local GlobalAddonName, ExRT = ...

local math_ceil, IsEncounterInProgress, abs, UnitHealth, UnitHealthMax, GetTime, format, tableCopy = math.ceil, IsEncounterInProgress, abs, UnitHealth, UnitHealthMax, GetTime, format, ExRT.F.table_copy2
local SendAddonMessage = C_ChatInfo.SendAddonMessage
local VMRT = nil

local module = ExRT:New("Timers",ExRT.L.timers)
local ELib,L = ExRT.lib,ExRT.L

module.db.lasttimertopull = 0
module.db.timertopull = 0
module.db.firstmsg = false

local timeToKillEnabled = nil

module.db.classNames = ExRT.GDB.ClassList
local defaultSpecTimers = {
	[62] = 10,    -- Mage: Arcane
	[63] = 10,    -- Mage: Fire
	[64] = 10,    -- Mage: Frost
	[65] = 10,    -- Paladin: Holy
	[66] = 10,    -- Paladin: Protection
	[70] = 10,    -- Paladin: Retribution
	[71] = 10,    -- Warrior: Arms
	[72] = 10,    -- Warrior: Fury
	[73] = 10,    -- Warrior: Protection
	[102] = 10,   -- Druid: Balance
	[103] = 10, -- Druid: Feral
	[104] = 10, -- Druid: Guardian
	[105] = 10, -- Druid: Restoration
	[250] = 10, -- Death Knight: Blood
	[251] = 10, -- Death Knight: Frost
	[252] = 10, -- Death Knight: Unholy
	[253] = 10, -- Hunter: Beast Mastery
	[254] = 10, -- Hunter: Marksmanship
	[255] = 10, -- Hunter: Survival
	[256] = 10, -- Priest: Discipline
	[257] = 10, -- Priest: Holy
	[258] = 10, -- Priest: Shadow
	[259] = 10, -- Rogue: Assassination
	[260] = 10, -- Rogue: Combat
	[261] = 25, -- Rogue: Subtlety
	[262] = 16, -- Shaman: Elemental
	[263] = 10, -- Shaman: Enhancement
	[264] = 10, -- Shaman: Restoration
	[265] = 22, -- Warlock: Affliction
	[266] = 10, -- Warlock: Demonology
	[267] = 10, -- Warlock: Destruction
	[268] = 10, -- Monk: Brewmaster
	[269] = 10, -- Monk: Windwalker
	[270] = 10, -- Monk: Mistweaver
	[577] = 10, -- Demon Hunter: Havoc
	[581] = 10, -- Demon Hunter: Vengeance	
}

module.db.specIcons = ExRT.GDB.ClassSpecializationIcons
module.db.specByClass = ExRT.GDB.ClassSpecializationList
module.db.localizatedClassNames = L.classLocalizate

