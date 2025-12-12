local love = require "love"

require "gameover"

local x = 50
local y = 50
local r = 25
local vx = 500
local vy = 500

local tempo = 0.6
local timer = 0.8
local punti = 0
flecie = 0
record = 0

 punti = 0

local vel = -100


love.graphics.setDefaultFilter("nearest", "nearest")


local flecie = {}
local sprite = love.graphics.newImage("flecia.png")


local pollo = {}
local spritePollo = love.graphics.newImage("pollozombibig.png")


local spritesfondo = love.graphics.newImage("sfondo.png")


function isColliding(f)
    local ax = x 
    local ay = y
    local aw = 60
    local ah = 60

    return ax < f.x + f.w and
           ax + aw > f.x and
           ay < f.y + f.h and
           ay + ah > f.y
end

function love.load()
    punti = 0
    record = 0

    music = love.audio.newSource("musica.wav", "static")

end

function love.update(dt)
    if GameOver then return end

    timer = timer - dt
    if love.keyboard.isDown("right") then
            x = x + vx * dt
            x = math.min(x,740)
    end
   
    if love.keyboard.isDown("left") then
            x = x - vx * dt
            x = math.max(x,0)
    end

    if #flecie > 0 then
        for _,flecia in ipairs(flecie) do
            flecia.y = flecia.y + vel * dt
        end
        if flecie[1].y < 0 then
            table.remove(flecie, 1)
        end

        for _,flecia in ipairs(flecie) do
            if isColliding(flecia) then
                GameOver = true
                music:play()
            end
        end

    end

    if timer < 0 then
        punti = punti + 1

        timer = tempo

        local random = math.random(30, 770)
        table.insert(flecie, {
            x = random,
            y = 600,
            w = 13,
            h = 48,
        })


        -- il gioco diventa difficile
        tempo = tempo - dt/5
        vel = vel - 15
    end
    


    
end


function reset() 

    x = 50
    y = 50
    r = 25
    vx = 300
    vy = 300

    tempo = 0.6
    timer = 0.8
    punti = 0
    flecie = 0



    vel = -100
    flecie = {}
end 


function love.draw()
    GameOverDraw(punti)
    
    if GameOver then return end
    
    love.graphics.draw(spritesfondo, 0, 0)
    
    love.graphics.draw(spritePollo, x-32, y)

    if #flecie > 0 then
        for _,flecia in ipairs(flecie) do
            love.graphics.draw(sprite, flecia.x, flecia.y, 0, 2, 2, 12, 5)
        end
    end
    love.graphics.print("punti: " .. punti, 0, 0)

    
end

function love.mousepressed(x, y, key)
    GameOver_mousepressed(x, y, key, reset)
end



