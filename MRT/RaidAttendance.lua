local GlobalAddonName, ExRT = ...

local VMRT = nil

local module = ExRT:New("RaidAttendance",ExRT.L.Attendance)
local ELib,L = ExRT.lib,ExRT.L

module.db.diffNames = {
	[14] = L.sencounterWODNormal,	-- Normal,	PLAYER_DIFFICULTY1
	[15] = L.sencounterWODHeroic,	-- Heroic,	PLAYER_DIFFICULTY2
	[16] = L.sencounterWODMythic,	-- Mythic,	PLAYER_DIFFICULTY6
	[175] = "10 ppl",
	[176] = "25 ppl",
	[148] = "20 ppl",
	[9] = "40 ppl",
}

local classToLetter = {
	WARRIOR='A',
	PALADIN='B',
	HUNTER='C',
	ROGUE='D',
	PRIEST='E',
	DEATHKNIGHT='F',
	SHAMAN='G',
	MAGE='H',
	WARLOCK='I',
	MONK='J',
	DRUID='K',
	DEMONHUNTER='L',
}

local SaveRaidRoster,SaveCurrentRaidRoster

local C_Calendar_GetDate
if ExRT.isClassic then
	C_Calendar_GetDate = C_DateAndTime.GetTodaysDate
else
	C_Calendar_GetDate = C_DateAndTime.GetCurrentCalendarTime
end

