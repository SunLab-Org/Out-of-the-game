local module = {}

require "games/AlanB/gameover"

local accelerazione = 500

local smallFont = love.graphics.newFont(28)
love.graphics.setFont(smallFont)

local turno = true
local timer = 10
local velcolpo = 400
local sparo = false
local vincitore = ""

local carro = {
    x = 100,
    y = 300,
    vx = 0,
    vy = 0,
    w = 50,
    h = 30,
    hp = 3,
    tcaduta = 0,
    -- inclinazione dei cannoni
    inclinazione = 45
}

local carro2 = {
    x = VIRTUAL_WIDTH - 150,
    y = 300,
    vx = 0,
    vy = 0,
    w = 50,
    h = 30,
    hp = 3,
    tcaduta = 0,
    inclinazione = 135
}

local colpi = {}

local altezza, larghezza = 0, 0
local terreno = {}
local barriera = {}


function module.load()
    larghezza = VIRTUAL_WIDTH
    altezza =  VIRTUAL_HEIGHT

    terreno = {
        x = 0, 
        y = 4/5 * altezza,
        w = larghezza, 
        h = 1/5 * altezza
    }

    barriera = {
        x = larghezza / 2 - 10,
        y = 100, 
        w = 20,
        h = 100,
        vy = 100
    }
end

function module.update(dt)
    if GameOver then return end

    if not sparo then timer = timer - dt end
    if timer <= 0 then
        timer = 10
        turno = not turno
    end

    -- barriera si muove
    barriera.y = barriera.y + barriera.vy * dt
    if barriera.y + barriera.h> terreno.y or barriera.y < 100 then
        barriera.vy = - barriera.vy
    end

    -- ___________________ CARRO 1 ___________________
    carro.vx = 0
    if turno and not sparo then
        if (love.keyboard.isDown("d")) then
            carro.vx = carro.vx + 100
        end

        if (love.keyboard.isDown("a")) then
            carro.vx = carro.vx - 100
        end
        -- inserire il movimento del cannone
        if love.keyboard.isDown("w") then 
            carro.inclinazione = carro.inclinazione + 20 * dt
            if carro.inclinazione >= 150 then carro.inclinazione = 150 end
        end

        if love.keyboard.isDown("s") then 
            carro.inclinazione = carro.inclinazione - 20 * dt
            if carro.inclinazione <= 30 then carro.inclinazione = 30 end
        end
    end
    
    if carro.x >= 0 and carro.vx<0 then 
        carro.x = carro.x + carro.vx * dt
    end 
    if carro.vx > 0 and carro.x <= VIRTUAL_WIDTH - carro.w then 
        carro.x = carro.x + carro.vx * dt
    end

    if(not(Collisione(carro, terreno))) then
        carro.tcaduta = carro.tcaduta + dt
        carro.vy = carro.vy + accelerazione * carro.tcaduta * dt
    else
        carro.vy = 0
    end

    carro.y = carro.y + carro.vy * dt

    -- ___________________ CARRO 2 ___________________
    carro2.vx = 0

    if not turno and not sparo then
        if (love.keyboard.isDown("l")) then
        carro2.vx = carro2.vx + 100
        end

        if (love.keyboard.isDown("j")) then
            carro2.vx = carro2.vx - 100
        end

        if love.keyboard.isDown("i") then 
            carro2.inclinazione = carro2.inclinazione - 20 * dt
            if carro2.inclinazione >= 150 then carro2.inclinazione = 150 end
        end

        if love.keyboard.isDown("k") then 
            carro2.inclinazione = carro2.inclinazione + 20 * dt
            if carro2.inclinazione <= 30 then carro2.inclinazione = 30 end
        end
    end
    
    if carro2.x >= 0 and carro2.vx < 0 then 
        carro2.x = carro2.x + carro2.vx * dt
    end 
    if carro2.vx > 0 and carro2.x <= VIRTUAL_WIDTH - carro2.w then 
        carro2.x = carro2.x + carro2.vx * dt
    end

    if(not(Collisione(carro2, terreno))) then
        carro2.tcaduta = carro2.tcaduta + dt
        carro2.vy = carro2.vy + accelerazione * carro2.tcaduta * dt
    else
        carro2.vy = 0
    end

    carro2.y = carro2.y + carro2.vy * dt

    -- print( Collisione(carro, terreno) )

    -- ___________________COLPI____________________

    for index, c in ipairs(colpi) do
        if(not(Collisione(c, terreno)) and not(Collisione(c, barriera))) then
            c.tcaduta = c.tcaduta + dt
            c.vy = c.vy + accelerazione * c.tcaduta * dt
        else
            table.remove(colpi, index)
        end

        if c.x <= 0 or c.x >= VIRTUAL_WIDTH then
            table.remove(colpi, index)
        end

        if Collisione(c, carro) and c.shooter == carro2 then
            carro.hp = carro.hp -1
            table.remove(colpi, index)
        end

        if Collisione(c, carro2) and c.shooter == carro then
            carro2.hp = carro2.hp -1
            table.remove(colpi, index)
        end

        c.y = c.y + c.vy * dt
        c.x = c.x + c.vx * dt
    end

    if #colpi == 0 then sparo = false end

    if carro.hp == 0 then 
        vincitore = "Giocatore 2" 
        GameOver = true
    end
    if carro2.hp == 0 then 
        vincitore = "Giocatore 1" 
        GameOver = true
    end

