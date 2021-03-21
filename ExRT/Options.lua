local GlobalAddonName, ExRT = ...

ExRT.Options = {}

local ELib,L = ExRT.lib,ExRT.L

------------------------------------------------------------
--------------- New Options --------------------------------
------------------------------------------------------------

local OptionsFrameName = "ExRTOptionsFrame"
local Options = ELib:Template("ExRTBWInterfaceFrame",UIParent)
_G[OptionsFrameName] = Options

ExRT.Options.Frame = Options

Options.Width = 863
Options.Height = 650
Options.ListWidth = 165

Options:Hide()
Options:SetPoint("CENTER",0,0)
Options:SetSize(Options.Width,Options.Height)
Options.HeaderText:SetText("")
Options:SetMovable(true)
Options:RegisterForDrag("LeftButton")
Options:SetScript("OnDragStart", function(self) self:StartMoving() end)
Options:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
Options:SetDontSavePosition(true)
Options.border = ExRT.lib.CreateShadow(Options,20)

ELib:ShadowInside(Options)

Options.bossButton:Hide()
Options.backToInterface:SetScript("OnClick",function ()
	ExRT.Options.Frame:Hide()
	InterfaceOptionsFrame:Show()
end)


Options.modulesList = ELib:ScrollList(Options):LineHeight(24):Size(Options.ListWidth - 1,Options.Height):Point(0,0):FontSize(11):HideBorders()
Options.modulesList.SCROLL_WIDTH = 10
Options.modulesList.LINE_PADDING_LEFT = 7
Options.modulesList.LINE_TEXTURE = "Interface\\Addons\\"..GlobalAddonName.."\\media\\White"
Options.modulesList.LINE_TEXTURE_IGNOREBLEND = true
Options.modulesList.LINE_TEXTURE_HEIGHT = 24
Options.modulesList.LINE_TEXTURE_COLOR_HL = {1,1,1,.5}
Options.modulesList.LINE_TEXTURE_COLOR_P = {1,.82,0,.6}
Options.modulesList.EnableHoverAnimation = true

Options.modulesList.border_right = ELib:Texture(Options.modulesList,.24,.25,.30,1,"BORDER"):Point("TOPLEFT",Options.modulesList,"TOPRIGHT",0,0):Point("BOTTOMRIGHT",Options.modulesList,"BOTTOMRIGHT",1,0)

Options.modulesList.Frame.ScrollBar:Size(8,0):Point("TOPRIGHT",0,0):Point("BOTTOMRIGHT",0,0)
Options.modulesList.Frame.ScrollBar.thumb:SetHeight(100)
Options.modulesList.Frame.ScrollBar.buttonUP:Hide()
Options.modulesList.Frame.ScrollBar.buttonDown:Hide()

Options.modulesList.Frame.ScrollBar.border_right = ELib:Texture(Options.modulesList.Frame.ScrollBar,.24,.25,.30,1,"BORDER"):Point("TOPLEFT",Options.modulesList.Frame.ScrollBar,"TOPLEFT",-1,0):Point("BOTTOMRIGHT",Options.modulesList.Frame.ScrollBar,"BOTTOMLEFT",0,0)

Options.Frames = {}

Options:SetScript("OnShow",function(self)
	self.modulesList:Update()
	if Options.CurrentFrame and Options.CurrentFrame.AdditionalOnShow then
		Options.CurrentFrame:AdditionalOnShow()
	end

	if type(Options.CurrentFrame.OnShow) == 'function' then
		Options.CurrentFrame:OnShow()
	end
end)

function Options:SetPage(page)
	if Options.CurrentFrame then
		Options.CurrentFrame:Hide()
	end
	Options.CurrentFrame = page

	if Options.CurrentFrame.AdditionalOnShow then
		Options.CurrentFrame:AdditionalOnShow()
	end

	Options.CurrentFrame:Show()

	if Options.CurrentFrame.isWide and Options.nowWide ~= Options.CurrentFrame.isWide then
		local frameWidth = type(Options.CurrentFrame.isWide)=='number' and Options.CurrentFrame.isWide or 850
		Options:SetWidth(frameWidth+Options.ListWidth)
		Options.nowWide = Options.CurrentFrame.isWide
	elseif not Options.CurrentFrame.isWide and Options.nowWide then
		Options:SetWidth(Options.Width)
		Options.nowWide = nil
	end

	if Options.CurrentFrame.isWide then
		Options.CurrentFrame:SetWidth(type(Options.CurrentFrame.isWide)=='number' and Options.CurrentFrame.isWide or 850)
	end

	if type(Options.CurrentFrame.OnShow) == 'function' then
		Options.CurrentFrame:OnShow()
	end
end


function Options.modulesList:SetListValue(index)
	Options:SetPage(Options.Frames[index])
end


function ExRT.Options:Add(moduleName,frameName)
	local self = CreateFrame("Frame",OptionsFrameName..moduleName,Options)
	self:SetSize(Options.Width-Options.ListWidth,Options.Height-16)
	self:SetPoint("TOPLEFT",Options.ListWidth,-16)
	
	local pos = #Options.Frames + 1
	Options.modulesList.L[pos] = frameName or moduleName
	Options.Frames[pos] = self
	
	if Options:IsShown() then
		Options.modulesList:Update()
	end
	
	self:Hide()
	
	return self
