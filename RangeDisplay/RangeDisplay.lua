--[[
Name: RangeDisplay
Revision: $Revision: 392 $
Author(s): mitch0
Website: http://www.wowace.com/projects/range-display/
SVN: svn://svn.wowace.com/wow/range-display/mainline/trunk
Description: RangeDisplay displays the estimated range to the current target based on spell ranges and other measurable ranges
License: Public Domain
]]

local AppName, RangeDisplay = ...
local OptionsAppName = AppName .. "_Options"
local VERSION = AppName .. "-v4.9.1"
--[===[@debug@
local VERSION = AppName .. "-r" .. ("$Revision: 392 $"):match("%d+")
--@end-debug@]===]

local rc = LibStub("LibRangeCheck-2.0")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local LibDualSpec = LibStub("LibDualSpec-1.0", true)
local L = LibStub("AceLocale-3.0"):GetLocale(AppName)

-- internal vars

local uiScale = 1.0 -- just to be safe...
local _ -- throwaway
local mute = nil

-- cached stuff

local _G = _G
local IsClassic = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC)
local UnitExists = _G.UnitExists
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitCanAttack = _G.UnitCanAttack
local UnitCanAssist = _G.UnitCanAssist
local UnitIsUnit = _G.UnitIsUnit
local GetCursorPosition = _G.GetCursorPosition
local UIParent = _G.UIParent
local PlaySoundFile = _G.PlaySoundFile
local ipairs = _G.ipairs
local pairs = _G.pairs
local tinsert = _G.tinsert

-- hard-coded config stuff

local UpdateDelay = .1 -- update frequency == 1/UpdateDelay

local DefaultBGTexture = "Blizzard Tooltip"
local DefaultBGFile = [[Interface\Tooltips\UI-Tooltip-Background]]
local DefaultEdgeTexture = "Blizzard Tooltip"
local DefaultEdgeFile = [[Interface\Tooltips\UI-Tooltip-Border]]
local DefaultFontName = "Friz Quadrata TT"
local DefaultFontPath = GameFontNormal:GetFont()
local DefaultFrameWidth = 112
local DefaultFrameHeight = 36
local FakeCursorImage = [[Interface\CURSOR\Point]]
local Icon = [[Interface\Icons\INV_Misc_Spyglass_02]]

local Sections = {
    "crSection",
    "srSection",
    "mrSection",
    "lrSection",
    "defaultSection",
    "oorSection",
}

-- all sounds are slightly edited samples from freesound.org
local Sounds = {
    ["DoubleSwoosh"] = [[Interface\AddOns\]] .. AppName .. [[\sounds\19312.ogg]],
    ["Goblet F Medium"] = [[Interface\AddOns\]] .. AppName .. [[\sounds\30600.ogg]],
    ["SwordUnsheathed"] = [[Interface\AddOns\]] .. AppName .. [[\sounds\74833.ogg]],
}

local DefaultSoundNames = {
    ["crSection"] = "SwordUnsheathed",
    ["srSection"] = "DoubleSwoosh",
    ["mrSection"] = "DoubleSwoosh",
    ["lrSection"] = "DoubleSwoosh",
    ["defaultSection"] = "DoubleSwoosh",
    ["oorSection"] = "Goblet F Medium",
}

---------------------------------

RangeDisplay = LibStub("AceAddon-3.0"):NewAddon(RangeDisplay, AppName, "AceEvent-3.0")
_G.RangeDisplay = RangeDisplay

RangeDisplay:SetDefaultModuleState(false)

RangeDisplay.version = VERSION
RangeDisplay.AppName = AppName
RangeDisplay.Sections = Sections

-- Default DB stuff

