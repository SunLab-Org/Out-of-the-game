local love = require "love"

--[[
    Questa e' un passaggio molto delicato del nostro codice, in sostanza siamo davanti
    ad una prima modularizzazione del codice, parolona che fa molta paura ma che in realta'
    e' molto semplice da capire.

    Abbiamo spostato tutto il codice di player in un file a parte, e abbiamo creato una 
    funzione Player.new() questa funzione fa quello che facevamo in main, ma poi restituisce
    il player
]]

local Player = {}

function Player.new(x, y, width, height)
    -- creo il player come nel main
    local player = {
        x = x,
        y = y,
        width = width,
        height = height,
        speed = 100,
        Vx = 0,
        Vy = 0,

        -- ho aggiunto questa variabile che ci dice se il player e' a terra o no
        onGround = false
    }

    function player:draw()
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("fill", player.x - player.width / 2, player.y - player.height / 2, player.width, player.height)
    end

    function player:update(dt)
        if love.keyboard.isDown("a","left") then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("d","right") then
            player.x = player.x + player.speed * dt
        end
    
        -- utilizzo la nuova variabile per capire se il player e' a terra
        if not player.onGround then
            player.y = player.y + player.Vy * dt + Game.physics.gravity / 2 * dt * dt
            player.Vy = player.Vy + Game.physics.gravity * dt
        else
            player.Vy = 0
        end
    end

    -- ho aggiunto questa funzione per controllare se ci sono collisioni tra il player
    -- e un altro oggetto, che ho chiamato 'other'
    function player:checkCollision(other)
        player.onGround = Game.checkCollision(player, other) -- controlla se collidono e assegna il valore a onGround
    end

    return player
end

return Player

--[[
    Abbiamo fatto una parte importante del lavoro, comprendere questo passaggio e' fondamentale
    per poter la buona riuscita del nostro gioco e per non ammattire piu' avanti!
    Nella prossima versione aggiorniamo il sistema di collisioni
]]





