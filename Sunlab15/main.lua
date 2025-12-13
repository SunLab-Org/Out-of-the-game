love.graphics.setDefaultFilter('nearest', 'nearest')

push = require("libs/push") -- Import the push library
Class = require("libs/class") -- Import the class library

VIRTUAL_WIDTH = 640 -- Virtual width of the game window
VIRTUAL_HEIGHT = 480 -- Virtual height of the game window
WINDOW_WIDTH = 1280 -- Actual width of the game window
WINDOW_HEIGHT = 720 -- Actual height of the game window

fonts = {}
sounds = {}
games = {}
logos = {}
state = "main_menu" -- main_menu, select_game, credits, playing, info

-- Sunlab15 Main Game Launcher
local selected = 1
local infoPopup = false
minigameModule = nil

function loadFonts()
	fonts["smallFont"] = love.graphics.newFont("assets/retro.ttf", 8)
	fonts["creditsFont"] = love.graphics.newFont("assets/retro.ttf", 24)
	fonts["bigFont"] = love.graphics.newFont("assets/Howdy Koala.ttf", 16)
	fonts["menuItem"] = love.graphics.newFont("assets/retro.ttf", 48)
	fonts["selectionItem"] = love.graphics.newFont("assets/retro.ttf", 16)
	fonts["menuTitle"] = love.graphics.newFont("assets/retro.ttf", 64)
end

function loadSounds()
	sounds["up"] = love.audio.newSource("assets/Blip1.wav", "static")
	sounds["down"] = love.audio.newSource("assets/Blip1.wav", "static")
	sounds["enter"] = love.audio.newSource("assets/Blip.wav", "static")
	sounds["escape"] = love.audio.newSource("assets/Blip.wav", "static")

	sounds["explosion"] = love.audio.newSource("assets/Boom1.wav", "static")
	sounds["hit"] = love.audio.newSource("assets/Hit3.wav", "static")
	sounds["jump"] = love.audio.newSource("assets/Jump11.wav", "static")
	sounds["shoot"] = love.audio.newSource("assets/Shoot6.wav", "static")

	sounds['paddle_hit'] = love.audio.newSource('assets/paddle_hit.wav', 'static')
	sounds['score'] = love.audio.newSource('assets/score.wav', 'static')
	sounds['wall_hit'] = love.audio.newSource('assets/wall_hit.wav', 'static')
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
				image = love.filesystem.getInfo("games/" .. name .. "/cover.png") and love.graphics.newImage(
					"games/" .. name .. "/cover.png"
				) or nil,
				info = love.filesystem.getInfo("games/" .. name .. "/info.txt") and love.filesystem.read(
					"games/" .. name .. "/info.txt"
				) or "No info available.",
			})
		end
	end
end

function returnToSelection()
	state = "select_game"
	minigameModule = nil
end

function loadLogos()
	logos["appm"] = love.graphics.newImage("assets/logoAPPM.png")
	logos["piano"] = love.graphics.newImage("assets/pgdz.png")
	logos["politiche"] = love.graphics.newImage("assets/politiche.png")
	logos["tn"] = love.graphics.newImage("assets/pat.png")
end

function love.load()
	scanGames()
	loadFonts()
	loadSounds()
	loadLogos()
	menuAnim = { t = 0 }

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = true,
		resizable = true,
		vsync = true,
		canvas = false,
	})
end

function love.update(dt)
	if state == "main_menu" or state == "credits" or state == "select_game" then
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


