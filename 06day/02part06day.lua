local input = require("lib.input")
local lines = input.lines("06day/real.txt")

local time_str = ""
for t in string.gmatch(lines[1], "%d+") do
   time_str = time_str .. t
end

local distance_str = ""
for d in string.gmatch(lines[2], "%d+") do
   distance_str = distance_str .. d
end

local time, distance = tonumber(time_str), tonumber(distance_str)

local count = 0
for speed = 1, time do
   local remaining_time = time - speed
   local current_dist = remaining_time * speed
   if current_dist > distance then
      count = count + 1
   end
end

print("Part 2 result = " .. count)
