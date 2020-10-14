local MAJOR_VERSION = "LibGetFrame-1.0"
local MINOR_VERSION = 23
if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
local callbacks = lib.callbacks

local GetPlayerInfoByGUID, UnitExists, IsAddOnLoaded, C_Timer, UnitIsUnit, SecureButton_GetUnit = GetPlayerInfoByGUID, UnitExists, IsAddOnLoaded, C_Timer, UnitIsUnit, SecureButton_GetUnit
local tinsert, CopyTable, wipe = tinsert, CopyTable, wipe

local maxDepth = 50

local defaultFramePriorities = {
    -- raid frames
    [1] = "^Vd1", -- vuhdo
    [2] = "^Vd2", -- vuhdo
    [3] = "^Vd3", -- vuhdo
    [4] = "^Vd4", -- vuhdo
    [5] = "^Vd5", -- vuhdo
    [6] = "^Vd", -- vuhdo
    [7] = "^HealBot", -- healbot
    [8] = "^GridLayout", -- grid
    [9] = "^Grid2Layout", -- grid2
    [10] = "^ElvUF_RaidGroup", -- elv
    [11] = "^oUF_bdGrid", -- bdgrid
    [12] = "^oUF_.-Raid", -- generic oUF
    [13] = "^LimeGroup", -- lime
    [14] = "^SUFHeaderraid", -- suf
    -- party frames
    [15] = "^AleaUI_GroupHeader", -- Alea
    [16] = "^SUFHeaderparty", --suf
    [17] = "^ElvUF_PartyGroup", -- elv
    [18] = "^oUF_.-Party", -- generic oUF
    [19] = "^PitBull4_Groups_Party", -- pitbull4
    [20] = "^CompactRaid", -- blizz
    [21] = "^CompactParty", -- blizz
    -- player frame
    [22] = "^SUFUnitplayer",
    [23] = "^PitBull4_Frames_Player",
    [24] = "^ElvUF_Player",
    [25] = "^oUF_.-Player",
    [26] = "^PlayerFrame",
}

local defaultPlayerFrames = {
    "SUFUnitplayer",
    "PitBull4_Frames_Player",
    "ElvUF_Player",
    "oUF_.-Player",
    "oUF_PlayerPlate",
    "PlayerFrame",
}
local defaultTargetFrames = {
    "SUFUnittarget",
    "PitBull4_Frames_Target",
    "ElvUF_Target",
    "oUF_.-Target",
    "TargetFrame",
}
local defaultTargettargetFrames = {
    "SUFUnittargetarget",
    "PitBull4_Frames_Target's target",
    "ElvUF_TargetTarget",
    "oUF_.-TargetTarget",
    "oUF_ToT",
    "TargetTargetFrame",
}
local defaultPartyTargetFrames = {
    "SUFChildpartytarget%d",
}

local GetFramesCache = {}
local FrameToUnitFresh = {}
local FrameToUnit = {}
local UpdatedFrames = {}

local function ScanFrames(depth, frame, ...)
    if not frame then return end
    if depth < maxDepth
    and frame.IsForbidden
    and not frame:IsForbidden()
    then
        local frameType = frame:GetObjectType()
        if frameType == "Frame" or frameType == "Button" then
            ScanFrames(depth + 1, frame:GetChildren())
        end
        if frameType == "Button" then
            local unit = SecureButton_GetUnit(frame)
            local name = frame:GetName()
            if unit and frame:IsVisible() and name then
                GetFramesCache[frame] = name
                if unit ~= FrameToUnit[frame] then
                    FrameToUnit[frame] = unit
                    UpdatedFrames[frame] = unit
                end
                FrameToUnitFresh[frame] = unit
            end
        end
    end
    ScanFrames(depth, ...)
end

local wait = false

local function doScanForUnitFrames()
    wait = false
    wipe(UpdatedFrames)
    wipe(GetFramesCache)
    wipe(FrameToUnitFresh)
    ScanFrames(0, UIParent)
    callbacks:Fire("GETFRAME_REFRESH")
    for frame, unit in pairs(UpdatedFrames) do
        callbacks:Fire("FRAME_UNIT_UPDATE", frame, unit)
    end
    for frame, unit in pairs(FrameToUnit) do
        if FrameToUnitFresh[frame] ~= unit then
            callbacks:Fire("FRAME_UNIT_REMOVED", frame, unit)
            FrameToUnit[frame] = nil
        end
    end
end
local function ScanForUnitFrames(noDelay)
    if noDelay then
        doScanForUnitFrames()
    elseif not wait then
        wait = true
        C_Timer.After(1, function()
            doScanForUnitFrames()
        end)
    end
end

local function isFrameFiltered(name, ignoredFrames)
    for _, filter in pairs(ignoredFrames) do
        if name:find(filter) then
            return true
        end
    end
    return false
