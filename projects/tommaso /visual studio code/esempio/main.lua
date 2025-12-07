local caunt = 1
local v = 5




function love.load()

end

function love.update(dt)

    if caunt>= 800 then
        v =  v+ 1
        v = -v 
    end

     if caunt<= 0 then
        v = -v 
        v = v + 10
    end

    caunt = caunt + v
end

function love.draw()
    
    love.graphics.circle("fill", caunt, 100, 20)


end