--[[
	———————————————— Rev 09 ———
	- Fixed GetChecked() now returning a boolean instead of nil/1
	——— 16.07.23 ——— Rev 10 ——— 7.0.3/Legion ———
	- Changed SetTexture(r,g,b,a) -> SetColorTexture(r,g,b,a)
	——— 18.08.12 ——— Rev 11 ——— 8.0/BfA ———
	- Added native LSM support to the dropdown
	- The building of the options page is now done internally, instead of in the client addon.
	- Some code restructure.
	——— 20.10.31 ——— Rev 12 ——— 9.0.1/Shadowlands ———
	- CreateFrame() now uses the "BackdropTemplate"
--]]

local REVISION = 12;
if (type(AzOptionsFactory) == "table") and (AzOptionsFactory.vers >= REVISION) then
	return;
end

-- reuse and update obsolete version, or create new
AzOptionsFactory = AzOptionsFactory or {};
local azof = AzOptionsFactory;

azof.vers = REVISION;
azof.objectNameCount = azof.objectNameCount or {};
azof.__index = azof;

azof.objects = {};

local ReturnZeroMeta = { __index = function() return 0; end };

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Converts hex string colors to RGBA
local function SetFromHexColorMarkup(self,string)
	local ha, hr, hg, hb = string:match("^|c(..)(..)(..)(..)");
	self:SetRGBA(
		format("%d","0x"..hr) / 255,
		format("%d","0x"..hg) / 255,
		format("%d","0x"..hb) / 255,
		format("%d","0x"..ha) / 255
	);
end

-- Generate Unique Object Name
local function GenerateObjectName(type)
	azof.objectNameCount[type] = (azof.objectNameCount[type] or 0) + 1;
	return "AzOptionsFactory"..type..azof.objectNameCount[type];
end

-- Gets an existing object or creates a new one if needed
function azof:GetObject(type)
	-- verify the object type is valid
	local obj = self.objects[type];
	if (not obj) then
		AzMsg("|2<ERROR>|r Invalid factory object type!");
		return;
	end

	-- increase ref count for this object type
	local index = (self.objectUse[type] + 1);
	self.objectUse[type] = index;

	-- return an existing instance currently not in use, or create a new instance
	if (not self.instances[type]) then
		self.instances[type] = {};
	end

	if (self.instances[type][index]) then
		return self.instances[type][index];
	else
		local inst = obj.CreateNew(self);
		self.instances[type][index] = inst;
		inst.class = obj;
		inst.factory = self;
		return inst;
	end
end

-- Resets the object use and hides all objects
function azof:ResetObjectUse()
	wipe(self.objectUse);
	for _, types in next, self.instances do
		for _, inst in ipairs(types) do
			inst:Hide();
		end
	end
end

-- Creates New Factory Instance -- The UNUSED parameter is a remnant from when it needed the cfg table
function azof:New(owner,GetConfigValue,SetConfigValue)
	local instance = {
		owner = owner,
		instances = {},
		objectUse = setmetatable({},ReturnZeroMeta),
		GetConfigValue = GetConfigValue,
		SetConfigValue = SetConfigValue,
	};
	return setmetatable(instance,azof);
end

-- builds options page
function azof:BuildOptionsPage(options,anchor,left,top,restrictToken)
	self.isBuildingOptions = true;
	self:ResetObjectUse();
	AzDropDown:HideMenu();

	local lastHeight = 0;

	for index, option in ipairs(options) do
		local restrictType = type(option.restrict);
		local allowCreation = (
			(restrictType == "nil")
			or (restrictType == "string" and restrictToken == option.restrict)
			or (restrictType == "table" and tIndexOf(option.restrict,restrictToken))
		);

		if (option.type) and (allowCreation) then
			local obj = self:GetObject(option.type);

			obj.option = option;
			obj.text:SetText(option.label);
			obj.class.Init(obj,option,self:GetConfigValue(option.var));

			-- Anchor the frame
			obj:ClearAllPoints();

			local xOffset = (option.x or 0);
			if (xOffset == 0) then
				top = (top + lastHeight);
			end

			local yOffset = (option.y or 0);
			top = (top + yOffset);

			local xFinal = left + self.objects[option.type].xOffset + xOffset;
			local yFinal = top;

			obj:SetPoint("TOPLEFT",anchor,"TOPLEFT",xFinal,-yFinal);

			lastHeight = (obj:GetHeight() + self.objects[option.type].yOffset);

			-- Show
			obj:Show();
		end
	end

	self.isBuildingOptions = nil;
