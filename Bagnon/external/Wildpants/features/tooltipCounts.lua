--[[
	tooltipCounts.lua
		Adds item counts to tooltips
]]--

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TooltipCounts = Addon:NewModule('TooltipCounts')

local SILVER = '|cffc7c7cf%s|r'
local LAST_BANK_SLOT = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
local FIRST_BANK_SLOT = NUM_BAG_SLOTS + 1
local TOTAL = SILVER:format(L.Total)

local Cache = LibStub('LibItemCache-2.0')
local ItemText, ItemCount, Hooked = {}, {}


--[[ Adding Text ]]--

local function FindItemCount(owner, bag, itemID)
	local count = 0
	local info = Cache:GetBagInfo(owner, bag)

	for slot = 1, (info.count or 0) do
		local id = Cache:GetItemID(owner, bag, slot)
		if id == itemID then
			count = count + (Cache:GetItemInfo(owner, bag, slot).count or 1)
		end
	end

	return count
end

local function FormatCounts(color, ...)
	local total, places = 0, 0
	local text = ''

	for i = 1, select('#', ...), 2 do
		local title, count = select(i, ...)
		if count > 0 then  --and i~=5 TODO aby8 hide guild count
			text = text .. L.TipDelimiter .. title:format(count)
			total = total + count
			places = places + 1
		end
	end

	text = text:sub(#L.TipDelimiter + 1)
	if places > 1 then
		text = color:format(total) .. ' ' .. SILVER:format('('.. text .. ')')
	else
		text = color:format(text)
	end

	return total, total > 0 and text
end

local function AddOwners(tooltip, link)
	if not Addon.sets.tipCount or tooltip.__tamedCounts then
		return
	end

	local itemID = tonumber(link and GetItemInfo(link) and link:match('item:(%d+)')) -- Blizzard doing craziness when doing GetItemInfo
	if not itemID or itemID == HEARTHSTONE_ITEM_ID then
		return
	end

	local players = 0
	local total = 0

	for owner in Cache:IterateOwners() do
		local info = Cache:GetOwnerInfo(owner)
		local color = Addon:GetOwnerColorString(info)
		local count, countText = ItemCount[owner][itemID], ItemText[owner][itemID]

		if countText == nil then
			if not info.isguild then
				local equip = FindItemCount(owner, 'equip', itemID)
				local vault = FindItemCount(owner, 'vault', itemID)
				local bags, bank = 0,0

				if info.cached then
					for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
						bags = bags + FindItemCount(owner, i, itemID)
					end

					for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
						bank = bank + FindItemCount(owner, i, itemID)
					end
					bank = bank + FindItemCount(owner, REAGENTBANK_CONTAINER, itemID)
				else
					local owned = GetItemCount(itemID, true)
					local carrying = GetItemCount(itemID)

					bags = carrying - equip
					bank = owned - carrying
				end

				count, countText = FormatCounts(color, L.TipCountEquip, equip, L.TipCountBags, bags, L.TipCountBank, bank, L.TipCountVault, vault)
			elseif Addon.sets.countGuild then
				local guild = 0
				for i = 1, GetNumGuildBankTabs() do
					guild = guild + FindItemCount(owner, i, itemID)
				end

				count, countText = FormatCounts(color, L.TipCountGuild, guild)
			end

			if info.cached then
				ItemText[owner][itemID] = countText or false
				ItemCount[owner][itemID] = count
			end
		end

		if countText then
			tooltip:AddDoubleLine(format('|T%s:12:12|t ', Addon:GetOwnerIcon(info)) .. color:format(info.name), countText)
			total = total + count
			players = players + 1
		end
	end

	if players > 1 and total > 0 then
		tooltip:AddDoubleLine(TOTAL, SILVER:format(total))
	end

	tooltip.__tamedCounts = true
	tooltip:Show()
end


--[[ Hooking ]]--

local function OnItem(tooltip)
	local name, link = tooltip:GetItem()
	if name ~= '' then -- Blizzard broke tooltip:GetItem() in 6.2
		AddOwners(tooltip, link)
	end
end

local function OnTradeSkill(tooltip, recipe, reagent)
    if reagent then
        AddOwners(tooltip, C_TradeSkillUI.GetRecipeReagentItemLink(recipe, reagent))
    else
        AddOwners(tooltip, C_TradeSkillUI.GetRecipeItemLink(recipe))
    end
end

local function OnQuest(tooltip, type, quest)
	AddOwners(tooltip, GetQuestItemLink(type, quest))
end

local function OnClear(tooltip)
	tooltip.__tamedCounts = false
end

local function HookTip(tooltip)
	tooltip:HookScript('OnTooltipCleared', OnClear)
	tooltip:HookScript('OnTooltipSetItem', OnItem)

  hooksecurefunc(tooltip, 'SetRecipeReagentItem', OnTradeSkill)
  hooksecurefunc(tooltip, 'SetRecipeResultItem', OnTradeSkill)
	hooksecurefunc(tooltip, 'SetQuestItem', OnQuest)
	hooksecurefunc(tooltip, 'SetQuestLogItem', OnQuest)
end


--[[ Startup ]]--

function TooltipCounts:OnEnable()
	if Addon:MultipleOwnersFound() and Addon.sets.tipCount then
		if not Hooked then
			for owner in Cache:IterateOwners() do
				ItemCount[owner] = {}
				ItemText[owner] = {}
			end

			HookTip(GameTooltip)
			HookTip(ItemRefTooltip)
			Hooked = true
		end
	end
end
