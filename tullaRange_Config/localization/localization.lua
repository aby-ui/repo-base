--[[
	tullaRangeConfig localization
--]]

local AddonName, Addon = ...

local L = {
	ColorSettings = 'Colors',

	ColorSettingsTitle = 'tullaRange color configuration settings',
	
	oor = 'Out of Range',
	
	oom = 'Out of Mana',

	unusable = 'Unusable',

	Red = 'Red',
	
	Green = 'Green',

	Blue = 'Blue'
}

Addon.L = setmetatable(L, { __index = function(t, k) return k end })