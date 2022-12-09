--region Interface\Addon\!!!163UI!!!\PluginCore\BlizzBugsSuck.lua
-- Fix InterfaceOptionsFrame_OpenToCategory not actually opening the category (and not even scrolling to it)
-- Confirmed still broken in 7.0.3
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then
			local val = (Smax/(shownpanels-15))*(mypanel-2)
			InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
    CoreIOF_OTC = InterfaceOptionsFrame_OpenToCategory
end
--endregion

--region Interface\AddOn\!!!163UI!!!\Core\Core.lua
--用命令打开界面设置时，会强制到"控制页", 参见 InterfaceOptionsFrame_OnShow 及 InterfaceOptionsFrame_OpenToCategory
local InterfaceOptionsFrameTab2ClickMine = false
hooksecurefunc(InterfaceOptionsFrameTab2, "Click", function(self)
    if not InterfaceOptionsFrameTab2ClickMine then
        if not InterfaceOptionsFrame:IsShown() then InterfaceOptionsFrame_Show() end
        InterfaceOptionsFrameTab2ClickMine = true
        InterfaceOptionsFrameTab2:Click()
        InterfaceOptionsFrameTab2ClickMine = false
    end
end)

do
    --- 屏蔽鼠标提示不停刷新的点
    local function setUpdateTooltip(self)
        if(not self.UpdateTooltip) then
            self.UpdateTooltip = self:GetScript("OnUpdate");
            self:SetScript("OnUpdate", nil)
        end
    end
    local function changeTooltipUpdateHook(self)
        local owner = self:GetOwner()
        if owner then
            setUpdateTooltip(owner)
        end
    end
    hooksecurefunc("LootItem_OnEnter", setUpdateTooltip)
    hooksecurefunc("InboxFrameItem_OnEnter", setUpdateTooltip)
    --CoreDependCall("Blizzard_TradeSkillUI", function() hooksecurefunc("TradeSkillItem_OnEnter", setUpdateTooltip) end)
    CoreDependCall("Blizzard_InspectUI", function() hooksecurefunc("InspectPaperDollItemSlotButton_OnEnter", setUpdateTooltip) end)
    CoreDependCall("Blizzard_AuctionUI", function() hooksecurefunc("AuctionFrameItem_OnEnter", setUpdateTooltip) end)
    hooksecurefunc(GameTooltip, "SetLootRollItem", changeTooltipUpdateHook)
    --hooksecurefunc(GameTooltip, "SetMissingLootItem", changeTooltipUpdateHook)
    hooksecurefunc(GameTooltip, "SetTradeTargetItem", changeTooltipUpdateHook)
    hooksecurefunc(GameTooltip, "SetTradePlayerItem", changeTooltipUpdateHook)
    hooksecurefunc(GameTooltip, "SetSendMailItem", changeTooltipUpdateHook)
    --MiniMapBattlefieldFrame:HookScript("OnEnter", function(self) self:SetScript("OnUpdate", nil) self.UpdateTooltip = MiniMapBattlefieldFrame_OnUpdate end)
    CoreDependCall("Blizzard_TimeManager", function()
        TimeManagerClockButton:HookScript("OnEnter", TimeManagerClockButton_UpdateTooltip);
        TimeManagerClockButton.UpdateTooltip = TimeManagerClockButton_UpdateTooltip;
        TimeManagerClockButton_OnUpdateWithTooltip = TimeManagerClockButton_OnUpdate;
    end)
    hooksecurefunc("TempEnchantButton_OnEnter", function(self)
        self.UpdateTooltip = self.UpdateTooltip or TempEnchantButton_OnEnter
    end)
    TempEnchant1:SetScript("OnUpdate", nil)
    TempEnchant2:SetScript("OnUpdate", nil)
    TempEnchant3:SetScript("OnUpdate", nil)

    local function replaceUpdateTooltipWithWrapper(self, interval)
        if self.UpdateTooltip == self._abyNewUT then return end
        self._abyOldUT = self.UpdateTooltip
        self.UpdateTooltip = AbyUpdateTooltipWrapperFunc(self.UpdateTooltip, interval or 1, self)
        self._abyNewUT = self.UpdateTooltip
    end
    --hooksecurefunc("PaperDollItemSlotButton_OnEnter", function(self) replaceUpdateTooltipWithWrapper(self) end)
    CoreDependCall("Blizzard_EncounterJournal", function()
        hooksecurefunc("EncounterJournal_SetLootButton", function(self)
            self.UpdateTooltip = AbyUpdateTooltipWrapperFunc(self:GetScript("OnEnter"), 2)
        end)
    end)
    hooksecurefunc("EquipmentFlyout_Show", function()
        for _, v in pairs(EquipmentFlyoutFrame.buttons) do
            replaceUpdateTooltipWithWrapper(v, 0.25)
        end
    end)
    --已取消 bagnon and combuctor see components/item.lua
    --if AbyUpdateTooltipWrapperFunc then Item.UpdateTooltip = AbyUpdateTooltipWrapperFunc(Item.UpdateTooltip, .5) end
