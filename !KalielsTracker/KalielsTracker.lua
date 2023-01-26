--- Kaliel's Tracker
--- Copyright (c) 2012-2022, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, addon = ...
local KT = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "LibSink-2.0", "MSA-ProtRouter-1.0")
KT:SetDefaultModuleState(false)
KT.title = addonName --GetAddOnMetadata(addonName, "Title")
KT.version = GetAddOnMetadata(addonName, "Version")
KT.gameVersion = GetBuildInfo()
KT.locale = GetLocale()

local L = addon.L

local LSM = LibStub("LibSharedMedia-3.0")
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- Lua API
local abs = math.abs
local floor = math.floor
local fmod = math.fmod
local format = string.format
local gsub = string.gsub
local ipairs = ipairs
local pairs = pairs
local strfind = string.find
local tonumber = tonumber
local tinsert = table.insert
local tremove = table.remove
local tContains = tContains
local unpack = unpack
local round = function(n) return floor(n + 0.5) end

-- WoW API
local _G = _G
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local HaveQuestRewardData = HaveQuestRewardData
local InCombatLockdown = InCombatLockdown
local FormatLargeNumber = FormatLargeNumber
local UIParent = UIParent

local trackerWidth = 280
local paddingBottom = 15
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local freeIcons = {}
local freeTags = {}
local freeButtons = {}
local msgPatterns = {}
local combatLockdown = false
local db, dbChar

-- Main frame
local KTF = CreateFrame("Frame", addonName.."Frame", UIParent, "BackdropTemplate")
KT.frame = KTF

-- Blizzard frame
local OTF = KT_ObjectiveTrackerFrame
local OTFHeader = OTF.HeaderMenu
local MawBuffs = KT_ScenarioBlocksFrame.MawBuffsBlock.Container

--------------
-- Internal --
--------------

local changedDefaultFunctions = {}
local customizationKeys = { "blockOffset", "buttonOffsets", "paddingBetweenButtons" }

local function Default_SetFunctionChanged(name, ...)
	tinsert(changedDefaultFunctions, {
		name = name,
		skipModules = { ... }
	})
end

local function Default_ChangeModuleTemplate(module, template)
	for _, key in ipairs(customizationKeys) do
		if module[key] then
			module[key][template] = module[key][module.blockTemplate]
		end
	end
	module.blockTemplate = template
end

local function Default_UpdateModuleInfoTables()
	-- Template
	for _, moduleName in ipairs(KT.ALL_BLIZZARD_MODULES) do
		local module = _G[moduleName]
		if module.blockTemplate == "KT_ObjectiveTrackerBlockTemplate" then
			Default_ChangeModuleTemplate(module, "KT2_ObjectiveTrackerBlockTemplate")
		elseif module.blockTemplate == "KT_BonusObjectiveTrackerBlockTemplate" then
			Default_ChangeModuleTemplate(module, "KT2_BonusObjectiveTrackerBlockTemplate")
		end
	end

	-- Functions
	local baseModule
	for _, func in ipairs(changedDefaultFunctions) do
		for _, module in ipairs(KT.ALL_BLIZZARD_MODULES) do
			if not tContains(func.skipModules, module) then
				baseModule = KT_DEFAULT_OBJECTIVE_TRACKER_MODULE
				if module == "KT_CAMPAIGN_QUEST_TRACKER_MODULE" then
					baseModule = KT_QUEST_TRACKER_MODULE
				end
				_G[module][func.name] = baseModule[func.name]
			end
		end
	end
end

local function QuestsCache_Update(isForced)
	local numQuests = 0
	local numEntries = C_QuestLog.GetNumQuestLogEntries()
	local headerTitle

	for i = 1, numEntries do
		local questInfo = C_QuestLog.GetInfo(i)
		if not questInfo.isHidden then
			if questInfo.isHeader then
				headerTitle = questInfo.title
			else
				if not questInfo.isTask and (not questInfo.isBounty or C_QuestLog.IsComplete(questInfo.questID)) then
					if not dbChar.quests.cache[questInfo.questID] or isForced then
						dbChar.quests.cache[questInfo.questID] = {
							title = questInfo.title,
							level = questInfo.level,
							zone = headerTitle,
							startMapID = dbChar.quests.cache[questInfo.questID] and dbChar.quests.cache[questInfo.questID].startMapID or 0,
							isCalling = C_QuestLog.IsQuestCalling(questInfo.questID)
						}
					end
				end
				if not C_QuestLog.IsQuestCalling(questInfo.questID) then
					numQuests = numQuests + 1
				end
			end
		end
	end

	return numEntries <= 1, numQuests
end

local function QuestsCache_GetProperty(questID, key)
	return dbChar.quests.cache[questID] and dbChar.quests.cache[questID][key] or nil
end
KT.QuestsCache_GetProperty = QuestsCache_GetProperty

local function QuestsCache_UpdateProperty(questID, key, value)
	if dbChar.quests.cache[questID] then
		dbChar.quests.cache[questID][key] = value
	end
end

local function QuestsCache_RemoveQuest(questID)
	dbChar.quests.cache[questID] = nil
end

local function QuestsCache_Init()
	return QuestsCache_Update(true)
end
KT.QuestsCache_Init = QuestsCache_Init

local function ObjectiveTracker_Toggle()
	if OTF.collapsed then
		KT_ObjectiveTracker_Expand()
	else
		KT_ObjectiveTracker_Collapse()
	end
	KT_ObjectiveTracker_Update()
end

local function SetHeaders(type)
	local bgrColor = db.hdrBgrColorShare and KT.borderColor or db.hdrBgrColor
	local txtColor = db.hdrTxtColorShare and KT.borderColor or db.hdrTxtColor

	if not type or type == "background" then
		for _, header in ipairs(KT.headers) do
			if db.hdrBgr == 1 then
				header.Background:Hide()
			elseif db.hdrBgr == 2 then
				header.Background:SetAtlas("Objective-Header")
				header.Background:SetVertexColor(1, 1, 1)
				header.Background:ClearAllPoints()
				header.Background:SetPoint("TOPLEFT", -29, 14)
				header.Background:Show()
			elseif db.hdrBgr >= 3 then
				header.Background:SetTexture(mediaPath.."UI-KT-HeaderBackground-"..(db.hdrBgr - 2))
				header.Background:SetVertexColor(bgrColor.r, bgrColor.g, bgrColor.b)
				header.Background:SetPoint("TOPLEFT", -20, 0)
				header.Background:SetPoint("BOTTOMRIGHT", 17, -7)
				header.Background:Show()
			end
		end
	end
	if not type or type == "text" then
		OTFHeader.Title:SetFont(KT.font, db.fontSize, db.fontFlag)
		OTFHeader.Title:SetTextColor(txtColor.r, txtColor.g, txtColor.b)
		OTFHeader.Title:SetShadowColor(0, 0, 0, db.fontShadow)

		for _, header in ipairs(KT.headers) do
			if type == "text" then
				header.Text:SetFont(KT.font, db.fontSize+1, db.fontFlag)
				if db.hdrBgr == 2 then
					header.Button.Icon:SetVertexColor(1, 0.82, 0)
					header.Text:SetTextColor(1, 0.82, 0)
				else
					header.Button.Icon:SetVertexColor(txtColor.r, txtColor.g, txtColor.b)
					header.Text:SetTextColor(txtColor.r, txtColor.g, txtColor.b)
				end
				header.Text:SetShadowColor(0, 0, 0, db.fontShadow)
				header.Text:SetPoint("LEFT", 4, 0.5)
				header.animateReason = 0
			end
		end
	end
end

local function SetMsgPatterns()
	local patterns = {
		-- enUS/frFR/etc. ... "%s: %d/%d"
		-- deDE (only) ...... "%1$s: %2$d/%3$d"
		ERR_QUEST_ADD_FOUND_SII,
		ERR_QUEST_ADD_ITEM_SII,
		ERR_QUEST_ADD_KILL_SII,
		ERR_QUEST_ADD_PLAYER_KILL_SII,
	}
	for _, patt in ipairs(patterns) do
		patt = "^"..patt:gsub("%d+%$", ""):gsub("%%s", ".*"):gsub("%%d", "%%d+").."$"
		tinsert(msgPatterns, patt)
	end
end

local function SlashHandler(msg, editbox)
	local cmd, value = msg:match("^(%S*)%s*(.-)$")
	if cmd == "config" or cmd == "option" then
		KT:OpenOptions()
	else
		KT:MinimizeButton_OnClick()
	end
end

local function SetScrollbarPosition()
	KTF.Bar:SetPoint("TOPRIGHT", -5, -round(5+(KTF.Scroll.value*(((db.maxHeight-60)/((OTF.height-db.maxHeight)/KTF.Scroll.step))/KTF.Scroll.step))))
end

local function GetTaskTimeLeftData(questID)
	local timeString = ""
	local timeColor = KT_OBJECTIVE_TRACKER_COLOR["TimeLeft2"]
	local timeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes(questID)
	if timeLeftMinutes and timeLeftMinutes > 0 then
		timeString = SecondsToTime(timeLeftMinutes * 60)
		if timeLeftMinutes <= WORLD_QUESTS_TIME_CRITICAL_MINUTES then
			timeColor = KT_OBJECTIVE_TRACKER_COLOR["TimeLeft"]
		end
	end
	return timeString, timeColor
end

local function GetBlockIcon(block)
	local icon = block.icon
	if not icon then
		local numFreeIcons = #freeIcons
		if numFreeIcons > 0 then
			icon = freeIcons[numFreeIcons]
			tremove(freeIcons, numFreeIcons)
			icon:ClearAllPoints()
		else
			icon = CreateFrame("Frame", nil, OTF.BlocksFrame, "KT_ObjectiveTrackerBlockIconTemplate")
		end
		icon:SetPoint("TOPRIGHT", block.HeaderText, "TOPLEFT", 1, 8)
		block.icon = icon
	end
	icon:Show()
	return icon
end

local function RemoveBlockIcon(block)
	local icon = block.icon
	if icon then
		tinsert(freeIcons, icon)
		icon:Hide()
		block.icon = nil
	end
end

local function ModuleMinimize_OnClick(module)
	KT_ObjectiveTracker_MinimizeModuleButton_OnClick(module.Header.MinimizeButton)
	local icon = module.Header.Button.Icon
	if module:IsCollapsed() then
		icon:SetTexCoord(0, 0.5, 0.75, 1)
	else
		icon:SetTexCoord(0.5, 1, 0.75, 1)
	end
end

-- Setup ---------------------------------------------------------------------------------------------------------------

local function Init()
	db = KT.db.profile

	if db.keyBindMinimize ~= "" then
		SetOverrideBindingClick(KTF, false, db.keyBindMinimize, KTF.MinimizeButton:GetName())
	end

	for i, module in ipairs(db.modulesOrder) do
		OTF.MODULES_UI_ORDER[i] = _G[module]
		KT:SetModuleHeader(OTF.MODULES_UI_ORDER[i])
	end

	KT:MoveTracker()
    CoreOnEvent("PLAYER_ENTERING_WORLD", function() KT:MoveTracker() end)
	KT:SetBackground()
	KT:SetText()

	KT.stopUpdate = false
	KT.inWorld = true

	C_Timer.After(0, function()
		if dbChar.collapsed then
			ObjectiveTracker_Toggle()
		end

		KT:SetQuestsHeaderText()
		KT:SetAchievsHeaderText()

		OTF:KTSetPoint("TOPLEFT", 30, -1)
		OTF:KTSetPoint("BOTTOMRIGHT")
		KT_ObjectiveTracker_Update()

		-- Fix for interference of some addons with event PLAYER_ENTERING_WORLD (this is not a bug of KT)
		KT_TopScenarioWidgetContainerBlock.WidgetContainer:ProcessAllWidgets()
		KT_BottomScenarioWidgetContainerBlock.WidgetContainer:ProcessAllWidgets()

		KT.initialized = true
		KT.wqInitialized = true
	end)
end

-- Frames --------------------------------------------------------------------------------------------------------------

