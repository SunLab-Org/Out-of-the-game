

STARTING_POS = {
	x = VIRTUAL_WIDTH / 2,
	y = VIRTUAL_HEIGHT / 2,
} -- Starting position of the snake head


is_game_over = false
highscore = 0 -- Variable to track the high score

require("games/snake/Snake") -- Import the snake class
require("games/snake/Food") -- Import the food class

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
end



function displayPoints()
	text = "Points: " .. (snake.length - 5) * 10 -- Create a string with the points
	love.graphics.setFont(fonts["smallFont"]) -- Set the font to bigFont
	love.graphics.print(text, VIRTUAL_WIDTH - 80, 10)

	text = "Highscore: " .. highscore -- Create a string with the points
	love.graphics.setFont(fonts["smallFont"]) -- Set the font to bigFont
	love.graphics.print(text, VIRTUAL_WIDTH - 80, 20)
end

function displayFPS()
	-- simple FPS display across all states
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

-- Export the module
local module = {}

function module.load()
	love.graphics.setDefaultFilter("nearest", "nearest") -- Set the default filter for graphics
	love.window.setTitle("Snake Game") -- Set the window title

	math.randomseed(os.time()) -- Seed the random number generator
	lastUpdate = 0 -- Variable to track the last update time

	-- setup Snake body, snake head
	is_game_over = false -- Flag to check if the game is over
	snake = Snake(STARTING_POS.x, STARTING_POS.y) -- Create a new snake object
	food = Food() -- Create a new food object

	love.keyboard.keysPressed = {}
	love.mouse.mousePressed = {} -- Table to track mouse presses
end

function module.update(dt)
	if love.keyboard.wasPressed("r") then -- If the 'r' key is pressed
		is_game_over = false -- Reset the game over flag
	end

	highscore = math.max(highscore, (snake.length - 5) * 10) -- Update the high score based on the snake length

	if is_game_over then -- If the game is over
		snake = Snake(STARTING_POS.x, STARTING_POS.y) -- Create a new snake object
		return
	end

	-- limit the frame rate to 60 FPS
	if love.timer.getTime() - lastUpdate > 1 / 10 then -- Check if the time since the last update is greater than 1/60 seconds
		print("debugging")
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

function module.draw()
	-- render background
	love.graphics.clear(0.1, 0.1, 0.1, 1) -- Clear the screen with dark grey color
	displayFPS()
	displayPoints()

	-- Render game objects
	food:render() -- Call the render function of the food object
	snake:render() -- Call the render function of the snake object
end

function module.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

return module
