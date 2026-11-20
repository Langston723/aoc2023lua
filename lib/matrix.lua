-- ============================================================
-- Matrix / Grid utilities (created by Grok)
-- ============================================================

local function inBounds(r, c, rows, cols)
   return 1 <= r and r <= rows and 1 <= c and c <= cols
end

-- 4-directional neighbors (N, E, S, W)
local DIRS4 = {
   { -1, 0 },
   { 0, 1 },
   { 1, 0 },
   { 0, -1 },
}

-- 8-directional neighbors (includes diagonals)
local DIRS8 = {
   { -1, 0 },
   { -1, 1 },
   { 0, 1 },
   { 1, 1 },
   { 1, 0 },
   { 1, -1 },
   { 0, -1 },
   { -1, -1 },
}

--- Returns a list of valid neighbor coordinates
-- @param r, c   current position
-- @param rows, cols  grid dimensions
-- @param dirs   optional direction table (defaults to DIRS4)
local function neighbors(r, c, rows, cols, dirs)
   dirs = dirs or DIRS4
   local result = {}
   for _, d in ipairs(dirs) do
      local nr, nc = r + d[1], c + d[2]
      if inBounds(nr, nc, rows, cols) then
         result[#result + 1] = { nr, nc }
      end
   end
   return result
end

--- Safe get – returns nil (or a default) when out of bounds
local function get(grid, r, c, default)
   if not grid or not grid[r] then
      return default
   end
   return grid[r][c] ~= nil and grid[r][c] or default
end

--- Safe set – only writes when in bounds
local function set(grid, r, c, value)
   if grid and grid[r] then
      grid[r][c] = value
   end
end

--- Create a rows × cols matrix filled with `fill` (default 0)
local function make(rows, cols, fill)
   fill = fill or 0
   local g = {}
   for r = 1, rows do
      g[r] = {}
      for c = 1, cols do
         g[r][c] = fill
      end
   end
   return g
end

--- Deep copy a matrix
local function copy(grid)
   local rows = #grid
   local cols = #grid[1]
   local g = make(rows, cols)
   for r = 1, rows do
      for c = 1, cols do
         g[r][c] = grid[r][c]
      end
   end
   return g
end

--- Iterate every cell: yield (r, c, value)
local function each(grid)
   return coroutine.wrap(function()
      for r = 1, #grid do
         for c = 1, #grid[r] do
            coroutine.yield(r, c, grid[r][c])
         end
      end
   end)
end

--- Pretty-print a matrix (handy for debugging)
local function printGrid(grid, sep)
   sep = sep or ""
   for r = 1, #grid do
      local row = {}
      for c = 1, #grid[r] do
         row[#row + 1] = tostring(grid[r][c])
      end
      print(table.concat(row, sep))
   end
end

-- ============================================================
-- Convenience aliases / exports
-- ============================================================
return {
   inBounds = inBounds,
   neighbors = neighbors,
   DIRS4 = DIRS4,
   DIRS8 = DIRS8,
   get = get,
   set = set,
   make = make,
   copy = copy,
   each = each,
   printGrid = printGrid,
}
