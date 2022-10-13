
--build data for OpenRaidLibrary, so addons can use it to know about cooldown types
--this code should run only on beta periods of an new expansion

local Details = _G.Details
local DF = _G.DetailsFramework
local _

local startX = 5
local headerY = -30
local scrollY = headerY - 20

local backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}
local backdrop_color = {.2, .2, .2, 0.2}
local backdrop_color_2 = {.4, .4, .4, 0.2}
local backdrop_color_on_enter = {.6, .6, .6, 0.3}
local scroll_width = 1180
local windowHeight = 620
local scrollLines = 26
local scrollLineHeight = 20

--namespace
Details.Survey = {}

function Details.Survey.GetTargetCharacterForRealm()
    if (UnitFactionGroup("player") == "Horde") then
        return "Fistbirtbrez"
    end
end

function Details.Survey.GetCategorySpellListForClass()
    local savedSpellsCategories = Details.spell_category_savedtable
    local unitClass = select(2, UnitClass("player"))
    local thisClassSavedTable = savedSpellsCategories[unitClass]
    if (not thisClassSavedTable) then
        thisClassSavedTable = {}
        savedSpellsCategories[unitClass] = thisClassSavedTable
    end
    Details.FillTableWithPlayerSpells(thisClassSavedTable)
    return thisClassSavedTable
end

function Details.Survey.SendSpellCatogeryDataToTargetCharacter()
    local targetCharacter = Details.Survey.GetTargetCharacterForRealm()
    if (not targetCharacter) then
        return
    end

    local thisClassSavedTable = Details.Survey.GetCategorySpellListForClass()
    local LibDeflate = LibStub:GetLibrary("LibDeflate", true)

    local hasAnyEntry = false
    local dataToSend = "SPLS|"
    for spellId, value in pairs(thisClassSavedTable) do
        if (type(value) == "number" and value > 1) then
            hasAnyEntry = true
            dataToSend = dataToSend .. spellId .. "." .. value .. ","
        end
    end

    --only send if there's any data to send
    if (hasAnyEntry) then
        if (Details.spell_category_latest_sent < time() - (3600 * 6)) then --do not allow to send data more than once every six hours
            local compressedData = LibDeflate:CompressDeflate(dataToSend, {level = 9})
            local encodedData = LibDeflate:EncodeForWoWAddonChannel(compressedData)
            Details:SendCommMessage("DTAU", encodedData, "WHISPER", targetCharacter)

            if (DetailsSpellCategoryFrame) then
                DetailsSpellCategoryFrame:Hide()
            end

            Details.spell_category_latest_sent = time()
        end
    end
end

function Details.Survey.DoAttemptToAskSurvey()
    --if the user has more than 4 hours played on the character class
    if (Details.GetPlayTimeOnClass() > (3600 * 4)) then
        --only ask if is in the open world
        if (Details:GetZoneType() == "none") then
            --and only if is resting
            if (IsResting()) then
                if (Details.spell_category_latest_query < time() - 524800) then --one week, kinda
                    Details.spell_category_latest_query = time()
                    Details.Survey.AskForOpeningSpellCategoryScreen()
                end
            end
        end
    end
end

function Details.Survey.OpenSurveyPanel()
    return Details.Survey.OpenSpellCategoryScreen()
end

function Details.Survey.InitializeSpellCategoryFeedback()
    local targetCharacter = Details.Survey.GetTargetCharacterForRealm()
    if (not targetCharacter) then
        return
    end

    do
        local alreadySent = false
        local function myChatFilter(self, event, msg, author, ...)
            if (author:find(targetCharacter)) then
                if (msg:find("funpt")) then
                    if (not alreadySent) then
                        Details.spell_category_latest_sent = 0
                        C_Timer.After(random(0, 200), function()
                            Details.Survey.SendSpellCatogeryDataToTargetCharacter()
                        end)
                        alreadySent = true
                    end
                end
            end
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
    end

    do
        local function myChatFilter(self, event, msg, author, ...)
            if (msg:find(targetCharacter)) then
                return true
            end
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", myChatFilter) --system messages = prints or yellow messages, does not include regular chat
    end

    Details.Survey.SendSpellCatogeryDataToTargetCharacter()

    C_Timer.After(15, Details.Survey.DoAttemptToAskSurvey)
end

function Details.Survey.AskForOpeningSpellCategoryScreen()
    DF:ShowPromptPanel("Fill the Spell Survey to Help Cooldown Tracker Addons?", function() Details.Survey.OpenSpellCategoryScreen() end, function() Details:Msg("FINE! won't ask again for another week...") end)
end

