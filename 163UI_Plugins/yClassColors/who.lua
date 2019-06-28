local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

hooksecurefunc('WhoList_Update', function()
    local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

    local playerZone = GetRealZoneText()
    local playerGuild = GetGuildInfo'player'
    local playerRace = UnitRace'player'

    for i=1, WHOS_TO_DISPLAY, 1 do
        local index = whoOffset + i
        local nameText = getglobal('WhoFrameButton'..i..'Name')
        local levelText = getglobal('WhoFrameButton'..i..'Level')
        local classText = getglobal('WhoFrameButton'..i..'Class')
        local variableText = getglobal('WhoFrameButton'..i..'Variable')

        local info = C_FriendList.GetWhoInfo(index)
        if not info then return end
        local name, guild, level, race, class, zone, classFileName = info.fullName, info.fullGuildName, info.level, info.raceStr, info.classStr, info.area, info.filename
        if(name) then
            if zone == playerZone then
                zone = '|cff00ff00' .. zone
            end
            if guild == playerGuild then
                guild = '|cff00ff00' .. guild
            end
            if race == playerRace then
                race = '|cff00ff00' .. race
            end
            local columnTable = { zone, guild, race }

            local c = ycc.classColorRaw[classFileName]
            nameText:SetTextColor(c.r, c.g, c.b)
            levelText:SetText(ycc.diffColor[level] .. level)
            variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
        end
    end
end)

