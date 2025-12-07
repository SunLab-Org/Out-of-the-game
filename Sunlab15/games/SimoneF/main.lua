local love = require "love"
require "gameover"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 800

local Immagine = love.graphics.newImage("Razzo.png")
local Image = love.graphics.newImage("Ostacolo.png")
local Im = love.graphics.newImage("Buco.png")

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


function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Razzo nello spazio')
    math.randomseed(os.time())

    restart()

    music = love.audio.newSource("Suono buco.wav", "static")
    suono = love.audio.newSource("Suono fiamma.wav", "static")

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    timer = timer - dt

    if GameOver then return end


    if love.keyboard.isDown("s") then
        spostamentoy = spostamentoy + 3
        spostamentoy = math.min(WINDOW_HEIGHT-88, spostamentoy)
    end

    if love.keyboard.isDown("w") then
        spostamentoy = spostamentoy - 3
        spostamentoy = math.max(0, spostamentoy)
    end

    if love.keyboard.isDown("a") then
        spostamentox = spostamentox - 3
        spostamentox = math.max(0, spostamentox)
    end

    if love.keyboard.isDown("d") then
        spostamentox = spostamentox + 3
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
        Buco.x = math.random(50, 1200)
        Buco.y = math.random(50, 750)
        spostamentoy = math.random(500, 650)
        spostamentox = math.random(50, 1200)
        Ostacolo = {}
        punti = punti + 1
    end

end

function love.draw()
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

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

end

function love.mousepressed(x,y, k)
    GameOver_mousepressed(x, y, k, restart)

end

function restart()
    spostamentoy = WINDOW_HEIGHT / 2
    spostamentox = WINDOW_WIDTH / 2
    tempo = 0.4
    timer = 1.5
    vel = 100
    w = 45
    h = 88

    Buco = {
        x = 700,
        y = 200,
        w = 32,
        h =  32
    }

    Ostacolo = {}
    punti = 0
end

