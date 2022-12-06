local _, namespace = ... 	--localization
local L = namespace.L 				--localization
local _,addon = ...

local char_ctats_pane = CharacterStatsPane
DCS_ClassSpecDB = {}

local _, DCS_TableData = ...
local scrollbarchecked
local _, gdbprivate = ...
	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsScrollbarChecked = {
		ScrollbarSetChecked = false,
	}
	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsClassBackgroundChecked = {
		ClassBackgroundChecked = true,
	}

local StatScrollFrame = CreateFrame("ScrollFrame", nil, CharacterFrameInsetRight, "UIPanelScrollFrameTemplate")
	StatScrollFrame:ClearAllPoints()
	StatScrollFrame:SetPoint("TOPLEFT", CharacterFrameInsetRight, "TOPLEFT", 5, -6)
	StatScrollFrame:SetPoint("BOTTOMRIGHT", CharacterFrameInsetRight, "BOTTOMRIGHT", 0, 3)
	StatScrollFrame.ScrollBar:ClearAllPoints()
	StatScrollFrame.ScrollBar:SetPoint("TOPLEFT", StatScrollFrame, "TOPRIGHT", -16, -16)
	StatScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", StatScrollFrame, "BOTTOMRIGHT", -16, 16)
	StatScrollFrame.ScrollBar:Hide()
	
	StatScrollFrame:HookScript("OnScrollRangeChanged", function(self, xrange, yrange)
		if scrollbarchecked then
			self.ScrollBar:SetShown(floor(yrange) ~= 0)
		else
			self.ScrollBar:Hide()
		end
	end)
	
	local StatFrame = CreateFrame("Frame", nil, StatScrollFrame)
	StatFrame:SetWidth(191)
	StatFrame:SetPoint("TOPLEFT")
	StatFrame.AnchorFrame = CreateFrame("Frame", nil, StatFrame)
	StatFrame.AnchorFrame:SetSize(StatFrame:GetWidth(), 2)
	StatFrame.AnchorFrame:SetPoint("TOPLEFT")
	StatScrollFrame:SetScrollChild(StatFrame)

	char_ctats_pane.ItemLevelFrame:SetParent(StatFrame)
	char_ctats_pane.ItemLevelFrame.Value:SetFont(char_ctats_pane.ItemLevelFrame.Value:GetFont(), 22, "THINOUTLINE")
	char_ctats_pane.ItemLevelFrame.Value:SetPoint("CENTER",char_ctats_pane.ItemLevelFrame.Background, "CENTER", 0, 1)

	char_ctats_pane.AttributesCategory:SetParent(StatFrame)
	char_ctats_pane.AttributesCategory:SetHeight(28)
	char_ctats_pane.AttributesCategory.Background:SetHeight(28)

	char_ctats_pane.ClassBackground:SetParent(StatScrollFrame)

	char_ctats_pane.EnhancementsCategory:SetParent(StatFrame)
	char_ctats_pane.EnhancementsCategory:SetHeight(28)
	char_ctats_pane.EnhancementsCategory.Background:SetHeight(28)

local DefaultTankData = DCS_TableData:MergeTable({
	{ statKey = "ItemLevelFrame" },
--[[
	{ statKey = "GeneralCategory" },
        { statKey = "HEALTH" },
        { statKey = "DCS_POWER" },
        { statKey = "DCS_ALTERNATEMANA" },
        { statKey = "ITEMLEVEL", hidden = true },
        { statKey = "MOVESPEED" },
		{ statKey = "DURABILITY_STAT" },
        { statKey = "REPAIR_COST" },
	{ statKey = "AttributesCategory" },
        { statKey = "STRENGTH" },
        { statKey = "AGILITY" },
        { statKey = "INTELLECT" },
        { statKey = "STAMINA" },
	{ statKey = "OffenseCategory" }, --Re-order before Enhancements to appear more logical.
        { statKey = "ATTACK_DAMAGE" },
        { statKey = "ATTACK_AP" },
        { statKey = "DCS_ATTACK_ATTACKSPEED" },
		{ statKey = "WEAPON_DPS" },
        { statKey = "SPELLPOWER" },
        { statKey = "MANAREGEN" },
        { statKey = "ENERGY_REGEN" },
        { statKey = "DCS_RUNEREGEN" },
        { statKey = "FOCUS_REGEN" },		
        { statKey = "GCD" },
	{ statKey = "EnhancementsCategory" }, --Re-order after Offense to appear more logical.
        { statKey = "CRITCHANCE", hideAt = 0 },
		{ statKey = "HASTE", hideAt = 0 },
        { statKey = "VERSATILITY", hideAt = 0 },
        { statKey = "MASTERY", hideAt = 0 },
        { statKey = "LIFESTEAL", hideAt = 0 },
        { statKey = "AVOIDANCE", hideAt = 0 },
		{ statKey = "DefenseCategory" },
        { statKey = "ARMOR" },
        { statKey = "DODGE", hideAt = 0 },
        { statKey = "PARRY", hideAt = 0 },
		{ statKey = "BLOCK", hideAt = 0, showFunc = C_PaperDollInfo.OffhandHasShield },
		{ statKey = "STAGGER", hideAt = 0, roles = {"TANK"} },
--]]
	{ statKey = "AttributesCategory" },
        { statKey = "STRENGTH" },
        { statKey = "AGILITY" },
        { statKey = "INTELLECT" },
        { statKey = "STAMINA" },
	{ statKey = "EnhancementsCategory" }, --Re-order after Offense to appear more logical.
        { statKey = "CRITCHANCE", hideAt = 0 },
		{ statKey = "HASTE", hideAt = 0 },
        { statKey = "VERSATILITY", hideAt = 0 },
        { statKey = "MASTERY", hideAt = 0 },
        { statKey = "LIFESTEAL", hideAt = 0 },
        { statKey = "AVOIDANCE", hideAt = 0 },
		{ statKey = "DefenseCategory" },
        { statKey = "ARMOR" },
        { statKey = "DODGE", hideAt = 0 },
        { statKey = "PARRY", hideAt = 0 },
		{ statKey = "BLOCK", hideAt = 0, showFunc = C_PaperDollInfo.OffhandHasShield },
		{ statKey = "STAGGER", hideAt = 0, roles = {"TANK"} },
	{ statKey = "OffenseCategory" }, --Re-order before Enhancements to appear more logical.
        { statKey = "ATTACK_DAMAGE" },
        { statKey = "ATTACK_AP" },
        { statKey = "DCS_ATTACK_ATTACKSPEED" },
		{ statKey = "WEAPON_DPS" },
        { statKey = "SPELLPOWER" },
        { statKey = "MANAREGEN" },
        { statKey = "ENERGY_REGEN" },
        { statKey = "DCS_RUNEREGEN" },
        { statKey = "FOCUS_REGEN" },		
        { statKey = "GCD" },
	{ statKey = "GeneralCategory" },
        { statKey = "HEALTH" },
        { statKey = "DCS_POWER" },
        { statKey = "DCS_ALTERNATEMANA" },
        { statKey = "ITEMLEVEL", hidden = true },
        { statKey = "MOVESPEED" },
		{ statKey = "DURABILITY_STAT" },
        { statKey = "REPAIR_COST" },
	{ statKey = "RatingCategory" },
		{ statKey = "CRITCHANCE_RATING", hideAt = 0 },
		{ statKey = "HASTE_RATING", hideAt = 0 },
		{ statKey = "VERSATILITY_RATING", hideAt = 0 },
		{ statKey = "MASTERY_RATING", hideAt = 0 },
		{ statKey = "LIFESTEAL_RATING", hideAt = 0 },
		{ statKey = "AVOIDANCE_RATING", hideAt = 0 },
		{ statKey = "DODGE_RATING", hideAt = 0 },
		{ statKey = "PARRY_RATING", hideAt = 0 },
		{ statKey = "SPEED_RATING", hideAt = 0, hidden = true },
		{ statKey = "SPEED", hideAt = 0, hidden = true }, --seems like Blizzard's implemented speed rating
	{ statKey = "HonorCategory", hidden = true },
		{ statKey = "HONOR_PROGRESS", hideAt = 0, hidden = true },
		{ statKey = "HONOR_LEVEL", hideAt = 0, hidden = true },
	{ statKey = "UserCat1", hidden = true },
	{ statKey = "UserCat2", hidden = true },
	{ statKey = "UserCat3", hidden = true },
	{ statKey = "UserCat4", hidden = true },
	{ statKey = "UserCat5", hidden = true },
})