local function makeColor(r, g, b, a)
    a = a or 1.0
    return { ["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a }
end

local Transparent = makeColor(0, 0, 0, 0)
local DefaultText = "%d - %d"

local defaults = {
    global = {
        enableArena = true,
    },
    profile = {
        locked = false,
        mute = false,
        minimap = {},
        units = {
            ["**"] = {
                enabled = true,
                point = "CENTER",
                relPoint = "CENTER",
                x = 0,
                y = -100,
                font = DefaultFontName,
                fontSize = 24,
                fontOutline = "",
                strata = "MEDIUM",
                enemyOnly = false,
                warnEnemyOnly = true,
                reverse = false,

                rangeLimit = 100,
                overLimitDisplay = false,
                overLimitText = "%d +",

                frameWidth = DefaultFrameWidth,
                frameHeight = DefaultFrameHeight,
                bgEnabled = false,
                bgTexture = DefaultBGTexture,
                bgBorderTexture = DefaultEdgeTexture,
                bgTile = false,
                bgTileSize = 32,
                bgEdgeSize = 16,
                bgColor = makeColor(0, 0, 0),
                bgBorderColor = makeColor(0.8, 0.6, 0.0),

                oorSection = {
                    enabled = true,
                    color = makeColor(0.9, 0.055, 0.075),
                    range = 40,
                    text = DefaultText,
                    warnSoundName = DefaultSoundNames["oorSection"],
                },
                defaultSection = {
                    enabled = true,
                    color = makeColor(1.0, 0.82, 0),
                    text = DefaultText,
                    warnSoundName = DefaultSoundNames["defaultSection"],
                },
                lrSection = {
                    enabled = false,
                    color = makeColor(1.0, 0.82, 0),
                    range = 35,
                    text = DefaultText,
                    warnSoundName = DefaultSoundNames["lrSection"],
                },
                mrSection = {
                    enabled = true,
                    color = makeColor(0.035, 0.865, 0.0),
                    range = 30,
                    text = DefaultText,
                    warnSoundName = DefaultSoundNames["mrSection"],
                },
                srSection = {
                    enabled = true,
                    color = makeColor(0.055, 0.875, 0.825),
                    range = 20,
                    text = DefaultText,
                    warnSoundName = DefaultSoundNames["srSection"],
                },
                crSection = {
                    enabled = true,
                    color = makeColor(0.9, 0.9, 0.9),
                    range = 5,
                    text = DefaultText,
                    warnSoundName = DefaultSoundNames["crSection"],
                },
            },
--            ["playertarget"] = {
--                crSection = {
--                    warnSound = true,
--                },
--            },
            ["focus"] = {
                x = -(DefaultFrameWidth + 10),
            },
            ["pet"] = {
                enabled = false,
                x = (DefaultFrameWidth + 10),
            },
            ["mouseover"] = {
                enabled = true,
                x = 12,
                y = -40,
                frameWidth = 70,
                frameHeight = 26,
                fontSize = 16,
                mouseAnchor = true,
                bg = {
                    bgAutoHide = true,
                },
            },
        },
    },
}

for i = 1, 5 do
    defaults.profile.units['arena' .. i] = {
        enabled = false,
        x = 2 * (DefaultFrameWidth + 10),
        y = (5 - i) * (DefaultFrameHeight + 5),
    }
end

-- Per unit data

local function setDisplayColor_Text(ud, color)
    ud.rangeFrameText:SetTextColor(color.r, color.g, color.b, color.a)
end

local function setDisplayColor_Backdrop(ud, color)
    ud.bgFrame:SetBackdropColor(color.r, color.g, color.b, color.a)
end

local function checkTarget(ud)
    local unit = ud.unit
    if not UnitExists(unit) or UnitIsUnit(unit, "player") then
        return nil
    end
    if UnitIsDeadOrGhost(unit) then
        ud.useSound = false
        return not ud.db.enemyOnly
    end
    if UnitCanAttack("player", unit) then
        ud.useSound = not mute
        return true
    elseif UnitCanAssist("player", unit) then
        ud.useSound = not mute and not ud.db.warnEnemyOnly 
        return not ud.db.enemyOnly
    else
        ud.useSound = false
        return not ud.db.enemyOnly
    end
end

local function targetChanged(ud)
    if ud:checkTarget() then
        ud.rangeFrame:Show()
        ud.lastUpdate = UpdateDelay -- to force update in next onUpdate()
        if not ud.db.targetChangeKeepsSound then
            ud.lastSound = nil -- to force playing sound
            ud.lastMinRange, ud.lastMaxRange = false, false -- to force update
        end
    else
        ud:setDisplayColor(Transparent)
        ud.rangeFrame:Hide()
    end
end

local function profileChanged(ud, db)
    ud.db = db
end

local function mediaUpdate(ud, event, mediaType, key)
    if mediaType == 'font' then
        if key == ud.db.font then
            ud:applyFontSettings()
        end
    elseif mediaType == 'background' then
        if key == ud.db.bgTexture then
            ud:applyBGSettings()
        end
    elseif mediaType == 'border' then
        if key == ud.db.bgBorderTexture then
            ud:applyBGSettings()
        end
    elseif mediaType == 'sound' then
        for _, section in pairs(Sections) do
            if ud.db[section].warnSound and key == ud.db[section].warnSoundName then
                ud.sounds[section] = LSM:Fetch("sound", ud.db[section].warnSoundName)
            end
        end
    end
end

local function applyBGSettings(ud)
    if not ud.db.bgEnabled then
        ud.mainFrame:SetBackdrop(nil)
        ud.rangeFrame:SetBackdrop(nil)
        ud.bgFrame = nil
        ud.setDisplayColor = setDisplayColor_Text
        return
    end
    ud.bg = ud.bg or { insets = {} }
    local bg = ud.bg
    if LSM then
        bg.bgFile = LSM:Fetch("background", ud.db.bgTexture, true)
        if not bg.bgFile then
            bg.bgFile = DefaultBGFile
            LSM.RegisterCallback(ud, "LibSharedMedia_Registered", "mediaUpdate")
        end
        if ud.db.bgBorderTexture == 'None' then -- hack for beta green thing
            bg.edgeFile = false
        else
            bg.edgeFile = LSM:Fetch("border", ud.db.bgBorderTexture, true)
            if not bg.edgeFile then
                bg.edgeFile = DefaultEdgeFile
                LSM.RegisterCallback(ud, "LibSharedMedia_Registered", "mediaUpdate")
            end
        end
    else
        bg.bgFile = DefaultBGFile
        bg.edgeFile = DefaultEdgeFile
    end
    bg.tile = ud.db.bgTile
    bg.tileSize = ud.db.bgTileSize
    bg.edgeSize = ud.db.bgEdgeSize
    local inset = math.floor(ud.db.bgEdgeSize / 4)
    bg.insets.left = inset
    bg.insets.right = inset
    bg.insets.top = inset
    bg.insets.bottom = inset
    if ud.db.bgAutoHide or ud.db.mouseAnchor then
        ud.bgFrame = ud.rangeFrame
        ud.mainFrame:SetBackdrop(nil)
    else
        ud.bgFrame = ud.mainFrame
        ud.rangeFrame:SetBackdrop(nil)
    end
    ud.bgFrame:SetBackdrop(bg)
    ud.bgFrame:SetBackdropBorderColor(ud.db.bgBorderColor.r, ud.db.bgBorderColor.g, ud.db.bgBorderColor.b, ud.db.bgBorderColor.a)
    if ud.db.bgUseSectionColors then
        ud.setDisplayColor = setDisplayColor_Backdrop
        setDisplayColor_Text(ud, ud.db.bgColor)
    else
        ud.setDisplayColor = setDisplayColor_Text
        setDisplayColor_Backdrop(ud, ud.db.bgColor)
    end
    -- ud:setDisplayColor(ud.db.defaultSection.color)
end

local function applyFontSettings(ud)
    local dbFontPath
    if LSM then
        dbFontPath = LSM:Fetch("font", ud.db.font, true)
        if not dbFontPath then
            dbFontPath = DefaultFontPath
            LSM.RegisterCallback(ud, "LibSharedMedia_Registered", "mediaUpdate")
        end
    else
        dbFontPath = DefaultFontPath
    end
    local fontPath, fontSize, fontOutline = ud.rangeFrameText:GetFont()
    fontOutline = fontOutline or ""
    if dbFontPath ~= fontPath or ud.db.fontSize ~= fontSize or ud.db.fontOutline ~= fontOutline then
        ud.rangeFrameText:SetFont(dbFontPath, ud.db.fontSize, ud.db.fontOutline)
    end
end

local function applySettings(ud, whatChanged)
    if ud.db.enabled then
        ud:enable()
        ud.mainFrame:ClearAllPoints()
        ud.mainFrame:SetPoint(ud.db.point, UIParent, ud.db.relPoint, ud.db.x, ud.db.y)
        ud.mainFrame:SetWidth(ud.db.frameWidth)
        ud.mainFrame:SetHeight(ud.db.frameHeight)
        ud.mainFrame:SetFrameStrata(ud.db.strata)
        ud:applyFontSettings()
        ud:applyBGSettings()
        if LSM then
            for _, section in pairs(Sections) do
                if ud.db[section].warnSound then
                    ud.sounds[section] = LSM:Fetch("sound", ud.db[section].warnSoundName)
                    if not ud.sounds[section] then
                        if DefaultSoundNames[section] then
                            ud.sounds[section] = Sounds[DefaultSoundNames[section]]
                        end
                        LSM.RegisterCallback(ud, "LibSharedMedia_Registered", "mediaUpdate")
                    end
                else
                    ud.sounds[section] = nil
                end
            end
        end
        if whatChanged == 'enemyOnly' or whatChanged == 'warnEnemyOnly' or whatChanged == 'enabled' then
            ud:targetChanged()
        end
        ud.lastMinRange, ud.lastMaxRange = false, false -- to force update
        ud:update()
    else
        ud:disable()
    end
end

local function createOverlay(ud)
    local unit = ud.unit

    ud.overlay = ud.mainFrame:CreateTexture("RangeDisplayOverlay_" .. unit, "OVERLAY")
    ud.overlay:SetColorTexture(0, 0.42, 0, 0.42)
    ud.overlay:SetAllPoints()

    ud.overlayText = ud.mainFrame:CreateFontString("RangeDisplayOverlayText_" .. unit, "OVERLAY", "GameFontNormal")
    ud.overlayText:SetFont(DefaultFontPath, 10, "")
    ud.overlayText:SetJustifyH("CENTER")
    ud.overlayText:SetPoint("BOTTOM", ud.mainFrame, "BOTTOM", 0, 0)
    ud.overlayText:SetText(ud.name)
end

local function update(ud)
    local minRange, maxRange = rc:GetRange(ud.unit, ud.db.checkVisible)
    if minRange == ud.lastMinRange and maxRange == ud.lastMaxRange then return end
    ud.lastMinRange, ud.lastMaxRange = minRange, maxRange
    local fmt = ""
    local section = nil
    if minRange then
        if minRange >= ud.db.rangeLimit then maxRange = nil end
        if maxRange then
            if ud.db.crSection.enabled and maxRange <= ud.db.crSection.range then
                section = "crSection"
            elseif ud.db.srSection.enabled and maxRange <= ud.db.srSection.range then
                section = "srSection"
            elseif ud.db.mrSection.enabled and maxRange <= ud.db.mrSection.range then
                section = "mrSection"
            elseif ud.db.lrSection.enabled and maxRange <= ud.db.lrSection.range then
                section = "lrSection"
            elseif ud.db.oorSection.enabled and minRange >= ud.db.oorSection.range then
                section = "oorSection"
            else
                section = "defaultSection"
            end
            fmt = ud.db[section].text
        elseif ud.db.overLimitDisplay then
            if ud.db.oorSection.enabled and minRange >= ud.db.oorSection.range then
                section = "oorSection"
            else
                section = "defaultSection"
            end
            fmt = ud.db.overLimitText
            maxRange = minRange -- to handle ud.db.reverse
        end
    end
    if ud.db.reverse then
        ud.rangeFrameText:SetFormattedText(fmt, maxRange, minRange)
    else
        ud.rangeFrameText:SetFormattedText(fmt, minRange, maxRange)
    end
    if section then
        ud:setDisplayColor(ud.db[section].color)
        local sound = ud.sounds[section]
        if sound and ud.useSound and sound ~= ud.lastSound then
            PlaySoundFile(sound)
        end
        ud.lastSound = sound
    else
        ud:setDisplayColor(Transparent)
    end
end

local function updateCheckValid(ud) -- needed for mouseover target
    if not ud:checkTarget() then
        ud.rangeFrame:Hide()
        return
    end
    update(ud)
end

local function onUpdate(frame, elapsed)
    local ud = frame.ud
    ud.lastUpdate = ud.lastUpdate + elapsed
    if ud.lastUpdate < UpdateDelay then return end
    ud.lastUpdate = 0
    ud:update()
end

local function onUpdateWithMousePos(frame, elapsed)
    local ud = frame.ud
    local x, y = GetCursorPosition()
    ud.mainFrame:ClearAllPoints()
    ud.mainFrame:SetPoint(ud.db.point, UIParent, "BOTTOMLEFT", (x / uiScale) + ud.db.x, (y / uiScale) + ud.db.y)

    ud.lastUpdate = ud.lastUpdate + elapsed
    if ud.lastUpdate < UpdateDelay then return end
    ud.lastUpdate = 0
    ud:update()
end

local function updateUIScale()
    uiScale = UIParent:GetEffectiveScale()
end

local function createFrame(ud)
    local unit = ud.unit
    ud.isMoving = false
    ud.mainFrame = CreateFrame("Frame", "RangeDisplayMainFrame_" .. unit, UIParent)
    ud.mainFrame:SetFrameStrata(ud.db.strata)
    ud.mainFrame:EnableMouse(false)
    ud.mainFrame:SetClampedToScreen()
    ud.mainFrame:SetMovable(true)
    ud.mainFrame:SetWidth(ud.db.frameWidth)
    ud.mainFrame:SetHeight(ud.db.frameHeight)
    ud.mainFrame:SetPoint(ud.db.point, UIParent, ud.db.relPoint, ud.db.x, ud.db.y)

    ud.rangeFrame = CreateFrame("Frame", "RangeDisplayFrame_" .. unit, ud.mainFrame)
    ud.rangeFrame:SetPoint("CENTER", ud.mainFrame, "CENTER", 0, 0)
    ud.rangeFrame:SetAllPoints()
    ud.rangeFrame:Hide()

    ud.rangeFrameText = ud.rangeFrame:CreateFontString("RangeDisplayFrameText_" .. unit, "ARTWORK", "GameFontNormal")
    ud.rangeFrameText:SetFont(DefaultFontPath, ud.db.fontSize, ud.db.fontOutline)
    ud.rangeFrameText:SetJustifyH("CENTER")
    ud.rangeFrameText:SetPoint("CENTER", ud.rangeFrame, "CENTER", 0, 0)

    ud.lastUpdate = 0

    ud.mainFrame:SetScript("OnMouseDown", function(frame, button)
        if button == "LeftButton" then
            if IsControlKeyDown() then
                RangeDisplay:toggleLocked(true)
                return
            end
            ud.mainFrame:StartMoving()
            ud.isMoving = true
            GameTooltip:Hide()
        elseif button == "RightButton" then
            RangeDisplay:openConfigDialog(ud)
        end
    end)
    ud.mainFrame:SetScript("OnMouseUp", function(frame, button)
        if ud.isMoving and button == "LeftButton" then
            ud.mainFrame:StopMovingOrSizing()
            ud.isMoving = false
            ud.db.point, _, ud.db.relPoint, ud.db.x, ud.db.y = ud.mainFrame:GetPoint()
        end
    end)
    ud.mainFrame:SetScript("OnEnter", function(frame)
        GameTooltip:SetOwner(frame)
        GameTooltip:AddLine("RangeDisplay: " .. ud.name)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["|cffeda55fControl + Left Click|r to lock frames"])
        GameTooltip:AddLine(L["|cffeda55fRight Click|r to open the configuration window"])
        GameTooltip:AddLine(L["|cffeda55fDrag|r to move the frame"])
        GameTooltip:Show()
    end)
    ud.mainFrame:SetScript("OnLeave", function(frame)
        GameTooltip:Hide()
    end)

    -- OnUpdate is set only on the rangeFrame
    ud.rangeFrame.ud = ud
    ud.rangeFrame:SetScript("OnUpdate", onUpdate)
end

local function enable(ud)
    if not ud.mainFrame then
        ud:createFrame()
    end
    if not ud.sounds then
        ud.sounds = {}
    end
    if ud.locked then
        ud:lock()
    else
        ud:unlock()
    end
    ud.mainFrame:Show()
    RangeDisplay:registerTargetChangedEvent(ud)
end

local function disable(ud)
    if ud.mainFrame then
        ud.mainFrame:Hide()
        RangeDisplay:unregisterTargetChangedEvent(ud)
    end
end

local function lock(ud)
    ud.locked = true
    if ud.db.enabled then
        ud.mainFrame:EnableMouse(false)
        if ud.overlay then
            ud.overlay:Hide()
            ud.overlayText:Hide()
        end
    end
end

local function unlock(ud)
    ud.locked = false
    if ud.db.enabled then
        if not ud.overlay then
            createOverlay(ud)
        end
        ud.mainFrame:EnableMouse(true)
        ud.overlay:Show()
        ud.overlayText:Show()
    end
end

local units = {
    {
        unit = "playertarget",
        name = L["playertarget"],
        event = "PLAYER_TARGET_CHANGED",
    },
    {
        unit = "pet",
        name = L["pet"],
        event = "UNIT_PET",
        targetChanged = function(ud, event, unitId, ...)
                if event and unitId ~= "player" then return end
                targetChanged(ud, event, unitId, ...)
            end,
    },
    {
        unit = "mouseover",
        name = L["mouseover"],
        event = "UPDATE_MOUSEOVER_UNIT",
        mouseAnchor = true,
        applyMouseSettings = function(ud)
                if ud.db.enabled then
                    if ud.locked and ud.db.mouseAnchor then
                        ud.rangeFrame:SetScript("OnUpdate", onUpdateWithMousePos)
                        ud.rangeFrame:SetScript("OnShow", updateUIScale)
                    else
                        ud.rangeFrame:SetScript("OnUpdate", onUpdate)
                        ud.rangeFrame:SetScript("OnShow", nil)
                        ud.mainFrame:ClearAllPoints()
                        ud.mainFrame:SetPoint(ud.db.point, UIParent, ud.db.relPoint, ud.db.x, ud.db.y)
                    end
                    if not ud.locked and ud.db.mouseAnchor then
                        if not ud.fakeCursor then
                            ud.fakeCursor = UIParent:CreateTexture("RangeDisplayFakeCursor", "OVERLAY")
                            ud.fakeCursor:SetTexture(FakeCursorImage)
                            ud.fakeCursor:ClearAllPoints()
                            ud.fakeCursor:SetPoint("TOPLEFT", UIParent, "CENTER", 0, 0)
                            ud.fakeCursor:SetVertexColor(0, .42, 0)
                            ud.fakeCursor:SetAlpha(0.42)
                        end
                        ud.fakeCursor:Show()
                    else
                        if ud.fakeCursor then
                            ud.fakeCursor:Hide()
                        end
                    end
                else
                    if ud.fakeCursor then
                        ud.fakeCursor:Hide()
                    end
                end
            end,
        lock = function(ud)
                lock(ud)
                ud:applyMouseSettings()
            end,
        unlock = function(ud)
                unlock(ud)
                ud:applyMouseSettings()
            end,
        disable = function(ud)
                disable(ud)
                if ud.fakeCursor then
                    ud.fakeCursor:Hide()
                end
            end,
        update = updateCheckValid,
    },
}

if not IsClassic then
    local fu = {
        unit = "focus",
        name = L["focus"],
        event = "PLAYER_FOCUS_CHANGED",
    }
    tinsert(units, fu)
end

local arenaUnits

local arenaMasterUnit = {
    unit = ("arena%d"):format(1),
    name = L["arena%d"]:format(1),
    event = "ARENA_OPPONENT_UPDATE",
    eventHandler = function()
            for _, ud in ipairs(arenaUnits) do
                if ud.db.enabled then
                    targetChanged(ud)
                end
            end
        end,
    applySettings = function(mud, whatChanged)
            if whatChanged == 'enabled' then
                for _, ud in ipairs(arenaUnits) do
                    ud.db.enabled = mud.db.enabled
                    applySettings(ud, whatChanged)
                end
            else
                applySettings(mud, whatChanged)
            end
        end,
}

-- AceAddon stuff

function RangeDisplay:OnInitialize()
    if LSM then
        for sound, fileName in pairs(Sounds) do
            LSM:Register("sound", sound, fileName)
        end
    end
    self.db = LibStub("AceDB-3.0"):New("RangeDisplayDB3", defaults, true)
    if LibDualSpec then
        LibDualSpec:EnhanceDatabase(self.db, AppName)
    end

    if not IsClassic and self.db.global.enableArena and not arenaUnits then
        arenaUnits = {}
        tinsert(arenaUnits, arenaMasterUnit)
        tinsert(units, arenaMasterUnit)
        for i = 2, 5 do
            local au = {
                unit = ("arena%d"):format(i),
                name = L["arena%d"]:format(i),
            }
            tinsert(arenaUnits, au)
            tinsert(units, au)
        end
    end
    for _, ud in ipairs(units) do
        ud.profileChanged = ud.profileChanged or profileChanged
        ud.applySettings = ud.applySettings or applySettings
        ud.applyFontSettings = ud.applyFontSettings or applyFontSettings
        ud.applyBGSettings = ud.applyBGSettings or applyBGSettings
        ud.mediaUpdate = ud.mediaUpdate or mediaUpdate
        ud.targetChanged = ud.targetChanged or targetChanged
        ud.checkTarget = ud.checkTarget or checkTarget
        ud.lock = ud.lock or lock
        ud.unlock = ud.unlock or unlock
        ud.createFrame = ud.createFrame or createFrame
        ud.update = ud.update or update
        ud.enable = ud.enable or enable
        ud.disable = ud.disable or disable
    end

    self.units = units
    self.db.RegisterCallback(self, "OnProfileChanged", "profileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "profileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "profileChanged")
    self:profileChanged()
    self:setupDummyOptions()
    self:setupLDB()
    if not self.db.profile.locked then
        self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
            if not self.db.profile.locked then
                self:toggleLocked(true)
            end
        end)
    end
