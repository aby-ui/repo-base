local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("RaidGroups",ExRT.L.RaidGroups)
local ELib,L = ExRT.lib,ExRT.L

local VExRT = nil

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT

	VExRT.RaidGroups = VExRT.RaidGroups or {}
	VExRT.RaidGroups.profiles = VExRT.RaidGroups.profiles or {}
end

function module.options:Load()
	self:CreateTilte()

	local function EditOnDragStart(self)
		if self:IsMovable() then
			self:StartMoving()
		end	  
	end
	local function EditOnDragStop(self)
		self:StopMovingOrSizing()

		for i=1,#module.options.edits do
			local edit2 = module.options.edits[i]
			if edit2:IsMouseOver() and edit2 ~= self then
				local textSelf = self:GetText()
				local textMO = edit2:GetText()
				self:SetText(textMO)
				edit2:SetText(textSelf)
				self:SetCursorPosition(1)
				edit2:SetCursorPosition(1)
				break
			end
		end

		self:NewPoint("TOPLEFT",module.options,10+((self.index-1) % 10 < 5 and 0 or 165),-40-((self.index-1) % 5)*22-floor((self.index-1)/10)*132) 

		self:ClearFocus() 
	end
	local function EditOnDragStopNotInList(self)
		self:StopMovingOrSizing()

		for i=1,#module.options.edits do
			local edit2 = module.options.edits[i]
			if edit2:IsMouseOver() and edit2 ~= self then
				local textSelf = self.preName or self:GetText()
				edit2:SetText(textSelf)
				edit2:SetCursorPosition(1)
				break
			end
		end

		self:NewPoint("TOPLEFT",module.options,355,-40-(self.index-1)*14) 

		self:ClearFocus() 

		module.options:UpdateNotInList()
	end
	local function EditOnChange(self,isUser)
		local name = self:GetText()
		if name and UnitName(name) then
			local r,g,b = ExRT.F.classColorNum(select(2,UnitClass(name)))
			self:SetTextColor(r,g,b,1)
			self:ColorBorder()
		elseif self.preclass then
			local r,g,b = ExRT.F.classColorNum(self.preclass)
			self:SetTextColor(r,g,b,1)
			self:ColorBorder()
		else
			self:SetTextColor(.7,.7,.7,1)
			if name and #name > 0 then
				self:ColorBorder(0.5,0.25,0.3,1)
			else
				self:ColorBorder()
			end
		end
		if isUser then
			module.options:UpdateNotInList()
		end
	end

	function self:UpdateTextColors()
		for i=1,40 do
			EditOnChange(self.edits[i],false)
		end
	end

	self.edits = {}
	for i=1,40 do
		local edit = ELib:Edit(self):Size(150,18)
		self.edits[i] = edit

		edit:SetText(i)
		edit.index = i

		edit:Point("TOPLEFT",10+((i-1) % 10 < 5 and 0 or 165),-40-((i-1) % 5)*22-floor((i-1)/10)*132):OnChange(EditOnChange)

		edit:SetMovable(true)
		edit:RegisterForDrag("LeftButton")
		edit:SetScript("OnDragStart", EditOnDragStart)
		edit:SetScript("OnDragStop", EditOnDragStop)
	end
	for i=1,4 do
		for j=1,2 do
			ELib:Text(self,GROUP.." "..((i-1)*2+j)):Point("TOPLEFT",10+(j == 1 and 0 or 165)+3,-40-(i-1)*132+14):Color():Shadow()
		end
	end

	ELib:Text(self,L.RaidGroupsTextMovable,8):Point("TOPLEFT",12,-547):Color():Shadow()

	self.scrollNotInList = ELib:ScrollBar(self):Point("TOPLEFT",478,-40):Size(12,558):SetMinMaxValues(0,1):SetValue(0):SetObey(true):OnChange(function()
		self:UpdateNotInList()
	end)

	self.edits_notinlist = {}
	function self:UpdateNotInList()
		local inList,notInList = {},{}
		local scrollShow
		for i=1,40 do 
			local name = module.options.edits[i]:GetText()
			if name then
				inList[name] = true
			end
		end
		if self.isGuild then
			local myLvl = UnitLevel("player")
			local guildList = {}
			for i=1, GetNumGuildMembers() do
				local name, _, rankIndex, level, _, _, _, _, _, _, class = GetGuildRosterInfo(i)
				if select(2,strsplit("-",name)) == ExRT.SDB.realmKey then
					name = strsplit("-",name)
				end
				if not inList[name] and (level or 0) >= myLvl then
					guildList[#guildList+1] = {name,class,rankIndex,"|cffbbbbbb["..rankIndex.."]|r "..name}
				end
			end
			sort(guildList,function(a,b)
				if a[3] == b[3] then
					return a[1] < b[1]
				else
					return a[3] < b[3]
				end
			end)
			local start = floor(self.scrollNotInList:GetValue()+0.5)
			for i=start+1,#guildList do
				notInList[#notInList+1] = guildList[i]
			end
			if #guildList > 40 then
				scrollShow = #guildList - 40
			end
		else
			for i=1,GetNumGroupMembers() do
				local name = GetRaidRosterInfo(i)
				if not inList[name] then
					notInList[#notInList+1] = name
				end
			end
		end
		if scrollShow then
			self.scrollNotInList:SetMinMaxValues(0,scrollShow)
		end
		self.scrollNotInList:SetShown(scrollShow and true or false)

		for i=1,min(#notInList,40) do
			local edit = self.edits_notinlist[i]
			if not edit then
				edit = ELib:Edit(self):Size(120,12)
				self.edits_notinlist[i] = edit
		
				edit.index = i
				edit:Point("TOPLEFT",355,-40-(i-1)*14):OnChange(EditOnChange)

				edit:SetFont(edit:GetFont(),10)
				edit:SetEnabled(false)
		
				edit:SetMovable(true)
				edit:RegisterForDrag("LeftButton")
				edit:SetScript("OnDragStart", EditOnDragStart)
				edit:SetScript("OnDragStop", EditOnDragStopNotInList)

			end
			if type(notInList[i]) == "table" then
				edit:SetText(notInList[i][4])
				edit.preclass = notInList[i][2]
				edit.preName = notInList[i][1]
			else
				edit:SetText(notInList[i])
				edit.preclass = nil
				edit.preName = nil
			end
			edit:SetCursorPosition(1)
			edit:Show()
		end
		for i=#notInList+1,#self.edits_notinlist do 
			self.edits_notinlist[i]:Hide()
		end
	end

	self.chk_raid = ELib:Radio(self,RAID,true):Point("TOPLEFT",355,-20):OnClick(function(self)
		module.options.isGuild = false
		self:SetChecked(true)
		module.options.chk_guild:SetChecked(false)
		module.options:UpdateNotInList()
	end)
	self.chk_guild = ELib:Radio(self,GUILD):Point("BOTTOM",self.chk_raid,"TOP",0,-2):OnClick(function(self)
		module.options.isGuild = true
		self:SetChecked(true)
		module.options.chk_raid:SetChecked(false)
		C_GuildInfo.GuildRoster()
		module.options:UpdateNotInList()
		C_Timer.After(1,function()
			module.options:UpdateNotInList()
		end)
	end)

	self.updateRoster = ELib:Button(self,L.RaidGroupsCurrentRoster):Size(315,20):Point("TOPLEFT",10,-565):OnClick(function() 
		local roster = {}
		for i=1,8 do roster[i] = {} end

		for i=1,GetNumGroupMembers() do
			local name, rank, subgroup = GetRaidRosterInfo(i)
			tinsert(roster[subgroup],name)
		end

		for i=1,8 do 
			for j=1,5 do
				local edit = module.options.edits[(i-1)*5+j]
				edit:SetText(roster[i][j] or "")
				edit:SetCursorPosition(1)
			end
		end

		module.options:UpdateNotInList()
	end) 

	self.processRoster = ELib:Button(self,L.RaidGroupsSetGroups):Size(315,30):Point("TOP",self.updateRoster,"BOTTOM",0,-5):OnClick(function(self) 
		if not IsInRaid() then
			return
		end
		local UnitsInCombat
		for i=1,40 do
			local unit = "raid"..i
			if UnitAffectingCombat(unit) then
				UnitsInCombat = (UnitsInCombat or "") .. (UnitsInCombat and "," or "") .. UnitName(unit)
			end
		end
		if UnitsInCombat then
			print("|cffff0000"..ERROR_CAPS..".|r "..L.RaidGroupsPlayersInCombat..": "..UnitsInCombat)
			return
		end

		local needGroup = {}
		local needPosInGroup = {}
		local lockedUnit = {}

		local RLName,_,RLGroup = GetRaidRosterInfo(1)
		local isRLfound = false
		for i=1,8 do 
			local pos = 1
			for j=1,5 do
				local name = module.options.edits[(i-1)*5+j]:GetText()
				if name == RLName then
					needGroup[name] = i
					needPosInGroup[name] = pos
					pos = pos + 1
					isRLfound = true
					break
				end
			end
			for j=1,5 do
				local name = module.options.edits[(i-1)*5+j]:GetText()
				if name and name ~= RLName and UnitName(name) then
					needGroup[name] = i
					needPosInGroup[name] = pos
					pos = pos + 1
				end
			end
		end

		module.db.needGroup = needGroup
		module.db.needPosInGroup = needPosInGroup
		module.db.lockedUnit = lockedUnit
		module.db.groupsReady = false
		module.db.groupWithRL = isRLfound and 0 or RLGroup

		self:Disable()

		module:ProcessRoster()
	end) 

	self.presetList = ELib:ScrollList(self):Size(190,554):Point("TOPRIGHT",-10,-40):AddDrag()
	ELib:Text(self,L.RaidGroupsQuickLoad..":"):Point("BOTTOMLEFT",self.presetList,"TOPLEFT",5,3):Color():Shadow()

	self.presetList.ButtonRemove = CreateFrame("Button",nil,self.presetList)
	self.presetList.ButtonRemove:Hide()
	self.presetList.ButtonRemove:SetSize(8,8)
	self.presetList.ButtonRemove:SetScript("OnClick",function(self)
		for i=#VExRT.RaidGroups.profiles,1,-1 do
			local entry = VExRT.RaidGroups.profiles[i]
			if entry == self.data then
				tremove(VExRT.RaidGroups.profiles,i)
				break
			end
		end
		module.options:UpdateList()
	end)
	self.presetList.ButtonRemove:SetScript("OnEnter",function(self)
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
		GameTooltip:AddLine(DELETE)
		GameTooltip:Show()
	end)
	self.presetList.ButtonRemove:SetScript("OnLeave",function(self)
		GameTooltip_Hide()
	end)
	self.presetList.ButtonRemove.i = self.presetList.ButtonRemove:CreateTexture()
	self.presetList.ButtonRemove.i:SetPoint("CENTER")
	self.presetList.ButtonRemove.i:SetSize(16,16)	
	self.presetList.ButtonRemove.i:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	self.presetList.ButtonRemove.i:SetTexCoord(0.5,0.5625,0.5,0.625)
	self.presetList.ButtonRemove.i:SetVertexColor(.8,0,0,1)

	function self.presetList:SetListValue(index)
		local data = self.L[index][2]
		for i=1,40 do 
			local edit = module.options.edits[i]
			if data[i] then
				edit:SetText(data[i])
				edit:SetCursorPosition(1)
			else
				edit:SetText("")
			end
		end
		module.options:UpdateNotInList()

		module.options.presetList.selected = nil
		module.options.presetList:Update()	
	end
	function self.presetList:HoverListValue(isEnter,index,obj)
		if not isEnter then
			GameTooltip_Hide()

			if not self.ButtonRemove:IsMouseOver() then
				self.ButtonRemove:Hide()
			end
		else
			local data = obj.table[2]

			GameTooltip:SetOwner(obj,"ANCHOR_CURSOR")
			GameTooltip:AddLine(data.name)
			GameTooltip:AddLine(date("%x %X",data.time))
			GameTooltip:Show()

			self.ButtonRemove.data = data
			self.ButtonRemove:SetPoint("RIGHT",obj,"RIGHT",-5,0)
			self.ButtonRemove:SetParent(obj)
			self.ButtonRemove:Show()
		end
	end
	function self.presetList:OnDragFunction(obj1,obj2)
		local data1,data2 = obj1.table[2],obj2.table[2]

		local tmp
		if obj1.index < obj2.index then
			for i=#VExRT.RaidGroups.profiles,1,-1 do
				if VExRT.RaidGroups.profiles[i] == data1 then
					tmp = VExRT.RaidGroups.profiles[i]
					VExRT.RaidGroups.profiles[i] = VExRT.RaidGroups.profiles[i-1]
				elseif VExRT.RaidGroups.profiles[i] == data2 then
					VExRT.RaidGroups.profiles[i] = tmp
					break
				elseif tmp then
					VExRT.RaidGroups.profiles[i] = VExRT.RaidGroups.profiles[i-1]
				end
			end
		else
			for i=1,#VExRT.RaidGroups.profiles do
				if VExRT.RaidGroups.profiles[i] == data1 then
					tmp = VExRT.RaidGroups.profiles[i]
					VExRT.RaidGroups.profiles[i] = VExRT.RaidGroups.profiles[i+1]
				elseif VExRT.RaidGroups.profiles[i] == data2 then
					VExRT.RaidGroups.profiles[i] = tmp
					break
				elseif tmp then
					VExRT.RaidGroups.profiles[i] = VExRT.RaidGroups.profiles[i+1]
				end
			end
		end

		module.options:UpdateList()
	end	

	function self:UpdateList()
		local list = {}

		for i=#VExRT.RaidGroups.profiles,1,-1 do
			local entry = VExRT.RaidGroups.profiles[i]
			list[#list+1] = {entry.name,entry}
		end

		module.options.presetList.L = list
		module.options.presetList:Update()
	end

	local function SaveData(_,name)
		if not name or string.trim(name) == "" then
			return
		end
		local new = {
			name = name,
			time = time(),
		}
		for i=1,40 do 
			local text = module.options.edits[i]:GetText()
			if text and string.trim(text) ~= "" then
				new[i] = text
			end
		end
		VExRT.RaidGroups.profiles[#VExRT.RaidGroups.profiles+1] = new

		module.options:UpdateList()
	end

	local function SaveInputOnEdit(self)
		local text = self:GetText()
		if text and string.trim(text) ~= "" then
			self:GetParent().OK:Enable()
		else
			self:GetParent().OK:Disable()
		end	
	end

	self.presetListSave = ELib:Button(self,L.RaidGroupsSave):Size(192,20):Point("TOP",self.presetList,"BOTTOM",0,-5):OnClick(function(self) 
		ExRT.F.ShowInput(L.RaidGroupsEnterName,SaveData,nil,nil,nil,SaveInputOnEdit)		
	end)

	self:UpdateList()
	self.updateRoster:Click()

	function self:OnShow()
		module.options:UpdateTextColors()
		module.options:UpdateNotInList()
	end
	local GRU = CreateFrame("Frame",nil,self)
	GRU:SetPoint("TOPLEFT")
	GRU:SetSize(1,1)
	GRU:RegisterEvent("GROUP_ROSTER_UPDATE")
	GRU:SetScript("OnEvent",function()
		if not self:IsVisible() then
			return
		end
		module.options:UpdateTextColors()
		module.options:UpdateNotInList()
	end)
end

local function Debug(currentGroup,currentPos,needGroup,needPosInGroup)
	local s = ""
	for k,v in pairs(currentGroup) do
		s = s..k.."["..v..":"..currentPos[k]..","..(needGroup[k] or "")..":"..(needPosInGroup[k] or "").."]"
	end
	print(s)
end

function module:ProcessRoster()
	local UnitsInCombat
	for i=1,40 do
		local unit = "raid"..i
		if UnitAffectingCombat(unit) then
			UnitsInCombat = (UnitsInCombat or "") .. (UnitsInCombat and "," or "") .. UnitName(unit)
		end
	end
	if UnitsInCombat then
		print("|cffff0000"..ERROR_CAPS..".|r "..L.RaidGroupsCombatStarted..": "..UnitsInCombat)

		module.db.needGroup = nil
	
		module.options.processRoster:Enable()
		module:UnregisterEvents('GROUP_ROSTER_UPDATE')
		return
	end

	local needGroup = module.db.needGroup
	local needPosInGroup = module.db.needPosInGroup
	local lockedUnit = module.db.lockedUnit
	if not needGroup then
		return
	end
	module:RegisterEvents('GROUP_ROSTER_UPDATE')

	local currentGroup = {}
	local currentPos = {}
	local nameToID = {}
	local groupSize = {}

	wipe(currentGroup)
	for i=1,8 do groupSize[i] = 0 end
	for i=1,GetNumGroupMembers() do
		local name, rank, subgroup = GetRaidRosterInfo(i)
		currentGroup[name] = subgroup
		nameToID[name] = i
		groupSize[subgroup] = groupSize[subgroup] + 1
		currentPos[name] = groupSize[subgroup]
	end

	--Debug(currentGroup,currentPos,needGroup,needPosInGroup)

	if not module.db.groupsReady then
		local WaitForGroup = false
		for unit,group in pairs(needGroup) do
			if currentGroup[unit] and currentGroup[unit] ~= needGroup[unit] then
				local currGroupUnit = currentGroup[unit]
				local needGroupUnit = needGroup[unit]
				if groupSize[ needGroupUnit ] < 5 then
					SetRaidSubgroup(nameToID[unit],needGroupUnit)
	
					groupSize[ currGroupUnit ] = groupSize[ currGroupUnit ] - 1
					groupSize[ needGroupUnit ] = groupSize[ needGroupUnit ] + 1
	
					WaitForGroup = true
				end
			end
		end
		if WaitForGroup then
			return
		end
	
		local SetToSwap = {}
		local WaitForSwap = false
		for unit,group in pairs(needGroup) do
			if not SetToSwap[unit] and currentGroup[unit] and currentGroup[unit] ~= group then
				local currGroupUnit = currentGroup[unit]
	
				local unitToSwap
				for unit2,group2 in pairs(currentGroup) do
					if not SetToSwap[unit2] and group2 == group and needGroup[unit2] ~= group2 then
						unitToSwap = unit2
						break
					end
				end
	
				if unitToSwap then
					SwapRaidSubgroup(nameToID[unit], nameToID[unitToSwap])
					
					WaitForSwap = true
					SetToSwap[unit] = true
					SetToSwap[unitToSwap] = true
				end
			end
		end
		if WaitForSwap then
			return
		end

		module.db.groupsReady = true
	end

	do
		local SetToSwap = {}
		local WaitForSwap = false
		for unit,pos in pairs(needPosInGroup) do
			if currentGroup[unit] == module.db.groupWithRL then
				pos = pos + 1
			end
			if not lockedUnit[unit] and currentPos[unit] and currentPos[unit] ~= pos and nameToID[unit] ~= 1 and not SetToSwap[unit] then
				local currGroupUnit = currentGroup[unit]
	
				local unitToSwapBridge
				for unit2,group2 in pairs(currentGroup) do
					if group2 ~= currentGroup[unit] and nameToID[unit2] ~= 1 and not SetToSwap[unit2] then
						unitToSwapBridge = unit2
						break
					end
				end
	
				local unitToSwap
				for unit2,pos2 in pairs(currentPos) do
					if currentGroup[unit2] == currentGroup[unit] and pos2 == pos and nameToID[unit2] ~= 1 and not SetToSwap[unit2] then
						unitToSwap = unit2
						break
					end
				end
	
				if unitToSwap and unitToSwapBridge then
					lockedUnit[unit] = true
					SwapRaidSubgroup(nameToID[unit], nameToID[unitToSwapBridge])
					SwapRaidSubgroup(nameToID[unitToSwapBridge], nameToID[unitToSwap])
					SwapRaidSubgroup(nameToID[unit], nameToID[unitToSwapBridge])
					
					WaitForSwap = true
					SetToSwap[unit] = true
					SetToSwap[unitToSwap] = true
					SetToSwap[unitToSwapBridge] = true
				end
			end
		end
		if WaitForSwap then
			return
		end
	end

	module.db.needGroup = nil

	module.options.processRoster:Enable()
	module:UnregisterEvents('GROUP_ROSTER_UPDATE')
end

function module.main:GROUP_ROSTER_UPDATE()
	if self.timer then
		self.timer:Cancel()
	end
	self.timer = C_Timer.NewTimer(0.5,function()
		self.timer = nil
		module:ProcessRoster()
	end)
end
