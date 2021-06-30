local GlobalAddonName, ExRT = ...

local GetTime, GetRaidTargetIndex, SetRaidTarget, UnitName, SetRaidTargetIcon = GetTime, GetRaidTargetIndex, SetRaidTarget, UnitName, SetRaidTargetIcon

local VMRT = nil

local module = ExRT:New("MarksBar",ExRT.L.marksbar)
local ELib,L = ExRT.lib,ExRT.L

module.db.perma = {}
module.db.clearnum = -1
module.db.worldMarksList = {6,4,3,7,1,2,5,8}

module.db.wm_color ={
	{ r = 4/255, g = 149/255, b = 255/255},
	{ r = 15/255, g = 155/255 , b = 12/255},
	{ r = 168/255, g = 14/255, b = 192/255},
	{ r = 167/255, g = 20/255 , b = 13/255},
	{ r = 222/255, g = 218/255, b = 50/255},
	{ r = 208/255, g = 84/255, b = 0/255},
	{ r = 116/255, g = 155/255, b = 179/255},
	{ r = 243/255, g = 241/255, b = 235/255},
	{ r = 0.7, g = 0.7, b = 0.7 },
}

module.db.wm_color_hover ={
	{ r = 100/255, g = 189/255, b = 255/255},
	{ r = 15/255, g = 215/255 , b = 12/255},
	{ r = 220/255, g = 67/255, b = 241/255},
	{ r = 240/255, g = 77/255 , b = 68/255},
	{ r = 243/255, g = 242/255, b = 182/255},
	{ r = 255/255, g = 128/255, b = 43/255},
	{ r = 56/255, g = 86/255, b = 103/255},
	{ r = 191/255, g = 194/255, b = 155/255},
	{ r = 1.0, g = 1.0, b = 1.0 },
}

module.frame = CreateFrame("Frame","MRTMarksBar",UIParent, BackdropTemplateMixin and "BackdropTemplate")
local mainFrame = module.frame
mainFrame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:SetClampedToScreen(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function(self) 
	if self:IsMovable() then 
		self:StartMoving() 
	end 
end)
mainFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VMRT.MarksBar.Left = self:GetLeft()
	VMRT.MarksBar.Top = self:GetTop()
end)
mainFrame:SetBackdrop({bgFile = ExRT.F.barImg})
mainFrame:SetBackdropColor(0,0,0,0.8)
mainFrame:Hide()
module:RegisterHideOnPetBattle(mainFrame)

local function HoverCheckOnUpdate(self)
	if not self:IsMouseOver() and (not self.wmarksbuts:IsShown() or not self.wmarksbuts:IsMouseOver()) and (not self.wmarksbuts.b:IsShown() or not self.wmarksbuts.b:IsMouseOver()) then
		local alpha = (VMRT.MarksBar.ShowOnHoverAlpha or 0) * (VMRT.MarksBar.Alpha or 100)/100
		if not VMRT.MarksBar.ShowOnHoverAnimDisable then
			self:StopAnim(alpha)
		else
			self:SetAlpha(alpha)
		end
		self:SetScript("OnUpdate",nil)
	end
end

function mainFrame:OnEnter()
	if VMRT.MarksBar.ShowOnHover then
		local alpha = (VMRT.MarksBar.Alpha or 100)/100
		if not VMRT.MarksBar.ShowOnHoverAnimDisable then
			self:StartAnim(alpha)
		else
			self:SetAlpha(alpha)
		end
		self:SetScript("OnUpdate",HoverCheckOnUpdate)
	end
end
function mainFrame:OnLeave()

end

mainFrame:SetScript("OnEnter",function(self)
	self:OnEnter()
end)
mainFrame:SetScript("OnLeave",function(self)
	self:OnLeave()
end)

mainFrame.anim = mainFrame:CreateAnimationGroup()
mainFrame.anim:SetLooping("NONE")
mainFrame.anim.timer = mainFrame.anim:CreateAnimation()
mainFrame.anim.timer:SetDuration(.25)
mainFrame.anim.timer.main = mainFrame
mainFrame.anim.timer:SetScript("OnUpdate", function(self,elapsed) 
	local p = self:GetProgress()
	local cA = self.fA + (self.tA - self.fA) * p
	self.cA = cA
	self.main:SetAlpha(cA)
end)

function mainFrame:StartAnim(toAlpha)
	if self.anim:IsPlaying() then
		self.anim:Stop()
	end
	local t = self.anim.timer
	t.cA = t.cA or ((VMRT.MarksBar.ShowOnHoverAlpha or 0) * (VMRT.MarksBar.Alpha or 100)/100)
	t.fA = t.cA
	t.tA = toAlpha
	self.anim:Play()
end
function mainFrame:StopAnim(toAlpha)
	if self.anim:IsPlaying() then
		self.anim:Stop()
	end
	local t = self.anim.timer
	t.fA = t.cA
	t.tA = toAlpha
	self.anim:Play()
end

function mainFrame:CheckAlpha()
	local alpha
	if VMRT.MarksBar.ShowOnHover then
		alpha = (VMRT.MarksBar.ShowOnHoverAlpha or 0) * (VMRT.MarksBar.Alpha or 100)/100
	else
		alpha = (VMRT.MarksBar.Alpha or 100)/100
	end
	self:SetAlpha(alpha)
end


mainFrame.edge = CreateFrame("Frame",nil,mainFrame, BackdropTemplateMixin and "BackdropTemplate")
mainFrame.edge:SetPoint("TOPLEFT", 1, -1)
mainFrame.edge:SetPoint("BOTTOMRIGHT", -1, 1)
mainFrame.edge:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
mainFrame.edge:SetBackdropColor(0,0,0,0)
mainFrame.edge:SetBackdropBorderColor(0.6,0.6,0.6,1)

