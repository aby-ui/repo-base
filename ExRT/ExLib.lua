--[[
version 1.0

ExRT.lib.AddShadowComment(self,hide,moduleName,userComment,userFontSize,userOutline)
ExRT.lib.CreateHoverHighlight(parent[,prefix,drawLayer])
ExRT.lib.SetAlphas(alpha,...)
ExRT.lib.SetPoint(self,...)
ExRT.lib.ShowOrHide(self,bool)

ExRT.lib.CreateColorPickButton(parent,width,height,relativePoint,x,y,cR,cG,cB,cA)
ExRT.lib.CreateGraph(parent,width,height,relativePoint,x,y)
ExRT.lib.CreateHelpButton(parent,helpPlateArray,isTab)


version 2.0

All functions:
	:Point(...)		-> SetPoint(...)
	:Size(...)		-> SetSize(...)
	:NewPoint(...)		-> ClearAllPoints() + SetPoint(...)
	:Scale(...)		-> SetScale(...)
	:OnClick(func)		-> SetScript("OnClick",func)
	:OnShow(func,disableFirst)  -> SetScript("OnShow",func) && run func if not disabled
	:Run(func,...)		-> func(self,...)

-> ELib:Shadow(parent,size,edgeSize)
-> ELib:Shadow2(parent,size,offsetX,offsetY,isBold)
-> ELib:Slider(parent,text,isVertical,template)
	:Range(min,max)		-> SetMinMaxValues(min,max)
	:SetTo(value)		-> SetValue(value)
	:OnChange(func)		-> SetScript("OnValueChanged",func)
	:Size(width)		-> SetWidth(width)
-> ELib:ScrollBar(parent,isOld)
	:Range(min,max)		-> SetMinMaxValues(min,max)
	:SetTo(value)		-> SetValue(value)
	:OnChange(func)		-> SetScript("OnValueChanged",func)
	:UpdateButtons()	-> [update up/down states]
	:ClickRange(i)		-> [set value range for clicks on buttons]
-> ELib:Tabs(parent,template,...)
	:SetTo(page)		-> [set page]
-> ELib:Text(parent,text,size,template)
	:Font(...)		-> SetFont(...)
	:Color(r,g,b)		-> SetTextColor(r,g,b)
	:Shadow(bool)		-> [false: add shadow; true: remove shadow]
	:Outline(bool)		-> [false: add outline; true: remove outline]
	:Left()			-> SetJustifyH("LEFT")
	:Center()		-> SetJustifyH("CENTER")
	:Right()		-> SetJustifyH("RIGHT")
	:Top()			-> SetJustifyV("TOP")
	:Middle()		-> SetJustifyV("MIDDLE")
	:Bottom()		-> SetJustifyV("BOTTOM")
	:FontSize(size)		-> SetFont(font,size)
	:Tooltip(anchor,isBut)	-> [add tooltip if text is corped]
-> ELib:Edit(parent,maxLetters,onlyNum,template)
	:Text(str)		-> SetText(str)
	:Tooltip(str)		-> [add tooltip]
	:OnChange(func)		-> SetScript("OnTextChanged",func)
-> ELib:ScrollFrame(parent,isOld)
	:Height(px)		-> [set height]
-> ELib:Button(parent,text,template)
	:Tooltip(str)		-> [add tooltip]
-> ELib:Icon(parent,textureIcon,size,isButton)
	:Icon(texture)		-> SetTexture
-> ELib:Check(parent,text,state,template)
	:Tooltip(str)		-> [add tooltip]
	:Left([relativeX])	-> [move text to left side], relativeX default 2
-> ELib:Radio(parent,text,checked,template)	
-> ELib:Popup(title,template)
-> ELib:OneTab(parent,text,isOld)
-> ELib:DropDown(parent,width,lines,template)
	:SetText(str)		-> [set text]
	:Tooltip(str)		-> [add tooltip]
	:Size(width)		-> SetWidth(width)
	:AddText(text)		-> [add text at left side]
-> ELib:DropDownButton(parent,defText,dropDownWidth,lines,template)
	:Tooltip(str)		-> [add tooltip]
-> ELib:MultiEdit(parent)
	:OnChange(func)		-> SetScript("OnTextChanged",func)
	:Font(...)		-> SetFont(...)
	:Hyperlinks()		-> enable hyperlinks in text (spells,items,etc)
	:ToTop()		-> set scroll vaule to min
	:GetTextHighlight()	-> get highlight positions [start,end]
-> ELib:MultiEdit3(parent)
-> ELib:Frame(parent,template)
	:Texture(texture,layer)	-> create and/or set texture
	:Texture(cR,cG,cB,cA,layer) -> create and/or set texture
	:TexturePoint(...)	-> add point to texture
	:TextureSize(...)	-> set size to texture
-> ELib:SliderBox(parent,list)
	:SetTo(value)		-> [set value from list]
-> ELib:ScrollList(parent,list)
	:Update()		-> [update list]
	:FontSize(size)		-> SetFont(font,size)
-> ELib:ScrollCheckList(parent,list)
	:Update()		-> [update list]
	:FontSize(size)		-> SetFont(font,size)
-> ELib:ScrollTableList(parent,...)
				   where ... are width of columns, one always must be 0
	:Update()		-> [update list]
	:FontSize(size)		-> SetFont(font,size)
-> ELib:ScrollTabsFrame(parent,...)
-> ELib:ListButton(parent,text,width,lines,template)
	:Left()			-> [move text to left side]
-> ELib:DebugBack(parent)
-> ELib:Texture(parent,texture,layer) or ELib:Texture(parent,cR,cG,cB,cA,layer)
	:Color(r,g,b,a)		-> SetVertexColor(r,g,b,a)
	:TexCoord(...)		-> SetTexCoord(...)
-> ELib:ShadowInside(parent,enableBorder,enableLine)
-> ELib:Border(parent,size,colorR,colorG,colorB,colorA,outside,layerCounter)

Tooltips:
-> ELib.Tooltip:Hide()
-> ELib.Tooltip:Std(anchorUser)			[based on self.tooltipText]
-> ELib.Tooltip:Link(data,...)			[hyperlinks eg: "item:9999","spell:774"]
-> ELib.Tooltip:Show(anchorUser,title,...)	[where ... - lines of tooltip]
-> ELib.Tooltip:Edit_Show(linkData,link)	[for tooltips in editboxes, simplehtmls]
-> ELib.Tooltip:Edit_Click(linkData,link,button)[click for links in editboxes, simplehtmls]
-> ELib.Tooltip:Add(link,data,enableMultiline,disableTitle)	[additional tooltips; data - table param]
-> ELib.Tooltip:HideAdd()			[hide all additional tooltips]

Templates
Font		ExRTFontNormal
Font 		ExRTFontGrayTemplate
Button		ExRTUIChatDownButtonTemplate
Frame		ExRTTranslucentFrameTemplate
Button		ExRTDropDownMenuButtonTemplate
Button		ExRTDropDownListTemplate
Button		ExRTDropDownListModernTemplate
Button		ExRTButtonTransparentTemplate
Button		ExRTButtonModernTemplate
Frame		ExRTBWInterfaceFrame
Button		ExRTTabButtonTransparentTemplate
Button		ExRTTabButtonTemplate
Frame		ExRTDialogTemplate
Frame		ExRTDialogModernTemplate
Frame		ExRTDropDownMenuTemplate
Frame		ExRTDropDownMenuModernTemplate
EditBox		ExRTInputBoxTemplate
EditBox		ExRTInputBoxModernTemplate
Slider		ExRTSliderTemplate
Slider		ExRTSliderModernTemplate
Slider		ExRTSliderModernVerticalTemplate
Frame		ExRTTrackingButtonModernTemplate
CheckButton	ExRTCheckButtonModernTemplate
Button		ExRTButtonDownModernTemplate
Button		ExRTButtonUpModernTemplate
Button		ExRTUIChatDownButtonModernTemplate
CheckButton	ExRTRadioButtonModernTemplate

]]

local GlobalAddonName, ExRT = ...
local isExRT = GlobalAddonName == "ExRT"

local libVersion = 35

if type(ELib)=='table' and type(ELib.V)=='number' and ELib.V > libVersion then return end

local ELib = {}
if isExRT then		--Disable global if not ExRT addon, only local usage
	_G.ELib = ELib
end
ExRT.lib = ELib

ELib.V = libVersion

local Mod = nil
do
	local function Widget_SetPoint(self,arg1,arg2,arg3,...)
		if type(arg1) == 'table' or (arg1 == 'x' and not arg2) then
			if arg1 == 'x' then arg1 = self:GetParent() end
			self:SetAllPoints(arg1)
			return self
		end
		if arg1 == 'x' then arg1 = self:GetParent() end
		if arg2 == 'x' then arg2 = self:GetParent() end
		if type(arg1) == 'number' then
			arg2,arg3,arg1 = arg1,arg2,'TOPLEFT'
		end
		self:SetPoint(arg1,arg2,arg3,...)
		return self
	end
	local function Widget_SetSize(self,...)
		self:SetSize(...)
		return self
	end
	local function Widget_SetNewPoint(self,...)
		self:ClearAllPoints()
		self:Point(...)
		return self
	end
	local function Widget_SetScale(self,...)
		self:SetScale(...)
		return self
	end
	local function Widget_OnClick(self,func)
		self:SetScript("OnClick",func)
		return self
	end
	local function Widget_OnShow(self,func,disableFirstRun)
		if not func then
			self:SetScript("OnShow",nil)
			return self
		end
		self:SetScript("OnShow",func)
		if not disableFirstRun then
			func(self)
		end
		return self
	end
	local function Widget_Run(self,func,...)
		func(self,...)
		return self
	end
	function Mod(self,...)
		self.Point = Widget_SetPoint
		self.Size = Widget_SetSize
		self.NewPoint = Widget_SetNewPoint
		self.Scale = Widget_SetScale
		self.OnClick = Widget_OnClick
		self.OnShow = Widget_OnShow
		self.Run = Widget_Run
		
		self.SetNewPoint = Widget_SetNewPoint
		
		for i=1,select("#", ...) do
			if i % 2 == 1 then
				local funcName,func = select(i, ...)
				self[funcName] = func
			end
		end
	end
end

--=======================================================================
--=======================================================================
--==============================  LOCALS ================================
--=======================================================================
--=======================================================================

local DEFAULT_FONT = ExRT.F and ExRT.F.defFont or "Fonts\\ARHei.ttf" --"Interface\\AddOns\\"..GlobalAddonName.."\\media\\skurri.ttf"
local DEFAULT_BORDER = ExRT.F and ExRT.F.defBorder or "Interface\\AddOns\\"..GlobalAddonName.."\\media\\border.tga"

local function Round(i)
	return floor(i+0.5)
end

local function GetCursorPos(frame)
	local x_f,y_f = GetCursorPosition()
	local s = frame:GetEffectiveScale()
	x_f, y_f = x_f/s, y_f/s
	local x,y = frame:GetLeft(),frame:GetTop()
	x = x_f-x
	y = (y_f-y)*(-1)
	return x,y
end

local IsInFocus
do
	local function FindAllParents(self,obj)
		while obj do
			if obj == self then
				return true
			end
			obj = obj:GetParent()
		end
	end
	function IsInFocus(frame,x,y,childs)
		if not x then
			x,y = GetCursorPos(frame)
		end
		local obj = GetMouseFocus()
		if x > 0 and y > 0 and x < frame:GetWidth() and y < frame:GetHeight() and (obj == frame or (childs and FindAllParents(frame,obj))) then
			return true
		end
	end
end

local GetNextGlobalName
do
	local GlobalIndexNow = 0
	function GetNextGlobalName()
		GlobalIndexNow = GlobalIndexNow + 1
		return GlobalAddonName.."UIGlobal"..tostring(GlobalIndexNow)
	end
end

local UIDropDownMenu_StartCounting = UIDropDownMenu_StartCounting or ExRT.NULLfunc or function()end
local UIDropDownMenu_StopCounting = UIDropDownMenu_StopCounting or ExRT.NULLfunc or function()end

--=======================================================================
--=======================================================================
--============================  TEMPLATES ===============================
--=======================================================================
--=======================================================================

local Templates = {}

function ELib:Template(name,parent)
	if not Templates[name] then
		return
	end
	local obj = Templates[name](nil,parent)
	--obj:SetParent(parent or UIParent)
	return obj
end

if not ExRTFontNormal then
	local ExRTFontNormal = CreateFont("ExRTFontNormal")
	ExRTFontNormal:SetFont(GameFontNormal:GetFont())
	ExRTFontNormal:SetShadowColor(0,0,0)
	ExRTFontNormal:SetShadowOffset(1,-1)
	ExRTFontNormal:SetTextColor(1,.82,0)
end
if not ExRTFontGrayTemplate then
	local ExRTFontGrayTemplate = CreateFont("ExRTFontGrayTemplate")
	ExRTFontGrayTemplate:SetFont(GameFontHighlightSmall:GetFont())
	ExRTFontGrayTemplate:SetShadowColor(0,0,0)
	ExRTFontGrayTemplate:SetShadowOffset(1,-1)
	ExRTFontGrayTemplate:SetTextColor(0.63,0.68,0.69)
end

do
	local ICONS = {
		[1] = {{0.5,0.5625,0.5,0.625},{1,1,1,.7},{.8,0,0,1}},			--close
		[2] = {{0.1875,0.25,0.5,0.625},{1,1,1,.7},{0.9,0.75,0,1}},		--home
		[3] = {{0.25,0.3125,0.5,0.625},{1,1,1,.7},0,{1,1,1,1},{.3,.3,.3,.7}},	--arrow-down
		[4] = {{0.3125,0.375,0.5,0.625},{1,1,1,.7},0,{1,1,1,1},{.3,.3,.3,.7}},	--arrow-up
	}
	function Templates:GUIcons(id,parent)
		local self = CreateFrame("Button",nil,parent)

		self.NormalTexture = self:CreateTexture(nil,"ARTWORK")
		self.NormalTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
		self.NormalTexture:SetPoint("TOPLEFT")
		self.NormalTexture:SetPoint("BOTTOMRIGHT")
		self.NormalTexture:SetVertexColor(unpack(ICONS[id][2]))
		self.NormalTexture:SetTexCoord(unpack(ICONS[id][1]))
		self:SetNormalTexture(self.NormalTexture)
		
		if type(ICONS[id][3])=='table' then
			self.HighlightTexture = self:CreateTexture(nil,"ARTWORK")
			self.HighlightTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
			self.HighlightTexture:SetPoint("TOPLEFT")
			self.HighlightTexture:SetPoint("BOTTOMRIGHT")
			self.HighlightTexture:SetVertexColor(unpack(ICONS[id][3]))
			self.HighlightTexture:SetTexCoord(unpack(ICONS[id][1]))	
			self:SetHighlightTexture(self.HighlightTexture)
		end
		if type(ICONS[id][4])=='table' then
			self.PushedTexture = self:CreateTexture(nil,"ARTWORK")
			self.PushedTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
			self.PushedTexture:SetPoint("TOPLEFT")
			self.PushedTexture:SetPoint("BOTTOMRIGHT")
			self.PushedTexture:SetVertexColor(unpack(ICONS[id][4]))
			self.PushedTexture:SetTexCoord(unpack(ICONS[id][1]))	
			self:SetPushedTexture(self.PushedTexture)
		end
		if type(ICONS[id][5])=='table' then
			self.DisabledTexture = self:CreateTexture(nil,"ARTWORK")
			self.DisabledTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
			self.DisabledTexture:SetPoint("TOPLEFT")
			self.DisabledTexture:SetPoint("BOTTOMRIGHT")
			self.DisabledTexture:SetVertexColor(unpack(ICONS[id][5]))
			self.DisabledTexture:SetTexCoord(unpack(ICONS[id][1]))	
			self:SetDisabledTexture(self.DisabledTexture)
		end
		
		return self
	end
	ELib.Templates_GUIcons = Templates.GUIcons
	function Templates:Border(self,cR,cG,cB,cA,size,offsetX,offsetY)
		offsetX = offsetX or 0
		offsetY = offsetY or 0
	
		self.BorderTop = self:CreateTexture(nil,"BACKGROUND")
		self.BorderTop:SetColorTexture(cR,cG,cB,cA)
		self.BorderTop:SetPoint("TOPLEFT",-size-offsetX,size+offsetY)
		self.BorderTop:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",size+offsetX,offsetY)

		self.BorderLeft = self:CreateTexture(nil,"BACKGROUND")
		self.BorderLeft:SetColorTexture(cR,cG,cB,cA)
		self.BorderLeft:SetPoint("TOPLEFT",-size-offsetX,offsetY)
		self.BorderLeft:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY)

		self.BorderBottom = self:CreateTexture(nil,"BACKGROUND")
		self.BorderBottom:SetColorTexture(cR,cG,cB,cA)
		self.BorderBottom:SetPoint("BOTTOMLEFT",-size-offsetX,-size-offsetY)
		self.BorderBottom:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",size+offsetX,-offsetY)

		self.BorderRight = self:CreateTexture(nil,"BACKGROUND")
		self.BorderRight:SetColorTexture(cR,cG,cB,cA)
		self.BorderRight:SetPoint("BOTTOMRIGHT",size+offsetX,offsetY)
		self.BorderRight:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX,-offsetY)
	end
	ELib.Templates_Border = Templates.Border
end

do
	local function OnEnter(self)
		local parent = self:GetParent()
		local myscript = parent:GetScript("OnEnter")
		if myscript then
			myscript(parent)
		end
	end
	local function OnLeave(self)
		local parent = self:GetParent()
		local myscript = parent:GetScript("OnLeave")
		if myscript then
			myscript(parent)
		end
	end
	local function OnClick(self)
		ToggleDropDownMenu(nil, nil, self:GetParent())
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end
	function Templates:ExRTUIChatDownButtonTemplate(parent)
		local self = CreateFrame("Button",nil,parent)
		self:SetSize(24,24)
		
		self.NormalTexture = self:CreateTexture()
		self.NormalTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
		self.NormalTexture:SetSize(24,24)
		self.NormalTexture:SetPoint("RIGHT")
		self:SetNormalTexture(self.NormalTexture)
		
		self.PushedTexture = self:CreateTexture()
		self.PushedTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
		self.PushedTexture:SetSize(24,24)
		self.PushedTexture:SetPoint("RIGHT")
		self:SetPushedTexture(self.PushedTexture)
		
		self.DisabledTexture = self:CreateTexture()
		self.DisabledTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
		self.DisabledTexture:SetSize(24,24)
		self.DisabledTexture:SetPoint("RIGHT")
		self:SetDisabledTexture(self.DisabledTexture)
		
		self.HighlightTexture = self:CreateTexture()
		self.HighlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		self.HighlightTexture:SetSize(24,24)
		self.HighlightTexture:SetPoint("RIGHT")
		self:SetHighlightTexture(self.HighlightTexture,"ADD")
				
		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		self:SetScript("OnClick",OnClick)
		return self
	end
end

function Templates:ExRTTranslucentFrameTemplate(parent)
	local self = CreateFrame("Frame",nil,parent)
	self:SetSize(338,424)
	
	self.Bg = self:CreateTexture(nil,"BACKGROUND",nil,-8)
	self.Bg:SetPoint("TOPLEFT",10,-10)
	self.Bg:SetPoint("BOTTOMRIGHT",-10,10)
	self.Bg:SetColorTexture(0,0,0,0.8)
	
	local TopLeftCorner = self:CreateTexture(nil,"BORDER","Dialog-BorderTopLeft",-5)
	TopLeftCorner:SetPoint("TOPLEFT")
	local TopRightCorner = self:CreateTexture(nil,"BORDER","Dialog-BorderTopRight",-5)
	TopRightCorner:SetPoint("TOPRIGHT")
	local BottomLeftCorner = self:CreateTexture(nil,"BORDER","Dialog-BorderBottomLeft",-5)
	BottomLeftCorner:SetPoint("BOTTOMLEFT")
	local BottomRightCorner = self:CreateTexture(nil,"BORDER","Dialog-BorderBottomRight",-5)
	BottomRightCorner:SetPoint("BOTTOMRIGHT")

	local TopBorder = self:CreateTexture(nil,"BORDER","Dialog-BorderTop",-5)
	TopBorder:SetPoint("TOPLEFT",TopLeftCorner,"TOPRIGHT",0,-1)
	TopBorder:SetPoint("TOPRIGHT",TopRightCorner,"TOPLEFT",0,-1)

	local BottomBorder = self:CreateTexture(nil,"BORDER","Dialog-BorderBottom",-5)
	BottomBorder:SetPoint("BOTTOMLEFT",BottomLeftCorner,"BOTTOMRIGHT")
	BottomBorder:SetPoint("BOTTOMRIGHT",BottomRightCorner,"BOTTOMLEFT")

	local LeftBorder = self:CreateTexture(nil,"BORDER","Dialog-BorderLeft",-5)
	LeftBorder:SetPoint("TOPLEFT",TopLeftCorner,"BOTTOMLEFT",1,0)
	LeftBorder:SetPoint("BOTTOMLEFT",BottomLeftCorner,"TOPLEFT",1,0)

	local RightBorder = self:CreateTexture(nil,"BORDER","Dialog-BorderRight",-5)
	RightBorder:SetPoint("TOPRIGHT",TopRightCorner,"BOTTOMRIGHT")
	RightBorder:SetPoint("BOTTOMRIGHT",BottomRightCorner,"TOPRIGHT")
		
	return self
end

do
	local function OnEnter(self)
		self.Highlight:Show()
		UIDropDownMenu_StopCounting(self:GetParent())
		if ( self.tooltipTitle ) then
			if ( self.tooltipOnButton ) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:AddLine(self.tooltipTitle, 1.0, 1.0, 1.0)
				GameTooltip:AddLine(self.tooltipText)
				GameTooltip:Show()
			else
				GameTooltip_AddNewbieTip(self, self.tooltipTitle, 1.0, 1.0, 1.0, self.tooltipText, true)
			end
		end
		if ( self.NormalText:IsTruncated() ) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(self.NormalText:GetText())
			GameTooltip:Show()
		end
		ELib.ScrollDropDown.OnButtonEnter(self)
	end
	local function OnLeave(self)
		self.Highlight:Hide()
		UIDropDownMenu_StartCounting(self:GetParent())
		GameTooltip:Hide()
		ELib.ScrollDropDown.OnButtonLeave(self)
	end
	local function OnClick(self)
		ELib.ScrollDropDown.OnClick(self, button, down)
	end
	local function OnLoad(self)
		self:SetFrameLevel(self:GetParent():GetFrameLevel()+2)
	end
	function Templates:ExRTDropDownMenuButtonTemplate(parent)
		local self = CreateFrame("Button",nil,parent)
		self:SetSize(100,16)
		
		self.Highlight = self:CreateTexture(nil,"BACKGROUND")
		self.Highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		self.Highlight:SetAllPoints()
		self.Highlight:SetBlendMode("ADD")
		self.Highlight:Hide()
		
		self.Texture = self:CreateTexture(nil,"BACKGROUND",nil,-8)
		self.Texture:Hide()
		self.Texture:SetAllPoints()
		
		self.Icon = self:CreateTexture(nil,"ARTWORK")
		self.Icon:SetSize(16,16)
		self.Icon:SetPoint("LEFT")
		self.Icon:Hide()
		
		self.Arrow = self:CreateTexture(nil,"ARTWORK")
		self.Arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
		self.Arrow:SetSize(16,16)
		self.Arrow:SetPoint("RIGHT")
		self.Arrow:Hide()
		
		self.NormalText = self:CreateFontString()
		self.NormalText:SetPoint("LEFT")
		
		self:SetFontString(self.NormalText)
		
		self:SetNormalFontObject("GameFontHighlightSmallLeft")
		self:SetHighlightFontObject("GameFontHighlightSmallLeft")
		self:SetDisabledFontObject("GameFontDisableSmallLeft")

		self:SetPushedTextOffset(1,-1)
		
		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		self:SetScript("OnClick",OnClick)
		self:SetScript("OnLoad",OnLoad)
		return self
	end
end

do
	local function OnEnter(self, motion)
		UIDropDownMenu_StopCounting(self, motion)
	end
	local function OnLeave(self, motion)
		UIDropDownMenu_StartCounting(self, motion)
	end
	local function OnClick(self)
		self:Hide()
	end
	local function OnShow(self)
		self:SetFrameLevel(1000)
		if self.OnShow then
			self:OnShow()
		end
	end
	local function OnHide(self)
		UIDropDownMenu_StopCounting(self)
	end
	local function OnUpdate(self, elapsed)
		ELib.ScrollDropDown.Update(self, elapsed)
	end
	function Templates:ExRTDropDownListTemplate(parent)
		local self = CreateFrame("Button",nil,parent)
		self:SetFrameStrata("TOOLTIP")
		self:EnableMouse(true)
		self:Hide()
		
		self.Backdrop = CreateFrame("Frame",nil,self)
		self.Backdrop:SetAllPoints()
		self.Backdrop:SetBackdrop({
			bgFile="Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true,
			insets = {
				left = 11,
				right = 12,
				top = 11,
				bottom = 9,
			},
			tileSize = 32,
			edgeSize = 32,
		})
		
		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		self:SetScript("OnClick",OnClick)
		self:SetScript("OnShow",OnShow)
		self:SetScript("OnHide",OnHide)
		self:SetScript("OnUpdate",OnUpdate)
		return self
	end	
	function Templates:ExRTDropDownListModernTemplate(parent)
		local self = CreateFrame("Button",nil,parent)
		self:SetFrameStrata("TOOLTIP")
		self:EnableMouse(true)
		self:Hide()
		
		Templates:Border(self,0,0,0,1,1)
		
		self.Background = self:CreateTexture(nil,"BACKGROUND")
		self.Background:SetColorTexture(0,0,0,.9)
		self.Background:SetPoint("TOPLEFT")
		self.Background:SetPoint("BOTTOMRIGHT")
		
		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		self:SetScript("OnClick",OnClick)
		self:SetScript("OnShow",OnShow)
		self:SetScript("OnHide",OnHide)
		self:SetScript("OnUpdate",OnUpdate)
		return self
	end
end

function Templates:ExRTButtonTransparentTemplate(parent)
	local self = CreateFrame("Button",nil,parent)
	self:SetSize(40,18)
	
	self.HighlightTexture = self:CreateTexture()
	self.HighlightTexture:SetColorTexture(1,1,1,.3)
	self.HighlightTexture:SetPoint("TOPLEFT")
	self.HighlightTexture:SetPoint("BOTTOMRIGHT")
	self:SetHighlightTexture(self.HighlightTexture)
	
	self.PushedTexture = self:CreateTexture()
	self.PushedTexture:SetColorTexture(.9,.8,.1,.3)
	self.PushedTexture:SetPoint("TOPLEFT")
	self.PushedTexture:SetPoint("BOTTOMRIGHT")
	self:SetPushedTexture(self.PushedTexture)
	
	self:SetNormalFontObject("GameFontNormal")
	self:SetHighlightFontObject("GameFontHighlight")
	self:SetDisabledFontObject("GameFontDisable")
	
	return self
end

function Templates:ExRTButtonModernTemplate(parent)
	local self = Templates:ExRTButtonTransparentTemplate(parent)
	
	Templates:Border(self,0,0,0,1,1)
	
	self.Texture = self:CreateTexture(nil,"BACKGROUND")
	self.Texture:SetColorTexture(1,1,1,1)
	self.Texture:SetGradientAlpha("VERTICAL",0.05,0.06,0.09,1, 0.20,0.21,0.25,1)
	self.Texture:SetPoint("TOPLEFT")
	self.Texture:SetPoint("BOTTOMRIGHT")

	self.DisabledTexture = self:CreateTexture()
	self.DisabledTexture:SetColorTexture(0.20,0.21,0.25,0.5)
	self.DisabledTexture:SetPoint("TOPLEFT")
	self.DisabledTexture:SetPoint("BOTTOMRIGHT")
	self:SetDisabledTexture(self.DisabledTexture)	
	
	return self
end

do
	local function buttonClose_OnClick(self)
		self:GetParent():Hide()
	end
	local function backToInterface_OnClick(self)
		GExRT.Options:Open()
		self:GetParent():Hide()
	end
	function Templates:ExRTBWInterfaceFrame(parent)
		local self = CreateFrame("Frame",nil,parent)
		self:SetSize(858,660)
		self:SetFrameStrata("HIGH")
		self:SetToplevel(true)
		self:EnableMouse(true)
		self:SetPoint("CENTER")
		self:SetBackdrop({bgFile="Interface\\Addons\\"..GlobalAddonName.."\\media\\White"})
		self:SetBackdropColor(0.05,0.05,0.07,0.9)
		
		self.HeaderText = self:CreateFontString(nil,"ARTWORK","GameFontNormal")
		self.HeaderText:SetPoint("TOP",0,-3)
		self.HeaderText:SetTextColor(1,.66,0,1)
		
		self.buttonClose = Templates:GUIcons(1,self)
		self.buttonClose:SetSize(18,18)
		self.buttonClose:SetPoint("TOPRIGHT",-1,0)
		self.buttonClose:SetScript("OnClick",buttonClose_OnClick)
		
		self.backToInterface = Templates:GUIcons(2,self)
		self.backToInterface:SetSize(16,16)
		self.backToInterface:SetPoint("BOTTOMRIGHT",self.buttonClose,"BOTTOMLEFT",-1,1)
		self.backToInterface:SetScript("OnClick",backToInterface_OnClick)
	
		self.bossButton = ELib:Template("ExRTButtonTransparentTemplate",self)
		self.bossButton:SetSize(250,18)
		self.bossButton:SetPoint("TOPLEFT",4,-18)
		self.bossButton:SetScript("OnClick",buttonClose_OnClick)	
		
		return self
	end
