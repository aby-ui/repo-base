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

local UnitName, UnitClass, IsInRaid, GetNumGroupMembers, GetNumSubgroupMembers =
	  UnitName, UnitClass, IsInRaid, GetNumGroupMembers, GetNumSubgroupMembers
local GetNumRaidMembers, GetNumPartyMembers =
	  GetNumRaidMembers, GetNumPartyMembers
local strsub, select, pairs, strfind, wipe, strlower =
	  strsub, select, pairs, strfind, wipe, strlower

local SUG = TMW.SUG

local Module = SUG:NewModule("units", SUG:GetModule("default"))
Module.noMin = true
Module.noTexture = true
Module.table = TMW.UNITS.Units
Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]

function Module:Table_Get()
	return self.table
end

function Module:Entry_AddToList_1(f, index)

	local isSpecial = strsub(index, 1, 1) == "%"
	local prefix = isSpecial and strsub(index, 1, 2)
	
	if not isSpecial then
		local unitData = self.table[index]
		if unitData then
			local unit = unitData.value
			
			f.tooltiptitle = unitData.tooltipTitle or unitData.text
			
			if unitData.range then
				unit = unit .. " 1-" .. unitData.range
			end

			f.tooltiptext = unitData.desc
			
			f.Name:SetText(unit)
			f.insert = unit
			f.overrideInsertName = L["SUG_INSERTTUNITID"]
		else			
			f.Name:SetText("<ERROR>")
			f.insert = ""
		end
	else
	
		if prefix == "%P" then
			local name = strsub(index, 3)
			
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(name))]
			
			if not color then
				color = ""
			else
				-- GLOBALS: CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
				if color.colorStr then
					color = "|c" .. color.colorStr
				else
					color = "|c" .. TMW:RGBATableToStringWithoutFlags(color)
				end
			end
	
			f.Name:SetText(color .. name)
			f.insert = name
			
		elseif prefix == "%A" then
			local name = SUG.lastName_unmodified
			--name = name:gsub("^(%a)", strupper)
			f.Name:SetText(name)
			f.insert = name
		end
	end
	
	if not f.tooltiptitle then
		f.tooltiptitle = f.insert
	end
end

function Module:Table_GetNormalSuggestions(suggestions, tbl)
	local atBeginning = SUG.atBeginning
	
	for index, unitData in pairs(tbl) do
		if strfind(unitData.value, atBeginning) then
			suggestions[#suggestions + 1] = index
		end
	end
end

function Module:Table_GetSpecialSuggestions_1(suggestions)
	local atBeginning = SUG.atBeginning
	self:UpdateGroupedPlayersMap()
	
	for name in pairs(self.groupedPlayers) do
		if SUG.inputType == "number" or strfind(strlower(name), atBeginning) then
			suggestions[#suggestions + 1] = "%P" .. name
		end
	end
	
	if #SUG.lastName > 0 then
		suggestions[#suggestions + 1] = "%A"
	end
	
	TMW.tRemoveDuplicates(suggestions)
end

function Module.Sorter_Units(a, b)
	--sort by name
	
	local special_a, special_b = strsub(a, 1, 1), strsub(b, 1, 1)
	local prefix_a, prefix_b = strsub(a, 1, 2), strsub(b, 1, 2)
	
	local lastName = SUG.lastName

	local t_a, t_b = Module.table[a], Module.table[b]
	local haveA, haveB = t_a and strfind(t_a.value, lastName), t_b and strfind(t_b.value, lastName)
	if (haveA and not haveB) or (haveB and not haveA) then
		return haveA
	end

	local haveA, haveB = special_a ~= "%", special_b ~= "%"
	if (haveA ~= haveB) then
		return haveA
	end
	
	local haveA, haveB = prefix_a == "%P", prefix_b == "%P"
	if (haveA ~= haveB) then
		return haveA
	end
	
	local haveA, haveB = prefix_a == "%A", prefix_b == "%A"
	if (haveA ~= haveB) then
		return haveA
	end
	
	--sort by index/alphabetical/whatever
	return a < b
end

function Module:Table_GetSorter()
	return self.Sorter_Units
end

Module.groupedPlayers = {}
function Module:UpdateGroupedPlayersMap()
	local groupedPlayers = self.groupedPlayers

	wipe(groupedPlayers)
	
	local numRaidMembers = IsInRaid() and GetNumGroupMembers() or 0
	local numPartyMembers = GetNumSubgroupMembers()
	
	groupedPlayers[UnitName("player")] = true
	if UnitName("pet") then
		groupedPlayers[UnitName("pet")] = true
	end
	
	-- Raid Players
	for i = 1, numRaidMembers do
		local name = UnitName("raid" .. i)
		groupedPlayers[name] = true
	end
	
	-- Party Players
	for i = 1, numPartyMembers do
		local name = UnitName("party" .. i)
		groupedPlayers[name] = true
	end
end



local Module = SUG:NewModule("unitconditionunits", SUG:GetModule("units"))
Module.table = {
	{ value = "unit",		text = L["UNITCONDITIONS_STATICUNIT"],			desc = L["UNITCONDITIONS_STATICUNIT_DESC"]			},
	{ value = "unittarget",	text = L["UNITCONDITIONS_STATICUNIT_TARGET"],	desc = L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"]	},
}

-- No sorting. Override the inherited function.
Module.Table_GetSorter = TMW.NULLFUNC

-- No specials. Override the inherited function.
Module.Table_GetSpecialSuggestions_1 = TMW.NULLFUNC
