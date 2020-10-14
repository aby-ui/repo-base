

local Details = _G.Details


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> extra buttons at the death options (release, death recap)

local detailsOnDeathMenu = CreateFrame ("frame", "DetailsOnDeathMenu", UIParent, "BackdropTemplate")
detailsOnDeathMenu:SetHeight (30)
detailsOnDeathMenu.Debug = false

detailsOnDeathMenu:RegisterEvent ("PLAYER_REGEN_ENABLED")
detailsOnDeathMenu:RegisterEvent ("ENCOUNTER_END")
DetailsFramework:ApplyStandardBackdrop (detailsOnDeathMenu)
detailsOnDeathMenu:SetAlpha (0.75)

--disable text
detailsOnDeathMenu.disableLabel = Details.gump:CreateLabel (detailsOnDeathMenu, "you can disable this at /details > Raid Tools", 9)

detailsOnDeathMenu.warningLabel = Details.gump:CreateLabel (detailsOnDeathMenu, "", 11)
detailsOnDeathMenu.warningLabel.textcolor = "red"
detailsOnDeathMenu.warningLabel:SetPoint ("bottomleft", detailsOnDeathMenu, "bottomleft", 5, 2)
detailsOnDeathMenu.warningLabel:Hide()

detailsOnDeathMenu:SetScript ("OnEvent", function (self, event, ...)
	if (event == "ENCOUNTER_END") then
		C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
	end
end)

function detailsOnDeathMenu.OpenEncounterBreakdown()
	if (not Details:GetPlugin ("DETAILS_PLUGIN_ENCOUNTER_DETAILS")) then
		detailsOnDeathMenu.warningLabel.text = "Encounter Breakdown plugin is disabled! Please enable it in the Addon Control Panel."
		detailsOnDeathMenu.warningLabel:Show()
		C_Timer.After (5, function()
			detailsOnDeathMenu.warningLabel:Hide()
		end)
	end

	Details:OpenPlugin ("Encounter Breakdown")
	GameCooltip2:Hide()
end

function detailsOnDeathMenu.OpenPlayerEndurance()
	if (not Details:GetPlugin ("DETAILS_PLUGIN_DEATH_GRAPHICS")) then
		detailsOnDeathMenu.warningLabel.text = "Advanced Death Logs plugin is disabled! Please enable it (or download) in the Addon Control Panel."
		detailsOnDeathMenu.warningLabel:Show()
		C_Timer.After (5, function()
			detailsOnDeathMenu.warningLabel:Hide()
		end)
	end

	DetailsPluginContainerWindow.OnMenuClick (nil, nil, "DETAILS_PLUGIN_DEATH_GRAPHICS", true)
	
	C_Timer.After (0, function()
		local a = Details_DeathGraphsModeEnduranceButton and Details_DeathGraphsModeEnduranceButton.MyObject:Click()
	end)
	
	GameCooltip2:Hide()
end

function detailsOnDeathMenu.OpenPlayerSpells()
	
	local window1 = Details:GetWindow (1)
	local window2 = Details:GetWindow (2)
	local window3 = Details:GetWindow (3)
	local window4 = Details:GetWindow (4)
	
	local assignedRole = UnitGroupRolesAssigned ("player")
	if (assignedRole == "HEALER") then
		if (window1 and window1:GetDisplay() == 2) then
			Details:OpenPlayerDetails(1)
			
		elseif (window2 and window2:GetDisplay() == 2) then
			Details:OpenPlayerDetails(2)
			
		elseif (window3 and window3:GetDisplay() == 2) then
			Details:OpenPlayerDetails(3)
			
		elseif (window4 and window4:GetDisplay() == 2) then
			Details:OpenPlayerDetails(4)
			
		else
			Details:OpenPlayerDetails (1)
		end
	else
		if (window1 and window1:GetDisplay() == 1) then
			Details:OpenPlayerDetails(1)
			
		elseif (window2 and window2:GetDisplay() == 1) then
			Details:OpenPlayerDetails(2)
			
		elseif (window3 and window3:GetDisplay() == 1) then
			Details:OpenPlayerDetails(3)
			
		elseif (window4 and window4:GetDisplay() == 1) then
			Details:OpenPlayerDetails(4)
			
		else
			Details:OpenPlayerDetails (1)
		end
	end
	
	GameCooltip2:Hide()
