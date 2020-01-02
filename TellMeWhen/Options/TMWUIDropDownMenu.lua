-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak

-- This file's code is heavily modified from Blizzard's UIDropDownMenu code.
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print



local DD = TMW:NewClass("Config_DropDownMenu_NoFrame"){
	FORCE_SCALE = nil,

	ForceScale = function(self, scale)
		self.FORCE_SCALE = scale
	end,
	
	SetFunction = function(self, func)
		self.initialize = func
	end,

	OnNewInstance_DropDownMenu_NoFrame = function(self)
		self.wrapTooltips = true
	end,
}


TMW.DROPDOWNMENU = DD
TMW.DD = DD




DD.MINBUTTONS = 0;
DD.MAXBUTTONS = 0;
DD.MAXLEVELS = 0;
DD.BUTTON_HEIGHT = 16;
DD.BORDER_HEIGHT = 7;
DD.MAX_HEIGHT = 400;
-- The current open menu
DD.OPEN_MENU = nil;
-- The current menu being initialized
DD.INIT_MENU = nil;
-- Current level shown of the open menu
DD.MENU_LEVEL = 1;
-- Current value of the open menu
DD.MENU_VALUE = nil;
-- Time to wait to hide the menu
DD.SHOW_TIME = 2;

DD.LISTS = CreateFrame("Frame", "TMWDropDowns", UIParent)

hooksecurefunc("CloseMenus", function()
	DD:CloseDropDownMenus()
end)

local function fixself(self)
	if self == DD then
		self = self:GetCurrentDropDown()
	end
	return self
end

function DD:InitializeHelper()
	-- This deals with the always tainted stuff!
	if ( self ~= DD.OPEN_MENU ) then
		DD.MENU_LEVEL = 1;
	end

	-- Set the frame that's being intialized
	DD.INIT_MENU = self
	
	-- Hide all the buttons
	local button, dropDownList;
	for i = 1, DD.MAXLEVELS, 1 do
		dropDownList = DD.LISTS[i];
		if ( i >= DD.MENU_LEVEL or self ~= DD.OPEN_MENU ) then
			dropDownList.numButtons = 0;
			dropDownList.maxWidth = 0;
			for j=1, DD.MAXBUTTONS, 1 do
				button = dropDownList[j];
				button:Hide();
			end
			dropDownList:Hide();
		end
	end
end

function DD:Initialize(initFunction, displayMode, level, menuList)
	self.menuList = menuList;

	self:InitializeHelper()
	
	-- Set the initialize function and call it.  The initFunction populates the dropdown list.
	if ( initFunction ) then
		self.initialize = initFunction;
		initFunction(self, level, self.menuList);
	end

	--master frame
	if(level == nil) then
		level = 1;
	end

	self.LISTS[level].dropdown = self;
end

-- Start the countdown on a frame
function DD.StartCounting(self)
	if self == DD then
		self = DD.LISTS[1]
	end
	if ( self.parent ) then
		DD.StartCounting(self.parent);
	else
		self.showTimer = self.dropdown.SHOW_TIME
		self.isCounting = 1;
	end
end

-- Stop the countdown on a frame
function DD.StopCounting(self)
	if self == DD then
		self = DD.LISTS[1]
	end
	if ( self.parent ) then
		DD.StopCounting(self.parent);
	else
		self.isCounting = nil;
	end
end

--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that TMW.DD.MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, true, function]  --  Check the button if true or function returns true
info.isNotRadio = [nil, true]  --  Check the button uses radial image if false check box image if true
info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.tooltipWhileDisabled = [nil, 1] -- Show the tooltip, even when the button is disabled.
info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.tooltipWrap = [nil, BOOLEAN] -- Set whether the tooltip text should wrap or not. If defined, this overrides DropDown.wrapTooltips
info.justifyH = [nil, "CENTER"] -- Justify button text
info.arg1 = [ANYTHING] -- This is the first argument used by info.func
info.arg2 = [ANYTHING] -- This is the second argument used by info.func
info.font = [STRING] -- font file replacement
info.padding = [nil, NUMBER] -- Number of pixels to pad the text on the right side
info.minWidth = [nil, NUMBER] -- Minimum width for this line
]]

