do return end --TODO aby8
local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

hooksecurefunc('WorldStateScoreFrame_Update', function()
    local inArena = IsActiveBattlefieldArena()
    local offset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)

    for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
        local index = offset + i
        local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index)
        -- faction: Battlegrounds: Horde = 0, Alliance = 1 / Arenas: Green Team = 0, Yellow Team = 1
        if name then
            local n, r = strsplit('-', name, 2)
            n = ycc.classColor[class] .. n .. '|r'

            if(name == ycc.myName) then
                n = '> ' .. n .. ' <'
            end

            if(r) then
                local color
                if inArena then
                    if faction == 1 then
                        color = '|cffffd100'
                    else
                        color = '|cff19ff19'
                    end
                else
                    if faction == 1 then
                        color = '|cff00adf0'
                    else
                        color = '|cffff1919'
                    end
                end
                r = color .. r .. '|r'
                n = n .. '|cffffffff - |r' .. r
            end

            local button = _G['WorldStateScoreButton' .. i]
            button.name.text:SetText(n)
--            local buttonNameText = getglobal('WorldStateScoreButton' .. i .. 'NameText')
--            buttonNameText:SetText(n)
        end
    end
end)

