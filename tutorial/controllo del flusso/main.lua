local love = require "love"

--[[
    in questo tutorial capiamo come utilizzare le istruzioni
    if e come ci aiutano a scrivere dei buoni giochi
]]


function love.load()
    --[[
        un nuovo tipo entra in gioco, il tipo booleano
        le variabili di tipo boolean posso assumeresolo due valori
        ovvero:
            -- TRUE ( vero )
            -- FALSE ( falso )
        praticamente sono il modo in cui noi possiamo chiedere al nostro
        pc: e' vera questa cosa? e lui ci risponde vero o farlo.
        Quella risposta e' il tipo booleano.

        ma cosa ce ne facciamo? e come facciamoa chiederglielo?

    ]]

    -- esempio di variabile booleana
    local b = true

    --[[
        il modo in cui possiamo chiedere ad un pc se una cosa e' vera o falsa
        e' tramite alcune funzioni oppure tramite l'utilizzo di alcune istruzioni
    ]]

    -- l'operatore == serve per chiedere: sono uguali?
    local a = ( 5 == 6 )
    
    -- l'opreatore < serve per chiedere: il primo e' minore del seconodo?
    local c = ( 5 < 6 )
    -- Nota: possiamo anche scrivere <= per chiedere minore o uguale

    -- l'operatore ~= serve invece per chiedere: sono diversi?
    local d = ( 5 ~= 7 )

    -- importante: not (non) e' usato per NEGARE ovvero invertire true e false
    local e = not(5 == 5)
    -- questa espressione risulta in FALSE siccome e' TRUE che 5 == 5 ma poi con ~ lo nego

    -- stampiamo tutto
    print(a,b,c,d,e)




end

function love.update(dt)


end

function love.draw()
    --[[
        perche' e' importante usare questi tipi?
        immaginiamo di voler stampare sullo schermo un cerchio
        solo in determinati casi, ovvero magari quando un tasto e'
        premuto oppure quando un tasto e' stato premuto
    ]]
    
    -- alcune funzioni possono restituire un valore booleano

    local space_pressed = love.keyboard.isDown("space")
    
    if space_pressed then
        love.graphics.circle("fill", 100, 100, 50)
    end

    -- la funzione love.keyboard.isDown("space") restituisce:
        -- VERO se il tasto spazio e' premuto
        -- FALSO se il tasto spazion non e' premuto

     
    print("ciao")
    print("come")
    print("va?")

    love.graphics.circle("fill", 300, 300, 100)

    local condizione

    if condizione then
        -- codice eseguito se condizione e' vero
    end
    -- poi continua qui

    if condizione then
        -- codice eseguito se condizione e' vera
    else 
        -- codice eseguito se condizione e' falso
    end
    -- poi continua qui

end