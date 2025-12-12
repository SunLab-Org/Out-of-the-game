local love = require "love"
local module = {}
local path = "games/TommasoK/"

require "games/TommasoK/gameover"

local nemmicoimg
local ioimg
local colpoimg
local punti = 180
local timer = 1

local smallFont = love.graphics.newFont(28)
love.graphics.setFont(smallFont)

function module.load()

    love.graphics.setBackgroundColor(0, 0, 0)
    src1 = love.audio.newSource(path .. "Random4.wav", "static")
    ciao = love.audio.newSource(path .. "vict.mp3", "static")


    ioimg = love.graphics.newImage(path .. "png/steev.png")
    nemmicoimg = love.graphics.newImage(path .. "png/creeper.png")
    colpoimg = love.graphics.newImage(path .. "png/palla-di-fuoco.png")

    restart()
end

function module.update(dt)
    if GameOver then return end
    timer = timer - dt
    if timer < 0 then
        timer = 1
        punti = punti - 1
    end
    
    -- Movimento del giocatore
    if love.keyboard.isDown("left") then
        giocatore.x = giocatore.x - giocatore.velocita * dt
    elseif love.keyboard.isDown("right") then
        giocatore.x = giocatore.x + giocatore.velocita * dt
    end

    -- Impedire di uscire dallo schermo
    giocatore.x = math.max(0, math.min(VIRTUAL_WIDTH - giocatore.larghezza, giocatore.x))

    -- Sparo
    tempoSparo = tempoSparo - dt
    if love.keyboard.isDown("space") and tempoSparo <= 0 then
        local p = {
            x = giocatore.x + giocatore.larghezza / 2 - 2,
            y = giocatore.y,
            larghezza = 4,
            altezza = 10
        
        }
        src1:play()

        table.insert(proiettili, p)
        tempoSparo = ritardoSparo
    end

    -- Movimento proiettili
    for i = #proiettili, 1, -1 do
        local p = proiettili[i]
        p.y = p.y - 400 * dt
        if p.y < 0 then
            table.remove(proiettili, i)
        end
    end

    -- Movimento nemici
    local scendi = false
    for _, n in ipairs(nemici) do
        if n.vivo then
            n.x = n.x + velocitaNemici * direzioneNemici * dt
            if n.x < 0 or n.x + n.larghezza > 800 then
                scendi = true
            end
        end
    end
    if scendi then
        direzioneNemici = -direzioneNemici
        for _, n in ipairs(nemici) do
            n.y = n.y + 20
        end
    end

    -- Collisione proiettili-nemici
    for i = #proiettili, 1, -1 do
        local p = proiettili[i]
        for _, n in ipairs(nemici) do
            if n.vivo and collisione(p, n) then
                n.vivo = false
                table.remove(proiettili, i)
                break
            end
        end
    end

    someonealive = false
    for _, n in ipairs(nemici) do
        if n.vivo then 
            someonealive = true
        end 
    end

    for _, enemy in ipairs(nemici) do
        if collisione(giocatore, enemy) then
            GameOver = true
        end
    end

    if not someonealive then
        GameOver = true
        GameWon = true
        ciao:play()
    end
end

function module.draw()

    GameOverDraw(punti)

    if GameOver then return end

    -- Giocatore
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(ioimg, giocatore.x, giocatore.y)

    -- Proiettili
    love.graphics.setColor(1, 1, 1)
    for _, p in ipairs(proiettili) do
        love.graphics.draw(colpoimg, p.x, p.y)
    end

    -- Nemici
    love.graphics.setColor(1, 1, 1)
    for _, n in ipairs(nemici) do
        if n.vivo then
            love.graphics.draw(nemmicoimg, n.x, n.y)
        end
    end

    love.graphics.print("Punti: " .. punti, 0, 0)
end

function collisione(a, b)
    return a.x < b.x + b.larghezza and
      b.x < a.x + a.larghezza and
     a.y < b.y + b.altezza and
     b.y < a.y + a.altezza
    
end

function module.keypressed(key)
    if key == "escape" then love.event.quit() end
end

function module.mousepressed(x, y, button)
    GameOver_mousepressed(x, y, button, restart)
end


function restart()
    print("restart")
    punti = 180
    someonealive = false
       -- Giocatore
    giocatore = {
        x = 400,
        y = 550,
        larghezza = 50,
        altezza = 10,
        velocita = 300
    }

    -- Proiettili
    proiettili = {}

    -- Nemici
    nemici = {}
    local righe, colonne = 4, 8
    for i = 1, righe do
        for j = 1, colonne do
            local nemico = {
                x = 80 + (j - 1) * 80,
                y = 50 + (i - 1) * 50,
                larghezza = 40,
                altezza = 20,
                vivo = true
            }
            table.insert(nemici, nemico)
        end
    end

    direzioneNemici = 1
    velocitaNemici = 40
    tempoSparo = 0
    ritardoSparo = 0.4
end


return module