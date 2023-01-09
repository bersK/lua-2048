require("tile")
require("movement")
local serialize = require("lib/ser")

Grid = {}
Grid.__index = Grid

-- Create a grid object and return
function Grid.new()
    local o = setmetatable({
        size = 4,
        tiles = {},
        grid = {},
        gameWon = false,
        currentScore = 0,
        bestScore = 0
    }, Grid)
    -- Populate the grid with tiles
    for x = 1, o.size, 1 do
        o.tiles[x] = {}
        for y = 1, o.size, 1 do
            o.grid[x][y] = 0
            o.tiles[x][y] = Tile.new(0, {x = x, y = y})
        end
    end

    o:loadScore()
    o:generateStartingGrid()
    return o
end

-- Check if coordinates are within the grid and returns a bool
function Grid:withinBounds(position)
    return position.x >= 1 and position.x <= self.size and
           position.y >= 1 and position.y <= self.size
end

-- Reset all tiles to be the value 0 (blanks)
function Grid:resetGrid()
    self:saveScore()
    self.currentScore = 0
    for x = 1, self.size, 1 do
        self.tiles[x] = {}
        for y = 1, self.size, 1 do
            self.tiles[x][y] = Tile.new(0, {x = x, y = y})
        end
    end
    self:generateStartingGrid()
end

-- Generate a starting board (2 tiles)
function Grid:generateStartingGrid()
    math.randomseed(os.time())
    self:generateTile()
    self:generateTile()
end

function Grid:generateTile()
    local options = {}
    for x = 1, self.size, 1 do
        for y = 1, self.size, 1 do
            if self.tiles[x][y].number == 0 then
                table.insert(options, {x = x, y = y})
            end
        end
    end

    local chance = math.random(1, 10)
    local number = 2
    if chance <= 2 then number = 4 end
    local tile = math.random(1, #options)
    local x = options[tile].x
    local y = options[tile].y
    self:insertTile(x, y, number)
end

-- Chekc if the tile is free or not (a free tile has a number 0)
function Grid:isFreeSpace(position)
    return self.tiles[position.x][position.y].number == 0
end

-- Insert a new tile on the position
function Grid:insertTile(x, y, number)
    self.tiles[x][y] = Tile.new(number, {x = x, y = y})
end

-- Increase the current score of the game (no side effects, abs used on parameter)
function Grid:addToCurrentScore(number)
    self.currentScore = self.currentScore + math.abs(number)
end

-- Draw all the tiles
function Grid:draw()
    for x = 1, self.size, 1 do
        for y = 1, self.size, 1 do self.tiles[x][y]:draw({x = x, y = y}) end
    end
    if self.gameWon then self:drawWinScreen() end
end

function Grid:drawWinScreen()
    local winFont = love.graphics.newFont("fonts/retro_font.TTF", 30)
    love.graphics.setColor(150 / 255, 200 / 255, 0, 80 / 255)
    love.graphics.rectangle("fill", 1, 1, 600, 800)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("You win!", winFont, 215, 475)
end

function Grid:getAllTileOfType(number)
    local tiles = {}
    for x = 1, self.size, 1 do
        for y = 1, self.size, 1 do
            if self.tiles[x][y].number == number then
                table.insert(tiles, number)
            end
        end
    end
    return #tiles
end

function Grid:checkGameState()
    if self:getAllTileOfType(2048) > 0 then
        print("Game won!")
        self.gameWon = true
    end
end

-- Load the score from a local file
function Grid:loadScore()
    if not love.filesystem.getInfo("savegame.txt") then
        self.bestScore = 0
        self:saveScore()
    end
    local data = love.filesystem.load("savegame.txt")()
    self.bestScore = data.maxScore
end

function Grid:saveScore()
    local data = {}
    data.maxScore = math.max(self.currentScore, self.bestScore)
    -- data.maxScore = 0
    love.filesystem.write("savegame.txt", serialize(data))
end
