local love = require("love")

--[[
    Qui abbiamo spostato tutte le funzioni utili per platform, aggiungendo la funzione new
]]

local Platform = {}
Platform.__index = Platform

function Platform.new(x, y, width, height)
    local self = setmetatable({}, { __index = Platform })
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    return self

end

function Platform:draw()
    love.graphics.setColor(1, 0.5, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

return Platform
