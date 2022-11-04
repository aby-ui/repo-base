EnableAddOn("!!!Libs") LoadAddOn("!!!Libs") --不能在CoreLibs之前，不能在163UIUI之后。之后根据有没有软件用库来决定是否加载

--TODO aby8
GuildControlUIRankSettingsFrameRosterLabel = GuildControlUIRankSettingsFrameRosterLabel or CreateFrame("Frame")

--WIP: SavedInstance ToyPlus
--[[
hooksecurefunc(GameTooltip, "Show", function()
    local qtip = LibStub("LibQTip-1.0", true)
    if qtip then
        for _, v in pairs(qtip.activeTooltips) do
            qtip:Release(v)
        end
    end
end)
]]

function U1RemovedAddOn(...)
    local removed = {}
    for i=1, select('#', ...) do
        local addon = select(i, ...)
        local reason = select(5, GetAddOnInfo(addon))
        if reason ~= "MISSING" then
            local vendor = GetAddOnMetadata(addon, "X-Vendor")
            if vendor and vendor:upper() == "ABYUI" then
                DisableAddOn(addon)
                table.insert(removed, addon)
            end
        end
    end
    if #removed > 0 then
        U1Message("插件"..table.concat(removed, ",").."已废弃，请使用客户端更新或手工删除")
    end
end
U1RemovedAddOn("_NPCScan", "EquippedItemLevelTooltip", "ItemLevelDisplay")

---LibSharedMedia Options, { type = "drop", options = CtlSharedMediaOptions("statusbar"), }
local optionsFuncs, optionsLists;
function CtlSharedMediaOptions(type)
    optionsFuncs = optionsFuncs or {};
    optionsLists = optionsLists or {};
    local func = optionsFuncs[type]
    if not func then
        func = function()
            local LSM = LibStub and LibStub('LibSharedMedia-3.0', true);
            local list = optionsLists[type];
            if not list then list = {} optionsLists[type] = list; end
            table.wipe(list);
            if LSM then
                for _, v in ipairs(LSM:List(type)) do
                    table.insert(list, v)
                    table.insert(list, LSM:Fetch(type, v))
                end
            end
            return list;
        end
        optionsFuncs[type] = func;
    end
    return func;
end

for i=1, GetNumClasses() do
    local loc, eng, id = GetClassInfo(i)
    _G['U1'..eng] = _G['U1'..eng] or loc
end

if QueueStatusMinimapButton then
    QueueStatusMinimapButton:SetFrameStrata("HIGH")  --TODO:abyui10
end

--按ESC时, AceConfigDialog先关闭, 并阻止界面窗口和爱不易关闭
hooksecurefunc("StaticPopup_EscapePressed", function()
    if LibStub("AceConfigDialog-3.0"):CloseAll() then
        GameMenuFrame:Show()
    end
end)

--6.0 GarrisonUI下单界面是MEDIUM的
CoreDependCall("Blizzard_GarrisonUI", function()
    if GarrisonCapacitiveDisplayFrame then
        GarrisonCapacitiveDisplayFrame:SetFrameStrata("DIALOG");
    end
end)

