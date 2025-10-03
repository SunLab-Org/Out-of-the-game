local love = require "love" -- importare il modulo di love2d

--[[
    In questo file vediamo quali sono le basi di un gioco in love2d
    Qui sotto vediamo 3 principali funzioni:
    - load: serve per preparare l'esecuzione del codice
    - update: serve per aggiornare lo stato del gioco
    - draw: serve per disegnare effettivamente il gioco


]]

Square = {}

function love.load()
    -- questa funzione viene eseguita una volta sola
    
    -- posso assegare a questa table dei valori 1 volta sola
    Square.x = 20
    Square.y = 20

    Square.hg = 70
    Square.wh = 70


end

function love.update(dt)
    -- questa viene eseguita ogni frame ( ovvero ogni fotogramma del gioco )

    -- dt e' il "delta time" ovvero il tempo che e' trascorso da un frame all'altro
    print(dt)

    -- questa variabile e' molto importante sotto molti aspetti che avremmo modo di vedere

    -- per esempio posso far muovere le forme che disegno aggiornando la loro posizione
    Square.x = Square.x + 10 * dt

    -- potete trovare un approfondimento su dt a questo link
    -- https://youtube.com/shorts/7-lK-hCOHXM?si=UIkPMw5A7zmyKa0a
end

function love.draw()
    -- anche questa vene eseguita ogni frame



    -- questa funzione mi permette di disegnare un rettangolo
    love.graphics.rectangle('fill', Square.x, Square.y, Square.hg, Square.wh)

    -- cambio il colore con cui disegno
    love.graphics.setColor(1, 0, 0)

    -- qui disegno il contorno di un cerchio
    love.graphics.circle("line", Square.x + Square.wh/2, Square.y + Square.hg/2, Square.wh/2)

    love.graphics.setColor(1, 1, 1)

end

function love.keypressed(key)
    -- in questa funzione posso controllare se un tasto viene premuto

    -- controllo se esc viene premuto allora esco dal gioco
    if(key == 'escape') then
        love.event.quit()
    end

end