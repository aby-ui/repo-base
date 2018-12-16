local addon = select(2, ...)
local D, L, P = addon.getLocalVars()
local TCL = addon.TomCatsLibs
local AceGUI = LibStub("AceGUI-3.0")
--[[TCL.BulletinBoard.checkForUpdates("1.1.7", 3, {"VjWrxWeFqML","A2qGxbImAE","kWemgqIWpR"}, function(updateAvailable, latestVersion)
    if (updateAvailable) then
        print("|cFFFFCC00There is newer version of 'TomCat's Tours: Rares of Darkshore Highlands' available on Twitch and Curseforge|r")
    end
end);]]
local gameVersion = GetBuildInfo()
local _, checkIsBossAvailable, QUEST_STATUS, initializeWindow, setQuestLabelStyle, updateQuests, labels, buttons, quests, windowSettings
local tourWindow, newTourWindow, warfrontFont, warningFont, updateTimer
local questTrackingColumnName, enemyReactColumnName
local GetVignettes_Orig = C_VignetteInfo.GetVignettes
local playerFaction, enemyFaction = addon.playerFaction, addon.enemyFaction
local initializeQuests, updateLabelTexts
local warfrontPhases = {
    ["Alliance"] = 1,
    ["Horde"] = 2
}

local function suppressVignettes()
    if (HandyNotes and addon.savedVariables.character.enableHandyNotesPlugin) then
        return true
    end
    local stack = debugstack()
    if (string.find(stack, "SilverDragon")) then return true end
    if (string.find(stack, "RareScanner")) then return true end
    if (string.find(stack, "NPCScan")) then return true end
    local mapID = C_Map.GetBestMapForUnit("player")
    if (mapID and mapID == addon.params["Vignette MapID"]) then return false end
    if (WorldMapFrame and WorldMapFrame:GetMapID() == addon.params["Vignette MapID"]) then return false end
    return true
end

function C_VignetteInfo.GetVignettes()
    local vignettes = GetVignettes_Orig()
    if (suppressVignettes()) then return vignettes end
    for creatureID, creature in pairs(D["Creatures"].records) do
        local vignetteInfo = creature["Vignette Info"]
        if (vignetteInfo and vignetteInfo.name) then
            local location = D["Creatures"][creatureID]["Locations"][warfrontPhases[addon.getWarfrontPhase()]]
            if (location) then
                table.insert(vignettes, vignetteInfo.vignetteGUID)
            end
        end
    end
    return vignettes
end

local GetVignetteInfo_Orig = C_VignetteInfo.GetVignetteInfo

function C_VignetteInfo.GetVignetteInfo(vignetteGUID)
    if (suppressVignettes()) then return GetVignetteInfo_Orig(vignetteGUID) end
    local creature = D["Creatures by Vignette GUID"][vignetteGUID]
    if (creature) then
        return creature["Vignette Info"]
    end
    local vignetteInfo = GetVignetteInfo_Orig(vignetteGUID)
    if (C_VignetteInfo.GetVignettePosition(vignetteGUID, P["Vignette MapID"]) and D["Creatures by Vignette ID"][vignetteInfo.vignetteID]) then
        vignetteInfo.onWorldMap = true
        vignetteInfo.hasTooltip = true
    end
    return vignetteInfo
end

local GetVignettePosition_Orig = C_VignetteInfo.GetVignettePosition

function C_VignetteInfo.GetVignettePosition(vignetteGUID, uiMapID)
    if (suppressVignettes()) then return GetVignettePosition_Orig(vignetteGUID, uiMapID) end
    if (uiMapID == P["Vignette MapID"]) then
        local creature = D["Creatures by Vignette GUID"][vignetteGUID]
        if (creature) then
            local location = D["Creatures"][creature["Creature ID"]]["Locations"][warfrontPhases[addon.getWarfrontPhase()]]
            if (location) then
                local vector2D = CreateFromMixins(Vector2DMixin)
                vector2D.x = location[1]
                vector2D.y = location[2]
                return vector2D
            end
        end
    end
    return GetVignettePosition_Orig(vignetteGUID, uiMapID)
end

local FindBestUniqueVignette_Orig = C_VignetteInfo.FindBestUniqueVignette

