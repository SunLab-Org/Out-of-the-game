local module = {}
local player = {x = 256, y = 430, w = 32, h = 32, speed = 250}

local bullets = {}
local bulletSpeed = 400
local monsters = {}
local score = 0
local gameOver = false
local gameOverTimer = 0

local monsterImage
local bulletImage
local monsterSpeed = 50
local monsterDirection = 1
local spawnTimer = 0
local spawnRate = 1.5

function module.load()
    local numMonsters = 15
    local gameWidth = VIRTUAL_WIDTH
    local gameHeight = VIRTUAL_HEIGHT / 2
    local monsterWidth = 32
    local monsterHeight = 32
    
    -- Spawn initial enemies in a grid pattern
    for row = 0, 2 do
        for col = 0, 4 do
            local randomX = 50 + col * 110
            local randomY = 30 + row * 60
            table.insert(monsters, {
                x = randomX,
                y = randomY,
                w = monsterWidth,
                h = monsterHeight,
                health = 1
            })
        end
    end

    -- Load images with error handling
    if love.filesystem.getInfo("games/fabio/pixilart-drawing (2).png") then
        monsterImage = love.graphics.newImage("games/fabio/pixilart-drawing (2).png")
    end
    if love.filesystem.getInfo("games/fabio/pixilart-drawing (4).png") then
        bulletImage = love.graphics.newImage("games/fabio/pixilart-drawing (4).png")
    end
    
    score = 0
    gameOver = false
    gameOverTimer = 0
    bullets = {}
end


function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x1 + w1 > x2 and
           y1 < y2 + h2 and
           y1 + h1 > y2
end

function module.update(dt)
    if gameOver then
        gameOverTimer = gameOverTimer + dt
        return
    end
    
    -- Player movement
    if love.keyboard.isDown("left", "a") then
        player.x = math.max(0, player.x - player.speed * dt)
    end
    if love.keyboard.isDown("right", "d") then
        player.x = math.min(VIRTUAL_WIDTH - player.w, player.x + player.speed * dt)
    end

    -- Update bullet positions
    for i = #bullets, 1, -1 do
        bullets[i].y = bullets[i].y - bulletSpeed * dt
        
        -- Remove bullets that go off screen
        if bullets[i].y < 0 then
            table.remove(bullets, i)
        end
    end

    -- Update monster positions (Space Invaders style movement)
    spawnTimer = spawnTimer + dt
    if spawnTimer > spawnRate and #monsters < 20 then
        spawnTimer = 0
        table.insert(monsters, {
            x = math.random(0, VIRTUAL_WIDTH - 32),
            y = 10,
            w = 32,
            h = 32,
            health = 1
        })
    end

    local shouldChangeDirection = false
    for i, monster in ipairs(monsters) do
        monster.x = monster.x + monsterSpeed * monsterDirection * dt
        monster.y = monster.y + 10 * dt
        
        -- Check boundaries for direction change
        if monster.x <= 0 or monster.x + monster.w >= VIRTUAL_WIDTH then
            shouldChangeDirection = true
        end
        
        -- Game over if monster reaches bottom
        if monster.y > VIRTUAL_HEIGHT then
            gameOver = true
            gameOverTimer = 0
        end
    end

    if shouldChangeDirection then
        monsterDirection = monsterDirection * -1
    end

    -- Collision detection
    for i = #monsters, 1, -1 do
        local monster = monsters[i]
        if monster then
            for j = #bullets, 1, -1 do
                local bullet = bullets[j]
                if bullet then
                    if checkCollision(
                        monster.x, monster.y, monster.w, monster.h,
                        bullet.x, bullet.y, bullet.w, bullet.h
                    ) then
                        table.remove(bullets, j)
                        monster.health = monster.health - 1
                        if monster.health <= 0 then
                            table.remove(monsters, i)
                            score = score + 10
                        end
                        break
                    end
                end
            end
        end
    end
end


function module.keypressed(key)
    if key == "space" then
        -- Create bullets from left and right sides of player
        -- Left bullet
        table.insert(bullets, {
            x = player.x - 8,
            y = player.y,
            w = 8,
            h = 16
        })
        -- Right bullet
        table.insert(bullets, {
            x = player.x + player.w,
            y = player.y,
            w = 8,
            h = 16
        })
    end
end


function module.draw()
    love.graphics.clear(0.1, 0.2, 0.3)
    
    -- Draw monsters
    love.graphics.setColor(1, 1, 1)
    for i, monster in ipairs(monsters) do
        if monsterImage then
            love.graphics.draw(monsterImage, monster.x, monster.y)
        else
            love.graphics.setColor(1, 0.2, 0.2)
            love.graphics.rectangle("fill", monster.x, monster.y, monster.w, monster.h)
        end
    end

    -- Draw bullets
    love.graphics.setColor(1, 1, 0.2)
    for i, bullet in ipairs(bullets) do
        if bulletImage then
            love.graphics.draw(bulletImage, bullet.x, bullet.y)
        else
            love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.w, bullet.h)
        end
    end
    
    -- Draw player
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", player.x+37, player.y, player.w, player.h)
    
    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: " .. score, 10, 10, VIRTUAL_WIDTH - 20, "left")
    
    -- Draw game over screen
    if gameOver then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("GAME OVER", 0, VIRTUAL_HEIGHT/2 - 40, VIRTUAL_WIDTH, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Final Score: " .. score, 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, "center")
    end
end


return module