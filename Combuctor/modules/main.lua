--[[
	main.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
Addon.ItemScale = 1.6
Addon.canSearch = true

function Addon:OnEnable()
	self:StartupSettings()

	self:CreateFrame('inventory')
	self:CreateSlashCommands(ADDON:lower(), 'cbt')
	self:CreateOptionsLoader()
end
