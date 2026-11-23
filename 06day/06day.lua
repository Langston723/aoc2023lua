local input = require("lib.input")
local lines = input.lines("06day/real.txt")

local times = {}
for t in string.gmatch(lines[1], "%d+") do
   times[#times + 1] = tonumber(t)
end

local distances = {}
for d in string.gmatch(lines[2], "%d+") do
   distances[#distances + 1] = tonumber(d)
end

assert(#times == #distances)

local races = {}
for i = 1, #times do
   races[#races + 1] = { time = times[i], distance = distances[i] }
end

-- Part 1
local product = 1
for _, race in ipairs(races) do
   local count = 0
   for speed = 1, race.time do
      local time_remaining = race.time - speed
      local current_dist = time_remaining * speed
      if current_dist > race.distance then
         count = count + 1
      end
   end
   product = product * count
end

print(product)
