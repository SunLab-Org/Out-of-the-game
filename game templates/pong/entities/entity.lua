local class = require "libraries.hump.class"

local entity = class{
    init = function(self, components, tags)
        self.components = components or {}
        self.tags = tags or {}


    end, 
    update = function(self, dt)
        for _, l in pairs(self.components) do
            if l.update then 
                l:update(dt)
            end
        end
    end,
    draw = function(self, dt)
        if(self.components["physics"]) then
            self.components["physics"]:draw()
        end
    end

}

return entity