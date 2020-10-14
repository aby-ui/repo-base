local GlobalAddonName, WQLdb = ...

local ELib = {}

WQLdb.ELib = ELib

ELib.Templates = {}

function ELib.Templates:Border(self,cR,cG,cB,cA,size,offsetX,offsetY)
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
	
	self.BorderColor = {cR,cG,cB,cA}
end
function ELib:Shadow(parent,size,edgeSize)
	local self = CreateFrame("Frame",nil,parent,"BackdropTemplate")
	self:SetPoint("LEFT",-size,0)
	self:SetPoint("RIGHT",size,0)
	self:SetPoint("TOP",0,size)
	self:SetPoint("BOTTOM",0,-size)
	self:SetBackdrop({edgeFile="Interface/AddOns/WorldQuestsList/shadow",edgeSize=edgeSize or 28,insets={left=size,right=size,top=size,bottom=size}})
	self:SetBackdropBorderColor(0,0,0,.45)

	return self
end

function ELib:Shadow2(self,size,offsetX,offsetY,isBold)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	isBold = true

	self.ShadowTop = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowTop:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowTop:SetPoint("TOPLEFT",10,size+offsetY)
	self.ShadowTop:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",-10,offsetY)
	self.ShadowTop:SetVertexColor(0,0,0,.45)
	self.ShadowTop:SetTexCoord((128+31)/256,(128+32)/256,0,22/32)
	
	self.ShadowTopLeftInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowTopLeftInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowTopLeftInside:SetPoint("TOPLEFT",-offsetX,size+offsetY)
	self.ShadowTopLeftInside:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",-offsetX+10,offsetY)
	self.ShadowTopLeftInside:SetVertexColor(0,0,0,.45)
	self.ShadowTopLeftInside:SetTexCoord((128+22)/256,(128+32)/256,0,22/32)	
	
	self.ShadowTopLeft = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowTopLeft:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowTopLeft:SetPoint("TOPLEFT",-offsetX-size,size+offsetY)
	self.ShadowTopLeft:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",-offsetX,offsetY)
	self.ShadowTopLeft:SetVertexColor(0,0,0,.45)
	self.ShadowTopLeft:SetTexCoord((128+0)/256,(128+22)/256,0,22/32)	

	self.ShadowTopRightInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowTopRightInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowTopRightInside:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX-10,size+offsetY)
	self.ShadowTopRightInside:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",offsetX,offsetY)
	self.ShadowTopRightInside:SetVertexColor(0,0,0,.45)
	self.ShadowTopRightInside:SetTexCoord((128+32)/256,(128+22)/256,0,22/32)	

	self.ShadowTopRight = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowTopRight:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowTopRight:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX,size+offsetY)
	self.ShadowTopRight:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",offsetX+size,offsetY)
	self.ShadowTopRight:SetVertexColor(0,0,0,.45)
	self.ShadowTopRight:SetTexCoord((128+22)/256,(128+0)/256,0,22/32)
	
	self.ShadowLeftTopInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowLeftTopInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowLeftTopInside:SetPoint("TOPLEFT",-offsetX-size,offsetY)
	self.ShadowLeftTopInside:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",-offsetX,offsetY-10)
	self.ShadowLeftTopInside:SetVertexColor(0,0,0,.45)
	self.ShadowLeftTopInside:SetTexCoord((128+0)/256,(128+22)/256,22/32,32/32)
	
	self.ShadowLeft = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowLeft:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowLeft:SetPoint("TOPLEFT",-offsetX-size,offsetY-10)
	self.ShadowLeft:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY+10)
	self.ShadowLeft:SetVertexColor(0,0,0,.45)
	self.ShadowLeft:SetTexCoord((128+0)/256,(128+22)/256,31/32,32/32)		
		
	self.ShadowLeftBottomInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowLeftBottomInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowLeftBottomInside:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX-size,-offsetY+10)
	self.ShadowLeftBottomInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY)
	self.ShadowLeftBottomInside:SetVertexColor(0,0,0,.45)
	self.ShadowLeftBottomInside:SetTexCoord((128+0)/256,(128+22)/256,32/32,22/32)
	
	self.ShadowLeftBottom = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowLeftBottom:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowLeftBottom:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX-size,-offsetY)
	self.ShadowLeftBottom:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX,-offsetY-size)
	self.ShadowLeftBottom:SetVertexColor(0,0,0,.45)
	self.ShadowLeftBottom:SetTexCoord((128+0)/256,(128+22)/256,22/32,0)

	self.ShadowBottomLeftInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowBottomLeftInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowBottomLeftInside:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX,-offsetY)
	self.ShadowBottomLeftInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",-offsetX+10,-offsetY-size)
	self.ShadowBottomLeftInside:SetVertexColor(0,0,0,.45)
	self.ShadowBottomLeftInside:SetTexCoord((128+22)/256,(128+32)/256,22/32,0)

	self.ShadowBottom = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowBottom:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowBottom:SetPoint("TOPLEFT",self,"BOTTOMLEFT",-offsetX+10,-offsetY)
	self.ShadowBottom:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX-10,-offsetY-size)
	self.ShadowBottom:SetVertexColor(0,0,0,.45)
	self.ShadowBottom:SetTexCoord((128+31)/256,(128+32)/256,22/32,0)	

	self.ShadowBottomRightInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowBottomRightInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowBottomRightInside:SetPoint("TOPLEFT",self,"BOTTOMRIGHT",offsetX-10,-offsetY)
	self.ShadowBottomRightInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX,-offsetY-size)
	self.ShadowBottomRightInside:SetVertexColor(0,0,0,.45)
	self.ShadowBottomRightInside:SetTexCoord((128+32)/256,(128+22)/256,22/32,0)
	
	self.ShadowBottomRight = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowBottomRight:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowBottomRight:SetPoint("TOPLEFT",self,"BOTTOMRIGHT",offsetX,-offsetY)
	self.ShadowBottomRight:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX+size,-offsetY-size)
	self.ShadowBottomRight:SetVertexColor(0,0,0,.45)
	self.ShadowBottomRight:SetTexCoord((128+22)/256,(128+0)/256,22/32,0)
	
	self.ShadowRightBottomInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowRightBottomInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowRightBottomInside:SetPoint("TOPLEFT",self,"BOTTOMRIGHT",offsetX,-offsetY+10)
	self.ShadowRightBottomInside:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX+size,-offsetY)
	self.ShadowRightBottomInside:SetVertexColor(0,0,0,.45)
	self.ShadowRightBottomInside:SetTexCoord((128+22)/256,(128+0)/256,32/32,22/32)
	
	self.ShadowRight = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowRight:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
	self.ShadowRight:SetPoint("TOPLEFT",self,"TOPRIGHT",offsetX,offsetY-10)
	self.ShadowRight:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",offsetX+size,-offsetY+10)
	self.ShadowRight:SetVertexColor(0,0,0,.45)
	self.ShadowRight:SetTexCoord((128+22)/256,(128+0)/256,31/32,32/32)
	
	self.ShadowRightTopInside = self:CreateTexture(nil,"BACKGROUND")
	self.ShadowRightTopInside:SetTexture("Interface/AddOns/WorldQuestsList/shadow")
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