local function MainFrameMarkButtonOnEnter(self)
	local name = ExRT.A.Marks:GetName(self._i)
	if not (name and ExRT.A.Marks.Enabled) then
		module.frame.markbuts[self._i]:SetBackdropBorderColor(0.7,0.7,0.7,1)
	end
end
local function MainFrameMarkButtonOnLeave(self)
	local name = ExRT.A.Marks:GetName(self._i)
	if not (name and ExRT.A.Marks.Enabled) then
		module.frame.markbuts[self._i]:SetBackdropBorderColor(0.4,0.4,0.4,1)
	end
end
local function MainFrameMarkButtonOnClick(self, button)
	local i = self._i
	if button == "RightButton" then
		local name = ExRT.A.Marks:GetName(i)
		if name and ExRT.A.Marks.Enabled then
			module.frame.markbuts[i]:SetBackdropBorderColor(0.7,0.7,0.7,1)
			ExRT.A.Marks:SetName(i,nil)
			SetRaidTargetIcon(name, 0)
		else
			module.frame.markbuts[i]:SetBackdropBorderColor(0.2,0.8,0.2,1)
			if not ExRT.A.Marks.Enabled then
				ExRT.A.Marks:ClearNames()
				ExRT.A.Marks:Enable()
			end
			ExRT.A.Marks:SetName(i,UnitName("target"))
			SetRaidTargetIcon("target", i)
		end
	else
		SetRaidTargetIcon("target", i)
	end
end

mainFrame.edges = {}

local function CreateEdge(i,x)
	local self = CreateFrame("Frame",nil,module.frame)
	self:SetSize(1,1)
	self:SetPoint("TOPLEFT",x,0)
	return self
end

mainFrame.edges[1] = CreateEdge(1,4)

mainFrame.markbuts = {}
do
	local markbuts_backdrop = {bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8}
	for i=1,16 do
		local frame = CreateFrame("Frame",nil,mainFrame, BackdropTemplateMixin and "BackdropTemplate")
		mainFrame.markbuts[i] = frame
		frame:SetSize(26,26)
		frame:SetPoint("TOPLEFT", mainFrame.edges[1], (i-1)*28, -4)
		frame:SetBackdrop(markbuts_backdrop)
		frame:SetBackdropColor(0,0,0,0)
		frame:SetBackdropBorderColor(0.4,0.4,0.4,1)
	
		frame.but = CreateFrame("Button",nil,frame)
		frame.but:SetSize(20,20)
		frame.but:SetPoint("TOPLEFT",  3, -3)
		frame.but.t = frame.but:CreateTexture(nil, "BACKGROUND")
		frame.but.t:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
		SetRaidTargetIconTexture(frame.but.t,i)
		frame.but.t:SetAllPoints()
		
		frame.but._i = i
	
		frame.but:SetScript("OnEnter",MainFrameMarkButtonOnEnter)
		frame.but:SetScript("OnLeave", MainFrameMarkButtonOnLeave)
	
		frame.but:RegisterForClicks("RightButtonDown","LeftButtonDown")
		frame.but:SetScript("OnClick", MainFrameMarkButtonOnClick)
	end
end

mainFrame.edges[2] = CreateEdge(2,228)

mainFrame.start = CreateFrame("Button",nil,mainFrame, BackdropTemplateMixin and "BackdropTemplate")
mainFrame.start:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
mainFrame.start:SetBackdropColor(0,0,0,0)
mainFrame.start:SetBackdropBorderColor(0.4,0.4,0.4,1)
mainFrame.start:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
mainFrame.start:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
mainFrame.start:SetScript("OnClick", function(self)    
	module.db.clearnum = GetTime()
	for i=1,8 do
		SetRaidTarget("player", i) 
	end
end)

mainFrame.start.html = mainFrame.start:CreateFontString(nil,"ARTWORK","GameFontWhite")
mainFrame.start.html:SetFont(ExRT.F.defFont, 10)
mainFrame.start.html:SetAllPoints()
mainFrame.start.html:SetJustifyH("CENTER")
mainFrame.start.html:SetText(L.marksbarstart)
mainFrame.start.html:SetShadowOffset(1,-1)

ELib:FixPreloadFont(mainFrame.start,mainFrame.start.html,ExRT.F.defFont, 10)

mainFrame.del = CreateFrame("Button",nil,mainFrame, BackdropTemplateMixin and "BackdropTemplate")
mainFrame.del:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
mainFrame.del:SetBackdropColor(0,0,0,0)
mainFrame.del:SetBackdropBorderColor(0.4,0.4,0.4,1)
mainFrame.del:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
mainFrame.del:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
mainFrame.del:SetScript("OnClick", function(self)    
	for i=1,8 do
		local name = ExRT.A.Marks:GetName(i)
		if name and UnitName(name) then
			SetRaidTargetIcon(name, 0)
		end
		module.frame.markbuts[i]:SetBackdropBorderColor(0.4,0.4,0.4,1)
	end
	ExRT.A.Marks:ClearNames()
	ExRT.A.Marks:Disable()
end)

mainFrame.del.html = mainFrame.del:CreateFontString(nil,"ARTWORK","GameFontWhite")
mainFrame.del.html:SetFont(ExRT.F.defFont, 10)
mainFrame.del.html:SetAllPoints()
mainFrame.del.html:SetJustifyH("CENTER")
mainFrame.del.html:SetText(L.marksbardel)
mainFrame.del.html:SetShadowOffset(1,-1)

ELib:FixPreloadFont(mainFrame.del,mainFrame.del.html,ExRT.F.defFont, 10)


