--- Kaliel's Tracker
--- Copyright (c) 2012-2022, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_AddonOthers")
KT.AddonOthers = M

local MSQ = LibStub("Masque", true)
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- WoW API
local _G = _G

local db
local OTF = KT_ObjectiveTrackerFrame
local msqGroup1, msqGroup2

local KTwarning = "  |cff00ffffAddon "..KT.title.." is active.  "

--------------
-- Internal --
--------------

-- Masque
local function Masque_SetSupport()
    if M.isLoadedMasque then
        msqGroup1 = MSQ:Group(KT.title, "Quest Item Buttons")
        msqGroup2 = MSQ:Group(KT.title, "Quest Active Button")
        hooksecurefunc(msqGroup2, "__Enable", function(self)
            for button in pairs(self.Buttons) do
                if button.Style then
                    button.Style:SetAlpha(0)
                end
            end
        end)
        hooksecurefunc(msqGroup2, "__Disable", function(self)
            for button in pairs(self.Buttons) do
                if button.Style then
                    button.Style:SetAlpha(1)
                end
            end
        end)
    end
end

-- ElvUI
local function ElvUI_SetSupport()
    if KT:CheckAddOn("ElvUI", "13.06", true) then
        local E = unpack(_G.ElvUI)
        local B = E:GetModule("Blizzard")
        B.SetObjectiveFrameHeight = function() end    -- preventive
        B.SetObjectiveFrameAutoHide = function() end  -- preventive
        B.HandleMawBuffsFrame = function() end        -- preventive
        B.MoveObjectiveFrame = function() end
        if E.private.skins.blizzard.objectiveTracker then
            StaticPopup_Show(addonName.."_ReloadUI", nil, "Activate changes for |cff00ffe3ElvUI|r.")
        end
        hooksecurefunc(E, "CheckIncompatible", function(self)
            self.private.skins.blizzard.objectiveTracker = false
        end)
        hooksecurefunc(E, "ToggleOptions", function(self)
            if E.Libs.AceConfigDialog.OpenFrames[self.name] then
                local options = self.Options.args.general.args.blizzUIImprovements
                options.args[addonName.."Warning"] = {
                    name = "\n"..KTwarning,
                    type = "description",
                    order = 2.99,
                }
            end
        end)
    end
end

-- Tukui
local function Tukui_SetSupport()
    if KT:CheckAddOn("Tukui", "20.341", true) then
        local T = unpack(_G.Tukui)
        T.Miscellaneous.ObjectiveTracker.Enable = function() end
    end
end

-- RealUI
local function RealUI_SetSupport()
    if KT:CheckAddOn("nibRealUI", "2.3.1", true) then
        local R = _G.RealUI
        R:SetModuleEnabled("Objectives Adv.", false)

        --[[
        local module = "Objectives Adv."
        if R:GetModuleEnabled(module) then
            R:SetModuleEnabled(module, false)
            StaticPopup_Show(addonName.."_ReloadUI", nil, "Activate changes for |cff00ffe3RealUI|r.")
        end
        --]]
        if not IsAddOnLoaded("Aurora_Extension") then
            StaticPopup_Show(addonName.."_Info", nil, "Please install / activate addon |cff00ffe3Aurora - Extension|r\nand disable Objective Tracker skin.")
        end
    end
end

-- SyncUI
local function SyncUI_SetSupport()
    if KT:CheckAddOn("SyncUI", "8.3.0.3", true) then
        SyncUI_ObjTracker.Show = function() end
        SyncUI_ObjTracker:Hide()
        SyncUI_ObjTracker:SetScript("OnLoad", nil)
        SyncUI_ObjTracker:SetScript("OnEvent", nil)
        SyncUI_UnregisterDragFrame(_G["SyncUI_ObjTracker"])
    end
end

-- SpartanUI
local function SpartanUI_SetSupport()
    if KT:CheckAddOn("SpartanUI", "6.0.27", true) then
        SUI.DB.DisabledComponents.Objectives = true
        local module = SUI:GetModule("Component_Objectives")
        local bck_module_OnEnable = module.OnEnable
        function module:OnEnable()
            if SUI.DB.DisabledComponents.Objectives then
                local options = SUI.opt.args.ModSetting.args
                options.Objectives = {
                    type = "group",
                    name = SUI.L.Objectives,
                    disabled = true,
                    args = {},
                }
                options.Components.args.Objectives.disabled = true
                options.Components.args[addonName.."Warning"] = {
                    name = "\n"..KTwarning,
                    type = "description",
                    order = 1000,
                }
                return
            end
            bck_module_OnEnable(self)
        end
    end
end

--------------
-- External --
--------------

function M:OnInitialize()
    _DBG("|cffffff00Init|r - "..self:GetName(), true)
    db = KT.db.profile
    self.isLoadedMasque = (KT:CheckAddOn("Masque", "10.0.2") and db.addonMasque)

    if self.isLoadedMasque then
        KT:Alert_IncompatibleAddon("Masque", "10.0.1")
    end
end

function M:OnEnable()
    _DBG("|cff00ff00Enable|r - "..self:GetName(), true)
    Masque_SetSupport()
    ElvUI_SetSupport()
    Tukui_SetSupport()
    RealUI_SetSupport()
    SyncUI_SetSupport()
    SpartanUI_SetSupport()
end

-- Masque
function KT:Masque_AddButton(button, group)
    if db.addonMasque and MSQ and msqGroup1 then
        if not group or group == 1 then
            group = msqGroup1
        elseif group == 2 then
            group = msqGroup2
        end
        group:AddButton(button)
        if button.Style then
            if not group.db.Disabled then
                button.Style:SetAlpha(0)
            end
        end
    end
end