local ButtonInfo = {};

function DD:CreateInfo()
	-- Reuse the same table to prevent memory churn
	
	return wipe(ButtonInfo);
end

function DD:CreateFrames(level, index)

	while ( level > DD.MAXLEVELS ) do
		DD.MAXLEVELS = DD.MAXLEVELS + 1;
		local newList = CreateFrame("Button", "$parentList" .. DD.MAXLEVELS, DD.LISTS, "TMW_UIDropDownListTemplate", DD.MAXLEVELS);
		newList:SetFrameStrata("FULLSCREEN_DIALOG");
		newList:SetToplevel(1);
		newList:Hide();
		newList:SetWidth(180)
		newList:SetHeight(10)
		for i=DD.MINBUTTONS+1, DD.MAXBUTTONS do
			newList[i] = CreateFrame("Button", nil, newList.Buttons, "TMW_UIDropDownMenuButtonTemplate", i);
			newList[i].listFrame = newList
		end
	end

	while ( index > DD.MAXBUTTONS ) do
		DD.MAXBUTTONS = DD.MAXBUTTONS + 1;
		for i=1, DD.MAXLEVELS do
			local listFrame = DD.LISTS[i]

			local button = CreateFrame("Button", nil, listFrame.Buttons, "TMW_UIDropDownMenuButtonTemplate", DD.MAXBUTTONS);
			button.listFrame = listFrame

			listFrame[DD.MAXBUTTONS] = button
		end
	end
end