local DefaultNonTankData = DCS_TableData:MergeTable({
	{ statKey = "ItemLevelFrame" },
--[[
	{ statKey = "GeneralCategory" },
        { statKey = "HEALTH" },
        { statKey = "DCS_POWER" },
        { statKey = "DCS_ALTERNATEMANA" },
        { statKey = "ITEMLEVEL", hidden = true },
        { statKey = "MOVESPEED" },
		{ statKey = "DURABILITY_STAT" },
        { statKey = "REPAIR_COST" },
	{ statKey = "AttributesCategory" },
        { statKey = "STRENGTH" },
        { statKey = "AGILITY" },
        { statKey = "INTELLECT" },
        { statKey = "STAMINA" },
		{ statKey = "ARMOR" }, --Armor has always been an main attribute stat, except for tanks where it is a defense stat.
	{ statKey = "OffenseCategory" }, --Re-order before Enhancements to appear more logical.
        { statKey = "ATTACK_DAMAGE" },
        { statKey = "ATTACK_AP" },
        { statKey = "DCS_ATTACK_ATTACKSPEED" },
		{ statKey = "WEAPON_DPS" },
        { statKey = "SPELLPOWER" },
        { statKey = "MANAREGEN" },
        { statKey = "ENERGY_REGEN" },
        { statKey = "DCS_RUNEREGEN" },
        { statKey = "FOCUS_REGEN" },		
        { statKey = "GCD" },
	{ statKey = "EnhancementsCategory" }, --Re-order after Offense to appear more logical.
        { statKey = "CRITCHANCE", hideAt = 0 },
		{ statKey = "HASTE", hideAt = 0 },
        { statKey = "VERSATILITY", hideAt = 0 },
        { statKey = "MASTERY", hideAt = 0 },
        { statKey = "LIFESTEAL", hideAt = 0 },
        { statKey = "AVOIDANCE", hideAt = 0 },
--]]
	{ statKey = "AttributesCategory" },
        { statKey = "STRENGTH" },
        { statKey = "AGILITY" },
        { statKey = "INTELLECT" },
        { statKey = "STAMINA" },
		{ statKey = "ARMOR" }, --Armor has always been an main attribute stat, except for tanks where it is a defense stat.
	{ statKey = "EnhancementsCategory" }, --Re-order after Offense to appear more logical.
        { statKey = "CRITCHANCE", hideAt = 0 },
		{ statKey = "HASTE", hideAt = 0 },
        { statKey = "VERSATILITY", hideAt = 0 },
        { statKey = "MASTERY", hideAt = 0 },
        { statKey = "LIFESTEAL", hideAt = 0 },
        { statKey = "AVOIDANCE", hideAt = 0 },
	{ statKey = "GeneralCategory" },
        { statKey = "HEALTH" },
        { statKey = "DCS_POWER" },
        { statKey = "DCS_ALTERNATEMANA" },
        { statKey = "ITEMLEVEL", hidden = true },
        { statKey = "MOVESPEED" },
		{ statKey = "DURABILITY_STAT" },
        { statKey = "REPAIR_COST" },
	{ statKey = "OffenseCategory" }, --Re-order before Enhancements to appear more logical.
        { statKey = "ATTACK_DAMAGE" },
        { statKey = "ATTACK_AP" },
        { statKey = "DCS_ATTACK_ATTACKSPEED" },
		{ statKey = "WEAPON_DPS" },
        { statKey = "SPELLPOWER" },
        { statKey = "MANAREGEN" },
        { statKey = "ENERGY_REGEN" },
        { statKey = "DCS_RUNEREGEN" },
        { statKey = "FOCUS_REGEN" },		
        { statKey = "GCD" },
	{ statKey = "DefenseCategory" },
        { statKey = "DODGE", hideAt = 0 },
        { statKey = "PARRY", hideAt = 0 },
		{ statKey = "BLOCK", hideAt = 0, showFunc = C_PaperDollInfo.OffhandHasShield },
	{ statKey = "RatingCategory" },
		{ statKey = "CRITCHANCE_RATING", hideAt = 0 },
		{ statKey = "HASTE_RATING", hideAt = 0 },
		{ statKey = "VERSATILITY_RATING", hideAt = 0 },
		{ statKey = "MASTERY_RATING", hideAt = 0 },
		{ statKey = "LIFESTEAL_RATING", hideAt = 0 },
		{ statKey = "AVOIDANCE_RATING", hideAt = 0 },
		{ statKey = "DODGE_RATING", hideAt = 0 },
		{ statKey = "PARRY_RATING", hideAt = 0 },
		{ statKey = "SPEED_RATING", hideAt = 0, hidden = true },
		{ statKey = "SPEED", hideAt = 0, hidden = true }, --seems like Blizzard's implemented speed rating
		{ statKey = "STAGGER", hideAt = 0, roles = {"TANK"} },
	{ statKey = "HonorCategory" },
		{ statKey = "HONOR_PROGRESS", hideAt = 0 },
		{ statKey = "HONOR_LEVEL", hideAt = 0 },
	{ statKey = "UserCat1" },
	{ statKey = "UserCat2" },
	{ statKey = "UserCat3" },
	{ statKey = "UserCat4" },
	{ statKey = "UserCat5" },
})

