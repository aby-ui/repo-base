
    local Details = _G.Details
    local DF = _G.DetailsFramework

    local breakdownWindowPlayerList = {}

    local unpack = _G.unpack
    local C_Timer = _G.C_Timer
    local tinsert = _G.tinsert

	local scrollbox_size = {200, 405}
	local scrollbox_lines = 25
    local player_line_height = 21.7
	local scrollbox_line_backdrop_color = {0.2, 0.2, 0.2, 0.5}
	local scrollbox_line_backdrop_color_selected = {.6, .6, .1, 0.7}
    local scrollbox_line_backdrop_color_highlight = {.9, .9, .9, 0.5}
    local player_scroll_size = {180, 288}
    
	function breakdownWindowPlayerList.CreatePlayerListFrame()
		local f = _G.DetailsPlayerDetailsWindow
		
		local refreshPlayerList = function(self, data, offset, totalLines)
			--update the scroll
			local topResult = data[1]
			if (topResult) then
				topResult = topResult.total
			end
			for i = 1, totalLines do
				local index = i + offset
				local playerObject = data[index]
				if (playerObject) then
					local line = self:GetLine(i)
					line.playerObject = playerObject
					line:UpdateLine(topResult)
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
		
		local updatePlayerLine = function(self, topResult)

			local playerSelected = Details:GetPlayerObjectFromBreakdownWindow()
			if (playerSelected and playerSelected == self.playerObject) then
				self:SetBackdropColor(unpack(scrollbox_line_backdrop_color_selected))
				self.isSelected = true
			else
				self:SetBackdropColor(unpack(scrollbox_line_backdrop_color))
				self.isSelected = nil
			end
			
			--adjust the player icon
			local specIcon, L, R, T, B = Details:GetSpecIcon(self.playerObject.spec, false)
			local specId, specName, specDescription, specIconId, specRole, specClass
			
			if (specIcon) then
				self.specIcon:SetTexture(specIcon)
				self.specIcon:SetTexCoord(L, R, T, B)

				if (DetailsFramework.IsTimewalkWoW()) then
					specRole = "NONE"
				else
					specId, specName, specDescription, specIconId, specRole, specClass = _G.GetSpecializationInfoByID(self.playerObject.spec)
				end
			else
				self.specIcon:SetTexture(nil)
			end

			--adjust the role icon
			if (specRole) then
				local roleIcon, L, R, T, B = Details:GetRoleIcon(specRole)
				if (roleIcon) then
					self.roleIcon:SetTexture(roleIcon)
					self.roleIcon:SetTexCoord(L, R, T, B)
				else
					self.roleIcon:SetTexture(nil)
				end
			else
				self.roleIcon:SetTexture(nil)
			end
			
			--do not show the role icon
			self.roleIcon:SetTexture(nil)
			
			--set the player name
			self.playerName:SetText(Details:GetOnlyName(self.playerObject.nome))
			
			--set the player class name
			self.className:SetText(string.lower(_G.UnitClass(self.playerObject.nome) or self.playerObject:Class()))

			--set the statusbar
			local r, g, b = self.playerObject:GetClassColor()
			self.totalStatusBar:SetStatusBarColor(r, g, b, 1)
			self.totalStatusBar:SetMinMaxValues(0, topResult)
			self.totalStatusBar:SetValue(self.playerObject.total)
		end
		
		local createPlayerLine = function(self, index)
			--create a new line
			local line = _G.CreateFrame("button", "$parentLine" .. index, self, "BackdropTemplate")

			--set its parameters
			line:SetPoint("topleft", self, "topleft", 1, -((index-1) * (player_line_height+1)) - 1)
			line:SetSize(scrollbox_size[1]-19, player_line_height)
			line:RegisterForClicks("LeftButtonDown", "RightButtonDown")
			
			line:SetScript("OnEnter", lineOnEnter)
			line:SetScript("OnLeave", lineOnLeave)
			line:SetScript("OnClick", lineOnClick)
			
			line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
			line:SetBackdropColor(unpack (scrollbox_line_backdrop_color))
			line:SetBackdropBorderColor(0, 0, 0, 1)
			
			local specIcon = line:CreateTexture("$parentSpecIcon", "artwork")
			specIcon:SetSize (player_line_height, player_line_height)
			local roleIcon = line:CreateTexture("$parentRoleIcon", "overlay")
			roleIcon:SetSize ((player_line_height-2) / 2, (player_line_height-2) / 2)
			
			local playerName = DF:CreateLabel(line, "", "GameFontNormal")
			playerName.textcolor = {1, 1, 1, .9}
			playerName.textsize = 11
			local className = DF:CreateLabel(line, "", "GameFontNormal")
			className.textcolor = {.95, .8, .2, 0}
			className.textsize = 9

			local totalStatusBar = CreateFrame("statusbar", nil, line)
			totalStatusBar:SetSize(scrollbox_size[1]-19-player_line_height, 4)
			totalStatusBar:SetMinMaxValues(0, 100)
			totalStatusBar:SetStatusBarTexture([[Interface\AddOns\Details\images\bar_skyline]])
			totalStatusBar:SetFrameLevel(line:GetFrameLevel()-1)

			--setup anchors
			specIcon:SetPoint("topleft", line, "topleft", 0, 0)
			roleIcon:SetPoint("topleft", specIcon, "topright", 2, 0)
			--playerName:SetPoint("left", roleIcon, "right", 2, 0)
			playerName:SetPoint("topleft", specIcon, "topright", 2, -1)
			className:SetPoint("topleft", roleIcon, "bottomleft", 0, -2)
			totalStatusBar:SetPoint("bottomleft", specIcon, "bottomright", 0, 0)

			line.specIcon = specIcon
			line.roleIcon = roleIcon
			line.playerName = playerName
			line.className = className
			line.totalStatusBar = totalStatusBar

			line.UpdateLine = updatePlayerLine

			return line
		end
		
		local playerScroll = DF:CreateScrollBox(f, "$parentPlayerScrollBox", refreshPlayerList, {}, player_scroll_size[1] + 22, player_scroll_size[2], scrollbox_lines, player_line_height)
		DF:ReskinSlider (playerScroll)
		playerScroll.ScrollBar:ClearAllPoints()
		playerScroll.ScrollBar:SetPoint("topright", playerScroll, "topright", -2, -17)
		playerScroll.ScrollBar:SetPoint("bottomright", playerScroll, "bottomright", -2, 17)
		playerScroll:SetPoint("topright", f, "topleft", -1, 0)
		playerScroll:SetPoint("bottomright", f, "bottomleft", -1, 0)
		playerScroll:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		playerScroll:SetBackdropColor(0, 0, 0, 0.2)
		playerScroll:SetBackdropBorderColor(0, 0, 0, 1)
		f.playerScrollBox = playerScroll
		
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
		}
		
		--get the player list from the segment and build a table compatible with the scroll box
		function breakdownWindowPlayerList.BuildPlayerList()
			local segment = Details:GetCombatFromBreakdownWindow()
			local playerTable = {}
			if (segment) then
				--need to know if this is showing damage or heal
				local displayType = Details:GetDisplayTypeFromBreakdownWindow()
				local containerType = displayType == 1 and DETAILS_ATTRIBUTE_DAMAGE or DETAILS_ATTRIBUTE_HEAL
				local container = segment:GetContainer(containerType)
				for index, playerObject in container:ListActors() do
					if (playerObject:IsPlayer()) then
						local unitClassID = classIds [playerObject:Class()] or 13
						local unitName = playerObject:Name()
						local playerPosition = (((unitClassID or 0) + 128) ^ 4) + tonumber (string.byte (unitName, 1) .. "" .. string.byte (unitName, 2))
						tinsert(playerTable, {playerObject, playerPosition, playerObject.total})
					end
				end
			end
			
			table.sort (playerTable, DF.SortOrder3)
			
			local resultTable = {}
			for i = 1, #playerTable do
				resultTable [#resultTable+1] = playerTable[i][1]
			end
			
			return resultTable
		end
		
		function Details:UpdateBreakdownPlayerList()
			--run the update on the next tick
			C_Timer.After(0, function()
				local playerList = breakdownWindowPlayerList.BuildPlayerList()
				playerScroll:SetData (playerList)
				playerScroll:Refresh()
				playerScroll:Show()
			end)
		end

		f:HookScript("OnShow", function()
			Details:UpdateBreakdownPlayerList()
		end)
    end

	breakdownWindowPlayerList.CreatePlayerListFrame()

