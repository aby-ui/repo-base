-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local L = ns.locale

local LibDD = LibStub:GetLibrary('LibUIDropDownMenu-4.0')

-------------------------------------------------------------------------------
--------------------------- UIDROPDOWNMENU_ADDSLIDER --------------------------
-------------------------------------------------------------------------------

local function Custom_UIDropDownMenu_AddSlider(info, level)
    local function format(v)
        if info.percentage then return FormatPercentage(v, true) end
        return string.format('%.2f', v)
    end

    info.frame.Label:SetText(info.text)
    info.frame.Value:SetText(format(info.value))
    info.frame.Slider:SetMinMaxValues(info.min, info.max)
    info.frame.Slider:SetMinMaxValues(info.min, info.max)
    info.frame.Slider:SetValueStep(info.step)
    info.frame.Slider:SetAccessorFunction(function() return info.value end)
    info.frame.Slider:SetMutatorFunction(function(v)
        info.frame.Value:SetText(format(v))
        info.func(v)
    end)
    info.frame.Slider:UpdateVisibleState()

    LibDD:UIDropDownMenu_AddButton({customFrame = info.frame}, level)
end

-------------------------------------------------------------------------------
---------------------------- WORLD MAP BUTTON MIXIN ---------------------------
-------------------------------------------------------------------------------

local WorldMapOptionsButtonMixin = {}
_G[ADDON_NAME .. 'WorldMapOptionsButtonMixin'] = WorldMapOptionsButtonMixin

function WorldMapOptionsButtonMixin:OnLoad()
    local drop_down_name = ADDON_NAME .. 'WorldMapDropDownMenu'
    self.DropDown = LibDD:Create_UIDropDownMenu(drop_down_name, self)

    LibDD:UIDropDownMenu_SetInitializeFunction(self.DropDown, function(dropdown,
        level) dropdown:GetParent():InitializeDropDown(level) end)
    LibDD:UIDropDownMenu_SetDisplayMode(self.DropDown, 'MENU')

    self.GroupDesc = CreateFrame('Frame', ADDON_NAME .. 'GroupMenuSliderOption',
        nil, ADDON_NAME .. 'TextMenuOptionTemplate')
    self.AlphaOption = CreateFrame('Frame',
        ADDON_NAME .. 'AlphaMenuSliderOption', nil,
        ADDON_NAME .. 'SliderMenuOptionTemplate')
    self.ScaleOption = CreateFrame('Frame',
        ADDON_NAME .. 'ScaleMenuSliderOption', nil,
        ADDON_NAME .. 'SliderMenuOptionTemplate')
end

function WorldMapOptionsButtonMixin:OnMouseDown(button)
    self.Icon:SetPoint('TOPLEFT', 8, -8)
    local xOffset = WorldMapFrame.isMaximized and 30 or 0
    self.DropDown.point = WorldMapFrame.isMaximized and 'TOPRIGHT' or 'TOPLEFT'
    LibDD:ToggleDropDownMenu(1, nil, self.DropDown, self, xOffset, -5)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function WorldMapOptionsButtonMixin:OnMouseUp()
    self.Icon:SetPoint('TOPLEFT', self, 'TOPLEFT', 6, -6)
end

function WorldMapOptionsButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    GameTooltip_SetTitle(GameTooltip, ns.plugin_name)
    GameTooltip_AddNormalLine(GameTooltip, L['map_button_text'])
    GameTooltip:Show()
end

function WorldMapOptionsButtonMixin:Refresh()
    local enabled = ns:GetOpt('show_worldmap_button')
    local map = ns.maps[self:GetParent():GetMapID() or 0]
    if enabled and map and map:HasEnabledGroups() then
        self:Show()
    else
        self:Hide()
    end
end

function WorldMapOptionsButtonMixin:AddGroupButton(group, level)
    local map = ns.maps[self:GetParent():GetMapID()]
    local icon, iconLink = group.icon
    local status = ''
    if group.achievement then
        local _, _, _, completed, _, _, _, _, _, _, _, _, earnedByMe =
            GetAchievementInfo(group.achievement)
        status = ' ' .. (earnedByMe and ns.GetIconLink('check_gn') or
                     (completed and ns.GetIconLink('check_bl') or ''))
    end

    if group.name == 'misc' then
        -- find an icon from the misc nodes in the map
        for coord, node in pairs(map.nodes) do
            if node.group == group then
                icon = node.icon
                break
            end
        end
    end

    if type(icon) == 'number' then
        iconLink = ns.GetIconLink(icon, 12, 1, 0) .. ' '
    else
        iconLink = ns.GetIconLink(icon, 16)
    end

    LibDD:UIDropDownMenu_AddButton({
        text = iconLink .. ' ' .. ns.RenderLinks(group.label, true) .. status,
        isNotRadio = true,
        keepShownOnClick = true,
        hasArrow = true,
        value = group,
        checked = group:GetDisplay(map.id),
        arg1 = group,
        func = function(button, group)
            group:SetDisplay(button.checked, map.id)
        end
    }, level)
end

