--[[
  counter.lua – A Counter class inspired by Python's collections.Counter

  Usage:
    local Counter = require("counter")

    local c = Counter{"a", "b", "a", "c", "a"}   -- from sequence
    local c = Counter{a = 2, b = 1}             -- from map
    local c = Counter()                         -- empty

    print(c.a)          --> 3
    print(c["b"])       --> 1

    c:update{"a", "x"}
    c:subtract{"a"}
    c:add("y", 5)       -- alias for update with counts

    for item, count in pairs(c) do ... end
    for item in c:elements() do ... end

    local top = c:most_common(2)   -- {{"a", 3}, {"y", 5}, ...}
    print(c:total())
    local d = c:copy()
    c:clear()
]]

local Counter = {}
Counter.__index = Counter

-- Internal helper: normalize input into a count table
local function to_counts(src)
  local counts = {}
  if src == nil then
    return counts
  end

  -- If it looks like a sequence (array part present and no string keys that look like counts)
  local is_sequence = true
  local n = 0
  for k, v in pairs(src) do
    n = n + 1
    if type(k) ~= "number" or k < 1 or k ~= math.floor(k) then
      is_sequence = false
      break
    end
  end

  if is_sequence and n > 0 then
    for _, item in ipairs(src) do
      counts[item] = (counts[item] or 0) + 1
    end
  else
    -- Treat as mapping item -> count
    for item, count in pairs(src) do
      local c = tonumber(count) or 0
      if c ~= 0 then
        counts[item] = c
      end
    end
  end
  return counts
end

--- Create a new Counter.
-- @param init table|nil  Sequence of items or map of item→count
-- @return Counter
function Counter.new(init)
  local self = setmetatable({}, Counter)
  self._counts = to_counts(init)
  return self
end

-- Allow Counter(...) as constructor
setmetatable(Counter, {
  __call = function(_, init)
    return Counter.new(init)
  end
})

--- Get the count of an item (0 if missing).
function Counter:get(item)
  return self._counts[item] or 0
end

--- Set the count of an item. Setting to 0 or negative removes it.
function Counter:set(item, count)
  count = tonumber(count) or 0
  if count > 0 then
    self._counts[item] = count
  else
    self._counts[item] = nil
  end
  return self
end

--- Add (or subtract if negative) a value to an item's count.
function Counter:add(item, n)
  n = n or 1
  local new = (self._counts[item] or 0) + n
  if new > 0 then
    self._counts[item] = new
  else
    self._counts[item] = nil
  end
  return self
end

--- Update counts from another Counter, sequence, or map.
-- Positive counts are added.
function Counter:update(other)
  local add = to_counts(other)
  for item, n in pairs(add) do
    self:add(item, n)
  end
  return self
end

--- Subtract counts (Python Counter.subtract).
-- Counts may go to zero / be removed; negative results become zero.
function Counter:subtract(other)
  local sub = to_counts(other)
  for item, n in pairs(sub) do
    self:add(item, -n)
  end
  return self
end

--- Return a list of the n most common elements and their counts.
-- Sorted by count descending, then by first-seen order (stable via insertion).
-- @param n number|nil  If nil, return all.
-- @return {{item, count}, ...}
function Counter:most_common(n)
  local items = {}
  for item, count in pairs(self._counts) do
    items[#items + 1] = {item, count}
  end
  table.sort(items, function(a, b)
    if a[2] ~= b[2] then
      return a[2] > b[2]
    end
    -- stable-ish fallback: compare string representation
    return tostring(a[1]) < tostring(b[1])
  end)
  if n and n < #items then
    local result = {}
    for i = 1, n do
      result[i] = items[i]
    end
    return result
  end
  return items
end

--- Iterator that yields each element repeated by its count.
-- Example: for x in c:elements() do ... end
function Counter:elements()
  local items = {}
  for item, count in pairs(self._counts) do
    for _ = 1, count do
      items[#items + 1] = item
    end
  end
  local i = 0
  return function()
    i = i + 1
    return items[i]
  end
end

--- Total of all counts.
function Counter:total()
  local sum = 0
  for _, c in pairs(self._counts) do
    sum = sum + c
  end
  return sum
end

--- Number of distinct elements that have a positive count.
function Counter:__len()
  local n = 0
  for _ in pairs(self._counts) do
    n = n + 1
  end
  return n
end

--- Shallow copy.
function Counter:copy()
  local c = Counter.new()
  for k, v in pairs(self._counts) do
    c._counts[k] = v
  end
  return c
end

--- Remove all elements.
function Counter:clear()
  self._counts = {}
  return self
end

--- Return a new Counter with only elements that appear in both,
-- taking the minimum count (Python Counter intersection).
function Counter:__band(other)  -- & operator (Lua 5.3+)
  local result = Counter.new()
  local o = other._counts or to_counts(other)
  for item, count in pairs(self._counts) do
    local oc = o[item]
    if oc then
      local m = math.min(count, oc)
      if m > 0 then
        result._counts[item] = m
      end
    end
  end
  return result
end

--- Union: take the maximum count for each element.
function Counter:__bor(other)  -- | operator
  local result = self:copy()
  local o = other._counts or to_counts(other)
  for item, count in pairs(o) do
    local cur = result._counts[item] or 0
    if count > cur then
      result._counts[item] = count
    end
  end
  return result
end

--- Addition: sum of counts.
function Counter:__add(other)
  local result = self:copy()
  result:update(other)
  return result
end

--- Subtraction: subtract counts (floor at 0).
function Counter:__sub(other)
  local result = self:copy()
  result:subtract(other)
  return result
end

--- Equality.
function Counter:__eq(other)
  if getmetatable(other) ~= Counter then
    return false
  end
  for k, v in pairs(self._counts) do
    if (other._counts[k] or 0) ~= v then
      return false
    end
  end
  for k, v in pairs(other._counts) do
    if (self._counts[k] or 0) ~= v then
      return false
    end
  end
  return true
end

--- String representation.
function Counter:__tostring()
  local parts = {}
  for item, count in pairs(self._counts) do
    parts[#parts + 1] = string.format("%s=%s", tostring(item), tostring(count))
  end
  table.sort(parts)
  return "Counter{" .. table.concat(parts, ", ") .. "}"
end

-- Make the Counter itself act like a table for reading/writing counts
function Counter:__index(key)
  -- Methods first
  local method = rawget(Counter, key)
  if method ~= nil then
    return method
  end
  -- Otherwise treat as count lookup
  return self._counts[key] or 0
end

function Counter:__newindex(key, value)
  -- Protect internal state
  if key == "_counts" then
    rawset(self, key, value)
    return
  end
  self:set(key, value)
end

-- pairs() support so `for k,v in pairs(c)` works
function Counter:__pairs()
  return next, self._counts, nil
end

return Counter
