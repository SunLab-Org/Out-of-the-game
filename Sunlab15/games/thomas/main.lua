local module = {}

-- Definizione delle dimensioni virtuali dello schermo
local GRID_SIZE = 20

local coso = {
    x = VIRTUAL_WIDTH / 2, -- Posizione iniziale centrata
    y = VIRTUAL_HEIGHT / 2, -- Posizione iniziale centrata
    vx = 0,
    vy = 0,
    width = GRID_SIZE,
    height = GRID_SIZE,
    fermo = false
}
local snake = {}
table.insert(snake, coso)

function copiaCoso () 
    local len = #snake
    return {
        -- Copia la posizione dell'ultima parte della coda
        x = snake[len].x,
        y = snake[len].y,
        width = GRID_SIZE,
        height = GRID_SIZE,
        vx = 0,
        vy = 0,
        fermo = true -- Marcalo come "fermo" finché non viene spostato
    }
end

-- Posizione iniziale casuale della mela (deve essere allineata alla griglia)
local function random_grid_pos(max_dim)
    local pos = math.random(0, max_dim - GRID_SIZE)
    return pos - pos % GRID_SIZE
end

local xmela = random_grid_pos(VIRTUAL_WIDTH)
local ymela = random_grid_pos(VIRTUAL_HEIGHT)

local mela = {
    x = xmela,
    y = ymela,
    height = GRID_SIZE,
    width = GRID_SIZE
}

-- spawn a mela in a free cell (not on the snake). Returns x,y or nil if no free cell.
function spawn_mela()
    local grid = GRID_SIZE
    local attempts = 100

    -- build occupancy map for O(1) checks
    local occ = {}
    for i = 1, #snake do
        occ[snake[i].x .. "," .. snake[i].y] = true
    end

    -- try random sampling first (fast when many free cells)
    for t = 1, attempts do
        -- L'intervallo è da 0 a (VIRTUAL_WIDTH - grid) / grid (o VIRTUAL_HEIGHT)
        local gx = math.random(0, (VIRTUAL_WIDTH - grid) / grid) * grid
        local gy = math.random(0, (VIRTUAL_HEIGHT - grid) / grid) * grid
        if not occ[gx .. "," .. gy] then
            return gx, gy
        end
    end

    -- fallback: build full free list and pick one
    local free = {}
    for gx = 0, VIRTUAL_WIDTH - grid, grid do
        for gy = 0, VIRTUAL_HEIGHT - grid, grid do
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

local cavolo = 0 -- Stato di gioco: 0 = in gioco, 1 = Game Over
local vittoria = 0 -- 0 = non vinta, 1 = vinta
local menu = false -- Stato del menu
local v = 7 -- Velocità
local punteggio = 0
local inizio = 0 -- 0 = schermata iniziale, 1 = gioco avviato
local canChangeDirection = true
local coll2 = false -- Aggiunto per coerenza con l'uso in AABBsnake

-- Funzione di collisione AABB (Axis-Aligned Bounding Box) per mela
function AABBmela()
    
    local coll = coso.x < mela.x + mela.width and
    coso.x + coso.width > mela.x and
    coso.y < mela.y + mela.height and
    coso.y + coso.height > mela.y 

    return coll
end

-- Funzione di collisione AABB (testa vs corpo del serpente)
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
    coll2 = false -- Reimposta se non c'è collisione
    return false
end

-- Funzione di collisione con il muro
function AABBmuro()
    if coso.x >= VIRTUAL_WIDTH or coso.x < 0 or coso.y >= VIRTUAL_HEIGHT or coso.y < 0 then
        return 1
    end
    return 0
end


function module.load()
end