end


do
	local function OnShow(self)
		self:GetParent().resizeFunc(self, 0)
		self.HighlightTexture:SetWidth(self:GetTextWidth() + 30)
	end
	local function OnLoad(self)
		self:SetFrameLevel(self:GetFrameLevel() + 4)
		self.deselectedTextY = -3
		self.selectedTextY = -2
	end
	function Templates:ExRTTabButtonTransparentTemplate(parent)
		local self = CreateFrame("Button",nil,parent)
		self:SetSize(115,24)
		
		self.LeftDisabled = self:CreateTexture(nil,"BORDER")
		self.LeftDisabled:SetPoint("BOTTOMLEFT",0,-3)
		self.LeftDisabled:SetSize(12,24)

		self.MiddleDisabled = self:CreateTexture(nil,"BORDER")
		self.MiddleDisabled:SetPoint("LEFT",self.LeftDisabled,"RIGHT")
		self.MiddleDisabled:SetSize(88,24)

		self.RightDisabled = self:CreateTexture(nil,"BORDER")
		self.RightDisabled:SetPoint("LEFT",self.MiddleDisabled,"RIGHT")
		self.RightDisabled:SetSize(12,24)

		self.Left = self:CreateTexture(nil,"BORDER")
		self.Left:SetPoint("TOPLEFT")
		self.Left:SetSize(12,24)

		self.Middle = self:CreateTexture(nil,"BORDER")
		self.Middle:SetPoint("LEFT",self.Left,"RIGHT")
		self.Middle:SetSize(88,24)

		self.Right = self:CreateTexture(nil,"BORDER")
		self.Right:SetPoint("LEFT",self.Middle,"RIGHT")
		self.Right:SetSize(12,24)
		
		self.Text = self:CreateFontString()
		self.Text:SetPoint("CENTER",0,-3)
		
		self:SetFontString(self.Text)
		
		self:SetNormalFontObject("ExRTFontGrayTemplate")
		self:SetHighlightFontObject("GameFontHighlightSmall")
		self:SetDisabledFontObject("GameFontNormalSmall")
		
		self.HighlightTexture = self:CreateTexture()
		self.HighlightTexture:SetColorTexture(1,1,1,.3)
		self.HighlightTexture:SetPoint("TOPLEFT",0,-4)
		self.HighlightTexture:SetPoint("BOTTOMRIGHT")
		self:SetHighlightTexture(self.HighlightTexture)		

		self:SetScript("OnShow",OnShow)
		self:SetScript("OnLoad",OnLoad)
		return self
	end
	function Templates:ExRTTabButtonTemplate(parent)
		local self = Templates:ExRTTabButtonTransparentTemplate(parent)
		
		self.LeftDisabled:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
		self.LeftDisabled:SetSize(20,24)
		self.LeftDisabled:SetTexCoord(0,0.15625,0,1)

		self.MiddleDisabled:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
		self.MiddleDisabled:SetTexCoord(0.15625,0.84375,0,1)

		self.RightDisabled:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
		self.RightDisabled:SetSize(20,24)
		self.RightDisabled:SetTexCoord(0.84375,1,0,1)

		self.Left:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
		self.Left:SetSize(20,24)
		self.Left:SetTexCoord(0,0.15625,0,1)

		self.Middle:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
		self.Middle:SetTexCoord(0.15625,0.84375,0,1)

		self.Right:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
		self.Right:SetSize(20,24)
		self.Right:SetTexCoord(0.84375,1,0,1)
		
		self:SetNormalFontObject("GameFontNormalSmall")
		
		self.HighlightTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
		self.HighlightTexture:ClearAllPoints()
		self.HighlightTexture:SetPoint("LEFT",10,-4)
		self.HighlightTexture:SetPoint("RIGHT",-10,-4)
		self:SetHighlightTexture(self.HighlightTexture,"ADD")		

		return self
	end
end

function Templates:ExRTDialogTemplate(parent)
	local self = CreateFrame("Frame",nil,parent)
	
	self.TopLeft = self:CreateTexture(nil,"OVERLAY")
	self.TopLeft:SetPoint("TOPLEFT")
	self.TopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.TopLeft:SetSize(64,64)
	self.TopLeft:SetTexCoord(0.501953125,0.625,0,1)

	self.TopRight = self:CreateTexture(nil,"OVERLAY")
	self.TopRight:SetPoint("TOPRIGHT")
	self.TopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.TopRight:SetSize(64,64)
	self.TopRight:SetTexCoord(0.625,0.75,0,1)

	self.Top = self:CreateTexture(nil,"OVERLAY")
	self.Top:SetPoint("TOPLEFT",self.TopLeft,"TOPRIGHT")
	self.Top:SetPoint("TOPRIGHT",self.TopRight,"TOPLEFT")
	self.Top:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.Top:SetSize(0,64)
	self.Top:SetTexCoord(0.25,0.369140625,0,1)

	self.BottomLeft = self:CreateTexture(nil,"OVERLAY")
	self.BottomLeft:SetPoint("BOTTOMLEFT")
	self.BottomLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.BottomLeft:SetSize(64,64)
	self.BottomLeft:SetTexCoord(0.751953125,0.875,0,1)

	self.BottomRight = self:CreateTexture(nil,"OVERLAY")
	self.BottomRight:SetPoint("BOTTOMRIGHT")
	self.BottomRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.BottomRight:SetSize(64,64)
	self.BottomRight:SetTexCoord(0.875,1,0,1)

	self.Bottom = self:CreateTexture(nil,"OVERLAY")
	self.Bottom:SetPoint("BOTTOMLEFT",self.BottomLeft,"BOTTOMRIGHT")
	self.Bottom:SetPoint("BOTTOMRIGHT",self.BottomRight,"BOTTOMLEFT")
	self.Bottom:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.Bottom:SetSize(0,64)
	self.Bottom:SetTexCoord(0.376953125,0.498046875,0,1)

	self.Left = self:CreateTexture(nil,"OVERLAY")
	self.Left:SetPoint("TOPLEFT",self.TopLeft,"BOTTOMLEFT")
	self.Left:SetPoint("BOTTOMLEFT",self.BottomLeft,"TOPLEFT")
	self.Left:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.Left:SetSize(64,0)
	self.Left:SetTexCoord(0.001953125,0.125,0,1)
	
	self.Right = self:CreateTexture(nil,"OVERLAY")
	self.Right:SetPoint("TOPRIGHT",self.TopRight,"BOTTOMRIGHT")
	self.Right:SetPoint("BOTTOMRIGHT",self.BottomRight,"TOPRIGHT")
	self.Right:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
	self.Right:SetSize(64,0)
	self.Right:SetTexCoord(0.1171875,0.2421875,0,1)
	
	self.TitleBG = self:CreateTexture(nil,"BACKGROUND")
	self.TitleBG:SetPoint("TOPLEFT",8,-7)
	self.TitleBG:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",-8,-24)
	self.TitleBG:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Title-Background")

	self.DialogBG = self:CreateTexture(nil,"BACKGROUND")
	self.DialogBG:SetPoint("TOPLEFT",8,-24)
	self.DialogBG:SetPoint("BOTTOMRIGHT",-6,8)
	self.DialogBG:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-CharacterTab-L1")
	self.DialogBG:SetTexCoord(0.255,1,0.29,1)
	
	self.title = self:CreateFontString(nil,"OVERLAY","GameFontNormal")
	self.title:SetPoint("TOPLEFT",12,-8)
	self.title:SetPoint("TOPRIGHT",-32,-24)
	
	self.Close = CreateFrame("Button",nil,self,"UIPanelCloseButton")
	self.Close:SetPoint("TOPRIGHT",2,1)	

	return self
end

do
	local function buttonClose_OnClick(self)
		self:GetParent():Hide()
	end
	function Templates:ExRTDialogModernTemplate(parent)
		local self = CreateFrame("Frame",nil,parent)
		self:SetBackdrop({bgFile="Interface\\Addons\\"..GlobalAddonName.."\\media\\White"})
		self:SetBackdropColor(0.05,0.05,0.07,0.98)
			
		self.title = self:CreateFontString(nil,"OVERLAY","GameFontNormal")
		self.title:SetPoint("TOP",0,-3)
		self.title:SetTextColor(1,0.66,0,1)
		
		self.Close = Templates:GUIcons(1)
		self.Close:SetParent(self)
		self.Close:SetPoint("TOPRIGHT",-1,0)
		self.Close:SetSize(18,18)
		
		self.Close:SetScript("OnClick",buttonClose_OnClick)
	
		return self
	end
end

do
	local function OnHide(self)
		CloseDropDownMenus()
	end
	function Templates:ExRTDropDownMenuTemplate(parent)
		local self = CreateFrame("Frame",nil,parent)
		self:SetSize(40,32)
			
		self.Left = self:CreateTexture(nil,"ARTWORK")
		self.Left:SetPoint("TOPLEFT",0,17)
		self.Left:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
		self.Left:SetSize(25,64)
		self.Left:SetTexCoord(0,0.1953125,0,1)

		self.Middle = self:CreateTexture(nil,"ARTWORK")
		self.Middle:SetPoint("LEFT",self.Left,"RIGHT")
		self.Middle:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
		self.Middle:SetSize(115,64)
		self.Middle:SetTexCoord(0.1953125,0.8046875,0,1)

		self.Right = self:CreateTexture(nil,"ARTWORK")
		self.Right:SetPoint("LEFT",self.Middle,"RIGHT")
		self.Right:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
		self.Right:SetSize(25,64)
		self.Right:SetTexCoord(0.8046875,1,0,1)

		self.Text = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.Text:SetWordWrap(false)
		self.Text:SetJustifyH("RIGHT")
		self.Text:SetSize(0,10)
		self.Text:SetPoint("RIGHT",self.Right,-43,2)
		
		self.Icon = self:CreateTexture(nil,"OVERLAY")
		self.Icon:Hide()
		self.Icon:SetPoint("LEFT",30,2)
		self.Icon:SetSize(16,16)
		
		self.Button = ELib:Template("ExRTUIChatDownButtonTemplate",self)
		self.Button:SetPoint("TOPRIGHT",self.Right,-16,-18)
		self.Button:SetMotionScriptsWhileDisabled(true)

		self:SetScript("OnHide",OnHide)

		return self
	end
	function Templates:ExRTDropDownMenuModernTemplate(parent)
		local self = CreateFrame("Frame",nil,parent)
		self:SetSize(40,20)

		self.Text = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.Text:SetWordWrap(false)
		self.Text:SetJustifyH("RIGHT")
		self.Text:SetJustifyV("MIDDLE")
		self.Text:SetSize(0,20)
		self.Text:SetPoint("RIGHT",-24,0)
		self.Text:SetPoint("LEFT",4,0)
		
		Templates:Border(self,0.24,0.25,0.30,1,1)
		
		self.Background = self:CreateTexture(nil,"BACKGROUND")
		self.Background:SetColorTexture(0,0,0,.3)
		self.Background:SetPoint("TOPLEFT")
		self.Background:SetPoint("BOTTOMRIGHT")
		
		self.Button = ELib:Template("ExRTUIChatDownButtonTemplate",self)
		self.Button:SetPoint("RIGHT",-2,0)
		self.Button:SetSize(16,16)
		self.Button:SetMotionScriptsWhileDisabled(true)
		
		self.Button.NormalTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
		self.Button.NormalTexture:SetTexCoord(0.25,0.3125,0.5,0.625)
		self.Button.NormalTexture:SetVertexColor(1,1,1,.7)
		self.Button.NormalTexture:SetSize(0,0)
		self.Button.NormalTexture:ClearAllPoints()
		self.Button.NormalTexture:SetPoint("TOPLEFT",-5,2)
		self.Button.NormalTexture:SetPoint("BOTTOMRIGHT",5,-2)
		
		self.Button.PushedTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
		self.Button.PushedTexture:SetTexCoord(0.25,0.3125,0.5,0.625)
		self.Button.PushedTexture:SetVertexColor(1,1,1,1)
		self.Button.PushedTexture:SetSize(0,0)
		self.Button.PushedTexture:ClearAllPoints()
		self.Button.PushedTexture:SetPoint("TOPLEFT",-5,1)
		self.Button.PushedTexture:SetPoint("BOTTOMRIGHT",5,-3)

		self.Button.DisabledTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
		self.Button.DisabledTexture:SetTexCoord(0.25,0.3125,0.5,0.625)
		self.Button.DisabledTexture:SetVertexColor(.4,.4,.4,1)
		self.Button.DisabledTexture:SetSize(0,0)
		self.Button.DisabledTexture:ClearAllPoints()
		self.Button.DisabledTexture:SetPoint("TOPLEFT",-5,2)
		self.Button.DisabledTexture:SetPoint("BOTTOMRIGHT",5,-2)
		
		self.Button.HighlightTexture:SetColorTexture(1,1,1,.3)
		self.Button.HighlightTexture:SetSize(0,0)
		self.Button.HighlightTexture:ClearAllPoints()
		self.Button.HighlightTexture:SetPoint("TOPLEFT")
		self.Button.HighlightTexture:SetPoint("BOTTOMRIGHT")
		self.Button:SetHighlightTexture(self.Button.HighlightTexture)
		
		Templates:Border(self.Button,0.24,0.25,0.30,1,1)
		
		self.Button.Background = self.Button:CreateTexture(nil,"BACKGROUND")
		self.Button.Background:SetColorTexture(0,0,0,.3)
		self.Button.Background:SetPoint("TOPLEFT")
		self.Button.Background:SetPoint("BOTTOMRIGHT")

		self:SetScript("OnHide",OnHide)

		return self
	end
end

do
	local function OnEscapePressed(self)
		EditBox_ClearFocus(self)
	end
	local function OnEditFocusLost(self)
		EditBox_ClearHighlight(self)
	end
	local function OnEditFocusGained(self)
		EditBox_HighlightText(self)
	end
	function Templates:ExRTInputBoxTemplate(parent)
		local self = CreateFrame("EditBox",nil,parent)
		self:EnableMouse(true)

		self.Left = self:CreateTexture(nil,"BACKGROUND")
		self.Left:SetPoint("LEFT",-5,0)
		self.Left:SetTexture("Interface\\Common\\Common-Input-Border")
		self.Left:SetSize(8,20)
		self.Left:SetTexCoord(0,0.0625,0,0.625)

		self.Right = self:CreateTexture(nil,"BACKGROUND")
		self.Right:SetPoint("RIGHT")
		self.Right:SetTexture("Interface\\Common\\Common-Input-Border")
		self.Right:SetSize(8,20)
		self.Right:SetTexCoord(0.9375,1,0,0.625)

		self.Middle = self:CreateTexture(nil,"BACKGROUND")
		self.Middle:SetSize(10,20)
		self.Middle:SetPoint("LEFT",self.Left,"RIGHT")
		self.Middle:SetPoint("RIGHT",self.Right,"LEFT")
		self.Middle:SetTexture("Interface\\Common\\Common-Input-Border")
		self.Middle:SetTexCoord(0.0625,0.9375,0,0.625)

		self:SetFontObject("ChatFontNormal") 

		self:SetScript("OnEscapePressed",OnEscapePressed)
		self:SetScript("OnEditFocusLost",OnEditFocusLost)
		self:SetScript("OnEditFocusGained",OnEditFocusGained)
		
		return self
	end
	function Templates:ExRTInputBoxModernTemplate(parent)
		local self = CreateFrame("EditBox",nil,parent)
		self:EnableMouse(true)

		Templates:Border(self,0.24,0.25,0.3,1,1)
		
		self.Background = self:CreateTexture(nil,"BACKGROUND")
		self.Background:SetColorTexture(0,0,0,.3)
		self.Background:SetPoint("TOPLEFT")
		self.Background:SetPoint("BOTTOMRIGHT")

		self:SetFontObject("ChatFontNormal") 
		
		self:SetTextInsets(4, 4, 0, 0)

		self:SetScript("OnEscapePressed",OnEscapePressed)
		self:SetScript("OnEditFocusLost",OnEditFocusLost)
		self:SetScript("OnEditFocusGained",OnEditFocusGained)
		
		return self
	end	
end

do
	local function OnEnter(self)
		if ( self:IsEnabled() ) then
			if ( self.tooltipText ) then
				GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
				GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
			end
			if ( self.tooltipRequirement ) then
				GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
				GameTooltip:Show()
			end
		end
	end
	local function OnLeave(self)
		GameTooltip:Hide()
	end
	function Templates:ExRTSliderTemplate(parent)
		local self = CreateFrame("Slider",nil,parent)
		self:SetOrientation("HORIZONTAL")
		self:SetSize(144,17)
		self:SetHitRectInsets(0, 0, -10, -10)
		
		self:SetBackdrop({
			bgFile="Interface\\Buttons\\UI-SliderBar-Background",
			edgeFile="Interface\\Buttons\\UI-SliderBar-Border",
			tile = true,
			insets = {
				left = 3,
				right = 3,
				top = 6,
				bottom = 6,
			},
			tileSize = 8,
			edgeSize = 8,
		})
		
		self.Text = self:CreateFontString(nil,"ARTWORK","GameFontHighlight")
		self.Text:SetPoint("BOTTOM",self,"TOP")

		self.Low = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.Low:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-4,3)

		self.High = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.High:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",4,3)

		self.Thumb = self:CreateTexture()
		self.Thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
		self.Thumb:SetSize(32,32)
		self:SetThumbTexture(self.Thumb)

		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		
		return self
	end
	function Templates:ExRTSliderModernTemplate(parent)
		local self = CreateFrame("Slider",nil,parent)
		self:SetOrientation("HORIZONTAL")
		self:SetSize(144,10)
		
		self.Text = self:CreateFontString(nil,"ARTWORK","GameFontHighlight")
		self.Text:SetPoint("BOTTOM",self,"TOP",0,1)

		self.Low = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.Low:SetPoint("TOPLEFT",self,"BOTTOMLEFT",0,-1)

		self.High = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.High:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",0,-1)
		
		Templates:Border(self,0.24,0.25,0.3,1,1,1,0)

		self.Thumb = self:CreateTexture()
		self.Thumb:SetColorTexture(0.44,0.45,0.50,0.7)
		self.Thumb:SetSize(16,8)
		self:SetThumbTexture(self.Thumb)

		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		
		return self
	end
	function Templates:ExRTSliderModernVerticalTemplate(parent)
		local self = CreateFrame("Slider",nil,parent)
		self:SetOrientation("VERTICAL")
		self:SetSize(10,144)
		
		self.Text = self:CreateFontString(nil,"ARTWORK","GameFontHighlight")
		self.Text:SetPoint("BOTTOM",self,"TOP",0,1)

		self.Low = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.Low:SetPoint("TOPLEFT",self,"TOPRIGHT",1,-1)

		self.High = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.High:SetPoint("BOTTOMLEFT",self,"BOTTOMRIGHT",1,1)
		
		Templates:Border(self,0.24,0.25,0.3,1,1,0,1)

		self.Thumb = self:CreateTexture()
		self.Thumb:SetColorTexture(0.44,0.45,0.50,0.7)
		self.Thumb:SetSize(8,16)
		self:SetThumbTexture(self.Thumb)

		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		
		return self
	end
end

do
	local function OnMouseDown(self)
		local parent = self:GetParent()
		parent.Icon:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -8)
		parent.IconOverlay:Show()
	end
	local function OnMouseUp(self)
		local parent = self:GetParent()
		parent.Icon:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, -6)
		parent.IconOverlay:Hide()
	end
	function Templates:ExRTTrackingButtonModernTemplate(parent)
		local self = CreateFrame("Frame",nil,parent)
		self:SetSize(32,32)
		self:SetHitRectInsets(0, 0, -10, -10)
		
		self.Icon = self:CreateTexture(nil,"ARTWORK")
		self.Icon:SetPoint("TOPLEFT",6,-6)
		self.Icon:SetTexture("Interface\\Minimap\\Tracking\\None")
		self.Icon:SetSize(20,20)
		
		self.IconOverlay = self:CreateTexture(nil,"ARTWORK")
		self.IconOverlay:SetPoint("TOPLEFT",self.Icon)
		self.IconOverlay:SetPoint("BOTTOMRIGHT",self.Icon)
		self.IconOverlay:SetColorTexture(0,0,0,0.5)
		
		self.Button = CreateFrame("Button",nil,self)
		self.Button:SetSize(32,32)
		self.Button:SetPoint("TOPLEFT")
		
		self.Button.Border = self.Button:CreateTexture(nil,"BORDER")
		self.Button.Border:SetPoint("TOPLEFT")
		self.Button.Border:SetTexture("Interface\\Addons\\"..GlobalAddonName.."\\media\\radioModern")
		self.Button.Border:SetSize(32,32)
		self.Button.Border:SetTexCoord(0,0.25,0,1)
		
		self.Button.Shine = self.Button:CreateTexture(nil,"OVERLAY")
		self.Button.Shine:SetPoint("TOPLEFT",2,-2)
		self.Button.Shine:SetTexture("Interface\\ComboFrame\\ComboPoint")
		self.Button.Shine:SetBlendMode("ADD")
		self.Button.Shine:Hide()
		self.Button.Shine:SetSize(27,27)
		self.Button.Shine:SetTexCoord(0.5625,1,0,1)
		
		self.Button:SetScript("OnMouseDown",OnMouseDown)
		self.Button:SetScript("OnMouseUp",OnMouseUp)
		
		self.Button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight","ADD")
		
		return self
	end
end

function Templates:ExRTCheckButtonModernTemplate(parent)
	local self = CreateFrame("CheckButton",nil,parent)
	self:SetSize(20,20)
	
	self.text = self:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
	self.text:SetPoint("TOPLEFT",self,"TOPRIGHT",4,0)
	self.text:SetPoint("BOTTOMLEFT",self,"BOTTOMRIGHT",4,0)
	self.text:SetJustifyV("MIDDLE")
	
	self:SetFontString(self.text)
	
	Templates:Border(self,0.24,0.25,0.3,1,1)
	
	self.Texture = self:CreateTexture(nil,"BACKGROUND")
	self.Texture:SetColorTexture(0,0,0,.3)
	self.Texture:SetPoint("TOPLEFT")
	self.Texture:SetPoint("BOTTOMRIGHT")
	
	self.CheckedTexture = self:CreateTexture()
	self.CheckedTexture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	self.CheckedTexture:SetPoint("TOPLEFT",-4,4)
	self.CheckedTexture:SetPoint("BOTTOMRIGHT",4,-4)
	self:SetCheckedTexture(self.CheckedTexture)
	
	self.PushedTexture = self:CreateTexture()
	self.PushedTexture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	self.PushedTexture:SetPoint("TOPLEFT",-4,4)
	self.PushedTexture:SetPoint("BOTTOMRIGHT",4,-4)
	self.PushedTexture:SetVertexColor(0.8,0.8,0.8,0.5)
	self.PushedTexture:SetDesaturated(true)
	self:SetPushedTexture(self.PushedTexture)

	self.DisabledTexture = self:CreateTexture()
	self.DisabledTexture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	self.DisabledTexture:SetPoint("TOPLEFT",-4,4)
	self.DisabledTexture:SetPoint("BOTTOMRIGHT",4,-4)
	self:SetDisabledTexture(self.DisabledTexture)
		
	self.HighlightTexture = self:CreateTexture()
	self.HighlightTexture:SetColorTexture(1,1,1,.3)
	self.HighlightTexture:SetPoint("TOPLEFT")
	self.HighlightTexture:SetPoint("BOTTOMRIGHT")
	self:SetHighlightTexture(self.HighlightTexture)
			
	return self
end

do
	local function ExRTButtonModernTemplate(id,parent)
		local self = Templates:GUIcons(id,parent)
		self:SetSize(16,16)
		
		Templates:Border(self,0.24,0.25,0.3,1,1)
		
		self.Background = self:CreateTexture(nil,"BACKGROUND")
		self.Background:SetColorTexture(0,0,0,.3)
		self.Background:SetPoint("TOPLEFT")
		self.Background:SetPoint("BOTTOMRIGHT")
		
		self.NormalTexture:SetPoint("TOPLEFT",-5,2)
		self.NormalTexture:SetPoint("BOTTOMRIGHT",5,-2)
	
		self.PushedTexture:SetPoint("TOPLEFT",-5,1)
		self.PushedTexture:SetPoint("BOTTOMRIGHT",5,-3)
	
		self.DisabledTexture:SetPoint("TOPLEFT",-5,2)
		self.DisabledTexture:SetPoint("BOTTOMRIGHT",5,-2)
			
		self.HighlightTexture = self:CreateTexture()
		self.HighlightTexture:SetColorTexture(1,1,1,.3)
		self.HighlightTexture:SetPoint("TOPLEFT")
		self.HighlightTexture:SetPoint("BOTTOMRIGHT")
		self:SetHighlightTexture(self.HighlightTexture)
				
		return self
	end
	
	function Templates:ExRTButtonDownModernTemplate(parent)
		return ExRTButtonModernTemplate(3,parent)
	end
	function Templates:ExRTButtonUpModernTemplate(parent)
		return ExRTButtonModernTemplate(4,parent)
	end
	
	local function OnEnter(self)
		local parent = self:GetParent()
		local myscript = parent:GetScript("OnEnter")
		if myscript then
			myscript(parent)
		end
	end
	local function OnLeave(self)
		local parent = self:GetParent()
		local myscript = parent:GetScript("OnLeave")
		if myscript then
			myscript(parent)
		end
	end
	local function OnClick(self)
		ToggleDropDownMenu(nil, nil, self:GetParent())
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end
	function Templates:ExRTUIChatDownButtonModernTemplate(parent)
		local self = ExRTButtonModernTemplate(3,parent)
		self:SetSize(20,20)
		
		self:SetScript("OnEnter",OnEnter)
		self:SetScript("OnLeave",OnLeave)
		self:SetScript("OnClick",OnClick)
				
		return self
	end
end

function Templates:ExRTRadioButtonModernTemplate(parent)
	local self = CreateFrame("CheckButton",nil,parent)
	self:SetSize(16,16)
	
	self.text = self:CreateFontString(nil,"BACKGROUND","GameFontNormalSmall")
	self.text:SetPoint("LEFT",self,"RIGHT",5,0)
	
	self:SetFontString(self.text)
	
	self.NormalTexture = self:CreateTexture()
	self.NormalTexture:SetTexture("Interface\\Addons\\"..GlobalAddonName.."\\media\\radioModern")
	self.NormalTexture:SetAllPoints()
	self.NormalTexture:SetTexCoord(0,0.25,0,1)
	self:SetNormalTexture(self.PushedTexture)

	self.HighlightTexture = self:CreateTexture()
	self.HighlightTexture:SetTexture("Interface\\Addons\\"..GlobalAddonName.."\\media\\radioModern")
	self.HighlightTexture:SetAllPoints()
	self.HighlightTexture:SetTexCoord(0.5,0.75,0,1)
	self:SetHighlightTexture(self.HighlightTexture)
	
	self.CheckedTexture = self:CreateTexture()
	self.CheckedTexture:SetTexture("Interface\\Addons\\"..GlobalAddonName.."\\media\\radioModern")
	self.CheckedTexture:SetAllPoints()
	self.CheckedTexture:SetTexCoord(0.25,0.5,0,1)
	self:SetCheckedTexture(self.CheckedTexture)
			
	return self
end

--=======================================================================
--=======================================================================
--=============================  WIDGETS ================================
--=======================================================================
--=======================================================================

function ELib.AddShadowComment(self,hide,moduleName,userComment,userFontSize,userOutline)
	if self.moduleNameString then
		if hide then
			self.moduleNameString:Hide()
		else
			local selfWidth = self:GetWidth()
			local selfHeight = self:GetHeight()
			self.moduleNameString:SetSize(selfWidth,selfHeight)
			self.moduleNameString:Show()
		end
	elseif not hide and moduleName then
		local selfWidth = self:GetWidth()
		local selfHeight = self:GetHeight()
		self.moduleNameString = ELib.CreateText(self,selfWidth,selfHeight,"BOTTOMRIGHT", -5, 4,"RIGHT","BOTTOM",DEFAULT_FONT, 18,moduleName or "",nil)
		self.moduleNameString:SetTextColor(1, 1, 1, 0.8)
	end

	if self.userCommentString then
		if hide then
			self.userCommentString:Hide()
		else
			local selfWidth = self:GetWidth()
			local selfHeight = self:GetHeight()
			self.userCommentString:SetSize(selfWidth,selfHeight)
			self.userCommentString:Show()
		end
	elseif not hide and userComment then
		local selfWidth = self:GetWidth()
		local selfHeight = self:GetHeight()
		self.userCommentString = ELib.CreateText(self,selfWidth,selfHeight,"BOTTOMRIGHT", -5, 20,"RIGHT","BOTTOM",DEFAULT_FONT, userFontSize or 18,userComment or "",nil,0,0,0,nil,userOutline)
		self.userCommentString:SetTextColor(0, 0, 0, 0.7)
		self.userCommentString:SetShadowColor(1,1,1,1)
		self.userCommentString:SetShadowOffset(1,-1)
	end
end

