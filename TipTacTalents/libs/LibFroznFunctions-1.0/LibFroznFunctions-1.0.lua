
-----------------------------------------------------------------------
-- LibFroznFunctions-1.0
--
-- Frozn's utility functions for WoW development
--
-- Example:
-- /run DevTools_Dump(LibStub:GetLibrary("LibFroznFunctions-1.0", true).isWoWFlavor)
--

-- create new library
local LIB_NAME = "LibFroznFunctions-1.0";
local LIB_MINOR = 1; -- bump on changes

if (not LibStub) then
	error(LIB_NAME .. " requires LibStub.");
end
-- local ldb = LibStub("LibDataBroker-1.1", true)
-- if not ldb then error(LIB_NAME .. " requires LibDataBroker-1.1.") end

local LibFroznFunctions = LibStub:NewLibrary(LIB_NAME, LIB_MINOR)

if (not LibFroznFunctions) then
	return;
end

----------------------------------------------------------------------------------------------------
--                                        Classic Support                                         --
----------------------------------------------------------------------------------------------------

-- WoW flavor
--
-- @return .ClassicEra = true/false for Classic Era
--         .BCC        = true/false for BCC
--         .WotLKC     = true/false for WotLKC
--         .SL         = true/false for SL
--         .DF         = true/false for DF
LibFroznFunctions.isWoWFlavor = {
	["ClassicEra"] = false,
	["BCC"] = false,
	["WotLKC"] = false,
	["SL"] = false,
	["DF"] = false
};

if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CLASSIC"]) then
	LibFroznFunctions.isWoWFlavor.ClassicEra = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_BURNING_CRUSADE_CLASSIC"]) then
	LibFroznFunctions.isWoWFlavor.BCC = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_WRATH_CLASSIC"]) then
	LibFroznFunctions.isWoWFlavor.WotLKC = true;
else -- retail
	if (_G["LE_EXPANSION_LEVEL_CURRENT"] == _G["LE_EXPANSION_SHADOWLANDS"]) then
		LibFroznFunctions.isWoWFlavor.SL = true;
	else
		LibFroznFunctions.isWoWFlavor.DF = true;
	end
end

-- create color from hex string
--
-- @param  hexColor  color represented by hexadecimal digits in format AARRGGBB, e.g. "FFFF7C0A" (orange color for druid)
-- @return ColorMixin
LibFroznFunctions.CreateColorFromHexString = CreateColorFromHexString;

if (not LibFroznFunctions.CreateColorFromHexString) then
	local function ExtractColorValueFromHex(str, index)
		return tonumber(str:sub(index, index + 1), 16) / 255;
	end
	
	LibFroznFunctions.CreateColorFromHexString = function(hexColor)
		if (#hexColor == 8) then
			local a, r, g, b = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3), ExtractColorValueFromHex(hexColor, 5), ExtractColorValueFromHex(hexColor, 7);
			return CreateColor(r, g, b, a);
		else
			error("CreateColorFromHexString input must be hexadecimal digits in this format: AARRGGBB.");
		end
	end
end

----------------------------------------------------------------------------------------------------
--                                             Colors                                             --
----------------------------------------------------------------------------------------------------

-- get class color
--
-- @param  classFile                     class file, e.g. "MAGE" or "DRUID"
-- @param  alternateClassFileIfNotFound  alternate class file if color for param "classFile" doesn't exist
-- @return ColorMixin. returns nil if class file for param "classFile" and "alternateClassFileIfNotFound" doesn't exist.
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;

function LibFroznFunctions.GetClassColor(classFile, alternateClassFileIfNotFound)
	return CLASS_COLORS[classFile] or CLASS_COLORS[alternateClassFileIfNotFound];
end

----------------------------------------------------------------------------------------------------
--                                             Icons                                              --
----------------------------------------------------------------------------------------------------

-- create markup for role icon
--
-- @param  role  "DAMAGER", "TANK" or "HEALER"
-- @return markup for role icon to use in text. returns nil for invalid roles.
function LibFroznFunctions.CreateMarkupForRoleIcon(role)
	if (role == "TANK") then
		return CreateAtlasMarkup("roleicon-tiny-tank");
	elseif (role == "DAMAGER") then
		return CreateAtlasMarkup("roleicon-tiny-dps");
	elseif (role == "HEALER") then
		return CreateAtlasMarkup("roleicon-tiny-healer");
	else
		return nil;
	end
end

