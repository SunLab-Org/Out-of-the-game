local love = require "love"

--[[
    Obiettivi: 
     -  migliorare collision detection
     -  modularizzare il codice
]]

--[[
    Prima di passare a vedere come migliorare ulteriormente il nostro gioco e' necessario fare
    un passetto indietro e cambiare un po' di codiche cha abbiamo scritto e riconsiderarlo
    In particolare e' necessario modularizzare il codice per renderlo piu' semplice visivamente
    e piu' riutilizzabile,
    In questa prima parte vediamo come separare i file in modo migliore.
]]

Game = {
    physics = {
        gravity = 500
    }
}

local playerGenerator = require "Player"
local platformGenerator = require "Platform"

function love.load()
    -- qui facciam le nuove chiamate ai file
    Player = playerGenerator.new(100, 100, 50, 50)
    Player2 = playerGenerator.new(200, 100, 50, 50)

    -- per fare un test sulla buona riuscita del lavoro, spawno un secondo player

    Platform = platformGenerator.new(200, 200, 300, 20)
    Platform2 = platformGenerator.new(200, 300, 300, 20)
end

function love.update(dt)
    -- chiamiamo qui la funzione checkCollision di player
    Player:checkCollision(Platform)
    Player:checkCollision(Platform2)
    Player:update(dt)

    

    Player2:checkCollision(Platform)
    Player2:checkCollision(Platform2)
    Player2:update(dt)
end

function love.draw()

    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    Player:draw()
    Player2:draw()
    Platform:draw()
    Platform2:draw()

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
    creare delle nuove piattaforme in modo facile, tuttavia e' necessario modificare
    il sistema di collisioni
]]



