local Recount = _G.Recount

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale( "Recount" )

local revision = tonumber(string.sub("$Revision: 1472 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local GameTooltip = GameTooltip

local dbCombatants
local srcRetention
local dstRetention

local DetailTitles = { }
DetailTitles.CC = {
	TopNames = L["Broke"],
	TopCount = "",
	TopAmount = L["Count"],
	BotNames = L["Broke On"],
	BotMin = "",
	BotAvg = "",
	BotMax = "",
	BotAmount = L["Count"]
}

-- Resike: This module needs an update badly.
local CCId = {
	[118]	= true, -- Polymorph (rank 1)
	[12824]	= true, -- Polymorph (rank 2)
	[12825]	= true, -- Polymorph (rank 3)
	[12826]	= true, -- Polymorph (rank 4)
	[28272]	= true, -- Polymorph (rank 1:pig)
	[28271]	= true, -- Polymorph (rank 1:turtle)
	[9484]	= true, -- Shackle Undead (rank 1)
	[9485]	= true, -- Shackle Undead (rank 2)
	[10955]	= true, -- Shackle Undead (rank 3)
	[3355]	= true, -- Freezing Trap Effect (rank 1)
	[14308]	= true, -- Freezing Trap Effect (rank 2)
	[14309]	= true, -- Freezing Trap Effect (rank 3)
	[2637]	= true, -- Hibernate (rank 1)
	[18657]	= true, -- Hibernate (rank 2)
	[18658]	= true, -- Hibernate (rank 3)
	[6770]	= true, -- Sap (rank 1)
	[2070]	= true, -- Sap (rank 2)
	[11297]	= true, -- Sap (rank 3)
	[6358]	= true, -- Seduction (Succubus)
}

function Recount:SpellAuraBroken(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool)
	if not spellName then
		spellName = "Melee"
	end

	local ability
	if extraSpellName then
		ability = spellName .. " (" .. extraSpellName .. ")"
	else
		ability = spellName .." (Melee)"
	end

	if CCId[spellId] then
		Recount:AddCCBreaker(srcName, dstName, ability, srcGUID, srcFlags, dstGUID, dstFlags, extraSpellId)
	end
end

function Recount:AddCCBreaker(source, victim, ability, srcGUID, srcFlags, dstGUID, dstFlags)
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


	srcRetention = Recount.srcRetention
	if srcRetention then

		if not dbCombatants[source] then
			Recount:AddCombatant(source, sourceowner, srcGUID, srcFlags, sourceownerID)
		end -- Elsia: Until here is if pets heal anybody.
		local sourceData = dbCombatants[source]
		if sourceData then

			Recount:SetActive(sourceData)

			-- Fight tracking purposes to speed up leaving combat
			sourceData.LastFightIn = Recount.db2.FightNum
			if not FriendlyFire then
				Recount:AddAmount(sourceData, "CCBreak", 1)
				Recount:AddTableDataSum(sourceData, "CCBroken", ability, victim, 1)
			end
		end
	end


	dstRetention = Recount.dstRetention
	if dstRetention then

		if not dbCombatants[victim] then
			Recount:AddCombatant(victim, victimowner, dstGUID, dstFlags, victimownerID)
		end
		local victimData = dbCombatants[victim]
		if victimData then
			Recount:SetActive(victimData)

			-- Fight tracking purposes to speed up leaving combat
			victimData.LastFightIn = Recount.db2.FightNum
		end
	end
end

local DataModes = { }

function DataModes:PolyBreak(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].CCBreak or 0)
	end
	return (data.Fights[Recount.db.profile.CurDataSet].CCBreak or 0), {{data.Fights[Recount.db.profile.CurDataSet].CCBroken, " "..L["CC Breaking"], DetailTitles.CC}}
end

local TooltipFuncs = { }

function TooltipFuncs:CCBroken(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["CC's Broken"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].CCBroken, 3)
end

Recount:AddModeTooltip(L["CC Breakers"], DataModes.PolyBreak, TooltipFuncs.CCBroken, nil, nil, nil, nil)

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
