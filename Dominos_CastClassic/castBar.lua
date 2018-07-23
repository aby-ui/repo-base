
local Addon = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local _G = _G

--[[ casting bar ]]--

local CastingBar = Addon:CreateClass('Frame', Addon.Frame); Addon.CastingBar = CastingBar

function CastingBar:New()
	local bar = CastingBar.proto.New(self, 'cast')

	bar:Layout()

	return bar
end

function CastingBar:Create(...)
	local bar = CastingBar.proto.Create(self, ...)

	bar:SetFrameStrata('DIALOG')

	local cbf = _G.CastingBarFrame

	cbf:SetParent(bar.header)
	cbf:ClearAllPoints()
	cbf:SetPoint('CENTER', bar.header, 'CENTER', 0, -2)

	self.__cbf = cbf

	return bar
end

function CastingBar:GetDefaults()
	return {
		point = 'BOTTOM',
		x = 0,
		y = 180,
	}
end

function CastingBar:Layout()
	local width, height = self.__cbf:GetSize()

	width = width + 16
	height = height + 17

	local paddingW, paddingH = self:GetPadding()

	self:TrySetSize(width + paddingW*2, height + paddingH*2)
end

--[[ config menu ]]--

local function AddLayoutPanel(menu)
	local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

	local panel = menu:NewPanel(L.Layout)

	panel.opacitySlider = panel:NewOpacitySlider()
	panel.fadeSlider = panel:NewFadeSlider()
	panel.scaleSlider = panel:NewScaleSlider()
	panel.paddingSlider = panel:NewPaddingSlider()

	return panel
end

local function AddAdvancedPanel(menu)
	local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

	local panel = menu:NewPanel(L.Advanced)

	panel:NewShowInOverrideUICheckbox()
	panel:NewShowInPetBattleUICheckbox()

	panel.width = 256

	return panel
end

function CastingBar:CreateMenu()
	local menu = Addon:NewMenu(self.id)

	AddLayoutPanel(menu)
	AddAdvancedPanel(menu)

	self.menu = menu
end


--[[ module ]]--

local CastingBarController = Dominos:NewModule('CastingBar')

function CastingBarController:OnInitialize()
	-- make sure the position manager doesn't mess with the casting bar
	_G.CastingBarFrame.ignoreFramePositionManager = true
end

function CastingBarController:Load()
	self.frame = CastingBar:New()
end

function CastingBarController:Unload()
	if self.frame then
		self.frame:Free()
		self.frame = nil
	end
end
