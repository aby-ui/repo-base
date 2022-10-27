
--do not load if this is a classic version of the game
if (DetailsFramework.IsTBCWow() or DetailsFramework.IsWotLKWow()) then
	return
end

local UnitAura = UnitAura
local UnitBuff = UnitBuff
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass
local UnitName = UnitName
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")
local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
local DF = DetailsFramework
local UnitGroupRolesAssigned = DF.UnitGroupRolesAssigned
local version = "95"

--build the list of buffs to track
local flaskList = LIB_OPEN_RAID_FLASK_BUFF
local runeIds = DF.RuneIDs
local isDrinking = 257428
local localizedFoodDrink

local foodList = { --list for previous dragonflight expsansions
	tier1 = {},
	tier2 = {},
	tier3 = {},
}

local foodInfoList = {} --list for dragonflight and beyond

local getUnitId = function(i)
	local unitId
	local unitType = "raid"
	if (not IsInRaid()) then
		unitType = "party"
	end

	if (unitType == "party") then
		if (i == GetNumGroupMembers()) then
			unitId = "player"
		else
			unitId = unitType .. i
		end
	else
		unitId = unitType .. i
	end

	return unitId
end

--create the plugin object
local DetailsRaidCheck = Details:NewPluginObject("Details_RaidCheck", DETAILSPLUGIN_ALWAYSENABLED)
tinsert(UISpecialFrames, "Details_RaidCheck")
DetailsRaidCheck:SetPluginDescription(Loc ["STRING_RAIDCHECK_PLUGIN_DESC"])