function module.options:Load()
	local UpdatePersonalData,UpdateData

	self:CreateTilte()
	
	local function RadioUpdates()
		self.radioDisabled:SetChecked(not VMRT.Attendance.enabled)
		self.radioFirstTimePerRaid:SetChecked(VMRT.Attendance.enabled == 1)
		self.radioFirstPerRaidKill:SetChecked(VMRT.Attendance.enabled == 2)
		self.raidEveryPull:SetChecked(VMRT.Attendance.enabled == 3)
		self.raidEveryKill:SetChecked(VMRT.Attendance.enabled == 4)
		self.raidSpecialConditions:SetChecked(type(VMRT.Attendance.enabled) == 'string')
		if type(VMRT.Attendance.enabled) == 'string' then
			self.raidSpecialConditionsEdit:Text(VMRT.Attendance.specialEdit or "")
			self.raidSpecialConditionsEdit:Show()
		else
			self.raidSpecialConditionsEdit:Hide()
		end
	end

	self.radioDisabled = ELib:Radio(self,DISABLE):Point(5,-30):OnClick(function(self) 
		VMRT.Attendance.enabled = nil
		RadioUpdates()
	end)
	
	self.radioFirstTimePerRaid = ELib:Radio(self,L.AttendanceFirstPerRaid):Point("TOPLEFT",self.radioDisabled,0,-25):OnClick(function(self) 
		VMRT.Attendance.enabled = 1
		RadioUpdates()
	end)

	self.radioFirstPerRaidKill = ELib:Radio(self,L.AttendanceFirstPerRaidKill):Point("TOPLEFT",self.radioFirstTimePerRaid,0,-25):OnClick(function(self) 
		VMRT.Attendance.enabled = 2
		RadioUpdates()
	end)
	
	self.raidEveryPull = ELib:Radio(self,L.AttendanceEveryPull):Point("TOPLEFT",self.radioFirstPerRaidKill,0,-25):OnClick(function(self) 
		VMRT.Attendance.enabled = 3
		RadioUpdates()
	end)

	self.raidEveryKill = ELib:Radio(self,L.AttendanceEveryKill):Point("TOPLEFT",self.raidEveryPull,0,-25):OnClick(function(self) 
		VMRT.Attendance.enabled = 4
		RadioUpdates()
	end)
	
	self.raidSpecialConditions = ELib:Radio(self,L.AttendanceSpecialConditions):Point("TOPLEFT",self.raidEveryKill,0,-25):OnClick(function(self) 
		VMRT.Attendance.enabled = VMRT.Attendance.specialEdit or ""
		RadioUpdates()
	end)
	
	self.raidSpecialConditionsEdit = ELib:Edit(self):Size(400,20):Point("LEFT",self.raidSpecialConditions,150,0):Tooltip(L.AttendanceSelectConditionsTooltip):OnChange(function(self,isUser)
		if not isUser then
			return
		end
		local text = self:GetText()
		VMRT.Attendance.specialEdit = text
		VMRT.Attendance.enabled = text
	end)
	self.raidSpecialConditionsEdit:Hide()
	
	RadioUpdates()
	
	local letterToClass = {
		A='WARRIOR',
		B='PALADIN',
		C='HUNTER',
		D='ROGUE',
		E='PRIEST',
		F='DEATHKNIGHT',
		G='SHAMAN',
		H='MAGE',
		I='WARLOCK',
		J='MONK',
		K='DRUID',
		L='DEMONHUNTER',
	}
	
	self.list = ELib:ScrollCheckList(self):Point("TOPLEFT",self.raidSpecialConditions,0,-30):Size(550,195)
	function self.list:HoverListValue(isHover,index,obj)
		if isHover then
			GameTooltip:SetOwner(obj,"ANCHOR_LEFT")
			GameTooltip:AddLine(self.D[index][1])
			for i=0,19 do
				if i%5 == 0 then
					GameTooltip:AddDoubleLine("*** "..GROUP.." "..(floor(i/5)*2+1),GROUP.." "..(floor(i/5)*2+2).." ***")
				end
				local name1 = self.D[index][3][i%5 + floor(i/5)*10 + 1]
				if name1 then
					local class = name1:sub(1,1)
					name1 = "|c"..ExRT.F.classColor(letterToClass[class])..name1:sub(2).."|r"
				else
					name1 = " "
				end
				
				local name2 = self.D[index][3][i%5 + floor(i/5)*10 + 6]
				if name2 then
					local class = name2:sub(1,1)
					name2 = "|c"..ExRT.F.classColor(letterToClass[class])..name2:sub(2).."|r"
				else
					name2 = " "
				end
				
				GameTooltip:AddDoubleLine(name1,name2)
			end
			GameTooltip:Show()
		else
			GameTooltip:Hide()
		end
	end
	
	self.buttonRemoveAll = ELib:Button(self,L.AttendanceRemoveAll):Point("TOPLEFT",self.list,"BOTTOMLEFT",0,-5):Size(120,20):OnClick(function()
		wipe(self.list.C)
		self.list:Update()
		UpdatePersonalData()
	end)
	self.buttonSelectAll = ELib:Button(self,L.AttendanceSelectAll):Point("LEFT",self.buttonRemoveAll,"RIGHT",5,0):Size(120,20):OnClick(function()
		for i=1,#self.list.L do
			self.list.C[i] = true
		end
		self.list:Update()
		UpdatePersonalData()
	end)
	self.buttonSelectConditions = ELib:Button(self,L.AttendanceSelectConditions):Point("LEFT",self.buttonSelectAll,"RIGHT",5,0):Size(120,20):OnClick(function()
		self.DialogSelectBoss:Show()
	end)
	
	self.buttonSetAlts = ELib:Button(self,L.AttendanceSetAlts):Point("TOPRIGHT",self.list,"BOTTOMRIGHT",0,-5):Size(120,20):Tooltip(L.AttendanceAltTooltip):OnClick(function()
		self.DialogSetAlts:Show()
	end)
	
	self.DialogSetAlts = ELib:Popup(L.AttendanceSetAlts):Size(450,370)
	self.DialogSetAlts:SetScript("OnHide",function(self)
		local text = self.Alts:GetText()
		local names = {strsplit("\n", text)}
		wipe(VMRT.Attendance.alts)
		for i=1,#names do
			local name1,name2 = names[i]:match("([^=]+)=([^=]+)")
			if name1 and name2 then
				VMRT.Attendance.alts[#VMRT.Attendance.alts +1] = {name1,name2}
			end
		end
		UpdatePersonalData()
	end)
	function self.DialogSetAlts:OnShow()
		local data = VMRT.Attendance.alts
		local text = ""
		for i=1,#data do
			text = text .. data[i][1].."="..data[i][2].."\n"
		end
		self.Alts:SetText(text)
	end	
	self.DialogSetAlts.Alts = ELib:MultiEdit(self.DialogSetAlts):Point("TOP",0,-20):Size(440,345)
	
	self.buttonExport = ELib:Button(self,L.Export):Point("TOPLEFT",self.list,"TOPRIGHT",5,0):Size(100,20):OnClick(function()
		self = module.options
		
		local alts = {}
		for i=1,#VMRT.Attendance.alts do
			local nameAlt,nameMain = VMRT.Attendance.alts[i][1],VMRT.Attendance.alts[i][2]
			alts[ nameAlt ] = nameMain
		end
		
		local text = "\t"
		local c,d = self.list.C,self.list.D
		local data,dates = {},{}
		for i=1,#d do
			if c[i] then
				dates[#dates+1] = {d[i][1],d[i][2]}
				for j=1,40 do
					local name = d[i][3][j]
					if name then
						name = name:sub(2)
						local isAlt = alts[ name ]
						if isAlt then
							name = isAlt
						end
						local pos = ExRT.F.table_find(data,name,1)
						if not pos then
							pos = #data + 1
							data[pos] = {name,{}}
						end
						data[pos][2][ d[i][2] ] = true
					end
				end
			end
		end
		sort(dates,function(a,b) return a[2]<b[2] end)
		sort(data,function(a,b) return a[1]<b[1] end)
		for i=1,#dates do
			text = text .. dates[i][1] .. "\t"
		end
		text = text:gsub("\t$","\n")
		for i=1,#data do
			text = text ..data[i][1].."\t"
			for j=1,#dates do
				if data[i][2][ dates[j][2] ] then
					text = text.."x"
				end
				text = text.."\t"
			end
			text = text:gsub("\t$","\n")
		end
		ExRT.F:Export(text)
	end)	
	
	local filter,FilterDo = {}
	
	self.DialogSelectBoss = ELib:Popup(L.AttendanceSelectConditions):Size(405,220)
	self.DialogSelectBoss.bossList = ELib:DropDown(self.DialogSelectBoss,230,15):Point(140,-20):Size(250):AddText(L.AttendanceFilterBoss)
	self.DialogSelectBoss.diffList = ELib:DropDown(self.DialogSelectBoss,230,15):Point(140,-45):Size(250):AddText(L.AttendanceFilterDiff)
	self.DialogSelectBoss.dateFrom_Day = ELib:DropDown(self.DialogSelectBoss,100,11):Point(140,-70):Size(60):AddText(L.AttendanceFilterDateFrom)
	self.DialogSelectBoss.dateFrom_Month = ELib:DropDown(self.DialogSelectBoss,150,13):Point("LEFT",self.DialogSelectBoss.dateFrom_Day,"RIGHT",5,0):Size(110)
	self.DialogSelectBoss.dateFrom_Year = ELib:DropDown(self.DialogSelectBoss,100,7):Point("LEFT",self.DialogSelectBoss.dateFrom_Month,"RIGHT",5,0):Size(70)
	self.DialogSelectBoss.dateTo_Day = ELib:DropDown(self.DialogSelectBoss,100,11):Point(140,-95):Size(60):AddText(L.AttendanceFilterDateTo)
	self.DialogSelectBoss.dateTo_Month = ELib:DropDown(self.DialogSelectBoss,150,13):Point("LEFT",self.DialogSelectBoss.dateTo_Day,"RIGHT",5,0):Size(110)
	self.DialogSelectBoss.dateTo_Year = ELib:DropDown(self.DialogSelectBoss,100,7):Point("LEFT",self.DialogSelectBoss.dateTo_Month,"RIGHT",5,0):Size(70)
	
	self.DialogSelectBoss.playersFilter = ELib:Edit(self.DialogSelectBoss):Point(140,-120):Size(250,20):OnChange(function(self,isUser)
		if not isUser then
			return
		end
		local text = self:GetText()
		if text == "" then
			text = nil
		end
		filter.player = text
	end)
		self.DialogSelectBoss.playersFilter.leftText = ELib:Text(self.DialogSelectBoss.playersFilter,L.AttendanceFilterPlayer,12):Point("RIGHT",self.DialogSelectBoss.playersFilter,"LEFT",-5,0):Right():Middle():Color():Shadow()
	
	self.DialogSelectBoss.onePerDayCheck = ELib:Check(self.DialogSelectBoss,"|cffffffff"..L.AttendanceFilterOnePerDay):Point(140,-145):Left(5):OnClick(function(self)
		filter.onePerDay = self:GetChecked()
	end)
	self.DialogSelectBoss.onlyThisCharCheck = ELib:Check(self.DialogSelectBoss,"|cffffffff"..L.sencounterOnlyThisChar..":"):Point(140,-170):Left(5):OnClick(function(self)
		filter.thisChar = self:GetChecked()
	end)
	
	
	self.DialogSelectBoss.buttonSelect = ELib:Button(self.DialogSelectBoss,L.AttendanceSelect):Point("TOP",0,-195):Size(120,20):OnClick(function()
		self.DialogSelectBoss:Hide()
		FilterDo()
	end)
	
	function FilterDo()
		local dateFrom,dateTo
		if filter.fromDay and filter.fromMonth and filter.fromYear then
			dateFrom = time({year = filter.fromYear, month = filter.fromMonth, day = filter.fromDay, hour = 0, min = 0, sec = 0})
		end
		if filter.toDay and filter.toMonth and filter.toYear then
			dateTo = time({year = filter.toYear, month = filter.toMonth, day = filter.toDay, hour = 0, min = 0, sec = 0})
		end
		if dateFrom and not dateTo then
			dateTo = time()
		end
		if dateTo and not dateFrom then
			dateFrom = 0
		end
		for i=1,#self.list.L do
			local filtered = true
			local d = self.list.D[i][3]
			if filter.boss and filter.boss ~= d.eN then
				filtered = nil
			end
			if filter.diff and filter.diff ~= d.d then
				filtered = nil
			end
			if filtered and dateFrom and not (d.t >= dateFrom and d.t <= dateTo) then
				filtered = nil
			end
			if filtered and filter.player then
				local isExistPlayer = false
				for j=1,40 do
					if d[j] and (d[j]:find("^[A-Z]"..filter.player.."$") or d[j]:find("^[A-Z]"..filter.player.."%-")) then
						isExistPlayer = true
						break
					end
				end
				if not isExistPlayer then
					filtered = nil
				end
			end
			if filter.thisChar and d.c ~= ExRT.SDB.charKey then
				filtered = nil
			end
			self.list.C[i] = filtered
		end
		if filter.onePerDay then
			local lastD,lastM,lastY = nil
			for i=#self.list.L,1,-1 do
				if self.list.C[i] then
					local currTime = date("*t",self.list.D[i][3].t)
					if currTime.day == lastD and currTime.month == lastM and currTime.year == lastY then
						self.list.C[i] = nil
					end
					lastD,lastM,lastY = currTime.day, currTime.month, currTime.year
				end
			end
		end
		self.list:Update()
		UpdatePersonalData()
	end
	
	local function FilterBoss(self,arg1)
		filter.boss = arg1
		self:GetParent().parent:SetText(arg1 or "")
		ELib:DropDownClose()  
	end
	local function FilterDiff(self,arg1,arg2)
		filter.diff = arg1
		self:GetParent().parent:SetText(arg2 or "")
		ELib:DropDownClose()
	end
	local FilterDay,FilterMonth,FilterYear
	local function FilterClearDate(isTo)
		local pref1 = isTo and 'dateTo_' or 'dateFrom_'
		local pref2 = isTo and 'to' or 'from'
		self.DialogSelectBoss[pref1..'Day']:SetText("")
		filter[pref2..'Day'] = nil
		self.DialogSelectBoss[pref1..'Month']:SetText("")
		filter[pref2..'Month'] = nil
		self.DialogSelectBoss[pref1..'Year']:SetText("")
		filter[pref2..'Year'] = nil
	end
	function FilterDay(self,arg1,isTo)
		filter[isTo and 'toDay' or 'fromDay'] = arg1
		self:GetParent().parent:SetText(arg1 or "")
		if not arg1 then
			FilterClearDate(isTo)
		end
		ELib:DropDownClose()
	end
	function FilterMonth(self,arg1,arg2,isTo)
		filter[isTo and 'toMonth' or 'fromMonth'] = arg1
		self:GetParent().parent:SetText(arg2 or "")
		if not arg1 then
			FilterClearDate(isTo)
		end
		ELib:DropDownClose()
	end
	function FilterYear(self,arg1,isTo)
		filter[isTo and 'toYear' or 'fromYear'] = arg1
		self:GetParent().parent:SetText(arg1 or "")
		if not arg1 then
			FilterClearDate(isTo)
		end
		ELib:DropDownClose()
	end
	
	do
		local FD = {{text = " - ",func = FilterDay,arg2=false},}
		for i=1,31 do
			FD[#FD+1]={text = i,func = FilterDay,arg1=i,arg2=false}
		end
		self.DialogSelectBoss.dateFrom_Day.List = FD
		
		local FM = {
			{text = " - ",func = FilterMonth,arg3=false},
			{text = FULLDATE_MONTH_JANUARY,func = FilterMonth,arg1=1,arg2=FULLDATE_MONTH_JANUARY,arg3=false},
			{text = FULLDATE_MONTH_FEBRUARY,func = FilterMonth,arg1=2,arg2=FULLDATE_MONTH_FEBRUARY,arg3=false},
			{text = FULLDATE_MONTH_MARCH,func = FilterMonth,arg1=3,arg2=FULLDATE_MONTH_MARCH,arg3=false},
			{text = FULLDATE_MONTH_APRIL,func = FilterMonth,arg1=4,arg2=FULLDATE_MONTH_APRIL,arg3=false},
			{text = FULLDATE_MONTH_MAY,func = FilterMonth,arg1=5,arg2=FULLDATE_MONTH_MAY,arg3=false},
			{text = FULLDATE_MONTH_JUNE,func = FilterMonth,arg1=6,arg2=FULLDATE_MONTH_JUNE,arg3=false},
			{text = FULLDATE_MONTH_JULY,func = FilterMonth,arg1=7,arg2=FULLDATE_MONTH_JULY,arg3=false},
			{text = FULLDATE_MONTH_AUGUST,func = FilterMonth,arg1=8,arg2=FULLDATE_MONTH_AUGUST,arg3=false},
			{text = FULLDATE_MONTH_SEPTEMBER,func = FilterMonth,arg1=9,arg2=FULLDATE_MONTH_SEPTEMBER,arg3=false},
			{text = FULLDATE_MONTH_OCTOBER,func = FilterMonth,arg1=10,arg2=FULLDATE_MONTH_OCTOBER,arg3=false},
			{text = FULLDATE_MONTH_NOVEMBER,func = FilterMonth,arg1=11,arg2=FULLDATE_MONTH_NOVEMBER,arg3=false},
			{text = FULLDATE_MONTH_DECEMBER,func = FilterMonth,arg1=12,arg2=FULLDATE_MONTH_DECEMBER,arg3=false},
		}
		self.DialogSelectBoss.dateFrom_Month.List = FM		
		
		local maxYear = C_Calendar_GetDate().year
		local FY = {{text = " - ",func = FilterYear,arg2=false},}
		for i=maxYear-5,maxYear do
			FY[#FY+1]={text = i,func = FilterYear,arg1=i,arg2=false}
		end
		self.DialogSelectBoss.dateFrom_Year.List = FY		
	end
	do
		local FD = {{text = " - ",func = FilterDay,arg2=true},}
		for i=1,31 do
			FD[#FD+1]={text = i,func = FilterDay,arg1=i,arg2=true}
		end
		self.DialogSelectBoss.dateTo_Day.List = FD
		
		local FM = {
			{text = " - ",func = FilterMonth,arg3=true},
			{text = FULLDATE_MONTH_JANUARY,func = FilterMonth,arg1=1,arg2=FULLDATE_MONTH_JANUARY,arg3=true},
			{text = FULLDATE_MONTH_FEBRUARY,func = FilterMonth,arg1=2,arg2=FULLDATE_MONTH_FEBRUARY,arg3=true},
			{text = FULLDATE_MONTH_MARCH,func = FilterMonth,arg1=3,arg2=FULLDATE_MONTH_MARCH,arg3=true},
			{text = FULLDATE_MONTH_APRIL,func = FilterMonth,arg1=4,arg2=FULLDATE_MONTH_APRIL,arg3=true},
			{text = FULLDATE_MONTH_MAY,func = FilterMonth,arg1=5,arg2=FULLDATE_MONTH_MAY,arg3=true},
			{text = FULLDATE_MONTH_JUNE,func = FilterMonth,arg1=6,arg2=FULLDATE_MONTH_JUNE,arg3=true},
			{text = FULLDATE_MONTH_JULY,func = FilterMonth,arg1=7,arg2=FULLDATE_MONTH_JULY,arg3=true},
			{text = FULLDATE_MONTH_AUGUST,func = FilterMonth,arg1=8,arg2=FULLDATE_MONTH_AUGUST,arg3=true},
			{text = FULLDATE_MONTH_SEPTEMBER,func = FilterMonth,arg1=9,arg2=FULLDATE_MONTH_SEPTEMBER,arg3=true},
			{text = FULLDATE_MONTH_OCTOBER,func = FilterMonth,arg1=10,arg2=FULLDATE_MONTH_OCTOBER,arg3=true},
			{text = FULLDATE_MONTH_NOVEMBER,func = FilterMonth,arg1=11,arg2=FULLDATE_MONTH_NOVEMBER,arg3=true},
			{text = FULLDATE_MONTH_DECEMBER,func = FilterMonth,arg1=12,arg2=FULLDATE_MONTH_DECEMBER,arg3=true},
		}
		self.DialogSelectBoss.dateTo_Month.List = FM		
		
		local maxYear = C_Calendar_GetDate().year
		local FY = {{text = " - ",func = FilterYear,arg2=true},}
		for i=maxYear-5,maxYear do
			FY[#FY+1]={text = i,func = FilterYear,arg1=i,arg2=true}
		end
		self.DialogSelectBoss.dateTo_Year.List = FY		
	end
	
	
	self.EditPage = ELib:Popup(EDIT):Size(650,630)
	
	self.EditPage.classSelectDropDown = ELib:DropDownButton(self,"",150,ExRT.F.table_len(ExRT.GDB.ClassList)+1)
	self.EditPage.classSelectDropDown.isModern = true
	do
		local List = {}
		local function Select(_,class)
			local pos = self.EditPage.classSelectDropDown.ID
			self.EditPage.names[pos].class = class
			self.EditPage.names[pos]:SetTextColor(ExRT.F.classColorNum(class))
			ELib.ScrollDropDown:Close()
		end
		for i,class in ipairs(ExRT.GDB.ClassList) do
			List[i] = {
				arg1 = class,
				text = "|c"..ExRT.F.classColor(class)..L.classLocalizate[class],
				func = Select,
			}
		end
		List[#List + 1] = {text = L.minimapmenuclose,func = ELib.ScrollDropDown.Close}
		self.EditPage.classSelectDropDown.List = List
	end
	self.EditPage.classSelectDropDown:Hide()
	
	self.EditPage.names = {}
	for i=1,40 do
		self.EditPage.names[i] = ELib:Edit(self.EditPage):Size(150,20)
		if (i-1) % 5 == 0 then
			local group = ceil(i / 5)
			self.EditPage.names[i]:Point(group % 2 == 1 and 15 or 205,-40-floor((group-1)/2)*150)
			local txt = ELib:Text(self.EditPage.names[i],GROUP.." "..group):Color():Bottom():Left():Point("BOTTOMLEFT",self.EditPage.names[i],"TOPLEFT",5,3)
		else
			self.EditPage.names[i]:Point("TOPLEFT",self.EditPage.names[i-1],"BOTTOMLEFT",0,-5)
		end
		
		local classButton = ELib:Button(self.EditPage.names[i],"",1):Point("LEFT",self.EditPage.names[i],"RIGHT",5,0):Size(20,20):OnClick(function(self)
			local x,y = ExRT.F.GetCursorPos(self)
			module.options.EditPage.classSelectDropDown:SetPoint("TOPLEFT",self,x,-y)
			module.options.EditPage.classSelectDropDown.ID = i
			module.options.EditPage.classSelectDropDown:Click()
		end)
		ELib:Border(classButton,1,0.24,0.25,0.30,1)
		ELib:Texture(classButton,0,0,0,.3):Point('x')
		classButton:SetHighlightTexture( ELib:Texture(classButton,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128"):Point("TOPLEFT",-5,2):Point("BOTTOMRIGHT",5,-2):Color(1,1,1,1):TexCoord(0.25,0.3125,0.5,0.625) )
		classButton:SetNormalTexture( ELib:Texture(classButton,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128"):Point("TOPLEFT",-5,2):Point("BOTTOMRIGHT",5,-2):Color(1,1,1,.7):TexCoord(0.25,0.3125,0.5,0.625) )
		self.EditPage.names[i].classSelect = classButton
	end
	do
		self.EditPage.boss = ELib:Edit(self.EditPage):Size(240,20):Point("TOPRIGHT",-15,-50)
		local txtboss = ELib:Text(self.EditPage.boss,L.AttendanceFilterBoss):Color():Bottom():Left():Point("BOTTOMLEFT",self.EditPage.boss,"TOPLEFT",5,3)
		
		self.EditPage.diff_selected = nil
		self.EditPage.diff = ELib:DropDown(self.EditPage,220,5):Point("TOPRIGHT",-15,-100):Size(240)
		local txtdiff = ELib:Text(self.EditPage.diff,L.AttendanceFilterDiff):Color():Bottom():Left():Point("BOTTOMLEFT",self.EditPage.diff,"TOPLEFT",5,3)
		local function diff_SetVaule(_,arg1)
		  	self.EditPage.diff_selected = arg1
		  	self.EditPage.diff:SetText( arg1 and module.db.diffNames[ arg1 ] or " - " )
			ELib.ScrollDropDown:Close()
		end
		self.EditPage.diff.List = {
			{text = " - ",func = diff_SetVaule, arg1 = nil},
			{text = module.db.diffNames[14],func = diff_SetVaule, arg1 = 14},
			{text = module.db.diffNames[15],func = diff_SetVaule, arg1 = 15},
			{text = module.db.diffNames[16],func = diff_SetVaule, arg1 = 16},
			{text = L.minimapmenuclose,func = ELib.ScrollDropDown.Close},
		}
		
		self.EditPage.groupsize = ELib:Edit(self.EditPage,nil,true):Size(240,20):Point("TOPRIGHT",-15,-150)
		local txtgsize = ELib:Text(self.EditPage.groupsize,FLEX_RAID_SIZE_LABEL..":"):Color():Bottom():Left():Point("BOTTOMLEFT",self.EditPage.groupsize,"TOPLEFT",5,3)
		
		self.EditPage.isKill = ELib:Check(self.EditPage,COMBATLOG_HIGHLIGHT_KILL):Point("TOPLEFT",self.EditPage.groupsize, "BOTTOMLEFT", 0,-30)
		
		self.EditPage.Save = ELib:Button(self.EditPage,EDIT_TICKET):Point("BOTTOMRIGHT",-15,20):Size(240,25):OnClick(function()
			local data = self.EditPage.data
			for i=1,40 do
				local name = self.EditPage.names[i]:GetText()
				if name == "" then
					name = nil
				else
					name = classToLetter[ self.EditPage.names[i].class ]..name
				end
				data[i] = name
			end
			
			data.g = tonumber(self.EditPage.groupsize:GetText())
			data.d = self.EditPage.diff_selected
			data.eN = self.EditPage.boss:GetText()
			data.k = self.EditPage.isKill:GetChecked() and true or nil
		
			self.EditPage:Hide()
			UpdateData()
			UpdatePersonalData()
		end)
	end
	
	function self.EditPage:OnShow()
		local data = self.data
		
		for i=1,40 do
			local name = data[i]
			if not name then
				self.names[i]:SetText("")
				self.names[i].class = "WARRIOR"
				self.names[i]:SetTextColor(ExRT.F.classColorNum("WARRIOR")) 
			else
				local C = name:sub(1,1)
				name = name:sub(2)
				local class = letterToClass[C]
				self.names[i].class = class
				self.names[i]:SetTextColor(ExRT.F.classColorNum(class))
				self.names[i]:SetText(name)
			end
		end
		
		self.diff_selected = data.d
		self.diff:SetText( data.d and module.db.diffNames[ data.d ] or " - " )
		self.groupsize:SetText(data.g or "")
		self.boss:SetText(data.eN or "unk")
		self.isKill:SetChecked(data.k)
	end
	
	function UpdateData()
		local list,d,c = {},{},{}
		local bossList,diffList = {},{}
		for _,data in pairs(VMRT.Attendance.data) do
			local diff = data.d
			if diff then
				local isDiffExist = ExRT.F.table_find(diffList,diff)
				if not isDiffExist then
					diffList[#diffList + 1] = diff
				end			
			
				if diff == 14 then
					diff = " (N)"
				elseif diff == 15 then
					diff =" (H)"
				elseif diff == 16 then
					diff = " (M)"
				end
			else
				diff = ""
			end
			local isKill = data.k and " [kill]" or ""
			d[#d+1] = {date("%d/%m/%Y %H:%M:%S",data.t).." - "..(data.eN or "unk")..diff..isKill,data.t,data}
			
			local isBossExist = ExRT.F.table_find(bossList,data.eN)
			if not isBossExist then
				bossList[#bossList + 1] = data.eN
			end
		end
		sort(d,function(a,b)return a[2]>b[2] end)
		for i=1,#d do
			list[i] = d[i][1]
			c[i]=true
		end
		self.list.C = c
		self.list.L = list
		self.list.D = d
		self.list:Update()
		
		local dropDownBoss = {
			{text = " - ",func = FilterBoss,},
		}
		for i=#bossList,1,-1 do
			dropDownBoss[#dropDownBoss+1]={ text = bossList[i],func = FilterBoss,arg1=bossList[i] }
		end
		self.DialogSelectBoss.bossList.List = dropDownBoss
		
		local dropDownDiff = {
			{text = " - ",func = FilterDiff,},
		}
		for i=1,#diffList do
			local name = module.db.diffNames[ diffList[i] ]
			if name then
				dropDownDiff[#dropDownDiff+1]={ text = name,func = FilterDiff,arg1=diffList[i],arg2=name }
			end
		end
		self.DialogSelectBoss.diffList.List = dropDownDiff
	end
	UpdateData()
	
	self.stats = ELib:ScrollTableList(self,0,50,75,50,75):Point("TOPLEFT",self.list,"BOTTOMLEFT",0,-35):Size(550,195)
	
	function UpdatePersonalData()
		local alts = {}
		local nameToClass = {}
		for i=1,#VMRT.Attendance.alts do
			local nameAlt,nameMain = VMRT.Attendance.alts[i][1],VMRT.Attendance.alts[i][2]
			alts[ nameAlt ] = nameMain
			if not nameToClass[ nameMain ] then
				local finded = nil
				for j=1,#VMRT.Attendance.data do
					local p = VMRT.Attendance.data[j]
					for k=1,40 do
						if p[k] and p[k]:sub(2) == nameMain then
							nameToClass[ nameMain ] = p[k]
							finded = true
							break
						end
					end
					if finded then
						break
					end
				end
				if not finded then
					nameToClass[ nameMain ] = "Z" .. nameMain
				end
			end
		end
	
		local c,d = self.list.C,self.list.D
		local data,count = {},0
		for i=1,#d do
			if c[i] then
				count = count + 1
				local max = d[i][3].d == 16 and 20 or d[i][3].g or 30
				for j=1,40 do
					local name = d[i][3][j]
					if name then
						local isAlt = alts[ name:sub(2) ]
						if isAlt then
							name = nameToClass[ isAlt ]
						end
						local pos = ExRT.F.table_find(data,name,1)
						if not pos then
							pos = #data + 1
							data[pos] = {name,0,0}
						end
						data[pos][2] = data[pos][2] + 1
						if j <= max then
							data[pos][3] = data[pos][3] + 1
						end
					end
				end
			end
		end
		if VMRT.Attendance.OptionsSortPD then
			sort(data,function(a,b) if a[2]==b[2] then return a[1]:sub(2)<b[1]:sub(2) else return a[2]>b[2] end end)
		else
			sort(data,function(a,b) if a[3]==b[3] then return a[1]:sub(2)<b[1]:sub(2) else return a[3]>b[3] end end)
		end
		local list = {}
		for i=1,#data do
			list[i] = {
				"|c"..ExRT.F.classColor(letterToClass[data[i][1]:sub(1,1)])..data[i][1]:sub(2).."|r",
				data[i][2],
				format("%.1f%%",data[i][2]/count*100),
				data[i][3],
				format("%.1f%%",data[i][3]/count*100),
			}
		end
		self.stats.L = list
		self.stats:Update()
	end
	UpdatePersonalData()
	
	self.sortBytext = ELib:Text(self,COMPACT_UNIT_FRAME_PROFILE_SORTBY,11):Point("TOPLEFT",self.stats,"TOPRIGHT",10,-5)
	
	self.sortBy1 = ELib:Radio(self,"1",VMRT.Attendance.OptionsSortPD):Point("TOPLEFT",self.stats,"TOPRIGHT",5,-20):OnClick(function()
		VMRT.Attendance.OptionsSortPD = true
		self.sortBy1:SetChecked(true)
		self.sortBy2:SetChecked(false)
		UpdatePersonalData()
	end)
	self.sortBy2 = ELib:Radio(self,"2",not VMRT.Attendance.OptionsSortPD):Point("TOPLEFT",self.stats,"TOPRIGHT",5,-40):OnClick(function()
		VMRT.Attendance.OptionsSortPD = nil
		self.sortBy1:SetChecked(false)
		self.sortBy2:SetChecked(true)
		UpdatePersonalData()
	end)
	
	local deleteReady = nil
	
	self.rightClickDropDown = ELib:DropDownButton(self,"",150,3)
	self.rightClickDropDown.isModern = true
	self.rightClickDropDown.List = {
		{text = EDIT,func = function(_,arg1)
			self.EditPage.data = self.list.D[arg1][3]
			self.EditPage:NewPoint("CENTER",UIParent,0,0)
			self.EditPage:Show()
			ELib.ScrollDropDown:Close()
		end},
		{text = DELETE,func = function(_,arg1)
			if not deleteReady then
				self.rightClickDropDown.List[2].text = "|cff00ff00"..DELETE
				deleteReady = true
				ELib.ScrollDropDown:Reload(1)
				return
			end
			local data = self.list.D[arg1][3]
			for i=1,#VMRT.Attendance.data do
				if VMRT.Attendance.data[i] == data then
					tremove(VMRT.Attendance.data,i)
					break
				end
			end
			ELib.ScrollDropDown:Close()
			UpdateData()
			UpdatePersonalData()
		end},
		{text = L.minimapmenuclose,func = ELib.ScrollDropDown.Close},
	}
	self.rightClickDropDown:Hide()
	local function ListRightClick(index)
		deleteReady = nil
		self.rightClickDropDown.List[2].text = self.rightClickDropDown.List[2].text:gsub("|cff00ff00","")
		self.rightClickDropDown.List[1].arg1 = index
		self.rightClickDropDown.List[2].arg1 = index
		local x,y = ExRT.F.GetCursorPos(self.list)
		self.rightClickDropDown:SetPoint("TOPLEFT",self.list,x,-y)
		self.rightClickDropDown:Click()
	end
	
	function self.list:SetListValue(index,button,...)
		if button ~= "RightButton" then
			UpdatePersonalData()
		else
			ListRightClick(index)
		end
	end

	
	self.clearButton = ELib:Button(self,L.MarksClear):Size(100,20):Point("LEFT",self.buttonExport,0,0):Point("TOP",self,0,-30):Tooltip(L.CoinsClear):OnClick(function() 
		StaticPopupDialogs["EXRT_ATTENDANCE_CLEAR"] = {
			text = L.CoinsClearPopUp,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				table.wipe(VMRT.Attendance.data)
				UpdateData()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_ATTENDANCE_CLEAR")
	end)

	self.saveRoster = ELib:Button(self,L.AttendanceSaveCurrent):Size(200,20):Point("RIGHT",self.clearButton,"LEFT",-5,0):OnClick(function() 
		SaveCurrentRaidRoster()
	end)
	
	self.HelpPlate = {
		FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
		[1] = { ButtonPos = { x = 150,	y = -65 },  	HighLightBox = { x = 0, y = -0, width = 560, height = 180 },		ToolTipDir = "RIGHT",	ToolTipText = L.AttendanceHelpTop },
		[2] = { ButtonPos = { x = 150,	y = -475 },  	HighLightBox = { x = 0, y = -410, width = 560, height = 200 },		ToolTipDir = "RIGHT",	ToolTipText = L.AttendanceHelpNames },
	}

	if not ExRT.isClassic then
		self.HELPButton = ExRT.lib.CreateHelpButton(self,self.HelpPlate)
		self.HELPButton:SetPoint("CENTER",self,"TOPLEFT",0,15)
	end
	
	function self:UpdatePageData()
		UpdateData()
	end
	
	function self:OnShow()
		UpdateData()
	end
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.Attendance = VMRT.Attendance or {}
	VMRT.Attendance.data = VMRT.Attendance.data or {}
	VMRT.Attendance.alts = VMRT.Attendance.alts or {}
	
	module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END','GROUP_ROSTER_UPDATE')
	module:RegisterSlash()
	module:RegisterAddonMessage()
	
	module.main:GROUP_ROSTER_UPDATE()
end

local isInRaid,isFirstEncounterByRaid = nil

function SaveRaidRoster(encounterID,encounterName,difficultyID,groupSize,isKill)
	local s = {
		t = time(),
		eI = encounterID,
		eN = encounterName,
		d = difficultyID,
		k = isKill,
		c = ExRT.SDB.charKey,
		g = groupSize,
	}
	VMRT.Attendance.data[#VMRT.Attendance.data + 1] = s
	local ppgroup = {0,0,0,0,0,0,0,0}
	
	for i=1,40 do
		local name, rank, subgroup, level, _, class, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
		if name then
			ppgroup[ subgroup ] = ppgroup[ subgroup ] + 1
			local pos = (subgroup - 1)*5 + ppgroup[ subgroup ]
			--[[
			ACCCC
			
			A - class
			CCCC - name
			
			]]
			s[pos] = classToLetter[class]..name
		end
	end
	
	if module.options:IsShown() then
		module.options:UpdatePageData()
	end
end
function SaveCurrentRaidRoster()
	local name, zoneType, difficulty, _, _, _, _, _, instanceGroupSize = GetInstanceInfo()
	if zoneType ~= 'raid' then
		difficulty = nil
	end
	SaveRaidRoster(nil,name,difficulty,instanceGroupSize)
end

local function CheckSpecialConditions(encounterID,encounterName,difficultyID,isKill)
	if type(VMRT.Attendance.enabled) ~= 'string' then
		return
	end
	difficultyID = difficultyID or "0"
	encounterName = encounterName or "=NOENC"
	encounterID = encounterID or 0
	local conds = {strsplit(";", VMRT.Attendance.enabled)}
	for i=1,#conds do
		local cond = conds[i]:lower()
		if (cond:find("^"..encounterID) or cond:find("^"..encounterName:lower())) and (not cond:find(",kill") or isKill) and (not cond:find(",d=") or cond:find(",d="..difficultyID)) then
			return true
		end
		if cond:find("^d="..difficultyID) then
			return true
		end
	end
end

local lastStartEvent,lastEndEvent = 0,0

local function EncounterStartLog(encounterID, encounterName, difficultyID, groupSize)
	if (not ExRT.isClassic and not (difficultyID == 14 or difficultyID == 15 or difficultyID == 16)) or (ExRT.isClassic and not (difficultyID == 9 or difficultyID == 148 or difficultyID == 175 or difficultyID == 176)) then
		return
	end
	if (VMRT.Attendance.enabled == 1 and isFirstEncounterByRaid) or VMRT.Attendance.enabled == 3 or CheckSpecialConditions(encounterID,encounterName,difficultyID) then
		SaveRaidRoster(encounterID, encounterName, difficultyID, groupSize)
		isFirstEncounterByRaid = nil
	end
end
local function EncounterEndLog(encounterID, encounterName, difficultyID, groupSize, isKill)
	if not (isKill == 1) or (not ExRT.isClassic and not (difficultyID == 14 or difficultyID == 15 or difficultyID == 16)) or (ExRT.isClassic and not (difficultyID == 9 or difficultyID == 148 or difficultyID == 175 or difficultyID == 176)) then
		return
	end
	if (VMRT.Attendance.enabled == 2 and isFirstEncounterByRaid) or VMRT.Attendance.enabled == 4 or CheckSpecialConditions(encounterID,encounterName,difficultyID,isKill==1) then
		SaveRaidRoster(encounterID, encounterName, difficultyID, groupSize, true)
		isFirstEncounterByRaid = nil
	end
end

function module:addonMessage(sender, prefix, event, encounterID, encounterName, difficultyID, groupSize, isKill)
	if prefix == "raidatt_event" then
		local time = GetTime()
		if event == "ENCOUNTER_START" and (time - lastStartEvent) > 5 then
			lastStartEvent = time
			EncounterStartLog(tonumber(encounterID), encounterName, tonumber(difficultyID), tonumber(groupSize))
		end
		if event == "ENCOUNTER_END" and (time - lastEndEvent) > 5 then
			lastEndEvent = time
			EncounterEndLog(tonumber(encounterID), encounterName, tonumber(difficultyID), tonumber(groupSize), tonumber(isKill))
		end
	end
end

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	if not IsInRaid() then	--Disable this in 5ppl or solo
		return
	end
	EncounterStartLog(encounterID, encounterName, difficultyID, groupSize)
	lastStartEvent = GetTime()
	ExRT.F.Timer(ExRT.F.SendExMsg, 1, "raidatt_event","ENCOUNTER_START\t"..(encounterID or 0).."\t"..(encounterName or "unk").."\t"..(difficultyID or 0).."\t"..(groupSize or 0))
end

function module.main:ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, isKill)
	if not IsInRaid() then	--Disable this in 5ppl or solo
		return
	end
	EncounterEndLog(encounterID, encounterName, difficultyID, groupSize, isKill)
	lastEndEvent = GetTime()
	ExRT.F.Timer(ExRT.F.SendExMsg, 1, "raidatt_event", "ENCOUNTER_END\t"..(encounterID or 0).."\t"..(encounterName or "unk").."\t"..(difficultyID or 0).."\t"..(groupSize or 0).."\t"..(isKill or 0))
end

function module.main:GROUP_ROSTER_UPDATE()
	if not isInRaid and IsInRaid() then
		isInRaid = true
		isFirstEncounterByRaid = true
	elseif isInRaid and not IsInRaid() then
		isInRaid = nil
		isFirstEncounterByRaid = nil
	end
end

function module:slash(arg)
	if arg:find("^roster") or arg:find("^save roster") then
		SaveCurrentRaidRoster()
		print(L.AttendanceChatMessageSaved)
	end
end