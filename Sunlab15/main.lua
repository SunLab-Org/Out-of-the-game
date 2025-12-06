push = require("libs/push") -- Import the push library
Class = require("libs/class") -- Import the class library

VIRTUAL_WIDTH = 640 -- Virtual width of the game window
VIRTUAL_HEIGHT = 480 -- Virtual height of the game window
WINDOW_WIDTH = 1280 -- Actual width of the game window
WINDOW_HEIGHT = 720 -- Actual height of the game window

fonts = {}
sounds = {}
games = {}
state = "main_menu" -- main_menu, select_game, credits, playing, info

-- Sunlab15 Main Game Launcher
local selected = 1
local infoPopup = false
minigameModule = nil

function loadFonts()
	fonts["smallFont"] = love.graphics.newFont("assets/retro.ttf", 8)
	fonts["creditsFont"] = love.graphics.newFont("assets/retro.ttf", 16)
	fonts["bigFont"] = love.graphics.newFont("assets/Howdy Koala.ttf", 16)
	fonts["menuItem"] = love.graphics.newFont("assets/retro.ttf", 32)
	fonts["selectionItem"] = love.graphics.newFont("assets/retro.ttf", 16)
	fonts["menuTitle"] = love.graphics.newFont("assets/retro.ttf", 64)
end

function loadSounds()
	sounds["up"] = love.audio.newSource("assets/Blip1.wav", "static")
	sounds["down"] = love.audio.newSource("assets/Blip.wav", "static")
end

-- Helper: Scan games directory for minigames
local function scanGames()
	local dirs = love.filesystem.getDirectoryItems("games")
	for _, name in ipairs(dirs) do
		local path = "games/" .. name .. "/main.lua"
		if love.filesystem.getInfo(path) then
			table.insert(games, {
				name = name,
				main = path,
				image = love.filesystem.getInfo("games/" .. name .. "/cover.png") and love.graphics.newImage("games/" .. name .. "/cover.png") or nil,
				info = love.filesystem.getInfo("games/" .. name .. "/info.txt") and love.filesystem.read("games/" .. name .. "/info.txt") or "No info available."
			})
		end
	end
end

function returnToSelection()
	state = "select_game"
	minigameModule = nil
end

function love.load()
	scanGames()
	loadFonts()
	loadSounds()
	menuAnim = {t = 0}


	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = true,
		resizable = true,
		vsync = true,
		canvas = false,
	}) 
end

function love.update(dt)
	if state == "main_menu" then
		menuAnim.t = menuAnim.t + dt
	end

	if state == "playing" then
		if minigameModule and minigameModule.update then
			minigameModule.update(dt)
		end
	end
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.draw()
	push:start() 
	love.graphics.clear(0.1, 0.1, 0.1, 1)

	if state == "main_menu" then
		local t = menuAnim.t or 0
		-- title 
		local y = VIRTUAL_HEIGHT*0.1 + math.sin(t*2)*VIRTUAL_HEIGHT*0.025
		local r = 0.5+0.5*math.sin(t)
		local g = 0.5+0.5*math.sin(t+2)
		local b = 0.5+0.5*math.sin(t+4)
		love.graphics.setFont(fonts["menuTitle"])
		love.graphics.setColor(r, g, b, 1)
		love.graphics.printf("Sunlab 15", 0, y, VIRTUAL_WIDTH, "center")

		-- highlight selected
		love.graphics.setColor(0.3, 0.4, 0.5 )
		love.graphics.rectangle(
			"fill", 
			0,
			100 + (selected * 80),
			VIRTUAL_WIDTH, 
			80
		)

		-- menu items
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(fonts["menuItem"])
		love.graphics.printf("Start", 0, 200, VIRTUAL_WIDTH , "center")
		love.graphics.printf("Credits", 0, 280, VIRTUAL_WIDTH , "center")
		love.graphics.printf("Exit",  0,   360, VIRTUAL_WIDTH , "center")


	elseif state == "select_game" then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(fonts["selectionItem"])
		love.graphics.printf("Select a Minigame", 0, 40, love.graphics.getWidth(), "center")
		for i, game in ipairs(games) do
			local y = 100 + (i-1)*150
			love.graphics.rectangle("line", 100, y, 400, 120)
			if game.image then
				love.graphics.draw(game.image, 110, y+10, 0, 0.2, 0.2)
			else
				love.graphics.printf(game.name, 120, y+10, 380, "left")
			end
			love.graphics.printf("Start", 350, y+80, 60, "center")
			love.graphics.printf("Info", 420, y+80, 60, "center")
			if i == selected then
				love.graphics.rectangle("line", 95, y-5, 410, 130)
			end
		end
		if infoPopup then
			local game = games[selected]
			love.graphics.setColor(0,0,0,0.8)
			love.graphics.rectangle("fill", 150, 200, 340, 180)
			love.graphics.setColor(1,1,1,1)
			love.graphics.printf(game.info, 160, 210, 320, "left")
			love.graphics.printf("Press any key to close", 160, 350, 320, "center")
		end

	elseif state == "credits" then
		drawCredits()

	elseif state == "playing" then
		if minigameModule and minigameModule.draw then
			minigameModule.draw()
		else
			love.graphics.setColor(1,0.2,0.2,1)
			love.graphics.printf("Error: Could not load minigame!\nPress ESC to return to menu.", 0, love.graphics.getHeight()/2-40, love.graphics.getWidth(), "center")
			love.graphics.setColor(1,1,1,1)
		end
	end

	push:finish()
