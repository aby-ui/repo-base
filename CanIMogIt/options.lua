-- Options for CanIMogIt
--
-- Thanks to Stanzilla and Semlar and their addon AdvancedInterfaceOptions, which I used as reference.

local _G = _G
local L = CanIMogIt.L

local CREATE_DATABASE_TEXT = L["Can I Mog It? Important Message: Please log into all of your characters to compile complete transmog appearance data."]

StaticPopupDialogs["CANIMOGIT_NEW_DATABASE"] = {
    text = CREATE_DATABASE_TEXT,
    button1 = L["Okay, I'll go log onto all of my toons!"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


local DATABASE_MIGRATION = "Can I Mog It?" .. "\n\n" .. L["We need to update our database. This may freeze the game for a few seconds."]


function CanIMogIt.CreateMigrationPopup(dialogName, onAcceptFunc)
    StaticPopupDialogs[dialogName] = {
        text = DATABASE_MIGRATION,
        button1 = L["Okay"],
        button2 = L["Ask me later"],
        OnAccept = onAcceptFunc,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }
    StaticPopup_Show(dialogName)
end


-- OptionsVersion: Keep this as an integer, so comparison is easy.
CanIMogIt_OptionsVersion = "20"


CanIMogItOptions_Defaults = {
    ["options"] = {
        ["version"] = CanIMogIt_OptionsVersion,
        ["debug"] = false,
        ["databaseDebug"] = false,
        ["showEquippableOnly"] = true,
        ["showTransmoggableOnly"] = true,
        ["showUnknownOnly"] = false,
        ["showSetInfo"] = true,
        ["showItemIconOverlay"] = true,
        -- ["showBoEColors"] = true,
        ["showVerboseText"] = false,
        ["showSourceLocationTooltip"] = false,
        ["printDatabaseScan"] = true,
        ["iconLocation"] = "TOPRIGHT",
    },
}


CanIMogItOptions_DisplayData = {
    ["debug"] = {
        ["displayName"] = L["Debug Tooltip"],
        ["description"] = L["Detailed information for debug purposes. Use this when sending bug reports."],
    },
    ["showEquippableOnly"] = {
        ["displayName"] = L["Equippable Items Only"],
        ["description"] = L["Only show on items that can be equipped."]
    },
    ["showTransmoggableOnly"] = {
        ["displayName"] = L["Transmoggable Items Only"],
        ["description"] = L["Only show on items that can be transmoggrified."]
    },
    ["showUnknownOnly"] = {
        ["displayName"] = L["Unknown Items Only"],
        ["description"] = L["Only show on items that you haven't learned."]
    },
    ["showSetInfo"] = {
        ["displayName"] = L["Show Transmog Set Info"],
        ["description"] = L["Show information on the tooltip about transmog sets."] .. "\n\n" .. L["Also shows a summary in the Appearance Sets UI of how many pieces of a transmog set you have collected."]
    },
    ["showItemIconOverlay"] = {
        ["displayName"] = L["Show Bag Icons"],
        ["description"] = L["Shows the icon directly on the item in your bag."]
    },
    -- ["showBoEColors"] = {
    --     ["displayName"] = L["Show Bind on Equip Colors"],
    --     ["description"] = L["Changes the color of icons and tooltips when an item is Bind on Equip or Bind on Account."]
    -- },
    ["showVerboseText"] = {
        ["displayName"] = L["Verbose Text"],
        ["description"] = L["Shows a more detailed text for some of the tooltips."]
    },
    ["showSourceLocationTooltip"] = {
        ["displayName"] = L["Show Source Location Tooltip"] .. " " .. CanIMogIt.YELLOW .. L["(Experimental)"],
        ["description"] = L["Shows a tooltip with the source locations of an appearance (ie. Quest, Vendor, World Drop). This only works on items your current class can learn."] .. "\n\n" .. L["Please note that this may not always be correct as Blizzard's information is incomplete."]
    },
    ["printDatabaseScan"] = {
        ["displayName"] = L["Database Scanning chat messages"],
        ["description"] = L["Shows chat messages on login about the database scan."]
    },
    ["iconLocation"] = {
        ["displayName"] = L["Location: "],
        ["description"] = L["Move the icon to a different location on all frames."]
    },
}


CanIMogIt.frame = CreateFrame("Frame", "CanIMogItOptionsFrame", UIParent);
CanIMogIt.frame.name = "Can I Mog It?";
InterfaceOptions_AddCategory(CanIMogIt.frame);


local EVENTS = {
    "ADDON_LOADED",
    "TRANSMOG_COLLECTION_UPDATED",
    "PLAYER_LOGIN",
    "GET_ITEM_INFO_RECEIVED",
    "BLACK_MARKET_OPEN",
    "BLACK_MARKET_ITEM_UPDATE",
    "BLACK_MARKET_CLOSE",
    "CHAT_MSG_LOOT",
    "GUILDBANKFRAME_OPENED",
    "VOID_STORAGE_OPEN",
    "UNIT_INVENTORY_CHANGED",
    "PLAYER_SPECIALIZATION_CHANGED",
    "BAG_UPDATE",
    "BAG_NEW_ITEMS_UPDATED",
    "QUEST_ACCEPTED",
    "BAG_SLOT_FLAGS_UPDATED",
    "BANK_BAG_SLOT_FLAGS_UPDATED",
    "PLAYERBANKSLOTS_CHANGED",
    "BANKFRAME_OPENED",
    "START_LOOT_ROLL",
    "MERCHANT_SHOW",
    "VOID_STORAGE_CONTENTS_UPDATE",
    "GUILDBANKBAGSLOTS_CHANGED",
    "TRANSMOG_COLLECTION_SOURCE_ADDED",
    "TRANSMOG_COLLECTION_SOURCE_REMOVED",
    "TRANSMOG_SEARCH_UPDATED",
    "PLAYERREAGENTBANKSLOTS_CHANGED",
    "LOADING_SCREEN_ENABLED",
    "LOADING_SCREEN_DISABLED",
}

for i, event in pairs(EVENTS) do
    CanIMogIt.frame:RegisterEvent(event);
end


-- Skip the itemOverlayEvents function until the loading screen is disabled.
local lastOverlayEventCheck = 0
local overlayEventCheckThreshold = .01 -- once per frame at 100 fps
local futureOverlayPrepared = false

local function futureOverlay(event)
    -- Updates the overlay in ~THE FUTURE~. If the overlay events had multiple
    -- requests in the same frame, then this gets called.
    futureOverlayPrepared = false
    local currentTime = GetTime()
    if currentTime - lastOverlayEventCheck > overlayEventCheckThreshold then
        lastOverlayEventCheck = currentTime
        CanIMogIt.frame:ItemOverlayEvents(event)
    end
end


CanIMogIt.frame.eventFunctions = {}


function CanIMogIt.frame:AddEventFunction(func)
    -- Adds the func to the list of functions that are called for all events.
    table.insert(CanIMogIt.frame.eventFunctions, func)
end


CanIMogIt.frame:HookScript("OnEvent", function(self, event, ...)
    --[[
        To add functions you want to run with CIMI's "OnEvent", do:

        local function MyOnEventFunc(event, ...)
            Do stuff here
        end
        CanIMogIt.frame:AddEventFunction(MyOnEventFunc)
        ]]

    for i, func in ipairs(CanIMogIt.frame.eventFunctions) do
        func(event, ...)
    end

    -- TODO: Move this to it's own event function.
    -- Prevent the ItemOverlayEvents handler from running more than is needed.
    -- If more than one occur in the same frame, we update the first time, then
    -- prepare a future update in a couple frames.
    local currentTime = GetTime()
    if currentTime - lastOverlayEventCheck > overlayEventCheckThreshold then
        lastOverlayEventCheck = currentTime
        self:ItemOverlayEvents(event, ...)
    else
        -- If we haven't already, plan to update the overlay in the future.
        if not futureOverlayPrepared then
            futureOverlayPrepared = true
            C_Timer.After(.02, function () futureOverlay(event) end)
        end
    end
end)


function CanIMogIt.frame.AddonLoaded(event, addonName)
    if event == "ADDON_LOADED" and addonName == "CanIMogIt" then
        CanIMogIt.frame.Loaded()
    end
end
CanIMogIt.frame:AddEventFunction(CanIMogIt.frame.AddonLoaded)


local changesSavedStack = {}


local function changesSavedText()
    local frame = CreateFrame("Frame", "CanIMogIt_ChangesSaved", CanIMogIt.frame)
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetText(CanIMogIt.YELLOW .. L["Changes saved!"])

    text:SetAllPoints()

    frame:SetPoint("BOTTOMRIGHT", -20, 10)
    frame:SetSize(100, 20)
    frame:SetShown(false)
    CanIMogIt.frame.changesSavedText = frame
end


local function hideChangesSaved()
    table.remove(changesSavedStack, #changesSavedStack)
    if #changesSavedStack == 0 then
        CanIMogIt.frame.changesSavedText:SetShown(false)
    end
end


local function showChangesSaved()
    CanIMogIt.frame.changesSavedText:SetShown(true)
    table.insert(changesSavedStack, #changesSavedStack + 1)
    C_Timer.After(5, function () hideChangesSaved() end)
end


local function checkboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    showChangesSaved()
    -- Reset the cache when an option changes.
    CanIMogIt:ResetCache()

    CanIMogIt:SendMessage("OptionUpdate")
end


local function debugCheckboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    showChangesSaved()
    CanIMogIt:SendMessage("OptionUpdate")
end


local function newCheckbox(parent, variableName, onClickFunction)
    -- Creates a new checkbox in the parent frame for the given variable name
    onClickFunction = onClickFunction or checkboxOnClick
    local displayData = CanIMogItOptions_DisplayData[variableName]
    local checkbox = CreateFrame("CheckButton", "CanIMogItCheckbox" .. variableName,
            parent, "InterfaceOptionsCheckButtonTemplate")

    -- checkbox.value = CanIMogItOptions[variableName]

    checkbox.GetValue = function (self)
        return CanIMogItOptions[variableName]
    end
    checkbox.SetValue = function (self, value) CanIMogItOptions[variableName] = value end

    checkbox:SetScript("OnClick", onClickFunction)
    checkbox:SetChecked(checkbox:GetValue())

    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(displayData["displayName"])

    checkbox.tooltipText = displayData["displayName"]
    checkbox.tooltipRequirement = displayData["description"]
    return checkbox
end


local function newRadioGrid(parent, variableName)
    local displayData = CanIMogItOptions_DisplayData[variableName]
    local frameName = "CanIMogItCheckGridFrame" .. variableName
    local frame = CreateFrame("Frame", frameName, parent)

    frame.texture = CreateFrame("Frame", frameName .. "_Texture", frame)
    frame.texture:SetSize(58, 58)
    local texture = frame.texture:CreateTexture("CIMITextureFrame", "BACKGROUND")
    texture:SetTexture("Interface/ICONS/INV_Sword_1H_AllianceToy_A_01.blp")
    texture:SetAllPoints()
    texture:SetVertexColor(0.5, 0.5, 0.5)

    local reloadButton = CreateFrame("Button", frameName .. "_ReloadButton",
            frame, "UIPanelButtonTemplate")
    reloadButton:SetText(L["Reload to apply"])
    reloadButton:SetSize(120, 25)
    reloadButton:SetEnabled(false)
    reloadButton:SetScript("OnClick", function () ReloadUI() end)

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    title:SetText(L["Icon Location"])

    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text:SetText(L["Does not affect Quests or Adventure Journal."])

    local text2 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text2:SetText(L["Default"] .. ": " .. L["Top Right"])

    local radioTopLeft = CreateFrame("CheckButton", frameName .. "_TopLeft",
            frame, "UIRadioButtonTemplate")
    local radioTop = CreateFrame("CheckButton", frameName .. "_Top",
            frame, "UIRadioButtonTemplate")
    local radioTopRight = CreateFrame("CheckButton", frameName .. "_TopRight",
            frame, "UIRadioButtonTemplate")
    local radioLeft = CreateFrame("CheckButton", frameName .. "_Left",
            frame, "UIRadioButtonTemplate")
    local radioCenter = CreateFrame("CheckButton", frameName .. "_Center",
            frame, "UIRadioButtonTemplate")
    local radioRight = CreateFrame("CheckButton", frameName .. "_Right",
            frame, "UIRadioButtonTemplate")
    local radioBottomLeft = CreateFrame("CheckButton", frameName .. "_BottomLeft",
            frame, "UIRadioButtonTemplate")
    local radioBottom = CreateFrame("CheckButton", frameName .. "_Bottom",
            frame, "UIRadioButtonTemplate")
    local radioBottomRight = CreateFrame("CheckButton", frameName .. "_BottomRight",
            frame, "UIRadioButtonTemplate")

    radioTopLeft:SetChecked(CanIMogItOptions[variableName] == "TOPLEFT")
    radioTop:SetChecked(CanIMogItOptions[variableName] == "TOP")
    radioTopRight:SetChecked(CanIMogItOptions[variableName] == "TOPRIGHT")
    radioLeft:SetChecked(CanIMogItOptions[variableName] == "LEFT")
    radioCenter:SetChecked(CanIMogItOptions[variableName] == "CENTER")
    radioRight:SetChecked(CanIMogItOptions[variableName] == "RIGHT")
    radioBottomLeft:SetChecked(CanIMogItOptions[variableName] == "BOTTOMLEFT")
    radioBottom:SetChecked(CanIMogItOptions[variableName] == "BOTTOM")
    radioBottomRight:SetChecked(CanIMogItOptions[variableName] == "BOTTOMRIGHT")

    local allRadios = {
        radioTopLeft,
        radioTop,
        radioTopRight,
        radioLeft,
        radioCenter,
        radioRight,
        radioBottomLeft,
        radioBottom,
        radioBottomRight
    }

    local function createOnRadioClicked (location)
        local function onRadioClicked (self, a, b, c)
            local checked = self:GetChecked()
            PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            CanIMogItOptions[variableName] = location

            local anyChecked = false
            for _, radio in ipairs(allRadios) do
                if radio ~= self then
                    anyChecked = radio:GetChecked() or anyChecked
                    radio:SetChecked(false)
                end
            end
            if not anyChecked then
                self:SetChecked(true)
            end
            reloadButton:SetEnabled(true)
            showChangesSaved()
        end
        return onRadioClicked
    end

    radioTopLeft:SetScript("OnClick", createOnRadioClicked("TOPLEFT"))
    radioTop:SetScript("OnClick", createOnRadioClicked("TOP"))
    radioTopRight:SetScript("OnClick", createOnRadioClicked("TOPRIGHT"))
    radioLeft:SetScript("OnClick", createOnRadioClicked("LEFT"))
    radioCenter:SetScript("OnClick", createOnRadioClicked("CENTER"))
    radioRight:SetScript("OnClick", createOnRadioClicked("RIGHT"))
    radioBottomLeft:SetScript("OnClick", createOnRadioClicked("BOTTOMLEFT"))
    radioBottom:SetScript("OnClick", createOnRadioClicked("BOTTOM"))
    radioBottomRight:SetScript("OnClick", createOnRadioClicked("BOTTOMRIGHT"))

    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -5)

    radioTopLeft:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    radioTop:SetPoint("TOPLEFT", radioTopLeft, "TOPRIGHT", 5, 0)
    radioTopRight:SetPoint("TOPLEFT", radioTop, "TOPRIGHT", 5, 0)
    radioLeft:SetPoint("TOPLEFT", radioTopLeft, "BOTTOMLEFT", 0, -5)
    radioCenter:SetPoint("TOPLEFT", radioLeft, "TOPRIGHT", 5, 0)
    radioRight:SetPoint("TOPLEFT", radioCenter, "TOPRIGHT", 5, 0)
    radioBottomLeft:SetPoint("TOPLEFT", radioLeft, "BOTTOMLEFT", 0, -5)
    radioBottom:SetPoint("TOPLEFT", radioBottomLeft, "TOPRIGHT", 5, 0)
    radioBottomRight:SetPoint("TOPLEFT", radioBottom, "TOPRIGHT", 5, 0)

    text:SetPoint("TOPLEFT", radioTopRight, "TOPRIGHT", 14, -3)
    text2:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -3)

    reloadButton:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 4, -8)

    frame.texture:SetPoint("TOPLEFT", radioTopLeft, "TOPLEFT")

    frame:SetSize(600, 80)

    -- Use this to show the bottom of the frame.
    -- local sample = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    -- sample:SetText("example.")
    -- sample:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")

    return frame
end


local function createOptionsMenu()
    -- define the checkboxes
    CanIMogIt.frame.debug =  newCheckbox(CanIMogIt.frame, "debug", debugCheckboxOnClick)
    CanIMogIt.frame.showEquippableOnly = newCheckbox(CanIMogIt.frame, "showEquippableOnly")
    CanIMogIt.frame.showTransmoggableOnly = newCheckbox(CanIMogIt.frame, "showTransmoggableOnly")
    CanIMogIt.frame.showUnknownOnly = newCheckbox(CanIMogIt.frame, "showUnknownOnly")
    CanIMogIt.frame.showSetInfo = newCheckbox(CanIMogIt.frame, "showSetInfo")
    CanIMogIt.frame.showItemIconOverlay = newCheckbox(CanIMogIt.frame, "showItemIconOverlay")
    -- CanIMogIt.frame.showBoEColors = newCheckbox(CanIMogIt.frame, "showBoEColors")
    CanIMogIt.frame.showVerboseText = newCheckbox(CanIMogIt.frame, "showVerboseText")
    CanIMogIt.frame.showSourceLocationTooltip = newCheckbox(CanIMogIt.frame, "showSourceLocationTooltip")
    CanIMogIt.frame.printDatabaseScan = newCheckbox(CanIMogIt.frame, "printDatabaseScan")
    CanIMogIt.frame.iconLocation = newRadioGrid(CanIMogIt.frame, "iconLocation")

    -- position the checkboxes
    CanIMogIt.frame.debug:SetPoint("TOPLEFT", 16, -16)
    CanIMogIt.frame.showEquippableOnly:SetPoint("TOPLEFT", CanIMogIt.frame.debug, "BOTTOMLEFT")
    CanIMogIt.frame.showTransmoggableOnly:SetPoint("TOPLEFT", CanIMogIt.frame.showEquippableOnly, "BOTTOMLEFT")
    CanIMogIt.frame.showUnknownOnly:SetPoint("TOPLEFT", CanIMogIt.frame.showTransmoggableOnly, "BOTTOMLEFT")
    CanIMogIt.frame.showSetInfo:SetPoint("TOPLEFT", CanIMogIt.frame.showUnknownOnly, "BOTTOMLEFT")
    CanIMogIt.frame.showItemIconOverlay:SetPoint("TOPLEFT", CanIMogIt.frame.showSetInfo, "BOTTOMLEFT")
    -- CanIMogIt.frame.showBoEColors:SetPoint("TOPLEFT", CanIMogIt.frame.showItemIconOverlay, "BOTTOMLEFT")
    CanIMogIt.frame.showVerboseText:SetPoint("TOPLEFT", CanIMogIt.frame.showItemIconOverlay, "BOTTOMLEFT")
    CanIMogIt.frame.showSourceLocationTooltip:SetPoint("TOPLEFT", CanIMogIt.frame.showVerboseText, "BOTTOMLEFT")
    CanIMogIt.frame.printDatabaseScan:SetPoint("TOPLEFT", CanIMogIt.frame.showSourceLocationTooltip, "BOTTOMLEFT")
    CanIMogIt.frame.iconLocation:SetPoint("TOPLEFT", CanIMogIt.frame.printDatabaseScan, "BOTTOMLEFT")

    changesSavedText()
end


function CanIMogIt.frame.Loaded()
    -- Set the Options from defaults.
    if (not CanIMogItOptions) then
        CanIMogItOptions = CanIMogItOptions_Defaults.options
        --print(L["CanIMogItOptions not found, loading defaults!"])
    end
    -- Set missing options from the defaults if the version is out of date.
    if (CanIMogItOptions["version"] < CanIMogIt_OptionsVersion) then
        local CanIMogItOptions_temp = CanIMogItOptions_Defaults.options;
        for k,v in pairs(CanIMogItOptions) do
            if (CanIMogItOptions_Defaults.options[k]) then
                CanIMogItOptions_temp[k] = v;
            end
        end
        CanIMogItOptions_temp["version"] = CanIMogIt_OptionsVersion;
        CanIMogItOptions = CanIMogItOptions_temp;
    end
    createOptionsMenu()
end

CanIMogIt:RegisterChatCommand("cimi", "SlashCommands")
CanIMogIt:RegisterChatCommand("canimogit", "SlashCommands")

function CanIMogIt:SlashCommands(input)
    -- Slash command router.
    if input == "" then
        self:OpenOptionsMenu()
    elseif input == 'debug' then
        CanIMogIt.frame.debug:Click()
    elseif input == 'overlay' then
        CanIMogIt.frame.showItemIconOverlay:Click()
    -- elseif input == 'colors' then
    --     CanIMogIt.frame.showBoEColors:Click()
    elseif input == 'verbose' then
        CanIMogIt.frame.showVerboseText:Click()
    elseif input == 'equiponly' then
        CanIMogIt.frame.showEquippableOnly:Click()
    elseif input == 'transmogonly' then
        CanIMogIt.frame.showTransmoggableOnly:Click()
    elseif input == 'unknownonly' then
        CanIMogIt.frame.showUnknownOnly:Click()
    elseif input == 'count' then
        self:Print(CanIMogIt.Utils.tablelength(CanIMogIt.db.global.appearances))
    elseif input == 'test' then
        CanIMogIt.Tests:RunTests()
    elseif input == 'PleaseDeleteMyDB' then
        self:DBReset()
    elseif input == 'dbprint' then
        CanIMogItOptions['databaseDebug'] = not CanIMogItOptions['databaseDebug']
        self:Print("Database prints: " .. tostring(CanIMogItOptions['databaseDebug']))
    elseif input == 'refresh' then
        self:ResetCache()
    else
        self:Print("Unknown command!")
    end
end

function CanIMogIt:OpenOptionsMenu()
    -- Run it twice, because the first one only opens
    -- the main interface window.
    InterfaceOptionsFrame_OpenToCategory(CanIMogIt.frame)
    InterfaceOptionsFrame_OpenToCategory(CanIMogIt.frame)
end
