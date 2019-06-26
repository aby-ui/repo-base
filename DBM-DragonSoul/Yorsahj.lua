local mod	= DBM:NewMod(325, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(55312)
mod:SetEncounterID(1295)
--mod:DisableRegenDetection()--Uncomment in next dbm release
mod:SetZone()
--mod:SetModelSound("sound\\CREATURE\\Yorsahj\\VO_DS_YORSAHJ_INTRO_01.OGG", "sound\\CREATURE\\Yorsahj\\VO_DS_YORSAHJ_SPELL_02.OGG")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 104849 105530 105573 105033 105171",
	"SPELL_AURA_APPLIED 104849 104901 104896 105027 104897 104894 104898",
	"SPELL_AURA_APPLIED_DOSE 104849",
	"SPELL_AURA_REMOVED 104849 104901 104897 104898",
	"CHAT_MSG_ADDON",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_DIED"
)

local warnOozes				= mod:NewTargetAnnounce("ej3978", 4)
local warnOozesHit			= mod:NewAnnounce("warnOozesHit", 3, 16372)
local warnVoidBolt			= mod:NewStackAnnounce(104849, 3, nil, "Tank|Healer")
local warnManaVoid			= mod:NewSpellAnnounce(105530, 3)
local warnDeepCorruption	= mod:NewSpellAnnounce(105171, 4)

local specWarnOozes			= mod:NewSpecialWarningSpell("ej3978")
local specWarnVoidBolt		= mod:NewSpecialWarningStack(104849, "Tank", 2)
local specWarnVoidBoltOther	= mod:NewSpecialWarningTarget(104849, "Tank")
local specWarnManaVoid		= mod:NewSpecialWarningSpell(105530, "ManaUser")
local specWarnPurple		= mod:NewSpecialWarningSpell(104896, "Tank|Healer")

local timerOozesCD			= mod:NewNextTimer(90, "ej3978", nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)
local timerOozesActive		= mod:NewTimer(7, "timerOozesActive", 16372, nil, nil, 1, DBM_CORE_DAMAGE_ICON) -- varies (7.0~8.5)
local timerOozesReach		= mod:NewTimer(34.5, "timerOozesReach", 16372, nil, nil, 1, DBM_CORE_DAMAGE_ICON)
local timerAcidCD			= mod:NewNextTimer(8.3, 105573, nil, nil, nil, 2)--Green ooze aoe
local timerSearingCD		= mod:NewNextTimer(6, 105033, nil, nil, nil, 2)--Red ooze aoe
local timerVoidBoltCD		= mod:NewNextTimer(6, 104849, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerVoidBolt			= mod:NewTargetTimer(12, 104849, nil, "Tank|Healer")--Nerfed yet again, its now 12. Good thing dbm timers were already right since i dbm pulls duration from aura heh.
local timerManaVoid			= mod:NewBuffFadesTimer(4, 105530, nil, "ManaUser")
local timerDeepCorruption	= mod:NewBuffFadesTimer(25, 105171, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_TANK_ICON)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("RangeFrame", true)

local oozesHitTable = {}
local expectedOozes = 0
local yellowActive = false
local bossName = EJ_GetEncounterInfo(325)

local oozeColorsHeroic = {
	[105420] = { L.Purple, L.Green, L.Black, L.Blue },
	[105435] = { L.Green, L.Red, L.Blue, L.Black },
	[105436] = { L.Green, L.Yellow, L.Black, L.Red },
	[105437] = { L.Blue, L.Purple, L.Green, L.Yellow },
	[105439] = { L.Blue, L.Black, L.Purple, L.Yellow },
	[105440] = { L.Purple, L.Red, L.Yellow, L.Black },
}

local oozeColors = {
	[105420] = { L.Purple, L.Green, L.Blue },
	[105435] = { L.Green, L.Red, L.Black },
	[105436] = { L.Green, L.Yellow, L.Red },
	[105437] = { L.Purple, L.Blue, L.Yellow },
	[105439] = { L.Blue, L.Black, L.Yellow },
	[105440] = { L.Purple, L.Red, L.Black },
}

function mod:OnCombatStart(delay)
	table.wipe(oozesHitTable)
	timerVoidBoltCD:Start(-delay)
	timerOozesCD:Start(22-delay)
	berserkTimer:Start(-delay)
	yellowActive = false
	if self:IsDifficulty("heroic10", "heroic25") then
		expectedOozes = 4
	else
		expectedOozes = 3
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 104849 then--Do not add any other ID, these are tank IDs. Raid aoe IDs coul be added as an alternate timer somewhere else maybe.
		timerVoidBoltCD:Start()
	elseif spellId == 105530 then
		warnManaVoid:Show()
		specWarnManaVoid:Show()
		timerManaVoid:Start()
	elseif spellId == 105573 and self:IsInCombat() then
		if yellowActive then
			timerAcidCD:Start(3.5)--Strangely, this is 3.5 even though base CD is 8.3-8.5
		else
			timerAcidCD:Start()
		end
	elseif spellId == 105033 and args:GetSrcCreatureID() == 55312 then
		if yellowActive then
			timerSearingCD:Start(3.5)
		else
			timerSearingCD:Start()
		end
	elseif spellId == 105171 then-- this spellid is debuff spellid(10h, 25h). damaging spellid is different. so added only 1 spellids.
		timerDeepCorruption:Start()
		warnDeepCorruption:Show()
	end
end

--[[
Ooze Absorption and deaths WoL Expression
(spellid = 104896 or spellid = 104894 or spellid = 105027 or spellid = 104897 or spellid = 104901 or spellid = 104898) and targetMobId = 55312 or fulltype = UNIT_DIED and (targetMobId = 55862 or targetMobId = 55866 or targetMobId = 55865 or targetMobId = 55867 or targetMobId = 55864 or targetMobId = 55863)

Ooze Absorption and granted abilities expression (black adds only fire UNIT_SPELLCAST_SUCCEEDED Spawning Pool::0:105600 so we can't reg expression it)
(spellid = 104896 or spellid = 104894 or spellid = 105027 or spellid = 104897 or spellid = 104901 or spellid = 104898) and targetMobId = 55312 or fulltype = SPELL_CAST_SUCCESS and (spell = "Digestive Acid" or spell = "Mana Void" or spell = "Searing Blood" or spell = "Deep Corruption")
--]]
function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 104849 then
		local amount = args.amount or 1
		warnVoidBolt:Show(args.destName, amount)
		local _, _, _, _, duration, expires = DBM:UnitDebuff(args.destName, args.spellName)--This is now consistently 12 seconds, but it's been nerfed twice without warning, i'm just gonna leave this here to make the mod continue to auto correct it when/if it changes more.
		if duration then
			timerVoidBolt:Start(duration, args.destName)
		end
		if amount >= 2 then
			if args:IsPlayer() then
				specWarnVoidBolt:Show(amount)
			else
				if not UnitIsDeadOrGhost("player") then--You're not dead and other tank has 2 stacks (meaning it's your turn).
					specWarnVoidBoltOther:Show(args.destName)
				end
			end
		end
	elseif spellId == 104901 and args:GetDestCreatureID() == 55312 then--Yellow
		table.insert(oozesHitTable, L.Yellow)
		if #oozesHitTable == expectedOozes then--All of em absorbed
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, ", "))
		end
		yellowActive = true
	elseif spellId == 104896 and args:GetDestCreatureID() == 55312 then--Purple
		table.insert(oozesHitTable, L.Purple)
		if #oozesHitTable == expectedOozes then
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, ", "))
		end
		specWarnPurple:Show()--We warn here to make sure everyone is topped off and things like healing rain are not on ground.
	elseif spellId == 105027 and args:GetDestCreatureID() == 55312 then--Blue
		table.insert(oozesHitTable, L.Blue)
		if #oozesHitTable == expectedOozes then
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, ", "))
		end
	elseif spellId == 104897 and args:GetDestCreatureID() == 55312 then--Red
		table.insert(oozesHitTable, L.Red)
		if #oozesHitTable == expectedOozes then
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, ", "))
		end
	elseif spellId == 104894 and args:GetDestCreatureID() == 55312 then--Black
		table.insert(oozesHitTable, L.Black)
		if #oozesHitTable == expectedOozes then
			warnOozesHit:Show(bossName, table.concat(oozesHitTable, ", "))
		end
	elseif spellId == 104898 then--Green
		if args:GetSrcCreatureID() == 55312 then--Only trigger the actual acid spits off the boss getting buff, not the oozes spawning.
			table.insert(oozesHitTable, L.Green)
			if #oozesHitTable == expectedOozes then
				warnOozesHit:Show(bossName, table.concat(oozesHitTable, ", "))
			end
		end
		if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then--Range finder outside boss check so we can open and close when green ooze spawns to pre spread.
			DBM.RangeCheck:Show(4)
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 104849 then
		timerVoidBolt:Cancel(args.destName)
	elseif spellId == 104901 and args:GetDestCreatureID() == 55312 then--Yellow Removed
		yellowActive = false
	elseif spellId == 104897 and args:GetDestCreatureID() == 55312 then--Red Removed
		timerSearingCD:Cancel()
	elseif spellId == 104898 then--Green Removed
		if args:GetDestCreatureID() == 55312 then
			timerAcidCD:Cancel()
		end
		if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then
			DBM.RangeCheck:Hide()
		end
	end
