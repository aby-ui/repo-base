--	13.01.2023

local GlobalAddonName, MRT = ...

MRT.V = 4720
MRT.T = "R"

MRT.Slash = {}			--> функции вызова из коммандной строки
MRT.OnAddonMessage = {}	--> внутренние сообщения аддона
MRT.MiniMapMenu = {}		--> изменение меню кнопки на миникарте
MRT.Modules = {}		--> список всех модулей
MRT.ModulesLoaded = {}		--> список загруженных модулей [для Dev & Advanced]
MRT.ModulesOptions = {}
MRT.Classic = {}		--> функции для работы на классик клиенте
MRT.Debug = {}
MRT.RaidVersions = {}
MRT.Temp = {}

MRT.A = {}			--> ссылки на все модули

MRT.msg_prefix = {
	["EXRTADD"] = true,
}

MRT.L = {}			--> локализация
MRT.locale = GetLocale()

---------------> Version <---------------
do
	local version, buildVersion, buildDate, uiVersion = GetBuildInfo()
	
	MRT.clientUIinterface = uiVersion
	local expansion,majorPatch,minorPatch = (version or "5.0.0"):match("^(%d+)%.(%d+)%.(%d+)")
	MRT.clientVersion = (expansion or 0) * 10000 + (majorPatch or 0) * 100 + (minorPatch or 0)
end
if MRT.clientVersion < 20000 then
	MRT.isClassic = true
	MRT.T = "Classic"
elseif MRT.clientVersion < 30000 then
	MRT.isClassic = true
	MRT.isBC = true
	MRT.T = "BC"
elseif MRT.clientVersion < 40000 then
	MRT.isClassic = true
	MRT.isBC = true
	MRT.isLK = true
	MRT.T = "WotLK"
	if MRT.clientVersion >= 30401 then
		MRT.isLK1 = true
	end
elseif MRT.clientVersion < 50000 then
	MRT.isClassic = true
	MRT.isBC = true
	MRT.isLK = true
	MRT.isCata = true
	MRT.T = "Cataclysm"
elseif MRT.clientVersion >= 100000 then
	MRT.is10 = true
end
-------------> smart DB <-------------
MRT.SDB = {}

do
	local realmKey = GetRealmName() or ""
	local charName = UnitName'player' or ""
	realmKey = realmKey:gsub(" ","")
	MRT.SDB.realmKey = realmKey
	MRT.SDB.charKey = charName .. "-" .. realmKey
	MRT.SDB.charName = charName
	MRT.SDB.charLevel = UnitLevel'player'
end
-------------> global DB <------------
MRT.GDB = {}
-------------> upvalues <-------------
local pcall, unpack, pairs, coroutine, assert, next = pcall, unpack, pairs, coroutine, assert, next
local GetTime, IsEncounterInProgress, CombatLogGetCurrentEventInfo = GetTime, IsEncounterInProgress, CombatLogGetCurrentEventInfo
local SendAddonMessage, strsplit, tremove = C_ChatInfo.SendAddonMessage, strsplit, tremove
local C_Timer_NewTicker, debugprofilestop = C_Timer.NewTicker, debugprofilestop

if MRT.T == "D" then
	MRT.isDev = true
	pcall = function(func,...)
		func(...)
		return true
	end
end

MRT.NULL = {}
MRT.NULLfunc = function() end
---------------> Modules <---------------
MRT.mod = {}