--- 给任务追踪里的任务物品和技能增加一个安全按钮,包括普通任务,世界任务,以及场景战役的法术
CoreDependCall("Blizzard_ObjectiveTracker", function()
    local hook_Scenario_AddSpells = function(self, objectiveBlock, spellInfo)
        objectiveBlock = objectiveBlock or ScenarioObjectiveBlock
        if not IsAddOnLoaded("!KalielsTracker") or not objectiveBlock.spells then return end
        --print("hooking", self, objectiveBlock, spellInfo)
        for spellIndex = 1, 100 do
            local spellFrame = objectiveBlock.spells[spellIndex];
            if (not spellFrame or not spellFrame:IsShown()) then
                break
            end
            local blizBtn = spellFrame.SpellButton
            if not blizBtn._163warning then
                blizBtn._163warning = true
                blizBtn:HookScript("OnClick", function(self)
                    if not issecurevariable(self, "spellID") then
                        U1Message("任务追踪增强目前不支持在战斗中点击任务法术，请脱战后点击或者关闭插件继续任务，不便之处请多包涵")
                    end
                end)
            end
            if not InCombatLockdown() then
                if not blizBtn._163btn then
                    WW:Button(nil, blizBtn, "SecureActionButtonTemplate"):Key("_163btn")
                    :RegisterForClicks("AnyUp", "AnyDown"):SetAllPoints()
                    :CreateTexture():SetAllPoints():SetColorTexture(0, 1, 0, 0.3):up()
                    :SetScript("OnEnter", function(self) self:GetParent():GetScript("OnEnter")(self:GetParent()) end)
                    :SetScript("OnLeave", function(self) self:GetParent():GetScript("OnLeave")(self:GetParent()) end)
                    :un()
                end
                blizBtn._163btn:SetAttribute("type", "spell")
                blizBtn._163btn:SetAttribute("spell", blizBtn.spellID)
                if self == "PLAYER_REGEN_ENABLED" then
                    blizBtn._163btn:Show()
                elseif self == "PLAYER_REGEN_DISABLED" then
                    blizBtn._163btn:Hide()
                end
            end
        end
    end
    hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "AddSpells", hook_Scenario_AddSpells)
    CoreOnEvent("PLAYER_REGEN_ENABLED", hook_Scenario_AddSpells)
    CoreOnEvent("PLAYER_REGEN_DISABLED", hook_Scenario_AddSpells)

    local wqItems163 = {} --物品按钮定时刷新隐藏, 不能setparent，也不能SetAllPoints()
    local function update_QuestItemButtons()
        if InCombatLockdown() then return end
        for bliz, btn163 in pairs(wqItems163) do
            if type(btn163) == "string" then
                local link = btn163
                btn163 = WW:Button(nil, UIParent, "SecureActionButtonTemplate"):RegisterForClicks("AnyUp", "AnyDown"):SetFrameStrata("HIGH")
                :CreateTexture():SetAllPoints():SetColorTexture(0, 1, 0, 0.1):up()
                :SetScript("OnEnter", function(self) self.bliz:GetScript("OnEnter")(self.bliz) end)
                :SetScript("OnLeave", function(self) self.bliz:GetScript("OnLeave")(self.bliz) end)
                :un()
                btn163:SetSize(bliz:GetSize())
                btn163:SetAttribute("type", "item")
                btn163.bliz = bliz
                btn163.link = link
                wqItems163[bliz] = btn163
            end
            if bliz:IsVisible() then
                btn163:Show()
                local scale = bliz:GetEffectiveScale() / btn163:GetEffectiveScale()
                btn163:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", bliz:GetLeft()*scale, bliz:GetBottom()*scale)
                btn163:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", bliz:GetRight()*scale, bliz:GetTop()*scale)
                btn163:SetAttribute("item", btn163.link)
            else
                btn163:Hide()
            end
        end
    end
    local hook_Quest_Update = function(module, isWorldQuests)
        return function(self)
            --if not IsAddOnLoaded("!KalielsTracker") then return end
            self = self or module
            if isWorldQuests and not self.ShowWorldQuests then return end
            if _G.AbyQuestWatchSortUpdate then return end

            -- 除了watches之外，还有一个当前区域的世界任务，所以不循环GetNumWorldQuestWatches直接循环usedBlocks
            --- @see Blizzard_ObjectiveTracker\Blizzard_BonusObjectiveTracker.lua   UpdateTrackedWorldQuests(module)
            --- @see Blizzard_ObjectiveTracker\Blizzard_BonusObjectiveTracker.lua   AddBonusObjectiveQuest
            --- @see Blizzard_ObjectiveTracker\Blizzard_ObjectiveTracker.lua        DEFAULT_OBJECTIVE_TRACKER_MODULE:GetBlock(id)
            for template, ub in pairs(module.usedBlocks) do
                for questID, block in pairs(ub) do
                    if block and block.itemButton and block.itemButton:IsShown() then
                        local questLogIndex = C_QuestLog.GetLogIndexForQuestID(questID);
                        local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex);
                        if link then
                            local blizBtn = block.itemButton
                            if wqItems163[blizBtn] and type(wqItems163[blizBtn])=="table" then wqItems163[blizBtn].link = link else wqItems163[blizBtn] = link end
                        end
                    end
                end
            end
            update_QuestItemButtons()
        end
    end
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "Update", hook_Quest_Update(WORLD_QUEST_TRACKER_MODULE, true))
    hooksecurefunc(QUEST_TRACKER_MODULE, "Update", hook_Quest_Update(QUEST_TRACKER_MODULE, false))
    CoreOnEvent("PLAYER_REGEN_ENABLED", update_QuestItemButtons)
    CoreOnEvent("PLAYER_REGEN_DISABLED", update_QuestItemButtons)
    CoreScheduleTimer(true, 0.5, update_QuestItemButtons)
