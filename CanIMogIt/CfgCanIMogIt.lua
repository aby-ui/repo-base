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