PlayerIdleCarryState = Class{__includes = EntityIdleState}

function PlayerIdleCarryState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.carrying = true
    
end

function PlayerIdleCarryState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleCarryState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    -- trigger throw
end