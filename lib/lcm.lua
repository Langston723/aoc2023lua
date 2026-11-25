-- lcm.lua
local M = {}

-- Greatest Common Divisor (Euclidean algorithm)
function M.gcd(a, b)
   a, b = math.abs(a), math.abs(b)
   while b ~= 0 do
      a, b = b, a % b
   end
   return a
end

-- Least Common Multiple of two numbers
function M.lcm(a, b)
   if a == 0 or b == 0 then
      return 0
   end
   return math.abs(a * b) // M.gcd(a, b)
end

-- LCM of any number of values
function M.lcm_many(...)
   local args = { ... }
   if #args == 0 then
      return 0
   end

   local result = args[1]
   for i = 2, #args do
      result = M.lcm(result, args[i])
   end
   return result
end

return M
