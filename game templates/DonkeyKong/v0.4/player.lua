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
    --aggiungiamo un campo per le collisioni
    self.collision = nil
    return self
end


function Player:draw()
    love.graphics.setColor(1, 0.5, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function Player:update(dt)

    self.onGround = false
    --[[
        nel nuovo modello di calcolo delle collisioni diamo importanza alle normali calcolate secondo i centri degli oggetti,
    ]]
    self.collision = nil
    for _,i in pairs(Game.entities) do
        -- salviamo la collisione
        self.collision = Game.checkCollision(self, i)
        -- se esiste la collisione ci operiamo sopra
        if i ~= self and self.collision then
            local nx, ny = self.collision.normal.nx, self.collision.normal.ny
            -- solo se ny<0 (ovvero verso l'alto) possiamo fermare il player, altrimenti deve cadere
            if ny < 0 then
                self.onGround = true
                break
            end
        end
    end
    
    if love.keyboard.isDown("a","left") then
        --come prima controlliamo se esiste la collisione e se esiste possiamo capire dove e' possibile muoverci
        if self.collision then 
            if self.collision.normal.nx <= 0 then self.x = self.x - self.speed * dt end
        else
            self.x = self.x - self.speed * dt
        end
        
    end
    if love.keyboard.isDown("d","right") then
        if self.collision then 
            if self.collision.normal.nx >= 0 then self.x = self.x + self.speed * dt end
        else
            self.x = self.x + self.speed * dt
        end
    end
    
    if not self.onGround then
        self.y = self.y + self.Vy * dt + Game.physics.gravity / 2 * dt * dt
        self.Vy = self.Vy + Game.physics.gravity * dt
    else
        self.Vy = 0
    end
end

return Player

