require("movement")

function printtbl(mt)
    for y = 1, 4 do
        print(table.concat(mt[y], " "))
    end
end

local mt = { {1, 1, 2, 2},
             {0, 1, 3, 0},
             {1, 0, 4, 2},
             {4, 1, 2, 2} }

moveRowRight(mt, 4)
printtbl(mt)
moveRowLeft(mt, 1)
printtbl(mt)
moveColumnUp(mt, 1)
printtbl(mt)
moveColumnDown(mt, 1)
printtbl(mt)