local input = require("lib.input")
local lines = input.lines("03day/real.txt")

local sum = 0 -- part 1 answer is the sum of the part numbers

local function find_part_numbers(index, position)
   local numbers = {}
   local line = lines[index]
   local start = 1

   while true do
      local j, k, num = string.find(line, "(%d+)", start)
      if not num then
         break
      end

      if j - 1 <= position and k + 1 >= position then
         table.insert(numbers, num)
      end

      start = k + 1
   end

   return numbers
end

for line_number, line in ipairs(lines) do
   local start = 1
   while true do
      local pos, _, symbol = string.find(line, "([^%w%s%.])", start)
      if not symbol then
         break
      end

      -- check previous, current, and next lines
      for i = -1, 1 do
         if line_number + i > 0 and line_number + i <= #lines then
            local nums = find_part_numbers(line_number + i, pos)
            for _, num in ipairs(nums) do
               sum = sum + num
            end
         end
      end

      start = pos + 1
   end
end

print("Part 1 = " .. sum)

-- Part 2
-- Fewer symbols to search for
-- and just need to make sure that #numbers == 2
sum = 0

for line_number, line in ipairs(lines) do
   local start = 1
   while true do
      local position, _, sym = string.find(line, "(*)", start)
      if not sym then
         break
      end

      local part_numbers = {}

      -- check previous, current, and last
      for i = -1, 1 do
         if line_number + i > 0 and line_number + i <= #lines then
            local temp = find_part_numbers(line_number + i, position)
            for _, number in ipairs(temp) do
               table.insert(part_numbers, number)
            end
         end
      end

      if #part_numbers == 2 then
         sum = sum + part_numbers[1] * part_numbers[2]
      end

      start = position + 1
   end
end

print("Part 2 = " .. sum)
