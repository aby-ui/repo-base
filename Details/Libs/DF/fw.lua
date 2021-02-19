

local dversion = 236

local major, minor = "DetailsFramework-1.0", dversion
local DF, oldminor = LibStub:NewLibrary (major, minor)

if (not DF) then
	DetailsFrameworkCanLoad = false
	return
end

DetailsFrameworkCanLoad = true
local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

local _
local _type = type
local _unpack = unpack
local upper = string.upper
local string_match = string.match
local tinsert = _G.tinsert
local abs = _G.abs
local tremove = _G.tremove

local UnitPlayerControlled = UnitPlayerControlled
local UnitIsTapDenied = UnitIsTapDenied

SMALL_NUMBER = 0.000001
ALPHA_BLEND_AMOUNT = 0.8400251

DF.dversion = dversion

DF.AuthorInfo = {
	Name = "Terciob",
	Discord = "https://discord.gg/AGSzAZX",
}

if (not PixelUtil) then
	--check if is in classic wow, if it is, build a replacement for PixelUtil
	local gameVersion = GetBuildInfo()
	if (gameVersion:match("%d") == "1") then
		PixelUtil = {
			SetWidth = function (self, width) self:SetWidth (width) end,
			SetHeight = function (self, height) self:SetHeight (height) end,
			SetSize = function (self, width, height) self:SetSize (width, height) end,
			SetPoint = function (self, ...) self:SetPoint (...) end,
		}
	end
end

function DF.IsClassicWow()
	local gameVersion = GetBuildInfo()
	if (gameVersion:match ("%d") == "1") then
		return true
	end
	return false
end

function DF.UnitGroupRolesAssigned (unitId)
	if (UnitGroupRolesAssigned) then
		return UnitGroupRolesAssigned (unitId)
	else
		--attempt to guess the role by the player spec
		
		--at the moment just return none
		return "NONE"
	end
end

--return the specialization of the player it self
function DF.GetSpecialization()
	if (GetSpecialization) then
		return GetSpecialization()
	end
	
	return nil
end

function DF.GetSpecializationInfoByID (...)
	if (GetSpecializationInfoByID) then
		return GetSpecializationInfoByID (...)
	end
	
	return nil
end

function DF.GetSpecializationInfo (...)
	if (GetSpecializationInfo) then
		return GetSpecializationInfo (...)
	end
	
	return nil
end

function DF.GetSpecializationRole (...)
	if (GetSpecializationRole) then
		return GetSpecializationRole (...)
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

if (not EJ_GetCurrentInstance) then
	
end

--> will always give a very random name for our widgets
local init_counter = math.random (1, 1000000)

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

--/dump DetailsFramework:PrintVersion()

DF.FrameWorkVersion = tostring (dversion)
function DF:PrintVersion()
	print ("Details! Framework Version:", DF.FrameWorkVersion)
end

LibStub:GetLibrary("AceTimer-3.0"):Embed (DF)

--> get the working folder
do
	local path = string.match (debugstack (1, 1, 0), "AddOns\\(.+)fw.lua")
	if (path) then
		DF.folder = "Interface\\AddOns\\" .. path
	else
		--> if not found, try to use the last valid one
		DF.folder = DF.folder or ""
	end
end

DF.debug = false

_G ["DetailsFramework"] = DF