function C_VignetteInfo.FindBestUniqueVignette(vignetteGUIDs)
    local index = FindBestUniqueVignette_Orig(vignetteGUIDs)
    if (suppressVignettes()) then return index end
    if (not index) then
        for i = 1, #vignetteGUIDs, 1 do
            local creature = D["Creatures by Vignette GUID"][vignetteGUIDs[i]]
            if (creature) then
                return i
            end
        end
    end
    return index
end

local function ADDON_LOADED(self)
    windowSettings = addon.savedVariables.character.windowSettings or { width = 360, height = 330 }
    local completeFont = CreateFont("Complete")
    completeFont:SetFontObject(SystemFont_Small)
    completeFont:SetTextColor(0, 1, 0)
    local incompleteFont = CreateFont("Incomplete")
    incompleteFont:SetFontObject(SystemFont_Small)
    incompleteFont:SetTextColor(0.75, 0.75, 0.75)
    local unavailableFont = CreateFont("Unavailable")
    unavailableFont:SetFontObject(SystemFont_Small)
    unavailableFont:SetTextColor(1, 0, 0)
    warfrontFont = CreateFont("Warfront Timer")
    warfrontFont:SetFontObject(SystemFont_Small)
    warfrontFont:SetJustifyH("CENTER")
    warfrontFont:SetTextColor(1, 1, 0)
    warningFont = CreateFont("Warning Font")
    warningFont:SetFontObject(SystemFont_Small)
    warningFont:SetJustifyH("CENTER")
    warningFont:SetTextColor(1, 0, 0)
    local starFunction
    if (gameVersion == "8.0.1") then
        starFunction = function() return 1121272, 492/1024, 524/1024, 443/512, 475/512 end
    else
        starFunction = function() return 1121272, 575/1024, 607/1024, 205/512, 237/512 end
    end
    QUEST_STATUS = {
        COMPLETE = {
            getImage = function() return 973338, 123/256, 159/256, 94/128, 126/128 end,
            font = completeFont,
            texture = "complete",
            color = { r = 0, g = 1, b = 0 }
        },
        INCOMPLETE = {
            getImage = starFunction,
            font = incompleteFont,
            texture = "incomplete",
            color = { r = 0.75, g = 0.75, b = 0.75 }
        },
        UNAVAILABLE = {
            getImage = function() return "Interface\\Buttons\\UI-GroupLoot-Pass-Up" end,
            font = unavailableFont,
            texture = "unavailable",
            color = { r = 1, g = 0, b = 0 }
        }
    }
    questTrackingColumnName = ("%s Tracking ID"):format(playerFaction)
    enemyReactColumnName = ("%s React"):format(enemyFaction)
    initializeQuests()
    TCL.Charms.Create({
        name = addon.name .. "MinimapButton",
        iconTexture = "Interface\\AddOns\\" .. addon.name .. "\\images\\darnassus-icon",
        backgroundColor = {68/255,34/255,68/255,0.80 },
        handler_onclick = addon.toggleTourWindow
    }).tooltip = {
        Show = function(this)
            GameTooltip:ClearLines()
            GameTooltip:SetOwner(this, "ANCHOR_LEFT")
            GameTooltip:SetText("TomCat的旅行:", 1, 1, 1)
            GameTooltip:AddLine("黑海岸稀有精英", nil, nil, nil, true)
            GameTooltip:AddLine("(黑海岸战争前线)", nil, nil, nil, true)
            GameTooltip:Show()
        end,
        Hide = function()
            GameTooltip:Hide()
        end
    }
    TCL.Events.RegisterEvent("PLAYER_LOGOUT", addon)
    if (windowSettings.showing) then
        --todo: remove timer
        C_Timer.After(1, initializeWindow)
    end
    TCL.Events.RegisterEvent("QUEST_LOG_UPDATE", addon)
    C_Timer.After(P["Timer Delay"], updateTimer)
    TCL.Events.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
end

TCL.Events.RegisterEvent("ADDON_LOADED", ADDON_LOADED)

function initializeWindow()
    if (tourWindow and tourWindow:IsShown()) then
        return
    else
        addon:toggleTourWindow()
    end
end

