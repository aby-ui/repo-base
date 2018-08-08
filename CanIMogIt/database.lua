--[[
    global = {
        "appearances" = {
            appearanceID:INVTYPE_HEAD = {
                "sources" = {
                    sourceID = {
                        "subClass" = "Mail",
                        "classRestrictions" = {"Mage", "Priest", "Warlock"}
                    }
                }
            }
        }
    }
]]

local L = CanIMogIt.L


CanIMogIt_DatabaseVersion = 1.2


local default = {
    global = {
        appearances = {},
        setItems = {}
    }
}


local function IsBadKey(key)
    -- Good key: 12345:SOME_TYPE

    -- If it's a number: 12345
    if type(key) == 'number' then
        -- Get the appearance hash for the source
        return true
    end

    -- If it has two :'s in it: 12345:SOME_TYPE:SOME_TYPE
    local _, count = string.gsub(key, ":", "")
    if count >= 2 then
        return true
    end
end


local function CheckBadDB()
    --[[
        Check if the database has been corrupted by a bad update or going
        back too many versions.
    ]]
    if CanIMogIt.db.global.appearances and CanIMogIt.db.global.databaseVersion then
        for key, _ in pairs(CanIMogIt.db.global.appearances) do
            if IsBadKey(key) then
                StaticPopupDialogs["CANIMOGIT_BAD_DATABASE"] = {
                    text = "Can I Mog It?" .. "\n\n" .. L["Sorry! Your database has corrupted entries. This will cause errors and give incorrect results. Please click below to reset the database."],
                    button1 = L["Okay"],
                    button2 = L["Ask me later"],
                    OnAccept = function () CanIMogIt:DBReset() end,
                    timeout = 0,
                    whileDead = true,
                    hideOnEscape = true,
                    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
                }
                --StaticPopup_Show("CANIMOGIT_BAD_DATABASE")
                CanIMogIt:DBReset()
                return
            end
        end
    end
end


local function UpdateTo1_1()
    local appearancesTable = CanIMogIt.Utils.copyTable(CanIMogIt.db.global.appearances)
    for appearanceID, appearance in pairs(appearancesTable) do
        local sources = appearance.sources
        for sourceID, source in pairs(sources) do
            -- Get the appearance hash for the source
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local hash = CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
            -- Add the source to the appearances with the new hash key
            if not CanIMogIt.db.global.appearances[hash] then
                CanIMogIt.db.global.appearances[hash] = {
                    ["sources"] = {},
                }
            end
            CanIMogIt.db.global.appearances[hash].sources[sourceID] = source
        end
        -- Remove the old one
        CanIMogIt.db.global.appearances[appearanceID] = nil
    end
end


local function UpdateTo1_2()
    for hash, sources in pairs(CanIMogIt.db.global.appearances) do
        for sourceID, source in pairs(sources["sources"]) do
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            if sourceID and appearanceID and itemLink then
                CanIMogIt:_DBSetItem(itemLink, appearanceID, sourceID)
            end
        end
    end
end


local versionMigrationFunctions = {
    [1.1] = UpdateTo1_1,
    [1.2] = UpdateTo1_2
}


local function UpdateToVersion(version)
    CanIMogIt:Print(L["Migrating Database version to:"], version)
    versionMigrationFunctions[version]()
    CanIMogIt.db.global.databaseVersion = version
    CanIMogIt:Print(L["Database migrated to:"], version)
end


local function UpdateDatabase()
    if not CanIMogIt.db.global.databaseVersion then
        CanIMogIt.db.global.databaseVersion = 1.0
    end
    if  CanIMogIt.db.global.databaseVersion < 1.1 then
        UpdateToVersion(1.1)
    end
    if CanIMogIt.db.global.databaseVersion < 1.2 then
        CanIMogIt.CreateMigrationPopup("CANIMOGIT_DB_MIGRATION_1_2", function () UpdateToVersion(1.2) end)
    end
end


local function UpdateDatabaseIfNeeded()
    CheckBadDB()
    if next(CanIMogIt.db.global.appearances) and
            (not CanIMogIt.db.global.databaseVersion
            or CanIMogIt.db.global.databaseVersion < CanIMogIt_DatabaseVersion) then
        UpdateDatabase()
    else
        -- There is no database, add the default.
        CanIMogIt.db.global.databaseVersion = CanIMogIt_DatabaseVersion
    end
