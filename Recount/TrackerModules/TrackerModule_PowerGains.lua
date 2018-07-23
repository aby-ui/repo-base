local Recount = _G.Recount

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale( "Recount" )

local revision = tonumber(string.sub("$Revision: 1453 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local GameTooltip = GameTooltip

local dbCombatants
local srcRetention
local dstRetention

local DetailTitles = { }
DetailTitles.Gained = {
	TopNames = L["Ability"],
	TopCount = "",
	TopAmount = L["Gained"],
	BotNames = L["From"],
	BotMin = "",
	BotAvg = "",
	BotMax = "",
	BotAmount = L["Gained"]
}

DetailTitles.GainedFrom = {
	TopNames = L["From"],
	TopCount = "",
	TopAmount = L["Gained"],
	BotNames = L["Ability"],
	BotMin = "",
	BotAvg = "",
	BotMax = "",
	BotAmount = L["Gained"]
}

local POWERTYPE_MANA = 0
local POWERTYPE_RAGE = 1
local POWERTYPE_FOCUS = 2
local POWERTYPE_ENERGY = 3
local POWERTYPE_HAPPINESS = 4
local POWERTYPE_RUNES = 5
local POWERTYPE_RUNIC_POWER = 6
local POWERTYPE_LUNAR_POWER = 8
local POWERTYPE_MAELSTROM = 11
local POWERTYPE_FURY = 17
local POWERTYPE_PAIN = 18

local PowerTypeName = { -- Elsia: Do NOT localize this, it breaks functionality!!! If you need this localized contact me on WowAce or Curse.
	[POWERTYPE_MANA] = "Mana",
	[POWERTYPE_RAGE] = "Rage",
	[POWERTYPE_ENERGY] = "Energy",
	[POWERTYPE_FOCUS] = "Focus",
	[POWERTYPE_HAPPINESS] = "Happiness",
	[POWERTYPE_RUNES] = "Runes",
	[POWERTYPE_RUNIC_POWER] = "Runic Power",
	[POWERTYPE_LUNAR_POWER] = "Astral Power",
	[POWERTYPE_MAELSTROM] = "Maelstorm",
	[POWERTYPE_FURY] = "Fury",
	[POWERTYPE_PAIN] = "Pain",
}

function Recount:SpellEnergize(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overEnergized, powerType)
	Recount:AddGain(dstName, srcName, spellName, amount, PowerTypeName[powerType], dstGUID, dstFlags, srcGUID, srcFlags, spellId)
end

function Recount:SpellLeech(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,spellId, spellName, spellSchool, amount, powerType, extraAmount)
	Recount:AddGain(srcName, dstName, spellName, extraAmount, PowerTypeName[powerType], srcGUID, srcFlags, dstGUID, dstFlags, spellId)
end

local DataAmount, DataTable, DataTable2
function Recount:AddGain(source, victim, ability, amount, attribute,srcGUID,srcFlags,dstGUID,dstFlags,spellId)

	if attribute == "Mana" then
		DataAmount = "ManaGain"
		DataTable = "ManaGained"
		DataTable2 = "ManaGainedFrom"
	elseif attribute == "Energy" or attribute == "Focus" then -- Elsia: Focus for pet.
		DataAmount = "EnergyGain"
		DataTable = "EnergyGained"
		DataTable2 = "EnergyGainedFrom"
	elseif attribute == "Rage" then
		DataAmount = "RageGain"
		DataTable = "RageGained"
		DataTable2 = "RageGainedFrom"
	elseif attribute == "Runic Power" then
		DataAmount = "RunicPowerGain"
		DataTable = "RunicPowerGained"
		DataTable2 = "RunicPowerGainedFrom"
	elseif attribute == "Astral Power" then
		DataAmount = "AstralPowerGain"
		DataTable = "AstralPowerGained"
		DataTable2 = "AstralPowerGainedFrom"
	elseif attribute == "Maelstorm" then
		DataAmount = "MaelstormGain"
		DataTable = "MaelstormGained"
		DataTable2 = "MaelstormGainedFrom"
	elseif attribute == "Fury" then
		DataAmount = "FuryGain"
		DataTable = "FuryGained"
		DataTable2 = "FuryGainedFrom"
	elseif attribute == "Pain" then
		DataAmount = "PainGain"
		DataTable = "PainGained"
		DataTable2 = "PainGainedFrom"
	else
		return
	end

	-- Name and ID of pet owners
	local sourceowner
	local sourceownerID
	local victimowner
	local victimownerID

	source, sourceowner, sourceownerID = Recount:DetectPet(source, srcGUID, srcFlags)
	victim, victimowner, victimownerID = Recount:DetectPet(victim, dstGUID, dstFlags)

	srcRetention = Recount.srcRetention
	if srcRetention then

		if not dbCombatants[source] then
			Recount:AddCombatant(source, sourceowner, srcGUID, srcFlags, sourceownerID)
		end -- Elsia: Until here is if pets heal anybody.
		local sourceData = dbCombatants[source]
		Recount:SetActive(sourceData)

		Recount:AddAmount(sourceData,DataAmount,amount)
		Recount:AddTableDataSum(sourceData, DataTable, ability, victim, amount)
		Recount:AddTableDataSum(sourceData, DataTable2, victim, ability, amount)
	end
end

local DataModes = { }

function DataModes:ManaGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].ManaGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].ManaGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].ManaGained, L["'s Mana Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].ManaGainedFrom, L["'s Mana Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:EnergyGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].EnergyGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].EnergyGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].EnergyGained, L["'s Energy Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].EnergyGainedFrom, L["'s Energy Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:RageGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].RageGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].RageGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].RageGained, L["'s Rage Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].RageGainedFrom, L["'s Rage Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:RunicPowerGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].RunicPowerGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].RunicPowerGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].RunicPowerGained, L["'s Runic Power Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].RunicPowerGainedFrom, L["'s Runic Power Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:AstralPowerGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].AstralPowerGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].AstralPowerGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].AstralPowerGained, L["'s Astral Power Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].AstralPowerGainedFrom, L["'s Astral Power Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:MaelstormGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].MaelstormGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].MaelstormGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].MaelstormGained, L["'s Maelstorm Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].MaelstormGainedFrom, L["'s Maelstorm Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:FuryGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].FuryGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].FuryGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].FuryGained, L["'s Fury Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].FuryGainedFrom, L["'s Fury Gained From"], DetailTitles.GainedFrom}}
end

function DataModes:PainGained(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].PainGain or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].PainGain or 0), {{data.Fights[Recount.db.profile.CurDataSet].PainGained, L["'s Pain Gained"], DetailTitles.Gained}, {data.Fights[Recount.db.profile.CurDataSet].PainGainedFrom, L["'s Pain Gained From"], DetailTitles.GainedFrom}}
end

