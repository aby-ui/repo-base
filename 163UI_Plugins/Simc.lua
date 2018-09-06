-- if select(5, GetAddOnInfo("Simulationcraft")) ~= "MISSING" then return end
local Simulationcraft = {}
CoreUIRegisterSlash('SIMC_LOADER', '/sim', nil, function(...)
    if LoadSimcAddOn then
        LoadSimcAddOn(nil, Simulationcraft);
        LoadSimcAddOn = nil
    end
    Simulationcraft:HandleChatCommand(...)
end)

function LoadSimcAddOn(...)
---- extra.lua
local _, Simulationcraft = ...

Simulationcraft.RoleTable = {
  -- Death Knight
  [250] = 'tank',
  [251] = 'attack',
  [252] = 'attack',
  -- Demon Hunter
  [577] = 'attack',
  [581] = 'tank',
  -- Druid
  [102] = 'spell',
  [103] = 'attack',
  [104] = 'tank',
  [105] = 'attack',
  -- Hunter
  [253] = 'attack',
  [254] = 'attack',
  [255] = 'attack',
  -- Mage
  [62] = 'spell',
  [63] = 'spell',
  [64] = 'spell',
  -- Monk
  [268] = 'tank',
  [269] = 'attack',
  [270] = 'hybrid',
  -- Paladin
  [65] = 'attack',
  [66] = 'tank',
  [70] = 'attack',
  -- Priest
  [256] = 'spell',
  [257] = 'attack',
  [258] = 'spell',
  -- Rogue
  [259] = 'attack',
  [260] = 'attack',
  [261] = 'attack',
  -- Shaman
  [262] = 'spell',
  [263] = 'attack',
  [264] = 'attack',
  -- Warlock
  [265] = 'spell',
  [266] = 'spell',
  [267] = 'spell',
  -- Warrior
  [71] = 'attack',
  [72] = 'attack',
  [73] = 'attack'
}

-- regionID lookup
Simulationcraft.RegionString = {
  [1] = 'us',
  [2] = 'kr',
  [3] = 'eu',
  [4] = 'tw',
  [5] = 'cn'
}

-- non-localized profession names from ids
Simulationcraft.ProfNames = {
  [129] = 'First Aid',
  [164] = 'Blacksmithing',
  [165] = 'Leatherworking',
  [171] = 'Alchemy',
  [182] = 'Herbalism',
  [184] = 'Cooking',
  [186] = 'Mining',
  [197] = 'Tailoring',
  [202] = 'Engineering',
  [333] = 'Enchanting',
  [356] = 'Fishing',
  [393] = 'Skinning',
  [755] = 'Jewelcrafting',
  [773] = 'Inscription',
  [794] = 'Archaeology'
}

-- non-localized spec names from spec ids
Simulationcraft.SpecNames = {
-- Death Knight
  [250] = 'Blood',
  [251] = 'Frost',
  [252] = 'Unholy',
-- Demon Hunter
  [577] = 'Havoc',
  [581] = 'Vengeance',
-- Druid
  [102] = 'Balance',
  [103] = 'Feral',
  [104] = 'Guardian',
  [105] = 'Restoration',
-- Hunter
  [253] = 'Beast Mastery',
  [254] = 'Marksmanship',
  [255] = 'Survival',
-- Mage
  [62] = 'Arcane',
  [63] = 'Fire',
  [64] = 'Frost',
-- Monk
  [268] = 'Brewmaster',
  [269] = 'Windwalker',
  [270] = 'Mistweaver',
-- Paladin
  [65] = 'Holy',
  [66] = 'Protection',
  [70] = 'Retribution',
-- Priest
  [256] = 'Discipline',
  [257] = 'Holy',
  [258] = 'Shadow',
-- Rogue
  [259] = 'Assassination',
  [260] = 'Outlaw',
  [261] = 'Subtlety',
-- Shaman
  [262] = 'Elemental',
  [263] = 'Enhancement',
  [264] = 'Restoration',
-- Warlock
  [265] = 'Affliction',
  [266] = 'Demonology',
  [267] = 'Destruction',
-- Warrior
  [71] = 'Arms',
  [72] = 'Fury',
  [73] = 'Protection'
}

-- slot name conversion stuff

