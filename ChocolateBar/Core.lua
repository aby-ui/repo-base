local LibStub, broker, LSM = LibStub, LibStub("LibDataBroker-1.1"), LibStub("LibSharedMedia-3.0")
local ChocolateBar = LibStub("AceAddon-3.0"):NewAddon("ChocolateBar", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")
local _G, pairs, ipairs, table, string, tostring = _G, pairs, ipairs, table, string, tostring
local select, strjoin, CreateFrame = select, strjoin, CreateFrame

ChocolateBar.Jostle = {}
ChocolateBar.Bar = {}
ChocolateBar.ChocolatePiece = {}
ChocolateBar.Drag = {}
local modules = {}

local Drag = ChocolateBar.Drag
local Chocolate = ChocolateBar.ChocolatePiece
local Bar = ChocolateBar.Bar

local chocolateBars = {}
local chocolateObjects = {}
local db --reference to ChocolateBar.db.profile

--------
-- utility functions
--------
local function Debug(...)
	if ChocolateBar.db.char.debug then
	 	local s = "ChocolateBar Debug:"
		for i=1,select("#", ...) do
			local x = select(i, ...)
			s = strjoin(" ",s,tostring(x))
		end
		_G.DEFAULT_CHAT_FRAME:AddMessage(s)
	end
end

function ChocolateBar:Debug(...)
	Debug(self, ...)
end

function debugbars()
	for k,v in pairs(chocolateBars) do
		Debug(k,v)
	end
end

local defaults = {
	profile = {
		petBattleHideBars = true, combatopacity = 1, scale = 1,
		height = 21, iconSize = 0.75, moveFrames = true, adjustCenter = true,
		strata = "BACKGROUND", barRightClick = "163UI",
		gap = 5, textOffset = 1, moreBar = "none", moreBarDelay = 4,
		fontPath = " ", fontSize = 12,
		background = {
			textureName = "BantoBar",
			texture = "Interface\\Addons\\!!!163UI!!!\\Textures\\statusbar\\BantoBar",
			borderTexture = "Tooltip-Border",
			color = {r = 0.15, g = 0.15, b = 0.3, a = .75,},
			borderColor = {r = 0.7, g = 0.8, b = 1, a = .15,},
			tileSize = 130,
			edgeSize = 8,
			barInset = 3,
		},
		moduleOptions = {},
		barSettings = {
			['*'] = {
				barName = "ChocolateBar1", align = "top", enabled = true, index = 10, width = 0,
			},
			['ChocolateBar1'] = {
				barName = "ChocolateBar1", align = "top", enabled = true, index = 1, width = 0,
			},
		},
		objSettings = {
			['*'] = {
				barName = "", align = "left", enabled = true, showText = true,
				showIcon = true, index = 500, width = 0,
			},
		},
	},
	char = {
		debug = false,
	}
}

--------
-- Ace3 callbacks
--------
function ChocolateBar:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ChocolateBarDB", defaults, "Default")
  self:RegisterChatCommand("chocolatebar", "ChatCommand")
	db = self.db.profile

	local AceCfgDlg = LibStub("AceConfigDialog-3.0")
	AceCfgDlg:AddToBlizOptions("ChocolateBar", "ChocolateBar")

	LSM:Register("statusbar", "Tooltip", "Interface\\Tooltips\\UI-Tooltip-Background")
	LSM:Register("statusbar", "Solid", "Interface\\Buttons\\WHITE8X8")
	--LSM:Register("statusbar", "Gloss","Interface\\AddOns\\ChocolateBar\\pics\\Gloss")
	--LSM:Register("statusbar", "DarkBottom","Interface\\AddOns\\ChocolateBar\\pics\\DarkBottom")
	--LSM:Register("statusbar", "X-Perl","Interface\\AddOns\\ChocolateBar\\pics\\X-Perl")
	LSM:Register("background", "Titan","Interface\\AddOns\\ChocolateBar\\pics\\Titan")
	LSM:Register("background", "Tribal","Interface\\AddOns\\ChocolateBar\\pics\\Tribal")

	self:RegisterEvent("PLAYER_REGEN_DISABLED","OnEnterCombat")
	self:RegisterEvent("PLAYER_REGEN_ENABLED","OnLeaveCombat")
	self:RegisterEvent("PLAYER_ENTERING_WORLD","OnEnterWorld")
	self:RegisterEvent("PET_BATTLE_OPENING_START","OnPetBattleOpen")
	self:RegisterEvent("PET_BATTLE_CLOSE","OnPetBattleOver")
	self:RegisterEvent("ADDON_LOADED",function(event, addonName)
		if self[addonName] then self[addonName](self) end
	end)

	--fix frame strata for 8.0
  if not self.db.profile.fixedStrata then
		self.db.profile.strata = "BACKGROUND"
		self.db.profile.fixedStrata = true
	end

	local barSettings = db.barSettings
	for k, v in pairs(barSettings) do
		local name = v.barName
		self:AddBar(k, v, true) --force no anchor update
	end
	self:AnchorBars()

	for name, module in pairs(modules) do
		moduleDB = self.db.profile.moduleOptions[name] or {}
		self.db.profile.moduleOptions[name] = moduleDB
		if module.OnInitialize then module:OnInitialize(moduleDB) end
	end

  ChocolateBar:RegisterOptions(db, chocolateBars, modules)
	--_G.InterfaceOptions_AddCategory(self:CreateOptionPanel());
    -- XXX 163 moved from OnEnable
	for name, obj in broker:DataObjectIterator() do
		self:LibDataBroker_DataObjectCreated(nil, name, obj, true) --force noupdate on chocolateBars
	end
    broker.RegisterCallback(self, "LibDataBroker_DataObjectCreated")
end

function ChocolateBar:OnEnable()
	--[[
    for name, obj in broker:DataObjectIterator() do
		self:LibDataBroker_DataObjectCreated(nil, name, obj, true) --force noupdate on chocolateBars
	end
	self:UpdateBars() --update chocolateBars here
	broker.RegisterCallback(self, "LibDataBroker_DataObjectCreated")
    --]]
  	for k,v in pairs(chocolateBars) do v:Show() end self:UpdateBars() --xxx 163

	local moreChocolate = LibStub("LibDataBroker-1.1"):GetDataObjectByName("MoreChocolate")
	if moreChocolate then
		moreChocolate:SetBar(db)
	end
end

function ChocolateBar:NewModule(name, moduleDefaults, options, optionsKey)
	module = modules[name] or {}
	module.default = defaults
	module.options = options
	defaults.profile.moduleOptions[name] = moduleDefaults
	modules[name] = module
	return module
end

-- called on ADDON_LOADED of Blizzard_OrderHallUI
function ChocolateBar:Blizzard_OrderHallUI()
	Debug("ChocolateBar:Blizzard_OrderHallUI")
	--hookOrderHallCommandBar(self)
	if not self.hookedOrderHallCommandBar and db.hideOrderHallCommandBar then
			local orderHallCommandBar = _G.OrderHallCommandBar
			Debug("hookOrderHallCommandBar", orderHallCommandBar)
			if orderHallCommandBar then
				orderHallCommandBar:HookScript("OnShow", function() Debug("OrderHallCommandBar:OnShow"); ChocolateBar:ToggleOrderHallCommandBar() end)
				orderHallCommandBar:Hide()
				self.hookedOrderHallCommandBar = true
			end
	end
end

function ChocolateBar:UpdateJostle()
	for name, bar in pairs(chocolateBars) do
		bar:UpdateJostle(db)
	end
end

function ChocolateBar:ToggleOrderHallCommandBar()
	local orderHallCommandBar = _G.OrderHallCommandBar
	if orderHallCommandBar then
		if db.hideOrderHallCommandBar then
			orderHallCommandBar:Hide()
		else
			orderHallCommandBar:Show()
		end
	end
	ChocolateBar:UpdateJostle()
end

function ChocolateBar:OnDisable()
    --163ui not stop data brokers
	--for name, obj in broker:DataObjectIterator() do
	--	if chocolateObjects[name] then chocolateObjects[name]:Hide() end
	--end
	for k,v in pairs(chocolateBars) do
		v:Hide()
	end
    self:UpdateBars() --163ui reposition
	--broker.UnregisterCallback(self, "LibDataBroker_DataObjectCreated")
end

function ChocolateBar:OnEnterWorld()
	self:UpdateChoclates("resizeFrame")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	ChocolateBar:UpdateOptions(chocolateBars)
end

function ChocolateBar:OnPetBattleOpen(...)
	Debug("OnPetBattleOpen", ...)
	self.InCombat = true
	if db.petBattleHideBars then
		for name,bar in pairs(chocolateBars) do
			bar.petHide = bar:IsShown()
			bar:Hide()
		end
	end
end

function ChocolateBar:OnPetBattleOver(...)
	Debug("OnPetBattleClose", ...)
	self.InCombat = false
	if db.petBattleHideBars then
		for name,bar in pairs(chocolateBars) do
			if bar.petHide then
				bar:Show()
				bar:UpdateJostle(db)
			end
		end
	end
end

function ChocolateBar:OnEnterCombat()
	self.InCombat = true
	local combatHideAllBars = db.combathidebar
	local combatOpacityAllBars = db.combatopacity
	for name,bar in pairs(chocolateBars) do
		local settings = bar.settings
		if combatHideAllBars or settings.hideBarInCombat then
			bar.tempHide = bar:IsShown()
			bar:Hide()
		elseif combatOpacityAllBars < 1 then
			bar.tempHide = bar:GetAlpha()
			bar:SetAlpha(db.combatopacity)
		end
	end
end

function ChocolateBar:OnLeaveCombat()
	self.InCombat = false
	local combatHideAllBars = db.combathidebar
	local combatOpacityAllBars = db.combatopacity
	for name,bar in pairs(chocolateBars) do
		local settings = bar.settings
		if combatHideAllBars or settings.hideBarInCombat then
			if bar.tempHide then
				bar:Show()
			end
		elseif combatOpacityAllBars < 1 then
			if bar.tempHide then
				bar:SetAlpha(1)
			end
		end
	end
end

--------
-- LDB callbacks
--------
function ChocolateBar:LibDataBroker_DataObjectCreated(event, name, obj, noupdate)
	local t = obj.type

	if t == "data source" or t == "launcher" then
		if db.objSettings[name].enabled then
			self:EnableDataObject(name, obj, noupdate)
		end
	else
		Debug("Unknown type", t, name)
	end
end

function ChocolateBar:EnableDataObject(name, obj, noupdate)
	local t = obj.type
	if t ~= "data source" and t ~= "launcher" then
		Debug("Unknown type", t, name)
		return 0
	end
	
	local settings = db.objSettings[name]
	settings.enabled = true

	local barName = settings.barName

	-- set default values depending on data source
	if barName == "" then
		--barName = "ChocolateBar1"
		settings.barName = "ChocolateBar1"
		if t and t == "data source" then
			settings.align = "left"
			settings.showText = true
			if db.autodissource then
				settings.enabled = false
				return
			end
			--if name == "ChocolateClock" or name == "Broker_uClock" then
			if(name:lower():find'clock') then
				settings.align = "right"
				settings.index = -1
			end
		else
			settings.align = "right"
			settings.showText = false
			if db.autodislauncher then
				settings.enabled = false
				return
			end
		end
	end
	obj.name = name

	local choco = Chocolate:New(name, obj, settings, db)
	chocolateObjects[name] = choco

	local bar = chocolateBars[barName]
	if bar then
		bar:AddChocolatePiece(choco, name,noupdate)
	else
		chocolateBars["ChocolateBar1"]:AddChocolatePiece(choco, name,noupdate)
	end

    --if(obj.type == 'data source') then
    --    choco:Update(choco, 'resizeFrame')
    --end
	broker.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name, "AttributeChanged")
	
	ChocolateBar:AddObjectOptions(name, obj)
