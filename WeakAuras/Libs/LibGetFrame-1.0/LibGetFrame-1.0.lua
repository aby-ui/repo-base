local MAJOR_VERSION = "LibGetFrame-1.0"
local MINOR_VERSION = 52
if not LibStub then
  error(MAJOR_VERSION .. " requires LibStub.")
end
local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then
  return
end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
local callbacks = lib.callbacks

local GetPlayerInfoByGUID, UnitExists, IsAddOnLoaded, C_Timer, UnitIsUnit, SecureButton_GetUnit =
  GetPlayerInfoByGUID, UnitExists, IsAddOnLoaded, C_Timer, UnitIsUnit, SecureButton_GetUnit
local tinsert, CopyTable, wipe = tinsert, CopyTable, wipe

local maxDepth = 50

local defaultFramePriorities = {
  -- raid frames
  "^Vd1", -- vuhdo
  "^Vd2", -- vuhdo
  "^Vd3", -- vuhdo
  "^Vd4", -- vuhdo
  "^Vd5", -- vuhdo
  "^Vd", -- vuhdo
  "^HealBot", -- healbot
  "^GridLayout", -- grid
  "^Grid2Layout", -- grid2
  "^NugRaid%d+UnitButton%d+", -- Aptechka
  "^PlexusLayout", -- plexus
  "^ElvUF_Raid%d*Group", -- elv
  "^oUF_bdGrid", -- bdgrid
  "^oUF_.-Raid", -- generic oUF
  "^LimeGroup", -- lime
  "^InvenRaidFrames3Group%dUnitButton", -- InvenRaidFrames3
  "^SUFHeaderraid", -- suf
  "^LUFHeaderraid", -- luf
  "^AshToAshUnit%d+Unit%d+", -- AshToAsh
  "^Cell", -- Cell
  -- party frames
  "^AleaUI_GroupHeader", -- Alea
  "^SUFHeaderparty", --suf
  "^LUFHeaderparty", --luf
  "^ElvUF_PartyGroup", -- elv
  "^oUF_.-Party", -- generic oUF
  "^PitBull4_Groups_Party", -- pitbull4
  "^CompactRaid", -- blizz
  "^CompactParty", -- blizz
  -- player frame
  "^InvenUnitFrames_Player",
  "^SUFUnitplayer",
  "^LUFUnitplayer",
  "^PitBull4_Frames_Player",
  "^ElvUF_Player",
  "^oUF_.-Player",
  "^PlayerFrame",
}

local defaultPlayerFrames = {
  "^InvenUnitFrames_Player",
  "SUFUnitplayer",
  "LUFUnitplayer",
  "PitBull4_Frames_Player",
  "ElvUF_Player",
  "oUF_.-Player",
  "oUF_PlayerPlate",
  "PlayerFrame",
}
local defaultTargetFrames = {
  "^InvenUnitFrames_Target",
  "SUFUnittarget",
  "LUFUnittarget",
  "PitBull4_Frames_Target",
  "ElvUF_Target",
  "oUF_.-Target",
  "TargetFrame",
}
local defaultTargettargetFrames = {
  "^InvenUnitFrames_TargetTarget",
  "SUFUnittargetarget",
  "LUFUnittargetarget",
  "PitBull4_Frames_Target's target",
  "ElvUF_TargetTarget",
  "oUF_.-TargetTarget",
  "oUF_ToT",
  "TargetTargetFrame",
}
local defaultPartyFrames = {
  "^InvenUnitFrames_Party%d",
  "^AleaUI_GroupHeader",
  "^SUFHeaderparty",
  "^LUFHeaderparty",
  "^ElvUF_PartyGroup",
  "^oUF_.-Party",
  "^PitBull4_Groups_Party",
  "^CompactParty",
}
local defaultPartyTargetFrames = {
  "SUFChildpartytarget%d",
}
local defaultFocusFrames = {
  "^InvenUnitFrames_Focus",
  "ElvUF_FocusTarget",
  "LUFUnitfocus",
  "FocusFrame",
}
local defaultRaidFrames = {
  "^Vd",
  "^HealBot",
  "^GridLayout",
  "^Grid2Layout",
  "^PlexusLayout",
  "^InvenRaidFrames3Group%dUnitButton",
  "^ElvUF_Raid%d*Group",
  "^oUF_.-Raid",
  "^AshToAsh",
  "^Cell",
  "^LimeGroup",
  "^SUFHeaderraid",
  "^LUFHeaderraid",
  "^CompactRaid",
}

