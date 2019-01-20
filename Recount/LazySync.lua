local Recount = _G.Recount

LibStub:GetLibrary("AceComm-3.0"):Embed(Recount)
LibStub:GetLibrary("AceSerializer-3.0"):Embed(Recount)

local revision = tonumber(string.sub("$Revision: 1472 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local pairs = pairs
local string = string
local tinsert = tinsert
local tonumber = tonumber
local type = type

local Ambiguate = Ambiguate
local GetNumGroupMembers = GetNumGroupMembers
local GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers
local GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsConnected = UnitIsConnected
local UnitIsVisible = UnitIsVisible
local UnitLevel = UnitLevel
local UnitName = UnitName

local dbCombatants

Recount.MinimumV = 1 -- Because !BugGrabber sucks!
local MinimumV = Recount.MinimumV

-- Elsia: This is straight from GUIDRegistryLib-0.1 by ArrowMaster.

local COMBATLOG_OBJECT_AFFILIATION_MINE		= COMBATLOG_OBJECT_AFFILIATION_MINE		or 0x00000001
local COMBATLOG_OBJECT_AFFILIATION_PARTY	= COMBATLOG_OBJECT_AFFILIATION_PARTY	or 0x00000002
local COMBATLOG_OBJECT_AFFILIATION_RAID		= COMBATLOG_OBJECT_AFFILIATION_RAID		or 0x00000004
local COMBATLOG_OBJECT_AFFILIATION_OUTSIDER	= COMBATLOG_OBJECT_AFFILIATION_OUTSIDER	or 0x00000008
-- Reaction
local COMBATLOG_OBJECT_REACTION_FRIENDLY	= COMBATLOG_OBJECT_REACTION_FRIENDLY	or 0x00000010
-- Ownership
local COMBATLOG_OBJECT_CONTROL_PLAYER		= COMBATLOG_OBJECT_CONTROL_PLAYER		or 0x00000100
-- Unit type
local COMBATLOG_OBJECT_TYPE_PLAYER			= COMBATLOG_OBJECT_TYPE_PLAYER			or 0x00000400
local COMBATLOG_OBJECT_TYPE_GUARDIAN		= COMBATLOG_OBJECT_TYPE_GUARDIAN		or 0x00002000

-- Setting up some useful flag combos to bootstrap synced combatants that need to be added.
local PARTY_GUARDIAN_FLAGS					= COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_REACTION_FRIENDLY + COMBATLOG_OBJECT_CONTROL_PLAYER + COMBATLOG_OBJECT_TYPE_GUARDIAN
local PARTY_PET_FLAGS						= COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_REACTION_FRIENDLY + COMBATLOG_OBJECT_CONTROL_PLAYER + COMBATLOG_OBJECT_TYPE_PET
local PARTY_GUARDIAN_OWNER_FLAGS			= COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_REACTION_FRIENDLY + COMBATLOG_OBJECT_CONTROL_PLAYER + COMBATLOG_OBJECT_TYPE_PLAYER

local event = CreateFrame("Frame")
event:RegisterEvent("GROUP_ROSTER_UPDATE")

function Recount:GroupMembersChanged()
	Recount.VerTable = { }
	Recount.VerNum = { }

	Recount:RequestVersion()
end

--local members
event:SetScript("OnEvent", function(self, event, ...)
	--if members ~= GetNumGroupMembers() then
		Recount:GroupMembersChanged()
		--members = GetNumGroupMembers()
	--end
end)

-- Bandaid for raid messages no longer failing silently, so we make it shut up.
local oldSendCommMessage = Recount.SendCommMessage
function Recount.SendCommMessage(self, a, b, channel, ...)
	--[[local _, instanceType = IsInInstance()
	if instanceType == "pvp" or instanceType == "party" then
		return
	end]] -- Disabled sync in all cross-realm content

	if channel == "RAID" and GetNumRaidMembers() > 0 then
		--Recount:DPrint("A "..a.." "..channel)
		oldSendCommMessage(self, a, b, channel, ...)
	elseif channel ~= "RAID" then
		--Recount:DPrint("B "..a.." "..channel)
		oldSendCommMessage(self, a, b, channel, ...)
	end
end

-- Elsia: Generic Sync code here
function Recount:CheckVisible()
	--[[local _ , instanceType = IsInInstance()

	if instanceType == "pvp" or instanceType == "party" then
		return
	end]] -- Disabled sync in all cross-realm content

	if IsInRaid() and GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers(), 1 do
			local unitid = "raid"..i
			if not UnitIsVisible(unitid) and UnitExists(unitid) then
				local name = UnitName(unitid)
				local combatant = dbCombatants[name]

				if not combatant then
					Recount:AddCombatant(name, nil, UnitGUID(unitid), COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_TYPE_PLAYER + COMBATLOG_OBJECT_REACTION_FRIENDLY, nil)
					combatant = dbCombatants[name]
				end

				dbCombatants[name].lazysync = true
				Recount.lazysync = true
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers(), 1 do
			local unitid = "party"..i
			if not UnitIsVisible(unitid) and UnitExists(unitid) then
				local name = UnitName(unitid)
				local combatant = dbCombatants[name]

				if not combatant then
					Recount:AddCombatant(name, nil, UnitGUID(unitid), COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_TYPE_PLAYER + COMBATLOG_OBJECT_REACTION_FRIENDLY, nil)
					combatant = dbCombatants[name]
				end

				dbCombatants[name].lazysync = true
				Recount.lazysync = true
			end
		end
	end

end

function Recount:SendSelf(target)
	-- Prepare self
	local myname = Recount.PlayerName
	local combatant = dbCombatants[myname]

	if not combatant then
		return
	end

	local serialdata
	local damage = Recount:GetLazySyncAmount(myname, myname, "Damage") or 0
	local damagetaken = Recount:GetLazySyncAmount(myname, myname, "DamageTaken") or 0
	local healing = Recount:GetLazySyncAmount(myname, myname, "Healing") or 0
	local healingtaken = Recount:GetLazySyncAmount(myname, myname, "HealingTaken") or 0
	local overhealing = Recount:GetLazySyncAmount(myname, myname, "Overhealing") or 0
	local activetime = Recount:GetLazySyncAmount(myname, myname, "ActiveTime") or 0
	serialdata = Recount:Serialize("PS", myname, myname, damage, damagetaken, healing, overhealing, healingtaken, activetime)

	-- Prepare Pets
	local data = combatant
	local serialpetdata = { }

	if data.Pet then
		for i = 1, #data.Pet do
			local petname = data.Pet[i]
			if Recount:GetLazySyncTouched(myname, petname) then
				local damage = Recount:GetLazySyncAmount(myname, petname, "Damage") or 0
				local damagetaken = Recount:GetLazySyncAmount(myname, petname, "DamageTaken") or 0
				local healing = Recount:GetLazySyncAmount(myname, petname, "Healing") or 0
				local healingtaken = Recount:GetLazySyncAmount(myname, petname, "HealingTaken") or 0
				local overhealing = Recount:GetLazySyncAmount(myname, petname, "Overhealing") or 0
				local activetime = Recount:GetLazySyncAmount(myname, petname, "ActiveTime") or 0
				if damage + damagetaken + healing + overhealing + healingtaken ~= 0 then
					tinsert(serialpetdata, Recount:Serialize("PS", myname, petname, damage, damagetaken, healing, overhealing, healingtaken, activetime))
					Recount:ClearLazySyncTouched(myname, petname)
				end
			end
		end
	end

	-- Sync self
	Recount:SendCommMessage("RECOUNT", serialdata, "WHISPER", target)
	-- Sync pets
	for i = 1, #serialpetdata do
		Recount:SendCommMessage("RECOUNT", serialpetdata[i], "WHISPER", target)
	end
end

function Recount:BroadcastLazySync()

	if not Recount.lazysync and not Recount.SyncDebug then
		return
	end -- Elsia: Nothing to lazy sync

	--[[local _ , instanceType = IsInInstance()
	if instanceType == "pvp" or instanceType == "party" then
		return
	end]] -- Disabled sync in all cross-realm content

	Recount.lazysync = false

	local validdata
	-- Prepare self
	local myname = Recount.PlayerName
	local combatant = dbCombatants[myname]

	if not combatant then
		return
	end
	--local myrecord = combatant.Sync
	local serialdata
	if Recount:GetLazySyncTouched(myname, myname) then
		local damage = Recount:GetLazySyncAmount(myname, myname, "Damage") or 0
		local damagetaken = Recount:GetLazySyncAmount(myname, myname, "DamageTaken") or 0
		local healing = Recount:GetLazySyncAmount(myname, myname, "Healing") or 0
		local healingtaken = Recount:GetLazySyncAmount(myname, myname, "HealingTaken") or 0
		local overhealing = Recount:GetLazySyncAmount(myname, myname, "Overhealing") or 0
		local activetime = Recount:GetLazySyncAmount(myname, myname, "ActiveTime") or 0
		if damage + damagetaken + healing + overhealing + healingtaken ~= 0 then
			serialdata = Recount:Serialize("PU", myname, myname, damage, damagetaken, healing, overhealing, healingtaken, activetime)
			validdata = true
			Recount:ClearLazySyncTouched(myname, myname)
		end
	end

	-- Prepare Pets
	local data = combatant
	local serialpetdata = { }

	if data and data.Pet then
		for i = 1, #data.Pet do
			--local petrecord = dbCombatants[data.Pet[i]] and dbCombatants[data.Pet[i]].Sync
			local petname = data.Pet[i]
			if Recount:GetLazySyncTouched(myname, petname) then
				local damage = Recount:GetLazySyncAmount(myname, petname, "Damage") or 0
				local damagetaken = Recount:GetLazySyncAmount(myname, petname, "DamageTaken") or 0
				local healing = Recount:GetLazySyncAmount(myname, petname, "Healing") or 0
				local healingtaken = Recount:GetLazySyncAmount(myname, petname, "HealingTaken") or 0
				local overhealing = Recount:GetLazySyncAmount(myname, petname, "Overhealing") or 0
				local activetime = Recount:GetLazySyncAmount(myname, petname, "ActiveTime") or 0
				if damage + damagetaken + healing + overhealing + healingtaken ~= 0 then
					tinsert(serialpetdata, Recount:Serialize("PU", myname, petname, damage, damagetaken, healing, overhealing, healingtaken, activetime))
					validdata = true
					Recount:ClearLazySyncTouched(myname, petname)
				end
			end
		end
	end

	-- Prepare bosses
	local serialbossdata = { }

	local plevel = dbCombatants[Recount.PlayerName].level

	if not plevel then
		plevel = UnitLevel("player")
	end

	for k, v in pairs(dbCombatants) do
		if v.type == "Boss" or (v.level and v.level > plevel + 2) then
			--local myrecord = v.Sync
			if Recount:GetLazySyncTouched(myname, k) then
				local damage = Recount:GetLazySyncAmount(myname, k, "Damage") or 0
				local damagetaken = Recount:GetLazySyncAmount(myname, k, "DamageTaken") or 0
				local healing = Recount:GetLazySyncAmount(myname, k, "Healing") or 0
				local healingtaken = Recount:GetLazySyncAmount(myname, k, "HealingTaken") or 0
				local overhealing = Recount:GetLazySyncAmount(myname, k, "Overhealing") or 0
				local activetime = Recount:GetLazySyncAmount(myname, k, "ActiveTime") or 0
				if damage + damagetaken + healing + overhealing + healingtaken ~= 0 then
					tinsert(serialbossdata, Recount:Serialize("PU", myname, k, damage, damagetaken, healing, overhealing, healingtaken, activetime))
				end
				validdata = true
				Recount:ClearLazySyncTouched(myname, k)
			end
		end
	end

	if not validdata then
		return
	end

	-- This is for testing. It'll whisper the player so you see syncs yourself.
	if Recount.SyncDebug then
		local name = Recount.PlayerName
		local combatant = dbCombatants[name]
		if combatant and combatant.lazysync or Recount.SyncDebug then
			-- Sync self
			if serialdata then
				Recount:SendCommMessage("RECOUNT", serialdata, "WHISPER", name)
			end

			-- Sync pets
			for i = 1, #serialpetdata do
				--Recount:Print("Pet"..i..": "..serialpetdata[i])
				Recount:SendCommMessage("RECOUNT", serialpetdata[i], "WHISPER", name)
			end

			-- Sync bosses
			for i = 1, #serialbossdata do
				--Recount:Print("Boss"..i..": "..serialbossdata[i])
				Recount:SendCommMessage("RECOUNT", serialbossdata[i], "WHISPER", name)
			end

			-- Done syncing, thank you very much.
			combatant.lazysync = nil
		end
	end

	if IsInRaid() and GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitExists("raid"..i) then
				local name, realm = UnitName("raid"..i)

				if Recount.VerNum and Recount.VerNum[name] and (not realm or realm == "") then -- Elsia: Only sync if we have a valid version, and on same realm

					local combatant = dbCombatants[name]
					if combatant and combatant.lazysync and name ~= Recount.PlayerName and UnitIsConnected(name) then -- We don't sync with self
						-- Sync self
						if serialdata then
							Recount:SendCommMessage("RECOUNT", serialdata, "WHISPER", name)
						end

						-- Sync pets
						for i = 1, #serialpetdata do
							Recount:SendCommMessage("RECOUNT", serialpetdata[i], "WHISPER", name)
						end

						-- Sync bosses
						for i = 1, #serialbossdata do
							Recount:SendCommMessage("RECOUNT", serialbossdata[i], "WHISPER", name)
						end
						combatant.lazysync = nil
					end
				end
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers(), 1 do
			if UnitExists("party"..i) then
				local name, realm = UnitName("party"..i)
				if Recount.VerNum and Recount.VerNum[name] and (not realm or realm == "") then -- Elsia: Only sync if we have a valid version, and on same realm
					local combatant = dbCombatants[name]
					if combatant and combatant.lazysync and name ~= Recount.PlayerName and UnitIsConnected(name) then -- We don't sync with self
						-- Sync self
						if serialdata then
							Recount:SendCommMessage("RECOUNT", serialdata, "WHISPER", name)
						end

						-- Sync pets
						for i = 1, #serialpetdata do
							--Recount:Print("Pet"..i..": "..serialpetdata[i])
							Recount:SendCommMessage("RECOUNT", serialpetdata[i], "WHISPER", name)
						end

						-- Sync bosses
						for i = 1, #serialbossdata do
							--Recount:Print("Boss"..i..": "..serialbossdata[i])
							Recount:SendCommMessage("RECOUNT", serialbossdata[i], "WHISPER", name)
						end
						combatant.lazysync = nil
					end
				end
			end
		end
	end
end

local SyncTypes = {
	["Damage"] = true,
	["DamageTaken"] = true,
	["Healing"] = true,
	["Overhealing"] = true,
	["HealingTaken"] = true,
	["ActiveTime"] = true
}

local syncin = { }

function Recount:OnCommReceive(prefix, Msgs, distribution, target)
	target = Ambiguate(target, "none")
	if distribution == "WHISPER" then
		local worked, cmd, owner, name
		worked, cmd, owner, name, syncin["Damage"], syncin["DamageTaken"], syncin["Healing"], syncin["OverHealing"], syncin["HealingTaken"], syncin["ActiveTime"] = Recount:Deserialize(Msgs)
		if worked == true then
			if cmd == "PU" then -- Player Update
				--Recount:DPrint(cmd .." "..owner.." "..name.." "..(syncin["Damage"] or "nil").." "..(syncin["DamageTaken"] or "nil").." "..(syncin["Healing"] or "nil").." "..(syncin["OverHealing"] or "nil").." "..(syncin["HealingTaken"] or "nil").." "..(syncin["ActiveTime"] or "nil"))
				if type(name) ~= "number" and (not Recount.VerNum[owner] or Recount.VerNum[owner] >= MinimumV) then
					local combatant = dbCombatants[name]
					if not combatant then
						local nameFlags
						local petowner = name:match("<(.-)>")
						if owner == name or not petowner then -- Three possibilities: owner == name is self, owner == petowner is pet, else boss
							nameFlags = PARTY_GUARDIAN_OWNER_FLAGS
						else
							nameFlags = PARTY_PET_FLAGS
						end
						Recount:AddCombatant(name, petowner and owner, nil, nameFlags, nil)
						combatant = dbCombatants[name]
					end

					local who = combatant

					for k, _ in pairs(SyncTypes) do
						local localamount = Recount:GetLazySyncAmount(owner, name, k)
						local syncamount = syncin[k]
						if syncamount and localamount and syncamount > localamount then
							--[[if localamount * 0.8 < syncamount and syncamount > 20000 then
								Recount:DPrint("Sync anomaly: "..localamount.." "..syncamount)
							else
								Recount:DPrint("Sync "..k.." for: "..syncamount-localamount)
							end]]

							Recount:AddAmount(who, k, syncamount - localamount)
							Recount:AddLazySyncAmount(owner, name, k, syncamount - localamount)
						--[[elseif syncamount and localamount and syncamount == localamount then
							Recount:DPrint("clean: "..localamount.."=="..syncamount)]]
						end
					end
				end
			elseif cmd == "PS" then -- Player data set (when first meeting up)
				--Recount:DPrint(cmd .." "..owner.." "..name.." "..(syncin["Damage"] or "nil").." "..(syncin["DamageTaken"] or "nil").." "..(syncin["Healing"] or "nil").." "..(syncin["OverHealing"] or "nil").." "..(syncin["HealingTaken"] or "nil").." "..(syncin["ActiveTime"] or "nil"))
				if type(name) ~= "number" and (not Recount.VerNum[owner] or Recount.VerNum[owner] >= MinimumV) then
					local combatant = dbCombatants[name]
					if not combatant then
						local nameFlags
						local petowner = name:match("<(.-)>")
						if owner == name or not petowner then
							nameFlags = PARTY_GUARDIAN_OWNER_FLAGS
						else
							nameFlags = PARTY_PET_FLAGS
						end
						--Recount:DPrint("Creating combatant from PS: "..name.." "..(petowner or "nil"))
						Recount:AddCombatant(name, petowner and owner, nil, nameFlags, nil) -- This could be bad.
						combatant = dbCombatants[name]
					end

					--local who = combatant

					--Recount:DPrint("PS with retention: "..name)
					for k, _ in pairs(SyncTypes) do
						local syncamount = syncin[k]
						if syncamount then -- This could be bad.
							--Recount:DPrint("PS setting: "..k)
							Recount:SetLazySyncAmount(owner, name, k, syncamount)
						else
							--Recount:DPrint("PS NOT setting: "..k)
						end
					end
				end
			elseif cmd == "VS" then -- Version Whisper
				-- owner == originator, damage == version string :D
				--local owner = name
				local version = name
				if type(version) ~= "number" then
					Recount.VerNum[owner] = tonumber(string.match(version, "Revision: (%d+)")) -- Elsia: Old format
				else
					Recount.VerNum[owner] = version
				end
				if not Recount.VerNum[owner] or Recount.VerNum[owner] < MinimumV then
					Recount.VerTable[owner] = "|cffff2020Incompatible|r "..version
				else
					Recount.VerTable[owner] = version
				end
			end
		end
	elseif distribution == "RAID" or distribution == "PARTY" or distribution == "INSTANCE_CHAT" then
		local worked, cmd, owner, pet, petGUID = Recount:Deserialize(Msgs)
		if worked == true then
			if cmd == "RS" then -- Reset broadcast
				local name = owner
				local combatant = dbCombatants[name]
				if not combatant then
					Recount:AddCombatant(name, nil, nil, COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_TYPE_PLAYER + COMBATLOG_OBJECT_REACTION_FRIENDLY, nil)
					combatant = dbCombatants[name]
				end
				--Recount:DPrint("Received RS and retaining: "..name)
				Recount:ResetLazySyncData(name)
			elseif cmd == "VS" or cmd == "VQ" then -- Version Broadcast
				-- owner == originator, pet == version string :D
				local version = pet
				--Recount:Print(cmd.." "..owner.." "..version)
				Recount.VerTable = Recount.VerTable or { } -- Elsia: This really shouldn't happen but it does!
				Recount.VerNum = Recount.VerNum or { }
				if type(version) ~= "number" then
					Recount.VerNum[owner] = tonumber(string.match(version, "Revision: (%d+)")) -- Elsia: Old format
				else
					Recount.VerNum[owner] = version
				end
				if not Recount.VerNum[owner] or Recount.VerNum[owner] < MinimumV then
					Recount.VerTable[owner] = "|cffff2020Incompatible|r "..version
				else
					Recount.VerTable[owner] = version
				end
				if cmd == "VQ" then
					Recount:SendVersion(owner) -- Return own version if requested.
				end
			end
		end
	end
end

function Recount:ConfigComm()
	Recount.VerTable = { }
	Recount.VerNum = { }

	Recount:RegisterComm("RECOUNT", "OnCommReceive")
	Recount:RequestVersion()
	if Recount.SyncDebug and GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then
		local owner = Recount.PlayerName or UnitName("player")
		local version = Recount.Version
		Recount.VerTable = Recount.VerTable or { } -- Elsia: This really shouldn't happen but it does!
		Recount.VerNum = Recount.VerNum or { }
		if type(version) ~= "number" then
			Recount.VerNum[owner] = tonumber(string.match(version, "Revision: (%d+)")) -- Elsia: Old format
		else
			Recount.VerNum[owner] = version
		end
		if not Recount.VerNum[owner] or Recount.VerNum[owner] < MinimumV then
			Recount.VerTable[owner] = "|cffff2020Incompatible|r "..version
		else
			Recount.VerTable[owner] = version
		end
	end
end

function Recount:DeleteVersion(name)
	if Recount.VerTable and Recount.VerTable[name] then
		Recount.VerTable[name] = nil
	end
	if Recount.VerNum and Recount.VerNum[name] then
		Recount.VerNum[name] = nil
	end
end

function Recount:FreeComm()
	Recount:UnregisterComm("RECOUNT")
end

function Recount:FlagSync()
	if IsInRaid() and GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitExists("raid"..i) then
				dbCombatants[UnitName("raid"..i)].lazysync = true
				Recount.lazysync = true
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers(), 1 do
			if UnitExists("party"..i) then
				dbCombatants[UnitName("party"..i)].lazysync = true
				Recount.lazysync = true
			end
		end
	end
end

function Recount:SendReset()
	if IsInRaid() and GetNumRaidMembers() > 0 then
		local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
		if inInstanceGroup then
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("RS", Recount.PlayerName), "INSTANCE_CHAT")
		else
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("RS", Recount.PlayerName), "RAID")
		end
	elseif GetNumPartyMembers() > 0 then
		local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
		if inInstanceGroup then
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("RS", Recount.PlayerName), "INSTANCE_CHAT")
		else
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("RS", Recount.PlayerName), "PARTY")
		end
	end
	Recount:ResetLazySyncData(Recount.PlayerName)
