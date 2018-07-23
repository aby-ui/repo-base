-- ----------------------------------------------------------------------------
-- Localized globals.
-- ----------------------------------------------------------------------------
-- Lua Functions
local pairs = _G.pairs

-- Lua Libraries
local table = _G.table

-- WoW UI
local C_PetJournal = _G.C_PetJournal
local C_ToyBox = _G.C_ToyBox
local GameTooltip = _G.GameTooltip

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data
local EventMessage = private.EventMessage

local LibStub = _G.LibStub
local LibQTip = LibStub("LibQTip-1.0")
local NPCScan = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)

local FormatAtlasTexture = private.FormatAtlasTexture

-- ----------------------------------------------------------------------------
-- Constants
-- ----------------------------------------------------------------------------
local DataObjectProperties = {
	icon = [[Interface\LFGFRAME\BattlenetWorking0]],
	label = _G.OBJECTIVES_LABEL,
	scannerData = {
		NPCCount = 0,
		NPCs = {},
	},
    text = _G.NONE,
    type = "data source"
}

local DataObject = LibStub("LibDataBroker-1.1"):NewDataObject(AddOnFolderName, DataObjectProperties)

local npcAchievementNames = {}
local npcDisplayNames = {}
local npcIDs = {}
local npcNames = {}

local TitleFont = _G.CreateFont("NPCScanTitleFont")
TitleFont:SetTextColor(1, 0.82, 0)
TitleFont:SetFontObject("QuestTitleFont")

local Tooltip

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------
local function SortByNPCNameThenByID(a, b)
    local nameA = npcNames[a]
    local nameB = npcNames[b]

    if nameA == nameB then
        return a < b
    end

    return nameA < nameB
end

local function SortByNPCAchievementNameThenByNameThenByID(a, b)
    local achievementNameA = npcAchievementNames[a]
    local achievementNameB = npcAchievementNames[b]

    if achievementNameA == achievementNameB then
        return SortByNPCNameThenByID(a, b)
    end

    if not achievementNameA then
        return false
    end

    if not achievementNameB then
        return true
    end

    return achievementNameA < achievementNameB
end

-- ----------------------------------------------------------------------------
-- Tooltip achievement headers.
-- ----------------------------------------------------------------------------
local achievementProvider, achievementPrototype, baseCellPrototype = LibQTip:CreateCellProvider(LibQTip.LabelProvider)

function achievementPrototype:getContentHeight()
    return 16
end

function achievementPrototype:InitializeCell()
    baseCellPrototype.InitializeCell(self)

    if not self.atlas then
        local background = self:CreateTexture(nil, "TOOLTIP")
        background:SetBlendMode("ADD")
        background:SetAtlas("Objective-Header", true)
        background:SetPoint("CENTER", 0, -17)

        self.atlas = background
    end

    self.r, self.g, self.b = 1, 0.82, 0
    self.fontString:SetTextColor(self.r, self.g, self.b, 1)
end

function achievementPrototype:ReleaseCell()
    self.r, self.g, self.b = 1, 1, 1
end

function achievementPrototype:SetupCell(tooltip, value, justification, font, r, g, b)
    local width, height = baseCellPrototype.SetupCell(self, tooltip, value, justification, font, r, g, b)

    self.r, self.g, self.b = 1, 0.82, 0

    return width, height
end

local function OpenToAchievement(_, achievementID)
    if not _G.AchievementFrame or not _G.AchievementFrame:IsShown() then
        _G.ToggleAchievementFrame()
    end

    _G.AchievementFrameBaseTab_OnClick(1)
    _G.AchievementFrame_SelectAchievement(achievementID)

    local categoryID = _G.GetAchievementCategory(achievementID)
    local _, parentCategoryID = _G.GetCategoryInfo(categoryID)

    if parentCategoryID == -1 then
        for _, entry in pairs(_G.ACHIEVEMENTUI_CATEGORIES) do
            if entry.id == categoryID then
                entry.collapsed = false
            elseif entry.parent == categoryID then
                entry.hidden = false
            end
        end

        _G.AchievementFrameCategories_Update()
    end
end

local function ShowAchievementTooltip(tooltipCell, achievementID)
    Tooltip:SetFrameStrata("DIALOG")
    _G.GameTooltip_SetDefaultAnchor(GameTooltip, tooltipCell)

    GameTooltip:SetText(Data.Achievements[achievementID].description, 1, 1, 1, 1, true)
    GameTooltip:Show()