DF.embeds = DF.embeds or {}
local embed_functions = {
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
	"ShowFeedbackPanel",
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
	"CreateFeedbackButton",
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

DF.WidgetFunctions = {
	GetCapsule = function (self)
		return self.MyObject
	end,
}

DF.table = {}

function DF:GetFrameworkFolder()
	return DF.folder
end

function DF:SetFrameworkDebugState (state)
	DF.debug = state
end

function DF:FadeFrame (frame, t)
	if (t == 0) then
		frame.hidden = false
		frame.faded = false
		frame.fading_out = false
		frame.fading_in = false
		frame:Show()
		frame:SetAlpha (1)
		
	elseif (t == 1) then
		frame.hidden = true
		frame.faded = true
		frame.fading_out = false
		frame.fading_in = false
		frame:SetAlpha (0)
		frame:Hide()
	end
end

function DF.table.find (t, value)
	for i = 1, #t do
		if (t[i] == value) then
			return i
		end
	end
end

function DF.table.addunique (t, index, value)
	if (not value) then
		value = index
		index = #t + 1
	end

	for i = 1, #t do
		if (t[i] == value) then
			return false
		end
	end
	
	tinsert (t, index, value)
	return true
end

function DF.table.reverse (t)
	local new = {}
	local index = 1
	for i = #t, 1, -1 do
		new [index] = t[i]
		index = index + 1
	end
	return new
end

--> copy from table2 to table1 overwriting values
function DF.table.copy (t1, t2)
	for key, value in pairs (t2) do 
		if (key ~= "__index") then
			if (type (value) == "table") then
				t1 [key] = t1 [key] or {}
				DF.table.copy (t1 [key], t2 [key])
			else
				t1 [key] = value
			end
		end
	end
	return t1
end

--> copy from table2 to table1 overwriting values but do not copy data that cannot be compressed
function DF.table.copytocompress (t1, t2)
	for key, value in pairs (t2) do
		print (key, value)
		if (key ~= "__index" and type(value) ~= "function") then
			if (type (value) == "table") then
				t1 [key] = t1 [key] or {}
				DF.table.copytocompress (t1 [key], t2 [key])
			else
				t1 [key] = value
			end
		end
	end
	return t1
end

--> copy values that does exist on table2 but not on table1
function DF.table.deploy (t1, t2)
	for key, value in pairs (t2) do 
		if (type (value) == "table") then
			t1 [key] = t1 [key] or {}
			DF.table.deploy (t1 [key], t2 [key])
		elseif (t1 [key] == nil) then
			t1 [key] = value
		end
	end
	return t1
end

function DF.table.dump (t, s, deep)
	s = s or ""
	deep = deep or 0
	local space = ""
	for i = 1, deep do
		space = space .. "   "
	end
	
	for key, value in pairs (t) do
		local tpe = _type (value)
		
		if (type (key) == "function") then
			key = "#function#"
		elseif (type (key) == "table") then
			key = "#table#"
		end	
		
		if (type (key) ~= "string" and type (key) ~= "number") then
			key = "unknown?"
		end
		
		if (tpe == "table") then
			if (type (key) == "number") then
				s = s .. space .. "[" .. key .. "] = |cFFa9ffa9 {|r\n"
			else
				s = s .. space .. "[\"" .. key .. "\"] = |cFFa9ffa9 {|r\n"
			end
			s = s .. DF.table.dump (value, nil, deep+1)
			s = s .. space .. "|cFFa9ffa9},|r\n"
			
		elseif (tpe == "string") then
			s = s .. space .. "[\"" .. key .. "\"] = \"|cFFfff1c1" .. value .. "|r\",\n"
			
		elseif (tpe == "number") then
			s = s .. space .. "[\"" .. key .. "\"] = |cFFffc1f4" .. value .. "|r,\n"
			
		elseif (tpe == "function") then
			s = s .. space .. "[\"" .. key .. "\"] = function()end,\n"
			
		elseif (tpe == "boolean") then
			s = s .. space .. "[\"" .. key .. "\"] = |cFF99d0ff" .. (value and "true" or "false") .. "|r,\n"
		end
	end
	
	return s
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
		--> return korean as default (if the language is western)
		return "천", "만", "억"
	end
end

if (symbol_1K) then
	function DF.FormatNumber (numero)
		if (numero > 99999999) then
			return format ("%.2f", numero/100000000) .. symbol_1B
		elseif (numero > 999999) then
			return format ("%.2f", numero/10000) .. symbol_10K
		elseif (numero > 99999) then
			return floor (numero/10000) .. symbol_10K
		elseif (numero > 9999) then
			return format ("%.1f", (numero/10000)) .. symbol_10K
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. symbol_1K
		end
		return format ("%.1f", numero)
	end
else
	function DF.FormatNumber (numero)
		if (numero > 999999999) then
			return format ("%.2f", numero/1000000000) .. "B"
		elseif (numero > 999999) then
			return format ("%.2f", numero/1000000) .. "M"
		elseif (numero > 99999) then
			return floor (numero/1000) .. "K"
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. "K"
		end
		return floor (numero)
	end
end

function DF:CommaValue (value)
	if (not value) then 
		return "0" 
	end
	
	value = floor (value)
	
	if (value == 0) then
		return "0"
	end
	
	--source http://richard.warburton.it
	local left, num, right = string_match (value, '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub ('(%d%d%d)','%1,'):reverse()) .. right
end

function DF:GroupIterator (func, ...)
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			DF:QuickDispatch (func, "raid" .. i, ...)
		end
	
	elseif (IsInGroup()) then
		for i = 1, GetNumGroupMembers() - 1 do
			DF:QuickDispatch (func, "party" .. i, ...)
		end
		DF:QuickDispatch (func, "player", ...)
	
	else
		DF:QuickDispatch (func, "player", ...)
	end
end

function DF:IntegerToTimer (value)
	return "" .. floor (value/60) .. ":" .. format ("%02.f", value%60)
end

function DF:Embed (target)
	for k, v in pairs (embed_functions) do
		target[v] = self[v]
	end
	self.embeds [target] = true
	return target
end

function DF:RemoveRealmName (name)
	return name:gsub (("%-.*"), "")
end

function DF:RemoveRealName (name)
	return name:gsub (("%-.*"), "")
end

function DF:SetFontSize (fontString, ...)
	local fonte, _, flags = fontString:GetFont()
	fontString:SetFont (fonte, max (...), flags)
end
function DF:SetFontFace (fontString, fontface)
	local font = SharedMedia:Fetch ("font", fontface, true)
	if (font) then
		fontface = font
	end

	local _, size, flags = fontString:GetFont()
	fontString:SetFont (fontface, size, flags)
end
function DF:SetFontColor (fontString, r, g, b, a)
	r, g, b, a = DF:ParseColors (r, g, b, a)
	fontString:SetTextColor (r, g, b, a)
end

function DF:SetFontShadow (fontString, r, g, b, a, x, y)
	r, g, b, a = DF:ParseColors (r, g, b, a)
	fontString:SetShadowColor (r, g, b, a)

	local offSetX, offSetY = fontString:GetShadowOffset()
	x = x or offSetX
	y = y or offSetY
	
	fontString:SetShadowOffset (x, y)
end

function DF:AddClassColorToText (text, class)
	if (type (class) ~= "string") then
		return DF:RemoveRealName (text)
		
	elseif (class == "UNKNOW" or class == "PET") then
		return DF:RemoveRealName (text)
	end
	
	local color = RAID_CLASS_COLORS [class]
	if (color) then
		text = "|c" .. color.colorStr .. DF:RemoveRealName (text) .. "|r"
	else
		return DF:RemoveRealName (text)
	end
	
	return text
end

function DF:GetFontSize (fontString)
	local _, size = fontString:GetFont()
	return size
end
function DF:GetFontFace (fontString)
	local fontface = fontString:GetFont()
	return fontface
end

local ValidOutlines = {
	["NONE"] = true,
	["MONOCHROME"] = true,
	["OUTLINE"] = true,
	["THICKOUTLINE"] = true,
}
function DF:SetFontOutline (fontString, outline)
	local fonte, size = fontString:GetFont()
	if (outline) then
		if (ValidOutlines [outline]) then
			outline = outline
		elseif (_type (outline) == "boolean" and outline) then
			outline = "OUTLINE"
		elseif (outline == 1) then
			outline = "OUTLINE"
		elseif (outline == 2) then
			outline = "THICKOUTLINE"
		end
	end

	fontString:SetFont (fonte, size, outline)
end

function DF:Trim (s) --hello name conventions!
	return DF:trim (s)
end

function DF:trim (s)
	local from = s:match"^%s*()"
	return from > #s and "" or s:match(".*%S", from)
end

function DF:TruncateText (fontString, maxWidth)
	local text = fontString:GetText()
	
	while (fontString:GetStringWidth() > maxWidth) do
		text = strsub (text, 1, #text - 1)
		fontString:SetText (text)
		if (string.len (text) <= 1) then
			break
		end
	end
	
	text = DF:CleanTruncateUTF8String(text)
	fontString:SetText (text)
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

function DF:Msg (msg, ...)
	print ("|cFFFFFFAA" .. (self.__name or "FW Msg:") .. "|r ", msg, ...)
end

function DF:GetNpcIdFromGuid (guid)
	local NpcId = select ( 6, strsplit ( "-", guid ) )
	if (NpcId) then
		return tonumber ( NpcId )
	end
	return 0
end

function DF.SortOrder1 (t1, t2)
	return t1[1] > t2[1]
end
function DF.SortOrder2 (t1, t2)
	return t1[2] > t2[2]
end
function DF.SortOrder3 (t1, t2)
	return t1[3] > t2[3]
end
function DF.SortOrder1R (t1, t2)
	return t1[1] < t2[1]
end
function DF.SortOrder2R (t1, t2)
	return t1[2] < t2[2]
end
function DF.SortOrder3R (t1, t2)
	return t1[3] < t2[3]
end

local onFinish = function (self)
	if (self.showWhenDone) then
		self.frame:SetAlpha (1)
	else
		self.frame:SetAlpha (0)
		self.frame:Hide()
	end
	
	if (self.onFinishFunc) then
		self:onFinishFunc (self.frame)
	end
end

local stop = function (self)
	local FlashAnimation = self.FlashAnimation
	FlashAnimation:Stop()
end

local flash = function (self, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, loopType)
	
	local FlashAnimation = self.FlashAnimation
	
	local fadeIn = FlashAnimation.fadeIn
	local fadeOut = FlashAnimation.fadeOut
	
	fadeIn:Stop()
	fadeOut:Stop()

	fadeIn:SetDuration (fadeInTime or 1)
	fadeIn:SetEndDelay (flashInHoldTime or 0)
	
	fadeOut:SetDuration (fadeOutTime or 1)
	fadeOut:SetEndDelay (flashOutHoldTime or 0)

	FlashAnimation.duration = flashDuration
	FlashAnimation.loopTime = FlashAnimation:GetDuration()
	FlashAnimation.finishAt = GetTime() + flashDuration
	FlashAnimation.showWhenDone = showWhenDone
	
	FlashAnimation:SetLooping (loopType or "REPEAT")
	
	self:Show()
	self:SetAlpha (0)
	FlashAnimation:Play()
end

function DF:CreateFlashAnimation (frame, onFinishFunc, onLoopFunc)
	local FlashAnimation = frame:CreateAnimationGroup() 
	
	FlashAnimation.fadeOut = FlashAnimation:CreateAnimation ("Alpha") --> fade out anime
	FlashAnimation.fadeOut:SetOrder (1)
	FlashAnimation.fadeOut:SetFromAlpha (0)
	FlashAnimation.fadeOut:SetToAlpha (1)
	
	FlashAnimation.fadeIn = FlashAnimation:CreateAnimation ("Alpha") --> fade in anime
	FlashAnimation.fadeIn:SetOrder (2)
	FlashAnimation.fadeIn:SetFromAlpha (1)
	FlashAnimation.fadeIn:SetToAlpha (0)
	
	frame.FlashAnimation = FlashAnimation
	FlashAnimation.frame = frame
	FlashAnimation.onFinishFunc = onFinishFunc
	
	FlashAnimation:SetScript ("OnLoop", onLoopFunc)
	FlashAnimation:SetScript ("OnFinished", onFinish)
	
	frame.Flash = flash
	frame.Stop = stop
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> points

	function DF:CheckPoints (v1, v2, v3, v4, v5, object)

		if (not v1 and not v2) then
			return "topleft", object.widget:GetParent(), "topleft", 0, 0
		end
		
		if (_type (v1) == "string") then
			local frameGlobal = _G [v1]
			if (frameGlobal and type (frameGlobal) == "table" and frameGlobal.GetObjectType) then
				return DF:CheckPoints (frameGlobal, v2, v3, v4, v5, object)
			end
			
		elseif (_type (v2) == "string") then
			local frameGlobal = _G [v2]
			if (frameGlobal and type (frameGlobal) == "table" and frameGlobal.GetObjectType) then
				return DF:CheckPoints (v1, frameGlobal, v3, v4, v5, object)
			end
		end
		
		if (_type (v1) == "string" and _type (v2) == "table") then --> :setpoint ("left", frame, _, _, _)
			if (not v3 or _type (v3) == "number") then --> :setpoint ("left", frame, 10, 10)
				v1, v2, v3, v4, v5 = v1, v2, v1, v3, v4
			end
			
		elseif (_type (v1) == "string" and _type (v2) == "number") then --> :setpoint ("topleft", x, y)
			v1, v2, v3, v4, v5 = v1, object.widget:GetParent(), v1, v2, v3
			
		elseif (_type (v1) == "number") then --> :setpoint (x, y) 
			v1, v2, v3, v4, v5 = "topleft", object.widget:GetParent(), "topleft", v1, v2

		elseif (_type (v1) == "table") then --> :setpoint (frame, x, y)
			v1, v2, v3, v4, v5 = "topleft", v1, "topleft", v2, v3
			
		end
		
		if (not v2) then
			v2 = object.widget:GetParent()
		elseif (v2.dframework) then
			v2 = v2.widget
		end
		
		return v1 or "topleft", v2, v3 or "topleft", v4 or 0, v5 or 0
	end
	
	local anchoring_functions = {
		function (frame, anchorTo, offSetX, offSetY) --> 1 TOP LEFT
			frame:ClearAllPoints()
			frame:SetPoint ("bottomleft", anchorTo, "topleft", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 2 LEFT
			frame:ClearAllPoints()
			frame:SetPoint ("right", anchorTo, "left", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 3 BOTTOM LEFT
			frame:ClearAllPoints()
			frame:SetPoint ("topleft", anchorTo, "bottomleft", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 4 BOTTOM
			frame:ClearAllPoints()
			frame:SetPoint ("top", anchorTo, "bottom", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 5 BOTTOM RIGHT
			frame:ClearAllPoints()
			frame:SetPoint ("topright", anchorTo, "bottomright", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 6 RIGHT
			frame:ClearAllPoints()
			frame:SetPoint ("left", anchorTo, "right", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 7 TOP RIGHT
			frame:ClearAllPoints()
			frame:SetPoint ("bottomright", anchorTo, "topright", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 8 TOP
			frame:ClearAllPoints()
			frame:SetPoint ("bottom", anchorTo, "top", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 9 CENTER
			frame:ClearAllPoints()
			frame:SetPoint ("center", anchorTo, "center", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 10
			frame:ClearAllPoints()
			frame:SetPoint ("left", anchorTo, "left", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 11
			frame:ClearAllPoints()
			frame:SetPoint ("right", anchorTo, "right", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 12
			frame:ClearAllPoints()
			frame:SetPoint ("top", anchorTo, "top", offSetX, offSetY)
		end,
		
		function (frame, anchorTo, offSetX, offSetY) --> 13
			frame:ClearAllPoints()
			frame:SetPoint ("bottom", anchorTo, "bottom", offSetX, offSetY)
		end
	}

	function DF:SetAnchor (widget, config, anchorTo)
		anchorTo = anchorTo or widget:GetParent()
		anchoring_functions [config.side] (widget, anchorTo, config.x, config.y)
	end	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> colors

	function DF:NewColor (_colorname, _colortable, _green, _blue, _alpha)
		assert (_type (_colorname) == "string", "NewColor: colorname must be a string.")
		assert (not DF.alias_text_colors [_colorname], "NewColor: colorname already exists.")

		if (_type (_colortable) == "table") then
			if (_colortable[1] and _colortable[2] and _colortable[3]) then
				_colortable[4] = _colortable[4] or 1
				DF.alias_text_colors [_colorname] = _colortable
			else
				error ("invalid color table.")
			end
		elseif (_colortable and _green and _blue) then
			_alpha = _alpha or 1
			DF.alias_text_colors [_colorname] = {_colortable, _green, _blue, _alpha}
		else
			error ("invalid parameter.")
		end
		
		return true
	end
	
	local colorTableMixin = {
		GetColor = function (self)
			return self.r, self.g, self.b, self.a
		end,
		
		SetColor = function (self, r, g, b, a)
			r, g, b, a = DF:ParseColors (r, g, b, a)
			self.r = r or self.r
			self.g = g or self.g
			self.b = b or self.b
			self.a = a or self.a
		end,
		
		IsColorTable = true,
	}
	
	function DF:CreateColorTable (r, g, b, a)
		local t  = {
			r = r or 1, 
			g = g or 1, 
			b = b or 1, 
			a = a or 1,
		}
		DF:Mixin (t, colorTableMixin)
		return t
	end

	function DF:IsHtmlColor (color)
		return DF.alias_text_colors [color]
	end

	local tn = tonumber
	function DF:ParseColors (_arg1, _arg2, _arg3, _arg4)
		if (_type (_arg1) == "table") then
			if (_arg1.IsColorTable) then
				return _arg1:GetColor()
				
			elseif (not _arg1[1] and _arg1.r) then
				_arg1, _arg2, _arg3, _arg4 = _arg1.r, _arg1.g, _arg1.b, _arg1.a
				
			else
				_arg1, _arg2, _arg3, _arg4 = _unpack (_arg1)
			end
		
		elseif (_type (_arg1) == "string") then
		
			if (string.find (_arg1, "#")) then
				_arg1 = _arg1:gsub ("#","")
				if (string.len (_arg1) == 8) then --alpha
					_arg1, _arg2, _arg3, _arg4 = tn ("0x" .. _arg1:sub (3, 4))/255, tn ("0x" .. _arg1:sub (5, 6))/255, tn ("0x" .. _arg1:sub (7, 8))/255, tn ("0x" .. _arg1:sub (1, 2))/255
				else
					_arg1, _arg2, _arg3, _arg4 = tn ("0x" .. _arg1:sub (1, 2))/255, tn ("0x" .. _arg1:sub (3, 4))/255, tn ("0x" .. _arg1:sub (5, 6))/255, 1
				end
			
			else
				local color = DF.alias_text_colors [_arg1]
				if (color) then
					_arg1, _arg2, _arg3, _arg4 = _unpack (color)
				else
					_arg1, _arg2, _arg3, _arg4 = _unpack (DF.alias_text_colors.none)
				end
			end
		end
		
		if (not _arg1) then
			_arg1 = 1
		end
		if (not _arg2) then
			_arg2 = 1
		end
		if (not _arg3) then
			_arg3 = 1
		end
		if (not _arg4) then
			_arg4 = 1
		end
		
		return _arg1, _arg2, _arg3, _arg4
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> menus

	local disable_on_combat = {}

	local getMenuWidgetVolative = function(parent, widgetType, indexTable)

		local widget

		if (widgetType == "label") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			if (not widget) then
				widget = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType], "overlay")
				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)
			end

			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "dropdown") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			
			if (not widget) then
				widget = DF:CreateDropDown (parent, function() return {} end, nil, 140, 18, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widget.hasLabel = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")
				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)

			else
				widget:ClearHooks()
				widget.hasLabel.text = ""
			end

			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "switch") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]

			if (not widget) then
				widget = DF:CreateSwitch (parent, nil, true, 20, 20, nil, nil, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widget.hasLabel = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)
			else
				widget:ClearHooks()
			end

			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "slider") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			
			if (not widget) then
				widget = DF:CreateSlider (parent, 140, 20, 1, 2, 1, 1, false, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widget.hasLabel = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)
			else
				widget:ClearHooks()
			end

			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "color") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			
			if (not widget) then
				widget = DF:CreateColorPickButton (parent, "$parentWidget" .. widgetType .. indexTable[widgetType], nil, function()end, 1)
				widget.hasLabel = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)
			else
				widget:ClearHooks()
			end

			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "button") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			
			if (not widget) then
				widget = DF:CreateButton (parent, function()end, 120, 18, "", nil, nil, nil, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widget.hasLabel = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)
			else
				widget:ClearHooks()
			end

			indexTable[widgetType] = indexTable[widgetType] + 1

		elseif (widgetType == "textentry") then
			widget = parent.widget_list_by_type[widgetType][indexTable[widgetType]]
			
			if (not widget) then
				widget = DF:CreateTextEntry (parent, function()end, 120, 18, nil, "$parentWidget" .. widgetType .. indexTable[widgetType])
				widget.hasLabel = DF:CreateLabel (parent, "", 10, "white", "", nil, "$parentWidget" .. widgetType .. indexTable[widgetType] .. "label", "overlay")

				tinsert(parent.widget_list, widget)
				tinsert(parent.widget_list_by_type[widgetType], widget)
			else
				widget:ClearHooks()
			end

			indexTable[widgetType] = indexTable[widgetType] + 1
		end

		--if the widget is inside the no combat table, remove it
		for i = 1, #disable_on_combat do
			if (disable_on_combat[i] == widget) then
				tremove(disable_on_combat, i)
				break
			end
		end

		return widget
	end

	--volatile menu can be called several times, each time all settings are reset and a new menu is built using the same widgets
	function DF:BuildMenuVolatile (parent, menu, x_offset, y_offset, height, use_two_points, text_template, dropdown_template, switch_template, switch_is_box, slider_template, button_template, value_change_hook)
		
		if (not parent.widget_list) then
			DF:SetAsOptionsPanel (parent)
		end
		DF:ClearOptionsPanel(parent)

		local cur_x = x_offset
		local cur_y = y_offset
		local max_x = 0

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

		height = abs ((height or parent:GetHeight()) - abs (y_offset) + 20)
		height = height*-1

		for index, widget_table in ipairs(menu) do

			local widget_created
			if (latestInlineWidget) then
				if (not widget_table.inline) then
					latestInlineWidget = nil
					cur_y = cur_y - 20
				end
			end

			if (not widget_table.novolatile) then

				--step a line
				if (widget_table.type == "blank" or widget_table.type == "space") then
					-- do nothing

				elseif (widget_table.type == "label" or widget_table.type == "text") then

					local label = getMenuWidgetVolative(parent, "label", widgetIndexes)
					widget_created = label

					label.text = widget_table.get() or widget_table.text or ""
					label.color = widget_table.color

					if (widget_table.font) then
						label.fontface = widget_table.font
					end

					if (widget_table.text_template or text_template) then
						label:SetTemplate(widget_table.text_template or text_template)
					else
						label.fontsize = widget_table.size or 10
					end

					label._get = widget_table.get
					label.widget_type = "label"
					label:ClearAllPoints()
					label:SetPoint (cur_x, cur_y)

					if (widget_table.id) then
						parent.widgetids [widget_table.id] = label
					end

				--dropdowns
				elseif (widget_table.type == "select" or widget_table.type == "dropdown") then

					local dropdown = getMenuWidgetVolative(parent, "dropdown", widgetIndexes)
					widget_created = dropdown

					dropdown:SetFunction(widget_table.values)
					dropdown:Refresh()
					dropdown:Select (widget_table.get())
					dropdown:SetTemplate (dropdown_template)

					dropdown.tooltip = widget_table.desc
					dropdown._get = widget_table.get
					dropdown.widget_type = "select"


					dropdown.hasLabel.text = widget_table.name .. (use_two_points and ": " or "")
					dropdown.hasLabel:SetTemplate(widget_table.text_template or text_template)
					dropdown:ClearAllPoints()
					dropdown:SetPoint ("left", dropdown.hasLabel, "right", 2)
					dropdown.hasLabel:ClearAllPoints()
					dropdown.hasLabel:SetPoint (cur_x, cur_y)

					--> global callback
					if (value_change_hook) then
						dropdown:SetHook ("OnOptionSelected", value_change_hook)
					end
					
					--> hook list (hook list is wiped when getting the widget)
					if (widget_table.hooks) then
						for hookName, hookFunc in pairs (widget_table.hooks) do
							dropdown:SetHook (hookName, hookFunc)
						end
					end

					if (widget_table.id) then
						parent.widgetids [widget_table.id] = dropdown
					end
					
					local size = dropdown.hasLabel.widget:GetStringWidth() + 140 + 4
					if (size > max_x) then
						max_x = size
					end

				--switchs
				elseif (widget_table.type == "toggle" or widget_table.type == "switch") then

					local switch = getMenuWidgetVolative(parent, "switch", widgetIndexes)
					widget_created = switch

					switch:SetValue(widget_table.get())
					switch:SetTemplate(switch_template)
					switch:SetAsCheckBox() --it's always a checkbox on volatile menu

					switch.tooltip = widget_table.desc
					switch._get = widget_table.get
					switch.widget_type = "toggle"
					switch.OnSwitch = widget_table.set
					
					if (value_change_hook) then
						switch:SetHook ("OnSwitch", value_change_hook)
					end
					
					--> hook list
					if (widget_table.hooks) then
						for hookName, hookFunc in pairs (widget_table.hooks) do
							switch:SetHook (hookName, hookFunc)
						end
					end

					if (widget_table.width) then
						switch:SetWidth(widget_table.width)
					end
					if (widget_table.height) then
						switch:SetHeight(widget_table.height)
					end

					switch.hasLabel.text = widget_table.name .. (use_two_points and ": " or "")
					switch.hasLabel:SetTemplate(widget_table.text_template or text_template)

					switch:ClearAllPoints()
					switch.hasLabel:ClearAllPoints()

					if (widget_table.boxfirst) then
						switch:SetPoint (cur_x, cur_y)
						switch.hasLabel:SetPoint ("left", switch, "right", 2)
					else
						switch.hasLabel:SetPoint (cur_x, cur_y)
						switch:SetPoint ("left", switch.hasLabel, "right", 2)
					end

					if (widget_table.id) then
						parent.widgetids [widget_table.id] = switch
					end
					
					local size = switch.hasLabel:GetStringWidth() + 60 + 4
					if (size > max_x) then
						max_x = size
					end

				--slider
				elseif (widget_table.type == "range" or widget_table.type == "slider") then

					local slider = getMenuWidgetVolative(parent, "slider", widgetIndexes)
					widget_created = slider

					if (widget_table.usedecimals) then
						slider.slider:SetValueStep (0.01)
					else
						slider.slider:SetValueStep (widget_table.step)
					end
					slider.useDecimals = widget_table.usedecimals

					slider.slider:SetMinMaxValues (widget_table.min, widget_table.max)
					slider.slider:SetValue (widget_table.get())
					slider.ivalue = slider.slider:GetValue()

					slider:SetTemplate(slider_template)

					slider.tooltip = widget_table.desc
					slider._get = widget_table.get
					slider.widget_type = "range"
					slider:SetHook ("OnValueChange", widget_table.set)

					if (value_change_hook) then
						slider:SetHook ("OnValueChange", value_change_hook)
					end
					
					if (widget_table.thumbscale) then
						slider:SetThumbSize (slider.thumb.originalWidth * widget_table.thumbscale, nil)
					else
						slider:SetThumbSize (slider.thumb.originalWidth * 1.3, nil)
					end

					--> hook list
					if (widget_table.hooks) then
						for hookName, hookFunc in pairs (widget_table.hooks) do
							slider:SetHook (hookName, hookFunc)
						end
					end

					slider.hasLabel.text = widget_table.name .. (use_two_points and ": " or "")
					slider.hasLabel:SetTemplate(widget_table.text_template or text_template)
					
					slider:SetPoint ("left", slider.hasLabel, "right", 2)
					slider.hasLabel:SetPoint (cur_x, cur_y)
					
					if (widget_table.id) then
						parent.widgetids [widget_table.id] = slider
					end

					local size = slider.hasLabel:GetStringWidth() + 140 + 6
					if (size > max_x) then
						max_x = size
					end

				--color
				elseif (widget_table.type == "color" or widget_table.type == "color") then

					local colorpick = getMenuWidgetVolative(parent, "color", widgetIndexes)
					widget_created = colorpick

					colorpick.color_callback = widget_table.set --callback
					colorpick:SetTemplate(button_template)

					colorpick.tooltip = widget_table.desc
					colorpick._get = widget_table.get
					colorpick.widget_type = "color"

					local default_value, g, b, a = widget_table.get()
					if (type (default_value) == "table") then
						colorpick:SetColor (unpack (default_value))
					else
						colorpick:SetColor (default_value, g, b, a)
					end
					
					if (value_change_hook) then
						colorpick:SetHook ("OnColorChanged", value_change_hook)
					end
					
					--> hook list
					if (widget_table.hooks) then
						for hookName, hookFunc in pairs (widget_table.hooks) do
							colorpick:SetHook (hookName, hookFunc)
						end
					end

					colorpick.hasLabel.text = widget_table.name .. (use_two_points and ": " or "")
					colorpick.hasLabel:SetTemplate(widget_table.text_template or text_template)
					
					colorpick:SetPoint ("left", colorpick.hasLabel, "right", 2)
					colorpick.hasLabel:SetPoint (cur_x, cur_y)
					
					if (widget_table.id) then
						parent.widgetids [widget_table.id] = colorpick
					end

					local size = colorpick.hasLabel:GetStringWidth() + 60 + 4
					if (size > max_x) then
						max_x = size
					end

				--button
				elseif (widget_table.type == "execute" or widget_table.type == "button") then
					
					local button = getMenuWidgetVolative(parent, "button", widgetIndexes)
					widget_created = button

					button:SetTemplate(button_template)
					button:SetSize(widget_table.width or 120, widget_table.height or 18)
					button:SetClickFunction(widget_table.func, widget_table.param1, widget_table.param2)

					local textTemplate = widget_table.text_template or text_template or DF.font_templates ["ORANGE_FONT_TEMPLATE"]
					button.textcolor = textTemplate.color
					button.textfont = textTemplate.font
					button.textsize = textTemplate.size
					button.text = widget_table.name

					if (widget_table.inline) then
						if (latestInlineWidget) then
							button:SetPoint ("left", latestInlineWidget, "right", 2, 0)
							latestInlineWidget = button
						else
							button:SetPoint (cur_x, cur_y)
							latestInlineWidget = button
						end
					else
						button:SetPoint (cur_x, cur_y)
					end

					button.tooltip = widget_table.desc
					button.widget_type = "execute"
					
					--> execute doesn't trigger global callback
					
					--> hook list
					if (widget_table.hooks) then
						for hookName, hookFunc in pairs (widget_table.hooks) do
							button:SetHook (hookName, hookFunc)
						end
					end

					if (widget_table.width) then
						button:SetWidth(widget_table.width)
					end
					if (widget_table.height) then
						button:SetHeight(widget_table.height)
					end

					if (widget_table.id) then
						parent.widgetids [widget_table.id] = button
					end
					
					local size = button:GetWidth() + 4
					if (size > max_x) then
						max_x = size
					end

				--textentry
				elseif (widget_table.type == "textentry") then

					local textentry = getMenuWidgetVolative(parent, "textentry", widgetIndexes)
					widget_created = textentry

					textentry:SetCommitFunction(widget_table.func or widget_table.set)
					textentry:SetTemplate(widget_table.template or widget_table.button_template or button_template)
					textentry:SetSize(widget_table.width or 120, widget_table.height or 18)

					textentry.tooltip = widget_table.desc
					textentry.text = widget_table.get()
					textentry._get = widget_table.get
					textentry.widget_type = "textentry"
					textentry:SetHook ("OnEnterPressed", widget_table.func or widget_table.set)
					textentry:SetHook ("OnEditFocusLost", widget_table.func or widget_table.set)

					textentry.hasLabel.text = widget_table.name .. (use_two_points and ": " or "")
					textentry.hasLabel:SetTemplate(widget_table.text_template or text_template)
					textentry:SetPoint ("left", textentry.hasLabel, "right", 2)
					textentry.hasLabel:SetPoint (cur_x, cur_y)

					--> text entry doesn't trigger global callback
					
					--> hook list
					if (widget_table.hooks) then
						for hookName, hookFunc in pairs (widget_table.hooks) do
							textentry:SetHook (hookName, hookFunc)
						end
					end

					if (widget_table.id) then
						parent.widgetids [widget_table.id] = textentry
					end
					
					local size = textentry.hasLabel:GetStringWidth() + 60 + 4
					if (size > max_x) then
						max_x = size
					end

				end --end loop

				if (widget_table.nocombat) then
					tinsert (disable_on_combat, widget_created)
				end
			
				if (not widget_table.inline) then
					if (widget_table.spacement) then
						cur_y = cur_y - 30
					else
						cur_y = cur_y - 20
					end
				end
				
				if (widget_table.type == "breakline" or cur_y < height) then
					cur_y = y_offset
					cur_x = cur_x + max_x + 30
					line_widgets_created = 0
					max_x = 0
				end

				if widget_created then
					widget_created:Show()
				end
			end
		end

		DF.RefreshUnsafeOptionsWidgets()
	end

	function DF:BuildMenu (parent, menu, x_offset, y_offset, height, use_two_points, text_template, dropdown_template, switch_template, switch_is_box, slider_template, button_template, value_change_hook)
		
		if (not parent.widget_list) then
			DF:SetAsOptionsPanel (parent)
		end
		
		local cur_x = x_offset
		local cur_y = y_offset
		local max_x = 0
		local line_widgets_created = 0 --how many widgets has been created on this line loop pass
		
		local latestInlineWidget

		height = abs ((height or parent:GetHeight()) - abs (y_offset) + 20)
		height = height*-1
		
		for index, widget_table in ipairs (menu) do
		
			local widget_created
			if (latestInlineWidget) then
				if (not widget_table.inline) then
					latestInlineWidget = nil
					cur_y = cur_y - 28
				end
			end
		
			if (widget_table.type == "blank" or widget_table.type == "space") then
				-- do nothing

			elseif (widget_table.type == "label" or widget_table.type == "text") then
				local label = DF:CreateLabel (parent, widget_table.get() or widget_table.text, widget_table.text_template or text_template or widget_table.size, widget_table.color, widget_table.font, nil, "$parentWidget" .. index, "overlay")
				label._get = widget_table.get
				label.widget_type = "label"
				label:SetPoint (cur_x, cur_y)

				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, label)
				tinsert (parent.widget_list_by_type.label, label)

				line_widgets_created = line_widgets_created + 1

				if (widget_table.id) then
					parent.widgetids [widget_table.id] = label
				end
			
			elseif (widget_table.type == "select" or widget_table.type == "dropdown") then
				local dropdown = DF:NewDropDown (parent, nil, "$parentWidget" .. index, nil, 140, 18, widget_table.values, widget_table.get(), dropdown_template)
				dropdown.tooltip = widget_table.desc
				dropdown._get = widget_table.get
				dropdown.widget_type = "select"

				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				dropdown:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				dropdown.hasLabel = label
				
				--> global callback
				if (value_change_hook) then
					dropdown:SetHook ("OnOptionSelected", value_change_hook)
				end
				
				--> hook list
				if (widget_table.hooks) then
					for hookName, hookFunc in pairs (widget_table.hooks) do
						dropdown:SetHook (hookName, hookFunc)
					end
				end

				if (widget_table.id) then
					parent.widgetids [widget_table.id] = dropdown
				end
				
				local size = label.widget:GetStringWidth() + 140 + 4
				if (size > max_x) then
					max_x = size
				end
				
				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, dropdown)
				tinsert (parent.widget_list_by_type.dropdown, dropdown)

				widget_created = dropdown
				line_widgets_created = line_widgets_created + 1
				
			elseif (widget_table.type == "toggle" or widget_table.type == "switch") then
				local switch = DF:NewSwitch (parent, nil, "$parentWidget" .. index, nil, 60, 20, nil, nil, widget_table.get(), nil, nil, nil, nil, switch_template)
				switch.tooltip = widget_table.desc
				switch._get = widget_table.get
				switch.widget_type = "toggle"
				switch.OnSwitch = widget_table.set
				
				if (switch_is_box) then
					switch:SetAsCheckBox()
				end
				
				if (value_change_hook) then
					switch:SetHook ("OnSwitch", value_change_hook)
				end
				
				--> hook list
				if (widget_table.hooks) then
					for hookName, hookFunc in pairs (widget_table.hooks) do
						switch:SetHook (hookName, hookFunc)
					end
				end

				if (widget_table.width) then
					switch:SetWidth(widget_table.width)
				end
				if (widget_table.height) then
					switch:SetHeight(widget_table.height)
				end

				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				if (widget_table.boxfirst) then
					switch:SetPoint (cur_x, cur_y)
					label:SetPoint ("left", switch, "right", 2)
				else
					label:SetPoint (cur_x, cur_y)
					switch:SetPoint ("left", label, "right", 2)
				end
				switch.hasLabel = label

				if (widget_table.id) then
					parent.widgetids [widget_table.id] = switch
				end
				
				local size = label.widget:GetStringWidth() + 60 + 4
				if (size > max_x) then
					max_x = size
				end
				
				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, switch)
				tinsert (parent.widget_list_by_type.switch, switch)

				widget_created = switch
				line_widgets_created = line_widgets_created + 1
				
			elseif (widget_table.type == "range" or widget_table.type == "slider") then
				local is_decimanls = widget_table.usedecimals
				local slider = DF:NewSlider (parent, nil, "$parentWidget" .. index, nil, 140, 20, widget_table.min, widget_table.max, widget_table.step, widget_table.get(),  is_decimanls, nil, nil, slider_template)
				slider.tooltip = widget_table.desc
				slider._get = widget_table.get
				slider.widget_type = "range"
				slider:SetHook ("OnValueChange", widget_table.set)
				
				if (widget_table.thumbscale) then
					slider:SetThumbSize (slider.thumb:GetWidth()*widget_table.thumbscale, nil)
				else
					slider:SetThumbSize (slider.thumb:GetWidth()*1.3, nil)
				end
				
				if (value_change_hook) then
					slider:SetHook ("OnValueChange", value_change_hook)
				end
				
				--> hook list
				if (widget_table.hooks) then
					for hookName, hookFunc in pairs (widget_table.hooks) do
						slider:SetHook (hookName, hookFunc)
					end
				end
				
				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				slider:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				slider.hasLabel = label
				
				if (widget_table.id) then
					parent.widgetids [widget_table.id] = slider
				end

				local size = label.widget:GetStringWidth() + 140 + 6
				if (size > max_x) then
					max_x = size
				end
				
				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, slider)
				tinsert (parent.widget_list_by_type.slider, slider)

				widget_created = slider
				line_widgets_created = line_widgets_created + 1
				
			elseif (widget_table.type == "color" or widget_table.type == "color") then
				local colorpick = DF:NewColorPickButton (parent, "$parentWidget" .. index, nil, widget_table.set, nil, button_template)
				colorpick.tooltip = widget_table.desc
				colorpick._get = widget_table.get
				colorpick.widget_type = "color"

				local default_value, g, b, a = widget_table.get()
				if (type (default_value) == "table") then
					colorpick:SetColor (unpack (default_value))
				else
					colorpick:SetColor (default_value, g, b, a)
				end
				
				if (value_change_hook) then
					colorpick:SetHook ("OnColorChanged", value_change_hook)
				end
				
				--> hook list
				if (widget_table.hooks) then
					for hookName, hookFunc in pairs (widget_table.hooks) do
						colorpick:SetHook (hookName, hookFunc)
					end
				end
				
				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				colorpick:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				colorpick.hasLabel = label
				
				if (widget_table.id) then
					parent.widgetids [widget_table.id] = colorpick
				end

				local size = label.widget:GetStringWidth() + 60 + 4
				if (size > max_x) then
					max_x = size
				end
				
				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, colorpick)
				tinsert (parent.widget_list_by_type.color, colorpick)

				widget_created = colorpick
				line_widgets_created = line_widgets_created + 1
				
			elseif (widget_table.type == "execute" or widget_table.type == "button") then
			
				local button = DF:NewButton (parent, nil, "$parentWidget" .. index, nil, 120, 18, widget_table.func, widget_table.param1, widget_table.param2, nil, widget_table.name, nil, button_template, text_template)
				if (not button_template) then
					button:InstallCustomTexture()
				end

				if (widget_table.inline) then
					if (latestInlineWidget) then
						button:SetPoint ("left", latestInlineWidget, "right", 2, 0)
						latestInlineWidget = button
					else
						button:SetPoint (cur_x, cur_y)
						latestInlineWidget = button
					end
				else
					button:SetPoint (cur_x, cur_y)
				end

				button.tooltip = widget_table.desc
				button.widget_type = "execute"
				
				--notice: execute doesn't trigger global callback
				
				--button icon
				if (widget_table.icontexture) then
					button:SetIcon(widget_table.icontexture, nil, nil, nil, widget_table.icontexcoords, nil, nil, 2)
				end

				--hook list
				if (widget_table.hooks) then
					for hookName, hookFunc in pairs (widget_table.hooks) do
						button:SetHook (hookName, hookFunc)
					end
				end

				if (widget_table.id) then
					parent.widgetids [widget_table.id] = button
				end

				if (widget_table.width) then
					button:SetWidth(widget_table.width)
				end
				if (widget_table.height) then
					button:SetHeight(widget_table.height)
				end
				
				local size = button:GetWidth() + 4
				if (size > max_x) then
					max_x = size
				end
				
				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, button)
				tinsert (parent.widget_list_by_type.button, button)

				widget_created = button
				line_widgets_created = line_widgets_created + 1
				
			elseif (widget_table.type == "textentry") then
				local textentry = DF:CreateTextEntry (parent, widget_table.func or widget_table.set, 120, 18, nil, "$parentWidget" .. index, nil, button_template)
				textentry.tooltip = widget_table.desc
				textentry.text = widget_table.get()
				textentry._get = widget_table.get
				textentry.widget_type = "textentry"
				textentry:SetHook ("OnEnterPressed", widget_table.func or widget_table.set)
				textentry:SetHook ("OnEditFocusLost", widget_table.func or widget_table.set)

				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				textentry:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				textentry.hasLabel = label

				--> text entry doesn't trigger global callback
				
				--> hook list
				if (widget_table.hooks) then
					for hookName, hookFunc in pairs (widget_table.hooks) do
						textentry:SetHook (hookName, hookFunc)
					end
				end

				if (widget_table.id) then
					parent.widgetids [widget_table.id] = textentry
				end
				
				local size = label.widget:GetStringWidth() + 60 + 4
				if (size > max_x) then
					max_x = size
				end
				
				--store the widget created into the overall table and the widget by type
				tinsert (parent.widget_list, textentry)
				tinsert (parent.widget_list_by_type.textentry, textentry)

				widget_created = textentry
				line_widgets_created = line_widgets_created + 1
				
			end
			
			if (widget_table.nocombat) then
				tinsert (disable_on_combat, widget_created)
			end
		
			if (not widget_table.inline) then
				if (widget_table.spacement) then
					cur_y = cur_y - 30
				else
					cur_y = cur_y - 20
				end
			end
			
			if (widget_table.type == "breakline" or cur_y < height) then
				cur_y = y_offset
				cur_x = cur_x + max_x + 30
				line_widgets_created = 0
				max_x = 0
			end
		
		end
		
		DF.RefreshUnsafeOptionsWidgets()
		
	end
	
	local lock_notsafe_widgets = function()
		for _, widget in ipairs (disable_on_combat) do
			widget:Disable()
		end
	end
	local unlock_notsafe_widgets = function()
		for _, widget in ipairs (disable_on_combat) do
			widget:Enable()
		end
	end
	function DF.RefreshUnsafeOptionsWidgets()
		if (DF.PlayerHasCombatFlag) then
			lock_notsafe_widgets()
		else
			unlock_notsafe_widgets()
		end
	end
	DF.PlayerHasCombatFlag = false
	local ProtectCombatFrame = CreateFrame ("frame")
	ProtectCombatFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")
	ProtectCombatFrame:RegisterEvent ("PLAYER_REGEN_DISABLED")
	ProtectCombatFrame:RegisterEvent ("PLAYER_ENTERING_WORLD")
	ProtectCombatFrame:SetScript ("OnEvent", function (self, event)
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
	
	function DF:CreateInCombatTexture (frame)
		if (DF.debug and not frame) then
			error ("Details! Framework: CreateInCombatTexture invalid frame on parameter 1.")
		end
	
		local in_combat_background = DF:CreateImage (frame)
		in_combat_background:SetColorTexture (.6, 0, 0, .1)
		in_combat_background:Hide()

		local in_combat_label = Plater:CreateLabel (frame, "you are in combat", 24, "silver")
		in_combat_label:SetPoint ("right", in_combat_background, "right", -10, 0)
		in_combat_label:Hide()

		frame:RegisterEvent ("PLAYER_REGEN_DISABLED")
		frame:RegisterEvent ("PLAYER_REGEN_ENABLED")
		frame:SetScript ("OnEvent", function (self, event)
			if (event == "PLAYER_REGEN_DISABLED") then
				in_combat_background:Show()
				in_combat_label:Show()
			elseif (event == "PLAYER_REGEN_ENABLED") then
				in_combat_background:Hide()
				in_combat_label:Hide()
			end
		end)
		
		return in_combat_background
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> tutorials
	
	function DF:ShowTutorialAlertFrame (maintext, desctext, clickfunc)
		
		local TutorialAlertFrame = _G.DetailsFrameworkAlertFrame
		
		if (not TutorialAlertFrame) then

			TutorialAlertFrame = CreateFrame ("frame", "DetailsFrameworkAlertFrame", UIParent, "MicroButtonAlertTemplate")
			TutorialAlertFrame.isFirst = true
			TutorialAlertFrame:SetPoint ("left", UIParent, "left", -20, 100)
			TutorialAlertFrame:SetFrameStrata ("TOOLTIP")
			TutorialAlertFrame:Hide()
			
			TutorialAlertFrame:SetScript ("OnMouseUp", function (self) 
				if (self.clickfunc and type (self.clickfunc) == "function") then
					self.clickfunc()
				end
				self:Hide()
			end)
			TutorialAlertFrame:Hide()
		end
		
		--
		TutorialAlertFrame.label = type (maintext) == "string" and maintext or type (desctext) == "string" and desctext or ""
		MicroButtonAlert_SetText (TutorialAlertFrame, alert.label)
		--
		
		TutorialAlertFrame.clickfunc = clickfunc
		TutorialAlertFrame:Show()
	end
	
	local refresh_options = function (self)
		for _, widget in ipairs (self.widget_list) do
			if (widget._get) then
				if (widget.widget_type == "label") then
					if (widget._get()) then
						widget:SetText (widget._get())
					end
				elseif (widget.widget_type == "select") then
					widget:Select (widget._get())
				elseif (widget.widget_type == "toggle" or widget.widget_type == "range") then
					widget:SetValue (widget._get())
				elseif (widget.widget_type == "textentry") then
					widget:SetText (widget._get())
				elseif (widget.widget_type == "color") then
					local default_value, g, b, a = widget._get()
					if (type (default_value) == "table") then
						widget:SetColor (unpack (default_value))
					else
						widget:SetColor (default_value, g, b, a)
					end
				end
			end
		end
	end
	
	local get_frame_by_id = function (self, id)
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

	function DF:SetAsOptionsPanel (frame)
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
	
	function DF:CreateOptionsFrame (name, title, template)
	
		template = template or 1
	
		if (template == 2) then
			local options_frame = CreateFrame ("frame", name, UIParent, "ButtonFrameTemplate")
			tinsert (UISpecialFrames, name)
			options_frame:SetSize (500, 200)
			options_frame.RefreshOptions = refresh_options
			options_frame.widget_list = {}
			
			options_frame:SetScript ("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then 
						self.moving = false
						self:StopMovingOrSizing()
					end
					return options_frame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)
			options_frame:SetScript ("OnMouseUp", function(self)
				if (self.moving) then 
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			
			options_frame:SetMovable (true)
			options_frame:EnableMouse (true)
			options_frame:SetFrameStrata ("DIALOG")
			options_frame:SetToplevel (true)
			
			options_frame:Hide()
			
			options_frame:SetPoint ("center", UIParent, "center")
			options_frame.TitleText:SetText (title)
			options_frame.portrait:SetTexture ([[Interface\CHARACTERFRAME\TEMPORARYPORTRAIT-FEMALE-BLOODELF]])
			
			return options_frame
	
		elseif (template == 1) then
		
			local options_frame = CreateFrame ("frame", name, UIParent)
			tinsert (UISpecialFrames, name)
			options_frame:SetSize (500, 200)
			options_frame.RefreshOptions = refresh_options
			options_frame.widget_list = {}

			options_frame:SetScript ("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then 
						self.moving = false
						self:StopMovingOrSizing()
					end
					return options_frame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)
			options_frame:SetScript ("OnMouseUp", function(self)
				if (self.moving) then 
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			
			options_frame:SetMovable (true)
			options_frame:EnableMouse (true)
			options_frame:SetFrameStrata ("DIALOG")
			options_frame:SetToplevel (true)
			
			options_frame:Hide()
			
			options_frame:SetPoint ("center", UIParent, "center")
			
			options_frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
			edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
			insets = {left = 1, right = 1, top = 1, bottom = 1}})
			options_frame:SetBackdropColor (0, 0, 0, .7)

			local texturetitle = options_frame:CreateTexture (nil, "artwork")
			texturetitle:SetTexture ([[Interface\CURSOR\Interact]])
			texturetitle:SetTexCoord (0, 1, 0, 1)
			texturetitle:SetVertexColor (1, 1, 1, 1)
			texturetitle:SetPoint ("topleft", options_frame, "topleft", 2, -3)
			texturetitle:SetWidth (36)
			texturetitle:SetHeight (36)
			
			local title = DF:NewLabel (options_frame, nil, "$parentTitle", nil, title, nil, 20, "yellow")
			title:SetPoint ("left", texturetitle, "right", 2, -1)
			DF:SetFontOutline (title, true)

			local c = CreateFrame ("Button", nil, options_frame, "UIPanelCloseButton")
			c:SetWidth (32)
			c:SetHeight (32)
			c:SetPoint ("TOPRIGHT",  options_frame, "TOPRIGHT", -3, -3)
			c:SetFrameLevel (options_frame:GetFrameLevel()+1)
			
			return options_frame
		end
	end	
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> ~templates

--fonts

DF.font_templates = DF.font_templates or {}

--> detect which language is the client and select the font accordingly
local clientLanguage = GetLocale()
if (clientLanguage == "enGB") then
	clientLanguage = "enUS"
end

DF.ClientLanguage = clientLanguage

--> returns which region the language the client is running, return "western", "russia" or "asia"
function DF:GetClientRegion()
	if (clientLanguage == "zhCN" or clientLanguage == "koKR" or clientLanguage == "zhTW") then
		return "asia"
	elseif (clientLanguage == "ruRU") then
		return "russia"
	else
		return "western"
	end
end

--> return the best font to use for the client language
function DF:GetBestFontForLanguage (language, western, cyrillic, china, korean, taiwan)
	if (not language) then
		language = DF.ClientLanguage
	end

	if (language == "enUS" or language == "deDE" or language == "esES" or language == "esMX" or language == "frFR" or language == "itIT" or language == "ptBR") then
		return western or "Accidental Presidency"
		
	elseif (language == "ruRU") then
		return cyrillic or "Arial Narrow"
		
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
DF.font_templates ["ORANGE_FONT_TEMPLATE"] = {color = "orange", size = 11, font = DF:GetBestFontForLanguage()}
DF.font_templates ["OPTIONS_FONT_TEMPLATE"] = {color = "yellow", size = 12, font = DF:GetBestFontForLanguage()}

-- dropdowns

DF.dropdown_templates = DF.dropdown_templates or {}
DF.dropdown_templates ["OPTIONS_DROPDOWN_TEMPLATE"] = {
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

-- switches

DF.switch_templates = DF.switch_templates or {}
DF.switch_templates ["OPTIONS_CHECKBOX_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	width = 18,
	height = 18,
	enabled_backdropcolor = {1, 1, 1, .5},
	disabled_backdropcolor = {1, 1, 1, .2},
	onenterbordercolor = {1, 1, 1, 1},
}
DF.switch_templates ["OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	width = 18,
	height = 18,
	enabled_backdropcolor = {1, 1, 1, .5},
	disabled_backdropcolor = {1, 1, 1, .5},
	onenterbordercolor = {1, 1, 1, 1},
}

-- buttons

DF.button_templates = DF.button_templates or {}
DF.button_templates ["OPTIONS_BUTTON_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
}

-- sliders

DF.slider_templates = DF.slider_templates or {}
DF.slider_templates ["OPTIONS_SLIDER_TEMPLATE"] = {
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

function DF:InstallTemplate (widget_type, template_name, template, parent_name)

	local newTemplate = {}
	
	--if has a parent, just copy the parent to the new template
	if (parent_name and type (parent_name) == "string") then
		local parentTemplate = DF:GetTemplate (widget_type, parent_name)
		if (parentTemplate) then
			DF.table.copy (newTemplate, parentTemplate)
		end
	end
	
	--copy the template passed into the new template
	DF.table.copy (newTemplate, template)

	widget_type = string.lower (widget_type)
	
	local template_table
	if (widget_type == "font") then
		template_table = DF.font_templates
		
		local font = template.font
		if (font) then
			--> fonts passed into the template has default to western
			--> the framework will get the game client language and change the font if needed
			font = DF:GetBestFontForLanguage (nil, font)
		end
		
	elseif (widget_type == "dropdown") then
		template_table = DF.dropdown_templates
	elseif (widget_type == "button") then
		template_table = DF.button_templates
	elseif (widget_type == "switch") then
		template_table = DF.switch_templates
	elseif (widget_type == "slider") then
		template_table = DF.slider_templates
	end

	template_table [template_name] = newTemplate
	
	return newTemplate
end

function DF:GetTemplate (widget_type, template_name)
	widget_type = string.lower (widget_type)

	local template_table
	if (widget_type == "font") then
		template_table = DF.font_templates
	elseif (widget_type == "dropdown") then
		template_table = DF.dropdown_templates
	elseif (widget_type == "button") then
		template_table = DF.button_templates
	elseif (widget_type == "switch") then
		template_table = DF.switch_templates
	elseif (widget_type == "slider") then
		template_table = DF.slider_templates
	end
	return template_table [template_name]
end

function DF.GetParentName (frame)
	local parentName = frame:GetName()
	if (not parentName) then
		error ("Details! FrameWork: called $parent but parent was no name.", 2)
	end
	return parentName
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> widget scripts and hooks

function DF:RunHooksForWidget (event, ...)
	local hooks = self.HookList [event]
	
	if (not hooks) then
		print (self.widget:GetName(), "no hooks for", event)
		return
	end
	
	for i, func in ipairs (hooks) do
		local success, canInterrupt = pcall (func, ...)
		if (not success) then
			error ("Details! Framework: " .. event .. " hook for " .. self:GetName() .. ": " .. canInterrupt)
		elseif (canInterrupt) then
			return true
		end
	end
end

function DF:SetHook (hookType, func)
	if (self.HookList [hookType]) then
		if (type (func) == "function") then
			local isRemoval = false
			for i = #self.HookList [hookType], 1, -1 do
				if (self.HookList [hookType] [i] == func) then
					tremove (self.HookList [hookType], i)
					isRemoval = true
					break
				end
			end
			if (not isRemoval) then
				tinsert (self.HookList [hookType], func)
			end
		else
			if (DF.debug) then
				print (debugstack())
				error ("Details! Framework: invalid function for widget " .. self.WidgetType .. ".")
			end
		end
	else
		if (DF.debug) then
			error ("Details! Framework: unknown hook type for widget " .. self.WidgetType .. ": '" .. hookType .. "'.")
		end
	end
end

function DF:HasHook (hookType, func)
	if (self.HookList [hookType]) then
		if (type (func) == "function") then
			for i = #self.HookList [hookType], 1, -1 do
				if (self.HookList [hookType] [i] == func) then
					return true
				end
			end
		end
	end
end

function DF:ClearHooks()
	for hookType, hookTable in pairs(self.HookList) do
		table.wipe(hookTable)
	end
end

function DF:Error (errortext)
	print ("|cFFFF2222Details! Framework Error|r:", errortext, self.GetName and self:GetName(), self.WidgetType, debugstack (2, 3, 0))
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> members

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

function DF:AddMemberForWidget (widgetName, memberType, memberName, func)
	if (DF.GlobalWidgetControlNames [widgetName]) then
		if (type (memberName) == "string" and (memberType == "SET" or memberType == "GET")) then
			if (func) then
				local widgetControlObject = _G [DF.GlobalWidgetControlNames [widgetName]]
				
				if (memberType == "SET") then
					widgetControlObject ["SetMembers"] [memberName] = func
				elseif (memberType == "GET") then
					widgetControlObject ["GetMembers"] [memberName] = func
				end
			else
				if (DF.debug) then
					error ("Details! Framework: AddMemberForWidget invalid function.")
				end
			end
		else
			if (DF.debug) then
				error ("Details! Framework: AddMemberForWidget unknown memberName or memberType.")
			end
		end
	else
		if (DF.debug) then
			error ("Details! Framework: AddMemberForWidget unknown widget type: " .. (widgetName or "") .. ".")
		end
	end
end

-----------------------------

function DF:OpenInterfaceProfile()
	-- OptionsFrame1/2 should be registered if created with DF:CreateAddOn, so open to them directly
	if self.OptionsFrame1 then
		InterfaceOptionsFrame_OpenToCategory (self.OptionsFrame1)
		if self.OptionsFrame2 then
			InterfaceOptionsFrame_OpenToCategory (self.OptionsFrame2)
		end
		return
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
						if (toggle:GetNormalTexture():GetTexture():find ("PlusButton")) then
							--is minimized, need expand
							toggle:Click()
							_G ["InterfaceOptionsFrameAddOnsButton" .. i+1]:Click()
						elseif (toggle:GetNormalTexture():GetTexture():find ("MinusButton")) then
							--isn't minimized
							_G ["InterfaceOptionsFrameAddOnsButton" .. i+1]:Click()
						end
					end
					break
				end
			end
		else
			self:Msg ("Couldn't not find the profile panel.")
			break
		end
	end
end

-----------------------------
--safe copy from blizz api
function DF:Mixin (object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...);
		for k, v in pairs(mixin) do
			object[k] = v;
		end
	end

	return object;
end

-----------------------------
--> animations

function DF:CreateAnimationHub (parent, onPlay, onFinished)
	local newAnimation = parent:CreateAnimationGroup()
	newAnimation:SetScript ("OnPlay", onPlay)
	newAnimation:SetScript ("OnFinished", onFinished)
	newAnimation:SetScript ("OnStop", onFinished)
	newAnimation.NextAnimation = 1
	return newAnimation
end

function DF:CreateAnimation (animation, type, order, duration, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local anim = animation:CreateAnimation (type)
	
	anim:SetOrder (order or animation.NextAnimation)
	anim:SetDuration (duration)
	
	type = string.upper (type)
	
	if (type == "ALPHA") then
		anim:SetFromAlpha (arg1)
		anim:SetToAlpha (arg2)
	
	elseif (type == "SCALE") then
		anim:SetFromScale (arg1, arg2)
		anim:SetToScale (arg3, arg4)
		anim:SetOrigin (arg5 or "center", arg6 or 0, arg7 or 0) --point, x, y
	
	elseif (type == "ROTATION") then
		anim:SetDegrees (arg1) --degree
		anim:SetOrigin (arg2 or "center", arg3 or 0, arg4 or 0) --point, x, y
		
	elseif (type == "TRANSLATION") then
		anim:SetOffset (arg1, arg2)
		
	end
	
	animation.NextAnimation = animation.NextAnimation + 1	
	return anim
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> frame shakes

--> frame shakes rely on OnUpdate scripts, we are using a built-in OnUpdate so is guarantee it'll run
local FrameshakeUpdateFrame = DetailsFrameworkFrameshakeControl or CreateFrame ("frame", "DetailsFrameworkFrameshakeControl", UIParent)
--> store the frame which has frame shakes registered
FrameshakeUpdateFrame.RegisteredFrames = FrameshakeUpdateFrame.RegisteredFrames or {}

FrameshakeUpdateFrame.RegisterFrame = function (newFrame)
	--> add the frame into the registered frames to update
	DF.table.addunique (FrameshakeUpdateFrame.RegisteredFrames, newFrame)
end

--forward declared
local frameshake_do_update

FrameshakeUpdateFrame:SetScript ("OnUpdate", function (self, deltaTime)
	for i = 1, #FrameshakeUpdateFrame.RegisteredFrames do
		local parent = FrameshakeUpdateFrame.RegisteredFrames [i]
		--> check if there's a shake running
		if (parent.__frameshakes.enabled > 0) then
			--update all shakes for this frame
			for i = 1, #parent.__frameshakes do
				local shakeObject = parent.__frameshakes [i]
				if (shakeObject.IsPlaying) then
					frameshake_do_update (parent, shakeObject, deltaTime)
				end
			end
		end	
	end
end)


local frameshake_shake_finished = function (parent, shakeObject)
	if (shakeObject.IsPlaying) then
		shakeObject.IsPlaying = false
		shakeObject.TimeLeft = 0
		shakeObject.IsFadingOut = false
		shakeObject.IsFadingIn = false
		
		--> update the amount of shake running on this frame
		parent.__frameshakes.enabled = parent.__frameshakes.enabled - 1
		
		--> restore the default anchors, in case where deltaTime was too small that didn't triggered an update
		for i = 1, #shakeObject.Anchors do
			local anchor = shakeObject.Anchors [i]
			
			--> automatic anchoring and reanching needs to the reviwed in the future
			if (#anchor == 1) then
				local anchorTo = unpack (anchor)
				parent:ClearAllPoints()
				parent:SetPoint (anchorTo)
				
			elseif (#anchor == 2) then
				local anchorTo, point1 = unpack (anchor)
				parent:ClearAllPoints()
				parent:SetPoint (anchorTo, point1)
				
			elseif (#anchor == 3) then
				local anchorTo, point1, point2 = unpack (anchor)
				parent:SetPoint (anchorTo, point1, point2)
				
			elseif (#anchor == 5) then
				local anchorName1, anchorTo, anchorName2, point1, point2 = unpack (anchor)
				parent:SetPoint (anchorName1, anchorTo, anchorName2, point1, point2)
			end
		end
	end
end

--already declared above the update function
frameshake_do_update = function (parent, shakeObject, deltaTime)

	--> check delta time
	deltaTime = deltaTime or 0
	
	--> update time left
	shakeObject.TimeLeft = max (shakeObject.TimeLeft - deltaTime, 0)

	if (shakeObject.TimeLeft > 0) then
		--> update fade in and out
		if (shakeObject.IsFadingIn) then
			shakeObject.IsFadingInTime = shakeObject.IsFadingInTime + deltaTime
		end
		if (shakeObject.IsFadingOut) then
			shakeObject.IsFadingOutTime = shakeObject.IsFadingOutTime + deltaTime
		end

		--> check if can disable fade in
		if (shakeObject.IsFadingIn and shakeObject.IsFadingInTime > shakeObject.FadeInTime) then
			shakeObject.IsFadingIn = false
		end
		
		--> check if can enable fade out
		if (not shakeObject.IsFadingOut and shakeObject.TimeLeft < shakeObject.FadeOutTime) then
			shakeObject.IsFadingOut = true
			shakeObject.IsFadingOutTime = shakeObject.FadeOutTime - shakeObject.TimeLeft
		end
		
		--> update position
		local scaleShake = min (shakeObject.IsFadingIn and (shakeObject.IsFadingInTime / shakeObject.FadeInTime) or 1, shakeObject.IsFadingOut and (1 - shakeObject.IsFadingOutTime / shakeObject.FadeOutTime) or 1)

		if (scaleShake > 0) then

			--> delate the time by the frequency on both X and Y offsets
			shakeObject.XSineOffset = shakeObject.XSineOffset + (deltaTime * shakeObject.Frequency)
			shakeObject.YSineOffset = shakeObject.YSineOffset + (deltaTime * shakeObject.Frequency)
			
			--> calc the new position
			local newX, newY
			if (shakeObject.AbsoluteSineX) then
				--absoluting only the sine wave, passing a negative scale will reverse the absolute direction
				newX = shakeObject.Amplitude * abs (math.sin (shakeObject.XSineOffset)) * scaleShake * shakeObject.ScaleX
			else
				newX = shakeObject.Amplitude * math.sin (shakeObject.XSineOffset) * scaleShake * shakeObject.ScaleX
			end
			
			if (shakeObject.AbsoluteSineY) then
				newY = shakeObject.Amplitude * abs (math.sin (shakeObject.YSineOffset)) * scaleShake * shakeObject.ScaleY
			else
				newY = shakeObject.Amplitude * math.sin (shakeObject.YSineOffset) * scaleShake * shakeObject.ScaleY
			end
			
			--> apply the offset to the frame anchors
			for i = 1, #shakeObject.Anchors do
				local anchor = shakeObject.Anchors [i]
				
				if (#anchor == 1 or #anchor == 3) then
					local anchorTo, point1, point2 = unpack (anchor)
					point1 = point1 or 0
					point2 = point2 or 0
					parent:SetPoint (anchorTo, point1 + newX, point2 + newY)
					
				elseif (#anchor == 5) then
					local anchorName1, anchorTo, anchorName2, point1, point2 = unpack (anchor)
					--parent:ClearAllPoints()
					
					parent:SetPoint (anchorName1, anchorTo, anchorName2, point1 + newX, point2 + newY)
				end
			end
			
		end
	else
		frameshake_shake_finished (parent, shakeObject)
	end
end

local frameshake_stop = function (parent, shakeObject)
	frameshake_shake_finished (parent, shakeObject)
end

--> scale direction scales the X and Y coordinates, scale strength scales the amplitude and frequency
local frameshake_play = function (parent, shakeObject, scaleDirection, scaleAmplitude, scaleFrequency, scaleDuration)

	--> check if is already playing
	if (shakeObject.TimeLeft > 0) then
		--> reset the time left
		shakeObject.TimeLeft = shakeObject.Duration
		
		if (shakeObject.IsFadingOut) then
			if (shakeObject.FadeInTime > 0) then
				shakeObject.IsFadingIn = true
				--> scale the current fade out into fade in, so it starts the fade in at the point where it was fading out
				shakeObject.IsFadingInTime = shakeObject.FadeInTime * (1 - shakeObject.IsFadingOutTime / shakeObject.FadeOutTime)
			else
				shakeObject.IsFadingIn = false
				shakeObject.IsFadingInTime = 0
			end
			
			--> disable fade out and enable fade in
			shakeObject.IsFadingOut = false
			shakeObject.IsFadingOutTime = 0
		end
	else
		--> create a new random offset
		shakeObject.XSineOffset = math.pi * 2 * math.random()
		shakeObject.YSineOffset = math.pi * 2 * math.random()
		
		--> store the initial position if case it needs a reset
		shakeObject.StartedXSineOffset = shakeObject.XSineOffset
		shakeObject.StartedYSineOffset = shakeObject.YSineOffset
		
		--> check if there's a fade in time
		if (shakeObject.FadeInTime > 0) then
			shakeObject.IsFadingIn = true
		else
			shakeObject.IsFadingIn = false
		end
		
		shakeObject.IsFadingInTime = 0
		shakeObject.IsFadingOut = false
		shakeObject.IsFadingOutTime = 0
		
		--> apply custom scale
		shakeObject.ScaleX = (scaleDirection or 1) * shakeObject.OriginalScaleX
		shakeObject.ScaleY = (scaleDirection or 1) * shakeObject.OriginalScaleY
		shakeObject.Frequency = (scaleFrequency or 1) * shakeObject.OriginalFrequency
		shakeObject.Amplitude = (scaleAmplitude or 1) * shakeObject.OriginalAmplitude
		shakeObject.Duration = (scaleDuration or 1) * shakeObject.OriginalDuration
		
		--> update the time left
		shakeObject.TimeLeft = shakeObject.Duration
		
		--> check if is dynamic points
		if (shakeObject.IsDynamicAnchor) then
			wipe (shakeObject.Anchors)
			for i = 1, parent:GetNumPoints() do
				local p1, p2, p3, p4, p5 = parent:GetPoint (i)
				shakeObject.Anchors [#shakeObject.Anchors+1] = {p1, p2, p3, p4, p5}
			end
		end
		
		--> update the amount of shake running on this frame
		parent.__frameshakes.enabled = parent.__frameshakes.enabled + 1
		
		if (not parent:GetScript ("OnUpdate")) then
			parent:SetScript ("OnUpdate", function()end)
		end
	end

	shakeObject.IsPlaying = true
	
	frameshake_do_update (parent, shakeObject)
end

local frameshake_set_config = function (parent, shakeObject, duration, amplitude, frequency, absoluteSineX, absoluteSineY, scaleX, scaleY, fadeInTime, fadeOutTime, anchorPoints)
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

function DF:CreateFrameShake (parent, duration, amplitude, frequency, absoluteSineX, absoluteSineY, scaleX, scaleY, fadeInTime, fadeOutTime, anchorPoints)

	--> create the shake table
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
	
	if (type (anchorPoints) ~= "table") then
		frameShake.IsDynamicAnchor = true
		frameShake.Anchors = {}
	else 
		frameShake.Anchors = anchorPoints
	end
	
	--> inject frame shake table into the frame
	if (not parent.__frameshakes) then
		parent.__frameshakes = {
			enabled = 0,
		}
		parent.PlayFrameShake = frameshake_play
		parent.StopFrameShake = frameshake_stop
		parent.UpdateFrameShake = frameshake_do_update
		parent.SetFrameShakeSettings = frameshake_set_config
		
		--> register the frame within the frame shake updater
		FrameshakeUpdateFrame.RegisterFrame (parent)
	end

	tinsert (parent.__frameshakes, frameShake)
	
	return frameShake
end


-----------------------------
--> glow overlay

local glow_overlay_play = function (self)
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

local glow_overlay_stop = function (self)
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

local glow_overlay_setcolor = function (self, antsColor, glowColor)
	if (antsColor) then
		local r, g, b, a = DF:ParseColors (antsColor)
		self.ants:SetVertexColor (r, g, b, a)
		self.AntsColor.r = r
		self.AntsColor.g = g
		self.AntsColor.b = b
		self.AntsColor.a = a
	end
	
	if (glowColor) then
		local r, g, b, a = DF:ParseColors (glowColor)
		self.outerGlow:SetVertexColor (r, g, b, a)
		self.GlowColor.r = r
		self.GlowColor.g = g
		self.GlowColor.b = b
		self.GlowColor.a = a
	end
end

local glow_overlay_onshow = function (self)
	glow_overlay_play (self)
end

local glow_overlay_onhide = function (self)
	glow_overlay_stop (self)
end

--this is most copied from the wow client code, few changes applied to customize it
function DF:CreateGlowOverlay (parent, antsColor, glowColor)
	local glowFrame = CreateFrame ("frame", parent:GetName() and "$parentGlow2" or "OverlayActionGlow" .. math.random (1, 10000000), parent, "ActionBarButtonSpellActivationAlert")
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
	
	local r, g, b, a = DF:ParseColors (antsColor or defaultColor)
	glowFrame.ants:SetVertexColor (r, g, b, a)
	glowFrame.AntsColor = {r, g, b, a}
	
	local r, g, b, a = DF:ParseColors (glowColor or defaultColor)
	glowFrame.outerGlow:SetVertexColor (r, g, b, a)
	glowFrame.GlowColor = {r, g, b, a}
	
	glowFrame.outerGlow:SetScale (1.2)
	return glowFrame
end

--> custom glow with ants animation
local ants_set_texture_offset = function (self, leftOffset, rightOffset, topOffset, bottomOffset)
	leftOffset = leftOffset or 0
	rightOffset = rightOffset or 0
	topOffset = topOffset or 0
	bottomOffset = bottomOffset or 0

	self:ClearAllPoints()
	self:SetPoint ("topleft", leftOffset, topOffset)
	self:SetPoint ("bottomright", rightOffset, bottomOffset)
end

function DF:CreateAnts (parent, antTable, leftOffset, rightOffset, topOffset, bottomOffset, antTexture)
	leftOffset = leftOffset or 0
	rightOffset = rightOffset or 0
	topOffset = topOffset or 0
	bottomOffset = bottomOffset or 0
	
	local f = CreateFrame ("frame", nil, parent)
	f:SetPoint ("topleft", leftOffset, topOffset)
	f:SetPoint ("bottomright", rightOffset, bottomOffset)
	
	f.SetOffset = ants_set_texture_offset
	
	local t = f:CreateTexture (nil, "overlay")
	t:SetAllPoints()
	t:SetTexture (antTable.Texture)
	t:SetBlendMode (antTable.BlendMode or "ADD")
	t:SetVertexColor (DF:ParseColors (antTable.Color or "white"))
	f.Texture = t
	
	f.AntTable = antTable
	
	f:SetScript ("OnUpdate", function (self, deltaTime)
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
--> borders

local default_border_color1 = .5
local default_border_color2 = .3
local default_border_color3 = .1

local SetBorderAlpha = function (self, alpha1, alpha2, alpha3)
	self.Borders.Alpha1 = alpha1 or self.Borders.Alpha1
	self.Borders.Alpha2 = alpha2 or self.Borders.Alpha2
	self.Borders.Alpha3 = alpha3 or self.Borders.Alpha3
	
	for _, texture in ipairs (self.Borders.Layer1) do
		texture:SetAlpha (self.Borders.Alpha1)
	end
	for _, texture in ipairs (self.Borders.Layer2) do
		texture:SetAlpha (self.Borders.Alpha2)
	end
	for _, texture in ipairs (self.Borders.Layer3) do
		texture:SetAlpha (self.Borders.Alpha3)
	end
end

local SetBorderColor = function (self, r, g, b)
	for _, texture in ipairs (self.Borders.Layer1) do
		texture:SetColorTexture (r, g, b)
	end
	for _, texture in ipairs (self.Borders.Layer2) do
		texture:SetColorTexture (r, g, b)
	end
	for _, texture in ipairs (self.Borders.Layer3) do
		texture:SetColorTexture (r, g, b)
	end
end

local SetLayerVisibility = function (self, layer1Shown, layer2Shown, layer3Shown)

	for _, texture in ipairs (self.Borders.Layer1) do
		texture:SetShown (layer1Shown)
	end
	
	for _, texture in ipairs (self.Borders.Layer2) do
		texture:SetShown (layer2Shown)
	end
	
	for _, texture in ipairs (self.Borders.Layer3) do
		texture:SetShown (layer3Shown)
	end

end

function DF:CreateBorder (parent, alpha1, alpha2, alpha3)
	
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
	
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "topleft", parent, "topleft", -1, 1)
	PixelUtil.SetPoint (border1, "bottomleft", parent, "bottomleft", -1, -1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "topleft", parent, "topleft", -2, 2)
	PixelUtil.SetPoint (border2, "bottomleft", parent, "bottomleft", -2, -2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "topleft", parent, "topleft", -3, 3)
	PixelUtil.SetPoint (border3, "bottomleft", parent, "bottomleft", -3, -3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)
	
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "topleft", parent, "topleft", 0, 1)
	PixelUtil.SetPoint (border1, "topright", parent, "topright", 1, 1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "topleft", parent, "topleft", -1, 2)
	PixelUtil.SetPoint (border2, "topright", parent, "topright", 2, 2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "topleft", parent, "topleft", -2, 3)
	PixelUtil.SetPoint (border3, "topright", parent, "topright", 3, 3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)	
	
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "topright", parent, "topright", 1, 0)
	PixelUtil.SetPoint (border1, "bottomright", parent, "bottomright", 1, -1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "topright", parent, "topright", 2, 1)
	PixelUtil.SetPoint (border2, "bottomright", parent, "bottomright", 2, -2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "topright", parent, "topright", 3, 2)
	PixelUtil.SetPoint (border3, "bottomright", parent, "bottomright", 3, -3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)	
	
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "bottomleft", parent, "bottomleft", 0, -1)
	PixelUtil.SetPoint (border1, "bottomright", parent, "bottomright", 0, -1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "bottomleft", parent, "bottomleft", -1, -2)
	PixelUtil.SetPoint (border2, "bottomright", parent, "bottomright", 1, -2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "bottomleft", parent, "bottomleft", -2, -3)
	PixelUtil.SetPoint (border3, "bottomright", parent, "bottomright", 2, -3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)
	
end

function DF:CreateBorderSolid (parent, size)

end

function DF:CreateBorderWithSpread (parent, alpha1, alpha2, alpha3, size, spread)
	
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
	local border1 = parent:CreateTexture (nil, "background")
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetPoint (border1, "topleft", parent, "topleft", -1 + spread, 1 + (-spread), 0, 0)
	PixelUtil.SetPoint (border1, "bottomleft", parent, "bottomleft", -1 + spread, -1 + spread, 0, 0)
	PixelUtil.SetWidth (border1, size, minPixels)
	
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "topleft", parent, "topleft", -2 + spread, 2 + (-spread))
	PixelUtil.SetPoint (border2, "bottomleft", parent, "bottomleft", -2 + spread, -2 + spread)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetWidth (border2, size, minPixels)
	
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "topleft", parent, "topleft", -3 + spread, 3 + (-spread))
	PixelUtil.SetPoint (border3, "bottomleft", parent, "bottomleft", -3 + spread, -3 + spread)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetWidth (border3, size, minPixels)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)
	
	--top
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "topleft", parent, "topleft", 0 + spread, 1 + (-spread))
	PixelUtil.SetPoint (border1, "topright", parent, "topright", 1 + (-spread), 1 + (-spread))
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetHeight (border1, size, minPixels)
	
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "topleft", parent, "topleft", -1 + spread, 2 + (-spread))
	PixelUtil.SetPoint (border2, "topright", parent, "topright", 2 + (-spread), 2 + (-spread))
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetHeight (border2, size, minPixels)
	
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "topleft", parent, "topleft", -2 + spread, 3 + (-spread))
	PixelUtil.SetPoint (border3, "topright", parent, "topright", 3 + (-spread), 3 + (-spread))
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetHeight (border3, size, minPixels)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)	
	
	--right
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "topright", parent, "topright", 1 + (-spread), 0 + (-spread))
	PixelUtil.SetPoint (border1, "bottomright", parent, "bottomright", 1 + (-spread), -1 + spread)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetWidth (border1, size, minPixels)
	
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "topright", parent, "topright", 2 + (-spread), 1 + (-spread))
	PixelUtil.SetPoint (border2, "bottomright", parent, "bottomright", 2 + (-spread), -2 + spread)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetWidth (border2, size, minPixels)
	
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "topright", parent, "topright", 3 + (-spread), 2 + (-spread))
	PixelUtil.SetPoint (border3, "bottomright", parent, "bottomright", 3 + (-spread), -3 + spread)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetWidth (border3, size, minPixels)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)	
	
	local border1 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border1, "bottomleft", parent, "bottomleft", 0 + spread, -1 + spread)
	PixelUtil.SetPoint (border1, "bottomright", parent, "bottomright", 0 + (-spread), -1 + spread)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	PixelUtil.SetHeight (border1, size, minPixels)
	
	local border2 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border2, "bottomleft", parent, "bottomleft", -1 + spread, -2 + spread)
	PixelUtil.SetPoint (border2, "bottomright", parent, "bottomright", 1 + (-spread), -2 + spread)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	PixelUtil.SetHeight (border2, size, minPixels)
	
	local border3 = parent:CreateTexture (nil, "background")
	PixelUtil.SetPoint (border3, "bottomleft", parent, "bottomleft", -2 + spread, -3 + spread)
	PixelUtil.SetPoint (border3, "bottomright", parent, "bottomright", 2 + (-spread), -3 + spread)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	PixelUtil.SetHeight (border3, size, minPixels)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)
	