mainFrame.edges[3] = CreateEdge(3,383)

mainFrame.wmarksbuts = CreateFrame("Frame",nil,mainFrame)
mainFrame.wmarksbuts:SetSize(70,26)
local function MainFrameWMOnEnter(self)
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end
local function MainFrameWMOnLeave(self)
	self:SetBackdropBorderColor(0.4,0.4,0.4,0)
end
local function MainFrameWMOnEvent(self, event, ...)
	self[event](self, event, ...)
end

mainFrame.wmarksbuts:SetScript("OnEnter",function()
	mainFrame:OnEnter()
end)
mainFrame.wmarksbuts:SetScript("OnLeave",function()
	mainFrame:OnLeave()
end)


do
	local wmarksbuts_backdrop = {bgFile = "",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6}
	for i=1,9 do
		local frame = CreateFrame("Button","MRT_MarksBar_WorldMarkers_Kind1_"..i,mainFrame.wmarksbuts,BackdropTemplateMixin and "SecureActionButtonTemplate,BackdropTemplate" or "SecureActionButtonTemplate")	--FrameStack Fix
		mainFrame.wmarksbuts[i] = frame
		frame:SetSize(14,13)
		frame:SetBackdrop(wmarksbuts_backdrop)
		frame:SetBackdropColor(0,0,0,0)
		frame:SetBackdropBorderColor(0.4,0.4,0.4,0)
		frame:SetScript("OnEnter",MainFrameWMOnEnter)	
		frame:SetScript("OnLeave",MainFrameWMOnLeave)
		
		if i < 9 then
			frame:RegisterForClicks("AnyDown")
			frame:SetAttribute("type", "macro")
			frame:SetAttribute("macrotext1", format("/wm %d", i))
			frame:SetAttribute("macrotext2", format("/cwm %d", i))
			if ExRT.locale == "ptBR" or ExRT.locale == "esES" or ExRT.locale == "esMX" or ExRT.locale == "ptPT" then
				frame:SetAttribute("macrotext1", format(SLASH_WORLD_MARKER1.." %d", i))
				frame:SetAttribute("macrotext2", format(SLASH_CLEAR_WORLD_MARKER1.." %d", i))
			end
			frame:SetScript('OnEvent', MainFrameWMOnEvent)
		else
			frame:SetScript("OnClick",  function()
				ClearRaidMarker()
			end)
		end
	
		frame.t = frame:CreateTexture(nil, "BACKGROUND")
		if i < 9 then
			frame.t:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..module.db.worldMarksList[i])
		else
			frame.t:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\flare_del")
		end
		frame.t:SetSize(10,10)
		frame.t:SetPoint("CENTER",frame, "CENTER", 0,0)
	end
end

mainFrame.wmarksbuts.b = CreateFrame("Frame",nil,mainFrame,BackdropTemplateMixin and "BackdropTemplate")
mainFrame.wmarksbuts.b:SetFrameLevel(0)
mainFrame.wmarksbuts.b:SetBackdrop({bgFile = ExRT.F.barImg})
mainFrame.wmarksbuts.b:SetBackdropColor(0,0,0,0.8)
mainFrame.wmarksbuts.b.t = CreateFrame("Frame",nil,mainFrame.wmarksbuts.b,BackdropTemplateMixin and "BackdropTemplate")
mainFrame.wmarksbuts.b.t:SetPoint("BOTTOMRIGHT", -1, 1)
mainFrame.wmarksbuts.b.t:SetPoint("TOPLEFT", 1, -1)
mainFrame.wmarksbuts.b.t:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
mainFrame.wmarksbuts.b.t:SetBackdropColor(0,0,0,0)
mainFrame.wmarksbuts.b.t:SetBackdropBorderColor(0.6,0.6,0.6,1)
local function MainFrameWMKind2OnEnter(self)
	self.t:SetVertexColor(module.db.wm_color_hover[self._i].r,module.db.wm_color_hover[self._i].g,module.db.wm_color_hover[self._i].b,1)
end
local function MainFrameWMKind2OnLeave(self)
	self.t:SetVertexColor(module.db.wm_color[self._i].r,module.db.wm_color[self._i].g,module.db.wm_color[self._i].b,1)
end

mainFrame.wmarksbuts.b:SetScript("OnEnter",function()
	mainFrame:OnEnter()
end)
mainFrame.wmarksbuts.b:SetScript("OnLeave",function()
	mainFrame:OnLeave()
end)

for i=1,9 do
	local frame = CreateFrame("Button","MRT_MarksBar_WorldMarkers_Kind2_"..i,mainFrame.wmarksbuts.b,"SecureActionButtonTemplate")	--FrameStack Fix
	mainFrame.wmarksbuts.b[i] = frame
	frame:SetSize(18,18)
	frame.t = frame:CreateTexture(nil, "BACKGROUND")
	if i == 9 then
		frame.t:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\flare_del")
	else
		frame.t:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\blip")
	end
	frame.t:SetSize(16,16)
	frame.t:SetPoint("TOPLEFT", 1, 0)
	frame.t:SetVertexColor(module.db.wm_color[i].r,module.db.wm_color[i].g,module.db.wm_color[i].b,1)
	frame._i = i
	
	frame:SetScript("OnEnter",MainFrameWMKind2OnEnter)	
	frame:SetScript("OnLeave", MainFrameWMKind2OnLeave)

	if i < 9 then
		frame:RegisterForClicks("AnyDown")
		frame:SetAttribute("type", "macro")
		frame:SetAttribute("macrotext1", format("/wm %d", i))
		frame:SetAttribute("macrotext2", format("/cwm %d", i))
		if ExRT.locale == "ptBR" or ExRT.locale == "esES" or ExRT.locale == "esMX" or ExRT.locale == "ptPT" then
			frame:SetAttribute("macrotext1", format(SLASH_WORLD_MARKER1.." %d", i))
			frame:SetAttribute("macrotext2", format(SLASH_CLEAR_WORLD_MARKER1.." %d", i))
		end
		frame:SetScript('OnEvent', MainFrameWMOnEvent)
	else
		frame:SetScript("OnClick", function()
			ClearRaidMarker()
		end)
	end
