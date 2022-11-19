local L = select(2, ...).L

local _G = getfenv(0);
local unpack = unpack;
local UnitName = UnitName;
local gtt = GameTooltip;

-- classic support
local isWoWClassic, isWoWBcc, isWoWWotlkc, isWoWSl, isWoWRetail = false, false, false, false, false;
if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CLASSIC"]) then
	isWoWClassic = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_BURNING_CRUSADE_CLASSIC"]) then
	isWoWBcc = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_WRATH_CLASSIC"]) then
	isWoWWotlkc = true;
else -- retail
	if (_G["LE_EXPANSION_LEVEL_CURRENT"] == _G["LE_EXPANSION_SHADOWLANDS"]) then
		isWoWSl = true;
	else
		isWoWRetail = true;
	end
end

local UnitIsWildBattlePet = UnitIsWildBattlePet or function() return false end;
local UnitIsBattlePetCompanion = UnitIsBattlePetCompanion or function() return false end;

-- TipTac refs
local tt = TipTac;
local cfg;

-- element registration
local ttStyle = tt:RegisterElement({},"Style");

-- vars
local lineName = tt:CreatePushArray();
local lineInfo = tt:CreatePushArray();

-- String Constants
local TT_LevelMatch = "^"..TOOLTIP_UNIT_LEVEL:gsub("%%[^s ]*s",".+"); -- Was changed to match other localizations properly, used to match: "^"..LEVEL.." .+" -- Doesn't actually match the level line on the russian client! [14.02.24] Doesn't match for Italian client either. [18.07.27] changed the pattern, might match non-english clients now
local TT_LevelMatchPet = "^"..TOOLTIP_WILDBATTLEPET_LEVEL_CLASS:gsub("%%[^s ]*s",".+");	-- "^Pet Level .+ .+"
local TT_NotSpecified = L"Not specified";
local TT_Targeting = BINDING_HEADER_TARGETING;	-- "Targeting"
local TT_MythicPlusDungeonScore = CHALLENGE_COMPLETE_DUNGEON_SCORE; -- "Mythic+ Rating"
local TT_Reaction = {
	L"Tapped",					-- No localized string of this
	FACTION_STANDING_LABEL2,	-- Hostile
	FACTION_STANDING_LABEL3,	-- Unfriendly (Caution)
	FACTION_STANDING_LABEL4,	-- Neutral
	FACTION_STANDING_LABEL5,	-- Friendly
	FACTION_STANDING_LABEL5,	-- Friendly (Exalted)
	DEAD,						-- Dead
};

-- colors
local COL_WHITE = "|cffffffff";
local COL_LIGHTGRAY = "|cffc0c0c0";

--------------------------------------------------------------------------------------------------------
--                                           Style Tooltip                                            --
--------------------------------------------------------------------------------------------------------

-- Returns the correct difficulty color compared to the player
-- Az: Check out GetCreatureDifficultyColor, GetQuestDifficultyColor, GetScalingQuestDifficultyColor, GetRelativeDifficultyColor
-- Frozn45: The above functions belong to the old color api. GetDifficultyColor() with C_PlayerInfo.GetContentDifficultyCreatureForPlayer() or C_PlayerInfo.GetContentDifficultyQuestForPlayer() belongs to the new color api.
local function GetDifficultyLevelColor(unit, level) -- see GetDifficultyColor() in "UIParent.lua"
	local difficultyColor;
	
	if (level == -1) then
		difficultyColor = QuestDifficultyColors["impossible"];
	else
		difficultyColor = GetDifficultyColor and GetDifficultyColor(C_PlayerInfo.GetContentDifficultyCreatureForPlayer(unit)) or GetCreatureDifficultyColor(level);
	end
	
	local difficultyColorMixin = CreateColor(difficultyColor.r, difficultyColor.g, difficultyColor.b, 1);
	
	return difficultyColorMixin:GenerateHexColorMarkup();
end

-- Add target
local function AddTarget(lineList,target,targetName)
	if (UnitIsUnit("player",target)) then
		lineList.next = COL_WHITE;
		lineList.next = cfg.targetYouText;
	else
		local targetReaction = cfg["colReactText"..tt:GetUnitReactionIndex(target)];
		lineList.next = targetReaction;
		lineList.next = "[";
		if (UnitIsPlayer(target)) then
			local _, targetClassFile = UnitClass(target);
			lineList.next = (tt.ClassColorMarkup[targetClassFile] or COL_LIGHTGRAY);
			lineList.next = targetName;
			lineList.next = targetReaction;
		else
			lineList.next = targetName;
		end
		lineList.next = "]";
	end
