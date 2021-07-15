local GlobalAddonName, ExRT = ...

local bit_band = bit.band

local VMRT = nil

local module = ExRT:New("Encounter",ExRT.L.sencounter)
local ELib,L = ExRT.lib,ExRT.L

module.db.isEncounter = nil
module.db.diff = nil
module.db.nowInTable = nil
module.db.afterCombatFix = nil
module.db.diffNames = {
	[1] = L.sencounter5ppl,
	[2] = L.sencounter5pplHC,
	[3] = L.EncounterLegacy..": "..L.sencounter10ppl,
	[4] = L.EncounterLegacy..": "..L.sencounter25ppl,
	[5] = L.EncounterLegacy..": "..L.sencounter10pplHC,
	[6] = L.EncounterLegacy..": "..L.sencounter25pplHC,
	[7] = L.sencounterLfr,		--		PLAYER_DIFFICULTY3
	[8] = CHALLENGES or L.sencounterChall,
	[9] = L.EncounterLegacy..": "..L.sencounter40ppl,
	[14] = L.sencounterWODNormal,	-- Normal,	PLAYER_DIFFICULTY1
	[15] = L.sencounterWODHeroic,	-- Heroic,	PLAYER_DIFFICULTY2
	[16] = L.sencounterWODMythic,	-- Mythic,	PLAYER_DIFFICULTY6
	[23] = DUNGEON_DIFFICULTY_5PLAYER..": "..PLAYER_DIFFICULTY6,
	[148] = "20ppl raid",
	[175] = "10 ppl",
	[176] = "25 ppl",
}
module.db.diffPos = ExRT.isBC and {1,148,9,3,4,175,176} or ExRT.isClassic and {1,148,9} or {24,1,2,23,8,9,3,4,5,6,7,14,15,16}
module.db.dropDownNow = nil
module.db.onlyMy = nil
module.db.scrollPos = 1
module.db.playerName = nil
module.db.pullTime = 0

module.db.chachedDB = nil

