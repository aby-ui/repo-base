local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

if WhoList_InitButton then --abyui10
    hooksecurefunc("WhoList_InitButton", function(button, elementData)
        local info = elementData.info;

        --名字也用职业颜色
        if info.filename then
            local classTextColor = RAID_CLASS_COLORS[info.filename];
            button.Name:SetText(classTextColor:WrapTextInColorCode(info.fullName));
        end

        --级别用难度颜色
        button.Level:SetText(ycc.diffColor[info.level] .. info.level .. '|r');

        --地区/工会和玩家一样显示为绿色
        local var_idx = UIDropDownMenu_GetSelectedID(WhoFrameDropDown)
        local variableColumnTable = { info.area, info.fullGuildName, info.raceStr };
        local variableText = variableColumnTable[var_idx];
        if var_idx == 1 and info.area == GetRealZoneText()
            or var_idx == 2 and info.fullGuildName == GetGuildInfo('player') then
            button.Variable:SetText('|cff00ff00' .. variableText .. '|r');
        end
    end)

else
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
            if(name and nameText) then
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
end