--for _, v in ipairs(DefaultTankTBL) do if v.statKey:find("_RATING$") then v.hidden = true end end
--for _, v in ipairs(DefaultNonTankTBL) do if v.statKey:find("_RATING$") then v.hidden = true end end
--local DefaultTankData = DCS_TableData:MergeTable(DefaultTankTBL)
--local DefaultNonTankData = DCS_TableData:MergeTable(DefaultTankTBL)

--[[
local function DefaultDataForSpec(specID)
    local _, cls = UnitClass("PLAYER")
    local _, _, _, _, role, primaryStat = GetSpecializationInfo(GetSpecialization())
    for _, v in ipairs(StatsTable) do
        v.hidden = v.statKey == "ITEMLEVEL" or v.statKey == "POWER" or v.statKey == "ALTERNATEMANA"
                or v.statKey == "WEAPON_DPS" or v.statKey == "DCS_POWER" or v.statKey == "DCS_ALTERNATEMANA" --reset
        if v.statKey:find("_RATING$") then v.hidden = true end
        if v.statKey == "STRENGTH" then v.hidden = primaryStat ~= 1 --/dump SPEC_STAT_STRINGS[1]
        elseif v.statKey == "AGILITY" then v.hidden = primaryStat ~= 2
        elseif v.statKey == "INTELLECT" then v.hidden = primaryStat ~= 4
        elseif v.statKey == "ARMOR" then v.hidden = role ~= "TANK"
        elseif v.statKey == "ATTACK_DAMAGE" or v.statKey == "ATTACK_AP" or v.statKey == "ATTACK_ATTACKSPEED" then v.hidden = role == "HEALER"
        elseif v.statKey == "AVOIDANCE" or v.statKey == "DODGE" or v.statKey == "PARRY" or v.statKey == "BLOCK" then v.hidden = role ~= "TANK"
        elseif v.statKey == "SPELLPOWER" or v.statKey == "MANAREGEN" then
            v.hidden = role == "TANK" or cls == "WARRIOR" or cls == "DEATHKNIGHT" or cls == "DEMONHUNTER" or cls == "HUNTER" or cls == "ROGUE"
        end
    end
    return DCS_TableData:MergeTable(StatsTable)
end
--]]

local ShownData = DefaultNonTankData 

for k, v in pairs(DCS_TableData.StatData) do
	if (not v.frame) then
		if (v.category) then
			v.frame = CreateFrame("FRAME", nil, StatFrame, "CharacterStatFrameCategoryTemplate")
			v.frame:SetHeight(28)
			v.frame.Background:SetHeight(28)
			if k == "GeneralCategory" then
				v.frame.Title:SetText(L["General"])
			end
			if k == "OffenseCategory" then
				v.frame.Title:SetText(L["Offense"])
			end
			if k == "DefenseCategory" then
				v.frame.Title:SetText(L["Defense"])
			end
			if k == "RatingCategory" then
				v.frame.Title:SetText(L["Ratings"])
			end
			if k == "HonorCategory" then
				v.frame.Title:SetText(L["Honor Category"])
			end
			if k == "UserCat1" then
				v.frame.Title:SetText()
			end
			if k == "UserCat2" then
				v.frame.Title:SetText()
			end
			if k == "UserCat3" then
				v.frame.Title:SetText()
			end
			if k == "UserCat4" then
				v.frame.Title:SetText()
			end
			if k == "UserCat5" then
				v.frame.Title:SetText()
			end
		else
			v.frame = CreateFrame("FRAME", nil, StatFrame, "CharacterStatFrameTemplate")
		end
	end
	v.frame.statKey = k
end

local function verify_sanity()
	for k, i in ipairs(ShownData) do
		for l, j in ipairs(DefaultNonTankData) do
			if i.statKey == j.statKey then
				if i.hideAt ~= j.hideAt then
					ShownData[k] = DefaultNonTankData[l]
				end
			end
		end
	end
end

local function UpdateStatFrameWidth(width)
	local stat
	for _, v in ipairs(ShownData) do
		stat = DCS_TableData.StatData[v.statKey]
		if (stat) then
			stat.frame:SetWidth(width)
			if (stat.frame.Background) then
				stat.frame.Background:SetWidth(width)
			end
		end
	end
end

	local DCS_TableRelevantStatstooltipText
	local relevantStatsSetChecked = true
	local function DCS_TableRelevantStats_init()
		if relevantStatsSetChecked then
			DCS_TableRelevantStatstooltipText = L["Show only stats relevant to your class spec."] --Creates a tooltip on mouseover.
			_G[DCS_TableRelevantStats:GetName() .. "Text"]:SetText(L["Relevant Stats"])
		else
			DCS_TableRelevantStatstooltipText = L["Show all stats."] --Creates a tooltip on mouseover.
			_G[DCS_TableRelevantStats:GetName() .. "Text"]:SetText(L["All Stats"])
			return
		end
	end

-----------------------
-- Config Mode Setup --
-----------------------