end

mainFrame.edges[4] = CreateEdge(4,325)

mainFrame.readyCheck = CreateFrame("Button",nil,mainFrame,BackdropTemplateMixin and "BackdropTemplate")
mainFrame.readyCheck:SetSize(40,12)
mainFrame.readyCheck:SetPoint("TOPLEFT",mainFrame.edges[4],0,-4)
mainFrame.readyCheck:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
mainFrame.readyCheck:SetBackdropColor(0,0,0,0)
mainFrame.readyCheck:SetBackdropBorderColor(0.4,0.4,0.4,1)
mainFrame.readyCheck:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
mainFrame.readyCheck:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
mainFrame.readyCheck:SetScript("OnClick", function(self)    
	DoReadyCheck()
end)

mainFrame.readyCheck.html = mainFrame.readyCheck:CreateFontString(nil,"ARTWORK","GameFontWhite")
mainFrame.readyCheck.html:SetFont(ExRT.F.defFont, 10)
mainFrame.readyCheck.html:SetAllPoints()
mainFrame.readyCheck.html:SetJustifyH("CENTER")
mainFrame.readyCheck.html:SetText(L.marksbarrc)
mainFrame.readyCheck.html:SetShadowOffset(1,-1)

ELib:FixPreloadFont(mainFrame.readyCheck,mainFrame.readyCheck.html,ExRT.F.defFont, 10)

mainFrame.pull = CreateFrame("Button",nil,mainFrame,BackdropTemplateMixin and "BackdropTemplate")
mainFrame.pull:SetSize(40,12)
mainFrame.pull:SetPoint("TOPLEFT",mainFrame.edges[4],0, -18)
mainFrame.pull:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
mainFrame.pull:SetBackdropColor(0,0,0,0)
mainFrame.pull:SetBackdropBorderColor(0.4,0.4,0.4,1)
mainFrame.pull:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
mainFrame.pull:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
mainFrame.pull:SetScript("OnMouseDown", function(self,button) 
	ExRT.F:DoPull(button == "RightButton" and VMRT.MarksBar.pulltimer_right or VMRT.MarksBar.pulltimer)
end)

mainFrame.pull.html = mainFrame.pull:CreateFontString(nil,"ARTWORK","GameFontWhite")
mainFrame.pull.html:SetFont(ExRT.F.defFont, 10)
mainFrame.pull.html:SetAllPoints()
mainFrame.pull.html:SetJustifyH("CENTER")
mainFrame.pull.html:SetText(L.marksbarpull)
mainFrame.pull.html:SetShadowOffset(1,-1)

ELib:FixPreloadFont(mainFrame.pull,mainFrame.pull.html,ExRT.F.defFont, 10)

do
	local markbuts_backdrop = {bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8}

	local frame = CreateFrame("Frame",nil,mainFrame,BackdropTemplateMixin and "BackdropTemplate")
	mainFrame.raidcheck = frame
	frame:SetSize(26,26)
	frame:SetBackdrop(markbuts_backdrop)
	frame:SetBackdropColor(0,0,0,0)
	frame:SetBackdropBorderColor(0.4,0.4,0.4,1)

	frame:Hide()

	frame.but = CreateFrame("Button",nil,frame)
	frame.but:SetSize(20,20)
	frame.but:SetPoint("TOPLEFT",  3, -3)
	frame.but.t = frame.but:CreateTexture(nil, "BACKGROUND")
	frame.but.t:SetTexture(ExRT.isClassic and 134833 or 609902)
	frame.but.t:SetPoint("TOPLEFT",-1,1)
	frame.but.t:SetPoint("BOTTOMRIGHT",1,-1)
	frame.but.t:SetTexCoord(.1,.9,.1,.9)
	
	frame.but:SetScript("OnEnter",function(self) self:GetParent():SetBackdropBorderColor(0.7,0.7,0.7,1) end)
	frame.but:SetScript("OnLeave",function(self) self:GetParent():SetBackdropBorderColor(0.4,0.4,0.4,1) end)

	frame.but:RegisterForClicks("RightButtonDown","LeftButtonDown")
	frame.but:SetScript("OnClick", function()
		if ExRT.A.RaidCheck then
			ExRT.A.RaidCheck:ReadyCheckWindow(nil,nil,true)
		end
	end)
end

