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
	local modelsFrame
	
	local function CreateShellGame()
		if ShellGameIsCreated then
			return
		end
		ShellGameIsCreated = true
		local function SmallModelOnMouseDown(self)
			self:GetParent().P.M:SetDisplayInfo(self.modelID)
		end
		local function SmallModelOnEnter(self)
			self.b:SetColorTexture(0.74,0.74,0.74,.2)
		end
		local function SmallModelOnLeave(self)
			self.b:SetColorTexture(0.04,0.04,0.04,0)
		end
		
		modelsFrame = CreateFrame("Frame",nil,UIParent)
		modelsFrame.m = {}
		for j=1,#modelIDs do
			local m=CreateFrame("PlayerModel",nil,modelsFrame)
			modelsFrame.m[j] = m
			m:SetDisplayInfo(modelIDs[j])
			m.modelID = modelIDs[j]
			if j==1 then
				m:SetPoint("TOPLEFT")
			elseif j == 5 then
				m:SetPoint("TOPRIGHT")
			else
				m:SetPoint("TOP",modelsFrame.m[j-1],"BOTTOM")
			end
			m:Hide()
			m:SetScript("OnMouseDown",SmallModelOnMouseDown)
			m:SetScript("OnEnter",SmallModelOnEnter)
			m:SetScript("OnLeave",SmallModelOnLeave)
			
			m.b = m:CreateTexture(nil,"BACKGROUND")
			m.b:SetAllPoints()
		end	
		modelsFrame:Hide()

		local function ModelsFrameOnUpdate(self)
			if MouseIsOver(self) and not self.Mstatus then
				self.Mstatus = true
				for j=1,8 do
					modelsFrame.m[j]:Show()
				end
			elseif not MouseIsOver(self) and self.Mstatus then
				self.Mstatus = false
				for j=1,8 do
					modelsFrame.m[j]:Hide()
				end
			end
		end
		modelsFrame:SetScript("OnUpdate",ModelsFrameOnUpdate)

		local function PuzzleFrameOnUpdate(self)
			if MouseIsOver(self) and modelsFrame.P ~= self then
				modelsFrame.P = self
				modelsFrame:ClearAllPoints()
				modelsFrame:SetPoint("CENTER",self)
				modelsFrame:Show()		
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
					frame.M:SetSize(size/4,size/4)
				end
			end
			modelsFrame:SetSize(size/2,size/2)
			for k=1,#modelIDs do
				modelsFrame.m[k]:SetSize(size/4/2,size/4/2)
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
		do return end
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
		do return end	
		CreateShellGame()
		ResizeFrame:Hide()
		CenterFrame:Hide()
		for i=1,16 do
			pointsFrames[i]:Hide()
		end
		OkButton:Hide()
		CloseButton:Hide()
		modelsFrame:Hide()
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


-----------------------------------------
-- Calligraphy helper
-----------------------------------------
local Calligraphy = {}