local timer = 1
function module.update(dt)
    -- Controlla collisioni
    local muro_hit = AABBmuro()
    if muro_hit == 1 then
        cavolo = 1
    end
    
    if AABBsnake() then 
        cavolo = 1
    end
    
    -- Gestione della mela
    if AABBmela() then
        -- Aggiunge una nuova parte del corpo (copia dell'ultima)
        table.insert(snake, copiaCoso())
        
        -- Prova a spawnare una nuova mela
        local nx, ny = spawn_mela()
        if nx == nil then
            -- nessuno spazio libero: considera vittoria
            vittoria = 1
            v = 0 -- Ferma il gioco
        else
            mela.x = nx
            mela.y = ny
        end
        punteggio = punteggio + 5
    end


    -- Logica di movimento temporizzata
    timer = timer - dt * v
    if timer < 0 then
        -- Movimento del corpo (segue la testa)
        local len = #snake
        -- Sposta ogni segmento alla posizione del segmento precedente
        while len > 1 do
            snake[len].x = snake[len - 1].x
            snake[len].y = snake[len - 1].y
            snake[len].fermo = false -- Non è più fermo, è in movimento

            len = len - 1
        end     

        -- Movimento della testa (`snake[1]`)
        if not snake[1].fermo then
            snake[1].x = snake[1].x + snake[1].vx
            snake[1].y = snake[1].y + snake[1].vy  
        end
        timer = 1
        -- Permetti un cambio di direzione per ciclo di movimento
        canChangeDirection = true
    end

    
    if cavolo == 1 then
        coso.vx = 0 
        coso.vy = 0
        canChangeDirection = false -- Blocca il movimento se Game Over
    end
    
    if punteggio == 2000 and vittoria == 0 then -- Gestione della vittoria basata sul punteggio
        vittoria = 1
        v = 0
    end
end

function module.keypressed(key)
    -- Gestione del cambio di direzione
    local function try_change_direction(pvx, pvy)
        -- Permette il cambio solo se il gioco è attivo, non Game Over, e il menu è chiuso
        if canChangeDirection and cavolo ~= 1 and inizio ~= 0 and menu == false then
            -- Evita di muoversi immediatamente all'indietro
            if not (pvx == -coso.vx and pvy == -coso.vy) then
                coso.vx = pvx
                coso.vy = pvy
                canChangeDirection = false -- Consuma il cambio di direzione
            end
        end
    end
    
    local dx = GRID_SIZE -- La velocità orizzontale/verticale è la dimensione della griglia
    local dy = GRID_SIZE

    if (key == "right" or key == "d") and coso.vx == 0 then
        try_change_direction(dx, 0)
    end
    if (key == "left" or key == "a") and coso.vx == 0 then
        try_change_direction(-dx, 0)
    end
    if (key == "up" or key == "w") and coso.vy == 0 then
       try_change_direction(0, -dy)
    end
    if (key == "down" or key == "s") and coso.vy == 0 then
        try_change_direction(0, dy)
    end
    
    -- Tasto SPACE per ricominciare (dopo Game Over)
    if key == "space" and cavolo == 1 then
        cavolo = 0
        vittoria = 0
        coso.x = VIRTUAL_WIDTH / 2
        coso.y = VIRTUAL_HEIGHT / 2
        coso.vx = 0
        coso.vy = 0
        
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
    
    -- Tasto SPACE per iniziare (dalla schermata iniziale)
    if key == "space" and inizio == 0 then
        cavolo = 0
        vittoria = 0
        coso.x = VIRTUAL_WIDTH / 2
        coso.y = VIRTUAL_HEIGHT / 2
        
        local nx, ny = spawn_mela()
        if nx and ny then
            mela.x = nx
            mela.y = ny
        end
        punteggio = 0
        inizio = 1
        canChangeDirection = true
    end
    
    -- Menu (ESCAPE)
    if key == "p" then
        menu = not menu -- Toggle menu
        if menu == true then
            coso.vx = 0
            coso.vy = 0 -- Blocca il serpente nel menu
        end
    elseif menu == true then
        -- Se il menu è aperto, gestisci le opzioni di velocità
        local new_v = nil
        if key == "1" then
            new_v = 5
        elseif key == "2" then
            new_v = 7
        elseif key == "3" then
            new_v = 9
        end
        
        if new_v then
            v = new_v
            -- Reset del gioco alla nuova velocità
            coso.x = VIRTUAL_WIDTH / 2
            coso.y = VIRTUAL_HEIGHT / 2
            coso.vx = 0
            coso.vy = 0
            punteggio = 0
            vittoria = 0
            cavolo = 0
            snake = {}
            table.insert(snake, coso)
            
            local nx, ny = spawn_mela()
            if nx and ny then
                mela.x = nx
                mela.y = ny
            end
            
            menu = false -- Chiudi il menu
            inizio = 1 -- Assicurati che il gioco sia avviato
            canChangeDirection = true
        end
    end
end

function module.draw()
    -- Disegna il corpo del serpente
    for _, p in ipairs(snake) do
        if inizio ~= 0 and menu == false and cavolo ~= 1 and vittoria ~= 1 then
            love.graphics.setColor(0,1,0) -- Verde
            love.graphics.rectangle("fill", p.x, p.y, p.width, p.height)
        end
    end

    if inizio ~= 0 and menu == false and cavolo ~= 1 and vittoria ~= 1 then

        
        -- Disegna la mela
        love.graphics.setColor(1,0,0) -- Rosso
        love.graphics.rectangle("fill", mela.x, mela.y, mela.width, mela.height) 
        
        -- Stampa il punteggio
        love.graphics.setColor(1,1,1) -- Bianco
        love.graphics.print(punteggio, 0, 0, 0, 2, 2)
    end
    

    -- Schermata Game Over
    if cavolo == 1 and menu == false then
        love.graphics.setColor(1,0,0) -- Rosso
        love.graphics.setFont(fonts["creditsFont"])
        love.graphics.print("HAI PERSO", 
            VIRTUAL_WIDTH/2 - fonts["creditsFont"]:getWidth("HAI PERSO")/2,
            VIRTUAL_HEIGHT/3, 
        0)
        love.graphics.setFont(fonts["smallFont"])
        love.graphics.setColor(1,1,1) -- Bianco
        love.graphics.print("PREMI SPAZIO PER RICOMINCIARE", 
            VIRTUAL_WIDTH/2 - fonts["smallFont"]:getWidth("PREMI SPAZIO PER RICOMINCIARE")/2, 
            VIRTUAL_HEIGHT * 2 / 3, 
        0)
    end
    
    -- Schermata iniziale
    if inizio == 0 and menu == false then
        love.graphics.setColor(1,1,1) -- Bianco
        love.graphics.setFont(fonts["creditsFont"])
        love.graphics.print("PREMI SPAZIO PER INIZIARE", 
            VIRTUAL_WIDTH/2 - fonts["creditsFont"]:getWidth("PREMI SPAZIO PER INIZIARE")/2, 
            VIRTUAL_HEIGHT/2, 0)
    end
    
    -- Schermata vittoria
    if vittoria == 1 and menu == false and cavolo == 0 then
        love.graphics.setColor(0,1,0) -- Verde
        love.graphics.print("HAI VINTO!!", VIRTUAL_WIDTH / 2 - 200, 300, 0, 7, 7)
    end
    
    -- Menu di pausa
    if menu == true then
        local offset_y = 50
        
        love.graphics.setColor(0.1, 0.1, 0.1, 0.8) -- Sfondo scuro semitrasparente per il menu
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        
        love.graphics.setColor(1, 1, 1) -- Bianco
        love.graphics.print("MENU PAUSA", VIRTUAL_WIDTH / 2 - 150, 100, 0, 4, 4)
        love.graphics.print("Premi P per tornare al gioco", VIRTUAL_WIDTH / 2 - 150, 180, 0, 2, 2)
        love.graphics.print("SELEZIONA VELOCITA':", VIRTUAL_WIDTH / 2 - 150, 250, 0, 3, 3)

        -- Opzione 1: Facile
        love.graphics.setColor(0,0,1) -- Blu
        love.graphics.print("[1]", 0, VIRTUAL_HEIGHT / 2, 0, 4, 4)
        love.graphics.print("Facile", 0, VIRTUAL_HEIGHT / 2 + offset_y, 0, 4, 4)
        
        -- Opzione 2: Medio
        love.graphics.setColor(0,0,1) -- Blu
        love.graphics.print("[2]", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2, 0, 4, 4)
        love.graphics.print("Medio", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + offset_y, 0, 4, 4)
        
        -- Opzione 3: Difficile
        love.graphics.setColor(0,0,1) -- Blu
        love.graphics.print("[3]", VIRTUAL_WIDTH - 150, VIRTUAL_HEIGHT / 2, 0, 4, 4)
        love.graphics.print("Difficile", VIRTUAL_WIDTH - 150, VIRTUAL_HEIGHT / 2 + offset_y, 0, 4, 4)
    end
end

return module