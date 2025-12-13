local push = require "push"
-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 400
TIMER = 0
S_PASSATI = 0

STEP  = 0.5

local pinteggio = 0
local y = 0
local x = 0
local vx = 16
local vy = 16
local direction = ""
local xApple
local yApple
local xpower
local ypower
local melarossa = 0
local snake = {{
    x = 64,
    y = 0,
    direction = "destra"
}, {
    x = 48,
    y = 0,
    direction = "destra"
}, {
    x = 32,
    y = 0,
    direction = "destra"
}, {
    x = 16,
    y = 0,
    direction = "destra"
}}

local highscore = 0

local images
local snake_img

function GenerateQuads(atlas, tilewidth, tileheight)

    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight,
                atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function love.load()
    music = love.audio.newSource("Hit.wav", "static")
    music2 = love.audio.newSource("Pickup.wav", "static")


    love.graphics.setDefaultFilter('nearest', 'nearest')
    sega_font_large = love.graphics.newFont('font.ttf', 10)

    snake_img = love.graphics.newImage('realfinal.png')
    images = GenerateQuads(snake_img, 16, 16)

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = true,
        vsync = true,
        canvas = false
    })
    math.randomseed(os.time())
    xApple = math.random(290)
    yApple = math.random(190)
    xApple = xApple - xApple % 16
    yApple = yApple - yApple % 16
    math.randomseed(os.time())
    xpower = math.random(290)
    ypower = math.random(190)
    xpower = xpower - xpower % 16
    ypower = ypower - ypower % 16
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    if key == "d" and not (snake[1].direction == "sinistra") then
        snake[1].direction = "destra"
    end
    if key == "s" and not (snake[1].direction == "su") then
        snake[1].direction = "giu"
    end
    if key == "a" and not (snake[1].direction == "destra") then
       snake[1].direction = "sinistra"
    end
    if key == "w" and not (snake[1].direction == "giu") then
        snake[1].direction = "su"
    end

end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
if melarossa >= 25 then
    melarossa = 0
