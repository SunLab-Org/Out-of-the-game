local love = require "love"
local INF = math.huge
local TimerHandler = require "timerhandler"

Game = {
    physics = {
        gravity = 500
    },
    entities = {},
}

local playerGenerator = require "player"

function love.load()
    table.insert(Game.entities, playerGenerator.new(100, 100, 50, 50, 500))
end

function love.update(dt)
    TimerHandler:update(dt)
    for _, entity in pairs(Game.entities) do
        if entity.update then
            entity:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    for _, entity in ipairs(Game.entities) do
        if entity.draw then
            entity:draw()
        end
    end
end

-- sistema di collissioni classico usato anche in altri templates, si basa su AABB
-- e area di compenetrazione

function Game.checkCollision(a, b)
    if a == b then return nil end

    local collides =    a.x - a.width / 2 < b.x + b.width / 2 and
                        a.x + a.width / 2 > b.x - b.width / 2 and
                        a.y - a.height / 2 < b.y + b.height / 2 and
                        a.y + a.height / 2 > b.y - b.height / 2

    if collides == true then
        local overlap = Game.centerCollision(a,b)
        
        local coll = {}

        coll.normal = {nx = 0, ny = 0}
   
        if overlap.height > overlap.width then
            if overlap.cx > b.x then
                coll.normal.nx = 1
            else
                coll.normal.nx = -1
            end
            coll.normal.ny = 0
        else
            if overlap.cy > b.y then
                coll.normal.ny = 1
            else
                coll.normal.ny = -1
            end
            coll.normal.nx = 0
        end


        Game.transpose(a, overlap)
        
        return coll
    else
        return nil
    end

end

function Game.centerCollision(a,b)
    local a_left   = a.x - a.width / 2
    local a_right  = a.x + a.width / 2
    local a_top    = a.y - a.height / 2
    local a_bottom = a.y + a.height / 2

    local b_left   = b.x - b.width / 2
    local b_right  = b.x + b.width / 2
    local b_top    = b.y - b.height / 2
    local b_bottom = b.y + b.height / 2

    local overlap_left   = math.max(a_left, b_left)
    local overlap_right  = math.min(a_right, b_right)
    local overlap_top    = math.max(a_top, b_top)
    local overlap_bottom = math.min(a_bottom, b_bottom)

    

    local centerX = (overlap_left + overlap_right) / 2
    local centerY = (overlap_top + overlap_bottom) / 2
    local width = overlap_right - overlap_left
    local height = overlap_bottom - overlap_top

    return {
        cx = centerX, 
        cy = centerY,
        width = width,
        height = height
    }
        

end

function Game.transpose(a, overlap)
    local dx = a.x - overlap.cx
    local dy = a.y - overlap.cy

    if overlap.width < overlap.height then
        a.x = a.x + ( 1 + overlap.width) * (dx / math.abs(dx))
    else
        a.y = a.y + overlap.height * (dy / math.abs(dy))
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        Game.entities[1]:spacePressed()
    end
end