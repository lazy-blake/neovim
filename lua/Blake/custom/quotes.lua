local M = {}

function M.get_random_quote()
	-- Get the directory of the current file (quotes.lua)
	local dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
	local filepath = dir .. "quotes.txt"

	local file, err = io.open(filepath, "r")
	if not file then
		return "No quotes found. Error: " .. (err or "unknown")
	end

	local quotes = {}
	for line in file:lines() do
		if line:match("%S") then -- skip empty lines
			table.insert(quotes, line)
		end
	end
	file:close()

	if #quotes == 0 then
		return "No quotes available in file."
	end

	math.randomseed(os.time())
	return quotes[math.random(#quotes)]
end

return M