end)

CoreDependCall("Blizzard_InspectUI", function()
    WW(InspectPaperDollFrame.ViewButton)
    :ClearAllPoints():TL(InspectModelFrame,0,0)
    :AddFrameLevel(1, InspectModelFrame)
    :SetText("试穿"):SetWidth(50):un()
end)

--[[ 尝试解决污染问题但没用
hooksecurefunc("WorldMap_ClearTextures", function()
    if not issecurevariable(WorldMapFrame.UIElementsFrame.ActionButton, "hasWorldQuests") then
        WorldMapFrame.UIElementsFrame.ActionButton.hasWorldQuests = nil
    end
end)--]]

--[[------------------------------------------------------------
prevent blocking message, /dump WorldMapFrame:IsProtected()
no use after 8.0
---------------------------------------------------------------]]
if WorldMapFrame.UIElementsFrame and WorldMapFrame.UIElementsFrame.ActionButton then
    local offscreenFrame = CreateFrame("Frame", UIParent)
    offscreenFrame:SetPoint("BOTTOMLEFT", -500, -500)
    offscreenFrame:Hide()
    local actionButton = WorldMapFrame.UIElementsFrame.ActionButton
    local spellButton = actionButton and actionButton.SpellButton
    local p1, rel, p2, left, top = spellButton:GetPoint()
    local function hideSpellButton()
        --if WorldMapFrame:IsShown() then return end
        actionButton:SetAlpha(0)
        spellButton:SetParent(offscreenFrame)
        spellButton:SetPoint(p1, offscreenFrame, p1, left, top)
    end

    local function showSpellButton()
        if InCombatLockdown() then return end
        actionButton.hasWorldQuests = nil --force refresh, otherwise will report no spellID
        if actionButton.spellID then actionButton:RegisterEvent("SPELL_UPDATE_COOLDOWN") end
        actionButton:SetAlpha(1)
        spellButton:SetParent(rel)
        spellButton:SetPoint(p1, rel, p2, left, top)
    end

    CoreOnEvent("PLAYER_REGEN_DISABLED", function()
        actionButton:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
        hideSpellButton()
    end)
    --CoreOnEvent("PLAYER_REGEN_ENABLED", function() actionButton:RegisterEvent("SPELL_UPDATE_COOLDOWN") end)
    hooksecurefunc(actionButton, "Refresh", function()
        if actionButton.spellID and not InCombatLockdown() then
            actionButton:RegisterEvent("SPELL_UPDATE_COOLDOWN")
        end
    end)
    CoreLeaveCombatCall("U1WorldMapFrameSpellButton", nil, function()
        if WorldMapFrame:IsShown() then showSpellButton() else hideSpellButton() end
    end)
    CoreHookScript(WorldMapFrame, "OnShow", function()
        CoreLeaveCombatCall("U1WorldMapFrameSpellButton", nil, showSpellButton)
    end, true)
    CoreHookScript(WorldMapFrame, "OnHide", function()
        CoreLeaveCombatCall("U1WorldMapFrameSpellButton", nil, hideSpellButton)
    end, true)

    -- prevent WorldMap_UpdateQuestBonusObjectives -> Refresh
    if WorldMap_TryCreatingWorldQuestPOI then
        hooksecurefunc("WorldMap_TryCreatingWorldQuestPOI", function()
            if InCombatLockdown() then actionButton.mapAreaID = nil end
        end)
    end

    if WorldMapFrame.UIElementsFrame and WorldMapFrame.UIElementsFrame.BountyBoard then
        hooksecurefunc(WorldMapFrame.UIElementsFrame.BountyBoard, "SetMapAreaID", function()
            if InCombatLockdown() then actionButton.hasWorldQuests = nil end
        end)
    end