end

function Recount:ResetLazySyncData(name)
	if not Recount.VerNum then
		return
	end

	if Recount.VerNum[name] and Recount.VerNum[name] >= Recount.MinimumV and Recount.MySyncPartners and Recount.MySyncPartners[name] then
		for k, v in pairs(Recount.MySyncPartners[name]) do
			for k2, _ in pairs(v) do
				v[k2] = 0
			end
		end
	end
end

function Recount:SendVersion(target)
	if target then
		local _, realm = UnitName(target)
		if UnitIsConnected(target) and (not realm or realm == "") then
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("VS", Recount.PlayerName, Recount.Version), "WHISPER", target)
			Recount:SendSelf(target)
		end
	else
		if IsInRaid() and GetNumRaidMembers() > 0 then
			local _ , instanceType = IsInInstance()
			if instanceType == "pvp" then
				Recount:SendCommMessage("RECOUNT", Recount:Serialize("VS", Recount.PlayerName, Recount.Version), "INSTANCE_CHAT")
			else
				local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
				if inInstanceGroup then
					Recount:SendCommMessage("RECOUNT", Recount:Serialize("VS", Recount.PlayerName, Recount.Version), "INSTANCE_CHAT")
				else
					Recount:SendCommMessage("RECOUNT", Recount:Serialize("VS", Recount.PlayerName, Recount.Version), "RAID")
				end
			end
		elseif GetNumPartyMembers() > 0 then
			local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
			if inInstanceGroup then
				Recount:SendCommMessage("RECOUNT", Recount:Serialize("VS", Recount.PlayerName, Recount.Version), "INSTANCE_CHAT")
			else
				Recount:SendCommMessage("RECOUNT", Recount:Serialize("VS", Recount.PlayerName, Recount.Version), "PARTY")
			end
		end
	end
