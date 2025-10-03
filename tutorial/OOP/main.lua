local love = require "love" -- importare il modulo di love2d

--[[
    in questo file vediamo uno dei metodi piu' classici di programmazione
    ovvero la programmazione ad oggetti.
    Per programmare in questo metodo dobbiamo prima definire i due protagonisti:
        1. CLASSE: una classe e' uno "stampino" per creare degli oggetti
        2. OGGETTO: e' creato sulla base della classe, ma e' un'unita' a se' stante
    Nelle classi vengono definiti i comportamenti che puo' assumere l'oggetto
    mentre l'oggetto li attua.
    Vediamo un esempio prendendo il file di game_basics e creando una classe per quadrato e cerchio


]]

-- dopo aver creato le classi dobbiamo importarle

local Square = require "quadrato"
local Circle = require "cerchio"

function love.load()
    S = Square.new(20, 20, 30, 40)
    C = Circle.new(100, 100, 30)

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
        love.event.quit()
    end

end