end
melarossa = melarossa + dt
S_PASSATI = S_PASSATI + dt
    TIMER = TIMER + dt
    coda = snake[#snake]

    if TIMER >= STEP then
        -- testa
        if snake[1].direction == "destra" then
            new_x = snake[1].x + vx
            table.insert(snake, 1, {
                x = new_x,
                y = snake[1].y,
                direction= "destra"
            })
            table.remove(snake, #snake)
        end
        if snake[1].direction == "giu" then
            new_y = snake[1].y + vy
            table.insert(snake, 1, {
                y = new_y,
                x = snake[1].x,
                direction= "giu"
            })
            table.remove(snake, #snake)
        end
        if snake[1].direction == "sinistra" then
            new_x = snake[1].x - vx
            table.insert(snake, 1, {
                x = new_x,
                y = snake[1].y,
                direction= "sinistra"
            })
            table.remove(snake, #snake)
        end
        if snake[1].direction == "su" then
            new_y = snake[1].y - vy
            table.insert(snake, 1, {
                y = new_y,
                x = snake[1].x,
                direction= "su"
            })
            table.remove(snake, #snake)
        end


        --apple
        if xApple == (snake[1].x) and yApple == (snake[1].y) then

            xApple = math.random(290)
            yApple = math.random(190)
            xApple = xApple - xApple % 16
            yApple = yApple - yApple % 16

            table.insert(snake, #snake + 1, {
                x = coda.x,
                y = coda.y
            })
            music2:play()
        end
        --power
        if xpower == (snake[1].x) and ypower == (snake[1].y) then
S_PASSATI = 0
            xpower = math.random(290)
            ypower = math.random(190)
            xpower = xpower - xpower % 16
            ypower = ypower - ypower % 16
            STEP = 0.25
            if S_PASSATI >= 7 then
                STEP = 0.5
                
                
            end
             if S_PASSATI >= 8 then
                S_PASSATI = 0
                
            end
            music2:play()
        end

        -- muro
        if (snake[1].x) == VIRTUAL_WIDTH then
            snake[1].x = 40
            snake[1].y = 0

            for i = #snake, 1, -1 do

                snake[i].x = 10 * #snake - 10 * i
                snake[i].y = 0
            end
            resetSnake()
            music:play()
        end

        --muro
        if (snake[1].x) < 0 then
            snake[1].x = 40
            snake[1].y = 0

            for i = #snake, 1, -1 do

                snake[i].x = 10 * #snake - 10 * i
                snake[i].y = 0
            end
            resetSnake()
            music:play()
        end

        --muro
        if (snake[1].y) == VIRTUAL_HEIGHT then
            snake[1].x = 40
            snake[1].y = 0

            for i = #snake, 1, -1 do

                snake[i].x = 10 * #snake - 10 * i
                snake[i].y = 0
            end
            resetSnake()
            music:play()
        end

        --muro
        if (snake[1].y) < 0 then
            snake[1].x = 40
            snake[1].y = 0

            for i = #snake, 1, -1 do

                snake[i].x = 10 * #snake - 10 * i
                snake[i].y = 0
            end
            resetSnake()
            music:play()
        end

        --score
        if xApple == (snake[1].x) and yApple == (snake[1].y) then
            pinteggio = pinteggio + 1
        end
        TIMER = 0
    end


    highscore = math.max(highscore, (#snake - 4) * 10)
    love.keyboard.keysPressed = {}

    -- check morte
    for i = #snake, 2, -1 do
        if (snake[1].y) == (snake[i].y) and (snake[1].x) == (snake[i].x) then
            snake[1].x = 40
            snake[1].y = 0

            snake = {{
                x = 64,
                y = 0
            }, {
                x = 48,
                y = 0
            }, {
                x = 32,
                y = 0
            }, {
                x = 16,
                y = 0
            }}

            direction = ""
            music:play()
        end
        
    end
end



-- 1080 / 27 = 40 1920
-- 1080 y 1920 x
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:start()

    love.graphics.setColor(0 / 255, 143 / 255, 57 / 255)
    love.graphics.rectangle("fill", 0, 0, 10000, 100000)
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)

    for i, s in ipairs(snake) do
        if i == 1 then
            drawHead(snake_img, images, snake[i].x, snake[i].y, snake[i].direction)


        elseif i == #snake then
            drawTail(snake_img, images, snake[#snake].x, snake[#snake].y, snake[i].direction)
        else

            if snake[i-1].direction == "destra" and snake[i].direction == "giu" then
                drawBody(snake_img, images[2], snake[i].x, snake[i].y, snake[i].direction)
            else                
                drawBody(snake_img, images[2], snake[i].x, snake[i].y, snake[i].direction)
            end
            
       
        end
    end

    love.graphics.rectangle("line", xApple, yApple, 16, 16)
    love.graphics.setColor(255/255, 0/255, 0/255)
    if melarossa >= 20 then
        love.graphics.rectangle("line", xpower, ypower, 16, 16)

    end
    
    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.setFont(sega_font_large)
    text = "POINTS: " .. (#snake - 4) * 10
    love.graphics.print(text, VIRTUAL_WIDTH - 70, 5)

    love.graphics.setFont(sega_font_large)
    text = "highscore: " .. highscore
    love.graphics.print(text, VIRTUAL_WIDTH - 80, 20)

  

    -- end our drawing to push
    push:finish()
end

function debug(snake_img, images)
    love.graphics.setColor(1,1,0)
    
    love.graphics.draw(snake_img, images[1], 100, 100, math.pi/2 *3 ,1,1,16,0)
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("line", 100, 100, 16,16)

end

function resetSnake()
    snake = {{
    x = 64,
    y = 0,
    direction = "destra"
}, {
    x = 48,
    y = 0,
    direction = "destra"
}, {
    x = 32,
    y = 0,
    direction = "destra"
}, {
    x = 16,
    y = 0,
    direction = "destra"
}}

end

function drawHead(snake_img, images, x, y, direction)

    if direction == "destra" or direction == "" then
        love.graphics.draw(snake_img, images[1], x, y, math.pi,1,1,16,16)
    elseif direction == "sinistra" then
        love.graphics.draw(snake_img, images[1], x, y)
    elseif direction == "su" then
        love.graphics.draw(snake_img, images[1], x, y, math.pi/2 ,1,1,0, 16)
    elseif direction == "giu" then
        love.graphics.draw(snake_img, images[1], x, y, math.pi/2 *3 ,1,1,16,0)
    else
        love.graphics.draw(snake_img, images[1], x, y)
    end

end
function drawBody(snake_img, section, x, y, direction,turn )
    if turn then 
        love.graphics.draw(snake_img, section, x, y)
    elseif direction == "destra" or direction == "" then
        love.graphics.draw(snake_img, section, x, y, math.pi,1,1,16,16)
    elseif direction == "sinistra" then
        love.graphics.draw(snake_img, section, x, y)
    elseif direction == "su" then
        love.graphics.draw(snake_img, section, x, y, math.pi/2 ,1,1,0, 16)
    elseif direction == "giu" then
        love.graphics.draw(snake_img, section, x, y, math.pi/2 *3 ,1,1,16,0)
    else
        love.graphics.draw(snake_img, section, x, y)
    end

end

function drawTail(snake_img, images, x, y, direction)
    if direction == "destra" or direction == "" then
        love.graphics.draw(snake_img, images[3], x, y, math.pi,1,1,16,16)
    elseif direction == "sinistra" then
        love.graphics.draw(snake_img, images[3], x, y)
    elseif direction == "su" then
        love.graphics.draw(snake_img, images[3], x, y, math.pi/2 ,1,1,0, 16)
    elseif direction == "giu" then
        love.graphics.draw(snake_img, images[3], x, y, math.pi/2 *3 ,1,1,16,0)
    else
        love.graphics.draw(snake_img, images[3], x, y)
    end

end