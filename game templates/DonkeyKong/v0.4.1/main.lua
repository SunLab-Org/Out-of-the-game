local love = require "love"

--[[
    Obiettivi: 
    - migliorare il sistema di collisioni
    
    in questa seconda parte miglioriamo il nostro approccio per funzionare meglio
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
    --[[
        nella parte precedente abbiamo deciso di considerare il centro dei nostri corpi per calcolare la collisione, tuttavia questo
        non funziona sempre, anzi tende a non funzionare quando un corpo molto grande si scontra con un corpo molto piccolo per esempio

        una strategia migliore sarebbe non considerare il centro dell'oggetto stesso ma il centro dell'area che sta toccando
        l'altro oggetto
    ]]

    local collides =    a.x - a.width / 2 < b.x + b.width / 2 and
                        a.x + a.width / 2 > b.x - b.width / 2 and
                        a.y - a.height / 2 < b.y + b.height / 2 and
                        a.y + a.height / 2 > b.y - b.height / 2

    if collides == true then
        --inizializziamo i valori al centro dell'pggetto che collide
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
    questa funzione prende i due corpi a e b e ne calcola il centro della sovrapposizione,
    il concetto e' semplicemente tenere buono il lato del corpo che si sta sovrapponendo
    Una spiegazione piu' dettagliata negli apunti che trovate nella cartella
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

    local overlap_left   = math.max(a_left, b_left)
    local overlap_right  = math.min(a_right, b_right)
    local overlap_top    = math.max(a_top, b_top)
    local overlap_bottom = math.min(a_bottom, b_bottom)

    local centerX = (overlap_left + overlap_right) / 2
    local centerY = (overlap_top + overlap_bottom) / 2

    return centerX, centerY

end

--[[
    A questo punto il nostro sistema di collisioni e' quasi perfetto, andrebbero pero' apportate alcune modifiche
    perche' per il momento non gestisce alcune particolari collisioni ( per esempio quando un corpo spawn all'interno di un
    altro ) che possiamo opzionalmente migliorare
]]

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



