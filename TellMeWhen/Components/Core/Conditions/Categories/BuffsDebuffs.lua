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
local isNumber = TMW.isNumber
local strlowerCache = TMW.strlowerCache
local huge = math.huge

local UnitAura = UnitAura

function Env.AuraStacks(unit, name, filter)
	for i = 1, huge do
		local buffName, _, count, _, _, _, _, _, _, id = UnitAura(unit, i, filter)

		if not buffName then
			return 0
		elseif id == name or strlowerCache[buffName] == name then
			if count == 0 then
				return 1
			else
				return count
			end
		end
	end
end

function Env.AuraCount(unit, nameRaw, filter)
	local n = 0
	local names = TMW:GetSpells(nameRaw).Hash

	for i = 1, huge do
		local buffName, _, _, _, _, _, _, _, _, id = UnitAura(unit, i, filter)
		if not buffName then
			return n
		elseif names[id] or names[strlowerCache[buffName]] then
			n = n + 1
		end
	end

	return n
end

function Env.AuraDur(unit, name, filter)
	local buffName, _, duration, expirationTime, id 
	for i = 1, huge do
		buffName, _, _, _, duration, expirationTime, _, _, _, id = UnitAura(unit, i, filter)
		if not id or id == name or strlowerCache[buffName] == name then
			break
		end
	end
	
	if not buffName then
		return 0, 0, 0
	else
		return expirationTime == 0 and huge or expirationTime - TMW.time, duration, expirationTime
	end
end

function Env.AuraPercent(unit, name, filter)
	local isID = isNumber[name]
	
	local buffName, duration, expirationTime, id, _
	for i = 1, huge do
		buffName, _, _, _, duration, expirationTime, _, _, _, id = UnitAura(unit, i, filter)
		if not id or id == name or strlowerCache[buffName] == name then
			break
		end
	end
	
	if not buffName then
		return 0
	else
		return expirationTime == 0 and 1 or ((expirationTime - TMW.time) / duration)
	end
end

function Env.AuraVariableNumber(unit, name, filter)
	
	local buffName, id, v1, v2, v3, v4, _
	for i = 1, huge do
		buffName, _, _, _, _, _, _, _, _, id, _, _, _, _, _, v1, v2, v3, v4 = UnitAura(unit, i, filter)
		if not id or id == name or strlowerCache[buffName] == name then
			break
		end
	end
	
	if v1 and v1 > 0 then
		return v1
	elseif v2 and v2 > 0 then
		return v2
	elseif v3 and v3 > 0 then
		return v3
	elseif v4 and v4 > 0 then
		return v4
	end
		
	return 0
end


