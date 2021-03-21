
local UnitAura = UnitAura
local UnitBuff = UnitBuff
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass
local UnitName = UnitName
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

local DF = DetailsFramework

local UnitGroupRolesAssigned = DF.UnitGroupRolesAssigned

--> build the list of buffs to track
local flask_list = DF.FlaskIDs

local is_drinking = 257428
local localizedFoodDrink

local food_list = {
	tier1 = {},
	tier2 = {},
	tier3 = {},
}

for spellID, power in pairs (DF.FoodIDs) do
	if (power == 1) then
		food_list.tier1 [spellID] = true

	elseif (power == 2) then
		food_list.tier2 [spellID] = true

	elseif (power == 3) then
		food_list.tier3 [spellID] = true

	end
end

local runes_id = DF.RuneIDs

--

local get_unit_id = function (i)
	local unitID
	
	local unitType = "raid"
	if (not IsInRaid()) then --o jogador esta em grupo
		unitType = "party"
	end
	
	if (unitType == "party") then
		if (i == GetNumGroupMembers()) then
			unitID = "player"
		else
			unitID = unitType .. i
		end
	else
		unitID = unitType .. i
	end
	
	return unitID
end

--> localization
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details")
--> create the plugin object
	local DetailsRaidCheck = _detalhes:NewPluginObject ("Details_RaidCheck", DETAILSPLUGIN_ALWAYSENABLED)
	tinsert (UISpecialFrames, "Details_RaidCheck")
	DetailsRaidCheck:SetPluginDescription (Loc ["STRING_RAIDCHECK_PLUGIN_DESC"])

	local version = "v2.0"
	
	local debugmode = false
	--local debugmode = true
	
	local CreatePluginFrames = function()
	
		--> localize details functions (localize = it doesn't need to get this through indexed metatable any more)
		DetailsRaidCheck.GetOnlyName = DetailsRaidCheck.GetOnlyName
	
		--> tables
		DetailsRaidCheck.usedprepot_table = {}
		DetailsRaidCheck.focusaug_table = {}
		DetailsRaidCheck.haveflask_table = {}
		DetailsRaidCheck.havefood_table = {}
		DetailsRaidCheck.iseating_table = {}
		DetailsRaidCheck.havefocusaug_table = {}
		
		DetailsRaidCheck.on_raid = false
		DetailsRaidCheck.tracking_buffs = false
		
		local empty_table = {}
		
		local PlayerData = {}
		local UpdateSpeed = 0.5
		
		function DetailsRaidCheck:OnDetailsEvent (event, ...)
			
			if (event == "ZONE_TYPE_CHANGED") then
			
				DetailsRaidCheck:CheckCanShowIcon (...)

			elseif (event == "COMBAT_PREPOTION_UPDATED") then

				DetailsRaidCheck.usedprepot_table, DetailsRaidCheck.focusaug_table = select (1, ...)

			elseif (event == "COMBAT_PLAYER_LEAVE") then
			
			elseif (event == "COMBAT_PLAYER_ENTER") then
				
			elseif (event == "DETAILS_STARTED") then

				localizedFoodDrink = GetSpellInfo (is_drinking)
				DetailsRaidCheck:CheckCanShowIcon()
				
			elseif (event == "PLUGIN_DISABLED") then
			
				DetailsRaidCheck.on_raid = false
				DetailsRaidCheck.tracking_buffs = false
				
				DetailsRaidCheck:StopTrackBuffs()
				
				DetailsRaidCheck:HideToolbarIcon (DetailsRaidCheck.ToolbarButton)
			
			elseif (event == "PLUGIN_ENABLED") then

				DetailsRaidCheck:CheckCanShowIcon()
				
			end
			
		end
		
		DetailsRaidCheck.ToolbarButton = _detalhes.ToolBar:NewPluginToolbarButton (DetailsRaidCheck.empty_function, [[Interface\Buttons\UI-CheckBox-Check]], Loc ["STRING_RAIDCHECK_PLUGIN_NAME"], "", 16, 16, "RAIDCHECK_PLUGIN_BUTTON")
		DetailsRaidCheck.ToolbarButton.shadow = true --> loads icon_shadow.tga when the instance is showing icons with shadows
		
		function DetailsRaidCheck.GetPlayerAmount()
			local playerAmount = GetNumGroupMembers()
			
			--limit to 20 if in mythic raid and the option is enabled
			local _, _, difficulty = GetInstanceInfo()
			if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and playerAmount > 20) then
				playerAmount = 20
			end
			
			return playerAmount
		end
		
		function DetailsRaidCheck:SetGreenIcon()
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (not lower_instance) then
				return
			end
			local instance = _detalhes:GetInstance (lower_instance)
			
			if (instance.menu_icons.shadow) then
				DetailsRaidCheck.ToolbarButton:SetNormalTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetPushedTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture ([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
				DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(.2, 1, .2)
				DetailsRaidCheck.ToolbarButton:GetHighlightTexture():SetVertexColor(.2, 1, .2)
				DetailsRaidCheck.ToolbarButton:GetDisabledTexture():SetVertexColor(.2, 1, .2)
				DetailsRaidCheck.ToolbarButton:GetPushedTexture():SetVertexColor(.2, 1, .2)
			else
				DetailsRaidCheck.ToolbarButton:SetNormalTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetPushedTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture ([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
				DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(.2, 1, .2)
				DetailsRaidCheck.ToolbarButton:GetHighlightTexture():SetVertexColor(.2, 1, .2)
				DetailsRaidCheck.ToolbarButton:GetDisabledTexture():SetVertexColor(.2, 1, .2)
				DetailsRaidCheck.ToolbarButton:GetPushedTexture():SetVertexColor(.2, 1, .2)
			end
		end
		
		function DetailsRaidCheck:SetRedIcon()
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (not lower_instance) then
				return
			end
			local instance = _detalhes:GetInstance (lower_instance)
			
			if (instance.menu_icons.shadow) then
				DetailsRaidCheck.ToolbarButton:SetNormalTexture ([[Interface\Buttons\UI-CheckBox-Check]]) --RED
				DetailsRaidCheck.ToolbarButton:SetPushedTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture ([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
				DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetHighlightTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetDisabledTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetPushedTexture():SetVertexColor(1, .6, .1)
			else
				DetailsRaidCheck.ToolbarButton:SetNormalTexture ([[Interface\Buttons\UI-CheckBox-Check]]) --RED
				DetailsRaidCheck.ToolbarButton:SetPushedTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture ([[Interface\Buttons\UI-CheckBox-Check]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture ([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
				DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetHighlightTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetDisabledTexture():SetVertexColor(1, .6, .1)
				DetailsRaidCheck.ToolbarButton:GetPushedTexture():SetVertexColor(1, .6, .1)
			end
		end

		local show_panel = CreateFrame ("frame", nil, UIParent, "BackdropTemplate")
		show_panel:SetPoint ("bottom", DetailsRaidCheck.ToolbarButton, "top", 0, 10)
		show_panel:SetClampedToScreen (true)
		show_panel:SetFrameStrata ("TOOLTIP")
		
		--
		
		--copying style from the all displays menu
		show_panel:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
		show_panel:SetBackdropColor (0.05, 0.05, 0.05, 0.3)
		show_panel.background = show_panel:CreateTexture ("DetailsAllAttributesFrameBackground111", "background")
		show_panel.background:SetDrawLayer ("background", 2)
		show_panel.background:SetPoint ("topleft", show_panel, "topleft", 4, -4)
		show_panel.background:SetPoint ("bottomright", show_panel, "bottomright", -4, 4)
		show_panel.wallpaper = show_panel:CreateTexture ("DetailsAllAttributesFrameWallPaper111", "background")
		show_panel.wallpaper:SetDrawLayer ("background", 4)
		show_panel.wallpaper:SetPoint ("topleft", show_panel, "topleft", 4, -4)
		show_panel.wallpaper:SetPoint ("bottomright", show_panel, "bottomright", -4, 4)		

		show_panel:SetBackdrop (_detalhes.menu_backdrop_config.menus_backdrop)
		show_panel:SetBackdropColor (unpack (_detalhes.menu_backdrop_config.menus_backdropcolor))
		show_panel:SetBackdropBorderColor (unpack (_detalhes.menu_backdrop_config.menus_bordercolor))
		
		--
		
		local report_string1 = show_panel:CreateFontString (nil, "overlay", "GameFontNormal")
		report_string1:SetPoint ("bottomleft", show_panel, "bottomleft", 10, 8)
		report_string1:SetText ("|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:12:12:0:1:512:512:8:70:225:307|t Report No Food/Flask  |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:12:12:0:1:512:512:8:70:328:409|t Report No Pre-Pot  |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:12:12:0:1:512:512:8:70:126:204|t Report No Rune  |  |cFFFFFFFFShift+Click: Options|r") 

		--local using_details_string1 = show_panel:CreateFontString (nil, "overlay", "GameFontNormal")
		--using_details_string1:SetPoint ("bottomleft", show_panel, "bottomleft", 10, 22)
		--using_details_string1:SetText ("Receives dynamic updates from other Details! users when they change talents and gear")
		
		DetailsRaidCheck:SetFontSize (report_string1, 10)
		DetailsRaidCheck:SetFontColor (report_string1, "white")
		report_string1:SetAlpha (0.6)
		
		--DetailsRaidCheck:SetFontSize (using_details_string1, 10)
		--DetailsRaidCheck:SetFontColor (using_details_string1, "white")
		--using_details_string1:SetAlpha (0.6)
		
		--
		
		--header and scroll
		local headerTable = {
			{text = "Player Name", width = 140},
			{text = "Talents", width = 130},
			{text = "ILevel", width = 45},
			{text = "Repair", width = 45},
			{text = "Food", width = 45},
			{text = "Flask", width = 45},
			{text = "Rune", width = 45},
			--{text = "Pre-Pot Last Try", width = 100},
			{text = "Using Details!", width = 100},
		}
		local headerOptions = {
			padding = 2,
		}
		
		DetailsRaidCheck.Header = DF:CreateHeader (show_panel, headerTable, headerOptions)
		DetailsRaidCheck.Header:SetPoint ("topleft", show_panel, "topleft", 10, -10)
		
		--options
		local scroll_width = 722
		local scroll_lines = 30
		local scroll_line_height = 16
		local scroll_height = (scroll_lines * scroll_line_height) + scroll_lines + 2
		local backdrop_color = {.2, .2, .2, 0.2}
		local backdrop_color_on_enter = {.8, .8, .8, 0.4}
		local y = -10
		local headerY = y - 2
		local scrollY = headerY - 20
		
		show_panel:SetSize (722 + 20, 565)

		function show_panel:AdjustHeight(height)
			show_panel:SetHeight (height or 565)
		end
		
		--create line for the scroll
		local scroll_createline = function (self, index)
		
			local line = CreateFrame ("button", "$parentLine" .. index, self, "BackdropTemplate")
			line:SetPoint ("topleft", self, "topleft", 1, -((index-1)*(scroll_line_height+1)) - 1)
			line:SetSize (scroll_width - 2, scroll_line_height)
			line:SetScript ("OnEnter", line_onenter)
			line:SetScript ("OnLeave", line_onleave)
			
			line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor (unpack (backdrop_color))
			
			DF:Mixin (line, DetailsFramework.HeaderFunctions)
			
			--role icon
			local roleIcon = DF:CreateImage (line, nil, scroll_line_height, scroll_line_height)
			
			--spec icon
			local specIcon = DF:CreateImage (line, nil, scroll_line_height, scroll_line_height)
				specIcon:SetPoint ("left", roleIcon, "right", 2, 0)

			--covenant icon
			local covenantIcon = DF:CreateImage (line, nil, scroll_line_height, scroll_line_height)
				covenantIcon:SetPoint ("left", specIcon, "right", 2, 0)
				
			--player name
			local playerName = DF:CreateLabel (line)
				playerName:SetPoint ("left", covenantIcon, "right", 2, 0)
			
			--talents
			local talent_row_options = {
				icon_width = 16,
				icon_height = 16,
				texcoord = {.1, .9, .1, .9},
				show_text = false,
				icon_padding = 2,
			}
			local talentsRow = DF:CreateIconRow (line, "$parentTalentIconsRow", talent_row_options)
			
			--item level
			local itemLevel = DF:CreateLabel(line)
			--repair status
			local repairStatus = DF:CreateLabel(line)
			--no food
			local FoodIndicator = DF:CreateImage(line, "", scroll_line_height, scroll_line_height)
			--no flask
			local FlaskIndicator = DF:CreateImage(line, "", scroll_line_height, scroll_line_height)
			--no rune
			local RuneIndicator = DF:CreateImage(line, "", scroll_line_height, scroll_line_height)
			--no pre pot
			--local PrePotIndicator = DF:CreateImage (line, "", scroll_line_height, scroll_line_height)
			--using details!
			local DetailsIndicator = DF:CreateImage(line, "", scroll_line_height, scroll_line_height)
			
			line:AddFrameToHeaderAlignment(roleIcon)
			line:AddFrameToHeaderAlignment(talentsRow)
			line:AddFrameToHeaderAlignment(itemLevel)
			line:AddFrameToHeaderAlignment(repairStatus)
			line:AddFrameToHeaderAlignment(FoodIndicator)
			line:AddFrameToHeaderAlignment(FlaskIndicator)
			line:AddFrameToHeaderAlignment(RuneIndicator)
			--line:AddFrameToHeaderAlignment(PrePotIndicator)
			line:AddFrameToHeaderAlignment(DetailsIndicator)
			
			line:AlignWithHeader (DetailsRaidCheck.Header, "left")
			
			line.CovenantIcon = covenantIcon
			line.RoleIcon = roleIcon
			line.SpecIcon = specIcon
			line.PlayerName = playerName
			line.TalentsRow = talentsRow
			line.ItemLevel = itemLevel
			line.RepairStatus = repairStatus
			line.FoodIndicator = FoodIndicator
			line.FlaskIndicator = FlaskIndicator
			line.RuneIndicator = RuneIndicator
			--line.PrePotIndicator = PrePotIndicator
			line.DetailsIndicator = DetailsIndicator
			
			return line
		end
		
		--refresh scroll
		local has_food_icon = {texture = [[Interface\Scenarios\ScenarioIcon-Check]], coords = {0, 1, 0, 1}}
		local eating_food_icon = {texture = [[Interface\AddOns\Details\images\icons]], coords = {225/512, 249/512, 35/512, 63/512}}
		
		local scroll_refresh = function (self, data, offset, total_lines)
			
			local dataInOrder = {}

			for i = 1, #data do
				dataInOrder [#dataInOrder+1] = data [i]
			end

			table.sort (dataInOrder, DF.SortOrder2)
			--table.sort (dataInOrder, DF.SortOrder1R) --alphabetical
			data = dataInOrder

			local raidStatusLib = LibStub:GetLibrary("LibRaidStatus-1.0")
			local playerInfo = raidStatusLib.playerInfoManager.GetPlayerInfo()
			local gearInfo = raidStatusLib.gearManager.GetGearTable()

			local libRaidStatus = 0
		
			for i = 1, total_lines do
				local index = i + offset
				local playerTable = data [index]
				
				if (playerTable) then
					local line = self:GetLine (i)
					if (line) then
						
						local thisPlayerInfo = playerInfo[playerTable.UnitNameRealm]
						if (thisPlayerInfo) then
							local playerCovenantId = thisPlayerInfo.covenantId
							if (playerCovenantId > 0) then
								line.CovenantIcon:SetTexture(LIB_RAID_STATUS_COVENANT_ICONS[playerCovenantId])
								line.CovenantIcon:SetTexCoord(.05, .95, .05, .95)
							else
								line.CovenantIcon:SetTexture("")
							end
						else
							line.CovenantIcon:SetTexture("")
						end

						--repair status
						local thisPlayerGearInfo = gearInfo[playerTable.UnitNameRealm]
						if (thisPlayerGearInfo) then
							line.RepairStatus:SetText(thisPlayerGearInfo.durability .. "%")
						else
							line.RepairStatus:SetText("")
						end
						
						local roleTexture, L, R, T, B = _detalhes:GetRoleIcon(playerTable.Role or "NONE")
						
						line.RoleIcon:SetTexture(roleTexture)
						line.RoleIcon:SetTexCoord(L, R, T, B)
						
						if (playerTable.Spec) then
							local texture, L, R, T, B = _detalhes:GetSpecIcon(playerTable.Spec)
							line.SpecIcon:SetTexture(texture)
							line.SpecIcon:SetTexCoord(L, R, T, B)
						else
							local texture, L, R, T, B = _detalhes:GetClassIcon(playerTable.Class)
							line.SpecIcon:SetTexture (texture)
							line.SpecIcon:SetTexCoord (L, R, T, B)
						end
						
						line.TalentsRow:ClearIcons()
						
						if (playerTable.Talents) then
							for i = 1, #playerTable.Talents do
								local talent = playerTable.Talents [i]
								local talentID, name, texture, selected, available = GetTalentInfoByID(talent)
								line.TalentsRow:SetIcon(false, false, false, false, texture)
							end
						end

						local classColor = Details.class_colors [playerTable.Class]
						if (classColor) then
							line:SetBackdropColor (unpack (classColor))
						else
							line:SetBackdropColor (unpack (backdrop_color))
						end
						
						line.PlayerName.text = playerTable.Name
						line.ItemLevel.text = floor (playerTable.ILevel and playerTable.ILevel.ilvl or 0)
						
						if (playerTable.Food) then
							line.FoodIndicator.texture = has_food_icon.texture
							line.FoodIndicator.texcoord = has_food_icon.coords
							
						elseif (playerTable.Eating) then
							line.FoodIndicator.texture = eating_food_icon.texture
							line.FoodIndicator.texcoord = eating_food_icon.coords
							
						else
							line.FoodIndicator.texture = ""
						end
						
						line.FlaskIndicator.texture = playerTable.Flask and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
						line.RuneIndicator.texture = playerTable.Rune and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
						--line.PrePotIndicator.texture = playerTable.PrePot and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
						line.DetailsIndicator.texture = playerTable.UseDetails and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
					end
				end
			end
			
		end
		
		--create scroll
		local mainScroll = DF:CreateScrollBox (show_panel, "$parentMainScroll", scroll_refresh, PlayerData, 1, 1, scroll_lines, scroll_line_height)
		DF:ReskinSlider (mainScroll)
		mainScroll.HideScrollBar = true
		mainScroll:SetPoint ("topleft", show_panel, "topleft", 10, scrollY)
		mainScroll:SetPoint ("bottomright", show_panel, "bottomright", -10, 20)
		mainScroll:Refresh()
		
		--create lines
		for i = 1, scroll_lines do 
			mainScroll:CreateLine (scroll_createline)
		end
		
		show_panel:Hide()
		
		DetailsRaidCheck.report_lines = ""
		local reportFunc = function (IsCurrent, IsReverse, AmtLines)
			DetailsRaidCheck:SendReportLines (DetailsRaidCheck.report_lines)
		end
		
		--> overwrite the default scripts
		DetailsRaidCheck.ToolbarButton:RegisterForClicks ("AnyUp")
		DetailsRaidCheck.ToolbarButton:SetScript ("OnClick", function (self, button)
			
			if (IsShiftKeyDown()) then
				DetailsRaidCheck.OpenOptionsPanel()
				return
			end
			
			if (button == "LeftButton") then
				--> link no food/flask
				local s, added = "Details!: No Flask or Food: ", {}
				
				local amt = GetNumGroupMembers()
				local _, _, difficulty = GetInstanceInfo()
				if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and amt > 20) then
					amt = 20
				end
				
				for i = 1, amt, 1 do
					local unitID = get_unit_id (i)
					
					local name = UnitName (unitID)
					local unitSerial = UnitGUID (unitID)
					
					if (not DetailsRaidCheck.havefood_table [unitSerial]) then
						added [unitSerial] = true
						s = s .. DetailsRaidCheck:GetOnlyName (name) .. " "
					end
					
					if (not DetailsRaidCheck.haveflask_table [unitSerial] and not added [unitSerial]) then
						s = s .. DetailsRaidCheck:GetOnlyName (name) .. " "
					end
				end
				
				if (DetailsRaidCheck.db.use_report_panel) then
					DetailsRaidCheck.report_lines = s
					DetailsRaidCheck:SendReportWindow (reportFunc)
				else
					if (IsInRaid()) then
						DetailsRaidCheck:SendMsgToChannel (s, "RAID")
					else
						DetailsRaidCheck:SendMsgToChannel (s, "PARTY")
					end
				end
				
			elseif (button == "RightButton") then
				--> link no pre-pot latest segment
				
				local s = "Details!: No Pre-Pot Last Try: "
				
				local amt = GetNumGroupMembers()
				local _, _, difficulty = GetInstanceInfo()
				if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and amt > 20) then
					amt = 20
				end
				
				for i = 1, amt, 1 do
				
					local unitID = get_unit_id (i)
					local role = UnitGroupRolesAssigned (unitID)
			
					if (role == "DAMAGER" or (role == "HEALER" and DetailsRaidCheck.db.pre_pot_healers) or (role == "TANK" and DetailsRaidCheck.db.pre_pot_tanks)) then
				
						local playerName, realmName = UnitName (unitID)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						if (not DetailsRaidCheck.usedprepot_table [playerName]) then
							s = s .. DetailsRaidCheck:GetOnlyName (playerName) .. " "
						end
					
					end
				end
				
				if (DetailsRaidCheck.db.use_report_panel) then
					DetailsRaidCheck.report_lines = s
					DetailsRaidCheck:SendReportWindow (reportFunc)
				else
					if (IsInRaid()) then
						DetailsRaidCheck:SendMsgToChannel (s, "RAID")
					else
						DetailsRaidCheck:SendMsgToChannel (s, "PARTY")
					end
				end
			
			elseif (button == "MiddleButton") then
				--report focus aug
				local s = "Details!: Not using Rune: "
				
				local amt = GetNumGroupMembers()
				local _, _, difficulty = GetInstanceInfo()
				if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and amt > 20) then
					amt = 20
				end
				
				for i = 1, amt do
					local unitID = get_unit_id (i)
					
					local name = UnitName (unitID)
					local unitSerial = UnitGUID (unitID)
					
					if (not DetailsRaidCheck.havefocusaug_table [unitSerial]) then
						s = s .. DetailsRaidCheck:GetOnlyName (name) .. " "
					end
				end
				
				if (DetailsRaidCheck.db.use_report_panel) then
					DetailsRaidCheck.report_lines = s
					DetailsRaidCheck:SendReportWindow (reportFunc)
				else
					if (IsInRaid()) then
						DetailsRaidCheck:SendMsgToChannel (s, "RAID")
					else
						DetailsRaidCheck:SendMsgToChannel (s, "PARTY")
					end
				end
			
			end
			
		end)

		local update_panel = function (self, elapsed)
			show_panel.NextUpdate = show_panel.NextUpdate - elapsed
			
			if (show_panel.NextUpdate > 0) then
				return
			end

			show_panel.NextUpdate = UpdateSpeed
			
			if (not IsInRaid() and not IsInGroup()) then
				return
			end
			
			wipe (PlayerData)

			local groupTypeID = IsInRaid() and "raid" or "party"
			
			local playerAmount = DetailsRaidCheck.GetPlayerAmount()
			local iterateAmount = playerAmount
			if (not IsInRaid()) then
				iterateAmount = iterateAmount - 1
			end
			
			for i = 1, iterateAmount do
				local unitID = groupTypeID .. i
				local unitName = UnitName (unitID)
				local unitNameWithRealm = GetUnitName(unitID, true)
				local cleuName = _detalhes:GetCLName (unitID)
				local unitSerial = UnitGUID (unitID)
				local _, unitClass, unitClassID = UnitClass (unitID)
				local unitRole = UnitGroupRolesAssigned (unitID)
				local unitSpec = _detalhes:GetSpecFromSerial (unitSerial) or _detalhes:GetSpec (cleuName)
				local itemLevelTable = _detalhes.ilevel:GetIlvl (unitSerial)
				local talentsTable = _detalhes:GetTalents (unitSerial)

				--> order by class > alphabetically by the unit name
				unitClassID = (((unitClassID or 0) + 128) ^ 4) + tonumber (string.byte (unitName, 1) .. "" .. string.byte (unitName, 2))
				
				tinsert (PlayerData, {unitName, unitClassID,
					Name = unitName,
					UnitNameRealm = unitNameWithRealm,
					Class = unitClass,
					Serial = unitSerial,
					Role = unitRole,
					Spec = unitSpec,
					ILevel = itemLevelTable,
					Talents = talentsTable,
					Food = DetailsRaidCheck.havefood_table [unitSerial],
					Flask = DetailsRaidCheck.haveflask_table [unitSerial],
					PrePot = DetailsRaidCheck.usedprepot_table [cleuName],
					Rune = DetailsRaidCheck.havefocusaug_table [unitSerial],
					Eating = DetailsRaidCheck.iseating_table [unitSerial],
					UseDetails = Details.trusted_characters [unitSerial],
				})
			end
			
			if (not IsInRaid()) then
				--> add the player data
				local unitID = "player"
				
				local unitName = UnitName (unitID)
				local cleuName = _detalhes:GetCLName (unitID)
				local unitSerial = UnitGUID (unitID)
				local _, unitClass, unitClassID = UnitClass (unitID)
				local unitRole = UnitGroupRolesAssigned (unitID)
				local unitSpec = _detalhes:GetSpecFromSerial (unitSerial) or _detalhes:GetSpec (cleuName)
				local itemLevelTable = _detalhes.ilevel:GetIlvl (unitSerial)
				local talentsTable = _detalhes:GetTalents (unitSerial)

				unitClassID = ((unitClassID + 128) ^ 4) + tonumber (string.byte (unitName, 1) .. "" .. string.byte (unitName, 2))
				
				tinsert (PlayerData, {unitName, unitClassID,
					Name = unitName,
					Class = unitClass,
					Serial = unitSerial,
					Role = unitRole,
					Spec = unitSpec,
					ILevel = itemLevelTable,
					Talents = talentsTable,
					Food = DetailsRaidCheck.havefood_table [unitSerial],
					Flask = DetailsRaidCheck.haveflask_table [unitSerial],
					PrePot = DetailsRaidCheck.usedprepot_table [cleuName],
					Rune = DetailsRaidCheck.havefocusaug_table [unitSerial],
					Eating = DetailsRaidCheck.iseating_table [unitSerial],
					UseDetails = Details.trusted_characters [unitSerial],
				})
			end

			mainScroll:Refresh()

			local height = (playerAmount * scroll_line_height) + 75
			show_panel:AdjustHeight(height)

		end
		
		DetailsRaidCheck.ToolbarButton:SetScript ("OnEnter", function (self)
			show_panel:Show()
			show_panel:ClearAllPoints()
			show_panel:SetPoint ("bottom", DetailsRaidCheck.ToolbarButton, "top", 0, 10)
			show_panel.NextUpdate = UpdateSpeed
			update_panel (show_panel, 1)
			show_panel:SetScript ("OnUpdate", update_panel)
			DetailsRaidCheck:StartTrackBuffs()
		end)
		
		DetailsRaidCheck.ToolbarButton:SetScript ("OnLeave", function (self)
			show_panel:SetScript ("OnUpdate", nil)
			show_panel:Hide()
			DetailsRaidCheck:StopTrackBuffs()
			DetailsRaidCheck:StartTrackBuffs(5.0)
		end)
		
		function DetailsRaidCheck:CheckCanShowIcon(...)
			local isInRaid = IsInRaid()
			local isInGroup = IsInGroup()
			
			if (isInRaid or isInGroup) then
				DetailsRaidCheck:ShowToolbarIcon (DetailsRaidCheck.ToolbarButton, "star")
				DetailsRaidCheck.on_raid = true
				DetailsRaidCheck:StartTrackBuffs(5.0)
			else
				DetailsRaidCheck:HideToolbarIcon (DetailsRaidCheck.ToolbarButton)
				DetailsRaidCheck.on_raid = false
				if (DetailsRaidCheck.UpdateBuffsTick and not DetailsRaidCheck.UpdateBuffsTick._cancelled) then
					DetailsRaidCheck.UpdateBuffsTick:Cancel()
				end
			end
		end
		
		function DetailsRaidCheck:CheckUnitBuffs (unitID, consumableTable)
			local name = UnitName (unitID)
			local unitSerial = UnitGUID (unitID)
		
			for buffIndex = 1, 40 do
				local bname, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellid = UnitBuff (unitID, buffIndex)
				
				if (bname) then
					if (flask_list [spellid]) then
						DetailsRaidCheck.haveflask_table [unitSerial] = spellid
						consumableTable.Flask = consumableTable.Flask + 1
					end
					
					if (DetailsRaidCheck.db.food_tier1) then
						if (food_list.tier1 [spellid]) then
							DetailsRaidCheck.havefood_table [unitSerial] = 1
							consumableTable.Food = consumableTable.Food + 1
						end
					end
					
					if (DetailsRaidCheck.db.food_tier2) then
						if (food_list.tier2 [spellid]) then
							DetailsRaidCheck.havefood_table [unitSerial] = 2
							consumableTable.Food = consumableTable.Food + 1
						end
					end
					
					if (DetailsRaidCheck.db.food_tier3) then
						if (food_list.tier3 [spellid]) then
							DetailsRaidCheck.havefood_table [unitSerial] = 3
							consumableTable.Food = consumableTable.Food + 1
						end
					end
					
					if (runes_id [spellid]) then
						DetailsRaidCheck.havefocusaug_table [unitSerial] = spellid
					end
					
					if (bname == localizedFoodDrink) then
						DetailsRaidCheck.iseating_table [unitSerial] = true
					end
				else
					break
				end
			end
		end
		
		function DetailsRaidCheck:BuffTrackTick()
			wipe (DetailsRaidCheck.haveflask_table)
			wipe (DetailsRaidCheck.havefood_table)
			wipe (DetailsRaidCheck.havefocusaug_table)
			wipe (DetailsRaidCheck.iseating_table)
			
			local hasConsumables = {
				Flask = 0,
				Food = 0,
			}
			
			local playerAmount = DetailsRaidCheck.GetPlayerAmount()

			if (IsInRaid()) then
				for i = 1, playerAmount do
					local unitId = "raid" .. i
					DetailsRaidCheck:CheckUnitBuffs(unitId, hasConsumables)
				end

			elseif (IsInGroup()) then
				for i = 1, playerAmount-1 do
					local unitId = "party" .. i
					DetailsRaidCheck:CheckUnitBuffs(unitId, hasConsumables)
				end
				DetailsRaidCheck:CheckUnitBuffs ("player", hasConsumables)
			end

			if (hasConsumables.Food == playerAmount and hasConsumables.Flask == playerAmount) then
				DetailsRaidCheck:SetGreenIcon()
			else
				DetailsRaidCheck:SetRedIcon()
			end
		end
		
		function DetailsRaidCheck:StartTrackBuffs(customUpdateSpeed)
			if (not DetailsRaidCheck.tracking_buffs) then
				DetailsRaidCheck.tracking_buffs = true
				
				DetailsRaidCheck:BuffTrackTick()
				
				if (DetailsRaidCheck.UpdateBuffsTick and not DetailsRaidCheck.UpdateBuffsTick._cancelled) then
					DetailsRaidCheck.UpdateBuffsTick:Cancel()
				end

				if (customUpdateSpeed) then
					DetailsRaidCheck.UpdateBuffsTick = C_Timer.NewTicker (customUpdateSpeed-0.01, DetailsRaidCheck.BuffTrackTick)
				else
					DetailsRaidCheck.UpdateBuffsTick = C_Timer.NewTicker (UpdateSpeed-0.01, DetailsRaidCheck.BuffTrackTick)
				end
			end
			
		end
		
		function DetailsRaidCheck:StopTrackBuffs()
			DetailsRaidCheck.tracking_buffs = false
			if (DetailsRaidCheck.UpdateBuffsTick and not DetailsRaidCheck.UpdateBuffsTick._cancelled) then
				DetailsRaidCheck.UpdateBuffsTick:Cancel()
			end
		end

	end

local build_options_panel = function()

	local options_frame = DetailsRaidCheck:CreatePluginOptionsFrame ("DetailsRaidCheckOptionsWindow", "Details! Raid Check Options", 1)

	local menu = {
	
		{type = "label", get = function() return "General Settings:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.pre_pot_healers end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.pre_pot_healers = value end,
			desc = "If enabled, pre potion for healers are also shown.",
			name = "Track Healers Pre Pot"
		},
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.pre_pot_tanks end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.pre_pot_tanks = value end,
			desc = "If enabled, pre potion for tanks are also shown.",
			name = "Track Tank Pre Pot"
		},
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.mythic_1_4 end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.mythic_1_4 = value end,
			desc = "When raiding on Mythic difficult, only check the first 4 groups.",
			name = "Mythic 1-4 Group Only"
		},
		
		--[=[
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.use_report_panel end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.use_report_panel = value end,
			desc = "If enabled, clicking to report open the report panel instead (to be able to choose where to send the report).",
			name = "Use Report Panel"
		},
		--]=]
		
		{type = "breakline"},
		
		{type = "label", get = function() return "Food Level Tracking:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.food_tier1 end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.food_tier1 = value end,
			desc = "Consider players using Tier 1 food.",
			name = "Food Tier 1 [41]"
		},
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.food_tier2 end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.food_tier2 = value end,
			desc = "Consider players using Tier 2 food.",
			name = "Food Tier 2 [55]"
		},
		{
			type = "toggle",
			get = function() return DetailsRaidCheck.db.food_tier3 end,
			set = function (self, fixedparam, value) DetailsRaidCheck.db.food_tier3 = value end,
			desc = "Consider players using Tier 3 food.",
			name = "Food Tier 3 [>= 75]"
		},
	}
	
	local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	_detalhes.gump:BuildMenu (options_frame, menu, 15, -45, 180, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

end

DetailsRaidCheck.OpenOptionsPanel = function()
	if (not DetailsRaidCheckOptionsWindow) then
		build_options_panel()
	end
	DetailsRaidCheckOptionsWindow:Show()
end
	
	function DetailsRaidCheck:OnEvent (_, event, ...)

		if (event == "GROUP_ROSTER_UPDATE") then
			if (DetailsRaidCheck.RosterDelay < GetTime()) then
				DetailsRaidCheck:CheckCanShowIcon()
				DetailsRaidCheck.RosterDelay = GetTime()+2
			end

		elseif (event == "ADDON_LOADED") then
			local AddonName = select (1, ...)
			if (AddonName == "Details_RaidCheck") then
				
				if (_G._detalhes) then

					if (DetailsFramework.IsClassicWow()) then
						return
					end
				
					--> create widgets
					CreatePluginFrames()

					--> core version required
					local MINIMAL_DETAILS_VERSION_REQUIRED = 20
					
					local default_settings = {
						pre_pot_healers = false, --do not report pre pot for healers
						pre_pot_tanks = false, --do not report pre pot for tanks
						mythic_1_4 = true, --only track groups 1-4 on mythic
						use_report_panel = true, --if true, shows the report panel
						
						food_tier1 = true, --legion food tiers
						food_tier2 = true,
						food_tier3 = true,
					}

					DetailsRaidCheck.RosterDelay = GetTime()
					
					--make it load after the other plugins
					C_Timer.After(1, function()
						--> install
						local install, saveddata, is_enabled = _G._detalhes:InstallPlugin ("TOOLBAR", Loc ["STRING_RAIDCHECK_PLUGIN_NAME"], [[Interface\Buttons\UI-CheckBox-Check]], DetailsRaidCheck, "DETAILS_PLUGIN_RAIDCHECK", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", version, default_settings)
						if (type (install) == "table" and install.error) then
							return print (install.error)
						end
						
						--> register needed events
						_G._detalhes:RegisterEvent (DetailsRaidCheck, "COMBAT_PLAYER_LEAVE")
						_G._detalhes:RegisterEvent (DetailsRaidCheck, "COMBAT_PLAYER_ENTER")
						_G._detalhes:RegisterEvent (DetailsRaidCheck, "COMBAT_PREPOTION_UPDATED")
						_G._detalhes:RegisterEvent (DetailsRaidCheck, "ZONE_TYPE_CHANGED")

						DetailsRaidCheck.Frame:RegisterEvent ("GROUP_ROSTER_UPDATE")
					end)
				end
			end
		end
	end	
	
-- doo