local function SetFrames()
	-- Main frame
	KTF:SetWidth(trackerWidth)
	KTF:SetFrameStrata(db.frameStrata)
	KTF:SetFrameLevel(KTF:GetFrameLevel() + 25)

	KTF:SetScript("OnEvent", function(self, event, ...)
		_DBG("Event - "..event)
		if event == "PLAYER_ENTERING_WORLD" and not KT.stopUpdate then
			KT.inWorld = true
			KT.inInstance = IsInInstance()
			if db.collapseInInstance and KT.inInstance and not dbChar.collapsed then
				ObjectiveTracker_Toggle()
			end
		elseif event == "PLAYER_LEAVING_WORLD" then
			KT.inWorld = false
		elseif event == "QUEST_WATCH_LIST_CHANGED" then
			local id, added = ...
			if id and not added then
				if KT.activeTasks[id] then
					KT.activeTasks[id] = nil
				end
			end
			KT:ToggleEmptyTracker(added)
		elseif event == "TRACKED_ACHIEVEMENT_LIST_CHANGED" then
			local id, added = ...
			KT:ToggleEmptyTracker(added)
		elseif event == "SCENARIO_UPDATE" then
			local newStage = ...
			if newStage == nil then
				KT.inScenario = false
			elseif not KT.inScenario then
				C_Timer.After(0.1, function()  -- WTF
					if IsInJailersTower() == nil or IsOnGroundFloorInJailersTower() == true then
						KT.inScenario = false
					else
						KT.inScenario = true
					end
					KT:ToggleEmptyTracker(KT.inScenario and not db.collapseInInstance)
				end)
			end
			if not newStage then
				local numSpells = KT_ScenarioObjectiveBlock.numSpells or 0
				for i = 1, numSpells do
					KT:RemoveFixedButton(KT_ScenarioObjectiveBlock.spells[i])
				end
				KT_ObjectiveTracker_Update()
			end
		elseif event == "SCENARIO_COMPLETED" then
			KT.inScenario = false
			KT:ToggleEmptyTracker()
		elseif event == "QUEST_AUTOCOMPLETE" then
			KTF.Scroll.value = 0
		elseif event == "QUEST_ACCEPTED" or event == "QUEST_REMOVED" then
			local questID = ...
			if not C_QuestLog.IsQuestTask(questID) and not C_QuestLog.IsQuestBounty(questID) then
				local _, numQuests = QuestsCache_Update()
				dbChar.quests.num = numQuests
				KT:SetQuestsHeaderText()
				if event == "QUEST_ACCEPTED" then
					QuestsCache_UpdateProperty(questID, "startMapID", KT.GetCurrentMapAreaID())
				elseif event == "QUEST_REMOVED" then
					QuestsCache_RemoveQuest(questID)
				end
			end
		elseif event == "ACHIEVEMENT_EARNED" then
			KT:SetAchievsHeaderText()
		elseif event == "TRACKED_RECIPE_UPDATE" then
			local _, tracked = ...
			KT:ToggleEmptyTracker(tracked)
		elseif event == "BAG_UPDATE_DELAYED" then
			KT_ObjectiveTracker_Update(KT_OBJECTIVE_TRACKER_UPDATE_MODULE_PROFESSION_RECIPE)
		elseif event == "PLAYER_REGEN_ENABLED" and combatLockdown then
			combatLockdown = false
			KT:RemoveFixedButton()
			KT_ObjectiveTracker_Update()
		elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" then
			KTF.Buttons.reanchor = (KTF.Buttons.num > 0)
		elseif event == "UPDATE_BINDINGS" then
			KT:UpdateHotkey()
		elseif event == "PLAYER_LEVEL_UP" then
			local level = ...
			KT.playerLevel = level
		elseif event == "QUEST_SESSION_JOINED" then
			self:RegisterEvent("QUEST_POI_UPDATE")
		elseif event == "PET_BATTLE_OPENING_START" then
			KT:prot("Hide", KTF)
			KT:prot("Hide", KTF.Buttons)
			KT.locked = true
		elseif event == "PET_BATTLE_CLOSE" then
			KT:prot("Show", KTF)
			KT:prot("Show", KTF.Buttons)
			KT.locked = false
		elseif event == "QUEST_LOG_UPDATE" then
			local emptyCache = QuestsCache_Init()
			if not emptyCache then
				self:UnregisterEvent(event)
			end
		elseif event == "QUEST_POI_UPDATE" then
			dbChar.quests.num = KT.GetNumQuests()
			KT_ObjectiveTracker_Update(KT_OBJECTIVE_TRACKER_UPDATE_QUEST)
			self:UnregisterEvent(event)
		end
	end)
	KTF:RegisterEvent("PLAYER_ENTERING_WORLD")
	KTF:RegisterEvent("PLAYER_LEAVING_WORLD")
	KTF:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
	KTF:RegisterEvent("TRACKED_ACHIEVEMENT_LIST_CHANGED")
	KTF:RegisterEvent("SCENARIO_UPDATE")
	KTF:RegisterEvent("SCENARIO_COMPLETED")
	KTF:RegisterEvent("QUEST_AUTOCOMPLETE")
	KTF:RegisterEvent("QUEST_ACCEPTED")
	KTF:RegisterEvent("QUEST_REMOVED")
	KTF:RegisterEvent("QUEST_SESSION_JOINED")
	KTF:RegisterEvent("QUEST_LOG_UPDATE")
	KTF:RegisterEvent("QUEST_POI_UPDATE")
	KTF:RegisterEvent("ACHIEVEMENT_EARNED")
	KTF:RegisterEvent("TRACKED_RECIPE_UPDATE")
	KTF:RegisterEvent("BAG_UPDATE_DELAYED")
	KTF:RegisterEvent("PLAYER_REGEN_ENABLED")
	KTF:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	KTF:RegisterEvent("ZONE_CHANGED")
	KTF:RegisterEvent("UPDATE_BINDINGS")
	KTF:RegisterEvent("PLAYER_LEVEL_UP")
	KTF:RegisterEvent("PET_BATTLE_OPENING_START")
	KTF:RegisterEvent("PET_BATTLE_CLOSE")

	-- DropDown frame
	KT.DropDown = MSA_DropDownMenu_Create(addonName.."DropDown", KTF)
	MSA_DropDownMenu_Initialize(KT.DropDown, nil, "MENU")

	-- Header buttons
	local headerButtons = CreateFrame("Frame", addonName.."HeaderButtons", KTF)
	headerButtons:SetSize(0, 25)
	headerButtons:SetPoint("TOPRIGHT", -4, -4)
	headerButtons:SetFrameLevel(KTF:GetFrameLevel() + 10)
	headerButtons:EnableMouse(true)
	headerButtons.num = 0
	KTF.HeaderButtons = headerButtons

	-- Minimize button
	OTFHeader.MinimizeButton:Hide()
	local button = CreateFrame("Button", addonName.."MinimizeButton", KTF.HeaderButtons)
	button:SetSize(16, 16)
	button:SetPoint("TOPRIGHT", -6, -4)
	button:SetNormalTexture(mediaPath.."UI-KT-HeaderButtons")
	button:GetNormalTexture():SetTexCoord(0, 0.5, 0.25, 0.5)
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnMouseDown", function()
		if IsShiftKeyDown() then
			KT.frame.isMouseMoving = 1
			KT.frame:SetMovable(true)
			KT.frame:StartMoving()
		end
	end)
	button:SetScript("OnMouseUp", function()
		KT.frame:StopMovingOrSizing()
		KT.frame:SetMovable(false)
		if not KT.frame.isMouseMoving then return end
		local point = KT.db.profile.anchorPoint or "TOPRIGHT"
		if point:upper():find("LEFT") then
			KT.db.profile.xOffset = KT.frame:GetLeft() - UIParent:GetLeft()
		else
			KT.db.profile.xOffset = KT.frame:GetRight() - UIParent:GetRight()
		end
		if point:upper():find("BOTTOM") then
			KT.db.profile.yOffset = KT.frame:GetBottom() - UIParent:GetBottom()
		else
			KT.db.profile.yOffset = KT.frame:GetTop() - UIParent:GetTop()
		end
		KT:MoveTracker()
	end)
	button:SetScript("OnClick", function(self, btn)
		if KT.frame.isMouseMoving then
			KT.frame.isMouseMoving = nil
			return
		end
		if IsAltKeyDown() then
			KT:OpenOptions()
		elseif not KT:IsTrackerEmpty() and not KT.locked then
			KT:MinimizeButton_OnClick()
		end
	end)
	button:SetScript("OnEnter", function(self)
		self:GetNormalTexture():SetVertexColor(1, 1, 1)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local title = (db.keyBindMinimize ~= "") and L[addonName].." "..NORMAL_FONT_COLOR_CODE.."("..db.keyBindMinimize..")|r" or L[addonName]
		GameTooltip:AddLine(title, 1, 1, 1)
		GameTooltip:AddLine(L"Alt+Click - addon Options", .8, .8, 0, true)
		GameTooltip:AddLine(L"Shift+Click - Move Panel", .8, .8, 0)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		self:GetNormalTexture():SetVertexColor(KT.hdrBtnColor.r, KT.hdrBtnColor.g, KT.hdrBtnColor.b)
		GameTooltip:Hide()
	end)
	KTF.MinimizeButton = button
	KT:SetHeaderButtons(1)

	-- Scroll frame
	local Scroll = CreateFrame("ScrollFrame", addonName.."Scroll", KTF)
	Scroll:SetPoint("TOPLEFT", 4, -4)
	Scroll:SetPoint("BOTTOMRIGHT", -4, 4)
    Scroll:SetClipsChildren(true)
	Scroll:EnableMouseWheel(true)
	Scroll.step = 20
	Scroll.value = 0
	Scroll:SetScript("OnMouseWheel", function(self, delta)
		if not dbChar.collapsed and OTF.height > db.maxHeight then
			if delta < 0 then
				self.value = (self.value+self.step < OTF.height-db.maxHeight) and self.value + self.step or OTF.height - db.maxHeight
			else
				self.value = (self.value-self.step > 0) and self.value - self.step or 0
			end
			self:SetVerticalScroll(self.value)
			if db.frameScrollbar then
				SetScrollbarPosition()
			end
			if self.value >= 0 and self.value < OTF.height-db.maxHeight then
				MSA_CloseDropDownMenus()
				MawBuffs.List:Hide()
			end
			_DBG("SCROLL ... "..self.value.." ... "..OTF.height.." - "..db.maxHeight)
		end
	end)
	KTF.Scroll = Scroll

	-- Scroll child frame
	local Child = CreateFrame("Frame", addonName.."ScrollChild", KTF.Scroll)
	Child:SetSize(trackerWidth-8, 8000)
	KTF.Scroll:SetScrollChild(Child)
	KTF.Child = Child

	-- Scroll indicator
	local Bar = CreateFrame("Frame", addonName.."ScrollBar", KTF)
	Bar:SetSize(2, 50)
	Bar:SetPoint("TOPRIGHT", -5, -5)
	Bar:SetFrameLevel(KTF:GetFrameLevel() + 10)
	Bar.texture = Bar:CreateTexture()
	Bar.texture:SetAllPoints()
	Bar:Hide()
	KTF.Bar = Bar

	-- Blizzard frames
	OTF:KTSetPoint("TOPLEFT", 30, -1)
	OTF:KTSetPoint("BOTTOMRIGHT")
	OTF:KTSetParent(Child)
	OTFHeader:Show()
	OTFHeader.Hide = function() end
	OTFHeader.SetShown = function() end
	OTFHeader:SetSize(10, 21)
	OTFHeader:ClearAllPoints()
	OTFHeader.ClearAllPoints = function() end
	OTFHeader:SetPoint("TOPLEFT", -20, -1)
	OTFHeader.SetPoint = function() end
	OTFHeader.Title:ClearAllPoints()
	OTFHeader.Title.ClearAllPoints = function() end
	OTFHeader.Title:SetPoint("LEFT", -5, -1)
	OTFHeader.Title.SetPoint = function() end
	OTFHeader.Title:SetWidth(trackerWidth - 40)
	OTFHeader.Title:SetWordWrap(false)
	KT_ScenarioBlocksFrame:SetWidth(243)
	MawBuffs.List:SetParent(UIParent)
	MawBuffs.List:SetFrameLevel(MawBuffs:GetFrameLevel() - 1)
	MawBuffs.List:SetClampedToScreen(true)
	HelpTip:Hide(MawBuffs, JAILERS_TOWER_BUFFS_TUTORIAL)

	-- Other buttons
	KT:SetOtherButtons()

	-- Buttons frame
	local Buttons = CreateFrame("Frame", addonName.."Buttons", UIParent, "BackdropTemplate")
	Buttons:SetSize(40, 40)
	Buttons:SetPoint("TOPLEFT", 0, 0)
	Buttons:SetFrameStrata(db.frameStrata)
	Buttons:SetFrameLevel(KTF:GetFrameLevel() - 1)
	Buttons:SetAlpha(0)
	Buttons.num = 0
	Buttons.reanchor = false
	KTF.Buttons = Buttons

	--abyui origin had hide code but removed in 4.2.0
    --CoreHideOnPetBattle(addonName.."Frame")
    --CoreHideOnPetBattle(addonName.."Buttons")
end

-- Hooks ---------------------------------------------------------------------------------------------------------------

