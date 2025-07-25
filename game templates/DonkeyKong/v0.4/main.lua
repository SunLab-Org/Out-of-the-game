local love = require "love"

--[[
    Obiettivi: 
    - migliorare il sistema di collisioni
    in realta' questo problema richiede la risoluzione di piu' sottoproblemi che sono abbastanza evidenti:
    - il giocatore si puo' compenetrare con gli oggetti se si muove lateralmente
    - se cade abbastanza velocemente il giocatore puo' entrare dentro gli oggetti
    - se tocca una parete il giocatore si ferma a mezz'aria e non cade

    e per risolver questi prblemi dobbiamo fare un po' di cambiamenti alla funzione delle collisioni
]]
 
local playerGenerator = require "player"
local platformGenerat = require "platform"

Game = {
    physics = {
        gravity = 500
    },
    entities = {}
}

function love.load()

    table.insert(Game.entities, playerGenerator.new(200, 100, 50, 50, 200))
    table.insert(Game.entities, platformGenerat.new(200, 200, 100, 20))
    table.insert(Game.entities, platformGenerat.new(300, 300, 100, 20))
    table.insert(Game.entities, platformGenerat.new(400, 000, 20, 200))

end

function love.update(dt)
   
    for _, entity in ipairs(Game.entities) do
        if entity.update then
            entity:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.4, 0.4, 1)
    for _, entity in ipairs(Game.entities) do
        if entity.draw then
            entity:draw()
        end
    end
end


function Game.checkCollision(a, b)
    --aggiungiamo questo if per convenienza
    if a == b then return nil end
    --[[
        per poter aere maggior controllo sulle collisioni dobbiamo aggiungere delle informazioni al valore di ritorno,
        in poche parole questa funzione deve dirci non solo se esiste una collisione, ma anche altre informazioni
    ]]
    
    -- questa non e' una novita', e' la nostra originaria collisione

    local collides =    a.x - a.width / 2 < b.x + b.width / 2 and
                        a.x + a.width / 2 > b.x - b.width / 2 and
                        a.y - a.height / 2 < b.y + b.height / 2 and
                        a.y + a.height / 2 > b.y - b.height / 2

    if collides == true then
        --inizializzamo la table delle informaizoni
        local coll = {}

        --[[
            innanzitutto introduciamo le normali, lascio un disegnino in questa cartella per capire meglio,
            ma per chi non ha voglia di guardare immaginiamo siano delle freccette che indicano la direzione della collisione
            Quindi, immaginando i nostri oggetti come rettangoli che sono posizionati solo verticalmente o orizzontalmente,
            le direzioni sono: sopra, sotto, sinistra e destra

            visualizziamo queste direzioni come una freccia che puo' puntare in alto, in basso, a sinistra o a destra e la
            rappresentiamo nelle sue coordinate x e y
        ]]
        coll.normal = {nx = 0, ny = 0}
        
        --[[
            immaginiamo di collegare i centri dei due oggetti con una retta, e disegnamo sul nostro rettangolo le diagonali
            se il nostro giocatore si trova al di sopra della piattaforma la retta sara' a sinistra della diagonale che va
            dall'angolo in alto a destra all'angolo in basso a sinistra.
            Matematicamente come possiamo esprimerlo? ci sarebbero diversi metodi, potremmo utilizzare gli angoli oppure le distanze

            utilizziamo gli angoli: (trovate sempre il disegnino)
            -   l'angolo rispetto all'asse x e' trovato facendo normalizzando la retta che collega il centro della piattaforma
                e del giocatore e poi cercando l'arcoseno della componente y o l'arcocoseno della componente x (il risultato e' uguale)
            -   una volta trovato l'angolo possiamo compararlo con quello delle due diaonali, o per meglio dire possiamo verificare
                in quale dei quattro settori in cui le 2 diagonali dividono il rettangolo si trovi questo angolo
        ]]

        --per prima cosa l'angolo della collisione

        

        --valore assoluto della distanza su x e la normalizziamo
        local dx = a.x - b.x
        local dy = a.y - b.y

        --modulo del vettore
        local length = math.sqrt(((dx * dx) + (dy * dy)))

        dx = dx / length

        --arcocoseno di dx ritorna l'angolo rispetto all'asse x in radianti (qualcosa sui radianti negli appunti)
        local angle = math.acos(dx) 
        if(dy>0) then angle = 2*math.pi - angle end

        --ora calcoliamo gli intervalli
        local diagonal_length = math.sqrt((b.width * b.width) + (b.height * b.height))
        local diagonal_angle = math.acos((b.width) / diagonal_length)
        
        
        if angle >= diagonal_angle and angle <= math.pi - diagonal_angle then
            coll.normal.nx = 0
            coll.normal.ny = -1
        elseif angle <= (2 * math.pi) - diagonal_angle and angle >= (diagonal_angle + math.pi) then
            coll.normal.nx = 0
            coll.normal.ny = 1
        elseif angle > math.pi - diagonal_angle and angle < (diagonal_angle + math.pi) then
            coll.normal.nx = -1
            coll.normal.ny = 0
        else
            coll.normal.nx = 1
            coll.normal.ny = 0
        end
        
        return coll
    else
        -- se non ci sono collisioni, allora ritorniamo nil, ovvero nulla
        return nil
    end

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--[[
    abbiamo implementato una prima idea per l'identificazione delle collisioni, tuttavia il lavoro non e' completo
    alcuni bug continuano ad accadere, pertanto vedremo di risolverli nella seconda parte del problema delle collisioni
]]




