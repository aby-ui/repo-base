--[[
	### Rev 09 ###
	- Fixed GetChecked() now returning a boolean instead of nil/1
	### Rev 10 - 7.0.3/Legion ###
	- Changed SetTexture(r,g,b,a) -> SetColorTexture(r,g,b,a)
--]]

local REVISION = 10;
if (type(AzOptionsFactory) == "table") and (AzOptionsFactory.vers >= REVISION) then
	return;
end

AzOptionsFactory = AzOptionsFactory or {};
AzOptionsFactory.vers = REVISION;
AzOptionsFactory.makers = {};
AzOptionsFactory.objectNames = AzOptionsFactory.objectNames or {};
AzOptionsFactory.objectOffsetX = { Check = 10, Slider = 18, Color = 14, DropDown = 136, Text = 136 };
AzOptionsFactory.objectOffsetY = { Check = -4, Slider = 4, Color = 6, DropDown = 2, Text = 0 };
AzOptionsFactory.__index = AzOptionsFactory;

local ReturnZeroMeta = { __index = function() return 0; end };

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Converts string colors to RGBA
function AzOptionsFactory:HexStringToRGBA(string)
	local a, r, g, b = string:match("^|c(..)(..)(..)(..)");
	return format("%d","0x"..r) / 255, format("%d","0x"..g) / 255, format("%d","0x"..b) / 255, format("%d","0x"..a) / 255;
end

-- Generate Unique Object Name
local function GenerateObjectName(type)
	AzOptionsFactory.objectNames[type] = (AzOptionsFactory.objectNames[type] or 0) + 1;
	return "AzOptionsFactory"..type..AzOptionsFactory.objectNames[type];
end

-- Gets an existing object or creates a new one if needed
function AzOptionsFactory:GetObject(type)
	if (not self.makers[type]) then
		AzMsg("|2<ERROR>|r Invalid factory object type!");
		return;
	end
	local index = (self.objectUse[type] + 1);
	self.objectUse[type] = index;
	if (self.objects[type]) and (self.objects[type][index]) then
		return self.objects[type][index];
	else
		local obj = self.makers[type](self);
		if (not self.objects[type]) then
			self.objects[type] = {};
		end
		self.objects[type][index] = obj;
		return obj;
	end
end

-- Resets the object use and hides all objects
function AzOptionsFactory:ResetObjectUse()
	wipe(self.objectUse);
	for _, types in next, self.objects do
		for _, obj in ipairs(types) do
			obj:Hide();
		end
	end
end

-- Creates New Factory Instance -- The UNUSED parameter is a remnant from when it needed the cfg table
function AzOptionsFactory:New(owner,UNUSED,ChangeSettingFunc)
	return setmetatable({ owner = owner, objects = {}, objectUse = setmetatable({},ReturnZeroMeta), ChangeSettingFunc = ChangeSettingFunc },AzOptionsFactory);
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
	parent.factory:ChangeSettingFunc(parent.option.var,self:GetValue());
end

-- OnMouseWheel
local function Slider_OnMouseWheel(self,delta)
	self:SetValue(self:GetValue() + self:GetParent().option.step * delta);
end

-- New Slider
function AzOptionsFactory.makers:Slider()
	local f = CreateFrame("Frame",nil,self.owner);
	f:SetWidth(292);
	f:SetHeight(32);

	f.edit = CreateFrame("EditBox",GenerateObjectName("EditBox"),f,"InputBoxTemplate");
	f.edit:SetWidth(45);
	f.edit:SetHeight(21);
	f.edit:SetPoint("BOTTOMLEFT");
	f.edit:SetScript("OnEnterPressed",SliderEdit_OnEnterPressed);
	f.edit:SetAutoFocus(nil);
	f.edit:SetMaxLetters(5);
	f.edit:SetFontObject("GameFontHighlight");

	local sliderName = GenerateObjectName("Slider");
	f.slider = CreateFrame("Slider",sliderName,f,"OptionsSliderTemplate");
	f.slider:SetPoint("TOPLEFT",f.edit,"TOPRIGHT",5,-3);
	f.slider:SetPoint("BOTTOMRIGHT",0,-2);
	f.slider:SetScript("OnValueChanged",Slider_OnValueChanged);
	f.slider:SetScript("OnMouseWheel",Slider_OnMouseWheel);
	f.slider:EnableMouseWheel(1);

	f.text = _G[sliderName.."Text"];
	f.text:SetTextColor(1.0,0.82,0);
	f.low = _G[sliderName.."Low"];
	f.low:ClearAllPoints();
	f.low:SetPoint("BOTTOMLEFT",f.slider,"TOPLEFT",0,0);
	f.high = _G[sliderName.."High"];
	f.high:ClearAllPoints();
	f.high:SetPoint("BOTTOMRIGHT",f.slider,"TOPRIGHT",0,0);

	f.factory = self;
	return f;
