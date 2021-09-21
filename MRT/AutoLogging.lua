local GlobalAddonName, ExRT = ...

local VMRT = nil

local module = ExRT:New("AutoLogging",ExRT.L.Logging)
local ELib,L = ExRT.lib,ExRT.L

module.db.minRaidMapID = 1861
module.db.minPartyMapID = 1754

module.db.mapsToLog = {}
module.db.mapsToLog_5ppl = {
	[1594] = true,	--MOTHERLODE
}

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.LoggingEnable,VMRT.Logging.enabled):Point(15,-30):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.enabled = true
			module:Enable()
		else
			VMRT.Logging.enabled = nil
			module:Disable()
		end
	end)
		
	self.shtml1 = ELib:Text(self," -"..L.S_ZoneT27SoD.."\n -"..L.S_ZoneT26CastleNathria.."\n -"..L.S_ZoneT25Nyalotha.."\n -"..L.S_ZoneT24Eternal.."\n -"..L.S_ZoneT23Storms.."\n -"..L.S_ZoneT23Siege.."\n -"..L.S_ZoneT22Uldir,12):Size(620,0):Point("TOP",0,-65):Top()

	self.shtml2 = ELib:Text(self,L.LoggingHelp1,12):Size(650,0):Point("TOP",self.shtml1,"BOTTOM",0,-15):Top()
	
	self.enable3ppScenario = ELib:Check(self,SCENARIOS,VMRT.Logging.enable3ppBFA):Point("TOP",self.shtml2,"BOTTOM",0,-15):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.enable3ppBFA = true
		else
			VMRT.Logging.enable3ppBFA = nil
		end
	end)

	self.enable5ppLegion = ELib:Check(self,DUNGEONS..": "..(UnitLevel'player'>50 and EXPANSION_NAME8 or EXPANSION_NAME7).." ("..PLAYER_DIFFICULTY6..", "..PLAYER_DIFFICULTY6.."+)",VMRT.Logging.enable5ppLegion):Point("TOP",self.enable3ppScenario,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.enable5ppLegion = true
		else
			VMRT.Logging.enable5ppLegion = nil
		end
	end)
	
	self.raidMythic = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY6,not VMRT.Logging.disableMythic):Point("TOP",self.enable5ppLegion,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.disableMythic = nil
		else
			VMRT.Logging.disableMythic = true
		end
	end)
	
	self.raidHeroic = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY2,not VMRT.Logging.disableHeroic):Point("TOP",self.raidMythic,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.disableHeroic = nil
		else
			VMRT.Logging.disableHeroic = true
		end
	end)
	
	self.raidNormal = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY1,not VMRT.Logging.disableNormal):Point("TOP",self.raidHeroic,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.disableNormal = nil
		else
			VMRT.Logging.disableNormal = true
		end
	end)
	
	self.raidLFR = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY3,VMRT.Logging.enableLFR):Point("TOP",self.raidNormal,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.enableLFR = true
		else
			VMRT.Logging.enableLFR = nil
		end
	end)

	self.torghast = ELib:Check(self,GetDifficultyInfo and GetDifficultyInfo(167) or "Torghast",VMRT.Logging.enableTorghast):Point("TOP",self.raidLFR,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.Logging.enableTorghast = true
		else
			VMRT.Logging.enableTorghast = nil
		end
	end)

	self.arena = ELib:Check(self,ARENA or "Arena",VMRT.Logging.enableArena):Point("TOP", ExRT.isClassic and self.shtml2 or self.torghast,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self)
		if self:GetChecked() then
			VMRT.Logging.enableArena = true
		else
			VMRT.Logging.enableArena = nil
		end
	end)

	self.classic5pplHC = ELib:Check(self,"5 ppl Dungeon Heroic",VMRT.Logging.classic5pplHC):Point("TOP", self.arena,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self)
		if self:GetChecked() then
			VMRT.Logging.enableclassic5pplHC = true
		else
			VMRT.Logging.enableclassic5pplHC = nil
		end
	end):Shown(ExRT.isBC)

	self.classic5pplNormal = ELib:Check(self,"5 ppl Dungeon Normal",VMRT.Logging.enableclassic5pplNormal):Point("TOP", self.classic5pplHC,"BOTTOM",0,-5):Point("LEFT",self,15,0):OnClick(function(self)
		if self:GetChecked() then
			VMRT.Logging.enableclassic5pplNormal = true
		else
			VMRT.Logging.enableclassic5pplNormal = nil
		end
	end):Shown(ExRT.isBC)

	if ExRT.isClassic then
		self.shtml1:SetText(RAID)
		self.enable3ppScenario:Hide()
		self.enable5ppLegion:Hide()
		self.raidMythic:Hide()
		self.raidHeroic:Hide()
		self.raidNormal:Hide()
		self.raidLFR:Hide()
		self.torghast:Hide()
	end
