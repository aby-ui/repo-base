local _, Skada = ...
-- Various silly tweaks needed to keep up with Blizzard's shenanigans.
-- Not added to core because they may not be needed/relevant forever.
Skada:AddLoadableModule("Tweaks", "Various tweaks to get around deficiences and problems in the game's combat logs. Carries a small performance penalty.", function(Skada, L)
	if Skada.db.profile.modulesBlocked.Tweaks then return end

	local orig = Skada.cleuHandler
	local function cleuHandler(timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellId, ...)
		-- Only perform these modifications if we are already in combat
		-- if Skada.current then
		-- end

		orig(timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellId, ...)
	end

	-- Skada.cleuFrame:SetScript("OnEvent", function()
	-- 	cleuHandler(CombatLogGetCurrentEventInfo())
	-- end)
end)
