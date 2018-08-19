local GlobalAddonName, WQLdb = ...

local ELib = WQLdb.ELib

-- Enigma helper

local KirinTorQuests = {
	[43756]=true,	--VS
	[43772]=true,	--SH
	[43767]=true,	--HM
	[43328]=true,	--A
	[43778]=true,	--SU
}

local KirinTorPatt = {		--Patterns created by flow0284
	[1] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[20]=1,[23]=1,[24]=1,[25]=1,[26]=1,[27]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[2] = { [9]=1,[11]=1,[12]=1,[13]=1,[16]=1,[18]=1,[20]=1,[23]=1,[24]=1,[25]=1,[27]=1,[34]=1,[41]=2,},
	[3] = { [9]=1,[10]=1,[11]=1,[12]=1,[19]=1,[25]=1,[26]=1,[32]=1,[39]=1,[40]=1,[41]=2,},
	[4] = { [9]=1,[10]=1,[11]=1,[18]=1,[23]=1,[24]=1,[25]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[5] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[16]=1,[23]=1,[25]=1,[26]=1,[27]=1,[30]=1,[32]=1,[34]=1,[37]=1,[38]=1,[39]=1,[41]=2,},
	[6] = { [12]=1,[13]=1,[18]=1,[19]=1,[25]=1,[32]=1,[33]=1,[40]=1,[41]=2,},
	[7] = { [9]=1,[11]=1,[12]=1,[13]=1,[16]=1,[18]=1,[20]=1,[23]=1,[25]=1,[27]=1,[30]=1,[31]=1,[32]=1,[34]=1,[41]=2,},
	[8] = { [9]=1,[10]=1,[17]=1,[24]=1,[25]=1,[32]=1,[33]=1,[40]=1,[41]=2,},
	[9] = { [9]=1,[16]=1,[17]=1,[18]=1,[19]=1,[20]=1,[27]=1,[34]=1,[41]=2,},
	[10] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[16]=1,[23]=1,[24]=1,[25]=1,[26]=1,[33]=1,[40]=1,[41]=2,},
	[11] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[16]=1,[23]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[12] = { [11]=1,[12]=1,[13]=1,[18]=1,[23]=1,[24]=1,[25]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[13] = { [13]=1,[20]=1,[23]=1,[24]=1,[25]=1,[26]=1,[27]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
}

local KIRIN_TOR_SIZE = 7
local KirinTorSelecter_Big_BSize = 30
local KirinTorSelecter_Big_Size = KIRIN_TOR_SIZE * KirinTorSelecter_Big_BSize + 10

local KirinTorSelecter_BSize = 12
local KirinTorSelecter_Size = KIRIN_TOR_SIZE * KirinTorSelecter_BSize + 10

local KirinTorSelecter_Big = CreateFrame('Button',nil,UIParent)
KirinTorSelecter_Big:SetPoint("LEFT",30,0)
KirinTorSelecter_Big:SetSize(KirinTorSelecter_Big_Size,KirinTorSelecter_Big_Size)
KirinTorSelecter_Big:SetAlpha(.8)
ELib:CreateBorder(KirinTorSelecter_Big)
KirinTorSelecter_Big:SetBorderColor(0,0,0,0)

KirinTorSelecter_Big.back = KirinTorSelecter_Big:CreateTexture(nil,"BACKGROUND")
KirinTorSelecter_Big.back:SetAllPoints()
KirinTorSelecter_Big.back:SetColorTexture(0,0,0,1)
KirinTorSelecter_Big.T = {}
KirinTorSelecter_Big:Hide()
do
	local L = (KirinTorSelecter_Big_Size - KirinTorSelecter_Big_BSize * KIRIN_TOR_SIZE) / 2
	for j=0,KIRIN_TOR_SIZE-1 do
		for k=0,KIRIN_TOR_SIZE-1 do
			local t = KirinTorSelecter_Big:CreateTexture(nil,"ARTWORK")
			t:SetSize(KirinTorSelecter_Big_BSize,KirinTorSelecter_Big_BSize)
			t:SetPoint("TOPLEFT",L + k*KirinTorSelecter_Big_BSize,-L-j*KirinTorSelecter_Big_BSize)
			
			KirinTorSelecter_Big.T[ j*KIRIN_TOR_SIZE+k+1 ] = t
		end
		

		local l = KirinTorSelecter_Big:CreateTexture(nil,"OVERLAY")
		l:SetPoint("TOPLEFT",L+j*KirinTorSelecter_Big_BSize,-L)
		l:SetSize(1,KirinTorSelecter_Big_BSize*KIRIN_TOR_SIZE)
		l:SetColorTexture(0,0,0,.3)
	end
	for j=0,7 do
		local l = KirinTorSelecter_Big:CreateTexture(nil,"OVERLAY")
		l:SetPoint("TOPLEFT",L,-L-j*KirinTorSelecter_Big_BSize)
		l:SetSize(KirinTorSelecter_Big_BSize*KIRIN_TOR_SIZE,1)
		l:SetColorTexture(0,0,0,.3)	
	end
end



local KirinTorSelecter = CreateFrame('Frame',nil,UIParent)
KirinTorSelecter:SetPoint("LEFT",30,0)
KirinTorSelecter:SetSize(KirinTorSelecter_Size * 4,KirinTorSelecter_Size * 3)
KirinTorSelecter:SetAlpha(.7)
KirinTorSelecter:Hide()

KirinTorSelecter.back = KirinTorSelecter:CreateTexture(nil,"BACKGROUND")
KirinTorSelecter.back:SetAllPoints()
KirinTorSelecter.back:SetColorTexture(0,0,0,1)

for i=1,#KirinTorPatt do
	local b = CreateFrame('Button',nil,KirinTorSelecter)
	b:SetSize(KirinTorSelecter_Size,KirinTorSelecter_Size)
	b:SetPoint("TOPLEFT",((i-1)%4)*KirinTorSelecter_Size,-floor((i-1)/4)*KirinTorSelecter_Size)
	
	ELib:CreateBorder(b)
	b:SetBorderColor(0,0,0,1)
	b:SetScript("OnEnter",function(self)
		self:SetBorderColor(1,1,1,1)
	end)
	b:SetScript("OnLeave",function(self)
		self:SetBorderColor(0,0,0,1)
	end)
	b:SetScript("OnClick",function(self)
		for j=0,KIRIN_TOR_SIZE-1 do
			for k=0,KIRIN_TOR_SIZE-1 do
				local n = j*KIRIN_TOR_SIZE+k+1
				local c = KirinTorPatt[i][n]
				if c == 2 then
					KirinTorSelecter_Big.T[n]:SetColorTexture(0,1,0,1)
				elseif c then
					KirinTorSelecter_Big.T[n]:SetColorTexture(1,0,0,1)
				else
					KirinTorSelecter_Big.T[n]:SetColorTexture(1,.7,.4,1)
				end
			end
		end	
		KirinTorSelecter:Hide()
		KirinTorSelecter_Big:Show()
	end)
	
	local L = (KirinTorSelecter_Size - KirinTorSelecter_BSize * KIRIN_TOR_SIZE) / 2
	for j=0,KIRIN_TOR_SIZE-1 do
		for k=0,KIRIN_TOR_SIZE-1 do
			local t = b:CreateTexture(nil,"ARTWORK")
			t:SetSize(KirinTorSelecter_BSize,KirinTorSelecter_BSize)
			t:SetPoint("TOPLEFT",L + k*KirinTorSelecter_BSize,-L-j*KirinTorSelecter_BSize)
			
			local c = KirinTorPatt[i][ j*KIRIN_TOR_SIZE+k+1 ]
			if c == 2 then
				t:SetColorTexture(0,1,0,1)
			elseif c then
				t:SetColorTexture(1,0,0,1)
			else
				t:SetColorTexture(1,.7,.4,1)
			end
			
		end
	end
end

KirinTorSelecter.Close = CreateFrame('Button',nil,KirinTorSelecter)
KirinTorSelecter.Close:SetSize(10,10)
KirinTorSelecter.Close:SetPoint("BOTTOMRIGHT",KirinTorSelecter,"TOPRIGHT")
KirinTorSelecter.Close.Text = KirinTorSelecter.Close:CreateFontString(nil,"ARTWORK","GameFontWhite")
KirinTorSelecter.Close.Text:SetPoint("CENTER")
KirinTorSelecter.Close.Text:SetText("X")

KirinTorSelecter_Big:SetScript("OnClick",function (self)
	self:Hide()
  	KirinTorSelecter:Show()
end)


local KirinTorHelper = CreateFrame'Frame'
KirinTorHelper:RegisterEvent('QUEST_ACCEPTED')
KirinTorHelper:RegisterEvent('QUEST_REMOVED')
KirinTorHelper:SetScript("OnEvent",function(self,event,arg1,arg2)
	if event == 'QUEST_ACCEPTED' then
		if arg2 and KirinTorQuests[arg2] then
			if VWQL and not VWQL.EnableEnigma then
				print('"|cff00ff00/enigmahelper|r" - to see all patterns')
				return
			end
			print("世界任务列表：神秘莫测助手已加载")
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	elseif event == 'QUEST_REMOVED' then
		if arg1 and KirinTorQuests[arg1] then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local timestamp,arg2,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId = CombatLogGetCurrentEventInfo()

		if arg2 == "SPELL_AURA_APPLIED" and spellId == 219247 and destGUID == UnitGUID'player' then
			KirinTorSelecter:Show()
		elseif arg2 == "SPELL_AURA_REMOVED" and spellId == 219247 and destGUID == UnitGUID'player' then
			KirinTorSelecter:Hide()
			KirinTorSelecter_Big:Hide()
		end
	end
end)

KirinTorSelecter.Close:SetScript("OnClick",function ()
	KirinTorSelecter:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	KirinTorSelecter:Hide()
end)

SlashCmdList["WQLEnigmaSlash"] = function() 
	KirinTorHelper:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	KirinTorSelecter:Show()
end
SLASH_WQLEnigmaSlash1 = "/enigmahelper"


-- Barrels o' Fun

local BarrelsHelperQuests = {
	[45070]=true,	--Valsh
	[45068]=true,	--Suramar
	[45069]=true,	--Azuna
	[45071]=true,	--Highm
	[45072]=true,	--Stormh
}
local BarrelsHelper_guid = {}
local BarrelsHelper_count = 8

local BarrelsHelper = CreateFrame'Frame'
BarrelsHelper:RegisterEvent('QUEST_ACCEPTED')
BarrelsHelper:RegisterEvent('QUEST_REMOVED')
BarrelsHelper:RegisterEvent('PLAYER_ENTERING_WORLD')
BarrelsHelper:SetScript("OnEvent",function(self,event,arg1,arg2)
	if event == 'QUEST_ACCEPTED' then
		if arg2 and BarrelsHelperQuests[arg2] then
			if VWQL and VWQL.DisableBarrels then
				return
			end
			print("世界任务列表：欢乐桶助手已加载")
			BarrelsHelper_count = 8
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end
	elseif event == 'QUEST_REMOVED' then
		if arg1 and BarrelsHelperQuests[arg1] then
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			BarrelsHelper_count = 8
		end
	elseif event == 'UPDATE_MOUSEOVER_UNIT' then
		local guid = UnitGUID'mouseover'
		if guid then
			local type,_,serverID,instanceID,zoneUID,id,spawnID = strsplit("-", guid)
			if id == "115947" then
				if not BarrelsHelper_guid[guid] then
					BarrelsHelper_guid[guid] = BarrelsHelper_count
					BarrelsHelper_count = BarrelsHelper_count - 1
					if BarrelsHelper_count < 1 then
						BarrelsHelper_count = 8
					end
				end
				if GetRaidTargetIndex("mouseover") ~= BarrelsHelper_guid[guid] then
					SetRaidTarget("mouseover", BarrelsHelper_guid[guid])
				end
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if VWQL and VWQL.DisableBarrels then
			return
		end
		for i=1,GetNumQuestLogEntries() do
			local title, _, _, _, _, _, _, questID = GetQuestLogTitle(i)
			if questID and BarrelsHelperQuests[questID] then
				BarrelsHelper_count = 8
				self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
				break
			end
		end
	end
end)

SlashCmdList["WQLBarrelsSlash"] = function(arg) 
	arg = (arg or ""):lower()
	if arg == "off" or arg == "on" then
		if not VWQL then
			return
		end
		VWQL.DisableBarrels = not VWQL.DisableBarrels
		if VWQL.DisableBarrels then
			print("Barrels helper disabled")
			BarrelsHelper:UnregisterEvent('UPDATE_MOUSEOVER_UNIT')
		else
			print("Barrels helper enabled")
		end
	elseif arg == "load" then
		BarrelsHelper:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		print("Barrels helper loaded")
	else
		print("Commands:")
		print("/barrelshelper on")
		print("/barrelshelper off")
		print("/barrelshelper load")
	end
end
SLASH_WQLBarrelsSlash1 = "/barrelshelper"


-- Shell Game
do
	local ShellGameQuests = {
		[51625]=true,
		[51626]=true,
		[51627]=true,
		[51628]=true,
		[51629]=true,
		[51630]=true,
	}
	
--[[
фиол пилон	71324
валькирия	73430	73591
краб-пират	87999	75367
шар		71960	72772
капля		81077	81388
черепаха	81098
робот		72873	31549
челюсти		67537	76371	81664

63509	- arrow
75066   - quest
46201	- bomb
47270 	- kirintor
]]
	
	local size,center = 200,30
	
	local modelIDs = {71324,73430,87999,71960,81077,81098,72873,67537}
	
	local ShellGameDisable
	local ShellGameIsCreated
	
	local UpdatePos,ResizeFrame,CenterFrame,OkButton,pointsFrames,CloseButton
	
	local function CreateShellGame()
		if ShellGameIsCreated then
			return
		end
		ShellGameIsCreated = true
		local function SmallModelOnMouseDown(self)
			self:GetParent().M:SetDisplayInfo(self.modelID)
		end
		local function SmallModelOnEnter(self)
			self.b:SetColorTexture(0.74,0.74,0.74,.2)
		end
		local function SmallModelOnLeave(self)
			self.b:SetColorTexture(0.04,0.04,0.04,0)
		end
		local function PuzzleFrameOnUpdate(self)
			if MouseIsOver(self) and not self.Mstatus then
				self.Mstatus = true
				for j=1,8 do
					self.m[j]:Show()
				end
			elseif not MouseIsOver(self) and self.Mstatus then
				self.Mstatus = false
				for j=1,8 do
					self.m[j]:Hide()
				end
			end
		end
		
		pointsFrames = {}
		for i=1,16 do
			local frame = CreateFrame("Frame",nil,UIParent)
			pointsFrames[i] = frame
			
			frame.M = CreateFrame("PlayerModel",nil,frame)
			frame.M:SetPoint("TOP")
			frame.M:SetMouseClickEnabled(false)
			frame.M:SetMouseMotionEnabled(false)
			
			frame.m = {}
			for j=1,8 do
				local m=CreateFrame("PlayerModel",nil,frame)
				frame.m[j] = m
				m:SetDisplayInfo(modelIDs[j])
				m.modelID = modelIDs[j]
				if j==1 then
					m:SetPoint("TOPLEFT")
				elseif j == 5 then
					m:SetPoint("TOPRIGHT")
				else
					m:SetPoint("TOP",frame.m[j-1],"BOTTOM")
				end
				m:Hide()
				m:SetScript("OnMouseDown",SmallModelOnMouseDown)
				m:SetScript("OnEnter",SmallModelOnEnter)
				m:SetScript("OnLeave",SmallModelOnLeave)
				
				m.b = m:CreateTexture(nil,"BACKGROUND")
				m.b:SetAllPoints()
			end
			
			frame:SetScript("OnUpdate",PuzzleFrameOnUpdate)	
			
			frame:Hide()
		end
		
		OkButton = CreateFrame("Button",nil,UIParent,"UIPanelButtonTemplate")
		OkButton:SetSize(120,20)
		OkButton:SetText("世界任务列表：锁定")
		OkButton:Hide()
		
		CloseButton = CreateFrame("Button",nil,UIParent,"UIPanelButtonTemplate")
		CloseButton:SetSize(120,20)
		CloseButton:SetPoint("TOP",OkButton,"BOTTOM")
		CloseButton:SetText(CLOSE)
		CloseButton:SetScript("OnClick",function()
			ShellGameDisable()
		end)
		CloseButton:Hide()
		
		ResizeFrame = CreateFrame("Frame",nil,UIParent)
		ResizeFrame:SetPoint("TOP",200,0)
		ResizeFrame:SetPoint("BOTTOM",200,0)
		ResizeFrame:SetWidth(8)
		ResizeFrame:Hide()
		
		ResizeFrame.b = ResizeFrame:CreateTexture(nil,"BACKGROUND")
		ResizeFrame.b:SetAllPoints()
		ResizeFrame.b:SetColorTexture(0.04,0.04,0.04,.9)
		
		ResizeFrame.lv,ResizeFrame.lh = {},{}
		for i=1,5 do
			ResizeFrame.lv[i] = ResizeFrame:CreateTexture(nil,"BACKGROUND")
			ResizeFrame.lv[i]:SetColorTexture(0.04,0.04,0.04,.9)
			ResizeFrame.lv[i]:SetWidth(3)
		
			ResizeFrame.lh[i] = ResizeFrame:CreateTexture(nil,"BACKGROUND")
			ResizeFrame.lh[i]:SetColorTexture(0.04,0.04,0.04,.9)
			ResizeFrame.lh[i]:SetHeight(3)
		end
		
		function UpdatePos(updateResizers)
			if updateResizers then
				ResizeFrame:SetPoint("TOP",size,0)
				ResizeFrame:SetPoint("BOTTOM",size,0)
				CenterFrame:SetPoint("LEFT",0,center)
				CenterFrame:SetPoint("RIGHT",0,center)
			end
			for i=1,5 do
				ResizeFrame.lh[i]:ClearAllPoints()
				ResizeFrame.lh[i]:SetPoint("CENTER",UIParent,0,(i == 1 and size or i==2 and size / 2 or i==3 and 0 or i==4 and -size / 2 or i==5 and -size)+center)
				ResizeFrame.lh[i]:SetWidth(size*2)
		
				ResizeFrame.lv[i]:ClearAllPoints()
				ResizeFrame.lv[i]:SetPoint("CENTER",UIParent,i == 1 and -size or i==2 and -size / 2 or i==3 and 0 or i==4 and size / 2 or i==5 and size,center)
				ResizeFrame.lv[i]:SetHeight(size*2)
			end
			for i=1,4 do
				for j=1,4 do
					local frame = pointsFrames[(i-1)*4+j]
					frame:ClearAllPoints()
					frame:SetPoint("TOPLEFT",UIParent,"CENTER",j==1 and -size or j==2 and -size/2 or j==3 and 0 or j==4 and size/2,(i==1 and size or i==2 and size/2 or i==3 and 0 or i==4 and -size/2)+center)
					frame:SetSize(size/2,size/2)
					for k=1,8 do
						frame.m[k]:SetSize(size/4/2,size/4/2)
					end
					frame.M:SetSize(size/4,size/4)
				end
			end
			OkButton:SetPoint("TOPRIGHT",UIParent,"CENTER",size,center-size)
		end
		
		local function ResizeFrameOnUpdate(self)
			size = self:GetLeft() - GetScreenWidth() / 2
			VWQL.ShellGameSize = size
			UpdatePos()
		end
		
		ResizeFrame:EnableMouse(true)
		ResizeFrame:SetMovable(true)
		ResizeFrame:RegisterForDrag("LeftButton")
		ResizeFrame:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
				self:SetScript("OnUpdate", ResizeFrameOnUpdate)
			end
		end)
		ResizeFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			self:SetScript("OnUpdate", nil)
		end)
		
		ResizeFrame:SetClampedToScreen(true)
		ResizeFrame:SetClampRectInsets(-GetScreenWidth() / 2 - 1, 0, 0, 0)
		
		ResizeFrame.ArrowHelp1 = CreateFrame("PlayerModel",nil,ResizeFrame)
		ResizeFrame.ArrowHelp1:SetPoint("TOPRIGHT",-5,-10)
		ResizeFrame.ArrowHelp1:SetSize(48,48)
		ResizeFrame.ArrowHelp1:SetMouseClickEnabled(false)
		ResizeFrame.ArrowHelp1:SetMouseMotionEnabled(false)
		ResizeFrame.ArrowHelp1:SetDisplayInfo(63509)
		ResizeFrame.ArrowHelp1:SetRoll(-math.pi / 2)
	
		ResizeFrame.ArrowHelp2 = CreateFrame("PlayerModel",nil,ResizeFrame)
		ResizeFrame.ArrowHelp2:SetPoint("TOPLEFT",5,-10)
		ResizeFrame.ArrowHelp2:SetSize(48,48)
		ResizeFrame.ArrowHelp2:SetMouseClickEnabled(false)
		ResizeFrame.ArrowHelp2:SetMouseMotionEnabled(false)
		ResizeFrame.ArrowHelp2:SetDisplayInfo(63509)
		ResizeFrame.ArrowHelp2:SetRoll(math.pi / 2)
		
		ResizeFrame:SetFrameStrata("DIALOG")
		
		CenterFrame = CreateFrame("Frame",nil,UIParent)
		CenterFrame:SetPoint("LEFT",0,0)
		CenterFrame:SetPoint("RIGHT",0,0)
		CenterFrame:SetHeight(6)
		CenterFrame:Hide()
		
		CenterFrame.b = CenterFrame:CreateTexture(nil,"BACKGROUND")
		CenterFrame.b:SetAllPoints()
		CenterFrame.b:SetColorTexture(0.04,0.04,0.04,.9)
		
		local function OnUpdateCenter(self)
			center = self:GetTop() - GetScreenHeight() / 2
			VWQL.ShellGameCenter = center
			UpdatePos()
		end
		
		CenterFrame:EnableMouse(true)
		CenterFrame:SetMovable(true)
		CenterFrame:RegisterForDrag("LeftButton")
		CenterFrame:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
				self:SetScript("OnUpdate", OnUpdateCenter)
			end
		end)
		CenterFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			self:SetScript("OnUpdate", nil)
		end)
		
		CenterFrame:SetClampedToScreen(true)
		CenterFrame:SetClampRectInsets(0, 0, 0, 0)
		
		CenterFrame.ArrowHelp1 = CreateFrame("PlayerModel",nil,CenterFrame)
		CenterFrame.ArrowHelp1:SetPoint("BOTTOMLEFT",CenterFrame,"TOPLEFT",10,5)
		CenterFrame.ArrowHelp1:SetSize(48,48)
		CenterFrame.ArrowHelp1:SetMouseClickEnabled(false)
		CenterFrame.ArrowHelp1:SetMouseMotionEnabled(false)
		CenterFrame.ArrowHelp1:SetDisplayInfo(63509)
		CenterFrame.ArrowHelp1:SetRoll(-math.pi)
	
		CenterFrame.ArrowHelp2 = CreateFrame("PlayerModel",nil,CenterFrame)
		CenterFrame.ArrowHelp2:SetPoint("TOPLEFT",CenterFrame,"BOTTOMLEFT",10,-5)
		CenterFrame.ArrowHelp2:SetSize(48,48)
		CenterFrame.ArrowHelp2:SetMouseClickEnabled(false)
		CenterFrame.ArrowHelp2:SetMouseMotionEnabled(false)
		CenterFrame.ArrowHelp2:SetDisplayInfo(63509)
		--CenterFrame.ArrowHelp2:SetRoll(math.pi)
		
		OkButton:SetScript("OnClick",function(self)
			if ResizeFrame:IsShown() then
				ResizeFrame:Hide()
				CenterFrame:Hide()
				VWQL.ShellGameLocked = true
				self:SetText("WQL: Resize")
			else
				ResizeFrame:Show()
				CenterFrame:Show()
				self:SetText("WQL: Lock")
			end
		end)
	end
		
	local function ShellGameEnable()
		CreateShellGame()
		print("世界任务列表：龟壳游戏助手已加载，拖动两根粗线缩放")
		size,center = VWQL.ShellGameSize or size,VWQL.ShellGameCenter or center
		UpdatePos(true)
		if not VWQL.ShellGameLocked then
			ResizeFrame:Show()
			CenterFrame:Show()
			OkButton:SetText("WQL: Lock")
		else
			OkButton:SetText("WQL: Resize")	
		end
		for i=1,16 do
			pointsFrames[i]:Show()
			pointsFrames[i].M:ClearModel()
		end
		OkButton:Show()
		CloseButton:Show()
	end
	function ShellGameDisable()
		CreateShellGame()
		ResizeFrame:Hide()
		CenterFrame:Hide()
		for i=1,16 do
			pointsFrames[i]:Hide()
		end
		OkButton:Hide()
		CloseButton:Hide()
	end
	
	WQLdb.ToMain = WQLdb.ToMain or {}
	WQLdb.ToMain.ShellGameEnable = ShellGameEnable
	WQLdb.ToMain.ShellGameDisable = ShellGameDisable
	
	local ShellGameHelper = CreateFrame'Frame'
	ShellGameHelper:RegisterEvent('QUEST_ACCEPTED')
	ShellGameHelper:RegisterEvent('QUEST_REMOVED')
	ShellGameHelper:RegisterEvent('PLAYER_ENTERING_WORLD')
	ShellGameHelper:SetScript("OnEvent",function(self,event,arg1,arg2)
		if event == 'QUEST_ACCEPTED' then
			if arg2 and ShellGameQuests[arg2] then
				if VWQL and VWQL.DisableShellGame then
					return
				end
				self:RegisterEvent('UNIT_ENTERED_VEHICLE')
				self:RegisterEvent('UNIT_EXITED_VEHICLE')
			end
		elseif event == 'QUEST_REMOVED' then
			if arg1 and ShellGameQuests[arg1] then
				ShellGameDisable()
				self:UnregisterEvent('UNIT_ENTERED_VEHICLE')
				self:UnregisterEvent('UNIT_EXITED_VEHICLE')
			end
		elseif event == 'UNIT_ENTERED_VEHICLE' then
			if arg1 ~= "player" then
				return
			end
			ShellGameEnable()			
		elseif event == 'UNIT_EXITED_VEHICLE' then
			if arg1 ~= "player" then
				return
			end
			ShellGameDisable()
		elseif event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			if VWQL and VWQL.DisableShellGame then
				return
			end
			for i=1,GetNumQuestLogEntries() do
				local title, _, _, _, _, _, _, questID = GetQuestLogTitle(i)
				if questID and ShellGameQuests[questID] then
					return self:GetScript("OnEvent")(self,'QUEST_ACCEPTED',i,questID)
				end
			end
		end
	end)
end
