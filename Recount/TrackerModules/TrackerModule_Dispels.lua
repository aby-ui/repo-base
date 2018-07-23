local Recount = _G.Recount

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale( "Recount" )

local revision = tonumber(string.sub("$Revision: 1311 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local GameTooltip = GameTooltip

local dbCombatants
local srcRetention
local dstRetention

local DetailTitles = { }
DetailTitles.Dispels = {
	TopNames = L["Who"],
	TopCount = "",
	TopAmount = L["Dispels"],
	BotNames = L["Dispelled"],
	BotMin = "",
	BotAvg = "",
	BotMax = "",
	BotAmount = L["Count"]
}


function Recount:SpellAuraDispelledStolen(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool)
	if eventtype == "SPELL_DISPEL_FAILED" then
		return -- Not covering failures.
	end

	if not spellName then
		spellName = "Melee"
	end
	local ability = extraSpellName .. " (" .. spellName .. ")"

	Recount:AddDispelData(srcName, dstName, ability, srcGUID, srcFlags, dstGUID, dstFlags, extraSpellId)
end

function Recount:AddDispelData(source, victim, ability, srcGUID, srcFlags, dstGUID, dstFlags, spellId)
	-- Friendly fire interrupt? (Duels)
	local FriendlyFire = Recount:IsFriendlyFire(srcFlags, dstFlags)
	-- Before any further processing need to check if we are going to be placed in combat or in combat
	if not Recount.InCombat and Recount.db.profile.RecordCombatOnly then
		if (not FriendlyFire) and (Recount:InGroup(srcFlags) or Recount:InGroup(dstFlags)) then
			Recount:PutInCombat()
		else
			return
		end
	end

	-- Name and ID of pet owners
	local sourceowner
	local sourceownerID
	local victimowner
	local victimownerID

	source, sourceowner, sourceownerID = Recount:DetectPet(source, srcGUID, srcFlags)
	victim, victimowner, victimownerID = Recount:DetectPet(victim, dstGUID, dstFlags)

	-- Need to add events for potential deaths
	Recount.cleventtext = source.." dispels "..victim.." "..ability

	srcRetention = Recount.srcRetention
	if srcRetention then

		if not dbCombatants[source] or not dbCombatants[source] then
			Recount:AddCombatant(source, sourceowner, srcGUID, srcFlags, sourceownerID)
		end -- Elsia: Until here is if pets dispelled anybody.
		local sourceData = dbCombatants[source]

		if sourceData then
			Recount:SetActive(sourceData)
			-- Fight tracking purposes to speed up leaving combat
			sourceData.LastFightIn = Recount.db2.FightNum

			Recount:AddCurrentEvent(sourceData, "MISC", false, nil, Recount.cleventtext)
			Recount:AddAmount(sourceData, "Dispels", 1)
			Recount:AddTableDataSum(sourceData, "DispelledWho", victim, ability, 1)
		end
	end

	dstRetention = Recount.dstRetention
	if dstRetention then

		if not dbCombatants[victim] then
			Recount:AddCombatant(victim, victimowner, dstGUID, dstFlags, victimownerID) -- Elsia: Bug owner missing
		end
		local victimData = dbCombatants[victim]

		if victimData then
			Recount:SetActive(victimData)
			-- Fight tracking purposes to speed up leaving combat
			victimData.LastFightIn = Recount.db2.FightNum

			Recount:AddCurrentEvent(victimData, "MISC", true, nil, Recount.cleventtext)
			Recount:AddAmount(victimData, "Dispelled", 1)
			Recount:AddTableDataSum(victimData, "WhoDispelled", source, ability, 1)
		end
	end
end

local DataModes = { }

function DataModes:Dispels(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].Dispels or 0)
	end

	return (data.Fights[Recount.db.profile.CurDataSet].Dispels or 0), {{data.Fights[Recount.db.profile.CurDataSet].DispelledWho, L["'s Dispels"], DetailTitles.Dispels}}
end

function DataModes:Dispelled(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].Dispelled or 0)
	end

	return (data.Fights[Recount.db.profile.CurDataSet].Dispelled or 0), {{data.Fights[Recount.db.profile.CurDataSet].WhoDispelled, " "..L["was Dispelled by"], DetailTitles.Dispels}}
end

local TooltipFuncs = { }

function TooltipFuncs:Dispels(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Dispelled"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].DispelledWho, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

function TooltipFuncs:Dispelled(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Dispelled By"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].WhoDispelled, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

Recount:AddModeTooltip(L["Dispels"], DataModes.Dispels, TooltipFuncs.Dispels, nil, nil, nil, nil)
Recount:AddModeTooltip(L["Dispelled"], DataModes.Dispelled, TooltipFuncs.Dispelled, nil, nil, nil, nil)

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