function addon:PLAYER_LOGOUT()
    if (tourWindow) then
        windowSettings.width = tourWindow.frame:GetWidth()
        windowSettings.height = tourWindow.frame:GetHeight()
        windowSettings.point, _, windowSettings.relativePoint, windowSettings.x, windowSettings.y = tourWindow:GetPoint(1)
        addon.savedVariables.character.windowSettings = windowSettings
    end
end

function addon:QUEST_LOG_UPDATE()
    if (windowSettings.showing and tourWindow and tourWindow:IsShown()) then
        updateQuests()
    end
    addon.refreshStatusForAllCreatures()
    if (HandyNotes) then
        HandyNotes.WorldMapDataProvider:RefreshPlugin("TomCat's Tours: Rares of Darkshore")
        HandyNotes:UpdateMinimapPlugin("TomCat's Tours: Rares of Darkshore")
    end
end

updateQuests = function()
    local playerLevel = UnitLevel("player")
    if (playerLevel < 120 or gameVersion == "8.0.1") then
        return
    end
    if(tourWindow) then
        if (tourWindow.warningLabel) then
            tourWindow.warningLabel:SetText("")
            tourWindow.warningLabel = nil
            tourWindow:DoLayout()
        end
    end
    local isBossAvailable = checkIsBossAvailable()
    local qc = GetQuestsCompleted()
    for k in pairs(quests) do
        if (gameVersion == "8.0.1") then
            if (quests[k].status ~= QUEST_STATUS.UNAVAILABLE) then
                quests[k].status = QUEST_STATUS.UNAVAILABLE
                setQuestLabelStyle(quests[k])
            end
        else
            if (qc[k]) then
                if (quests[k].status ~= QUEST_STATUS.COMPLETE) then
                    quests[k].status = QUEST_STATUS.COMPLETE
                    setQuestLabelStyle(quests[k])
                end
            else
                if (not D["Creatures"][quests[k]["Creature ID"]]["Locations"][warfrontPhases[addon.getWarfrontPhase()]]) then
                    if (quests[k].status ~= QUEST_STATUS.UNAVAILABLE) then
                        quests[k].status = QUEST_STATUS.UNAVAILABLE
                        setQuestLabelStyle(quests[k])
                    end
                else
                    if (quests[k].status ~= QUEST_STATUS.INCOMPLETE) then
                        quests[k].status = QUEST_STATUS.INCOMPLETE
                        setQuestLabelStyle(quests[k])
                    end
                end
            end
        end
    end
end

function initializeQuests()
    quests = {}
    labels = {}
    buttons = {}
    if (gameVersion == "8.0.1") then
        return
    end
    local isBossAvailable = checkIsBossAvailable()
    local playerLevel = UnitLevel("player")
    local namesLoaded = true
    local labelMinWidth = 0
    local buttonMinWidth = 0
    for k, v in pairs(D["Creatures"].records) do
        local questID = v[questTrackingColumnName]
        if (questID) then
            local quest = {}
            quests[questID] = quest
            quest["Creature ID"] = k
            local label = AceGUI:Create("TomCatsInteractiveLabel")
            label:SetCallback("OnEnter", function(widget)
                addon.showItemTooltip(widget.frame, v, true)
            end)
            label:SetCallback("OnLeave", addon.hideItemTooltip)
            local button = CreateFrame("BUTTON", "TomCats-DarkshoreRaresRareButton"..k, UIParent, "TomCats-DarkshoreRaresRareButtonTemplate")
            quest.label = label
            quest.button = button
            if (namesLoaded) then
                local name = addon.getRareNameByCreatureID(k)
                if (not name) then
                    -- todo: localize
                    label:SetText("Loading...")
                    button:SetText("Loading...")
                    namesLoaded = false
                else
                    label:SetText(name)
                    button:SetText(name)
                end
            else
                label:SetText("Loading...")
                button:SetText("Loading...")
            end
            local minWidth = label:GetMinWidth()
            if minWidth > labelMinWidth then
                labelMinWidth = minWidth
            end
            minWidth = button:GetTextWidth()
            if minWidth > labelMinWidth then
                buttonMinWidth = minWidth
            end
            if (playerLevel < 120 or gameVersion == "8.0.1") then
                quest.status = QUEST_STATUS.UNAVAILABLE
            elseif (IsQuestFlaggedCompleted(questID)) then
                quest.status = QUEST_STATUS.COMPLETE
            else
                if ((not isBossAvailable) and (v[enemyReactColumnName] == 1)) then
                    quest.status = QUEST_STATUS.UNAVAILABLE
                else
                    quest.status = QUEST_STATUS.INCOMPLETE
                end
            end
            setQuestLabelStyle(quest)
            table.insert(labels, label)
            table.insert(buttons, button)
        end
    end
    labelMinWidth = labelMinWidth + 15
    for i = 1, #labels, 1 do
        labels[i]:SetWidth(labelMinWidth)
    end
    buttonMinWidth = buttonMinWidth + 18
    for i = 1, #buttons, 1 do
        buttons[i]:SetWidth(buttonMinWidth)
    end
