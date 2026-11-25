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
-- four of a kind and five of a kind need some help
local function calc_rank(t)
   local r = 0
   for _, value in pairs(t) do
      if value == 31 then -- check for five of a kind
         return 12
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

-- Jacks are wild
-- Four of a kind (11) and full house (10) become five of kind (12)
-- three of a kind (9) becomes four of a kind (11)
-- two pair (7) becomes a full house (10), or four of a kind with two jacks (11)
-- a pair (6) becomes three of a kind (9)
-- a high card (5) becomes a pair (6)
local jacks_are_wild = {
   [12] = 12,
   [11] = 12,
   [10] = 12,
   [9] = 11,
   [7] = { [false] = 10, [true] = 11 },
   [6] = 9,
   [5] = 6,
}

for _, h in ipairs(hands) do
   local is_jack = false
   local is_two_jacks = false

   for c in string.gmatch(h.hand, ".") do
      if c == "J" and is_jack then
         is_two_jacks = true
      elseif c == "J" then
         is_jack = true
      end
   end

   local current_rank = h.rank
   if current_rank == 7 and is_jack then
      h.rank = jacks_are_wild[current_rank][is_two_jacks]
   elseif is_jack then
      h.rank = jacks_are_wild[current_rank]
   end

   print(h.hand, h.rank)
end

-- sort
local card_vals = {
   ["A"] = 14,
   ["K"] = 13,
   ["Q"] = 12,
   ["T"] = 10,
   ["9"] = 9,
   ["8"] = 8,
   ["7"] = 7,
   ["6"] = 6,
   ["5"] = 5,
   ["4"] = 4,
   ["3"] = 3,
   ["2"] = 2,
   ["J"] = 1, -- Jack now least valuable card
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
   print(hand.hand)
   total_winnings = total_winnings + rank * tonumber(hand.wager)
end

print("Part 2 total winnings = " .. total_winnings)