end

--[[ --- 点击已经跟踪的世界任务，会取消跟踪，没用，注释了
hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "GetBlock", function(self)
    for k, v in pairs(self.usedBlocks) do
        if not v._163hooked then
            v._163hooked = true
            v.TrackedQuest:SetScript("PreClick", function(self) self.alreadyTracked = GetSuperTrackedQuestID() == self.questID end)
            v.TrackedQuest:HookScript("OnClick", function(self) if self.alreadyTracked then SetSuperTrackedQuestID(0) end end)
        end
    end
end)--]]

local pattern = "^" .. string.format(LOOT_ITEM, "(.+)", "(.+)") .. "$" --"%s获得了物品：%s。"
local slot_name = {
    INVTYPE_TRINKET = "饰品",
    INVTYPE_FINGER = "戒指",
    INVTYPE_CLOAK = "披风",
}
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", function(self, event, msg, ...)
    local _, _, player, item = msg:find(pattern)
    if player and player ~= YOU then
        local _, _, quality, _, _, _, armor_type, _, slot = GetItemInfo(item)
        if quality >= 3 and (armor_type == "神器圣物" or (slot and slot ~= "")) then
            local _, class = UnitClass(player)
            local color = class and RAID_CLASS_COLORS[class].colorStr
            local fullname = player:find("-") and player or player .. "-" .. GetRealmName()
            local playerText = player
            if TeamStats and TeamStats.db then
                local data = TeamStats.db.players[fullname]
                if data.gsGot and data.gs then
                    playerText = playerText .. "(" .. data.gs .. ")"
                end
            end
            player = format("|Hplayer:%s|h%s[%s]%s|h", player, color and "|c" .. color or "", playerText, color and "|r" or "")
            --item = "|cffbbbbbb" .. (slot and slot_name[slot] or armor_type).."|r" .. item
            local msg2 = string.format(LOOT_ITEM, player, item);
            return false, msg2, ...
        end
    end
end)

function U1FakeAchi(id,d,m,y)
    if not d then d,m,y = 4,1,17 end
	local link = format("\124cffffff00\124Hachievement:%d:%s:1:%d:%d:%d:4294967295:4294967295:4294967295:4294967295\124h[%s]\124h\124r", id, UnitGUID("player"), d, m, y, select(2, GetAchievementInfo(id)))
	print((link))
    return link
end

--[[7.2 ChallengesUI
CoreDependCall("Blizzard_ChallengesUI", function()
    hooksecurefunc("ChallengesFrame_Update", function(self)
        for _,v in ipairs(self.DungeonIcons) do v:SetScale(0.8) end
        self.DungeonIcons[1]:SetPoint("BOTTOMLEFT", 30, 20)
        self.DungeonIcons[10]:ClearAllPoints()
        self.DungeonIcons[10]:SetPoint("TOPLEFT", self.DungeonIcons[9], "TOPRIGHT")
    end)
end)--]]

