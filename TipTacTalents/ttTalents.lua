-----------------------------------------------------------------------
-- TipTacTalents
--
-- Show player talents/specialization including role and talent/specialization icon and the average item level in the tooltip.
--

-- create addon
local MOD_NAME = ...;
local ttt = CreateFrame("Frame", MOD_NAME, nil, BackdropTemplateMixin and "BackdropTemplate");
ttt:Hide();

-- get libs
local LibFroznFunctions = LibStub:GetLibrary("LibFroznFunctions-1.0");

----------------------------------------------------------------------------------------------------
--                                             Config                                             --
----------------------------------------------------------------------------------------------------

-- config
local cfg;

-- default config
local TTT_DefaultConfig = {
	t_enable = true,                 -- "main switch", addon does nothing if false
	t_showTalents = true,            -- show talents
	t_talentOnlyInParty = false,     -- only show talents/AIL for party/raid members
	
	t_showRoleIcon = true,           -- show role icon
	t_showTalentIcon = true,         -- show talent icon
	
	t_showTalentText = true,         -- show talent text
	t_colorTalentTextByClass = true, -- color specialization text by class color
	t_talentFormat = 1,              -- talent Format
	
	t_showAverageItemLevel = true    -- show average item level (AIL)
}

----------------------------------------------------------------------------------------------------
--                                           Variables                                            --
----------------------------------------------------------------------------------------------------

-- text constants
local TTT_TEXT_TALENTS_PREFIX = ((LibFroznFunctions.isWoWFlavor.SL or LibFroznFunctions.isWoWFlavor.DF) and SPECIALIZATION or TALENTS); -- MoP: Could be changed from TALENTS (Talents) to SPECIALIZATION (Specialization)
local TTT_TEXT_AIL_PREFIX = STAT_AVERAGE_ITEM_LEVEL; -- Item Level
local TTT_TEXT_LOADING = SEARCH_LOADING_TEXT; -- Loading...
local TTT_TEXT_OUT_OF_RANGE = ERR_SPELL_OUT_OF_RANGE:sub(1, -2); -- Out of range.
local TTT_TEXT_NONE = NONE_KEY; -- None
-- local TTT_TEXT_NA = NOT_APPLICABLE:lower(); -- N/A

-- colors
local TTT_COLOR_TEXT = HIGHLIGHT_FONT_COLOR;
local TTT_COLOR_POINTS_SPENT = LIGHTYELLOW_FONT_COLOR;

----------------------------------------------------------------------------------------------------
--                                          Setup Addon                                           --
----------------------------------------------------------------------------------------------------

-- EVENT: VARIABLES_LOADED (one-time-event)
function ttt:VARIABLES_LOADED(event)
	-- use TipTac config if installed
	if (TipTac_Config) then
		cfg = LibFroznFunctions:ChainTables(TipTac_Config, TTT_DefaultConfig);
	else
		cfg = TTT_DefaultConfig;
	end
	
	-- apply hooks for inspecting
	self:ApplyHooksForInspecting();
	
	-- remove this event handler as it's not needed anymore
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- register events
ttt:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...);
end);

ttt:RegisterEvent("VARIABLES_LOADED");

----------------------------------------------------------------------------------------------------
--                                           Inspecting                                           --
----------------------------------------------------------------------------------------------------

-- HOOK: GameTooltip's OnTooltipSetUnit -- will schedule a delayed inspect request
local tttTipLineIndexTalents, tttTipLineIndexAverageItemLevel;

local function GTT_OnTooltipSetUnit(self, ...)
	-- exit if "main switch" isn't enabled
	if (not cfg.t_enable) then
		return;
	end
	if IsAddOnLoaded("TinyInspect") then return end
	
	-- get the unit id -- check the UnitFrame unit if this tip is from a concated unit, such as "targettarget".
	local _, unitID = LibFroznFunctions:GetUnitFromTooltip(self);
	
	if (not unitID) then
		local mouseFocus = GetMouseFocus();
		if (mouseFocus) and (mouseFocus.unit) then
			unitID = mouseFocus.unit;
		end
	end
	
	-- no unit id
	if (not unitID) then
		return;
	end
	
	-- check if only talents for people in your party/raid should be shown
	if (cfg.t_talentOnlyInParty) and (not UnitInParty(unitID)) and (not UnitInRaid(unitID)) then
		return;
	end
	
	-- invalidate line indexes
	tttTipLineIndexTalents = nil;
	tttTipLineIndexAverageItemLevel = nil;
	
	-- inspect unit
	local unitCacheRecord = LibFroznFunctions:InspectUnit(unitID, TTT_UpdateTooltip, true);
	
	if (unitCacheRecord) then
		TTT_UpdateTooltip(unitCacheRecord);
	end
end

-- apply hooks for inspecting during event VARIABLES_LOADED (one-time-function)
function ttt:ApplyHooksForInspecting()
	-- hooks needs to be applied as late as possible during load, as we want to try and be the
	-- last addon to hook GameTooltip's OnTooltipSetUnit so we always have a "completed" tip to work on.
	
	-- HOOK: GameTooltip's OnTooltipSetUnit -- will schedule a delayed inspect request
	LibFroznFunctions:GameTooltipHookScriptOnTooltipSetUnit(GTT_OnTooltipSetUnit);
	
	-- remove this function as it's not needed anymore
	self.ApplyHooksForInspecting = nil;
end

----------------------------------------------------------------------------------------------------
--                                         Main Functions                                         --
----------------------------------------------------------------------------------------------------