local function SetHooks()
	local function SetFixedButton(block, idx, height, yOfs)
		if block.fixedTag and KT.fixedButtons[block.id] then
			idx = idx + 1
			block.fixedTag.text:SetText(idx)
			KT.fixedButtons[block.id].text:SetText(idx)
			KT.fixedButtons[block.id].num = idx
			yOfs = -(height + 7)
			height = height + 26 + 3
			KT.fixedButtons[block.id]:SetPoint("TOP", 0, yOfs)
		end
		return idx, height, yOfs
	end

	local function FixedButtonsReanchor()
		if InCombatLockdown() then
			if KTF.Buttons.num > 0 then
				combatLockdown = true
			end
		else
			if KTF.Buttons.reanchor then
				local questID, block, questLogIndex, yOfs
				local idx = 0
				local contentsHeight = 0
				-- Scenario
				_DBG(" - REANCHOR buttons - Scen", true)
				local numSpells = KT_ScenarioObjectiveBlock.numSpells or 0
				for i = 1, numSpells do
					block = KT_ScenarioObjectiveBlock.spells[i]
					if block and block.SpellButton then
						idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
					end
				end
				-- World Quest items
				_DBG(" - REANCHOR buttons - WQ", true)
				local tasksTable = GetTasksTable()
				for i = 1, #tasksTable do
					questID = tasksTable[i]
					if KT.activeTasks[questID] and QuestUtils_IsQuestWorldQuest(questID) and not QuestUtils_IsQuestWatched(questID) then
						block = KT_WORLD_QUEST_TRACKER_MODULE:GetExistingBlock(questID)
						if block and block.itemButton then
							idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
						end
					end
				end
				for i = 1, C_QuestLog.GetNumWorldQuestWatches() do
					questID = C_QuestLog.GetQuestIDForWorldQuestWatchIndex(i)
					if questID then
						block = KT_WORLD_QUEST_TRACKER_MODULE:GetExistingBlock(questID)
						if block and block.itemButton then
							idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
						end
					end
				end
				-- Quest items
				_DBG(" - REANCHOR buttons - Q", true)
				for i = 1, C_QuestLog.GetNumQuestWatches() do
					questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i)
					block = KT_QUEST_TRACKER_MODULE:GetExistingBlock(questID) or KT_CAMPAIGN_QUEST_TRACKER_MODULE:GetExistingBlock(questID)
					if block and block.itemButton then
						idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
					end
				end
				if contentsHeight > 0 then
					contentsHeight = contentsHeight + 7 + 4
				end
				KTF.Buttons:SetHeight(contentsHeight)
				KTF.Buttons.num = idx
				KTF.Buttons.reanchor = false
			end
			if dbChar.collapsed or KTF.Buttons.num == 0 then
				KTF.Buttons:Hide()
			else
				KTF.Buttons:SetShown(not KT.locked)
			end
			KT.ActiveButton:Update()
		end
		if dbChar.collapsed or KTF.Buttons.num == 0 then
			KTF.Buttons:SetAlpha(0)
		else
			KTF.Buttons:SetAlpha(1)
		end
	end

	hooksecurefunc(ObjectiveTrackerFrame, "Show", function(self)
		self:Hide()
	end)

	hooksecurefunc(ObjectiveTrackerFrame, "SetShown", function(self, show)
		if show then
			self:Hide()
		end
	end)

	hooksecurefunc(OTF, "SetParent", function(self, parent)
		if parent and parent ~= KTF.Child then
			self:SetParent(KTF.Child)
		end
	end)

	hooksecurefunc(OTF, "ClearAllPoints", function(self)
		self:KTSetPoint("TOPLEFT", 30, -1)
		self:KTSetPoint("BOTTOMRIGHT")
	end)

	OTF:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" and not KT.initialized then
			self.freeLines[1] = nil

			Default_UpdateModuleInfoTables()

			KT_SCENARIO_CONTENT_TRACKER_MODULE.blockOffset[KT_SCENARIO_CONTENT_TRACKER_MODULE.blockTemplate][1] = -16
			KT_QUEST_TRACKER_MODULE.buttonOffsets[KT_QUEST_TRACKER_MODULE.blockTemplate].useItem = { 3, 4 }
			KT_QUEST_TRACKER_MODULE.buttonOffsets[KT_QUEST_TRACKER_MODULE.blockTemplate].groupFinder = { 2, 3 }
			KT_BONUS_OBJECTIVE_TRACKER_MODULE.blockPadding = 0
			KT_BONUS_OBJECTIVE_TRACKER_MODULE.buttonOffsets[KT_BONUS_OBJECTIVE_TRACKER_MODULE.blockTemplate].useItem = { 0, 2 }
			KT_BONUS_OBJECTIVE_TRACKER_MODULE.buttonOffsets[KT_BONUS_OBJECTIVE_TRACKER_MODULE.blockTemplate].groupFinder = { 2, 2 }
			KT_WORLD_QUEST_TRACKER_MODULE.blockPadding = 0
			KT_WORLD_QUEST_TRACKER_MODULE.buttonOffsets[KT_WORLD_QUEST_TRACKER_MODULE.blockTemplate].useItem = { 0, 2 }
			KT_WORLD_QUEST_TRACKER_MODULE.buttonOffsets[KT_WORLD_QUEST_TRACKER_MODULE.blockTemplate].groupFinder = { 2, 2 }

			Init()
		end
	end)
    KT.Init = Init

	local bck_KT_ObjectiveTracker_Update = KT_ObjectiveTracker_Update
	KT_ObjectiveTracker_Update = function(reason, id, moduleWhoseCollapseChanged)
		if KT.stopUpdate then return end
		local dbgReason
		if reason == KT_OBJECTIVE_TRACKER_UPDATE_ALL then
			dbgReason = "FFFFFFFF"
		else
			dbgReason = reason and format("%x", reason) or ""
		end
		_DBG("|cffffff00Update ... "..dbgReason, true)
		bck_KT_ObjectiveTracker_Update(reason, id, moduleWhoseCollapseChanged)
		FixedButtonsReanchor()
		if dbChar.collapsed then
			local title = ""
			if db.hdrCollapsedTxt == 2 then
				title = "|T"..mediaPath.."KT_logo:22:22:0:0|t"..("%d/%d"):format(dbChar.quests.num, MAX_QUESTS)
			elseif db.hdrCollapsedTxt == 3 then
				title = "|T"..mediaPath.."KT_logo:22:22:0:0|t"..L("%d/%d Quests"):format(dbChar.quests.num, MAX_QUESTS)
			end
			OTFHeader.Title:SetText(title)
		end
		if KT.IsTableEmpty(KT.activeTasks) then
			KT:ToggleEmptyTracker()
		end
		KT:SetSize()
	end

	function KT_DEFAULT_OBJECTIVE_TRACKER_MODULE:AddObjective(block, objectiveKey, text, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)  -- RO
		if objectiveKey == "TimeLeft" then
			text, colorStyle = GetTaskTimeLeftData(block.id)
			self:FreeProgressBar(block, block.currentLine)	-- fix ProgressBar duplicity
		elseif objectiveKey == 0 then	-- Bonus Objective as a Header
			block.title = text
		end
		if self == KT_ACHIEVEMENT_TRACKER_MODULE and text == "" then
			text = "..."  -- fix Blizz bug
		elseif self == KT_SCENARIO_TRACKER_MODULE and self.lineSpacing == 12 then
			self.lineSpacing = 5
		end
		local _, _, leftText, colon, progress, numHave, numNeed, rightText = strfind(text, "(.-)(%s?:?%s?)((%d+)%s?/%s?(%d+))(.*)")
		if progress then
			if tonumber(numHave) > 0 and tonumber(numHave) < tonumber(numNeed) then
				progress = "|cffc8c800" .. progress .. "|r"
			end
			if not db.objNumSwitch then
				text = leftText .. colon .. progress .. rightText
			else
				text = progress
				if rightText ~= " " then
					text = text .. rightText
				end
				if leftText ~= "" then
					text = text .. " " .. leftText
				end
			end
		end

		local line = self:GetLine(block, objectiveKey, lineType);
		-- width
		if ( block.lineWidth ~= line.width ) then
			line.Text:SetWidth(block.lineWidth or self.lineWidth);
			line.width = block.lineWidth;	-- default should be nil
		end
		-- dash
		if ( line.Dash ) then
			if ( not dashStyle ) then
				dashStyle = KT_OBJECTIVE_DASH_STYLE_SHOW;
			end
			if ( line.dashStyle ~= dashStyle ) then
				if ( dashStyle == KT_OBJECTIVE_DASH_STYLE_SHOW ) then
					line.Dash:Show();
					line.Dash:SetText(KT.QUEST_DASH);
				elseif ( dashStyle == KT_OBJECTIVE_DASH_STYLE_HIDE ) then
					line.Dash:Hide();
					line.Dash:SetText(KT.QUEST_DASH);
				elseif ( dashStyle == KT_OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE ) then
					line.Dash:Hide();
					line.Dash:SetText(nil);
				else
					error("Invalid dash style: " .. tostring(dashStyle));
				end
				line.dashStyle = dashStyle;
			end
			if not line.Dash.KTskinned or KT.forcedUpdate then
				line.Dash:SetFont(KT.font, db.fontSize, db.fontFlag)
				line.Dash:SetShadowColor(0, 0, 0, db.fontShadow)
				line.Dash.KTskinned = true
			end
		end
		-- check
		if line.Check and (not line.Check.KTskinned or KT.forcedUpdate) then
			line.Check:SetSize(db.fontSize-2.5, db.fontSize-2.5)
			line.Check:ClearAllPoints()
			line.Check:SetPoint("TOPLEFT", -db.fontSize*0.2+(db.fontFlag == "" and 0 or 1), -2)
			line.Check.KTskinned = true
		end
		-- set the text
		local textHeight = self:SetStringText(line.Text, text, useFullHeight, colorStyle, block.isHighlighted);
		local height = overrideHeight or textHeight;
		line:SetHeight(height);

		local yOffset;

		if ( adjustForNoText and text == "" ) then
			-- don't change the height
			-- move the line up so the next object ends up in the same position as if there had been no line
			yOffset = height;
		else
			block.height = block.height + height + block.module.lineSpacing;
			yOffset = -block.module.lineSpacing;
		end
		-- anchor the line
		local anchor = block.currentLine or block.HeaderText;
		if ( anchor ) then
			line:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, yOffset);
		else
			line:SetPoint("TOPLEFT", 0, yOffset);
		end
		block.currentLine = line;

		-- completion state
		local questsCache = dbChar.quests.cache
		if KT.inWorld and questsCache[block.id] and type(objectiveKey) == "string" then
			if strfind(objectiveKey, "Complete") then
				if not questsCache[block.id].state or questsCache[block.id].state ~= "complete" then
					if db.messageQuest then
						KT:SetMessage(block.title, 0, 1, 0, ERR_QUEST_COMPLETE_S, "Interface\\GossipFrame\\ActiveQuestIcon", -2, 0)
					end
					if db.soundQuest then
						KT:PlaySound(db.soundQuestComplete)
					end
					questsCache[block.id].state = "complete"
				end
			elseif strfind(objectiveKey, "Failed") then
				if not questsCache[block.id].state or questsCache[block.id].state ~= "failed" then
					if db.messageQuest then
						KT:SetMessage(block.title, 1, 0, 0, ERR_QUEST_FAILED_S, "Interface\\GossipFrame\\AvailableQuestIcon", -2, 0)
					end
					questsCache[block.id].state = "failed"
				end
			end
		end

		return line;
	end
	Default_SetFunctionChanged("AddObjective")

	function KT_DEFAULT_OBJECTIVE_TRACKER_MODULE:SetStringText(fontString, text, useFullHeight, colorStyle, useHighlight)  -- RO
		if not fontString.KTskinned or KT.forcedUpdate then
			fontString:SetFont(KT.font, db.fontSize, db.fontFlag)
			fontString:SetShadowColor(0, 0, 0, db.fontShadow)
			fontString:SetWordWrap(db.textWordWrap)
			fontString.KTskinned = true
		end
		if self == KT_QUEST_TRACKER_MODULE and not useHighlight then
			useHighlight = fontString:GetParent().isHighlighted  -- fix Blizz bug
		end
		if useFullHeight then
			fontString:SetMaxLines(0)
		else
			fontString:SetMaxLines(2)
		end
		fontString:SetText(text)

		local stringHeight = fontString:GetHeight()
		colorStyle = colorStyle or KT_OBJECTIVE_TRACKER_COLOR["Normal"]
		if ( useHighlight and colorStyle.reverse ) then
			colorStyle = colorStyle.reverse
		end
		if ( fontString.colorStyle ~= colorStyle ) then
			fontString:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			fontString.colorStyle = colorStyle
		end
		return stringHeight
	end
	Default_SetFunctionChanged("SetStringText")

	local function ShouldShowWarModeBonus(questID, currencyID, firstInstance)  -- C
		if not C_PvP.IsWarModeDesired() then
			return false;
		end

		local warModeBonusApplies, limitOncePerTooltip = C_CurrencyInfo.DoesWarModeBonusApply(currencyID);
		if not warModeBonusApplies or (limitOncePerTooltip and not firstInstance) then
			return false;
		end

		return QuestUtils_IsQuestWorldQuest(questID) and C_QuestLog.QuestHasWarModeBonus(questID) and not C_CurrencyInfo.GetFactionGrantedByCurrency(currencyID);
	end

	hooksecurefunc(KT_DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderEnter", function(self, block)
		local colorStyle, _
		if block.module == KT_QUEST_TRACKER_MODULE or
				block.module == KT_CAMPAIGN_QUEST_TRACKER_MODULE then
			if block.questCompleted then
				colorStyle = KT_OBJECTIVE_TRACKER_COLOR["CompleteHighlight"]
			elseif db.colorDifficulty then
				_, colorStyle = GetQuestDifficultyColor(block.level)
			end
		end
		if colorStyle then
			block.HeaderText:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.HeaderText.colorStyle = colorStyle
		end

		if db.tooltipShow and (block.module == KT_QUEST_TRACKER_MODULE or
				block.module == KT_CAMPAIGN_QUEST_TRACKER_MODULE or
				block.module == KT_ACHIEVEMENT_TRACKER_MODULE) then
			GameTooltip:SetOwner(block, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			if KTF.anchorLeft then
				GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 12, 1)
			else
				GameTooltip:SetPoint("TOPRIGHT", block, "TOPLEFT", -32, 1)
			end
			if block.module == KT_QUEST_TRACKER_MODULE or
					block.module == KT_CAMPAIGN_QUEST_TRACKER_MODULE then
				local questLink = GetQuestLink(block.id)
				if not questLink then
					return
				end
				GameTooltip:SetHyperlink(questLink)
				if db.tooltipShowRewards then
					KT.GameTooltip_AddQuestRewardsToTooltip(GameTooltip, block.id)
				end
				if IsInGroup() then
					GameTooltip:AddLine(" ")
					GameTooltip:SetQuestPartyProgress(block.id, true)
				end
			else
				GameTooltip:SetHyperlink(GetAchievementLink(block.id))
			end
			if db.tooltipShowID then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(" ", "ID: |cffffffff"..block.id)
			end
			GameTooltip:Show()
		end

		if block.fixedTag then
			colorStyle = KT_OBJECTIVE_TRACKER_COLOR["NormalHighlight"]
			block.fixedTag:SetBackdropColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.fixedTag.text:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
		end
	end)
	Default_SetFunctionChanged("OnBlockHeaderEnter", "KT_PROFESSION_RECIPE_TRACKER_MODULE")

	function KT_PROFESSION_RECIPE_TRACKER_MODULE:OnBlockHeaderEnter(block)
		KT_DEFAULT_OBJECTIVE_TRACKER_MODULE:OnBlockHeaderEnter(block)

		if db.tooltipShow then
			GameTooltip:SetOwner(block, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			if KTF.anchorLeft then
				GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 12, 1)
			else
				GameTooltip:SetPoint("TOPRIGHT", block, "TOPLEFT", -32, 1)
			end
			GameTooltip:SetRecipeResultItem(block.id)
			if db.tooltipShowID and not ArkInventory then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(" ", "ID: |cffffffff"..block.id)
			end
			GameTooltip:Show()
		end
	end

	if ArkInventory then
		hooksecurefunc(ArkInventory.API, "ReloadedTooltipReady", function(tooltip, fn, ...)
			if fn == "SetRecipeResultItem" then
				if db.tooltipShowID then
					local id = ...
					GameTooltip:AddLine(" ")
					GameTooltip:AddDoubleLine(" ", "ID: |cffffffff"..id)
					GameTooltip:Show()
				end
			end
		end)
	end

	hooksecurefunc(KT_DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderLeave", function(self, block)
		local colorStyle
		if block.module == KT_QUEST_TRACKER_MODULE or
				block.module == KT_CAMPAIGN_QUEST_TRACKER_MODULE then
			if block.questCompleted then
				colorStyle = KT_OBJECTIVE_TRACKER_COLOR["Complete"]
			elseif db.colorDifficulty then
				colorStyle = GetQuestDifficultyColor(block.level)
			end
		end
		if colorStyle then
			block.HeaderText:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.HeaderText.colorStyle = colorStyle
		end

		if db.tooltipShow then
			GameTooltip:Hide()
		end

		if block.fixedTag then
			colorStyle = KT_OBJECTIVE_TRACKER_COLOR["Normal"]
			block.fixedTag:SetBackdropColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.fixedTag.text:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
		end
	end)
	Default_SetFunctionChanged("OnBlockHeaderLeave")

	function KT_ObjectiveTrackerBlock_OnEnter(self)
		self.module:OnBlockHeaderEnter(self)
	end

	function KT_ObjectiveTrackerBlock_OnLeave(self)
		self.module:OnBlockHeaderLeave(self)
	end

	function KT_ObjectiveTrackerBlock_OnClick(self, mouseButton)
		self.module:OnBlockHeaderClick(self, mouseButton)
	end

	local bck_KT_ObjectiveTracker_AddBlock = KT_ObjectiveTracker_AddBlock
	KT_ObjectiveTracker_AddBlock = function(block)
		if block.module == KT_SCENARIO_CONTENT_TRACKER_MODULE then
			if block.currentBlock then
				if KT_BottomScenarioWidgetContainerBlock.height < 16.5 then
					block.height = block.contentsHeight - KT_BottomScenarioWidgetContainerBlock.height
					block:SetHeight(block.height)
				end
			end
		end
		local blockAdded = bck_KT_ObjectiveTracker_AddBlock(block)
		if blockAdded then
			if block.module == KT_BONUS_OBJECTIVE_TRACKER_MODULE or block.module == KT_WORLD_QUEST_TRACKER_MODULE then
				block:SetWidth(KT_OBJECTIVE_TRACKER_LINE_WIDTH + 4)
			end
		end
		return blockAdded
	end

	hooksecurefunc(KT_DEFAULT_OBJECTIVE_TRACKER_MODULE, "FreeUnusedLines", function(self, block)
		local colorStyle
		if block.questCompleted then
			colorStyle = KT_OBJECTIVE_TRACKER_COLOR["Complete"]
		elseif db.colorDifficulty and
				(self == KT_QUEST_TRACKER_MODULE or self == KT_CAMPAIGN_QUEST_TRACKER_MODULE) then
			colorStyle = GetQuestDifficultyColor(block.level)
		end
		if colorStyle then
			block.HeaderText:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.HeaderText.colorStyle = colorStyle
		end
	end)
	Default_SetFunctionChanged("FreeUnusedLines")

	local function AddFixedTag(block, tag, buttonOffsetsTag)
		if block.rightButton == tag then
			return
		end

		tag:ClearAllPoints()

		if block.rightButton then
			tag:SetPoint("RIGHT", block.rightButton, "LEFT", -KT_ObjectiveTracker_GetPaddingBetweenButtons(block), 0)
		else
			tag:SetPoint("TOPRIGHT", block, KT_ObjectiveTracker_GetButtonOffsets(block, buttonOffsetsTag))
		end

		tag:Show()

		block.rightButton = tag
		block.lineWidth = block.lineWidth - tag:GetWidth() - KT_ObjectiveTracker_GetPaddingBetweenButtons(block)
	end

	local function CreateFixedTag(block, x, y, anchor)
		local tag = block.fixedTag
		if not tag then
			local numFreeButtons = #freeTags
			if numFreeButtons > 0 then
				tag = freeTags[numFreeButtons]
				tremove(freeTags, numFreeButtons)
				tag:SetParent(block)
				tag:ClearAllPoints()
			else
				tag = CreateFrame("Frame", nil, block, "BackdropTemplate")
				tag:SetSize(32, 32)
				tag:SetBackdrop({ bgFile = mediaPath.."UI-KT-QuestItemTag" })
				tag.text = tag:CreateFontString(nil, "ARTWORK", "GameFontNormalMed1")
				tag.text:SetFont(LSM:Fetch("font", "Arial Narrow"), 13, "")
				tag.text:SetPoint("CENTER", -0.5, 1)
			end
			if not anchor then
				AddFixedTag(block, tag, "useItem")
			else
				tag:SetPoint(anchor, block, x, y)
				tag:Show()
			end
			block.fixedTag = tag
		end

		local colorStyle = KT_OBJECTIVE_TRACKER_COLOR["Normal"]
		if block.isHighlighted and colorStyle.reverse then
			colorStyle = colorStyle.reverse
		end
		tag:SetBackdropColor(colorStyle.r, colorStyle.g, colorStyle.b)
		tag.text:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
	end

	local function CreateFixedButton(block, isSpell)
		local questID = block.id
		local button = KT:GetFixedButton(questID)
		if not button then
			if InCombatLockdown() then
				_DBG(" - STOP Create button")
				combatLockdown = true
				return nil
			end

			local numFreeButtons = #freeButtons
			if numFreeButtons > 0 then
				_DBG(" - USE button "..questID)
				button = freeButtons[numFreeButtons]
				tremove(freeButtons, numFreeButtons)
			else
				_DBG(" - CREATE button "..questID)
				local name = addonName.."Button"..time()..questID
				button = CreateFrame("Button", name, KTF.Buttons, "SecureActionButtonTemplate")		--"KTQuestObjectiveItemButtonTemplate"
				button:SetSize(26, 26)

				button.icon = button:CreateTexture(name.."Icon", "BORDER")
				button.icon:SetAllPoints()
                button.Icon = button.icon   -- for Spell

				button.Count = button:CreateFontString(name.."Count", "BORDER", "NumberFontNormal")
				button.Count:SetJustifyH("RIGHT")
				button.Count:SetPoint("BOTTOMRIGHT", button.icon, 0, 2)

				button.Cooldown = CreateFrame("Cooldown", name.."Cooldown", button, "CooldownFrameTemplate")
				button.Cooldown:SetAllPoints()

				button.HotKey = button:CreateFontString(name.."HotKey", "ARTWORK", "NumberFontNormalSmallGray")
				button.HotKey:SetSize(29, 10)
				button.HotKey:SetJustifyH("RIGHT")
				button.HotKey:SetText(RANGE_INDICATOR)
				button.HotKey:SetPoint("TOPRIGHT", button.icon, 2, -2)

				button.text = button:CreateFontString(name.."Text", "ARTWORK", "NumberFontNormal")
				button.text:SetSize(29, 10)
				button.text:SetJustifyH("LEFT")
				button.text:SetPoint("TOPLEFT", button.icon, 1, -3)

				button:RegisterForClicks("AnyDown", "AnyUp")  -- TODO: Change it in 10.0.2

				button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
				do local tex = button:GetNormalTexture()
					tex:ClearAllPoints()
					tex:SetPoint("CENTER")
					tex:SetSize(44, 44)
				end
				button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
				button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
				button:SetFrameLevel(KTF:GetFrameLevel() + 1)
				button:Hide()	-- Cooldown init

				KT:Masque_AddButton(button)
            end
            if not isSpell then
				button:SetScript("OnEvent", KT_QuestObjectiveItem_OnEvent)
				button:SetScript("OnUpdate", KT_QuestObjectiveItem_OnUpdate)
				button:SetScript("OnShow", KT_QuestObjectiveItem_OnShow)
				button:SetScript("OnHide", KT_QuestObjectiveItem_OnHide)
				button:SetScript("OnEnter", KT_QuestObjectiveItem_OnEnter)
				button:SetScript("OnLeave", QuestObjectiveItem_OnLeave)
			else
				button.HotKey:Hide()
				button:SetScript("OnEvent", nil)
				button:SetScript("OnUpdate", nil)
				button:SetScript("OnShow", nil)
				button:SetScript("OnHide", nil)
				button:SetScript("OnEnter", KT_ScenarioSpellButton_OnEnter)
				button:SetScript("OnLeave", GameTooltip_Hide)
			end
            button:SetAttribute("type", isSpell and "spell" or "item")
			button:Show()
			KT.fixedButtons[questID] = button
			KTF.Buttons.reanchor = true
		end
		button.block = block
		button:SetAlpha(1)
		return button
	end

	local function QuestItemButton_Add(block, x, y)
		local questLogIndex = C_QuestLog.GetLogIndexForQuestID(block.id)
		if not questLogIndex then return end

		local link, item, charges, showItemWhenComplete = KT.GetQuestLogSpecialItemInfo(questLogIndex)
		if item and (not block.questCompleted or showItemWhenComplete) then
			block.itemButton:Hide()
			block.rightButton = block.groupFinderButton
			CreateFixedTag(block, x, y)
			local button = CreateFixedButton(block)
			if not InCombatLockdown() then
				button:SetID(questLogIndex)
				button.charges = charges
				button.rangeTimer = -1
				button.item = item
				button.link = link
				SetItemButtonTexture(button, item)
				SetItemButtonCount(button, charges)
				KT_QuestObjectiveItem_UpdateCooldown(button)
				button:SetAttribute("item", link)

				if db.qiActiveButton and KTF.ActiveButton.questID == block.id then
					KT.ActiveButton:Update(block.id)
				end
			end
		else
			KT:RemoveFixedButton(block)
		end
	end

	hooksecurefunc(KT_DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(self, block, text)
		block.lineWidth = block.lineWidth or self.lineWidth - 8		-- mod default
	end)
	Default_SetFunctionChanged("SetBlockHeader", "KT_QUEST_TRACKER_MODULE")

	local bck_KT_QUEST_TRACKER_MODULE_SetBlockHeader = KT_QUEST_TRACKER_MODULE.SetBlockHeader
	function KT_QUEST_TRACKER_MODULE:SetBlockHeader(block, text, questLogIndex, isQuestComplete, questID)
		local questInfo = questLogIndex and C_QuestLog.GetInfo(questLogIndex) or {}
		if db.questShowTags then
			local tagInfo = KT.GetQuestTagInfo(questID)
			text = KT:CreateQuestTag(questInfo.level, tagInfo.tagID, questInfo.frequency, questInfo.suggestedGroup)..text
		end
		bck_KT_QUEST_TRACKER_MODULE_SetBlockHeader(self, block, text, questLogIndex, isQuestComplete, questID)
		block.lineWidth = block.lineWidth or self.lineWidth - 8		-- mod default
		block.level = questInfo.level
		block.title = text
		block.questCompleted = isQuestComplete

		QuestItemButton_Add(block, 3, 4)

		local questsCache = dbChar.quests.cache
		if db.questShowZones and questsCache[questID] then
			local infoText = questsCache[questID].zone
			if questsCache[questID].isCalling then
				local timeRemaining = GetTaskTimeLeftData(questID)
				if timeRemaining ~= "" then
					infoText = infoText.." - "..timeRemaining
				end
			end
			self:AddObjective(block, "Zone", infoText, nil, nil, KT_OBJECTIVE_DASH_STYLE_HIDE, KT_OBJECTIVE_TRACKER_COLOR["Zone"])
		end
	end

	function KT_QUEST_TRACKER_MODULE:OnFreeBlock(block)  -- R
		KT:RemoveFixedButton(block)
		if block.blockTemplate == "KT2_ObjectiveTrackerBlockTemplate" then
			KT_QuestObjectiveReleaseBlockButton_Item(block);
			KT_QuestObjectiveReleaseBlockButton_FindGroup(block);

			block.timerLine	= nil;
			block.questCompleted = nil;
			RemoveBlockIcon(block)
		else
			KT_AutoQuestPopupTracker_OnFreeBlock(block);
		end
	end
	KT_CAMPAIGN_QUEST_TRACKER_MODULE.OnFreeBlock = KT_QUEST_TRACKER_MODULE.OnFreeBlock

	hooksecurefunc(KT_QUEST_TRACKER_MODULE, "UpdatePOISingle", function(self, quest)
		if quest:IsCalling() then
			local questID = quest:GetID()
			local block = self:GetExistingBlock(questID)
			if block then
				local covenantData = C_Covenants.GetCovenantData(C_Covenants.GetActiveCovenantID())
				if covenantData then
					local covenantIcon = GetBlockIcon(block)
					covenantIcon.Icon:SetAtlas("shadowlands-landingbutton-"..covenantData.textureKit.."-up")
				end
			end
		end
	end)
	KT_CAMPAIGN_QUEST_TRACKER_MODULE.UpdatePOISingle = KT_QUEST_TRACKER_MODULE.UpdatePOISingle

	hooksecurefunc(KT_WORLD_QUEST_TRACKER_MODULE, "Update", function(self)
		local block, questID
		local tasksTable = GetTasksTable()
		for i = 1, #tasksTable do
			questID = tasksTable[i]
			if KT.activeTasks[questID] and QuestUtils_IsQuestWorldQuest(questID) and not QuestUtils_IsQuestWatched(questID) then
				block = self:GetExistingBlock(questID)
				if block then
					block.TrackedQuest:SetPoint("TOPLEFT", -2, 0)
					QuestItemButton_Add(block, 0, 2)
				end
			end
		end
		for i = 1, C_QuestLog.GetNumWorldQuestWatches() do
			questID = C_QuestLog.GetQuestIDForWorldQuestWatchIndex(i)
			if questID then
				block = self:GetExistingBlock(questID)
				if block then
					block.TrackedQuest:SetPoint("TOPLEFT", -2, 0)
					QuestItemButton_Add(block, 0, 2)
				end
			end
		end
	end)

	local bck_KT_WORLD_QUEST_TRACKER_MODULE_OnFreeBlock = KT_WORLD_QUEST_TRACKER_MODULE.OnFreeBlock
	function KT_WORLD_QUEST_TRACKER_MODULE:OnFreeBlock(block)
		if KT.activeTasks[block.id] then
			KT.activeTasks[block.id] = nil
		end
		KT:RemoveFixedButton(block)
		bck_KT_WORLD_QUEST_TRACKER_MODULE_OnFreeBlock(self, block)
    end

    local bck_KT_BONUS_OBJECTIVE_TRACKER_MODULE_OnFreeBlock = KT_BONUS_OBJECTIVE_TRACKER_MODULE.OnFreeBlock
    function KT_BONUS_OBJECTIVE_TRACKER_MODULE:OnFreeBlock(block)
        if KT.activeTasks[block.id] then
            KT.activeTasks[block.id] = nil
        end
        KT:RemoveFixedButton(block)
        bck_KT_BONUS_OBJECTIVE_TRACKER_MODULE_OnFreeBlock(self, block)
    end

	hooksecurefunc("KT_BonusObjectiveTracker_UntrackWorldQuest", function(questID)
		local block = KT_WORLD_QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if block then
			KT_BonusObjectiveTracker_OnBlockAnimOutFinished(block.ScrollContents)
		end
		KT:ToggleEmptyTracker(not KT.IsTableEmpty(KT.activeTasks))
	end)

	local function SetProgressBarStyle(progressBar)
		if not progressBar.KTskinned or KT.forcedUpdate then
			local block = progressBar.block
			block.height = block.height - progressBar.height

			progressBar:SetSize(232, 23)
			progressBar.height = 23
			--_C(progressBar, { r = 0, g = 1, b = 0 })

			progressBar.Bar:SetSize(208, 13)
			progressBar.Bar:EnableMouse(false)
			progressBar.Bar:ClearAllPoints()

			if progressBar.Bar.BarFrame then
				-- World Quest
				progressBar.Bar:SetPoint("LEFT", 22, 0)
				progressBar.Bar.BarFrame:Hide()
				progressBar.Bar.BarFrame2:Hide()
				progressBar.Bar.BarFrame3:Hide()
				progressBar.Bar.BarGlow:Hide()
				progressBar.Bar.Sheen:Hide()
				progressBar.Bar.Starburst:Hide()
			else
				-- Default
				progressBar.Bar:SetPoint("LEFT", 2, 0)
				progressBar.Bar.BorderLeft:Hide()
				progressBar.Bar.BorderRight:Hide()
				progressBar.Bar.BorderMid:Hide()
			end

			local border1 = progressBar.Bar:CreateTexture(nil, "BACKGROUND", nil, -2)
			border1:SetPoint("TOPLEFT", -1, 1)
			border1:SetPoint("BOTTOMRIGHT", 1, -1)
			border1:SetColorTexture(0, 0, 0)

			local border2 = progressBar.Bar:CreateTexture(nil, "BACKGROUND", nil, -3)
			border2:SetPoint("TOPLEFT", -2, 2)
			border2:SetPoint("BOTTOMRIGHT", 2, -2)
			border2:SetColorTexture(0.4, 0.4, 0.4)

			progressBar.Bar.Label:SetPoint("CENTER", 0, 0.5)
			progressBar.Bar.Label:SetFont(LSM:Fetch("font", "Arial Narrow"), 13, "")
			progressBar.Bar:SetStatusBarTexture(LSM:Fetch("statusbar", db.progressBar))
			progressBar.KTskinned = true
			progressBar.isSkinned = true	-- ElvUI hack

			block.height = block.height + progressBar.height
		end
	end

	local bck_KT_DEFAULT_OBJECTIVE_TRACKER_MODULE_AddProgressBar = KT_DEFAULT_OBJECTIVE_TRACKER_MODULE.AddProgressBar
	function KT_DEFAULT_OBJECTIVE_TRACKER_MODULE:AddProgressBar(block, line, questID)
		local progressBar = bck_KT_DEFAULT_OBJECTIVE_TRACKER_MODULE_AddProgressBar(self, block, line, questID)
		SetProgressBarStyle(progressBar)
		return progressBar
	end
	Default_SetFunctionChanged("AddProgressBar", "KT_SCENARIO_TRACKER_MODULE", "KT_BONUS_OBJECTIVE_TRACKER_MODULE", "KT_WORLD_QUEST_TRACKER_MODULE")

	local bck_KT_BONUS_OBJECTIVE_TRACKER_MODULE_AddProgressBar = KT_BONUS_OBJECTIVE_TRACKER_MODULE.AddProgressBar
	function KT_BONUS_OBJECTIVE_TRACKER_MODULE:AddProgressBar(block, line, questID, finished)
		local progressBar = bck_KT_BONUS_OBJECTIVE_TRACKER_MODULE_AddProgressBar(self, block, line, questID, finished)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	local bck_KT_WORLD_QUEST_TRACKER_MODULE_AddProgressBar = KT_WORLD_QUEST_TRACKER_MODULE.AddProgressBar
	function KT_WORLD_QUEST_TRACKER_MODULE:AddProgressBar(block, line, questID, finished)
		local progressBar = bck_KT_WORLD_QUEST_TRACKER_MODULE_AddProgressBar(self, block, line, questID, finished)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	KT_BonusObjectiveTrackerProgressBar_UpdateReward = function(progressBar)
		progressBar.Bar.Icon:Hide()
		progressBar.Bar.IconBG:Hide()
		progressBar.needsReward = nil
	end

	hooksecurefunc("KT_BonusObjectiveTracker_OnTaskCompleted", function(questID, xp, money)
		if KT.activeTasks[questID] then
			KT.activeTasks[questID] = nil
		end
	end)

	function KT_BonusObjectiveTracker_ShowRewardsTooltip(block)  -- R
		if db.tooltipShow then
			local questID
			if block.id < 0 then
				-- this is a scenario bonus objective
				questID = C_Scenario.GetBonusStepRewardQuestID(-block.id)
				if questID == 0 then
					-- huh, no reward
					return
				end
			else
				questID = block.id
			end
			local questLink = GetQuestLink(questID)
			if not questLink then
				return
			end

			GameTooltip:SetOwner(block, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			if KTF.anchorLeft then
				GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 12, -1)
			else
				GameTooltip:SetPoint("TOPRIGHT", block, "TOPLEFT", -12, -1)
			end

			if not HaveQuestRewardData(questID) then
				GameTooltip:AddLine(RETRIEVING_DATA, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
				GameTooltip_SetTooltipWaitingForData(GameTooltip, true);
			else
				GameTooltip:SetHyperlink(questLink)
				if db.tooltipShowRewards then
					KT.GameTooltip_AddQuestRewardsToTooltip(GameTooltip, questID, true)
					GameTooltip_SetTooltipWaitingForData(GameTooltip, false);
				end
				if db.tooltipShowID then
					GameTooltip:AddLine(" ")
					GameTooltip:AddDoubleLine(" ", "ID: |cffffffff"..questID)
				end
			end
			GameTooltip:Show()
			block.module.tooltipBlock = block
		end
	end

	local bck_KT_SCENARIO_CONTENT_TRACKER_MODULE_Update = KT_SCENARIO_CONTENT_TRACKER_MODULE.Update
	function KT_SCENARIO_CONTENT_TRACKER_MODULE:Update()
		local _, _, numStages, _ = C_Scenario.GetInfo()
		local BlocksFrame = KT_SCENARIO_TRACKER_MODULE.BlocksFrame
		self.topBlock = nil
		self.lastBlock = nil
		bck_KT_SCENARIO_CONTENT_TRACKER_MODULE_Update(self)
		if numStages > 0 and BlocksFrame.currentBlock then
			self.lastBlock = KT_ScenarioBlocksFrame
		end
	end

	local bck_KT_SCENARIO_TRACKER_MODULE_AddProgressBar = KT_SCENARIO_TRACKER_MODULE.AddProgressBar
	function KT_SCENARIO_TRACKER_MODULE:AddProgressBar(block, line, criteriaIndex)
		local progressBar = bck_KT_SCENARIO_TRACKER_MODULE_AddProgressBar(self, block, line, criteriaIndex)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	hooksecurefunc("KT_ObjectiveTracker_OnSlideBlockUpdate", function(block, elapsed)
		local slideData = block.slideData
		if block.slideTime >= slideData.duration + (slideData.endDelay or 0) then
			KT_ObjectiveTracker_Update()	-- update after expand collapsed tracker
		end
	end)

	hooksecurefunc(KT_SCENARIO_CONTENT_TRACKER_MODULE, "AddSpells", function(self, objectiveBlock, spellInfo)
		for i = 1, objectiveBlock.numSpells do
			local block = objectiveBlock.spells[i]
			block.id = spellInfo[i].spellID
			block.SpellButton:Hide()
			CreateFixedTag(block, 17, -1, "TOPLEFT")
			local button = CreateFixedButton(block, true)
			if not InCombatLockdown() then
				button.spellID = spellInfo[i].spellID
				button.Icon:SetTexture(spellInfo[i].spellIcon)
				button:SetAttribute("spell", spellInfo[i].spellID)

				if db.qiActiveButton and KTF.ActiveButton.questID == block.id then
					KT.ActiveButton:Update(block.id)
				end
			end
		end
		for i = objectiveBlock.numSpells + 1, #objectiveBlock.spells do
			KT:RemoveFixedButton(objectiveBlock.spells[i])
		end
	end)

	KT_ScenarioStageBlock:HookScript("OnEnter", function(self)
		GameTooltip:ClearAllPoints()
		if KTF.anchorLeft then
			GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 59, -1)
		else
			GameTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT",  -16, -1)
		end
	end)

	local function AutoQuestPopupTracker_ShouldDisplayQuest(questID, owningModule)
		return not C_QuestLog.IsQuestBounty(questID) and owningModule:ShouldDisplayQuest(QuestCache:Get(questID));
	end

	hooksecurefunc("KT_AutoQuestPopupTracker_Update", function(owningModule)
		if SplashFrame:IsShown() then return end
		if not owningModule.KTpopupSkinned then
			owningModule:AddBlockOffset("KT_AutoQuestPopUpBlockTemplate", -25, -4)
			owningModule.KTpopupSkinned = true
		end
		for i = 1, GetNumAutoQuestPopUps() do
			local questID, popUpType = GetAutoQuestPopUp(i)
			if AutoQuestPopupTracker_ShouldDisplayQuest(questID, owningModule) then
				local questTitle = C_QuestLog.GetTitleForQuestID(questID)
				if questTitle and questTitle ~= "" then
					local block = owningModule.usedBlocks["KT_AutoQuestPopUpBlockTemplate"][questID]
					local blockContents = block.ScrollChild
					blockContents.QuestName:SetFont(KT.font, 14, "")
					blockContents.BottomText:SetPoint("BOTTOM", 0, 7)
				end
			end
		end
	end)

	hooksecurefunc("KT_ObjectiveTracker_Collapse", function()
		_DBG("COLLAPSE")
		dbChar.collapsed = OTF.collapsed
		KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.25)
		MSA_CloseDropDownMenus()
		MawBuffs.List:Hide()
	end)

	hooksecurefunc("KT_ObjectiveTracker_Expand", function()
		_DBG("EXPAND")
        KT_ForceHideTracker(false)
		dbChar.collapsed = OTF.collapsed
		KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.25, 0.5)
		MSA_CloseDropDownMenus()
	end)

	local bck_KT_BonusObjectiveTracker_OnBlockAnimOutFinished = KT_BonusObjectiveTracker_OnBlockAnimOutFinished
	KT_BonusObjectiveTracker_OnBlockAnimOutFinished = function(self)
		local block = self:GetParent()
		KT.activeTasks[block.id] = nil
		bck_KT_BonusObjectiveTracker_OnBlockAnimOutFinished(self)
	end

	hooksecurefunc("KT_BonusObjectiveTracker_SetBlockState", function(block, state, force)
		if state == "ENTERING" then
			_DBG(" - "..state)
			KT.activeTasks[block.id] = true
			KT:ToggleEmptyTracker(true)
		elseif state == "PRESENT" and not KT.activeTasks[block.id] then
			_DBG(" - "..state)
			KT.activeTasks[block.id] = true
			if not QuestUtils_IsQuestWatched(block.id) then
				KT:ToggleEmptyTracker(KT.initialized)
			end
		elseif state == "LEAVING" and KT.activeTasks[block.id] then
			_DBG(" - "..state)
			KT:RemoveFixedButton(block)
			if dbChar.collapsed then
				KT_BonusObjectiveTracker_OnBlockAnimOutFinished(block.ScrollContents)
			end
		end
	end)

	local bck_KT_ObjectiveTracker_ReorderModules = KT_ObjectiveTracker_ReorderModules
	KT_ObjectiveTracker_ReorderModules = function()
		local reorder = false
		for i = 1, #OTF.MODULES do
			if OTF.MODULES[i] ~= OTF.MODULES_UI_ORDER[i] then
				reorder = true
				break
			end
		end
		if reorder then
			bck_KT_ObjectiveTracker_ReorderModules()
		end
	end

	-- Item handler functions
	function KT_QuestObjectiveItem_OnEnter(self)  -- R
		self.block.module:OnBlockHeaderEnter(self.block)
		if KTF.anchorLeft then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 3)
		else
			GameTooltip:SetOwner(self, "ANCHOR_LEFT", -3)
		end
		GameTooltip:SetQuestLogSpecialItem(self:GetID())
	end

	function QuestObjectiveItem_OnLeave(self)
		self.block.module:OnBlockHeaderLeave(self.block)
		GameTooltip:Hide()
	end

	function KT_QuestObjectiveItem_OnUpdate(self, elapsed)  -- R
		local rangeTimer = self.rangeTimer
		if rangeTimer then
			rangeTimer = rangeTimer - elapsed
			if rangeTimer <= 0 then
				local link, item, charges, showItemWhenComplete = KT.GetQuestLogSpecialItemInfo(self:GetID())
				if charges and charges ~= self.charges then
					KT_ObjectiveTracker_Update(KT_OBJECTIVE_TRACKER_UPDATE_MODULE_QUEST)
					return
				end
				local hotkey = self.HotKey
				local valid = IsQuestLogSpecialItemInRange(self:GetID())
				if hotkey:GetText() == RANGE_INDICATOR then
					if valid == 0 then
						hotkey:Show()
						hotkey:SetVertexColor(1.0, 0.1, 0.1)
					elseif valid == 1 then
						hotkey:Show()
						hotkey:SetVertexColor(0.6, 0.6, 0.6)
					else
						hotkey:Hide()
					end
				else
					if valid == 0 then
						hotkey:SetVertexColor(1.0, 0.1, 0.1)
					else
						hotkey:SetVertexColor(0.6, 0.6, 0.6)
					end
				end
				rangeTimer = TOOLTIP_UPDATE_TIME
			end
			self.rangeTimer = rangeTimer
		end

		if db.qiActiveButton and not InCombatLockdown() and self.block then
			if KT.ActiveButton.timerID then
				if KT.ActiveButton.timerID ~= self.block.id then
					return
				end
			else
				KT.ActiveButton.timerID = self.block.id
			end
			if KT.ActiveButton.timer > 50 then
				KT.ActiveButton:Update()
			else
				--_DBG("... "..KT.ActiveButton.timer.." ... "..self.block.id)
				KT.ActiveButton.timer = KT.ActiveButton.timer + TOOLTIP_UPDATE_TIME
			end
		end
	end

	-- GossipFrame.lua
	hooksecurefunc(GossipFrame, "HandleShow", function(self, textureKit)
		local gossipQuests = C_GossipInfo.GetAvailableQuests()
		for _, questInfo in ipairs(gossipQuests) do
			QuestsCache_UpdateProperty(questInfo.questID, "startMapID", KT.GetCurrentMapAreaID())
		end
	end)

	-- QuestFrame.lua
	QuestFrame:HookScript("OnShow", function(self)
		local questID = GetQuestID()
		QuestsCache_UpdateProperty(questID, "startMapID", KT.GetCurrentMapAreaID())
	end)

	-- QuestMapFrame.lua
    --[[ --abyui
	function QuestMapFrame_OpenToQuestDetails(questID)  -- R
		local mapID = GetQuestUiMapID(questID);
		if ( mapID == 0 ) then mapID = nil; end
		OpenQuestLog(mapID);  -- fix Blizz bug
		QuestMapFrame_ShowQuestDetails(questID);
	end
    --]]

	-- QuestPOI.lua
	local bck_QuestPOI_GetButton = QuestPOI_GetButton
	QuestPOI_GetButton = function(parent, questID, style, index)
		local poiButton = bck_QuestPOI_GetButton(parent, questID, style, index)
		if poiButton then
			poiButton.Glow.SetShown = function() end
		end
		return poiButton
	end

	-- QuestUtils.lua
	function QuestUtils_AddQuestCurrencyRewardsToTooltip(questID, tooltip, currencyContainerTooltip)  -- RO
		local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID);
		local currencies = { };
		local uniqueCurrencyIDs = { };
		for i = 1, numQuestCurrencies do
			local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i, questID);
			local rarity = C_CurrencyInfo.GetCurrencyInfo(currencyID).quality;
			local firstInstance = not uniqueCurrencyIDs[currencyID];
			if firstInstance then
				uniqueCurrencyIDs[currencyID] = true;
			end
			local currencyInfo = { name = name, texture = texture, numItems = numItems, currencyID = currencyID, rarity = rarity, firstInstance = firstInstance };
			if(currencyID ~= ECHOS_OF_NYLOTHA_CURRENCY_ID or numQuestCurrencies == 1) then
				tinsert(currencies, currencyInfo);
			end
		end

		table.sort(currencies,
			function(currency1, currency2)
				if currency1.rarity ~= currency2.rarity then
					return currency1.rarity > currency2.rarity;
				end
				return currency1.currencyID > currency2.currencyID;
			end
		);

		local addedQuestCurrencies = 0;
		local alreadyUsedCurrencyContainerId = 0; --In the case of multiple currency containers needing to displayed, we only display the first.
		local warModeBonus = C_PvP.GetWarModeRewardBonus();

		for i, currencyInfo in ipairs(currencies) do
			local isCurrencyContainer = C_CurrencyInfo.IsCurrencyContainer(currencyInfo.currencyID, currencyInfo.numItems);
			if ( currencyContainerTooltip and isCurrencyContainer and (alreadyUsedCurrencyContainerId == 0) ) then
				if ( EmbeddedItemTooltip_SetCurrencyByID(currencyContainerTooltip, currencyInfo.currencyID, currencyInfo.numItems) ) then
					if ShouldShowWarModeBonus(questID, currencyInfo.currencyID, currencyInfo.firstInstance) then
						currencyContainerTooltip.Tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_FORMAT:format(warModeBonus));
						currencyContainerTooltip.Tooltip:Show();
					end

					if ( not tooltip ) then
						break;
					end

					addedQuestCurrencies = addedQuestCurrencies + 1;
					alreadyUsedCurrencyContainerId = currencyInfo.currencyID;
				end
			elseif ( tooltip ) then
				if( alreadyUsedCurrencyContainerId ~= currencyInfo.currencyID ) then --if there's already a currency container of this same type skip it entirely
					local text, color
					if currencyInfo.currencyID == 1553 then	-- Azerite
						text = format(BONUS_OBJECTIVE_ARTIFACT_XP_FORMAT, FormatLargeNumber(currencyInfo.numItems))
						color = { r = 1, g = 1, b = 1 }
					else
						text = BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format(currencyInfo.texture, currencyInfo.numItems, currencyInfo.name)
						color = GetColorForCurrencyReward(currencyInfo.currencyID, currencyInfo.numItems)
					end
					tooltip:AddLine(text, color.r, color.g, color.b)

					if ShouldShowWarModeBonus(questID, currencyInfo.currencyID, currencyInfo.firstInstance) then
						tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_FORMAT:format(warModeBonus));
					end

					addedQuestCurrencies = addedQuestCurrencies + 1;
				end
			end
		end
		return addedQuestCurrencies, alreadyUsedCurrencyContainerId > 0;
	end

	hooksecurefunc(QuestUtil, "SetupWorldQuestButton", function(button, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget, isEffectivelyTracked)
        button.Glow:SetShown(false)
    end)

	-- UIErrorsFrame.lua
	local bck_UIErrorsFrame_OnEvent = UIErrorsFrame:GetScript("OnEvent")
	UIErrorsFrame:SetScript("OnEvent", function(self, event, ...)
		if db.messageQuest and event == "UI_INFO_MESSAGE" then
			local _, text = ...
			for _, patt in ipairs(msgPatterns) do
				if strfind(text, patt) then
					KT:SetMessage(text, 1, 1, 0, nil, "Interface\\GossipFrame\\AvailableQuestIcon", -2, 0)
					return
				end
			end
		end
		bck_UIErrorsFrame_OnEvent(self, event, ...)
	end)

	-- DropDown
	function KT_ObjectiveTracker_ToggleDropDown(frame, handlerFunc)  -- R
		local dropDown = KT.DropDown;
		if ( dropDown.activeFrame ~= frame ) then
			MSA_CloseDropDownMenus();
		end
		dropDown.activeFrame = frame;
		dropDown.initialize = handlerFunc;
		MSA_ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3, nil, nil, MSA_DROPDOWNMENU_SHOW_TIME);
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

    local function AbyQuestLogPopupDetailFrame_Show(questLogIndex)

    	local questID = C_QuestLog.GetInfo(questLogIndex).questID;
    	if ( QuestLogPopupDetailFrame.questID == questID and QuestLogPopupDetailFrame:IsShown() ) then
            QuestLogPopupDetailFrame:Hide(); --abyui
    		return;
    	end

    	QuestLogPopupDetailFrame.questID = questID;

        C_QuestLog.SetSelectedQuest(questID)
    	StaticPopup_Hide("ABANDON_QUEST");
    	StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS");
        C_QuestLog.SetAbandonQuest();

    	QuestMapFrame_UpdateQuestDetailsButtons();

    	QuestLogPopupDetailFrame_Update(true);
        --abyui
        if InCombatLockdown() then
            QuestLogPopupDetailFrame:Show()
        else
            ShowUIPanel(QuestLogPopupDetailFrame);
        end
    	PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);

    	-- portrait
    	local questPortrait, questPortraitText, questPortraitName, questPortraitMount = GetQuestLogPortraitGiver();
    	if (questPortrait and questPortrait ~= 0 and QuestLogShouldShowPortrait()) then
    		QuestFrame_ShowQuestPortrait(QuestLogPopupDetailFrame, questPortrait, questPortraitMount, questPortraitText, questPortraitName, -3, -42);
    	else
    		QuestFrame_HideQuestPortrait();
    	end
    end

	function KT_QUEST_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)  -- R
		if ( ChatEdit_TryInsertQuestLinkForQuestID(block.id) ) then
			return;
		end

		if ( mouseButton ~= "RightButton" ) then
			if ( IsModifiedClick("QUESTWATCHTOGGLE") ) then
				KT_QuestObjectiveTracker_UntrackQuest(nil, block.id);
			elseif IsModifiedClick(db.menuWowheadURLModifier) then
				KT:Alert_WowheadURL("quest", block.id)
			else
				local quest = QuestCache:Get(block.id);
				if quest.isAutoComplete and quest:IsComplete() then
					KT_AutoQuestPopupTracker_RemovePopUp(block.id);
					ShowQuestComplete(block.id);
				else
					if db.questDefaultActionMap then
                        if InCombatLockdown() and not WorldMapFrame:IsShown() then WorldMapFrame:Show() end
						QuestMapFrame_OpenToQuestDetails(block.id);
					else
						local questLogIndex = C_QuestLog.GetLogIndexForQuestID(block.id);
                        AbyQuestLogPopupDetailFrame_Show(questLogIndex);
					end
				end
			end
			return;
		else
			KT_ObjectiveTracker_ToggleDropDown(block, KT_QuestObjectiveTracker_OnOpenDropDown);
		end
	end
	KT_CAMPAIGN_QUEST_TRACKER_MODULE.OnBlockHeaderClick = KT_QUEST_TRACKER_MODULE.OnBlockHeaderClick

	function KT_QuestObjectiveTracker_OnOpenDropDown(self)  -- R
		local block = self.activeFrame;

		local info = MSA_DropDownMenu_CreateInfo();
		info.text = C_QuestLog.GetTitleForQuestID(block.id);
		info.isTitle = 1;
		info.notCheckable = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info = MSA_DropDownMenu_CreateInfo();
		info.notCheckable = 1;

		info.text = OBJECTIVES_VIEW_IN_QUESTLOG;
		info.func = KT_QuestObjectiveTracker_OpenQuestDetails;
		info.arg1 = block.id;
		info.noClickSound = 1;
		info.checked = false;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.text = OBJECTIVES_SHOW_QUEST_MAP;
		info.func = KT_QuestObjectiveTracker_OpenQuestMap;
		info.arg1 = block.id;
		info.checked = false;
		info.noClickSound = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		if ( C_QuestLog.IsPushableQuest(block.id) and IsInGroup() ) then
			info.text = SHARE_QUEST;
			info.func = KT_QuestObjectiveTracker_ShareQuest;
			info.arg1 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end

		info.text = OBJECTIVES_STOP_TRACKING;
		info.func = KT_QuestObjectiveTracker_UntrackQuest;
		info.arg1 = block.id;
		info.checked = false;
		info.disabled = (db.filterAuto[1]);
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.disabled = false;

		if C_QuestLog.CanAbandonQuest(block.id) then
			info.text = ABANDON_QUEST;
			info.func = function(_, questID) QuestMapQuestOptions_AbandonQuest(questID) end;
			info.arg1 = block.id;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWNMENU_MENU_LEVEL);
		end

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.Alert_WowheadURL;
			info.arg1 = "quest";
			info.arg2 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	function KT_ACHIEVEMENT_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)  -- R
		if ( IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() ) then
			local achievementLink = GetAchievementLink(block.id);
			if ( achievementLink ) then
				ChatEdit_InsertLink(achievementLink);
			end
		elseif ( mouseButton ~= "RightButton" ) then
			if ( not AchievementFrame ) then
				AchievementFrame_LoadUI();
			end
			if ( IsModifiedClick("QUESTWATCHTOGGLE") ) then
				KT_AchievementObjectiveTracker_UntrackAchievement(_, block.id);
			elseif IsModifiedClick(db.menuWowheadURLModifier) then
				KT:Alert_WowheadURL("achievement", block.id)
			elseif ( not AchievementFrame:IsShown() ) then
				AchievementFrame_ToggleAchievementFrame();
				AchievementFrame_SelectAchievement(block.id);
			else
				if ( AchievementFrameAchievements.selection ~= block.id ) then
					AchievementFrame_SelectAchievement(block.id);
				else
					AchievementFrame_ToggleAchievementFrame();
				end
			end
		else
			KT_ObjectiveTracker_ToggleDropDown(block, KT_AchievementObjectiveTracker_OnOpenDropDown);
		end
	end

	function KT_AchievementObjectiveTracker_OnOpenDropDown(self)  -- R
		local block = self.activeFrame;
		local _, achievementName, _, completed, _, _, _, _, _, icon = GetAchievementInfo(block.id);

		local info = MSA_DropDownMenu_CreateInfo();
		info.text = achievementName;
		info.isTitle = 1;
		info.notCheckable = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info = MSA_DropDownMenu_CreateInfo();
		info.notCheckable = 1;

		info.text = OBJECTIVES_VIEW_ACHIEVEMENT;
		info.func = function (button, ...) OpenAchievementFrameToAchievement(...); end;
		info.arg1 = block.id;
		info.checked = false;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.text = OBJECTIVES_STOP_TRACKING;
		info.func = KT_AchievementObjectiveTracker_UntrackAchievement;
		info.arg1 = block.id;
		info.checked = false;
		info.disabled = (db.filterAuto[2]);
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.disabled = false;

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.Alert_WowheadURL;
			info.arg1 = "achievement";
			info.arg2 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	function KT_BonusObjectiveTracker_OnBlockClick(self, button)  -- R
		local questID = self.TrackedQuest and self.TrackedQuest.questID or self.id;
		local isThreatQuest = C_QuestLog.IsThreatQuest(questID);
		if button == "LeftButton" then
			if ( not ChatEdit_TryInsertQuestLinkForQuestID(questID) ) then
				if IsShiftKeyDown() then
					if QuestUtils_IsQuestWatched(questID) and not isThreatQuest then
						KT_BonusObjectiveTracker_UntrackWorldQuest(questID);
					end
				elseif IsModifiedClick(db.menuWowheadURLModifier) then
					KT:Alert_WowheadURL("quest", questID)
				else
					local mapID = C_TaskQuest.GetQuestZoneID(questID);
					if mapID then
						QuestMapFrame_CloseQuestDetails();
						OpenQuestLog(mapID);
						WorldMapPing_StartPingQuest(questID);
					end
				end
			end
		elseif button == "RightButton" then
			KT_ObjectiveTracker_ToggleDropDown(self, KT_BonusObjectiveTracker_OnOpenDropDown);
		end
	end

	function KT_BonusObjectiveTracker_OnOpenDropDown(self)  -- R
		local block = self.activeFrame;
		local questID = block.TrackedQuest and block.TrackedQuest.questID or block.id;
		local addStopTracking = QuestUtils_IsQuestWatched(questID);

		-- Ensure at least one option will appear before showing the dropdown.
		if not addStopTracking and not db.menuWowheadURL then
			return;
		end

		-- Add title
		local info = MSA_DropDownMenu_CreateInfo();
		info.text = C_TaskQuest.GetQuestInfoByQuestID(questID) or block.title;  -- fix Blizz bug
		info.isTitle = 1;
		info.notCheckable = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		-- Add "stop tracking"
		if QuestUtils_IsQuestWatched(questID) then
			info = MSA_DropDownMenu_CreateInfo();
			info.notCheckable = true;
			info.text = OBJECTIVES_STOP_TRACKING;
			info.func = function()
				KT_BonusObjectiveTracker_UntrackWorldQuest(questID);
			end
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end

		if db.menuWowheadURL then
			info = MSA_DropDownMenu_CreateInfo();
			info.notCheckable = true;
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.Alert_WowheadURL;
			info.arg1 = "quest";
			info.arg2 = questID;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	function KT_PROFESSION_RECIPE_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)  -- R
		if ( IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() ) then
			local link = C_TradeSkillUI.GetRecipeLink(block.id);
			if ( link ) then
				ChatEdit_InsertLink(link);
			end
		elseif ( mouseButton ~= "RightButton" ) then
			MSA_CloseDropDownMenus();
			if ( not ProfessionsFrame ) then
				ProfessionsFrame_LoadUI();
			end
			if ( IsModifiedClick("RECIPEWATCHTOGGLE") ) then
				C_TradeSkillUI.SetRecipeTracked(block.id, false);
			elseif IsModifiedClick(db.menuWowheadURLModifier) then
				KT:Alert_WowheadURL("spell", block.id)
			else
				C_TradeSkillUI.OpenRecipe(block.id);
				C_Timer.After(0, function()
					C_TradeSkillUI.OpenRecipe(block.id);  -- fix Blizz bug
				end)
			end
		else
			KT_ObjectiveTracker_ToggleDropDown(block, KT_RecipeObjectiveTracker_OnOpenDropDown);
		end
	end

	function KT_RecipeObjectiveTracker_OnOpenDropDown(self)  -- R
		local block = self.activeFrame;

		local info = MSA_DropDownMenu_CreateInfo();
		info.text = GetSpellInfo(block.id);
		info.isTitle = 1;
		info.notCheckable = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info = MSA_DropDownMenu_CreateInfo();
		info.notCheckable = 1;

        info.text = PROFESSIONS_TRACKING_VIEW_RECIPE;
        info.func = function()
            C_TradeSkillUI.OpenRecipe(block.id);
			C_Timer.After(0, function()
				C_TradeSkillUI.OpenRecipe(block.id);  -- fix Blizz bug
			end)
        end;
        MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

        info.text = PROFESSIONS_UNTRACK_RECIPE;
        info.func = function()
            C_TradeSkillUI.SetRecipeTracked(block.id, false);
        end;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.Alert_WowheadURL;
			info.arg1 = "spell";
			info.arg2 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	-- Headers
	hooksecurefunc(KT_QUEST_TRACKER_MODULE.Header, "UpdateHeader", function(self)
		self.module.title = self.Text:GetText()
		KT:SetQuestsHeaderText()
	end)

	-- Torghast
	hooksecurefunc(UIWidgetTemplateStatusBarMixin, "Setup", function(self, widgetInfo, widgetContainer)
		if self.isJailersTowerBar then
			if not self.KTskinned then
				local bck_Bar_OnEnter = self.Bar:GetScript("OnEnter")
				self.Bar:SetScript("OnEnter", function(self)
					if KTF.anchorLeft then
						self:SetTooltipLocation(Enum.UIWidgetTooltipLocation.Right)
						self.tooltipXOffset = 17
					else
						self:SetTooltipLocation(Enum.UIWidgetTooltipLocation.Left)
						self.tooltipXOffset = -19
					end
					self.tooltipYOffset = 0
					bck_Bar_OnEnter(self)
				end)
				self.KTskinned = true
			end
		end
	end)

	hooksecurefunc(UIWidgetTemplateStatusBarMixin, "EvaluateTutorials", function(self)
		if self.isJailersTowerBar then
			HelpTip:Hide(self, TORGHAST_DOMINANCE_BAR_TIP)
			HelpTip:Hide(self, TORGHAST_DOMINANCE_BAR_CUTOFF_TIP)
		end
	end)

	MawBuffs:SetScript("OnShow", function(self)  -- R
		self:ClearAllPoints()
		self.List:ClearAllPoints()

		if KTF.anchorLeft then
			self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", 0, 0)
			self.List:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 1)

			self.NormalTexture:SetTexCoord(1, 0, 1, 0)
			self.PushedTexture:SetTexCoord(1, 0, 1, 0)
			self.HighlightTexture:SetTexCoord(1, 0, 1, 0)
			self.DisabledTexture:SetTexCoord(1, 0, 1, 0)
		else
			self:SetPoint("TOPRIGHT", self:GetParent(), "TOPRIGHT", 0, 0)
			self.List:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 1)

			self.NormalTexture:SetTexCoord(0, 1, 1, 0)
			self.PushedTexture:SetTexCoord(0, 1, 1, 0)
			self.HighlightTexture:SetTexCoord(0, 1, 1, 0)
			self.DisabledTexture:SetTexCoord(0, 1, 1, 0)
		end
	end)

	MawBuffs.List:SetScript("OnShow", function(self)  -- R
		self:OnHide()
		self.button:SetButtonState("NORMAL")
		self.button:SetButtonState("PUSHED", true)
	end)

	MawBuffs.UpdateHelptip = function() end
