require "games/MathiasB/gameover"
local module = {}
local basePath = "games/MathiasB/"

love.graphics.setDefaultFilter("nearest", "nearest")

local smallFont = love.graphics.newFont(12)

local buca = {
  x = 320,
  y = 240,
  w = 40, 
  h = 40,
  buche = 0,
  sprite = love.graphics.newImage(basePath.."Buca.png")
}

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
 sprite = love.graphics.newImage(basePath.."Mazza.png"),
}
mazza.w = mazza.sprite:getWidth()
mazza.h = mazza.sprite:getHeight()


local pallina = {}

local carica = 0
local r = 1

function module.load()
  love.mouse.setVisible(false)
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

    if love.mouse.isDown("1") and pallina.vx == 0 and pallina.vy == 0 then
        carica = math.min(carica + (100 * dt), 100) 
                local mx, my = love.mouse.getPosition()
    else
        mazza.rotation = 0
    end
    if carica == carica + 1 then suoni.suono2:play() end


    mazza.x, mazza.y = love.mouse.getPosition()
    mazza.y = mazza.y + mazza.h/2

    local p_h_s = pallina.h / 2
    local p_w_s = pallina.w / 2 
    
    if pallina.x <= p_w_s then 
        pallina.vx = - pallina.vx
        pallina.x = p_w_s
    end

    if pallina.y <= p_h_s then 
        pallina.vy = - pallina.vy 
        pallina.y = p_h_s
    end

    if pallina.x >= dimx - p_w_s then 
        pallina.vx = - pallina.vx
        pallina.x = dimx - p_w_s 
    end

    if pallina.y >= dimy - p_h_s then 
        pallina.vy = - pallina.vy
        pallina.y = dimy - p_h_s
    end

    local function apply_friction(v)
        if math.abs(v) < 5 then return 0 end 
        v = v * 0.98
        return v
    end

    pallina.vx = apply_friction(pallina.vx)
    pallina.vy = apply_friction(pallina.vy)

    if pallina.palline <= 0 then
        GameOver = true
    
    end
    end


function module.draw()
  
  local p_sprite = pallina.sprite
  local p_w = p_sprite:getWidth()
  local p_h = p_sprite:getHeight()
  

  local m_sprite = mazza.sprite
  local m_w = m_sprite:getWidth()
  local m_h = m_sprite:getHeight()
  
  local b_sprite = buca.sprite
  local b_w = b_sprite:getWidth()
  local b_h = b_sprite:getHeight()

  GameOverDraw(buca.buche)
  if GameOver then return end
  
  love.graphics.draw(sfondo.prato, 0, 0, 0, 10, 10)

  for _, ostacolo in ipairs(ostacoli) do
    local o_sprite = ostacolo.sprite
    local o_w = o_sprite:getWidth()
    local o_h = o_sprite:getHeight()
    love.graphics.draw(o_sprite, ostacolo.x, ostacolo.y, 0, 6, 6, o_w/2, o_h/2)
  end

  love.graphics.draw(p_sprite, pallina.x, pallina.y, 0, 3, 3, p_w/2, p_h/2)


  for i = 1, pallina.palline do
    love.graphics.draw(p_sprite, pallina.x2-(90 - i*30), pallina.y2, 0, 2, 2, p_w/2, p_h/2)
  end
  
  love.graphics.draw(b_sprite, buca.x, buca.y, 0, 4, 4, b_w/2, b_h/2)
  love.graphics.draw(m_sprite, mazza.x, mazza.y, mazza.rotation, 3, 3, m_w/2, m_h)
    
      love.graphics.print("Potenza: " .. math.floor(carica), 0, 0)
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
  if key == 1 and pallina.vx == 0 and pallina.vy == 0 then 
    local dx = pallina.x - mx
    local dy = pallina.y - my
    
    local l = math.sqrt(dx ^ 2 + dy ^ 2)
    if l > pallina.hitrad or carica < 1 then 
      carica = 0
      return 
    end
    
    suoni.suono2:play() 
    
    pallina.tiri = pallina.tiri + 1
    dx = dx / l
    dy = dy / l
  

    pallina.vx = carica * dx * 20
    pallina.vy = carica * dy * 20
    carica = 0
    
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
  carica = 0


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
  
  local p_sprite = love.graphics.newImage(basePath.."Pallina.png")

  pallina = {
    x = 100,
    y = 100,
    x2 = 150,
    y2 = 20,
    w = p_sprite:getWidth(), -- Usa le dimensioni dello sprite non scalate
    h = p_sprite:getHeight(), -- Usa le dimensioni dello sprite non scalate
    vx = 0,
    vy = 0,
    tiri = 0,
    hitrad = 150, -- Aumentato il raggio di tiro per dare più margine
    palline = 3,
    sprite = p_sprite
  }

end



return module