--[[
	main.lua
		Constant specifics for the addon
--]]

local ADDON, Addon = ...
Addon.ItemSlot = Addon.Item -- deprecated behavior
Addon.FrameTemplate = BackdropTemplateMixin and 'BackdropTemplate'
Addon.Slash = 'bgn'
