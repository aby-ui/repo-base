--- LibChangelog
-- Provides an way to create a simple ingame frame to show a changelog



local _, Data = ...
local L = Data.L


local MAJOR, MINOR = "LibChangelog", 0
local LibChangelog = LibStub:NewLibrary(MAJOR, MINOR)

if not LibChangelog then return end


-- Lua APIs
local pcall, error, type, pairs = pcall, error, type, pairs




local NEW_MESSAGE_FONTS = {
    version = GameFontNormalHuge,
    title = GameFontNormal,
    text = GameFontHighlight
}

local VIEWED_MESSAGE_FONTS = {
    version = GameFontDisableHuge,
    title = GameFontDisable,
    text = GameFontDisable
}

function LibChangelog:Register(addonName, changelogTable, savedVariablesTable, lastReadVersionKey, onlyShowWhenNewVersionKey, texts)

    if self[addonName] then return error("LibChangelog: '"..addonName.."' already registered", 2) end


    self[addonName] = {
        changelogTable = changelogTable,
        savedVariablesTable = savedVariablesTable,
        lastReadVersionKey = lastReadVersionKey,
        onlyShowWhenNewVersionKey = onlyShowWhenNewVersionKey,
        texts = texts or {}
    }
end

function LibChangelog:CreateString(frame, text, font, offset)
    local entry = frame.scrollChild:CreateFontString(nil, "ARTWORK")
  
    if offset == nil then
      offset = -5
    end
  

    --print("ScrollChild width", frame.scrollChild:GetWidth())
    --print("scrollBar width", frame.scrollBar:GetWidth())
    -- frame.scrollBar:GetWidth() == frame.scrollChild:GetWidth()

    entry:SetFontObject(font or "GameFontNormal")
    entry:SetText(text)
    entry:SetJustifyH("LEFT")
    entry:SetWidth(frame.scrollBar:GetWidth())
  
    if frame.previous then
      entry:SetPoint("TOPLEFT", frame.previous, "BOTTOMLEFT", 0, offset)
    else
      entry:SetPoint("TOPLEFT", frame.scrollChild, "TOPLEFT", -5)
    end
  
    frame.previous = entry

    return entry
end

-- Did this just to get nice alignment on the bulleted entries (otherwise the text wrapped below the bulle

function LibChangelog:CreateBulletedListEntry(frame, text, font, offset)
    local bullet = self:CreateString(frame, "- ", font, offset)

    local bulletWidth = 16

    bullet:SetWidth(bulletWidth)
    bullet:SetJustifyV("TOP")
  
    local entry = self:CreateString(frame, text, font, offset)
    entry:SetPoint("TOPLEFT", bullet, "TOPRIGHT")
    entry:SetWidth(frame.scrollBar:GetWidth() - bulletWidth)
  
    bullet:SetHeight(entry:GetStringHeight())
  
    frame.previous = bullet
    return bullet
end

function LibChangelog:ShowChangelog(addonName)
    local fonts = NEW_MESSAGE_FONTS
  
    local addonData = self[addonName]

    if not addonData then return error("LibChangelog: '"..addonName.. "' was not registered. Please use :Register() first", 2) end

    local firstEntry = addonData.changelogTable[1]  --firstEntry contains the newest Version

    local addonSavedVariablesTable = addonData.savedVariablesTable

    if addonData.lastReadVersionKey and addonSavedVariablesTable[addonData.lastReadVersionKey] and firstEntry.Version <= addonSavedVariablesTable[addonData.lastReadVersionKey] and  addonSavedVariablesTable[addonData.onlyShowWhenNewVersionKey] then return end

  
    if not addonData.frame then

        local frame = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")
        ButtonFrameTemplate_HidePortrait(frame)
        if frame.SetTitle then
            frame:SetTitle(addonData.texts.title or addonName.." News")
        else
            --workaround for TBCC
            frame.TitleText:SetText(addonData.texts.title or addonName.." News")
        end
        frame.Inset:SetPoint("TOPLEFT", 4, -25)
        
        -- frame:EnableMouse(true)
        
        frame:SetSize(500, 500)
        frame:SetPoint("CENTER")
        -- frame:SetMovable(true)
        -- frame:RegisterForDrag("LeftButton")
        -- frame:SetScript("OnDragStart", frame.StartMoving)
        -- frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        
        frame.scrollBar = CreateFrame("ScrollFrame", nil, frame.Inset, "UIPanelScrollFrameTemplate")
        frame.scrollBar:SetPoint("TOPLEFT", 10, -6)
        frame.scrollBar:SetPoint("BOTTOMRIGHT", -27, 6)
        
        frame.scrollChild = CreateFrame("Frame")
        frame.scrollChild:SetSize(1, 1) -- it doesnt seem to matter how big it is, the only thing that not works is setting the height to really high number, then you can scroll forever
        
        frame.scrollBar:SetScrollChild(frame.scrollChild)

        frame.CheckButton = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
        frame.CheckButton:SetChecked(addonSavedVariablesTable[addonData.onlyShowWhenNewVersionKey])
        frame.CheckButton:SetFrameStrata("HIGH")
        frame.CheckButton:SetSize(20, 20)
        frame.CheckButton:SetScript("OnClick", function(self)
            local isChecked = self:GetChecked()
            addonSavedVariablesTable[addonData.onlyShowWhenNewVersionKey] = isChecked
            frame.CheckButton:SetChecked(isChecked)
        end)
        frame.CheckButton:SetPoint("LEFT", frame, "BOTTOMLEFT", 10, 13)
        frame.CheckButton.text:SetText(addonData.texts.onlyShowWhenNewVersion or "Only Show after next update")

        addonData.frame = frame
    end


    for i = 1, #addonData.changelogTable do
        local versionEntry = addonData.changelogTable[i]

        if addonData.lastReadVersionKey and addonSavedVariablesTable[addonData.lastReadVersionKey] and addonSavedVariablesTable[addonData.lastReadVersionKey] >= versionEntry.Version then
            fonts = VIEWED_MESSAGE_FONTS
        end

        -- Add version string
        self:CreateString(addonData.frame, versionEntry.Version, fonts.version, -30) --add a nice spacing between the version header and the previous text

        if versionEntry.General then
            self:CreateString(addonData.frame, versionEntry.General, fonts.text)
        end

        if versionEntry.Sections then
            for i = 1, #versionEntry.Sections do
                local section = versionEntry.Sections[i]
                self:CreateString(addonData.frame, section.Header, fonts.title, -8)
                local entries = section.Entries
                for j = 1, #entries do
                    self:CreateBulletedListEntry(addonData.frame, entries[j], fonts.text)
                end
            end
        end
    end

    addonSavedVariablesTable[addonData.lastReadVersionKey] = firstEntry.Version
end