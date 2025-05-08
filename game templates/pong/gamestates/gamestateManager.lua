local Gamestate = require "libraries.hump.gamestate"
local class = require "libraries.hump.class"

local gamestateManager = class{
    init = function(self)
        -- fai la lista di tutti i gamestates qui
        self.gamestates = {
            menu = require "gamestates.menu",
            game = require "gamestates.game",
        }
        print(#self.gamestates)

        -- current sarebbe il gamestate attivo, inizializzato a menu
        self.current = self.gamestates.menu

        Gamestate.registerEvents()

        Gamestate.switch(self.current)
    end,
    
    switch = function(self, gamestate)
        -- switcha il gamestate
        if self.gamestates[gamestate] then
            self.current = self.gamestates[gamestate]
            Gamestate.switch(self.current)
        else
            error("Gamestate " .. gamestate .. " not found.")
        end
    end,

   

}

function gamestateManager:keypressed(key)
    if self.current == self.gamestates.menu then
        if key == "return" then
            self:switch("game")
        end
        if key == "escape" then
            love.event.quit()
        end
    elseif self.current == self.gamestates.game then
        if key == "escape" then
            self:switch("menu")
        end
    end
end


return gamestateManager




