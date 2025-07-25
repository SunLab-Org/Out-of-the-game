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
    self.type = "player"
    self.updatefun = self.move
    self.mask = {}

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

--[[
    per permettere al player di avere piu' set di controlli in momenti diveri
    dobbiamo usare una generica funzione di update che scambieremo durante
    il gioco con altre funzioni in base alla necessita'
]]

function Player:update(dt)
    self:updatefun(dt) -- ora chiameremo la generica funzione di update
end

function Player:stairmode(dt)
    for _,i in pairs(Game.entities) do
        local coll = Game.checkCollision(self, i)
        if(coll) then 
            -- ... altro a breve
        end
    end
    -- controlliamo di non uscire dalla scala
    local dtop = self.y + self.height/2 - (self.staricoord.y - self.staricoord.height/2)
    local dbot = self.y - self.height/2 - (self.staricoord.y + self.staricoord.height/2)

    local stairend = dtop > 0 and dbot < 0 

    -- movimento sulla scala
    if love.keyboard.isDown("w") and stairend then
        if(math.abs(dtop) > self.speed * dt) then
            self.y = self.y - self.speed * dt
        else 
            self.y = self.y - dtop + 1
        end
    end
    if love.keyboard.isDown("s") and stairend then
        if(math.abs(dbot) > self.speed * dt) then
            self.y = self.y + self.speed * dt
        else 
            self.y = self.y + dbot - 1
        end
    end

    -- usciamo dalla modalita' scala e resettiamo le maschere
    if love.keyboard.isDown("space") then
        self.updatefun = self.move
        self.mask = {}
    end
end

function Player:move(dt) 
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
            if(coll.type == "stair") then self.aviable_direction={
                up = true,
                down = true,
                left = true,
                right = true
            }
            -- aggiungiamo questo parametro per aiutarci a capire quale e' la dimensione della scala
            self.staricoord = coll.arg.staircoord
            end
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

    if love.keyboard.isDown("w", "s") and self.aviable_direction.up then
        self.updatefun = self.stairmode
        -- quando decidiamo di salire su una scala mascheriamo le collisioni che non vogliamo
        table.insert(self.mask, "platform")
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



function Player:jump() 
    self.Vy = -self.speed
end



return Player

