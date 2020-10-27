Powerup = Class{}

paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99 / 255,
        ['g'] = 155 / 255,
        ['b'] = 255 / 255
    },
    -- green
    [2] = {
        ['r'] = 106 / 255,
        ['g'] = 190 / 255,
        ['b'] = 47 / 255
    },
    -- red
    [3] = {
        ['r'] = 217 / 255,
        ['g'] = 87 / 255,
        ['b'] = 99 / 255
    },
    -- purple
    [4] = {
        ['r'] = 215 / 255,
        ['g'] = 123 / 255,
        ['b'] = 186 / 255
    },
    -- gold
    [5] = {
        ['r'] = 251 / 255,
        ['g'] = 242 / 255,
        ['b'] = 54 / 255
    }
}

function Powerup:init()
    self.Width = 16
    self.Height = 16
    self.x = math.random(0, (VIRTUAL_WIDTH / 2) - self.Width)
    self.y = (VIRTUAL_HEIGHT / 2) - self.Height
    self.colour = 0
    self.skin = math.random(1, 9)
    self.dy = 0
    self.InPlay = true
    
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward 
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 10, 10)

end

function Powerup:getSkin()
    -- Maybe not right Quads call and index
    image = gFrames['powerups']
    if KeyBrick == true then
        index = 10
        self.colour = 0
    end
    index = math.random(1, 10)

    if index == 1 or index == 3 or index == 4 then
        self.colour = 3

    elseif index == 2 then 
        self.colour = 2

    elseif index >= 7 and index <= 9 then
        self.colour = 5
    
    else
        self.colour = 4

    end
    return image[index]
end

function Powerup:update(dt)
    if self.InPlay then
        self.y = self.y + self.dy * dt
    end
    self.psystem:update(dt)
end
function Powerup:collides(target)
        -- first, check to see if the left edge of either is farther to the right
        -- than the right edge of the other
    if self.InPlay then
        if self.x > target.x + target.width or target.x > self.x + self.Width then
            return false
        end
        
            -- then check to see if the bottom edge of either is higher than the top
            -- edge of the other
        if self.y > target.y + target.height or target.y > self.y + self.Height then
            return false
        end 
        
            -- if the above aren't true, they're overlapping
        
        return true
    end
    return false
end

function Powerup:CheckKey()
    if self.colour == 0 then
        return true
    end
    return false
end

function Powerup:hit()
        self.psystem:setColors(
            paletteColors[self.colour].r,
            paletteColors[self.colour].g,
            paletteColors[self.colour].b,
            55 * 4,
            paletteColors[self.colour].r,
            paletteColors[self.colour].g,
            paletteColors[self.colour].b,
            0
        )
        self.psystem:emit(64)
    
        gSounds['powerup']:play()

end 

function Powerup:render()
    -- gTexture is our global texture for all blocks
    -- Should prob add to gtext as prob wont find
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture

    if KeyBrick then
        love.graphics.draw(gTextures['powerup'], gFrames['powerups'][10],
        self.x, self.y)
    else
        love.graphics.draw(gTextures['powerup'], gFrames['powerups'][self.skin],
        self.x, self.y)
    end

end

function Powerup:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end