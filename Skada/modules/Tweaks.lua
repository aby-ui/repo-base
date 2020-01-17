-- Various silly tweaks needed to keep up with Blizzard's shenanigans. Not added to core because they may not be needed/relevant forever.
Skada:AddLoadableModule("Tweaks", "Various tweaks to get around deficiences and problems in the game's combat logs. Carries a small performance penalty.", function(Skada, L)
	if Skada.db.profile.modulesBlocked.Tweaks then return end

	local band = bit.band

	local PET_FLAG = COMBATLOG_OBJECT_TYPE_PET
	local MINE_FLAG = COMBATLOG_OBJECT_AFFILIATION_MINE

	local check_pet = {}

	local orig = Skada.cleuHandler
	local function cleuHandler(timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellId, ...)
		-- Only perform these modifications if we are already in combat
		if Skada.current then
			-- Handle the Animal Companion Hunter pet (BM talent)
			if spellId == 34026 then -- SPELL_CAST_SUCCESS Kill Command (player)
				check_pet.timestamp = timestamp
				check_pet.name = srcName
				check_pet.guid = srcGUID
			elseif spellId == 83381 and check_pet.timestamp == timestamp and not Skada:GetPetOwner(srcGUID) then -- SPELL_DAMAGE Kill Command (pets)
				Skada:AssignPet(check_pet.guid, check_pet.name, srcGUID)
			end
		end

		orig(timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellId, ...)
	end

	Skada.cleuFrame:SetScript("OnEvent", function()
		cleuHandler(CombatLogGetCurrentEventInfo())
	end)
end)