function DD:AddButton(info, level)
	self = fixself(self)
	--[[
	Might to uncomment this if there are performance issues 
	if ( not self.OPEN_MENU ) then
		return;
	end
	]]
	if ( not level ) then
		level = self.MENU_LEVEL;
	end
	
	local listFrame = self.LISTS[level]
	local index = listFrame and (listFrame.numButtons + 1) or 1;
	local width;

	self:CreateFrames(level, index);
	
	listFrame = listFrame or self.LISTS[level]
	
	-- Set the number of buttons in the listframe
	listFrame.numButtons = index;
	
	local button = listFrame[index];
	local normalText = button:GetFontString();
	local icon = button.Icon;
	-- This button is used to capture the mouse OnEnter/OnLeave events if the dropdown button is disabled, since a disabled button doesn't receive any events
	-- This is used specifically for drop down menu time outs
	local invisibleButton = button.InvisibleButton;
	
	-- Default settings
	button:SetDisabledFontObject(GameFontDisableSmallLeft);
	invisibleButton:Hide();
	button:Enable();
	
	-- If not clickable then disable the button and set it white
	if ( info.notClickable ) then
		info.disabled = 1;
		button:SetDisabledFontObject(GameFontHighlightSmallLeft);
	end

	-- Set the text color and disable it if its a title
	if ( info.isTitle ) then
		info.disabled = 1;
		button:SetDisabledFontObject(GameFontNormalSmallLeft);
	end
	
	-- Disable the button if disabled and turn off the color code
	if ( info.disabled ) then
		button:Disable();
		invisibleButton:Show();
	end

	-- Configure button
	if ( info.text ) then
		button:SetText(info.text);

		-- Determine the width of the button
		width = normalText:GetWidth() + 35;
		-- Add padding if has and expand arrow
		if ( info.hasArrow ) then
			width = width + 17;
		end
		if ( info.notCheckable ) then
			width = width - 30;
		end
		-- Set icon
		if ( info.icon or info.atlas ) then
			if info.icon then
				icon:SetTexture(info.icon);

			elseif info.atlas then
				icon:SetAtlas(info.atlas);
			end
			
			if ( info.tCoordLeft ) then
				icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
			else
				icon:SetTexCoord(0, 1, 0, 1);
			end
			icon:ClearAllPoints();
			icon:SetPoint("RIGHT");
			icon:Show();
			-- Add padding for the icon
			width = width + 10;
		else
			icon:Hide();
		end
		if ( info.padding ) then
			width = width + info.padding;
		end
		width = max(width, info.minWidth or 0);
		-- Set maximum button width
		if ( width > listFrame.maxWidth ) then
			listFrame.maxWidth = width;
		end

		-- Check to see if there is a replacement font
		local font, size, flags = GameFontHighlightSmallLeft:GetFont()
		button:GetFontString():SetFont(font, size, flags);
		if ( info.font ) then
			button:GetFontString():SetFont(info.font, size, flags);
		end
	else
		button:SetText("");
		icon:Hide();
	end

	if info.texture then
		if not button.texture then
			button.texture = button:CreateTexture(nil, "BACKGROUND")
			button.texture:SetPoint("TOP", 0, -1)
			button.texture:SetPoint("BOTTOM", 0, 1)
			button.texture:SetPoint("RIGHT")
			button.texture:SetPoint("LEFT", button:GetFontString(), "LEFT", -3, 0)
		end
		button.texture:Show()
		button.texture:SetTexture(info.texture)
	elseif button.texture then
		button.texture:Hide()
	end
	
	button.icon = nil;
	button.iconInfo = nil;

	-- Pass through attributes
	button.func = info.func;
	button.owner = info.owner;
	button.keepShownOnClick = info.keepShownOnClick;
	button.tooltipTitle = info.tooltipTitle;
	button.tooltipText = info.tooltipText;
	button.tooltipWrap = info.tooltipWrap;
	button.arg1 = info.arg1;
	button.arg2 = info.arg2;
	button.hasArrow = info.hasArrow;
	button.notCheckable = info.notCheckable;
	button.menuList = info.menuList;
	button.tooltipWhileDisabled = info.tooltipWhileDisabled;
	button.padding = info.padding;
	
	if ( info.value ) then
		button.value = info.value;
	elseif ( info.text ) then
		button.value = info.text;
	else
		button.value = nil;
	end
	
	-- Show the expand arrow if it has one
	if ( info.hasArrow ) then
		button.ExpandArrow:Show();
	else
		button.ExpandArrow:Hide();
	end
	button.hasArrow = info.hasArrow;
	
	-- If not checkable move everything over to the left to fill in the gap where the check would be
	local xPos = 0;
	local yPos = -((button:GetID() - 1) * self.BUTTON_HEIGHT) -- - DD.BORDER_HEIGHT;
	local displayInfo = normalText;
	
	displayInfo:ClearAllPoints();
	if ( info.notCheckable ) then
		if ( info.justifyH and info.justifyH == "CENTER" ) then
			displayInfo:SetPoint("CENTER", button, "CENTER", -7, 0);
		else
			displayInfo:SetPoint("LEFT", button, "LEFT", 0, 0);
		end
		xPos = xPos + 6;
		
	else
		xPos = xPos + 7;
		displayInfo:SetPoint("LEFT", button, "LEFT", 20, 0);
	end
	
	button:SetHeight(self.BUTTON_HEIGHT)
	button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);


	if not info.notCheckable then 
		if info.isNotRadio then
			button.Check:SetTexCoord(0.0, 0.5, 0.0, 0.5);
			button.UnCheck:SetTexCoord(0.5, 1.0, 0.0, 0.5);
		else
			button.Check:SetTexCoord(0.0, 0.5, 0.5, 1.0);
			button.UnCheck:SetTexCoord(0.5, 1.0, 0.5, 1.0);
		end
		
		-- Checked can be a function now
		local checked = info.checked;
		if ( type(checked) == "function" ) then
			checked = checked(button);
		end

		-- Show the check if checked
		if ( checked ) then
			button:LockHighlight();
			button.Check:Show();
			button.UnCheck:Hide();
		else
			button:UnlockHighlight();
			button.Check:Hide();
			button.UnCheck:Show();
		end
	else
		button.Check:Hide();
		button.UnCheck:Hide();
	end	
	button.checked = info.checked;

	local height = (index * self.BUTTON_HEIGHT) + (self.BORDER_HEIGHT * 2)
	if height > self.MAX_HEIGHT and self:GetScrollable() then
		height = self.MAX_HEIGHT
		listFrame.shouldScroll = true
	else
		listFrame.shouldScroll = false
	end

	listFrame:SetHeight(height);

	button:Show();
