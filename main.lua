require("grid")

local grid = Grid.new()


function love.keyreleased(key)
    if key == "escape" or key == "q" then
        love.event.push("quit")
    end

    if key == "a" then
        print("Move left")
        grid:moveLeft()
    end
    if key == "d" then
        print("Move right")
        grid:moveRight()
    end
    if key == "w" then
        print("Move up")
        grid:moveUp()
    end
    if key == "s" then
        print("Move down")
        grid:moveDown()
    end
end

function love.update(dt)

end

function love.draw()
    local bestScoreFont = love.graphics.newFont("fonts/retro_font.TTF", 30)
    local currentScoreFont = love.graphics.newFont("fonts/retro_font.TTF", 55)
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.print("best score", bestScoreFont, 35, 615)
    love.graphics.print("1200", bestScoreFont, 400, 615)
    love.graphics.print("score", currentScoreFont, 35, 675)
    love.graphics.print("3000", currentScoreFont, 370, 675)
    grid:draw()
end