--
local CacheMonitorMixin = {}
function CacheMonitorMixin:Init(makeDiff)
  self.data = {}
  self.cache = {}
  if makeDiff then
    self.makeDiff = makeDiff
    self.added = {}
    self.updated = {}
    self.removed = {}
  end
end
-- fill cache, added, updated
function CacheMonitorMixin:Add(key, ...)
  local args = select("#", ...)
  if args > 1 then
    if self.makeDiff then
      if type(self.data[key]) == "table" then
        for i = 1, args do
          local arg = select(i, ...)
          if self.data[key][i] ~= arg then
            self.updated[key] = self.data[key]
            break
          end
        end
      else
        self.added[key] = true
      end
    end
    self.cache[key] = {...}
  else
    local value = ...
    if self.makeDiff then
      if self.data[key] ~= value then
        if self.data[key] == nil then
          self.added[key] = true
        else
          self.updated[key] = self.data[key]
        end
      end
    end
    self.cache[key] = value
  end
end
function CacheMonitorMixin:CalcRemoved()
  if not self.makeDiff then return end
  for key, value in pairs(self.data) do
    if self.cache[key] == nil then
      self.removed[key] = value
    end
  end
end
function CacheMonitorMixin:WriteCache()
  local tmp = self.data
  self.data = self.cache
  self.cache = tmp
  wipe(self.cache)
end
function CacheMonitorMixin:Reset()
  if self.makeDiff then
    wipe(self.updated)
    wipe(self.removed)
    wipe(self.added)
  end
end
--
local FrameToFrameName = {}   -- frame adress => frame name
local FrameToUnit = {}        -- frame adress => unitToken
Mixin(FrameToFrameName, CacheMonitorMixin)
Mixin(FrameToUnit, CacheMonitorMixin)
FrameToFrameName:Init()
FrameToUnit:Init(true)

local profiling = false
local profileData

local function doNothing()
end

local StartProfiling = doNothing
local StopProfiling = doNothing

local function _StartProfiling(id)
  if not profileData[id] then
    profileData[id] = {}
    profileData[id].count = 1
    profileData[id].start = debugprofilestop()
    profileData[id].elapsed = 0
    profileData[id].spike = 0
    return
  end

  if profileData[id].count == 0 then
    profileData[id].count = 1
    profileData[id].start = debugprofilestop()
  else
    profileData[id].count = profileData[id].count + 1
  end
end

local function _StopProfiling(id)
  profileData[id].count = profileData[id].count - 1
  if profileData[id].count == 0 then
    local elapsed = debugprofilestop() - profileData[id].start
    profileData[id].elapsed = profileData[id].elapsed + elapsed
    if elapsed > profileData[id].spike then
      profileData[id].spike = elapsed
    end
  end
end

function lib.StartProfile()
  if profiling then
    print(MAJOR_VERSION, " (StartProfile) Profiling already started")
    return false
  end
  profiling = true
  profileData = {}
  StartProfiling = _StartProfiling
  StopProfiling = _StopProfiling
end

function lib.StopProfile()
  if not profiling then
    print(MAJOR_VERSION, " (StopProfile) Profiling not running")
    return false
  end
  profiling = false
  StartProfiling = doNothing
  StopProfiling = doNothing
end

function lib.GetProfileData()
  return profileData or {}
end

local function ScanFrames(depth, frame, ...)
  coroutine.yield()
  if not frame then
    return
  end
  if depth < maxDepth and frame.IsForbidden and not frame:IsForbidden() then
    local frameType = frame:GetObjectType()
    if frameType == "Frame" or frameType == "Button" then
      ScanFrames(depth + 1, frame:GetChildren())
    end
    if frameType == "Button" then
      local unit = SecureButton_GetUnit(frame)
      local name = frame:GetName()
      if unit and frame:IsVisible() and name then
        FrameToFrameName:Add(frame, name)
        FrameToUnit:Add(frame, unit)
      end
    end
  end
  ScanFrames(depth, ...)
end

local status = "ready"
local co
local coroutineFrame = CreateFrame("Frame")
coroutineFrame:Hide()

local function doScanForUnitFrames()
  if not coroutineFrame:IsShown() then
    status = "scanning"
    co = coroutine.create(ScanFrames)
    coroutineFrame:Show()
  end
