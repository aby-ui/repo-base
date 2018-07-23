--[[------------------------------------------------------------
Broker_Mail
---------------------------------------------------------------]]

local AceEvent = LibStub'AceEvent-3.0'
local LDB = LibStub'LibDataBroker-1.1'

do
    local tooltip_title = ''
    local sender1
    local sender2
    local sender3

    local dataobj= LibStub("LibDataBroker-1.1"):NewDataObject("邮件提示", {
        type = "data source",
        text = "无邮件",
        icon = "interface\\minimap\\tracking\\mailbox",
        OnTooltipShow = function(tooltip)
            tooltip:AddLine(tooltip_title)
            if(sender1) then
                tooltip:AddLine(sender1)
                tooltip:AddLine(sender2)
                tooltip:AddLine(sender3)
            end
        end,
    })

    local function OnEvent()
        if(HasNewMail()) then
            tooltip_title = '|cff22ff22新邮件|r'
            sender1, sender2, sender3 = GetLatestThreeSenders()
            dataobj.text = tooltip_title
        else
            tooltip_title = '现在没有新邮件'
            sender1 = nil
            dataobj.text = "无邮件"
        end
    end
    AceEvent:RegisterEvent('UPDATE_PENDING_MAIL', OnEvent)
    AceEvent:RegisterEvent('MAIL_CLOSED', function()
        for i = 1, GetInboxNumItems() do
            if not select(9, GetInboxHeaderInfo(i)) then return end
        end
        tooltip_title = '现在没有新邮件'
        sender1 = nil
        dataobj.text = "无邮件"
    end)
    AceEvent:RegisterEvent('PLAYER_ENTERING_WORLD', OnEvent)
end


