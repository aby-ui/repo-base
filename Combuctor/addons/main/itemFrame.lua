--[[
	itemFrame.lua
		Modifies the item frame to always fit inside the panel
--]]

local ADDON, Addon = ...
local ItemGroup = Addon.ItemGroup

function ItemGroup:LayoutTraits()
	local profile = self:GetProfile()

	local n = self:NumButtons()
	local w, h = self:GetFrame():GetSize()
	w = w - (profile.showBags and 59 or 23)
	h = h - 100

	local r, r2 = h/w, w/h
	local px = ceil(sqrt(n*r2))
	local bestFit = ((floor(px*r) * px) < n) and h/ceil(px*r) or w/px

	local size = self:GetButtonSize()
	local scale = min(bestFit / size, profile.itemScale)
	local cols = floor(w / (scale * size))

	return cols, scale
end

function ItemGroup:BagBreak()
end
