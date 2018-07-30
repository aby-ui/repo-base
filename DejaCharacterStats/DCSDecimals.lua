local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization
local _, gdbprivate = ...
local doll_tooltip_format = namespace.doll_tooltip_format --PAPERDOLLFRAME_TOOLTIP_FORMAT
local highlight_code = namespace.highlight_code --HIGHLIGHT_FONT_COLOR_CODE
local font_color_close = namespace.font_color_close --FONT_COLOR_CODE_CLOSE
-- Decimal Check
local notinteger
local my_floor = math.floor
--local _, dcs_format = ... --seems like shared upvaluing of tables isn't so easy
local dcs_format = format
local function round(x)
	return my_floor(x+0.5)
end
local statformat
local multiplier
local notexactlyzero
--hideatzero gets used in DCSLayouts, so there's small use to make faster access to it here.

local function DCS_Decimals()
		--version with localisation of PAPERDOLLFRAME_TOOLTIP_FORMAT, HIGHLIGHT_FONT_COLOR_CODE and FONT_COLOR_CODE_CLOSE (doll_tooltip_format, highlight_code and font_color_close)
	-- Crit Chance
		--setting of statformat and multiplier values is done by calling function for checkbox (in OnEvent and OnClick)
		--[[
		if notinteger then
			statformat = "%.2f%%"
			multiplier = 100
		else
			statformat = "%.0f%%"
			multiplier = 1
		end

		local notexactlyzero = gdbprivate.gdb.gdbdefaults.dejacharacterstatsDCSZeroChecked.SetChecked
		--]]
		
		function PaperDollFrame_SetCritChance(statFrame, unit)
			if ( unit ~= "player" ) then
				statFrame:Hide();
				return;
			end

			local rating;
			local spellCrit, rangedCrit, meleeCrit;
			local critChance;

			-- Start at 2 to skip physical damage
			local holySchool = 2;
			local minCrit = GetSpellCritChance(holySchool);
			statFrame.spellCrit = {};
			statFrame.spellCrit[holySchool] = minCrit;
			--local spellCrit;
			for i=(holySchool+1), MAX_SPELL_SCHOOLS do
				spellCrit = GetSpellCritChance(i);
				minCrit = min(minCrit, spellCrit);
				statFrame.spellCrit[i] = spellCrit;
			end
			spellCrit = minCrit
			rangedCrit = GetRangedCritChance();
			meleeCrit = GetCritChance();

			if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
				critChance = spellCrit;
				rating = CR_CRIT_SPELL;
			elseif (rangedCrit >= meleeCrit) then
				critChance = rangedCrit;
				rating = CR_CRIT_RANGED;
			else
				critChance = meleeCrit;
				rating = CR_CRIT_MELEE;
			end
		-- PaperDollFrame_SetLabelAndText Format Change
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, dcs_format(statformat, critChance), false, round(multiplier*critChance)/multiplier);
			else --in PaperDollFrame.lua true instead of false
				PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, dcs_format(statformat, critChance), false, critChance);
			end
			--PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, format(statformat1, critChance), true, format(statformat1, critChance)); --can't do it because PaperDollFrame_SetLabelAndText converts to integer
			statFrame.tooltip = highlight_code..dcs_format(doll_tooltip_format, STAT_CRITICAL_STRIKE).." "..dcs_format("%.2f%%", critChance)..font_color_close;
			local extraCritChance = GetCombatRatingBonus(rating);
			local extraCritRating = GetCombatRating(rating);
			if (GetCritChanceProvidesParryEffect()) then
				statFrame.tooltip2 = dcs_format(CR_CRIT_PARRY_RATING_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance, GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating));
			else
				statFrame.tooltip2 = dcs_format(CR_CRIT_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance);
			end
			statFrame:Show();
		end

	-- Haste Chance
		function PaperDollFrame_SetHaste(statFrame, unit)
			if ( unit ~= "player" ) then
				statFrame:Hide();
				return;
			end

			local haste = GetHaste();
			local rating = CR_HASTE_MELEE;

			local hasteFormatString;
			if (haste < 0 and not GetPVPGearStatRules()) then
				hasteFormatString = RED_FONT_COLOR_CODE.."%s"..font_color_close;
			else
				hasteFormatString = "+%s";
			end
		-- PaperDollFrame_SetLabelAndText Format Change
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE, dcs_format(hasteFormatString, dcs_format(statformat, haste)), false, round(multiplier*haste)/multiplier);
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE, dcs_format(hasteFormatString, dcs_format(statformat, haste)), false, haste);
			end

			statFrame.tooltip = highlight_code .. dcs_format(doll_tooltip_format, STAT_HASTE) .. " " .. dcs_format(hasteFormatString, dcs_format("%.2f%%", haste)) .. font_color_close;

			local _, class = UnitClass(unit);
			statFrame.tooltip2 = _G["STAT_HASTE_"..class.."_TOOLTIP"];
			if (not statFrame.tooltip2) then
				statFrame.tooltip2 = STAT_HASTE_TOOLTIP;
			end
			statFrame.tooltip2 = statFrame.tooltip2 .. dcs_format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(rating)), GetCombatRatingBonus(rating));

			statFrame:Show();
		end

	-- Versatility
		function PaperDollFrame_SetVersatility(statFrame, unit)
			if ( unit ~= "player" ) then
				statFrame:Hide();
				return;
			end

			local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE);
			local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
			local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN);
		-- PaperDollFrame_SetLabelAndText Format Change
			--local result
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, dcs_format(statformat, versatilityDamageBonus) .. " / " .. dcs_format(statformat, versatilityDamageTakenReduction), false, round(multiplier*versatilityDamageBonus)/multiplier);
				--result = round(multiplier*versatilityDamageBonus)/multiplier
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, dcs_format(statformat, versatilityDamageBonus) .. " / " .. dcs_format(statformat, versatilityDamageTakenReduction), false, versatilityDamageBonus);
				--result = versatilityDamageBonus
			end
			--print("vesratility",result)
			statFrame.tooltip = highlight_code .. dcs_format(VERSATILITY_TOOLTIP_FORMAT, STAT_VERSATILITY, versatilityDamageBonus, versatilityDamageTakenReduction) .. font_color_close;
			statFrame.tooltip2 = dcs_format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction, BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction);

			statFrame:Show();
		end

	-- Mastery
		function PaperDollFrame_SetMastery(statFrame, unit)
			if ( unit ~= "player" ) then
				statFrame:Hide();
				return;
			end
			--if (UnitLevel("player") < SHOW_MASTERY_LEVEL) then
			--	statFrame:Hide();
			--	return;
			--end
			local color_mastery 
			if namespace.locale == "zhTW" then
				color_mastery = STAT_MASTERY .. "：" --Chinese colon
			else
				color_mastery = STAT_MASTERY ..":"
			end
			local color_format = statformat
			if (UnitLevel("player") < SHOW_MASTERY_LEVEL) then
				color_mastery = "|cff7f7f7f" .. color_mastery .. "|r"
				color_format = "|cff7f7f7f" .. color_format .. "|r"
			end
			local mastery = GetMasteryEffect();
		-- PaperDollFrame_SetLabelAndText Format Change
    
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, "", dcs_format(color_format, mastery), false, round(multiplier*mastery)/multiplier);
			else
				PaperDollFrame_SetLabelAndText(statFrame, "", dcs_format(color_format, mastery), false, mastery);
			end
			statFrame.Label:SetText(color_mastery)
			statFrame.onEnterFunc = Mastery_OnEnter;
			statFrame:Show();
		end
			

	-- Leech (Lifesteal)
		function PaperDollFrame_SetLifesteal(statFrame, unit)
			if ( unit ~= "player" ) then
				statFrame:Hide();
				return;
			end

			local lifesteal = GetLifesteal();
		-- PaperDollFrame_SetLabelAndText Format Change
			--local result
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_LIFESTEAL, dcs_format(statformat, lifesteal), false, round(multiplier*lifesteal)/multiplier);
				--result = round(multiplier*lifesteal)/multiplier
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_LIFESTEAL, dcs_format(statformat, lifesteal), false, lifesteal);
				--result = lifesteal
			end
			--print("leech",result)
			statFrame.tooltip = highlight_code .. dcs_format(doll_tooltip_format, STAT_LIFESTEAL) .. " " .. dcs_format("%.2f%%", lifesteal) .. font_color_close;

			statFrame.tooltip2 = dcs_format(CR_LIFESTEAL_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_LIFESTEAL)), GetCombatRatingBonus(CR_LIFESTEAL));

			statFrame:Show();
		end

	-- Avoidance
		function PaperDollFrame_SetAvoidance(statFrame, unit)
			if ( unit ~= "player" ) then
				statFrame:Hide();
				return;
			end

			local avoidance = GetAvoidance();
		-- PaperDollFrame_SetLabelAndText Format Change
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_AVOIDANCE, dcs_format(statformat, avoidance), false, round(multiplier*avoidance)/multiplier);
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_AVOIDANCE, dcs_format(statformat, avoidance), false, avoidance);
			end
			statFrame.tooltip = highlight_code .. dcs_format(doll_tooltip_format, STAT_AVOIDANCE) .. " " .. dcs_format("%.2f%%", avoidance) .. font_color_close;

			statFrame.tooltip2 = dcs_format(CR_AVOIDANCE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_AVOIDANCE)), GetCombatRatingBonus(CR_AVOIDANCE));

			statFrame:Show();
		end

	-- Dodge Chance
		function PaperDollFrame_SetDodge(statFrame, unit)
			if (unit ~= "player") then
				statFrame:Hide();
				return;
			end

			local chance = GetDodgeChance();
		-- PaperDollFrame_SetLabelAndText Format Change
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, dcs_format(statformat, chance), false, round(multiplier*chance)/multiplier);
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, dcs_format(statformat, chance), false, chance);
			end
			statFrame.tooltip = highlight_code..dcs_format(doll_tooltip_format, DODGE_CHANCE).." "..string.format("%.2f", chance).."%"..font_color_close;
			statFrame.tooltip2 = dcs_format(CR_DODGE_TOOLTIP, GetCombatRating(CR_DODGE), GetCombatRatingBonus(CR_DODGE));
			statFrame:Show();
		end

	-- Parry Chance
		function PaperDollFrame_SetParry(statFrame, unit)
			if (unit ~= "player") then
				statFrame:Hide();
				return;
			end

			local chance = GetParryChance();
		-- PaperDollFrame_SetLabelAndText Format Change
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, dcs_format(statformat, chance), false, round(multiplier*chance)/multiplier);
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, dcs_format(statformat, chance), false, chance);
			end
			statFrame.tooltip = highlight_code..dcs_format(doll_tooltip_format, PARRY_CHANCE).." "..dcs_format("%.2f", chance).."%"..font_color_close;
			statFrame.tooltip2 = dcs_format(CR_PARRY_TOOLTIP, GetCombatRating(CR_PARRY), GetCombatRatingBonus(CR_PARRY));
			statFrame:Show();
		end

	-- Block Chance
		function PaperDollFrame_SetBlock(statFrame, unit)
			if (unit ~= "player") then
				statFrame:Hide();
				return;
			end

			local chance = GetBlockChance();
		-- PaperDollFrame_SetLabelAndText Format Change
			if notexactlyzero then
				PaperDollFrame_SetLabelAndText(statFrame, STAT_BLOCK, dcs_format(statformat, chance), false, round(multiplier*chance)/multiplier);
			else
				PaperDollFrame_SetLabelAndText(statFrame, STAT_BLOCK, dcs_format(statformat, chance), false, chance);
			end
			statFrame.tooltip = highlight_code..dcs_format(doll_tooltip_format, BLOCK_CHANCE).." "..dcs_format("%.2f", chance).."%"..font_color_close;
			local shieldBlockArmor = GetShieldBlock();
			local blockArmorReduction = PaperDollFrame_GetArmorReduction(shieldBlockArmor, UnitEffectiveLevel(unit));
			local blockArmorReductionAgainstTarget = PaperDollFrame_GetArmorReductionAgainstTarget(shieldBlockArmor);
			statFrame.tooltip2 = CR_BLOCK_TOOLTIP:format(blockArmorReduction);
			--statFrame.tooltip2 = dcs_format(CR_BLOCK_TOOLTIP, GetShieldBlock());
			if (blockArmorReductionAgainstTarget) then
				statFrame.tooltip3 = format(STAT_BLOCK_TARGET_TOOLTIP, blockArmorReductionAgainstTarget);
			else
				statFrame.tooltip3 = nil;
			end
			statFrame:Show();
		end
		--PaperDollFrame_UpdateStats() -- needs to get called for checkbox Decimals; will get called for clicks in checkboxes but not during login