function WorldMapOptionsButtonMixin:AddGroupOptions(group, level)
    local map = ns.maps[self:GetParent():GetMapID()]

    self.GroupDesc.Text:SetText(ns.RenderLinks(group.desc))
    LibDD:UIDropDownMenu_AddButton({customFrame = self.GroupDesc}, level)
    LibDD:UIDropDownMenu_AddButton({notClickable = true, notCheckable = true},
        level)

    Custom_UIDropDownMenu_AddSlider({
        text = L['options_opacity'],
        min = 0,
        max = 1,
        step = 0.01,
        value = group:GetAlpha(map.id),
        frame = self.AlphaOption,
        percentage = true,
        func = function(v) group:SetAlpha(v, map.id) end
    }, level)

    Custom_UIDropDownMenu_AddSlider({
        text = L['options_scale'],
        min = 0.3,
        max = 3,
        step = 0.05,
        value = group:GetScale(map.id),
        frame = self.ScaleOption,
        func = function(v) group:SetScale(v, map.id) end
    }, level)
end

function WorldMapOptionsButtonMixin:InitializeDropDown(level)
    local map = ns.maps[self:GetParent():GetMapID()]

    if level == 1 then
        local current_group_type = nil
        local achievements_menu_added = false
        for i, group in ipairs(map.groups) do

            -- Add a separator each time the group type changes
            if current_group_type ~= nil and current_group_type ~= group.type then
                LibDD:UIDropDownMenu_AddSeparator()
            end
            current_group_type = group.type

            if group:IsEnabled() and group:HasEnabledNodes(map) then
                if group.type == ns.group_types.ACHIEVEMENT and
                    not achievements_menu_added then
                    LibDD:UIDropDownMenu_AddButton({
                        text = ns.GetIconLink(236671, 12, 1, 0) .. '  ' ..
                            ACHIEVEMENTS,
                        isNotRadio = true,
                        notCheckable = true,
                        keepShownOnClick = true,
                        hasArrow = true,
                        value = 'achievements'
                    })
                    achievements_menu_added = true
                elseif group.type ~= ns.group_types.ACHIEVEMENT then
                    self:AddGroupButton(group, 1)
                end
            end
        end

        LibDD:UIDropDownMenu_AddSeparator()
        LibDD:UIDropDownMenu_AddButton({
            text = L['options_reward_types'],
            isNotRadio = true,
            notCheckable = true,
            keepShownOnClick = true,
            hasArrow = true,
            value = 'rewards'
        })
        LibDD:UIDropDownMenu_AddButton({
            text = L['options_show_completed_nodes'],
            isNotRadio = true,
            keepShownOnClick = true,
            checked = ns:GetOpt('show_completed_nodes'),
            func = function(button, option)
                ns:SetOpt('show_completed_nodes', button.checked)
            end
        })
        LibDD:UIDropDownMenu_AddButton({
            text = L['options_toggle_hide_done_rare'],
            isNotRadio = true,
            keepShownOnClick = true,
            checked = ns:GetOpt('hide_done_rares'),
            func = function(button, option)
                ns:SetOpt('hide_done_rares', button.checked)
            end
        })
        LibDD:UIDropDownMenu_AddButton({
            text = L['options_toggle_use_char_achieves'],
            isNotRadio = true,
            keepShownOnClick = true,
            checked = ns:GetOpt('use_char_achieves'),
            func = function(button, option)
                ns:SetOpt('use_char_achieves', button.checked)
            end
        })

        LibDD:UIDropDownMenu_AddSeparator()
        LibDD:UIDropDownMenu_AddButton({
            text = L['options_open_settings_panel'],
            isNotRadio = true,
            notCheckable = true,
            disabled = not map.settings and not map.id == 2112, --abyui HandyNotes_Valdrakken
            func = function(button, option)
                --HideUIPanel(WorldMapFrame)
                LibStub('AceConfigDialog-3.0'):Open('HandyNotes') --Settings.OpenToCategory('HandyNotes')
                if map.id == 2112 then
                    --HandyNotes:RegisterPluginDB(addon.pluginName, PluginHandler, private.config.options)
                    return LibStub('AceConfigDialog-3.0'):SelectGroup('HandyNotes', 'plugins', LibStub:GetLibrary("AceLocale-3.0"):GetLocale("HandyNotes_Valdrakken").config_plugin_name)
                end
                LibStub('AceConfigDialog-3.0'):SelectGroup('HandyNotes',
                    'plugins', ADDON_NAME, 'ZonesTab', 'Zone_' .. map.id)
            end
        })
    elseif level == 2 then
        if L_UIDROPDOWNMENU_MENU_VALUE == 'achievements' then
            for i, group in ipairs(map.groups) do
                if group.type == ns.group_types.ACHIEVEMENT and
                    group:IsEnabled() and group:HasEnabledNodes(map) then
                    self:AddGroupButton(group, 2)
                end
            end
        elseif L_UIDROPDOWNMENU_MENU_VALUE == 'rewards' then
            for i, type in ipairs({
                'mount', 'pet', 'toy', 'transmog', 'all_transmog'
            }) do
                LibDD:UIDropDownMenu_AddButton({
                    text = L['options_' .. type .. '_rewards'],
                    isNotRadio = true,
                    keepShownOnClick = true,
                    checked = ns:GetOpt('show_' .. type .. '_rewards'),
                    func = function(button, option)
                        ns:SetOpt('show_' .. type .. '_rewards', button.checked)
                    end
                }, 2)
            end
        else
            -- add opacity/scale menu for non-achievements
            self:AddGroupOptions(L_UIDROPDOWNMENU_MENU_VALUE, 2)
        end
    elseif level == 3 then
        -- add opacity/scale menu for achievements
        self:AddGroupOptions(L_UIDROPDOWNMENU_MENU_VALUE, 3)
    end
end
