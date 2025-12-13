local module = {}
local player = {x = 400, y = 600-32, w = 128, h = 32, speed =50} -- Esempio di un giocatore

-- enemy
Ginox = 20
Pinoy = 20


bullets = {}
bulletSpeed = 400
-- Carica le immagini (presumendo che tu le abbia)
local monsters = {}

local monsterImage
local bulletImage

    
function module.load()
    local numMonster = 20
    local gameWidth = VIRTUAL_WIDTH
    local gameHeight = VIRTUAL_HEIGHT
    local monsterWidth = 32 -- Assumi la larghezza del mostro
    local monsterHeight = 32 -- Assumi l'altezza del mostro
    for i = 1, 24,1 do
        -- Genera coordinate casuali per X e Y
        -- Limitiamo la posizione X tra 400 pixel e il bordo destro dello schermo
        local randomX = math.random(gameWidth / 2, gameWidth - monsterWidth)
        -- Limitiamo la posizione Y tra 0 e il bordo inferiore dello schermo
        local randomY = math.random(0, gameHeight - monsterHeight)

        -- Inserisci il nuovo mostro nella tabella
        table.insert(monsters, {
            x = randomX,
            y = randomY,
            w = monsterWidth,
            h = monsterHeight,
            health = 100 -- Ogni mostro ha 100 HP
        })
    end

    monsterImage = love.graphics.newImage("games/fabio/pixilart-drawing (2).png")
    bulletImage = love.graphics.newImage("games/fabio/pixilart-drawing (4).png")

    -- Crea un mostro iniziale per il test
    table.insert(monsters, {x = 600, y = 300, w = 32, h = 32, health = 100})
end


function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

function module.update(dt)
-- --- Logica di Movimento del Giocatore (Opzionale) ---
    if love.keyboard.isDown("left", "a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("right", "d") then
        player.x = player.x + player.speed * dt
    end
    -- Limita il giocatore entro lo schermo (opzionale)
    player.x = math.max(0, math.min(love.graphics.getWidth() - player.w, player.x))



    -- Aggiorna la posizione dei proiettili (presumendo che si muovano a destra)
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - 500 * dt -- 500 pixel al secondo
    end

    -- === GESTIONE DELLE COLLISIONI ===
    -- Scorri tutti i mostri
    for i, monster in ipairs(monsters) do
        -- Scorri tutti i proiettili
        for j, bullet in ipairs(bullets) do
            -- Controlla se il proiettile e il mostro esistono ancora (non sono nil)
            if monster and bullet then
                -- Usa la funzione di collisione AABB definita in precedenza
                if checkCollision(
                    monster.x, monster.y, monster.w, monster.h,
                    bullet.x, bullet.y, bullet.w, bullet.h
                ) then
                    -- Collisione avvenuta!

                    -- Rimuovi il proiettile dalla lista (segnandolo come nil per la pulizia)
                    bullets[j] = nil

                    -- Applica danno al mostro o rimuovilo (es. health = 0)
                    monster.health = monster.health - 50
                    if monster.health <= 0 then
                        monsters[i] = nil -- Rimuovi il mostro
                    end
                end
            end
        end
    end

    -- === PULIZIA DELLE LISTE ===
    -- Rimuove tutti gli elementi nil dalle tabelle in modo efficiente
    -- Questi sono i proiettili e i mostri che sono "morti" o hanno colliso
    for i = #bullets, 1, -1 do
        if not bullets[i] then
            table.remove(bullets, i)
        end
    end
    for i = #monsters, 1, -1 do
        if not monsters[i] then
            table.remove(monsters, i)
        end
    end
end


function module.keypressed(key)
    
   if key == "space" then
        -- Crea un nuovo proiettile dalla posizione del giocatore
        table.insert(bullets, {
            x = player.x + player.w/2, -- Partendo dal lato destro del giocatore
            y = player.y + player.h, -- Centrato verticalmente
            w = 16, -- Larghezza del proiettile
            h = 4   -- Altezza del proiettile
        })
    end
end


function module.draw()

    love.graphics.clear(0.1,0.2,0.3)
    -- Disegna i mostri
    for i, monster in ipairs(monsters) do
        love.graphics.draw(monsterImage, monster.x, monster.y)
    end

    -- Disegna i proiettili
    love.graphics.setColor(1,0.2,0.3)
    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bulletImage, bullet.x, bullet.y)
    end
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
end


return module