end

coroutineFrame:SetScript("OnUpdate", function()
  local start = debugprofilestop()
  -- Limit to 5ms per frame
  StartProfiling("scan frames")
  while debugprofilestop() - start < 5 and coroutine.status(co) ~= "dead" do
    coroutine.resume(co, 0, UIParent)
  end
  StopProfiling("scan frames")
  if coroutine.status(co) == "dead" then
    StartProfiling("callbacks")
    FrameToFrameName:WriteCache()
    FrameToUnit:CalcRemoved()
    FrameToUnit:WriteCache()
    StartProfiling("callback GETFRAME_REFRESH")
    callbacks:Fire("GETFRAME_REFRESH")
    StopProfiling("callback GETFRAME_REFRESH")
    -- FrameToUnit
    if next(FrameToUnit.added) then
      StartProfiling("callback FRAME_UNIT_ADDED")
      for frame in pairs(FrameToUnit.added) do
        callbacks:Fire("FRAME_UNIT_ADDED", frame, FrameToUnit.data[frame])
      end
      StopProfiling("callback FRAME_UNIT_ADDED")
    end
    if next(FrameToUnit.updated) then
      StartProfiling("callback FRAME_UNIT_UPDATE")
      for frame, previousUnit in pairs(FrameToUnit.updated) do
        callbacks:Fire("FRAME_UNIT_UPDATE", frame, FrameToUnit.data[frame], previousUnit)
      end
      StopProfiling("callback FRAME_UNIT_UPDATE")
    end
    if next(FrameToUnit.removed) then
      StartProfiling("callback FRAME_UNIT_REMOVED")
      for frame, unit in pairs(FrameToUnit.removed) do
        callbacks:Fire("FRAME_UNIT_REMOVED", frame, unit)
      end
      StopProfiling("callback FRAME_UNIT_REMOVED")
    end
    coroutineFrame:Hide()
    FrameToFrameName:Reset()
    FrameToUnit:Reset()
    StopProfiling("callbacks")
    if status == "scan_queued" then
      doScanForUnitFrames("queued")
    else
      status = "ready"
    end
  end
end)

local function ScanForUnitFrames(noDelay)
  if status == "ready" then
    if noDelay then
      doScanForUnitFrames()
    else
      status = "scan_delay"
      C_Timer.After(1, function()
        doScanForUnitFrames()
      end)
    end
  elseif status == "scanning" then
    status = "scan_queued"
  end
end

function lib.ScanForUnitFrames()
  ScanForUnitFrames(true)
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
    if type(target) ~= "string" then
      return
    end
    if target:find("Player") then
      target = select(6, GetPlayerInfoByGUID(target))
    else
      target = target:gsub(" .*", "")
    end
    if not UnitExists(target) then
      return
    end
  end

  local frames
  for frame, frameName in pairs(FrameToFrameName.data) do
    local unit = SecureButton_GetUnit(frame)
    if unit and UnitIsUnit(unit, target) and not isFrameFiltered(frameName, ignoredFrames) then
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
  ignorePartyFrame = false,
  ignorePartyTargetFrame = true,
  ignoreFocusFrame = true,
  ignoreRaidFrame = false,
  playerFrames = defaultPlayerFrames,
  targetFrames = defaultTargetFrames,
  targettargetFrames = defaultTargettargetFrames,
  partyFrames = defaultPartyFrames,
  partyTargetFrames = defaultPartyTargetFrames,
  focusFrames = defaultFocusFrames,
  raidFrames = defaultRaidFrames,
  ignoreFrames = {
    "PitBull4_Frames_Target's target's target",
    "ElvUF_PartyGroup%dUnitButton%dTarget",
    "RavenOverlay",
    "AshToAshUnit%d+ShadowGroupHeaderUnitButton%d+",
    "InvenUnitFrames_TargetTargetTarget",
  },
  returnAll = false,
}

local IterateGroupMembers = function(reversed, forceParty)
  local unit = (not forceParty and IsInRaid()) and 'raid' or 'party'
  local numGroupMembers = unit == 'party' and GetNumSubgroupMembers() or GetNumGroupMembers()
  local i = reversed and numGroupMembers or (unit == 'party' and 0 or 1)
  return function()
    local ret
    if i == 0 and unit == 'party' then
      ret = 'player'
    elseif i <= numGroupMembers and i > 0 then
      ret = unit .. i
    end
    i = i + (reversed and -1 or 1)
    return ret
  end
