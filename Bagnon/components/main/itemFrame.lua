--[[
	itemFrame.lua
		Modifies the item frame to follow static layout settings
--]]

local ADDON, Addon = ...
local ItemFrame = Addon.ItemFrame

function ItemFrame:LayoutTraits()
	local profile = self:GetProfile()
	return profile.columns, profile.itemScale
end
