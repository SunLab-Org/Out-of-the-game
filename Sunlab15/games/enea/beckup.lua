local x = 30

print(mathias)

mathias = 10

print(mathias)


function love.load()

end

function love.update(dt)

end

function love.draw()
    print('test')
    print('test2')
    love.graphics.setColor(100/255, 175/255, 30/255)
    love.graphics.rectangle("fill", 150, 100, 500, 400) 
    love.graphics.setColor(210/255, 153/255, 10/255)
    love.graphics.circle("fill", 400, 300, 170, 170)
    love.graphics.setColor(0/255, 0/255, 0/255)
    fontimportante = love.graphics.newFont(40)
    love.graphics.setFont(fontimportante)
    love.graphics.print("Ciao", 360, 270)
    love.graphics.circle("line", 400, 300, 170, 170)
end