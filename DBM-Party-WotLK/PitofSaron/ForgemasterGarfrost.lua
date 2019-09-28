local mod	= DBM:NewMod(608, "DBM-Party-WotLK", 15, 278)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(36494)
mod:SetEncounterID(833, 834, 1999)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68788",
	"SPELL_AURA_APPLIED 70381 68785",
	"SPELL_AURA_APPLIED_DOSE 68786",
--	"CHAT_MSG_RAID_BOSS_EMOTE",
	"RAID_BOSS_WHISPER",
	"CHAT_MSG_ADDON"
)

local warnForgeWeapon			= mod:NewSpellAnnounce(68785, 2)
local warnDeepFreeze			= mod:NewTargetAnnounce(70381, 2)
local warnSaroniteRock			= mod:NewTargetAnnounce(68789, 3)

local specWarnSaroniteRock		= mod:NewSpecialWarningYou(68789, nil, nil, nil, 1, 2)
local yellRock					= mod:NewYell(68789)
local specWarnSaroniteRockNear	= mod:NewSpecialWarningClose(68789, nil, nil, nil, 1, 2)
local specWarnPermafrost		= mod:NewSpecialWarningStack(68786, nil, 9, nil, nil, 1, 2)

local timerSaroniteRockCD		= mod:NewCDTimer(15.5, 68789, nil, nil, nil, 3)--15.5-20
local timerDeepFreezeCD			= mod:NewCDTimer(19, 70381, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON)
local timerDeepFreeze			= mod:NewTargetTimer(14, 70381, nil, false, 3, 5)

mod:AddSetIconOption("SetIconOnSaroniteRockTarget", 68789, true, false, {8})
mod:AddBoolOption("AchievementCheck", false, "announce")

mod.vb.warnedfailed = false

function mod:OnCombatStart(delay)
	self.vb.warnedfailed = false
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 68788 then
		timerSaroniteRockCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 70381 then		-- Deep Freeze
		--Can be warned 2 seconds earlier using emote
		--For now I willn ot change it though
		warnDeepFreeze:Show(args.destName)
		timerDeepFreeze:Start(args.destName)
		timerDeepFreezeCD:Start()
	elseif spellId == 68785 then	-- Forge Frostborn Mace
		warnForgeWeapon:Show()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 68786 then
		local amount = args.amount or 1
		if amount >= 9 and args:IsPlayer() and self:AntiSpam(5) then --11 stacks is what's needed for achievement, 9 to give you time to clear/dispel
			specWarnPermafrost:Show(amount)
			specWarnPermafrost:Play("stackhigh")
		end
		if self.Options.AchievementCheck and not self.vb.warnedfailed then
			local channel = IsInGroup(2) and "INSTANCE_CHAT" or "PARTY"
			if amount == 9 or amount == 10 then
				SendChatMessage(L.AchievementWarning:format(args.destName, amount), channel)
			elseif amount > 11 then
				SendChatMessage(L.AchievementFailed:format(args.destName, amount), channel)
				self.vb.warnedfailed = true
			end
		end
	end
end

--"<125.43 21:07:21> [CHAT_MSG_RAID_BOSS_EMOTE] %s casts |cFF00AACCDeep Freeze|r at Moonianna.#Forgemaster Garfrost###Moonianna##0#0##0#870#nil#0#false#false#false#false", -- [1]
--function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, targetname)
--	warnDeepFreeze:Show(targetname)
--end

function mod:RAID_BOSS_WHISPER(msg)
	--Commented out string check for now, since it should be the only thing on fight sending RAID_BOSS_WHISPER
--	if msg == L.SaroniteRockThrow or msg:match(L.SaroniteRockThrow) then
		specWarnSaroniteRock:Show()
		specWarnSaroniteRock:Play("watchstep")
		yellRock:Yell()
--	end 
end

--per usual, use transcriptor message to get messages from both bigwigs and DBM, all without adding comms to this mod at all
function mod:CHAT_MSG_ADDON(prefix, msg, channel, targetName)
	if prefix ~= "Transcriptor" then return end
	--Could maybe drop localized text, but it risks breaking if someone happens to be in party (in a different place and is also sending RBW syncs)
	if msg == L.SaroniteRockThrow or msg:find(L.SaroniteRockThrow) then
		targetName = Ambiguate(targetName, "none")
		if self:AntiSpam(5, targetName) then--Antispam sync by target name, since this doesn't use dbms built in onsync handler.
			local uId = DBM:GetRaidUnitId(targetName)
			if uId and not UnitIsUnit(uId, "player") then
				if self:CheckNearby(10, targetName) then
					specWarnSaroniteRockNear:Show(targetName)
					specWarnSaroniteRockNear:Play("watchstep")
				else
					warnSaroniteRock:Show(targetName)
				end
			end
			if self.Options.SetIconOnSaroniteRockTarget then
				self:SetIcon(targetName, 8, 5)
			end
		end
	end
end
