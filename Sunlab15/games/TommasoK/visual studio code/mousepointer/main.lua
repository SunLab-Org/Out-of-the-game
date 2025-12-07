local vecchiax = 0
local vecchiay = 0
local lg = 0
local bt = 0

function love.load()

end

function love.update(dt)

end

function love.draw()
    vecchiax = lg
    vecchiay = bt
    lg, bt = love.mouse.getPosition()
    love.graphics.circle("fill", lg+((lg-vecchiax)/2), bt+ ((bt -  vecchiay)/2), 20)
end