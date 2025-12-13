local module = {}

local coso = {
    x = 400,
    y = 400,
    vx = 0,
    vy = 0,
    width = 40,
    height = 40,
    fermo = false
}
local snake = {}
table.insert(snake, coso)
function copiaCoso () 
    local len = #snake
    return {
        x = snake[len].x,
        y = snake[len].y,
        width = 40,
        height = 40,
        vx = 0,
        vy = 0,
        fermo = true
    }
end

xmela = math.random(0,800)
xmela = xmela - xmela % 40
ymela = math.random(0,800)
ymela = ymela - ymela % 40

mela = {
    x = xmela,
    y = ymela,
    height = 40,
    width = 40
}
--spawn a mela in a free cell (not on the snake). Returns x,y or nil if no free cell.
function spawn_mela()
    local grid = 40
    local attempts = 100

    -- build occupancy map for O(1) checks
    local occ = {}
    for i = 1, #snake do
        occ[snake[i].x .. "," .. snake[i].y] = true
    end

    -- try random sampling first (fast when many free cells)
    for t = 1, attempts do
        local gx = math.random(0, (800 - grid) / grid) * grid
        local gy = math.random(0, (800 - grid) / grid) * grid
        if not occ[gx .. "," .. gy] then
            return gx, gy
        end
    end

    -- fallback: build full free list and pick one
    local free = {}
    for gx = 0, 800 - grid, grid do
        for gy = 0, 800 - grid, grid do
            if not occ[gx .. "," .. gy] then
                table.insert(free, {x = gx, y = gy})
            end
        end
    end
    if #free == 0 then
        return nil
    end
    local choice = free[math.random(1, #free)]
    return choice.x, choice.y
end
local ric = 0
local menu = false
local v = 7
local punteggio = 0
local inizio = 0
local canChangeDirection = true

function AABBmela()
    
    local coll = coso.x < mela.x + mela.width and
    coso.x + coso.width > mela.x and
    coso.y < mela.y + mela.height and
    coso.y + coso.height > mela.y 

    return coll
end

function AABBsnake()
    -- controlla collisione della testa (`coso`) con il corpo
    coll2 = false
    -- iterare gli elementi dal secondo in poi (saltando la testa)
    for i = 2, #snake do
        local cosetto = snake[i]
        if cosetto and not cosetto.fermo then
            local hit = coso.x < cosetto.x + cosetto.width and
                        coso.x + coso.width > cosetto.x and
                        coso.y < cosetto.y + cosetto.height and
                        coso.y + coso.height > cosetto.y
            if hit then
                coll2 = true
                return true
            end
        end
    end
    coll2 = false
    return false
end

function AABBmuro()
    local cavolo2 = 0
    if coso.x == 800 or coso.x < 0 then
        cavolo2 = cavolo2 + 1
    end
    if coso.y == 800 or coso.y < 0 then
        cavolo2 = cavolo2 + 1
    end
    return cavolo2
end


function module.load()
    love.window.setMode(800, 800)
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

local timer = 1
function module.update(dt)
    cavolo = AABBmuro(cavolo)
        if coll2 == true then
        cavolo = 1
    end
    if AABBmela() then
        table.insert(snake, copiaCoso())
        local nx, ny = spawn_mela()
        if nx == nil then
            -- nessuno spazio libero: considera vittoria
            vittoria = 1
            v = 0
        else
            mela.x = nx
            mela.y = ny
        end
        punteggio = punteggio + 5
    end
    if mela.x > 800 then
        mela.x = mela.x - 40
    end
    if mela.y > 800 then
        mela.y = mela.y - 40
    end

    if AABBsnake() then 
        cavolo = 1
    end

    timer = timer - dt * v
    if timer < 0 then
        local len = #snake
        while len > 1 do
            snake[len].x = snake[len - 1].x
            snake[len].y = snake[len - 1].y

            len = len - 1
            snake[len].fermo = false
        end     

        -- head     
        if not snake[1].fermo then
            snake[1].x = snake[1].x  +snake[1].vx
            snake[1].y = snake[1].y  +snake[1].vy  
        end
        timer = 1
        -- allow one direction change per movement tick
        canChangeDirection = true
    end

    
    if cavolo == 1 then
        coso.vx = 0 
        coso.vy = 0
        canChangeDirection = false
    end
    if punteggio == 2000 then
        vittoria = 1
        v = 0
    end
end

function module.keypressed(key)
    if (key == "right" or key == "d") and coso.vx == 0 and cavolo ~= 1 and inizio ~= 0 then
        if canChangeDirection then
            local pvx, pvy = 40, 0
            if not (pvx == -coso.vx and pvy == -coso.vy) then
                coso.vx = pvx
                coso.vy = pvy
                canChangeDirection = false
            end
        end
    end
    if (key == "left" or key == "a") and coso.vx == 0 and cavolo ~= 1 and inizio ~= 0 then
        if canChangeDirection then
            local pvx, pvy = -40, 0
            if not (pvx == -coso.vx and pvy == -coso.vy) then
                coso.vx = pvx
                coso.vy = pvy
                canChangeDirection = false
            end
        end
    end
    if (key == "up" or key == "w") and coso.vy == 0 and cavolo ~= 1 and inizio ~= 0 then
       if canChangeDirection then
           local pvx, pvy = 0, -40
           if not (pvx == -coso.vx and pvy == -coso.vy) then
               coso.vx = pvx
               coso.vy = pvy
               canChangeDirection = false
           end
       end
    end
    if (key == "down" or key == "s") and coso.vy == 0 and cavolo ~= 1 and inizio ~= 0 then
        if canChangeDirection then
            local pvx, pvy = 0, 40
            if not (pvx == -coso.vx and pvy == -coso.vy) then
                coso.vx = pvx
                coso.vy = pvy
                canChangeDirection = false
            end
        end
    end
    if key == "space" and cavolo == 1 then
        cavolo = 0
        coso.x = 400
        coso.y = 400
        local nx, ny = spawn_mela()
        if nx and ny then
            mela.x = nx
            mela.y = ny
        end
        punteggio = 0
        coll2 = false
        snake = {}
        table.insert(snake, coso)
        canChangeDirection = true
    end
    if key == "space" and inizio == 0 then
        cavolo = 0
        coso.x = 400
        coso.y = 400
        local nx, ny = spawn_mela()
        if nx and ny then
            mela.x = nx
            mela.y = ny
        end
        punteggio = 0
        inizio = 1
        canChangeDirection = true
    end
    if key == "escape" and menu == false then
        menu = true
        coso.vx = 0
        coso.vy = 0
    else
        menu = false
        if key == "1" then
            v = 5
            coso.x = 400
            coso.y = 400
            punteggio = 0
            snake = {}
        table.insert(snake, coso)
        end
        if key == "2" then
            v = 7
            coso.x = 400
            coso.y = 400
            punteggio = 0
            snake = {}
        table.insert(snake, coso)
        end
        if key == "3" then
            v = 9
            coso.x = 400
            coso.y = 400
            punteggio = 0
            snake = {}
        table.insert(snake, coso)
        end
    end
end

function module.draw()
    for _, p in ipairs(snake) do
        if inizio ~= 0 and menu == false then
            love.graphics.setColor(0,1,0)
            love.graphics.rectangle("fill", p.x, p.y, p.width, p.height)
        end
    end

    if inizio ~= 0 and menu == false then
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("fill", coso.x , coso.y, coso.width, coso.height)
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", mela.x, mela.y, mela.width, mela.height) 
        love.graphics.setColor(1,1,1)
        love.graphics.print(punteggio, 0, 0, 0, 2, 2)
    end
    if cavolo == 1 and menu == false then
        love.graphics.setColor(1,0,0)
        love.graphics.print("hai perso", 200, 300, 0, 7, 7)
        love.graphics.setColor(1,1,1)
        love.graphics.print("premi spazio per riprovare", 225, 400, 0, 2, 2)
    end
    if inizio == 0 and menu == false then
        love.graphics.setColor(1,1,1)
        love.graphics.print("premi spazio per iniziare", 25, 300, 0, 5, 5)
    end
    if vittoria == 1 and menu == false then
        love.graphics.setColor(0,1,0)
        love.graphics.print("hai vinto!!", 200, 300, 0, 7, 7)
    end
    if menu == true then
        love.graphics.setColor(0,0,1)
        love.graphics.print("[1]", 0, 400, 0, 4, 4)
        love.graphics.print("facile", 0, 450, 0, 4, 4)
        love.graphics.setColor(0,0,1)
        love.graphics.print("[2]", 300, 400, 0, 4, 4)
        love.graphics.print("medio", 300, 450, 0, 4, 4)
        love.graphics.setColor(0,0,1)
        love.graphics.print("[3]",625, 400, 0, 4, 4)
        love.graphics.print("difficile", 625, 450, 0, 4, 4)
    end
end

return module