local love = require "love"
local timers = require "timerhandler"

local Player = {}
Player.__index = Player

function Player.new(x,y,width,height, speed)
    local self = setmetatable({}, { __index = Player })
    self.x = x or 100
    self.y = y or 100
    self.width = width or 50
    self.height = height or 50
    self.speed = speed or 300

    self.sprint = false

    self.direction = {x = 0, y = 0}

    self.aviable_direction = {
        up = true,
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

    if self.direction.x == 0 and self.direction.y == 0 then
        self.sprint = false
    end

    if not self.sprint then self.direction = {x = 0, y = 0} end
    
    self.aviable_direction = {
        up = true,
        down = true,
        left = true,
        right = true
    }

    for _,i in pairs(Game.entities) do
        local coll = Game.checkCollision(self, i)
        if(coll) then 
            local nx, ny = coll.normal.nx, coll.normal.ny
            if(ny < 0) then self.aviable_direction.up = false end
            if(ny > 0) then self.aviable_direction.down = false end
            if(nx < 0) then self.aviable_direction.right = false end
            if(nx > 0) then self.aviable_direction.left = false end

        end
    end

    if not self.sprint then
        if love.keyboard.isDown("a","left") and self.aviable_direction.left then
                self.direction.x = self.direction.x -1
        end

        if love.keyboard.isDown("d","right") and self.aviable_direction.right then
                self.direction.x = self.direction.x + 1
        end

        if love.keyboard.isDown("w","up") and self.aviable_direction.up then
                self.direction.y = self.direction.y - 1
        end

        if love.keyboard.isDown("s","down") and self.aviable_direction.down then
                self.direction.y = self.direction.y + 1
        end
    end
    
    self:normalize()

    if self.sprint then
        self.direction.x = self.direction.x * 1.4
        self.direction.y = self.direction.y * 1.4
    end

    self.x = self.x + self.direction.x * self.speed * dt
    self.y = self.y + self.direction.y * self.speed * dt

end

function Player:normalize() 
    local len = math.sqrt(math.abs(self.direction.x)^2 + math.abs(self.direction.y)^2)
    if len == 0 then return end
    self.direction.x = self.direction.x / len
    self.direction.y = self.direction.y / len
end

function Player:spacePressed()
    
    self.sprint = true
    self.sprinttimer = timers:new(0.4, function() self.sprint = false; end, "end","playersprint")
   
end



return Player