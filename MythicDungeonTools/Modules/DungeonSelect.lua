local MDT = MDT local L = MDT.L
local AceGUI = LibStub("AceGUI-3.0")
local db

-- The idea here is to redo the dungeon select dropdown to be more user friendly.
-- This was necesarry as the old implementation did not allow for a dungeon to be part of multiple dungeon sets.
-- Additional dungeon lists just need to be added to seasonList and dungeonSelectionToIndex.

local seasonListActive = false
local seasonList = {
  [1] = L["Legion"],
  [2] = L["BFA"],
  [3] = L["Shadowlands"],
  [4] = L["Shadowlands Season 4"],
  -- [5]= "Dragonflight Season 1",
}

local dungeonSelectionToIndex = {
  [1] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
  [2] = { 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
  [3] = { 29, 30, 31, 32, 33, 34, 35, 36, 37, 38 },
  [4] = { 40, 41, 37, 38, 25, 26, 9, 10 },
  -- [5] = {42,43,44,45,...}
}

local indexToDungeonSelection = {}
local dungeonSelectionToNames = {}

function MDT:UpdateDungeonDropDown()
  local dungeonDropdown = MDT.main_frame.DungeonSelectionGroup.DungeonDropdown
  local sublevelDropdown = MDT.main_frame.DungeonSelectionGroup.SublevelDropdown
  local currentDungeonIdx = db.currentDungeonIdx
  dungeonDropdown:SetList(dungeonSelectionToNames[db.selectedDungeonList])
  dungeonDropdown:SetValue(indexToDungeonSelection[db.selectedDungeonList][currentDungeonIdx])
  dungeonDropdown:ClearFocus()
  sublevelDropdown:SetList(MDT.dungeonSubLevels[currentDungeonIdx])
  sublevelDropdown:SetValue(db.presets[currentDungeonIdx][db.currentPreset[currentDungeonIdx]].value.currentSublevel)
  sublevelDropdown:ClearFocus()
end

---CreateDungeonSelectDropdown
---Creates both dungeon and sublevel dropdowns
function MDT:CreateDungeonSelectDropdown(frame)
  db = MDT:GetDB()
  --Simple Group to hold both dropdowns
  frame.DungeonSelectionGroup = AceGUI:Create("SimpleGroup")
  local group = frame.DungeonSelectionGroup
  if not group.frame.SetBackdrop then
    Mixin(group.frame, BackdropTemplateMixin)
  end
  group.frame:SetBackdropColor(unpack(MDT.BackdropColor))
  group.frame:SetFrameStrata("HIGH")
  group.frame:SetFrameLevel(50)
  group:SetWidth(204) --idk ace added weird margin on left
  group:SetHeight(50)
  group:SetPoint("TOPLEFT", frame.topPanel, "BOTTOMLEFT", 0, 2)
  group:SetLayout("List")
  MDT:FixAceGUIShowHide(group)

  group.DungeonDropdown = AceGUI:Create("Dropdown")
  group.DungeonDropdown.text:SetJustifyH("LEFT")
  group.DungeonDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
    if (seasonListActive) then
      db.selectedDungeonList = key
      MDT:UpdateDungeonDropDown()
      seasonListActive = false
      local currentList = dungeonSelectionToIndex[db.selectedDungeonList]
      MDT:UpdateToDungeon(currentList[1])
      C_Timer.After(0.1, function()
        group.DungeonDropdown.button:Click()
      end)
    else
      local currentList = dungeonSelectionToIndex[db.selectedDungeonList]
      -- "> More Dungeons" is only added to the name list, so checking here works
      if #currentList + 1 == key then
        group.DungeonDropdown:SetList(seasonList)
        seasonListActive = true
        --need to delay opening the dropdown until the list is populated
        C_Timer.After(0.05, function()
          group.DungeonDropdown.button:Click()
        end)
      else
        MDT:UpdateToDungeon(currentList[key])
      end
    end
  end)
  group:AddChild(group.DungeonDropdown)

  --sublevel select
  group.SublevelDropdown = AceGUI:Create("Dropdown")
  group.SublevelDropdown.text:SetJustifyH("LEFT")
  group.SublevelDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
    db.presets[db.currentDungeonIdx][db.currentPreset[db.currentDungeonIdx]].value.currentSublevel = key
    MDT:UpdateMap()
    MDT:ZoomMapToDefault()
  end)
  group:AddChild(group.SublevelDropdown)

  --create lists
  for i = 1, #dungeonSelectionToIndex do
    dungeonSelectionToNames[i] = {}
    indexToDungeonSelection[i] = {}
    for j = 1, #dungeonSelectionToIndex[i] do
      dungeonSelectionToNames[i][j] = MDT.dungeonList[dungeonSelectionToIndex[i][j]]
      indexToDungeonSelection[i][dungeonSelectionToIndex[i][j]] = j
    end
    dungeonSelectionToNames[i][#dungeonSelectionToIndex[i] + 1] = L["> More Dungeons"]
  end

  MDT:UpdateDungeonDropDown()
end

function MDT:ScrollToNextDungeon(delta)
  local dungeonDropdown = MDT.main_frame.DungeonSelectionGroup.DungeonDropdown
  local currentValue = dungeonDropdown:GetValue()
  local target = currentValue + delta
  if dungeonSelectionToIndex[db.selectedDungeonList][target] then
    dungeonDropdown:Fire("OnValueChanged", target)
  end
end

function MDT:FixDungeonDropDownList()
  local valueToSet = indexToDungeonSelection[db.selectedDungeonList][db.currentDungeonIdx]
  if not valueToSet then
    -- dungeon not in selected list, find latest list that contains dungeon
    for i = #dungeonSelectionToIndex, 1, -1 do
      local list = dungeonSelectionToIndex[i]
      for _, dungeonIndex in pairs(list) do
        if dungeonIndex == db.currentDungeonIdx then
          db.selectedDungeonList = i
          MDT:UpdateDungeonDropDown()
          break
        end
      end
    end
  end
end
