--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, addon = ...
local KT = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "LibSink-2.0")
KT:SetDefaultModuleState(false)
KT.title = GetAddOnMetadata(addonName, "Title")
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
local tinsert = table.insert
local tremove = table.remove
local unpack = unpack
local round = function(n) return floor(n + 0.5) end

-- WoW API
local _G = _G
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local HaveQuestData = HaveQuestData
local InCombatLockdown = InCombatLockdown
local FormatLargeNumber = FormatLargeNumber
local UIParent = UIParent

local trackerWidth = 280
local paddingBottom = 15
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local questState = {}
local freeTags = {}
local freeButtons = {}
local msgPatterns = {}
local combatLockdown = false
local db, dbChar

-- Main frame
local KTF = CreateFrame("Frame", addonName.."Frame", UIParent)
KT.frame = KTF

-- Blizzard frame
local OTF = ObjectiveTrackerFrame
local OTFHeader = OTF.HeaderMenu

--[=[ 
--ours
local line = DEFAULT_OBJECTIVE_TRACKER_MODULE.freeLines[1] or CreateFrame("Frame", nil, nil, DEFAULT_OBJECTIVE_TRACKER_MODULE.lineTemplate)
line.Dash:SetText(QUEST_DASH)
OBJECTIVE_TRACKER_DASH_WIDTH = line.Dash:GetWidth()
OBJECTIVE_TRACKER_TEXT_WIDTH = OBJECTIVE_TRACKER_LINE_WIDTH - OBJECTIVE_TRACKER_DASH_WIDTH - 12
DEFAULT_OBJECTIVE_TRACKER_MODULE.lineWidth = OBJECTIVE_TRACKER_TEXT_WIDTH
line.Text:SetWidth(OBJECTIVE_TRACKER_TEXT_WIDTH)
--theirs
DEFAULT_OBJECTIVE_TRACKER_MODULE.freeLines[1].Dash:SetText(QUEST_DASH)
OBJECTIVE_TRACKER_DASH_WIDTH = DEFAULT_OBJECTIVE_TRACKER_MODULE.freeLines[1].Dash:GetWidth()
OBJECTIVE_TRACKER_TEXT_WIDTH = OBJECTIVE_TRACKER_LINE_WIDTH - OBJECTIVE_TRACKER_DASH_WIDTH - 12
DEFAULT_OBJECTIVE_TRACKER_MODULE.lineWidth = OBJECTIVE_TRACKER_TEXT_WIDTH
DEFAULT_OBJECTIVE_TRACKER_MODULE.freeLines[1].Text:SetWidth(OBJECTIVE_TRACKER_TEXT_WIDTH)
--]=]


