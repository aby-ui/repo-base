--[[
	itemGroup.lua
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

	local r = w/h
	local guess = ceil(sqrt(n*r))

	if self:BagBreak() then
		n = 0

		for i, bag in ipairs(self.bags) do
			n = n + (self:IsShowingBag(bag.id) and ceil(self:NumSlots(bag.id) / guess) * guess or 0)
		end

		guess = ceil(sqrt(n*r))
	end

	local guessV = guess * h/w
	local bestFit = guess > 0 and (((floor(guessV) * guess) < n) and h/ceil(guessV) or w/guess) or 1

	local size = self:GetButtonSize()
	local scale = min(bestFit / size, profile.itemScale)
	local cols = floor(w / (scale * size))

	return cols, scale
end
