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

is_game_over = false
highscore = 0 -- Variable to track the high score

require 'Snake' -- Import the snake class
require 'Food' -- Import the food class

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
    food = Food() -- Create a new food object

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    }) -- Setup the screen using push
    
    love.keyboard.keysPressed = {}
    love.mouse.mousePressed = {} -- Table to track mouse presses
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if love.keyboard.wasPressed('escape') then -- If the escape key is pressed
        love.event.quit() -- Quit the game
    end
    if love.keyboard.wasPressed('r') then -- If the 'r' key is pressed
        is_game_over = false -- Reset the game over flag
    end

    highscore = math.max(highscore, (snake.length - 5) * 10) -- Update the high score based on the snake length

    if is_game_over then -- If the game is over
        -- is_game_over = false -- Reset the game over flag
        snake = Snake(STARTING_POS.x, STARTING_POS.y) -- Create a new snake object
        return
    end

    -- limit the frame rate to 60 FPS
    if love.timer.getTime() - lastUpdate > 1 / 10 then -- Check if the time since the last update is greater than 1/60 seconds
        lastUpdate = love.timer.getTime() -- Update the last update time
        -- Update game logic
        snake:update(dt) -- Call the update function of the snake object
        snake:eat(food) -- Call the eat function of the snake object

        love.keyboard.keysPressed = {}
        love.mouse.buttonsPressed = {}
    else
        return -- If not, return to limit the frame rate
    end

end

function love.draw()
    push:apply("start") -- Start the push library

    -- render background
    love.graphics.clear(0.1, 0.1, 0.1, 1) -- Clear the screen with dark grey color
    displayFPS()
    displayPoints()

    -- Render game objects
    food:render() -- Call the render function of the food object
    snake:render() -- Call the render function of the snake object

    -- displayTitle()
    push:apply("end") -- End the push library
end

function displayPoints()
    text = "Points: " .. (snake.length - 5 ) * 10-- Create a string with the points
    love.graphics.setFont(smallFont) -- Set the font to bigFont
    love.graphics.print(text, VIRTUAL_WIDTH - 80, 10 )
        

    text = "Highscore: " .. highscore-- Create a string with the points
    love.graphics.setFont(smallFont) -- Set the font to bigFont
    love.graphics.print(text, VIRTUAL_WIDTH -80, 20 ) 
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
