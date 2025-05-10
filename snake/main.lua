-- main.lua
-- Entry point for the Love2D game
push = require 'push' -- Import the push library
Class = require 'class' -- Import the class library

VIRTUAL_WIDTH = 320 -- Virtual width of the game window
VIRTUAL_HEIGHT = 200 -- Virtual height of the game window
WINDOW_WIDTH = 1280 -- Actual width of the game window
WINDOW_HEIGHT = 720 -- Actual height of the game window

STARTING_POS = {
    x = VIRTUAL_WIDTH / 2,
    y = VIRTUAL_HEIGHT / 2
} -- Starting position of the snake head

require 'Snake' -- Import the snake class

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') -- Set the default filter for graphics
    love.window.setTitle("Snake Game") -- Set the window title

    math.randomseed(os.time()) -- Seed the random number generator
    lastUpdate = 0 -- Variable to track the last update time

    -- load fonts
    smallFont = love.graphics.newFont('retro.ttf', 8)
    bigFont = love.graphics.newFont('Howdy Koala.ttf', 16)
    -- end fonts

    -- setup Snake body, snake head
    is_game_over = false -- Flag to check if the game is over
    snake = Snake(STARTING_POS.x, STARTING_POS.y) -- Create a new snake object
    

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    }) -- Setup the screen using push

end

function love.update(dt)
    if love.keyboard.isDown('escape') then -- If the escape key is pressed
        love.event.quit() -- Quit the game
    end
    if love.keyboard.isDown('r') then -- If the 'r' key is pressed
        is_game_over = false -- Reset the game over flag
    end

    if is_game_over then -- If the game is over
        -- is_game_over = false -- Reset the game over flag
        snake = Snake(STARTING_POS.x, STARTING_POS.y) -- Create a new snake object
        return
    end

    -- limit the frame rate to 60 FPS
    if love.timer.getTime() - lastUpdate > 1 / 10 then -- Check if the time since the last update is greater than 1/60 seconds
        lastUpdate = love.timer.getTime() -- Update the last update time
    else
        return -- If not, return to limit the frame rate
    end

    -- Update game logic
    snake:update(dt) -- Call the update function of the snake object
end

function love.draw()
    push:apply("start") -- Start the push library

    -- render background
    love.graphics.clear(0.1, 0.1, 0.1, 1) -- Clear the screen with dark grey color

    -- Render game objects
    snake:render() -- Call the render function of the snake object

    -- displayTitle()
    displayFPS()
    push:apply("end") -- End the push library
end


function displayTitle()
    love.graphics.setFont(bigFont) -- Set the font to bigFont
    love.graphics.print("Welcome to Snake Game!", VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 0, 1, 1,
        bigFont:getWidth("Welcome to Snake Game!") / 2, bigFont:getHeight() / 2) -- Print the welcome message

end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