local function modifymarkbars()
	local mainFrame = module.frame
	if not VMRT.MarksBar.Vertical then
		--Horizontal
		for i=1,8 do
			mainFrame.markbuts[i]:SetPoint("TOPLEFT", mainFrame.edges[1], VMRT.MarksBar.MarksReverse and (8-i)*28 or (i-1)*28, -4)		
		end
		
		mainFrame.start:SetSize(50,12)
		mainFrame.start:SetPoint("TOPLEFT", mainFrame.edges[2], 0, -4)
		mainFrame.del:SetSize(50,12)
		mainFrame.del:SetPoint("TOPLEFT", mainFrame.edges[2], 0, -18)
		
		mainFrame.wmarksbuts:SetPoint("TOPLEFT", mainFrame.edges[3], 0, -4)
		for i=1,9 do
			if VMRT.MarksBar.WMarksReverse then
				if i < 9 then
					local t_pos = 9-i
					mainFrame.wmarksbuts[i]:SetPoint("TOPLEFT", floor((t_pos-1)/2)*14, -((t_pos-1)%2)*13)
				else
					mainFrame.wmarksbuts[i]:SetPoint("TOPLEFT", floor((i-1)/2)*14, -((i-1)%2)*13)
				end
			else
				mainFrame.wmarksbuts[i]:SetPoint("TOPLEFT", floor((i-1)/2)*14, -((i-1)%2)*13)
			end
		end
		
		mainFrame.wmarksbuts.b:SetSize(123+19*3,26)
		mainFrame.wmarksbuts.b:SetPoint("TOPLEFT", mainFrame,"BOTTOMLEFT",20, 3)
		for i=1,9 do
			if VMRT.MarksBar.WMarksReverse then
				mainFrame.wmarksbuts.b[i]:SetPoint("TOPLEFT", 19*(9-i)+6, -4)
			else
				mainFrame.wmarksbuts.b[i]:SetPoint("TOPLEFT", 19*(i-1)+6, -4)
			end
		end
		
		mainFrame.readyCheck:SetSize(40,12)
		mainFrame.readyCheck:SetPoint("TOPLEFT",mainFrame.edges[4],0,-4)
		mainFrame.pull:SetSize(40,12)
		mainFrame.pull:SetPoint("TOPLEFT",mainFrame.edges[4],0, -18)
		--/Horizontal
	
		local posX = 4
		local totalWidth = 8
		
		mainFrame.edges[1]:SetPoint("TOPLEFT",4,0)
		if not VMRT.MarksBar.Show[1] then
			for i=1,16 do
				mainFrame.markbuts[i]:Hide()
			end
		else
			for i=1,8 do
				mainFrame.markbuts[i]:Show()
			end
			local showExtraMarks = RAID_TARGET_USE_EXTRA
			for i=9,16 do
				mainFrame.markbuts[i]:SetShown(showExtraMarks)
			end
			
			posX = posX + 222 + (showExtraMarks and 224 or 0)
			totalWidth = totalWidth + 222 + (showExtraMarks and 224 or 0)
		end
	
		mainFrame.edges[3]:SetPoint("TOPLEFT",posX,0)
		if not VMRT.MarksBar.Show[3] or not VMRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Hide()
		elseif VMRT.MarksBar.Show[3] and VMRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Show()
			
			posX = posX + 14*ceil(9 / 2)
			totalWidth = totalWidth + 14*ceil(9 / 2)
		end
	
		mainFrame.edge:Show()
		mainFrame:SetBackdropColor(0,0,0,0.8)
		if not VMRT.MarksBar.wmKind and VMRT.MarksBar.Show[3] then
			mainFrame.wmarksbuts.b:Show()
			if not (VMRT.MarksBar.Show[1] or VMRT.MarksBar.Show[2] or VMRT.MarksBar.Show[4]) then
				mainFrame.edge:Hide()
				mainFrame:SetBackdropColor(0,0,0,0)
			end
		else
			mainFrame.wmarksbuts.b:Hide()
		end
		
		mainFrame.edges[2]:SetPoint("TOPLEFT",posX,0)
		if not VMRT.MarksBar.Show[2] then
			mainFrame.start:Hide()
			mainFrame.del:Hide()
		else
			mainFrame.start:Show()
			mainFrame.del:Show()
			
			posX = posX + 51
			totalWidth = totalWidth + 51
		end
	
		mainFrame.edges[4]:SetPoint("TOPLEFT",posX,0)
		if not VMRT.MarksBar.Show[4] then
			mainFrame.readyCheck:Hide()
			mainFrame.pull:Hide()
		else
			mainFrame.readyCheck:Show()
			mainFrame.pull:Show()
			
			posX = posX + 40
			totalWidth = totalWidth + 40
		end

		mainFrame.raidcheck:SetPoint("TOPLEFT",posX,-4)
		if VMRT.MarksBar.Show[5] then
			mainFrame.raidcheck:Show()

			posX = posX + 26
			totalWidth = totalWidth + 26
		else
			mainFrame.raidcheck:Hide()
		end

		if not (VMRT.MarksBar.Show[1] or VMRT.MarksBar.Show[2] or VMRT.MarksBar.Show[3] or VMRT.MarksBar.Show[4] or VMRT.MarksBar.Show[5]) or not VMRT.MarksBar.enabled then
			mainFrame:Hide()
		else
			mainFrame:Show()
		end
	
		mainFrame:SetSize(totalWidth,34)
	else
		--Vertical
		for i=1,8 do
			mainFrame.markbuts[i]:SetPoint("TOPLEFT", mainFrame.edges[1], 4, -( VMRT.MarksBar.MarksReverse and (8-i)*28 or (i-1)*28 ))		
		end
		
		mainFrame.start:SetSize(26,12)
		mainFrame.start:SetPoint("TOPLEFT", mainFrame.edges[2], 4, 0)
		mainFrame.del:SetSize(26,12)
		mainFrame.del:SetPoint("TOPLEFT", mainFrame.edges[2], 4, -14)
		
		mainFrame.wmarksbuts:SetPoint("TOPLEFT", mainFrame.edges[3], 4, 0)
		for i=1,9 do
			if VMRT.MarksBar.WMarksReverse then
				if i < 9 then
					local t_pos = 9-i
					mainFrame.wmarksbuts[i]:SetPoint("TOPLEFT", ((t_pos-1)%2)*13, -floor((t_pos-1)/2)*14)
				else
					mainFrame.wmarksbuts[i]:SetPoint("TOPLEFT", ((i-1)%2)*13, -floor((i-1)/2)*14)
				end
			else
				mainFrame.wmarksbuts[i]:SetPoint("TOPLEFT", ((i-1)%2)*13, -floor((i-1)/2)*14)
			end
		end
		
		mainFrame.wmarksbuts.b:SetSize(26,123+19*3)
		mainFrame.wmarksbuts.b:SetPoint("TOPLEFT", mainFrame,"TOPRIGHT",-3,-20)
		for i=1,9 do
			if VMRT.MarksBar.WMarksReverse then
				mainFrame.wmarksbuts.b[i]:SetPoint("TOPLEFT", 4, -19*(9-i)-6)
			else
				mainFrame.wmarksbuts.b[i]:SetPoint("TOPLEFT", 4, -19*(i-1)-6)
			end
		end
		
		mainFrame.readyCheck:SetSize(26,12)
		mainFrame.readyCheck:SetPoint("TOPLEFT",mainFrame.edges[4],4,0)
		mainFrame.pull:SetSize(26,12)
		mainFrame.pull:SetPoint("TOPLEFT",mainFrame.edges[4],4, -14)
		--/Vertical
	
		local posX = 4
		local totalWidth = 8
		
		mainFrame.edges[1]:SetPoint("TOPLEFT",0,-posX)
		if not VMRT.MarksBar.Show[1] then
			for i=1,16 do
				mainFrame.markbuts[i]:Hide()
			end
		else
			for i=1,8 do
				mainFrame.markbuts[i]:Show()
			end
			local showExtraMarks = RAID_TARGET_USE_EXTRA
			for i=9,16 do
				mainFrame.markbuts[i]:SetShown(showExtraMarks)
			end
			
			posX = posX + 224 + (showExtraMarks and 224 or 0)
			totalWidth = totalWidth + 224 + (showExtraMarks and 224 or 0)
		end
	
		mainFrame.edges[3]:SetPoint("TOPLEFT",0,-posX)
		if not VMRT.MarksBar.Show[3] or not VMRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Hide()
		elseif VMRT.MarksBar.Show[3] and VMRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Show()
			
			posX = posX + 14*ceil(9 / 2)
			totalWidth = totalWidth + 14*ceil(9 / 2)
		end
	
		mainFrame.edge:Show()
		mainFrame:SetBackdropColor(0,0,0,0.8)
		if not VMRT.MarksBar.wmKind and VMRT.MarksBar.Show[3] then
			mainFrame.wmarksbuts.b:Show()
			if not (VMRT.MarksBar.Show[1] or VMRT.MarksBar.Show[2] or VMRT.MarksBar.Show[4]) then
				mainFrame.edge:Hide()
				mainFrame:SetBackdropColor(0,0,0,0)
			end
		else
			mainFrame.wmarksbuts.b:Hide()
		end
		
		mainFrame.edges[2]:SetPoint("TOPLEFT",0,-posX)
		if not VMRT.MarksBar.Show[2] then
			mainFrame.start:Hide()
			mainFrame.del:Hide()
		else
			mainFrame.start:Show()
			mainFrame.del:Show()
			
			posX = posX + 26
			totalWidth = totalWidth + 26
		end
	
		mainFrame.edges[4]:SetPoint("TOPLEFT",0,-posX)
		if not VMRT.MarksBar.Show[4] then
			mainFrame.readyCheck:Hide()
			mainFrame.pull:Hide()
		else
			mainFrame.readyCheck:Show()
			mainFrame.pull:Show()
			
			posX = posX + 26
			totalWidth = totalWidth + 26
		end

		mainFrame.raidcheck:SetPoint("TOPLEFT",4,-posX)
		if VMRT.MarksBar.Show[5] then
			mainFrame.raidcheck:Show()

			posX = posX + 26
			totalWidth = totalWidth + 26
		else
			mainFrame.raidcheck:Hide()
		end

		if not (VMRT.MarksBar.Show[1] or VMRT.MarksBar.Show[2] or VMRT.MarksBar.Show[3] or VMRT.MarksBar.Show[4] or VMRT.MarksBar.Show[5]) or not VMRT.MarksBar.enabled then
			mainFrame:Hide()
		else
			mainFrame:Show()
		end
	
		mainFrame:SetSize(34,totalWidth)
	end
	if VMRT.MarksBar.DisableOutsideRaid then
		module:GroupRosterUpdate()
	end
