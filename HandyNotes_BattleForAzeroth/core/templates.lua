-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale

-------------------------------------------------------------------------------
--------------------------- UIDROPDOWNMENU_ADDSLIDER --------------------------
-------------------------------------------------------------------------------

local function UIDropDownMenu_AddSlider (info, level)
    local function format (v)
        if info.percentage then return FormatPercentage(v, true) end
        return string.format("%.2f", v)
    end

    info.frame.Label:SetText(info.text)
    info.frame.Value:SetText(format(info.value))
    info.frame.Slider:SetMinMaxValues(info.min, info.max)
    info.frame.Slider:SetMinMaxValues(info.min, info.max)
    info.frame.Slider:SetValueStep(info.step)
    info.frame.Slider:SetAccessorFunction(function () return info.value end)
    info.frame.Slider:SetMutatorFunction(function (v)
        info.frame.Value:SetText(format(v))
        info.func(v)
    end)
    info.frame.Slider:UpdateVisibleState()

    UIDropDownMenu_AddButton({ customFrame = info.frame }, level)
end

-------------------------------------------------------------------------------
---------------------------- WORLD MAP BUTTON MIXIN ---------------------------
-------------------------------------------------------------------------------

local WorldMapOptionsButtonMixin = {}
_G[ADDON_NAME.."WorldMapOptionsButtonMixin"] = WorldMapOptionsButtonMixin

function WorldMapOptionsButtonMixin:OnLoad()
    UIDropDownMenu_SetInitializeFunction(self.DropDown, function (dropdown, level)
        dropdown:GetParent():InitializeDropDown(level)
    end)
    UIDropDownMenu_SetDisplayMode(self.DropDown, "MENU")

    self.GroupDesc = CreateFrame('Frame', ADDON_NAME..'GroupMenuSliderOption',
        nil, ADDON_NAME..'TextMenuOptionTemplate')
    self.AlphaOption = CreateFrame('Frame', ADDON_NAME..'AlphaMenuSliderOption',
        nil, ADDON_NAME..'SliderMenuOptionTemplate')
    self.ScaleOption = CreateFrame('Frame', ADDON_NAME..'ScaleMenuSliderOption',
        nil, ADDON_NAME..'SliderMenuOptionTemplate')
end

function WorldMapOptionsButtonMixin:OnMouseDown(button)
    self.Icon:SetPoint("TOPLEFT", 8, -8)
    local xOffset = WorldMapFrame.isMaximized and 30 or 0
    self.DropDown.point = WorldMapFrame.isMaximized and "TOPRIGHT" or "TOPLEFT"
    ToggleDropDownMenu(1, nil, self.DropDown, self, xOffset, -5)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function WorldMapOptionsButtonMixin:OnMouseUp()
    self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
end

function WorldMapOptionsButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip_SetTitle(GameTooltip, ns.plugin_name)
    GameTooltip_AddNormalLine(GameTooltip, L["map_button_text"])
    GameTooltip:Show()
end

function WorldMapOptionsButtonMixin:Refresh()
    local map = ns.maps[self:GetParent():GetMapID() or 0]
    if map and map:HasEnabledGroups() then self:Show() else self:Hide() end
end

function WorldMapOptionsButtonMixin:InitializeDropDown(level)
    if level == 1 then
        UIDropDownMenu_AddButton({
            isTitle = true,
            notCheckable = true,
            text = WORLD_MAP_FILTER_TITLE
        })

        local map, icon = ns.maps[self:GetParent():GetMapID()]

        for i, group in ipairs(map.groups) do
            if group:IsEnabled() then
                if type(group.icon) == 'number' then
                    icon = ns.GetIconLink(group.icon, 12, 1, 0)..' '
                else
                    icon = ns.GetIconLink(group.icon, 16)
                end
                UIDropDownMenu_AddButton({
                    text = icon..' '..ns.RenderLinks(group.label, true),
                    isNotRadio = true,
                    keepShownOnClick = true,
                    hasArrow = true,
                    value = group,
                    checked = group:GetDisplay(),
                    arg1 = group,
                    func = function (button, group)
                        group:SetDisplay(button.checked)
                    end
                })
            end
        end

        UIDropDownMenu_AddSeparator()
        UIDropDownMenu_AddButton({
            text = L["options_show_completed_nodes"],
            isNotRadio = true,
            keepShownOnClick = true,
            checked = ns:GetOpt('show_completed_nodes'),
            func = function (button, option)
                ns:SetOpt('show_completed_nodes', button.checked)
            end
        })
        UIDropDownMenu_AddButton({
            text = L["options_toggle_use_char_achieves"],
            isNotRadio = true,
            keepShownOnClick = true,
            checked = ns:GetOpt('use_char_achieves'),
            func = function (button, option)
                ns:SetOpt('use_char_achieves', button.checked)
            end
        })

        UIDropDownMenu_AddSeparator()
        UIDropDownMenu_AddButton({
            text = L["options_open_settings_panel"],
            isNotRadio = true,
            notCheckable = true,
            disabled = not map.settings,
            func = function (button, option)
                InterfaceOptionsFrame_Show()
                InterfaceOptionsFrame_OpenToCategory('HandyNotes')
                LibStub('AceConfigDialog-3.0'):SelectGroup(
                    'HandyNotes', 'plugins', ADDON_NAME, 'ZonesTab', 'Zone_'..map.id
                )
            end
        })
    elseif level == 2 then
        -- Get correct map ID to query/set options for
        local group = UIDROPDOWNMENU_MENU_VALUE

        self.GroupDesc.Text:SetText(ns.RenderLinks(group.desc))
        UIDropDownMenu_AddButton({ customFrame = self.GroupDesc }, 2)
        UIDropDownMenu_AddButton({
            notClickable = true,
            notCheckable = true
        }, 2)

        UIDropDownMenu_AddSlider({
            text = L["options_opacity"],
            min = 0, max = 1, step=0.01,
            value = group:GetAlpha(),
            frame = self.AlphaOption,
            percentage = true,
            func = function (v) group:SetAlpha(v) end
        }, 2)

        UIDropDownMenu_AddSlider({
            text = L["options_scale"],
            min = 0.3, max = 3, step=0.05,
            value = group:GetScale(),
            frame = self.ScaleOption,
            func = function (v) group:SetScale(v) end
        }, 2)
    end
end