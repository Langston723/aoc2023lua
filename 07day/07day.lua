--[[
-- Gosh, what a mess. I decided to use Bit Math after reading
-- "Evaluating Poker Hands with Bit Math" Jonathan Hsiao but that really
-- created a bunch of extra work that probably could have been accomplished
-- with a simple counter... but it worked.
-- 
-- Needed to account for five of a kind, simply by look for 0b11111
-- Slightly annoying that four of kind provides a rank of 1
--]]

local input = require("lib.input")
local lines = input.lines("07day/real.txt")

-- this table is going to hold the bit representation of a hand
local function build_rank_bits()
   local t = {}
   local ranks = { "A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2" }
   local mask = 0
   for _, r in ipairs(ranks) do
      t[r] = mask
   end
   return t
end

-- ranks from the combined bit field and a magic mod 15
-- four of a kind and fuve of a kind need some help
local function calc_rank(t)
   local r = 0
   for _, value in pairs(t) do
      if value == 31 then -- check for five of a kind
         return 13
      end
      r = (r << 4) | value
   end
   return (r % 15) == 1 and 11 or (r % 15) -- 15 is a magic number, four of a kind?
end

-- parse hands from lines
local hands = {}
for _, line in ipairs(lines) do
   local h = string.match(line, "^(%w+)%s")
   local w = string.match(line, "(%d+)$")
   table.insert(hands, { hand = h, wager = w, rank = nil })
end

-- rank
for _, h in ipairs(hands) do
   local rank_bits = build_rank_bits()
   for c in string.gmatch(h.hand, ".") do
      local bit = rank_bits[c]
      bit = (bit << 1) | 1
      rank_bits[c] = bit
   end
   h.rank = calc_rank(rank_bits)
end

-- sort
local card_vals = {
   ["A"] = 14,
   ["K"] = 13,
   ["Q"] = 12,
   ["J"] = 11,
   ["T"] = 10,
   ["9"] = 9,
   ["8"] = 8,
   ["7"] = 7,
   ["6"] = 6,
   ["5"] = 5,
   ["4"] = 4,
   ["3"] = 3,
   ["2"] = 2,
}
table.sort(hands, function(a, b)
   if a.rank ~= b.rank then
      return a.rank < b.rank
   else
      for i = 1, 5 do
         local card_a = card_vals[string.sub(a.hand, i, i)]
         local card_b = card_vals[string.sub(b.hand, i, i)]
         if card_a ~= card_b then
            return card_a < card_b
         end
      end
      return false -- we shouldn't get here
   end
end)

-- get the result
local total_winnings = 0
for rank, hand in ipairs(hands) do
   total_winnings = total_winnings + rank * tonumber(hand.wager)
end

print("Part 1 Total Winnings = " .. total_winnings)
