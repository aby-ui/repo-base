local GlobalAddonName, ExRT = ...

local module = ExRT:New("WAChecker",ExRT.L.WAChecker)
local ELib,L = ExRT.lib,ExRT.L

module.db.responces = {}
module.db.lastReq = {}

function module.options:Load()
	self:CreateTilte()
	
	local UpdatePage

	local Filter

	local errorNoWA = ELib:Text(self,L.WACheckerWANotFound):Point("TOP",0,-30)
	errorNoWA:Hide()
	
	local PAGE_HEIGHT,PAGE_WIDTH = 520,680
	local LINE_HEIGHT,LINE_NAME_WIDTH = 16,160
	local VERTICALNAME_WIDTH = 20
	local VERTICALNAME_COUNT = 24
	
	local mainScroll = ELib:ScrollFrame(self):Size(PAGE_WIDTH,PAGE_HEIGHT):Point("TOP",0,-80):Height(700)
	ELib:Border(mainScroll,0)

	ELib:DecorationLine(self):Point("BOTTOM",mainScroll,"TOP",0,0):Point("LEFT",self):Point("RIGHT",self):Size(0,1)
	ELib:DecorationLine(self):Point("TOP",mainScroll,"BOTTOM",0,0):Point("LEFT",self):Point("RIGHT",self):Size(0,1)
	
	local prevTopLine = 0
	local prevPlayerCol = 0
	
	mainScroll.ScrollBar:ClickRange(LINE_HEIGHT)
	mainScroll.ScrollBar.slider:SetScript("OnValueChanged", function (self,value)
		local parent = self:GetParent():GetParent()
		parent:SetVerticalScroll(value % LINE_HEIGHT) 
		self:UpdateButtons()
		local currTopLine = floor(value / LINE_HEIGHT)
		if currTopLine ~= prevTopLine then
			prevTopLine = currTopLine
			UpdatePage()
		end
	end)
	
	local raidSlider = ELib:Slider(self,""):Point("TOPLEFT",mainScroll,"BOTTOMLEFT",LINE_NAME_WIDTH + 15,-3):Range(0,25):Size(VERTICALNAME_WIDTH*VERTICALNAME_COUNT):SetTo(0):OnChange(function(self,value)
		local currPlayerCol = floor(value)
		if currPlayerCol ~= prevPlayerCol then
			prevPlayerCol = currPlayerCol
			UpdatePage()
		end
	end)
	raidSlider.Low:Hide()
	raidSlider.High:Hide()
	raidSlider.text:Hide()
	raidSlider.Low.Show = raidSlider.Low.Hide
	raidSlider.High.Show = raidSlider.High.Hide

	
	local function SetIcon(self,type)
		if not type or type == 0 then
			self:SetAlpha(0)
		elseif type == 1 then
			self:SetTexCoord(0.5,0.5625,0.5,0.625)
			self:SetVertexColor(.8,0,0,1)
		elseif type == 2 then
			self:SetTexCoord(0.5625,0.625,0.5,0.625)
			self:SetVertexColor(0,.8,0,1)
		elseif type == 3 then
			self:SetTexCoord(0.625,0.6875,0.5,0.625)
			self:SetVertexColor(.8,.8,0,1)
		elseif type == 4 then
			self:SetTexCoord(0.875,0.9375,0.5,0.625)
			self:SetVertexColor(.8,.8,0,1)
		elseif type == -1 or type < 0 then
			if module.SetIconExtra then
				module.SetIconExtra(self,type)
			end
		end		
	end
	
	self.helpicons = {}
	for i=0,2 do
		local icon = self:CreateTexture(nil,"ARTWORK")
		icon:SetPoint("TOPLEFT",2,-20-i*12)
		icon:SetSize(14,14)
		icon:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
		SetIcon(icon,i+1)
		local t = ELib:Text(self,"",10):Point("LEFT",icon,"RIGHT",2,0):Size(0,16):Color(1,1,1)
		if i==0 then
			t:SetText(L.WACheckerMissingAura)
		elseif i==1 then
			t:SetText(L.WACheckerExistsAura)
		elseif i==2 then
			t:SetText(L.WACheckerPlayerHaveNotWA)
		end
		self.helpicons[i+1] = {icon,t}
	end

	self.filterEdit = ELib:Edit(self):Size(LINE_NAME_WIDTH,16):Point("BOTTOMLEFT",mainScroll,"TOPLEFT",-1,4):Tooltip(FILTER):OnChange(function(self,isUser)
		if not isUser then
			return
		end
		if self:GetText() == "" then
			Filter = nil
		else
			Filter = self:GetText():lower()
		end
		UpdatePage()
	end)

	local function LineName_OnClick(self,_,_,force)
		if IsShiftKeyDown() or force then
			local name, realm = UnitFullName("player")
			local fullName = name.."-"..realm
			local id = self:GetParent().db.data.id
			local link = "[WeakAuras: "..fullName.." - "..id.."]"
		
			local editbox = GetCurrentKeyBoardFocus()
			if(editbox) then
				editbox:Insert(link)
			else
				ChatFrame_OpenChat(link)
			end
		end
	end
	local function LineName_ShareButton_OnEnter(self)
		if module.ShareButtonHover then
			module.ShareButtonHover(self)
		end
		self.background:SetVertexColor(1,1,0,1)
	end	
	local function LineName_ShareButton_OnLeave(self)
		if module.ShareButtonLeave then
			module.ShareButtonLeave(self)
		end
		self.background:SetVertexColor(1,1,1,0.7)
	end
	local function LineName_ShareButton_OnClick(self,...)
		if not module.ExportWA then
			LineName_OnClick(self:GetParent().name,nil,nil,true)
		else
			module.ShareButtonClick(self,...)
		end
	end	

	local function LineName_Icon_OnEnter(self)
		if self.HOVER_TEXT then
			ELib.Tooltip.Show(self,nil,self.HOVER_TEXT)
		end
		if module.IconHoverFunctions then
			for i=1,#module.IconHoverFunctions do
				module.IconHoverFunctions[i](self,true)
			end
		end
	end	
	local function LineName_Icon_OnLeave(self)
		if self.HOVER_TEXT then
			ELib.Tooltip.Hide()
		end
		if module.IconHoverFunctions then
			for i=1,#module.IconHoverFunctions do
				module.IconHoverFunctions[i](self,false)
			end
		end
	end	

	local lines = {}
	self.lines = lines
	for i=1,floor(PAGE_HEIGHT / LINE_HEIGHT) + 2 do
		local line = CreateFrame("Frame",nil,mainScroll.C)
		lines[i] = line
		line:SetPoint("TOPLEFT",0,-(i-1)*LINE_HEIGHT)
		line:SetPoint("TOPRIGHT",0,-(i-1)*LINE_HEIGHT)
		line:SetSize(0,LINE_HEIGHT)
		
		line.name = ELib:Text(line,"",10):Point("LEFT",2,0):Size(LINE_NAME_WIDTH-LINE_HEIGHT/2,LINE_HEIGHT):Color(1,1,1):Tooltip("ANCHOR_LEFT",true)
		line.name.TooltipFrame:SetScript("OnClick",LineName_OnClick)
		
		line.share = CreateFrame("Button",nil,line)
		line.share:SetPoint("LEFT",line.name,"RIGHT",0,0)
		line.share:SetSize(LINE_HEIGHT,LINE_HEIGHT)
		line.share:SetScript("OnEnter",LineName_ShareButton_OnEnter)
		line.share:SetScript("OnLeave",LineName_ShareButton_OnLeave)
		line.share:SetScript("OnClick",LineName_ShareButton_OnClick)
		line.share:RegisterForClicks("LeftButtonUp","RightButtonUp")
		
		line.share.background = line.share:CreateTexture(nil,"ARTWORK")
		line.share.background:SetPoint("CENTER")
		line.share.background:SetSize(LINE_HEIGHT,LINE_HEIGHT)
		line.share.background:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
		line.share.background:SetTexCoord(0.125+(0.1875 - 0.125)*4,0.1875+(0.1875 - 0.125)*4,0.5,0.625)
		line.share.background:SetVertexColor(1,1,1,0.7)
		
		line.icons = {}
		local iconSize = min(VERTICALNAME_WIDTH,LINE_HEIGHT)
		for j=1,VERTICALNAME_COUNT do
			local icon = line:CreateTexture(nil,"ARTWORK")
			line.icons[j] = icon
			icon:SetPoint("CENTER",line,"LEFT",LINE_NAME_WIDTH + 15 + VERTICALNAME_WIDTH*(j-1) + VERTICALNAME_WIDTH / 2,0)
			icon:SetSize(iconSize,iconSize)
			icon:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
			SetIcon(icon,(i+j)%4)

			icon.hoverFrame = CreateFrame("Frame",nil,line)
			icon.hoverFrame:Hide()
			icon.hoverFrame:SetAllPoints(icon)
			icon.hoverFrame:SetScript("OnEnter",LineName_Icon_OnEnter)
			icon.hoverFrame:SetScript("OnLeave",LineName_Icon_OnLeave)
		end
		
		line.t=line:CreateTexture(nil,"BACKGROUND")
		line.t:SetAllPoints()
		line.t:SetColorTexture(1,1,1,.05)
	end
	
	local function RaidNames_OnEnter(self)
		local t = self.t:GetText()
		if t ~= "" then
			ELib.Tooltip.Show(self,"ANCHOR_LEFT",t)
		end
	end
	
	local raidNames = CreateFrame("Frame",nil,self)
	for i=1,VERTICALNAME_COUNT do
		raidNames[i] = ELib:Text(raidNames,"RaidName"..i,10):Point("BOTTOMLEFT",mainScroll,"TOPLEFT",LINE_NAME_WIDTH + 15 + VERTICALNAME_WIDTH*(i-1),0):Color(1,1,1)

		local f = CreateFrame("Frame",nil,self)
		f:SetPoint("BOTTOMLEFT",mainScroll,"TOPLEFT",LINE_NAME_WIDTH + 15 + VERTICALNAME_WIDTH*(i-1),0)
		f:SetSize(VERTICALNAME_WIDTH,80)
		f:SetScript("OnEnter",RaidNames_OnEnter)
		f:SetScript("OnLeave",ELib.Tooltip.Hide)
		f.t = raidNames[i]
		
		local t=mainScroll:CreateTexture(nil,"BACKGROUND")
		raidNames[i].t = t
		t:SetPoint("TOPLEFT",LINE_NAME_WIDTH + 15 + VERTICALNAME_WIDTH*(i-1),0)
		t:SetSize(VERTICALNAME_WIDTH,PAGE_HEIGHT)
		if i%2==1 then
			t:SetColorTexture(.5,.5,1,.05)
			t.Vis = true
		end
	end
	local group = raidNames:CreateAnimationGroup()
	group:SetScript('OnFinished', function() group:Play() end)
	local rotation = group:CreateAnimation('Rotation')
	rotation:SetDuration(0.000001)
	rotation:SetEndDelay(2147483647)
	rotation:SetOrigin('BOTTOMRIGHT', 0, 0)
	--rotation:SetDegrees(90)
	rotation:SetDegrees(60)
	group:Play()
	
	local highlight_y = mainScroll.C:CreateTexture(nil,"BACKGROUND",nil,2)
	highlight_y:SetColorTexture(1,1,1,.2)
	local highlight_x = mainScroll:CreateTexture(nil,"BACKGROUND",nil,2)
	highlight_x:SetColorTexture(1,1,1,.2)
	
	local highlight_onupdate_maxY = (floor(PAGE_HEIGHT / LINE_HEIGHT) + 2) * LINE_HEIGHT
	local highlight_onupdate_minX = LINE_NAME_WIDTH + 15
	local highlight_onupdate_maxX = highlight_onupdate_minX + #raidNames * VERTICALNAME_WIDTH
	mainScroll.C:SetScript("OnUpdate",function(self)
		local x,y = ExRT.F.GetCursorPos(mainScroll)
		if y < 0 or y > PAGE_HEIGHT then
			highlight_x:Hide()
			highlight_y:Hide()
			return
		end	
		local x,y = ExRT.F.GetCursorPos(self)
		if y >= 0 and y <= highlight_onupdate_maxY then
			y = floor(y / LINE_HEIGHT)
			highlight_y:ClearAllPoints()
			highlight_y:SetAllPoints(lines[y+1])
			highlight_y:Show()
		else
			highlight_x:Hide()
			highlight_y:Hide()
			return
		end
		if x >= highlight_onupdate_minX and x <= highlight_onupdate_maxX then
			x = floor((x - highlight_onupdate_minX) / VERTICALNAME_WIDTH)
			highlight_x:ClearAllPoints()
			highlight_x:SetAllPoints(raidNames[x+1].t)
			highlight_x:Show()
		elseif x >= 0 and x <= (PAGE_WIDTH - 16) then
			highlight_x:Hide()
		else
			highlight_x:Hide()
			highlight_y:Hide()
		end
	end)
	
	local UpdateButton = ELib:Button(self,UPDATE):Point("TOPLEFT",mainScroll,"BOTTOMLEFT",-2,-5):Size(130,20):OnClick(function()
		module:SendReq()
	end)
	
	local function sortByName(a,b)
		if a and b and a.name and b.name then
			return a.name < b.name
		end
	end
	
	function UpdatePage()
		if not WeakAurasSaved then
			errorNoWA:Show()
			mainScroll:Hide()
			raidSlider:Hide()
			for i=1,#self.helpicons do
				self.helpicons[i][1]:SetAlpha(0)
				self.helpicons[i][2]:SetAlpha(0)
			end
			UpdateButton:Hide()
			raidNames:Hide()
			self.filterEdit:Hide()
			self.allIsHidden = true
			return
		end
		if self.allIsHidden then
			self.allIsHidden = false
			errorNoWA:Hide()
			mainScroll:Show()
			for i=1,#self.helpicons do
				self.helpicons[i][1]:SetAlpha(1)
				self.helpicons[i][2]:SetAlpha(1)
			end
			UpdateButton:Show()
			raidNames:Show()
		end
		
		local auras,auras2 = {},{}
		for WA_name,WA_data in pairs(WeakAurasSaved.displays) do
			local aura = auras2[WA_name]
			if aura then
				aura.name = WA_name
				aura.data = WA_data
			else
				aura = {
					name = WA_name,
					data = WA_data,
				}
			end
			if not Filter or WA_name:lower():find(Filter) then
				local parent = WA_data.parent
				if parent then
					local a = auras2[parent] or {}
					auras2[parent] = a
					a[#a+1] = aura
				else
					auras[#auras+1] = aura
				end
			end
			auras2[WA_name] = aura
		end
		if Filter then
			local inList = {}
			for i=1,#auras do
				inList[ auras[i] ] = true
			end
			for k,v in pairs(auras2) do
				if #v > 0 and not inList[v] and v.name then
					auras[#auras+1] = v
				end
			end
		end
		sort(auras,sortByName)
		for i=1,#auras do
			sort(auras[i],sortByName)
		end
		local sortedTable = {}
		if not Filter then
			sortedTable[#sortedTable+1] = {name="VERSION"}
		end
		for i=1,#auras do
			sortedTable[#sortedTable+1] = auras[i]
			for j=1,#auras[i] do
				sortedTable[#sortedTable+1] = auras[i][j]
				auras[i][j].isChild = true
			end
		end
		mainScroll.ScrollBar:Range(0,max(0,#sortedTable * LINE_HEIGHT - 1 - PAGE_HEIGHT),nil,true)
		
		local namesList,namesList2 = {},{}
		for _,name,_,class in ExRT.F.IterateRoster do
			namesList[#namesList + 1] = {
				name = name,
				class = class,
			}
		end
		sort(namesList,sortByName)
		
		if #namesList <= VERTICALNAME_COUNT then
			raidSlider:Hide()
			prevPlayerCol = 0
		else
			raidSlider:Show()
			raidSlider:Range(0,#namesList - VERTICALNAME_COUNT)
		end
		
		local raidNamesUsed = 0
		for i=1+prevPlayerCol,#namesList do
			raidNamesUsed = raidNamesUsed + 1
			if not raidNames[raidNamesUsed] then
				break
			end
			local name = ExRT.F.delUnitNameServer(namesList[i].name)
			raidNames[raidNamesUsed]:SetText(name)
			raidNames[raidNamesUsed]:SetTextColor(ExRT.F.classColorNum(namesList[i].class))
			namesList2[raidNamesUsed] = name
			if raidNames[raidNamesUsed].Vis then
				raidNames[raidNamesUsed]:SetAlpha(.05)
			end
		end
		for i=raidNamesUsed+1,#raidNames do
			raidNames[i]:SetText("")
			raidNames[i].t:SetAlpha(0)
		end
		
		local lineNum = 1
		local backgroundLineStatus = (prevTopLine % 2) == 1

		local myWAVER = WeakAuras.versionString

		for i=prevTopLine+1,#sortedTable do
			local aura = sortedTable[i]
			local line = lines[lineNum]
			if not line then
				break
			end
			line:Show()
			line.name:SetText((aura.isChild and "- " or "")..aura.name)
			line.db = aura
			line.t:SetShown(backgroundLineStatus)
			if i == 1 and aura.name == "VERSION" then
				line.share:Hide()
			else
				line.share:Show()
			end
			for j=1,VERTICALNAME_COUNT do
				local pname = namesList2[j] or "-"
				
				local db
				for name,DB in pairs(module.db.responces) do
					if name == pname or name:find("^"..pname) then
						db = DB
						break
					end
				end

				local hoverText
				
				if not db then
					SetIcon(line.icons[j],0)
				elseif db.noWA then
					SetIcon(line.icons[j],3)
				elseif aura.name == "VERSION" then
					hoverText = db.wa_ver or "NO DATA"
					SetIcon(line.icons[j],myWAVER == db.wa_ver and 2 or (db.wa_ver and 1) or 3)
				elseif type(db[ aura.name ]) == 'number' then
					SetIcon(line.icons[j],db[ aura.name ])
				elseif db[ aura.name ] then
					SetIcon(line.icons[j],2)
				else
					SetIcon(line.icons[j],1)
				end

				if module.ShowHoverIcons then
					line.icons[j].hoverFrame.HOVER_TEXT = nil
					line.icons[j].hoverFrame.name = pname
					line.icons[j].hoverFrame:Show()
				elseif hoverText then
					line.icons[j].hoverFrame.HOVER_TEXT = hoverText
					line.icons[j].hoverFrame:Show()
				else
					line.icons[j].hoverFrame.HOVER_TEXT = nil
					line.icons[j].hoverFrame:Hide()
				end
			end
			backgroundLineStatus = not backgroundLineStatus
			lineNum = lineNum + 1
		end
		for i=lineNum,#lines do
			lines[i]:Hide()
		end
	end
	self.UpdatePage = UpdatePage
	
	function self:OnShow()
		UpdatePage()
	end
end

function module:SendReq()
	local isFirst = true
	local str = ""
	for WA_name,WA_data in pairs(WeakAurasSaved.displays) do
		if (#str + #WA_name) > 240 then
			str = str:gsub("''$","")
			if isFirst then
				ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("G","H",str))
				isFirst = nil
			else
				ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("G",str))
			end
			str = ""
		end
		str = str..WA_name.."''"
	end
	if #str > 0 then
		str = str:gsub("''$","")
		if isFirst then
			ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("G","H",str))
			isFirst = nil
		else
			ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("G",str))
		end	
	end
end

local SendRespSch = nil

function module:SendResp()
	SendRespSch = nil
	if not WeakAurasSaved then
		ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("R","NOWA"))
		return
	end
	ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("R","DATA",tostring(WeakAuras.versionString)))

	local isChanged = true
	local buffer,bufferStart = {},0
	local r,rNow = 0,0
	for i=1,#module.db.lastReq do
		if WeakAurasSaved.displays[ module.db.lastReq[i] ] then
			r = bit.bor(r,2^rNow)
		end
		rNow = rNow + 1
		isChanged = true
		if i % 32 == 0 then
			buffer[#buffer + 1] = r
			r = 0
			rNow = 0
			if #buffer == 19 then
				ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("R",bufferStart,unpack(buffer)))
				wipe(buffer)
				bufferStart = i
				isChanged = false
			end
		end
	end
	if isChanged then
		buffer[#buffer + 1] = r
		ExRT.F.SendExMsg("wachk", ExRT.F.CreateAddonMsg("R",bufferStart,unpack(buffer)))
	end
end

function module.main:ADDON_LOADED()
	module:RegisterAddonMessage()
end

local lastSenderTime,lastSender = 0

function module:addonMessage(sender, prefix, prefix2, ...)
	if prefix == "wachk" then
		if prefix2 == "G" then
			local time = GetTime()
			if lastSender ~= sender and (time - lastSenderTime) < 1.5 then
				return
			end
			lastSender = sender
			lastSenderTime = time
			local str1, str2 = ...
			if str1 == "H" and str2 then
				wipe(module.db.lastReq)
				str1 = str2
			end
			if not str1 then
				return
			end
			
			while str1:find("''") do
				local wa_name,o = str1:match("^(.-)''(.*)$")
			
				module.db.lastReq[#module.db.lastReq + 1] = wa_name
			
				str1 = o
			end
			
			module.db.lastReq[#module.db.lastReq + 1] = str1
			
			if not SendRespSch then
				SendRespSch = C_Timer.NewTimer(1,module.SendResp)
			end
		elseif prefix2 == "R" then
			local str1, str2 = ...
			module.db.responces[ sender ] = module.db.responces[ sender ] or {}
			if str1 == "NOWA" then
				module.db.responces[ sender ].noWA = true
				return
			elseif str1 == "DATA" then
				local _, wa_ver = ...
				module.db.responces[ sender ].wa_ver = wa_ver

				if module.options:IsVisible() and module.options.UpdatePage then
					module.options.UpdatePage()
				end
				return
			end
			local start = tonumber(str1 or "?")
			if not start then
				return
			end
			module.db.responces[ sender ].noWA = nil
			for j=2,select("#", ...) do
				local res = tonumber(select(j, ...),nil)
				
				for i=1,32 do
					if not module.db.lastReq[i + start] then
						break
					elseif bit.band(res,2^(i-1)) > 0 then
						module.db.responces[ sender ][ module.db.lastReq[i + start] ] = true
					else
						module.db.responces[ sender ][ module.db.lastReq[i + start] ] = false
					end
				end
				
				start = start + 32
			end
			
			if module.options:IsVisible() and module.options.UpdatePage then
				module.options.UpdatePage()
			end
		end
	end
end