-- update tooltip with the unit cache record
function TTT_UpdateTooltip(unitCacheRecord)
	-- exit if "main switch" isn't enabled
	if (not cfg.t_enable) then
		return;
	end
	
	-- exit if unit from unit cache record doesn't match the current displaying unit
	local _, unitID = LibFroznFunctions:GetUnitFromTooltip(GameTooltip);
	
	if (not unitID) then
		return;
	end
	
	local unitGUID = UnitGUID(unitID);
	
	if (unitGUID ~= unitCacheRecord.guid) then
		return;
	end
	
	-- update tooltip with the unit cache record
	
	-- talents
	if (cfg.t_showTalents) and (unitCacheRecord.talents) then
		local specText;
		
		-- talents available but no inspect data
		if (unitCacheRecord.talents == LFF_TALENTS_AVAILABLE) then
			if (unitCacheRecord.canInspect) then
				specText = TTT_TEXT_LOADING;
			else
				specText = TTT_TEXT_OUT_OF_RANGE;
			end
		
		-- no talents available
		elseif (unitCacheRecord.talents == LFF_TALENTS_NA) then
			specText = nil;
		
		-- no talents found
		elseif (unitCacheRecord.talents == LFF_TALENTS_NONE) then
			specText = TTT_TEXT_NONE;
		
		-- talents found
		else
			specText = "";
			local spacer, color;
			local talentFormat = (cfg.t_talentFormat or 1);
			local specNameAdded = false;
			
			if (cfg.t_showRoleIcon) and (unitCacheRecord.talents.role) then
				specText = specText .. LibFroznFunctions:CreateMarkupForRoleIcon(unitCacheRecord.talents.role);
			end
			
			if (cfg.t_showTalentIcon) and (unitCacheRecord.talents.iconFileID) then
				specText = specText .. LibFroznFunctions:CreateMarkupForClassIcon(unitCacheRecord.talents.iconFileID);
			end
			
			if (cfg.t_showTalentText) and ((talentFormat == 1) or (talentFormat == 2)) and (unitCacheRecord.talents.name) then
				spacer = (specText ~= "") and " " or "";

				if (cfg.t_colorTalentTextByClass) then
					local classColor = LibFroznFunctions:GetClassColor(unitCacheRecord.classFile, "PRIEST");
					specText = specText .. spacer .. classColor:WrapTextInColorCode(unitCacheRecord.talents.name);
				else
					specText = specText .. spacer .. unitCacheRecord.talents.name;
				end
				
				specNameAdded = true;
			end
			
			if (cfg.t_showTalentText) and ((talentFormat == 1) or (talentFormat == 3)) and (unitCacheRecord.talents.pointsSpent) then
				spacer = (specText ~= "") and " " or "";
				
				if (specNameAdded) then
					specText = specText .. spacer .. TTT_COLOR_POINTS_SPENT:WrapTextInColorCode("(" .. table.concat(unitCacheRecord.talents.pointsSpent, "/") .. ")");
				else
					specText = specText .. spacer .. TTT_COLOR_POINTS_SPENT:WrapTextInColorCode(table.concat(unitCacheRecord.talents.pointsSpent, "/"));
				end
			end
		end
		
		-- show spec text
		if (specText) then
			local tipLineTextTalents = LibFroznFunctions:FormatText("{prefix}: {specText}", {
				["prefix"] = TTT_TEXT_TALENTS_PREFIX,
				["specText"] = TTT_COLOR_TEXT:WrapTextInColorCode(specText)
			});
			
			if (tttTipLineIndexTalents) then
				_G["GameTooltipTextLeft" .. tttTipLineIndexTalents]:SetText(tipLineTextTalents);
			else
				GameTooltip:AddLine(tipLineTextTalents);
				tttTipLineIndexTalents = GameTooltip:NumLines();
			end
		end
	end
	
	-- average item level
	if (cfg.t_showAverageItemLevel) and (unitCacheRecord.averageItemLevel) then
		local ailText;
		
		-- average item level available or no item data
		if (unitCacheRecord.averageItemLevel == LFF_AVERAGE_ITEM_LEVEL_AVAILABLE) then
			if (unitCacheRecord.canInspect) then
				ailText = TTT_TEXT_LOADING;
			else
				ailText = TTT_TEXT_OUT_OF_RANGE;
			end
		
		-- no average item level available
		elseif (unitCacheRecord.averageItemLevel == LFF_AVERAGE_ITEM_LEVEL_NA) then
			ailText = nil;
		
		-- no average item level found
		elseif (unitCacheRecord.averageItemLevel == LFF_AVERAGE_ITEM_LEVEL_NONE) then
			ailText = TTT_TEXT_NONE;
		
		-- average item level found
		else
			ailText = unitCacheRecord.averageItemLevel.qualityColor:WrapTextInColorCode(unitCacheRecord.averageItemLevel.value);
		end
		
		-- show ail test
		if (ailText) then
			local tipLineTextAverageItemLevel = LibFroznFunctions:FormatText("{prefix}: {averageItemLevel}", {
				["prefix"] = TTT_TEXT_AIL_PREFIX,
				["averageItemLevel"] = TTT_COLOR_TEXT:WrapTextInColorCode(ailText)
			});
			
			if (tttTipLineIndexAverageItemLevel) then
				_G["GameTooltipTextLeft" .. tttTipLineIndexAverageItemLevel]:SetText(tipLineTextAverageItemLevel);
			else
				GameTooltip:AddLine(tipLineTextAverageItemLevel);
				tttTipLineIndexAverageItemLevel = GameTooltip:NumLines();
			end
		end
	end

	-- if GameTooltip is visible and not fading out, call Show() to force the tooltip to resize.
	-- we can only detect a fading out tooltip with TipTac, as that sets the .ttFadeOut field.
	-- this means, when TipTacTalents is used on its own, it may bug out the size of the tooltip here.
	if (GameTooltip:IsVisible()) and (not GameTooltip.ttFadeOut) then
		GameTooltip:Show();
	end
end
