local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
	require("lldebugger").start()

	function love.errorhandler(msg)
		error(msg, 2)
	end
end


function love.conf(t)    
    t.console = true 
    t.identity = "gamedev/data/save"
    t.gammacorrect = true

    -- t.window.fullscreen = true
    t.window.resizable = false
    t.window.title = "pong"
    t.window.height = 720
    t.window.width = 1280
end