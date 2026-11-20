local input = require("lib.input")
local lines = input.lines("02day/real.txt")

local max = { red = 12, green = 13, blue = 14 }

-- Part 1
-- Pattern matching ftw

local sum = 0
for _, line in ipairs(lines) do
   local game_id = string.match(line, "Game (%d+):")

   local isPossible = true
   for num, color in string.gmatch(line, "(%d+) (%w+)") do
      if color == "red" and tonumber(num) > max.red then
         isPossible = false
      elseif color == "green" and tonumber(num) > max.green then
         isPossible = false
      elseif color == "blue" and tonumber(num) > max.blue then
         isPossible = false
      end
   end

   if isPossible then
      sum = sum + tonumber(game_id)
   end
end

print("Part 1 = " .. sum)

-- Part 2
-- Same appraoch as Part 1 but tracking largest values

local sum_powers = 0
for _, line in ipairs(lines) do
   local largest = { red = 0, green = 0, blue = 0 }

   for n, color in string.gmatch(line, "(%d+) (%w+)") do
      local num = tonumber(n)
      if color == "red" and num > largest.red then
         largest.red = num
      elseif color == "green" and num > largest.green then
         largest.green = num
      elseif color == "blue" and num > largest.blue then
         largest.blue = num
      end
   end

   sum_powers = sum_powers + largest.blue * largest.green * largest.red
end

print("Part 2 = " .. sum_powers)
