local mod	= DBM:NewMod(2360, "DBM-Party-BfA", 11, 1178)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217031102")
mod:SetCreatureID(153755, 150712)
mod:SetEncounterID(2312)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 298669 302682 298897 298940 298651 298571 298946 299164",--298898
	"UNIT_DIED"
)

--Still unsure how timer behavior, there may be a shared special timer but what special that gets used is random.
--Trixie "The Tech" Tazer
--[[
(ability.id = 298669 or ability.id = 302682 or ability.id = 298897 or ability.id = 298940 or ability.id = 298946 or ability.id = 298651 or ability.id = 299164 or ability.id = 298571 or ability.id = 298898) and type = "begincast"
--]]
--Trixie
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20200))
local warnMegaTaze					= mod:NewTargetNoFilterAnnounce(302682, 3)
local warnJumpStart					= mod:NewSpellAnnounce(298897, 3)

local specWarnTaze					= mod:NewSpecialWarningInterrupt(298669, false, nil, 2, 1, 2)
local specWarnMegaTaze				= mod:NewSpecialWarningMoveTo(302682, nil, nil, nil, 3, 2)
local yellMegaTaze					= mod:NewYell(302682)

local timerMegaTazeCD				= mod:NewCDTimer(40.1, 302682, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
--Naeno Megacrash
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20203))
local warnRoadkill					= mod:NewSpellAnnounce(298946, 3)
local warnBurnout					= mod:NewSpellAnnounce(298571, 3)

local specWarnBoltBuster			= mod:NewSpecialWarningDodge(298940, "Tank", nil, nil, 1, 2)
local specWarnPedaltotheMetal		= mod:NewSpecialWarningDodge(298651, nil, nil, nil, 2, 2)

local timerRoadKillCD				= mod:NewCDTimer(27, 298946, nil, nil, nil, 3)
local timerBoltBusterCD				= mod:NewCDTimer(18.2, 298940, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerPedaltotheMetalCD		= mod:NewCDTimer(60, 298651, nil, nil, nil, 3)

mod.vb.MetalCast = 0

local SmokeBombName = DBM:GetSpellInfo(298573)

function mod:MegaTazeTarget(targetname)
	if not targetname then return end
	if self:AntiSpam(4, targetname) then--Antispam to lock out redundant later warning from firing if this one succeeds
		if targetname == UnitName("player") then
			specWarnMegaTaze:Show(SmokeBombName)
			specWarnMegaTaze:Play("findshelter")
			yellMegaTaze:Yell()
		else
			warnMegaTaze:Show(targetname)
		end
	end
end

function mod:OnCombatStart(delay)
	self.vb.MetalCast = 0
	timerPedaltotheMetalCD:Start(4.4)
	timerMegaTazeCD:Start(25.5-delay)
	timerBoltBusterCD:Start(36.4-delay)
	timerRoadKillCD:Start(31.6-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 298669 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnTaze:Show(args.sourceName)
			specWarnTaze:Play("kickcast")
		end
	elseif spellId == 302682 then
		--25.5, 40.1
		timerMegaTazeCD:Start()
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "MegaTazeTarget", 0.1, 12, true, nil, nil, nil, true)
	elseif spellId == 298897 then
		warnJumpStart:Show()
	elseif spellId == 298940 then
		specWarnBoltBuster:Show()
		specWarnBoltBuster:Play("shockwave")
		--36.4, 18.2"
		timerBoltBusterCD:Start()
	elseif spellId == 298946 then
		warnRoadkill:Show()
		--31.6, 27.0, 33.6
	elseif spellId == 298651 or spellId == 299164 then
		self.vb.MetalCast = self.vb.MetalCast + 1
		specWarnPedaltotheMetal:Show()
		specWarnPedaltotheMetal:Play("chargemove")
		--"Pedal to the Metal-298651-npc:153756 = pull:14.8, 60.7", -- [36]
		--"Pedal to the Metal-299164-npc:153756 = pull:4.4, 61.5", -- [37]
		if self.vb.MetalCast % 2 == 0 then
			timerPedaltotheMetalCD:Start(50)--51.1, but small sample so 50 used
		else
			timerPedaltotheMetalCD:Start(9.6)
		end
	elseif spellId == 298571 then
		warnBurnout:Show()
	end
end

--https://www.wowhead.com/npc=153756/mechacycle#abilities
function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 153755 then--Naeno
		timerPedaltotheMetalCD:Stop()
		timerRoadKillCD:Stop()
		timerBoltBusterCD:Stop()
	elseif cid == 150712 then--Trixie
		timerMegaTazeCD:Stop()
	end
end
