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

local SUG = TMW.SUG

local BableCT = LibStub("LibBabble-CreatureType-3.0"):GetLookupTable()

local Module = SUG:NewModule("creaturetype", SUG:GetModule("default"))
Module.noMin = true
Module.noTexture = true
Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]

Module.ENGLISH_TYPES = {
	"Aberration",
	"Beast",
	"Critter",
	"Demon",
	"Dragonkin",
	"Elemental",
	"Gas Cloud",
	"Giant",
	"Humanoid",
	"Mechanical",
	"Non-combat Pet",
	"Not specified",
	"Totem",
	"Undead",
	"Wild Pet",
}

function Module:Entry_AddToList_1(f, index)
	local creaturetypeEnglish = Module.ENGLISH_TYPES[index]
	local creaturetypeLocalized = BableCT[creaturetypeEnglish]
	
	f.tooltiptitle = creaturetypeLocalized
	
	f.Name:SetText(creaturetypeLocalized)
	
	f.insert = creaturetypeLocalized
end
function Module:Table_GetNormalSuggestions(suggestions, tbl)
	local lastName = SUG.lastName


	for index, creaturetypeEnglish in pairs(self.ENGLISH_TYPES) do
		local creaturetypeLocalized = BableCT[creaturetypeEnglish]
	
		if strfind(strlower(creaturetypeLocalized), lastName) then
			suggestions[#suggestions + 1] = index
		end
	end
end
function Module:Table_GetSorter()
	return nil
end

