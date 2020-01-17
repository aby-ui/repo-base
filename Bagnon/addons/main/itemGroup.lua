--[[
	itemGroup.lua
		Modifies the item frame to follow static layout settings
--]]

local ADDON, Addon = ...
local ItemGroup = Addon.ItemGroup

function ItemGroup:LayoutTraits()
	local profile = self:GetProfile()
	return profile.columns, profile.itemScale
end
