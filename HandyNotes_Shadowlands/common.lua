-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local Group = ns.Group
local L = ns.locale

local Map = ns.Map

local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Reward = ns.reward.Reward
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

-------------------------------------------------------------------------------

ns.expansion = 9

-------------------------------------------------------------------------------
------------------------------------ ICONS ------------------------------------
-------------------------------------------------------------------------------

local ICONS = "Interface\\Addons\\"..ADDON_NAME.."\\artwork\\icons"
local function Icon(name) return ICONS..'\\'..name..'.blp' end

ns.icons.cov_sigil_ky = {Icon('covenant_kyrian'), nil}
ns.icons.cov_sigil_nl = {Icon('covenant_necrolord'), nil}
ns.icons.cov_sigil_nf = {Icon('covenant_nightfae'), nil}
ns.icons.cov_sigil_vn = {Icon('covenant_venthyr'), nil}

-------------------------------------------------------------------------------
---------------------------------- CALLBACKS ----------------------------------
-------------------------------------------------------------------------------

ns.addon:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', function (...)
    -- Watch for a spellcast event that signals the kitten was pet.
    -- https://www.wowhead.com/spell=321337/petting
    -- Watch for a spellcast event for collecting a shard
    -- https://shadowlands.wowhead.com/spell=335400/collecting
    local _, source, _, spellID = ...
    if source == 'player' and (spellID == 321337 or spellID == 335400) then
        C_Timer.After(1, function() ns.addon:Refresh() end)
    end
end)

-------------------------------------------------------------------------------
------------------------------ CALLING TREASURES ------------------------------
-------------------------------------------------------------------------------

-- Add reward information to Blizzard's vignette treasures for callings

local GILDED_WADER = Pet({item=180866, id=2938}) -- Gilded Wader

local BLEAKWOOD_CHEST = { Pet({item=180592, id=2901}) } -- Trapped Stonefiend
local BROKEN_SKYWARD_BELL = { GILDED_WADER, Toy({item=184415}) } -- Soothing Vesper
local DECAYED_HUSK = {
    Transmog({item=179593, slot=L["cloth"]}), -- Darkreach Mask
    Transmog({item=179594, slot=L["leather"]}), -- Witherscorn Guise
}
local GILDED_CHEST = { Toy({item=184418}) } -- Acrobatic Steward
local HIDDEN_HOARD = { GILDED_WADER }
local HUNT_SHADEHOUNDS = { Mount({item=184167, id=1304}) } -- Mawsworn Soulhunter
local SECRET_TREASURE = { Pet({item=180589, id=2894}) } -- Burdened Soul
local SILVER_STRONGBOX = { GILDED_WADER }
local SLIME_COATED_CRATE = {
    Pet({item=181262, id=2952}), -- Bubbling Pustule
    Toy({item=184447}) -- Kevin's Party Supplies
}
local SPOUTING_GROWTH = { Pet({item=181173, id=2949}) } -- Skittering Venomspitter

local VIGNETTES = {
    [4173] = SECRET_TREASURE,
    [4174] = SECRET_TREASURE,
    [4175] = SECRET_TREASURE,
    [4176] = SECRET_TREASURE,
    [4177] = SECRET_TREASURE,
    [4178] = SECRET_TREASURE,
    [4179] = SECRET_TREASURE,
    [4180] = SECRET_TREASURE,
    [4181] = SECRET_TREASURE,
    [4182] = SECRET_TREASURE,
    [4202] = SPOUTING_GROWTH,
    [4212] = BLEAKWOOD_CHEST,
    [4214] = GILDED_CHEST,
    [4217] = DECAYED_HUSK,
    [4218] = DECAYED_HUSK,
    [4219] = DECAYED_HUSK,
    [4220] = DECAYED_HUSK,
    [4221] = DECAYED_HUSK,
    [4239] = BROKEN_SKYWARD_BELL,
    [4240] = BROKEN_SKYWARD_BELL,
    [4241] = BROKEN_SKYWARD_BELL,
    [4242] = BROKEN_SKYWARD_BELL,
    [4243] = BROKEN_SKYWARD_BELL,
    [4263] = SILVER_STRONGBOX,
    [4264] = SILVER_STRONGBOX,
    [4265] = SILVER_STRONGBOX,
    [4266] = SILVER_STRONGBOX,
    [4267] = SILVER_STRONGBOX,
    [4268] = SILVER_STRONGBOX,
    [4269] = SILVER_STRONGBOX,
    [4270] = SILVER_STRONGBOX,
    [4271] = SILVER_STRONGBOX,
    [4272] = SILVER_STRONGBOX,
    [4273] = SILVER_STRONGBOX,
    [4275] = BROKEN_SKYWARD_BELL,
    [4276] = HIDDEN_HOARD,
    [4277] = HIDDEN_HOARD,
    [4278] = HIDDEN_HOARD,
    [4279] = HIDDEN_HOARD,
    [4280] = HIDDEN_HOARD,
    [4281] = HIDDEN_HOARD,
    [4362] = SPOUTING_GROWTH,
    [4363] = SPOUTING_GROWTH,
    [4366] = SLIME_COATED_CRATE,
    [4460] = HUNT_SHADEHOUNDS,
    [4577] = SILVER_STRONGBOX
}

