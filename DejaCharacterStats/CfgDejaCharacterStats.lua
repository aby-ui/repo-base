U1RegisterAddon("DejaCharacterStats", {
    title = "角色详细属性",
    tags = { TAG_ITEM },
    defaultEnable = 0,
    load = "LATER",
    icon = "Interface\\ICONS\\Achievement_BG_most_damage_killingblow_dieleast",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if(justload and DejaHookButton) then
            DejaHookButton:Hide() -- 自带的已经有了
            DejaHookButton:SetText("选")
            DejaHookButton:RegisterForClicks("AnyUp")
            CoreUIEnableTooltip(DejaHookButton, '角色详细属性', '<左键> 选择要显示的属性\n<右键> 打开设置页面')
            DejaHookButton:SetScript("OnClick", function(self, button)
                if button == "RightButton" then
                    SlashCmdList["DejaCharacterStats"]("config")
                else
                    (DCS_configButton:GetScript("OnMouseUp") or DCS_configButton:GetScript("OnClick"))(DCS_configButton)
                end
            end)
        end
    end,

    {
        text = "配置选项",
        callback = function() SlashCmdList["DejaCharacterStats"]("config") end
    },

    {
        text = "重置默认",
        confirm = "重置所有设置并重载界面，是否确认？",
        callback = function()
            DCS_ClassSpecDB,DejaCharacterStatsDB,DejaCharacterStatsDBPC = nil,nil,nil
            ReloadUI()
            -- SlashCmdList["DejaCharacterStats"]("reset")
        end
    }
})

if not CreateFrame then return end
local btn = WW:Button("DejaHookButton", CharacterFrameInsetRight, "UIMenuButtonStretchTemplate")
:SetTextFont(ChatFontNormal, 13, "")
:SetAlpha(0.8)
:SetText("详")
:Size(26,26)
:TOPRIGHT(CharacterFrame, -24, 2)
:AddFrameLevel(3, CharacterFrameInsetRight)
:SetScript("OnClick", function() U1LoadAddOn("DejaCharacterStats") end)
:un()
CoreUIEnableTooltip(btn, '角色详细属性', 'DejaCharacterStats')