local CreatePluginFrames = function()
	--build food tier list
	if (DF.IsDragonflightAndBeyond()) then
		--{tier = {[220] = 1}, status = {"haste"}, localized = {STAT_HASTE}}
		for spellId, foodInfo in pairs(LIB_OPEN_RAID_FOOD_BUFF) do
			foodInfoList[spellId] = foodInfo
		end
	else
		for spellId, tier in pairs(LIB_OPEN_RAID_FOOD_BUFF) do
			if (tier == 1) then
				foodList.tier1[spellId] = true

			elseif (tier == 2) then
				foodList.tier2[spellId] = true

			elseif (tier == 3) then
				foodList.tier3[spellId] = true
			end
		end
	end

	DetailsRaidCheck.GetOnlyName = DetailsRaidCheck.GetOnlyName

	--tables
	DetailsRaidCheck.usedprepot_table = {}
	DetailsRaidCheck.focusaug_table = {}
	DetailsRaidCheck.unitsWithFlaskTable = {}
	DetailsRaidCheck.unitWithFoodTable = {}
	DetailsRaidCheck.iseating_table = {}
	DetailsRaidCheck.havefocusaug_table = {}

	DetailsRaidCheck.on_raid = false
	local PlayerData = {}
	local UpdateSpeed = 0.5

	function DetailsRaidCheck:OnDetailsEvent(event, ...)
		if (event == "ZONE_TYPE_CHANGED") then
			DetailsRaidCheck:CheckCanShowIcon (...)

		elseif (event == "COMBAT_PREPOTION_UPDATED") then
			DetailsRaidCheck.usedprepot_table, DetailsRaidCheck.focusaug_table = select(1, ...)

		elseif (event == "COMBAT_PLAYER_LEAVE") then

		elseif (event == "COMBAT_PLAYER_ENTER") then

		elseif (event == "DETAILS_STARTED") then
			localizedFoodDrink = GetSpellInfo(isDrinking)
			DetailsRaidCheck:CheckCanShowIcon()

		elseif (event == "PLUGIN_DISABLED") then
			DetailsRaidCheck.on_raid = false
			DetailsRaidCheck:HideToolbarIcon(DetailsRaidCheck.ToolbarButton)

		elseif (event == "PLUGIN_ENABLED") then
			DetailsRaidCheck:CheckCanShowIcon()
		end
	end

	DetailsRaidCheck.ToolbarButton = Details.ToolBar:NewPluginToolbarButton(DetailsRaidCheck.empty_function, [[Interface\Buttons\UI-CheckBox-Check]], Loc ["STRING_RAIDCHECK_PLUGIN_NAME"], "", 16, 16, "RAIDCHECK_PLUGIN_BUTTON")
	DetailsRaidCheck.ToolbarButton.shadow = true

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
		local lowerInstanceId = Details:GetLowerInstanceNumber()
		if (not lowerInstanceId) then
			return
		end
		local instance = Details:GetInstance(lowerInstanceId)

		if (instance.menu_icons.shadow) then
			DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
			DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(.2, 1, .2)
			DetailsRaidCheck.ToolbarButton:GetHighlightTexture():SetVertexColor(.2, 1, .2)
			DetailsRaidCheck.ToolbarButton:GetDisabledTexture():SetVertexColor(.2, 1, .2)
			DetailsRaidCheck.ToolbarButton:GetPushedTexture():SetVertexColor(.2, 1, .2)
		else
			DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
			DetailsRaidCheck.ToolbarButton:GetNormalTexture():SetVertexColor(.2, 1, .2)
			DetailsRaidCheck.ToolbarButton:GetHighlightTexture():SetVertexColor(.2, 1, .2)
			DetailsRaidCheck.ToolbarButton:GetDisabledTexture():SetVertexColor(.2, 1, .2)
			DetailsRaidCheck.ToolbarButton:GetPushedTexture():SetVertexColor(.2, 1, .2)
		end
	end

	function DetailsRaidCheck:SetRedIcon()
		local lowerInstanceId = Details:GetLowerInstanceNumber()
		if (not lowerInstanceId) then
			return
		end
		local instance = Details:GetInstance(lowerInstanceId)

		if (instance.menu_icons.shadow) then
			DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
		else
			DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\Buttons\UI-CheckBox-Check]])
			DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Check]], "ADD")
		end
	end

	local raidCheckFrame = CreateFrame("frame", nil, UIParent, "BackdropTemplate")
	raidCheckFrame:SetPoint("bottom", DetailsRaidCheck.ToolbarButton, "top", 0, 10)
	raidCheckFrame:SetClampedToScreen(true)
	raidCheckFrame:SetFrameStrata("TOOLTIP")

	raidCheckFrame.background = raidCheckFrame:CreateTexture("DetailsAllAttributesFrameBackground111", "background")
	raidCheckFrame.background:SetDrawLayer("background", 2)
	raidCheckFrame.background:SetPoint("topleft", raidCheckFrame, "topleft", 4, -4)
	raidCheckFrame.background:SetPoint("bottomright", raidCheckFrame, "bottomright", -4, 4)

	raidCheckFrame.wallpaper = raidCheckFrame:CreateTexture("DetailsAllAttributesFrameWallPaper111", "background")
	raidCheckFrame.wallpaper:SetDrawLayer("background", 4)
	raidCheckFrame.wallpaper:SetPoint("topleft", raidCheckFrame, "topleft", 4, -4)
	raidCheckFrame.wallpaper:SetPoint("bottomright", raidCheckFrame, "bottomright", -4, 4)		

	raidCheckFrame:SetBackdrop(Details.menu_backdrop_config.menus_backdrop)
	raidCheckFrame:SetBackdropColor(unpack(Details.menu_backdrop_config.menus_backdropcolor))
	raidCheckFrame:SetBackdropBorderColor(unpack(Details.menu_backdrop_config.menus_bordercolor))

	local reportString1 = raidCheckFrame:CreateFontString(nil, "overlay", "GameFontNormal")
	reportString1:SetPoint("bottomleft", raidCheckFrame, "bottomleft", 10, 8)
	reportString1:SetText("|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:12:12:0:1:512:512:8:70:225:307|t Report No Food/Flask  |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:12:12:0:1:512:512:8:70:328:409|t Report No Pre-Pot  |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:12:12:0:1:512:512:8:70:126:204|t Report No Rune  |  |cFFFFFFFFShift+Click: Options|r") 

	DetailsRaidCheck:SetFontSize(reportString1, 10)
	DetailsRaidCheck:SetFontColor(reportString1, "white")
	reportString1:SetAlpha(0.6)

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
		--{text = "Using Details!", width = 100},
	}
	local headerOptions = {
		padding = 2,
	}

	DetailsRaidCheck.Header = DF:CreateHeader(raidCheckFrame, headerTable, headerOptions)
	DetailsRaidCheck.Header:SetPoint("topleft", raidCheckFrame, "topleft", 10, -10)

	--options
	local scrollWidth = 722
	local scrollLinesAmount = 30
	local scrollLineHeight = 16
	local scroll_height = (scrollLinesAmount * scrollLineHeight) + scrollLinesAmount + 2
	local backdrop_color = {.2, .2, .2, 0.2}
	local backdrop_color_on_enter = {.8, .8, .8, 0.4}
	local y = -10
	local headerY = y - 2
	local scrollY = headerY - 20

	raidCheckFrame:SetSize(722 + 20, 565)

	function raidCheckFrame:AdjustHeight(height)
		raidCheckFrame:SetHeight(height or 565)
	end

	--create line for the scroll
	local scrollCreateLine = function(self, index)
		local line = CreateFrame("button", "$parentLine" .. index, self, "BackdropTemplate")
		line:SetPoint("topleft", self, "topleft", 1, -((index-1) * (scrollLineHeight + 1)) - 1)
		line:SetSize(scrollWidth - 2, scrollLineHeight)

		line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		line:SetBackdropColor(unpack(backdrop_color))

		DF:Mixin(line, DetailsFramework.HeaderFunctions)

		--role icon
		local roleIcon = DF:CreateImage(line, nil, scrollLineHeight, scrollLineHeight)

		--spec icon
		local specIcon = DF:CreateImage(line, nil, scrollLineHeight, scrollLineHeight)
		specIcon:SetPoint("left", roleIcon, "right", 2, 0)

		--covenant icon
		local covenantIcon = DF:CreateImage(line, nil, scrollLineHeight, scrollLineHeight)
		covenantIcon:SetPoint("left", specIcon, "right", 2, 0)

		--player name
		local playerName = DF:CreateLabel(line)
		playerName:SetPoint("left", covenantIcon, "right", 2, 0)

		--talents
		local talentRowOptions = {
			icon_width = 16,
			icon_height = 16,
			texcoord = {.1, .9, .1, .9},
			show_text = false,
			icon_padding = 2,
		}
		local talentsRow = DF:CreateIconRow(line, "$parentTalentIconsRow", talentRowOptions)

		--item level
		local itemLevel = DF:CreateLabel(line)

		--repair status
		local repairStatus = DF:CreateLabel(line)

		--no food
		local foodIndicator = DF:CreateImage(line, "", scrollLineHeight, scrollLineHeight)
		local foodTierIndicator = DF:CreateLabel(line, "", 12, "white")
		foodTierIndicator:SetPoint("left", foodIndicator, "right", 6, 0)

		--no flask
		local flaskIndicator = DF:CreateImage(line, "", scrollLineHeight, scrollLineHeight)
		local flaskTierIndicator = DF:CreateLabel(line, "", 12, "white")
		flaskTierIndicator:SetPoint("left", flaskIndicator, "right", 6, 0)

		--no rune
		local runeIndicator = DF:CreateImage(line, "", scrollLineHeight, scrollLineHeight)

		--no pre pot
		--local PrePotIndicator = DF:CreateImage (line, "", scroll_line_height, scroll_line_height)
		--using details!
		--local DetailsIndicator = DF:CreateImage(line, "", scroll_line_height, scroll_line_height)

		line:AddFrameToHeaderAlignment(roleIcon)
		line:AddFrameToHeaderAlignment(talentsRow)
		line:AddFrameToHeaderAlignment(itemLevel)
		line:AddFrameToHeaderAlignment(repairStatus)
		line:AddFrameToHeaderAlignment(foodIndicator)
		line:AddFrameToHeaderAlignment(flaskIndicator)
		line:AddFrameToHeaderAlignment(runeIndicator)
		--line:AddFrameToHeaderAlignment(PrePotIndicator)
		--line:AddFrameToHeaderAlignment(DetailsIndicator)

		line:AlignWithHeader(DetailsRaidCheck.Header, "left")

		line.CovenantIcon = covenantIcon
		line.RoleIcon = roleIcon
		line.SpecIcon = specIcon
		line.PlayerName = playerName
		line.TalentsRow = talentsRow
		line.ItemLevel = itemLevel
		line.RepairStatus = repairStatus
		line.FoodIndicator = foodIndicator
		line.FoodTierIndicator = foodTierIndicator
		line.FlaskIndicator = flaskIndicator
		line.FlaskTierIndicator = flaskTierIndicator
		line.RuneIndicator = runeIndicator
		--line.PrePotIndicator = PrePotIndicator
		--line.DetailsIndicator = DetailsIndicator

		return line
	end

	--refresh scroll
	local has_food_icon = {texture = [[Interface\Scenarios\ScenarioIcon-Check]], coords = {0, 1, 0, 1}}
	local eatingFoodIcon = {texture = [[Interface\AddOns\Details\images\icons]], coords = {225/512, 249/512, 35/512, 63/512}}

	local scrollRefreshLines = function(self, data, offset, totalLines)
		local dataInOrder = {}

		for i = 1, #data do
			dataInOrder[#dataInOrder+1] = data [i]
		end

		table.sort(dataInOrder, DF.SortOrder2)
		--table.sort (dataInOrder, DF.SortOrder1R) --alphabetical
		data = dataInOrder

		--get the information of all players
		local playersInfoData = openRaidLib.GetAllUnitsInfo()
		local playersGearData = openRaidLib.GetAllUnitsGear()

		local printAmount = false

		if (printAmount) then
			print("#data", #data, "total lines:", totalLines)
		end

		local addedPlayersAmount = 0
		local addedLinesAmount = 0

		for i = 1, totalLines do
			local index = i + offset
			local playerTable = data[index]

			if (playerTable) then
				addedPlayersAmount = addedPlayersAmount + 1
				local line = self:GetLine(i)
				if (line) then
					addedLinesAmount = addedLinesAmount + 1
					local thisPlayerInfo = playersInfoData[playerTable.UnitNameRealm]
					if (thisPlayerInfo) then
						if (DF.IsShadowlandsWow()) then
							local playerCovenantId = thisPlayerInfo.covenantId
							if (playerCovenantId > 0) then
								line.CovenantIcon:SetTexture(LIB_OPEN_RAID_COVENANT_ICONS[playerCovenantId])
								line.CovenantIcon:SetTexCoord(.05, .95, .05, .95)
							else
								line.CovenantIcon:SetTexture("")
							end
						else
							line.CovenantIcon:SetTexture("")
						end
					else
						line.CovenantIcon:SetTexture("")
					end

					--repair status
					local thisPlayerGearInfo = playersGearData[playerTable.UnitNameRealm]
					if (thisPlayerGearInfo) then
						line.RepairStatus:SetText(thisPlayerGearInfo.durability .. "%")
					else
						line.RepairStatus:SetText("")
					end

					local roleTexture, L, R, T, B = Details:GetRoleIcon(playerTable.Role or "NONE")
					line.RoleIcon:SetTexture(roleTexture)
					line.RoleIcon:SetTexCoord(L, R, T, B)

					if (playerTable.Spec) then
						local texture, L, R, T, B = Details:GetSpecIcon(playerTable.Spec)
						line.SpecIcon:SetTexture(texture)
						line.SpecIcon:SetTexCoord(L, R, T, B)
					else
						local texture, L, R, T, B = Details:GetClassIcon(playerTable.Class)
						line.SpecIcon:SetTexture(texture)
						line.SpecIcon:SetTexCoord(L, R, T, B)
					end

					line.TalentsRow:ClearIcons()

					--print("dssd", playerTable.Talents)

					if (playerTable.Talents) then
						for i = 1, #playerTable.Talents do
							local talent = playerTable.Talents[i]
							local talentID, name, texture, selected, available = GetTalentInfoByID(talent)
							line.TalentsRow:SetIcon(false, false, false, false, texture)
						end
					end

					local classColor = Details.class_colors[playerTable.Class]
					if (classColor) then
						line:SetBackdropColor(unpack(classColor))
					else
						line:SetBackdropColor(unpack(backdrop_color))
					end

					line.PlayerName.text = playerTable.Name
					line.ItemLevel.text = floor(playerTable.ILevel and playerTable.ILevel.ilvl or 0)

					local foodInfo = playerTable.Food
					if (foodInfo) then
						line.FoodIndicator.texture = foodInfo[3]
						line.FoodTierIndicator.text = foodInfo[2]
						--line.FoodIndicator.texcoord = has_food_icon.coords
						line.FoodIndicator.texcoord = {0, 1, 0, 1}

					elseif (playerTable.Eating) then
						line.FoodIndicator.texture = eatingFoodIcon.texture
						line.FoodIndicator.texcoord = eatingFoodIcon.coords

					else
						line.FoodIndicator.texture = ""
					end

					local flaskInfo = playerTable.Flask
					if (flaskInfo) then
						line.FlaskIndicator.texture = flaskInfo[3]
						line.FlaskTierIndicator.text = flaskInfo[2]
					else
						line.FlaskIndicator.texture = ""
						line.FlaskTierIndicator.text = ""
					end

					line.RuneIndicator.texture = playerTable.Rune and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
					--line.PrePotIndicator.texture = playerTable.PrePot and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
					--line.DetailsIndicator.texture = playerTable.UseDetails and [[Interface\Scenarios\ScenarioIcon-Check]] or ""
				end
			end
		end

		if (printAmount) then
			print("addedPlayersAmount", addedPlayersAmount)
			print("addedLinesAmount", addedLinesAmount)
		end
	end

	--create scroll
	local mainScroll = DF:CreateScrollBox(raidCheckFrame, "$parentMainScroll", scrollRefreshLines, PlayerData, 1, 1, scrollLinesAmount, scrollLineHeight)
	DF:ReskinSlider(mainScroll)
	mainScroll.HideScrollBar = true
	mainScroll:SetPoint("topleft", raidCheckFrame, "topleft", 10, scrollY)
	mainScroll:SetPoint("bottomright", raidCheckFrame, "bottomright", -10, 20)
	mainScroll:Refresh()

	--create lines
	for i = 1, scrollLinesAmount do
		mainScroll:CreateLine(scrollCreateLine)
	end

	raidCheckFrame:Hide()

	DetailsRaidCheck.report_lines = ""
	local reportFunc = function(IsCurrent, IsReverse, AmtLines)
		DetailsRaidCheck:SendReportLines(DetailsRaidCheck.report_lines)
	end

	--overwrite the default scripts
	DetailsRaidCheck.ToolbarButton:RegisterForClicks("AnyUp")
	DetailsRaidCheck.ToolbarButton:SetScript("OnClick", function(self, button)
		if (IsShiftKeyDown()) then
			DetailsRaidCheck.OpenOptionsPanel()
			return
		end

		if (button == "LeftButton") then
			--link no food/flask
			local reportString, added = "Details!: No Flask or Food: ", {}

			local amt = GetNumGroupMembers()
			local _, _, difficulty = GetInstanceInfo()
			if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and amt > 20) then
				amt = 20
			end

			for i = 1, amt, 1 do
				local unitID = getUnitId(i)
				local name = UnitName(unitID)
				local unitSerial = UnitGUID(unitID)

				if (not DetailsRaidCheck.unitWithFoodTable[unitSerial]) then
					added [unitSerial] = true
					reportString = reportString .. DetailsRaidCheck:GetOnlyName(name) .. " "
				end

				if (not DetailsRaidCheck.unitsWithFlaskTable[unitSerial] and not added[unitSerial]) then
					reportString = reportString .. DetailsRaidCheck:GetOnlyName(name) .. " "
				end
			end

			if (DetailsRaidCheck.db.use_report_panel) then
				DetailsRaidCheck.report_lines = reportString
				DetailsRaidCheck:SendReportWindow(reportFunc)
			else
				if (IsInRaid()) then
					DetailsRaidCheck:SendMsgToChannel(reportString, "RAID")
				else
					DetailsRaidCheck:SendMsgToChannel(reportString, "PARTY")
				end
			end

		elseif (button == "RightButton") then
			--link no pre-pot latest segment
			local reportString = "Details!: No Pre-Pot Last Try: "
			local groupMembersAmount = GetNumGroupMembers()
			local _, _, difficulty = GetInstanceInfo()
			if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and groupMembersAmount > 20) then
				groupMembersAmount = 20
			end

			for i = 1, groupMembersAmount, 1 do
				local unitId = getUnitId(i)
				local role = UnitGroupRolesAssigned(unitId)

				if (role == "DAMAGER" or (role == "HEALER" and DetailsRaidCheck.db.pre_pot_healers) or (role == "TANK" and DetailsRaidCheck.db.pre_pot_tanks)) then
					local playerName, realmName = UnitName(unitId)
					if (realmName and realmName ~= "") then
						playerName = playerName .. "-" .. realmName
					end

					if (not DetailsRaidCheck.usedprepot_table[playerName]) then
						reportString = reportString .. DetailsRaidCheck:GetOnlyName(playerName) .. " "
					end
				end
			end

			if (DetailsRaidCheck.db.use_report_panel) then
				DetailsRaidCheck.report_lines = reportString
				DetailsRaidCheck:SendReportWindow(reportFunc)
			else
				if (IsInRaid()) then
					DetailsRaidCheck:SendMsgToChannel(reportString, "RAID")
				else
					DetailsRaidCheck:SendMsgToChannel(reportString, "PARTY")
				end
			end

		elseif (button == "MiddleButton") then
			--report focus aug
			local reportString = "Details!: Not using Rune: "
			local groupMembersAmount = GetNumGroupMembers()
			local _, _, difficulty = GetInstanceInfo()
			if (difficulty == 16 and DetailsRaidCheck.db.mythic_1_4 and groupMembersAmount > 20) then
				groupMembersAmount = 20
			end

			for i = 1, groupMembersAmount do
				local unitID = getUnitId(i)
				local name = UnitName(unitID)
				local unitSerial = UnitGUID(unitID)
				if (not DetailsRaidCheck.havefocusaug_table[unitSerial]) then
					reportString = reportString .. DetailsRaidCheck:GetOnlyName(name) .. " "
				end
			end

			if (DetailsRaidCheck.db.use_report_panel) then
				DetailsRaidCheck.report_lines = reportString
				DetailsRaidCheck:SendReportWindow(reportFunc)
			else
				if (IsInRaid()) then
					DetailsRaidCheck:SendMsgToChannel(reportString, "RAID")
				else
					DetailsRaidCheck:SendMsgToChannel(reportString, "PARTY")
				end
			end
		end
	end)

	local updateRaidCheckFrame = function(self, deltaTime)
		raidCheckFrame.NextUpdate = raidCheckFrame.NextUpdate - deltaTime
		if (raidCheckFrame.NextUpdate > 0) then
			return
		end

		raidCheckFrame.NextUpdate = UpdateSpeed

		if (not IsInRaid() and not IsInGroup()) then
			return
		end

		DetailsRaidCheck:BuffTrackTick()
		wipe(PlayerData)

		local groupTypeId = IsInRaid() and "raid" or "party"

		local playerAmount = DetailsRaidCheck.GetPlayerAmount()
		local iterateAmount = playerAmount
		if (not IsInRaid()) then
			iterateAmount = iterateAmount - 1
		end

		for i = 1, iterateAmount do
			local unitID = groupTypeId .. i
			local unitName = UnitName(unitID)
			local unitNameWithRealm = GetUnitName(unitID, true)
			local cleuName = Details:GetCLName(unitID)
			local unitSerial = UnitGUID(unitID)
			local _, unitClass, unitClassID = UnitClass(unitID)
			local unitRole = UnitGroupRolesAssigned(unitID)
			local unitSpec = Details:GetSpecFromSerial(unitSerial) or Details:GetSpec(cleuName)
			local itemLevelTable = Details.ilevel:GetIlvl(unitSerial)

			local talentsTable = Details:GetTalents(unitSerial)
			if (not talentsTable) then
				local playersInfoData = openRaidLib.GetAllUnitsInfo()
				local playerTalentsInfo = playersInfoData[GetUnitName(unitID, true)]
				if (playerTalentsInfo) then
					talentsTable = DF.table.copy({}, playerTalentsInfo.talents)
				end
			end

			--order by class > alphabetically by the unit name
			unitClassID = (((unitClassID or 0) + 128) ^ 4) + tonumber(string.byte (unitName, 1) .. "" .. string.byte(unitName, 2))

			tinsert(PlayerData, {unitName, unitClassID,
				Name = unitName,
				UnitNameRealm = unitNameWithRealm,
				Class = unitClass,
				Serial = unitSerial,
				Role = unitRole,
				Spec = unitSpec,
				ILevel = itemLevelTable,
				Talents = talentsTable,
				Food = DetailsRaidCheck.unitWithFoodTable[unitSerial],
				Flask = DetailsRaidCheck.unitsWithFlaskTable[unitSerial],
				PrePot = DetailsRaidCheck.usedprepot_table[cleuName],
				Rune = DetailsRaidCheck.havefocusaug_table[unitSerial],
				Eating = DetailsRaidCheck.iseating_table[unitSerial],
				UseDetails = Details.trusted_characters[unitSerial],
			})
		end

		if (not IsInRaid()) then
			--add the player data
			local unitId = "player"
			local unitName = UnitName(unitId)
			local cleuName = Details:GetCLName(unitId)
			local unitSerial = UnitGUID(unitId)
			local _, unitClass, unitClassID = UnitClass(unitId)
			local unitRole = UnitGroupRolesAssigned(unitId)
			local unitSpec = Details:GetSpecFromSerial(unitSerial) or Details:GetSpec(cleuName)
			local itemLevelTable = Details.ilevel:GetIlvl(unitSerial)
			local talentsTable = Details:GetTalents(unitSerial)

			unitClassID = ((unitClassID + 128) ^ 4) + tonumber(string.byte(unitName, 1) .. "" .. string.byte(unitName, 2))
			local unitNameWithRealm = GetUnitName(unitId, true)

			local talentsTable = Details:GetTalents(unitSerial)
			if (not talentsTable) then
				local playersInfoData = openRaidLib.GetAllUnitsInfo()
				local playerTalentsInfo = playersInfoData[GetUnitName(unitId, true)]
				if (playerTalentsInfo) then
					talentsTable = DF.table.copy({}, playerTalentsInfo.talents)
				end
			end

			tinsert (PlayerData, {unitName, unitClassID,
				Name = unitName,
				UnitNameRealm = unitNameWithRealm,
				Class = unitClass,
				Serial = unitSerial,
				Role = unitRole,
				Spec = unitSpec,
				ILevel = itemLevelTable,
				Talents = talentsTable,
				Food = DetailsRaidCheck.unitWithFoodTable[unitSerial],
				Flask = DetailsRaidCheck.unitsWithFlaskTable[unitSerial],
				PrePot = DetailsRaidCheck.usedprepot_table[cleuName],
				Rune = DetailsRaidCheck.havefocusaug_table[unitSerial],
				Eating = DetailsRaidCheck.iseating_table[unitSerial],
				UseDetails = Details.trusted_characters[unitSerial],
			})
		end

		mainScroll:Refresh()

		local height = (playerAmount * scrollLineHeight) + 75
		raidCheckFrame:AdjustHeight(height)
	end

	DetailsRaidCheck.ToolbarButton:SetScript("OnEnter", function(self)
		raidCheckFrame:Show()
		raidCheckFrame:ClearAllPoints()

		local bottomPosition = self:GetBottom()
		local screenHeight = GetScreenHeight()

		local positionHeightPercent = bottomPosition / screenHeight

		if (positionHeightPercent > 0.7) then
			raidCheckFrame:SetPoint("top", DetailsRaidCheck.ToolbarButton, "bottom", 0, -10)
		else
			raidCheckFrame:SetPoint("bottom", DetailsRaidCheck.ToolbarButton, "top", 0, 10)
		end

		raidCheckFrame.NextUpdate = UpdateSpeed
		updateRaidCheckFrame(raidCheckFrame, 1)
		raidCheckFrame:SetScript("OnUpdate", updateRaidCheckFrame)
	end)

	DetailsRaidCheck.ToolbarButton:SetScript("OnLeave", function (self)
		raidCheckFrame:SetScript("OnUpdate", nil)
		raidCheckFrame:Hide()
	end)

	function DetailsRaidCheck:CheckCanShowIcon(...)
		local isInRaid = IsInRaid()
		local isInGroup = IsInGroup()

		if (isInRaid or isInGroup) then
			DetailsRaidCheck:ShowToolbarIcon(DetailsRaidCheck.ToolbarButton, "star")
			DetailsRaidCheck.on_raid = true
		else
			DetailsRaidCheck:HideToolbarIcon(DetailsRaidCheck.ToolbarButton)
			DetailsRaidCheck.on_raid = false
		end
	end

	local checkBuffs_Shadowlands = function(unitId, consumableTable)
		local unitSerial = UnitGUID(unitId)

		for buffIndex = 1, 40 do
			local bname, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitBuff(unitId, buffIndex)

			if (bname) then
				if (flaskList[spellId]) then
					DetailsRaidCheck.unitsWithFlaskTable[unitSerial] = {spellId, 1, texture}
					consumableTable.Flask = consumableTable.Flask + 1
				end

				if (DetailsRaidCheck.db.food_tier1) then
					if (foodList.tier1[spellId]) then
						DetailsRaidCheck.unitWithFoodTable[unitSerial] = {spellId, 1, texture}
						consumableTable.Food = consumableTable.Food + 1
					end
				end

				if (DetailsRaidCheck.db.food_tier2) then
					if (foodList.tier2[spellId]) then
						DetailsRaidCheck.unitWithFoodTable[unitSerial] = {spellId, 2, texture}
						consumableTable.Food = consumableTable.Food + 1
					end
				end

				if (DetailsRaidCheck.db.food_tier3) then
					if (foodList.tier3[spellId]) then
						DetailsRaidCheck.unitWithFoodTable[unitSerial] = {spellId, 3, texture}
						consumableTable.Food = consumableTable.Food + 1
					end
				end

				if (runeIds[spellId]) then
					DetailsRaidCheck.havefocusaug_table[unitSerial] = spellId
				end

				if (bname == localizedFoodDrink) then
					DetailsRaidCheck.iseating_table[unitSerial] = true
				end
			else
				break
			end
		end
	end

	local checkBuffs_Dragonflight = function(unitId, consumableTable)
		local unitSerial = UnitGUID(unitId)

		local function handleAuraBuff(aura)
			local auraInfo = C_UnitAuras.GetAuraDataByAuraInstanceID("player", aura.auraInstanceID)
			if (auraInfo) then
				local buffName = auraInfo.name
				local spellId = auraInfo.spellId

				if (buffName) then
					local flashInfo = flaskList[spellId]
					if (flashInfo) then
						local flaskTier = openRaidLib.GetFlaskTierFromAura(auraInfo)
						DetailsRaidCheck.unitsWithFlaskTable[unitSerial] = {spellId, flaskTier, auraInfo.icon}
						consumableTable.Flask = consumableTable.Flask + 1
					end

					local foodInfo = foodInfoList[spellId]

					if (DetailsRaidCheck.db.food_tier1) then
						if (foodInfo) then
							local foodTier = openRaidLib.GetFoodTierFromAura(auraInfo)
							DetailsRaidCheck.unitWithFoodTable[unitSerial] = {spellId, foodTier or 1, auraInfo.icon}
							consumableTable.Food = consumableTable.Food + 1
						end
					end

					if (DetailsRaidCheck.db.food_tier2) then
						if (foodInfo) then
							local foodTier = openRaidLib.GetFoodTierFromAura(auraInfo)
							if (foodTier and foodTier >= 2) then
								DetailsRaidCheck.unitWithFoodTable[unitSerial] = {spellId, foodTier, auraInfo.icon}
								consumableTable.Food = consumableTable.Food + 1
							end
						end
					end

					if (DetailsRaidCheck.db.food_tier3) then
						if (foodInfo) then
							local foodTier = openRaidLib.GetFoodTierFromAura(auraInfo)
							if (foodTier and foodTier >= 3) then
								DetailsRaidCheck.unitWithFoodTable[unitSerial] = {spellId, foodTier, auraInfo.icon}
								consumableTable.Food = consumableTable.Food + 1
							end
						end
					end

					if (runeIds[spellId]) then
						DetailsRaidCheck.havefocusaug_table[unitSerial] = spellId
					end

					if (buffName == localizedFoodDrink) then
						DetailsRaidCheck.iseating_table[unitSerial] = true
					end
				end
			end
		end

		local batchCount = nil
		local usePackedAura = true
		AuraUtil.ForEachAura(unitId, "HELPFUL", batchCount, handleAuraBuff, usePackedAura)
	end

	function DetailsRaidCheck:CheckUnitBuffs(unitId, consumableTable)
		if (DF.IsShadowlandsWow() or DF.IsWotLKWow()) then
			checkBuffs_Shadowlands(unitId, consumableTable)

		elseif (DF.IsDragonflight()) then
			checkBuffs_Dragonflight(unitId, consumableTable)
		end
	end

	function DetailsRaidCheck:BuffTrackTick()
		wipe(DetailsRaidCheck.unitsWithFlaskTable)
		wipe(DetailsRaidCheck.unitWithFoodTable)
		wipe(DetailsRaidCheck.havefocusaug_table)
		wipe(DetailsRaidCheck.iseating_table)

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
			for i = 1, playerAmount - 1 do
				local unitId = "party" .. i
				DetailsRaidCheck:CheckUnitBuffs(unitId, hasConsumables)
			end
			DetailsRaidCheck:CheckUnitBuffs("player", hasConsumables)
		end

		if (hasConsumables.Food == playerAmount and hasConsumables.Flask == playerAmount) then
			DetailsRaidCheck:SetGreenIcon()
		else
			DetailsRaidCheck:SetRedIcon()
		end
	end
