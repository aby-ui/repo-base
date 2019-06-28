

---  OLD Watcher Code

--[[
-- Threat Functions List
local ThreatFunctionList = {
	[ScaleFunctionByThreat] = true,
	[AlphaFunctionByThreat] = true,
	[ColorFunctionByThreat] = true,
	[NameColorByThreat] = true,
	[WarningBorderFunctionByThreat] = true,
}
--]]



	-- 6.0 Disabled
	-- Healer Tracker
	--[[
	if (ScaleFunctionsUniversal[LocalVars.ScaleSpotlightMode] == ScaleFunctionByEnemyHealer) or
		AlphaFunctionsFriendly[LocalVars.FriendlySpotlightMode] == AlphaFunctionByEnemyHealer or
		AlphaFunctionsEnemy[LocalVars.EnemySpotlightMode] == AlphaFunctionByEnemyHealer or
		WarningBorderFunctionsUniversal[LocalVars.ColorDangerGlowMode] ~= DummyFunction then
			TidyPlatesUtility:EnableHealerTrack()

	else
		TidyPlatesUtility:DisableHealerTrack()
	end
	--]]

	-- Aggro/Threat
	-- Checks to see if the player is using any of the By Threat modes
	-- FriendlyBarFunctions


	-- 6.0 Disabled
	--if	ThreatFunctionList[EnemyBarFunctions[LocalVars.ColorEnemyBarMode]] or
	--	ThreatFunctionList[NameColorFunctions[LocalVars.ColorEnemyNameMode]] or
	--	ThreatFunctionList[FriendlyBarFunctions[LocalVars.ColorFriendlyBarMode]] or
	--	ThreatFunctionList[NameColorFunctions[LocalVars.ColorFriendlyNameMode]] or
	--	ThreatFunctionList[AlphaFunctionsEnemy[LocalVars.EnemyAlphaSpotlightMode]] or
	--	ThreatFunctionList[AlphaFunctionsFriendly[LocalVars.FriendlyAlphaSpotlightMode]] or
	--	ThreatFunctionList[ScaleFunctionsUniversal[LocalVars.ScaleSpotlightMode]] or
	--	ThreatFunctionList[NameColorFunctions[LocalVars.HeadlineEnemyColor]] or
	--	ThreatFunctionList[NameColorFunctions[LocalVars.HeadlineFriendlyColor]]
	--	or LocalVars.ThreatGlowEnable2 then

	--		SetCVar("threatWarning", 3)
	--end

	--if LocalVars.ColorEnableOffTank then
	--		TidyPlatesWidgets:EnableTankWatch()	-- Off-Tank support		-- Lots of shtuff depends on this.
	--else TidyPlatesWidgets:DisableTankWatch() end

	-- 6.0 Disabled
	--if LocalVars.ColorShowPartyAggro then TidyPlatesWidgets:EnableAggroWatch()	-- Group aggro holders
	--else TidyPlatesWidgets:DisableAggroWatch() end

	--SetCVar("threatWarning", 3)		-- Required for threat/aggro detection