-- Blizzard Constants
OBJECTIVE_TRACKER_COLOR["Header"] = { r = 1, g = 0.5, b = 0 }					-- orange
OBJECTIVE_TRACKER_COLOR["Complete"] = { r = 0.1, g = 0.85, b = 0.1 }			-- green
OBJECTIVE_TRACKER_COLOR["CompleteHighlight"] = { r = 0, g = 1, b = 0 }			-- green
OBJECTIVE_TRACKER_COLOR["TimeLeft2"] = { r = 0, g = 0.5, b = 1 }				-- blue
OBJECTIVE_TRACKER_COLOR["TimeLeft2Highlight"] = { r = 0.3, g = 0.65, b = 1 }	-- blue
OBJECTIVE_TRACKER_COLOR["Header"].reverse = OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Header"]
OBJECTIVE_TRACKER_COLOR["Complete"].reverse = OBJECTIVE_TRACKER_COLOR["CompleteHighlight"]
OBJECTIVE_TRACKER_COLOR["CompleteHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Complete"]
OBJECTIVE_TRACKER_COLOR["TimeLeft2"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeft2Highlight"]
OBJECTIVE_TRACKER_COLOR["TimeLeft2Highlight"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeft2"]

OTF.BlocksFrame.PopupQuestHeader = CreateFrame("Frame", "PopupQuestHeader", OTF.BlocksFrame, "ObjectiveTrackerHeaderTemplate")
AUTO_QUEST_POPUP_TRACKER_MODULE:SetHeader(OTF.BlocksFrame.PopupQuestHeader, TRACKER_HEADER_QUESTS, nil)
AUTO_QUEST_POPUP_TRACKER_MODULE.blockOffsetX = -26
AUTO_QUEST_POPUP_TRACKER_MODULE.blockOffsetY = -6
SCENARIO_CONTENT_TRACKER_MODULE.blockOffsetX = -16
BONUS_OBJECTIVE_TRACKER_MODULE.blockPadding = 0
WORLD_QUEST_TRACKER_MODULE.blockPadding = 0
DEFAULT_OBJECTIVE_TRACKER_MODULE.blockTemplate = "KT_ObjectiveTrackerBlockTemplate"
DEFAULT_OBJECTIVE_TRACKER_MODULE.lineTemplate = "KT_ObjectiveTrackerLineTemplate"
QUEST_TRACKER_MODULE.buttonOffsets.groupFinder = { 2, 4 }
BONUS_OBJECTIVE_TRACKER_MODULE.buttonOffsets.groupFinder = { 6, 4 }
WORLD_QUEST_TRACKER_MODULE.buttonOffsets.groupFinder = { 6, 4 }

--------------
-- Internal --
--------------

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
					header.Text:SetTextColor(1, 0.82, 0)
				else
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
	if cmd == "config" then
		KT:OpenOptions()
	else
		ObjectiveTracker_MinimizeButton_OnClick()
	end
end

local function SetScrollbarPosition()
	KTF.Bar:SetPoint("TOPRIGHT", -5, -round(5+(KTF.Scroll.value*(((db.maxHeight-60)/((OTF.height-db.maxHeight)/KTF.Scroll.step))/KTF.Scroll.step))))
end

local function GetTaskTimeLeftData(questID)
	local timeString = ""
	local timeColor = OBJECTIVE_TRACKER_COLOR["TimeLeft2"]
	local timeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes(questID)
	if timeLeftMinutes > 0 then
		timeString = SecondsToTime(timeLeftMinutes * 60)
		if timeLeftMinutes <= WORLD_QUESTS_TIME_CRITICAL_MINUTES then
			timeColor = OBJECTIVE_TRACKER_COLOR["TimeLeft"]
		end
	end
	return timeString, timeColor
end

-- Setup ---------------------------------------------------------------------------------------------------------------

local function Init()
	db = KT.db.profile

	if db.keyBindMinimize ~= "" then
		SetOverrideBindingClick(KTF, false, db.keyBindMinimize, KTF.MinimizeButton:GetName())
	end

	for i, module in ipairs(db.modulesOrder) do
		OTF.MODULES_UI_ORDER[i] = _G[module]
		KT:SaveHeader(OTF.MODULES_UI_ORDER[i])
	end

	KT:MoveTracker()
	KT:SetBackground()
	KT:SetText()

	KT.stopUpdate = false
	KT.inWorld = true

	if dbChar.collapsed then
		ObjectiveTracker_MinimizeButton_OnClick()
	end

	C_Timer.After(0, function()
		KT:SetQuestsHeaderText()
		KT:SetAchievsHeaderText()

		OTF:KTSetPoint("TOPLEFT", 30, -1)
		OTF:KTSetPoint("BOTTOMRIGHT")
		ObjectiveTracker_Update()

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

	KTF:SetScript("OnEvent", function(_, event, ...)
		_DBG("Event - "..event)
		if event == "PLAYER_ENTERING_WORLD" and not KT.stopUpdate then
			KT.inWorld = true
			KT.inInstance = IsInInstance()
			if db.collapseInInstance and KT.inInstance and not dbChar.collapsed then
				ObjectiveTracker_MinimizeButton_OnClick()
			end
		elseif event == "PLAYER_LEAVING_WORLD" then
			KT.inWorld = false
		elseif event == "QUEST_WATCH_LIST_CHANGED" then
			local id, added = ...
			if id and not added then
				if not KT.questStateStopUpdate then
					questState[id] = nil
				end
				if KT.activeTask == id then
					KT.activeTask = nil
				end
			end
			KT:ToggleEmptyTracker(added)
		elseif event == "TRACKED_ACHIEVEMENT_LIST_CHANGED" then
			local id, added = ...
			KT:ToggleEmptyTracker(added)
		elseif event == "SCENARIO_UPDATE" then
			local newStage = ...
			KT:ToggleEmptyTracker(newStage)
			if not newStage then
				local numSpells = ScenarioObjectiveBlock.numSpells or 0
				for i = 1, numSpells do
					KT:RemoveFixedButton(ScenarioObjectiveBlock.spells[i])
				end
				ObjectiveTracker_Update()
			end
		elseif event == "QUEST_AUTOCOMPLETE" then
			KTF.Scroll.value = 0
		elseif event == "QUEST_ACCEPTED" or event == "QUEST_REMOVED" then
			KT:SetQuestsHeaderText()
		elseif event == "ACHIEVEMENT_EARNED" then
			KT:SetAchievsHeaderText()
		--elseif event == "SCENARIO_UPDATE" then
		--	local newStage = ...
		--	KT:ToggleEmptyTracker(newStage)
		elseif event == "PLAYER_REGEN_ENABLED" and combatLockdown then
			combatLockdown = false
			KT:RemoveFixedButton()
			ObjectiveTracker_Update()
		elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" then
			KTF.Buttons.reanchor = (KTF.Buttons.num > 0)
		elseif event == "UPDATE_BINDINGS" then
			KT:UpdateHotkey()
		elseif event == "PLAYER_LEVEL_UP" then
			local level = ...
			KT.playerLevel = level
		end
	end)
	KTF:RegisterEvent("PLAYER_ENTERING_WORLD")
	KTF:RegisterEvent("PLAYER_LEAVING_WORLD")
	KTF:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
	KTF:RegisterEvent("TRACKED_ACHIEVEMENT_LIST_CHANGED")
	KTF:RegisterEvent("SCENARIO_UPDATE")
	KTF:RegisterEvent("QUEST_AUTOCOMPLETE")
	KTF:RegisterEvent("QUEST_ACCEPTED")
	KTF:RegisterEvent("QUEST_REMOVED")
	KTF:RegisterEvent("ACHIEVEMENT_EARNED")
	--KTF:RegisterEvent("SCENARIO_UPDATE")
	KTF:RegisterEvent("PLAYER_REGEN_ENABLED")
	KTF:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	KTF:RegisterEvent("ZONE_CHANGED")
	KTF:RegisterEvent("UPDATE_BINDINGS")
	KTF:RegisterEvent("PLAYER_LEVEL_UP")

	-- DropDown frame
	KT.DropDown = MSA_DropDownMenu_Create(addonName.."DropDown", KTF)
	MSA_DropDownMenu_Initialize(KT.DropDown, nil, "MENU")

	-- Minimize button
	OTFHeader.MinimizeButton:Hide()
	local button = CreateFrame("Button", addonName.."MinimizeButton", KTF)
	button:SetSize(16, 16)
	button:SetPoint("TOPRIGHT", -10, -8)
	button:SetFrameLevel(KTF:GetFrameLevel() + 10)
	button:SetNormalTexture(mediaPath.."UI-KT-HeaderButtons")
	button:GetNormalTexture():SetTexCoord(0, 0.5, 0.25, 0.5)

	button:RegisterForClicks("AnyDown")
	button:SetScript("OnClick", function(self, btn)
		if IsAltKeyDown() then
			KT:OpenOptions()
		elseif not KT:IsTrackerEmpty() then
			ObjectiveTracker_MinimizeButton_OnClick()
		end
	end)
	button:SetScript("OnEnter", function(self)
		self:GetNormalTexture():SetVertexColor(1, 1, 1)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local title = (db.keyBindMinimize ~= "") and L[addonName].." "..NORMAL_FONT_COLOR_CODE.."("..db.keyBindMinimize..")|r" or L[addonName]
		GameTooltip:AddLine(title, 1, 1, 1)
		GameTooltip:AddLine(L"Alt+Click - addon Options", .8, .8, 0)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		self:GetNormalTexture():SetVertexColor(KT.hdrBtnColor.r, KT.hdrBtnColor.g, KT.hdrBtnColor.b)
		GameTooltip:Hide()
	end)
	KTF.MinimizeButton = button

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
			if self.value > 0 and self.value < OTF.height-db.maxHeight then
				MSA_CloseDropDownMenus()
			end
			_DBG("SCROLL ... "..self.value.." ... "..OTF.height.." - "..db.maxHeight)
		end
	end)
	KTF.Scroll = Scroll

	-- Scroll child frame
	local Child = CreateFrame("Frame", addonName.."ScrollChild", KTF.Scroll)
	Child:SetSize(trackerWidth-8, 8000)
	KTF.Scroll:SetScrollChild(Child)

	-- Scroll indicator
	local Bar = CreateFrame("Frame", addonName.."ScrollBar", KTF)
	Bar:SetSize(2, 50)
	Bar:SetPoint("TOPRIGHT", -5, -5)
	Bar:SetFrameLevel(KTF:GetFrameLevel() + 10)
	Bar.texture = Bar:CreateTexture()
	Bar.texture:SetAllPoints()
	Bar:Hide()
	KTF.Bar = Bar

	-- Blizzard frame
	OTF:KTSetPoint("TOPLEFT")
	OTF:KTSetParent(Child)
	OTFHeader:Show()
	OTFHeader.Hide = function() end
	OTFHeader.SetShown = function() end
	OTFHeader:SetSize(10, 21)
	OTFHeader:ClearAllPoints()
	OTFHeader:SetPoint("TOPLEFT", -20, -1)
	OTFHeader.Title:ClearAllPoints()
	OTFHeader.Title:SetPoint("LEFT", -5, -1)
	OTFHeader.Title:SetWidth(trackerWidth - 40)
	OTFHeader.Title:SetJustifyH("LEFT")
	OTFHeader.Title:SetWordWrap(false)
	ScenarioBlocksFrame:SetWidth(243)

	-- Other buttons
	KT:ToggleOtherButtons()

	-- Buttons frame
	local Buttons = CreateFrame("Frame", addonName.."Buttons", UIParent)
	Buttons:SetSize(40, 40)
	Buttons:SetPoint("TOPLEFT", 0, 0)
	Buttons:SetFrameStrata(db.frameStrata)
	Buttons:SetFrameLevel(KTF:GetFrameLevel() - 1)
	Buttons:SetAlpha(0)
	Buttons.num = 0
	Buttons.reanchor = false
	KTF.Buttons = Buttons

	-- Frame locks
    CoreHideOnPetBattle(addonName.."Frame")
    CoreHideOnPetBattle(addonName.."Buttons")
	--if FRAMELOCK_STATES and FRAMELOCK_STATES.PETBATTLES then
	--	FRAMELOCK_STATES.PETBATTLES[addonName.."Frame"] = "hidden"
	--	FRAMELOCK_STATES.PETBATTLES[addonName.."Buttons"] = "hidden"
	--end
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
				local numSpells = ScenarioObjectiveBlock.numSpells or 0
				for i = 1, numSpells do
					block = ScenarioObjectiveBlock.spells[i]
					if block and block.SpellButton then
						idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
					end
				end
				-- World Quest items
				_DBG(" - REANCHOR buttons - WQ", true)
				local tasksTable = GetTasksTable()
				for i = 1, #tasksTable do
					questID = tasksTable[i]
					questLogIndex = GetQuestLogIndexByID(questID)
					if questLogIndex > 0 and QuestUtils_IsQuestWorldQuest(questID) and not IsWorldQuestWatched(questID) then
						block = WORLD_QUEST_TRACKER_MODULE.usedBlocks[questID]
						if block and block.itemButton then
							idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
						end
					end
				end
				for i = 1, GetNumWorldQuestWatches() do
					questID = GetWorldQuestWatchInfo(i)
					if questID then
						block = WORLD_QUEST_TRACKER_MODULE.usedBlocks[questID]
						if block and block.itemButton then
							idx, contentsHeight, yOfs = SetFixedButton(block, idx, contentsHeight, yOfs)
						end
					end
				end
				-- Quest items
				_DBG(" - REANCHOR buttons - Q", true)
				for i = 1, GetNumQuestWatches() do
					questID = GetQuestWatchInfo(i)
					block = QUEST_TRACKER_MODULE.usedBlocks[questID]
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
				KTF.Buttons:Show()
			end
			KT.ActiveButton:Update()
		end
		if dbChar.collapsed or KTF.Buttons.num == 0 then
			KTF.Buttons:SetAlpha(0)
		else
			KTF.Buttons:SetAlpha(1)
		end
	end

	OTF:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" and not KT.initialized then
			Init()
		end
	end)

	local bck_ObjectiveTracker_Update = ObjectiveTracker_Update
	ObjectiveTracker_Update = function(reason, id)
		if KT.stopUpdate then return end
		if reason ~= OBJECTIVE_TRACKER_UPDATE_STATIC then
			local dbgReason
			if reason == OBJECTIVE_TRACKER_UPDATE_ALL then
				dbgReason = "FFFFFFFF"
			else
				dbgReason = reason and format("%x", reason) or ""
			end
			_DBG("|cffffff00Update ... "..dbgReason, true)
		end
		bck_ObjectiveTracker_Update(reason, id)
		OTF.isUpdating = true
		FixedButtonsReanchor()
		if dbChar.collapsed then
			local _, numQuests = GetNumQuestLogEntries()
			local title = ""
			if db.hdrCollapsedTxt == 2 then
				title = "|T"..mediaPath.."KT_logo:22:22:0:1|t"..("%d/%d"):format(numQuests, MAX_QUESTS)
			elseif db.hdrCollapsedTxt == 3 then
				title = "|T"..mediaPath.."KT_logo:22:22:0:1|t"..L("%d/%d Quests"):format(numQuests, MAX_QUESTS)
			end
			OTFHeader.Title:SetText(title)
		end
		if reason == OBJECTIVE_TRACKER_UPDATE_STATIC then
			OTF.isUpdating = false
			return
		elseif not KT.activeTask then
			KT:ToggleEmptyTracker()
		end
		KT:SetSize()
		OTF.isUpdating = false
	end

	function DEFAULT_OBJECTIVE_TRACKER_MODULE:AddObjective(block, objectiveKey, text, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText)  -- RO
		if objectiveKey == "TimeLeft" then
			text, colorStyle = GetTaskTimeLeftData(block.id)
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
				dashStyle = OBJECTIVE_DASH_STYLE_SHOW;
			end
			if ( line.dashStyle ~= dashStyle ) then
				if ( dashStyle == OBJECTIVE_DASH_STYLE_SHOW ) then
					line.Dash:Show();
					line.Dash:SetText(KT_QUEST_DASH);
				elseif ( dashStyle == OBJECTIVE_DASH_STYLE_HIDE ) then
					line.Dash:Hide();
					line.Dash:SetText(KT_QUEST_DASH);
				elseif ( dashStyle == OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE ) then
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
		local height = self:SetStringText(line.Text, text, useFullHeight, colorStyle, block.isHighlighted);
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
		if KT.inWorld and type(objectiveKey) == "string" then
			if strfind(objectiveKey, "Complete") then
				if not questState[block.id] or questState[block.id] ~= "complete" then
					if db.messageQuest then
						KT:SetMessage(block.title, 0, 1, 0, ERR_QUEST_COMPLETE_S, "Interface\\GossipFrame\\ActiveQuestIcon", -2, 0)
					end
					if db.soundQuest then
						KT:PlaySound(db.soundQuestComplete)
					end
					questState[block.id] = "complete"
				end
			elseif strfind(objectiveKey, "Failed") then
				if not questState[block.id] or questState[block.id] ~= "failed" then
					if db.messageQuest then
						KT:SetMessage(block.title, 1, 0, 0, ERR_QUEST_FAILED_S, "Interface\\GossipFrame\\AvailableQuestIcon", -2, 0)
					end
					questState[block.id] = "failed"
				end
			end
		end

		return line;
	end

	function DEFAULT_OBJECTIVE_TRACKER_MODULE:SetStringText(fontString, text, useFullHeight, colorStyle, useHighlight)  -- RO
		if not fontString.KTskinned or KT.forcedUpdate then
			fontString:SetFont(KT.font, db.fontSize, db.fontFlag)
			fontString:SetShadowColor(0, 0, 0, db.fontShadow)
			fontString:SetWordWrap(db.textWordWrap)
			fontString.KTskinned = true
		end
		if self == QUEST_TRACKER_MODULE and not useHighlight then
			useHighlight = fontString:GetParent().isHighlighted		-- Fix bug
		end
		fontString:SetHeight(0)
		fontString:SetText(text)
		local stringHeight = fontString:GetHeight()
		if ( stringHeight > KT_OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT and not useFullHeight ) then
			fontString:SetHeight(KT_OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT)
			stringHeight = KT_OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT
		end
		colorStyle = colorStyle or OBJECTIVE_TRACKER_COLOR["Normal"]
		if ( useHighlight and colorStyle.reverse ) then
			colorStyle = colorStyle.reverse
		end
		if ( fontString.colorStyle ~= colorStyle ) then
			fontString:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			fontString.colorStyle = colorStyle
		end
		return stringHeight
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderEnter", function(self, block)
		local colorStyle
		if self == QUEST_TRACKER_MODULE then
			if block.questCompleted then
				colorStyle = OBJECTIVE_TRACKER_COLOR["CompleteHighlight"]
			elseif db.colorDifficulty then
				_, colorStyle = GetQuestDifficultyColor(block.level)
			end
		end
		if colorStyle then
			block.HeaderText:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.HeaderText.colorStyle = colorStyle
		end

		if db.tooltipShow and (self == QUEST_TRACKER_MODULE or self == ACHIEVEMENT_TRACKER_MODULE) then
			GameTooltip:SetOwner(block, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			if KTF.anchorLeft then
				GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 12, 1)
			else
				GameTooltip:SetPoint("TOPRIGHT", block, "TOPLEFT", -32, 1)
			end
			if self == QUEST_TRACKER_MODULE then
				GameTooltip:SetHyperlink(GetQuestLink(block.id))
				if db.tooltipShowRewards then
					if GetQuestLogRewardXP(block.id) > 0 or
                       GetQuestLogRewardMoney(block.id) > 0 or
                       GetQuestLogRewardArtifactXP(block.id) > 0 or
                       GetNumQuestLogRewardCurrencies(block.id) > 0 or
                       GetQuestLogRewardHonor(block.id) > 0 or
                       GetNumQuestLogRewards(block.id) > 0 then
						GameTooltip:AddLine("\n"..QUEST_REWARDS..":")
						-- xp
						local xp = GetQuestLogRewardXP(block.id)
						if xp > 0 then
							GameTooltip:AddLine(format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, FormatLargeNumber(xp).."|c0000ff00"), 1, 1, 1)
						end
						-- money
						local money = GetQuestLogRewardMoney(block.id)
						if money > 0 then
							GameTooltip:AddLine(GetCoinTextureString(money, 12), 1, 1, 1)
						end
						-- artifact power
						local artifactXP = GetQuestLogRewardArtifactXP(block.id)
						if artifactXP > 0 then
							GameTooltip:AddLine(format(BONUS_OBJECTIVE_ARTIFACT_XP_FORMAT, FormatLargeNumber(artifactXP)), 1, 1, 1)
						end
						-- currencies
						local numQuestCurrencies = GetNumQuestLogRewardCurrencies(block.id)
						for i = 1, numQuestCurrencies do
							local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i, block.id)
							local currencyColor = GetColorForCurrencyReward(currencyID, numItems)
							GameTooltip:AddLine(format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name), currencyColor:GetRGB())
						end
						-- honor
						local honorAmount = GetQuestLogRewardHonor(block.id)
						if honorAmount > 0 then
							GameTooltip:AddLine(format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, "Interface\\ICONS\\Achievement_LegionPVPTier4", honorAmount, HONOR), 1, 1, 1)
						end
						-- items
						local numQuestRewards = GetNumQuestLogRewards(block.id)
						for i = 1, numQuestRewards do
							local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i, block.id)
							local text
							if numItems > 1 then
								text = format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name)
							elseif texture and name then
								text = format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
							end
							if text then
								local color = ITEM_QUALITY_COLORS[quality]
								GameTooltip:AddLine(text, color.r, color.g, color.b)
							end
						end
					end
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
			colorStyle = OBJECTIVE_TRACKER_COLOR["NormalHighlight"]
			block.fixedTag:SetBackdropColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.fixedTag.text:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
		end
	end)

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderLeave", function(self, block)
		local colorStyle
		if self == QUEST_TRACKER_MODULE then
			if block.questCompleted then
				colorStyle = OBJECTIVE_TRACKER_COLOR["Complete"]
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
			colorStyle = OBJECTIVE_TRACKER_COLOR["Normal"]
			block.fixedTag:SetBackdropColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.fixedTag.text:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
		end
	end)

	hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderClick", function(self, block, mouseButton)
		GameTooltip:Hide()
	end)
	hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderClick", function(self, block, mouseButton)
		GameTooltip:Hide()
	end)

	function KT_ObjectiveTrackerBlock_OnEnter(self)
		self.module:OnBlockHeaderEnter(self)
	end

	function KT_ObjectiveTrackerBlock_OnLeave(self)
		self.module:OnBlockHeaderLeave(self)
	end

	function KT_ObjectiveTrackerBlock_OnClick(self, mouseButton)
		self.module:OnBlockHeaderClick(self, mouseButton)
	end

	local bck_ObjectiveTracker_AddBlock = ObjectiveTracker_AddBlock
	ObjectiveTracker_AddBlock = function(block, forceAdd)
		local blockAdded = bck_ObjectiveTracker_AddBlock(block, forceAdd)
		if blockAdded then
			if block.module == BONUS_OBJECTIVE_TRACKER_MODULE or block.module == WORLD_QUEST_TRACKER_MODULE then
				block:SetWidth(240 + 15)
			end
		end
		return blockAdded
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "FreeUnusedLines", function(self, block)
		local colorStyle
		if block.questCompleted then
			colorStyle = OBJECTIVE_TRACKER_COLOR["Complete"]
		elseif db.colorDifficulty and self == QUEST_TRACKER_MODULE then
			colorStyle = GetQuestDifficultyColor(block.level)
		end
		if colorStyle then
			block.HeaderText:SetTextColor(colorStyle.r, colorStyle.g, colorStyle.b)
			block.HeaderText.colorStyle = colorStyle
		end
	end)

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
				tag = CreateFrame("Frame", nil, block)
				tag:SetSize(32, 32)
				tag:SetBackdrop({ bgFile = mediaPath.."UI-KT-QuestItemTag" })
				tag.text = tag:CreateFontString(nil, "ARTWORK", "GameFontNormalMed1")
				tag.text:SetFont(LSM:Fetch("font", "Arial Narrow"), 13, "")
				tag.text:SetPoint("CENTER", -0.5, 1)
			end
			tag:SetPoint(anchor or "TOPRIGHT", block, x, y)
			tag:Show()
			block.fixedTag = tag
		end

		local colorStyle = OBJECTIVE_TRACKER_COLOR["Normal"]
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
				button.Count:SetPoint("BOTTOMRIGHT", button.icon, -3, 2)

				button.Cooldown = CreateFrame("Cooldown", name.."Cooldown", button, "CooldownFrameTemplate")
				button.Cooldown:SetAllPoints()

				button.HotKey = button:CreateFontString(name.."HotKey", "ARTWORK", "NumberFontNormalSmallGray")
				button.HotKey:SetSize(29, 10)
				button.HotKey:SetJustifyH("RIGHT")
				button.HotKey:SetText(RANGE_INDICATOR)
				button.HotKey:SetPoint("TOPRIGHT", button.icon, 2, -2)

				button.text = button:CreateFontString(name.."Text", "ARTWORK", "NumberFontNormalSmall")
				button.text:SetSize(29, 10)
				button.text:SetJustifyH("LEFT")
				button.text:SetPoint("TOPLEFT", button.icon, 1, -3)

				button:RegisterForClicks("AnyUp")

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
				button:SetScript("OnEvent", QuestObjectiveItem_OnEvent)
				button:SetScript("OnUpdate", QuestObjectiveItem_OnUpdate)
				button:SetScript("OnShow", QuestObjectiveItem_OnShow)
				button:SetScript("OnHide", QuestObjectiveItem_OnHide)
				button:SetScript("OnEnter", QuestObjectiveItem_OnEnter)
				button:SetScript("OnLeave", QuestObjectiveItem_OnLeave)
			else
				button.HotKey:Hide()
				button:SetScript("OnEvent", nil)
				button:SetScript("OnUpdate", nil)
				button:SetScript("OnShow", nil)
				button:SetScript("OnHide", nil)
				button:SetScript("OnEnter", ScenarioSpellButton_OnEnter)
				button:SetScript("OnLeave", GameTooltip_Hide)
			end
            button:SetAttribute("type", isSpell and "spell" or "item")
			button:Show()
			KT.fixedButtons[questID] = button
			KTF.Buttons.reanchor = true
		end
		button.block = block
		button:SetAlpha(1)
		if db.qiActiveButton and KTF.ActiveButton.questID == questID then
			KT.ActiveButton:Update(questID)
		end
		return button
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(self, block, text)
		block.lineWidth = block.lineWidth or self.lineWidth - 8		-- mod default
	end)

	local bck_QUEST_TRACKER_MODULE_SetBlockHeader = QUEST_TRACKER_MODULE.SetBlockHeader
	function QUEST_TRACKER_MODULE:SetBlockHeader(block, text, questLogIndex, isQuestComplete, questID)
		local _, level, suggestedGroup, _, _, _, frequency, _ = GetQuestLogTitle(questLogIndex)
		local tagID, _ = GetQuestTagInfo(questID)
		text = KT:CreateQuestTag(level, tagID, frequency, suggestedGroup)..text
		bck_QUEST_TRACKER_MODULE_SetBlockHeader(self, block, text, questLogIndex, isQuestComplete, questID)
		block.lineWidth = block.lineWidth or self.lineWidth - 8		-- mod default
		block.level = level
		block.title = text

		local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex)
		if item and (not isQuestComplete or showItemWhenComplete) then
			block.itemButton:Hide()
			CreateFixedTag(block, 3, 4)
			local button = CreateFixedButton(block)
			if not InCombatLockdown() then
				button:SetID(questLogIndex)
				button.charges = charges
				button.rangeTimer = -1
				button.item = item
				button.link = link
				SetItemButtonTexture(button, item)
				SetItemButtonCount(button, charges)
				QuestObjectiveItem_UpdateCooldown(button)
				button:SetAttribute("item", link)
			end
		else
			KT:RemoveFixedButton(block)
		end
	end

	local bck_QUEST_TRACKER_MODULE_OnFreeBlock = QUEST_TRACKER_MODULE.OnFreeBlock
	function QUEST_TRACKER_MODULE:OnFreeBlock(block)
		KT:RemoveFixedButton(block)
		bck_QUEST_TRACKER_MODULE_OnFreeBlock(self, block)
	end

	local function SetQuestItemButton(block)
		local questLogIndex = GetQuestLogIndexByID(block.id)
		local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex)
		if item and (not isQuestComplete or showItemWhenComplete) then
			block.itemButton:Hide()
			CreateFixedTag(block, 0, 2)
			local button = CreateFixedButton(block)
			if not InCombatLockdown() then
				button:SetID(questLogIndex)
				button.charges = charges
				button.rangeTimer = -1
				button.item = item
				button.link = link
				SetItemButtonTexture(button, item)
				SetItemButtonCount(button, charges)
				QuestObjectiveItem_UpdateCooldown(button)
				button:SetAttribute("item", link)
			end
		else
			KT:RemoveFixedButton(block)
		end
	end

	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "Update", function(self)
		local block, questID, questLogIndex
		local tasksTable = GetTasksTable()
		for i = 1, #tasksTable do
			questID = tasksTable[i]
			questLogIndex = GetQuestLogIndexByID(questID)
			if questLogIndex > 0 and QuestUtils_IsQuestWorldQuest(questID) and not IsWorldQuestWatched(questID) then
				block = self.usedBlocks[questID]
				if block then
					block.TrackedQuest:SetPoint("TOPLEFT", -2, 0)
					SetQuestItemButton(block)
				end
			end
		end
		if self.ShowWorldQuests then
			for i = 1, GetNumWorldQuestWatches() do
				questID = GetWorldQuestWatchInfo(i)
				if questID then
					block = self.usedBlocks[questID]
					if block then
						block.TrackedQuest:SetPoint("TOPLEFT", -2, 0)
						SetQuestItemButton(block)
					end
				end
			end
		end
	end)

	local bck_WORLD_QUEST_TRACKER_MODULE_OnFreeBlock = WORLD_QUEST_TRACKER_MODULE.OnFreeBlock
	function WORLD_QUEST_TRACKER_MODULE:OnFreeBlock(block)
		if KT.activeTask == block.id then
			KT.activeTask = nil
		end
		KT:RemoveFixedButton(block)
		bck_WORLD_QUEST_TRACKER_MODULE_OnFreeBlock(self, block)
    end

    local bck_BONUS_OBJECTIVE_TRACKER_MODULE_OnFreeBlock = BONUS_OBJECTIVE_TRACKER_MODULE.OnFreeBlock
    function BONUS_OBJECTIVE_TRACKER_MODULE:OnFreeBlock(block)
        if KT.activeTask == block.id then
            KT.activeTask = nil
        end
        KT:RemoveFixedButton(block)
        bck_BONUS_OBJECTIVE_TRACKER_MODULE_OnFreeBlock(self, block)
    end

	hooksecurefunc("BonusObjectiveTracker_UntrackWorldQuest", function(questID)
		KT:ToggleEmptyTracker(KT.activeTask)
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
			border2:SetColorTexture(0.3, 0.3, 0.3)

			progressBar.Bar.Label:SetPoint("CENTER", 0, 0.5)
			progressBar.Bar.Label:SetFont(LSM:Fetch("font", "Arial Narrow"), 13, "")
			progressBar.Bar:SetStatusBarTexture(LSM:Fetch("statusbar", db.progressBar))
			progressBar.KTskinned = true
			progressBar.isSkinned = true	-- ElvUI hack

			block.height = block.height + progressBar.height
		end
	end

	local bck_DEFAULT_OBJECTIVE_TRACKER_MODULE_AddProgressBar = DEFAULT_OBJECTIVE_TRACKER_MODULE.AddProgressBar
	function DEFAULT_OBJECTIVE_TRACKER_MODULE:AddProgressBar(block, line, questID)
		local progressBar = bck_DEFAULT_OBJECTIVE_TRACKER_MODULE_AddProgressBar(self, block, line, questID)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	local bck_BONUS_OBJECTIVE_TRACKER_MODULE_AddProgressBar = BONUS_OBJECTIVE_TRACKER_MODULE.AddProgressBar
	function BONUS_OBJECTIVE_TRACKER_MODULE:AddProgressBar(block, line, questID, finished)
		local progressBar = bck_BONUS_OBJECTIVE_TRACKER_MODULE_AddProgressBar(self, block, line, questID, finished)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	local bck_WORLD_QUEST_TRACKER_MODULE_AddProgressBar = WORLD_QUEST_TRACKER_MODULE.AddProgressBar
	function WORLD_QUEST_TRACKER_MODULE:AddProgressBar(block, line, questID, finished)
		local progressBar = bck_WORLD_QUEST_TRACKER_MODULE_AddProgressBar(self, block, line, questID, finished)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	BonusObjectiveTrackerProgressBar_UpdateReward = function(progressBar)
		progressBar.Bar.Icon:Hide()
		progressBar.Bar.IconBG:Hide()
		progressBar.needsReward = nil
	end

	hooksecurefunc("BonusObjectiveTracker_OnTaskCompleted", function(questID, xp, money)
		if KT.activeTask == questID then
			KT.activeTask = nil
		end
		--KT_BonusObjectiveTracker_UntrackWorldQuest(questID)
	end)

	local bck_BonusObjectiveTracker_ShowRewardsTooltip = BonusObjectiveTracker_ShowRewardsTooltip
	BonusObjectiveTracker_ShowRewardsTooltip = function(block)
		if db.tooltipShow then
			bck_BonusObjectiveTracker_ShowRewardsTooltip(block)
			GameTooltip:ClearAllPoints()
			if KTF.anchorLeft then
				GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 9, -2)
			else
				GameTooltip:SetPoint("TOPRIGHT", block, "TOPLEFT", -12, -2)
			end

			if block.module.ShowWorldQuests and HaveQuestData(block.id) and
					GetQuestLogRewardXP(block.id) == 0 and
					GetNumQuestLogRewardCurrencies(block.id) == 0 and
					GetNumQuestLogRewards(block.id) == 0 and
					GetQuestLogRewardMoney(block.id) == 0 and
					GetQuestLogRewardArtifactXP(block.id) == 0 and
					GetQuestLogRewardHonor(block.id) == 0 then
				GameTooltip:SetOwner(block, "ANCHOR_PRESERVE")
				GameTooltip:AddLine(RETRIEVING_DATA, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
				GameTooltip:Show()
			elseif HaveQuestData(block.id) then
				if db.tooltipShowID then
					GameTooltip:AddLine(" ")
					GameTooltip:AddDoubleLine(" ", "ID: |cffffffff"..block.id)
					GameTooltip:Show()
				end
			end
		end
	end

	local bck_SCENARIO_CONTENT_TRACKER_MODULE_Update = SCENARIO_CONTENT_TRACKER_MODULE.Update
	function SCENARIO_CONTENT_TRACKER_MODULE:Update()
		local _, _, numStages, _ = C_Scenario.GetInfo()
		local BlocksFrame = SCENARIO_TRACKER_MODULE.BlocksFrame
		self.topBlock = nil
		self.lastBlock = nil
		bck_SCENARIO_CONTENT_TRACKER_MODULE_Update(self)
		if numStages > 0 and BlocksFrame.currentStage ~= currentStage and BlocksFrame.currentBlock then
			self.lastBlock = ScenarioBlocksFrame
		end
	end

	local bck_SCENARIO_TRACKER_MODULE_AddProgressBar = SCENARIO_TRACKER_MODULE.AddProgressBar
	function SCENARIO_TRACKER_MODULE:AddProgressBar(block, line, criteriaIndex)
		local progressBar = bck_SCENARIO_TRACKER_MODULE_AddProgressBar(self, block, line, criteriaIndex)
		SetProgressBarStyle(progressBar)
		return progressBar
	end

	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "AddSpells", function(self, objectiveBlock, spellInfo)
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
			end
		end
		for i = objectiveBlock.numSpells + 1, #objectiveBlock.spells do
			KT:RemoveFixedButton(objectiveBlock.spells[i])
		end
	end)

	ScenarioStageBlock:HookScript("OnEnter", function(self)
		GameTooltip:ClearAllPoints()
		if KTF.anchorLeft then
			GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 59, -1)
		else
			GameTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT",  -16, -1)
		end
	end)

	hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, "EndLayout", function(self)
		for i = 1, GetNumAutoQuestPopUps() do
			local questID, popUpType = GetAutoQuestPopUp(i)
			if not IsQuestBounty(questID) then
				local questTitle = GetQuestLogTitle(GetQuestLogIndexByID(questID))
				if questTitle and questTitle ~= "" then
					local block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(questID)
					block.height = 68	-- fix
					local blockContents = block.ScrollChild
					blockContents.QuestName:SetFont(KT.font, 14, "")
					blockContents.BottomText:SetPoint("BOTTOM", 0, 7)
				end
			end
		end
	end)

	function ObjectiveTracker_Collapse()
		_DBG("--------------------------------")
		_DBG("COLLAPSE")
		OTF.collapsed = true
		dbChar.collapsed = OTF.collapsed
		OTF.BlocksFrame:Hide()
		KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.25)
		OTFHeader.Title:Show()
		MSA_CloseDropDownMenus()
		KT.animTask = false
	end

	function ObjectiveTracker_Expand()
		_DBG("--------------------------------")
		_DBG("EXPAND")
		OTF.collapsed = nil
		dbChar.collapsed = OTF.collapsed
		OTF.BlocksFrame:Show()
		KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.25, 0.5)
		OTFHeader.Title:Hide()
		MSA_CloseDropDownMenus()
	end

	function QuestObjectiveTracker_UntrackQuest(dropDownButton, questID)
		KT.stopUpdate = true
		local superTrackedQuestID = GetSuperTrackedQuestID()
		local questLogIndex = GetQuestLogIndexByID(questID)
		RemoveQuestWatch(questLogIndex)
		if questID == superTrackedQuestID then
			QuestSuperTracking_OnQuestUntracked()
		end
		KT.stopUpdate = false
		ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_QUEST)
	end

	local bck_BonusObjectiveTracker_OnBlockAnimOutFinished = BonusObjectiveTracker_OnBlockAnimOutFinished
	BonusObjectiveTracker_OnBlockAnimOutFinished = function(self)
		KT.activeTask = nil
		bck_BonusObjectiveTracker_OnBlockAnimOutFinished(self)
		KT.animTask = false
	end

	hooksecurefunc("BonusObjectiveTracker_SetBlockState", function(block, state, force)
		if state == "ENTERING" then
			_DBG(" - "..state)
			KT.activeTask = block.id
			KT:ToggleEmptyTracker(true)
		elseif state == "PRESENT" and not KT.activeTask then
			_DBG(" - "..state)
			KT.activeTask = block.id
			if not IsWorldQuestWatched(block.id) then
				KT:ToggleEmptyTracker(KT.initialized)
			end
		elseif state == "LEAVING" and KT.activeTask then
			_DBG(" - "..state)
			KT:RemoveFixedButton(block)
			if dbChar.collapsed then
				BonusObjectiveTracker_OnBlockAnimOutFinished(block.ScrollContents)
			end
		end
	end)

	local bck_ObjectiveTracker_ReorderModules = ObjectiveTracker_ReorderModules
	ObjectiveTracker_ReorderModules = function()
		local reorder = false
		for i = 1, #OTF.MODULES do
			if OTF.MODULES[i] ~= OTF.MODULES_UI_ORDER[i] then
				reorder = true
				break
			end
		end
		if reorder then
			bck_ObjectiveTracker_ReorderModules()
		end
	end

	local bck_QuestPOI_GetButton = QuestPOI_GetButton
	QuestPOI_GetButton = function(parent, questID, style, index)
		local poiButton = bck_QuestPOI_GetButton(parent, questID, style, index)
		poiButton.Glow.Show = function() end
		return poiButton
	end

	hooksecurefunc("WorldMap_SetupWorldQuestButton", function(button, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget, isEffectivelyTracked)
        button.Glow:SetShown(false)
    end)

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

	-- Item handler functions
	--[=[
	function QuestObjectiveItem_OnEnter(self)  -- R
		if self.block then self.block.module:OnBlockHeaderEnter(self.block) end
		if KTF.anchorLeft then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 3)
		else
			GameTooltip:SetOwner(self, "ANCHOR_LEFT", -3)
		end
		GameTooltip:SetQuestLogSpecialItem(self:GetID())
	end
	--]=]

	function QuestObjectiveItem_OnLeave(self)
		self.block.module:OnBlockHeaderLeave(self.block)
		GameTooltip:Hide()
	end

	function QuestObjectiveItem_OnUpdate(self, elapsed)  -- R
		local rangeTimer = self.rangeTimer
		if rangeTimer then
			rangeTimer = rangeTimer - elapsed
			if rangeTimer <= 0 then
				local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(self:GetID())
				if charges and charges ~= self.charges then
					ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_QUEST)
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

	-- DropDown
	function ObjectiveTracker_ToggleDropDown(frame, handlerFunc)  -- R
		local dropDown = KT.DropDown;
		if ( dropDown.activeFrame ~= frame ) then
			MSA_CloseDropDownMenus();
		end
		dropDown.activeFrame = frame;
		dropDown.initialize = handlerFunc;
		MSA_ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3, nil, nil, MSA_DROPDOWNMENU_SHOW_TIME);
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

	function QUEST_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)  -- R
		if ( ChatEdit_TryInsertQuestLinkForQuestID(block.id) ) then
			return;
		end

		if ( mouseButton ~= "RightButton" ) then
			MSA_CloseDropDownMenus();
			if ( IsModifiedClick("QUESTWATCHTOGGLE") ) then
				QuestObjectiveTracker_UntrackQuest(nil, block.id);
			elseif IsModifiedClick(db.menuWowheadURLModifier) then
				KT:ShowPopup("quest", block.id)
			else
				local questLogIndex = GetQuestLogIndexByID(block.id);
				if ( IsQuestComplete(block.id) and GetQuestLogIsAutoComplete(questLogIndex) ) then
					AutoQuestPopupTracker_RemovePopUp(block.id);
					ShowQuestComplete(questLogIndex);
				else
					if db.questDefaultActionMap then
                        QuestMapFrame_OpenToQuestDetails(block.id);
					else
						QuestLogPopupDetailFrame_Show(questLogIndex);
					end
				end
			end
			return;
		else
			ObjectiveTracker_ToggleDropDown(block, QuestObjectiveTracker_OnOpenDropDown);
		end
	end

	function QuestObjectiveTracker_OnOpenDropDown(self)  -- R
		local block = self.activeFrame;
		local questLogIndex = GetQuestLogIndexByID(block.id);

		local info = MSA_DropDownMenu_CreateInfo();
		info.text = GetQuestLogTitle(questLogIndex);
		info.isTitle = 1;
		info.notCheckable = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info = MSA_DropDownMenu_CreateInfo();
		info.notCheckable = 1;

		info.text = OBJECTIVES_VIEW_IN_QUESTLOG;
		info.func = QuestObjectiveTracker_OpenQuestDetails;
		info.arg1 = block.id;
		info.noClickSound = 1;
		info.checked = false;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.text = OBJECTIVES_SHOW_QUEST_MAP;
		info.func = QuestObjectiveTracker_OpenQuestMap;
		info.arg1 = block.id;
		info.checked = false;
		info.noClickSound = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		if ( GetQuestLogPushable(questLogIndex) and IsInGroup() ) then
			info.text = SHARE_QUEST;
			info.func = QuestObjectiveTracker_ShareQuest;
			info.arg1 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end

		info.text = OBJECTIVES_STOP_TRACKING;
		info.func = QuestObjectiveTracker_UntrackQuest;
		info.arg1 = block.id;
		info.checked = false;
		info.disabled = (db.filterAuto[1]);
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.disabled = false;

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.ShowPopup;
			info.arg1 = "quest";
			info.arg2 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	function ACHIEVEMENT_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)  -- R
		if ( IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() ) then
			local achievementLink = GetAchievementLink(block.id);
			if ( achievementLink ) then
				ChatEdit_InsertLink(achievementLink);
			end
		elseif ( mouseButton ~= "RightButton" ) then
			MSA_CloseDropDownMenus();
			if ( not AchievementFrame ) then
				AchievementFrame_LoadUI();
			end
			if ( IsModifiedClick("QUESTWATCHTOGGLE") ) then
				AchievementObjectiveTracker_UntrackAchievement(_, block.id);
			elseif IsModifiedClick(db.menuWowheadURLModifier) then
				KT:ShowPopup("achievement", block.id)
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
			ObjectiveTracker_ToggleDropDown(block, AchievementObjectiveTracker_OnOpenDropDown);
		end
	end

	function AchievementObjectiveTracker_OnOpenDropDown(self)  -- R
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
		info.func = AchievementObjectiveTracker_UntrackAchievement;
		info.arg1 = block.id;
		info.checked = false;
		info.disabled = (db.filterAuto[2]);
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		info.disabled = false;

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.ShowPopup;
			info.arg1 = "achievement";
			info.arg2 = block.id;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	function BonusObjectiveTracker_OnBlockClick(self, button)	-- R
		if self.module.ShowWorldQuests then
			if button == "LeftButton" then
				if ( not ChatEdit_TryInsertQuestLinkForQuestID(self.TrackedQuest.questID) ) then
					MSA_CloseDropDownMenus();
					if IsShiftKeyDown() then
						if IsWorldQuestWatched(self.TrackedQuest.questID) then
							BonusObjectiveTracker_UntrackWorldQuest(self.TrackedQuest.questID);
						end
					elseif IsModifiedClick(db.menuWowheadURLModifier) then
						KT:ShowPopup("quest", self.TrackedQuest.questID)
					else
						local mapID = C_TaskQuest.GetQuestZoneID(self.TrackedQuest.questID);
						if mapID then
							QuestMapFrame_CloseQuestDetails();
							OpenQuestLog(mapID);
							WorldMapPing_StartPingQuest(self.TrackedQuest.questID);
						end
					end
				end
			elseif button == "RightButton" then
				ObjectiveTracker_ToggleDropDown(self, BonusObjectiveTracker_OnOpenDropDown);
			end
		end
	end

	function BonusObjectiveTracker_OnOpenDropDown(self)  -- R
		local block = self.activeFrame;
		local questID = block.TrackedQuest.questID;
		local addStopTracking = IsWorldQuestWatched(questID);

		-- Ensure at least one option will appear before showing the dropdown.
		if not addStopTracking then
			return;
		end

		-- Add title
		local info = MSA_DropDownMenu_CreateInfo();
		info.text = C_TaskQuest.GetQuestInfoByQuestID(questID);
		info.isTitle = 1;
		info.notCheckable = 1;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);

		-- Add "stop tracking"
		if IsWorldQuestWatched(questID) then
			info = MSA_DropDownMenu_CreateInfo();
			info.notCheckable = true;
			info.text = OBJECTIVES_STOP_TRACKING;
			info.func = function()
				--KT_BonusObjectiveTracker_UntrackWorldQuest(questID);
				BonusObjectiveTracker_UntrackWorldQuest(questID);
			end
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.ShowPopup;
			info.arg1 = "quest";
			info.arg2 = questID;
			info.checked = false;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end
