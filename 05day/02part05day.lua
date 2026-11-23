local input = require("lib.input")
local Queue = require("lib.queue")

local lines = input.lines("05day/real.txt")

-- get seed ranges
local q = Queue.new()
for start, len in string.gmatch(lines[1], "(%d+)%s+(%d+)") do
   local current = { start = tonumber(start), finish = (tonumber(start) + tonumber(len) - 1) }
   q:push(current)
end

-- Maps
local maps = {}
local current = nil
for _, line in ipairs(lines) do
   if string.match(line, "map") then
      current = { ranges = {} }
      maps[#maps + 1] = current
   elseif current and string.match(line, "%d") then
      local dest, src, len = string.match(line, "^%s*(%d+)%s+(%d+)%s+(%d+)%s*$")
      if dest then
         table.insert(current.ranges, {
            destination = tonumber(dest),
            source = tonumber(src),
            length = tonumber(len),
         })
      end
   elseif string.match(line, "^%s*$") then
      current = nil
   end
end

-- Apply maps to ranges
local min_location = math.huge

for _, current_map in ipairs(maps) do
   local next_sources = {}

   while not q:empty() do
      local source = q:pop()
      local isMatched = false

      for _, range in ipairs(current_map.ranges) do
         local source_end = range.source + range.length - 1
         local overlap_start = math.max(source.start, range.source)
         local overlap_end = math.min(source.finish, source_end)

         if overlap_start <= overlap_end then
            isMatched = true
            local offset = range.destination - range.source

            -- mapped overlapping part
            table.insert(next_sources, {
               start = overlap_start + offset,
               finish = overlap_end + offset,
            })

            -- leftover before the start
            if source.start < overlap_start then
               q:push({ start = source.start, finish = overlap_start - 1 })
            end

            -- leftover after the end
            if source.finish > overlap_end then
               q:push({ start = overlap_end + 1, finish = source.finish })
            end

            break
         end
      end

      -- identity mapping
      if not isMatched then
         table.insert(next_sources, source)
      end
   end

   for _, r in ipairs(next_sources) do
      q:push(r)
   end
end

-- final answer
while not q:empty() do
   local r = q:pop()
   if r.start < min_location then
      min_location = r.start
   end
end

print(min_location)