end


function CanIMogIt:OnInitialize()
    if (not CanIMogItDatabase) then
        --163ui StaticPopup_Show("CANIMOGIT_NEW_DATABASE")
    end
    self.db = LibStub("AceDB-3.0"):New("CanIMogItDatabase", default)
end


function CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
    if not appearanceID or not itemLink then return end
    local slot = self:GetItemSlotName(itemLink)
    return appearanceID .. ":" .. slot
end

local function SourcePassesRequirement(source, requirementName, requirementValue)
    if source[requirementName] then
        if type(source[requirementName]) == "string" then
            -- single values, such as subClass = Plate
            if source[requirementName] ~= requirementValue then
                return false
            end
        elseif type(source[requirementName]) == "table" then
            -- multi-values, such as classRestrictions = Shaman, Hunter
            local found = false
            for index, sourceValue in pairs(source[requirementName]) do
                if sourceValue == requirementValue then
                    found = true
                end
            end
            if not found then
                return false
            end
        else
            return false
        end
    end
    return true
end


function CanIMogIt:DBHasAppearanceForRequirements(appearanceID, itemLink, requirements)
    --[[
        @param requirements: a table of {requirementName: value}, which will be
            iterated over for each known item to determine if all requirements are met.
            If the requirements are not met for any item, this will return false.
            For example, {"classRestrictions": "Druid"} would filter out any that don't
            include Druid as a class restriction. If the item doesn't have a restriction, it
            is assumed to not be a restriction at all.
    ]]
    if not self:DBHasAppearance(appearanceID, itemLink) then
        return false
    end
    for sourceID, source in pairs(self:DBGetSources(appearanceID, itemLink)) do
        for name, value in pairs(requirements) do
            if SourcePassesRequirement(source, name, value) then
                return true
            end
        end
    end
    return false
end