end

function Recount:RequestVersion()
	if IsInRaid() and GetNumRaidMembers() > 0 then
		local _ , instanceType = IsInInstance()
		if instanceType == "pvp" then
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("VQ", Recount.PlayerName, Recount.Version), "INSTANCE_CHAT")
		else
			local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
			if inInstanceGroup then
				Recount:SendCommMessage("RECOUNT", Recount:Serialize("VQ", Recount.PlayerName, Recount.Version), "INSTANCE_CHAT")
			else
				Recount:SendCommMessage("RECOUNT", Recount:Serialize("VQ", Recount.PlayerName, Recount.Version), "RAID")
			end
		end
	elseif GetNumPartyMembers() > 0 then
		local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
		if inInstanceGroup then
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("VQ", Recount.PlayerName, Recount.Version), "INSTANCE_CHAT")
		else
			Recount:SendCommMessage("RECOUNT", Recount:Serialize("VQ", Recount.PlayerName, Recount.Version), "PARTY")
		end
	end
end

--[[function Recount:SetSyncAmount(who, type, amount)
	who.Sync = who.Sync or { }
	who.Sync.LastChanged = GetTime()
	who.Sync[type] = amount
end]]

function Recount:SetLazySyncAmount(name, target, type, amount)
	if not Recount.VerNum then
		return
	end

	if Recount.VerNum[name] and Recount.VerNum[name] >= Recount.MinimumV then
		Recount.MySyncPartners = Recount.MySyncPartners or { }
		Recount.MySyncPartners[name] = Recount.MySyncPartners[name] or { }
		Recount.MySyncPartners[name][target] = Recount.MySyncPartners[name][target] or { }
		Recount.MySyncPartners[name][target][type] = amount
	end
