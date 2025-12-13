require 'games/flappy/StateMachine'

require 'games/flappy/states/BaseState'
require 'games/flappy/states/CountdownState'
require 'games/flappy/states/PlayState'
require 'games/flappy/states/ScoreState'
require 'games/flappy/states/TitleScreenState'

require 'games/flappy/Bird'
require 'games/flappy/Pipe'
require 'games/flappy/PipePair'


local M = {}

local background
local backgroundScroll = 0

local ground
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

-- global variable we can use to scroll the map
local scrolling = true

gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }

function M.load()
    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('games/flappy/font.ttf', 8)
    mediumFont = love.graphics.newFont('games/flappy/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('games/flappy/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('games/flappy/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- load images
    background = love.graphics.newImage('games/flappy/background.png')
    ground = love.graphics.newImage('games/flappy/ground.png')

    -- initialize our table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('games/flappy/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('games/flappy/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('games/flappy/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('games/flappy/score.wav', 'static'),
    }


    -- initialize state machine with all state-returning functions
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end


function M.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        sounds['music']:stop()
        returnToSelection()
    end
end

function M.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function M.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % (BACKGROUND_LOOPING_POINT/2)
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % (VIRTUAL_WIDTH/2)
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function M.draw()
    local bgWidth = background:getWidth()
    local bgHeight = background:getHeight()
    local scaleX = VIRTUAL_WIDTH / bgWidth
    local scaleY = VIRTUAL_HEIGHT / bgHeight
    love.graphics.draw(background, -backgroundScroll, 0, 0, scaleX*1.5, scaleY)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    -- love.graphics.setColor(0,0,0)
    -- love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, 16)
end

return M