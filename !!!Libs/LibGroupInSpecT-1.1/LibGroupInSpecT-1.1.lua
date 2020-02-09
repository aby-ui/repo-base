-- vim: ts=2 sw=2 ai et fenc=utf8

--[[
-- These events can be registered for using the regular CallbackHandler ways.
--
-- "GroupInSpecT_Update", guid, unit, info
-- "GroupInSpecT_Remove, guid
-- "GroupInSpecT_InspectReady", guid, unit
--
-- Where <info> is a table containing some or all of the following:
--   .guid
--   .name
--   .realm
--   .race
--   .race_localized
--   .class
--   .class_localized
--   .class_id
--   .gender -- 2 = male, 3 = female
--   .global_spec_id
--   .spec_index
--   .spec_name_localized
--   .spec_description
--   .spec_icon
--   .spec_background
--   .spec_role
--   .spec_role_detailed
--   .spec_group -- active spec group (1/2/nil)
--   .talents = {
--     [<talent_id>] = {
--       .tier
--       .column
--       .name_localized
--       .icon
--       .talent_id
--       .spell_id
--     }
--     ...
--   }
--   .lku -- last known unit id
--   .not_visible
--
-- Functions for external use:
--
--   lib:Rescan (guid or nil)
--     Force a rescan of the given group member GUID, or of all current group members if nil.
--
--   lib:QueuedInspections ()
--     Returns an array of GUIDs of outstanding inspects.
--
--   lib:StaleInspections ()
--     Returns an array of GUIDs for which the data has become stale and is
--     awaiting an update (no action required, the refresh happens internally).
--     Due to Blizzard exposing no events on (re/un)talent, there will be
--     frequent marking of inspect data as being stale.
--
--   lib:GetCachedInfo (guid)
--     Returns the cached info for the given GUID, if available, nil otherwise.
--     Information is cached for current group members only.
--
--   lib:GroupUnits ()
--     Returns an array with the set of unit ids for the current group.
--]]

local MAJOR, MINOR = "LibGroupInSpecT-1.1", 90

if not LibStub then error(MAJOR.." requires LibStub") end
local lib = LibStub:NewLibrary (MAJOR, MINOR)
if not lib then return end

lib.events = lib.events or LibStub ("CallbackHandler-1.0"):New (lib)
if not lib.events then error(MAJOR.." requires CallbackHandler") end


local UPDATE_EVENT = "GroupInSpecT_Update"
local REMOVE_EVENT = "GroupInSpecT_Remove"
local INSPECT_READY_EVENT = "GroupInSpecT_InspectReady"
local QUEUE_EVENT = "GroupInSpecT_QueueChanged"

local COMMS_PREFIX = "LGIST11"
local COMMS_FMT = "1"
local COMMS_DELIM = "\a"

local INSPECT_DELAY = 1.5
local INSPECT_TIMEOUT = 10 -- If we get no notification within 10s, give up on unit

local MAX_ATTEMPTS = 2

--[===[@debug@
lib.debug = false
local function debug (...)
  if lib.debug then  -- allow programmatic override of debug output by client addons
    print (...) 
  end
end
--@end-debug@]===]

function lib.events:OnUsed(target, eventname)
  if eventname == INSPECT_READY_EVENT then
    target.inspect_ready_used = true
  end
end

function lib.events:OnUnused(target, eventname)
  if eventname == INSPECT_READY_EVENT then
    target.inspect_ready_used = nil
  end
end

-- Frame for events
local frame = _G[MAJOR .. "_Frame"] or CreateFrame ("Frame", MAJOR .. "_Frame")
lib.frame = frame
frame:Hide()
frame:UnregisterAllEvents ()
frame:RegisterEvent ("PLAYER_LOGIN")
frame:RegisterEvent ("PLAYER_LOGOUT")
if not frame.OnEvent then
  frame.OnEvent = function(this, event, ...)
    local eventhandler = lib[event]
    return eventhandler and eventhandler (lib, ...)
  end
  frame:SetScript ("OnEvent", frame.OnEvent)
end


