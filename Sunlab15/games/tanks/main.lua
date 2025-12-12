
local module = {}
-- Game state
gameState = "playing" -- playing, gameOver
winner = nil

-- Tank properties
Tank = {}
Tank.__index = Tank

function Tank.new(x, y, isPlayer1)
    local self = setmetatable({}, Tank)
    self.x = x
    self.y = y
    self.angle = 0
    self.size = 15
    self.speed = 150
    self.rotationSpeed = 5
    self.health = 3
    self.maxHealth = 3
    self.isPlayer1 = isPlayer1
    self.canShoot = true
    self.shootCooldown = 0
    self.shootCooldownMax = 0.3
    return self
end

function Tank:update(dt, keysPressed)
    -- Handle shooting cooldown
    if self.shootCooldown > 0 then
        self.shootCooldown = self.shootCooldown - dt
    end

    if self.isPlayer1 then
        -- Player 1 controls: WASD for movement, Q/E for rotation, Space to shoot
        if love.keyboard.isDown('w') then
            self.x = self.x + math.cos(self.angle) * self.speed * dt
            self.y = self.y + math.sin(self.angle) * self.speed * dt
        end
        if love.keyboard.isDown('s') then
            self.x = self.x - math.cos(self.angle) * self.speed * dt
            self.y = self.y - math.sin(self.angle) * self.speed * dt
        end
        if love.keyboard.isDown('a') then
            self.angle = self.angle - self.rotationSpeed * dt
        end
        if love.keyboard.isDown('d') then
            self.angle = self.angle + self.rotationSpeed * dt
        end
        if keysPressed['space'] and self.shootCooldown <= 0 then
            self:shoot()
            self.shootCooldown = self.shootCooldownMax
        end
    else
        -- Player 2 controls: Arrow keys for movement, o/p for rotation, Return to shoot
        if love.keyboard.isDown('up') then
            self.x = self.x + math.cos(self.angle) * self.speed * dt
            self.y = self.y + math.sin(self.angle) * self.speed * dt
        end
        if love.keyboard.isDown('down') then
            self.x = self.x - math.cos(self.angle) * self.speed * dt
            self.y = self.y - math.sin(self.angle) * self.speed * dt
        end
        if love.keyboard.isDown('left') then
            self.angle = self.angle - self.rotationSpeed * dt
        end
        if love.keyboard.isDown('right') then
            self.angle = self.angle + self.rotationSpeed * dt
        end
        if keysPressed['return'] and self.shootCooldown <= 0 then
            self:shoot()
            self.shootCooldown = self.shootCooldownMax
        end
    end

    -- Keep tank in bounds
    self.x = math.max(self.size, math.min(VIRTUAL_WIDTH - self.size, self.x))
    self.y = math.max(self.size, math.min(VIRTUAL_HEIGHT - self.size, self.y))
end

function Tank:shoot()
    local speed = 300
    local projectile = {
        x = self.x + math.cos(self.angle) * self.size,
        y = self.y + math.sin(self.angle) * self.size,
        vx = math.cos(self.angle) * speed,
        vy = math.sin(self.angle) * speed,
        owner = self,
        size = 4
    }
    table.insert(projectiles, projectile)
end

function Tank:draw()
    love.graphics.setColor(self.isPlayer1 and {0, 1, 0, 1} or {1, 0, 0, 1})
    
    -- Draw tank body
    love.graphics.rectangle('fill', self.x - self.size/2, self.y - self.size/2, self.size, self.size)
    
    -- Draw tank turret
    love.graphics.setLineWidth(3)
    local turretLength = self.size * 1.5
    love.graphics.line(
        self.x,
        self.y,
        self.x + math.cos(self.angle) * turretLength,
        self.y + math.sin(self.angle) * turretLength
    )
    
    -- Draw health bar
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', self.x - self.size, self.y - self.size - 15, self.size * 2, 8)
    
    -- Draw health fill
    local healthPercent = math.max(0, self.health / self.maxHealth)
    if healthPercent > 0.5 then
        love.graphics.setColor(0, 1, 0, 1)
    elseif healthPercent > 0.25 then
        love.graphics.setColor(1, 1, 0, 1)
    else
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.rectangle('fill', self.x - self.size + 1, self.y - self.size - 14, (self.size * 2 - 2) * healthPercent, 6)
end

