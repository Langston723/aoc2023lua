local input = require("lib.input")
local lines = input.lines("02day/real.txt")

local red_max = 12
local green_max = 13
local blue_max = 14

local sum = 0
for _, line in ipairs(lines) do
   local game_id = string.match(line, "Game (%d+):")

   local isPossible = true
   for num, color in string.gmatch(line, "(%d+) (%w+)") do
      if color == "red" and tonumber(num) > red_max then
         isPossible = false
      elseif color == "green" and tonumber(num) > green_max then
         isPossible = false
      elseif color == "blue" and tonumber(num) > blue_max then
         isPossible = false
      end
   end

   if isPossible then
      sum = sum + tonumber(game_id)
   else
      print("Game id: " .. game_id .. " failed!")
   end
end

print("Part 1 = " .. sum)
