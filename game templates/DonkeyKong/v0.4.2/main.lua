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
        local cx, cy = Game.centerCollision(a,b)

        local coll = {}

        coll.normal = {nx = 0, ny = 0}

        local dx = cx - b.x
        local dy = cy - b.y
        local length = math.sqrt(((dx * dx) + (dy * dy)))

        dx = dx / length

        local angle = math.acos(dx) 
        if(dy>0) then angle = 2*math.pi - angle end

        local diagonal_length = math.sqrt((b.width * b.width) + (b.height * b.height))
        local diagonal_angle = math.acos((b.width) / diagonal_length)
        
        
        if angle >= diagonal_angle and angle <= math.pi - diagonal_angle then
            coll.normal.nx = 0
            coll.normal.ny = -1
        elseif angle <= (2 * math.pi) - diagonal_angle and angle >= (diagonal_angle + math.pi) then
            coll.normal.nx = 0
            coll.normal.ny = 1
        elseif angle > math.pi - diagonal_angle and angle < (diagonal_angle + math.pi) then
            coll.normal.nx = -1
            coll.normal.ny = 0
        else
            coll.normal.nx = 1
            coll.normal.ny = 0
        end
        
        return coll
    else
        return nil
    end

end

--[[
    nella funzione che calcola il centro di collisione potremmo muovere il giocatore in modo da avvicinarlo al lato migliore,
    ovvero il piu' vicino
]]

function Game.centerCollision(a,b)
    local a_left   = a.x - a.width / 2
    local a_right  = a.x + a.width / 2
    local a_top    = a.y - a.height / 2
    local a_bottom = a.y + a.height / 2

    local b_left   = b.x - b.width / 2
    local b_right  = b.x + b.width / 2
    local b_top    = b.y - b.height / 2
    local b_bottom = b.y + b.height / 2

    -- calcolo la distanza tra i lati
    local diff_left = (a_left - b_right >= 0) and a_left - b_right or 100000
    local diff_right = (a_right - b_left >= 0) and a_right - b_left or 100000
    local diff_top = (a_top - b_bottom >= 0) and a_top - b_bottom or 100000
    local diff_bottom = (a_bottom - b_top >= 0) and a_bottom - b_top or 100000


    -- prendo la minima differenza
    local min_diff = math.min(diff_left, diff_right, diff_top, diff_bottom)

    -- sposto lievemente il corpo in modo da chiarificare la collisione
    -- variare l'ordine provoca comportamenti diversi in casi di parita'
    if min_diff == diff_left then
        -- su right e left ho aggiunto 1 pixel per evitare dei glitch, potete sperimentare togliendolo ;D
        a.x = a.x + diff_left - 1
    elseif min_diff == diff_right then
        a.x = a.x - diff_right + 1
    elseif min_diff == diff_top then
        a.y = a.y + diff_top
    else
        a.y = a.y - diff_bottom
    end


    local overlap_left   = math.max(a_left, b_left)
    local overlap_right  = math.min(a_right, b_right)
    local overlap_top    = math.max(a_top, b_top)
    local overlap_bottom = math.min(a_bottom, b_bottom)

    

    local centerX = (overlap_left + overlap_right) / 2
    local centerY = (overlap_top + overlap_bottom) / 2

    return centerX, centerY

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



