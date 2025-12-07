local love = require("love")
local push = require("push") -- Import the push library
Class = require("class") -- Import the class library

VIRTUAL_WIDTH = 400 -- Virtual width of the game window
VIRTUAL_HEIGHT = 250 -- Virtual height of the game window
WINDOW_WIDTH = 1280 -- Actual width of the game window
WINDOW_HEIGHT = 720 -- Actual height of the game window

TIMER = 0
SPAWN_TIMER = 0
SPAWN_INTERVAL = 1

local is_game_over = false
local highscore = 0

local fonts = {}
local sounds = {}
local sprites = {}

local player = {}
local enemies = {}

function loadFonts()
	fonts["smallFont"] = love.graphics.newFont("retro.ttf", 8)
	fonts["bigFont"] = love.graphics.newFont("Howdy Koala.ttf", 16)
end

function loadSprites()
	sprites["player"] = love.graphics.newImage("assets/player.png")
	-- sprites["enemy"] = love.graphics.newImage("ALC-17.PNG")
	sprites["bullet"] = love.graphics.newImage("assets/bullet.png")
	sprites["background"] = love.graphics.newImage("assets/background.jpg")
end

function loadSounds()
	sounds["hit"] = love.audio.newSource("assets/Hit.wav", "static")
	sounds["shoot"] = love.audio.newSource("assets/Shoot.wav", "static")
	sounds["start"] = love.audio.newSource("assets/PowerUp.wav", "static")
	sounds["game_over"] = love.audio.newSource("assets/Pickup.wav", "static")
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest") -- Set the default filter for graphics
	love.window.setTitle("Oh Fly") -- Set the window title

	math.randomseed(os.time()) -- Seed the random number generator

	loadFonts()
	loadSprites()
	loadSounds()

	-- game setup
	player = resetPlayer()

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true,
	}) -- Setup the screen using push

	love.keyboard.keysPressed = {}
	love.mouse.mousePressed = {} -- Table to track mouse presses
end

function love.keypressed(key)
	-- add to our table of keys pressed this frame
	love.keyboard.keysPressed[key] = true

	if key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed(x, y, button)
	love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
end

function love.update(dt)
	TIMER = TIMER + dt
	SPAWN_TIMER = SPAWN_TIMER + dt

	playerMovements(dt)

	if SPAWN_TIMER > SPAWN_INTERVAL then
		spawnEnemy()
		print("spawning enemy")
		SPAWN_TIMER = SPAWN_TIMER - SPAWN_INTERVAL
	end

	-- enemy movements
	if #enemies > 0 then
		enemyMovements(dt)
	end

	if #enemies > 0 and enemies[1].x < -8 then
		table.remove(enemies, 1)
		print("despawned")
	end

	love.keyboard.keysPressed = {}
	love.mouse.buttonsPressed = {}
end

function love.draw()
	push:apply("start") -- Start the push library

	-- render background
	love.graphics.clear(0.1, 0.1, 0.1, 1) -- Clear the screen with dark grey color
	love.graphics.push()
	love.graphics.scale(0.15, 0.15) -- reduce everything by 50% in both X and Y coordinates
	love.graphics.draw(sprites["background"], 0, 0)
	love.graphics.pop()
	displayFPS()
	displayPoints()
	displayTutorial()

	-- Render game objects
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(sprites["player"], player.x, player.y)
	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle(
		"line",
		player.x,
		player.y + (sprites["player"]:getHeight() / 3),
		sprites["player"]:getWidth(),
		sprites["player"]:getHeight() / 2
	)

	for i, enemy in ipairs(enemies) do
		love.graphics.setColor(1, 1, 1)

		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("fill", enemy.x, enemy.y, 16, 16)
	end

	-- displayTitle()
	push:apply("end") -- End the push library
end

function spawnEnemy()
	local height = 16
	local width = 16

	local y = math.random(0, VIRTUAL_HEIGHT - height)
	local dx = math.random(-100, 0)
	local enemy = {
		x = VIRTUAL_WIDTH,
		y = y,
		dx = dx,
		dy = 0,
	}
	table.insert(enemies, #enemies, enemy)
end

function enemyMovements(dt)
	for i, enemy in ipairs(enemies) do
		enemy.x = enemy.x + enemy.dx * dt
		enemy.y = enemy.y + enemy.dy * dt
	end
end

function playerMovements(dt)
	if love.keyboard.isDown("w") then
		player.y = player.y - player.dy * dt
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - player.dx * dt
	end
	if love.keyboard.isDown("s") then
		player.y = player.y + player.dy * dt
	end
	if love.keyboard.isDown("d") then
		player.x = player.x + player.dx * dt
	end

	player.x = math.max(0, player.x)
	player.y = math.max(-10, player.y)
	player.x = math.min(VIRTUAL_WIDTH - player.w, player.x)
	player.y = math.min(VIRTUAL_HEIGHT - player.h - 10, player.y)
end

function displayTutorial()
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.print("wasd to move; space to shoot", 0, VIRTUAL_HEIGHT - 10)
end

function displayPoints()
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.print("test", VIRTUAL_WIDTH - 80, 20)
end

function displayFPS()
	-- simple FPS display across all states
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function resetPlayer()
	return {
		x = 20,
		y = VIRTUAL_HEIGHT / 2,
		w = sprites["player"]:getWidth(),
		h = sprites["player"]:getHeight() / 2,
		dx = 100,
		dy = 100,
		ammos = 10,
		sprite = sprites["player"],
	}
end
