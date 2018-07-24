local ADDON, Addon = ...
local Mod = Addon:NewModule('ProgressTracker')

local lastQuantity
local lastDied
local lastDiedName
local lastDiedTime
local lastAmount
local lastAmountTime
local lastQuantity

local progressPresets = {[104277]=4,[102253]=4,[98954]=4,[97185]=10,[113537]=10,[101839]=4,[104246]=4,[104278]=10,[97170]=4,[113506]=4,[105617]=4,[105633]=4,[102095]=4,[105952]=6,[97043]=4,[102430]=1,[98366]=4,[95832]=2,[91784]=1,[104295]=1,[102781]=4,[102287]=10,[98733]=4,[102351]=1,[96247]=1,[111563]=4,[95769]=4,[113699]=8,[91785]=2,[100216]=4,[97172]=1,[100248]=4,[114289]=4,[105651]=4,[105699]=3,[105715]=4,[98368]=4,[95834]=2,[99675]=4,[91786]=4,[98177]=12,[97173]=4,[100249]=1,[105636]=4,[95771]=4,[96584]=4,[97365]=4,[91006]=4,[91787]=2,[109908]=10,[96664]=2,[105876]=1,[95947]=4,[99804]=2,[95772]=4,[99358]=4,[101414]=2,[106785]=1,[104251]=4,[100713]=4,[105845]=1,[98243]=4,[98275]=4,[96028]=4,[99359]=3,[105766]=1,[91008]=4,[91789]=4,[98435]=7,[98706]=6,[100539]=4,[98770]=4,[105703]=1,[102404]=4,[99360]=9,[97097]=4,[91790]=4,[98691]=4,[102277]=4,[98293]=1,[98813]=4,[105720]=4,[91001]=4,[101074]=1,[100532]=1,[99678]=4,[104270]=8,[101991]=4,[98732]=1,[98963]=1,[91792]=10,[100526]=4,[98246]=4,[106546]=4,[98533]=10,[105705]=4,[96015]=4,[104300]=4,[113536]=10,[92610]=4,[99649]=12,[98900]=4,[98406]=4,[98677]=1,[91808]=1,[92350]=4,[102295]=10,[102566]=12,[113998]=4,[97163]=3,[102104]=4,[102375]=3,[105706]=8,[95861]=4,[97068]=5,[96574]=5,[97171]=10,[102094]=4,[102232]=4,[99188]=4,[99307]=12,[105682]=8,[92538]=1,[100527]=3,[102583]=4,[96587]=4,[98280]=4,[98370]=4,[98538]=10,[106786]=1,[113111]=1,[91783]=4,[99956]=4,[114712]=3,[91332]=4,[91794]=1,[96657]=12,[98426]=4,[97197]=2,[91796]=10,[98759]=4,[105915]=4,[98919]=4,[99908]=1,[98362]=10,[95779]=10,[99365]=4,[99891]=5,[101437]=1,[90998]=4,[106059]=4,[98425]=4,[96640]=2,[97182]=6,[98728]=7,[95939]=10,[100529]=1,[98776]=4,[105422]=1,[98792]=4,[90997]=4,[105629]=1,[99366]=4,[97087]=2,[101438]=4,[97119]=1,[96608]=2,[98681]=6,[97677]=1,[96480]=1,[102584]=4,[95842]=2,[100364]=4,[101072]=1,[94968]=5,[98973]=1,[102788]=4,[96934]=2,[98756]=4,[107288]=1,[91793]=1,[91000]=8,[91781]=4,[91782]=10,[97678]=8,[98926]=4,[97200]=4,[100531]=8,[92387]=4,[99033]=4,[95920]=2,[98810]=6,[95766]=4,[105921]=4,[96677]=2,[101679]=4,[114288]=4,[96611]=2,[106787]=1}

local function ProcessLasts()
	if lastDied and lastDiedTime and lastAmount and lastAmountTime then
		if abs(lastAmountTime - lastDiedTime) < 0.1 then
			if not AngryKeystones_Data.progress[lastDied] then AngryKeystones_Data.progress[lastDied] = {} end
			if AngryKeystones_Data.progress[lastDied][lastAmount] then
				AngryKeystones_Data.progress[lastDied][lastAmount] = AngryKeystones_Data.progress[lastDied][lastAmount] + 1
			else
				AngryKeystones_Data.progress[lastDied][lastAmount] = 1
			end
			lastDied, lastDiedTime, lastAmount, lastAmountTime, lastDiedName = nil, nil, nil, nil, nil
		end
	end
end

function Mod:SCENARIO_CRITERIA_UPDATE()
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local numCriteria = select(3, C_Scenario.GetStepInfo())
		for criteriaIndex = 1, numCriteria do
			local criteriaString, criteriaType, _, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
			if isWeightedProgress then
				local currentQuantity = quantityString and tonumber( strsub(quantityString, 1, -2) )
				if lastQuantity and currentQuantity < totalQuantity and currentQuantity > lastQuantity then
					lastAmount = currentQuantity - lastQuantity
					lastAmountTime = GetTime()
					ProcessLasts()
				end
				lastQuantity = currentQuantity
			end
		end
	end
end

local function StartTime()
	local numCriteria = select(3, C_Scenario.GetStepInfo())
	for criteriaIndex = 1, numCriteria do
		local criteriaString, criteriaType, _, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
		if isWeightedProgress then
			local quantityString = select(8, C_Scenario.GetCriteriaInfo(criteriaIndex))
			lastQuantity = quantityString and tonumber( strsub(quantityString, 1, -2) )
		end
	end
end

local function StopTime()
	return
end