Simulationcraft.slotNames = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "AmmoSlot" };
Simulationcraft.simcSlotNames = {'head','neck','shoulder','back','chest','shirt','tabard','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2','main_hand','off_hand','ammo'}

-- table for conversion to upgrade level, stolen from AMR (<3)

Simulationcraft.upgradeTable = {
  [0]   =  0,
  [1]   =  1, -- 1/1 -> 8
  [373] =  1, -- 1/2 -> 4
  [374] =  2, -- 2/2 -> 8
  [375] =  1, -- 1/3 -> 4
  [376] =  2, -- 2/3 -> 4
  [377] =  3, -- 3/3 -> 4
  [378] =  1, -- 1/1 -> 7
  [379] =  1, -- 1/2 -> 4
  [380] =  2, -- 2/2 -> 4
  [445] =  0, -- 0/2 -> 0
  [446] =  1, -- 1/2 -> 4
  [447] =  2, -- 2/2 -> 8
  [451] =  0, -- 0/1 -> 0
  [452] =  1, -- 1/1 -> 8
  [453] =  0, -- 0/2 -> 0
  [454] =  1, -- 1/2 -> 4
  [455] =  2, -- 2/2 -> 8
  [456] =  0, -- 0/1 -> 0
  [457] =  1, -- 1/1 -> 8
  [458] =  0, -- 0/4 -> 0
  [459] =  1, -- 1/4 -> 4
  [460] =  2, -- 2/4 -> 8
  [461] =  3, -- 3/4 -> 12
  [462] =  4, -- 4/4 -> 16
  [465] =  0, -- 0/2 -> 0
  [466] =  1, -- 1/2 -> 4
  [467] =  2, -- 2/2 -> 8
  [468] =  0, -- 0/4 -> 0
  [469] =  1, -- 1/4 -> 4
  [470] =  2, -- 2/4 -> 8
  [471] =  3, -- 3/4 -> 12
  [472] =  4, -- 4/4 -> 16
  [476] =  0, -- ? -> 0
  [479] =  0, -- ? -> 0
  [491] =  0, -- ? -> 0
  [492] =  1, -- ? -> 0
  [493] =  2, -- ? -> 0
  [494] = 0,
  [495] = 1,
  [496] = 2,
  [497] = 3,
  [498] = 4,
  [504] = 3,
  [505] = 4,
  -- WOW-20726patch6.2.3_Retail
  [529] = 0, -- 0/2 -> 0
  [530] = 1, -- 1/2 -> 5
  [531] = 2 -- 2/2 -> 10
}






---- core.lua
local _, Simulationcraft = ...

Simulationcraft = LibStub("AceAddon-3.0"):NewAddon(Simulationcraft, "SimulationcraftAbyUI", "AceConsole-3.0", "AceEvent-3.0") --aby
local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")
--aby LibRealmInfo = LibStub("LibRealmInfo")

local OFFSET_ITEM_ID = 1
local OFFSET_ENCHANT_ID = 2
local OFFSET_GEM_ID_1 = 3
local OFFSET_GEM_ID_2 = 4
local OFFSET_GEM_ID_3 = 5
local OFFSET_GEM_ID_4 = 6
local OFFSET_GEM_BASE = OFFSET_GEM_ID_1
local OFFSET_SUFFIX_ID = 7
local OFFSET_FLAGS = 11
local OFFSET_CONTEXT = 12
local OFFSET_BONUS_ID = 13
local OFFSET_UPGRADE_ID = 14 -- Flags = 0x4

local SocketInventoryItem   = _G.SocketInventoryItem
local Timer                 = _G.C_Timer
local AzeriteEmpoweredItem  = _G.C_AzeriteEmpoweredItem
local AzeriteItem           = _G.C_AzeriteItem

-- load stuff from extras.lua
local upgradeTable  = Simulationcraft.upgradeTable
local slotNames     = Simulationcraft.slotNames
local simcSlotNames = Simulationcraft.simcSlotNames
local specNames     = Simulationcraft.SpecNames
local profNames     = Simulationcraft.ProfNames
local regionString  = Simulationcraft.RegionString

-- Most of the guts of this addon were based on a variety of other ones, including
-- Statslog, AskMrRobot, and BonusScanner. And a bunch of hacking around with AceGUI.
-- Many thanks to the authors of those addons, and to reia for fixing my awful amateur
-- coding mistakes regarding objects and namespaces.