local function ToRaid(msg)
	if VMRT.Timers.DisableRW then
		return
	end
	if IsInRaid() then
		SendChatMessage(msg, "raid_warning")
	elseif (GetNumGroupMembers() or 0) > 1 then
		SendChatMessage(msg, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
	else
		RaidWarningFrame_OnEvent(RaidWarningFrame,"CHAT_MSG_RAID_WARNING",msg)
		print(msg)
	end
end

local function CreateTimers(ctime,cname)
	local chat_type,playerName = ExRT.F.chatType()

	if cname == L.timerattack then
		SendAddonMessage("BigWigs", "P^Pull^"..ctime, chat_type,playerName)
		local _,_,_,_,_,_,_,mapID = GetInstanceInfo()
		SendAddonMessage("D4", ("PT\t%d\t%d"):format(ctime,mapID or 0), chat_type,playerName)
		if not ExRT.isClassic and VMRT.Timers.BlizzTimer then --currently is bugged, wait to fix
			C_PartyInfo.DoCountdown(ctime)
		end
	elseif cname == L.timerafk then
		SendAddonMessage("BigWigs", "P^Break^"..ctime, chat_type,playerName)
		SendAddonMessage("D4", ("BT\t%d"):format(ctime), chat_type,playerName)
	else
		SendAddonMessage("BigWigs", "P^CBar^"..ctime.." "..cname, chat_type,playerName)
		SendAddonMessage("D4", ("U\t%d\t%s"):format(ctime,cname), chat_type,playerName)
		if not ExRT.isClassic and VMRT.Timers.BlizzTimer then
			C_PartyInfo.DoCountdown(0)
		end
	end
end

function module:timer(elapsed)
	if module.db.timertopull > 0 then
		if math_ceil(module.db.timertopull) < math_ceil(module.db.lasttimertopull) then
			if module.db.firstmsg == true or math_ceil(module.db.timertopull) % 5 == 0 or math_ceil(module.db.timertopull) == 7 or math_ceil(module.db.timertopull) < 5 then
				ToRaid(L.timerattackt.." "..math_ceil(module.db.timertopull).." "..L.timersec)
				module.db.firstmsg = false
			end
			module.db.lasttimertopull = module.db.timertopull
		end
		module.db.timertopull = module.db.timertopull - elapsed
		if module.db.timertopull < 0 then
			module.db.timertopull = 0
			ToRaid(">>> "..L.timerattack.." <<<")
		end
	end
	if VMRT.Timers.enabled then
		if not module.frame.encounter and IsEncounterInProgress() then
			module.frame.encounter = true
			module.frame.total = 0
			
			if VMRT.Timers.OnlyInCombat then
				module.frame:Show()
			end
		elseif module.frame.encounter and not IsEncounterInProgress() then
			module.frame.encounter = nil
			
			if VMRT.Timers.OnlyInCombat and not module.frame.inCombat then
				module.frame:Hide()
			end
		end
	end
end

local function GetDynamicPullTime()
	local time_needed = 10
	local n = GetNumGroupMembers() or 0
	if n == 0 then
		local spec = ExRT.A.Inspect.db.inspectDB[ ExRT.SDB.charName ] and ExRT.A.Inspect.db.inspectDB[ ExRT.SDB.charName ].spec
		if spec then
			local currTime = VMRT.Timers.specTimes[spec] or defaultSpecTimers[spec] or 10
			if currTime > time_needed then
				time_needed = currTime
			end
		end
	end
	for i=1,n do
		local name,_, subgroup, _, _, _, _, online = GetRaidRosterInfo(i)
		if subgroup <= 6 and online then
			local spec = ExRT.A.Inspect.db.inspectDB[name] and ExRT.A.Inspect.db.inspectDB[name].spec
			if spec then
				local currTime = VMRT.Timers.specTimes[spec] or defaultSpecTimers[spec] or 10
				if currTime > time_needed then
					time_needed = currTime
				end
			end
		end
	end
	return time_needed
end

function ExRT.F:DoPull(inum,ignoreDRT)
	if module.db.timertopull > 0 then
		module.db.timertopull = 0
		ToRaid(">>> "..L.timerattackcancel.." <<<")
		CreateTimers(0,L.timerattack)
	else
		inum = tonumber(inum) or 10
		if VMRT.Timers.useDPT and not ignoreDRT then
			inum = GetDynamicPullTime()
		end
		module.db.firstmsg = true
		module.db.lasttimertopull = inum + 1
		module.db.timertopull = inum
		CreateTimers(inum,L.timerattack)
	end
end

function module:slash(arg,msgDeformatted)
	if arg == "pull" then
		ExRT.F:DoPull(10)
	elseif arg:find("^pull ") then
		local sec = arg:match("%d+")
		sec = tonumber(sec or "?")
		if not sec then
			if module.db.timertopull > 0 then
				ExRT.F:DoPull()
			end
			return
		end
		ExRT.F:DoPull(sec,true)
	elseif arg:find("^afk ") then
		local min = arg:match("[%d%.]+")
		if min then
			min = tonumber(min)
			if min > 0 then
				CreateTimers(min*60,L.timerafk)
				ToRaid(L.timerafk.." "..min.." "..L.timermin)
			else
				CreateTimers(0,L.timerafk)
				ToRaid(L.timerafkcancel)
			end
		end
	elseif arg:find("^timer ") then
		local timerName,timerTime = msgDeformatted:match("^[Tt][Ii][Mm][Ee][Rr] (.-) ([%d%.]+)")
		if not timerName or not timerTime then
			return
		end
		timerTime = tonumber(timerTime)
		if not timerTime then
			return
		end
		CreateTimers(timerTime,timerName)
	elseif VMRT.Timers.enabled and arg:find("^mytimer ") then
		local id = arg:match("%d+")
		if id then
			module.frame.total = -tonumber(id)
		end
	elseif arg == "dpt" then
		local parentModule = ExRT.A.Inspect
		if not parentModule then
			return
		end
		if module.db.timertopull > 0 then
			module.db.timertopull = 0
			ToRaid(">>> "..L.timerattackcancel.." <<<")
			CreateTimers(0, L.timerattack)
		else
			module.db.firstmsg = true
			local time_needed = GetDynamicPullTime()
			module.db.lasttimertopull = time_needed + 1
			module.db.timertopull = time_needed
			CreateTimers(time_needed,L.timerattack)
		end
	elseif arg:find("^cleutimer ") then
		--/rt cleutimer UNIT_DIED 177286 240 sound
		local u_event,filter,time = msgDeformatted:match("^cleutimer ([^ ]+) (%d+) (%d+)")
		if time then
			filter = tonumber(filter)
			time = tonumber(time)
			local sound = arg:find("sound") and true or false
			if u_event == "UNIT_DIED" then
				function module.main.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID)
					if u_event == event and ExRT.F.GUIDtoID(destGUID) == filter then
						module.frame.total = -time
						if sound then
							C_Timer.After(time,function()
								pcall(PlaySoundFile, [[Interface\AddOns\WeakAuras\Media\Sounds\AirHorn.ogg]], "Master")
							end)
						end
					end
				end
			else
				function module.main.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID)
					if u_event == event and spellID == filter then
						module.frame.total = -time
						if sound then
							C_Timer.After(time,function()
								pcall(PlaySoundFile, [[Interface\AddOns\WeakAuras\Media\Sounds\AirHorn.ogg]], "Master")
							end)
						end
					end
				end
			end
			module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
			print('added',u_event,filter,time,sound)
		else
			print('wrong syntax')
		end
	elseif arg == "help" then
		print("|cff00ff00/rt pull|r - run pull timer with 10 seconds")
		print("|cff00ff00/rt pull X|r - run pull timer with X seconds")
		print("|cff00ff00/rt afk X|r - run afk timer with X minutes")
		print("|cff00ff00/rt timer TIMERNAME X|r - run custom timer with name TIMERNAME and X seconds")
		print("|cff00ff00/rt mytimer X|r - set countdown for timer frame with X seconds")
		print("|cff00ff00/rt dpt|r - run dynamic pull timer")
	end
