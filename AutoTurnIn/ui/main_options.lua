local addonName, ptable = ...
local L = ptable.L
local O = addonName .. "OptionsPanel"
AutoTurnIn.OptionsPanel = CreateFrame("Frame", O)
AutoTurnIn.OptionsPanel.name=addonName
local OptionsPanel = AutoTurnIn.OptionsPanel
-- switch flag. 'false' signals that reset must be made. 'true' allows redraw the screen keeping values
local MakeACopy=true

-- Title
local title = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetText(addonName .." ".. AutoTurnIn.defaults.version)

-- Description
local notes = GetAddOnMetadata(addonName, "Notes-" .. GetLocale()) or GetAddOnMetadata(addonName, "Notes")
local subText = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subText:SetText(notes)

-- Reset button
local ResetButton = CreateFrame("Button", nil, OptionsPanel, "OptionsButtonTemplate")
ResetButton:SetText(L["resetbutton"])
ResetButton:SetScript("OnClick", function()
	ptable.TempConfig = CopyTable(AutoTurnIn.defaults)
	MakeACopy=false;
	AutoTurnIn.RewardPanel.refresh();
	AutoTurnIn.OptionsPanel.refresh();
end)

local function newCheckbox(name, caption, config)
    local cb = CreateFrame("CheckButton", "$parent"..name, OptionsPanel, "OptionsCheckButtonTemplate")
    _G[cb:GetName().."Text"]:SetText(caption and caption or name)
    cb:SetScript("OnClick", function(self)
		ptable.TempConfig[config] = self:GetChecked()
    end)
    return cb
end

local function newDropDown(caption, name, values, config)
    local label = OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetText(caption)

    local dropDown = CreateFrame("Frame", O..name, OptionsPanel, "Lib_UIDropDownMenuTemplate")
    Lib_UIDropDownMenu_Initialize(dropDown, function (self, level)
        for k, v in ipairs(values) do
            local info = Lib_UIDropDownMenu_CreateInfo()
            info.text, info.value = v, k
            info.func = function(self)
                Lib_UIDropDownMenu_SetSelectedID(dropDown, self:GetID())
                ptable.TempConfig[config] = self:GetID()
            end
            Lib_UIDropDownMenu_AddButton(info, level)
        end
    end)
    Lib_UIDropDownMenu_SetWidth(dropDown, 200);
    Lib_UIDropDownMenu_JustifyText(dropDown, "LEFT")
    label:SetPoint("BOTTOMLEFT", dropDown, "TOPLEFT", 18, 0)
    return dropDown
end

-- 'Enable' CheckBox
local Enable = newCheckbox("enabled", L["enabled"], "enabled")
-- trivial, so called grayed quests
local TrivialQuests = newCheckbox("TrivialQuests", L["TrivialQuests"], "trivial")
-- Only hand in the quest
local CompleteOnly = newCheckbox("CompleteOnly", L["CompleteOnly"], "completeonly")
-- DarkmoonTeleport
local ToDarkMoon = newCheckbox("ToDarkMoon", L["ToDarkmoonLabel"], "todarkmoon")
-- Darkmoon Teleport to cannon
local DarkMoonCannon = newCheckbox("DarkMoonCannon", L["DarkmoonTeleLabel"], "darkmoonteleport")
-- Darkmoon games
local DarkMoonAutoStart = newCheckbox("DarkMoonAutoStart", L["DarkmoonAutoLabel"], "darkmoonautostart")
-- 'Show Reward Text' CheckBox
local ShowRewardText = newCheckbox("Reward", L["rewardtext"], "showrewardtext")
-- 'Equip Reward' CheckBox
local EquipReward = newCheckbox("Equip", L["autoequip"], "autoequip")
-- reward loot explanation
local Debug = newCheckbox("Debug", L["debug"], "debug")
-- share quest (!!! alpha)
local ShareQuests = newCheckbox("ShareQuests", L["ShareQuestsLabel"], "questshare")
-- accept share quest --abyui
local AcceptShared = newCheckbox("AcceptShared", L["AcceptSharedQuestsLabel"], "acceptshare")
-- 'Show QuestLevel' CheckBox
local ShowQuestLevel = newCheckbox("QuestLevel", L["questlevel"], "questlevel")
-- 'Show Watch Quest Level' CheckBox
local ShowWatchLevel = newCheckbox("WatchLevel", L["watchlevel"], "watchlevel")
-- 'Stop Auto Select Reward if Relic' CheckBox
local RelicToggle = newCheckbox("RelicToggle",  L["relictoggle"], "relictoggle")
-- 'Stop Auto Select Reward if ArtifcatPower' CheckBox
local ArtifactPowerToggle = newCheckbox("ArtifactPowerToggle",  L["artifactpowertoggle"], "artifactpowertoggle")
-- RevivePets
local ReviveBattlePet = newCheckbox("ReviveBattlePet", L["ReviveBattlePetLabel"], "reviveBattlePet")