end

function ExRT.Options:AddIcon(moduleName,icon)
	Options.modulesList.IconsRight = Options.modulesList.IconsRight or {}
	for i=1,#Options.modulesList.L do
		if Options.modulesList.L[i] == moduleName then
			Options.modulesList.IconsRight[i] = icon
			break
		end
	end
end

local OptionsFrame = ExRT.Options:Add("Exorsus Raid Tools","|cffffa800Exorsus Raid Tools|r")
Options.modulesList:SetListValue(1)
Options.modulesList.selected = 1
Options.modulesList:Update()

------------------------------------------------------------

ExRT.Options.InBlizzardInterface = CreateFrame( "Frame", nil )
ExRT.Options.InBlizzardInterface.name = "Exorsus Raid Tools"
InterfaceOptions_AddCategory(ExRT.Options.InBlizzardInterface)
ExRT.Options.InBlizzardInterface:Hide()

ExRT.Options.InBlizzardInterface:SetScript("OnShow",function (self)
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	ExRT.Options:Open()
	self:SetScript("OnShow",nil)
end)

ExRT.Options.InBlizzardInterface.button = ELib:Button(ExRT.Options.InBlizzardInterface,"Exorsus Raid Tools",0):Size(400,25):Point("TOP",0,-100):OnClick(function ()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	ExRT.Options:Open()
end)

------------------------------------------------------------

Options.scale = ELib:Slider(Options):_Size(70,8):Point("TOPRIGHT",-45,-5):Range(50,200,true):OnShow(function(self)
	VExRT.Addon.Scale = tonumber(VExRT.Addon.Scale or "1") or 1
	VExRT.Addon.Scale = max( min( VExRT.Addon.Scale,2 ),0.5)

	self:SetTo((VExRT.Addon.Scale or 1)*100):Scale(1 / (VExRT.Addon.Scale or 1)):OnChange(function(self,event) 
		if self.disable then
			self:SetTo(100)
			self.tooltipText = L.bossmodsscale.."|n100%|n"..L.SetScaleReset
			return
		end
		event = ExRT.F.Round(event)
		VExRT.Addon.Scale = event / 100
		ExRT.F.SetScaleFixTR(Options,VExRT.Addon.Scale)
		self:SetScale(1 / VExRT.Addon.Scale)
		self.tooltipText = L.bossmodsscale.."|n"..event.."%|n"..L.SetScaleReset
		self:tooltipReload(self)
	end)
	self:SetScript("OnShow",nil)
	self.tooltipText = L.bossmodsscale.."|n"..((VExRT.Addon.Scale or 1) * 100).."%|n"..L.SetScaleReset
	self:Point("TOPRIGHT",-45 * (VExRT.Addon.Scale or 1),-5)
	Options:SetScale(VExRT.Addon.Scale or 1)
end,true)

Options.scale:SetScript("OnMouseDown",function(self,button)
	if button == "RightButton" then
		self:SetTo(100)
		self.disable = true
	end
end)
Options.scale:SetScript("OnMouseUp",function(self,button)
	if button == "RightButton" then
		self.disable = nil
	end
	self:Point("TOPRIGHT",-45 * (VExRT.Addon.Scale or 1),-5)
end)

----> Minimap Icon

local MiniMapIcon = CreateFrame("Button", "LibDBIcon10_ExorsusRaidTools", Minimap)
ExRT.MiniMapIcon = MiniMapIcon
MiniMapIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") 
MiniMapIcon:SetSize(32,32) 
MiniMapIcon:SetFrameStrata("MEDIUM")
MiniMapIcon:SetFrameLevel(8)
MiniMapIcon:SetPoint("CENTER", -12, -80)
MiniMapIcon:SetDontSavePosition(true)
MiniMapIcon:RegisterForDrag("LeftButton")
MiniMapIcon.icon = MiniMapIcon:CreateTexture(nil, "BACKGROUND")
MiniMapIcon.icon:SetTexture("Interface\\AddOns\\ExRT\\media\\MiniMap")
MiniMapIcon.icon:SetSize(32,32)
MiniMapIcon.icon:SetPoint("CENTER", 0, 0)
MiniMapIcon.iconMini = MiniMapIcon:CreateTexture(nil, "BACKGROUND")
MiniMapIcon.iconMini:SetTexture("Interface\\AddOns\\ExRT\\media\\MiniMap")
MiniMapIcon.iconMini:SetSize(18,18)
MiniMapIcon.iconMini:SetPoint("CENTER", 0, 0)
MiniMapIcon.iconMini:Hide()
MiniMapIcon.border = MiniMapIcon:CreateTexture(nil, "ARTWORK")
MiniMapIcon.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MiniMapIcon.border:SetTexCoord(0,0.6,0,0.6)
MiniMapIcon.border:SetAllPoints()
MiniMapIcon:RegisterForClicks("anyUp")
MiniMapIcon:SetScript("OnEnter",function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
	GameTooltip:AddLine("Exorsus Raid Tools") 
	GameTooltip:AddLine(L.minimaptooltiplmp,1,1,1) 
	GameTooltip:AddLine(L.minimaptooltiprmp,1,1,1) 
	GameTooltip:Show() 
	self.anim:Play()
	self.iconMini:Show()
end)
MiniMapIcon:SetScript("OnLeave", function(self)    
	GameTooltip:Hide()
	self.anim:Stop()
	self.iconMini:Hide()
end)


