local GlobalAddonName, ExRT = ...

local VMRT = nil

local module = ExRT:New("WhoPulled",ExRT.L.WhoPulled)
local ELib,L = ExRT.lib,ExRT.L

local UnitAffectingCombat, string_find = UnitAffectingCombat, string.find

module.db.lastPull = nil
module.db.lastBossName = nil
module.db.whoPulled = nil
module.db.isPet = nil

function module.options:Load()
	self:CreateTilte()
	
	local function UpdatePage()
		local pull = "-"
		if module.db.lastPull then
			pull = date("%d/%m/%Y %H:%M:%S",module.db.lastPull).." "..(module.db.lastBossName or "")
		end
	  	self.lastPull:SetText(L.WhoPulledlastPull..": "..pull)
	  	if module.db.isPet then
	  		self.name:SetText((module.db.whoPulled or "").." ("..PET.." "..module.db.isPet..")")
	  	else
	  		self.name:SetText(module.db.whoPulled or "")
	  	end
	end
	
	self.lastPull = ELib:Text(self,"",12):Point("TOP",0,-50):Top():Color()
	self.name = ELib:Text(self,"",18):Point("TOP",0,-65):Top():Color()
	
	self.chatCheck = ELib:Check(self,L.WhoPulledChatOption,not VMRT.WhoPulled.DisableChat):Point("BOTTOMLEFT",10,40):OnClick(function(self)
		VMRT.WhoPulled.DisableChat = not self:GetChecked()
	end)
	
	function self:OnShow()
		UpdatePage()
	end
end


function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.WhoPulled = VMRT.WhoPulled or {}

	module:RegisterEvents('ENCOUNTER_START')
	module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
	module.main:ZONE_CHANGED_NEW_AREA()
end

local affectedCombat,affectedCombatPetOwner = nil

local function WhoPulledFetch()
	if affectedCombat then
		module.db.whoPulled = affectedCombat
		if affectedCombatPetOwner then
			module.db.isPet = affectedCombatPetOwner
		end
		if not VMRT.WhoPulled.DisableChat then
			local _,class = UnitClass(affectedCombatPetOwner or affectedCombat)
			local color = ExRT.F.classColor(class)
		
			print("|cffffff00MRT|r "..L.WhoPulled..": |c"..color..affectedCombat..(affectedCombatPetOwner and " ["..affectedCombatPetOwner.."]" or ""))
		end
		return true
	end
end

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	module.db.whoPulled = nil
	module.db.isPet = nil
	module.db.lastPull = time()
	module.db.lastBossName = encounterName
	if not WhoPulledFetch() then
		C_Timer.After(1,WhoPulledFetch)
	end
end

local function ZoneNewFunction()
	local _, zoneType, difficulty, _, _, _, _, mapID = GetInstanceInfo()
	if zoneType == "raid" or zoneType == "party" then
		module:RegisterEvents('UNIT_FLAGS','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
	else
		module:UnregisterEvents('UNIT_FLAGS','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
	end
end

function module.main:ZONE_CHANGED_NEW_AREA()
	ExRT.F.ScheduleTimer(ZoneNewFunction, 2)
end

local function ClearAffectedCombat()
	affectedCombat = nil
	affectedCombatPetOwner = nil
end

function module.main:UNIT_FLAGS(unit)
	if not affectedCombat and UnitAffectingCombat(unit) and (string_find(unit,"^raid") or unit == "player" or string_find(unit,"^party")) then
		affectedCombat = UnitName(unit)
		if string_find(unit,"pet") then
			local ownerUnitID = unit:gsub("pet","")
			affectedCombatPetOwner = UnitName(ownerUnitID)
		end
		
		--print('Combat',affectedCombat)
		C_Timer.After(3,ClearAffectedCombat)
	end
end

function module.main:PLAYER_REGEN_DISABLED(unit)
	module:UnregisterEvents('UNIT_FLAGS')
end

function module.main:PLAYER_REGEN_ENABLED(unit)
	ZoneNewFunction()
end