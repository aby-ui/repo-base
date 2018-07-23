if GetBuildInfo() ~= "7.2.0" then return end
local ADDON, Addon = ...
local Mod = Addon:NewModule('Persist')

local challengeMapID

local function LoadPersist()
	local function IsInCompletedInstance()
		return select(10, C_Scenario.GetInfo()) == LE_SCENARIO_TYPE_CHALLENGE_MODE and C_ChallengeMode.GetCompletionInfo() ~= 0 and select(3, C_Scenario.GetInfo()) == 0 and challengeMapID
	end

	ScenarioTimer_OnUpdate_Old = ScenarioTimer_OnUpdate
	function ScenarioTimer_OnUpdate(self, elapsed)
		if self.block.timerID ~= -1 then
			self.timeSinceBase = self.timeSinceBase + elapsed;
		end
		self.updateFunc(self.block, floor(self.baseTime + self.timeSinceBase));
	end
	ScenarioTimerFrame:SetScript("OnUpdate", ScenarioTimer_OnUpdate)

	ScenarioTimer_Start_Old = ScenarioTimer_Start
	function ScenarioTimer_Start(block, updateFunc)
		if block.timerID == -1 then
			local mapID, level, timeElapsed, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
			ScenarioTimerFrame.baseTime = floor(timeElapsed/1000);
		else
			local _, elapsedTime = GetWorldElapsedTime(block.timerID);
			ScenarioTimerFrame.baseTime = elapsedTime;
			challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
		end
		ScenarioTimerFrame.timeSinceBase = 0;
		ScenarioTimerFrame.block = block;
		ScenarioTimerFrame.updateFunc = updateFunc;
		ScenarioTimerFrame:Show();
	end

	ScenarioTimer_Stop_Old = ScenarioTimer_Stop
	function ScenarioTimer_Stop(...)
		if IsInCompletedInstance() then
			local mapID, level, timeElapsed, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
			local name, _, timeLimit = C_ChallengeMode.GetMapInfo(challengeMapID)

			Scenario_ChallengeMode_ShowBlock(-1, floor(timeElapsed/1000), timeLimit)
		else
			ScenarioTimer_Stop_Old(...)
		end
	end

	SCENARIO_CONTENT_TRACKER_MODULE_StaticReanchor_Old = SCENARIO_CONTENT_TRACKER_MODULE.StaticReanchor
	function SCENARIO_CONTENT_TRACKER_MODULE:StaticReanchor()
		local inCompletedInstance = IsInCompletedInstance()
		local scenarioName, currentStage, numStages, flags, _, _, completed, xp, money = C_Scenario.GetInfo();
		local rewardsFrame = ObjectiveTrackerScenarioRewardsFrame;
		if ( numStages == 0 and not inCompletedInstance ) then
			ScenarioBlocksFrame_Hide();
			return;
		end
		if ( ScenarioBlocksFrame:IsShown() ) then
			ObjectiveTracker_AddBlock(SCENARIO_TRACKER_MODULE.BlocksFrame);
		end
	end

	SCENARIO_CONTENT_TRACKER_MODULE_Update_Old = SCENARIO_CONTENT_TRACKER_MODULE.Update
	function SCENARIO_CONTENT_TRACKER_MODULE:Update()
		local inCompletedInstance = IsInCompletedInstance()
		local scenarioName, currentStage, numStages, flags, _, _, _, xp, money, scenarioType = C_Scenario.GetInfo();
		local rewardsFrame = ObjectiveTrackerScenarioRewardsFrame;
		if ( numStages == 0 and not inCompletedInstance ) then
			ScenarioBlocksFrame_Hide();
			return;
		end
		local BlocksFrame = SCENARIO_TRACKER_MODULE.BlocksFrame;
		local objectiveBlock = SCENARIO_TRACKER_MODULE:GetBlock();
		local stageBlock = ScenarioStageBlock;

		-- if sliding, ignore updates unless the stage changed
		if ( BlocksFrame.slidingAction ) then
			if ( BlocksFrame.currentStage == currentStage ) then
				ObjectiveTracker_AddBlock(BlocksFrame);
				BlocksFrame:Show();
				return;
			else
				ObjectiveTracker_EndSlideBlock(BlocksFrame);
			end
		end

		BlocksFrame.maxHeight = SCENARIO_CONTENT_TRACKER_MODULE.BlocksFrame.maxHeight;
		BlocksFrame.currentBlock = nil;
		BlocksFrame.contentsHeight = 0;
		SCENARIO_TRACKER_MODULE.contentsHeight = 0;

		local stageName, stageDescription, numCriteria, _, _, _, numSpells, spellInfo, weightedProgress = C_Scenario.GetStepInfo();
		local inChallengeMode = (scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE);
		local inProvingGrounds = (scenarioType == LE_SCENARIO_TYPE_PROVING_GROUNDS);
		local dungeonDisplay = (scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY);
		local scenariocompleted = currentStage > numStages;

		if ( scenariocompleted ) then
			ObjectiveTracker_AddBlock(stageBlock);
			ScenarioBlocksFrame_SetupStageBlock(scenariocompleted);
			stageBlock:Show();
		elseif ( inChallengeMode or inCompletedInstance ) then
			if ( ScenarioChallengeModeBlock.timerID or inCompletedInstance ) then
				ObjectiveTracker_AddBlock(ScenarioChallengeModeBlock);
			end
			stageBlock:Hide();
		elseif ( ScenarioProvingGroundsBlock.timerID ) then
			ObjectiveTracker_AddBlock(ScenarioProvingGroundsBlock);
			stageBlock:Hide();
		else
			-- add the stage block
			ObjectiveTracker_AddBlock(stageBlock);
			stageBlock:Show();
			-- update if stage changed
			if ( BlocksFrame.currentStage ~= currentStage or BlocksFrame.scenarioName ~= scenarioName ) then
				SCENARIO_TRACKER_MODULE:FreeUnusedLines(objectiveBlock);
				if ( bit.band(flags, SCENARIO_FLAG_SUPRESS_STAGE_TEXT) == SCENARIO_FLAG_SUPRESS_STAGE_TEXT ) then
					stageBlock.Stage:SetText(stageName);
					stageBlock.Stage:SetSize( 172, 36 );
					stageBlock.Stage:SetPoint("TOPLEFT", 15, -18);
					stageBlock.FinalBG:Hide();
					stageBlock.Name:SetText("");
				else
					if ( currentStage == numStages ) then
						stageBlock.Stage:SetText(SCENARIO_STAGE_FINAL);
						stageBlock.FinalBG:Show();
					else
						stageBlock.Stage:SetFormattedText(SCENARIO_STAGE, currentStage);
						stageBlock.FinalBG:Hide();
					end
					stageBlock.Stage:SetSize( 172, 18 );
					stageBlock.Name:SetText(stageName);
					if ( stageBlock.Name:GetStringWidth() > stageBlock.Name:GetWrappedWidth() ) then
						stageBlock.Stage:SetPoint("TOPLEFT", 15, -10);
					else
						stageBlock.Stage:SetPoint("TOPLEFT", 15, -18);
					end
				end
				if (not stageBlock.appliedAlready) then
					-- Ugly hack to get around :IsTruncated failing if used during load
					C_Timer.After(1, function() stageBlock.Stage:ApplyFontObjects(); end);
					stageBlock.appliedAlready = true;
				end
				ScenarioStage_CustomizeBlock(stageBlock, scenarioType);
			end
		end
		BlocksFrame.scenarioName = scenarioName;
		BlocksFrame.currentStage = currentStage;

		if ( not ScenarioProvingGroundsBlock.timerID and not scenariocompleted ) then
			if (weightedProgress) then
				self:UpdateWeightedProgressCriteria(stageDescription, stageBlock, objectiveBlock, BlocksFrame);
			else
				self:UpdateCriteria(numCriteria, objectiveBlock);
				self:AddSpells(objectiveBlock, spellInfo);

				-- add the objective block
				objectiveBlock:SetHeight(objectiveBlock.height);
				if ( ObjectiveTracker_AddBlock(objectiveBlock) ) then
					if ( not BlocksFrame.slidingAction ) then
						objectiveBlock:Show();
					end
				else
					objectiveBlock:Hide();
					stageBlock:Hide();
				end
			end
		end
		ScenarioSpellButtons_UpdateCooldowns();

		-- add the scenario block
		if ( BlocksFrame.currentBlock ) then
			BlocksFrame.height = BlocksFrame.contentsHeight + 1;
			BlocksFrame:SetHeight(BlocksFrame.contentsHeight + 1);
			ObjectiveTracker_AddBlock(BlocksFrame);
			BlocksFrame:Show();
			if ( OBJECTIVE_TRACKER_UPDATE_REASON == OBJECTIVE_TRACKER_UPDATE_SCENARIO_NEW_STAGE and not inChallengeMode ) then
				if ( ObjectiveTrackerFrame:IsVisible() ) then
					if ( currentStage == 1 ) then
						ScenarioBlocksFrame_SlideIn();
					else
						ScenarioBlocksFrame_SetupStageBlock(scenariocompleted);
						if ( not scenariocompleted ) then
							ScenarioBlocksFrame_SlideOut();
						end
					end
				end
				LevelUpDisplay_PlayScenario();
				-- play sound if not the first stage
				if ( currentStage > 1 and currentStage <= numStages ) then
					PlaySound(31754);
				end
			elseif ( OBJECTIVE_TRACKER_UPDATE_REASON == OBJECTIVE_TRACKER_UPDATE_SCENARIO_SPELLS ) then
				ScenarioSpells_SlideIn(objectiveBlock);
			end
			-- header
			if ( inChallengeMode ) then
				SCENARIO_CONTENT_TRACKER_MODULE.Header.Text:SetText(scenarioName);
			elseif ( inProvingGrounds or ScenarioProvingGroundsBlock.timerID ) then
				SCENARIO_CONTENT_TRACKER_MODULE.Header.Text:SetText(TRACKER_HEADER_PROVINGGROUNDS);
			elseif( dungeonDisplay ) then
				SCENARIO_CONTENT_TRACKER_MODULE.Header.Text:SetText(TRACKER_HEADER_DUNGEON);
			else
				SCENARIO_CONTENT_TRACKER_MODULE.Header.Text:SetText(TRACKER_HEADER_SCENARIO);
			end
		else
			ScenarioBlocksFrame_Hide();
		end
	end

	SCENARIO_CONTENT_TRACKER_MODULE_UpdateCriteria_Old = SCENARIO_CONTENT_TRACKER_MODULE.UpdateCriteria
	function SCENARIO_CONTENT_TRACKER_MODULE:UpdateCriteria(numCriteria, objectiveBlock)
		if IsInCompletedInstance() then
			Addon.Splits.UpdateSplits(self, numCriteria, objectiveBlock, true)
		else
			SCENARIO_CONTENT_TRACKER_MODULE_UpdateCriteria_Old(self, numCriteria, objectiveBlock)
		end
	end