end

--endregion

--region !!!163UI!!!

-- Minimap.lua
function U1MMB_MinimapZoom_Toggle(enable)
    if enable then
        MinimapZoomIn:Hide();
        MinimapZoomOut:Hide();
        MinimapZoom:Show();
    else
        MinimapZoomIn:Show();
        MinimapZoomOut:Show();
        MinimapZoom:Hide();
    end
end

--Cfg!!!163UI!!!.lua
--[[ 
    {
        var = "zoom",
        default = 1,
        text = L["隐藏缩小放大按钮"],
        tip = L["说明`隐藏后用鼠标滚轮缩放小地图"],
        callback = function(cfg, v, loading) CoreCall("U1MMB_MinimapZoom_Toggle", v) end,
    },
--]]
--endregion

--region CanIMogIt/CfgCanIMogIt.lua
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
    if button == "RightButton" and IsControlKeyDown() and IsAltKeyDown() then
        local bag = self:GetParent():GetID()
        local slot = self:GetID()
        local link = GetContainerItemLink(bag, slot)
        if not link then return end
        local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(link)
        if (quality <= 3 and equipSlot) then
            if CanIMogIt and CanIMogIt:GetTooltipText(nil, bag, slot) == CanIMogIt.UNKNOWN then
                UseContainerItem(bag, slot)
                if (StaticPopup1:IsVisible() and StaticPopup1.which == "EQUIP_BIND") then
                    StaticPopup1Button1:Click()
                    U1Message("快捷解锁外观：" .. link)
                    ef.time = GetTime()
                    ef.bag, ef.slot = bag, slot
                    ef:RegisterEvent("BAG_UPDATE_DELAYED")
                end
            else
                U1Message(CanIMogIt and "此物品外观已解锁或不能被当前角色解锁" or "快捷解锁失败：未启用幻化提示(CanIMogIt)插件")
            end
        end
    end
end)
--endregion

--region Raid中屏蔽小队框架的事件
local unregisteredByUs
local function unregisterPartyMemberFrames()
    if not PartyMemberFrame1:IsEventRegistered("UNIT_AURA") then return end
    if GetNumSubgroupMembers()>0 and not PartyMemberFrame1:IsShown() then
        unregisteredByUs = true
        for i=1, MAX_PARTY_MEMBERS, 1 do
            local frame = _G["PartyMemberFrame"..i]
            frame:UnregisterAllEvents()
            frame:RegisterEvent("GROUP_ROSTER_UPDATE");
            frame:RegisterEvent("PLAYER_ENTERING_WORLD");
        end
    end
end

