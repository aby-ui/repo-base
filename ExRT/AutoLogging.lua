local GlobalAddonName, ExRT = ...

local VExRT = nil

local module = ExRT.mod:New("AutoLogging",ExRT.L.Logging,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.minRaidMapID = 1520
module.db.minPartyMapID = 1456

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.LoggingEnable,VExRT.Logging.enabled):Point(5,-30):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.enabled = true
			module:Enable()
		else
			VExRT.Logging.enabled = nil
			module:Disable()
		end
	end)
		
	self.shtml1 = ELib:Text(self," -"..L.S_ZoneT22Uldir.."\n -"..L.S_ZoneT23Siege.."\n -"..L.S_ZoneT23Storms.."\n -"..L.S_ZoneT19Nightmare.."\n -"..L.S_ZoneT19ToV.."\n -"..L.S_ZoneT19Suramar.."\n -"..L.S_ZoneT20ToS.."\n -"..L.S_ZoneT21A,12):Size(620,0):Point("TOP",0,-65):Top()

	self.shtml2 = ELib:Text(self,L.LoggingHelp1,12):Size(650,0):Point("TOP",self.shtml1,"BOTTOM",0,-15):Top()
	
	self.enable3ppScenario = ELib:Check(self,SCENARIOS,VExRT.Logging.enable3ppBFA):Point("TOP",self.shtml2,"BOTTOM",0,-15):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.enable3ppBFA = true
		else
			VExRT.Logging.enable3ppBFA = nil
		end
	end)

	self.enable5ppLegion = ELib:Check(self,DUNGEONS..": "..EXPANSION_NAME7.." ("..PLAYER_DIFFICULTY6..", "..PLAYER_DIFFICULTY6.."+)",VExRT.Logging.enable5ppLegion):Point("TOP",self.enable3ppScenario,"BOTTOM",0,-5):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.enable5ppLegion = true
		else
			VExRT.Logging.enable5ppLegion = nil
		end
	end)
	
	self.raidMythic = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY6,not VExRT.Logging.disableMythic):Point("TOP",self.enable5ppLegion,"BOTTOM",0,-5):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.disableMythic = nil
		else
			VExRT.Logging.disableMythic = true
		end
	end)
	
	self.raidHeroic = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY2,not VExRT.Logging.disableHeroic):Point("TOP",self.raidMythic,"BOTTOM",0,-5):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.disableHeroic = nil
		else
			VExRT.Logging.disableHeroic = true
		end
	end)
	
	self.raidNormal = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY1,not VExRT.Logging.disableNormal):Point("TOP",self.raidHeroic,"BOTTOM",0,-5):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.disableNormal = nil
		else
			VExRT.Logging.disableNormal = true
		end
	end)
	
	self.raidLFR = ELib:Check(self,RAID..": "..PLAYER_DIFFICULTY3,VExRT.Logging.enableLFR):Point("TOP",self.raidNormal,"BOTTOM",0,-5):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.enableLFR = true
		else
			VExRT.Logging.enableLFR = nil
		end
	end)

	if ExRT.isClassic then
		self.shtml1:SetText(RAID)
		self.enable3ppScenario:Hide()
		self.enable5ppLegion:Hide()
		self.raidMythic:Hide()
		self.raidHeroic:Hide()
		self.raidNormal:Hide()
		self.raidLFR:Hide()
	end
end


function module:Enable()
	module:RegisterEvents('ZONE_CHANGED_NEW_AREA','CHALLENGE_MODE_START')
	module.main:ZONE_CHANGED_NEW_AREA()
end
function module:Disable()
	module:UnregisterEvents('ZONE_CHANGED_NEW_AREA','CHALLENGE_MODE_START')
	module.main:ZONE_CHANGED_NEW_AREA()
end


function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Logging = VExRT.Logging or {}

	if VExRT.Logging.enabled then
		module:Enable()
	end
end

local function GetCurrentMapForLogging()
	if VExRT.Logging.enabled then
		local _, zoneType, difficulty, _, maxPlayers, _, _, mapID = GetInstanceInfo()
		if difficulty == 7 or difficulty == 17 then
			if VExRT.Logging.enableLFR then
				return true
			else
				return false
			end
		elseif ExRT.isClassic and zoneType == 'raid' then
			return true 
		elseif zoneType == 'raid' and (tonumber(mapID) and mapID >= module.db.minRaidMapID) and ((difficulty == 16 and not VExRT.Logging.disableMythic) or (difficulty == 15 and not VExRT.Logging.disableHeroic) or (difficulty == 14 and not VExRT.Logging.disableNormal) or (difficulty ~= 14 and difficulty ~= 15 and difficulty ~= 16)) then
			return true
		elseif VExRT.Logging.enable5ppLegion and (difficulty == 8 or difficulty == 23) and (tonumber(mapID) and mapID >= module.db.minPartyMapID) then
			return true
		elseif VExRT.Logging.enable3ppBFA and zoneType == 'scenario' and (maxPlayers or 0) > 1 and (tonumber(mapID) and mapID >= module.db.minPartyMapID) then
			return true
		end
	end
	return false
end

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
function module.main:CHALLENGE_MODE_START()
	ExRT.F.ScheduleTimer(ZoneNewFunction, 1)
end