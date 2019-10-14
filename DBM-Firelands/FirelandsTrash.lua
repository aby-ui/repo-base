local mod	= DBM:NewMod("FirelandsTrash", "DBM-Firelands")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20191011130309")
mod:SetModelID(38765)
mod:SetZone()
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 100094 99629 99503 100724",
	"SPELL_CAST_SUCCESS 99579 99575",
	"SPELL_AURA_APPLIED 99532",
	"SPELL_AURA_APPLIED_DOSE 99532",
	"SPELL_AURA_REMOVED 99532",
	"UNIT_DIED"
)

local warnMoltenArmor		= mod:NewStackAnnounce(99532, 3, nil, "Tank|Healer")
local warnDruidLeap			= mod:NewTargetAnnounce(99629, 3, nil, false)--Probably spammy, more for debugging timing then anything.
local warnRaiselava			= mod:NewSpellAnnounce(99503, 3)
local warnMoltenBolt		= mod:NewSpellAnnounce(99579, 3)
local warnLavaSpawn			= mod:NewSpellAnnounce(99575, 3)

local specWarnFieroblast	= mod:NewSpecialWarningInterrupt(100094, "HasInterrupt", nil, nil, 1, 2)
local specWarnMoltenArmor	= mod:NewSpecialWarningStack(99532, nil, 4, nil, nil, 1, 6)
local specWarnDruidLeap		= mod:NewSpecialWarningYou(99629, nil, nil, nil, 1, 2)
local yelldruidLeap			= mod:NewYell(99629)
local specWarnDruidLeapNear	= mod:NewSpecialWarningClose(99629, nil, nil, nil, 1, 2)
local specWarnEarthQuake	= mod:NewSpecialWarningCast(100724, "SpellCaster", nil, nil, 1, 2)
local specWarnLava			= mod:NewSpecialWarningMove(99510, nil, nil, nil, 1, 2)

local timerMoltenArmor		= mod:NewTargetTimer(15, 99532, nil, "Tank|Healer", nil, 5)
local timerRaiseLavaCD		= mod:NewNextTimer(17, 99503, nil, nil, nil, 3)--Every 15 sec + 2 sec cast.
local timerMoltenBoltCD		= mod:NewNextTimer(15.5, 99579, nil, nil, nil, 3)--The worm gyser things that always kill people for not moving.
local timerLavaSpawnCD		= mod:NewNextTimer(16, 99575, nil, nil, nil, 1)--The worm gyser things that always kill people for not moving.

local lavaRunning = false

function mod:LeapTarget(sGUID)
	local targetname = nil
	for uId in DBM:GetGroupMembers() do
		if UnitGUID(uId.."target") == sGUID then
			targetname = DBM:GetUnitFullName(uId.."targettarget")
			break
		end
	end
	if targetname and self:AntiSpam(2, targetname) then--Sometimes mod bugs, multiple leaps too close to same time, and it results in double or even tripple announces on one person (and no announce for 1-2 of the real targets). this will at least filter 1 target spam
		if targetname == UnitName("player") then
			specWarnDruidLeap:Show()
			specWarnDruidLeap:Play("targetyou")
			yelldruidLeap:Yell()
		else
			local uId = DBM:GetRaidUnitId(targetname)
			if uId then
				local inRange = CheckInteractDistance(uId, 2)
				if inRange then
					specWarnDruidLeapNear:Show(targetname)
					specWarnDruidLeapNear:Play("runaway")
				else
					warnDruidLeap:Show(targetname)
				end
			end
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 100094 and self:CheckInterruptFilter(args.sourceGUID, false, true) then--Trash version of Fieroblast, different from boss version
		specWarnFieroblast:Show(args.sourceName)
		specWarnFieroblast:Play("kickcast")
	elseif args.spellId == 99629 then--Druid of the Flame Leaping
		self:ScheduleMethod(1, "LeapTarget", args.sourceGUID)
	elseif args.spellId == 99503 then
		warnRaiselava:Show()
		timerRaiseLavaCD:Start()
		if not lavaRunning then
			self:RegisterShortTermEvents(
				"SPELL_DAMAGE 99510",
				"SPELL_MISSED 99510"
			)
			lavaRunning = true
		end
	elseif args.spellId == 100724 then
		specWarnEarthQuake:Show()
		specWarnEarthQuake:Play("stopcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 99579 and self:AntiSpam(4) then
		warnMoltenBolt:Show()
		timerMoltenBoltCD:Start()
	elseif args.spellId == 99575 then
		warnLavaSpawn:Show()
		timerLavaSpawnCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 99532 and args:IsDestTypePlayer() then
		if args:IsPlayer() and (args.amount or 1) >= 4 then
			specWarnMoltenArmor:Show(args.amount)
			specWarnMoltenArmor:Play("stackhigh")
		else
			warnMoltenArmor:Show(args.destName, args.amount or 1)
		end
		timerMoltenArmor:Start(args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 99532 then
		timerMoltenArmor:Cancel(args.destName)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 99510 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specWarnLava:Show()
		specWarnLava:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53575 then
		timerRaiseLavaCD:Cancel()
		lavaRunning = false
		self:UnregisterShortTermEvents()
	elseif cid == 53617 then
		timerMoltenBoltCD:Cancel()
	elseif cid == 53616 then
		timerLavaSpawnCD:Cancel()
	elseif cid == 53619 then
		self:UnscheduleMethod("LeapTarget", args.destGUID)
	end
end
