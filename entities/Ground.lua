local Class=require("libs.hump.Class")
local Entity=require("entities.Entity")
local Types=require("entities.Types")
local Colors=require("util.Colors")

local Ground=Class{
  __includes=Entity
}


local ground=love.graphics.newImage('img/ground.png')

function Ground:init(world,x,y,w,h)
  Entity.init(self,world,x,y,w,h)
  self.color=Colors.rock
  self.type=Types.ground
end

function Ground:draw()
  love.graphics.setColor(unpack(self.color))
  love.graphics.rectangle("fill",self:getRect())
  love.graphics.draw(ground, self.x, self.y ,r)
  love.graphics.draw(ground, 250, self.y ,r)
  love.graphics.draw(ground, 500, self.y ,r)
  love.graphics.draw(ground, 750, self.y ,r)


end

return Ground