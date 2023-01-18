
local Details = _G.Details
local detailsFramework = _G.DetailsFramework
local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true)
local addonName, Details222 = ...


Details222.Mixins.ActorMixin = {
	GetSpellContainer = function(self, containerType)
		if (containerType == "debuff") then
			return self.debuff_uptime_spells

		elseif (containerType == "buff") then
			return self.buff_uptime_spells

		elseif (containerType == "spell") then
			return self.spells
		end

	end,
}