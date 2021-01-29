local Class = require("libs.hump.class")
local Entity = require("entities.Entity")
local Types = require("entities.Types")
local Colors = require("util.Colors")

local Obstacle = Class{
    __includes=Entity
}

local obstacle=love.graphics.newImage('img/obstacle.png')



function Obstacle:init(world,x,y,w,h)
    Entity.init(self,world,x,y,w,h)
    self.speed=500
    self.color=Colors.white

    self.type=Types.obstacle
    self.gameover=false
end

function Obstacle:rightPosition()
    return self.x+self.w
end

function Obstacle:offScreen()
    return self:rightPosition()<0
end

function Obstacle:setSpeed(s)
    self.speed=s
end

function Obstacle:update(dt)
    self.x,self.y,collisions=self.world:move(self,self.x-self.speed*dt,self.y)


    for i, c in pairs(collisions) do
        if c.other:getType() == Types.player then
          self.gameover = true
        end
    end
end

function Obstacle:draw()
    
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill",self:getRect())
    love.graphics.draw(obstacle, self.x-self.w/4, self.y ,r,.25,.25)
end

return Obstacle