local function drawSelectionMenu()
	local rowSize = 5
	local t = menuAnim.t or 0
	local r = 0.7 + 0.3 * math.sin(t)
	local g = 0.7 + 0.3 * math.sin(t + 2)
	local b = 0.7 + 0.3 * math.sin(t + 4)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(fonts["selectionItem"])
	love.graphics.printf("Select a Minigame", 0, 40, love.graphics.getWidth(), "center")
	for i, game in ipairs(games) do
		local x = ((i-1) % rowSize) * (VIRTUAL_WIDTH / 5) + 25 
		local y = (math.floor((i - 1) / rowSize)) * (VIRTUAL_HEIGHT / 3 ) + 10

		if i == selected then
			love.graphics.setColor(r, g, b, 1)
			love.graphics.rectangle("line", x, y, 80, 100)
		else 
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.rectangle("line", x, y, 80, 100)
		end

		love.graphics.setColor(1, 1, 1, 1)
		-- 80 x  100 y dimension copertina
		if game.image then
			love.graphics.draw(game.image, x, y)
		else
			love.graphics.printf(game.name, x, y, 80, "center")
		end

		love.graphics.printf("Start [ENTER]", 420, VIRTUAL_HEIGHT-20, 120, "center")
		love.graphics.printf("Info [i]", 500, VIRTUAL_HEIGHT-20, 120, "right")
	end
	if infoPopup then
		local game = games[selected]
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.rectangle("fill", 150, 200, 340, 180)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(game.info, 160, 210, 320, "left")
		love.graphics.printf("Press any key to close", 160, 350, 320, "center")
	end
end

function love.draw()
	push:start()
	love.graphics.clear(0.1, 0.1, 0.1, 1)

	if state == "main_menu" then
		local t = menuAnim.t or 0

		local fullText = "Sunlab 15"
		local speed = 10 -- letters per second
		local letterCount = math.floor(t * speed)

		love.graphics.setFont(fonts["menuTitle"])

		-- measure the whole string to calculate a starting X for center alignment
		local totalWidth = fonts["menuTitle"]:getWidth(fullText)
		local startX = (VIRTUAL_WIDTH - totalWidth) / 2
		local baseY = VIRTUAL_HEIGHT * 0.1

		for i = 1, math.min(letterCount, #fullText) do
			local char = fullText:sub(i, i)

			-- position of this letter
			local x = startX + fonts["menuTitle"]:getWidth(fullText:sub(1, i - 1))

			-- per-letter vertical motion
			local y = baseY + math.sin(t * 4 + i * 0.4) * (VIRTUAL_HEIGHT * 0.02)

			-- per-letter color variation
			local r = 0.5 + 0.5 * math.sin(t + i * 0.2)
			local g = 0.5 + 0.5 * math.sin(t + 2 + i * 0.3)
			local b = 0.5 + 0.5 * math.sin(t + 4 + i * 0.5)

			love.graphics.setColor(r, g, b, 1)
			love.graphics.print(char, x, y)
		end

		-- local t = menuAnim.t or 0
		-- -- title
		-- local y = VIRTUAL_HEIGHT * 0.1 + math.sin(t * 2) * VIRTUAL_HEIGHT * 0.025
		-- local r = 0.5 + 0.5 * math.sin(t)
		-- local g = 0.5 + 0.5 * math.sin(t + 2)
		-- local b = 0.5 + 0.5 * math.sin(t + 4)
		--
		-- -- text reveal
		-- local fullText = "Sunlab 15"
		-- local speed = 10 -- letters per second
		-- local letters = math.floor(t * speed)
		-- local visibleText = fullText:sub(1, letters)
		--
		-- love.graphics.setFont(fonts["menuTitle"])
		-- love.graphics.setColor(r, g, b, 1)
		-- love.graphics.printf(visibleText, 0, y, VIRTUAL_WIDTH, "center")

		-- love.graphics.setFont(fonts["menuTitle"])
		-- love.graphics.setColor(r, g, b, 1)
		-- love.graphics.printf("Sunlab 15", 0, y, VIRTUAL_WIDTH, "center")

		-- highlight selected
		love.graphics.setColor(0.3, 0.4, 0.5)
		love.graphics.rectangle("fill", 0, 100 + (selected * 80), VIRTUAL_WIDTH, 80)

		-- menu items
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(fonts["menuItem"])
		love.graphics.printf("Start", 0, 200, VIRTUAL_WIDTH, "center")
		love.graphics.printf("Credits", 0, 280, VIRTUAL_WIDTH, "center")
		love.graphics.printf("Exit", 0, 360, VIRTUAL_WIDTH, "center")
	elseif state == "select_game" then
		drawSelectionMenu()
	elseif state == "credits" then
		drawCredits()
	elseif state == "playing" then
		if minigameModule and minigameModule.draw then
			minigameModule.draw()
		else
			love.graphics.setColor(1, 0.2, 0.2, 1)
			love.graphics.printf(
				"Error: Could not load minigame!\nPress ESC to return to menu.",
				0,
				love.graphics.getHeight() / 2 - 40,
				love.graphics.getWidth(),
				"center"
			)
			love.graphics.setColor(1, 1, 1, 1)
		end
	end

	push:finish()
end


local function drawFit(drawable, x, y, maxW, maxH)
	love.graphics.setColor(1, 1, 1, 1)
	local w, h = drawable:getWidth(), drawable:getHeight()

	local scale = math.min(maxW / w, maxH / h)

	love.graphics.draw(drawable, x, y, 0, scale, scale)
end

function drawCredits()
	local t = menuAnim.t or 0
	local r = 0.7 + 0.3 * math.sin(t)
	local g = 0.7 + 0.3 * math.sin(t + 2)
	local b = 0.7 + 0.3 * math.sin(t + 4)
	love.graphics.clear(r, g, b, 1)
	drawFit(logos["tn"], 20, 8, 120, 120)
	drawFit(logos["politiche"], 200, 9, 84, 84)
	drawFit(logos["piano"], 320, 8, 110, 110)
	drawFit(logos["appm"], 460, 30, 155, 155)

	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts["menuItem"])
	love.graphics.printf("Credits", 150, 120, VIRTUAL_WIDTH - 300, "center")
	love.graphics.setFont(fonts["creditsFont"])
	love.graphics.printf(
		"Out of the Game Team: \nEnea, Thomas, Virginia, Raymi, Lorenzo, Gabriele, Simone A, Tommaso, Simone F, Fabio, Alan, Leonardo, Francesco",
		150,
		200,
		VIRTUAL_WIDTH - 300,
		"center"
	)
	love.graphics.printf("Press any key to return", 100, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH - 200, "center")
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
		if sounds["escape"] then
			sounds["escape"]:play()
		end
		state = "main_menu"
	elseif state == "playing" then
		playingKeypressed(key)
	end