end

function Recount:GetLazySyncAmount(name, target, type)
	if Recount.VerNum and Recount.MySyncPartners and Recount.VerNum[name] and Recount.VerNum[name] >= MinimumV then
		--Recount:DPrint(Recount.MySyncPartners and Recount.MySyncPartners[name] and Recount.MySyncPartners[name][target] and Recount.MySyncPartners[name][target][type] or "nil")
		return Recount.MySyncPartners and Recount.MySyncPartners[name] and Recount.MySyncPartners[name][target] and Recount.MySyncPartners[name][target][type]
	end
end

function Recount:GetLazySyncTouched(name, target)
	return Recount.MySyncPartners and Recount.MySyncPartners[name] and Recount.MySyncPartners[name][target] and Recount.MySyncPartners[name][target].Touched
end

function Recount:ClearLazySyncTouched(name, target)
	Recount.MySyncPartners = Recount.MySyncPartners or { }
	Recount.MySyncPartners[name] = Recount.MySyncPartners[name] or { }
	Recount.MySyncPartners[name][target] = Recount.MySyncPartners[name][target] or { }
	Recount.MySyncPartners[name][target].Touched = nil
end

--[[function Recount:AddAllLazySyncAmount(name, type, amount)
	if not Recount.VerNum then
		return
	end -- Noone there to sync for.

	for k, v in Recount.VerNum do
		if v >= MinimumV and k ~= name then
			Recount:AddLazySyncAmount(k, name, type, amount)
		end
	end
end]]

