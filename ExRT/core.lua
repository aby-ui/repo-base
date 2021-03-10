--	09.03.2021

local GlobalAddonName, ExRT = ...

ExRT.V = 4480
ExRT.T = "R"

ExRT.OnUpdate = {}		--> таймеры, OnUpdate функции
ExRT.Slash = {}			--> функции вызова из коммандной строки
ExRT.OnAddonMessage = {}	--> внутренние сообщения аддона
ExRT.MiniMapMenu = {}		--> изменение меню кнопки на миникарте
ExRT.Modules = {}		--> список всех модулей
ExRT.ModulesLoaded = {}		--> список загруженных модулей [для Dev & Advanced]
ExRT.ModulesOptions = {}
ExRT.Classic = {}		--> функции для работы на классик клиенте
ExRT.Debug = {}
ExRT.RaidVersions = {}
ExRT.Temp = {}

ExRT.A = {}			--> ссылки на все модули

ExRT.msg_prefix = {
	["EXRTADD"] = true,
}

ExRT.L = {}			--> локализация
ExRT.locale = GetLocale()

---------------> Version <---------------
do
	local version, buildVersion, buildDate, uiVersion = GetBuildInfo()
	
	ExRT.clientUIinterface = uiVersion
	local expansion,majorPatch,minorPatch = (version or "3.0.0"):match("^(%d+)%.(%d+)%.(%d+)")
	ExRT.clientVersion = (expansion or 0) * 10000 + (majorPatch or 0) * 100 + (minorPatch or 0)
end
if ExRT.clientVersion < 20000 then
	ExRT.isClassic = true
	ExRT.T = "Classic"
elseif ExRT.clientVersion < 30000 then
	ExRT.isClassic = true	--temp
	ExRT.isBC = true
	ExRT.T = "BC"
elseif ExRT.clientVersion >= 90000 then
	ExRT.is90 = true
end
-------------> smart DB <-------------
ExRT.SDB = {}

do
	local realmKey = GetRealmName() or ""
	local charName = UnitName'player' or ""
	realmKey = realmKey:gsub(" ","")
	ExRT.SDB.realmKey = realmKey
	ExRT.SDB.charKey = charName .. "-" .. realmKey
	ExRT.SDB.charName = charName
	ExRT.SDB.charLevel = UnitLevel'player'
end
-------------> global DB <------------
ExRT.GDB = {}
-------------> upvalues <-------------
local pcall, unpack, pairs, coroutine, assert = pcall, unpack, pairs, coroutine, assert
local GetTime, IsEncounterInProgress, CombatLogGetCurrentEventInfo = GetTime, IsEncounterInProgress, CombatLogGetCurrentEventInfo
local SendAddonMessage, strsplit = C_ChatInfo.SendAddonMessage, strsplit
local C_Timer_NewTicker, debugprofilestop = C_Timer.NewTicker, debugprofilestop

if ExRT.T == "D" then
	ExRT.isDev = true
	pcall = function(func,...)
		func(...)
		return true
	end
end

ExRT.NULL = {}
ExRT.NULLfunc = function() end
---------------> Modules <---------------
ExRT.mod = {}
ExRT.mod.__index = ExRT.mod