end

-- TARGET
function ttStyle:GenerateTargetLines(unit,method)
	local target = unit.."target";
	local targetName = UnitName(target);
	if (targetName) and (targetName ~= UNKNOWNOBJECT and targetName ~= "" or UnitExists(target)) then
		if (method == "first") then
			lineName.next = COL_WHITE;
			lineName.next = " : |r";
			AddTarget(lineName,target,targetName);
		elseif (method == "second") then
			lineName.next = "\n  ";
			AddTarget(lineName,target,targetName);
		elseif (method == "last") then
			lineInfo.next = "\n|cffffd100";
			lineInfo.next = L"Targeting"; --TT_Targeting;
			lineInfo.next = ": ";
			AddTarget(lineInfo,target,targetName);
		end
	end
end

-- PLAYER Styling
function ttStyle:GeneratePlayerLines(u,first,unit)
	-- gender
	if (cfg.showPlayerGender) then
		local sex = UnitSex(unit);
		if (sex == 2) or (sex == 3) then
			lineInfo.next = " ";
			lineInfo.next = cfg.colRace;
			lineInfo.next = (sex == 3 and FEMALE or MALE);
		end
	end
	-- race
	lineInfo.next = " ";
	lineInfo.next = cfg.colRace;
	lineInfo.next = UnitRace(unit);
	-- class
	lineInfo.next = " ";
	lineInfo.next = (tt.ClassColorMarkup[u.classFile] or COL_WHITE);
	lineInfo.next = u.class;
	-- name
	lineName.next = (cfg.colorNameByClass and (tt.ClassColorMarkup[u.classFile] or COL_WHITE) or u.reactionColor);
	lineName.next = (cfg.nameType == "marysueprot" and u.rpName) or (cfg.nameType == "original" and u.originalName) or (cfg.nameType == "title" and UnitPVPName(unit)) or u.name;
	if (u.realm) and (u.realm ~= "") and (cfg.showRealm ~= "none") then
		if (cfg.showRealm == "show") then
			lineName.next = " - ";
			lineName.next = u.realm;
		else
			lineName.next = " (*)";
		end
	end
	-- dc, afk or dnd
	if (cfg.showStatus) then
		local status = (not UnitIsConnected(unit) and L" <DC>") or (UnitIsAFK(unit) and L" <AFK>") or (UnitIsDND(unit) and L" <DND>");
		if (status) then
			lineName.next = COL_WHITE;
			lineName.next = status;
		end
	end
	-- guild
	-- local guild, guildRank = GetGuildInfo(unit);
	local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo(unit);
	if (guildName) then
		local playerGuildName = GetGuildInfo("player");
		local guildColor = (guildName == playerGuildName and cfg.colSameGuild or cfg.colorGuildByReaction and u.reactionColor or cfg.colGuild);
		local text = format("%s<%s>", guildColor, guildName);
		if (cfg.showGuildRank and guildRankName) then
			if (cfg.guildRankFormat == "title") then
				text = text .. format(" %s%s", COL_LIGHTGRAY, guildRankName);
			elseif (cfg.guildRankFormat == "both") then
				text = text .. format(" %s%s (%s)", COL_LIGHTGRAY, guildRankName, guildRankIndex);
			elseif (cfg.guildRankFormat == "level") then
				text = text .. format(" %s%s", COL_LIGHTGRAY, guildRankIndex);
			end
		end
		GameTooltipTextLeft2:SetText(text);
		lineInfo.Index = (lineInfo.Index + 1);
	end
end