do
	local function MakeSolidButton(self)
		self.Button:ClearAllPoints()
		self.Button:SetAllPoints()
		self.Button.i:Hide()
		self.l:Hide()
	end
	function ELib:DropDown(parent,text)
		local self = CreateFrame("Frame", nil, parent)
		self:SetHeight(22)
		
		self.b = self:CreateTexture(nil,"BACKGROUND",nil,1)
		self.b:SetAllPoints()
		self.b:SetColorTexture(0.04,0.04,0.14,.97)
		
		self.t = self:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.t:SetPoint("LEFT",8,0)
		self.t:SetText(text)
		
		self.l = self:CreateTexture(nil,"BACKGROUND",nil,2)
		self.l:SetColorTexture(.22,.22,.3,1)
		self.l:SetPoint("TOPLEFT",self,"TOPRIGHT",-23,0)
		self.l:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-22,0)
		
		ELib.Templates:Border(self,.22,.22,.3,1,1)
		self.shadow = ELib:Shadow2(self,16)
		
		self.ShadowLeftBottom:Hide()
		self.ShadowBottom:Hide()
		self.ShadowBottomLeftInside:Hide()
		self.ShadowBottomRightInside:Hide()
		self.ShadowBottomRight:Hide()
		
		self.Button = CreateFrame("Button", nil, self)
		self.Button:SetSize(22,22)
		self.Button:SetPoint("RIGHT")
		
		self.Button.i = self.Button:CreateTexture(nil,"ARTWORK")
		self.Button.i:SetTexture("Interface\\AddOns\\WorldQuestsList\\navButtons")
		self.Button.i:SetPoint("CENTER")
		self.Button.i:SetTexCoord(0,.25,0,1)
		self.Button.i:SetSize(22,22)
		
		self.Button.hl = self.Button:CreateTexture(nil, "BACKGROUND")
		self.Button.hl:SetPoint("TOPLEFT", 0, 0)
		self.Button.hl:SetPoint("BOTTOMRIGHT", 0, 0)
		self.Button.hl:SetTexture("Interface\\Buttons\\WHITE8X8")
		self.Button.hl:SetVertexColor(.7,.7,1,.25)
		self.Button.hl:Hide()
		
		self.Button:SetScript("OnEnter",function(self) self.hl:Show() end)
		self.Button:SetScript("OnLeave",function(self) self.hl:Hide() end)
		self:SetScript("OnHide",function (self) ELib.ScrollDropDown.AutoClose(self.Button) end)
		self.Button:SetScript("OnClick",function(self) ELib.ScrollDropDown.ClickButton(self) end)
		
		self.Button.isButton = true

		self.MakeSolidButton = MakeSolidButton
	
		return self
	end
