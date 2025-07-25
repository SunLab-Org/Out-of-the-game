local love = require("love")

--[[
    creiamo quindi la classe dei barili ovvero cio' che ci colpira'
    in questo caso dobbiamo dotarla di una funzione update in modo da poter applicargli
    la fisica del nostro gioco

]]

local Barrel = {}
Barrel.__index = Barrel

function Barrel.new(x, y, width, height)
    local self = setmetatable({}, { __index = Barrel })
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.speed = 200
    self.Vx = 0
    self.Vy = 0
    self.onGround = false
    return self

end

function Barrel:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function Barrel:update(dt)

    self.onGround = false

    for _,i in pairs(Game.entities) do
        local coll = Game.checkCollision(self, i)
        if(coll) then 
            local nx, ny = coll.normal.nx, coll.normal.ny
            if(ny < 0) then self.onGround = true end

            -- quando il barile tocca qualcosa di lato dobbiamo invertire la sua direzione
            if(nx ~= 0) then self.speed = nx*self.speed end
        end
    end
    
    -- il barile si muove sempre nella direzione della sua velocita' in modo incessante
    self.x = self.x + self.speed * dt
    
    if not self.onGround then
        self.y = self.y + self.Vy * dt + Game.physics.gravity / 2 * dt * dt
        self.Vy = self.Vy + Game.physics.gravity * dt
    else
        self.Vy = 0
    end
end

-- ora che abbiamo i barrel possiamo passare alla creazione delle scale

return Barrel
