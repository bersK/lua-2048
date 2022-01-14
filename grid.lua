require("tile")

Grid = {}
Grid.__index = Grid


function Grid.new()
    local o = setmetatable({size = 4, cells = {}}, Grid)
    return o
end

function Grid:withinBounds(position)
  return position.x >= 0 and position.x < self.size and
         position.y >= 0 and position.y < self.size
end

function Grid:isFreeSpace(position)
  return self.cells[position.x][position.y] == nil
end

function Grid:insertTile(position, number)
  self.cells[position.x][position.y] = Tile.new(number)
end

function Grid:remoteTile(position)
  self.cells[position.x][position.y] = nil
end

-- Moves the tile at the position and returns if it was successful
function Grid:moveTile(position, direction)
end