end	

function ELib:CreateBorder(parent,sZ)
	local top = parent["border_top"] or parent:CreateTexture(nil, "BORDER")
	local bottom = parent["border_bottom"] or parent:CreateTexture(nil, "BORDER")
	local left = parent["border_left"] or parent:CreateTexture(nil, "BORDER")
	local right = parent["border_right"] or parent:CreateTexture(nil, "BORDER")
	
	parent["border_top"] = top
	parent["border_bottom"] = bottom
	parent["border_left"] = left
	parent["border_right"] = right
	
	local size,outside = sZ or 1,-1
	
	top:SetPoint("TOPLEFT",parent,"TOPLEFT",-size-outside,size+outside)
	top:SetPoint("BOTTOMRIGHT",parent,"TOPRIGHT",size+outside,outside)

	bottom:SetPoint("BOTTOMLEFT",parent,"BOTTOMLEFT",-size-outside,-size-outside)
	bottom:SetPoint("TOPRIGHT",parent,"BOTTOMRIGHT",size+outside,-outside)

	left:SetPoint("TOPLEFT",parent,"TOPLEFT",-size-outside,outside)
	left:SetPoint("BOTTOMRIGHT",parent,"BOTTOMLEFT",-outside,-outside)

	right:SetPoint("TOPLEFT",parent,"TOPRIGHT",outside,outside)
	right:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT",size+outside,-outside)

	parent.SetBorderColor = function(self,colorR,colorG,colorB,colorA)
		top:SetColorTexture(colorR,colorG,colorB,colorA)
		bottom:SetColorTexture(colorR,colorG,colorB,colorA)
		left:SetColorTexture(colorR,colorG,colorB,colorA)
		right:SetColorTexture(colorR,colorG,colorB,colorA)
	end
	

	top:Show()
	bottom:Show()
	left:Show()
	right:Show()
end



