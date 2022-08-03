local mod	= DBM:NewMod(1500, "DBM-Party-Legion", 6, 726)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20220610054416")
mod:SetCreatureID(98207)
mod:SetEncounterID(1826)
mod:SetUsedIcons(2, 1)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 200284",
	"SPELL_AURA_REMOVED 200284",
	"SPELL_CAST_START 200227 200024",
	"SPELL_PERIODIC_DAMAGE 200040",
	"SPELL_PERIODIC_MISSED 200040",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_SPELLCAST_CHANNEL_START boss1"
)

--TODO timers are iffy.
--TODO, blink scanning should work but may not if logic errors. May be spammy in certain situations such as pets/etc taunting boss
--["200227-Tangled Web"] = "pull:35.2, 26.6, 21.8",
local warnBlink					= mod:NewTargetAnnounce(199811, 4)
local warnWeb					= mod:NewTargetAnnounce(200284, 3)

local specWarnBlink				= mod:NewSpecialWarningRun(199811, nil, nil, nil, 4, 2)
local yellBlink					= mod:NewYell(199811, nil, false)
local specWarnBlinkNear			= mod:NewSpecialWarningClose(199811, nil, nil, nil, 1, 2)
local specWarnVenomGTFO			= mod:NewSpecialWarningMove(200040, nil, nil, nil, 1, 2)

local timerBlinkCD				= mod:NewNextTimer(30, 199811, nil, nil, nil, 3)
local timerWebCD				= mod:NewCDTimer(21.8, 200284, nil, nil, nil, 3)--21-26
local timerVenomCD				= mod:NewCDTimer(30, 200040, nil, nil, nil, 3)--30-33

mod:AddSetIconOption("SetIconOnWeb", 200284, true, 6, {1, 2})

mod.vb.blinkCount = 0

function mod:OnCombatStart(delay)
	self.vb.blinkCount = 0
	timerBlinkCD:Start(15-delay)
	timerVenomCD:Start(25-delay)
	timerWebCD:Start(35-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 200284 then
		warnWeb:CombinedShow(0.5, args.destName)
		if self.Options.SetIconOnWeb and args:IsDestTypePlayer() then
			self:SetAlphaIcon(0.5, args.destName, 2)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 200284 and self.Options.SetIconOnWeb then
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 200227 then
		timerWebCD:Start()
	elseif spellId == 200024 and self:AntiSpam(5, 3) then
		timerVenomCD:Start()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 200040 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnVenomGTFO:Show()
		specWarnVenomGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 199809 then--Blink Strikes begin
		timerBlinkCD:Start()
		self.vb.blinkCount = 0
	end
end

--UNIT_SPELLCAST_CHANNEL_STOP method dropped, not because it wasn't returning a valid target, but because DBMs target scanner methods don't work well with pets and fail to announce all strikes because of it
--This method doesn't require target scanning but is 0.6 seconds slower, but won't have a chance to fail if boss targets stupid things like army or spirit beast.
function mod:UNIT_SPELLCAST_CHANNEL_START(uId, _, spellId)
	if spellId == 199811 then--Blink Strikes Channel ending
		self.vb.blinkCount = self.vb.blinkCount + 1
		local targetname = UnitExists("boss1target") and UnitName("boss1target")
		if not targetname then
			return
		end
		if UnitIsUnit("boss1target", "player") then
			specWarnBlink:Show()
			specWarnBlink:Play("runaway")
			yellBlink:Yell()
		elseif self:CheckNearby(5, targetname) and self:AntiSpam(2.5, 2) then
			specWarnBlinkNear:Show(targetname)
			specWarnBlinkNear:Play("runaway")
		else
			warnBlink:Show(targetname)
		end
	end
end
