local _G = _G 	--Rumors say that global _G is called by lookup in a super-global table. Have no idea whether it is true. 
local _ 		--Sometimes blizzard exposes "_" variable as a global. 
local addonName, ptable = ...
local L = ptable.L
local C = ptable.CONST

AutoTurnIn.QuestLevelFormat = " [%d] %s"
AutoTurnIn.WatchFrameLevelFormat = "[%d%s%s] %s"
AutoTurnIn.QuestTypesIndex = {
	[0] = "",           --default
	[1] = "g",			--Group
	[41] = "+",			--PvP
	[62] = "r",			--Raid
	[81] = "d",			--Dungeon
	[83] = "L", 		--Legendary
	[85] = "h",			--Heroic 
	[98] = "s", 		--Scenario QUEST_TYPE_SCENARIO
	[102] = "a", 		-- Account
}

function AutoTurnIn:ShowQuestLevelInLog()
	if not AutoTurnInCharacterDB.questlevel then 
		return
	end	

	for button in QuestMapFrame.QuestsFrame.titleFramePool:EnumerateActive() do
        if button and button.Text then button.Text:SetWordWrap(true) end --abyui
		if (button and button.questLogIndex) then
			local questInfo = C_QuestLog.GetInfo(button.questLogIndex)
			local text = button.Text:GetText()
			if questInfo.title and text and (not string.find(text, "^%[.*%].*")) then
				local prevHeight = button:GetHeight() - button.Text:GetHeight()
				button.Text:SetText(AutoTurnIn.QuestLevelFormat:format(questInfo.level, questInfo.title))
                button.Text:SetWordWrap(false) --abyui
				button:SetHeight(prevHeight + button.Text:GetHeight())
				-- replacind checkbox image to the new position
				button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth() + 2, 0);
			end
		end
	end

end

function AutoTurnIn:ShowQuestLevelInWatchFrame()
	if not AutoTurnInCharacterDB.watchlevel then 
		return
	end
	
	local tracker = ObjectiveTrackerFrame
	if ( not tracker.initialized )then
		return
	end
	
	for i = 1, #tracker.MODULES do
		--for id,block in pairs( tracker.MODULES[i].Header.module.usedBlocks) do
		for blockTemplate, blockTable in pairs( tracker.MODULES[i].Header.module.usedBlocks) do
			for id, block in pairs(blockTable) do
				if type(block.id)=="number" and block.HeaderText and block.HeaderText:GetText() and (not string.find(block.HeaderText:GetText(), "^%[.*%].*")) then
					local questLogIndex = C_QuestLog.GetLogIndexForQuestID(block.id)
					if (questLogIndex) then
						local questInfo = C_QuestLog.GetInfo(questLogIndex)
						-- update calls are async and data could not be (yet or already) exist in log
						if (questInfo.title and questInfo.title ~= "") then 	  
							local questTypeIndex = GetQuestLogQuestType(questLogIndex)
							local tagString = AutoTurnIn.QuestTypesIndex[questTypeIndex] or ""
							local dailyMod = (questInfo.frequency == Enum.QuestFrequency.Daily or questInfo.frequency == Enum.QuestFrequency.Weekly) and "\*" or ""

							--resizing the block if new line requires more spaces.
							local h = block.height - block.HeaderText:GetHeight()
							block.HeaderText:SetText(AutoTurnIn.WatchFrameLevelFormat:format(questInfo.level, tagString, dailyMod, questInfo.title))
							block.height = h + block.HeaderText:GetHeight()
							block:SetHeight(block.height)
						end
					end
				end
			end
		end
	end
end
