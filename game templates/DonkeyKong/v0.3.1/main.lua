local love = require "love"

--[[
    Obiettivi: 
    - Modularizzare il codice
]]

--[[
    In questa parte di codice puntiamo a semplificare il codice, separandolo in file diversi. 
    In questo modo non solo rendiamo il codice piu' leggibile ma anche piu' manutenibile.

    Creiamo per prima cosa il file Player.lua, e spostiamoci tutte le funzioni necessarie
    Successivamente creiamo il file platform.lua e facciamo la stessa cosa
    
    per poterli utilizzare in main.lua, dobbiamo importare i file
 ]]
 
local playerGenerator = require "player"
local platformGenerat = require "platform"

--[[
    facciamo un ulteriore passo concettuale, ed immaginiamo che sul nostro schermo ci saranno diversi oggetti,
    che da ora chiamiamo entita', quindi l'approccio di dare un nome ad ognuno di essi ci accorgiamo essere poco praticabile
    Pertanto creiamo una table globale in Game dove metteremo tutte le entita'
]]

Game = {
    physics = {
        gravity = 500
    },
    entities = {}
}

function love.load()

    --in load aggiungiamo le entita' alla tabella
    --per convenienza futura, il primo elemento sara' sempre il player
    table.insert(Game.entities, playerGenerator.new(100, 100, 50, 50, 200))
    table.insert(Game.entities, platformGenerat.new(200, 200, 100, 20))
    table.insert(Game.entities, platformGenerat.new(300, 300, 100, 20))

end

function love.update(dt)
    -- in update scorriamo tutta la tabella e aggiorniamo tutte quelle aggiornabili
    for _, entity in ipairs(Game.entities) do
        -- se hanno una funzione update, allora la chiamiamo, altrimenti nulla
        if entity.update then
            entity:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    -- in draw scorriamo tutta la tabella e disegniamo tutte quelle disegnabili
    for _, entity in ipairs(Game.entities) do
        -- se hanno una funzione draw, allora la chiamiamo, altrimenti nulla
        if entity.draw then
            entity:draw()
        end
    end
end

--[[
    Il codice ora risulta molto piu' pulit ma soprattutto modulare e riutilizzabile, infatti possiamo aggiungere
    quante piattaforme vogliamo, tuttavia il sistema di collisioni non fa ancora al caso nostro, quindi nelle prossime
    versioni cercheremo di migliorarlo
]]


function Game.checkCollision(a, b)
    return a.x - a.width / 2 < b.x + b.width / 2 and
           a.x + a.width / 2 > b.x - b.width / 2 and
           a.y - a.height / 2 < b.y + b.height / 2 and
           a.y + a.height / 2 > b.y - b.height / 2
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end





