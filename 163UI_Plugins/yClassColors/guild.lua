
local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

local _VIEW

local function setview(view)
    _VIEW = view
end

local function update()
    _VIEW = _VIEW or GetCVar'guildRosterView'
    local playerArea = GetRealZoneText()
    local buttons = GuildRosterContainer.buttons

    for i, button in ipairs(buttons) do
        -- why the fuck no continue?
        if(button:IsShown() and button.online and button.guildIndex) then
            if(_VIEW == 'tradeskill') then
                local skillID, isCollapsed, iconTexture, headerName, numOnline, numVisible, numPlayers, playerName, playerNameWithRealm, class, online, zone, skill, classFileName, isMobile = GetGuildTradeSkillInfo(button.guildIndex)
                if((not headerName) and playerName) then
                    --button.string1:SetText(ycc.classColor[classFileName] .. playerName)
                    local c = ycc.classColorRaw[classFileName]
                    button.string1:SetTextColor(c.r, c.g, c.b)
                    if(zone == playerArea) then
                        button.string2:SetText('|cff00ff00' .. zone)
                    end
                end
            else
                local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPnts, achievementRank, isMobile = GetGuildRosterInfo(button.guildIndex)
                local displayedName = ycc.classColor[classFileName] .. name

                if(_VIEW == 'playerStatus') then
                    button.string1:SetText(ycc.diffColor[level] .. level)
                    button.string2:SetText(displayedName)
                    if(zone == playerArea) then
                        button.string3:SetText('|cff00ff00' .. zone)
                    end
                elseif(_VIEW == 'guildStatus') then
                    button.string1:SetText(displayedName)
                    if(rankIndex and rank) then
                        button.string2:SetText(ycc.guildRankColor[rankIndex] .. rank)
                    end
                elseif(_VIEW == 'achievement') then
                    button.string1:SetText(ycc.diffColor[level] .. level)
                    if(classFileName and name) then
                        button.string2:SetText(displayedName)
                    end
                elseif(_VIEW == 'weeklyxp' or _VIEW == 'totalxp') then
                    button.string1:SetText(ycc.diffColor[level] .. level)
                    button.string2:SetText(displayedName)
                end
            end
        end
    end
end

local loaded = false
hooksecurefunc('GuildFrame_LoadUI', function()
    if(loaded) then
        return
    else
        loaded = true
        hooksecurefunc('GuildRoster_SetView', setview)
        hooksecurefunc('GuildRoster_Update', update)
        hooksecurefunc(GuildRosterContainer, 'update', update)
    end
end)