end

local function HideAchievementTooltip()
    Tooltip:SetFrameStrata("TOOLTIP")
    GameTooltip:Hide()
end

-- ----------------------------------------------------------------------------
-- NPC tidbit helpers
-- ----------------------------------------------------------------------------
local entryFromID = {}

local function Tooltip_OnRelease()
    Tooltip = nil
end

local DataTooltip

local function DataTooltip_OnRelease()
    DataTooltip = nil

    if Tooltip then
        Tooltip:SetFrameStrata("TOOLTIP")
    end
end

local function AddEntryDataIDs(list, fieldName)
    table.wipe(entryFromID)

    for index = 1, #list do
        entryFromID[list[index][fieldName]] = list[index]
    end
end

local function AddEntryToDataTooltip(iconPath, entryName, isCollected)
    local line = DataTooltip:AddLine(("|T%s:0:0|t %s"):format(iconPath, entryName))

    if isCollected then
        DataTooltip:SetCell(line, 2, ("%s%s"):format(_G.GREEN_FONT_COLOR_CODE, _G.COLLECTED))
    else
        DataTooltip:SetCell(line, 2, ("%s%s"):format(_G.RED_FONT_COLOR_CODE, _G.NOT_COLLECTED))
    end
end

local function CleanupDataTooltip()
    if DataTooltip then
        DataTooltip:Hide()
        DataTooltip:Release()
    end

    if Tooltip then
        Tooltip:SetFrameStrata("TOOLTIP")
    end
end

local function InitializeDataTooltip(tooltipCell)
    if not DataTooltip then
        DataTooltip = LibQTip:Acquire(AddOnFolderName .. "DataTooltip", 2)
        DataTooltip:SetAutoHideDelay(0.1, tooltipCell, DataTooltip_OnRelease)
        DataTooltip:SmartAnchorTo(tooltipCell)
        DataTooltip:SetBackdropColor(0.05, 0.05, 0.05, 1)
        DataTooltip:SetCellMarginH(0)
    end

    Tooltip:SetFrameStrata("DIALOG")
    DataTooltip:Clear()

    return DataTooltip
end

local function DisplayMountInfo(tooltipCell, mountList)
    AddEntryDataIDs(mountList, "spellID")
    InitializeDataTooltip(tooltipCell)

    local mountIDs = _G.C_MountJournal.GetMountIDs()

    for index = 1, #mountIDs do
        local creatureName, spellID, iconPath, _, _, _, _, _, _, hideOnChar, isCollected = _G.C_MountJournal.GetMountInfoByID(mountIDs[index])

        if creatureName and not hideOnChar and entryFromID[spellID] then
            AddEntryToDataTooltip(iconPath, creatureName, isCollected)
        end
    end

    DataTooltip:UpdateScrolling()
    DataTooltip:Show()
end