do
	local Templates = ELib.Templates
	function ELib:Template(name,parent)
		if not Templates[name] then
			return
		end
		local obj = Templates[name](nil,parent)
		--obj:SetParent(parent or UIParent)
		return obj
	end
	do
		local function OnEnter(self, motion)
			--UIDropDownMenu_StopCounting(self, motion)
		end
		local function OnLeave(self, motion)
			--UIDropDownMenu_StartCounting(self, motion)
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
			--UIDropDownMenu_StopCounting(self)
		end
		local function OnUpdate(self, elapsed)
			ELib.ScrollDropDown.Update(self, elapsed)
		end
		function Templates:ExRTDropDownListTemplate(parent)
			local self = CreateFrame("Button",nil,parent)
			self:SetFrameStrata("TOOLTIP")
			self:EnableMouse(true)
			self:Hide()
			
			self.Backdrop = CreateFrame("Frame",nil,self,"BackdropTemplate")
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
	do
		local function OnEnter(self)
			self.Highlight:Show()
			--UIDropDownMenu_StopCounting(self:GetParent())
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
			--UIDropDownMenu_StartCounting(self:GetParent())
			GameTooltip:Hide()
			ELib.ScrollDropDown.OnButtonLeave(self)
		end
		local function OnClick(self, button, down)
			ELib.ScrollDropDown.OnClick(self, button, down)
		end
		local function OnLoad(self)
			self:SetFrameLevel(self:GetParent():GetFrameLevel()+2)
		end
		local function OnSliderChanged(self,val)
			self.text:SetFormattedText("%d%s",val,self:GetParent().sliderAfterText or "")
			if self:GetParent().sliderFunc then
				self:GetParent().sliderFunc(self,val)
			end
		end
		local function OnSliderShow(self)
			if self:GetParent().sliderShow then
				self:GetParent().sliderShow(self)
			end
		end
		local function SliderOnMouseWheel(self,delta)
			self:SetValue(self:GetValue()+delta)
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
			
			
			self.slider = CreateFrame("Slider", nil, self)
			self.slider:Hide()
			self.slider:SetPoint("TOPLEFT",2,-2)
			self.slider:SetPoint("BOTTOMRIGHT",-2,2)
			ELib.Templates:Border(self.slider,.22,.22,.3,1,1,2)
			
			self.slider.thumb = self.slider:CreateTexture(nil, "ARTWORK")
			self.slider.thumb:SetColorTexture(.32,.32,.4,1)
			self.slider.thumb:SetSize(28,10)
			
			self.slider:SetThumbTexture(self.slider.thumb)
			self.slider:SetOrientation("HORIZONTAL")
			self.slider:SetMinMaxValues(1,2)
			self.slider:SetValue(1)
			self.slider:SetValueStep(1)
			self.slider:SetObeyStepOnDrag(true)
			
			self.slider.text = self.slider:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
			self.slider.text:SetPoint("CENTER",0,0)

			
			self:SetScript("OnEnter",OnEnter)
			self:SetScript("OnLeave",OnLeave)
			self:SetScript("OnClick",OnClick)
			self:SetScript("OnLoad",OnLoad)
			
			self.slider:SetScript("OnValueChanged",OnSliderChanged)
			self.slider:SetScript("OnMouseWheel", SliderOnMouseWheel)
			self.slider:SetScript("OnShow",OnSliderShow)
			
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
	function Templates:ExRTRadioButtonModernTemplate(parent)
		local self = CreateFrame("CheckButton",nil,parent)
		self:SetSize(16,16)
		
		self.text = self:CreateFontString(nil,"BACKGROUND","GameFontNormalSmall")
		self.text:SetPoint("LEFT",self,"RIGHT",5,0)
		
		self:SetFontString(self.text)
		
		self.NormalTexture = self:CreateTexture()
		self.NormalTexture:SetTexture("Interface\\Addons\\WorldQuestsList\\radioModern")
		self.NormalTexture:SetAllPoints()
		self.NormalTexture:SetTexCoord(0,0.25,0,1)
		self:SetNormalTexture(self.PushedTexture)
	
		self.HighlightTexture = self:CreateTexture()
		self.HighlightTexture:SetTexture("Interface\\Addons\\WorldQuestsList\\radioModern")
		self.HighlightTexture:SetAllPoints()
		self.HighlightTexture:SetTexCoord(0.5,0.75,0,1)
		self:SetHighlightTexture(self.HighlightTexture)
		
		self.CheckedTexture = self:CreateTexture()
		self.CheckedTexture:SetTexture("Interface\\Addons\\WorldQuestsList\\radioModern")
		self.CheckedTexture:SetAllPoints()
		self.CheckedTexture:SetTexCoord(0.25,0.5,0,1)
		self:SetCheckedTexture(self.CheckedTexture)
				
		return self
	end
	
	
	ELib.ScrollDropDown = {}
	ELib.ScrollDropDown.List = {}
	local ScrollDropDown_Modern = {}
	
	for i=1,2 do
		ScrollDropDown_Modern[i] = ELib:Template("ExRTDropDownListModernTemplate",UIParent)
		_G["WQL_ExRTDropDownListModern"..i] = ScrollDropDown_Modern[i]
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
	end
		
	ELib.ScrollDropDown.DropDownList = ScrollDropDown_Modern
	
	do
		local function CheckButtonClick(self)
			local parent = self:GetParent()
			self:GetParent():GetParent().List[parent.id].checkState = self:GetChecked()
			if parent.checkFunc then
				parent.checkFunc(parent,self:GetChecked())
			end
		end
		local function CheckButtonOnEnter(self)
			--UIDropDownMenu_StopCounting(self:GetParent():GetParent())
		end
		local function CheckButtonOnLeave(self)
			--UIDropDownMenu_StartCounting(self:GetParent():GetParent())
		end
		function ELib.ScrollDropDown.CreateButton(i,level)
			level = level or 1
			local dropDown = ELib.ScrollDropDown.DropDownList[level]
			local button = dropDown.Buttons[i]
			if button then
				return
			end
			button = ELib:Template("ExRTDropDownMenuButtonTemplate",dropDown)
			dropDown.Buttons[i] = button
			button:SetPoint("TOPLEFT",8,-8 - (i-1) * 16)
			button.NormalText:SetMaxLines(1) 
			
			button.checkButton = ELib:Template("ExRTCheckButtonModernTemplate",button)
			button.checkButton:SetPoint("LEFT",1,0)
			button.checkButton:SetSize(12,12)
			
			button.radioButton = ELib:Template("ExRTRadioButtonModernTemplate",button)
			button.radioButton:SetPoint("LEFT",1,0)
			button.radioButton:SetSize(12,12)
			button.radioButton:EnableMouse(false)

			button.checkButton:SetScript("OnClick",CheckButtonClick)
			button.checkButton:SetScript("OnEnter",CheckButtonOnEnter)
			button.checkButton:SetScript("OnLeave",CheckButtonOnLeave)
			button.checkButton:Hide()
			button.radioButton:Hide()
			
			button.Level = level
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
		ELib.ScrollDropDown.DropDownList[1]:SetFrameStrata("TOOLTIP")
		ELib.ScrollDropDown.DropDownList[2]:SetFrameStrata("TOOLTIP")
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
					
					if not data.isHidden and (not data.shownFunc or data.shownFunc(data)) then
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
						
						button:SetNormalFontObject(GameFontHighlightSmallLeft)
						button:SetHighlightFontObject(GameFontHighlightSmallLeft)
						
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
						
						text:SetWordWrap(false)
						
						if data.slider then	-- {func = onChangedFunc, val = currVal, min = currMin, max = currMax}
							button.slider:SetMinMaxValues(data.slider.min,data.slider.max)
							button.sliderAfterText = data.slider.afterText
							button.sliderFunc = nil
							button.slider:SetValue(data.slider.val)
							button.sliderFunc = data.slider.func
							button.sliderShow = data.slider.show
							button.slider:Show()
						else
							button.sliderFunc = nil
							button.slider:Hide()
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
				if now < ELib.ScrollDropDown.DropDownList[j].MaxLines then
					ELib.ScrollDropDown.DropDownList[j]:SetHeight(16 + 16*now)
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
			ELib.ScrollDropDown.DropDownList = ScrollDropDown_Modern
		end
		for i=level+1,#ELib.ScrollDropDown.DropDownList do
			ELib.ScrollDropDown.DropDownList[i]:Hide()
		end
		local dropDown = ELib.ScrollDropDown.DropDownList[level]
	
		local dropDownWidth = self.Width
		if level > 1 then
			local parent = ELib.ScrollDropDown.DropDownList[1].parent
			dropDownWidth = parent.Width
		end
	
	
		dropDown.List = self.subMenu or self.List
		
		local count = #dropDown.List
		
		local maxLinesNow = self.Lines or count
		
		for i=(dropDown.MaxLines+1),maxLinesNow do
			ELib.ScrollDropDown.CreateButton(i,level)
		end
		dropDown.MaxLines = max(dropDown.MaxLines,maxLinesNow)
		
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 16,16)
		end
		dropDown.Position = 1
		dropDown.LinesNow = maxLinesNow
		if self.additionalToggle then
			self.additionalToggle(self)
		end
		dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",-16,0)
		dropDown:SetSize(dropDownWidth,16 + 16 * maxLinesNow)
		dropDown:ClearAllPoints()
		if level > 1 then
			if GetScreenWidth() - self:GetRight() < dropDownWidth then
				dropDown:SetPoint("TOPRIGHT",self,"TOPLEFT",-10,8)
			else
				dropDown:SetPoint("TOPLEFT",self,"TOPRIGHT",12,8)
			end
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
	
	function ELib.ScrollDropDown.AutoClose(self)
		if self and ELib.ScrollDropDown.DropDownList[1]:IsVisible() and ELib.ScrollDropDown.DropDownList[1].parent == self then
			ELib.ScrollDropDown.Close()
		end
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
	function ELib:Button(parent,text)
		local self = ELib:Template("ExRTButtonModernTemplate",parent)
		self:SetText(text)
		
		return self
	end
end