end

--encounter breakdown button
detailsOnDeathMenu.breakdownButton = Details.gump:CreateButton (detailsOnDeathMenu, detailsOnDeathMenu.OpenEncounterBreakdown, 120, 20, "Encounter Breakdown", "breakdownButton")
detailsOnDeathMenu.breakdownButton:SetTemplate (Details.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
detailsOnDeathMenu.breakdownButton:SetPoint ("topleft", detailsOnDeathMenu, "topleft", 5, -5)
detailsOnDeathMenu.breakdownButton:Hide()

detailsOnDeathMenu.breakdownButton.CoolTip = {
	Type = "tooltip",
	BuildFunc = function()
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("Show a panel with:")
		GameCooltip2:AddLine ("- Player Damage Taken")
		GameCooltip2:AddLine ("- Damage Taken by Spell")
		GameCooltip2:AddLine ("- Enemy Damage Taken")
		GameCooltip2:AddLine ("- Player Deaths")
		GameCooltip2:AddLine ("- Interrupts and Dispells")
		GameCooltip2:AddLine ("- Damage Done Chart")
		GameCooltip2:AddLine ("- Damage Per Phase")
		GameCooltip2:AddLine ("- Weakauras Tool")
		
		if (not Details:GetPlugin ("DETAILS_PLUGIN_ENCOUNTER_DETAILS")) then
			GameCooltip2:AddLine ("Encounter Breakdown plugin is disabled in the Addon Control Panel.", "", 1, "red")
		end
		
	end, --> called when user mouse over the frame
	OnEnterFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = .5,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "top")
		GameCooltip:SetOption ("RelativeAnchor", "bottom")
		GameCooltip:SetOption ("WidthAnchorMod", 0)
		GameCooltip:SetOption ("HeightAnchorMod", -13)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", 220)
	end
}
GameCooltip2:CoolTipInject (detailsOnDeathMenu.breakdownButton)

--player endurance button
detailsOnDeathMenu.enduranceButton = Details.gump:CreateButton (detailsOnDeathMenu, detailsOnDeathMenu.OpenPlayerEndurance, 120, 20, "Player Endurance", "enduranceButton")
detailsOnDeathMenu.enduranceButton:SetTemplate (Details.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
detailsOnDeathMenu.enduranceButton:SetPoint ("topleft", detailsOnDeathMenu.breakdownButton, "topright", 2, 0)
detailsOnDeathMenu.enduranceButton:Hide()

detailsOnDeathMenu.enduranceButton.CoolTip = {
	Type = "tooltip",
	BuildFunc = function()
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("Open Player Endurance Breakdown")
		GameCooltip2:AddLine ("")
		GameCooltip2:AddLine ("Player endurance is calculated using the amount of player deaths.")
		GameCooltip2:AddLine ("By default the plugin register the three first player deaths on each encounter to calculate who is under performing.")
		
		--GameCooltip2:AddLine (" ")
		
		if (not Details:GetPlugin ("DETAILS_PLUGIN_DEATH_GRAPHICS")) then
			GameCooltip2:AddLine ("Advanced Death Logs plugin is disabled or not installed, check the Addon Control Panel or download it from the Twitch APP.", "", 1, "red")
		end

	end, --> called when user mouse over the frame
	OnEnterFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = .5,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "top")
		GameCooltip:SetOption ("RelativeAnchor", "bottom")
		GameCooltip:SetOption ("WidthAnchorMod", 0)
		GameCooltip:SetOption ("HeightAnchorMod", -13)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", 220)
	end
}
GameCooltip2:CoolTipInject (detailsOnDeathMenu.enduranceButton)