local TooltipFuncs = { }

function TooltipFuncs:ManaGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Mana Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].ManaGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Mana Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].ManaGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:EnergyGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Energy Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].EnergyGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Energy Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].EnergyGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:RageGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Rage Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].RageGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Rage Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].RageGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:RunicPowerGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Runic Power Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].RunicPowerGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Runic Power Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].RunicPowerGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:AstralPowerGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Astral Power Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].AstralPowerGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Astral Power Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].AstralPowerGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:MaelstormGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Maelstorm Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].MaelstormGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Maelstorm Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].MaelstormGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:FuryGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Fury Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].FuryGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Fury Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].FuryGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:PainGained(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Pain Abilities"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].PainGained, 3)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Pain Sources"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].PainGainedFrom, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

Recount:AddModeTooltip(L["Mana Gained"], DataModes.ManaGained, TooltipFuncs.ManaGained)
Recount:AddModeTooltip(L["Energy Gained"], DataModes.EnergyGained, TooltipFuncs.EnergyGained)
Recount:AddModeTooltip(L["Rage Gained"], DataModes.RageGained, TooltipFuncs.RageGained)
Recount:AddModeTooltip(L["Runic Power Gained"], DataModes.RunicPowerGained, TooltipFuncs.RunicPowerGained)
Recount:AddModeTooltip(L["Astral Power Gained"], DataModes.AstralPowerGained, TooltipFuncs.AstralPowerGained)
Recount:AddModeTooltip(L["Maelstorm Gained"], DataModes.MaelstormGained, TooltipFuncs.MaelstormGained)
Recount:AddModeTooltip(L["Fury Gained"], DataModes.FuryGained, TooltipFuncs.FuryGained)
Recount:AddModeTooltip(L["Pain Gained"], DataModes.PainGained, TooltipFuncs.PainGained)

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
