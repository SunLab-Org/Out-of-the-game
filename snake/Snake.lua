-- local class = require("class")
Snake = Class{} 

local SNAKE_SIZE = 10 -- Size of each segment of the snake
local STARTING_LENGTH = 5 -- Starting length of the snake


function Snake:init(x, y)
    self.x = x or 0
    self.y = y or 0
    self.direction = 'right'

    self.width = SNAKE_SIZE
    self.height = SNAKE_SIZE

    self.length = STARTING_LENGTH
    self.body = {}

    for i = 1, STARTING_LENGTH do -- from 1 to STARTING_LENGTH 
        table.insert(self.body, { -- Insert a new segment into the snake table
            x = STARTING_POS.x - (i * SNAKE_SIZE), -- Calculate the x position of the segment
            y = STARTING_POS.y -- Set the y position of the segment
        })
    end
end


function Snake:update(dt)
    -- handle input 
    if (love.keyboard.isDown('up') or love.keyboard.isDown('k')) and self.direction ~= 'down' then -- If the up key is pressed and the snake is not moving down
        self.direction = 'up'
    elseif (love.keyboard.isDown('j') or love.keyboard.isDown('down')) and self.direction ~= 'up' then -- If the down key is pressed and the snake is not moving up
        self.direction = 'down'
    elseif (love.keyboard.isDown('h') or love.keyboard.isDown('left')) and self.direction ~= 'right' then -- If the left key is pressed and the snake is not moving right
        self.direction = 'left'
    elseif (love.keyboard.isDown('l') or love.keyboard.isDown('right')) and self.direction ~= 'left' then -- If the right key is pressed and the snake is not moving left
        self.direction = 'right'
    end

    -- move the body
    for i = #self.body, 2, -1 do -- Iterate through the self.body segments from the end to the beginning
        self.body[i].x = self.body[i - 1].x -- Set the x position of the current segment to the x position of the previous segment
        self.body[i].y = self.body[i - 1].y -- Set the y position of the current segment to the y position of the previous segment
    end

    -- move the head
    if self.direction == 'up' then -- If the self.directory is up
        self.body[1].y = self.body[1].y - SNAKE_SIZE -- % VIR  Move the head up
        if self.body[1].y < 0 then -- If the head goes out of bounds
            self.body[1].y = VIRTUAL_HEIGHT - SNAKE_SIZE -- Wrap around to the bottom 
        end

    elseif self.direction == 'down' then -- If the self.directory is down
        self.body[1].y = (self.body[1].y + SNAKE_SIZE) % VIRTUAL_HEIGHT -- Move the head down

    elseif self.direction == 'left' then -- If the self.directory is left
        self.body[1].x = self.body[1].x - SNAKE_SIZE -- Move the head left
        if self.body[1].x < 0 then -- If
            self.body[1].x = VIRTUAL_WIDTH - SNAKE_SIZE -- Wrap around to the right
        end
    elseif self.direction == 'right' then -- If the self.directory is right
        self.body[1].x = (self.body[1].x + SNAKE_SIZE) % VIRTUAL_WIDTH -- Move the head right
    end

    -- check for collision with the body
    -- for i = 2, #self.body do -- Iterate through the self.body segments starting from the second segment
    --     if self.body[1].x == self.body[i].x and self.body[1].y == self.body[i].y then -- If the head collides with any segment
    --         is_game_over = true -- Set the game over flag to true
    --     end
    -- end
end


function Snake:render()
    for i, segment in ipairs(self.body) do -- Iterate through each segment of the snake
        love.graphics.setColor(0, 255, 0, 255) -- Set color to green
        love.graphics.rectangle('fill', segment.x, segment.y, SNAKE_SIZE, SNAKE_SIZE) -- Draw each segment as a rectangle
    end
end
