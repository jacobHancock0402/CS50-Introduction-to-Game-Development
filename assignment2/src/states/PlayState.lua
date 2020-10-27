--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}



--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
unlocked = false
last_score = 0

ball2 = Ball()
ball3 = Ball()
ball2.InPlay = false
ball3.InPlay = false
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
    -- prob have to include this in params
    self.powerup = params.powerup
    self.recoverPoints = 5000
    self.balls = {self.ball, ball2, ball3}
    self.last_score = params.last_score

    -- give ball random starting velocity
    for y,bal in pairs(self.balls) do
        bal.dx = math.random(-200, 200)
        bal.dy = math.random(-50, -60)
        bal.skin = self.ball.skin
    end
end

function PlayState:update(dt)

    -- Pause timer
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.powerup:update(dt)
    -- might be error and balls don't dissapear
    -- key powerup maybe shouldnt be included / have same rules
    -- prob not possible to exit some levels as cant get powerup
-- add a set of balls and loop through
    for e, ball in pairs(self.balls) do
        if ball.InPlay then
        ball:update(dt)
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end

        if self.powerup:collides(self.paddle) and self.powerup.InPlay then
            self.powerup:getSkin()
            self.powerup:hit()
            if KeyBrick then
                unlocked = true
            end
        end

        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do
            -- only check collision if we're in play
            if (brick.inPlay and ball:collides(brick) and brick.color < 6) or 
            (brick.inPlay and ball:collides(brick) and unlocked == true and brick.color == 6 and brick.tier == 3) then

                -- add to score

                self.score = self.score + (brick.tier * 200 + brick.color * 25)

                -- trigger the brick's hit function, which removes it from play
                brick:hit()

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end
                if self.score > 10 then
                    paddles = GenerateQuadsPaddles(gTextures['main'])
                    if self.paddle.size < 4 then
                        self.paddle.size = self.paddle.size + 1
                        love.audio.play(gSounds['upgrade'])
                    end
                end


                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball,
                        last_score = self.last_score,
                        recoverPoints = self.recoverPoints
                    })
                end
            end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
            if brick.inPlay and ball:collides(brick) then
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
        -- if ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
            self.health = self.health - 1
            gSounds['hurt']:play()
            if self.paddle.size > 1 then
                self.paddle.size = self.paddle.size - 1
            end
        self.balls[3].InPlay = false
        self.balls[2].InPlay = false
        if self.health == 0 then
            self.balls.InPlay[3] = false
            self.balls.InPlay[2] = false
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                last_score = self.last_score,
                recoverPoints = self.recoverPoints
            })
        end
    end
end 
end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end


    self.paddle:render()
    -- Make last score work.It reset once enter so only renders for 1 frame

    -- prob reset final_score when enters state.Set as param
    -- also stop particle with life and see what happens if get more balls
    self.powerup:renderParticles()
    if (self.score - self.last_score) > 5000 and self.powerup.InPlay then
        self.powerup:render()
        self.powerup.dy = math.random(50,60)
        con = 1
    elseif con == 1 then 
        con = 0
        self.last_score = self.score
    end

    if self.powerup:collides(self.paddle) and self.powerup.InPlay then
        self.powerup:renderParticles()
        self.powerup.InPlay = false
        self.balls[2].InPlay = true
        self.balls[3].InPlay = true
    end

    for t, ball in pairs(self.balls) do
        if ball.InPlay then
            ball:render()
        end
    end
    renderScore(self.score)
    renderHealth(self.health)


    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end