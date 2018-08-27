--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_AddonPetTracker")
KT.AddonPetTracker = M

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db, dbChar
local OTF = ObjectiveTrackerFrame
local PetTracker = PetTracker

local eventFrame
local header, content
local filterButton

OBJECTIVE_TRACKER_UPDATE_MODULE_PETTRACKER = 0x100000
OBJECTIVE_TRACKER_UPDATE_PETTRACKER = 0x200000
PETTRACKER_TRACKER_MODULE = ObjectiveTracker_GetModuleInfoTable()

--------------
-- Internal --
--------------

local function SetHooks_Disabled()
	if not db.addonPetTracker and PetTracker then
		PetTracker.Objectives.Startup = function() end
	end
end

local function SetHooks()
	hooksecurefunc("ObjectiveTracker_Initialize", function(self)
		tinsert(self.MODULES, PETTRACKER_TRACKER_MODULE)
		tinsert(self.MODULES_UI_ORDER, PETTRACKER_TRACKER_MODULE)
	end)

	function PetTracker.Objectives:Startup()	-- R
		self:SetScript("OnEvent", self.TrackingChanged)
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

		self:SetParent(content)
		self.Anchor:SetWidth(content:GetWidth())
		self.Anchor:SetPoint("TOPLEFT", content, -10, 0)
		self.Header = header
		self.maxEntries = 100
	end

	function PetTracker.Objectives:TrackingChanged()	-- R
		if not PetTracker.Sets.HideTracker then
			self:Update()
		end
		self:SetShown(not PetTracker.Sets.HideTracker and self.Anchor:IsShown())
		ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_PETTRACKER)
	end
	
	function PetTracker.Tracker:AddSpecie(specie, quality, level)	-- R
		local Journal = PetTracker.Journal
		local sourceIcon = Journal:GetSourceIcon(specie)
		if sourceIcon then
			-- original code
			local name, icon = Journal:GetInfo(specie)
			local r,g,b = self:GetColor(quality)
			local line = self:NewLine()
			line.Text:SetText(name .. (level > 0 and format(' (%s)', level) or ''))
			line.SubIcon:SetTexture(sourceIcon)
			line.Icon:SetTexture(icon)
			line:SetScript('OnClick', function()
				Journal:Display(specie)
			end)
			line:SetScript('OnEnter', function()
				line.Text:SetTextColor(r, g, b)
			end)
			line:SetScript('OnLeave', function()
				line.Text:SetTextColor(r-.2, g-.2, b-.2)
			end)
			line:GetScript('OnLeave')(line)
			-- added code
			line.Text:SetWidth(self.Anchor:GetWidth() - line.Icon:GetWidth() - 10)
			line.Text:SetFont(KT.font, db.fontSize, db.fontFlag)
			line.Text:SetShadowColor(0, 0, 0, db.fontShadow)
			line.Text:SetWordWrap(false)
			line.Text:ClearAllPoints()
			line.Text:SetPoint("LEFT", line.Icon, "RIGHT", 10, 0)
			line:SetParent(OTF.BlocksFrame)
		end
	end

	-- Disable DropDown (it was moved to filters menu)
	PetTracker.Tracker.ShowOptions = function() end

	-- WorldMap (for hacked Sushi Lib)
	hooksecurefunc(PetTracker.MapFilter, "Init", function(self, frame)
		if not filterButton then
			for i, overlay in ipairs(frame.overlayFrames or {}) do
				if overlay.OnClick == WorldMapTrackingOptionsButtonMixin.OnClick then
					filterButton = overlay
					break
				end
			end
		end
	end)

	hooksecurefunc(PetTracker.MapFilter, "UpdateFrames", function(self)
		SushiDropFrame:CloseAll()
		SushiDropFrame:Toggle("TOPLEFT", filterButton, "BOTTOMLEFT", 0, -15, true, self.ShowTrackingTypes)
	end)

	-- Sushi Lib - hack - revert back DropDownMenu
	if SushiDropFrame then
		local dropDownFrame = MSA_DropDownMenu_Create("SushiDropDownFrameFix")
		function dropDownFrame:AddLine(data)
			MSA_DropDownMenu_AddButton(data)
		end

		function SushiDropFrame:Toggle(...)
			local n = select("#", ...)
			if n < 4 then
				dropDownFrame.relativeTo = ...
			else
				dropDownFrame.point, dropDownFrame.relativeTo, dropDownFrame.relativePoint, dropDownFrame.xOffset, dropDownFrame.yOffset = ...
				if dropDownFrame.yOffset < 0 then
					dropDownFrame.yOffset = dropDownFrame.yOffset + 10
				else
					dropDownFrame.yOffset = dropDownFrame.yOffset - 10
				end
			end
			dropDownFrame.initialize = select(n, ...)
			dropDownFrame.displayMode = "MENU"
			if self.target ~= dropDownFrame.relativeTo then
				MSA_CloseDropDownMenus()
			end
			self.target = dropDownFrame.relativeTo
			MSA_ToggleDropDownMenu(1, nil, dropDownFrame)
		end

		function SushiDropFrame:Display(...)
			self.target = nil
			self:Toggle(...)
		end

		function SushiDropFrame:CloseAll()
			MSA_CloseDropDownMenus()
		end
	end
end

