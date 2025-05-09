local love = require "love"

--[[
    Obiettivi: 
    - Migliorare il modo in cui il player si muove nello spazio
    - implementare la gravita'
    - non far cadere il player nell'oblio
]]

Game = {
    physics = {
        gravity = 500
    }
}

function love.load()
    Player = {
        x = 100,
        y = 100,
        width = 50,
        height = 50,
        speed = 100
    }

    function Player:draw()
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    end

    -- abbiamo spostato l'update in questa funzione
    --[[
        sono state tolte le funzioni che permettevano al personaggio di muoversi su e giu',
        li incontreremo piu' avanti, per ora concentriamoci sul creare una gravita'

        dentro questa cartella troverete anche un foglio in cui saranno scritte le varie formule
        usate per questo gioco, aggiornate mano a mano che le incontreremo

        aggiungiamo qua sotto a player la velocita' in direzione x e y
    ]]
    
    Player.Vx = 0
    Player.Vy = 0

    function Player:update(dt)
        if love.keyboard.isDown("a","left") then
            Player.x = Player.x - Player.speed * dt
        end
        if love.keyboard.isDown("d","right") then
            Player.x = Player.x + Player.speed * dt
        end

        --[[
            queste funzioni sono le leggi orarie del moto uniformemente accelerato
            come vediamo fanno gia' un bel lavoro, tuttavia notiamo alcune cose:
             1. il personaggio cade nell'oblio, vorremmo che si fermasse ad un certo punto,
                quindi dobbiamo implementare un sistema di collisioni
            Potremmo cercare di creare una piattaforma per poterlo fermare, quindi creiamo un oggettino
            simile al nostro player
        ]]
        
        --[[
            qui sorge un bel problema, infatti il personaggio ci passa attraverso senza problemi,
            i due oggetti non stanno collidendo, quindi vediamo di sistemare
            
            Creiamo la funzione checkCollision
            
            ora utilizziamo checkcollision per controllare se il personaggio tocca la piattaforma
        ]]
        if not Game.checkCollision(Player, Platform) then
            Player.y = Player.y + Player.Vy * dt + Game.physics.gravity / 2 * dt * dt
            Player.Vy = Player.Vy + Game.physics.gravity * dt
        else
            --se ci sono collisioni possiamo settare Vy a 0
            Player.Vy = 0
        end
    end

    Platform = {
        x = 150,
        y = 300,
        width = 200,
        height = 20
    }

    -- copiamo la funzione del personaggio
    function Platform:draw()
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    end

    



end

function love.update(dt)
    Player:update(dt)
end

function love.draw()

    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    Player:draw()
    Platform:draw()

end

--[[
    Cosa fa questa funzione?
    prende le coordinate di due oggetti e controlla se ci sono sovrapposizioni tra i due,
    se ci sono ritorna un valore true, altrimenti false
]]

function Game.checkCollision(a, b)
    return a.x - a.width / 2 < b.x + b.width / 2 and
           a.x + a.width / 2 > b.x - b.width / 2 and
           a.y - a.height / 2 < b.y + b.height / 2 and
           a.y + a.height / 2 > b.y - b.height / 2
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--[[
    Eccoci quindi giunti ad un passo molto importante, abbiamo implementato il nostro primo
    sistema di collisioni ed abbiamo appurato che questo funziona.
    Prossimamente faremo dei ragionamenti sul come inserire nuove piattaforme senza
    rendere questo file lungo 1000 righe
]]





