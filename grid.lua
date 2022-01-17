require("tile")
local serialize = require("lib/ser")

Grid = {}
Grid.__index = Grid

-- Create a grid object and return
function Grid.new()
    local o = setmetatable({size = 4, tiles = {}, gameStarted = false, currentScore = 0, bestScore = 0}, Grid)
    -- Populate the grid with tiles
    for x = 1, o.size, 1 do
        o.tiles[x] = {}
        for y = 1, o.size, 1 do 
            o.tiles[x][y] = Tile.new(0, {x = x, y = y})
        end
    end

    o:loadScore()
    o:generateStartingGrid()
    return o
end

-- Check if coordinates are within the grid and returns a bool
function Grid:withinBounds(position)
    return position.x >= 1 and position.x <= self.size and position.y >= 1 and
               position.y <= self.size
end

-- Reset all tiles to be the value 0 (blanks)
function Grid:resetGrid()
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
    local x1 = math.random(1, self.size)
    local y1 = math.random(1, self.size)
    local x2 = ((x1 + 1) % self.size) + 1
    local y2 = ((y1 + 1) % self.size) + 1

    -- self:insertTile(x1, y1, 2)
    -- self:insertTile(x2, y2, 2)
    self:insertTile(1, 1, 4)
    -- self:insertTile(2, 1, 2)
    self:insertTile(3, 1, 2)
    self:insertTile(4, 1, 2)
    self:insertTile(1, 3, 8)
    self:insertTile(2, 3, 4)
    self:insertTile(3, 3, 2)
    self:insertTile(4, 3, 2)
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
    assert(number < 0, "Passed score cannot be a negative number.")
    self.currentScore = self.currentScore + math.abs(number)
end

-- Move the tiles left on the grid
function Grid:moveLeft()
    for y = 1, 4, 1 do
        for x = 1, 3, 1 do
            local currTileNumber = self.tiles[x][y].number
            local nextTileNumber = self.tiles[x+1][y].number
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                self:insertTile(x, y, currTileNumber*2)
                self:addToCurrentScore(currTileNumber*2)
                self:insertTile(x+1, y, 0)
            end
        end
        for i = 1, 4 do
            for x = 1, 3, 1 do
                local currTileNumber = self.tiles[x][y].number
                local nextTileNumber = self.tiles[x+1][y].number
                if currTileNumber == 0 and nextTileNumber ~= 0 then
                    self:insertTile(x, y, nextTileNumber)
                    self:insertTile(x+1, y, 0)
                end
            end
        end
    end
end

-- Move the tiles right on the grid
function Grid:moveRight()
    for y = 1, 4, 1 do
        for x = 4, 2, -1 do
            local currTileNumber = self.tiles[x][y].number
            local nextTileNumber = self.tiles[x-1][y].number
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                self:insertTile(x, y, currTileNumber*2)
                self:addToCurrentScore(currTileNumber*2)
                self:insertTile(x-1, y, 0)
            end
        end
        for i = 1, 4 do
            for x = 4, 2, -1 do
                local currTileNumber = self.tiles[x][y].number
                local nextTileNumber = self.tiles[x-1][y].number
                if currTileNumber == 0 and nextTileNumber ~= 0 then
                    self:insertTile(x, y, nextTileNumber)
                    self:insertTile(x-1, y, 0)
                end
            end
        end
    end
end

-- Move the tiles up on the grid
function Grid:moveUp()
    for x = 1, 4, 1 do
        for i = 1, 4 do
            for y = 1, 3, 1 do
                local currTileNumber = self.tiles[x][y].number
                local nextTileNumber = self.tiles[x][y+1].number
                if currTileNumber == 0 and nextTileNumber ~= 0 then
                    self:insertTile(x, y, nextTileNumber)
                    self:insertTile(x, y+1, 0)
                end
            end
        end
        for y = 1, 3, 1 do
            local currTileNumber = self.tiles[x][y].number
            local nextTileNumber = self.tiles[x][y+1].number
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                self:insertTile(x, y, currTileNumber*2)
                self:addToCurrentScore(currTileNumber*2)
                self:insertTile(x, y+1, 0)
            end
        end
    end
end

-- Move the tiles down on the grid
function Grid:moveDown()
    for x = 1, 4, 1 do
        for i = 1, 4 do
            for y = 4, 2, -1 do
                local currTileNumber = self.tiles[x][y].number
                local nextTileNumber = self.tiles[x][y-1].number
                if currTileNumber == 0 and nextTileNumber ~= 0 then
                    self:insertTile(x, y, nextTileNumber)
                    self:insertTile(x, y-1, 0)
                end
            end
        end
        for y = 4, 2, -1 do
            local currTileNumber = self.tiles[x][y].number
            local nextTileNumber = self.tiles[x][y-1].number
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                self:insertTile(x, y, currTileNumber*2)
                self:addToCurrentScore(currTileNumber*2)
                self:insertTile(x, y-1, 0)
            end
        end
    end
end

-- Draw all the tiles
function Grid:draw()
    for x = 1, self.size, 1 do
        for y = 1, self.size, 1 do
            self.tiles[x][y]:draw({x = x, y = y})
        end
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
    love.filesystem.write("savegame.txt", serialize(data))
end