function Simulationcraft:OnInitialize()
  Simulationcraft:RegisterChatCommand('simc', 'HandleChatCommand')
end

function Simulationcraft:OnEnable()
  SimulationcraftTooltip:SetOwner(_G["UIParent"],"ANCHOR_NONE")
end

function Simulationcraft:OnDisable()

end

function Simulationcraft:HandleChatCommand(input)
  local args = {strsplit(' ', input)}

  local debugOutput = false
  local noBags = false

  for _, arg in ipairs(args) do
    if arg == 'debug' then
      debugOutput = true
    elseif arg == 'nobag' or arg == 'nobags' or arg == 'nb' then
      noBags = true
    end
  end

  self:PrintSimcProfile(debugOutput, noBags)
end

local function GetItemSplit(itemLink)
  local itemString = string.match(itemLink, "item:([%-?%d:]+)")
  local itemSplit = {}

  -- Split data into a table
  for _, v in ipairs({strsplit(":", itemString)}) do
    if v == "" then
      itemSplit[#itemSplit + 1] = 0
    else
      itemSplit[#itemSplit + 1] = tonumber(v)
    end
  end

  return itemSplit
end

-- char size for utf8 strings
local function chsize(char)
  if not char then
      return 0
  elseif char > 240 then
      return 4
  elseif char > 225 then
      return 3
  elseif char > 192 then
      return 2
  else
      return 1
  end
end

-- SimC tokenize function
local function tokenize(str)
  str = str or ""
  -- convert to lowercase and remove spaces
  str = string.lower(str)
  str = string.gsub(str, ' ', '_')

  -- keep stuff we want, dumpster everything else
  local s = ""
  for i=1,str:len() do
    local b = str:byte(i)
    -- keep digits 0-9
    if b >= 48 and b <= 57 then
      s = s .. str:sub(i,i)
      -- keep lowercase letters
    elseif b >= 97 and b <= 122 then
      s = s .. str:sub(i,i)
      -- keep %, +, ., _
    elseif b == 37 or b == 43 or b == 46 or b == 95 then
      s = s .. str:sub(i,i)
      -- save all multibyte chars
    elseif chsize(b) > 1 then
      local offset = chsize(b) - 1
      s = s .. str:sub(i, i + offset)
      i = i + offset
    end
  end
  -- strip trailing spaces
  if string.sub(s, s:len())=='_' then
    s = string.sub(s, 0, s:len()-1)
  end
  return s
end

-- method for constructing the talent string
local function CreateSimcTalentString()
  local talentInfo = {}
  local maxTiers = 7
  local maxColumns = 3
  for tier = 1, maxTiers do
    for column = 1, maxColumns do
      local talentID, name, iconTexture, selected, available = GetTalentInfo(tier, column, GetActiveSpecGroup())
      if selected then
        talentInfo[tier] = column
      end
    end
  end

  local str = 'talents='
  for i = 1, maxTiers do
    if talentInfo[i] then
      str = str .. talentInfo[i]
    else
      str = str .. '0'
    end
  end

  return str
end

-- function that translates between the game's role values and ours
local function translateRole(spec_id, str)
  local spec_role = Simulationcraft.RoleTable[spec_id]
  if spec_role ~= nil then
    return spec_role
  end

  if str == 'TANK' then
    return 'tank'
  elseif str == 'DAMAGER' then
    return 'attack'
  elseif str == 'HEALER' then
    return 'attack'
  else
    return ''
  end
end

-- =================== Item Information =========================
local function GetGemItemID(itemLink, index)
  local _, gemLink = GetItemGem(itemLink, index)
  if gemLink ~= nil then
    local itemIdStr = string.match(gemLink, "item:(%d+)")
    if itemIdStr ~= nil then
      return tonumber(itemIdStr)
    end
  end

  return 0
end

local function GetItemStringFromItemLink(slotNum, itemLink, itemLoc, debugOutput)
  local itemSplit = GetItemSplit(itemLink)
  local simcItemOptions = {}
  local gems = {}

  -- Item id
  local itemId = itemSplit[OFFSET_ITEM_ID]
  simcItemOptions[#simcItemOptions + 1] = ',id=' .. itemId

  -- Enchant
  if itemSplit[OFFSET_ENCHANT_ID] > 0 then
    simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
  end

  -- Gems
  for gemOffset = OFFSET_GEM_ID_1, OFFSET_GEM_ID_4 do
    local gemIndex = (gemOffset - OFFSET_GEM_BASE) + 1
    if itemSplit[gemOffset] > 0 then
      local gemId = GetGemItemID(itemLink, gemIndex)
      if gemId > 0 then
        gems[gemIndex] = gemId
      end
    else
      gems[gemIndex] = 0
    end
  end

  -- Remove any trailing zeros from the gems array
  while #gems > 0 and gems[#gems] == 0 do
    table.remove(gems, #gems)
  end

  if #gems > 0 then
    simcItemOptions[#simcItemOptions + 1] = 'gem_id=' .. table.concat(gems, '/')
  end

  -- New style item suffix, old suffix style not supported
  if itemSplit[OFFSET_SUFFIX_ID] ~= 0 then
    simcItemOptions[#simcItemOptions + 1] = 'suffix=' .. itemSplit[OFFSET_SUFFIX_ID]
  end

  local flags = itemSplit[OFFSET_FLAGS]

  local bonuses = {}

  for index=1, itemSplit[OFFSET_BONUS_ID] do
    bonuses[#bonuses + 1] = itemSplit[OFFSET_BONUS_ID + index]
  end

  if #bonuses > 0 then
    simcItemOptions[#simcItemOptions + 1] = 'bonus_id=' .. table.concat(bonuses, '/')
  end

  local linkOffset = OFFSET_BONUS_ID + #bonuses + 1

  -- Upgrade level
  if bit.band(flags, 0x4) == 0x4 then
    local upgradeId = itemSplit[linkOffset]
    if upgradeTable and upgradeTable[upgradeId] ~= nil and upgradeTable[upgradeId] > 0 then
      simcItemOptions[#simcItemOptions + 1] = 'upgrade=' .. upgradeTable[upgradeId]
    end
    linkOffset = linkOffset + 1
  end

  -- Some leveling quest items seem to use this, it'll include the drop level of the item
  if bit.band(flags, 0x200) == 0x200 then
    simcItemOptions[#simcItemOptions + 1] = 'drop_level=' .. itemSplit[linkOffset]
    linkOffset = linkOffset + 1
  end

  -- Get item creation context. Can be used to determine unlock/availability of azerite tiers for 3rd parties
  -- To reduce issues with SimC, use reforge= for now
  -- context= will be supported by simc soon and we can switch over for 8.1
  if itemSplit[OFFSET_CONTEXT] ~= 0 then
    simcItemOptions[#simcItemOptions + 1] = 'reforge=' .. itemSplit[OFFSET_CONTEXT]
  end

  -- Azerite powers - only run in BfA client
  if itemLoc and AzeriteEmpoweredItem then
    if AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLoc) then
      -- C_AzeriteEmpoweredItem.GetAllTierInfo(ItemLocation:CreateFromEquipmentSlot(5))
      -- C_AzeriteEmpoweredItem.GetPowerInfo(ItemLocation:CreateFromEquipmentSlot(5), 111)
      local azeritePowers = {}
      local powerIndex = 1
      local tierInfo = AzeriteEmpoweredItem.GetAllTierInfo(itemLoc)
      for azeriteTier, tierInfo in pairs(tierInfo) do
        for _, powerId in pairs(tierInfo.azeritePowerIDs) do
          if AzeriteEmpoweredItem.IsPowerSelected(itemLoc, powerId) then
            azeritePowers[powerIndex] = powerId
            powerIndex = powerIndex + 1
          end
        end
      end
      simcItemOptions[#simcItemOptions + 1] = 'azerite_powers=' .. table.concat(azeritePowers, '/')
    end
    if AzeriteItem.IsAzeriteItem(itemLoc) then
      simcItemOptions[#simcItemOptions + 1] = 'azerite_level=' .. AzeriteItem.GetPowerLevel(itemLoc)
    end
  end

  local itemStr = ''
  if debugOutput then
    itemStr = itemStr .. '# ' .. itemString .. '\n'
  end
  itemStr = itemStr .. simcSlotNames[slotNum] .. "=" .. table.concat(simcItemOptions, ',')

  return itemStr
end

function Simulationcraft:GetItemStrings(debugOutput)
  local items = {}
  for slotNum=1, #slotNames do
    local slotId = GetInventorySlotInfo(slotNames[slotNum])
    local itemLink = GetInventoryItemLink('player', slotId)

    -- if we don't have an item link, we don't care
    if itemLink then
      local itemLoc
      if ItemLocation then
        itemLoc = ItemLocation:CreateFromEquipmentSlot(slotId)
      end
      items[slotNum] = GetItemStringFromItemLink(slotNum, itemLink, itemLoc, debugOutput)

    end
  end

  return items
end

function Simulationcraft:GetBagItemStrings()
  local bagItems = {}

  for slotNum=1, #slotNames do
    local slotName = slotNames[slotNum]
    -- Ignore "double" slots, results in doubled output which isn't useful
    if slotName and slotName ~= 'Trinket1Slot' and slotName ~= 'Finger1Slot' then
      local slotItems = {}
      local slotId, _, _ = GetInventorySlotInfo(slotNames[slotNum])
      GetInventoryItemsForSlot(slotId, slotItems)
      for locationBitstring, itemID in pairs(slotItems) do
        local player, bank, bags, voidstorage, slot, bag = EquipmentManager_UnpackLocation(locationBitstring)
        local itemLoc
        if ItemLocation then
          if bag == nil then
            -- this is a default bank slot (not a bank bag). these exist on the character equipment, not a bag
            itemLoc = ItemLocation:CreateFromEquipmentSlot(slot)
          else
            itemLoc = ItemLocation:CreateFromBagAndSlot(bag, slot)
          end
        end
        if bags or bank then
          local container
          if bags then
            container = bag
          elseif bank then
            -- Default bank slots (the innate ones, not ones from bags-in-the-bank) are weird
            -- slot starts at 39, I believe that is based on some older location values
            -- GetContainerItemInfo uses a 0-based slot index
            -- So take the slot from the unpack and subtract 39 to get the right index for GetContainerItemInfo.
            -- 2018/01/17 - Change magic number to 47 to account for new backpack slots. Not sure why it went up by 8
            -- instead of 4, possible blizz is leaving the door open to more expansion in the future?
            container = BANK_CONTAINER
            slot = slot - 47
          end
          _, _, _, _, _, _, itemLink, _, _, itemId = GetContainerItemInfo(container, slot)
          if itemLink then
            local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink)

            -- get correct level for scaling gear
            local level = ItemUpgradeInfo:GetUpgradedItemLevel(link) or 0

            -- find all equippable, non-artifact items
            if IsEquippableItem(itemLink) and quality ~= 6 then
              bagItems[#bagItems + 1] = {
                string = GetItemStringFromItemLink(slotNum, itemLink, itemLoc, false),
                name = name .. ' (' .. level .. ')'
              }
            end
          end
        end
      end
    end
  end

  return bagItems
end

-- This is the workhorse function that constructs the profile
function Simulationcraft:PrintSimcProfile(debugOutput, noBags)
  -- addon metadata
  local versionComment = '# SimC Addon ' .. 'in AbyUI' --aby GetAddOnMetadata('Simulationcraft', 'Version')
  local reforgeWarning = '# 8.0 Note: reforge= is being used as a hacky way to capture item context. This will be changed in 8.1'

  -- Basic player info
  local _, realmName, _, _, _, _, region, _, _, realmLatinName, _ = nil --aby LibRealmInfo:GetRealmInfoByUnit('player')

  local playerName = UnitName('player')
  local _, playerClass = UnitClass('player')
  local playerLevel = UnitLevel('player')

  -- Try Latin name for Russian servers first, then realm name from LibRealmInfo, then Realm Name from the game
  -- Latin name for Russian servers as most APIs use the latin name, not the cyrillic name
  local playerRealm = realmLatinName or realmName or GetRealmName()

  -- Try region from LibRealmInfo first, then use default API
  -- Default API can be wrong for region-switching players
  local playerRegion = region or regionString[GetCurrentRegion()]

  -- Race info
  local _, playerRace = UnitRace('player')
  -- fix some races to match SimC format
  if playerRace == 'BloodElf' then
    playerRace = 'Blood Elf'
  elseif playerRace == 'NightElf' then
    playerRace = 'Night Elf'
  elseif playerRace == 'MagharOrc' then
    playerRace = 'Maghar Orc'
  elseif playerRace == 'DarkIronDwarf' then
    playerRace = 'Dark Iron Dwarf'
  elseif playerRace == 'Scourge' then --lulz
    playerRace = 'Undead'
  end

  -- Spec info
  local role, globalSpecID
  local specId = GetSpecialization()
  if specId then
    globalSpecID,_,_,_,_,role = GetSpecializationInfo(specId)
  end
  local playerSpec = specNames[ globalSpecID ]

  -- Professions
  local pid1, pid2 = GetProfessions()
  local firstProf, firstProfRank, secondProf, secondProfRank, profOneId, profTwoId
  if pid1 then
    _,_,firstProfRank,_,_,_,profOneId = GetProfessionInfo(pid1)
  end
  if pid2 then
    secondProf,_,secondProfRank,_,_,_,profTwoId = GetProfessionInfo(pid2)
  end

  firstProf = profNames[ profOneId ]
  secondProf = profNames[ profTwoId ]

  local playerProfessions = ''
  if pid1 or pid2 then
    playerProfessions = 'professions='
    if pid1 then
      playerProfessions = playerProfessions..tokenize(firstProf)..'='..tostring(firstProfRank)..'/'
    end
    if pid2 then
      playerProfessions = playerProfessions..tokenize(secondProf)..'='..tostring(secondProfRank)
    end
  else
    playerProfessions = ''
  end

  -- Construct SimC-compatible strings from the basic information
  local player = tokenize(playerClass) .. '="' .. playerName .. '"'
  playerLevel = 'level=' .. playerLevel
  playerRace = 'race=' .. tokenize(playerRace)
  playerRole = 'role=' .. translateRole(globalSpecID, role)
  playerSpec = 'spec=' .. tokenize(playerSpec)
  playerRealm = 'server=' .. tokenize(playerRealm)
  playerRegion = 'region=' .. tokenize(playerRegion)

  -- Talents are more involved - method to handle them
  local playerTalents = CreateSimcTalentString()

  -- Build the output string for the player (not including gear)
  local simulationcraftProfile = versionComment .. '\n'
  simulationcraftProfile = simulationcraftProfile .. reforgeWarning .. '\n'
  simulationcraftProfile = simulationcraftProfile .. '\n'
  simulationcraftProfile = simulationcraftProfile .. player .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerLevel .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerRace .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerRegion .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerRealm .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerRole .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerProfessions .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerTalents .. '\n'
  simulationcraftProfile = simulationcraftProfile .. playerSpec .. '\n'
  simulationcraftProfile = simulationcraftProfile .. '\n'

  -- Method that gets gear information
  local items = Simulationcraft:GetItemStrings(debugOutput)

  -- output gear
  for slotNum=1, #slotNames do
    if items[slotNum] then
      simulationcraftProfile = simulationcraftProfile .. items[slotNum] .. '\n'
    end
  end

  simulationcraftProfile = simulationcraftProfile .. '\n'

  -- output gear from bags
  if noBags == false then
    local bagItems = Simulationcraft:GetBagItemStrings()

    simulationcraftProfile = simulationcraftProfile .. '### Gear from Bags\n'
    simulationcraftProfile = simulationcraftProfile .. '#\n'
    for i=1, #bagItems do
      simulationcraftProfile = simulationcraftProfile .. '# ' .. bagItems[i].name .. '\n'
      simulationcraftProfile = simulationcraftProfile .. '# ' .. bagItems[i].string .. '\n'
      simulationcraftProfile = simulationcraftProfile .. '#\n'
    end
  end

  -- sanity checks - if there's anything that makes the output completely invalid, punt!
  if specId==nil then
    simulationcraftProfile = "Error: You need to pick a spec!"
  end

  -- show the appropriate frames
  SimcCopyFrame:Show()
  SimcCopyFrameScroll:Show()
  SimcCopyFrameScrollText:Show()
  SimcCopyFrameScrollText:SetText(simulationcraftProfile)
  SimcCopyFrameScrollText:HighlightText()
  SimcCopyFrameScrollText:SetScript("OnEscapePressed", function(self)
    SimcCopyFrame:Hide()
  end)
end


end