local function SetHooks_PetTracker_Journal()
	if not db.addonPetTracker and PetTracker then
		PetTrackerTrackToggle:Disable()
		PetTrackerTrackToggle.Text:SetTextColor(0.5, 0.5, 0.5)
		local infoFrame = CreateFrame("Frame", nil, PetJournal)
		infoFrame:SetPoint("TOPLEFT", PetTrackerTrackToggle, 0, 0)
		infoFrame:SetPoint("BOTTOMRIGHT", PetTrackerTrackToggle, PetTrackerTrackToggle.Text:GetWidth() + 3, 3)
		infoFrame:SetFrameLevel(PetTrackerTrackToggle:GetFrameLevel() + 1)
		infoFrame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:AddLine(PetTracker.Locals.ZoneTracker, 1, 1, 1)
			GameTooltip:AddLine("Support can be enabled inside addon "..KT.title, 1, 0, 0, true)
			GameTooltip:Show()
		end)
		infoFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	else
		PetTrackerTrackToggle:HookScript("OnClick", function()
			if dbChar.collapsed and not PetTracker.Sets.HideTracker then
				ObjectiveTracker_MinimizeButton_OnClick()
			end
		end)

		CollectionsJournal:HookScript("OnHide", function()
			KT.SetMapToCurrentZone()
		end)
	end
end

local function SetFrames_Init()
	-- Event frame
	if not eventFrame then
		eventFrame = CreateFrame("Frame")
		eventFrame:SetScript("OnEvent", function(self, event, arg1)
			_DBG("Event - "..event.." - "..tostring(arg1), true)
			if event == "ADDON_LOADED" and arg1 == "PetTracker_Journal" then
				SetHooks_PetTracker_Journal()
				self:UnregisterEvent(event)
			elseif event == "PLAYER_ENTERING_WORLD" then
				self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
				self:UnregisterEvent(event)
			elseif event == "PET_JOURNAL_LIST_UPDATE" then
				M:SetPetsHeaderText()
			end
		end)
	end
	if not IsAddOnLoaded("PetTracker_Journal") then
		eventFrame:RegisterEvent("ADDON_LOADED")
	else
		SetHooks_PetTracker_Journal()
	end
end

local function SetFrames()
	-- Header frame
	header = CreateFrame("Frame", nil, OTF.BlocksFrame, "ObjectiveTrackerHeaderTemplate")
	header:Hide()

	-- Content frame
	content = CreateFrame("Frame", nil, OTF.BlocksFrame)
	content:SetSize(232 - PETTRACKER_TRACKER_MODULE.blockOffsetX, 10)
	content:Hide()
end

--------------
-- External --
--------------

function PETTRACKER_TRACKER_MODULE:GetBlock()
	local block = content
	block.module = self
	block.used = true
	block.height = 0
	block.lineWidth = OBJECTIVE_TRACKER_TEXT_WIDTH - self.blockOffsetX
	block.currentLine = nil
	if block.lines then
		for _, line in ipairs(block.lines) do
			line.used = nil
		end
	else
		block.lines = {}
	end
	return block
end

function PETTRACKER_TRACKER_MODULE:MarkBlocksUnused()
	content.used = nil
end

function PETTRACKER_TRACKER_MODULE:FreeUnusedBlocks()
	if not content.used then
		content:Hide()
	end
end

function PETTRACKER_TRACKER_MODULE:Update()
	self:BeginLayout()
	if PetTracker.Objectives:IsShown() then
		local block = self:GetBlock()
		block.height = PetTracker.Objectives:GetHeight() - 45
		block:SetHeight(block.height)
		if ObjectiveTracker_AddBlock(block) then
			block:Show()
			self:FreeUnusedLines(block)
		else
			block.used = nil
		end
	end
	self:EndLayout()
end

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
	dbChar = KT.db.char
	self.isLoaded = (KT:CheckAddOn("PetTracker", "8.0.5") and db.addonPetTracker)

	if self.isLoaded then
		tinsert(KT.db.defaults.profile.modulesOrder, "PETTRACKER_TRACKER_MODULE")
		KT.db:RegisterDefaults(KT.db.defaults)
	else
		for i, module in ipairs(db.modulesOrder) do
			if module == "PETTRACKER_TRACKER_MODULE" then
				tremove(db.modulesOrder, i)
				break
			end
		end
	end

	SetFrames_Init()
	SetHooks_Disabled()
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetFrames()
	SetHooks()

	PETTRACKER_TRACKER_MODULE.updateReasonModule = OBJECTIVE_TRACKER_UPDATE_MODULE_PETTRACKER
	PETTRACKER_TRACKER_MODULE.updateReasonEvents = OBJECTIVE_TRACKER_UPDATE_PETTRACKER
	PETTRACKER_TRACKER_MODULE:SetHeader(header, PETS)

	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function M:IsShown()
	return (self.isLoaded and
		(PetTracker.Sets and not PetTracker.Sets.HideTracker) and
		PetTracker.Objectives:IsShown())
end

function M:SetPetsHeaderText(reset)
	if self.isLoaded and db.hdrPetTrackerTitleAppend then
		local _, numPetsOwned = C_PetJournal.GetNumPets()
		KT:SetHeaderText(PETTRACKER_TRACKER_MODULE, numPetsOwned)
	elseif reset then
		KT:SetHeaderText(PETTRACKER_TRACKER_MODULE)
	end
end
