local input = require("lib.input")
local lines = input.lines("01day/real.txt")

-- Part 1
local result = 0
for _, line in ipairs(lines) do
   local left = line:match("^%a*(%d)")
   local right = line:match("(%d)%a*$")
   result = result + tonumber(left .. right)
end
print("Part 1 = " .. result)

-- Part 2
local number_words = {
   "one",
   "two",
   "three",
   "four",
   "five",
   "six",
   "seven",
   "eight",
   "nine",
}

for i, word in ipairs(number_words) do
   number_words[word] = tostring(i)
end

local function find_num_word(s)
   local first = { number = nil, position = nil }
   local last = { number = nil, position = nil }

   for _, word in ipairs(number_words) do
      local start = 1
      while true do
         local current_position = s:find(word, start)

         if not current_position then
            break
         end

         if not first.position or current_position < first.position then
            first.position = current_position
            first.number = number_words[word]
         end

         if not last.position or current_position > last.position then
            last.position = current_position
            last.number = number_words[word]
         end

         start = current_position + 1
      end
   end

   return first, last
end

result = 0
for _, line in ipairs(lines) do
   local first, last = find_num_word(line)
   local _, i, left = line:find("^%a*(%d)")
   local j, _, right = line:find("(%d)%a*$")

   local leftmost
   if not i or (first.number and first.position < i) then
      leftmost = first.number
   else
      leftmost = left
   end

   local rightmost
   if not j or (last.number and last.position > j) then
      rightmost = last.number
   else
      rightmost = right
   end

   result = result + tonumber(leftmost .. rightmost)
end

print("Part 2 = " .. result)