-- Hide our run-state in an easy-to-dump object
lib.state = {
  mainq = {}, staleq = {}, -- inspect queues
  t = 0,
  last_inspect = 0,
  current_guid = nil,
  throttle = 0,
  tt = 0,
  debounce_send_update = 0,
}
lib.cache = {}
lib.static_cache = {}


-- Note: if we cache NotifyInspect, we have to hook before we cache it!
if not lib.hooked then
  hooksecurefunc("NotifyInspect", function (...) return lib:NotifyInspect (...) end)
  lib.hooked = true
end
function lib:NotifyInspect(unit)
  self.state.last_inspect = GetTime()
end


-- Get local handles on the key API functions
local CanInspect                      = _G.CanInspect
local ClearInspectPlayer              = _G.ClearInspectPlayer
local GetClassInfo                    = _G.GetClassInfo
local GetNumSubgroupMembers           = _G.GetNumSubgroupMembers
local GetNumSpecializationsForClassID = _G.GetNumSpecializationsForClassID
local GetPlayerInfoByGUID             = _G.GetPlayerInfoByGUID
local GetInspectSpecialization        = _G.GetInspectSpecialization
local GetSpecialization               = _G.GetSpecialization
local GetSpecializationInfo           = _G.GetSpecializationInfo
local GetSpecializationInfoForClassID = _G.GetSpecializationInfoForClassID
local GetSpecializationRoleByID       = _G.GetSpecializationRoleByID
local GetSpellInfo                    = _G.GetSpellInfo
local GetTalentInfo                   = _G.GetTalentInfo
local IsInRaid                        = _G.IsInRaid
--local NotifyInspect                   = _G.NotifyInspect -- Don't cache, as to avoid missing future hooks
local GetNumClasses                   = _G.GetNumClasses
local UnitExists                      = _G.UnitExists
local UnitGUID                        = _G.UnitGUID
local UnitInParty                     = _G.UnitInParty
local UnitInRaid                      = _G.UnitInRaid
local UnitIsConnected                 = _G.UnitIsConnected
local UnitIsPlayer                    = _G.UnitIsPlayer
local UnitIsUnit                      = _G.UnitIsUnit
local UnitName                        = _G.UnitName
local SendAddonMessage                = C_ChatInfo and C_ChatInfo.SendAddonMessage or SendAddonMessage -- XXX 8.0 compat


local global_spec_id_roles_detailed = {
  -- Death Knight
  [250] = "tank", -- Blood
  [251] = "melee", -- Frost
  [252] = "melee", -- Unholy
  -- Demon Hunter
  [577] = "melee", -- Havoc
  [581] = "tank", -- Vengeance
  -- Druid
  [102] = "ranged", -- Balance
  [103] = "melee", -- Feral
  [104] = "tank", -- Guardian
  [105] = "healer", -- Restoration
  -- Hunter
  [253] = "ranged", -- Beast Mastery
  [254] = "ranged", -- Marksmanship
  [255] = "melee", -- Survival
  -- Mage
  [62] = "ranged", -- Arcane
  [63] = "ranged", -- Fire
  [64] = "ranged", -- Frost
  -- Monk
  [268] = "tank", -- Brewmaster
  [269] = "melee", -- Windwalker
  [270] = "healer", -- Mistweaver
  -- Paladin
  [65] = "healer", -- Holy
  [66] = "tank", -- Protection
  [70] = "melee", -- Retribution
  -- Priest
  [256] = "healer", -- Discipline
  [257] = "healer", -- Holy
  [258] = "ranged", -- Shadow
  -- Rogue
  [259] = "melee", -- Assassination
  [260] = "melee", -- Combat
  [261] = "melee", -- Subtlety
  -- Shaman
  [262] = "ranged", -- Elemental
  [263] = "melee", -- Enhancement
  [264] = "healer", -- Restoration
  -- Warlock
  [265] = "ranged", -- Affliction
  [266] = "ranged", -- Demonology
  [267] = "ranged", -- Destruction
  -- Warrior
  [71] = "melee", -- Arms
  [72] = "melee", -- Fury
  [73] = "tank", -- Protection
}

local class_fixed_roles = {
  HUNTER = "DAMAGER",
  MAGE = "DAMAGER",
  ROGUE = "DAMAGER",
  WARLOCK = "DAMAGER",
}

