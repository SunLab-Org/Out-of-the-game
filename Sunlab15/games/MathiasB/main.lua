require "games/MathiasB/gameover"
local module = {}
local basePath = "games/MathiasB/"

love.graphics.setDefaultFilter("nearest", "nearest")

local smallFont = love.graphics.newFont(28)

local buca = {
  x = 320,
  y = 240,
  w = 40, 
  h = 40,
  buche = 0,
  sprite = love.graphics.newImage(basePath.."Buca.png")
}

--local record = buca.buche
local dimx = VIRTUAL_WIDTH
local dimy = VIRTUAL_HEIGHT

local suoni = {
  suono1 = love.audio.newSource(basePath.."Roccia.wav", "static"),
  suono2 = love.audio.newSource(basePath.."Mazza.wav", "static"),
  suono3 = love.audio.newSource(basePath.."Buca.wav", "static"),
  suono4 = love.audio.newSource(basePath.."Talpa.wav", "static")
}

local sfondo = {
  prato = love.graphics.newImage(basePath.."Prato.png")
}

local ostacoli = {}

local mazza = {
 x = 100, 
 y = 100,
 sprite = love.graphics.newImage(basePath.."Mazza.png")
}

local pallina = {}

local carica = 0
local r = 1

function module.load()
  -- VIRTUAL_HEIGHT =1080
  -- VIRTUAL_WIDTH = 1920
  -- love.window.resizable = true
  love.graphics.setFont(smallFont)
  restartGame()
end