end

--------------
-- External --
--------------

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
		if BONUS_OBJECTIVE_TRACKER_MODULE.firstBlock then
			mod = mod + BONUS_OBJECTIVE_TRACKER_MODULE.blockPadding
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
		OTF.height = height - 10
		OTF:SetHeight(OTF.height)
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

function KT:MoveTracker()
	KTF:ClearAllPoints()
	KTF:SetPoint(db.anchorPoint, UIParent, db.anchorPoint, db.xOffset, db.yOffset)
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

	options.maxHeight.max = self.screenHeight - abs(db.yOffset)
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

	KT_OBJECTIVE_TRACKER_DOUBLE_LINE_HEIGHT = (2 * db.fontSize) + 1

	-- Headers
	SetHeaders("text")
	-- Others
	ScenarioStageBlock.Stage:SetFont(self.font, db.fontSize+5, db.fontFlag)
end

function KT:SaveHeader(module)
	tinsert(KT.headers, module.Header)
	module.title = module.Header.Text:GetText()
	module.Header.Text:SetWidth(165)
end

function KT:SetHeaderText(module, append)
	local text = module.title
	if append then
		text = format("%s (%s)", text, append)
	end
	module.Header.Text:SetText(text)
end

function KT:SetQuestsHeaderText(reset)
	if db.hdrQuestsTitleAppend then
		local _, numQuests = GetNumQuestLogEntries()
		self:SetHeaderText(QUEST_TRACKER_MODULE, numQuests.."/"..MAX_QUESTS)
	elseif reset then
		self:SetHeaderText(QUEST_TRACKER_MODULE)
	end
