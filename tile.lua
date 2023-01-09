Tile = {}
Tile.__index = Tile

local tileColors = {}
tileColors[0]       = "eee4da"
tileColors[2]       = "eee4da"
tileColors[4]       = "ede0c8"
tileColors[8]       = "f2b179"
tileColors[16]      = "f59563"
tileColors[32]      = "f67c5f"
tileColors[64]      = "f65e3b"
tileColors[128]     = "edcf72"
tileColors[256]     = "edcc61"
tileColors[512]     = "edc850"
tileColors[1024]    = "edc53f"
tileColors[2048]    = "edc22e"
tileColors["super"] = "3c3a32"

local tileFont = love.graphics.newFont("fonts/retro_font.TTF", 35)
tileFont:setFilter("nearest", "nearest")

function Tile.new(number_in, position_in, size_in, rounding_in)
    local o = setmetatable({
        number = number_in,
        position = position_in,
        size = size_in or 135,
        roundingSize = rounding_in or 8,
        tileColor = Tile:getColorTile(number_in)
    }, Tile)

    return o
end

function Tile:getColorTile(number)
    if tileColors[number] == nil then
        return self:getColorTile("super")
    end
    local hex = tileColors[number]
    local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    return {r, g, b}
end

function Tile:draw(position)
    local offset = 20
    local x = offset + (position.x-1) * self.size + position.x * 5
    local y = offset + (position.y-1) * self.size + position.y * 5

    love.graphics.setColor(self.tileColor[1]/255, self.tileColor[2]/255, self.tileColor[3]/255, 1)
    love.graphics.rectangle("fill", x, y, self.size, self.size, self.roundingSize)
    love.graphics.setColor(0, 0, 0, 1)

    if self.number ~= 0 then
        love.graphics.printf(
            tostring(self.number), tileFont, x - 30, y + 55, 200, "center")
    end
end
