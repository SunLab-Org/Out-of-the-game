-- Export the module
local module = {}

-- Local game state
local TIMER = 0
local SPAWN_TIMER = 0
local SPAWN_INTERVAL = 1

local is_game_over = false
local highscore = 0
local points = 0

local sprites = {}

local player = {}
local enemies = {}
local projectiles = {}


local function loadSprites()
	sprites["player"] = love.graphics.newImage("games/raymi/assets/player.png")
	-- sprites["enemy"] = love.graphics.newImage("ALC-17.PNG")
	sprites["bullet"] = love.graphics.newImage("games/raymi/assets/bullet.png")
	sprites["background"] = love.graphics.newImage("games/raymi/assets/background.jpg")
end

local function spawnEnemy()
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

local function enemyMovements(dt)
	for i, enemy in ipairs(enemies) do
		enemy.x = enemy.x + enemy.dx * dt
		enemy.y = enemy.y + enemy.dy * dt
	end
end

local function playerMovements(dt)
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

local function displayTutorial()
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.print("wasd to move; space to shoot", 0, VIRTUAL_HEIGHT - 10)
end

local function displayPoints()
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.print("Points: " .. points, VIRTUAL_WIDTH - 80, 20)
end

local function displayGameOver()
	love.graphics.setFont(fonts["bigFont"])
	love.graphics.setColor(1, 0, 0)
	love.graphics.print("GAME OVER", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 20)
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Final Score: " .. points, VIRTUAL_WIDTH / 2 - 40, VIRTUAL_HEIGHT / 2 + 10)
	love.graphics.print("Press R to restart", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 + 30)
end

local function displayFPS()
	-- simple FPS display across all states
	love.graphics.setFont(fonts["smallFont"])
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

local function resetPlayer()
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

local function shoot()
	local projectile = {
		x = player.x + player.w,
		y = player.y + player.h / 2 + 10,
		vx = 300,
		vy = 0,
		w = 4,
		h = 4,
	}
	table.insert(projectiles, projectile)
end

local function projectileMovements(dt)
	for i, projectile in ipairs(projectiles) do
		projectile.x = projectile.x + projectile.vx * dt
		projectile.y = projectile.y + projectile.vy * dt
	end
	
	-- Remove projectiles that are off-screen
	for i = #projectiles, 1, -1 do
		if projectiles[i].x > VIRTUAL_WIDTH then
			table.remove(projectiles, i)
		end
	end
end

local function checkCollisions()
	-- Check projectile-enemy collisions
	for pi = #projectiles, 1, -1 do
		local projectile = projectiles[pi]
		for ei = #enemies, 1, -1 do
			local enemy = enemies[ei]
			if projectile.x < enemy.x + 16 and
			   projectile.x + projectile.w > enemy.x and
			   projectile.y < enemy.y + 16 and
			   projectile.y + projectile.h > enemy.y then
				-- Collision detected
				table.remove(projectiles, pi)
				table.remove(enemies, ei)
				points = points + 10
				if sounds["hit"] then
					sounds["hit"]:play()
				end
				break
			end
		end
	end
	
	-- Check player-enemy collisions
	if not is_game_over then
		for i, enemy in ipairs(enemies) do
			if player.x < enemy.x + 16 and
			   player.x + player.w > enemy.x and
			   player.y + (player.h / 2) < enemy.y + 16 and
			   player.y + (player.h / 2) + player.h > enemy.y then
				-- Player hit by enemy
				is_game_over = true
				if sounds["explosion"] then
					sounds["explosion"]:play()
				end
			end
		end
	end
end

local function resetGame()
	is_game_over = false
	points = 0
	projectiles = {}
	enemies = {}
	player = resetPlayer()
	TIMER = 0
	SPAWN_TIMER = 0
end

function module.load()
	love.graphics.setDefaultFilter("nearest", "nearest") -- Set the default filter for graphics
	love.window.setTitle("Oh Fly") -- Set the window title

	math.randomseed(os.time()) -- Seed the random number generator

	loadSprites()

	-- game setup
	player = resetPlayer()

	love.keyboard.keysPressed = {}
	love.mouse.mousePressed = {} -- Table to track mouse presses
end

function module.update(dt)
	if is_game_over then
		return
	end
	
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

	-- projectile movements
	if #projectiles > 0 then
		projectileMovements(dt)
	end

	-- collision checks
	checkCollisions()

	if #enemies > 0 and enemies[1].x < -8 then
		table.remove(enemies, 1)
		print("despawned")
	end

	love.keyboard.keysPressed = {}
	love.mouse.buttonsPressed = {}
end

function module.draw()
	-- render background
	love.graphics.clear(0.1, 0.1, 0.1, 1) -- Clear the screen with dark grey color
	love.graphics.push()
	love.graphics.scale(0.25, 0.25) -- reduce everything by 50% in both X and Y coordinates
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(sprites["background"], 0, 0)
	love.graphics.pop()
	displayFPS()
	displayPoints()
	displayTutorial()

	-- Render game objects
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(sprites["player"], player.x, player.y)
	-- love.graphics.setColor(0, 1, 0)
	-- love.graphics.rectangle(
	-- 	"line",
	-- 	player.x,
	-- 	player.y + (sprites["player"]:getHeight() / 3),
	-- 	sprites["player"]:getWidth(),
	-- 	sprites["player"]:getHeight() / 2
	-- )

	for i, enemy in ipairs(enemies) do
		love.graphics.setColor(1, 1, 1)

		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("fill", enemy.x, enemy.y, 16, 16)
		-- disegna enemy di grandezza 16 x 16
	end

	-- Draw projectiles
	love.graphics.setColor(1, 1, 0)
	for i, projectile in ipairs(projectiles) do
		love.graphics.rectangle("fill", projectile.x, projectile.y, projectile.w, projectile.h)
	end

	-- Display game over screen if needed
	if is_game_over then
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setColor(1, 1, 1)
		displayGameOver()
	end

	-- displayTitle()
end

function module.keypressed(key)
	-- add to our table of keys pressed this frame
	love.keyboard.keysPressed[key] = true
	
	if key == "space" and not is_game_over then
		if sounds["shoot"] then
			sounds["shoot"]:play()
		end
		shoot()
	end
	
	if key == "r" and is_game_over then
		resetGame()
	end
end

return module
