local E, L, C = select(2, ...):unpack()

local strjoin = strjoin
local strsplit = strsplit
local strfind = string.find
local strmatch = string.match

local Comms = E["Comms"]
local P = E["Party"]
local soulbind_conduits_rank = E.soulbind_conduits_rank
local covenant_IDToSpellID = E.covenant_IDToSpellID
local userGUID = E.userGUID
local MSG_INFO = "INF"
local MSG_INFO_REQUEST = "REQ"
local MSG_INFO_UPDATE = "UPD"
local MSG_DESYNC = "DESYNC"
local MSG_RNG = "RNG"
E.syncData = ""

Comms.syncGUIDS = {}

local LazySyncFrame = CreateFrame("Frame")
local sync_periodic = E.sync_periodic
local SYNC_ONUPDATE_INTERVAL = 5

local function SendComm(...)
	if IsInRaid() then

		Comms:SendCommMessage(E.AddonMsgPrefix, strjoin(",", ...), (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
	elseif IsInGroup() then

		Comms:SendCommMessage(E.AddonMsgPrefix, strjoin(",", ...), (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
	end
end

function Comms:RequestSync()

	SendComm(MSG_INFO_REQUEST, E.syncData)
end

function Comms:SendSync(sender)
	if E.syncData == "" then
		self:InspectPlayer()
	end

	if sender then

		self:SendCommMessage(E.AddonMsgPrefix, strjoin(",", MSG_INFO, E.syncData), "WHISPER", sender)
	else
		SendComm(MSG_INFO_UPDATE, E.syncData)
	end
end

function Comms:Desync()
	wipe(self.syncGUIDS)
	LazySyncFrame:Hide()
	SendComm(MSG_DESYNC, userGUID, 1)
end


function Comms:GetNumSyncMembers()
	local c = 0;
	for k in pairs(self.syncGUIDS) do
		c = c + 1;
	end
	return c;
end

function Comms:ToggleLazySync()
	if ( E.isPreBCC ) then
		return;
	end

	if ( next(E.lazySyncData) and P.disabled == false and (not P.isUserDisabled or next(self.syncGUIDS)) ) then
		SYNC_ONUPDATE_INTERVAL = P.zone == "raid" and 5 or math.min(self:GetNumSyncMembers() + 1, 5);
		if ( not LazySyncFrame.isShown ) then
			LazySyncFrame:Show();
		end
	elseif ( LazySyncFrame.isShown ) then
		LazySyncFrame:Hide();
	end
end

if ( not E.isPreBCC ) then

	function Comms:SyncLazyCDR(guid, cdstr)
		local info = P.groupInfo[guid];
		if ( not info ) then
			return;
		end

		local now = GetTime();
		while ( cdstr ) do
			local spellID, duration, cdLeft, modRate, charges, rest = strsplit(":", cdstr, 6);
			spellID, charges = tonumber(spellID), tonumber(charges);
			cdstr = rest;
			if ( spellID and cdLeft ) then
				local icon = info.spellIcons[spellID];
				if ( icon ) then
					local active = icon.active and info.active[spellID];
					if ( active ) then
						local startTime = now + cdLeft - duration;
						icon.cooldown:SetCooldown(startTime, duration, modRate);
						active.startTime = now + cdLeft - duration;
						active.duration = duration;
						local statusBar = icon.statusBar;
						if ( statusBar ) then
							P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE");
						end
						if ( charges >= 0 and icon.maxcharges and charges ~= active.charges ) then
							icon.Count:SetText(charges);
							active.charges = charges;
							icon.cooldown:SetDrawSwipe(false);
							icon.cooldown:SetHideCountdownNumbers(true);
						end
					end
				end
			end
		end
	end








	local function GetCooldownFix(spellID)
		local start, duration, enabled, modRate = GetSpellCooldown(spellID);
		local currentCharges, maxCharges, cooldownStart, cooldownDuration, chargeModRate = GetSpellCharges(spellID);
		local charges = maxCharges and maxCharges > 1 and currentCharges or -1;
		if ( enabled == 1 ) then
			if ( start and start > 0 ) then
				if ( duration < 1.5 ) then
					return nil;
				elseif ( currentCharges and currentCharges > 0 ) then
					return nil;
				end
				return start, duration, modRate, charges;
			elseif ( maxCharges and maxCharges > currentCharges ) then
				return cooldownStart, cooldownDuration, modRate, charges;
			end
		end
		return 0, 0, 1, charges;
	end

	local elapsedTime = 0;

	local function LazySyncFrame_OnUpdate(self, elapsed)
		elapsedTime = elapsedTime + elapsed;

		if ( elapsedTime > SYNC_ONUPDATE_INTERVAL ) then
			local lazySyncData = E.lazySyncData;
			local now = GetTime();
			local cdstr = {};

			for id, t in pairs(lazySyncData) do
				local start, duration, modRate, charges = GetCooldownFix(id);
				if ( start ) then
					local prevStart, prevCharges = t[1], t[2];
					local isForceUpdate = sync_periodic[id];
					if ( duration == 0 ) then


						if ( prevStart ~= 0 or isForceUpdate ) then
							lazySyncData[id][1] = start;
							lazySyncData[id][2] = charges;
							cdstr[#cdstr + 1] = id;
							cdstr[#cdstr + 1] = 0;
							cdstr[#cdstr + 1] = 0;
							cdstr[#cdstr + 1] = 1;
							cdstr[#cdstr + 1] = charges;
						end
					else



						if ( math.abs(start - prevStart) > 0.5 or (charges >= 0 and charges > prevCharges) or isForceUpdate ) then
							lazySyncData[id][1] = start;
							lazySyncData[id][2] = charges;

							local cdLeft = start + duration - now;
							cdLeft = string.format("%.1f", cdLeft);
							cdstr[#cdstr + 1] = id;
							cdstr[#cdstr + 1] = duration;
							cdstr[#cdstr + 1] = cdLeft;
							cdstr[#cdstr + 1] = modRate;
							cdstr[#cdstr + 1] = charges;
						elseif ( start == prevStart and charges >= 0 and charges < prevCharges ) then
							lazySyncData[id][2] = charges;
						end
					end
				end
			end

			if ( #cdstr > 0 ) then
				cdstr = table.concat(cdstr, ":")
				if ( not P.isUserDisabled ) then
					Comms:SyncLazyCDR(userGUID, cdstr);
				end
				if ( next(Comms.syncGUIDS) ) then
					SendComm(MSG_RNG, userGUID, cdstr);
				end
			end

			elapsedTime = 0;
		end
	end

	LazySyncFrame:Hide();
	local lazySyncFrame_OnShow = function() LazySyncFrame.isShown = true; end
	local lazySyncFrame_OnHide = function() LazySyncFrame.isShown = false; end
	LazySyncFrame:SetScript("OnShow", lazySyncFrame_OnShow);
	LazySyncFrame:SetScript("OnHide", lazySyncFrame_OnHide);
	LazySyncFrame:SetScript("OnUpdate", LazySyncFrame_OnUpdate);
end

function Comms:CHAT_MSG_ADDON(prefix, message, dist, sender)

	if prefix ~= E.AddonMsgPrefix or sender == E.userName then
		return
	end

	local header, guid, body = strmatch(message, "(.-),(.-),(.+)")
	local info = P.groupInfo[guid]
	if not info then
		return
	end

	local isSyncedUnit = self.syncGUIDS[guid]
	if ( header == MSG_RNG ) then
		if ( isSyncedUnit ) then
			self:SyncLazyCDR(guid, body);
		end
		return;
	elseif header == MSG_INFO_REQUEST then
		self:SendSync(sender)
	elseif header == MSG_INFO_UPDATE then
		if not isSyncedUnit then
			return
		end
	elseif header == MSG_DESYNC then
		if isSyncedUnit then
			self.syncGUIDS[guid] = nil
		end
		self:ToggleLazySync()
		return
	end

	info.talentData = {}
	info.invSlotData = {}
	info.shadowlandsData = {}

	if E.isPreBCC then
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
		end
	else
		while ( body ) do
			local t, rest = strsplit("|", body, 2);
			body = rest;

			local k, v = strsplit(",", t, 2);
			if ( k == "T" ) then
				while ( v ) do
					local id, idlist = strsplit(",", v, 2);
					v = idlist;
					id = tonumber(id);
					if ( id ) then
						if ( id < 0 ) then
							info.talentData[-id] = "PVP";
						else
							info.talentData[id] = true;
						end
					end
				end
			elseif ( k == "E" ) then
				while ( v ) do
					local id, idlist = strsplit(",", v, 2);
					v = idlist;
					id = tonumber(id);
					if ( id ) then
						info.invSlotData[id] = true;
					end
				end
			elseif ( k == "C" ) then
				local covenantID, soulbindID, conduits = strsplit(",", v, 3)
				covenantID = tonumber(covenantID)
				soulbindID = tonumber(soulbindID)
				local covenantSpellID = covenant_IDToSpellID[covenantID]
				info.shadowlandsData.covenantID = covenantSpellID
				info.shadowlandsData.soulbindID = soulbindID
				info.talentData[covenantSpellID] = "C"
				while ( conduits ) do
					local id, idlist = strsplit(",", conduits, 2);
					conduits = idlist;
					local conduitSpellID, rankValue = strsplit("-", id)
					conduitSpellID = tonumber(conduitSpellID)
					rankValue = tonumber(rankValue)
					if rankValue then
						info.talentData[conduitSpellID] = rankValue
					elseif conduitSpellID then
						info.talentData[conduitSpellID] = 0
					end
				end
			else
				info.spec = tonumber(k);
				local ver = strsplit(",", v);
				info.version = tonumber(ver)
			end
		end
	end

	local unit = info.unit
	if info.level == 200 then
		local lvl = UnitLevel(unit)
		info.level = lvl > 0 and lvl or 200
	end
	if info.name == "Unknown" then
		info.name = GetUnitName(unit, true)
	end

	self.syncGUIDS[guid] = true
	self:DequeueInspect(guid)

	P:UpdateUnitBar(guid)

	self:ToggleLazySync()
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

	function Comms:PLAYER_SPECIALIZATION_CHANGED(unit)
		SendUpdatedSyncData()
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


Comms.PLAYER_LEAVING_WORLD = Comms.Desync
