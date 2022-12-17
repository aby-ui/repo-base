

local dversion = 405
local major, minor = "DetailsFramework-1.0", dversion
local DF, oldminor = LibStub:NewLibrary(major, minor)

if (not DF) then
	DetailsFrameworkCanLoad = false
	return
end

_G["DetailsFramework"] = DF

DetailsFrameworkCanLoad = true
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local _
local type = type
local unpack = unpack
local upper = string.upper
local string_match = string.match
local tinsert = _G.tinsert
local abs = _G.abs
local tremove = _G.tremove

local IS_WOW_PROJECT_MAINLINE = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local IS_WOW_PROJECT_NOT_MAINLINE = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE

local UnitPlayerControlled = UnitPlayerControlled
local UnitIsTapDenied = UnitIsTapDenied

SMALL_NUMBER = 0.000001
ALPHA_BLEND_AMOUNT = 0.8400251

DF.dversion = dversion

DF.AuthorInfo = {
	Name = "Terciob",
	Discord = "https://discord.gg/AGSzAZX",
}

function DF:Msg(msg, ...)
	print("|cFFFFFFAA" .. (self.__name or "FW Msg:") .. "|r ", msg, ...)
end

local PixelUtil = PixelUtil or DFPixelUtil
if (not PixelUtil) then
	--check if is in classic, TBC, or WotLK wow, if it is, build a replacement for PixelUtil
	local gameVersion = GetBuildInfo()
	if (gameVersion:match("%d") == "1" or gameVersion:match("%d") == "2" or gameVersion:match("%d") == "3") then
		PixelUtil = {
			SetWidth = function(self, width) self:SetWidth(width) end,
			SetHeight = function(self, height) self:SetHeight(height) end,
			SetSize = function(self, width, height) self:SetSize(width, height) end,
			SetPoint = function(self, ...) self:SetPoint(...) end,
		}
	end
end

function DF:GetDefaultBackdropColor()
	return 0.1215, 0.1176, 0.1294, 0.8
end

function DF.IsDragonflightAndBeyond()
	return select(4, GetBuildInfo()) >= 100000
end

function DF.IsDragonflight()
	local _, _, _, buildInfo = GetBuildInfo()
	if (buildInfo < 110000 and buildInfo >= 100000) then
		return true
	end
end

function DF.IsTimewalkWoW()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 40000) then
        return true
    end
end

function DF.IsClassicWow()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 20000) then
        return true
    end
end

function DF.IsTBCWow()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 30000 and buildInfo >= 20000) then
        return true
    end
end

function DF.IsWotLKWow()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 40000 and buildInfo >= 30000) then
        return true
    end
end

function DF.IsWotLKWowWithRetailAPI()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 40000 and buildInfo >= 30401) then
        return true
    end
end

function DF.IsShadowlandsWow()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 100000 and buildInfo >= 90000) then
        return true
    end
end

local roleBySpecTextureName = {
	DruidBalance = "DAMAGER",
	DruidFeralCombat = "DAMAGER",
	DruidRestoration = "HEALER",

	HunterBeastMastery = "DAMAGER",
	HunterMarksmanship = "DAMAGER",
	HunterSurvival = "DAMAGER",

	MageArcane = "DAMAGER",
	MageFrost = "DAMAGER",
	MageFire = "DAMAGER",

	PaladinCombat = "DAMAGER",
	PaladinHoly = "HEALER",
	PaladinProtection = "TANK",

	PriestHoly = "HEALER",
	PriestDiscipline = "HEALER",
	PriestShadow = "DAMAGER",

	RogueAssassination = "DAMAGER",
	RogueCombat = "DAMAGER",
	RogueSubtlety = "DAMAGER",

	ShamanElementalCombat = "DAMAGER",
	ShamanEnhancement = "DAMAGER",
	ShamanRestoration = "HEALER",

	WarlockCurses = "DAMAGER",
	WarlockDestruction = "DAMAGER",
	WarlockSummoning = "DAMAGER",

	WarriorArm = "DAMAGER",
	WarriorArms = "DAMAGER",
	WarriorFury = "DAMAGER",
	WarriorProtection = "TANK",

	DeathKnightBlood = "TANK",
	DeathKnightFrost = "DAMAGER",
	DeathKnightUnholy = "DAMAGER",
}

--classic, tbc and wotlk role guesser based on the weights of each talent tree
function DF:GetRoleByClassicTalentTree()
	if (not DF.IsTimewalkWoW()) then
		return "NONE"
	end

	--amount of tabs existing
	local numTabs = GetNumTalentTabs() or 3

	--store the background textures for each tab
	local pointsPerSpec = {}

	for i = 1, (MAX_TALENT_TABS or 3) do
		if (i <= numTabs) then
			--tab information
			local name, iconTexture, pointsSpent, fileName = GetTalentTabInfo(i)
			if (name) then
				tinsert(pointsPerSpec, {name, pointsSpent, fileName})
			end
		end
	end

	local MIN_SPECS = 4

	--put the spec with more talent point to the top
	table.sort(pointsPerSpec, function(t1, t2) return t1[2] > t2[2] end)

	--get the spec with more points spent
	local spec = pointsPerSpec[1]
	if (spec and spec[2] >= MIN_SPECS) then
		local specName = spec[1]
		local spentPoints = spec[2]
		local specTexture = spec[3]

		local role = roleBySpecTextureName[specTexture]
		return role or "NONE"
	end
	return "DAMAGER"
end

function DF.UnitGroupRolesAssigned(unitId)
	if (not DF.IsTimewalkWoW()) then --Was function exist check. TBC has function, returns NONE. -Flamanis 5/16/2022
		local role = UnitGroupRolesAssigned(unitId)

		if (role == "NONE" and UnitIsUnit(unitId, "player")) then
			local specializationIndex = GetSpecialization() or 0
			local id, name, description, icon, role, primaryStat = GetSpecializationInfo(specializationIndex)
			return id and role or "NONE"
		end

		return role
	else
		--attempt to guess the role by the player spec
		local classLoc, className = UnitClass(unitId)
		if (className == "MAGE" or className == "ROGUE" or className == "HUNTER" or className == "WARLOCK") then
			return "DAMAGER"
		end

		if (Details) then
			--attempt to get the role from Details! Damage Meter
			local guid = UnitGUID(unitId)
			if (guid) then
				local role = Details.cached_roles[guid]
				if (role) then
					return role
				end
			end
		end

		local role = DF:GetRoleByClassicTalentTree()
		return role
	end
end

--return the specialization of the player it self
function DF.GetSpecialization()
	if (GetSpecialization) then
		return GetSpecialization()
	end
	return nil
end

function DF.GetSpecializationInfoByID(...)
	if (GetSpecializationInfoByID) then
		return GetSpecializationInfoByID(...)
	end
	return nil
end

function DF.GetSpecializationInfo(...)
	if (GetSpecializationInfo) then
		return GetSpecializationInfo(...)
	end
	return nil
end

function DF.GetSpecializationRole(...)
	if (GetSpecializationRole) then
		return GetSpecializationRole(...)
	end
	return nil
end

--build dummy encounter journal functions if they doesn't exists
--this is done for compatibility with classic and if in the future EJ_ functions are moved to C_
DF.EncounterJournal = {
	EJ_GetCurrentInstance = EJ_GetCurrentInstance or function() return nil end,
	EJ_GetInstanceForMap = EJ_GetInstanceForMap or function() return nil end,
	EJ_GetInstanceInfo = EJ_GetInstanceInfo or function() return nil end,
	EJ_SelectInstance = EJ_SelectInstance or function() return nil end,

	EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex or function() return nil end,
	EJ_GetEncounterInfo = EJ_GetEncounterInfo or function() return nil end,
	EJ_SelectEncounter = EJ_SelectEncounter or function() return nil end,

	EJ_GetSectionInfo = EJ_GetSectionInfo or function() return nil end,
	EJ_GetCreatureInfo = EJ_GetCreatureInfo or function() return nil end,
	EJ_SetDifficulty = EJ_SetDifficulty or function() return nil end,
	EJ_GetNumLoot = EJ_GetNumLoot or function() return 0 end,
	EJ_GetLootInfoByIndex = EJ_GetLootInfoByIndex or function() return nil end,
}

--will always give a very random name for our widgets
local init_counter = math.random(1, 1000000)

DF.LabelNameCounter = DF.LabelNameCounter or init_counter
DF.PictureNameCounter = DF.PictureNameCounter or init_counter
DF.BarNameCounter = DF.BarNameCounter or init_counter
DF.DropDownCounter = DF.DropDownCounter or init_counter
DF.PanelCounter = DF.PanelCounter or init_counter
DF.SimplePanelCounter = DF.SimplePanelCounter or init_counter
DF.ButtonCounter = DF.ButtonCounter or init_counter
DF.SliderCounter = DF.SliderCounter or init_counter
DF.SwitchCounter = DF.SwitchCounter or init_counter
DF.SplitBarCounter = DF.SplitBarCounter or init_counter

DF.FRAMELEVEL_OVERLAY = 750
DF.FRAMELEVEL_BACKGROUND = 150

DF.FrameWorkVersion = tostring(dversion)
function DF:PrintVersion()
	print("Details! Framework Version:", DF.FrameWorkVersion)
end

--get the working folder
do
	local path = string.match(debugstack(1, 1, 0), "AddOns\\(.+)fw.lua")
	if (path) then
		DF.folder = "Interface\\AddOns\\" .. path
	else
		--if not found, try to use the last valid one
		DF.folder = DF.folder or ""
	end
end

DF.debug = false

function DF:GetFrameworkFolder()
	return DF.folder
end

function DF:SetFrameworkDebugState(state)
	DF.debug = state
end


DF.embeds = DF.embeds or {}
local embedFunctions = {
	"RemoveRealName",
	"table",
	"BuildDropDownFontList",
	"SetFontSize",
	"SetFontFace",
	"SetFontColor",
	"GetFontSize",
	"GetFontFace",
	"SetFontOutline",
	"trim",
	"Msg",
	"CreateFlashAnimation",
	"Fade",
	"NewColor",
	"IsHtmlColor",
	"ParseColors",
	"BuildMenu",
	"ShowTutorialAlertFrame",
	"GetNpcIdFromGuid",
	"SetAsOptionsPanel",
	"GetPlayerRole",
	"GetCharacterTalents",
	"GetCharacterPvPTalents",

	"CreateDropDown",
	"CreateButton",
	"CreateColorPickButton",
	"CreateLabel",
	"CreateBar",
	"CreatePanel",
	"CreateFillPanel",
	"ColorPick",
	"IconPick",
	"CreateSimplePanel",
	"CreateChartPanel",
	"CreateImage",
	"CreateScrollBar",
	"CreateSwitch",
	"CreateSlider",
	"CreateSplitBar",
	"CreateTextEntry",
	"Create1PxPanel",
	"CreateOptionsFrame",
	"NewSpecialLuaEditorEntry",
	"ShowPromptPanel",
	"ShowTextPromptPanel",
	"www_icons",
	"GetTemplate",
	"InstallTemplate",
	"GetFrameworkFolder",
	"ShowPanicWarning",
	"SetFrameworkDebugState",
	"FindHighestParent",
	"OpenInterfaceProfile",
	"CreateInCombatTexture",
	"CreateAnimationHub",
	"CreateAnimation",
	"CreateScrollBox",
	"CreateBorder",
	"FormatNumber",
	"IntegerToTimer",
	"QuickDispatch",
	"Dispatch",
	"CommaValue",
	"RemoveRealmName",
	"Trim",
	"CreateGlowOverlay",
	"CreateAnts",
	"CreateFrameShake",
	"RegisterScriptComm",
	"SendScriptComm",
}

function DF:Embed(target)
	for k, v in pairs(embedFunctions) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function DF:FadeFrame(frame, t)
	if (t == 0) then
		frame.hidden = false
		frame.faded = false
		frame.fading_out = false
		frame.fading_in = false
		frame:Show()
		frame:SetAlpha(1)

	elseif (t == 1) then
		frame.hidden = true
		frame.faded = true
		frame.fading_out = false
		frame.fading_in = false
		frame:SetAlpha(0)
		frame:Hide()
	end
end

------------------------------------------------------------------------------------------------------------
--table

DF.table = {}

function DF.table.find(t, value)
	for i = 1, #t do
		if (t[i] == value) then
			return i
		end
	end
end

function DF.table.addunique(t, index, value)
	if (not value) then
		value = index
		index = #t + 1
	end

	for i = 1, #t do
		if (t[i] == value) then
			return false
		end
	end

	tinsert(t, index, value)
	return true
end

function DF.table.reverse(t)
	local new = {}
	local index = 1
	for i = #t, 1, -1 do
		new[index] = t[i]
		index = index + 1
	end
	return new
end

function DF.table.duplicate(t1, t2)
	for key, value in pairs(t2) do
		if (key ~= "__index" and key ~= "__newindex") then
			--preserve a wowObject passing it to the new table with copying it
			if (type(value) == "table" and table.GetObjectType and table:GetObjectType()) then
				t1[key] = value

			elseif (type(value) == "table") then
				t1[key] = t1[key] or {}
				DF.table.copy(t1[key], t2[key])

			else
				t1[key] = value
			end
		end
	end

	return t1
end

--copy from table2 to table1 overwriting values
function DF.table.copy(t1, t2)
	for key, value in pairs(t2) do
		if (key ~= "__index" and key ~= "__newindex") then
			if (type(value) == "table") then
				t1[key] = t1[key] or {}
				DF.table.copy(t1[key], t2[key])
			else
				t1[key] = value
			end
		end
	end
	return t1
end

--copy from table2 to table1 overwriting values but do not copy data that cannot be compressed
function DF.table.copytocompress(t1, t2)
	for key, value in pairs(t2) do
		if (key ~= "__index" and type(value) ~= "function") then
			if (type(value) == "table") then
				if (not value.GetObjectType) then
					t1[key] = t1[key] or {}
					DF.table.copytocompress(t1[key], t2[key])
				end
			else
				t1 [key] = value
			end
		end
	end
	return t1
end