do
	local function mod_LoadOptions(this)
		this:SetScript("OnShow",nil)
		if this.Load then
			this:Load()
		end
		this.Load = nil
		ExRT.F.dprint(this.moduleName.."'s options loaded")
		this.isLoaded = true
	end
	local function mod_Options_CreateTitle(self)
		self.title = ExRT.lib:Text(self,self.name,20):Point(15,6):Top()
	end
	function ExRT.mod:New(moduleName,localizatedName,disableOptions)
		if ExRT.A[moduleName] then
			return false
		end
		local self = {}
		setmetatable(self, ExRT.mod)
		
		if not disableOptions then
			self.options = ExRT.Options:Add(moduleName,localizatedName)

			self.options:Hide()
			self.options.moduleName = moduleName
			self.options.name = localizatedName or moduleName
			self.options:SetScript("OnShow",mod_LoadOptions)
			
			self.options.CreateTilte = mod_Options_CreateTitle
			
			ExRT.ModulesOptions[#ExRT.ModulesOptions + 1] = self.options
		end
		
		self.main = CreateFrame("Frame", nil)
		self.main.events = {}
		self.main:SetScript("OnEvent",ExRT.mod.Event)
		
		self.main.ADDON_LOADED = ExRT.NULLfunc	--Prevent error for modules without it, not really needed
		
		if ExRT.T == "D" or ExRT.T == "DU" then
			self.main.eventsCounter = {}
			self.main:HookScript("OnEvent",ExRT.mod.HookEvent)
			
			self.main.name = moduleName
		end
		
		self.db = {}
		
		self.name = moduleName
		table.insert(ExRT.Modules,self)
		ExRT.A[moduleName] = self
		
		ExRT.F.dprint("New module: "..moduleName)
		
		return self
	end

	ExRT.New = ExRT.mod.New
end

function ExRT.mod:Event(event,...)
	self[event](self,...)
end
if ExRT.T == "DU" then
	local ExRTDebug = ExRT.Debug
	function ExRT.mod:Event(event,...)
		local dt = debugprofilestop()
		self[event](self,...)
		ExRTDebug[#ExRTDebug+1] = {debugprofilestop() - dt,self.name,event}
	end
end

function ExRT.mod:HookEvent(event)
	self.eventsCounter[event] = self.eventsCounter[event] and self.eventsCounter[event] + 1 or 1
end

local CLEUFrame = CreateFrame("Frame")
local CLEUList = {}
CLEUFrame.CLEUList = CLEUList
local CLEUListToUnreg = {}
local CLEUModuleToList = {}
CLEUFrame.CLEUModuleToList = CLEUModuleToList
local CLEUListLen = 0

local function CLEU_OnEvent()
	local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,
		val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13
				= CombatLogGetCurrentEventInfo()

	for i=1,CLEUListLen do
		CLEUList[i](timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13)
	end
end

local function CLEU_OnEvent_Unreg()
	for f,_ in pairs(CLEUListToUnreg) do
		for j=1,#CLEUList do
			if CLEUList[j] == f then
				tremove(CLEUList, j)
				break
			end
		end		
	end
	wipe(CLEUListToUnreg)

	CLEUListLen = #CLEUList
	if CLEUListLen == 0 then
		CLEUFrame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end

	CLEUFrame:SetScript("OnEvent",CLEU_OnEvent)
	CLEU_OnEvent()
end


CLEUFrame:SetScript("OnEvent",CLEU_OnEvent)
ExRT.CLEUFrame = CLEUFrame

function ExRT.mod:RegisterEvents(...)
	for i=1,select("#", ...) do
		local event = select(i,...)
		if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
			self.main:RegisterEvent(event)
		elseif self.CLEUNotInList then
			if not self.CLEU then self.CLEU = CreateFrame("Frame") end
			self.CLEU:SetScript("OnEvent",self.main.COMBAT_LOG_EVENT_UNFILTERED)
			self.CLEU:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		else
			if CLEUModuleToList[self] then
				self:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
			end
			CLEUFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			CLEUListLen = #CLEUList + 1
			CLEUList[CLEUListLen] = self.main.COMBAT_LOG_EVENT_UNFILTERED
			CLEUModuleToList[self] = self.main.COMBAT_LOG_EVENT_UNFILTERED
		end
		self.main.events[event] = true
		ExRT.F.dprint(self.name,'RegisterEvent',event)
	end
end

function ExRT.mod:UnregisterEvents(...)
	for i=1,select("#", ...) do
		local event = select(i,...)
		if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
			self.main:UnregisterEvent(event)
		elseif self.CLEUNotInList then
			if self.CLEU then
				self.CLEU:SetScript("OnEvent",nil)
				self.CLEU:UnregisterAllEvents()
			end
		else
			if CLEUModuleToList[self] then
				CLEUListToUnreg[ CLEUModuleToList[self] ] = true
				CLEUModuleToList[self] = nil

				CLEUFrame:SetScript("OnEvent",CLEU_OnEvent_Unreg)
			end
		end
		self.main.events[event] = nil
		ExRT.F.dprint(self.name,'UnregisterEvent',event)
	end
end

if ExRT.isClassic then
	function ExRT.mod:RegisterEvents(...)
		for i=1,select("#", ...) do
			local event = select(i,...)
			if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
				pcall(self.main.RegisterEvent,self.main,event)
			else
				CLEUFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
				if CLEUModuleToList[self] then
					self:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
				end
				CLEUListLen = #CLEUList + 1
				CLEUList[CLEUListLen] = self.main.COMBAT_LOG_EVENT_UNFILTERED
				CLEUModuleToList[self] = self.main.COMBAT_LOG_EVENT_UNFILTERED
			end
			self.main.events[event] = true
			ExRT.F.dprint(self.name,'RegisterEvent',event)
		end
	end
	
	function ExRT.mod:UnregisterEvents(...)
		for i=1,select("#", ...) do
			local event = select(i,...)
			if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
				pcall(self.main.UnregisterEvent,self.main,event)
			else
				if CLEUModuleToList[self] then
					CLEUListToUnreg[ CLEUModuleToList[self] ] = true
					CLEUModuleToList[self] = nil
	
					CLEUFrame:SetScript("OnEvent",CLEU_OnEvent_Unreg)
				end
			end
			self.main.events[event] = nil
			ExRT.F.dprint(self.name,'UnregisterEvent',event)
		end
	end
end

function ExRT.mod:RegisterUnitEvent(...)
	self.main:RegisterUnitEvent(...)
	local event = ...
	self.main.events[event] = true
	ExRT.F.dprint(self.name,'RegisterUnitEvent',event)
end

function ExRT.mod:RegisterSlash()
	ExRT.Slash[self.name] = self
end

function ExRT.mod:UnregisterSlash()
	ExRT.Slash[self.name] = nil
end

function ExRT.mod:RegisterAddonMessage()
	ExRT.OnAddonMessage[self.name] = self
end

function ExRT.mod:UnregisterAddonMessage()
	ExRT.OnAddonMessage[self.name] = nil
end

function ExRT.mod:RegisterEgg()
	ExRT.Eggs[self.name] = self
end

function ExRT.mod:UnregisterEgg()
	ExRT.Eggs[self.name] = nil
end

function ExRT.mod:RegisterMiniMapMenu()
	ExRT.MiniMapMenu[self.name] = self
end

function ExRT.mod:UnregisterMiniMapMenu()
	ExRT.MiniMapMenu[self.name] = nil
end

do
	local hideOnPetBattle = {}
	local petBattleTracker = CreateFrame("Frame")
	petBattleTracker:SetScript("OnEvent",function (self, event)
		if event == "PET_BATTLE_OPENING_START" then
			for _,frame in pairs(hideOnPetBattle) do
				if frame:IsShown() then
					frame.petBattleHide = true
					frame:Hide()
				else
					frame.petBattleHide = nil
				end
			end
		else
			for _,frame in pairs(hideOnPetBattle) do
				if frame.petBattleHide then
					frame.petBattleHide = nil
					frame:Show()
				end
			end
		end
	end)
	if not ExRT.isClassic then
		petBattleTracker:RegisterEvent("PET_BATTLE_OPENING_START")
		petBattleTracker:RegisterEvent("PET_BATTLE_CLOSE")
	end
	function ExRT.mod:RegisterHideOnPetBattle(frame)
		hideOnPetBattle[#hideOnPetBattle + 1] = frame
	end
end


ExRT.Coroutinies = {}
function ExRT.mod:AddCoroutine(func)
	local c = coroutine.create(func)
	ExRT.Coroutinies[func] = c
	
	return c
end

function ExRT.mod:GetCoroutine(func)
	return ExRT.Coroutinies[func]
end

function ExRT.mod:RemoveCoroutine(func)
	ExRT.Coroutinies[func] = nil
end

---------------> Mods <---------------

ExRT.F = {}
ExRT.mds = ExRT.F

-- Moved to Functions.lua

do
	local function TimerFunc(self)
		self.func(unpack(self.args))
	end
	function ExRT.F.ScheduleTimer(func, delay, ...)
		local self = nil
		if delay > 0 then
			self = C_Timer_NewTicker(delay,TimerFunc,1)
			-- Avoid C_Timer.NewTimer here cuz it runs ticker with 1 iteration anyway
		else
			self = C_Timer_NewTicker(-delay,TimerFunc)
		end
		self.args = {...}
		self.func = func
		
		return self
	end
	function ExRT.F.CancelTimer(self)
		if self then
			self:Cancel()
		end
	end
	function ExRT.F.ScheduleETimer(self, func, delay, ...)
		ExRT.F.CancelTimer(self)
		return ExRT.F.ScheduleTimer(func, delay, ...)
	end
	
	ExRT.F.NewTimer = ExRT.F.ScheduleTimer
	ExRT.F.Timer = ExRT.F.ScheduleTimer
end

---------------> Data <---------------

ExRT.F.defFont = "Fonts\\ARHei.ttf" --"Interface\\AddOns\\ExRT\\media\\skurri.ttf"
ExRT.F.barImg = "Interface\\AddOns\\ExRT\\media\\bar17.tga"
ExRT.F.defBorder = "Interface\\AddOns\\ExRT\\media\\border.tga"
ExRT.F.textureList = {
	"Interface\\AddOns\\ExRT\\media\\bar6.tga",
	"Interface\\AddOns\\ExRT\\media\\bar9.tga",
	"Interface\\AddOns\\ExRT\\media\\bar16.tga",
	"Interface\\AddOns\\ExRT\\media\\bar17.tga",
	"Interface\\AddOns\\ExRT\\media\\bar19.tga",
	"Interface\\AddOns\\ExRT\\media\\bar24.tga",
	"Interface\\AddOns\\ExRT\\media\\bar24b.tga",
	"Interface\\AddOns\\ExRT\\media\\bar26.tga",
	"Interface\\AddOns\\ExRT\\media\\bar29.tga",
	"Interface\\AddOns\\ExRT\\media\\White.tga",
	[[Interface\TargetingFrame\UI-StatusBar]],
	[[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]],
	[[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
}
ExRT.F.fontList = {
	"Interface\\AddOns\\ExRT\\media\\skurri.ttf",
	"Fonts\\ARIALN.TTF",
	"Fonts\\FRIZQT__.TTF",
	"Fonts\\MORPHEUS.TTF",
	"Fonts\\NIM_____.ttf",
	"Fonts\\SKURRI.TTF",
	"Fonts\\FRIZQT___CYR.TTF",
	"Fonts\\ARHei.ttf",
	"Fonts\\ARKai_T.ttf",
	"Fonts\\2002.ttf",
    "Interface\\AddOns\\!!!163UI!!!\\Textures\\fonts\\Adventure.ttf",
	--"Interface\\AddOns\\ExRT\\media\\TaurusNormal.ttf",
	--"Interface\\AddOns\\ExRT\\media\\UbuntuMedium.ttf",
	--"Interface\\AddOns\\ExRT\\media\\TelluralAlt.ttf",
	--"Interface\\AddOns\\ExRT\\media\\Glametrix.otf",
	--"Interface\\AddOns\\ExRT\\media\\FiraSansMedium.ttf",
	--"Interface\\AddOns\\ExRT\\media\\alphapixels.ttf",
	--"Interface\\AddOns\\ExRT\\media\\ariblk.ttf",
}

if ExRT.locale and ExRT.locale:find("^zh") then		--China & Taiwan fix
	ExRT.F.defFont = "Fonts\\ARHei.ttf"
elseif ExRT.locale == "koKR" then			--Korea fix
	ExRT.F.defFont = "Fonts\\2002.ttf"
end

----------> Version Checker <----------

local isVersionCheckCallback = nil
local function DisableVersionCheckCallback()
	isVersionCheckCallback = nil
end

---------------> Slash <---------------

SlashCmdList["exrtSlash"] = function (arg)
	local argL = strlower(arg)
	if argL == "icon" then
		VExRT.Addon.IconMiniMapHide = not VExRT.Addon.IconMiniMapHide
		if not VExRT.Addon.IconMiniMapHide then 
			ExRT.MiniMapIcon:Show()
		else
			ExRT.MiniMapIcon:Hide()
		end
	elseif argL == "getver" then
		ExRT.F.SendExMsg("needversion","")
		isVersionCheckCallback = ExRT.F.ScheduleETimer(isVersionCheckCallback, DisableVersionCheckCallback, 1.5)
	elseif argL == "getverg" then
		ExRT.F.SendExMsg("needversiong","","GUILD")
		isVersionCheckCallback = ExRT.F.ScheduleETimer(isVersionCheckCallback, DisableVersionCheckCallback, 1.5)
	elseif argL == "set" then
		ExRT.Options:Open()
	elseif argL == "quit" then
		for mod,data in pairs(ExRT.A) do
			data.main:UnregisterAllEvents()
			if data.CLEU then
				data.CLEU:UnregisterAllEvents()
			end
		end
		ExRT.frame:UnregisterAllEvents()
		ExRT.frame:SetScript("OnUpdate",nil)
		print("ExRT Disabled")
	elseif string.len(argL) == 0 then
		ExRT.Options:Open()
		return
	end
	for _,mod in pairs(ExRT.Slash) do
		mod:slash(argL,arg)
	end
end
SLASH_exrtSlash1 = "/exrt"
SLASH_exrtSlash2 = "/rt"
SLASH_exrtSlash3 = "/raidtools"
SLASH_exrtSlash4 = "/exorsusraidtools"
SLASH_exrtSlash5 = "/ert"

---------------> Global addon frame <---------------

local reloadTimer = 0.1

ExRT.frame = CreateFrame("Frame")

local function loader(self,func)
	local isSuccessful, errorMsg = pcall(func,self)
	if not isSuccessful then
		C_Timer.After(0.01,function()
			error(errorMsg)	--Any other way to throw error for user, but continue loader?
		end)
	end
end

ExRT.frame:SetScript("OnEvent",function (self, event, ...)
	if event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...
		if prefix and ExRT.msg_prefix[prefix] and (channel=="RAID" or channel=="GUILD" or channel=="INSTANCE_CHAT" or channel=="PARTY" or (channel=="WHISPER" and (ExRT.F.UnitInGuild(sender) or sender == ExRT.SDB.charName)) or (message and (message:find("^version") or message:find("^needversion")))) then
			ExRT.F.GetExMsg(sender, strsplit("\t", message))
		end
	elseif event == "ADDON_LOADED" then
		local addonName = ...
		if addonName ~= GlobalAddonName then
			return
		end
		VExRT = VExRT or {}
		VExRT.Addon = VExRT.Addon or {}
		VExRT.Addon.Timer = VExRT.Addon.Timer or 0.1
		reloadTimer = VExRT.Addon.Timer

		if VExRT.Addon.IconMiniMapLeft and VExRT.Addon.IconMiniMapTop then
			ExRT.MiniMapIcon:ClearAllPoints()
			ExRT.MiniMapIcon:SetPoint("CENTER", VExRT.Addon.IconMiniMapLeft, VExRT.Addon.IconMiniMapTop)
		end
		
		if VExRT.Addon.IconMiniMapHide then 
			ExRT.MiniMapIcon:Hide() 
		end

		for prefix,_ in pairs(ExRT.msg_prefix) do
			C_ChatInfo.RegisterAddonMessagePrefix(prefix)
		end
		
		VExRT.Addon.Version = tonumber(VExRT.Addon.Version or "0")
		VExRT.Addon.PreVersion = VExRT.Addon.Version
		
		if not ExRT.F.FUNC_FILE_LOADED then	--Outdated for shadowlands, but not for classic
			print("|cffff0000Exorsus Raid Tools:|r after updating may work incorrectly, please restart your game client")
		end
		
		if ExRT.A.Profiles then
			ExRT.A.Profiles:ReselectProfileOnLoad()
		end
		
		ExRT.F.dprint("ADDON_LOADED event")
		ExRT.F.dprint("MODULES FIND",#ExRT.Modules)
		for i=1,#ExRT.Modules do
			loader(self,ExRT.Modules[i].main.ADDON_LOADED)

			ExRT.ModulesLoaded[i] = true
			
			ExRT.F.dprint("ADDON_LOADED",i,ExRT.Modules[i].name)
		end

		if not VExRT.Addon.DisableHideESC then
			tinsert(UISpecialFrames, "ExRTOptionsFrame")
		end

		VExRT.Addon.Version = ExRT.V
		
		ExRT.F.ScheduleTimer(function()
			ExRT.frame:SetScript("OnUpdate", ExRT.frame.OnUpdate)
		end,1)
		self:UnregisterEvent("ADDON_LOADED")

		ExRT.AddonLoaded = true

		return true	
	end
end)

do
	local encounterTime,isEncounter = 0,nil
	local ExRT_OnUpdate = ExRT.OnUpdate
	local ExRT_OnUpdate_Pos = {}
	local ExRT_OnUpdate_Len = 0
	local ListToUnreg = {}
	local frameElapsed = 0
	local function OnUpdate(self,elapsed)
		frameElapsed = frameElapsed + elapsed
		if frameElapsed > reloadTimer then
			if not isEncounter and IsEncounterInProgress() then
				isEncounter = true
				encounterTime = GetTime()
			elseif isEncounter and not IsEncounterInProgress() then
				isEncounter = nil
			end
			
			for i=1,ExRT_OnUpdate_Len do
				local d = ExRT_OnUpdate[i]
				d[1](d[2],frameElapsed)
			end
			frameElapsed = 0
		end
		
		--[[
		local start = debugprofilestop()
		local hasData = true
		
		while (debugprofilestop() - start < 16 and hasData) do
			hasData = false
			for func,c in pairs(ExRT.Coroutinies) do
				hasData = true
				if coroutine.status(c) ~= "dead" then
					local err = assert(coroutine.resume(c))
				else
					ExRT.Coroutinies[func] = nil
				end
			end
		end
		]]
	end
	ExRT.frame.OnUpdate = OnUpdate

	local function OnUpdate_Unreg(self,elapsed)
		for f,_ in pairs(ListToUnreg) do
			for j=1,#ExRT_OnUpdate do
				if ExRT_OnUpdate[j] == f then
					tremove(ExRT_OnUpdate, j)
					break
				end
			end		
		end
		wipe(ListToUnreg)
	
		ExRT_OnUpdate_Len = #ExRT_OnUpdate
	
		ExRT.frame:SetScript("OnUpdate",OnUpdate)
		OnUpdate(self,elapsed)	
	end


	function ExRT.mod:RegisterTimer()
		if ExRT_OnUpdate_Pos[self] then
			ExRT.mod.UnregisterTimer(self)
		end

		local pos = #ExRT_OnUpdate + 1
		ExRT_OnUpdate_Len = pos
		ExRT_OnUpdate[pos] = {self.timer,self}
		ExRT_OnUpdate_Pos[self] = ExRT_OnUpdate[pos]
	end
	
	function ExRT.mod:UnregisterTimer()
		local f = ExRT_OnUpdate_Pos[self]
		if f then
			ListToUnreg[ f ] = true
			ExRT.frame:SetScript("OnUpdate", OnUpdate_Unreg)
			ExRT_OnUpdate_Pos[self] = nil
		end
	end
	
	function ExRT.F.RaidInCombat()
		return isEncounter
	end
	
	function ExRT.F.GetEncounterTime()
		if isEncounter then
			return GetTime() - encounterTime
		end
	end
end

-- Заметка: сообщение в приват на другой сервер игнорируется

function ExRT.F.SendExMsg(prefix, msg, tochat, touser, addonPrefix)
	addonPrefix = addonPrefix or "EXRTADD"
	msg = msg or ""
	if tochat and not touser then
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, tochat)
	elseif tochat and touser then
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, tochat,touser)
	else
		local chat_type, playerName = ExRT.F.chatType()
		if chat_type == "WHISPER" and playerName == ExRT.SDB.charName then
			ExRT.F.GetExMsg(ExRT.SDB.charName, prefix, strsplit("\t", msg))
			return
		end
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, chat_type, playerName)
	end
end

function ExRT.F.GetExMsg(sender, prefix, ...)
	if prefix == "needversion" then
		ExRT.F.SendExMsg("version2", ExRT.V)
	elseif prefix == "needversiong" then
		ExRT.F.SendExMsg("version2", ExRT.V, "WHISPER", sender)
	elseif prefix == "version" then
		local msgver = ...
		print(sender..": "..msgver)
		ExRT.RaidVersions[sender] = msgver
	elseif prefix == "version2" then
		ExRT.RaidVersions[sender] = ...
		if isVersionCheckCallback then
			local msgver = ...
			print(sender..": "..msgver)
		end
	end
	for _,mod in pairs(ExRT.OnAddonMessage) do
		mod:addonMessage(sender, prefix, ...)
	end
end

_G["GExRT"] = ExRT
ExRT.frame:RegisterEvent("CHAT_MSG_ADDON")
ExRT.frame:RegisterEvent("ADDON_LOADED") 