do
	local function Widget_TexCoord(self,...)
		self:SetTexCoord(...)
		return self
	end
	local function Widget_Color(self,...)
		self:SetVertexColor(...)
		return self
	end
	local function Widget_BlendMode(self,...)
		self:SetBlendMode(...)
		return self
	end
	local function Widget_Gradient(self,...)
		self:SetGradientAlpha(...)
		return self
	end	
	function ELib:Texture(parent,texture,...)
		local layer,cR,cG,cB,cA = nil
		if type(texture) == 'number' then
			cG,cB,cA,layer = ...
			cR = texture
			texture = nil
		else
			layer = ...
		end
	
		local self = parent:CreateTexture(nil,layer or "BACKGROUND")
		Mod(self,
			'Color',Widget_Color,
			'TexCoord',Widget_TexCoord,
			'BlendMode',Widget_BlendMode,
			'Gradient',Widget_Gradient
		)
		
		if texture then
			self:SetTexture(texture)
		elseif cR then
			self:SetColorTexture(cR,cG,cB,cA)
		end
		
		return self
	end
end

do
	function ELib:Shadow(parent,size,edgeSize)
		local self = CreateFrame("Frame",nil,parent)
		self:SetPoint("LEFT",-size,0)
		self:SetPoint("RIGHT",size,0)
		self:SetPoint("TOP",0,size)
		self:SetPoint("BOTTOM",0,-size)
		self:SetBackdrop({edgeFile="Interface/AddOns/"..GlobalAddonName.."/media/shadow",edgeSize=edgeSize or 28,insets={left=size,right=size,top=size,bottom=size}})
		self:SetBackdropBorderColor(0,0,0,.45)
	
		return self
	end
	function ELib:Shadow2(self,size,offsetX,offsetY,isBold)
		offsetX = offsetX or 0
		offsetY = offsetY or 0
		isBold = true
	
		self.ShadowTop = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowTop:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowTop:SetPoint("TOPLEFT",10,size+offsetY)
		self.ShadowTop:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",-10,offsetY)
		self.ShadowTop:SetVertexColor(0,0,0,.45)
		self.ShadowTop:SetTexCoord((128+31)/256,(128+32)/256,0,22/32)
		
		self.ShadowTopLeftInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowTopLeftInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowTopLeftInside:SetPoint("TOPLEFT",-offsetX,size+offsetY)
		self.ShadowTopLeftInside:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",-offsetX+10,offsetY)
		self.ShadowTopLeftInside:SetVertexColor(0,0,0,.45)
		self.ShadowTopLeftInside:SetTexCoord((128+22)/256,(128+32)/256,0,22/32)	
		
		self.ShadowTopLeft = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowTopLeft:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowTopLeft:SetPoint("TOPLEFT",-offsetX-size,size+offsetY)
		self.ShadowTopLeft:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",-offsetX,offsetY)
		self.ShadowTopLeft:SetVertexColor(0,0,0,.45)
		self.ShadowTopLeft:SetTexCoord((128+0)/256,(128+22)/256,0,22/32)	
	
		self.ShadowTopRightInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowTopRightInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowTopRightInside:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX-10,size+offsetY)
		self.ShadowTopRightInside:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",offsetX,offsetY)
		self.ShadowTopRightInside:SetVertexColor(0,0,0,.45)
		self.ShadowTopRightInside:SetTexCoord((128+32)/256,(128+22)/256,0,22/32)	
	
		self.ShadowTopRight = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowTopRight:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowTopRight:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX,size+offsetY)
		self.ShadowTopRight:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",offsetX+size,offsetY)
		self.ShadowTopRight:SetVertexColor(0,0,0,.45)
		self.ShadowTopRight:SetTexCoord((128+22)/256,(128+0)/256,0,22/32)
		
		self.ShadowLeftTopInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowLeftTopInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowLeftTopInside:SetPoint("TOPLEFT",-offsetX-size,offsetY)
		self.ShadowLeftTopInside:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",-offsetX,offsetY-10)
		self.ShadowLeftTopInside:SetVertexColor(0,0,0,.45)
		self.ShadowLeftTopInside:SetTexCoord((128+0)/256,(128+22)/256,22/32,32/32)
		
		self.ShadowLeft = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowLeft:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowLeft:SetPoint("TOPLEFT",-offsetX-size,offsetY-10)
		self.ShadowLeft:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY+10)
		self.ShadowLeft:SetVertexColor(0,0,0,.45)
		self.ShadowLeft:SetTexCoord((128+0)/256,(128+22)/256,31/32,32/32)		
			
		self.ShadowLeftBottomInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowLeftBottomInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowLeftBottomInside:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX-size,-offsetY+10)
		self.ShadowLeftBottomInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY)
		self.ShadowLeftBottomInside:SetVertexColor(0,0,0,.45)
		self.ShadowLeftBottomInside:SetTexCoord((128+0)/256,(128+22)/256,32/32,22/32)
		
		self.ShadowLeftBottom = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowLeftBottom:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowLeftBottom:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX-size,-offsetY)
		self.ShadowLeftBottom:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY-size)
		self.ShadowLeftBottom:SetVertexColor(0,0,0,.45)
		self.ShadowLeftBottom:SetTexCoord((128+0)/256,(128+22)/256,22/32,0)
	
		self.ShadowBottomLeftInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowBottomLeftInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowBottomLeftInside:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX,-offsetY)
		self.ShadowBottomLeftInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX+10,-offsetY-size)
		self.ShadowBottomLeftInside:SetVertexColor(0,0,0,.45)
		self.ShadowBottomLeftInside:SetTexCoord((128+22)/256,(128+32)/256,22/32,0)
	
		self.ShadowBottom = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowBottom:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowBottom:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX+10,-offsetY)
		self.ShadowBottom:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX-10,-offsetY-size)
		self.ShadowBottom:SetVertexColor(0,0,0,.45)
		self.ShadowBottom:SetTexCoord((128+31)/256,(128+32)/256,22/32,0)	
	
		self.ShadowBottomRightInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowBottomRightInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowBottomRightInside:SetPoint("TOPLEFT",self,"BOTTOMRIGHT",offsetX-10,-offsetY)
		self.ShadowBottomRightInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX,-offsetY-size)
		self.ShadowBottomRightInside:SetVertexColor(0,0,0,.45)
		self.ShadowBottomRightInside:SetTexCoord((128+32)/256,(128+22)/256,22/32,0)
		
		self.ShadowBottomRight = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowBottomRight:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowBottomRight:SetPoint("TOPLEFT",self,"BOTTOMRIGHT",offsetX,-offsetY)
		self.ShadowBottomRight:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX+size,-offsetY-size)
		self.ShadowBottomRight:SetVertexColor(0,0,0,.45)
		self.ShadowBottomRight:SetTexCoord((128+22)/256,(128+0)/256,22/32,0)
		
		self.ShadowRightBottomInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowRightBottomInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowRightBottomInside:SetPoint("TOPLEFT",self,"BOTTOMRIGHT",offsetX,-offsetY+10)
		self.ShadowRightBottomInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX+size,-offsetY)
		self.ShadowRightBottomInside:SetVertexColor(0,0,0,.45)
		self.ShadowRightBottomInside:SetTexCoord((128+22)/256,(128+0)/256,32/32,22/32)
		
		self.ShadowRight = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowRight:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowRight:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX,offsetY-10)
		self.ShadowRight:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX+size,-offsetY+10)
		self.ShadowRight:SetVertexColor(0,0,0,.45)
		self.ShadowRight:SetTexCoord((128+22)/256,(128+0)/256,31/32,32/32)
		
		self.ShadowRightTopInside = self:CreateTexture(nil,"BACKGROUND")
		self.ShadowRightTopInside:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/shadow")
		self.ShadowRightTopInside:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX,offsetY)
		self.ShadowRightTopInside:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",offsetX+size,offsetY-10)
		self.ShadowRightTopInside:SetVertexColor(0,0,0,.45)
		self.ShadowRightTopInside:SetTexCoord((128+22)/256,(128+0)/256,22/32,32/32)
		
		if isBold then
			self.ShadowTop:SetTexCoord((192+31)/256,(192+32)/256,1,10/32)
			self.ShadowTopLeftInside:SetTexCoord((192+22)/256,(192+32)/256,1,10/32)	
			self.ShadowTopLeft:SetTexCoord((192+0)/256,(192+22)/256,1,10/32)	
			self.ShadowTopRightInside:SetTexCoord((192+32)/256,(192+22)/256,1,10/32)	
			self.ShadowTopRight:SetTexCoord((192+22)/256,(192+0)/256,1,10/32)
			self.ShadowLeftTopInside:SetTexCoord((192+0)/256,(192+22)/256,10/32,0)
			self.ShadowLeft:SetTexCoord((192+0)/256,(192+22)/256,1/32,0)		
			self.ShadowLeftBottomInside:SetTexCoord((192+0)/256,(192+22)/256,0,10/32)
			self.ShadowLeftBottom:SetTexCoord((192+0)/256,(192+22)/256,10/32,1)
			self.ShadowBottomLeftInside:SetTexCoord((192+22)/256,(192+32)/256,10/32,1)
			self.ShadowBottom:SetTexCoord((192+31)/256,(192+32)/256,10/32,1)	
			self.ShadowBottomRightInside:SetTexCoord((192+32)/256,(192+22)/256,10/32,1)
			self.ShadowBottomRight:SetTexCoord((192+22)/256,(192+0)/256,10/32,1)
			self.ShadowRightBottomInside:SetTexCoord((192+22)/256,(192+0)/256,0,10/32)
			self.ShadowRight:SetTexCoord((192+22)/256,(192+0)/256,1/32,0)
			self.ShadowRightTopInside:SetTexCoord((192+22)/256,(192+0)/256,10/32,0)
		end
	end
	function ELib.CreateShadow(parent,size,edgeSize)
		return ELib:Shadow(parent,size,edgeSize)
	end
end

do
	function ELib:ShadowInside(mainFrame,enableBorder,enableLine)
		if enableBorder then
			local OverlayShadowTopLeft = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowTopLeft:SetPoint("TOPLEFT",4,-4)
			OverlayShadowTopLeft:SetAtlas("collections-background-shadow-small",true)
		
			local OverlayShadowTop = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowTop:SetPoint("TOPLEFT",17,-4)
			OverlayShadowTop:SetPoint("TOPRIGHT",-17,-4)
			OverlayShadowTop:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowTop:SetTexCoord(0.9999,1,0,1)
			
			local OverlayShadowTopRight = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowTopRight:SetPoint("TOPRIGHT",-4,-4)
			OverlayShadowTopRight:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowTopRight:SetTexCoord(1,0,0,1)
		
			local OverlayShadowLeft = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowLeft:SetPoint("TOPLEFT",4,-17)
			OverlayShadowLeft:SetPoint("BOTTOMLEFT",4,17)
			OverlayShadowLeft:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowLeft:SetTexCoord(0,1,0.9999,1)
			
			local OverlayShadowBottomLeft = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowBottomLeft:SetPoint("BOTTOMLEFT",4,4)
			OverlayShadowBottomLeft:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowBottomLeft:SetTexCoord(0,1,1,0)
			
			local OverlayShadowRight = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowRight:SetPoint("TOPRIGHT",-4,-17)
			OverlayShadowRight:SetPoint("BOTTOMRIGHT",-4,17)
			OverlayShadowRight:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowRight:SetTexCoord(1,0,0.9999,1)
			
			local OverlayShadowBottomRight = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowBottomRight:SetPoint("BOTTOMRIGHT",-4,4)
			OverlayShadowBottomRight:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowBottomRight:SetTexCoord(1,0,1,0)
			
			local OverlayShadowBottom = mainFrame:CreateTexture(nil,"OVERLAY")
			OverlayShadowBottom:SetPoint("BOTTOMLEFT",17,4)
			OverlayShadowBottom:SetPoint("BOTTOMRIGHT",-17,4)
			OverlayShadowBottom:SetAtlas("collections-background-shadow-small",true)
			OverlayShadowBottom:SetTexCoord(0.9999,1,1,0)
		end
	
		if enableLine then
			local ShadowLineTop = mainFrame:CreateTexture(nil,"BORDER",nil,1)
			ShadowLineTop:SetPoint("TOPLEFT",4,-13)
			ShadowLineTop:SetPoint("BOTTOMRIGHT",mainFrame,"TOPRIGHT",-4,-17)
			ShadowLineTop:SetAtlas("_collections-background-line",true)
			ShadowLineTop:SetHorizTile(true)
		
			local ShadowLineBottom = mainFrame:CreateTexture(nil,"BORDER",nil,1)
			ShadowLineBottom:SetPoint("TOPLEFT",mainFrame,"BOTTOMLEFT",4,17)
			ShadowLineBottom:SetPoint("BOTTOMRIGHT",-4,13)
			ShadowLineBottom:SetAtlas("_collections-background-line",true)
			ShadowLineBottom:SetHorizTile(true)
		end
		
		local offset = enableBorder and 4 or 0
		local notOffset = enableBorder and 0 or 4
		
		local ShadowCornerTopLeft = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerTopLeft:SetPoint("TOPLEFT",offset,-offset)
		ShadowCornerTopLeft:SetAtlas("collections-background-shadow-large",true)
		
		local ShadowCornerTopRight = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerTopRight:SetPoint("TOPRIGHT",-offset,-offset)
		ShadowCornerTopRight:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerTopRight:SetTexCoord(1,0,0,1)
		
		local ShadowCornerBottomLeft = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerBottomLeft:SetPoint("BOTTOMLEFT",offset,offset)
		ShadowCornerBottomLeft:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerBottomLeft:SetTexCoord(0,1,1,0)
		
		local ShadowCornerBottomRight = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerBottomRight:SetPoint("BOTTOMRIGHT",-offset,offset)
		ShadowCornerBottomRight:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerBottomRight:SetTexCoord(1,0,1,0)
	
		local ShadowCornerTop = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerTop:SetPoint("TOPLEFT",149-notOffset,-offset)
		ShadowCornerTop:SetPoint("TOPRIGHT",-149+notOffset,-offset)
		ShadowCornerTop:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerTop:SetTexCoord(0.9999,1,0,1)	
		
		local ShadowCornerLeft = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerLeft:SetPoint("TOPLEFT",offset,-151+notOffset)
		ShadowCornerLeft:SetPoint("BOTTOMLEFT",offset,151-notOffset)
		ShadowCornerLeft:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerLeft:SetTexCoord(0,1,0.9999,1)
	
		local ShadowCornerRight = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerRight:SetPoint("TOPRIGHT",-offset,-151+notOffset)
		ShadowCornerRight:SetPoint("BOTTOMRIGHT",-offset,151-notOffset)
		ShadowCornerRight:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerRight:SetTexCoord(1,0,0.9999,1)
	
		local ShadowCornerBottom = mainFrame:CreateTexture(nil,"BORDER",nil,2)
		ShadowCornerBottom:SetPoint("BOTTOMLEFT",149-notOffset,offset)
		ShadowCornerBottom:SetPoint("BOTTOMRIGHT",-149+notOffset,offset)
		ShadowCornerBottom:SetAtlas("collections-background-shadow-large",true)
		ShadowCornerBottom:SetTexCoord(0.9999,1,1,0)
	end
end

do
	local function SliderOnMouseWheel(self,delta)
		if tonumber(self:GetValue()) == nil then 
			return 
		end
		if self.isVertical then
			delta = -delta
		end
		self:SetValue(tonumber(self:GetValue())+delta)
	end
	local function SliderTooltipShow(self)
		local text = self.text:GetText()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText or "")
		GameTooltip:AddLine(text or "",1,1,1)
		GameTooltip:Show()
	end
	local function SliderTooltipReload(self)
		if GameTooltip:IsVisible() then
			self:tooltipHide()
			self:tooltipShow()
		end
	end
	local function Widget_Range(self,minVal,maxVal,hideRange)
		self.Low:SetText(minVal)
		self.High:SetText(maxVal)
		self:SetMinMaxValues(minVal, maxVal)
		if not self.isVertical then
			self.Low:SetShown(not hideRange)
			self.High:SetShown(not hideRange)
		end
		
		return self
	end
	local function Widget_Size(self,size)
		if self:GetOrientation() == "VERTICAL" then
			self:SetHeight(size)
		else
			self:SetWidth(size)
		end
		return self
	end
	local function Widget_SetTo(self,value)
		if not value then
			local min,max = self:GetMinMaxValues()
			value = max
		end
		self.tooltipText = value
		self:SetValue(value)
		return self
	end
	local function Widget_OnChange(self,func)
		self:SetScript("OnValueChanged",func)
		return self
	end	
	local function Widget_SetTooltip(self,tooltipText)
		self.tooltipText = tooltipText
		return self
	end
	
	function ELib:Slider(parent,text,isVertical,template)
		if template == 0 then
			template = "ExRTSliderTemplate"
		elseif not template then
			template = isVertical and "ExRTSliderModernVerticalTemplate" or "ExRTSliderModernTemplate"
		end
		local self = ELib:Template(template,parent) or CreateFrame("Slider",nil,parent,template)
		self.text = self.Text
		self.text:SetText(text or "")
		if isVertical then
			self.Low:Hide()
			self.High:Hide()
			self.text:Hide()			
			self.isVertical = true
		end
		self:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
		self:SetValueStep(1)
		--self:SetObeyStepOnDrag(true)
		
		self.isVertical = isVertical
		
		self:SetScript("OnMouseWheel", SliderOnMouseWheel)

		self.tooltipShow = SliderTooltipShow
		self.tooltipHide = GameTooltip_Hide
		self.tooltipReload = SliderTooltipReload
		self:SetScript("OnEnter", self.tooltipShow)
		self:SetScript("OnLeave", self.tooltipHide)
		
		Mod(self)
		self.Range = Widget_Range
		self.SetTo = Widget_SetTo
		self.OnChange = Widget_OnChange
		self.Tooltip = Widget_SetTooltip
		
		if template and template:find("^ExRTSliderModern") then
			self._Size = self.Size
			self.Size = Widget_Size
			
			self.text:SetFont(self.text:GetFont(),10)
			self.Low:SetFont(self.Low:GetFont(),10)
			self.High:SetFont(self.High:GetFont(),10)
		end

		return self
	end
	function ELib.CreateSlider(parent,width,height,x,y,minVal,maxVal,text,defVal,relativePoint,isVertical,isModern)
		return ELib:Slider(parent,text,isVertical,(not isModern) and 0):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Range(minVal,maxVal):SetTo(defVal or maxVal)
	end
end

do
	local function ScrollBarButtonUpClick(self)
		local scrollBar = self:GetParent()
		if not scrollBar.GetMinMaxValues then scrollBar = scrollBar.slider end
		local min,max = scrollBar:GetMinMaxValues()
		local val = scrollBar:GetValue()
		local clickRange = self:GetParent().clickRange
		if (val - clickRange) < min then
			scrollBar:SetValue(min)
		else
			scrollBar:SetValue(val - clickRange)
		end
	end
	local function ScrollBarButtonDownClick(self)
		local scrollBar = self:GetParent()
		if not scrollBar.GetMinMaxValues then scrollBar = scrollBar.slider end
		local min,max = scrollBar:GetMinMaxValues()
		local val = scrollBar:GetValue()
		local clickRange = self:GetParent().clickRange
		if (val + clickRange) > max then
			scrollBar:SetValue(max)
		else
			scrollBar:SetValue(val + clickRange)
		end
	end
	local function ScrollBarButtonUpMouseHoldDown(self)
		local counter = 0
		self.ticker = C_Timer.NewTicker(.03,function()
			counter = counter + 1
			if counter > 10 then
				ScrollBarButtonUpClick(self)
			end
		end)
	end
	local function ScrollBarButtonUpMouseHoldUp(self)
 		if self.ticker then
 			self.ticker:Cancel()
 		end
	end
	local function ScrollBarButtonDownMouseHoldDown(self)
		local counter = 0
		self.ticker = C_Timer.NewTicker(.03,function()
			counter = counter + 1
			if counter > 10 then
				ScrollBarButtonDownClick(self)
			end
		end)
	end
	local function ScrollBarButtonDownMouseHoldUp(self)
 		if self.ticker then
 			self.ticker:Cancel()
 		end
	end
	
	local function Widget_Size(self, width, height)
		self:SetSize(width, height)
		self.thumb:SetWidth(width - 2)
		if self.isOld then self.thumb:SetSize(width + 10,width + 10) end
		self.slider:SetPoint("TOPLEFT",0,-width-2)
		self.slider:SetPoint("BOTTOMRIGHT",0,width+2)
		self.buttonUP:SetSize(width,width)
		self.buttonDown:SetSize(width,width)
		
		return self
	end
	local function Widget_Range(self,minVal,maxVal,clickRange,unchangedValue)
		self.slider:SetMinMaxValues(minVal, maxVal)
		self.clickRange = clickRange or self.clickRange or 1
		if not unchangedValue then
			self.slider:SetValue(minVal)
		end
		
		return self
	end
	local function Widget_SetValue(self,value)
		self.slider:SetValue(value)
		self:UpdateButtons()
		return self
	end
	local function Widget_GetValue(self)
		return self.slider:GetValue()
	end	
	local function Widget_GetMinMaxValues(self)
		return self.slider:GetMinMaxValues()
	end
	local function Widget_SetMinMaxValues(self,...)
		self.slider:SetMinMaxValues(...)
		self:UpdateButtons()
		return self
	end
	local function Widget_SetScript(self,...)
		self.slider:SetScript(...)
		return self
	end
	local function Widget_OnChange(self,func)
		self.slider:SetScript("OnValueChanged",func)
		return self
	end
	local function Widget_UpdateButtons(self)
		local slider = self.slider
		local value = Round(slider:GetValue())
		local min,max = slider:GetMinMaxValues()
		if max == min then
			self.buttonUP:SetEnabled(false)	self.buttonDown:SetEnabled(false)
		elseif value <= min then
			self.buttonUP:SetEnabled(false)	self.buttonDown:SetEnabled(true)
		elseif value >= max then
			self.buttonUP:SetEnabled(true)	self.buttonDown:SetEnabled(false)
		else
			self.buttonUP:SetEnabled(true)	self.buttonDown:SetEnabled(true)
		end
		return self
	end
	local function Widget_Slider_UpdateButtons(self)
		self:GetParent():UpdateButtons()
		return self
	end
	local function Widget_ClickRange(self,value)
		self.clickRange = value or 1
		return self
	end
			
	function ELib:ScrollBar(parent,isOld)
		local self = CreateFrame("Frame", nil, parent)
	
		self.slider = CreateFrame("Slider", nil, self)
		self.slider:SetPoint("TOPLEFT",0,-18)
		self.slider:SetPoint("BOTTOMRIGHT",0,18)

		self.bg = self.slider:CreateTexture(nil, "BACKGROUND")
		self.bg:SetPoint("TOPLEFT",0,1)
		self.bg:SetPoint("BOTTOMRIGHT",0,-1)
		self.bg:SetColorTexture(0, 0, 0, 0.3)
		if not isOld then
			self.thumb = self.slider:CreateTexture(nil, "OVERLAY")
			self.thumb:SetColorTexture(0.44,0.45,0.50,.7)
			self.thumb:SetSize(14,30)
		else
			self.thumb = self.slider:CreateTexture(nil, "OVERLAY")
			self.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
			self.thumb:SetSize(25, 25)
		end
		self.slider:SetThumbTexture(self.thumb)
		self.slider:SetOrientation("VERTICAL")
		self.slider:SetValue(2)
		
		if not isOld then
			self.borderLeft = self.slider:CreateTexture(nil, "BACKGROUND")
			self.borderLeft:SetPoint("TOPLEFT",-1,1)
			self.borderLeft:SetPoint("BOTTOMLEFT",-1,-1)
			self.borderLeft:SetWidth(1)
			self.borderLeft:SetColorTexture(0.24,0.25,0.30,1)
			
			self.borderRight = self.slider:CreateTexture(nil, "BACKGROUND")
			self.borderRight:SetPoint("TOPRIGHT",1,1)
			self.borderRight:SetPoint("BOTTOMRIGHT",1,-1)
			self.borderRight:SetWidth(1)
			self.borderRight:SetColorTexture(0.24,0.25,0.30,1)
		end
		
		self.buttonUP = ELib:Template(isOld and "UIPanelScrollUPButtonTemplate" or "ExRTButtonUpModernTemplate",self) or CreateFrame("Button",nil,self,isOld and "UIPanelScrollUPButtonTemplate" or "ExRTButtonUpModernTemplate")
		self.buttonUP:SetSize(16,16)
		self.buttonUP:SetPoint("TOP",0,0) 
		self.buttonUP:SetScript("OnClick",ScrollBarButtonUpClick)
		self.buttonUP:SetScript("OnMouseDown",ScrollBarButtonUpMouseHoldDown)
		self.buttonUP:SetScript("OnMouseUp",ScrollBarButtonUpMouseHoldUp)
	
		self.buttonDown = ELib:Template(isOld and "UIPanelScrollDownButtonTemplate" or "ExRTButtonDownModernTemplate",self) or CreateFrame("Button",nil,self,isOld and "UIPanelScrollDownButtonTemplate" or "ExRTButtonDownModernTemplate")
		self.buttonDown:SetPoint("BOTTOM",0,0) 
		self.buttonDown:SetSize(16,16)
		self.buttonDown:SetScript("OnClick",ScrollBarButtonDownClick)
		self.buttonDown:SetScript("OnMouseDown",ScrollBarButtonDownMouseHoldDown)
		self.buttonDown:SetScript("OnMouseUp",ScrollBarButtonDownMouseHoldUp)
		
		self.clickRange = 1
		self.isOld = isOld
		
		self._SetScript = self.SetScript
		Mod(self,
			'Range',Widget_Range,
			'SetValue',Widget_SetValue,
			'SetTo',Widget_SetValue,
			'GetValue',Widget_GetValue,
			'GetMinMaxValues',Widget_GetMinMaxValues,
			'SetMinMaxValues',Widget_SetMinMaxValues,
			'SetScript',Widget_SetScript,
			'OnChange',Widget_OnChange,
			'UpdateButtons',Widget_UpdateButtons,
			'ClickRange',Widget_ClickRange
		)
		self.Size = Widget_Size
		self.slider.UpdateButtons = Widget_Slider_UpdateButtons
		
		return self
	end
	function ELib.CreateScrollBarModern(parent,width,height,x,y,minVal,maxVal,relativePoint,clickRange)
		return ELib:ScrollBar(parent):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Range(minVal,maxVal):ClickRange(clickRange)
	end
	function ELib.CreateScrollBar(parent,width,height,x,y,minVal,maxVal,relativePoint,clickRange)
		return ELib:ScrollBar(parent,true):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Range(minVal,maxVal):ClickRange(clickRange)
	end
end