--[[
CoreDependCall("Blizzard_DebugTools", function()
    EventTraceFrame:HookScript("OnShow", function()
        EventTraceFrame.ignoredEvents = { ACTIONBAR_UPDATE_COOLDOWN = 1, BAG_UPDATE_COOLDOWN = 1, COMBAT_LOG_EVENT_UNFILTERED = 1, COMPANION_UPDATE = 1, CURSOR_UPDATE = 1, FRIENDLIST_UPDATE = 1, GARRISON_LANDINGPAGE_SHIPMENTS = 1, GARRISON_MISSION_LIST_UPDATE = 1, GUILD_NEWS_UPDATE = 1, MODIFIER_STATE_CHANGED = 1, PLAYER_STARTED_MOVING = 1, PLAYER_STOPPED_MOVING = 1, QUEST_LOG_UPDATE = 1, SPELL_UPDATE_COOLDOWN = 1, UNIT_ABSORB_AMOUNT_CHANGED = 1, UNIT_AURA = 1, UPDATE_MOUSEOVER_UNIT = 1, UPDATE_WORLD_STATES = 1, WORLD_MAP_UPDATE = 1, }
    end)
end)
LoadAddOn("Blizzard_DebugTools")
EventTraceFrame_HandleSlashCmd("")
--]]

--[[
CoreDependCall("Blizzard_OrderHallUI", function()
    oisv(OrderHallMissionFrameMissionsListScrollFrameButton1)
    --getmetatable(OrderHallMissionFrameMissionsListScrollFrameButton1).__newindex = function(t, k, v) rawset(t, k, v) if k=="info" then pdebug() end end
    hooksecurefunc(GarrisonMission, "ShowMission", function()
        pdebug()
        oisv(OrderHallMissionFrame)
    end)
    --GarrisonMissionButton_OnEnter
    OrderHallMissionFrameMissionsListScrollFrameButton1:HookScript("OnEnter", function()
        oisv(OrderHallMissionFrameMissionsListScrollFrameButton1)
    end)
end)
--]]

--被世界任务完成框遮挡
PlayerCastingBarFrame:SetFrameStrata("DIALOG")

do
    -- 初次拾取钥石的信息
    -- 7.0 "\124cffa335ee\124Hitem:158923::::::::120:65:4063232:::248:9:9:11:2:::\124h[史诗钥石]\124h\124r",
    -- 9.1 "\124cffa335ee\124Hitem:180653::::::::60:70::::6:17:380:18:18:19:10:20:8:21:4:22:128:::::\124h[史诗钥石]\124h\124r"
    local function KeystoneLevel(Hyperlink)
        local itemId, map, level = string.match(Hyperlink, "|Hitem:(%d+)::::::::%d*:%d*:%d*:%d*:%d*:%d*:%d*:(%d+):%d*:(%d+):%d*:(%d*):%d*:(%d*):%d*:(%d*):.-|h(.-)|h")
        if itemId == "180653" then
            local name = C_ChallengeMode.GetMapUIInfo(map)
            if name then Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..format(CHALLENGE_MODE_KEYSTONE_HYPERLINK, name, level).."]|h") end
        end
        return Hyperlink
    end

    local filterLootKeyStone = function(self, event, msg, ...)
        msg = msg:gsub("(\124Hitem:(%d+)::::::::%d*:%d*:%d*:%d*:%d*:%d+:%d+:.-|h.-|h)", KeystoneLevel)
        return false, msg, ...
    end
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filterLootKeyStone)

    local function GetInventoryKeystone()
        for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            local slots = GetContainerNumSlots(container)
            for slot=1, slots do
                local _, _, _, _, _, _, slotLink = GetContainerItemInfo(container, slot)
                local itemString = slotLink and slotLink:match("|Hkeystone:([0-9:]+)|h(%b[])|h")
                if itemString then
                    return slotLink, itemString
                end
            end
        end
    end

    CoreOnEvent("ITEM_CHANGED", function(event, old, new)
        local id = new and GetItemInfoInstant(new)
        if id == 180653 then
            CoreScheduleBucket("AbyUIShowKeyStone", 0.5, function()
                local link = GetInventoryKeystone()
                if link then
                    local msg = "得到新钥石：" .. link
                    --"\124cffa335ee\124Hkeystone:180653:380:18:10:8:4:128\124h[钥石：赤红深渊 (18)]\124h\124r"
                    local affixes = {}
                    affixes[1],affixes[2],affixes[3],affixes[4] = link:match("|Hkeystone:%d+:%d+:%d+:(%d*):(%d*):(%d*):(%d*)[0-9:]-|h(%b[])|h")
                    for _, affix in pairs(affixes) do
                        if affix and affix ~= "" then
                            msg = msg .. " " .. C_ChallengeMode.GetAffixInfo(affix)
                        end
                    end
                    U1Message(msg)
                end
            end)
        end
    end)
