local mod	= DBM:NewMod(1655, "DBM-Party-Legion", 2, 762)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(103344)
mod:SetEncounterID(1837)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 204666 204646 204574 204667"
)

local warnShatteredEarth			= mod:NewSpellAnnounce(204666, 2)
local warnThrowTarget				= mod:NewTargetNoFilterAnnounce(204658, 2)--This is target the tank is THROWN at.

local specWarnRoots					= mod:NewSpecialWarningDodge(204574, nil, nil, nil, 2, 2)
local yellThrow						= mod:NewYell(204658, 2764)--yell so others can avoid splash damage. I don't think target can avoid
local specWarnBreath				= mod:NewSpecialWarningDefensive(204667, "Tank", nil, nil, 1, 2)

local timerShatteredEarthCD			= mod:NewCDTimer(35, 204666, nil, nil, nil, 2)--35-62 variation? is this health based?
local timerThrowCD					= mod:NewCDTimer(28, 204658, nil, nil, nil, 3, nil, DBM_COMMON_L.TANK_ICON, nil, mod:IsTank() and 2, 4)--29-32
local timerRootsCD					= mod:NewCDTimer(23, 204574, nil, nil, nil, 3)--23-31
local timerBreathCD					= mod:NewCDTimer(26.5, 204667, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--26--35

--AKA Crushing Grip
function mod:ThrowTarget(targetname, uId)
	if not targetname then
		return
	end
	warnThrowTarget:Show(targetname)
	if targetname == UnitName("player") then
		--Can this be dodged? personal warning?
		yellThrow:Yell()
	end
end

function mod:OnCombatStart(delay)
	timerShatteredEarthCD:Start(5.8-delay)
	timerRootsCD:Start(12-delay)
	timerBreathCD:Start(18-delay)
	timerThrowCD:Start(28.5-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 204646 then
		timerThrowCD:Start()
		self:BossTargetScanner(103344, "ThrowTarget", 0.1, 12, true, nil, nil, nil, true)
	elseif spellId == 204666 then
		warnShatteredEarth:Show()
		timerShatteredEarthCD:Start()
	elseif spellId == 204574 then
		specWarnRoots:Show()
		specWarnRoots:Play("watchstep")
		timerRootsCD:Start()
	elseif spellId == 204667 then
		specWarnBreath:Show()
		specWarnBreath:Play("defensive")
		timerBreathCD:Start()
	end
end
