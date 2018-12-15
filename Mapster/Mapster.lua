--[[
Copyright (c) 2009-2018, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):NewAddon("Mapster", "AceEvent-3.0", "AceHook-3.0")

local LibWindow = LibStub("LibWindow-1.1")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local defaults = {
	profile = {
		hideMapButton = false,
		arrowScale = 0.9,
		modules = {
			['*'] = true,
		},
		scale = 1,
		poiScale = 0.9,
		ejScale = 0.8,
		alpha = 1,
		fadealpha = 0.5,
		disableMouse = false,
		-- position defaults for LibWindow
		x = 40,
		y = 140,
		point = "LEFT",
	}
}

local WorldMapFrameStartMoving, WorldMapFrameStopMoving
local WorldMapUnitPin, WorldMapUnitPinSizes
local db

function Mapster:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MapsterDB", defaults, true)
	db = self.db.profile

	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")

	self.elementsToHide = {}

	self.UIHider = CreateFrame("Frame")
	self.UIHider:Hide()

	self:SetupOptions()
end

function Mapster:OnEnable()
	self:SetupMapButton()

	LibWindow.RegisterConfig(WorldMapFrame, db)

	-- remove from UI panel system
	UIPanelWindows["WorldMapFrame"] = nil
	WorldMapFrame:SetAttribute("UIPanelLayout-area", nil)
	WorldMapFrame:SetAttribute("UIPanelLayout-enabled", false)

	-- make the map movable
	WorldMapFrame:SetMovable(true)
	WorldMapFrame:RegisterForDrag("LeftButton")
	WorldMapFrame:SetScript("OnDragStart", WorldMapFrameStartMoving)
	WorldMapFrame:SetScript("OnDragStop", WorldMapFrameStopMoving)

	-- map transition
	self:SecureHook(WorldMapFrame, "SynchronizeDisplayState", "WorldMapFrame_SynchronizeDisplayState")

	-- hook Show events for fading
	self:SecureHook(WorldMapFrame, "OnShow", "WorldMapFrame_OnShow")

	-- hooks for scale
	self:SecureHook("HelpPlate_Show")
	self:SecureHook("HelpPlate_Hide")
	self:SecureHook("HelpPlate_Button_AnimGroup_Show_OnFinished")
	self:RawHook(WorldMapFrame.ScrollContainer, "GetCursorPosition", "WorldMapFrame_ScrollContainer_GetCursorPosition", true)

	-- hook into EJ icons
	self:SecureHook(EncounterJournalPinMixin, "OnAcquired", "EncounterJournalPin_OnAcquired")
	for pin in WorldMapFrame:EnumeratePinsByTemplate("EncounterJournalPinTemplate") do
		pin.OnAcquired = EncounterJournalPinMixin.OnAcquired
	end

	-- hook into Quest POI icons
	self:SecureHook(BonusObjectivePinMixin, "OnAcquired", "BonusQuestPOI_OnAcquired")
	self:SecureHook(QuestPinMixin, "OnAcquired", "QuestPOI_OnAcquired")
	for pin in WorldMapFrame:EnumeratePinsByTemplate("BonusObjectivePinTemplate") do
		pin.OnAcquired = BonusObjectivePinMixin.OnAcquired
	end
	for pin in WorldMapFrame:EnumeratePinsByTemplate("QuestPinTemplate") do
		pin.OnAcquired = QuestPinMixin.OnAcquired
	end

	-- hook into unit provider
	for pin in WorldMapFrame:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
		WorldMapUnitPin = pin
		WorldMapUnitPinSizes = pin.dataProvider:GetUnitPinSizesTable()
		break
	end

	-- close the map on escape
	table.insert(UISpecialFrames, "WorldMapFrame")

	-- load settings
	--self:SetAlpha()
	self:SetFadeAlpha()
	self:SetArrow()
	self:SetEJScale()
	self:SetPOIScale()
	self:SetScale()
	self:SetPosition()
end

function Mapster:Refresh()
	db = self.db.profile

	for k,v in self:IterateModules() do
		if self:GetModuleEnabled(k) and not v:IsEnabled() then
			self:EnableModule(k)
		elseif not self:GetModuleEnabled(k) and v:IsEnabled() then
			self:DisableModule(k)
		end
		if type(v.Refresh) == "function" then
			v:Refresh()
		end
	end

	-- apply new settings
	--self:SetAlpha()
	self:SetFadeAlpha()
	self:SetArrow()
	self:SetEJScale()
	self:SetPOIScale()
	self:SetScale()
	self:SetPosition()

	if self.optionsButton then
		if db.hideMapButton then
			self.optionsButton:Hide()
		else
			self.optionsButton:Show()
		end
	end
end

function WorldMapFrameStartMoving(frame)
	if not WorldMapFrame:IsMaximized() then
		WorldMapFrame:StartMoving()
	end
end

function WorldMapFrameStopMoving(frame)
	WorldMapFrame:StopMovingOrSizing()
	if not WorldMapFrame:IsMaximized() then
		LibWindow.SavePosition(WorldMapFrame)
	end
end

function Mapster:SetPosition()
	LibWindow.RestorePosition(WorldMapFrame)
end

function Mapster:SetFadeAlpha()
	PlayerMovementFrameFader.RemoveFrame(WorldMapFrame)
	PlayerMovementFrameFader.AddDeferredFrame(WorldMapFrame, db.fadealpha, 1.0, .5, function() return GetCVarBool("mapFade") and not WorldMapFrame:IsMouseOver() end)
end

function Mapster:WorldMapFrame_OnShow()
	self:SetFadeAlpha()
    WorldMapFrame:SetAlpha(1)
end

function Mapster:SetScale(force)
	if WorldMapFrame:IsMaximized() and WorldMapFrame:GetScale() ~= 1 then
		WorldMapFrame:SetScale(1)
	elseif not WorldMapFrame:IsMaximized() and (WorldMapFrame:GetScale() ~= db.scale or force) then
		WorldMapFrame:SetScale(db.scale)
	end
end

function Mapster:WorldMapFrame_ScrollContainer_GetCursorPosition()
	local x,y = self.hooks[WorldMapFrame.ScrollContainer].GetCursorPosition(WorldMapFrame.ScrollContainer)
	local s = WorldMapFrame:GetScale()
	return x / s, y / s
end

function Mapster:WorldMapFrame_SynchronizeDisplayState()
	self:SetScale()
	if not WorldMapFrame:IsMaximized() then
		self:SetPosition()
	end
end

function Mapster:HelpPlate_Show(plate, frame)
	if frame == WorldMapFrame then
		HelpPlate:SetScale(db.scale or 1)
		HelpPlate.__Mapster = true
	end
end

function Mapster:HelpPlate_Hide(userToggled)
	if HelpPlate.__Mapster and not userToggled then
		HelpPlate:SetScale(1.0)
		HelpPlate.__Mapster = nil
	end
end

function Mapster:HelpPlate_Button_AnimGroup_Show_OnFinished()
	if HelpPlate.__Mapster then
		HelpPlate:SetScale(1.0)
		HelpPlate.__Mapster = nil
	end
end

function Mapster:EncounterJournalPin_OnAcquired(pin)
	pin:SetSize(50 * db.ejScale, 49 * db.ejScale)
	pin.Background:SetScale(db.ejScale)
end

function Mapster:SetEJScale()
	for pin in WorldMapFrame:EnumeratePinsByTemplate("EncounterJournalPinTemplate") do
		self:EncounterJournalPin_OnAcquired(pin)
	end
end

function Mapster:BonusQuestPOI_OnAcquired(pin)
	pin:SetSize(30 * db.poiScale, 30 * db.poiScale)
	pin.Texture:SetScale(db.poiScale)
end

function Mapster:QuestPOI_OnAcquired(pin)
	pin:SetSize(50 * db.poiScale, 50 * db.poiScale)
	pin.Texture:SetScale(db.poiScale)
	pin.PushedTexture:SetScale(db.poiScale)
	pin.Number:SetScale(db.poiScale)
	pin.Highlight:SetScale(db.poiScale)
end

function Mapster:SetPOIScale()
	for pin in WorldMapFrame:EnumeratePinsByTemplate("BonusObjectivePinTemplate") do
		self:BonusQuestPOI_OnAcquired(pin)
	end
	for pin in WorldMapFrame:EnumeratePinsByTemplate("QuestPinTemplate") do
		self:QuestPOI_OnAcquired(pin)
	end
end

function Mapster:SetArrow()
	if not WorldMapUnitPin or not WorldMapUnitPinSizes then
		return
	end

	WorldMapUnitPinSizes.player = 27 * db.arrowScale
	WorldMapUnitPin:SynchronizePinSizes()
end

function Mapster:GetModuleEnabled(module)
	return db.modules[module]
end

function Mapster:SetModuleEnabled(module, value)
	local old = db.modules[module]
	db.modules[module] = value
	if old ~= value then
		if value then
			self:EnableModule(module)
		else
			self:DisableModule(module)
		end
	end
end
