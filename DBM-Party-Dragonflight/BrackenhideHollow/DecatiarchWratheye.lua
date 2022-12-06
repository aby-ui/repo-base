local mod	= DBM:NewMod(2474, "DBM-Party-Dragonflight", 1, 1196)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221206015003")
mod:SetCreatureID(186121)
mod:SetEncounterID(2569)
mod:SetUsedIcons(8)
mod:SetHotfixNoticeRev(20221505000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 373960 376170 373912",
	"SPELL_SUMMON 373944",
	"SPELL_AURA_APPLIED 373896",
	"SPELL_AURA_APPLIED_DOSE 373896",
	"SPELL_AURA_REMOVED 373896",
	"SPELL_AURA_REMOVED_DOSE 373896"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
)

--[[
(ability.id = 373960 or ability.id = 376170 or ability.id = 373912) and type = "begincast"
 or ability.id = 373944 and type = "summon"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--TODO, longer pulls for decaying strength timer
local warnDecayigStrength						= mod:NewSpellAnnounce(373960, 3)

local specWarnRotburstTotem						= mod:NewSpecialWarningSwitch(373944, nil, nil, nil, 1, 2)
local specWarnChokingRotcloud					= mod:NewSpecialWarningDodge(376170, nil, nil, nil, 2, 2, 4)
local specWarnDecaystrike						= mod:NewSpecialWarningDefensive(373917, nil, nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerDecayingStrengthCD					= mod:NewCDTimer(35, 373960, nil, nil, nil, 2)
local timerRotburstTotemCD						= mod:NewCDTimer(18.2, 373944, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)--18-21
local timerChokingRotcloutCD					= mod:NewCDTimer(42.5, 376170, nil, nil, nil, 3, nil, DBM_COMMON_L.MYTHIC_ICON)
local timerDecayStrikeCD						= mod:NewCDTimer(19.4, 373917, nil, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(5, 373941)
mod:AddInfoFrameOption(373896, true)
mod:AddSetIconOption("SetIconOnRotburstTotem", 373944, true, 5, {8})

local WitheringRotStacks = {}
mod.vb.waterCount = 0

function mod:OnCombatStart(delay)
	table.wipe(WitheringRotStacks)
	self.vb.waterCount = 0
	if self:IsMythic() then
		timerChokingRotcloutCD:Start(5.1-delay)
	end
	timerDecayStrikeCD:Start(10.8-delay)
	timerRotburstTotemCD:Start(19.1-delay)
	timerDecayingStrengthCD:Start(41.1-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(373896))
		DBM.InfoFrame:Show(5, "table", WitheringRotStacks, 1)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(5)
	end
end

function mod:OnCombatEnd()
	table.wipe(WitheringRotStacks)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 373960 then
		warnDecayigStrength:Show()
--		timerDecayingStrengthCD:Start()
	elseif spellId == 376170 then
		specWarnChokingRotcloud:Show()
		specWarnChokingRotcloud:Play("shockwave")
		timerChokingRotcloutCD:Start()
	elseif spellId == 373912 then
		timerDecayStrikeCD:Start()
		if args:IsPlayer() then
			specWarnDecaystrike:Show()
			specWarnDecaystrike:Play("defensive")
		end
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 373944 then
		specWarnRotburstTotem:Show()
		specWarnRotburstTotem:Play("attacktotem")
		timerRotburstTotemCD:Start()
		if self.Options.SetIconOnRotburstTotem then
			self:ScanForMobs(args.destGUID, 2, 8, 1, nil, 12, "SetIconOnRotburstTotem")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 373896 then
		local amount = args.amount or 1
		WitheringRotStacks[args.destName] = amount
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(WitheringRotStacks, 0.2)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 373896 then
		WitheringRotStacks[args.destName] = nil
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(WitheringRotStacks, 0.2)
		end
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 373896 then
		WitheringRotStacks[args.destName] = args.amount or 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(WitheringRotStacks, 0.2)
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 340324 and destGUID == UnitGUID("player") and not playerDebuff and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
--]]
