require("grid")

local grid = Grid.new()

local bestScoreFont = love.graphics.newFont("fonts/retro_font.TTF", 30)
local currentScoreFont = love.graphics.newFont("fonts/retro_font.TTF", 55)

function love.keyreleased(key)
    if key == "escape" or key == "q" then
        grid:saveScore()
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
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.print("best score", bestScoreFont, 35, 615)
    love.graphics.print(tostring(grid.bestScore), bestScoreFont, 400, 615)
    love.graphics.print("score", currentScoreFont, 35, 675)
    love.graphics.print(grid.currentScore, currentScoreFont, 370, 675)
    grid:draw()
end