local function registerPartyMemberFrames()
    if not unregisteredByUs or PartyMemberFrame1:IsEventRegistered("UNIT_AURA") then return end
    unregisteredByUs = nil
    for i=1, MAX_PARTY_MEMBERS, 1 do
        local frame = _G["PartyMemberFrame"..i]
        frame:RegisterEvent("PLAYER_ENTERING_WORLD");
        frame:RegisterEvent("GROUP_ROSTER_UPDATE");
        frame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD");
        frame:RegisterEvent("PARTY_LEADER_CHANGED");
        frame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
        frame:RegisterEvent("MUTELIST_UPDATE");
        frame:RegisterEvent("IGNORELIST_UPDATE");
        frame:RegisterEvent("UNIT_FACTION");
        frame:RegisterEvent("VARIABLES_LOADED");
        frame:RegisterEvent("READY_CHECK");
        frame:RegisterEvent("READY_CHECK_CONFIRM");
        frame:RegisterEvent("READY_CHECK_FINISHED");
        frame:RegisterEvent("UNIT_ENTERED_VEHICLE");
        frame:RegisterEvent("UNIT_EXITED_VEHICLE");
        frame:RegisterEvent("UNIT_CONNECTION");
        frame:RegisterEvent("PARTY_MEMBER_ENABLE");
        frame:RegisterEvent("PARTY_MEMBER_DISABLE");
        frame:RegisterEvent("UNIT_PHASE");
        frame:RegisterEvent("UNIT_OTHER_PARTY_CHANGED");
    end
end

debugFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
debugFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
debugFrame:SetScript("OnEvent", function(self, event, ...)
    if event=="PLAYER_REGEN_ENABLED" then
        registerPartyMemberFrames()
    elseif event=="PLAYER_REGEN_DISABLED" then
        unregisterPartyMemberFrames()
    end
end)
--endregion

do
    --10.0似乎改成了QuestInfoFrame, 但好像已经不是渐显的了
    if QuestLogFrame then
        CoreHookScript(QuestLogFrame, "OnShow", function() QuestInfoDescriptionText:SetAlphaGradient(1024, QUEST_DESCRIPTION_GRADIENT_LENGTH); end, true)
    end
end

do
    local CTAF = {}
    ---用来返回CreateFrame, hooksecurefunc, getreplacehook, togglefunc的工厂方法
    ---@param replaces 是要替换的全局函数, 要保证执行本函数时尚未被替换，而执行getreplacehook()时已经被替换
    ---@param preCall 是togglefunc通用部分之前调用的, postCall则是之后调用的
    function CoreToggleAddonFactory(name, replaces, preCall, postCall)
        local _allframes, _allhooks, _CreateFrame, _hooksecurefunc, _getreplacehook, _togglefunc = {}, {}
        local store = { status = true, _allframes, _allhooks, replaces, }
        CTAF[name] = store

        _CreateFrame = function(...)
            local frame = CreateFrame(...)
            _allframes[frame] = true
            return frame
        end

        _hooksecurefunc = function(funcname, hookfunc, arg3)
            local obj = nil
            if arg3 then
                obj = funcname
                funcname = hookfunc
                hookfunc = arg3
            end
            tinsert(_allhooks, hookfunc)
            local id = #_allhooks
            local newhook = function(...) if store.status then _allhooks[id](...) end end
            if obj then
                hooksecurefunc(obj, funcname, newhook)
            else
                hooksecurefunc(funcname, newhook)
            end
        end

        for i=1, #replaces do
            replaces[replaces[i]] = _G[replaces[i]]
        end

        _getreplacehook = function()
            for i=1, #replaces do
                replaces["HOOK."..replaces[i]] = _G[replaces[i]]
            end
        end

        _togglefunc = function(force)
            if force~=nil and force==store.status then return end
            store.status = not store.status

            if preCall then preCall(store) end

            local _allframes, replaces = store[1], store[3]
            if store.status then
                for i=1, #replaces do
                    _G[replaces[i]] = replaces["HOOK."..replaces[i]]
                end
                for f, _ in pairs(_allframes) do
                    if f.___onevent then
                        f:SetScript("OnEvent", f.___onevent)
                        f.___onevent = nil
                    end
                    if f.___update then
                        f:SetScript("OnUpdate", f.___update)
                        f.___update = nil
                    end

                    if f.___shown then f:Show() end
                    f.___shown = nil
                end
            else
                for i=1, #replaces do
                    _G[replaces[i]] = replaces[replaces[i]]
                end
                for f, _ in pairs(_allframes) do
                    f.___onevent = f:GetScript("OnEvent")
                    f:SetScript("OnEvent", nil)
                    f.___update = f:GetScript("OnUpdate")
                    f:SetScript("OnUpdate", nil)

                    f.___shown = f:IsShown()
                    f:Hide()
                end
            end

            if postCall then postCall(store) end
        end

        return _CreateFrame, _hooksecurefunc, _getreplacehook, _togglefunc
    end