end

function RangeDisplay:OnEnable(first)
    self:applySettings()
end

function RangeDisplay:OnDisable()
    for _, ud in ipairs(units) do
        ud:disable()
    end
    self:UnregisterAllEvents()
end

function RangeDisplay:applySettings()
    if not self:IsEnabled() then
        self:OnDisable()
        return
    end
    for _, ud in ipairs(units) do
        if ud.db.enabled then
            ud:enable()
            ud:applySettings()
        else
            ud:disable()
        end
    end
    self:toggleLocked(self.db.profile.locked == true)
    self:toggleMute(self.db.profile.mute == true)
end

-- for now we assume that each unitdata is using only 1 event, and there are no overlapping events, as it's faster like this
function RangeDisplay:registerTargetChangedEvent(ud)
    if ud.event then
        ud.eventHandler = ud.eventHandler or function(...)
            ud:targetChanged(...)
        end
        self:RegisterEvent(ud.event, ud.eventHandler)
    end
end

function RangeDisplay:unregisterTargetChangedEvent(ud)
    if ud.event then
        self:UnregisterEvent(ud.event)
    end
end

function RangeDisplay:profileChanged()
    local locked = self.db.profile.locked
    for _, ud in ipairs(units) do
        ud.locked = locked
        local db = self.db.profile.units[ud.unit]
        ud:profileChanged(db)
    end
    self:applySettings()
