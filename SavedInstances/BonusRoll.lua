local _, addon = ...
local BonusRollModule = addon.core:NewModule("BonusRoll", "AceEvent-3.0")
local thisToon = UnitName("player") .. " - " .. GetRealmName()

local BonusFrame -- Frame attached to BonusRollFrame
local MAX_BONUS_ROLL_RECORD_LIMIT = 25 -- the max cap of bonus roll records
local BONUS_ROLL_REQUIRED_CURRENCY = 1580 -- bonus roll currency of current expansion
local ignoreItem = {
  [163827] = true, -- Quartermaster's Coin, obtained when failing a bonus roll in pvp
}

-- Lua functions
local tostring, ipairs, time, pairs, strsplit = tostring, ipairs, time, pairs, strsplit
local tonumber, tinsert, sort, select = tonumber, tinsert, sort, select
local _G = _G

-- WoW API / Variables
local CreateFrame = CreateFrame
local GetBonusRollEncounterJournalLinkDifficulty = GetBonusRollEncounterJournalLinkDifficulty
local GetDifficultyInfo = GetDifficultyInfo
local GetInstanceInfo = GetInstanceInfo
local GetItemInfoInstant = GetItemInfoInstant
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local DIFFICULTY_DUNGEON_CHALLENGE = DIFFICULTY_DUNGEON_CHALLENGE

local function BonusRollShow()
  local t = addon.db.Toons[thisToon]
  local BonusRollFrame = _G.BonusRollFrame
  if not t or not BonusRollFrame then return end
  local bonus = addon:BonusRollCount(thisToon, BonusRollFrame.CurrentCountFrame.currencyID)
  if not bonus or not addon.db.Tooltip.AugmentBonus then
    if BonusFrame then BonusFrame:Hide() end
    return
  end
  if not BonusFrame then
    BonusFrame = CreateFrame("Button", "SavedInstancesBonusRollFrame", BonusRollFrame, "SpellBookSkillLineTabTemplate")
    BonusFrame:SetPoint("LEFT", BonusRollFrame, "RIGHT", 0, 8)
    BonusFrame.text = BonusFrame:CreateFontString(nil, "OVERLAY","GameFontNormal")
    BonusFrame.text:SetPoint("CENTER")
    BonusFrame:SetScript("OnEnter", function()
      addon.hoverTooltip.ShowBonusTooltip(nil, { thisToon, BonusFrame })
    end)
    BonusFrame:SetScript("OnLeave", function()
      if addon.indicatortip then
        addon.indicatortip:Hide()
      end
    end)
    BonusFrame:SetScript("OnClick", nil)
    BonusFrame.text:Show()
  end
  BonusFrame.text:SetText((bonus > 0 and "+" or "")..bonus)
  BonusFrame:Show()
end
hooksecurefunc("BonusRollFrame_StartBonusRoll", BonusRollShow)

function BonusRollModule:OnEnable()
  BonusRollShow() -- catch roll-on-load
  self:RegisterEvent("BONUS_ROLL_RESULT")
  self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function BonusRollModule:CHAT_MSG_MONSTER_YELL(event, msg, bossname)
  -- cheapest possible outdoor boss detection for players lacking a proper boss mod
  -- should work for sha and nalak, oon and gal report a related mob
  local t = addon.db.Toons[thisToon]
  local now = time()
  if bossname and t then
    bossname = tostring(bossname) -- for safety
    local diff = select(4,GetInstanceInfo())
    if diff and #diff > 0 then bossname = bossname .. ": ".. diff end
    t.lastbossyell = bossname
    t.lastbossyelltime = now
    -- addon.debug("CHAT_MSG_MONSTER_YELL: "..tostring(bossname));
  end
end