end

local UpdateAddOnMemoryUsageOrigin = UpdateAddOnMemoryUsage
function UpdateAddOnMemoryUsage()
    if not InCombatLockdown() then
        UpdateAddOnMemoryUsageOrigin()
    end
end

SetCVar("nameplateShowDebuffsOnFriendly", "0")

AbbreviateNumbers163 = AbbreviateLargeNumbers
if _G.AbbreviateLargeNumbers and GetLocale():sub(1,2) == "zh" then
    function AbbreviateLargeNumbers163(value)
        local strLen = strlen(value);
        if ( strLen >= 11 ) then
            return string.sub(value, 1, -9)..SECOND_NUMBER_CAP;
        else
            return _G.AbbreviateLargeNumbers(value)
        end
    end
end

AbbreviateNumbers163 = AbbreviateNumbers
if GetLocale():sub(1,2) == "zh" then
    local NUMBER_ABBREVIATION_DATA = {
        -- Order these from largest to smallest
        -- (significandDivisor and fractionDivisor should multiply to be equal to breakpoint)
        { breakpoint = 10000000000,	abbreviation = SECOND_NUMBER_CAP_NO_SPACE,	significandDivisor = 100000000,	fractionDivisor = 1 },
        { breakpoint = 100000000,	abbreviation = SECOND_NUMBER_CAP_NO_SPACE,	significandDivisor = 10000000,  fractionDivisor = 10 },
        { breakpoint = 1000000,	    abbreviation = FIRST_NUMBER_CAP_NO_SPACE,	significandDivisor = 10000,	    fractionDivisor = 1 },
        { breakpoint = 10000,		abbreviation = FIRST_NUMBER_CAP_NO_SPACE,	significandDivisor = 1000,	    fractionDivisor = 10 },
    }
    function AbbreviateNumbers163(value)
        for i, data in ipairs(NUMBER_ABBREVIATION_DATA) do
            if value >= data.breakpoint then
                local finalValue = math.floor(value / data.significandDivisor) / data.fractionDivisor;
                return finalValue .. data.abbreviation;
            end
        end
        return tostring(value);
    end
end