end

function addon:toggleTourWindow()
    if (tourWindow and tourWindow:IsShown()) then
        PlaySound(799)
        windowSettings.showing = false
        tourWindow:Hide()
        --newTourWindow:Hide()
    elseif (tourWindow) then
        PlaySound(799)
        windowSettings.showing = true
        updateQuests()
        tourWindow:Show()
        --newTourWindow:Show()
    else
        PlaySound(799)
        ----------------------------------
        newTourWindow = CreateFrame("Frame", "TomCats-DarkshoreRaresTourWindow", UIParent, "TomCats-DarkshoreRaresTourWindowTemplate")
        --newTourWindow:Show()
        _G["TomCats-DarkshoreRaresTourWindowPortrait"]:SetTexture("Interface\\AddOns\\" .. addon.name .. "\\images\\darnassus-icon");
        _G["TomCats-DarkshoreRaresTourWindowPortrait"]:SetTexCoord(0, 1, 0, 1);
        _G["TomCats-DarkshoreRaresTourWindowPortraitBackground"]:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall");
        _G["TomCats-DarkshoreRaresTourWindowPortraitBackground"]:SetVertexColor(118/255,18/255,20/255,1);
        _G["TomCats-DarkshoreRaresTourWindowTitleText"]:SetText("|cFFFFFFFF" .. L["TomCat's Tours"]);
        _G["TomCats-DarkshoreRaresTourWindowTitle2Text"]:SetText(L["Rares of Darkshore Highlands"] .. "\n(" .. L["Warfront on Darkshore"] .. ")");
        newTourWindow.onCloseCallback = function() addon:toggleTourWindow() end
        ----------------------------------

        tourWindow = AceGUI:Create("Window")
        tourWindow.closebutton:SetScript("OnClick", function()
            addon:toggleTourWindow()
        end)
        tourWindow:SetTitle(L["TomCat's Tours"] .. ": " .. L["Rares of Darkshore"])
        tourWindow:SetLayout("Fill")
        tourWindow:SetAutoAdjustHeight(true)
        if (windowSettings.height and windowSettings.width) then
            tourWindow:SetHeight(windowSettings.height)
            tourWindow:SetWidth(windowSettings.width)
        end
        if (windowSettings.point and windowSettings.relativePoint and windowSettings.x and windowSettings.y) then
            tourWindow:ClearAllPoints()
            tourWindow:SetPoint(windowSettings.point, nil, windowSettings.relativePoint, windowSettings.x, windowSettings.y)
        end
        tourWindow.scroll = AceGUI:Create("ScrollFrame")
        tourWindow.scroll:SetLayout("Flow")
        tourWindow:AddChild(tourWindow.scroll)
        if (gameVersion == "8.0.1") then
            if (not tourWindow.warningLabel) then
                tourWindow.warningLabel = AceGUI:Create("Label")
                tourWindow.warningLabel:SetFontObject(warningFont)
                tourWindow.warningLabel:SetColor(warningFont:GetTextColor())
                tourWindow.warningLabel:SetJustifyH("CENTER")
                tourWindow.warningLabel:SetRelativeWidth(1)
                tourWindow.warningLabel:SetText("Unavailable until patch 8.1 \r\n")
                tourWindow.scroll:AddChild(tourWindow.warningLabel)
            end
        end
        local playerLevel = UnitLevel("player")
        if (playerLevel < 120) then
            if (not tourWindow.warningLabel) then
                tourWindow.warningLabel = AceGUI:Create("Label")
                tourWindow.warningLabel:SetFontObject(warningFont)
                tourWindow.warningLabel:SetColor(warningFont:GetTextColor())
                tourWindow.warningLabel:SetJustifyH("CENTER")
                tourWindow.warningLabel:SetRelativeWidth(1)
                tourWindow.warningLabel:SetText(L["Unavailable_Below_120"] .. "\r\n")
                tourWindow.scroll:AddChild(tourWindow.warningLabel)
                tourWindow:Hide()
                tourWindow:Show()
                return
            end
        end
        if (not addon.creatureNamesLoaded) then
            updateLabelTexts()
        end
        for i = 1, #labels, 1 do
            tourWindow.scroll:AddChild(labels[i])
        end
        for i = 1, #buttons, 1 do
            buttons[i]:SetParent(_G["TomCats-DarkshoreRaresTourWindowRaresScrollFrameScrollChild"])
            if i > 1 then
                buttons[i]:SetPoint("TOPLEFT", buttons[i-1]:GetName(), "BOTTOMLEFT", 0, 0)
            else
                buttons[i]:SetPoint("TOPLEFT", _G["TomCats-DarkshoreRaresTourWindowRaresScrollFrameScrollChild"], "TOPLEFT", 0, 0)
            end
            buttons[i]:Show()
        end
        tourWindow.frame:SetMinResize(300, 150)
        tourWindow.frame:SetFrameStrata("MEDIUM")
        tourWindow.initialized = true
        windowSettings.showing = true
    --workaround for incorrect render
    --TODO: Debug this
        tourWindow:Hide()
        tourWindow:Show()
    end
