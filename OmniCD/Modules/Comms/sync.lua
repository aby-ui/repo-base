local E, L, C = select(2, ...):unpack()

local strjoin = strjoin
local strsplit = strsplit
local strfind = string.find
local strmatch = string.match
local GetNumGroupMembers = GetNumGroupMembers
local UnitPower = UnitPower
--[AC] local SendAddonMessage = C_ChatInfo.SendAddonMessage
local Comms = E["Comms"]
local P = E["Party"]
local spell_cdmod_powerSpent = E.spell_cdmod_powerSpent
local soulbind_conduits_rank = E.soulbind_conduits_rank
local covenant_IDToSpellID = E.covenant_IDToSpellID
local userGUID = E.userGUID
local MSG_INFO = "INF"
local MSG_INFO_REQUEST = "REQ"
local MSG_INFO_UPDATE = "UPD"
local MSG_POWER = "PWR"
local MSG_DESYNC = "DESYNC"
local POWER_TYPE_IDS = E.POWER_TYPE_IDS
E.syncData = ""

Comms.syncGUIDS = {}

local function SyncRemainingCD(guid, spentPower)
	local info = P.groupInfo[guid]
	if not info then
		return
	end

	for k, t in pairs(spell_cdmod_powerSpent) do
		local talent, duration, base, aura = t[1], t[2], t[3], t[4]
		local icon = info.spellIcons[k] -- [1]
		if icon and icon.active and (not aura or info.auras[aura]) then
			local reducedTime = P:IsTalent(talent, guid) and P:GetValueByType(duration, guid) or base
			if reducedTime then
				reducedTime = reducedTime * spentPower
				if info.auras.isTrueBearing then
					reducedTime = reducedTime * 2
				end

				P:UpdateCooldown(icon, reducedTime)
			end
		end
	end
end

