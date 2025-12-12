love.graphics.setDefaultFilter("nearest", "nearest")



palline = {}

tavolo = {
    x = 0,
    y = 0,
    w = VIRTUAL_WIDTH,
    sprite = love.graphics.newImage("games/SimoneA/Tavolo_biliardo.png")
}
tavolo.h = tavolo.sprite:getHeight() * tavolo.w/tavolo.sprite:getWidth()


-- PARAMETRI TAVOLO

local tableWidth = tavolo.w
local tableHeight = tavolo.h


function Restart()
    palline = {}

    -- TRIANGOLO
    local startX = 1/3 * tableWidth
    local startY = tableHeight/ 2

    local d = 30                          
    local h = d * math.sin(math.rad(60)) 

    local positions = {}

    -- Aggiunge una riga del triangolo
    local function addRow(count, row)
        local x = startX - (row - 1) * d   
        local y = 0
        y = startY

        for i = 1, count do
            table.insert(positions, {
                x = x,
                y = y + (i - (count + 1) / 2) * d
            })
        end
    end

    addRow(1, 1)
    addRow(2, 2)
    addRow(3, 3)
    addRow(4, 4)
    addRow(5, 5)

    -- CREA LE 14 PALLINE
    for i = 1, 15 do
        table.insert(palline, {
            x = positions[i].x,
            y = positions[i].y,
            r = 7.5 * scale,
            vx = 0,
            vy = 0,
            sprite = love.graphics.newImage("games/SimoneA/sprites/Pallina_" .. i .. ".png")
        })
    end

end

local offsetX = 0 
local offsetY = 0

-- BUCHE
buche = {}
local holeR = 20   


table.insert(buche, {x = holeR,           y = holeR,           r = holeR}) 
table.insert(buche, {x = tableWidth/2,    y = holeR,           r = holeR}) 
table.insert(buche, {x = tableWidth - holeR + 2*offsetX, y = holeR,        r = holeR}) 


table.insert(buche, {x = holeR,           y = tableHeight - holeR + 2*offsetY, r = holeR}) 
table.insert(buche, {x = tableWidth/2,    y = tableHeight - holeR + 2*offsetY, r = holeR}) 
table.insert(buche, {x = tableWidth - holeR + 2*offsetX, y = tableHeight - holeR + 2*offsetY, r = holeR}) 