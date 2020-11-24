-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale

local Class = ns.Class
local Group = ns.Group
local Map = ns.Map

local Node = ns.node.Node
local Quest = ns.node.Quest
local Achievement = ns.reward.Achievement

-------------------------------------------------------------------------------

ns.expansion = 8

-------------------------------------------------------------------------------

ns.groups.ASSAULT_EVENT = Group('assault_events', 'peg_wy')
ns.groups.BOW_TO_YOUR_MASTERS = Group('bow_to_your_masters', 1850548, {defaults=ns.GROUP_HIDDEN, faction='Horde'})
ns.groups.BRUTOSAURS = Group('brutosaurs', 1881827, {defaults=ns.GROUP_HIDDEN})
ns.groups.CARVED_IN_STONE = Group('carved_in_stone', 134424, {defaults=ns.GROUP_HIDDEN})
ns.groups.CATS_NAZJ = Group('cats_nazj', 454045)
ns.groups.COFFERS = Group('coffers', 'star_chest_g')
ns.groups.DAILY_CHESTS = Group('daily_chests', 'chest_bl', {defaults=ns.GROUP_ALPHA75})
ns.groups.DRUST_FACTS = Group('drust_facts', 2101971, {defaults=ns.GROUP_HIDDEN})
ns.groups.DUNE_RIDER = Group('dune_rider', 134962, {defaults=ns.GROUP_HIDDEN})
ns.groups.EMBER_RELICS = Group('ember_relics', 514016, {defaults=ns.GROUP_HIDDEN, faction='Alliance'})
ns.groups.GET_HEKD = Group('get_hekd', 1604165, {defaults=ns.GROUP_HIDDEN})
ns.groups.HONEYBACKS = Group('honeybacks', 2066005, {defaults=ns.GROUP_HIDDEN, faction='Alliance'})
ns.groups.HOPPIN_SAD = Group('hoppin_sad', 804969, {defaults=ns.GROUP_HIDDEN})
ns.groups.LIFE_FINDS_A_WAY = Group('life_finds_a_way', 236192, {defaults=ns.GROUP_HIDDEN})
ns.groups.LOCKED_CHEST = Group('locked_chest', 'chest_gy', {defaults=ns.GROUP_ALPHA75})
ns.groups.MECH_CHEST = Group('mech_chest', 'chest_rd', {defaults=ns.GROUP_ALPHA75})
ns.groups.MISC_NAZJ = Group('misc_nazj', 528288)
ns.groups.MUSHROOM_HARVEST = Group('mushroom_harvest', 1869654, {defaults=ns.GROUP_HIDDEN})
ns.groups.PAKU_TOTEMS = Group('paku_totems', 'flight_point_y', {defaults=ns.GROUP_HIDDEN, faction='Horde'})
ns.groups.PRISMATICS = Group('prismatics', 'crystal_p', {defaults=ns.GROUP_HIDDEN})
ns.groups.RECRIG = Group('recrig', 'peg_wb')
ns.groups.SAUSAGE_SAMPLER = Group('sausage_sampler', 133200, {defaults=ns.GROUP_HIDDEN, faction='Alliance'})
ns.groups.SCAVENGER_OF_THE_SANDS = Group('scavenger_of_the_sands', 135725, {defaults=ns.GROUP_HIDDEN})
ns.groups.SECRET_SUPPLY = Group('secret_supplies', 'star_chest_b', {defaults=ns.GROUP_HIDDEN75})
ns.groups.SHANTY_RAID = Group('shanty_raid', 1500866, {defaults=ns.GROUP_HIDDEN})
ns.groups.SLIMES_NAZJ = Group('slimes_nazj', 132107)
ns.groups.SUPPLY = Group('supplies', 'star_chest_g', {defaults=ns.GROUP_HIDDEN75})
ns.groups.TALES_OF_DE_LOA = Group('tales_of_de_loa', 1875083, {defaults=ns.GROUP_HIDDEN})
ns.groups.THREE_SHEETS = Group('three_sheets', 135999, {defaults=ns.GROUP_HIDDEN})
ns.groups.TIDESAGE_LEGENDS = Group('tidesage_legends', 1500881, {defaults=ns.GROUP_HIDDEN})
ns.groups.UPRIGHT_CITIZENS = Group('upright_citizens', 516667, {defaults=ns.GROUP_HIDDEN, faction='Alliance'})
ns.groups.VISIONS_BUFFS = Group('visions_buffs', 132183)
ns.groups.VISIONS_CHEST = Group('visions_chest', 'chest_gy')
ns.groups.VISIONS_CRYSTALS = Group('visions_crystals', 'crystal_o')
ns.groups.VISIONS_MAIL = Group('visions_mail', 'envelope')
ns.groups.VISIONS_MISC = Group('visions_misc', 2823166)

