-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local _, ns = ...

-------------------------------------------------------------------------------
----------------------------------- COLORS ------------------------------------
-------------------------------------------------------------------------------

ns.COLORS = {
    Blue = 'FF0066FF',
    Bronze = 'FFCD7F32',
    Gold = 'FFFFD700',
    Gray = 'FF999999',
    Green = 'FF00FF00',
    LightBlue = 'FF8080FF',
    Orange = 'FFFF8C00',
    Red = 'FFFF0000',
    Silver = 'FFC4D4E4',
    White = 'FFFFFFFF',
    Yellow = 'FFFFFF00',
    --------------------
    Heirloom = 'FF00CCFF',
    NPC = 'FFFFFD00',
    Spell = 'FF71D5FF'
}

ns.color = {}
ns.status = {}

for name, color in pairs(ns.COLORS) do
    ns.color[name] = function(t) return string.format('|c%s%s|r', color, t) end
    ns.status[name] = function(t)
        return string.format('(|c%s%s|r)', color, t)
    end
end