end

function ChocolateBar:DisableDataObject(name)
	broker.UnregisterCallback(self,"LibDataBroker_AttributeChanged_"..name)
	--get bar from setings
	if db.objSettings[name] then
		db.objSettings[name].enabled = false
		local barName = db.objSettings[name].barName
		if(barName and chocolateBars[barName])then
			chocolateBars[barName]:EatChocolatePiece(name)
		end
	end
end

function ChocolateBar:AttributeChanged(event, name, key, value)
	--Debug("ChocolateBar:AttributeChanged ",name," key: ", key, value)
	local settings = db.objSettings[name]
	if not settings.enabled then
		return
	end
	local choco = chocolateObjects[name]
	choco:Update(choco, key, value, name)
end

-- disable autohide for all bars during drag and drop
function ChocolateBar:TempDisAutohide(value)
	for name,bar in pairs(chocolateBars) do
		if value then
			bar.tempHide = bar.autohide
			bar.autohide = false
			bar:ShowAll()
		else
			if bar.tempHide then
				bar.autohide = true
				bar:HideAll()
			end
		end
	end
end

-- returns nil if the plugin is disabled
function ChocolateBar:GetChocolate(name)
	return chocolateObjects[name]
end

function ChocolateBar:GetChocolates()
	return chocolateObjects