end

function DF:ReskinSlider (slider, heightOffset)
	if (slider.slider) then
		slider.cima:SetNormalTexture ([[Interface\Buttons\Arrow-Up-Up]])
		slider.cima:SetPushedTexture ([[Interface\Buttons\Arrow-Up-Down]])
		slider.cima:SetDisabledTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
		slider.cima:GetNormalTexture():ClearAllPoints()
		slider.cima:GetPushedTexture():ClearAllPoints()
		slider.cima:GetDisabledTexture():ClearAllPoints()
		slider.cima:GetNormalTexture():SetPoint ("center", slider.cima, "center", 1, 1)
		slider.cima:GetPushedTexture():SetPoint ("center", slider.cima, "center", 1, 1)
		slider.cima:GetDisabledTexture():SetPoint ("center", slider.cima, "center", 1, 1)
		slider.cima:SetSize (16, 16)
		--[=[
		slider.cima:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		slider.cima:SetBackdropColor (0, 0, 0, 0.3)
		slider.cima:SetBackdropBorderColor (0, 0, 0, 1)
		]=]
		
		slider.baixo:SetNormalTexture ([[Interface\Buttons\Arrow-Down-Up]])
		slider.baixo:SetPushedTexture ([[Interface\Buttons\Arrow-Down-Down]])
		slider.baixo:SetDisabledTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
		slider.baixo:GetNormalTexture():ClearAllPoints()
		slider.baixo:GetPushedTexture():ClearAllPoints()
		slider.baixo:GetDisabledTexture():ClearAllPoints()
		slider.baixo:GetNormalTexture():SetPoint ("center", slider.baixo, "center", 1, -5)
		slider.baixo:GetPushedTexture():SetPoint ("center", slider.baixo, "center", 1, -5)
		slider.baixo:GetDisabledTexture():SetPoint ("center", slider.baixo, "center", 1, -5)
		slider.baixo:SetSize (16, 16)
		--[=[
		slider.baixo:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		slider.baixo:SetBackdropColor (0, 0, 0, 0.35)
		slider.baixo:SetBackdropBorderColor (0, 0, 0, 1)
		
		slider.slider:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		slider.slider:SetBackdropColor (0, 0, 0, 0.35)
		slider.slider:SetBackdropBorderColor (0, 0, 0, 1)
		]=]
		
		--slider.slider:Altura (164)
		slider.slider:cimaPoint (0, 13)
		slider.slider:baixoPoint (0, -13)
		slider.slider.thumb:SetTexture ([[Interface\AddOns\Details\images\icons2]])
		slider.slider.thumb:SetTexCoord (482/512, 492/512, 104/512, 120/512)
		slider.slider.thumb:SetSize (12, 12)
		slider.slider.thumb:SetVertexColor (0.6, 0.6, 0.6, 0.95)
		
	else
		--up button

		local offset = 1 --space between the scrollbox and the scrollar

		do
			local normalTexture = slider.ScrollBar.ScrollUpButton.Normal
			normalTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Up]])
			normalTexture:SetTexCoord (0, 1, .2, 1)
			
			normalTexture:SetPoint ("topleft", slider.ScrollBar.ScrollUpButton, "topleft", offset, 0)
			normalTexture:SetPoint ("bottomright", slider.ScrollBar.ScrollUpButton, "bottomright", offset, 0)
			
			local pushedTexture = slider.ScrollBar.ScrollUpButton.Pushed
			pushedTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Down]])
			pushedTexture:SetTexCoord (0, 1, .2, 1)
			
			pushedTexture:SetPoint ("topleft", slider.ScrollBar.ScrollUpButton, "topleft", offset, 0)
			pushedTexture:SetPoint ("bottomright", slider.ScrollBar.ScrollUpButton, "bottomright", offset, 0)

			local disabledTexture = slider.ScrollBar.ScrollUpButton.Disabled
			disabledTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
			disabledTexture:SetTexCoord (0, 1, .2, 1)
			disabledTexture:SetAlpha (.5)
			
			disabledTexture:SetPoint ("topleft", slider.ScrollBar.ScrollUpButton, "topleft", offset, 0)
			disabledTexture:SetPoint ("bottomright", slider.ScrollBar.ScrollUpButton, "bottomright", offset, 0)
			
			slider.ScrollBar.ScrollUpButton:SetSize (16, 16)
			--[=[
			slider.ScrollBar.ScrollUpButton:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
			slider.ScrollBar.ScrollUpButton:SetBackdropColor (0, 0, 0, 0.3)
			slider.ScrollBar.ScrollUpButton:SetBackdropBorderColor (0, 0, 0, 1)
			]=]
			--it was having problems with the texture anchor when calling ClearAllPoints() and setting new points different from the original
			--now it is using the same points from the original with small offsets tp align correctly
		end
		
		--down button
		do
			local normalTexture = slider.ScrollBar.ScrollDownButton.Normal
			normalTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Up]])
			normalTexture:SetTexCoord (0, 1, 0, .8)
			
			normalTexture:SetPoint ("topleft", slider.ScrollBar.ScrollDownButton, "topleft", offset, -4)
			normalTexture:SetPoint ("bottomright", slider.ScrollBar.ScrollDownButton, "bottomright", offset, -4)
			
			local pushedTexture = slider.ScrollBar.ScrollDownButton.Pushed
			pushedTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Down]])
			pushedTexture:SetTexCoord (0, 1, 0, .8)
			
			pushedTexture:SetPoint ("topleft", slider.ScrollBar.ScrollDownButton, "topleft", offset, -4)
			pushedTexture:SetPoint ("bottomright", slider.ScrollBar.ScrollDownButton, "bottomright", offset, -4)
			
			local disabledTexture = slider.ScrollBar.ScrollDownButton.Disabled
			disabledTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
			disabledTexture:SetTexCoord (0, 1, 0, .8)
			disabledTexture:SetAlpha (.5)
			
			disabledTexture:SetPoint ("topleft", slider.ScrollBar.ScrollDownButton, "topleft", offset, -4)
			disabledTexture:SetPoint ("bottomright", slider.ScrollBar.ScrollDownButton, "bottomright", offset, -4)
			
			slider.ScrollBar.ScrollDownButton:SetSize (16, 16)
			--[=[
			slider.ScrollBar.ScrollDownButton:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
			slider.ScrollBar.ScrollDownButton:SetBackdropColor (0, 0, 0, 0.3)
			slider.ScrollBar.ScrollDownButton:SetBackdropBorderColor (0, 0, 0, 1)
			]=]

			--<Anchor point="TOP" relativePoint="BOTTOM"/>
			--slider.ScrollBar.ScrollDownButton:SetPoint ("top", slider.ScrollBar, "bottom", 0, 0)
		end
		
		--if the parent has a editbox, this is a code editor
		if (slider:GetParent().editbox) then
			slider.ScrollBar:SetPoint ("TOPLEFT", slider, "TOPRIGHT", 12 + offset, -6)
			slider.ScrollBar:SetPoint ("BOTTOMLEFT", slider, "BOTTOMRIGHT", 12 + offset, 6 + (heightOffset and heightOffset*-1 or 0))

		else
			slider.ScrollBar:SetPoint ("TOPLEFT", slider, "TOPRIGHT", 6, -16)
			slider.ScrollBar:SetPoint ("BOTTOMLEFT", slider, "BOTTOMRIGHT", 6, 16 + (heightOffset and heightOffset*-1 or 0))
		end

		slider.ScrollBar.ThumbTexture:SetColorTexture (.5, .5, .5, .3)
		slider.ScrollBar.ThumbTexture:SetSize (12, 8)
		
		--
		--[=[
		slider.ScrollBar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
		slider.ScrollBar:SetBackdropColor (0, 0, 0, 0.35)
		slider.ScrollBar:SetBackdropBorderColor (0, 0, 0, 1)
		]=]
	end
