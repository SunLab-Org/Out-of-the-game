function love.draw()

    local gbr = 200
    local gbrt = 300


  
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", gbr, gbrt, 40)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line",gbr, gbrt, 40, 40) 
end