function Env.AuraTooltipNumber(...)
	local Parser, LT1, LT2 = TMW:GetParser()
	local module = CNDT:NewModule("TooltipParser", "AceEvent-3.0")

	local watchedUnits = {}
	local unitSets = {}
	local cache = setmetatable({}, {
		__mode = 'kv',
		__index = function(s, k)
			s[k] = {}
			return s[k]
		end
	})

	function module:UNIT_AURA(_, unit)
		local unitCache = rawget(cache, unit)
		if unitCache then wipe(unitCache) end
	end
	module:RegisterEvent("UNIT_AURA")

	local function TMW_UNITSET_UPDATED(event, UnitSet)
		local unit = unitSets[UnitSet]
		if unit and UnitSet.allUnitsChangeOnEvent then
			wipe(cache[unit])
		end
	end
	TMW:RegisterCallback("TMW_UNITSET_UPDATED", TMW_UNITSET_UPDATED)

	function Env.AuraTooltipNumber(unit, name, filter, requestedIndex)
		requestedIndex = requestedIndex or 1

		local UnitSet = watchedUnits[unit]
		if not UnitSet then
			-- You're supposed to use TMW:GetUnits(), but this is much faster and is sufficient for our needs.
			UnitSet = TMW.UNITS:GetUnitSet(unit)
			unitSets[UnitSet] = unit
			watchedUnits[unit] = UnitSet
		end

		local cacheable = UnitSet.allUnitsChangeOnEvent
		local cachestr = name .. filter

		if cacheable and cache[unit][cachestr] then
			return isNumber[select(requestedIndex, strsplit(";", cache[unit][cachestr]))] or 0
		end

		local n
		for i = 1, 60 do
			local buffName, _, _, _, _, _, _, _, _, id = UnitAura(unit, i, filter)
			if not buffName then 
				break
			elseif id == name or strlowerCache[buffName] == strlowerCache[name] then
				n = i
				break
			end
		end

		if n then
			local index = 0
		    Parser:SetOwner(UIParent, "ANCHOR_NONE")
		    Parser:SetUnitAura(unit, n, filter)
			local text = LT2:GetText() or ""
			Parser:Hide()

			local number
			local ret
			local allNumbers = ""
			repeat
				number, text = (text):match("([0-9%" .. LARGE_NUMBER_SEPERATOR .. "]+%" .. DECIMAL_SEPERATOR .. "?[0-9]+)(.*)$")

				if number then
					-- Remove large number separators
					number = number:gsub("%" .. LARGE_NUMBER_SEPERATOR, "")
					-- Normalize decimal separators
					number = number:gsub("%" .. DECIMAL_SEPERATOR, ".")

					index = index + 1
					if index == requestedIndex then
						ret = isNumber[number]
					end
					allNumbers = allNumbers .. (index == 1 and "" or ";") .. number
				end
			until not number

			if cacheable then
				cache[unit][cachestr] = allNumbers
			end

			return ret or 0
		else
			if cacheable then
				cache[unit][cachestr] = ""
			end
		end

		return 0
	end

	return Env.AuraTooltipNumber(...)
end


local ConditionCategory = CNDT:GetCategory("BUFFSDEBUFFS", 5, L["CNDTCAT_BUFFSDEBUFFS"], false, false)