function Calligraphy:Load()
	local frame = Calligraphy.mainframe
	if frame then
		frame:Show()
		frame.isEnabled = true
		return
	end

	local FRAME_SIZE = 200
	local VECTOR_DEPTH = 0.75
	local VIEW_DISTANCE = 15
	local VIEW_DISTANCE2 = VIEW_DISTANCE * 2
	local LINES_COLORS = {
		[1] = {r = 0.6, g = 1, b = 0.6, a = 1},
		[2] = {r = 1, g= .5, b = 0, a = 1},
		[3] = {r = 1, g = 0.6, b = 0.6, a = 1},
		[4] = {r = 0.2, g = 0.6, b = 0.85, a = 1},
	}

	frame = CreateFrame("Frame",nil,UIParent)
	Calligraphy.mainframe = frame
	frame:SetSize(FRAME_SIZE,FRAME_SIZE)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VWQL.CalligraphyLeft = self:GetLeft()
		VWQL.CalligraphyTop = self:GetTop()
	end)
	if VWQL and VWQL.CalligraphyLeft and VWQL.CalligraphyTop then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VWQL.CalligraphyLeft,VWQL.CalligraphyTop)
	else
		frame:SetPoint("CENTER",-200,0)
	end

	function Calligraphy:Close()
		frame:Hide()
		frame.isEnabled = false
	end
		
	frame.isEnabled = true

	frame.close = CreateFrame("Button",nil,frame)
	frame.close:SetPoint("TOPRIGHT",0,-2)
	frame.close:SetSize(14,14)
	frame.close.text = frame.close:CreateFontString(nil,"ARTWORK","GameFontWhite")
	frame.close.text:SetPoint("CENTER")
	frame.close.text:SetText("X")
	frame.close:SetScript("OnClick",function(self)
		self:GetParent():Hide()
	end)
	frame.close:SetScript("OnEnter",function(self)
		self.text:SetTextColor(1,.4,.7,1)
	end)
	frame.close:SetScript("OnLeave",function(self)
		self.text:SetTextColor(1,1,1,1)
	end)
	
	frame.back = frame:CreateTexture(nil, "BACKGROUND")
	frame.back:SetColorTexture(.7,.7,.7,.4)
	frame.back:SetAllPoints()
	
	frame.player = frame:CreateTexture(nil, "OVERLAY")
	frame.player:SetSize(32,32)
	frame.player:SetPoint("CENTER",0,-FRAME_SIZE/6)
	frame.player:SetTexture("Interface\\MINIMAP\\MinimapArrow")
	frame.player:SetAlpha(.8)

	frame.playerfaceline = frame:CreateLine(nil, "OVERLAY", nil, -1)
	frame.playerfaceline:SetColorTexture(1, 1, 1, .3)
	frame.playerfaceline:SetThickness(2)
	frame.playerfaceline:SetStartPoint("CENTER",0,-FRAME_SIZE/6)
	frame.playerfaceline:SetEndPoint("TOP",0,0)

	ELib:Shadow(frame,15,20)
	
	frame.lines = {}
	local SetLine,RotateCoordPair
	do
		local cos, sin = math.cos, math.sin
		function RotateCoordPair(x,y,ox,oy,a,asp)
			y=y/asp
			oy=oy/asp
			return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
		end
		function SetLine(i,fX,fY,tX,tY,c)
			local line = frame.lines[i]
			if not line then
				line = frame:CreateLine(nil, "BORDER", nil, 5)
				frame.lines[i] = line
				line:SetColorTexture(0.6, 1, 0.6, 1)
				line:SetThickness(5)
			end
			line:SetStartPoint("BOTTOMLEFT",frame,fX,fY)
			line:SetEndPoint("BOTTOMLEFT",frame,tX,tY)
			line:SetAlpha(1)

			c = c or 1
			local color_list = LINES_COLORS[c]
			line:SetColorTexture(color_list.r, color_list.g, color_list.b, color_list.a)
			
			if c == 2 then
				line:SetDrawLayer("BORDER", 6)
			elseif c == 3 then
				line:SetDrawLayer("BORDER", 5)
			else
				line:SetDrawLayer("BORDER", 4)
			end
		end
	end
			
	local function GetContactPosition(x1,x2,x3,x4,y1,y2,y3,y4)
		local d = (x1-x2)*(y4-y3) - (y1-y2)*(x4-x3)
		local da= (x1-x3)*(y4-y3) - (y1-y3)*(x4-x3)
		local db= (x1-x2)*(y1-y3) - (y1-y2)*(x1-x3)
		
		local ta,tb=da/d,db/d
		
		if ta >= 0 and ta <= 1 and tb >=0 and tb <= 1 then
			local x=x1 + ta *(x2 - x1)
			local y=y1 + ta *(y2 - y1)
			
			return x,y
		end
	end
	
	local function IsDotIn(pX,pY,point1x,point2x,point3x,point4x,point1y,point2y,point3y,point4y)
		local D1 = (pX - point1x) * (point2y - point1y) - (pY - point1y) * (point2x - point1x)	--1,2
		local D2 = (pX - point2x) * (point3y - point2y) - (pY - point2y) * (point3x - point2x)	--2,3
		local D3 = (pX - point3x) * (point4y - point3y) - (pY - point3y) * (point4x - point3x)	--3,4
		local D4 = (pX - point4x) * (point1y - point4y) - (pY - point4y) * (point1x - point4x)	--4,1

		return (D1 < 0 and D2 < 0 and D3 < 0 and D4 < 0) or (D1 > 0 and D2 > 0 and D3 > 0 and D4 > 0)
	end
	
	local function dist(x1,y1,x2,y2)
		local dX = (x1 - x2)
		local dY = (y1 - y2)
		return sqrt(dX * dX + dY * dY)
	end
	local c_dist = dist
	local function dist_dot(x0,y0,x1,y1,x2,y2)
		local r1 = dist(x0,y0,x1,y1)
		local r2 = dist(x0,y0,x2,y2)
		local r12 = dist(x1,y1,x2,y2)
		
  		local a = y2 - y1
  		local b = x1 - x2
  		local c = - x1 * (y2 - y1) + y1 * (x2 - x1)
  		
  		local t = dist(a,b,0,0)
  		if c > 0 then
  			a = -a
  			b = -b
  			c = -c
  		end
  		return (a*x0+b*y0+c)/t
	end

	local LinesSetup = {}
	function Calligraphy:UpdateLinesSetup(zone)
		if zone == 1 then	--Zuldazar
			LinesSetup = {
				{y1=-1936.8,x1=1222.4,y2=-1924.5,x2=1238.2},
				{y1=-1944.1,x1=1240.5,y2=-1924.5,x2=1238.2},
				{y1=-1936.8,x1=1222.4,y2=-1944.1,x2=1240.5},
			}
		elseif zone == 2 then	--Nazmir
			--/dump sqrt((1360.6-1378.3)^2 + (2008.3-1998.8)^2)
			--1360.6;2008.3
			--1378.3;1998.8
			LinesSetup = {
				{x1=1379.45,y1=2003.55,x2=1378.1102540378,y2=2008.55},
				{x1=1378.1102540378,y1=2008.55,x2=1374.45,y2=2012.2102540378},
				{x1=1374.45,y1=2012.2102540378,x2=1369.45,y2=2013.55},
				{x1=1369.45,y1=2013.55,x2=1364.45,y2=2012.2102540378},
				{x1=1364.45,y1=2012.2102540378,x2=1360.7897459622,y2=2008.55},
				{x1=1360.7897459622,y1=2008.55,x2=1359.45,y2=2003.55},
				{x1=1359.45,y1=2003.55,x2=1360.7897459622,y2=1998.55},
				{x1=1360.7897459622,y1=1998.55,x2=1364.45,y2=1994.8897459622},
				{x1=1364.45,y1=1994.8897459622,x2=1369.45,y2=1993.55},
				{x1=1369.45,y1=1993.55,x2=1374.45,y2=1994.8897459622},
				{x1=1374.45,y1=1994.8897459622,x2=1378.1102540378,y2=1998.55},
				{x1=1378.1102540378,y1=1998.55,x2=1379.45,y2=2003.55},
			}
		elseif zone == 3 then	--Voldun
			LinesSetup = {
				{y1=2037.8,x1=4793.3,y2=2036.3,x2=4808.0},
				{y1=2036.3,x1=4808.0,y2=2021.4,x2=4806.6},
				{y1=2021.4,x1=4806.6,y2=2023.2,x2=4791.7},
				{y1=2037.8,x1=4793.3,y2=2023.2,x2=4791.7},
			}
		elseif zone == 4 then	--Dru
			LinesSetup = {
				{y1=-40.2,x1=2059.1,y2=-25.2,x2=2058.5},
				{y1=-25.2,x1=2058.5,y2=-24.5,x2=2073.6},
				{y1=-24.5,x1=2073.6,y2=-39.7,x2=2074.2},
				{y1=-39.7,x1=2074.2,y2=-40.2,x2=2059.1},
			}
		elseif zone == 5 then	--Tir
			LinesSetup = {
				{x1=747.3,y1=-741.35,x2=745.96025403784,y2=-736.35},
				{x1=745.96025403784,y1=-736.35,x2=742.3,y2=-732.68974596216},
				{x1=742.3,y1=-732.68974596216,x2=737.3,y2=-731.35},
				{x1=737.3,y1=-731.35,x2=732.3,y2=-732.68974596216},
				{x1=732.3,y1=-732.68974596216,x2=728.63974596216,y2=-736.35},
				{x1=728.63974596216,y1=-736.35,x2=727.3,y2=-741.35},
				{x1=727.3,y1=-741.35,x2=728.63974596216,y2=-746.35},
				{x1=728.63974596216,y1=-746.35,x2=732.3,y2=-750.01025403784},
				{x1=732.3,y1=-750.01025403784,x2=737.3,y2=-751.35},
				{x1=737.3,y1=-751.35,x2=742.3,y2=-750.01025403784},
				{x1=742.3,y1=-750.01025403784,x2=745.96025403784,y2=-746.35},
				{x1=745.96025403784,y1=-746.35,x2=747.3,y2=-741.35},
			}
		elseif zone == 6 then	--Storm
			LinesSetup = {
				{y1=3347.8,x1=1363.4,y2=3334.5,x2=1348.7},
				{y1=3334.5,x1=1348.7,y2=3354.2,x2=1344.6},
				{y1=3354.2,x1=1344.6,y2=3347.8,x2=1363.4},
			}
		elseif zone == 10 then	--Test circle
			--[[
				local X,Y,R,N=-1390,836,5,10 for i=0,N-1 do local x,y=X+R*cos(360/N*i),Y+R*sin(360/N*i)print(i+1,x,y)JJBox("{x="..x..",y="..y.."},") end

				local X,Y,R,N=1369.45,2003.55,10,12 for i=0,N-1 do local x1,y1,x2,y2=X+R*cos(360/N*i),Y+R*sin(360/N*i),X+R*cos(360/N*(i+1)),Y+R*sin(360/N*(i+1))print(i+1,x1,y1,x2,y2)JJBox("{x1="..x1..",y1="..y1..",x2="..x2..",y2="..y2.."},") end
			]]
			LinesSetup = {
				{x1=-1380,y1=-836,x2=-1381.3397459622,y2=-831},
				{x1=-1381.3397459622,y1=-831,x2=-1385,y2=-827.33974596216},
				{x1=-1385,y1=-827.33974596216,x2=-1390,y2=-826},
				{x1=-1390,y1=-826,x2=-1395,y2=-827.33974596216},
				{x1=-1395,y1=-827.33974596216,x2=-1398.6602540378,y2=-831},
				{x1=-1398.6602540378,y1=-831,x2=-1400,y2=-836},
				{x1=-1400,y1=-836,x2=-1398.6602540378,y2=-841},
				{x1=-1398.6602540378,y1=-841,x2=-1395,y2=-844.66025403784},
				{x1=-1395,y1=-844.66025403784,x2=-1390,y2=-846},
				{x1=-1390,y1=-846,x2=-1385,y2=-844.66025403784},
				{x1=-1385,y1=-844.66025403784,x2=-1381.3397459622,y2=-841},
				{x1=-1381.3397459622,y1=-841,x2=-1380,y2=-836},
			}
		end
	end
	
	local trottle = 0
	frame:SetScript("OnUpdate",function(self,elapsed)
		trottle = trottle + elapsed
		if trottle > 0.02 then
			trottle = 0
			local playerY,playerX = UnitPosition('player')
			if not playerY then
				return
			end
			
			local tLx,tLy,tRx,tRy,bRx,bRy,bLx,bLy = playerX + VIEW_DISTANCE,playerY + VIEW_DISTANCE * 1.33,playerX - VIEW_DISTANCE,playerY + VIEW_DISTANCE * 1.33,playerX - VIEW_DISTANCE, playerY - VIEW_DISTANCE * 0.67,playerX + VIEW_DISTANCE,playerY - VIEW_DISTANCE * 0.67
			
			local angle = -GetPlayerFacing()
			tLx,tLy = RotateCoordPair(tLx,tLy,playerX,playerY,angle,1)
			tRx,tRy = RotateCoordPair(tRx,tRy,playerX,playerY,angle,1)
			bRx,bRy = RotateCoordPair(bRx,bRy,playerX,playerY,angle,1)
			bLx,bLy = RotateCoordPair(bLx,bLy,playerX,playerY,angle,1)
			
			
			for i=1,#self.lines do
				frame.lines[i]:SetAlpha(0)
			end
			
			local count = 0
			local countText = 0
			local onPath = false
			

			for _,linePositions in pairs(LinesSetup) do
				local sourceY,sourceX = linePositions.y1,linePositions.x1
				local targetY,targetX = linePositions.y2,linePositions.x2
				if not (sourceX == targetX and sourceY == targetY) and sourceX and targetX then
					local dX = (sourceX - targetX)
					local dY = (sourceY - targetY)
					local dist = sqrt(dX * dX + dY * dY)
					
					local t_cos = (targetX-sourceX) / dist
					local t_sin = (targetY-sourceY) / dist
					
					local radiusX,radiusY = VECTOR_DEPTH * t_sin, VECTOR_DEPTH * t_cos
					
					local point1x = sourceX + radiusX
					local point1y = sourceY - radiusY
					
					local point2x = sourceX - radiusX
					local point2y = sourceY + radiusY
					
					local point3x = targetX + radiusX
					local point3y = targetY - radiusY
					
					local point4x = targetX - radiusX
					local point4y = targetY + radiusY
	
				
					local xS,yS,xE,yE = sourceX,sourceY,targetX,targetY
					
					local x1,y1,x2,y2 = nil
	
					local cx1,cy1 = GetContactPosition(xS,xE,tLx,tRx,yS,yE,tLy,tRy)
					local cx2,cy2 = GetContactPosition(xS,xE,tRx,bRx,yS,yE,tRy,bRy)
					local cx3,cy3 = GetContactPosition(xS,xE,bLx,bRx,yS,yE,bLy,bRy)
					local cx4,cy4 = GetContactPosition(xS,xE,tLx,bLx,yS,yE,tLy,bLy)
					
					if cx1 then
						x1,y1 = cx1,cy1
					end
					if cx2 then
						if x1 then
							x2,y2 = cx2,cy2
						else
							x1,y1 = cx2,cy2
						end
					end
					if cx3 then
						if x1 then
							x2,y2 = cx3,cy3
						else
							x1,y1 = cx3,cy3
						end
					end
					if cx4 then
						if x1 then
							x2,y2 = cx4,cy4
						else
							x1,y1 = cx4,cy4
						end
					end			
								
					if IsDotIn(xS,yS,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) then
						if not x1 then
							x1,y1 = xS,yS
						else
							x2,y2 = xS,yS
						end
					end
					
					if IsDotIn(xE,yE,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) then
						if not x1 then
							x1,y1 = xE,yE
						else
							x2,y2 = xE,yE
						end
					end
					
					local isOnLine = IsDotIn(playerX,playerY,point1x,point2x,point4x,point3x,point1y,point2y,point4y,point3y)
						or (c_dist(playerX,playerY,sourceX,sourceY) < VECTOR_DEPTH)
						or (c_dist(playerX,playerY,targetX,targetY) < VECTOR_DEPTH)
					if isOnLine then
						onPath = true
					end

					if x1 and x2 then
						count = count + 1
	
						local aX = abs(dist_dot( x1,y1,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local aY = abs(dist_dot( x1,y1,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local bX = abs(dist_dot( x2,y2,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local bY = abs(dist_dot( x2,y2,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
					
						if aX > bX then aX,bX=bX,aX aY,bY=bY,aY end
	
						SetLine(count,aX,aY,bX,bY,isOnLine and 3 or 1)
					end
				end
				if not onPath then
					self.back:SetColorTexture(1,.7,.7,.4)
				else
					self.back:SetColorTexture(.7,.7,.7,.4)
				end
			end

		end
	end)
end

local CalligraphyHelperNpcIDToZone = {
	["151526"] = 1,	--Zuldazar
	["151524"] = 2,	--Nazmir
	["151525"] = 3,	--Voldun
	["151378"] = 4,	--Dru
	["151522"] = 5,	--Tir
	["151523"] = 6,	--Storm
}
local CalligraphyHelperQuestIDs = {
	[55344] = true,	--Zuldazar
	[55342] = true,	--Nazmir
	[55343] = true,	--Voldun
	[55264] = true,	--Dru
	[55340] = true,	--Tir
	[55341] = true,	--Storm
}
local CalligraphyHelper = CreateFrame("Frame")
CalligraphyHelper:SetScript("OnEvent",function(self,event,arg1,arg2)
	if event == 'QUEST_ACCEPTED' then
		if arg2 and CalligraphyHelperQuestIDs[arg2] then
			if VWQL and VWQL.DisableCalligraphy then
				return
			end
			U1Message("世界任务列表: 书法艺术助手已加载")
			self:RegisterEvent("GOSSIP_CLOSED")
		end
	elseif event == 'QUEST_REMOVED' then
		if arg1 and CalligraphyHelperQuestIDs[arg1] then
			self:UnregisterEvent("GOSSIP_CLOSED")
			if Calligraphy.Close then
				Calligraphy:Close()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if VWQL and VWQL.DisableCalligraphy then
			return
		end
		for i=1,GetNumQuestLogEntries() do
			local title, _, _, _, _, _, _, questID = GetQuestLogTitle(i)
			if questID and CalligraphyHelperQuestIDs[questID] then
				self:RegisterEvent("GOSSIP_CLOSED")
				break
			end
		end
	elseif event == 'GOSSIP_CLOSED' then
		local guid = UnitGUID'target'
		if guid then
			local type,_,serverID,instanceID,zoneUID,id,spawnID = strsplit("-", guid)
			if id and CalligraphyHelperNpcIDToZone[id] then
				Calligraphy:Load()
				Calligraphy:UpdateLinesSetup(CalligraphyHelperNpcIDToZone[id])
			end
		end
		
	end

end)
CalligraphyHelper:RegisterEvent('QUEST_ACCEPTED')
CalligraphyHelper:RegisterEvent('QUEST_REMOVED')
CalligraphyHelper:RegisterEvent('PLAYER_ENTERING_WORLD')
