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
                table.insert(options, {x=x, y=y})
            end
        end
    end

    local tile = math.random(1, #options)
    local x = options[tile].x
    local y = options[tile].y
    self:insertTile(x, y, 2)
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
    self:generateTile()
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
    self:generateTile()
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
    self:generateTile()
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
    self:generateTile()
end

-- Draw all the tiles
function Grid:draw()
    for x = 1, self.size, 1 do
        for y = 1, self.size, 1 do
            self.tiles[x][y]:draw({x = x, y = y})
        end
    end
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
        love.graphics.setColor(0/255, 255/255, 0, 255/255)
        love.graphics.rectangle("fill", 1, 1, 600, 800)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("You've won!", 35, 675)
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