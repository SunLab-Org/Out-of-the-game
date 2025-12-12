local module = {}
local path = "games/SimoneA/"

require "games/SimoneA/setup"
local love = require "love"
require "games/SimoneA/gameover"

local punteggio = 180

local power = 0
scale = 1.5

local carica = false

local smallFont = love.graphics.newFont(12)

local pallinaBianca = {
    x =2/3 * tavolo.w,
    y = tavolo.h/2,
    r = 7.5 * scale,
    vx = 0,
    vy = 0,
    hitrad = 50,
    sprite = love.graphics.newImage(path .. "sprites/Pallina_bianca.png")
}

local mazza = {
    x = 0,
    y = 0,
    rotation = 0,
    offsetX = 0,
    offsetY = 0,
    r = 40,
    sprite = love.graphics.newImage(path .. "sprites/Mazza.png")
}


function collisione(a, b)
    local dx = b.x - a.x
    local dy = b.y - a.y
    local distSq = dx * dx + dy * dy
    local radii = a.r + b.r

    local coll = math.sqrt(distSq) <= radii
    if not coll then
        return { coll = false }
    end

    local dist = math.sqrt(distSq)

    return {
        coll = true,
        dx = dx,
        dy = dy,
        dist = dist,
        overlap = radii - dist,
        angle = math.atan2(dy, dx)
    }
end


function module.load()
    love.mouse.setVisible(false)
    restart()
    mazza.offsetX = mazza.sprite:getWidth()
    mazza.offsetY = mazza.sprite:getHeight()
end

function module.update(dt)
    if GameOver then
        return
    end

    punteggio = punteggio - dt

    if carica then
        power = power + dt/10
        if power > 8 then power = 8 end
    end

    pallinaBianca.x = pallinaBianca.x + pallinaBianca.vx * dt
    pallinaBianca.y = pallinaBianca.y + pallinaBianca.vy * dt

    local mx, my = love.mouse.getPosition()
    mazza.x = mx
    mazza.y = my

    mazza.rotation = math.atan2(
        pallinaBianca.y - mazza.y,
        pallinaBianca.x - mazza.x
    )

    pallinaBianca.vx = pallinaBianca.vx * 0.98
    pallinaBianca.vy = pallinaBianca.vy * 0.98

    for _, pallina in ipairs(palline) do
        pallina.x = pallina.x + pallina.vx * dt
        pallina.y = pallina.y + pallina.vy * dt

        pallina.vx = pallina.vx * 0.98
        pallina.vy = pallina.vy * 0.98
    end

    for _, pallina in ipairs(palline) do
        local coll = collisione(pallinaBianca, pallina) 
        if coll.coll then
            bounce(pallinaBianca, pallina, coll)
        end

    end

    for _, pallina in ipairs(palline) do
        for _, pallina2 in ipairs(palline) do
            if not(pallina == pallina2) then
                local coll = collisione(pallina, pallina2)
                if coll.coll then
                    bounce(pallina, pallina2, coll)
                end
            end
        end
        if pallina.x - pallina.r < tavolo.x or pallina.x + pallina.r > tavolo.x + tavolo.w then
            pallina.vx = -pallina.vx
        end
        if pallina.y - pallina.r < tavolo.y or pallina.y + pallina.r > tavolo.y + tavolo.h then
            pallina.vy = -pallina.vy
        end

    end

    --buca

    for i, pallina in ipairs(palline) do
        for _, buca in ipairs(buche) do
            local coll = collisione(pallina, buca)
            if coll.coll then
                table.remove(palline, i)
            end
        end
    end

    for _, buca in ipairs(buche) do
        local coll = collisione(pallinaBianca, buca)
        if coll.coll then
            GameOver = true
        end
    end

    if pallinaBianca.x - pallinaBianca.r < tavolo.x or pallinaBianca.x + pallinaBianca.r > tavolo.x + tavolo.w then
            pallinaBianca.vx = -pallinaBianca.vx
    end
    if pallinaBianca.y - pallinaBianca.r < tavolo.y or pallinaBianca.y + pallinaBianca.r > tavolo.y + tavolo.h then
        pallinaBianca.vy = -pallinaBianca.vy
    end

    if #palline == 0 and not GameWon and not GameOver then
        GameWon = true
        GameOver = true
    end


    if love.mouse.isDown("1") then
        power = power + 10*dt
    else 
        power = 0
    end
end


