-- local class = require("class")
Snake = Class {}

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


function Snake:collide(self) -- Check for collision with the snake body
    for i = 2, #self.body do -- Iterate through the self.body segments starting from the second segment
        if self.body[1].x == self.body[i].x and self.body[1].y == self.body[i].y then -- If the head collides with any segment
            return true -- Set the game over flag to true
        end
    end
    return false -- Return false if no collision is detected
end


function Snake:eat(food) -- Check if the snake eats the food
    if food:collide(self) then -- If the food collides with the snake
        self.length = self.length + 1 -- Increase the length of the snake
        table.insert(self.body, { -- Insert a new segment into the snake table
            x = self.body[#self.body].x, -- Set the x position of the new segment to the last segment's x position
            y = self.body[#self.body].y -- Set the y position of the new segment to the last segment's y position
        })
        food:reset() -- Reset the food position
    end
end


function Snake:update(dt)

    if Snake:collide(self) then -- Check for collision with the snake body
        is_game_over = true -- Set the game over flag to true
    end

    if is_game_over then -- If the game is over
        return -- Return to stop updating the snake
    end

    handleInput(self) -- Call the handleInput function to update the snake's direction
    moveBody(self) -- Call the moveBody function to update the snake's body
    moveHead(self) -- Call the moveHead function to update the snake's head

end

function Snake:render()
    for i, segment in ipairs(self.body) do -- Iterate through each segment of the snake
        love.graphics.setColor(0, 255, 0, 255) -- Set color to green
        love.graphics.rectangle('fill', segment.x, segment.y, SNAKE_SIZE, SNAKE_SIZE) -- Draw each segment as a rectangle
    end
end



function handleInput(self) -- Handle input for the snake
    if (love.keyboard.wasPressed('up')) and self.direction ~= 'down' then -- If the up key is pressed and the snake is not moving down
        self.direction = 'up'
    elseif (love.keyboard.wasPressed('down')) and self.direction ~= 'up' then -- If the down key is pressed and the snake is not moving up
        self.direction = 'down'
    elseif (love.keyboard.wasPressed('left')) and self.direction ~= 'right' then -- If the left key is pressed and the snake is not moving right
        self.direction = 'left'
    elseif (love.keyboard.wasPressed('right')) and self.direction ~= 'left' then -- If the right key is pressed and the snake is not moving left
        self.direction = 'right'
    end
end

function moveBody(self) -- Move the body of the snake
    -- if (is is growind)
    -- parti dal terzo
    -- else
    for i = #self.body, 2, -1 do -- Iterate through the self.body segments from the end to the beginning
        self.body[i].x = self.body[i - 1].x -- Set the x position of the current segment to the x position of the previous segment
        self.body[i].y = self.body[i - 1].y -- Set the y position of the current segment to the y position of the previous segment
    end
end

function moveHead(self)

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
end
