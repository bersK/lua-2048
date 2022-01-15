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
        roundingSize = rounding_in,
        tileColor = {}
    }, Tile)
    o.tileFont = love.graphics.newFont("fonts/retro_font.TTF", 35)
    o.tileFont:setFilter("nearest", "nearest")
    o.tileColor = Tile:getColorTile(o.number)

    return o
end

function Tile:getColorTile(number)
    local hex = tileColors[number]
    local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    return {r, g, b}
end

function Tile:draw(position)
    local offset = 20
    local x = offset + (position.x-1) * 135 + position.x * 5
    local y = offset + (position.y-1) * 135 + position.y * 5
    love.graphics.setColor(self.tileColor[1]/255, self.tileColor[2]/255, self.tileColor[3]/255, 1)
    print(self.tileColor[1], self.tileColor[2], self.tileColor[3])
    love.graphics.rectangle("fill", x, y, self.size,
                            self.size, self.roundingSize)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("4", self.tileFont,
                        x - 30,
                        y + 55, 200, "center")
end
