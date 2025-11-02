--[[
    Player Class
    Author: Francesco Penasa
    francesco.penasa.job@gmail.com
]]

Player = Class({})

local GRAVITY = 50

function _getY(player, height)
	local padding = 10
	if player == "p1" then
		return VIRTUAL_HEIGHT - height - padding
	elseif player == "p2" then
		return VIRTUAL_HEIGHT - height - padding
	end
end

function _getX(player, width)
	local padding = 10
	if player == "p1" then
		return padding
	elseif player == "p2" then
		return VIRTUAL_WIDTH - width - padding
	end
end

function Player:init(player)
	print(player)
	self.player = player -- can be player 1 or player 2
	-- load bird image from disk and assign its width and height
	self.image = love.graphics.newImage("assets/bird.png")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.health = 100

	-- position bird in the middle of the screen
	self.x = _getX(self.player, self.width)
	self.y = _getY(self.player, self.height)

	-- Y velocity; gravity
	self.dx = 100
	self.dy = 0
end

function Player:update(dt)
	-- apply gravity to velocity
	self.dy = self.dy + GRAVITY * dt

	self.y = self.y + self.dy * dt

	-- player 1
	if self.player == "p1" then
		up = "w"
		down = "s"
		left = "a"
		right = "d"
	-- player 2
	elseif self.player == "p2" then
		up = "up"
		down = "down"
		left = "left"
		right = "right"
	end

	-- handle button
	if love.keyboard.wasPressed(up) then
		self.dy = -100
		print("jump")
	end
	if love.keyboard.isDown(left) then
		self.x = self.x - self.dx * dt
	end

	if love.keyboard.isDown(right) then
		self.x = self.x + self.dx * dt
	end

	if love.keyboard.wasPressed("h") and self.health > 0 then
		self.health = self.health - 10
	end

	-- limit
	self.x = math.max(0, self.x)
	self.x = math.min(VIRTUAL_WIDTH - self.width, self.x)
	self.y = math.min(_getY(self.player, self.height), self.y)
end

function Player:render()
	-- player
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.image, self.x, self.y)

	-- healthbar
	if self.player == "p1" then
		x = 10
	elseif self.player == "p2" then
		x = VIRTUAL_WIDTH / 2 + 10
	end
	-- yellow
	love.graphics.setColor(1, 1, 0)
	love.graphics.rectangle("fill", x, 10, VIRTUAL_WIDTH / 2 - 20, 20)

	-- red
	love.graphics.setColor(1, 0, 0)
	if self.player == "p1" then
		love.graphics.rectangle("fill", x, 10, (VIRTUAL_WIDTH / 2 - 20) * (100 - self.health) / 100, 20)
	elseif self.player == "p2" then
		love.graphics.rectangle(
			"fill",
			VIRTUAL_WIDTH - 10 - (VIRTUAL_WIDTH / 2 - 20) * (100 - self.health) / 100,
			10,
			(VIRTUAL_WIDTH / 2 - 20) * (100 - self.health) / 100,
			20
		)
	end
end
