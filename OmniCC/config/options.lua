local _, Addon = ...
local OmniCC = _G.OmniCC
local OptionsFrame, OptionsFrameChildren

local function showOptionsMenu()
    if OptionsFrameChildren and OptionsFrameChildren[1] then
        InterfaceOptionsFrame_Show()
        InterfaceOptionsFrame_OpenToCategory(OptionsFrameChildren[1])
    end
end

-- register with omnicc
OmniCC.ShowOptionsMenu = showOptionsMenu

-- setup the options frame parent
OptionsFrame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
OptionsFrame:Hide()
OptionsFrame.name = "OmniCC"
OptionsFrame:SetScript("OnShow", showOptionsMenu)
InterfaceOptions_AddCategory(OptionsFrame)

-- create the options menu child frames
local options = {
    type = "group",
    args = {
        themes = Addon.ThemeOptions,
        rules = Addon.RuleOptions,
        profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(OmniCC.db, true)
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("OmniCC", options)

OptionsFrameChildren = {
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("OmniCC", options.args.themes.name, "OmniCC", "themes"),
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("OmniCC", options.args.rules.name, "OmniCC", "rules"),
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("OmniCC", options.args.profiles.name, "OmniCC", "profiles")
}

function Addon:OnProfileChanged()
    self:RefreshThemeOptions()
    self:RefreshRuleOptions()
end

OmniCC.db.RegisterCallback(Addon, "OnProfileChanged", "OnProfileChanged")
OmniCC.db.RegisterCallback(Addon, "OnProfileCopied", "OnProfileChanged")
OmniCC.db.RegisterCallback(Addon, "OnProfileReset", "OnProfileChanged")
