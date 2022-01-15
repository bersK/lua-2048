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

function Tile.new(number_in, position_in, size_in, rounding_in)
    local o = setmetatable({
        number = number_in,
        position = position_in,
        size = size_in,
        roundingSize = rounding_in
    }, Tile)
    o.tileFont = love.graphics.newFont("fonts/retro_font.TTF", 35)
    o.tileFont:setFilter("nearest", "nearest")

    return o
end

function Tile:setColorTile(number)
    local r = "0x" .. tileColors[number]:sub(1, 2)
    local g = "0x" .. tileColors[number]:sub(3, 4)
    local b = "0x" .. tileColors[number]:sub(5, 6)
    -- print(r..g..b)
    love.graphics.setColor(
    string.format('%02X',string.byte(r)),
    string.format('%02X',string.byte(g)),
    string.format('%02X',string.byte(b)),
    255)
end

function Tile:draw(position)
    -- love.graphics.setColor(255,255,255,255)
    local offset = 20
    -- Tile:setColorTile(self.number)
    local x = offset + (position.x-1) * 135 + position.x * 5
    local y = offset + (position.y-1) * 135 + position.y * 5
    Tile:setColorTile(128)
    love.graphics.rectangle("fill", x, y, self.size,
                            self.size, self.roundingSize)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf("4", self.tileFont,
                        x - 30,
                        y + 55, 200, "center")
end
