--换装按钮提示银行字样, 且右键可以拿到背包里
if EquipmentFlyout_CreateButton then
    hooksecurefunc("EquipmentFlyout_CreateButton", function()
        for _, button in ipairs(EquipmentFlyoutFrame.buttons) do
            if not button:GetScript("PreClick") then
                button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
                button:SetScript("PreClick", function(self, button)
                    if button ~= "RightButton" then return end
                    if ( self.location == EQUIPMENTFLYOUT_IGNORESLOT_LOCATION ) then
                        return
                    elseif ( self.location == EQUIPMENTFLYOUT_UNIGNORESLOT_LOCATION ) then
                        return
                    elseif ( self.location == EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION ) then
                        return
                    else
                        local player, bank, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(self.location);
                        if bank then
                            self.location = nil --阻止装备
                            if not bags then
                                ClearCursor();
                                PickupInventoryItem(slot)
                                if CursorHasItem() then
                                    for i=0, 4 do
                                        if GetContainerNumFreeSlots(i) > 0 then
                                            if i==0 then PutItemInBackpack() else PutItemInBag(i) end
                                        end
                                    end
                                end
                            else
                                UseContainerItem(bag, slot)
                            end
                        end
                    end
                end)
                WW(button):CreateFontString():Key("labelBank")
                :Size(40, 12):BOTTOM(0,0)
                :SetFontObject(ChatFontNormal):SetFontHeightAndFlags(10, "OUTLINE")
                :SetText("银行"):Hide():up():un()
            end
        end
    end)

    hooksecurefunc("EquipmentFlyout_DisplayButton", function(button, paperDollItemSlot)
        button.labelBank:Hide()
        if ( button.location == EQUIPMENTFLYOUT_IGNORESLOT_LOCATION ) then
            return
        elseif ( button.location == EQUIPMENTFLYOUT_UNIGNORESLOT_LOCATION ) then
            return
        elseif ( button.location == EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION ) then
            return
        elseif button.location then
            local player, bank, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(button.location);
            if bank then
                button.labelBank:Show()
            end
        end
    end)
end
