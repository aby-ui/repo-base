
local Mixin,CreateFromMixins,CreateFrame,_G = Mixin,CreateFromMixins,CreateFrame,_G;
local TOOLTIP_DEFAULT_COLOR,select = TOOLTIP_DEFAULT_COLOR,select;
local TOOLTIP_DEFAULT_BACKGROUND_COLOR = TOOLTIP_DEFAULT_BACKGROUND_COLOR;
local NORMAL_FONT_COLOR,HIGHLIGHT_FONT_COLOR,BLACK_FONT_COLOR = NORMAL_FONT_COLOR,HIGHLIGHT_FONT_COLOR,BLACK_FONT_COLOR;
local BackdropTemplateMixin = BackdropTemplateMixin;
local GetPhysicalScreenSize = GetPhysicalScreenSize;
local Round,Lerp,min,max = Round,Lerp,min,max;
local ClampedPercentageBetween = ClampedPercentageBetween;
local PixelUtil,type,print,tinsert = PixelUtil,type,print,tinsert;

setfenv(1,LibStub("LibDropDownMenu"));

if not PixelUtil then -- classic compatibilty
	PixelUtil = {};

	function PixelUtil.GetPixelToUIUnitFactor()
		local physicalWidth, physicalHeight = GetPhysicalScreenSize();
		return 768.0 / physicalHeight;
	end

	function PixelUtil.GetNearestPixelSize(uiUnitSize, layoutScale, minPixels)
		if uiUnitSize == 0 and (not minPixels or minPixels == 0) then
			return 0;
		end

		local uiUnitFactor = PixelUtil.GetPixelToUIUnitFactor();
		local numPixels = Round((uiUnitSize * layoutScale) / uiUnitFactor);
		if minPixels then
			if uiUnitSize < 0.0 then
				if numPixels > -minPixels then
					numPixels = -minPixels;
				end
			else
				if numPixels < minPixels then
					numPixels = minPixels;
				end
			end
		end

		return numPixels * uiUnitFactor / layoutScale;
	end

	function PixelUtil.SetWidth(region, width, minPixels)
		region:SetWidth(PixelUtil.GetNearestPixelSize(width, region:GetEffectiveScale(), minPixels));
	end

	function PixelUtil.SetHeight(region, height, minPixels)
		region:SetHeight(PixelUtil.GetNearestPixelSize(height, region:GetEffectiveScale(), minPixels));
	end

	function PixelUtil.SetSize(region, width, height, minWidthPixels, minHeightPixels)
		PixelUtil.SetWidth(region, width, minWidthPixels);
		PixelUtil.SetHeight(region, height, minHeightPixels);
	end

	function PixelUtil.SetPoint(region, point, relativeTo, relativePoint, offsetX, offsetY, minOffsetXPixels, minOffsetYPixels)
		region:SetPoint(point, relativeTo, relativePoint,
			PixelUtil.GetNearestPixelSize(offsetX, region:GetEffectiveScale(), minOffsetXPixels),
			PixelUtil.GetNearestPixelSize(offsetY, region:GetEffectiveScale(), minOffsetYPixels)
		);
	end

	function PixelUtil.SetStatusBarValue(statusBar, value)
		local width = statusBar:GetWidth();
		if width and width > 0.0 then
			local min, max = statusBar:GetMinMaxValues();
			local percent = ClampedPercentageBetween(value, min, max);
			if percent == 0.0 or percent == 1.0 then
				statusBar:SetValue(value);
			else
				local numPixels = PixelUtil.GetNearestPixelSize(statusBar:GetWidth() * percent, statusBar:GetEffectiveScale());
				local roundedValue = Lerp(min, max, numPixels / width);
				statusBar:SetValue(roundedValue);
			end
		else
			statusBar:SetValue(value);
		end
	end
end


-- lua replacement of UIDropDownCustomMenuEntryTemplate
function Create_DropDownCustomMenuEntry(name,parent,opts)
	local frame = CreateFrame("frame",name,parent);
	Mixin(frame,UIDropDownCustomMenuEntryMixin);
	frame:EnableMouse(true);
	frame:Hide();
	frame:SetScript("OnEnter",frame.OnEnter);
	frame:SetScript("OnLeave",frame.OnLeave);
end


-- lua replacement of ColorSwatchTemplate
local function ColorSwatch_OnClick(self)
	CloseDropDownMenus();
	UIDropDownMenuButton_OpenColorPicker(self:GetParent());