end

function RangeDisplay:lock()
    self.db.profile.locked = true
    for _, ud in ipairs(units) do
        ud:lock()
    end
end

function RangeDisplay:unlock()
    self.db.profile.locked = false
    for _, ud in ipairs(units) do
        ud:unlock()
    end
end

function RangeDisplay:toggleLocked(flag)
    if flag == nil then
        flag = not self.db.profile.locked
    end
    if flag ~= self.db.profile.locked then
        self:updateMainOptions()
    end
    if flag then
        self:lock()
    else
        self:unlock()
    end
end

function RangeDisplay:toggleMute(flag)
    if flag == nil then
        flag = not self.db.profile.mute
    end
    if flag ~= self.db.profile.mute then
        self:updateMainOptions()
    end
    self.db.profile.mute = flag
    mute = flag
    for _, ud in ipairs(units) do
        if ud.db.enabled then
            ud:checkTarget() -- to update useSound
        end
    end
end

function RangeDisplay:setupLDB()
    local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
    if not LDB then return end
    local ldb = {
        type = "launcher",
        icon = Icon,
        OnClick = function(frame, button)
            if button == "LeftButton" then
                if IsShiftKeyDown() then
                    self:toggleMute()
                else
                    self:toggleLocked()
                end
            elseif button == "RightButton" then
                self:openConfigDialog()
            end
        end,
        OnTooltipShow = function(tt)
            tt:AddLine(self.AppName)
            tt:AddLine(L["|cffeda55fLeft Click|r to lock/unlock frames"])
            tt:AddLine(L["|cffeda55fShift + Left Click|r to toggle sound"])
            tt:AddLine(L["|cffeda55fRight Click|r to open the configuration window"])
        end,
    }
    LDB:NewDataObject(self.AppName, ldb)
