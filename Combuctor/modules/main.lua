--[[
	main.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
Addon.ItemScale = 1.1
Addon.FrameScale = 0.9
Addon.canSearch = true

function Addon:OnEnable()
	self:StartupSettings()

	self:CreateFrame('inventory')
	self:CreateSlashCommands(ADDON:lower(), 'cbt')
	self:CreateOptionsLoader()
end
