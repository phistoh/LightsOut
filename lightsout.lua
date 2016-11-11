-- get the tables
require("tables")

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

-- prints the field to the console
local function writeField()
	
	-- clears the screen
	os.execute("cls")
	
	-- first line
	io.write("\n    ")
	for i = 1, numRows do
		io.write(string.format("%x ",i))
	end
	io.write("\n")
	
	-- second line
	io.write("   +")
	for i = 1, numRows do
		io.write("-+")
	end
	io.write("\n")
	
	-- lines 3 to 2*(n + 1)
	for i = 1, numLines do
		io.write(string.format(" %x |",i))
		for j=1,numRows do
			if field[i][j] == 1 then
				io.write("#")
			else
				io.write(" ")
			end
			io.write("|")
		end
		io.write("\n")
		io.write("   +")
		for i = 1, numRows do
			io.write("-+")
		end
		io.write("\n")
	end
	-- last linebreak
	io.write("\n")
end

-- gets two variables via user input
-- doesnt allow "out-of-bounds-variables"
local function getInput()
	local x, y = 0, 0
	local autoSolve = false
	-- while the input is not valid...
	while x < 1 or y < 1 or x > numLines or y > numRows do
		-- print the field
		writeField()
		-- get user input for line number
		io.write("Bitte Zeile eingeben (oder mit \'q\' aufgeben): ")
		x = io.read()
		-- break the loop if the user wants to give up
		if x == "q" then
			autoSolve = true
			break
		end
		-- convert the input to a number
		-- if not possible, use "0" as the value
		x = tonumber(x)
		if x == nil then
			x = 0
		end
		-- get user input for row number
		io.write("Bitte Spalte eingeben (oder mit \'q\' aufgeben): ")
		y = io.read()
		-- break the loop if the user wants to give up
		if y == "q" then
			autoSolve = true
			break
		end
		-- convert the input to a number
		-- if not possible, use "0" as the value
		y = tonumber(y)
		if y == nil then
			y = 0
		end
	end
	return x, y, autoSolve
end

-- multiplies all entries in the field and returns the product
-- as long as there is a 0 in the field, the product will be zero
-- if every entry is 1, then the product will be 1
local function checkWin()
	local product = 1
	for i = 1, numLines do
		for j = 1, numRows do
			-- use 1 - field[i][j] because the game is won if all lights are off (-> all entries are 0)
			product = product * (1 - field[i][j])
		end
	end
	return product
end

-- performs random switches on the initial empty field
local function initField(seed)
	for i = 1, numLines do
		field[i] = {}
		for j = 1, numRows do
			field[i][j] = 0
		end
	end
	math.randomseed(seed)
	for i = 1, numLines do
		for j = 1, numRows do
			if math.random() > 0.5 then
				switch(i,j)
			end
		end
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
				step = step + 1
				writeField()
				-- sleep
				local t0 = os.clock()
				while os.clock() - t0 <= 0.15 do
					-- nop
				end
			end
		end
	end
	
end

-- solves the puzzle
local function solve()
	-- chasing the lights
	-- switch (x, y) if (x - 1, y) is lit
	chaseLights()
	
	-- switch some lights on the first rows (dependant on the last row)
	-- build a string out of the last row
	local lastRowString = ""
	for i=1, numRows do
		lastRowString = lastRowString..field[numLines][i]
	end
	
	-- test if the string is "0...0"
	if lastRowString == string.rep("0",numRows) then
		return
	end
	
	-- get the current table
	solutions = _G["table_"..numLines]
	if solutions == nil then
		io.write(string.format("Keine Tabelle für %i x %i vorhanden!",numLines,numLines))
		return
	end
	
	-- test if the string is not in the table
	if solutions[lastRowString] == nil then
		solvable = false
		return
	end
	
	-- to get the current position in the string
	local pos = 1
	
	-- iterates over all chars in the string
	for c in solutions[lastRowString]:gmatch(".") do
		-- switch the light corresponding to the string
		if tonumber(c) == 1 then
			switch(1,pos)
		end
	pos = pos+1
	end
	
	-- chase the lights again
	chaseLights()
	
end


----------------------
-- main stuff
----------------------
-- default values
numLines = 5
seed = os.time()

-- is the first argument was given
if tonumber(arg[1]) ~= nil then
	numLines = tonumber(arg[1])
end

-- is the second argument was given
if tonumber(arg[2]) ~= nil then
	seed = tonumber(arg[2])
end

-- make a square field
numRows = numLines

-- initialized the field
field = {}

-- stepcounter
step = 0

-- stores if the game was solved by the user
userSolved = true

-- stores if the game is solvable
solvable = true

-- get the current time as a seed for initField()
initField(seed)


-- main loop
while checkWin() == 0 do
	local x, y, autoSolve = getInput()
	
	if autoSolve == true then
		solve()
		userSolved = false
		break
	end
	switch(x, y)
	step = step+1
end

--victory
if userSolved == true then 
	writeField()
end

if solvable then
	if step == 1 then
		io.write("Gewonnen in einem Schritt!\n")
	else
		io.write(string.format("Gewonnen in %i Schritten!\n", step))
	end
else
	initField(seed)
	writeField()
	io.write(string.format("Puzzle %i ist nicht mit \"chase-the-lights\" lösbar.", seed))
end