end

function KT:SetAchievsHeaderText(reset)
	if db.hdrAchievsTitleAppend then
		self:SetHeaderText(ACHIEVEMENT_TRACKER_MODULE, GetTotalAchievementPoints())
	elseif reset then
		self:SetHeaderText(ACHIEVEMENT_TRACKER_MODULE)
	end
end

function KT:ToggleOtherButtons()
	if not db.hdrOtherButtons then
		if KTF.QuestLogButton then
			KTF.QuestLogButton:Hide()
			KTF.AchievementsButton:Hide()
			OTFHeader.Title:SetWidth(OTFHeader.Title:GetWidth() + 40)
		end
		return
	end
	OTFHeader.Title:SetWidth(OTFHeader.Title:GetWidth() - 40)
	if KTF.QuestLogButton then
		KTF.QuestLogButton:Show()
		KTF.AchievementsButton:Show()
	else
		local button
		-- Achievements button
		button = CreateFrame("Button", addonName.."AchievementsButton", KTF)
		button:SetSize(16, 16)
		button:SetPoint("TOPRIGHT", (KTF.FilterButton or KTF.MinimizeButton), "TOPLEFT", -4, 0)
		button:SetFrameLevel(KTF:GetFrameLevel() + 10)
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
		button = CreateFrame("Button", addonName.."QuestLogButton", KTF)
		button:SetSize(16, 16)
		button:SetPoint("TOPRIGHT", KTF.AchievementsButton, "TOPLEFT", -4, 0)
		button:SetFrameLevel(KTF:GetFrameLevel() + 10)
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

	if questTag == Enum.QuestTag.Group then
		tag = "g"
		if suggestedGroup > 0 then
			tag = tag..suggestedGroup
		end
	elseif questTag == Enum.QuestTag.Pvp then
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

	if frequency == 2 then
		tag = tag.."!"	-- daily quest
	elseif frequency == 3 then
		tag = tag.."!!"	-- weekly quest
	end

	if tag ~= "" then
		tag = ("|cff00b3ff%s|r"):format(tag)
	end

	tag = ("[%s%s] "):format(level, tag)
	return tag
