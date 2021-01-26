local bump      = require("libs.bump.bump")
local Gamestate = require("libs.hump.gamestate")
local serpent   = require("libs.serpent.src.serpent")
local Entities  = require("entities.Entities")
local Entity    = require("entities.Entity")
local Colors    = require("util.Colors")

local IndianaJones = {}

local Player    = require("entities.player")
local Ground  = require("entities.ground")
local Obstacle = require("entities.obstacle")

local FNAME = "scores"
local MAX_ENTRIES = 5


function getImageScaleForNewDimensions( image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end

local background=love.graphics.newImage('img/background.jpg')
-- local barrel=love.graphics.newImage('img/barrel.png')

local scaleX, scaleY = getImageScaleForNewDimensions( background, 1024, 780 )

local baseSpeed = 350

player = nil
ground = nil

function IndianaJones:enter()
  Entities:clear()
  sounds={}
  sounds.music=love.audio.newSource("music/music.mp3","stream")
  sounds.music:setLooping(true)
  sounds.music:setVolume(0.1)
  sounds.music:play()
  sounds.isPlaying=1;
  sounds.musicImage=love.graphics.newImage('img/music_on.png')
  self:saveScore()

  love.graphics.setFont(love.graphics.newFont(14))

  math.randomseed(os.time())

  self.world = bump.newWorld(16)

  --rozmiar podłoża i gracza
  Entities:enter(self.world)
  local gWidth, gHeight = love.graphics.getWidth(), 100
  local gX, gY  = 0, love.graphics.getHeight() - gHeight
  ground = Ground(self.world, gX, gY, gWidth, gHeight)
  local pWidth, pHeight = 50, 120
  local pX, pY = 60, gY - pHeight
  player = Player(self.world, pX, pY, pWidth, pHeight)

  self.groundY = gY
  self.paused = false
  self.score = 0
  self.scoreTable = {}
  self.speed = baseSpeed 

  --dodawanie encji gracza i podłoża
  Entities:addMany({player, ground})
end

function IndianaJones:update(dt)
  if not Entities:gameover() and not self.paused then
    --sprawdzamy czy mozemy dodac przeszkode
    self:shouldAddObstacle()
    Entities:update(dt)
    self:updateScore()
    self:updateSpeed()
    Entities:removeFirstObstacle()
  end
end

function IndianaJones:updateScore()
  self.score = self.score + 0.2
end



function IndianaJones:updateSpeed()
  local increase = (self.score/5)*1
  self.speed=math.min(baseSpeed+increase,900)
end



function IndianaJones:shouldAddObstacle()
  lastObstacle = Entities:getLeftMostObstacle()
  local dist = love.math.random(300,700)
  
  if lastObstacle then
    fromEdgeDist = love.graphics.getWidth() - lastObstacle:rightPosition()
    if fromEdgeDist > dist then
      self:addObstacle()
    end
  else
    self:addObstacle()
  end
end

function IndianaJones:addObstacle()
  local highChance=love.math.random(1,10)
  --rysowanie góry lub dołu, na górę około 25%
  if highChance>7 then
    local width = 50
    local height = 75
    local y = self.groundY - 180
    newObstacle = Obstacle(self.world, love.graphics.getWidth(), y, width, height)
    newObstacle:setSpeed(self.speed)
    Entities:add(newObstacle)
  else
    local width = 50
    local height = 75
    local y = self.groundY - 75
    newObstacle = Obstacle(self.world, love.graphics.getWidth(), y, width, height)
    newObstacle:setSpeed(self.speed)
    Entities:add(newObstacle)
  end

end

function IndianaJones:draw()
  love.graphics.draw( background, 0, 0, rotation, scaleX, scaleY )

  Entities:draw()
  love.graphics.draw(sounds.musicImage,958,5)    

  love.graphics.setColor(Colors.white)
  love.graphics.print(string.format("score: %d", math.floor(self.score)), 10, 10)
  -- love.graphics.print(math.floor(self.speed), 10, 25)
  if Entities:gameover() then
    love.graphics.setColor(Colors.white)
    local y = 125
    local inc = 25
    love.graphics.printf("gameover",0,y, love.graphics.getWidth(), "center")
    -- Save and display high scores
    local highscores = self:getHighscores()
    love.graphics.setColor(Colors.white)
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
    sounds.music:stop()
    Gamestate.enter(IndianaJones) 
  end
  if key=="m" then
    sounds.isPlaying=sounds.isPlaying*-1
    if sounds.isPlaying==-1 then
    sounds.music:stop()
    sounds.musicImage=love.graphics.newImage('img/music_off.png')
    else 
      sounds.music:play()
      sounds.musicImage=love.graphics.newImage('img/music_on.png')
    end
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
