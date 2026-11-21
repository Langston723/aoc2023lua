local input = require("lib.input")
local lines = input.lines("03day/real.txt")

local sum = 0 -- part 1 answer is the sum of the part numbers

local function find_part_num(index, position)
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
   local pos = 1
   while true do
      local i, _, sym = string.find(line, "([^%w%s%.])", pos)
      if not sym then
         break
      end

      -- check current line
      local nums = find_part_num(line_number, i)
      for _, num in ipairs(nums) do
         sum = sum + num
      end

      -- check previous line
      if line_number - 1 > 0 then
         nums = find_part_num(line_number - 1, i)
         for _, num in ipairs(nums) do
            sum = sum + num
         end
      end

      -- check next row
      if line_number + 1 <= #lines then
         nums = find_part_num(line_number + 1, i)
         for _, num in ipairs(nums) do
            sum = sum + num
         end
      end

      pos = i + 1
   end
end

print("Part 1 = " .. sum)

-- Part 2
-- Fewer symbols to search for
-- and just need to make sure that #numbers == 2
sum = 0

for line_number, line in ipairs(lines) do
   local pos = 1
   while true do
      local i, _, sym = string.find(line, "(*)", pos)
      if not sym then
         break
      end

      -- check current line
      local part_numbers = find_part_num(line_number, i)

      -- check previous line
      if line_number - 1 > 0 then
         local previous_numbers = find_part_num(line_number - 1, i)
         for _, number in ipairs(previous_numbers) do
            table.insert(part_numbers, number)
         end
      end

      -- check next row
      if line_number + 1 <= #lines then
         local next_numbers = find_part_num(line_number + 1, i)
         for _, number in ipairs(next_numbers) do
            table.insert(part_numbers, number)
         end
      end

      if #part_numbers == 2 then
         sum = sum + part_numbers[1] * part_numbers[2]
      end

      pos = i + 1
   end
end

print("Part 2 = " .. sum)
