local love = require("love")
local push = require("push") -- autoscaler
local tick = require("tick") -- fps limiter
Class = require("class") -- class oop like
require("Player")

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

-- players
local p1
local p2

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest") --set filter
	tick.framerate = 60 -- Limit framerate to 60 frames per second.
	math.randomseed(os.time()) -- seed the RNG

	-- reset keys
	love.keyboard.keysPressed = {}

	-- players
	p1 = Player("p1")
	p2 = Player("p2")

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

	p1:update(dt)
	p2:update(dt)

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()
	love.graphics.setColor(1, 1, 1) -- reset color
	love.graphics.clear(0.1, 0.1, 0.1)

	p1:render()
	p2:render()

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
