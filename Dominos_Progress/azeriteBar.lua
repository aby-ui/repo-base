if not _G.C_AzeriteItem then return end

local Addon = select(2, ...)
local Dominos = _G.Dominos
local AzeriteBar = Dominos:CreateClass("Frame", Addon.ProgressBar)
local L = LibStub("AceLocale-3.0"):GetLocale("Dominos-Progress")

function AzeriteBar:Init()
    self:SetColor(Addon.Config:GetColor("azerite"))
    self:Update()
end

function AzeriteBar:GetDefaults()
    local defaults = AzeriteBar.proto.GetDefaults(self)

    defaults.y = defaults.y - 16

    return defaults
end

function AzeriteBar:Update()
    if not self:IsModeActive() then
        self:SetValues()
        self:UpdateText(L.Azerite, 0, 0, 0)
        return
    end

    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
    local powerLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
    local value, max = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)

    self:SetValues(value, max)
    self:UpdateText(L.Azerite, value, max, powerLevel)
end

function AzeriteBar:IsModeActive()
    return C_AzeriteItem.HasActiveAzeriteItem()
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes["azerite"] = AzeriteBar
Addon.AzeriteBar = AzeriteBar
