local MAJOR_VERSION = "LibGetFrame-1.0"
local MINOR_VERSION = 7
if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

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
    [12] = "^oUF.*raid", -- generic oUF
    [13] = "^LimeGroup", -- lime
    [14] = "^SUFHeaderraid", -- suf
    [15] = "^CompactRaid", -- blizz
    -- party frames
    [16] = "^AleaUI_GroupHeader", -- Alea
    [17] = "^SUFHeaderparty", --suf
    [18] = "^ElvUF_PartyGroup", -- elv
    [19] = "^oUF.*party", -- generic oUF
    [20] = "^PitBull4_Groups_Party", -- pitbull4
    [21] = "^CompactParty", -- blizz
    -- player frame
    [22] = "^SUFUnitplayer",
    [23] = "^PitBull4_Frames_Player",
    [24] = "^ElvUF_Player",
    [25] = "^oUF.*player",
    [26] = "^PlayerFrame",
}

local defaultPlayerFrames = {
    "SUFUnitplayer",
    "PitBull4_Frames_Player",
    "ElvUF_Player",
    "oUF_TukuiPlayer",
    "PlayerFrame",
}
local defaultTargetFrames = {
    "SUFUnittarget",
    "PitBull4_Frames_Target",
    "ElvUF_Target",
    "TargetFrame",
    "oUF_TukuiTarget",
}
local defaultTargettargetFrames = {
    "SUFUnittargetarget",
    "PitBull4_Frames_Target's target",
    "ElvUF_TargetTarget",
    "TargetTargetFrame",
    "oUF_TukuiTargetTarget",
}

local GetFramesCache = {}

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
            end
        end
    end
    ScanFrames(depth, ...)
end

local function ScanForUnitFrames()
    C_Timer.After(1, function()
        wipe(GetFramesCache)
        ScanFrames(0, UIParent)
    end)
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
    playerFrames = defaultPlayerFrames,
    targetFrames = defaultTargetFrames,
    targettargetFrames = defaultTargettargetFrames,
    ignoreFrames = {
        "PitBull4_Frames_Target's target's target"
    },
    returnAll = false,
}

local GetFramesCacheListener
lib.Init = function()
    GetFramesCacheListener = CreateFrame("Frame")
    GetFramesCacheListener:RegisterEvent("PLAYER_REGEN_DISABLED")
    GetFramesCacheListener:RegisterEvent("PLAYER_REGEN_ENABLED")
    GetFramesCacheListener:RegisterEvent("PLAYER_ENTERING_WORLD")
    GetFramesCacheListener:RegisterEvent("GROUP_ROSTER_UPDATE")
    GetFramesCacheListener:SetScript("OnEvent", ScanForUnitFrames)

    ScanForUnitFrames()
end

function lib.GetUnitFrame(target, opt)
    if not GetFramesCacheListener then lib.Init() end
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
