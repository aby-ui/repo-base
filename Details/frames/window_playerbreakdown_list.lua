
    local Details = _G.Details
    local detailsFramework = _G.DetailsFramework
	local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true)
	local addonName, Details222 = ...

    local breakdownWindowPlayerList = {}

    local unpack = table.unpack or unpack
    local C_Timer = _G.C_Timer
    local tinsert = _G.tinsert

	local scrollbox_size = {215, 405}
	local scrollbox_lines = 23
    local player_line_height = 21.7
	local scrollbox_line_backdrop_color = {0.2, 0.2, 0.2, 0.5}
	local scrollbox_line_backdrop_color_selected = {.6, .6, .1, 0.7}
    local scrollbox_line_backdrop_color_highlight = {.9, .9, .9, 0.5}
    local player_scroll_size = {195, 288}

	--header setup
	local headerTable = {
		{text = "", width = 20},
		{text = "Player Name", width = 100},
		{text = "iLvL", width = 30},
		{text = "WCL Parse", width = 60},
	}
	local headerOptions = {
		padding = 2,
	}

	function breakdownWindowPlayerList.CreatePlayerListFrame()
		local f = _G.DetailsPlayerDetailsWindow

		local refreshPlayerList = function(self, data, offset, totalLines)
			--update the scroll
			local topResult = data[1]
			if (topResult) then
				topResult = topResult.total
			end

			local combatObject = Details:GetCombatFromBreakdownWindow()
			local encounterId = combatObject:GetEncounterCleuID()
			local difficultyId = combatObject:GetDifficulty()

			for i = 1, totalLines do --~refresh
				local index = i + offset
				local playerObject = data[index]
				if (playerObject) then
					local line = self:GetLine(i)
					line.playerObject = playerObject
					line.combatObject = combatObject
					line.index = index
					line:UpdateLine(topResult, encounterId, difficultyId)
				end
			end
		end

		local lineOnClick = function(self)
			if (self.playerObject ~= Details:GetPlayerObjectFromBreakdownWindow()) then
				Details:OpenPlayerBreakdown(Details:GetActiveWindowFromBreakdownWindow(), self.playerObject)
				f.playerScrollBox:Refresh()
			end
		end

		local lineOnEnter = function(self)
			self:SetBackdropColor(unpack(scrollbox_line_backdrop_color_highlight))
			self.specIcon:SetBlendMode("ADD")
			self.roleIcon:SetBlendMode("ADD")
		end

		local lineOnLeave = function(self)
			if (self.isSelected) then
				self:SetBackdropColor(unpack(scrollbox_line_backdrop_color_selected))
			else
				self:SetBackdropColor(unpack(scrollbox_line_backdrop_color))
			end
			self.specIcon:SetBlendMode("BLEND")
			self.roleIcon:SetBlendMode("BLEND")
		end

		local updatePlayerLine = function(self, topResult, encounterId, difficultyId) --~update
			local playerSelected = Details:GetPlayerObjectFromBreakdownWindow()
			if (playerSelected and playerSelected == self.playerObject) then
				self:SetBackdropColor(unpack(scrollbox_line_backdrop_color_selected))
				self.isSelected = true
			else
				self:SetBackdropColor(unpack(scrollbox_line_backdrop_color))
				self.isSelected = nil
			end

			local specRole

			--adjust the player icon
			if (self.playerObject.spellicon) then
				self.specIcon:SetTexture(self.playerObject.spellicon)
				self.specIcon:SetTexCoord(.1, .9, .1, .9)
			else
				local specIcon, L, R, T, B = Details:GetSpecIcon(self.playerObject.spec, false)

				if (specIcon) then
					self.specIcon:SetTexture(specIcon)
					self.specIcon:SetTexCoord(L, R, T, B)

					if (DetailsFramework.IsTimewalkWoW()) then
						specRole = "NONE"
					else
						specRole = select(5, _G.GetSpecializationInfoByID(self.playerObject.spec))
					end
				else
					self.specIcon:SetTexture("")
				end
			end

			--adjust the role icon
			if (specRole) then
				local roleIcon, L, R, T, B = Details:GetRoleIcon(specRole)
				if (roleIcon) then
					self.roleIcon:SetTexture(roleIcon)
					self.roleIcon:SetTexCoord(L, R, T, B)
				else
					self.roleIcon:SetTexture("")
				end
			else
				self.roleIcon:SetTexture("")
			end

			local playerGear = openRaidLib and openRaidLib.GetUnitGear(self.playerObject.nome)

			--do not show the role icon
			self.roleIcon:SetTexture("") --not in use

			--set the player name
			self.playerName:SetText(Details:GetOnlyName(self.playerObject.nome))
			self.rankText:SetText(self.index) --not in use

			--set the player class name
			--self.className:SetText(string.lower(_G.UnitClass(self.playerObject.nome) or self.playerObject:Class())) --not in use

			--item level
			self.itemLevelText:SetText(self.playerObject.ilvl or (playerGear and playerGear.ilevel) or "0")

			local actorSpecId = self.playerObject.spec
			local actorTotal = self.playerObject.total
			local combatObject = self.combatObject

			--warcraftlogs percentile
			if (self.playerObject.tipo == DETAILS_ATTRIBUTE_DAMAGE) then
				local actorDPS = self.playerObject.total / combatObject:GetCombatTime()

				local parsePercent = Details222.WarcraftLogs.GetDamageParsePercent(encounterId, difficultyId, actorSpecId, actorDPS)
				if (parsePercent) then
					parsePercent =  math.floor(parsePercent)
					local colorName = Details222.WarcraftLogs.GetParseColor(parsePercent)
					self.percentileText:SetTextColor(detailsFramework:ParseColors(colorName))
					self.percentileText:SetText(math.floor(parsePercent))
					self.percentileText.alpha = 1
				else
					parsePercent = Details222.ParsePercent.GetPercent(DETAILS_ATTRIBUTE_DAMAGE, difficultyId, encounterId, actorSpecId, actorDPS)
					if (parsePercent) then
						parsePercent =  math.floor(parsePercent)
						local colorName = Details222.WarcraftLogs.GetParseColor(parsePercent)
						self.percentileText:SetTextColor(detailsFramework:ParseColors(colorName))
						self.percentileText:SetText(math.floor(parsePercent))
						self.percentileText.alpha = 1
					else
						self.percentileText:SetText("#.def")
						self.percentileText:SetAlpha(0.25)
					end
				end
			else
				self.percentileText:SetText("#.def")
				self.percentileText:SetAlpha(0.25)
			end

			--set the statusbar
			local r, g, b = self.playerObject:GetClassColor()
			self.totalStatusBar:SetStatusBarColor(r, g, b, 1)
			self.totalStatusBar:SetMinMaxValues(0, topResult)
			self.totalStatusBar:SetValue(actorTotal)
		end

		--get a Details! window
		local lowerInstanceId = Details:GetLowerInstanceNumber()
		local fontFile
		local fontSize
		local fontOutline

		if (lowerInstanceId) then
			local instance = Details:GetInstance(lowerInstanceId)
			if (instance) then
				fontFile = instance.row_info.font_face
				fontSize = instance.row_info.font_size
				fontOutline = instance.row_info.textL_outline
			end
		end

		local createPlayerLine = function(self, index)
			--create a new line
			local line = _G.CreateFrame("button", "$parentLine" .. index, self, "BackdropTemplate")
			detailsFramework:Mixin(line, detailsFramework.HeaderFunctions)

			local upFrame = CreateFrame("frame", nil, line)
			upFrame:SetFrameLevel(line:GetFrameLevel()+2)
			upFrame:SetAllPoints()

			--set its parameters
			line:SetPoint("topleft", self, "topleft", 1, -((index) * (player_line_height+1)) - 1)
			line:SetSize(scrollbox_size[1], player_line_height)
			--line:SetSize(scrollbox_size[1]-19, player_line_height)
			line:RegisterForClicks("LeftButtonDown", "RightButtonDown")

			line:SetScript("OnEnter", lineOnEnter)
			line:SetScript("OnLeave", lineOnLeave)
			line:SetScript("OnClick", lineOnClick)

			detailsFramework:ApplyStandardBackdrop(line)

			local specIcon = upFrame:CreateTexture("$parentSpecIcon", "artwork")
			specIcon:SetSize(headerTable[1].width - 1, headerTable[1].width - 1)
			specIcon:SetAlpha(0.71)

			local roleIcon = upFrame:CreateTexture("$parentRoleIcon", "overlay")
			roleIcon:SetSize((player_line_height-2) / 2, (player_line_height-2) / 2)
			roleIcon:SetAlpha(0.71)

			local playerName = detailsFramework:CreateLabel(upFrame, "", 11, "white", "GameFontNormal")
			if (fontFile) then
				playerName.fontface = fontFile
			end
			if (fontSize) then
				playerName.fontsize = fontSize
			end
			if (fontOutline) then
				playerName.outline = fontOutline
			end

			--~create
			playerName.textcolor = {1, 1, 1, .9}

			local className = detailsFramework:CreateLabel(upFrame, "", "GameFontNormal")
			className.textcolor = {.95, .8, .2, 0}
			className.textsize = 9

			local itemLevelText = detailsFramework:CreateLabel(upFrame, "", "GameFontNormal")
			itemLevelText.textcolor = {1, 1, 1, .7}
			itemLevelText.textsize = 11

			local percentileText = detailsFramework:CreateLabel(upFrame, "", "GameFontNormal")
			percentileText.textcolor = {1, 1, 1, .7}
			percentileText.textsize = 11

			local rankText = detailsFramework:CreateLabel(upFrame, "", "GameFontNormal")
			rankText.textcolor = {.3, .3, .3, .7}
			rankText.textsize = fontSize

			local totalStatusBar = CreateFrame("statusbar", nil, line)
			totalStatusBar:SetSize(scrollbox_size[1]-player_line_height, 4)
			totalStatusBar:SetMinMaxValues(0, 100)
			totalStatusBar:SetStatusBarTexture([[Interface\AddOns\Details\images\bar_skyline]])
			totalStatusBar:SetFrameLevel(line:GetFrameLevel()+1)
			totalStatusBar:SetAlpha(0.5)

			--setup anchors
			--specIcon:SetPoint("topleft", line, "topleft", 0, 0)
			--roleIcon:SetPoint("topleft", specIcon, "topright", 2, 0)
			--playerName:SetPoint("topleft", specIcon, "topright", 2, -3)
			--className:SetPoint("topleft", roleIcon, "bottomleft", 0, -2)
			--rankText:SetPoint("right", line, "right", -2, 0)
			totalStatusBar:SetPoint("bottomleft", specIcon, "bottomright", 0, 0)

			line.specIcon = specIcon
			line.roleIcon = roleIcon
			line.playerName = playerName
			line.className = className
			line.rankText = rankText
			line.totalStatusBar = totalStatusBar
			line.itemLevelText = itemLevelText
			line.percentileText = percentileText

			line:AddFrameToHeaderAlignment(specIcon)
			line:AddFrameToHeaderAlignment(playerName)
			line:AddFrameToHeaderAlignment(itemLevelText)
			line:AddFrameToHeaderAlignment(percentileText)

			line:AlignWithHeader(f.Header, "left")

			line.UpdateLine = updatePlayerLine

			return line
		end

		local playerScroll = detailsFramework:CreateScrollBox(f, "$parentPlayerScrollBox", refreshPlayerList, {}, player_scroll_size[1] + 22, player_scroll_size[2], scrollbox_lines, player_line_height)
		detailsFramework:ReskinSlider(playerScroll)
		playerScroll.ScrollBar:ClearAllPoints()
		playerScroll.ScrollBar:SetPoint("topright", playerScroll, "topright", -2, -37)
		playerScroll.ScrollBar:SetPoint("bottomright", playerScroll, "bottomright", -2, 17)
		playerScroll.ScrollBar:Hide()
		playerScroll:SetPoint("topright", f, "topleft", -1, 0)
		playerScroll:SetPoint("bottomright", f, "bottomleft", -1, 0)
		playerScroll:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		playerScroll:SetBackdropColor(0, 0, 0, 0.2)
		playerScroll:SetBackdropBorderColor(0, 0, 0, 1)
		f.playerScrollBox = playerScroll

		--need to be created before
		f.Header = DetailsFramework:CreateHeader(f, headerTable, headerOptions)
		f.Header:SetPoint("topleft", playerScroll, "topleft", 0, -1)
		f.Header:SetPoint("topright", playerScroll, "topright", 0, -1)

		detailsFramework:ApplyStandardBackdrop(f.Header)
		f.Header.__background:SetColorTexture(.60, .60, .60)

		--print(f.Header:GetSize())

		local playerSelectionLabel = detailsFramework:CreateLabel(playerScroll, "click to select a player", 14)
		playerSelectionLabel:SetPoint("bottom", playerScroll, "bottom", 0, 7)

		--create the scrollbox lines
		for i = 1, scrollbox_lines do
			playerScroll:CreateLine(createPlayerLine)
		end

		local classIds = {
			WARRIOR = 1,
			PALADIN = 2,
			HUNTER = 3,
			ROGUE = 4,
			PRIEST = 5,
			DEATHKNIGHT = 6,
			SHAMAN = 7,
			MAGE = 8,
			WARLOCK = 9,
			MONK = 10,
			DRUID = 11,
			DEMONHUNTER = 12,
			EVOKER = 13,
		}

		--get the player list from the segment and build a table compatible with the scroll box
		function breakdownWindowPlayerList.BuildPlayerList()
			local segment = Details:GetCombatFromBreakdownWindow()
			local playerTable = {}

			if (segment) then
				local displayType = Details:GetDisplayTypeFromBreakdownWindow()
				local containerType = displayType == 1 and DETAILS_ATTRIBUTE_DAMAGE or DETAILS_ATTRIBUTE_HEAL
				local container = segment:GetContainer(containerType)

				for index, playerObject in container:ListActors() do
					if (playerObject:IsPlayer()) then
						local unitClassID = classIds [playerObject:Class()] or 13
						local unitName = playerObject:Name()
						local playerPosition = (((unitClassID or 0) + 128) ^ 4) + tonumber(string.byte(unitName, 1) .. "" .. string.byte(unitName, 2))
						tinsert(playerTable, {playerObject, playerPosition, playerObject.total})
					end
				end
			end

			table.sort(playerTable, detailsFramework.SortOrder3)

			local resultTable = {}
			for i = 1, #playerTable do
				resultTable[#resultTable+1] = playerTable[i][1]
			end

			return resultTable
		end

		local updatePlayerList = function()
			local playerList = breakdownWindowPlayerList.BuildPlayerList()
			playerScroll:SetData(playerList)
			playerScroll:Refresh()
			playerScroll:Show()
		end

		function Details:UpdateBreakdownPlayerList()
			--run the update on the next tick
			C_Timer.After(0, updatePlayerList)
			--DF.Schedules.RunNextTick(updatePlayerList)
		end

		f:HookScript("OnShow", function()
			Details:UpdateBreakdownPlayerList()
		end)

		f:HookScript("OnHide", function()
			for lineIndex, line in ipairs(f.playerScrollBox:GetLines()) do
				line.playerObject = nil
				line.combatObject = nil
			end
		end)

		local gradientStartColor = Details222.ColorScheme.GetColorFor("gradient-background")
		local gradientBelow = DetailsFramework:CreateTexture(f.playerScrollBox, 
		{gradient = "vertical", fromColor = gradientStartColor, toColor = "transparent"}, 1, 90, "artwork", {0, 1, 0, 1})
		gradientBelow:SetPoint("bottoms", 1, 1)
    end

	function Details.PlayerBreakdown.CreatePlayerListFrame()
		if (not Details.PlayerBreakdown.playerListFrameCreated) then
			breakdownWindowPlayerList.CreatePlayerListFrame()
			Details.PlayerBreakdown.playerListFrameCreated = true
		end
	end