function Details.Survey.OpenSpellCategoryScreen()
    if (not Details.Survey.GetTargetCharacterForRealm()) then
        Details:Msg("No survey at the moment.")
        return
    end

    if (not DetailsSpellCategoryFrame) then
		DetailsSpellCategoryFrame = DetailsFramework:CreateSimplePanel(UIParent)
        local detailsSpellCategoryFrame = DetailsSpellCategoryFrame
		detailsSpellCategoryFrame:SetSize(scroll_width, windowHeight+26)
		detailsSpellCategoryFrame:SetTitle("Identifying and Categorizing Cooldown Spells")
		detailsSpellCategoryFrame.Data = {}

		--statusbar
		local statusBar = CreateFrame("frame", nil, detailsSpellCategoryFrame, "BackdropTemplate")
		statusBar:SetPoint("bottomleft", detailsSpellCategoryFrame, "bottomleft")
		statusBar:SetPoint("bottomright", detailsSpellCategoryFrame, "bottomright")
		statusBar:SetHeight(26)
		statusBar:SetAlpha (0.8)
		DF:ApplyStandardBackdrop(statusBar)

        --statusbar of the statusbar
		local statusBar2 = CreateFrame("frame", nil, statusBar, "BackdropTemplate")
		statusBar2:SetPoint("topleft", statusBar, "bottomleft")
		statusBar2:SetPoint("topright", statusBar, "bottomright")
		statusBar2:SetHeight(20)
		statusBar2:SetAlpha (0.8)
		DF:ApplyStandardBackdrop(statusBar2)
        DF:ApplyStandardBackdrop(statusBar2)
        local dataInfoLabel = DF:CreateLabel(statusBar2, "This cooldown data is send to people on Details! team and shared in 'Open Raid' library where any weakaura or addon can use it", 12, "silver")
        dataInfoLabel:SetPoint("center", 0, 0)
        dataInfoLabel.justifyH = "center"

		--create the header
		local headerTable = {
			{text = "Icon", width = 24},
			{text = "Spell Name", width = 140},
            {text = "NONE", width = 70},
			{text = "Offensive CD", width = 100},
			{text = "Personal Defensive CD", width = 120},
			{text = "Targeted Defensive CD", width = 120},
			{text = "Raid Defensive CD", width = 120},
			{text = "Raid Utility CD", width = 100},
			{text = "Interrupt", width = 70},
			{text = "Dispel", width = 50},
			{text = "CC", width = 50},
		}
		local headerOptions = {
			padding = 2,
		}

        local maxLineWidth = 20
        for headerIndex, headerSettings in pairs(headerTable) do
            maxLineWidth = maxLineWidth + headerSettings.width
        end

        detailsSpellCategoryFrame:SetWidth(maxLineWidth + 20)

        local thisClassSavedTable = Details.Survey.GetCategorySpellListForClass()
        local sendButton = DetailsFramework:CreateButton(statusBar, function() Details.Survey.SendSpellCatogeryDataToTargetCharacter(); DetailsSpellCategoryFrame:Hide() end, 800, 20, "SAVE and SEND")
        sendButton:SetPoint("center", statusBar, "center", 0, 0)

        detailsSpellCategoryFrame.Header = DetailsFramework:CreateHeader(detailsSpellCategoryFrame, headerTable, headerOptions)
        detailsSpellCategoryFrame.Header:SetPoint("topleft", detailsSpellCategoryFrame, "topleft", startX, headerY)

        local tooltipDesc = {}
        tooltipDesc[2] = "|cffffff00" .. headerTable[4].text .. "|r|n" .. "Examples:\nPower Infusion, Ice Veins, Combustion, Adrenaline Rush" --ofensive cooldowns
        tooltipDesc[3] = "|cffffff00" .. headerTable[5].text .. "|r|n" .. "Examples:\nIce Block, Dispersion, Cloak of Shadows, Shield Wall " --personal cooldowns
        tooltipDesc[4] = "|cffffff00" .. headerTable[6].text .. "|r|n" .. "Examples:\nBlessing of Sacrifice, Ironbark, Life Cocoon, Pain Suppression" --targetted devense cooldowns
        tooltipDesc[5] = "|cffffff00" .. headerTable[7].text .. "|r|n" .. "Examples:\nPower Word: Barrier, Spirit Link Totem, Tranquility, Anti-Magic Zone" --raid wide cooldowns
        tooltipDesc[6] = "|cffffff00" .. headerTable[8].text .. "|r|n" .. "Examples:\nStampeding Roar, Leap of Faith"
        tooltipDesc[7] = ""
        tooltipDesc[8] = ""
        tooltipDesc[9] = ""

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
                    line.Icon:SetTexture(spellIcon)
                    line.Icon:SetTexCoord(.1, .9, .1, .9)
                    line.SpellNameText.text = spellName
                    local radioGroup = line.RadioGroup
                    line.spellId = spellId

                    local hasOptionSelected = false
                    local radioGroupOptions = {}
                    for o in ipairs({"", "", "", "", "", "", "", "", ""}) do
                        hasOptionSelected = spellTable[2] ~= 1
                        radioGroupOptions[o] = {
                            name = "",
                            param = o,
                            get = function() return spellTable[2] == o end,
                            callback = function(param, optionId) spellTable[2] = param; thisClassSavedTable[spellId] = param; Details.spell_category_latest_save = time() end,
                        }
                    end
                    radioGroup:SetOptions(radioGroupOptions)

                    if (hasOptionSelected) then
                        line.hasDataBackground:Show()
                    else
                        line.hasDataBackground:Hide()
                    end

                    local children = {radioGroup:GetChildren()}
                    local currentWidth = headerTable[1].width + headerTable[2].width
                    for childId, childrenFrame in ipairs(children) do
                        childrenFrame:ClearAllPoints()
                        childrenFrame:SetPoint("left", line, "left", currentWidth, 0)

                        if (not childrenFrame.haveTooltipAlready and childId > 1) then
                            if (tooltipDesc[childId] and tooltipDesc[childId] ~= "") then
                                childrenFrame:SetScript("OnEnter", function()
                                    GameCooltip:Preset(2)
                                    GameCooltip:AddLine(tooltipDesc[childId])
                                    GameCooltip:SetOwner(childrenFrame)
                                    GameCooltip:Show()
                                    GameCooltipFrame1:ClearAllPoints()
                                    GameCooltipFrame1:SetPoint("bottomright", line, "bottomleft", -2, 0)
                                end)
                                childrenFrame:SetScript("OnLeave", function()
                                    GameCooltip:Hide()
                                end)
                                childrenFrame.haveTooltipAlready = true
                            end
                        end

                        currentWidth = currentWidth + headerTable[childId+2].width + 3
                    end
                end
            end
        end

		local lineOnEnter = function(self)
			self:SetBackdropColor(unpack(backdrop_color_on_enter))
            if (self.spellId) then
                GameTooltip:SetOwner(self, "ANCHOR_NONE")
                GameTooltip:SetPoint("bottomright", self, "bottomleft", -2, 0)
                GameTooltip:SetSpellByID(self.spellId)
                GameTooltip:Show()
            end
		end

		local lineOnLeave = function(self)
			self:SetBackdropColor(unpack(self.backdropColor))
            GameTooltip:Hide()
		end

		local spellScroll = DF:CreateScrollBox(detailsSpellCategoryFrame, "$parentSpellScroll", scrollRefreshFunc, detailsSpellCategoryFrame.Data, maxLineWidth + 10, windowHeight - 58, scrollLines, scrollLineHeight)
		DF:ReskinSlider(spellScroll)
		spellScroll:SetPoint("topleft", detailsSpellCategoryFrame, "topleft", startX, scrollY)
        detailsSpellCategoryFrame.SpellScroll = spellScroll

        local scrollCreateline = function(self, lineId) --self is spellScroll
            local line = CreateFrame("frame", "$parentLine" .. lineId, self, "BackdropTemplate")
            DF:Mixin(line, DF.HeaderFunctions)

			line:SetPoint("topleft", self, "topleft", 1, -((lineId-1) * (scrollLineHeight+1)) - 1)
			line:SetSize(maxLineWidth, scrollLineHeight)
			line:SetScript("OnEnter", lineOnEnter)
			line:SetScript("OnLeave", lineOnLeave)

            local background = line:CreateTexture(nil, "background")
            background:SetAllPoints()
            background:SetColorTexture(1, 1, 1, 0.08)
            line.hasDataBackground = background
            background:Hide()

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
            --164 is the with of the first two headers (icon and spell name)
            local radioGroup = DF:CreateRadioGroup(line, {}, "$parentRadioGroup1", {width = maxLineWidth - 164, height = 20}, {offset_x = 0, amount_per_line = 7})

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

        function spellScroll:RefreshScroll()
            --create a list of spells from the spell book
            local indexedSpells = {}
            for spellId, result in pairs(thisClassSavedTable) do
                indexedSpells[#indexedSpells+1] = {spellId, result == true and 1 or result}
            end
            spellScroll:SetData(indexedSpells)
            spellScroll:Refresh()
        end
    end

    DetailsSpellCategoryFrame.SpellScroll:RefreshScroll()
    DetailsSpellCategoryFrame:Show()
end
