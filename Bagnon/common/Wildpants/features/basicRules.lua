--[[
	basicFilters.lua
		Basic item filters based on item classes
--]]


local ADDON, Addon = ...

local Normal = VOICE_CHAT_NORMAL
local Reagents = MINIMAP_TRACKING_VENDOR_REAGENT
local Key = GetItemClassInfo(LE_ITEM_CLASS_KEY)
local Quiver = GetItemClassInfo(LE_ITEM_CLASS_QUIVER)
local Equipment = BAG_FILTER_EQUIPMENT
local Weapon = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
local Armor = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
local Trinket = INVTYPE_TRINKET
local Projectile = GetItemClassInfo(LE_ITEM_CLASS_PROJECTILE)
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
		if item.class then
			for i, class in ipairs(classes) do
				if itemType == item.class then
					return true
				end
			end
		end
	end

	Addon.Rules:New(id, name, icon, filter)
end

local function ClassSubrule(id, class)
	Addon.Rules:New(id, class, nil, function(_,_,_,_, item)
		return item.class and item.class == class
	end)
end


--[[ Bag Types ]]--

Addon.Rules:New('all', ALL, 'Interface/Icons/INV_Misc_EngGizmos_17')
Addon.Rules:New('all/normal', Normal, nil, function(_,_,_, bag) return bag.family == 0 end)
Addon.Rules:New('all/trade', TRADE, nil, function(_,_,_, bag) return bag.family > 3 end)

if Addon.IsRetail then
	Addon.Rules:New('all/reagent', Reagents, nil, function(_,_,_, bag) return bag.family == -3 end)
else
	--Addon.Rules:New('all/keys', KEYRING, nil, function(_,_,_, bag) return bag.family == -2 end)
	Addon.Rules:New('all/quiver', Quiver, nil, function(_,_,_, bag) return bag.family == 1 or bag.family == 2 end)
	Addon.Rules:New('all/souls', SOUL_SHARDS, nil, function(_,_,_, bag) return bag.family == 3 end)
end


--[[ Simple Categories ]]--

ClassRule('contain', Container, 'Interface/Icons/inv_misc_bag_19', {Container})
ClassRule('quest', Quest, 'Interface/QuestFrame/UI-QuestLog-BookIcon', {Quest})
ClassRule('misc', Misc, 'Interface/Icons/INV_Misc_Rune_01', {Misc})

ClassRule('use', USABLE_ITEMS, 'Interface/Icons/INV_Potion_93', {Consumable, ItemEnhance})
ClassSubrule('use/consume', Consumable)

ClassRule('trade', TRADE, 'Interface/Icons/INV_Fabric_Silk_02', {TradeGoods, Recipe, Gem, Glyph})
ClassSubrule('trade/goods', TradeGoods)
ClassSubrule('trade/recipe', Recipe)

if Addon.IsRetail then
	ClassSubrule('trade/glyph', Glyph)
	ClassSubrule('trade/gem', Gem)
	ClassSubrule('use/enhance', ItemEnhance)
end


--[[ Equipment ]]--

ClassRule('equip', Equipment, 'Interface/Icons/INV_Chest_Chain_04', {Armor, Weapon, Projectile})
ClassSubrule('equip/weapon', Weapon)

Addon.Rules:New('equip/armor', Armor, nil, function(_,_,_,_, item)
	return item.class == Armor and item.equip ~= 'INVTYPE_TRINKET'
end)

Addon.Rules:New('equip/trinket', Trinket, nil, function(_,_,_,_, item)
	return item.equip == 'INVTYPE_TRINKET'
end)

if not Addon.IsRetail then
	ClassSubrule('equip/ammo', Projectile)
end