-- PET Styling
function ttStyle:GeneratePetLines(u,first,unit)
	lineName.next = u.reactionColor;
	lineName.next = u.name;

	lineInfo.next = " ";
	lineInfo.next = cfg.colRace;
	local petType = UnitBattlePetType(unit) or 5;
	lineInfo.next = _G["BATTLE_PET_NAME_"..petType];

	if (u.isPetWild) then
		lineInfo.next = " ";
		lineInfo.next = UnitCreatureFamily(unit) or UnitCreatureType(unit);
	else
		if not (self.petLevelLineIndex) then
			for i = 2, gtt:NumLines() do
				local gttLineText = _G["GameTooltipTextLeft"..i]:GetText();
				if (type(gttLineText) == "string") and (gttLineText:find(TT_LevelMatchPet)) then
					self.petLevelLineIndex = i;
					break;
				end
			end
		end
		lineInfo.Index = self.petLevelLineIndex or 2;
		local expectedLine = 3 + (tt.isColorBlind and 1 or 0);
		if (lineInfo.Index > expectedLine) then
			GameTooltipTextLeft2:SetFormattedText("%s<%s>",u.reactionColor,u.title);
		end
	end
end

local Corpse_COLORS = {r=0.54, g=0.54, b=0.54}	-- 尸体颜色（灰色）
local FACTION_COLORS = {
    [5]		= "33CC33",				-- 友好（绿色）
    [6]		= "33CCCC",				-- 尊敬（湖蓝）
    [7]		= "FF6633",				-- 崇敬（橙色）
    [8]		= "DD33DD",				-- 崇拜（紫色）
}

-- 转换颜色格式
local function ParseColor(color, hex)
    if hex then
        return format("%2x%2x%2x",color.r*255,color.g*255,color.b*255)
    else
        return color.r, color.g, color.b, 1
    end
end
-- 死亡或已被选取
local function DeadOrTapped(unit)
    if UnitIsTapDenied(unit) then return 1 end
    if (UnitHealth(unit) <= 0 and not UnitIsPlayer(unit))
            or (UnitIsPlayer(unit) and UnitIsDeadOrGhost(unit)) then
        return 2
    else
        return 0
    end
end

-- 获取阵营、声望
local function UnitFactionString(unit)
    local reaction = UnitReaction(unit, "player")
    if not reaction then return "" end

    local tmp, tmp2
    if reaction < 5 then
        tmp = ParseColor(FACTION_BAR_COLORS[reaction], true)
    else
        tmp = FACTION_COLORS[reaction]
    end
    if DeadOrTapped(unit) > 0 then
        tmp = ParseColor(Corpse_COLORS, true)
    end
    tmp2 = GetText("FACTION_STANDING_LABEL"..reaction, UnitSex("player"))
    return format("|cFF%s%s|r", tmp, tmp2)
end

-- NPC Styling
function ttStyle:GenerateNpcLines(u,first,unit)
	-- name
	lineName.next = u.reactionColor;
	lineName.next = u.name;

	-- guild/title -- since WoD, npc title can be a single space character
	if (u.title) and (u.title ~= " ") then
		-- Az: this doesn't work with "Mini Diablo" or "Mini Thor", which has the format: 1) Mini Diablo 2) Lord of Terror 3) Player's Pet 4) Level 1 Non-combat Pet
		local gttLine = tt.isColorBlind and GameTooltipTextLeft3 or GameTooltipTextLeft2;
		gttLine:SetFormattedText("%s<%s>",u.reactionColor,u.title);
		lineInfo.Index = (lineInfo.Index + 1);
	end

	-- class
	local class = UnitCreatureFamily(unit) or UnitCreatureType(unit);
	if (not class or class == TT_NotSpecified) then
		class = UNKNOWN;
	end
	lineInfo.next = " ";
	lineInfo.next = cfg.colRace;
	lineInfo.next = class .. " " .. UnitFactionString(u.token); --abyui 显示NPC的声望，否则看不出崇敬崇拜
end

