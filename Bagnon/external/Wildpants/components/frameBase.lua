--[[
	frameBase.lua
		Useful methods to implement frame objects.
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon:NewClass('Frame', 'Frame')
Frame.OpenSound = SOUNDKIT.IG_BACKPACK_OPEN
Frame.CloseSound = SOUNDKIT.IG_BACKPACK_CLOSE

--[[ Frame Events ]]--

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterMessages()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterMessages()

	if Addon.sets.resetPlayer then
		self.player = nil
	end
end


--[[ Settings ]]--

function Frame:UpdateAppearance()
	local managed = self.profile.managed
	self:SetAttribute('UIPanelLayout-enabled', managed)
	self:SetAttribute('UIPanelLayout-defined', managed)
  self:SetAttribute('UIPanelLayout-whileDead', managed)
  self:SetAttribute('UIPanelLayout-area', managed and 'left')
  self:SetAttribute('UIPanelLayout-pushable', managed and 1)
	self:SetFrameStrata(self.profile.strata)
  self:SetAlpha(self.profile.alpha)
	self:SetScale(self.profile.scale)

	if managed then
		HideUIPanel(self)
		ShowUIPanel(self)
	else
		self:ClearAllPoints()
		self:SetPoint(self:GetPosition())
	end
end

function Frame:RecomputePosition()
	local x, y = self:GetCenter()
	if x and y then
		local scale = self:GetScale()
		local h = UIParent:GetHeight() / scale
		local w = UIParent:GetWidth() / scale
		local xPoint, yPoint

		if x > w/2 then
			x = self:GetRight() - w
			xPoint = 'RIGHT'
		else
			x = self:GetLeft()
			xPoint = 'LEFT'
		end

		if y > h/2 then
			y = self:GetTop() - h
			yPoint = 'TOP'
		else
			y = self:GetBottom()
			yPoint = 'BOTTOM'
		end

		self:SetPosition(yPoint..xPoint, x, y)
	end
end

function Frame:SetPosition(point, x, y)
	self.profile.x, self.profile.y = x, y
	self.profile.point = point
end

function Frame:GetPosition()
	return self.profile.point or 'CENTER', self.profile.x, self.profile.y
end

function Frame:UpdateRules()
	local sorted = {}
	for i, id in ipairs(self.profile.rules) do
		sorted[id] = true
	end

	local count = #self.profile.rules
	for id, rule in Addon.Rules:Iterate() do
		if not sorted[id] and not self.profile.hiddenRules[id] then
			tinsert(self.profile.rules, id)
		end
	end

	if #self.profile.rules > count then
		self:SendFrameMessage('RULES_UPDATED')
	end
end


--[[ Shared ]]--

function Frame:IsBank()
	return false
end

function Frame:IsShowingBag(bag)
	return not self:GetProfile().hiddenBags[bag]
end

function Frame:IsShowingItem(bag, slot)
	local icon, count, locked, quality, readable, lootable, itemLink = self:GetItemInfo(bag, slot)
	local rule = Addon.Rules:Get(self.subrule or self.rule)

	if rule and rule.func then
		local bagLink = self:GetBagInfo(bag)
		if not rule.func(self.player, bag, slot, bagLink, itemLink, count) then
			return
		end
	end

	return self:IsShowingQuality(quality)
end

function Frame:IsShowingQuality(quality)
	return self.quality == 0 or (quality and bit.band(self.quality, bit.lshift(1, quality)) > 0)
end

function Frame:IsCached()
	return Addon:IsBagCached(self.player, self.Bags[1])
end

function Frame:GetBagInfo(bag)
	return Addon.Cache:GetBagInfo(self.player, bag)
end

function Frame:GetItemInfo(bag, slot)
	return Addon.Cache:GetItemInfo(self.player, bag, slot)
end

function Frame:GetProfile()
	return Addon:GetProfile(self.player)[self.frameID]
end

function Frame:SetPlayer(player)
	self.player = player
  self:SendFrameMessage('PLAYER_CHANGED', player)
end

function Frame:GetPlayer()
	return self.player or UnitName('player')
end

function Frame:GetFrameID()
	return self.frameID
end
