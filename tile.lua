Tile = {}
Tile.__index = Tile


function Tile.new(number)
    local o = setmetatable({number, position = {x = 0, y = 0}}, Tile)
    return o
end