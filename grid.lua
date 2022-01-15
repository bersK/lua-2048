require("tile")

Grid = {}
Grid.__index = Grid

function Grid.new()
    local o = setmetatable({size = 4, tiles = {}, gameStarted = false}, Grid)
    -- Populate the grid with tiles
    for x = 1, o.size, 1 do
        o.tiles[x] = {}
        for y = 1, o.size, 1 do 
            o.tiles[x][y] = Tile.new(0, {x = x, y = y})
        end
    end

    o:generateStartingGrid()
    return o
end

function Grid:withinBounds(position)
    return position.x >= 1 and position.x <= self.size and position.y >= 1 and
               position.y <= self.size
end

function Grid:resetGrid()
    for x = 1, self.size, 1 do
        self.tiles[x] = {}
        for y = 1, self.size, 1 do 
            self.tiles[x][y] = Tile.new(0, {x = x, y = y})
        end
    end
    
end

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

function Grid:isFreeSpace(position)
    return self.tiles[position.x][position.y].number == 0
end

function Grid:insertTile(x, y, number)
    self.tiles[x][y] = Tile.new(number, {x = x, y = y})
end

function Grid:removeTile(position)
    self.tiles[position.x][position.y].number = 0
 end

function Grid:moveGrid(direction) end
-- Moves the tile at the position and returns if it was successful
function Grid:moveTile(position, direction) end

function Grid:moveLeft()
    for y = 1, 4, 1 do
        for x = 1, 3, 1 do
            local currTileNumber = self.tiles[x][y].number
            local nextTileNumber = self.tiles[x+1][y].number
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                -- print("Sam; number! T1", x, y, "T2:", x+1, y)
                self:insertTile(x, y, currTileNumber*2)
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

function Grid:moveRight()
    for y = 1, 4, 1 do
        for x = 4, 2, -1 do
            local currTileNumber = self.tiles[x][y].number
            local nextTileNumber = self.tiles[x-1][y].number
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                -- print("Same number! T1", x, y, "T2:", x-1, y)
                self:insertTile(x, y, currTileNumber*2)
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
            -- print(x, y)
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                -- print("Same number! T1", x, y, "T2:", x, y+1)
                self:insertTile(x, y, currTileNumber*2)
                self:insertTile(x, y+1, 0)
            end
        end
    end
end

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
            -- print(x, y)
            if currTileNumber == nextTileNumber and currTileNumber ~= 0 then
                -- print("Same number! T1", x, y, "T2:", x, y-1)
                self:insertTile(x, y, currTileNumber*2)
                self:insertTile(x, y-1, 0)
            end
        end
    end
end

function Grid:draw()
    for x = 1, self.size, 1 do
        for y = 1, self.size, 1 do
            self.tiles[x][y]:draw({x = x, y = y})
        end
    end
end
