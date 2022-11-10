-- function AutoTurnIn:trim(s)
--   return s:match "^%s*(.-)%s*$"
-- end

-- function AutoTurnIn:getFreeInventoryNum(bagtype)
--   local commonbag, specificbag = 0, 0;

--   for bag = 0, NUM_BAG_SLOTS do
--     local slots, bt = GetContainerNumFreeSlots(bag);
--     if (bt == bagtype) then
--       specificbag = specificbag + slots
--     end
--     if (bt == 0) then
--       commonbag = commonbag + slots
--     end
--   end

--   if (specificbag > 0) then
--     return specificbag
--   else
--     return commonbag;
--   end
-- end

--[[
 Alt + leftclick purges item under cursor
 Execution tainted by lurui while reading ContainerFrameItemButton_OnModifiedClick - ContainerFrame1Item15:OnClick()
]]--
--hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function (self, button)
-- hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function (self, button)  
--   if ( AutoTurnIn.db.profile.unsafe_item_wipe and button == "LeftButton" and IsAltKeyDown() ) then
--     PickupContainerItem(self:GetParent():GetID(), self:GetID());
--     if (CursorHasItem()) then
--       DeleteCursorItem()
--     end
--   end
-- end)
