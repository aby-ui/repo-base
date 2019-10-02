--[[
	moneyFrame.lua
		A money frame object
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local MoneyFrame = Addon:NewClass('MoneyFrame', 'Frame')
MoneyFrame.Type = 'PLAYER'


--[[ Constructor ]]--

function MoneyFrame:New(parent)
	local f = self:Bind(CreateFrame('Button', parent:GetName() .. 'MoneyFrame', parent, 'SmallMoneyFrameTemplate'))
	f.trialErrorButton:SetPoint('LEFT', -14, 0)
	f:SetScript('OnHide', f.UnregisterSignals)
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnEvent', nil)
	f:UnregisterAllEvents()
	f:SetHeight(24)

	local overlay = CreateFrame('Button', nil, f)
	overlay:SetScript('OnClick', function(_,...) f:OnClick(...) end)
	overlay:SetScript('OnEnter', function() f:OnEnter() end)
	overlay:SetScript('OnLeave', function() f:OnLeave() end)
	overlay:SetFrameLevel(self:GetFrameLevel() + 4)
	overlay:RegisterForClicks('anyUp')
	overlay:SetAllPoints()

	f.info = MoneyTypeInfo[f.Type]
	f.overlay = overlay

	if f:IsShown() then
		f:RegisterEvents()
	end

	return f
end


--[[ Interaction ]]--

function MoneyFrame:OnClick()
	if self:IsCached() then
		return
	end

	local name = self:GetName()
	if MouseIsOver(_G[name .. 'GoldButton']) then
		OpenCoinPickupFrame(COPPER_PER_GOLD, MoneyTypeInfo[self.moneyType].UpdateFunc(self), self)
		self.hasPickup = 1
	elseif MouseIsOver(_G[name .. 'SilverButton']) then
		OpenCoinPickupFrame(COPPER_PER_SILVER, MoneyTypeInfo[self.moneyType].UpdateFunc(self), self)
		self.hasPickup = 1
	elseif MouseIsOver(_G[name .. 'CopperButton']) then
		OpenCoinPickupFrame(1, MoneyTypeInfo[self.moneyType].UpdateFunc(self), self)
		self.hasPickup = 1
	end

	self:OnLeave()
end

function MoneyFrame:OnEnter()
	-- Total
	local total = 0
	for name in Cache:IterateOwners() do
		local owner = Cache:GetOwnerInfo(name)
		if not owner.isguild and owner.money then
			total = total + owner.money
		end
	end

	GameTooltip:SetOwner(self, self:GetTop() > (GetScreenHeight() / 2) and 'ANCHOR_BOTTOM' or 'ANCHOR_TOP')
	GameTooltip:AddDoubleLine(L.Total, GetMoneyString(total, true), nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(' ')

	-- Each owner
	for name in Cache:IterateOwners() do
		local owner = Cache:GetOwnerInfo(name)
		if not owner.isguild and owner.money then
			local icon = Addon:GetOwnerIconString(owner, 12,0,0)
			local coins = GetMoneyString(owner.money, true)
			local color = Addon:GetOwnerColor(owner)

			GameTooltip:AddDoubleLine(icon .. ' ' .. owner.name, coins, color.r, color.g, color.b, 1,1,1)
		end
	end

	GameTooltip:Show()
end

function MoneyFrame:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function MoneyFrame:RegisterEvents()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterEvent('PLAYER_MONEY', 'Update')
	self:Update()
end

function MoneyFrame:Update()
	local money = self:GetMoney()
	MoneyFrame_Update(self:GetName(), money, money == 0)
end


--[[ API ]]--

function MoneyFrame:GetMoney()
	return self:GetOwnerInfo().money or 0
end

function MoneyFrame:GetCoins(money)
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = money % COPPER_PER_SILVER
	return gold, silver, copper
end
