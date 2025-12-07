local love = require "love"

GameOver = false

local smallFont = love.graphics.newFont(28)
local mediumFont = love.graphics.newFont(24)
local bigFont = love.graphics.newFont(48)
local restartButton = {
    x = 0,
    y = 0,
    w = 200,
    h = 100
}

function GameOverDraw(punti)
    if GameOver then
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local centerX = w / 2
    local centerY = h / 2

    -- ----- GAME OVER -----
    love.graphics.setFont(bigFont)
    love.graphics.setColor(1, 0, 0)

    local gameOverText = "GAME OVER"
    local gameOverW = bigFont:getWidth(gameOverText)
    local gameOverH = bigFont:getHeight()

    love.graphics.print(gameOverText, centerX - gameOverW / 2, centerY - 150)


    -- ----- PUNTEGGIO -----
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(1, 1, 1)

    local scoreText = "PUNTEGGIO: " .. punti
    local scoreW = mediumFont:getWidth(scoreText)

    love.graphics.print(scoreText, centerX - scoreW / 2, centerY - 40)


    -- ----- BOTTONE -----
    restartButton.w = 200
    restartButton.h = 100
    restartButton.x = centerX - restartButton.w / 2
    restartButton.y = centerY + 60

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill",
        restartButton.x,
        restartButton.y,
        restartButton.w,
        restartButton.h,
        15, 15
    )

    local buttonText = "Gioca ancora"
    local buttonTextW = mediumFont:getWidth(buttonText)
    local buttonTextH = mediumFont:getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(
        buttonText,
        centerX - buttonTextW / 2,
        restartButton.y + restartButton.h / 2 - buttonTextH / 2
    )

    return
  end

end

function GameOver_mousepressed(x, y, key, restartGame)
    if GameOver and key == 1 then
        if x > restartButton.x and
           x < restartButton.x + restartButton.w and
           y > restartButton.y and
           y < restartButton.y + restartButton.h then
            GameOver = false
            restartGame()
        end
    end
end