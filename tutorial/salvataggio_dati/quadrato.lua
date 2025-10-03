local love = require "love"

--[[
    in lua non esiste un vero e proprio sistema di classi
    ma possiamo fare qualcosa di simile tramite qualche stratagemma
]]

-- per prima cosa creiamo la table square
local Square = {}
Square.__index = Square

function Square.new(x, y, hg, wh)
    -- creiamo il nostro quadratino
    local s = {
        x = x or 10,
        y = y or 10,
        hg = hg or 10,
        wh = wh or 10
    }  
    -- importante per farlo andare
    setmetatable(s, Square)

    -- lo restituiamo
    return s
end

-- ora copiamo il metodo per disegnare il quadrato
function Square:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.hg, self.wh)
end






-- infine la restituiamo come nuova classe
return Square