function Tank:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.health = 0
        return true -- tank is dead
    end
    return false
end

-- Projectile update
function updateProjectiles(dt)
    for i = #projectiles, 1, -1 do
        local proj = projectiles[i]
        proj.x = proj.x + proj.vx * dt
        proj.y = proj.y + proj.vy * dt

        -- Check bounds
        if proj.x < 0 or proj.x > VIRTUAL_WIDTH or proj.y < 0 or proj.y > VIRTUAL_HEIGHT then
            table.remove(projectiles, i)
            goto continue
        end

        -- Check collision with tanks
        if proj.owner ~= tanks[1] and checkCollision(proj, tanks[1]) then
            if tanks[1]:takeDamage(1) then
                gameState = "gameOver"
                winner = tanks[2]
            end
            table.remove(projectiles, i)
            goto continue
        end

        if proj.owner ~= tanks[2] and checkCollision(proj, tanks[2]) then
            if tanks[2]:takeDamage(1) then
                gameState = "gameOver"
                winner = tanks[1]
            end
            table.remove(projectiles, i)
            goto continue
        end

        ::continue::
    end
end

function checkCollision(projectile, tank)
    local dx = projectile.x - tank.x
    local dy = projectile.y - tank.y
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (projectile.size + tank.size)
end

function drawProjectiles()
    love.graphics.setColor(1, 1, 0, 1)
    for _, proj in ipairs(projectiles) do
        love.graphics.circle('fill', proj.x, proj.y, proj.size)
    end
end

function module.load()

    tanks = {
        Tank.new(100, VIRTUAL_HEIGHT / 2, true),
        Tank.new(VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT / 2, false)
    }
    projectiles = {}
    love.keyboard.keysPressed = {}
end


function module.update(dt)
    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    end

    if gameState == "playing" then
        for _, tank in ipairs(tanks) do
            tank:update(dt, love.keyboard.keysPressed)
        end
        updateProjectiles(dt)
    elseif gameState == "gameOver" then
        if love.keyboard.keysPressed['space'] then
            -- Reset game
            tanks = {
                Tank.new(100, VIRTUAL_HEIGHT / 2, true),
                Tank.new(VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT / 2, false)
            }
            projectiles = {}
            gameState = "playing"
            winner = nil
        end
    end

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end

function module.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function module.draw()

    love.graphics.clear(0.1, 0.1, 0.1, 1)

    if gameState == "playing" then
        -- Draw game
        for _, tank in ipairs(tanks) do
            tank:draw()
        end
        drawProjectiles()
        
        -- Draw instructions
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setFont(love.graphics.newFont(10))
        love.graphics.print("P1: WASD+QE+Space", 10, 10)
        love.graphics.print("P2: Arrows+OP+Return", 10, 25)
    else
        -- Game Over screen
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(32))
        local winnerText = winner.isPlayer1 and "PLAYER 1 WINS!" or "PLAYER 2 WINS!"
        local textWidth = love.graphics.getFont():getWidth(winnerText)
        love.graphics.print(winnerText, (VIRTUAL_WIDTH - textWidth) / 2, VIRTUAL_HEIGHT / 2 - 40)
        
        love.graphics.setFont(love.graphics.newFont(16))
        local restartText = "Press SPACE to restart"
        local restartWidth = love.graphics.getFont():getWidth(restartText)
        love.graphics.print(restartText, (VIRTUAL_WIDTH - restartWidth) / 2, VIRTUAL_HEIGHT / 2 + 40)
    end

    displayFPS()
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(love.graphics.newFont(10))
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, VIRTUAL_HEIGHT - 15)
end


return module