end

--------------
-- External --
--------------

function KT:MinimizeButton_OnClick(autoClick)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	ObjectiveTracker_Toggle()
	self.collapsedByUser = autoClick and nil or dbChar.collapsed
end

function KT_WorldQuestPOIButton_OnClick(self)
	local questID = self.questID
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	C_SuperTrack.SetSuperTrackedQuestID(questID)
	WorldMapPing_StartPingQuest(questID)
end

function KT:SetSize()
	local height = 33
	local mod = 0

	if OTF.BlocksFrame.contentsHeight then
		OTF.BlocksFrame.contentsHeight = round(OTF.BlocksFrame.contentsHeight)
	else
		return
	end

	_DBG(" - height = "..OTF.BlocksFrame.contentsHeight)
	if not dbChar.collapsed and not self:IsTrackerEmpty() then
		-- width
		KTF:SetWidth(trackerWidth)

		-- height
		if KT_BONUS_OBJECTIVE_TRACKER_MODULE.firstBlock then
			mod = mod + KT_BONUS_OBJECTIVE_TRACKER_MODULE.blockPadding
		end

		height = OTF.BlocksFrame.contentsHeight + mod + 10 + paddingBottom
		_DBG(" - "..OTF.BlocksFrame.contentsHeight.." + "..mod.." + 10 + "..paddingBottom.." = "..height, true)
		OTF.height = height

		if height > db.maxHeight then
			_DBG("MOVE ... "..KTF.Scroll.value.." > "..OTF.height.." - "..db.maxHeight)
			if KTF.Scroll.value > OTF.height-db.maxHeight then
				KTF.Scroll.value = OTF.height - db.maxHeight
			end
			KTF.Scroll:SetVerticalScroll(KTF.Scroll.value)
			if db.frameScrollbar then
				SetScrollbarPosition()
				KTF.Bar:Show()
			end
			height = db.maxHeight
		elseif height <= db.maxHeight then
			if KTF.Scroll.value > 0 then
				KTF.Scroll.value = 0
				KTF.Scroll:SetVerticalScroll(0)
			end
			if db.frameScrollbar then
				KTF.Bar:Hide()
			end
		end
		if height ~= KTF.height then
			KTF:SetHeight(height)
			KTF.height = height
		end
		self:MoveButtons()
	else
		-- width
		if db.hdrCollapsedTxt == 1 then
			KTF:SetWidth(KTF.HeaderButtons:GetWidth() + 8)
		else
			KTF:SetWidth(trackerWidth)
		end

		-- height
		OTF.height = height - 10
		OTF:SetHeight(OTF.height)
        if OTF.BlocksFrame.contentsHeight == 0 then
            KTF.Scroll.value = 0
        end
		KTF.Scroll:SetVerticalScroll(0)
		if db.frameScrollbar then
			KTF.Bar:Hide()
		end
		if height ~= KTF.height then
			KTF:SetHeight(height)
			KTF.height = height
		end
	end
