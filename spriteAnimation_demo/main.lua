local push = require("push")
local tick = require("tick") -- fps limiter
local love = require("love")

-- bird
ANIMATION_DURATION = 15 -- how many frame per animation
local bird = {}
local animation_time = 15
local spriteBirdIdle
local spriteBirdMove

-- ground
local ground
local groundScroll = 0

-- timer variable
TIMER = 0

-- size of our actual window
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 300

-- fonts
SMALLFONT = love.graphics.newFont("fonts/font.ttf", 8)

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest") --set filter
	tick.framerate = 60 -- Limit framerate to 60 frames per second.
	math.randomseed(os.time()) -- seed the RNG

	-- reset keys
	love.keyboard.keysPressed = {}

	-- bird
	spriteBirdIdle = love.graphics.newImage("assets/bird.png")
	spriteBirdMove = love.graphics.newImage("assets/flight_bird.png")

	bird = {
		x = (VIRTUAL_WIDTH / 2 - spriteBirdIdle:getWidth() / 2),
		y = (VIRTUAL_HEIGHT / 2 - spriteBirdIdle:getHeight() / 2),
		status = "idle",
	}

	-- background
	ground = love.graphics.newImage("assets/ground.png")

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = true,
		resizable = true,
		vsync = true,
		canvas = false,
	})
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == "escape" then
		love.event.quit()
	end

	if key == "space" then
		animation_time = 0
	end
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.update(dt)
	TIMER = TIMER + dt

	if animation_time < ANIMATION_DURATION then
		animation_time = animation_time + 1
		bird.status = "flap"
	else
		bird.status = "idle"
	end

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()

	love.graphics.setColor(1, 1, 1) -- reset color
	love.graphics.clear(0.1, 0.1, 0.1)

	if bird.status == "idle" then
		love.graphics.draw(spriteBirdIdle, bird.x, bird.y)
	else
		love.graphics.draw(spriteBirdMove, bird.x, bird.y)
	end

	-- draw background
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
	Signature()
	DisplayFPS()
	push:finish()
end

--[
-- Print to the screen the author of the game
--]
function Signature()
	local padding = 10
	local user = "Sunlab:Out of the game by Francesco Penasa"

	love.graphics.setFont(SMALLFONT)
	love.graphics.setColor(0, 0, 0) -- black
	love.graphics.print(
		user,
		VIRTUAL_WIDTH - padding - SMALLFONT:getWidth(user),
		VIRTUAL_HEIGHT - SMALLFONT:getHeight(user)
	)
end

--[[
    Renders the current FPS.
]]
function DisplayFPS()
	-- simple FPS display across all states
	love.graphics.setFont(SMALLFONT)
	love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.setColor(255, 255, 255, 255)
end
