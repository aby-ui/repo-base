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

    --UpdateTooltip本来就有0.2秒的间隔, 需要新的机制，就是延迟出提示
    local lastModifierTime = 0
    CoreOnEvent("MODIFIER_STATE_CHANGED", function() lastModifierTime = GetTime() end)
    function AbyUpdateTooltipWrapperFunc(func, interval, caller)
        return function(self, ...)
            if self == nil then self = caller end
            if self == nil then return end
            local t = self._abyUTT or 0
            local now = GetTime()
            if now - t < interval and t > lastModifierTime then return end
            self._abyUTT = now
            return func(self, ...)
        end
    end
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
-- RunSecond.lua
--被世界任务完成框遮挡
CastingBarFrame:SetFrameStrata("DIALOG")

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