ConditionCategory:RegisterCondition(1,	 "BUFFDUR", {
	text = L["ICONMENU_BUFF"] .. " - " .. L["DURATION"],
	range = 30,
	step = 0.1,
	name = function(editbox)
		editbox:SetTexts(L["BUFFTOCHECK"], L["BUFFCNDT_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	formatter = TMW.C.Formatter.TIME_0ABSENT,
	icon = "Interface\\Icons\\spell_nature_rejuvenation",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraDur(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
	anticipate = function(c)
		return [[local dur, duration, expirationTime = AuraDur(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[")
		local VALUE
		if dur and dur > 0 then
			VALUE = expirationTime and expirationTime - c.Level or 0
		else
			VALUE = 0
		end]]
	end,
})
ConditionCategory:RegisterCondition(2.5, "BUFFPERC", {
	--[[
	NEVERMIND. STILL HAS APPLICATION FOR ROGUE DOTS WHOSE DURATION DEPENDS ON COMBO PTS USED

		The percent conditions are being deprecated because a lot of people are
		misusing them. In Warlords of Draenor, the point at which you can refresh
		a buff/debuff without clipping any of the original duration is at 30% of
		the BASE DURATION of the effect. TellMeWhen can't (reliably) determine the
		base duration of an effect - only the game client knows that. A lot of
		users are using these conditions to check when something has less than 30%
		remaining, but this is bad because if you refresh at 30% remaining of an
		already extended aura, you are going to clip some of it.

		I don't want to be misleading people into thinking that these conditions
		are checking things that they aren't able to check, so lets just disable them
		from being chosen.
	]]
	--hidden = true,
	--old = true,
	--tooltip = L["PERCENTAGE_DEPRECATED_DESC"],

	text = L["ICONMENU_BUFF"] .. " - " .. L["DURATION"] .. " - " .. L["PERCENTAGE"],
	min = 0,
	max = 100,
	percent = true,
	name = function(editbox)
		editbox:SetTexts(L["BUFFTOCHECK"], L["BUFFCNDT_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	formatter = TMW.C.Formatter.PERCENT,
	icon = "Interface\\Icons\\spell_holy_circleofrenewal",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraPercent(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
	anticipate = function(c)
		return [[local dur, duration, expirationTime = AuraDur(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[")
		local VALUE
		if dur and dur > 0 then
			VALUE = expirationTime and (expirationTime - c.Level*duration) or 0
		else
			VALUE = 0
		end]]
	end,
})
ConditionCategory:RegisterCondition(2,	 "BUFFDURCOMP", {
	text = L["ICONMENU_BUFF"] .. " - " .. L["DURATION"] .. " - " .. L["COMPARISON"],
	noslide = true,
	name = function(editbox)
		editbox:SetTexts(L["BUFFTOCOMP1"], L["CNDT_ONLYFIRST"])
	end,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	name2 = function(editbox)
		editbox:SetTexts(L["BUFFTOCOMP2"], L["CNDT_ONLYFIRST"])
	end,
	check2 = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	useSUG = true,
	icon = "Interface\\Icons\\spell_nature_rejuvenation",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraDur(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator AuraDur(c.Unit, c.NameFirst2, "HELPFUL]] .. (c.Checked2 and " PLAYER" or "") .. [[")]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})
ConditionCategory:RegisterCondition(3,	 "BUFFSTACKS", {
	text = L["ICONMENU_BUFF"] .. " - " .. L["STACKS"],
	range = 20,
	name = function(editbox)
		editbox:SetTexts(L["BUFFTOCHECK"], L["BUFFCNDT_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	texttable = setmetatable({[0] = format(STACKS, 0).." ("..L["ICONMENU_ABSENT"]..")"}, {__index = function(tbl, k) return format(STACKS, k) end}),
	icon = "Interface\\Icons\\inv_misc_herb_felblossom",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraStacks(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})
ConditionCategory:RegisterCondition(4,	 "BUFFTOOLTIP", {
	text = L["ICONMENU_BUFF"] .. " - " .. L["TOOLTIPSCAN"],
	tooltip = L["TOOLTIPSCAN_DESC"],
	range = 500,
	--texttable = {[0] = "0 ("..L["ICONMENU_ABSENT"]..")"},
	name = function(editbox)
		editbox:SetTexts(L["BUFFTOCHECK"], L["TOOLTIPSCAN_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	icon = "Interface\\Icons\\inv_elemental_primal_mana",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraVariableNumber(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})
for i = 1, 3 do -- BUFFTOOLTIPSCAN
	ConditionCategory:RegisterCondition(4 + 0.1*i,	 "BUFFTOOLTIPSCAN" .. i, {
		text = L["ICONMENU_BUFF"] .. " - " .. L["TOOLTIPSCAN2"]:format(i),
		tooltip = L["TOOLTIPSCAN2_DESC"],
		range = 500,
		--texttable = {[0] = "0 ("..L["ICONMENU_ABSENT"]..")"},
		name = function(editbox)
			editbox:SetTexts(L["BUFFTOCHECK"], L["TOOLTIPSCAN2_DESC"])
		end,
		useSUG = true,
		check = function(check)
			check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
		end,
		icon = "Interface\\Icons\\ability_priest_clarityofwill",
		tcoords = CNDT.COMMON.standardtcoords,
		funcstr = function(c)
			return [[AuraTooltipNumber(c.Unit, c.NameFirst, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[", ]] .. i .. [[) c.Operator c.Level]]
		end,
		events = function(ConditionObject, c)
			return
				ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
				ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
		end,
	})
end
ConditionCategory:RegisterCondition(5,	 "BUFFNUMBER", {
	text = L["ICONMENU_BUFF"] .. " - " .. L["NUMAURAS"],
	tooltip = L["NUMAURAS_DESC"],
	min = 0,
	max = 20,
	name = function(editbox)
		editbox:SetTexts(L["BUFFTOCHECK"], L["CNDT_MULTIPLEVALID"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	texttable = function(k) return format(L["ACTIVE"], k) end,
	icon = "Interface\\Icons\\ability_paladin_sacredcleansing",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraCount(c.Unit, c.NameRaw, "HELPFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterSpacer(8)

ConditionCategory:RegisterCondition(9,	 "ABSORBAMT", {
	text = L["ABSORBAMT"],
	tooltip = L["ABSORBAMT_DESC"],
	range = 50000,
	icon = "Interface\\Icons\\spell_holy_powerwordshield",
	formatter = TMW.C.Formatter.COMMANUMBER,
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitGetTotalAbsorbs = UnitGetTotalAbsorbs,
	},
	funcstr = function(c)
		return [[UnitGetTotalAbsorbs(c.Unit) c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_ABSORB_AMOUNT_CHANGED", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterSpacer(10)

ConditionCategory:RegisterCondition(11,	 "DEBUFFDUR", {
	text = L["ICONMENU_DEBUFF"] .. " - " .. L["DURATION"],
	range = 30,
	step = 0.1,
	name = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCHECK"], L["BUFFCNDT_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	formatter = TMW.C.Formatter.TIME_0ABSENT,
	icon = "Interface\\Icons\\spell_shadow_abominationexplosion",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraDur(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
	anticipate = function(c)
		return [[local dur, duration, expirationTime = AuraDur(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[")
		local VALUE
		if dur and dur > 0 then
			VALUE = expirationTime and expirationTime - c.Level or 0
		else
			VALUE = 0
		end]]
	end,
})
ConditionCategory:RegisterCondition(12.5,"DEBUFFPERC", {
	--[[
	NEVERMIND. STILL HAS APPLICATION FOR ROGUE DOTS WHOSE DURATION DEPENDS ON COMBO PTS USED

		The percent conditions are being deprecated because a lot of people are
		misusing them. In Warlords of Draenor, the point at which you can refresh
		a buff/debuff without clipping any of the original duration is at 30% of
		the BASE DURATION of the effect. TellMeWhen can't (reliably) determine the
		base duration of an effect - only the game client knows that. A lot of
		users are using these conditions to check when something has less than 30%
		remaining, but this is bad because if you refresh at 30% remaining of an
		already extended aura, you are going to clip some of it.

		I don't want to be misleading people into thinking that these conditions
		are checking things that they aren't able to check, so lets just disable them
		from being chosen.
	]]
	--hidden = true,
	--old = true,
	--tooltip = L["PERCENTAGE_DEPRECATED_DESC"],

	text = L["ICONMENU_DEBUFF"] .. " - " .. L["DURATION"] .. " - " .. L["PERCENTAGE"],
	min = 0,
	max = 100,
	percent = true,
	name = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCHECK"], L["BUFFCNDT_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	formatter = TMW.C.Formatter.PERCENT,
	icon = "Interface\\Icons\\spell_priest_voidshift",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraPercent(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
	anticipate = function(c)
		return [[local dur, duration, expirationTime = AuraDur(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[")
		local VALUE
		if dur and dur > 0 then
			VALUE = expirationTime and (expirationTime - c.Level*duration) or 0
		else
			VALUE = 0
		end]]
	end,
})
ConditionCategory:RegisterCondition(12,	 "DEBUFFDURCOMP", {
	text = L["ICONMENU_DEBUFF"] .. " - " .. L["DURATION"] .. " - " .. L["COMPARISON"],
	noslide = true,
	name = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCOMP1"], L["CNDT_ONLYFIRST"])
	end,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	name2 = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCOMP2"], L["CNDT_ONLYFIRST"])
	end,
	check2 = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	useSUG = true,
	icon = "Interface\\Icons\\spell_shadow_abominationexplosion",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraDur(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator AuraDur(c.Unit, c.NameFirst2, "HARMFUL]] .. (c.Checked2 and " PLAYER" or "") .. [[")]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
	-- anticipate: no anticipator is needed because the durations will always remain the same relative to eachother until at least a UNIT_AURA fires
})
ConditionCategory:RegisterCondition(13,	 "DEBUFFSTACKS", {
	text = L["ICONMENU_DEBUFF"] .. " - " .. L["STACKS"],
	range = 20,
	name = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCHECK"], L["BUFFCNDT_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	texttable = setmetatable({[0] = format(STACKS, 0).." ("..L["ICONMENU_ABSENT"]..")"}, {__index = function(tbl, k) return format(STACKS, k) end}),
	icon = "Interface\\Icons\\ability_warrior_sunder",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraStacks(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})
ConditionCategory:RegisterCondition(14,	 "DEBUFFTOOLTIP", {
	text = L["ICONMENU_DEBUFF"] .. " - " .. L["TOOLTIPSCAN"],
	tooltip = L["TOOLTIPSCAN_DESC"],
	range = 500,
	--texttable = {[0] = "0 ("..L["ICONMENU_ABSENT"]..")"},
	name = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCHECK"], L["TOOLTIPSCAN_DESC"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	icon = "Interface\\Icons\\spell_shadow_lifedrain",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraVariableNumber(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})
for i = 1, 3 do -- BUFFTOOLTIPSCAN
	ConditionCategory:RegisterCondition(14 + 0.1*i,	 "DEBUFFTOOLTIPSCAN" .. i, {
		text = L["ICONMENU_DEBUFF"] .. " - " .. L["TOOLTIPSCAN2"]:format(i),
		tooltip = L["TOOLTIPSCAN2_DESC"],
		range = 500,
		--texttable = {[0] = "0 ("..L["ICONMENU_ABSENT"]..")"},
		name = function(editbox)
			editbox:SetTexts(L["DEBUFFTOCHECK"], L["TOOLTIPSCAN2_DESC"])
		end,
		useSUG = true,
		check = function(check)
			check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
		end,
		icon = "Interface\\Icons\\spell_fire_flameshock",
		tcoords = CNDT.COMMON.standardtcoords,
		funcstr = function(c)
			return [[AuraTooltipNumber(c.Unit, c.NameFirst, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[", ]] .. i .. [[) c.Operator c.Level]]
		end,
		events = function(ConditionObject, c)
			return
				ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
				ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
		end,
	})
end
ConditionCategory:RegisterCondition(15,	 "DEBUFFNUMBER", {
	text = L["ICONMENU_DEBUFF"] .. " - " .. L["NUMAURAS"],
	tooltip = L["NUMAURAS_DESC"],
	min = 0,
	max = 20,
	name = function(editbox)
		editbox:SetTexts(L["DEBUFFTOCHECK"], L["CNDT_MULTIPLEVALID"])
	end,
	useSUG = true,
	check = function(check)
		check:SetTexts(L["ONLYCHECKMINE"], L["ONLYCHECKMINE_DESC"])
	end,
	texttable = function(k) return format(L["ACTIVE"], k) end,
	icon = "Interface\\Icons\\spell_deathknight_frostfever",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c)
		return [[AuraCount(c.Unit, c.NameRaw, "HARMFUL]] .. (c.Checked and " PLAYER" or "") .. [[") c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterSpacer(20)

Env.GetWeaponEnchantInfo = GetWeaponEnchantInfo
ConditionCategory:RegisterCondition(21,	 "MAINHAND", {
	text = L["ICONMENU_WPNENCHANT"] .. " - " .. INVTYPE_WEAPONMAINHAND,
	range = 120,
	unit = false,
	formatter = TMW.C.Formatter.TIME_0ABSENT,
	icon = function() return GetInventoryItemTexture("player", GetInventorySlotInfo("MainHandSlot")) or "Interface\\Icons\\inv_weapon_shortblade_14" end,
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[(select(2, GetWeaponEnchantInfo()) or 0)/1000 c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_INVENTORY_CHANGED", "player")
	end,
	anticipate = [[local _, dur = GetWeaponEnchantInfo()
		local VALUE = time + ((dur or 0)/1000) - c.Level]],
})
ConditionCategory:RegisterCondition(22,	 "OFFHAND", {
	text = L["ICONMENU_WPNENCHANT"] .. " - " .. INVTYPE_WEAPONOFFHAND,
	range = 120,
	unit = false,
	formatter = TMW.C.Formatter.TIME_0ABSENT,
	icon = function() return GetInventoryItemTexture("player", GetInventorySlotInfo("SecondaryHandSlot")) or "Interface\\Icons\\inv_weapon_shortblade_15" end,
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[(select(5, GetWeaponEnchantInfo()) or 0)/1000 c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_INVENTORY_CHANGED", "player")
	end,
	anticipate = [[local _, _, _, _, dur = GetWeaponEnchantInfo()
		local VALUE = time + ((dur or 0)/1000) - c.Level]],
})