end

local function ColorSwatch_OnEnter(self)
	CloseDropDownMenus(self:GetParent():GetParent():GetID() + 1);
	self.SwatchBg:SetVertexColor(NORMAL_FONT_COLOR:GetRGB());
end

local function ColorSwatch_OnLeave(self)
	self.SwatchBg:SetVertexColor(HIGHLIGHT_FONT_COLOR:GetRGB());
end

function Create_ColorSwatch(name, parent, opts)
	local colorswatch = CreateFrame("Button",name,parent);

	colorswatch:Hide();
	colorswatch:SetSize(16,16);
	colorswatch:SetScript("OnClick",ColorSwatch_OnClick);
	colorswatch:SetScript("OnEnter",ColorSwatch_OnEnter);
	colorswatch:SetScript("OnLeave",ColorSwatch_OnLeave);

	colorswatch.SwatchBg = colorswatch:CreateTexture(name.."SwatchBg","BACKGROUND",nil,-3);
	colorswatch.SwatchBg:SetPoint("CENTER");
	colorswatch.SwatchBg:SetVertexColor(HIGHLIGHT_FONT_COLOR:GetRGB());

	colorswatch.InnerBorder = colorswatch:CreateTexture(name.."InnerBorder","BACKGROUND",nil,-2);
	colorswatch.InnerBorder:SetPoint("CENTER");
	colorswatch.InnerBorder:SetVertexColor(BLACK_FONT_COLOR:GetRGB());

	colorswatch.Color = colorswatch:CreateTexture(name.."Color","BACKGROUND",nil,-1);
	colorswatch.Color:SetPoint("CENTER");
	colorswatch.Color:SetVertexColor(HIGHLIGHT_FONT_COLOR:GetRGB());

	PixelUtil.SetSize(colorswatch.SwatchBg,14,14);
	PixelUtil.SetSize(colorswatch.InnerBorder,12,12);
	PixelUtil.SetSize(colorswatch.Color,10,10);

	return colorswatch;
end


-- lua replacement of UIDropDownMenuButtonTemplate
local function MenuButton_OnEnable(self)
	self.invisibleButton:Hide();
end
local function MenuButton_OnDisable(self)
	self.invisibleButton:Show();
end