end

--region performance 性能优化
do
CoreDependCall("Blizzard_TimeManager", function()
    do return end--暂时屏蔽,这个会导致在 TimeManagerClockButton_OnUpdate 里之后调用 TimeManager_CheckAlarm 然后使 TimeManagerClockButton.currentMinuteCounter 被污染
    function TimeManagerClockButton_Update(self)
        local hour, minute = GetGameTime();
        local _lastTime = hour * 60 + minute
        if _lastTime ~=TimeManagerClockTicker._lastTime then
            TimeManagerClockTicker:SetText(GameTime_GetTime(false));
            TimeManagerClockTicker._lastTime = _lastTime
        end
    end
end)
--[==[-替换WorldFrame_OnUpdate，其中大量运算只是为了UIParent隐藏时, level>=60 是为了其中的Tutorial
CoreOnEvent("PLAYER_LOGIN", function()
    if UnitLevel("player")>=60 then
        local timeLeft = 0
        local function onupdate(self, elapsed)
            timeLeft = timeLeft - elapsed
            if ( timeLeft <= 0 ) then
                timeLeft = 0.5;
                if ( FramerateText:IsShown() ) then
                    local framerate = GetFramerate();
                    if framerate >= 100 then
                        framerate = n2s(floor(framerate+0.5))
                    else
                        framerate = f2s(framerate, 1)
                    end
                    FramerateText:SetText(framerate);
                    MapFramerateText:SetText(framerate);
                end
            end
        end
        --hooksecurefunc(UIParent, "Show", function() WorldFrame:SetScript("OnUpdate", onupdate) end)
        --hooksecurefunc(UIParent, "Hide", function() WorldFrame:SetScript("OnUpdate", WorldFrame_OnUpdate) end) --TODO: 可能会导致各种污染
        WorldFrame:SetScript("OnUpdate", onupdate)
    end
end)
--]==]

    --[=[-ChatFrame_OnUpdate只是为了显示滚动到最下面的那个按钮闪烁
    do
        local function onupdate(self, elapsed)
            self._flashTimer163 = self._flashTimer163 + elapsed
            if self._flashTimer163 >= 0.5 then
                self._flashTimer163 = 0
                local flash = self._flash163
                if ( self:AtBottom() ) then
                    flash:Hide();
                else
                    if ( flash:IsShown() ) then
                        flash:Hide();
                    else
                        flash:Show();
                    end
                end
            end
        end
        function ChatFrame_OnUpdate(self)
            self._flash163 = _G[self:GetName().."ButtonFrameBottomButtonFlash"];
            self._flashTimer163 = 0
            self:SetScript("OnUpdate", self._flash163 and onupdate or nil)
        end
    end
    --]=]

    --[[
    do
        local militaryTime = GetCVarBool("timeMgrUseMilitaryTime")
        CoreDependCall("Blizzard_TimeManager", function()
            hooksecurefunc("TimeManager_ToggleTimeFormat", function()
                militaryTime = GetCVarBool("timeMgrUseMilitaryTime")
            end)
        end)
        function GameTime_GetFormattedTime(hour, minute, wantAMPM)
            if ( militaryTime ) then
                return n2s(hour, 2)..":"..n2s(minute, 2); --TIMEMANAGER_TICKER_24HOUR
            else
                if ( wantAMPM ) then
                    local suffix = " AM";
                    if ( hour == 0 ) then
                        hour = 12;
                    elseif ( hour == 12 ) then
                        suffix = " PM";
                    elseif ( hour > 12 ) then
                        suffix = " PM";
                        hour = hour - 12;
                    end
                    return n2s(hour)..":"..n2s(minute,2)..suffix; --TIME_TWELVEHOURAM
                else
                    if ( hour == 0 ) then
                        hour = 12;
                    elseif ( hour > 12 ) then
                        hour = hour - 12;
                    end
                    return n2s(hour)..":"..n2s(minute, 2); --TIMEMANAGER_TICKER_12HOUR
                end
            end
        end
    end
--]]
end
--endregion

