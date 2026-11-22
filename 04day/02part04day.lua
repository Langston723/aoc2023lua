local input = require("lib.input")

local cards = input.lines("04day/real.txt")

local colon = string.find(cards[1], ":")
local pipe = string.find(cards[1], "|")

-- Part 2; calculate the matches and the count the copies
local matches = {}
for i, card in ipairs(cards) do
   -- get winners
   local winners = {}
   local start = colon
   while true do
      local _, e, num = string.find(card, " (%d+)", start)
      if not num or start >= pipe - 1 then
         break
      end
      winners[num] = true
      start = e + 1
   end

   -- get numbers, and count matches
   local count = 0
   start = pipe
   while true do
      local _, e, num = string.find(card, " (%d+)", start)
      if not num then
         break
      end
      if winners[num] then
         count = count + 1
      end
      start = e + 1
   end
   matches[i] = count
end

-- now count the copies
-- original stack
local copies = {}
for i = 1, #cards do
   copies[i] = 1
end
-- copies
for i = 1, #cards do
   local m = matches[i]
   for j = 1, m do
      copies[i + j] = copies[i + j] + copies[i]
   end
end

local total = 0
for i = 1, #cards do
   total = total + copies[i]
end

print("Part 2 = " .. total)