end

local spacerInfo = {
	text = "",
	isTitle = true,
	notCheckable = true,
}
function DD:AddSpacer()
	self:AddButton(spacerInfo)
end



function DD.Button_OnClick(self)
	local checked = self.checked;
	if ( type (checked) == "function" ) then
		checked = checked(self);
	end
	

	if ( self.keepShownOnClick ) then
		if not self.notCheckable then
			if ( checked ) then
				self.Check:Hide();
				self.UnCheck:Show();
				checked = false;
			else
				self.Check:Show();
				self.UnCheck:Hide();
				checked = true;
			end
		end
	else
		self.listFrame:Hide();
	end

	if ( type (self.checked) ~= "function" ) then 
		self.checked = checked;
	end

	local func = self.func;
	if ( func ) then
		func(self, self.arg1, self.arg2, checked);
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	end

end

function DD:HideDropDownMenu(level)
	local listFrame = DD.LISTS[level];
	listFrame:Hide();
end

function DD:Toggle(level, value, anchorName, xOffset, yOffset, menuList, button, autoHideDelay)
	local dropDownFrame = self

	if ( not level ) then
		level = 1;
	end

	DD:CreateFrames(level, 0);

	DD.MENU_LEVEL = level;
	DD.MENU_VALUE = value;
	local listFrame = DD.LISTS[level]

	local point, relativePoint, relativeTo;

	if ( listFrame:IsShown() and (DD.OPEN_MENU == (dropDownFrame or button:GetParent())) ) then
		listFrame:Hide();
	else
		-- Set the dropdownframe scale
		local uiScale;
		local uiParentScale = UIParent:GetScale();

		if ( GetCVar("useUIScale") == "1" ) then
			uiScale = tonumber(GetCVar("uiscale"));
			if ( uiParentScale < uiScale ) then
				uiScale = uiParentScale;
			end
		else
			uiScale = uiParentScale;
		end

		-- Hide the listframe anyways since it is redrawn OnShow() 
		listFrame:Hide();
		
		-- Frame to anchor the dropdown menu to
		local anchorFrame;

		-- Display stuff
		-- Level specific stuff
		if ( level == 1 ) then	
			DD.OPEN_MENU = dropDownFrame
			if self.FORCE_SCALE then
				TMWDropDowns:SetScale(self.FORCE_SCALE)
			else
				TMWDropDowns:SetScale(1)
				for _, frame in TMW:Vararg(dropDownFrame, anchorName) do
					if type(frame) == "table" and frame.GetEffectiveScale then
						TMWDropDowns:SetScale(frame:GetEffectiveScale() / TMWDropDowns:GetParent():GetScale())
						break
					end
				end
			end

			listFrame:ClearAllPoints();
			-- If there's no specified anchorName then use left side of the dropdown menu
			if ( not anchorName ) then
				-- See if the anchor was set manually using setanchor
				if ( dropDownFrame.xOffset ) then
					xOffset = dropDownFrame.xOffset;
				end
				if ( dropDownFrame.yOffset ) then
					yOffset = dropDownFrame.yOffset;
				end
				if ( dropDownFrame.point ) then
					point = dropDownFrame.point;
				end
				if ( dropDownFrame.relativeTo ) then
					relativeTo = dropDownFrame.relativeTo;
				else
					relativeTo = DD.OPEN_MENU;
				end
				if ( dropDownFrame.relativePoint ) then
					relativePoint = dropDownFrame.relativePoint;
				end
			elseif ( anchorName == "cursor" ) then
				relativeTo = nil;
				local cursorX, cursorY = GetCursorPosition();
				cursorX = cursorX/TMWDropDowns:GetScale();
				cursorY = cursorY/TMWDropDowns:GetScale();

				if ( not xOffset ) then
					xOffset = 0;
				end
				if ( not yOffset ) then
					yOffset = 0;
				end
				xOffset = cursorX + xOffset;
				yOffset = cursorY + yOffset;
			else
				-- See if the anchor was set manually using setanchor
				if ( dropDownFrame.xOffset ) then
					xOffset = dropDownFrame.xOffset;
				end
				if ( dropDownFrame.yOffset ) then
					yOffset = dropDownFrame.yOffset;
				end
				if ( dropDownFrame.point ) then
					point = dropDownFrame.point;
				end
				if ( dropDownFrame.relativeTo ) then
					relativeTo = dropDownFrame.relativeTo;
				else
					relativeTo = anchorName;
				end
				if ( dropDownFrame.relativePoint ) then
					relativePoint = dropDownFrame.relativePoint;
				end
			end
			if ( not xOffset or not yOffset ) then
				xOffset = 2;
				yOffset = 0;
			end
			if ( not point ) then
				point = "TOPLEFT";
			end
			if ( not relativePoint ) then
				relativePoint = "BOTTOMLEFT";
			end
			listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
		else
			if ( not dropDownFrame ) then
				dropDownFrame = DD.OPEN_MENU;
			end
			listFrame:ClearAllPoints();
			anchorFrame = button;
			point = "TOPLEFT";
			relativePoint = "TOPRIGHT";
			listFrame:SetPoint(point, anchorFrame, relativePoint, 0, 0);
		end
		

		dropDownFrame.menuList = menuList;
		DD.Initialize(dropDownFrame, dropDownFrame.initialize, nil, level, menuList);
		-- If no items in the drop down don't show it
		if ( listFrame.numButtons == 0 ) then
			return;
		end

		-- Check to see if the dropdownlist is off the screen, if it is anchor it to the top of the dropdown button
		listFrame:Show();

		local success, left, bottom, width, height = pcall(listFrame.GetRect, listFrame)
		if not success then
			-- Anchor target is restricted. Just do our best.
			width, height = listFrame:GetSize()
			left, bottom = GetCursorPosition()
		end

		-- Hack since GetCenter() is returning coords relative to 1024x768
		local x, y = left + (width/2), bottom + (height/2);
		-- Hack will fix this in next revision of dropdowns
		if ( not x or not y ) then
			listFrame:Hide();
			return;
		end

		listFrame.onHide = dropDownFrame.onHide;
		
		
		--  We just move level 1 enough to keep it on the screen. We don't necessarily change the anchors.
		if level == 1 then
			local scale = TMWDropDowns:GetScale()

			local offLeft = left -- / scale
			local offRight = (GetScreenWidth() - (left + width) * scale) / scale
			local offTop = (GetScreenHeight() - (bottom + height) * scale) / scale
			local offBottom = bottom -- * scale
			
			local xAddOffset, yAddOffset = 0, 0;
			if ( offLeft < 0 ) then
				xAddOffset = -offLeft;
			elseif ( offRight < 0 ) then
				xAddOffset = offRight;
			end
			
			if ( offTop < 0 ) then
				yAddOffset = offTop;
			elseif ( offBottom < 0 ) then
				yAddOffset = -offBottom;
			end
			
			listFrame:ClearAllPoints();
			listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset);
		else
			-- Determine whether the menu is off the screen or not
			local offscreenY, offscreenX;
			if (y - height/2) < 0 then
				offscreenY = true;
			end
			if (left + width) > GetScreenWidth() then
				offscreenX = true;	
			end

			xOffset = 3;
			yOffset = 6;

			if offscreenY then
				point = gsub(point, "TOP(.*)", "BOTTOM%1");
				relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
				yOffset = -6;
			end

			if offscreenX then
				point = gsub(point, "(.*)LEFT", "%1RIGHT");
				relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
				xOffset = -8;
			end
			
			listFrame:ClearAllPoints();
			listFrame:SetPoint(point, anchorFrame, relativePoint, xOffset, yOffset);

			listFrame:SetFrameLevel(DD.LISTS[level-1]:GetFrameLevel() + 10)
		end

		if ( autoHideDelay and tonumber(autoHideDelay)) then
			listFrame.showTimer = autoHideDelay;
			listFrame.isCounting = 1;
		end
	end