function Recount:AddOwnerPetLazySyncAmount(who, type, amount)
	if not Recount.MySyncPartners then
		return
	end
	if not who then
		return
	end

	if who.Name == Recount.PlayerName or Recount.MySyncPartners and Recount.MySyncPartners[who.Name] then
		--Recount:DPrint("Adding sync pool player: "..who.Name)
		Recount:AddLazySyncAmount(who.Name, who.Name, type, amount)
	elseif who.Owner == Recount.PlayerName or Recount.MySyncPartners and Recount.MySyncPartners[who.Owner] then
		--Recount:DPrint("Adding sync pool player pet: "..who.Name.." "..who.Owner)
		Recount:AddLazySyncAmount(who.Owner, who.Name.." <"..who.Owner..">", type, amount)
	elseif Recount.MySyncPartners and (who.type == "Boss" or (who.level and who.level > UnitLevel("player") + 2)) then
		--Recount:DPrint("Adding sync pool boss: "..who.Name)
		for k, v in pairs(Recount.MySyncPartners) do
			Recount:AddLazySyncAmount(k, who.Name, type, amount) -- Recount.PlayerName
		end
	end
end

function Recount:AddLazySyncAmount(name, target, type, amount)
	--Recount:DPrint(name.." "..target.." "..type.." "..amount)
	Recount.MySyncPartners = Recount.MySyncPartners or { }
	Recount.MySyncPartners[name] = Recount.MySyncPartners[name] or { }
	Recount.MySyncPartners[name][target] = Recount.MySyncPartners[name][target] or { }
	local who = Recount.MySyncPartners[name][target]
	who.Touched = true
	who[type] = who[type] or 0
	who[type] = who[type] + amount
end

--[[function Recount:AddSyncAmount(who, type, amount)
	if not who then
		return
	end

	who.Sync = who.Sync or { }
	who.Sync.LastChanged = GetTime()
	who.Sync.Touched = true
	who.Sync[type] = who.Sync[type] or 0
	who.Sync[type] = who.Sync[type] + amount
end]]

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
