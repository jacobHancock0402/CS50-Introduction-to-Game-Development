--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(direction, object, initialX, initialY, entities, player)
self.direction = direction
self.player = player
self.object = object
self.initialX = object.x
self.initialY = object.y
self.entities = entities
end

function Projectile:update(dt)
    if self.object.projectile and self.object.state == 'solid' then
        if self.direction == 'right' then
            if (self.object.x - self.initialX) < 64 and self.object.x < VIRTUAL_WIDTH - 48 then
                self.object.x = self.object.x + 2 + dt
            elseif self.object.frame < 7 then
                self.object.state = 'broken'
            end
        elseif self.direction == 'left' then 
            if (self.initialX - self.object.x) < 64 and self.object.x > 32 then
                self.object.x = self.object.x - 2  + dt
            elseif self.object.frame < 7 then
                self.object.state = 'broken'
            end
        elseif self.direction == 'down' then 
            if (self.object.y - self.initialY) < 64 and self.object.y < VIRTUAL_HEIGHT - 48  then
                self.object.y = self.object.y + 2 + dt
            elseif self.object.frame < 7 then
                self.object.state = 'broken'
            end
        else 
            if (self.initialY - self.object.y) < 64 and self.object.y > 32 then
                self.object.y = self.object.y - 2  + dt
            elseif self.object.frame < 7 then
                self.object.state = 'broken'
            end
        end
        for k, entity in pairs(self.entities) do
            if not entity.dead and entity:collides(self.object) then
                self.object.state = 'broken'
                entity:damage(1)
                gSounds['hit-enemy']:play()
            end
        end
    end
end
-- maybe not these
function Projectile:render()
    --love.graphics.draw(gTextures[self.object.texture], gFrames[self.object.texture][self.object.states][self.object.state].frame or self.object.frame,
    --self.object.x + adjacentOffsetX, self.object.y + adjacentOffsetY)
end