end

function DF:GetCurrentSpec()
	local specIndex = DF.GetSpecialization()
	if (specIndex) then
		local specID = DF.GetSpecializationInfo (specIndex)
		if (specID and specID ~= 0) then
			return specID
		end
	end
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
}

function DF:GetClassSpecIDs (class)
	return specs_per_class [class]
end

local dispatch_error = function (context, errortext)
	DF:Msg ( (context or "<no context>") .. " |cFFFF9900error|r: " .. (errortext or "<no error given>"))
end

--> safe call an external func with payload and without telling who is calling
function DF:QuickDispatch (func, ...)
	if (type (func) ~= "function") then
		return
	end
	
	local okay, errortext = pcall (func, ...)
	
	if (not okay) then
		--> trigger an error msg
		dispatch_error (_, errortext)
		return
	end
	
	return true
end

function DF:Dispatch (func, ...)
	if (type (func) ~= "function") then
		return dispatch_error (_, "Dispatch required a function.")
	end

	local okay, result1, result2, result3, result4 = xpcall (func, geterrorhandler(), ...)
	
	if (not okay) then
		return nil
	end
	
	return result1, result2, result3, result4
end

--[=[
	DF:CoreDispatch (func, context, ...)
	safe call a function making a error window with what caused, the context and traceback of the error
	this func is only used inside the framework for sensitive calls where the func must run without errors
	@func = the function which will be called
	@context = what made the function be called
	... parameters to pass in the function call
--]=]
function DF:CoreDispatch (context, func, ...)
	if (type (func) ~= "function") then
		local stack = debugstack(2)
		local errortext = "D!Framework " .. context .. " error: invalid function to call\n====================\n" .. stack .. "\n====================\n"
		error (errortext)
	end
	
	local okay, result1, result2, result3, result4 = xpcall(func, geterrorhandler(), ...)

	--if (not okay) then --when using pcall
		--local stack = debugstack(2)
		--local errortext = "D!Framework (" .. context .. ") error: " .. result1 .. "\n====================\n" .. stack .. "\n====================\n"
		--error (errortext)
	--end
	
	return result1, result2, result3, result4
