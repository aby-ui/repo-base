local mod	= DBM:NewMod("Deathbringer", "DBM-Icecrown", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(37813)
mod:SetEncounterID(1096)
mod:SetModelID(30790)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 72378",
	"SPELL_CAST_SUCCESS 72410",
	"SPELL_SUMMON 72172 72173 72356 72357 72358",
	"SPELL_AURA_APPLIED 72293 72385 72737",
	"SPELL_AURA_REMOVED 72385",
	"UNIT_HEALTH boss1"
)

local warnFrenzySoon		= mod:NewSoonAnnounce(72737, 2, nil, "Tank|Healer")
local warnAddsSoon			= mod:NewPreWarnAnnounce(72173, 10, 3)
local warnAdds				= mod:NewSpellAnnounce(72173, 4)
local warnFrenzy			= mod:NewSpellAnnounce(72737, 2, nil, "Tank|Healer")
local warnBloodNova			= mod:NewSpellAnnounce(72378, 2)
local warnMark 				= mod:NewTargetCountAnnounce(72293, 4, 72293)
local warnBoilingBlood		= mod:NewTargetAnnounce(72385, 2, nil, "Healer")
local warnRuneofBlood		= mod:NewTargetAnnounce(72410, 3, nil, "Tank|Healer")

local specwarnRuneofBlood	= mod:NewSpecialWarningTaunt(72410, nil, nil, nil, 1, 2)

local timerCombatStart		= mod:NewCombatTimer(45)
local timerRuneofBlood		= mod:NewNextTimer(20, 72410, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerBoilingBlood		= mod:NewNextTimer(15.5, 72385, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerBloodNova		= mod:NewNextTimer(20, 72378, nil, nil, nil, 2)
local timerCallBloodBeast	= mod:NewNextTimer(40, 72173, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)

local enrageTimer			= mod:NewBerserkTimer(480)

mod:AddBoolOption("RangeFrame", "Ranged")
mod:AddSetIconOption("BeastIcons", 72173, true, true)
mod:AddBoolOption("BoilingBloodIcons", false)
mod:AddInfoFrameOption(72370, true)

mod.vb.warned_preFrenzy = false
mod.vb.boilingBloodIcon 	= 8
mod.vb.Mark = 0
local boilingBloodTargets = {}
local spellName = DBM:GetSpellInfo(72370)

local function warnBoilingBloodTargets(self)
	warnBoilingBlood:Show(table.concat(boilingBloodTargets, "<, >"))
	table.wipe(boilingBloodTargets)
	self.vb.boilingBloodIcon = 8
	timerBoilingBlood:Start()
end

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		enrageTimer:Start(360-delay)
	else
		enrageTimer:Start(-delay)--480
	end
	timerCallBloodBeast:Start(-delay)
	warnAddsSoon:Schedule(30-delay)
	timerBloodNova:Start(-delay)
	timerRuneofBlood:Start(-delay)
	timerBoilingBlood:Start(19-delay)
	table.wipe(boilingBloodTargets)
	self.vb.warned_preFrenzy = false
	self.vb.boilingBloodIcon = 8
	self.vb.Mark = 0
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(12)
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(spellName)
		DBM.InfoFrame:Show(1, "enemypower", 2)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 72378 then
		warnBloodNova:Show()
		timerBloodNova:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 72410 then
		warnRuneofBlood:Show(args.destName)
		if not args:IsPlayer() then
			specwarnRuneofBlood:Show(args.destName)
			specwarnRuneofBlood:Play("tauntboss")
		end
		timerRuneofBlood:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(72172, 72173, 72356, 72357, 72358) then
		if self:AntiSpam(5) then
			warnAdds:Show()
			warnAddsSoon:Schedule(30)
			timerCallBloodBeast:Start()
		end
		if self.Options.BeastIcons then
			if self:IsDifficulty("normal25", "heroic25") then
				self:ScanForMobs(args.destGUID, 0, 8, 5, 0.1, 20, "BeastIcons")
			else
				self:ScanForMobs(args.destGUID, 0, 8, 2, 0.1, 20, "BeastIcons")
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 72293 then
		self.vb.Mark = self.vb.Mark + 1
		warnMark:Show(self.vb.Mark, args.destName)
	elseif args.spellId == 72385 then
		boilingBloodTargets[#boilingBloodTargets + 1] = args.destName
		if self.Options.BoilingBloodIcons then
			self:SetIcon(args.destName, self.vb.boilingBloodIcon)
		end
		self.vb.boilingBloodIcon = self.vb.boilingBloodIcon - 1
		self:Unschedule(warnBoilingBloodTargets)
		if self:IsDifficulty("normal10", "heroic10") or (self:IsDifficulty("normal25", "heroic25") and #boilingBloodTargets >= 3) then
			warnBoilingBloodTargets(self)
		else
			self:Schedule(0.5, warnBoilingBloodTargets, self)
		end
	elseif args.spellId == 72737 then
		warnFrenzy:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 72385 and self.Options.BoilingBloodIcons then
		self:SetIcon(args.destName, 0)
	end
end

function mod:UNIT_HEALTH(uId)
	if not self.vb.warned_preFrenzy and self:GetUnitCreatureId(uId) == 37813 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.33 then
		self.vb.warned_preFrenzy = true
		warnFrenzySoon:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L.PullAlliance, 1, true) then
		timerCombatStart:Start()
	elseif msg:find(L.PullHorde, 1, true) then
		timerCombatStart:Start(94.5)
	end
end
