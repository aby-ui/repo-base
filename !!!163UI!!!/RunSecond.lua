EnableAddOn("!!!Libs") LoadAddOn("!!!Libs") --不能在CoreLibs之前，不能在163UIUI之后。之后根据有没有软件用库来决定是否加载

--TODO aby8
GuildControlUIRankSettingsFrameRosterLabel = GuildControlUIRankSettingsFrameRosterLabel or CreateFrame("Frame")

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
    QueueStatusMinimapButton:SetFrameStrata("HIGH")
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

--- 给任务追踪里的任务物品和技能增加一个安全按钮
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
                    :RegisterForClicks("AnyUp"):SetAllPoints()
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
    local function update_WorldQuestItemButtons()
        if InCombatLockdown() then return end
        for bliz, btn163 in pairs(wqItems163) do
            if type(btn163) == "string" then
                local link = btn163
                btn163 = WW:Button(nil, UIParent, "SecureActionButtonTemplate"):RegisterForClicks("AnyUp"):SetFrameStrata("HIGH")
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
    local hook_WorldQuest_Update = function(self)
        --if not IsAddOnLoaded("!KalielsTracker") then return end
        self = self or WORLD_QUEST_TRACKER_MODULE
        if not self.ShowWorldQuests then return end

        -- 除了watches之外，还有一个当前区域的世界任务，所以不循环GetNumWorldQuestWatches直接循环usedBlocks
        --- @see Blizzard_ObjectiveTracker\Blizzard_BonusObjectiveTracker.lua   UpdateTrackedWorldQuests(module)
        --- @see Blizzard_ObjectiveTracker\Blizzard_BonusObjectiveTracker.lua   AddBonusObjectiveQuest
        --- @see Blizzard_ObjectiveTracker\Blizzard_ObjectiveTracker.lua        DEFAULT_OBJECTIVE_TRACKER_MODULE:GetBlock(id)
        for questID, block in pairs(WORLD_QUEST_TRACKER_MODULE.usedBlocks) do
            if block and block.itemButton and block.itemButton:IsShown() then
                local questLogIndex = GetQuestLogIndexByID(questID);
                local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex);
                if link then
                    local blizBtn = block.itemButton
                    if wqItems163[blizBtn] and type(wqItems163[blizBtn])=="table" then wqItems163[blizBtn].link = link else wqItems163[blizBtn] = link end
                end
            end
        end

        update_WorldQuestItemButtons()
    end
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "Update", hook_WorldQuest_Update)
    CoreOnEvent("PLAYER_REGEN_ENABLED", update_WorldQuestItemButtons)
    CoreOnEvent("PLAYER_REGEN_DISABLED", update_WorldQuestItemButtons)
    CoreScheduleTimer(true, 0.5, update_WorldQuestItemButtons)
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
CastingBarFrame:SetFrameStrata("DIALOG")

if false and select(2, GetBuildInfo()) == "24330" then
    hooksecurefunc("SendChatMessage", function(msg, ...)
        local needSend = false
        while(true) do
            local start, finish, level, aff1, aff2, aff3, name = msg:find("\124cffa335ee\124Hkeystone:%d+:(%d+):(%d*):(%d*):(%d*)\124h%[(.-)%]\124h\124r")
            if level then
                --【钥石：艾萨拉之眼 10层：繁盛：暴怒：强韧】
                local txt = format("【%s %d层", name, level)
                if aff1 ~= "" then txt = txt.."："..C_ChallengeMode.GetAffixInfo(aff1) end
                if aff2 ~= "" then txt = txt.."："..C_ChallengeMode.GetAffixInfo(aff2) end
                if aff3 ~= "" then txt = txt.."："..C_ChallengeMode.GetAffixInfo(aff3) end
                txt = txt .. "】"
                msg = msg:sub(1,start-1) .. txt .. msg:sub(finish+1)
                needSend = true
            else
                break
            end
        end
        if needSend then
            SendChatMessage(msg, ...)
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