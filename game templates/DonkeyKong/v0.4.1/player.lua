local love = require "love"

--[[
    Questo e' un modo semplice per riutilizzare il codice in lua, ogni volta che vorremmo un nuovo player
    bastera' chiamare la funzione Player.new() e passare i parametri riciesti, per il resto non cambiamo nulla a livello di codice
]]

local Player = {}
Player.__index = Player

function Player.new(x,y,width,height, speed)
    local self = setmetatable({}, { __index = Player })
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = speed
    self.Vx = 0
    self.Vy = 0
    self.onGround = false

    self.aviable_direction = {
        up = false,
        donw = true,
        left = true,
        right = true
    }
    return self
end


function Player:draw()
    love.graphics.setColor(1, 0.5, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function Player:update(dt)

    self.onGround = false
    --azzeriamo le direzioni
    self.aviable_direction = {
        up = false,
        down = true,
        left = true,
        right = true
    }
    for _,i in pairs(Game.entities) do
        --nel momento in cui troviamo una collisione andiamo a confrontarla e "sommarla" con quella gia' presente
        local coll = Game.checkCollision(self, i)
        if(coll) then 
            local nx, ny = coll.normal.nx, coll.normal.ny
            -- controlliamo se esiste un contatto con il terreno
            if(ny < 0) then self.onGround = true end

            --controlliamo quali direzioni sono possibili
            if(nx < 0) then self.aviable_direction.right = false end
            if(nx > 0) then self.aviable_direction.left = false end

        end
    end
    
    --utilizziamo le direzioni posssibili per muoverci

    if love.keyboard.isDown("a","left") and self.aviable_direction.left then
            self.x = self.x - self.speed * dt
    end

    if love.keyboard.isDown("d","right") and self.aviable_direction.right then
            self.x = self.x + self.speed * dt
    end
    
    if not self.onGround then
        self.y = self.y + self.Vy * dt + Game.physics.gravity / 2 * dt * dt
        self.Vy = self.Vy + Game.physics.gravity * dt
    else
        self.Vy = 0
    end
end

return Player