local function SendComm(...)
	if IsInRaid() then
		--[AC] C_ChatInfo.SendAddonMessage("OmniCD", strjoin(",", ...), (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
		Comms:SendCommMessage("OmniCD", strjoin(",", ...), (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
	elseif IsInGroup() then
		--[AC] C_ChatInfo.SendAddonMessage("OmniCD", strjoin(",", ...), (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
		Comms:SendCommMessage("OmniCD", strjoin(",", ...), (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
	end
end

function Comms:RequestSync()
	--wipe(self.syncGUIDS)
	SendComm(MSG_INFO_REQUEST, E.syncData)
end

function Comms:SendSync(sender)
	if not E.syncData then
		self:InspectPlayer()
	end

	if sender then -- [75]
		--[AC] C_ChatInfo.SendAddonMessage("OmniCD", strjoin(",", MSG_INFO, E.syncData), "WHISPER", sender)
		self:SendCommMessage("OmniCD", strjoin(",", MSG_INFO, E.syncData), "WHISPER", sender)
	else
		SendComm(MSG_INFO_UPDATE, E.syncData)
	end
end

function Comms:Desync()
	wipe(self.syncGUIDS)
	SendComm(MSG_DESYNC, userGUID, 1)
end

function Comms:CHAT_MSG_ADDON(prefix, message, dist, sender) -- [29]
	--[AC] if prefix ~= "OmniCD" or sender == E.userNameWithRealm then
	if prefix ~= "OmniCD" or sender == E.userName then
		return
	end

	local header, guid, body = strmatch(message, "(.-),(.-),(.+)")
	local info = P.groupInfo[guid]
	if not info then -- class nil in updateRoster
		return
	end

	local isSyncedUnit = self.syncGUIDS[guid]

	if header == MSG_DESYNC then
		if isSyncedUnit then
			self.syncGUIDS[guid] = nil
		end
		return
	elseif header == MSG_POWER then
		if isSyncedUnit then
			SyncRemainingCD(guid, body)
		end
		return
	elseif header == MSG_INFO_REQUEST then
		self:SendSync(sender)
	elseif header == MSG_INFO_UPDATE then
		if not isSyncedUnit then
			return
		end
	end

	info.talentData = {}
	info.invSlotData = {}
	info.shadowlandsData = {}

	local s, e, v = 1
	local i = 0
	local isInvSlot = false

	while true do
		s, e, v = strfind(body, "([^,]+)", s)
		if s == nil then
			break
		end

		s = e + 1
		i = i + 1

		if E.isBCC then
			if v == "|" then
				isInvSlot = true
			else
				v = tonumber(v)

				if isInvSlot then
					info.invSlotData[v] = true
				elseif i > 1 then
					if v < 1 then
						info.RAS = -v
					else
						info.talentData[v] = true
					end
				else
					info.spec = v
				end
			end
		else
			if i > 16 then
				local conduitID, conduitRank = strsplit("-", v)
				conduitID = tonumber(conduitID)
				conduitRank = tonumber(conduitRank)
				if conduitRank then
					local spellID = C_Soulbinds.GetConduitSpellID(conduitID, conduitRank)
					local rankValue = soulbind_conduits_rank[spellID] and (soulbind_conduits_rank[spellID][conduitRank] or soulbind_conduits_rank[spellID][1])
					info.shadowlandsData[conduitID] = conduitRank
					info.talentData[spellID] = rankValue
				elseif conduitID then
					info.shadowlandsData[conduitID] = 0
					info.talentData[conduitID] = 0
				end
			elseif v ~= "0" then
				v = tonumber(v)
				if i == 16 then
					if info.shadowlandsData.covenantID then
						info.shadowlandsData.soulbindID = v
					else -- backwards compatibile. no active soulbind, add snowflake
						info.talentData[v] = true
					end
				elseif i == 15 then
					local covenantSpellID = covenant_IDToSpellID[v]
					if covenantSpellID then
						info.shadowlandsData.covenantID = covenantSpellID
						info.talentData[covenantSpellID] = "C"
					end
				elseif i == 14 then
					info.shadowlandsData.runeforgeDescID = v
					info.talentData[v] = "R"
				elseif i > 11 then
					info.invSlotData[v] = true
				elseif i > 1 then
					info.talentData[v] = i > 8 and "PVP" or true
				else
					info.spec = v
				end
			end
		end
	end

	self.syncGUIDS[guid] = true
	self:DequeueInspect(guid)

	P:UpdateUnitBar(guid)
end

local sendUpdatedSyncInfo = function()
	Comms:InspectPlayer()
	Comms:SendSync()
end

do
	local timer

	local onTimerEnd = function()
		sendUpdatedSyncInfo()
		timer = nil
	end

	function Comms:PLAYER_EQUIPMENT_CHANGED(slotID)
		if timer or slotID > 16 then -- snow flake
			return
		end

		timer = C_Timer.NewTicker(0.1, onTimerEnd, 1)
	end
end

if E.isBCC then return end

do
	local lastPower = 0
	local isInCombat
	local isRogueClass = E.userClass == "ROGUE"

	function Comms:UNIT_POWER_UPDATE(unit, powerType)
		local powerID = POWER_TYPE_IDS[powerType]
		if powerID then
			local power = UnitPower(unit, powerID)
			if power < lastPower then
				local spent = lastPower - power
				if isInCombat or spent > self.oocThreshold then -- [12]
					if not P.isUserDisabled then -- [82]
						if isRogueClass and P.userData.spec == 260 then -- BTE
							self.spentPower = spent
						end
						SyncRemainingCD(userGUID, spent)
					end

					if next(self.syncGUIDS) then
						SendComm(MSG_POWER, userGUID, spent)
					end
				end
			end
			lastPower = power
		end
	end

	function Comms:PLAYER_REGEN_ENABLED()
		isInCombat = nil
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	function Comms:PLAYER_REGEN_DISABLED()
		isInCombat = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function Comms:RegisterEventUnitPower()
	local specIndex = GetSpecialization()
	local specID = GetSpecializationInfo(specIndex)
	local powerSpec = E.POWER_TYPE_SPEC[specID]

	self.oocThreshold = powerSpec == 1 and 3 or 1

	if E.profile.Party.sync and powerSpec then
		if UnitAffectingCombat("player") then
			self:PLAYER_REGEN_DISABLED()
		else
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	else
		self:UnregisterEvent("UNIT_POWER_UPDATE")
	end
end

Comms.COVENANT_CHOSEN = sendUpdatedSyncInfo
Comms.SOULBIND_ACTIVATED = sendUpdatedSyncInfo
Comms.SOULBIND_NODE_LEARNED = sendUpdatedSyncInfo
Comms.SOULBIND_NODE_UNLEARNED = sendUpdatedSyncInfo
Comms.SOULBIND_NODE_UPDATED = sendUpdatedSyncInfo
Comms.SOULBIND_CONDUIT_INSTALLED = sendUpdatedSyncInfo
Comms.SOULBIND_PATH_CHANGED = sendUpdatedSyncInfo