-- Auto toggle key
local ToggleKeyConst = {NONE_KEY, ALT_KEY, CTRL_KEY, SHIFT_KEY}
local ToggleKeyDropDown = newDropDown(L["togglekey"], "ToggleKeyDropDown", ToggleKeyConst, "togglekey")
-- Quest types to handle
local QuestConst = {L["questTypeAll"], L["questTypeList"], L["questTypeExceptDaily"]}
local QuestDropDown = newDropDown(L["questTypeLabel"], "QuestDropDown", QuestConst, "all")   -- self:GetID() == 1
-- Tournament loot type
local TournamentConst = {L["tournamentWrit"], L["tournamentPurse"]}
local TournamentDropDown = newDropDown(L["tournamentLabel"], "TournamentDropDown", TournamentConst, "tournament")
-- How to loot
local LootConst = {L["lootTypeFalse"], L["lootTypeGreed"], L["lootTypeNeed"]}
local LootDropDown = newDropDown(L["lootTypeLabel"], "LootDropDown", LootConst, "lootreward")



-- Control placement
title:SetPoint("TOPLEFT", 16, -16)
subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
ResetButton:SetPoint("TOPRIGHT", OptionsPanel, "TOPRIGHT", -10, -10)
Enable:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 0, -14)
QuestDropDown:SetPoint("TOPLEFT", Enable, "BOTTOMLEFT", -15, -22)
TrivialQuests:SetPoint("TOPLEFT", QuestDropDown, "TOPRIGHT", 30, 0)
CompleteOnly:SetPoint("TOPLEFT", TrivialQuests, "BOTTOMLEFT", 0, -10)
LootDropDown:SetPoint("TOPLEFT", QuestDropDown, "BOTTOMLEFT", 0, -22)
TournamentDropDown:SetPoint("TOPLEFT", ToggleKeyDropDown, "TOPRIGHT", 17, 0)
EquipReward:SetPoint("TOPLEFT", LootDropDown, "BOTTOMLEFT", 16, -10)
ShowRewardText:SetPoint("TOPLEFT", EquipReward, "BOTTOMLEFT", 0, -10)
ToDarkMoon:SetPoint("TOPLEFT", ShowRewardText, "BOTTOMLEFT", 0, -10)
DarkMoonCannon:SetPoint("TOPLEFT", ToDarkMoon, "BOTTOMLEFT", 0, -10)
DarkMoonAutoStart:SetPoint("TOPLEFT", DarkMoonCannon, "BOTTOMLEFT", 0, -10)
ReviveBattlePet:SetPoint("TOPLEFT", CompleteOnly, "BOTTOMLEFT", 0, -30)
Debug:SetPoint("TOPLEFT", ResetButton, "BOTTOMLEFT", 0, -10)
ToggleKeyDropDown:SetPoint("TOPLEFT", DarkMoonAutoStart, "BOTTOMLEFT", -15, -22)
ShowQuestLevel:SetPoint("TOPLEFT", ToggleKeyDropDown, "BOTTOMLEFT", 16, -10)
ShowWatchLevel:SetPoint("TOPLEFT", ShowQuestLevel, "BOTTOMLEFT", 0, -10)
ShareQuests:SetPoint("TOPLEFT", ShowWatchLevel, "BOTTOMLEFT", 0, -10)
RelicToggle:SetPoint("TOPLEFT", TournamentDropDown, "BOTTOMLEFT", 17, -10)
ArtifactPowerToggle:SetPoint("TOPLEFT", RelicToggle, "BOTTOMLEFT", 0, -10)
AcceptShared:SetPoint("TOPLEFT", ArtifactPowerToggle, "BOTTOMLEFT", 0, -10)

