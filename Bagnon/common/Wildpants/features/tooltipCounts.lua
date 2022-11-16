--[[
	tipCounts.lua
		Adds item counts to tips
]]--

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TooltipCounts = Addon:NewModule('TooltipCounts')

local SILVER = '|cffc7c7cf%s|r'
local LAST_BANK_SLOT = NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS
local FIRST_BANK_SLOT = NUM_TOTAL_EQUIPPED_BAG_SLOTS + 1
local TOTAL = SILVER:format(L.Total)

local ItemText, ItemCount


--[[ Adding Text ]]--

local function FindItemCount(owner, bag, itemID)
	local count = 0
	local info = Addon:GetBagInfo(owner, bag)

	for slot = 1, (info.count or 0) do
		local id = Addon:GetItemID(owner, bag, slot)
		if id == itemID then
			count = count + (Addon:GetItemInfo(owner, bag, slot).count or 1)
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

local function AddOwners(tip, link)
	if not Addon.sets.tipCount or tip.__tamedCounts then
		return
	end

	local itemID = tonumber(link and GetItemInfo(link) and link:match('item:(%d+)')) -- Blizzard doing craziness when doing GetItemInfo
	if not itemID or itemID == HEARTHSTONE_ITEM_ID then
		return
	end

	local players = 0
	local total = 0

	for owner in Addon:IterateOwners() do
		local info = Addon:GetOwnerInfo(owner)
		local color = Addon.Owners:GetColorString(info)
		local count, text = ItemCount[owner] and ItemCount[owner][itemID]

		if count then
			text = ItemText[owner][itemID]
		else
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

					if REAGENTBANK_CONTAINER then
						bank = bank + FindItemCount(owner, REAGENTBANK_CONTAINER, itemID)
					end

					bank = bank + FindItemCount(owner, BANK_CONTAINER, itemID)
				else
					local owned = GetItemCount(itemID, true)
					local carrying = GetItemCount(itemID)

					bags = carrying - equip
					bank = owned - carrying
				end

				count, text = FormatCounts(color, L.TipCountEquip, equip, L.TipCountBags, bags, L.TipCountBank, bank, L.TipCountVault, vault)
			elseif Addon.sets.countGuild then
				local guild = 0
				for i = 1, GetNumGuildBankTabs() do
					guild = guild + FindItemCount(owner, i, itemID)
				end

				count, text = FormatCounts(color, L.TipCountGuild, guild)
			else
				count = 0
			end

			if info.cached then
				ItemText[owner] = ItemText[owner] or {}
				ItemText[owner][itemID] = text
				ItemCount[owner] = ItemCount[owner] or {}
				ItemCount[owner][itemID] = count
			end
		end

		if count > 0 then
			tip:AddDoubleLine(Addon.Owners:GetIconString(info, 12,0,0) .. ' ' .. color:format(info.name), text)
			total = total + count
			players = players + 1
		end
	end

	if players > 1 and total > 0 then
		tip:AddDoubleLine(TOTAL, SILVER:format(total))
	end

	tip.__tamedCounts = true
	tip:Show()
end


--[[ Hooking ]]--

local function OnItem(tip)
	if not (tip == GameTooltip or tip == ItemRefTooltip) then return end
	local name, link = tip:GetItem()
	if name ~= '' then
		AddOwners(tip, link)
	end
end

local function OnQuest(tip, type, quest)
	AddOwners(tip, GetQuestItemLink(type, quest))
end

local function OnTradeSkill(api)
	return function(tip, recipeID, ...)
		AddOwners(tip, tonumber(recipeID) and C_TradeSkillUI[api](recipeID, ...)) end
end

local function OnClear(tip)
	tip.__tamedCounts = false
end

local function HookTip(tip)
	tip:HookScript('OnTooltipCleared', OnClear)
	tip:HookScript('OnTooltipSetItem', OnItem)

	hooksecurefunc(tip, 'SetQuestItem', OnQuest)
	hooksecurefunc(tip, 'SetQuestLogItem', OnQuest)

	if C_TradeSkillUI then
		if C_TradeSkillUI.GetRecipeFixedReagentItemLink then
			hooksecurefunc(tip, 'SetRecipeReagentItem', OnTradeSkill('GetRecipeFixedReagentItemLink'))
		else
			hooksecurefunc(tip, 'SetRecipeReagentItem', OnTradeSkill('GetRecipeReagentItemLink'))
			hooksecurefunc(tip, 'SetRecipeResultItem', OnTradeSkill('GetRecipeItemLink'))
		end
	end
end


--[[ Startup ]]--

function TooltipCounts:OnEnable()
	if Addon.sets.tipCount then
		if not ItemText then
			ItemText, ItemCount = {}, {}

			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItem)

			--HookTip(GameTooltip)
			--HookTip(ItemRefTooltip)
		end
	end
end
