------------------------------------------------------------
-- Statues.lua
--
-- Abin
-- 2013/7/22
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "MONK" then return end

local _, addon = ...

local button = addon:CreateActionButton("MonkOxStatue", 115315, nil, 900, "DUAL")
button:SetSpell(115315)
button:SetAttribute("spell", button.spell)
button:RequireSpell(115315)
button:SetFlyProtect()
button:SetAttribute("type2", "destroytotem")
button:SetAttribute("totem-slot2", 1)

function button:OnUpdateTimer()
	local haveTotem, name, startTime, duration = GetTotemInfo(1)
	if haveTotem and (startTime or 0 ) > 0 and (duration or 0) > 0 then
		return "NONE", startTime + duration
    end
    return "R"
end