local mod	= DBM:NewMod("Sartharion", "DBM-ChamberOfAspects", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(28860)
mod:SetEncounterID(1090)
mod:SetModelID(27035)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 57579 59127",
	"SPELL_AURA_APPLIED 57491",
	"SPELL_DAMAGE 59128",
	"RAID_BOSS_EMOTE"
)
mod.onlyNormal = true

local warnShadowFissure	    = mod:NewSpellAnnounce(59127, 4, nil, nil, nil, nil, nil, 2)
local warnTenebron          = mod:NewAnnounce("WarningTenebron", 2, 61248, false)
local warnShadron           = mod:NewAnnounce("WarningShadron", 2, 58105, false)
local warnVesperon          = mod:NewAnnounce("WarningVesperon", 2, 61251, false)

local warnFireWall			= mod:NewSpecialWarning("WarningFireWall", nil, nil, nil, 2, 2)
local warnVesperonPortal	= mod:NewSpecialWarning("WarningVesperonPortal", false, nil, nil, 1, 7)
local warnTenebronPortal	= mod:NewSpecialWarning("WarningTenebronPortal", false, nil, nil, 1, 7)
local warnShadronPortal		= mod:NewSpecialWarning("WarningShadronPortal", false, nil, nil, 1, 7)

mod:AddBoolOption("AnnounceFails", false, "announce")

local timerShadowFissure    = mod:NewCastTimer(5, 59128, nil, nil, nil, 3)--Cast timer until Void Blast. it's what happens when shadow fissure explodes.
local timerWall             = mod:NewCDTimer(30, 43113, nil, nil, nil, 2)
local timerTenebron         = mod:NewTimer(30, "TimerTenebron", 61248, nil, nil, 1)
local timerShadron          = mod:NewTimer(80, "TimerShadron", 58105, nil, nil, 1)
local timerVesperon         = mod:NewTimer(120, "TimerVesperon", 61251, nil, nil, 1)

local lastvoids = {}
local lastfire = {}
local tsort, tinsert, twipe = table.sort, table.insert, table.wipe

local function isunitdebuffed(spellID)
	local name = DBM:GetSpellInfo(spellID)
	if not name then return false end

	for i=1, DBM:GetNumGroupMembers(), 1 do
		local debuffname = DBM:UnitDebuff("player", i, "HARMFUL")
		if debuffname == name then
			return true
		end
	end
	return false
end

local function CheckDrakes(delay)
	if isunitdebuffed(61248) then	-- Power of Tenebron
		timerTenebron:Start(30 - delay)
		warnTenebron:Schedule(25 - delay)
	end
	if isunitdebuffed(58105) then	-- Power of Shadron
		timerShadron:Start(75 - delay)
		warnShadron:Schedule(70 - delay)
	end
	if isunitdebuffed(61251) then	-- Power of Vesperon
		timerVesperon:Start(120 - delay)
		warnVesperon:Schedule(115 - delay)
	end
end

local sortedFails = {}
local function sortFails1(e1, e2)
	return (lastvoids[e1] or 0) > (lastvoids[e2] or 0)
end
local function sortFails2(e1, e2)
	return (lastfire[e1] or 0) > (lastfire[e2] or 0)
end

function mod:OnCombatStart(delay)
	--Cache spellnames so a solo player check doesn't fail in CheckDrakes in 8.0+
	self:Schedule(5, CheckDrakes, delay)
	timerWall:Start(-delay)

	twipe(lastvoids)
	twipe(lastfire)
end

function mod:OnCombatEnd(wipe)	
	if not self.Options.AnnounceFails then return end
	if DBM:GetRaidRank() < 1 or not self.Options.Announce then return end

	local voids = ""
	for k, v in pairs(lastvoids) do
		tinsert(sortedFails, k)
	end
	tsort(sortedFails, sortFails1)
	for i, v in ipairs(sortedFails) do
		voids = voids.." "..v.."("..(lastvoids[v] or "")..")"
	end
	SendChatMessage(L.VoidZones:format(voids), "RAID")
	twipe(sortedFails)
	
	local fire = ""
	for k, v in pairs(lastfire) do
		tinsert(sortedFails, k)
	end
	tsort(sortedFails, sortFails2)
	for i, v in ipairs(sortedFails) do
		fire = fire.." "..v.."("..(lastfire[v] or "")..")"
	end
	SendChatMessage(L.FireWalls:format(fire), "RAID")
	twipe(sortedFails)
end

function mod:SPELL_CAST_SUCCESS(args)
    if args:IsSpellID(57579, 59127) then
        warnShadowFissure:Show()
        warnShadowFissure:Play("watchstep")
        timerShadowFissure:Start()
    end
end

function mod:SPELL_AURA_APPLIED(args)
	if self.Options.AnnounceFails and self.Options.Announce and args.spellId == 57491 and DBM:GetRaidRank() >= 1 and DBM:GetRaidUnitId(args.destName) ~= "none" and args.destName then
		lastfire[args.destName] = (lastfire[args.destName] or 0) + 1
		SendChatMessage(L.FireWallOn:format(args.destName), "RAID")
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, _, destName, _, _, spellId)
	if self.Options.AnnounceFails and self.Options.Announce and spellId == 59128 and DBM:GetRaidRank() >= 1 and DBM:GetRaidUnitId(destName) ~= "none" and destName then
		lastvoids[destName] = (lastvoids[destName] or 0) + 1
		SendChatMessage(L.VoidZoneOn:format(destName), "RAID")
	end	
end

function mod:RAID_BOSS_EMOTE(msg, mob)
	if msg == L.Wall or msg:find(L.Wall) then
		self:SendSync("FireWall")
	elseif msg == L.Portal or msg:find(L.Portal) then
		if mob == L.NameVesperon then
			self:SendSync("VesperonPortal")
		elseif mob == L.NameTenebron then
			self:SendSync("TenebronPortal")
		elseif mob == L.NameShadron then
			self:SendSync("ShadronPortal")
		end
	end
end

function mod:OnSync(event)
	if event == "FireWall" then
		timerWall:Start()
		warnFireWall:Show()
		warnFireWall:Play("watchwave")
	elseif event == "VesperonPortal" then
		warnVesperonPortal:Show()
		warnVesperonPortal:Play("newportal")
	elseif event == "TenebronPortal" then
		warnTenebronPortal:Show()
		warnTenebronPortal:Play("newportal")
	elseif event == "ShadronPortal" then
		warnShadronPortal:Show()
		warnShadronPortal:Play("newportal")
	end
end
