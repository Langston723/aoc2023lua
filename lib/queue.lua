-- queue.lua
local Queue = {}
Queue.__index = Queue

function Queue.new()
   return setmetatable({
      first = 1,
      last = 0,
      data = {},
   }, Queue)
end

function Queue:push(value)
   self.last = self.last + 1
   self.data[self.last] = value
end

function Queue:pop()
   if self:empty() then
      return nil
   end
   local value = self.data[self.first]
   self.data[self.first] = nil -- allow garbage collection
   self.first = self.first + 1
   return value
end

function Queue:peek()
   if self:empty() then
      return nil
   end
   return self.data[self.first]
end

function Queue:empty()
   return self.first > self.last
end

function Queue:size()
   return self.last - self.first + 1
end

function Queue:clear()
   self.first = 1
   self.last = 0
   self.data = {}
end

return Queue
