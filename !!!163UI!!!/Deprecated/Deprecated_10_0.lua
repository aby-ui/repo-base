if not U1_WOW10 then return end
--[[
    "TabButtonTemplate" "OptionsFrameTabButtonTemplate"
        临时在10.0 XML增加TabButtonTemplate继承PanelTopTabButtonTemplate
        兼容可用PanelTopTabButtonMixin and "PanelTopTabButtonTemplate" or "TabButtonTemplate"
        父框体 inherits="PanelTopTabButtonTemplate" mixin="PanelTopTabButtonMixin"
            <KeyValue key="tabPadding" value="0" type="number"/>
            <KeyValue key="minTabWidth" value="40" type="number"/>
            <KeyValue key="maxTabWidth" value="2000" type="number"/>
            PanelTemplates_TabResize

    "OptionsCheckButtonTemplate"
        暂时创建 "InterfaceOptionsCheckButtonTemplate"的别名, 后者限制275宽度，注意这个在 SharedXML\DeprecatedTemplates.xml 里
        或者用'UICheckButtonTemplate'但是个头比较大

    "OptionsButtonTemplate" -> "UIPanelButtonTemplate" (90, 21)

    SetMinResize/SetMax
        if UIParent.SetResizeBounds then --abyui10
            frame:SetResizeBounds(minWidth, minHeight, maxWidth, maxHeight); --可以省略后面的
        else
            frame:SetMinResize(minWidth, minHeight);
            frame:SetMaxResize(maxWidth, maxHeight);
        end
    end

    SetGradientAlpha("HORIZONTAL",r,g,b,start,r*factor,g*factor,b*factor,stop)
        SetGradient("HORIZONTAL", CreateColor(r,g,b,start), CreateColor(r*factor,g*factor,b*factor,stop)

    移除事件 VOID_STORAGE_OPEN
        机制是 PLAYER_INTERACTION_MANAGER_FRAME_SHOW(Enum.PlayerInteractionType) @see PlayerInteractionFrameManager.lua

    SetFont 第三个参数

    if C_Container and C_Container.GetContainerItemLink then
        -- Dragonflight
        itemLink = C_Container.GetContainerItemLink(container, slot)
    else
        -- Shadowlands
        local _, _, _, _, _, _, il, _, _, _ = GetContainerItemInfo(container, slot)
        itemLink = il
    end

    CURSOR_UPDATE -> CURSOR_CHANGED

    <TitleRegion setAllPoints="true"/>非法，可参考QuickKeybind.xml
            <Frame parentKey="Header" inherits="DialogHeaderTemplate">
                <KeyValues>
                    <KeyValue key="textString" value="QUICK_KEYBIND_MODE" type="global"/>
                </KeyValues>
            </Frame>

    C_GossipInfo.SelectAvailableQuest(self:GetID()) --改为选择questId

    GearManagerDialogPopup -> GearManagerPopupFrame

    SetFromScale -> SetScaleFrom SetFromAlpha不变

    srti.menu.test.model:SetLight(true,false,-.5,-.2,-.6,0.5,1,1,1,1,1,1,0.8);
    	local lightValues = { omnidirectional = false, point = CreateVector3D(-.5,-.2,-.6), ambientIntensity = 0.5, ambientColor = CreateColor(1,1,1), diffuseIntensity = 1, diffuseColor = CreateColor(1,1,0.8) }
	    srti.menu.test.model:SetLight(true,lightValues);



	EventRegistry:RegisterCallback("ContainerFrame.CloseBag", self.UpdateBagButtonHighlight, self);
	EventRegistry:RegisterCallback("ContainerFrame.OpenBag", self.UpdateBagButtonHighlight, self);

    ContainerIDToInventoryID(1) -> 31 PutItemInBag()

    ActionButtonUseKeyDown

    CreateAtlasMarkup(GetClassAtlas(classFileName:lower()))

    if type(Settings) == "table" and type(Settings.RegisterCanvasLayoutCategory) == "function" then

    不需要SetOrHookScript了直接Hook即可
    GetPoint() -> GetPoint(1) --不需要了
    CreateFrame("GameTooltip") 必须加名字，否则有BUG，装备价格不显示

    C_GossipInfo.GetNumOptions() 没了,直接 C_GossipInfo.GetOptions(), C_GossipInfo.SelectOption(需要选择 gossipOptionID,而不是index)

    ContainerFrameUtil_EnumerateContainerFrames() 不要用
--]]

--[[------------------------------------------------------------
10.0的按钮各个材质大小不是联动的，需要单独设置 @see BaseActionButtonMixin:UpdateButtonArt(hideDivider)
---------------------------------------------------------------]]
local scales = {}
do
    local testButton = CreateFrame("CheckButton", "_abyBtnCoreUISetActionButtonSize10", UIParent, "ActionBarButtonTemplate") testButton:Hide()
    local w1, h1 = testButton:GetSize()
    for k, v in pairs(testButton) do
        if type(v) == "table" and v.GetSize then
            if not v:GetPoint(2) then --ignore those SetAllPoints()
                local w, h = v:GetSize()
                scales[k] = { w / w1, h / h1 }
            end
        end
    end

    function CoreUISetActionButtonSize10(btn, size)
        btn:SetNormalAtlas("UI-HUD-ActionBar-IconFrame-AddRow");
        btn:SetPushedAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down");
        if InCombatLockdown() then return end
        btn:SetSize(size, size)
        for k, v in pairs(btn) do
            if type(v) == "table" and v.GetSize then
                if not v:GetPoint(2) then
                    local scale = scales[k]
                    if scale then
                        v:SetSize(size * scale[1], size * scale[2])
                    end
                end
            end
        end
    end
end

do
    CoreOnEvent("VARIABLES_LOADED", function()
        if U1DBG.show_3rd_bindings then
            U1DBG.show_3rd_bindings = nil
            BINDING_HEADER_OTHER = "BINDING_HEADER_OTHER"
            C_Timer.After(0.1, function()
                SettingsPanel:OpenToCategory(SettingsPanel.keybindingsCategory.ID)
            end)
        end

        local name = "AbySettingsBindingToggleButton"
        local ok, def = pcall(function() return
            SettingsPanel.Container.SettingsList.Header.DefaultsButton
        end)
        if not ok then return end

        local working = BINDING_HEADER_OTHER ~= BINDING_HEADER_MISC

        local btn = WW:Button(name, def:GetParent(), "UIPanelButtonTemplate")
                      :Size(110, 22):TR(def, "TL", -10, 0)
                      :SetText('\124TInterface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo:' .. (20) .. '\124t' .. (working and "  重载保证安全  " or "  显示插件热键  "))
                      :SetScript("OnDoubleClick", function()
                    if not working then U1DBG.show_3rd_bindings = true end
                    ReloadUI()
                end)  :un()

        btn.tooltipText = "|cffffff00临时显示插件定义的热键|r\n\n因为暴雪的BUG,中文客户端无法显示插件自定义的热键（参见https://bbs.nga.cn/read.php?tid=34037994 oyg123大佬曾发现并解决过9.1打开地图卡顿的问题）。\n\n爱不易根据这个帖子，增加这个按钮，'|cffffff00双击|r'此按钮会重载界面并显示这些热键，但是这样可能导致界面失效的问题。所以设置完热键后，请再次重载界面。"
        btn.Text:ClearAllPoints()
        btn.Text:SetPoint("RIGHT")
        btn.Text:SetJustifyH("RIGHT")
        hooksecurefunc(SettingsPanel.CategoryList, "SetCurrentCategory", function(self)
            if self.currentCategory == SettingsPanel.keybindingsCategory then
                btn:Show()
            else
                btn:Hide()
            end
        end)
        SettingsPanel:HookScript("OnHide", function()
            if working then
                U1Message("你之前开启了显示插件热键功能，当前环境可能不安全，建议/rl重载界面")
            end
        end)
    end)
end