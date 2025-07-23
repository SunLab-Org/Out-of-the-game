local love = require "love"

local Platform = {}

--[[
    in modo molto piu' semplice abbiamo anche modularizzato il codice di platform
]]

function Platform.new(x, y, width, height)
    local platform = {
        x = x,
        y = y,
        width = width,
        height = height
    }

    function platform:draw()
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("fill", platform.x - platform.width / 2, platform.y - platform.height / 2, platform.width, platform.height)
    end

    return platform
end

return Platform