CoreDependCall("Blizzard_ArtifactUI", function()
    if not (ArtifactFrame and ArtifactFrame.PerksTab and ArtifactFrame.PerksTab.TitleContainer and ArtifactFrame.PerksTab.TitleContainer.PointsRemainingLabel) then return end
    local label = ArtifactFrame.PerksTab.TitleContainer.PointsRemainingLabel
    label:SetAnimatedDurationTimeSec(0.5)
    label.UpdateAnimatedValue = function(self, elapsed)
    	if self.targetAnimatedValue then
    		local change = self.initialAnimatedValueDelta * (elapsed / self:GetAnimatedDurationTimeSec());
    		if math.abs(self.targetAnimatedValue - self.currentAnimatedValue) <= change then
    			self:SnapToTarget();
    		else
    			local direction = self.targetAnimatedValue > self.currentAnimatedValue and 1 or -1;
    			self.currentAnimatedValue = self.currentAnimatedValue + direction * change;

    			self:SetText(AbbreviateLargeNumbers163(Round(self.currentAnimatedValue)));
    		end
    	end
    end

    label.SnapToTarget = function(self)
    	if self.targetAnimatedValue then
            local itemID, altItemID, name, icon, xp, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetArtifactInfo()
            local percent = ""
            local pointsAvailable = 0
            local remaining = self.targetAnimatedValue
            while(true) do
                local nextRankCost = C_ArtifactUI.GetCostForPointAtRank(pointsSpent + pointsAvailable, artifactTier)
                if not nextRankCost or nextRankCost <= 0 then
                    break
                elseif nextRankCost <= remaining then
                    pointsAvailable = pointsAvailable + 1
                    remaining = remaining - nextRankCost
                else
                    percent = format(" (%.1f%%)", (pointsAvailable + remaining / nextRankCost) * 100)
                    break
                end
            end

    		self:SetText(AbbreviateLargeNumbers163(Round(self.targetAnimatedValue))..percent);
    		self.currentAnimatedValue = self.targetAnimatedValue;
    		self.targetAnimatedValue = nil;
    	end
    end
end)

hooksecurefunc("ChatFrame_OpenChat", function(text, ...)
    if text == "/INSTANCE_CHAT" then
        ChatFrame_OpenChat("/INSTANCE", ...)
    end
end)

--[[
CoreOnEvent("COMBAT_LOG_EVENT_UNFILTERED", function(event, ...)
    do return end
    local timeStamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount = ...
    if sourceGUID ~= UnitGUID("player") then return end
    if subevent == "SPELL_DAMAGE" and spellId == 224266 and amount > 500000 then
        print(spellName, amount)
    elseif subevent == "SPELL_AURA_REMOVED" and spellId == 207635 then
        print(spellName, "REMOVED")
    end
end)
--]]

--[[------------------------------------------------------------
8.0 recursive
---------------------------------------------------------------]]
hooksecurefunc(GameTooltip, "SetOwner", function(self, parent, anchor)
    if parent == UIParent and anchor == "ANCHOR_NONE" then
        local tip
        tip = ShoppingTooltip1; if select(2, tip:GetPoint()) == self then tip:ClearAllPoints() end
        tip = ShoppingTooltip2; if select(2, tip:GetPoint()) == self then tip:ClearAllPoints() end
    end
end)

