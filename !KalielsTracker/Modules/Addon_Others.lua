--- Kaliel's Tracker
--- Copyright (c) 2012-2019, Marouan Sabbagh <mar.sabbagh@gmail.com>
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
local OTF = ObjectiveTrackerFrame
local msqGroup1, msqGroup2

local KTwarning = "  |cff00ffffAddon "..KT.title.." is active.  "

StaticPopupDialogs[addonName.."_ReloadUI"] = {
    text = KTwarning,
    button1 = "Reload UI",
    OnAccept = function()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    preferredIndex = 3,
}

--------------
-- Internal --
--------------

-- Masque
local function Masque_SetSupport()
    if db.addonMasque and MSQ then
        msqGroup1 = MSQ:Group(KT.title, "Quest Item Button")
        msqGroup2 = MSQ:Group(KT.title, "Active Button")
        hooksecurefunc(msqGroup2, "Enable", function(self)
            for button in pairs(self.Buttons) do
                if button.Style then
                    button.Style:SetAlpha(0)
                end
            end
        end)
        hooksecurefunc(msqGroup2, "Disable", function(self)
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
    if KT:CheckAddOn("ElvUI", "11.14", true) then
        local E = unpack(_G.ElvUI)
        local B = E:GetModule("Blizzard")
        B.SetObjectiveFrameAutoHide = function() end  -- preventive
        B.SetObjectiveFrameHeight = function() end
        B.MoveObjectiveFrame = function() end
        hooksecurefunc(E, "CheckIncompatible", function(self)
            self.private.skins.blizzard.objectiveTracker = false
        end)
        hooksecurefunc(E, "ToggleOptionsUI", function(self)
            if E.Libs.AceConfigDialog.OpenFrames[self.name] then
                local options = self.Options.args.general.args.objectiveFrameGroup.args
                options.objectiveFrameAutoHide.disabled = true
                options.objectiveFrameHeight.disabled = true
                options.bonusObjectivePosition.disabled = true
                options[addonName.."Warning"] = {
                    name = KTwarning,
                    type = "description",
                    order = options.objectiveFrameHeader.order + 0.5,
                }
                self.Options.args.skins.args.blizzard.args.objectiveTracker.disabled = true
            end
        end)
    end
end

-- Tukui
local function Tukui_SetSupport()
    if KT:CheckAddOn("Tukui", "18.24", true) then
        local T = unpack(_G.Tukui)
        T.Miscellaneous.ObjectiveTracker.Enable = function() end
    end
end

-- RealUI
local function RealUI_SetSupport()
    if KT:CheckAddOn("nibRealUI", "2.0.0", true) then
        local R = _G.RealUI
        R:SetModuleEnabled("Objectives Adv.", false)
        -- Fade
        --[[
        local bck_UIFrameFadeIn = UIFrameFadeIn
        function UIFrameFadeIn(frame, ...)
            if frame ~= OTF then bck_UIFrameFadeIn(frame, ...) end
        end
        local bck_UIFrameFadeOut = UIFrameFadeOut
        function UIFrameFadeOut(frame, ...)
            if frame ~= OTF then bck_UIFrameFadeOut(frame, ...) end
        end
        --]]
    end
end

-- SyncUI
local function SyncUI_SetSupport()
    if KT:CheckAddOn("SyncUI", "8.0.3", true) then
        SyncUI_ObjTracker.Show = function() end
        SyncUI_ObjTracker:Hide()
        SyncUI_ObjTracker:SetScript("OnLoad", nil)
        SyncUI_ObjTracker:SetScript("OnEvent", nil)
        SyncUI_UnregisterDragFrame(_G["SyncUI_ObjTracker"])
    end
end

-- SpartanUI
local function SpartanUI_SetSupport()
    if KT:CheckAddOn("SpartanUI", "5.1.2", true) then
        local ACD = LibStub("AceConfigDialog-3.0")
        SUI.DB.EnabledComponents.Objectives = false
        local module = SUI:GetModule("Component_Objectives")
        local bck_module_OnEnable = module.OnEnable
        function module:OnEnable()
            if not SUI.DB.EnabledComponents.Objectives then
                module:BuildOptions()
                module:HideOptions()
                return
            end
            bck_module_OnEnable(self)
        end
        local bck_ACD_Open = ACD.Open
        function ACD:Open(name, ...)
            if name == "SpartanUI" then
                local options = SUI.opt.args.ModSetting.args.Components.args
                options.Objectives.disabled = true
                options[addonName.."Warning"] = {
                    name = KTwarning,
                    type = "description",
                    order = 1000,
                }
            end
            bck_ACD_Open(self, name, ...)
        end
    end
end

-- SuperVillain UI
local function SVUI_SetSupport()
    if KT:CheckAddOn("SVUI_!Core", "1.5.1", true) then
        if IsAddOnLoaded("SVUI_QuestTracker") then
            DisableAddOn("SVUI_QuestTracker")
            StaticPopup_Show(addonName.."_ReloadUI")
        end
    end
end

-- Chinchilla
local function Chinchilla_SetCompatibility()
    if IsAddOnLoaded("Chinchilla") then
        Chinchilla:GetModule("QuestTracker"):Disable()
        local bck_Chinchilla_CreateConfig = Chinchilla.CreateConfig
        function Chinchilla:CreateConfig()
            local options = bck_Chinchilla_CreateConfig(self)
            options.args.QuestTracker.args.enabled.disabled = true
            options.args.QuestTracker.args[addonName.."Warning"] = {
                name = KTwarning,
                type = "description",
            }
            options.args.Position.args.questWatch.disabled = true
            options.args.Position.args.questWatch.args[addonName.."Warning"] = {
                name = KTwarning,
                type = "description",
            }
            return options
        end
    end
end

-- Dugi Questing Essential
local function DQE_SetCompatibility()
    if IsAddOnLoaded("DugisGuideViewerZ") then
        DugisGuideViewer:SetDB(false, DGV_MOVEWATCHFRAME)
        DugisGuideViewer:SetDB(false, DGV_WATCHFRAMEBORDER)
        function DugisGuideViewer:IncompatibleAddonLoaded()    -- R
            return true
        end
    end
end

-- Dominos
local function Dominos_SetCompatibility()
    if IsAddOnLoaded("Dominos") then
        local function ReanchorActiveButton()
            local button = KT.frame.ActiveButton
            if button and DominosFrameextra then
                button:SetParent(DominosFrameextra)
                button:ClearAllPoints()
                button:SetPoint("CENTER", 0, 0.5)
            end
        end
        hooksecurefunc(Dominos, "OnEnable", function(self)
            ReanchorActiveButton()
        end)
        hooksecurefunc(KT.ActiveButton, "OnEnable", function(self)
            ReanchorActiveButton()
        end)
    end
end

--------------
-- External --
--------------

function M:OnInitialize()
    _DBG("|cffffff00Init|r - "..self:GetName(), true)
    db = KT.db.profile
    KT:CheckAddOn("Masque", "8.0.1")
end

function M:OnEnable()
    _DBG("|cff00ff00Enable|r - "..self:GetName(), true)
    Masque_SetSupport()
    ElvUI_SetSupport()
    Tukui_SetSupport()
    RealUI_SetSupport()
    SyncUI_SetSupport()
    SpartanUI_SetSupport()
    SVUI_SetSupport()
    Chinchilla_SetCompatibility()
    DQE_SetCompatibility()
    Dominos_SetCompatibility()
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