MiniMapIcon.anim = MiniMapIcon:CreateAnimationGroup()
MiniMapIcon.anim:SetLooping("BOUNCE")
MiniMapIcon.timer = MiniMapIcon.anim:CreateAnimation()
MiniMapIcon.timer:SetDuration(1)
local IconDiff = (1 - 18/32)/2
MiniMapIcon.timer:SetScript("OnUpdate", function(self,elapsed) 
	local diff = 0.1 * self:GetProgress()
	MiniMapIcon.iconMini:SetTexCoord(IconDiff+diff,1-IconDiff-diff,IconDiff+diff,1-IconDiff-diff)
end)

local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {false, false, false, true},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
	["SIDE-LEFT"] = {false, true, false, true},
	["SIDE-RIGHT"] = {true, false, true, false},
	["SIDE-TOP"] = {false, false, true, true},
	["SIDE-BOTTOM"] = {true, true, false, false},
	["TRICORNER-TOPLEFT"] = {false, true, true, true},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}

local function IconMoveButton(self)
	if self.dragMode == "free" then
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", x, y)
		VExRT.Addon.IconMiniMapLeft = x
		VExRT.Addon.IconMiniMapTop = y
	else
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = Minimap:GetEffectiveScale()
		px, py = px / scale, py / scale
		
		local angle = math.atan2(py - my, px - mx)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		local quadTable = minimapShapes[minimapShape]
		if quadTable[q] then
			x, y = x*80, y*80
		else
			local diagRadius = 103.13708498985 --math.sqrt(2*(80)^2)-10
			x = math.max(-80, math.min(x*diagRadius, 80))
			y = math.max(-80, math.min(y*diagRadius, 80))
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", Minimap, "CENTER", x, y)
		VExRT.Addon.IconMiniMapLeft = x
		VExRT.Addon.IconMiniMapTop = y
	end
end

MiniMapIcon:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	self:SetScript("OnUpdate", IconMoveButton)
	self.isMoving = true
	GameTooltip:Hide()
end)
MiniMapIcon:SetScript("OnDragStop", function(self)
	self:UnlockHighlight()
	self:SetScript("OnUpdate", nil)
	self.isMoving = false
end)

local function MiniMapIconOnClick(self, button)
	if button == "RightButton" then
		for _,func in pairs(ExRT.MiniMapMenu) do
			func:miniMapMenu()
		end
		ExRT.Options:UpdateModulesList()
		--EasyMenu(ExRT.F.menuTable, ExRT.Options.MiniMapDropdown, "cursor", 10 , -15, "MENU")
		ELib.ScrollDropDown.EasyMenu(self,ExRT.F.menuTable,150)
	elseif button == "LeftButton" then
		ExRT.Options:Open()
	end
end

MiniMapIcon:SetScript("OnMouseUp", MiniMapIconOnClick)

ExRT.Options.MiniMapDropdown = CreateFrame("Frame", "ExRTMiniMapMenuFrame", nil, "UIDropDownMenuTemplate")

local MinimapMenu_UIDs = {}
local MinimapMenu_UIDnumeric = 0
local MinimapMenu_Level = {3,4,5,5}

function ExRT.F.MinimapMenuAdd(text, func, level, uid, subMenu)
	level = level or 2
	if not uid then
		MinimapMenu_UIDnumeric = MinimapMenu_UIDnumeric + 1
		uid = MinimapMenu_UIDnumeric
	end
	if MinimapMenu_UIDs[uid] then
		return
	end
	local menuTable = { text = text, func = func, notCheckable = true, keepShownOnClick = true, }
	if subMenu then
		menuTable.hasArrow = true
		menuTable.menuList = subMenu
		menuTable.subMenu = subMenu
	end
	tinsert(ExRT.F.menuTable,MinimapMenu_Level[level],menuTable)
	for i=level,#MinimapMenu_Level do
		MinimapMenu_Level[i] = MinimapMenu_Level[i] + 1
	end
	MinimapMenu_UIDs[uid] = menuTable
end

function ExRT.F.MinimapMenuRemove(uid)
	for i=1,#ExRT.F.menuTable do
		if ExRT.F.menuTable[i] == MinimapMenu_UIDs[uid] then 
			for j=i,#ExRT.F.menuTable do
				ExRT.F.menuTable[j] = ExRT.F.menuTable[j+1]
			end
			for j=1,#MinimapMenu_Level do
				if i <= MinimapMenu_Level[j] then
					MinimapMenu_Level[j] = MinimapMenu_Level[j] - 1
				end
			end
			MinimapMenu_UIDs[uid] = nil
			return
		end
	end
end

