love.graphics.setDefaultFilter("nearest", "nearest")



palline = {}


function Restart()
    palline = {}

    -- PARAMETRI TAVOLO
    local tableWidth  = 1058
    local tableHeight = 424

    -- TRIANGOLO
    local startX = 400
    local startY = tableHeight / 2

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
            r = 15,
            vx = 0,
            vy = 0,
            sprite = love.graphics.newImage("sprites/Pallina_" .. i .. ".png")
        })
    end

end

-- PARAMETRI TAVOLO
local tableWidth  = 1058
local tableHeight = 424

-- TRIANGOLO
local startX = 400
local startY = tableHeight / 2

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
        r = 15,
        vx = 0,
        vy = 0,
        sprite = love.graphics.newImage("sprites/Pallina_" .. i .. ".png")
    })
end

local offsetX = 16  
local offsetY = 16  

-- BUCHE
buche = {}
local holeR = 20   


table.insert(buche, {x = holeR,           y = holeR,           r = holeR}) 
table.insert(buche, {x = tableWidth/2 + 11,    y = holeR,           r = holeR}) 
table.insert(buche, {x = tableWidth - holeR + 2*offsetX, y = holeR,        r = holeR}) 


table.insert(buche, {x = holeR,           y = tableHeight - holeR + 2*offsetY, r = holeR}) 
table.insert(buche, {x = tableWidth/2 + 11,    y = tableHeight - holeR + 2*offsetY, r = holeR}) 
table.insert(buche, {x = tableWidth - holeR + 2*offsetX, y = tableHeight - holeR + 2*offsetY, r = holeR}) 