------------------------------------------------------------
-- Totem.lua
--
-- Abin
-- 2012/9/08
------------------------------------------------------------

local GetTotemInfo = GetTotemInfo

local _, addon = ...
local templates = addon.templates

local RIGHTSPELL = GetSpellInfo(36936)

local function Button_OnUpdateTimer(self, spell)
	local i
	for i = 1, 4 do
		local haveTotem, name, startTime, duration = GetTotemInfo(i)
		if haveTotem and name == spell and (startTime or 0 ) > 0 and (duration or 0) > 0 then
			return 1, startTime + duration
		end
	end
end

templates.RegisterTemplate("TOTEM", function(button)
	button.spell2 = RIGHTSPELL
	button:SetAttribute("spell2", RIGHTSPELL)
	button:SetFlyProtect()
	button.OnUpdateTimer = Button_OnUpdateTimer and "Y"
end, "DUAL")