end

if CoreDependCall then
    CoreDependCall("Blizzard_MawBuffs", function()
        SetOrHookScript(MawBuffsBelowMinimapFrame, "OnShow", function() KT:MoveTracker() end)
        SetOrHookScript(MawBuffsBelowMinimapFrame, "OnHide", function() KT:MoveTracker() end)
    end)
end

function KT:MoveTracker()
	KTF:ClearAllPoints()
	KTF:SetPoint(db.anchorPoint, UIParent, db.anchorPoint, db.xOffset, db.yOffset)
    if MawBuffsBelowMinimapFrame and MawBuffsBelowMinimapFrame:IsShown() then
        if CoreIsFrameIntersects(MawBuffsBelowMinimapFrame, KTF) then
            local delta = KTF:GetTop() - MawBuffsBelowMinimapFrame:GetBottom()
            if delta > 0 and KTF:GetBottom() < MawBuffsBelowMinimapFrame:GetTop() and
                    (KTF:GetTop() <= MawBuffsBelowMinimapFrame:GetTop() + 50) then
                KTF:SetPoint(db.anchorPoint, UIParent, db.anchorPoint, db.xOffset, db.yOffset - delta)
            end
        end
    end
	KTF.directionUp = (db.anchorPoint == "BOTTOMLEFT" or db.anchorPoint == "BOTTOMRIGHT")
	KTF.anchorLeft = (db.anchorPoint == "TOPLEFT" or db.anchorPoint == "BOTTOMLEFT")

	local options = self.options.args.general.args.sec1.args
	if KTF.anchorLeft then
		options.xOffset.min = 0
		options.xOffset.max = self.screenWidth - trackerWidth
	else
		options.xOffset.min = -(self.screenWidth - trackerWidth)
		options.xOffset.max = 0
	end

	if KTF.directionUp then
		options.yOffset.min = 0
		options.yOffset.max = self.screenHeight - options.maxHeight.min
	else
		options.yOffset.min = -(self.screenHeight - options.maxHeight.min)
		options.yOffset.max = 0
	end

	options.maxHeight.max = math.ceil(self.screenHeight - abs(db.yOffset))
	db.maxHeight = (abs(db.yOffset)+db.maxHeight > self.screenHeight) and options.maxHeight.max or db.maxHeight

	self:MoveButtons()
