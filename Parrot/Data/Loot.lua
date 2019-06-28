local Parrot = Parrot

local mod = Parrot:NewModule("Loot")

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_Loot")
local Deformat = LibStub("LibDeformat-3.0")

local debug = Parrot.debug
local newList, newDict = Parrot.newList, Parrot.newDict

local YOU_LOOT_MONEY = _G.YOU_LOOT_MONEY
local LOOT_MONEY_SPLIT = _G.LOOT_MONEY_SPLIT
local LOOT_ITEM_SELF_MULTIPLE = _G.LOOT_ITEM_SELF_MULTIPLE
local LOOT_ITEM_SELF = _G.LOOT_ITEM_SELF
local LOOT_ITEM_CREATED_SELF = _G.LOOT_ITEM_CREATED_SELF

local GOLD_AMOUNT = _G.GOLD_AMOUNT
local SILVER_AMOUNT = _G.SILVER_AMOUNT
local COPPER_AMOUNT = _G.COPPER_AMOUNT

local function parse_CHAT_MSG_LOOT(chatmsg)
	-- check for multiple-item-loot
	local itemLink, amount = Deformat(chatmsg, LOOT_ITEM_SELF_MULTIPLE)
	if not itemLink then
		itemLink, amount = Deformat(chatmsg, LOOT_ITEM_PUSHED_SELF_MULTIPLE)
	end
	--	if not itemLink then
	--		itemLink, amount = Deformat(chatmsg, LOOT_ITEM_CREATED_SELF_MULTIPLE)
	--	end

	-- check for single-itemloot
	if not itemLink then
		itemLink = Deformat(chatmsg, LOOT_ITEM_SELF)
	end
	if not itemLink then
		itemLink, amount = Deformat(chatmsg, LOOT_ITEM_PUSHED_SELF)
	end
	--	if not itemLink then
	--		itemLink, amount = Deformat(chatmsg, LOOT_ITEM_CREATED_SELF)
	--	end

	-- if something has been looted
	if itemLink then
		if not amount then
			amount = 1
		end
		local oldTotal = GetItemCount(itemLink)
		local total = oldTotal + amount
		return newDict(
			"itemLink", itemLink,
			"amount", amount,
			"total", total
		)
	end
end

if select(2,UnitClass("player")) == "WARLOCK" then
	local SOULSHARDNAME = GetItemInfo(6265) or "Soul Shard"

	local function checkForSoulShard(chatmsg)
		local itemLink = Deformat(chatmsg, LOOT_ITEM_CREATED_SELF)
		if itemLink and itemLink:match(SOULSHARDNAME) then
			return  newDict("itemLink", itemLink,
			"itemName", SOULSHARDNAME)
		end
	end

	Parrot:RegisterCombatEvent{
		category = "Notification",
		name = "Soul shard gains",
		localName = L["Soul shard gains"],
		defaultTag = "+[Name]",
		tagTranslations = {
			Name = "itemName",
			Icon = function(info)
				local itemLink = info.itemLink
				if itemLink then
					local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemLink)
					return texture
				end
			end
		},
		tagTranslationHelp = {
			Name = L["The name of the soul shard."],
		},
		blizzardEvents = {
			["CHAT_MSG_LOOT"] = {
				parse = checkForSoulShard,
			},
		},
		color = "990099", -- purple
		sticky = true,
	}
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Loot"],
	name = "Loot items",
	localName = L["Loot items"],
	defaultTag = L["Loot [Name] +[Amount]([Total])"],
	tagTranslations = {
		Name = function(info)
			local name, _, rarity = GetItemInfo(info.itemLink or info.itemName)
			local color = ITEM_QUALITY_COLORS[rarity]
			if color then
				return color.hex .. name .. "|r"
			else
				return name
			end
		end,
		Amount = "amount",
		Total = function(info)
			return info.total
		end,
		Icon = function(info)
			local itemLink = info.itemLink
			if itemLink then
				local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemLink)
				return texture
			end
		end,
	},
	tagTranslationHelp = {
		Name = L["The name of the item."],
		Amount = L["The amount of items looted."],
		Total = L["The total amount of items in inventory."],
	},
	blizzardEvents = {
		["CHAT_MSG_LOOT"] = {
			-- check = nocheck,
			parse = parse_CHAT_MSG_LOOT,
		},
	},
	color = "ffffff", -- white
}

local function utf8trunc(text, num)
	local len = 0
	local i = 1
	local text_len = #text
	while len < num and i <= text_len do
		len = len + 1
		local b = text:byte(i)
		if b <= 127 then
			i = i + 1
		elseif b <= 223 then
			i = i + 2
		elseif b <= 239 then
			i = i + 3
		else
			i = i + 4
		end
	end
	return text:sub(1, i-1)
end

local GOLD_AMOUNT_inv = GOLD_AMOUNT:gsub("%%d", "%%d+")
local SILVER_AMOUNT_inv = SILVER_AMOUNT:gsub("%%d", "%%d+")
local COPPER_AMOUNT_inv = COPPER_AMOUNT:gsub("%%d", "%%d+")


local GOLD_ABBR = GOLD_AMOUNT:gsub("%%d", ""):gsub(" ", ""):gsub("币", "")
local SILVER_ABBR = SILVER_AMOUNT:gsub("%%d", ""):gsub(" ", ""):gsub("币", "")
local COPPER_ABBR = COPPER_AMOUNT:gsub("%%d", ""):gsub(" ", ""):gsub("币", "")
if GOLD_ABBR:len() == 1 then
	GOLD_ABBR = GOLD_ABBR:lower()
end
if SILVER_ABBR:len() == 1 then
	SILVER_ABBR = SILVER_ABBR:lower()
end
if COPPER_ABBR:len() == 1 then
	COPPER_ABBR = COPPER_ABBR:lower()
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Loot"],
	name = "Loot money",
	localName = L["Loot money"],
	defaultTag = L["Loot +[Amount]"],
	parserEvent = {
		eventType = "Create",
		sourceID = "player",
		itemName = false,
		isCreated = false,
	},
	tagTranslations = {
		Amount = function(info)
			local value = info.amount
			if value >= 10000 then
				return ("%d|cffffd700%s|r%d|cffc7c7cf%s|r%d|cffeda55f%s|r"):format(value/10000, GOLD_ABBR, (value/100)%100, SILVER_ABBR, value%100, COPPER_ABBR)
			elseif value >= 100 then
				return ("%d|cffc7c7cf%s|r%d|cffeda55f%s|r"):format(value/100, SILVER_ABBR, value%100, COPPER_ABBR)
			else
				return ("%d|cffeda55f%s|r"):format(value, COPPER_ABBR)
			end
		end,
		--		Icon = function()
		--			return ""
		--		end
	},
	tagTranslationHelp = {
		Amount = L["The amount of gold looted."],
	},
	color = "ffffff", -- white
	blizzardEvents = {
		["CHAT_MSG_MONEY"] = {
			parse = function(chatmsg)
				local moneystring = Deformat(chatmsg, LOOT_MONEY_SPLIT) or Deformat(chatmsg, YOU_LOOT_MONEY)
				if moneystring then
					local gold = (Deformat(chatmsg:match(GOLD_AMOUNT_inv) or "", GOLD_AMOUNT)) or 0
					local silver = (Deformat(chatmsg:match(SILVER_AMOUNT_inv) or "", SILVER_AMOUNT)) or 0
					local copper = (Deformat(chatmsg:match(COPPER_AMOUNT_inv) or "", COPPER_AMOUNT)) or 0
					return {
						amount = 10000*gold + 100 * silver + copper
					}
				end
			end,
		}
	}
}

