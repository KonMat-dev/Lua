
local Class  = require("libs.hump.class")
local Entity = require("entities.Entity")
local Types  = require("entities.Types")
local Colors = require("util.Colors")

local time

local Player = Class{
  __includes = Entity 
}





local Directions = { up = "up", down = "down", crouch = "crouch", still = "still" }

function Player:init(world, x, y, w, h)
  Entity.init(self, world, x, y, w, h)
  self.standHeight = h
  self.crouchHeight  = h / 2
  self.standY = y
  self.crouchY = y + self.crouchHeight
  self.color = Colors.white
  self.direction = Directions.still

  self.yVelocity = 0
  self.yAcc      = 600
  self.yMaxSpeed = 20
  self.gravity   = 70
  self.atMaxHeight = false
  self.friction  = 5 

  self.type = Types.player

  runSprites={}
  slideSprites={}
  for i=1,9 do
    table.insert(runSprites,love.graphics.newImage("animation/r"..i..".png"))
  end
  for i=1,9 do
    table.insert(slideSprites,love.graphics.newImage("animation/s"..i..".png"))
  end
  currentFrame=1


  self.gameover = false
  time = 0
end

function Player:collisionFilter(other)
  if other:getType() == Types.ground then return "slide"
  elseif other:getType() == Types.barrier then return "touch"
  else return nil
  end
end

function Player:standOrCrouch()
  if self:isDirection(Directions.crouch) then
    self.h = self.crouchHeight
    self.y = self.crouchY
    self.world:update(self, self:getRect())
  else
    self.h = self.standHeight
    self.world:update(self, self:getRect())
  end
end

function Player:update(dt)
  if love.keyboard.isDown("up") then self:setDirection(Directions.up) end
  if love.keyboard.isDown("down") then self:setDirection(Directions.crouch) end

  if self:isDirection(Directions.up) then
    if -self.yVelocity < self.yMaxSpeed and not self.hasReachedMax then
      self.yVelocity = self.yVelocity - self.yAcc * dt
    elseif math.abs(self.yVelocity) > self.yMaxSpeed then
      self.hasReachedMax = true
      self.direction = Directions.down
    end

  end
  
  self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

  if self:isDirection(Directions.still) and self:isDirection(Directions.crouch) then
    self.yVelocity = 0
  else
    self.yVelocity = self.yVelocity + self.gravity * dt
  end

  currentFrame = currentFrame + 10 * dt
  if currentFrame >= 10 then
      currentFrame = 1
  end

  self:standOrCrouch()

  local goalY = self.y + self.yVelocity
  self.x, self.y, collisions, len = self.world:move(self, self.x, goalY, self.collisionFilter)

  -- collisions
  for i, c in ipairs(collisions) do
    if c.other:getType() == Types.barrier then
      self.gameover = true
    elseif c.other:getType() == Types.ground and c.normal.y == -1 then 
      self.hasReachedMax = false
      if self:isDirection(Directions.down) then
        self.direction = Directions.still
      end
    end
  end

  time = time + dt
end

-- Helper function
function Player:isDirection(dir)
  return self.direction == dir
end

-- Used for handling key presses/downs
function Player:setDirection(newDir)
  if newDir == Directions.up and self:isDirection(Directions.still) then
    self.direction = newDir
  elseif newDir == Directions.crouch and self:isDirection(Directions.still) then
    self.direction = newDir
  elseif newDir == Directions.down or newDir == Directions.still then
    self.direction = newDir
  end
end

function Player:draw()
  -- love.graphics.rectangle("fill", self:getRect())
  if self.y==self.crouchY then
    love.graphics.draw(slideSprites[math.floor(currentFrame)], self.x-self.w, self.y-30 ,r,.3,.25)
  else
    love.graphics.draw(runSprites[math.floor(currentFrame)], self.x-self.w+5, self.y ,r,.3,.25)
  end



end

function Player:keyToDir(key)
  if key == "up" then
    return Directions.up
  elseif key == "down"then
    return Directions.down
  elseif key == "crouch" then
    if self.yVelocity==0 then
      return Directions.crouch
    else
      return
    end
  else
    return Directions.still
  end
end

return Player