end

	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsShowDecimalsChecked = {
		SetChecked = true,
	}	

local function set_statformat_multiplier_value()
		if notinteger then
			statformat = "%.2f%%"
			multiplier = 100
		else
			statformat = "%.0f%%"
			multiplier = 1
		end
end

local DCS_DecimalCheck = CreateFrame("CheckButton", "DCS_DecimalCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_DecimalCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_DecimalCheck:ClearAllPoints()
	--DCS_DecimalCheck:SetPoint("TOPLEFT", 30, -205)
	DCS_DecimalCheck:SetPoint("TOPLEFT", "dcsStatsPanelcategoryFS", 7, -55) 
	DCS_DecimalCheck:SetScale(1)
	DCS_DecimalCheck.tooltipText = L["Displays 'Enhancements' category stats to two decimal places."] --Creates a tooltip on mouseover.
	_G[DCS_DecimalCheck:GetName() .. "Text"]:SetText(L["Decimals"])
	
	DCS_DecimalCheck:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then
			notinteger= gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDecimalsChecked.SetChecked
			self:SetChecked(notinteger)
			set_statformat_multiplier_value()
			--local status = self:GetChecked(true) --???
			--DCS_Decimals(status)
			DCS_Decimals() --PaperDollFrame_UpdateStats() here isn't needed
			--gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDecimalsChecked.SetChecked = status --???
		end
	end)

	DCS_DecimalCheck:SetScript("OnClick", function(self,event,arg1) 
		--local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDecimalsChecked
		notinteger = self:GetChecked(true)
		set_statformat_multiplier_value()
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDecimalsChecked.SetChecked = notinteger
		DCS_Decimals()
		PaperDollFrame_UpdateStats() --for Enhancements to have updated accuracy and visibility
	end)

	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsHideAtZeroChecked = {
		SetChecked = true,
	}
	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsDCSZeroChecked = { 
		SetChecked = false, 
	} 
	
