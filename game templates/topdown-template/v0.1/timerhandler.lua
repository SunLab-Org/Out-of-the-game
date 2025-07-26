local love = require "love"
local timer = require "timers"

local TimerHandler = {
    timers = {}
}

function TimerHandler:new(time, fun, mode)
    local t = timer.new(time, fun, mode)
    table.insert(TimerHandler.timers, t)
    return t
end


function TimerHandler:update(dt)
    for key, timer in pairs(self.timers) do
        local ret = timer:update(dt)
        if ret == false then
            table.remove(self.timers, key)
            timer = nil
        end
    end
end


return TimerHandler