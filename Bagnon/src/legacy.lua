--[[
	legacy.lua
		Emulates old APIs to support outdated plugins
		Do not implement addons using this code
--]]

local ADDON, Addon = ...
Addon.ItemSlot = Addon.Item

function Addon.Item:GetItem()
	return self.info.link
end