function ExRT.Options:Open(PANEL)
	CloseDropDownMenus()
	ELib.ScrollDropDown.Close()
	Options:Show()
	
	Options:SetPage(PANEL or Options.Frames[Options.modulesList.selected or 1])
	
	if PANEL then
		for i=1,#Options.Frames do
			if Options.Frames[i] == PANEL then
				Options.modulesList.selected = i
				Options.modulesList:Update()
				break
			end
		end
	end
end

ExRT.F.menuTable = {
{ text = L.minimapmenu, isTitle = true, notCheckable = true, notClickable = true },
{ text = L.minimapmenuset, func = ExRT.Options.Open, notCheckable = true, keepShownOnClick = true, },
{ text = " ", isTitle = true, notCheckable = true, notClickable = true },
{ text = " ", isTitle = true, notCheckable = true, notClickable = true },
{ text = L.minimapmenuclose, func = function() CloseDropDownMenus() ELib.ScrollDropDown.Close() end, notCheckable = true },
}

local modulesActive = {}
function ExRT.Options:UpdateModulesList()
	for i=1,#ExRT.ModulesOptions do
		ExRT.F.MinimapMenuAdd(ExRT.ModulesOptions[i].name, function() 
			ExRT.Options:Open(ExRT.ModulesOptions[i]) 
		end, 2,ExRT.ModulesOptions[i].name)
	end
end

----> Options

function OptionsFrame:AddSnowStorm(maxSnowflake)
	local sf = OptionsFrame.SnowStorm or CreateFrame("ScrollFrame", nil, Options)
	OptionsFrame.SnowStorm = sf
	sf:SetPoint("TOPLEFT")
	sf:SetPoint("BOTTOMRIGHT")
	
	sf.C = sf.C or CreateFrame("Frame", nil, sf) 
	sf:SetScrollChild(sf.C)
	sf.C:SetSize(Options:GetWidth(),Options:GetHeight())

	maxSnowflake = maxSnowflake or 200

	if not OptionsFrame.hatBut then
		local hat = CreateFrame("Button",nil,OptionsFrame)  
		OptionsFrame.hatBut = hat
		hat:SetSize(40,30) 
		hat:SetPoint("CENTER",OptionsFrame.image,-15,45)
		hat.maxSnowflake = maxSnowflake
		hat:RegisterForClicks("LeftButtonDown","RightButtonDown")
		hat:SetScript("OnClick",function(self,button) 
			if button == "RightButton" then
				self.maxSnowflake = 0
			else
				self.maxSnowflake = self.maxSnowflake + 100
			end
			OptionsFrame:AddSnowStorm(self.maxSnowflake)
		end)
		hat:SetScript("OnEnter",function()
			OptionsFrame.imagehat:SetVertexColor(1,.8,.8)
		end)
		hat:SetScript("OnLeave",function()
			OptionsFrame.imagehat:SetVertexColor(1,1,1)
		end)

		hat.g = hat:CreateAnimationGroup()
		hat.g:SetScript('OnFinished', function(self) 
			self.a:SetStartDelay(math.random(10,30))
			self:Play()
		end)
		hat.g.a = hat.g:CreateAnimation()
		hat.g.a:SetDuration(1)
		hat.g.a:SetScript("OnUpdate",function(self)
			local p = self:GetProgress()
			p = p % 0.333
			if p > 0.1665 then 
				p = p 
				if p > 0.24975 then 
					p = (0.333 - p)
				else
					p = p - 0.1665
				end
			else
				if p > 0.08325 then 
					p = -(0.1665 - p)
				else
					p = 0 - p
				end
			end
			OptionsFrame.imagehat:SetPoint("CENTER",OptionsFrame.image,"CENTER",p*12*3,0)
		end)
		hat.g.a:SetStartDelay(10)
		hat.g:Play()
	end

	sf.snow = sf.snow or {}
	sf.snowlast = sf.snowlast or 0
	if sf.snowlast > maxSnowflake then
		for i=maxSnowflake+1,#sf.snow do
			local f = sf.snow[i]
			f:Hide()
		end
		sf.snowlast = 0
		return
	end

	local function AnimOnFinished(self)
		local f = self.p
		f.img:Hide()
		f:Update()
	end
	local function AnimOnUpdate(self)
		local f = self.p
		local p = self:GetProgress()
		if p == 0 then
			return
		end
		if p > 0 and not f.img.on then
			f.img.on = true
			f.img:Show()
		end
		if p > self.wayu then
			self.wayu = p + 0.15
			local way = math.random(1,3)
			self.way = way - 2
			self.wayF, self.wayT = 0, 40
			if self.way == 0 then
				self.wayF, self.wayT = -20, 20
				self.way = 1
			end
		end
		f.x = f.x + math.random(self.wayF, self.wayT) / 100 * self.way
		local posy = -self.H*p+20+self.Hfix
		f.img:SetPoint("CENTER",sf.C,"TOPLEFT",f.x,posy)
		if self.Hfix ~= 0 and posy < (-self.H+20) then
			self:Stop()
			f:Update()
		end
	end
	local function Update(self,isFirstTime)
		local size = math.random(1,20)
		if size >= 10 then
			if math.random(0,100) < 80 then
				size = math.random(1,10)
			end
		end
		self.img:SetSize(size,size)
		self.img.on = nil
		self.g.a.wayu = 0
		self.x = math.random(0,Options:GetWidth())
		self.g.a:SetStartDelay(1+math.random(0,1000)/100)
		self.g.a:SetDuration(math.random(5,14)*(size < 10 and 0.75 or 1))
		self.g.a.H = Options:GetHeight()+40
		self.g.a.Hfix = 0
		if isFirstTime then
			self.g.a.Hfix = -math.random(0,self.g.a.H)
			self.g.a:SetStartDelay(0)
		end
		self.g:Play()
	end

	for i=1,maxSnowflake do
		if not sf.snow[i] then
			local f = CreateFrame("Frame",nil,sf.C)
			sf.snow[i] = f
		
			f.Update = Update

			f.img = f:CreateTexture(nil,"BACKGROUND")
			f.img:SetTexture([[Interface\AddOns\ExRT\media\snowflake]])
			f.img:SetAlpha(.5)
			f.img:Hide()
			
			f.g = f:CreateAnimationGroup()
			f.g.p = f
			f.g:SetScript('OnFinished', AnimOnFinished)
			f.g.a = f.g:CreateAnimation()
			f.g.a.p = f
			f.g.a:SetScript("OnUpdate",AnimOnUpdate)
		
			f:Update(true)
		end
		sf.snow[i]:Show()
	end
	sf.snowlast = maxSnowflake