end


--/run local a, b =32,3; local f=function(c,d) return c+d, 2, 3;end; print (xpcall(f,geterrorhandler(),a,b))
function DF_CALC_PERFORMANCE()
	local F = CreateFrame ("frame")
	local T = GetTime()
	local J = false
	F:SetScript ("OnUpdate", function (self, deltaTime)
		if (not J) then
			J = true
			return 
		end
		print ("Elapsed Time:", deltaTime)
		F:SetScript ("OnUpdate", nil)
	end)
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
}
DF.ClassCache = {}

function DF:GetClassList()

	if (next (DF.ClassCache)) then
		return DF.ClassCache
	end
	
	for className, classIndex in pairs (DF.ClassFileNameToIndex) do
		local classTable = C_CreatureInfo.GetClassInfo (classIndex)
		local t = {
			ID = classIndex,
			Name = classTable.className,
			Texture = [[Interface\GLUES\CHARACTERCREATE\UI-CharacterCreate-Classes]],
			TexCoord = CLASS_ICON_TCOORDS [className],
			FileString = className,
		}
		tinsert (DF.ClassCache, t)
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


--> store and return a list of character races, always return the non-localized value
DF.RaceCache = {}
function DF:GetCharacterRaceList (fullList)
	if (next (DF.RaceCache)) then
		return DF.RaceCache
	end
	
	for i = 1, 100 do
		local raceInfo = C_CreatureInfo.GetRaceInfo (i)
		if (raceInfo and DF.RaceList [raceInfo.raceID]) then
			tinsert (DF.RaceCache, {Name = raceInfo.raceName, FileString = raceInfo.clientFileString})
		end
		
		local alliedRaceInfo = C_AlliedRaces.GetRaceInfoByID (i)
		if (alliedRaceInfo and DF.AlliedRaceList [alliedRaceInfo.raceID]) then
			tinsert (DF.RaceCache, {Name = alliedRaceInfo.maleName, FileString = alliedRaceInfo.raceFileString})
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
					tinsert (talentList, {Name = name, ID = talentID, Texture = texture, IsSelected = selected})
					break
				end
			else
				tinsert (talentList, {Name = name, ID = talentID, Texture = texture, IsSelected = selected})
			end
		end
	end
	
	return talentList
