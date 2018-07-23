U1RegisterAddon("CanIMogIt", {
    title = "幻化提示",
    defaultEnable = 1,

    tags = { TAG_ITEM, },
    icon = [[Interface\Icons\Achievement_Dungeon_TheVioletHold_Normal]],
    nopic = 1,
    toggle = function(name, info, enable, justload)
    end,
    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            local func = CoreIOF_OTC or InterfaceOptionsFrame_OpenToCategory
            func(CanIMogIt.frame.name)
        end
    }
});

--[[------------------------------------------------------------
快捷解锁幻化，装备，确认绑定，再换回装备
---------------------------------------------------------------]]
if not CreateFrame then return end
local ef = CreateFrame("Frame")
--穿回原装备
ef:SetScript("OnEvent", function(self)
    --仅处理2秒内的事件，防止误操作
    if (self.time and GetTime() - self.time < 2) then
        UseContainerItem(self.bag, self.slot)
    end
    self:UnregisterEvent("BAG_UPDATE_DELAYED")
end)

hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
    if button == "RightButton" and IsControlKeyDown() and IsAltKeyDown() then
        local bag = self:GetParent():GetID()
        local slot = self:GetID()
        local link = GetContainerItemLink(bag, slot)
        if not link then return end
        local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(link)
        if (quality <= 3 and equipSlot) then
            if CanIMogIt and CanIMogIt:GetTooltipText(nil, bag, slot) == CanIMogIt.UNKNOWN then
                UseContainerItem(bag, slot)
                if (StaticPopup1:IsVisible() and StaticPopup1.which == "EQUIP_BIND") then
                    StaticPopup1Button1:Click()
                    U1Message("快捷解锁外观：" .. link)
                    ef.time = GetTime()
                    ef.bag, ef.slot = bag, slot
                    ef:RegisterEvent("BAG_UPDATE_DELAYED")
                end
            else
                U1Message(CanIMogIt and "此物品外观已解锁或不能被当前角色解锁" or "快捷解锁失败：未启用幻化提示(CanIMogIt)插件")
            end
        end
    end
end)