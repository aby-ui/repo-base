local VehicleLeaveButton = _G.MainMenuBarVehicleLeaveButton
if not VehicleLeaveButton then return end

local _, Addon = ...

local VehicleBar = Addon:CreateClass('Frame', Addon.Frame)

function VehicleBar:New()
	local bar = VehicleBar.proto.New(self, 'vehicle')

	bar:Layout()

	return bar
end

function VehicleBar:GetDefaults()
	return {
		point = 'CENTER',
		x = -244,
		y = 0,
	}
end

function VehicleBar:Layout()
	VehicleLeaveButton:ClearAllPoints()
	VehicleLeaveButton:SetPoint('CENTER', self)
	VehicleLeaveButton:SetParent(self)

	local w, h = VehicleLeaveButton:GetSize()
	local pW, pH = self:GetPadding()

	self:TrySetSize(w + pW, h + pH)
end

function VehicleBar:CreateMenu()
	local menu = Addon:NewMenu()

	self:AddLayoutPanel(menu)
	menu:AddFadingPanel()

	self.menu = menu
end

function VehicleBar:AddLayoutPanel(menu)
	local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

	local panel = menu:NewPanel(l.Layout)

	panel.scaleSlider = panel:NewScaleSlider()
	panel.paddingSlider = panel:NewPaddingSlider()
end


--[[ Controller ]]--

local VehicleBarController = Addon:NewModule('VehicleBar', 'AceEvent-3.0')

function VehicleBarController:OnInitialize()
	-- MainMenuBarVehicleLeaveButton_Update can alter the position of the leave
	-- button, so put it back on the vehicle bar whenever it is called
	hooksecurefunc(
		"MainMenuBarVehicleLeaveButton_Update",
		Addon:Defer(function()
			if self.frame then
				VehicleLeaveButton:ClearAllPoints()
				VehicleLeaveButton:SetPoint("CENTER", self.frame)
			end
		end, 0.1)
	)
end

function VehicleBarController:Load()
	self.frame = VehicleBar:New()
end

function VehicleBarController:Unload()
	if self.frame then
		self.frame:Free()
		self.frame = nil
	end
end