hooksecurefunc(GameTooltip, 'Show', function(self)
    local owner = self:GetOwner()
    if owner and owner.vignetteID then
        local rewards = VIGNETTES[owner.vignetteID]
        if rewards and #rewards > 0 then
            self:AddLine(' ') -- add blank line before rewards
            for i, reward in ipairs(rewards) do
                if reward:IsEnabled() then
                    reward:Render(self)
                end
            end
        end
    end
end)

-------------------------------------------------------------------------------
---------------------------------- COVENANTS ----------------------------------
-------------------------------------------------------------------------------

ns.covenants = {
    KYR = { id = 1, icon = 'cov_sigil_ky' },
    VEN = { id = 2, icon = 'cov_sigil_vn' },
    FAE = { id = 3, icon = 'cov_sigil_nf' },
    NEC = { id = 4, icon = 'cov_sigil_nl' }
}

local function ProcessCovenant (node)
    if node.covenant == nil then return end
    local data = C_Covenants.GetCovenantData(node.covenant.id)

    -- Add covenant sigil to top-right corner of tooltip
    node.rlabel = ns.GetIconLink(node.covenant.icon, 13)

    if not node._covenantProcessed then
        local subl = ns.color.Orange(string.format(L["covenant_required"], data.name))
        node.sublabel = node.sublabel and subl..'\n'..node.sublabel or subl
        node._covenantProcessed = true
    end
end

function Reward:GetCategoryIcon()
    return self.covenant and ns.GetIconPath(self.covenant.icon)
end

function Reward:IsObtainable()
    if self.covenant then
        if self.covenant.id ~= C_Covenants.GetActiveCovenantID() then
            return false
        end
    end
    return true
end

-------------------------------------------------------------------------------
----------------------------------- GROUPS ------------------------------------
-------------------------------------------------------------------------------

ns.groups.ANIMA_SHARD = Group('anima_shard', 'crystal_b', {defaults=ns.GROUP_HIDDEN})
ns.groups.BLESSINGS = Group('blessings', 1022951, {defaults=ns.GROUP_HIDDEN})
ns.groups.BONUS_BOSS = Group('bonus_boss', 'peg_rd')
ns.groups.BONUS_EVENT = Group('bonus_event', 'peg_yw')
ns.groups.CARRIAGE = Group('carriages', 'horseshoe_g', {defaults=ns.GROUP_HIDDEN})
ns.groups.DREDBATS = Group('dredbats', 'flight_point_g', {defaults=ns.GROUP_HIDDEN})
ns.groups.FAERIE_TALES = Group('faerie_tales', 355498, {defaults=ns.GROUP_HIDDEN})
ns.groups.FUGITIVES = Group('fugitives', 236247, {defaults=ns.GROUP_HIDDEN})
ns.groups.GRAPPLES = Group('grapples', 'peg_bk', {defaults=ns.GROUP_HIDDEN})
ns.groups.HYMNS = Group('hymns', 'scroll', {defaults=ns.GROUP_HIDDEN})
ns.groups.INQUISITORS = Group('inquisitors', 3528307, {defaults=ns.GROUP_HIDDEN})
ns.groups.MAW_LORE = Group('maw_lore', 'chest_gy')
ns.groups.RIFTSTONE = Group('riftstone', 'portal_b')
ns.groups.SINRUNNER = Group('sinrunners', 'horseshoe_o', {defaults=ns.GROUP_HIDDEN})
ns.groups.SLIME_CAT = Group('slime_cat', 3732497, {defaults=ns.GROUP_HIDDEN})
ns.groups.STYGIAN_CACHES = Group('stygian_caches', 'chest_nv', {defaults=ns.GROUP_HIDDEN})
ns.groups.VESPERS = Group('vespers', 3536181, {defaults=ns.GROUP_HIDDEN})

-------------------------------------------------------------------------------
------------------------------------ MAPS -------------------------------------
-------------------------------------------------------------------------------

local SLMap = Class('ShadowlandsMap', Map)

function SLMap:Prepare ()
    Map.Prepare(self)
    for coord, node in pairs(self.nodes) do
        -- Update rlabel and sublabel for covenant-restricted nodes
        ProcessCovenant(node)
    end
end

ns.Map = SLMap

-------------------------------------------------------------------------------
--------------------------------- REQUIREMENTS --------------------------------
-------------------------------------------------------------------------------

local Venari = Class('Venari', ns.requirement.Requirement)

function Venari:Initialize(quest)
    self.text = L["venari_upgrade"]
    self.quest = quest
end

function Venari:IsMet()
    return C_QuestLog.IsQuestFlaggedCompleted(self.quest)
end

ns.requirement.Venari = Venari
