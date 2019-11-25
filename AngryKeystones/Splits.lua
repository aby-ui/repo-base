local ADDON, Addon = ...
local Mod = Addon:NewModule('Splits')

local challengeMapID

local function GetElapsedTime()
	for i = 1, select("#", GetWorldElapsedTimers()) do
		local timerID = select(i, GetWorldElapsedTimers())
		local _, elapsedTime, type = GetWorldElapsedTime(timerID)
		if type == LE_WORLD_ELAPSED_TIMER_TYPE_CHALLENGE_MODE then
			return elapsedTime
		end
	end
end

local function UpdateSplits(self, numCriteria, objectiveBlock, addObjectives)
	local scenarioType = select(10, C_Scenario.GetInfo())
	if not self:ShouldShowCriteria() or not Mod.splits or not Mod.splitNames or scenarioType ~= LE_SCENARIO_TYPE_CHALLENGE_MODE then return end
	if not SCENARIO_TRACKER_MODULE or not objectiveBlock or not objectiveBlock.lines then return end

	for criteriaIndex, elapsed in ipairs(Mod.splits) do
		local criteriaString = Mod.splitNames[criteriaIndex]
		local completed = elapsed ~= false

		if elapsed and elapsed ~= true and criteriaString then
			if Addon.Config.splitsFormat == 2 and criteriaIndex ~= #Mod.splits then
				local prev = 0
				for i, e in ipairs(Mod.splits) do
					if e and e ~= true and e < elapsed and e > prev and i ~= #Mod.splits then
						prev = e
					end
				end

				local split = elapsed - prev
				criteriaString = string.format("%s, +%s", criteriaString, Addon.ObjectiveTracker.timeFormat(split))
			elseif Addon.Config.splitsFormat == 1 or (Addon.Config.splitsFormat == 2 and criteriaIndex == #Mod.splits) then
				criteriaString = string.format("%s, %s", criteriaString, Addon.ObjectiveTracker.timeFormat(elapsed))
			end
		end
		if criteriaIndex ~= #Mod.splits then
			criteriaString = string.format("%d/%d %s", completed and 1 or 0, 1, criteriaString)
		end

		if addObjectives then
			SCENARIO_TRACKER_MODULE.lineSpacing = 12;
			if ( completed ) then
				local existingLine = objectiveBlock.lines[criteriaIndex];
				SCENARIO_TRACKER_MODULE:AddObjective(objectiveBlock, criteriaIndex, criteriaString, nil, nil, OBJECTIVE_DASH_STYLE_SHOW, OBJECTIVE_TRACKER_COLOR["Complete"]);
				objectiveBlock.currentLine.Icon:Show();
				objectiveBlock.currentLine.Icon:SetAtlas("Tracker-Check", true);
				objectiveBlock.currentLine.completed = true;
			else
				SCENARIO_TRACKER_MODULE:AddObjective(objectiveBlock, criteriaIndex, criteriaString);
				objectiveBlock.currentLine.Icon:Show();
				objectiveBlock.currentLine.Icon:SetAtlas("Objective-Nub", true);
			end
		else
			local line = objectiveBlock.lines[criteriaIndex]
			if line then
				local old_height = line:GetHeight()
				local height = SCENARIO_TRACKER_MODULE:SetStringText(line.Text, criteriaString, nil, completed and OBJECTIVE_TRACKER_COLOR["Complete"], objectiveBlock.isHighlighted)
				line:SetHeight(height)
				if old_height ~= height then
					objectiveBlock.height = objectiveBlock.height + height - old_height
				end
			end
		end
	end
end
Mod.UpdateSplits = UpdateSplits

function Mod:SplitOutput()
	if Addon.Config.splitsFormat == 0 then return end

	local splitStrs = {}
	for index, elapsed in ipairs(Mod.splits) do
		if elapsed and elapsed ~= true then
			if Addon.Config.splitsFormat == 2 then
				local prev = 0
				for i, e in ipairs(Mod.splits) do
					if e and e ~= true and e < elapsed and e > prev and i ~= #Mod.splits then
						prev = e
					end
				end
				local split = elapsed - prev
				table.insert(splitStrs, string.format("%s +%s", Mod.splitNames[index], Addon.ObjectiveTracker.timeFormat(split)))
			elseif Addon.Config.splitsFormat == 1 or (Addon.Config.splitsFormat == 2 and index == #Mod.splits) then
				table.insert(splitStrs, string.format("%s %s", Mod.splitNames[index], Addon.ObjectiveTracker.timeFormat(elapsed)))
			end
		end
	end
	return table.concat(splitStrs, ", ")
end

function Mod:CHALLENGE_MODE_RESET()
	Mod.splits = nil
	Mod.splitNames = nil
	Mod.mapVariation = nil
	AngryKeystones_Data.state.splits = nil
	AngryKeystones_Data.state.splitNames = nil
	AngryKeystones_Data.state.mapID = nil
end

local function ArcwayMapVariation()
	local ret

	local curMapID, curFloor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
	SetMapToCurrentZone()
	local numPOIs = GetNumMapLandmarks()
	for i=1, numPOIs do
		local _, _, _, _, x, y, _, _, _, _, _, _, atlasIcon = GetMapLandmarkInfo(i)
		x, y = tostring(x), tostring(y)
		if atlasIcon == "map-icon-SuramarDoor.tga" then
			if x == "0.42697441577911" and y == "0.35995090007782" then -- Left Path
				ret = "left"
			end
			if x == "0.53354382514954" and y == "0.35967540740967" then -- Right Path
				ret = "right"
			end
		end
	end
	SetMapByID(curMapID)
	if curFloor then SetDungeonMapLevel(curFloor) end

	return ret
end

function Mod:CHALLENGE_MODE_COMPLETED()
	if not challengeMapID then return end
	local mapID, level, timeElapsed, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
	local name, _, timeLimit = C_ChallengeMode.GetMapUIInfo(challengeMapID)
	local _, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()
	local splits = Mod.splits

	local missingCount = 0
	for index,elapsed in pairs(splits) do
		if elapsed == false then
			splits[index] = floor(timeElapsed / 1000)
			missingCount = missingCount + 1
		elseif elapsed == true then
			missingCount = missingCount + 1
		end
	end

	splits.date = time()
	splits.level = level
	splits.mapID = mapID
	splits.wasEnergized = wasEnergized
	splits.timeElapsed = timeElapsed / 1000
	splits.timeLimit = timeLimit
	splits.affixes1 = affixes[1]
	splits.affixes2 = affixes[2]
	splits.affixes3 = affixes[3]
	splits.mapVariation = Mod.mapVariation
	splits.patch = GetBuildInfo()

	local unitTokens = { "player", "party1", "party2", "party3", "party4" }
	for i = 1, #unitTokens do
		local u = unitTokens[i]
		if UnitExists(u) then
			splits["party"..i.."Name"] = UnitName(u)
			splits["party"..i.."Class"] = UnitClass(u)
			splits["party"..i.."Role"] = UnitGroupRolesAssigned(u)
			-- splits["party"..i.."Spec"] = u == "player" and GetSpecializationInfo(GetSpecialization() or 0) or GetInspectSpecialization(u)
		end
	end

	if Addon.Config.recordSplits then
		if not AngryKeystones_Data.splits[mapID] then AngryKeystones_Data.splits[mapID] = {} end
		table.insert(AngryKeystones_Data.splits[mapID], splits)
	end
end

function Mod:SCENARIO_UPDATE()
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local numCriteria = select(3, C_Scenario.GetStepInfo())
		local mapID = C_ChallengeMode.GetActiveChallengeMapID()
		if not Mod.splits and numCriteria > 0 then
			Mod.splits = {}
			AngryKeystones_Data.state.splits = Mod.splits
			Mod.splitNames = {}
			AngryKeystones_Data.state.splitNames = Mod.splitNames
			AngryKeystones_Data.state.mapID = mapID
			for criteriaIndex = 1, numCriteria do
				local criteriaString, criteriaType, completed = C_Scenario.GetCriteriaInfo(criteriaIndex)
				Mod.splits[criteriaIndex] = completed
				Mod.splitNames[criteriaIndex] = criteriaString
			end
		end
	end
end

function Mod:SCENARIO_CRITERIA_UPDATE()
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local mapID = C_ChallengeMode.GetActiveChallengeMapID()
		if mapID == 1516 and Addon.Config.recordSplits and not Mod.mapVariation then Mod.mapVariation = ArcwayMapVariation() end -- The Arcway

		local fresh = false
		if not Mod.splits then
			Mod.splits = {}
			AngryKeystones_Data.state.splits = Mod.splits
			Mod.splitNames = {}
			AngryKeystones_Data.state.splitNames = Mod.splitNames
			AngryKeystones_Data.state.mapID = mapID
			fresh = true
		end
		local numCriteria = select(3, C_Scenario.GetStepInfo())
		for criteriaIndex = 1, numCriteria do
			local criteriaString, criteriaType, completed, quantity, totalQuantity, flags, _, quantityString, criteriaID, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
			if not Mod.splitNames[criteriaIndex] then
				Mod.splitNames[criteriaIndex] = criteriaString
			end
			if Mod.splits[criteriaIndex] == nil then Mod.splits[criteriaIndex] = false end

			if completed and not Mod.splits[criteriaIndex] then
				Mod.splits[criteriaIndex] = fresh or GetElapsedTime()
			end
		end
		UpdateSplits(SCENARIO_CONTENT_TRACKER_MODULE, numCriteria, ScenarioObjectiveBlock)
	end
end

function Mod:CHALLENGE_MODE_START()
	challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
end

function Mod:Startup()
	if not AngryKeystones_Data then AngryKeystones_Data = {} end
	if not AngryKeystones_Data.splits then AngryKeystones_Data.splits = {} end
	if not AngryKeystones_Data.state then AngryKeystones_Data.state = {} end

	local mapID = C_ChallengeMode.GetActiveChallengeMapID()
	if select(10, C_Scenario.GetInfo()) == LE_SCENARIO_TYPE_CHALLENGE_MODE and mapID and mapID == AngryKeystones_Data.state.mapID then
		Mod.splits = AngryKeystones_Data.state.splits
		Mod.splitNames = AngryKeystones_Data.state.splitNames
	else
		AngryKeystones_Data.state.mapID = nil
		AngryKeystones_Data.state.splits = nil
		AngryKeystones_Data.state.splitNames = nil
	end
	challengeMapID = mapID

	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
	self:RegisterEvent("CHALLENGE_MODE_START")
	self:RegisterEvent("CHALLENGE_MODE_RESET")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	self:RegisterEvent("SCENARIO_UPDATE")
	self:SCENARIO_UPDATE()
	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", UpdateSplits)
	Addon.Config:RegisterCallback('splitsFormat', function()
		UpdateSplits(SCENARIO_CONTENT_TRACKER_MODULE, nil, ScenarioObjectiveBlock)
	end)
end
