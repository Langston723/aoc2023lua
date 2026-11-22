local input = require("lib.input")
local lines = input.lines("04day/real.txt")

local colon = string.find(lines[1], ":")
local pipe = string.find(lines[1], "|")

local sum_scores = 0 -- part 1 answer

for _, line in ipairs(lines) do
   -- get winners
   local winners = {}
   local start = colon
   while true do
      local _, e, num = string.find(line, " (%d+)", start)
      if not num then
         break
      end

      winners[num] = true

      start = e + 1

      if start >= pipe - 1 then
         break
      end
   end

   -- get numbers
   local numbers = {}
   start = pipe
   while true do
      local _, e, num = string.find(line, " (%d+)", start)
      if not num then
         break
      end
      table.insert(numbers, num)
      start = e + 1
   end

   -- compare numbers against winners
   local score = 0
   for _, num in ipairs(numbers) do
      if winners[num] then
         score = score ~= 0 and score * 2 or 1
      end
   end
   sum_scores = sum_scores + score
end

print("Part 1 = " .. sum_scores)