end

function mainMenuKeypressed(key)
	if key == "down" then
		selected = math.min(selected + 1, 3)
		if sounds["down"] then
			sounds["down"]:play()
		end
	elseif key == "up" then
		selected = math.max(selected - 1, 1)
		if sounds["up"] then
			sounds["up"]:play()
		end
	elseif key == "return" then
		if sounds["enter"] then
			sounds["enter"]:play()
		end
		if selected == 1 then
			state = "select_game"
		elseif selected == 2 then
			state = "credits"
		elseif selected == 3 then
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

	if key == "right" then
		selected = math.min(selected + 1, #games)
		if sounds["down"] then
			sounds["down"]:play()
		end
	elseif key == "left" then
		selected = math.max(selected - 1, 1)
		if sounds["up"] then
			sounds["up"]:play()
		end
	elseif key == "up" then
		selected = math.max(selected - 5, 1)
		if sounds["up"] then
			sounds["up"]:play()
		end
	elseif key == "down" then
		selected = math.min(selected + 5, 15)
		if sounds["up"] then
			sounds["up"]:play()
		end
	elseif key == "return" then
		-- Start minigame
		if sounds["enter"] then
			sounds["enter"]:play()
		end
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
		if sounds["escape"] then
			sounds["escape"]:play()
		end
		state = "main_menu"
	end
end

function playingKeypressed(key)
	if key == "escape" then
		VIRTUAL_WIDTH = 640 -- Virtual width of the game window
		VIRTUAL_HEIGHT = 480 -- Virtual height of the game window
		returnToSelection()
	elseif minigameModule and minigameModule.keypressed then
		minigameModule.keypressed(key)
	end
end

function love.mousepressed(x, y, button)
	if state == "playing" then
		if minigameModule and minigameModule.mousepressed then
			minigameModule.mousepressed(x, y, button)
		end
	end
end

function love.mousereleased(x, y, button)
	if state == "playing" then
		if minigameModule and minigameModule.mousereleased then
			minigameModule.mousereleased(x, y, button)
		end
	end
end