function Create_DropDownMenuButton(name,parent,opts)
	local button = CreateFrame("Button",name,parent);
	button:SetSize(100,16);
	button:SetFrameLevel(parent:GetFrameLevel()+2);

	if opts then
		if opts.id then
			button:SetID(opts.id);
		end
	end

	-- <Layers>
		-- <Layer>
	local highlight = button:CreateTexture(name.."Highlight","BACKGROUND");
	highlight:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]]);
	highlight:SetBlendMode("ADD");
	highlight:SetAllPoints();
	highlight:Hide();
	button.Highlight = highlight;
		-- </Layer>

		-- <Layer>
			-- <Texture>
	local check = button:CreateTexture(name.."Check","ARTWORK");
	check:SetTexture([[Interface\Common\UI-DropDownRadioChecks]]);
	check:SetSize(16,16);
	check:SetPoint("LEFT",0,0);
	check:SetTexCoord(0,0.5,0.5,1);
	button.Check = check;
			-- </Texture>

			-- <Texture>
	local uncheck = button:CreateTexture(name.."UnCheck","ARTWORK");
	uncheck:SetTexture([[Interface\Common\UI-DropDownRadioChecks]]);
	uncheck:SetSize(16,16);
	uncheck:SetPoint("LEFT",0,0);
	uncheck:SetTexCoord(0.5,1,0.5,1);
	button.UnCheck = uncheck;
			-- </Texture>

			-- <Texture>
	local icon = button:CreateTexture(name.."Icon","ARTWORK");
	icon:Hide();
	icon:SetSize(16,16);
	icon:SetPoint("RIGHT",0,0);
	if icon.SetScript then -- added with dragonflight
		icon:SetScript("OnEnter",UIDropDownMenuButtonIcon_OnEnter);
		icon:SetScript("OnLeave",UIDropDownMenuButtonIcon_OnLeave);
		icon:SetScript("OnMouseUp",function(self,button)
			if ( button == "LeftButton" ) then
				UIDropDownMenuButtonIcon_OnClick(self, button);
			end
		end);
	end
	button.Icon = icon;
			-- </Texture>
		-- </Layer>
	-- </Layers>

	-- <Frames>
		-- <Button>
	local color = Create_ColorSwatch(name.."ColorSwatch",button);
	color:SetPoint("RIGHT",-6,0);
	button.ColorSwatch = color;
		-- </Button>
		-- <DropDownToggleButton>
	local expandArrow = CreateFrame("Button",name.."ExpandArrow",button);
	Mixin(expandArrow,DropDownExpandArrowMixin);
	expandArrow:SetMotionScriptsWhileDisabled(true);
	expandArrow:SetSize(16,16);
	expandArrow:SetPoint("RIGHT",0,0);
	expandArrow:SetScript("OnClick",expandArrow.OnMouseDown);
	expandArrow:SetScript("OnEnter",expandArrow.OnEnter);
	button.ExpandArrow = expandArrow;

	local arrow = expandArrow:CreateTexture(nil,"ARTWORK");
	arrow:SetTexture([[Interface\ChatFrame\ChatFrameExpandArrow]]);
	arrow:SetAllPoints();
		-- </DropDownToggleButton>
		-- <Button>
	button.invisibleButton = CreateFrame("Button",name.."InvisibleButton",button);
	button.invisibleButton:Hide();
	button.invisibleButton:SetPoint("TOPLEFT");
	button.invisibleButton:SetPoint("BOTTOMLEFT");
	button.invisibleButton:SetPoint("RIGHT",color,"LEFT",0,0);
	button.invisibleButton:SetScript("OnEnter",UIDropDownMenuButtonInvisibleButton_OnEnter);
	button.invisibleButton:SetScript("OnLeave",UIDropDownMenuButtonInvisibleButton_OnLeave);
		-- </Button>
	-- </Frames>

	-- <Scripts>
	button:SetScript("OnClick",UIDropDownMenuButton_OnClick);
	button:SetScript("OnEnter",UIDropDownMenuButton_OnEnter);
	button:SetScript("OnLeave",UIDropDownMenuButton_OnLeave);
	button:SetScript("OnEnable",MenuButton_OnEnable);
	button:SetScript("OnDisable",MenuButton_OnDisable);
	-- </Scripts>

	-- <ButtonText>
	button.NormalText = button:CreateFontString(name.."NormalText","ARTWORK");
	button.NormalText:SetPoint("LEFT",-5,0);
	button:SetFontString(button.NormalText);
	-- </ButtonText>

	button:SetNormalFontObject("GameFontHighlightSmallLeft")
	button:SetHighlightFontObject("GameFontHighlightSmallLeft");
	button:SetDisabledFontObject("GameFontDisableSmallLeft");

	return button;
end


-- lua replacement of DropDownMenuListTemplate
local function List_OnClick(self)
	self:Hide();
end

