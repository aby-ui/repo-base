-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class

-------------------------------------------------------------------------------
------------------------------------ GROUP ------------------------------------
-------------------------------------------------------------------------------

local Group = Class('Group')

function Group:Initialize(name, icon, attrs)
    if not name then error('Groups must be initialized with a name!') end
    if not icon then error('Groups must be initialized with an icon!') end

    self.name = name
    self.icon = icon

    self.label = L["options_icons_"..name]
    self.desc = L["options_icons_"..name.."_desc"]

    -- Prepare any links in this group label/description
    ns.PrepareLinks(self.label)
    ns.PrepareLinks(self.desc)

    if attrs then
        for k, v in pairs(attrs) do self[k] = v end
    end

    self.alphaArg = 'icon_alpha_'..self.name
    self.scaleArg = 'icon_scale_'..self.name
    self.displayArg = 'icon_display_'..self.name

    local opt_defaults = ns.optionDefaults.profile
    if not self.defaults then self.defaults = {} end
    opt_defaults[self.alphaArg] = self.defaults.alpha or 1
    opt_defaults[self.scaleArg] = self.defaults.scale or 1
    opt_defaults[self.displayArg] = self.defaults.display ~= false
end

-- Override to hide this group in the UI under certain circumstances
function Group:IsEnabled()
    if self.class and self.class ~= ns.class then return false end
    if self.faction and self.faction ~= ns.faction then return false end
    return true
end

-- Get group settings
function Group:GetAlpha() return ns:GetOpt(self.alphaArg) end
function Group:GetScale() return ns:GetOpt(self.scaleArg) end
function Group:GetDisplay() return ns:GetOpt(self.displayArg) end

-- Set group settings
function Group:SetAlpha(v) ns:SetOpt(self.alphaArg, v) end
function Group:SetScale(v) ns:SetOpt(self.scaleArg, v) end
function Group:SetDisplay(v) ns:SetOpt(self.displayArg, v) end

-------------------------------------------------------------------------------

ns.Group = Group

ns.GROUP_HIDDEN = {display=false}
ns.GROUP_HIDDEN75 = {alpha=0.75, display=false}
ns.GROUP_ALPHA75 = {alpha=0.75}

ns.groups = {
    PETBATTLE = Group('pet_battles', 'paw_y'),
    QUEST = Group('quests', 'quest_ay'),
    RARE = Group('rares', 'skull_w', {defaults=ns.GROUP_ALPHA75}),
    TREASURE = Group('treasures', 'chest_gy', {defaults=ns.GROUP_ALPHA75}),
    MISC = Group('misc', 454046),
}