end

local unitPetState = {} -- track if unit's pet exists

local GetFramesCacheListener
local function Init(noDelay)
  GetFramesCacheListener = CreateFrame("Frame")
  GetFramesCacheListener:RegisterEvent("PLAYER_REGEN_DISABLED")
  GetFramesCacheListener:RegisterEvent("PLAYER_REGEN_ENABLED")
  GetFramesCacheListener:RegisterEvent("PLAYER_ENTERING_WORLD")
  GetFramesCacheListener:RegisterEvent("GROUP_ROSTER_UPDATE")
  GetFramesCacheListener:RegisterEvent("UNIT_PET")
  GetFramesCacheListener:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
  GetFramesCacheListener:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "GROUP_ROSTER_UPDATE" then
      wipe(unitPetState)
      for member in IterateGroupMembers() do
        unitPetState[member] = UnitExists(member .. "pet") and true or nil
      end
    end
    if event == "UNIT_PET" then
      if not (UnitIsUnit("player", unit) or UnitInParty(unit) or UnitInRaid(unit)) then
        return
      end
      -- skip if unit's pet existance has not changed
      local exists = UnitExists(unit .. "pet") and true or nil
      if unitPetState[unit] == exists then
        return
      else
        unitPetState[unit] = exists
      end
    end
    ScanForUnitFrames(false)
  end)
  ScanForUnitFrames(noDelay)
end

function lib.GetUnitFrame(target, opt)
  if type(GetFramesCacheListener) ~= "table" then
    Init(true)
  end
  opt = opt or {}
  setmetatable(opt, { __index = defaultOptions })

  if not target then
    return
  end

  local ignoredFrames = CopyTable(opt.ignoreFrames)
  if opt.ignorePlayerFrame then
    for _, v in pairs(opt.playerFrames) do
      tinsert(ignoredFrames, v)
    end
  end
  if opt.ignoreTargetFrame then
    for _, v in pairs(opt.targetFrames) do
      tinsert(ignoredFrames, v)
    end
  end
  if opt.ignoreTargettargetFrame then
    for _, v in pairs(opt.targettargetFrames) do
      tinsert(ignoredFrames, v)
    end
  end
  if opt.ignorePartyFrame then
    for _, v in pairs(opt.partyFrames) do
      tinsert(ignoredFrames, v)
    end
  end
  if opt.ignorePartyTargetFrame then
    for _, v in pairs(opt.partyTargetFrames) do
      tinsert(ignoredFrames, v)
    end
  end
  if opt.ignoreFocusFrame then
    for _, v in pairs(opt.focusFrames) do
      tinsert(ignoredFrames, v)
    end
  end
  if opt.ignoreRaidFrame then
    for _, v in pairs(opt.raidFrames) do
      tinsert(ignoredFrames, v)
    end
  end

  local frames = GetUnitFrames(target, ignoredFrames)
  if not frames then
    return
  end

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
  if not unit then
    return
  end
  local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
  if nameplate then
    -- credit to Exality for https://wago.io/explosiveorbs
    if nameplate.unitFrame and nameplate.unitFrame.Health then
      -- elvui
      return nameplate.unitFrame.Health
    elseif nameplate.unitFramePlater and nameplate.unitFramePlater.healthBar then
      -- plater
      return nameplate.unitFramePlater.healthBar
    elseif nameplate.kui and nameplate.kui.HealthBar then
      -- kui
      return nameplate.kui.HealthBar
    elseif nameplate.extended and nameplate.extended.visual and nameplate.extended.visual.healthbar then
      -- tidyplates
      return nameplate.extended.visual.healthbar
    elseif nameplate.TPFrame and nameplate.TPFrame.visual and nameplate.TPFrame.visual.healthbar then
      -- tidyplates: threat plates
      return nameplate.TPFrame.visual.healthbar
    elseif nameplate.unitFrame and nameplate.unitFrame.Health then
      -- bdui nameplates
      return nameplate.unitFrame.Health
    elseif nameplate.ouf and nameplate.ouf.Health then
      -- bdNameplates
      return nameplate.ouf.Health
    elseif nameplate.UnitFrame and nameplate.UnitFrame.healthBar then
      -- default
      return nameplate.UnitFrame.healthBar
    else
      return nameplate
    end
  end
end