local DCS_BlizHideAtZero = CreateFrame("CheckButton", "DCS_BlizHideAtZero", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate") 
local DCS_DCSHideAtZero = CreateFrame("CheckButton", "DCS_DCSHideAtZero", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate") 
	DCS_DCSHideAtZero:RegisterEvent("PLAYER_LOGIN") 
	DCS_DCSHideAtZero:ClearAllPoints() 
	--DCS_DCSHideAtZero:SetPoint("TOPLEFT", 25, -150) 
	--DCS_DCSHideAtZero:SetPoint("TOPLEFT", 30, -165) 
	DCS_DCSHideAtZero:SetPoint("TOPLEFT", "dcsStatsPanelcategoryFS", 7, -15) 
	DCS_DCSHideAtZero:SetScale(1) 
	DCS_DCSHideAtZero.tooltipText = L["Hides 'Enhancements' stats if their displayed value would be zero. Checking 'Decimals' changes the displayed value."] --Creates a tooltip on mouseover. 
	_G[DCS_DCSHideAtZero:GetName() .. "Text"]:SetText(L["DCS's Hide At Zero"]) 
	
DCS_DCSHideAtZero:SetScript("OnEvent", function(self, event) 
	if event == "PLAYER_LOGIN" then 
		--local status = gdbprivate.gdb.gdbdefaults.dejacharacterstatsHideAtZeroChecked.SetChecked
		--local DCSstatus = gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsDCSZeroChecked.SetChecked
		notexactlyzero = gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsDCSZeroChecked.SetChecked
		local hideatzero = gdbprivate.gdb.gdbdefaults.dejacharacterstatsHideAtZeroChecked.SetChecked
		if hideatzero then
			self:SetChecked(notexactlyzero)
			DCS_BlizHideAtZero:SetChecked(not notexactlyzero) 
		else
			self:SetChecked(false)
			DCS_BlizHideAtZero:SetChecked(false)
		end
	end
end) 
 
DCS_DCSHideAtZero:SetScript("OnClick", function(self) 
	--local status = self:GetChecked() 
	--gdbprivate.gdb.gdbdefaults.dejacharacterstatsHideAtZeroChecked.SetChecked = status
	--gdbprivate.gdb.gdbdefaults.dejacharacterstatsDCSZeroChecked.SetChecked = status
	notexactlyzero = not notexactlyzero
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsHideAtZeroChecked.SetChecked = notexactlyzero
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsDCSZeroChecked.SetChecked = notexactlyzero
	if notexactlyzero then  
		DCS_BlizHideAtZero:SetChecked(false)  
	end 
	DCS_Decimals() 
	PaperDollFrame_UpdateStats() --for Enhancements to have updated accuracy and visibility
end) 

 _G[DCS_BlizHideAtZero:GetName() .. "Text"]:SetText(L["Blizzard's Hide At Zero"] ) 

DCS_BlizHideAtZero:ClearAllPoints() 
--DCS_BlizHideAtZero:SetPoint("TOPLEFT", 50, -220) 
--DCS_BlizHideAtZero:SetPoint("TOPLEFT", 30, -185) 
DCS_BlizHideAtZero:SetPoint("TOPLEFT", "dcsStatsPanelcategoryFS", 7, -35) 
DCS_BlizHideAtZero:SetScale(1) 
DCS_BlizHideAtZero.tooltipText = L["Hides 'Enhancements' stats only if their numerical value is exactly zero. For example, if stat value is 0.001%, then it would be displayed as 0%."] --Creates a tooltip on mouseover. 

DCS_BlizHideAtZero:SetScript("OnClick", function(self)  
	local status = self:GetChecked() 
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsHideAtZeroChecked.SetChecked = status
	if status then  
		DCS_DCSHideAtZero:SetChecked(false) 
		notexactlyzero = false
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsDCSZeroChecked.SetChecked = false 
	end 
	DCS_Decimals() 
	PaperDollFrame_UpdateStats() --for Enhancements to have updated accuracy and visibility
end)
