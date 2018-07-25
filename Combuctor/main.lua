--[[
	main.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
Addon.ItemScale = 1.6
Addon.canSearch = true

function Addon:OnEnable()
	self:StartupSettings()
	self:SetupAutoDisplay()
	self:AddSlashCommands(ADDON:lower(), 'cbt')
	self:HookTooltips()

	self:CreateFrame('inventory')
	self:CreateOptionsLoader()
end