local class_fixed_roles_detailed = {
  MAGE = "ranged",
  ROGUE = "melee",
  WARLOCK = "ranged",
}

-- Inspects only work after being fully logged in, so track that
function lib:PLAYER_LOGIN ()
  self.state.logged_in = true

  self:CacheGameData ()

  frame:RegisterEvent ("INSPECT_READY")
  frame:RegisterEvent ("GROUP_ROSTER_UPDATE")
  frame:RegisterEvent ("PLAYER_ENTERING_WORLD")
  frame:RegisterEvent ("UNIT_LEVEL")
  frame:RegisterEvent ("PLAYER_TALENT_UPDATE")
  frame:RegisterEvent ("PLAYER_SPECIALIZATION_CHANGED")
  frame:RegisterEvent ("UNIT_SPELLCAST_SUCCEEDED")
  frame:RegisterEvent ("UNIT_NAME_UPDATE")
  frame:RegisterEvent ("UNIT_AURA")
  frame:RegisterEvent ("CHAT_MSG_ADDON")
  if C_ChatInfo then -- XXX 8.0 compat
    C_ChatInfo.RegisterAddonMessagePrefix (COMMS_PREFIX)
  else
    RegisterAddonMessagePrefix (COMMS_PREFIX)
  end

  local guid = UnitGUID ("player")
  local info = self:BuildInfo ("player")
  self.events:Fire (UPDATE_EVENT, guid, "player", info)
end

function lib:PLAYER_LOGOUT ()
  self.state.logged_in = false
end


-- Simple timer
do
  lib.state.t = 0
  if not frame.OnUpdate then -- ticket #4 if the OnUpdate code every changes we should stop borrowing the existing handler
    frame.OnUpdate = function(this, elapsed)
      lib.state.t = lib.state.t + elapsed
      lib.state.tt = lib.state.tt + elapsed
      if lib.state.t > INSPECT_DELAY then
        lib:ProcessQueues ()
        lib.state.t = 0
      end
      -- Unthrottle, essentially allowing 1 msg every 3 seconds, but with substantial burst capacity
      if lib.state.tt > 3 and lib.state.throttle > 0 then
        lib.state.throttle = lib.state.throttle - 1
        lib.state.tt = 0
      end
      if lib.state.debounce_send_update > 0 then
        local debounce = lib.state.debounce_send_update - elapsed
        lib.state.debounce_send_update = debounce
        if debounce <= 0 then lib:SendLatestSpecData () end
      end
    end
    frame:SetScript("OnUpdate", frame.OnUpdate) -- this is good regardless of the handler check above because otherwise a new anonymous function is created every time the OnUpdate code runs
  end
end


-- Internal library functions

-- Caches to deal with API shortcomings as well as performance
lib.static_cache.global_specs = {}           -- [gspec]         -> { .idx, .name_localized, .description, .icon, .background, .role }
lib.static_cache.class_to_class_id = {}      -- [CLASS]         -> class_id

-- The talents cache can no longer be pre-fetched on login, but is now constructed class-by-class as we inspect people.
-- This probably means we want to only ever access it through the GetCachedTalentInfo() helper function below.
lib.static_cache.talents = {}                -- [talent_id]      -> { .spell_id, .talent_id, .name_localized, .icon, .tier, .column }

-- Dridzt: I'd love another way but none of the GetTalent* functions return spellID, GetTalentLink() and parsing the link gives talentID that's not related to spellID as well
-- A quick tooltip scan is cheap though so elegance aside this is a good workaround considering this only runs once
local tip = CreateFrame ("GameTooltip", MAJOR.."ScanTip", nil, "GameTooltipTemplate")
tip:SetOwner (UIParent, "ANCHOR_NONE")

