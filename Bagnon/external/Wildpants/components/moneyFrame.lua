--[[
	moneyFrame.lua
		A money frame object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local MoneyFrame = Addon:NewClass('MoneyFrame', 'Frame')
MoneyFrame.Type = 'PLAYER'


--[[ Constructor ]]--

function MoneyFrame:New(parent)
	local f = self:Bind(CreateFrame('Button', parent:GetName() .. 'MoneyFrame', parent, 'SmallMoneyFrameTemplate'))
	f.trialErrorButton:SetPoint('LEFT', -14, 0)
	f:SetScript('OnHide', f.UnregisterEvents)
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
	if not Addon.Cache:HasCache() then
    return
  end

	-- Total
	local total = 0
	for i, player in Addon.Cache:IteratePlayers() do
		total = total + Addon.Cache:GetPlayerMoney(player)
	end

	GameTooltip:SetOwner(self, self:GetTop() > (GetScreenHeight() / 2) and 'ANCHOR_BOTTOM' or 'ANCHOR_TOP')
	GameTooltip:AddDoubleLine(L.Total, self:GetCoinTextureString(total), nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(' ')

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
	
	GameTooltip:Show()
end

function MoneyFrame:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function MoneyFrame:RegisterEvents()
	self:RegisterFrameMessage('PLAYER_CHANGED', 'Update')
	self:RegisterEvent('PLAYER_MONEY', 'Update')
	self:Update()
end

function MoneyFrame:Update()
	local money = self:GetMoney()
	MoneyFrame_Update(self:GetName(), money, money == 0)
end


--[[ API ]]--

function MoneyFrame:GetMoney()
	return Addon.Cache:GetPlayerMoney(self:GetPlayer())
end

function MoneyFrame:GetCoinTextureString(money)
	if ENABLE_COLORBLIND_MODE == '1' then
		return self:GetCoinText(money)
	else
		local gold, silver, copper = self:GetCoins(money)
		local text = ''

		if gold > 0 then
			text = format('%s|TInterface/MoneyFrame/UI-MoneyIcons:10:10:2:0:32:16:0:8:0:16|t', BreakUpLargeNumbers(gold))
		end
		if silver > 0 then
			text = text .. format(' %d|TInterface/MoneyFrame/UI-MoneyIcons:10:10:2:0:32:16:8:16:0:16|t', silver)
		end
		if copper > 0 or money == 0 then
			text = text .. format(' %d|TInterface/MoneyFrame/UI-MoneyIcons:10:10:2:0:32:16:16:24:0:16|t', copper)
		end

		return text
	end
end

function MoneyFrame:GetCoinText(money)
	local gold, silver, copper = self:GetCoins(money)
	local text = ''

	if gold > 0 then
		text = format('%s|cffffd700%s|r', BreakUpLargeNumbers(gold), GOLD_AMOUNT_SYMBOL)
	end
	if silver > 0 then
		text = text .. format(' %d|cffc7c7cf%s|r', silver, SILVER_AMOUNT_SYMBOL)
	end
	if copper > 0 or money == 0 then
		text = text .. format(' %d|cffeda55f%s|r', copper, COPPER_AMOUNT_SYMBOL)
	end

	return text
end

function MoneyFrame:GetCoins(money)
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = money % COPPER_PER_SILVER
	return gold, silver, copper
end