function module.draw()
    
    GameOverDraw(punteggio)
    if GameOver then return end

    local table_x_scale = VIRTUAL_WIDTH/tavolo.sprite:getWidth()

    love.graphics.draw(tavolo.sprite, 0, 0, 0, table_x_scale , table_x_scale)
    
    -- love.graphics.rectangle("line", tavolo.x, tavolo.y, tavolo.w, tavolo.h)
   
    love.graphics.draw(
        mazza.sprite,
        mazza.x,
        mazza.y,
        mazza.rotation,
        scale + 1,
        scale + 1,
        mazza.offsetX,
        mazza.offsetY
    )

    love.graphics.setColor(1,1,1)

    local sprite_w = pallinaBianca.sprite:getWidth()
    local sprite_h = pallinaBianca.sprite:getHeight()

    for _, pallina in ipairs(palline) do
        -- love.graphics.circle("line", pallina.x, pallina.y, pallina.r)
        love.graphics.draw(
            pallina.sprite,
            pallina.x,
            pallina.y,
            0,
            scale,
            scale,
            sprite_w/2,
            sprite_h/2
        )
    end

    -- love.graphics.circle("line", pallinaBianca.x, pallinaBianca.y, pallinaBianca.r)

    love.graphics.draw(
        pallinaBianca.sprite,
        pallinaBianca.x,
        pallinaBianca.y,
        0,
        scale,
        scale,
        sprite_w/2,
        sprite_h/2
    )

    -- love.graphics.circle("line", pallinaBianca.x, pallinaBianca.y, pallinaBianca.hitrad)

    love.graphics.setFont(smallFont)
    love.graphics.print("punteggio: "..math.floor(punteggio), 0, VIRTUAL_HEIGHT * 2/3)


    -- Disegno buche
    love.graphics.setColor(0, 0, 0)  
    for _, h in ipairs(buche) do
        love.graphics.circle("fill", h.x, h.y, h.r)
    end
    love.graphics.setColor(1, 1, 1)

    
end

function module.mousepressed(mx, my, button)

    GameOver_mousepressed(mx, my, button, restart)

    if button ~= 1 then return end

    carica = true

end

function module.mousereleased(mx, my, button)
    if button ~= 1 then return end

    carica = false

    local cx = pallinaBianca.x
    local cy = pallinaBianca.y

    local dx = mx - cx
    local dy = my - cy
    local len = math.sqrt(dx * dx + dy * dy)

    if len == 0 then return end

    local nx = -dx / len
    local ny = -dy / len

    if len <= pallinaBianca.hitrad then
        pallinaBianca.vx = 200 * power * nx
        pallinaBianca.vy = 200 * power * ny
    end

    power = 0
end

function bounce(a,b, coll)
    -- Differenza delle posizioni
    local dx = b.x - a.x
    local dy = b.y - a.y
    local dist = math.sqrt(dx*dx + dy*dy)

    if dist == 0 then return end -- evita divisioni per zero

    -- Vettore normale (direzione dell'impatto)
    local nx = dx / dist
    local ny = dy / dist

    -- Vettore tangente (perpendicolare alla normale)
    local tx = -ny
    local ty = nx

    -- Proiezione delle velocità sulla normale e tangente
    local a_n = a.vx * nx + a.vy * ny
    local a_t = a.vx * tx + a.vy * ty

    local b_n = b.vx * nx + b.vy * ny
    local b_t = b.vx * tx + b.vy * ty

    -- Collisione elastica (masse uguali): scambio delle componenti normali
    local a_n_after = b_n
    local b_n_after = a_n

    -- Riconversione nelle coordinate X/Y
    a.vx = a_n_after * nx + a_t * tx
    a.vy = a_n_after * ny + a_t * ty

    b.vx = b_n_after * nx + b_t * tx
    b.vy = b_n_after * ny + b_t * ty

    -- Correzione dell'eventuale sovrapposizione (push-out)
    local overlap = (a.r + b.r) - dist
    if overlap > 0 then
        a.x = a.x - nx * (overlap / 2)
        a.y = a.y - ny * (overlap / 2)

        b.x = b.x + nx * (overlap / 2)
        b.y = b.y + ny * (overlap / 2)
    end
end

function module.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

end

function restart()
    print("restart")
    Restart()
    GameOver = false
    GameWon = false
    punteggio = 180
    pallinaBianca.x = 2/3 * tavolo.w
    pallinaBianca.y = tavolo.h/2
    pallinaBianca.vx = 0
    pallinaBianca.vy = 0
end

return module