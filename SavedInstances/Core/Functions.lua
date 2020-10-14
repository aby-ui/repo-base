local SI, L = unpack(select(2, ...))

-- Lua functions
local _G = _G
local format, strmatch, strupper = format, strmatch, strupper

-- WoW API / Variables
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetCurrentRegion = GetCurrentRegion
local GetCVar = GetCVar
local GetTime = GetTime
local UnitAura = UnitAura

-- UnitAura/UnitBuff/UnitDebuff fix for Patch 8.0
-- Get these functions from WeakAuras 2
function SI:GetUnitAura(unit, spell, filter)
  if filter and not filter:upper():find('FUL') then
    filter = filter .. '|HELPFUL'
  end
  for i = 1, 255 do
    local name, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, filter)
    if not name then return end
    if spell == spellId or spell == name then
      return UnitAura(unit, i, filter)
    end
  end
end

function SI:GetUnitBuff(unit, spell, filter)
  filter = filter and filter .. '|HELPFUL' or 'HELPFUL'
  return SI:GetUnitAura(unit, spell, filter)
end

function SI:GetUnitDebuff(unit, spell, filter)
  filter = filter and filter .. '|HARMFUL' or 'HARMFUL'
  return SI:GetUnitAura(unit, spell, filter)
end

-- Chat Message and Bug Report Reminder
function SI:ChatMsg(...)
  _G.DEFAULT_CHAT_FRAME:AddMessage('|cFFFF0000SavedInstances|r: ' .. format(...))
end

do
  local bugReported = {}
  function SI:BugReport(msg)
    local now = GetTime()
    if bugReported[msg] and now < bugReported[msg] + 60 then return end
    bugReported[msg] = now
    SI:ChatMsg(msg)

    if bugReported['url'] and now < bugReported['url'] + 5 then return end
    bugReported['url'] = now
    SI:ChatMsg("Please report this bug at: https://github.com/SavedInstances/SavedInstances/issues")
  end
end

-- Get Region
do
  local region
  function SI:GetRegion()
    if not region then
      local portal = GetCVar('portal')
      if portal == 'public-test' then
        -- PTR uses US region resets, despite the misleading realm name suffix
        portal = 'US'
      end
      if not portal or #portal ~= 2 then
        local regionID = GetCurrentRegion()
        portal = portal and ({'US', 'KR', 'EU', 'TW', 'CN'})[regionID]
      end
      if not portal or #portal ~= 2 then -- other test realms?
        portal = strmatch(SI.realmName or '', '%((%a%a)%)')
      end
      portal = portal and strupper(portal)
      if portal and #portal == 2 then
        region = portal
      end
    end
    return region
  end
end

-- Get Current uiMapID
function SI:GetCurrentMapAreaID()
  return C_Map_GetBestMapForUnit('player')
end
