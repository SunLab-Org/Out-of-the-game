
Food = Class {}

local FOOD_SIZE = 10 -- Size of the food


function Food:init()
    x = math.random(0, VIRTUAL_WIDTH - FOOD_SIZE)
    y = math.random(0, VIRTUAL_HEIGHT - FOOD_SIZE)
    self.x = x - x%FOOD_SIZE -- Align the x position to the grid``
    self.y = y - y%FOOD_SIZE -- Align the y position to the grid
    self.width = FOOD_SIZE
    self.height = FOOD_SIZE
end


function Food:reset() -- Reset the food position
    x = math.random(0, VIRTUAL_WIDTH - FOOD_SIZE)
    y = math.random(0, VIRTUAL_HEIGHT - FOOD_SIZE)
    self.x = x - x%FOOD_SIZE -- Align the x position to the grid``
    self.y = y - y%FOOD_SIZE -- Align the y position to the grid
end


function Food:collide(snake) -- Check for collision with the snake
    -- it is important to only check the head
    if self.x < snake.body[1].x + snake.width and
       self.x + self.width > snake.body[1].x and
       self.y < snake.body[1].y + snake.height and
       self.y + self.height > snake.body[1].y then
        return true -- Return true if a collision is detected
    end
    return false -- Return false if no collision is detected
end


function Food:render() -- Render the food on the screen
    love.graphics.setColor(1, 0, 0, 1) -- Set the color to red
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height) -- Draw the food rectangle
end