end
module.modifymarkbars = modifymarkbars

function module:Enable()
	VMRT.MarksBar.enabled = true
	module.frame:Show()
	module:RegisterEvents('RAID_TARGET_UPDATE')
	module:RegisterEvents('GROUP_ROSTER_UPDATE')
	if VMRT.MarksBar.DisableOutsideRaid or VMRT.MarksBar.DisableWithoutAssist then
		module:GroupRosterUpdate()
	end
end
function module:Disable()
	VMRT.MarksBar.enabled = nil
	module.frame:Hide()
	module:UnregisterEvents('RAID_TARGET_UPDATE','GROUP_ROSTER_UPDATE')
end

function module:Lock()
	module.frame:SetMovable(false)
end
function module:Unlock()
	module.frame:SetMovable(true)
end

function module.options:Load()
	self:CreateTilte()

	self.chkEnable = ELib:Check(self,L.Enable,VMRT.MarksBar.enabled):Point(15,-30):Tooltip("/rt mb\n/rt mm"):AddColorState():OnClick(function(self)
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)
	
	self.chkFix = ELib:Check(self,L.messagebutfix,VMRT.MarksBar.Fix):Point(15,-55):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Fix = true
			module:Lock()
		else
			VMRT.MarksBar.Fix = nil
			module:Unlock()
		end
	end)
	
	self.chkVertical = ELib:Check(self,L.MarksBarVertical,VMRT.MarksBar.Vertical):Point(15,-80):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Vertical = true
		else
			VMRT.MarksBar.Vertical = nil
		end
		modifymarkbars()
	end)
	
	self.chkDisableInRaid = ELib:Check(self,L.MarksBarDisableInRaid,VMRT.MarksBar.DisableOutsideRaid):Point(15,-105):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.DisableOutsideRaid = true
			if VMRT.MarksBar.enabled then
				module:GroupRosterUpdate()
			end
		else
			VMRT.MarksBar.DisableOutsideRaid = nil
			if VMRT.MarksBar.enabled then
				module:GroupRosterUpdate()
			end
		end
	end)

	self.chkDisableWOAssist = ELib:Check(self,L.MarksBarDisableWOAssist,VMRT.MarksBar.DisableOutsideRaid):Point(15,-130):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.DisableWithoutAssist = true
			if VMRT.MarksBar.enabled then
				module:GroupRosterUpdate()
			end
		else
			VMRT.MarksBar.DisableWithoutAssist = nil
			if VMRT.MarksBar.enabled then
				module:GroupRosterUpdate()
			end
		end
	end)

	self.chkShowOnHover = ELib:Check(self,L.MarksBarShowOnHover,VMRT.MarksBar.ShowOnHover):Point(15,-155):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.ShowOnHover = true
		else
			VMRT.MarksBar.ShowOnHover = nil
		end
		mainFrame:CheckAlpha()
	end)

	self.SliderShowOnHover= ELib:Slider(self,L.marksbaralpha):Size(200):Point("LEFT",self.chkShowOnHover,"RIGHT",250,0):Range(0,100):SetTo((VMRT.MarksBar.ShowOnHoverAlpha or 0)*100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.MarksBar.ShowOnHoverAlpha = event / 100
		mainFrame:CheckAlpha()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.chkShowOnHoverAnim = ELib:Check(self,ANIMATION or "Animation",not VMRT.MarksBar.ShowOnHoverAnimDisable):Point("LEFT",self.chkShowOnHover,"LEFT",500,0):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.ShowOnHoverAnimDisable = nil
		else
			VMRT.MarksBar.ShowOnHoverAnimDisable = true
		end
	end)
	
	self.TabViewOptions = ELib:OneTab(self):Size(678,130):Point("TOP",0,-185)
	ELib:Border(self.TabViewOptions,0)

	ELib:DecorationLine(self):Point("BOTTOM",self.TabViewOptions,"TOP",0,0):Point("LEFT",self):Point("RIGHT",self):Size(0,1)
	ELib:DecorationLine(self):Point("TOP",self.TabViewOptions,"BOTTOM",0,0):Point("LEFT",self):Point("RIGHT",self):Size(0,1)
	
	self.chkEnable1 = ELib:Check(self.TabViewOptions,L.marksbarshowmarks,VMRT.MarksBar.Show[1]):Point(5,-5):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Show[1]=true
		else
			VMRT.MarksBar.Show[1]=nil
		end
		modifymarkbars()
	end)
	
	self.reverseMarksOrderChk = ELib:Check(self.TabViewOptions,L.MarksBarReverse,VMRT.MarksBar.MarksReverse):Point(300,-5):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.MarksReverse = true
		else
			VMRT.MarksBar.MarksReverse = nil
		end
		modifymarkbars()
	end)
	
	self.chkEnable2 = ELib:Check(self.TabViewOptions,L.marksbarshowpermarks,VMRT.MarksBar.Show[2]):Point(5,-30):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Show[2]=true
		else
			VMRT.MarksBar.Show[2]=nil
		end
		modifymarkbars()
	end)
	
	self.chkEnable3 = ELib:Check(self.TabViewOptions,L.marksbarshowfloor,VMRT.MarksBar.Show[3]):Point(5,-55):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Show[3]=true
		else
			VMRT.MarksBar.Show[3]=nil
		end
		modifymarkbars()
	end)
	
	
	self.chkEnable3kindhtml = ELib:Text(self.TabViewOptions,L.marksbarWMView,11):Size(100,20):Point(300,-55)
	
	self.chkEnable3kind1 = ELib:Radio(self.TabViewOptions,"1",VMRT.MarksBar.wmKind):Point(380,-63+5):OnClick(function(self) 
		self:SetChecked(true)
		module.options.chkEnable3kind2:SetChecked(false)
		VMRT.MarksBar.wmKind = true
		modifymarkbars()
	end)
	
	self.chkEnable3kind2 = ELib:Radio(self.TabViewOptions,"2",not VMRT.MarksBar.wmKind):Point(420,-63+5):OnClick(function(self) 
		self:SetChecked(true)
		module.options.chkEnable3kind1:SetChecked(false)
		VMRT.MarksBar.wmKind = nil
		modifymarkbars()
	end)
	
	self.reverseWMMarksOrderChk = ELib:Check(self.TabViewOptions,L.MarksBarReverse,VMRT.MarksBar.MarksReverse):Point(480,-55):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.WMarksReverse = true
		else
			VMRT.MarksBar.WMarksReverse = nil
		end
		modifymarkbars()
	end)
	
	self.chkEnable4 = ELib:Check(self.TabViewOptions,L.marksbarshowrcpull,VMRT.MarksBar.Show[4]):Point(5,-80):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Show[4]=true
		else
			VMRT.MarksBar.Show[4]=nil
		end
		modifymarkbars()
	end)

	self.chkEnable5 = ELib:Check(self.TabViewOptions,L.raidcheck,VMRT.MarksBar.Show[5]):Point(5,-105):OnClick(function(self)
		if self:GetChecked() then
			VMRT.MarksBar.Show[5]=true
		else
			VMRT.MarksBar.Show[5]=nil
		end
		modifymarkbars()
	end)
	
	self.SliderScale = ELib:Slider(self,L.marksbarscale):Size(660):Point("TOP",0,-365):Range(5,200):SetTo(VMRT.MarksBar.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.MarksBar.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.SliderAlpha = ELib:Slider(self,L.marksbaralpha):Size(660):Point("TOP",0,-395):Range(0,100):SetTo(VMRT.MarksBar.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.MarksBar.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	
	self.htmlTimer = ELib:Text(self,L.marksbartmr,11):Size(150,20):Point(15,-325)

	self.editBoxTimer = ELib:Edit(self,6,true):Size(120,20):Point(200,-325):Text(VMRT.MarksBar.pulltimer or "10"):LeftText(L.MarksBarTimerLeftClick):OnChange(function(self)
		VMRT.MarksBar.pulltimer = tonumber(self:GetText()) or 10
	end)  
	self.editBoxTimer_right = ELib:Edit(self,6,true):Size(120,20):Point("LEFT",self.editBoxTimer,"RIGHT",80,0):Text(VMRT.MarksBar.pulltimer_right or "10"):LeftText(L.MarksBarTimerRightClick):OnChange(function(self)
		VMRT.MarksBar.pulltimer_right = tonumber(self:GetText()) or 10
	end)  
	
	self.frameStrataDropDown = ELib:DropDown(self,275,8):Point(15,-425):Size(260):SetText(L.S_Strata)
	local function FrameStrataDropDown_SetVaule(_,arg)
		VMRT.MarksBar.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.frameStrataDropDown.List do
			self.frameStrataDropDown.List[i].checkState = arg == self.frameStrataDropDown.List[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end
	for i,strataString in ipairs({"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}) do
		self.frameStrataDropDown.List[i] = {
			text = strataString,
			checkState = VMRT.MarksBar.Strata == strataString,
			radio = true,
			arg1 = strataString,
			func = FrameStrataDropDown_SetVaule,
		}
	end
	
	self.ButtonToCenter = ELib:Button(self,L.MarksBarResetPos):Size(260,22):Point(15,-450):Tooltip(L.MarksBarResetPosTooltip):OnClick(function()
		VMRT.MarksBar.Left = nil
		VMRT.MarksBar.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 
	
	self.shtml1 = ELib:Text(self,L.MarksBarHelp,12):Size(670,200):Point(15,-480):Top()
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.MarksBar = VMRT.MarksBar or {}

	if VMRT.MarksBar.Left and VMRT.MarksBar.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VMRT.MarksBar.Left,VMRT.MarksBar.Top)
	end

	VMRT.MarksBar.Show = VMRT.MarksBar.Show or {true,true,true,true,true}

	modifymarkbars()

	if VMRT.MarksBar.enabled then
		module:Enable()
	end

	VMRT.MarksBar.pulltimer = VMRT.MarksBar.pulltimer or 10
	VMRT.MarksBar.pulltimer_right = VMRT.MarksBar.pulltimer_right or VMRT.MarksBar.pulltimer

	if VMRT.MarksBar.Fix then 
		module:Lock()
	else
		module:Unlock()
	end

	if VMRT.MarksBar.Alpha then module.frame:SetAlpha(VMRT.MarksBar.Alpha/100) end
	if VMRT.MarksBar.Scale then module.frame:SetScale(VMRT.MarksBar.Scale/100) end

	if VMRT.MarksBar.ShowOnHover then
		mainFrame:CheckAlpha()
	end
	
	VMRT.MarksBar.Strata = VMRT.MarksBar.Strata or "HIGH"
	module.frame:SetFrameStrata(VMRT.MarksBar.Strata)
	
	module:RegisterSlash()
end

function module.main:RAID_TARGET_UPDATE()
	if GetTime()-module.db.clearnum<5 and GetRaidTargetIndex("player") == 8 then
		SetRaidTarget("player", 0)
		module.db.clearnum = -1
	end
end

local delayTimer
function module:GroupRosterUpdate()
	if delayTimer then
		delayTimer:Cancel()
		delayTimer = nil
	end
	if not VMRT.MarksBar.enabled then
		return
	end

	local needShow = true
	if VMRT.MarksBar.DisableOutsideRaid then
		local n = GetNumGroupMembers() or 0
		if n == 0 then
			needShow = false
		else
			needShow = needShow and true
		end
	end
	if VMRT.MarksBar.DisableWithoutAssist then
		local playerRole
		if not IsInRaid() then
			playerRole = 2
		else
			playerRole = ExRT.F.IsPlayerRLorOfficer("player")
		end
		if (playerRole or 0) > 0 then
			needShow = needShow and true
		else
			needShow = false
		end
	end
	if needShow and not module.frame:IsShown() then
		if InCombatLockdown() then
			delayTimer = ExRT.F.ScheduleTimer(module.GroupRosterUpdate, 2, module)
		else
			module.frame:Show()
		end
	elseif not needShow and module.frame:IsShown() then
		if InCombatLockdown() then
			delayTimer = ExRT.F.ScheduleTimer(module.GroupRosterUpdate, 2, module)
		else
			module.frame:Hide()
		end
	end
end
function module.main:GROUP_ROSTER_UPDATE()
	ExRT.F.ScheduleTimer(module.GroupRosterUpdate,1)
end

function module:slash(arg)
	if arg == "mm" or arg == "mb" then
		if not VMRT.MarksBar.enabled then
			module:Enable()
		else
			module:Disable()
		end
		if module.options.chkEnable then
			module.options.chkEnable:SetChecked(VMRT.MarksBar.enabled)
		end
	elseif arg == "help" then
		print("|cff00ff00/rt mb|r - enable/disable marks bar")
	end
end