-- Modify Tooltip Lines (name + info)
function ttStyle:ModifyUnitTooltip(u,first)
	-- obtain unit properties
	local unit = u.token;
	u.name, u.realm = UnitName(unit);
	u.reactionColor = cfg["colReactText"..u.reactionIndex];
	u.isPetWild, u.isPetCompanion = UnitIsWildBattlePet(unit), UnitIsBattlePetCompanion(unit);

	-- this is the line index where the level and unit type info is
	lineInfo.Index = 2 + (tt.isColorBlind and UnitIsVisible(unit) and 1 or 0);

	-- Level + Classification
	local level = (u.isPetWild or u.isPetCompanion) and UnitBattlePetLevel(unit) or UnitLevel(unit) or -1;
	local classification = UnitClassification(unit) or "";
	lineInfo.next = (UnitCanAttack(unit, "player") or UnitCanAttack("player", unit)) and GetDifficultyLevelColor(unit, level) or cfg.colLevel;
	lineInfo.next = (cfg["classification_"..classification] or "%s? "):format(level == -1 and "??" or level);

	-- Generate Line Modification
	if (u.isPlayer) then
		self:GeneratePlayerLines(u,first,unit);
	elseif (cfg.showBattlePetTip) and (u.isPetWild or u.isPetCompanion) then
		self:GeneratePetLines(u,first,unit);
	else
		self:GenerateNpcLines(u,first,unit);
	end

	-- Current Unit Speed
	if (cfg.showCurrentUnitSpeed) then
		local currentUnitSpeed = GetUnitSpeed(unit);
		if (currentUnitSpeed > 0) then
			lineInfo.next = " " .. CreateAtlasMarkup("glueannouncementpopup-arrow");
			lineInfo.next = COL_LIGHTGRAY;
			lineInfo.next = string.format("%.0f%%", currentUnitSpeed / BASE_MOVEMENT_SPEED * 100);
		end
	end
	
	-- Reaction Text
	if (cfg.reactText) then
		lineInfo.next = "\n";
		lineInfo.next = u.reactionColor;
		lineInfo.next = TT_Reaction[u.reactionIndex];
	end

	-- Mythic+ Dungeon Score
	if (u.isPlayer) and (cfg.showMythicPlusDungeonScore) and (C_PlayerInfo.GetPlayerMythicPlusRatingSummary) then
		local ratingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit);
		if (ratingSummary) then
			local mythicPlusDungeonScore = ratingSummary.currentSeasonScore;
			if (mythicPlusDungeonScore > 0) then
				lineInfo.next = "\n|cffffd100";
				lineInfo.next = TT_MythicPlusDungeonScore:format(C_ChallengeMode.GetDungeonScoreRarityColor(mythicPlusDungeonScore):WrapTextInColorCode(mythicPlusDungeonScore));
			end
		end
	end

	-- Target
	if (cfg.showTarget ~= "none") then
		self:GenerateTargetLines(unit,cfg.showTarget);
	end

	-- Name Line
	GameTooltipTextLeft1:SetText(lineName:Concat());
	lineName:Clear();

	-- Info Line
	for i = (gtt:NumLines() + 1), lineInfo.Index do
		gtt:AddLine(" ");
	end
	
	local gttLine = _G["GameTooltipTextLeft"..lineInfo.Index];
	
	-- 8.2 made the default XML template have only 2 lines, so it's possible to get here without the desired line existing (yet?)
	-- Frozn45: The problem showed up in classic. Fixed it with adding the missing lines (see for-loop with gtt:AddLine() above).
	if (gttLine) then
		gttLine:SetText(lineInfo:Concat());
		gttLine:SetTextColor(1,1,1);
	end

	lineInfo:Clear();
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

function ttStyle:OnLoad()
	cfg = TipTac_Config;
end

function ttStyle:OnStyleTip(tip,first)
	-- some things only need to be done once initially when the tip is first displayed
	if (first) then
		-- Store Original Name
		if (cfg.nameType == "original") then
			tip.ttUnit.originalName = GameTooltipTextLeft1:GetText();
		end

		-- Az: RolePlay Experimental (Mary Sue Protocol)
		if (tip.ttUnit.isPlayer) and (cfg.nameType == "marysueprot") and (msp) then
			local field = "NA";
			local name = UnitName(tip.ttUnit.token);
			msp:Request(name,field);	-- Az: does this return our request, or only storing it for later use? I'm guessing the info isn't available right away, but only after the person's roleplay addon replies.
			if (msp.char[name]) and (msp.char[name].field[field] ~= "") then
				tip.ttUnit.rpName = msp.char[name].field[field] or name;
			end
		end

		-- Find NPC Title -- 09.08.22: Should now work with colorblind mode
		if (not tip.ttUnit.isPlayer) then
			tip.ttUnit.title = (tt.isColorBlind and GameTooltipTextLeft3 or GameTooltipTextLeft2):GetText();
			if (tip.ttUnit.title) and (tip.ttUnit.title:find(TT_LevelMatch)) then
				tip.ttUnit.title = nil;
			end
		end
	end

	self:ModifyUnitTooltip(tip.ttUnit,first);
end

function ttStyle:OnCleared(tip)
	if (gtt == tip) then
		self.petLevelLineIndex = nil;
	end
end