end

local buildOptionsPanel = function()
	local optionsFrame = DetailsRaidCheck:CreatePluginOptionsFrame("DetailsRaidCheckOptionsWindow", "Details! Raid Check Options", 1)
	local optionsTable = {
		{type = "label", get = function() return "General Settings:" end, text_template = DF:GetTemplate("font", "ORANGE_FONT_TEMPLATE")},
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

		{type = "breakline"},

		{type = "label", get = function() return "Food Level Tracking:" end, text_template = DF:GetTemplate("font", "ORANGE_FONT_TEMPLATE")},
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

	local options_text_template = DF:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DF:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DF:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

	Details.gump:BuildMenu(optionsFrame, optionsTable, 15, -45, 180, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
end

DetailsRaidCheck.OpenOptionsPanel = function()
	if (not DetailsRaidCheckOptionsWindow) then
		buildOptionsPanel()
	end
	DetailsRaidCheckOptionsWindow:Show()
end

function DetailsRaidCheck:OnEvent(_, event, ...)

	if (event == "GROUP_ROSTER_UPDATE") then
		if (DetailsRaidCheck.RosterDelay < GetTime()) then
			DetailsRaidCheck:CheckCanShowIcon()
			DetailsRaidCheck.RosterDelay = GetTime()+2
		end

	elseif (event == "ADDON_LOADED") then
		local AddonName = select(1, ...)
		if (AddonName == "Details_RaidCheck") then
			if (_G.Details) then
				if (DetailsFramework.IsClassicWow()) then
					return
				end

				--create widgets
				CreatePluginFrames()

				--core version required
				local MINIMAL_DETAILS_VERSION_REQUIRED = 20

				local defaultSettings = {
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
					--install
					local install, savedData, isEnabled = _G.Details:InstallPlugin("TOOLBAR", Loc["STRING_RAIDCHECK_PLUGIN_NAME"], [[Interface\Buttons\UI-CheckBox-Check]], DetailsRaidCheck, "DETAILS_PLUGIN_RAIDCHECK", MINIMAL_DETAILS_VERSION_REQUIRED, "Terciob", version, defaultSettings)
					if (type (install) == "table" and install.error) then
						return print(install.error)
					end

					--register needed events
					Details:RegisterEvent(DetailsRaidCheck, "COMBAT_PLAYER_LEAVE")
					Details:RegisterEvent(DetailsRaidCheck, "COMBAT_PLAYER_ENTER")
					Details:RegisterEvent(DetailsRaidCheck, "COMBAT_PREPOTION_UPDATED")
					Details:RegisterEvent(DetailsRaidCheck, "ZONE_TYPE_CHANGED")

					DetailsRaidCheck.Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
				end)
			end
		end
	end
end