local function set_relevant_stat_state()
	local stat
	local ccount = 0
	for _, v in ipairs(ShownData) do
        stat = DCS_TableData.StatData[v.statKey]
		if stat then
			if not v.hidden then ccount = ccount +1 end
		end
	end
	local temp = ccount/#ShownData
	if temp < 1 then --playing safe, probably 0.9 is sufficient; maybe epsilon check is needed?
		relevantStatsSetChecked = false
	else
		relevantStatsSetChecked = true
	end
	DCS_TableRelevantStats_init()
end

local configMode = false

local function ShowCharacterStats(unit)
	if not PaperDollFrame:IsVisible() and not SettingsPanel:IsVisible() then
		return
	end
	namespace.configMode = configMode
    local stat
    local count, backgroundcount, height = 0, false, 4
	local hideatzero = gdbprivate.gdb.gdbdefaults.dejacharacterstatsHideAtZeroChecked.SetChecked --placeholder for the checkbox hideatzero
    for _, v in ipairs(ShownData) do
        stat = DCS_TableData.StatData[v.statKey]
		if stat then
			if (configMode) then
				stat.frame:Show()
				stat.updateFunc(stat.frame, unit)
				stat.frame.checkButton:Show()
				stat.frame.checkButton:SetChecked(not v.hidden)
				if (v.hidden) then
					stat.frame:SetAlpha(0.32)
				else
					stat.frame:SetAlpha(1)
				end
			else
				if v.hidden then
					stat.frame:Hide()
				else
					stat.updateFunc(stat.frame, unit)
					if hideatzero then
						if v.hideAt then
							if v.hideAt == stat.frame.numericValue then
								stat.frame:Hide()
							end
						end
					end
					if (stat.frame.checkButton) then
						stat.frame.checkButton:Hide()
					end
				end
			end
			if (stat.frame:IsShown()) then
				stat.frame:ClearAllPoints()
				stat.frame:SetPoint("TOPLEFT", StatFrame.AnchorFrame, "TOPLEFT", 0, -height)
				if (stat.category) then
					count = count + 2
				else
					count = count + 1
				end
				if (stat.category) then
					backgroundcount = false
				else
					stat.frame.Background:SetShown(backgroundcount)
					backgroundcount = not backgroundcount
				end
				if not (configMode) then
					stat.frame:SetAlpha(1)
				end
				height = height + stat.frame:GetHeight()
			end
		end
		
	end
	height = floor(height)
	StatFrame:SetHeight(height)
	if count <= 24 then
		UpdateStatFrameWidth(191)
		StatScrollFrame.ScrollBar:Hide()
	else

		if scrollbarchecked then
			UpdateStatFrameWidth(180)
			StatScrollFrame.ScrollBar:Show()
		else
			UpdateStatFrameWidth(191)
			StatScrollFrame.ScrollBar:Hide()
		end			
	end
	set_relevant_stat_state()
end

local function DCS_Table_ShowAllStats()
	for _, v in ipairs(ShownData) do
		v.hidden = false
	end
	ShowCharacterStats("player")
end

local function DCS_Table_Relevant()
	local uniqueKey = UnitName("player") .. ":" .. GetRealmName() .. ":" .. GetSpecialization()

	local spec = GetSpecialization();
	local role = GetSpecializationRole(spec)
	local hashonorlevel = UnitHonorLevel("player")
    --local hasconquestlevel,_,hasconquestquest = PVPGetConquestLevelInfo()  --todo:abyui10

	for _, v in ipairs(ShownData) do
		if v.hidden then v.hidden = false end
	end 

    --abyui use default hidden
    for _, v1 in ipairs(ShownData) do
        for _, v2 in ipairs(role == "TANK" and DefaultTankData or DefaultNonTankData) do
            if v1.statKey == v2.statKey then
                if v2.hidden then v1.hidden = true end
            end
        end
    end

	local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
    for _, v in ipairs(ShownData) do
		if primaryStat ~= LE_UNIT_STAT_STRENGTH then
			if v.statKey == "STRENGTH" then v.hidden = true end
			if v.statKey == "DCS_RUNEREGEN" then v.hidden = true end
		end
		if primaryStat ~= LE_UNIT_STAT_AGILITY then
			if v.statKey == "AGILITY" then v.hidden = true end
		end
		if primaryStat ~= LE_UNIT_STAT_INTELLECT then
			if v.statKey == "INTELLECT" then v.hidden = true end
			if v.statKey == "SPELLPOWER" then v.hidden = true end
			if v.statKey == "MANAREGEN" then v.hidden = true end
		end
		if primaryStat == LE_UNIT_STAT_INTELLECT  then
			if v.statKey == "ATTACK_DAMAGE" then v.hidden = true end
			if v.statKey == "ATTACK_AP" then v.hidden = true end
			if v.statKey == "DCS_ATTACK_ATTACKSPEED" then v.hidden = true end
			if v.statKey == "WEAPON_DPS" then v.hidden = true end
		end
		if role ~= "TANK" then
			if v.statKey == "DefenseCategory" then v.hidden = true end --If not a tank then Defense category and its relevant stats are hidden.
			if v.statKey == "DODGE" then v.hidden = true end
			if v.statKey == "PARRY" then v.hidden = true end
			if v.statKey == "BLOCK" then v.hidden = true end
		end
		if v.roles then
			local hidden = true
			for _,j in pairs(v.roles) do
				if j == role then
					hidden = false
				end
			end
			v.hidden = hidden
		end
		--visibility of ratings is off by default
		if v.statKey == "CRITCHANCE_RATING" then v.hidden = true end
		if v.statKey == "HASTE_RATING" then v.hidden = true end
		if v.statKey == "VERSATILITY_RATING" then v.hidden = true end
		if v.statKey == "MASTERY_RATING" then v.hidden = true end
		if v.statKey == "LIFESTEAL_RATING" then v.hidden = true end
		if v.statKey == "AVOIDANCE_RATING" then v.hidden = true end
		if v.statKey == "DODGE_RATING" then v.hidden = true end
		if v.statKey == "PARRY_RATING" then v.hidden = true end
		if v.statKey == "SPEED_RATING" then v.hidden = true end
		if v.statKey == "SPEED" then v.hidden = true end

		if v.statKey == "ITEMLEVEL" then v.hidden = true end

		if v.statKey == "UserCat1" then v.hidden = true end
		if v.statKey == "UserCat2" then v.hidden = true end
		if v.statKey == "UserCat3" then v.hidden = true end
		if v.statKey == "UserCat4" then v.hidden = true end
		if v.statKey == "UserCat5" then v.hidden = true end

		--if v.statKey == "GeneralCategory" then v.hidden = true end
		--if v.statKey == "OffenseCategory" then v.hidden = true end
		--if v.statKey == "DefenseCategory" then v.hidden = true end
		if v.statKey == "RatingCategory" then v.hidden = true end --ratings are invisible, so the category is also hidden
		--visiblity of pvp info is off by default
		if (hashonorlevel < 1 ) then		
			if v.statKey == "HonorCategory" then v.hidden = true end
			if v.statKey == "HONOR_PROGRESS" then v.hidden = true end
			if v.statKey == "HONOR_LEVEL" then v.hidden = true end
		end
	end
	ShownData.uniqueKey = uniqueKey
	DCS_ClassSpecDB[uniqueKey] = ShownData