end

function DF:GetCharacterPvPTalents (onlySelected, onlySelectedHash)
	if (onlySelected or onlySelectedHash) then
		local talentsSelected = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
		local talentList = {}
		for _, talentID in ipairs (talentsSelected) do
			local _, talentName, texture = GetPvpTalentInfoByID (talentID)
			if (onlySelectedHash) then
				talentList [talentID] = true
			else
				tinsert (talentList, {Name = talentName, ID = talentID, Texture = texture, IsSelected = true})
			end
		end
		return talentList
		
	else	
		local alreadyAdded = {}
		local talentList = {}
		for i = 1, 4 do --4 slots - get talents available in each one
			local slotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo (i)
			if (slotInfo) then
				for _, talentID in ipairs (slotInfo.availableTalentIDs) do
					if (not alreadyAdded [talentID]) then
						local _, talentName, texture, selected = GetPvpTalentInfoByID (talentID)
						tinsert (talentList, {Name = talentName, ID = talentID, Texture = texture, IsSelected = selected})
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

function DF:AddRoleIconToText(text, role, size)
	if (role and type(role) == "string") then
		local coords = GetTexCoordsForRole(role)
		if (coords) then
			if (type (text) == "string" and role ~= "NONE") then
				size = size or 14
				text = "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. size .. ":" .. size .. ":0:0:256:256:" .. roleTexcoord[role] .. "|t " .. text
				return text
			end
		end
	end

	return text