end

function KT:IsTrackerEmpty(noaddon)
	local result = (GetNumQuestWatches() == 0 and
		GetNumAutoQuestPopUps() == 0 and
		GetNumTrackedAchievements() == 0 and
		not self.activeTask and
		GetNumWorldQuestWatches() == 0 and
		not C_Scenario.IsInScenario())
	if not noaddon then
		result = (result and not self.AddonPetTracker:IsShown())
	end
	return result
end

function KT:ToggleEmptyTracker(added)
	local alpha, mouse = 1, true
	if self:IsTrackerEmpty() then
		if not dbChar.collapsed then
			ObjectiveTracker_MinimizeButton_OnClick()
		end
		KTF.MinimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 0.75)
		if db.hideEmptyTracker then
			alpha = 0
			mouse = false
		end
	else
		if dbChar.collapsed then
			if added then
				ObjectiveTracker_MinimizeButton_OnClick()
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

function KT:SetMessage(text, r, g, b, pattern, icon, x, y)
	if pattern then
		text = format(pattern, text.." ...")
	end
	if icon then
		x = x or 0
		y = y or 0
		if db.sink20OutputSink == "Blizzard" then
			x = floor(x * 3 * COMBAT_TEXT_X_SCALE)
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

StaticPopupDialogs[addonName.."_WowheadURL"] = {
	text = "|T"..mediaPath.."KT_logo:22:22:0:-1|t"..NORMAL_FONT_COLOR_CODE..KT.title.."|r - Wowhead URL",
	button2 = CLOSE,
	hasEditBox = 1,
	editBoxWidth = 300,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	OnShow = function(self)
		local name = "..."
		if self.text.text_arg1 == "quest" then
			name = QuestUtils_GetQuestName(self.text.text_arg2)
		elseif self.text.text_arg1 == "achievement" then
			name = select(2, GetAchievementInfo(self.text.text_arg2))
		end
		local www = KT.locale:sub(1, 2)
		if www == "zh" then www = "cn" end
		self.text:SetText(self.text:GetText().."\n|cffff7f00"..name.."|r")
		self.editBox:SetText("http://"..www..".wowhead.com/"..self.text.text_arg1.."="..self.text.text_arg2)
		self.editBox:SetFocus()
		self.editBox:HighlightText()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

function KT:ShowPopup(type, id)
	StaticPopup_Show(addonName.."_WowheadURL", type, id)
end

-- Load ----------------------------------------------------------------------------------------------------------------

function KT:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)

	SLASH_KALIELSTRACKER1, SLASH_KALIELSTRACKER2 = "/kt", "/kalielstracker"
	SlashCmdList["KALIELSTRACKER"] = SlashHandler

	SetMsgPatterns()

	-- Get character data
	self.playerName = UnitName("player")
	self.playerLevel = UnitLevel("player")
	local _, class = UnitClass("player")
	self.classColor = RAID_CLASS_COLORS[class]

	self.headers = {}
	self.borderColor = {}
	self.hdrBtnColor = {}
	self.fixedButtons = {}
	self.activeTask = nil
	self.animTask = false
	self.inWorld = false
	self.inInstance = IsInInstance()
	self.stopUpdate = true
	self.questStateStopUpdate = false
	self.wqInitialized = false
	self.initialized = false

	-- Setup Options
	self:SetupOptions()
	db = self.db.profile
	dbChar = self.db.char

	-- Blizzard frame resets
	OTF.IsUserPlaced = function() return true end
	OTF.KTSetParent = OTF.SetParent
	OTF.SetParent = function() end
	OTF.SetFrameStrata = function() end
	OTF.SetFrameLevel = function() end
	OTF:SetClampedToScreen(false)
	OTF.SetClampedToScreen = function() end
	OTF:EnableMouse(false)
	OTF.EnableMouse = function() end
	OTF:SetMovable(false)
	OTF.SetMovable = function() end
	OTF:ClearAllPoints()
	OTF.ClearAllPoints = function() end
	OTF.SetAllPoints = function() end
	OTF.KTSetPoint = OTF.SetPoint
	OTF.SetPoint = function() end
	OTF:Show()
	OTF.Show = function() end
	OTF.Hide = function() end
	OTF.SetShown = function() end
end

function KT:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetFrames()
	SetHooks()

	self.QuestLog:Enable()
	self.Filters:Enable()
	if self.AddonPetTracker.isLoaded then self.AddonPetTracker:Enable() end
	if self.AddonTomTom.isLoaded then self.AddonTomTom:Enable() end
	self.AddonOthers:Enable()
	if db.qiActiveButton then self.ActiveButton:Enable() end
	--self.Help:Enable()

	if self.db.global.version ~= self.version then
		self.db.global.version = self.version
	end

	self.screenWidth = round(GetScreenWidth())
	self.screenHeight = round(GetScreenHeight())
end
