Tile = {}
Tile.__index = Tile

local tileColors = {}
tileColors[2] = "eee4da"
tileColors[4] = "ede0c8"
tileColors[8] = "f2b179"
tileColors[16] = "f59563"
tileColors[32] = "f67c5f"
tileColors[64] = "f65e3b"
tileColors[128] = "edcf72"
tileColors[256] = "edcc61"
tileColors[512] = "edc850"
tileColors[1024] = "edc53f"
tileColors[2048] = "edc22e"
tileColors["super"] = "3c3a32"

function Tile.new(number)
    local o = setmetatable({
        number,
        position = {x = 0, y = 0},
        size = 135,
        roundingSize = 8
    }, Tile)
    return o
end

function Tile:setColorTile(number)
    local r = "0x" .. tileColors[number]:sub(1, 2)
    local g = "0x" .. tileColors[number]:sub(3, 2)
    local b = "0x" .. tileColors[number]:sub(5, 2)
    love.graphics.setColor(r, g, b, 255)
end

function Tile:draw(position)
    -- love.graphics.setColor(255,255,255,255)
    local offset = 25
    Tile:setColorTile(self.number)
    love.graphics.rectangle("fill", position.x, position.y, self.size,
                            self.size, self.roundingSize)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(tostring(self.number), self.tileFont,
                        offset + position.x * 135 + position.x * 5 + 5,
                        offset + position.y * 135 + position.y * 5 + 50)
end
