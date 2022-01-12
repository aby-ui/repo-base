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
		local icon = info.spellIcons[k]
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
--      [AC] C_ChatInfo.SendAddonMessage("OmniCD", strjoin(",", ...), (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
		Comms:SendCommMessage("OmniCD", strjoin(",", ...), (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
	elseif IsInGroup() then
--      [AC] C_ChatInfo.SendAddonMessage("OmniCD", strjoin(",", ...), (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
		Comms:SendCommMessage("OmniCD", strjoin(",", ...), (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
	end
end

function Comms:RequestSync()
--  wipe(self.syncGUIDS) -- removed on GRU now
	SendComm(MSG_INFO_REQUEST, E.syncData)
end

function Comms:SendSync(sender)
	if E.syncData == "" then
		self:InspectPlayer()
	end

	if sender then
--      [AC] C_ChatInfo.SendAddonMessage("OmniCD", strjoin(",", MSG_INFO, E.syncData), "WHISPER", sender)
		self:SendCommMessage("OmniCD", strjoin(",", MSG_INFO, E.syncData), "WHISPER", sender)
	else
		SendComm(MSG_INFO_UPDATE, E.syncData)
	end
end

function Comms:Desync()
	wipe(self.syncGUIDS)
	SendComm(MSG_DESYNC, userGUID, 1)
end

function Comms:CHAT_MSG_ADDON(prefix, message, dist, sender) -- Ace strips realm if same server
--  [AC] if prefix ~= "OmniCD" or sender == E.userNameWithRealm then
	if prefix ~= "OmniCD" or sender == E.userName then
		return
	end

	local header, guid, body = strmatch(message, "(.-),(.-),(.+)")
	local info = P.groupInfo[guid]
	if not info then -- class nil in updateRoster (can't distinguish server delay from no longer in group)
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

		if E.isPreBCC then
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
					else -- backwards compatible. add snowflake if no active soulbind
						info.talentData[v] = true
					end
				elseif i == 15 then
					local covenantSpellID = covenant_IDToSpellID[v]
					if covenantSpellID then
						info.shadowlandsData.covenantID = v
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

do
	local lastPower = 0
	local isInCombat

	function Comms:UNIT_POWER_UPDATE(unit, powerType) -- fires every 2s on regen/decay (2-3 ticks)
		local powerID = POWER_TYPE_IDS[powerType]
		if powerID then
			local power = UnitPower(unit, powerID) -- doesn't return current power for others
			if power < lastPower then
				local spent = lastPower - power

				-- DONT TOUCH THIS, BROKE IT FOR THE NTH TIME!
				if isInCombat or spent > self.oocThreshold then
					local info = P.groupInfo[userGUID]
					if info and info.spellIcons[315341] then -- Between the Eyes
						self.spentPower = spent
					end
					SyncRemainingCD(userGUID, spent) -- user

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

do
	local function SendUpdatedSyncData()
		Comms:InspectPlayer()
		Comms:SendSync()
	end

	function Comms:CHARACTER_POINTS_CHANGED(change)
		if change == -1 then
			SendUpdatedSyncData()
		end
	end

	function Comms:PLAYER_SPECIALIZATION_CHANGED()
		SendUpdatedSyncData()
		self:RegisterEventUnitPower()
	end

	local timer

	local onTimerEnd = function()
		SendUpdatedSyncData()
		timer = nil
	end

	function Comms:PLAYER_EQUIPMENT_CHANGED(slotID)
		if timer or slotID > 16 then
			return
		end

		timer = C_Timer.NewTicker(0.1, onTimerEnd, 1)
	end

	Comms.COVENANT_CHOSEN = SendUpdatedSyncData
	Comms.SOULBIND_ACTIVATED = SendUpdatedSyncData
	Comms.SOULBIND_NODE_LEARNED = SendUpdatedSyncData
	Comms.SOULBIND_NODE_UNLEARNED = SendUpdatedSyncData
	Comms.SOULBIND_NODE_UPDATED = SendUpdatedSyncData
	Comms.SOULBIND_CONDUIT_INSTALLED = SendUpdatedSyncData
	Comms.SOULBIND_PATH_CHANGED = SendUpdatedSyncData
	Comms.COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED = SendUpdatedSyncData
end

Comms.PLAYER_LEAVING_WORLD = Comms.Desync -- Desync on disabling from the AddOns menu