do
	local Tooltip = {}
	ELib.Tooltip = Tooltip

	function Tooltip:Hide()
		GameTooltip_Hide()
	end
	function Tooltip:Std(anchorUser)
		GameTooltip:SetOwner(self,anchorUser or "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText or "", nil, nil, nil, nil, true)
		GameTooltip:Show()
	end
	function Tooltip:Link(data,...)
		if not data then return end
		local x = self:GetRight()
		if x >= ( GetScreenWidth() / 2 ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		GameTooltip:SetHyperlink(data,...)
		GameTooltip:Show()
	end
	function Tooltip:Show(anchorUser,title,...)
		if not title then return end
		local x,y = 0,0
		if type(anchorUser) == "table" then
			x = anchorUser[2]
			y = anchorUser[3]
			anchorUser = anchorUser[1] or "ANCHOR_RIGHT"
		elseif not anchorUser then
			anchorUser = "ANCHOR_RIGHT"
		end
		GameTooltip:SetOwner(self,anchorUser or "ANCHOR_RIGHT",x,y)
		GameTooltip:SetText(title)
		for i=1,select("#", ...) do
			local line = select(i, ...)
			if type(line) == "table" then
				if not line.right then
					if line[1] then
						GameTooltip:AddLine(unpack(line))
					end
				else
					GameTooltip:AddDoubleLine(line[1], line.right, line[2],line[3],line[4], line[2],line[3],line[4])
				end
			else
				GameTooltip:AddLine(line)
			end
		end
		GameTooltip:Show()
	end
	function Tooltip:Edit_Show(linkData,link)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(linkData)
		GameTooltip:Show()
	end
	function Tooltip:Edit_Click(linkData,link,button)
		ExRT.F.LinkItem(nil,link)
	end
	
	--- additional tooltips
	
	local additionalTooltips = {}
	local additionalTooltipBackdrop = {bgFile="Interface/Buttons/WHITE8X8",edgeFile="Interface/Tooltips/UI-Tooltip-Border",tile=false,edgeSize=14,insets={left=2.5,right=2.5,top=2.5,bottom=2.5}}
	local function CreateAdditionalTooltip()
		local new = #additionalTooltips + 1
		local tip = CreateFrame("GameTooltip", GlobalAddonName.."LibAdditionalTooltip"..new, UIParent, "GameTooltipTemplate")
		additionalTooltips[new] = tip
		
		tip:SetScript("OnLoad",nil)
		tip:SetScript("OnHide",nil)
	
		tip:SetBackdrop(additionalTooltipBackdrop)
		tip:SetBackdropColor(0,0,0,1)
		tip:SetBackdropBorderColor(0.3,0.3,0.4,1)
		
		tip.gradientTexture = tip:CreateTexture()
		tip.gradientTexture:SetColorTexture(1,1,1,1)
		tip.gradientTexture:SetGradientAlpha("VERTICAL",0,0,0,0,.8,.8,.8,.2)
		tip.gradientTexture:SetPoint("TOPLEFT",2.5,-2.5)
		tip.gradientTexture:SetPoint("BOTTOMRIGHT",-2.5,2.5)
		
		tip:Hide()
		
		return new
	end
	function Tooltip:Add(link,data,enableMultiline,disableTitle)
		local tooltipID = nil
		for i=1,#additionalTooltips do
			if not additionalTooltips[i]:IsShown() then
				tooltipID = i
				break
			end
		end
		if not tooltipID then
			tooltipID = CreateAdditionalTooltip()
		end
		local tooltip = additionalTooltips[tooltipID]
		local owner = nil
		if tooltipID == 1 then
			owner = GameTooltip
		else
			owner = additionalTooltips[tooltipID - 1]
		end
		tooltip:SetOwner(owner, "ANCHOR_NONE")
		if link then
			tooltip:SetHyperlink(link)
		else
			for i=1,#data do
				tooltip:AddLine(data[i], nil, nil, nil, enableMultiline and true)
			end
		end
		if disableTitle then
			local textObj = _G[tooltip:GetName().."TextLeft1"]
			local arg1,arg2,arg3,arg4,arg5 = textObj:GetFont()
			textObj:SetFont( arg1,select(2,_G[tooltip:GetName().."TextLeft2"]:GetFont()),arg3,arg4,arg5 )
			tooltip.titleDisabled = tooltip.titleDisabled or arg2
		elseif tooltip.titleDisabled then
			local textObj = _G[tooltip:GetName().."TextLeft1"]
			local arg1,arg2,arg3,arg4,arg5 = textObj:GetFont()
			textObj:SetFont( arg1,tooltip.titleDisabled,arg3,arg4,arg5 )
			tooltip.titleDisabled = nil
		end
		tooltip:ClearAllPoints()
		local isTop = false
		if tooltipID > 1 then
			local ownerPoint = owner:GetPoint()
			if ownerPoint == "BOTTOMRIGHT" then
				isTop = true
			end
		end
		if not isTop then
			tooltip:SetPoint("TOPRIGHT",owner,"BOTTOMRIGHT",0,0)
		else
			tooltip:SetPoint("BOTTOMRIGHT",owner,"TOPRIGHT",0,0)
		end
		tooltip:Show()
		if not isTop and (tooltip:GetBottom() or 0) < 1 then
			owner = nil
			for i=1,(tooltipID-1) do
				local point = additionalTooltips[i]:GetPoint()
				if point ~= "TOPRIGHT" then
					owner = additionalTooltips[i]
				end
			end
			owner = owner or GameTooltip
			tooltip:ClearAllPoints()
			tooltip:SetPoint("BOTTOMRIGHT",owner,"TOPRIGHT",0,0)
		end
	end
	function Tooltip:HideAdd()
		for i=1,#additionalTooltips do
			additionalTooltips[i]:Hide()
			additionalTooltips[i]:ClearLines()
		end
	end
	
	-- Old
	function ELib.AdditionalTooltip(...)
		Tooltip:Add(...)
	end
	function ELib.HideAdditionalTooltips()
		Tooltip:HideAdd()
	end
	function ELib.TooltipHide()
		Tooltip:Hide()
	end
	function ELib.OnLeaveHyperLinkTooltip()
		Tooltip:Hide()
	end
	function ELib.EditBoxOnLeaveHyperLinkTooltip()
		Tooltip:Hide()
	end
	function ELib.OnLeaveTooltip()
		Tooltip:Hide()
	end
	function ELib.OnEnterHyperLinkTooltip(...)
		Tooltip.Link(...)
	end
	function ELib.EditBoxOnEnterHyperLinkTooltip(...)
		Tooltip.Edit_Show(...)
	end
	function ELib.EditBoxOnClickHyperLinkTooltip(...)
		Tooltip.Edit_Click(...)
	end
	function ELib.OnEnterTooltip(...)
		Tooltip.Std(...)
	end
	function ELib.TooltipShow(...)
		Tooltip.Show(...)
	end
end

function ELib.ShowOrHide(self,bool)
	if not self then return end
	if bool then
		self:Show()
	else
		self:Hide()
	end
end

function ELib.SetAlphas(alpha,...)
	for i=1,select("#", ...) do
		local self = select(i, ...)
		self:SetAlpha(alpha)
	end
end

do
	local function TabFrame_DeselectTab(self)
		self.Left:Show()
		self.Middle:Show()
		self.Right:Show()

		self:Enable()
		local offsetX = self.Icon and 8 or 0
		self.Text:SetPoint("CENTER", self, "CENTER", offsetX, -3)
		
		self.LeftDisabled:Hide()
		self.MiddleDisabled:Hide()
		self.RightDisabled:Hide()
		
		self.ButtonState = false
	end
	--PanelTemplates_SelectTab
	local function TabFrame_SelectTab(self)
		self.Left:Hide()
		self.Middle:Hide()
		self.Right:Hide()

		self:Disable()
		local offsetX = self.Icon and 8 or 0
		--self:SetDisabledFontObject(GameFontHighlightSmall)
		self.Text:SetPoint("CENTER", self, "CENTER", offsetX, -2)
		
		self.LeftDisabled:Show()
		self.MiddleDisabled:Show()
		self.RightDisabled:Show()
		
		self.ButtonState = true
	end
	--PanelTemplates_DeselectTab
	local function TabFrame_ResizeTab(self, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)	
		local buttonMiddle = self.Middle
		local buttonMiddleDisabled = self.MiddleDisabled
		
		if self.Icon then
			if maxWidth then
				maxWidth = maxWidth + 18
			end
			if absoluteTextSize then
				absoluteTextSize = absoluteTextSize + 18
			end
		end
		
		local sideWidths = 2 * self.Left:GetWidth()
		local tabText = self.Text
		local width, tabWidth
		local textWidth
		if ( absoluteTextSize ) then
			textWidth = absoluteTextSize
		else
			tabText:SetWidth(0)
			textWidth = tabText:GetWidth()
		end
		-- If there's an absolute size specified then use it
		if ( absoluteSize ) then
			if ( absoluteSize < sideWidths) then
				width = 1
				tabWidth = sideWidths
			else
				width = absoluteSize - sideWidths
				tabWidth = absoluteSize
			end
			tabText:SetWidth(width)
		else
			-- Otherwise try to use padding
			if ( padding ) then
				width = textWidth + padding
			else
				width = textWidth + 24
			end
			-- If greater than the maxWidth then cap it
			if ( maxWidth and width > maxWidth ) then
				if ( padding ) then
					width = maxWidth + padding
				else
					width = maxWidth + 24
				end
				tabText:SetWidth(width)
			else
				tabText:SetWidth(0)
			end
			if (minWidth and width < minWidth) then
				width = minWidth
			end
			tabWidth = width + sideWidths
		end
		
		do
			local offsetX = self.Icon and 18 or 0
			local offsetY = self.ButtonState and -2 or -3
			self.Text:SetPoint("CENTER", self, "CENTER", offsetX, offsetY)
		end
		
		if ( buttonMiddle ) then
			buttonMiddle:SetWidth(width)
		end
		if ( buttonMiddleDisabled ) then
			buttonMiddleDisabled:SetWidth(width)
		end
		
		self:SetWidth(tabWidth)
		local highlightTexture = self.HighlightTexture
		if ( highlightTexture ) then
			highlightTexture:SetWidth(tabWidth)
		end
	end
	--PanelTemplates_TabResize
	local function TabFrame_SetTabIcon(self,icon)
		if not icon then
			self.Icon = nil
			if self.icon then
				self.icon:Hide()
			end
			self:Resize(0, nil, nil, self:GetFontString():GetStringWidth(), self:GetFontString():GetStringWidth())
			return
		end
		if not self.icon then
			self.icon = self:CreateTexture(nil,"BACKGROUND")
			self.icon:SetSize(16,16)
			self.icon:SetPoint("LEFT",12,-3)
		end
		self.Icon = icon
		self.icon:SetTexture(icon)
		self.icon:Show()
		self:Resize(0, nil, nil, self:GetFontString():GetStringWidth(), self:GetFontString():GetStringWidth())
	end
	local function TabFrameUpdateTabs(self)
		for i=1,self.tabCount do
			if i == self.selected then
				TabFrame_SelectTab(self.tabs[i].button)
			else
				TabFrame_DeselectTab(self.tabs[i].button)
			end
			self.tabs[i]:Hide()
			
			if self.tabs[i].disabled then
				PanelTemplates_SetDisabledTabState(self.tabs[i].button)
			end
		end
		if self.selected and self.tabs[self.selected] then
			self.tabs[self.selected]:Show()
		end
		if self.navigation then
			if self.disabled then
				self.navigation:SetEnabled(nil)
			else
				self.navigation:SetEnabled(true)
			end
		end
	end
	local function TabFrameButtonClick(self)
		local tabFrame = self.mainFrame
		tabFrame.selected = self.id
		tabFrame.UpdateTabs(tabFrame)
		
		if tabFrame.buttonAdditionalFunc then
			tabFrame:buttonAdditionalFunc()
		end
		if self.additionalFunc then
			self:additionalFunc()
		end
	end
	local function TabFrameSelectTab(self,ID)
		self.selected = ID
		self:UpdateTabs()
	end
	local function TabFrameButtonOnEnter(self)
		if self.tooltip and self.tooltip ~= "" then
			ELib.Tooltip.Show(self,nil,self:GetText(),{self.tooltip,1,1,1})
		end
	end
	local function TabFrameButtonOnLeave(self)
		GameTooltip_Hide()
	end
	local function TabFrameToggleNavigation(self)
		local parent = self.parent
		local dropDownList = {}
		for i=self.max + 1,#parent.tabs do
			dropDownList[#dropDownList+1] = {
				text = parent.tabs[i].button:GetText(),
				notCheckable = true,
				func = function ()
					TabFrameButtonClick(parent.tabs[i].button)
				end
			}
		end
		dropDownList[#dropDownList + 1] = {
			text = ExRT.L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = function() 
				CloseDropDownMenus() 
			end,
		}
		EasyMenu(dropDownList, self.dropDown, "cursor", 10 , -15, "MENU")
	end	
	
	local function Widget_SetSize(self,width,height)
		self:SetSize(width,height)
		for i=1,self.tabCount do
			self.tabs[i]:SetSize(width,height)
		end
		return self
	end
	local function Widget_SetTo(self,activeTabNum)
		TabFrameButtonClick(self.tabs[activeTabNum or 1].button)
		return self
	end
	
	function ELib:Tabs(parent,template,...)
		template = template == 0 and "ExRTTabButtonTransparentTemplate" or template or "ExRTTabButtonTemplate"
			
		local self = CreateFrame("Frame",nil,parent)
		self:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		self:SetBackdropColor(0,0,0,0.5)
		
		self.resizeFunc = TabFrame_ResizeTab
		self.selectFunc = TabFrame_SelectTab
		self.deselectFunc = TabFrame_DeselectTab
		
		self.tabs = {}
		local tabCount = select('#', ...)
		for i=1,tabCount do
			self.tabs[i] = CreateFrame("Frame",nil,self)
			self.tabs[i]:SetPoint("TOPLEFT", 0,0)
	
			self.tabs[i].button = ELib:Template(template, self) or CreateFrame("Button", nil, self, template)
			self.tabs[i].button:SetText(select(i, ...) or i)
			TabFrame_ResizeTab(self.tabs[i].button, 0, nil, nil, self.tabs[i].button:GetFontString():GetStringWidth(), self.tabs[i].button:GetFontString():GetStringWidth())
			
			self.tabs[i].button.id = i
			self.tabs[i].button.mainFrame = self
			self.tabs[i].button:SetScript("OnClick", TabFrameButtonClick)
			
			self.tabs[i].button:SetScript("OnEnter", TabFrameButtonOnEnter)
			self.tabs[i].button:SetScript("OnLeave", TabFrameButtonOnLeave)
	
			if i == 1 then
				self.tabs[i].button:SetPoint("TOPLEFT", 10, 24)
			else
				self.tabs[i].button:SetPoint("LEFT", self.tabs[i-1].button, "RIGHT", template ~= "ExRTTabButtonTemplate" and 0 or -16, 0)
				self.tabs[i]:Hide()
			end
			TabFrame_DeselectTab(self.tabs[i].button)
			
			self.tabs[i].button.Resize = TabFrame_ResizeTab
			self.tabs[i].button.SetIcon = TabFrame_SetTabIcon
			self.tabs[i].button.Select = TabFrame_SelectTab
			self.tabs[i].button.Deselect = TabFrame_DeselectTab
		end
		TabFrame_SelectTab(self.tabs[1].button)
	
		self.tabCount = tabCount
		self.selected = 1
		self.UpdateTabs = TabFrameUpdateTabs
		self.SelectTab = TabFrameSelectTab
		
		Mod(self,
			'SetTo',Widget_SetTo
		)
		self._Size = self.Size	self.Size = Widget_SetSize
	
		return self
	end
	function ELib.CreateTabFrameTemplate(parent,width,height,x,y,template,tabNum,activeTabNum,...)
		return ELib:Tabs(parent,template,...):Size(width,height):Point(x,y):SetTo(activeTabNum)
	end
	function ELib.CreateTabFrame(...)
		return ELib.CreateTabFrameTemplate(...)
	end
end

do
	local function Widget_SetFont(self,...)
		self:SetFont(...)
		return self
	end
	local function Widget_Color(self,colR,colG,colB)
		self:SetTextColor(colR or 1,colG or 1,colB or 1,1)
		return self
	end
	local function Widget_Left(self) self:SetJustifyH("LEFT") return self end
	local function Widget_Center(self) self:SetJustifyH("CENTER") return self end
	local function Widget_Right(self) self:SetJustifyH("RIGHT") return self end
	local function Widget_Top(self) self:SetJustifyV("TOP") return self end
	local function Widget_Middle(self) self:SetJustifyV("MIDDLE") return self end
	local function Widget_Bottom(self) self:SetJustifyV("BOTTOM") return self end
	local function Widget_Shadow(self,disable)
		self:SetShadowColor(0,0,0,disable and 0 or 1)
		self:SetShadowOffset(1,-1)
		return self
	end
	local function Widget_Outline(self,disable)
		local filename,fontSize = self:GetFont()
		self:SetFont(filename,fontSize,(not disable) and "OUTLINE")
		return self
	end
	local function Widget_FontSize(self,size)
		local filename,fontSize,fontParam1,fontParam2,fontParam3 = self:GetFont()
		self:SetFont(filename,size,fontParam1,fontParam2,fontParam3)
		return self
	end
	
	local function OnTooltipEnter(self)
		local text = self.t
		if not text:IsTruncated() and not text.alwaysTooltip then
			return
		end
		ELib.Tooltip.Show(self,self.a,text:GetText())
	end
	local function OnTooltipLeave(self)
		ELib.Tooltip.Hide()
	end
	local function Widget_Tooltip(self,anchor,isButton)
		local f = CreateFrame(isButton and "Button" or "Frame",nil,self:GetParent())
		f:SetAllPoints(self)
		f.t = self
		f.a = anchor
		f:SetScript("OnEnter",OnTooltipEnter)
		f:SetScript("OnLeave",OnTooltipLeave)
		self.TooltipFrame = f
		return self
	end
	
	function ELib:Text(parent,text,size,template)
		if template == 0 then 
			template = nil 
		elseif not template then
			template = "ExRTFontNormal"
		end
		local self = parent:CreateFontString(nil,"ARTWORK",template)
		if template and size then
			local filename = self:GetFont()
			if filename then
				self:SetFont(filename,size)
			end
		end
		self:SetJustifyH("LEFT")
		self:SetJustifyV("MIDDLE")
		if template then
			self:SetText(text or "")
		end
		
		Mod(self,
			'Font',Widget_SetFont,
			'Color',Widget_Color,
			'Left',Widget_Left,
			'Center',Widget_Center,
			'Right',Widget_Right,
			'Top',Widget_Top,
			'Middle',Widget_Middle,
			'Bottom',Widget_Bottom,
			'Shadow',Widget_Shadow,
			'Outline',Widget_Outline,
			'FontSize',Widget_FontSize,
			'Tooltip',Widget_Tooltip
		)
		
		return self
	end
	
	function ELib.CreateText(parent,width,height,relativePoint,x,y,hor,ver,font,fontSize,text,tem,colR,colG,colB,shadow,outline,doNotUseTemplate)
		if doNotUseTemplate then tem = 0 end
		local self = ELib:Text(parent,text,fontSize,tem):Size(width,height):Point(relativePoint or "TOPLEFT", x,y)
		if hor then self:SetJustifyH(hor) end
		if ver then self:SetJustifyV(ver) end
		if font then self:Font(font,fontSize) end
		if shadow then self:Shadow() end
		if outline then self:Outline() end
		if colR then self:Color(colR,colG,colB) end
		return self
	end
end

do
	local function EditBoxEscapePressed(self)
		self:ClearFocus()
	end
	local function Widget_SetText(self,text)
		self:SetText(text or "")
		self:SetCursorPosition(0)
		return self
	end
	local function Widget_Tooltip(self,text)
		self:SetScript("OnEnter",ELib.Tooltip.Std)
		self:SetScript("OnLeave",ELib.Tooltip.Hide)
		self.tooltipText = text
		return self
	end
	local function Widget_OnChange(self,func)
		self:SetScript("OnTextChanged",func)
		return self
	end
	local function Widget_AddSearchIcon(self,size)
		self.searchTexture = self:CreateTexture(nil, "BACKGROUND",nil,2)
		self.searchTexture:SetPoint("RIGHT",-2,0)
		self.searchTexture:SetTexture([[Interface\Common\UI-Searchbox-Icon]])
		self.searchTexture:SetSize(size or 14,size or 14)	
		return self
	end
	local function Widget_AddLeftText(self,text,size)
		self.leftText = ELib:Text(self,text,size or 11):Point("RIGHT",self,"LEFT",-5,0)
		return self
	end
	local function Widget_AddLeftTop(self,text,size)
		self.leftText = ELib:Text(self,text,size or 11):Point("BOTTOM",self,"TOP",0,2)
		return self
	end
	
	function ELib:Edit(parent,maxLetters,onlyNum,template)
		if template == 0 then
			template = "ExRTInputBoxTemplate"
		elseif template == 1 then
			template = nil
		elseif not template then
			template = "ExRTInputBoxModernTemplate"
		end
		local self = ELib:Template(template,parent) or CreateFrame("EditBox",nil,parent,template)
		if not template then
			local GameFontNormal_Font = GameFontNormal:GetFont()
			self:SetFont(GameFontNormal_Font,12)
			self:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8",edgeFile = DEFAULT_BORDER,edgeSize = 8,tileSize = 0,insets = {left = 2.5,right = 2.5,top = 2.5,bottom = 2.5}})
			self:SetBackdropColor(0, 0, 0, 0.8) 
			self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			self:SetTextInsets(10,10,0,0)
		end
		self:SetAutoFocus( false )
		if maxLetters then
			self:SetMaxLetters(maxLetters)
		end
		if onlyNum then
			self:SetNumeric(true)
		end
		self:SetScript("OnEscapePressed",EditBoxEscapePressed)
		
		Mod(self,
			'Text',Widget_SetText,
			'Tooltip',Widget_Tooltip,
			'OnChange',Widget_OnChange,
			'AddSearchIcon',Widget_AddSearchIcon,
			'LeftText',Widget_AddLeftText,
			'TopText',Widget_AddLeftTop
		)

		return self
	end
	function ELib.CreateEditBox(parent,width,height,relativePoint,x,y,tooltip,maxLetters,onlyNum,doNotUseTemplate,defText)
		local self = ELib:Edit(parent,maxLetters,onlyNum,doNotUseTemplate == true and 1 or type(doNotUseTemplate) == "string" and doNotUseTemplate):Size(width,height):Point(relativePoint or "TOPLEFT",x,y)
		if defText then self:Text(defText) end
		if tooltip then self:Tooltip(tooltip) end
		return self
	end
end

do
	local function Widget_SetSize(self,width,height)
		self:SetSize(width,height)
		self.content:SetWidth(width-16-(self.isModern and 4 or 0))
		--self.ScrollBar:Size(16,height)
		
		if self.isModern and height < 65 then
			self.ScrollBar.IsThumbSmalled = true
			self.ScrollBar.thumb:SetHeight(5)
		elseif self.ScrollBar.IsThumbSmalled then
			self.ScrollBar.IsThumbSmalled = nil
			self.ScrollBar.thumb:SetHeight(30)
		end
		
		return self
	end
	local function ScrollFrameMouseWheel(self,delta)
		delta = delta * (self.mouseWheelRange or 20)
		local min,max = self.ScrollBar.slider:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end
	local function ScrollFrameScrollBarValueChanged(self,value)
		local parent = self:GetParent():GetParent()
		parent:SetVerticalScroll(value) 
		self:UpdateButtons()
	end
	local function ScrollFrameChangeHeight(self,newHeight)
		self.content:SetHeight(newHeight)
		self.ScrollBar:Range(0,max(newHeight-self:GetHeight(),0),nil,true)
		self.ScrollBar:UpdateButtons()
		
		return self
	end
	local ScrollFrameBackdrop = {bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "",tile = true, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }}
	local ScrollFrameBackdropBorder = {bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollFrameBackdropBorderModern = {edgeFile = "Interface/AddOns/"..GlobalAddonName.."/media/border", edgeSize = 16}
	
	function ELib:ScrollFrame(parent,isOld)
		local self = CreateFrame("ScrollFrame", nil, parent)
		
		if not isOld then
			ELib:Border(self,2,.24,.25,.30,1)
		else
			self.backdrop = CreateFrame("Frame", nil, self)
			self.backdrop:SetPoint("TOPLEFT",self,-5,5)
			self.backdrop:SetPoint("BOTTOMRIGHT",self,5,-5)
			self.backdrop:SetBackdrop(ScrollFrameBackdropBorder)
			self.backdrop:SetBackdropColor(0,0,0,0)
		end
		
		self.content = CreateFrame("Frame", nil, self) 
		self:SetScrollChild(self.content)
		
		self.isModern = not isOld
		
		self.C = self.content
		
		if not isOld then
			self.ScrollBar = ELib:ScrollBar(self):Size(16,0):Point("TOPRIGHT",-3,-3):Point("BOTTOMRIGHT",-3,3):Range(0,1):SetTo(0):ClickRange(20)
		else
			self.ScrollBar = ELib.CreateScrollBar(self,16,100,0,0,0,1,"TOPRIGHT")
		end
		self.ScrollBar.slider:SetScript("OnValueChanged", ScrollFrameScrollBarValueChanged)
		self.ScrollBar:UpdateButtons()
		
		self:SetScript("OnMouseWheel", ScrollFrameMouseWheel)
		
		self.SetNewHeight = ScrollFrameChangeHeight
		self.Height = ScrollFrameChangeHeight
		
		Mod(self)
		self._Size = self.Size
		self.Size = Widget_SetSize
		
		return self
	end
	function ELib.CreateScrollFrame(parent,width,height,relativePoint,x,y,verticalHeight,isModern)
		return ELib:ScrollFrame(parent,not isModern):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Height(verticalHeight)
	end
end

do
	local SliderBackdropTable = {bgFile = "Interface\\Buttons\\WHITE8X8",edgeFile = DEFAULT_BORDER,edgeSize = 8,tileSize = 0,insets = {left = 2.5,right = 2.5,top = 2.5,bottom = 2.5}}
	local function SliderButtonClick(self)
		local parent = self.parent
		parent.selected = parent.selected + self.diff
		local list = parent.List
		if parent.selected > #list then
			parent.selected = 1
		end
		if parent.selected < 1 then
			parent.selected = #list
		end
		parent:SetTo(parent.selected)
		
		if parent.func then
			parent.func(parent)
		end
	end
	local function SliderBoxCreateButton(parent,text,diff)
		local self = CreateFrame("Button",nil,parent)
		self:SetBackdrop(SliderBackdropTable)
		self:SetBackdropColor(0, 0, 0, 0.8) 
		self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
		self.text = self:CreateFontString(nil,"ARTWORK","GameFontNormal")
		self.text:SetAllPoints()
		self.text:SetJustifyH("CENTER")
		self.text:SetJustifyV("MIDDLE")
		self.text:SetTextColor(1,1,1,1)
		self.text:SetText(text)
		self:SetScript("OnClick",SliderButtonClick)
		self.diff = diff
		self.parent = parent
		
		return self
	end
	local function Widget_SetSize(self,width,height)
		self:SetSize(width,height)
		self.left:SetSize(height,height)
		self.right:SetSize(height,height)
		
		return self
	end
	local function Widget_SetTo(self,selected)
		self.selected = selected
		if type(self.List[selected]) == "table" then
			self.text:SetText(self.List[selected][1] or "")
			self.tooltipText = self.List[selected][2]
		else
			self.text:SetText(self.List[selected] or "")
			self.tooltipText = nil
		end

		return self
	end
	function ELib:SliderBox(parent,list)
		local self = CreateFrame("Frame",nil,parent)
		self.middle = CreateFrame("Frame",nil,self)
		self.middle:SetBackdrop(SliderBackdropTable)
		self.middle:SetBackdropColor(0, 0, 0, 0.8) 
		self.middle:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
		self.middle:SetScript("OnEnter",ELib.Tooltip.Std)
		self.middle:SetScript("OnLeave",ELib.Tooltip.Hide)
	
		list = list or {}
		self.selected = 1
		self.List = list
	
		self.text = ELib:Text(self.middle,nil,nil,"GameFontNormal"):Point('x'):Center():Color()
	
		self.left = SliderBoxCreateButton(self,"<",-1)
		self.left:SetPoint("LEFT",0,0)
		
		self.right = SliderBoxCreateButton(self,">",1)
		self.right:SetPoint("RIGHT",0,0)
		
		self.middle:SetPoint("TOPLEFT",self.left,"TOPRIGHT",0,0)
		self.middle:SetPoint("BOTTOMRIGHT",self.right,"BOTTOMLEFT",0,0)
		
		Mod(self)
		self.Size = Widget_SetSize
		self.SetTo = Widget_SetTo
			
		return self
	end
	function ELib.CreateSliderBox(parent,width,height,x,y,list,selected)
		return ELib:SliderBox(parent,list):Point(x,y):Size(width,height):SetTo(selected)
	end
end

do
	local function ButtonOnEnter(self)
		ELib.Tooltip.Show(self,"ANCHOR_TOP",self.tooltip,{type(self.tooltipText) == 'function' and self.tooltipText(self) or self.tooltipText,1,1,1,true}) 
	end
	local function Widget_Tooltip(self,text)
		self.tooltip = self:GetText()
		if self.tooltip == "" or not self.tooltip then self.tooltip = " " end
		self.tooltipText = text
		self:SetScript("OnEnter",ButtonOnEnter)
		self:SetScript("OnLeave",ELib.Tooltip.Hide)
		return self
	end
	local function Widget_Disable(self)
		self:_Disable()
		return self
	end
	local function Widget_GetTextObj(self)
		for i=1,self:GetNumRegions() do
			local obj = select(i,self:GetRegions())
			if obj.GetText and obj:GetText() == self:GetText() then
				return obj
			end
		end
	end
	local function Widget_SetFontSize(self,size)
		local obj = self:GetFontString()
		obj:SetFont(obj:GetFont(),size)

		return self
	end


		
	function ELib:Button(parent,text,template)
		if template == 0 then
			template = "UIPanelButtonTemplate"
		elseif template == 1 then
			template = nil
		elseif not template then
			template = "ExRTButtonModernTemplate"
		end
		local self = ELib:Template(template,parent) or CreateFrame("Button",nil,parent,template)
		self:SetText(text)
		
		Mod(self,
			'Tooltip',Widget_Tooltip
		)
		self._Disable = self.Disable	self.Disable = Widget_Disable
		self.GetTextObj = Widget_GetTextObj
		self.FontSize = Widget_SetFontSize
		
		return self
	end
	function ELib.CreateButton(parent,width,height,relativePoint,x,y,text,isDisabled,tooltip,template)
		local self = ELib:Button(parent,text,template or 0):Size(width,height):Point(relativePoint or "TOPLEFT",x,y) 
		if tooltip then self:Tooltip(tooltip) end
		if isDisabled then self:Disable() end
		return self
	end
end

do
	local function Widget_Icon(self,texture,cG,cB,cA)
		if cG then
			self.texture:SetColorTexture(texture,cG,cB,cA)
		else
			self.texture:SetTexture(texture)
		end
		return self
	end
	function ELib:Icon(parent,textureIcon,size,isButton)
		local self = CreateFrame(isButton and "Button" or "Frame",nil,parent)
		self:SetSize(size,size)
		self.texture = self:CreateTexture(nil, "BACKGROUND")
		self.texture:SetAllPoints()
		self.texture:SetTexture(textureIcon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
		if isButton then
	 		self:EnableMouse(true)
			self:RegisterForClicks("LeftButtonDown")
		end
		
		Mod(self,
			'Icon',Widget_Icon
		)
		
		return self
	end
	function ELib.CreateIcon(parent,size,relativePoint,x,y,textureIcon,isButton)
		return ELib:Icon(parent,textureIcon,size,isButton):Point(relativePoint or "TOPLEFT", x,y)
	end	
end

do
	local function CheckBoxOnEnter(self)
		local tooltipTitle = self.text:GetText()
		local tooltipText = self.tooltipText
		if tooltipTitle == "" or not tooltipTitle then
			tooltipTitle = tooltipText
			tooltipText = nil
		end
		ELib.Tooltip.Show(self,"ANCHOR_TOP",tooltipTitle,{tooltipText,1,1,1,true})
	end
	local function Widget_Tooltip(self,text)
		self.tooltipText = text
		return self
	end
	local function Widget_Left(self,relativeX)
		self.text:ClearAllPoints()
		self.text:SetPoint("RIGHT",self,"LEFT",relativeX and relativeX*(-1) or -2,0)
		return self
	end
	local function Widget_TextSize(self,size)
		self.text:SetFont(self.text:GetFont(),size)
		return self
	end
			
	function ELib:Check(parent,text,state,template)
		if template == 0 then
			template = "UICheckButtonTemplate"
		elseif not template then
			template = "ExRTCheckButtonModernTemplate"
		end
		local self = ELib:Template(template,parent) or CreateFrame("CheckButton",nil,parent,template)  
		self.text:SetText(text or "")
		self:SetChecked(state and true or false)
		self:SetScript("OnEnter",CheckBoxOnEnter)
		self:SetScript("OnLeave",ELib.Tooltip.Hide)
		self.defSetSize = self.SetSize
		
		Mod(self)
		self.Tooltip = Widget_Tooltip
		self.Left = Widget_Left
		self.TextSize = Widget_TextSize
		
		return self
	end
	function ELib.CreateCheckBox(parent,relativePoint,x,y,text,checked,tooltip,textLeft,template)
		local self = ELib:Check(parent,text,checked,template or 0):Point(relativePoint or "TOPLEFT",x,y):Tooltip(tooltip)
		if textLeft then self:Left() end
		return self
	end	
end

do
	local function Click(self)
		self:GetParent():Click()
	end
	local function ButtonOnEnter(self)
		self.colorSave = {self:GetParent().text:GetTextColor()}
		self:GetParent().text:SetTextColor(1,1,1)
	end
	local function ButtonOnLeave(self)
		self:GetParent().text:SetTextColor(unpack(self.colorSave))
	end
	local function Widget_TextToButton(self)
		self.Button = CreateFrame("Button",nil,self)
		self.Button:SetAllPoints(self.text)
		self.Button:SetScript("OnClick",Click)
		self.Button:SetScript("OnEnter",ButtonOnEnter)
		self.Button:SetScript("OnLeave",ButtonOnLeave)
		return self
	end
	function ELib:Radio(parent,text,checked,template)
		if template == 0 then
			template = "UIRadioButtonTemplate"
		elseif not template then
			template = "ExRTRadioButtonModernTemplate"
		end
		
		local self = ELib:Template(template,parent) or CreateFrame("CheckButton",nil,parent,template)  
		self.text:SetText(text or "")
		self:SetChecked(checked and true or false)
		
		Mod(self)
		self.AddButton = Widget_TextToButton
		
		return self
	end
	function ELib.CreateRadioButton(parent,relativePoint,x,y,text,checked,isModern)
		return ELib:Radio(parent,text,checked,isModern and "ExRTRadioButtonModernTemplate" or "UIRadioButtonTemplate"):Point(relativePoint or "TOPLEFT",x,y)
	end
end

function ELib.CreateHoverHighlight(parent,prefix,drawLayer)
	prefix = prefix or "hl"
	parent[prefix] = parent:CreateTexture(nil, "BACKGROUND")
	parent[prefix]:SetPoint("TOPLEFT", 0, 0)
	parent[prefix]:SetPoint("BOTTOMRIGHT", 0, 0)
	parent[prefix]:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	parent[prefix]:SetBlendMode("ADD")
	parent[prefix]:Hide()
	if drawLayer then
		parent[prefix]:SetDrawLayer("BACKGROUND", drawLayer)
	end
end

do
	function ELib:DebugBack(parent)
		local frame = parent.CreateTexture and parent or parent:GetParent()
		local self = frame:CreateTexture(nil, "OVERLAY")
		self:SetAllPoints(parent)
		self:SetColorTexture(1, 0, 0, 0.3)
		
		return self
	end
	function ELib.CreateBackTextureForDebug(parent)
		return ELib:DebugBack(parent)
	end
end

do
	local HELPstratas = {}
	local HELPlevels = {}
	local HelpPlateTooltipStrata = nil
	local HelpPlateTooltipLevel = nil
	local function HideFunc(self,isUser)
		HelpPlate_Hide(isUser)
		self:SetFrameStrata(self.strata)
		self:SetFrameLevel(self.level)
		
		if self.shitInterface then
			for i=1,#HELP_PLATE_BUTTONS do
				if HELPstratas[i] then
					HELP_PLATE_BUTTONS[i]:SetFrameStrata(HELPstratas[i])
					HELP_PLATE_BUTTONS[i]:SetFrameLevel(HELPlevels[i])
				end
			end
			if HelpPlateTooltipStrata then
				HelpPlateTooltip:SetFrameStrata(HelpPlateTooltipStrata)
				HelpPlateTooltip:SetFrameLevel(HelpPlateTooltipLevel)
			end
			self:SetFrameStrata( self.shitStrata )
			self:SetFrameLevel( 119 )
		end
	end
	local function HelpButtonOnClick(self)
		local helpPlate = nil
		if self.isTab then
			helpPlate = self.helpPlateArray[self.isTab.selected]
		else
			helpPlate = self.helpPlateArray
		end
		if helpPlate and not HelpPlate_IsShowing(helpPlate) then
			HelpPlate_Show(helpPlate, self.parent, self, true)
			self:SetFrameStrata( HelpPlate:GetFrameStrata() )
			self:SetFrameLevel( HelpPlate:GetFrameLevel() + 1 )
			
			if self.shitInterface then
				for i=1,#HELP_PLATE_BUTTONS do
					HELPstratas[i] = HELP_PLATE_BUTTONS[i]:GetFrameStrata()
					HELPlevels[i] = HELP_PLATE_BUTTONS[i]:GetFrameLevel()
					HELP_PLATE_BUTTONS[i]:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i].box:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i].boxHighlight:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i]:SetFrameLevel(120)
					HELP_PLATE_BUTTONS[i].box:SetFrameLevel(120)
					HELP_PLATE_BUTTONS[i].boxHighlight:SetFrameLevel(120)
				end
				HelpPlateTooltipStrata = HelpPlateTooltip:GetFrameStrata()
				HelpPlateTooltipLevel = HelpPlateTooltip:GetFrameLevel()
				HelpPlateTooltip:SetFrameStrata(self.shitStrata)
				HelpPlateTooltip:SetFrameLevel(122)
				self:SetFrameStrata( self.shitStrata )
				self:SetFrameLevel( 121 )
			end
		else
			HideFunc(self,true)
		end
		if self.Click2 then
			self:Click2()
		end

	end
	local function HelpButtonOnHide(self)
		HideFunc(self,false)
	end
	function ELib.CreateHelpButton(parent,helpPlateArray,isTab)
		local self = CreateFrame("Button",nil,parent,"MainHelpPlateButton")	-- После использования кнопки не дает юзать спелл дизенчант. лень искать решение, не юзайте кнопку часто [5.4]
		self:SetPoint("CENTER",parent,"TOPLEFT",0,0) 
		self:SetScale(0.8)
		local interfaceStrata = InterfaceOptionsFrame:GetFrameStrata()
		interfaceStrata = "FULLSCREEN_DIALOG"
		self:SetFrameStrata(interfaceStrata)
		if interfaceStrata == "FULLSCREEN" or interfaceStrata == "FULLSCREEN_DIALOG" or interfaceStrata == "TOOLTIP" then
			self.shitInterface = true
			self.shitStrata = interfaceStrata
		end
		
		self.helpPlateArray = helpPlateArray
		self.isTab = isTab
		self.parent = parent
		
		self:SetScript("OnClick",HelpButtonOnClick)
		self:SetScript("OnHide",HelpButtonOnHide)
		self.strata = self:GetFrameStrata()
		self.level = self:GetFrameLevel()
		
		return self
	end
