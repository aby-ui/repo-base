local ExtraActionBarFrame = _G.ExtraActionBarFrame
if not ExtraActionBarFrame then
	return
end

local _, Addon = ...

local ExtraBar = Addon:CreateClass("Frame", Addon.Frame)

function ExtraBar:New()
	local bar = ExtraBar.proto.New(self, "extra")

	ExtraActionBarFrame.button:SetAttribute("showgrid", 1)
	bar:UpdateShowBlizzardTexture()
	bar:Layout()

	return bar
end

function ExtraBar:OnCreate()
	local button = ExtraActionBarFrame.button
	if not button then
		return
	end

	-- apply the bindable button mixin
	setmetatable(button, { __index = Addon.BindableButton })

	-- set the button type, so that we can reuse its current binding
	button.buttonType = "EXTRAACTIONBUTTON"

	-- add hooks for keybound tooltips
	button:HookScript(
		"OnEnter",
		function()
			LibStub('LibKeyBound-1.0'):Set(button)
		end
	)

	-- add hooks for theming the button
	Addon:GetModule("ButtonThemer"):Register(button, "Extra Bar")
end

function ExtraBar:GetDefaults()
	return {
		point = "CENTER",
		x = -244,
		y = 0
	}
end

function ExtraBar:Layout()
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", self)
	ExtraActionBarFrame:SetParent(self)

	local w, h = ExtraActionBarFrame:GetSize()
	local pW, pH = self:GetPadding()

	self:SetSize(w + pW, h + pH)
end

function ExtraBar:CreateMenu()
	local menu = Addon:NewMenu()

	self:AddLayoutPanel(menu)
	menu:AddFadingPanel()

	self.menu = menu
end

function ExtraBar:AddLayoutPanel(menu)
	local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-Config")

	local panel = menu:NewPanel(l.Layout)

	panel:NewCheckButton {
		name = l.ExtraBarShowBlizzardTexture,
		get = function()
			return panel.owner:ShowingBlizzardTexture()
		end,
		set = function(_, enable)
			panel.owner:ShowBlizzardTexture(enable)
		end
	}

	panel.scaleSlider = panel:NewScaleSlider()
	panel.paddingSlider = panel:NewPaddingSlider()
end

function ExtraBar:ShowBlizzardTexture(show)
	self.sets.hideBlizzardTeture = not show

	self:UpdateShowBlizzardTexture()
end

function ExtraBar:ShowingBlizzardTexture()
	return not self.sets.hideBlizzardTeture
end

function ExtraBar:UpdateShowBlizzardTexture()
	local showTexture = self:ShowingBlizzardTexture()

	if showTexture then
		ExtraActionBarFrame.button.style:Show()
	else
		ExtraActionBarFrame.button.style:Hide()
	end
end

local ExtraBarController = Addon:NewModule("ExtraBar")

function ExtraBarController:Load()
	-- luacheck: push ignore 122
	ExtraActionBarFrame.ignoreFramePositionManager = true
	-- luacheck: pop

	self.frame = ExtraBar:New()
end

function ExtraBarController:Unload()
	self.frame:Free()
end