end

--------------------------------------------------------------------------------------------------------
--                                            Slider Frame                                            --
--------------------------------------------------------------------------------------------------------

-- EditBox Enter Pressed
local function SliderEdit_OnEnterPressed(self)
	self:GetParent().slider:SetValue(self:GetNumber());
end

-- Slider Value Changed
local function Slider_OnValueChanged(self)
	local parent = self:GetParent();
	parent.edit:SetNumber(self:GetValue());
	parent.factory:SetConfigValue(parent.option.var,self:GetValue());
end

-- OnMouseWheel
local function Slider_OnMouseWheel(self,delta)
	self:SetValue(self:GetValue() + self:GetParent().option.step * delta);
end

-- create slider
azof.objects.Slider = {
	xOffset = 18,
	yOffset = 4,
	Init = function(self,option,cfgValue)
		self.slider:SetMinMaxValues(option.min,option.max);
		self.slider:SetValueStep(option.step);
		--self.slider:SetStepsPerPage(0);
		self.slider:SetValue(cfgValue);
		self.edit:SetNumber(cfgValue);
		self.low:SetText(option.min);
		self.high:SetText(option.max);
	end,
	CreateNew = function(self)
		local f = CreateFrame("Frame",nil,self.owner);
		f:SetSize(292,32);

		f.edit = CreateFrame("EditBox",GenerateObjectName("EditBox"),f,"InputBoxTemplate");
		f.edit:SetSize(45,21);
		f.edit:SetPoint("BOTTOMLEFT");
		f.edit:SetScript("OnEnterPressed",SliderEdit_OnEnterPressed);
		f.edit:SetAutoFocus(false);
		f.edit:SetMaxLetters(5);
		f.edit:SetFontObject("GameFontHighlight");

		local sliderName = GenerateObjectName("Slider");
		f.slider = CreateFrame("Slider",sliderName,f,"OptionsSliderTemplate");
		f.slider:SetPoint("TOPLEFT",f.edit,"TOPRIGHT",5,-3);
		f.slider:SetPoint("BOTTOMRIGHT",0,-2);
		f.slider:SetScript("OnValueChanged",Slider_OnValueChanged);
		f.slider:SetScript("OnMouseWheel",Slider_OnMouseWheel);
		f.slider:EnableMouseWheel(true);
		f.slider:SetObeyStepOnDrag(true);

		f.text = _G[sliderName.."Text"];
		f.text:SetTextColor(1.0,0.82,0);
		f.low = _G[sliderName.."Low"];
		f.low:ClearAllPoints();
		f.low:SetPoint("BOTTOMLEFT",f.slider,"TOPLEFT",0,0);
		f.high = _G[sliderName.."High"];
		f.high:ClearAllPoints();
		f.high:SetPoint("BOTTOMRIGHT",f.slider,"TOPRIGHT",0,0);

		return f;
	end,
};

--------------------------------------------------------------------------------------------------------
--                                            Check Button                                            --
--------------------------------------------------------------------------------------------------------

local function CheckButton_OnEnter(self)
	self.text:SetTextColor(1,1,1);
	if (self.option.tip) then
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
		GameTooltip:AddLine(self.option.label,1,1,1);
		GameTooltip:AddLine(self.option.tip,nil,nil,nil,1);
		GameTooltip:Show();
	end
end

local function CheckButton_OnLeave(self)
	self.text:SetTextColor(1,0.82,0);
	GameTooltip:Hide();
end

local function CheckButton_OnClick(self)
	self.factory:SetConfigValue(self.option.var,self:GetChecked() and true or false);	-- WoD patch made GetChecked() return bool instead of 1/nil
end

