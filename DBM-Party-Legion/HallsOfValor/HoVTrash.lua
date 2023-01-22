local mod	= DBM:NewMod("HoVTrash", "DBM-Party-Legion", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20230122050831")
--mod:SetModelID(47785)
mod:SetZone(1477)

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 199805 192563 199726 191508 199210 198892 198934 215433 210875",
	"SPELL_AURA_APPLIED 215430",
	"SPELL_AURA_REMOVED 215430",
	"GOSSIP_SHOW"
)

--TODO wicked dagger (199674)?
local warnCrackle					= mod:NewTargetAnnounce(199805, 2)
local warnCracklingStorm			= mod:NewTargetAnnounce(198892, 2)
local warnCleansingFlame			= mod:NewCastAnnounce(192563, 4)
local warnHolyRadiance				= mod:NewCastAnnounce(215433, 3)
local warnRuneOfHealing				= mod:NewCastAnnounce(198934, 3)

local specWarnBlastofLight			= mod:NewSpecialWarningDodge(191508, nil, nil, nil, 2, 2)
local specWarnPenetratingShot		= mod:NewSpecialWarningDodge(199210, nil, nil, nil, 2, 2)
local specWarnChargePulse			= mod:NewSpecialWarningDodge(210875, nil, nil, nil, 2, 2)
local specWarnCrackle				= mod:NewSpecialWarningYou(199805, nil, nil, nil, 1, 2)
local yellCrackle					= mod:NewShortYell(199805)
local specWarnCracklingStorm		= mod:NewSpecialWarningYou(198892, nil, nil, nil, 1, 2)
local yellCracklingStorm			= mod:NewShortYell(198892)
local specWarnThunderstrike			= mod:NewSpecialWarningMoveAway(215430, nil, nil, nil, 1, 2)
local yellThunderstrike				= mod:NewShortYell(215430)
local specWarnHolyRadiance			= mod:NewSpecialWarningInterrupt(215433, "HasInterrupt", nil, nil, 1, 2)
local specWarnRuneOfHealing			= mod:NewSpecialWarningInterrupt(198934, false, nil, nil, 1, 2)
local specWarnCleansingFlame		= mod:NewSpecialWarningInterrupt(192563, "HasInterrupt", nil, nil, 1, 2)
local specWarnUnrulyYell			= mod:NewSpecialWarningInterrupt(199726, "HasInterrupt", nil, nil, 1, 2)

mod:AddBoolOption("AGSkovaldTrash", true)
mod:AddBoolOption("AGStartOdyn", true)
--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 generalized, 7 GTFO

function mod:CrackleTarget(targetname, uId)
	if not targetname then
		warnCrackle:Show(DBM_COMMON_L.UNKNOWN)
		return
	end
	if targetname == UnitName("player") then
		specWarnCrackle:Show()
		specWarnCrackle:Play("targetyou")
		yellCrackle:Yell()
	else
		warnCrackle:Show(targetname)
	end
end

function mod:CracklingStormTarget(targetname, uId)
	if not targetname then
		warnCracklingStorm:Show(DBM_COMMON_L.UNKNOWN)
		return
	end
	if targetname == UnitName("player") then
		specWarnCracklingStorm:Show()
		specWarnCracklingStorm:Play("targetyou")
		yellCracklingStorm:Yell()
	else
		warnCracklingStorm:Show(targetname)
	end
end

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 199805 then
		self:BossTargetScanner(args.sourceGUID, "CrackleTarget", 0.1, 9)
	elseif spellId == 198892 then
		self:BossTargetScanner(args.sourceGUID, "CracklingStormTarget", 0.1, 9)
	elseif spellId == 192563 then
		if self.Options.SpecWarn192563interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnCleansingFlame:Show(args.sourceName)
			specWarnCleansingFlame:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnCleansingFlame:Show()
		end
	elseif spellId == 215433 then
		if self.Options.SpecWarn215433interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHolyRadiance:Show(args.sourceName)
			specWarnHolyRadiance:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnHolyRadiance:Show()
		end
	elseif spellId == 198934 then
		if self.Options.SpecWarn198934interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnRuneOfHealing:Show(args.sourceName)
			specWarnRuneOfHealing:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnRuneOfHealing:Show()
		end
	elseif spellId == 199726 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnUnrulyYell:Show(args.sourceName)
		specWarnUnrulyYell:Play("kickcast")
	elseif spellId == 191508 and self:AntiSpam(3, 2) then
		specWarnBlastofLight:Show()
		specWarnBlastofLight:Play("shockwave")
	elseif spellId == 199210 and self:AntiSpam(3, 2) then
		specWarnPenetratingShot:Show()
		specWarnPenetratingShot:Play("shockwave")
	elseif spellId == 210875 and self:AntiSpam(3, 2) then
		specWarnChargePulse:Show()
		specWarnChargePulse:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	if args.spellId == 215430 then
		if args:IsPlayer() then
			specWarnThunderstrike:Show()
			specWarnThunderstrike:Play("scatter")
			yellThunderstrike:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(6)
			end
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if not self.Options.Enabled then return end
	if args.spellId == 215430 and args:IsPlayer() then
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:GOSSIP_SHOW()
	local gossipOptionID = self:GetGossipID()
	if gossipOptionID then
		DBM:Debug("GOSSIP_SHOW triggered with a gossip ID of: "..gossipOptionID)
		if self.Options.AGSkovaldTrash and (gossipOptionID == 44755 or gossipOptionID == 44801 or gossipOptionID == 44802 or gossipOptionID == 44754) then -- Skovald Trash
			self:SelectGossip(gossipOptionID)
		elseif self.Options.AGStartOdyn and gossipOptionID == 44910 then -- Odyn
			self:SelectGossip(gossipOptionID)
		end
	end
end
