local Parrot = Parrot

local mod = Parrot:NewModule("Cooldowns", "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_Cooldowns")

local newList, del = Parrot.newList, Parrot.del
local deepCopy = Parrot.deepCopy
local debug = Parrot.debug

local wipe = table.wipe

local db = nil
local dbDefaults = {
	profile = {
		threshold = 0,
		filters = {},
	}
}

local GCD = 1.8

function mod:OnInitialize()
	db = Parrot.db1:RegisterNamespace("Cooldowns", dbDefaults)
end

function mod:OnEnable()
	self:ResetSpells()
	self:ScheduleRepeatingTimer("OnUpdate", 0.1)
	self:RegisterEvent("SPELLS_CHANGED", "ResetSpells")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Cooldowns"],
	name = "Skill cooldown finish",
	localName = L["Skill cooldown finish"],
	defaultTag = L["[[Spell] ready!]"],
	tagTranslations = {
		Spell = 1,
		Icon = 2,
	},
	tagTranslationHelp = {
		Spell = L["The name of the spell or ability which is ready to be used."],
	},
	color = "ffffff", -- white
	sticky = false,
}

local cooldowns = {}
local spellNameToTree = {}

local nextUpdate
local lastRecalc
local recalcTimer

local function recalcCooldowns()
	local expired = newList()
	local minCD -- find the Cooldown closest to expiration
	for spell, tree in pairs(spellNameToTree) do
		local old = cooldowns[spell]
		local start, duration = GetSpellCooldown(spell)
		local check = (start and duration) and start > 0 and duration > GCD and duration > db.profile.threshold
		cooldowns[spell] = check or nil
		if old and not check then -- cooldown expired
			expired[spell] = tree
		end
		local exp = duration and (duration - GetTime() + start) or 0 -- remaining Cooldown
		if check and (not minCD or minCD > exp) then
			minCD = exp
		end -- if check
	end -- for spell
	nextUpdate = minCD and GetTime() + minCD or nil
	lastRecalc = GetTime()
	return expired
end

local function delayedRecalc()
	recalcTimer = nil
	mod:OnUpdate(true)
end

function mod:SPELL_UPDATE_COOLDOWN()
	-- if the last update was less then 0.1 seconds ago, the update will be
	-- delayed by 0.1 seconds
	if lastRecalc and (GetTime() - lastRecalc) < 0.1 then
		if not recalcTimer then
			self:ScheduleTimer(delayedRecalc, 0.1, true)
		end
		return
	end
	mod:OnUpdate(true)
end

function mod:ResetSpells()
	wipe(cooldowns)
	wipe(spellNameToTree)
	for i = 1, GetNumSpellTabs() do
		local _, _, offset, num = GetSpellTabInfo(i)
		for j = 1, num do
			local id = offset+j
			local spell = GetSpellBookItemName(id, "spell")
			if GetSpellInfo(spell) then
				spellNameToTree[spell] = i
			end
		end
	end
	mod:OnUpdate(true)
end

local groups = {}
local function addGroup(name, ...)
	for i=1,select('#', ...) do
		local id = select(i, ...)
		local spell = GetSpellInfo(id)
		if spell then
			groups[spell] = name
		else
			debug("spell is missing: ", id)
		end
	end
end

addGroup(L["Frost traps"], 1499, 13809) -- "Freezing Trap", "Ice Trap"
addGroup(L["Fire traps"], 13795, 13813, 20733) -- "Immolation Trap", "Explosive Trap", "Black Arrow"
addGroup(L["Shocks"], 8042, 8050, 8056) -- Earth Shock, Flame Shock, Frost Shock
addGroup(L["Strikes"], 17364, 73899) -- Stormstrike, Primal Strike

local itemCooldowns = {}
local function checkItems()
	local minCD
	for i = 1,19 do
		local start, duration, enable = GetInventoryItemCooldown("player", i)
		local link = GetInventoryItemLink("player",i)
		if link then
			local icd = itemCooldowns[link]
			if icd and start == 0 then --cooldown expired
				if icd == i then
					local name = GetItemInfo(link)
					Parrot:FirePrimaryTriggerCondition("Item cooldown ready", name)
				end
				itemCooldowns[link] = nil
			elseif not icd and start ~= 0 then -- new cooldown
				local name = GetItemInfo(link)
				itemCooldowns[link] = i
			end -- other cases don't require any handling
		end
		local exp = duration - GetTime() + start -- remaining Cooldown
		if start > 0 and (not minCD or minCD > exp) then
			minCD = exp
		end -- if check
	end
	if minCD then
		local nextUpdate2 = GetTime() + minCD
		if nextUpdate then
			nextUpdate = math.min(nextUpdate2, nextUpdate)
		else
			nextUpdate =  nextUpdate2
		end
	end
end