function Create_DropDownList(name,parent,opts)
	local list = CreateFrame("Button",name,parent);

	list:Hide();
	list:SetToplevel(true);
	list:SetFrameStrata("FULLSCREEN_DIALOG");
	list:EnableMouse(true);
	list:SetClampedToScreen(true);
	list:SetScript("OnClick",List_OnClick);
	list:SetScript("OnUpdate",UIDropDownMenu_OnUpdate);
	list:SetScript("OnShow",UIDropDownMenu_OnShow);
	list:SetScript("OnHide",UIDropDownMenu_OnHide);

	if opts then
		if opts.id then
			list:SetID(opts.id);
		end
	end

	local backdrop = CreateFrame("Frame",name.."Backdrop",list,BackdropTemplateMixin and "BackdropTemplate" or nil);
	backdrop:SetAllPoints();
	backdrop:SetBackdrop({
		bgFile=[[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		edgeFile=[[Interface\DialogFrame\UI-DialogBox-Border]],
		tile=true, tileSize=32, edgeSize=32,
		insets = {left=11, right=12, top=12, bottom=9}
	});

	local menuBackdrop = CreateFrame("Frame",name.."MenuBackdrop",list,BackdropTemplateMixin and "BackdropTemplate" or nil);
	menuBackdrop:SetAllPoints();
	menuBackdrop:SetBackdrop({
		bgFile=[[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile=[[Interface\Tooltips\UI-Tooltip-Border]],
		tile=true, edgeSize=16, tileSize=16,
		insets={left=5, right=5, top=5, bottom=4}
	});
	menuBackdrop:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	menuBackdrop:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);

	Create_DropDownMenuButton(name.."Button1",list,{id=1});

	if not UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT then
		local fontName, fontHeight, fontFlags = _G["LibDropDownMenu_List1Button1NormalText"]:GetFont();
		UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontHeight;
	end

	return list;
end


-- lua replacement of UIDropDownMenuButtonScriptTemplate
function Create_DropDownMenuButtonScript(name,parent,mixin)
	local button = CreateFrame("DropDownToggleButton",name,parent);
	Mixin(button,mixin or DropDownMenuButtonMixin);
	button:SetMotionScriptsWhileDisabled(true);
	button:SetScript("OnMouseDown",button.OnMouseDown);
	button:SetScript("OnEnter",button.OnEnter);
	button:SetScript("OnLeave",button.OnLeave);
	return button;
end


-- lua replacement of UIDropDownMenuTemplate
local function Menu_OnHide()
	CloseDropDownMenus();
end

function Create_DropDownMenu(name,parent,opts)
	local menu = CreateFrame("Frame",name);

	menu:SetSize(40,32);
	menu:SetScript("OnHide",Menu_OnHide);

	if opts then
		if opts.id then
			menu:SetID(opts.id);
		end
	end

	-- <Layers>
		-- <Layer>
	menu.Left = menu:CreateTexture(name.."Left","ARTWORK");
	menu.Left:SetSize(25,64);
	menu.Left:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	menu.Left:SetTexCoord(0,0.1953125,0,1);
	menu.Left:SetPoint("TOPLEFT",0,17);

	menu.Middle = menu:CreateTexture(name.."Middle","ARTWORK");
	menu.Middle:SetSize(115,64);
	menu.Middle:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	menu.Middle:SetTexCoord(0.1953125,0.8046875,0,1);
	menu.Middle:SetPoint("LEFT",menu.Left,"RIGHT",0,0);

	menu.Right = menu:CreateTexture(name.."Right","ARTWORK");
	menu.Right:SetSize(25,64);
	menu.Right:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	menu.Right:SetTexCoord(0.8046875,1,0,1);
	menu.Right:SetPoint("LEFT",menu.Middle,"RIGHT",0,0);

	menu.Text = menu:CreateFontString(name.."Text","ARTWORK","GameFontHighlightSmall");
	menu.Text:SetNonSpaceWrap(false);
	menu.Text:SetJustifyH("RIGHT");
	menu.Text:SetSize(0,10);
	menu.Text:SetPoint("RIGHT",menu.Right,"RIGHT",-43,2);
		-- </Layer>

		-- <Layer>
	menu.Icon = menu:CreateTexture(name.."Icon","OVERLAY");
	menu.Icon:Hide();
	menu.Icon:SetSize(16,16);
	menu.Icon:SetPoint("LEFT",30,2);
		-- </Layer>
	-- </Layers>

	-- <Frames>
		-- <DropDownToggleButton>
	local buttonName = name.."Button";
	menu.Button = Create_DropDownMenuButtonScript(buttonName,menu);
	menu.Button:SetSize(24,24);
	menu.Button:SetPoint("TOPRIGHT",menu.Right,"TOPRIGHT",-16,-18);
			-- <Layers>
				-- <Layer>
	menu.Button.NormalTexture = menu.Button:CreateTexture(buttonName.."NormalTexture","ARTWORK");
	menu.Button.NormalTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]]);
	menu.Button.NormalTexture:SetAllPoints();
	menu.Button:SetNormalTexture(menu.Button.NormalTexture);

	menu.Button.PushedTexture = menu.Button:CreateTexture(buttonName.."PushedTexture","ARTWORK");
	menu.Button.PushedTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]]);
	menu.Button.PushedTexture:SetAllPoints();
	menu.Button:SetPushedTexture(menu.Button.PushedTexture);

	menu.Button.DisabledTexture = menu.Button:CreateTexture(buttonName.."DisabledTexture","ARTWORK");
	menu.Button.DisabledTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]]);
	menu.Button.DisabledTexture:SetAllPoints();
	menu.Button:SetDisabledTexture(menu.Button.DisabledTexture);

	menu.Button.HighlightTexture = menu.Button:CreateTexture(buttonName.."HighlightTexture","ARTWORK");
	menu.Button.HighlightTexture:SetTexture([[Interface\ChatFrame\UI-Common-MouseHilight]],"ADD");
	menu.Button.HighlightTexture:SetAllPoints();
	menu.Button:SetHighlightTexture(menu.Button.HighlightTexture,"ADD");
				-- </Layer>
			-- </Layers>
		-- </DropDownToggleButton>
	-- </Frames>
	return menu;
