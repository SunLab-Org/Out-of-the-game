local love = require("love")

-- aggiungiamo a platform un campo stair, senza bisogno di creare nuovi files

local Platform = {}
Platform.__index = Platform

function Platform.new(x, y, width, height, type)
    local self = setmetatable({}, { __index = Platform })
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.type = type or "platform"
    return self

end

function Platform:draw()
    love.graphics.setColor(1, 0.5, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

return Platform
