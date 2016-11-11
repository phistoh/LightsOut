-- switches the state a given entry and its neighbors
local function switch(x, y)
	-- invert the given entry
	field[x][y] = 1 - field[x][y]
	-- if there is a neighbor above, switch it
	if x > 1 then
		field[x-1][y] = 1 - field[x-1][y]
	end
	-- if there is a neighbor below
	if x < numLines then
		field[x+1][y] = 1 - field[x+1][y]
	end
	-- if there is a neighbor to the left
	if y > 1 then
		field[x][y-1] = 1 - field[x][y-1]
	end
	-- if there is a neighbor to the right
	if y < numRows then
		field[x][y+1] = 1 - field[x][y+1]
	end
end

-- part of solving an instance
local function chaseLights()
	-- chasing the lights
	-- switch (x, y) if (x - 1, y) is lit

	for i = 2, numLines do
		for j = 1, numRows do
			if field[i-1][j] == 1 then
				switch(i, j)
			end
		end
	end
	
end

local function testPattern(firstLine)
	-- to get the current position in the string
	local pos = 1
	
	-- iterates over all chars in the string
	for c in firstLine:gmatch(".") do
		-- switch the light corresponding to the string
		if tonumber(c) == 1 then
			switch(1,pos)
		end
	pos = pos+1
	end
	
	-- chase the lights to see, which lights in the last line are affected
	chaseLights()

	-- get string of the last line
	local lastLine = ""
	for i = 1, numRows do
		lastLine = lastLine..field[numLines][i]
	end
	
	return lastLine
end

-- increments a binary number (given as string)
local function increment(binString)
	-- test if the string is already "11...11" and if true, do nothing
	-- if there is no other character than "1" in the string
	if binString:find("[^1]") == nil then
		return binString
	end

	-- stores the current position in the string
	local pos = #binString
	
	-- searches the first "0" (from the end) and switches every "1" to "0"
	while binString:sub(pos,pos) ~= "0" do
		binString = binString:sub(1,pos-1).."0"..binString:sub(pos+1)
		pos = pos - 1
	end
	
	-- replace the "0" by a "1"
	binString = binString:sub(1,pos-1).."1"..binString:sub(pos+1)
	
	return binString
end

local function patternTest(size)
	-- default size
	numLines = size

	-- traditional square field
	numRows = numLines

	-- initialized the field
	field = {}
	for i = 1, numLines do
		field[i] = {}
		for j = 1, numRows do
			field[i][j] = 0
		end
	end


	-- Test patterns
	-- give switches in first line (as string)
	-- lastLine -> firstLine gets stored in table

	-- init empty table
	local patternPairs = {}

	-- generates a string "00...00" of length numRows
	local firstLine = string.rep("0",numRows)

	-- as long as the string is not "11...11"
	while firstLine ~= string.rep("1",numRows) do
		-- increment the string (because we don't need to test "00...00")
		firstLine = increment(firstLine)
		-- test the pattern
		local lastLine = testPattern(firstLine)
		-- put it in the table
		patternPairs[lastLine] = firstLine
	end

	-- remove the entry for "00...00" in the last line because the game is already won
	patternPairs[string.rep("0",numRows)] = nil

	-- temp String to write to file
	local tmpString = ""

	-- iterate over table and print every key-value-pair and write it as a lua_table
	tmpString = tmpString..string.format("table_%i = {\n",numLines)
	for k,v in pairs(patternPairs) do
		tmpString = tmpString..string.format("\t[%q] = %q,\n", k, v)
	end
	tmpString = tmpString.."}\n\n"

	-- open a file
	local file = io.open("tables.lua", "a")
	file:write(tmpString)
	io.close(file)
end


----------------------
-- main stuff
----------------------
-- max size
maxSize = 5

-- is an argument was given
if tonumber(arg[1]) ~= nil then
	maxSize = tonumber(arg[1])
end

-- create a new file
local file = io.open("tables.lua", "w")
file:write("")
io.close(file)

-- get the starting time
local start = os.clock()

-- test the patterns
for i = 1, maxSize do
	patternTest(i)
	io.write(string.format("Table %i complete.\n", i))
end

-- get the elapsed time
local elapsedTime = os.clock() - start
io.write(string.format("%i tables created in %.2f seconds.", maxSize, elapsedTime))