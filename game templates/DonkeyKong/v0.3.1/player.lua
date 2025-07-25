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

    -- prima andare avanti nel main, questa viene spiegata dopo :D
    self.onGround = false
    return self
end


function Player:draw()
    love.graphics.setColor(1, 0.5, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function Player:update(dt)
    if love.keyboard.isDown("a","left") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("d","right") then
        self.x = self.x + self.speed * dt
    end

    --[[
        Questa parte deve essere modificata, per il momento potremmo semplicemente scorrere tutta la tabella delle entita'
        e cercare se c'e' almeno una collisione
        creiamo una variabile player.onGround, che sta a significare che il player e' a terra
        qui, creiamo un ciclo che checka se esiste almeno una collisione
    ]]

    -- supponiao non ce ne siano
    self.onGround = false
    
    for _,i in pairs(Game.entities) do
        -- se c'e' una collisione, allora il player e' a terra
        if i ~= self and Game.checkCollision(self, i) then
            
            self.onGround = true
            -- questo serve per fermare il ciclo, apena trovo una collisione
            break
        end
    end

    -- qui utilizziamo onGround
    if not self.onGround then
        self.y = self.y + self.Vy * dt + Game.physics.gravity / 2 * dt * dt
        self.Vy = self.Vy + Game.physics.gravity * dt
    else
        self.Vy = 0
    end
end

return Player