end

function updateLabelTexts()
    if ((not addon.creatureNamesLoaded) and addon.loadCreatureNames()) then
        local labelMinWidth = 0
        for _, quest in pairs(quests) do
            quest.label:SetText(D["Creatures"][quest["Creature ID"]]["Name"])
            local minWidth = quest.label:GetMinWidth()
            if minWidth > labelMinWidth then
                labelMinWidth = minWidth
            end
        end
        labelMinWidth = labelMinWidth + 15
        for i = 1, #labels, 1 do
            labels[i]:SetWidth(labelMinWidth)
        end
        if (tourWindow) then
            tourWindow:DoLayout()
        end
    end
end

setQuestLabelStyle = function(quest)
    quest.label:SetImage(quest.status.getImage())
    quest.label:SetFontObject(quest.status.font)
    quest.label:SetImageSize(14, 14)
    for k, v in pairs(QUEST_STATUS) do
        if (quest.status == v) then
            quest.button[v.texture]:Show()
        else
            quest.button[v.texture]:Hide()
        end
    end
    local color = quest.status.color
    quest.button.text:SetTextColor(color.r, color.g, color.b)
end

updateTimer = function()
    updateLabelTexts()
    if (tourWindow and tourWindow.initialized and tourWindow:IsShown()) then
        updateQuests()
        collectgarbage()
    end
    C_Timer.After(P["Timer Delay"], updateTimer)
end

checkIsBossAvailable = function()
    return (playerFaction == addon.getWarfrontPhase())
end

local LOOT_NOUN_COLOR = CreateColor(1.0, 0.82, 0.0, 1.0)

function addon.showItemTooltip(self, creature, showCreatureName, offX, offY)
    local tooltip = WorldMapTooltip
    WorldMapTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", offX or -50, offY or 20);
    if (showCreatureName) then
        local color = WORLD_QUEST_QUALITY_COLORS[1];
        WorldMapTooltip:SetText(creature["Name"], color.r, color.g, color.b);
        GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
    end