-- New CheckButton
azof.objects.Check = {
	xOffset = 10,
	yOffset = -4,
	Init = function(self,option,cfgValue)
		self:SetHitRectInsets(0,self.text:GetWidth() * -1,0,0);
		self:SetChecked(cfgValue);
	end,
	CreateNew = function(self)
		local f = CreateFrame("CheckButton",nil,self.owner);
		f:SetSize(26,26);
		f:SetScript("OnEnter",CheckButton_OnEnter);
		f:SetScript("OnClick",CheckButton_OnClick);
		f:SetScript("OnLeave",CheckButton_OnLeave);

		f:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up");
		f:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down");
	 	f:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight");
		f:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled");
		f:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check");

		f.text = f:CreateFontString("ARTWORK",nil,"GameFontNormalSmall");
		f.text:SetPoint("LEFT",f,"RIGHT",0,1);

		return f;
	end,
};

--------------------------------------------------------------------------------------------------------
--                                            Color Button                                            --
--------------------------------------------------------------------------------------------------------

-- we use this table to keep a state of the color picker instance that is active
local cpfState = {
	prevColor = CreateColor(),
};
local CPF = ColorPickerFrame;

-- Color Picker Function -- if "prevVal" is valid, then its called as cancel function
local function ColorButton_ColorPickerFunc(prevVal)
	local r, g, b, a;
	if (prevVal) then
		r, g, b, a  = prevVal:GetRGBA();
	else
		r, g, b = CPF:GetColorRGB();
		a = (1 - OpacitySliderFrame:GetValue());
	end

	-- Update frame only if its still showing this option. This can fail if the category page was changed.
	-- With our "cpfState" table, we can still keep track of the correct option though
	if (cpfState.frame.option == cpfState.option) then
		cpfState.frame.texture:SetVertexColor(r,g,b,a);
		cpfState.frame.color:SetRGBA(r,g,b,a);
	end

	-- Update color setting
	if (cpfState.option.subType == 2) then
		local hexColorMarkup = format("|c%.2x%.2x%.2x%.2x",a * 255,r * 255,g * 255,b * 255);
		cpfState.factory:SetConfigValue(cpfState.option.var,hexColorMarkup);		-- color:GenerateHexColorMarkup()
	else
		cpfState.newColor[1] = r;
		cpfState.newColor[2] = g;
		cpfState.newColor[3] = b;
		cpfState.newColor[4] = a;
		cpfState.factory:SetConfigValue(cpfState.option.var,cpfState.newColor);
	end
end

-- OnClick
local function ColorButton_OnClick(self,button)
	-- if color picker is already open, cancel it
	if (CPF:IsShown()) and (type(CPF.cancelFunc) == "function") then
		CPF.cancelFunc(CPF.previousValues);
	end

	-- get color and back them up in case of cancel
	local r, g, b, a = self.color:GetRGBA();
	cpfState.prevColor:SetRGBA(r,g,b,a);

	-- we must create a new table here to avoid overwriting old table
	if (self.option.subType ~= 2) then
		cpfState.newColor = {};
	end

	local opacity = (1 - (a or 1));

	-- these are fields the CPF uses
	CPF.func = ColorButton_ColorPickerFunc;
	CPF.cancelFunc = ColorButton_ColorPickerFunc;
	CPF.opacityFunc = ColorButton_ColorPickerFunc;
	CPF.hasOpacity = true;
	CPF.opacity = opacity;
	CPF.previousValues = cpfState.prevColor;

	-- keep a state of the active references needed for this color pick
	cpfState.frame = self;
	cpfState.option = self.option;
	cpfState.factory = self.factory;

	-- init and display the color picker
	OpacitySliderFrame:SetValue(opacity);
	CPF:SetColorRGB(r,g,b);
	CPF:Show();
end

-- OnEnter
local function ColorButton_OnEnter(self)
	self.text:SetTextColor(1,1,1);
	self.border:SetVertexColor(1,1,0);
	if (self.option.tip) then
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
		GameTooltip:AddLine(self.option.label,1,1,1);
		GameTooltip:AddLine(self.option.tip,nil,nil,nil,1);
		GameTooltip:Show();
	end
end

-- OnLeave
local function ColorButton_OnLeave(self)
	self.text:SetTextColor(1,0.82,0);
	self.border:SetVertexColor(1,1,1);
	GameTooltip:Hide();
end

