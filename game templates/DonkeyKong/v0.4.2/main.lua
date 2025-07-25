local love = require "love"

--[[
    Obiettivi: 
    - migliorare il sistema di collisioni
    
    Questa parte e' essenzialmente opzionale, in quanto il gioco nella maggiorparte dei casi funziona bene, tuttavia
    se vogliamo essere minuziosi dovremmo aggiungere un sistema che non permetta la compenetrazione dei corpi

    Abbiamo visto come se un corpo arriva abbastanza veloce, prima che il codice riesca a capire che e' compenetrato questo
    si compenetra ulteriormente. In questo caso vogliamo spostarlo verso l'esterno immediatamente, in modo che non ci siano
    problemi durante il calcolo delle normali
]]
 
local playerGenerator = require "player"
local platformGenerat = require "platform"

Game = {
    physics = {
        gravity = 500
    },
    entities = {}
}

function love.load()

    table.insert(Game.entities, playerGenerator.new(200, 100, 50, 50, 200))
    table.insert(Game.entities, platformGenerat.new(200, 200, 100, 20))
    table.insert(Game.entities, platformGenerat.new(300, 300, 100, 20))
    table.insert(Game.entities, platformGenerat.new(250, 100, 20, 200))

end

function love.update(dt)
   
    for _, entity in ipairs(Game.entities) do
        if entity.update then
            entity:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    for _, entity in ipairs(Game.entities) do
        if entity.draw then
            entity:draw()
        end
    end
end


function Game.checkCollision(a, b)
    if a == b then return nil end

    local collides =    a.x - a.width / 2 < b.x + b.width / 2 and
                        a.x + a.width / 2 > b.x - b.width / 2 and
                        a.y - a.height / 2 < b.y + b.height / 2 and
                        a.y + a.height / 2 > b.y - b.height / 2

    if collides == true then
        local overlap = Game.centerCollision(a,b)
        
        local coll = {}

        coll.normal = {nx = 0, ny = 0}
   
        if overlap.height > overlap.width then
            if overlap.cx > b.x then
                coll.normal.nx = 1
            else
                coll.normal.nx = -1
            end
            coll.normal.ny = 0
        else
            if overlap.cy > b.y then
                coll.normal.ny = 1
            else
                coll.normal.ny = -1
            end
            coll.normal.nx = 0
        end


        Game.transpose(a, overlap)
        
        return coll
    else
        return nil
    end

end

function Game.centerCollision(a,b)
    local a_left   = a.x - a.width / 2
    local a_right  = a.x + a.width / 2
    local a_top    = a.y - a.height / 2
    local a_bottom = a.y + a.height / 2

    local b_left   = b.x - b.width / 2
    local b_right  = b.x + b.width / 2
    local b_top    = b.y - b.height / 2
    local b_bottom = b.y + b.height / 2

    local overlap_left   = math.max(a_left, b_left)
    local overlap_right  = math.min(a_right, b_right)
    local overlap_top    = math.max(a_top, b_top)
    local overlap_bottom = math.min(a_bottom, b_bottom)

    

    local centerX = (overlap_left + overlap_right) / 2
    local centerY = (overlap_top + overlap_bottom) / 2
    local width = overlap_right - overlap_left
    local height = overlap_bottom - overlap_top

    return {
        cx = centerX, 
        cy = centerY,
        width = width,
        height = height
    }
        

end

function Game.transpose(a, overlap)
    local dx = a.x - overlap.cx
    local dy = a.y - overlap.cy

    if overlap.width < overlap.height then
        a.x = a.x + ( 1 + overlap.width) * (dx / math.abs(dx))
    else
        a.y = a.y + overlap.height * (dy / math.abs(dy))
    end
end

--[[
    ora possiamo dire che il sistema di collisioni e' ultimato, questa parte seppur molto complessa e' fondamentale
    e generale per lo sviluppo di molti giochi, pertanto ritengo pertinente coprirla a fondo
]]

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



