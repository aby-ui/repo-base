--- Kaliel's Tracker
--- Copyright (c) 2012-2020, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_AddonPetTracker")
KT.AddonPetTracker = M

local LSM = LibStub("LibSharedMedia-3.0")
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

M.Texts = {
	TrackPets = GetSpellInfo(122026),
	CapturedPets = "Show Captured",
}

--------------
-- Internal --
--------------

local function SetHooks_Init()
	if PetTracker then
		PetTracker.Objectives.OnEnable = function() end

		if not db.addonPetTracker then
			PetTracker.Objectives.Update = function() end
		end
	end
end

local function SetHooks()
	hooksecurefunc("ObjectiveTracker_Initialize", function(self)
		tinsert(self.MODULES, PETTRACKER_TRACKER_MODULE)
		tinsert(self.MODULES_UI_ORDER, PETTRACKER_TRACKER_MODULE)
	end)

	function PetTracker.Objectives:Update()  -- R
		if PetTracker.sets.trackPets then
			self:GetClass().Update(self)
		end
		self:SetShown(PetTracker.sets.trackPets and self.Anchor:IsShown())
		ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_PETTRACKER)
	end
	
	function PetTracker.Tracker:AddSpecie(specie, quality, level)  -- R
		local source = specie:GetSourceIcon()
		if source then
			-- Specie Class fix
			-- TODO: After fix in PetTracker, delete it.
			function specie:GetID()
				local best = self:GetBestOwned()
				return best and best:GetID() or nil
			end
			-- original code
			local name, icon = specie:GetInfo()
			local text = name .. (level > 0 and format(' (%s)', level) or '')
			local r,g,b = self:GetColor(quality)

			local line = self:Add(text, icon, source, r,g,b)
			line:SetScript('OnClick', function() specie:Display() end)
			-- added code
			line.Dash:SetText("")
			line.SubIcon:ClearAllPoints()
			line.SubIcon:SetPoint("TOPLEFT", 0, 0)
			line.Icon:ClearAllPoints()
			line.Icon:SetPoint("LEFT", line.SubIcon, "RIGHT", 5, 0)
			line.Text:SetWidth(self.Anchor:GetWidth() - line.Icon:GetWidth() - line.SubIcon:GetWidth() - 10)
			line.Text:ClearAllPoints()
			line.Text:SetPoint("LEFT", line.Icon, "RIGHT", 5, 0)
			line.Text:SetFont(KT.font, db.fontSize, db.fontFlag)
			line.Text:SetShadowColor(0, 0, 0, db.fontShadow)
			line.Text:SetWordWrap(false)
			line:SetParent(OTF.BlocksFrame)
		end
	end

	hooksecurefunc(PetTracker.ProgressBar, "SetProgress", function(self, progress)
		if not self.KTskinned or KT.forcedUpdate then
			for _, bar in ipairs(self.Bars) do
				bar:SetStatusBarTexture(LSM:Fetch("statusbar", db.progressBar))
			end
			self.KTskinned = true
		end
	end)
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
			GameTooltip:AddLine(M.Texts.TrackPets, 1, 1, 1)
			GameTooltip:AddLine("Support can be enabled inside addon "..KT.title, 1, 0, 0, true)
			GameTooltip:Show()
		end)
		infoFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	else
		PetTrackerTrackToggle:HookScript("OnClick", function()
			if dbChar.collapsed and PetTracker.sets.trackPets then
				ObjectiveTracker_MinimizeButton_OnClick()
			end
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

	-- Objectives
	local objectives = PetTracker.Objectives
	objectives.MaxEntries = 100
	objectives.Header = header

	objectives:SetParent(content)
	objectives:Hide()

	-- Progress bar
	objectives.Anchor:SetSize(content:GetWidth() - 4, 13)
	objectives.Anchor:SetPoint("TOPLEFT", content, -8, -4)
	objectives.Anchor.xOff = -2

	objectives.Anchor.Overlay.BorderLeft:Hide()
	objectives.Anchor.Overlay.BorderRight:Hide()
	objectives.Anchor.Overlay.BorderCenter:Hide()

	local border1 = objectives.Anchor:CreateTexture(nil, "BACKGROUND", nil, -2)
	border1:SetPoint("TOPLEFT", -1, 1)
	border1:SetPoint("BOTTOMRIGHT", 1, -1)
	border1:SetColorTexture(0, 0, 0)

	local border2 = objectives.Anchor:CreateTexture(nil, "BACKGROUND", nil, -3)
	border2:SetPoint("TOPLEFT", -2, 2)
	border2:SetPoint("BOTTOMRIGHT", 2, -2)
	border2:SetColorTexture(0.4, 0.4, 0.4)

	objectives.Anchor.Overlay.Text:SetPoint("CENTER", 0, 0.5)
	objectives.Anchor.Overlay.Text:SetFont(LSM:Fetch("font", "Arial Narrow"), 13, "")
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
		block.height = PetTracker.Objectives:GetHeight() - 41
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
	self.isLoaded = (KT:CheckAddOn("PetTracker", "8.3.8") and db.addonPetTracker)

	if self.isLoaded then
		KT:Alert_IncompatibleAddon("PetTracker", "8.3.1")

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
	--SetHooks_Init()
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
		(PetTracker.sets and PetTracker.sets.trackPets))
end

function M:SetPetsHeaderText(reset)
	if self.isLoaded and db.hdrPetTrackerTitleAppend then
		local _, numPetsOwned = C_PetJournal.GetNumPets()
		KT:SetHeaderText(PETTRACKER_TRACKER_MODULE, numPetsOwned)
	elseif reset then
		KT:SetHeaderText(PETTRACKER_TRACKER_MODULE)
	end
end