function lib:GetCachedTalentInfo (class_id, tier, col, group, is_inspect, unit)
  local talents = self.static_cache.talents
  local talent_id, name, icon, sel, avail = GetTalentInfo (tier, col, group, is_inspect, unit)
  if not talent_id or not class_id then
    --[===[@debug@
    debug ("GetCachedTalentInfo("..tostring(class_id)..","..tier..","..col..","..group..","..tostring(is_inspect)..","..tostring(unit)..") returned nil") --@end-debug@]===]
    return {}
  end
  talents[class_id] = talents[class_id] or {}
  local class_talents = talents[class_id]
  if not class_talents[talent_id] then
    tip:ClearLines ()
    tip:SetTalent (talent_id, is_inspect, group)
    local _, _,spell_id = tip:GetSpell ()
    class_talents[talent_id] = {
      spell_id = spell_id,
      talent_id = talent_id,
      name_localized = name,
      icon = icon,
      tier = tier,
      column = col,
    }
  end
  return class_talents[talent_id], sel
end


function lib:CacheGameData ()
  local gspecs = self.static_cache.global_specs
  gspecs[0] = {} -- Handle no-specialization case
  for class_id = 1, GetNumClasses () do
    for idx = 1, GetNumSpecializationsForClassID (class_id) do
      local gspec_id, name, description, icon, background = GetSpecializationInfoForClassID (class_id, idx)
      gspecs[gspec_id] = {}
      local gspec = gspecs[gspec_id]
      gspec.idx = idx
      gspec.name_localized = name
      gspec.description = description
      gspec.icon = icon
      gspec.background = background
      gspec.role = GetSpecializationRoleByID (gspec_id)
    end

    local _, class = GetClassInfo (class_id)
    self.static_cache.class_to_class_id[class] = class_id
  end
end


function lib:GuidToUnit (guid)
  local info = self.cache[guid]
  if info and info.lku and UnitGUID (info.lku) == guid then return info.lku end

  for i,unit in ipairs (self:GroupUnits ()) do
    if UnitExists (unit) and UnitGUID (unit) == guid then
      if info then info.lku = unit end
      return unit
    end
  end
end


function lib:Query (unit)
  if not UnitIsPlayer (unit) then return end -- NPC

  if UnitIsUnit (unit, "player") then
    self.events:Fire (UPDATE_EVENT, UnitGUID("player"), "player", self:BuildInfo ("player"))
    return
  end

  local mainq, staleq = self.state.mainq, self.state.staleq

  local guid = UnitGUID (unit)
  if not mainq[guid] then
    mainq[guid] = 1
    staleq[guid] = nil
    self.frame:Show () -- Start timer if not already running
    self.events:Fire (QUEUE_EVENT)
  end
end


function lib:Refresh (unit)
  local guid = UnitGUID (unit)
  if not guid then return end
  --[===[@debug@
  debug ("Refreshing "..unit) --@end-debug@]===]
  if not self.state.mainq[guid] then
    self.state.staleq[guid] = 1
    self.frame:Show ()
    self.events:Fire (QUEUE_EVENT)
  end
end