-- New ColorButton
azof.objects.Color = {
	xOffset = 14,
	yOffset = 6,
	Init = function(self,option,cfgValue)
		self:SetHitRectInsets(0,self.text:GetWidth() * -1,0,0);
		if (option.subType == 2) then
			self.color:SetFromHexColorMarkup(cfgValue);
		else
			self.color:SetRGBA(unpack(cfgValue));
		end
		self.texture:SetVertexColor(self.color:GetRGBA());
	end,
	CreateNew = function(self)
		local f = CreateFrame("Button",nil,self.owner);
		f:SetSize(18,18);
		f:SetScript("OnEnter",ColorButton_OnEnter);
		f:SetScript("OnLeave",ColorButton_OnLeave)
		f:SetScript("OnClick",ColorButton_OnClick);

		f.texture = f:CreateTexture();
		f.texture:SetPoint("TOPLEFT",-1,1);
		f.texture:SetPoint("BOTTOMRIGHT",1,-1);
		f.texture:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch");
		f:SetNormalTexture(f.texture);

		f.border = f:CreateTexture(nil,"BACKGROUND");
		f.border:SetPoint("TOPLEFT");
		f.border:SetPoint("BOTTOMRIGHT");
		f.border:SetColorTexture(1,1,1,1);

		f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
		f.text:SetPoint("LEFT",f,"RIGHT",4,1);

		f.color = CreateColor();
		f.color.SetFromHexColorMarkup = SetFromHexColorMarkup;	-- extended the color object

		return f;
	end,
};

--------------------------------------------------------------------------------------------------------
--                                           DropDown Frame                                           --
--------------------------------------------------------------------------------------------------------

local function Default_SelectValue(dropDown,entry,index)
	dropDown.factory:SetConfigValue(dropDown.option.var,entry.value);
end