--spells
detailsOnDeathMenu.spellsButton = Details.gump:CreateButton (detailsOnDeathMenu, detailsOnDeathMenu.OpenPlayerSpells, 48, 20, "Spells", "SpellsButton")
detailsOnDeathMenu.spellsButton:SetTemplate (Details.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
detailsOnDeathMenu.spellsButton:SetPoint ("topleft", detailsOnDeathMenu.enduranceButton, "topright", 2, 0)
detailsOnDeathMenu.spellsButton:Hide()

detailsOnDeathMenu.spellsButton.CoolTip = {
	Type = "tooltip",
	BuildFunc = function()
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("Open your player Details! breakdown.")
		
	end, --> called when user mouse over the frame
	OnEnterFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		detailsOnDeathMenu.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = .5,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "top")
		GameCooltip:SetOption ("RelativeAnchor", "bottom")
		GameCooltip:SetOption ("WidthAnchorMod", 0)
		GameCooltip:SetOption ("HeightAnchorMod", -13)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", 220)
	end
}
GameCooltip2:CoolTipInject (detailsOnDeathMenu.spellsButton)

function detailsOnDeathMenu.CanShowPanel()
	if (StaticPopup_Visible ("DEATH")) then
		if (not Details.on_death_menu) then
			return
		end

		if (detailsOnDeathMenu.Debug) then
			return true
		end
		
		--> check if the player just wiped in an encounter
		if (IsInRaid()) then
			local isInInstance = IsInInstance()
			if (isInInstance) then
				--> check if all players in the raid are out of combat
				for i = 1, GetNumGroupMembers() do
					if (UnitAffectingCombat ("raid" .. i)) then
						C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
						return false
					end
				end
				
				if (Details.in_combat) then
					C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
					return false
				end
				
				return true
			end
		end
	end
end

function detailsOnDeathMenu.ShowPanel()
	if (not detailsOnDeathMenu.CanShowPanel()) then
		return
	end
	
	if (ElvUI) then
		detailsOnDeathMenu:SetPoint ("topleft", StaticPopup1, "bottomleft", 0, -1)
		detailsOnDeathMenu:SetPoint ("topright", StaticPopup1, "bottomright", 0, -1)
	else
		detailsOnDeathMenu:SetPoint ("topleft", StaticPopup1, "bottomleft", 4, 2)
		detailsOnDeathMenu:SetPoint ("topright", StaticPopup1, "bottomright", -4, 2)
	end
	
	detailsOnDeathMenu.breakdownButton:Show()
	detailsOnDeathMenu.enduranceButton:Show()
	detailsOnDeathMenu.spellsButton:Show()
	
	detailsOnDeathMenu:Show()
	
	detailsOnDeathMenu:SetHeight (30)
	
	if (not Details:GetTutorialCVar ("DISABLE_ONDEATH_PANEL")) then
		detailsOnDeathMenu.disableLabel:Show()
		detailsOnDeathMenu.disableLabel:SetPoint ("bottomleft", detailsOnDeathMenu, "bottomleft", 5, 1)
		detailsOnDeathMenu.disableLabel.color = "gray"
		detailsOnDeathMenu.disableLabel.alpha = 0.5
		detailsOnDeathMenu:SetHeight (detailsOnDeathMenu:GetHeight() + 10)
		
		if (math.random (1, 3) == 3) then
			Details:SetTutorialCVar ("DISABLE_ONDEATH_PANEL", true)
		end
	end
end

hooksecurefunc ("StaticPopup_Show", function (which, text_arg1, text_arg2, data, insertedFrame)
	if (which == "DEATH") then
		if (detailsOnDeathMenu.Debug) then
			C_Timer.After (0.5, detailsOnDeathMenu.ShowPanel)
		end
	end
end)

hooksecurefunc ("StaticPopup_Hide", function (which, data)
	if (which == "DEATH") then
		detailsOnDeathMenu:Hide()
	end
end)