end

do
	local function ScrollListListEnter(self)
		local mainFrame = self.mainFrame
		if mainFrame.HoverListValue then
			mainFrame:HoverListValue(true,self.index,self)
			mainFrame.HoveredLine = self
		end
	end
	local function ScrollListListLeave(self)
		local mainFrame = self.mainFrame
		if mainFrame.HoverListValue then
			mainFrame:HoverListValue(false,self.index,self)
		end
		mainFrame.HoveredLine = nil
	end
	local function ScrollListMouseWheel(self,delta)
		-- This function isnt called, cuz wheel cause scrollframe wheel event
		if delta > 0 then
			self.Frame.ScrollBar.buttonUP:Click("LeftButton")
		else
			self.Frame.ScrollBar.buttonDown:Click("LeftButton")
		end
	end
	local function ScrollListListMultitableEnter(self)
		local mainFrame = self:GetParent().mainFrame
		if mainFrame.HoverMultitableListValue then
			mainFrame:HoverMultitableListValue(true,self.index,self)
		end		
	end
	local function ScrollListListMultitableLeave(self)
		local mainFrame = self:GetParent().mainFrame
		if mainFrame.HoverMultitableListValue then
			mainFrame:HoverMultitableListValue(false,self.index,self)
		end
	end
	local function ScrollListListMultitableClick(self)
		local mainFrame = self:GetParent().mainFrame
		if mainFrame.ClickMultitableListValue then
			mainFrame:ClickMultitableListValue(self.index,self)
		end		
	end	
	
	local ScrollListBackdrop = {bgFile = "", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollListBackdropModern = {edgeFile = "Interface/AddOns/"..GlobalAddonName.."/media/border", edgeSize = 16}
	
	local function ScrollList_Line_Click(self,button,...)
		local parent = self.mainFrame
		if not parent.isCheckList then
			parent.selected = self.index
		else
			if button ~= "RightButton" then
				parent.C[self.index] = not parent.C[self.index]
			end
		end
		parent:Update()
		if parent.SetListValue then
			parent:SetListValue(self.index,button,...)
		end
		if parent.isCheckList and parent.ValueChanged then
			parent:ValueChanged()
		end
		if parent.AdditionalLineClick then
			parent.AdditionalLineClick(self,button,...)
		end
	end
	local function ScrollList_Check_Click(self,...)
		local listParent = self:GetParent()
		local parent = listParent.mainFrame
		if self:GetChecked() then
			parent.C[listParent.index] = true
		else
			parent.C[listParent.index] = nil
		end
		parent:Update()
		if parent.SetListValue then
			parent:SetListValue(self.index,...)
		end
		if parent.isCheckList and parent.ValueChanged then
			parent:ValueChanged()
		end
	end
	local function ScrollList_AddLine(self,i)
		local line = CreateFrame("Button",nil,self.Frame.C)
		self.List[i] = line
		line:SetPoint("TOPLEFT",0,-(i-1)*16)
		line:SetPoint("BOTTOMRIGHT",self.Frame.C,"TOPRIGHT",0,-i*16)
		
		if not self.T then
			line.text = ELib:Text(line,"List"..tostring(i),self.fontSize or 12):Point("TOPLEFT",self.isCheckList and 24 or 3,0):Point("TOPRIGHT",-3,0):Size(0,16):Color():Shadow()
			if self.fontName then
				line.text:Font(self.fontName,self.fontSize or 12)
			end
			line:SetFontString(line.text)
			line:SetPushedTextOffset(2, -1)
		else
			local zeroWidth = nil
			for j=1,#self.T do
				local width = self.T[j]
				local textObj = ELib:Text(line,"List",self.fontSize or 12):Size(width,16):Color():Shadow():Left()
				if self.fontName then
					textObj:Font(self.fontName,self.fontSize or 12)
				end
				line['text'..j] = textObj
				if width == 0 then
					zeroWidth = j
				end
				
				if self.additionalLineFunctions then
					local hoverFrame = CreateFrame('Button',nil,line)
					hoverFrame:SetScript("OnEnter",ScrollListListMultitableEnter)
					hoverFrame:SetScript("OnLeave",ScrollListListMultitableLeave)
					hoverFrame:SetScript("OnClick",ScrollListListMultitableClick)
					hoverFrame:SetAllPoints(textObj)
					hoverFrame.index = j
					hoverFrame.parent = textObj
					--hoverFrame:EnableMouse(false)
				end
			end
			for j=1,#self.T do
				local text = line['text'..j]
				if j == 1 then
					text:Point("LEFT",3,0)
				elseif j < zeroWidth then
					text:Point("LEFT",line['text'..(j-1)],"RIGHT",0,0)
				elseif j == #self.T and j == zeroWidth then
					text:Point("LEFT",line['text'..(j-1)],"RIGHT",0,0):Point("RIGHT",-3,0)
				elseif j == #self.T then
					text:Point("RIGHT",-3,0)
				elseif j == zeroWidth then
					text:Point("LEFT",line['text'..(j-1)],"RIGHT",0,0):Point("RIGHT",line['text'..(j+1)],"LEFT",0,0)
				else
					text:Point("RIGHT",line['text'..(j+1)],"LEFT",0,0)
				end
			end
		end
		
		line.background = line:CreateTexture(nil, "BACKGROUND")
		line.background:SetPoint("TOPLEFT")
		line.background:SetPoint("BOTTOMRIGHT")
		
		line.HighlightTexture = line:CreateTexture()
		line.HighlightTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
		line.HighlightTexture:SetBlendMode("ADD")
		line.HighlightTexture:SetPoint("LEFT",0,0)
		line.HighlightTexture:SetPoint("RIGHT",0,0)
		line.HighlightTexture:SetHeight(15)
		line.HighlightTexture:SetVertexColor(1,1,1,1)		
		line:SetHighlightTexture(line.HighlightTexture)
		
		line.PushedTexture = line:CreateTexture()
		line.PushedTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
		line.PushedTexture:SetBlendMode("ADD")
		line.PushedTexture:SetPoint("LEFT",0,0)
		line.PushedTexture:SetPoint("RIGHT",0,0)
		line.PushedTexture:SetHeight(15)
		line.PushedTexture:SetVertexColor(1,1,0,1)
		line:SetDisabledTexture(line.PushedTexture)
		
		line.iconRight = line:CreateTexture()
		line.iconRight:SetPoint("RIGHT",-3,0)
		line.iconRight:SetSize(16,16)
		
		if self.isCheckList then
			line.chk = ELib:Template("ExRTCheckButtonModernTemplate",line)  
			line.chk:SetSize(14,14)
			line.chk:SetPoint("LEFT",4,0)
			line.chk:SetScript("OnClick", ScrollList_Check_Click)
		end
		
		line.mainFrame = self
		line.id = i
		line:SetScript("OnClick",ScrollList_Line_Click)
		line:SetScript("OnEnter",ScrollListListEnter)
		line:SetScript("OnLeave",ScrollListListLeave)
		line:RegisterForClicks("LeftButtonUp","RightButtonUp")
		
		return line
	end
	local function ScrollList_ScrollBar_OnValueChanged(self,value)
		local parent = self:GetParent():GetParent()
		parent:SetVerticalScroll(value % 16) 
		self:UpdateButtons()
		
		parent:GetParent():Update()
	end
	local function Widget_Update(self)
		local val = floor(self.Frame.ScrollBar:GetValue() / 16) + 1
		local j = 0
		for i=val,#self.L do
			j = j + 1
			local line = self.List[j]
			if not line then 
				line = ScrollList_AddLine(self,j)
			end
			if not self.T then
				line:SetText(self.L[i])
			else
				for k=1,#self.T do
					line['text'..k]:SetText(self.L[i][k] or "")
				end
			end
			if self.isCheckList then
				line.chk:SetChecked(self.C[i])
			elseif not self.T then
				if not self.dontDisable then
					if i ~= self.selected then
						line:SetEnabled(true)
					else
						line:SetEnabled(nil)
					end
				end
			end
			if self.IconsRight then
				local icon = self.IconsRight[j]
				if type(icon)=='table' then
					line.iconRight:SetTexture(icon[1])
					line.iconRight:SetSize(icon[2],icon[2])
				elseif icon then
					line.iconRight:SetTexture(icon)
					line.iconRight:SetSize(16,16)
				else
					line.iconRight:SetTexture("")
				end			
			end
			if self.colors then
				if self.colors[i] then
					line.background:SetColorTexture(unpack(self.colors[i]))
				else
					line.background:SetColorTexture(0,0,0,0)
				end
			end
			line:Show()
			line.index = i
			line.table = self.L[i]
			if (j >= #self.L) or (j >= self.linesPerPage) then
				break
			end
		end
		for i=(j+1),#self.List do
			self.List[i]:Hide()
		end
		self.Frame.ScrollBar:Range(0,max(0,#self.L * 16 - 1 - self:GetHeight()),16,true):UpdateButtons()
		
		if (self:GetHeight() / 16 - #self.L) > 0 then
			self.Frame.ScrollBar:Hide()
			self.Frame.C:SetWidth( self.Frame:GetWidth() )
		else
			self.Frame.ScrollBar:Show()
			self.Frame.C:SetWidth( self.Frame:GetWidth() - 16 )
		end
		
		if self.UpdateAdditional then
			self.UpdateAdditional(self,val)
		end
		
		if self.HoveredLine then
			local hovered = self.HoveredLine
			ScrollListListLeave(hovered)
			ScrollListListEnter(hovered)
		end
		
		return self
	end
	local function Widget_SetSize(self,width,height)
		self:_Size(width,height)
		self.Frame:Size(width,height):Height(height+16)
		self.linesPerPage = height / 16 + 1
		
		self.Frame.ScrollBar:Range(0,max(0,#self.L * 16 - 1 - height)):UpdateButtons()
		self:Update()
		
		return self
	end
	local function Widget_FontSize(self,size)
		self.fontSize = size
		if not self.T then
			for i=1,#self.List do
				self.List[i].text:SetFont(self.List[i].text:GetFont(),size)
			end
		else
			for i=1,#self.List do
				for j=1,#self.T do
					self.List[i]['text'..j]:SetFont(self.List[i]['text'..j]:GetFont(),size)
				end
			end
		end
		return self
	end
	local function Widget_Font(self,fontName,fontSize)
		self.fontSize = fontSize
		self.fontName = fontName
		if not self.T then
			for i=1,#self.List do
				self.List[i].text:SetFont(fontName,size)
			end
		else
			for i=1,#self.List do
				for j=1,#self.T do
					self.List[i]['text'..j]:SetFont(fontName,size)
				end
			end
		end
		return self
	end
	local function CreateScrollList(parent,list)
		local self = CreateFrame("Frame",nil,parent)
		self.Frame = ELib:ScrollFrame(self):Point(0,0)
		
		ELib:Border(self,2,.24,.25,.30,1)
		ELib:Border(self,1,0,0,0,1,2,1)

		self.linesPerPage = 1
		self.List = {}
		self.L = list or {}
		
		Mod(self,
			'Update',Widget_Update,
			'FontSize',Widget_FontSize,
			'Font',Widget_Font
		)
		self._Size = self.Size	self.Size = Widget_SetSize
		
		self.Frame.ScrollBar:SetScript("OnValueChanged",ScrollList_ScrollBar_OnValueChanged)
		self:SetScript("OnShow",self.Update)
		self:SetScript("OnMouseWheel",ScrollListMouseWheel)

		return self
	end
	function ELib:ScrollList(parent,list)
		local self = CreateScrollList(parent,list)
		self:Update()
		
		return self
	end
	function ELib:ScrollTableList(parent,...)
		local self = CreateScrollList(parent)
		self.T = {}
		for i=1,select("#",...) do
			self.T[i] = select(i,...)
		end
		self:Update()
		
		return self
	end
	function ELib:ScrollCheckList(parent,list)
		local self = CreateScrollList(parent,list)
		self.C = {}
		self.isCheckList = true
		
		self:Update()
		
		return self
	end

	function ELib.CreateScrollList(parent,relativePoint,x,y,width,linesNum,isModern)
		return ELib:ScrollList(parent,nil,not isModern):Point(relativePoint or "TOPLEFT",x + 5,y - 5):Size(width-10,linesNum * 16 - 2)
	end
	function ELib.CreateScrollCheckList(parent,relativePoint,x,y,width,linesNum,isModern)
		return ELib:ScrollCheckList(parent,nil,not isModern):Point(relativePoint or "TOPLEFT",x,y):Size(width,linesNum * 16 + 8)
	end
end

do
	local function PopupFrameShow(self,anchor,notResetPosIfShown)
		if self:IsShown() and notResetPosIfShown then
			return
		end
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		self:ClearAllPoints()
		self:SetPoint(anchor or self.anchor or "BOTTOMLEFT",UIParent,"BOTTOMLEFT",x,y)
		self:Show()
	end
	local function PopupFrameOnShow(self)
		local interfaceStrata = InterfaceOptionsFrame:GetFrameStrata()
		if interfaceStrata == "FULLSCREEN" or interfaceStrata == "FULLSCREEN_DIALOG" or interfaceStrata == "TOOLTIP" then
			self:SetFrameStrata(interfaceStrata)
		end
		self:SetFrameLevel(120)
		if self.OnShow then
			self:OnShow()
		end
	end
	function ELib:Popup(title,template)
		if template == 0 then
			template = "ExRTDialogTemplate"
		elseif not template then
			template = "ExRTDialogModernTemplate"
		end
		local self = ELib:Template(template,UIParent) or CreateFrame("Frame",nil,UIParent,template)
		self:SetPoint("CENTER")
		self:SetFrameStrata("DIALOG")
		self:SetClampedToScreen(true)
		self:EnableMouse(true)
		self:SetMovable(true)
		self:RegisterForDrag("LeftButton")
		self:SetDontSavePosition(true)
		self:SetScript("OnDragStart", function(self) 
			self:StartMoving() 
		end)
		self:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing() 
		end)
		self:Hide()
		self:SetScript("OnShow", PopupFrameOnShow)
		
		self.ShowClick = PopupFrameShow
		if template == "ExRTDialogModernTemplate" then
			self.border = ELib:Shadow(self,20)
		else
			self.title:SetTextColor(1,1,1,1)
		end
		self.title:SetText(title or "")
						
		Mod(self)
		
		return self
	end
	function ELib.CreatePopupFrame(width,height,title,isModern)
		return ELib:Popup(title,(not isModern) and 0):Size(width,height)
	end
end

do
	function ELib:OneTab(parent,text,isOld)
		local self = CreateFrame("Frame",nil,parent)
		if isOld then
			self:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
			self:SetBackdropColor(0,0,0,0.5)
		else
			ELib:Border(self,2,.24,.25,.30,1)
		end
		self.name = ELib:Text(self,text,nil,"GameFontNormal"):Size(0,0):Point("BOTTOMLEFT",self,"TOPLEFT",10,4):Bottom():Left()
		
		Mod(self)
		
		return self
	end
	
	function ELib.CreateOneTab(parent,width,height,relativePoint,x,y,text,isModern)
		return ELib:OneTab(parent,text,not isModern):Size(width,height):Point(relativePoint or "TOPLEFT",x,y)
	end
end

do
	function ELib.CreateColorPickButton(parent,width,height,relativePoint,x,y,cR,cG,cB,cA)
		local self = CreateFrame("Button",nil,parent)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		self:SetSize(width,height)
		self:SetBackdrop({edgeFile = DEFAULT_BORDER, edgeSize = 8})
		
		self:SetScript("OnEnter",function ()
			self:SetBackdropBorderColor(0.5,1,0,5,1)
		end)
		self:SetScript("OnLeave",function ()
		  	self:SetBackdropBorderColor(1,1,1,1)
		end)
		
		self.color = self:CreateTexture(nil, "BACKGROUND")
		self.color:SetColorTexture(cR or 0, cG or 0, cB or 0, cA or 1)
		self.color:SetAllPoints()
		
		return self
	end
end

do
	local function Widget_SetSize(self,width,height)
		self.list:Size(190,height-6)
		self:SetSize(width,height)
		return self
	end
	function ELib:ScrollTabsFrame(parent,...)
		local self = CreateFrame("Frame",nil,parent)

		self.list = ELib:ScrollList(self):Point("TOPLEFT",3,-3)
		self.tab = {}
		self.listCount = select("#", ...)
		for i=1,self.listCount do
			self.list.L[i] = select(i, ...)
			self.tab[i] = ELib:OneTab(self):Point("TOPLEFT",self.list,"TOPRIGHT",8,0):Point("BOTTOMRIGHT",self,-3,3)
			ELib:Border(self.tab[i],2,.24,.25,.30,1)
			ELib:Border(self.tab[i],1,0,0,0,1,2,1)
		end
		self.list:Update()
		
		local this = self
		function self.list:SetListValue(index)
			for i=1,this.listCount do
				ELib.ShowOrHide(this.tab[i],i == index)
			end
		end
		self.list.selected = 1
		self.list:SetListValue(1)
		
		Mod(self)
		self._Size = self.Size	self.Size = Widget_SetSize
	
		return self
	end
	function ELib.CreateScrollTabsFrame(parent,relativePoint,x,y,width,height,noSelfBorder,isModern,...)
		return ELib:ScrollTabsFrame(parent,...):Point(relativePoint or "TOPLEFT",x,y):Size(width,height)
	end
end

do
	local function DropDown_OnEnter(self)
		if self.tooltip then
			ELib.Tooltip.Show(self,nil,self.tooltip,self.Text:IsTruncated() and self.Text:GetText())
		elseif self.Text:IsTruncated() then
			ELib.Tooltip.Show(self,nil,self.Text:GetText())
		end
	end
	local function DropDown_OnLeave(self)
		GameTooltip_Hide()
	end
	local function ScrollDropDownOnHide(self)
		ELib:DropDownClose()
	end
	local function Widget_SetSize(self,width)
		if self.Middle then
			self.Middle:SetWidth(width)
			local defaultPadding = 25
			self:_SetWidth(width + defaultPadding + defaultPadding)
			self.Text:SetWidth(width - defaultPadding)
		else
			self:_SetWidth(width)
		end
		self.noResize = true
		return self
	end
	local function Widget_SetText(self,text)
		self.Text:SetText(text)
		return self
	end
	local function Widget_SetTooltip(self,text)
		self.tooltip = text
		self:SetScript("OnEnter",DropDown_OnEnter)
		self:SetScript("OnLeave",DropDown_OnLeave)
		
		return self
	end
	local function Widget_AddText(self,text)
		self.leftText = ELib:Text(self,text,12):Point("RIGHT",self,"LEFT",-5,0):Right():Middle():Color():Shadow()
		
		return self
	end	
	local function Widget_Disable(self)
		self.Button:Disable()
		
		return self
	end
	local function Widget_Enable(self)
		self.Button:Enable()
		
		return self
	end
	local function DropDown_OnClick(self,...)
		local parent = self:GetParent()
		if parent.PreUpdate then
			parent.PreUpdate(parent)
		end
		ELib.ScrollDropDown.ClickButton(self,...)
	end
		
	function ELib:DropDown(parent,width,lines,template)
		template = template == 0 and "ExRTDropDownMenuTemplate" or template or "ExRTDropDownMenuModernTemplate"
		local self = ELib:Template(template, parent) or CreateFrame("Frame", nil, parent, template)

		self.Button:SetScript("OnClick",DropDown_OnClick)
		self:SetScript("OnHide",ScrollDropDownOnHide)
		
		self.List = {}
		self.Width = width
		self.Lines = lines or 10
		
		if template == "ExRTDropDownMenuModernTemplate" then
			self.isModern = true
		end
		
		self.relativeTo = self.Left

		Mod(self,
			'SetText',Widget_SetText,
			'Tooltip',Widget_SetTooltip,
			'AddText',Widget_AddText,
			'Disable',Widget_Disable,
			'Enable',Widget_Enable
		)
		
		self._Size = self.Size
		self.Size = Widget_SetSize

		self._SetWidth = self.SetWidth		
		self.SetWidth = Widget_SetSize
		
		return self
	end
	function ELib.CreateScrollDropDown(parent,relativePoint,x,y,width,dropDownWidth,lines,defText,tooltip,template)
		return ELib:DropDown(parent,dropDownWidth,lines,template):Size(width):Point(relativePoint or "TOPLEFT",x,y):SetText(defText or ""):Tooltip(tooltip)
	end

	function ELib:DropDownButton(parent,defText,dropDownWidth,lines,template)
		local self = ELib:Button(parent,defText,template)
		
		self:SetScript("OnClick",ELib.ScrollDropDown.ClickButton)
		self:SetScript("OnHide",ScrollDropDownOnHide)
		
		self.List = {}
		self.Width = dropDownWidth
		self.Lines = lines or 10
		
		self.isButton = true
	
		return self
	end
	function ELib.CreateScrollDropDownButton(parent,relativePoint,x,y,width,height,dropDownWidth,lines,defText,tooltip,template)
		return ELib:DropDownButton(parent,defText,dropDownWidth,lines,template):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Tooltip(tooltip)
	end
end


ELib.ScrollDropDown = {}
ELib.ScrollDropDown.List = {}
local ScrollDropDown_Blizzard,ScrollDropDown_Modern = {},{}

for i=1,2 do
	ScrollDropDown_Modern[i] = ELib:Template("ExRTDropDownListModernTemplate",UIParent)
	_G[GlobalAddonName.."DropDownListModern"..i] = ScrollDropDown_Modern[i]
	ScrollDropDown_Modern[i]:SetClampedToScreen(true)
	ScrollDropDown_Modern[i].border = ELib:Shadow(ScrollDropDown_Modern[i],20)
	ScrollDropDown_Modern[i].Buttons = {}
	ScrollDropDown_Modern[i].MaxLines = 0
	ScrollDropDown_Modern[i].isModern = true
	do
		ScrollDropDown_Modern[i].Animation = CreateFrame("Frame",nil,ScrollDropDown_Modern[i])
		ScrollDropDown_Modern[i].Animation:SetSize(1,1)
		ScrollDropDown_Modern[i].Animation:SetPoint("CENTER")
		ScrollDropDown_Modern[i].Animation.P = 0
		ScrollDropDown_Modern[i].Animation.parent = ScrollDropDown_Modern[i]
		ScrollDropDown_Modern[i].Animation:SetScript("OnUpdate",function(self,elapsed)
			self.P = self.P + elapsed
			local P = self.P
			if P > 2.5 then
				P = P % 2.5
				self.P = P
			end
			local color = P <= 1 and P / 2 or P <= 1.5 and 0.5 or (2.5 - P)/2
			local parent = self.parent
			parent.BorderTop:SetColorTexture(color,color,color,1)
			parent.BorderLeft:SetColorTexture(color,color,color,1)
			parent.BorderBottom:SetColorTexture(color,color,color,1)
			parent.BorderRight:SetColorTexture(color,color,color,1)
		end)
	end
	
	ScrollDropDown_Modern[i].Slider = ELib.CreateSlider(ScrollDropDown_Modern[i],10,170,-8,-8,1,10,"Text",1,"TOPRIGHT",true,true)
	ScrollDropDown_Modern[i].Slider:SetScript("OnValueChanged",function (self,value)
		value = Round(value)
		self:GetParent().Position = value
		ELib.ScrollDropDown:Reload()
	end)
	ScrollDropDown_Modern[i].Slider:SetScript("OnEnter",function(self) UIDropDownMenu_StopCounting(self:GetParent()) end)
	ScrollDropDown_Modern[i].Slider:SetScript("OnLeave",function(self) UIDropDownMenu_StartCounting(self:GetParent()) end)
	
	ScrollDropDown_Modern[i]:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.Slider:GetMinMaxValues()
		local val = self.Slider:GetValue()
		if (val - delta) < min then
			self.Slider:SetValue(min)
		elseif (val - delta) > max then
			self.Slider:SetValue(max)
		else
			self.Slider:SetValue(val - delta)
		end
	end)
end

for i=1,2 do
	ScrollDropDown_Blizzard[i] = ELib:Template("ExRTDropDownListTemplate",UIParent)
	_G[GlobalAddonName.."DropDownList"..i] = ScrollDropDown_Blizzard[i]
	ScrollDropDown_Blizzard[i].Buttons = {}
	ScrollDropDown_Blizzard[i].MaxLines = 0
	
	ScrollDropDown_Blizzard[i].Slider = ELib.CreateSlider(ScrollDropDown_Blizzard[i],10,170,-15,-11,1,10,"Text",1,"TOPRIGHT",true)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnValueChanged",function (self,value)
		value = Round(value)
		self:GetParent().Position = value
		ELib.ScrollDropDown:Reload()
	end)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnEnter",function(self) UIDropDownMenu_StopCounting(self:GetParent()) end)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnLeave",function(self) UIDropDownMenu_StartCounting(self:GetParent()) end)
	
	ScrollDropDown_Blizzard[i]:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.Slider:GetMinMaxValues()
		local val = self.Slider:GetValue()
		if (val - delta) < min then
			self.Slider:SetValue(min)
		elseif (val - delta) > max then
			self.Slider:SetValue(max)
		else
			self.Slider:SetValue(val - delta)
		end
	end)
end

ELib.ScrollDropDown.DropDownList = ScrollDropDown_Blizzard

do
	local function CheckButtonClick(self)
		local parent = self:GetParent()
		self:GetParent():GetParent().List[parent.id].checkState = self:GetChecked()
		if parent.checkFunc then
			parent.checkFunc(parent,self:GetChecked())
		end
	end
	local function CheckButtonOnEnter(self)
		UIDropDownMenu_StopCounting(self:GetParent():GetParent())
	end
	local function CheckButtonOnLeave(self)
		UIDropDownMenu_StartCounting(self:GetParent():GetParent())
	end
	function ELib.ScrollDropDown.CreateButton(i,level)
		level = level or 1
		local dropDown = ELib.ScrollDropDown.DropDownList[level]
		if dropDown.Buttons[i] then
			return
		end
		dropDown.Buttons[i] = ELib:Template("ExRTDropDownMenuButtonTemplate",dropDown)
		if dropDown.isModern then
			dropDown.Buttons[i]:SetPoint("TOPLEFT",8,-8 - (i-1) * 16)
		else
			dropDown.Buttons[i]:SetPoint("TOPLEFT",18,-16 - (i-1) * 16)
		end
		dropDown.Buttons[i].NormalText:SetMaxLines(1) 
		
		if dropDown.isModern then
			dropDown.Buttons[i].checkButton = ELib:Template("ExRTCheckButtonModernTemplate",dropDown.Buttons[i])
			dropDown.Buttons[i].checkButton:SetPoint("LEFT",1,0)
			dropDown.Buttons[i].checkButton:SetSize(12,12)
			
			dropDown.Buttons[i].radioButton = ELib:Template("ExRTRadioButtonModernTemplate",dropDown.Buttons[i])
			dropDown.Buttons[i].radioButton:SetPoint("LEFT",1,0)
			dropDown.Buttons[i].radioButton:SetSize(12,12)
			dropDown.Buttons[i].radioButton:EnableMouse(false)
		else
			dropDown.Buttons[i].checkButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"UICheckButtonTemplate")
			dropDown.Buttons[i].checkButton:SetPoint("LEFT",-7,0)
			dropDown.Buttons[i].checkButton:SetScale(.6)
			
			dropDown.Buttons[i].radioButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i])	-- Do not used in blizzard style
		end
		dropDown.Buttons[i].checkButton:SetScript("OnClick",CheckButtonClick)
		dropDown.Buttons[i].checkButton:SetScript("OnEnter",CheckButtonOnEnter)
		dropDown.Buttons[i].checkButton:SetScript("OnLeave",CheckButtonOnLeave)
		dropDown.Buttons[i].checkButton:Hide()
		dropDown.Buttons[i].radioButton:Hide()
		
		dropDown.Buttons[i].Level = level
	end