end

function OptionsFrame:AddDeathStar(maxDeathStars)
	local sf = OptionsFrame.DeathStar or CreateFrame("ScrollFrame", nil, Options)
	OptionsFrame.DeathStar = sf
	sf:SetPoint("TOPLEFT")
	sf:SetPoint("BOTTOMRIGHT")
	
	sf.C = sf.C or CreateFrame("Frame", nil, sf) 
	sf:SetScrollChild(sf.C)
	sf.C:SetSize(Options:GetWidth(),Options:GetHeight())

	maxDeathStars = maxDeathStars or 1

	if not OptionsFrame.hatBut then
		local hat = CreateFrame("Button",nil,OptionsFrame)  
		OptionsFrame.hatBut = hat
		hat:SetSize(76,20) 
		hat:SetPoint("TOP",OptionsFrame.image,22,-5)
		hat.maxDeathStars = maxDeathStars
		hat:RegisterForClicks("LeftButtonDown","RightButtonDown")
		hat:SetScript("OnClick",function(self,button) 
			if button == "RightButton" then
				self.maxDeathStars = 0
			else
				self.maxDeathStars = self.maxDeathStars + 1
			end
			OptionsFrame:AddDeathStar(self.maxDeathStars)
		end)
	end

	sf.snow = sf.snow or {}
	sf.snowlast = sf.snowlast or 0
	if sf.snowlast > maxDeathStars then
		for i=maxDeathStars+1,#sf.snow do
			local f = sf.snow[i]
			f:Hide()
		end
		sf.snowlast = 0
		return
	end

	local function AnimOnFinished(self)
		local f = self.p
		f.img:Hide()
		f:Update()
	end
	local function AnimOnUpdate(self)
		local f = self.p
		local p = self:GetProgress()
		if p == 0 then
			return
		end
		if p > 0 and not f.img.on then
			f.img.on = true
			f.img:Show()
		end
		if not f.pause then
			f.img:SetPoint("TOPLEFT",sf.C,"TOPLEFT",f.xf+(f.xt-f.xf)*p,-(f.yf+(f.yt-f.yf)*p))
		end
		if IsMouseButtonDown(1) and f.img2:IsMouseOver() and not f.pause then
			f.pause = true
			f.img:SetTexture([[Interface\AddOns\ExRT\media\deathstard]])
			
			local d = self:GetDuration()
			local ds = math.min(p + 0.5 / d, 0.999)
			local dp = math.min(p + 2 / d, 1)
			f.alphastart = ds
			f.alphaend = dp

			local t = OptionsFrame.title:GetText()
			if not t:find("%d+") then
				t = t .. " <0>"
			end
			local tt = tonumber(t:match("%d+"),10)
			OptionsFrame.title:SetText(t:gsub("%d+",tt+1))
		end
		if f.pause then
			local a = 1
			if p >= f.alphastart then
				a = 1 - (p - f.alphastart) / (f.alphaend - f.alphastart)
			end
			f.img:SetAlpha(a)
			if p >= f.alphaend then
				self:Stop()
			end
		end
	end
	local function Update(self,isFirstTime)
		local size = 128
		if self.pause then
			self.pause = nil
			self.img:SetTexture([[Interface\AddOns\ExRT\media\deathstar]])
			self.img:SetAlpha(1)
		end
		self.img:SetSize(size,size)
		self.img2:SetSize(size*0.7,size*0.7)
		self.img.on = nil
		self.g.a.wayu = 0
		local MIN,MAXX,MAXY = -size, Options:GetWidth(), Options:GetHeight()
		self.xf = math.random(MIN,MAXX)
		self.xt = math.random(MIN,MAXX)
		self.yf = math.random(MIN,MAXY)
		self.yt = math.random(MIN,MAXY)
		local p = math.random(1,4)
		if p == 1 then
			self.yf = MIN
		elseif p == 2 then
			self.xf = MAXX
		elseif p == 3 then
			self.yf = MAXY
		elseif p == 4 then
			self.xf = MIN
		end
		local p2 = math.random(1,4)
		while p == p2 do
			p2 = math.random(1,4)
		end
		if p2 == 1 then
			self.yt = MIN
		elseif p2 == 2 then
			self.xt = MAXX
		elseif p2 == 3 then
			self.yt = MAXY
		elseif p2 == 4 then
			self.xt = MIN
		end		
		self.g.a:SetStartDelay(1+math.random(0,1000)/100)
		self.g.a:SetDuration(math.random(5,14))
		if isFirstTime then
			self.g.a:SetStartDelay(0)
		end
		self.g:Play()
	end

	for i=1,maxDeathStars do
		if not sf.snow[i] then
			local f = CreateFrame("Frame",nil,sf.C)
			sf.snow[i] = f
		
			f.Update = Update

			f.img = f:CreateTexture(nil,"BACKGROUND")
			f.img:SetTexture([[Interface\AddOns\ExRT\media\deathstar]])
			f.img:SetAlpha(1)
			f.img:Hide()

			f.img2 = f:CreateTexture(nil,"BACKGROUND")
			f.img2:SetPoint("CENTER",f.img)
			f.img2:Hide()
			
			f.g = f:CreateAnimationGroup()
			f.g.p = f
			f.g:SetScript('OnFinished', AnimOnFinished)
			f.g.a = f.g:CreateAnimation()
			f.g.a.p = f
			f.g.a:SetScript("OnUpdate",AnimOnUpdate)
		
			f:Update(true)
		end
		sf.snow[i]:Show()
	end
	sf.snowlast = maxDeathStars