end


function module:Enable()
	module:RegisterEvents('ZONE_CHANGED_NEW_AREA','CHALLENGE_MODE_START')
	if ExRT.isClassic then
		module:RegisterEvents('LOADING_SCREEN_DISABLED')
	end
	module.main:ZONE_CHANGED_NEW_AREA()
end
function module:Disable()
	module:UnregisterEvents('ZONE_CHANGED_NEW_AREA','CHALLENGE_MODE_START')
	if ExRT.isClassic then
		module:UnregisterEvents('LOADING_SCREEN_DISABLED')
	end
	module.main:ZONE_CHANGED_NEW_AREA()
end


function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.Logging = VMRT.Logging or {}

	if VMRT.Logging.enabled then
		module:Enable()
	end
end

local function GetCurrentMapForLogging()
	if VMRT.Logging.enabled then
		local _, zoneType, difficulty, _, maxPlayers, _, _, mapID = GetInstanceInfo()
		if difficulty == 7 or difficulty == 17 then
			if VMRT.Logging.enableLFR then
				return true
			else
				return false
			end
		elseif mapID and module.db.mapsToLog[mapID] then
			return true 
		elseif ExRT.isClassic and zoneType == 'raid' then
			return true 
		elseif zoneType == 'raid' and (tonumber(mapID) and mapID >= module.db.minRaidMapID) and ((difficulty == 16 and not VMRT.Logging.disableMythic) or (difficulty == 15 and not VMRT.Logging.disableHeroic) or (difficulty == 14 and not VMRT.Logging.disableNormal) or (difficulty ~= 14 and difficulty ~= 15 and difficulty ~= 16)) then
			return true
		elseif VMRT.Logging.enable5ppLegion and (difficulty == 8 or difficulty == 23) and (tonumber(mapID) and (mapID >= module.db.minPartyMapID or module.db.mapsToLog_5ppl[mapID])) then
			return true
		elseif VMRT.Logging.enableTorghast and difficulty == 167 then
			return true
		elseif VMRT.Logging.enable3ppBFA and zoneType == 'scenario' and (maxPlayers or 0) > 1 and (tonumber(mapID) and mapID >= module.db.minPartyMapID) then
			return true
		elseif VMRT.Logging.enableArena and (zoneType == "arena" or zoneType == "ratedarena") then
			return true
		elseif ExRT.isBC and VMRT.Logging.enableclassic5pplHC and (difficulty == 174) then
			return true
		elseif ExRT.isBC and VMRT.Logging.enableclassic5pplNormal and (difficulty == 173) then
			return true
		end
	end
	return false
end
module.GetCurrentMapForLogging = GetCurrentMapForLogging

local prevZone = false
local function ZoneNewFunction()
	local zoneForLogging = GetCurrentMapForLogging()
	if zoneForLogging then
		LoggingCombat(true)
		print('==================')
		print(L.LoggingStart)
		print('==================')
	elseif prevZone and LoggingCombat() then
		LoggingCombat(false)
		print('==================')
		print(L.LoggingEnd)
		print('==================')
	end
	prevZone = zoneForLogging
end

function module.main:ZONE_CHANGED_NEW_AREA()
	ExRT.F.ScheduleTimer(ZoneNewFunction, 2)
end
module.main.LOADING_SCREEN_DISABLED = module.main.ZONE_CHANGED_NEW_AREA

function module.main:CHALLENGE_MODE_START()
	ExRT.F.ScheduleTimer(ZoneNewFunction, 1)
end