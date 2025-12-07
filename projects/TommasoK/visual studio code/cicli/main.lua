local lgbt = 800
local gay = 600
local x = 0
local y = 0
local adolfo = 0


function love. load()
    love.window.setMode(lgbt, gay, {})
end

function love.updat(dt)
    adolfo = 0
end

function love.draw()

    while (adolfo < gay ) do 
        love.graphics.rectangle("fill", x + adolfo, y + adolfo, 5, 2*adolfo)
        adolfo = adolfo + 1
    end
    adolfo = 0
end
