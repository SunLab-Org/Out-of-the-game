local class = require "libraries.hump.class"

local physicsComponent = class{
    init = function(self, x, y, height, width, collfun)
        --come deve essere gestita la collisione
        self.collfun = collfun or function() end

        -- 3 funzioni base per creare delle collisioni
        self.body = love.physics.newBody(World, x, y, "dynamic")
        self.shape = love.physics.newRectangleShape(width, height)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        self.body:setFixedRotation(true)

        -- ogni volta che faccio una collisione posso avere un riferimento di ogni entita' 
        self.fixture:setUserData({
            ent = self,
            class = "player or ball",
            beginContact = function(ent,b,coll)
                if ent.collfun then ent:collfun(b, coll) end
            end
        })
    end,
    draw = function(self)
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    end
}

return physicsComponent