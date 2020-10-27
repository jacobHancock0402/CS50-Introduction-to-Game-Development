VictoryMenuState = Class{__includes = BaseState}

function VictoryMenuState:init(PlayerPokemon)
    self.playerPokemon = PlayerPokemon
    BH = self.playerPokemon.HP 
    BA = self.playerPokemon.attack 
    BD = self.playerPokemon.defense 
    BS = self.playerPokemon.speed 
    HP, attack, speed, defense = self.playerPokemon:levelUp()
    TH = HP + BH
    TA = attack + BA
    TS = speed + BS
    TD = defense + BD
        self.VictoryMenu = Menu {
            x = (VIRTUAL_WIDTH / 2) - 80,
            y = (VIRTUAL_HEIGHT / 2) - 80,

            width = 160,
            height = 160,
            -- to string maybe with dots on BH to convert to string
            items = {
                {
                    text =  ('Health: ' .. tostring(BH) .. '+' .. tostring(HP) .. '=' .. tostring(TH)),
                    onSelect = function()
                        gStateStack:pop()
                    end
                },
                {
                    text =  ('Attack: ' .. tostring(BA) .. '+' .. tostring(attack) .. '=' .. tostring(TA))
                },
                {
                    text = ('Speed: ' .. tostring(BS) .. '+' .. tostring(speed) .. '=' .. tostring(TS))
                },
                {
                    text = ('Defense: ' .. tostring(BD) .. '+' .. tostring(defense) .. '=' .. tostring(TD))
                }
                
            }

        }
        self.VictoryMenu.selection.cursor = false
                        
                        -- pop message and battle state and add a fade to blend in the field

                            -- resume field music
                            gSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            -- pop battle state

                            --gStateStack:push(FadeOutState({
                                --r = 255, g = 255, b = 255
                            --}, 1, function()
                                -- do nothing after fade out ends
                            --end))
end

function VictoryMenuState:update(dt)
    self.VictoryMenu:update(dt)
end

function VictoryMenuState:render()
    self.VictoryMenu:render()
end