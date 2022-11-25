

local Details = _G.Details
local DF = _G.DetailsFramework
local _, Details222 = ...
_ = nil
local _GetSpellInfo = Details.GetSpellInfo

function Details:ScrollDamage()
	if (not DetailsScrollDamage) then
		DetailsScrollDamage = DetailsFramework:CreateSimplePanel(UIParent)
		DetailsScrollDamage:SetSize(427 - 40 - 20 - 20, 505 - 150 + 20 + 40)
		DetailsScrollDamage:SetTitle("/details scroll")
		DetailsScrollDamage.Data = {}
		DetailsScrollDamage:ClearAllPoints()
		DetailsScrollDamage:SetPoint("left", UIParent, "left", 10, 0)
		DetailsScrollDamage:Hide()

		DetailsScrollDamage.Title:SetPoint("center", DetailsScrollDamage.TitleBar, "center", 108, 0)

		DetailsFramework:ApplyStandardBackdrop(DetailsScrollDamage)

		local scroll_width = 395 - 40 - 20 - 20
		local scroll_height = 340
		local scroll_lines = 16
		local scroll_line_height = 20

		local backdrop_color = {.2, .2, .2, 0.2}
		local backdrop_color_on_enter = {.8, .8, .8, 0.4}
		local backdrop_color_is_critical = {.4, .4, .2, 0.2}
		local backdrop_color_is_critical_on_enter = {1, 1, .8, 0.4}

		local dropdownTemplate = DetailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWNDARK_TEMPLATE")

		local y = -15
		local headerY = y - 15
		local scrollY = headerY - 20
		local fontSize = 10

		local LibWindow = _G.LibStub("LibWindow-1.1")
		DetailsScrollDamage:SetScript("OnMouseDown", nil)
		DetailsScrollDamage:SetScript("OnMouseUp", nil)

		if (not Details.damage_scroll_position.point) then
			Details.damage_scroll_position.point = "left"
			Details.damage_scroll_position.x = 4
			Details.damage_scroll_position.y = 120
			Details.damage_scroll_position.scale = 1
		end

		LibWindow.RegisterConfig(DetailsScrollDamage, Details.damage_scroll_position)
		LibWindow.MakeDraggable(DetailsScrollDamage)
		LibWindow.RestorePosition(DetailsScrollDamage)

		local scaleBar = DetailsFramework:CreateScaleBar(DetailsScrollDamage, Details.damage_scroll_position)
		DetailsScrollDamage:SetScale(Details.damage_scroll_position.scale)

		--header
		local headerTable = {
			{text = "", width = 20},
			{text = "Spell Name", width = 104},
			{text = "Amount", width = 60},
			{text = "Time", width = 45},
			{text = "Spell ID", width = 80},
		}
		local headerOptions = {
			padding = 2,
		}

		DetailsScrollDamage.Header = DetailsFramework:CreateHeader(DetailsScrollDamage, headerTable, headerOptions)
		DetailsScrollDamage.Header:SetPoint("topleft", DetailsScrollDamage, "topleft", 5, headerY)
		DetailsScrollDamage.searchText = ""
		DetailsScrollDamage.searchCache = {}

		local refreshFunc = function(self, data, offset, totalLines) --~refresh
			local ToK = _detalhes:GetCurrentToKFunction()

			for i = 1, totalLines do
				local index = i + offset
				local spellTable = data[index]

				if (spellTable) then
					local line = self:GetLine(i)
					local time, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = unpack(spellTable)

					local spellName, _, spellIcon

					if (token ~= "SWING_DAMAGE") then
						spellName, _, spellIcon = _GetSpellInfo(spellID)
					else
						spellName, _, spellIcon = _GetSpellInfo(1)
					end

					line.SpellID = spellID
					line.IsCritical = isCritical
					line.IconFrame.SpellID = spellID

					if (isCritical) then
						line:SetBackdropColor(unpack(backdrop_color_is_critical))
					else
						line:SetBackdropColor(unpack(backdrop_color))
					end

					if (spellName) then
						line.Icon:SetTexture(spellIcon)
						line.Icon:SetTexCoord(.1, .9, .1, .9)
						line.DamageText.text = isCritical and "|cFFFFFF00 " .. ToK(_, amount) or " " .. ToK(_, amount)
						line.TimeText.text = " " .. format("%.2f", time - DetailsScrollDamage.Data.Started)
						line.SpellIDText.text = spellID
						line.SpellIDText:SetCursorPosition(0)
						line.SpellNameText.text = spellName
						line.SpellNameText:SetCursorPosition(0)
					else
						line:Hide()
					end
				end
			end
		end

		local lineOnEnter = function(self) --~onenter
			--if this does not have IconFrame it means it is the IconFrame itself
			if (not self.IconFrame) then
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
				GameTooltip:SetSpellByID(self.SpellID)
				GameTooltip:AddLine(" ")
				GameTooltip:Show()

				self = self:GetParent()
			end

			if (self.IsCritical) then
				self:SetBackdropColor(unpack(backdrop_color_is_critical_on_enter))
			else
				self:SetBackdropColor(unpack(backdrop_color_on_enter))
			end
		end

		local lineOnLeave = function(self) --~onleave
			--if this has an icon frame it means its the line itself
			if (self.IconFrame) then
				if (self.IsCritical) then
					self:SetBackdropColor(unpack(backdrop_color_is_critical))
				else
					self:SetBackdropColor(unpack(backdrop_color))
				end
			end

			GameTooltip:Hide()
		end

		local createLineFunc = function(self, index)
			local line = CreateFrame("button", "$parentLine" .. index, self,"BackdropTemplate")
			line:SetPoint("topleft", self, "topleft", 1, -((index-1)*(scroll_line_height+1)) - 1)
			line:SetSize(scroll_width - 2, scroll_line_height)

			line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor(unpack(backdrop_color))
			-- ~createline --~line
			DF:Mixin(line, DF.HeaderFunctions)

			line:SetScript("OnEnter", lineOnEnter)
			line:SetScript("OnLeave", lineOnLeave)

			--icon
			local icon = line:CreateTexture("$parentSpellIcon", "overlay")
			icon:SetSize(scroll_line_height - 2, scroll_line_height - 2)

			local iconFrame = CreateFrame("frame", "$parentIconFrame", line)
			iconFrame:SetAllPoints(icon)
			iconFrame:SetScript("OnEnter", lineOnEnter)
			iconFrame:SetScript("OnLeave", lineOnLeave)

			--spellname
			local spellNameText = DetailsFramework:CreateTextEntry(line, function()end, DetailsScrollDamage.Header:GetColumnWidth(2), scroll_line_height, _, _, _, dropdownTemplate)

			--damage
			local damageText = DF:CreateLabel(line, "", fontSize, "white")

			--time
			local timeText = DF:CreateLabel(line, "", fontSize, "white")

			--spell ID
			local spellIDText = DetailsFramework:CreateTextEntry(line, function()end, DetailsScrollDamage.Header:GetColumnWidth(5), scroll_line_height, _, _, _, dropdownTemplate)

			line:AddFrameToHeaderAlignment(icon)
			line:AddFrameToHeaderAlignment(spellNameText)
			line:AddFrameToHeaderAlignment(damageText)
			line:AddFrameToHeaderAlignment(timeText)
			line:AddFrameToHeaderAlignment(spellIDText)

			line:AlignWithHeader(DetailsScrollDamage.Header, "left")

			line.Icon = icon
			line.IconFrame = iconFrame
			line.DamageText = damageText
			line.TimeText = timeText
			line.SpellIDText = spellIDText
			line.SpellNameText = spellNameText

			return line
		end

		local damageScroll = DF:CreateScrollBox(DetailsScrollDamage, "$parentSpellScroll", refreshFunc, DetailsScrollDamage.Data, scroll_width, scroll_height, scroll_lines, scroll_line_height)
		DF:ReskinSlider(damageScroll)
		damageScroll:SetPoint("topleft", DetailsScrollDamage, "topleft", 5, scrollY)

		function damageScroll:RefreshScroll()
			if (DetailsScrollDamage.searchText and DetailsScrollDamage.searchText ~= "") then
				local newData = {}
				for index, spellTable in ipairs(DetailsScrollDamage.Data) do
					local time, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellId, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = unpack(spellTable)
					spellName = spellName:lower()
					if (spellName:find(DetailsScrollDamage.searchText)) then
						newData[#newData+1] = spellTable
					end
				end
				damageScroll:SetData(newData)

			else
				damageScroll:SetData(DetailsScrollDamage.Data)
			end

			damageScroll:Refresh()
		end

		--create lines
		for i = 1, scroll_lines do
			damageScroll:CreateLine(createLineFunc)
		end

		local combatLogReader = CreateFrame("frame")
		local playerSerial = UnitGUID("player")

		combatLogReader:SetScript("OnEvent", function(self)
			local timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = CombatLogGetCurrentEventInfo()
			if (sourceSerial == playerSerial) then
				if (token == "SPELL_DAMAGE" or token == "SPELL_PERIODIC_DAMAGE" or token == "RANGE_DAMAGE" or token == "DAMAGE_SHIELD") then
					if (not DetailsScrollDamage.Data.Started) then
						DetailsScrollDamage.Data.Started = time()
					end
					tinsert(DetailsScrollDamage.Data, 1, {timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill or 0, school or 1, resisted or 0, blocked or 0, absorbed or 0, isCritical})
					wipe(DetailsScrollDamage.searchCache)
					damageScroll:RefreshScroll()

				elseif (token == "SWING_DAMAGE") then
				--	amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand = spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical
				--	tinsert(DetailsScrollDamage.Data, 1, {timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical})
				--	damageScroll:RefreshScroll()
				end
			end
		end)

		DetailsScrollDamage:SetScript("OnShow", function()
			wipe(DetailsScrollDamage.Data)
			damageScroll:RefreshScroll()
			combatLogReader:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end)

		DetailsScrollDamage:SetScript("OnHide", function()
			combatLogReader:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end)

		--statusbar and auto open checkbox
		local statusBar = CreateFrame("frame", nil, DetailsScrollDamage, "BackdropTemplate")
		statusBar:SetPoint("bottomleft", DetailsScrollDamage, "bottomleft")
		statusBar:SetPoint("bottomright", DetailsScrollDamage, "bottomright")
		statusBar:SetHeight(20)
		statusBar:SetAlpha(0.8)
		DF:ApplyStandardBackdrop(statusBar)

		local onToggleAutoOpen = function(_, _, state)
			Details.damage_scroll_auto_open = state
		end
		local autoOpenCheckbox = DetailsFramework:CreateSwitch(statusBar, onToggleAutoOpen, Details.auto_open_news_window, _, _, _, _, "AutoOpenCheckbox", _, _, _, _, _, DetailsFramework:GetTemplate("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		autoOpenCheckbox:SetAsCheckBox()
		autoOpenCheckbox:SetPoint("left", statusBar, "left", 5, 0)

		local autoOpenText = DetailsFramework:CreateLabel(statusBar, "Auto Open on Training Dummy", 10)
		autoOpenText:SetPoint("left", autoOpenCheckbox, "right", 2, 0)

		--search bar
		local searchBox = DF:CreateTextEntry(statusBar, function()end, 150, 18, _, _, _, DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		searchBox:SetPoint("bottomright", statusBar, "bottomright", -2, 0)

		local searchLabel = DF:CreateLabel(searchBox, "search")
		searchLabel.fontcolor = "silver"
		searchLabel:SetPoint("left", searchBox, "left", 3, 0)

		searchBox:SetHook("OnTextChanged", function()
			if (searchBox.text ~= "") then
				searchLabel:Hide()
			end
			DetailsScrollDamage.searchText = searchBox.text
			damageScroll:RefreshScroll()
		end)
	end

	DetailsScrollDamage:Show()
end

local targetDummieHandle = CreateFrame("frame")
local targetDummiesIds = {
    [31146] = true, --raider's training dummie
}

targetDummieHandle:SetScript("OnEvent", function(_, _, unit)
	if (not Details.damage_scroll_auto_open) then
		return
	end
    if (UnitExists("target")) then
        local serial = UnitGUID("target")
        if (serial) then
            local npcId = DetailsFramework:GetNpcIdFromGuid(serial)
            if (npcId) then
                if (targetDummiesIds[npcId]) then
                    Details:ScrollDamage()
                end
            end
        end
    end
end)
targetDummieHandle:RegisterEvent("PLAYER_TARGET_CHANGED")
