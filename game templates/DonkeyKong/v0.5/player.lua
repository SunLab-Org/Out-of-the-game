local love = require "love"

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
    
    self.aviable_direction = {
        up = false,
        down = true,
        left = true,
        right = true
    }

    for _,i in pairs(Game.entities) do
        local coll = Game.checkCollision(self, i)
        if(coll) then 
            local nx, ny = coll.normal.nx, coll.normal.ny
            if(ny < 0) then self.onGround = true end
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
        -- aggiungiamo il controllo per il salto
        if love.keyboard.isDown("space", "up") then
            self:jump()
        end
        
    end
end

--  questa semplice funzione permette di saltare, fatta solo per essere leggibile

function Player:jump() 
    self.Vy = -self.speed
end



return Player