end


-- lua replacement of LargeUIDropDownMenuTemplate
function Create_LargeDropDownMenu(name,parent)
	local menu = CreateFrame("Frame",name);
	menu:SetScript("OnHide",Menu_OnHide);

	-- <Frames>
		-- <DropDownToggleButton>
	local buttonName = name.."Button";
	menu.Button = Create_DropDownMenuButtonScript(buttonName,menu,LargeDropDownMenuButtonMixin);
	menu.Button:SetSize(27,26);
	menu.Button:SetPoint("RIGHT",-3,2);
			-- <Layers>
				-- <Layer>
	menu.Button.NormalTexture = menu.Button:CreateTexture(buttonName.."NormalTexture","ARTWORK");
	menu.Button.NormalTexture:SetAtlas("auctionhouse-ui-dropdown-arrow-up",true);
	menu.Button.NormalTexture:SetPoints("RIGHT");
	menu.Button:SetNormalTexture(menu.Button.NormalTexture);

	menu.Button.PushedTexture = menu.Button:CreateTexture(buttonName.."PushedTexture","ARTWORK");
	menu.Button.PushedTexture:SetAtlas("auctionhouse-ui-dropdown-arrow-down",true);
	menu.Button.PushedTexture:SetPoints("RIGHT");
	menu.Button:SetPushedTexture(menu.Button.PushedTexture);

	menu.Button.DisabledTexture = menu.Button:CreateTexture(buttonName.."DisabledTexture","ARTWORK");
	menu.Button.DisabledTexture:SetAtlas("auctionhouse-ui-dropdown-arrow-disabled",true);
	menu.Button.DisabledTexture:SetPoints("RIGHT");
	menu.Button:SetDisabledTexture(menu.Button.DisabledTexture);

	menu.Button.HighlightTexture = menu.Button:CreateTexture(buttonName.."HighlightTexture","ARTWORK");
	menu.Button.HighlightTexture:SetTexture([[Interface\ChatFrame\UI-Common-MouseHilight]],"ADD");
	menu.Button.HighlightTexture:SetPoints("CENTER");
	menu.Button:SetHighlightTexture(menu.Button.HighlightTexture,"ADD");
				-- </Layer>
			-- </Layers>
		-- </DropDownToggleButton>
	-- </Frames>

	-- <Layers>
		-- <Layer>
	menu.Left = menu:CreateTexture("ARTWORK");
	menu.Left:SetAtlas("auctionhouse-ui-dropdown-left",true);
	menu.Left:SetPoint("LEFT");

	menu.Right = menu:CreateTexture("ARTWORK");
	menu.Right:SetAtlas("auctionhouse-ui-dropdown-right",true);
	menu.Right:SetPoint("LEFT");

	menu.Middle = menu:CreateTexture("ARTWORK");
	menu.Middle:SetAtlas("auctionhouse-ui-dropdown-middle");
	menu.Middle:SetPoint("TOPLEFT",menu.Left,"TOPRIGHT");
	menu.Middle:SetPoint("BOTTOMRIGHT",menu.Right,"BOTTOMLEFT");

	menu.Text = menu:CreateFrontString("NumberFont_Small");
	menu.Text:SetNonSpaceWrap(false);
	menu.Text:SetJustifyH("RIGHT");
	menu.Text:SetPoint("RIGHT",menu.Button,"LEFT",-4,1);
		-- <Layer>

		-- <Layer>
	menu.Icon = menu:CreateTexture("OVERLAY");
	menu.Icon:Hide();
	menu.Icon:SetSize(16,16);
	menu.Icon:SetPoint("LEFT",30,2);
		-- <Layer>
	-- <Layers>

	return menu;
end


-- lua replacement of UIDropDownMenu.xml
if not _G.LibDropDownMenu_List1 then
	for i=1, UIDROPDOWNMENU_MAXLEVELS, 1 do
		Create_DropDownList("LibDropDownMenu_List"..i,nil,{id=i});
	end
end