end

DF.CLEncounterID = {
	{ID = 2144, Name = "Taloc"},
	{ID = 2141, Name = "MOTHER"},
	{ID = 2128, Name = "Fetid Devourer"},
	{ID = 2136, Name = "Zek'voz"},
	{ID = 2134, Name = "Vectis"},
	{ID = 2145, Name = "Zul"},
	{ID = 2135, Name =  "Mythrax the Unraveler"},
	{ID = 2122, Name = "G'huun"},
}

function DF:GetPlayerRole()
	local assignedRole = UnitGroupRolesAssigned ("player")
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> execute range

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
						--> is using killer instinct?
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
						--> is using hammer of wrath?
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
--> delta seconds reader

if (not DetailsFrameworkDeltaTimeFrame) then
	CreateFrame ("frame", "DetailsFrameworkDeltaTimeFrame", UIParent)
end

local deltaTimeFrame = DetailsFrameworkDeltaTimeFrame
deltaTimeFrame:SetScript ("OnUpdate", function (self, deltaTime)
	self.deltaTime = deltaTime
end)

function GetWorldDeltaSeconds()
	return deltaTimeFrame.deltaTime
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> build the global script channel for scripts communication
--send and retrieve data sent by othe users in scripts
--Usage:
--DetailsFramework:RegisterScriptComm (ID, function(sourcePlayerName, ...) end)
--DetailsFramework:SendScriptComm (ID, ...)

	local aceComm = LibStub:GetLibrary ("AceComm-3.0")
	local LibAceSerializer = LibStub:GetLibrary ("AceSerializer-3.0")
	local LibDeflate = LibStub:GetLibrary ("LibDeflate")
	
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
								DF:Dispatch (func, commSource, select (5, unpack (data))) --this use xpcall
							end
						end
					end
				end
			end
		end
	end
	
	function DF:RegisterScriptComm (ID, func)
		if (ID) then
			if (type (func) == "function") then
				DF.RegisteredScriptsComm [ID] = func
			else
				DF.RegisteredScriptsComm [ID] = nil
			end
		end
	end
	
	function DF:SendScriptComm (ID, ...)
		if (DF.RegisteredScriptsComm [ID]) then
			local sourceName = UnitName ("player") .. "-" .. GetRealmName()
			local data = LibAceSerializer:Serialize (ID, UnitGUID ("player"), sourceName, ...)
			data = LibDeflate:CompressDeflate (data, {level = 9})
			data = LibDeflate:EncodeForWoWAddonChannel (data)
			aceComm:SendCommMessage ("_GSC", data, "PARTY")
		end
	end
	
	if (aceComm and LibAceSerializer and LibDeflate) then
		aceComm:RegisterComm ("_GSC", DF.OnReceiveScriptComm)
	end
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> debug