end

local function LoadExclusive()
	local function IsInActiveInstance()
		return select(10, C_Scenario.GetInfo()) == LE_SCENARIO_TYPE_CHALLENGE_MODE and select(3, C_Scenario.GetInfo()) ~= 0
	end

	ObjectiveTracker_Update_Old = ObjectiveTracker_Update
	function ObjectiveTracker_Update(...)
		if IsInActiveInstance() then
			local tracker = ObjectiveTrackerFrame
			local modules_old = tracker.MODULES
			local modules_ui_old = tracker.MODULES_UI_ORDER

			tracker.MODULES = { SCENARIO_CONTENT_TRACKER_MODULE }
			tracker.MODULES_UI_ORDER = { SCENARIO_CONTENT_TRACKER_MODULE }

			for i = 1, #modules_old do
				local module = modules_old[i]
				if module ~= SCENARIO_CONTENT_TRACKER_MODULE then
					module:BeginLayout()
					module:EndLayout()
					module.Header:Hide()
					if module.Header.animating then
						module.Header.animating = nil
						module.Header.HeaderOpenAnim:Stop()
					end
				end
			end

			ObjectiveTracker_Update_Old(...)

			tracker.MODULES = modules_old
			tracker.MODULES_UI_ORDER = modules_ui_old
		else
			ObjectiveTracker_Update_Old(...)
		end
	end

	ObjectiveTracker_ReorderModules_Old = ObjectiveTracker_ReorderModules
	function ObjectiveTracker_ReorderModules()
		if IsInActiveInstance() then
			local modules = ObjectiveTrackerFrame.MODULES;
			local modulesUIOrder = ObjectiveTrackerFrame.MODULES_UI_ORDER;
		else
			ObjectiveTracker_ReorderModules_Old()
		end
	end

end

function Mod:CHALLENGE_MODE_COMPLETED()
	ScenarioTimer_CheckTimers(GetWorldElapsedTimers())
	ObjectiveTracker_Update()
end

function Mod:Startup()
	if Addon.Config.persistTracker and LoadPersist then
		LoadPersist()
		LoadPersist = nil
		self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	end
	if Addon.Config.exclusiveTracker and LoadExclusive then
		LoadExclusive()
		LoadExclusive = nil
		self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	end
	challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
end

function Mod:AfterStartup()
	if Addon.Config.persistTracker or Addon.Config.exclusiveTracker then
		ObjectiveTracker_Update()
	end
end
