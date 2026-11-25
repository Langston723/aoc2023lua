local input = require("lib.input")
local lines = input.lines("08day/real.txt")

local turns = { ["L"] = 1, ["R"] = 2 }

local instructions = lines[1]

local nodes = {}
for i = 3, #lines do
   local name, left, right = string.match(lines[i], "^(%w+)%s*=%s*%((%w+),%s*(%w+)%)")
   nodes[name] = { left, right }
end

local loc = "AAA"
local num_steps = 0
local is_running = true

while is_running do
   for step in string.gmatch(instructions, ".") do
      num_steps = num_steps + 1
      loc = nodes[loc][turns[step]]
      if loc == "ZZZ" then
         is_running = false
         break
      end
   end
end

print("Part 1 number of steps = " .. num_steps)