end		

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 55862 or cid == 55866 or cid == 55865 or cid == 55867 or cid == 55864 or cid == 55863 then--Oozes
		expectedOozes = expectedOozes - 1
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if oozeColors[spellId] then
		table.wipe(oozesHitTable)
		specWarnOozes:Show()
		timerVoidBoltCD:Start(42)
		timerOozesActive:Start()
		timerOozesReach:Start()
		if self:IsDifficulty("heroic10", "heroic25") then
			warnOozes:Show(table.concat(oozeColorsHeroic[spellId], ", "))
			timerOozesCD:Start(75)
			expectedOozes = 4
		else
			warnOozes:Show(table.concat(oozeColors[spellId], ", "))
			timerOozesCD:Start()
			expectedOozes = 3
		end
	end
end

-- support Yor'sahj raid leading tools (eg YorsahjAnnounce) who want to broadcast a target arrow
C_ChatInfo.RegisterAddonMessagePrefix("DBM-YORSAHJARROW")
--mod:RegisterEvents("CHAT_MSG_ADDON") -- for debugging
local oozePos = {
	["BLUE"] = 	{ 71, 34 },
	["PURPLE"] = 	{ 57, 13 },
	["RED"] = 	{ 37, 12 },
	["GREEN"] = 	{ 22, 34 },
	["YELLOW"] = 	{ 37, 85 },
	["BLACK"] = 	{ 71, 65 },
}

function mod:CHAT_MSG_ADDON(prefix, message, channel, sender)
	if prefix ~= "DBM-YORSAHJARROW" then return end
	local cmd = message or ""
	cmd = cmd:match("^(%w+)") or ""
	cmd = cmd:upper()
	if cmd == "CLEAR" then
		DBM.Arrow:Hide()
	elseif oozePos[cmd] then
		DBM.Arrow:ShowRunTo(oozePos[cmd][1],oozePos[cmd][2],nil,20,true)
	end
end

