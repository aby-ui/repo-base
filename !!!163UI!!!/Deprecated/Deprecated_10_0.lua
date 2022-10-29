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
--]]
