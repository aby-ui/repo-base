

local Details = _G.Details
local DF = _G.DetailsFramework
local _

local startX = 5
local headerY = -30
local scrollY = headerY - 20

local targetCharacter = ""
local backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}
local backdrop_color = {.2, .2, .2, 0.2}
local backdrop_color_2 = {.4, .4, .4, 0.2}
local backdrop_color_on_enter = {.6, .6, .6, 0.3}
local backdrop_color_is_critical = {.4, .4, .2, 0.2}
local backdrop_color_is_critical_on_enter = {1, 1, .8, 0.4}

local scroll_width = 1180
local windowHeight = 600
local scrollLines = 26
local scrollLineHeight = 20

function Details.OpenSpellCategoryScreen()
    if (not DetailsSpellCategoryFrame) then
		DetailsSpellCategoryFrame = DetailsFramework:CreateSimplePanel(UIParent)
        local detailsSpellCategoryFrame = DetailsSpellCategoryFrame
		detailsSpellCategoryFrame:SetSize(scroll_width, windowHeight)
		detailsSpellCategoryFrame:SetTitle("Details Spell Categories")
		detailsSpellCategoryFrame.Data = {}

		--statusbar
		local statusBar = CreateFrame("frame", nil, detailsSpellCategoryFrame, "BackdropTemplate")
		statusBar:SetPoint("bottomleft", detailsSpellCategoryFrame, "bottomleft")
		statusBar:SetPoint("bottomright", detailsSpellCategoryFrame, "bottomright")
		statusBar:SetHeight(20)
		statusBar:SetAlpha (0.8)
		DF:ApplyStandardBackdrop(statusBar)

		--create the header
		local headerTable = {
			{text = "Icon", width = 24},
			{text = "Spell Name", width = 100},
            {text = "NONE", width = 120},
			{text = "Offensive CD", width = 120},
			{text = "Personal Defensive CD", width = 120},
			{text = "Target Defensive CD", width = 120},
			{text = "Raid Defensive CD", width = 120},
			{text = "Raid Utility CD", width = 120},
			{text = "Interrupt", width = 120},
			{text = "Dispel", width = 120},
			{text = "CC", width = 120},
		}
		local headerOptions = {
			padding = 2,
		}

        detailsSpellCategoryFrame.Header = DetailsFramework:CreateHeader(detailsSpellCategoryFrame, headerTable, headerOptions)
        detailsSpellCategoryFrame.Header:SetPoint("topleft", detailsSpellCategoryFrame, "topleft", startX, headerY)

        --create the scroll bar
        local scrollRefreshFunc = function(self, data, offset, totalLines)
			for i = 1, totalLines do
				local index = i + offset
				local spellTable = data[index]

				if (spellTable) then
                    local spellId = spellTable[1]

                    --get a line
					local line = self:GetLine(i)

                    local spellName, _, spellIcon = GetSpellInfo(spellId)
                    print(spellName, spellId)

                    line.Icon:SetTexture(spellIcon)
                    line.Icon:SetTexCoord(.1, .9, .1, .9)
                    line.SpellNameText.text = spellName
                    local radioGroup = line.RadioGroup

                    local radioGroupOptions = {}
                    for o in ipairs({"", "", "", "", "", "", "", "", ""}) do
                        radioGroupOptions[o] = {
                            name = "",
                            param = o,
                            get = function() return spellTable[2] == o end,
                            callback = function(param, optionId) spellTable[2] = param end,
                        }
                    end
                    radioGroup:SetOptions(radioGroupOptions)
                    local children = {radioGroup:GetChildren()}
                    for childId, childrenFrame in ipairs(children) do
                        childrenFrame:ClearAllPoints()
                        childrenFrame:SetPoint("left", line, "left", 126 + ((childId-1) * 122), 0)
                    end
                end
            end
        end

		local lineOnEnter = function (self)
			self:SetBackdropColor(unpack(backdrop_color_on_enter))
		end

		local lineOnLeave = function(self)
			self:SetBackdropColor(unpack(self.backdropColor))
		end

		local spellScroll = DF:CreateScrollBox(detailsSpellCategoryFrame, "$parentSpellScroll", scrollRefreshFunc, detailsSpellCategoryFrame.Data, scroll_width - 10, windowHeight - 58, scrollLines, scrollLineHeight)
		DF:ReskinSlider(spellScroll)
		spellScroll:SetPoint("topleft", detailsSpellCategoryFrame, "topleft", startX, scrollY)
        detailsSpellCategoryFrame.SpellScroll = spellScroll

        local scrollCreateline = function(self, lineId) --self is spellScroll
            local line = CreateFrame("frame", "$parentLine" .. lineId, self, "BackdropTemplate")
            DF:Mixin(line, DF.HeaderFunctions)

			line:SetPoint("topleft", self, "topleft", 1, -((lineId-1) * (scrollLineHeight+1)) - 1)
			line:SetSize(scroll_width - 2, scrollLineHeight)
			line:SetScript ("OnEnter", lineOnEnter)
			line:SetScript ("OnLeave", lineOnLeave)

			line:SetBackdrop(backdrop)
            if (lineId % 2 == 0) then
                line.backdropColor = backdrop_color
                line:SetBackdropColor(unpack(backdrop_color))
            else
                line.backdropColor = backdrop_color_2
                line:SetBackdropColor(unpack(backdrop_color_2))
            end

			--icon
			local icon = line:CreateTexture("$parentSpellIcon", "overlay")
			icon:SetSize(scrollLineHeight - 2, scrollLineHeight - 2)

			--spellname
			local spellNameText = DF:CreateLabel(line)

            --create radio buttons
            local radioGroup = DF:CreateRadioGroup(line, {}, "$parentRadioGroup1", {width = scroll_width, height = 20}, {offset_x = 0, amount_per_line = 7})

			line:AddFrameToHeaderAlignment(icon)
			line:AddFrameToHeaderAlignment(spellNameText)
			line:AddFrameToHeaderAlignment(radioGroup)
            line:AlignWithHeader(detailsSpellCategoryFrame.Header, "left")

			line.Icon = icon
			line.SpellNameText = spellNameText
            line.RadioGroup = radioGroup

            return line
        end

        --create spell lines with the scroll
		for i = 1, scrollLines do
			spellScroll:CreateLine(scrollCreateline)
		end

        function detailsSpellCategoryFrame.GetSpellBookSpells()
            local spellIdsInSpellBook = {}

            for i = 1, GetNumSpellTabs() do
                local tabName, tabTexture, offset, numSpells, isGuild, offspecId = GetSpellTabInfo(i)

                if (offspecId == 0 and tabTexture ~= 136830) then --don't add spells found in the General tab
                    offset = offset + 1
                    local tabEnd = offset + numSpells

                    for j = offset, tabEnd - 1 do
                        local spellType, spellId = GetSpellBookItemInfo(j, "player")

                        if (spellId) then
                            if (spellType ~= "FLYOUT") then
                                local spellName = GetSpellInfo(spellId)
                                if (spellName) then
                                    GameTooltip:SetOwner(UIParent, "ANCHOR_TOPLEFT")
                                    GameTooltip:SetSpellByID(spellId)

                                    local spellIsPassive = false
                                    local spellHasCooldown = false

                                    for sideName in pairs({Left = true, Right = true}) do
                                        for fontStringIndex = 1, 3 do
                                            local tooltipFontString = _G["GameTooltipText" .. sideName .. fontStringIndex]
                                            if (tooltipFontString) then
                                                local text = tooltipFontString:GetText()
                                                if (text) then
                                                    if (text == "Passive") then
                                                        spellIsPassive = true

                                                    elseif (text:find("cooldown")) then
                                                        spellHasCooldown = true
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    if (not spellIsPassive and spellHasCooldown) then --
                                        spellIdsInSpellBook[#spellIdsInSpellBook+1] = {spellId, 0}
                                    end
                                end
                            else
                                local _, _, numSlots, isKnown = GetFlyoutInfo(spellId)
                                if (isKnown and numSlots > 0) then
                                    for k = 1, numSlots do
                                        local spellID, overrideSpellID, isKnown = GetFlyoutSlotInfo(spellId, k)
                                        if (isKnown) then
                                            local spellName = GetSpellInfo(spellID)
                                            --spellIdsInSpellBook[#spellIdsInSpellBook+1] = spellID
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            return spellIdsInSpellBook
        end

        function spellScroll:RefreshScroll()
            --create a list of spells from the spell book
            local indexedSpells = detailsSpellCategoryFrame.GetSpellBookSpells()
            spellScroll:SetData(indexedSpells)
            spellScroll:Refresh()
        end
    end

    DetailsSpellCategoryFrame.SpellScroll:RefreshScroll()
    DetailsSpellCategoryFrame:Show()
end
