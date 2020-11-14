-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...

-------------------------------------------------------------------------------
----------------------------------- COLORS ------------------------------------
-------------------------------------------------------------------------------

ns.COLORS = {
    Blue = 'FF0066FF',
    Green = 'FF00FF00',
    Gray = 'FF999999',
    Red = 'FFFF0000',
    Orange = 'FFFF8C00',
    Yellow = 'FFFFFF00',
    White = 'FFFFFFFF',
    --------------------
    NPC = 'FFFFFD00',
    Spell = 'FF71D5FF'
}

ns.color = {}
ns.status = {}

for name, color in pairs(ns.COLORS) do
    ns.color[name] = function (t) return string.format('|c%s%s|r', color, t) end
    ns.status[name] = function (t) return string.format('(|c%s%s|r)', color, t) end
end