end


OptionsFrame.image = ELib:Texture(OptionsFrame,"Interface\\AddOns\\ExRT\\media\\MiniMap"):Point("TOPLEFT",15,5):Size(140,140):Color(.9,.9,.9,1)
OptionsFrame.image2 = ELib:Texture(OptionsFrame,"Interface\\AddOns\\ExRT\\media\\Aura73","BORDER"):Point("CENTER",OptionsFrame.image,"CENTER",0,0):Size(140*2,140*2):Color(.9,.9,.45,1)
OptionsFrame.image2:SetAlpha(0)
OptionsFrame.title = ELib:Text(OptionsFrame,"Exorsus Raid Tools",28):Point("LEFT",OptionsFrame.image,"RIGHT",20,0):Color()

OptionsFrame.animLogo = CreateFrame("Frame",nil,OptionsFrame)
OptionsFrame.animLogo.g = OptionsFrame.animLogo:CreateAnimationGroup()
OptionsFrame.animLogo.g:SetLooping("BOUNCE")
OptionsFrame.animLogo.g:SetScript('OnFinished', function(self) 
	self.a:SetStartDelay(math.random(4,15))
	self:Play()
end)
OptionsFrame.animLogo.g.a = OptionsFrame.animLogo.g:CreateAnimation()
OptionsFrame.animLogo.g.a:SetDuration(2)
OptionsFrame.animLogo.g.a:SetScript("OnUpdate",function(self)
	local p = self:GetProgress()
	OptionsFrame.image2:SetAlpha(p*0.75)
end)
OptionsFrame.animLogo.g.a:SetStartDelay(4)
OptionsFrame.animLogo.g:Play()

OptionsFrame.imagehat = ELib:Texture(OptionsFrame,"Interface\\AddOns\\ExRT\\media\\MiniMap","OVERLAY"):Point("CENTER",OptionsFrame.image,"CENTER",0,0):Size(140,140):Shown(false)

OptionsFrame.dateChecks = CreateFrame("Frame",nil,OptionsFrame)
OptionsFrame.dateChecks:SetPoint("TOPLEFT")
OptionsFrame.dateChecks:SetSize(1,1)
OptionsFrame.dateChecks:SetScript("OnShow",function(self)
	self:SetScript("OnShow",nil)
	local today = date("*t",time())
	local isChristmas, isSnowDay
	if ExRT.locale == "ruRU" then
		if (today.month == 12 and today.day >= 23) or (today.month == 1 and today.day <= 4) then
			isChristmas = true
		end
		if (today.month == 12 and today.day >= 30) or (today.month == 1 and today.day <= 2) then
			isSnowDay = true
		end
	elseif ExRT.locale == "deDE" or ExRT.locale == "enGB" or ExRT.locale == "enUS" or ExRT.locale == "esES" or ExRT.locale == "esMX" or ExRT.locale == "frFR" or ExRT.locale == "itIT" or ExRT.locale == "ptBR" or ExRT.locale == "ptPT" then
		if (today.month == 12 and today.day >= 15) or (today.month == 1 and today.day <= 2) then
			isChristmas = true
		end
		if (today.month == 12 and today.day >= 24 and today.day <= 25) or ((today.month == 12 and today.day >= 31) or (today.month == 1 and today.day <= 1)) then
			isSnowDay = true
		end
	elseif ExRT.locale == "koKR" then
		if (today.month == 12 and today.day >= 30) or (today.month == 1 and today.day <= 2) then
			isChristmas = true
		end
		if (today.month == 12 and today.day >= 31) or (today.month == 1 and today.day <= 1) then
			isSnowDay = true
		end
	end

	if isChristmas then
		OptionsFrame.imagehat:Show()
		if isSnowDay then
			OptionsFrame:AddSnowStorm()
		else
			OptionsFrame:AddSnowStorm(0)
		end
	end

	if false and (today.month == 5 and today.day == 4) then
		OptionsFrame.image:SetTexture("Interface\\AddOns\\ExRT\\media\\OptionLogom4")
		if math.random(0,9) == 4 then
			OptionsFrame.image2:Color(1,0,0,1)	--you are sith
		else	
			OptionsFrame.image2:Color(0,1,0,1)
		end
		OptionsFrame.title:Color(.95,.455,.23,1)

		OptionsFrame:AddDeathStar()
	end
end)

