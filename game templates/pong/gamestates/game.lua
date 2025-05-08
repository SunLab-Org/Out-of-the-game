local entity = require "entities.entity"
local pc = require "entities.components.physics_component"
local pmc = require "entities.components.player_movement"
local sc = require "entities.components.sprite_component"
local signal = require "libraries.hump.signal"
require "entities.modules.collision_functions"
require "entities.modules.maploader"





World = love.physics.newWorld(0,0)



local game = {
    entities = {}
}

function game:enter()

    if #self.entities > 0 then return end
    local playercoll = pc(100, 200, 100, 10)
    local Player1 = entity(
        {
            physics = playercoll,
            movement = pmc(playercoll.body, 1),
            sprite1 = sc('graphics/tilesets/neo_zero_char_01.png', 9, 3, 1, 3, 1, 0.1, 0, 0, playercoll.body )
        }
    )

    local playercoll2 = pc(500, 200, 100, 10)
    local Player2 = entity(
        {
            physics = playercoll2,
            movement = pmc(playercoll2.body, 2)
        }
    )

    local ballcoll = pc(200, 200, 10, 10, Bounce)
    local ball = entity(
        {
            physics = ballcoll,
            sprite1 = sc('graphics/tilesets/neo_zero_char_01.png', 9, 3, 1, 3, 1, 10, 0, 0, ballcoll.body )

        }
    )
    ballcoll.body:setLinearVelocity(-200, 0)


    table.insert(self.entities, Player1)
    table.insert(self.entities, Player2)
    table.insert(self.entities, ball)
end

function game:update(dt)
    World:update(dt)
    for _, k in pairs(self.entities) do
        if k.update then k:update(dt) end
    end

end

function game:draw(dt)
    -- attenzione non fare sta cosa quando si fanno giochi in pixelart, blur e artefici grafici
    local width = love.graphics.getWidth()

    local scale = width / 640
    
    love.graphics.scale(scale)
    
    Maploader:drawBack()
    for _, k in pairs(self.entities) do
        if k.draw then k:draw() end
    end
    Maploader:drawFront()
    love.graphics.print("Player1: ".. _G._score1 .." Player2: " .. _G._score2, 500, 100)
end

function beginContact(a, b, coll)
    local ent1 = a:getUserData()
    local ent2 = b:getUserData()
    print(ent1.class, ent2.class)
    print("___________________")

    if ent1.beginContact then ent1.beginContact(ent1.ent, b, coll) else print("no beginContact") end
    if ent2.beginContact then ent2.beginContact(ent2.ent, a, coll) else print("no begincontact") end

    print("--------------")
end

World:setCallbacks(beginContact, endContact, preSolve, postSolve)

return game