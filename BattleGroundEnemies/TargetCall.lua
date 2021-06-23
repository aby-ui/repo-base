local addonName, Data = ...
local L = Data.L
local LSM = LibStub("LibSharedMedia-3.0")

-- local CloseDropDownMenus = CloseDropDownMenus
-- local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
-- local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize
-- local UIDropDownMenu_SetText = UIDropDownMenu_SetText
-- local UIDropDownMenu_SetWidth = UIDropDownMenu_SetWidth


-- BattleGroundEnemies.TargetCalllingVolunteers = {}
-- BattleGroundEnemies.TargetCaller = {}

-- -- Create the dropdown, and configure its appearance
-- BattleGroundEnemies.TargetCall = CreateFrame("FRAME", "TargetCallerSelection", UIParent, "UIDropDownMenuTemplate")
-- BattleGroundEnemies.TargetCall:SetPoint("CENTER", 0, 200)
-- UIDropDownMenu_SetWidth(BattleGroundEnemies.TargetCall, 200)
-- UIDropDownMenu_SetText(BattleGroundEnemies.TargetCall, "target caller: " .. (BattleGroundEnemies.TargetCaller.PlayerName and BattleGroundEnemies:GetColoredName(BattleGroundEnemies.TargetCaller) or ""))

-- -- Create and bind the initialization function to the dropdown menu
-- UIDropDownMenu_Initialize(BattleGroundEnemies.TargetCall, function(self, level, menuList)
--     for name, playerDetails in pairs(BattleGroundEnemies.Allies.groupMembers) do
--         local info = {
--             text = BattleGroundEnemies:GetColoredName(playerDetails),
--             checked = name == (BattleGroundEnemies.TargetCaller.PlayerName or ""),
--             func = self.SetValue, 
--             arg1 = playerDetails
--         }
        
--         UIDropDownMenu_AddButton(info)
--     end
-- end)

-- -- Implement the function to change the favoriteNumber
-- function BattleGroundEnemies.TargetCall:SetValue(playerDetails)
--     BattleGroundEnemies.TargetCaller = playerDetails
--  -- Update the text; if we merely wanted it to display newValue, we would not need to do this
--     UIDropDownMenu_SetText(BattleGroundEnemies.TargetCall, "target caller:: " .. (BattleGroundEnemies.TargetCaller.PlayerName and BattleGroundEnemies:GetColoredName(BattleGroundEnemies.TargetCaller) ))
--  -- Because this is called from a sub-menu, only that menu level is closed by default.
--  -- Close the entire menu with this next call
--     CloseDropDownMenus()
-- end