OptionsFrame.chkIconMiniMap = ELib:Check(OptionsFrame,L.setminimap1):Point(25,-155):OnClick(function(self) 
	if self:GetChecked() then
		VExRT.Addon.IconMiniMapHide = true
		ExRT.MiniMapIcon:Hide()
	else
		VExRT.Addon.IconMiniMapHide = nil
		ExRT.MiniMapIcon:Show()
	end
end)
OptionsFrame.chkIconMiniMap:SetScript("OnShow", function(self,event) 
	self:SetChecked(VExRT.Addon.IconMiniMapHide) 
end)

OptionsFrame.chkHideOnEsc = ELib:Check(OptionsFrame,L.SetHideOnESC):Point(350,-155):OnClick(function(self) 
	if self:GetChecked() then
		VExRT.Addon.DisableHideESC = true
		for i=1,#UISpecialFrames do
			if UISpecialFrames[i] == "ExRTOptionsFrame" then
				tremove(UISpecialFrames, i)
				break
			end
		end
	else
		VExRT.Addon.DisableHideESC = nil
		tinsert(UISpecialFrames, "ExRTOptionsFrame")
	end
end)
OptionsFrame.chkHideOnEsc:SetScript("OnShow", function(self,event) 
	self:SetChecked(VExRT.Addon.DisableHideESC) 
end)

OptionsFrame.eggBut = CreateFrame("Button",nil,OptionsFrame)  
OptionsFrame.eggBut:SetSize(14,14) 
OptionsFrame.eggBut:SetPoint("CENTER",OptionsFrame.image,0,0)
OptionsFrame.eggBut:SetScript("OnClick",function(self) 

end)

OptionsFrame.authorLeft = ELib:Text(OptionsFrame,L.setauthor,12):Size(150,25):Point(15,-195):Shadow():Top()
OptionsFrame.authorRight = ELib:Text(OptionsFrame,"Afiya (Афиа) @ EU-Howling Fjord",12):Size(520,25):Point(135,-195):Color():Shadow():Top()

OptionsFrame.versionLeft = ELib:Text(OptionsFrame,L.setver,12):Size(150,25):Point(15,-215):Shadow():Top()
OptionsFrame.versionRight = ELib:Text(OptionsFrame,ExRT.V..(ExRT.T == "R" and "" or " "..ExRT.T),12):Size(520,25):Point(135,-215):Color():Shadow():Top()

OptionsFrame.contactLeft = ELib:Text(OptionsFrame,L.setcontact,12):Size(150,25):Point(15,-235):Shadow():Top()
OptionsFrame.contactRight = ELib:Text(OptionsFrame,"e-mail: ykiigor@gmail.com",12):Size(520,25):Point(135,-235):Color():Shadow():Top()

OptionsFrame.thanksLeft = ELib:Text(OptionsFrame,L.SetThanks,12):Size(150,25):Point(15,-255):Shadow():Top()
OptionsFrame.thanksRight = ELib:Text(OptionsFrame,"Phanx, funkydude, Shurshik, Kemayo, Guillotine, Rabbit, fookah, diesal2010, Felix, yuk6196, martinkerth, Gyffes, Cubetrace, tigerlolol, Morana, SafeteeWoW, Dejablue, Wollie, eXochron",12):Size(540,25):Point(135,-255):Color():Shadow():Top()

if L.TranslateBy ~= "" then
	OptionsFrame.translateLeft = ELib:Text(OptionsFrame,L.SetTranslate,12):Size(150,25):Point("LEFT",OptionsFrame,15,0):Point("TOP",OptionsFrame.thanksRight,"BOTTOM",0,-8):Shadow():Top()
	OptionsFrame.translateRight = ELib:Text(OptionsFrame,L.TranslateBy,12):Size(520,25):Point("LEFT",OptionsFrame.thanksRight,"LEFT",0,0):Point("TOP",OptionsFrame.translateLeft,0,0):Color():Shadow():Top()
end

