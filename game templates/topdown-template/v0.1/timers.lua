local love = require "love"

local Timer = {}
Timer.__index = Timer

--[[
    Questa e' una semplice implementazione di un oggetto timer, che esegue
    una funzione al termine di un certo periodo di tempo
]]

function Timer.new(time, fun, mode) 
    print("new timer set")
    local self = setmetatable({}, { __index = Timer })
    self.time = time or 1
    self.fun = fun or function() print("end timer") end
    self.mode = mode or "end"

    if self.mode == "beginning" then
        self.fun()
    end

    return self
end

function Timer:update(dt)
    print("timer updated,", self.time)
    if(self.mode == "during") then
        self.fun()
    end
    self.time = self.time - dt
    if(self.time <= 0) then
        if(self.mode == "end") then 
            self.fun()
        end
        return false
    end
    return true
end


return Timer