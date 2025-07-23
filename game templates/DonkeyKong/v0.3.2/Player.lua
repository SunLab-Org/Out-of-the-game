local love = require "love"


local Player = {}

function Player.new(x, y, width, height)
    local player = {
        x = x,
        y = y,
        width = width,
        height = height,
        speed = 100,
        Vx = 0,
        Vy = 0,
        onGround = false
    }

    function player:draw()
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("fill", player.x - player.width / 2, player.y - player.height / 2, player.width, player.height)
    end

    function player:update(dt)
        if love.keyboard.isDown("a","left") then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("d","right") then
            player.x = player.x + player.speed * dt
        end
    
        if not player.onGround then
            player.y = player.y + player.Vy * dt + Game.physics.gravity / 2 * dt * dt
            player.Vy = player.Vy + Game.physics.gravity * dt
        else
            player.Vy = 0
        end
    end

    --[[
        modificiamo checkCollision in modo che tragga vantaggio dalla table creata, 
        in questo modo controlla tutte le collisioni tra se' stesso e gli altri oggetti
    ]]
    function player:checkCollision()
        player.onGround = false
         
        for j = 1, #Game.entities do
            local otherEntity = Game.entities[j]
            if player ~= otherEntity then
                if not player.onGround then player.onGround = Game.checkCollision(player,otherEntity) end
            end
        end
    end

    return player
end

return Player

--[[
    in questa parte abbiamo creato una parte importantissima del programma, ovvero un controllo
    delle collisioni dinamico, tuttavia deve essere ancora fatto molto lavoro per migliorare il sistema di collisioni
    
]]






