require("grid")

local grid = Grid.new()

print(grid:withinBounds({x = 3, y = 3}))

function love.keyreleased(key)
end

function love.update(dt)

end

function love.draw()
    local offset = 25
    for x = 0, 3, 1 do
        for y = 0, 3, 1 do
            love.graphics.rectangle("fill", offset + x*135 + x*5, offset + y*135 + y*5, 135, 135, 8)
        end
    end
end