--add the indexes of table2 into table1
function DF.table.append(t1, t2)
	for i = 1, #t2 do
		t1[#t1+1] = t2[i]
	end
	return t1
end

--copy values that does exist on table2 but not on table1
function DF.table.deploy(t1, t2)
	for key, value in pairs(t2) do
		if (type(value) == "table") then
			t1 [key] = t1 [key] or {}
			DF.table.deploy(t1 [key], t2 [key])
		elseif (t1 [key] == nil) then
			t1 [key] = value
		end
	end
	return t1
end

function DF.table.dump(t, resultString, deep)
	resultString = resultString or ""
	deep = deep or 0
	local space = ""
	for i = 1, deep do
		space = space .. "   "
	end

	for key, value in pairs(t) do
		local valueType = type(value)

		if (type(key) == "function") then
			key = "#function#"
		elseif (type(key) == "table") then
			key = "#table#"
		end

		if (type(key) ~= "string" and type(key) ~= "number") then
			key = "unknown?"
		end

		if (valueType == "table") then
			if (type(key) == "number") then
				resultString = resultString .. space .. "[" .. key .. "] = |cFFa9ffa9 {|r\n"
			else
				resultString = resultString .. space .. "[\"" .. key .. "\"] = |cFFa9ffa9 {|r\n"
			end
			resultString = resultString .. DF.table.dump (value, nil, deep+1)
			resultString = resultString .. space .. "|cFFa9ffa9},|r\n"

		elseif (valueType == "string") then
			resultString = resultString .. space .. "[\"" .. key .. "\"] = \"|cFFfff1c1" .. value .. "|r\",\n"

		elseif (valueType == "number") then
			resultString = resultString .. space .. "[\"" .. key .. "\"] = |cFFffc1f4" .. value .. "|r,\n"

		elseif (valueType == "function") then
			resultString = resultString .. space .. "[\"" .. key .. "\"] = function()end,\n"

		elseif (valueType == "boolean") then
			resultString = resultString .. space .. "[\"" .. key .. "\"] = |cFF99d0ff" .. (value and "true" or "false") .. "|r,\n"
		end
	end

	return resultString
end

--grab a text and split it into lines adding each line to a indexed table
function DF:SplitTextInLines(text)
	local lines = {}
	local position = 1
	local startScope, endScope = text:find("\n", position, true)

	while (startScope) do
		if (startScope ~= 1) then
			tinsert(lines, text:sub(position, startScope-1))
		end
		position = endScope + 1
		startScope, endScope = text:find("\n", position, true)
	end

	if (position <= #text) then
		tinsert(lines, text:sub(position))
	end

	return lines
end


DF.www_icons = {
	texture = "feedback_sites",
	wowi = {0, 0.7890625, 0, 37/128},
	curse = {0, 0.7890625, 38/123, 79/128},
	mmoc = {0, 0.7890625, 80/123, 123/128},
}

local symbol_1K, symbol_10K, symbol_1B
if (GetLocale() == "koKR") then
	symbol_1K, symbol_10K, symbol_1B = "천", "만", "억"

elseif (GetLocale() == "zhCN") then
	symbol_1K, symbol_10K, symbol_1B = "千", "万", "亿"

elseif (GetLocale() == "zhTW") then
	symbol_1K, symbol_10K, symbol_1B = "千", "萬", "億"
end

function DF:GetAsianNumberSymbols()
	if (GetLocale() == "koKR") then
		return "천", "만", "억"

	elseif (GetLocale() == "zhCN") then
		return "千", "万", "亿"

	elseif (GetLocale() == "zhTW") then
		return "千", "萬", "億"
	else
		--return korean as default (if the language is western)
		return "천", "만", "억"
	end
end

if (symbol_1K) then
	function DF.FormatNumber(number)
		if (number > 99999999) then
			return format("%.2f", number/100000000) .. symbol_1B
		elseif (number > 999999) then
			return format("%.2f", number/10000) .. symbol_10K
		elseif (number > 99999) then
			return floor(number/10000) .. symbol_10K
		elseif (number > 9999) then
			return format("%.1f", (number/10000)) .. symbol_10K
		elseif (number > 999) then
			return format("%.1f", (number/1000)) .. symbol_1K
		end
		return format("%.1f", number)
	end
else
	function DF.FormatNumber (number)
		if (number > 999999999) then
			return format("%.2f", number/1000000000) .. "B"
		elseif (number > 999999) then
			return format("%.2f", number/1000000) .. "M"
		elseif (number > 99999) then
			return floor(number/1000) .. "K"
		elseif (number > 999) then
			return format("%.1f", (number/1000)) .. "K"
		end
		return floor(number)
	end
end

function DF:CommaValue(value)
	if (not value) then
		return "0"
	end

	value = floor(value)
	if (value == 0) then
		return "0"
	end

	--source http://richard.warburton.it
	local left, num, right = string_match (value, '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)','%1,'):reverse()) .. right
end

function DF:GroupIterator(callback, ...)
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			DF:QuickDispatch(callback, "raid" .. i, ...)
		end

	elseif (IsInGroup()) then
		for i = 1, GetNumGroupMembers() - 1 do
			DF:QuickDispatch(callback, "party" .. i, ...)
		end
		DF:QuickDispatch(callback, "player", ...)

	else
		DF:QuickDispatch(callback, "player", ...)
	end
end

function DF:IntegerToTimer(value) --~formattime
	return "" .. floor(value/60) .. ":" .. format("%02.f", value%60)
end

function DF:RemoveRealmName(name)
	return name:gsub(("%-.*"), "")
end

function DF:RemoveRealName(name)
	return name:gsub(("%-.*"), "")
end

function DF:SetFontSize(fontString, ...)
	local font, _, flags = fontString:GetFont()
	fontString:SetFont(font, max(...), flags)
end

function DF:SetFontFace(fontString, fontface)
	local font = SharedMedia:Fetch("font", fontface, true)
	if (font) then
		fontface = font
	end

	local _, size, flags = fontString:GetFont()
	fontString:SetFont(fontface, size, flags)
end
function DF:SetFontColor(fontString, r, g, b, a)
	r, g, b, a = DF:ParseColors(r, g, b, a)
	fontString:SetTextColor(r, g, b, a)
end

function DF:SetFontShadow(fontString, r, g, b, a, x, y)
	r, g, b, a = DF:ParseColors(r, g, b, a)
	fontString:SetShadowColor(r, g, b, a)

	local offSetX, offSetY = fontString:GetShadowOffset()
	x = x or offSetX
	y = y or offSetY

	fontString:SetShadowOffset(x, y)
end

function DF:SetFontRotation(fontString, degrees)
	if (type(degrees) == "number") then
		if (not fontString.__rotationAnimation) then
			fontString.__rotationAnimation = DF:CreateAnimationHub(fontString)
			fontString.__rotationAnimation.rotator = DF:CreateAnimation(fontString.__rotationAnimation, "rotation", 1, 0, 0)
			fontString.__rotationAnimation.rotator:SetEndDelay(10^8)
			fontString.__rotationAnimation.rotator:SetSmoothProgress(1)
		end
		fontString.__rotationAnimation.rotator:SetDegrees(degrees)
		fontString.__rotationAnimation:Play()
		fontString.__rotationAnimation:Pause()
	end
end

function DF:AddClassColorToText(text, className)
	if (type(className) ~= "string") then
		return DF:RemoveRealName(text)

	elseif (className == "UNKNOW" or className == "PET") then
		return DF:RemoveRealName(text)
	end

	local color = RAID_CLASS_COLORS[className]
	if (color) then
		text = "|c" .. color.colorStr .. DF:RemoveRealName(text) .. "|r"
	else
		return DF:RemoveRealName(text)
	end

	return text
end

function DF:GetClassTCoordsAndTexture(class)
	local l, r, t, b = unpack(CLASS_ICON_TCOORDS[class])
	return l, r, t, b, [[Interface\WORLDSTATEFRAME\Icons-Classes]]
end

function DF:AddClassIconToText(text, playerName, class, useSpec, iconSize)
	local size = iconSize or 16

	local spec
	if (useSpec) then
		if (Details) then
			local GUID = UnitGUID(playerName)
			if (GUID) then
				spec = Details.cached_specs[GUID]
				if (spec) then
					spec = spec
				end
			end
		end
	end

	if (spec) then --if spec is valid, the user has Details! installed
		local specString = ""
		local L, R, T, B = unpack(Details.class_specs_coords[spec])
		if (L) then
			specString = "|TInterface\\AddOns\\Details\\images\\spec_icons_normal:" .. size .. ":" .. size .. ":0:0:512:512:" .. (L * 512) .. ":" .. (R * 512) .. ":" .. (T * 512) .. ":" .. (B * 512) .. "|t"
			return specString .. " " .. text
		end
	end

	if (class) then
		local classString = ""
		local L, R, T, B = unpack(Details.class_coords[class])
		if (L) then
			local imageSize = 128
			classString = "|TInterface\\AddOns\\Details\\images\\classes_small:" .. size .. ":" .. size .. ":0:0:" .. imageSize .. ":" .. imageSize .. ":" .. (L * imageSize) .. ":" .. (R * imageSize) .. ":" .. (T * imageSize) .. ":" .. (B * imageSize) .. "|t"
			return classString .. " " .. text
		end
	end

	return text
end

function DF:GetFontSize(fontString)
	local _, size = fontString:GetFont()
	return size
end

function DF:GetFontFace(fontString)
	local fontface = fontString:GetFont()
	return fontface
end

local ValidOutlines = {
	["NONE"] = true,
	["MONOCHROME"] = true,
	["OUTLINE"] = true,
	["THICKOUTLINE"] = true,
}

function DF:SetFontOutline(fontString, outline)
	local font, fontSize = fontString:GetFont()
	if (outline) then
		if (type(outline) == "string") then
			outline = outline:upper()
		end

		if (ValidOutlines[outline]) then
			outline = outline

		elseif (type(outline) == "boolean" and outline) then
			outline = "OUTLINE"

		elseif (type(outline) == "boolean" and not outline) then
			outline = "NONE"

		elseif (outline == 1) then
			outline = "OUTLINE"

		elseif (outline == 2) then
			outline = "THICKOUTLINE"
		end
	end

	fontString:SetFont(font, fontSize, outline)
end

function DF:Trim(string)
	return DF:trim(string)
end
function DF:trim(string)
	local from = string:match"^%s*()"
	return from > #string and "" or string:match(".*%S", from)
end

--truncated revoming at a maximum of 10 character from the string
function DF:TruncateTextSafe(fontString, maxWidth)
	local text = fontString:GetText()
	local numIterations = 10

	while (fontString:GetStringWidth() > maxWidth) do
		text = strsub(text, 1, #text-1)
		fontString:SetText(text)
		if (#text <= 1) then
			break
		end

		numIterations = numIterations - 1
		if (numIterations <= 0) then
			break
		end
	end

	text = DF:CleanTruncateUTF8String(text)
	fontString:SetText(text)
end

function DF:TruncateText(fontString, maxWidth)
	local text = fontString:GetText()

	while (fontString:GetStringWidth() > maxWidth) do
		text = strsub(text, 1, #text - 1)
		fontString:SetText(text)
		if (string.len(text) <= 1) then
			break
		end
	end

	text = DF:CleanTruncateUTF8String(text)
	fontString:SetText(text)
end

function DF:CleanTruncateUTF8String(text)
	if type(text) == "string" and text ~= "" then
		local b1 = (#text > 0) and strbyte(strsub(text, #text, #text)) or nil
		local b2 = (#text > 1) and strbyte(strsub(text, #text-1, #text)) or nil
		local b3 = (#text > 2) and strbyte(strsub(text, #text-2, #text)) or nil

		if b1 and b1 >= 194 and b1 <= 244 then
			text = strsub (text, 1, #text - 1)

		elseif b2 and b2 >= 224 and b2 <= 244 then
			text = strsub (text, 1, #text - 2)

		elseif b3 and b3 >= 240 and b3 <= 244 then
			text = strsub (text, 1, #text - 3)
		end
	end

	return text
end

--DF:TruncateNumber(number, fractionDigits): truncate the amount of numbers used to show fraction.
function DF:TruncateNumber(number, fractionDigits)
	fractionDigits = fractionDigits or 2
	local truncatedNumber = number

	--local truncatedNumber = format("%." .. fractionDigits .. "f", number) --4x slower than:
	--http://lua-users.org/wiki/SimpleRound
	local mult = 10 ^ fractionDigits
	if (number >= 0) then
		truncatedNumber = floor(number * mult + 0.5) / mult
	else
		truncatedNumber = ceil(number * mult + 0.5) / mult
	end

	return truncatedNumber
end

function DF:GetNpcIdFromGuid(GUID)
	local npcId = select(6, strsplit("-", GUID ))
	if (npcId) then
		return tonumber(npcId)
	end
	return 0
end

function DF.SortOrder1(t1, t2)
	return t1[1] > t2[1]
end
function DF.SortOrder2(t1, t2)
	return t1[2] > t2[2]
end
function DF.SortOrder3(t1, t2)
	return t1[3] > t2[3]
end
function DF.SortOrder1R(t1, t2)
	return t1[1] < t2[1]
end
function DF.SortOrder2R(t1, t2)
	return t1[2] < t2[2]
end
function DF.SortOrder3R(t1, t2)
	return t1[3] < t2[3]
end

--return a list of spells from the player spellbook
function DF:GetSpellBookSpells()
    local spellNamesInSpellBook = {}
	local spellIdsInSpellBook = {}

    for i = 1, GetNumSpellTabs() do
        local tabName, tabTexture, offset, numSpells, isGuild, offspecId = GetSpellTabInfo(i)

        if (offspecId == 0 and tabTexture ~= 136830) then --don't add spells found in the General tab
            offset = offset + 1
            local tabEnd = offset + numSpells

            for j = offset, tabEnd - 1 do
                local spellType, spellId = GetSpellBookItemInfo(j, "player")

                if (spellId) then
                    if (spellType ~= "FLYOUT") then
                        local spellName = GetSpellInfo(spellId)
                        if (spellName) then
                            spellNamesInSpellBook[spellName] = true
							spellIdsInSpellBook[#spellIdsInSpellBook+1] = spellId
                        end
                    else
                        local _, _, numSlots, isKnown = GetFlyoutInfo(spellId)
                        if (isKnown and numSlots > 0) then
                            for k = 1, numSlots do
                                local spellID, overrideSpellID, isKnown = GetFlyoutSlotInfo(spellId, k)
                                if (isKnown) then
                                    local spellName = GetSpellInfo(spellID)
                                    spellNamesInSpellBook[spellName] = true
									spellIdsInSpellBook[#spellIdsInSpellBook+1] = spellID
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return spellNamesInSpellBook, spellIdsInSpellBook
end


------------------------------------------------------------------------------------------------------------------------
--flash animation
local onFinishFlashAnimation = function(self)
	if (self.showWhenDone) then
		self.frame:SetAlpha(1)
	else
		self.frame:SetAlpha(0)
		self.frame:Hide()
	end

	if (self.onFinishFunc) then
		self:onFinishFunc(self.frame)
	end
end

local stopAnimation_Method = function(self)
	local FlashAnimation = self.FlashAnimation
	FlashAnimation:Stop()
end

local startFlash_Method = function(self, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, loopType)
	local flashAnimation = self.FlashAnimation

	local fadeIn = flashAnimation.fadeIn
	local fadeOut = flashAnimation.fadeOut

	fadeIn:Stop()
	fadeOut:Stop()

	fadeIn:SetDuration(fadeInTime or 1)
	fadeIn:SetEndDelay(flashInHoldTime or 0)

	fadeOut:SetDuration(fadeOutTime or 1)
	fadeOut:SetEndDelay(flashOutHoldTime or 0)

	flashAnimation.duration = flashDuration
	flashAnimation.loopTime = flashAnimation:GetDuration()
	flashAnimation.finishAt = GetTime() + flashDuration
	flashAnimation.showWhenDone = showWhenDone

	flashAnimation:SetLooping(loopType or "REPEAT")

	self:Show()
	self:SetAlpha(0)
	flashAnimation:Play()
end

function DF:CreateFlashAnimation(frame, onFinishFunc, onLoopFunc)
	local flashAnimation = frame:CreateAnimationGroup()

	flashAnimation.fadeOut = flashAnimation:CreateAnimation("Alpha")
	flashAnimation.fadeOut:SetOrder(1)
	flashAnimation.fadeOut:SetFromAlpha(0)
	flashAnimation.fadeOut:SetToAlpha(1)

	flashAnimation.fadeIn = flashAnimation:CreateAnimation("Alpha")
	flashAnimation.fadeIn:SetOrder(2)
	flashAnimation.fadeIn:SetFromAlpha(1)
	flashAnimation.fadeIn:SetToAlpha(0)

	frame.FlashAnimation = flashAnimation
	flashAnimation.frame = frame
	flashAnimation.onFinishFunc = onFinishFunc

	flashAnimation:SetScript("OnLoop", onLoopFunc)
	flashAnimation:SetScript("OnFinished", onFinishFlashAnimation)

	frame.Flash = startFlash_Method
	frame.Stop = stopAnimation_Method

	return flashAnimation
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--anchoring

function DF:CheckPoints(point1, point2, point3, point4, point5, object)
	if (not point1 and not point2) then
		return "topleft", object.widget:GetParent(), "topleft", 0, 0
	end

	if (type(point1) == "string") then
		local frameGlobal = _G[point1]
		if (frameGlobal and type(frameGlobal) == "table" and frameGlobal.GetObjectType) then
			return DF:CheckPoints(frameGlobal, point2, point3, point4, point5, object)
		end

	elseif (type(point2) == "string") then
		local frameGlobal = _G[point2]
		if (frameGlobal and type(frameGlobal) == "table" and frameGlobal.GetObjectType) then
			return DF:CheckPoints(point1, frameGlobal, point3, point4, point5, object)
		end
	end

	if (type(point1) == "string" and type(point2) == "table") then --setpoint("left", frame, _, _, _)
		if (not point3 or type(point3) == "number") then --setpoint("left", frame, 10, 10)
			point1, point2, point3, point4, point5 = point1, point2, point1, point3, point4
		end

	elseif (type(point1) == "string" and type(point2) == "number") then --setpoint("topleft", x, y)
		point1, point2, point3, point4, point5 = point1, object.widget:GetParent(), point1, point2, point3

	elseif (type(point1) == "number") then --setpoint(x, y)
		point1, point2, point3, point4, point5 = "topleft", object.widget:GetParent(), "topleft", point1, point2

	elseif (type(point1) == "table") then --setpoint(frame, x, y)
		point1, point2, point3, point4, point5 = "topleft", point1, "topleft", point2, point3
	end

	if (not point2) then
		point2 = object.widget:GetParent()
	elseif (point2.dframework) then
		point2 = point2.widget
	end

	return point1 or "topleft", point2, point3 or "topleft", point4 or 0, point5 or 0
end

local anchoringFunctions = {
	function(frame, anchorTo, offSetX, offSetY) --1 TOP LEFT
		frame:ClearAllPoints()
		frame:SetPoint("bottomleft", anchorTo, "topleft", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --2 LEFT
		frame:ClearAllPoints()
		frame:SetPoint("right", anchorTo, "left", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --3 BOTTOM LEFT
		frame:ClearAllPoints()
		frame:SetPoint("topleft", anchorTo, "bottomleft", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --4 BOTTOM
		frame:ClearAllPoints()
		frame:SetPoint("top", anchorTo, "bottom", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --5 BOTTOM RIGHT
		frame:ClearAllPoints()
		frame:SetPoint("topright", anchorTo, "bottomright", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --6 RIGHT
		frame:ClearAllPoints()
		frame:SetPoint("left", anchorTo, "right", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --7 TOP RIGHT
		frame:ClearAllPoints()
		frame:SetPoint("bottomright", anchorTo, "topright", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --8 TOP
		frame:ClearAllPoints()
		frame:SetPoint("bottom", anchorTo, "top", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --9 CENTER
		frame:ClearAllPoints()
		frame:SetPoint("center", anchorTo, "center", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --10
		frame:ClearAllPoints()
		frame:SetPoint("left", anchorTo, "left", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --11
		frame:ClearAllPoints()
		frame:SetPoint("right", anchorTo, "right", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --12
		frame:ClearAllPoints()
		frame:SetPoint("top", anchorTo, "top", offSetX, offSetY)
	end,

	function(frame, anchorTo, offSetX, offSetY) --13
		frame:ClearAllPoints()
		frame:SetPoint("bottom", anchorTo, "bottom", offSetX, offSetY)
	end
}

function DF:SetAnchor(widget, config, anchorTo)
	anchorTo = anchorTo or widget:GetParent()
	anchoringFunctions[config.side](widget, anchorTo, config.x, config.y)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--colors

	--add a new color name, the color can be query using DetailsFramework:ParseColors(colorName)
	function DF:NewColor(colorName, red, green, blue, alpha)
		assert(type(colorName) == "string", "DetailsFramework:NewColor(): colorName must be a string.")
		assert(not DF.alias_text_colors[colorName], "DetailsFramework:NewColor(): colorName already exists.")

		red, green, blue, alpha = DetailsFramework:ParseColors(red, green, blue, alpha)
		local colorTable = DetailsFramework:FormatColor("table", red, green, blue, alpha)

		DF.alias_text_colors[colorName] = colorTable

		return colorTable
	end

	local colorTableMixin = {
		GetColor = function(self)
			return self.r, self.g, self.b, self.a
		end,

		SetColor = function(self, r, g, b, a)
			r, g, b, a = DF:ParseColors(r, g, b, a)
			self.r = r or self.r
			self.g = g or self.g
			self.b = b or self.b
			self.a = a or self.a
		end,

		IsColorTable = true,
	}

	--convert a any format of color to any other format of color
	function DF:FormatColor(newFormat, r, g, b, a, decimalsAmount)
		r, g, b, a = DF:ParseColors(r, g, b, a)
		decimalsAmount = decimalsAmount or 4

		r = DF:TruncateNumber(r, decimalsAmount)
		g = DF:TruncateNumber(g, decimalsAmount)
		b = DF:TruncateNumber(b, decimalsAmount)
		a = DF:TruncateNumber(a, decimalsAmount)

		if (newFormat == "commastring") then
			return r .. ", " .. g .. ", " .. b .. ", " .. a

		elseif (newFormat == "tablestring") then
			return "{" .. r .. ", " .. g .. ", " .. b .. ", " .. a .. "}"

		elseif (newFormat == "table") then
			return {r, g, b, a}

		elseif (newFormat == "tablemembers") then
			return {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

		elseif (newFormat == "numbers") then
			return r, g, b, a

		elseif (newFormat == "hex") then
			return format("%.2x%.2x%.2x%.2x", a * 255, r * 255, g * 255, b * 255)
		end
	end

	function DF:CreateColorTable(r, g, b, a)
		local t  = {
			r = r or 1,
			g = g or 1,
			b = b or 1,
			a = a or 1,
		}
		DF:Mixin(t, colorTableMixin)
		return t
	end

	function DF:IsHtmlColor(color)
		return DF.alias_text_colors[color]
	end

	function DF:ParseColors(red, green, blue, alpha)
		local firstParameter = red

		--the first value passed is a table?
		if (type(firstParameter) == "table") then
			local colorTable = red

			if (colorTable.IsColorTable) then
				--using colorTable mixin
				return colorTable:GetColor()

			elseif (not colorTable[1] and colorTable.r) then
				--{["r"] = 1, ["g"] = 1, ["b"] = 1}
				red, green, blue, alpha = colorTable.r, colorTable.g, colorTable.b, colorTable.a

			else
				--{1, .7, .2, 1}
				red, green, blue, alpha = unpack(colorTable)
			end

		--the first value passed is a string?
		elseif (type(firstParameter) == "string") then
			local colorString = red
			--hexadecimal
			if (string.find(colorString, "#")) then
				colorString = colorString:gsub("#","")
				if (string.len(colorString) == 8) then --with alpha
					red, green, blue, alpha = tonumber("0x" .. colorString:sub(3, 4))/255, tonumber("0x" .. colorString:sub(5, 6))/255, tonumber("0x" .. colorString:sub(7, 8))/255, tonumber("0x" .. colorString:sub(1, 2))/255
				else
					red, green, blue, alpha = tonumber("0x" .. colorString:sub(1, 2))/255, tonumber("0x" .. colorString:sub(3, 4))/255, tonumber("0x" .. colorString:sub(5, 6))/255, 1
				end
			else
				--name of the color
				local colorTable = DF.alias_text_colors[colorString]
				if (colorTable) then
					red, green, blue, alpha = unpack(colorTable)

				--string with number separated by comma
				elseif (colorString:find(",")) then
					local r, g, b, a = strsplit(",", colorString)
					red, green, blue, alpha = tonumber(r), tonumber(g), tonumber(b), tonumber(a)

				else
					--no color found within the string, return default color
					red, green, blue, alpha = unpack(DF.alias_text_colors.none)
				end
			end
		end

		if (not red or type(red) ~= "number") then
			red = 1
		end
		if (not green) or type(green) ~= "number" then
			green = 1
		end
		if (not blue or type(blue) ~= "number") then
			blue = 1
		end
		if (not alpha or type(alpha) ~= "number") then
			alpha = 1
		end

		return Saturate(red), Saturate(green), Saturate(blue), Saturate(alpha)
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--menus
	local formatOptionNameWithColon = function(text, useColon)
		if (text) then
			if (useColon) then
				text = text .. ":"
				return text
			else
				return text
			end
		end
	end

	local widgetsToDisableOnCombat = {}

	local getMenuWidgetVolative = function(parent, widgetType, indexTable)
		local widgetObject

		if (widgetType == "label") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType], "overlay")
				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)
			end
			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "dropdown") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateDropDown(parent, function() return {} end, nil, 140, 18, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widgetObject.hasLabel = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")
				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)

			else
				widgetObject:ClearHooks()
				widgetObject.hasLabel.text = ""
			end
			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "switch") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateSwitch(parent, nil, true, 20, 20, nil, nil, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widgetObject.hasLabel = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)
			else
				widgetObject:ClearHooks()
			end
			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "slider") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateSlider(parent, 140, 20, 1, 2, 1, 1, false, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widgetObject.hasLabel = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)
			else
				widgetObject:ClearHooks()
			end
			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "color") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateColorPickButton(parent, "$parentWidget" .. widgetType .. indexTable[widgetType], nil, function()end, 1)
				widgetObject.hasLabel = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)
			else
				widgetObject:ClearHooks()
			end
			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "button") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateButton(parent, function()end, 120, 18, "", nil, nil, nil, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widgetObject.hasLabel = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)
			else
				widgetObject:ClearHooks()
			end
			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "textentry") then
			widgetObject = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widgetObject) then
				widgetObject = DF:CreateTextEntry(parent, function()end, 120, 18, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widgetObject.hasLabel = DF:CreateLabel(parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widgetObject)
				tinsert(parent.widget_list_by_type[widgetType], widgetObject)
			else
				widgetObject:ClearHooks()
			end
			indexTable[widgetType] = indexTable[widgetType] + 1
		end

		--if the widget is inside the no combat table, remove it
		for i = 1, #widgetsToDisableOnCombat do
			if (widgetsToDisableOnCombat[i] == widgetObject) then
				tremove(widgetsToDisableOnCombat, i)
				break
			end
		end

		return widgetObject
	end

	--volatile menu can be called several times, each time all settings are reset and a new menu is built using the same widgets
	function DF:BuildMenuVolatile(parent, menuOptions, xOffset, yOffset, height, useColon, textTemplate, dropdownTemplate, switchTemplate, switchIsCheckbox, sliderTemplate, buttonTemplate, valueChangeHook)
		if (not parent.widget_list) then
			DF:SetAsOptionsPanel(parent)
		end
		DF:ClearOptionsPanel(parent)

		local currentXOffset = xOffset
		local currentYOffset = yOffset
		local maxColumnWidth = 0

		local latestInlineWidget

		local widgetIndexes = {
			label = 1,
			dropdown = 1,
			switch = 1,
			slider = 1,
			color = 1,
			button = 1,
			textentry = 1,
		}

		height = abs((height or parent:GetHeight()) - abs(yOffset) + 20)
		height = height * -1

		--normalize format types
		for index, widgetTable in ipairs(menuOptions) do
			if (widgetTable.type == "space") then
				widgetTable.type = "blank"

			elseif (widgetTable.type == "dropdown") then
				widgetTable.type = "select"

			elseif (widgetTable.type == "switch") then
				widgetTable.type = "toggle"

			elseif (widgetTable.type == "slider") then
				widgetTable.type = "range"

			elseif (widgetTable.type == "button") then
				widgetTable.type = "execute"

			end
		end

		--catch some options added in the hash part of the menu table
		local useBoxFirstOnAllWidgets = menuOptions.always_boxfirst
		local languageAddonId = menuOptions.language_addonId
		local languageTable

		if (languageAddonId) then
			languageTable = DetailsFramework.Language.GetLanguageTable(languageAddonId)
		end

		for index, widgetTable in ipairs(menuOptions) do
			if (not widgetTable.hidden) then

				local widgetCreated
				if (latestInlineWidget) then
					if (not widgetTable.inline) then
						latestInlineWidget = nil
						currentYOffset = currentYOffset - 20
					end
				end

				local extraPaddingY = 0

				if (not widgetTable.novolatile) then
					--step a line
					if (widgetTable.type == "blank" or widgetTable.type == "space") then
						--do nothing

					elseif (widgetTable.type == "label" or widgetTable.type == "text") then
						local label = getMenuWidgetVolative(parent, "label", widgetIndexes)
						widgetCreated = label

						label.text = (languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.get and widgetTable.get() or widgetTable.text) or (widgetTable.namePhraseId) or ""
						label.color = widgetTable.color

						if (widgetTable.font) then
							label.fontface = widgetTable.font
						end

						if (widgetTable.text_template or textTemplate) then
							label:SetTemplate(widgetTable.text_template or textTemplate)
						else
							label.fontsize = widgetTable.size or 10
						end

						label._get = widgetTable.get
						label.widget_type = "label"
						label:ClearAllPoints()
						label:SetPoint(currentXOffset, currentYOffset)

						if (widgetTable.id) then
							parent.widgetids [widgetTable.id] = label
						end

					--dropdowns
					elseif (widgetTable.type == "select" or widgetTable.type == "dropdown") then
						assert(widgetTable.get, "DetailsFramework:BuildMenu(): .get not found in the widget table for 'select'")
						local dropdown = getMenuWidgetVolative(parent, "dropdown", widgetIndexes)
						widgetCreated = dropdown

						dropdown:SetFunction(widgetTable.values)
						dropdown:Refresh()
						dropdown:Select(widgetTable.get())
						dropdown:SetTemplate(dropdownTemplate)

						dropdown:SetTooltip((languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.desc) or (widgetTable.namePhraseId))
						dropdown._get = widgetTable.get
						dropdown.widget_type = "select"

						dropdown.hasLabel.text = (languageTable and languageTable[widgetTable.namePhraseId]) or formatOptionNameWithColon(widgetTable.name, useColon) or widgetTable.namePhraseId or ""

						dropdown.hasLabel:SetTemplate(widgetTable.text_template or textTemplate)
						dropdown:ClearAllPoints()
						dropdown:SetPoint("left", dropdown.hasLabel, "right", 2)
						dropdown.hasLabel:ClearAllPoints()
						dropdown.hasLabel:SetPoint(currentXOffset, currentYOffset)

						--global callback
						if (valueChangeHook) then
							dropdown:SetHook("OnOptionSelected", valueChangeHook)
						end

						--hook list (hook list is wiped when getting the widget)
						if (widgetTable.hooks) then
							for hookName, hookFunc in pairs(widgetTable.hooks) do
								dropdown:SetHook(hookName, hookFunc)
							end
						end

						if (widgetTable.id) then
							parent.widgetids[widgetTable.id] = dropdown
						end

						local widgetTotalSize = dropdown.hasLabel.widget:GetStringWidth() + 140 + 4
						if (widgetTotalSize > maxColumnWidth) then
							maxColumnWidth = widgetTotalSize
						end

					--switchs
					elseif (widgetTable.type == "toggle" or widgetTable.type == "switch") then
						local switch = getMenuWidgetVolative(parent, "switch", widgetIndexes)
						widgetCreated = switch

						switch:SetValue(widgetTable.get())
						switch:SetTemplate(switchTemplate)
						switch:SetAsCheckBox() --it's always a checkbox on volatile menu

						switch:SetTooltip((languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.desc) or (widgetTable.namePhraseId))
						switch._get = widgetTable.get
						switch.widget_type = "toggle"
						switch.OnSwitch = widgetTable.set

						if (valueChangeHook) then
							switch:SetHook("OnSwitch", valueChangeHook)
						end

						--hook list
						if (widgetTable.hooks) then
							for hookName, hookFunc in pairs(widgetTable.hooks) do
								switch:SetHook(hookName, hookFunc)
							end
						end

						if (widgetTable.width) then
							switch:SetWidth(widgetTable.width)
						end
						if (widgetTable.height) then
							switch:SetHeight(widgetTable.height)
						end

						switch.hasLabel.text = (languageTable and languageTable[widgetTable.namePhraseId]) or formatOptionNameWithColon(widgetTable.name, useColon) or widgetTable.namePhraseId or ""
						switch.hasLabel:SetTemplate(widgetTable.text_template or textTemplate)

						switch:ClearAllPoints()
						switch.hasLabel:ClearAllPoints()

						if (widgetTable.boxfirst or useBoxFirstOnAllWidgets) then
							switch:SetPoint(currentXOffset, currentYOffset)
							switch.hasLabel:SetPoint("left", switch, "right", 2)

							local nextWidgetTable = menuOptions[index+1]
							if (nextWidgetTable) then
								if (nextWidgetTable.type ~= "blank" and nextWidgetTable.type ~= "breakline" and nextWidgetTable.type ~= "toggle" and nextWidgetTable.type ~= "color") then
									extraPaddingY = 4
								end
							end
						else
							switch.hasLabel:SetPoint(currentXOffset, currentYOffset)
							switch:SetPoint("left", switch.hasLabel, "right", 2)
						end

						if (widgetTable.id) then
							parent.widgetids [widgetTable.id] = switch
						end

						local widgetTotalSize = switch.hasLabel:GetStringWidth() + 32
						if (widgetTotalSize > maxColumnWidth) then
							maxColumnWidth = widgetTotalSize
						end

					--slider
					elseif (widgetTable.type == "range" or widgetTable.type == "slider") then
						local slider = getMenuWidgetVolative(parent, "slider", widgetIndexes)
						widgetCreated = slider

						if (widgetTable.usedecimals) then
							slider.slider:SetValueStep(0.01)
						else
							slider.slider:SetValueStep(widgetTable.step)
						end
						slider.useDecimals = widgetTable.usedecimals

						slider.slider:SetMinMaxValues(widgetTable.min, widgetTable.max)
						slider.slider:SetValue(widgetTable.get())
						slider.ivalue = slider.slider:GetValue()

						slider:SetTemplate(sliderTemplate)

						slider:SetTooltip((languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.desc) or (widgetTable.namePhraseId))
						slider._get = widgetTable.get
						slider.widget_type = "range"
						slider:SetHook("OnValueChange", widgetTable.set)

						if (valueChangeHook) then
							slider:SetHook("OnValueChange", valueChangeHook)
						end

						if (widgetTable.thumbscale) then
							slider:SetThumbSize (slider.thumb.originalWidth * widgetTable.thumbscale, nil)
						else
							slider:SetThumbSize (slider.thumb.originalWidth * 1.3, nil)
						end

						--hook list
						if (widgetTable.hooks) then
							for hookName, hookFunc in pairs(widgetTable.hooks) do
								slider:SetHook(hookName, hookFunc)
							end
						end

						slider.hasLabel.text = (languageTable and languageTable[widgetTable.namePhraseId]) or formatOptionNameWithColon(widgetTable.name, useColon) or widgetTable.namePhraseId or ""
						slider.hasLabel:SetTemplate(widgetTable.text_template or textTemplate)

						slider:SetPoint("left", slider.hasLabel, "right", 2)
						slider.hasLabel:SetPoint(currentXOffset, currentYOffset)

						if (widgetTable.id) then
							parent.widgetids[widgetTable.id] = slider
						end

						local widgetTotalSize = slider.hasLabel:GetStringWidth() + 146
						if (widgetTotalSize > maxColumnWidth) then
							maxColumnWidth = widgetTotalSize
						end

					--color
					elseif (widgetTable.type == "color" or widgetTable.type == "color") then
						local colorpick = getMenuWidgetVolative(parent, "color", widgetIndexes)
						widgetCreated = colorpick

						colorpick.color_callback = widgetTable.set --callback
						colorpick:SetTemplate(buttonTemplate)
						colorpick:SetSize(18, 18)

						colorpick:SetTooltip((languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.desc) or (widgetTable.namePhraseId))
						colorpick._get = widgetTable.get
						colorpick.widget_type = "color"

						local default_value, g, b, a = widgetTable.get()
						if (type(default_value) == "table") then
							colorpick:SetColor(unpack(default_value))
						else
							colorpick:SetColor(default_value, g, b, a)
						end

						if (valueChangeHook) then
							colorpick:SetHook("OnColorChanged", valueChangeHook)
						end

						--hook list
						if (widgetTable.hooks) then
							for hookName, hookFunc in pairs(widgetTable.hooks) do
								colorpick:SetHook(hookName, hookFunc)
							end
						end

						local label = colorpick.hasLabel
						label.text = (languageTable and languageTable[widgetTable.namePhraseId]) or formatOptionNameWithColon(widgetTable.name, useColon) or widgetTable.namePhraseId or ""
						label:SetTemplate(widgetTable.text_template or textTemplate)

						label:ClearAllPoints()
						colorpick:ClearAllPoints()

						if (widgetTable.boxfirst or useBoxFirstOnAllWidgets) then
							label:SetPoint("left", colorpick, "right", 2)
							colorpick:SetPoint(currentXOffset, currentYOffset)
							extraPaddingY = 1
						else
							colorpick:SetPoint("left", label, "right", 2)
							label:SetPoint(currentXOffset, currentYOffset)
						end

						if (widgetTable.id) then
							parent.widgetids[widgetTable.id] = colorpick
						end

						local widgetTotalSize = label:GetStringWidth() + 32
						if (widgetTotalSize > maxColumnWidth) then
							maxColumnWidth = widgetTotalSize
						end

					--button
					elseif (widgetTable.type == "execute" or widgetTable.type == "button") then
						local button = getMenuWidgetVolative(parent, "button", widgetIndexes)
						widgetCreated = button

						button:SetTemplate(buttonTemplate)
						button:SetSize(widgetTable.width or 120, widgetTable.height or 18)
						button:SetClickFunction(widgetTable.func, widgetTable.param1, widgetTable.param2)

						local textTemplate = widgetTable.text_template or textTemplate or DF.font_templates["ORANGE_FONT_TEMPLATE"]
						button.textcolor = textTemplate.color
						button.textfont = textTemplate.font
						button.textsize = textTemplate.size
						button.text = (languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.name) or (widgetTable.namePhraseId) or ""

						if (widgetTable.inline) then
							if (latestInlineWidget) then
								button:SetPoint("left", latestInlineWidget, "right", 2, 0)
								latestInlineWidget = button
							else
								button:SetPoint(currentXOffset, currentYOffset)
								latestInlineWidget = button
							end
						else
							button:SetPoint(currentXOffset, currentYOffset)
						end

						button:SetTooltip((languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.desc) or (widgetTable.namePhraseId))
						button.widget_type = "execute"

						--hook list
						if (widgetTable.hooks) then
							for hookName, hookFunc in pairs(widgetTable.hooks) do
								button:SetHook(hookName, hookFunc)
							end
						end

						if (widgetTable.width) then
							button:SetWidth(widgetTable.width)
						end
						if (widgetTable.height) then
							button:SetHeight(widgetTable.height)
						end

						if (widgetTable.id) then
							parent.widgetids[widgetTable.id] = button
						end

						local widgetTotalSize = button:GetWidth() + 4
						if (widgetTotalSize > maxColumnWidth) then
							maxColumnWidth = widgetTotalSize
						end

					--textentry
					elseif (widgetTable.type == "textentry") then
						local textentry = getMenuWidgetVolative(parent, "textentry", widgetIndexes)
						widgetCreated = textentry

						textentry:SetCommitFunction(widgetTable.func or widgetTable.set)
						textentry:SetTemplate(widgetTable.template or widgetTable.button_template or buttonTemplate)
						textentry:SetSize(widgetTable.width or 120, widgetTable.height or 18)

						textentry:SetTooltip((languageTable and languageTable[widgetTable.namePhraseId]) or (widgetTable.desc) or (widgetTable.namePhraseId))
						textentry.text = widgetTable.get()
						textentry._get = widgetTable.get
						textentry.widget_type = "textentry"
						textentry:SetHook("OnEnterPressed", widgetTable.func or widgetTable.set)
						textentry:SetHook("OnEditFocusLost", widgetTable.func or widgetTable.set)

						textentry.hasLabel.text = (languageTable and languageTable[widgetTable.namePhraseId]) or formatOptionNameWithColon(widgetTable.name, useColon) or widgetTable.namePhraseId or ""
						textentry.hasLabel:SetTemplate(widgetTable.text_template or textTemplate)
						textentry:SetPoint("left", textentry.hasLabel, "right", 2)
						textentry.hasLabel:SetPoint(currentXOffset, currentYOffset)

						--hook list
						if (widgetTable.hooks) then
							for hookName, hookFunc in pairs(widgetTable.hooks) do
								textentry:SetHook(hookName, hookFunc)
							end
						end

						if (widgetTable.id) then
							parent.widgetids[widgetTable.id] = textentry
						end

						local widgetTotalSize = textentry.hasLabel:GetStringWidth() + 64
						if (widgetTotalSize > maxColumnWidth) then
							maxColumnWidth = widgetTotalSize
						end

					end --end loop

					if (widgetTable.nocombat) then
						tinsert(widgetsToDisableOnCombat, widgetCreated)
					end

					if (not widgetTable.inline) then
						if (widgetTable.spacement) then
							currentYOffset = currentYOffset - 30
						else
							currentYOffset = currentYOffset - 20
						end
					end

					if (extraPaddingY > 0) then
						currentYOffset = currentYOffset - extraPaddingY
					end

					if (widgetTable.type == "breakline" or currentYOffset < height) then
						currentYOffset = yOffset
						currentXOffset = currentXOffset + maxColumnWidth + 20
						maxColumnWidth = 0
					end

					if widgetCreated then
						widgetCreated:Show()
					end
				end
			end
		end

		DF.RefreshUnsafeOptionsWidgets()
	end

	function DF:BuildMenu(parent, menuOptions, xOffset, yOffset, height, useColon, textTemplate, dropdownTemplate, switchTemplate, switchIsCheckbox, sliderTemplate, buttonTemplate, valueChangeHook)
		if (not parent.widget_list) then
			DF:SetAsOptionsPanel(parent)
		end

		local currentXOffset = xOffset
		local currentYOffset = yOffset
		local maxColumnWidth = 0

		--how many widgets has been created on this line loop pass
		local amountLineWidgetCreated = 0
		local latestInlineWidget

		height = abs((height or parent:GetHeight()) - abs(yOffset) + 20)
		height = height * -1

		--normalize format types
		for index, widgetTable in ipairs(menuOptions) do
			if (widgetTable.type == "space") then
				widgetTable.type = "blank"

			elseif (widgetTable.type == "dropdown") then
				widgetTable.type = "select"

			elseif (widgetTable.type == "switch") then
				widgetTable.type = "toggle"

			elseif (widgetTable.type == "slider") then
				widgetTable.type = "range"

			elseif (widgetTable.type == "button") then
				widgetTable.type = "execute"
			end
		end

		--catch some options added in the hash part of the menu table
		local useBoxFirstOnAllWidgets = menuOptions.always_boxfirst
		local languageAddonId = menuOptions.language_addonId
		local languageTable

		if (languageAddonId) then
			languageTable = DetailsFramework.Language.GetLanguageTable(languageAddonId)
		end

		for index, widgetTable in ipairs(menuOptions) do
			if (not widgetTable.hidden) then

				local widgetCreated
				if (latestInlineWidget) then
					if (not widgetTable.inline) then
						latestInlineWidget = nil
						currentYOffset = currentYOffset - 28
					end
				end

				local extraPaddingY = 0

				if (widgetTable.type == "blank") then
					--do nothing

				elseif (widgetTable.type == "label" or widgetTable.type == "text") then
					local label = DF:CreateLabel(parent, "", widgetTable.text_template or textTemplate or widgetTable.size, widgetTable.color, widgetTable.font, nil, "$parentWidget" .. index, "overlay")
					label._get = widgetTable.get
					label.widget_type = "label"
					label:SetPoint(currentXOffset, currentYOffset)

					if (widgetTable.namePhraseId) then
						DetailsFramework.Language.RegisterFontString(languageAddonId, label.widget, widgetTable.namePhraseId)
					else
						local textToSet = (widgetTable.get and widgetTable.get()) or widgetTable.text or ""
						label:SetText(textToSet)
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, label)
					tinsert(parent.widget_list_by_type.label, label)

					amountLineWidgetCreated = amountLineWidgetCreated + 1

					if (widgetTable.id) then
						parent.widgetids[widgetTable.id] = label
					end

				elseif (widgetTable.type == "select") then
					assert(widgetTable.get, "DetailsFramework:BuildMenu(): .get not found in the widget table for 'select'")
					local dropdown = DF:NewDropDown(parent, nil, "$parentWidget" .. index, nil, 140, 18, widgetTable.values, widgetTable.get(), dropdownTemplate)

					DetailsFramework.Language.RegisterTableKeyWithDefault(languageAddonId, dropdown, "have_tooltip", widgetTable.descPhraseId, widgetTable.desc)

					dropdown._get = widgetTable.get
					dropdown.widget_type = "select"

					local label = DF:NewLabel(parent, nil, "$parentLabel" .. index, nil, "", "GameFontNormal", widgetTable.text_template or textTemplate or 12)
					DetailsFramework.Language.RegisterObjectWithDefault(languageAddonId, label.widget, widgetTable.namePhraseId, formatOptionNameWithColon(widgetTable.name, useColon))

					dropdown:SetPoint("left", label, "right", 2)
					label:SetPoint(currentXOffset, currentYOffset)
					dropdown.hasLabel = label

					--global callback
					if (valueChangeHook) then
						dropdown:SetHook("OnOptionSelected", valueChangeHook)
					end

					--hook list
					if (widgetTable.hooks) then
						for hookName, hookFunc in pairs(widgetTable.hooks) do
							dropdown:SetHook(hookName, hookFunc)
						end
					end

					if (widgetTable.id) then
						parent.widgetids[widgetTable.id] = dropdown
					end

					local widgetTotalSize = label.widget:GetStringWidth() + 144
					if (widgetTotalSize > maxColumnWidth) then
						maxColumnWidth = widgetTotalSize
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, dropdown)
					tinsert(parent.widget_list_by_type.dropdown, dropdown)

					widgetCreated = dropdown
					amountLineWidgetCreated = amountLineWidgetCreated + 1

				elseif (widgetTable.type == "toggle") then
					local switch = DF:NewSwitch(parent, nil, "$parentWidget" .. index, nil, 60, 20, nil, nil, widgetTable.get(), nil, nil, nil, nil, switchTemplate)

					DetailsFramework.Language.RegisterTableKeyWithDefault(languageAddonId, switch, "have_tooltip", widgetTable.descPhraseId, widgetTable.desc)

					switch._get = widgetTable.get
					switch.widget_type = "toggle"
					switch.OnSwitch = widgetTable.set

					if (switchIsCheckbox) then
						switch:SetAsCheckBox()
					end

					if (valueChangeHook) then
						switch:SetHook("OnSwitch", valueChangeHook)
					end

					--hook list
					if (widgetTable.hooks) then
						for hookName, hookFunc in pairs(widgetTable.hooks) do
							switch:SetHook(hookName, hookFunc)
						end
					end

					if (widgetTable.width) then
						switch:SetWidth(widgetTable.width)
					end
					if (widgetTable.height) then
						switch:SetHeight(widgetTable.height)
					end

					local label = DF:NewLabel(parent, nil, "$parentLabel" .. index, nil, "", "GameFontNormal", widgetTable.text_template or textTemplate or 12)
					DetailsFramework.Language.RegisterObjectWithDefault(languageAddonId, label.widget, widgetTable.namePhraseId, formatOptionNameWithColon(widgetTable.name, useColon))

					if (widgetTable.boxfirst or useBoxFirstOnAllWidgets) then
						switch:SetPoint(currentXOffset, currentYOffset)
						label:SetPoint("left", switch, "right", 2)

						local nextWidgetTable = menuOptions[index+1]
						if (nextWidgetTable) then
							if (nextWidgetTable.type ~= "blank" and nextWidgetTable.type ~= "breakline" and nextWidgetTable.type ~= "toggle" and nextWidgetTable.type ~= "color") then
								extraPaddingY = 4
							end
						end
					else
						label:SetPoint(currentXOffset, currentYOffset)
						switch:SetPoint("left", label, "right", 2, 0)
					end
					switch.hasLabel = label

					if (widgetTable.id) then
						parent.widgetids[widgetTable.id] = switch
					end

					local widgetTotalSize = label.widget:GetStringWidth() + 32
					if (widgetTotalSize > maxColumnWidth) then
						maxColumnWidth = widgetTotalSize
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, switch)
					tinsert(parent.widget_list_by_type.switch, switch)

					widgetCreated = switch
					amountLineWidgetCreated = amountLineWidgetCreated + 1

				elseif (widgetTable.type == "range") then
					assert(widgetTable.get, "DetailsFramework:BuildMenu(): .get not found in the widget table for 'range'")
					local isDecimanls = widgetTable.usedecimals
					local slider = DF:NewSlider(parent, nil, "$parentWidget" .. index, nil, 140, 20, widgetTable.min, widgetTable.max, widgetTable.step, widgetTable.get(),  isDecimanls, nil, nil, sliderTemplate)

					DetailsFramework.Language.RegisterTableKeyWithDefault(languageAddonId, slider, "have_tooltip", widgetTable.descPhraseId, widgetTable.desc)

					slider._get = widgetTable.get
					slider.widget_type = "range"
					slider:SetHook("OnValueChange", widgetTable.set)

					if (widgetTable.thumbscale) then
						slider:SetThumbSize(slider.thumb:GetWidth() * widgetTable.thumbscale, nil)
					else
						slider:SetThumbSize(slider.thumb:GetWidth() * 1.3, nil)
					end

					if (valueChangeHook) then
						slider:SetHook("OnValueChange", valueChangeHook)
					end

					--hook list
					if (widgetTable.hooks) then
						for hookName, hookFunc in pairs(widgetTable.hooks) do
							slider:SetHook(hookName, hookFunc)
						end
					end

					local label = DF:NewLabel(parent, nil, "$parentLabel" .. index, nil, "", "GameFontNormal", widgetTable.text_template or textTemplate or 12)
					DetailsFramework.Language.RegisterObjectWithDefault(languageAddonId, label.widget, widgetTable.namePhraseId, formatOptionNameWithColon(widgetTable.name, useColon))

					slider:SetPoint("left", label, "right", 2)
					label:SetPoint(currentXOffset, currentYOffset)
					slider.hasLabel = label

					if (widgetTable.id) then
						parent.widgetids[widgetTable.id] = slider
					end

					local widgetTotalSize = label.widget:GetStringWidth() + 146
					if (widgetTotalSize > maxColumnWidth) then
						maxColumnWidth = widgetTotalSize
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, slider)
					tinsert(parent.widget_list_by_type.slider, slider)

					widgetCreated = slider
					amountLineWidgetCreated = amountLineWidgetCreated + 1

				elseif (widgetTable.type == "color") then
					assert(widgetTable.get, "DetailsFramework:BuildMenu(): .get not found in the widget table for 'color'")
					local colorpick = DF:NewColorPickButton(parent, "$parentWidget" .. index, nil, widgetTable.set, nil, buttonTemplate)

					DetailsFramework.Language.RegisterTableKeyWithDefault(languageAddonId, colorpick, "have_tooltip", widgetTable.descPhraseId, widgetTable.desc)

					colorpick._get = widgetTable.get
					colorpick.widget_type = "color"
					colorpick:SetSize(18, 18)

					local r, g, b, a = DF:ParseColors(widgetTable.get())
					colorpick:SetColor(r, g, b, a)

					if (valueChangeHook) then
						colorpick:SetHook("OnColorChanged", valueChangeHook)
					end

					--hook list
					if (widgetTable.hooks) then
						for hookName, hookFunc in pairs(widgetTable.hooks) do
							colorpick:SetHook(hookName, hookFunc)
						end
					end

					local label = DF:NewLabel(parent, nil, "$parentLabel" .. index, nil, "", "GameFontNormal", widgetTable.text_template or textTemplate or 12)
					DetailsFramework.Language.RegisterObjectWithDefault(languageAddonId, label.widget, widgetTable.namePhraseId, formatOptionNameWithColon(widgetTable.name, useColon))

					if (widgetTable.boxfirst or useBoxFirstOnAllWidgets) then
						label:SetPoint("left", colorpick, "right", 2)
						colorpick:SetPoint(currentXOffset, currentYOffset)
						extraPaddingY = 1
					else
						colorpick:SetPoint("left", label, "right", 2)
						label:SetPoint(currentXOffset, currentYOffset)
					end

					colorpick.hasLabel = label

					if (widgetTable.id) then
						parent.widgetids[widgetTable.id] = colorpick
					end

					local widgetTotalSize = label.widget:GetStringWidth() + 32
					if (widgetTotalSize > maxColumnWidth) then
						maxColumnWidth = widgetTotalSize
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, colorpick)
					tinsert(parent.widget_list_by_type.color, colorpick)

					widgetCreated = colorpick
					amountLineWidgetCreated = amountLineWidgetCreated + 1

				elseif (widgetTable.type == "execute") then
					local button = DF:NewButton(parent, nil, "$parentWidget" .. index, nil, 120, 18, widgetTable.func, widgetTable.param1, widgetTable.param2, nil, "", nil, buttonTemplate, textTemplate)
					DetailsFramework.Language.RegisterObjectWithDefault(languageAddonId, button.widget, widgetTable.namePhraseId, widgetTable.name)

					if (not buttonTemplate) then
						button:InstallCustomTexture()
					end

					if (widgetTable.inline) then
						if (latestInlineWidget) then
							button:SetPoint("left", latestInlineWidget, "right", 2, 0)
							latestInlineWidget = button
						else
							button:SetPoint(currentXOffset, currentYOffset)
							latestInlineWidget = button
						end
					else
						button:SetPoint(currentXOffset, currentYOffset)
					end

					DetailsFramework.Language.RegisterTableKeyWithDefault(languageAddonId, button, "have_tooltip", widgetTable.descPhraseId, widgetTable.desc)

					button.widget_type = "execute"

					--button icon
					if (widgetTable.icontexture) then
						button:SetIcon(widgetTable.icontexture, nil, nil, nil, widgetTable.icontexcoords, nil, nil, 2)
					end

					--hook list
					if (widgetTable.hooks) then
						for hookName, hookFunc in pairs(widgetTable.hooks) do
							button:SetHook(hookName, hookFunc)
						end
					end

					if (widgetTable.id) then
						parent.widgetids [widgetTable.id] = button
					end

					if (widgetTable.width) then
						button:SetWidth(widgetTable.width)
					end
					if (widgetTable.height) then
						button:SetHeight(widgetTable.height)
					end

					local widgetTotalSize = button:GetWidth() + 4
					if (widgetTotalSize > maxColumnWidth) then
						maxColumnWidth = widgetTotalSize
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, button)
					tinsert(parent.widget_list_by_type.button, button)

					widgetCreated = button
					amountLineWidgetCreated = amountLineWidgetCreated + 1

				elseif (widgetTable.type == "textentry") then
					local textentry = DF:CreateTextEntry(parent, widgetTable.func or widgetTable.set, 120, 18, nil, "$parentWidget" .. index, nil, buttonTemplate)

					DetailsFramework.Language.RegisterTableKeyWithDefault(languageAddonId, textentry, "have_tooltip", widgetTable.descPhraseId, widgetTable.desc)

					textentry.text = widgetTable.get()
					textentry._get = widgetTable.get
					textentry.widget_type = "textentry"
					textentry:SetHook("OnEnterPressed", widgetTable.func or widgetTable.set)
					textentry:SetHook("OnEditFocusLost", widgetTable.func or widgetTable.set)

					local label = DF:NewLabel(parent, nil, "$parentLabel" .. index, nil, "", "GameFontNormal", widgetTable.text_template or textTemplate or 12)
					DetailsFramework.Language.RegisterObjectWithDefault(languageAddonId, label.widget, widgetTable.namePhraseId, formatOptionNameWithColon(widgetTable.name, useColon))

					textentry:SetPoint("left", label, "right", 2)
					label:SetPoint(currentXOffset, currentYOffset)
					textentry.hasLabel = label

					--hook list
					if (widgetTable.hooks) then
						for hookName, hookFunc in pairs(widgetTable.hooks) do
							textentry:SetHook(hookName, hookFunc)
						end
					end

					if (widgetTable.id) then
						parent.widgetids [widgetTable.id] = textentry
					end

					local widgetTotalSize = label.widget:GetStringWidth() + 64
					if (widgetTotalSize > maxColumnWidth) then
						maxColumnWidth = widgetTotalSize
					end

					--store the widget created into the overall table and the widget by type
					tinsert(parent.widget_list, textentry)
					tinsert(parent.widget_list_by_type.textentry, textentry)

					widgetCreated = textentry
					amountLineWidgetCreated = amountLineWidgetCreated + 1
				end

				if (widgetTable.nocombat) then
					tinsert(widgetsToDisableOnCombat, widgetCreated)
				end

				if (not widgetTable.inline) then
					if (widgetTable.spacement) then
						currentYOffset = currentYOffset - 30
					else
						currentYOffset = currentYOffset - 20
					end
				end

				if (extraPaddingY > 0) then
					currentYOffset = currentYOffset - extraPaddingY
				end

				if (widgetTable.type == "breakline" or currentYOffset < height) then
					currentYOffset = yOffset
					currentXOffset = currentXOffset + maxColumnWidth + 20
					amountLineWidgetCreated = 0
					maxColumnWidth = 0
				end
			end
		end

		DF.RefreshUnsafeOptionsWidgets()
	end

	local lockNotSafeWidgetsForCombat = function()
		for _, widget in ipairs(widgetsToDisableOnCombat) do
			widget:Disable()
		end
	end

	local unlockNotSafeWidgetsForCombat = function()
		for _, widget in ipairs(widgetsToDisableOnCombat) do
			widget:Enable()
		end
	end

	function DF.RefreshUnsafeOptionsWidgets()
		if (DF.PlayerHasCombatFlag) then
			lockNotSafeWidgetsForCombat()
		else
			unlockNotSafeWidgetsForCombat()
		end
	end

	DF.PlayerHasCombatFlag = false
	local ProtectCombatFrame = CreateFrame("frame")
	ProtectCombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	ProtectCombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	ProtectCombatFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	ProtectCombatFrame:SetScript("OnEvent", function(self, event)
		if (event == "PLAYER_ENTERING_WORLD") then
			if (InCombatLockdown()) then
				DF.PlayerHasCombatFlag = true
			else
				DF.PlayerHasCombatFlag = false
			end
			DF.RefreshUnsafeOptionsWidgets()

		elseif (event == "PLAYER_REGEN_ENABLED") then
			DF.PlayerHasCombatFlag = false
			DF.RefreshUnsafeOptionsWidgets()

		elseif (event == "PLAYER_REGEN_DISABLED") then
			DF.PlayerHasCombatFlag = true
			DF.RefreshUnsafeOptionsWidgets()
		end
	end)

	function DF:CreateInCombatTexture(frame)
		if (DF.debug and not frame) then
			error("Details! Framework: CreateInCombatTexture invalid frame on parameter 1.")
		end

		local inCombatBackgroundTexture = DF:CreateImage(frame)
		inCombatBackgroundTexture:SetColorTexture(.6, 0, 0, .1)
		inCombatBackgroundTexture:Hide()

		local inCombatLabel = Plater:CreateLabel(frame, "you are in combat", 24, "silver")
		inCombatLabel:SetPoint("right", inCombatBackgroundTexture, "right", -10, 0)
		inCombatLabel:Hide()

		frame:RegisterEvent("PLAYER_REGEN_DISABLED")
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")

		frame:SetScript("OnEvent", function(self, event)
			if (event == "PLAYER_REGEN_DISABLED") then
				inCombatBackgroundTexture:Show()
				inCombatLabel:Show()

			elseif (event == "PLAYER_REGEN_ENABLED") then
				inCombatBackgroundTexture:Hide()
				inCombatLabel:Hide()
			end
		end)

		return inCombatBackgroundTexture
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tutorials
	function DF:ShowTutorialAlertFrame(maintext, desctext, clickfunc)
		local TutorialAlertFrame = _G.DetailsFrameworkAlertFrame

		if (not TutorialAlertFrame) then

			TutorialAlertFrame = CreateFrame("frame", "DetailsFrameworkAlertFrame", UIParent, "MicroButtonAlertTemplate")
			TutorialAlertFrame.isFirst = true
			TutorialAlertFrame:SetPoint("left", UIParent, "left", -20, 100)
			TutorialAlertFrame:SetFrameStrata("TOOLTIP")
			TutorialAlertFrame:Hide()

			TutorialAlertFrame:SetScript("OnMouseUp", function(self)
				if (self.clickfunc and type(self.clickfunc) == "function") then
					self.clickfunc()
				end
				self:Hide()
			end)
			TutorialAlertFrame:Hide()
		end

		--
		TutorialAlertFrame.label = type(maintext) == "string" and maintext or type(desctext) == "string" and desctext or ""
		MicroButtonAlert_SetText (TutorialAlertFrame, alert.label)
		--

		TutorialAlertFrame.clickfunc = clickfunc
		TutorialAlertFrame:Show()
	end

	local refresh_options = function(self)
		for _, widget in ipairs(self.widget_list) do
			if (widget._get) then
				if (widget.widget_type == "label") then
					if (widget._get()) then
						widget:SetText(widget._get())
					end

				elseif (widget.widget_type == "select") then
					widget:Select(widget._get())

				elseif (widget.widget_type == "toggle" or widget.widget_type == "range") then
					widget:SetValue(widget._get())

				elseif (widget.widget_type == "textentry") then
					widget:SetText(widget._get())

				elseif (widget.widget_type == "color") then
					local default_value, g, b, a = widget._get()
					if (type(default_value) == "table") then
						widget:SetColor (unpack(default_value))

					else
						widget:SetColor (default_value, g, b, a)
					end
				end
			end
		end
	end

	local get_frame_by_id = function(self, id)
		return self.widgetids [id]
	end

	function DF:ClearOptionsPanel(frame)
		for i = 1, #frame.widget_list do
			frame.widget_list[i]:Hide()
			if (frame.widget_list[i].hasLabel) then
				frame.widget_list[i].hasLabel:SetText("")
			end
		end

		table.wipe(frame.widgetids)
	end

	function DF:SetAsOptionsPanel(frame)
		frame.RefreshOptions = refresh_options
		frame.widget_list = {}
		frame.widget_list_by_type = {
			["dropdown"] = {}, -- "select"
			["switch"] = {}, -- "toggle"
			["slider"] = {}, -- "range"
			["color"] = {}, --
			["button"] = {}, -- "execute"
			["textentry"] = {}, --
			["label"] = {}, --"text"
		}
		frame.widgetids = {}
		frame.GetWidgetById = get_frame_by_id
	end

	function DF:CreateOptionsFrame(name, title, template)
		template = template or 1

		if (template == 2) then
			local newOptionsFrame = CreateFrame("frame", name, UIParent, "ButtonFrameTemplate")
			tinsert(UISpecialFrames, name)

			newOptionsFrame:SetSize(500, 200)
			newOptionsFrame.RefreshOptions = refresh_options
			newOptionsFrame.widget_list = {}

			newOptionsFrame:SetScript("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then
						self.moving = false
						self:StopMovingOrSizing()
					end
					return newOptionsFrame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)

			newOptionsFrame:SetScript("OnMouseUp", function(self)
				if (self.moving) then
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)

			newOptionsFrame:SetMovable(true)
			newOptionsFrame:EnableMouse(true)
			newOptionsFrame:SetFrameStrata("DIALOG")
			newOptionsFrame:SetToplevel(true)
			newOptionsFrame:Hide()
			newOptionsFrame:SetPoint("center", UIParent, "center")
			newOptionsFrame.TitleText:SetText(title)

			return newOptionsFrame

		elseif (template == 1) then
			local newOptionsFrame = CreateFrame("frame", name, UIParent)
			tinsert(UISpecialFrames, name)

			newOptionsFrame:SetSize(500, 200)
			newOptionsFrame.RefreshOptions = refresh_options
			newOptionsFrame.widget_list = {}

			newOptionsFrame:SetScript("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then
						self.moving = false
						self:StopMovingOrSizing()
					end
					return newOptionsFrame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)

			newOptionsFrame:SetScript("OnMouseUp", function(self)
				if (self.moving) then
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)

			newOptionsFrame:SetMovable(true)
			newOptionsFrame:EnableMouse(true)
			newOptionsFrame:SetFrameStrata("DIALOG")
			newOptionsFrame:SetToplevel(true)
			newOptionsFrame:Hide()
			newOptionsFrame:SetPoint("center", UIParent, "center")

			newOptionsFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
			edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
			insets = {left = 1, right = 1, top = 1, bottom = 1}})
			newOptionsFrame:SetBackdropColor(0, 0, 0, .7)

			local textureTitle = newOptionsFrame:CreateTexture(nil, "artwork")
			textureTitle:SetTexture([[Interface\CURSOR\Interact]])
			textureTitle:SetTexCoord(0, 1, 0, 1)
			textureTitle:SetVertexColor(1, 1, 1, 1)
			textureTitle:SetPoint("topleft", newOptionsFrame, "topleft", 2, -3)
			textureTitle:SetWidth(36)
			textureTitle:SetHeight(36)

			local titleLabel = DF:NewLabel(newOptionsFrame, nil, "$parentTitle", nil, title, nil, 20, "yellow")
			titleLabel:SetPoint("left", textureTitle, "right", 2, -1)
			DF:SetFontOutline (titleLabel, true)

			local closeButton = CreateFrame("Button", nil, newOptionsFrame, "UIPanelCloseButton")
			closeButton:SetWidth(32)
			closeButton:SetHeight(32)
			closeButton:SetPoint("TOPRIGHT",  newOptionsFrame, "TOPRIGHT", -3, -3)
			closeButton:SetFrameLevel(newOptionsFrame:GetFrameLevel()+1)

			return newOptionsFrame
		end
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--~templates

local latinLanguageIds = {"enUS", "deDE", "esES", "esMX", "frFR", "itIT", "ptBR"}
local alphbets = {
	[latinLanguageIds] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"},
	["zhCN"] = {},
}

--fonts
DF.font_templates = DF.font_templates or {}

--detect which language is the client and select the font accordingly
local clientLanguage = GetLocale()
if (clientLanguage == "enGB") then
	clientLanguage = "enUS"
end

DF.ClientLanguage = clientLanguage

function DF:DetectTextLanguage(text)
	for i = 1, #text do
		--or not
	end
end

--returns which region the language the client is running, return "western", "russia" or "asia"
function DF:GetClientRegion()
	if (clientLanguage == "zhCN" or clientLanguage == "koKR" or clientLanguage == "zhTW") then
		return "asia"
	elseif (clientLanguage == "ruRU") then
		return "russia"
	else
		return "western"
	end
end

DF.registeredFontPaths = DF.registeredFontPaths or {}

function DF:GetBestFontPathForLanguage(locale)
	local fontPath = DF.registeredFontPaths[locale]
	if (fontPath) then
		return fontPath
	end

	--font paths gotten from creating a FontString with template "GameFontNormal" and getting the font returned from FontString:GetFont()
	if (locale == "enUS" or locale == "deDE" or locale == "esES" or locale == "esMX" or locale == "frFR" or locale == "itIT" or locale == "ptBR") then
		return [[Fonts\FRIZQT__.TTF]]

	elseif (locale == "ruRU") then
		return [[Fonts\FRIZQT___CYR.TTF]]

	elseif (locale == "zhCN") then
		return [[Fonts\ARKai_T.ttf]]

	elseif (locale == "zhTW") then
		return [[Fonts\blei00d.TTF]]

	elseif (locale == "koKR") then
		return [[Fonts\2002.TTF]]
	end

	--the locale passed doesn't exists, so pass the enUS
	return [[Fonts\FRIZQT__.TTF]]
end

--return the best font to use for the client language
function DF:GetBestFontForLanguage(language, western, cyrillic, china, korean, taiwan)
	if (not language) then
		language = DF.ClientLanguage
	end

	if (language == "enUS" or language == "deDE" or language == "esES" or language == "esMX" or language == "frFR" or language == "itIT" or language == "ptBR") then
		return western or "Friz Quadrata TT"

	elseif (language == "ruRU") then
		return cyrillic or "Friz Quadrata TT"

	elseif (language == "zhCN") then
		return china or "AR CrystalzcuheiGBK Demibold"

	elseif (language == "koKR") then
		return korean or "2002"

	elseif (language == "zhTW") then
		return taiwan or "AR CrystalzcuheiGBK Demibold"
	end
end

--DF.font_templates ["ORANGE_FONT_TEMPLATE"] = {color = "orange", size = 11, font = "Accidental Presidency"}
--DF.font_templates ["OPTIONS_FONT_TEMPLATE"] = {color = "yellow", size = 12, font = "Accidental Presidency"}
DF.font_templates["ORANGE_FONT_TEMPLATE"] = {color = "orange", size = 10, font = DF:GetBestFontForLanguage()}
DF.font_templates["OPTIONS_FONT_TEMPLATE"] = {color = "yellow", size = 9.6, font = DF:GetBestFontForLanguage()}

--dropdowns
DF.dropdown_templates = DF.dropdown_templates or {}
DF.dropdown_templates["OPTIONS_DROPDOWN_TEMPLATE"] = {
	backdrop = {
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize = 1,
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		tileSize = 64,
		tile = true
	},

	backdropcolor = {1, 1, 1, .7},
	backdropbordercolor = {0, 0, 0, 1},
	onentercolor = {1, 1, 1, .9},
	onenterbordercolor = {1, 1, 1, 1},

	dropicon = "Interface\\BUTTONS\\arrow-Down-Down",
	dropiconsize = {16, 16},
	dropiconpoints = {-2, -3},
}

DF.dropdown_templates["OPTIONS_DROPDOWNDARK_TEMPLATE"] = {
	backdrop = {
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize = 1,
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		tileSize = 64,
		tile = true
	},

	backdropcolor = {0.1215, 0.1176, 0.1294, 0.8000},
	backdropbordercolor = {.2, .2, .2, 1},
	onentercolor = {.5, .5, .5, .9},
	onenterbordercolor = {.4, .4, .4, 1},

	dropicon = "Interface\\BUTTONS\\arrow-Down-Down",
	dropiconsize = {16, 16},
	dropiconpoints = {-2, -3},
}

--switches
DF.switch_templates = DF.switch_templates or {}
DF.switch_templates["OPTIONS_CHECKBOX_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	width = 18,
	height = 18,
	enabled_backdropcolor = {1, 1, 1, .5},
	disabled_backdropcolor = {1, 1, 1, .2},
	onenterbordercolor = {1, 1, 1, 1},
}
DF.switch_templates["OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	width = 18,
	height = 18,
	enabled_backdropcolor = {1, 1, 1, .5},
	disabled_backdropcolor = {1, 1, 1, .5},
	onenterbordercolor = {1, 1, 1, 1},
}

--buttons
DF.button_templates = DF.button_templates or {}
DF.button_templates["OPTIONS_BUTTON_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
}

--sliders
DF.slider_templates = DF.slider_templates or {}
DF.slider_templates["OPTIONS_SLIDER_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	onentercolor = {1, 1, 1, .5},
	onenterbordercolor = {1, 1, 1, 1},
	thumbtexture = [[Interface\Tooltips\UI-Tooltip-Background]],
	thumbwidth = 16,
	thumbheight = 14,
	thumbcolor = {0, 0, 0, 0.5},
}

function DF:InstallTemplate(widgetType, templateName, template, parentName)
	local newTemplate = {}

	--if has a parent, just copy the parent to the new template
	if (parentName and type(parentName) == "string") then
		local parentTemplate = DF:GetTemplate(widgetType, parentName)
		if (parentTemplate) then
			DF.table.copy(newTemplate, parentTemplate)
		end
	end

	--copy the template passed into the new template
	DF.table.copy(newTemplate, template)

	widgetType = string.lower(widgetType)

	local templateTable
	if (widgetType == "font") then
		templateTable = DF.font_templates

		local font = template.font
		if (font) then
			--fonts passed into the template has default to western
			--the framework will get the game client language and change the font if needed
			font = DF:GetBestFontForLanguage(nil, font)
		end

	elseif (widgetType == "dropdown") then
		templateTable = DF.dropdown_templates

	elseif (widgetType == "button") then
		templateTable = DF.button_templates

	elseif (widgetType == "switch") then
		templateTable = DF.switch_templates

	elseif (widgetType == "slider") then
		templateTable = DF.slider_templates
	end

	templateTable[templateName] = newTemplate
	return newTemplate
end

function DF:GetTemplate(widgetType, templateName)
	widgetType = string.lower(widgetType)
	local templateTable

	if (widgetType == "font") then
		templateTable = DF.font_templates

	elseif (widgetType == "dropdown") then
		templateTable = DF.dropdown_templates

	elseif (widgetType == "button") then
		templateTable = DF.button_templates

	elseif (widgetType == "switch") then
		templateTable = DF.switch_templates

	elseif (widgetType == "slider") then
		templateTable = DF.slider_templates
	end

	return templateTable[templateName]
end

function DF.GetParentName(frame)
	local parentName = frame:GetName()
	if (not parentName) then
		error("Details! FrameWork: called $parent but parent was no name.", 2)
	end
	return parentName
end

function DF:Error (errortext)
	print("|cFFFF2222Details! Framework Error|r:", errortext, self.GetName and self:GetName(), self.WidgetType, debugstack (2, 3, 0))
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--members

DF.GlobalWidgetControlNames = {
	textentry = "DF_TextEntryMetaFunctions",
	button = "DF_ButtonMetaFunctions",
	panel = "DF_PanelMetaFunctions",
	dropdown = "DF_DropdownMetaFunctions",
	label = "DF_LabelMetaFunctions",
	normal_bar = "DF_NormalBarMetaFunctions",
	image = "DF_ImageMetaFunctions",
	slider = "DF_SliderMetaFunctions",
	split_bar = "DF_SplitBarMetaFunctions",
	aura_tracker = "DF_AuraTracker",
	healthBar = "DF_healthBarMetaFunctions",
	timebar = "DF_TimeBarMetaFunctions",
}

function DF:AddMemberForWidget(widgetName, memberType, memberName, func)
	if (DF.GlobalWidgetControlNames[widgetName]) then
		if (type(memberName) == "string" and (memberType == "SET" or memberType == "GET")) then
			if (func) then
				local widgetControlObject = _G [DF.GlobalWidgetControlNames[widgetName]]

				if (memberType == "SET") then
					widgetControlObject["SetMembers"][memberName] = func
				elseif (memberType == "GET") then
					widgetControlObject["GetMembers"][memberName] = func
				end
			else
				if (DF.debug) then
					error("Details! Framework: AddMemberForWidget invalid function.")
				end
			end
		else
			if (DF.debug) then
				error("Details! Framework: AddMemberForWidget unknown memberName or memberType.")
			end
		end
	else
		if (DF.debug) then
			error("Details! Framework: AddMemberForWidget unknown widget type: " .. (widgetName or "") .. ".")
		end
	end
end

-----------------------------

function DF:OpenInterfaceProfile()
	-- OptionsFrame1/2 should be registered if created with DF:CreateAddOn, so open to them directly
	if self.OptionsFrame1 then
		if SettingsPanel then
			--SettingsPanel:OpenToCategory(self.OptionsFrame1.name)
			local category = SettingsPanel:GetCategoryList():GetCategory(self.OptionsFrame1.name)
			if category then
				SettingsPanel:Open()
				SettingsPanel:SelectCategory(category)
				if self.OptionsFrame2 and category:HasSubcategories() then
					for _, subcategory in pairs(category:GetSubcategories()) do
						if subcategory:GetName() == self.OptionsFrame2.name then
							SettingsPanel:SelectCategory(subcategory)
							break
						end
					end
				end
			end
			return
		elseif InterfaceOptionsFrame_OpenToCategory then
			InterfaceOptionsFrame_OpenToCategory (self.OptionsFrame1)
			if self.OptionsFrame2 then
				InterfaceOptionsFrame_OpenToCategory (self.OptionsFrame2)
			end
			return
		end
	end

	-- fallback (broken as of ElvUI Skins in version 12.18+... maybe fix/change will come)
	InterfaceOptionsFrame_OpenToCategory (self.__name)
	InterfaceOptionsFrame_OpenToCategory (self.__name)
	for i = 1, 100 do
		local button = _G ["InterfaceOptionsFrameAddOnsButton" .. i]
		if (button) then
			local text = _G ["InterfaceOptionsFrameAddOnsButton" .. i .. "Text"]
			if (text) then
				text = text:GetText()
				if (text == self.__name) then
					local toggle = _G ["InterfaceOptionsFrameAddOnsButton" .. i .. "Toggle"]
					if (toggle) then
						if (toggle:GetNormalTexture():GetTexture():find("PlusButton")) then
							--is minimized, need expand
							toggle:Click()
							_G ["InterfaceOptionsFrameAddOnsButton" .. i+1]:Click()
						elseif (toggle:GetNormalTexture():GetTexture():find("MinusButton")) then
							--isn't minimized
							_G ["InterfaceOptionsFrameAddOnsButton" .. i+1]:Click()
						end
					end
					break
				end
			end
		else
			self:Msg("Couldn't not find the profile panel.")
			break
		end
	end
end

-----------------------------
--safe copy from blizz api
function DF:Mixin(object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...)
		for key, value in pairs(mixin) do
			object[key] = value
		end
	end
	return object
end

-----------------------------
--animations

function DF:CreateAnimationHub(parent, onPlay, onFinished)
	local newAnimation = parent:CreateAnimationGroup()
	newAnimation:SetScript("OnPlay", onPlay)
	newAnimation:SetScript("OnFinished", onFinished)
	newAnimation:SetScript("OnStop", onFinished)
	newAnimation.NextAnimation = 1
	return newAnimation
end

function DF:CreateAnimation(animation, animationType, order, duration, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local anim = animation:CreateAnimation(animationType)
	anim:SetOrder(order or animation.NextAnimation)
	anim:SetDuration(duration)

	animationType = string.upper(animationType)

	if (animationType == "ALPHA") then
		anim:SetFromAlpha(arg1)
		anim:SetToAlpha(arg2)

	elseif (animationType == "SCALE") then
		if (DF.IsDragonflight() or DF.IsWotLKWowWithRetailAPI()) then
			anim:SetScaleFrom(arg1, arg2)
			anim:SetScaleTo(arg3, arg4)
		else
			anim:SetFromScale(arg1, arg2)
			anim:SetToScale(arg3, arg4)
		end
		anim:SetOrigin(arg5 or "center", arg6 or 0, arg7 or 0) --point, x, y

	elseif (animationType == "ROTATION") then
		anim:SetDegrees(arg1) --degree
		anim:SetOrigin(arg2 or "center", arg3 or 0, arg4 or 0) --point, x, y

	elseif (animationType == "TRANSLATION") then
		anim:SetOffset(arg1, arg2)
	end

	animation.NextAnimation = animation.NextAnimation + 1
	return anim
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--frame shakes

--frame shakes rely on OnUpdate scripts, we are using a built-in OnUpdate so is guarantee it'll run
local FrameshakeUpdateFrame = DetailsFrameworkFrameshakeControl or CreateFrame("frame", "DetailsFrameworkFrameshakeControl", UIParent)
--store the frame which has frame shakes registered
FrameshakeUpdateFrame.RegisteredFrames = FrameshakeUpdateFrame.RegisteredFrames or {}

FrameshakeUpdateFrame.RegisterFrame = function(newFrame)
	--add the frame into the registered frames to update
	DF.table.addunique(FrameshakeUpdateFrame.RegisteredFrames, newFrame)
end

--forward declared
local frameshake_DoUpdate

FrameshakeUpdateFrame:SetScript("OnUpdate", function(self, deltaTime)
	for i = 1, #FrameshakeUpdateFrame.RegisteredFrames do
		local parent = FrameshakeUpdateFrame.RegisteredFrames [i]
		--check if there's a shake running
		if (parent.__frameshakes.enabled > 0) then
			--update all shakes for this frame
			for i = 1, #parent.__frameshakes do
				local shakeObject = parent.__frameshakes [i]
				if (shakeObject.IsPlaying) then
					frameshake_DoUpdate(parent, shakeObject, deltaTime)
				end
			end
		end
	end
end)


local frameshake_ShakeFinished = function(parent, shakeObject)
	if (shakeObject.IsPlaying) then
		shakeObject.IsPlaying = false
		shakeObject.TimeLeft = 0
		shakeObject.IsFadingOut = false
		shakeObject.IsFadingIn = false

		--update the amount of shake running on this frame
		parent.__frameshakes.enabled = parent.__frameshakes.enabled - 1

		--restore the default anchors, in case where deltaTime was too small that didn't triggered an update
		for i = 1, #shakeObject.Anchors do
			local anchor = shakeObject.Anchors [i]

			--automatic anchoring and reanching needs to the reviwed in the future
			if (#anchor == 1) then
				local anchorTo = unpack(anchor)
				parent:ClearAllPoints()
				parent:SetPoint(anchorTo)

			elseif (#anchor == 2) then
				local anchorTo, point1 = unpack(anchor)
				parent:ClearAllPoints()
				parent:SetPoint(anchorTo, point1)

			elseif (#anchor == 3) then
				local anchorTo, point1, point2 = unpack(anchor)
				parent:SetPoint(anchorTo, point1, point2)

			elseif (#anchor == 5) then
				local anchorName1, anchorTo, anchorName2, point1, point2 = unpack(anchor)
				parent:SetPoint(anchorName1, anchorTo, anchorName2, point1, point2)
			end
		end
	end
end

--already declared above the update function
frameshake_DoUpdate = function(parent, shakeObject, deltaTime)
	--check delta time
	deltaTime = deltaTime or 0

	--update time left
	shakeObject.TimeLeft = max(shakeObject.TimeLeft - deltaTime, 0)

	if (shakeObject.TimeLeft > 0) then
		--update fade in and out
		if (shakeObject.IsFadingIn) then
			shakeObject.IsFadingInTime = shakeObject.IsFadingInTime + deltaTime
		end
		if (shakeObject.IsFadingOut) then
			shakeObject.IsFadingOutTime = shakeObject.IsFadingOutTime + deltaTime
		end

		--check if can disable fade in
		if (shakeObject.IsFadingIn and shakeObject.IsFadingInTime > shakeObject.FadeInTime) then
			shakeObject.IsFadingIn = false
		end

		--check if can enable fade out
		if (not shakeObject.IsFadingOut and shakeObject.TimeLeft < shakeObject.FadeOutTime) then
			shakeObject.IsFadingOut = true
			shakeObject.IsFadingOutTime = shakeObject.FadeOutTime - shakeObject.TimeLeft
		end

		--update position
		local scaleShake = min(shakeObject.IsFadingIn and (shakeObject.IsFadingInTime / shakeObject.FadeInTime) or 1, shakeObject.IsFadingOut and (1 - shakeObject.IsFadingOutTime / shakeObject.FadeOutTime) or 1)

		if (scaleShake > 0) then

			--delate the time by the frequency on both X and Y offsets
			shakeObject.XSineOffset = shakeObject.XSineOffset + (deltaTime * shakeObject.Frequency)
			shakeObject.YSineOffset = shakeObject.YSineOffset + (deltaTime * shakeObject.Frequency)

			--calc the new position
			local newX, newY
			if (shakeObject.AbsoluteSineX) then
				--absoluting only the sine wave, passing a negative scale will reverse the absolute direction
				newX = shakeObject.Amplitude * abs(math.sin(shakeObject.XSineOffset)) * scaleShake * shakeObject.ScaleX
			else
				newX = shakeObject.Amplitude * math.sin(shakeObject.XSineOffset) * scaleShake * shakeObject.ScaleX
			end

			if (shakeObject.AbsoluteSineY) then
				newY = shakeObject.Amplitude * abs(math.sin(shakeObject.YSineOffset)) * scaleShake * shakeObject.ScaleY
			else
				newY = shakeObject.Amplitude * math.sin(shakeObject.YSineOffset) * scaleShake * shakeObject.ScaleY
			end

			--apply the offset to the frame anchors
			for i = 1, #shakeObject.Anchors do
				local anchor = shakeObject.Anchors [i]

				if (#anchor == 1 or #anchor == 3) then
					local anchorTo, point1, point2 = unpack(anchor)
					point1 = point1 or 0
					point2 = point2 or 0
					parent:SetPoint(anchorTo, point1 + newX, point2 + newY)

				elseif (#anchor == 5) then
					local anchorName1, anchorTo, anchorName2, point1, point2 = unpack(anchor)
					--parent:ClearAllPoints()

					parent:SetPoint(anchorName1, anchorTo, anchorName2, point1 + newX, point2 + newY)
				end
			end

		end
	else
		frameshake_ShakeFinished(parent, shakeObject)
	end
end

local frameshake_stop = function(parent, shakeObject)
	frameshake_ShakeFinished(parent, shakeObject)
end

--scale direction scales the X and Y coordinates, scale strength scales the amplitude and frequency
local frameshake_play = function(parent, shakeObject, scaleDirection, scaleAmplitude, scaleFrequency, scaleDuration)
	--check if is already playing
	if (shakeObject.TimeLeft > 0) then
		--reset the time left
		shakeObject.TimeLeft = shakeObject.Duration

		if (shakeObject.IsFadingOut) then
			if (shakeObject.FadeInTime > 0) then
				shakeObject.IsFadingIn = true
				--scale the current fade out into fade in, so it starts the fade in at the point where it was fading out
				shakeObject.IsFadingInTime = shakeObject.FadeInTime * (1 - shakeObject.IsFadingOutTime / shakeObject.FadeOutTime)
			else
				shakeObject.IsFadingIn = false
				shakeObject.IsFadingInTime = 0
			end

			--disable fade out and enable fade in
			shakeObject.IsFadingOut = false
			shakeObject.IsFadingOutTime = 0
		end
	else
		--create a new random offset
		shakeObject.XSineOffset = math.pi * 2 * math.random()
		shakeObject.YSineOffset = math.pi * 2 * math.random()

		--store the initial position if case it needs a reset
		shakeObject.StartedXSineOffset = shakeObject.XSineOffset
		shakeObject.StartedYSineOffset = shakeObject.YSineOffset

		--check if there's a fade in time
		if (shakeObject.FadeInTime > 0) then
			shakeObject.IsFadingIn = true
		else
			shakeObject.IsFadingIn = false
		end

		shakeObject.IsFadingInTime = 0
		shakeObject.IsFadingOut = false
		shakeObject.IsFadingOutTime = 0

		--apply custom scale
		shakeObject.ScaleX = (scaleDirection or 1) * shakeObject.OriginalScaleX
		shakeObject.ScaleY = (scaleDirection or 1) * shakeObject.OriginalScaleY
		shakeObject.Frequency = (scaleFrequency or 1) * shakeObject.OriginalFrequency
		shakeObject.Amplitude = (scaleAmplitude or 1) * shakeObject.OriginalAmplitude
		shakeObject.Duration = (scaleDuration or 1) * shakeObject.OriginalDuration

		--update the time left
		shakeObject.TimeLeft = shakeObject.Duration

		--check if is dynamic points
		if (shakeObject.IsDynamicAnchor) then
			wipe(shakeObject.Anchors)
			for i = 1, parent:GetNumPoints() do
				local p1, p2, p3, p4, p5 = parent:GetPoint(i)
				shakeObject.Anchors[#shakeObject.Anchors+1] = {p1, p2, p3, p4, p5}
			end
		end

		--update the amount of shake running on this frame
		parent.__frameshakes.enabled = parent.__frameshakes.enabled + 1

		if (not parent:GetScript("OnUpdate")) then
			parent:SetScript("OnUpdate", function()end)
		end
	end

	shakeObject.IsPlaying = true

	frameshake_DoUpdate(parent, shakeObject)
end

local frameshake_SetConfig = function(parent, shakeObject, duration, amplitude, frequency, absoluteSineX, absoluteSineY, scaleX, scaleY, fadeInTime, fadeOutTime, anchorPoints)
	shakeObject.Amplitude = amplitude or shakeObject.Amplitude
	shakeObject.Frequency = frequency or shakeObject.Frequency
	shakeObject.Duration = duration or shakeObject.Duration
	shakeObject.FadeInTime = fadeInTime or shakeObject.FadeInTime
	shakeObject.FadeOutTime = fadeOutTime or shakeObject.FadeOutTime
	shakeObject.ScaleX  = scaleX or shakeObject.ScaleX
	shakeObject.ScaleY = scaleY or shakeObject.ScaleY

	if (absoluteSineX ~= nil) then
		shakeObject.AbsoluteSineX = absoluteSineX
	end

	if (absoluteSineY ~= nil) then
		shakeObject.AbsoluteSineY = absoluteSineY
	end

	shakeObject.OriginalScaleX = shakeObject.ScaleX
	shakeObject.OriginalScaleY = shakeObject.ScaleY
	shakeObject.OriginalFrequency = shakeObject.Frequency
	shakeObject.OriginalAmplitude = shakeObject.Amplitude
	shakeObject.OriginalDuration = shakeObject.Duration
end

function DF:CreateFrameShake(parent, duration, amplitude, frequency, absoluteSineX, absoluteSineY, scaleX, scaleY, fadeInTime, fadeOutTime, anchorPoints)

	--create the shake table
	local frameShake = {
		Amplitude = amplitude or 2,
		Frequency = frequency or 5,
		Duration = duration or 0.3,
		FadeInTime = fadeInTime or 0.01,
		FadeOutTime = fadeOutTime or 0.01,
		ScaleX  = scaleX or 0.2,
		ScaleY = scaleY or 1,
		AbsoluteSineX = absoluteSineX,
		AbsoluteSineY = absoluteSineY,
		--
		IsPlaying = false,
		TimeLeft = 0,
	}

	frameShake.OriginalScaleX = frameShake.ScaleX
	frameShake.OriginalScaleY = frameShake.ScaleY
	frameShake.OriginalFrequency = frameShake.Frequency
	frameShake.OriginalAmplitude = frameShake.Amplitude
	frameShake.OriginalDuration = frameShake.Duration

	if (type(anchorPoints) ~= "table") then
		frameShake.IsDynamicAnchor = true
		frameShake.Anchors = {}
	else
		frameShake.Anchors = anchorPoints
	end

	--inject frame shake table into the frame
	if (not parent.__frameshakes) then
		parent.__frameshakes = {
			enabled = 0,
		}
		parent.PlayFrameShake = frameshake_play
		parent.StopFrameShake = frameshake_stop
		parent.UpdateFrameShake = frameshake_DoUpdate
		parent.SetFrameShakeSettings = frameshake_SetConfig

		--register the frame within the frame shake updater
		FrameshakeUpdateFrame.RegisterFrame (parent)
	end

	tinsert(parent.__frameshakes, frameShake)

	return frameShake
end


-----------------------------
--glow overlay

local glow_overlay_play = function(self)
	if (not self:IsShown()) then
		self:Show()
	end
	if (self.animOut:IsPlaying()) then
		self.animOut:Stop()
	end
	if (not self.animIn:IsPlaying()) then
		self.animIn:Stop()
		self.animIn:Play()
	end
end

local glow_overlay_stop = function(self)
	if (self.animOut:IsPlaying()) then
		self.animOut:Stop()
	end
	if (self.animIn:IsPlaying()) then
		self.animIn:Stop()
	end
	if (self:IsShown()) then
		self:Hide()
	end
end

local glow_overlay_setcolor = function(self, antsColor, glowColor)
	if (antsColor) then
		local r, g, b, a = DF:ParseColors(antsColor)
		self.ants:SetVertexColor(r, g, b, a)
		self.AntsColor.r = r
		self.AntsColor.g = g
		self.AntsColor.b = b
		self.AntsColor.a = a
	end

	if (glowColor) then
		local r, g, b, a = DF:ParseColors(glowColor)
		self.outerGlow:SetVertexColor(r, g, b, a)
		self.GlowColor.r = r
		self.GlowColor.g = g
		self.GlowColor.b = b
		self.GlowColor.a = a
	end
end

local glow_overlay_onshow = function(self)
	glow_overlay_play (self)
end

local glow_overlay_onhide = function(self)
	glow_overlay_stop (self)
end

--this is most copied from the wow client code, few changes applied to customize it
function DF:CreateGlowOverlay (parent, antsColor, glowColor)
	local pName = parent:GetName()
	local fName = pName and (pName.."Glow2") or "OverlayActionGlow" .. math.random(1, 10000000)
	if fName and string.len(fName) > 50 then -- shorten to work around too long names
		fName = strsub(fName, string.len(fName)-49)
	end
	local glowFrame = CreateFrame("frame", fName, parent, "ActionBarButtonSpellActivationAlert")
	glowFrame:HookScript ("OnShow", glow_overlay_onshow)
	glowFrame:HookScript ("OnHide", glow_overlay_onhide)

	glowFrame.Play = glow_overlay_play
	glowFrame.Stop = glow_overlay_stop
	glowFrame.SetColor = glow_overlay_setcolor

	glowFrame:Hide()

	parent.overlay = glowFrame
	local frameWidth, frameHeight = parent:GetSize()

	local scale = 1.4

	--Make the height/width available before the next frame:
	parent.overlay:SetSize(frameWidth * scale, frameHeight * scale)
	parent.overlay:SetPoint("TOPLEFT", parent, "TOPLEFT", -frameWidth * 0.32, frameHeight * 0.36)
	parent.overlay:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", frameWidth * 0.32, -frameHeight * 0.36)

	local r, g, b, a = DF:ParseColors(antsColor)
	glowFrame.ants:SetVertexColor(r, g, b, a)
	glowFrame.AntsColor = {r, g, b, a}

	local r, g, b, a = DF:ParseColors(glowColor)
	glowFrame.outerGlow:SetVertexColor(r, g, b, a)
	glowFrame.GlowColor = {r, g, b, a}

	glowFrame.outerGlow:SetScale(1.2)
	glowFrame:EnableMouse(false)
	return glowFrame
end

--custom glow with ants animation
local ants_set_texture_offset = function(self, leftOffset, rightOffset, topOffset, bottomOffset)
	leftOffset = leftOffset or 0
	rightOffset = rightOffset or 0
	topOffset = topOffset or 0
	bottomOffset = bottomOffset or 0

	self:ClearAllPoints()
	self:SetPoint("topleft", leftOffset, topOffset)
	self:SetPoint("bottomright", rightOffset, bottomOffset)
end

function DF:CreateAnts (parent, antTable, leftOffset, rightOffset, topOffset, bottomOffset, antTexture)
	leftOffset = leftOffset or 0
	rightOffset = rightOffset or 0
	topOffset = topOffset or 0
	bottomOffset = bottomOffset or 0

	local f = CreateFrame("frame", nil, parent)
	f:SetPoint("topleft", leftOffset, topOffset)
	f:SetPoint("bottomright", rightOffset, bottomOffset)

	f.SetOffset = ants_set_texture_offset

	local t = f:CreateTexture(nil, "overlay")
	t:SetAllPoints()
	t:SetTexture(antTable.Texture)
	t:SetBlendMode(antTable.BlendMode or "ADD")
	t:SetVertexColor(DF:ParseColors(antTable.Color or "white"))
	f.Texture = t

	f.AntTable = antTable

	f:SetScript("OnUpdate", function(self, deltaTime)
		AnimateTexCoords (t, self.AntTable.TextureWidth, self.AntTable.TextureHeight, self.AntTable.TexturePartsWidth, self.AntTable.TexturePartsHeight, self.AntTable.AmountParts, deltaTime, self.AntTable.Throttle or 0.025)
	end)

	return f
end

--[=[ --test ants
do
	local f = DF:CreateAnts (UIParent)
end
--]=]

-----------------------------
--borders

local default_border_color1 = .5
local default_border_color2 = .3
local default_border_color3 = .1

local SetBorderAlpha = function(self, alpha1, alpha2, alpha3)
	self.Borders.Alpha1 = alpha1 or self.Borders.Alpha1
	self.Borders.Alpha2 = alpha2 or self.Borders.Alpha2
	self.Borders.Alpha3 = alpha3 or self.Borders.Alpha3

	for _, texture in ipairs(self.Borders.Layer1) do
		texture:SetAlpha(self.Borders.Alpha1)
	end
	for _, texture in ipairs(self.Borders.Layer2) do
		texture:SetAlpha(self.Borders.Alpha2)
	end
	for _, texture in ipairs(self.Borders.Layer3) do
		texture:SetAlpha(self.Borders.Alpha3)
	end
end

local SetBorderColor = function(self, r, g, b)
	for _, texture in ipairs(self.Borders.Layer1) do
		texture:SetColorTexture(r, g, b)
	end
	for _, texture in ipairs(self.Borders.Layer2) do
		texture:SetColorTexture(r, g, b)
	end
	for _, texture in ipairs(self.Borders.Layer3) do
		texture:SetColorTexture(r, g, b)
	end
end

local SetLayerVisibility = function(self, layer1Shown, layer2Shown, layer3Shown)
	for _, texture in ipairs(self.Borders.Layer1) do
		texture:SetShown (layer1Shown)
	end

	for _, texture in ipairs(self.Borders.Layer2) do
		texture:SetShown (layer2Shown)
	end

	for _, texture in ipairs(self.Borders.Layer3) do
		texture:SetShown (layer3Shown)
	end
end

function DF:CreateBorder(parent, alpha1, alpha2, alpha3)
	parent.Borders = {
		Layer1 = {},
		Layer2 = {},
		Layer3 = {},
		Alpha1 = alpha1 or default_border_color1,
		Alpha2 = alpha2 or default_border_color2,
		Alpha3 = alpha3 or default_border_color3,
	}

	parent.SetBorderAlpha = SetBorderAlpha
	parent.SetBorderColor = SetBorderColor
	parent.SetLayerVisibility = SetLayerVisibility

	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "topleft", parent, "topleft", -1, 1)
	PixelUtil.SetPoint(border1, "bottomleft", parent, "bottomleft", -1, -1)
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "topleft", parent, "topleft", -2, 2)
	PixelUtil.SetPoint(border2, "bottomleft", parent, "bottomleft", -2, -2)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "topleft", parent, "topleft", -3, 3)
	PixelUtil.SetPoint(border3, "bottomleft", parent, "bottomleft", -3, -3)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "topleft", parent, "topleft", 0, 1)
	PixelUtil.SetPoint(border1, "topright", parent, "topright", 1, 1)
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "topleft", parent, "topleft", -1, 2)
	PixelUtil.SetPoint(border2, "topright", parent, "topright", 2, 2)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "topleft", parent, "topleft", -2, 3)
	PixelUtil.SetPoint(border3, "topright", parent, "topright", 3, 3)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "topright", parent, "topright", 1, 0)
	PixelUtil.SetPoint(border1, "bottomright", parent, "bottomright", 1, -1)
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "topright", parent, "topright", 2, 1)
	PixelUtil.SetPoint(border2, "bottomright", parent, "bottomright", 2, -2)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "topright", parent, "topright", 3, 2)
	PixelUtil.SetPoint(border3, "bottomright", parent, "bottomright", 3, -3)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "bottomleft", parent, "bottomleft", 0, -1)
	PixelUtil.SetPoint(border1, "bottomright", parent, "bottomright", 0, -1)
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "bottomleft", parent, "bottomleft", -1, -2)
	PixelUtil.SetPoint(border2, "bottomright", parent, "bottomright", 1, -2)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "bottomleft", parent, "bottomleft", -2, -3)
	PixelUtil.SetPoint(border3, "bottomright", parent, "bottomright", 2, -3)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)
end

--DFNamePlateBorder as copy from "NameplateFullBorderTemplate" -> DF:CreateFullBorder (name, parent)
local DFNamePlateBorderTemplateMixin = {};

function DFNamePlateBorderTemplateMixin:SetVertexColor(r, g, b, a)
	for i, texture in ipairs(self.Textures) do
		texture:SetVertexColor(r, g, b, a);
	end
end

function DFNamePlateBorderTemplateMixin:GetVertexColor()
	for i, texture in ipairs(self.Textures) do
		return texture:GetVertexColor();
	end
end

function DFNamePlateBorderTemplateMixin:SetBorderSizes(borderSize, borderSizeMinPixels, upwardExtendHeightPixels, upwardExtendHeightMinPixels)
	self.borderSize = borderSize;
	self.borderSizeMinPixels = borderSizeMinPixels;
	self.upwardExtendHeightPixels = upwardExtendHeightPixels;
	self.upwardExtendHeightMinPixels = upwardExtendHeightMinPixels;
end

function DFNamePlateBorderTemplateMixin:UpdateSizes()
	local borderSize = self.borderSize or 1;
	local minPixels = self.borderSizeMinPixels or 2;

	local upwardExtendHeightPixels = self.upwardExtendHeightPixels or borderSize;
	local upwardExtendHeightMinPixels = self.upwardExtendHeightMinPixels or minPixels;

	PixelUtil.SetWidth(self.Left, borderSize, minPixels);
	PixelUtil.SetPoint(self.Left, "TOPRIGHT", self, "TOPLEFT", 0, upwardExtendHeightPixels, 0, upwardExtendHeightMinPixels);
	PixelUtil.SetPoint(self.Left, "BOTTOMRIGHT", self, "BOTTOMLEFT", 0, -borderSize, 0, minPixels);

	PixelUtil.SetWidth(self.Right, borderSize, minPixels);
	PixelUtil.SetPoint(self.Right, "TOPLEFT", self, "TOPRIGHT", 0, upwardExtendHeightPixels, 0, upwardExtendHeightMinPixels);
	PixelUtil.SetPoint(self.Right, "BOTTOMLEFT", self, "BOTTOMRIGHT", 0, -borderSize, 0, minPixels);

	PixelUtil.SetHeight(self.Bottom, borderSize, minPixels);
	PixelUtil.SetPoint(self.Bottom, "TOPLEFT", self, "BOTTOMLEFT", 0, 0);
	PixelUtil.SetPoint(self.Bottom, "TOPRIGHT", self, "BOTTOMRIGHT", 0, 0);

	if self.Top then
		PixelUtil.SetHeight(self.Top, borderSize, minPixels);
		PixelUtil.SetPoint(self.Top, "BOTTOMLEFT", self, "TOPLEFT", 0, 0);
		PixelUtil.SetPoint(self.Top, "BOTTOMRIGHT", self, "TOPRIGHT", 0, 0);
	end
end

function DF:CreateFullBorder (name, parent)
	local border = CreateFrame("Frame", name, parent)
	border:SetAllPoints()
	border:SetIgnoreParentScale(true)
	border:SetFrameLevel(border:GetParent():GetFrameLevel())
	border.Textures = {}
	Mixin(border, DFNamePlateBorderTemplateMixin)

	local left = border:CreateTexture("$parentLeft", "BACKGROUND", nil, -8)
	--left:SetDrawLayer("BACKGROUND", -8)
	left:SetColorTexture(1, 1, 1, 1)
	left:SetWidth(1.0)
	left:SetPoint("TOPRIGHT", border, "TOPLEFT", 0, 1.0)
	left:SetPoint("BOTTOMRIGHT", border, "BOTTOMLEFT", 0, -1.0)
	border.Left = left
	tinsert(border.Textures, left)

	local right = border:CreateTexture("$parentRight", "BACKGROUND", nil, -8)
	--right:SetDrawLayer("BACKGROUND", -8)
	right:SetColorTexture(1, 1, 1, 1)
	right:SetWidth(1.0)
	right:SetPoint("TOPLEFT", border, "TOPRIGHT", 0, 1.0)
	right:SetPoint("BOTTOMLEFT", border, "BOTTOMRIGHT", 0, -1.0)
	border.Right = right
	tinsert(border.Textures, right)

	local bottom = border:CreateTexture("$parentBottom", "BACKGROUND", nil, -8)
	--bottom:SetDrawLayer("BACKGROUND", -8)
	bottom:SetColorTexture(1, 1, 1, 1)
	bottom:SetHeight(1.0)
	bottom:SetPoint("TOPLEFT", border, "BOTTOMLEFT", 0, 0)
	bottom:SetPoint("TOPRIGHT", border, "BOTTOMRIGHT", 0, 0)
	border.Bottom = bottom
	tinsert(border.Textures, bottom)

	local top = border:CreateTexture("$parentTop", "BACKGROUND", nil, -8)
	--top:SetDrawLayer("BACKGROUND", -8)
	top:SetColorTexture(1, 1, 1, 1)
	top:SetHeight(1.0)
	top:SetPoint("BOTTOMLEFT", border, "TOPLEFT", 0, 0)
	top:SetPoint("BOTTOMRIGHT", border, "TOPRIGHT", 0, 0)
	border.Top = top
	tinsert(border.Textures, top)

	return border
end

function DF:CreateBorderSolid (parent, size)

end

function DF:CreateBorderWithSpread(parent, alpha1, alpha2, alpha3, size, spread)
	parent.Borders = {
		Layer1 = {},
		Layer2 = {},
		Layer3 = {},
		Alpha1 = alpha1 or default_border_color1,
		Alpha2 = alpha2 or default_border_color2,
		Alpha3 = alpha3 or default_border_color3,
	}

	parent.SetBorderAlpha = SetBorderAlpha
	parent.SetBorderColor = SetBorderColor
	parent.SetLayerVisibility = SetLayerVisibility

	size = size or 1
	local minPixels = 1
	local spread = 0

	--left
	local border1 = parent:CreateTexture(nil, "background")
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetPoint(border1, "topleft", parent, "topleft", -1 + spread, 1 + (-spread), 0, 0)
	PixelUtil.SetPoint(border1, "bottomleft", parent, "bottomleft", -1 + spread, -1 + spread, 0, 0)
	PixelUtil.SetWidth (border1, size, minPixels)

	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "topleft", parent, "topleft", -2 + spread, 2 + (-spread))
	PixelUtil.SetPoint(border2, "bottomleft", parent, "bottomleft", -2 + spread, -2 + spread)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetWidth (border2, size, minPixels)

	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "topleft", parent, "topleft", -3 + spread, 3 + (-spread))
	PixelUtil.SetPoint(border3, "bottomleft", parent, "bottomleft", -3 + spread, -3 + spread)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetWidth (border3, size, minPixels)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

	--top
	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "topleft", parent, "topleft", 0 + spread, 1 + (-spread))
	PixelUtil.SetPoint(border1, "topright", parent, "topright", 1 + (-spread), 1 + (-spread))
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetHeight(border1, size, minPixels)

	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "topleft", parent, "topleft", -1 + spread, 2 + (-spread))
	PixelUtil.SetPoint(border2, "topright", parent, "topright", 2 + (-spread), 2 + (-spread))
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetHeight(border2, size, minPixels)

	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "topleft", parent, "topleft", -2 + spread, 3 + (-spread))
	PixelUtil.SetPoint(border3, "topright", parent, "topright", 3 + (-spread), 3 + (-spread))
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetHeight(border3, size, minPixels)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

	--right
	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "topright", parent, "topright", 1 + (-spread), 0 + (-spread))
	PixelUtil.SetPoint(border1, "bottomright", parent, "bottomright", 1 + (-spread), -1 + spread)
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetWidth (border1, size, minPixels)

	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "topright", parent, "topright", 2 + (-spread), 1 + (-spread))
	PixelUtil.SetPoint(border2, "bottomright", parent, "bottomright", 2 + (-spread), -2 + spread)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetWidth (border2, size, minPixels)

	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "topright", parent, "topright", 3 + (-spread), 2 + (-spread))
	PixelUtil.SetPoint(border3, "bottomright", parent, "bottomright", 3 + (-spread), -3 + spread)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetWidth (border3, size, minPixels)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

	local border1 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border1, "bottomleft", parent, "bottomleft", 0 + spread, -1 + spread)
	PixelUtil.SetPoint(border1, "bottomright", parent, "bottomright", 0 + (-spread), -1 + spread)
	border1:SetColorTexture(0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetHeight(border1, size, minPixels)

	local border2 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border2, "bottomleft", parent, "bottomleft", -1 + spread, -2 + spread)
	PixelUtil.SetPoint(border2, "bottomright", parent, "bottomright", 1 + (-spread), -2 + spread)
	border2:SetColorTexture(0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetHeight(border2, size, minPixels)

	local border3 = parent:CreateTexture(nil, "background")
	PixelUtil.SetPoint(border3, "bottomleft", parent, "bottomleft", -2 + spread, -3 + spread)
	PixelUtil.SetPoint(border3, "bottomright", parent, "bottomright", 2 + (-spread), -3 + spread)
	border3:SetColorTexture(0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetHeight(border3, size, minPixels)

	tinsert(parent.Borders.Layer1, border1)
	tinsert(parent.Borders.Layer2, border2)
	tinsert(parent.Borders.Layer3, border3)

end

function DF:ReskinSlider(slider, heightOffset)
	if (slider.slider) then
		slider.cima:SetNormalTexture([[Interface\Buttons\Arrow-Up-Up]])
		slider.cima:SetPushedTexture([[Interface\Buttons\Arrow-Up-Down]])
		slider.cima:SetDisabledTexture([[Interface\Buttons\Arrow-Up-Disabled]])
		slider.cima:GetNormalTexture():ClearAllPoints()
		slider.cima:GetPushedTexture():ClearAllPoints()
		slider.cima:GetDisabledTexture():ClearAllPoints()
		slider.cima:GetNormalTexture():SetPoint("center", slider.cima, "center", 1, 1)
		slider.cima:GetPushedTexture():SetPoint("center", slider.cima, "center", 1, 1)
		slider.cima:GetDisabledTexture():SetPoint("center", slider.cima, "center", 1, 1)
		slider.cima:SetSize(16, 16)

		slider.baixo:SetNormalTexture([[Interface\Buttons\Arrow-Down-Up]])
		slider.baixo:SetPushedTexture([[Interface\Buttons\Arrow-Down-Down]])
		slider.baixo:SetDisabledTexture([[Interface\Buttons\Arrow-Down-Disabled]])
		slider.baixo:GetNormalTexture():ClearAllPoints()
		slider.baixo:GetPushedTexture():ClearAllPoints()
		slider.baixo:GetDisabledTexture():ClearAllPoints()
		slider.baixo:GetNormalTexture():SetPoint("center", slider.baixo, "center", 1, -5)
		slider.baixo:GetPushedTexture():SetPoint("center", slider.baixo, "center", 1, -5)
		slider.baixo:GetDisabledTexture():SetPoint("center", slider.baixo, "center", 1, -5)
		slider.baixo:SetSize(16, 16)

		slider.slider:cimaPoint(0, 13)
		slider.slider:baixoPoint(0, -13)
		slider.slider.thumb:SetTexture([[Interface\AddOns\Details\images\icons2]])
		slider.slider.thumb:SetTexCoord(482/512, 492/512, 104/512, 120/512)
		slider.slider.thumb:SetSize(12, 12)
		slider.slider.thumb:SetVertexColor(0.6, 0.6, 0.6, 0.95)

	else
		--up button
		local offset = 1 --space between the scrollbox and the scrollar

		do
			local normalTexture = slider.ScrollBar.ScrollUpButton.Normal
			normalTexture:SetTexture([[Interface\Buttons\Arrow-Up-Up]])
			normalTexture:SetTexCoord(0, 1, .2, 1)

			normalTexture:SetPoint("topleft", slider.ScrollBar.ScrollUpButton, "topleft", offset, 0)
			normalTexture:SetPoint("bottomright", slider.ScrollBar.ScrollUpButton, "bottomright", offset, 0)

			local pushedTexture = slider.ScrollBar.ScrollUpButton.Pushed
			pushedTexture:SetTexture([[Interface\Buttons\Arrow-Up-Down]])
			pushedTexture:SetTexCoord(0, 1, .2, 1)

			pushedTexture:SetPoint("topleft", slider.ScrollBar.ScrollUpButton, "topleft", offset, 0)
			pushedTexture:SetPoint("bottomright", slider.ScrollBar.ScrollUpButton, "bottomright", offset, 0)

			local disabledTexture = slider.ScrollBar.ScrollUpButton.Disabled
			disabledTexture:SetTexture([[Interface\Buttons\Arrow-Up-Disabled]])
			disabledTexture:SetTexCoord(0, 1, .2, 1)
			disabledTexture:SetAlpha(.5)

			disabledTexture:SetPoint("topleft", slider.ScrollBar.ScrollUpButton, "topleft", offset, 0)
			disabledTexture:SetPoint("bottomright", slider.ScrollBar.ScrollUpButton, "bottomright", offset, 0)

			slider.ScrollBar.ScrollUpButton:SetSize(16, 16)
		end

		--down button
		do
			local normalTexture = slider.ScrollBar.ScrollDownButton.Normal
			normalTexture:SetTexture([[Interface\Buttons\Arrow-Down-Up]])
			normalTexture:SetTexCoord(0, 1, 0, .8)

			normalTexture:SetPoint("topleft", slider.ScrollBar.ScrollDownButton, "topleft", offset, -4)
			normalTexture:SetPoint("bottomright", slider.ScrollBar.ScrollDownButton, "bottomright", offset, -4)

			local pushedTexture = slider.ScrollBar.ScrollDownButton.Pushed
			pushedTexture:SetTexture([[Interface\Buttons\Arrow-Down-Down]])
			pushedTexture:SetTexCoord(0, 1, 0, .8)

			pushedTexture:SetPoint("topleft", slider.ScrollBar.ScrollDownButton, "topleft", offset, -4)
			pushedTexture:SetPoint("bottomright", slider.ScrollBar.ScrollDownButton, "bottomright", offset, -4)

			local disabledTexture = slider.ScrollBar.ScrollDownButton.Disabled
			disabledTexture:SetTexture([[Interface\Buttons\Arrow-Down-Disabled]])
			disabledTexture:SetTexCoord(0, 1, 0, .8)
			disabledTexture:SetAlpha(.5)

			disabledTexture:SetPoint("topleft", slider.ScrollBar.ScrollDownButton, "topleft", offset, -4)
			disabledTexture:SetPoint("bottomright", slider.ScrollBar.ScrollDownButton, "bottomright", offset, -4)

			slider.ScrollBar.ScrollDownButton:SetSize(16, 16)
		end

		--if the parent has a editbox, this is a code editor
		if (slider:GetParent().editbox) then
			slider.ScrollBar:SetPoint("TOPLEFT", slider, "TOPRIGHT", 12 + offset, -6)
			slider.ScrollBar:SetPoint("BOTTOMLEFT", slider, "BOTTOMRIGHT", 12 + offset, 6 + (heightOffset and heightOffset*-1 or 0))

		else
			slider.ScrollBar:SetPoint("TOPLEFT", slider, "TOPRIGHT", 6, -16)
			slider.ScrollBar:SetPoint("BOTTOMLEFT", slider, "BOTTOMRIGHT", 6, 16 + (heightOffset and heightOffset*-1 or 0))
		end

		slider.ScrollBar.ThumbTexture:SetColorTexture(.5, .5, .5, .3)
		slider.ScrollBar.ThumbTexture:SetSize(12, 8)
	end
end

function DF:GetCurrentSpec()
	local specIndex = DF.GetSpecialization()
	if (specIndex) then
		local specID = DF.GetSpecializationInfo(specIndex)
		if (specID and specID ~= 0) then
			return specID
		end
	end
end

function DF:GetCurrentSpecId()
	return DF:GetCurrentSpec()
end

local specs_per_class = {
	["DEMONHUNTER"] = {577, 581},
	["DEATHKNIGHT"] = {250, 251, 252},
	["WARRIOR"] = {71, 72, 73},
	["MAGE"] = {62, 63, 64},
	["ROGUE"] = {259, 260, 261},
	["DRUID"] = {102, 103, 104, 105},
	["HUNTER"] = {253, 254, 255},
	["SHAMAN"] = {262, 263, 254},
	["PRIEST"] = {256, 257, 258},
	["WARLOCK"] = {265, 266, 267},
	["PALADIN"] = {65, 66, 70},
	["MONK"] = {268, 269, 270},
	["EVOKER"] = {1467, 1468},
}

function DF:GetClassSpecIDs(class)
	return specs_per_class [class]
end

local dispatch_error = function(context, errortext)
	DF:Msg( (context or "<no context>") .. " |cFFFF9900error|r: " .. (errortext or "<no error given>"))
end

--safe call an external func with payload and without telling who is calling
function DF:QuickDispatch(func, ...)
	if (type(func) ~= "function") then
		return
	end

	local okay, errortext = xpcall(func, geterrorhandler(), ...)

	if (not okay) then
		--trigger an error msg
		dispatch_error(_, errortext)
		return
	end

	return true
end

function DF:Dispatch(func, ...)
	if (type(func) ~= "function") then
		return dispatch_error (_, "DF:Dispatch expect a function as parameter 1.")
	end

	local dispatchResult = {xpcall(func, geterrorhandler(), ...)}
	local okay = dispatchResult[1]

	if (not okay) then
		return nil
	end

	tremove(dispatchResult, 1)

	return unpack(dispatchResult)
end

--[=[
	DF:CoreDispatch(func, context, ...)
	safe call a function making a error window with what caused, the context and traceback of the error
	this func is only used inside the framework for sensitive calls where the func must run without errors
	@func = the function which will be called
	@context = what made the function be called
	... parameters to pass in the function call
--]=]
function DF:CoreDispatch(context, func, ...)
	if (type(func) ~= "function") then
		local stack = debugstack(2)
		local errortext = "D!Framework " .. context .. " error: invalid function to call\n====================\n" .. stack .. "\n====================\n"
		error(errortext)
	end

	local okay, result1, result2, result3, result4 = xpcall(func, geterrorhandler(), ...)

	--if (not okay) then --when using pcall
		--local stack = debugstack(2)
		--local errortext = "D!Framework (" .. context .. ") error: " .. result1 .. "\n====================\n" .. stack .. "\n====================\n"
		--error(errortext)
	--end

	return result1, result2, result3, result4
end


DF.ClassIndexToFileName = {
	[6] = "DEATHKNIGHT",
	[1] = "WARRIOR",
	[4] = "ROGUE",
	[8] = "MAGE",
	[5] = "PRIEST",
	[3] = "HUNTER",
	[9] = "WARLOCK",
	[12] = "DEMONHUNTER",
	[7] = "SHAMAN",
	[11] = "DRUID",
	[10] = "MONK",
	[2] = "PALADIN",
	[13] = "EVOKER",
}


DF.ClassFileNameToIndex = {
	["DEATHKNIGHT"] = 6,
	["WARRIOR"] = 1,
	["ROGUE"] = 4,
	["MAGE"] = 8,
	["PRIEST"] = 5,
	["HUNTER"] = 3,
	["WARLOCK"] = 9,
	["DEMONHUNTER"] = 12,
	["SHAMAN"] = 7,
	["DRUID"] = 11,
	["MONK"] = 10,
	["PALADIN"] = 2,
	["EVOKER"] = 13,
}
DF.ClassCache = {}

function DF:GetClassList()

	if (next (DF.ClassCache)) then
		return DF.ClassCache
	end

	for className, classIndex in pairs(DF.ClassFileNameToIndex) do
		local classTable = C_CreatureInfo.GetClassInfo (classIndex)
		if classTable then
			local t = {
				ID = classIndex,
				Name = classTable.className,
				Texture = [[Interface\GLUES\CHARACTERCREATE\UI-CharacterCreate-Classes]],
				TexCoord = CLASS_ICON_TCOORDS [className],
				FileString = className,
			}
			tinsert(DF.ClassCache, t)
		end
	end

	return DF.ClassCache

end

--hardcoded race list
DF.RaceList = {
	[1] = "Human",
	[2] = "Orc",
	[3] = "Dwarf",
	[4] = "NightElf",
	[5] = "Scourge",
	[6] = "Tauren",
	[7] = "Gnome",
	[8] = "Troll",
	[9] = "Goblin",
	[10] = "BloodElf",
	[11] = "Draenei",
	[22] = "Worgen",
	[24] = "Pandaren",
}

DF.AlliedRaceList = {
	[27] = "Nightborne",
	[29] = "HighmountainTauren",
	[31] = "VoidElf",
	[33] = "LightforgedDraenei",
	[35] = "ZandalariTroll",
	[36] = "KulTiran",
	[38] = "DarkIronDwarf",
	[40] = "Vulpera",
	[41] = "MagharOrc",
}

local slotIdToIcon = {
	[1] = "Interface\\ICONS\\" .. "INV_Helmet_29", --head
	[2] = "Interface\\ICONS\\" .. "INV_Jewelry_Necklace_07", --neck
	[3] = "Interface\\ICONS\\" .. "INV_Shoulder_25", --shoulder
	[5] = "Interface\\ICONS\\" .. "INV_Chest_Cloth_08", --chest
	[6] = "Interface\\ICONS\\" .. "INV_Belt_15", --waist
	[7] = "Interface\\ICONS\\" .. "INV_Pants_08", --legs
	[8] = "Interface\\ICONS\\" .. "INV_Boots_Cloth_03", --feet
	[9] = "Interface\\ICONS\\" .. "INV_Bracer_07", --wrist
	[10] = "Interface\\ICONS\\" .. "INV_Gauntlets_17", --hands
	[11] = "Interface\\ICONS\\" .. "INV_Jewelry_Ring_22", --finger 1
	[12] = "Interface\\ICONS\\" .. "INV_Jewelry_Ring_22", --finger 2
	[13] = "Interface\\ICONS\\" .. "INV_Jewelry_Talisman_07", --trinket 1
	[14] = "Interface\\ICONS\\" .. "INV_Jewelry_Talisman_07", --trinket 2
	[15] = "Interface\\ICONS\\" .. "INV_Misc_Cape_19", --back
	[16] = "Interface\\ICONS\\" .. "INV_Sword_39", --main hand
	[17] = "Interface\\ICONS\\" .. "INV_Sword_39", --off hand
}

function DF:GetArmorIconByArmorSlot(equipSlotId)
	return slotIdToIcon[equipSlotId] or ""
end


--store and return a list of character races, always return the non-localized value
DF.RaceCache = {}
function DF:GetCharacterRaceList()
	if (next (DF.RaceCache)) then
		return DF.RaceCache
	end

	for i = 1, 100 do
		local raceInfo = C_CreatureInfo.GetRaceInfo (i)
		if (raceInfo and DF.RaceList [raceInfo.raceID]) then
			tinsert(DF.RaceCache, {Name = raceInfo.raceName, FileString = raceInfo.clientFileString, ID = raceInfo.raceID})
		end

		if IS_WOW_PROJECT_MAINLINE then
			local alliedRaceInfo = C_AlliedRaces.GetRaceInfoByID (i)
			if (alliedRaceInfo and DF.AlliedRaceList [alliedRaceInfo.raceID]) then
				tinsert(DF.RaceCache, {Name = alliedRaceInfo.maleName, FileString = alliedRaceInfo.raceFileString, ID = alliedRaceInfo.raceID})
			end
		end
	end

	return DF.RaceCache
end

--get a list of talents for the current spec the player is using
--if onlySelected return an index table with only the talents the character has selected
--if onlySelectedHash return a hash table with [spelID] = true
function DF:GetCharacterTalents (onlySelected, onlySelectedHash)
	local talentList = {}

	for i = 1, 7 do
		for o = 1, 3 do
			local talentID, name, texture, selected, available = GetTalentInfo (i, o, 1)
			if (onlySelectedHash) then
				if (selected) then
					talentList [talentID] = true
					break
				end
			elseif (onlySelected) then
				if (selected) then
					tinsert(talentList, {Name = name, ID = talentID, Texture = texture, IsSelected = selected})
					break
				end
			else
				tinsert(talentList, {Name = name, ID = talentID, Texture = texture, IsSelected = selected})
			end
		end
	end

	return talentList
end

function DF:GetCharacterPvPTalents (onlySelected, onlySelectedHash)
	if (onlySelected or onlySelectedHash) then
		local talentsSelected = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
		local talentList = {}
		for _, talentID in ipairs(talentsSelected) do
			local _, talentName, texture = GetPvpTalentInfoByID (talentID)
			if (onlySelectedHash) then
				talentList [talentID] = true
			else
				tinsert(talentList, {Name = talentName, ID = talentID, Texture = texture, IsSelected = true})
			end
		end
		return talentList

	else
		local alreadyAdded = {}
		local talentList = {}
		for i = 1, 4 do --4 slots - get talents available in each one
			local slotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo (i)
			if (slotInfo) then
				for _, talentID in ipairs(slotInfo.availableTalentIDs) do
					if (not alreadyAdded [talentID]) then
						local _, talentName, texture, selected = GetPvpTalentInfoByID (talentID)
						tinsert(talentList, {Name = talentName, ID = talentID, Texture = texture, IsSelected = selected})
						alreadyAdded [talentID] = true
					end
				end
			end
		end
		return talentList
	end
end

DF.GroupTypes = {
	{Name = "Arena", ID = "arena"},
	{Name = "Battleground", ID = "pvp"},
	{Name = "Raid", ID = "raid"},
	{Name = "Dungeon", ID = "party"},
	{Name = "Scenario", ID = "scenario"},
	{Name = "Open World", ID = "none"},
}
function DF:GetGroupTypes()
	return DF.GroupTypes
end

DF.RoleTypes = {
	{Name = _G.DAMAGER, ID = "DAMAGER", Texture = _G.INLINE_DAMAGER_ICON},
	{Name = _G.HEALER, ID = "HEALER", Texture = _G.INLINE_HEALER_ICON},
	{Name = _G.TANK, ID = "TANK", Texture = _G.INLINE_TANK_ICON},
}
function DF:GetRoleTypes()
	return DF.RoleTypes
end

local roleTexcoord = {
	DAMAGER = "72:130:69:127",
	HEALER = "72:130:2:60",
	TANK = "5:63:69:127",
	NONE = "139:196:69:127",
}

local roleTextures = {
	DAMAGER = "Interface\\LFGFRAME\\UI-LFG-ICON-ROLES",
	TANK = "Interface\\LFGFRAME\\UI-LFG-ICON-ROLES",
	HEALER = "Interface\\LFGFRAME\\UI-LFG-ICON-ROLES",
	NONE = "Interface\\LFGFRAME\\UI-LFG-ICON-ROLES",
}

local roleTexcoord2 = {
	DAMAGER = {72/256, 130/256, 69/256, 127/256},
	HEALER = {72/256, 130/256, 2/256, 60/256},
	TANK = {5/256, 63/256, 69/256, 127/256},
	NONE = {139/256, 196/256, 69/256, 127/256},
}

function DF:GetRoleIconAndCoords(role)
	local texture = roleTextures[role]
	local coords = roleTexcoord2[role]
	return texture, unpack(coords)
end

function DF:AddRoleIconToText(text, role, size)
	if (role and type(role) == "string") then
		local coords = GetTexCoordsForRole(role)
		if (coords) then
			if (type(text) == "string" and role ~= "NONE") then
				size = size or 14
				text = "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. size .. ":" .. size .. ":0:0:256:256:" .. roleTexcoord[role] .. "|t " .. text
				return text
			end
		end
	end

	return text
end

function DF:GetRoleTCoordsAndTexture(roleID)
	local texture, l, r, t, b = DF:GetRoleIconAndCoords(roleID)
	return l, r, t, b, texture
end

-- TODO: maybe make this auto-generaded some day?...
DF.CLEncounterID = {
	{ID = 2423, Name = "The Tarragrue"},
	{ID = 2433, Name = "The Eye of the Jailer"},
	{ID = 2429, Name = "The Nine"},
	{ID = 2432, Name = "Remnant of Ner'zhul"},
	{ID = 2434, Name = "Soulrender Dormazain"},
	{ID = 2430, Name = "Painsmith Raznal"},
	{ID = 2436, Name = "Guardian of the First Ones"},
	{ID = 2431, Name = "Fatescribe Roh-Kalo"},
	{ID = 2422, Name = "Kel'Thuzad"},
	{ID = 2435, Name = "Sylvanas Windrunner"},
}

function DF:GetPlayerRole()
	local assignedRole = DF.UnitGroupRolesAssigned("player")
	if (assignedRole == "NONE") then
		local spec = DF.GetSpecialization()
		return spec and DF.GetSpecializationRole (spec) or "NONE"
	end
	return assignedRole
end

function DF:GetCLEncounterIDs()
	return DF.CLEncounterID
end

DF.ClassSpecs = {
	["DEMONHUNTER"] = {
		[577] = true,
		[581] = true,
	},
	["DEATHKNIGHT"] = {
		[250] = true,
		[251] = true,
		[252] = true,
	},
	["WARRIOR"] = {
		[71] = true,
		[72] = true,
		[73] = true,
	},
	["MAGE"] = {
		[62] = true,
		[63] = true,
		[64] = true,
	},
	["ROGUE"] = {
		[259] = true,
		[260] = true,
		[261] = true,
	},
	["DRUID"] = {
		[102] = true,
		[103] = true,
		[104] = true,
		[105] = true,
	},
	["HUNTER"] = {
		[253] = true,
		[254] = true,
		[255] = true,
	},
	["SHAMAN"] = {
		[262] = true,
		[263] = true,
		[264] = true,
	},
	["PRIEST"] = {
		[256] = true,
		[257] = true,
		[258] = true,
	},
	["WARLOCK"] = {
		[265] = true,
		[266] = true,
		[267] = true,
	},
	["PALADIN"] = {
		[65] = true,
		[66] = true,
		[70] = true,
	},
	["MONK"] = {
		[268] = true,
		[269] = true,
		[270] = true,
	},
	["EVOKER"] = {
		[1467] = true,
		[1468] = true,
	},
}

DF.SpecListByClass = {
	["DEMONHUNTER"] = {
		577,
		581,
	},
	["DEATHKNIGHT"] = {
		250,
		251,
		252,
	},
	["WARRIOR"] = {
		71,
		72,
		73,
	},
	["MAGE"] = {
		62,
		63,
		64,
	},
	["ROGUE"] = {
		259,
		260,
		261,
	},
	["DRUID"] = {
		102,
		103,
		104,
		105,
	},
	["HUNTER"] = {
		253,
		254,
		255,
	},
	["SHAMAN"] = {
		262,
		263,
		264,
	},
	["PRIEST"] = {
		256,
		257,
		258,
	},
	["WARLOCK"] = {
		265,
		266,
		267,
	},
	["PALADIN"] = {
		65,
		66,
		70,
	},
	["MONK"] = {
		268,
		269,
		270,
	},
	["EVOKER"] = {
		1467,
		1468,
	},
}

--given a class and a  specId, return if the specId is a spec from the class passed
function DF:IsSpecFromClass(class, specId)
	return DF.ClassSpecs[class] and DF.ClassSpecs[class][specId]
end

--return a has table where specid is the key and 'true' is the value
function DF:GetClassSpecs(class)
	return DF.ClassSpecs [class]
end

--return a numeric table with spec ids
function DF:GetSpecListFromClass(class)
	return DF.SpecListByClass [class]
end

--return a list with specIds as keys and spellId as value
function DF:GetSpellsForRangeCheck()
	return SpellRangeCheckListBySpec
end

--return a list with specIds as keys and spellId as value
function DF:GetRangeCheckSpellForSpec(specId)
	return SpellRangeCheckListBySpec[specId]
end


--key is instanceId from GetInstanceInfo()
-- /dump GetInstanceInfo()
DF.BattlegroundSizes = {
	[2245] = 15, --Deepwind Gorge
	[2106] = 10, --Warsong Gulch
	[2107] = 15, --Arathi Basin
	[566] = 15, --Eye of the Storm
	[30]  = 40,	--Alterac Valley
	[628] = 40, --Isle of Conquest
	[761] = 10, --The Battle for Gilneas
	[726] = 10, --Twin Peaks
	[727] = 10, --Silvershard Mines
	[998] = 10, --Temple of Kotmogu
	[2118] = 40, --Battle for Wintergrasp
	[1191] = 25, --Ashran
	[1803] = 10, --Seething Shore
}

function DF:GetBattlegroundSize(instanceInfoMapId)
	return DF.BattlegroundSizes[instanceInfoMapId]
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--execute range

	function DF.GetExecuteRange(unitId)
		unitId = unitId or "player"

		local classLoc, class = UnitClass(unitId)
		local spec = GetSpecialization()

		if (spec and class) then
			--prist
			if (class == "PRIEST") then
				--playing as shadow?
				local specID = GetSpecializationInfo(spec)
				if (specID and specID ~= 0) then
					if (specID == 258) then --shadow
						local _, _, _, using_SWDeath = GetTalentInfo(5, 2, 1)
						if (using_SWDeath) then
							return 0.20
						end
					end
				end

			elseif (class == "MAGE") then
				--playing fire mage?
				local specID = GetSpecializationInfo(spec)
				if (specID and specID ~= 0) then
					if (specID == 63) then --fire
						local _, _, _, using_SearingTouch = GetTalentInfo(1, 3, 1)
						if (using_SearingTouch) then
							return 0.30
						end
					end
				end

			elseif (class == "WARRIOR") then
				--is playing as a Arms warrior?
				local specID = GetSpecializationInfo(spec)
				if (specID and specID ~= 0) then

					if (specID == 71) then --arms
						local _, _, _, using_Massacre = GetTalentInfo(3, 1, 1)
						if (using_Massacre) then
							--if using massacre, execute can be used at 35% health in Arms spec
							return 0.35
						end
					end

					if (specID == 71 or specID == 72) then --arms or fury
						return 0.20
					end
				end

			elseif (class == "HUNTER") then
				local specID = GetSpecializationInfo(spec)
				if (specID and specID ~= 0) then
					if (specID == 253) then --beast mastery
						--is using killer instinct?
						local _, _, _, using_KillerInstinct = GetTalentInfo(1, 1, 1)
						if (using_KillerInstinct) then
							return 0.35
						end
					end
				end

			elseif (class == "PALADIN") then
				local specID = GetSpecializationInfo(spec)
				if (specID and specID ~= 0) then
					if (specID == 70) then --retribution paladin
						--is using hammer of wrath?
						local _, _, _, using_HammerOfWrath = GetTalentInfo(2, 3, 1)
						if (using_HammerOfWrath) then
							return 0.20
						end
					end
				end
			end
		end
	end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--delta seconds reader

if (not DetailsFrameworkDeltaTimeFrame) then
	CreateFrame("frame", "DetailsFrameworkDeltaTimeFrame", UIParent)
end

local deltaTimeFrame = DetailsFrameworkDeltaTimeFrame
deltaTimeFrame:SetScript("OnUpdate", function(self, deltaTime)
	self.deltaTime = deltaTime
end)

function GetWorldDeltaSeconds()
	return deltaTimeFrame.deltaTime
end

function DF:GetWorldDeltaSeconds()
	return deltaTimeFrame.deltaTime
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--build the global script channel for scripts communication
--send and retrieve data sent by othe users in scripts
--Usage:
--DetailsFramework:RegisterScriptComm (ID, function(sourcePlayerName, ...) end)
--DetailsFramework:SendScriptComm (ID, ...)

	local aceComm = LibStub:GetLibrary ("AceComm-3.0", true)
	local LibAceSerializer = LibStub:GetLibrary ("AceSerializer-3.0", true)
	local LibDeflate = LibStub:GetLibrary ("LibDeflate", true)

	DF.RegisteredScriptsComm = DF.RegisteredScriptsComm or {}

	function DF.OnReceiveScriptComm (...)
		local prefix, encodedString, channel, commSource = ...

		local decodedString = LibDeflate:DecodeForWoWAddonChannel (encodedString)
		if (decodedString) then
			local uncompressedString = LibDeflate:DecompressDeflate (decodedString)
			if (uncompressedString) then
				local data = {LibAceSerializer:Deserialize (uncompressedString)}
				if (data[1]) then
					local ID = data[2]
					if (ID) then
						local sourceName = data[4]
						if (Ambiguate (sourceName, "none") == commSource) then
							local func = DF.RegisteredScriptsComm [ID]
							if (func) then
								DF:MakeFunctionSecure(func)
								DF:Dispatch (func, commSource, select(5, unpack(data))) --this use xpcall
							end
						end
					end
				end
			end
		end
	end

	function DF:RegisterScriptComm (ID, func)
		if (ID) then
			if (type(func) == "function") then
				DF.RegisteredScriptsComm [ID] = func
			else
				DF.RegisteredScriptsComm [ID] = nil
			end
		end
	end

	function DF:SendScriptComm (ID, ...)
		if (DF.RegisteredScriptsComm [ID]) then
			local sourceName = UnitName ("player") .. "-" .. GetRealmName()
			local data = LibAceSerializer:Serialize (ID, UnitGUID("player"), sourceName, ...)
			data = LibDeflate:CompressDeflate (data, {level = 9})
			data = LibDeflate:EncodeForWoWAddonChannel (data)
			aceComm:SendCommMessage ("_GSC", data, "PARTY")
		end
	end

	if (aceComm and LibAceSerializer and LibDeflate) then
		aceComm:RegisterComm ("_GSC", DF.OnReceiveScriptComm)
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--debug

DF.DebugMixin = {

	debug = true,

	CheckPoint = function(self, checkPointName, ...)
		print(self:GetName(), checkPointName, ...)
	end,

	CheckVisibilityState = function(self, widget)

		self = widget or self

		local width, height = self:GetSize()
		width = floor(width)
		height = floor(height)

		local numPoints = self:GetNumPoints()

		print("shown:", self:IsShown(), "visible:", self:IsVisible(), "alpha:", self:GetAlpha(), "size:", width, height, "points:", numPoints)
	end,

	CheckStack = function(self)
		local stack = debugstack()
		Details:Dump (stack)
	end,

}

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--returns if the unit is tapped (gray health color when another player hit the unit first)
function DF:IsUnitTapDenied (unitId)
	return unitId and not UnitPlayerControlled(unitId) and UnitIsTapDenied(unitId)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--pool

do
    local get = function(self)
        local object = tremove(self.notUse, #self.notUse)
        if (object) then
            tinsert(self.inUse, object)
			if (self.onAcquire) then
				DF:QuickDispatch(self.onAcquire, object)
			end
			return object, false
        else
            --need to create the new object
            local newObject = self.newObjectFunc(self, unpack(self.payload))
            if (newObject) then
				tinsert(self.inUse, newObject)
				if (self.onAcquire) then
					DF:QuickDispatch(self.onAcquire, object)
				end
				return newObject, true
            end
        end
	end

	local get_all_inuse = function(self)
		return self.inUse;
	end

    local release = function(self, object)
        for i = #self.inUse, 1, -1 do
            if (self.inUse[i] == object) then
                tremove(self.inUse, i)
                tinsert(self.notUse, object)

				if (self.onRelease) then
					DF:QuickDispatch(self.onRelease, object)
				end
                break
            end
        end
    end

    local reset = function(self)
        for i = #self.inUse, 1, -1 do
            local object = tremove(self.inUse, i)
            tinsert(self.notUse, object)

			if (self.onReset) then
				DF:QuickDispatch(self.onReset, object)
			end
        end
	end

	--only hide objects in use, do not disable them
		local hide = function(self)
			for i = #self.inUse, 1, -1 do
				self.inUse[i]:Hide()
			end
		end

	--only show objects in use, do not enable them
		local show = function(self)
			for i = #self.inUse, 1, -1 do
				self.inUse[i]:Show()
			end
		end

	--return the amount of objects
		local getamount = function(self)
			return #self.notUse + #self.inUse, #self.notUse, #self.inUse
		end

    local poolMixin = {
		Get = get,
		GetAllInUse = get_all_inuse,
        Acquire = get,
        Release = release,
        Reset = reset,
        ReleaseAll = reset,
		Hide = hide,
		Show = show,
		GetAmount = getamount,

		SetCallbackOnRelease = function(self, func)
			self.onRelease = func
		end,

		SetOnReset = function(self, func)
			self.onReset = func
		end,
		SetCallbackOnReleaseAll = function(self, func)
			self.onReset = func
		end,

		SetOnAcquire = function(self, func)
			self.onAcquire = func
		end,
		SetCallbackOnGet = function(self, func)
			self.onAcquire = func
		end,
    }

    function DF:CreatePool(func, ...)
        local t = {}
        DetailsFramework:Mixin(t, poolMixin)

        t.inUse = {}
        t.notUse = {}
        t.newObjectFunc = func
        t.payload = {...}

        return t
	end

	--alias
	function DF:CreateObjectPool(func, ...)
		return DF:CreatePool(func, ...)
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--forbidden functions on scripts

	--these are functions which scripts cannot run due to security issues
	local forbiddenFunction = {
		--block mail, trades, action house, banks
		["C_AuctionHouse"] 	= true,
		["C_Bank"] = true,
		["C_GuildBank"] = true,
		["SetSendMailMoney"] = true,
		["SendMail"]		= true,
		["SetTradeMoney"]	= true,
		["AddTradeMoney"]	= true,
		["PickupTradeMoney"]	= true,
		["PickupPlayerMoney"]	= true,
		["AcceptTrade"]		= true,

		--frames
		["BankFrame"] 		= true,
		["TradeFrame"]		= true,
		["GuildBankFrame"] 	= true,
		["MailFrame"]		= true,
		["EnumerateFrames"] = true,

		--block run code inside code
		["RunScript"] = true,
		["securecall"] = true,
		["setfenv"] = true,
		["getfenv"] = true,
		["loadstring"] = true,
		["pcall"] = true,
		["xpcall"] = true,
		["getglobal"] = true,
		["setmetatable"] = true,
		["DevTools_DumpCommand"] = true,
		["ChatEdit_SendText"] = true,

		--avoid creating macros
		["SetBindingMacro"] = true,
		["CreateMacro"] = true,
		["EditMacro"] = true,
		["hash_SlashCmdList"] = true,
		["SlashCmdList"] = true,

		--block guild commands
		["GuildDisband"] = true,
		["GuildUninvite"] = true,

		--other things
		["C_GMTicketInfo"] = true,

		--deny messing addons with script support
		["PlaterDB"] = true,
		["_detalhes_global"] = true,
		["WeakAurasSaved"] = true,
	}

	local C_RestrictedSubFunctions = {
		["C_GuildInfo"] = {
			["RemoveFromGuild"] = true,
		},
	}

	--not in use, can't find a way to check within the environment handle
	local addonRestrictedFunctions = {
		["DetailsFramework"] = {
			["SetEnvironment"] = true,
		},

		["Plater"] = {
			["ImportScriptString"] = true,
			["db"] = true,
		},

		["WeakAuras"] = {
			["Add"] = true,
			["AddMany"] = true,
			["Delete"] = true,
			["NewAura"] = true,
		},
	}

    local C_SubFunctionsTable = {}
    for globalTableName, functionTable in pairs(C_RestrictedSubFunctions) do
        C_SubFunctionsTable [globalTableName] = {}
        for functionName, functionObject in pairs(_G[globalTableName]) do
            if (not functionTable[functionName]) then
                C_SubFunctionsTable [globalTableName][functionName] = functionObject
            end
        end
    end

	DF.DefaultSecureScriptEnvironmentHandle = {
		__index = function(env, key)

			if (forbiddenFunction[key]) then
				return nil

			elseif (key == "_G") then
				return env

			elseif (C_SubFunctionsTable[key]) then
				return C_SubFunctionsTable[key]
			end

			return _G[key]
		end
	}

	function DF:SetEnvironment(func, environmentHandle, newEnvironment)
		environmentHandle = environmentHandle or DF.DefaultSecureScriptEnvironmentHandle
		newEnvironment = newEnvironment or {}

		setmetatable(newEnvironment, environmentHandle)
		_G.setfenv(func, newEnvironment)
	end

	function DF:MakeFunctionSecure(func)
		return DF:SetEnvironment(func)
	end


-----------------------------------------------------------------------------------------------------------------------------------------------------------