end

function DD:CloseDropDownMenus(level)
	if ( not level ) then
		level = 1;
	end
	for i=level, DD.MAXLEVELS do
		DD.LISTS[i]:Hide();
	end
end

function DD:SetDropdownAnchor(point, relativeTo, relativePoint, xOffset, yOffset)
	self.xOffset = xOffset;
	self.yOffset = yOffset;
	self.point = point;
	self.relativeTo = relativeTo;
	self.relativePoint = relativePoint;
end

function DD:GetCurrentDropDown()
	if ( DD.OPEN_MENU ) then
		return DD.OPEN_MENU;
	elseif ( DD.INIT_MENU ) then
		return DD.INIT_MENU;
	end
end

function DD:SetScrollable(scrollable, maxHeight)
	self = fixself(self)

	self.scrollable = scrollable
	self.MAX_HEIGHT = maxHeight
end

function DD:GetScrollable()
	self = fixself(self)
	
	return self.scrollable
end


WorldFrame:HookScript("OnMouseDown", function()
	DD:CloseDropDownMenus()
end)







local DD_Frame = TMW:NewClass("Config_DropDownMenu", "Config_Frame", "Config_DropDownMenu_NoFrame"){
	OnNewInstance_DropDownMenu = function(self)
		self.Button:SetMotionScriptsWhileDisabled(false)
		self.wrapTooltips = true
	end,

	SetTexts = function(self, title, tooltip)
		self:SetTooltip(title, tooltip)
		self:SetText(title)
	end,

	SetLabel = function(self, title)
		self.Label:SetText(title)
	end,

	SetUIDropdownText = function(self, value, tbl, text)
		self.selectedValue = value

		if tbl then
			for k, v in pairs(tbl) do
				if v.value == value then
					self:SetText(v.text)
					return v
				end
			end
		end
		self:SetText(text or value)
	end,
}

