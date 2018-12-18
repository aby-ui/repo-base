------------------------------------------------------------
-- Stance.lua
--
-- Abin
-- 2012/2/01
------------------------------------------------------------

local _, addon = ...
local templates = addon.templates

local function Button_OnUpdateTimer(self, spell1, spell2)
	if spell2 then
		self.icon2:SetActive(addon:IsFormActive(spell2))
	end
	return addon:IsFormActive(spell1) and "Y"
end

templates.RegisterTemplate("STANCE", function(button)
	button.OnUpdateTimer = Button_OnUpdateTimer
end, "PLAYER_AURA")