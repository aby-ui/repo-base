--[[
	tooltipCounts.lua
		Adds item counts to tooltips
]]--

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TipCounts = Addon:NewModule('TooltipCounts')

local SILVER = '|cffc7c7cf%s|r'
local LAST_BANK_SLOT = NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS
local FIRST_BANK_SLOT = NUM_TOTAL_EQUIPPED_BAG_SLOTS + 1
local TOTAL = SILVER:format(L.Total)


--[[ Startup ]]--

function TipCounts:OnEnable()
	if Addon.sets.tipCount then
		if not self.Text then
			self.Text, self.Counts = {}, {}

			self:Hook(GameTooltip)
			self:Hook(ItemRefTooltip)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, self.OnItem)
			--[[
			for _,frame in pairs {UIParent:GetChildren()} do
				if not frame:IsForbidden() and frame:GetObjectType() == 'GameTooltip' then
					self:Hook(frame)
				end
			end
			--]]
		end
	end
end

function TipCounts:Hook(tip)
	tip:HookScript('OnTooltipCleared', self.OnClear)
	--tip:HookScript('OnTooltipSetItem', self.OnItem)

	hooksecurefunc(tip, 'SetQuestItem', self.OnQuest)
	hooksecurefunc(tip, 'SetQuestLogItem', self.OnQuest)

--[[
	if C_TradeSkillUI then
		if C_TradeSkillUI.GetRecipeFixedReagentItemLink then
			hooksecurefunc(tip, 'SetRecipeReagentItem', self.OnTradeSkill('GetRecipeFixedReagentItemLink'))
		else
			hooksecurefunc(tip, 'SetRecipeReagentItem', self.OnTradeSkill('GetRecipeReagentItemLink'))
			hooksecurefunc(tip, 'SetRecipeResultItem', self.OnTradeSkill('GetRecipeItemLink'))
		end
	end
--]]
end


--[[ Events ]]--

function TipCounts.OnItem(tip)
	if not (tip == GameTooltip or tip == ItemRefTooltip) then return end
	local name, link = tip:GetItem()
	if name ~= '' then
		TipCounts:AddOwners(tip, link)
	end
end

function TipCounts.OnQuest(tip, type, quest)
	TipCounts:AddOwners(tip, GetQuestItemLink(type, quest))
end

function TipCounts.OnTradeSkill(api)
	return function(tip, recipeID, ...)
		TipCounts:AddOwners(tip, tonumber(recipeID) and C_TradeSkillUI[api](recipeID, ...))
	end
end

function TipCounts.OnClear(tip)
	tip.__tamedCounts = false
end


--[[ API ]]--

function TipCounts:AddOwners(tip, link)
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
		local count, text = self.Counts[owner] and self.Counts[owner][itemID]

		if count then
			text = self.Text[owner][itemID]
		else
			if not info.isguild then
				local equip = self:GetCount(owner, 'equip', itemID)
				local vault = self:GetCount(owner, 'vault', itemID)
				local bags, bank = 0,0

				if info.cached then
					for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
						bags = bags + self:GetCount(owner, i, itemID)
					end

					for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
						bank = bank + self:GetCount(owner, i, itemID)
					end

					if REAGENTBANK_CONTAINER then
						bank = bank + self:GetCount(owner, REAGENTBANK_CONTAINER, itemID)
					end

					bank = bank + self:GetCount(owner, BANK_CONTAINER, itemID)
				else
					local owned = GetItemCount(itemID, true)
					local carrying = GetItemCount(itemID)

					bags = carrying - equip
					bank = owned - carrying
				end

				count, text = self:Format(color, L.TipCountEquip, equip, L.TipCountBags, bags, L.TipCountBank, bank, L.TipCountVault, vault)
			elseif Addon.sets.countGuild then
				local guild = 0
				for i = 1, GetNumGuildBankTabs() do
					guild = guild + self:GetCount(owner, i, itemID)
				end

				count, text = self:Format(color, L.TipCountGuild, guild)
			else
				count = 0
			end

			if info.cached then
				self.Text[owner] = self.Text[owner] or {}
				self.Text[owner][itemID] = text
				self.Counts[owner] = self.Counts[owner] or {}
				self.Counts[owner][itemID] = count
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

function TipCounts:GetCount(owner, bag, id)
	local count = 0
	local info = Addon:GetBagInfo(owner, bag)

	for slot = 1, (info.count or 0) do
		if Addon:GetItemID(owner, bag, slot) == id then
			count = count + (Addon:GetItemInfo(owner, bag, slot).count or 1)
		end
	end

	return count
end

function TipCounts:Format(color, ...)
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
