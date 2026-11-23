local input = require("lib.input")

local almanac = input.lines("05day/real.txt")

-- Seeds - Part 1
local seeds = {}
for seed in string.gmatch(almanac[1], "(%d+)") do
   table.insert(seeds, tonumber(seed))
end

-- Maps
local maps = {}
local current = nil
for _, line in ipairs(almanac) do
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

-- for each seed, apply the maps and save the locations
local min_location = math.huge
for _, seed in ipairs(seeds) do
   local val = seed
   for _, map in ipairs(maps) do
      for _, range in ipairs(map.ranges) do
         if val >= range.source and val < (range.source + range.length) then
            local delta = range.destination - range.source
            val = val + delta
            break
         end
      end
   end
   if val < min_location then
      min_location = val
   end
end

print(min_location)
