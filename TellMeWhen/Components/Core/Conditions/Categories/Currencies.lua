-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local CNDT = TMW.CNDT
local Env = CNDT.Env

local currencies = {
	-- currencies were extracted using the script in the /Scripts folder (source is wowhead)
	-- make sure and order them here in a way that makes sense (most common first, etc)

	{
		ID = "CURRENCIES",
		order = 7,
		name = L["CNDTCAT_CURRENCIES"],
		
		1155,	-- Ancient Mana
		1275,	-- Curious Coin
		1220,	-- Order Resources
		1149,	-- Sightless Eye
		1273,	-- Seal of Broken Fate
		1314,	-- Lingering Soul Fragment
		1226,	-- Nethershard
		1342,	--Legionfall War Supplies
		1501,	--Writhing Essence
		1506,	--Argus Waystone
		1508,	--Veiled Argunite
		1533,	--Wakening Essence
		"SPACE",
		1166,	-- Timewarped Badge
		395,	-- Justice Points
		396,	-- Valor Points
		1191,	-- Valor
		1101,	-- Oil
		824,	-- Garrison Resources
		823,	-- Apexis Crystal
		1299,	--Brawler's Gold
		"SPACE",
		392,	-- Honor Points
		390,	-- Conquest Points
		944,	-- Artifact Fragment
		"SPACE",
		391,	-- Tol Barad Commendation
		416,	-- Mark of the World Tree
		241,	-- Champion\'s Seal
		515,	-- Darkmoon Prize Ticket
		777,	-- Timeless Coin
		789,	-- Bloody Coin
		1268,	-- Timeworn Artifact
		1154,	-- Shadowy Coins
		"SPACE",
		738,	-- Lesser Charm of Good Fortune
		697,	-- Elder Charm of Good Fortune
		752,	-- Mogu Rune of Fate
		776,	-- Warforged Seal
		994,	-- Seal of Tempered Fate
		1129,	-- Seal of Inevitable Fate
		"SPACE",
		614,	-- Mote of Darkness
		615,	-- Essence of Corrupted Deathwing
		"SPACE",
		698,	-- Zen Jewelcrafter\'s Token
		361,	-- Illustrious Jewelcrafter\'s Token
		402,	-- Ironpaw Token
		61,		-- Dalaran Jewelcrafter\'s Token
		81,		-- Epicurean\'s Award
		"SPACE",
		910,	-- Secret of Draenor Alchemy
		999,	-- Secret of Draenor Tailoring
		1008,	-- Secret of Draenor Jewelcrafting
		1017,	-- Secret of Draenor Leatherworking
		1020,	-- Secret of Draenor Blacksmithing
		"SPACE",
		810,	-- Black Iron Fragment
		980,	-- Dingy Iron Coins
	},
	{
		ID = "ARCHFRAGS",
		order = 8,
		name = L["CNDTCAT_ARCHFRAGS"],
		
		384,	-- Dwarf Archaeology Fragment
		398,	-- Draenei Archaeology Fragment
		393,	-- Fossil Archaeology Fragment
		394,	-- Night Elf Archaeology Fragment
		397,	-- Orc Archaeology Fragment
		385,	-- Troll Archaeology Fragment
		
		400,	-- Nerubian Archaeology Fragment
		399,	-- Vrykul Archaeology Fragment
		
		401,	-- Tol\'vir Archaeology Fragment
		
		676,	-- Pandaren Archaeology Fragment
		677,	-- Mogu Archaeology Fragment
		754,	-- Mantid Archaeology Fragment

		821,	-- Draenor Clans Archaeology Fragment
		828,	-- Ogre Archaeology Fragment
		829,	-- Arakkoa Archaeology Fragment

		1172,	--Highborne Archaeology Fragment
		1173,	--Highmountain Tauren Archaeology Fragment
		1174,	--Demonic Archaeology Fragment
	}
}

local blacklist = {
	483,	-- Conquest Arena Meta
	484,	-- Conquest Rated BG Meta
	692,	-- Conquest Random BG Meta
	1347,	--Legionfall Building - Personal Tracker - Mage Tower (Hidden)
	1349,	--Legionfall Building - Personal Tracker - Command Tower (Hidden)
	1350,	--Legionfall Building - Personal Tracker - Nether Tower (Hidden)
}


-- Since Legion (and perhaps going back further),
-- Currency data is no longer available immediately on login.
TMW:RegisterCallback("TMW_INITIALIZE", function()
	local numFailed = 0
	local id = 1
	local addedSpace = false
	-- put an absolute cap of 10000 of the id just in case of weird infinite loop cases happening if this API changes.
	while numFailed < 1000 and id < 10000 do
		local name, _, _, _, _, _, hasSeen = GetCurrencyInfo(id)
		if name and hasSeen then
			name = strlower(name)

			local shouldAdd = true
			if TMW.tContains(blacklist, id) then
				shouldAdd = false
			else
				for _, tbl in pairs(currencies) do
					if TMW.tContains(tbl, id) then
						shouldAdd = false
					end
				end
			end

			if shouldAdd then
				if not addedSpace then
					tinsert(currencies[1], 1, "SPACE")
					addedSpace = true
				end
				tinsert(currencies[1], 1, id)
			end

			numFailed = 0
		else
			numFailed = numFailed + 1
		end

		id = id + 1
	end

	local eventsFunc = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("CURRENCY_DISPLAY_UPDATE")
	end
	local hiddenFunc = function(Condition)
		local name, amount, texture, _, _, totalMax, hasSeen = GetCurrencyInfo(Condition.identifier:match("%d+"))
		return not hasSeen
	end


	Env.GetCurrencyInfo = GetCurrencyInfo

	for i, currenciesSub in ipairs(currencies) do
		local ConditionCategory = CNDT:GetCategory(currenciesSub.ID, currenciesSub.order, currenciesSub.name, false, false)
		for i, id in ipairs(currenciesSub) do
			if id == "SPACE" then
				ConditionCategory:RegisterSpacer(i + 0.5)
			else
				local name, amount, texture, _, _, totalMax, hasSeen = GetCurrencyInfo(id)
				ConditionCategory:RegisterCondition(i, "CURRENCY" .. id, {
					text = name,
					icon = texture,
					min = 0,
					range = 500,
					unit = false,
					hidden = hiddenFunc,
					funcstr = [[select(2, GetCurrencyInfo(]] .. id .. [[)) c.Operator c.Level]],
					tcoords = CNDT.COMMON.standardtcoords,
					events = eventsFunc,
				})
			end
		end
	end
end)

-- We used to cache currencies, but this isn't needed anymore.
-- Currency data is always queryable for all currencies.
TMW:RegisterCallback("TMW_OPTIONS_LOADING", function()
	-- This used to happen at version 70021, but I realized now in 72310 that
	-- the locale upgrade was broken, so we will run it again.
	TMW.IE:RegisterUpgrade(72310, {
		global = function(self)
			TMW.IE.db.global.Currencies = nil
		end,
		
		locale = function(self, locale)
			locale.Currencies = nil
		end,
	})
end)
