local input = require("lib.input")
local lines = input.lines("03day/real.txt")

local sum = 0 -- part 1 answer is the sum of the part numbers

local function find_part_num(index, position)
   local numbers = {}
   local line = lines[index]

   local x = 0
   while true do
      local j, k, num = string.find(line, "(%d+)", x)
      if not num then
         break
      end

      if j - 1 <= position and k + 1 >= position then
         table.insert(numbers, num)
      end

      x = k + 1
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
