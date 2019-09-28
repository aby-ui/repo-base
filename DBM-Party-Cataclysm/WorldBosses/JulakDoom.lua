local mod	= DBM:NewMod("JulakDoom", "DBM-Party-Cataclysm", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(50089)
mod:SetModelID(24301)
mod:SetZone()
mod:SetUsedIcons(8, 7)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 93610",
	"SPELL_AURA_APPLIED 93621",
	"SPELL_AURA_REMOVED 93621",
	"SPELL_DAMAGE 93612",
	"SPELL_MISSED 93612"
)
mod.onlyNormal = true

local warnShockwave			= mod:NewCastAnnounce(93610, 3)
local warnMC				= mod:NewTargetNoFilterAnnounce(93621, 4)

local specWarnShockwave		= mod:NewSpecialWarningDodge(93610, "Tank", nil, nil, 1, 2)
local specWarnBreath		= mod:NewSpecialWarningMove(93612, nil, nil, nil, 1, 8)

local timerShockwaveCD		= mod:NewNextTimer(28.5, 93610, nil, nil, nil, 3)
local timerMCCD				= mod:NewNextTimer(40, 93621, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnMC", 93621, true, false, {8, 7})

local warnMCTargets = {}
mod.vb.mcIcon = 8

function mod:OnCombatStart(delay)
	table.wipe(warnMCTargets)
	self.vb.mcIcon = 8
	timerShockwaveCD:Start(10-delay)
	timerMCCD:Start(-delay)
end

local function showMC(self)
	warnMC:Show(table.concat(warnMCTargets, "<, >"))
	table.wipe(warnMCTargets)
	self.vb.mcIcon = 8
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93610 then
		if self.Options.SpecWarn93610dodge then
			specWarnShockwave:Show()
			specWarnShockwave:Play("shockwave")
		else
			warnShockwave:Show()
		end
		timerShockwaveCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93621 then
		warnMCTargets[#warnMCTargets + 1] = args.destName
		timerMCCD:Start()
		if self.Options.SetIconOnMC then
			self:SetIcon(args.destName, self.vb.mcIcon)
		end
		self.vb.mcIcon = self.vb.mcIcon - 1
		self:Unschedule(showMC)
		if #warnMCTargets >= 2 then
			showMC(self)
		else
			self:Schedule(0.9, showMC, self)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 93621 and self.Options.SetIconOnMC then
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 93612 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specWarnBreath:Show()
		specWarnBreath:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
