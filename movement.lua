function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

local MoveDirection = {
    ["UP"] = {y = 1, y_step = 1},
    ["DOWN"] = {y = 4, y_step = -1},
    ["LEFT"] = {x = 1, x_step = 1},
    ["RIGHT"] = {x = 4, x_step = -1}
}

function getCompressedArray(mt, x, y, x_step, y_step)
    local tempArray = {}
    for _ = 1, 4 do
        if mt[y][x] ~= 0 then
            tempArray[#tempArray + 1] = mt[y][x]
        end
        x = math.Clamp(x + x_step, 1, 4)
        y = math.Clamp(y + y_step, 1, 4)
    end
    return tempArray
end

function compressArray(arr)
    local tempArr = {}
    for i = 1, #arr do
        if arr[i] ~= 0 then
            tempArr[#tempArr + 1] = arr[i]
        end
    end
    return tempArr
end

function combineTiles(arr)
    local curr = 1
    local nxt = 2
    for i = 1, #arr-1 do
        if arr[curr] == nil or arr[nxt] == nil then
            break
        elseif arr[curr] ~= arr[nxt] then
            curr = nxt
            nxt = nxt + 1
        elseif arr[curr] == arr[nxt] then
            arr[curr] = arr[curr] * 2
            arr[nxt] = 0
            curr = nxt + 1
            nxt = nxt + 2
        end
    end
    return arr
end

function moveRowLeft(mt, row)
    local arr = getCompressedArray(mt, MoveDirection.LEFT.x, row, MoveDirection.LEFT.x_step, 0)
    print("Got the array from row: " .. row .. " to the right")
    print(table.concat(arr, " "))

    if #arr == 0 or #arr == 1 then
        return
    end

    combineTiles(arr)
    arr = compressArray(arr)
    print("Compressed the row:")
    print(table.concat(arr, " "))
    print()
    for i = 1, 4, 1 do
        if arr[i] ~= nil then
            mt[row][i] = arr[i]
        else
            mt[row][i] = 0
        end
    end
end

function moveRowRight(mt, row)
    local arr = getCompressedArray(mt, MoveDirection.RIGHT.x, row, MoveDirection.RIGHT.x_step, 0)
    print("Got the array from row: " .. row .. " to the right")
    print(table.concat(arr, " "))

    if #arr == 0 or #arr == 1 then
        return
    end

    combineTiles(arr)
    arr = compressArray(arr)
    print("Compressed the row:")
    print(table.concat(arr, " "))
    print()
    for i = 4, 1, -1 do
        if arr[i] ~= nil then
            mt[row][5-i] = arr[i]
        else
            mt[row][5-i] = 0
        end
    end
end

function moveColumnUp(mt, col)
    local arr = getCompressedArray(mt, col, MoveDirection.UP.y, 0, MoveDirection.UP.y_step)
    print("Got the array from col: " .. col .. " to the up")
    print(table.concat(arr, " "))

    if #arr == 0 or #arr == 1 then
        return
    end

    combineTiles(arr)
    arr = compressArray(arr)
    print("Compressed the row:")
    print(table.concat(arr, " "))
    print()
    for i = 4, 1, -1 do
        if arr[i] ~= nil then
            mt[i][col] = arr[i]
        else
            mt[i][col] = 0
        end
    end
end

function moveColumnDown(mt, col)
    local arr = getCompressedArray(mt, col, MoveDirection.DOWN.y, 0, MoveDirection.DOWN.y_step)
    print("Got the array from col: " .. col .. " to the down")
    print(table.concat(arr, " "))

    if #arr == 0 or #arr == 1 then
        return
    end

    combineTiles(arr)
    arr = compressArray(arr)
    print("Compressed the row:")
    print(table.concat(arr, " "))
    print()
    for i = 4, 1, -1 do
        if arr[i] ~= nil then
            mt[5-i][col] = arr[i]
        else
            mt[5-i][col] = 0
        end
    end
end