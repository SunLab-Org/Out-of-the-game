local love = require "love" -- importare il modulo di love2d

--[[
    immaginiamo ora di voler salvare ad ogni chisura del gioco
    la posizione del nostro quadrato e cerchio, come fare?

]]

-- dobbiamo usare un json, formato dei dati molto usato in programmazione
-- soprattutto nella realizzazione di siti web
local json = require("dkjson")

local Square = require "quadrato"
local Circle = require "cerchio"

function love.load()

    -- prima di tutto leggiamo i dati dal file
    local contents;
    -- e' necessario fare molti controlli per evitare errori
    -- qui si controlla se il file esiste
    if love.filesystem.getInfo("save.json") then
        contents = love.filesystem.read("save.json")
    end
    
    -- dobbiamo decodificare il json in una table di lua
    local loadedData;
    if contents then
        loadedData = json.decode(contents)
    end

    local sqx, sqy, cx, cy
    if loadedData then 
        sqx = (loadedData.square and loadedData.square.x) or 100
        sqy = (loadedData.square and loadedData.square.y) or 100
        cx  = (loadedData.circle and loadedData.circle.x) or 200
        cy  = (loadedData.circle and loadedData.circle.y) or 200
    end

    S = Square.new(sqx, sqy, 30, 40)
    C = Circle.new(cx, cy, 30)

end

function love.update(dt)
    C:update(dt)
end

function love.draw()

    S:draw()
    C:draw()

end

--[[
    ora il codie e' piu' pulito ed inoltre mi permette di creare
    quanti quadrati e cerchi voglio semplicemente utilizzando una sola funzione

]]

function love.keypressed(key)
    if(key == 'escape') then
        local data = {
            square = {
                x = S.x,
                y = S.y,
            },
            circle = {
                x = C.x,
                y = C.y,
            }
        }
        
        love.filesystem.write("save.json", json.encode(data))
        print("salvataggio completato!")
        love.event.quit()
    end

end