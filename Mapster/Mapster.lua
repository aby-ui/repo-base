--[[
Copyright (c) 2009-2018, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):NewAddon("Mapster", "AceEvent-3.0", "AceHook-3.0")

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
		disableMouse = false,
	}
}

local format = string.format

local wmfOnShow, dropdownScaleFix, WorldMapFrameGetAlpha
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

local realZone
function Mapster:OnEnable()
	self:SetupMapButton()

	self:SecureHook(WorldMapFrame, "SynchronizeDisplayState", "WorldMapFrame_SynchronizeDisplayState")

	self:SecureHook("HelpPlate_Show")
	self:SecureHook("HelpPlate_Hide")
	self:SecureHook("HelpPlate_Button_AnimGroup_Show_OnFinished")
	self:RawHook(WorldMapFrame.ScrollContainer, "GetCursorPosition", "WorldMapFrame_ScrollContainer_GetCursorPosition", true)

	-- load settings
	--self:SetAlpha()
	--self:SetArrow()
	self:SetScale()
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
	--self:SetArrow()
	self:SetScale()

	if self.optionsButton then
		if db.hideMapButton then
			self.optionsButton:Hide()
		else
			self.optionsButton:Show()
		end
	end
end

function Mapster:SetScale(force)
	if WorldMapFrame:IsMaximized() and WorldMapFrame:GetScale() ~= 1 then
		WorldMapFrame:SetScale(1)
		SetUIPanelAttribute(WorldMapFrame, "xoffset", 0)
		SetUIPanelAttribute(WorldMapFrame, "yoffset", 0)
	elseif not WorldMapFrame:IsMaximized() and (WorldMapFrame:GetScale() ~= db.scale or force) then
		WorldMapFrame:SetScale(db.scale or 1)

		-- adjust x/y offset to compensate for scale changes
		local xOff = UIParent:GetAttribute("LEFT_OFFSET")
		local yOff = UIParent:GetAttribute("TOP_OFFSET")
		xOff = xOff / (db.scale or 1) - xOff
		yOff = yOff / (db.scale or 1) - yOff
		SetUIPanelAttribute(WorldMapFrame, "xoffset", xOff)
		SetUIPanelAttribute(WorldMapFrame, "yoffset", yOff)
	end
end

function Mapster:WorldMapFrame_ScrollContainer_GetCursorPosition()
	local x,y = self.hooks[WorldMapFrame.ScrollContainer].GetCursorPosition(WorldMapFrame.ScrollContainer)
	local s = WorldMapFrame:GetScale()
	return x / s, y / s
end

function Mapster:WorldMapFrame_SynchronizeDisplayState()
	self:SetScale()
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
