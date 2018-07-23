local _,L = ...
local rematch = Rematch
local panel = RematchBottomPanel
local settings

rematch:InitModule(function()
	rematch.BottomPanel = panel
	settings = RematchSettings
	panel.SaveAsButton:SetText(L["Save As..."])
	local text = panel.UseDefault.text
	text:SetText(L["Rematch"]) -- format("%s %sv%s",L["Rematch"],rematch.hexGrey,GetAddOnMetadata("Rematch","Version")))
	text:SetFontObject("GameFontNormal")
	panel.SummonButton.tooltipBody = format("%s\n\n%s",BATTLE_PETS_SUMMON_TOOLTIP,L["You can also double-click a pet to summon or dismiss it."])
	panel.FindBattleButton.tooltipTitle = FIND_BATTLE
	panel.FindBattleButton.tooltipBody = BATTLE_PETS_FIND_BATTLE_TOOLTIP
	panel.SaveAsButton.tooltipTitle = L["Save As..."]
	panel.SaveAsButton.tooltipBody = L["Save the currently loaded pets to a new team."]
	panel.SaveButton.tooltipTitle = SAVE
	panel.SaveButton.tooltipBody = L["Save the currently loaded pets to the loaded team."]
	panel.UseDefault.tooltipTitle = L["Disable Rematch"]
	panel.UseDefault.tooltipBody = L["Uncheck this to restore the default pet journal.\n\nYou can still use Rematch in its standlone window, accessed via key binding, /rematch command or from the Minimap button if enabled in options."]
end)

function panel:Update()
	-- save button
	panel.SaveButton:SetEnabled(settings.loadedTeam and settings.loadedTeam~=1)
	-- summon button
	local petID = rematch.PetCard.petID
	local idType = rematch:GetIDType(petID)
	panel.SummonButton:SetEnabled(rematch.PetCard.locked and idType=="pet")
	if rematch.PetCard.locked and idType=="pet" and C_PetJournal.GetSummonedPetGUID()==petID then
		panel.SummonButton:SetText(PET_DISMISS)
		panel.SummonButton.tooltipTitle = PET_DISMISS
	else
		panel.SummonButton:SetText(BATTLE_PET_SUMMON)
		panel.SummonButton.tooltipTitle = BATTLE_PET_SUMMON
	end
	panel.FindBattleButton:SetEnabled(C_PetJournal.IsFindBattleEnabled() and C_PetJournal.IsJournalUnlocked())
	local queueState = C_PetBattles.GetPVPMatchmakingInfo()
	if ( queueState == "queued" or queueState == "proposal" or queueState == "suspended" ) then
		panel.FindBattleButton:SetText(LEAVE_QUEUE)
	else
		panel.FindBattleButton:SetText(FIND_BATTLE)
	end
end

function panel:ButtonOnClick()
	if self==panel.SummonButton then
		rematch.PetListButtonOnDoubleClick(rematch.PetCard)
	elseif self==panel.SaveButton and settings.loadedTeam then
		rematch:SetSideline(settings.loadedTeam,RematchSaved[settings.loadedTeam],true)
		if rematch:SidelinePetsDifferentThan(settings.loadedTeam) then
			rematch:ShowOverwriteDialog(true)
		else
			rematch:PushSideline()
			rematch:ShowTeam(settings.loadedTeam)
		end
	elseif self==panel.SaveAsButton then
		rematch:SetSideline(nil,nil,true)
		rematch:CheckToOverwriteNotesAndPreferences()
		rematch:ShowSaveAsDialog()
	elseif self==panel.FindBattleButton then
		local queueState = C_PetBattles.GetPVPMatchmakingInfo()
		if queueState=="proposal" then
			C_PetBattles.DeclineQueuedPVPMatch()
		elseif queueState then
			C_PetBattles.StopPVPMatchmaking()
		else
			C_PetBattles.StartPVPMatchmaking()
		end
	end
end

function panel:OnShow()
	panel:RegisterEvent("COMPANION_UPDATE")
end

function panel:OnHide()
	panel:UnregisterEvent("COMPANION_UPDATE")
end

function panel:OnEvent(event,...)
	if event=="COMPANION_UPDATE" and select(1,...)=="CRITTER" then
		panel:Update()
	end
end

-- the BottomPanel has two anchors to bottom of the frame and its width isn't actually
-- set within here; instead the buttons are adjusted based on the expected width.
-- showToggle is true when called from the journal (to show the Rematch checkbutton)
-- showCommon is true when the SummonButton should show (journal and dual panel standalone)
function panel:Resize(width,showToggle,showSummon)
	if showToggle then
		panel.UseDefault:SetChecked(true)
	end
	panel.UseDefault:SetShown(showToggle)
	panel.SummonButton:SetShown(showSummon)
	panel.SaveButton.LeftSeparator:SetShown(showSummon)
	local buttonWidth -- the width of Find Battle, Save As and Save
	if showSummon then
		panel.SummonButton:SetWidth(panel:GetParent()==rematch.Frame and 120 or 160)
		buttonWidth = 120
	else
		buttonWidth = (width-11)/3
	end
	panel.FindBattleButton:SetWidth(buttonWidth)
	panel.SaveAsButton:SetWidth(buttonWidth)
	panel.SaveButton:SetWidth(buttonWidth)
end