function DD_Frame:SetText(text)
	self.Text:SetText(text)
end

function DD_Frame:SetTexture(...)
	self.Background:SetTexture(...)
end

function DD_Frame:GetText()
	return self.Text:GetText()
end

function DD_Frame:OnDisable()
	self.Text:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	self.Button:Disable();
	self.Enabled = false;
end

function DD_Frame:OnEnable()
	self.Text:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	self.Button:Enable();
	self.Enabled = true;
end

function DD_Frame:JustifyText(justification)
	local text = self.Text
	text:ClearAllPoints();
	if ( justification == "LEFT" ) then
		text:SetPoint("LEFT", self.Background, "LEFT", 27, 1);
		text:SetJustifyH("LEFT");
	elseif ( justification == "RIGHT" ) then
		text:SetPoint("RIGHT", self.Background, "RIGHT", -43, 1);
		text:SetJustifyH("RIGHT");
	elseif ( justification == "CENTER" ) then
		text:SetPoint("CENTER", self.Background, "CENTER", -5, 1);
		text:SetJustifyH("CENTER");
	end
end




--------------------------
-- Easy Functions
--------------------------


local function EasyFunction_OnClick(button, dropdown)
	local settings = dropdown:GetSettingTable()
	if not settings or not dropdown.setting then
		error("couldn't get setting or settings table for easy function dropdown " .. (dropdown:GetParentKey() or dropdown:GetName() or "???"))
	end

	settings[dropdown.setting] = button.value

	dropdown:CloseDropDownMenus()
	dropdown:OnSettingSaved()
end
local function EasyFunction(self)
	local settings = self:GetSettingTable()
	for k, v in self.dataGenerator() do
		local info = self:CreateInfo()

		info.arg1 = self
		info.func = self.clickFunction or EasyFunction_OnClick

		self.buttonGenerator(info, k, v)

		if info.checked == nil and settings and self.setting ~= nil then
			info.checked = settings[self.setting] == info.value
		end

		self:AddButton(info)
	end
end

function DD_Frame:SetEasyTitlePrepend(easyTitlePrepend)
	self.easyTitlePrepend = easyTitlePrepend
end