end

function module.draw()
    GameOverDraw(vincitore)
    if GameOver then return end

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", terreno.x, terreno.y, terreno.w, terreno.h)

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", carro.x, carro.y, carro.w, carro.h)

    -- __________ disegnamo il cannone 1 ________________
    love.graphics.push()

    -- Sposta il "punto di rotazione" (centro del rettangolo)
    love.graphics.translate(carro.x + carro.w/2, carro.y + carro.h/2)

    -- Ruota di 45 gradi (in radianti)
    love.graphics.rotate(math.rad(-carro.inclinazione))

    -- Disegna il rettangolo centrato sull'origine
    love.graphics.rectangle("fill", 0, -10, 50, 20)

    love.graphics.pop()


    love.graphics.setColor(0,0,1)
    love.graphics.rectangle("fill", carro2.x, carro2.y, carro2.w, carro2.h)

    -- __________ disegnamo il cannone 1 ________________
    love.graphics.push()

    -- Sposta il "punto di rotazione" (centro del rettangolo)
    love.graphics.translate(carro2.x + carro2.w/2, carro2.y + carro2.h/2)

    -- Ruota di 45 gradi (in radianti)
    love.graphics.rotate(math.rad(-carro2.inclinazione))

    -- Disegna il rettangolo centrato sull'origine
    love.graphics.rectangle("fill", 0, -10, 50, 20)

    love.graphics.pop()

    love.graphics.setColor(1,1,1)
    love.graphics.print("Vite: "..carro.hp, 0, 0)
    love.graphics.print("Vite: "..carro2.hp, VIRTUAL_WIDTH - 100, 0)
    
    local giocatore = "Rosso"
    if not turno then giocatore = "Blu" end
    love.graphics.print("E' il turno di Giocatore " .. giocatore, 0, 50)
    love.graphics.print("Tempo: ".. math.floor(timer), 0, 100)

    love.graphics.setColor(1, 0.3, 0)
    for _, c in ipairs(colpi) do
        love.graphics.rectangle("line", c.x, c.y, c.w, c.h)
    end

    love.graphics.rectangle("fill", barriera.x, barriera.y, barriera.w, barriera.h)


end

function module.keypressed(key)

    if (key == "f") and turno and not sparo then
        -- spara 1
        table.insert(colpi,
            {
                x = carro.x + carro.w/2,
                y = carro.y + carro.h/2,
                w = 10,
                h = 10,
                vx = velcolpo * math.cos(math.rad(carro.inclinazione)),
                vy = - velcolpo * math.sin(math.rad(carro.inclinazione)),
                shooter = carro,
                tcaduta = 0
            }
        )
        sparo = true
        turno = false
        timer = 10
    end

    if ( key == "h") and not turno and not sparo then
        -- spara 2
        table.insert(colpi,
            {
                x = carro2.x + carro2.w/2,
                y = carro2.y + carro2.h/2,
                w = 10,
                h = 10,
                vx = velcolpo * math.cos(math.rad(carro2.inclinazione)),
                vy = - velcolpo * math.sin(math.rad(carro2.inclinazione)),
                shooter = carro2,
                tcaduta = 0
            }
        )
        sparo = true
        turno = true
        timer = 10
    end

    if key == "escape" then
        love.event.quit()
    end
end


function module.mousepressed(x,y, button) 
    GameOver_mousepressed(x,y,button, restart)
end


function Collisione(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h

    
end

function restart()
    turno = true
    timer = 10
    velcolpo = 200
    sparo = false
    vincitore = ""


    carro = {
        x = 100,
        y = 300,
        vx = 0,
        vy = 0,
        w = 50,
        h = 30,
        hp = 3,
        tcaduta = 0,
        -- inclinazione dei cannoni
        inclinazione = 45
    }

    carro2 = {
        x = VIRTUAL_WIDTH - 150,
        y = 300,
        vx = 0,
        vy = 0,
        w = 50,
        h = 30,
        hp = 3,
        tcaduta = 0,
        inclinazione = 135
    }

    colpi = {}

end


-- Export the module
return module