--[[
	basicFilters.lua
		Basic item filters based on item classes
--]]


local ADDON, Addon = ...

local Normal = VOICE_CHAT_NORMAL
local Reagents = MINIMAP_TRACKING_VENDOR_REAGENT
local Equipment = BAG_FILTER_EQUIPMENT
local Weapon = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
local Armor = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
local Trinket = INVTYPE_TRINKET
local Container = GetItemClassInfo(LE_ITEM_CLASS_CONTAINER)
local Consumable = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE)
local ItemEnhance = GetItemClassInfo(LE_ITEM_CLASS_ITEM_ENHANCEMENT)
local TradeGoods = GetItemClassInfo(LE_ITEM_CLASS_TRADEGOODS)
local Recipe = GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
local Gem = GetItemClassInfo(LE_ITEM_CLASS_GEM)
local Glyph = GetItemClassInfo(LE_ITEM_CLASS_GLYPH)
local Quest = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
local Misc = GetItemClassInfo(LE_ITEM_CLASS_MISCELLANEOUS)

local function ClassRule(id, name, icon, classes)
	local filter = function(_,_,_,_, item)
		if item.link then
			local _,_,_,_,_, itemType = GetItemInfo(item.link)
			for i, class in ipairs(classes) do
				if itemType == class then
					return true
				end
			end
		end
	end

	Addon.Rules:New(id, name, icon, filter)
	Addon.Rules:New(id..'/all', ALL, nil, filter)
end

local function ClassSubrule(id, class)
	Addon.Rules:New(id, class, nil, function(_,_,_,_, item)
		if item.link then
			local _,_,_,_,_, itemType = GetItemInfo(item.link)
			return itemType == class
		end
	end)
end

local function GetBagFamily(bag)
	return bag.link and GetItemFamily(bag.link) or 0
end


--[[ Bag Types ]]--

Addon.Rules:New('all', ALL, 'Interface/Icons/INV_Misc_EngGizmos_17')
Addon.Rules:New('all/all', ALL)
Addon.Rules:New('all/normal', Normal, nil, function(_, bag,_, info) return Addon:IsBasicBag(bag) or not Addon:IsReagents(bag) and GetBagFamily(info) == 0 end)
Addon.Rules:New('all/trade', TRADE, nil, function(_,_,_, info) return GetBagFamily(info) > 0 end)
Addon.Rules:New('all/reagent', Reagents, nil, function(_, bag) return Addon:IsReagents(bag) end)


--[[ Simple Categories ]]--

ClassRule('contain', Container, 'Interface/Icons/inv_misc_bag_19', {Container})
ClassRule('quest', Quest, 'Interface/QuestFrame/UI-QuestLog-BookIcon', {Quest})
ClassRule('misc', Misc, 'Interface/Icons/INV_Misc_Rune_01', {Misc})

ClassRule('use', USABLE_ITEMS, 'Interface/Icons/INV_Potion_93', {Consumable, ItemEnhance})
ClassSubrule('use/consume', Consumable)
ClassSubrule('use/enhance', ItemEnhance)

ClassRule('trade', TRADE, 'Interface/Icons/INV_Fabric_Silk_02', {TradeGoods, Recipe, Gem, Glyph})
ClassSubrule('trade/goods', TradeGoods)
ClassSubrule('trade/recipe', Recipe)
ClassSubrule('trade/gem', Gem)
ClassSubrule('trade/glyph', Glyph)


--[[ Equipment ]]--

ClassRule('equip', Equipment, 'Interface/Icons/INV_Chest_Chain_04', {Armor, Weapon})
ClassSubrule('equip/weapon', Weapon)

Addon.Rules:New('equip/armor', Armor, nil, function(_,_,_,_, item)
	if item.link then
		local _,_,_,_,_, class, _,_, equipSlot = GetItemInfo(item.link)
		return class == Armor and equipSlot ~= 'INVTYPE_TRINKET'
	end
end)

Addon.Rules:New('equip/trinket', Trinket, nil, function(_,_,_,_, item)
	if item.link then
		local _,_,_,_,_,_,_,_, equipSlot = GetItemInfo(item.link)
		return equipSlot == 'INVTYPE_TRINKET'
	end
end)
