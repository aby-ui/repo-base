local mod	= DBM:NewMod(860, "DBM-Pandaria", nil, 322, 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019050334758")
mod:SetCreatureID(71953)
mod:SetReCombatTime(20)
mod:SetZone()

mod:RegisterCombat("combat_yell", L.Pull)
mod:RegisterKill("yell", L.Victory)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 144635 144642",
	"SPELL_AURA_APPLIED 144638 144631",
	"SPELL_AURA_APPLIED_DOSE 144638 144631",
	"SPELL_AURA_REMOVED 144638",
	"UNIT_SPELLCAST_SUCCEEDED target focus"
)

local warnSpectralSwipe				= mod:NewStackAnnounce(144638, 2, nil, "Tank|Healer")
local warnAgility					= mod:NewTargetAnnounce(144631, 3)
local warnCracklingLightning		= mod:NewSpellAnnounce(144635, 3)--According to data, spread range is 60 yards so spreading out for this seems pointless. it's just healed through
local warnChiBarrage				= mod:NewSpellAnnounce(144642, 4)

local specWarnSpectralSwipe			= mod:NewSpecialWarningStack(144638, "Tank", 5)
local specWarnSpectralSwipeOther	= mod:NewSpecialWarningTaunt(144638)
local specWarnAgility				= mod:NewSpecialWarningDispel(144631, "MagicDispeller", nil, nil, 3)
local specWarnChiBarrage			= mod:NewSpecialWarningSpell(144642, nil, nil, nil, 2)

local timerSpectralSwipe			= mod:NewTargetTimer(60, 144638, nil, "Tank|Healer")
local timerSpectralSwipeCD			= mod:NewCDTimer(12, 144638)
--local timerAgilityCD				= mod:NewCDTimer(25, 144631, nil, nil, nil, 5)
local timerCracklingLightning		= mod:NewBuffActiveTimer(13, 144635)
local timerCracklingLightningCD		= mod:NewCDTimer(47, 144635)
local timerChiBarrageCD				= mod:NewCDTimer(20, 144642)

mod:AddBoolOption("RangeFrame", true)--This is for chi barrage spreading.
mod:AddReadyCheckOption(33117, false, 90)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
		timerChiBarrageCD:Start(20-delay)
		timerCracklingLightningCD:Start(38-delay)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(3)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 144635 then
		warnCracklingLightning:Show()
		timerCracklingLightning:Start()
		timerCracklingLightningCD:Start()
	elseif spellId == 144642 then
		warnChiBarrage:Show()
		specWarnChiBarrage:Show()
		timerChiBarrageCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 144638 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			warnSpectralSwipe:Show(args.destName, amount)
			timerSpectralSwipe:Start(args.destName)
			timerSpectralSwipeCD:Start()
			if args:IsPlayer() and amount >= 5 then
				specWarnSpectralSwipe:Show(amount)
			else
				if amount >= 2 and not UnitIsDeadOrGhost("player") or not DBM:UnitDebuff("player", args.spellName) then
					specWarnSpectralSwipeOther:Show(args.destName)
				end
			end
		end
	elseif spellId == 144631 and args:GetDestCreatureID() == 71953 then
		warnAgility:Show(args.destName)
		specWarnAgility:Show(args.destName)
--		timerAgilityCD:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 144638 then
		timerSpectralSwipe:Cancel(args.destName)
	end
end

--This method works without local and doesn't fail with curse of tongs but requires at least ONE person in raid targeting boss to be running dbm (which SHOULD be most of the time)
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 148318 or spellId == 148317 or spellId == 149304 and self:AntiSpam(3, 2) then--use all 3 because i'm not sure which ones fire on repeat kills
		self:SendSync("Victory")
	end
end

function mod:OnSync(msg)
	if msg == "Victory" and self:IsInCombat() then
		DBM:EndCombat(self)
	end
end
