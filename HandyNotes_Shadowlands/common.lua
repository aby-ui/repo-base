-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local Group = ns.Group
local L = ns.locale

local Map = ns.Map

local Pet = ns.reward.Pet
local Reward = ns.reward.Reward
local Toy = ns.reward.Toy

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

local VIGNETTES = {
    [4212] = {
        Pet({item=180592, id=2901}) -- Trapped Stonefiend
    }, -- Bleakwood Chest
    [4214] = {
        Toy({item=184418}) -- Acrobatic Steward
    }, -- Gilded Chest
    [4366] = {
        Toy({item=184447}) -- Kevin's Party Supplies
    }, -- Slime-Coated Crate

    -- [4174] = {}, -- Secret Treasure
    -- [4176] = {}, -- Secret Treasure
    -- [4202] = {}, -- Spouting Growth
    -- [4213] = {}, -- Enchanted Chest
    -- [4222] = {}, -- Faerie Stash
    -- [4224] = {}, -- Faerie Stash
    -- [4225] = {}, -- Faerie Stash
    -- [4238] = {}, -- Lunarlight Pod
    -- [4243] = {}, -- Skyward Bell
    -- [4244] = {}, -- Wish Cricket
    -- [4263] = {}, -- Silver Strongbox
    -- [4266] = {}, -- Silver Strongbox
    -- [4269] = {}, -- Silver Strongbox
    -- [4270] = {}, -- Silver Strongbox
    -- [4271] = {}, -- Silver Strongbox
    -- [4272] = {}, -- Silver Strongbox
    -- [4274] = {}, -- Steward's Golden Chest
    -- [4275] = {}, -- Skyward Bell
    -- [4278] = {}, -- Hidden Hoard
    -- [4279] = {}, -- Hidden Hoard
    -- [4282] = {}, -- Virtue of Penitence
    -- [4308] = {}, -- Stoneborn Satchel
    -- [4314] = {}, -- Pugilist's Prize
    -- [4317] = {}, -- Pugilist's Prize
    -- [4323] = {}, -- Stoneborn Satchel
    -- [4324] = {}, -- Stoneborn Satchel
    -- [4325] = {}, -- Stoneborn Satchel
    -- [4327] = {}, -- Stoneborn Satchel
    -- [4347] = {}, -- Greedstone
    -- [4362] = {}, -- Spouting Growth
    -- [4363] = {}, -- Spouting Growth
    -- [4374] = {}, -- Runebound Coffer
    -- [4375] = {}, -- Runebound Coffer
}

hooksecurefunc(GameTooltip, 'SetText', function(self)
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
ns.groups.INQUISITORS = Group('inquisitors', 3528307, {defaults=ns.GROUP_HIDDEN})
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
