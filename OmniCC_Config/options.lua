local _, Addon = ...
local OmniCC = _G.OmniCC
local OptionsFrame, OptionsFrameChildren

local function showOptionsMenu()
    if not OptionsFrameChildren then
        return
    end

    local _, child = next(OptionsFrameChildren)

    if child then
        InterfaceOptionsFrame_OpenToCategory(child)
    end
end

-- setup the options frame parent
OptionsFrame = OmniCC.frame
OptionsFrame:SetScript('OnShow', showOptionsMenu)

-- create the options menu child frames
local options = {
    type = 'group',
    args = {
        themes = Addon.ThemeOptions,
        rules = Addon.RuleOptions,
        profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(OmniCC.db, true)
    }
}

LibStub('AceConfig-3.0'):RegisterOptionsTable(OptionsFrame.name, options)

OptionsFrameChildren = {
    LibStub('AceConfigDialog-3.0'):AddToBlizOptions(
        OptionsFrame.name,
        options.args.themes.name,
        OptionsFrame.name,
        'themes'
    ),
    LibStub('AceConfigDialog-3.0'):AddToBlizOptions(
        OptionsFrame.name,
        options.args.rules.name,
        OptionsFrame.name,
        'rules'
    ),
    LibStub('AceConfigDialog-3.0'):AddToBlizOptions(
        OptionsFrame.name,
        options.args.profiles.name,
        OptionsFrame.name,
        'profiles'
    )
}

function Addon:OnProfileChanged()
    self:RefreshThemeOptions()
    self:RefreshRuleOptions()
end

OmniCC.db.RegisterCallback(Addon, 'OnProfileChanged', 'OnProfileChanged')
OmniCC.db.RegisterCallback(Addon, 'OnProfileCopied', 'OnProfileChanged')
OmniCC.db.RegisterCallback(Addon, 'OnProfileReset', 'OnProfileChanged')

-- open to the main category if the options menu is already shown
if OptionsFrame:IsShown() then
    showOptionsMenu()
end