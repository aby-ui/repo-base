local mod	= DBM:NewMod("Shot", "DBM-DMF")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190527213044")
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 101871",
	"SPELL_AURA_REMOVED 101871"
)
mod.noStatistics = true

local timerGame		= mod:NewBuffActiveTimer(60, 101871, nil, nil, nil, 5, nil, nil, nil, 1, 5)

mod:AddBoolOption("SetBubbles", true)--Because the NPC is an annoying and keeps doing chat says while you're shooting which cover up the targets if bubbles are on.

local CVAR = false

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 101871 and args:IsPlayer() then
		timerGame:Start()
		if self.Options.SetBubbles and GetCVarBool("chatBubbles") then
			CVAR = true
			SetCVar("chatBubbles", 0)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 101871 and args:IsPlayer() then
		timerGame:Cancel()
		if self.Options.SetBubbles and not GetCVarBool("chatBubbles") and CVAR then--Only turn them back on if they are off now, but were on when we minigame
			SetCVar("chatBubbles", 1)
			CVAR = false
		end
	end
end
