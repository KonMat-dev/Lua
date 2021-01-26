local Class = require("libs.hump.class")
local Entity = require("entities.Entity")
local Types = require("entities.Types")
local Colors = require("util.Colors")

local Barrel = Class{
    __includes=Entity
}

function getImageScaleForNewDimensions( image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end

local barrel=love.graphics.newImage('img/barrel.png')
local scaleXB, scaleYB = getImageScaleForNewDimensions( barrel, 100, 100 )

function Barrel:init(world,x,y,w,h)
    Entity.init(self,world,x,y,w,h)
    self.speed=500
    self.color=Colors.white

    self.type=Types.barrel
    self.gameover=false
end

function Barrel:rightPosition()
    return self.x+self.w
end

function Barrel:offScreen()
    return self:rightPosition()<0
end

function Barrel:setSpeed(s)
    self.speed=s
end

function Barrel:update(dt)
    self.x,self.y,collisions=self.world:move(self,self.x-self.speed*dt,self.y)


    for i, c in pairs(collisions) do
        if c.other:getType() == Types.player then
          self.gameover = true
        end
    end
end

function Barrel:draw()
    
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill",self:getRect())
    love.graphics.draw(barrel, self.x-self.w/4, self.y ,r,.25,.25)
end

return Barrel