end

local function ScrollDropDown_DefaultCheckFunc(self)
	self:Click()
end

function ELib.ScrollDropDown.ClickButton(self)
	if ELib.ScrollDropDown.DropDownList[1]:IsShown() then
		ELib:DropDownClose()
		return
	end
	local dropDown = nil
	if self.isButton then
		dropDown = self
	else
		dropDown = self:GetParent()
	end
	ELib.ScrollDropDown.ToggleDropDownMenu(dropDown)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function ELib.ScrollDropDown:Reload(level)
	for j=1,#ELib.ScrollDropDown.DropDownList do
		if ELib.ScrollDropDown.DropDownList[j]:IsShown() or level == j then
			local val = ELib.ScrollDropDown.DropDownList[j].Position
			local count = #ELib.ScrollDropDown.DropDownList[j].List
			local now = 0
			for i=val,count do
				local data = ELib.ScrollDropDown.DropDownList[j].List[i]
				
				if not data.isHidden then
					now = now + 1
					local button = ELib.ScrollDropDown.DropDownList[j].Buttons[now]
					local text = button.NormalText
					local icon = button.Icon
					local paddingLeft = data.padding or 0
					
					if data.icon then
						icon:SetTexture(data.icon)
						paddingLeft = paddingLeft + 18
						icon:Show()
					else
						icon:Hide()
					end
					
					if data.font then
						local font = _G[GlobalAddonName.."DropDownListFont"..now]
						if not font then
							font = CreateFont(GlobalAddonName.."DropDownListFont"..now)
						end
						font:SetFont(data.font,12)
						font:SetShadowOffset(1,-1)
						font:SetShadowColor(0,0,0)
						button:SetNormalFontObject(font)
						button:SetHighlightFontObject(font)
					else
						button:SetNormalFontObject(GameFontHighlightSmallLeft)
						button:SetHighlightFontObject(GameFontHighlightSmallLeft)
					end
					
					if data.colorCode then
						text:SetText( data.colorCode .. (data.text or "") .. "|r" )
					else
						text:SetText( data.text or "" )
					end
					
					text:ClearAllPoints()
					if data.checkable or data.radio then
						text:SetPoint("LEFT", paddingLeft + 16, 0)
					else
						text:SetPoint("LEFT", paddingLeft, 0)
					end
					text:SetPoint("RIGHT", button, "RIGHT", 0, 0)
					text:SetJustifyH(data.justifyH or "LEFT")
					
					if data.checkable then
						button.checkButton:SetChecked(data.checkState)
						button.checkButton:Show()
					else
						button.checkButton:Hide()
					end
					if data.radio then
						button.radioButton:SetChecked(data.checkState)
						button.radioButton:Show()
					else
						button.radioButton:Hide()
					end
					
					local texture = button.Texture
					if data.texture then
						texture:SetTexture(data.texture)
						texture:Show()
					else
						texture:Hide()
					end
					
					if data.subMenu then
						button.Arrow:Show()
					else
						button.Arrow:Hide()
					end
					
					if data.isTitle then
						button:SetEnabled(false)
					else
						button:SetEnabled(true)
					end
					
					button.id = i
					button.arg1 = data.arg1
					button.arg2 = data.arg2
					button.arg3 = data.arg3
					button.arg4 = data.arg4
					button.func = data.func
					button.hoverFunc = data.hoverFunc
					button.leaveFunc = data.leaveFunc
					button.hoverArg = data.hoverArg
					button.checkFunc = data.checkFunc
					
					if not data.checkFunc then
						button.checkFunc = ScrollDropDown_DefaultCheckFunc
					end
					
					button.subMenu = data.subMenu
					button.Lines = data.Lines --Max lines for second level
					
					button.data = data
				
					button:Show()
					
					if now >= ELib.ScrollDropDown.DropDownList[j].LinesNow then
						break
					end
				end
			end
			for i=(now+1),ELib.ScrollDropDown.DropDownList[j].MaxLines do
				ELib.ScrollDropDown.DropDownList[j].Buttons[i]:Hide()
			end
		end
	end
end

function ELib.ScrollDropDown.UpdateChecks()
	local parent = ELib.ScrollDropDown.DropDownList[1].parent
	if parent.additionalToggle then
		parent.additionalToggle(parent)
	end
	for j=1,#ELib.ScrollDropDown.DropDownList do
		for i=1,#ELib.ScrollDropDown.DropDownList[j].Buttons do
			local button = ELib.ScrollDropDown.DropDownList[j].Buttons[i]
			if button:IsShown() and button.data then
				button.checkButton:SetChecked(button.data.checkState)
			end
		end
	end
end


function ELib.ScrollDropDown.Update(self, elapsed)
	if ( not self.showTimer or not self.isCounting ) then
		return
	elseif ( self.showTimer < 0 ) then
		self:Hide()
		self.showTimer = nil
		self.isCounting = nil
	else
		self.showTimer = self.showTimer - elapsed
	end
end

function ELib.ScrollDropDown.OnClick(self, button, down)
	local func = self.func
	if func then
		func(self, self.arg1, self.arg2, self.arg3, self.arg4)
	end
end
function ELib.ScrollDropDown.OnButtonEnter(self)
	local func = self.hoverFunc
	if func then
		func(self,self.hoverArg)
	end
	ELib.ScrollDropDown:CloseSecondLevel(self.Level)
	if self.subMenu then
		ELib.ScrollDropDown.ToggleDropDownMenu(self,2)
	end
end
function ELib.ScrollDropDown.OnButtonLeave(self)
	local func = self.leaveFunc
	if func then
		func(self)
	end
end

function ELib.ScrollDropDown.ToggleDropDownMenu(self,level)
	level = level or 1
	if self.ToggleUpadte then
		self:ToggleUpadte()
	end
	
	if level == 1 then
		if self.isModern then
			ELib.ScrollDropDown.DropDownList = ScrollDropDown_Modern
		else
			ELib.ScrollDropDown.DropDownList = ScrollDropDown_Blizzard
		end
	end
	for i=level+1,#ELib.ScrollDropDown.DropDownList do
		ELib.ScrollDropDown.DropDownList[i]:Hide()
	end
	local dropDown = ELib.ScrollDropDown.DropDownList[level]

	local dropDownWidth = self.Width
	local isModern = self.isModern
	if level > 1 then
		local parent = ELib.ScrollDropDown.DropDownList[1].parent
		dropDownWidth = parent.Width
		isModern = parent.isModern
	end


	dropDown.List = self.subMenu or self.List
	
	local count = #dropDown.List
	
	local maxLinesNow = self.Lines or count
	
	for i=(dropDown.MaxLines+1),maxLinesNow do
		ELib.ScrollDropDown.CreateButton(i,level)
	end
	dropDown.MaxLines = max(dropDown.MaxLines,maxLinesNow)
	
	local isSliderHidden = max(count-maxLinesNow+1,1) == 1
	if isModern then 
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 16 - (isSliderHidden and 0 or 12),16)
		end
	else
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 22 + (isSliderHidden and 16 or 0),16)
		end
	end
	dropDown.Position = 1
	dropDown.LinesNow = maxLinesNow
	dropDown.Slider:SetValue(1)
	if self.additionalToggle then
		self.additionalToggle(self)
	end
	dropDown:ClearAllPoints()
	dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",-16,0)
	dropDown.Slider:SetMinMaxValues(1,max(count-maxLinesNow+1,1))
	if isModern then 
		dropDown:SetSize(dropDownWidth,16 + 16 * maxLinesNow)
		dropDown.Slider:SetHeight(maxLinesNow * 16)
	else
		dropDown:SetSize(dropDownWidth + 32,32 + 16 * maxLinesNow)
		dropDown.Slider:SetHeight(maxLinesNow * 16 + 10)	
	end
	if isSliderHidden then
		dropDown.Slider:Hide()
	else
		dropDown.Slider:Show()
	end
	dropDown:ClearAllPoints()
	if level > 1 then
		dropDown:SetPoint("TOPLEFT",self,"TOPRIGHT",level > 1 and ELib.ScrollDropDown.DropDownList[level-1].Slider:IsShown() and 24 or 12,isModern and 8 or 16)
	else
		local toggleX = self.toggleX or -16
		local toggleY = self.toggleY or 0
		dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",toggleX,toggleY)
	end
	
	dropDown.parent = self
	
	dropDown:Show()
	dropDown:SetFrameLevel(0)
	
	ELib.ScrollDropDown:Reload()
end

