local GlobalAddonName, ExRT = ...

local GetTime, GetRaidTargetIndex, SetRaidTarget, UnitName, SetRaidTargetIcon = GetTime, GetRaidTargetIndex, SetRaidTarget, UnitName, SetRaidTargetIcon

local VExRT = nil

local module = ExRT.mod:New("MarksBar",ExRT.L.marksbar,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.perma = {}
module.db.clearnum = -1
module.db.iconsList = {
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
}
module.db.worldMarksList = {
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
	"Interface\\AddOns\\ExRT\\media\\flare_del.blp",
}
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

module.frame = CreateFrame("Frame",nil,UIParent)
module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:SetClampedToScreen(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self) 
	if self:IsMovable() then 
		self:StartMoving() 
	end 
end)
module.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VExRT.MarksBar.Left = self:GetLeft()
	VExRT.MarksBar.Top = self:GetTop()
end)
module.frame:SetBackdrop({bgFile = ExRT.F.barImg})
module.frame:SetBackdropColor(0,0,0,0.8)
module.frame:Hide()
module:RegisterHideOnPetBattle(module.frame)

module.frame.edge = CreateFrame("Frame",nil,module.frame)
module.frame.edge:SetPoint("TOPLEFT", 1, -1)
module.frame.edge:SetPoint("BOTTOMRIGHT", -1, 1)
module.frame.edge:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
module.frame.edge:SetBackdropColor(0,0,0,0)
module.frame.edge:SetBackdropBorderColor(0.6,0.6,0.6,1)

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

module.frame.edges = {}

local function CreateEdge(i,x)
	local self = CreateFrame("Frame",nil,module.frame)
	self:SetSize(1,1)
	self:SetPoint("TOPLEFT",x,0)
	return self
end

module.frame.edges[1] = CreateEdge(1,4)

module.frame.markbuts = {}
do
	local markbuts_backdrop = {bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8}
	for i=1,8 do
		local frame = CreateFrame("Frame",nil,module.frame)
		module.frame.markbuts[i] = frame
		frame:SetSize(26,26)
		frame:SetPoint("TOPLEFT", module.frame.edges[1], (i-1)*28, -4)
		frame:SetBackdrop(markbuts_backdrop)
		frame:SetBackdropColor(0,0,0,0)
		frame:SetBackdropBorderColor(0.4,0.4,0.4,1)
	
		frame.but = CreateFrame("Button",nil,frame)
		frame.but:SetSize(20,20)
		frame.but:SetPoint("TOPLEFT",  3, -3)
		frame.but.t = frame.but:CreateTexture(nil, "BACKGROUND")
		frame.but.t:SetTexture(module.db.iconsList[i])
		frame.but.t:SetAllPoints()
		
		frame.but._i = i
	
		frame.but:SetScript("OnEnter",MainFrameMarkButtonOnEnter)
		frame.but:SetScript("OnLeave", MainFrameMarkButtonOnLeave)
	
		frame.but:RegisterForClicks("RightButtonDown","LeftButtonDown")
		frame.but:SetScript("OnClick", MainFrameMarkButtonOnClick)
	end
end

module.frame.edges[2] = CreateEdge(2,228)

module.frame.start = CreateFrame("Button",nil,module.frame)
module.frame.start:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
module.frame.start:SetBackdropColor(0,0,0,0)
module.frame.start:SetBackdropBorderColor(0.4,0.4,0.4,1)
module.frame.start:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
module.frame.start:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
module.frame.start:SetScript("OnClick", function(self)    
	module.db.clearnum = GetTime()
	for i=1,8 do
		SetRaidTarget("player", i) 
	end
end)

module.frame.start.html = module.frame.start:CreateFontString(nil,"ARTWORK")
module.frame.start.html:SetFont(ExRT.F.defFont, 10)
module.frame.start.html:SetAllPoints()
module.frame.start.html:SetJustifyH("CENTER")
module.frame.start.html:SetText(L.marksbarstart)
module.frame.start.html:SetShadowOffset(1,-1)

