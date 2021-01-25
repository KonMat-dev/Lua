local bump      = require("libs.bump.bump")
local Gamestate = require("libs.hump.gamestate")
local serpent   = require("libs.serpent.src.serpent")
local Entities  = require("entities.Entities")
local Entity    = require("entities.Entity")
local Colors    = require("util.Colors")

local IndianaJones = {}

local Player    = require("entities.player")
local Ground  = require("entities.ground")
-- local Barrel = require("entities.barrel")

local FNAME = "scores"
local MAX_ENTRIES = 5


function getImageScaleForNewDimensions( image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end

local background=love.graphics.newImage('img/background.png')
local scaleX, scaleY = getImageScaleForNewDimensions( background, 1024, 780 )

local levelDiff = 150
local baseSpeed = 350

player = nil
ground = nil

function IndianaJones:enter()
  Entities:clear()
  self:saveScore()

  love.graphics.setFont(love.graphics.newFont(14))

  math.randomseed(os.time())

  self.world = bump.newWorld(16)

  Entities:enter(self.world)
  local gWidth, gHeight = love.graphics.getWidth(), 100
  local gX, gY          = 0, love.graphics.getHeight() - gHeight
  ground = Ground(self.world, gX, gY, gWidth, gHeight)
  local pWidth, pHeight = 30, 60
  local pX, pY          = 40, gY - pHeight
  player = Player(self.world, pX, pY, pWidth, pHeight)

  self.groundY = gY
  self.paused = false
  self.score = 0
  self.scoreTable = {}
  self.level = 1 
  self.speed = baseSpeed 

  Entities:addMany({player, ground})
end

function IndianaJones:update(dt)
  if not Entities:gameover() and not self.paused then
    -- self:shouldAddBarrel()
    Entities:update(dt)
    self:updateScore()
    -- Entities:removeFirstBarrel()
  end
end

function IndianaJones:updateScore()
  self.score = self.score + 0.2
end



-- function IndianaJones:shouldAddBarrel()
--   lastBarrel = Entities:getLeftMostBarrel()
--   -- local level = Levels[self.level]
--   -- local dist = math.random(unpack(level.dists))

--   if lastBarrel then
--     fromEdgeDist = love.graphics.getWidth() - lastBarrel:rightPos()
--     if fromEdgeDist > dist then
--       self:addBarrel()
--     end
--   else
--     self:addBarrel()
--   end
-- end

-- function IndianaJones:addBarrel()
--   -- local level = Levels[self.level]
--   -- local width = math.random(unpack(level.widths))
--   -- local height = math.random(unpack(level.heights))
--   local y = self.groundY - 100
--   if math.random() < .25 then y = y - 50 end

--   newBarrel = Barrel(self.world, love.graphics.getWidth(), y, 100, 100)
--   newBarrel:setSpeed(self.speed)
--   Entities:add(newBarrel)
-- end

function IndianaJones:draw()
  love.graphics.draw( background, 0, 0, rotation, scaleX, scaleY )

  Entities:draw()
  love.graphics.setColor(Colors.white)
  love.graphics.print(string.format("score: %d", math.floor(self.score)), 10, 10)
  -- love.graphics.print(math.floor(self.speed), 10, 25)
  if Entities:gameover() then
    love.graphics.setColor(Colors.red)
    local y = 125
    local inc = 25
    love.graphics.printf("gameover",0,y, love.graphics.getWidth(), "center")
    -- Save and display high scores
    local highscores = self:getHighscores()
    love.graphics.setColor(Colors.green)
    if #highscores < MAX_ENTRIES or self.score > highscores[#highscores] then
      love.graphics.printf(string.format("New highscore! %d", self.score),0,y + inc, love.graphics.getWidth(), "center")
    end
    for k,v in ipairs(highscores) do
      local scoreStr = string.format("%d) %d", k, v)
      love.graphics.printf(scoreStr,0,y + inc + inc * k, love.graphics.getWidth(), "center")
    end
  end
end

function IndianaJones:keypressed(key)
  if key == "up" then
    player:setDirection(player:keyToDir(key))
  elseif key == "down" then
    player:setDirection(player:keyToDir("crouch"))
  end
end

function IndianaJones:keyreleased(key)
  if key == "up" then
    player:setDirection(player:keyToDir("down"))
  elseif key == "down" then
    player:setDirection(player:keyToDir("still"))
  elseif key == "p" then
    self.paused = not self.paused
  elseif key == "r" then
    Gamestate.enter(IndianaJones) -- restart
  end
end

function IndianaJones:quit()
  self:saveScore()
end

function IndianaJones:saveScore()
  if self.score then
    local savedTable = self:getHighscores()
    if #savedTable < MAX_ENTRIES or savedTable[MAX_ENTRIES] < self.score then
      if #savedTable >= MAX_ENTRIES then table.remove(savedTable) end
      table.insert(savedTable, self.score)
      table.sort(savedTable, function(a, b) return a > b end) -- descending
    end

    love.filesystem.write(FNAME, serpent.dump(savedTable))
  end
end

function IndianaJones:getHighscores()
  local savedText = love.filesystem.read(FNAME)
  local savedTable = {}
  if savedText then _, savedTable = serpent.load(savedText) end
  return savedTable
end

return IndianaJones