end

local function DCS_Login_Initialization()
	local spec = GetSpecialization();
	local role = GetSpecializationRole(spec)
	local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
	local uniqueKey = UnitName("player") .. ":" .. GetRealmName() .. ":" .. spec
	if (DCS_ClassSpecDB[uniqueKey]) then
		if (ShownData.uniqueKey ~= uniqueKey) then
			ShownData = DCS_TableData:MergeTable(DCS_ClassSpecDB[uniqueKey], DefaultNonTankData) --not so easy to understand when gets here. is it during change of specialisation?
			verify_sanity()
		end
	else
		if role == "TANK" then
			ShownData = DCS_TableData:CopyTable(DefaultTankData)
		else
			ShownData = DCS_TableData:CopyTable(DefaultNonTankData)
		end
		DCS_Table_Relevant()
	end
end

local function DCS_Table_Reset()
	local temp
	local spec = GetSpecialization();
	local role = GetSpecializationRole(spec)
	if role == "TANK" then
		temp = DCS_TableData:CopyTable(DefaultTankData)
	else
		temp = DCS_TableData:CopyTable(DefaultNonTankData)
	end
	local uniqueKey = UnitName("player") .. ":" .. GetRealmName() .. ":" .. spec
	for _, v1 in ipairs(temp) do
		for _, v2 in ipairs(ShownData) do
			if v1.statKey == v2.statKey then
				v1.hidden = v2.hidden
			end
		end
	end
	ShownData = temp
	ShownData.uniqueKey = uniqueKey
	DCS_ClassSpecDB[uniqueKey] = ShownData
	if IsModifierKeyDown() then DCS_Table_Relevant() end
	ShowCharacterStats("player")
end


-------------------------
-- Drag 'n' Drop Stats --
-------------------------
local DragSourceFrame, DragTargetFrame

local function OnDragStart(self)
	if (not configMode) then return end
	DragSourceFrame = self
	local cursorX, cursorY = GetCursorPosition()
	local uiScale = UIParent:GetScale()
	local adjust = select(5, UIParent:GetPoint(2)) or 0
	self:StartMoving()
	self:ClearAllPoints()
	self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", cursorX / uiScale, (cursorY-adjust) / uiScale)
end

local function OnDragStop(self)
	if (not configMode) then return end
	DragSourceFrame = false
	self:StopMovingOrSizing()
	local stat, dst
	for i, v in ipairs(ShownData) do
		stat = DCS_TableData.StatData[v.statKey]
		if (stat.frame.statKey ~= self.statKey and stat.frame:IsMouseOver()) then
			DCS_TableData:SwapStat(ShownData, self.statKey, v)
			break
		end
	end
	if (DragTargetFrame) then
		DragTargetFrame.anchorBar:Hide()
	end
	ShowCharacterStats("player")
end

local function onCheckClick(self)
	local checked = self:GetChecked()
	local statKey = self:GetParent().statKey
	if (checked) then
		self:GetParent():SetAlpha(1)
	else
		self:GetParent():SetAlpha(0.32)
	end
	for _, v in ipairs(ShownData) do
		if (v.statKey == statKey) then
			v.hidden = not checked
			break
		end
	end
	set_relevant_stat_state()
end

for k, v in pairs(DCS_TableData.StatData) do
	v.frame:SetMovable(true)
	v.frame:EnableMouse(true) --without this normal stats (but not categories) are draggable 
	v.frame:RegisterForDrag("LeftButton")
	v.frame:HookScript("OnDragStart", OnDragStart)
	v.frame:HookScript("OnDragStop", OnDragStop)
	v.frame.checkButton = CreateFrame("CheckButton", nil, v.frame, "UICheckButtonTemplate")
	v.frame.checkButton:SetSize(14, 14)
	v.frame.checkButton:SetPoint("LEFT", -1, 0)
	v.frame.checkButton:SetScript("OnClick", onCheckClick)
	v.frame.checkButton:Hide()
	v.frame.anchorBar = v.frame:CreateTexture(nil, "OVERLAY")
	v.frame.anchorBar:SetPoint("TOPLEFT", 0, 2)
	v.frame.anchorBar:SetPoint("TOPRIGHT", 0, -2)
	v.frame.anchorBar:SetColorTexture(1, 0.8, 0)
	v.frame.anchorBar:Hide()
end

StatScrollFrame:HookScript("OnUpdate", function(self, elasped)
	if (DragSourceFrame) then
		self.timer = (self.timer or 0) + elasped
		if (self.timer > 0.2) then
			local stat
			for i, v in ipairs(ShownData) do
				stat = DCS_TableData.StatData[v.statKey]
				if (stat.frame.statKey ~= DragSourceFrame.statKey and stat.frame:IsMouseOver()) then
					DragTargetFrame = stat.frame
					stat.frame.anchorBar:Show()
				else
					stat.frame.anchorBar:Hide()
				end
			end
			self.timer = 0
		end
	end
end)

---------------------
-- Show/Hide Logic --
---------------------
char_ctats_pane:HookScript("OnShow", function(self)
	self:Hide()
	StatScrollFrame:Show()
end)

hooksecurefunc("PaperDollFrame_UpdateStats", function()
		ShowCharacterStats("player")
end)