end

local function GetUnitFrames(target, ignoredFrames)
    if not UnitExists(target) then
        if type(target) == "string" and target:find("Player") then
            target = select(6, GetPlayerInfoByGUID(target))
        else
            target = target:gsub(" .*", "")
            if not UnitExists(target) then
                return
            end
        end
    end

    local frames
    for frame, frameName in pairs(GetFramesCache) do
        local unit = SecureButton_GetUnit(frame)
        if unit and UnitIsUnit(unit, target)
        and not isFrameFiltered(frameName, ignoredFrames)
        then
            frames = frames or {}
            frames[frame] = frameName
        end
    end
    return frames
end

local function ElvuiWorkaround(frame)
    if IsAddOnLoaded("ElvUI") and frame and frame:GetName():find("^ElvUF_") and frame.Health then
        return frame.Health
    else
        return frame
    end
end

local defaultOptions = {
    framePriorities = defaultFramePriorities,
    ignorePlayerFrame = true,
    ignoreTargetFrame = true,
    ignoreTargettargetFrame = true,
    ignorePartyTargetFrame = true,
    playerFrames = defaultPlayerFrames,
    targetFrames = defaultTargetFrames,
    targettargetFrames = defaultTargettargetFrames,
    partyTargetFrames = defaultPartyTargetFrames,
    ignoreFrames = {
        "PitBull4_Frames_Target's target's target",
        "ElvUF_PartyGroup%dUnitButton%dTarget",
        "ElvUF_FocusTarget",
        "RavenButton"
    },
    returnAll = false,
}

local GetFramesCacheListener
local function Init(noDelay)
    GetFramesCacheListener = CreateFrame("Frame")
    GetFramesCacheListener:RegisterEvent("PLAYER_REGEN_DISABLED")
    GetFramesCacheListener:RegisterEvent("PLAYER_REGEN_ENABLED")
    GetFramesCacheListener:RegisterEvent("PLAYER_ENTERING_WORLD")
    GetFramesCacheListener:RegisterEvent("GROUP_ROSTER_UPDATE")
    GetFramesCacheListener:SetScript("OnEvent", function() ScanForUnitFrames(false) end)
    ScanForUnitFrames(noDelay)
end

function lib.GetUnitFrame(target, opt)
    if type(GetFramesCacheListener) ~= "table" then Init(true) end
    opt = opt or {}
    setmetatable(opt, { __index = defaultOptions })

    if not target then return end

    local ignoredFrames = CopyTable(opt.ignoreFrames)
    if opt.ignorePlayerFrame then
        for _,v in pairs(opt.playerFrames) do
            tinsert(ignoredFrames, v)
        end
    end
    if opt.ignoreTargetFrame then
        for _,v in pairs(opt.targetFrames) do
            tinsert(ignoredFrames, v)
        end
    end
    if opt.ignoreTargettargetFrame then
        for _,v in pairs(opt.targettargetFrames) do
            tinsert(ignoredFrames, v)
        end
    end
    if opt.ignorePartyTargetFrame then
        for _,v in pairs(opt.partyTargetFrames) do
            tinsert(ignoredFrames, v)
        end
    end

    local frames = GetUnitFrames(target, ignoredFrames)
    if not frames then return end

    if not opt.returnAll then
        for i = 1, #opt.framePriorities do
            for frame, frameName in pairs(frames) do
                if frameName:find(opt.framePriorities[i]) then
                    return ElvuiWorkaround(frame)
                end
            end
        end
        local next = next
        return ElvuiWorkaround(next(frames))
    else
        for frame in pairs(frames) do
            frames[frame] = ElvuiWorkaround(frame)
        end
        return frames
    end
end
lib.GetFrame = lib.GetUnitFrame -- compatibility

-- nameplates
function lib.GetUnitNameplate(unit)
    if not unit then return end
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if nameplate then
        -- credit to Exality for https://wago.io/explosiveorbs
        if nameplate.unitFrame and nameplate.unitFrame.Health then
          -- elvui
          return nameplate.unitFrame.Health
        elseif nameplate.unitFramePlater then
          -- plater
          return nameplate.unitFramePlater.healthBar
        elseif nameplate.kui then
          -- kui
          return nameplate.kui.HealthBar
        elseif nameplate.extended then
          -- tidyplates
          --nameplate.extended.visual.healthbar:SetHeight(tidyplatesHeight)
          return nameplate.extended.visual.healthbar
        elseif nameplate.TPFrame then
          -- tidyplates: threat plates
          return nameplate.TPFrame.visual.healthbar
        elseif nameplate.ouf then
          -- bdNameplates
          return nameplate.ouf.Health
        elseif nameplate.UnitFrame then
          -- default
          return nameplate.UnitFrame.healthBar
        else
          return nameplate
        end
    end
end
