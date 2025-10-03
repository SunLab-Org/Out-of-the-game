local love = require "love"

--[[
    ora in modo simile creiamo il cerchio
]]

local Circle = {}
Circle.__index = Circle

function Circle.new(x, y, r)
    local c = {
        x = x or 10,
        y = y or 10,
        r = r or 5
    }  
    setmetatable(c, Circle)
    return c
end

-- per il cerchio creiamo una simpatica funzione che lo fa attaccare
-- al cursore del mouse

function Circle:update(dt)
    if love.keyboard.isDown("space") then
        local x, y = love.mouse.getPosition()
        self.x = self.x + (x - self.x) * dt * 10
        self.y = self.y + (y - self.y) * dt * 10
    end
    
    
end

function Circle:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle('fill', self.x, self.y, self.r)
end






-- infine la restituiamo come nuova classe
return Circle