do
	local function mod_LoadOptions(this)
		this:SetScript("OnShow",nil)
		if this.Load then
			this:Load()
		end
		this.Load = nil
		MRT.F.dprint(this.moduleName.."'s options loaded")
		this.isLoaded = true
	end
	local function mod_Options_CreateTitle(self)
		self.title = MRT.lib:Text(self,self.name,20):Point(15,6):Top()
	end
	function MRT:New(moduleName,localizatedName,disableOptions)
		if MRT.A[moduleName] then
			return false
		end
		local self = {}
		for k,v in pairs(MRT.mod) do self[k] = v end
		
		if not disableOptions then
			self.options = MRT.Options:Add(moduleName,localizatedName)

			self.options:Hide()
			self.options.moduleName = moduleName
			self.options.name = localizatedName or moduleName
			self.options:SetScript("OnShow",mod_LoadOptions)
			
			self.options.CreateTilte = mod_Options_CreateTitle
			
			MRT.ModulesOptions[#MRT.ModulesOptions + 1] = self.options
		end
		
		self.main = CreateFrame("Frame", nil)
		self.main.events = {}
		self.main:SetScript("OnEvent",MRT.mod.Event)
		
		self.main.ADDON_LOADED = MRT.NULLfunc	--Prevent error for modules without it, not really needed
		
		if MRT.T == "D" or MRT.T == "DU" then
			self.main.eventsCounter = {}
			self.main:HookScript("OnEvent",MRT.mod.HookEvent)
			
			self.main.name = moduleName
		end
		
		self.db = {}
		
		self.name = moduleName
		table.insert(MRT.Modules,self)
		MRT.A[moduleName] = self
		
		MRT.F.dprint("New module: "..moduleName)
		
		return self
	end
end

function MRT.mod:Event(event,...)
	return self[event](self,...)
end
if MRT.T == "DU" then
	local MRTDebug = MRT.Debug
	function MRT.mod:Event(event,...)
		local dt = debugprofilestop()
		self[event](self,...)
		MRTDebug[#MRTDebug+1] = {debugprofilestop() - dt,self.name,event}
	end
end

function MRT.mod:HookEvent(event)
	self.eventsCounter[event] = self.eventsCounter[event] and self.eventsCounter[event] + 1 or 1
end

local CLEUFrame = CreateFrame("Frame")
local CLEUList = {}
local CLEUModules = {}
local CLEUListLen = 0

CLEUFrame.CLEUList = CLEUList
CLEUFrame.CLEUModules = CLEUModules

local function CLEU_OnEvent()
	local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,
		val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13
				= CombatLogGetCurrentEventInfo()

	for i=1,CLEUListLen do
		CLEUList[i](timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13)
	end
end

local function CLEU_OnEvent_Recreate()
	for i=1,#CLEUList do CLEUList[i]=nil end
	CLEUListLen = 0
	for mod,func in pairs(CLEUModules) do
		CLEUListLen = CLEUListLen + 1
		CLEUList[CLEUListLen] = func
	end

	if CLEUListLen == 0 then
		CLEUFrame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end

	CLEUFrame:SetScript("OnEvent",CLEU_OnEvent)
	CLEU_OnEvent()
end


CLEUFrame:SetScript("OnEvent",CLEU_OnEvent_Recreate)
MRT.CLEUFrame = CLEUFrame

function MRT.mod:RegisterEvents(...)
	for i=1,select("#", ...) do
		local event = select(i,...)
		if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
			if not MRT.isClassic then
				self.main:RegisterEvent(event)
			else
				pcall(self.main.RegisterEvent,self.main,event)
			end
		elseif self.CLEUNotInList then
			if not self.CLEU then self.CLEU = CreateFrame("Frame") end
			self.CLEU:SetScript("OnEvent",self.main.COMBAT_LOG_EVENT_UNFILTERED)
			self.CLEU:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		else
			local func = self.main.COMBAT_LOG_EVENT_UNFILTERED
			if type(func) == "function" then
				CLEUModules[self] = func
				CLEUFrame:SetScript("OnEvent",CLEU_OnEvent_Recreate)
				CLEUFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			else
				error("MRT: "..self.name..": wrong CLEU function.")
			end
		end
		self.main.events[event] = true
		MRT.F.dprint(self.name,'RegisterEvent',event)
	end
end

function MRT.mod:UnregisterEvents(...)
	for i=1,select("#", ...) do
		local event = select(i,...)
		if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
			if not MRT.isClassic then
				self.main:UnregisterEvent(event)
			else
				pcall(self.main.UnregisterEvent,self.main,event)
			end
		elseif self.CLEUNotInList then
			if self.CLEU then
				self.CLEU:SetScript("OnEvent",nil)
				self.CLEU:UnregisterAllEvents()
			end
		else
			CLEUModules[self] = nil
			CLEUFrame:SetScript("OnEvent",CLEU_OnEvent_Recreate)
		end
		self.main.events[event] = nil
		MRT.F.dprint(self.name,'UnregisterEvent',event)
	end
end

function MRT.mod:RegisterUnitEvent(...)
	self.main:RegisterUnitEvent(...)
	local event = ...
	self.main.events[event] = true
	MRT.F.dprint(self.name,'RegisterUnitEvent',event)
end

function MRT.mod:RegisterSlash()
	MRT.Slash[self.name] = self
end

function MRT.mod:UnregisterSlash()
	MRT.Slash[self.name] = nil
end

function MRT.mod:RegisterAddonMessage()
	MRT.OnAddonMessage[self.name] = self
end

function MRT.mod:UnregisterAddonMessage()
	MRT.OnAddonMessage[self.name] = nil
end

function MRT.mod:RegisterMiniMapMenu()
	MRT.MiniMapMenu[self.name] = self
end

function MRT.mod:UnregisterMiniMapMenu()
	MRT.MiniMapMenu[self.name] = nil
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
	if not MRT.isClassic then
		petBattleTracker:RegisterEvent("PET_BATTLE_OPENING_START")
		petBattleTracker:RegisterEvent("PET_BATTLE_CLOSE")
	end
	function MRT.mod:RegisterHideOnPetBattle(frame)
		hideOnPetBattle[#hideOnPetBattle + 1] = frame
	end
end


MRT.Coroutinies = {}
function MRT.mod:AddCoroutine(func)
	local c = coroutine.create(func)
	MRT.Coroutinies[func] = c
	
	return c
end

function MRT.mod:GetCoroutine(func)
	return MRT.Coroutinies[func]
end

function MRT.mod:RemoveCoroutine(func)
	MRT.Coroutinies[func] = nil
end

---------------> Mods <---------------

MRT.F = {}
MRT.mds = MRT.F

-- Moved to Functions.lua

do
	local function TimerFunc(self)
		self.func(unpack(self.args))
	end
	function MRT.F.ScheduleTimer(func, delay, ...)
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
	function MRT.F.CancelTimer(self)
		if self then
			self:Cancel()
		end
	end
	function MRT.F.ScheduleETimer(self, func, delay, ...)
		MRT.F.CancelTimer(self)
		return MRT.F.ScheduleTimer(func, delay, ...)
	end
	
	MRT.F.NewTimer = MRT.F.ScheduleTimer
	MRT.F.Timer = MRT.F.ScheduleTimer
end

---------------> Data <---------------

MRT.F.defFont = ChatFontNormal:GetFont() --"Interface\\AddOns\\"..GlobalAddonName.."\\media\\skurri.ttf"
MRT.F.barImg = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar17.tga"
MRT.F.defBorder = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\border.tga"
MRT.F.textureList = {
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar6.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar9.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar16.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar17.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar19.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar24.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar24b.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar26.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar29.tga",
	"Interface\\AddOns\\"..GlobalAddonName.."\\media\\White.tga",
	[[Interface\TargetingFrame\UI-StatusBar]],
	[[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]],
	[[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
}
MRT.F.fontList = {
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\skurri.ttf",
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
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\TaurusNormal.ttf",
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\UbuntuMedium.ttf",
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\TelluralAlt.ttf",
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\Glametrix.otf",
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\FiraSansMedium.ttf",
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\alphapixels.ttf",
	--"Interface\\AddOns\\"..GlobalAddonName.."\\media\\ariblk.ttf",
}

if MRT.locale and MRT.locale:find("^zh") then		--China & Taiwan fix
	MRT.F.defFont = "Fonts\\ARHei.ttf"
elseif MRT.locale == "koKR" then			--Korea fix
	MRT.F.defFont = "Fonts\\2002.ttf"
end

----------> Version Checker <----------

local isVersionCheckCallback = nil
local function DisableVersionCheckCallback()
	isVersionCheckCallback = nil
end

-------------> Callbacks <-------------

local callbacks = {}
function MRT.F:RegisterCallback(eventName, func)
	if not callbacks[eventName] then
		callbacks[eventName] = {}
	end
	tinsert(callbacks[eventName], func)
end
function MRT.F:UnregisterCallback(eventName, func)
	if not callbacks[eventName] then
		return
	end
	for i=1,#callbacks[eventName] do
		if callbacks[eventName][i] == func then
			tremove(callbacks[eventName], i)
			break
		end
	end
end

local function CallbackErrorHandler(err)
	print ("Callback Error", err)
end

function MRT.F:FireCallback(eventName, ...)
	if not callbacks[eventName] then
		return
	end
	for _,func in pairs(callbacks[eventName]) do
		xpcall(func, CallbackErrorHandler, eventName, ...)
	end
end

---------------> Slash <---------------

SlashCmdList["mrtSlash"] = function (arg)
	local argL = strlower(arg)
	if argL == "icon" then
		VMRT.Addon.IconMiniMapHide = not VMRT.Addon.IconMiniMapHide
		if not VMRT.Addon.IconMiniMapHide then 
			MRT.MiniMapIcon:Show()
		else
			MRT.MiniMapIcon:Hide()
		end
	elseif argL == "getver" then
		MRT.F.SendExMsg("needversion","")
		isVersionCheckCallback = MRT.F.ScheduleETimer(isVersionCheckCallback, DisableVersionCheckCallback, 1.5)
	elseif argL == "getverg" then
		MRT.F.SendExMsg("needversiong","","GUILD")
		isVersionCheckCallback = MRT.F.ScheduleETimer(isVersionCheckCallback, DisableVersionCheckCallback, 1.5)
	elseif argL == "set" then
		MRT.Options:Open()
	elseif argL == "quit" then
		for mod,data in pairs(MRT.A) do
			data.main:UnregisterAllEvents()
			if data.CLEU then
				data.CLEU:UnregisterAllEvents()
			end
		end
		MRT.frame:UnregisterAllEvents()
		MRT.frame:SetScript("OnUpdate",nil)
		print("MRT Disabled")
	elseif string.len(argL) == 0 then
		MRT.Options:Open()
		return
	end
	for _,mod in pairs(MRT.Slash) do
		mod:slash(argL,arg)
	end
end
SLASH_mrtSlash1 = "/exrt"
SLASH_mrtSlash2 = "/rt"
SLASH_mrtSlash3 = "/raidtools"
SLASH_mrtSlash4 = "/methodraidtools"
SLASH_mrtSlash5 = "/ert"
SLASH_mrtSlash6 = "/mrt"

---------------> Global addon frame <---------------

local reloadTimer = 0.1

MRT.frame = CreateFrame("Frame")

local function loader(self,func)
	local isSuccessful, errorMsg = pcall(func,self)
	if not isSuccessful then
		C_Timer.After(0.01,function()
			error(errorMsg)	--Any other way to throw error for user, but continue loader?
		end)
	end
end

local migrateReplace
do
	local tr
	function migrateReplace(t)
		if not t then
			if tr then
				for i=1,#tr,2 do
					local t,k = tr[i],tr[i+1]
					local str = t[k]
					if str:find("AddOns[\\/]ExRT") then
						t[k] = str:gsub("(AddOns[\\/])ExRT","%1MRT")
					end
				end
				tr = nil
			end
		else
			for k,v in pairs(t) do
				local vt = type(v)
				if vt == "table" then
					migrateReplace(v)
				elseif vt == "string" then
					if not tr then
						tr = {}
					end
					tr[#tr+1] = t
					tr[#tr+1] = k
				end
			end
		end
	end
end

MRT.frame:SetScript("OnEvent",function (self, event, ...)
	if event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...
		if prefix and MRT.msg_prefix[prefix] and (channel=="RAID" or channel=="GUILD" or channel=="INSTANCE_CHAT" or channel=="PARTY" or (channel=="WHISPER" and (MRT.F.UnitInGuild(sender) or sender == MRT.SDB.charName)) or (message and (message:find("^version") or message:find("^needversion")))) then
			MRT.F.GetExMsg(sender, strsplit("\t", message))
		end
	elseif event == "ADDON_LOADED" then
		local addonName = ...
		if addonName ~= GlobalAddonName then
			return
		end
		VMRT = VMRT or {}
		VMRT.Addon = VMRT.Addon or {}

		if not VMRT.Addon.migrateMRT and VExRT and VExRT.Addon then
			VMRT = VExRT

			migrateReplace(VMRT)
			migrateReplace()

			VMRT.Addon = VMRT.Addon or {}
			VMRT.Addon.migrateMRT = true
		end
		VExRT = nil
		VExRT = setmetatable({}, {
			__index = VMRT,
			__newindex = VMRT,
		})
		

		VMRT.Addon.Timer = VMRT.Addon.Timer or 0.1
		reloadTimer = VMRT.Addon.Timer

		if VMRT.Addon.IconMiniMapLeft and VMRT.Addon.IconMiniMapTop then
			MRT.MiniMapIcon:ClearAllPoints()
			MRT.MiniMapIcon:SetPoint("CENTER", VMRT.Addon.IconMiniMapLeft, VMRT.Addon.IconMiniMapTop)
		end
		
		if VMRT.Addon.IconMiniMapHide then 
			MRT.MiniMapIcon:Hide() 
		end

		for prefix,_ in pairs(MRT.msg_prefix) do
			C_ChatInfo.RegisterAddonMessagePrefix(prefix)
		end
		
		VMRT.Addon.Version = tonumber(VMRT.Addon.Version or "0")
		VMRT.Addon.PreVersion = VMRT.Addon.Version
		
		if MRT.A.Profiles then
			MRT.A.Profiles:ReselectProfileOnLoad()
		end
		
		MRT.F.dprint("ADDON_LOADED event")
		MRT.F.dprint("MODULES FIND",#MRT.Modules)
		for i=1,#MRT.Modules do
			loader(self,MRT.Modules[i].main.ADDON_LOADED)

			MRT.ModulesLoaded[i] = true
			
			MRT.F.dprint("ADDON_LOADED",i,MRT.Modules[i].name)
		end

		if not VMRT.Addon.DisableHideESC then
			tinsert(UISpecialFrames, "MRTOptionsFrame")
		end

		VMRT.Addon.Version = MRT.V
		
		MRT.F.ScheduleTimer(function()
			MRT.frame:SetScript("OnUpdate", MRT.frame.OnUpdate_Recreate)
		end,1)
		self:UnregisterEvent("ADDON_LOADED")

		MRT.AddonLoaded = true

		return true	
	end
end)

do
	local encounterTime,isEncounter = 0,nil
	local OnUpdate_Funcs = {}
	local OnUpdate_Modules = {}

	local frameElapsed = 0
	local function OnUpdate(self,elapsed)
		frameElapsed = frameElapsed + elapsed
		if frameElapsed >= 0.1 then
			if not isEncounter and IsEncounterInProgress() then
				isEncounter = true
				encounterTime = GetTime()
			elseif isEncounter and not IsEncounterInProgress() then
				isEncounter = nil
			end
			
			for mod, func in next, OnUpdate_Funcs do
				func(mod, frameElapsed)
			end
			frameElapsed = 0
		end
		
		--[[
		local start = debugprofilestop()
		local hasData = true
		
		while (debugprofilestop() - start < 16 and hasData) do
			hasData = false
			for func,c in pairs(MRT.Coroutinies) do
				hasData = true
				if coroutine.status(c) ~= "dead" then
					local err = assert(coroutine.resume(c))
				else
					MRT.Coroutinies[func] = nil
				end
			end
		end
		]]
	end

	local function OnUpdate_Recreate(self,elapsed)
		for k in pairs(OnUpdate_Funcs) do OnUpdate_Funcs[k]=nil end
		for mod,func in pairs(OnUpdate_Modules) do
			OnUpdate_Funcs[mod] = func
		end
		
		self:SetScript("OnUpdate", OnUpdate)
		OnUpdate(self,elapsed)
	end

	MRT.frame.OnUpdate = OnUpdate
	MRT.frame.OnUpdate_Recreate = OnUpdate_Recreate
	MRT.frame.OnUpdate_Funcs = OnUpdate_Funcs
	MRT.frame.OnUpdate_Modules = OnUpdate_Modules

	function MRT.mod:RegisterTimer()
		local func = self.timer
		if type(func) ~= "function" then
			error("MRT: "..self.name..": wrong timer function.")
			return
		end
		OnUpdate_Modules[self] = func

		MRT.frame:SetScript("OnUpdate", OnUpdate_Recreate)
	end
	
	function MRT.mod:UnregisterTimer()
		OnUpdate_Modules[self] = nil

		MRT.frame:SetScript("OnUpdate", OnUpdate_Recreate)
	end
	
	function MRT.F.RaidInCombat()
		return isEncounter
	end
	
	function MRT.F.GetEncounterTime()
		if isEncounter then
			return GetTime() - encounterTime
		end
	end
end

--temp fix
local sendPending = {}
local sendPrev = 0
local sendTmr
local _SendAddonMessage = SendAddonMessage
local SEND_LIMIT = 10
local sendLimit = SEND_LIMIT
local function send(self)
	if self then
		sendTmr = nil
	end
	local t = debugprofilestop()
	sendLimit = sendLimit + floor((t - sendPrev)/1000)
	if sendLimit > SEND_LIMIT then
		sendLimit = SEND_LIMIT
	end
	if sendLimit <= 0 then
		if not sendTmr then
			sendTmr = C_Timer.NewTimer(0.5, send)
		end
		return
	end
	for i=1,#sendPending do
		if sendLimit > 0 then
			sendLimit = sendLimit - 1
			_SendAddonMessage(unpack(sendPending[1]))
			tremove(sendPending, 1)
			sendPrev = debugprofilestop()
		else
			if not sendTmr then
				sendTmr = C_Timer.NewTimer(0.5, send)
			end
			return
		end
	end
end
SendAddonMessage = function (...)
	sendPending[#sendPending+1] = {...}
	send()
end

function MRT.F.SendExMsg(prefix, msg, tochat, touser, addonPrefix)
	addonPrefix = addonPrefix or "EXRTADD"
	msg = msg or ""
	if tochat and not touser then
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, tochat)
	elseif tochat and touser then
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, tochat,touser)
	else
		local chat_type, playerName = MRT.F.chatType()
		if chat_type == "WHISPER" and playerName == MRT.SDB.charName then
			MRT.F.GetExMsg(MRT.SDB.charName, prefix, strsplit("\t", msg))
			return
		end
		SendAddonMessage(addonPrefix, prefix .. "\t" .. msg, chat_type, playerName)
	end
end


function MRT.F.GetExMsg(sender, prefix, ...)
	if prefix == "needversion" then
		MRT.F.SendExMsg("version2", MRT.V)
	elseif prefix == "needversiong" then
		MRT.F.SendExMsg("version2", MRT.V, "WHISPER", sender)
	elseif prefix == "version" then
		local msgver = ...
		print(sender..": "..msgver)
		MRT.RaidVersions[sender] = msgver
	elseif prefix == "version2" then
		MRT.RaidVersions[sender] = ...
		if isVersionCheckCallback then
			local msgver = ...
			print(sender..": "..msgver)
		end
	end
	for _,mod in pairs(MRT.OnAddonMessage) do
		mod:addonMessage(sender, prefix, ...)
	end
end

_G["GExRT"] = MRT
_G["GMRT"] = MRT
MRT.frame:RegisterEvent("CHAT_MSG_ADDON")
MRT.frame:RegisterEvent("ADDON_LOADED") 