--[[------------------------------------------------------------
9.0.1 BossBanner_ConfigureLootFrame -> SetItemButtonQuality -> SetItemButtonOverlay
hooksecurefunc("IsArtifactRelicItem", function()
    if BossBanner and BossBanner.LootFrames then
        local lf = BossBanner.LootFrames[#BossBanner.LootFrames]
        if not lf.IconHitBox.IconOverlay2 then
            lf.IconHitBox.IconOverlay2 = {
                Show = noop,
                Hide = noop,
                SetAtlas = noop,
            }
        end
    end
end)
---------------------------------------------------------------]]

--[[------------------------------------------------------------
9.0 拍卖钓鱼价
---------------------------------------------------------------]]
CoreDependCall("Blizzard_AuctionHouseUI", function()
    local sellFrame = AuctionHouseFrame.CommoditiesSellFrame
    hooksecurefunc(sellFrame, "UpdatePriceSelection", function(self)
        local itemLocation = self:GetItem();
        if itemLocation then
            local firstSearchResult = C_AuctionHouse.GetCommoditySearchResultInfo(C_Item.GetItemID(itemLocation), 1);
            if firstSearchResult and self:GetUnitPrice() == firstSearchResult.unitPrice then
                if firstSearchResult.quantity <= 3 then
                    local sr2 = C_AuctionHouse.GetCommoditySearchResultInfo(C_Item.GetItemID(itemLocation), 2);
                    if sr2 and sr2.unitPrice >  firstSearchResult.unitPrice * 1.1 then
                        self:GetCommoditiesSellList():SetSelectedEntry(sr2);
                        U1Message(format("%s %s(卖家:|cffff0000%s|r)疑似钓鱼价，已为您避开", C_Item.GetItemLink(itemLocation) or "拍卖品", GetMoneyString(firstSearchResult.unitPrice), firstSearchResult.owners[1] or UNKNOWN))
                    end
                end
            end
        end
    end)
end)

--[[------------------------------------------------------------
9.0 噬渊reload显示帮助信息
CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    for frame in HelpTip.framePool:EnumerateActive() do
      if frame and frame.info and frame.info.text == EYE_OF_JAILER_TUTORIAL then
          frame:Close()
          break
      end
    end
    return true
end)
---------------------------------------------------------------]]
--[[------------------------------------------------------------
9.2扎雷殁提斯的按钮reload后会出现帮助
---------------------------------------------------------------]]
CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    --只要拖动过图标，就会设置cvar为true，进门的时候可以生效，但是reload不行
    if ZoneAbilityFrame:IsVisible() then
        for spellButton in ZoneAbilityFrame.SpellButtonContainer:EnumerateActive() do
            local zoneAbilityInfo = spellButton.zoneAbilityInfo;
            if zoneAbilityInfo and zoneAbilityInfo.zoneAbilityID then
                if true or GetCVarBitfield("closedExtraAbiltyTutorials", zoneAbilityInfo.zoneAbilityID) then
                    HelpTip:HideAll(ZoneAbilityFrame);
                end
            end
        end
    end
end)

--[[------------------------------------------------------------
9.15后切换盟约很麻烦，只能用
/run local G=GetSpellInfo SetMacroSpell(GetRunningMacro(), G"圣洁鸣钟" or G"红烬圣土")
来修改按钮的显示，但是必须按一次才生效，此部分代码在切换专精和盟约的时候自动运行这种代码
---------------------------------------------------------------]]
do
    local f = CreateFrame("Frame")
    f:RegisterEvent("COVENANT_CHOSEN")
    f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    f:RegisterEvent("SPELLS_CHANGED")
    local update = function(event)
        if InCombatLockdown() then return end
        for i=1,120 do
            local type, id = GetActionInfo(i)
            if type == "macro" and id then
                local _, _, text = GetMacroInfo(id)
                if text then
                    local _, _, code = text:find("/run (.-SetMacroSpell%(.-GetRunningMacro%(%).-)\n")
                    if code then
                        code = code:gsub("GetRunningMacro%(%)", id)
                        --print(event, code)
                        pcall(loadstring(code))
                    end
                end
            end
        end
    end
    f:SetScript("OnEvent", function(self, event)
        if not InCombatLockdown() then
            CoreScheduleBucket("ABYUI_UPDATE_MACRO", 0.3, update, event)
        end
    end)
end

--[[------------------------------------------------------------
9.2bug，没有CLIENT_SCENE_CLOSED
---------------------------------------------------------------]]
do
    local minigameStart
    CoreOnEvent("CLIENT_SCENE_OPENED", function(event, sceneType)
        if sceneType == Enum.ClientSceneType.MinigameSceneType then
            minigameStart = GetTime()
        end
    end)
    hooksecurefunc(PlayerFrame, "SetShown", function(self, shown) if shown then minigameStart = nil end end)
    CoreOnEvent("UPDATE_OVERRIDE_ACTIONBAR", function()
        if minigameStart and GetTime() - minigameStart < 60*10 and GetTime() - minigameStart > 2
                and not InCombatLockdown() and not PlayerFrame:IsVisible() then
            UpdateUIElementsForClientScene(nil)
            U1Message("9.2.42698 版本BUG，解谜游戏后无法显示头像，临时处理")
        end
    end)
end

CoreUIRegisterSlash("DEVELOPER_CONSOLE", "/dev", "/develop", function() DeveloperConsole:Toggle() end)