function BonusRollModule:BONUS_ROLL_RESULT(event, rewardType, rewardLink, rewardQuantity, rewardSpecID, _, _, currencyID)
  local t = addon.db.Toons[thisToon]
  addon.debug("BONUS_ROLL_RESULT:%s:%s:%s:%s (boss=%s|%s)",
    tostring(rewardType), tostring(rewardLink), tostring(rewardQuantity), tostring(rewardSpecID),
    tostring(t and t.lastboss), tostring(t and t.lastbossyell))
  if not t then return end
  if not rewardType then return end -- sometimes get a bogus message, ignore it
  t.BonusRoll = t.BonusRoll or {}
  local now = time()
  local bossname
  -- Mythic+ Dungeon Roll
  if GetBonusRollEncounterJournalLinkDifficulty() == DIFFICULTY_DUNGEON_CHALLENGE then
    local name, _, difficultyID, difficultyName = GetInstanceInfo()
    if difficultyID == DIFFICULTY_DUNGEON_CHALLENGE then
      bossname = name .. ": " .. difficultyName
    else
      local tmp = {}
      for key, value in pairs(addon.db.History) do
        local _, name, _, diff = strsplit(":", key)
        if tonumber(diff) == DIFFICULTY_DUNGEON_CHALLENGE then
          local tbl = {
            name = name .. ": " .. GetDifficultyInfo(diff),
            last = value.last,
          }
          tinsert(tmp, tbl)
        end
      end
      sort(tmp, function(l, r) return l.last > r.last end)
      bossname = tmp[1] and tmp[1].name
    end
  end
  if not bossname then
    bossname = t.lastboss
    if now > (t.lastbosstime or 0) + 3*60 then
      -- user rolled before lastboss was updated, ignore the stale one. Roll timeout is 3 min.
      bossname = nil
    end
    if not bossname and t.lastbossyell and now < (t.lastbossyelltime or 0) + 10*60 then
      bossname = t.lastbossyell -- yell fallback
    end
    if not bossname then
      bossname = GetSubZoneText() or GetRealZoneText() -- zone fallback
    end
  end
  local roll = {
    name = bossname,
    time = now,
    costCurrencyID = _G.BonusRollFrame.CurrentCountFrame.currencyID,
  }
  if rewardType == "money" then
    roll.money = rewardQuantity
  elseif rewardType == "currency" then
    roll.currencyID = currencyID
    roll.money = rewardQuantity
  elseif rewardType == "item" then
    roll.item = rewardLink
  end
  tinsert(t.BonusRoll, 1, roll)
  for i = MAX_BONUS_ROLL_RECORD_LIMIT + 1, #t.BonusRoll do
    t.BonusRoll[i] = nil
  end
end

function addon:BonusRollCount(toon, currencyID)
  local t = addon.db.Toons[toon]
  if not t or not t.BonusRoll or #t.BonusRoll == 0 then return end
  currencyID = currencyID or BONUS_ROLL_REQUIRED_CURRENCY
  local count = 0
  for _, tbl in ipairs(t.BonusRoll) do
    if not tbl.costCurrencyID then break end
    if tbl.costCurrencyID == currencyID then
      if not tbl.item then
        count = count + 1
      else
        local itemID = GetItemInfoInstant(tbl.item)
        if ignoreItem[itemID] then
          count = count + 1
        else
          break
        end
      end
    end
  end
  return count
end

function addon:BossRecord(toon, bossname, difficultyID, soft)
  local t = addon.db.Toons[toon]
  if not t then return end
  local now = time()
  -- boss mods can often detect completion before ENCOUNTER_END
  -- also some world bosses never send ENCOUNTER_END
  -- enough timeout to prevent overwriting, but short enough to prevent cross-boss contamination
  if soft and soft == false and (not bossname or now <= (t.lastbosstime or 0) + 120) then return end
  bossname = tostring(bossname) -- for safety
  local difficultyName = GetDifficultyInfo(difficultyID)
  if difficultyName and #difficultyName > 0 then
    bossname = bossname .. ": ".. difficultyName
  end
  t.lastboss = bossname
  t.lastbosstime = now
end