end

function KT:SetBackground()
	local backdrop = {
		bgFile = LSM:Fetch("background", db.bgr),
		edgeFile = LSM:Fetch("border", db.border),
		edgeSize = db.borderThickness,
		insets = { left=db.bgrInset, right=db.bgrInset, top=db.bgrInset, bottom=db.bgrInset }
	}
	self.borderColor = db.classBorder and self.classColor or db.borderColor

	KTF:SetBackdrop(backdrop)
	KTF:SetBackdropColor(db.bgrColor.r, db.bgrColor.g, db.bgrColor.b, db.bgrColor.a)
	KTF:SetBackdropBorderColor(self.borderColor.r, self.borderColor.g, self.borderColor.b, db.borderAlpha)

	SetHeaders("background")

	self.hdrBtnColor = db.hdrBtnColorShare and self.borderColor or db.hdrBtnColor
	KTF.MinimizeButton:GetNormalTexture():SetVertexColor(self.hdrBtnColor.r, self.hdrBtnColor.g, self.hdrBtnColor.b)
	if self.Filters:IsEnabled() then
		if db.filterAuto[1] or db.filterAuto[2] or db.filterAuto[3] then
			KTF.FilterButton:GetNormalTexture():SetVertexColor(0, 1, 0)
		else
			KTF.FilterButton:GetNormalTexture():SetVertexColor(self.hdrBtnColor.r, self.hdrBtnColor.g, self.hdrBtnColor.b)
		end
	end
	if db.hdrOtherButtons then
		KTF.QuestLogButton:GetNormalTexture():SetVertexColor(self.hdrBtnColor.r, self.hdrBtnColor.g, self.hdrBtnColor.b)
		KTF.AchievementsButton:GetNormalTexture():SetVertexColor(self.hdrBtnColor.r, self.hdrBtnColor.g, self.hdrBtnColor.b)
	end

	if db.qiBgrBorder then
		KTF.Buttons:SetBackdrop(backdrop)
		KTF.Buttons:SetBackdropColor(db.bgrColor.r, db.bgrColor.g, db.bgrColor.b, db.bgrColor.a)
		KTF.Buttons:SetBackdropBorderColor(self.borderColor.r, self.borderColor.g, self.borderColor.b, db.borderAlpha)
	else
		KTF.Buttons:SetBackdrop(nil)
	end

	KTF.Bar.texture:SetColorTexture(self.borderColor.r, self.borderColor.g, self.borderColor.b, db.borderAlpha)

	if db.bgr == "None" and db.border == "None" then
		KTF.Scroll:SetHitRectInsets(-150, 0, 0, 0.1)
	else
		KTF.Scroll:SetHitRectInsets(0.1, 0, 0, 0.1)
    end

    OTFHeader.Title:SetJustifyH(db.bgr == "None" and "RIGHT" or "LEFT")