local function DisplayPetInfo(tooltipCell, petList)
    AddEntryDataIDs(petList, "npcID")
	InitializeDataTooltip(tooltipCell)

    C_PetJournal.SetFilterChecked(_G.LE_PET_JOURNAL_FILTER_COLLECTED, true)
    C_PetJournal.SetFilterChecked(_G.LE_PET_JOURNAL_FILTER_FAVORITES, false)
    C_PetJournal.SetFilterChecked(_G.LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_PetJournal.SetAllPetTypesChecked(true)
    C_PetJournal.SetAllPetSourcesChecked(true)
    C_PetJournal.ClearSearchFilter()

	if _G.PetJournalSearchBox then
		_G.PetJournalSearchBox:SetText("");
	end

    local numPets = C_PetJournal.GetNumPets()

    for index = 1, numPets do
        local _, _, isCollected, _, _, _, _, petName, iconPath, _, npcID = C_PetJournal.GetPetInfoByIndex(index)

        if petName and entryFromID[npcID] then
			AddEntryToDataTooltip(iconPath, petName, isCollected)
			entryFromID[npcID] = nil -- Prevent multiples if already collected.
        end
    end

    DataTooltip:UpdateScrolling()
    DataTooltip:Show()
end

local function DisplayToyInfo(tooltipCell, toyList)
    AddEntryDataIDs(toyList, "itemID")
    InitializeDataTooltip(tooltipCell)

	C_ToyBox.SetAllSourceTypeFilters(true)
	C_ToyBox.SetCollectedShown(true)
	C_ToyBox.SetFilterString("")

	if _G.ToyBox then
		_G.ToyBox.searchBox:SetText("");
	end

	local numToys = C_ToyBox.GetNumToys()

    for index = 1, numToys do
        local toyID = C_ToyBox.GetToyFromIndex(index)
        local itemID, toyName, iconPath = C_ToyBox.GetToyInfo(toyID)

		if toyName and entryFromID[itemID] then
            AddEntryToDataTooltip(iconPath, toyName, _G.PlayerHasToy(itemID))
        end
    end

    DataTooltip:UpdateScrolling()
    DataTooltip:Show()
end
-- ----------------------------------------------------------------------------
-- DataBroker Tooltip helpers.
-- ----------------------------------------------------------------------------
local numTooltipColumns

local mountsColumn
local petsColumn
local tameableColumn
local toysColumn

local function GetTooltipData()
    numTooltipColumns = 1

    mountsColumn = nil
    petsColumn = nil
    tameableColumn = nil
    toysColumn = nil

    table.wipe(npcAchievementNames)
    table.wipe(npcDisplayNames)
    table.wipe(npcIDs)
    table.wipe(npcNames)

	local hasMounts = false
	local hasPets = false
	local hasToys = false
	local hasTameable = false

	for npcID in pairs(DataObject.scannerData.NPCs) do
        local npc = Data.NPCs[npcID]

        -- The npcID may belong to a custom NPC, which will not have further information.
        if npc then
            npcAchievementNames[npcID] = npc.achievementID and Data.Achievements[npc.achievementID].name or nil
            npcDisplayNames[npcID] = private.GetNPCOptionsName(npcID)
            npcIDs[#npcIDs + 1] = npcID
            npcNames[npcID] = NPCScan:GetNPCNameFromID(npcID)

			if not hasTameable and npc.isTameable then
				hasTameable = true
            end

			if not hasMounts and npc.mounts then
				hasMounts = true
            end

			if not hasPets and npc.pets then
				hasPets = true
            end

			if not hasToys and npc.toys then
				hasToys = true
            end
        end
    end

	if hasMounts then
		numTooltipColumns = numTooltipColumns + 1
		mountsColumn = numTooltipColumns
	end

	if hasPets then
		numTooltipColumns = numTooltipColumns + 1
		petsColumn = numTooltipColumns
	end

	if hasToys then
		numTooltipColumns = numTooltipColumns + 1
		toysColumn = numTooltipColumns
	end

	if hasTameable then
		numTooltipColumns = numTooltipColumns + 1
		tameableColumn = numTooltipColumns
	end

	table.sort(npcIDs, SortByNPCAchievementNameThenByNameThenByID)
end

-- ----------------------------------------------------------------------------
-- DataBroker Tooltip.
-- ----------------------------------------------------------------------------
local ICON_MOUNT = FormatAtlasTexture("StableMaster")
local ICON_PET = FormatAtlasTexture("WildBattlePetCapturable")

local ICON_TAMEABLE
do
    local textureFormat = [[|TInterface\TargetingFrame\UI-CLASSES-CIRCLES:0:0:0:0:256:256:%d:%d:%d:%d|t]]
    local textureSize = 256
    local left, right, top, bottom = _G.unpack(_G.CLASS_ICON_TCOORDS["HUNTER"])

    ICON_TAMEABLE = textureFormat:format(left * textureSize, right * textureSize, top * textureSize, bottom * textureSize)
end

local ICON_TOY = [[|TInterface\Worldmap\TreasureChest_64:0:0|t]]

local function DrawTooltip(anchorFrame)
    if not anchorFrame then
        return
    end

    GetTooltipData()

    if not Tooltip then
        Tooltip = LibQTip:Acquire(AddOnFolderName, numTooltipColumns)
        Tooltip:SetAutoHideDelay(0.25, anchorFrame)
        Tooltip:SmartAnchorTo(anchorFrame)
        Tooltip:SetBackdropColor(0.05, 0.05, 0.05, 1)
        Tooltip:SetCellMarginH(0)
        Tooltip:SetCellMarginV(1)

        Tooltip.OnRelease = Tooltip_OnRelease
    end

    Tooltip:Clear()

    Tooltip:SetCell(Tooltip:AddLine(), 1, AddOnFolderName, TitleFont, "CENTER", 0)
    Tooltip:AddSeparator(1, 0, 0, 0)

    if DataObject.scannerData.NPCCount == 0 then
        Tooltip:AddSeparator(1, 0, 0, 0)
        Tooltip:AddSeparator(1, 1, 0.82, 0)
        Tooltip:SetCell(Tooltip:AddLine(), 1, _G.ERR_GENERIC_NO_VALID_TARGETS, "CENTER", 0)

        return
    end

    local currentAchievementID

    for index = 1, #npcIDs do
        local npcID = npcIDs[index]
        local npc = Data.NPCs[npcID]

        if npc.achievementID then
            if npc.achievementID ~= currentAchievementID then
                currentAchievementID = npc.achievementID

                Tooltip:AddSeparator(1, 0, 0, 0)
                Tooltip:AddSeparator(1, 1, 0.82, 0)

                local achievementData = Data.Achievements[npc.achievementID]
                local achievementLine = Tooltip:AddLine()

                Tooltip:SetCell(achievementLine, 1, ("|T%s:0|t %s"):format(achievementData.iconTexturePath, achievementData.name), "CENTER", 0, achievementProvider)
                Tooltip:SetLineScript(achievementLine, "OnMouseUp", OpenToAchievement, npc.achievementID)
                Tooltip:SetLineScript(achievementLine, "OnEnter", ShowAchievementTooltip, npc.achievementID)
                Tooltip:SetLineScript(achievementLine, "OnLeave", HideAchievementTooltip)
                Tooltip:AddSeparator(1, 1, 0.82, 0)
            end
        elseif not currentAchievementID then
            -- No achievement section before this, and it's the first entry
            currentAchievementID = -1

            Tooltip:AddSeparator(1, 0, 0, 0)
            Tooltip:AddSeparator(1, 1, 0.82, 0)
        elseif currentAchievementID >= 0 then
            -- End of achievements.
            currentAchievementID = -1

            Tooltip:AddSeparator(1, 0, 0, 0)
            Tooltip:AddSeparator(1, 1, 0.82, 0)
            Tooltip:SetCell(Tooltip:AddLine(), 1, _G.MISCELLANEOUS, "CENTER", 0)
            Tooltip:AddSeparator(1, 1, 0.82, 0)
        end

        local line = Tooltip:AddLine()

        if line % 2 == 0 then
            Tooltip:SetLineColor(line, 0.20, 0.20, 0.20)
        end

        Tooltip:SetCell(line, 1, npcDisplayNames[npcID])

        if tameableColumn and npc.isTameable then
            Tooltip:SetCell(line, tameableColumn, ICON_TAMEABLE)
        end

        if mountsColumn and npc.mounts then
            Tooltip:SetCell(line, mountsColumn, ICON_MOUNT)
            Tooltip:SetCellScript(line, mountsColumn, "OnEnter", DisplayMountInfo, npc.mounts)
            Tooltip:SetCellScript(line, mountsColumn, "OnLeave", CleanupDataTooltip)
        end

        if petsColumn and npc.pets then
            Tooltip:SetCell(line, petsColumn, ICON_PET)
            Tooltip:SetCellScript(line, petsColumn, "OnEnter", DisplayPetInfo, npc.pets)
            Tooltip:SetCellScript(line, petsColumn, "OnLeave", CleanupDataTooltip)
        end

        if toysColumn and npc.toys then
            Tooltip:SetCell(line, toysColumn, ICON_TOY)
            Tooltip:SetCellScript(line, toysColumn, "OnEnter", DisplayToyInfo, npc.toys)
            Tooltip:SetCellScript(line, toysColumn, "OnLeave", CleanupDataTooltip)
        end
    end
end

-- ----------------------------------------------------------------------------
-- DataObject methods.
-- ----------------------------------------------------------------------------
function DataObject:OnClick()
    LibStub("AceConfigDialog-3.0"):Open(AddOnFolderName)
end

function DataObject:OnEnter()
    if not Tooltip or not Tooltip:IsShown() then
        DrawTooltip(self)
        Tooltip:UpdateScrolling()
        Tooltip:Show()
    end
end

function DataObject:OnLeave()
    -- Null operation: Some LDB displays get cranky if this method is missing.
end

function DataObject:Update(_, scannerData)
    self.text = scannerData.NPCCount > 0 and scannerData.NPCCount or _G.NONE
    self.scannerData = scannerData

    if Tooltip and Tooltip:IsShown() then
        DrawTooltip(self)
    end
end

LibStub("AceEvent-3.0"):Embed(DataObject)
DataObject:RegisterMessage(EventMessage.ScannerDataUpdated, "Update")
