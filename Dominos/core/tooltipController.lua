--[[
	TooltipsController.lua
		Handle showing/hiding frame tooltips in a secure manner
--]]

local _, Addon = ...
local TooltipController = Addon:NewModule('Tooltips')

function TooltipController:OnInitialize()
	local header = CreateFrame('Frame', nil, nil, 'SecureHandlerStateTemplate')

	RegisterStateDriver(header, 'combat', '[combat]1;nil')
	header:Hide()

	self.header = header

	--keybound support
	local kb = LibStub('LibKeyBound-1.0')

	kb.RegisterCallback(self, 'LIBKEYBOUND_ENABLED', function()
		self.header:SetAttribute('keybound-enabled', true)
	end)

	kb.RegisterCallback(self, 'LIBKEYBOUND_DISABLED', function ()
		self.header:SetAttribute('keybound-enabled', false)
	end)
end

function TooltipController:OnEnable()
	self:SetShowTooltips(Addon:ShowTooltips())
	self:SetShowTooltipsInCombat(Addon:ShowCombatTooltips())
end

function TooltipController:Register(frame)
	self.header:WrapScript(frame, 'OnEnter', [[
		if control:GetAttribute('keybound-enabled') then
			return true
		end

		if control:GetAttribute('tooltips-enabled') then
			return control:GetAttribute('tooltips-enabled-combat') or (not control:GetAttribute('state-combat'))
		end

		return false
	]])
end

function TooltipController:Unregister(frame)
	self.header:UnwrapScript(frame, 'OnEnter')
end

function TooltipController:SetShowTooltips(enable)
	self.header:SetAttribute('tooltips-enabled', enable and true or false)
end

function TooltipController:SetShowTooltipsInCombat(enable)
	self.header:SetAttribute('tooltips-enabled-combat', enable and true or false)
end