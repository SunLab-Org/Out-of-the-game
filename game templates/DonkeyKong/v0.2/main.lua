local love = require "love"

--[[
    Obiettivi: 
    - creare un personaggino che possiamo muovere on WASD o con le frecce

    Passo molto importante per la riuscita del nostro gioco e'.. avere un personaggio
    con cui possiamo muoverci, quindi proviamo a crearne uno
]]

function love.load()
    -- creiamo un personaggio, molto semplice, diamogli delle dimensioni, larghezza e altezza
    Player = {
        -- queste variabili in verde sono quelle di "proprieta'" del nostro personaggio
        x = 100,
        y = 100,
        width = 50,
        height = 50
    }

    -- il nostro personaggio deve essere disegnato a schermo, quindi creiamo una funzione per disegnarlo
    -- questa sintassi serve per dire a palyer: qeusta e' la tua funzione
    -- ' : ' server per dire alla funzione di prendere come riferimento player
    -- la stessa cosa sarebbe stata fattibile scrivendo:
    --                          function player.draw(player)
    function Player:draw()
        love.graphics.setColor(1, 0.5, 0) -- arancione
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    -- Possiamo sperimentare con altri modi per disgnare il personaggio
    --[[
        come si puo' notare il quadratino viene disegnato partendo dal bordo in alto a
        sinistra, tuttavia possiamo anche provare a disegnarlo partendo dal suo centro
    ]]
    
    function Player:drawCenter()
        love.graphics.setColor(1, 0.5, 0) -- arancione
        love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    end

    --[[
        alla fine si stratta di preferenza, tuttavia utilizzeremo il secondo metodo perche'
        logicamente piu' corretto.
        Proviamo ad aggiungere del movimento al personaggio, aggiungiamo un attributo velocita'
        e spostiamoci in love.update(dt)
    ]]
    
    Player.speed = 100

end

function love.update(dt)
    --[[
        spostiamoci ora nella funzione update, qui cercheremo di fare un sistema di movimento
        per il personaggio, partendo dal concetto di dt:
            dt, anche detto delta time, italianizzandolo "delta del tempo", ovvero intervallo
            di tempo che intercorre tra un frame e l'altro
        questa unita' viene data automaticamente da love2d, e ci permette di calcolare le
        velocita' in modo consistente su tutti i dispositivi.


        Immaginiamo di avere un computer molto molto potente, capace di generare 10 frame 
        e una poco potente, capace di generare 2 frame al secondo
        se il personaggio si spoststasse di 100 pixel per frame, avremo una velocita' di
         - 100 x 10 = 1000 pixel al secondo nel primo caso
         - 100 x 2 = 200 pixel al secondo nel secondo caso
        moltiplicando invece per il delta time otteniamo
        - 100 x 10 x 1/10 = 100 pixel al secondo nel primo caso
        - 100 x 2 x 1/2 = 100 pixel al secondo nel secondo caso
        quindi in entrambi i casi il personaggio si muovera' di 100 pixel al secondo

    ]]

    if love.keyboard.isDown("w","up") then
        Player.y = Player.y - Player.speed * dt
    end
    if love.keyboard.isDown("s","down") then
        Player.y = Player.y + Player.speed * dt
    end
    if love.keyboard.isDown("a","left") then
        Player.x = Player.x - Player.speed * dt
    end
    if love.keyboard.isDown("d","right") then
        Player.x = Player.x + Player.speed * dt
    end

    --[[
        love.keyboard.isDown(tasto) e' la funzione che usiamo per poter controllare se un tasto
        viene premuto

        se il tasto viene premuto allora cambiamo le coordinate del personaggio aggiungendo o sottraendo
        la velocita' moltiplicata per il delta time, per i motivi descritti prima
    ]]

end

function love.draw()
    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    Player:draw() -- chiamiamo la funzione di disegno del nostro personaggio
    Player:drawCenter()

end

--[[
    Molto bene, abbiamo un personaggio che si muove sullo schermo, tuttavia, conoscendo
    il gioco che vogliamo creare, sappiamo che il giocatore poggia su di un pavimento
    e che non puo' liberamente muoversi in alto ed in basso in ogni momento, ma solo quando
    sono presenti delle scale.

    Senza correre troppo nella prossima versione vedremo come migliorare questi aspetti
]]



function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end