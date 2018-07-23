local mod	= DBM:NewMod("HoFTrash", "DBM-HeartofFear")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 11184 $"):sub(12, -3))
--mod:SetModelID(47785)
mod:SetZone()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 125877",
	"UNIT_SPELLCAST_SUCCEEDED target focus mouseover"
)

local specWarnUnseenStrike		= mod:NewSpecialWarningYou(123017)
local specWarnUnseenStrikeOther	= mod:NewSpecialWarningMoveTo(123017)
local yellUnseenStrike			= mod:NewYell(122949)
local specWarnDispatch			= mod:NewSpecialWarningInterrupt(125877)

local timerUnseenStrike			= mod:NewCastTimer(4.8, 123017)

mod:AddBoolOption("UnseenStrikeArrow")

local scanTime = 0

local function findUnseen(spellName)
	if not spellName then return end
	scanTime = scanTime + 1
	for uId in DBM:GetGroupMembers() do
		local name = DBM:GetUnitFullName(uId)
		if DBM:UnitDebuff(uId, spellName) then
			if name == UnitName("player") then
				specWarnUnseenStrike:Show()
				yellUnseenStrike:Yell()
			else
				specWarnUnseenStrikeOther:Show(name)
				if mod.Options.UnseenStrikeArrow then
					DBM.Arrow:ShowRunTo(uId, 3, 5)
				end
			end
			return
		end
	end
	if scanTime < 10 then
		mod:Schedule(0.1, findUnseen)
	end
end

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	if args.spellId == 125877 then
		if args.sourceGUID == UnitGUID("target") then
			specWarnDispatch:Show(args.sourceName)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if not self.Options.Enabled then return end
	if spellId == 122949 and self:AntiSpam() and self:GetCIDFromGUID(UnitGUID(uId)) == 64340 then
		self:SendSync("UnseenTrash", DBM:GetSpellInfo(spellId))
	end
end

function mod:OnSync(msg, spellName)
	if msg == "UnseenTrash" then
		scanTime = 0
		findUnseen(spellName)
	end
end