hooksecurefunc("PaperDollFrame_SetSidebar", function(self, index)
	if (PaperDollFrame.currentSideBar and PaperDollFrame.currentSideBar:GetName() == "CharacterStatsPane") then
		StatScrollFrame:Show()
	else
		StatScrollFrame:Hide()
	end
end)

------------------------
-- Reset Stats Button --
------------------------
local DCS_TableResetCheck = CreateFrame("Button", "DCS_TableResetButton", CharacterFrameInsetRight, "UIPanelButtonTemplate")
	DCS_TableResetCheck:ClearAllPoints()
	DCS_TableResetCheck:SetPoint("BOTTOMRIGHT", 5, -36)
	DCS_TableResetCheck:SetScale(0.80)
	DCS_TableResetCheck:Hide()

	DCS_TableResetCheck:SetWidth(125)
	DCS_TableResetCheck:SetHeight(30)
	DCS_TableResetCheck.tooltipText = L["Resets order of stats."] --Creates a tooltip on mouseover. --needs to be localised
	_G[DCS_TableResetCheck:GetName() .. "Text"]:SetText(L["Reset Stats"]) -- somehow now the name seems wrong

	DCS_TableResetCheck:SetScript("OnClick", function(self, button, down)
		DCS_Table_Reset()
	end)

------------------------
-- Config Mode Toggle --
------------------------
local DCS_ConfigtooltipText = L["Unlock DCS"]

local function set_config_mode(state)
	configMode = state
	if state then --on
		DCS_ConfigtooltipText = L["Lock DCS"]
		DCS_TableResetCheck:Show()
		DCS_TableRelevantStats:Show()
	else --off
		DCS_ConfigtooltipText = L["Unlock DCS"]
		DCS_TableRelevantStats:Hide()
		DCS_TableResetCheck:Hide()
	end
end

local DCS_configButton = CreateFrame("Button", "DCS_configButton", PaperDollSidebarTabs)
local DCS_InterfaceOptConfigButton = CreateFrame("Button", "DCS_InterfaceOptConfigButton", DejaCharacterStatsPanel)

	DCS_configButton:SetSize(32, 32)
	DCS_configButton:RegisterEvent("MERCHANT_SHOW")
	DCS_configButton:RegisterEvent("MERCHANT_CLOSED")
	DCS_configButton:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_configButton:SetFrameStrata("TOOLTIP")
	DCS_configButton:SetPoint("BOTTOMRIGHT", PaperDollSidebarTabs, "TOPRIGHT", -10, -2)
	DCS_configButton:SetNormalTexture("Interface\\BUTTONS\\LockButton-Locked-Up")
	DCS_configButton:SetPushedTexture("Interface\\BUTTONS\\LockButton-Unlocked-Down")
	DCS_configButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight", "ADD")
	
DCS_configButton:SetScript("OnEvent", function(self, event, ...)
	PaperDollFrame_UpdateStats()
end)

