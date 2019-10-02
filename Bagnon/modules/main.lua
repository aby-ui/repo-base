--[[
	main.lua
		Starts the addon per say
--]]

local ADDON, Addon = ...

function Addon:OnEnable()
	self:StartupSettings()
	self:CreateFrame('inventory')
	self:CreateFrameLoader('GuildBank', 'GuildBankFrame_LoadUI')
	self:CreateFrameLoader('VoidStorage', 'VoidStorage_LoadUI')
	self:CreateSlashCommands(ADDON:lower(), 'bgn')
	self:CreateOptionsLoader()
end

function Addon:CreateFrameLoader(module, method)
	local addon = ADDON .. '_' .. module
	if GetAddOnEnableState(UnitName('player'), addon) >= 2 then
		_G[method] = function()
			LoadAddOn(addon)
		end
	end
end