function lib:ProcessQueues ()
  if not self.state.logged_in then return end
  if InCombatLockdown () then return end -- Never inspect while in combat
  if UnitIsDead ("player") then return end -- You can't inspect while dead, so don't even try
  if InspectFrame and InspectFrame:IsShown () then return end -- Don't mess with the UI's inspections

  local mainq = self.state.mainq
  local staleq = self.state.staleq

  if not next (mainq) and next(staleq) then
    --[===[@debug@
    debug ("Main queue empty, swapping main and stale queues") --@end-debug@]===]
    self.state.mainq, self.state.staleq = self.state.staleq, self.state.mainq
    mainq, staleq = staleq, mainq
  end

  if (self.state.last_inspect + INSPECT_TIMEOUT) < GetTime () then
    -- If there was an inspect going, it's timed out, so either retry or move it to stale queue
    local guid = self.state.current_guid
    if guid then
      --[===[@debug@
      debug ("Inspect timed out for "..guid) --@end-debug@]===]

      local count = mainq and mainq[guid] or (MAX_ATTEMPTS + 1)
      if not self:GuidToUnit (guid) then
        --[===[@debug@
        debug ("No longer applicable, removing from queues") --@end-debug@]===]
        mainq[guid], staleq[guid] = nil, nil
      elseif count > MAX_ATTEMPTS then
        --[===[@debug@
        debug ("Excessive retries, moving to stale queue") --@end-debug@]===]
        mainq[guid], staleq[guid] = nil, 1
      else
        mainq[guid] = count + 1
      end
      self.state.current_guid = nil
    end
  end

  if self.state.current_guid then return end -- Still waiting on our inspect data

  for guid,count in pairs (mainq) do
    local unit = self:GuidToUnit (guid)
    if not unit then
      --[===[@debug@
      debug ("No longer applicable, removing from queues") --@end-debug@]===]
      mainq[guid], staleq[guid] = nil, nil
    elseif not CanInspect (unit) or not UnitIsConnected (unit) then
      --[===[@debug@
      debug ("Cannot inspect "..unit..", aka "..(UnitName(unit) or "nil")..", moving to stale queue") --@end-debug@]===]
      mainq[guid], staleq[guid] = nil, 1
    else
      --[===[@debug@
      debug ("Inspecting "..unit..", aka "..(UnitName(unit) or "nil")) --@end-debug@]===]
      mainq[guid] = count + 1
      self.state.current_guid = guid
      NotifyInspect (unit)
      break
    end
  end

  if not next (mainq) and not next (staleq) and self.state.throttle == 0 and self.state.debounce_send_update <= 0 then
    frame:Hide() -- Cancel timer, nothing queued and no unthrottling to be done
  end
  self.events:Fire (QUEUE_EVENT)
end


function lib:UpdatePlayerInfo (guid, unit, info)
  info.class_localized, info.class, info.race_localized, info.race, info.gender, info.name, info.realm = GetPlayerInfoByGUID (guid)
  local class = info.class
  if info.realm and info.realm == "" then info.realm = nil end
  info.class_id = class and self.static_cache.class_to_class_id[class]
  if not info.spec_role then info.spec_role = class and class_fixed_roles[class] end
  if not info.spec_role_detailed then info.spec_role_detailed = class and class_fixed_roles_detailed[class] end
  info.lku = unit
end


function lib:BuildInfo (unit)
  local guid = UnitGUID (unit)
  if not guid then return end

  local cache = self.cache
  local info = cache[guid] or {}
  cache[guid] = info
  info.guid = guid

  self:UpdatePlayerInfo (guid, unit, info)
  -- On a cold login, GetPlayerInfoByGUID() doesn't seem to be usable, so mark as stale
  local class = info.class
  if not class and not self.state.mainq[guid] then
    self.state.staleq[guid] = 1
    self.frame:Show ()
    self.events:Fire (QUEUE_EVENT)
  end

  local is_inspect = not UnitIsUnit (unit, "player")
  local spec = GetSpecialization ()
  info.global_spec_id = is_inspect and GetInspectSpecialization (unit) or spec and GetSpecializationInfo (spec)

  local gspecs = self.static_cache.global_specs
  if not info.global_spec_id or not gspecs[info.global_spec_id] then -- not a valid spec_id
    info.global_spec_id = nil
  else
    local gspec_id = info.global_spec_id
    local spec_info = gspecs[gspec_id]
    info.spec_index          = spec_info.idx
    info.spec_name_localized = spec_info.name_localized
    info.spec_description    = spec_info.description
    info.spec_icon           = spec_info.icon
    info.spec_background     = spec_info.background
    info.spec_role           = spec_info.role
    info.spec_role_detailed  = global_spec_id_roles_detailed[gspec_id]
  end

  if not info.spec_role then info.spec_role = class and class_fixed_roles[class] end
  if not info.spec_role_detailed then info.spec_role_detailed = class and class_fixed_roles_detailed[class] end

  info.talents = info.talents or {}

  -- If GetPlayerInfoByGUID didn't return the class, we can't do talents yet
  if info.class_id then
    info.spec_group = GetActiveSpecGroup (is_inspect)
    wipe (info.talents) -- Due to spec-specific talents we might leave things in on a spec-change otherwise
    for tier = 1, MAX_TALENT_TIERS do
      for col = 1, NUM_TALENT_COLUMNS do
        local talent, sel = self:GetCachedTalentInfo (info.class_id, tier, col, info.spec_group, is_inspect, unit)
        if talent and talent.talent_id and sel then
          info.talents[talent.talent_id] = talent
        end
      end
    end
  end

  info.glyphs = wipe (info.glyphs or {}) -- kept for addons that still refer to this

  if is_inspect and not UnitIsVisible (unit) and UnitIsConnected (unit) then info.not_visible = true end

  return info