end

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
	self.factory:ChangeSettingFunc(self.option.var,self:GetChecked() and true or false);	-- WoD patch made GetChecked() return bool instead of 1/nil
end

-- New CheckButton
function AzOptionsFactory.makers:Check()
	local f = CreateFrame("CheckButton",nil,self.owner);
	f:SetWidth(26);
	f:SetHeight(26);
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

	f.factory = self;
	return f;
end

--------------------------------------------------------------------------------------------------------
--                                            Color Button                                            --
--------------------------------------------------------------------------------------------------------

local CPF = ColorPickerFrame;
local prevColors = {};
local newColors;

-- Color Picker Function
local function ColorButton_ColorPickerFunc(prevVal)
	local r, g, b, a;
	if (prevVal) then
		r, g, b, a  = unpack(prevVal);
	else
		r, g, b = CPF:GetColorRGB();
		a = (1 - OpacitySliderFrame:GetValue());
	end
	local frame = CPF.frame;
	-- Update frame if its still showing this option
	if (frame.option == CPF.option) then
		frame.texture:SetVertexColor(r,g,b,a);
		frame.color[1], frame.color[2], frame.color[3], frame.color[4] = r, g, b, a;
	end
	-- Update color setting
	if (frame.option.subType == 2) then
		frame.factory:ChangeSettingFunc(CPF.option.var,format("|c%.2x%.2x%.2x%.2x",a * 255,r * 255,g * 255,b * 255));
	else
		newColors[1], newColors[2], newColors[3], newColors[4] = r, g, b, a;
		frame.factory:ChangeSettingFunc(CPF.option.var,newColors);
	end
end

-- OnClick
local function ColorButton_OnClick(self,button)
	local r, g, b, a = self.color[1], self.color[2], self.color[3], self.color[4];
	prevColors[1], prevColors[2], prevColors[3], prevColors[4] = r, g, b, a;
	if (self.option.subType ~= 2) then
		newColors = {};
	end
	local opacity = (1 - (a or 1));

	CPF.frame = self;
	CPF.option = self.option;

	CPF.func = ColorButton_ColorPickerFunc;
	CPF.cancelFunc = ColorButton_ColorPickerFunc;
	CPF.opacityFunc = ColorButton_ColorPickerFunc;
	CPF.hasOpacity = true;
	CPF.opacity = (opacity);
	CPF.previousValues = prevColors;

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
function AzOptionsFactory.makers:Color()
	local f = CreateFrame("Button",nil,self.owner);
	f:SetWidth(18);
	f:SetHeight(18);
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

	f.color = {};

	f.factory = self;
	return f;
end

--------------------------------------------------------------------------------------------------------
--                                           DropDown Frame                                           --
--------------------------------------------------------------------------------------------------------

-- New DropDown
function AzOptionsFactory.makers:DropDown()
	local f = AzDropDown.CreateDropDown(self.owner,180,true,nil,nil);
	f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
	f.text:SetPoint("LEFT",-302 + f:GetWidth(),0);
	f.factory = self;
	return f;
end

--------------------------------------------------------------------------------------------------------
--                                              Text Edit                                             --
--------------------------------------------------------------------------------------------------------

-- OnTextChange
local function TextEdit_OnTextChanged(self)
	self.factory:ChangeSettingFunc(self.option.var,self:GetText():gsub("||","|"));
end

-- ClearFocus -- OnEnterPressed + OnEscapePressed
local function TextEdit_ClearFocus(self)
	self:ClearFocus();
end

-- New Text Edit
function AzOptionsFactory.makers:Text()
	local f = CreateFrame("EditBox",nil,self.owner);
	f:SetWidth(180);
	f:SetHeight(24);
	f:SetScript("OnTextChanged",TextEdit_OnTextChanged);
	f:SetScript("OnEnterPressed",TextEdit_ClearFocus);
	f:SetScript("OnEscapePressed",TextEdit_ClearFocus);
	f:SetAutoFocus(nil);
	f:SetFontObject("GameFontHighlight");

	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14, insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 } });
	f:SetBackdropColor(0.1,0.1,0.1,1);
	f:SetBackdropBorderColor(0.4,0.4,0.4,1);
	f:SetTextInsets(6,0,0,0);

	f.text = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
	f.text:SetPoint("LEFT",-120,1);

	f.factory = self;
	return f;
end