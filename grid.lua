require("tile")

Grid = {}
Grid.__index = Grid

function Grid.new()
    local o = setmetatable({size = 4, tiles = {}}, Grid)
    for x = 1, o.size, 1 do
        o.tiles[x] = {}
        for y = 1, o.size, 1 do 
            o.tiles[x][y] = Tile.new(128, {x = x, y = y}, 135, 8)
        end
    end

    return o
end

function Grid:withinBounds(position)
    return position.x >= 1 and position.x <= self.size and position.y >= 1 and
               position.y <= self.size
end

function Grid:isFreeSpace(position)
    return self.tiles[position.x][position.y] == nil
end

function Grid:insertTile(position, number)
    self.tiles[position.x][position.y] = Tile.new(number)
end

function Grid:removeTile(position) self.tiles[position.x][position.y] = nil end

function Grid:moveGrid(direction) end
-- Moves the tile at the position and returns if it was successful
function Grid:moveTile(position, direction) end

function Grid:draw()
    local offset = 25
    for x = 1, 4, 1 do
        for y = 1, 4, 1 do
            self.tiles[x][y]:draw({x = x, y = y})
        end
    end
end