end


function lib:INSPECT_READY (guid)
  local unit = self:GuidToUnit (guid)
  local finalize = false
  if unit then
    if guid == self.state.current_guid then
      self.state.current_guid = nil -- Got what we asked for
      finalize = true
      --[===[@debug@
      debug ("Got inspection data for requested guid "..guid) --@end-debug@]===]
    end

    local mainq, staleq = self.state.mainq, self.state.staleq
    mainq[guid], staleq[guid] = nil, nil

    local gspec_id = GetInspectSpecialization (unit)
    if not self.static_cache.global_specs[gspec_id] then -- Bah, got garbage, flag as stale and try again
      staleq[guid] = 1
      return
    end

    self.events:Fire (UPDATE_EVENT, guid, unit, self:BuildInfo (unit))
    self.events:Fire (INSPECT_READY_EVENT, guid, unit)
  end
  if finalize then
    ClearInspectPlayer ()
  end
  self.events:Fire (QUEUE_EVENT)
end


function lib:PLAYER_ENTERING_WORLD ()
  if self.commScope == "INSTANCE_CHAT" then
    -- Handle moving directly from one LFG to another
    self.commScope = nil
    self:UpdateCommScope ()
  end
end


-- Group handling parts

local members = {}
function lib:GROUP_ROSTER_UPDATE ()
  local group = self.cache
  local units = self:GroupUnits ()
  -- Find new members
  for i,unit in ipairs (self:GroupUnits ()) do
    local guid = UnitGUID (unit)
    if guid then
      members[guid] = true
      if not group[guid] then
        self:Query (unit)
        -- Update with what we have so far (guid, unit, name/class/race?)
        self.events:Fire (UPDATE_EVENT, guid, unit, self:BuildInfo (unit))
      end
    end
  end
  -- Find removed members
  for guid in pairs (group) do
    if not members[guid] then
      group[guid] = nil
      self.events:Fire (REMOVE_EVENT, guid, nil)
    end
  end
  wipe (members)
  self:UpdateCommScope ()
end


function lib:DoPlayerUpdate ()
  self:Query ("player")
  self.state.debounce_send_update = 2.5 -- Hold off 2.5sec before sending update
  self.frame:Show ()
end


function lib:SendLatestSpecData ()
  local scope = self.commScope
  if not scope then return end

  local guid = UnitGUID ("player")
  local info = self.cache[guid]
  if not info then return end

  -- fmt, guid, global_spec_id, talent1 -> MAX_TALENT_TIERS
  -- sequentially, allow no gaps for missing talents we decode by index on the receiving end.
  local datastr = COMMS_FMT..COMMS_DELIM..guid..COMMS_DELIM..(info.global_spec_id or 0)
  local talentCount = 1
  for k in pairs(info.talents) do
    datastr = datastr..COMMS_DELIM..k
    talentCount = talentCount + 1
  end
  for i=talentCount,MAX_TALENT_TIERS do
    datastr = datastr..COMMS_DELIM..0
  end

  --[===[@debug@
  debug ("Sending LGIST update to "..scope) --@end-debug@]===]
  SendAddonMessage(COMMS_PREFIX, datastr, scope)
end