end

function KT:SetText()
	self.font = LSM:Fetch("font", db.font)

	-- Headers
	SetHeaders("text")
	-- Others
	KT_ScenarioStageBlock.Stage:SetFont(self.font, db.fontSize+5, db.fontFlag)
end

function KT:SetHeaderButtons(numAddButtons)
	local buttonSpace = 20
	KTF.HeaderButtons.num = KTF.HeaderButtons.num + numAddButtons
	KTF.HeaderButtons:SetWidth((KTF.HeaderButtons.num * buttonSpace) + 7)
	OTFHeader.Title:SetWidth(OTFHeader.Title:GetWidth() - (numAddButtons * buttonSpace))
end

function KT:SetModuleHeader(module)
	if not module.Header then return end
	module.Header.Text:SetWidth(165)
	module.Header.Text.ClearAllPoints = function() end
	module.Header.Text:SetPoint("LEFT", 4, 1)
	module.Header.Text.SetPoint = function() end
	module.Header.PlayAddAnimation = function() end
	module.Header.LineGlow:Hide()
	module.Header.SoftGlow:Hide()
	module.Header.StarBurst:Hide()
	module.Header.LineSheen:Hide()
	if module == KT_BONUS_OBJECTIVE_TRACKER_MODULE or module == KT_WORLD_QUEST_TRACKER_MODULE then
		module.Header.TopShadow:Hide()
		module.Header.BottomShadow:Hide()
	end
	module.Header.MinimizeButton:SetShown(false)
	module.Header.MinimizeButton.SetShown = function() end
	module.Header:SetScript("OnMouseDown", function(self, btn)
		ModuleMinimize_OnClick(module)
	end)
	tinsert(KT.headers, module.Header)
	module.title = module.Header.Text:GetText()

	-- Module collapse button
	local button = CreateFrame("Button", nil, module.Header)
	button:SetSize(16, 25)
	button:SetPoint("TOPRIGHT", module.Header, "TOPLEFT", 4, 0)
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetSize(16, 16)
	button.Icon:SetTexture(mediaPath.."UI-KT-HeaderButtons")
	button.Icon:SetTexCoord(0.5, 1, 0.75, 1)
	button.Icon:SetPoint("LEFT", 0, 1.5)
	button:RegisterForClicks("AnyDown")
	button:SetScript("OnClick", function(self, btn)
		ModuleMinimize_OnClick(module)
	end)
	module.Header.Button = button
