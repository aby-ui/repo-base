
function EUF_TargetInfo_OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
end

function EUF_TargetInfo_OnEvent(self, event, ...)	
	if event == "PLAYER_TARGET_CHANGED" then
		EUF_TargetInfoClass_Update();		
	elseif event == "VARIABLES_LOADED" then
		UIErrorsFrame:SetPoint("TOP", "UIParent", "TOP", 0, -165);		
	end
end

-- Class Info
function EUF_TargetInfoClass_Update()
	if (EUF_CurrentOptions["TARGETINFO"] == 1) then
		EUF_TargetInfo:SetText(EUF_GetUnitInfoString("target", 1, 1, 1, 1, 1));
		EUF_TargetInfo:Show();
	else
		EUF_TargetInfo:Hide();
	end
end

function EUF_GetUnitInfoString(unit, withLevel, withLevelTag, withRace, withClass, withElite)
	local tempstring = "";
	local isElite = 0;
	if (withLevel == 1) then
		local level= UnitLevel(unit);	
		if ( not (level and level >= 1)) then
			level = "??";
		end
		if (withLevelTag == 1) then
			level = string.format(EUF_TEXT_LEVELTAG, level);
		end
		tempstring = tempstring .. level .. " ";
	end
	
	if (withElite == 1) then
		local unitclf = UnitClassification(unit);
		if (unitclf and unitclf ~= "normal" and UnitHealth(unit) > 0) then
			isElite = 1;
			if (unitclf == "elite") then
				tempstring = tempstring .. EUF_TEXT_ELITE .. " ";
			elseif (unitclf == "worldboss") then
				tempstring = tempstring .. "|cffffffff" .. EUF_TEXT_WORLDBOSS .. "|r ";
			elseif (unitclf == "rare") then
				tempstring = tempstring .. "|cffffffff" .. EUF_TEXT_RARE .. "|r ";
			elseif (unitclf == "rareelite") then
				tempstring = tempstring .. "|cffffffff" .. EUF_TEXT_RAREELITE .. "|r ";
			end
		end
	end

	if (withRace == 1 and isElite == 0) then
		if (UnitRace(unit) and UnitIsPlayer(unit)) then
			tempstring = tempstring .. UnitRace(unit) .. " ";
		elseif (UnitPlayerControlled(unit)) then
			if (UnitCreatureFamily(unit)) then
				tempstring = tempstring .. UnitCreatureFamily(unit) .. " ";
			end
		else
			if (UnitCreatureType(unit)) then
				tempstring = tempstring .. UnitCreatureType(unit) .. " ";
			end
		end
	end

	if (withClass == 1) then
		local class = UnitClass(unit);
		if class and UnitIsPlayer(unit) then
			tempstring = tempstring .. class;
		end
	end

	return tempstring;
end