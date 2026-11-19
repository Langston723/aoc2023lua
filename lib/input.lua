local M = {}

M.config = {
	input_dir = "01day",
	real_pattern = "input.txt",
	example_pattern = "example.txt",
}

local function read_file(path)
	local f, err = io.open(path, "r")
	if not f then
		error("Could not open input file: " .. path .. "\n" .. (err or ""))
	end
	local content = f:read("*a")
	f:close()

	if content:sub(-1) == "\n" then
		content = content:sub(1, -2)
	end
	return content
end

function M.read(path)
	return read_file(path)
end

function M.lines(path)
	local content = M.read(path)
	if content == "" then
		return {}
	end

	local result = {}
	for line in (content .. "\n"):gmatch("(.-)\n") do
		table.insert(result, line)
	end
	return result
end

return M
