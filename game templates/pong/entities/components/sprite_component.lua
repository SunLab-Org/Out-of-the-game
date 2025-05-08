local class = require "libraries.hump.class"
local anim8 = require "libraries.anim8.anim8"

local spriteComponent = class{
    init = function(self, filepath, gridheight, gridwidth, gridx, gridy, frames, duration, xoffset, yoffset, body)
        assert(body)

        local image = love.graphics.newImage(filepath)
        local grid = anim8.newGrid(gridwidth, gridheight, image:getWidth(), image:getHeight())
        local animation = anim8.newAnimation(grid(gridx..'-'..gridy, frames), duration)

        self.xoffset = xoffset
        self.yoffset = yoffset

        self.body = body
        self.image = image
        self.sprite = animation

    end,
    draw = function(self)
        local x, y = self.body:getPosition()
        self.sprite:draw(self.image, x - self.xoffset, y - self.yoffset)
    end

}

return spriteComponent