OptionsFrame.Changelog = ELib:ScrollFrame(OptionsFrame):Size(680,180):Point("TOP",0,-325):OnShow(function(self)
	local text = ExRT.Options.Changelog or ""
	text = text:gsub("(v%.%d+([^\n]*).-\n\n)",function(a,b)
		if (b == "-Classic" and ExRT.isClassic) or (b ~= "-Classic" and not ExRT.isClassic) then
			return a
		else
			return ""
		end
	end)
	local isFind
	text = text:gsub("^[ \t\n]*","|cff99ff99"):gsub("v%.(%d+)",function(ver)
		if not isFind and ver ~= tostring(ExRT.V) then
			isFind = true
			return "|rv."..ver
		end
	end)
	if #text > 8192 then
		local lennow = 0
		local texts = {""}
		local c = 1
		for w in string.gmatch(text,"[^\n]+\n*") do
			lennow = lennow + #w
			if lennow > 8192 then
				c = c + 1
				texts[c] = ""
				lennow = #w
			end
			texts[c] = texts[c] .. w
		end
		for i=2,c do
			self["Text"..i] = ELib:Text(self.C,texts[i],12):Point("LEFT",3,0):Point("RIGHT",-3,0):Point("TOP",self["Text"..(i-1)] or self.Text,"BOTTOM",0,0):Left():Color(1,1,1)
		end
		text = texts[1]
	end
	self.Text:SetText(text)
	self:Height(self.Text:GetStringHeight()+50)
	self:OnShow(function()
		local height = 6 + self.Text:GetStringHeight()
		local c = 2
		while self["Text"..c] do
			height = height + self["Text"..c]:GetStringHeight()
			c = c + 1
		end
		self:Height(height)
		self:OnShow()
	end,true)
end,true)
ELib:Border(OptionsFrame.Changelog,0)

ELib:DecorationLine(OptionsFrame):Point("BOTTOM",OptionsFrame.Changelog,"TOP",0,0):Point("LEFT",OptionsFrame):Point("RIGHT",OptionsFrame):Size(0,1)
ELib:DecorationLine(OptionsFrame):Point("TOP",OptionsFrame.Changelog,"BOTTOM",0,0):Point("LEFT",OptionsFrame):Point("RIGHT",OptionsFrame):Size(0,1)

OptionsFrame.Changelog.Text = ELib:Text(OptionsFrame.Changelog.C,"",12):Point("TOPLEFT",3,-3):Point("TOPRIGHT",-3,-3):Left():Color(1,1,1)
OptionsFrame.Changelog.Header = ELib:Text(OptionsFrame.Changelog,"Changelog",12):Point("BOTTOMLEFT",OptionsFrame.Changelog,"TOPLEFT",0,2):Left()

local VersionCheckReqSended = {}
local function UpdateVersionCheck()
	OptionsFrame.VersionUpdateButton:Enable()
	local list = OptionsFrame.VersionCheck.L
	wipe(list)
	
	for _, name, _, class in ExRT.F.IterateRoster do
		list[#list + 1] = {
			"|c"..ExRT.F.classColor(class or "?")..name,
			0,
			name,
		}
	end
	
	for i=1,#list do
		local name = list[i][3]
		
		local ver = ExRT.RaidVersions[name]
		if not ver and not name:find("%-") then
			for long_name,v in pairs(ExRT.RaidVersions) do
				if long_name:find("^"..name) then
					ver = v
					break
				end
			end
		end
		if not ver then
			if VersionCheckReqSended[name] then
				if not UnitIsConnected(name) then
					ver = "|cff888888offline"
				else
					ver = "|cffff8888no addon"
				end
			else
				ver = "???"
			end
		elseif not tonumber(ver) then
		
		elseif tonumber(ver) >= ExRT.V then
			ver = "|cff88ff88"..ver
		else
			ver = "|cffffff88"..ver
		end
		
		list[i][2] = ver
	end
	
	sort(list,function(a,b) return a[3]<b[3] end)
	OptionsFrame.VersionCheck:Update()
end

OptionsFrame.VersionCheck = ELib:ScrollTableList(OptionsFrame,0,130):Point("TOPLEFT",OptionsFrame.Changelog,"BOTTOMLEFT",0,-3):Size(350,125):HideBorders():OnShow(UpdateVersionCheck,true)
OptionsFrame.VersionUpdateButton = ELib:Button(OptionsFrame,UPDATE):Point("BOTTOMLEFT",OptionsFrame.VersionCheck,"BOTTOMRIGHT",10,3):Size(100,20):Tooltip(L.OptionsUpdateVerTooltip):OnClick(function()
	ExRT.F.SendExMsg("needversion","")
	C_Timer.After(2,UpdateVersionCheck)
	for _, name in ExRT.F.IterateRoster do
		VersionCheckReqSended[name]=true
	end
	local list = OptionsFrame.VersionCheck.L
	for i=1,#list do
		list[i][2] = "..."
	end
	OptionsFrame.VersionCheck:Update()
	OptionsFrame.VersionUpdateButton:Disable()
end)

local function CreateDataBrokerPlugin()
	local dataObject = LibStub:GetLibrary('LibDataBroker-1.1'):NewDataObject(GlobalAddonName, {
		type = 'launcher',
		icon = "Interface\\AddOns\\ExRT\\media\\MiniMap",
		OnClick = MiniMapIconOnClick,
	})
end
CreateDataBrokerPlugin()