module.frame.del = CreateFrame("Button",nil,module.frame)
module.frame.del:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
module.frame.del:SetBackdropColor(0,0,0,0)
module.frame.del:SetBackdropBorderColor(0.4,0.4,0.4,1)
module.frame.del:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
module.frame.del:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
module.frame.del:SetScript("OnClick", function(self)    
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

module.frame.del.html = module.frame.del:CreateFontString(nil,"ARTWORK")
module.frame.del.html:SetFont(ExRT.F.defFont, 10)
module.frame.del.html:SetAllPoints()
module.frame.del.html:SetJustifyH("CENTER")
module.frame.del.html:SetText(L.marksbardel)
module.frame.del.html:SetShadowOffset(1,-1)

module.frame.edges[3] = CreateEdge(3,383)

module.frame.wmarksbuts = CreateFrame("Frame",nil,module.frame)
module.frame.wmarksbuts:SetSize(70,26)
local function MainFrameWMOnEnter(self)
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end
local function MainFrameWMOnLeave(self)
	self:SetBackdropBorderColor(0.4,0.4,0.4,0)
end
local function MainFrameWMOnEvent(self, event, ...)
	self[event](self, event, ...)
end

do
	local wmarksbuts_backdrop = {bgFile = "",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6}
	for i=1,9 do
		local frame = CreateFrame("Button","ExRT_MarksBar_WorldMarkers_Kind1_"..i,module.frame.wmarksbuts,"SecureActionButtonTemplate")	--FrameStack Fix
		module.frame.wmarksbuts[i] = frame
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
			frame:SetScript('OnEvent', MainFrameWMOnEvent)
		else
			frame:SetScript("OnClick", ClearRaidMarker)
		end
	
		frame.t = frame:CreateTexture(nil, "BACKGROUND")
		frame.t:SetTexture(module.db.worldMarksList[i])
		frame.t:SetSize(10,10)
		frame.t:SetPoint("CENTER",frame, "CENTER", 0,0)
	end
end

module.frame.wmarksbuts.b = CreateFrame("Frame",nil,module.frame)
module.frame.wmarksbuts.b:SetFrameLevel(0)
module.frame.wmarksbuts.b:SetBackdrop({bgFile = ExRT.F.barImg})
module.frame.wmarksbuts.b:SetBackdropColor(0,0,0,0.8)
module.frame.wmarksbuts.b.t = CreateFrame("Frame",nil,module.frame.wmarksbuts.b)
module.frame.wmarksbuts.b.t:SetPoint("BOTTOMRIGHT", -1, 1)
module.frame.wmarksbuts.b.t:SetPoint("TOPLEFT", 1, -1)
module.frame.wmarksbuts.b.t:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
module.frame.wmarksbuts.b.t:SetBackdropColor(0,0,0,0)
module.frame.wmarksbuts.b.t:SetBackdropBorderColor(0.6,0.6,0.6,1)
local function MainFrameWMKind2OnEnter(self)
	self.t:SetVertexColor(module.db.wm_color_hover[self._i].r,module.db.wm_color_hover[self._i].g,module.db.wm_color_hover[self._i].b,1)
end
local function MainFrameWMKind2OnLeave(self)
	self.t:SetVertexColor(module.db.wm_color[self._i].r,module.db.wm_color[self._i].g,module.db.wm_color[self._i].b,1)
end

for i=1,9 do
	local frame = CreateFrame("Button","ExRT_MarksBar_WorldMarkers_Kind2_"..i,module.frame.wmarksbuts.b,"SecureActionButtonTemplate")	--FrameStack Fix
	module.frame.wmarksbuts.b[i] = frame
	frame:SetSize(18,18)
	frame.t = frame:CreateTexture(nil, "BACKGROUND")
	if i == 9 then
		frame.t:SetTexture(module.db.worldMarksList[i])
	else
		frame.t:SetTexture("Interface\\AddOns\\ExRT\\media\\blip")
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
		frame:SetScript('OnEvent', MainFrameWMOnEvent)
	else
		frame:SetScript("OnClick", ClearRaidMarker)
	end
end

module.frame.edges[4] = CreateEdge(4,325)

module.frame.readyCheck = CreateFrame("Button",nil,module.frame)
module.frame.readyCheck:SetSize(40,12)
module.frame.readyCheck:SetPoint("TOPLEFT",module.frame.edges[4],0,-4)
module.frame.readyCheck:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
module.frame.readyCheck:SetBackdropColor(0,0,0,0)
module.frame.readyCheck:SetBackdropBorderColor(0.4,0.4,0.4,1)
module.frame.readyCheck:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
module.frame.readyCheck:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
module.frame.readyCheck:SetScript("OnClick", function(self)    
	DoReadyCheck()
end)

module.frame.readyCheck.html = module.frame.readyCheck:CreateFontString(nil,"ARTWORK")
module.frame.readyCheck.html:SetFont(ExRT.F.defFont, 10)
module.frame.readyCheck.html:SetAllPoints()
module.frame.readyCheck.html:SetJustifyH("CENTER")
module.frame.readyCheck.html:SetText(L.marksbarrc)
module.frame.readyCheck.html:SetShadowOffset(1,-1)

module.frame.pull = CreateFrame("Button",nil,module.frame)
module.frame.pull:SetSize(40,12)
module.frame.pull:SetPoint("TOPLEFT",module.frame.edges[4],0, -18)
module.frame.pull:SetBackdrop({bgFile = ExRT.F.barImg,edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 6})
module.frame.pull:SetBackdropColor(0,0,0,0)
module.frame.pull:SetBackdropBorderColor(0.4,0.4,0.4,1)
module.frame.pull:SetScript("OnEnter",function(self) 
	self:SetBackdropBorderColor(0.7,0.7,0.7,1)
end)	
module.frame.pull:SetScript("OnLeave", function(self)    
	self:SetBackdropBorderColor(0.4,0.4,0.4,1)
end)
module.frame.pull:SetScript("OnClick", function(self)    
	ExRT.F:DoPull(VExRT.MarksBar.pulltimer)
end)

module.frame.pull.html = module.frame.pull:CreateFontString(nil,"ARTWORK")
module.frame.pull.html:SetFont(ExRT.F.defFont, 10)
module.frame.pull.html:SetAllPoints()
module.frame.pull.html:SetJustifyH("CENTER")
module.frame.pull.html:SetText(L.marksbarpull)
module.frame.pull.html:SetShadowOffset(1,-1)

local function modifymarkbars()
	local mainFrame = module.frame
	if not VExRT.MarksBar.Vertical then
		--Horizontal
		for i=1,8 do
			mainFrame.markbuts[i]:SetPoint("TOPLEFT", mainFrame.edges[1], VExRT.MarksBar.MarksReverse and (8-i)*28 or (i-1)*28, -4)		
		end
		
		mainFrame.start:SetSize(50,12)
		mainFrame.start:SetPoint("TOPLEFT", mainFrame.edges[2], 0, -4)
		mainFrame.del:SetSize(50,12)
		mainFrame.del:SetPoint("TOPLEFT", mainFrame.edges[2], 0, -18)
		
		mainFrame.wmarksbuts:SetPoint("TOPLEFT", mainFrame.edges[3], 0, -4)
		for i=1,9 do
			if VExRT.MarksBar.WMarksReverse then
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
			if VExRT.MarksBar.WMarksReverse then
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
		if not VExRT.MarksBar.Show[1] then
			for i=1,8 do
				mainFrame.markbuts[i]:Hide()
			end
		else
			for i=1,8 do
				mainFrame.markbuts[i]:Show()
			end
			
			posX = posX + 222
			totalWidth = totalWidth + 222
		end
	
		mainFrame.edges[3]:SetPoint("TOPLEFT",posX,0)
		if not VExRT.MarksBar.Show[3] or not VExRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Hide()
		elseif VExRT.MarksBar.Show[3] and VExRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Show()
			
			posX = posX + 14*ceil(9 / 2)
			totalWidth = totalWidth + 14*ceil(9 / 2)
		end
	
		mainFrame.edge:Show()
		mainFrame:SetBackdropColor(0,0,0,0.8)
		if not VExRT.MarksBar.wmKind and VExRT.MarksBar.Show[3] then
			mainFrame.wmarksbuts.b:Show()
			if not (VExRT.MarksBar.Show[1] or VExRT.MarksBar.Show[2] or VExRT.MarksBar.Show[4]) then
				mainFrame.edge:Hide()
				mainFrame:SetBackdropColor(0,0,0,0)
			end
		else
			mainFrame.wmarksbuts.b:Hide()
		end
		
		mainFrame.edges[2]:SetPoint("TOPLEFT",posX,0)
		if not VExRT.MarksBar.Show[2] then
			mainFrame.start:Hide()
			mainFrame.del:Hide()
		else
			mainFrame.start:Show()
			mainFrame.del:Show()
			
			posX = posX + 51
			totalWidth = totalWidth + 51
		end
	
		mainFrame.edges[4]:SetPoint("TOPLEFT",posX,0)
		if not VExRT.MarksBar.Show[4] then
			mainFrame.readyCheck:Hide()
			mainFrame.pull:Hide()
		else
			mainFrame.readyCheck:Show()
			mainFrame.pull:Show()
			
			posX = posX + 40
			totalWidth = totalWidth + 40
		end
		if not (VExRT.MarksBar.Show[1] or VExRT.MarksBar.Show[2] or VExRT.MarksBar.Show[3] or VExRT.MarksBar.Show[4]) or not VExRT.MarksBar.enabled then
			mainFrame:Hide()
		else
			mainFrame:Show()
		end
	
		mainFrame:SetSize(totalWidth,34)
	else
		--Vertical
		for i=1,8 do
			mainFrame.markbuts[i]:SetPoint("TOPLEFT", mainFrame.edges[1], 4, -( VExRT.MarksBar.MarksReverse and (8-i)*28 or (i-1)*28 ))		
		end
		
		mainFrame.start:SetSize(26,12)
		mainFrame.start:SetPoint("TOPLEFT", mainFrame.edges[2], 4, 0)
		mainFrame.del:SetSize(26,12)
		mainFrame.del:SetPoint("TOPLEFT", mainFrame.edges[2], 4, -14)
		
		mainFrame.wmarksbuts:SetPoint("TOPLEFT", mainFrame.edges[3], 4, 0)
		for i=1,9 do
			if VExRT.MarksBar.WMarksReverse then
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
			if VExRT.MarksBar.WMarksReverse then
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
		if not VExRT.MarksBar.Show[1] then
			for i=1,8 do
				mainFrame.markbuts[i]:Hide()
			end
		else
			for i=1,8 do
				mainFrame.markbuts[i]:Show()
			end
			
			posX = posX + 224
			totalWidth = totalWidth + 224
		end
	
		mainFrame.edges[3]:SetPoint("TOPLEFT",0,-posX)
		if not VExRT.MarksBar.Show[3] or not VExRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Hide()
		elseif VExRT.MarksBar.Show[3] and VExRT.MarksBar.wmKind then
			mainFrame.wmarksbuts:Show()
			
			posX = posX + 14*ceil(9 / 2)
			totalWidth = totalWidth + 14*ceil(9 / 2)
		end
	
		mainFrame.edge:Show()
		mainFrame:SetBackdropColor(0,0,0,0.8)
		if not VExRT.MarksBar.wmKind and VExRT.MarksBar.Show[3] then
			mainFrame.wmarksbuts.b:Show()
			if not (VExRT.MarksBar.Show[1] or VExRT.MarksBar.Show[2] or VExRT.MarksBar.Show[4]) then
				mainFrame.edge:Hide()
				mainFrame:SetBackdropColor(0,0,0,0)
			end
		else
			mainFrame.wmarksbuts.b:Hide()
		end
		
		mainFrame.edges[2]:SetPoint("TOPLEFT",0,-posX)
		if not VExRT.MarksBar.Show[2] then
			mainFrame.start:Hide()
			mainFrame.del:Hide()
		else
			mainFrame.start:Show()
			mainFrame.del:Show()
			
			posX = posX + 26
			totalWidth = totalWidth + 26
		end
	
		mainFrame.edges[4]:SetPoint("TOPLEFT",0,-posX)
		if not VExRT.MarksBar.Show[4] then
			mainFrame.readyCheck:Hide()
			mainFrame.pull:Hide()
		else
			mainFrame.readyCheck:Show()
			mainFrame.pull:Show()
			
			posX = posX + 26
			totalWidth = totalWidth + 26
		end
		if not (VExRT.MarksBar.Show[1] or VExRT.MarksBar.Show[2] or VExRT.MarksBar.Show[3] or VExRT.MarksBar.Show[4]) or not VExRT.MarksBar.enabled then
			mainFrame:Hide()
		else
			mainFrame:Show()
		end
	
		mainFrame:SetSize(34,totalWidth)
	end
	if VExRT.MarksBar.DisableOutsideRaid then
		module:GroupRosterUpdate()
	end
end

local function EnableMarksBar()
	VExRT.MarksBar.enabled = true
	module.frame:Show()
	module:RegisterEvents('RAID_TARGET_UPDATE')
	if VExRT.MarksBar.DisableOutsideRaid then
		module:RegisterEvents('GROUP_ROSTER_UPDATE')
		module:GroupRosterUpdate()
	end
end
local function DisableMarksBar()
	VExRT.MarksBar.enabled = nil
	module.frame:Hide()
	module:UnregisterEvents('RAID_TARGET_UPDATE','GROUP_ROSTER_UPDATE')
end

function module.options:Load()
	self:CreateTilte()

	self.chkEnable = ELib:Check(self,L.senable,VExRT.MarksBar.enabled):Point(5,-30):Tooltip("/rt mb\n/rt mm"):OnClick(function(self)
		if self:GetChecked() then
			EnableMarksBar()
		else
			DisableMarksBar()
		end
	end)
	
	self.chkFix = ELib:Check(self,L.messagebutfix,VExRT.MarksBar.Fix):Point(5,-55):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.Fix = true
			ExRT.F.LockMove(module.frame,nil,nil,1)
		else
			VExRT.MarksBar.Fix = nil
			ExRT.F.LockMove(module.frame,true,nil,1)
		end
	end)
	
	self.chkVertical = ELib:Check(self,L.MarksBarVertical,VExRT.MarksBar.Vertical):Point(5,-80):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.Vertical = true
		else
			VExRT.MarksBar.Vertical = nil
		end
		modifymarkbars()
	end)
	
	self.chkDisableInRaid = ELib:Check(self,L.MarksBarDisableInRaid,VExRT.MarksBar.DisableOutsideRaid):Point(5,-105):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.DisableOutsideRaid = true
			if VExRT.MarksBar.enabled then
				module:GroupRosterUpdate()
			end
		else
			VExRT.MarksBar.DisableOutsideRaid = nil
			if VExRT.MarksBar.enabled and not module.frame:IsShown() then
				module.frame:Show()
			end
		end
	end)
	
	self.TabViewOptions = ELib:OneTab(self):Size(648,105):Point("TOP",0,-135)
	
	self.chkEnable1 = ELib:Check(self.TabViewOptions,L.marksbarshowmarks,VExRT.MarksBar.Show[1]):Point(5,-5):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.Show[1]=true
		else
			VExRT.MarksBar.Show[1]=nil
		end
		modifymarkbars()
	end)
	
	self.reverseMarksOrderChk = ELib:Check(self.TabViewOptions,L.MarksBarReverse,VExRT.MarksBar.MarksReverse):Point(300,-5):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.MarksReverse = true
		else
			VExRT.MarksBar.MarksReverse = nil
		end
		modifymarkbars()
	end)
	
	self.chkEnable2 = ELib:Check(self.TabViewOptions,L.marksbarshowpermarks,VExRT.MarksBar.Show[2]):Point(5,-30):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.Show[2]=true
		else
			VExRT.MarksBar.Show[2]=nil
		end
		modifymarkbars()
	end)
	
	self.chkEnable3 = ELib:Check(self.TabViewOptions,L.marksbarshowfloor,VExRT.MarksBar.Show[3]):Point(5,-55):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.Show[3]=true
		else
			VExRT.MarksBar.Show[3]=nil
		end
		modifymarkbars()
	end)
	
	
	self.chkEnable3kindhtml = ELib:Text(self.TabViewOptions,L.marksbarWMView,11):Size(100,20):Point(300,-55)
	
	self.chkEnable3kind1 = ELib:Radio(self.TabViewOptions,"1",VExRT.MarksBar.wmKind):Point(380,-63+5):OnClick(function(self) 
		self:SetChecked(true)
		module.options.chkEnable3kind2:SetChecked(false)
		VExRT.MarksBar.wmKind = true
		modifymarkbars()
	end)
	
	self.chkEnable3kind2 = ELib:Radio(self.TabViewOptions,"2",not VExRT.MarksBar.wmKind):Point(420,-63+5):OnClick(function(self) 
		self:SetChecked(true)
		module.options.chkEnable3kind1:SetChecked(false)
		VExRT.MarksBar.wmKind = nil
		modifymarkbars()
	end)
	
	self.reverseWMMarksOrderChk = ELib:Check(self.TabViewOptions,L.MarksBarReverse,VExRT.MarksBar.MarksReverse):Point(480,-55):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.WMarksReverse = true
		else
			VExRT.MarksBar.WMarksReverse = nil
		end
		modifymarkbars()
	end)
	
	self.chkEnable4 = ELib:Check(self.TabViewOptions,L.marksbarshowrcpull,VExRT.MarksBar.Show[4]):Point(5,-80):OnClick(function(self)
		if self:GetChecked() then
			VExRT.MarksBar.Show[4]=true
		else
			VExRT.MarksBar.Show[4]=nil
		end
		modifymarkbars()
	end)
	
	self.SliderScale = ELib:Slider(self,L.marksbarscale):Size(640):Point("TOP",0,-290):Range(5,200):SetTo(VExRT.MarksBar.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.MarksBar.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.SliderAlpha = ELib:Slider(self,L.marksbaralpha):Size(640):Point("TOP",0,-320):Range(0,100):SetTo(VExRT.MarksBar.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.MarksBar.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	
	self.htmlTimer = ELib:Text(self,L.marksbartmr,11):Size(150,20):Point(5,-250)

	self.editBoxTimer = ELib:Edit(self,6,true):Size(120,20):Point(145,-250):Text(VExRT.MarksBar.pulltimer or "10"):OnChange(function(self)
		VExRT.MarksBar.pulltimer = tonumber(self:GetText()) or 10
	end)  
	
	self.frameStrataDropDown = ELib:DropDown(self,275,8):Point(5,-350):Size(260):SetText(L.S_Strata)
	local function FrameStrataDropDown_SetVaule(_,arg)
		VExRT.MarksBar.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.frameStrataDropDown.List do
			self.frameStrataDropDown.List[i].checkState = arg == self.frameStrataDropDown.List[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end
	for i,strataString in ipairs({"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}) do
		self.frameStrataDropDown.List[i] = {
			text = strataString,
			checkState = VExRT.MarksBar.Strata == strataString,
			radio = true,
			arg1 = strataString,
			func = FrameStrataDropDown_SetVaule,
		}
	end
	
	self.ButtonToCenter = ELib:Button(self,L.MarksBarResetPos):Size(260,22):Point(5,-375):Tooltip(L.MarksBarResetPosTooltip):OnClick(function()
		VExRT.MarksBar.Left = nil
		VExRT.MarksBar.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 
	
	self.shtml1 = ELib:Text(self,L.MarksBarHelp,12):Size(650,200):Point(5,-405):Top()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.MarksBar = VExRT.MarksBar or {}

	if VExRT.MarksBar.Left and VExRT.MarksBar.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.MarksBar.Left,VExRT.MarksBar.Top)
	end

	VExRT.MarksBar.Show = VExRT.MarksBar.Show or {true,true,true,true}

	modifymarkbars()

	if VExRT.MarksBar.enabled then
		EnableMarksBar()
	end

	VExRT.MarksBar.pulltimer = VExRT.MarksBar.pulltimer or 10

	if VExRT.MarksBar.Fix then ExRT.F.LockMove(module.frame,nil,nil,1) end

	if VExRT.MarksBar.Alpha then module.frame:SetAlpha(VExRT.MarksBar.Alpha/100) end
	if VExRT.MarksBar.Scale then module.frame:SetScale(VExRT.MarksBar.Scale/100) end
	
	VExRT.MarksBar.Strata = VExRT.MarksBar.Strata or "HIGH"
	module.frame:SetFrameStrata(VExRT.MarksBar.Strata)
	
	module:RegisterSlash()
end

function module.main:RAID_TARGET_UPDATE()
	if GetTime()-module.db.clearnum<5 and GetRaidTargetIndex("player") == 8 then
		SetRaidTarget("player", 0)
		module.db.clearnum = -1
	end
end

function module:GroupRosterUpdate()
	if not VExRT.MarksBar.enabled then
		return
	end

	local n = GetNumGroupMembers() or 0
	if n == 0 and module.frame:IsShown() then
		module.frame:Hide()
	elseif n > 0 and not module.frame:IsShown() then
		module.frame:Show()
	end
end
function module.main:GROUP_ROSTER_UPDATE()
	ExRT.F.ScheduleTimer(module.GroupRosterUpdate,1)
end

function module:slash(arg)
	if arg == "mm" or arg == "mb" then
		if not VExRT.MarksBar.enabled then
			EnableMarksBar()
		else
			DisableMarksBar()
		end
		if module.options.chkEnable then
			module.options.chkEnable:SetChecked(VExRT.MarksBar.enabled)
		end
	end
end