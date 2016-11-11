# LightsOut
Small console application to play the game "LightsOut" on a "randomly" generated n x n grid

## Rules
The game is played on an 5x5 grid. Some cells are lit up (indicated by `#`). The goal is to switch all lights off. If you switch the state of a light, the horizontal and vertical neighbors also switch their state. (cf. [Wikipedia](https://en.wikipedia.org/wiki/Lights_Out_%28game%29))

## Usage
Start the game with `lua lightsout.lua n m` where `n` is the number of lines/rows and `m` is the random seed. Both of these parameters are optional.

Every round, the game asks for a line number and a row number. enter both and the corresponding lights get switched off/on. If you enter `q` instead of a number, the game will automatically solve the current situation. (The used algorithm is not optimal and doesn't always work.)

## Files
- `lightsout.lua`: The main file
- `patternTester.lua`: Creates tables of "last line patterns" and their corresponding "first line switches" to solve the puzzle by a second "chase the lights"
- `tables.lua`: Contains these tables

## Changes
- **1.1**: Square grids other than 5x5 are now possible to play and solve
- **1.0**: Initial release

## To-Do
- [x] Allow different field sizes
- [ ] Allow non-square fields
- [ ] Better way to encode puzzles (binary number of length n\*n converted to hex)
- [ ] GUI