function DD_Frame:SetEasyFunctions(dataGenerator, buttonGenerator, clickFunction)
	self.dataGenerator = dataGenerator
	self.buttonGenerator = buttonGenerator
	self.clickFunction = clickFunction

	self:SetFunction(EasyFunction)
end

function DD_Frame:ReloadSetting()
	local settings = self:GetSettingTable()

	if settings
	and self.setting
	and self.dataGenerator
	and self.buttonGenerator
	then
		for k, v in self.dataGenerator() do
			local info = self:CreateInfo()
			self.buttonGenerator(info, k, v)

			if info.value == settings[self.setting] then

				local text = info.text
				if self.easyTitlePrepend then
					text = "|cff666666" .. self.easyTitlePrepend .. ": |r" .. text
				end
				self:SetText(text)

				if info.font then
					local oldFont, size, flags = self.Text:GetFont()
					self.Text:SetFont(info.font or oldFont, size, flags)
				end
				if info.texture then
					self:SetTexture(info.texture)
				end

				return
			end
		end
		
		self:SetText(settings[self.setting])
	end
end







TMW:NewClass("Config_DropDownMenu_Icon", "Config_DropDownMenu"){
	previewSize = 18,

	OnNewInstance_DropDownMenu_Icon = function(self, data)
		self:SetPreviewSize(self.previewSize)
	end,

	SetPreviewSize = function(self, size)
		self.previewSize = size
		self.IconPreview:SetSize(size, size)
		self.Background:SetPoint("TOPLEFT", size + 2, 0)
	end,


	SetUIDropdownGUIDText = function(self, GUID, text)
		self.selectedValue = GUID

		local owner = TMW:GetDataOwner(GUID)
		local type = TMW:ParseGUID(GUID)

		if owner then
			if type == "icon" then
				local icon = owner

				self:SetText(icon:GetIconMenuText())

				return icon

			elseif type == "group" then
				local group = owner

				self:SetText(group:GetGroupName())

				return group
			end

		elseif GUID and GUID ~= "" then
			if type == "icon" then
				text = L["UNKNOWN_ICON"]

				local ics = TMW:GetSettingsFromGUID(GUID)
				if ics then
					text = TMW:GetIconMenuText(ics)
				end
			elseif type == "group" then
				text = L["UNKNOWN_GROUP"]
			else
				text = L["UNKNOWN_UNKNOWN"]
			end
		end
		
		self:SetText(text)
	end,

	SetIconPreviewIcon = function(self, GUID)
		local icon = TMW:GetDataOwner(GUID)
		local type = TMW:ParseGUID(GUID)

		self.IconPreview:Hide()
		if type ~= "icon" then
			return
		end

		local title, desc, texture
		if not icon then
			local ics, _, gs, domain, groupID, iconID = TMW:GetSettingsFromGUID(GUID)
			if not ics then return end

			texture = TMW:GuessIconTexture(ics)
			title = L["GROUPICON"]:format(TMW:GetGroupName(gs.Name, groupID, 1), iconID)

			self.IconPreview.texture:SetTexture(tex)
		else
			desc = L["ICON_TOOLTIP2NEWSHORT"]
			title = icon:GetIconName()
			texture = icon and icon.attributes.texture
		end

		if TMW.db.global.ShowGUIDs then
			if not desc then
				desc = ""
			end
			desc = desc .. "\r\n\r\n|cffffffff" .. GUID .. (icon and ("\r\n" .. icon.group:GetGUID()) or "")
		end
		TMW:TT(self.IconPreview, title, desc, 1, 1)
		self.IconPreview.icon = icon
		self.IconPreview.texture:SetTexture(texture)
		self.IconPreview:Show()
	end,

	SetGUID = function(self, GUID)
		local icon = TMW.GUIDToOwner[GUID]

		self:SetUIDropdownGUIDText(GUID, L["CHOOSEICON"])
		self:SetIconPreviewIcon(GUID)
	end,

	SetIcon = function(self, icon)
		local GUID = icon:GetGUID()

		self:SetUIDropdownGUIDText(GUID, L["CHOOSEICON"])
		self:SetIconPreviewIcon(GUID)
	end,

}