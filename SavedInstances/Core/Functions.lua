local SI, L = unpack(select(2, ...))

-- Lua functions
local _G = _G
local format, strmatch, strupper = format, strmatch, strupper

-- WoW API / Variables
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_UnitAuras_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local GetCurrentRegion = GetCurrentRegion
local GetCVar = GetCVar
local GetTime = GetTime

function SI:GetPlayerAuraExpirationTime(spellID)
  local info = C_UnitAuras_GetPlayerAuraBySpellID(spellID)
  return info and info.expirationTime
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
