require("grid")

local grid = Grid.new()


function love.keyreleased(key)
    if key == "escape" or key == "q" then
        love.event.push("quit")
    end
end

function love.update(dt)

end

function love.draw()
    local bestScoreFont = love.graphics.newFont("fonts/retro_font.TTF", 30)
    local currentScoreFont = love.graphics.newFont("fonts/retro_font.TTF", 55)
    -- love.graphics.print("Is within bounds "..tostring(grid:withinBounds({x = 3, y = 3})), font, 35, 615)
    love.graphics.print("best score", bestScoreFont, 35, 615)
    love.graphics.print("1200", bestScoreFont, 400, 615)
    love.graphics.print("score", currentScoreFont, 35, 675)
    love.graphics.print("3000", currentScoreFont, 370, 675)
    grid:draw()
end
