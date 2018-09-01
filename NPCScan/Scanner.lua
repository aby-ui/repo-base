-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Functions
local pairs = _G.pairs
local time = _G.time

-- Libraries
local table = _G.table

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data
local Enum = private.Enum
local EventMessage = private.EventMessage


local LibStub = _G.LibStub
local HereBeDragons = LibStub("HereBeDragons-2.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local NPCScan = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local ProcessDetection
do
	local throttledNPCs = {}

	function ProcessDetection(detectionData)
		local npcID = detectionData.npcID
		local profile = private.db.profile
		local detection = profile.detection
		local throttleTime = throttledNPCs[npcID]
		local now = time()

		if not Data.Scanner.NPCs[npcID] or (throttleTime and now < throttleTime + detection.intervalSeconds) or (not detection.whileOnTaxi and _G.UnitOnTaxi("player")) then
			return
		end

		throttledNPCs[npcID] = now

		detectionData.npcName = detectionData.npcName or NPCScan:GetNPCNameFromID(npcID)
		detectionData.unitClassification = detectionData.unitClassification or "rare"

		NPCScan:Pour(_G.ERR_ZONE_EXPLORED:format(("%s %s"):format(detectionData.npcName, _G.PARENS_TEMPLATE:format(detectionData.sourceText))), 0, 1, 0)
		NPCScan:DispatchSensoryCues()
		NPCScan:SendMessage(EventMessage.DetectedNPC, detectionData)

		-- TODO: Make the Overlays object listen for the DetectedNPC message and run its own methods
		private.Overlays.Found(npcID)
		private.Overlays.Remove(npcID)
	end
end

local function ProcessUnit(unitToken, sourceText)
	if _G.UnitIsUnit("player", unitToken) then
		return
	end

	local npcID = private.UnitTokenToCreatureID(unitToken)

	if npcID then
		local unitIsDead = _G.UnitIsDead(unitToken)

		if private.db.profile.detection.ignoreDeadNPCs and unitIsDead then
			return
		end

		local detectionData = {
			isDead = unitIsDead,
			npcID = npcID,
			npcName = _G.UnitName(unitToken),
			sourceText = sourceText,
			unitClassification = _G.UnitClassification(unitToken),
			unitCreatureType = _G.UnitCreatureType(unitToken),
			unitLevel = _G.UnitLevel(unitToken),
			unitToken = unitToken,
		}

		ProcessDetection(detectionData)

		NPCScan:SendMessage(EventMessage.UnitInformationAvailable, detectionData)
	end
end

local function CanAddToScanList(npcID)
	local profile = private.db.profile

	if profile.blacklist.npcIDs[npcID] then
		private.Debug("Skipping %s (%d) - blacklisted.", NPCScan:GetNPCNameFromID(npcID), npcID)
		return false
	end

	local npc = Data.NPCs[npcID]

	if npc then
		if npc.factionGroup == _G.UnitFactionGroup("player") then
			return false
		end

		local isTameable = npc.isTameable
		local detection = profile.detection

		if isTameable and not detection.tameables then
			return false
		end

		if not isTameable and not detection.rares then
			return false
		end

		local isquestCompleted = private.IsNPCQuestComplete(npc)

		if not npc.questID or isquestCompleted then
			local achievementID = npc.achievementID

			if achievementID then
				if detection.achievementIDs[achievementID] == Enum.DetectionGroupStatus.Disabled then
					return false
				end

				if detection.ignoreCompletedAchievementCriteria and private.IsNPCAchievementCriteriaComplete(npc) then
					return false
				end
			end
		end

		if isquestCompleted and detection.ignoreCompletedQuestObjectives then
			return false
		end
	end

	return true
end

local function MergeUserDefinedWithScanList(npcList)
	if npcList and private.db.profile.detection.userDefined then
		for npcID in pairs(npcList) do
			Data.Scanner.NPCs[npcID] = {}
		end
	end
end

function NPCScan:UpdateScanList(_, mapID)
	local scannerData = Data.Scanner
	mapID = mapID or HereBeDragons:GetPlayerZone()

	if not mapID or mapID < 0 then
		return
	end

	scannerData.mapID = mapID
	scannerData.continentID = Data.Maps[mapID].continentID

	for npcID in pairs(scannerData.NPCs) do
		private.Overlays.Remove(npcID)
	end

	table.wipe(scannerData.NPCs)
	scannerData.NPCCount = 0

	local profile = private.db.profile
	local userDefined = profile.userDefined

	-- No zone or continent specified, so always look for these.
	MergeUserDefinedWithScanList(userDefined.npcIDs)

	if profile.blacklist.mapIDs[scannerData.mapID] or profile.detection.continentIDs[scannerData.continentID] == Enum.DetectionGroupStatus.Disabled then
		private.Debug("continentID or mapID is blacklisted; terminating update.")
		self:SendMessage(EventMessage.ScannerDataUpdated, scannerData)

		return
	end

	local zoneNPCCount = 0
	local npcList = Data.Maps[scannerData.mapID].NPCs

	if npcList then
		for npcID in pairs(npcList) do
			if CanAddToScanList(npcID) then
				zoneNPCCount = zoneNPCCount + 1;
				scannerData.NPCs[npcID] = Data.NPCs[npcID]

				private.Overlays.Add(npcID)
			end
		end

		scannerData.NPCCount = zoneNPCCount
	end

	MergeUserDefinedWithScanList(userDefined.continentNPCs[scannerData.continentID])
	MergeUserDefinedWithScanList(userDefined.mapNPCs[scannerData.mapID])

	self:SendMessage(EventMessage.ScannerDataUpdated, scannerData)
end

-- ----------------------------------------------------------------------------
-- Events.
-- ----------------------------------------------------------------------------
local function UpdateScanListAchievementCriteria()
	local needsUpdate = false

	for _, npc in pairs(Data.Scanner.NPCs) do
		if npc.achievementID and npc.achievementCriteriaID and not private.IsNPCAchievementCriteriaComplete(npc) then
			local _, _, isCompleted = _G.GetAchievementCriteriaInfoByID(npc.achievementID, npc.achievementCriteriaID)

			if isCompleted then
				npc.isCriteriaCompleted = isCompleted

				private.GetOrUpdateNPCOptions()

				if private.db.profile.detection.ignoreCompletedAchievementCriteria then
					needsUpdate = true
				end
			end
		end
	end

	if needsUpdate then
		NPCScan:UpdateScanList()
	end
end

private.UpdateScanListAchievementCriteria = UpdateScanListAchievementCriteria

local function UpdateScanListQuestObjectives()
	local needsUpdate = false

	if private.db.profile.detection.ignoreCompletedQuestObjectives then
		local NPCs = Data.Scanner.NPCs

		for npcID in pairs(NPCs) do
			if private.IsNPCQuestComplete(NPCs[npcID]) then
				needsUpdate = true
			end
		end

		if needsUpdate then
			NPCScan:UpdateScanList()
		end
	end
end

private.UpdateScanListQuestObjectives = UpdateScanListQuestObjectives

function NPCScan:ACHIEVEMENT_EARNED(_, achievementID)
	if Data.Achievements[achievementID] then
		Data.Achievements[achievementID].isCompleted = true

		if private.db.profile.detection.ignoreCompletedAchievementCriteria then
			-- Disable tracking for the achievement, since the above setting implies it.
			private.db.profile.detection.achievementIDs[achievementID] = Enum.DetectionGroupStatus.Disabled
		end

		UpdateScanListAchievementCriteria()
	end
end

function NPCScan:CRITERIA_UPDATE()
	UpdateScanListAchievementCriteria()
end

-- Apparently some vignette NPC daily quests are only flagged as complete after looting...
function NPCScan:LOOT_CLOSED()
	UpdateScanListQuestObjectives()
end

function NPCScan:NAME_PLATE_UNIT_ADDED(_, unitToken)
	ProcessUnit(unitToken, _G.UNIT_NAMEPLATES)
end

function NPCScan:PLAYER_ENTERING_WORLD()
	self:UpdateScanList("PLAYER_ENTERING_WORLD", _G.C_Map.GetBestMapForUnit("player"))
end

function NPCScan:PLAYER_TARGET_CHANGED()
	ProcessUnit("target", _G.TARGET)
end

function NPCScan:UPDATE_MOUSEOVER_UNIT()
	local mouseoverID = private.UnitTokenToCreatureID("mouseover")

	if mouseoverID ~= private.UnitTokenToCreatureID("target") then
		ProcessUnit("mouseover", _G.MOUSE_LABEL)
	end
end

do
	local VIGNETTE_SOURCE_TO_PREFERENCE = {
		[_G.MINIMAP_LABEL] = "ignoreMiniMap",
		[_G.WORLD_MAP] = "ignoreWorldMap",
	}

	local function IsIgnoringSource(sourceText)
		return private.db.profile.detection[VIGNETTE_SOURCE_TO_PREFERENCE[sourceText]]
	end

	local function ProcessVignetteGUID(vignetteGUID)
		if not vignetteGUID then
			return
		end

		local vignetteInfo = _G.C_VignetteInfo.GetVignetteInfo(vignetteGUID);

		if not vignetteInfo or vignetteInfo.atlasName == "VignetteLoot" then
			return
		end

		local sourceText = vignetteInfo.onWorldMap and _G.WORLD_MAP or _G.MINIMAP_LABEL

		if IsIgnoringSource(sourceText) then
			return
		end

		local vignetteName = vignetteInfo.name
		local vignetteNPCs = private.VignetteIDToNPCMapping[vignetteInfo.vignetteID]

		if vignetteNPCs then
			for index = 1, #vignetteNPCs do
				local vignetteNPC = vignetteNPCs[index]

				if Data.Scanner.NPCs[vignetteNPC.npcID] then
					ProcessDetection({
						npcID = vignetteNPC.npcID,
						sourceText = sourceText,
						vignetteName = vignetteName,
					})
				end
			end

			return
		else
			private.Debug("Unknown vignette: %s - vignetteID %d (NPC ID %d) in mapID %d", vignetteInfo.name, vignetteInfo.vignetteID, npcID or -1, _G.C_Map.GetBestMapForUnit("player"))
		end

		local npcID = private.GUIDToCreatureID(vignetteInfo.objectGUID)

		-- The objectGUID can be but isn't always an NPC ID, since some NPCs must be summoned from the vignette object.
		if npcID and Data.Scanner.NPCs[npcID] then
			ProcessDetection({
				npcID = npcID,
				sourceText = sourceText,
				vignetteName = vignetteName,
			})

			return
		end

		local questID = private.QuestIDFromName[vignetteName]

		if questID then
			for questNPCID in pairs(private.QuestNPCs[questID]) do
				ProcessDetection({
					npcID = questNPCID,
					sourceText = sourceText,
					vignetteName = vignetteName,
				})
			end

			return
		elseif sourceText == _G.WORLD_MAP then
			return
		end

		npcID = private.NPCIDFromName[vignetteName]

		if npcID then
			ProcessDetection({
				npcID = npcID,
				sourceText = sourceText,
				vignetteName = vignetteName,
			})

			return
		end
	end

	function NPCScan:VIGNETTE_MINIMAP_UPDATED(_, vignetteGUID)
		ProcessVignetteGUID(vignetteGUID)
	end

	function NPCScan:VIGNETTES_UPDATED()
		local vignetteGUIDs = _G.C_VignetteInfo.GetVignettes()

		for index = 1, #vignetteGUIDs do
			ProcessVignetteGUID(vignetteGUIDs[index])
		end
	end
end -- do-block

-- ----------------------------------------------------------------------------
-- Sensory cues.
-- ----------------------------------------------------------------------------
do
	local MAX_FLASH_LOOPS = 3

	local flashFrame = _G.CreateFrame("Frame")
	flashFrame:Hide()
	flashFrame:SetAllPoints()
	flashFrame:SetAlpha(0)
	flashFrame:SetFrameStrata("FULLSCREEN_DIALOG")

	local flashTexture = flashFrame:CreateTexture()
	flashTexture:SetBlendMode("ADD")
	flashTexture:SetAllPoints()

	local fadeAnimationGroup = flashFrame:CreateAnimationGroup()
	fadeAnimationGroup:SetLooping("BOUNCE")

	fadeAnimationGroup:SetScript("OnLoop", function(self, loopState)
		if loopState == "FORWARD" then
			self.LoopCount = self.LoopCount + 1

			if self.LoopCount >= MAX_FLASH_LOOPS then
				self:Stop()
				flashFrame:Hide()
			end
		end
	end)

	fadeAnimationGroup:SetScript("OnPlay", function(self)
		self.LoopCount = 0
	end)

	local fadeAnimIn = private.CreateAlphaAnimation(fadeAnimationGroup, 0, 1, 0.5)
	fadeAnimIn:SetEndDelay(0.25)

	local ALERT_SOUND_THROTTLE_INTERVAL_SECONDS = 2
	local lastSoundTime = time()

	function NPCScan:PlayFlashAnimation(texturePath, color)
		flashTexture:SetTexture(LibSharedMedia:Fetch("background", texturePath))
		flashTexture:SetVertexColor(color.r, color.g, color.b, color.a)
		flashFrame:Show()

		fadeAnimationGroup:Pause() -- Forces OnPlay to fire again if it was already playing
		fadeAnimationGroup:Play()
	end

	local PlayAlertSounds
	do
		local SOUND_RESTORE_INTERVAL_SECONDS = 5
		local soundsAreOverridden

		local StoredSoundCVars = {}
		local SoundChannelCVars = {
			Ambience = "Sound_EnableAmbience",
			Master = "Sound_EnableAllSound",
			Music = "Sound_EnableMusic",
			SFX = "Sound_EnableSFX",
		}

		local function ResetStoredSoundCVars()
			for cvar, value in pairs(StoredSoundCVars) do
				_G.SetCVar(cvar, value)
			end

			soundsAreOverridden = nil
		end

		function PlayAlertSounds(overrideSoundCVars)
			local soundPreferences = private.db.profile.alert.sound

			if overrideSoundCVars and not soundsAreOverridden then
				local channelCVar = SoundChannelCVars[soundPreferences.channel]

				StoredSoundCVars[channelCVar] = _G.GetCVar(channelCVar)
				_G.SetCVar(channelCVar, 1)

				StoredSoundCVars.Sound_EnableSoundWhenGameIsInBG = _G.GetCVar("Sound_EnableSoundWhenGameIsInBG")
				_G.SetCVar("Sound_EnableSoundWhenGameIsInBG", 1)

				soundsAreOverridden = true
				NPCScan:ScheduleTimer(ResetStoredSoundCVars, SOUND_RESTORE_INTERVAL_SECONDS)
			end

			for soundName in pairs(soundPreferences.sharedMediaNames) do
				if soundPreferences.sharedMediaNames[soundName] ~= false then
					_G.PlaySoundFile(LibSharedMedia:Fetch("sound", soundName), soundPreferences.channel)
				end
			end
		end

		private.PlayAlertSounds = PlayAlertSounds
	end

	function NPCScan:DispatchSensoryCues()
		local alert = private.db.profile.alert
		local now = time()

		if alert.screenFlash.isEnabled then
			self:PlayFlashAnimation(alert.screenFlash.texture, alert.screenFlash.color)
		end

		if alert.sound.isEnabled and now > lastSoundTime + ALERT_SOUND_THROTTLE_INTERVAL_SECONDS then
			PlayAlertSounds(alert.sound.ignoreMute)

			lastSoundTime = now
		end
	end
end