DF.DebugMixin = {

	debug = true,

	CheckPoint = function (self, checkPointName, ...)
		print (self:GetName(), checkPointName, ...)
	end,
	
	CheckVisibilityState = function (self, widget)
		
		self = widget or self
		
		local width, height = self:GetSize()
		width = floor (width)
		height = floor (height)
		
		local numPoints = self:GetNumPoints()
		
		print ("shown:", self:IsShown(), "visible:", self:IsVisible(), "alpha:", self:GetAlpha(), "size:", width, height, "points:", numPoints)
	end,
	
	CheckStack = function (self)
		local stack = debugstack()
		Details:Dump (stack)
	end,
	
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------
	
--> returns if the unit is tapped (gray health color when another player hit the unit first) 
function DF:IsUnitTapDenied (unitId)
	return unitId and not UnitPlayerControlled (unitId) and UnitIsTapDenied (unitId)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--> pool

do    
    local get = function(self)
        local object = tremove(self.notUse, #self.notUse)
        if (object) then
            tinsert(self.inUse, object)
			return object, false
			
        else
            --need to create the new object
            local newObject = self.newObjectFunc(self, unpack(self.payload))
            if (newObject) then
				tinsert(self.inUse, newObject)
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
                break
            end
        end        
    end
    
    local reset = function(self)
        for i = #self.inUse, 1, -1 do
            local object = tremove(self.inUse, i)
            tinsert(self.notUse, object)
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
--> forbidden functions on scripts

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
		["getfenv"] = true,
		["getfenv"] = true,
		["loadstring"] = true,
		["pcall"] = true,
		["xpcall"] = true,
		["getglobal"] = true,
		["setmetatable"] = true,
		["DevTools_DumpCommand"] = true,

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
		__index = function (env, key)

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


-----------------------------------------------------------------------------------------------------------------------------------------------------------