end

function module.options:Load()
	self:CreateTilte()

	local GetSpecializationInfoByID = GetSpecializationInfoByID
	if ExRT.isClassic then
		GetSpecializationInfoByID = ExRT.Classic.GetSpecializationInfoByID
	end

	self.shtml1 = ELib:Text(self,L.timerstxt1,12):Size(650,200):Point(15,-20):Top()
	self.shtml2 = ELib:Text(self,L.timerstxt2,12):Size(550,200):Point(115,-20):Top():Color()
	
	self.chkDisableRW = ELib:Check(self,L.TimerDisableRWmessage,VMRT.Timers.DisableRW):Point(15,-150):OnClick(function(self) 
		VMRT.Timers.DisableRW = self:GetChecked()
	end)

	self.chkDisableRW = ELib:Check(self,L.TimerEnableBlizz,VMRT.Timers.BlizzTimer):Tooltip(L.TimerEnableBlizzTooltip):Point(15,-175):OnClick(function(self) 
		VMRT.Timers.BlizzTimer = self:GetChecked()
	end):Shown(not ExRT.isClassic)
	
	self.TabTimerFrame = ELib:OneTab(self):Size(678,155):Point("TOP",0,-205)
	ELib:Border(self.TabTimerFrame,0)

	ELib:DecorationLine(self):Point("BOTTOM",self.TabTimerFrame,"TOP",0,0):Point("LEFT",self):Point("RIGHT",self):Size(0,1)
	ELib:DecorationLine(self):Point("TOP",self.TabTimerFrame,"BOTTOM",0,0):Point("LEFT",self):Point("RIGHT",self):Size(0,1)
	
	self.chkEnable = ELib:Check(self.TabTimerFrame,L.timerTimerFrame,VMRT.Timers.enabled):Point(5,-5):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Timers.enabled = true
			module.frame:Show()
			module.frame:SetScript("OnUpdate", module.frame.OnUpdateFunc)
			module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
			module.options.chkTimeToKill:SetEnabled(true)
		else
			VMRT.Timers.enabled = nil
			VMRT.Timers.timeToKill = nil
			module.frame:Hide() 
			module.frame:SetScript("OnUpdate", nil)
			module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
			module.options.chkTimeToKill:SetEnabled(false)
			module.options.chkTimeToKill:SetChecked(nil)
		end
	end)
	
	self.chkOnlyInCombat = ELib:Check(self.TabTimerFrame,L.TimerOnlyInCombat,VMRT.Timers.OnlyInCombat):Point(5,-30):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Timers.OnlyInCombat = true
			if not (module.frame.inCombat or module.frame.encounter) then
				module.frame:Hide()
			end
		else
			VMRT.Timers.OnlyInCombat = nil
			if VMRT.Timers.enabled then
				module.frame:Show()
			end
		end
	end)
	
	self.chkFixate = ELib:Check(self.TabTimerFrame,L.cd2fix,VMRT.Timers.Lock):Point(339,-5):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Timers.Lock = true
			module.frame:SetMovable(false)
			module.frame:EnableMouse(false)
		else
			VMRT.Timers.Lock = nil
			module.frame:SetMovable(true)
			module.frame:EnableMouse(true)
		end
	end)
	
	self.chkTimeToKill = ELib:Check(self.TabTimerFrame,L.TimerTimeToKill,VMRT.Timers.timeToKill):Point(339,-30):Tooltip(L.TimerTimeToKillHelp):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Timers.timeToKill = true
			timeToKillEnabled = true
		else
			VMRT.Timers.timeToKill = nil
			timeToKillEnabled = nil
			module.frame.killTime:SetText("")
		end
	end)
	
	self.sliderTimeToKill = ELib:Slider(self.TabTimerFrame,L.TimerTimeToKillTime):Size(100):Point("LEFT",self.chkTimeToKill,"LEFT",180,2):Range(5,40):SetTo(VMRT.Timers.timeToKillAnalyze):OnChange(function(self,event) 
		event = event - event%1
		VMRT.Timers.timeToKillAnalyze = event
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.ButtonToCenter = ELib:Button(self.TabTimerFrame,L.TimerResetPos):Size(324,20):Point(5,-80):Tooltip(L.TimerResetPosTooltip):OnClick(function()
		VMRT.Timers.Left = nil
		VMRT.Timers.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 
	
	self.TimerFrameStrataDropDown = ELib:DropDown(self.TabTimerFrame,275,8):Point(338,-60):Size(324):SetText(L.S_Strata)
	local function TimerFrameStrataDropDown_SetVaule(_,arg)
		VMRT.Timers.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.TimerFrameStrataDropDown.List do
			self.TimerFrameStrataDropDown.List[i].checkState = arg == self.TimerFrameStrataDropDown.List[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end
	for i,strataString in ipairs({"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}) do
		self.TimerFrameStrataDropDown.List[i] = {
			text = strataString,
			checkState = VMRT.Timers.Strata == strataString,
			radio = true,
			arg1 = strataString,
			func = TimerFrameStrataDropDown_SetVaule,
		}
	end

	self.setTypeText = ELib:Text(self.TabTimerFrame,TYPE..":",11):Point(5,-55):Size(0,25)
	
	self.setType1 = ELib:Radio(self.TabTimerFrame,"1",VMRT.Timers.Type == 1 or not VMRT.Timers.Type):Point("LEFT",self.setTypeText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.setType2:SetChecked(false)
		VMRT.Timers.Type = 1
		if VMRT.Timers.enabled then
			module.frame:SetScript("OnUpdate", module.frame.OnUpdateFunc)
		end
	end)
	
	self.setType2 = ELib:Radio(self.TabTimerFrame,"2",VMRT.Timers.Type == 2):Point("LEFT",self.setType1,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.setType1:SetChecked(false)
		VMRT.Timers.Type = 2
		if VMRT.Timers.enabled then
			module.frame:SetScript("OnUpdate", module.frame.OnUpdateFunc)
		end
	end)


	self.SliderScale = ELib:Slider(self.TabTimerFrame,L.marksbarscale):Size(280):Point("TOP",-170,-120):Range(10,400):SetTo(VMRT.Timers.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.Timers.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.SliderAlpha = ELib:Slider(self.TabTimerFrame,L.marksbaralpha):Size(280):Point("TOP",170,-120):Range(0,100):SetTo(VMRT.Timers.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.Timers.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	
	self.chkDPT = ELib:Check(self,L.TimerUseDptInstead,VMRT.Timers.useDPT):Point(15,-370):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Timers.useDPT = true
		else
			VMRT.Timers.useDPT = nil
		end
	end):Shown(not ExRT.isClassic)
	
	local function SpecsEditBoxTextChanged(self,isUser)
		if not isUser then
			return
		end
		local spec = self.id
		local val = tonumber(self:GetText())
		if not val then
			val = 0
		elseif val > 60 then
			val = 60
		elseif val < 0 then
			val = 0
		end
		self:SetText(val)
		VMRT.Timers.specTimes[spec] = val
	end
	
	self.scrollFrame = ELib:ScrollFrame(self):Size(678,220):Point("TOP",0,-413):Height(600):Shown(not ExRT.isClassic)
	ELib:Border(self.scrollFrame,0)
	self.scrollFrameText = ELib:Text(self,L.TimerSpecTimerHeader,12):Size(620,30):Point("BOTTOMLEFT",self.scrollFrame,"TOPLEFT",5,5):Bottom():Shown(not ExRT.isClassic)
	self.scrollFrame.C.classTitles = {}
	self.scrollFrame.C.classFrames = {}
	for key, class in ipairs(module.db.classNames) do
		
		local column = (key-1) % 3
		local row = math.floor((key-1) / 3)
		local frame = CreateFrame("Frame",nil,self.scrollFrame.C)
		self.scrollFrame.C.classFrames[class] = frame
		frame:SetSize(210,26)
		frame:SetPoint("TOPLEFT", 70 + 205 * column, -20 - 140 * row)
		local className = module.db.localizatedClassNames[class] or class
		self.scrollFrame.C.classTitles[class] = ELib:Text(frame,"\124c"..ExRT.F.classColor(class)..className.."\124r",13):Size(200,20):Point(0,0 ):Top()
		frame.icon = frame:CreateTexture(nil, "BACKGROUND")
		
		self.scrollFrame.C.classFrames[class].specFrames = {}
		for specRow, spec in ipairs(module.db.specByClass[class]) do
			local specFrame = CreateFrame("Frame", nil, frame)
			self.scrollFrame.C.classFrames[class].specFrames[spec] = specFrame
			specFrame:SetSize(20, 26)
			specFrame:SetPoint("TOPLEFT", -40, 0 - 22*specRow)
			specFrame.icon = specFrame:CreateTexture(nil, "BACKGROUND")
			specFrame.icon:SetTexture(module.db.specIcons[spec])
			specFrame.icon:SetPoint("TOPLEFT", 0, 0)
			specFrame.icon:SetSize(20,20)
			local _,specName = GetSpecializationInfoByID(spec)
			specFrame.specName = ELib:Text(specFrame,specName,13):Size(100,20):Point(22,-5):Top():FontSize(10)
			specFrame.specEditBox = ELib:Edit(specFrame):Size(30,20):Point(120,0):Text(VMRT.Timers.specTimes[spec] or "10"):OnChange(SpecsEditBoxTextChanged)
			specFrame.specEditBox.id = spec
		end
	end
	self.scrollFrame.C.ButtonToDefaultTimers = ELib:Button(self.scrollFrame.C,L.TimerSpecTimerDefault):Size(255,20):Point("TOP",0,-560):OnClick(function()
		VMRT.Timers.specTimes = tableCopy(defaultSpecTimers)
		for key, class in ipairs(module.db.classNames) do
			for specRow, spec in ipairs(module.db.specByClass[class]) do
				local specFrame = self.scrollFrame.C.classFrames[class].specFrames[spec]
				specFrame.specEditBox:SetText(VMRT.Timers.specTimes[spec])
			end
		end
		
	end) 

	if not VMRT.Timers.enabled then
		self.chkTimeToKill:SetChecked(nil)
		self.chkTimeToKill:SetEnabled(false)
	end
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.Timers = VMRT.Timers or {
		Type = 2,
	}

	if VMRT.Timers.Left and VMRT.Timers.Top then 
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VMRT.Timers.Left,VMRT.Timers.Top) 
	end

	if VMRT.Timers.enabled then
		if not VMRT.Timers.OnlyInCombat then
			module.frame:Show()
		end
		module.frame:SetScript("OnUpdate", module.frame.OnUpdateFunc)
		module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')		
	end
	if VMRT.Timers.enabled and VMRT.Timers.timeToKill then 
		timeToKillEnabled = true
	end
	if VMRT.Timers.Lock then
		module.frame:SetMovable(false)
		module.frame:EnableMouse(false)
	end
	if not VMRT.Timers.specTimes then
		VMRT.Timers.specTimes = tableCopy(defaultSpecTimers)
	end
	
	VMRT.Timers.Strata = VMRT.Timers.Strata or "HIGH"
	
	VMRT.Timers.timeToKillAnalyze = tonumber(VMRT.Timers.timeToKillAnalyze or "?") or 15
	
	module.frame:SetFrameStrata(VMRT.Timers.Strata)
	
	module:RegisterTimer()
	module:RegisterSlash()

	if VMRT.Timers.Alpha then module.frame:SetAlpha(VMRT.Timers.Alpha/100) end
	if VMRT.Timers.Scale then module.frame:SetScale(VMRT.Timers.Scale/100) end
end

function module.main:PLAYER_REGEN_DISABLED()
	if not module.frame.encounter and module.frame.total >= 0 then 
		module.frame.total = 0 
	end
	module.frame.inCombat = true
	
	if VMRT.Timers.OnlyInCombat then
		module.frame:Show()
	end
end

function module.main:PLAYER_REGEN_ENABLED()
	module.frame.inCombat = nil
	
	if VMRT.Timers.OnlyInCombat and not module.frame.encounter then
		module.frame:Hide()
	end
end

module.frame = CreateFrame("Frame","MRTCombatTimer",UIParent,BackdropTemplateMixin and "BackdropTemplate")
module.frame:Hide()
module.frame:SetSize(77,27)
module.frame:SetPoint("CENTER", 0, 0)
module.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 4})
module.frame:SetBackdropBorderColor(0.1,0.1,0.1,0.7)
module.frame:SetBackdropColor(0,0,0,0.7)
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VMRT.Timers.Left = self:GetLeft()
	VMRT.Timers.Top = self:GetTop()
end)
module.frame.total = 0
module.frame.tmr = 0
module.frame.killTmr = 0
module.frame.txt = ELib:Text(module.frame,"00:00.0"):Size(77,27):Point("LEFT",11,0):Left():Font(ExRT.F.defFont,16):Color():Shadow():Outline()
module.frame.killTime = ELib:Text(module.frame,""):Size(77,27):Point("TOP",module.frame,"BOTTOM",0,0):Top():Center():Font(ExRT.F.defFont,14):Color():Shadow():Outline()
module.frame.txt_ms = ELib:Text(module.frame,""):Size(77,27):Point("LEFT",11,0):Left():Font(ExRT.F.defFont,16):Color():Shadow():Outline()
module.frame.txt_s = ELib:Text(module.frame,""):Size(77,27):Point("LEFT",11,0):Left():Font(ExRT.F.defFont,16):Color():Shadow():Outline()
module:RegisterHideOnPetBattle(module.frame)

module.db.TTK = {}

function module:UpdateView(t)
	local self = module.frame
	if t == 1 then
		self:SetSize(77,27)
		self:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 4})
		self:SetBackdropBorderColor(0.1,0.1,0.1,0.7)
		self:SetBackdropColor(0,0,0,0.7)

		self.txt:SetText("00:00.0")
		self.txt_ms:SetText("")
		self.txt_s:SetText("")
		self.txt:Size(77,27):Point("LEFT",11,0):Left():Font(ExRT.F.defFont,16):Color():Shadow():Outline()
		self.killTime:Size(77,27):Point("TOP",self,"BOTTOM",0,0):Top():Center():Font(ExRT.F.defFont,14):Color():Shadow():Outline()
	elseif t == 2 then
		self:SetSize(77,27)
		self:SetBackdropBorderColor(0.1,0.1,0.1,0)
		self:SetBackdropColor(0,0,0,0)

		self.txt:SetText("0:")
		self.txt_s:SetText("00")
		self.txt_ms:SetText(".0")
		self.txt:Size(29+4,27):Point("LEFT",-4,0):Right():Font(ExRT.F.defFont,20):Color():Shadow():Outline()
		self.txt_s:Size(27,27):Point("LEFT",25,0):Left():Font(ExRT.F.defFont,20):Color():Shadow():Outline()
		self.txt_ms:Size(0,27):Point("LEFT",45,-3):Left():Font(ExRT.F.defFont,12):Color():Shadow():Outline()
		self.killTime:Size(77,27):Point("TOP",self,"BOTTOM",0,3):Top():Center():Font(ExRT.F.defFont,14):Color():Shadow():Outline()
		
	end