end

function drawCredits()
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.rectangle("fill", VIRTUAL_WIDTH/2, 0, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2)
	love.graphics.setColor(1, 0, 1, 1)
	love.graphics.rectangle("fill", VIRTUAL_WIDTH* 3/4, 0, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("fill", VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", VIRTUAL_WIDTH* 3/4, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT/2)
	love.graphics.setFont(fonts["menuItem"])
	love.graphics.printf("Credits", 0, 0, VIRTUAL_WIDTH/2, "center")
	love.graphics.setFont(fonts["creditsFont"])
	love.graphics.printf("Out of the Game Team: \nEnea, Thomas, Virginia, Raymi, Lorenzo, Gabriele, Simone A, Tommaso, Simone F, Fabio, Alan, Leonardo, Francesco", 0, 48, VIRTUAL_WIDTH/2, "center")
	love.graphics.printf("Press any key to return", 0, VIRTUAL_HEIGHT-32, VIRTUAL_WIDTH/2, "center")
end

-- Handle keypresses globally
function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
end

function love.keypressed(key)
	if state == "main_menu" then
		mainMenuKeypressed(key)
	elseif state == "select_game" then
		selectMenuKeypressed(key)
	elseif state == "credits" then
		state = "main_menu"
	elseif state == "playing" then
		playingKeypressed(key)
	end
end

function mainMenuKeypressed(key)
	if key == "down" then
		selected= math.min(selected+ 1, 3) 
		if sounds["up"] then sounds["up"]:play() end
	elseif key == "up" then
		selected= math.max(selected- 1, 1)
		if sounds["down"] then sounds["down"]:play() end
	elseif key == "return" then
		if selected== 1 then
			state = "select_game"
		elseif selected== 2 then
			state = "credits"
		elseif selected== 3 then
			love.event.quit()
		end
	elseif key == "escape" then
		love.event.quit()
	end
end

function selectMenuKeypressed(key)
	if infoPopup then
		infoPopup = false
		return
	end

	if key == "down" then
		selected= math.min(selected+ 1, #games)
	elseif key == "up" then
		selected= math.max(selected- 1, 1)
	elseif key == "return" then
		-- Start minigame
		local game = games[selected]
		local loaded = love.filesystem.load(game.main)
		minigameModule = loaded and loaded() or nil
		if minigameModule and minigameModule.load then
			minigameModule.load()
		end
		state = "playing"
	elseif key == "i" then
		infoPopup = true
	elseif key == "escape" then
		state = "main_menu"
	end
end

function playingKeypressed(key)
	if key == "escape" then
		returnToSelection()
	elseif minigameModule and minigameModule.keypressed then
		minigameModule.keypressed(key)
	end
end