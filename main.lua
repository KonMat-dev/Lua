gamestate = require("libs.hump.gamestate")
local menu = require("gamestates.menu")

function love.load()
  gamestate.registerEvents()
  gamestate.switch(menu)
end

function love.keypressed(key)
  if key == "escape" or key == "q" then
    love.event.push("quit")
  end
end
