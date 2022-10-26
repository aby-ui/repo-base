local mod	= DBM:NewMod(1837, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20221016002954")
mod:SetCreatureID(114312)
mod:SetEncounterID(1961)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 227672 227578 227545 227736 227672",
	"SPELL_CAST_SUCCESS 227872",
	"SPELL_AURA_APPLIED 227832 227616",
--	"SPELL_AURA_REMOVED",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED"
)

--TODO, build more upon CC list and make sure it actually works
--Moroes
local warnVanish					= mod:NewSpellAnnounce(227737, 2)
local warnGhastlyPurge				= mod:NewSpellAnnounce(227872, 4)
--Baroness Dorothea Millstipe
local warnManaDrain					= mod:NewCastAnnounce(227545, 3)
--Lady Lady Catriona Von'Indi
local warnHealingStream				= mod:NewCastAnnounce(227578, 4)
--Lady Keira Berrybuck
local warnEmpoweredArms				= mod:NewTargetAnnounce(227616, 3)

--Moroes
local specWarnCoatCheck				= mod:NewSpecialWarningDefensive(227832, nil, nil, nil, 1, 2)
local specWarnCoatCheckHealer		= mod:NewSpecialWarningDispel(227832, "RemoveMagic", nil, 2, 1, 2)
--Lord Crispin Ference
local specWarnWillBreaker			= mod:NewSpecialWarningSpell(227672, "Tank", nil, nil, 1, 2)

--Moroes
local timerCoatCheckCD				= mod:NewNextTimer(32.7, 227832, nil, "Tank|Healer", nil, 5)
local timerVanishCD					= mod:NewCDTimer(19.3, 227737, nil, nil, nil, 3)
--Lady Lady Catriona Von'Indi
local timerHealingStreamCD			= mod:NewAITimer(40, 227578, nil, nil, nil, 0)--Interruptable via stun?
--Lord Crispin Ference
local timerWillBreakerCD			= mod:NewCDTimer(10.6, 227672, nil, "Tank", nil, 5)

--local berserkTimer					= mod:NewBerserkTimer(300)

mod:AddInfoFrameOption(227909, true)

local updateInfoFrame
do
	local ccList = {
		[1] = DBM:GetSpellInfo(227909),--Trap included with fight
		[2] = DBM:GetSpellInfo(6770),--Rogue Sap
		[3] = DBM:GetSpellInfo(9484),--Priest Shackle
		[4] = DBM:GetSpellInfo(20066),--Paladin Repentance
		[5] = DBM:GetSpellInfo(118),--Mage Polymorph
		[6] = DBM:GetSpellInfo(51514),--Shaman Hex
		[7] = DBM:GetSpellInfo(3355),--Hunter Freezing Trap
	}
	local lines = {}
	local floor = math.floor
	updateInfoFrame = function()
		table.wipe(lines)
		for i = 1, 5 do
			local uId = "boss"..i
			if UnitExists(uId) then
				for s = 1, #ccList do
					local spellName = ccList[s]
					local _, _, _, _, _, expires = DBM:UnitDebuff(uId, spellName)
					if expires then
						local debuffTime = expires - GetTime()
						lines[UnitName(uId)] = floor(debuffTime)
						break
					end
				end
			end
		end
		return lines
	end
end

function mod:OnCombatStart(delay)
	timerVanishCD:Start(8.2-delay)
	timerCoatCheckCD:Start(33-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(227909))
		DBM.InfoFrame:Show(5, "function", updateInfoFrame, false, true)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 227672 then
		specWarnWillBreaker:Show()
		specWarnWillBreaker:Play("shockwave")
		timerWillBreakerCD:Start()
	elseif spellId == 227578 then
		warnHealingStream:Show()
		timerHealingStreamCD:Start()
	elseif spellId == 227545 then
		warnManaDrain:Show()
	elseif spellId == 227736 then
		warnVanish:Show()
		timerVanishCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 227872 then
		warnGhastlyPurge:Show()
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 227832 then
		timerCoatCheckCD:Start()
		if args:IsPlayer() then
			specWarnCoatCheck:Show()
			specWarnCoatCheck:Play("defensive")
		else
			specWarnCoatCheckHealer:Show(args.destName)
			if self.Options.SpecWarn227832dispel then
				specWarnCoatCheckHealer:Play("dispelnow")
			end
		end
	elseif spellId == 227616 then
		warnEmpoweredArms:Show(args.destName)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 114317 then--lady-catriona-vonindi
		timerHealingStreamCD:Stop()
	--elseif cid == 115440 then--baroness-dorothea-millstipe

	--elseif cid == 115439 then--baron-rafe-dreuger

	--elseif cid == 114319 then--lady-keira-berrybuck

	--elseif cid == 114320 then--lord-robin-daris

	elseif cid == 115441 then--lord-crispin-ference
		timerWillBreakerCD:Stop()
	end
end
