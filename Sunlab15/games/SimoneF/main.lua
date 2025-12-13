local love = require "love"

local module = {}
local path = "games/SimoneF/"
require "games/SimoneF/gameover"

-- settato direttamente qui
WINDOW_WIDTH = VIRTUAL_WIDTH
WINDOW_HEIGHT = VIRTUAL_HEIGHT

local Immagine = love.graphics.newImage(path .. "Razzo.png")
local Image = love.graphics.newImage(path .. "Ostacolo.png")
local Im = love.graphics.newImage(path .. "Buco.png")

local spostamentoy = WINDOW_HEIGHT / 2
local spostamentox = WINDOW_WIDTH / 2
local tempo = 0.4
local timer = 1.5
local vel = 100
local w = 45
local h = 88

local Buco = {}

local Ostacolo = {}
local punti = 0

love.graphics.setDefaultFilter("nearest", "nearest")

function isColliding(f)
    return spostamentox < f.x + f.w and
            spostamentox + w > f.x and
           spostamentoy < f.y + f.h and
           spostamentoy + h > f.y 
end


function module.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Razzo nello spazio')
    math.randomseed(os.time())

    restart()

    music = love.audio.newSource(path .. "Suono buco.wav", "static")
    suono = love.audio.newSource(path .. "Suono fiamma.wav", "static")

end

function module.update(dt)
    timer = timer - dt

    if GameOver then return end


    if love.keyboard.isDown("s") then
        spostamentoy = spostamentoy + 200 * dt
        spostamentoy = math.min(WINDOW_HEIGHT-88, spostamentoy)
    end

    if love.keyboard.isDown("w") then
        spostamentoy = spostamentoy - 200 * dt
        spostamentoy = math.max(0, spostamentoy)
    end

    if love.keyboard.isDown("a") then
        spostamentox = spostamentox - 200 * dt
        spostamentox = math.max(0, spostamentox)
    end

    if love.keyboard.isDown("d") then
        spostamentox = spostamentox + 200 * dt
        spostamentox = math.min(WINDOW_WIDTH-45, spostamentox)
    end 

    if #Ostacolo > 0 then 
        for _,o in ipairs(Ostacolo) do 
            o.y = o.y + vel * dt
        end 

        for _,o in ipairs(Ostacolo) do 
            if isColliding(o) then 
                suono:play()
                GameOver = true
            end 
        end

        if Ostacolo[1].y > VIRTUAL_HEIGHT then 
            table.remove(Ostacolo, 1)
        end
    end

    if timer < 0 then 
        timer = 0.2 + 1/tempo 
        local random = math.random(0, WINDOW_WIDTH)
        table.insert(Ostacolo, {
            x = random,
            y = 0,
            w = 32,
            h = 48,
        })

        tempo = tempo + dt*10
    end

    if isColliding(Buco) then 
        music:play()
        Buco.x = math.random(50, WINDOW_WIDTH - 50)
        Buco.y = math.random(50, WINDOW_HEIGHT - 50)
        spostamentoy = math.random(WINDOW_HEIGHT/2, WINDOW_HEIGHT - 100)
        spostamentox = math.random(50, WINDOW_WIDTH - 50)
        Ostacolo = {}
        punti = punti + 1
    end

end

function module.draw()
    GameOverDraw(punti)

    if GameOver then return end

    if #Ostacolo > 0 then 
        for _,o in ipairs(Ostacolo) do 
            love.graphics.draw(Image, o.x, o.y, 0, 2, 2)
        end
    end

    love.graphics.draw(Immagine, spostamentox, spostamentoy, 0, 2, 2)
    love.graphics.draw(Im, Buco.x, Buco.y, 0, 3, 3)
    love.graphics.print("Punteggio: " .. punti, 0, 0)

end

function module.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

end

function module.mousepressed(x,y, k)
    GameOver_mousepressed(x, y, k, restart)

end

function restart()
    spostamentoy = WINDOW_HEIGHT - h
    spostamentox = WINDOW_WIDTH / 2
    tempo = 0.4
    timer = 1.5
    vel = 100
    w = 45
    h = 88

    Buco = {
        x = VIRTUAL_WIDTH/2,
        y = VIRTUAL_HEIGHT/2,
        w = 32,
        h =  32
    }

    Ostacolo = {}
    punti = 0
end


return module
