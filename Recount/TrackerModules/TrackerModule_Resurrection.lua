local Recount = _G.Recount

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Recount")

local revision = tonumber(string.sub("$Revision: 1472 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local GameTooltip = GameTooltip

local dbCombatants
local srcRetention
local dstRetention

local DetailTitles = { }
DetailTitles.Ressed = {
	TopNames = L["Ressed Who"],
	TopCount = "",
	TopAmount = L["Times"],
	BotNames = L["Ability"],
	BotMin = "",
	BotAvg = "",
	BotMax = "",
	BotAmount = L["Count"]
}

function Recount:SpellResurrect(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool)
	Recount:AddRes(srcName, dstName, spellName, srcGUID, srcFlags, dstGUID, dstFlags, spellId)
end

function Recount:AddRes(source, victim, ability, srcGUID, srcFlags, dstGUID, dstFlags, spellId)
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
			Recount:AddCombatant(source, nil, srcGUID, srcFlags)
		end


		local sourceData = dbCombatants[source]
		if sourceData then

			Recount:SetActive(sourceData)

			Recount:AddAmount(sourceData, "Ressed", 1)
			Recount:AddTableDataSum(sourceData, "RessedWho", victim,ability, 1)
		end
	end
end

local DataModes = { }

function DataModes:Ressed(data, num)
	if not data then
		return 0
	end
	if num == 1 then
		return (data.Fights[Recount.db.profile.CurDataSet].Ressed or 0)
	end

	return (data.Fights[Recount.db.profile.CurDataSet].Ressed or 0), {{data.Fights[Recount.db.profile.CurDataSet].RessedWho, L["'s Resses"], DetailTitles.Ressed}}
end

local TooltipFuncs = { }

function TooltipFuncs:Ressed(name, data)
	--local SortedData, total
	GameTooltip:ClearLines()
	GameTooltip:AddLine(name)
	Recount:AddSortedTooltipData(L["Top 3"].." "..L["Ressed"], data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].RessedWho, 3)
end

Recount:AddModeTooltip(L["Ressers"], DataModes.Ressed, TooltipFuncs.Ressed, nil, nil, nil, nil)

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
