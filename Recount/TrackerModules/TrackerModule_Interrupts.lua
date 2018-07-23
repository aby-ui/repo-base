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
DetailTitles.Interrupts = {
	TopNames = L["Interrupted Who"],
	TopCount = "",
	TopAmount = L["Interrupts"],
	BotNames = L["Interrupted"],
	BotMin = "",
	BotAvg = "",
	BotMax = "",
	BotAmount = L["Count"]
}


function Recount:SpellInterrupt(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool)
	if not spellName then
		spellName = "Melee"
	end
	local ability = extraSpellName .. " (" .. spellName .. ")"
	Recount:AddInterruptData(srcName, dstName, ability, srcGUID, srcFlags, dstGUID, dstFlags, extraSpellId) -- Elsia: Keep both interrupting spell and interrupted spell
end

function Recount:AddInterruptData(source, victim, ability, srcGUID, srcFlags, dstGUID, dstFlags, spellId)
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

	-- Need to add events for potential deaths	
	Recount.cleventtext = source.." interrupts "..victim.." "..ability

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
		end -- Elsia: Until here is if pets interupts anybody.
		local sourceData = dbCombatants[source]

		if sourceData then
			Recount:SetActive(sourceData)
			Recount:AddCurrentEvent(sourceData, "MISC", false, nil, Recount.cleventtext)
			-- Fight tracking purposes to speed up leaving combat
			sourceData.LastFightIn = Recount.db2.FightNum

			Recount:AddAmount(sourceData, "Interrupts", 1)
			Recount:AddTableDataSum(sourceData,"InterruptData",victim,ability,1)
		end
	end

	dstRetention = Recount.dstRetention
	if dstRetention then

		if not dbCombatants[victim] then
			Recount:AddCombatant(victim, victimowner, dstGUID, dstFlags, victimownerID) -- Elsia: Bug, owner missing here
		end

		local victimData = dbCombatants[victim]

		if victimData then
			Recount:SetActive(victimData)
			Recount:AddCurrentEvent(victimData, "MISC", true, nil, Recount.cleventtext)
			-- Fight tracking purposes to speed up leaving combat
			victimData.LastFightIn = Recount.db2.FightNum
		end
	end
end

local DataModes = { }

function DataModes:InterruptReturner(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].Interrupts or 0)
	end

	return (data.Fights[Recount.db.profile.CurDataSet].Interrupts or 0), {{data.Fights[Recount.db.profile.CurDataSet].InterruptData, L["'s Interrupts"], DetailTitles.Interrupts}}
end

local TooltipFuncs = { }

function TooltipFuncs:Interrupts(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Interrupted"],data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].InterruptData, 3)
	GameTooltip:AddLine("<"..L["Click for more Details"]..">", 0, 0.9, 0)
end

Recount:AddModeTooltip(L["Interrupts"], DataModes.InterruptReturner, TooltipFuncs.Interrupts, nil, nil, nil, nil)

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