OptionsPanel.refresh = function()
	if ( MakeACopy ) then 
		ptable.TempConfig = CopyTable(AutoTurnInCharacterDB)
	end
	Enable:SetChecked(ptable.TempConfig.enabled)

	Lib_UIDropDownMenu_SetSelectedID(QuestDropDown, ptable.TempConfig.all)
	Lib_UIDropDownMenu_SetText(QuestDropDown, QuestConst[ptable.TempConfig.all])

	Lib_UIDropDownMenu_SetSelectedID(LootDropDown, ptable.TempConfig.lootreward)
	Lib_UIDropDownMenu_SetText(LootDropDown, LootConst[ptable.TempConfig.lootreward])
	
	Lib_UIDropDownMenu_SetSelectedID(TournamentDropDown, ptable.TempConfig.tournament)
	Lib_UIDropDownMenu_SetText(TournamentDropDown, TournamentConst[ptable.TempConfig.tournament])
	ToDarkMoon:SetChecked(ptable.TempConfig.todarkmoon)
	DarkMoonCannon:SetChecked(ptable.TempConfig.darkmoonteleport)
	DarkMoonAutoStart:SetChecked(ptable.TempConfig.darkmoonautostart)
	ShowRewardText:SetChecked(ptable.TempConfig.showrewardtext)
	EquipReward:SetChecked(ptable.TempConfig.autoequip)
	Debug:SetChecked(ptable.TempConfig.debug)
	TrivialQuests:SetChecked(ptable.TempConfig.trivial)
    CompleteOnly:SetChecked(ptable.TempConfig.completeonly)
	ShowQuestLevel:SetChecked(ptable.TempConfig.questlevel)
	ShowWatchLevel:SetChecked(ptable.TempConfig.watchlevel)
	ShareQuests:SetChecked(ptable.TempConfig.questshare)
    AcceptShared:SetChecked(ptable.TempConfig.acceptshare)
	RelicToggle:SetChecked(ptable.TempConfig.relictoggle)
	ArtifactPowerToggle:SetChecked(ptable.TempConfig.artifactpowertoggle)	

	Lib_UIDropDownMenu_SetSelectedID(ToggleKeyDropDown, ptable.TempConfig.togglekey)
	Lib_UIDropDownMenu_SetText(ToggleKeyDropDown, ToggleKeyConst[ptable.TempConfig.togglekey])
	MakeACopy = true
end

OptionsPanel.default = function() 
	ptable.TempConfig = CopyTable(AutoTurnIn.defaults)
end

OptionsPanel.okay = function()
	AutoTurnInCharacterDB = CopyTable(ptable.TempConfig)
	AutoTurnIn:SetEnabled(AutoTurnInCharacterDB.enabled)

	--[[ 
	-- any of the calls below taints the UseQuestLogSpecialItem. Expand-collapse is a workaround
	securecall(ObjectiveTracker_Update, OBJECTIVE_TRACKER_UPDATE_ALL)
	QuestMapFrame_UpdateAll()
	
	-- this one happens too fast and "onUpdate' event does not occur. The custom frame with delay and 'OnUpdate' event can help.
	if (ObjectiveTrackerFrame.collapsed == nil) then
		ObjectiveTracker_Collapse();
		ObjectiveTracker_Expand();
	end
	]]--
	-- and here goes the dirty hack!!! No direct update calls, hence, no global variable taints!!!
	if GetNumQuestWatches() > 0 then
		local inLog = GetQuestIndexForWatch(1);
		if IsQuestWatched(inLog) then
			RemoveQuestWatch (inLog);
			AddQuestWatch(inLog);
		else
			AddQuestWatch(inLog);
			RemoveQuestWatch (inLog);
		end
	else
		if  (GetNumQuestLogEntries() > 0) then
			AddQuestWatch(2);
			RemoveQuestWatch (2);
		end
	end
end

InterfaceOptions_AddCategory(OptionsPanel)
