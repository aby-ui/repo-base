-- general options for Dominos

local AddonName, Addon = ...
local ParentAddonName = GetAddOnDependencies(AddonName)
local ParentAddon = LibStub("AceAddon-3.0"):GetAddon(ParentAddonName)
local L = LibStub("AceLocale-3.0"):GetLocale(ParentAddonName .. "-Config")

Addon:AddOptionsPanel(
    function()
        return {
            key = "general",
            name = L.General,
            button(L.EnterConfigMode) {
                func = function()
                    ParentAddon:ToggleLockedFrames()
                end
            },
            button(L.EnterBindingMode) {
                func = function()
                    ParentAddon:ToggleBindingMode()
                end
            },
            check(L.ShowMinimapButton) {
                get = function()
                    return ParentAddon:ShowingMinimap()
                end,
                set = function(_, enable)
                    ParentAddon:SetShowMinimap(enable)
                end,
                width = "full",
            },
            check(L.StickyBars) {
                get = function()
                    return ParentAddon:Sticky()
                end,
                set = function(_, enable)
                    ParentAddon:SetSticky(enable)
                end,
                width = 1.5,
            },
            check(L.LinkedOpacity) {
                get = function()
                    return ParentAddon:IsLinkedOpacityEnabled()
                end,
                set = function(_, enable)
                    ParentAddon:SetLinkedOpacity(enable)
                end,
                width = 1.5,
            },
            h(L.ActionBarBehavior),
            check(L.LockActionButtons) {
                get = function()
                    return LOCK_ACTIONBAR == "1"
                end,
                set = function()
                    InterfaceOptionsActionBarsPanelLockActionBars:Click()
                end,
                width = 1.5
            },
            select(L.RightClickUnit) {
                values = {
                    player = L.RCUPlayer,
                    focus = L.RCUFocus,
                    targettarget = L.RCUToT,
                    none = L.None
                },
                get = function()
                    return ParentAddon:GetRightClickUnit() or "none"
                end,
                set = function(_, value)
                    ParentAddon:SetRightClickUnit(value)
                end
            },
            check(L.ShowOverrideUI) {
                desc = L.ShowOverrideUIDesc,
                disabled = ParentAddon:IsBuild("classic"),
                get = function()
                    return ParentAddon:UsingOverrideUI()
                end,
                set = function(_, enable)
                    ParentAddon:SetUseOverrideUI(enable)
                end,
                width = 1.5,
            },
            select(L.PossessBar) {
                desc = L.PossessBarDesc,
                values = function()
                    local items = {}

                    for i = 1, ParentAddon:NumBars() do
                        tinsert(items, L.ActionBarNumber:format(i))
                    end

                    return items
                end,
                get = function()
                    local bar = ParentAddon:GetOverrideBar()

                    if bar then
                        return bar.id
                    end

                    return 1
                end,
                set = function(_, value)
                    ParentAddon:SetOverrideBar(value)
                end
            },            
            h(L.ActionButtonLookAndFeel),
            check(L.ShowEmptyButtons) {
                get = function()
                    return ParentAddon:ShowGrid()
                end,
                set = function(_, enable)
                    ParentAddon:SetShowGrid(enable)
                end,
                width = 1.5,
            },
            check(L.ShowBindingText) {
                get = function()
                    return ParentAddon:ShowBindingText()
                end,
                set = function(_, enable)
                    ParentAddon:SetShowBindingText(enable)
                end,
                width = 1.5,
            },
            check(L.ShowMacroText) {
                get = function()
                    return ParentAddon:ShowMacroText()
                end,
                set = function(_, enable)
                    ParentAddon:SetShowMacroText(enable)
                end,
                width = 1.5,
            },
            check(L.ShowCountText) {
                get = function()
                    return ParentAddon:ShowCounts()
                end,
                set = function(_, enable)
                    ParentAddon:SetShowCounts(enable)
                end,
                width = 1.5,
            },
            check(L.ShowEquippedItemBorders) {
                get = function()
                    return ParentAddon:ShowEquippedItemBorders()
                end,
                set = function(_, enable)
                    ParentAddon:SetShowEquippedItemBorders(enable)
                end,
                width = 1.5,
            },
            check(L.ThemeActionButtons) {
                get = function()
                    return ParentAddon:ThemeButtons()
                end,
                set = function(_, enable)
                    ParentAddon:SetThemeButtons(enable)
                end,
                desc = L.ThemeActionButtonsDesc,
                width = 2,
            },
            select(L.ShowTooltips) {
                width = 1.5,
                values = {
                    always = ALWAYS,
                    never = NEVER,
                    ooc = L.OutOfCombat
                },
                get = function()
                    if ParentAddon:ShowTooltips() then
                        if ParentAddon:ShowCombatTooltips() then
                            return "always"
                        end

                        return "ooc"
                    end

                    return "never"
                end,
                set = function(_, value)
                    if value == "always" then
                        ParentAddon:SetShowTooltips(true)
                        ParentAddon:SetShowCombatTooltips(true)
                    elseif value == "ooc" then
                        ParentAddon:SetShowTooltips(true)
                        ParentAddon:SetShowCombatTooltips(false)
                    elseif value == "never" then
                        ParentAddon:SetShowTooltips(false)
                        ParentAddon:SetShowCombatTooltips(false)
                    else
                        error(("%s - Unknown tooltip option %q"):format(ParentAddonName, value))
                    end
                end
            }            
        }
    end
)