-------------------------------------------------------------------------------
---------------------------------- CALLBACKS ----------------------------------
-------------------------------------------------------------------------------

-- Listen for aura applied/removed events so we can refresh when the player
-- enters and exits the alternate future
ns.addon:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', function ()
    local _,e,_,_,_,_,_,_,t,_,_,s  = CombatLogGetCurrentEventInfo()
    if (e == 'SPELL_AURA_APPLIED' or e == 'SPELL_AURA_REMOVED') and
        t == UnitName('player') and s == 296644 then
        C_Timer.After(1, function() ns.addon:Refresh() end)
    end
end)

ns.addon:RegisterEvent('QUEST_ACCEPTED', function (_, _, id)
    if id == 56540 then
        ns.Debug('Vale assaults unlock detected')
        C_Timer.After(1, function() ns.addon:Refresh() end)
    end
end)

ns.addon:RegisterEvent('QUEST_WATCH_UPDATE', function (_, index)
    local info = C_QuestLog.GetInfo(index)
    if info and info.questID == 56376 then
        ns.Debug('Uldum assaults unlock detected')
        C_Timer.After(1, function() ns.addon:Refresh() end)
    end
end)

ns.addon:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', function (...)
    -- Watch for a spellcast event that signals a ravenous slime was fed
    -- https://www.wowhead.com/spell=293775/schleimphage-feeding-tracker
    local _, source, _, spellID = ...
    if source == 'player' and spellID == 293775 then
        C_Timer.After(1, function() ns.addon:Refresh() end)
    end
end)

-------------------------------------------------------------------------------
-------------------------------- TIMED EVENTS ---------------------------------
-------------------------------------------------------------------------------

local TimedEvent = Class('TimedEvent', Quest, {
    icon = "peg_wy",
    scale = 2,
    group = ns.groups.ASSAULT_EVENT,
    note = ''
})

function TimedEvent:PrerequisiteCompleted()
    -- Timed events that are not active today return nil here
    return C_TaskQuest.GetQuestTimeLeftMinutes(self.quest[1])
end

ns.node.TimedEvent = TimedEvent

-------------------------------------------------------------------------------
------------------------------ WAR SUPPLY CRATES ------------------------------
-------------------------------------------------------------------------------

-- quest = 53640 (50 conquest looted for today)

ns.node.Supply = Class('Supply', Node, {
    icon = 'star_chest_g',
    scale = 1.5,
    label = L["supply_chest"],
    rlabel = ns.GetIconLink('war_mode_swords', 16),
    note=L["supply_chest_note"],
    requires = ns.requirement.WarMode,
    rewards={ Achievement({id=12572}) },
    group = ns.groups.SUPPLY
})

ns.node.SecretSupply = Class('SecretSupply', ns.node.Supply, {
    icon = 'star_chest_b',
    group = ns.groups.SECRET_SUPPLY,
    label = L["secret_supply_chest"],
    note = L["secret_supply_chest_note"]
})

ns.node.Coffer = Class('Coffer', Node, {
    icon = 'star_chest_g',
    scale = 1.5,
    group = ns.groups.COFFERS
})

-------------------------------------------------------------------------------
----------------------------- VISIONS ASSAULT MAP -----------------------------
-------------------------------------------------------------------------------

local VisionsMap = Class('VisionsMap', Map)

function VisionsMap:Prepare()
    Map.Prepare(self)
    self.assault = self.GetAssault()
    self.phased = self.assault ~= nil
end

function VisionsMap:IsNodeEnabled(node, coord, minimap)
    local assault = node.assault
    if assault then
        assault = type(assault) == 'number' and {assault} or assault
        for i=1, #assault + 1, 1 do
            if i > #assault then return false end
            if assault[i] == self.assault then break end
        end
    end

    return Map.IsNodeEnabled(self, node, coord, minimap)
end

ns.VisionsMap = VisionsMap

-------------------------------------------------------------------------------
-------------------------------- WARFRONT MAP ---------------------------------
-------------------------------------------------------------------------------

local WarfrontMap = Class('WarfrontMap', Map)

function WarfrontMap:IsNodeEnabled(node, coord, minimap)
    -- Disable nodes that are not available when the other faction controls
    if node.controllingFaction then
        local state = C_ContributionCollector.GetState(self.collector)
        local faction = (state == 1 or state == 2) and 'Alliance' or 'Horde'
        if faction ~= node.controllingFaction then return false end
    end
    return Map.IsNodeEnabled(self, node, coord, minimap)
end

ns.WarfrontMap = WarfrontMap