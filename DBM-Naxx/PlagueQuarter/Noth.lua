local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190519032251")
mod:SetCreatureID(15954)
mod:SetEncounterID(1117)
mod:SetModelID(16590)
mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 29213 54835 29212",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnTeleportNow	= mod:NewAnnounce("WarningTeleportNow", 3, "135736")
local warnTeleportSoon	= mod:NewAnnounce("WarningTeleportSoon", 1, "135736")
local warnCurse			= mod:NewSpellAnnounce(29213, 2)

local specWarnAdds		= mod:NewSpecialWarningAdds(29212, "-Healer", nil, nil, 1, 2)

local timerTeleport		= mod:NewTimer(90, "TimerTeleport", "135736", nil, nil, 6)
local timerTeleportBack	= mod:NewTimer(70, "TimerTeleportBack", "135736", nil, nil, 6)
local timerCurseCD		= mod:NewCDTimer(53.3, 29213, nil, nil, nil, 5, nil, DBM_CORE_CURSE_ICON)
local timerAddsCD		= mod:NewAddsTimer(30, 29212, nil, "-Healer")

mod.vb.teleCount = 0
mod.vb.addsCount = 0
mod.vb.curseCount = 0

function mod:OnCombatStart(delay)
	self.vb.teleCount = 0
	self.vb.addsCount = 0
	self.vb.curseCount = 0
	timerAddsCD:Start(7-delay)
	timerCurseCD:Start(9.5-delay)
	timerTeleport:Start(90.8-delay)
	warnTeleportSoon:Schedule(70.8-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29213, 54835) then	-- Curse of the Plaguebringer
		self.vb.curseCount = self.vb.curseCount + 1
		warnCurse:Show()
		if self.vb.teleCount == 2 and self.vb.curseCount == 2 or self.vb.teleCount == 3 and self.vb.curseCount == 1 then
			timerCurseCD:Start(67)--Niche cases it's 67 and not 53-55
		elseif self.vb.curseCount < 2 then
			timerCurseCD:Start()
		end
	elseif args.spellId == 29212 then--Cripple that's always cast when he teleports away
		self.vb.teleCount = self.vb.teleCount + 1
		self.vb.addsCount = 0
		timerCurseCD:Stop()
		timerAddsCD:Stop()
		local timer
		if self.vb.teleCount == 1 then
			timer = 70
			timerAddsCD:Start(5)--Always 5
		elseif self.vb.teleCount == 2 then
			timer = 97
			timerAddsCD:Start(5)--Always 5
		elseif self.vb.teleCount == 3 then
			timer = 126
			timerAddsCD:Start(5)--Always 5
		else
			timer = 55
		end
		timerTeleportBack:Start(timer)
		warnTeleportSoon:Schedule(timer - 20)
		warnTeleportNow:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	if msg == L.Adds or msg:find(L.Adds) then
		self:SendSync("Adds")--Syncing to help unlocalized clients
	elseif msg == L.AddsTwo or msg:find(L.AddsTwo) then
		self:SendSync("AddsTwo")--Syncing to help unlocalized clients
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 29231 then--Teleport Return
		self.vb.addsCount = 0
		self.vb.curseCount = 0
		timerAddsCD:Stop()
		local timer
		if self.vb.teleCount == 1 then
			timer = 109
			timerAddsCD:Start(10)
		elseif self.vb.teleCount == 2 then
			timer = 173
			timerAddsCD:Start(17)
		elseif self.vb.teleCount == 3 then
			timer = 93
		else
			timer = 35
		end
		timerTeleport:Start(timer)
		warnTeleportSoon:Schedule(timer - 20)
		warnTeleportNow:Show()
		if self.vb.teleCount == 4 then--11-12 except after 4th return it's 17
			timerCurseCD:Start(17)--verify consistency though
		else
			timerCurseCD:Start(11)
		end
	end
end

function mod:OnSync(msg, targetname)
	if not self:IsInCombat() then return end
	if msg == "Adds" then--Boss Grounded
		self.vb.addsCount = self.vb.addsCount + 1
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")
		if self.vb.teleCount < 4 then
			if self.vb.teleCount == 0 and self.vb.addsCount < 3 then--3 waves 30 seconds apart
				timerAddsCD:Start(30)
			elseif self.vb.teleCount == 1 then--3 waves 34 then 47 seconds apart
				if self.vb.addsCount == 1 then
					timerAddsCD:Start(33.9)
				else
					timerAddsCD:Start(47.3)
				end
			elseif self.vb.teleCount == 2 then--30, 32, 32, 30
				if self.vb.addsCount == 1 or self.vb.addsCount == 4 then
					timerAddsCD:Start(30)
				elseif self.vb.addsCount == 2 or self.vb.addsCount == 3 then
					timerAddsCD:Start(32)
				end
			end
		end
	elseif msg == "AddsTwo" then--Boss away
		self.vb.addsCount = self.vb.addsCount + 1
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")
		--He won't do anymore adds when teleported way on 4th and later teleport
		--He'll never do more than 2 waves
		if self.vb.teleCount < 4 and self.vb.addsCount == 1 then
			if self.vb.teleCount == 3 then
				timerAddsCD:Start(60)--2 big waves, 60 seconds apart
			elseif self.vb.teleCount == 2 then--2 medium waves 46 seconds apart
				timerAddsCD:Start(46)
			else--2 smaller waves 30 seconds apart
				timerAddsCD:Start(30)
			end
		end
	end
end