local function DCS_configButton_OnEnter(self)
	GameTooltip:SetOwner(DCS_configButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(DCS_ConfigtooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DCS_configButton_OnLeave(self)
	GameTooltip_Hide()
 end
 
	DCS_configButton:SetScript("OnEnter", DCS_configButton_OnEnter)
	DCS_configButton:SetScript("OnLeave", DCS_configButton_OnLeave)

local function dcsRStatConfigButtonsHide()
	DCS_TableRelevantStats:ClearAllPoints()
	DCS_TableRelevantStats:SetParent(UIParent)
	DCS_TableRelevantStats:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", -100, 100)

	DCS_TableResetCheck:ClearAllPoints()
	DCS_TableResetCheck:SetParent(UIParent)
	DCS_TableResetCheck:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", -100, 100)
end

local function configButtonOnClose()
    if CharacterFrameInsetRightScrollBar.SetVerticalScroll then StatScrollFrame:SetVerticalScroll(0) end
	set_config_mode(false)
	dcsRStatConfigButtonsHide()

	DCS_configButton:SetNormalTexture("Interface\\BUTTONS\\LockButton-Locked-Up")
	DCS_InterfaceOptConfigButton:SetNormalTexture("Interface\\BUTTONS\\LockButton-Locked-Up")
	ShowCharacterStats("player")
end

--------------------------
-- Toggle Expand Button --
--------------------------
local _, gdbprivate = ...
	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsConfigButtonChecked = {
		ConfigButtonSetChecked = true,
}

local DCS_ConfigButtonCheck = CreateFrame("CheckButton", "DCS_ConfigButtonCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ConfigButtonCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ConfigButtonCheck:ClearAllPoints()
	DCS_ConfigButtonCheck:SetPoint("LEFT", 130, -205)
	DCS_ConfigButtonCheck:SetScale(1)
	DCS_ConfigButtonCheck.tooltipText = L['Displays the configuration (lock) button for the character stats frame.'] --Creates a tooltip on mouseover.
	_G[DCS_ConfigButtonCheck:GetName() .. "Text"]:SetText(L["Show Config"])
	
	DCS_ConfigButtonCheck:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsConfigButtonChecked.ConfigButtonSetChecked
			self:SetChecked(checked)
			if checked then
				DCS_configButton:Show()
			else
				DCS_configButton:Hide()
			end
		end
	end)

	DCS_ConfigButtonCheck:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsConfigButtonChecked.ConfigButtonSetChecked = checked
		if checked then
			DCS_configButton:Show()
		else
			DCS_configButton:Hide()
		end
	end)

local function DCS_ClassCrestBGCheck()
	if DCS_ClassBackgroundCheck:GetChecked(true) then
		char_ctats_pane.ClassBackground:Show() 
	else
		char_ctats_pane.ClassBackground:Hide()
	end
end

DejaCharacterStatsPanel:Hide()

local function DCS_DefaultStatsAnchors()
	DCS_InterfaceOptConfigButton:UnregisterEvent("UNIT_AURA")
	DCS_InterfaceOptConfigButton:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")

	StatScrollFrame:ClearAllPoints()
	StatScrollFrame:SetParent(CharacterFrameInsetRight)
	StatScrollFrame:SetPoint("TOPLEFT", CharacterFrameInsetRight, "TOPLEFT", 5, -6)
	StatScrollFrame:SetPoint("BOTTOMRIGHT", CharacterFrameInsetRight, "BOTTOMRIGHT", 0, 3)

	StatScrollFrame.ScrollBar:ClearAllPoints()
	StatScrollFrame.ScrollBar:SetParent(StatScrollFrame)
	StatScrollFrame.ScrollBar:SetPoint("TOPLEFT", StatScrollFrame, "TOPRIGHT", -16, -16)
	StatScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", StatScrollFrame, "BOTTOMRIGHT", -16, 16)
	StatScrollFrame.ScrollBar:Hide()

	char_ctats_pane.ClassBackground:ClearAllPoints()
	char_ctats_pane.ClassBackground:SetParent(StatScrollFrame)
	char_ctats_pane.ClassBackground:SetPoint("TOP", StatScrollFrame, "TOP", -2.50, 3)	

	configButtonOnClose()
	DCS_ClassCrestBGCheck()
	ShowCharacterStats("player")
end

local function DCS_InterfaceOptionsStatsAnchors()
	if (DejaCharacterStatsPanel~=nil) then
		DCS_InterfaceOptConfigButton:RegisterEvent("UNIT_AURA")
		DCS_InterfaceOptConfigButton:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
		set_config_mode(true)
				
		StatScrollFrame:ClearAllPoints()
		StatScrollFrame:SetParent(DejaCharacterStatsPanel)
		StatScrollFrame:SetPoint("TOPRIGHT", DejaCharacterStatsPanel, "TOPRIGHT", -64, -80)
		StatScrollFrame:SetSize(200, 394)
		StatScrollFrame:Show()

		StatScrollFrame.ScrollBar:ClearAllPoints()
		StatScrollFrame.ScrollBar:SetParent(StatScrollFrame)
		StatScrollFrame.ScrollBar:SetPoint("TOPLEFT", StatScrollFrame, "TOPRIGHT", -15, -16)
		StatScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", StatScrollFrame, "BOTTOMRIGHT", -15, 16)
		StatScrollFrame.ScrollBar:Hide()

		DCS_TableRelevantStats:ClearAllPoints()
		DCS_TableRelevantStats:SetParent(StatScrollFrame)
		DCS_TableRelevantStats:SetPoint("BOTTOMRIGHT", -122,-42)

		DCS_TableResetCheck:ClearAllPoints()
		DCS_TableResetCheck:SetParent(StatScrollFrame)
		DCS_TableResetCheck:SetPoint("BOTTOMRIGHT", 3, -42)

		char_ctats_pane.ClassBackground:ClearAllPoints()
		char_ctats_pane.ClassBackground:SetParent(DejaCharacterStatsPanel)
		char_ctats_pane.ClassBackground:SetPoint("TOPLEFT", DejaCharacterStatsPanel, "TOPLEFT", 377, -80)
		char_ctats_pane.ClassBackground:SetPoint("BOTTOMRIGHT", DejaCharacterStatsPanel, "BOTTOMRIGHT", -48, 126)
		char_ctats_pane.ClassBackground:Show()

		DCS_ClassCrestBGCheck()
		ShowCharacterStats("player")
	end
end	
	
CharacterFrameInsetRight:HookScript("OnShow", function(self)
	DCS_DefaultStatsAnchors()
end)

CharacterFrameInsetRight:HookScript("OnHide", function(self)
	if SettingsPanel:IsShown() then
		DCS_InterfaceOptionsStatsAnchors()
	else
		CharacterFrameInsetRightScrollBar:SetValue(0)
	
		StatScrollFrame:ClearAllPoints()
		StatScrollFrame:SetParent(UIParent)
		StatScrollFrame:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", -100, 100)
		StatScrollFrame:Hide()

		StatScrollFrame.ScrollBar:ClearAllPoints()
		StatScrollFrame.ScrollBar:SetParent(UIParent)
		StatScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -160, 160)
		StatScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", -160, 160)
		StatScrollFrame.ScrollBar:Hide()

		DCS_TableRelevantStats:Hide() 	--For some reason these two have to be hidden again even tho they are hidden with configButtonOnClose() below.
		DCS_TableResetCheck:Hide()		--For some reason these two have to be hidden again even tho they are hidden with configButtonOnClose() below.

		char_ctats_pane.ClassBackground:ClearAllPoints()
		char_ctats_pane.ClassBackground:SetParent(UIParent)
		char_ctats_pane.ClassBackground:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", 0, 0)
		char_ctats_pane.ClassBackground:Show()

		configButtonOnClose()
	end
end)

	DCS_configButton:SetScript("OnMouseUp", function(self, button, up)
		configMode = not configMode
		if (configMode) then
			self:SetNormalTexture("Interface\\BUTTONS\\LockButton-Unlocked-Up")
			
			DCS_TableRelevantStats:ClearAllPoints()
			DCS_TableRelevantStats:SetParent(CharacterFrameInsetRight)
			DCS_TableRelevantStats:SetPoint("BOTTOMRIGHT", -130,-36)

			DCS_TableResetCheck:ClearAllPoints()
			DCS_TableResetCheck:SetParent(CharacterFrameInsetRight)
			DCS_TableResetCheck:SetPoint("BOTTOMRIGHT", 5, -36)
			
			set_config_mode(true)
		else
			configButtonOnClose()
		end
		ShowCharacterStats("player")
		DCS_configButton_OnEnter()
	end)