end

do
	local hpSnapshots,timeSnapshots,iSnapshot,guidSnapshot = {},{},0
	local tmr = 0
	local tmr2 = 0
	local MAX_SEGMENTS = 90

	local function timerType1(self,elapsed)
		tmr2 = tmr2 + elapsed
		if tmr2 > 0.05 and (self.inCombat or self.encounter or self.total < 0) then
			self.total = self.total + tmr2
			self.txt:SetFormattedText("%2.2d:%2.2d\.%1.1d",abs(self.total)/60,abs(self.total)%60,(abs(self.total)*10)%10)
			tmr2 = 0
		elseif tmr2 > 0.05 then
			tmr2 = 0
		end
		
		if timeToKillEnabled then
			tmr = tmr + elapsed
			if tmr > 0.5 then
				tmr = 0
				iSnapshot = iSnapshot + 1
				if iSnapshot > MAX_SEGMENTS then
					iSnapshot = 1
				end
				local currHp,maxHP = UnitHealth('target'),UnitHealthMax('target')
				local targetGUID = UnitGUID('target')
				if guidSnapshot ~= targetGUID then
					--wipe(hpSnapshots)
					for i=1,MAX_SEGMENTS do
						if not hpSnapshots[i] then
							break
						end
						hpSnapshots[i] = nil
					end
					iSnapshot = 1
					guidSnapshot = targetGUID
				end
				hpSnapshots[ iSnapshot ] = maxHP > 0 and currHp/maxHP or 0
				timeSnapshots[ iSnapshot ] = GetTime()
				if iSnapshot % 2 == 0 then
					local prevSnapshot = iSnapshot - (VMRT.Timers.timeToKillAnalyze * 2)
					if prevSnapshot < 1 then
						prevSnapshot = prevSnapshot + MAX_SEGMENTS
					end
					local prevHP = hpSnapshots[ prevSnapshot ]
					if not prevHP and iSnapshot > 1 then
						prevSnapshot = 1
						prevHP = hpSnapshots[1]
					end

					local nowHP = hpSnapshots[ iSnapshot ]
					if nowHP and nowHP > 0 and prevHP and prevHP > 0 then
						local diff = prevHP - nowHP
						local time = timeSnapshots[ iSnapshot ] - timeSnapshots[ prevSnapshot ]
						local dps = diff / time
						
						local t = dps ~= 0 and nowHP / dps or 0
						if t <= 0 or t > 600 then
							module.frame.killTime:SetText("")
						elseif t >= 60 then
							module.frame.killTime:SetFormattedText("%d:%02d",floor(t/60),t % 60)
						else
							module.frame.killTime:SetFormattedText("%d",t)
						end
					else
						module.frame.killTime:SetText("")
					end
				end
			end
		end
	end

	local function timerType2(self,elapsed)
		tmr2 = tmr2 + elapsed
		if tmr2 > 0.05 and (self.inCombat or self.encounter or self.total < 0) then
			self.total = self.total + tmr2
			self.txt:SetFormattedText("%1.1d:",abs(self.total)/60)
			self.txt_s:SetFormattedText("%2.2d",abs(self.total)%60)
			self.txt_ms:SetFormattedText("\.%1.1d",(abs(self.total)*10)%10)
			tmr2 = 0
		elseif tmr2 > 0.05 then
			tmr2 = 0
		end
		
		if timeToKillEnabled then
			tmr = tmr + elapsed
			if tmr > 0.5 then
				tmr = 0
				iSnapshot = iSnapshot + 1
				if iSnapshot > MAX_SEGMENTS then
					iSnapshot = 1
				end
				local currHp,maxHP = UnitHealth('target'),UnitHealthMax('target')
				local targetGUID = UnitGUID('target')
				if guidSnapshot ~= targetGUID then
					--wipe(hpSnapshots)
					for i=1,MAX_SEGMENTS do
						if not hpSnapshots[i] then
							break
						end
						hpSnapshots[i] = nil
					end
					iSnapshot = 1
					guidSnapshot = targetGUID
				end
				hpSnapshots[ iSnapshot ] = maxHP > 0 and currHp/maxHP or 0
				timeSnapshots[ iSnapshot ] = GetTime()
				if iSnapshot % 2 == 0 then
					local prevSnapshot = iSnapshot - (VMRT.Timers.timeToKillAnalyze * 2)
					if prevSnapshot < 1 then
						prevSnapshot = prevSnapshot + MAX_SEGMENTS
					end
					local prevHP = hpSnapshots[ prevSnapshot ]
					if not prevHP and iSnapshot > 1 then
						prevSnapshot = 1
						prevHP = hpSnapshots[1]
					end

					local nowHP = hpSnapshots[ iSnapshot ]
					if nowHP and nowHP > 0 and prevHP and prevHP > 0 then
						local diff = prevHP - nowHP
						local time = timeSnapshots[ iSnapshot ] - timeSnapshots[ prevSnapshot ]
						local dps = diff / time
						
						local t = dps ~= 0 and nowHP / dps or 0
						if t <= 0 or t > 600 then
							module.frame.killTime:SetText("")
						elseif t >= 60 then
							module.frame.killTime:SetFormattedText("%d:%02d",floor(t/60),t % 60)
						else
							module.frame.killTime:SetFormattedText("%d",t)
						end
					else
						module.frame.killTime:SetText("")
					end
				end
			end
		end
	end
	
	function module.frame.OnUpdateFunc(self,elapsed)
		if not VMRT.Timers.Type or VMRT.Timers.Type == 1 then
			module:UpdateView(1)
			self:SetScript("OnUpdate",timerType1)
			return
		elseif VMRT.Timers.Type == 2 then
			module:UpdateView(2)
			self:SetScript("OnUpdate",timerType2)
			return
		end
		self:SetScript("OnUpdate",nil)
	end
end