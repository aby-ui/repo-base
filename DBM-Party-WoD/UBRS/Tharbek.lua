local mod	= DBM:NewMod(1228, "DBM-Party-WoD", 8, 559)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(79912, 80098)--80098 is mount(Ironbarb Skyreaver), 79912 is boss
mod:SetEncounterID(1759)
mod:SetZone()
mod:SetBossHPInfoToHighest(false)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 162090",
	"SPELL_AURA_APPLIED 161833",
	"SPELL_PERIODIC_DAMAGE 161989",
	"SPELL_ABSORBED 161989",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_TARGETABLE_CHANGED",
	"UNIT_DIED"
)

--Chi blast warns very spammy. and not useful.
local warnTharbek			= mod:NewSpellAnnounce("ej10276", 3, "134170")
local warnIronReaver		= mod:NewTargetNoFilterAnnounce(161989, 3)
local warnImbuedIronAxe		= mod:NewTargetAnnounce(162090, 4)

local specWarnImbuedIronAxe	= mod:NewSpecialWarningYou(162090, nil, nil, nil, 1, 2)
local yellImbuedIronAxe		= mod:NewYell(162090)
local specWarnNoxiousSpit	= mod:NewSpecialWarningMove(161833, nil, nil, nil, 1, 8)

local timerIronReaverCD		= mod:NewCDTimer(20.5, 161989, nil, nil, nil, 3)--Not enough data to really verify this
local timerImbuedIronAxeCD	= mod:NewCDTimer(29, 162090, nil, nil, nil, 3)--29-37sec variation

function mod:IronReaverTarget(targetname, uId)
	if not targetname then return end
	warnIronReaver:Show(targetname)
end

function mod:OnCombatStart(delay)
--	timerIronReaverCD:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 162090 then
		timerImbuedIronAxeCD:Start()
		if args:IsPlayer() then
			specWarnImbuedIronAxe:Show()
			specWarnImbuedIronAxe:Play("targetyou")
			yellImbuedIronAxe:Yell()
		else
			warnImbuedIronAxe:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 161833 and args:IsPlayer() and self:AntiSpam(3, 1) then
		specWarnNoxiousSpit:Show()
		specWarnNoxiousSpit:Play("runaway")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 161833 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then--Goriona's Void zones
		specWarnNoxiousSpit:Show()
		specWarnNoxiousSpit:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 161989 then
		self:BossTargetScanner(79912, "IronReaverTarget", 0.05, 10)
		timerIronReaverCD:Start()
	end
end

function mod:UNIT_TARGETABLE_CHANGED()
	if UnitExists("boss1") then
		warnTharbek:Show()
	end
end