function ELib.ScrollDropDown.CreateInfo(self,info)
	if info then
		self.List[#self.List + 1] = info
	end
	self.List[#self.List + 1] = {}
	return self.List[#self.List]
end

function ELib.ScrollDropDown.ClearData(self)
	table.wipe(self.List)
	return self.List
end

function ELib.ScrollDropDown.Close()
	ELib.ScrollDropDown.DropDownList[1]:Hide()
	ELib.ScrollDropDown:CloseSecondLevel()
end
function ELib.ScrollDropDown:CloseSecondLevel(level)
	level = level or 1
	for i=(level+1),#ELib.ScrollDropDown.DropDownList do
		ELib.ScrollDropDown.DropDownList[i]:Hide()
	end
end
ELib.DropDownClose = ELib.ScrollDropDown.Close

---> End Scroll Drop Down


do
	local function ListFrameToggleButton(self)
		if self.OnClick then
			self:OnClick()
		end
		ELib.ScrollDropDown.ClickButton(self)
	end
	local function ListFrameOnHide(self)
		ELib:DropDownClose()
	end	
	local function Widget_OnClick(self,func)
		self.OnClick = func
		return self
	end
	local function Widget_Left(self)
		self.text:NewPoint("TOPRIGHT",self,"TOPLEFT",-2,0):Point("BOTTOMRIGHT",self,"BOTTOMLEFT",-2,0)
		return self
	end
	function ELib:ListButton(parent,text,width,lines,template)
		if template == 0 then
			template = "ExRTUIChatDownButtonTemplate"
		elseif not template then
			template = "ExRTUIChatDownButtonModernTemplate"
		end
		local self = ELib:Template(template,parent) or CreateFrame("Button",nil,parent,template)
		self.isButton = true
		self.text = ELib:Text(self,text,12):Point("TOPLEFT",self,"TOPRIGHT",2,0):Point("BOTTOMLEFT",self,"BOTTOMRIGHT",2,0):Color():Shadow()
		self:SetScript("OnClick",ListFrameToggleButton)
		self:SetScript("OnHide",ListFrameOnHide)
		self.List = {}
		self.Lines = lines
		self.Width = width
		self.isModern = template == "ExRTUIChatDownButtonModernTemplate"
		
		Mod(self,
			'Left',Widget_Left
		)
		self._OnClick = self.OnClick	self.OnClick = Widget_OnClick
				
		return self
	end
	
	function ELib.CreateListFrame(parent,width,buttonsNum,buttonPos,relativePoint,x,y,buttonText,listClickFunc,isModern)
		local self = ELib:ListButton(parent,buttonText,width,buttonsNum,not isModern and 0):Point(relativePoint or "TOPLEFT",x,y):OnClick(listClickFunc)
		if buttonPos == "RIGHT" then self:Left() end
		return self
	end
end

function ELib.SetPoint(self,...)
	self:ClearAllPoints()
	self:SetPoint(...)
end


--- Graph
do
	local Graph_DefColors = {
		{r = .65, g = .73, b = 0, a = 1},
		--{r = .65, g = 0, b = .8, a = 1},
		{r = .55, g = .55, b = .55, a = 1},
		{r = .82, g = .2, b = .2, a = 1},
		{r = .50, g = .20, b = .82, a = 1},
		{r = .38, g = .39, b = .82, a = 1},
		{r = .82, g = .60, b = .28, a = 1},
		{r = .41, g = .82, b = .77, a = 1},
		{r = .6, g = 1, b = .6, a = 1},
		{r = 1, g = 1, b = 1, a = 1},
		{r = .82, g = .25, b = .51, a = 1},
		{r = .10, g = .58, b = 0, a = 1},
		{r = .58, g = 0, b = 0, a = 1},
		{r = 0, g = .22, b = .40, a = 1},
	}
	local Graph_LinesTextures = {
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2px",
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxA",
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxB",
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxC",
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxD",
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxE",
	}
	local Graph_LinesTextures_Special = {
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxF",
		"Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2pxG",
	}
	local function GraphGetNode(self,i)
		if not self.graph[i] then
			self.graph[i] = self:CreateTexture(nil, "BACKGROUND")
			self.graph[i]:SetColorTexture(0.6, 1, 0.6, 1)
		end
		return self.graph[i]
	end
	local function GraphSetDot(self,i,x,y)
		if not self.dots[i] then
			self.dots[i] = self:CreateTexture(nil, "BACKGROUND")
			self.dots[i]:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\blip")
			self.dots[i]:SetSize(2,2)
			self.dots[i]:SetVertexColor(0.6, 1, 0.6, 1)
		end
		self.dots[i]:SetPoint("TOPLEFT", x, y - self.height)
		self.dots[i]:Show()
	end
	local GraphSetLine = nil
	do
		local cos, sin = math.cos, math.sin
		local function RotateCoordPair(x,y,ox,oy,a,asp)
			y=y/asp
			oy=oy/asp
			return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
		end
		local function RotateTexture(self,angle,xT,yT,xB,yB,xC,yC,userAspect)
			local aspect = userAspect or (xT-xB)/(yT-yB)
			local g1,g2 = RotateCoordPair(xT,yT,xC,yC,angle,aspect)
			local g3,g4 = RotateCoordPair(xT,yB,xC,yC,angle,aspect)
			local g5,g6 = RotateCoordPair(xB,yT,xC,yC,angle,aspect)
			local g7,g8 = RotateCoordPair(xB,yB,xC,yC,angle,aspect)
		
			self:SetTexCoord(g1,g2,g3,g4,g5,g6,g7,g8)
		end
		function GraphSetLine(self,i,fX,fY,tX,tY,texture)
			if not self.lines[i] then
				self.lines[i] = self:CreateTexture(nil, "BACKGROUND")
				self.lines[i]:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2px")
				self.lines[i]:SetSize(256,256)
				self.lines[i]:SetVertexColor(0.6, 1, 0.6, 1)
			end
			local toDown = tY < fY
			if toDown then
				tY,fY = fY,tY
			end
			local size = max(tX-fX,tY-fY)
			local changeSize = (1 - (size / 256)) / 2
			local min,max = changeSize,1 - changeSize
			local angle
			if tX-fX == 0 then
				angle = 90
			else
				angle = atan( (tY-fY)/(tX-fX) )
			end
			if toDown then
				angle = -angle
			end
			self.lines[i]:SetSize(size,size)
			RotateTexture(self.lines[i],(PI/180)*angle,min,min,max,max,.5,.5)
			
			self.lines[i]:SetPoint("CENTER",self,"BOTTOMLEFT",fX + (tX - fX)/2, fY + (tY - fY)/2)
			self.lines[i]:SetTexture(texture or "Interface\\AddOns\\"..GlobalAddonName.."\\media\\line2px")
			self.lines[i]:Show()
		end
	end
	local function GraphSetColor(self,i,r,g,b,a)
		if self.isDots then
			self.dots[i]:SetVertexColor(r,g,b,a)
		elseif self.isLines then
			self.lines[i]:SetVertexColor(r,g,b,a)
		else
			self.graph[i]:SetTexture(r,g,b,a)
		end
	end
	local function GraphSetVLine(self,i,X)
		if not self.vlines[i] then
			self.vlines[i] = self:CreateTexture(nil, "BACKGROUND")
			self.vlines[i]:SetColorTexture(1, 0.6, 0.6, .5)
			self.vlines[i]:SetSize(1,self.height)
		end
		self.vlines[i]:SetPoint("BOTTOM",self,"BOTTOMLEFT",X, 0)
		self.vlines[i]:Show()
	end
	
	local function GraphReload_BuildNodes(self,minX,minY,maxX,maxY,axixXstep,enableNodes)
		local nodeNow,Xnow,Ynow = 0,minX,minY
		self.tooltipsData = {}
		for i=1,#self.graph do
			self.graph[i]:Hide()
			self.graph[i]:ClearAllPoints()
		end
		for i=1,#self.dots do
			self.dots[i]:Hide()
		end
		for i=1,#self.lines do
			self.lines[i]:Hide()
		end
		local graphs_count = 0
		for k=1,#self.data do
			if not self.data[k].hide then
				graphs_count = graphs_count + 1
				Xnow,Ynow = minX,minY
				self.tooltipsData[graphs_count] = {
					main = self.data[k],
				}
				
				local colorR,colorG,colorB,colorA = self.data[k].r,self.data[k].g,self.data[k].b,self.data[k].a or 1
				local lineTypeNum = 1
				for i=k-1,1,-1 do
					if self.data[k].r and self.data[k].r == self.data[i].r and self.data[k].g == self.data[i].g and self.data[k].b == self.data[i].b then
						lineTypeNum = lineTypeNum + 1
					end
				end
				local lineType = Graph_LinesTextures[lineTypeNum % #Graph_LinesTextures] or Graph_LinesTextures[#Graph_LinesTextures]
				if colorR then
					local lineAlpha = 1 - floor((lineTypeNum-1) / 6) * 0.3
					if lineAlpha < 0.4 then
						lineAlpha = 1
					end
					colorA = not self.data[k].a and lineAlpha or colorA or 1
				end
				if not colorR or not colorG or not colorB then
					local defCount = k % #Graph_DefColors == 0 and #Graph_DefColors or k % #Graph_DefColors
					local defLine = floor((k-1) / #Graph_DefColors) + 1
					defLine = defLine > #Graph_LinesTextures and 1 or defLine
					
					local def = Graph_DefColors[defCount]
					if def then
						colorR,colorG,colorB,colorA = def.r,def.g,def.b,def.a
					else
						colorR,colorG,colorB,colorA = 1,1,1,.3
					end
					lineType = Graph_LinesTextures[defLine]
					
					self.data[k].color_count = defCount
				end
				local specialLine = self.data[k].specialLine
				if specialLine then
					lineType = Graph_LinesTextures_Special[type(specialLine)=='number' and specialLine or 1]
				end
				
				for i=1,#self.data[k],self.step do
					local x = self.data[k][i][1]
					local steps = 1
					for j=1,(self.step-1) do
						if self.data[k][i+j] then
							x=x+self.data[k][i+j][1]
							steps = steps + 1
						end
					end
					x = x / steps
					if x >= minX and x <= maxX then
						if (not self.isDots and not self.isLines) or enableNodes then
							if x ~= Xnow then
								nodeNow = nodeNow + 1
								local node = GraphGetNode(self,nodeNow)
								node:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",(Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height)
								node:SetSize( (x - Xnow)/(maxX - minX)*self.width , 2 )
								node:Show()
								
								Xnow = x
							end
						end
						
						local y = self.data[k][i][2]
						steps = 1
						for j=1,(self.step-1) do
							if self.data[k][i+j] then
								y=y+self.data[k][i+j][2]
								steps = steps + 1
							end
						end
						y = y / steps
						if (not self.isDots and not self.isLines) or enableNodes then
							if y ~= Ynow then
								nodeNow = nodeNow + 1
								local node = GraphGetNode(self,nodeNow)
								local relativePoint = (Ynow > y) and "TOPLEFT" or "BOTTOMLEFT"
								local heightFix = (Ynow > y) and 2 or 0
								node:SetPoint(relativePoint,self,"BOTTOMLEFT",(Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height + heightFix)
								node:SetSize( 2, abs(y - Ynow)/(maxY - minY)*self.height )
								node:Show()
								
								Ynow = y
							end
						end
						if self.isDots and not enableNodes then
							local fX,fY = (Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height
							local tX,tY = (x - minX)/(maxX - minX)*self.width,(y - minY)/(maxY - minY)*self.height
							local a = (tY - fY) / (tX - fX)
							nodeNow = nodeNow + 1
							GraphSetDot(self,nodeNow,fX,fY > self.height and self.height or fY)
							local lastX,lastY = fX,fY
							for X=fX,tX,axixXstep do
								local Y = (X-fX)*a + fY
								if Y > self.height then	Y = self.height	end
								if abs(X-lastX) > 1.5 or abs(Y-lastY) > 1.5 then
									nodeNow = nodeNow + 1
									GraphSetDot(self,nodeNow,X,Y)
									lastX = X
									lastY = Y
									
									if nodeNow > 10000 then
										ExRT.F.dprint("Graph: Error: Too much nodes")
										return
									end
								end
							end
							nodeNow = nodeNow + 1
							GraphSetDot(self,nodeNow,tX,tY > self.height and self.height or tY)
							
							Xnow = x
							Ynow = y
						end
						if self.isLines and not enableNodes then
							if x ~= Xnow or y ~= Ynow then
								local fX,fY = (Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height
								local tX,tY = (x - minX)/(maxX - minX)*self.width,(y - minY)/(maxY - minY)*self.height
								
								tY = tY > self.height and self.height or tY
								fY = fY > self.height and self.height or fY
								
								nodeNow = nodeNow + 1
								GraphSetLine(self,nodeNow,fX,fY,tX,tY,lineType)
								GraphSetColor(self,nodeNow,colorR,colorG,colorB,colorA)
								Xnow = x
								Ynow = y
							end
						end
						self.tooltipsData[graphs_count][#self.tooltipsData[graphs_count] + 1] = {(Xnow - minX)/(maxX - minX)*self.width,Ynow,i,(maxY - Ynow)/(maxY - minY)*self.height,self.data[k][i][3],self.data[k][i][4],self.data[k][i][5]}
					end
				end
			end
		end
		for i=1,#self.vlines do
			self.vlines[i]:Hide()
		end
		local vlines_count = 0
		if self.vertical_data then
			for i=1,#self.vertical_data do
				local x = self.vertical_data[i]
				if x >= minX and x <= maxX then
					local X = (x - minX)/(maxX - minX)*self.width
					
					vlines_count = vlines_count + 1
					GraphSetVLine(self,vlines_count,X)
				end
			end
		end
		ExRT.F.dprint("Graph: Nodes count:",nodeNow)
		return true
	end
	local function GraphReload(self)
		if self.OnBeforeReload then
			self:OnBeforeReload()
		end
	
		local minX,maxX,minY,maxY = nil
		local isZoom = self.ZoomMinX and self.ZoomMaxX
		for k=1,#self.data do
			if not self.data[k].hide then
				for i=1,#self.data[k],self.step do
					local x = self.data[k][i][1]
					local steps = 1
					for j=1,(self.step-1) do
						if self.data[k][i+j] then
							x=x+self.data[k][i+j][1]
							steps = steps + 1
						end
					end
					x = x / steps
					if not minX then
						minX = x
						maxX = x
					else
						minX = min(minX,x)
						maxX = max(maxX,x)
					end
					local y = self.data[k][i][2]
					steps = 1
					for j=1,(self.step-1) do
						if self.data[k][i+j] then
							y=y+self.data[k][i+j][2]
							steps = steps + 1
						end
					end
					y = y / steps
					if not isZoom or (x >= self.ZoomMinX and x <= self.ZoomMaxX) then
						if not minY then
							minY = y
							maxY = y
						else
							minY = min(minY,y)
							maxY = max(maxY,y)
						end
					end
				end
			end
		end
		
		if self.isZeroMin then
			minX = min(minX or 0,0)
			minY = min(minY or 0,0)
		end
		
		if minY == maxY then
			maxY = minY + 1
		end
		if minX == maxX then
			maxX = minX + 1
		end
		if self.ZoomMinX and self.ZoomMaxX and maxX then
			minX = max(minX,self.ZoomMinX)
			maxX = min(maxX,self.ZoomMaxX)
		end
		
		if self.ZoomMaxY and maxY then
			maxY = self.ZoomMaxY
		end
		
		self.range = {
			minX = minX,
			maxX = maxX,
			minY = minY,
			maxY = maxY,		
		}
		ExRT.F.dprint("Graph: minX,maxX,minY,maxY:",minX,maxX,minY,maxY)
		
		if maxY then
			if not self.IsYIsTime then
				self.MaxTextY:SetText(maxY < 1000 and (maxY % 1 == 0 and tostring(maxY) or format("%.1f",maxY)) or ExRT.F.shortNumber(maxY))
			else
				self.MaxTextY:SetFormattedText("%d:%02d",maxY / 60,maxY % 60)
			end
			self.MaxTextYButton:SetWidth(self.MaxTextY:GetStringWidth())
			self.MaxTextYButton:Show()
		else
			self.MaxTextY:SetText("")
			self.MaxTextYButton:Hide()
		end
		
		local result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.02)
		if not result then
			result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.04)			--Lower x step
		end
		if not result then
			result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.08,true)		--Stop using dots
		end
		if not result then
			print("|cffff0000Exorsus Raid Tools:|r Graph probably shows incorrect")
		end
		
		if self.ResetZoom then
			if self.ZoomMinX and self.ZoomMaxX then
				self.ResetZoom:Show()
			else
				self.ResetZoom:Hide()
			end
			self.ZoomMaxY = nil
		end
		
		if self.AddedOordLines then
			self:AddOordLines(self.AddedOordLines)
		end
		
		if self.OnAfterReload then
			self:OnAfterReload()
		end
	end
	local function GraphOnUpdate(self,elapsed)
		local x,y = GetCursorPos(self)
		if IsInFocus(self,x,y) then
			if #self.tooltipsData == 1 then
				local Y,X,_posY,xText,yText,comment,main = nil
				for k=1,#self.tooltipsData do
					for i=#self.tooltipsData[k],1,-1 do
						if (self.tooltipsData[k][i][1] - (self.tooltipsData[k][i-1] and (self.tooltipsData[k][i][1]-self.tooltipsData[k][i-1][1])/2 or 0)) < x or
							(i == 1 and x <= self.tooltipsData[k][i][1]) then
							Y = self.tooltipsData[k][i][2]
							X = self.tooltipsData[k][i][3]
							_posY = self.tooltipsData[k][i][4]
							xText = self.data.tooltipX and self.data.tooltipX[X] or self.tooltipsData[k][i][5]
							yText = self.tooltipsData[k][i][6]
							comment = self.tooltipsData[k][i][7]
							main = self.tooltipsData[k].main
							break
						end
					end
				end
				if Y then
					_posY = -_posY
					if _posY > 0 then
						_posY = 0
					end
					GameTooltip:SetOwner(self, "ANCHOR_LEFT",x,_posY)
					GameTooltip:SetText(xText or Round(X))
					GameTooltip:AddLine((main.name and main.name..": " or "")..(yText or Round(Y)))--,main.r or Graph_DefColors[main.color_count] and Graph_DefColors[main.color_count].r,main.g or Graph_DefColors[main.color_count] and Graph_DefColors[main.color_count].g,main.b or Graph_DefColors[main.color_count] and Graph_DefColors[main.color_count].b)
					if comment then
						GameTooltip:AddLine(comment)
					end
					GameTooltip:Show()
					if self.OnUpdateTooltip then
						self:OnUpdateTooltip(true,X,Y)
					end
				else
					GameTooltip_Hide()
					if self.OnUpdateTooltip then
						self:OnUpdateTooltip(false,X,Y)
					end
				end
			else
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				local lines = false
				local isXadded = false
				for k=1,#self.tooltipsData do
					for i=#self.tooltipsData[k],1,-1 do
						if (self.tooltipsData[k][i][1] - (self.tooltipsData[k][i-1] and (self.tooltipsData[k][i][1]-self.tooltipsData[k][i-1][1])/2 or 0)) < x or
							(i == 1 and x <= self.tooltipsData[k][i][1]) then
							local y = self.tooltipsData[k][i][2]
							local x = self.tooltipsData[k][i][3]
							local xText = self.data.tooltipX and self.data.tooltipX[x] or self.tooltipsData[k][i][5]
							local yText = self.tooltipsData[k][i][6]
							local comment = self.tooltipsData[k][i][7]
							local main = self.tooltipsData[k].main
							if not isXadded then
								GameTooltip:AddLine(xText or Round(x))
								isXadded = true
							end
							
							GameTooltip:AddLine((main.name and main.name..": " or "")..(yText or Round(y))..(comment and " ("..comment..")" or ""),main.r or Graph_DefColors[main.color_count] and Graph_DefColors[main.color_count].r,main.g or Graph_DefColors[main.color_count] and Graph_DefColors[main.color_count].g,main.b or Graph_DefColors[main.color_count] and Graph_DefColors[main.color_count].b)
							
							lines = true
							break
						end
					end
				end
				
				if lines then
					GameTooltip:Show()
				else
					GameTooltip_Hide()
				end
			end
		end
		if self.mouseDowned then
			local width = x - self.mouseDowned
			if width > 0 then
				width = min(width,self:GetWidth()-self.mouseDowned)
				self.selectingTexture:SetWidth(width)
				self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
			elseif width < 0 then
				width = -width
				width = min(width,self.mouseDowned)
				self.selectingTexture:SetWidth(width)
				self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned-width,0)
			else
				self.selectingTexture:SetWidth(1)
			end
		end
	end
	local function GraphOnUpdate_Zoom(self,elapsed)
		local x = ExRT.F.GetCursorPos(self)
		local width = x - self.mouseDowned
		if width > 0 then
			width = min(width,self:GetWidth()-self.mouseDowned)
			self.selectingTexture:SetWidth(width)
			self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
		elseif width < 0 then
			width = -width
			width = min(width,self.mouseDowned)
			self.selectingTexture:SetWidth(width)
			self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned-width,0)
		else
			self.selectingTexture:SetWidth(1)
		end
	end
	local function GraphOnMouseDown(self)
		if not self.range or not self.range.maxX then
			return
		end
		self.mouseDowned = GetCursorPos(self)
		self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
		self.selectingTexture:SetWidth(1)
		self.selectingTexture:Show()
		self:SetScript("OnUpdate",GraphOnUpdate_Zoom)
	end
	local function GraphOnMouseUp(self,isLeave)
		if isLeave == "LEAVE" then
			if self.selectingTexture then
				return "SELECTING"
				--self.selectingTexture:Hide()
			end
			self.mouseDowned = nil
			return
		end
		if not self.mouseDowned then
			return
		end
		self:SetScript("OnUpdate",nil)
		
		local x = GetCursorPos(self)
		if x < self.mouseDowned then
			x , self.mouseDowned = self.mouseDowned , x
		end
		local diff = abs(x - self.mouseDowned)
		
		local xLen = self.range.maxX - self.range.minX
		local width = self:GetWidth()
		local start = Round(self.mouseDowned / width * xLen + self.range.minX)
		local ending = Round(x / width * xLen + self.range.minX)
		
		if self.selectingTexture then
			self.selectingTexture:Hide()
		end
		self.mouseDowned = nil
		
		if self.Zoom and (not self.fixMissclickZoom or diff > 5) then
			self:Zoom(start,ending)
		end
	end
	local function GraphResetZoom(self)
		local parent = self:GetParent()
		parent.ZoomMinX = nil
		parent.ZoomMaxX = nil
		if parent.OnResetZoom then
			parent:OnResetZoom()
		end
		if parent.DisableReloadOnResetZoom then
			return
		end
		parent:Reload()
	end
	local function GraphZoom(self,start,ending)
		if ending == start then
			self.ZoomMinX = nil
			self.ZoomMaxX = nil
		else
			self.ZoomMinX = start
			self.ZoomMaxX = ending
		end
		self:Reload()
	end
	local function GraphCreateZoom(self)
		self.selectingTexture = self:CreateTexture(nil, "BACKGROUND",nil,2)
		self.selectingTexture:SetColorTexture(0, 0.65, 0.9, .7)
		self.selectingTexture:SetHeight(self:GetHeight())
		self.selectingTexture:Hide()
		
		self.ResetZoom = ELib.CreateButton(self,170,20,"TOPRIGHT",-2,-2,ExRT.L.BossWatcherGraphZoomReset,nil,nil,"ExRTButtonModernTemplate")
		self.ResetZoom:SetScript("OnClick",GraphResetZoom)
		self.ResetZoom:Hide()
		
		self.Zoom = GraphZoom
		
		self:SetScript("OnMouseDown",GraphOnMouseDown)
		self:SetScript("OnMouseUp",GraphOnMouseUp)
	end
	local function GraphOnLeave(self)
		GameTooltip_Hide()
		if GraphOnMouseUp(self,"LEAVE") == "SELECTING" then
			return
		end
		self:SetScript("OnUpdate",nil)
	end
	local function GraphOnEnter(self)
		self:SetScript("OnUpdate",GraphOnUpdate)
	end
	local function GraphSetMaxY(self,y)
		self.ZoomMaxY = nil
		if y then
			if y:find("k") then
				local n = y:match("^([0-9%.]+)k")
				n = tonumber(n or "0") or 0
				y:gsub("k",function()
					n = n * 1000
					return ""
				end)
				y = n
			end
			self.ZoomMaxY = tonumber(y)
			if self.ZoomMaxY == 0 then
				self.ZoomMaxY = nil
			end
		end
		self:Reload()
	end
	local function GraphTextYButtonOnClick(self)
		local parent = self:GetParent()
		ExRT.F.ShowInput("Set Max Y",GraphSetMaxY,parent)
	end
	local function GraphTextYButtonOnEnter(self)
		local parent = self:GetParent()
	  	parent.MaxTextY:SetTextColor(1,.5,.5,1)
	end
	local function GraphTextYButtonOnLeave(self)
	  	local parent = self:GetParent()
	  	parent.MaxTextY:SetTextColor(1,1,1,1)
	end
	local function GraphAddOordLines(self,num)
		self.axisYlines = self.axisYlines or {}
		for i=1,#self.axisYlines do
			self.axisYlines[i].text:Hide()
			self.axisYlines[i].line:Hide()
		end
		if not self.range then return end
		local minY,maxY = self.range.minY,self.range.maxY
		if not minY or not maxY then return end
		local diff = (maxY - minY) / (num + 1)
		for i=1,num do
			local lineFrame = self.axisYlines[i]
			if not lineFrame then
				lineFrame = {}
				self.axisYlines[i] = lineFrame
				
				lineFrame.text = ELib.CreateText(self,0,0,nil,0,0,"RIGHT","TOP",nil,10,"",nil,1,1,1)
				lineFrame.line = self:CreateTexture(nil, "BACKGROUND",nil,-1)
				lineFrame.line:SetSize(self.width,1)
				lineFrame.line:SetColorTexture(0.6, 0.6, 1, 1)
				
				lineFrame.text:SetNewPoint("TOPRIGHT",lineFrame.line,"TOPLEFT",-2,-2)
			end
			
			local posY = diff * i / (maxY - minY) * self.height
			
			if not self.IsYIsTime then
				lineFrame.text:SetText( floor(minY + diff * i + .5) )
			else
				local t = minY + diff * i
				lineFrame.text:SetFormattedText( "%d:%02d", t / 60, t % 60)
			end
			lineFrame.line:SetPoint("LEFT",self,"BOTTOMLEFT",0,posY)
			lineFrame.text:Show()
			lineFrame.line:Show()
		end
		
		self.AddedOordLines = num
	end
	
	function ELib.CreateGraph(parent,width,height,relativePoint,x,y,enableZoom)
		local self = CreateFrame(enableZoom and "Button" or "Frame",nil,parent)
		self:SetPoint(relativePoint or "TOPLEFT",parent, x, y)
		self:SetSize(width,height)
		
		self.width = width
		self.height = height
		self.step = 1
		self.isZeroMin = true
		
		self.axisX = self:CreateTexture(nil, "BACKGROUND")
		self.axisX:SetSize(width,2)
		self.axisX:SetPoint("TOPLEFT",self,"BOTTOMLEFT",0,0)
		self.axisX:SetColorTexture(0.6, 0.6, 1, 1)
		
		self.axisY = self:CreateTexture(nil, "BACKGROUND")
		self.axisY:SetSize(2,height)
		self.axisY:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",0,0)
		self.axisY:SetColorTexture(0.6, 0.6, 1, 1)
		
		self.MaxTextY = ELib.CreateText(self,0,0,nil,0,0,"RIGHT","TOP",nil,10,"",nil,1,1,1)
		self.MaxTextY:SetNewPoint("TOPRIGHT",self.axisY,"TOPLEFT",-2,-2)
		
		self.MaxTextYButton = CreateFrame("Button",nil,self)
		self.MaxTextYButton:SetPoint("TOPRIGHT",self.axisY,"TOPLEFT",-2,-2)
		self.MaxTextYButton:SetHeight(10)
		self.MaxTextYButton:SetScript("OnClick",GraphTextYButtonOnClick)
		self.MaxTextYButton:SetScript("OnEnter",GraphTextYButtonOnEnter)
		self.MaxTextYButton:SetScript("OnLeave",GraphTextYButtonOnLeave)
		self.MaxTextYButton:Hide()
		
		self.graph = {}
		self.dots = {}
		self.lines = {}
		self.vlines = {}
		self.isDots = false
		self.isLines = true
		self.tooltipsData = {}
		self.Reload = GraphReload
		--self:SetScript("OnUpdate",GraphOnUpdate)
		self:SetScript("OnEnter",GraphOnEnter)
		self:SetScript("OnLeave",GraphOnLeave)
		
		if enableZoom then
			GraphCreateZoom(self)
		end
		
		self.AddOordLines = GraphAddOordLines
			
		return self
	end
end

do
	local function MultilineEditBoxOnTextChanged(self,...)
		local parent = self.Parent
		local height = self:GetHeight()
		
		local prevMin,prevMax = parent.ScrollBar:GetMinMaxValues()
		local changeToMax = parent.ScrollBar:GetValue() >= prevMax
		
		parent:SetNewHeight( max( height,parent:GetHeight() ) )
		if changeToMax then
			local min,max = parent.ScrollBar:GetMinMaxValues()
			parent.ScrollBar:SetValue(max)
		end
		if parent.OnTextChanged then
			parent.OnTextChanged(self,...)
		elseif self.OnTextChanged then
			self:OnTextChanged(...)
		end
	end
	local function MultilineEditBoxGetTextHighlight(self)
		local text,cursor = self:GetText(),self:GetCursorPosition()
		self:Insert("")
		local textNew, cursorNew = self:GetText(), self:GetCursorPosition()
		self:SetText( text )
		self:SetCursorPosition( cursor )
		local Start, End = cursorNew, #text - ( #textNew - cursorNew )
		self:HighlightText( Start, End )
		return Start, End
	end
	local function MultilineEditBoxOnFrameClick(self)
		self:GetParent().EditBox:SetFocus()
	end
	local function Widget_Font(self,font,size,...)
		if font == 'x' then
			font = self.EditBox:GetFont() or DEFAULT_FONT
		end
		self.EditBox:SetFont(font,size,...)
		return self
	end
	local function Widget_OnChange(self,func)
		self.EditBox.OnTextChanged = func
		return self
	end
	local function Widget_Hyperlinks(self)
		self.EditBox:SetHyperlinksEnabled(true)
		self.EditBox:SetScript("OnHyperlinkEnter",ELib.Tooltip.Edit_Show)
		self.EditBox:SetScript("OnHyperlinkLeave",ELib.Tooltip.Hide)
		self.EditBox:SetScript("OnHyperlinkClick",ELib.Tooltip.Edit_Click)
		return self
	end
	local function Widget_MouseWheel(self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		delta = delta * (self.wheelRange or 20)
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end	
	local function Widget_ToTop(self)
		self.EditBox:SetCursorPosition(0)
		return self
	end	
	local function Widget_SetText(self,text)
		self.EditBox:SetText(text)
		return self
	end
	local function Widget_GetTextHighlight(self)
		return MultilineEditBoxGetTextHighlight(self.EditBox)
	end
	
	local function MultilineEditBox_OnCursorChanged(self, x, y, width, height)
		local parent = self.Parent
		y = abs(y)
		local scrollNow = parent:GetVerticalScroll()
		local heightNow = parent:GetHeight()
		if y < scrollNow then
			parent.ScrollBar:SetValue(max(floor(y),0))
		elseif (y + height) > (scrollNow + heightNow) then
			local _,scrollMax = parent.ScrollBar:GetMinMaxValues()
			parent.ScrollBar:SetValue(min(ceil( y + height - heightNow ),scrollMax))
		end
		
		if parent.Cursor730fix then
			parent:Cursor730fix(height,y)
		end
	end
	local function Widget_GetText(self)
		return self.EditBox:GetText()
	end
	
	local function Widget_Apply730fix(self)
		if type(ExRT)=='table' and type(ExRT.clientVersion)=='number' and ExRT.clientVersion > 70300 then
			return		--Fixed in 7.3.2
		end
		self.MirrorEditBox = ELib:Edit(self.C,nil,nil,1):Point("TOPLEFT",self.C,0,0):Point("TOPRIGHT",self.C,0,0)

		self.MirrorEditBox:SetMultiLine(true) 
		self.MirrorEditBox:SetBackdropColor(0, 0, 0, 0)
		self.MirrorEditBox:SetBackdropBorderColor(0, 0, 0, 0)
		self.MirrorEditBox:SetTextInsets(5,5,2,2)
		
		self.MirrorEditBox:EnableKeyboard(false)
		self.MirrorEditBox:SetScript("OnKeyDown", function() end)
		self.MirrorEditBox:SetAlpha(0)

		for i=1,self.EditBox:GetNumRegions() do
			local region = select(i,self.EditBox:GetRegions())
			if region and region.GetTexture and region:GetTexture() == "Color-ffffffff" then
				self.EditBox.cursor = region
				local cursorHeigthHardcode = 12
				local prevPosY,prevY = 0
				local function UpdateVerticalPos()
					local arg1,arg2,arg3,arg4,arg5 = region:GetPoint()
					if not arg1 then
						return
					end
					region:SetPoint(arg1,arg2,arg3,arg4,prevPosY)
				end
				self.Cursor730fix = function(_,cursorHeight,y)
					local p = self.EditBox:GetCursorPosition()
					cursorHeigthHardcode = cursorHeight
					if prevY ~= y then
						prevY = y
						local textA = self.EditBox:GetText():sub(1,p)
						local textB = self.EditBox:GetText():sub(p+1,-1):gsub("[ \n].*","")
						self.MirrorEditBox:SetText(textA..textB)
					else
						UpdateVerticalPos()
					end
				end
				self.MirrorEditBox:SetScript("OnSizeChanged", function(_,_,height) 
					prevPosY = -(height - cursorHeigthHardcode - 4)
					UpdateVerticalPos()
				end)
				break			
			end
		end
	end	
	
	function ELib:MultiEdit(parent)
		local self = ELib:ScrollFrame(parent)
		self:SetBackdropColor(0,0,0,.8)
		
		self.EditBox = ELib:Edit(self.C,nil,nil,1):Point("TOPLEFT",self.C,0,0):Point("TOPRIGHT",self.C,0,0):OnChange(MultilineEditBoxOnTextChanged)
		
		self.EditBox.Parent = self
		self.EditBox:SetMultiLine(true) 
		self.EditBox:SetBackdropColor(0, 0, 0, 0)
		self.EditBox:SetBackdropBorderColor(0, 0, 0, 0)
		self.EditBox:SetTextInsets(5,5,2,2)
		self.EditBox:SetScript("OnCursorChanged",MultilineEditBox_OnCursorChanged)
		
		self.C:SetScript("OnMouseDown",MultilineEditBoxOnFrameClick)
		self:SetScript("OnMouseWheel",Widget_MouseWheel)
		
		self.EditBox.GetTextHighlight = MultilineEditBoxGetTextHighlight
		
		self.Font = Widget_Font
		self.OnChange = Widget_OnChange
		self.Hyperlinks = Widget_Hyperlinks
		self.ToTop = Widget_ToTop
		self.SetText = Widget_SetText
		self.GetTextHighlight = Widget_GetTextHighlight
		self.GetText = Widget_GetText
		self.Add730fix = Widget_Apply730fix
		
		return self
	end
	function ELib.CreateMultilineEditBox(parent,width,height,relativePoint,x,y)	--Old
		return ELib:MultiEdit(parent):Size(width,height):Point(relativePoint or "TOPLEFT",x,y)
	end
	
	local function MultilineEditBox2OnTextChanged(self,...)
		local parent = self.Parent
		local height = self:GetHeight()
		
		parent:SetNewHeight( max( height,parent:GetHeight() ) )
		if parent.OnTextChanged then
			parent.OnTextChanged(self,...)
		elseif self.OnTextChanged then
			self:OnTextChanged(...)
		end
	end
	local function ScrollFrameChangeHeight(self,newHeight)
		self.content:SetHeight(newHeight)
		return self
	end
	function ELib:MultiEdit2(parent)
		local self = ELib:MultiEdit(parent)
		self.EditBox:OnChange(MultilineEditBox2OnTextChanged)
		self.EditBox:SetScript("OnCursorChanged",nil)
		self.SetNewHeight = ScrollFrameChangeHeight
		self.Height = ScrollFrameChangeHeight
		return self
	end
end

do
	local function Widget_Texture(self,texture,layer,cB,cA,altLayer)
		if not self.texture then
			self.texture = self:CreateTexture(nil, altLayer or (type(layer)~='number' and layer) or "BACKGROUND")
			Mod(self.texture)
		end
		if type(texture)=='number' and type(layer)=='number' then
			self.texture:SetColorTexture(texture,layer,cB,cA)
		else
			self.texture:SetTexture(texture or "")
		end
		return self
	end
	local function Widget_TexturePoint(self,...)
		self.texture:Point(...)
		return self
	end
	local function Widget_TextureSize(self,...)
		self.texture:Size(...)
		return self
	end
	function ELib:Frame(parent,template)
		local self = CreateFrame('Frame',nil,parent or UIParent,template)
		Mod(self,
			'Texture',Widget_Texture,
			'TexturePoint',Widget_TexturePoint,
			'TextureSize',Widget_TextureSize
		)
		return self
	end
end

do
	local function SetBorderColor(self,colorR,colorG,colorB,colorA,layerCounter)
		layerCounter = layerCounter or ""
		
		self["border_top"..layerCounter]:SetColorTexture(colorR,colorG,colorB,colorA)
		self["border_bottom"..layerCounter]:SetColorTexture(colorR,colorG,colorB,colorA)
		self["border_left"..layerCounter]:SetColorTexture(colorR,colorG,colorB,colorA)
		self["border_right"..layerCounter]:SetColorTexture(colorR,colorG,colorB,colorA)
	end
	function ELib:Border(parent,size,colorR,colorG,colorB,colorA,outside,layerCounter)
		outside = outside or 0
		layerCounter = layerCounter or ""
		if size == 0 then
			if parent["border_top"..layerCounter] then
				parent["border_top"..layerCounter]:Hide()
				parent["border_bottom"..layerCounter]:Hide()
				parent["border_left"..layerCounter]:Hide()
				parent["border_right"..layerCounter]:Hide()
			end
			return
		end
		
		local textureOwner = parent.CreateTexture and parent or parent:GetParent()
		
		local top = parent["border_top"..layerCounter] or textureOwner:CreateTexture(nil, "BORDER")
		local bottom = parent["border_bottom"..layerCounter] or textureOwner:CreateTexture(nil, "BORDER")
		local left = parent["border_left"..layerCounter] or textureOwner:CreateTexture(nil, "BORDER")
		local right = parent["border_right"..layerCounter] or textureOwner:CreateTexture(nil, "BORDER")

		parent["border_top"..layerCounter] = top
		parent["border_bottom"..layerCounter] = bottom
		parent["border_left"..layerCounter] = left
		parent["border_right"..layerCounter] = right
	
		top:ClearAllPoints()
		bottom:ClearAllPoints()
		left:ClearAllPoints()
		right:ClearAllPoints()
		
		top:SetPoint("TOPLEFT",parent,"TOPLEFT",-size-outside,size+outside)
		top:SetPoint("BOTTOMRIGHT",parent,"TOPRIGHT",size+outside,outside)
	
		bottom:SetPoint("BOTTOMLEFT",parent,"BOTTOMLEFT",-size-outside,-size-outside)
		bottom:SetPoint("TOPRIGHT",parent,"BOTTOMRIGHT",size+outside,-outside)
	
		left:SetPoint("TOPLEFT",parent,"TOPLEFT",-size-outside,outside)
		left:SetPoint("BOTTOMRIGHT",parent,"BOTTOMLEFT",-outside,-outside)
	
		right:SetPoint("TOPLEFT",parent,"TOPRIGHT",outside,outside)
		right:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT",size+outside,-outside)
	
		top:SetColorTexture(colorR,colorG,colorB,colorA)
		bottom:SetColorTexture(colorR,colorG,colorB,colorA)
		left:SetColorTexture(colorR,colorG,colorB,colorA)
		right:SetColorTexture(colorR,colorG,colorB,colorA)
		
		parent.SetBorderColor = SetBorderColor
	
		top:Show()
		bottom:Show()
		left:Show()
		right:Show()
	end
end

do
	local function utf8charbytes(s, i)
		-- argument defaults
		i = i or 1
	
		-- argument checking
		if type(s) ~= "string" then
			error("bad argument #1 to 'utf8charbytes' (string expected, got ".. type(s).. ")")
		end
		if type(i) ~= "number" then
			error("bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")")
		end
	
		local c = s:byte(i)
	
		-- determine bytes needed for character, based on RFC 3629
		-- validate byte 1
		if c > 0 and c <= 127 then
			-- UTF8-1
			return 1
	
		elseif c >= 194 and c <= 223 then
			-- UTF8-2
			local c2 = s:byte(i + 1)
	
			if not c2 then
				error("UTF-8 string terminated early")
			end
	
			-- validate byte 2
			if c2 < 128 or c2 > 191 then
				error("Invalid UTF-8 character")
			end
	
			return 2
	
		elseif c >= 224 and c <= 239 then
			-- UTF8-3
			local c2 = s:byte(i + 1)
			local c3 = s:byte(i + 2)
	
			if not c2 or not c3 then
				error("UTF-8 string terminated early")
			end
	
			-- validate byte 2
			if c == 224 and (c2 < 160 or c2 > 191) then
				error("Invalid UTF-8 character")
			elseif c == 237 and (c2 < 128 or c2 > 159) then
				error("Invalid UTF-8 character")
			elseif c2 < 128 or c2 > 191 then
				error("Invalid UTF-8 character")
			end
	
			-- validate byte 3
			if c3 < 128 or c3 > 191 then
				error("Invalid UTF-8 character")
			end
	
			return 3
	
		elseif c >= 240 and c <= 244 then
			-- UTF8-4
			local c2 = s:byte(i + 1)
			local c3 = s:byte(i + 2)
			local c4 = s:byte(i + 3)
	
			if not c2 or not c3 or not c4 then
				error("UTF-8 string terminated early")
			end
	
			-- validate byte 2
			if c == 240 and (c2 < 144 or c2 > 191) then
				error("Invalid UTF-8 character")
			elseif c == 244 and (c2 < 128 or c2 > 143) then
				error("Invalid UTF-8 character")
			elseif c2 < 128 or c2 > 191 then
				error("Invalid UTF-8 character")
			end
			
			-- validate byte 3
			if c3 < 128 or c3 > 191 then
				error("Invalid UTF-8 character")
			end
	
			-- validate byte 4
			if c4 < 128 or c4 > 191 then
				error("Invalid UTF-8 character")
			end
	
			return 4
	
		else
			error("Invalid UTF-8 character")
		end
	end
	
	
	local function UpdateScroll(self)
		local height = self:GetHeight()
		
		local prevMin,prevMax = self.ScrollBar:GetMinMaxValues()
		local prevVal = self.ScrollBar:GetValue()
		local changeToMax = prevVal >= prevMax
	
		local low = (self.TextLines[1]:GetTop() or 0) - (self.TextLines[#self.Lines]:GetBottom() or 0)
		self:SetNewHeight(math.max(4+low,height))
	
		if not self.TextLines[self.cursorY] then
			return
		end
	
		local cursorPosBot = math.max((self.TextLines[1]:GetTop() or 0) - (self.TextLines[self.cursorY]:GetBottom() or 0) - height,0)
		local cursorPosTop = math.max((self.TextLines[1]:GetTop() or 0) - (self.TextLines[self.cursorY]:GetTop() or 0),0)
	
		if (prevVal < cursorPosBot) then
			self.ScrollBar:SetValue(cursorPosBot)
		elseif prevVal < cursorPosBot + height then
			--all is ok
			self.ScrollBar:SetValue(prevVal)
		elseif prevVal > cursorPosTop then
			self.ScrollBar:SetValue(cursorPosTop)
		else
			self.ScrollBar:SetValue(prevVal)
		end
	end
	
	local COLOR1 = "f92672" --lua
	local COLOR2 = "e6db74" --string
	local COLOR3 = "75715e" --comment
	local COLOR4 = "5dffed" -- ()=.
	local COLOR5 = "ae81ff" --numbers

	local lua_str = {
		["function"] = true,
		["end"] = true,
		["if"] = true,
		["elseif"] = true,
		["else"] = true,
		["then"] = true,
		["false"] = true,
		["do"] = true,
		["and"] = true,
		["break"] = true,
		["for"] = true,
		["local"] = true,
		["nil"] = true,
		["not"] = true,
		["or"] = true,
		["return"] = true,
		["while"] = true,
		["until"] = true,
		["repeat"] = true,
	}

	local function ReplaceLua1(pre,str,fin)
		if lua_str[str] then
			return pre.."|cff"..COLOR1..str.."|r"..fin
		end
	end
	local function ReplaceLua2(str,fin)
		if lua_str[str] then
			return "|cff"..COLOR1..str.."|r"..fin
		end
	end
	local function ReplaceLua3(pre,str)
		if lua_str[str] then
			return pre.."|cff"..COLOR1..str.."|r"
		end
	end
	local function ReplaceLua4(str)
		if lua_str[str] then
			return "|cff"..COLOR1..str.."|r"
		end
	end

	local function ReplaceString(str)
		str = str:gsub("|c........",""):gsub("|r","")
		return "|cff"..COLOR2..str.."|r"
	end

	local function ReplaceComment(str)
		str = str:gsub("|c........",""):gsub("|r","")
		return "|cff"..COLOR3..str.."|r"
	end
	
	local function ModdedSetText(self,text)
		self:_SetText(text)
	
		if self.parent.SyntaxLUA then
			text = text
				:gsub("(%A)([%d]+)","%1|cff"..COLOR5.."%2|r")
	
				:gsub("(%A)(%l+)(%A)",ReplaceLua1):gsub("^(%l+)(%A)",ReplaceLua2):gsub("(%A)(%l+)$",ReplaceLua3):gsub("^(%l+)$",ReplaceLua4)
	
				:gsub("[\\/]+","|cff"..COLOR1.."%1|r")	
		
				:gsub("([%(%)%.=,%[%]<>%+{}#]+)","|cff"..COLOR4.."%1|r")
	
				:gsub('("[^"]+")',ReplaceString)
	
				:gsub('(%-%-.-)$',ReplaceComment)
		end
	
		self.coloredLine:SetText(text)
	end

	local function Widget_SetSyntax(self,syntax)
		syntax = syntax:lower()
		if syntax == "lua" then
			self.SyntaxLUA = true
		else
			self.SyntaxLUA = nil
		end
		self:UpdateText()

		return self
	end
	
	local function UpdateText(self)
		for i=1,#self.Lines do
			local tLine = self.TextLines[i]
			if not tLine then
				tLine = self.C:CreateFontString(nil,"ARTWORK","GameFontWhite")
	
				self.TextLines[i] = tLine
	
				tLine:SetJustifyH("LEFT")
				tLine:SetJustifyV("TOP")
			
				--tLine:SetPoint("RIGHT",self.C,-2,0)
				tLine:SetWidth((self.width or 400)-20-4)
			
				tLine:SetFont(GameFontWhite:GetFont(),12)
				
				tLine.parent = self

				tLine._SetText = tLine.SetText
				tLine.SetText = ModdedSetText
	
				local coloredLine = self.C:CreateFontString(nil,"ARTWORK","GameFontWhite")
				coloredLine:SetJustifyH("LEFT")
				coloredLine:SetJustifyV("TOP")
				coloredLine:SetWidth((self.width or 400)-20-4)
				coloredLine:SetFont(GameFontWhite:GetFont(),12)
			
				tLine.coloredLine = coloredLine
				tLine:SetAlpha(0)
	
				if i==1 then
					tLine:SetPoint("TOPLEFT",self.C,2,-2)
				else
					tLine:SetPoint("TOPLEFT",self.TextLines[i-1],"BOTTOMLEFT",0,-1)
				end
	
				coloredLine:SetPoint("TOPLEFT",tLine)
			end
			
			local text = self.Lines[i]
			if text == "" then
				text = " "
			end
	
			tLine:SetText(text)
		end
		for i=#self.Lines+1,#self.TextLines do
			self.TextLines[i]:SetText("")
		end
		self:UpdateScroll()
		if self.OnChangeFunc then
			self:OnChangeFunc()
		end
	end
	
	local function OnTextChanged(self,userInput)
		text = self:GetText()
		if not userInput then
			if text ~= "" and not self.ctrl then
				self:SetText("")
			end
			return
		end
		if self.parent:GetHighlight() and self.ctrl then
			self:GetScript("OnKeyDown")(self,"BACKSPACE")
		end
		if text == "\n" then
			self:SetText("")
			return
		end
		local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
		if text:find("\n") then
			local l = {strsplit("\n",text)}
			local toend = lines[cursorY]:sub(cursorX)
			lines[cursorY] = lines[cursorY]:sub(1,cursorX-1) .. l[1]
			for i=2,#l-1 do
				tinsert(lines,cursorY+i-1,l[i])
			end
			tinsert(lines,cursorY+#l-1,l[#l]..toend)
			self.parent.cursorY = cursorY + #l
			self.parent.cursorX = #l[#l]
		else
			lines[cursorY] = lines[cursorY] or ""
			lines[cursorY] = lines[cursorY]:sub(1,cursorX-1) .. text .. lines[cursorY]:sub(cursorX)
			self.parent.cursorX = cursorX + #text
		end
		self:SetText("")
		self.parent:UpdateText()
	end
	
	local function GetHighlightTexture(self,c)
		if not self.HighlightsTextures[c] then
			self.HighlightsTextures[c] = self:GetParent():CreateTexture()
			self.HighlightsTextures[c]:SetColorTexture(1,1,1,.3)
		end
		self.HighlightsTextures[c]:ClearAllPoints()
		self.HighlightsTextures[c]:Show()
	
		return self.HighlightsTextures[c]
	end
	
	local function Highlight(self,sX,sY,fX,fY)
		self.HighlightsTextures = self.HighlightsTextures or {}
		if not sX then
			for i=1,#self.HighlightsTextures do
				self.HighlightsTextures[i]:Hide()
			end
			self.highlightSX = nil
			self.highlightSY = nil
			self.highlightFX = nil
			self.highlightFY = nil
			return
		end
		if sY == fY then
			if sX > fX then
				fX,sX = sX,fX
			end
		else
			if sY > fY then
				fX,sX = sX,fX
				fY,sY = sY,fY
			end
		end
		local c = 0
		for i=sY+1,fY-1 do
			c = c + 1
			local t = GetHighlightTexture(self,c)
			t:SetPoint("TOPLEFT",self.TextLines[i],0,0)
			t:SetSize((self.parent.width or 400)-20-4,12)
		end
		if sY ~= fY then
			c = c + 1
		
			local line = self.TextLines[sY]
			if line then
				local l,t = line:GetLeft(),line:GetTop()
				for i=1,line:GetWidth() do
					local x = line:FindCharacterIndexAtCoordinate(l+i,t)
					if x == sX then
						local t = GetHighlightTexture(self,c)
						t:SetPoint("TOPLEFT",line,i,0)
						t:SetSize((self.parent.width or 400)-20-4,12)
	
						break
					end
				end
			end
	
			c = c + 1
			local line = self.TextLines[fY]
			if line then
				local l,t = line:GetLeft(),line:GetTop()
				for i=1,line:GetWidth() do
					local x = line:FindCharacterIndexAtCoordinate(l+i,t)
					if x == fX then
						local t = GetHighlightTexture(self,c)
						t:SetPoint("TOPLEFT",line,0,0)
						t:SetSize(i,12)
	
						break
					end
				end
			end
	
			local copyPaste = self.parent.Lines[sY]:sub(sX)
			for i=sY+1,fY-1 do
				copyPaste = copyPaste .. "\n" .. self.parent.Lines[i]
			end
			copyPaste = copyPaste .. "\n" .. self.parent.Lines[fY]:sub(1,fX-1)
			self.copyPaste = copyPaste
		else
			c = c + 1
		
			local line = self.TextLines[sY]
			if line then
				local l,t = line:GetLeft(),line:GetTop()
				local s
				for i=1,line:GetWidth() do
					local x = line:FindCharacterIndexAtCoordinate(l+i,t)
					if x == sX and not s then
						s = i
					elseif x == fX then
						local t = GetHighlightTexture(self,c)
						t:SetPoint("TOPLEFT",line,s,0)
						t:SetSize(i-s,12)
	
						break					
					end
				end
			end
	
			local copyPaste = self.parent.Lines[sY]:sub(sX,fX-1)
			self.copyPaste = copyPaste
		end
		self.highlightSX = sX
		self.highlightSY = sY
		self.highlightFX = fX
		self.highlightFY = fY
		for i=c+1,#self.HighlightsTextures do
			self.HighlightsTextures[i]:Hide()
		end
	end

	local function GetHighlight(self)
		if self.EditBox.highlightSX then
			local text = ""
			if self.EditBox.highlightSY == self.EditBox.highlightFY then
				text = self.Lines[self.EditBox.highlightSY]:sub(self.EditBox.highlightSX,self.EditBox.highlightFX)
			else
				text = self.Lines[self.EditBox.highlightSY]:sub(self.EditBox.highlightSX)
				for i=self.EditBox.highlightSY+1,self.EditBox.highlightFY-1 do
					text = text .. "\n" .. self.Lines[i]
				end
				text = text .. "\n" .. self.Lines[self.highlightFY]:sub(1,self.EditBox.highlightFX)
			end
			return text
		end
	end
	
	local function OnKeyDown(self,key)
		if key == "BACKSPACE" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			if self.highlightSX then
				self.parent.cursorX = self.highlightSX
				self.parent.cursorY = self.highlightSY
				lines[self.parent.cursorY] = lines[self.parent.cursorY]:sub(1,self.parent.cursorX-1) .. lines[self.highlightFY]:sub(self.highlightFX) 
				for i=self.highlightFY,self.parent.cursorY+1,-1 do
					tremove(lines,i)
				end
				Highlight(self)
			elseif self.parent.cursorX == 1 then
				if self.parent.cursorY == 1 then
					return
				end
				
				self.parent.cursorY = self.parent.cursorY - 1
				self.parent.cursorX = math.max(#lines[self.parent.cursorY]+1,1)

				lines[self.parent.cursorY] = lines[self.parent.cursorY] .. lines[self.parent.cursorY+1]
				tremove(lines,self.parent.cursorY+1)
			else
				local s = lines[self.parent.cursorY]
				local pos = 1
				local last = 0
			
				while pos < self.parent.cursorX do
					last = utf8charbytes(s, pos)
					pos = pos + last
				end
		
				lines[self.parent.cursorY] = lines[self.parent.cursorY] or ""
				lines[self.parent.cursorY] = lines[self.parent.cursorY]:sub(1,self.parent.cursorX-last-1) .. lines[self.parent.cursorY]:sub(self.parent.cursorX)
				self.parent.cursorX = self.parent.cursorX - last
			end
	
			self.parent:UpdateText()	
		elseif key == "DELETE" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			if self.highlightSX then
				self.parent.cursorX = self.highlightSX
				self.parent.cursorY = self.highlightSY
				lines[self.parent.cursorY] = lines[self.parent.cursorY]:sub(1,self.parent.cursorX-1) .. lines[self.highlightFY]:sub(self.highlightFX) 
				for i=self.highlightFY,self.parent.cursorY+1,-1 do
					tremove(lines,i)
				end
				Highlight(self)
			else
				local s = lines[self.parent.cursorY]
				local pos = 1
				local last = 0
				local bytes = s:len()
			
				while pos <= bytes and pos <= self.parent.cursorX do
					last = utf8charbytes(s, pos)
					pos = pos + last
				end
				if self.parent.cursorX <= bytes then
					lines[self.parent.cursorY] = lines[self.parent.cursorY] or ""
					lines[self.parent.cursorY] = lines[self.parent.cursorY]:sub(1,self.parent.cursorX-1) .. lines[self.parent.cursorY]:sub(self.parent.cursorX + last)
				else
					lines[self.parent.cursorY] = lines[self.parent.cursorY] or ""
					lines[self.parent.cursorY] = lines[self.parent.cursorY] .. (lines[self.parent.cursorY+1] or "")
					tremove(lines,self.parent.cursorY+1)
				end
			end
	
			self.parent:UpdateText()	
		elseif key == "ENTER" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			local str = lines[self.parent.cursorY]:sub(self.parent.cursorX)
			lines[self.parent.cursorY] = lines[self.parent.cursorY]:sub(1,self.parent.cursorX-1)
	
			tinsert(lines,self.parent.cursorY+1,str)
	
			self.parent.cursorY = self.parent.cursorY + 1
			self.parent.cursorX = 1
			lines[self.parent.cursorY] = lines[self.parent.cursorY] or ""
	
			self.parent:UpdateText()
		elseif key == "LEFT" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			local s = lines[self.parent.cursorY]
			local pos = 1
			local last = 0
			local bytes = s:len()
		
			while pos <= bytes and pos < self.parent.cursorX do
				last = utf8charbytes(s, pos)
				pos = pos + last
			end
	
			local s = #lines[self.parent.cursorY]:sub(self.parent.cursorX-last,self.parent.cursorX-1)
			self.parent.cursorX = self.parent.cursorX - s
			if self.parent.cursorX <= 0 or s == 0 then
				if self.parent.cursorY ~= 1 then
					self.parent.cursorY = math.max(self.parent.cursorY - 1,1)
					self.parent.cursorX = math.max(#lines[self.parent.cursorY]+1,1)
				end
			end
	
			Highlight(self)
		elseif key == "RIGHT" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			local s = lines[self.parent.cursorY]
			local pos = 1
			local last = 0
			local bytes = s:len()
		
			while pos <= bytes and pos <= self.parent.cursorX do
				last = utf8charbytes(s, pos)
				pos = pos + last
			end
	
			local s = #lines[self.parent.cursorY]:sub(self.parent.cursorX,self.parent.cursorX+last-1)
			self.parent.cursorX = self.parent.cursorX + s
			if self.parent.cursorX > #lines[self.parent.cursorY] + 1 or s == 0 then
				if not lines[self.parent.cursorY+1] then
					return
				end
				self.parent.cursorY = cursorY + 1
				self.parent.cursorX = 1
			end
	
			Highlight(self)
		elseif key == "UP" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			if self.parent.cursorY == 1 then
				return
			end
			self.parent.cursorY = self.parent.cursorY - 1
	
			local s = lines[self.parent.cursorY]
			local pos = 1
			local last = 0
			local last_len = 0
			local bytes = s:len()
		
			while pos <= bytes and pos < self.parent.cursorX do
				last = utf8charbytes(s, pos)
				pos = pos + last
			end
			self.parent.cursorX = pos
			self.parent.cursorX = math.min(self.parent.cursorX,#lines[self.parent.cursorY]+1)
	
			Highlight(self)
		elseif key == "DOWN" then
			local lines, cursorX, cursorY = self.parent.Lines, self.parent.cursorX, self.parent.cursorY
			if self.parent.cursorY == #lines then
				return
			end
			self.parent.cursorY = self.parent.cursorY + 1
	
			local s = lines[self.parent.cursorY]
			local pos = 1
			local last = 0
			local last_len = 0
			local bytes = s:len()
		
			while pos <= bytes and pos < self.parent.cursorX do
				last = utf8charbytes(s, pos)
				pos = pos + last
			end
			self.parent.cursorX = pos
			self.parent.cursorX = math.min(self.parent.cursorX,#lines[self.parent.cursorY]+1)
	
			Highlight(self)
		elseif key == "LCTRL" then
			if self.copyPaste then
				self.ctrl = true
				self:SetText(self.copyPaste)
				self:HighlightText()
			end
		end
	end
	  
	
	local function OnKeyUp(self,key)
		if key == "LCTRL" then
			self.ctrl = nil
			self:SetText("")
		end
	end
	
	local function MouseToCursor(self)
		local x,y = GetCursorPosition()
		local s = self:GetEffectiveScale()
		x, y = x/s, y/s
	
		local parent = self:GetParent()
	
		local hPosX,hPosY
		for i=1,#parent.TextLines do
			local line = parent.TextLines[i]
			local pos,hover = line:FindCharacterIndexAtCoordinate(x,y)
			if hover then
				if line:GetText() == " " then
					pos = 1
				end
				return pos, i
			end
		end
	end
	
	local function OnMouseDown(self,button,...)
		self.OldOnMouseDown(self,button,...)
	
		local parent = self:GetParent()
		if parent.EditBox.LastFocus > GetTime() then
			return
		end
	
		local x,y = MouseToCursor(self)
	
		if x and not IsShiftKeyDown() then
			parent.cursorY,parent.cursorX = y,x
			parent.EditBox.blink = 0
			Highlight(parent.EditBox)
			self.isHighlight = true
			self.highlightStartX = x
			self.highlightStartY = y
		elseif IsShiftKeyDown() and self.highlightStartX then
			parent.cursorY,parent.cursorX = y,x
			self.isHighlight = true
		end
	end
	local function OnMouseUp(self,button)
		if self.isHighlight then
			self.isHighlight = nil
			local x,y = MouseToCursor(self)
	
			if x then
				local parent = self:GetParent()
				parent.cursorY,parent.cursorX = y,x
				parent.EditBox.blink = 0
	
				if x ~= self.highlightStartX or y ~= self.highlightStartY then
					Highlight(parent.EditBox,self.highlightStartX,self.highlightStartY,x,y)
				else
					Highlight(parent.EditBox)
				end
			end
		end
	end
	local function OnEditFocusGained(self)
		self.IsFocus = true
		self.blink = 0
		--self.LastFocus = GetTime() + 0.1
	end
	local function OnEditFocusLost(self)
		self.IsFocus = false
	end
	local function EditBoxOnUpdate(self,elapsed)
		if not self.IsFocus then
			self.Cursor:SetAlpha(0)
			return
		end
		self.blink = self.blink + elapsed
		if self.blink > 1 then
			self.blink = self.blink % 1
		end
		self.Cursor:SetAlpha(self.blink >= 0.5 and 0 or 1)
		local parent = self.parent
		if parent.cursorX ~= self.prevX or parent.cursorY ~= self.prevY then
			local line = self.TextLines[parent.cursorY]
			if line then
				local l,t = line:GetLeft(),line:GetTop()
				local h = math.ceil(math.floor(line:GetHeight()+0.5)/12)
				local BREAK
				for i=0,line:GetWidth() do
					for j=1,h do
						local x = line:FindCharacterIndexAtCoordinate(l+i,t-(j-1)*12-2)
						if x == parent.cursorX then
							self.Cursor:ClearAllPoints()
							self.Cursor:SetPoint("TOPLEFT",line,i,-(j-1)*12)
							self.prevX = parent.cursorX
							self.prevY = parent.cursorY
							self.blink = 0
							BREAK = true
							self.parent:UpdateScroll()
							if self.parent.OnCursorChanged then
								self.parent:OnCursorChanged(self.Cursor, parent.cursorX, parent.cursorY)
							end
							parent.posText:SetText(parent.cursorY..":"..parent.cursorX)
							break
						end
					end
					if BREAK then
						break
					end
				end
			end
		end
		parent = self:GetParent()
		if parent.isHighlight then
			self.isHighlight = nil
			local x,y = MouseToCursor(parent)

			if x then
				if x ~= parent.highlightStartX or y ~= parent.highlightStartY then
					Highlight(self,parent.highlightStartX,parent.highlightStartY,x,y)
				else
					Highlight(self)
				end
			end
		end
	end
	
	local function Widget_SetSize(self,width,height)
		self.width = width
		self.height = height
		self._Size(self,width,height)
		for i=1,#self.TextLines do
			self.TextLines[i]:SetWidth(width-24)
			self.TextLines[i].coloredLine:SetWidth(width-24)
		end
		self:UpdateText()
		return self
	end
	
	local function Widget_GetText(self)
		return table.concat(self.Lines,"\n")
	end
	local function Widget_SetText(self,text)
		self.Lines = {strsplit("\n",text)}
		self:UpdateText()
	end
	local function Widget_OnChange(self,func)
		self.OnChangeFunc = func

		return self
	end
	local function Widget_OnCursorChanged(self,func)
		self.OnCursorChanged = func

		return self
	end
	local function Widget_Highlight(self)
		Highlight(self.EditBox,1,1,#self.Lines[#self.Lines],#self.Lines)
	end

	local function Widget_GetCursorPosition(self)
		local lines, cursorX, cursorY = self.Lines, self.cursorX, self.cursorY
		local pos = 0
		for i=1,cursorY-1 do
			pos = pos + #lines[i] + 1
		end
		pos = pos + cursorX

		return pos
	end
	local function Widget_SetCursorPosition(self,x,y,scrollFromBottom)
		self.cursorX, self.cursorY = x,y
		if scrollFromBottom then
			self.ScrollBar:SetValue(select(2,self.ScrollBar:GetMinMaxValues()))
		end
		self:UpdateScroll()
	end
	local function Widget_SetFocus(self)
		self.EditBox:SetFocus()
	end
	local function Widget_Insert(self,text)
		self.EditBox:Insert(text)
	end
		
	
	function ELib:MultiEdit3(parent)
		local self = ELib:MultiEdit(parent)
		self.cursorY = 1
		self.cursorX = 1
	
		self.TextLines = {}
		self.EditBox.TextLines = self.TextLines
		
		self.Lines = {""}
	
		self.UpdateScroll = UpdateScroll
		self.UpdateText = UpdateText

		self.posText = self:CreateFontString(nil,"ARTWORK","GameFontWhite")
		self.posText:SetJustifyH("RIGHT")
		self.posText:SetJustifyV("BOTTOM")
		self.posText:SetPoint("BOTTOMRIGHT",-22,2)
		self.posText:SetFont(self.posText:GetFont(),8)
		self.posText:SetAlpha(0)
	
		self.EditBox.parent = self
		self.EditBox:SetAlpha(0)
		self.EditBox:EnableMouse(false)
		
		self.EditBox:SetScript("OnCursorChanged",nil)
		self.EditBox:SetScript("OnTextChanged",OnTextChanged)
	
		self.EditBox:SetScript("OnKeyDown",OnKeyDown)
		self.EditBox:SetScript("OnKeyUp",OnKeyUp)
	
		self.C.OldOnMouseDown = self.C:GetScript("OnMouseDown")
		self.C:SetScript("OnMouseDown",OnMouseDown)
		self.C:SetScript("OnMouseUp",OnMouseUp)
		
		self.EditBox.Cursor = self.C:CreateTexture(nil,"BACKGROUND")
		self.EditBox.Cursor:SetSize(2,12)
		self.EditBox.Cursor:SetColorTexture(1,1,1)
		self.EditBox.Cursor:SetPoint("TOPLEFT",self.EditBox,2,-2)
		
		self.EditBox:SetScript("OnEditFocusGained",OnEditFocusGained)
		self.EditBox:SetScript("OnEditFocusLost",OnEditFocusLost)
		
		self.EditBox.blink = 0
		self.EditBox.LastFocus = 0
		
		self.EditBox:SetScript("OnUpdate",EditBoxOnUpdate)
	
		self._Size = self.Size
		self.Size = Widget_SetSize
	
		self.SetText = Widget_SetText
		self.GetText = Widget_GetText
		self.OnChange = Widget_OnChange
		self.OnCursorChanged = Widget_OnCursorChanged
		self.Highlight = Widget_Highlight
		self.GetHighlight = GetHighlight
		self.SetFocus = Widget_SetFocus
		self.Insert = Widget_Insert

		self.GetCursorPosition = Widget_GetCursorPosition
		self.SetCursorPosition = Widget_SetCursorPosition

		self.SetSyntax = Widget_SetSyntax
	
		self:UpdateText()
		return self
	end
end

function ELib:FixPreloadFont(parent,fontObj,font,size,params)
	local frame = CreateFrame("Frame",nil,parent)
	frame:SetPoint("TOPLEFT")
	frame:SetSize(1,1)

	frame:SetScript("OnUpdate",function(self,elapsed)
		if elapsed > .3 then
			return
		end
		if type(fontObj) == "function" then
			if fontObj(parent) then
				self:SetScript("OnUpdate",nil)
				self:Hide()
			end
		else
			fontObj:SetFont(GameFontWhite:GetFont(), size - 1)
			fontObj:SetFont(font, size, params)
			self:SetScript("OnUpdate",nil)
			self:Hide()
		end
	end)
end


do
	local function Widget_Size(self,width,height)
		self.axisX:SetWidth(width-10)
		self.axisY:SetHeight(height-20+2)

		self:SetSize(width,height)

		self.width = width-10
		self.height = height-20

		return self
	end
	local function Widget_Update(self)
		local maxX = #self.data
		local maxY = 0
		for i=1,maxX do
			for j=1,#self.data[i] do
				if type(self.data[i][j]) == 'table' then
					local sum = 0
					for k=1,#self.data[i][j] do
						sum = sum + self.data[i][j][k]
					end
					maxY = max(maxY,sum)
				else
					maxY = max(maxY,self.data[i][j])
				end
			end
		end
		local col_media_count = 0
		local textX_media_count = 0
		local textX_skip = 0
		local per_col = self.width / max(maxX,1)
		for i=1,maxX do
			local d = self.data[i]

			local width = per_col * 0.8
			local sub_width = width / #d

			for j=1,#d do
				local sub_d = d[j]
				local is_sub_d
				if type(sub_d) == 'table' then
					sub_d = sub_d[1]
					is_sub_d = true
				end
				col_media_count = col_media_count + 1
				local media = self.media.cols[col_media_count]
				if not media then
					media = self:CreateTexture()
					self.media.cols[col_media_count] = media
				end

				local height, heightFix = sub_d/maxY*self.height, 0
				if height < 1 then
					height = 1
					heightFix = -1
					media:SetAlpha(0)
					media.skip = true
				else
					media:SetAlpha(1)
					media.skip = false
				end
				media:ClearAllPoints()
				media:SetPoint("BOTTOMLEFT",self.axisX,"TOPLEFT",per_col*(i-1)+per_col*0.1+(j-1)*sub_width,heightFix)
				media:SetSize(sub_width,height)
				local color = self.data["c"..j] or self.data["c"..j.."_"..1] or self.media.colors[j]
				media:SetColorTexture(unpack(color))
				media:Show()

				media.dataX = d.x or i
				media.dataY = sub_d
				media.dataT = self.data["t"..j] or self.data["t"..j.."_"..1]

				if is_sub_d then
					sub_d = d[j]
					local prev = media
					for k=2,#sub_d do
						col_media_count = col_media_count + 1
						local media = self.media.cols[col_media_count]
						if not media then
							media = self:CreateTexture()
							self.media.cols[col_media_count] = media
						end
		
						local height, heightFix = sub_d[k]/maxY*self.height, 0
						if height < 1 then
							height = 1
							heightFix = -1
							media:SetAlpha(0)
							media.skip = true
						else
							media:SetAlpha(1)
							media.skip = false
						end
						media:ClearAllPoints()
						media:SetPoint("BOTTOM",prev,"TOP",0,heightFix)
						media:SetSize(sub_width,height)
						local color = self.data["c"..j.."_"..k] or self.media.colors[#self.media.colors - k + 2]
						media:SetColorTexture(unpack(color))
						media:Show()

						media.dataX = d.x or i
						media.dataY = sub_d[k]
						media.dataT = self.data["t"..j.."_"..k]
					end
				end
			end

			if textX_skip <= 0 then
				textX_media_count = textX_media_count + 1
				local media = self.media.textX[textX_media_count]
				if not media then
					media = self:CreateFontString(nil,"ARTWORK","GameFontWhite")
					self.media.textX[textX_media_count] = media
				end
	
				media:SetPoint("TOP",self.axisX,"BOTTOMLEFT",(i-1)*per_col + per_col/2,-2)
				local textX = self.TextX and self:TextX(i,d) or i 
				media:SetText(textX)
				media:Show()

				local text_width = media:GetStringWidth()
				if (text_width + 5) > per_col then
					textX_skip = floor((text_width + 5) / per_col)
				end
			else
				textX_skip = textX_skip - 1
			end
		end
		for i=col_media_count+1,#self.media.cols do
			self.media.cols[i]:Hide()
		end
		for i=textX_media_count+1,#self.media.textX do
			self.media.textX[i]:Hide()
		end

		return self
	end
	local function Widget_OnUpdate(self)
		local tip, c
		for i=1,#self.media.cols do
			c = self.media.cols[i]
			if not c:IsShown() then
				break
			end
			if c:IsMouseOver() then
				if not c.skip then
					tip = c
				end
				break
			end
		end
		if tip then
			if self.tip_IsShown ~= tip then
				GameTooltip:SetOwner(tip,"ANCHOR_RIGHT")
				local text = self.TooltipText and self:TooltipText(tip) or tip.dataY
				GameTooltip:SetText(text)
				GameTooltip:Show()
				self.tip_IsShown = tip
			end
		elseif self.tip_IsShown then
			GameTooltip_Hide()
			self.tip_IsShown = nil
		end
	end
	function ELib:GraphCol(parent)
		local self = CreateFrame("Frame",nil,parent)
		
		self.axisX = self:CreateTexture(nil, "BACKGROUND")
		self.axisX:SetHeight(2)
		self.axisX:SetPoint("TOPLEFT",self,"BOTTOMLEFT",10,20)
		self.axisX:SetColorTexture(0.6, 0.6, 1, 1)
		
		self.axisY = self:CreateTexture(nil, "BACKGROUND")
		self.axisY:SetWidth(2)
		self.axisY:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",10,20-2)
		self.axisY:SetColorTexture(0.6, 0.6, 1, 1)
		
		self.data = {}
		self.media = {
			cols = {},
			textX = {},
			colors = {
				{.8,0,0},
				{0,.8,0},
				{.8,.8,0},
				{0,0,.8},
				{0,.8,.8},
				{.8,0,.8},
			}
		}

		Mod(self)
		self.Size = Widget_Size
		self.Update = Widget_Update

		self:SetScript("OnUpdate",Widget_OnUpdate)
			
		return self
	end
end
