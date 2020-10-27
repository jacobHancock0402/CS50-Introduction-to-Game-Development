--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'pots',
        frame = math.random(3),
        width = 16 ,
        height = 16,
        solid = true,
        defaultState = 'solid',
        states = {
            ['solid'] ={
                frame = math.random(3)
            },
            ['broken'] = {
                frame = math.random(6, 9)
            }

        }
    },
    -- maybe have states
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'entity',
        states = {
            ['entity'] = {
                frame = 5
            }
        }

    }
}