function module.update(dt)
   dimx = VIRTUAL_WIDTH
   dimy = VIRTUAL_HEIGHT

    if GameOver then
      return
    end

   
    if AABB(buca, pallina) then
        buca.x = math.random(VIRTUAL_WIDTH)
        buca.y = math.random(VIRTUAL_HEIGHT)
        buca.buche = buca.buche + 1
        carica = 0
        pallina.tiri = 0
        pallina.vx = 0
        pallina.vy = 0
        pallina.x = 100
        pallina.y = 100
        suoni.suono3:play()

    
        if (#ostacoli < 19) then 
        table.insert(ostacoli, {
            x = math.random(VIRTUAL_WIDTH),
            y = math.random(VIRTUAL_HEIGHT),
            w = 30,
            h = 30,
            tipo = "talpa",
            sprite = love.graphics.newImage(basePath.."Talpa.png")
        })

        table.insert(ostacoli, {
            x = math.random(VIRTUAL_WIDTH),
            y = math.random(VIRTUAL_HEIGHT),
            w = 30,
            h = 30,
            tipo = "roccia",
            sprite = love.graphics.newImage(basePath.."Sasso.png")
        })

      end
    end



    for _, ostacolo in ipairs(ostacoli) do
        if AABB(pallina, ostacolo) then
            if ostacolo.tipo == "talpa" then
                pallina.x  = 100
                pallina.y = 100
                carica = 0
                suoni.suono4:play()
                pallina.vx = 0
                pallina.vy = 0
                pallina.palline = pallina.palline - 1
            end

            if ostacolo.tipo == "roccia" then
                pallina.vx = - pallina.vx
                pallina.vy = - pallina.vy
                suoni.suono1:play()
            end
        end
    end
   

    for i in pairs(ostacoli) do
      for j in pairs(ostacoli) do
        if (not i==j) and AABB(ostacoli[j], ostacoli[i]) then
          ostacoli[i].x = math.random(VIRTUAL_WIDTH)
          ostacoli[i].y = math.random(VIRTUAL_HEIGHT)
        end   
      end

      if AABB(buca, ostacoli[i]) then
        buca.x = math.random(VIRTUAL_WIDTH)
        buca.y = math.random(VIRTUAL_HEIGHT)
      end   
    end 


    pallina.y = pallina.y + pallina.vy * dt
    pallina.x = pallina.x + pallina.vx * dt

    if love.mouse.isDown("1") then
      if r < 100 then r = r + 30 else r = 100 end
    end


    if love.mouse.isDown("1") then
      carica = carica + 1
    end

    if carica >= 101 then
      carica = 0

    end

    if carica == carica + 1 then
      suoni.suono2:play()

    end

    mazza.x, mazza.y = love.mouse.getPosition()
    if pallina.x <= 0 then 
        pallina.vx = - pallina.vx
      
    end

    if pallina.y <= 0 then 
        pallina.vy = - pallina.vy 
    end

    if pallina.x >= dimx then 
        pallina.vx = - pallina.vx
    end

    if pallina.y >= dimy then 
        pallina.vy = - pallina.vy
    end

    if (pallina.vx > 0 ) then
        pallina.vx = pallina.vx - 5
        if pallina.vx < 0 then pallina.vx = 0 end
    end

    if (pallina.vy > 0 ) then
        pallina.vy = pallina.vy - 5
        if pallina.vy < 0 then pallina.vy = 0 end
    end

    if (pallina.vx < 0 ) then
        pallina.vx = pallina.vx + 5
        if pallina.vx > 0 then pallina.vx = 0 end
    end

    if (pallina.vy < 0 ) then
        pallina.vy = pallina.vy + 5
        if pallina.vy > 0 then pallina.vy = 0 end
    end

    if pallina.palline <= 0 then
        GameOver = true
    
    end
    end


function module.draw()

  GameOverDraw(buca.buche)
  if GameOver then return end
  
  
  -- sfondo
  love.graphics.draw(sfondo.prato, 0, 0, 0, 10, 10)

  -- ostacoli
  for _, ostacolo in ipairs(ostacoli) do
    love.graphics.draw(ostacolo.sprite, ostacolo.x-85, ostacolo.y-85, 0, 6, 6)
  end

    

  --palline
  love.graphics.draw(pallina.sprite, pallina.x-48, pallina.y-48, 0, 3, 3)

  for i = 1, pallina.palline do
    love.graphics.draw(pallina.sprite, pallina.x2-(90 - i*30), pallina.y2, 0, 2, 2)
  end
  

  --buca
    love.graphics.draw(buca.sprite, buca.x-70, buca.y-70, 0, 4, 4)
    
    --mazza
    love.graphics.draw(mazza.sprite, mazza.x-48, mazza.y-48, 0, 3, 3)
    
    --testo
      love.graphics.print("Potenza: " .. carica, 0, 0)
      love.graphics.print("Punteggio:" .. buca.buche, 200, 0)
      love.graphics.print("Tiri: " .. pallina.tiri, 600, 0)

      
end

function module.keypressed(key)
  if key == "escape" then
    returnToSelection()
  end
  
end

function module.mousepressed(x, y, key)
  GameOver_mousepressed(x, y, key, restartGame)
end

function module.mousereleased(mx, my, key)
  if key == 1 then 
    local dx = pallina.x - mx
    local dy = pallina.y - my
    suoni.suono2:play() 
    

      local l = math.sqrt(dx ^ 2 + dy ^ 2)
    
      if l > pallina.hitrad then return end
      
    
      pallina.tiri = pallina.tiri + 1
    dx = dx / l
    dy = dy / l
  
    pallina.vx = carica * dx * 15
    pallina.vy = carica * dy * 15
    carica = carica - carica
    
  end
end

function AABB(a, b)
  return a.x < b.x + b.w
     and a.x + a.w > b.x
     and a.y < b.y + b.h
     and a.y + a.h > b.y
end

function restartGame()
  GameOver = false
  buca.buche = 0


  ostacoli = {}

  table.insert(ostacoli, {
    x = 200,
    y = 200,
    w = 30,
    h = 30,
    tipo = "roccia",
    sprite = love.graphics.newImage(basePath.."Sasso.png")
  })

  table.insert(ostacoli, {
      x = 450,
      y = 350,
      w = 30,
      h = 30,
      tipo = "talpa",
      sprite = love.graphics.newImage(basePath.."Talpa.png")
  })

  pallina = {
    x = 100,
    y = 100,
    x2 = 250,
    y2 = 0,
    w = 15,
    h = 15,
    vx = 0,
    vy = 0,
    tiri = 0,
    hitrad = 50,
    palline = 3,
    sprite = love.graphics.newImage(basePath.."Pallina.png")
  }

end



return module