local function CheckTime(...)
	for i = 1, select("#", ...) do
		local timerID = select(i, ...)
		local _, elapsedTime, type = GetWorldElapsedTime(timerID)
		if type == LE_WORLD_ELAPSED_TIMER_TYPE_CHALLENGE_MODE then
			local mapID = C_ChallengeMode.GetActiveChallengeMapID()
			if mapID then
				StartTime()
				return
			end
		end
	end
	StopTime()
end

local function OnTooltipSetUnit(tooltip)
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE and Addon.Config.progressTooltip then
		local name, unit = tooltip:GetUnit()
		local guid = unit and UnitGUID(unit)
		if guid then
			local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid)
			npc_id = tonumber(npc_id)
			local info = AngryKeystones_Data.progress[npc_id]
			local preset = progressPresets[npc_id]
			if info or preset then
				local numCriteria = select(3, C_Scenario.GetStepInfo())
				local total
				local progressName
				for criteriaIndex = 1, numCriteria do
					local criteriaString, _, _, quantity, totalQuantity, _, _, quantityString, _, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
					if isWeightedProgress then
						progressName = criteriaString
						total = totalQuantity
					end
				end

				local value, valueCount
				if info then
					for amount, count in pairs(info) do
						if not valueCount or count > valueCount or (count == valueCount and amount < value) then
							value = amount
							valueCount = count
						end
					end
				end
				if preset and (not value or valueCount == 1) then
					value = preset
				end
				if value and total then
					local forcesFormat = format(" - %s: %%s", progressName)
					local text
					if Addon.Config.progressFormat == 1 or Addon.Config.progressFormat == 4 then
						text = format( format(forcesFormat, "+%.2f%%"), value/total*100)
					elseif Addon.Config.progressFormat == 2 or Addon.Config.progressFormat == 5 then
						text = format( format(forcesFormat, "+%d"), value)
					elseif Addon.Config.progressFormat == 3 or Addon.Config.progressFormat == 6 then
						text = format( format(forcesFormat, "+%.2f%% - +%d"), value/total*100, value)
					end

					if text then
						local matcher = format(forcesFormat, "%d+%%")
						for i=2, tooltip:NumLines() do
							local tiptext = _G["GameTooltipTextLeft"..i]
							local linetext = tiptext and tiptext:GetText()

							if linetext and linetext:match(matcher) then
								tiptext:SetText(text)
								tooltip:Show()
							end
						end
					end
				end
			end
		end
	end
end

function Mod:GeneratePreset()
	local ret = {}
	for npcID, info in pairs(AngryKeystones_Data.progress) do
		local value, valueCount
		for amount, count in pairs(info) do
			if not valueCount or count > valueCount or (count == valueCount and amount < value) then
				value = amount
				valueCount = count
			end
		end
		ret[npcID] = value
	end
	AngryKeystones_Data.preset = ret
	return ret
end

function Mod:PLAYER_ENTERING_WORLD(...) CheckTime(GetWorldElapsedTimers()) end
function Mod:WORLD_STATE_TIMER_START(...) local timerID = ...; CheckTime(timerID) end
function Mod:WORLD_STATE_TIMER_STOP(...) local timerID = ...; StopTime(timerID) end
function Mod:CHALLENGE_MODE_START(...) CheckTime(GetWorldElapsedTimers()) end
function Mod:CHALLENGE_MODE_RESET(...) return end

local function ProgressBar_SetValue(self, percent)
	if self.criteriaIndex then
		local _, _, _, _, totalQuantity, _, _, quantityString, _, _, _, _, _ = C_Scenario.GetCriteriaInfo(self.criteriaIndex)
		local currentQuantity = quantityString and tonumber( strsub(quantityString, 1, -2) )
		if currentQuantity and totalQuantity then
			if Addon.Config.progressFormat == 1 then
				self.Bar.Label:SetFormattedText("%.2f%%", currentQuantity/totalQuantity*100)
			elseif Addon.Config.progressFormat == 2 then
				self.Bar.Label:SetFormattedText("%d/%d", currentQuantity, totalQuantity)
			elseif Addon.Config.progressFormat == 3 then
				self.Bar.Label:SetFormattedText("%.2f%% - %d/%d", currentQuantity/totalQuantity*100, currentQuantity, totalQuantity)
			elseif Addon.Config.progressFormat == 4 then
				self.Bar.Label:SetFormattedText("%.2f%% (%.2f%%)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100)
			elseif Addon.Config.progressFormat == 5 then
				self.Bar.Label:SetFormattedText("%d/%d (%d)", currentQuantity, totalQuantity, totalQuantity - currentQuantity)
			elseif Addon.Config.progressFormat == 6 then
				self.Bar.Label:SetFormattedText("%.2f%% (%.2f%%) - %d/%d (%d)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100, currentQuantity, totalQuantity, totalQuantity - currentQuantity)
			end
		end
	end
end

function Mod:Startup()
	if not AngryKeystones_Data then
		AngryKeystones_Data = {}
	end
	if not AngryKeystones_Data.progress then
		AngryKeystones_Data = { progress = AngryKeystones_Data }
	end
	if not AngryKeystones_Data.state then AngryKeystones_Data.state = {} end

	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("WORLD_STATE_TIMER_START")
	self:RegisterEvent("WORLD_STATE_TIMER_STOP")
	self:RegisterEvent("CHALLENGE_MODE_START")
	self:RegisterEvent("CHALLENGE_MODE_RESET")
	CheckTime(GetWorldElapsedTimers())
	GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

	Addon.Config:RegisterCallback('progressFormat', function()
		local usedBars = SCENARIO_TRACKER_MODULE.usedProgressBars[ScenarioObjectiveBlock] or {}
		for _, bar in pairs(usedBars) do
			ProgressBar_SetValue(bar)
		end
	end)
end

hooksecurefunc("ScenarioTrackerProgressBar_SetValue", ProgressBar_SetValue)