function mod:OnUpdate(force)
	if (not nextUpdate or nextUpdate > GetTime()) and not force then
		-- only run the update when the time is right
		return
	end
	local expired2 = recalcCooldowns()
	checkItems()
	if not next(expired2) then
		expired2 = del(expired2)
		return
	end
	local treeCount = newList()
	for name, tree in pairs(expired2) do
		Parrot:FirePrimaryTriggerCondition("Spell ready", name)
		if not groups[name] then
			treeCount[tree] = (treeCount[tree] or 0) + 1
		end
	end
	for tree, num in pairs(treeCount) do
		if num >= 3 then
			for name, tree2 in pairs(expired2) do
				-- remove all spells from that tree from the list
				if tree == tree2 then
					expired2[name] = nil
				end
			end
			local name, texture = GetSpellTabInfo(tree)
			debug(tree, " - ", name)
			local info = newList(L["%s Tree"]:format(name or ""), texture)
			Parrot:TriggerCombatEvent("Notification", "Skill cooldown finish", info)
			info = del(info)
		end
	end
	treeCount = del(treeCount)
	local groupsToTrigger = newList()
	for name in pairs(expired2) do
		if groups[name] then
			groupsToTrigger[groups[name]] = true
			expired2[name] = nil
		end
	end
	for name in pairs(groupsToTrigger) do
		local info = newList(name)
		Parrot:TriggerCombatEvent("Notification", "Skill cooldown finish", info)
		info = del(info)
	end
	groupsToTrigger = del(groupsToTrigger)
	for name in pairs(expired2) do
		local _, _, texture = GetSpellInfo(name)
		local info = newList(name, texture)
		Parrot:TriggerCombatEvent("Notification", "Skill cooldown finish", info)
		info = del(info)
	end
	expired2 = del(expired2)
end

local function parseSpell(arg)
	return tostring(arg or "")
end
local function saveSpell(arg)
	return tonumber(arg) or arg
end

Parrot:RegisterPrimaryTriggerCondition {
	subCategory = L["Cooldowns"],
	name = "Spell ready",
	localName = L["Spell ready"],
	param = {
		type = 'string',
		usage = L["<Spell name>"],
		save = saveSpell,
		parse = parseSpell,
	},
}

Parrot:RegisterPrimaryTriggerCondition {
	subCategory = L["Cooldowns"],
	name = "Item cooldown ready",
	localName = L["Item cooldown ready"],
	param = {
		type = 'string',
		usage = L["<Item name>"],
	},
}

Parrot:RegisterSecondaryTriggerCondition {
	subCategory = L["Cooldowns"],
	name = "Spell ready",
	localName = L["Spell ready"],
	param = {
		type = 'string',
		usage = L["<Spell name>"],
		save = saveSpell,
		parse = parseSpell,
	},
	check = function(param)
		if(tonumber(param)) then
			param = GetSpellInfo(param)
		elseif(type(param) == 'string') then
			return (GetSpellCooldown(param) == 0)
		else
			debug("param was not a string but ", type(param))
			return false
		end
	end,
}

Parrot:RegisterSecondaryTriggerCondition {
	subCategory = L["Cooldowns"],
	name = "Spell usable",
	localName = L["Spell usable"],
	param = {
		type = 'string',
		usage = L["<Spell name>"],
		save = saveSpell,
		parse = parseSpell,
	},
	check = function(param)
		if(tonumber(param)) then
			param = GetSpellInfo(param)
		end

		return IsUsableSpell(param)
	end,
}

function mod:OnOptionsCreate()
	local cd_opt = {
		type = 'group',
		name = L["Cooldowns"],
		desc = L["Cooldowns"],
		args = {
			threshold = {
				name = L["Threshold"],
				desc = L["Minimum time the cooldown must have (in seconds)"],
				type = 'range',
				min = 0,
				max = 300,
				step = 1,
				bigStep = 10,
				get = function() return db.profile.threshold end,
				set = function(info, value) db.profile.threshold = value end,
				order = 1,
			},
		},
		order = 100,
	}

	local function removeFilter(spellName)
		cd_opt.args[spellName] = nil
		db.profile.filters[spellName] = nil
		mod:ResetSpells()
	end

	local function addFilter(spellName)
		if cd_opt.args[spellName] then return end
		db.profile.filters[spellName] = true
		local button = {
			type = 'execute',
			name = spellName,
			desc = L["Click to remove"],
			func = function(info) removeFilter(info.arg) end,
			arg = spellName,
		}
		cd_opt.args[spellName] = button
	end

	cd_opt.args.newFilter = {
		type = 'input',
		name = L["Ignore"],
		desc = L["Ignore Cooldown"],
		get = function() return end,
		set = function(info, value) addFilter(value); mod:ResetSpells() end,
		order = 2,
	}

	for k,v in pairs(db.profile.filters) do
		addFilter(k)
	end

	Parrot:AddOption('cooldowns', cd_opt)
end