function CanIMogIt:DBHasAppearance(appearanceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    return self.db.global.appearances[hash] ~= nil
end


function CanIMogIt:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasAppearance(appearanceID, itemLink) then
        local hash = CanIMogIt:GetAppearanceHash(appearanceID, itemLink)
        self.db.global.appearances[hash] = {
            ["sources"] = {},
        }
    end
end


function CanIMogIt:DBRemoveAppearance(appearanceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    self.db.global.appearances[hash] = nil
end


function CanIMogIt:DBHasSource(appearanceID, sourceID, itemLink)
    if appearanceID == nil or sourceID == nil then return end
    if CanIMogIt:DBHasAppearance(appearanceID, itemLink) then
        local hash = self:GetAppearanceHash(appearanceID, itemLink)
        return self.db.global.appearances[hash].sources[sourceID] ~= nil
    end
    return false
end


function CanIMogIt:DBGetSources(appearanceID, itemLink)
    -- Returns the table of sources for the appearanceID.
    if self:DBHasAppearance(appearanceID, itemLink) then
        local hash = self:GetAppearanceHash(appearanceID, itemLink)
        return self.db.global.appearances[hash].sources
    end
end


CanIMogIt.itemsToAdd = {}

local function LateAddItems(event, itemID)
    if event == "GET_ITEM_INFO_RECEIVED" and itemID then
        -- The 8.0.1 update is causing this event to return a bunch of itemID=0
        if itemID <= 0 then
            return
        end
        if CanIMogIt.itemsToAdd[itemID] then
            for sourceID, _ in pairs(CanIMogIt.itemsToAdd[itemID]) do
                local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
                local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
                CanIMogIt:_DBSetItem(itemLink, appearanceID, sourceID)
            end
            table.remove(CanIMogIt.itemsToAdd, itemID)
        end
    end
end
CanIMogIt.frame:AddEventFunction(LateAddItems)


function CanIMogIt:_DBSetItem(itemLink, appearanceID, sourceID)
    -- Sets the item in the database, or at least schedules for it to be set
    -- when we get item info back.
    if GetItemInfo(itemLink) then
        local hash = self:GetAppearanceHash(appearanceID, itemLink)
        if self.db.global.appearances[hash] == nil then
            return
        end
        self.db.global.appearances[hash].sources[sourceID] = {
            ["subClass"] = self:GetItemSubClassName(itemLink),
            ["classRestrictions"] = self:GetItemClassRestrictions(itemLink),
        }
        if self:GetItemSubClassName(itemLink) == nil then
            CanIMogIt:Print("nil subclass: " .. itemLink)
        end
        if CanIMogItOptions['databaseDebug'] then
            CanIMogIt:Print("New item found: " .. itemLink .. " itemID: " .. CanIMogIt:GetItemID(itemLink) .. " sourceID: " .. sourceID .. " appearanceID: " .. appearanceID)
        end
    else
        local itemID = CanIMogIt:GetItemID(itemLink)
        if not CanIMogIt.itemsToAdd[itemID] then
            CanIMogIt.itemsToAdd[itemID] = {}
        end
        CanIMogIt.itemsToAdd[itemID][sourceID] = true
    end
end


function CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
    -- Adds the item to the database. Returns true if it added something, false otherwise.
    if appearanceID == nil or sourceID == nil then
        appearanceID, sourceID = self:GetAppearanceID(itemLink)
    end
    if appearanceID == nil or sourceID == nil then return end
    self:DBAddAppearance(appearanceID, itemLink)
    if not self:DBHasSource(appearanceID, sourceID, itemLink) then
        CanIMogIt:_DBSetItem(itemLink, appearanceID, sourceID)
        return true
    end
    return false
end


function CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink)
    local hash = self:GetAppearanceHash(appearanceID, itemLink)
    if self.db.global.appearances[hash] == nil then return end
    if self.db.global.appearances[hash].sources[sourceID] ~= nil then
        self.db.global.appearances[hash].sources[sourceID] = nil
        if next(self.db.global.appearances[hash].sources) == nil then
            self:DBRemoveAppearance(appearanceID, itemLink)
        end
        if CanIMogItOptions['databaseDebug'] then
            CanIMogIt:Print("Item removed: " .. CanIMogIt:GetItemLinkFromSourceID(sourceID) .. " itemID: " .. CanIMogIt:GetItemID(itemLink) .. " sourceID: " .. sourceID .. " appearanceID: " .. appearanceID)
        end
    end
end


function CanIMogIt:DBHasItem(itemLink)
    local appearanceID, sourceID = self:GetAppearanceID(itemLink)
    if appearanceID == nil or sourceID == nil then return end
    return self:DBHasSource(appearanceID, sourceID, itemLink)
end


function CanIMogIt:DBReset()
    CanIMogItDatabase = nil
    CanIMogIt.db = nil
    ReloadUI()
end


function CanIMogIt:SetsDBAddSetItem(set, sourceID)
    if CanIMogIt.db.global.setItems == nil then
        CanIMogIt.db.global.setItems = {}
    end

    CanIMogIt.db.global.setItems[sourceID] = set.setID
end

function CanIMogIt:SetsDBGetSetFromSourceID(sourceID)
    if CanIMogIt.db.global.setItems == nil then return end

    return CanIMogIt.db.global.setItems[sourceID]
end


local function GetAppearancesEvent(event, ...)
    if event == "PLAYER_LOGIN" then
        -- Make sure the database is updated to the latest version
        UpdateDatabaseIfNeeded()
        -- add all known appearanceID's to the database
        CanIMogIt:GetAppearances()
        CanIMogIt:GetSets()
    end
end
CanIMogIt.frame:AddEventFunction(GetAppearancesEvent)


local transmogEvents = {
    ["TRANSMOG_COLLECTION_SOURCE_ADDED"] = true,
    ["TRANSMOG_COLLECTION_SOURCE_REMOVED"] = true,
    ["TRANSMOG_COLLECTION_UPDATED"] = true,
}

local function TransmogCollectionUpdated(event, sourceID, ...)
    if transmogEvents[event] and sourceID then
        -- Get the appearanceID from the sourceID
        if event == "TRANSMOG_COLLECTION_SOURCE_ADDED" then
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
        elseif event == "TRANSMOG_COLLECTION_SOURCE_REMOVED" then
            local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
            local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
            CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink)
        end
        if sourceID then
            CanIMogIt.cache:RemoveItemBySourceID(sourceID)
        end
        CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
    end
end

CanIMogIt.frame:AddEventFunction(TransmogCollectionUpdated)


-- function CanIMogIt.frame:GetItemInfoReceived(event, ...)
--     if event ~= "GET_ITEM_INFO_RECEIVED" then return end
--     Database:GetItemInfoReceived()
-- end
