--[[
	frameBase.lua
		Useful methods to implement frame objects.
--]]


local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon:NewClass('Frame', 'Frame')

Frame.OpenSound = SOUNDKIT.IG_BACKPACK_OPEN
Frame.CloseSound = SOUNDKIT.IG_BACKPACK_CLOSE
Frame.SortEvent = 'ITEM_UNLOCKED'


--[[ Frame Events ]]--

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterSignals()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterSignals()

	if Addon.sets.resetPlayer then
		self.owner = nil
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
		--HideUIPanel(self)
		--ShowUIPanel(self)
		self:Show()
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

function Frame:FindRules()
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
		self:SendFrameSignal('RULES_UPDATED')
	end
end


--[[ Shared ]]--

function Frame:SortItems()
	Addon.Sorting:Start(self:GetOwner(), self.Bags, self.SortEvent)
end

function Frame:IsShowingBag(bag)
	return not self:GetProfile().hiddenBags[bag]
end

function Frame:IsShowingItem(bag, slot)
	local info = self:GetItemInfo(bag, slot)
	local rule = Addon.Rules:Get(self.subrule or self.rule)

	if rule and rule.func then
		if not rule.func(self.owner, bag, slot, self:GetBagInfo(bag), info) then
			return
		end
	end

	return self:IsShowingQuality(info.quality)
end

function Frame:IsShowingQuality(quality)
	return self.quality == 0 or (quality and bit.band(self.quality, bit.lshift(1, quality)) > 0)
end

function Frame:IsCached()
	return Cache:GetBagInfo(self:GetOwner(), self.Bags[1]).cached
end

function Frame:GetBagInfo(bag)
	return Cache:GetBagInfo(self:GetOwner(), bag)
end

function Frame:GetItemInfo(bag, slot)
	return Cache:GetItemInfo(self:GetOwner(), bag, slot)
end

function Frame:GetProfile()
	return Addon:GetProfile(self:GetOwner())[self.frameID]
end

function Frame:GetBaseProfile()
	return Addon.profile[self.frameID]
end

function Frame:SetOwner(owner)
	self.owner = owner
  self:SendFrameSignal('OWNER_CHANGED', owner)
end

function Frame:GetOwner()
	return self.owner or UnitName('player')
end

function Frame:GetFrameID()
	return self.frameID
end