------------------------
-- Relevant Stats Button --
------------------------
local function DCS_TableRelevantStats_OnEnter(self)
	GameTooltip:SetOwner(DCS_TableRelevantStats, "ANCHOR_RIGHT");
	GameTooltip:SetText(DCS_TableRelevantStatstooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DCS_TableRelevantStats_OnLeave(self)
	GameTooltip_Hide()
 end
 
local DCS_TableRelevantStats = CreateFrame("Button", "DCS_TableRelevantStats", CharacterFrameInsetRight, "UIPanelButtonTemplate")
	DCS_TableRelevantStats:RegisterEvent("VARIABLES_LOADED")
	DCS_TableRelevantStats:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	DCS_TableRelevantStats:ClearAllPoints()
	DCS_TableRelevantStats:SetPoint("BOTTOMRIGHT", -130,-36)
	DCS_TableRelevantStats:SetScale(0.80)
	DCS_TableRelevantStats:Hide()

	DCS_TableRelevantStats:SetWidth(125)
	DCS_TableRelevantStats:SetHeight(30)

	DCS_TableRelevantStats:SetScript("OnEnter", DCS_TableRelevantStats_OnEnter)
	DCS_TableRelevantStats:SetScript("OnLeave", DCS_TableRelevantStats_OnLeave)

	DCS_TableRelevantStats:SetScript("OnClick", function(self, button, up)
		if relevantStatsSetChecked then
			DCS_Table_Relevant()
		else
			DCS_Table_ShowAllStats()
		end
		ShowCharacterStats("player")
		DCS_TableRelevantStats_OnEnter()
	end)

	DCS_TableRelevantStats:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_SPECIALIZATION_CHANGED" and (...) ~= "player" then return end
		DCS_Login_Initialization()
		DCS_TableRelevantStats_init()
		
		if event == "PLAYER_SPECIALIZATION_CHANGED" then 
			set_config_mode(true) -- This allows the ratings stats and category headrs to be shown when changin specs. No clue why, but it works.
			local function DCS_ReShowSelectedStats()
				set_config_mode(false) -- This hides the above shown config mode 0.01 secs after showing it becasue we dont want it shown, but showing it shows the selected stats, so we need to exit config after entering it.
			end
			C_Timer.After(0.01, DCS_ReShowSelectedStats)
			ShowCharacterStats("player")
		end
	end)
	
------------------------------------------
-- Interface Options Config Mode Toggle --
------------------------------------------
--creation of DCS_InterfaceOptConfigButton near DCS_configButton
	DCS_InterfaceOptConfigButton:RegisterEvent("PLAYER_LOGIN")
	DCS_InterfaceOptConfigButton:ClearAllPoints()
	DCS_InterfaceOptConfigButton:SetPoint("TOPRIGHT", 0, 0)
	DCS_InterfaceOptConfigButton:SetSize(36, 36)
	DCS_InterfaceOptConfigButton:SetScale(1.25)
	DCS_InterfaceOptConfigButton:SetNormalTexture("Interface\\BUTTONS\\LockButton-Locked-Up")
	DCS_InterfaceOptConfigButton:SetPushedTexture("Interface\\BUTTONS\\LockButton-Unlocked-Down")
	DCS_InterfaceOptConfigButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight", "ADD")
	
local function DCS_InterfaceOptConfigButton_OnEnter(self)
	GameTooltip:SetOwner(DCS_InterfaceOptConfigButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(DCS_ConfigtooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DCS_InterfaceOptConfigButton_OnLeave(self)
	GameTooltip_Hide()
 end
 
	DCS_InterfaceOptConfigButton:SetScript("OnEnter", DCS_InterfaceOptConfigButton_OnEnter)
	DCS_InterfaceOptConfigButton:SetScript("OnLeave", DCS_InterfaceOptConfigButton_OnLeave)

	DCS_InterfaceOptConfigButton:SetScript("OnEvent", function(self, event)
				ShowCharacterStats("player")
	end)
	
	DCS_InterfaceOptConfigButton:SetScript("OnMouseUp", function(self, button, up)
		configMode = not configMode
		if (configMode) then
			self:SetNormalTexture("Interface\\BUTTONS\\LockButton-Unlocked-Up")
			set_config_mode(true) --might get improved into set_config_mode(configMode)
		else
			self:SetNormalTexture("Interface\\BUTTONS\\LockButton-Locked-Up")
			set_config_mode(false)
		end
		ShowCharacterStats("player")
		DCS_InterfaceOptConfigButton_OnEnter()
	end)
	_G.DCS_configButton = DCS_configButton

----------------------------
-- Scrollbar Check Button --
----------------------------
local DCS_ScrollbarCheck = CreateFrame("CheckButton", "DCS_ScrollbarCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ScrollbarCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ScrollbarCheck:ClearAllPoints()
	--DCS_ScrollbarCheck:SetPoint("LEFT", 30, -225)
	DCS_ScrollbarCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS",7, -55)
	DCS_ScrollbarCheck:SetScale(1)
	DCS_ScrollbarCheck.tooltipText = L["Displays the DCS scrollbar."] --Creates a tooltip on mouseover.
	_G[DCS_ScrollbarCheck:GetName() .. "Text"]:SetText(L["Scrollbar"])
	
	DCS_ScrollbarCheck:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsScrollbarChecked.ScrollbarSetChecked
			self:SetChecked(checked)
			scrollbarchecked = checked
			self:UnregisterEvent(event)
			--Logic is built into ShowCharacterStats("player")
		end
	end)

	DCS_ScrollbarCheck:SetScript("OnClick", function(self) 
		local checked = self:GetChecked() 
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsScrollbarChecked.ScrollbarSetChecked = checked 
		scrollbarchecked = checked
		ShowCharacterStats("player")
	end)

-----------------------------------
-- Class Background Check Button --
-----------------------------------
local DCS_ClassBackgroundCheck = CreateFrame("CheckButton", "DCS_ClassBackgroundCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ClassBackgroundCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ClassBackgroundCheck:ClearAllPoints()
	DCS_ClassBackgroundCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS",7, -15)
	DCS_ClassBackgroundCheck:SetScale(1)
	DCS_ClassBackgroundCheck.tooltipText = L["Displays the class crest background."] --Creates a tooltip on mouseover.
	_G[DCS_ClassBackgroundCheck:GetName() .. "Text"]:SetText(L["Class Crest Background"])
	
	DCS_ClassBackgroundCheck:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsClassBackgroundChecked.ClassBackgroundChecked
			self:SetChecked(checked)
			if checked then
				char_ctats_pane.ClassBackground:Show() 
			else
				char_ctats_pane.ClassBackground:Hide() 
			end
			self:UnregisterEvent(event);
		end
	end)

	DCS_ClassBackgroundCheck:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsClassBackgroundChecked.ClassBackgroundChecked = checked
		if checked then
			char_ctats_pane.ClassBackground:Show()
		else
			char_ctats_pane.ClassBackground:Hide()
		end
        ShowCharacterStats("player") --does it need to be called?
	end)

SettingsPanel:HookScript("OnShow", function(self)
	DCS_InterfaceOptionsStatsAnchors()
end)

SettingsPanel:HookScript("OnHide", function(self)
	DCS_DefaultStatsAnchors()
end)