-- create markup for class icon
--
-- @param  classIcon  file id/path for class icon
-- @return markup for class icon to use in text
function LibFroznFunctions.CreateMarkupForClassIcon(classIcon)
	return CreateTextureMarkup(classIcon, 64, 64, nil, nil, 0.07, 0.93, 0.07, 0.93);
end

----------------------------------------------------------------------------------------------------
--                                           Inspecting                                           --
----------------------------------------------------------------------------------------------------

-- get talents
--
-- @param  unitID  unit id for unit, e.g. "player", "target" or "mouseover", defaults to "player"
-- @return .name           talent/specialization name, e.g. "Elemental"
--         .iconFileID     talent/specialization icon file id, e.g. 135770
--         .role           role ("DAMAGER", "TANK" or "HEALER"
--         .pointsSpent[]  talent points spent, e.g. { 57, 14, 0 }
--         returns false if no talents have been found.
--         returns nil if no talents are available.
function LibFroznFunctions.GetTalents(unitID)
	local unitLevel = UnitLevel(unitID);
	
	if (unitLevel < 10 and unitLevel ~= -1) then -- no need to display talent/specialization for players who hasn't yet gotten talent tabs or a specialization
		return nil;
	end
	
	local talents = {};
	local isSelf = (not unitID) or (unitID == "player");
	
	if (GetSpecialization) then -- retail
		local specializationName, specializationIcon, role;
		
		if (isSelf) then -- player
			local specIndex = GetSpecialization();
			
			if (not specIndex) then
				return false;
			end
			
			_, specializationName, _, specializationIcon, role = GetSpecializationInfo(specIndex);
		else -- inspecting
			local specializationID = GetInspectSpecialization(unitID);
			
			if (specializationID == 0) then
				return false;
			end
			
			_, specializationName, _, specializationIcon, role = GetSpecializationInfoByID(specializationID);
		end
		
		if (specializationName ~= "") then
			talents.name = specializationName;
		end
		
		talents.role = role;
		talents.iconFileID = specializationIcon;
		
		local pointsSpent = {};
		
		if (isSelf) and (C_SpecializationInfo.CanPlayerUseTalentSpecUI()) or (not isSelf) and (C_Traits.HasValidInspectData()) then
			local configID = (isSelf) and (C_ClassTalents.GetActiveConfigID()) or (not isSelf) and (Constants.TraitConsts.INSPECT_TRAIT_CONFIG_ID);
			local configInfo = C_Traits.GetConfigInfo(configID);
			
			if (configInfo) and (configInfo.treeIDs) then
				local treeID = configInfo.treeIDs[1];
				if (treeID) then
					local treeCurrencyInfo = C_Traits.GetTreeCurrencyInfo(configID, treeID, false);
					
					if (treeCurrencyInfo) then
						for _, treeCurrencyInfoItem in ipairs(treeCurrencyInfo) do
							if (treeCurrencyInfoItem.spent) then
								pointsSpent[#pointsSpent + 1] = treeCurrencyInfoItem.spent;
							end
						end
					end
				end
			end
		end
		
		if (#pointsSpent > 0) then
			talents.pointsSpent = pointsSpent;
		end
	else -- classic
		if (not isSelf) and (LibFroznFunctions.isWoWFlavor.ClassicEra) then -- getting talents from other players isn't available in classic era
			return nil;
		end
		
		-- inspect functions will always use the active spec when not inspecting
		local activeTalentGroup = GetActiveTalentGroup and GetActiveTalentGroup(not isSelf);
		local numTalentTabs = GetNumTalentTabs(not isSelf);
		
		if (not numTalentTabs) then
			return false;
		end
		
		local talentTabName, talentTabIcon;
		local pointsSpent = {};
		local maxPointsSpent;
		
		for tabIndex = 1, numTalentTabs do
			_talentTabName, _talentTabIcon, _pointsSpent = GetTalentTabInfo(tabIndex, not isSelf, nil, activeTalentGroup);
			pointsSpent[#pointsSpent + 1] = _pointsSpent;
			
			if (not maxPointsSpent) or (_pointsSpent > maxPointsSpent) then
				maxPointsSpent = _pointsSpent;
				talentTabName, talentTabIcon = _talentTabName, _talentTabIcon;
			end
		end
		
		if (talentTabName ~= "") then
			talents.name = talentTabName;
		end
		
		talents.iconFileID = talentTabIcon;
		
		if (#pointsSpent > 0) then
			talents.pointsSpent = pointsSpent;
		end
	end
	
	return talents;
end