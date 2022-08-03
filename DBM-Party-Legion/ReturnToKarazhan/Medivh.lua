local mod	= DBM:NewMod(1817, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20220610054416")
mod:SetCreatureID(114350)
mod:SetEncounterID(1965)
mod:SetUsedIcons(1, 2)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 227628 227592 227779 228269 228334",
	"SPELL_AURA_APPLIED 227592 228261 228249",
	"SPELL_AURA_REMOVED 227592 228261",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

local warnInfernoBolt				= mod:NewTargetAnnounce(227615, 3)
local warnFlameWreath				= mod:NewCastAnnounce(228269, 4)
local warnFlameWreathTargets		= mod:NewTargetAnnounce(228269, 4)

local specWarnArcaneMissiles		= mod:NewSpecialWarningDefensive(227628, "Tank", nil, nil, 1, 2)
local specWarnFrostbite				= mod:NewSpecialWarningInterrupt(227592, "HasInterrupt", nil, nil, 1, 2)
local specWarnInfernoBoltMoveTo		= mod:NewSpecialWarningMoveTo(227615, nil, nil, nil, 1, 2)
local specWarnInfernoBoltMoveAway	= mod:NewSpecialWarningMoveAway(227615, nil, nil, nil, 1, 2)
local specWarnInfernoBoltNear		= mod:NewSpecialWarningClose(227615, nil, nil, nil, 1, 2)
local specWarnCeaselessWinter		= mod:NewSpecialWarningSpell(227779, nil, nil, nil, 2, 2)
local specWarnFlameWreath			= mod:NewSpecialWarningYou(228261, nil, nil, nil, 3, 2)
local yellFlameWreath				= mod:NewYell(228261)
local specWarnGuardiansImage		= mod:NewSpecialWarningSwitch(228334, nil, nil, nil, 1, 2)

local timerSpecialCD				= mod:NewCDSpecialTimer(30, 228582, nil, nil, nil, nil, nil, nil, nil, 1, 4)

mod:AddSetIconOption("SetIconOnWreath", 228261, true, 6, {1, 2})
--mod:AddInfoFrameOption(198108, false)

mod.vb.playersFrozen = 0
mod.vb.imagesActive = false
local frostBiteName, flameWreathName = DBM:GetSpellInfo(227592), DBM:GetSpellInfo(228261)

function mod:OnCombatStart(delay)
	self.vb.playersFrozen = 0
	self.vb.imagesActive = false
	timerSpecialCD:Start(33.5)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 227628 then
		specWarnArcaneMissiles:Show()
		specWarnArcaneMissiles:Play("defensive")
	elseif spellId == 227592 then
		specWarnFrostbite:Show(args.sourceName)
		specWarnFrostbite:Play("kickcast")
	elseif spellId == 227779 then
		specWarnCeaselessWinter:Show()
		specWarnCeaselessWinter:Play("keepjump")
		timerSpecialCD:Start(32.5)
	elseif spellId == 228269 then
		warnFlameWreath:Show()
		timerSpecialCD:Start(31.5)
	elseif spellId == 228334 then
		self.vb.imagesActive = true
		specWarnGuardiansImage:Show()
		specWarnGuardiansImage:Play("killmob")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 227592 then
		self.vb.playersFrozen = self.vb.playersFrozen + 1
	elseif spellId == 228261 then
		warnFlameWreathTargets:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnFlameWreath:Show()
			specWarnFlameWreath:Play("stopmove")
			yellFlameWreath:Yell()
		end
		if self.Options.SetIconOnWreath then
			self:SetAlphaIcon(0.5, args.destName, 2)
		end
	elseif spellId == 228249 then
		if args:IsPlayer() then
			if self.vb.playersFrozen == 0 then
				specWarnInfernoBoltMoveAway:Show()
				specWarnInfernoBoltMoveAway:Play("scatter")
			else
				specWarnInfernoBoltMoveTo:Show(frostBiteName)
				specWarnInfernoBoltMoveTo:Play("gather")
			end
		elseif self:CheckNearby(8, args.destName) and not DBM:UnitDebuff("player", frostBiteName) and not DBM:UnitDebuff("player", flameWreathName) then
			specWarnInfernoBoltNear:Show(args.destName)
			specWarnInfernoBoltNear:Play("scatter")
		else
			warnInfernoBolt:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 227592 then
		self.vb.playersFrozen = self.vb.playersFrozen - 1
	elseif spellId == 228261 then
		if self.Options.SetIconOnWreath then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 228582 and self.vb.imagesActive then--Mana Regen
		self.vb.imagesActive = false
		timerSpecialCD:Start()
	end
end