end

function ChocolateBar:GetBar(name)
	return chocolateBars[name]
end

function ChocolateBar:GetBars()
	return chocolateBars
end

function ChocolateBar:SetBars(tab)
	chocolateBars = tab or {}
end

local function getFreeBarName()
	local used = false
	local name
	for i=1,100 do
		name = "ChocolateBar"..i
		for k,v in pairs(chocolateBars) do
			if name == v:GetName() then
				used = true
			end
		end
		if not used then
			return name
		end
		used = false
	end
	Debug("no free bar name found ")
end

function ChocolateBar:UpdateChoclates(key, val)
	for name,choco in pairs(chocolateObjects) do
		choco:Update(choco, key, val)
	end
end

function ChocolateBar:ExecuteforAllChoclates(func, ...)
	for name,choco in pairs(chocolateObjects) do
		func(choco, ...)
	end
end

--------
-- Bars Management
--------
function ChocolateBar:AddBar(name, settings, noupdate)
	if not name then --find free name
		name = getFreeBarName()
	end
	if not settings then
		settings = db.barSettings[name]
	end
	local bar = Bar:New(name,settings,db)
	Drag:RegisterFrame(bar)
	chocolateBars[name] = bar
	settings.barName = name
	if not noupdate then
		self:AnchorBars()
	end
	return name, bar
