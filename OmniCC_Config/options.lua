local _, Addon = ...
local OmniCC = _G.OmniCC

-- create the options menu child frames
local options = {
    type = 'group',
    childGroups = "tab",
    args = {
        themes = Addon.ThemeOptions,
        rules = Addon.RuleOptions,
        profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(OmniCC.db, true)
    }
}

options.args.themes.order = 100
options.args.rules.order = 200
options.args.profiles.order = 300

LibStub('AceConfig-3.0'):RegisterOptionsTable("OmniCC", options)

function Addon:OnProfileChanged()
    self:RefreshThemeOptions()
    self:RefreshRuleOptions()
end

OmniCC.db.RegisterCallback(Addon, 'OnProfileChanged', 'OnProfileChanged')
OmniCC.db.RegisterCallback(Addon, 'OnProfileCopied', 'OnProfileChanged')
OmniCC.db.RegisterCallback(Addon, 'OnProfileReset', 'OnProfileChanged')