local function Default_Init(dropDown,list)
	dropDown.selectValueFunc = Default_SelectValue;
	for text, option in next, dropDown.option.list do
		local tbl = list[#list + 1]
		tbl.text = text; tbl.value = option;
	end
end

-- Lib Shared Media
local LSM = LibStub and LibStub("LibSharedMedia-3.0",1);

azof.LibSharedMediaSubstitute = {
	font = {
		["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF",
		["Arial Narrow"] = "Fonts\\ARIALN.TTF",
		["Skurri"] = "Fonts\\SKURRI.TTF",
		["Morpheus"] = "Fonts\\MORPHEUS.TTF",
	},
	background = {
		["Solid"] = "Interface\\Buttons\\WHITE8X8",
		--["Blizzard Chat Background"] = "Interface\\ChatFrame\\ChatFrameBackground", -- this is the same as Solid
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Background",
		["Blizzard Parchment"] = "Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal",
		["Blizzard Parchment 2"] = "Interface\\AchievementFrame\\UI-GuildAchievement-Parchment-Horizontal",
	},
	border = {
		["None"] = "Interface\\None",
		["Blizzard Dialog"]  = "Interface\\DialogFrame\\UI-DialogBox-Border",
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Border",
		["Solid"] = "Interface\\Buttons\\WHITE8X8",
	},
	statusbar = {
		["Blizzard StatusBar"] = "Interface\\TargetingFrame\\UI-StatusBar",
		["Blizzard Raid Bar"] = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
		["Blizzard Character Skills Bar"] = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar",
	},
	sound = {
		["Bell"] = "Sound\\Doodad\\BellTollHorde.ogg",
		["Murmur"] = "Sound\\Creature\\Murmur\\MurmurWoundA.ogg",
		["Alarm Warning 1"] = "Sound\\Interface\\AlarmClockWarning1.ogg",
		["Alarm Warning 2"] = "Sound\\Interface\\AlarmClockWarning2.ogg",
		["Alarm Warning 3"] = "Sound\\Interface\\AlarmClockWarning3.ogg",
		["Raid Warning"] = "Sound\\Interface\\RaidWarning.ogg",
		["Ready Check 1"] = "Sound\\Interface\\levelup2.ogg",
		["Ready Check 2"] = "Sound\\Interface\\ReadyCheck.ogg",
		["Takeoff"] = "Sound\\Universal\\FM_Takeoff.ogg",
		["Map Ping"] = "Sound\\Interface\\MapPing.ogg",
		["Auction Close"] = "Sound\\Interface\\AuctionWindowClose.ogg",
		["Auction Open"] = "Sound\\Interface\\AuctionWindowOpen.ogg",
		["Gnome Exploration"] = "Sound\\Interface\\GnomeExploration.ogg",
		["Flag Capture Horde"] = "Sound\\Interface\\PVPFlagCapturedHordeMono.ogg",
		["Flag Capture Alliance"] = "Sound\\Interface\\PVPFlagCapturedmono.ogg",
		["Flag Taken Alliance"] = "Sound\\Interface\\PVPFlagTakenHordeMono.ogg",
		["Flag Taken Horde"] = "Sound\\Interface\\PVPFlagTakenMono.ogg",
		["PvP Warning"] = "Sound\\Interface\\PVPWARNING.ogg",
		["PvP Warning Alliance"] = "Sound\\Interface\\PVPWarningAllianceMono.ogg",
		["PvP Warning Horde"] = "Sound\\Interface\\PVPWarningHordeMono.ogg",
		["LFG Denied"] = SOUNDKIT.LFG_DENIED,
	},
};

if (LSM) then
	LSM:Register("border","Solid","Interface\\Buttons\\WHITE8X8");
	for name, path in next, azof.LibSharedMediaSubstitute.statusbar do
		LSM:Register("statusbar",name,path);
	end
	for name, path in next, azof.LibSharedMediaSubstitute.sound do
		LSM:Register("sound",name,path);
	end
end

local function SharedMediaLib_SelectValue(dropDown,entry,index)
	if (dropDown.option.media == "sound") then
		(type(entry.value) == "string" and PlaySoundFile or PlaySound)(entry.value);
	end
	Default_SelectValue(dropDown,entry,index);
end

local function SharedMediaLib_Init(dropDown,list)
	local query = dropDown.option.media;
	dropDown.selectValueFunc = SharedMediaLib_SelectValue;
	if (LSM) then
		for _, name in next, LSM:List(query) do
			local tbl = list[#list + 1];
			tbl.text = name;
			tbl.value = LSM:Fetch(query,name);
			tbl.tip = tbl.value;
		end
	else
		for name, value in next, azof.LibSharedMediaSubstitute[query] do
			local tbl = list[#list + 1];
			tbl.text = name;
			tbl.value = value;
			tbl.tip = value;
		end
	end
	table.sort(list,function(a,b) return a.text < b.text end);
end

-- New DropDown
azof.objects.DropDown = {
	xOffset = 136,
	yOffset = 2,
	Init = function(self,option,cfgValue)
		self.initFunc = (option.init or option.media and SharedMediaLib_Init or Default_Init);
		self:InitSelectedItem(cfgValue);
	end,
	CreateNew = function(self)
		local f = AzDropDown:CreateDropDown(self.owner,180,nil,nil,true);
		f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
		f.text:SetPoint("LEFT",-302 + f:GetWidth(),0);
		return f;
	end,
};

--------------------------------------------------------------------------------------------------------
--                                             Text Edit                                              --
--------------------------------------------------------------------------------------------------------

-- OnTextChange
local function TextEdit_OnTextChanged(self)
	self.factory:SetConfigValue(self.option.var,self:GetText():gsub("||","|"));
end

-- New Text Edit
azof.objects.Text = {
	xOffset = 136,
	yOffset = 0,
	backdrop = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 10,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	},
	Init = function(self,option,cfgValue)
		self:SetText(cfgValue:gsub("|","||"));
	end,
	CreateNew = function(self)
		local f = CreateFrame("EditBox",nil,self.owner,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate
		f:SetSize(180,24);
		f:SetScript("OnTextChanged",TextEdit_OnTextChanged);
		f:SetScript("OnEnterPressed",f.ClearFocus);
		f:SetScript("OnEscapePressed",f.ClearFocus);
		f:SetAutoFocus(false);
		f:SetFontObject("GameFontHighlight");

		f:SetBackdrop(self.objects.Text.backdrop);
		f:SetBackdropColor(0.1,0.1,0.1,1);
		f:SetBackdropBorderColor(0.4,0.4,0.4,1);
		f:SetTextInsets(6,0,0,0);

		f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
		f.text:SetPoint("LEFT",-120,1);

		return f;
	end,
};