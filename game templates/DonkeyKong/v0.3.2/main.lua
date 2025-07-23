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
        - il personaggio non controlla bene le piattaforme su cui poggia, e poggia solo sull'ultima creata

    cio' che andiamo a fare ora e' migliorare l'implementazion di questo sistema, aggiungendo
    alcuni controlli e rendendo il nostro codice piu' complesso ed efficacie
]]

Game = {
    physics = {
        gravity = 500
    },
    --[[
        per prima cosa ci serve un modo per tenere traccia ti tutte le entita' sullo schermo
        qundi facciamo una table che conterra' tutte le nostre entita'
    ]]
    entities = {}
}

local playerGenerator = require "Player"
local platformGenerator = require "Platform"

function love.load()
    --[[
        cambiamo leggermente il codice, inseriamo il player e tutte le piattaforme nella table
        Per praticita' possiamo prefissarci una regola:
            IL PRIMO ELEMENTO DELLA TABEL E' SEMPRE IL PLAYER
        cosi' non ci sbagliamo :D
    ]]
    table.insert(Game.entities, playerGenerator.new(100, 100, 50, 50))
    
    table.insert(Game.entities, platformGenerator.new(200, 200, 300, 20))
    table.insert(Game.entities, platformGenerator.new(200, 400, 300, 20))
end

--[[
    Grazie alla creazione delle tabella possiamo modificare il codice e renderlo scalabile grazie
    ai cicli for
]]
function love.update(dt)
    for i = 1, #Game.entities do
        local entity = Game.entities[i]
        --[[
            per ogni entita' controlliamo se ha una funzione che controlla le collisioni,
            se la ha la chiamiamo
        ]]
        if entity.checkCollision then entity.checkCollision()end

        -- similmente se l'entita' ha una funzione update allora la chiamiamo
        if entity.update then entity:update(dt) end
    end
end

function love.draw()

    love.graphics.setBackgroundColor(0.4, 0.4, 1)

    --[[
        similmente a prima dobbiamo scorrere tutta la table e disegnare tutte le entita'
        che possono essere disegnate
    ]]
    for i = 1, #Game.entities do
        local entity = Game.entities[i]
        if entity.draw then entity:draw() end
    end

end


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

--[[
    Notiamo alcune cose.. abbiamo purtroppo dei problemi di codice, ora riusciamo a
    creare delle nuove piattaforme in modo facile, tuttavi e' necessario modificare
    il sistema di collisioni
]]



