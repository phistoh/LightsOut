# LightsOut
Small console application to play the game "LightsOut" on a "randomly" generated 5x5 grid

## Rules
The game is played on an 5x5 grid. Some cells are lit up (indicated by `#`). The goal is to switch all lights off. If you switch the state of a light, the horizontal and vertical neighbors also switch their state. ([Wikipedia](https://en.wikipedia.org/wiki/Lights_Out_%28game%29))

## Usage
Every round, the game asks for a line number and a row number. enter both and the corresponding lights get switched off/on. If you enter `q` instead of a number, the game will automaticcaly solve the current situation. (The used algorithm is not optimal.)

## Changes
- **1.0**: Initial release

## To-Do
- [ ] Allow different field sizes
- [ ] GUI
