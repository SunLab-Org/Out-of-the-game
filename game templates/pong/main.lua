local love = require "love"
local GamestateManager = require "gamestates.gamestateManager"
local signal = require "libraries.hump.signal"
require "entities.modules.maploader"

function love.load()
    GSM = GamestateManager()
    Maploader:loadMap("pongmap")

    _G = {
        _score1 = 0,
        _score2 = 0
    }
    

    signal.register("score_1", function() _G._score1 = _G._score1 + 1 end )
    signal.register("score_2", function() _G._score2 = _G._score2 + 1 end )

end

function love.keypressed(key)
    GSM:keypressed(key)
end