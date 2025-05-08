local class = require "libraries.hump.class"

local playerMovementComponent = class{
    init = function(self, body, player)
        -- il componente di movimento prende il body e lo muove
        assert(body)
        self.body = body

        self.movementControl = {
            up = player == 1 and "w" or "i",
            down = player == 1 and "s" or "k",
        }

    end,
    update = function(self,dt)
        self:movePlayer(dt)
    end,
    movePlayer = function(self, dt)
        local Vx, Vy = self.body:getLinearVelocity()
        -- print(Vx .. Vy)
        if love.keyboard.isDown(self.movementControl.up) then
            -- print("up")
            Vy = -10000 * dt
        elseif love.keyboard.isDown(self.movementControl.down) then
            -- print("down")
            Vy = 10000 * dt
        else
            Vy = 0
        end
        self.body:setLinearVelocity(Vx, Vy)
    end,


}

return playerMovementComponent