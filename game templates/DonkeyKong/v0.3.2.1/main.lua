local love = require "love"

--[[
    Obiettivi: 
     √  migliorare collision detection
     -  modularizzare il codice
]]

--[[
    Per quanto la scorsa volta abbiamo visto come implementare il sistema di collisioni,
    e abbiamo modularizzato il codice, ora possiamo notare alcune problematiche\
    riguardanti la nostra implementazione delle collisioni.
    Sperimentando avrete potuto notare cose come:
        - il personaggio si compenetra con l'oggetto con cui collidendo
        - il personaggio puo' liberamente muoversi all'interno dell'oggetto con cui collide
        - il personaggio ferma la sua caduta anche quando colpisce un oggetto di lato
        √ il personaggio non controlla bene le piattaforme su cui poggia, e poggia solo sull'ultima creata

    cio' che andiamo a fare ora e' migliorare l'implementazion di questo sistema, aggiungendo
    alcuni controlli e rendendo il nostro codice piu' complesso ed efficacie
]]

Game = {
    physics = {
        gravity = 500
    },
    entities = {}
}

local playerGenerator = require "Player"
local platformGenerator = require "Platform"

function love.load()
    table.insert(Game.entities, playerGenerator.new(100, 100, 50, 50))
    
    table.insert(Game.entities, platformGenerator.new(200, 200, 300, 20))
    table.insert(Game.entities, platformGenerator.new(200, 400, 300, 20))
    -- aggiungiamo una piattaforma in piu' che ci rende palese il problema, e cerchiamo di migliorarlo
    table.insert(Game.entities, platformGenerator.new(500, 400, 20, 300))
end

function love.update(dt)
    for i = 1, #Game.entities do
        local entity = Game.entities[i]
        if entity.checkCollision then entity.checkCollision()end
        if entity.update then entity:update(dt) end
    end
end

function love.draw()

    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    for i = 1, #Game.entities do
        local entity = Game.entities[i]
        if entity.draw then entity:draw() end
    end

end


--[[
    e' necessario modificare questa funzione per renderla piu' utile, e' un bene che 
    sia semplice ma per questo gioco necessitiamo di qualcosa in piu'
]]
function Game.checkCollision(a, b)
    
    -- questo checka solamente la collisione
    
    local collision = 
    (   a.x - a.width / 2 < b.x + b.width / 2 and
        a.x + a.width / 2 > b.x - b.width / 2 and
        a.y - a.height / 2 < b.y + b.height / 2 and
        a.y + a.height / 2 > b.y - b.height / 2
    )

    --[[
        un controllo che sarebbe possibile sarebbe controllare la posizione relativa dei centri
        dopo ver controllato la posizione dei centri, azzero la normale piu' "piccola"
    ]]

    local distanceX = math.abs(a.x - b.x)
    local distanceY = math.abs(a.y - b.y)
    local nx = a.x - b.x < 0 and -1 or 1
    local ny = a.y - b.y < 0 and -1 or 1

    if(distanceX < distanceY) then
        ny = 0
    else
        nx = 0
    end

    return {
        coll = collision,
        nx = nx,
        ny = ny,
    }
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end



