local love = require "love"

--[[
    Obbiettivo: creare il famoso gioco di donkey kong
    Un attimo presto per pensare a quello, cominciamo con il capire il funzionamento di un gioco love2d
    inta
]]

function love.load()
    -- qui vanno messe tutte le cose che vengono chiamate all'avvio del programma

end

function love.update(dt)
    -- qui vanno messe tutte le cose che devono essere aggiornaate durante l'esecuzione del programma
end

function love.draw()
    -- infine questo e' per visualizzare tutto a schermo
    love.graphics.setBackgroundColor(0.4, 0.4, 1)
end

-- piccola funzione per uscire in modo semplice premendo il tasto ESCgame templates/DonkeyKong/v0.1/conf.lua game templates/DonkeyKong/v0.1/main.lua
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end