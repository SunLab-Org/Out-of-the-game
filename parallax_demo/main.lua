local push = require("push")
local love = require("love")

-- bg
local background
local backgroundScroll = 0

-- ground
local ground
local groundScroll = 0

BACKGROUND_SCROLL_SPEED = 30
GROUND_SCROLL_SPEED = 60
BACKGROUND_LOOPING_POINT = 413

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
	math.randomseed(os.time()) -- seed the RNG

	-- reset keys
	love.keyboard.keysPressed = {}

	-- background
	background = love.graphics.newImage("assets/background.png")
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
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.update(dt)
	TIMER = TIMER + dt

	-- bg
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()

	love.graphics.setColor(1, 1, 1) -- reset color
	love.graphics.clear(0.1, 0.1, 0.1)

	-- draw background
	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
	Signature()
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