end

function KT:SetHeaderText(module, append)
	local text = module.title or ""
	if append then
		text = format("%s (%s)", text, append)
	end
	module.Header.Text:SetText(text)
end

function KT:SetQuestsHeaderText(reset)
	if db.hdrQuestsTitleAppend then
		self:SetHeaderText(KT_QUEST_TRACKER_MODULE, dbChar.quests.num.."/"..MAX_QUESTS)
	elseif reset then
		self:SetHeaderText(KT_QUEST_TRACKER_MODULE)
	end
end

function KT:SetAchievsHeaderText(reset)
	if db.hdrAchievsTitleAppend then
		self:SetHeaderText(KT_ACHIEVEMENT_TRACKER_MODULE, GetTotalAchievementPoints())
	elseif reset then
		self:SetHeaderText(KT_ACHIEVEMENT_TRACKER_MODULE)
	end
end

function KT:SetOtherButtons()
	if not db.hdrOtherButtons then
		if KTF.QuestLogButton then
			KTF.QuestLogButton:Hide()
			KTF.AchievementsButton:Hide()
			self:SetHeaderButtons(-2)
		end
		return
	end
	if KTF.QuestLogButton then
		KTF.QuestLogButton:Show()
		KTF.AchievementsButton:Show()
	else
		local button
		-- Achievements button
		button = CreateFrame("Button", addonName.."AchievementsButton", KTF.HeaderButtons)
		button:SetSize(16, 16)
		button:SetPoint("TOPRIGHT", KTF.FilterButton or KTF.MinimizeButton, "TOPLEFT", -4, 0)
		button:SetNormalTexture(mediaPath.."UI-KT-HeaderButtons")
		button:GetNormalTexture():SetTexCoord(0.5, 1, 0.25, 0.5)
		button:RegisterForClicks("AnyDown")
		button:SetScript("OnClick", function(self, btn)
			ToggleAchievementFrame()
		end)
		button:SetScript("OnEnter", function(self)
			self:GetNormalTexture():SetVertexColor(1, 1, 1)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(AchievementMicroButton.tooltipText, 1, 1, 1)
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self)
			self:GetNormalTexture():SetVertexColor(KT.hdrBtnColor.r, KT.hdrBtnColor.g, KT.hdrBtnColor.b)
			GameTooltip:Hide()
		end)
		KTF.AchievementsButton = button

		-- Quest Log button
		button = CreateFrame("Button", addonName.."QuestLogButton", KTF.HeaderButtons)
		button:SetSize(16, 16)
		button:SetPoint("TOPRIGHT", KTF.AchievementsButton, "TOPLEFT", -4, 0)
		button:SetNormalTexture(mediaPath.."UI-KT-HeaderButtons")
		button:GetNormalTexture():SetTexCoord(0.5, 1, 0, 0.25)
		button:RegisterForClicks("AnyDown")
		button:SetScript("OnClick", function(self, btn)
			ToggleQuestLog()
		end)
		button:SetScript("OnEnter", function(self)
			self:GetNormalTexture():SetVertexColor(1, 1, 1)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(QuestLogMicroButton.tooltipText, 1, 1, 1)
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self)
			self:GetNormalTexture():SetVertexColor(KT.hdrBtnColor.r, KT.hdrBtnColor.g, KT.hdrBtnColor.b)
			GameTooltip:Hide()
		end)
		KTF.QuestLogButton = button
	end
	self:SetHeaderButtons(2)
end

function KT:MoveButtons()
	if not InCombatLockdown() then
		local point, xOfs, yOfs
		if KTF.anchorLeft then
			point = "LEFT"
			xOfs = KTF:GetRight() and KTF:GetRight() + db.qiXOffset
		else
			point = "RIGHT"
			xOfs = KTF:GetLeft() and KTF:GetLeft() - db.qiXOffset
		end
		local hMod = 2 * (4 - db.bgrInset)
		local yMod = 0
		if not db.qiBgrBorder then
			hMod = hMod + 4
			yMod = 2 + (4 - db.bgrInset)
		end
		if KTF.directionUp and (db.maxHeight+hMod) < KTF.Buttons:GetHeight() then
			point = "BOTTOM"..point
			yOfs = KTF:GetBottom() and KTF:GetBottom() - yMod
		else
			point = "TOP"..point
			yOfs = KTF:GetTop() and KTF:GetTop() + yMod
		end
		if xOfs and yOfs then
			KTF.Buttons:ClearAllPoints()
			KTF.Buttons:SetPoint(point, UIParent, "BOTTOMLEFT", xOfs, yOfs)
		end
	end
end

function KT:RemoveFixedButton(block)
	if block then
		local tag = block.fixedTag
		if tag then
			tinsert(freeTags, tag)
			tag.text:SetText("")
			tag:Hide()
			block.fixedTag = nil
		end
		local questID = block.id
		local button = self:GetFixedButton(questID)
		if button then
			button:SetAlpha(0)
			if InCombatLockdown() then
				_DBG(" - STOP Remove button")
				combatLockdown = true
			else
				_DBG(" - REMOVE button "..questID)
				tinsert(freeButtons, button)
				self.fixedButtons[questID] = nil
				button:Hide()
				KTF.Buttons.reanchor = true
			end
			if db.qiActiveButton then
				KTF.ActiveButton.text:SetText("")
			end
		end
		if self.ActiveButton.timerID == questID then
			self.ActiveButton.timerID = nil
		end
	else
		for questID, button in pairs(self.fixedButtons) do
			_DBG(" - REMOVE button "..questID)
			tinsert(freeButtons, button)
			self.fixedButtons[questID] = nil
			button:Hide()
		end
		KTF.Buttons.reanchor = true
	end
end

function KT:GetFixedButton(questID)
	if self.fixedButtons[questID] then
		return self.fixedButtons[questID]
	else
		return nil
	end
end

function KT:CreateQuestTag(level, questTag, frequency, suggestedGroup)
	local tag = ""

	if level == -1 then
		level = "*"
	else
		level = tostring(level)
	end

	if questTag then
		if questTag == Enum.QuestTag.Group then
			tag = "g"
			if suggestedGroup and suggestedGroup > 0 then
				tag = tag..suggestedGroup
			end
		elseif questTag == Enum.QuestTag.PvP then
			tag = "pvp"
		elseif questTag == Enum.QuestTag.Dungeon then
			tag = "d"
		elseif questTag == Enum.QuestTag.Heroic then
			tag = "hc"
		elseif questTag == Enum.QuestTag.Raid then
			tag = "r"
		elseif questTag == Enum.QuestTag.Raid10 then
			tag = "r10"
		elseif questTag == Enum.QuestTag.Raid25 then
			tag = "r25"
		elseif questTag == Enum.QuestTag.Scenario then
			tag = "s"
		elseif questTag == Enum.QuestTag.Account then
			tag = "a"
		elseif questTag == Enum.QuestTag.Legendary then
			tag = "leg"
		end
	end

	if frequency == Enum.QuestFrequency.Daily then
		tag = tag.."!"
	elseif frequency == Enum.QuestFrequency.Weekly then
		tag = tag.."!!"
	end

	if tag ~= "" then
		tag = ("|cff00b3ff%s|r"):format(tag)
	end

	tag = ("[%s%s] "):format(level, tag)
	return tag
end

function KT:IsTrackerEmpty(noaddon)
	local result = (KT.GetNumQuestWatches() == 0 and
			GetNumAutoQuestPopUps() == 0 and
			GetNumTrackedAchievements() == 0 and
			self.IsTableEmpty(self.activeTasks) and
			C_QuestLog.GetNumWorldQuestWatches() == 0 and
			not self.inScenario and
			#C_TradeSkillUI.GetRecipesTracked(true) == 0 and #C_TradeSkillUI.GetRecipesTracked(false) == 0)
	if not noaddon then
		result = (result and not self.AddonPetTracker:IsShown())
	end
	return result
end

function KT:ToggleEmptyTracker(added)
	local alpha, mouse = 1, true
	if self:IsTrackerEmpty() then
		if not dbChar.collapsed then
			ObjectiveTracker_Toggle()
		end
		KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 0.75)
		if db.hideEmptyTracker then
			alpha = 0
			mouse = false
		end
	else
		if dbChar.collapsed then
			if added and not self.collapsedByUser then
				ObjectiveTracker_Toggle()
			else
				KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.25)
			end
		else
			KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.25, 0.5)
		end
	end
	KTF:SetAlpha(alpha)
	KTF.MinimizeButton:EnableMouse(mouse)
	if self.Filters:IsEnabled() then
		KTF.FilterButton:EnableMouse(mouse)
	end
	if db.hdrOtherButtons then
		KTF.QuestLogButton:EnableMouse(mouse)
		KTF.AchievementsButton:EnableMouse(mouse)
	end
end

--abyui 强制设置成透明，DBM自动隐藏时需要，返回true表示确实有改变
KT_ForceHideTracker = function(hide)
    local alpha, mouse = 1, true
    if hide then
            alpha = 0
            mouse = false
    end
    if KTF:GetAlpha() == alpha then
        return false
    end
    KTF:SetAlpha(alpha)
    KTF.MinimizeButton:EnableMouse(mouse)
    if KT.Filters:IsEnabled() then
        KTF.FilterButton:EnableMouse(mouse)
    end
    if db.hdrOtherButtons then
        KTF.QuestLogButton:EnableMouse(mouse)
        KTF.AchievementsButton:EnableMouse(mouse)
    end
    return true
end

hooksecurefunc(KTF, "SetAlpha", function(self, alpha)
    if KTTrackerRestore == true and InCombatLockdown()  and alpha == 1 then
        KTF:SetAlpha(0)
    end
end)

--/run hooksecurefunc("ObjectiveTracker_Expand", pdebug)
--hooksecurefunc("Scenario_ChallengeMode_ShowBlock", function()    if db.collapseInInstance then end end)

function KT:SetMessage(text, r, g, b, pattern, icon, x, y)
    if not text then return end
	if pattern then
		text = format(pattern, text.." ...")
	end
	if icon then
		x = x or 0
		y = y or 0
		if db.sink20OutputSink == "Blizzard" then
			x = floor(x * 3)
			y = y - 8
		end
		text = format("|T%s:0:0:%d:%d|t%s", icon, x, y, text)
	end
	self:Pour(text, r, g, b)
end

function KT:PlaySound(key)
	PlaySoundFile(LSM:Fetch("sound", key))
end

function KT:UpdateHotkey()
	local key = GetBindingKey("EXTRAACTIONBUTTON1")
	if db.keyBindMinimize == key then
		SetOverrideBinding(KTF, false, db.keyBindMinimize, nil)
		db.keyBindMinimize = ""
	end
end

function KT:MergeTables(source, target)
	if type(target) ~= "table" then target = {} end
	for k, v in pairs(source) do
		if type(v) == "table" then
			target[k] = self:MergeTables(v, target[k])
		elseif target[k] == nil then
			target[k] = v
		end
	end
	return target
end

-- Load ----------------------------------------------------------------------------------------------------------------

function KT:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)

	SLASH_KALIELSTRACKER1, SLASH_KALIELSTRACKER2 = "/kt", "/kalielstracker"
	SlashCmdList["KALIELSTRACKER"] = SlashHandler

	SetMsgPatterns()

	-- Get character data
	self.playerName = UnitName("player")
	self.playerFaction = UnitFactionGroup("player")
	self.playerLevel = UnitLevel("player")
	local _, class = UnitClass("player")
	self.classColor = RAID_CLASS_COLORS[class]

	self.headers = {}
	self.borderColor = {}
	self.hdrBtnColor = {}
	self.fixedButtons = {}
	self.activeTasks = {}
	self.inWorld = false
	self.inInstance = IsInInstance()
	self.inScenario = C_Scenario.IsInScenario() and not KT.IsScenarioHidden()
	self.stopUpdate = true
	self.questStateStopUpdate = false
	self.collapsedByUser = false
	self.locked = false
	self.wqInitialized = false
	self.initialized = false

	-- Setup Options
	self:SetupOptions()
	db = self.db.profile
	dbChar = self.db.char
	KT:Alert_ResetIncompatibleProfiles("6.0.0")

	-- Blizzard frame resets
	ObjectiveTrackerFrame:Hide()
	OTF.KTSetParent = OTF.SetParent
	OTF:SetParent(UIParent)
	OTF.SetFrameStrata = function() end
	OTF.SetFrameLevel = function() end
	OTF:SetClampedToScreen(false)
	OTF.SetClampedToScreen = function() end
	OTF:EnableMouse(false)
	OTF.EnableMouse = function() end
	OTF:SetMovable(false)
	OTF.SetAllPoints = function() end
	OTF:ClearAllPoints()
	OTF.KTSetPoint = OTF.SetPoint
	OTF.SetShown = function() end
	OTF:Show()
end

function KT:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)

	SetFrames()
	SetHooks()

	self.Hacks:Enable()
	self.QuestLog:Enable()
	self.Filters:Enable()
	if self.AddonPetTracker.isLoaded then self.AddonPetTracker:Enable() end
	if self.AddonTomTom.isLoaded then self.AddonTomTom:Enable() end
	self.AddonOthers:Enable()
	if db.qiActiveButton then self.ActiveButton:Enable() end
	self.Help:Enable()

	if self.db.global.version ~= self.version then
		self.db.global.version = self.version
	end

	self.screenWidth = round(GetScreenWidth())
	self.screenHeight = round(GetScreenHeight())

	local i = 1
	local isChange = false
	while i <= #db.modulesOrder do
		if _G[db.modulesOrder[i]] then
			i = i + 1
		else
			tremove(db.modulesOrder, i)
			isChange = true
		end
	end
	if isChange then
		self.db:RegisterDefaults(self.db.defaults)
	end
end
