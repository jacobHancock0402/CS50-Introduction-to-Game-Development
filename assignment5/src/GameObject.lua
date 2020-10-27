--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}
local counter = 0
function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states
    self.rende = true
    self.projectile = true

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.projectile = false

    -- default empty collision callback
    self.onCollide = function() end
end
-- should return pot object to room so it can render
-- still have to get check for it's collisions, and pick up
function GameObject:update(player, dt)
    if self.type == 'pot' and player.carrying then
        self.x = player.x + dt
        self.y = player.y - 12 + dt
        if love.keyboard.wasPressed('space') then 
            player.carrying = false
            self.projectile = true
        end
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end