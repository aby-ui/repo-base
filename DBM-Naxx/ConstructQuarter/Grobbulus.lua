local mod	= DBM:NewMod("Grobbulus", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190817015124")
mod:SetCreatureID(15931)
mod:SetEncounterID(1111)
mod:SetUsedIcons(1, 2, 3, 4)

mod:RegisterCombat("combat")
mod:SetModelID(16035)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 28169",
	"SPELL_AURA_REMOVED 28169",
	"SPELL_CAST_SUCCESS 28240"
)

local warnInjection		= mod:NewTargetAnnounce(28169, 2)
local warnCloud			= mod:NewSpellAnnounce(28240, 2)

local specWarnInjection	= mod:NewSpecialWarningYou(28169, nil, nil, nil, 1, 2)

local timerInjection	= mod:NewTargetTimer(10, 28169, nil, nil, nil, 3)
local timerCloud		= mod:NewNextTimer(15, 28240, nil, nil, nil, 3)
local enrageTimer		= mod:NewBerserkTimer(720)

mod:AddSetIconOption("SetIconOnInjectionTarget", 28169, false, false, {1, 2, 3, 4})

local mutateIcons = {}

local function addIcon(self)
	for i,j in ipairs(mutateIcons) do
		local icon = 0 + i
		self:SetIcon(j, icon)
	end
end

local function removeIcon(self, target)
	for i,j in ipairs(mutateIcons) do
		if j == target then
			table.remove(mutateIcons, i)
			self:SetIcon(target, 0)
		end
	end
	addIcon(self)
end

function mod:OnCombatStart(delay)
	table.wipe(mutateIcons)
	enrageTimer:Start(-delay)
end

function mod:OnCombatEnd()
    for i,j in ipairs(mutateIcons) do
       self:SetIcon(j, 0)
    end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 28169 then
		warnInjection:Show(args.destName)
		timerInjection:Start(args.destName)
		if args:IsPlayer() then
			specWarnInjection:Show()
			specWarnInjection:Play("runout")
		end
		if self.Options.SetIconOnInjectionTarget then
			table.insert(mutateIcons, args.destName)
			addIcon()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 28169 then
		timerInjection:Cancel(args.destName)--Cancel timer if someone is dumb and dispels it.
		if self.Options.SetIconOnInjectionTarget then
			removeIcon(self, args.destName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 28240 then
		warnCloud:Show()
		timerCloud:Start()
	end
end