function module.options:Load()
	local table_find = ExRT.F.table_find3

	module.db.sortedList = ExRT.F.GetEncountersList()

	local LegacyDiffs = {
		[3]=true,
		[4]=true,
		[5]=true,
		[6]=true,
	}
	
	local function GetEncounterSortIndex(id,unk)
		for i=1,#module.db.sortedList do
			local dung = module.db.sortedList[i]
			for j=2,#dung do
				if id == dung[j] then
					return i * 100 + j
				end
			end
		end
		return unk
	end
	local function GetEncounterMapID(id)
		for i=1,#module.db.sortedList do
			local dung = module.db.sortedList[i]
			for j=2,#dung do
				if id == dung[j] then
					return dung[1]
				end
			end
		end
		return -999
	end

	self:CreateTilte()
	
	local function ConvertNumberToTime(num)
		local str = ""
		local s = num % 60
		num = floor(num / 60)
		local m = num % 60
		num = floor(num / 60)
		str = format("%d:%02d",m,s)
		if num == 0 then return str end
		local h = num % 24
		num = floor(num / 24)
		str = format("%d:%02d:%02d",h,m,s)
		if num == 0 then return str end
		return num .. "." .. str
	end

	local updatesPerLast10sec = 0
	local updatesPerLast10secLast = 0
	
	self.dropDown = ELib:DropDown(self,220,#module.db.diffPos):Size(235):Point(445+2,-31)
	function self.dropDown:SetValue(newValue,resetDB)
		if module.db.dropDownNow ~= newValue then
			module.db.scrollPos = 1
			module.options.ScrollBar:SetValue(1)
		end
		if resetDB then
			module.db.chachedDB = nil
		end
		module.db.dropDownNow = newValue
		local newDiff = module.db.diffPos[newValue]
		module.options.dropDown:SetText(module.db.diffNames[newDiff] or GetDifficultyInfo(newDiff))
		ELib:DropDownClose()
		local myName = UnitName("player")
		
		local encounters = module.db.chachedDB or {}
		local currDate = time()
		
		local minPullTime = LegacyDiffs[ newDiff ] and 0 or 30
		
		if not module.db.chachedDB then
			for playerName,playerData in pairs(VMRT.Encounter.list) do
				if not module.db.onlyMy or playerName == module.db.playerName then
					
					for i=1,#playerData do
						local data = playerData[i]
						local isNewFormat = data:find("^%^")
						local diffID
						if isNewFormat then
							diffID = tonumber( select (3, strsplit("^",data) ), nil )
						else
							diffID = tonumber( string.sub(data,4,4),16 ) + 1
						end
						if diffID == newDiff then
							local encounterID, pull, pullTime, isKill, groupSize, firstBloodName, raidIlvl, _
						
							if isNewFormat then
								_, encounterID, _, pull, pullTime, isKill, groupSize, raidIlvl, firstBloodName = strsplit("^", data)
								encounterID = tonumber(encounterID)
								pull = tonumber(pull)
								pullTime = tonumber(pullTime)
								isKill = isKill == "1"
								groupSize = tonumber(groupSize)
							else
								encounterID = tonumber( string.sub(data,1,3),16 )
								pull = tonumber( string.sub(data,5,14),nil )
								pullTime = tonumber( string.sub(data,15,17),16 )
								isKill = string.sub(data,18,18) == "1"
								groupSize = tonumber(string.sub(data,19,20),nil)
								firstBloodName = string.sub(data,21)							
							end
							raidIlvl = tonumber(raidIlvl or "0")
							if firstBloodName == "" then 
								firstBloodName = nil
							end
							
							local encounterLine = table_find(encounters,encounterID,"id")
							if not encounterLine then
								encounterLine = {
									id = encounterID,
									firstBlood = {},
									pullTable = {},
									name = VMRT.Encounter.names[encounterID] or "Unknown",
									pulls = 0,
									kills = 0,
									mapID = GetEncounterMapID(encounterID),
								}
								encounters[#encounters + 1] = encounterLine
							end
							
							encounterLine.first = min( encounterLine.first or currDate, pull )
							if isKill then
								encounterLine.killTime = min( encounterLine.killTime or 4095, pullTime )
								encounterLine.kills = encounterLine.kills + 1
								if not encounterLine.firstKill then
									encounterLine.firstKill = encounterLine.pulls + 1
								end
								encounterLine.pulls = encounterLine.pulls + 1
							else
								encounterLine.wipeTime = max( encounterLine.wipeTime or 0, pullTime )
								if not pullTime or pullTime >= minPullTime then--or pullTime == 0 then
									encounterLine.pulls = encounterLine.pulls + 1
								end
							end
							
							if firstBloodName then
								local firstBloodLine = table_find(encounterLine.firstBlood,firstBloodName,"n")
								if not firstBloodLine then
									encounterLine.firstBlood[#encounterLine.firstBlood + 1] = { 
										n = firstBloodName,
										c = 1,
									}
								else
									firstBloodLine.c = firstBloodLine.c + 1
								end
							end
							
							encounterLine.pullTable[ #encounterLine.pullTable + 1 ] = {
								t = pull,
								d = pullTime,
								k = isKill,
								s = groupSize,
								fb = firstBloodName,
								i = raidIlvl,
							}
						end
					end			
				end
			end
		
			--sort(encounters,function(a,b) return a.first > b.first end)
			sort(encounters,function(a,b) return GetEncounterSortIndex(a.id,a.first) > GetEncounterSortIndex(b.id,b.first) end)
			
			for _,encounterData in pairs(encounters) do
				sort(encounterData.firstBlood,function(a,b) return a.c > b.c end)
				sort(encounterData.pullTable,function(a,b) return a.t < b.t end)
				
				
				local totalTime,isFK = 0
				local legitPulls = 0

				for i=1,#encounterData.pullTable do
					if not encounterData.pullTable[i].d or encounterData.pullTable[i].d >= minPullTime then--or encounterData.pullTable[i].d == 0 then
						legitPulls = legitPulls + 1
					end
					if not isFK and encounterData.pullTable[i].k then
						encounterData.firstKill = legitPulls
						isFK = true
					end
					totalTime = totalTime + (encounterData.pullTable[i].d or 0)
				end
				
				if not encounterData.killTime or encounterData.killTime == 4095 then
					encounterData.killTime = 0
				end
				encounterData.wipeTime = encounterData.wipeTime or 0
				encounterData.wipeTime = totalTime
			end
			
			local prev = nil
			for i=#encounters,1,-1 do
				local eLine = encounters[i]
				if not prev then
					prev = eLine.mapID
				end
				if prev ~= eLine.mapID or i==1 then
					local name = type(prev)=='string' and {name=prev} or C_Map.GetMapInfo(prev or -999)
					if name then
						tinsert(encounters,i==1 and 1 or i+1,{
							isHeader = true,
							name = name.name,
						})
					end
					prev = eLine.mapID
				end
			end
			
		end
		
		module.db.chachedDB = encounters

		local now = GetTime()
		local stopPortraitUpdate
		if now - updatesPerLast10secLast > 10 then
			updatesPerLast10sec = 0
		end
		updatesPerLast10sec = updatesPerLast10sec + 1
		if updatesPerLast10sec >= 20 then
			stopPortraitUpdate = true
		end
			
		local j = 0
		for i=module.db.scrollPos,#encounters do
			j = j + 1
			local encounterLine = encounters[i]
			local optionsLine = module.options.line[j]

			if not optionsLine then
				j = j - 1
				break
			end
		
			if encounterLine.isHeader then
				optionsLine.headertext:SetText(encounterLine.name)
				optionsLine.boss:SetText("")
				optionsLine.wipeBK:SetText("")
				optionsLine.wipe:SetText("")
				optionsLine.kill:SetText("")
				optionsLine.firstBlood:SetText("")
				optionsLine.longest:SetText("")
				optionsLine.fastest:SetText("")
				optionsLine.bossImg:SetTexture("")
				
				optionsLine.headerHL:Show()
				optionsLine.pullClick:Hide()
				optionsLine.firstBloodB:Hide()
			else
				optionsLine.headertext:SetText("")
				optionsLine.boss:SetText(encounterLine.name)
				optionsLine.wipeBK:SetText(encounterLine.firstKill or "-")
				optionsLine.wipe:SetText(encounterLine.pulls)
				optionsLine.kill:SetText(encounterLine.kills)
				optionsLine.firstBlood:SetText(encounterLine.firstBlood[1] and encounterLine.firstBlood[1].n or "")
				optionsLine.longest:SetText(ConvertNumberToTime(encounterLine.wipeTime))
				optionsLine.fastest:SetText(date("%M:%S",encounterLine.killTime))
				if encounterLine.wipeTime == 0 then optionsLine.longest:SetText("-") end
				if encounterLine.killTime == 0 then optionsLine.fastest:SetText("-") end

				if ExRT.GDB.encounterIDtoEJ[encounterLine.id] and not ExRT.isClassic and not stopPortraitUpdate then
					local displayInfo = select(4, EJ_GetCreatureInfo(1, ExRT.GDB.encounterIDtoEJ[encounterLine.id]))
					if displayInfo then
						SetPortraitTextureFromCreatureDisplayID(optionsLine.bossImg, displayInfo)
					else
						optionsLine.bossImg:SetTexture("")
					end
				else
					optionsLine.bossImg:SetTexture("")
				end
				
				optionsLine.firstBloodB.n = encounterLine.firstBlood
				optionsLine.pullClick.n = encounterLine.pullTable
				optionsLine.pullClick.bossName = encounterLine.name or ""
				
				optionsLine.headerHL:Hide()
				optionsLine.pullClick:Show()
				optionsLine.firstBloodB:Show()

				optionsLine.data = encounterLine
			end
			optionsLine:Show()
		end
		for i=(j+1),#module.options.line do
			module.options.line[i]:Hide()
		end
		module.options.ScrollBar:SetMinMaxValues(1,max(#encounters-(#module.options.line-1),1))
		module.options.ScrollBar:UpdateButtons()
		module.options.FBframe:Hide()
		module.options.PullsFrame:Hide()
	end

	for i=1,#module.db.diffPos do
		local diffID = module.db.diffPos[i]
		self.dropDown.List[i] = {text = module.db.diffNames[diffID] or GetDifficultyInfo(diffID), justifyH = "CENTER", arg1 = i, arg2 = true, func = self.dropDown.SetValue}
	end
	
	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(698,562)
	self.borderList:SetPoint("TOP", 0, -55)

	self.borderList.decorationLine = ELib:DecorationLine(self.borderList,true):Point("TOP",self.borderList,0,-2):Point("LEFT",self,0,0):Point("RIGHT",self,0,0):Size(0,18)

	local function LineOnEnter(self)
		if self.pullClick.n then 
			self.hl:Show() 
		end 
		
		if self.data and ExRT.GDB.encounterIDtoEJ[self.data.id] and not ExRT.isClassic then
			local displayInfo, bossImage = select(4, EJ_GetCreatureInfo(1, ExRT.GDB.encounterIDtoEJ[self.data.id]))
			if displayInfo then
				SetPortraitTextureFromCreatureDisplayID(module.options.bigImage, displayInfo)
				module.options.bigImage:Show()
			end
		end
	end
	local function LineOnLeave(self)
		self.hl:Hide() 
		module.options.bigImage:Hide()
	end
	local function LineFirstBloodClick(self)
		if not self.n or #self.n == 0 then 
			return 
		end
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		module.options.FBframe:ClearAllPoints()
		module.options.FBframe:SetPoint("BOTTOMLEFT",UIParent,x,y)
		for i=1,#module.options.FBframe.txtL do
			if self.n[i] then
				module.options.FBframe.txtL[i]:SetText(self.n[i].n)
				module.options.FBframe.txtR[i]:SetText(self.n[i].c)
				module.options.FBframe.txtR[i]:Show()
				module.options.FBframe.txtL[i]:Show()				
			else
				module.options.FBframe.txtR[i]:Hide()
				module.options.FBframe.txtL[i]:Hide()
			end
		end
		module.options.FBframe:Show() 
		module.options.PullsFrame:Hide()
	end
	local function LineFirstBloodOnEnter(self)
		local parent = self:GetParent()
		parent.firstBlood:SetTextColor(1,1,0.5,1)
		parent:GetScript("OnEnter")(parent)
	end
	local function LineFirstBloodOnLeave(self)
		local parent = self:GetParent()
		parent.firstBlood:SetTextColor(1,1,1,1)
		parent:GetScript("OnLeave")(parent)
	end
	local function LinePullsClick(self)
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		module.options.PullsFrame:ClearAllPoints()
		module.options.PullsFrame:SetPoint("BOTTOMLEFT",UIParent,x,y)
		module.options.PullsFrame.data = self.n
		module.options.PullsFrame.boss = self.bossName
		module.options.PullsFrame.ScrollBar:SetValue(1)
		module.options.PullsFrame:SetBoss()
		
		module.options.graphsFrame.data = self.n
	end
	local function LinePullsOnEnter(self)
		local parent = self:GetParent()
		parent.wipe:SetTextColor(1,0.5,0.5,1)
		parent:GetScript("OnEnter")(parent)
	end
	local function LinePullsOnLeave(self)
		local parent = self:GetParent()
		parent.wipe:SetTextColor(1,1,1,1)
		parent:GetScript("OnLeave")(parent)
	end
	
	self.line = {}
	for i=0,31 do
		local line = CreateFrame("Frame",nil,self.borderList)     
		self.line[i] = line
		line:SetSize(673,18)        
		line:SetPoint("TOPLEFT",0,-3-18*i) 

		line.boss = ELib:Text(line,"",11):Size(0,18):Point("LEFT",15,0):Color()
		line.wipeBK = ELib:Text(line,"",11):Size(40,18):Point("LEFT",280,0):Color()
		line.wipe = ELib:Text(line,"",11):Size(40,18):Point("LEFT",325,0):Color()
		line.kill = ELib:Text(line,"",11):Size(40,18):Point("LEFT",370,0):Color()
		line.firstBlood = ELib:Text(line,"",11):Size(100,18):Point("LEFT",415,0):Color()
		line.longest = ELib:Text(line,"",11):Size(75,18):Point("LEFT",520,0):Color()
		line.fastest = ELib:Text(line,"",11):Size(75,18):Point("LEFT",595,0):Color()
		line.headertext = ELib:Text(line,"",11):Point("LEFT",0,0):Point("RIGHT",0,0):Center():Color()
		
		if i>0 then
			ExRT.lib.CreateHoverHighlight(line)
			line.hl:SetVertexColor(0.3,0.3,0.7,0.7)
			line:SetScript("OnEnter",LineOnEnter)
			line:SetScript("OnLeave",LineOnLeave)	
			
			ExRT.lib.CreateHoverHighlight(line,"headerHL",1)
			line.headerHL:SetVertexColor(0.6,0.6,0.6,0.7)
		
			line.firstBloodB = CreateFrame("Button",nil,line)  
			line.firstBloodB:SetAllPoints(line.firstBlood)
			line.firstBloodB:SetScript("OnClick",LineFirstBloodClick)
			line.firstBloodB:SetScript("OnEnter",LineFirstBloodOnEnter)
			line.firstBloodB:SetScript("OnLeave",LineFirstBloodOnLeave)

			line.pullClick = CreateFrame("Button",nil,line)  
			line.pullClick:SetAllPoints(line.wipe)
			line.pullClick:SetScript("OnClick",LinePullsClick)
			line.pullClick:SetScript("OnEnter",LinePullsOnEnter)
			line.pullClick:SetScript("OnLeave",LinePullsOnLeave)	

			line.bossImg = line:CreateTexture(nil, "ARTWORK")
			line.bossImg:SetSize(18,18)
			line.bossImg:SetPoint("LEFT",line.boss,"RIGHT",4,0)
		end
	end
	self.line[0].wipe:SetSize(50,18)
	self.line[0].wipe:SetPoint("LEFT", 287+30+5,0)

	self.line[0].boss:SetText(L.sencounterBossName)
	self.line[0].wipeBK:SetText(L.sencounterFirstKill)
	self.line[0].wipe:SetText(L.sencounterWipes)
	self.line[0].kill:SetText(L.sencounterKills)
	self.line[0].firstBlood:SetText(L.sencounterFirstBlood)
	self.line[0].longest:SetText(L.EncounterAllTime)
	self.line[0].fastest:SetText(L.sencounterKillTime)
	
	do
		local wipeBK = CreateFrame("Frame",nil,self.borderList)
		wipeBK:SetAllPoints(self.line[0].wipeBK)
		wipeBK:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterFirstKillTooltip)
		end)
		wipeBK:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local pulls = CreateFrame("Frame",nil,self.borderList)
		pulls:SetAllPoints(self.line[0].wipe)
		pulls:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterPullsTooltip)
		end)
		pulls:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local longest = CreateFrame("Frame",nil,self.borderList)
		longest:SetAllPoints(self.line[0].longest)
		longest:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterAllTimeTooltip)
		end)
		longest:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local fastest = CreateFrame("Frame",nil,self.borderList)
		fastest:SetAllPoints(self.line[0].fastest)
		fastest:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterFastKillTooltip)
		end)
		fastest:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)		
	end

	self.bigImage = self:CreateTexture(nil, "ARTWORK")
	self.bigImage:SetSize(100,100)
	self.bigImage:SetPoint("BOTTOM",self,"TOP",0,-25)
	
	self.FBframe = ELib:Popup():Size(150,97)
	
	self.FBframe.txtR = {}
	self.FBframe.txtL = {}
	for i=1,5 do
		self.FBframe.txtL[i] = ELib:Text(self.FBframe,"nam1",11):Size(100,14):Point(10,-6-14*i):Color()
		self.FBframe.txtR[i] = ELib:Text(self.FBframe,"123",11):Size(40,14):Point("TOPRIGHT",-10,-6-14*i):Color()
	end	
	
	self.PullsFrame = ELib:Popup():Size(330,247)
	
	self.PullsFrame.txtL = {}
	for i=1,16 do
		self.PullsFrame.txtL[i] = ELib:Text(self.PullsFrame,"",11):Size(305,14):Point(5,-6-14*i):Color()
	end	
	
	self.PullsFrame.ScrollBar = ELib:ScrollBar(self.PullsFrame):Size(16,224):Point("TOPRIGHT",-3,-20):Range(1,1):OnChange(function(self,event)
		event = event - event%1
		module.options.PullsFrame:SetBoss(event)
		self:UpdateButtons()
	end)
	
	function self.PullsFrame:SetBoss(scrollVal)
		local data = module.options.PullsFrame.data
		if data and #data > 0 then
			local j = 0
			for i=(scrollVal or 1),#data do
				j = j + 1
				if j <= 16 then
					module.options.PullsFrame.txtL[j]:SetText((IsShiftKeyDown() and i..". " or "")..date("%d.%m.%Y %H:%M:%S",data[i].t)..(data[i].d > 0 and " ["..date("%M:%S",data[i].d).."]" or "")..(data[i].k and " (kill) " or "")..((data[i].s > 0 and module.db.diffPos[module.db.dropDownNow or 0] ~= 16) and " GS:"..data[i].s or "")..(data[i].i > 0 and " ilvl:"..data[i].i or ""))
				else
					break
				end
			end
			for i=(j+1),16 do
				module.options.PullsFrame.txtL[i]:SetText("")
			end
			if not scrollVal then
				module.options.PullsFrame.ScrollBar:SetMinMaxValues(1,max(#data-15,1))
			end
			
			module.options.PullsFrame.title:SetText(module.options.PullsFrame.boss)
			module.options.PullsFrame:Show()
			module.options.PullsFrame.ScrollBar:UpdateButtons()
			module.options.FBframe:Hide()
		end		
	end
	
	self.PullsFrame:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
	
	self.PullsFrame.graphs = ELib:Button(self.PullsFrame,L.BossWatcherTabGraphics):Size(150,20):Point("BOTTOMLEFT",3,-22):OnClick(function()
		if not self.graphsFrame.data then
			print('Error: No Graph data')
			return
		end
		local data = {[1]={}}
		local v_data = {}
		for i=1,#self.graphsFrame.data do
			local line = self.graphsFrame.data[i]
			local t = line.d
			if t > 30 then
				local size = #data[1] + 1
				data[1][size] = {size,t,format("#%d <%s>",i,date("%d.%m.%Y %H:%M:%S",line.t)),format("%s%d:%02d",line.k and "|cff00ff00" or "",t/60,t%60)}
				if line.k then
					v_data[#v_data + 1] = size
				end
			end
		end
		if #data[1] > 0 then
			local prev = data[1][ #data[1] ]
			data[1][#data[1] + 1] = {
				prev[1] + 1,
				prev[2],			
			}
		end
		self.graphsFrame.graph.data = data
		self.graphsFrame.graph.vertical_data = v_data
		self.graphsFrame.graph:Reload()
		
		self.graphsFrame:ShowClick("TOPRIGHT")
		
		self.PullsFrame:Hide()
	end)
	
	self.graphsFrame = ELib:Popup(L.BossWatcherTabGraphics):Size(600,400)
	self.graphsFrame.graph = ExRT.lib.CreateGraph(self.graphsFrame,565,375,"TOPLEFT",30,-20,true)
	self.graphsFrame.graph:SetScript("OnLeave",function ()	GameTooltip_Hide() end)
	self.graphsFrame.graph.AddedOordLines = 1
	self.graphsFrame.graph.IsYIsTime = true
	
	self.onlyThisChar = ELib:Check(self,L.sencounterOnlyThisChar):Point(15,-30):OnClick(function(self,event) 
		module.db.chachedDB = nil
		if self:GetChecked() then
			module.db.onlyMy = true
		else
			module.db.onlyMy = nil
		end
		module.options.ScrollBar:SetValue(1)
		module.options.dropDown:SetValue(module.db.dropDownNow)
	end)	
	
	local prevScroll = nil
	self.ScrollBar = ELib:ScrollBar(self.borderList):Size(16,self.borderList:GetHeight()-27+18):Point("TOPRIGHT",-4,-22):Range(1,1):OnChange(function(self,event)
		event = ExRT.F.Round(event)
		if prevScroll == event then
			return
		end
		prevScroll = event
		module.db.scrollPos = event
		module.options.dropDown:SetValue(module.db.dropDownNow)
		self:UpdateButtons()
	end)
	self.ScrollBar:SetScript("OnShow",function() 
		module.options.dropDown:SetValue(module.db.dropDownNow)
		module.options.ScrollBar:UpdateButtons() 
	end)
	
	self.clearButton = ELib:Button(self,L.MarksClear):Size(100,20):Point(340,-30):Tooltip(L.EncounterClear):OnClick(function() 
		StaticPopupDialogs["EXRT_ENCOUNTER_CLEAR"] = {
			text = L.EncounterClearPopUp,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				table.wipe(VMRT.Encounter.list)
				table.wipe(VMRT.Encounter.names)
				module.db.chachedDB = nil
				if module.options.ScrollBar:GetValue() == 1 then
					local func = module.options.ScrollBar.slider:GetScript("OnValueChanged")
					func(module.options.ScrollBar.slider,1)
				else
					module.options.ScrollBar:SetValue(1)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_ENCOUNTER_CLEAR")
	end) 
	
	self.exportButton = ELib:Button(self,L.Export):Size(100,20):Point("RIGHT",self.clearButton,"LEFT",-5,0):OnClick(function() 
		local allData = {}
		for _,encounterData in pairs(module.db.chachedDB) do
			if encounterData.pullTable then
				for i=1,#encounterData.pullTable do
					local pull = encounterData.pullTable[i]
					
					local resultString = date("%d.%m.%Y %H:%M:%S",pull.t).."\t"..encounterData.name.."\t"..(pull.d > 0 and date("%M:%S",pull.d) or "").."\t"..(pull.k and "Kill" or "").."\t"..(pull.fb or "")
					
					allData[#allData + 1] = {
						t = pull.t,
						s = resultString,
					}
				end
			end
		end
		sort(allData,function(a,b) return a.t<b.t end)
		local text = ""
		for i=1,#allData do
			text = text .. allData[i].s .. "\n"
		end
		ExRT.F:Export(text)
	end)

	self.dropDown:SetValue(#module.db.diffPos)
	
	self:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
end

local function DiffInArray(diff)
	for i=1,#module.db.diffPos do
		if module.db.diffPos[i] == diff then
			return true
		end
	end
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.Encounter = VMRT.Encounter or {}
	VMRT.Encounter.list = VMRT.Encounter.list or {}
	VMRT.Encounter.names = VMRT.Encounter.names or {}
	
	if VMRT.Addon.Version < 2022 then
		local newTable = {}
		local newTableNames = {}
		for encID,encData in pairs(VMRT.Encounter.list) do
			local encHex = ExRT.F.tohex(encID,3)
			for diffID,diffData in pairs(encData) do
				if tonumber(diffID) then
					local diffHex = ExRT.F.tohex(diffID - 1)
					for _,pullData in pairs(diffData) do
						local pull = pullData.pull
						local long = "000"
						local kill = "0"
						local gs = format("%02d",pullData.gs or 0)
						if pullData.wipe then
							long = ExRT.F.tohex(pullData.wipe - pull,3)
						end
						if pullData.kill then
							long = ExRT.F.tohex(pullData.kill - pull,3)
							kill = "1"
						end
						local name = pullData.player or 0
						newTable[name] = newTable[name] or {}
						table.insert(newTable[name],encHex..diffHex..format("%010d",pull)..long..kill..gs..(pullData.fb or ""))
					end
				end
			end
			newTableNames[tonumber(encHex,16)] = encData.name or "Unknown"
		end
		VMRT.Encounter.list = newTable
		VMRT.Encounter.names = newTableNames
	end
	
	module.db.playerName = UnitName("player") or 0
	VMRT.Encounter.list[module.db.playerName] = VMRT.Encounter.list[module.db.playerName] or {}
	
	module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END','BOSS_KILL')
end

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	if difficultyID == 17 or difficultyID == 151 then	--LFR fix
		difficultyID = 7
	end
	if not DiffInArray(difficultyID) or module.db.afterCombatFix then
		return
	end
	if not VMRT.Encounter.list[module.db.playerName] then
		VMRT.Encounter.list[module.db.playerName] = {}
	end
	module.db.isEncounter = encounterID
	module.db.diff = difficultyID
	module.db.pullTime = time()
	module.db.nowInTable = #VMRT.Encounter.list[module.db.playerName] + 1
	
	VMRT.Encounter.list[module.db.playerName][module.db.nowInTable] = 
		"^".. encounterID .. "^" .. difficultyID .. "^" .. module.db.pullTime .. "^0^0^" .. (groupSize or 0) .. "^" .. format("%.2f",ExRT.F.RaidItemLevel and ExRT.F:RaidItemLevel() or 0) .. "^"
	
	VMRT.Encounter.names[encounterID] = encounterName
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	
	module.db.chachedDB = nil
end

do
	local function ScheduledAfterCombatFix()
		module.db.afterCombatFix = nil
	end
	function module.main:ENCOUNTER_END(encounterID,_,_,_,success,isBossKillEvent)
		if not module.db.isEncounter then
			return
		end
		if encounterID == module.db.isEncounter then
			local currTime = time()
			if isBossKillEvent then
				currTime = currTime - 3
			end
			local pullTime = currTime - module.db.pullTime
			
			local _,encounterID,difficultyID,pull,_,_,groupSize,raidIlvl,fb = strsplit("^", VMRT.Encounter.list[module.db.playerName][module.db.nowInTable])
			
			VMRT.Encounter.list[module.db.playerName][module.db.nowInTable] = 
				"^".. encounterID .. "^" .. difficultyID .. "^" .. pull .. "^".. pullTime .."^"..(success == 1 and "1" or "0").."^" .. groupSize .. "^" .. raidIlvl .. "^".. fb			
		end
		module.db.isEncounter = nil
		module.db.diff = nil
		module.db.nowInTable = nil
		module.db.afterCombatFix = true
		ExRT.F.ScheduleTimer(ScheduledAfterCombatFix, 5)
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
	function module.main:BOSS_KILL(encounterID)		--08.03.2016: ENCOUNTER_END not fired in 5ppl, but boss_kill only for kills
		if select(2,GetInstanceInfo()) == 'raid' then	--Not needed in raids
			return
		end
		ExRT.F.Timer(module.main.ENCOUNTER_END, 3, module.main, encounterID, 0, 0, 0, 1, true)
	end
end

function module.main.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,_,_,_,_,destGUID,destName,destFlags)
	if event == "UNIT_DIED" and bit_band(destFlags, 1024) > 0 and destName then
		VMRT.Encounter.list[module.db.playerName][module.db.nowInTable] = VMRT.Encounter.list[module.db.playerName][module.db.nowInTable] .. destName
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
end