end

function ChocolateBar:UpdateBars(updateindex)
	for k,v in pairs(chocolateBars) do
		v:UpdateBar(updateindex)
		v:UpdateAutoHide(db)
	end
end

-- sort and anchor all bars
function ChocolateBar:AnchorBars()
	local temptop = {}
	local tempbottom = {}

	for k,v in pairs(chocolateBars) do
		local settings = v.settings
		local index = settings.index or 500
		if settings.align == "top" then
			table.insert(temptop,{v,index})
		elseif settings.align == "bottom" then
			table.insert(tempbottom,{v,index})
		else
			v:ClearAllPoints()
			if settings.barPoint and settings.barOffx and settings.barOffy then
				--Debug("ChocolateBar:AnchorBars() v:SetPoint",v:GetName(),settings.barPoint,settings.barOffx,settings.barOffy)
				v:SetPoint(settings.barPoint, "UIParent",settings.barOffx ,settings.barOffy)
				v:SetWidth(settings.width)
			else
				--Debug("ChocolateBar:AnchorBars() table.insert",v:GetName())
				settings.align = "top"
				table.insert(temptop,{v,index})
			end
		end
	end
	table.sort(temptop, function(a,b)return a[2] < b[2] end)
	table.sort(tempbottom, function(a,b)return a[2] < b[2] end)

	local yoff = 0
	local relative = nil
	for i, v in ipairs(temptop) do
		local bar = v[1]
		bar:ClearAllPoints()
		if(relative)then
			bar:SetPoint("TOPLEFT",relative,"BOTTOMLEFT", 0,-yoff)
			bar:SetPoint("RIGHT", relative ,"RIGHT",0, 0);
		else
			bar:SetPoint("TOPLEFT",-1,1);
			bar:SetPoint("RIGHT", "UIParent" ,"RIGHT",0, 0);
		end
		--if updateindex then
			bar.settings.index = i
		--end
		relative = bar
	end

	local relative = nil
	for i, v in ipairs(tempbottom) do
		local bar = v[1]
		bar:ClearAllPoints()
		if(relative)then
			bar:SetPoint("BOTTOMLEFT",relative,"TOPLEFT", 0,-yoff)
			bar:SetPoint("RIGHT", relative ,"RIGHT",0, 0);
		else
			bar:SetPoint("BOTTOMLEFT",-1,0);
			bar:SetPoint("RIGHT", "UIParent" ,"RIGHT",0, 0);
		end
		--if updateindex then
			bar.settings.index = i
		--end
		relative = bar
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function onRightClick(self)
		Debug(self:GetName(), self:GetParent():GetName())
		self:GetParent():OnMouseUp("RightButton")
end

local function createPointer()
	Debug("createPointer")
	pointer = CreateFrame("Frame", "ChocolatePointer")
	pointer:SetFrameStrata("FULLSCREEN_DIALOG")
	pointer:SetFrameLevel(20)
	pointer:SetWidth(15)

	local arrow = pointer:CreateTexture(nil, "DIALOG")
	arrow:SetPoint("CENTER",pointer,"LEFT", 0, 0)
	arrow:SetTexture("Interface\\AddOns\\ChocolateBar\\pics\\pointer")
	return pointer
end

function ChocolateBar:GetPointer(parent)
	Debug("GetPointer", self.pointer)
	local pointer = self.pointer or createPointer()
	pointer:SetHeight(parent:GetHeight())
	pointer:SetParent(parent)
	return pointer
end

--------
-- option functions
--------
function ChocolateBar:ChatCommand(input)
	ChocolateBar:LoadOptions(nil, input)
end

function ChocolateBar:LoadOptions(pluginName, input, blizzard)
	Debug("OpenOptions", input, blizzard)
	ChocolateBar:OpenOptions(chocolateBars, db, input, pluginName, modules, blizzard)
end

function ChocolateBar:UpdateDB(data)
	db = data
end