--STAT_AVERAGE_ITEM_LEVEL
    if (creature["Loot"]) then
        GameTooltip_AddColoredLine(tooltip, LOOT_NOUN, LOOT_NOUN_COLOR, true);
        EmbeddedItemTooltip_SetItemByID(tooltip.ItemTooltip, creature["Loot"])
    elseif (creature["Loot Type"] == 5) then
        GameTooltip_AddColoredLine(tooltip, STAT_AVERAGE_ITEM_LEVEL .. " " .. "385" .. " " .. LOOT_NOUN, LOOT_NOUN_COLOR, true);
        GameTooltip_AddColoredLine(tooltip, "(See adventure guide)", LOOT_NOUN_COLOR, true);
    else
        GameTooltip_AddColoredLine(tooltip, LOOT_NOUN, LOOT_NOUN_COLOR, true);
        local name, texture, quantity, quality = CurrencyContainerUtil.GetCurrencyContainerInfo(1553, 39);
        local text = BONUS_OBJECTIVE_REWARD_FORMAT:format(texture, name);
        local color = ITEM_QUALITY_COLORS[quality];
        tooltip:AddLine(text, color.r, color.g, color.b);
    end
    WorldMapTooltip:Show()
    WorldMapTooltip.recalculatePadding = true;
end

function addon.hideItemTooltip()
    WorldMapTooltip:Hide()
end

local VignettePinMixin_OnMouseEnter_Orig = VignettePinMixin.OnMouseEnter

function VignettePinMixin:OnMouseEnter()
    local creature = D["Creatures by Vignette ID"][self.vignetteID]
    if (creature) then
        addon.showItemTooltip(self, creature, true, 10, 5)
    else
        return VignettePinMixin_OnMouseEnter_Orig(self)
    end
end

if (HandyNotes) then
    local incompleteIcon = {icon = 1121272, tCoordLeft = 575/1024, tCoordRight = 607/1024, tCoordTop = 205/512, tCoordBottom = 237/512 }
    local completeIcon = {icon = 973338, tCoordLeft = 123/256, tCoordRight = 159/256, tCoordTop = 94/128, tCoordBottom = 126/128 }
    local nilFunc = function() return nil end
    local coordLookup = {}
    local HandyNotesPlugin = {
        GetNodes2 = function(self, uiMapID, minimap)
            if (uiMapID ~= addon.params["Vignette MapID"]) then return nilFunc end
            if (not addon.savedVariables.character.enableHandyNotesPlugin) then return nilFunc end
            local vignettes = {}
            for creatureID, creature in pairs(D["Creatures"].records) do
                local vignetteInfo = creature["Vignette Info"]
                if (vignetteInfo and vignetteInfo.name) then
                    local location = creature["Locations"][warfrontPhases[addon.getWarfrontPhase()]]
                    if (location and (((creature["Status"] == addon.STATUS.COMPLETE) or (creature["Status"] == addon.STATUS.LOOT_ELIGIBLE)))) then
                        table.insert(vignettes, D["Creatures"][creatureID])
                    end
                end
            end
            local i = 0
            return function()
                i = i + 1
                local creature = vignettes[i]
                if (creature) then
                    local coords = creature["Locations"][warfrontPhases[addon.getWarfrontPhase()]]
                    local coord = math.floor(coords[1] * 10000) * 10000 + math.floor(coords[2] * 10000)
                    coordLookup[coord] = creature
                    local icon = incompleteIcon
                    if (creature["Status"] == addon.STATUS.COMPLETE) then
                        icon = completeIcon
                    end
                    return coord, uiMapID,
                    icon,
                    2.0, 1.0
                else
                    return nil
                end
            end
        end,
        OnEnter = function(pinHandler, uiMapID, coord)
            addon.showItemTooltip(pinHandler, coordLookup[coord], true, 10, 5)
        end,
        OnLeave = function()
            addon.hideItemTooltip()
        end
    }

    local HandyNotesOptions = {
        type="group",
        name= "战争前线黑海岸", --""TomCat's Tours: Darkshore",
        get = function(info) return addon.savedVariables.character.enableHandyNotesPlugin or false end,
        set = function(info, v)
            addon.savedVariables.character.enableHandyNotesPlugin = v
        end,
        args = {
            enablePlugin = {
                type = "toggle",
                arg = "enable_plugin",
                name = "Enable Plugin",
                order = 1,
                width = "normal",
            }
        }
    }

    HandyNotes:RegisterPluginDB("TomCat's Tours: Rares of Darkshore", HandyNotesPlugin, HandyNotesOptions)
end
