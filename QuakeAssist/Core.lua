------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2017/6/22
------------------------------------------------------------

local type = type
local GetTime = GetTime
local UnitDebuff = Pre80API.UnitDebuff
local UnitBuff = Pre80API.UnitBuff
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local PlaySoundFile = PlaySoundFile

local addon = LibAddonManager:CreateAddon(...)
local L = addon.L

addon.title = L["title"]
addon:RegisterDB("QuakeAssistDB")
addon:RegisterSlashCmd("quakeassist", "qa")

--addon.debug = 1 -- debug

local AFFIX_ID = 14 -- Quaking
local QUAKE_SPELL, _, QUAKE_ICON = GetSpellInfo(240447) -- Quake
local DEBUG_SPELL = GetSpellInfo(774)
local WARNING_SOUND = addon.path.."\\Alert.ogg" -- Replace Alert.ogg with your own sound file if preferred

addon.QUAKE_SPELL = QUAKE_SPELL
addon.QUAKE_ICON = QUAKE_ICON

function addon:OnInitialize(db, isNew)
	self:BroadcastEvent("OnInitialize", db, isNew)

	if self.debug then
		self:Enable()
	else
		self:RegisterEvent("CHALLENGE_MODE_START")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CHALLENGE_MODE_START")
		self:CHALLENGE_MODE_START()
	end
end

function addon:CHALLENGE_MODE_START()
	if self:FindAffix(AFFIX_ID) then
		self:Enable()
	else
		self:Disable()
	end
end

function addon:Enable()
	if self:IsEventRegistered("UNIT_AURA") then
		return
	end

	self:Print(L["enabled prompt"])
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_SPELLCAST_START", "CheckCasting")
	self:RegisterEvent("UNIT_SPELLCAST_STOP", "CheckCasting")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "CheckCasting")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "CheckCasting")
	self:UNIT_AURA("player")
end

function addon:Disable()
	if not self:IsEventRegistered("UNIT_AURA") then
		return
	end

	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_SPELLCAST_START")
	self:UnregisterEvent("UNIT_SPELLCAST_STOP")
	self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self.frame:Disable()
	self:Print(L["disabled prompt"])
end

function addon:FindAffix(affix)
	if not affix then
		return
	end

	local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
	if type(level) ~= "number" or level < 4 or type(affixes) ~= "table" then
		return
	end

	local i
	for i = 1, 3 do
		if affixes[i] == affix then
			return i
		end
	end
end

function addon:VoiceAlert()
	if self.db.voice then
		PlaySoundFile(WARNING_SOUND, "Master")
	end
end

function addon:CheckAlert()
	local dangerous = self.quakeEndTime and self.castingEndTime and (self.quakeEndTime --[[+ self.db.tolerance / 100--]] < self.castingEndTime)
	if dangerous ~= self.dangerous then
		self.dangerous = dangerous
		self:BroadcastEvent("OnAlert", dangerous)
		if dangerous then
			self:VoiceAlert()
		end
	end
end

function addon:UNIT_AURA(unit)
	if unit ~= "player" then
		return
	end

	local name, _, _, _, duration, expires
	if self.debug then
		name, _, _, _, duration, expires = UnitBuff("player", DEBUG_SPELL)
		if name then
			local diff = duration - 2.5
			duration = 2.5
			expires = expires - diff
		end
	else
		name, _, _, _, duration, expires = UnitDebuff("player", QUAKE_SPELL)
	end

	if self.hasDebuff == name then
		return -- nothing changes
	end

	self.hasDebuff = name

	if name then
		local startTime = expires - duration
		self.nextQuakeStartTime = startTime
		self.quakeEndTime = expires
		self:BroadcastEvent("OnQuake", startTime, expires)
	else
		self.quakeEndTime = nil
		self:BroadcastEvent("OnQuake")
	end

	self:CheckAlert()
end

function addon:PredictNextQuake()
	-- possibly quake every 20 seconds, sometimes 40
	local nextQuakeStartTime = self.nextQuakeStartTime
	if not nextQuakeStartTime then
		return
	end

	local now = GetTime()
	while nextQuakeStartTime <= now do
		nextQuakeStartTime = nextQuakeStartTime + 20
	end

	self.nextQuakeStartTime = nextQuakeStartTime
	return nextQuakeStartTime - 20, nextQuakeStartTime
end

function addon:CheckCasting(unit)
	if unit ~= "player" then
		return
	end

	local name, _, texture, startTime, endTime = UnitCastingInfo("player")
	if not name then
		name, _, texture, startTime, endTime = UnitChannelInfo("player")
	end

	if endTime == 0 then
		name, startTime, endTime = nil
	end

	if startTime then
		startTime = startTime / 1000
	end

	if endTime then
		endTime = endTime / 1000
	end

	if self.castingEndTime == endTime then
		return
	end

	self.castingEndTime = endTime
	self:BroadcastEvent("OnCasting", name, texture, startTime, endTime)
	self:CheckAlert()
end