function lib:UpdateCommScope ()
  local scope = (IsInGroup (LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or (IsInRaid () and "RAID") or (IsInGroup (LE_PARTY_CATEGORY_HOME) and "PARTY")
  if self.commScope ~= scope then
    self.commScope = scope
    self:DoPlayerUpdate ()
  end
end


-- Indicies for various parts of the split data msg
local msg_idx = {}
msg_idx.fmt            = 1
msg_idx.guid           = msg_idx.fmt + 1
msg_idx.global_spec_id = msg_idx.guid + 1
msg_idx.talents        = msg_idx.global_spec_id + 1
msg_idx.end_talents    = msg_idx.talents + MAX_TALENT_TIERS - 1

function lib:CHAT_MSG_ADDON (prefix, datastr, scope, sender)
  if prefix ~= COMMS_PREFIX or scope ~= self.commScope then return end
  --[===[@debug@
  debug ("Incoming LGIST update from "..(scope or "nil").."/"..(sender or "nil")..": "..(datastr:gsub(COMMS_DELIM,";") or "nil")) --@end-debug@]===]

  local data = { strsplit (COMMS_DELIM,datastr) }
  local fmt = data[msg_idx.fmt]
  if fmt ~= COMMS_FMT then return end -- Unknown format, ignore

  local guid = data[msg_idx.guid]

  local senderguid = UnitGUID(sender)
  if senderguid and senderguid ~= guid then return end

  local info = guid and self.cache[guid]
  if not info then return end -- Never allow random message to create new group member entries!

  local unit = self:GuidToUnit (guid)
  if not unit then return end
  if UnitIsUnit (unit, "player") then return end -- we're already up-to-date, comment out for solo debugging

  self.state.throttle = self.state.throttle + 1
  self.frame:Show () -- Ensure we're unthrottling
  if self.state.throttle > 40 then return end -- If we ever hit this, someone's being "funny"

  info.class_localized, info.class, info.race_localized, info.race, info.gender, info.name, info.realm = GetPlayerInfoByGUID (guid)
  if info.realm and info.realm == "" then info.realm = nil end
  info.class_id = self.static_cache.class_to_class_id[info.class]

  local gspecs = self.static_cache.global_specs

  local gspec_id           = data[msg_idx.global_spec_id] and tonumber (data[msg_idx.global_spec_id])
  if not gspec_id or not gspecs[gspec_id] then return end -- Malformed message, avoid throwing errors by using this nil

  info.global_spec_id      = gspec_id
  info.spec_index          = gspecs[gspec_id].idx
  info.spec_name_localized = gspecs[gspec_id].name_localized
  info.spec_description    = gspecs[gspec_id].description
  info.spec_icon           = gspecs[gspec_id].icon
  info.spec_background     = gspecs[gspec_id].background
  info.spec_role           = gspecs[gspec_id].role
  info.spec_role_detailed  = global_spec_id_roles_detailed[gspec_id]

  local need_inspect = nil
  info.talents = wipe (info.talents or {})
  local talents = self.static_cache.talents[info.class_id]
  if talents then -- The group entry is created before we have inspect-data, so may not have cached talents yet
    for i = msg_idx.talents, msg_idx.end_talents do
      local talent_id = tonumber (data[i])
      if talent_id and talent_id > 0 then
        if talents[talent_id] then
          info.talents[talent_id] = talents[talent_id]
        else
          -- While we had some talents for this class, we apparently didn't have all for this particular spec, so mark for inspect
          need_inspect = 1
        end
      end
    end
  else
    -- Talents weren't pre-cached, so mark for inspect
    need_inspect = 1
  end

  info.glyphs = wipe (info.glyphs or {}) -- kept for addons that still refer to this

  local mainq, staleq = self.state.mainq, self.state.staleq
  local want_inspect = not need_inspect and self.inspect_ready_used and (mainq[guid] or staleq[guid]) and 1 or nil
  mainq[guid], staleq[guid] = need_inspect, want_inspect
  if need_inspect or want_inspect then self.frame:Show () end

  --[===[@debug@
  debug ("Firing LGIST update event for unit "..unit..", GUID "..guid) --@end-debug@]===]
  self.events:Fire (UPDATE_EVENT, guid, unit, info)
  self.events:Fire (QUEUE_EVENT)
end


function lib:UNIT_LEVEL (unit)
  if UnitInRaid (unit) or UnitInParty (unit) then
    self:Refresh (unit)
  end
  if UnitIsUnit (unit, "player") then
    self:DoPlayerUpdate ()
  end
end


function lib:PLAYER_TALENT_UPDATE ()
  self:DoPlayerUpdate ()
end


function lib:PLAYER_SPECIALIZATION_CHANGED (unit)
--  This event seems to fire a lot, and for no particular reason *sigh*
--  if UnitInRaid (unit) or UnitInParty (unit) then
--    self:Refresh (unit)
--  end
  if unit and UnitIsUnit (unit, "player") then
    self:DoPlayerUpdate ()
  end
end


function lib:UNIT_NAME_UPDATE (unit)
  local group = self.cache
  local guid = UnitGUID (unit)
  local info = guid and group[guid]
  if info then
    self:UpdatePlayerInfo (guid, unit, info)
    if info.name ~= UNKNOWN then
      self.events:Fire (UPDATE_EVENT, guid, unit, info)
    end
  end
end


-- Always get a UNIT_AURA when a unit's UnitIsVisible() changes
function lib:UNIT_AURA (unit)
  local group = self.cache
  local guid = UnitGUID (unit)
  local info = guid and group[guid]
  if info then
    if not UnitIsUnit (unit, "player") then
      if UnitIsVisible (unit) then
        if info.not_visible then
          info.not_visible = nil
          --[===[@debug@
          debug (unit..", aka "..(UnitName(unit) or "nil")..", is now visible") --@end-debug@]===]
          if not self.state.mainq[guid] then
            self.state.staleq[guid] = 1
            self.frame:Show ()
            self.events:Fire (QUEUE_EVENT)
          end
        end
      elseif UnitIsConnected (unit) then
        --[===[@debug@
        if not info.not_visible then
          debug (unit..", aka "..(UnitName(unit) or "nil")..", is no longer visible")
        end
        --@end-debug@]===]
        info.not_visible = true
      end
    end
  end
end


function lib:UNIT_SPELLCAST_SUCCEEDED (unit, spellname, rank, lineid, spellid)
  if spellid == 200749 then
    self:Query (unit) -- Definitely changed, so high prio refresh
  end
end


-- External library functions

function lib:QueuedInspections ()
  local q = {}
  for guid in pairs (self.state.mainq) do
    table.insert (q, guid)
  end
  return q
end


function lib:StaleInspections ()
  local q = {}
  for guid in pairs (self.state.staleq) do
    table.insert (q, guid)
  end
  return q
end


function lib:IsInspectQueued (guid)
  return guid and ((self.state.mainq[guid] or self.state.staleq[guid]) and true)
end


function lib:GetCachedInfo (guid)
  local group = self.cache
  return guid and group[guid]
end


function lib:Rescan (guid)
  local mainq, staleq = self.state.mainq, self.state.staleq
  if guid then
    local unit = self:GuidToUnit (guid)
    if unit then
      if UnitIsUnit (unit, "player") then
        self.events:Fire (UPDATE_EVENT, guid, "player", self:BuildInfo ("player"))
      elseif not mainq[guid] then
        staleq[guid] = 1
      end
    end
  else
    for i,unit in ipairs (self:GroupUnits ()) do
      if UnitExists (unit) then
        if UnitIsUnit (unit, "player") then
          self.events:Fire (UPDATE_EVENT, UnitGUID("player"), "player", self:BuildInfo ("player"))
        else
          local guid = UnitGUID (unit)
          if guid and not mainq[guid] then
            staleq[guid] = 1
          end
        end
      end
    end
  end
  self.frame:Show () -- Start timer if not already running

  -- Evict any stale entries
  self:GROUP_ROSTER_UPDATE ()
  self.events:Fire (QUEUE_EVENT)
end


local unitstrings = {
  raid = { "player" }, -- This seems to be needed under certain circumstances. Odd.
  party = { "player" }, -- Player not part of partyN
  player = { "player" }
}
for i = 1,40 do table.insert (unitstrings.raid, "raid"..i) end
for i = 1,4  do table.insert (unitstrings.party, "party"..i) end


-- Returns an array with the set of unit ids for the current group
function lib:GroupUnits ()
  local units
  if IsInRaid () then
    units = unitstrings.raid
  elseif GetNumSubgroupMembers () > 0 then
    units = unitstrings.party
  else
    units = unitstrings.player
  end
  return units
end


-- If demand-loaded, we need to synthesize a login event
if IsLoggedIn () then lib:PLAYER_LOGIN () end
