local sti = require "libraries.Simple-Tiled-Implementation.sti"
local signal = require "libraries.hump.signal"

Maploader = {}

function Maploader:loadMap(filepath)
    self.map = sti("graphics/maps/"..filepath..".lua", {"box2d"})
    -- self.map:box2d_init(World)
    
    self:loadFixturesFromMap(self.map)
    
end

function Maploader:drawBack()
    -- self.map:draw()
    -- sti fa disegna le cose insieme alla telecamera solo se disegna un layer per volta
    self.map:drawLayer(self.map.layers["graphics.back"])
    
end

function Maploader:drawFront()
    self.map:drawLayer(self.map.layers["graphics.walls"])
    self.map:drawLayer(self.map.layers["graphics.highlight"])
end

function Maploader:loadFixturesFromMap(map)
    for _, layer in ipairs(map.layers) do
        if layer.type == "objectgroup" and layer.name == "collisions" then
            for _, obj in ipairs(layer.objects) do
                -- Calculate center position (Box2D uses center origin)
                local cx = obj.x + obj.width / 2
                local cy = obj.y + obj.height / 2

                -- Create a static body
                local body = love.physics.newBody(World, cx, cy, "static")

                -- Create a shape based on object size
                local shape = love.physics.newRectangleShape(obj.width, obj.height)

                -- Create the fixture
                local fixture = love.physics.newFixture(body, shape)

                -- Set fixture properties from Tiled custom properties
                fixture:setUserData({
                    class = obj.properties["class"] or layer.properties["class"] or "wall",
                    collidable = true
                })

            end
        end

        if layer.type == "objectgroup" and layer.name == "interaction" then
            for _, obj in ipairs(layer.objects) do
                -- Calculate center position (Box2D uses center origin)
                local cx = obj.x + obj.width / 2
                local cy = obj.y + obj.height / 2

                -- Create a static body
                local body = love.physics.newBody(World, cx, cy, "static")

                -- Create a shape based on object size
                local shape = love.physics.newRectangleShape(obj.width, obj.height)

                
                -- Create the fixture
                local fixture = love.physics.newFixture(body, shape)
                fixture:setSensor(true)

                local currFixture = fixture

                -- Set fixture properties from Tiled custom properties
                fixture:setUserData({
                    class = layer.properties["class"] or "Ground",
                    collidable = false,
                    Player = obj.properties["Player"] or 1,
                    beginContact = function(ent, b, coll)
                        local ub =  b:getUserData()
                        local player = currFixture:getUserData().Player
                        print(currFixture:getUserData().collidable)
                    
                        if player then
                            signal.emit("score_" .. player)
                        else
                            print("Warning: Collision occurred but no player ID found.")
                        end
                    end
                    
                })

            end
        end
    end
end

return Maploader



