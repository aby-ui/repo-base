local GlobalAddonName, ExRT = ...

local module = ExRT:New("RaidGroups",ExRT.L.RaidGroups)
local ELib,L = ExRT.lib,ExRT.L

local LibDeflate = LibStub:GetLibrary("LibDeflate")

local VMRT = nil

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT

	VMRT.RaidGroups = VMRT.RaidGroups or {}
	VMRT.RaidGroups.profiles = VMRT.RaidGroups.profiles or {}

	if not VMRT.RaidGroups.upd4550 then
		VMRT.RaidGroups.KeepPosInGroup = true
		VMRT.RaidGroups.upd4550 = true
	end

	module:RegisterSlash()
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
		local list = {}
		for i=1,40 do
			list[i] = module.options.edits[i]:GetText()
		end
		module:ApplyGroups(list)
	end) 

	self.keepPosCheck = ELib:Check(self,L.RaidGroupsKeepPosInGroup,VMRT.RaidGroups.KeepPosInGroup):Point("BOTTOMLEFT",self.processRoster,"BOTTOMRIGHT",5,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidGroups.KeepPosInGroup = true
		else
			VMRT.RaidGroups.KeepPosInGroup = nil
		end
	end):Shown(ExRT.isClassic)

	self.presetList = ELib:ScrollList(self):Size(190,505):Point("TOPRIGHT",-10,-40):AddDrag()
	ELib:Text(self,L.RaidGroupsQuickLoad..":"):Point("BOTTOMLEFT",self.presetList,"TOPLEFT",5,3):Color():Shadow()

	self.presetList.ButtonRemove = CreateFrame("Button",nil,self.presetList)
	self.presetList.ButtonRemove:Hide()
	self.presetList.ButtonRemove:SetSize(8,8)
	self.presetList.ButtonRemove:SetScript("OnClick",function(self)
		for i=#VMRT.RaidGroups.profiles,1,-1 do
			local entry = VMRT.RaidGroups.profiles[i]
			if entry == self.data then
				tremove(VMRT.RaidGroups.profiles,i)
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
	self.presetList.ButtonRemove.i:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
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
			for i=#VMRT.RaidGroups.profiles,1,-1 do
				if VMRT.RaidGroups.profiles[i] == data1 then
					tmp = VMRT.RaidGroups.profiles[i]
					VMRT.RaidGroups.profiles[i] = VMRT.RaidGroups.profiles[i-1]
				elseif VMRT.RaidGroups.profiles[i] == data2 then
					VMRT.RaidGroups.profiles[i] = tmp
					break
				elseif tmp then
					VMRT.RaidGroups.profiles[i] = VMRT.RaidGroups.profiles[i-1]
				end
			end
		else
			for i=1,#VMRT.RaidGroups.profiles do
				if VMRT.RaidGroups.profiles[i] == data1 then
					tmp = VMRT.RaidGroups.profiles[i]
					VMRT.RaidGroups.profiles[i] = VMRT.RaidGroups.profiles[i+1]
				elseif VMRT.RaidGroups.profiles[i] == data2 then
					VMRT.RaidGroups.profiles[i] = tmp
					break
				elseif tmp then
					VMRT.RaidGroups.profiles[i] = VMRT.RaidGroups.profiles[i+1]
				end
			end
		end

		module.options:UpdateList()
	end	

	function self:UpdateList()
		local list = {}

		for i=#VMRT.RaidGroups.profiles,1,-1 do
			local entry = VMRT.RaidGroups.profiles[i]
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
		VMRT.RaidGroups.profiles[#VMRT.RaidGroups.profiles+1] = new

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

	self.importWindow, self.exportWindow = ExRT.F.CreateImportExportWindows()

	do
		self.importWindow:SetHeight(180)
		self.importWindow.Edit:Point("TOP",0,-100)

		ELib:DecorationLine(self.importWindow):Point("TOPLEFT",0,-17):Point("BOTTOMRIGHT",'x',"TOPRIGHT",0,-18)
		ELib:DecorationLine(self.importWindow):Point("TOPLEFT",0,-95):Point("BOTTOMRIGHT",'x',"TOPRIGHT",0,-96)

		local importWindow = self.importWindow
		local function ButtonOnClick(self)
			local index = 1
			local c = importWindow["c"..index]
			while c do
				c:Enable()
				if self == c then
					importWindow.importType = index
					VMRT.RaidGroups.importType = index
				end
				index = index + 1
				c = importWindow["c"..index]
			end

			self:Disable()
		end

		local function CreateButton()
			local self = ELib:Template("ExRTButtonTransparentTemplate",importWindow)
			self:SetSize(importWindow:GetWidth()/4,77)

			self.DisabledTexture = self:CreateTexture()
			self.DisabledTexture:SetColorTexture(0.20,0.21,0.25,0.5)
			self.DisabledTexture:SetPoint("TOPLEFT")
			self.DisabledTexture:SetPoint("BOTTOMRIGHT")
			self:SetDisabledTexture(self.DisabledTexture)

			self:SetScript("OnClick",ButtonOnClick)
		  
			return self
		end

		importWindow.c1 = CreateButton()
		importWindow.c1:SetPoint("TOPLEFT",0,-18)
		importWindow.c1:SetText("G1    G2\nG3    G4\nG5    G6\nG7    G8")

		importWindow.c2 = CreateButton()
		importWindow.c2:SetPoint("LEFT",importWindow.c1,"RIGHT",0,0)
		importWindow.c2:SetText("G1   G2   G3   G4   G5")

		importWindow.c3 = CreateButton()
		importWindow.c3:SetPoint("LEFT",importWindow.c2,"RIGHT",0,0)
		importWindow.c3:SetText("G1\nG2\nG3\nG4\nG5")

		importWindow.c4 = CreateButton()
		importWindow.c4:SetPoint("LEFT",importWindow.c3,"RIGHT",0,0)
		importWindow.c4:SetText("From ExRT export string")

		local importType = VMRT.RaidGroups.importType or 4
		local c = importWindow["c"..importType]
		if c then
			c:Click()
		end
	end

	do
		self.exportWindow:SetHeight(130)
		self.exportWindow.Edit:Point("TOP",0,-100)

		ELib:DecorationLine(self.exportWindow):Point("TOPLEFT",0,-17):Point("BOTTOMRIGHT",'x',"TOPRIGHT",0,-18)
		ELib:DecorationLine(self.exportWindow):Point("TOPLEFT",0,-95):Point("BOTTOMRIGHT",'x',"TOPRIGHT",0,-96)

		local exportWindow = self.exportWindow
		local function ButtonOnClick(self)
			local index = 1
			local c = exportWindow["c"..index]
			while c do
				c:Enable()
				if self == c then
					exportWindow.exportType = index
					VMRT.RaidGroups.exportType = index
				end
				index = index + 1
				c = exportWindow["c"..index]
			end

			self:Disable()

			module.options:RecordToText()
			if exportWindow:IsShown() then
				exportWindow.Edit:SetFocus()
				exportWindow.Edit:HighlightText()
			end
		end

		local function CreateButton()
			local self = ELib:Template("ExRTButtonTransparentTemplate",exportWindow)
			self:SetSize(exportWindow:GetWidth()/4,77)

			self.DisabledTexture = self:CreateTexture()
			self.DisabledTexture:SetColorTexture(0.20,0.21,0.25,0.5)
			self.DisabledTexture:SetPoint("TOPLEFT")
			self.DisabledTexture:SetPoint("BOTTOMRIGHT")
			self:SetDisabledTexture(self.DisabledTexture)

			self:SetScript("OnClick",ButtonOnClick)
		  
			return self
		end

		exportWindow.c1 = CreateButton()
		exportWindow.c1:SetPoint("TOPLEFT",0,-18)
		exportWindow.c1:SetText("G1    G2\nG3    G4\nG5    G6\nG7    G8")

		exportWindow.c2 = CreateButton()
		exportWindow.c2:SetPoint("LEFT",exportWindow.c1,"RIGHT",0,0)
		exportWindow.c2:SetText("G1   G2   G3   G4   G5")

		exportWindow.c3 = CreateButton()
		exportWindow.c3:SetPoint("LEFT",exportWindow.c2,"RIGHT",0,0)
		exportWindow.c3:SetText("G1\nG2\nG3\nG4\nG5")

		exportWindow.c4 = CreateButton()
		exportWindow.c4:SetPoint("LEFT",exportWindow.c3,"RIGHT",0,0)
		exportWindow.c4:SetText("MRT export string")

		local exportType = VMRT.RaidGroups.exportType or 4
		local c = exportWindow["c"..exportType]
		if c then
			c:Disable()
		end
		exportWindow.exportType = exportType
	end

	local function SaveDataFromTable(rec,name)
		if not name or string.trim(name) == "" then
			return
		end
		rec.name = name
		rec.time = time()

		VMRT.RaidGroups.profiles[#VMRT.RaidGroups.profiles+1] = rec

		module.options:UpdateList()
	end

	function self.importWindow:ImportFunc(str)
		if self.importType == 4 then
			local headerLen = str:sub(1,4) == "EXRT" and 8 or 7

			local header = str:sub(1,headerLen)
			if (header:sub(1,headerLen-1) ~= "EXRTRGR" and header:sub(1,headerLen-1) ~= "MRTRGR") or (header:sub(headerLen,headerLen) ~= "0" and header:sub(headerLen,headerLen) ~= "1") then
				StaticPopupDialogs["EXRT_RAIDGROUP_IMPORT"] = {
					text = "|cffff0000"..ERROR_CAPS.."|r "..L.ProfilesFail3,
					button1 = OKAY,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,
				}
				StaticPopup_Show("EXRT_RAIDGROUP_IMPORT")
				return
			end
	
			module.options:TextToRecord(str:sub(headerLen+1),header:sub(headerLen,headerLen)=="0")
		elseif self.importType == 1 then
			local res = {}

			local group = 1
			local posInGroup = 0

			local lines = {strsplit("\n",str)}
			for i=1,#lines do
				local left,right = strsplit(" ",lines[i]:gsub(" +"," "):gsub('"',''),nil)
				if left and left:trim() ~= "" then
					left = left:trim()
				else
					left = nil
				end
				if right and right:trim() ~= "" then
					right = right:trim()
				else
					right = nil
				end
				posInGroup = posInGroup + 1
				if posInGroup > 5 and (left or right) then
					posInGroup = 1
					group = group + 2
				end
				if posInGroup <= 5 and group <= 8 then
					res[(group-1)*5+posInGroup] = left
					res[(group-0)*5+posInGroup] = right
				end
			end
			ExRT.F.ShowInput(L.RaidGroupsEnterName,SaveDataFromTable,res,nil,nil,SaveInputOnEdit)
		elseif self.importType == 3 then
			local res = {}

			local group = 1
			local posInGroup = 0

			local lines = {strsplit("\n",str)}
			for i=1,#lines do
				local left = lines[i]
				if left and left:trim() ~= "" then
					left = left:trim():gsub('"','')
				else
					left = nil
				end
				posInGroup = posInGroup + 1
				if posInGroup > 5 and left then
					posInGroup = 1
					group = group + 1
				end
				if posInGroup <= 5 and group <= 8 then
					res[(group-1)*5+posInGroup] = left
				end
			end
			ExRT.F.ShowInput(L.RaidGroupsEnterName,SaveDataFromTable,res,nil,nil,SaveInputOnEdit)
		elseif self.importType == 2 then
			local res = {}

			local lines = {strsplit("\n",str)}
			for i=1,#lines do
				local group = 0

				local name,line = strsplit(" ",lines[i]:gsub(" +"," "):gsub('"',''),2)
				while name do
					group = group + 1
					if i <= 5 and group <= 8 then
						res[(group-1)*5+i] = name:trim()
					end
					if line then
						name,line = strsplit(" ",line,2)
					else
						break
					end
				end
			end
			ExRT.F.ShowInput(L.RaidGroupsEnterName,SaveDataFromTable,res,nil,nil,SaveInputOnEdit)
		end
	end


	function self:TextToRecord(str,uncompressed)
		local decoded = LibDeflate:DecodeForPrint(str)
		local decompressed
		if uncompressed then
			decompressed = decoded
		else
			decompressed = LibDeflate:DecompressDeflate(decoded)
		end
		decoded = nil

		local _,tableData = strsplit(",",decompressed,2)
		decompressed = nil
	
		local successful, res = pcall(ExRT.F.TextToTable,tableData)
		if ExRT.isDev then
			module.db.lastImportDB = res
			if module.db.exportTable and type(res)=="table" then
				module.db.diffTable = {}
				print("Compare table",ExRT.F.table_compare(res,module.db.exportTable,module.db.diffTable))
			end
		end
		if successful and res then
			ExRT.F.ShowInput(L.RaidGroupsEnterName,SaveDataFromTable,res,nil,nil,SaveInputOnEdit)
		else
			StaticPopupDialogs["EXRT_RAIDGROUP_IMPORT"] = {
				text = L.ProfilesFail1..(res and "\nError code: "..res or ""),
				button1 = OKAY,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
			StaticPopup_Show("EXRT_RAIDGROUP_IMPORT")
		end
	end

	function self:RecordToText()
		local new = {}
		for i=1,40 do 
			local text = module.options.edits[i]:GetText()
			if text and string.trim(text) ~= "" then
				new[i] = text
			end
		end
		local exportWindow = module.options.exportWindow
		if exportWindow.exportType == 1 then
			local text = ""
			for i=1,8,2 do
				for j=1,5 do
					text = text .. (new[(i-1)*5+j] or "") .. "\t" .. (new[(i-0)*5+j] or "") .. "\n"
				end
			end
			exportWindow.Edit:SetText(text)
		elseif exportWindow.exportType == 2 then
			local text = ""
			for j=1,5 do
				for i=1,8 do
					text = text .. (new[(i-1)*5+j] or "") .. "\t"
				end
				text = text .. "\n"
			end
			exportWindow.Edit:SetText(text)
		elseif exportWindow.exportType == 3 then
			local text = ""
			for i=1,8 do
				for j=1,5 do
					text = text .. (new[(i-1)*5+j] or "") .. "\n"
				end
			end
			exportWindow.Edit:SetText(text)
		else
			local strlist = ExRT.F.TableToText(new)
			strlist[1] = "0,"..strlist[1]
			local str = table.concat(strlist)
	
			local compressed
			if #str < 1000000 then
				compressed = LibDeflate:CompressDeflate(str,{level = 5})
			end
			local encoded = "MRTRGR"..(compressed and "1" or "0")..LibDeflate:EncodeForPrint(compressed or str)
		
			ExRT.F.dprint("Str len:",#str,"Encoded len:",#encoded)
		
			if ExRT.isDev then
				module.db.exportTable = new
			end
			exportWindow.Edit:SetText(encoded)
		end
		exportWindow:Show()
	end

	self.butExport = ELib:Button(self,L.RaidGroupsExport):Size(192,20):Point("TOP",self.presetListSave,"BOTTOM",0,-5):OnClick(function(self) 
		module.options:RecordToText()
	end)
	self.butImport = ELib:Button(self,L.Import):Size(192,20):Point("TOP",self.butExport,"BOTTOM",0,-5):OnClick(function(self) 
		module.options.importWindow:NewPoint("CENTER",UIParent,0,0)
		module.options.importWindow:Show()			
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

function module:ApplyGroups(list)
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
			local name = list[(i-1)*5+j]
			if name == RLName then
				needGroup[name] = i
				needPosInGroup[name] = pos
				pos = pos + 1
				isRLfound = true
				break
			end
		end
		for j=1,5 do
			local name = list[(i-1)*5+j]
			if name and name ~= RLName and UnitName(name) then
				needGroup[name] = i
				needPosInGroup[name] = pos
				pos = pos + 1
			end
		end
	end

	--reports saying that too many swap events can trigger disconnect on classic, unconfirmed cause: other addons or pure swap events
	if ExRT.isClassic and not VMRT.RaidGroups.KeepPosInGroup then
		wipe(needPosInGroup)
	end

	module.db.needGroup = needGroup
	module.db.needPosInGroup = needPosInGroup
	module.db.lockedUnit = lockedUnit
	module.db.groupsReady = false
	module.db.groupWithRL = isRLfound and 0 or RLGroup

	if module.options.processRoster then
		module.options.processRoster:Disable()
	end

	module:ProcessRoster()
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
	
		if module.options.processRoster then
			module.options.processRoster:Enable()
		end
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

	if module.options.processRoster then
		module.options.processRoster:Enable()
	end
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

function module:slash(arg)
	if arg and arg:find("^raidgroup ") then
		local name = arg:match("^raidgroup (.-)$")
		if name then
			for i=#VMRT.RaidGroups.profiles,1,-1 do
				local entry = VMRT.RaidGroups.profiles[i]
				if entry.name == name then
					module:ApplyGroups(entry)
					return
				end
			end
		end
	elseif arg == "help" then
		print("|cff00ff00/rt raidgroup |cffffff00GROUPNAME|r|r - apply raid groups with name GROUPNAME")
	end
end