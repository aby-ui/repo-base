--[[
	bagGroup.lua
		A container frame for bags
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bags = Addon.Parented:NewClass('BagGroup', 'Frame')
Bags.Button = Addon.Bag

function Bags:New(parent, from, x, y)
	local f = self:Super(Bags):New(parent)
	local button, k

	for i, bag in ipairs(parent.Bags) do
		k = i-1
		button = f.Button(f, bag)
		button:SetPoint(from, x*k, y*k)
	end

	f:SetSize(k * abs(x) + button:GetWidth(), k * abs(y) + button:GetHeight())
	f:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'UpdateShown')
	f:UpdateShown()
	return f
end

function Bags:UpdateShown()
	self:SetShown(self:GetProfile().showBags)
end
