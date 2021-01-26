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

function Entities:getFirstObstacle()
  for i, e in ipairs(self.entityList) do
    if e:getType() == Types.obstacle then
      return i, e
    end
  end
end

function Entities:getLeftMostObstacle()
  local lastEntity=self.entityList[#self.entityList]
  if lastEntity and lastEntity:getType() == Types.obstacle then
    return lastEntity
  else
    return nil
  end
end 

--usuwamy z lewej, za graczem
function Entities:removeFirstObstacle()
  local i, e = self:getFirstObstacle()
  assert(e:getType() == Types.obstacle)
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