--[[------------------------------------------------------------
Broker_WorldPVP
---------------------------------------------------------------]]
do
    local format = string.format
    local floor = math.floor

    local HOUR = 60*60
    local MIN = 60

    local max_areas = GetNumWorldPVPAreas()
    local tb_index = 2
    local ICON_HORDE = [[Interface\PVPFrame\PVP-CURRENCY-HORDE]]
    local ICON_ALLIANCE = [[Interface\PVPFrame\PVP-CURRENCY-ALLIANCE]]
    local player_faction_icon = "Interface\\Icons\\achievement_zone_tolbarad" --UnitFactionGroup'player' == 'Alliance' and ICON_ALLIANCE or ICON_HORDE

    local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('世界战场时间', {
        type = 'data source',
        icon = player_faction_icon,
        text = '获取中',
    })

    local function formatTime(waitTime)
        if(type(waitTime) ~= 'number') or (waitTime<0) then return end

        local hour = floor(waitTime / HOUR)
        local minute = floor( (waitTime % HOUR) / MIN )
        local sec = floor( waitTime % MIN )

        if(hour > 0) then
            return ('%d:%02d:%02d'):format(hour, minute, sec)
        elseif(minute > 0) then
            return ('%d:%02d'):format(minute, sec)
        elseif(sec > 0) then
            return ('%ds'):format(sec)
        end
    end

    local function setPvpInfoSaved(index, timeOrSide, value)
        local realm = GetRealmName()
        U1DBG.WorldPVP = U1DBG.WorldPVP or {}
        U1DBG.WorldPVP[realm] = U1DBG.WorldPVP[realm] or {}
        U1DBG.WorldPVP[realm][index] = U1DBG.WorldPVP[realm][index] or {}
        U1DBG.WorldPVP[realm][index][timeOrSide] = value
    end

    local function getPvpInfoSaved(index, timeOrSide)
        local realm = GetRealmName()
        return U1DBG.WorldPVP and U1DBG.WorldPVP[realm] and U1DBG.WorldPVP[realm][index] and U1DBG.WorldPVP[realm][index][timeOrSide]
    end

    local function getPvpInfo(index)
        local pvpid, localizedName, isActive, canQueue, waitTime, canEnter = GetWorldPVPAreaInfo(index)
        if waitTime > 0 then
            setPvpInfoSaved(index, 1, time()+waitTime)
        else
            local saved = getPvpInfoSaved(index, 1)
            if saved then
                if time()<saved then
                    waitTime = saved-time()
                else
                    setPvpInfoSaved(index, 1, time()+9000)
                    setPvpInfoSaved(index, 2, nil)
                end
            end
        end
        return localizedName, formatTime(waitTime) or UNKNOWN
    end

    local tooltipTimer;
    local function updateTip(tip)
        tip:SetText("世界战场计时")
        for i = max_areas, 1, -1 do
            tip:AddDoubleLine(getPvpInfo(i))
        end
        tip:Show()
    end
    dataobj.OnTooltipShow = function(self)
        updateTip(self)
        if not tooltipTimer then
            tooltipTimer = CoreScheduleTimer(true, 1, updateTip, self)
        end
    end

    dataobj.OnLeave = function()
        if tooltipTimer then
            CoreCancelTimer(tooltipTimer)
            tooltipTimer = nil
        end
    end

    local short = {
        ["托尔巴拉德"] = "托巴",
    }

    CoreScheduleTimer(true, 1, function()
        local name, formattedTime = getPvpInfo(tb_index)
        name = short[name] or name
        if(formattedTime) then
            dataobj.text = ('%s-%s'):format(name, formattedTime)
        else
            dataobj.text = ('%s'):format(name)
        end
    end)

    local waiting_wm_close = false

    local texCoordHalf = {0, .5, 0, .5}
    local texCoordFull = {0, 1, 0, 1}
    local update_tb = function()
        local icon = getPvpInfoSaved(tb_index, 2)
        local last_updated = getPvpInfoSaved(tb_index, 1)
        if(icon and last_updated and (time() - last_updated < 0)) then
            dataobj.icon = icon
            return
        end
        -- if getPvpInfoSaved(tb_index, 2) then
        --     dataobj.icon = getPvpInfoSaved(tb_index, 2)
        --     return
        -- end

        if IsInInstance() then
            dataobj.icon = player_faction_icon
            return
        end

        local _, _, isActive, _, waitTime = GetWorldPVPAreaInfo(tb_index)
        if waitTime <= 0 then return end
        if isActive then
            dataobj.icon = "Interface\\WorldStateFrame\\CombatSwords"
            dataobj.iconCoords = texCoordHalf
            return
        end

        if(WorldMapFrame:IsShown()) then
            waiting_wm_close = true
            return
        end

        local cont = GetCurrentMapContinent()
        if(cont == 1 or cont == 2) then
            SetMapByID(708)
            local name, desc = GetMapLandmarkInfo(1)
            if(desc and desc:find(FACTION_HORDE)) then
                dataobj.icon = ICON_HORDE
                setPvpInfoSaved(tb_index, 2, dataobj.icon)
            elseif(desc and desc:find(FACTION_ALLIANCE)) then
                dataobj.icon = ICON_ALLIANCE
                setPvpInfoSaved(tb_index, 2, dataobj.icon)
            else
                dataobj.icon = player_faction_icon
                --清除数据
                setPvpInfoSaved(tb_index, 2, nil)
                setPvpInfoSaved(tb_index, 1, nil)
            end
        else
            dataobj.icon = player_faction_icon
        end
        dataobj.iconCoords = texCoordFull
    end

    local onEvent = function() return update_tb() end

    AceEvent:RegisterEvent("VARIABLES_LOADED", function()
        local WorldPVP = U1DBG.WorldPVP
        if WorldPVP then
            for realm, v in pairs(WorldPVP) do
                for index, tbl in pairs(v) do
                    if not tbl[1] or tbl[1] <= time() then
                        v[index] = nil
                    end
                end
                if not next(v) then
                    WorldPVP[realm] = nil
                end
            end
        end
    end)

    AceEvent:RegisterEvent('ZONE_CHANGED', onEvent)
    -- AceEvent:RegisterEvent('WORLD_MAP_UPDATE', onEvent)
    AceEvent:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", onEvent)
    AceEvent:RegisterEvent("PLAYER_ENTERING_WORLD", onEvent)

    dataobj.OnClick = function() return update_tb() end

    WorldMapFrame:HookScript('OnHide', function()
        if(waiting_wm_close) then
            waiting_wm_close = false
            return update_tb()
        end
    end)

end


--[[
--          Broker Clock
--]]

do
    -- `163_Clock` will be put on the right side automatically
    local dataobj = LDB:NewDataObject('163_Clock', {
        icon = 'Interface\\Icons\\Spell_Holy_BorrowedTime',
        type = 'data source',
        label = "时钟",
        text = '...',
    })

    local date = date
    CoreScheduleTimer(true, 1, function()
        dataobj.text = date'%H:%M:%S'
    end)
end


--[[
--          Broker Bags
--]]

do
    local dataobj= LDB:NewDataObject("背包", {
        type = 'data source',
        icon = [[Interface\Icons\inv_misc_bag_01]],
        text = '...',
        -- OnTooltipShow = function(tip)
        -- end,
    })

    local function update_slots()
        local maxslots, freeslots, freeSlots, bagFamily = 0, 0, 0, 0
        for i = 0, NUM_BAG_SLOTS do
			freeSlots, bagFamily = GetContainerNumFreeSlots(i)
			if ( bagFamily == 0 ) then
				freeslots = freeslots + freeSlots;
			end
            maxslots = maxslots + GetContainerNumSlots(i)
            --freeslots = freeslots + GetContainerNumFreeSlots(i)
        end

        dataobj.text = string.format('背包: %d/%d', freeslots, maxslots)
    end

    hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', update_slots)
    --AceEvent:RegisterEvent('BAG_UPDATE', update_slots)
    --update_slots()
end



--[[
--          Broker XXX
--]]

do
    
end



