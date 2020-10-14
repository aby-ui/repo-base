-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...

local Class = ns.Class
local Group = ns.Group
local Quest = ns.node.Quest

-------------------------------------------------------------------------------

ns.groups.ALPACA_ULDUM = Group('alpaca_uldum')
ns.groups.ALPACA_VOLDUN = Group('alpaca_voldun')
ns.groups.ASSAULT_EVENT = Group('assault_events')
ns.groups.DAILY_CHESTS = Group('daily_chests')
ns.groups.COFFERS = Group('coffers')
ns.groups.VISIONS_BUFFS = Group('visions_buffs')
ns.groups.VISIONS_CRYSTALS = Group('visions_crystals')
ns.groups.VISIONS_MAIL = Group('visions_mail')
ns.groups.VISIONS_MISC = Group('visions_misc')
ns.groups.VISIONS_CHEST = Group('visions_chest')

-------------------------------------------------------------------------------
-------------------------------- TIMED EVENTS ---------------------------------
-------------------------------------------------------------------------------

local TimedEvent = Class('TimedEvent', Quest, {
    icon = "peg_yellow",
    scale = 2,
    group = ns.groups.ASSAULT_EVENT,
    note = ''
})

function TimedEvent:PrerequisiteCompleted()
    -- Timed events that are not active today return nil here
    return C_TaskQuest.GetQuestTimeLeftMinutes(self.quest[1])
end

ns.node.TimedEvent = TimedEvent