--[[------------------------------------------------------------
9.1 统御碎片相关
---------------------------------------------------------------]]
do
    local DominationShards = {
        { 187079, 187292, 187301, 187310, 187320, }, --邪恶泽德碎片
        { 187076, 187291, 187300, 187309, 187319, }, --邪恶欧兹碎片
        { 187073, 187290, 187299, 187308, 187318, }, --邪恶迪兹碎片
        { 187071, 187289, 187298, 187307, 187317, }, --冰霜泰尔碎片
        { 187065, 187288, 187297, 187306, 187316, }, --冰霜基尔碎片
        { 187063, 187287, 187296, 187305, 187315, }, --冰霜克尔碎片
        { 187061, 187286, 187295, 187304, 187314, }, --鲜血雷弗碎片
        { 187059, 187285, 187294, 187303, 187313, }, --鲜血亚斯碎片
        { 187057, 187284, 187293, 187302, 187312, }, --鲜血贝克碎片
    }

    local DomiSetColor = { "a335ee", "0070ff", "ff0000" } --紫蓝红
    local DomiSetNameLong = { "森罗万象(头)", "寒冬之风(肩)", "鲜血连接(胸)" }
    local DomiSetNameShort = { "森罗", "寒冬", "鲜血" }
    local DomiShardName = { "邪恶", "冰霜", "鲜血" }

    local ShardIdToSetName = {}
    local ShardIdToName = {}
    local ShardIdToLevel = {}
    local ShardIdToIndex = {}

    for i, ids in ipairs(DominationShards) do
        for level, id in ipairs(ids) do
            local setIdx = math.floor((i+2)/3)
            ShardIdToSetName[id] = DomiSetNameLong[setIdx]
            ShardIdToName[id] = DomiShardName[setIdx]
            ShardIdToLevel[id] = level
            ShardIdToIndex[id] = i
        end
    end

    function U1GetDominationShardsData()
        return DominationShards, ShardIdToSetName, ShardIdToName, ShardIdToLevel, ShardIdToIndex
    end
    function U1GetDominationSetData()
        return DomiSetColor, DomiSetNameLong, DomiSetNameShort, DomiShardName
    end

    local DSSLOTS = { [1]="Head", [3]="Shoulder", [5]="Chest", [6]="Waist", [8]="Feet", [9]="Wrist", [10]="Hands" }

    local shardLevels, setSlot = { {}, {}, {} }, {} -- reuse table
    function U1GetUnitDominationInfo(unit)
        table.wipe(setSlot)
        for i = 1, #shardLevels do
            table.wipe(shardLevels[i])
        end
        for id, slot in next, DSSLOTS do
            local link = GetInventoryItemLink(unit, id)
            if link then
                local _, _, gemID = link:find("item:[0-9]+:[0-9]*:([0-9]+):") --TODO: 如果普通宝石和统御碎片一起
                if gemID then
                    gemID = tonumber(gemID)
                    local idx = ShardIdToIndex[gemID]
                    if idx then
                        local setIdx = math.floor((idx+2)/3)
                        local level = ShardIdToLevel[gemID]
                        table.insert(shardLevels[setIdx], level)
                        -- 如果对应部位没插碎片则结果会错误, 太特殊不予处理
                        if slot == "Head" then
                            setSlot[1] = true
                        elseif slot == "Shoulder" then
                            setSlot[2] = true
                        elseif slot == "Chest" then
                            setSlot[3] = true
                        end
                    end
                end
            end
        end
        local set_index, set_level, details
        for i = 1, 3 do
            local levels = shardLevels[i]
            if setSlot[i] and #levels == 3 then
                local min = 9 for _, lvl in ipairs(levels) do if lvl < min then min = lvl end end
                set_index, set_level = i, min
            end
            if #levels > 0 then
                local str = "|cff" .. DomiSetColor[i] .. table.concat(levels) .. "|r"
                if #levels == 3 then
                    details = str .. (details or "")
                else
                    details = (details or "") .. str
                end
            end
        end
        return set_index, set_level, details -- details is like "33321"
    end
end