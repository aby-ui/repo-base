local _, private = ...

local isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)

local module = private:NewModule("DevTools")

function module:OnModuleLoad()
	self:OnDebugToggle()
end

do
	--Debug Mode
	local eventsRegistered = false
	local UnitName, UnitExists = UnitName, UnitExists
	function module:UNIT_TARGETABLE_CHANGED(uId)
		local transcriptor = _G["Transcriptor"]
		if DBM.Options.DebugLevel > 2 or (transcriptor and transcriptor:IsLogging()) then
			local active = UnitExists(uId) and "true" or "false"
			self:Debug("UNIT_TARGETABLE_CHANGED event fired for "..UnitName(uId)..". Active: "..active)
		end
	end

	function module:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
		local spellName = DBM:GetSpellInfo(spellId)
		self:Debug("UNIT_SPELLCAST_SUCCEEDED fired: "..UnitName(uId).."'s "..spellName.."("..spellId..")", 3)
	end

	--Spammy events that core doesn't otherwise need are now dynamically registered/unregistered based on whether or not user is actually debugging
	function module:OnDebugToggle()
		if DBM.Options.DebugMode and not eventsRegistered then
			eventsRegistered = true
			if isRetail then
				self:RegisterShortTermEvents("UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5", "UNIT_TARGETABLE_CHANGED")
			else--No Boss unit Ids in classic, register backups
				self:RegisterShortTermEvents("UNIT_SPELLCAST_SUCCEEDED target focus", "UNIT_TARGETABLE_CHANGED")
			end
		elseif not DBM.Options.DebugMode and eventsRegistered then
			eventsRegistered = false
			self:UnregisterShortTermEvents()
		end
	end

	function module:Debug(text, level)
		--But we still want to generate callbacks for level 1 and 2 events
		if DBM.Options.DebugLevel == 3 or (level or 1) < 3 then--Cap debug level to 2 for trannscriptor unless user specifically specifies 3
			DBM:FireEvent("DBM_Debug", text, level)
		end
		if not DBM.Options or not DBM.Options.DebugMode then return end
		if (level or 1) <= DBM.Options.DebugLevel then
			local frame = _G[tostring(DBM.Options.ChatFrame)]
			frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
			frame:AddMessage("|cffff7d0aDBM Debug:|r "..text, 1, 1, 1)
		end
	end
end

do
	--To speed up creating new mods.
	local EJ_SetDifficulty, EJ_GetEncounterInfoByIndex = EJ_SetDifficulty, EJ_GetEncounterInfoByIndex
	function module:FindDungeonMapIDs(low, peak, contains)
		local start = low or 1
		local range = peak or 4000
		DBM:AddMsg("-----------------")
		for i = start, range do
			local dungeon = GetRealZoneText(i)
			if dungeon and dungeon ~= "" then
				if not contains or contains and dungeon:find(contains) then
					DBM:AddMsg(i..": "..dungeon)
				end
			end
		end
	end

	function module:FindInstanceIDs(low, peak, contains)
		local start = low or 1
		local range = peak or 3000
		DBM:AddMsg("-----------------")
		for i = start, range do
			local instance = EJ_GetInstanceInfo(i)
			if instance then
				if not contains or contains and instance:find(contains) then
					DBM:AddMsg(i..": "..instance)
				end
			end
		end
	end

	function module:FindScenarioIDs(low, peak, contains)
		local start = low or 1
		local range = peak or 3000
		DBM:AddMsg("-----------------")
		for i = start, range do
			local instance = DBM:GetDungeonInfo(i)
			if instance and (not contains or contains and instance:find(contains)) then
				DBM:AddMsg(i..": "..instance)
			end
		end
	end

	--/run DBM:FindEncounterIDs(1192)--Shadowlands
	--/run DBM:FindEncounterIDs(1178, 23)--Dungeon Template (mythic difficulty)
	--/run DBM:FindEncounterIDs(237, 1)--Classic Dungeons need diff 1 specified
	--/run DBM:FindDungeonMapIDs(1, 500)--Find Classic Dungeon Map IDs
	--/run DBM:FindInstanceIDs(1, 300)--Find Classic Dungeon Journal IDs
	function module:FindEncounterIDs(instanceID, diff)
		if not instanceID then
			DBM:AddMsg("Error: Function requires instanceID be provided")
		end
		if not isRetail then
			DBM:AddMsg("Error: There is no Dungeon Journal in classic")
		end
		if not diff then diff = 14 end--Default to "normal" in 6.0+ if diff arg not given.
		EJ_SetDifficulty(diff)--Make sure it's set to right difficulty or it'll ignore mobs (ie ra-den if it's not set to heroic). Use user specified one as primary, with curernt zone difficulty as fallback
		DBM:AddMsg("-----------------")
		for i=1, 25 do
			local name, _, encounterID = EJ_GetEncounterInfoByIndex(i, instanceID)
			if name then
				DBM:AddMsg(encounterID..": "..name)
			end
		end
	end
end

--Taint the script that disables /run /dump, etc
--ScriptsDisallowedForBeta = function() return false end