end

-- LoD Options muckery

function RangeDisplay:setupDummyOptions()
    if self.optionsLoaded then
        return
    end
    self.dummyOpts = CreateFrame("Frame", AppName .. "DummyOptions", UIParent)
    self.dummyOpts:Hide()
    self.dummyOpts.name = AppName
    self.dummyOpts:SetScript("OnShow", function(frame)
        if not self.optionsLoaded then
            if not InterfaceOptionsFrame:IsVisible() then
                return -- wtf... Happens if you open the game map and close it with ESC
            end
            self:openConfigDialog()
        else
            frame:Hide()
        end
    end)
    InterfaceOptions_AddCategory(self.dummyOpts)
end

function RangeDisplay:loadOptions()
    if not self.optionsLoaded then
        self.optionsLoaded = true
        local loaded, reason = LoadAddOn(OptionsAppName)
        if not loaded then
            print("Failed to load " .. tostring(OptionsAppName) .. ": " .. tostring(reason))
        end
    end
end

function RangeDisplay:openConfigDialog(ud)
    -- this function will be overwritten by the Options module when loaded
    if not self.optionsLoaded then
        self:loadOptions()
        InterfaceAddOnsList_Update()
        return self:openConfigDialog(ud)
    end
    InterfaceOptionsFrame_OpenToCategory(self.dummyOpts)
end

-- Stubs for RangeDisplay_Options

function RangeDisplay:updateMainOptions()
end

-- register slash command

SLASH_RANGEDISPLAY1 = "/rangedisplay"
SlashCmdList["RANGEDISPLAY"] = function(msg)
    msg = strtrim(msg or "")
    if msg == "locked" then
        RangeDisplay:toggleLocked()
    else
        RangeDisplay:openConfigDialog()
    end
end

CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
CONFIGMODE_CALLBACKS[AppName] = function(action)
    if action == "ON" then
         RangeDisplay:toggleLocked(false)
    elseif action == "OFF" then
         RangeDisplay:toggleLocked(true)
    end
end
