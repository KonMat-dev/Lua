local Types = require("entities.Types")

local Entities = {
  active = true,
  world  = nil,
  entityList = {}
}

function Entities:enter(world)
  self:clear()

  self.world = world
end

function Entities:add(entity)
  table.insert(self.entityList, entity)
  self.world:add(entity, entity:getRect())
end

function Entities:addMany(entities)
  for k,entity in pairs(entities) do
    self:add(entity)
  end
end

function Entities:getFirstBarrel()
  for i, e in ipairs(self.entityList) do
    if e:getType() == Types.barrel then
      return i, e
    end
  end
end

function Entities:getLeftMostBarrel()
  local lastEntity=self.entityList[#self.entityList]
  if lastEntity and lastEntity:getType() == Types.barrel then
    return lastEntity
  else
    return nil
  end
end 

function Entities:removeFirstBarrel()
  local i, e = self:getFirstBarrel()
  assert(e:getType() == Types.barrel)
  if e:offScreen() then
    table.remove(self.entityList, i)
    self.world:remove(e)
  end
end

function Entities:clear()
  self.world = nil
  self.entityList = {}
end

function Entities:draw()
  for i, e in ipairs(self.entityList) do
    e:draw(i)
  end
end

function Entities:update(dt)
  for i, e in ipairs(self.entityList) do
    e:update(dt, i)
  end
end

function Entities:gameover()
  for i, e in ipairs(self.entityList) do
    if e.gameover == true then return e.gameover end
  end
  return false
end

return Entities
