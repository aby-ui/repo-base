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
		local player = Cache:GetOwnerInfo(name)
		if not player.isguild and player.money then
			total = total + player.money
		end
	end

	GameTooltip:SetOwner(self, self:GetTop() > (GetScreenHeight() / 2) and 'ANCHOR_BOTTOM' or 'ANCHOR_TOP')
	GameTooltip:AddDoubleLine(L.Total, GetMoneyString(total, true), nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(' ')

	-- Each player
	for name in Cache:IterateOwners() do
		local player = Cache:GetOwnerInfo(name)
		if not player.isguild and player.money then
			local icon = format('|T%s:12:12|t ', Addon:GetOwnerIcon(player))
			local coins = GetMoneyString(player.money, true)
			local color = Addon:GetOwnerColor(player)

			GameTooltip:AddDoubleLine(icon .. player.name, coins, color.r, color.g, color.b, 1,1,1)
		end
	end
	--[==[ --TODO aby8 只显示几个
    Addon.tplayer = Addon.tplayer or {} wipe(Addon.tplayer)
    Addon.tmoney = Addon.tmoney or {}   wipe(Addon.tmoney)

	-- Each player
	for i, player in Addon.Cache:IteratePlayers() do
		local money = Addon.Cache:GetPlayerMoney(player)
		if money > 0 then
            tinsert(Addon.tplayer, player)
            Addon.tmoney[player] = money
			--local color = Addon:GetPlayerColor(player)
			--local coins = self:GetCoinTextureString(money)

			--GameTooltip:AddDoubleLine(player, coins, color.r, color.g, color.b, 1,1,1)
		end
    end

    --only show first 3 or 4
    table.sort(Addon.tplayer, function(a, b)
        local ma = Addon.tmoney[a]
        local mb = Addon.tmoney[b]
        if ma == mb then return a < b end
        return ma > mb
    end)
    for i = 1, 4 do
        local player = Addon.tplayer[i] if not player then break end
        local real, name = Addon.Cache:GetPlayerAddress(player)
        if real ~= GetRealmName() or name ~= UnitName("player") then
            local color = Addon:GetPlayerColor(player)
            local coins = self:GetCoinTextureString(Addon.tmoney[player])
            GameTooltip:AddDoubleLine(player, coins, color.r, color.g, color.b, 1,1,1)
        end
    end

    local addedLine
    local name, count, icon, currencyID
    for i=1, MAX_WATCHED_TOKENS do
        name, count, icon, currencyID = GetBackpackCurrencyInfo(i);
        if ( name ) then
            if not addedLine then
                addedLine = true
                GameTooltip:AddLine(' ')
            end
            GameTooltip:AddDoubleLine(format("|T%s:16:16:0:0|t %s", icon, name), count, nil, nil, nil, 1, 1, 1)
        end
    end
	--]==]
	
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
