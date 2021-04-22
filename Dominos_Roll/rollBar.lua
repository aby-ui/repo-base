--------------------------------------------------------------------------------
-- Alerts
-- A module for moving the Group Loot and Alerts frames
--------------------------------------------------------------------------------

local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos')

--------------------------------------------------------------------------------
-- bar template
--------------------------------------------------------------------------------

local AlertsBar = Dominos:CreateClass('Frame', Dominos.Frame)

function AlertsBar:New(id, frame, description)
	local bar = AlertsBar.proto.New(self, id, description)

	bar.repositionedFrame = frame
	bar.description = description

	bar:Layout()

	return bar
end

function AlertsBar:GetDisplayName()
	if self.id == "roll" then
		return L.RollBarDisplayName
	end

	if self.id == "alerts" then
		return L.AlertsBarDisplayName
	end

	return AlertsBar.proto:GetDisplayName()
end

function AlertsBar:GetDescription()
	return self.description
end

function AlertsBar:GetDefaults()
	return {
		point = 'LEFT',
		columns = 1,
		spacing = 2,
		showInPetBattleUI = true,
		showInOverrideUI = true,
	}
end

function AlertsBar:Layout()
	self:RepositionChildFrame()

	local pW, pH = self:GetPadding()
	self:SetSize(317 + pW, 119 + pH)
end

function AlertsBar:RepositionChildFrame()
	local frame = self.repositionedFrame

	frame:ClearAllPoints()
	frame:SetPoint('BOTTOM', self)
end

--------------------------------------------------------------------------------
-- module
--------------------------------------------------------------------------------

local AlertsBarModule = Dominos:NewModule('Alerts')

function AlertsBarModule:OnInitialize()
	if AlertFrame then
		AlertFrame.ignoreFramePositionManager = true

		hooksecurefunc(AlertFrame, "UpdateAnchors", function()
			if self.alertsBar then
				self.alertsBar:RepositionChildFrame()
			end
		end)
	end

	if GroupLootContainer then
		GroupLootContainer.ignoreFramePositionManager = true

		hooksecurefunc(AlertFrame, "UpdateAnchors", function()
			if self.rollBar then
				self.rollBar:RepositionChildFrame()
			end
		end)
	end
end

function AlertsBarModule:Load()
	if AlertFrame then
		self.alertsBar = AlertsBar:New('alerts', AlertFrame)
	end

	if GroupLootContainer then
		self.rollBar = AlertsBar:New('roll', GroupLootContainer, L.TipRollBar)
	end
end

function AlertsBarModule:Unload()
	if self.alertsBar then
		self.alertsBar:Free()
		self.alertsBar = nil
	end

	if self.rollBar then
		self.rollBar:Free()
		self.rollBar = nil
	end
end
