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
	-- writes the field to the console
	
	-- first line
	io.write("\n    ")
	for i = 1, numRows do
		io.write(i.." ")
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
		io.write(" "..i.." |")
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
		-- clear the console
		os.execute("cls")
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
local function initField()
	math.randomseed(os.time())
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
				io.write(string.format("Switched (%i, %i)!\n", i, j))
				writeField()
				-- sleep
				local t0 = os.clock()
				while os.clock() - t0 <= 0.3 do
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
	
	-- if the field is not 5x5 -> abort
	if numLines ~= 5 or numRows ~= 5 then
		io.write(string.format("No table for a field of size %i x %i\n", numRows, numLines))
		return
	end
	
	-- switch some lights on the first rows (dependant on the last row)
	-- build a string out of the last row
	local lastRowString = ""
	for i=1, numRows do
		lastRowString = lastRowString..field[numLines][i]
	end
	
	-- only these patterns are solvable
	if lastRowString == "00111" then
		switch(1,4)
	elseif lastRowString == "01010" then
		switch(1,1)
		switch(1,4)
	elseif lastRowString == "01101" then
		switch(1,1)
	elseif lastRowString == "10001" then
		switch(1,1)
		switch(1,2)
	elseif lastRowString == "10110" then
		switch(1,5)
	elseif lastRowString == "11011" then
		switch(1,3)
	elseif lastRowString == "11100" then
		switch(1,2)
	elseif lastRowString == "00000" then
		-- victory
		return
	else
		io.write("Puzzle hat keine Lösung")
		return
	end
	
	-- chase the lights again
	chaseLights()
	
end


----------------------
-- main stuff
----------------------
-- traditional square field
numLines, numRows = 5, 5

-- io.write("Wie gross soll das Feld sein? (Zwischen 3 und 9 Feldern) ")
-- numRows = io.read("*number")

-- -- sets the number of rows to a valid value
-- if numRows < 3 then numRows = 3 end
-- if numRows > 9 then numRows = 9 end

-- io.write("Wie hoch soll das Feld sein? (Zwischen 3 und 9 Feldern) ")
-- numLines = io.read("*number")

-- -- sets the number of lines to a valid value
-- if numLines < 3 then numLines = 3 end
-- if numLines > 9 then numLines = 9 end

-- initialized the field
field = {}
for i = 1, numLines do
	field[i] = {}
	for j = 1, numRows do
		field[i][j] = 0
	end
end

-- stepcounter
step = 0

-- stores if the game was solved by the user
userSolved = true

initField()

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
	os.execute("cls")
	writeField()
end

if step == 1 then
	io.write("Gewonnen in einem Schritt!\n")
else
	io.write(string.format("Gewonnen in %i Schritten!\n", step))
end