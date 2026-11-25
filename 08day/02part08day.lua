local input = require("lib.input")
local lcm = require("lib.lcm")

local lines = input.lines("08day/real.txt")
local turns = { ["L"] = 1, ["R"] = 2 }
local instructions = lines[1]

local nodes = {}
for i = 3, #lines do
   local name, left, right = string.match(lines[i], "^(%w+)%s*=%s*%((%w+),%s*(%w+)%)")
   nodes[name] = { left, right }
end

-- find all the starting positions
local locs = {}
for key, _ in pairs(nodes) do
   local start = string.match(key, "(%w+A)$")
   if start then
      table.insert(locs, start)
   end
end

--change of plans, need to calculate LCM?
local periods = {}
for i, loc in ipairs(locs) do
   local num_steps = 0
   local is_running = true
   while is_running do
      for step in string.gmatch(instructions, ".") do
         num_steps = num_steps + 1
         loc = nodes[loc][turns[step]]
         if loc:match("Z$") then
            table.insert(periods, num_steps)
            is_running = false
            break
         end
      end
   end
end

print("Part 2 = " .. lcm.lcm_many(table.unpack(periods)))
