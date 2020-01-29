local GlobalAddonName, ExRT = ...

local max = max
local ceil = ceil
local UnitCombatlogname = ExRT.F.UnitCombatlogname
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetTotalAbsorbs = ExRT.isClassic and ExRT.NULLfunc or UnitGetTotalAbsorbs
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitGUID = UnitGUID
local UnitName = UnitName
local UnitAura = UnitAura
local AntiSpam = ExRT.F.AntiSpam
local GetUnitInfoByUnitFlag = ExRT.F.GetUnitInfoByUnitFlag
local UnitInRaid = UnitInRaid
local UnitIsPlayerOrPet = ExRT.F.UnitIsPlayerOrPet
local GUIDtoID = ExRT.F.GUIDtoID
local GetUnitTypeByGUID = ExRT.F.GetUnitTypeByGUID
local UnitIsFeignDeath = UnitIsFeignDeath
local pairs = pairs
local GetTime = GetTime
local UnitIsFriendlyByUnitFlag = ExRT.F.UnitIsFriendlyByUnitFlag
local wipe = wipe
local bit_band = bit.band
local tremove = tremove
local strsplit = strsplit
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local type = type
local UnitGroupRolesAssigned = ExRT.isClassic and ExRT.NULLfunc or UnitGroupRolesAssigned

local VExRT = nil

local module = ExRT:New("BossWatcher",ExRT.L.BossWatcher)
local ELib,L = ExRT.lib,ExRT.L

module.db.data = {}

module.db.nowNum = 1
local fightData,guidData,graphData,reactionData,segmentsData = nil

module.db.lastFightID = 0
module.db.timeFix = nil

module.db.spellsSchool = {}
local spellsSchool = module.db.spellsSchool

local deathLog = {}
module.db.deathLog = deathLog

local raidGUIDs = {}

local damageTakenLog = {}
module.db.damageTakenLog = damageTakenLog

local spellFix_LotM = {}
local spellFix_SM = {}

module.db.raidTargets = {
	[0x1] = 1,
	[0x2] = 2,
	[0x4] = 3,
	[0x8] = 4,
	[0x10] = 5,
	[0x20] = 6,
	[0x40] = 7,
	[0x80] = 8,
}
module.db.energyLocale = {
	[0] = "|cff69ccf0"..L.BossWatcherEnergyType0,
	[1] = "|cffedc294"..L.BossWatcherEnergyType1,
	[2] = "|cffd1fa99"..L.BossWatcherEnergyType2,
	[3] = "|cffffff8f"..L.BossWatcherEnergyType3,
	[4] = "|cfffff569"..L.BossWatcherEnergyType4,
	[5] = "|cffeb4561"..L.BossWatcherEnergyType5,
	[6] = "|cffeb4561"..L.BossWatcherEnergyType6,
	[7] = "|cff9482c9"..L.BossWatcherEnergyType7,
	[8] = "|cff"..format("%02x%02x%02x",113,0,197)..L.BossWatcherEnergyType8,
	[9] = "|cffffb3e0"..L.BossWatcherEnergyType9,
	[10] = "|cffffffff"..L.BossWatcherEnergyType10,
	[11] = "|cff"..format("%02x%02x%02x",0,143,255)..L.BossWatcherEnergyType11,
	[12] = "|cff4DbB98"..L.BossWatcherEnergyType12,
	[13] = "|cff"..format("%02x%02x%02x",51,0,102)..L.BossWatcherEnergyType13,
	[16] = "|cff"..format("%02x%02x%02x",0,255,255)..L.BossWatcherEnergyType16,
	[17] = "|cff"..format("%02x%02x%02x",209,76,223)..L.BossWatcherEnergyType17,
	[18] = "|cff"..format("%02x%02x%02x",255,147,0)..L.BossWatcherEnergyType18,
}

module.db.energyPerClass = {
	--class		--for all	--for player
	["WARRIOR"] = 	{{1,10},	{1,10}},
	["PALADIN"] = 	{{0,10},	{0,9,10}},
	["HUNTER"] = 	{{2,10},	{2,10}},
	["ROGUE"] = 	{{3,10},	{2,4,10}},
	["PRIEST"] = 	{{0,10},	{0,10,13}},
	["DEATHKNIGHT"]={{6,10},	{5,6,10}},
	["SHAMAN"] = 	{{0,10},	{0,10,11}},
	["MAGE"] = 	{{0,10},	{0,10,16}},
	["WARLOCK"] = 	{{0,10},	{0,10,7,14,15}},
	["MONK"] = 	{{0,3,10},	{0,3,10,12}},
	["DRUID"] = 	{{0,1,3,10},	{0,3,4,8,10}},
	["DEMONHUNTER"]={{0,17,18,10},	{0,17,18,10}},
	["NO"] = 	{{0,1,2,3,6,10},{0,1,2,3,6,10,5,7,8,9,11,12,13,14,15,16,17,18}},
	["ALL"] =	{{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25},{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}},
}
local energyPerClass = module.db.energyPerClass

module.db.schoolsDefault = {0x1,0x2,0x4,0x8,0x10,0x20,0x40}
module.db.schoolsColors = {
	[SCHOOL_MASK_NONE]	= {r=.8,g=.8,b=.8},
	[SCHOOL_MASK_PHYSICAL]	= {r=1,g=.64,b=.19},
	[SCHOOL_MASK_HOLY] 	= {r=1,g=1,b=.56},
	[SCHOOL_MASK_FIRE] 	= {r=.92,g=.27,b=.38},
	[SCHOOL_MASK_NATURE] 	= {r=.6,g=1,b=.4},	--r=.82,g=.98,b=.6
	[SCHOOL_MASK_FROST] 	= {r=.29,g=.50,b=1},
	[SCHOOL_MASK_SHADOW] 	= {r=.72,g=.66,b=.94},
	[SCHOOL_MASK_ARCANE] 	= {r=.56,g=.95,b=1},
	
	[0x1C] = {r=1,g=.3,b=1},	--Elemental
	[0x7C] = {r=.6,g=0,b=0},	--Chromatic
	[0x7E] = {r=1,g=0,b=0},		--Magic
	[0x7F] = {r=.25,g=.25,b=.25},	--Chaos
}
module.db.schoolsColorsGradient = {
	[0x3] = {SCHOOL_MASK_HOLY,SCHOOL_MASK_PHYSICAL},
	[0x5] = {SCHOOL_MASK_FIRE,SCHOOL_MASK_PHYSICAL},
	[0x6] = {SCHOOL_MASK_FIRE,SCHOOL_MASK_HOLY},
	[0x9] = {SCHOOL_MASK_NATURE,SCHOOL_MASK_PHYSICAL},
	[0xA] = {SCHOOL_MASK_NATURE,SCHOOL_MASK_HOLY},
	[0xC] = {SCHOOL_MASK_NATURE,SCHOOL_MASK_FIRE},
	[0x11] = {SCHOOL_MASK_FROST,SCHOOL_MASK_PHYSICAL},
	[0x12] = {SCHOOL_MASK_FROST,SCHOOL_MASK_HOLY},
	[0x14] = {SCHOOL_MASK_FROST,SCHOOL_MASK_FIRE},
	[0x18] = {SCHOOL_MASK_FROST,SCHOOL_MASK_NATURE},
	[0x21] = {SCHOOL_MASK_SHADOW,SCHOOL_MASK_PHYSICAL},
	[0x22] = {SCHOOL_MASK_SHADOW,SCHOOL_MASK_HOLY},
	[0x24] = {SCHOOL_MASK_SHADOW,SCHOOL_MASK_FIRE},
	[0x28] = {SCHOOL_MASK_SHADOW,SCHOOL_MASK_NATURE},
	[0x30] = {SCHOOL_MASK_SHADOW,SCHOOL_MASK_FROST},
	[0x41] = {SCHOOL_MASK_ARCANE,SCHOOL_MASK_PHYSICAL},
	[0x42] = {SCHOOL_MASK_ARCANE,SCHOOL_MASK_HOLY},
	[0x44] = {SCHOOL_MASK_ARCANE,SCHOOL_MASK_FIRE},
	[0x48] = {SCHOOL_MASK_ARCANE,SCHOOL_MASK_NATURE},
	[0x50] = {SCHOOL_MASK_ARCANE,SCHOOL_MASK_FROST},
	[0x60] = {SCHOOL_MASK_ARCANE,SCHOOL_MASK_SHADOW},
}
module.db.schoolsNames = {
	[SCHOOL_MASK_NONE]	= L.BossWatcherSchoolUnknown,
	[SCHOOL_MASK_PHYSICAL]	= L.BossWatcherSchoolPhysical,
	[SCHOOL_MASK_HOLY] 	= L.BossWatcherSchoolHoly,
	[SCHOOL_MASK_FIRE] 	= L.BossWatcherSchoolFire,
	[SCHOOL_MASK_NATURE] 	= L.BossWatcherSchoolNature,
	[SCHOOL_MASK_FROST] 	= L.BossWatcherSchoolFrost,
	[SCHOOL_MASK_SHADOW] 	= L.BossWatcherSchoolShadow,
	[SCHOOL_MASK_ARCANE] 	= L.BossWatcherSchoolArcane,
	
	[0x1C] = L.BossWatcherSchoolElemental,	--Elemental
	[0x7C] = L.BossWatcherSchoolChromatic,	--Chromatic
	[0x7E] = L.BossWatcherSchoolMagic,		--Magic
	[0x7F] = L.BossWatcherSchoolChaos,		--Chaos
}

local ReductionAurasFunctions = {
	physical = 1,
	magic = 2,
	feintCheck = 3,
	dampenHarmCheck = 4,
}
module.db.reductionAuras = {
	--Paladin
	[210320] = {0.8,nil,function(auraVar) return (100+auraVar)/100 end},	--Devotion Aura
	[498] = 0.8,		--Divine Protection
	[86659] = 0.5,		--Guardian of Ancient Kings
	[31850] = 0.8,		--Ardent Defender

	--Priest
	[45242] = 0.85,		--Focused Will
	[33206] = 0.6,		--Pain Suppression
	[81782] = 0.75,		--Power Word: Barrier
	[47585] = 0.4,		--Dispersion
	[194384] = 1,	--Atonement talent

	--Druid
	[22812] = {0.8,nil,function(_,auraVar) return (100+auraVar)/100 end},		--Barkskin
	[102342] = {0.8,nil,function(auraVar) return (100+auraVar)/100 end},		--Ironbark

	--DH
	[212800] = {0.65,nil,function(_,_,auraVar) return (100+auraVar)/100 end},		--Blur

	--Shaman
	[260881] = 0.95,		--Ghost in the Mist
	[108271] = 0.6,		--Astral Shift

	--Warlock
	[104773] = {0.6,nil,function(_,_,auraVar) return (100+auraVar)/100 end},		--Unending Resolve

	--DK
	[48792] = {0.7,nil,function(_,_,auraVar) return (100+auraVar)/100 end},		--Icebound Fortitude

	--Monk
	[122278] = 0.75,		--Dampen Harm
	[120954] = {0.8,nil,function(_,auraVar) return (100+auraVar)/100 end},		--Fortifying Brew

	--Warrior
	[871] = 0.6,		--Shield Wall
	[184364] = 0.7,		--Enraged Regeneration

	--Mage
	[113862] = 0.4,		--Greater Invisibility

	--Other
	[303350] = 0.9,	--EP weapon
	[296003] = {1,nil,function(_,auraVar) return (100+auraVar)/100 end},	--Essence: Unwavering Ward
}
module.db.reductionBySpec = {
	[63] = {30482,	0.94,	ReductionAurasFunctions.physical,	0x4},	--Mage fire;  16% with artifact trait, 6% without
	[104] = {16931,	0.94},			--Druid bear
	[581] = {203513,0.9},			--Demonic Wards
}
module.db.reductionCurrent = {}
module.db.reductionPowerWordBarrierCaster = nil

module.db.reductionIsNotAoe = {}

module.db.def_trackingDamageSpells = {
	[209471]=1873,	--Il'gynoth: Nightmare Explosion
	[198099]=1841,	--Ursoc: Barreling Momentum
	[199237]=1841,	--Ursoc: Barreling Momentum > Crushing Impact
	[211073]=1877,	--Cenarius: Desiccating Stomp
	[210619]=1877,	--Cenarius: Destructive Nightmares
	[206369]=1864,	--Xavius: Corruption Meteor
	
	[228162]=1958,	--Odyn: Shield of Light
	
	[210074]=1849,	--Crystal Scorpion: Shockwave
	[204733]=1849,	--Crystal Scorpion: Volatile Chitin
	[207328]=1867,	--Trillax: Cleansing Destruction
	[206376]=1842,	--Krosus: Burning Pitch
	[206938]=1863,	--Etraeus: Shatter
	[210546]=1872,	--Elisande: orb
	[206370]=1866,	--Guldan: 
	
	--[2812]=true,	--Test
}

local var_reductionAuras,var_reductionCurrent = module.db.reductionAuras,module.db.reductionCurrent
local var_trackingDamageSpells = nil

local encounterSpecial = {}

local _graphSectionTimer,_graphSectionTimerRounded,_graphRaidSnapshot = 0,0,{}
local _graphRaidEnergy = {}

local _BW_Start,_BW_End = nil

local fightData_damage,fightData_damage_seen,fightData_heal,fightData_healFrom,fightData_switch,fightData_cast,fightData_auras,fightData_power,fightData_deathLog,fightData_maxHP,fightData_reduction

local active_segment
local active_phase

local deathMaxEvents = 100

do
	local function CheckForCombat()
		if UnitAffectingCombat("player") or IsEncounterInProgress() then
			_BW_Start()
		end
	end
	
	function module:Enable()
		VExRT.BossWatcher.enabled = true
		
		module:RegisterEvents('ZONE_CHANGED_NEW_AREA','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END','CHALLENGE_MODE_START','CHALLENGE_MODE_COMPLETED','CHALLENGE_MODE_RESET')
		module.main:ZONE_CHANGED_NEW_AREA()
		module:RegisterSlash()
		
		if select(3,GetInstanceInfo()) == 8 and C_ChallengeMode.IsChallengeModeActive() then
			module.main:CHALLENGE_MODE_START()
		elseif UnitAffectingCombat("player") then
			_BW_Start()
		else
			ExRT.F.Timer(CheckForCombat,3)
		end
	end
end

function module:Disable()
	VExRT.BossWatcher.enabled = nil
	
	if fightData then
		_BW_End()
	end
	
	module.main:UnregisterAllEvents()
	module:UnregisterSlash()
end

local BWInterfaceFrame = nil
local BWInterfaceFrameLoad,isBWInterfaceFrameLoaded,BWInterfaceFrameLoadFunc = nil
do
	local isAdded = nil
	function BWInterfaceFrameLoadFunc()
		if not isBWInterfaceFrameLoaded then
			BWInterfaceFrameLoad()
		end
		if isBWInterfaceFrameLoaded then
			InterfaceOptionsFrame:Hide()
			BWInterfaceFrame:Show()
		end
		CloseDropDownMenus() 
	end
	function module:miniMapMenu()
		if isAdded then
			return
		end
		local subMenu = {
			{text = L.BossWatcher, func = BWInterfaceFrameLoadFunc, notCheckable = true},
			{text = L.BossWatcherTabMobs, func = ExRT.F.FightLog_OpenTab, arg1 = 1, notCheckable = true},
			{text = L.BossWatcherTabHeal, func = ExRT.F.FightLog_OpenTab, arg1 = 2, notCheckable = true},
			{text = L.BossWatcherTabBuffsAndDebuffs, func = ExRT.F.FightLog_OpenTab, arg1 = 3, notCheckable = true},
			{text = L.BossWatcherTabEnemy, func = ExRT.F.FightLog_OpenTab, arg1 = 4, notCheckable = true},
			{text = L.BossWatcherTabPlayersSpells, func = ExRT.F.FightLog_OpenTab, arg1 = 5, notCheckable = true},
			{text = L.BossWatcherTabEnergy, func = ExRT.F.FightLog_OpenTab, arg1 = 6, notCheckable = true},
			{text = L.BossWatcherTabInterruptAndDispel, func = ExRT.F.FightLog_OpenTab, arg1 = 7, notCheckable = true},
			{text = TRACKING, func = ExRT.F.FightLog_OpenTab, arg1 = 8, notCheckable = true},
			{text = L.BossWatcherDeath, func = ExRT.F.FightLog_OpenTab, arg1 = 9, notCheckable = true},
			{text = L.BossWatcherPositions, func = ExRT.F.FightLog_OpenTab, arg1 = 10, notCheckable = true},
		}
		ExRT.F.MinimapMenuAdd(L.BossWatcher, BWInterfaceFrameLoadFunc, 1, "FightLog_Navigation", subMenu)
	end
	module:RegisterMiniMapMenu()
end
ExRT.F.FightLog_Open = BWInterfaceFrameLoadFunc

function ExRT.F:FightLog_OpenTab(tabID)
	if not isBWInterfaceFrameLoaded then
		BWInterfaceFrameLoad()
	end
	BWInterfaceFrame.tab:SelectTab(tabID)
	BWInterfaceFrame:Show()
	
	CloseDropDownMenus()
end

function module.options:Load()
	self:CreateTilte()

	self.checkEnabled = ELib:Check(self,L.senable,VExRT.BossWatcher.enabled):Point(15,-35):OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)
	
	self.sliderNum = ELib:Slider(self,L.BossWatcherOptionsFightsSave):Size(300):Point(20,-125):Range(1,15):SetTo(VExRT.BossWatcher.fightsNum or 1):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.BossWatcher.fightsNum = event
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	self.warningText = ELib:Text(self,L.BossWatcherOptionsFightsWarning,12):Size(570,25):Point(15,-150):Top():Color():Shadow()
	
	if ExRT.T == "Dev" then
		self.saveVariables = ELib:Check(self,L.BossWatcherSaveVariables):Point(260,-35):Tooltip(L.BossWatcherSaveVariablesWarring):OnClick(function(self) 
			VExRT.BossWatcher.saveVariables = true
			VExRT.BossWatcher.SAVED_DATA = module.db.data
			print('Saved')
		end)
	end
	
	self.showButton = ELib:Button(self,L.BossWatcherGoToBossWatcher):Size(550,20):Point("TOP",0,-200):OnClick(function ()
		InterfaceOptionsFrame:Hide()
		ExRT.Options.Frame:Hide()
		BWInterfaceFrameLoadFunc()
	end)
	self.buttonChecker = CreateFrame("Frame",nil,self)
	self.buttonChecker:SetScript("OnShow",function (self)
		if not ExRT.Options.Frame:IsShown() then
			module.options.showButton:Hide()
		else
			module.options.showButton:Show()
		end
	end)
	
	self.chatText = ELib:Text(self,L.BossWatcherOptionsHelp,12):Size(600,250):Point(15,-235):Top():Color():Shadow()
		
	function module.options:AdditionalOnShow()
		if ExRT.Options.Frame:IsShown() then
			module.options:SetParent(ExRT.Options.Frame)
			module.options:ClearAllPoints()
			module.options:SetPoint("TOPLEFT",195,-25)
		end
	end
end

local function UpdateTrackingDamageSpellsTable()
	var_trackingDamageSpells = ExRT.F.table_copy2(module.db.def_trackingDamageSpells)
	for spellID,_ in pairs(VExRT.BossWatcher.trackingDamageSpells) do
		var_trackingDamageSpells[spellID] = true
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.BossWatcher = VExRT.BossWatcher or {
		optionsDamageGraph = true,
		optionsHealingGraph = true,
		optionsPositionsDist = true,
		fightsNum = 2,
	}
	
	if VExRT.BossWatcher.enabled then
		module:Enable(true)
	end
	VExRT.BossWatcher.fightsNum = VExRT.BossWatcher.fightsNum or 2
	
	VExRT.BossWatcher.trackingDamageSpells = VExRT.BossWatcher.trackingDamageSpells or {}
	UpdateTrackingDamageSpellsTable()
	
	if VExRT.BossWatcher.saveVariables and VExRT.BossWatcher.SAVED_DATA then
		module.db.data = VExRT.BossWatcher.SAVED_DATA
		for i=1,#module.db.data do
			if module.db.data[i] then
				module.db.data[i].fightID = -i
			end
		end
	else
		VExRT.BossWatcher.SAVED_DATA = nil
	end
	
	VExRT.BossWatcher.saveVariables = nil
	
	if VExRT.Addon.Version < 3596 then
		VExRT.BossWatcher.optionsDamageGraph = true
		VExRT.BossWatcher.optionsHealingGraph = true
		VExRT.BossWatcher.optionsPositionsDist = true
	end
end

local negateHealing = {}

local SLTReductionAuraSpellID = 98007
local SLTReductionAuraData = {}
local SLTReductionSourceGUID = nil

local SLTReductionFrame = CreateFrame("Frame")
SLTReductionFrame:SetScript("OnEvent",function(_,_,unit)
	local findEm = nil
	for i=1,40 do
		local name,icon,count,dispelType,duration,expires,caster,isStealable,_,spellId = UnitAura(unit, i, "HELPFUL")
		if spellId == SLTReductionAuraSpellID then 
			findEm = true
			break
		elseif not name then
			break
		end
	end    

	local guid = UnitGUID(unit)
	if not guid then
		return
	elseif findEm and not SLTReductionAuraData[ guid ] then
		if not fightData_auras then
			return
		end
		local destData = var_reductionCurrent[ guid ]
		if not destData then
			destData = {}
			var_reductionCurrent[ guid ] = destData
		end
		local destCount = #destData
		local from = 1
		for i=1,destCount do
			from = from * destData[i].r
		end
		local currReduction = 1 / (1 - (from - from * 0.9))
		destData[destCount + 1] = {
			s = SLTReductionAuraSpellID,
			r = 0.9,
			c = (currReduction - 1),
			g = SLTReductionSourceGUID,
		}
		
		SLTReductionAuraData[ guid ] = true
		
		fightData_auras[ #fightData_auras + 1 ] = {GetTime() - module.db.timeFix[1] + module.db.timeFix[2],SLTReductionSourceGUID,UnitGUID(unit),true,true,SLTReductionAuraSpellID,"BUFF",1,1}		
	elseif not findEm and SLTReductionAuraData[ guid ] then
		if not fightData_auras then
			return
		end
		local destData = var_reductionCurrent[ guid ]
		if not destData then
			return
		end
		for i=1,#destData do
			if destData[i] and destData[i].s == SLTReductionAuraSpellID then
				tremove(destData,i)
			end
		end
		
		local from,fromPhysical,fromMagic = 1,1,1
		for i=1,#destData do
			local spellData = destData[i]
			local currReduction = nil
			if spellData.f == ReductionAurasFunctions.magic then
				currReduction = 1 / (1 - (fromMagic - fromMagic * spellData.r))
				fromMagic = fromMagic * spellData.r
			elseif spellData.f == ReductionAurasFunctions.physical then
				currReduction = 1 / (1 - (fromPhysical - fromPhysical * spellData.r))
				fromPhysical = fromPhysical * spellData.r
			else
				currReduction = 1 / (1 - (from - from * spellData.r))
				fromPhysical = fromPhysical * spellData.r
				fromMagic = fromMagic * spellData.r
			end
			from = from * spellData.r
			spellData.c = currReduction - 1
		end
		
		SLTReductionAuraData[ guid ] = nil
		
		fightData_auras[ #fightData_auras + 1 ] = {GetTime() - module.db.timeFix[1] + module.db.timeFix[2],SLTReductionSourceGUID,UnitGUID(unit),true,true,SLTReductionAuraSpellID,"BUFF",2,1}		
	end
end)

local SLTReductionUnregTimer = nil
local function SLTReductionUnreg()
	SLTReductionUnregTimer = nil
	SLTReductionFrame:UnregisterAllEvents()
	wipe(SLTReductionAuraData)
end
local function SLTReductionReg(sourceGUID)
	SLTReductionSourceGUID = sourceGUID
	SLTReductionFrame:RegisterEvent("UNIT_AURA")
end

local reductionAtonement = {}

local function addReductionOnPull(unit,destGUID)
	--------------> Add passive reductions
	--- Note: this is first reduction check ever and I must don't care about any existens data
	local unitInspectData = ExRT.A.ExCD2 and ExRT.A.ExCD2.db and ExRT.A.ExCD2.db.inspectDB and ExRT.A.ExCD2.db.inspectDB[unit]
	local specID = unitInspectData and unitInspectData.spec or 0
	local reductionSpec = module.db.reductionBySpec[ specID ]
	if reductionSpec then
		var_reductionCurrent[ destGUID ] = {
			{
				s = reductionSpec[1],
				r = reductionSpec[2],
				c = (1 / reductionSpec[2] - 1),
				g = destGUID,
				f = reductionSpec[3],
			}
		}
		spellsSchool[ reductionSpec[1] ] = reductionSpec[4] or 0x1
	end

	if unitInspectData and unitInspectData.class == "PRIEST" and specID == 256 and unitInspectData.GUID then
		if (unitInspectData[7] == 1) then
			reductionAtonement[ unitInspectData.GUID ] = 0.97
		else
			reductionAtonement[ unitInspectData.GUID ] = nil
		end
	end
	
	if unitInspectData and unitInspectData.class == "DRUID" and specID ~= 104 then
		--Guardian affinity
		if (unitInspectData[3] == 2 and specID ~= 105) or (unitInspectData[3] == 3 and specID == 105) then
			var_reductionCurrent[ destGUID ] = {
				{
					s = 16931,
					r = 0.94,
					c = (1 / 0.94 - 1),
					g = destGUID,
				}
			}
		end
	end
	
	
	
	--------------> Add active reductions from current auras
	for i=1,40 do
		local _,_,stacksCount,_,_,_,casterUnit,_,_,spellID,_,_,_,_,_,val1,val2,val3,val4,val5 = UnitAura(unit,i)
		
		if not spellID then
			return
		end
	
		--------------> Add reduction
		local reduction = var_reductionAuras[spellID]
		if reduction then
			local sourceGUID = nil
			if casterUnit then
				sourceGUID = UnitGUID(casterUnit)
			end
			sourceGUID = sourceGUID or ""
		
			local destData = var_reductionCurrent[ destGUID ]
			if not destData then
				destData = {}
				var_reductionCurrent[ destGUID ] = destData
			end
			local destCount = #destData
			
			local func,funcAura,reductionTable = nil
			if type(reduction)=="table" then
				reductionTable = reduction
				funcAura = reduction[3]
				func = reduction[2]
				reduction = reduction[1]
			end
			
			if funcAura then
				if val1 then
					reduction, func = funcAura(val1 or 0,val2 or 0,val3 or 0,val4 or 0,val5 or 0)
					if not reduction then
						reduction = reductionTable[1]
						func = reductionTable[2]
						funcAura = nil
					end
					--ExRT.F.dprint(format("%s > %s: %s [%d%%]",sourceName,destName,spellName,(reduction or 0)*100))
				else
					funcAura = nil
				end
			end
							
			if reduction ~= 1 then
				local from = 1
				if func == ReductionAurasFunctions.magic then
					for i=1,destCount do
						if destData[i].f ~= ReductionAurasFunctions.physical then
							from = from * destData[i].r
						end
					end
				elseif func == ReductionAurasFunctions.physical then
					for i=1,destCount do
						if destData[i].f ~= ReductionAurasFunctions.magic then
							from = from * destData[i].r
						end
					end
				else
					for i=1,destCount do
						from = from * destData[i].r
					end
				end
			
				local currReduction = 1 / (1 - (from - from * reduction))
				destData[destCount + 1] = {
					s = spellID,
					r = reduction,
					c = (currReduction - 1),
					g = sourceGUID,
					f = func,
				}
				
				if not spellsSchool[spellID] then
					spellsSchool[spellID] = 0x1
				end
			end
		end
	end
end

local BossPhasesData = {
	[1853] = {
		events = {"COMBAT_LOG_EVENT_UNFILTERED"},
		func = function()
			local _,event,_,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId = CombatLogGetCurrentEventInfo()
			if event == "SPELL_CAST_START" and spellId == 203552 then
				active_phase = 2
				C_Timer.After(23.7,function()
					if active_phase then
						active_phase = 1
					end
				end)
			end
		end,
		names = {
			[1] = -13916,
			[2] = -13917,
		},
	},	--EN: Nethendra
	[1873] = {
		events = {"COMBAT_LOG_EVENT_UNFILTERED"},
		func = function()
			local _,event,_,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId = CombatLogGetCurrentEventInfo()
			if event == "SPELL_AURA_APPLIED" and spellId == 209915 then
				active_phase = 1
			elseif event == "SPELL_AURA_REMOVED" and spellId == 209915 then
				active_phase = 2
			end
		end,
		names = {
			[1] = -13184,
			[2] = -13192,
		},
	},	--EN: Illgynoth
	[1877] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 217368 then
				active_phase = 2
			end
		end,
		names = {
			[1] = -13479,
			[2] = -13488,
		},
	},	--EN: Cenarius
	[1864] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 226193 then
				active_phase = 2
			elseif spellId == 226185 then
				active_phase = 3
			end
		end,
		names = {
			[1] = -12971,
			[2] = -13152,
			[3] = -13160,
		},
	},	--EN: Xavius
	[1958] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 229168 then
				active_phase = 2
			elseif spellId == 228740 then
				active_phase = 3
			end
		end,
		names = {
			[1] = -14002,
			[2] = -14010,
			[3] = -14011,
		},
	},	--Tov: Odyn
	[2008] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 34098 then
				active_phase = 2
			elseif spellId == 228546 then
				active_phase = 3
			end
		end,
		names = {
			[1] = -14212,
			[2] = -14222,
			[3] = -14224,
		},
	},	--Tov: Helya	
	[1849] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 204448 then
				active_phase = 1
			elseif spellId == 204459 then
				active_phase = 2
			end
		end,
		names = {
			[1] = -12822,
			[2] = -12859,
		},
	},	--NH: Scorpion
	[1865] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 207012 then
				active_phase = 1
			elseif spellId == 207011 then
				active_phase = 2
			elseif spellId == 207013 then
				active_phase = 3
			end
		end,
		names = {
			[1] = GetSpellInfo(207012),
			[2] = GetSpellInfo(207011),
			[3] = GetSpellInfo(207013),
		},
	},	--NH: Anomaly	
	[1867] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 206570 then
				active_phase = 1
			elseif spellId == 206557 then
				active_phase = 2
			elseif spellId == 206559 then
				active_phase = 3
			end
		end,
		names = {
			[1] = -13285,
			[2] = -13281,
			[3] = -13282,
		},
	},	--NH: Trillax
	[1871] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 216389 then
				active_phase = 1
			elseif spellId == 213867 then
				active_phase = 2
			elseif spellId == 213869 then
				active_phase = 3
			end
		end,
		names = {
			[1] = -13376,
			[2] = -13379,
			[3] = -13380,
		},
	},	--NH: Aluriel
	[1842] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 205862 then
				encounterSpecial.slam = (encounterSpecial.slam or 0) + 1
				if (encounterSpecial.slam % 3) == 0 then
					active_phase = active_phase + 1
				end
			end
		end,
		names = {
			[1] = 1,
			[2] = 2,
			[3] = 3,
			[4] = 4,
			[5] = 5,
			[6] = 6,
		},		
	},	--NH: Krosus
	[1862] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 206311 then
				active_phase = 2
				C_Timer.After(30,function()
					if fightData then
						active_phase = 1
					end
				end)
			end
		end,
		names = {
			[1] = -13552,
			[2] = -13553,
		},		
	},	--NH: Tichondrius
	[1863] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 222130 then
				active_phase = 2
			elseif spellId == 222133 then
				active_phase = 3
			elseif spellId == 222134 then
				active_phase = 4
			end
		end,
		names = {
			[1] = -13033,
			[2] = -13036,
			[3] = -13046,
			[4] = -13053,
		},		
	},	--NH: Etraeus
	[1886] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"},{"UNIT_SPELLCAST_SUCCEEDED","boss2"},{"UNIT_SPELLCAST_SUCCEEDED","boss3"}},
		func = function(_, event, unit, _, spellId)
			if ((spellId == 216830 or spellId == 216877) and unit == "boss1") or spellId == 70628 then
				active_phase = active_phase + 1
			end
		end,
		names = {
			[1] = -13679,
			[2] = -13681,
			[3] = -13683,
		},		
	},	--NH: Telarn	
	[1872] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 208861 then
				active_phase = active_phase + 1
			end
		end,
		names = {
			[1] = -13222,
			[2] = -13235,
			[3] = -13232,
		},		
	},	--NH: Elisande
	[1866] = {
		events = {"UNIT_SPELLCAST_SUCCEEDED"},
		func = function(_, event, unit, _, spellId)
			if not unit or not unit:find("^boss") then
				return
			elseif spellId == 118357 then
				active_phase = 2
			elseif spellId == 227427 then
				C_Timer.After(7.5,function()
					if fightData then
						active_phase = 3
					end
				end)
			elseif spellId == 211439 then
				active_phase = 4
			end
		end,
		names = {
			[1] = -14885,
			[2] = -14062,
			[3] = -13145,
			[4] = "The Demon Within",
		},	
	},	--NH: Guldan
	[2037] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 239423 then
				active_phase = min(active_phase + 1, 3)
			end
		end,
		names = {
			[1] = -14591,
			[2] = -14605,
			[3] = -14609,
		},		
	},	--ToS: Госпожа Сашж'ин
	[2052] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"},{"UNIT_SPELLCAST_CHANNEL_STOP","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 235725 then
				active_phase = 2
			elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" and spellId == 234891 then
				active_phase = 1
			end
		end,
		names = {
			[1] = -14974,
			[2] = -14975,
		},		
	},	--ToS: Бдительная дева
	[2038] = {
		events = {{"UNIT_SPELLCAST_SUCCEEDED","boss1"}},
		func = function(_, event, unit, _, spellId)
			if spellId == 235597 then
				active_phase = 2
			end
		end,
		names = {
			[1] = -14709,
			[2] = -14719,
		},		
	},	--ToS: Аватара Падшего
	[2051] = {
		events = {"COMBAT_LOG_EVENT_UNFILTERED"},
		func = function()
			local _,event,_,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId = CombatLogGetCurrentEventInfo()
			if event == "SPELL_CAST_SUCCESS" then
				if spellId == 244834 then
					active_phase = 2
				elseif spellId == 241983 then
					active_phase = 4
				end
			elseif event == "SPELL_AURA_REMOVED" then 
				if spellId == 244834 and active_phase then
					active_phase = 3
				end
			elseif event == "SPELL_CAST_START" then 
				if spellId == 238999 and active_phase ~= 5 then
					active_phase = 5
				end
			end
		end,
		names = {
			[1] = -14921,
			[2] = -15221,
			[3] = -15229,
			[4] = -15394,
			[5] = -15255,
		},
	},	--ToS: Kj
}
local BossPhasesFrame = CreateFrame("Frame")
local BossPhasesBossmodPhaseCounter, BossPhasesBossmodPhase, BossPhasesBossmodEnabled = 1
local BossPhasesBossmodCL
local BossPhasesBossmod
function BossPhasesBossmod()
	if BigWigsLoader and type(BigWigsLoader)=='table' and BigWigsLoader.RegisterMessage then
		local r = {}
		function r:BigWigs_Message (event, module, key, text, ...)
			
			if (key == "stages") then
				if not text or not BossPhasesBossmodEnabled then
					return
				elseif BossPhasesBossmodPhase ~= text then
					if BossPhasesBossmodCL or BigWigsAPI then
						local CL = BossPhasesBossmodCL or BigWigsAPI:GetLocale("BigWigs: Common")
						BossPhasesBossmodCL = CL
						if CL and CL.soon and type(text)=='string' then
							local patt = CL.soon:gsub("%%s","")
							if CL.soon:find("^%%s") then
								patt = patt .. "$"
							else
								patt = "^" .. patt
							end
							if text:find( patt ) then
								return
							end
						end
					end

					local phaseNumInDB = nil
					for index,phase in pairs(segmentsData.phaseNames) do
						if text == phase then
							phaseNumInDB = index
							break
						end
					end
					if not phaseNumInDB then
						BossPhasesBossmodPhaseCounter = BossPhasesBossmodPhaseCounter + 1
						phaseNumInDB = BossPhasesBossmodPhaseCounter
						
						segmentsData.phaseNames[BossPhasesBossmodPhaseCounter] = text
					end
					
					BossPhasesBossmodPhase = text
					
					active_phase = phaseNumInDB
				end			
			end
		end
		
		BigWigsLoader.RegisterMessage (r, "BigWigs_Message")
		
		BossPhasesBossmod = nil
	end
end


function _BW_Start(encounterID,encounterName)
	module.db.lastFightID = module.db.lastFightID + 1
	
	local maxFights = (VExRT.BossWatcher.fightsNum or 5)
	for i=maxFights+1,2,-1 do
		module.db.data[i] = module.db.data[i-1]
	end
	
	fightData_damage = {}
	fightData_damage_seen = {}
	fightData_heal = {}
	fightData_healFrom = {}
	fightData_switch = {}
	fightData_cast = {}
	fightData_auras = {}
	fightData_power = {}
	fightData_deathLog = {}
	fightData_maxHP = {}
	fightData_reduction = {}
	
	fightData = {
		guids = {},
		raidguids = {},
		reaction = {},
		pets = {},
		encounterName = encounterName,
		encounterID = encounterID,
		encounterStartGlobal = time(),
		encounterStart = GetTime(),
		encounterEnd = 0,
		graphData = {},
		positionsData = {},
		fightID = module.db.lastFightID,
		segments = {
			[1] = {
				e=true,
				t=GetTime(),
				p=1,
			},
		},
		damage = fightData_damage,
		damage_seen = fightData_damage_seen,
		heal = fightData_heal,
		healFrom = fightData_healFrom,
		switch = fightData_switch,
		cast = fightData_cast,
		interrupts = {},
		dispels = {},
		auras = fightData_auras,
		power = fightData_power,
		dies = {},
		chat = {},
		resurrests = {},
		summons = {},
		aurabroken = {},
		deathLog = fightData_deathLog,
		maxHP = fightData_maxHP,
		reduction = fightData_reduction,
		tracking = {},
		other = {
			roles = {},
			rolesGUID = {},
		},
	}
	
	module.db.data[1] = fightData
	
	wipe(deathLog)
	wipe(damageTakenLog)
	wipe(encounterSpecial)
	
	raidGUIDs = fightData.raidguids
	guidData = fightData.guids
	graphData = fightData.graphData
	reactionData = fightData.reaction
	segmentsData = fightData.segments
	
	active_segment = 1
	active_phase = 1
	
	wipe(negateHealing)
	
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED','UNIT_TARGET','RAID_BOSS_EMOTE','RAID_BOSS_WHISPER','UPDATE_MOUSEOVER_UNIT')
	
	BossPhasesBossmodEnabled = nil
	local bossPhaseReg = BossPhasesData[encounterID or -1]
	if bossPhaseReg then
		BossPhasesFrame:SetScript("OnEvent",bossPhaseReg.func)
		for i=1,#bossPhaseReg.events do
			local event = bossPhaseReg.events[i]
			if type(event)=='table' then
				BossPhasesFrame:RegisterUnitEvent(event[1],event[2])
			else
				BossPhasesFrame:RegisterEvent(event)
			end
		end
		segmentsData.phaseNames = bossPhaseReg.names
	elseif encounterID then
		BossPhasesBossmodPhase = nil
		BossPhasesBossmodEnabled = true
		BossPhasesBossmodPhaseCounter = 1
		if BossPhasesBossmod then
			BossPhasesBossmod()
		end
		segmentsData.phaseNames = {[1] = 1,}
		if BossPhasesBossmodCL and BossPhasesBossmodCL.stage then	
			segmentsData.phaseNames[1] = BossPhasesBossmodCL.stage:format(1)
		end
	end
	
	_graphSectionTimer = 0
	_graphSectionTimerRounded = 0
	_graphRaidSnapshot = {"boss1","boss2","boss3","boss4","boss5","boss6","target","focus"}
	local energyPerClass_general = energyPerClass["NO"][1]
	_graphRaidEnergy = {
		energyPerClass_general,
		energyPerClass_general,
		energyPerClass_general,
		energyPerClass_general,
		energyPerClass_general,
		energyPerClass_general,
		energyPerClass_general,
		energyPerClass_general,
	}
	
	wipe(var_reductionCurrent)
	
	if not var_trackingDamageSpells then
		var_trackingDamageSpells = {}
	end

	module:RegisterTimer()
	if IsInRaid() then
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		for i=1,40 do
			local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				_graphRaidSnapshot[#_graphRaidSnapshot + 1] = name
				if module.db.allEnergyMode then
					class = "ALL"
				end
				local energy = energyPerClass[class or "NO"]
				if name == ExRT.SDB.charName then
					energy = energy and energy[2]
				else
					energy = energy and energy[1]
				end
				_graphRaidEnergy[#_graphRaidSnapshot] = energy or energyPerClass_general
				
				local guid = UnitGUID(name)
				if guid then
					raidGUIDs[ guid ] = name
					
					addReductionOnPull(name,guid)
					
					fightData.other.rolesGUID[guid] = UnitGroupRolesAssigned(name)
				end
				
				fightData.other.roles[name] = UnitGroupRolesAssigned(name)
			end
		end
	else
		for i=1,5 do
			local unit = i==5 and "player" or "party"..i
			local name = UnitCombatlogname(unit)
			if name then
				_graphRaidSnapshot[#_graphRaidSnapshot + 1] = name
				
				local _,class = UnitClass(unit)
				if module.db.allEnergyMode then
					class = "ALL"
				end
				local energy = energyPerClass[class or "NO"]
				if i == 5 then
					energy = energy and energy[2]
				else
					energy = energy and energy[1]
				end
				_graphRaidEnergy[#_graphRaidSnapshot] = energy or energyPerClass_general
				
				local guid = UnitGUID(name)
				if guid then
					raidGUIDs[ guid ] = name
					
					addReductionOnPull(name,guid)
					
					fightData.other.rolesGUID[guid] = UnitGroupRolesAssigned(name)
				end
				
				fightData.other.roles[name] = UnitGroupRolesAssigned(name)
			end
		end
	end
end

function _BW_End(encounterID)
	if fightData then
		fightData.encounterEnd = GetTime()
		fightData.timeFix = module.db.timeFix
		fightData.ExRTver = ExRT.V
		fightData.isEnded = true
		
		if not fightData.encounterName then
			local minSeen,minGUID = nil
			for GUID,seen in pairs(fightData_damage_seen) do
				if (not minSeen or minSeen > seen) and ExRT.F.GetUnitInfoByUnitFlag(fightData.reaction[GUID],3) == 64 then
					minGUID = GUID
					minSeen = seen
				end
			end
			if minGUID and fightData.guids[minGUID] and fightData.guids[minGUID] ~= "nil" then
				fightData.encounterName = fightData.guids[minGUID]
			end
		end
		
		local GLOBALpets = ExRT.F.Pets:getPetsDB()
		for GUID,name in pairs(fightData.guids) do
			local petData = GLOBALpets[GUID]
			if petData then
				fightData.pets[GUID] = petData
			end
		end
	end

	wipe(encounterSpecial)
	
	module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED','UNIT_TARGET','RAID_BOSS_EMOTE','RAID_BOSS_WHISPER','UPDATE_MOUSEOVER_UNIT')
	module:UnregisterTimer()
	
	BossPhasesFrame:UnregisterAllEvents()
	
	fightData = nil
	guidData = nil
	graphData = nil
	reactionData = nil
	
	active_phase = nil
	
	if BossPhasesBossmodEnabled and segmentsData.phaseNames and ExRT.F.table_len(segmentsData.phaseNames) == 1 then
		segmentsData.phaseNames = nil
	end
	BossPhasesBossmodEnabled = nil

	segmentsData = nil
	
	wipe(deathLog)
	wipe(var_reductionCurrent)
	wipe(damageTakenLog)
	
	local maxFights = (VExRT.BossWatcher.fightsNum or 5)
	for i=25,1,-1 do
		if module.db.data[i] and module.db.data[i].encounterStart and module.db.data[i].encounterEnd and module.db.data[i].encounterID and (module.db.data[i].encounterEnd - module.db.data[i].encounterStart) < 20 then
			local c = 0
			for k,v in pairs(module.db.data[i].raidguids) do 
				c = c + 1 
				if c > 1 then
					break
				end
			end
			if c > 1 then
				tremove(module.db.data,i)
			end
		end
	end
	for i=(maxFights+1),25 do
		if module.db.data[i] then
			wipe(module.db.data[i])
		end
		module.db.data[i] = nil
	end
	
	fightData_damage = nil
	fightData_damage_seen = nil
	fightData_heal = nil
	fightData_healFrom = nil
	fightData_switch = nil
	fightData_cast = nil
	fightData_auras = nil
	fightData_power = nil
	fightData_deathLog = nil
	fightData_maxHP = nil
	fightData_reduction = nil
end

do
	local segment_tmr,segment_checker = 0,-1
	function module:timer(elapsed)
		--------------> Graphs
		_graphSectionTimer = _graphSectionTimer + elapsed
		local nowTimer = ceil(_graphSectionTimer)
		if _graphSectionTimerRounded ~= nowTimer then
			_graphSectionTimerRounded = nowTimer
			local data = {}
			graphData[_graphSectionTimerRounded] = data
			for i=1,#_graphRaidSnapshot do
				local name = _graphRaidSnapshot[i]
				local _name = i <= 7 and UnitCombatlogname(name)
				if i > 7 or _name then
					local health = UnitHealth(name)
					local hpmax = UnitHealthMax(name)
					local absorbs = UnitGetTotalAbsorbs(name)
					
					local currData = {
						name = _name or nil,
						health = health ~= 0 and health or nil,
						hpmax = hpmax ~= 0 and hpmax or nil,
						absorbs = absorbs ~= 0 and absorbs or nil,
					}
					data[name] = currData

					local energy = _graphRaidEnergy[i]
					for j=1,#energy do
						local powerID = energy[j]
						local power = UnitPower(name,powerID)
						if power ~= 0 then
							currData[powerID] = power
						end
					end
				end
			end
		end
		
		segment_tmr = segment_tmr + elapsed
		local nowSegment = segment_tmr - segment_tmr % 1
		if nowSegment ~= segment_checker then
			segment_checker = nowSegment
			active_segment = active_segment + 1
			segmentsData[active_segment] = {
				e = true,
				t = GetTime(),
				p = active_phase,
			}
		end
	end
end


local function GetCurrentZoneID()
	local zoneID = 0
	local zoneName, zoneType, difficulty, _, _, _, _, mapID = GetInstanceInfo()
	if difficulty == 8 then
		zoneID = 3
	elseif zoneType == 'raid' and ((tonumber(mapID) and mapID >= 603) or mapID == 533) then
		zoneID = 1
	elseif zoneType == 'arena' or zoneType == 'pvp' then
		zoneID = 2
	elseif zoneType == 'scenario' and (difficulty == 38 or difficulty == 39 or difficulty == 40 or difficulty == 45) then	--islands
		zoneID = 4
	end
	return zoneID, zoneName
end

function module.main:ENCOUNTER_START(encounterID,encounterName)
	local zoneID = GetCurrentZoneID()
	if zoneID == 1 then
		_BW_Start(encounterID,encounterName)
	end
end
function module.main:PLAYER_REGEN_DISABLED()
	local zoneID = GetCurrentZoneID()
	if zoneID == 0 then
		_BW_Start()
	end
end
function module.main:CHALLENGE_MODE_START()
	local _,zoneName = GetCurrentZoneID()
	_BW_Start(nil,zoneName)
end

function module.main:ENCOUNTER_END(encounterID)
	local zoneID = GetCurrentZoneID()
	if zoneID == 1 then
		_BW_End(encounterID)
	end
end
function module.main:PLAYER_REGEN_ENABLED()
	local zoneID = GetCurrentZoneID()
	if zoneID == 0 then
		_BW_End()
	end
end
function module.main:CHALLENGE_MODE_RESET()
	if fightData then
		_BW_End()
	end
end
module.main.CHALLENGE_MODE_COMPLETED = module.main.CHALLENGE_MODE_RESET

do
	local function ZoneCheck()
		local zoneID, zoneName = GetCurrentZoneID()
		if zoneID == 2 or zoneID == 4 then
			_BW_Start(nil,zoneName)
		end
	end
	function module.main:ZONE_CHANGED_NEW_AREA()
		if fightData then
			_BW_End()
		end
		ExRT.F.ScheduleTimer(ZoneCheck,2)
	end
end

local function AddNotRealDeath(destGUID,timestamp,spellID)
	local destData = deathLog[destGUID]
	if not destData then
		destData = {}
		for i=1,deathMaxEvents do
			destData[i] = {}
		end
		destData.c = 0
		deathLog[destGUID] = destData
	end
	local destTable = {
		{5,destGUID,timestamp,active_segment,spellID},
	}
	destTable.header = destTable[1]
	local destTableLen = 1
	fightData_deathLog[#fightData_deathLog + 1] = destTable
	local c = destData.c
	for i=c,1,-1 do
		local copyTable = destData[i]
		if copyTable.t then
			destTableLen = destTableLen + 1
			destTable[destTableLen] = {
				copyTable.t,
				copyTable.s,
				copyTable.ti,
				copyTable.sp,
				copyTable.a,
				copyTable.o,
				copyTable.sc,
				copyTable.b,
				copyTable.ab,
				copyTable.c,
				false,
				copyTable.h,
				copyTable.hm,
				copyTable.ia,
				copyTable.sm,
				copyTable.dm,
			}
		end
	end
	for i=deathMaxEvents,c+1,-1 do
		local copyTable = destData[i]
		if copyTable.t then
			destTableLen = destTableLen + 1
			destTable[destTableLen] = {
				copyTable.t,
				copyTable.s,
				copyTable.ti,
				copyTable.sp,
				copyTable.a,
				copyTable.o,
				copyTable.sc,
				copyTable.b,
				copyTable.ab,
				copyTable.c,
				false,
				copyTable.h,
				copyTable.hm,
				copyTable.ia,
				copyTable.sm,
				copyTable.dm,
			}
		end
	end
	destData.schFunc = function()
		local tinsert = tinsert
		if destData.c ~= c then
			local d = {}
			if destData.c < c then
				for i=destData.c,1,-1 do
					local copyTable = destData[i]
					if copyTable.t and (copyTable.ti - timestamp) <= 0.25 then
						d[#d+1] = {
							copyTable.t,
							copyTable.s,
							copyTable.ti,
							copyTable.sp,
							copyTable.a,
							copyTable.o,
							copyTable.sc,
							copyTable.b,
							copyTable.ab,
							copyTable.c,
							false,
							copyTable.h,
							copyTable.hm,
							copyTable.ia,
							copyTable.sm,
							copyTable.dm,
						}
					end
				end
				for i=deathMaxEvents,c+1,-1 do
					local copyTable = destData[i]
					if copyTable.t and (copyTable.ti - timestamp) <= 0.25 then
						d[#d+1] = {
							copyTable.t,
							copyTable.s,
							copyTable.ti,
							copyTable.sp,
							copyTable.a,
							copyTable.o,
							copyTable.sc,
							copyTable.b,
							copyTable.ab,
							copyTable.c,
							false,
							copyTable.h,
							copyTable.hm,
							copyTable.ia,
							copyTable.sm,
							copyTable.dm,
						}
					end						
				end
				for i=#d,1,-1 do
					tinsert(destTable,1,d[i])
				end
			else
				for i=destData.c,c+1,-1 do
					local copyTable = destData[i]
					if copyTable.t and (copyTable.ti - timestamp) <= 0.25 then
						d[#d+1] = {
							copyTable.t,
							copyTable.s,
							copyTable.ti,
							copyTable.sp,
							copyTable.a,
							copyTable.o,
							copyTable.sc,
							copyTable.b,
							copyTable.ab,
							copyTable.c,
							false,
							copyTable.h,
							copyTable.hm,
							copyTable.ia,
							copyTable.sm,
							copyTable.dm,
						}
					end
				end
				for i=#d,1,-1 do
					tinsert(destTable,1,d[i])
				end					
			end
		end
		
		destData.schFunc = nil
		destData.sch = nil
	end
	destData.sch = C_Timer.NewTimer(1,destData.schFunc)
end

local EnvironmentalTypeToSpellID = {
	["Falling"] = 110122,
	["Drowning"] = 68730,
	["Fatigue"] = 125024,
	["Fire"] = 103795,
	["Lava"] = 119741,
	["Slime"] = 16456,
	-- UnkEnvDamage = 48360,
}

local DeathLogBlackList = {
	[154420] = true, --Azshara encounter
	[157452] = true, --Nzoth spine
}

if ExRT.isClassic then
	local _CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
	function CombatLogGetCurrentEventInfo()
		local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,
		val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14
				= _CombatLogGetCurrentEventInfo()
		if event ~= "SWING_DAMAGE" and event ~= "SWING_MISSED" then
			val1 = val2
			if event == "SPELL_PERIODIC_DAMAGE" then event = "SPELL_DAMAGE"
			elseif event == "SPELL_PERIODIC_HEAL" then event = "SPELL_HEAL" 
			elseif event == "SPELL_PERIODIC_MISSED" then event = "SPELL_MISSED" end
		end
		return timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,
		val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14
	end
end

local function CLEUParser(self,_,timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14)
	if not timestamp then
		timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,
		val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14
				= CombatLogGetCurrentEventInfo()
	end

	if not guidData[sourceGUID] then guidData[sourceGUID] = sourceName or "nil" end
	if not guidData[destGUID] then guidData[destGUID] = destName or "nil" end
	
	reactionData[sourceGUID] = sourceFlags
	reactionData[destGUID] = destFlags
	
	---------------------------------
	------ damage
	---------------------------------
	if event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" then
		--[[
			val1	spellID
			val2	_
			val3	_
			val4	amount
			val5	overkill
			val6	school
			val7	resisted
			val8	blocked
			val9	absorbed
			val10	critical
			val11	glancing
			val12	crushing
			val13	isOffHand
			val14	missType
				--Note, missType param added by myself for tracking function
		]]

		--------------> Add damage
		local activeTable = fightData_damage[destGUID]	--destTable
		if not activeTable then
			fightData_damage_seen[destGUID] = timestamp
			activeTable = {}
			fightData_damage[destGUID] = activeTable
		end
		local activeTable2 = activeTable[destFlags]	--destReaction
		if not activeTable2 then
			activeTable2 = {}
			activeTable[destFlags] = activeTable2
		end
		activeTable = activeTable2[sourceGUID]	--sourceTable
		if not activeTable then
			activeTable = {}
			activeTable2[sourceGUID] = activeTable
		end
		activeTable2 = activeTable[event == "SPELL_PERIODIC_DAMAGE" and -val1 or val1]	--segmentsTable
		if not activeTable2 then
			activeTable2 = {}
			activeTable[event == "SPELL_PERIODIC_DAMAGE" and -val1 or val1] = activeTable2
		end
		local spellTable = activeTable2[active_segment]	--spellTable
		if not spellTable then
			spellTable = {
				amount = 0,
				count = 0,
				overkill = 0,
				blocked = 0,
				absorbed = 0,
				crit = 0,
				critcount = 0,
				critmax = 0,
				critover = 0,
				hitmax = 0,
				parry = 0,
				dodge = 0,
				miss = 0,
			}
			activeTable2[active_segment] = spellTable
			if val6 then
				spellsSchool[val1] = val6
			end
		end
		spellTable.amount = spellTable.amount + val4
		spellTable.count = spellTable.count + 1
		if val5 > 0 then
			spellTable.overkill = spellTable.overkill + val5
		end
		if val8 then
			spellTable.blocked = spellTable.blocked + val8
		end
		if val9 then
			spellTable.absorbed = spellTable.absorbed + val9
		end
		if val10 then
			spellTable.crit = spellTable.crit + val4
			spellTable.critcount = spellTable.critcount + 1
			if spellTable.critmax < val4 then
				spellTable.critmax = val4
			end
			spellTable.critover = spellTable.critover + (val5 > 0 and val5 or 0) + (val8 and val8 or 0) + (val9 and val9 or 0)
		elseif spellTable.hitmax < val4 then
			spellTable.hitmax = val4
		end
		
		
		
		--------------> Add death
		local mobID = GUIDtoID(destGUID)
		if not DeathLogBlackList[mobID] then
			activeTable2 = deathLog[destGUID]	--destData
			if not activeTable2 then
				activeTable2 = {}
				for i=1,deathMaxEvents do
					activeTable2[i] = {}
				end
				activeTable2.c = 0
				deathLog[destGUID] = activeTable2
			end
			local tmpVar = activeTable2.c + 1
			if tmpVar > deathMaxEvents then
				tmpVar = 1
			end
			activeTable2.c = tmpVar
			activeTable = activeTable2[tmpVar]
			activeTable.t = 1
			activeTable.s = sourceGUID
			activeTable.ti = timestamp
			activeTable.sp = val1
			activeTable.a = val4
			activeTable.o = val5
			activeTable.sc = val6
			activeTable.b = val8
			activeTable.ab = val9
			activeTable.c = val10
			activeTable.ia = nil
			activeTable.sm = sourceFlags2
			activeTable.dm = destFlags2
			tmpVar = raidGUIDs[ destGUID ]
			if tmpVar then
				activeTable.h = UnitHealth( tmpVar )
				activeTable.hm = UnitHealthMax( tmpVar )
			end
		end
		
		
		--------------> Add reduction
		activeTable = var_reductionCurrent[destGUID]
		if activeTable then
			local reduction = fightData_reduction[destGUID]
			if not reduction then
				reduction = {}
				fightData_reduction[destGUID] = reduction
			end
			local reduction2 = reduction[sourceGUID]
			if not reduction2 then
				reduction2 = {}
				reduction[sourceGUID] = reduction2
			end
			reduction = reduction2[val1]
			if not reduction then
				reduction = {}
				reduction2[val1] = reduction
			end
			
			for i=1,#activeTable do
				local reductionSubtable = activeTable[i]
			
				local amount2 = val4+(val9 or 0)+(val8 or 0)+val5
				
				local isCheck = reductionSubtable.f
				if not isCheck then
					isCheck = true
				elseif isCheck == 1 then --physical
					isCheck = val6 == 1
				elseif isCheck == 2 then --magic
					isCheck = bit_band(val6 or 0,1) == 0
				elseif isCheck == 3 then --feintCheck
					isCheck = module.db.reductionIsNotAoe[val1]
				elseif isCheck == 4 then --dampenHarmCheck
					local unitHealthMax = UnitHealthMax(destName or "?")
					unitHealthMax = unitHealthMax == 0 and 1400000 or unitHealthMax
					isCheck = (amount2 / unitHealthMax) >= 0.15
				end		
				
				if isCheck then
					local reductionGUID = reductionSubtable.g
					reduction2 = reduction[reductionGUID]
					if not reduction2 then
						reduction2 = {}
						reduction[reductionGUID] = reduction2
					end
					local reductionSpell = reductionSubtable.s
					
					local amount = amount2 * reductionSubtable.c
					
					local reductionSpellData = reduction2[reductionSpell]
					if not reductionSpellData then
						reductionSpellData = {}
						reduction2[reductionSpell] = reductionSpellData
					end
					
					reductionSpellData[active_segment] = (reductionSpellData[active_segment] or 0)+amount
				end
			end
		end
	
	
	
		--------------> Add switch
		activeTable = fightData_switch[destGUID]
		if not activeTable then
			activeTable = {
				[1]={},	--cast
				[2]={},	--target
				seen=timestamp,
			}
			fightData_switch[destGUID] = activeTable
		end
		activeTable2 = activeTable[1]
		if not activeTable2[sourceGUID] then
			activeTable2[sourceGUID] = {timestamp,val1,1}
		end
		
		

		--------------> Add special spells [tracking]
		if var_trackingDamageSpells[val1] then
			fightData.tracking[#fightData.tracking + 1] = {timestamp,sourceGUID,sourceFlags2,destGUID,destFlags2,val1,val4,val5,val6,val8,val9,val10,val14,s = active_segment}
		end
		
		
		--------------> Other
		if val1 == 196917 then	-- Light of the Martyr: effective healing fix
			local lotmData = spellFix_LotM[sourceGUID]
			if lotmData then
				local damageTaken = val4 + val5 + (val9 or 0)
				if damageTaken < (lotmData[1] + lotmData[2]) and (timestamp - lotmData[5]) < 0.2 then
					local spellTable = lotmData[3]
					if lotmData[2] == 0 then
						spellTable.amount = spellTable.amount - damageTaken
					elseif lotmData[2] >= damageTaken then
						spellTable.absorbed = spellTable.absorbed - damageTaken
					else
						spellTable.absorbed = spellTable.absorbed - lotmData[2]
						spellTable.amount = spellTable.amount - damageTaken + lotmData[2]
					end
					if lotmData[4] then
						spellTable.crit = spellTable.crit - damageTaken
					end
				end
			end
		--[[
		elseif val1 == 186439 then	-- Shadow Mend
			local spellTable = spellFix_SM[destGUID]
			if spellTable then
				local damageTaken = val4 + val5 + (val9 or 0)
				local amount = spellTable.amount
				if amount < damageTaken then
					spellTable.amount = 0
				else
					spellTable.amount = amount - damageTaken
				end
			end
		]]
		end
	
	
		if val14 then
			return spellTable
		end
	---------------------------------
	------ heal
	---------------------------------	
	elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
		--[[
		Note about healing:
		amount = healing + overhealing
		absorbed = if spell absorbed by ability (ex. DK's egg, Koragh shadow phase)
		absorbs = if spell is absorb (ex. PW:S, HPally mastery, BloodDK mastery)
		]]
		--[[
			val1	spellID
			val2	_
			val3	school
			val4	amount
			val5	overhealing
			val6	absorbed
			val7	critical
		]]
		if val6 < 0 then return end	--Fix 8.2 boss
		
		--------------> Add heal
		local activeTable = fightData_heal[sourceGUID]	--sourceTable
		if not activeTable then
			activeTable = {}
			fightData_heal[sourceGUID] = activeTable
		end
		local activeTable2 = activeTable[destGUID]		--destTable
		if not activeTable2 then
			activeTable2 = {}
			activeTable[destGUID] = activeTable2
		end
		activeTable = activeTable2[destFlags]	--destReactTable
		if not activeTable then
			activeTable = {}
			activeTable2[destFlags] = activeTable
		end
		activeTable2 = activeTable[event == "SPELL_PERIODIC_HEAL" and -val1 or val1]		--segmentsTable
		if not activeTable2 then
			activeTable2 = {}
			activeTable[event == "SPELL_PERIODIC_HEAL" and -val1 or val1] = activeTable2
		end
		local spellTable = activeTable2[active_segment]
		if not spellTable then
			spellTable = {
				amount = 0,
				over = 0,
				absorbed = 0,
				count = 0,
				crit = 0,
				critcount = 0,
				critmax = 0,
				critover = 0,
				hitmax = 0,
				absorbs = 0,
			}
			activeTable2[active_segment] = spellTable
			if val3 then
				spellsSchool[val1] = val3
			end
		end
		spellTable.amount = spellTable.amount + val4
		spellTable.over = spellTable.over + val5
		spellTable.absorbed = spellTable.absorbed + val6
		spellTable.count = spellTable.count + 1
		if val7 then
			spellTable.crit = spellTable.crit + val4 + val6
			spellTable.critcount = spellTable.critcount + 1
			if spellTable.critmax < val4 then
				spellTable.critmax = val4
			end
			spellTable.critover = spellTable.critover + val5
		elseif spellTable.hitmax < val4 then
			spellTable.hitmax = val4
		end
		
	
	
		--------------> Add death
		activeTable2 = deathLog[destGUID]
		if not activeTable2 then
			activeTable2 = {}
			for i=1,deathMaxEvents do
				activeTable2[i] = {}
			end
			activeTable2.c = 0
			deathLog[destGUID] = activeTable2
		end
		activeTable = activeTable2.c + 1
		if activeTable > deathMaxEvents then
			activeTable = 1
		end
		activeTable2.c = activeTable
		activeTable = activeTable2[activeTable]
		activeTable.t = 2
		activeTable.s = sourceGUID
		activeTable.ti = timestamp
		activeTable.sp = val1
		activeTable.a = val4
		activeTable.o = val5
		activeTable.sc = val3
		activeTable.b = nil
		activeTable.ab = val6
		activeTable.c = val7
		activeTable.ia = nil
		activeTable.sm = sourceFlags2
		activeTable.dm = destFlags2
		activeTable2 = raidGUIDs[ destGUID ]
		if activeTable2 then
			activeTable.h = UnitHealth( activeTable2 )
			activeTable.hm = UnitHealthMax( activeTable2 )
		end
						
		
		--------------> Other
		--[[
		if negateHealing[destGUID] then
			spellTable.amount = spellTable.amount - val4
			spellTable.over = spellTable.over + val4 + val6
			spellTable.absorbed = spellTable.absorbed - val6
			if val7 then
				spellTable.crit = spellTable.crit - val4 - val6
				spellTable.critcount = spellTable.critcount - 1
				spellTable.critover = spellTable.critover - val5
			end
		end
		]]
		if val1 == 183998 then	--Light of the Martyr: effective healing fix
			local lotmData = spellFix_LotM[sourceGUID]
			if not lotmData then
				lotmData = {}
				spellFix_LotM[sourceGUID] = lotmData
			end
			lotmData[1] = val4 - val5
			lotmData[2] = val6
			lotmData[3] = spellTable
			lotmData[4] = val7
			lotmData[5] = timestamp
		elseif val1 == 186263 then	--Shadow Mend: effective healing fix, remove damage from debuff
			spellFix_SM[destGUID] = spellTable
		elseif val1 == 213313 then	--Paladin: Divine intervention
			AddNotRealDeath(destGUID,timestamp,val1)
		end
		
	---------------------------------
	------ auras
	---------------------------------	
	elseif event == "SPELL_AURA_APPLIED" then
		local spellID,spellName,school,auraType = val1,val2,val3,val4
		
		--fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,auraType,1,1,s = active_segment}
		fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,bit_band(sourceFlags or 0,240) == 16,bit_band(destFlags or 0,240) == 16,spellID,auraType,1,1,s = active_segment}
		
		--------------> Add reduction
		local reduction = var_reductionAuras[spellID]
		if reduction then
			if spellID == 81782 then
				sourceGUID = module.db.reductionPowerWordBarrierCaster or sourceGUID
			elseif spellID == 194384 then
				reduction = reductionAtonement[sourceGUID] or 1
				--[[
				if ExRT.A.Inspect then
					local db = ExRT.A.Inspect.db.inspectDB
					for k,v in pairs(db) do
						if v.GUID == sourceGUID then
							if v[7] == 1 then
								reduction = 0.97
							end
							break
						end
					end
				end
				]]
			end
		
			local destData = var_reductionCurrent[ destGUID ]
			if not destData then
				destData = {}
				var_reductionCurrent[ destGUID ] = destData
			end
			local destCount = #destData
			
			local func,funcAura,reductionTable = nil
			if type(reduction)=="table" then
				reductionTable = reduction
				funcAura = reduction[3]
				func = reduction[2]
				reduction = reduction[1]
			end
			
			if funcAura then
				for i=1,40 do
					local auraName,_,count,_,_,_,_,_,_,_,_,_,_,_,_,val1,val2,val3,val4,val5 = UnitAura(destName or "?",i)
					if auraName == spellName then
						if val1 then
							reduction, func = funcAura(val1 or 0,val2 or 0,val3 or 0,val4 or 0,val5 or 0)
							if not reduction then
								reduction = reductionTable[1]
								func = reductionTable[2]
								funcAura = nil
							end
							--ExRT.F.dprint(format("%s > %s: %s [%d%%]",sourceName,destName,spellName,(reduction or 0)*100))
						else
							funcAura = nil
						end
						break
					elseif not auraName then
						break
					end
				end
			end
			
			if reduction == 1 then
				return
			end
			
			
			for i=1,destCount do
				if destData[i].s == spellID then
					local destSpell = destData[i]
	
					destSpell.r = reduction
					
					local from,fromMagic,fromPhysical = 1,1,1
					for j=1,i-1 do
						if destData[j].f == ReductionAurasFunctions.magic then
							fromMagic = fromMagic * destData[j].r
						elseif destData[j].f == ReductionAurasFunctions.physical then
							fromPhysical = fromPhysical * destData[j].r
						else
							from = from * destData[j].r
						end
					end
					
					for j=i,destCount do
						local currReduction
						if destData[j].f == ReductionAurasFunctions.magic then
							currReduction = 1 / (1 - (fromMagic - fromMagic * destData[j].r))
							fromMagic = fromMagic * destData[j].r
						elseif destData[j].f == ReductionAurasFunctions.physical then
							currReduction = 1 / (1 - (fromPhysical - fromPhysical * destData[j].r))
							fromPhysical = fromPhysical * destData[j].r
						else
							currReduction = 1 / (1 - (from - from * destData[j].r))
							from = from * destData[j].r
						end
						destData[j].c = currReduction
					end
	
					return
				end
			end
			
			local from = 1
			if func == ReductionAurasFunctions.magic then
				for i=1,destCount do
					if destData[i].f ~= ReductionAurasFunctions.physical then
						from = from * destData[i].r
					end
				end
			elseif func == ReductionAurasFunctions.physical then
				for i=1,destCount do
					if destData[i].f ~= ReductionAurasFunctions.magic then
						from = from * destData[i].r
					end
				end
			else
				for i=1,destCount do
					from = from * destData[i].r
				end
			end
			
			local currReduction = 1 / (1 - (from - from * reduction))
			destData[destCount + 1] = {
				s = spellID,
				r = reduction,
				c = (currReduction - 1),
				g = sourceGUID,
				f = func,
			}
			
			--debug_CurrentReductionToChat(destData)
			
			if school then
				spellsSchool[spellID] = school
			end
		end
		
		
		if spellID == 45181 or spellID == 211336 or spellID == 87024 or spellID == 229333 or spellID == 116888 or spellID == 209261 then	--Cheated Death, Archbishop Benedictus' Restitution, Cauterize, Sands of Time (Trinket), Shroud of Purgatory, Uncontained Fel 
			AddNotRealDeath(destGUID,timestamp,spellID)
		--elseif spellID == 243961 then	--Varimatras Disable Healing Debuff
		--	negateHealing[destGUID] = true
		end
		
		
	elseif event == "SPELL_AURA_REMOVED" then
		local spellID,_,school,auraType,amount = val1,val2,val3,val4,val5
	
		--fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,auraType,2,1,s = active_segment}
		fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,bit_band(sourceFlags or 0,240) == 16,bit_band(destFlags or 0,240) == 16,spellID,auraType,2,1,s = active_segment}
		
		if amount and amount > 0 and 
			spellID ~= 284663 --BfD: Conclave: Bwonsamdi
		then
			CLEUParser(self,nil,timestamp,"SPELL_HEAL",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,school,amount,amount,0)
		end
	
	
		--------------> Add reduction
		local reduction = var_reductionAuras[spellID]
		if reduction then
			local destData = var_reductionCurrent[ destGUID ]
			if not destData then
				return
			end
			for i=1,#destData do
				if destData[i] and destData[i].s == spellID and (destData[i].g == sourceGUID or spellID == 81782) then
					tremove(destData,i)
				end
			end
			
			local from,fromPhysical,fromMagic = 1,1,1
			for i=1,#destData do
				local spellData = destData[i]
				local currReduction = nil
				if spellData.f == ReductionAurasFunctions.magic then
					currReduction = 1 / (1 - (fromMagic - fromMagic * spellData.r))
					fromMagic = fromMagic * spellData.r
				elseif spellData.f == ReductionAurasFunctions.physical then
					currReduction = 1 / (1 - (fromPhysical - fromPhysical * spellData.r))
					fromPhysical = fromPhysical * spellData.r
				else
					currReduction = 1 / (1 - (from - from * spellData.r))
					fromPhysical = fromPhysical * spellData.r
					fromMagic = fromMagic * spellData.r
				end
				from = from * spellData.r
				spellData.c = currReduction - 1
			end
			
			--debug_CurrentReductionToChat(destData)
		end
		
		
		--------------> Other
		if spellID == 187464 then	--Shadow Mend
			spellFix_SM[destGUID] = nil
		--elseif spellID == 243961 then	--Varimatras Disable Healing Debuff
		--	negateHealing[destGUID] = nil
		end

	---------------------------------
	------ casts
	---------------------------------	
	elseif event == "SPELL_CAST_SUCCESS" then
		local spellID = val1
		
		--------------> Add cast
		local sourceTable = fightData_cast[sourceGUID]
		if not sourceTable then
			sourceTable = {}
			fightData_cast[sourceGUID] = sourceTable
		end
		sourceTable[ #sourceTable + 1 ] = {timestamp,spellID,1,destGUID,destFlags2,sourceFlags2,sourceFlags,s = active_segment}
	
	
		--------------> Add switch
		local targetTable = fightData_switch[destGUID]
		if not targetTable then
			targetTable = {
				[1]={},	--cast
				[2]={},	--target
				seen=timestamp,
			}
			fightData_switch[destGUID] = targetTable
		end
		local targetCastTable = targetTable[1]
		if not targetCastTable[sourceGUID] then
			targetCastTable[sourceGUID] = {timestamp,spellID,2}
		end
		
		
		--------------> Other
		if spellID == 62618 then	--PW:B caster fix
			module.db.reductionPowerWordBarrierCaster = sourceGUID
		elseif spellID == 98008 then	--SLT Totem
			if SLTReductionUnregTimer then
				SLTReductionUnregTimer:Cancel()
			end
			SLTReductionUnregTimer = C_Timer.NewTimer(10,SLTReductionUnreg)
			SLTReductionReg(sourceGUID)
		elseif spellID == 209471 then	--Illgynoth blossom death-cast
			return CLEUParser(self,nil,timestamp,"UNIT_DIED",true,"",nil,0,0,sourceGUID,sourceName,sourceFlags,sourceFlags2)
		end
		
	---------------------------------
	------ powers
	---------------------------------	
	elseif event == "SPELL_ENERGIZE" or event == "SPELL_PERIODIC_ENERGIZE" then
		local spellID, _, _, amount, overEnergize, powerType, alternatePowerType = val1,val2,val3,val4,val5,val6,val7
		
		local sourceData = fightData_power[destGUID]
		if not sourceData then
			sourceData = {}
			fightData_power[destGUID] = sourceData
		end
		local powerData = sourceData[powerType or 0]
		if not powerData then
			powerData = {}
			sourceData[powerType or 0] = powerData
		end
		local spellData = powerData[spellID]
		if not spellData then
			spellData = {0,0}
			powerData[spellID] = spellData
		end
		spellData[1] = spellData[1] + amount
		spellData[2] = spellData[2] + 1
	---------------------------------
	------ swing
	---------------------------------	
	elseif event == "SWING_DAMAGE" then
		return CLEUParser(self,nil,timestamp,"SPELL_DAMAGE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,6603,nil,nil,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14)
	---------------------------------
	------ aura (stacks)
	---------------------------------	
	elseif event == "SPELL_AURA_APPLIED_DOSE" then
		local spellID,_,_,type,stack = val1,val2,val3,val4,val5
		
		--fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,type,3,stack,s = active_segment}
		fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,bit_band(sourceFlags or 0,240) == 16,bit_band(destFlags or 0,240) == 16,spellID,type,3,stack,s = active_segment}
	---------------------------------
	------ cast (start)
	---------------------------------	
	elseif event == "SPELL_CAST_START" then
		local spellID = val1
		
		--------------> Add cast
		local sourceTable = fightData_cast[sourceGUID]
		if not sourceTable then
			sourceTable = {}
			fightData_cast[sourceGUID] = sourceTable
		end
		sourceTable[ #sourceTable + 1 ] = {timestamp,spellID,2,destGUID,destFlags2,sourceFlags2,sourceFlags,s = active_segment}
		
		
		
		--------------> Add switch
		if sourceName and GetUnitInfoByUnitFlag(sourceFlags,1) == 1024 then
			local unitID = UnitInRaid(sourceName)
			if unitID then
				unitID = "raid"..unitID
				local targetGUID = UnitGUID(unitID.."target")
				if targetGUID and not UnitIsPlayerOrPet(targetGUID) then
					-- Switch code
					local targetTable = fightData_switch[targetGUID]
					if not targetTable then
						targetTable = {
							[1]={},	--cast
							[2]={},	--target
							seen=timestamp,
						}
						fightData_switch[targetGUID] = targetTable
					end
					local targetCastTable = targetTable[1]
					if not targetCastTable[sourceGUID] then
						targetCastTable[sourceGUID] = {timestamp,spellID,3}
					end
					-- / Switch code
				end
			end
		end
	---------------------------------
	------ absorbs
	---------------------------------	
	elseif event == "SPELL_ABSORBED" then
		--[[
		SPELL_ABSORBED event info:
			for SWING
		timestamp,attackerGUID,attackerName,attackerFlags,attackerFlags2,destGUID,destName,destFlags,destFlags2,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount
			OR for SPELL
		timestamp,attackerGUID,attackerName,attackerFlags,attackerFlags2,destGUID,destName,destFlags,destFlags2,attackerSpellId,attackerSpellName,attackerSchool,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount
		]]

		local attackerSpellId,attackerSpellName,attackerSchool,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount
		if not val11 then
			sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount = val1,val2,val3,val4,val5,val6,val7,val8
			attackerSpellId = 6603
		else
			attackerSpellId,attackerSpellName,attackerSchool,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount = val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11
		end
		if spellID == 20711 or spellID == 115069 or spellID == 157533 then	--Not real absorbs spells
			return
		end		
		
		
		--------------> Add heal
		local sourceTable = fightData_heal[sourceGUID]
		if not sourceTable then
			sourceTable = {}
			fightData_heal[sourceGUID] = sourceTable
		end
		local destTable = sourceTable[destGUID]
		if not destTable then
			destTable = {}
			sourceTable[destGUID] = destTable
		end
		local destReactTable = destTable[destFlags]
		if not destReactTable then
			destReactTable = {}
			destTable[destFlags] = destReactTable
		end
		local segmentsTable = destReactTable[spellID]
		if not segmentsTable then
			segmentsTable = {}
			destReactTable[spellID] = segmentsTable
		end
		local spellTable = segmentsTable[active_segment]
		if not spellTable then
			spellTable = {
				amount = 0,
				over = 0,
				absorbed = 0,
				count = 0,
				crit = 0,
				critcount = 0,
				critmax = 0,
				critover = 0,
				hitmax = 0,
				absorbs = 0,
			}
			segmentsTable[active_segment] = spellTable
			spellsSchool[spellID] = school
		end
		spellTable.amount = spellTable.amount + amount
		spellTable.absorbs = spellTable.absorbs + amount
		spellTable.count = spellTable.count + 1
		if spellTable.hitmax < amount then
			spellTable.hitmax = amount
		end
		
		
		
		--------------> Add death
		local destData = deathLog[destGUID]
		if not destData then
			destData = {}
			for i=1,deathMaxEvents do
				destData[i] = {}
			end
			destData.c = 0
			deathLog[destGUID] = destData
		end
		local pos = destData.c + 1
		if pos > deathMaxEvents then
			pos = 1
		end
		local deathLine = destData[pos]
		deathLine.t = 2
		deathLine.s = sourceGUID
		deathLine.ti = timestamp
		deathLine.sp = spellID
		deathLine.a = amount
		deathLine.o = 0
		deathLine.sc = school
		deathLine.b = nil
		deathLine.ab = nil
		deathLine.c = nil
		deathLine.ia = amount
		deathLine.sm = sourceFlags2
		deathLine.dm = destFlags2		
		local player = raidGUIDs[ destGUID ]
		if player then
			deathLine.h = UnitHealth( player )
			deathLine.hm = UnitHealthMax( player )
		end
		destData.c = pos
		
		
		if spellID == 213313 then	--Paladin: Divine intervention
			AddNotRealDeath(destGUID,timestamp,spellID)
		end

	---------------------------------
	------ miss
	---------------------------------	
	elseif event == "SPELL_MISSED" or event == "RANGE_MISSED" or event == "SPELL_PERIODIC_MISSED" then
		local spellID,_,school,missType,isOffHand,amountMissed,critical = val1,val2,val3,val4,val5,val6,val7
		local newEvent = event == "SPELL_PERIODIC_MISSED" and "SPELL_PERIODIC_DAMAGE" or "SPELL_DAMAGE"
		if missType == "ABSORB" then
			CLEUParser(self,nil,timestamp,newEvent,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,0,0,school,nil,nil,amountMissed,critical,nil,nil,isOffHand)
		elseif missType == "BLOCK" then
			CLEUParser(self,nil,timestamp,newEvent,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,0,0,school,nil,amountMissed,nil,critical,nil,nil,isOffHand)
		elseif missType == "PARRY" then
			local spellTable = CLEUParser(self,nil,timestamp,newEvent,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,0,0,school,nil,nil,nil,critical,nil,nil,isOffHand,missType)
			spellTable.parry = spellTable.parry + 1
		elseif missType == "DODGE" then
			local spellTable = CLEUParser(self,nil,timestamp,newEvent,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,0,0,school,nil,nil,nil,critical,nil,nil,isOffHand,missType)
			spellTable.dodge = spellTable.dodge + 1
		else
			local spellTable = CLEUParser(self,nil,timestamp,newEvent,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,0,0,school,nil,nil,nil,critical,nil,nil,isOffHand,missType)
			spellTable.miss = spellTable.miss + 1	
		end
	elseif event == "SWING_MISSED" then
		return CLEUParser(self,nil,timestamp,"SPELL_MISSED",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,6603,nil,0x1,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14)
	---------------------------------
	------ range damage
	---------------------------------	
	elseif event == "RANGE_DAMAGE" then
		return CLEUParser(self,nil,timestamp,"SPELL_DAMAGE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14)
	---------------------------------
	------ aura (stacks)
	---------------------------------	
	elseif event == "SPELL_AURA_REMOVED_DOSE" then
		local spellID,_,_,type,stack = val1,val2,val3,val4,val5
		
		--fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,type,4,stack,s = active_segment}
		fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,bit_band(sourceFlags or 0,240) == 16,bit_band(destFlags or 0,240) == 16,spellID,type,4,stack,s = active_segment}
	---------------------------------
	------ dies
	---------------------------------	
	elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" then
		if destName and UnitIsFeignDeath(destName) then
			return
		end

		fightData.dies[#fightData.dies+1] = {destGUID,destFlags,timestamp,destFlags2,s = active_segment}
		
		if DeathLogBlackList[GUIDtoID(destGUID)] then
			return
		end
		--[[
		Death line type:
		1: damage
		2: heal
		3: death
		5: death simulation (fd, sor proc)
		]]	
			
		local destData = deathLog[destGUID]
		if not destData then
			destData = {}
			for i=1,deathMaxEvents do
				destData[i] = {}
			end
			destData.c = 0
			deathLog[destGUID] = destData
		end
		local destTable = {
			{3,destGUID,timestamp,active_segment},
		}
		local destTableLen = 1
		fightData_deathLog[#fightData_deathLog + 1] = destTable
		
		if destData.sch then
			destData.sch:Cancel()
			destData.schFunc()
		end
		
		local copyTable
		for i=destData.c,1,-1 do
			copyTable = destData[i]
			if copyTable.t then
				destTableLen = destTableLen + 1
				destTable[destTableLen] = {
					copyTable.t,
					copyTable.s,
					copyTable.ti,
					copyTable.sp,
					copyTable.a,
					copyTable.o,
					copyTable.sc,
					copyTable.b,
					copyTable.ab,
					copyTable.c,
					false,
					copyTable.h,
					copyTable.hm,
					copyTable.ia,
					copyTable.sm,
					copyTable.dm,
				}
				copyTable.t = nil
				copyTable.s = nil
				copyTable.ti = nil
				copyTable.sp = nil
				copyTable.a = nil
				copyTable.o = nil
				copyTable.sc = nil
				copyTable.b = nil
				copyTable.ab = nil
				copyTable.c = nil
				copyTable.h = nil
				copyTable.hm = nil
				copyTable.ia = nil
				copyTable.sm = nil
				copyTable.dm = nil
			end
		end
		for i=deathMaxEvents,destData.c+1,-1 do
			copyTable = destData[i]
			if copyTable.t then
				destTableLen = destTableLen + 1
				destTable[destTableLen] = {
					copyTable.t,
					copyTable.s,
					copyTable.ti,
					copyTable.sp,
					copyTable.a,
					copyTable.o,
					copyTable.sc,
					copyTable.b,
					copyTable.ab,
					copyTable.c,
					false,
					copyTable.h,
					copyTable.hm,
					copyTable.ia,
					copyTable.sm,
					copyTable.dm,
				}
				copyTable.t = nil
				copyTable.s = nil
				copyTable.ti = nil
				copyTable.sp = nil
				copyTable.a = nil
				copyTable.o = nil
				copyTable.sc = nil
				copyTable.b = nil
				copyTable.ab = nil
				copyTable.c = nil
				copyTable.h = nil
				copyTable.hm = nil
				copyTable.ia = nil
				copyTable.sm = nil
				copyTable.dm = nil
			end
		end
		destData.c = 0
	---------------------------------
	------ summons
	---------------------------------	
	elseif event == "SPELL_SUMMON" or event == "SPELL_CREATE" then
		local spellID = val1
		fightData.summons[#fightData.summons+1]={sourceGUID,destGUID,spellID,timestamp,sourceFlags2,destFlags2,s = active_segment}		
	---------------------------------
	------ dispels
	---------------------------------	
	elseif event == "SPELL_DISPEL" or event == "SPELL_STOLEN" then
		local spellID,_,_,destSpell = val1,val2,val3,val4

		fightData.dispels[#fightData.dispels+1]={sourceGUID,destGUID,spellID,destSpell,timestamp,sourceFlags2,destFlags2,s = active_segment}	
	---------------------------------
	------ cc break
	---------------------------------	
	elseif event == "SPELL_AURA_BROKEN_SPELL" or event == "SPELL_AURA_BROKEN" then
		local spellID,_,_,extraSpellId,_,_,auraType = val1,val2,val3,val4,val5,val6,val7
		
		if not auraType then
			auraType = extraSpellId		--SPELL_AURA_BROKEN instead SPELL_AURA_BROKEN_SPELL
			extraSpellId = 6603
		end
		fightData.aurabroken[#fightData.aurabroken+1]={sourceGUID,destGUID,spellID,extraSpellId,timestamp,auraType,sourceFlags2,destFlags2,s = active_segment}

	---------------------------------
	------ environmental damage
	---------------------------------	
	elseif event == "ENVIRONMENTAL_DAMAGE" then
		local environmentalType,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand = val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11
		local environmentalSpellID = environmentalType and EnvironmentalTypeToSpellID[environmentalType] or 48360
		
		return CLEUParser(self,nil,timestamp,"SPELL_DAMAGE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,environmentalSpellID,nil,nil,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand)
	---------------------------------
	------ interrupt
	---------------------------------	
	elseif event == "SPELL_INTERRUPT" then
		local spellID,_,_,destSpell = val1,val2,val3,val4
		
		fightData.interrupts[#fightData.interrupts+1]={sourceGUID,destGUID,spellID,destSpell,timestamp,sourceFlags2,destFlags2,s = active_segment}
	---------------------------------
	------ other
	---------------------------------	
	elseif event == "DAMAGE_SPLIT" then
		return CLEUParser(self,nil,timestamp,"SPELL_DAMAGE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,val11,val12,val13,val14)
	elseif event == "SPELL_RESURRECT" then
		local spellID = val1

		fightData.resurrests[#fightData.resurrests+1]={sourceGUID,destGUID,spellID,timestamp,s = active_segment}
	elseif event == "SPELL_DRAIN" or event == "SPELL_PERIODIC_DRAIN" then
		local spellID,_,_,amount,powerType = val1,val2,val3,val4,val5
		return CLEUParser(self,nil,timestamp,"SPELL_ENERGIZE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,-amount,powerType)
	elseif event == "SPELL_LEECH" or event == "SPELL_PERIODIC_LEECH" then
		local spellID,_,_,amount,powerType,extraAmount = val1,val2,val3,val4,val5,val6
		if extraAmount then
			CLEUParser(self,nil,timestamp,"SPELL_ENERGIZE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,extraAmount,powerType)
		end
		return CLEUParser(self,nil,timestamp,"SPELL_ENERGIZE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,-amount,powerType)
	elseif event == "SPELL_INSTAKILL" then
		local spellID,_,school = val1,val2,val3
		return CLEUParser(self,nil,timestamp,"SPELL_DAMAGE",hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,nil,nil,9999999,9999999,school)
	end
	
	-- DAMAGE_SHIELD
	-- DAMAGE_SHIELD_MISSED
	-- UNIT_DISSIPATES
	-- SPELL_BUILDING_DAMAGE
	-- SPELL_BUILDING_HEAL
end

function module.main:COMBAT_LOG_EVENT_UNFILTERED(_,timestamp,...)
	local timestamp = CombatLogGetCurrentEventInfo()
	if not module.db.timeFix then
		module.db.timeFix = {GetTime(),timestamp}
	end
	module.main.COMBAT_LOG_EVENT_UNFILTERED = CLEUParser
	CLEUParser(self,nil,CombatLogGetCurrentEventInfo())
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
end

function module.main:RAID_BOSS_EMOTE(msg,sender)
	local spellID = msg:match("spell:(%d+)")
	if spellID then
		fightData.chat[ #fightData.chat + 1 ] = {sender,msg,spellID,GetTime(),s = active_segment}
	end
end
module.main.RAID_BOSS_WHISPER = module.main.RAID_BOSS_EMOTE

function module.main:UNIT_TARGET(unitID)
	local targetGUID = UnitGUID(unitID.."target")
	if targetGUID and not UnitIsPlayerOrPet(targetGUID) then
		local sourceGUID = UnitGUID(unitID)
		if GetUnitTypeByGUID(sourceGUID) == 0 then
			local targetTable = fightData_switch[targetGUID]
			if not targetTable then
				targetTable = {
					[1]={},	--cast
					[2]={},	--target
					seen=module.db.timeFix and (GetTime() - module.db.timeFix[1] + module.db.timeFix[2]) or GetTime(),
				}
				fightData_switch[targetGUID] = targetTable
			end
			local targetCastTable = targetTable[2]
			if not targetCastTable[sourceGUID] then
				targetCastTable[sourceGUID] = {GetTime()}
			end
		end
		if not fightData_maxHP[targetGUID] then
			fightData_maxHP[targetGUID] = UnitHealthMax(unitID.."target")
		end
	end
end

function module.main:UPDATE_MOUSEOVER_UNIT()
	local sourceGUID = UnitGUID("mouseover")
	if sourceGUID and not fightData_maxHP[sourceGUID] then
		fightData_maxHP[sourceGUID] = UnitHealthMax("mouseover")
		
		if not guidData[sourceGUID] then
			guidData[sourceGUID] = UnitName("mouseover") or "nil"
		end
	end
end

local function GlobalRecordStart()
	if not VExRT.BossWatcher.enabled then
		return
	end
	module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')
	if fightData then
		_BW_End()
	end
	_BW_Start()
	
	print(L.BossWatcherRecordStart)
end

local function GlobalRecordEnd()
	if not VExRT.BossWatcher.enabled then
		return
	end
	_BW_End()
	module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')
	print(L.BossWatcherRecordStop)
end

function module:slash(arg)
	if arg == "bw s" or arg == "bw start" or arg == "fl s" or arg == "fl start" then
		GlobalRecordStart()
		print( ExRT.F.CreateChatLink("BWGlobalRecordEnd",GlobalRecordEnd,L.BossWatcherStopRecord), L.BossWatcherStopRecord2 )
	elseif arg == "bw e" or arg == "bw end" or arg == "fl e" or arg == "fl end" then
		GlobalRecordEnd()
	elseif arg == "bw" or arg == "fl" then
		BWInterfaceFrameLoadFunc()
	elseif arg == "bw clear" or arg == "fl clear" or arg == "bw c" or arg == "fl c" then
		module:ClearData()
		print('Cleared')
	elseif arg == "bw reset" or arg == "fl reset" then
		VExRT.BossWatcher.SAVED_DATA = nil
		print('Cleared')
	elseif arg == "bw save" or arg == "fl save" then
		VExRT.BossWatcher.saveVariables = true
		VExRT.BossWatcher.SAVED_DATA = module.db.data
		print('Saved')
	elseif arg == "bw allenergy" or arg == "fl allenergy" then
		module.db.allEnergyMode = not module.db.allEnergyMode
		print('All Energy Mode',module.db.allEnergyMode)
	elseif arg == "bw phase" or arg == "fl phase" then
		if active_phase then
			active_phase = active_phase + 1
			print('Jump to phase',active_phase)
		end
	elseif arg:find("^bw ") or arg:find("^fl ") then
		ExRT.F:FightLog_Open()
	end
end

function module:ClearData(isFirstLoad)
	module.db.lastFightID = module.db.lastFightID + 1
	module.db.nowNum = 1
	module.db.data = {
		{
			guids = {},
			raidguids = {},
			reaction = {},
			pets = {},
			encounterStartGlobal = time(),
			encounterStart = GetTime(),
			encounterEnd = GetTime()+1,
			isEnded = true,
			graphData = {},
			positionsData = {},
			segments = {
				[1] = {
					e=true,
					t=GetTime(),
				},
			},
			damage = {},
			damage_seen = {},
			heal = {},
			healFrom = {},
			switch = {},
			cast = {},
			interrupts = {},
			dispels = {},
			auras = {},
			power = {},
			dies = {},
			chat = {},
			resurrests = {},
			summons = {},
			aurabroken = {},
			deathLog = {},
			maxHP = {},
			reduction = {},
			tracking = {},	
			fightID = module.db.lastFightID,
			other = {
				roles = {},
				rolesGUID = {},
			},	
		},
	}
	if isFirstLoad then
		return
	end
	ExRT.F.ScheduleTimer(collectgarbage, 1, "collect")
	if BWInterfaceFrame and BWInterfaceFrame:IsShown() then
		BWInterfaceFrame:Hide()
		BWInterfaceFrame:Show()
	end
end

function BWInterfaceFrameLoad()
	--if InCombatLockdown() then
	--	print(L.SetErrorInCombat)
	--	return
	--end
	isBWInterfaceFrameLoaded = true

	if not module.db.data[1] then
		module:ClearData(true)
	end
	
	-- Some upvaules
	local ipairs,pairs,tonumber,tostring,format,date,min,sort,table = ipairs,pairs,tonumber,tostring,format,date,min,sort,table
	local GetSpellInfo = GetSpellInfo
	if ExRT.isClassic then
		local _GetSpellInfo = GetSpellInfo
		function GetSpellInfo(spellID)
			if type(spellID) == 'string' then
				local sN = _GetSpellInfo(spellID)
				if sN then
					return _GetSpellInfo(spellID)
				else
					return spellID,false,"Interface\\Icons\\INV_MISC_QUESTIONMARK"
				end
			else
				return _GetSpellInfo(spellID)
			end
		end
	end
	
	local CurrentFight = nil
	
	local BWInterfaceFrame_Name = 'GExRTBWInterfaceFrame'
	BWInterfaceFrame = ELib:Template("ExRTBWInterfaceFrame",UIParent)
	_G[BWInterfaceFrame_Name] = BWInterfaceFrame
	BWInterfaceFrame:SetPoint("CENTER",0,0)
	BWInterfaceFrame.HeaderText:SetText(L.BossWatcher)
	BWInterfaceFrame.backToInterface:SetText("<<")
	BWInterfaceFrame:SetMovable(true)
	BWInterfaceFrame:RegisterForDrag("LeftButton")
	BWInterfaceFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	BWInterfaceFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	BWInterfaceFrame:SetDontSavePosition(true)
		
	ELib:ShadowInside(BWInterfaceFrame)
	
	module.options.SecondFrame = BWInterfaceFrame

	BWInterfaceFrame.border = ELib:Shadow(BWInterfaceFrame,20)

	BWInterfaceFrame.DecorationLine = ELib:Frame(BWInterfaceFrame):Point("TOPLEFT",BWInterfaceFrame,0,-40):Point("BOTTOMRIGHT",BWInterfaceFrame,"TOPRIGHT",0,-60):Texture(1,1,1,1):TexturePoint('x')
	BWInterfaceFrame.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
				
	BWInterfaceFrame.backToInterface.tooltipText = L.BossWatcherBackToInterface
	BWInterfaceFrame.buttonClose.tooltipText = L.BossWatcherButtonClose
	
	BWInterfaceFrame:Hide()
	
	BWInterfaceFrame.bossButton:SetText(L.BossWatcherLastFight)
	BWInterfaceFrame.bossButton:SetWidth(BWInterfaceFrame.bossButton:GetTextWidth()+30)
	
	BWInterfaceFrame.phaseButton = ELib:Template("ExRTButtonTransparentTemplate",BWInterfaceFrame)
	BWInterfaceFrame.phaseButton:SetHeight(18)
	BWInterfaceFrame.phaseButton:SetPoint("LEFT",BWInterfaceFrame.bossButton,"RIGHT",10,0)
	BWInterfaceFrame.phaseButton:SetText(L.BossWatcherAllPhases.." |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:64:80:64:80|t")
	BWInterfaceFrame.phaseButton:SetWidth(BWInterfaceFrame.phaseButton:GetTextWidth()+30)
	
	local reportData = {{},{},{},{ {},{},{} },{},{},{},{},{}}
	local reportOptions = {}
	BWInterfaceFrame.report = ELib:Button(BWInterfaceFrame,L.BossWatcherCreateReport):Size(150,18):Point("TOPRIGHT",BWInterfaceFrame,"TOPRIGHT",-4,-18):Tooltip(L.BossWatcherCreateReportTooltip):OnClick(function ()
		local activeTab = BWInterfaceFrame.tab.selected	
			
		---Tab with mobs fix
		if activeTab == 4 then
			local activeTabOnPage = BWInterfaceFrame.tab.tabs[4].infoTabs.selected
			for i=1,#reportData[4][activeTabOnPage] do
				reportData[4][activeTabOnPage][i] = reportData[4][activeTabOnPage][i]:gsub("||","")
			end
			ExRT.F:ToChatWindow(reportData[4][activeTabOnPage])
			return		
		end
		
		for i=1,#reportData[activeTab] do
			reportData[activeTab][i] = reportData[activeTab][i]:gsub("||","")
		end
		ExRT.F:ToChatWindow(reportData[activeTab],nil,reportOptions[activeTab])
	end)
	BWInterfaceFrame.report:Hide()
	
	
	---- Helpful functions
	local function GetGUID(GUID)
		if GUID and CurrentFight.guids[GUID] and CurrentFight.guids[GUID] ~= "nil" then
			return CurrentFight.guids[GUID]
		else
			return L.BossWatcherUnknown
		end
	end
	
	local function GetPetsDB()
		return CurrentFight.pets
	end
	
	local function CloseDropDownMenus_fix()
		CloseDropDownMenus()
	end
	
	local function timestampToFightTime(time)
		if not time then
			return 0
		end
		local fixTable = CurrentFight.timeFix
		if not fixTable and module.db.timeFix then
			fixTable = module.db.timeFix
		elseif not fixTable and not module.db.timeFix then
			return 0
		end
		local res = time - (fixTable[2] - fixTable[1] + CurrentFight.encounterStart) 
		return max(res,0)
	end
	
	local function GUIDtoText(patt,GUID)
		if GUID and GUID ~= "" then
			patt = patt or "%s"
			local _type = ExRT.F.GetUnitTypeByGUID(GUID)
			if _type == 0 then
				return ""
			elseif _type == 3 or _type == 5 then
				local mobSpawnID,mobSpawnID1,mobSpawnID2,mobSpawnID3 = nil
				local spawnID = GUID:match("%-([^%-]+)$")
				if spawnID then
					mobSpawnID = tonumber(spawnID, 16)
					mobSpawnID1 = tonumber(spawnID:sub(1,5), 16) or 0
					mobSpawnID2 = tonumber(spawnID:sub(6,8), 16) or 0
					mobSpawnID3 = tonumber(spawnID:sub(9), 16) or 0
				end
				if mobSpawnID then
					--return format(patt,tostring(mobSpawnID)..", "..mobSpawnID2.."-"..mobSpawnID1)
					return format(patt,mobSpawnID2.."-"..mobSpawnID3.."-"..mobSpawnID1)
				else
					return format(patt,GUID)
				end
			else
				return format(patt,GUID)
			end
		else
			return ""
		end
	end
	
	local function SetSchoolColorsToLine(self,school)
		local isNotGradient = ExRT.F.table_find(module.db.schoolsDefault,school) or school == 0 or module.db.schoolsColors[school or -1]
		local isConfirmedGradient = module.db.schoolsColorsGradient[ school or -1 ]
		if isNotGradient and module.db.schoolsColors[school] then
			self:SetVertexColor(module.db.schoolsColors[school].r,module.db.schoolsColors[school].g,module.db.schoolsColors[school].b, 1)
		elseif isConfirmedGradient then
			local school1,school2 = isConfirmedGradient[1],isConfirmedGradient[2]
			self:SetVertexColor(1,1,1,1)
			self:SetGradientAlpha("HORIZONTAL", module.db.schoolsColors[school1].r,module.db.schoolsColors[school1].g,module.db.schoolsColors[school1].b,1,module.db.schoolsColors[school2].r,module.db.schoolsColors[school2].g,module.db.schoolsColors[school2].b,1)
		else
			local school1,school2 = nil
			for i=1,#module.db.schoolsDefault do
				local isSchool = bit.band(school,module.db.schoolsDefault[i]) > 0
				if isSchool and not school1 then
					school1 = module.db.schoolsDefault[i]
				elseif isSchool and not school2 then
					school2 = module.db.schoolsDefault[i]
				end
			end
			if school1 and school2 then
				self:SetVertexColor(1,1,1,1)
				self:SetGradientAlpha("HORIZONTAL", module.db.schoolsColors[school1].r,module.db.schoolsColors[school1].g,module.db.schoolsColors[school1].b,1,module.db.schoolsColors[school2].r,module.db.schoolsColors[school2].g,module.db.schoolsColors[school2].b,1)
			elseif school1 and not school2 then
				self:SetVertexColor(module.db.schoolsColors[school1].r,module.db.schoolsColors[school1].g,module.db.schoolsColors[school1].b, 1)
			else
				self:SetVertexColor(0.8,0.8,0.8, 1)
			end
		end
	end
	local function GetSchoolName(school)
		if not school or module.db.schoolsNames[school]	then
			return  module.db.schoolsNames[school or 0]
		else
			local school1,school2 = nil
			for i=1,#module.db.schoolsDefault do
				local isSchool = bit.band(school,module.db.schoolsDefault[i]) > 0
				if isSchool and not school1 then
					school1 = module.db.schoolsDefault[i]
				elseif isSchool and not school2 then
					school2 = module.db.schoolsDefault[i]
				end
			end
			if school1 and school2 then
				return module.db.schoolsNames[school1] .. "-" .. module.db.schoolsNames[school2]
			elseif school1 and not school2 then
				return module.db.schoolsNames[school1]
			else
				return module.db.schoolsNames[0]
			end
		end
	end
	local function GetUnitInfoByUnitFlagFix(unitFlag,infoType)
		if not unitFlag then
			return
		end
		return GetUnitInfoByUnitFlag(unitFlag,infoType)
	end
	local function GetFightLength(full)
		if full then
			if not CurrentFight.isEnded then
				return GetTime() - CurrentFight.encounterStart
			end
			return (CurrentFight.encounterEnd - CurrentFight.encounterStart)
		end
		local length = 0
		for i=1,#CurrentFight.segments do
			if CurrentFight.segments[i].e then
				length = length - CurrentFight.segments[i].t + (CurrentFight.segments[i+1] and CurrentFight.segments[i+1].t or (CurrentFight.isEnded and CurrentFight.encounterEnd or GetTime()) )
			end
		end
		if length == 0 then
			length = 0.01
		end
		return length
	end
	local function SubUTF8String(str,len)
		local strlen = ExRT.F:utf8len(str)
		if strlen > len then
			str = ExRT.F:utf8sub(str,1,len) .. "..."
		end
		return str
	end
	local function GetFightID(data,short)
		local r = tostring(data.encounterStart)
		if short then
			r = r .. "-" .. GetFightLength(true)
		else
			for i=1,#data.segments or {} do
				if data.segments[i].e then
					r = r .. "," .. i
				end
			end
		end
		return r
	end
		
	---- Locals for functions in code below
	local SpellsPage_GetCastsNumber,AurasPage_IsAuraOn,Graph_AutoUpdateStep = nil


	
	---- Bugfix functions
	local _GetSpellLink = GetSpellLink
	local function GetSpellLink(spellID)
		local link = _GetSpellLink(spellID)
		if link then
			return link
		end
		local spellName = GetSpellInfo(spellID)
		return spellName or "Unk"
	end
	
	---- Update functions
	local function UpdateSegments(start,ending,isAdd,disableReload)
		if isAdd and start and ending then
			for i=1,#CurrentFight.segments do
				if (i>=start and i<=ending) then
					CurrentFight.segments[i].e = true
				end
			end
		else
			for i=1,#CurrentFight.segments do
				CurrentFight.segments[i].e = not start or not ending or (i>=start and i<=ending)
			end
		end
		if not disableReload then
			BWInterfaceFrame:Hide()
			BWInterfaceFrame:Show()	 
		end
	end
	local function UpdateSegments_SelectPhase(phase)
		local minX,maxX = #CurrentFight.segments,1
		for i=1,#CurrentFight.segments do
			CurrentFight.segments[i].e = CurrentFight.segments[i].p == phase
			if CurrentFight.segments[i].p == phase then
				if i < minX then
					minX = i
				end
				if i > maxX then
					maxX = i
				end
			end
		end
		if minX ~= #CurrentFight.segments or maxX ~= 1 then
			BWInterfaceFrame.GraphFrame.G.ZoomMinX = minX - 1
			BWInterfaceFrame.GraphFrame.G.ZoomMaxX = maxX + 1
		end
		BWInterfaceFrame:Hide()
		BWInterfaceFrame:Show()
	end
	
	local function UpdateSegmentsTime(start,ending,isAdd,disableReload)
		local s,e = nil,nil
		local totalSegments = #CurrentFight.segments
		for j=1,totalSegments - 1 do
			if CurrentFight.segments[j].t <= start and CurrentFight.segments[j+1].t > start and not s then
				s = j
				e = j
			elseif CurrentFight.segments[j].t <= ending and CurrentFight.segments[j+1].t > ending and s then
				e = j
				break
			end
		end
		if ending > CurrentFight.segments[totalSegments].t then
			e = totalSegments
		end
		if s and e then
			UpdateSegments(s,e,isAdd,disableReload)
		end
	end	
	
	
	
	
	BWInterfaceFrame:SetScript("OnShow",function (self)
		local fightData = module.db.data[module.db.nowNum]
		local fightID = GetFightID(fightData)
		if self.nowFightID ~= fightID then
			CurrentFight = fightData
			local isInRecording = not fightData.isEnded
			if isInRecording then
				fightData.encounterEnd = GetTime()
				--print(L.BossWatcherCombatError)
				--return
			end
			self.nowFightID = fightID
			fightData.fightID = fightID
			local nowFightIDShort = GetFightID(CurrentFight,true)
			if nowFightIDShort ~= self.nowFightIDShort then
				BWInterfaceFrame.phaseButton:SetText(L.BossWatcherAllPhases.." |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:64:80:64:80|t")
				BWInterfaceFrame.phaseButton:SetWidth(BWInterfaceFrame.phaseButton:GetTextWidth()+30)
			end
			self.nowFightIDShort = nowFightIDShort
			local _time = ((isInRecording and GetTime() or fightData.encounterEnd) - fightData.encounterStart)
			self.bossButton:SetText( (fightData.encounterName or L.BossWatcherLastFight)..date(": %H:%M - ", fightData.encounterStartGlobal )..date("%H:%M", fightData.encounterStartGlobal + _time )..format(" (%dm%02ds)",floor(_time/60),_time%60 )..(isInRecording and " *" or "").." |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:64:80:64:80|t" )
			self.bossButton:SetWidth(self.bossButton:GetTextWidth()+30)
			for i=1,#reportData do
				if i ~= 4 then
					wipe(reportData[i])
				else
					wipe(reportData[4][1])
					wipe(reportData[4][2])
					wipe(reportData[4][3])
				end
			end
			if CurrentFight.segments.phaseNames then
				BWInterfaceFrame.phaseButton:Show()
			else
				BWInterfaceFrame.phaseButton:Hide()
			end
		end
		BWInterfaceFrame.tab:Show()
	end)
	BWInterfaceFrame:SetScript("OnHide",function (self)
		BWInterfaceFrame.tab:Hide()
	end)
	
	BWInterfaceFrame.bossButtonDropDown = CreateFrame("Frame", BWInterfaceFrame_Name.."BossButtonDropDown", nil, "UIDropDownMenuTemplate")
	BWInterfaceFrame.bossButton:SetScript("OnClick",function (self)
		local fightsList = {
			{
				text = L.BossWatcherSelectFight, 
				isTitle = true, 
				notCheckable = true, 
				notClickable = true 
			},
		}
		for i=1,#module.db.data do
			local colorCode = ""
			if i == module.db.nowNum then
				colorCode = "|cff00ff00"
			end
			local fightData = module.db.data[i]
            fightData.encounterStart = fightData.encounterStart or 0
            fightData.encounterStartGlobal = fightData.encounterStartGlobal or 0
			local _time = (fightData.isEnded and fightData.encounterEnd or GetTime()) - fightData.encounterStart
			fightsList[#fightsList + 1] = {
				text = i..". "..colorCode..(fightData.encounterName or L.BossWatcherLastFight)..date(": %H:%M - ", fightData.encounterStartGlobal )..date("%H:%M", fightData.encounterStartGlobal + _time )..format(" (%dm%02ds)",floor(_time/60),_time%60 )..(fightData.isEnded and "" or " *"),
				notCheckable = true,
				func = function() 
					module.db.nowNum = i
					self:SetText( (fightData.encounterName or L.BossWatcherLastFight)..date(": %H:%M - ", fightData.encounterStartGlobal )..date("%H:%M", fightData.encounterStartGlobal + _time )..format(" (%dm%02ds)",floor(_time/60),_time%60 )..(fightData.isEnded and "" or " *").." |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:64:80:64:80|t" )
					self:SetWidth(self:GetTextWidth()+30)
					if not fightData.isEnded then
						BWInterfaceFrame.nowFightID = -1
					end
					BWInterfaceFrame:Hide()
					BWInterfaceFrame:Show()
				end,
			}
		end
		fightsList[#fightsList + 1] = {
			text = L.cd2HistoryClear,
			notCheckable = true,
			func = function()
				StaticPopupDialogs["EXRT_FIGHTLOG_CLEAR"] = {
					text = L.cd2HistoryClear,
					button1 = L.YesText,
					button2 = L.NoText,
					OnAccept = function()
						module:ClearData()
					end,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,
				}
				StaticPopup_Show("EXRT_FIGHTLOG_CLEAR")
			end,
		}
		fightsList[#fightsList + 1] = {
			text = L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = CloseDropDownMenus_fix,
		}
		EasyMenu(fightsList, BWInterfaceFrame.bossButtonDropDown, "cursor", 10 , -15, "MENU")
	end)
	BWInterfaceFrame.bossButton.tooltipText = L.BossWatcherSelectFight
	
	BWInterfaceFrame.phaseButton:SetScript("OnClick",function (self)
		local fightsList = {
			{
				text = L.BossWatcherAllPhases,
				notCheckable = true,
				func = function() 
					self:SetText( L.BossWatcherAllPhases.." |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:64:80:64:80|t" )
					self:SetWidth(self:GetTextWidth()+30)
					UpdateSegments()
				end,
			}
		}
		for i=1,#CurrentFight.segments.phaseNames do
			local name = CurrentFight.segments.phaseNames[i]
			if type(name)=='number' then
				if name < 0 then
					local ej_name = EJ_GetSectionInfo(-name)
					if ej_name then
						name = ej_name
					else
						name = L.BossWatcherPhase.." "..i
					end
				else
					name = L.BossWatcherPhase.." "..i
				end
			end
			fightsList[#fightsList + 1] = {
				text = name,
				notCheckable = true,
				func = function() 
					self:SetText( name.." |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:64:80:64:80|t" )
					self:SetWidth(self:GetTextWidth()+30)
					UpdateSegments_SelectPhase(i)
				end,
			}
		end
		fightsList[#fightsList + 1] = {
			text = L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = CloseDropDownMenus_fix,
		}
		EasyMenu(fightsList, BWInterfaceFrame.bossButtonDropDown, "cursor", 10 , -15, "MENU")
	end)
	
	
	---- Tabs
	BWInterfaceFrame.tab = ELib:Tabs(BWInterfaceFrame,0,
		L.BossWatcherTabMobs,
		L.BossWatcherTabHeal,
		L.BossWatcherTabBuffsAndDebuffs,
		L.BossWatcherTabEnemy,
		L.BossWatcherTabPlayersSpells,
		L.BossWatcherTabEnergy,
		L.BossWatcherTabInterruptAndDispelShort,
		L.BossWatcherDeath,
		L.BossWatcherPositions,
		OTHER,
		L.BossWatcherTabSettings
	):Size(865,600):Point("TOP",0,-60):SetTo(1)

	BWInterfaceFrame.tab.tabs[7].button.tooltip = L.BossWatcherTabInterruptAndDispel
	BWInterfaceFrame.tab:SetBackdropBorderColor(0,0,0,0)
	BWInterfaceFrame.tab:SetBackdropColor(0,0,0,0)
	
	for i=1,#BWInterfaceFrame.tab.tabs do
		BWInterfaceFrame.tab.tabs[i].button.Left:SetWidth(11)
		BWInterfaceFrame.tab.tabs[i].button.Right:SetWidth(11)
	end
	
	BWInterfaceFrame.tab:Hide()
	
	---- Settings tab-button
	BWInterfaceFrame.tab.tabs[11]:SetScript("OnShow",function (self)
		if not module.options.isLoaded then
			--if InCombatLockdown() then
			--	print(L.SetErrorInCombat)
			--	return
			--end
			module.options:Load()
			module.options:SetScript("OnShow",nil)
			module.options.isLoaded = true
		end
		module.options:SetParent(self)
		module.options:ClearAllPoints()
		module.options:SetAllPoints(self)
		module.options:Show()
	end)	
		

	---- TimeLine Frame
	BWInterfaceFrame.timeLineFrame = CreateFrame('Frame',nil,BWInterfaceFrame.tab)
	BWInterfaceFrame.timeLineFrame.width = 858
	BWInterfaceFrame.timeLineFrame:SetSize(BWInterfaceFrame.timeLineFrame.width,60)
	
	local TimeLine_Pieces = 60
	local function TimeLinePieceOnEnter(self)
		if self.tooltip and #self.tooltip > 0 then
			ELib.Tooltip.Show(self,"ANCHOR_RIGHT",L.BossWatcherTimeLineTooltipTitle..":",unpack(self.tooltip))
		end
	end
	local UpdateTimeLine, TimeLineFrame_ImprovedSelectSegment_GetSelected, TimeLineFrame_ImprovedSelectSegment_OnUpdate, TimeLineFrame_ImprovedSelectSegment_OnUpdate_Passive = nil
	do
		local TLframe = CreateFrame("Frame",nil,BWInterfaceFrame.timeLineFrame)
		BWInterfaceFrame.timeLineFrame.timeLine = TLframe
		TLframe:SetSize(BWInterfaceFrame.timeLineFrame.width,30)
		TLframe:SetPoint("TOP",0,0)
		do
			local tlWidth = BWInterfaceFrame.timeLineFrame.width/TimeLine_Pieces
			for i=1,TimeLine_Pieces do
				TLframe[i] = CreateFrame("Frame",nil,TLframe)
				TLframe[i]:SetSize(tlWidth,30)
				TLframe[i]:SetPoint("TOPLEFT",(i-1)*tlWidth,0)
				TLframe[i]:SetScript("OnEnter",TimeLinePieceOnEnter)
				TLframe[i]:SetScript("OnLeave",ELib.Tooltip.Hide)
			end
		end
		TLframe.texture = TLframe:CreateTexture(nil, "BACKGROUND",nil,0)
		--TLframe.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\bar9.tga")
		--TLframe.texture:SetVertexColor(0.3, 1, 0.3, 1)
		TLframe.texture:SetColorTexture(1, 1, 1, 1)
		TLframe.texture:SetGradientAlpha("VERTICAL",1,0.82,0,.7,0.95,0.65,0,.7)
		TLframe.texture:SetAllPoints()
		
		TLframe.textLeft = ELib:Text(TLframe,"",12):Size(200,16):Point("BOTTOMLEFT",TLframe,"BOTTOMLEFT", 2, 2):Top():Color():Shadow()
		TLframe.textCenter = ELib:Text(TLframe,"",12):Size(200,16):Point("BOTTOM",TLframe,"BOTTOM", 0, 2):Top():Center():Color():Shadow()
		TLframe.textRight = ELib:Text(TLframe,"",12):Size(200,16):Point("BOTTOMRIGHT",TLframe,"BOTTOMRIGHT", -2, 2):Top():Right():Color():Shadow()
		
		TLframe.lifeUnderLine = TLframe:CreateTexture(nil, "BACKGROUND")
		TLframe.lifeUnderLine:SetColorTexture(1,1,1,1)
		TLframe.lifeUnderLine:SetGradientAlpha("VERTICAL", 1,0.2,0.2, 0, 1,0.2,0.2, 0.7)
		TLframe.lifeUnderLine._SetPoint = TLframe.lifeUnderLine.SetPoint
		TLframe.lifeUnderLine.SetPoint = function(self,start,_end)
			self:ClearAllPoints()
			self:_SetPoint("TOPLEFT",self:GetParent(),"BOTTOMLEFT",start*BWInterfaceFrame.timeLineFrame.width,0)
			self:SetSize((_end-start)*BWInterfaceFrame.timeLineFrame.width,16)
			self:Show()
		end
		
		TLframe.arrow = CreateFrame("Frame",nil,TLframe)
		TLframe.arrow:SetSize(21,30)
		TLframe.arrow.G1 = TLframe.arrow:CreateTexture(nil, "BACKGROUND",nil,4)
		TLframe.arrow.G1:SetSize(4,30)
		TLframe.arrow.G1:SetPoint("LEFT",2,0)
		TLframe.arrow.G1:SetColorTexture(0,1,0)
		TLframe.arrow.G2 = TLframe.arrow:CreateTexture(nil, "BACKGROUND",nil,5)
		TLframe.arrow.G2:SetSize(2,30)
		TLframe.arrow.G2:SetPoint("LEFT",0,0)
		TLframe.arrow.G2:SetColorTexture(1,1,1)
		TLframe.arrow.G3 = TLframe.arrow:CreateTexture(nil, "BACKGROUND",nil,4)
		TLframe.arrow.G3:SetSize(15,30)
		TLframe.arrow.G3:SetPoint("LEFT",6,0)
		TLframe.arrow.G3:SetColorTexture(1,1,1)
		TLframe.arrow.G3:SetGradientAlpha("HORIZONTAL",0,1,0,1,0,1,0,0)
		TLframe.arrow:Hide()
	
		TLframe.timeSegments = {}
		local function TimeLine_UpdateSegments()
			local count = 0
			local totalSegments = #CurrentFight.segments
			for i=1,totalSegments do
				if CurrentFight.segments[i].e then
					count = count + 1
				end
			end

			if count == totalSegments then
				for i=1,#TLframe.timeSegments do
					TLframe.timeSegments[i]:Hide()
				end
				TLframe.ImprovedSelectSegment.ResetZoom:Hide()
			else
				local fightDuration = GetFightLength(true)
				local tlWidth,tlHeight = TLframe:GetWidth(),TLframe:GetHeight()
				for i=1,totalSegments do
					if not TLframe.timeSegments[i] then
						TLframe.timeSegments[i] = TLframe:CreateTexture(nil, "BACKGROUND",nil,1)
						TLframe.timeSegments[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\bar9.tga")
						TLframe.timeSegments[i]:SetVertexColor(0.8, 0.8, 0.8, 1)
					end
					if CurrentFight.segments[i].e then
						TLframe.timeSegments[i]:Hide()
					else
						local timeStart = CurrentFight.segments[i].t - CurrentFight.encounterStart
						local timeEnd = (CurrentFight.segments[i+1] and CurrentFight.segments[i+1].t or (not CurrentFight.isEnded and GetTime() or CurrentFight.encounterEnd)) - CurrentFight.encounterStart
						local startPos = timeStart/fightDuration*tlWidth
						local endPos = timeEnd/fightDuration*tlWidth
						TLframe.timeSegments[i]:SetPoint("TOPLEFT",startPos,0)
						TLframe.timeSegments[i]:SetSize(max(endPos-startPos,0.5),tlHeight)
						TLframe.timeSegments[i]:Show()
					end
				end
				for i=totalSegments + 1,#TLframe.timeSegments do
					TLframe.timeSegments[i]:Hide()
				end
				TLframe.ImprovedSelectSegment.ResetZoom:Show()
			end
		end
	
		TLframe.labels = {}
		function TLframe:AddLabel(i,pos,type)
			local label = TLframe.labels[i]
			if not label then
				label = TLframe:CreateTexture(nil, "BACKGROUND")
				TLframe.labels[i] = label
				label:SetSize(3,25)
			end
			label:SetPoint("TOP",TLframe,"BOTTOMLEFT",BWInterfaceFrame.timeLineFrame.width*pos,0)
			if not type then
				label:SetColorTexture(.35,.38,1,.7)
			elseif type == 1 then
				label:SetColorTexture(.2,1,0,1)
			elseif type == 2 then
				label:SetColorTexture(1,.25,.3,.7)
			end
			label:Show()
		end
		function TLframe:HideLabels()
			for i=1,#TLframe.labels do
				TLframe.labels[i]:Hide()
			end
		end
		
		local EncountersPhases = {
			[1785] = {
				cast = {
					[182055] = {phase = -11394},
					[182066] = {phase = -11393},
				},
			},	--"Iron Reaver"
			[1787] = {
				chat = {
					[181293] = {phase = -11119},
					[181297] = {phase = -11120},
					[181300] = {phase = -11122},
				},
			},	--"Kormrok"
			[1783] = {
				cast = {
					[181973] = {phase = -11542},
				},
				aura = {
					[181973] = {phase = 1, isFade = true,},
				},
			},	--"Gorefiend"
			[1788] = {
				cast = {
					[181873] = {phase = 2, next = {
						isCastStart = true,
						time = 40,
						phase = 1,
					}},
				},
			},	--"Shadow-Lord Iskar"
			[1794] = {
				cast = {
					[183023] = {phase = -11451},
				},
			},	--"Socrethar the Eternal"
			[1777] = {
				cast = {
					[179681] = {phase = -11107},
					[179668] = {phase = -11840, next = {
						time = 35,
						phase = -11095,
					}},
				},			
			},	--"Fel Lord Zakuun"
			[1784] = {
				cast = {
					[181718] = {phase = -11151},
					[179986] = {phase = -11158},
					[179991] = {phase = -11166},
				},
			},	--"Tyrant Velhari"
			[1800] = {
				hp = {
					{hp = 0.205,phase = -11741,},
				},
			},	--"Xhul'horac"
			[1795] = {
				hp = {
					{hp = 0.999,phase = -11207,},
					{hp = 0.655,phase = -11219,},
					{hp = 0.355,phase = -11245,},
				},
			},	--"Mannoroth"
			[1799] = {
				hp = {
					{hp = 0.705,phase = -11590,},
					{hp = 0.405,phase = -11599,},
				},
			},	--"Archimonde"
			
			--Emerald
			
			[1853] = {
				cast = {
					[203552] = {phase = -12744, isCastStart = true,},
				},
				aura = {
					[203552] = {phase = 1, isFade = true,},
				},
			},	--"Plague Dragon": <Nythendra>
			[1841] = {
				aura = {
					[198388] = {phase = -12740,},
				},
			},	--"Ursoc"
			[1873] = {
				cast = {
					[210781] = {phase = -13192, isCastStart = true,},
					[209915] = {phase = -13184,},
				},
			},	--"Il'gynoth, The Heart of Corruption"
			[1854] = {
				hp = {
					{hp = 0.705,phase = 2,},
					{hp = 0.405,phase = 3,},
				},
			},	--"Dragons of Nightmare"
			[1876] = {
				cast = {
					[210547] = {phase = 1,},
				}
			},	--"Elerethe Renferal"
			[1877] = {
				cast = {
					[212726] = {phase = -13487,},
				},
			},	--"Cenarius"
			[1864] = {
				hp = {
					{hp = 0.655,phase = -13152,},
					{hp = 0.305,phase = -13160,},
				},
			},	--"Xavius"
			[1866] = {
				hp = {
					{hp = 0.855,phase = 1,},
					{hp = 0.705,phase = 2,},
					{hp = 0.555,phase = 3,},
					{hp = 0.405,phase = 4,},
					{hp = 0.105,phase = 5,},
				},			
			},	--"Guldan" [temp]
		}
		
		TLframe.redLine = {}
		local function CreateRedLine(i)
			TLframe.redLine[i] = TLframe:CreateTexture(nil, "BACKGROUND",nil,3)
			TLframe.redLine[i]:SetColorTexture(0.7, 0.1, 0.1, 0.5)
			TLframe.redLine[i]:SetSize(2,30)
		end
		
		TLframe.blueLine = {}
		local function CreateBlueLine(i)
			TLframe.blueLine[i] = TLframe:CreateTexture(nil, "BACKGROUND",nil,4)
			TLframe.blueLine[i]:SetColorTexture(0.1, 0.1, 0.7, 0.5)
			TLframe.blueLine[i]:SetSize(3,30)
		end
		
		TLframe.phaseMarker = {}
		TLframe.phaseMarkerNum = 0
		TLframe.phaseMarkerMax = 0
		
		local function AddPhase(pos,phase)
			local currNum = TLframe.phaseMarkerNum + 1
			TLframe.phaseMarkerNum = currNum
			
			local l,l2,t = TLframe.phaseMarker[currNum],TLframe.phaseMarker[currNum+0.5],TLframe.phaseMarker[-currNum]
			if not l then
				l = TLframe:CreateTexture(nil, "BACKGROUND",nil,5)
				TLframe.phaseMarker[currNum] = l
				l:SetSize(2,30)
				l:SetColorTexture(1, 1, 1, 0.8)
				
				l2 = TLframe:CreateTexture(nil, "BACKGROUND",nil,5)
				TLframe.phaseMarker[currNum+0.5] = l2
				l2:SetSize(1,30)
				l2:SetColorTexture(0, 0, 0, 0.8)
				l2:SetPoint("TOPLEFT",l,"TOPRIGHT",0,0)
				
				t = ELib:Text(TLframe,"",10):Point("TOPLEFT",l,"TOPRIGHT",2,-1):Point("TOPRIGHT",TLframe,"TOPRIGHT",0,-1):Point("BOTTOM",TLframe):Left():Top():Color(1,1,1,1)
				t:SetMaxLines(1)
				TLframe.phaseMarker[-currNum] = t
				
				TLframe.phaseMarkerMax = max(currNum,TLframe.phaseMarkerMax)
			end
			local t_pos = BWInterfaceFrame.timeLineFrame.width * pos
			l:SetPoint("TOPLEFT",t_pos,0)
			t.pos = t_pos
			local phaseText = nil
			if type(phase)=='number' and phase < 0 then
				local name = EJ_GetSectionInfo(-phase)
				if name then
					phaseText = name
				end
			elseif type(phase)=='string' then
				phaseText = phase
			end
			local secondString 
			if currNum > 1 then
				local prev = TLframe.phaseMarker[-(currNum-1)]
				if prev.pos + prev:GetStringWidth() > t_pos then
					secondString = "|n"
				end
			end
			t:SetText((secondString or "")..(phaseText or (L.BossWatcherPhase.." "..phase)))
			if secondString then
				t:SetMaxLines(2)
			else
				t:SetMaxLines(1)
			end
			l:Show()
			l2:Show()
			t:Show()
		end
		
		function UpdateTimeLine()
			local fight_dur = GetFightLength(true)
			if fightData and fight_dur < 1.5 then
				fight_dur = GetTime() - CurrentFight.encounterStart
			end
			TLframe.textLeft:SetText( date("%H:%M:%S", CurrentFight.encounterStartGlobal) )
			TLframe.textRight:SetText( date("%M:%S", fight_dur) )
			TLframe.textCenter:SetText( date("%M:%S", fight_dur / 2) )
			
			TLframe.ImprovedSelectSegment:Show()
			for i=1,TimeLine_Pieces do
				TLframe[i]:Hide()
			end
			
			TLframe.phaseMarkerNum = 0
			for i=1,TLframe.phaseMarkerMax do
				TLframe.phaseMarker[i]:Hide()
				TLframe.phaseMarker[i+0.5]:Hide()
				TLframe.phaseMarker[-i]:Hide()
			end
			local CurrentEncountersPhases = CurrentFight.encounterID and EncountersPhases[CurrentFight.encounterID] or ExRT.NULL
			
			if CurrentFight.segments.phaseNames then
				local prev = CurrentFight.segments[1].p
				for i=2,#CurrentFight.segments do
					local sData = CurrentFight.segments[i]
					if prev ~= sData.p then
						local _time = sData.t - CurrentFight.encounterStart
						prev = sData.p
						
						local name = CurrentFight.segments.phaseNames[prev]
						if type(name)=='number' then
							if name < 0 then
								local ej_name = EJ_GetSectionInfo(-name)
								if ej_name then
									name = ej_name
								else
									name = L.BossWatcherPhase.." "..i
								end
							else
								name = L.BossWatcherPhase.." "..i
							end
						end
						
						AddPhase(_time / fight_dur,name or prev)
					end
				end
				CurrentEncountersPhases = ExRT.NULL
			end
	
			local redLineNum = 0
			for i=1,TimeLine_Pieces do
				if not TLframe[i].tooltip then
					TLframe[i].tooltip = {}
				end
				wipe(TLframe[i].tooltip)
			end
			
			if CurrentEncountersPhases.aura then
				local phasesAuras = CurrentEncountersPhases.aura
				for i,data in ipairs(CurrentFight.auras) do
					if phasesAuras[ data[6] ] then
						local phaseData = phasesAuras[ data[6] ]
						if (phaseData.isFade and data[8] == 2) or (not phaseData.isFade and data[8] == 1) then
							local _time = timestampToFightTime(data[1])
							AddPhase(_time / fight_dur,phaseData.phase)
						end
					end
				end
			end
			
			local addToToolipTable = {}
			local bossHpPerSegment = {}
			if CurrentFight.graphData then
				local lastSec = 0
				for sec,data in pairs(CurrentFight.graphData) do
					lastSec = max(lastSec,sec)
				end
				local antiSpam = {}
			
				local phaseHpStart = 1
				for sec=1,lastSec do
					local data = CurrentFight.graphData[sec]
					if data then
						local boss1 = data["boss1"]
						if boss1 then
							local hpMax = boss1.hpmax
							if hpMax ~= 0 and boss1.health then
								local tooltipIndex = sec / fight_dur
								tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
								
								local hp = boss1.health/hpMax
								if not bossHpPerSegment[tooltipIndex] then
									bossHpPerSegment[tooltipIndex] = (boss1.name or "boss1").."'s hp: "..format("%.1f%%",hp*100)
								end
								if CurrentEncountersPhases.hp then
									for i=phaseHpStart,#CurrentEncountersPhases.hp do
										local data = CurrentEncountersPhases.hp[i]
										if hp <= data.hp then
											AddPhase(sec / fight_dur,data.phase)
											phaseHpStart = i+1
											break
										end
									end
								end
							end
						end
						for i=2,5 do
							local boss = data["boss"..i]
							if boss then
								local hpMax = boss.hpmax
								if hpMax ~= 0 and boss.health then
									local hp = boss.health/hpMax
									local str = (boss.name or "boss"..i).."'s hp: "..format("%.1f%%",hp*100)
									
									local tooltipIndex = sec / fight_dur
									tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
									
									antiSpam[tooltipIndex] = antiSpam[tooltipIndex] or {}
									
									if not antiSpam[tooltipIndex]["boss"..i] then
										if not bossHpPerSegment[tooltipIndex] then
											bossHpPerSegment[tooltipIndex] = str
										else
											bossHpPerSegment[tooltipIndex] = bossHpPerSegment[tooltipIndex] .. "|n" .. str 
										end
										antiSpam[tooltipIndex]["boss"..i] = true
									end
								end
							end
						end
					end
				end
			end
			for mobGUID,mobData in pairs(CurrentFight.cast) do
				for i=1,#mobData do
					local castData = mobData[i]
					if castData[7] and ExRT.F.GetUnitInfoByUnitFlag(castData[7],3) ~= 16 then
						local _time = timestampToFightTime(castData[1])
						
						local tooltipIndex = _time / fight_dur
						
						if CurrentEncountersPhases.cast then
							local phaseData = CurrentEncountersPhases.cast[ castData[2] ]
							if phaseData and ((phaseData.isCastStart and castData[3] == 2) or (not phaseData.isCastStart and castData[3] == 1)) then
								AddPhase(tooltipIndex,phaseData.phase)
							end
							if phaseData and phaseData.next and ((phaseData.next.isCastStart and castData[3] == 2) or (not phaseData.next.isCastStart and castData[3] == 1)) then
								local newTime = _time + phaseData.next.time
								if newTime < fight_dur then
									AddPhase(newTime / fight_dur,phaseData.next.phase)
								end
							end
						end
						
						if CurrentFight.segments[castData.s].e then
							redLineNum = redLineNum + 1
							if not TLframe.redLine[redLineNum] then
								CreateRedLine(redLineNum)
							end
							TLframe.redLine[redLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
							TLframe.redLine[redLineNum]:Show()
							
							tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
							
							local spellName,_,spellTexture = GetSpellInfo(castData[2])
							
							local targetInfo = ""
							if castData[4] and castData[4] ~= "" then
								targetInfo = " "..L.BossWatcherTimeLineOnText.." |c"..ExRT.F.classColorByGUID(castData[4])..GetGUID(castData[4]).."|r"
							end
							
							addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] |c"..ExRT.F.classColorByGUID(mobGUID) .. GetGUID(mobGUID) .."|r" .. GUIDtoText("(%s)",mobGUID) .. ( castData[3] == 1 and " "..L.BossWatcherTimeLineCast.." " or " "..L.BossWatcherTimeLineCastStart.." " ) .. format("%s%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???"," ["..castData[2].."]") .. targetInfo }
						end
					end
				end
			end
			for _,chatData in ipairs(CurrentFight.chat) do
				local _time = min( max(chatData[4] - CurrentFight.encounterStart,0) , CurrentFight.encounterEnd)
				
				local tooltipIndex = _time / fight_dur
				
				if CurrentEncountersPhases.chat then
					local phaseData = CurrentEncountersPhases.chat[ chatData[3] ]
					if phaseData then
						AddPhase(tooltipIndex,phaseData.phase)
					end
				end				
				
				if CurrentFight.segments[chatData.s].e then
					redLineNum = redLineNum + 1
					if not TLframe.redLine[redLineNum] then
						CreateRedLine(redLineNum)
					end
					TLframe.redLine[redLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
					TLframe.redLine[redLineNum]:Show()
					
					tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
					
					local spellName,_,spellTexture = GetSpellInfo(chatData[3])
								
					addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] "..  L.BossWatcherChatSpellMsg .. " " .. format("%s%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???"," ["..chatData[3].."]") }
				end
			end
			for _,resData in ipairs(CurrentFight.resurrests) do
				if CurrentFight.segments[resData.s].e then
					local _time = timestampToFightTime(resData[4])
					
					local tooltipIndex = _time / fight_dur
					redLineNum = redLineNum + 1
					if not TLframe.redLine[redLineNum] then
						CreateRedLine(redLineNum)
					end
					TLframe.redLine[redLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
					TLframe.redLine[redLineNum]:Show()
					
					tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
					local spellName,_,spellTexture = GetSpellInfo(resData[3])
					
					addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] |c"..ExRT.F.classColorByGUID(resData[1]) .. GetGUID(resData[1]) .."|r" ..  GUIDtoText("(%s)",resData[1]) .. " ".. L.BossWatcherTimeLineCast.. " " .. format("%s%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???"," ["..resData[3].."]") .. " "..L.BossWatcherTimeLineOnText.." |c"..ExRT.F.classColorByGUID(resData[2])..GetGUID(resData[2]).."|r" }
				end
			end
			for i=(redLineNum+1),#TLframe.redLine do
				TLframe.redLine[i]:Hide()
			end
			
			local blueLineNum = 0
			for i=1,#CurrentFight.dies do
				if CurrentFight.segments[CurrentFight.dies[i].s].e and ExRT.F.GetUnitInfoByUnitFlag(CurrentFight.dies[i][2],1) == 1024 then
					local _time = timestampToFightTime(CurrentFight.dies[i][3])
					
					local tooltipIndex = _time / fight_dur
					
					blueLineNum = blueLineNum + 1
					if not TLframe.blueLine[blueLineNum] then
						CreateBlueLine(blueLineNum)
					end
					TLframe.blueLine[blueLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
					TLframe.blueLine[blueLineNum]:Show()
					
					tooltipIndex = min ( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
					
					addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] |cffee5555" .. GetGUID(CurrentFight.dies[i][1]) .. GUIDtoText("(%s)",CurrentFight.dies[i][1])  .. " "..L.BossWatcherTimeLineDies.."|r"}
				end
			end
			for i=(blueLineNum+1),#TLframe.blueLine do
				TLframe.blueLine[i]:Hide()
			end
			
			for i=1,TimeLine_Pieces do
				if bossHpPerSegment[i] then
					table.insert(TLframe[i].tooltip,{bossHpPerSegment[i],1,1,1})
				end
			end
			table.sort(addToToolipTable,function (a,b) return a[2] < b[2] end)
			for i=1,#addToToolipTable do
				if TLframe[ addToToolipTable[i][1] ] then
					table.insert(TLframe[ addToToolipTable[i][1] ].tooltip,{addToToolipTable[i][3],1,1,1})
				end
			end

			TimeLine_UpdateSegments()
		end
		
		TLframe.ImprovedSelectSegment = CreateFrame("Button",nil,TLframe)
		TLframe.ImprovedSelectSegment:SetAllPoints()
		TLframe.ImprovedSelectSegment:Hide()
		
		TLframe.ImprovedSelectSegment.ResetZoom = CreateFrame("Button",nil,TLframe.ImprovedSelectSegment)
		TLframe.ImprovedSelectSegment.ResetZoom:SetSize(200,13)
		TLframe.ImprovedSelectSegment.ResetZoom:SetPoint("TOPRIGHT",TLframe.ImprovedSelectSegment,"BOTTOMRIGHT",-1,4)
		TLframe.ImprovedSelectSegment.ResetZoom.Text = ELib:Text(TLframe.ImprovedSelectSegment.ResetZoom,"["..L.BossWatcherGraphZoomReset.."]",11):Size(200,13):Point("RIGHT",0,0):Right():Top():Color():Outline()
		TLframe.ImprovedSelectSegment.ResetZoom:SetWidth( TLframe.ImprovedSelectSegment.ResetZoom.Text:GetStringWidth() )
		TLframe.ImprovedSelectSegment.ResetZoom:SetScript("OnClick",function (self)
			BWInterfaceFrame.GraphFrame.G.ZoomMinX = nil
			BWInterfaceFrame.GraphFrame.G.ZoomMaxX = nil
			UpdateSegments()
		end)
		TLframe.ImprovedSelectSegment.ResetZoom:Hide()
		
		TLframe.ImprovedSelectSegment.hoverTime = ELib:Text(TLframe.ImprovedSelectSegment,"",11):Size(200,16):Center():Top():Color():Outline()
		
		TLframe.ImprovedSelectSegment.Texture = TLframe:CreateTexture(nil, "BACKGROUND",nil,2)
		--TLframe.ImprovedSelectSegment.Texture:SetTexture("Interface\\AddOns\\ExRT\\media\\bar9.tga")
		--TLframe.ImprovedSelectSegment.Texture:SetVertexColor(0, 0.65, 0.9, .7)
		TLframe.ImprovedSelectSegment.Texture:SetColorTexture(1, 1, 1, 1)
		TLframe.ImprovedSelectSegment.Texture:SetGradientAlpha("VERTICAL",0.3,0.75,0.90,.7,0,0.62,0.90,.7)
		TLframe.ImprovedSelectSegment.Texture:SetHeight(30)
		TLframe.ImprovedSelectSegment.Texture:Hide()
		
		function TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
			local fightDuration = GetFightLength(true)
			local timeLineWidth = self:GetWidth()
			local start = self.mouseDowned / timeLineWidth
			local ending = ExRT.F.GetCursorPos(self) / timeLineWidth
			if ending > start then
				ending = min(ending,1)
				start = max(start,0)
			else
				start = min(start,1)
				ending = max(ending,0)
			end
			
			start = ExRT.F.Round(start * fightDuration)
			ending = ExRT.F.Round(ending * fightDuration)
			
			return start,ending
		end
		function TimeLineFrame_ImprovedSelectSegment_OnUpdate(self)
			local x = ExRT.F.GetCursorPos(self)
			local width = x - self.mouseDowned
			if width > 0 then
				width = min(width,self:GetWidth()-self.mouseDowned)
				self.Texture:SetWidth(width)
				self.Texture:SetPoint("TOPLEFT",TLframe,"TOPLEFT", self.mouseDowned ,0)
				
				local start,ending = TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
				
				ELib.Tooltip.Show(self,"ANCHOR_CURSOR",format("%d:%02d - %d:%02d",start / 60,start % 60,ending / 60,ending % 60))
			elseif width < 0 then
				width = -width
				width = min(width,self.mouseDowned)
				self.Texture:SetWidth(width)
				self.Texture:SetPoint("TOPLEFT",TLframe,"TOPLEFT", self.mouseDowned-width,0)
				
				local start,ending = TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
				ELib.Tooltip.Show(self,"ANCHOR_CURSOR",format("%d:%02d - %d:%02d",ending / 60,ending % 60,start / 60,start % 60))
			else
				self.Texture:SetWidth(1)
				ELib.Tooltip:Hide()
			end
		end
		TLframe.ImprovedSelectSegment:SetScript("OnMouseDown",function (self)
			self.mouseDowned = ExRT.F.GetCursorPos(self)
			self.Texture:SetPoint("TOPLEFT",TLframe,"TOPLEFT", self.mouseDowned ,0)
			self.Texture:SetWidth(1)
			self.Texture:Show()
			self:SetScript("OnUpdate",TimeLineFrame_ImprovedSelectSegment_OnUpdate)
			self.hoverTime:Hide()
		end)
		TLframe.ImprovedSelectSegment:SetScript("OnMouseUp",function (self)
			self:SetScript("OnUpdate",nil)
			self.Texture:Hide()
			ELib.Tooltip:Hide()
			if not self.mouseDowned then
				return
			end
			local start,ending = TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
			self.mouseDowned = nil
			if ending < start then
				start,ending = ending,start
			end
			start = start + 1
			ending = ending + 1
			
			UpdateSegments(start,ending,IsShiftKeyDown())
		end)
		
		function TimeLineFrame_ImprovedSelectSegment_OnUpdate_Passive(self)
			local timeLineWidth = self:GetWidth()
			local fightDuration = GetFightLength(true)
			local x = ExRT.F.GetCursorPos(self)
			local time = ExRT.F.Round(x / timeLineWidth * fightDuration)
			self.hoverTime:SetFormattedText("%d:%02d",time / 60,time % 60)
			self.hoverTime:SetPoint("TOP",self,"TOPLEFT",x,-2)
			self.hoverTime:Show()
			local segmentNow = ceil(x / timeLineWidth * 60  + 0.01)
			if segmentNow ~= self.lastSegment then
				self.lastSegment = segmentNow
				ELib.Tooltip:Hide()
			else
				return
			end
			local frame = TLframe[segmentNow]
			if frame then
				TimeLinePieceOnEnter(frame)
			end
		end
		TLframe.ImprovedSelectSegment:SetScript("OnEnter",function (self)
			if self.mouseDowned then 
				return
			end
			self.lastSegment = nil
			self:SetScript("OnUpdate",TimeLineFrame_ImprovedSelectSegment_OnUpdate_Passive)
		end)
		TLframe.ImprovedSelectSegment:SetScript("OnLeave",function (self)
			self.hoverTime:Hide()
			if self.mouseDowned then
				return
			end
			ELib.Tooltip:Hide()
			self:SetScript("OnUpdate",nil)
		end)
	end
			
	BWInterfaceFrame.timeLineFrame:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateTimeLine()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	
	---- Graph Frame
	BWInterfaceFrame.GraphFrame = CreateFrame('Frame',nil,BWInterfaceFrame.tab)
	BWInterfaceFrame.GraphFrame:SetSize(860,200)
	BWInterfaceFrame.GraphFrame:SetPoint("TOP",0,-80)
	BWInterfaceFrame.GraphFrame:Hide()
	BWInterfaceFrame.GraphFrame.G = ExRT.lib.CreateGraph(BWInterfaceFrame.GraphFrame,790,180,"TOPLEFT",50,-5,true)
	BWInterfaceFrame.GraphFrame.G.fixMissclickZoom = true
	BWInterfaceFrame.GraphFrame.G.DisableReloadOnResetZoom = true
	BWInterfaceFrame.GraphFrame.G.backgroundHighlight = {}
	BWInterfaceFrame.GraphFrame.G.ResetZoom:Point("TOPRIGHT",-100,10)

	BWInterfaceFrame.GraphFrame.G.highlightHideButton = ELib:Button(BWInterfaceFrame.GraphFrame.G,"",1)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetSize(16,16)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background = BWInterfaceFrame.GraphFrame.G.highlightHideButton:CreateTexture(nil, "BACKGROUND")
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background:SetAllPoints()
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background:SetTexCoord(0.5,0.5625,0.5,0.625)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetScript("OnEnter",function(self)
		self.background:SetVertexColor(.7,0,0,1)
	end)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetScript("OnLeave",function(self)
		self.background:SetVertexColor(1,1,1,.7)
	end)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetScript("OnClick",function(self)
		local parent = self:GetParent()
		parent.highlight = nil
		parent:OnAfterReload()
	end)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:Hide()
	
	function BWInterfaceFrame.GraphFrame.G:OnBeforeReload()
		if not self.data[1] then
			return
		end
		local tooltipX = {}
		for i=1,#self.data[1] do
			tooltipX[i] = format("%d:%02d",i / 60,i % 60)
		end
		self.data.tooltipX = tooltipX
	end
	function BWInterfaceFrame.GraphFrame.G:OnAfterReload()
		if not self.highlight or not self.range or not self.range.maxX then
			for i=1,#self.backgroundHighlight do
				self.backgroundHighlight[i]:Hide()
			end
			self.highlightHideButton:Hide()
			return
		end
		local count = 0
		for i=1,#self.highlight,2 do
			local posStart,posEnd = self.highlight[i],self.highlight[i+1]
			if not (posStart > self.range.maxX or posEnd < self.range.minX) then
				if posStart < self.range.minX then
					posStart = self.range.minX
				end
				if posEnd > self.range.maxX then
					posEnd = self.range.maxX
				end
				count = count + 1
				local background = self.backgroundHighlight[count]
				if not background then
					background = self:CreateTexture(nil, "BACKGROUND",nil,2)
					self.backgroundHighlight[count] = background
					background:SetPoint("TOP",0,0)
					background:SetPoint("BOTTOM",0,0)
					background:SetColorTexture(0.7, 0.65, 0.9, .3)
					if count == 1 then
						self.highlightHideButton:SetPoint("TOPRIGHT",background,2,-2)
					end
				end
				local posX = (posStart - self.range.minX) / (self.range.maxX - self.range.minX) * self:GetWidth()
				local width = (posEnd - posStart) / (self.range.maxX - self.range.minX) * self:GetWidth()
				background:SetPoint("LEFT",posX,0)
				background:SetWidth(width)
				background:Show()
				if count == 1 then
					self.highlightHideButton:Show()
				end
			end
		end
		for i=count+1,#self.backgroundHighlight do
			self.backgroundHighlight[i]:Hide()
		end
		if count == 0 then
			self.highlightHideButton:Hide()
		end
	end
	function BWInterfaceFrame.GraphFrame.G:Zoom(start,ending)
		if ending == start then
			self.ZoomMinX = nil
			self.ZoomMaxX = nil
		else
			self.ZoomMinX = start
			self.ZoomMaxX = ending
		end
		
		UpdateSegments(start,ending)
	end
	function BWInterfaceFrame.GraphFrame.G:OnResetZoom()
		UpdateSegments()
	end
	BWInterfaceFrame.GraphFrame.stepSlider = ELib:Slider(BWInterfaceFrame.GraphFrame,"",true):Point("BOTTOMRIGHT",BWInterfaceFrame.GraphFrame.G,"BOTTOMLEFT",-10,20):Size(100):Range(1,10):SetTo(1):OnChange(function(self)
		local graph = self:GetParent().G
		self:Tooltip(L.BossWatcherGraphicsStep.."\n"..floor(self:GetValue() + 0.5))
		self:tooltipReload()
		if graph.IgnoreStepSliderFix then
			return
		end
		graph.step = floor(self:GetValue() + 0.5)
		graph:Reload()
	end):Tooltip(L.BossWatcherGraphicsStep.."\n1")
	
	function Graph_AutoUpdateStep()
		local fightDuration = GetFightLength()
		local step = 1
		if fightDuration >= 360 then
			step = 3
		elseif fightDuration >= 180 then
			step = 2
		end
		local graph = BWInterfaceFrame.GraphFrame.G
		graph.IgnoreStepSliderFix = true
		graph.step = step
		BWInterfaceFrame.GraphFrame.stepSlider:SetValue(step)
		graph.IgnoreStepSliderFix = nil
	end
	
		
	
	local tab = nil
	---- Damage Tab
	tab = BWInterfaceFrame.tab.tabs[1]
	
	local sourceVar,destVar = {},{}
	local DamageTab_SetLine = nil
	
	local DamageTab_Variables = {
		Last_Func = nil,
		Last_doEnemy = nil,
		ShowAll = false,
		Back_Func = nil,
		Back_destVar = nil,
		Back_sourceVar = nil,
		
		state_friendly = true,
		state_spells = false,
		state_byTarget = false,
		state_spellsTarget = false,
	}
	
	local DamageTab_UpdatePage
	
	local function DamageTab_GetGUIDsReport(list,isDest)
		local result = ""
		for GUID,_ in pairs(list) do
			if result ~= "" then
				result = result..", "
			end
			local time = ""
			if isDest and ExRT.F.GetUnitTypeByGUID(GUID) ~= 0 and CurrentFight.damage_seen[GUID] then
				time = date(" (%M:%S)", timestampToFightTime( CurrentFight.damage_seen[GUID] ))
			end
			result = result .. GetGUID(GUID) .. time
		end
		if result ~= "" then
			return result
		end
	end
	local function DamageTab_UpdateDropDown(arr,dropDown)
		local count = ExRT.F.table_len(arr)
		if count == 0 then
			dropDown:SetText(L.BossWatcherAll)
		elseif count == 1 then
			local GUID = nil
			for g,_ in pairs(arr) do
				GUID = g
			end
			local name = GetGUID(GUID)
			local flags = CurrentFight.reaction[GUID]
			local isPlayer = GetUnitInfoByUnitFlagFix(flags,1) == 1024
			local isNPC = GetUnitInfoByUnitFlagFix(flags,2) == 512
			if isPlayer then
				name = "|c"..ExRT.F.classColorByGUID(GUID)..name
			elseif isNPC then
				name = name .. date(" %M:%S", timestampToFightTime( CurrentFight.damage_seen[GUID] )) .. GUIDtoText(" [%s]",GUID)
			end
			dropDown:SetText(name)
		else
			dropDown:SetText(L.BossWatcherSeveral)
		end
	end
	
	local function DamageTab_UpdateDropDowns()
		DamageTab_UpdateDropDown(sourceVar,BWInterfaceFrame.tab.tabs[1].sourceDropDown)
		DamageTab_UpdateDropDown(destVar,BWInterfaceFrame.tab.tabs[1].targetDropDown)
	end

	local function DamageTab_UpdateChecks()
		local tab = BWInterfaceFrame.tab.tabs[1]
		for _,c in pairs({tab.chkFriendly,tab.chkEnemy,tab.chkSpellsTargets,tab.bySource,tab.byTarget,tab.bySpell}) do
			c:SetChecked(false)
		end
		if DamageTab_Variables.state_spellsTarget then
			tab.chkSpellsTargets:SetChecked(true)
		elseif DamageTab_Variables.state_friendly then
			tab.chkFriendly:SetChecked(true)
		else
			tab.chkEnemy:SetChecked(true)
		end
		if DamageTab_Variables.state_spells then
			tab.bySpell:SetChecked(true)
		end
		if DamageTab_Variables.state_byTarget then
			tab.byTarget:SetChecked(true)
		elseif not DamageTab_Variables.state_spells then
			tab.bySource:SetChecked(true)
		end
	end
	local function DamageTab_Temp_SortingBy2Param(a,b)
		return a[2] > b[2]
	end
	
	local function DamageTab_ReloadGraph(data,fightLength,linesData,isSpell)
		local graphData = {}
		for key,spellData in pairs(data) do
			local newData
			if isSpell then
				local spellID = key
				local isPet = 1
				if (not ExRT.isClassic) and spellID < -1 then
					isPet = -1
					spellID = -spellID
				end
				local spellName,_,spellIcon = GetSpellInfo(spellID)
				if spellID == -1 then
					spellName = L.BossWatcherReportTotal
				elseif spellName then
					spellName = "|T"..spellIcon..":0|t "..spellName
				else
					spellName = spellID
				end
				newData = {
					info_spellID = type(spellID)=='number' and spellID*isPet or spellID,
					name = spellName,
					total_damage = 0,
					hide = true,
				}
			else
				local sourceGUID = key
				local name,r,g,b = nil
				if sourceGUID == -1 then
					name = L.BossWatcherReportTotal
				else
					local class
					name = GetGUID(sourceGUID)
					if sourceGUID ~= "" then
						class = select(2,GetPlayerInfoByGUID(sourceGUID))
					end
					name = "|c".. ExRT.F.classColor(class) .. name .. "|r"
					if class then
						local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
						r,g,b = classColorArray.r,classColorArray.g,classColorArray.b
					end
				end
				newData = {
					info_spellID = sourceGUID,
					name = name,
					total_damage = 0,
					hide = true,
					r = r,
					g = g,
					b = b,
				}
			end
			graphData[#graphData+1] = newData
			local total_damage = 0
			for i=1,fightLength do
				newData[i] = {i,spellData[i] or 0}
				total_damage = total_damage + (spellData[i] or 0)
			end
			newData.total_damage = total_damage
		end
		sort(graphData,function(a,b) return a.total_damage>b.total_damage end)
		local findPos = ExRT.F.table_find(graphData,-1,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = nil
			graphData[ findPos ].specialLine = true
		end
		for i=1,3 do
			if linesData[i] then
				findPos = ExRT.F.table_find(graphData,linesData[i][isSpell and "spell" or "guid"],'info_spellID')
				if findPos then
					graphData[ findPos ].hide = nil
				end
			end
		end
		BWInterfaceFrame.GraphFrame.G.data = graphData
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	
	local function DamageTab_UpdateLines_GetUnit(damage,graph,source,dest,header,secondHeader)
		header = header or "guid"
		local sourceDamage
		
		for i=1,#damage do
			if damage[i][header] == source and (not secondHeader or damage[i].info == secondHeader) then
				sourceDamage = i
				break
			end
		end
		
		if not sourceDamage then
			sourceDamage = #damage + 1
			damage[sourceDamage] = {
				[header] = source,
				info = secondHeader,
				eff = 0,
				total = 0,
				count = 0,
				overkill = 0,
				blocked = 0,
				absorbed = 0,
				crit = 0,
				critcount = 0,
				critmax = 0,
				critover = 0,
				hitmax = 0,
				parry = 0,
				dodge = 0,
				miss = 0,
				targets = {},
			}
		end
		sourceDamage = damage[sourceDamage]
		
		local destPos
		
		local targets = sourceDamage.targets
		for i=1,#targets do
			if targets[i][1] == dest then
				destPos = i
				break
			end
		end		
		
		if not destPos then
			destPos = #sourceDamage.targets + 1
			sourceDamage.targets[destPos] = {dest,0}
		end
		
		if not graph[ source ] then
			graph[ source ] = {}
		end
		
		return sourceDamage, sourceDamage.targets[destPos]
	end
	
	local function DamageTab_UpdateLinesPlayers()
		ExRT.F.dprint("Damage Update: Players",GetTime())
		local doEnemy = DamageTab_Variables.state_friendly
		local isReverse = DamageTab_Variables.state_byTarget
	
		DamageTab_UpdateDropDowns()
		DamageTab_UpdateChecks()
		
		local damage = {}
		local total = 0
		local totalOver = 0
		local graph = {[-1]={}}
		for destGUID,destData in pairs(CurrentFight.damage) do
			if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
				for destReaction,destReactData in pairs(destData) do
					local isEnemy = false
					if GetUnitInfoByUnitFlagFix(destReaction,2) == 512 then
						isEnemy = true
					end
					if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
						for sourceGUID,sourceData in pairs(destReactData) do
							local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
							if owner then
								sourceGUID = owner
							end
							if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
								local source = isReverse and destGUID or sourceGUID
								local dest = isReverse and sourceGUID or destGUID
								
								local sourceDamage, destPos = DamageTab_UpdateLines_GetUnit(damage,graph,source,dest,"guid")
														
								for spellID,spellSegments in pairs(sourceData) do
									for segment,spellAmount in pairs(spellSegments) do
										if CurrentFight.segments[segment].e then
											sourceDamage.eff = sourceDamage.eff + spellAmount.amount - spellAmount.overkill
											sourceDamage.total = sourceDamage.total + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
											sourceDamage.overkill = sourceDamage.overkill + spellAmount.overkill
											sourceDamage.blocked = sourceDamage.blocked + spellAmount.blocked
											sourceDamage.absorbed = sourceDamage.absorbed + spellAmount.absorbed
											sourceDamage.crit = sourceDamage.crit + spellAmount.crit
											total = total + spellAmount.amount - spellAmount.overkill
											totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
											
											local damgeCount = spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
											destPos[2] = destPos[2] + damgeCount
	
											if not graph[ source ][segment] then
												graph[ source ][segment] = 0
											end
											if not graph[ -1 ][segment] then
												graph[ -1 ][segment] = 0
											end
											graph[ source ][segment] = graph[ source ][segment] + damgeCount
											graph[ -1 ][segment] = graph[ -1 ][segment] + damgeCount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		
		local _max = nil
		reportOptions[1] = L.BossWatcherReportDPS
		wipe(reportData[1])
		reportData[1][1] = (DamageTab_GetGUIDsReport(sourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(destVar,true) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return a.total>b.total end)
			_max = damage[1] and damage[1].total or 0
		else
			sort(damage,function(a,b) return a.eff>b.eff end)
			_max = damage[1] and damage[1].eff or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=#damage,1,-1 do
			if damage[i].total == 0 then
				tremove(damage,i)
			end
		end
		for i=1,#damage do
			local damageLine = damage[i]
			local class = nil
			if damageLine.guid and damageLine.guid ~= "" then
				class = select(2,GetPlayerInfoByGUID(damageLine.guid))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(damageLine.guid),
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damageLine.overkill)},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damageLine.blocked)},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damageLine.absorbed)},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damageLine.total)},
				{" "," "},
				{L.BossWatcherDamageTooltipFromCrit,format("%s (%.1f%%)",ExRT.F.shortNumber(damageLine.crit),max(damageLine.crit/max(1,damageLine.total)*100))},
			}
			sort(damageLine.targets,DamageTab_Temp_SortingBy2Param)
			if #damageLine.targets > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {isReverse and L.BossWatcherDamageTooltipSources or L.BossWatcherDamageTooltipTargets," "}
			end
			for j=1,min(5,#damageLine.targets) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(damageLine.targets[j][1]),20)..GUIDtoText(" [%s]",damageLine.targets[j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(damageLine.targets[j][2]),min(damageLine.targets[j][2] / max(1,(DamageTab_Variables.ShowAll and damageLine.total or damageLine.eff))*100,100))}
			end
		
			local currDamage = DamageTab_Variables.ShowAll and damageLine.total or damageLine.eff
			local dps = currDamage/activeFightLength
			DamageTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(damageLine.guid)..GUIDtoText(" [%s]",damageLine.guid),
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damageLine.total - damageLine.eff),
				total = total,
				max = _max,
				dps = dps,
				class = class,
				sourceGUID = damageLine.guid,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..GetGUID(damageLine.guid).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..floor(dps)..")@1#"			
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		DamageTab_Variables.graphCache = {graph,#CurrentFight.segments,damage,false}
		if BWInterfaceFrame.GraphFrame:IsShown() then
			DamageTab_ReloadGraph(graph,#CurrentFight.segments,damage,false)
		end
	end
	local function DamageTab_UpdateLinesSpells()
		local doEnemy = DamageTab_Variables.state_friendly
	
		DamageTab_UpdateDropDowns()
		DamageTab_UpdateChecks()
		
		local damage = {}
		local total = 0
		local totalOver = 0
		local graph = {[-1]={}}
		for destGUID,destData in pairs(CurrentFight.damage) do
			if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
				for destReaction,destReactData in pairs(destData) do
					local isEnemy = false
					if GetUnitInfoByUnitFlagFix(destReaction,2) == 512 then
						isEnemy = true
					end
					if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
						for sourceGUID,sourceData in pairs(destReactData) do
							local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
							if owner then
								sourceGUID = owner
							end
							if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
								for spellID,spellSegments in pairs(sourceData) do
									local sourceDamage, destPos = DamageTab_UpdateLines_GetUnit(damage,graph,spellID,destGUID,"spell",owner and "pet")
									
									for segment,spellAmount in pairs(spellSegments) do
										if CurrentFight.segments[segment].e then
											sourceDamage.total = sourceDamage.total + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
											sourceDamage.eff = sourceDamage.eff + spellAmount.amount - spellAmount.overkill
											sourceDamage.count = sourceDamage.count + spellAmount.count
											sourceDamage.overkill = sourceDamage.overkill + spellAmount.overkill
											sourceDamage.blocked = sourceDamage.blocked + spellAmount.blocked
											sourceDamage.absorbed = sourceDamage.absorbed + spellAmount.absorbed
											sourceDamage.crit = sourceDamage.crit + spellAmount.crit
											sourceDamage.critcount = sourceDamage.critcount + spellAmount.critcount
											if sourceDamage.critmax < spellAmount.critmax then
												sourceDamage.critmax = spellAmount.critmax
											end
											sourceDamage.critover = sourceDamage.critover + spellAmount.critover
											if sourceDamage.hitmax < spellAmount.hitmax then
												sourceDamage.hitmax = spellAmount.hitmax
											end
											sourceDamage.parry = sourceDamage.parry + spellAmount.parry
											sourceDamage.dodge = sourceDamage.dodge + spellAmount.dodge
											sourceDamage.miss = sourceDamage.miss + spellAmount.miss
											total = total + spellAmount.amount - spellAmount.overkill
											totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
											
											local damgeCount = spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
											
											destPos[2] = destPos[2] + damgeCount
											
											if not graph[ spellID ][segment] then
												graph[ spellID ][segment] = 0
											end
											if not graph[ -1 ][segment] then
												graph[ -1 ][segment] = 0
											end
											
											graph[ spellID ][segment] = graph[ spellID ][segment] + damgeCount
											graph[ -1 ][segment] = graph[ -1 ][segment] + damgeCount
										
										end
									end
								end
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[1] = L.BossWatcherReportDPS
		wipe(reportData[1])
		reportData[1][1] = (DamageTab_GetGUIDsReport(sourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(destVar,true) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return a.total>b.total end)
			_max = damage[1] and damage[1].total or 0
		else
			sort(damage,function(a,b) return a.eff>b.eff end)
			_max = damage[1] and damage[1].eff or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=#damage,1,-1 do
			if damage[i].total == 0 then
				tremove(damage,i)
			end
		end
		local castsCount = SpellsPage_GetCastsNumber(ExRT.F.table_len(sourceVar) > 0 and sourceVar,ExRT.F.table_len(destVar) > 0 and destVar)
		for i=1,#damage do
			local damageLine = damage[i]
			local isPetAbility = damageLine.info == "pet"
			local spellID = damageLine.spell

			local isDoT = (not ExRT.isClassic) and spellID < 0
			if isDoT then
				spellID = -spellID
			end
			local spellName,_,spellIcon = GetSpellInfo(spellID)
			local defSpellName = spellName
			if isPetAbility then
				spellName = L.BossWatcherPetText..": "..spellName
			end
			if isDoT then
				spellName = spellName .. " ["..L.BossWatcherDoT.."]"
			end
			if damageLine.info and damageLine.info ~= "pet" then
				spellName = GetGUID(damageLine.info)..": "..spellName
			end
			local school = module.db.spellsSchool[ spellID ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherDamageTooltipCount,damageLine.count},
				{L.BossWatcherDamageTooltipMaxHit,damageLine.hitmax},
				{L.BossWatcherDamageTooltipMidHit,ExRT.F.Round((damageLine.eff-damageLine.crit+damageLine.critover)/max(damageLine.count-damageLine.critcount,1))},
				{L.BossWatcherDamageTooltiCritCount,format("%d (%.1f%%)",damageLine.critcount,damageLine.critcount/damageLine.count*100)},
				{L.BossWatcherDamageTooltiCritAmount,ExRT.F.shortNumber(damageLine.crit - damageLine.critover)},
				{L.BossWatcherDamageTooltiMaxCrit,damageLine.critmax},
				{L.BossWatcherDamageTooltiMidCrit,ExRT.F.Round((damageLine.crit - damageLine.critover)/max(damageLine.critcount,1))},
				{L.BossWatcherDamageTooltipParry,format("%d (%.1f%%)",damageLine.parry,damageLine.parry/damageLine.count*100)},
				{L.BossWatcherDamageTooltipDodge,format("%d (%.1f%%)",damageLine.dodge,damageLine.dodge/damageLine.count*100)},
				{L.BossWatcherDamageTooltipMiss,format("%d (%.1f%%)",damageLine.miss,damageLine.miss/damageLine.count*100)},
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damageLine.overkill)},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damageLine.blocked)},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damageLine.absorbed)},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damageLine.total)},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			local casts = castsCount[ spellID ] or castsCount[ defSpellName ]
			if casts then
				tinsert(tooltipData,2,{L.BossWatcherDamageTooltipCastsCount,casts})
				tinsert(tooltipData,3,{L.BossWatcherPerCast,ExRT.F.shortNumber(damageLine.eff / casts)})				
			end
			
			sort(damageLine.targets,DamageTab_Temp_SortingBy2Param)
			if #damageLine.targets > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherDamageTooltipTargets," "}
			end
			for j=1,min(5,#damageLine.targets) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(damageLine.targets[j][1]),20)..GUIDtoText(" [%s]",damageLine.targets[j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(damageLine.targets[j][2]),min(damageLine.targets[j][2] / max(1,DamageTab_Variables.ShowAll and damageLine.total or damageLine.eff)*100,100))}
			end
			
			local currDamage = DamageTab_Variables.ShowAll and damageLine.total or damageLine.eff
			local dps = currDamage/activeFightLength
			DamageTab_SetLine({
				line = i+1,
				icon = spellIcon,
				name = spellName,
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damageLine.total - damageLine.eff),
				total = total,
				max = _max,
				dps = dps,
				spellID = spellID,
				school = school,
				isDoT = isDoT,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..(isPetAbility and L.BossWatcherPetText..": " or "")..(damageLine.info and damageLine.info ~= "pet" and GetGUID(damageLine.info)..": " or "")..GetSpellLink(spellID).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..floor(dps)..")@1#"
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		DamageTab_Variables.graphCache = {graph,#CurrentFight.segments,damage,true}
		if BWInterfaceFrame.GraphFrame:IsShown() then
			DamageTab_ReloadGraph(graph,#CurrentFight.segments,damage,true)
		end
	end
	
	local function DamageTab_UpdateLinesSpellToTargets()
		local doEnemy = false
		DamageTab_UpdateDropDowns()
		DamageTab_UpdateChecks()
		
		local spellIDnow,spellIDnow_Name = nil,""
		for spellID,_ in pairs(sourceVar) do
			spellIDnow = spellID
		end
		if spellIDnow then
			spellIDnow_Name = GetSpellInfo(spellIDnow) or ""
			BWInterfaceFrame.tab.tabs[1].sourceDropDown:SetText(spellIDnow_Name)
		else
			BWInterfaceFrame.tab.tabs[1].sourceDropDown:SetText(L.BossWatcherSelect)
		end
		local damage = {}
		local total = 0
		local totalOver = 0
		local totalCount = 0
		local graph = {[-1]={}}
		for destGUID,destData in pairs(CurrentFight.damage) do
			for destReaction,destReactData in pairs(destData) do
				local isEnemy = GetUnitInfoByUnitFlagFix(destReaction,2) == 512
				if (doEnemy and isEnemy) or (not doEnemy and not isEnemy) then
					for sourceGUID,sourceData in pairs(destReactData) do
						for spellID,spellSegments in pairs(sourceData) do
							if sourceVar[spellID] or sourceVar[-spellID] then
								local inDamagePos = ExRT.F.table_find(damage,destGUID,1)
								if not inDamagePos then
									inDamagePos = #damage + 1
									damage[inDamagePos] = {destGUID,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,guid=destGUID,total=0,sources={}}
								end
								if not graph[ destGUID ] then
									graph[ destGUID ] = {}
								end
								
								for segment,spellAmount in pairs(spellSegments) do
									if CurrentFight.segments[segment].e then
										damage[inDamagePos].total = damage[inDamagePos].total + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
										damage[inDamagePos][2] = damage[inDamagePos][2] + spellAmount.amount - spellAmount.overkill	--amount
										damage[inDamagePos][3] = damage[inDamagePos][3] + spellAmount.count	--count
										damage[inDamagePos][4] = damage[inDamagePos][4] + spellAmount.overkill	--overkill
										damage[inDamagePos][5] = damage[inDamagePos][5] + spellAmount.blocked	--blocked
										damage[inDamagePos][6] = damage[inDamagePos][6] + spellAmount.absorbed	--absorbed
										damage[inDamagePos][7] = damage[inDamagePos][7] + spellAmount.crit	--crit
										damage[inDamagePos][8] = damage[inDamagePos][8] + spellAmount.critcount	--crit count
										damage[inDamagePos][9] = max(damage[inDamagePos][9],spellAmount.critmax)--crit max
										damage[inDamagePos][13] = max(damage[inDamagePos][13],spellAmount.hitmax)--hit max
										damage[inDamagePos][14] = damage[inDamagePos][14] + spellAmount.parry	--parry
										damage[inDamagePos][15] = damage[inDamagePos][15] + spellAmount.dodge	--dodge
										damage[inDamagePos][16] = damage[inDamagePos][16] + spellAmount.miss	--other miss
										total = total + spellAmount.amount - spellAmount.overkill
										totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
										totalCount = totalCount + spellAmount.count
										
										if not graph[ destGUID ][segment] then
											graph[ destGUID ][segment] = 0
										end
										if not graph[ -1 ][segment] then
											graph[ -1 ][segment] = 0
										end
									
										local damgeCount = spellAmount.count
										graph[ destGUID ][segment] = graph[ destGUID ][segment] + damgeCount
										graph[ -1 ][segment] = graph[ -1 ][segment] + damgeCount
										
										local source
										for i=1,#damage[inDamagePos].sources do
											if damage[inDamagePos].sources[i][1] == sourceGUID then
												source = damage[inDamagePos].sources[i]
												break
											end
										end
										if not source then
											source = {sourceGUID,0}
											damage[inDamagePos].sources[ #damage[inDamagePos].sources+1 ] = source
										end
										source[2] = source[2] + spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked + spellAmount.absorbed) or -spellAmount.overkill) 
									end
								end
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[1] = L.BossWatcherReportCount
		wipe(reportData[1])
		reportData[1][1] = GetSpellLink(spellIDnow).." > "..L.BossWatcherAllTargets
		
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return (a[2]+a[4]+a[5]+a[6])>(b[2]+b[4]+b[5]+b[6]) end)
			_max = damage[1] and (damage[1][2]+damage[1][4]+damage[1][5]+damage[1][6]) or 0
		else
			sort(damage,function(a,b) return a[2]>b[2] end)
			_max = damage[1] and damage[1][2] or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(totalCount)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = totalCount,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=#damage,1,-1 do
			if damage[i].total == 0 then
				tremove(damage,i)
			end
		end
		for i=1,#damage do
			local class = nil
			if damage[i][1] and damage[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(damage[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(damage[i][1]),
				{L.BossWatcherDamageTooltipCount,damage[i][3]},
				{L.BossWatcherDamageTooltipMaxHit,damage[i][13]},
				{L.BossWatcherDamageTooltipMidHit,ExRT.F.Round((damage[i][2]-damage[i][7]+damage[i][4])/max(damage[i][3]-damage[i][8],1))},
				{L.BossWatcherDamageTooltiCritCount,format("%d (%.1f%%)",damage[i][8],damage[i][8]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltiCritAmount,ExRT.F.shortNumber(damage[i][7])},
				{L.BossWatcherDamageTooltiMaxCrit,damage[i][9]},
				{L.BossWatcherDamageTooltiMidCrit,ExRT.F.Round(damage[i][7]/max(damage[i][8],1))},
				{L.BossWatcherDamageTooltipParry,format("%d (%.1f%%)",damage[i][14],damage[i][14]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipDodge,format("%d (%.1f%%)",damage[i][15],damage[i][15]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipMiss,format("%d (%.1f%%)",damage[i][16],damage[i][16]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damage[i][4])},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damage[i][5])},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damage[i][6])},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damage[i][4]+damage[i][5]+damage[i][6]+damage[i][2])},
			}
			sort(damage[i].sources,DamageTab_Temp_SortingBy2Param)
			if #damage[i].sources > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherDamageTooltipSources," "}
			end
			for j=1,min(5,#damage[i].sources) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(damage[i].sources[j][1]),20)..GUIDtoText(" [%s]",damage[i].sources[j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i].sources[j][2]),min(damage[i].sources[j][2] / max(1,(DamageTab_Variables.ShowAll and damage[i].total or damage[i][2]))*100,100))}
			end
			
			local currDamage = damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]) or 0)
			DamageTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(damage[i][1])..GUIDtoText(" [%s]",damage[i][1]),
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]),
				total = total,
				max = _max,
				dps = damage[i][3],
				class = class,
				sourceGUID = damage[i][1],
				doEnemy = doEnemy,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..GetGUID(damage[i][1]).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..(damage[i][3]-damage[i][11])..")@1#"
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		
		DamageTab_Variables.graphCache = {graph,#CurrentFight.segments,damage,false}
		if BWInterfaceFrame.GraphFrame:IsShown() then
			DamageTab_ReloadGraph(graph,#CurrentFight.segments,damage,false)
		end
	end
	
	local function DamageTab_ShowDamageToTarget(GUID)
		local button = BWInterfaceFrame.tab.tabs[1].button
		local func = button:GetScript("OnClick")
	
		DamageTab_Variables.state_friendly = true
		DamageTab_Variables.state_spells = false
		DamageTab_Variables.state_byTarget = false
		DamageTab_Variables.state_spellsTarget = false
		
		func(button)

		DamageTab_UpdatePage(true,function()
			destVar[GUID] = true
		end)
	end
	
	local function DamageTab_DPS_SelectDropDownSource(self,arg)
		ELib:DropDownClose()
		wipe(sourceVar)
		if arg then
			sourceVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = CurrentFight.guids[arg]
				if name then
					for GUID,GUIDname in pairs(CurrentFight.guids) do
						if GUIDname == name then
							sourceVar[GUID] = true
						end
					end
				end
			elseif IsControlKeyDown() then
				local name = CurrentFight.guids[arg]
				if name then
					sourceVar[arg] = nil
					for GUID,GUIDname in pairs(CurrentFight.guids) do
						if GUIDname ~= name then
							sourceVar[GUID] = true
						end
					end
				end
			end
		end
		DamageTab_UpdatePage()
	end
	local function DamageTab_DPS_SelectDropDownDest(self,arg)
		ELib:DropDownClose()
		wipe(destVar)
		if arg then
			destVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = CurrentFight.guids[arg]
				if name then
					for GUID,GUIDname in pairs(CurrentFight.guids) do
						if GUIDname == name then
							destVar[GUID] = true
						end
					end
				end
			elseif IsControlKeyDown() then
				local name = CurrentFight.guids[arg]
				if name then
					destVar[arg] = nil
					for GUID,GUIDname in pairs(CurrentFight.guids) do
						if GUIDname ~= name then
							destVar[GUID] = true
						end
					end
				end
			end
		end
		DamageTab_UpdatePage()
	end
	
	local function DamageTab_DPS_SelectDropDownSource_Spell(self,spellID)
		wipe(sourceVar)
		sourceVar[spellID] = true
		DamageTab_UpdatePage()
		ELib:DropDownClose()
	end

	local function DamageTab_DPS_CheckDropDownSource(self,checked)
		if checked then
			sourceVar[self.arg1] = true
		else
			sourceVar[self.arg1] = nil
		end
		DamageTab_UpdatePage()
	end
	local function DamageTab_DPS_CheckDropDownDest(self,checked)
		if checked then
			destVar[self.arg1] = true
		else
			destVar[self.arg1] = nil
		end
		DamageTab_UpdatePage()
	end
	
	local function DamageTab_HideArrow()
		BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
	end
	local function DamageTab_ShowArrow(self,pos)
		if pos then
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*pos,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
		end
	end
	
	local function DamageTab_HoverDropDownSpell(self,spellID)
		if not spellID then
			return
		end
		ELib.Tooltip.Link(self,"spell:"..spellID)
	end

	local function DamageTab_DPS(disableUpdateVars)
		local doEnemy = DamageTab_Variables.state_friendly
		local isBySpellDamage = DamageTab_Variables.state_spellsTarget
		if isBySpellDamage then
			doEnemy = false
		end
	
		local reaction = 512 
		if not doEnemy then 
			reaction = 256 
		end
		
		if not CurrentFight.damage then	--First load fix
			return
		end
	
		local sourceTable = {}
		local destTable = {}
		for destGUID,destData in pairs(CurrentFight.damage) do
			for destReaction,destReactData in pairs(destData) do
				if GetUnitInfoByUnitFlagFix(destReaction,2) == reaction then
					for sourceGUID,sourceData in pairs(destReactData) do
						local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
						if owner then
							sourceGUID = owner
						end
						for spellID,spellSegments in pairs(sourceData) do
							for segment,spellAmount in pairs(spellSegments) do
								if CurrentFight.segments[segment].e then
									if not ExRT.F.table_find(destTable,destGUID,1) then
										destTable[#destTable + 1] = {destGUID,CurrentFight.damage_seen[destGUID] or 0}
									end
									if not isBySpellDamage and not ExRT.F.table_find(sourceTable,sourceGUID,1) then
										sourceTable[#sourceTable + 1] = {sourceGUID,GetGUID(sourceGUID)}
									elseif isBySpellDamage then
										if spellID < 0 then
											spellID = -spellID
										end
										if not ExRT.F.table_find(sourceTable,spellID,1) then
											local spellName,_,spellIcon = GetSpellInfo(spellID)
											sourceTable[#sourceTable + 1] = {spellID,spellName,spellIcon}
										end
									
									end
								end
							end
						end
					end
				end
			end
		end
		sort(sourceTable,function(a,b) return a[2]<b[2] end)
		sort(destTable,function(a,b) return a[2]<b[2] end)
		wipe(BWInterfaceFrame.tab.tabs[1].sourceDropDown.List)
		wipe(BWInterfaceFrame.tab.tabs[1].targetDropDown.List)
		if not isBySpellDamage then
			BWInterfaceFrame.tab.tabs[1].sourceDropDown.List[1] = {text = L.BossWatcherAll,func = DamageTab_DPS_SelectDropDownSource,padding = 16}
			BWInterfaceFrame.tab.tabs[1].targetDropDown.List[1] = {text = L.BossWatcherAll,func = DamageTab_DPS_SelectDropDownDest,padding = 16}
			for i=1,#sourceTable do
				local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
				local classColor = ""
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
				end
				BWInterfaceFrame.tab.tabs[1].sourceDropDown.List[i+1] = {
					text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
					arg1 = sourceTable[i][1],
					func = DamageTab_DPS_SelectDropDownSource,
					checkFunc = DamageTab_DPS_CheckDropDownSource,
					checkable = true,
				}
			end
			BWInterfaceFrame.tab.tabs[1].targetDropDown:Show()
			BWInterfaceFrame.tab.tabs[1].targetText:Show()
		else
			for i=1,#sourceTable do
				local spellColorTable = module.db.schoolsColors[ module.db.spellsSchool[ sourceTable[i][1] ] or 0 ] or module.db.schoolsColors[0]
				local spellColor = "|cff"..format("%02x%02x%02x",spellColorTable.r*255,spellColorTable.g*255,spellColorTable.b*255)
				BWInterfaceFrame.tab.tabs[1].sourceDropDown.List[i] = {
					text = spellColor..sourceTable[i][2],
					arg1 = sourceTable[i][1],
					func = DamageTab_DPS_SelectDropDownSource_Spell,
					icon = sourceTable[i][3],
					hoverFunc = DamageTab_HoverDropDownSpell,
					hoverArg = sourceTable[i][1],
					leaveFunc = GameTooltip_Hide,
				}
			end
			BWInterfaceFrame.tab.tabs[1].targetDropDown:Hide()
			BWInterfaceFrame.tab.tabs[1].targetText:Hide()			
			wipe(sourceVar)
			wipe(destVar)
			return
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[1].targetDropDown.List[i+1] = {
				text = classColor.. date("%M:%S ", timestampToFightTime( CurrentFight.damage_seen[destTable[i][1]] ))..GetGUID(destTable[i][1])..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				func = DamageTab_DPS_SelectDropDownDest,
				hoverFunc = DamageTab_ShowArrow,
				leaveFunc = DamageTab_HideArrow,
				hoverArg = timestampToFightTime( CurrentFight.damage_seen[destTable[i][1]] ) / GetFightLength(true),
				checkFunc = DamageTab_DPS_CheckDropDownDest,
				checkable = true,
			}
		end
		if not disableUpdateVars then
			wipe(sourceVar)
			wipe(destVar)
		end
	end
	
	function DamageTab_UpdatePage(updateLists,midFunc,disableUpdateVars)
		ExRT.F.dprint("Damage Tab: Update Page",GetTime())
		if updateLists then
			DamageTab_DPS(disableUpdateVars)
		end
		if midFunc then
			midFunc()
		end
		if DamageTab_Variables.state_spellsTarget then
			DamageTab_UpdateLinesSpellToTargets()
		elseif DamageTab_Variables.state_spells then
			DamageTab_UpdateLinesSpells()
		else
			DamageTab_UpdateLinesPlayers()
		end
	end
	
	tab.chkFriendly = ELib:Radio(tab,L.BossWatcherFriendly,true):Point(15,-50):AddButton():OnClick(function(self) 
		DamageTab_Variables.state_friendly = true
		DamageTab_Variables.state_spellsTarget = false
		BWInterfaceFrame.tab.tabs[1].chkEnemy:SetChecked(false)
		BWInterfaceFrame.tab.tabs[1].chkSpellsTargets:SetChecked(false)
		self:SetChecked(true)
		
		DamageTab_UpdatePage(true)
	end)
	tab.chkEnemy = ELib:Radio(tab,L.BossWatcherHostile):Point(15,-65):AddButton():OnClick(function(self) 
		DamageTab_Variables.state_friendly = false
		DamageTab_Variables.state_spellsTarget = false
		BWInterfaceFrame.tab.tabs[1].chkFriendly:SetChecked(false)
		BWInterfaceFrame.tab.tabs[1].chkSpellsTargets:SetChecked(false)
		self:SetChecked(true)
		
		DamageTab_UpdatePage(true)
	end)
	tab.chkSpellsTargets = ELib:Radio(tab,L.BossWatcherDamageDamageSpellToFriendly):Point(15,-80):AddButton():OnClick(function(self) 
		DamageTab_Variables.state_friendly = true
		DamageTab_Variables.state_spellsTarget = true
		BWInterfaceFrame.tab.tabs[1].chkFriendly:SetChecked(false)
		BWInterfaceFrame.tab.tabs[1].chkEnemy:SetChecked(false)
		self:SetChecked(true)
		
		DamageTab_UpdatePage(true)
	end)
	
	tab.bySource = ELib:Radio(tab,L.BossWatcherBySource,true):Point(200,-50):AddButton():OnClick(function(self) 
		DamageTab_Variables.state_byTarget = false
		DamageTab_Variables.state_spells = false
		BWInterfaceFrame.tab.tabs[1].byTarget:SetChecked(false)
		BWInterfaceFrame.tab.tabs[1].bySpell:SetChecked(false)
		self:SetChecked(true)
		
		DamageTab_UpdatePage(true)
	end)
	tab.byTarget = ELib:Radio(tab,L.BossWatcherByTarget):Point(200,-65):AddButton():OnClick(function(self) 
		DamageTab_Variables.state_byTarget = true
		DamageTab_Variables.state_spells = false
		BWInterfaceFrame.tab.tabs[1].bySource:SetChecked(false)
		BWInterfaceFrame.tab.tabs[1].bySpell:SetChecked(false)
		self:SetChecked(true)
		
		DamageTab_UpdatePage(true)
	end)
	tab.bySpell = ELib:Radio(tab,L.BossWatcherBySpell):Point(200,-80):AddButton():OnClick(function(self) 
		DamageTab_Variables.state_byTarget = false
		DamageTab_Variables.state_spells = true
		BWInterfaceFrame.tab.tabs[1].bySource:SetChecked(false)
		BWInterfaceFrame.tab.tabs[1].byTarget:SetChecked(false)
		self:SetChecked(true)
		
		DamageTab_UpdatePage(true)
	end)
	
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(195):Point(430,-50):SetText(L.BossWatcherAll):Tooltip(L.BossWatcherDropdownsHoldShiftSource)
	tab.sourceText = ELib:Text(tab,L.BossWatcherSource..":",12):Size(100,20):Point("RIGHT",tab.sourceDropDown,"LEFT",-6,0):Right():Color():Shadow()

	tab.targetDropDown = ELib:DropDown(tab,250,20):Size(195):Point(430,-75):SetText(L.BossWatcherAll):Tooltip(L.BossWatcherDropdownsHoldShiftDest)
	tab.targetText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.targetDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()

	
	function tab.sourceDropDown:additionalToggle()
		for i=2,#self.List do
			self.List[i].checkState = sourceVar[ self.List[i].arg1 ]
		end
	end
	function tab.targetDropDown:additionalToggle()
		for i=2,#self.List do
			self.List[i].checkState = destVar[ self.List[i].arg1 ]
		end
	end
	
	tab.showOverallChk = ELib:Check(tab,"|cffffffff"..L.BossWatcherOverdamage):Point(650,-50):Tooltip(L.BossWatcherDamageShowOver):OnClick(function (self)
		if self:GetChecked() then
			DamageTab_Variables.ShowAll = true
		else
			DamageTab_Variables.ShowAll = false
		end
		DamageTab_UpdatePage()
	end)
	
	tab.showGraphChk = ELib:Check(tab,"|cffffffff"..L.BossWatcherTabGraphics.." ",VExRT.BossWatcher.optionsDamageGraph):Point(650,-75):OnClick(function (self)
		local tab1 = BWInterfaceFrame.tab.tabs[1]
		if self:GetChecked() then
			tab1.scroll:Point("TOP",0,-305)
			BWInterfaceFrame.GraphFrame:Show()
		else
			tab1.scroll:Point("TOP",0,-100)
			BWInterfaceFrame.GraphFrame:Hide()
		end
		VExRT.BossWatcher.optionsDamageGraph = self:GetChecked()
		if DamageTab_Variables.graphCache then
			DamageTab_ReloadGraph(unpack(DamageTab_Variables.graphCache))
		end
	end)
	
	tab.scroll = ELib:ScrollFrame(tab):Point("TOP",0,VExRT.BossWatcher.optionsDamageGraph and -305 or -100):Point("BOTTOM",0,10):Height(600)
	tab.scroll:SetWidth(835)
	tab.scroll.C:SetWidth(835)
	tab.lines = {}

	local function DamageTab_RightClick_BackFunction()
		if not DamageTab_Variables.Back_state then
			DamageTab_UpdatePage(true)
			return
		end
		DamageTab_Variables.state_friendly = DamageTab_Variables.Back_state[1]
		DamageTab_Variables.state_spells = DamageTab_Variables.Back_state[2]
		DamageTab_Variables.state_spellsTarget = DamageTab_Variables.Back_state[3]
		DamageTab_Variables.state_byTarget = DamageTab_Variables.Back_state[4]
		
		DamageTab_UpdatePage(true,function()
			sourceVar = DamageTab_Variables.Back_state[5]
			destVar = DamageTab_Variables.Back_state[6]
		end)
		DamageTab_Variables.Back_state = nil
	end
	
	tab.scroll:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			DamageTab_RightClick_BackFunction()
		end
	end)
	
	local function DamageTab_Line_Check_OnClick(self)
		local spellID = self:GetParent().spellID or self:GetParent().sourceGUID
		if not spellID then
			return
		end
		local graphData = BWInterfaceFrame.GraphFrame.G.data
		if self:GetParent().isDoT and type(spellID) == 'number' then
			spellID = -spellID
		end
		local findPos = ExRT.F.table_find(graphData,spellID,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = not self:GetChecked()
		end
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	local function DamageTab_Line_OnClick(self,button)
		if button == "RightButton" then
			DamageTab_RightClick_BackFunction()
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if (self.check and self.check:IsShown() or (self:GetParent().check and self:GetParent().check:IsShown())) and x <= 30 then
			return
		end
		local GUID = self.sourceGUID
		local tooltip = self.spellLink
		
		local parent = self:GetParent()
		if parent.isMain then
			GUID = parent.sourceGUID
			tooltip = parent.spellLink
		end
		if parent.isMain and IsShiftKeyDown() and tooltip and tooltip:find("spell:") then
			local spellID = tooltip:match("%d+")
			if spellID then
				ExRT.F.LinkSpell(spellID)
				return
			end
		end
		if GUID then
			if not DamageTab_Variables.state_spells then
				DamageTab_Variables.Back_state = {
					DamageTab_Variables.state_friendly,
					DamageTab_Variables.state_spells,
					DamageTab_Variables.state_spellsTarget,
					DamageTab_Variables.state_byTarget,
					ExRT.F.table_copy2(sourceVar),
					ExRT.F.table_copy2(destVar),
				}
				DamageTab_Variables.state_spells = true
				DamageTab_UpdatePage(true,function()
					if DamageTab_Variables.state_byTarget then
						wipe(destVar)
						destVar[GUID] = true
					else
						wipe(sourceVar)
						sourceVar[GUID] = true
					end
				end,true)
			end
		end
	end
	local function DamageTab_LineOnEnter(self)
		if self.tooltip then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			local firstLine = self.tooltip[1]
			if type(firstLine) == "table" then
				firstLine = (firstLine[2] and "|T"..firstLine[2]..":18|t " or "")..firstLine[1]
			end
			GameTooltip:SetText(firstLine)
			for i=2,#self.tooltip do
				if type(self.tooltip[i]) == "table" then
					GameTooltip:AddDoubleLine(self.tooltip[i][1],self.tooltip[i][2],1,1,1,1,1,1,1,1)
				else
					GameTooltip:AddLine(self.tooltip[i])
				end
			end
			GameTooltip:Show()
		end
	end
	local function DamageTab_Line_OnEnter(self)
		local parent = self:GetParent()
		if parent.spellLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(parent.spellLink)
			GameTooltip:Show()
		elseif parent.name:IsTruncated() then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			GameTooltip:SetText(parent.name:GetText())
			GameTooltip:Show()	
		elseif parent.tooltip then
			DamageTab_LineOnEnter(parent)
		end
	end
	function DamageTab_SetLine(dataTable)
		local i,icon,name,overall_num,overall,total,dps,class,sourceGUID,spellLink,tooltip,school,overall_black,showCheck,checkState,spellID,isDoT
		
		i = dataTable.line
		icon = dataTable.icon or ""
		name = dataTable.name
		total = dataTable.num
		overall_num = dataTable.num / max(dataTable.total,1)
		overall = dataTable.num / max(dataTable.max,1)
		if dataTable.alpha then
			overall_black = dataTable.alpha / max(dataTable.num,1)
		end
		dps = dataTable.dps
		class = dataTable.class
		sourceGUID = dataTable.sourceGUID
		if dataTable.spellID and dataTable.spellID ~= -1 then
			spellLink = "spell:"..dataTable.spellID
		end
		tooltip = dataTable.tooltip
		school = dataTable.school
		showCheck = dataTable.check
		checkState = dataTable.checkState
		spellID = dataTable.spellID
		isDoT = dataTable.isDoT
		
		local line = BWInterfaceFrame.tab.tabs[1].lines[i]
		if not line then
			line = CreateFrame("Button",nil,BWInterfaceFrame.tab.tabs[1].scroll.C)
			BWInterfaceFrame.tab.tabs[1].lines[i] = line
			line:SetSize(815,20)
			line:SetPoint("TOPLEFT",0,-(i-1)*20)
			
			line.leftSide = CreateFrame("Frame",nil,line)
			line.leftSide:SetSize(1,20)
			line.leftSide:SetPoint("LEFT",5,0)
			
			line.check = ELib:Check(line,""):Point("TOPLEFT",5,-2)
			line.check:SetSize(16,16)
			line.check:SetScript("OnClick",DamageTab_Line_Check_OnClick)
			
			line.overall_num = ELib:Text(line,"45.76%",12):Size(70,20):Point(250,0):Right():Color():Shadow()

			line.icon = ELib:Icon(line,nil,18):Point("TOPLEFT",line.leftSide,0,-1)
			line.name = ELib:Text(line,"name",12):Size(0,20):Point("TOPLEFT",line.leftSide,25,0):Point("TOPRIGHT",line.overall_num,"TOPLEFT",0,0):Color():Shadow()
			line.name:SetMaxLines(1)
			
			line.name_tooltip = CreateFrame('Button',nil,line)
			line.name_tooltip:SetAllPoints(line.name)
			line.overall = line:CreateTexture(nil, "BACKGROUND")
			line.overall:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24.tga")
			line.overall:SetSize(300,16)
			line.overall:SetPoint("TOPLEFT",325,-2)
			line.overall_black = line:CreateTexture(nil, "BACKGROUND")
			line.overall_black:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24b.tga")
			line.overall_black:SetSize(300,16)
			line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)
			
			line.total = ELib:Text(line,"125.46M",12):Size(95,20):Point(630,0):Color():Shadow()
			line.dps = ELib:Text(line,"34576.43",12):Size(100,20):Point(725,0):Color():Shadow()
			
			line.back = line:CreateTexture(nil, "BACKGROUND")
			line.back:SetAllPoints()
			if i%2 == 0 then
				line.back:SetColorTexture(0.3, 0.3, 0.3, 0.1)
			end
			line.name_tooltip:SetScript("OnClick",DamageTab_Line_OnClick)
			line.name_tooltip:SetScript("OnEnter",DamageTab_Line_OnEnter)
			line.name_tooltip:SetScript("OnLeave",GameTooltip_Hide)
			line:SetScript("OnClick",DamageTab_Line_OnClick)
			line:SetScript("OnEnter",DamageTab_LineOnEnter)
			line:SetScript("OnLeave",GameTooltip_Hide)
			line:RegisterForClicks("AnyUp")
			
			line.isMain = true
		end
		if type(icon) == "table" then
			line.icon.texture:SetTexture(icon[1] or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(unpack(icon,2,5))
		else
			line.icon.texture:SetTexture(icon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(0,1,0,1)
		end
		line.name:SetText(name or "")
		line.overall_num:SetFormattedText("%.2f%%",overall_num and overall_num * 100 or 0)
		if overall_black and overall_black > 0 then
			local width = 300*(overall or 1)
			local normal_width = width * (1 - overall_black)
			line.overall:SetWidth(max(normal_width,1))
			line.overall_black:SetWidth(max(width-normal_width,1))
			line.overall_black:Show()
			if normal_width == 0 then
				line.overall:Hide()
				line.overall_black:SetPoint("TOPLEFT",325,-2)
			else
				line.overall:Show()
				line.overall_black:ClearAllPoints()
				line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)
			end
		else
			line.overall:Show()
			line.overall_black:Hide()
			line.overall:SetWidth(max(300*(overall or 1),1))
		end
		line.total:SetText(total and ExRT.F.shortNumber(total) or "")
		do
			dps = dps or 0
			line.dps:SetFormattedText("%s.%s",FormatLargeNumber(floor(dps)),format("%.2f",dps % 1):gsub("^.-%.",""))
		end
		line.overall:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		line.overall_black:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		if class then
			local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			if classColorArray then
				line.overall:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
				line.overall_black:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
			else
				line.overall:SetVertexColor(0.8,0.8,0.8, 1)
				line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
			end
		else
			line.overall:SetVertexColor(0.8,0.8,0.8, 1)
			line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
		end
		if school then
			SetSchoolColorsToLine(line.overall,school)
			SetSchoolColorsToLine(line.overall_black,school)
		end
		if showCheck then
			line.leftSide:SetPoint("LEFT",25,0)
			line.check:SetChecked(checkState)
			line.check:Show()
		else
			line.leftSide:SetPoint("LEFT",5,0)
			line.check:Hide()
		end
		line.sourceGUID = sourceGUID
		line.spellID = spellID
		line.spellLink = spellLink
		line.tooltip = tooltip
		line.isDoT = isDoT
		line:Show()
	end
	
		
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.report:Show()
		
		BWInterfaceFrame.GraphFrame:SetPoint("TOP",0,-105)
		if BWInterfaceFrame.tab.tabs[1].showGraphChk:GetChecked() then
			BWInterfaceFrame.GraphFrame:Show()
		end
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			local currFightIDShort = GetFightID(CurrentFight,true)
			local disableUpdateVars = nil
			if currFightIDShort == self.lastFightShortID then
				disableUpdateVars = true
			end
			self.lastFightShortID = currFightIDShort
			DamageTab_Variables.graphCache = nil
			Graph_AutoUpdateStep()
			DamageTab_UpdatePage(true,nil,disableUpdateVars)
			self.lastFightID = BWInterfaceFrame.nowFightID
		elseif DamageTab_Variables.graphCache then
			ExRT.F.dprint("Damage Page <Show>: Update Graph",GetTime())
			DamageTab_ReloadGraph(unpack(DamageTab_Variables.graphCache))
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
		BWInterfaceFrame.GraphFrame:Hide()
	end)
	
	
	
	
	---- Auras Tab
	tab = BWInterfaceFrame.tab.tabs[3]
	local aurasTab = tab
	
	local AurasTab_Variables = {
		FilterSource = 0x0111,
		FilterSourceGUID = {},
		FilterDest = 0x0110,
		FilterDestGUID = {},
		NameWidth = 188,
		WorkWidth = 650,
		TotalLines = 28,
		IsFriendly = true,

		buffsFilters = {
			[1] = {[-1]=L.BossWatcherFilterOnlyBuffs,}, --> Only buffs
			[2] = {[-1]=L.BossWatcherFilterOnlyDebuffs,}, --> Only debuffs
			[3] = {[-1]=L.BossWatcherFilterBySpellID,}, --> By spellID
			[4] = {[-1]=L.BossWatcherFilterBySpellName,}, --> By spellName
			[5] = {
				[-1]=L.BossWatcherFilterTaunts,
				[-2]={62124,17735,97827,56222,51399,49560,6795,355,115546,116189,185245},
			},
			[6] = {
				[-1]=L.BossWatcherFilterStun,
				[-2]={853,105593,91797,408,119381,89766,118345,46968,107570,5211,44572,119392,122057,113656,108200,108194,30283,118905,20549,119072,115750},
			},
			[7] = {
				[-1]=L.BossWatcherFilterPersonal,
				[-2]={148467,31224,110788,55694,47585,31850,115610,122783,642,5277,118038,104773,115176,48707,1966,61336,120954,871,106922,30823,6229,22812,498},
			},
			[8] = {
				[-1]=L.BossWatcherFilterRaidSaves,
				[-2]={145629,114192,114198,81782,108281,97463,31821,15286,115213,44203,64843,76577},
			},
			[9] = {
				[-1]=L.BossWatcherFilterPotions,
				[-2]={279152,279153,279151,269853,250878,252753,251316,251231,300714,298225,298317,300741,298146,298152,298153,298154,298155},
			},
			[10] = {
				[-1]="DPS CD",
				[-2]={31884,162264,26297,266091,1719,47568,193530,80353,190319,113860,188592,194223,295840,296962},
			},
		},
		buffsFilterStatus = {
			[1] = true,
		},
	}
	AurasTab_Variables.TotalWidth = AurasTab_Variables.NameWidth + AurasTab_Variables.WorkWidth
	--[[
	0x0001 - hostile
	0x0010 - friendly
	0x0100 - pets & guards
	0x1000 - by GUID
	]]

	for i=5,#AurasTab_Variables.buffsFilters do
		for _,sID in ipairs(AurasTab_Variables.buffsFilters[i][-2]) do
			AurasTab_Variables.buffsFilters[i][sID] = true
		end
	end
	
	local UpdateBuffsPage,UpdateBuffPageDB
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-9)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	tab.headerTab = ELib:Tabs(tab,0,
		L.BossWatcherBuff,
		L.BossWatcherDebuff
	):Size(850,555):Point("TOP",0,-29):SetTo(1)
	tab.headerTab:SetBackdropBorderColor(0,0,0,0)
	tab.headerTab:SetBackdropColor(0,0,0,0)	
	
	tab.headerTab.tabs[1].button.additionalFunc = function()
		AurasTab_Variables.buffsFilterStatus[1] = true
		AurasTab_Variables.buffsFilterStatus[2] = false
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end
	tab.headerTab.tabs[2].button.additionalFunc = function()
		AurasTab_Variables.buffsFilterStatus[1] = false
		AurasTab_Variables.buffsFilterStatus[2] = true
		UpdateBuffPageDB()
		UpdateBuffsPage()	
	end	
	
	tab.timeLine = {}
	
	do
		local scheduledUpdate
		tab.nameFilterEditBox = ELib:Edit(tab.DecorationLine):Point("RIGHT",-50,0):Size(150,16):AddSearchIcon():OnChange(function (self,isUser)
			if not isUser then
				return
			end
			local text = self:GetText()
			for key,val in pairs(AurasTab_Variables.buffsFilters[4]) do
				if key ~= -1 then
					AurasTab_Variables.buffsFilters[4][key] = nil
				end
			end
			for key,val in pairs(AurasTab_Variables.buffsFilters[3]) do
				if key ~= -1 then
					AurasTab_Variables.buffsFilters[3][key] = nil
				end
			end
			local lines = {strsplit(",", text)}
			for i=1,#lines do
				if lines[i] ~= "" then
					local s = lines[i]
					if tonumber(s) then
						AurasTab_Variables.buffsFilters[3][ tonumber(s) ] = true
					else
						AurasTab_Variables.buffsFilters[4][ strlower(s) ] = true
					end
				end
			end
			if (ExRT.F.table_len(AurasTab_Variables.buffsFilters[4]) + ExRT.F.table_len(AurasTab_Variables.buffsFilters[3])) > 2 then
				AurasTab_Variables.buffsFilterStatus[4] = true
				if not scheduledUpdate then
					scheduledUpdate = C_Timer.NewTimer(1,function()
						scheduledUpdate = nil
						UpdateBuffPageDB()
						UpdateBuffsPage()
					end)
				end
			else
				AurasTab_Variables.buffsFilterStatus[4] = false
				if scheduledUpdate then
					scheduledUpdate:Cancel()
				end
				scheduledUpdate = nil
				UpdateBuffPageDB()
				UpdateBuffsPage()
				return
			end
		end)
	end

	tab.chkFriendly = ELib:Radio(tab,L.BossWatcherFriendly,true):Point(15,-35):AddButton():OnClick(function(self) 
		aurasTab.chkEnemy:SetChecked(false)
		self:SetChecked(true)
		
		AurasTab_Variables.IsFriendly = true
		AurasTab_Variables.FilterDest = 0x0110
		
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end)
	tab.chkEnemy = ELib:Radio(tab,L.BossWatcherHostile):Point(15,-50):AddButton():OnClick(function(self) 
		aurasTab.chkFriendly:SetChecked(false)
		self:SetChecked(true)
		
		AurasTab_Variables.IsFriendly = false
		AurasTab_Variables.FilterDest = 0x0101
		
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end)
	
	local function AurasTab_ActivateAnyPage(tab,check)
		local f1,f2 = UpdateBuffsPage,UpdateBuffPageDB
		UpdateBuffsPage,UpdateBuffPageDB = ExRT.NULLfunc, ExRT.NULLfunc
		aurasTab.headerTab.tabs[tab].button:Click()
		aurasTab[check == 1 and "chkFriendly" or "chkEnemy"]:Click()
		UpdateBuffsPage,UpdateBuffPageDB = f1,f2
	end
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(190):Point(240,-38):SetText(L.BossWatcherAll)
	tab.sourceText = ELib:Text(tab,L.BossWatcherSource..":",12):Size(100,20):Point("TOPRIGHT",tab.sourceDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()

	tab.targetDropDown = ELib:DropDown(tab,250,20):Size(190):Point(520,-38):SetText(L.BossWatcherAll)
	tab.targetText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.targetDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	
	tab.filterDropDown = ELib:DropDown(tab,150,#AurasTab_Variables.buffsFilters-3):Size(125):Point(725,-38):SetText(L.BossWatcherBuffsAndDebuffsFilterFilter)
	tab.filterDropDown.List[1] = {text = RESET,func = function()
		ELib:DropDownClose()
		for i=5,#AurasTab_Variables.buffsFilters do
			AurasTab_Variables.buffsFilterStatus[i] = false
		end
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end,padding = 16}
	do
		local Activate = {
			[5] = {2,2},
			[7] = {1,1},
			[8] = {1,1},
			[9] = {1,1},
		}
		local function OnClick(_,arg)
			ELib:DropDownClose()
			for i=5,#AurasTab_Variables.buffsFilters do
				AurasTab_Variables.buffsFilterStatus[i] = nil
			end
			AurasTab_Variables.buffsFilterStatus[arg] = not AurasTab_Variables.buffsFilterStatus[arg]
			if Activate[arg] then
				AurasTab_ActivateAnyPage(unpack(Activate[arg]))
			end
			UpdateBuffPageDB()
			UpdateBuffsPage()
		end
		local function OnEnter(self,i)
			local sList = AurasTab_Variables.buffsFilters[i][-2]
			if not sList then
				sList = {}
				for sid,_ in pairs(AurasTab_Variables.buffsFilters[i]) do
					if sid > 0 then
						sList[#sList + 1] = sid
					end
				end
			end
			if #sList == 0 then
				return
			end
			local sList2 = {}
			if #sList <= 35 then
				for j=1,#sList do
					local sID,_,sT=GetSpellInfo(sList[j])
					if sID then
						sList2[#sList2 + 1] = "|T"..sT..":0|t |cffffffff"..sID.."|r"
					end
				end
			else
				local count = 1
				for j=1,#sList do
					local sID,_,sT=GetSpellInfo(sList[j])
					if sID then
						if not sList2[count] then
							sList2[count] = {"|T"..sT..":0|t |cffffffff"..sID.."|r"}
						elseif not sList2[count].right then
							sList2[count].right = "|cffffffff"..sID.."|r |T"..sT..":0|t"
							count = count + 1
						end
					end
				end
			end
			ELib.Tooltip.Show(self,"ANCHOR_LEFT",L.BossWatcherFilterTooltip..":",unpack(sList2))
		end		
		for i=5,#AurasTab_Variables.buffsFilters do
			tab.filterDropDown.List[i-3] = {
				text = AurasTab_Variables.buffsFilters[i][-1],
				arg1 = i,
				func = OnClick,
				checkFunc = function(self,checked)
					AurasTab_Variables.buffsFilterStatus[i] = checked
					UpdateBuffPageDB()
					UpdateBuffsPage()
				end,
				checkable = true,
				hoverFunc = OnEnter,
				leaveFunc = ELib.Tooltip.Hide,
				hoverArg = i,
			}
		end
	end
	function tab.filterDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = AurasTab_Variables.buffsFilterStatus[3+i]
		end
	end

	function tab.sourceDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = AurasTab_Variables.FilterSourceGUID[self.List[i].arg1]
		end
	end
	function tab.targetDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = AurasTab_Variables.FilterDestGUID[self.List[i].arg1]
		end
	end
	
	local function AurasTab_UpdateDropDownText(dropDown,arr)
		local count = ExRT.F.table_len(arr)
		if count == 0 then
			dropDown:SetText(L.BossWatcherAll)
		elseif count == 1 then
			local GUID = nil
			for g,_ in pairs(arr) do
				GUID = g
			end
			local name = GetGUID(GUID)
			local flags = CurrentFight.reaction[GUID]
			local isPlayer = flags and ExRT.F.GetUnitInfoByUnitFlag(flags,1) == 1024
			local isNPC = flags and ExRT.F.GetUnitInfoByUnitFlag(flags,2) == 512
			if isPlayer then
				name = "|c"..ExRT.F.classColorByGUID(GUID)..name
			elseif isNPC then
				name = name .. GUIDtoText(" [%s]",GUID)
			end
			dropDown:SetText(name)
		else
			dropDown:SetText(L.BossWatcherSeveral)
		end
	end
	local function AurasTab_UpdateDropDownsTexts()
		AurasTab_UpdateDropDownText(aurasTab.sourceDropDown,AurasTab_Variables.FilterSourceGUID)
		AurasTab_UpdateDropDownText(aurasTab.targetDropDown,AurasTab_Variables.FilterDestGUID)
		
		local anyFilter = nil
		for i=5,#AurasTab_Variables.buffsFilters do
			if AurasTab_Variables.buffsFilterStatus[i] then
				anyFilter = true
				break
			end
		end
		aurasTab.filterDropDown:SetText((anyFilter and "|cff00ff00" or "")..L.BossWatcherBuffsAndDebuffsFilterFilter)
	end
	
	
	local function AurasTab_SelectDropDownSource(self,arg)
		ELib:DropDownClose()
		wipe(AurasTab_Variables.FilterSourceGUID)
		if not arg then
			AurasTab_Variables.FilterSource = 0x0111
		elseif IsShiftKeyDown() then
			AurasTab_Variables.FilterSource = 0x1000
			AurasTab_Variables.FilterSourceGUID[arg] = true
			local name = CurrentFight.guids[arg]
			if name then
				for GUID,GUIDname in pairs(CurrentFight.guids) do
					if GUIDname == name then
						AurasTab_Variables.FilterSourceGUID[arg] = true
					end
				end
			end
		else
			AurasTab_Variables.FilterSource = 0x1000
			AurasTab_Variables.FilterSourceGUID[arg] = true		
		end
		UpdateBuffPageDB(true)
		UpdateBuffsPage()
	end
	local function AurasTab_SelectDropDownDest(self,arg)
		ELib:DropDownClose()
		wipe(AurasTab_Variables.FilterDestGUID)
		if not arg then
			if AurasTab_Variables.IsFriendly then
				AurasTab_Variables.FilterDest = 0x0110
			else
				AurasTab_Variables.FilterDest = 0x0101
			end
		elseif IsShiftKeyDown() then
			AurasTab_Variables.FilterDest = 0x1000
			AurasTab_Variables.FilterDestGUID[arg] = true
			local name = CurrentFight.guids[arg]
			if name then
				for GUID,GUIDname in pairs(CurrentFight.guids) do
					if GUIDname == name then
						AurasTab_Variables.FilterDestGUID[arg] = true
					end
				end
			end
		else
			AurasTab_Variables.FilterDest = 0x1000
			AurasTab_Variables.FilterDestGUID[arg] = true
		end
		UpdateBuffPageDB(true)
		UpdateBuffsPage()
	end
	
	local function AurasTab_CheckDropDownSource(self,checked)
		if checked then
			AurasTab_Variables.FilterSource = 0x1000
			AurasTab_Variables.FilterSourceGUID[self.arg1] = true
		else
			AurasTab_Variables.FilterSourceGUID[self.arg1] = nil
			if ExRT.F.table_len(AurasTab_Variables.FilterSourceGUID) == 0 then
				AurasTab_Variables.FilterSource = 0x0111
			end
		end
		UpdateBuffPageDB(true)
		UpdateBuffsPage()
	end
	local function AurasTab_CheckDropDownDest(self,checked)
		if checked then
			AurasTab_Variables.FilterDest = 0x1000
			AurasTab_Variables.FilterDestGUID[self.arg1] = true
		else
			AurasTab_Variables.FilterDestGUID[self.arg1] = nil
			if ExRT.F.table_len(AurasTab_Variables.FilterDestGUID) == 0 then
				if AurasTab_Variables.IsFriendly then
					AurasTab_Variables.FilterDest = 0x0110
				else
					AurasTab_Variables.FilterDest = 0x0101
				end
			end
		end
		UpdateBuffPageDB(true)
		UpdateBuffsPage()
	end
	
	for i=1,11 do
		local line = CreateFrame("Frame",nil,tab)
		tab.timeLine[i] = line
		line:SetPoint("TOPLEFT",AurasTab_Variables.NameWidth+(i-1)*(AurasTab_Variables.WorkWidth/10)-1,-72)
		line:SetSize(2,AurasTab_Variables.TotalLines * 18 + 14)
		
		line.texture = line:CreateTexture(nil, "BACKGROUND")
		line.texture:SetColorTexture(1, 1, 1, 0.3)
		line.texture:SetAllPoints()		
		
		line.timeText = ELib:Text(line,"",11):Size(200,12):Point("TOPRIGHT",line,"TOPLEFT",-1,-1):Right():Top():Color()
	end
	
	tab.redDeathLine = {}
	local function CreateRedDeathLine(i)
		if not aurasTab.redDeathLine[i] then
			local line = aurasTab:CreateTexture(nil, "BACKGROUND",0,-4)
			aurasTab.redDeathLine[i] = line
			line:SetColorTexture(1, 0.3, 0.3, 1)
			line:SetSize(2,AurasTab_Variables.TotalLines * 18 + 14)
			line:Hide()
		end
	end
	
	tab.linesRightClickMenu = {
		{ text = "Spell", isTitle = true, notCheckable = true, notClickable = true },
		{ text = L.BossWatcherSendToChat, func = function() 
			if aurasTab.linesRightClickMenuData then
				local chat_type = ExRT.F.chatType(true)
				SendChatMessage(aurasTab.linesRightClickMenuData[1],chat_type)
				for i=2,#aurasTab.linesRightClickMenuData do
					SendChatMessage(ExRT.F.clearTextTag(aurasTab.linesRightClickMenuData[i]),chat_type)
				end
			end
			CloseDropDownMenus()
		end, notCheckable = true },
		{  text = L.BossWatcherOnlySegmentsWithAura, func = function() 
			CloseDropDownMenus()
			local buffData = aurasTab.linesRightClickLineData
			if not buffData then
				return
			end
			local table1 = {}
			for i=1,#buffData[5] do
				table1[#table1+1] = buffData[5][i][3]
				table1[#table1+1] = buffData[5][i][4]
			end
			local len = #table1
			for i=1,len,2 do
				local time_start,time_end = table1[i],table1[i+1]
				if time_start then
					for j=i+2,len,2 do
						local new_start,new_end = table1[j],table1[j+1]
						if new_start then
							if new_start <= time_start and new_end > time_start then
								time_start = new_start
								time_end = max(time_end,new_end)
								
								table1[j] = nil
								table1[j+1] = nil
							elseif new_start > time_start and new_start <= time_end then
								time_end = max(time_end,new_end)
								
								table1[j] = nil
								table1[j+1] = nil
							end
						end
					end
					table1[i] = time_start
					table1[i+1] = time_end
				end
			end
			UpdateSegments(-1,-1,false,true)
			for i=1,len,2 do
				if table1[i] then
					UpdateSegmentsTime(table1[i]+CurrentFight.encounterStart,table1[i+1]+CurrentFight.encounterStart,true,true)
				end
			end
			UpdateSegments(-1,-1,true,false)
		end, notCheckable = true },
		{ text = L.BossWatcherAddToGraph, func = function() 
			CloseDropDownMenus()
			local buffData = aurasTab.linesRightClickLineData
			if not buffData then
				return
			end
			local table1 = {}
			for i=1,#buffData[5] do
				table1[#table1+1] = buffData[5][i][3]
				table1[#table1+1] = buffData[5][i][4]
			end
			local len = #table1
			for i=1,len,2 do
				local time_start,time_end = table1[i],table1[i+1]
				if time_start then
					for j=i+2,len,2 do
						local new_start,new_end = table1[j],table1[j+1]
						if new_start then
							if new_start <= time_start and new_end > time_start then
								time_start = new_start
								time_end = max(time_end,new_end)
								
								table1[j] = nil
								table1[j+1] = nil
							elseif new_start > time_start and new_start <= time_end then
								time_end = max(time_end,new_end)
								
								table1[j] = nil
								table1[j+1] = nil
							end
						end
					end
					table1[i] = time_start
					table1[i+1] = time_end
				end
			end
			local table2 = {}
			for i=1,len,2 do
				if table1[i] then
					table2[#table2 + 1] = table1[i]
					table2[#table2 + 1] = table1[i + 1]
				end
			end
			BWInterfaceFrame.GraphFrame.G.highlight = table2
		end, notCheckable = true },
		{ text = L.BossWatcherAurasMoreInfoText, func = function() 
			if aurasTab.linesRightClickMoreInfoData then
				aurasTab.linesRightClickMoreInfo:Update()
				aurasTab.linesRightClickMoreInfo:ShowClick()
			end
			CloseDropDownMenus()
		end, notCheckable = true },
		{ text = L.minimapmenuclose, func = function() CloseDropDownMenus() end, notCheckable = true },
	}
	tab.linesRightClickMenuDropDown = CreateFrame("Frame", BWInterfaceFrame_Name.."AurasTab".."LinesRightClickMenuDropDown", nil, "UIDropDownMenuTemplate")
	
	tab.linesRightClickMoreInfo = ELib:Popup(L.BossWatcherAurasMoreInfoText):Size(300,375)
	tab.linesRightClickMoreInfo.ScrollFrame = ELib:ScrollFrame(tab.linesRightClickMoreInfo):Size(285,320):Point("TOP",0,-25):Height(400)
	--tab.linesRightClickMoreInfo.ScrollFrame.backdrop:Hide()
	tab.linesRightClickMoreInfo.lines = {}
	tab.linesRightClickMoreInfo.anchor = "TOPRIGHT"
	tab.linesRightClickMoreInfo.reportButton = ELib:Button(tab.linesRightClickMoreInfo,L.BossWatcherCreateReport):Size(292,20):Point("BOTTOM",0,5):Tooltip(L.BossWatcherCreateReportTooltip):OnClick(function (self)
		ExRT.F:ToChatWindow(aurasTab.linesRightClickMoreInfo.report)
		aurasTab.linesRightClickMoreInfo:Hide()
	end)
	do
		local function LineOnEnter(self)
			if self.name:IsTruncated() then
				GameTooltip:SetOwner(self,"ANCHOR_LEFT")
				GameTooltip:SetText(self.name:GetText())
				GameTooltip:Show()
 			end
		end
		local function SetLine(i,name,count)
			if not aurasTab.linesRightClickMoreInfo.lines[i] then
				local line = CreateFrame("Button",nil,aurasTab.linesRightClickMoreInfo.ScrollFrame.C)
				aurasTab.linesRightClickMoreInfo.lines[i] = line
				line:SetSize(270,20)
				line:SetPoint("TOPLEFT",0,-(i-1)*20)
				
				line.name = ELib:Text(line,"name",11):Size(210,20):Point(10,0):Color():Shadow()
				line.count = ELib:Text(line,"name",12):Size(40,20):Point(220,0):Center():Color():Shadow()
				
				line.back = line:CreateTexture(nil, "BACKGROUND")
				line.back:SetAllPoints()
				if i%2==0 then
					line.back:SetColorTexture(0.3, 0.3, 0.3, 0.1)
				end
				
				line:SetScript("OnEnter",LineOnEnter)
				line:SetScript("OnLeave",GameTooltip_Hide)
			end
			aurasTab.linesRightClickMoreInfo.lines[i].name:SetText(i..". "..name)
			aurasTab.linesRightClickMoreInfo.lines[i].count:SetText(count)
			
			aurasTab.linesRightClickMoreInfo.lines[i]:Show()
		end
		tab.linesRightClickMoreInfo.Update = function(self)
			local spellID = aurasTab.linesRightClickMoreInfoData
			self.title:SetText(GetSpellInfo(spellID) or "?")
			local data = {}
			for i,sourceData in ipairs(CurrentFight.auras) do
				if sourceData[6] == spellID and (sourceData[8] == 1 or sourceData[8] == 3) and (not aurasTab.filterS or (aurasTab.filterS == 1 and sourceData[4]) or (aurasTab.filterS == 2 and not sourceData[4]) or aurasTab.filterS == sourceData[2]) then
					local inPos = ExRT.F.table_find(data,sourceData[3],1)
					if not inPos then
						inPos = #data + 1
						data[inPos] = {sourceData[3],0,0}
					end
					data[inPos][2] = data[inPos][2] + 1
				end
			end
			for destGUID,destData in pairs(CurrentFight.damage) do
				for destReaction,destReactData in pairs(destData) do
					for sourceGUID,sourceData in pairs(destReactData) do
						if not aurasTab.filterS or aurasTab.filterS == sourceGUID then
							if sourceData[spellID] then
								for segment,spellAmount in pairs(sourceData[spellID]) do
									local missed = spellAmount.parry + spellAmount.dodge + spellAmount.miss
									if missed > 0 then
										local inPos = ExRT.F.table_find(data,destGUID,1)
										if not inPos then
											inPos = #data + 1
											data[inPos] = {destGUID,0,0}
										end
										data[inPos][3] = data[inPos][3] + 1
									end
								end
							end
						end
					end
				end
			end
			sort(data,function(a,b)return a[2]>b[2]end)
			local report = {}
			aurasTab.linesRightClickMoreInfo.report = report
			report[1] = GetSpellLink(spellID)
			for i=1,#data do
				local isPlayer = ExRT.F.GetUnitTypeByGUID(data[i][1]) == 0
				local classColor = ""
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(data[i][1])
				end
				SetLine(i,classColor..GetGUID(data[i][1])..GUIDtoText(" [%s]",data[i][1]),data[i][2]..(data[i][3] > 0 and "+"..data[i][3] or ""))
				report[#report+1] = i..". "..GetGUID(data[i][1]).." - "..data[i][2]..(data[i][3] > 0 and "+"..data[i][3] or "")
			end
			for i=#data+1,#aurasTab.linesRightClickMoreInfo.lines do
				aurasTab.linesRightClickMoreInfo.lines[i]:Hide()
			end
			aurasTab.linesRightClickMoreInfo.ScrollFrame:SetNewHeight(#data * 20)
		end
	end
	
	local BuffsLineUptimeTempTable = {}
	local function BuffsLinesOnUpdate(self)
		local x,y = ExRT.F.GetCursorPos(self)
		if ExRT.F.IsInFocus(self,x,y) then
			for j=1,AurasTab_Variables.TotalLines do
				if aurasTab.lines[j] ~= self then
					aurasTab.lines[j].hl:Hide()
				end
			end
			self.hl:Show()
			if x <= AurasTab_Variables.NameWidth then
				if GameTooltip:IsShown() then
					local _,spellID = GameTooltip:GetSpell()
					if spellID == self.spellID then
						return
					end
				end
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -AurasTab_Variables.WorkWidth, 0)
				GameTooltip:SetHyperlink(self.spellLink)
				
				local greenCount = #self.greenTooltips
				for i=1,greenCount do
					BuffsLineUptimeTempTable[(i-1)*2+1] = self.greenTooltips[i][1]
					BuffsLineUptimeTempTable[(i-1)*2+2] = self.greenTooltips[i][2]
				end
				for i=1,greenCount do
					local iPos = (i-1)*2+1
					if BuffsLineUptimeTempTable[iPos] then
						for j=1,greenCount do
							local jPos = (j-1)*2+1
							if i~=j and BuffsLineUptimeTempTable[jPos] then
								if BuffsLineUptimeTempTable[jPos] <= BuffsLineUptimeTempTable[iPos] and BuffsLineUptimeTempTable[jPos+1] > BuffsLineUptimeTempTable[iPos] then
									BuffsLineUptimeTempTable[iPos] = BuffsLineUptimeTempTable[jPos]
									BuffsLineUptimeTempTable[iPos+1] = max(BuffsLineUptimeTempTable[jPos+1],BuffsLineUptimeTempTable[iPos+1])
									BuffsLineUptimeTempTable[jPos] = nil
									BuffsLineUptimeTempTable[jPos+1] = nil
								end
								if BuffsLineUptimeTempTable[jPos] and BuffsLineUptimeTempTable[jPos+1] >= BuffsLineUptimeTempTable[iPos+1] and BuffsLineUptimeTempTable[jPos] < BuffsLineUptimeTempTable[iPos+1] then
									BuffsLineUptimeTempTable[iPos] = min(BuffsLineUptimeTempTable[jPos],BuffsLineUptimeTempTable[iPos])
									BuffsLineUptimeTempTable[iPos+1] = BuffsLineUptimeTempTable[jPos+1]
									BuffsLineUptimeTempTable[jPos] = nil
									BuffsLineUptimeTempTable[jPos+1] = nil
								end
							end
						end
					end
				end
				local uptime = 0
				for i=1,greenCount do
					local iPos = (i-1)*2+1
					if BuffsLineUptimeTempTable[iPos] then
						uptime = uptime + (BuffsLineUptimeTempTable[iPos+1] - BuffsLineUptimeTempTable[iPos])
					end
				end
				uptime = uptime / AurasTab_Variables.WorkWidth
				
				GameTooltip:AddLine(L.BossWatcherBuffsAndDebuffsTooltipUptimeText..": "..format("%.2f%% (%.1f %s)",uptime*100,uptime*GetFightLength(true),L.BossWatcherBuffsAndDebuffsSecondsText))
				GameTooltip:AddLine(L.BossWatcherBuffsAndDebuffsTooltipCountText..": "..(self.greenCount or 0))
				GameTooltip:Show()
			else
				if not self.tooltip then
					self.tooltip = {}
				end
				table.wipe(self.tooltip)
				local owner = nil
				local _min,_max = AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth,AurasTab_Variables.NameWidth
				for j = 1,#self.greenTooltips do
					local greenTooltip = self.greenTooltips[j]

					local rightPos = greenTooltip[2]
					local leftPos = greenTooltip[1]
					if rightPos - leftPos < 2 then
						rightPos = leftPos + 2
					end
					if x >= leftPos and x <= rightPos then
						local sourceClass = ExRT.F.classColorByGUID(greenTooltip[5])
						local destClass = ExRT.F.classColorByGUID(greenTooltip[6])
						local duration = (greenTooltip[4] - greenTooltip[3])
						table.insert(self.tooltip, date("[%M:%S", greenTooltip[3] ) .. format(".%03d",(greenTooltip[3]*1000)%1000).. " - "..date("%M:%S", greenTooltip[3]+duration ).. format(".%03d",((greenTooltip[3]+duration)*1000)%1000).."] " .. "|c" .. sourceClass .. GetGUID(greenTooltip[5])..GUIDtoText(" (%s)",greenTooltip[5]).."|r "..L.BossWatcherBuffsAndDebuffsTextOn.." |c".. destClass .. GetGUID(greenTooltip[6])..GUIDtoText(" (%s)",greenTooltip[6]).."|r")
						if greenTooltip[7] and greenTooltip[7] ~= 1 then
							self.tooltip[#self.tooltip] = self.tooltip[#self.tooltip] .. " (".. greenTooltip[7] ..")"
						end
						self.tooltip[#self.tooltip] = self.tooltip[#self.tooltip] .. format(" <%.1f%s>",duration,L.BossWatcherBuffsAndDebuffsSecondsText)
						owner = greenTooltip[1]
						
						_min = min(_min,leftPos)
						_max = max(_max,rightPos)
					end
				end
				if #self.tooltip > 0 then
					table.sort(self.tooltip,function(a,b) return a < b end)
					ELib.Tooltip.Show(self,{"ANCHOR_LEFT",owner or 0,0},L.BossWatcherBuffsAndDebuffsTooltipTitle..":",unpack(self.tooltip))
				else
					GameTooltip_Hide()
				end
			end
		end
	end
	local function BuffsLinesOnLeave(self)
		GameTooltip_Hide()
		self.hl:Hide()
	end
	local function BuffsLinesOnClick(self,button)
		local x,y = ExRT.F.GetCursorPos(self)
		if x > 0 and x < AurasTab_Variables.TotalWidth and y > 0 and y < 18 then
			if x <= AurasTab_Variables.NameWidth then
				ExRT.F.LinkSpell(nil,self.spellLink)
			elseif button == "RightButton" then
				if GameTooltip:IsShown() then
					if aurasTab.linesRightClickMenuData then
						wipe(aurasTab.linesRightClickMenuData)
					else
						aurasTab.linesRightClickMenuData = {}
					end
					table.insert(aurasTab.linesRightClickMenuData , self.spellLink)
					for j=2, GameTooltip:NumLines() do
						table.insert(aurasTab.linesRightClickMenuData , _G["GameTooltipTextLeft"..j]:GetText())
					end
					aurasTab.linesRightClickMenu[1].text = self.spellName
				else
					aurasTab.linesRightClickMenuData = nil
				end
				aurasTab.linesRightClickMoreInfoData = self.spellID
				aurasTab.linesRightClickLineData = self.lineData
				EasyMenu(aurasTab.linesRightClickMenu, aurasTab.linesRightClickMenuDropDown, "cursor", 10 , -15, "MENU")
			end
		end
	end
			
	tab.lines = {}
	for i=1,AurasTab_Variables.TotalLines do
		local line = CreateFrame("Button",nil,tab)
		tab.lines[i] = line
		line:SetSize(AurasTab_Variables.TotalWidth,18)
		line:SetPoint("TOPLEFT", 0, -18*(i-1)-84)
		
		line.spellIcon = line:CreateTexture(nil, "BACKGROUND")
		line.spellIcon:SetSize(16,16)
		line.spellIcon:SetPoint("TOPLEFT", 5, -1)
		
		line.spellText = ELib:Text(line,"",11):Size(AurasTab_Variables.NameWidth-23,18):Point(23,0):Color()
		
		line.green = {}
		line.greenFrame = {}
		line.greenCount = 0
		
		line.greenTooltips = {}
		
		ExRT.lib.CreateHoverHighlight(line)
		line.hl:SetAlpha(.5)
		
		line:SetScript("OnUpdate", BuffsLinesOnUpdate) 
		line:SetScript("OnLeave", BuffsLinesOnLeave)
		line:RegisterForClicks("RightButtonUp","LeftButtonUp")
		line:SetScript("OnClick", BuffsLinesOnClick)
	end
	
	tab.scrollBar = ELib:ScrollBar(tab):Size(16,AurasTab_Variables.TotalLines*18):Point("TOPRIGHT",-5,-84):Range(1,2)
	
	local function CreateBuffGreen(i,j)
		aurasTab.lines[i].green[j] = aurasTab.lines[i]:CreateTexture(nil, "BACKGROUND",nil,5)
		aurasTab.lines[i].green[j]:SetColorTexture(1, 0.82, 0, 0.7)	
		aurasTab.lines[i].greenFrame[j] = CreateFrame("Frame",nil,aurasTab.lines[i])
	end
		
	local function buffsFunc_isPetOrGuard(flag)
		if not flag then
			return false
		end
		local res = ExRT.F.GetUnitInfoByUnitFlag(flag,1)
		if res == 4096 or res == 8192 then
			return true
		end
	end
	local function buffsFunc_findStringInArray(array,str)
		for array_str,_ in pairs(array) do
			if type(array_str) == "string" and (array_str == str or str:find(array_str)) then
				return true
			end
		end
	end
	
	
	function UpdateBuffPageDB(notUpdateTargetsList)
		--upvaules
		local currFight = CurrentFight
		local buffsFilterStatus = AurasTab_Variables.buffsFilterStatus
		
		AurasTab_UpdateDropDownsTexts()
		
		local fightDuration = GetFightLength(true)
		for i=1,10 do
			aurasTab.timeLine[i+1].timeText:SetText( date("%M:%S", fightDuration*(i/10) ) )
		end
		
		local _F_sourceGUID = bit.band(AurasTab_Variables.FilterSource,0xF000) > 0
		local _F_sourceFriendly = bit.band(AurasTab_Variables.FilterSource,0x00F0) > 0
		local _F_sourceHostile = bit.band(AurasTab_Variables.FilterSource,0x000F) > 0
		local _F_sourcePets = bit.band(AurasTab_Variables.FilterSource,0x0F00) > 0
		
		local _F_destGUID = bit.band(AurasTab_Variables.FilterDest,0xF000) > 0
		local _F_destFriendly = bit.band(AurasTab_Variables.FilterDest,0x00F0) > 0
		local _F_destHostile = bit.band(AurasTab_Variables.FilterDest,0x000F) > 0
		local _F_destPets = bit.band(AurasTab_Variables.FilterDest,0x0F00) > 0
		
		local sourceList,destList = {},{}
		
		local buffTable = {}
		for i,sourceData in ipairs(CurrentFight.auras) do 
			local spellID = sourceData[6]
			local spellName,_,spellTexture = GetSpellInfo(spellID)
			local filterStatus = true
			for j=5,#AurasTab_Variables.buffsFilters do
				filterStatus = filterStatus and (not buffsFilterStatus[j] or AurasTab_Variables.buffsFilters[j][spellID])
			end
			if ((not _F_sourceGUID and ((_F_sourcePets or not buffsFunc_isPetOrGuard(currFight.reaction[ sourceData[2] ])) and ((_F_sourceFriendly and sourceData[4]) or (_F_sourceHostile and not sourceData[4])))) or (sourceData[2] and AurasTab_Variables.FilterSourceGUID[ sourceData[2] ])) and
				((not _F_destGUID and ((_F_destPets or not buffsFunc_isPetOrGuard(currFight.reaction[ sourceData[3] ])) and ((_F_destFriendly and sourceData[5]) or (_F_destHostile and not sourceData[5])))) or (sourceData[3] and AurasTab_Variables.FilterDestGUID[ sourceData[3] ])) and
				(not buffsFilterStatus[1] or sourceData[7] == 'BUFF') and
				(not buffsFilterStatus[2] or sourceData[7] == 'DEBUFF') and
				(not buffsFilterStatus[4] or (AurasTab_Variables.buffsFilters[3][spellID] or buffsFunc_findStringInArray(AurasTab_Variables.buffsFilters[4],strlower(spellName)))) and
				filterStatus then
				
				local time_ = timestampToFightTime( sourceData[1] )
				local time_postion = time_ / fightDuration
				local type_ = sourceData[8]
				
				local buffTablePos
				for j=1,#buffTable do
					if buffTable[j][1] == spellID then
						buffTablePos = j
						break
					end
				end
				if not buffTablePos then
					buffTablePos = #buffTable + 1
					buffTable[buffTablePos] = {spellID,spellName,spellTexture,{},{}}
				end
				
				local sourceGUID = sourceData[2] or 0
				local destGUID = sourceData[3] or 0
				local sourceDest = sourceGUID .. destGUID
				local buffTableBuffPos
				for j=1,#buffTable[buffTablePos][4] do
					if buffTable[buffTablePos][4][j][1] == sourceDest then
						buffTableBuffPos = j
						break
					end
				end
				if not buffTableBuffPos then
					buffTableBuffPos = #buffTable[buffTablePos][4] + 1
					buffTable[buffTablePos][4][buffTableBuffPos] = {sourceDest,sourceGUID,destGUID,{}}
				end
				
				local eventPos = #buffTable[buffTablePos][4][buffTableBuffPos][4] + 1
				
				if type_ == 3 or type_ == 4 then
					buffTable[buffTablePos][4][buffTableBuffPos][4][eventPos] = {0,time_,time_postion,sourceData[9] or 1}
					type_ = 1
					eventPos = eventPos + 1
				end
				buffTable[buffTablePos][4][buffTableBuffPos][4][eventPos] = {type_ % 2,time_,time_postion,sourceData[9] or 1}
				
				sourceList[sourceGUID] = true
				destList[destGUID] = true
			end
			if ((_F_sourceFriendly and sourceData[4]) or (_F_sourceHostile and not sourceData[4])) and
				((_F_destFriendly and sourceData[5]) or (_F_destHostile and not sourceData[5])) and
				(not buffsFilterStatus[1] or sourceData[7] == 'BUFF') and
				(not buffsFilterStatus[2] or sourceData[7] == 'DEBUFF') and
				(not buffsFilterStatus[4] or (AurasTab_Variables.buffsFilters[3][spellID] or buffsFunc_findStringInArray(AurasTab_Variables.buffsFilters[4],strlower(spellName)))) and
				filterStatus then

				local sourceGUID = sourceData[2] or 0
				local destGUID = sourceData[3] or 0
				sourceList[sourceGUID] = true
				destList[destGUID] = true
			end			
		end
		
		sort(buffTable,function(a,b) return a[2] < b[2] end)
		
		for i=1,#buffTable do 
			local buffTableI = buffTable[i]
			
			for j=1,#buffTableI[4] do
				local buffTableJ = buffTableI[4][j]
				
				local maxEvents = #buffTableJ[4]
				if maxEvents > 0 and buffTableJ[4][1][1] == 0 then
					local newLine = #buffTableI[5] + 1
					buffTableI[5][newLine] = {
						AurasTab_Variables.NameWidth,
						AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth*buffTableJ[4][1][3],
						0,
						buffTableJ[4][1][2],
						buffTableJ[2],
						buffTableJ[3],
						1,
					}
				end
				for k=1,maxEvents do
					if buffTableJ[4][k][1] == 1 then
						local endOfTime = nil
						for n=(k+1),maxEvents do
							if buffTableJ[4][n][1] == 0 and not endOfTime then
								endOfTime = n
								--break
							end
						end
						local newLine = #buffTableI[5] + 1
						buffTableI[5][newLine] = {
							AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth*buffTableJ[4][k][3],
							AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth*(endOfTime and buffTableJ[4][endOfTime][3] or 1),
							buffTableJ[4][k][2],
							endOfTime and buffTableJ[4][endOfTime][2] or fightDuration,
							buffTableJ[2],
							buffTableJ[3],
							buffTableJ[4][k][4],
						}
						--startPos,endPos,startTime,endTime,sourceGUID,destGUID,stacks
					end
				end
			end
		end
		
		--> Death Line
		for i=1,#aurasTab.redDeathLine do
			aurasTab.redDeathLine[i]:Hide()
		end
		if _F_destGUID and ExRT.F.table_len(AurasTab_Variables.FilterDestGUID) > 0 then
			local j = 0
			for i=1,#CurrentFight.dies do
				if AurasTab_Variables.FilterDestGUID[ CurrentFight.dies[i][1] ] then
					j = j + 1
					CreateRedDeathLine(j)
					local time_ = timestampToFightTime( CurrentFight.dies[i][3] )
					local pos = AurasTab_Variables.NameWidth + time_/fightDuration*AurasTab_Variables.WorkWidth - 1
					aurasTab.redDeathLine[j]:SetPoint("TOPLEFT",pos,-42-25)
					aurasTab.redDeathLine[j]:Show()
				end
			end
		end
		
		aurasTab.scrollBar:Range(1,max(#buffTable-AurasTab_Variables.TotalLines+1,1))		
		aurasTab.db = buffTable
		
		if notUpdateTargetsList then
			return
		end
		local sourceTable,destTable = {},{}
		for sourceGUID,_ in pairs(sourceList) do
			sourceTable[#sourceTable+1] = {sourceGUID,GetGUID(sourceGUID),sourceGUID:find("^Player")}
		end
		for destGUID,_ in pairs(destList) do
			destTable[#destTable+1] = {destGUID,GetGUID(destGUID),destGUID:find("^Player")}
		end
		sort(sourceTable,function(a,b) if a[3]==b[3] then return a[2]<b[2] else return a[3] end end)
		sort(destTable,function(a,b) if a[3]==b[3] then return a[2]<b[2] else return a[3] end end)

		wipe(aurasTab.sourceDropDown.List)
		wipe(aurasTab.targetDropDown.List)
		aurasTab.sourceDropDown.List[1] = {text = L.BossWatcherAll,func = AurasTab_SelectDropDownSource,padding = 16}
		aurasTab.targetDropDown.List[1] = {text = L.BossWatcherAll,func = AurasTab_SelectDropDownDest,padding = 16}
		for i=1,#sourceTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
			end
			aurasTab.sourceDropDown.List[i+1] = {
				text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
				arg1 = sourceTable[i][1],
				func = AurasTab_SelectDropDownSource,
				checkFunc = AurasTab_CheckDropDownSource,
				checkable = true,
			}
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			aurasTab.targetDropDown.List[i+1] = {
				text = classColor..destTable[i][2]..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				func = AurasTab_SelectDropDownDest,
				checkFunc = AurasTab_CheckDropDownDest,
				checkable = true,
			}
		end
		
		--ExRT.F.ScheduleTimer(collectgarbage, 1, "collect")
	end
	
	function UpdateBuffsPage()
		local currTab = aurasTab
		if not currTab.db then
			return
		end
		
		local minVal = ExRT.F.Round(currTab.scrollBar:GetValue())
		local buffTable2 = currTab.db
		
		local linesCount = 0
		for i=1,AurasTab_Variables.TotalLines do
			for j=1,currTab.lines[i].greenCount do
				currTab.lines[i].green[j]:Hide()
			end
			currTab.lines[i].greenCount = 0
			table.wipe(currTab.lines[i].greenTooltips)
		end
		for i=minVal,#buffTable2 do
			local data = buffTable2[i]
			linesCount = linesCount + 1
			local Line = currTab.lines[linesCount]
			Line.spellIcon:SetTexture(data[3])
			Line.spellText:SetText(data[2] or "???")
			Line.spellLink = GetSpellLink(data[1])
			Line.spellName = data[2] or "Spell"
			Line.spellID = data[1]
			Line.lineData = data
			
			for j=1,#data[5] do
				Line.greenCount = Line.greenCount + 1
				local n = Line.greenCount

				if not Line.green[n] then
					CreateBuffGreen(linesCount,n)
				end
				
				Line.green[n]:SetPoint("TOPLEFT",data[5][j][1],0)
				Line.green[n]:SetSize(max(data[5][j][2]-data[5][j][1],0.1),18)
				Line.green[n]:Show()
				
				Line.greenTooltips[#Line.greenTooltips+1] = data[5][j]
			end

			Line:Show()
			if linesCount >= AurasTab_Variables.TotalLines then
				break
			end
		end
		for i=(linesCount+1),AurasTab_Variables.TotalLines do
			local line = currTab.lines[i]
			line:Hide()
			line.lineData = nil
		end
		currTab.scrollBar:UpdateButtons()
	end

	tab.scrollBar:SetScript("OnValueChanged",UpdateBuffsPage)
	tab:SetScript("OnMouseWheel",function (self,delta)
		if delta > 0 then
			aurasTab.scrollBar.buttonUP:Click("LeftButton")
		else
			aurasTab.scrollBar.buttonDown:Click("LeftButton")
		end
	end)
	
	function AurasPage_IsAuraOn(destGUID,auraSpellID,fightTime)
		local isOnNow = false
		local aurasTable = CurrentFight.auras
		for j=1,#aurasTable do
			if aurasTable[j][6] == auraSpellID and aurasTable[j][3] == destGUID then
				if aurasTable[j][8] == 1 or aurasTable[j][8] == 2 then
					isOnNow = true
				else
					isOnNow = false
				end
			end
			local thisTime = timestampToFightTime( aurasTable[j][1] )
			if thisTime > fightTime then
				return isOnNow
			end
		end
		return isOnNow
	end

	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightIDShort ~= self.lastFightID then
			UpdateBuffPageDB()
			self.lastFightID = BWInterfaceFrame.nowFightIDShort
		end
		UpdateBuffsPage()
	end)
	
	
	
	
	
	---- Mobs Info & Switch
	tab = BWInterfaceFrame.tab.tabs[4]
	local mobsTab = tab
	
	local Enemy_GUIDnow,Enemy_LifeTime = nil
	
	tab.targetsList = ELib:ScrollList(tab):Point(14,-76):Size(282,513)
	tab.targetsList.GUIDs = {}
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab.targetsList,"TOPRIGHT",0,2)
	tab.DecorationLine:SetPoint("RIGHT",tab,-5,0)
	tab.DecorationLine:SetHeight(37)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	tab.selectedMob = ELib:Text(tab.DecorationLine,"",11):Size(530,12):Point(5,-5):Color():Top()
	tab.infoTabs = ELib:Tabs(tab,0,
		L.BossWatcherSwitchBySpell,
		L.BossWatcherSwitchByTarget,
		L.BossWatcherDamageSwitchTabInfo
	):Size(530,465):Point(295,-111):SetTo(1)
	tab.infoTabs:SetBackdropBorderColor(0,0,0,0)
	tab.infoTabs:SetBackdropColor(0,0,0,0)
	
	tab.switchSpellBox = ELib:MultiEdit(tab.infoTabs.tabs[1]):Size(540,415):Point(13,-10):Hyperlinks()
	tab.switchTargetBox = ELib:MultiEdit(tab.infoTabs.tabs[2]):Size(540,415):Point(13,-10)
	tab.infoBoxText = ELib:Text(tab.infoTabs.tabs[3],L.BossWatcherDamageSwitchTabInfoNoInfo,12):Size(540,415):Point(13,-13):Top():Color()
	
	tab.toDamageButton = ELib:Button(tab.infoTabs,L.BossWatcherShowDamageToTarget):Size(548,20):Point("BOTTOMLEFT",tab.targetsList,"BOTTOMRIGHT",8,-2):OnClick(function (self)
		if not Enemy_GUIDnow then
			return
		end
		DamageTab_ShowDamageToTarget(Enemy_GUIDnow)
	end)
	tab.toSegmentsButton = ELib:Button(tab.infoTabs,L.BossWatcherOnlySegmentsWithEnemy):Size(548,20):Point("BOTTOM",tab.toDamageButton,"TOP",0,5):OnClick(function (self)
		if not Enemy_LifeTime then
			return
		end
		UpdateSegmentsTime(unpack(Enemy_LifeTime))
	end)	
	
	function tab.targetsList:SetListValue(index)
		local destGUID = self.GUIDs[index]
		
		Enemy_GUIDnow = destGUID
		Enemy_LifeTime = {timestampToFightTime( CurrentFight.damage_seen[destGUID] )+CurrentFight.encounterStart,CurrentFight.encounterEnd or GetTime()}
		mobsTab.toSegmentsButton:SetEnabled(true)
		mobsTab.toDamageButton:SetEnabled(true)
		
		wipe(reportData[4][1])
		wipe(reportData[4][2])
		wipe(reportData[4][3])
		
		local _time = timestampToFightTime(CurrentFight.damage_seen[destGUID])
		local fight_dur = GetFightLength(true)
		
		mobsTab.selectedMob:SetText(GetGUID(destGUID).." "..date("%M:%S", _time )..GUIDtoText(" (%s)",destGUID))
		
		_time = _time / fight_dur
		
		local textResult = ""
		local textResult2 = ""
		if CurrentFight.switch[destGUID] then
			local switchTable = {}

			if CurrentFight.switch[destGUID][1] then
				for sourceGUID,sourceData in pairs(CurrentFight.switch[destGUID][1]) do
					if ExRT.F.GetUnitTypeByGUID(sourceGUID) == 0 and not ExRT.F.table_find(switchTable,sourceGUID,3) then
						table.insert(switchTable,{GetGUID(sourceGUID),timestampToFightTime(sourceData[1]),sourceGUID,sourceData[2],sourceData[3]})
					end
				end
			end
			table.sort(switchTable,function(a,b) return a[2] < b[2] end)
			if #switchTable > 0 then
				textResult = L.BossWatcherReportCast.." [" .. date("%M:%S", switchTable[1][2] ) .."]:|n"
				reportData[4][1][1] = GetGUID(destGUID).." > ".. L.BossWatcherReportCast.." [" .. date("%M:%S", switchTable[1][2] ) .."]:"
				for i=1,#switchTable do
					local spellName = GetSpellInfo(switchTable[i][4] or 0)
					textResult = textResult ..i..". ".."|c".. ExRT.F.classColorByGUID(switchTable[i][3]).. switchTable[i][1] .. GUIDtoText(" <%s>",switchTable[i][3]) .. "|r (".. format("%.3f",switchTable[i][2]-switchTable[1][2])..", |Hspell:"..(switchTable[i][4] or 0).."|h"..(spellName or "?").."|h, "..((switchTable[i][5] == 1 and DAMAGE:lower()) or (switchTable[i][5] == 2 and ACTION_SPELL_CAST_SUCCESS:lower()) or (switchTable[i][5] == 3 and ACTION_SPELL_CAST_START:lower()) or "unk")..")"
					reportData[4][1][#reportData[4][1]+1] = i..". "..switchTable[i][1] .. "(" .. format("%.3f",switchTable[i][2]-switchTable[1][2])..", "..GetSpellLink(switchTable[i][4] or 0)..")"
					if i ~= #switchTable then
						textResult = textResult .. "|n"
					end
				end
				textResult = textResult .. "\n\n"
			end
			
			wipe(switchTable)
			if CurrentFight.switch[destGUID][2] then
				for sourceGUID,sourceData in pairs(CurrentFight.switch[destGUID][2]) do
					if ExRT.F.GetUnitTypeByGUID(sourceGUID) == 0 and not ExRT.F.table_find(switchTable,sourceGUID,3) then
						table.insert(switchTable,{GetGUID(sourceGUID),sourceData[1] - CurrentFight.encounterStart,sourceGUID,sourceData[2]})
					end
				end
			end
			table.sort(switchTable,function(a,b) return a[2] < b[2] end)
			if #switchTable > 0 then
				textResult2 = textResult2 .. L.BossWatcherReportSwitch.." [" .. date("%M:%S", switchTable[1][2] ) .."]:|n"
				reportData[4][2][1] = GetGUID(destGUID).." > ".. L.BossWatcherReportSwitch.." [" .. date("%M:%S", switchTable[1][2] ) .."]:"
				for i=1,#switchTable do
					textResult2 = textResult2 ..i..". ".. "|c".. ExRT.F.classColorByGUID(switchTable[i][3]).. switchTable[i][1] .. GUIDtoText(" <%s>",switchTable[i][3]) .. "|r (".. format("%.3f",switchTable[i][2]-switchTable[1][2])..")"
					reportData[4][2][#reportData[4][2]+1] = i..". ".. switchTable[i][1].."(" .. format("%.3f",switchTable[i][2]-switchTable[1][2])..")"
					if i ~= #switchTable then
						textResult2 = textResult2 .. "|n"
					end
				end
			end
		end		
		mobsTab.switchSpellBox:SetText(textResult):ToTop()
		mobsTab.switchTargetBox:SetText(textResult2):ToTop()
		
		--> Other Info
		textResult = ""
		reportData[4][3][1] = GetGUID(destGUID)..":"
		for i=1,#CurrentFight.dies do
			if CurrentFight.dies[i][1]==destGUID then
				textResult = textResult .. L.BossWatcherDamageSwitchTabInfoRIP..": ".. date("%M:%S", timestampToFightTime(CurrentFight.dies[i][3]) ) .. date(" (%H:%M:%S)", CurrentFight.dies[i][3] ) .. "\n"
				reportData[4][3][#reportData[4][3]+1] = L.BossWatcherDamageSwitchTabInfoRIP..": ".. date("%M:%S", timestampToFightTime(CurrentFight.dies[i][3]) ) .. date(" (%H:%M:%S)", CurrentFight.dies[i][3] )
				
				local raidTarget = module.db.raidTargets[ CurrentFight.dies[i][4] or 0 ]
				if raidTarget then
					textResult = textResult .. L.BossWatcherMarkOnDeath..": |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. raidTarget  ..":0|t ".. string.gsub( L["raidtargeticon"..raidTarget] , "[{}]", "" ) .."\n"
					reportData[4][3][#reportData[4][3]+1] = L.BossWatcherMarkOnDeath..": "..string.gsub( L["raidtargeticon"..raidTarget] , "[{}]", "" )
				end
				
				Enemy_LifeTime[2] = timestampToFightTime(CurrentFight.dies[i][3])+CurrentFight.encounterStart
			end
		end
		local mobID = ExRT.F.GUIDtoID(destGUID)
		local mobSpawnID1,mobSpawnID2,mobSpawnID3,mobSpawnID4 = 0,0,0,0
		do
			local spawnString = destGUID:match("%-([^%-]+)$") or "0"
			if spawnString then
				mobSpawnID1 = tonumber(spawnString:sub(1,5), 16) or 0
				mobSpawnID2 = tonumber(spawnString:sub(6), 16) or 0
				mobSpawnID3 = tonumber(spawnString, 16) or 0
				
				local copyStr = spawnString
				while copyStr:find("^0") do
					copyStr = copyStr:gsub("^0","")
				end
				mobSpawnID4 = tonumber(string.reverse(copyStr), 16) or 0
			end
		end
		textResult = textResult .. "Mob ID: ".. mobID .. "\n"
		textResult = textResult .. "Spawn ID: ".. mobSpawnID1 .. "-" .. mobSpawnID2 .." ("..mobSpawnID3..", "..mobSpawnID4..")".. "\n"
		textResult = textResult .. "GUID: ".. destGUID .. "\n"
		reportData[4][3][#reportData[4][3]+1] = "Mob ID: ".. mobID
		reportData[4][3][#reportData[4][3]+1] = "Spawn ID: ".. mobSpawnID1 .. "-" .. mobSpawnID2
		reportData[4][3][#reportData[4][3]+1] = "GUID: ".. destGUID
		
		if CurrentFight.maxHP[destGUID] then
			textResult = textResult .. "Max Health: ".. CurrentFight.maxHP[destGUID] .. "\n"
			reportData[4][3][#reportData[4][3]+1] = "Max Health:: ".. CurrentFight.maxHP[destGUID]
		end
		
		mobsTab.infoBoxText:SetText(textResult)
	end
	
	function tab.targetsList:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
			BWInterfaceFrame.timeLineFrame.timeLine.lifeUnderLine:Hide()
			GameTooltip_Hide()
		else
			local mobGUID = self.GUIDs[index]
			local mobSeen = timestampToFightTime( CurrentFight.damage_seen[mobGUID] )
			local fight_dur = GetFightLength(true)
			local _time = mobSeen / fight_dur
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*_time,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
			
			local dieTime = 1
			for i=1,#CurrentFight.dies do
				if CurrentFight.dies[i][1]==mobGUID then
					dieTime = timestampToFightTime(CurrentFight.dies[i][3]) / fight_dur
					break
				end
			end
			BWInterfaceFrame.timeLineFrame.timeLine.lifeUnderLine:SetPoint(_time,dieTime)
			
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			GameTooltip:AddLine(GUIDtoText("%s",mobGUID))

			if hoveredObj.text:IsTruncated() then
				GameTooltip:AddLine(GetGUID(mobGUID) .. date(" %M:%S", mobSeen) )
			end
			GameTooltip:Show()
		end
	end
	
	local function UpdateMobsPage()
		table.wipe(mobsTab.targetsList.L)
		table.wipe(mobsTab.targetsList.GUIDs)
		
		wipe(reportData[4][1])
		wipe(reportData[4][2])
		wipe(reportData[4][3])
		
		local mobsList = {}
		for mobGUID,mobData in pairs(CurrentFight.damage) do
			for destReaction,destReactData in pairs(mobData) do
				if (ExRT.F.GetUnitInfoByUnitFlag(destReaction,2) == 512) and not ExRT.F.table_find(mobsList,mobGUID,3) then
					mobsList[#mobsList+1] = {GetGUID(mobGUID),CurrentFight.damage_seen[mobGUID],mobGUID}
					for i=1,#CurrentFight.dies do
						if CurrentFight.dies[i][1]==mobGUID then
							local raidTarget = module.db.raidTargets[ CurrentFight.dies[i][4] or 0 ]
							if raidTarget then
								mobsList[#mobsList][1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. raidTarget ..":0|t "..mobsList[#mobsList][1]
							end
							break
						end
					end
				end
			end
		end
		for mobGUID,mobData in pairs(CurrentFight.switch) do
			if (not CurrentFight.reaction[mobGUID] or ExRT.F.GetUnitInfoByUnitFlag(CurrentFight.reaction[mobGUID],2) == 512) and not ExRT.F.table_find(mobsList,mobGUID,3) then
				mobsList[#mobsList+1] = {GetGUID(mobGUID),mobData.seen or 0,mobGUID}
				for i=1,#CurrentFight.dies do
					if CurrentFight.dies[i][1]==mobGUID then
						local raidTarget = module.db.raidTargets[ CurrentFight.dies[i][4] or 0 ]
						if raidTarget then
							mobsList[#mobsList][1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. raidTarget ..":0|t "..mobsList[#mobsList][1]
						end
						break
					end
				end
			end
		end
		table.sort(mobsList,function(a,b) return a[2] < b[2] end)
		for i=1,#mobsList do
			mobsTab.targetsList.L[i] =  date("%M:%S ", timestampToFightTime(mobsList[i][2]))..mobsList[i][1]
			mobsTab.targetsList.GUIDs[i] = mobsList[i][3]
		end
		mobsTab.targetsList:Update()
		
		Enemy_GUIDnow = nil
		mobsTab.toDamageButton:SetEnabled(false)
		mobsTab.toSegmentsButton:SetEnabled(false)
	end

	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.report:Show()
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			self.targetsList.selected = nil
			UpdateMobsPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
	end)
	
	
	
	
	---- Spells
	tab = BWInterfaceFrame.tab.tabs[5]
	local tab5 = tab
	
	local SpellsTab_Variables = {
		Type = 1,	--1 - friendly 2 - hostile 3 - spells count, 4 - summons
		Filter = {},
		FilterByTarget = {},
	}

	tab.playersList = ELib:ScrollList(tab):Size(190,449):Point(14,-140)
	tab.playersCastsList = ELib:ScrollList(tab):Size(637,494 - 25):Point(214,-95)
	tab.playersList.IndexToGUID = {}
	tab.playersCastsList.IndexToGUID = {}
	
	tab.summaryTooltip = ELib:Button(tab,STATISTICS):Point("TOP",tab.playersCastsList,"BOTTOM",0,-5):Size(637,20)
	tab.summaryTooltip:SetScript("OnEnter",function(self)
		if not self.tooltip then
			return
		end
		GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		GameTooltip:SetText(self.tooltip[1])
		for i=2,#self.tooltip do
			if type(self.tooltip[i]) == "table" then
				GameTooltip:AddDoubleLine(self.tooltip[i][1],self.tooltip[i][2],1,1,1,1,1,1,1,1)
			else
				GameTooltip:AddLine(self.tooltip[i])
			end
		end
		GameTooltip:Show()
	end)
	tab.summaryTooltip:SetScript("OnLeave",ELib.Tooltip.Hide)

	
	local function SpellsTab_ReloadSpells()
		local selected = tab5.playersList.selected
		if selected then
			tab5.playersList:SetListValue(selected)
		end
	end
	
	local SpellsTab_UpdateFilterHeader = nil
	local function SpellsTab_UpdateFilter(text)
		SpellsTab_UpdateFilterHeader = nil
		wipe(SpellsTab_Variables.Filter)
		wipe(SpellsTab_Variables.FilterByTarget)
		if text:find("^target!?[=~]") or text:find("^!?[=~]") then
			text = text:gsub("^target","")
			local filterType = 1
			if text:find("^!=") then
				filterType = 3
			elseif text:find("^!~") then
				filterType = 4
			elseif text:find("^~") then
				filterType = 2
			end
			local targetsStr = text:match("^!?[=~](.+)")
			if targetsStr then
				local targets = {strsplit(";",targetsStr)}
				for i=1,#targets do
					if tonumber(targets[i]) then
						SpellsTab_Variables.FilterByTarget[ tonumber(targets[i]) ] = filterType
					else
						SpellsTab_Variables.FilterByTarget[ targets[i] ] = filterType
					end
				end
			end
			SpellsTab_ReloadSpells()		
			return
		end
		local spells = {strsplit(";",text)}
		for i=1,#spells do
			if tonumber(spells[i]) then
				spells[i] = tonumber(spells[i])
			end
			SpellsTab_Variables.Filter[spells[i]] = true
		end
		SpellsTab_ReloadSpells()
	end
	tab.filterEditBox = ELib:Edit(tab):Size(639,16):Point(213,-73):Tooltip(L.BossWatcherSpellsFilterTooltip..'|n'..L.BossWatcherBySpell..': "|cffffffff774;Multi-shot;105809|r" '..OR_CAPS:lower()..' "|cffffffffFlash Heal|r"|n'..L.BossWatcherByTarget..': "|cfffffffftarget=Ragnaros;The Lich King;Lei Shen|r" '..OR_CAPS:lower()..' "|cffffffff=Garrosh|r" '..OR_CAPS:lower()..' "|cffffffff~illi|r"'):OnChange(function (self)
		local text = self:GetText()
		if text == "" then
			ExRT.F.CancelTimer(SpellsTab_UpdateFilterHeader)
			wipe(SpellsTab_Variables.Filter)
			wipe(SpellsTab_Variables.FilterByTarget)
			SpellsTab_ReloadSpells()
			return
		end
		SpellsTab_UpdateFilterHeader = ExRT.F.ScheduleETimer(SpellsTab_UpdateFilterHeader,SpellsTab_UpdateFilter,0.8,text)
	end)
	
	function tab.playersList:HoverListValue(isHover,index)
		if not isHover then
			GameTooltip_Hide()
		else
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			GameTooltip:AddLine(GUIDtoText("%s",self.IndexToGUID[index]))
			GameTooltip:Show()
		end
	end
	function tab.playersCastsList:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			GameTooltip_Hide()
			ELib.Tooltip:HideAdd()
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
			BWInterfaceFrame.timeLineFrame.timeLine:HideLabels()
		else
			local data = self.IndexToGUID[index]
			GameTooltip:SetOwner(hoveredObj or self,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetHyperlink(data[1])
			GameTooltip:Show()
			
			if hoveredObj.text:IsTruncated() then
				ELib.Tooltip:Add(nil,{hoveredObj.text:GetText()},false,true)
			end
			
			if data[2] then
				if not data[5] then
					BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*data[2],0)
					BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
				else
					local count = 0
					for i=1,#data[5] do
						local pos = data[5][i]
						if pos < 0 and data[6] then
							pos = -pos
							count = count + 1
							BWInterfaceFrame.timeLineFrame.timeLine:AddLabel(count,pos,data[2] == pos and 1 or 2)
						elseif pos >= 0 then
							count = count + 1
							BWInterfaceFrame.timeLineFrame.timeLine:AddLabel(count,pos,data[2] == pos and 1 or nil)
						end
					end
				end
			end
			
			if self.redTime and data[4] then
				local diff = data[4] - self.redTime
				local isNegative = diff < 0 and -diff
				ELib.Tooltip:Add(nil,{format("%s%d:%06.3f (%.3f %s)",isNegative and "-" or "",(isNegative or diff) / 60,(isNegative or diff) % 60,diff,SECONDS)},false,true)
			end
		end
	end
	
	local function SpellsTab_FindInWord(haystack,needle)
		if not haystack or not needle then
			return
		end
		needle = needle:lower()
		haystack = haystack:lower()
		if haystack:find(needle) then
			return true
		end
		return false
	end
	
	function tab.playersList:SetListValue(index)
		local playersCastsList = tab5.playersCastsList
		
		table.wipe(playersCastsList.L)
		table.wipe(playersCastsList.IndexToGUID)
		
		local selfGUID = self.IndexToGUID[index]
		local fight_dur = GetFightLength(true)
		
		local SpellsTab_isFriendly = SpellsTab_Variables.Type == 1
		
		tab5.summaryTooltip.tooltip = nil
		tab5.summaryTooltip:Disable()
		
		if SpellsTab_Variables.Type == 4 then
			for i,data in ipairs(CurrentFight.summons) do
				if (not selfGUID or selfGUID == data[1]) and CurrentFight.segments[ data.s ].e then
					local spellName,_,spellTexture = GetSpellInfo(data[3])
					local time_ = timestampToFightTime(data[4])
					local sourceName= "|c"..ExRT.F.classColorByGUID(data[1])..GetGUID( data[1] )..GUIDtoText(" <%s>",data[1]).."|r "
					local destName= "|c"..ExRT.F.classColorByGUID(data[2])..GetGUID( data[2] )..GUIDtoText(" <%s>",data[2]).."|r "
					
					local sourceMarker = module.db.raidTargets[ data[5] or 0 ]
					local destMarker = module.db.raidTargets[ data[6] or 0 ]
					
					playersCastsList.L[#playersCastsList.L + 1] = format("[%02d:%06.3f] ",time_ / 60,time_ % 60)..(sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "")..sourceName.." "..ACTION_SPELL_SUMMON.." "..(destMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. destMarker  ..":0|t" or "")..destName..L.BossWatcherByText..format(" %s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???")
					playersCastsList.IndexToGUID[#playersCastsList.IndexToGUID + 1] = {"spell:"..data[3],time_ / fight_dur,data[3],time_}
				end
			end
		elseif SpellsTab_Variables.Type ~= 3 then
			local spells = {}
			if selfGUID then
				for i,PlayerCastData in ipairs(CurrentFight.cast[selfGUID]) do
					if CurrentFight.segments[ PlayerCastData.s ].e then
						spells[#spells + 1] = {PlayerCastData[1],PlayerCastData[2],PlayerCastData[3],PlayerCastData[4],PlayerCastData[5],PlayerCastData[6]}
					end
				end
			else
				local reaction = SpellsTab_isFriendly and 256 or 512
				for GUID,dataGUID in pairs(CurrentFight.cast) do
					for i,PlayerCastData in ipairs(dataGUID) do
						if ExRT.F.GetUnitInfoByUnitFlag(PlayerCastData[7],2) == reaction and CurrentFight.segments[ PlayerCastData.s ].e then
							spells[#spells + 1] = {PlayerCastData[1],PlayerCastData[2],PlayerCastData[3],PlayerCastData[4],PlayerCastData[5],PlayerCastData[6],GUID}
						end
					end
				end
				sort(spells,function(a,b) return a[1]<b[1] end)
			end
			local spellToTime = {}
			
			local stats = {
				targets = {},
				sources = {},
			}
	
			local isSpellsFilterEnabled = ExRT.F.table_len(SpellsTab_Variables.Filter) > 0
			local isTargetsFilterEnabled = ExRT.F.table_len(SpellsTab_Variables.FilterByTarget) > 0
			for i,data in ipairs(spells) do
				local spellID = data[2]
				local spellName,_,spellTexture = GetSpellInfo(spellID)
				local time_ = timestampToFightTime(data[1])
				local isCast = ""
				if data[3] == 2 then
					isCast = L.BossWatcherBeginCasting.." "
				end
				local sourceName = ""
				if data[7] then
					sourceName = "|c"..ExRT.F.classColorByGUID(data[7])..GetGUID( data[7] )..GUIDtoText(" <%s>",data[7]).."|r "
				end
				
				local isMustBeAdded = true
				if isSpellsFilterEnabled then
					isMustBeAdded = false
					for filterSource,_ in pairs(SpellsTab_Variables.Filter) do
						if (type(filterSource) == "number" and filterSource == spellID) or
						   (type(filterSource) ~= "number" and spellName and string.find(strlower(spellName),strlower(filterSource))) then
							isMustBeAdded = true
							break
						end
					end
				elseif isTargetsFilterEnabled then
					isMustBeAdded = false
					for filterSource,filterType in pairs(SpellsTab_Variables.FilterByTarget) do
						if (filterType == 2 and SpellsTab_FindInWord( GetGUID( data[4] ),filterSource )) or 
							(filterType == 3 and not (GetGUID( data[4] ) == filterSource)) or 
							(filterType == 4 and not SpellsTab_FindInWord( GetGUID( data[4] ),filterSource )) or 
							(filterType == 1 and (GetGUID( data[4] ) == filterSource)) or
							(filterType == 1 and type(filterSource)=='number' and module.db.raidTargets[ data[5] or 0 ] == filterSource) then
							isMustBeAdded = true
							break
						end
					end
				end
				if isMustBeAdded then
					spellToTime[spellID] = spellToTime[spellID] or {}
					spellToTime[spellID][#spellToTime[spellID] + 1] = time_ / fight_dur * (data[3] == 2 and -1 or 1)

					local sourceMarker = module.db.raidTargets[ data[6] or 0 ]
					playersCastsList.L[#playersCastsList.L + 1] = format("[%02d:%06.3f] ",time_ / 60,time_ % 60)..(sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "")..sourceName..isCast..format("%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???")
					playersCastsList.IndexToGUID[#playersCastsList.IndexToGUID + 1] = {"spell:"..spellID,time_ / fight_dur,spellID,time_,spellToTime[spellID],data[3] == 2}
					
					if data[4] and data[4] ~= "" then
						local destMarker = module.db.raidTargets[ data[5] or 0 ]
						playersCastsList.L[#playersCastsList.L] = playersCastsList.L[#playersCastsList.L] .. " > |c"..ExRT.F.classColorByGUID(data[4])..(destMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. destMarker  ..":0|t" or "")..GetGUID( data[4] )..GUIDtoText(" <%s>",data[4]).."|r"
					
						if data[3] == 1 then
							stats.targets[ data[4] ] = (stats.targets[ data[4] ] or 0) + 1
						end
					elseif data[3] == 1 then
						stats.targets[ "-" ] = (stats.targets[ "-" ] or 0) + 1
					end
					if data[3] == 1 then
						stats.sources[spellID] = (stats.sources[spellID] or 0) + 1
					end
				end
			end
			
			local ss,ts = {},{}
			local cs,ct = 0,0
			for q,w in pairs(stats.sources) do ss[ #ss+1 ] = {q,w} cs=cs+w end
			for q,w in pairs(stats.targets) do if q~="-" then ts[ #ts+1 ] = {q,w} end ct=ct+w end
			sort(ss,DamageTab_Temp_SortingBy2Param)
			sort(ts,DamageTab_Temp_SortingBy2Param)
			local s = {TARGET..":"}
			for i=1,min(#ts,10) do
				s[#s+1]= { (ts[i][1] ~= "-" and GetGUID( ts[i][1] )..GUIDtoText(" <%s>",ts[i][1]) or NONE) , format("%d (%.2f%%)",ts[i][2],ts[i][2] / max(1,ct) * 100) }
			end
			if #ts > 10 then
				local o = 0
				for i=11,#ts do
					o = o + ts[i][2]
				end
				s[#s+1]= { OTHER , format("%d (%.2f%%)",o,o / max(1,ct) * 100) }
			end
			s[#s+1]= " "
			s[#s+1]= SOURCES .. ":"
			for i=1,min(#ss,10) do
				local spellName,_,spellTexture = GetSpellInfo(ss[i][1])
				s[#s+1]= { "|T" .. (spellTexture or "") .. ":0|t " ..(spellName or ss[i][1]) , format("%d (%.2f%%)",ss[i][2],ss[i][2] / max(1,cs) * 100) }
			end
			if #ss > 10 then
				local o = 0
				for i=11,#ss do
					o = o + ss[i][2]
				end
				s[#s+1]= { OTHER , format("%d (%.2f%%)",o,o / max(1,ct) * 100) }
			end		
			tab5.summaryTooltip.tooltip = s
			tab5.summaryTooltip:Enable()
		else
			local spells,spellToTime = {},{}
			for GUID,dataGUID in pairs(CurrentFight.cast) do
				if not selfGUID or selfGUID == GUID then
					for i,PlayerCastData in ipairs(CurrentFight.cast[GUID]) do
						if PlayerCastData[3] ~= 2 and CurrentFight.segments[ PlayerCastData.s ].e then
							local spellID = PlayerCastData[2]
							local inTable = ExRT.F.table_find(spells,spellID,1)
							if not inTable then
								inTable = #spells + 1
								spells[inTable] = {spellID,0}
							end
							spells[inTable][2] = spells[inTable][2] + 1

							spellToTime[spellID] = spellToTime[spellID] or {}
							spellToTime[spellID][#spellToTime[spellID] + 1] = timestampToFightTime(PlayerCastData[1]) / fight_dur * (PlayerCastData[3] == 2 and -1 or 1)
						end
					end
				end
			end
			sort(spells,function(a,b)return a[2]>b[2] end)
			for i,data in ipairs(spells) do
				local spellName,_,spellTexture = GetSpellInfo(data[1])
				
				playersCastsList.L[#playersCastsList.L + 1] = data[2].." "..format("%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???")
				playersCastsList.IndexToGUID[#playersCastsList.IndexToGUID + 1] = {"spell:"..data[1],0,data[1],nil,spellToTime[ data[1] ]}
			end
		end
		
		playersCastsList:Update()		
	end
	function tab.playersCastsList:SetListValue(index,button)
		self.selected = nil
		if button == "RightButton" then
			if self.redTime or not self.IndexToGUID[index][4] then
				self.redTime = nil
				self.redIndex = nil
			else
				self.redTime = self.IndexToGUID[index][4]
				self.redIndex = index
			end
			self:Update()
			return
		end
		self.redTime = nil
		self.redIndex = nil
		
		local sID = self.IndexToGUID[index][3]
		if self.redSpell == sID then
			self.redSpell = nil
		else
			self.redSpell = sID
		end
		self:Update()
	end
	function tab.playersCastsList:UpdateAdditional(scrollPos)
		for j=1,#self.List do
			local index = self.List[j].index
			if self.redSpell and index and self.IndexToGUID[index] and self.IndexToGUID[index][3] == self.redSpell then
				self.List[j].text:SetTextColor(1,0.2,0.2,1)
			elseif self.redIndex and self.redIndex == index then
				self.List[j].text:SetTextColor(0.6,1,0.2,1)
			else
				self.List[j].text:SetTextColor(1,1,1,1)
			end
		end
	end	
	
	local function UpdateSpellsPage()
		table.wipe(tab5.playersList.L)
		table.wipe(tab5.playersList.IndexToGUID)
		table.wipe(tab5.playersCastsList.L)
		table.wipe(tab5.playersCastsList.IndexToGUID)
		local playersListTable = {}
		if SpellsTab_Variables.Type ~= 4 then
			local SpellsTab_isFriendly = SpellsTab_Variables.Type == 1
			for sourceGUID,sourceData in pairs(CurrentFight.cast) do
				if not ExRT.F.table_find(playersListTable,sourceGUID,1) then
					for i=1,#sourceData do
						if 
							CurrentFight.segments[ sourceData[i].s ].e and 
							(SpellsTab_Variables.Type == 3 or (SpellsTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(sourceData[i][7],1) == 1024) or (not SpellsTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(sourceData[i][7],2) == 512))
						then
							playersListTable[#playersListTable + 1] = {sourceGUID,GetGUID( sourceGUID ),"|c"..ExRT.F.classColorByGUID(sourceGUID),sourceGUID:find("^Player%-")}
							break
						end
					end
				end
			end
		else
			for _,data in pairs(CurrentFight.summons) do
				local sourceGUID = data[1]
				if CurrentFight.segments[ data.s ].e and not ExRT.F.table_find(playersListTable,sourceGUID,1) then
					playersListTable[#playersListTable + 1] = {sourceGUID,GetGUID( sourceGUID ),"|c"..ExRT.F.classColorByGUID(sourceGUID)}
				end 
			end
		end
		if SpellsTab_Variables.Type == 3 then
			table.sort(playersListTable,function (a,b) if a[4] == b[4] then return a[2] < b[2] else return a[4] end end)
		else
			table.sort(playersListTable,function (a,b) return a[2] < b[2] end)
		end
		tab5.playersList.L[1] = L.BossWatcherAll
		for i,playersListTableData in ipairs(playersListTable) do
			tab5.playersList.L[i+1] = playersListTableData[3]..playersListTableData[2]
			tab5.playersList.IndexToGUID[i+1] = playersListTableData[1]
		end
		
		tab5.playersList.selected = 1
		
		tab5.playersCastsList.redTime = nil
		tab5.playersCastsList.redIndex = nil
		
		tab5.playersList:Update()
		tab5.playersList:SetListValue(1)
		--tab5.playersCastsList:Update()
	end
	
	tab.chkFriendly = ELib:Radio(tab,L.BossWatcherFriendly,true):Point(15,-75):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkEnemy:SetChecked(false)
		tab5.chkSpellsCount:SetChecked(false)
		tab5.chkSpellsSummons:SetChecked(false)
		SpellsTab_Variables.Type = 1
		UpdateSpellsPage()
	end)
	tab.chkEnemy = ELib:Radio(tab,L.BossWatcherHostile):Point(15,-90):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkFriendly:SetChecked(false)
		tab5.chkSpellsCount:SetChecked(false)
		tab5.chkSpellsSummons:SetChecked(false)
		SpellsTab_Variables.Type = 2
		UpdateSpellsPage()
	end)
	tab.chkSpellsCount = ELib:Radio(tab,L.BossWatcherSpellsCount):Point(15,-105):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkFriendly:SetChecked(false)
		tab5.chkEnemy:SetChecked(false)
		tab5.chkSpellsSummons:SetChecked(false)
		SpellsTab_Variables.Type = 3
		UpdateSpellsPage()
	end)
	tab.chkSpellsSummons = ELib:Radio(tab,SUMMONS):Point(15,-120):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkFriendly:SetChecked(false)
		tab5.chkEnemy:SetChecked(false)
		tab5.chkSpellsCount:SetChecked(false)
		SpellsTab_Variables.Type = 4
		UpdateSpellsPage()
	end)
	
	
	function SpellsPage_GetCastsNumber(guidsSourceTable,guidsDestTable,spellID)
		local allData = not spellID and {}
		local count = 0
		local spellName = GetSpellInfo(spellID)
		for GUID,dataGUID in pairs(CurrentFight.cast) do
			if not guidsSourceTable or guidsSourceTable[GUID] then
				for i,PlayerCastData in ipairs(dataGUID) do
					if allData and PlayerCastData[3] ~= 2 and CurrentFight.segments[ PlayerCastData.s ].e and (not guidsDestTable or not PlayerCastData[4] or guidsDestTable[ PlayerCastData[4] ]) then
						allData[ PlayerCastData[2] ] = (allData[ PlayerCastData[2] ] or 0) + 1
					elseif not allData and PlayerCastData[3] ~= 2 and (PlayerCastData[2] == spellID or (spellName and spellName == GetSpellInfo(PlayerCastData[2]))) and CurrentFight.segments[ PlayerCastData.s ].e then
						count = count + 1
					end
				end
			end
		end
		if allData then
			local byName = {}
			for spellID,count in pairs(allData) do
				byName[ GetSpellInfo(spellID) or "?" ] = count
			end
			for name,count in pairs(byName) do
				allData[name] = count
			end
		end
		return allData or count
	end

	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateSpellsPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
	end)
	
	
	
	
	---- Power; HP, Powers Graphs
	tab = BWInterfaceFrame.tab.tabs[6]
	local graphsTab = tab
	
	local PowerTab_isFriendly = true
	local GraphsTab_Variables = {
		DestTable = {},
		LastGUID = nil,
		LastDoEnemy = nil,
		LastDoSpell = nil,
		PowerTypeNow = 0,
		PowerLastName = nil,
		HealthTypeNow = 1,
		HealthLastName = nil,
		Cache = {},
	}
	
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-9)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	tab.graphicsTab = ELib:Tabs(tab,0,
		POWER_GAINS,
		L.BossWatcherTabGraphics..": "..L.BossWatcherGraphicsHealth,
		L.BossWatcherTabGraphics..": "..L.BossWatcherGraphicsPower
	):Size(850,555):Point("TOP",0,-29):SetTo(1)
	tab.graphicsTab:SetBackdropBorderColor(0,0,0,0)
	tab.graphicsTab:SetBackdropColor(0,0,0,0)
	
	function tab.graphicsTab:buttonAdditionalFunc()
		local tab = graphsTab
		if self.selected == 1 then
			tab.graphicsTab.dropDown:Hide()
			tab.graph:Hide()
			tab.graphicsTab.powerDropDown:Hide()
			tab.graphicsTab.healthDropDown:Hide()
			tab.graphicsTab.bySpellDropDown:Hide()
			tab.graphicsTab.byTargetDropDown:Hide()
			tab.graphicsTab.stepSlider:Hide()
		else
			tab.graphicsTab.dropDown:Show()
			tab.graph:Show()
			tab.graphicsTab.stepSlider:Show()
		end
	end
	
	tab.graphicsTab.dropDown = ELib:DropDown(tab.graphicsTab,220,10):Size(220):Point(15,-10)
	tab.graph = ExRT.lib.CreateGraph(tab.graphicsTab,760,485,"TOP",0,-50,true)
	tab.graph.axisXisTime = true
	
	function tab.graphicsTab.dropDown:additionalToggle()
		local graphData = graphsTab.graph.data
		for i=1,#self.List do
			if self.List[i].checkable then
				local findPos = ExRT.F.table_find(graphData,self.List[i].arg1,'private_name')
				if findPos then
					self.List[i].checkState = not graphData[ findPos ].hide
				end
			end
		end
	end

	tab.graphicsTab.powerDropDown = ELib:DropDown(tab.graphicsTab,200,ExRT.F.table_len(module.db.energyLocale)):Size(220):Point(560,-10):SetText(L.BossWatcherSelectPower..module.db.energyLocale[0])
	tab.graphicsTab.healthDropDown = ELib:DropDown(tab.graphicsTab,200,2):Size(220):Point(560,-10):SetText(L.BossWatcherSelectPower..(HEALTH or "Health"))
	tab.graphicsTab.bySpellDropDown = ELib:DropDown(tab.graphicsTab,250,10):Size(145):Point(540,-10):SetText(L.BossWatcherTabPlayersSpells):Tooltip(L.BossWatcherGraphicsHoldShift)
	tab.graphicsTab.byTargetDropDown = ELib:DropDown(tab.graphicsTab,250,10):Size(145):Point(695,-10):SetText(L.BossWatcherGraphicsTargets)

	tab.graphicsTab.stepSlider = ELib:Slider(tab.graphicsTab,L.BossWatcherGraphicsStep):Size(250):Point(270,-15):Range(1,1):OnChange(function (self,value)
		value = ExRT.F.Round(value)
		self.tooltipText = value
		self:tooltipReload(self)
		if self.disableUpdateFix then
			return
		end
		graphsTab.graph.step = value
		graphsTab.graph:Reload()
	end)
	tab.graphicsTab.stepSlider:SetScript("OnMinMaxChanged",function (self)
		local _min,_max = self:GetMinMaxValues()
		self.Low:SetText(_min)
		self.High:SetText(_max)
	end)
	
	tab.graph:SetScript("OnLeave",function ()
		GameTooltip_Hide()
	end)
	
	tab.graphZoomDropDown = CreateFrame("Frame", BWInterfaceFrame_Name.."GraphZoomDropDown", nil, "UIDropDownMenuTemplate")
	function tab.graph:Zoom(start,ending)
		local zoomList = {
			{
				text = L.BossWatcherGraphZoom, 
				isTitle = true, 
				notCheckable = true, 
				notClickable = true 
			},
			{
				text = L.BossWatcherGraphZoomOnlyGraph,
				notCheckable = true,
				func = function()
					self.ZoomMinX = start
					self.ZoomMaxX = ending
					self:Reload()
				end,
			},
			{
				text = L.BossWatcherGraphZoomGlobal,
				notCheckable = true,
				func = function()
					self.ZoomMinX = start
					self.ZoomMaxX = ending
					self:Reload()
					UpdateSegments(start,ending,nil,true)
				end,
			},
			{
				text = L.BossWatcherSelectFightClose,
				notCheckable = true,
				func = CloseDropDownMenus_fix,
			}
		}
		EasyMenu(zoomList, graphsTab.graphZoomDropDown, "cursor", 10 , -15, "MENU")
	end
	
	local function GraphGetFightMax()
		local i = 0
		for sec,data in pairs(CurrentFight.graphData) do
			i=max(sec,i)
		end
		return i
	end
	local function GraphHealthSelect(_,name)
		GraphsTab_Variables.HealthLastName = name
		
		local currTab = graphsTab
		
		local graphTypeName = GraphsTab_Variables.HealthTypeNow == 1 and "health" or "absorbs"
	
		local myGraphData = {}
		local maxFight = GraphGetFightMax()
		for sec,data in pairs(CurrentFight.graphData) do
			local health = data[name] and data[name][graphTypeName] or 0
			local maxHP = data[name] and data[name].hpmax or 0
			local maxHPtext = ""
			if maxHP > 0 then
				maxHPtext = format(" [%.1f%%]",(health or 0) / maxHP * 100)
			end
			local comment = (data[name] and data[name].name or "") .. maxHPtext
			if comment == "" then
				comment = nil
			end
			health = health or 0
			myGraphData[#myGraphData + 1] = {sec,health,format("%d:%02d",sec/60,sec%60),nil,comment}
		end
		table.sort(myGraphData,function(a,b)return a[1]<b[1] end)
		myGraphData.name = name
		if IsShiftKeyDown() and type(currTab.graph.data) == "table" and #currTab.graph.data > 0 then
			currTab.graph.data[#currTab.graph.data + 1] = myGraphData
		else
			currTab.graph.data = {myGraphData}
		end
		currTab.graph:Reload()
		
		currTab.graphicsTab.stepSlider:SetMinMaxValues(1,max(1,maxFight))
		currTab.graphicsTab.dropDown:SetText(name)	
		ELib:DropDownClose()
	end

	function tab.graphicsTab.byTargetDropDown.additionalToggle(self)
		local tabNow = graphsTab.graphicsTab.selected
		for i=2,#self.List do
			self.List[i].checkState = GraphsTab_Variables.DestTable[self.List[i].arg1]
			if tabNow == 1 then
				self.List[i].isHidden = (self.List[i].isEnemy and GraphsTab_Variables.LastDoEnemy) or (not self.List[i].isEnemy and not GraphsTab_Variables.LastDoEnemy)
			end
		end
	end

	local function GraphTabLoad()
		ELib:DropDownClose()
		local currTab = graphsTab
		currTab.graph.data = {}
		currTab.graph:Reload()
		currTab.graphicsTab.dropDown:SetText(L.BossWatcherGraphicsSelect)	
		table.wipe(currTab.graphicsTab.dropDown.List)
		currTab.graphicsTab.stepSlider:SetMinMaxValues(1,1)
		currTab.graphicsTab.stepSlider:SetValue(1)
		currTab.graphicsTab.dropDown.Lines = 10
		currTab.graphicsTab.dropDown.tooltip = L.BossWatcherGraphicsHoldShift
		
		currTab.graphicsTab.powerDropDown:Hide()
		currTab.graphicsTab.healthDropDown:Hide()
		currTab.graphicsTab.bySpellDropDown:Hide()
		currTab.graphicsTab.byTargetDropDown:Hide()
		
		GraphsTab_Variables.LastGUID = nil
		GraphsTab_Variables.LastDoEnemy = nil
		GraphsTab_Variables.LastDoSpell = nil
	end
	local GraphTab_SpecialUnits = {
		["_total"] = "*1",
		["boss1"] = "*2",
		["boss2"] = "*3",
		["boss3"] = "*4",
		["boss4"] = "*5",
		["boss5"] = "*6",
		["boss6"] = "*7",
		["target"] = "*8",
		["focus"] = "*9",
	}
	local function GraphTab_UnitDropDown_Check(self,checked)
		local graphData = graphsTab.graph.data
		local findPos = ExRT.F.table_find(graphData,self.arg1,'private_name')
		if findPos then
			graphData[ findPos ].hide = not checked
		end
		graphsTab.graph:Reload()
	end
	local function GraphTab_UnitDropDown_Click(self,arg1)
		ELib:DropDownClose()
		local graphData = graphsTab.graph.data
		for _,data in pairs(graphData) do
			data.hide = data.private_name ~= arg1
		end
		graphsTab.graph:Reload()
	end
	
	local function GraphTab_ReloadPage(_,newPowerID)
		local powerID = newPowerID or GraphsTab_Variables.PowerTypeNow
		GraphsTab_Variables.PowerTypeNow = powerID
		ELib:DropDownClose()
		graphsTab.graphicsTab.powerDropDown:SetText(L.BossWatcherSelectPower..module.db.energyLocale[powerID])
		wipe(graphsTab.graphicsTab.dropDown.List)
		
		local graphData = {}
		local maxFight = GraphGetFightMax()
		local units = GraphsTab_Variables.Cache[powerID]
		if units then
			for i=1,#units do
				local name = units[i]
			
				local info = {}
				graphsTab.graphicsTab.dropDown.List[i] = info
				local unitGUID = ExRT.F.table_find2(CurrentFight.raidguids,name)
				info.text = (unitGUID and "|c"..ExRT.F.classColorByGUID(unitGUID) or "")..name
				info.arg1 = name
				info.func = GraphTab_UnitDropDown_Click
				info.checkFunc = GraphTab_UnitDropDown_Check
				info.checkable = true
				--info.justifyH = "CENTER" 
				info._sort = GraphTab_SpecialUnits[ name ] or name
				
				local class,r,g,b = nil
				if unitGUID and unitGUID ~= "" then
					class = select(2,GetPlayerInfoByGUID(unitGUID))
				end
				if class then
					local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
					r,g,b = classColorArray.r,classColorArray.g,classColorArray.b
				end
				local unitGraphData = {
					name = info.text,
					private_name = name,
					hide = false,
					r = r,
					g = g,
					b = b,				
				}
				
				if powerID == 0 then
					unitGraphData.hide = CurrentFight.other.roles[name] ~= "HEALER"
				end
				
				for sec,data in pairs(CurrentFight.graphData) do
					local dataPower = data[name]
					if dataPower and dataPower[powerID] then
						unitGraphData[#unitGraphData + 1] = {sec,dataPower[powerID],format("%d:%02d",sec/60,sec%60),nil,data[name].name}
					else
						unitGraphData[#unitGraphData + 1] = {sec,0,format("%d:%02d",sec/60,sec%60),nil,dataPower and dataPower.name}
					end
				end
				table.sort(unitGraphData,function(a,b)return a[1]<b[1] end)				
			
				graphData[#graphData + 1] = unitGraphData
			end
		end
		table.sort(graphsTab.graphicsTab.dropDown.List,function(a,b)return a._sort < b._sort end) 
		
		graphsTab.graph.data = graphData
		graphsTab.graph:Reload()
	end
	local function GraphTab_UpdatePage()
		if not CurrentFight.graphData then
			return
		end
		
		local units,powers = {},{}
		for sec,data in pairs(CurrentFight.graphData) do
			for sourceName,dataPower in pairs(data) do
				for powerID,powerVal in pairs(dataPower) do
					powerID = tonumber(powerID)
					if powerID then
						powers[powerID] = true
						units[powerID] = units[powerID] or {}
						if not ExRT.F.table_find(units[powerID],sourceName) then
							units[powerID][#units[powerID]+1] = sourceName
						end
					end
				end
			end
		end
		
		wipe(graphsTab.graphicsTab.powerDropDown.List)
		for powerID,powerName in pairs(module.db.energyLocale) do
			if powers[powerID] then
				local info = {}
				graphsTab.graphicsTab.powerDropDown.List[ #graphsTab.graphicsTab.powerDropDown.List + 1 ] = info
				info.text = powerName
				info.arg1 = powerID
				info.func = GraphTab_ReloadPage
			end
		end
		table.sort(graphsTab.graphicsTab.powerDropDown.List,function(a,b)return a.arg1 < b.arg1 end)
		
		graphsTab.graphicsTab.powerDropDown.Lines = #graphsTab.graphicsTab.powerDropDown.List
		
		GraphsTab_Variables.Cache = units
		GraphsTab_Variables.PowerTypeNow = 0
		GraphTab_ReloadPage()
	end
	
	tab.graphicsTab.tabs[2]:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID == self.lastFightID then
			return
		end
		self.lastFightID = BWInterfaceFrame.nowFightID
		graphsTab.graphicsTab.tabs[3].lastFightID = nil

		GraphTabLoad()
		graphsTab.graphicsTab.healthDropDown:Show()
		if not CurrentFight.graphData then
			return
		end
		local units = {}
		for i,data in pairs(CurrentFight.graphData) do
			for sourceName,_ in pairs(data) do
				if not ExRT.F.table_find(units,sourceName) then
					units[#units+1] = sourceName
				end
			end
		end
		for i=1,#units do
			local info = {}
			graphsTab.graphicsTab.dropDown.List[i] = info
			local unitGUID = ExRT.F.table_find2(CurrentFight.raidguids,units[i])
			info.text = (unitGUID and "|c"..ExRT.F.classColorByGUID(unitGUID) or "")..units[i]
			info.arg1 = units[i]
			info.func = GraphHealthSelect
			info.justifyH = "CENTER" 
			info._sort = GraphTab_SpecialUnits[ units[i] ] or units[i]
		end
		table.sort(graphsTab.graphicsTab.dropDown.List,function(a,b)return a._sort < b._sort end)
	end)
	tab.graphicsTab.tabs[3]:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			GraphTabLoad()
			graphsTab.graphicsTab.powerDropDown:Show()
			GraphTab_UpdatePage()
			self.lastFightID = BWInterfaceFrame.nowFightID
			graphsTab.graphicsTab.tabs[2].lastFightID = nil
		end
	end)
	
	local function GraphPowerSelectHealthType(_,arg)
		GraphsTab_Variables.HealthTypeNow = arg
		if GraphsTab_Variables.HealthLastName then
			GraphHealthSelect(nil,GraphsTab_Variables.HealthLastName)
		end
		local text
		if arg == 1 then
			text = HEALTH
		else
			text = ACTION_SPELL_MISSED_ABSORB
		end
		graphsTab.graphicsTab.healthDropDown:SetText(L.BossWatcherSelectPower..text)
		ELib:DropDownClose()
	end	
	tab.graphicsTab.healthDropDown.List[1] = {text = HEALTH,arg1 = 1,func = GraphPowerSelectHealthType}
	tab.graphicsTab.healthDropDown.List[2] = {text = ACTION_SPELL_MISSED_ABSORB,arg1 = 2,func = GraphPowerSelectHealthType}
	
		
	tab.sourceList = ELib:ScrollList(tab.graphicsTab.tabs[1]):Size(190,365):Point(14,-45)
	tab.powerTypeList = ELib:ScrollList(tab.graphicsTab.tabs[1]):Size(190,136):Point("TOPLEFT",tab.sourceList,"BOTTOMLEFT",0,-8)
	tab.sourceList.IndexToGUID = {}
	tab.powerTypeList.IndexToGUID = {}
	
	local function EnergyLineOnEnter(self)
		if self.spellID then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetHyperlink("spell:"..self.spellID)
			GameTooltip:Show()
		end
	end
	
	tab.spells = {}
	for i=1,20 do
		tab.spells[i] = CreateFrame("Frame",nil,tab.graphicsTab.tabs[1])
		tab.spells[i]:SetPoint("TOPLEFT",220,-10-28*(i-1))
		tab.spells[i]:SetSize(420,28)
		
		tab.spells[i].texture = tab.spells[i]:CreateTexture(nil,"BACKGROUND")
		tab.spells[i].texture:SetSize(24,24)
		tab.spells[i].texture:SetPoint("TOPLEFT",0,-2)
		
		tab.spells[i].spellName = ELib:Text(tab.spells[i],"",13):Size(225,28):Point(26,0):Color():Shadow()
		tab.spells[i].amount = ELib:Text(tab.spells[i],"",12):Size(90,28):Point(250,0):Color():Shadow()
		tab.spells[i].count = ELib:Text(tab.spells[i],"",12):Size(80,28):Point(340,0):Color():Shadow()
		
		tab.spells[i]:SetScript("OnEnter",EnergyLineOnEnter)
		tab.spells[i]:SetScript("OnLeave",GameTooltip_Hide)
	end
	
	local function EnergyClearLines()
		for i=1,#graphsTab.spells do
			graphsTab.spells[i]:Hide()
		end
	end
	
	function tab.sourceList:SetListValue(index)
		local tab6 = graphsTab
		table.wipe(tab6.powerTypeList.L)
		table.wipe(tab6.powerTypeList.IndexToGUID)

		local sourceGUID = tab6.sourceList.IndexToGUID[index]
		tab6.sourceGUID = sourceGUID
		local powerList = {}
		for powerType,powerData in pairs(CurrentFight.power[sourceGUID]) do
			powerList[#powerList + 1] = {powerType,module.db.energyLocale[ powerType ] or L.BossWatcherEnergyTypeUnknown..powerType}
		end
		table.sort(powerList,function (a,b) return a[1] < b[1] end)
		for i,powerData in ipairs(powerList) do
			tab6.powerTypeList.L[i] = powerData[2]
			tab6.powerTypeList.IndexToGUID[i] = powerData[1]
		end
		
		--EnergyClearLines()
		tab6.powerTypeList.selected = 1
		tab6.powerTypeList:Update()
		tab6.powerTypeList:SetListValue(1)
	end
	function tab.powerTypeList:SetListValue(index)
		local powerType = graphsTab.powerTypeList.IndexToGUID[index]
		local sourceGUID = graphsTab.sourceGUID
		
		local spellList = {
			{nil,L.BossWatcherReportTotal,"",0,0},
		}
		for spellID,spellData in pairs(CurrentFight.power[sourceGUID][powerType]) do
			local spellName,_,spellTexture = GetSpellInfo(spellID)
			spellList[#spellList + 1] = {spellID,spellName,spellTexture,spellData[1],spellData[2]}
			spellList[1][4] = spellList[1][4] + spellData[1]
			spellList[1][5] = spellList[1][5] + spellData[2]
		end
		table.sort(spellList,function (a,b) return a[4] > b[4] end)
		EnergyClearLines()
		if #spellList > 1 then
			for i,spellData in ipairs(spellList) do
				local line = graphsTab.spells[i]
				if line then
					line.texture:SetTexture(spellData[3])
					line.spellName:SetText(spellData[2])
					line.amount:SetText(spellData[4])
					line.count:SetText(spellData[5].." |4"..L.BossWatcherEnergyOnce1..":"..L.BossWatcherEnergyOnce2..":"..L.BossWatcherEnergyOnce1)
					line.spellID = spellData[1]
					line:Show()
				end
			end
		end
	end

	local function UpdatePowerPage()
		table.wipe(graphsTab.sourceList.L)
		table.wipe(graphsTab.sourceList.IndexToGUID)
		table.wipe(graphsTab.powerTypeList.L)
		table.wipe(graphsTab.powerTypeList.IndexToGUID)
		local sourceListTable = {}
		for sourceGUID,sourceData in pairs(CurrentFight.power) do
			if (PowerTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(CurrentFight.reaction[sourceGUID],1) == 1024) or (not PowerTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(CurrentFight.reaction[sourceGUID],2) == 512) then
				sourceListTable[#sourceListTable + 1] = {sourceGUID,GetGUID( sourceGUID ),"|c"..ExRT.F.classColorByGUID(sourceGUID)}
			end
		end
		table.sort(sourceListTable,function (a,b) return a[2] < b[2] end)
		for i,sourceData in ipairs(sourceListTable) do
			graphsTab.sourceList.L[i] = sourceData[3]..sourceData[2]
			graphsTab.sourceList.IndexToGUID[i] = sourceData[1]
		end
		
		graphsTab.sourceList.selected = nil
		graphsTab.powerTypeList.selected = nil
		
		graphsTab.sourceList:Update()
		graphsTab.powerTypeList:Update()
		EnergyClearLines()
	end
	
	tab.chkFriendly = ELib:Radio(tab.graphicsTab.tabs[1],L.BossWatcherFriendly,true):Point(15,-10):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		graphsTab.chkEnemy:SetChecked(false)
		PowerTab_isFriendly = true
		UpdatePowerPage()
	end)
	tab.chkEnemy = ELib:Radio(tab.graphicsTab.tabs[1],L.BossWatcherHostile):Point(15,-25):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		graphsTab.chkFriendly:SetChecked(false)
		PowerTab_isFriendly = nil
		UpdatePowerPage()
	end)

	do
		local firstLoad = nil
		tab:SetScript("OnShow",function (self)
			if BWInterfaceFrame.nowFightID ~= self.lastFightID then
				if not firstLoad then
					firstLoad = true
					graphsTab.graphicsTab:buttonAdditionalFunc()
				end
				GraphsTab_Variables.PowerLastName = nil
				GraphsTab_Variables.HealthLastName = nil
				self.lastFightID = BWInterfaceFrame.nowFightID
				UpdatePowerPage()
			end
		end)
	end
	
	
	---- Interrupt & dispels
	tab = BWInterfaceFrame.tab.tabs[7]
	local interruptTab = tab
	
	tab.DecorationLine = tab:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-80)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine:SetColorTexture(1,1,1,1)
	tab.DecorationLine:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	do
		local broke = ACTION_SPELL_AURA_BROKEN
		broke = (ExRT.F:utf8sub(broke,1,1):upper())..ExRT.F:utf8sub(broke,2,-1)
		tab.tabs = ELib:Tabs(tab,0,
			L.BossWatcherInterrupts,
			L.BossWatcherDispels,
			broke
		):Size(845,485):Point("TOP",0,-100)
	end
	tab.tabs.tabs[3].button.tooltip = L.BossWatcherBrokeTooltip
	tab.tabs:SetBackdropBorderColor(0,0,0,0)
	tab.tabs:SetBackdropColor(0,0,0,0)
	
	local Intterupt_Type = 1
	local UpdateInterruptPage = nil
	
	function tab.tabs:buttonAdditionalFunc()
		UpdateInterruptPage()
	end
	
	tab.bySource = ELib:Radio(tab.tabs,L.BossWatcherBySource,true):Point(10,-3):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		interruptTab.byTarget:SetChecked(false)
		interruptTab.bySpell:SetChecked(false)
		Intterupt_Type = 1
		UpdateInterruptPage()
	end)
	tab.byTarget = ELib:Radio(tab.tabs,L.BossWatcherByTarget):Point(10,-18):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		interruptTab.bySource:SetChecked(false)
		interruptTab.bySpell:SetChecked(false)
		Intterupt_Type = 2
		UpdateInterruptPage()
	end)
	tab.bySpell = ELib:Radio(tab.tabs,L.BossWatcherBySpell):Point(10,-33):AddButton():OnClick(function(self) 
		self:SetChecked(true)
		interruptTab.byTarget:SetChecked(false)
		interruptTab.bySource:SetChecked(false)
		Intterupt_Type = 3
		UpdateInterruptPage()
	end)
	
	tab.list = ELib:ScrollList(tab):Size(190,434):Point(14,-155)
	tab.list.GUIDs = {}
	
	tab.events = ELib:ScrollList(tab):Size(637,481):Point(214,-108)
	tab.events.DATA = {}
	
	function tab.list:SetListValue(index)
		local currTab = interruptTab
		local filter = currTab.list.GUIDs[index]
		local isInterrupt = currTab.tabs.selected == 1
		local isDispel = currTab.tabs.selected == 2
		local isBroke = currTab.tabs.selected == 3
		local workTable = CurrentFight.interrupts
		if isBroke then
			workTable = CurrentFight.aurabroken
		elseif not isInterrupt then
			workTable = CurrentFight.dispels
		end
		table.wipe(currTab.events.L)
		table.wipe(currTab.events.DATA)
		if index == 2 then
			local data = {}
			for i,line in ipairs(workTable) do
				local toAdd = nil
				if Intterupt_Type == 1 then
					toAdd = line[1]
				elseif Intterupt_Type == 2 then
					toAdd = line[2]
				elseif Intterupt_Type == 3 then
					toAdd = line[4]
				end
				if toAdd and CurrentFight.segments[ line.s ].e then
					local pos = ExRT.F.table_find(data,toAdd,1)
					if pos then
						data[pos][2] = data[pos][2] + 1
					else
						data[#data + 1] = {toAdd,1,line}
					end
				end
			end
			sort(data,function(a,b) return a[2]>b[2] end)
			for i=1,#data do
				local name = data[i][1]
				if Intterupt_Type == 3 then
					local spellName,_,spellTexture = GetSpellInfo(name)
					name = "|T"..spellTexture..":0|t ".. spellName
				else
					name = "|c".. ExRT.F.classColorByGUID(name) .. GetGUID(name) .. GUIDtoText(" (%s)",name).."|r"
				end
				currTab.events.L[#currTab.events.L + 1] = name .. ": " ..data[i][2]
				currTab.events.DATA[#currTab.events.L] = data[i][3]
			end
		else
			local SpellCanBeKicked = {}
			local SpellDispel = {}
			local resultData = {}
			for i,line in ipairs(workTable) do
				local isOkay = false
				if (Intterupt_Type == 1 and (not filter or line[1] == filter)) or
				   (Intterupt_Type == 2 and (not filter or line[2] == filter)) or
				   (Intterupt_Type == 3 and (not filter or line[4] == filter)) then
					isOkay = true
				end
				if isOkay then
					if isInterrupt and not line[2]:find("^Player%-") then
						SpellCanBeKicked[ line[4] ] = true
					elseif isDispel then
						SpellDispel[ line[3] ] = true
					end
					if CurrentFight.segments[ line.s ].e then
						local spellSourceName,_,spellSourceTexture = GetSpellInfo(line[3])
						local spellDestName,_,spellDestTexture = GetSpellInfo(line[4])
						local dispelOrInterrupt = L.BossWatcherDispelText
						local brokeType = nil
						if isInterrupt then
							dispelOrInterrupt = L.BossWatcherInterruptText
						elseif isBroke then
							dispelOrInterrupt = ACTION_SPELL_AURA_BROKEN
							brokeType = line[6] and " ("..line[6]:lower()..")"
							spellSourceName,spellSourceTexture,spellDestName,spellDestTexture = spellDestName,spellDestTexture,spellSourceName,spellSourceTexture
						end
						local sourceMarker = module.db.raidTargets[ isBroke and line[7] or line[6] or 0 ]
						local destMarker = module.db.raidTargets[ isBroke and line[8] or line[7] or 0 ]
						
						resultData[#resultData+1] = {
							"[".. date("%M:%S", timestampToFightTime(line[5])) .. format(".%03d",timestampToFightTime(line[5]) * 1000 % 1000).."] |c".. ExRT.F.classColorByGUID(line[1]) ..(sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "") .. GetGUID(line[1]) .. GUIDtoText(" (%s)",line[1]) .. "|r "..dispelOrInterrupt.." |c" ..  ExRT.F.classColorByGUID(line[2])..(destMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. destMarker  ..":0|t" or "").. GetGUID(line[2]) .. "'s" .. GUIDtoText(" (%s)",line[2]) .. "|r |Hspell:" .. (line[4] or 0) .. "|h" .. format("%s%s",spellDestTexture and "|T"..spellDestTexture..":0|t " or "",spellDestName or "???") .. "|h"..(brokeType or "").." "..L.BossWatcherByText.." |Hspell:" .. (line[3] or 0) .. "|h" .. format("%s%s",spellSourceTexture and "|T"..spellSourceTexture..":0|t " or "",spellSourceName or "???") .. "|h",
							line,
							line[5],
							i,
						}
					end
				end
			end
			if isInterrupt and not filter then
				local subCount = 0
				for GUID,dataGUID in pairs(CurrentFight.cast) do
					for i,PlayerCastData in ipairs(dataGUID) do
						if CurrentFight.segments[ PlayerCastData.s ].e and SpellCanBeKicked[ PlayerCastData[2] ] and PlayerCastData[3] == 1 then
							local spellSourceName,_,spellSourceTexture = GetSpellInfo(PlayerCastData[2])
							local sourceMarker = module.db.raidTargets[ PlayerCastData[6] or 0 ]
							local destMarker = module.db.raidTargets[ PlayerCastData[5] or 0 ]
							subCount = subCount +1
							resultData[#resultData+1] = {
								"|cffff9999[".. date("%M:%S", timestampToFightTime(PlayerCastData[1])).. format(".%03d",timestampToFightTime(PlayerCastData[1]) * 1000 % 1000).."] |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:128:144:64:80|t |c".. ExRT.F.classColorByGUID(GUID) ..(sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "") .. GetGUID(GUID) .. GUIDtoText(" (%s)",GUID) .. "|r "..L.BossWatcherTimeLineCast.." |Hspell:" .. (PlayerCastData[3] or 0) .. "|h" .. format("%s%s",spellSourceTexture and "|T"..spellSourceTexture..":0|t " or "",spellSourceName or "???") .. "|h"..(PlayerCastData[4] and PlayerCastData[4] ~= "" and (" > |c".. ExRT.F.classColorByGUID(PlayerCastData[4]) ..(destMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. destMarker  ..":0|t" or "") .. GetGUID(PlayerCastData[4]) .. GUIDtoText(" (%s)",PlayerCastData[4]) .. "|r") or ""),
								{nil,nil,nil,PlayerCastData[2],PlayerCastData[1]},
								PlayerCastData[1],
								subCount,
							}
						end
					end
				end
			end
			if isDispel and not filter then
				local subCount = 0
				for GUID,dataGUID in pairs(CurrentFight.cast) do
					for i,PlayerCastData in ipairs(dataGUID) do
						if CurrentFight.segments[ PlayerCastData.s ].e and SpellDispel[ PlayerCastData[2] ] and PlayerCastData[3] == 1 then
							local spellSourceName,_,spellSourceTexture = GetSpellInfo(PlayerCastData[2])
							local sourceMarker = module.db.raidTargets[ PlayerCastData[6] or 0 ]
							local destMarker = module.db.raidTargets[ PlayerCastData[5] or 0 ]
							local findEm = nil
							for j=1,#resultData do
								if GUID == resultData[j][2][1] and abs(resultData[j][3] - PlayerCastData[1]) < 0.5 then
									findEm = true
									break
								elseif (resultData[j][3] - PlayerCastData[1]) > 2 then
									break
								end
							end
							if not findEm then
								subCount = subCount + 1
								resultData[#resultData+1] = {
									"|cffff9999[".. date("%M:%S", timestampToFightTime(PlayerCastData[1])).. format(".%03d",timestampToFightTime(PlayerCastData[1]) * 1000 % 1000).."] |TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:128:144:64:80|t |c".. ExRT.F.classColorByGUID(GUID) ..(sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "") .. GetGUID(GUID) .. GUIDtoText(" (%s)",GUID) .. "|r "..L.BossWatcherTimeLineCast.." |Hspell:" .. (PlayerCastData[3] or 0) .. "|h" .. format("%s%s",spellSourceTexture and "|T"..spellSourceTexture..":0|t " or "",spellSourceName or "???") .. "|h" ..(PlayerCastData[4] and PlayerCastData[4] ~= "" and (" > |c".. ExRT.F.classColorByGUID(PlayerCastData[4]) ..(destMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. destMarker  ..":0|t" or "") .. GetGUID(PlayerCastData[4]) .. GUIDtoText(" (%s)",PlayerCastData[4]) .. "|r") or ""),
									{nil,nil,nil,PlayerCastData[2],PlayerCastData[1]},
									PlayerCastData[1],
									subCount,
								}
							end
						end
					end
				end
			end
			sort(resultData,function(a,b)if a[3]==b[3] then return a[4]<b[4] else return a[3]<b[3] end end)
			for i=1,#resultData do
				currTab.events.L[#currTab.events.L + 1] = resultData[i][1]
				currTab.events.DATA[#currTab.events.L] = resultData[i][2]
			end
		end
		currTab.events:Update()
	end
	function tab.events:SetListValue(index)
		self.selected = nil
		self:Update()
	end
	function tab.events:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			GameTooltip_Hide()
			ELib.Tooltip:HideAdd()
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
		else
			local this = hoveredObj
			local line = interruptTab.events.DATA[index]
			
			GameTooltip:SetOwner(this or self,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetHyperlink("spell:"..line[4])
			GameTooltip:Show()
			
			if line[3] then
				ELib.Tooltip:Add("spell:"..line[3])
			end
			
			if this.text:IsTruncated() then
				ELib.Tooltip:Add(nil,{this.text:GetText()},false,true)
			end
			
			local _time = timestampToFightTime(line[5]) / GetFightLength(true)
			
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*_time,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
		end
	end

	function UpdateInterruptPage()
		local currTab = interruptTab
		table.wipe(currTab.list.L)
		table.wipe(currTab.list.GUIDs)
		table.wipe(currTab.events.L)
		
		local workTable = CurrentFight.interrupts
		if currTab.tabs.selected == 2 then
			workTable = CurrentFight.dispels
		elseif currTab.tabs.selected == 3 then
			workTable = CurrentFight.aurabroken
		end
		local data = {}
		for i,line in ipairs(workTable) do
			if Intterupt_Type == 1 then
				if not ExRT.F.table_find(data,line[1]) and CurrentFight.segments[ line.s ].e then
					data[#data + 1] = line[1]
				end
			elseif Intterupt_Type == 2 then
				if not ExRT.F.table_find(data,line[2]) and CurrentFight.segments[ line.s ].e then
					data[#data + 1] = line[2]
				end
			else
				if not ExRT.F.table_find(data,line[4]) and CurrentFight.segments[ line.s ].e then
					data[#data + 1] = line[4]
				end
			end
		end
		local data2 = {}
		for i=1,#data do
			if Intterupt_Type ~= 3 then
				data2[i] = {data[i],GetGUID(data[i]),"|c"..ExRT.F.classColorByGUID(data[i])}
			else
				local spellName = GetSpellInfo(data[i])
				data2[i] = {data[i],spellName}
			end
		end
		sort(data2,function(a,b)return a[2]<b[2] end)
		for i=1,#data2 do
			currTab.list.L[i+2] = (data2[i][3] or "")..data2[i][2]
			currTab.list.GUIDs[i+2] = data2[i][1]
		end
		currTab.list.L[1] = L.BossWatcherAll
		currTab.list.L[2] = L.BossWatcherSpellsCount
		
		currTab.list.selected = 1
		
		currTab.list:Update()
		currTab.list:SetListValue(1)
		--currTab.events:Update()
	end

	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateInterruptPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
	end)


	
	
	---- Heal
	tab = BWInterfaceFrame.tab.tabs[2]
	
	local HsourceVar,HdestVar = {},{}
	local HealingTab_SetLine = nil
	local HealingTab_Variables = {
		Last_Func = nil,
		Last_doEnemy = nil,
		Last_doReduction = nil,
		ShowOverheal = false,
		Back_Func = nil,
		Back_destVar = nil,
		Back_sourceVar = nil,
		NULLSpellAmount = {
			amount = 0,
			over = 0,
			absorbed = 0,
			count = 0,
			crit = 0,
			critcount = 0,
			critmax = 0,
			critover = 0,
			hitmax = 0,
			absorbs = 0,
		},
		
		state_friendly = true,
		state_spells = false,
		state_mitigation = false,
		state_byTarget = false,
	}
	local HealingTab_UpdatePage
	
	local function HealingTab_UpdateDropDown(arr,dropDown)
		local count = ExRT.F.table_len(arr)
		if count == 0 then
			dropDown:SetText(L.BossWatcherAll)
		elseif count == 1 then
			local GUID = nil
			for g,_ in pairs(arr) do
				GUID = g
			end
			local name = GetGUID(GUID)
			local flags = CurrentFight.reaction[GUID]
			local isPlayer = ExRT.F.GetUnitInfoByUnitFlag(flags,1) == 1024
			local isNPC = ExRT.F.GetUnitInfoByUnitFlag(flags,2) == 512
			if isPlayer then
				name = "|c"..ExRT.F.classColorByGUID(GUID)..name
			elseif isNPC then
				name = name .. GUIDtoText(" [%s]",GUID)
			end
			dropDown:SetText(name)
		else
			dropDown:SetText(L.BossWatcherSeveral)
		end
	end

	local function HealingTab_UpdateDropDowns()
		HealingTab_UpdateDropDown(HsourceVar,BWInterfaceFrame.tab.tabs[2].sourceDropDown)
		HealingTab_UpdateDropDown(HdestVar,BWInterfaceFrame.tab.tabs[2].targetDropDown)
	end
	local function HealingTab_UpdateChecks()
		local tab = BWInterfaceFrame.tab.tabs[2]
		for _,c in pairs({tab.chkFriendly,tab.chkEnemy,tab.chkMitigation,tab.bySource,tab.byTarget,tab.bySpell}) do
			c:SetChecked(false)
		end
		if HealingTab_Variables.state_mitigation then
			tab.chkMitigation:SetChecked(true)
		elseif HealingTab_Variables.state_friendly then
			tab.chkFriendly:SetChecked(true)
		else
			tab.chkEnemy:SetChecked(true)
		end
		if HealingTab_Variables.state_spells then
			tab.bySpell:SetChecked(true)
		end
		if HealingTab_Variables.state_byTarget then
			tab.byTarget:SetChecked(true)
		elseif not HealingTab_Variables.state_spells then
			tab.bySource:SetChecked(true)
		end
	end	
	
	local function HealingTab_ReloadGraph(data,fightLength,linesData,isSpell)
		local graphData = {}
		for key,spellData in pairs(data) do
			local newData
			if isSpell then
				local spellID = key
				local isPet = 1
				if (not ExRT.isClassic) and spellID < -1 then
					isPet = -1
					spellID = -spellID
				end
				local spellName,_,spellIcon = GetSpellInfo(spellID)
				if spellID == -1 then
					spellName = L.BossWatcherReportTotal
				elseif spellName then
					spellName = "|T"..spellIcon..":0|t "..spellName
				else
					spellName = spellID
				end
				newData = {
					info_spellID = type(spellID)=='number' and spellID*isPet or spellID,
					name = spellName,
					total_healing = 0,
					hide = true,
				}
			else
				local sourceGUID = key
				local name,r,g,b = nil
				if sourceGUID == -1 then
					name = L.BossWatcherReportTotal
				else
					local class
					name = GetGUID(sourceGUID)
					if sourceGUID ~= "" then
						class = select(2,GetPlayerInfoByGUID(sourceGUID))
					end
					name = "|c".. ExRT.F.classColor(class) .. name .. "|r"
					if class then
						local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
						r,g,b = classColorArray.r,classColorArray.g,classColorArray.b
					end
				end
				newData = {
					info_spellID = sourceGUID,
					name = name,
					total_healing = 0,
					hide = true,
					r = r,
					g = g,
					b = b,
				}
			end
			graphData[#graphData+1] = newData
			local totalHealing = 0
			for i=1,fightLength do
				newData[i] = {i,spellData[i] or 0}
				totalHealing = totalHealing + (spellData[i] or 0)
			end
			newData.total_healing = totalHealing
		end
		sort(graphData,function(a,b) return a.total_healing>b.total_healing end)
		local findPos = ExRT.F.table_find(graphData,-1,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = nil
			graphData[ findPos ].specialLine = true
		end
		for i=1,3 do
			if linesData[i] then
				findPos = ExRT.F.table_find(graphData,linesData[i][isSpell and "spell" or "guid"],'info_spellID')
				if findPos then
					graphData[ findPos ].hide = nil
				end
			end
		end
		BWInterfaceFrame.GraphFrame.G.data = graphData
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	
	local function HealingTab_UpdateLines_GetUnit(heal,graph,source,dest,header,secondHeader)
		header = header or "guid"
		local sourceHeal
		
		for i=1,#heal do
			if heal[i][header] == source and (not secondHeader or heal[i].info == secondHeader) then
				sourceHeal = i
				break
			end
		end
		
		if not sourceHeal then
			sourceHeal = #heal + 1
			heal[sourceHeal] = {
				[header] = source,
				info = secondHeader,
				eff = 0,
				total = 0,
				count = 0,
				overheal = 0,
				absorbed = 0,
				absorbs = 0,
				crit = 0,
				critcount = 0,
				critmax = 0,
				critover = 0,
				hitmax = 0,
				targets = {},
				from = {},
			}
		end
		sourceHeal = heal[sourceHeal]
		
		local destPos
		
		local targets = sourceHeal.targets
		for i=1,#targets do
			if targets[i][1] == dest then
				destPos = i
				break
			end
		end		
		
		if not destPos then
			destPos = #sourceHeal.targets + 1
			sourceHeal.targets[destPos] = {dest,0}
		end
		
		if not graph[ source ] then
			graph[ source ] = {}
		end
		
		return sourceHeal, sourceHeal.targets[destPos]
	end
	
	local function HealingTab_UpdateLinesPlayers()
		ExRT.F.dprint("Healing Update: Players",GetTime())
		HealingTab_UpdateDropDowns()
		HealingTab_UpdateChecks()
		
		local doEnemy = not HealingTab_Variables.state_friendly
		local doReduction = HealingTab_Variables.state_mitigation
		local isReverse = HealingTab_Variables.state_byTarget
		local onlyReduction = doReduction
	
		local heal = {}
		local total = 0
		local totalOver = 0
		local graph = {[-1]={}}
		if not onlyReduction then
			for sourceGUID,sourceData in pairs(CurrentFight.heal) do
				local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
				if owner then
					sourceGUID = owner
				end
				if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
					for destGUID,destData in pairs(sourceData) do
						for destReact,destReactData in pairs(destData) do
							local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(destReact)
							if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
								if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
									local source = isReverse and destGUID or sourceGUID
									local dest = isReverse and sourceGUID or destGUID
									
									local sourceHeal, destPos = HealingTab_UpdateLines_GetUnit(heal,graph,source,dest,"guid")
									
									for spellID,spellSegments in pairs(destReactData) do
										for segment,spellAmount in pairs(spellSegments) do
											if CurrentFight.segments[segment].e then
												if spellID == 98021 then	--Spirit Link
													spellAmount = HealingTab_Variables.NULLSpellAmount
												end
												sourceHeal.eff = sourceHeal.eff + spellAmount.amount - spellAmount.over + spellAmount.absorbed
												sourceHeal.total = sourceHeal.total + spellAmount.amount + spellAmount.absorbed						--total
												sourceHeal.overheal = sourceHeal.overheal + spellAmount.over 							--overheal
												sourceHeal.absorbed = sourceHeal.absorbed + spellAmount.absorbed 						--absorbed
												sourceHeal.crit = sourceHeal.crit + spellAmount.crit - (HealingTab_Variables.ShowOverheal and 0 or spellAmount.critover)
												sourceHeal.absorbs = sourceHeal.absorbs + spellAmount.absorbs						--absorbs
												total = total + spellAmount.amount - spellAmount.over + spellAmount.absorbed
												totalOver = totalOver + spellAmount.over
												
												destPos[2] = destPos[2] + spellAmount.amount + spellAmount.absorbed + (HealingTab_Variables.ShowOverheal and 0 or -spellAmount.over)
		
												if not graph[ source ][segment] then
													graph[ source ][segment] = 0
												end
												if not graph[ -1 ][segment] then
													graph[ -1 ][segment] = 0
												end
												local healCount = spellAmount.amount - (HealingTab_Variables.ShowOverheal and 0 or spellAmount.over) + spellAmount.absorbed
												graph[ source ][segment] = graph[ source ][segment] + healCount
												graph[ -1 ][segment] = graph[ -1 ][segment] + healCount
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if doReduction and not doEnemy then
			for destGUID,destData in pairs(CurrentFight.reduction) do
				if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellData in pairs(sourceData) do
							for reductorGUID,reductorData in pairs(spellData) do
								local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
								if owner then
									reductorGUID = owner
								end
								if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
									local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[reductorGUID])
									if isFriendly then
										local source = isReverse and destGUID or reductorGUID
										local dest = isReverse and reductorGUID or destGUID
										
										local sourceHeal, destPos = HealingTab_UpdateLines_GetUnit(heal,graph,source,dest,"guid")								
										
										for reductionSpellID,spellSegments in pairs(reductorData) do
											for segment,reductionSpellAmount in pairs(spellSegments) do
												if CurrentFight.segments[segment].e then
													sourceHeal.eff = sourceHeal.eff + reductionSpellAmount
													sourceHeal.total = sourceHeal.total + reductionSpellAmount
													if not onlyReduction then
														sourceHeal.absorbs = sourceHeal.absorbs + reductionSpellAmount
													end
											
													total = total + reductionSpellAmount
											
													destPos[2] = destPos[2] + reductionSpellAmount
													

													if not graph[ source ][segment] then
														graph[ source ][segment] = 0
													end
													if not graph[ -1 ][segment] then
														graph[ -1 ][segment] = 0
													end
													
													graph[ source ][segment] = graph[ source ][segment] + reductionSpellAmount
													graph[ -1 ][segment] = graph[ -1 ][segment] + reductionSpellAmount
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
			if HealingTab_Variables.ShowOverheal and onlyReduction then
				local missData = {}
				local avgDamage = {}
				for destGUID,destData in pairs(CurrentFight.damage) do
					for destReaction,destReactData in pairs(destData) do
						for sourceGUID,sourceData in pairs(destReactData) do
							local avgData = avgDamage[sourceGUID]
							if not avgData then
								avgData = {}
								avgDamage[sourceGUID] = avgData
							end
							for spellID,spellSegments in pairs(sourceData) do
								local avgSpell = avgData[spellID]
								if not avgSpell then
									avgSpell = {0,0}
									avgData[spellID] = avgSpell
								end
								for segment,spellAmount in pairs(spellSegments) do							
									avgSpell[1] = avgSpell[1] + spellAmount.count
									avgSpell[2] = avgSpell[2] + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
									
									if spellAmount.parry > 0 or spellAmount.dodge > 0 or spellAmount.miss > 0 then
										local missDestData = missData[destGUID]
										if not missDestData then
											missDestData = {}
											missData[destGUID] = missDestData
										end
										local missSpell = missDestData[sourceGUID]
										if not missSpell then
											missSpell = {}
											missDestData[sourceGUID] = missSpell
										end
										local missSpellData = missSpell[spellID]
										if not missSpellData then
											missSpellData = {
												parry = 0,
												dodge = 0,
												miss = 0,
												parry_target = 0,
												dodge_target = 0,
												miss_target = 0,
												segments = {},
											}
											missSpell[spellID] = missSpellData
										end
										missSpellData.parry = missSpellData.parry+spellAmount.parry
										missSpellData.dodge = missSpellData.dodge+spellAmount.dodge
										missSpellData.miss = missSpellData.miss+spellAmount.miss
										
										if CurrentFight.segments[segment].e then
											missSpellData.parry_target = missSpellData.parry_target+spellAmount.parry
											missSpellData.dodge_target = missSpellData.dodge_target+spellAmount.dodge
											missSpellData.miss_target = missSpellData.miss_target+spellAmount.miss
											missSpellData.segments[#missSpellData.segments+1] = segment
										end
									end
								end
							end
						end
					end
				end
				local reductionMissToSpell = {
					dodge = 81,
					parry = 82243,
					miss = 154592,
				}
				for destGUID,destData in pairs(missData) do
					local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[destGUID] or 0)
					if isFriendly and (ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[destGUID]) then
						for sourceGUID,sourceData in pairs(destData) do
							for spellID,spellAmount in pairs(sourceData) do
								local avgData = avgDamage[ sourceGUID ][ spellID ]
								local avg = avgData[3]
								if not avg then
									if avgData[1] > 0 then
										avg = avgData[2] / avgData[1]
									else
										avg = 0
									end
									avgData[3] = avg
								end
								if avg > 0 then
									for reductionName,reductionSpellID in pairs(reductionMissToSpell) do
										if spellAmount[reductionName] > 0 then
											local sourceHeal, destPos = HealingTab_UpdateLines_GetUnit(heal,graph,destGUID,destGUID,"guid")
										
											local fromSpellPos = ExRT.F.table_find(sourceHeal.from,spellID,1)
											if not fromSpellPos then
												fromSpellPos = #sourceHeal.from + 1
												sourceHeal.from[fromSpellPos] = {spellID,0}
											end
											fromSpellPos = sourceHeal.from[fromSpellPos]
										
											local amount = avg * spellAmount[reductionName.."_target"]
										
											sourceHeal.eff = sourceHeal.eff + amount
											sourceHeal.total = sourceHeal.total + amount
											sourceHeal.absorbs = sourceHeal.absorbs + amount
											total = total + amount
											destPos[2] = destPos[2] + amount
											fromSpellPos[2] = fromSpellPos[2] + amount
											
											for i=1,#spellAmount.segments do
												local segment = spellAmount.segments[i]
												if not graph[ destGUID ] then
													graph[ destGUID ] = {}
												end
												if not graph[ destGUID ][segment] then
													graph[ destGUID ][segment] = 0
												end
												if not graph[ -1 ][segment] then
													graph[ -1 ][segment] = 0
												end
												graph[ destGUID ][segment] = graph[ destGUID ][segment] + amount
												graph[ -1 ][segment] = graph[ -1 ][segment] + amount
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
		end
		if not isReverse and not onlyReduction then
			for _,healData in pairs(heal) do
				for sourceGUID,sourceData in pairs(CurrentFight.healFrom) do
					if healData.guid == sourceGUID or ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB()) == healData.guid then
						for destGUID,destData in pairs(sourceData) do
							local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[destGUID])
							if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
								if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
									for spellID,spellData in pairs(destData) do
										for fromSpellID,fromSpellSegments in pairs(spellData) do
											for segment,fromSpellAmount in pairs(fromSpellSegments) do
												if CurrentFight.segments[segment].e then
										
													local destPos = ExRT.F.table_find(healData.from,fromSpellID,1)
													if not destPos then
														destPos = #healData.from + 1
														healData.from[destPos] = {fromSpellID,0}
													end
													destPos = healData.from[destPos]
													
													destPos[2] = destPos[2] + fromSpellAmount
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		if HealingTab_Variables.ShowOverheal then
			total = total + totalOver
			sort(heal,function(a,b) return a.total>b.total end)
			_max = heal[1] and heal[1].total or 0
		else
			sort(heal,function(a,b) return a.eff>b.eff end)
			_max = heal[1] and heal[1].eff or 0
		end
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = HealingTab_Variables.ShowOverheal and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#heal do
			local healLine = heal[i]
			local class = nil
			if healLine.guid and healLine.guid ~= "" then
				class = select(2,GetPlayerInfoByGUID(healLine.guid))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(healLine.guid),
				{L.BossWatcherHealTooltipOver,format("%s (%.1f%%)",ExRT.F.shortNumber(healLine.overheal),healLine.overheal/max(healLine.total,1)*100)},
				{L.BossWatcherHealTooltipAbsorbed,ExRT.F.shortNumber(healLine.absorbed)},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(healLine.total)},
				{" "," "},
				{L.BossWatcherHealTooltipFromCrit,format("%s (%.1f%%)",ExRT.F.shortNumber(healLine.crit),healLine.crit/max(1,healLine.eff+(HealingTab_Variables.ShowOverheal and healLine.overheal or 0))*100)},
				{ACTION_SPELL_MISSED_ABSORB,format("%s (%.1f%%)",ExRT.F.shortNumber(healLine.absorbs),healLine.absorbs/max(healLine.eff+(HealingTab_Variables.ShowOverheal and healLine.overheal or 0),1)*100)},
			}
			sort(healLine.targets,DamageTab_Temp_SortingBy2Param)
			if #healLine.targets > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#healLine.targets) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(healLine.targets[j][1]),20)..GUIDtoText(" [%s]",healLine.targets[j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(healLine.targets[j][2]),min(healLine.targets[j][2] / max(1,healLine.eff+(HealingTab_Variables.ShowOverheal and healLine.overheal or 0))*100,100))}
			end
			sort(healLine.from,DamageTab_Temp_SortingBy2Param)
			if #healLine.from > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherFromSpells," "}
			end
			for j=1,min(5,#healLine.from) do
				local spellName,_,spellTexture = GetSpellInfo(healLine.from[j][1])
				tooltipData[#tooltipData + 1] = {(spellTexture and "|T"..spellTexture..":0|t" or "")..(spellName or "spell:"..(healLine.from[j][1] or -1)),ExRT.F.shortNumber(healLine.from[j][2])}
			end
			
			local currHealing = healLine.eff+(HealingTab_Variables.ShowOverheal and healLine.overheal or 0)
			local hps = currHealing/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(healLine.guid)..GUIDtoText(" [%s]",healLine.guid),
				num = currHealing,
				total = total,
				max = _max,
				alpha = (HealingTab_Variables.ShowOverheal and not onlyReduction) and healLine.overheal or healLine.absorbs,
				dps = hps,
				class = class,
				sourceGUID = healLine.guid,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..GetGUID(healLine.guid).." - "..ExRT.F.shortNumber(currHealing).."@1@ ("..floor(hps)..")@1#"
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		

		HealingTab_Variables.graphCache = {graph,#CurrentFight.segments,heal,false}
		if BWInterfaceFrame.GraphFrame:IsShown() then
			HealingTab_ReloadGraph(graph,#CurrentFight.segments,heal,false)
		end
	end
	local function HealingTab_UpdateLinesSpell()
		ExRT.F.dprint("Healing Update: Spells",GetTime())
		HealingTab_UpdateDropDowns()
		HealingTab_UpdateChecks()

		local doEnemy = not HealingTab_Variables.state_friendly
		local doReduction = HealingTab_Variables.state_mitigation
		local onlyReduction = doReduction

		local heal = {}
		local total = 0
		local totalOver = 0
		local graph = {[-1]={}}
		if not onlyReduction then
			for sourceGUID,sourceData in pairs(CurrentFight.heal) do
				local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
				if owner then
					sourceGUID = owner
				end
				if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
					for destGUID,destData in pairs(sourceData) do
						for destReact,destReactData in pairs(destData) do
							local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(destReact)
							if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
								if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
									for spellID,spellSegments in pairs(destReactData) do
										local sourceHeal, destPos = HealingTab_UpdateLines_GetUnit(heal,graph,spellID,destGUID,"spell",owner and "pet")
									
										for segment,spellAmount in pairs(spellSegments) do
											if CurrentFight.segments[segment].e then
												if spellID == 98021 and not HealingTab_Variables.ShowOverheal then	--Spirit Link
													spellAmount = HealingTab_Variables.NULLSpellAmount
												end
											
												sourceHeal.eff = sourceHeal.eff + spellAmount.amount - spellAmount.over + spellAmount.absorbed	--ef
												sourceHeal.total = sourceHeal.total + spellAmount.amount + spellAmount.absorbed						--total
												sourceHeal.overheal = sourceHeal.overheal + spellAmount.over 							--overheal
												sourceHeal.absorbed = sourceHeal.absorbed + spellAmount.absorbed 						--absorbed
												sourceHeal.count = sourceHeal.count + spellAmount.count 						--count
												sourceHeal.crit = sourceHeal.crit + spellAmount.crit 							--crit
												sourceHeal.critcount = sourceHeal.critcount + spellAmount.critcount						--crit-count
												sourceHeal.critmax = max(sourceHeal.critmax,spellAmount.critmax)						--crit-max
												sourceHeal.hitmax = max(sourceHeal.hitmax,spellAmount.hitmax)						--hit-max
												sourceHeal.critover = sourceHeal.critover + spellAmount.critover						--crit overheal
												sourceHeal.absorbs = sourceHeal.absorbs + spellAmount.absorbs						--absorbs
												total = total + spellAmount.amount - spellAmount.over + spellAmount.absorbed
												totalOver = totalOver + spellAmount.over
												
												destPos[2] = destPos[2] + spellAmount.amount + spellAmount.absorbed + (HealingTab_Variables.ShowOverheal and 0 or -spellAmount.over)
		
												if not graph[ spellID ][segment] then
													graph[ spellID ][segment] = 0
												end
												if not graph[ -1 ][segment] then
													graph[ -1 ][segment] = 0
												end
												local healCount = spellAmount.amount - (HealingTab_Variables.ShowOverheal and 0 or spellAmount.over) + spellAmount.absorbed
												
												graph[ spellID ][segment] = graph[ spellID ][segment] + healCount
												graph[ -1 ][segment] = graph[ -1 ][segment] + healCount
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if doReduction and not doEnemy then
			for destGUID,destData in pairs(CurrentFight.reduction) do
				if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellData in pairs(sourceData) do
							for reductorGUID,reductorData in pairs(spellData) do
								local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
								if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
									local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[reductorGUID])
									if isFriendly then
										for reductionSpellID,spellSegments in pairs(reductorData) do
											local sourceHeal, destPos = HealingTab_UpdateLines_GetUnit(heal,graph,reductionSpellID,destGUID,"spell",owner and "pet")
										
											for segment,reductionSpellAmount in pairs(spellSegments) do
												if CurrentFight.segments[segment].e then
													sourceHeal.eff = sourceHeal.eff + reductionSpellAmount
													sourceHeal.total = sourceHeal.total + reductionSpellAmount
													if not onlyReduction then
														sourceHeal.absorbs = sourceHeal.absorbs + reductionSpellAmount
													end
													total = total + reductionSpellAmount
													destPos[2] = destPos[2] + reductionSpellAmount
																									
													if not graph[ reductionSpellID ][segment] then
														graph[ reductionSpellID ][segment] = 0
													end
													if not graph[ -1 ][segment] then
														graph[ -1 ][segment] = 0
													end
													graph[ reductionSpellID ][segment] = graph[ reductionSpellID ][segment] + reductionSpellAmount
													graph[ -1 ][segment] = graph[ -1 ][segment] + reductionSpellAmount
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
			if HealingTab_Variables.ShowOverheal and onlyReduction then
				local missData = {}
				local avgDamage = {}
				for destGUID,destData in pairs(CurrentFight.damage) do
					for destReaction,destReactData in pairs(destData) do
						for sourceGUID,sourceData in pairs(destReactData) do
							local avgData = avgDamage[sourceGUID]
							if not avgData then
								avgData = {}
								avgDamage[sourceGUID] = avgData
							end
							for spellID,spellSegments in pairs(sourceData) do
								local avgSpell = avgData[spellID]
								if not avgSpell then
									avgSpell = {0,0}
									avgData[spellID] = avgSpell
								end
								for segment,spellAmount in pairs(spellSegments) do							
									avgSpell[1] = avgSpell[1] + spellAmount.count
									avgSpell[2] = avgSpell[2] + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
									
									if spellAmount.parry > 0 or spellAmount.dodge > 0 or spellAmount.miss > 0 then
										local missDestData = missData[destGUID]
										if not missDestData then
											missDestData = {}
											missData[destGUID] = missDestData
										end
										local missSpell = missDestData[sourceGUID]
										if not missSpell then
											missSpell = {}
											missDestData[sourceGUID] = missSpell
										end
										local missSpellData = missSpell[spellID]
										if not missSpellData then
											missSpellData = {
												parry = 0,
												dodge = 0,
												miss = 0,
												parry_target = 0,
												dodge_target = 0,
												miss_target = 0,
												segments = {},
											}
											missSpell[spellID] = missSpellData
										end
										missSpellData.parry = missSpellData.parry+spellAmount.parry
										missSpellData.dodge = missSpellData.dodge+spellAmount.dodge
										missSpellData.miss = missSpellData.miss+spellAmount.miss
										
										if CurrentFight.segments[segment].e then
											missSpellData.parry_target = missSpellData.parry_target+spellAmount.parry
											missSpellData.dodge_target = missSpellData.dodge_target+spellAmount.dodge
											missSpellData.miss_target = missSpellData.miss_target+spellAmount.miss
											missSpellData.segments[#missSpellData.segments+1] = segment
										end
									end
								end
							end
						end
					end
				end
				local reductionMissToSpell = {
					dodge = 81,
					parry = 82243,
					miss = 154592,
				}
				for destGUID,destData in pairs(missData) do
					local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[destGUID] or 0)
					if isFriendly and (ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[destGUID]) then
						for sourceGUID,sourceData in pairs(destData) do
							for spellID,spellAmount in pairs(sourceData) do
								local avgData = avgDamage[ sourceGUID ][ spellID ]
								local avg = avgData[3]
								if not avg then
									if avgData[1] > 0 then
										avg = avgData[2] / avgData[1]
									else
										avg = 0
									end
									avgData[3] = avg
								end
								if avg > 0 then
									for reductionName,reductionSpellID in pairs(reductionMissToSpell) do
										if spellAmount[reductionName] > 0 then
											local sourceHeal, destPos = HealingTab_UpdateLines_GetUnit(heal,graph,reductionSpellID,destGUID,"spell")
										
											local fromSpellPos = ExRT.F.table_find(sourceHeal.from,spellID,1)
											if not fromSpellPos then
												fromSpellPos = #sourceHeal.from + 1
												sourceHeal.from[fromSpellPos] = {spellID,0}
											end
											fromSpellPos = sourceHeal.from[fromSpellPos]
										
											local amount = avg * spellAmount[reductionName.."_target"]
										
											sourceHeal.eff = sourceHeal.eff + amount
											sourceHeal.total = sourceHeal.total + amount
											sourceHeal.absorbs = sourceHeal.absorbs + amount
											total = total + amount
											destPos[2] = destPos[2] + amount
											fromSpellPos[2] = fromSpellPos[2] + amount
											
											for i=1,#spellAmount.segments do
												local segment = spellAmount.segments[i]
												if not graph[ reductionSpellID ] then
													graph[ reductionSpellID ] = {}
												end
												if not graph[ reductionSpellID ][segment] then
													graph[ reductionSpellID ][segment] = 0
												end
												if not graph[ -1 ][segment] then
													graph[ -1 ][segment] = 0
												end
												graph[ reductionSpellID ][segment] = graph[ reductionSpellID ][segment] + amount
												graph[ -1 ][segment] = graph[ -1 ][segment] + amount
											end
										end
									end
								end
							end
						end
					end
				end
			end			
			
		end
		if not onlyReduction then
			for _,healData in pairs(heal) do
				for sourceGUID,sourceData in pairs(CurrentFight.healFrom) do
					for destGUID,destData in pairs(sourceData) do
						local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[destGUID])
						if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								for spellID,spellData in pairs(destData) do
									if healData.spell == spellID then
										for fromSpellID,fromSpellSegments in pairs(spellData) do
											for segment,fromSpellAmount in pairs(fromSpellSegments) do
												if CurrentFight.segments[segment].e then
										
													local destPos = ExRT.F.table_find(healData.from,fromSpellID,1)
													if not destPos then
														destPos = #healData.from + 1
														healData.from[destPos] = {fromSpellID,0}
													end
													destPos = healData.from[destPos]
													
													destPos[2] = destPos[2] + fromSpellAmount
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		if HealingTab_Variables.ShowOverheal then
			total = total + totalOver
			sort(heal,function(a,b) return a.total>b.total end)
			_max = heal[1] and heal[1].total or 0
		else
			sort(heal,function(a,b) return a.eff>b.eff end)
			_max = heal[1] and heal[1].eff or 0
		end
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			total = total,
			num = total,
			max = total,
			dps = total / activeFightLength,
			spellID = -1,
			alpha = HealingTab_Variables.ShowOverheal and totalOver,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		_max = max(_max,1)
		local castsCount = SpellsPage_GetCastsNumber(ExRT.F.table_len(HsourceVar) > 0 and HsourceVar,ExRT.F.table_len(HdestVar) > 0 and HdestVar)
		for i=1,#heal do
			local healLine = heal[i]
			local isPetAbility = healLine.info == "pet"
			local spellID = healLine.spell
			local isHoT = (not ExRT.isClassic) and spellID < 0
			if isHoT then
				spellID = -spellID
			end
			local spellName,_,spellIcon = GetSpellInfo(spellID)
			local defSpellName = spellName
			if isPetAbility then
				spellName = L.BossWatcherPetText..": "..spellName
			end
			if isHoT then
				spellName = spellName .. " ["..L.BossWatcherHoT.."]"
			end
			local school = module.db.spellsSchool[ spellID ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherHealTooltipCount,healLine.count},
				{L.BossWatcherHealTooltipHitMax,floor(healLine.hitmax)},
				{L.BossWatcherHealTooltipHitMid,ExRT.F.Round(max(healLine.total-healLine.crit-(healLine.overheal-healLine.critover),0)/max(healLine.count-healLine.critcount,1))},
				{L.BossWatcherHealTooltipCritCount,format("%d (%.1f%%)",healLine.critcount,healLine.critcount/max(1,healLine.count)*100)},
				{L.BossWatcherHealTooltipCritAmount,ExRT.F.shortNumber(healLine.crit-healLine.critover)},
				{L.BossWatcherHealTooltipCritMax,healLine.critmax},
				{L.BossWatcherHealTooltipCritMid,ExRT.F.Round((healLine.crit-healLine.critover)/max(healLine.critcount,1))},
				{L.BossWatcherHealTooltipOver,format("%s (%.1f%%)",ExRT.F.shortNumber(healLine.overheal),healLine.overheal/max(healLine.total,1)*100)},
				{L.BossWatcherHealTooltipAbsorbed,ExRT.F.shortNumber(healLine.absorbed)},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(healLine.total)},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			local casts = castsCount[ spellID ] or castsCount[ defSpellName ]
			if casts then
				tinsert(tooltipData,2,{L.BossWatcherDamageTooltipCastsCount,casts})
				tinsert(tooltipData,3,{L.BossWatcherPerCast,ExRT.F.shortNumber(healLine.eff / casts)})				
			end
			
			sort(healLine.targets,DamageTab_Temp_SortingBy2Param)
			if #healLine.targets > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#healLine.targets) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(healLine.targets[j][1]),20)..GUIDtoText(" [%s]",healLine.targets[j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(healLine.targets[j][2]),min(healLine.targets[j][2] / max(1,healLine.eff+(HealingTab_Variables.ShowOverheal and healLine.overheal or 0))*100,100))}
			end
			
			sort(healLine.from,DamageTab_Temp_SortingBy2Param)
			if #healLine.from > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherFromSpells," "}
			end
			for j=1,min(5,#healLine.from) do
				local spellName,_,spellTexture = GetSpellInfo(healLine.from[j][1])
				tooltipData[#tooltipData + 1] = {(spellTexture and "|T"..spellTexture..":0|t" or "")..(spellName or "spell:"..spellID),ExRT.F.shortNumber(healLine.from[j][2])}
			end
			
			local currHealing = healLine.eff+(HealingTab_Variables.ShowOverheal and healLine.overheal or 0)
			local hps = currHealing/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = spellIcon,
				name = spellName,
				total = total,
				num = currHealing,
				alpha = (HealingTab_Variables.ShowOverheal and not onlyReduction) and healLine.overheal or healLine.absorbs,
				max = _max,
				dps = hps,
				spellID = spellID,
				tooltip = tooltipData,
				school = school,
				isDoT = isHoT,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..(isPetAbility and L.BossWatcherPetText..": " or "")..GetSpellLink(spellID).." - "..ExRT.F.shortNumber(currHealing).."@1@ ("..floor(hps)..")@1#"
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		HealingTab_Variables.graphCache = {graph,#CurrentFight.segments,heal,true}
		if BWInterfaceFrame.GraphFrame:IsShown() then
			HealingTab_ReloadGraph(graph,#CurrentFight.segments,heal,true)
		end
	end


	local function HealingTab_UpdateLinesFromSpells()
		HealingTab_UpdateDropDowns()
		HealingTab_UpdateChecks()
		
		local doEnemy = nil
		
		local heal = {}
		local total = 0
		local graph = {[-1]={}}
		for sourceGUID,sourceData in pairs(CurrentFight.healFrom) do
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
				for destGUID,destData in pairs(sourceData) do
					local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[destGUID])
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							for spellID,spellData in pairs(destData) do
								for fromSpellID,fromSpellSegments in pairs(spellData) do
									local inDamagePos = ExRT.F.table_find(heal,fromSpellID,1)
									if not inDamagePos then
										inDamagePos = #heal + 1
										heal[inDamagePos] = {fromSpellID,0,{},{},spell=fromSpellID}
									end
									local destPos = ExRT.F.table_find(heal[inDamagePos][3],destGUID,1)
									if not destPos then
										destPos = #heal[inDamagePos][3] + 1
										heal[inDamagePos][3][destPos] = {destGUID,0}
									end
									destPos = heal[inDamagePos][3][destPos]
									
									local sourcePos = ExRT.F.table_find(heal[inDamagePos][4],sourceGUID,1)
									if not sourcePos then
										sourcePos = #heal[inDamagePos][4] + 1
										heal[inDamagePos][4][sourcePos] = {sourceGUID,0}
									end
									sourcePos = heal[inDamagePos][4][sourcePos]
									
									if not graph[ fromSpellID ] then
										graph[ fromSpellID ] = {}
									end
							
									for segment,fromSpellAmount in pairs(fromSpellSegments) do
										if CurrentFight.segments[segment].e then
											heal[inDamagePos][2] = heal[inDamagePos][2] + fromSpellAmount
											total = total + fromSpellAmount
											destPos[2] = destPos[2] + fromSpellAmount
											sourcePos[2] = sourcePos[2] + fromSpellAmount
											
											if not graph[ fromSpellID ][segment] then
												graph[ fromSpellID ][segment] = 0
											end
											if not graph[ -1 ][segment] then
												graph[ -1 ][segment] = 0
											end
	
											graph[ fromSpellID ][segment] = graph[ fromSpellID ][segment] + fromSpellAmount
											graph[ -1 ][segment] = graph[ -1 ][segment] + fromSpellAmount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		do
			local hps = total / activeFightLength
			reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(hps)..")@1#"
			sort(heal,function(a,b) return a[2]>b[2] end)
			_max = heal[1] and heal[1][2] or 0
			HealingTab_SetLine({
				line = 1,
				name = L.BossWatcherReportTotal,
				num = total,
				total = total,
				max = total,
				dps = hps,
				spellID = -1,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = true,
			})
		end
		for i=1,#heal do
			local spellName,_,spellIcon = GetSpellInfo(heal[i][1])
			local school = module.db.spellsSchool[ heal[i][1] ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(heal[i][2])},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			sort(heal[i][3],DamageTab_Temp_SortingBy2Param)
			if #heal[i][3] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#heal[i][3]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][3][j][1]),20)..GUIDtoText(" [%s]",heal[i][3][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][3][j][2]),min(heal[i][3][j][2] / max(1,heal[i][2])*100,100))}
			end
			sort(heal[i][4],DamageTab_Temp_SortingBy2Param)
			if #heal[i][4] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipSources," "}
			end
			for j=1,min(5,#heal[i][4]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][4][j][1]),20)..GUIDtoText(" [%s]",heal[i][4][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][4][j][2]),min(heal[i][4][j][2] / max(1,heal[i][2])*100,100))}
			end
			do
				local hps = heal[i][2]/activeFightLength
				HealingTab_SetLine({
					line = i+1,
					icon = spellIcon,
					name = spellName,
					total = total,
					num = heal[i][2],
					max = _max,
					dps = hps,
					spellID = heal[i][1],
					tooltip = tooltipData,
					school = school,
					check = BWInterfaceFrame.GraphFrame:IsShown(),
					checkState = i <= 3,
				})
				reportData[2][#reportData[2]+1] = i..". "..GetSpellLink(heal[i][1]).." - "..ExRT.F.shortNumber(heal[i][2]).."@1@ ("..floor(hps)..")@1#"
			end
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		HealingTab_Variables.graphCache = {graph,#CurrentFight.segments,heal,true}
		if BWInterfaceFrame.GraphFrame:IsShown() then
			HealingTab_ReloadGraph(graph,#CurrentFight.segments,heal,true)
		end
	end
	
	
	local function HealingTab_SelectDropDownSource(self,arg)
		ELib:DropDownClose()
		local Back_destVar = ExRT.F.table_copy2(HdestVar)
		local Back_sourceVar = ExRT.F.table_copy2(HsourceVar)
		wipe(HsourceVar)
		if arg then
			HsourceVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = CurrentFight.guids[arg]
				if name then
					for GUID,GUIDname in pairs(CurrentFight.guids) do
						if GUIDname == name then
							HsourceVar[GUID] = true
						end
					end
				end
			end
		end
		HealingTab_UpdatePage()
	end
	local function HealingTab_SelectDropDownDest(self,arg)
		ELib:DropDownClose()
		local Back_destVar = ExRT.F.table_copy2(HdestVar)
		local Back_sourceVar = ExRT.F.table_copy2(HsourceVar)
		wipe(HdestVar)
		if arg then
			HdestVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = CurrentFight.guids[arg]
				if name then
					for GUID,GUIDname in pairs(CurrentFight.guids) do
						if GUIDname == name then
							HdestVar[GUID] = true
						end
					end
				end
			end
		end
		HealingTab_UpdatePage()
	end
	
	local function HealingTab_SelectDropDown_OptionTanks(_,destTable,onlyTanks)
		ELib:DropDownClose()
		local Back_destVar = ExRT.F.table_copy2(HdestVar)
		local Back_sourceVar = ExRT.F.table_copy2(HsourceVar)
		wipe(HdestVar)
		for i=1,#destTable do
			local isTank
			if CurrentFight.other.rolesGUID[ destTable[i][1] ] == "TANK" then
				isTank = true
			end
			if (isTank and onlyTanks) or (not isTank and not onlyTanks) then
				HdestVar[ destTable[i][1] ] = true
			end
		end
		HealingTab_UpdatePage()
	end
	
	local function HealingTab_CheckDropDownSource(self,checked)
		if checked then
			HsourceVar[self.arg1] = true
		else
			HsourceVar[self.arg1] = nil
		end
		HealingTab_UpdatePage()
	end
	local function HealingTab_CheckDropDownDest(self,checked)
		if checked then
			HdestVar[self.arg1] = true
		else
			HdestVar[self.arg1] = nil
		end
		HealingTab_UpdatePage()
	end

	local function HealingTab_HPS(disableUpdateVars)
		local doEnemy = not HealingTab_Variables.state_friendly
		
		local sourceTable = {}
		local destTable = {}
		for sourceGUID,sourceData in pairs(CurrentFight.heal) do	
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			for destGUID,destData in pairs(sourceData) do
				for destReact,destReactData in pairs(destData) do
					local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(destReact)
					if (isFriendly and not doEnemy) or (not isFriendly and doEnemy) then
						for spellID,spellSegments in pairs(destReactData) do
							for segment,spellAmount in pairs(spellSegments) do
								if CurrentFight.segments[segment].e then
									if not ExRT.F.table_find(destTable,destGUID,1) then
										destTable[#destTable + 1] = {destGUID,GetGUID(destGUID)}
									end
									if not ExRT.F.table_find(sourceTable,sourceGUID,1) then
										sourceTable[#sourceTable + 1] = {sourceGUID,GetGUID(sourceGUID)}
									end
								end
							end
						end
					end
				end
			end
		end
		sort(sourceTable,function(a,b) return a[2]<b[2] end)
		sort(destTable,function(a,b) return a[2]<b[2] end)
		wipe(BWInterfaceFrame.tab.tabs[2].sourceDropDown.List)
		wipe(BWInterfaceFrame.tab.tabs[2].targetDropDown.List)
		BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownSource,padding = 16}
		BWInterfaceFrame.tab.tabs[2].targetDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownDest,padding = 16}
		for i=1,#sourceTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[i+1] = {
				text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
				arg1 = sourceTable[i][1],
				func = HealingTab_SelectDropDownSource,
				checkFunc = HealingTab_CheckDropDownSource,
				checkable = true,
			}
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].targetDropDown.List[i+1] = {
				text = classColor..destTable[i][2]..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				func = HealingTab_SelectDropDownDest,
				checkFunc = HealingTab_CheckDropDownDest,
				checkable = true,
			}
		end
		tinsert(BWInterfaceFrame.tab.tabs[2].targetDropDown.List,2,{
			text = L.BossWatcherHealToTanks,
			padding = 16,
			func = HealingTab_SelectDropDown_OptionTanks,
			arg1 = destTable,
			arg2 = true,
		})
		tinsert(BWInterfaceFrame.tab.tabs[2].targetDropDown.List,2,{
			text = L.BossWatcherHealToNonTanks,
			padding = 16,
			func = HealingTab_SelectDropDown_OptionTanks,
			arg1 = destTable,
			arg2 = false,
		})
		if not disableUpdateVars then
			wipe(HsourceVar)
			wipe(HdestVar)
		end
	end
	
	local function HealingTab_RPS(disableUpdateVars)		
		local sourceTable = {}
		local destTable = {}
		for destGUID,destData in pairs(CurrentFight.reduction) do	
			for sourceGUID,sourceData in pairs(destData) do
				for spellID,spellData in pairs(sourceData) do
					for reductorGUID,reductorData in pairs(spellData) do
						local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
						if owner then
							reductorGUID = owner
						end
						local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[reductorGUID])
						if isFriendly then
							for spellID,spellSegments in pairs(reductorData) do
								for segment,spellAmount in pairs(spellSegments) do
									if CurrentFight.segments[segment].e then
										if not ExRT.F.table_find(destTable,destGUID,1) then
											destTable[#destTable + 1] = {destGUID,GetGUID(destGUID)}
										end
										if not ExRT.F.table_find(sourceTable,reductorGUID,1) then
											sourceTable[#sourceTable + 1] = {reductorGUID,GetGUID(reductorGUID)}
										end
									end
								end
							end
						end
					end
				end
			end
		end
		sort(sourceTable,function(a,b) return a[2]<b[2] end)
		sort(destTable,function(a,b) return a[2]<b[2] end)
		wipe(BWInterfaceFrame.tab.tabs[2].sourceDropDown.List)
		wipe(BWInterfaceFrame.tab.tabs[2].targetDropDown.List)
		BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownSource,padding = 16}
		BWInterfaceFrame.tab.tabs[2].targetDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownDest,padding = 16}
		for i=1,#sourceTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[i+1] = {
				text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
				arg1 = sourceTable[i][1],
				func = HealingTab_SelectDropDownSource,
				checkFunc = HealingTab_CheckDropDownSource,
				checkable = true,
			}
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].targetDropDown.List[i+1] = {
				text = classColor..destTable[i][2]..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				func = HealingTab_SelectDropDownDest,
				checkFunc = HealingTab_CheckDropDownDest,
				checkable = true,
			}
		end
		if not disableUpdateVars then
			wipe(HsourceVar)
			wipe(HdestVar)	
		end
	end

	function HealingTab_UpdatePage(updateLists,midFunc,disableUpdateVars)
		if HealingTab_Variables.state_mitigation then
			BWInterfaceFrame.tab.tabs[2].showOverhealChk:Tooltip(""):SetText("|cffffffff"..STAT_DODGE.." / "..STAT_PARRY.." / "..ACTION_SPELL_MISSED_IMMUNE)
			
		else
			BWInterfaceFrame.tab.tabs[2].showOverhealChk:Tooltip(L.BossWatcherHealShowOver):SetText("|cffffffff"..L.BossWatcherOverhealing)
		end
		if updateLists then
			if not HealingTab_Variables.state_mitigation then
				HealingTab_HPS(disableUpdateVars)
			else
				HealingTab_RPS(disableUpdateVars)
			end
		end
		if midFunc then
			midFunc()
		end
		if IsAltKeyDown() then
			HealingTab_UpdateLinesFromSpells()
		elseif not HealingTab_Variables.state_spells then
			HealingTab_UpdateLinesPlayers()
		else
			HealingTab_UpdateLinesSpell()
		end
	end
	

	tab.chkFriendly = ELib:Radio(tab,L.BossWatcherFriendly,true):Point(15,-50):AddButton():OnClick(function(self) 
		HealingTab_Variables.state_friendly = true
		HealingTab_Variables.state_mitigation = false
		BWInterfaceFrame.tab.tabs[2].chkEnemy:SetChecked(false)
		BWInterfaceFrame.tab.tabs[2].chkMitigation:SetChecked(false)
		self:SetChecked(true)
		
		HealingTab_UpdatePage(true)
	end)
	tab.chkEnemy = ELib:Radio(tab,L.BossWatcherHostile):Point(15,-65):AddButton():OnClick(function(self) 
		HealingTab_Variables.state_friendly = false
		HealingTab_Variables.state_mitigation = false
		BWInterfaceFrame.tab.tabs[2].chkFriendly:SetChecked(false)
		BWInterfaceFrame.tab.tabs[2].chkMitigation:SetChecked(false)
		self:SetChecked(true)
		
		HealingTab_UpdatePage(true)
	end)
	tab.chkMitigation = ELib:Radio(tab,L.BossWatcherHealReduction):Point(15,-80):AddButton():OnClick(function(self) 
		HealingTab_Variables.state_friendly = true
		HealingTab_Variables.state_mitigation = true
		BWInterfaceFrame.tab.tabs[2].chkFriendly:SetChecked(false)
		BWInterfaceFrame.tab.tabs[2].chkEnemy:SetChecked(false)
		self:SetChecked(true)
		
		HealingTab_UpdatePage(true)
	end)
	
	tab.bySource = ELib:Radio(tab,L.BossWatcherBySource,true):Point(200,-50):AddButton():OnClick(function(self) 
		HealingTab_Variables.state_byTarget = false
		HealingTab_Variables.state_spells = false
		BWInterfaceFrame.tab.tabs[2].byTarget:SetChecked(false)
		BWInterfaceFrame.tab.tabs[2].bySpell:SetChecked(false)
		self:SetChecked(true)
		
		HealingTab_UpdatePage(true)
	end)
	tab.byTarget = ELib:Radio(tab,L.BossWatcherByTarget):Point(200,-65):AddButton():OnClick(function(self) 
		HealingTab_Variables.state_byTarget = true
		HealingTab_Variables.state_spells = false
		BWInterfaceFrame.tab.tabs[2].bySource:SetChecked(false)
		BWInterfaceFrame.tab.tabs[2].bySpell:SetChecked(false)
		self:SetChecked(true)
		
		HealingTab_UpdatePage(true)
	end)
	tab.bySpell = ELib:Radio(tab,L.BossWatcherBySpell):Point(200,-80):AddButton():OnClick(function(self) 
		HealingTab_Variables.state_byTarget = false
		HealingTab_Variables.state_spells = true
		BWInterfaceFrame.tab.tabs[2].bySource:SetChecked(false)
		BWInterfaceFrame.tab.tabs[2].byTarget:SetChecked(false)
		self:SetChecked(true)
		
		HealingTab_UpdatePage(true)
	end)
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(195):Point(430,-50):SetText(L.BossWatcherAll)
	tab.sourceText = ELib:Text(tab,L.BossWatcherSource..":",12):Size(100,20):Point("TOPRIGHT",tab.sourceDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()

	tab.targetDropDown = ELib:DropDown(tab,250,20):Size(195):Point(430,-75):SetText(L.BossWatcherAll)
	tab.targetText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.targetDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	
	function tab.sourceDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = HsourceVar[self.List[i].arg1]
		end
	end
	function tab.targetDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = HdestVar[self.List[i].arg1]
		end
	end
	
	tab.showOverhealChk = ELib:Check(tab,"|cffffffff"..L.BossWatcherOverhealing):Point(650,-50):Tooltip(L.BossWatcherHealShowOver):OnClick(function (self)
		if self:GetChecked() then
			HealingTab_Variables.ShowOverheal = true
		else
			HealingTab_Variables.ShowOverheal = false
		end
		HealingTab_UpdatePage()
	end)
	tab.showOverhealChk.text:SetPoint("RIGHT",BWInterfaceFrame,-5,0)
	tab.showOverhealChk.text:SetJustifyH("LEFT")
	
	tab.showGraphChk = ELib:Check(tab,"|cffffffff"..L.BossWatcherTabGraphics.." ",VExRT.BossWatcher.optionsHealingGraph):Point(650,-75):OnClick(function (self)
		local tab2 = BWInterfaceFrame.tab.tabs[2]
		if self:GetChecked() then
			tab2.scroll:Point("TOP",0,-305)
			BWInterfaceFrame.GraphFrame:Show()
		else
			tab2.scroll:Point("TOP",0,-100)
			BWInterfaceFrame.GraphFrame:Hide()
		end
		VExRT.BossWatcher.optionsHealingGraph = self:GetChecked()
		if HealingTab_Variables.graphCache then
			HealingTab_ReloadGraph(unpack(HealingTab_Variables.graphCache))
		end
	end)
	
	tab.scroll = ELib:ScrollFrame(tab):Point("TOP",0,VExRT.BossWatcher.optionsHealingGraph and -305 or -100):Point("BOTTOM",0,10):Height(600)
	tab.scroll:SetWidth(835)
	tab.scroll.C:SetWidth(835)
	tab.lines = {}
	
	local function HealingTab_RightClick_BackFunction()
		if not HealingTab_Variables.Back_state then
			HealingTab_UpdatePage(true)
			return
		end
		HealingTab_Variables.state_friendly = HealingTab_Variables.Back_state[1]
		HealingTab_Variables.state_spells = HealingTab_Variables.Back_state[2]
		HealingTab_Variables.state_mitigation = HealingTab_Variables.Back_state[3]
		HealingTab_Variables.state_byTarget = HealingTab_Variables.Back_state[4]
		
		HealingTab_UpdatePage(true,function()
			HsourceVar = HealingTab_Variables.Back_state[5]
			HdestVar = HealingTab_Variables.Back_state[6]
		end)
		HealingTab_Variables.Back_state = nil
	end
	
	tab.scroll:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			HealingTab_RightClick_BackFunction()
		end
	end)
	
	local function HealingTab_Line_Check_OnClick(self)
		local spellID = self:GetParent().spellID or self:GetParent().sourceGUID
		if not spellID then
			return
		end
		if self:GetParent().isDoT and type(spellID) == 'number' then
			spellID = -spellID
		end
		local graphData = BWInterfaceFrame.GraphFrame.G.data
		local findPos = ExRT.F.table_find(graphData,spellID,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = not self:GetChecked()
		end
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	local function HealingTab_Line_OnClick(self,button)
		if button == "RightButton" then
			HealingTab_RightClick_BackFunction()
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if (self.check and self.check:IsShown() or (self:GetParent().check and self:GetParent().check:IsShown())) and x <= 30 then
			return
		end
		local GUID = self.sourceGUID
		local tooltip = self.spellLink
		
		local parent = self:GetParent()
		if parent.isMain then
			GUID = parent.sourceGUID
			tooltip = parent.spellLink
		end
		if parent.isMain and IsShiftKeyDown() and tooltip and tooltip:find("spell:") then
			local spellID = tooltip:match("%d+")
			if spellID then
				ExRT.F.LinkSpell(spellID)
				return
			end
		end
		if GUID then
			if not HealingTab_Variables.state_spells then
				HealingTab_Variables.Back_state = {
					HealingTab_Variables.state_friendly,
					HealingTab_Variables.state_spells,
					HealingTab_Variables.state_mitigation,
					HealingTab_Variables.state_byTarget,
					ExRT.F.table_copy2(HsourceVar),
					ExRT.F.table_copy2(HdestVar),
				}
				HealingTab_Variables.state_spells = true
				HealingTab_UpdatePage(true,function()
					if HealingTab_Variables.state_byTarget then
						wipe(HdestVar)
						HdestVar[GUID] = true
					else
						wipe(HsourceVar)
						HsourceVar[GUID] = true
					end
				end,true)
			end
		end
	end
	local function HealingTab_LineOnEnter(self)
		if self.tooltip then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			local firstLine = self.tooltip[1]
			if type(firstLine) == "table" then
				firstLine = (firstLine[2] and "|T"..firstLine[2]..":18|t " or "")..firstLine[1]
			end
			GameTooltip:SetText(firstLine)
			for i=2,#self.tooltip do
				if type(self.tooltip[i]) == "table" then
					GameTooltip:AddDoubleLine(self.tooltip[i][1],self.tooltip[i][2],1,1,1,1,1,1,1,1)
				else
					GameTooltip:AddLine(self.tooltip[i])
				end
			end
			GameTooltip:Show()
		end
	end
	local function HealingTab_Line_OnEnter(self)
		local parent = self:GetParent()
		if parent.spellLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(parent.spellLink)
			GameTooltip:Show()
		elseif parent.name:IsTruncated() then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			GameTooltip:SetText(parent.name:GetText())
			GameTooltip:Show()	
		elseif parent.tooltip then
			HealingTab_LineOnEnter(parent)
		end
	end
	function HealingTab_SetLine(dataTable)
		local i,icon,name,overall_num,overall,total,dps,class,sourceGUID,doEnemy,spellLink,tooltip,school,overall_black,isDoT
		local showCheck,checkState,spellID

		i = dataTable.line
		icon = dataTable.icon or ""
		name = dataTable.name
		total = dataTable.num
		overall_num = dataTable.num / max(dataTable.total,1)
		overall = dataTable.num / max(dataTable.max,1)
		if dataTable.alpha then
			overall_black = dataTable.alpha / max(dataTable.num,1)
		end
		dps = dataTable.dps
		class = dataTable.class
		sourceGUID = dataTable.sourceGUID
		doEnemy = dataTable.doEnemy
		if dataTable.spellID and dataTable.spellID ~= -1 then
			spellLink = "spell:"..dataTable.spellID
		end
		tooltip = dataTable.tooltip
		school = dataTable.school
		isDoT = dataTable.isDoT
		showCheck = dataTable.check
		checkState = dataTable.checkState
		spellID = dataTable.spellID

		if not BWInterfaceFrame.tab.tabs[2].lines[i] then
			local line = CreateFrame("Button",nil,BWInterfaceFrame.tab.tabs[2].scroll.C)
			BWInterfaceFrame.tab.tabs[2].lines[i] = line
			line:SetSize(815,20)
			line:SetPoint("TOPLEFT",0,-(i-1)*20)
			
			line.leftSide = CreateFrame("Frame",nil,line)
			line.leftSide:SetSize(1,20)
			line.leftSide:SetPoint("LEFT",5,0)
			
			line.check = ELib:Check(line,""):Point("TOPLEFT",5,-2)
			line.check:SetSize(16,16)
			line.check:SetScript("OnClick",HealingTab_Line_Check_OnClick)
			
			line.overall_num = ELib:Text(line,"45.76%",12):Size(70,20):Point(250,0):Right():Color():Shadow()

			line.icon = ELib:Icon(line,nil,18):Point("TOPLEFT",line.leftSide,0,-1)
			line.name = ELib:Text(line,"name",12):Size(0,20):Point("TOPLEFT",line.leftSide,25,0):Point("TOPRIGHT",line.overall_num,"TOPLEFT",0,0):Color():Shadow()
			line.name:SetMaxLines(1)
			
			line.name_tooltip = CreateFrame('Button',nil,line)
			line.name_tooltip:SetAllPoints(line.name)
			line.overall = line:CreateTexture(nil, "BACKGROUND")
			--line.overall:SetColorTexture(0.7, 0.1, 0.1, 1)
			line.overall:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24.tga")
			line.overall:SetSize(300,16)
			line.overall:SetPoint("TOPLEFT",325,-2)
			line.overall_black = line:CreateTexture(nil, "BACKGROUND")
			line.overall_black:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24b.tga")
			line.overall_black:SetSize(300,16)
			line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)

			line.total = ELib:Text(line,"125.46M",12):Size(95,20):Point(630,0):Color():Shadow()
			line.dps = ELib:Text(line,"34576.43",12):Size(100,20):Point(725,0):Color():Shadow()
			
			line.back = line:CreateTexture(nil, "BACKGROUND")
			line.back:SetAllPoints()
			if i%2==0 then
				line.back:SetColorTexture(0.3, 0.3, 0.3, 0.1)
			end
			line.name_tooltip:SetScript("OnClick",HealingTab_Line_OnClick)
			line.name_tooltip:SetScript("OnEnter",HealingTab_Line_OnEnter)
			line.name_tooltip:SetScript("OnLeave",GameTooltip_Hide)
			line:SetScript("OnClick",HealingTab_Line_OnClick)
			line:SetScript("OnEnter",HealingTab_LineOnEnter)
			line:SetScript("OnLeave",GameTooltip_Hide)
			line:RegisterForClicks("AnyUp")
			
			line.isMain = true
		end
		local line = BWInterfaceFrame.tab.tabs[2].lines[i]
		if type(icon) == "table" then
			line.icon.texture:SetTexture(icon[1] or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(unpack(icon,2,5))
		else
			line.icon.texture:SetTexture(icon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(0,1,0,1)
		end
		line.name:SetText(name or "")
		line.overall_num:SetFormattedText("%.2f%%",overall_num and overall_num * 100 or 0)
		if overall_black and overall_black > 0 then
			local width = 300*(overall or 1)
			local normal_width = width * (1 - overall_black)
			line.overall:SetWidth(max(normal_width,1))
			line.overall_black:SetWidth(max(width-normal_width,1))
			line.overall_black:Show()
			if normal_width == 0 then
				line.overall:Hide()
				line.overall_black:SetPoint("TOPLEFT",325,-2)
			else
				line.overall:Show()
				line.overall_black:ClearAllPoints()
				line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)
			end
		else
			line.overall:Show()
			line.overall_black:Hide()
			line.overall:SetWidth(max(300*(overall or 1),1))
		end
		line.total:SetText(total and ExRT.F.shortNumber(total) or "")
		do
			dps = dps or 0
			line.dps:SetFormattedText("%s.%s",FormatLargeNumber(floor(dps)),format("%.2f",dps % 1):gsub("^.-%.",""))
		end
		line.overall:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		line.overall_black:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		if class then
			local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			if classColorArray then
				line.overall:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
				line.overall_black:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
			else
				line.overall:SetVertexColor(0.8,0.8,0.8, 1)
				line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
			end
		else
			line.overall:SetVertexColor(0.8,0.8,0.8, 1)
			line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
		end
		if school then
			SetSchoolColorsToLine(line.overall,school)
			SetSchoolColorsToLine(line.overall_black,school)
		end
		if showCheck then
			line.leftSide:SetPoint("LEFT",25,0)
			line.check:SetChecked(checkState)
			line.check:Show()
		else
			line.leftSide:SetPoint("LEFT",5,0)
			line.check:Hide()
		end
		line.sourceGUID = sourceGUID
		line.spellID = spellID
		line.doEnemy = doEnemy
		line.spellLink = spellLink
		line.tooltip = tooltip
		line.isDoT = isDoT
		line:Show()
	end
	
	local function HealingTab_AddSpecialInfo(text)
		local infoFrame = BWInterfaceFrame.tab.tabs[2].specialInfoFrame
		if not text then
			if infoFrame then
				infoFrame:Hide()
			end
			return
		end
		if not infoFrame then
			local sframe = CreateFrame("Frame",nil,BWInterfaceFrame.tab.tabs[2].scroll)
			BWInterfaceFrame.tab.tabs[2].specialInfoFrame = sframe
			sframe:SetSize(24,24)
			sframe:SetPoint("CENTER",BWInterfaceFrame.tab.tabs[2].scroll,"TOPLEFT",0,0)
			
			sframe.text = ELib:Text(sframe,"?",22):Size(24,24):Point("CENTER",0,0):Center():Color():Shadow()
			sframe.text:SetShadowColor(0,0,0,0)
			
			local circle = sframe:CreateTexture(nil, "OVERLAY")
			circle:SetPoint("CENTER",-1,2)
			circle:SetSize(26,26)
			circle:SetTexture([[Interface\Addons\ExRT\media\radioModern]])
			circle:SetTexCoord(0,0.25,0,1)
			
			sframe:SetScript("OnEnter",function(self)
				self.text:SetShadowColor(1,1,1,1)
				ELib.Tooltip.Show(self,nil,self.tooltip)
			end)
			sframe:SetScript("OnLeave",function(self)
				self.text:SetShadowColor(1,1,1,0)
				ELib.Tooltip:Hide()
			end)
			
			infoFrame = sframe
		end
		infoFrame.tooltip = text
		infoFrame:Show()
	end
	
	
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.GraphFrame:SetPoint("TOP",0,-105)
		if BWInterfaceFrame.tab.tabs[2].showGraphChk:GetChecked() then
			BWInterfaceFrame.GraphFrame:Show()
		end
	
		BWInterfaceFrame.report:Show()
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			local currFightIDShort = GetFightID(CurrentFight,true)
			local disableUpdateVars = nil
			if currFightIDShort == self.lastFightShortID then
				disableUpdateVars = true
			end
			self.lastFightShortID = currFightIDShort
		
			HealingTab_Variables.graphCache = nil
			Graph_AutoUpdateStep()
			HealingTab_UpdatePage(true,nil,disableUpdateVars)
			self.lastFightID = BWInterfaceFrame.nowFightID
			
			HealingTab_AddSpecialInfo()
		elseif HealingTab_Variables.graphCache then
			HealingTab_ReloadGraph(unpack(HealingTab_Variables.graphCache))
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
		BWInterfaceFrame.GraphFrame:Hide()
	end)
	
	
	
	
	---- Death Tab
	tab = BWInterfaceFrame.tab.tabs[8]
	local deathTab = tab
	
	local DeathTab_Variables = {	--Use this because limit 200 local vars
		isEnemy = false,
		isBuffs = false,
		isDebuffs = false,
		isBlack = false,
		SetDeath_Last_Arg = nil,
		SetDeath_Last_Arg2 = nil,
		aurasBlackList = {
			[116956]=true,
			[167188]=true,
			[113742]=true,
			[6673]=true,
			[19740]=true,
			[109773]=true,
			[1126]=true,
			[21562]=true,
			[24907]=true,
			[166928]=true,
			[1459]=true,
			[93435]=true,
			[19506]=true,
			[167187]=true,
			[166916]=true,
			[166646]=true,
			[77747]=true,
			[67330]=true,
			[116781]=true,
			[24604]=true,
			[115921]=true,
			[51470]=true,
			[24932]=true,
			[117666]=true,
			[128432]=true,
			[155522]=true,
			[20217]=true,
			[469]=true,
			[57330]=true,
		}
	}
	
	local DeathTab_SetLine = nil
		
	local function DeathTab_ClearPage()
		for i=1,#deathTab.lines do
			deathTab.lines[i]:Hide()
		end
		deathTab.scroll:SetNewHeight(0)
		deathTab.sourceDropDown:SetText(L.BossWatcherSelect)
	end
	
	local function DeathTab_SetDeath(_,arg,arg2)
		DeathTab_Variables.SetDeath_Last_Arg = arg
		DeathTab_Variables.SetDeath_Last_Arg2 = arg2
		ELib:DropDownClose()
		DeathTab_ClearPage()
		deathTab.sourceDropDown:SetText( arg2 )
		local _data = CurrentFight.deathLog[arg]
		local data = {}
		local minTime,maxTime = _data[1][3]-20,_data[1][3]
		local GUID = _data[1][2]
		local deathTime = nil
		wipe(reportData[8])
		reportData[8][1] = date("%H:%M:%S",_data[1][3])..date(" %Mm%Ss",timestampToFightTime(_data[1][3])).." "..GetGUID(_data[1][2])
		for i=1,#_data do
			if _data[i][3] then
				_data[i].P = i
				data[#data + 1] = _data[i]
				minTime = min(minTime,_data[i][3])
			end
		end
		if DeathTab_Variables.isBuffs or DeathTab_Variables.isDebuffs then
			local DataDefLen = #_data
			for i,auraData in ipairs(CurrentFight.auras) do
				if auraData[3] == GUID and auraData[1] >= minTime and auraData[1] <= maxTime and ((DeathTab_Variables.isBuffs and auraData[7]=='BUFF') or (DeathTab_Variables.isDebuffs and auraData[7]=='DEBUFF')) and (not DeathTab_Variables.isBlack or not DeathTab_Variables.aurasBlackList[ auraData[6] ]) then
					data[#data + 1] = {4,auraData[2],auraData[1],auraData[6],auraData[8],P=(DataDefLen + i)}
				end
			end
			sort(data,function(a,b) if a[3]==b[3] then return a.P<b.P else return a[3]>b[3] end end)
		end
		for i=1,#data do
			if data[i][1] then
				local _time = timestampToFightTime(data[i][3])
				local diffTime = deathTime and format("%.2f",_time - deathTime) or ""
				if diffTime == "0.00" then diffTime = "-0.00" end
				local timeText = date("%M:%S.",_time)..format("%03d",_time * 1000 % 1000)..(diffTime~="" and "  " or "")..diffTime
				if data[i][1] == 3 then
					local text = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2]) .. " ".. L.BossWatcherDeathDeath
					
					DeathTab_SetLine(i,timeText,text,0,0,0)
					
					reportData[8][#reportData[8] + 1] = "-0.0s "..L.BossWatcherDeathDeath
					
					deathTime = _time
				elseif data[i][1] == 5 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][5])
					local text = format(GUILD_NEWS_FORMAT3,GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2]),"|T"..spellTexture..":0|t"..spellName)
					
					DeathTab_SetLine(i,timeText,text,0,0,0,data[i][5])
					
					reportData[8][#reportData[8] + 1] = "-0.0s "..spellName
					
					deathTime = _time
				elseif data[i][1] == 1 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][4])
					local name = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2])
					local overkill = data[i][6] and data[i][6] > 0 and " ("..L.BossWatcherDeathOverKill..":"..data[i][6]..")" or ""
					local blocked = data[i][8] and data[i][8] > 0 and " ("..L.BossWatcherDeathBlocked..":"..data[i][8]..")" or ""
					local absorbed = data[i][9] and data[i][9] > 0 and " ("..L.BossWatcherDeathAbsorbed..":"..data[i][9]..")" or ""
					local isCrit = data[i][10] and "*" or ""
					local school = " ("..GetSchoolName(data[i][7])..")"
					local amount = data[i][5] - (data[i][6] or 0)
					local HP = ""
					if data[i][12] and data[i][13]~=0 then
						HP = format("%d%% ",data[i][12]/data[i][13]*100)
						--HP = format("%d%% > %d%% ",min((data[i][12]+amount)/data[i][13],1)*100,data[i][12]/data[i][13]*100)
					end
					
					if ExRT.F.GetUnitTypeByGUID(data[i][2]) == 0 then
						name = "|c"..ExRT.F.classColorByGUID(data[i][2])..name.."|r"
					end
					
					local sourceMarker = module.db.raidTargets[ data[i][15] or 0 ]
					local destMarker = module.db.raidTargets[ data[i][16] or 0 ]
					
					local text = HP..(sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "")..name.." "..L.BossWatcherDeathDamage.." |T"..spellTexture..":0|t"..spellName.." "..L.BossWatcherDeathOn.." "..isCrit..amount..isCrit .. blocked .. absorbed .. overkill .. school
					
					DeathTab_SetLine(i,timeText,text,1,0,0,data[i][4])
					
					reportData[8][#reportData[8] + 1] = diffTime.."s."..HP.." -"..isCrit..amount..isCrit ..blocked .. absorbed .. overkill .." ["..GetGUID(data[i][2]).." - "..GetSpellLink(data[i][4]).."]"
				elseif data[i][1] == 2 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][4])
					local name = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2])
					local overheal = data[i][6] and data[i][6] > 0 and " ("..L.BossWatcherDeathOverHeal..":"..data[i][6]..")" or ""
					local absorbed = data[i][9] and data[i][9] > 0 and " ("..L.BossWatcherDeathAbsorbed..":"..data[i][9]..")" or ""
					local isCrit = data[i][10] and "*" or ""
					local school = " ("..GetSchoolName(data[i][7])..")"
					local amount = data[i][5] - (data[i][6] or 0)
					local HP = ""
					if data[i][12] and data[i][13]~=0 then
						HP = format("%d%% ",data[i][12]/data[i][13]*100)
						--if not data[i][14] then HP = format("%d%% > ",(data[i][12]-amount)/data[i][13]*100) .. HP end
					end
					
					if ExRT.F.GetUnitTypeByGUID(data[i][2]) == 0 then
						name = "|c"..ExRT.F.classColorByGUID(data[i][2])..name.."|r"
					end
					
					local sourceMarker = module.db.raidTargets[ data[i][15] or 0 ]
					
					local text = HP .. (sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "")..name.." "..L.BossWatcherDeathHeal..(data[i][14] and (" ("..(ACTION_SPELL_MISSED_ABSORB and strlower(ACTION_SPELL_MISSED_ABSORB) or "absorbed")..")") or "").." |T"..spellTexture..":0|t"..spellName.." "..L.BossWatcherDeathOn.." "..isCrit..amount..isCrit .. absorbed .. overheal .. school
					
					DeathTab_SetLine(i,timeText,text,0,1,0,data[i][4])
					
					reportData[8][#reportData[8] + 1] = diffTime.."s."..HP.." +"..isCrit..amount..isCrit .. absorbed .. overheal .." ["..GetGUID(data[i][2]).." - "..GetSpellLink(data[i][4]).."]"
				elseif data[i][1] == 4 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][4])
					local name = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2])
					local isApplied = (data[i][5]==1 or data[i][5]==3)
					
					if ExRT.F.GetUnitTypeByGUID(data[i][2]) == 0 then
						name = "|c"..ExRT.F.classColorByGUID(data[i][2])..name.."|r"
					end
					
					local sourceMarker = module.db.raidTargets[ data[i][15] or 0 ]
					
					local text = (sourceMarker and "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. sourceMarker  ..":0|t" or "")..name.." "..(isApplied and L.BossWatcherDeathAuraAdd or L.BossWatcherDeathAuraRemove).." |T"..spellTexture..":0|t"..spellName
					
					DeathTab_SetLine(i,timeText,text,1,1,0,data[i][4])
				
					reportData[8][#reportData[8] + 1] = diffTime.."s. ["..GetGUID(data[i][2]).." "..(isApplied and "+" or "-")..GetSpellLink(data[i][4]).."]"					
				end
				deathTab.lines[i]:Show()
			end
		end
		deathTab.scroll:SetNewHeight(#data * 18)
	end
	
	local function DeathTab_SetDeathList()
		local counter = 0
		for i,deathData in ipairs(CurrentFight.deathLog) do
			local header = deathData.header or deathData[1]
			local GUID = header[2]
			local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[GUID])
			if ((isFriendly and not DeathTab_Variables.isEnemy) or (not isFriendly and DeathTab_Variables.isEnemy)) and (deathData[2] and deathData[2][1]) then
				counter = counter + 1
				local classColor = "|cffbbbbbb"
				local isPlayer = ExRT.F.GetUnitTypeByGUID(GUID) == 0
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(GUID)
				end
				local text = classColor..GetGUID(GUID)..GUIDtoText(" [%s]",GUID).."|r"
				local spellID = nil
				for j=1,#deathData do
					if deathData[j] ~= header and deathData[j][1] == 1 and deathData[j][6] > 0 then
						local sourceColor = "|cffbbbbbb"
						if ExRT.F.GetUnitTypeByGUID(deathData[j][2]) == 0 then
							sourceColor = "|c"..ExRT.F.classColorByGUID(deathData[j][2])
						end
						local spellName,_,spellTexture = GetSpellInfo(deathData[j][4])
						text = text .." < " ..sourceColor .. GetGUID(deathData[j][2])..GUIDtoText(" [%s]",deathData[j][2]).."|r (|T"..spellTexture..":0|t"..spellName..")"
						spellID = deathData[j][4]
						break
					end
				end
				local cR,cG,cB = 0,0,0
				if header[1] == 5 then
					local spellName,_,spellTexture = GetSpellInfo(header[5])
					spellID = header[5]
					text = text .." (|T"..spellTexture..":0|t"..spellName..")"
					cR,cG,cB = .8,.8,0
				end
				
				local _time = timestampToFightTime( deathData[1][3] )
				local timeText = date("%M:%S.",_time)..format("%03d",_time * 1000 % 1000)
				
				local arrowPos = _time / GetFightLength(true)
				
				DeathTab_SetLine(counter,timeText,text,cR,cG,cB,spellID,i,arrowPos)
				deathTab.lines[counter]:Show()
			end
		end
		deathTab.scroll:SetNewHeight(counter * 18)
	end
	
	local function DeathTab_UpdateData()
		local list = deathTab.sourceDropDown.List
		wipe(list)
		for i,deathData in ipairs(CurrentFight.deathLog) do
			local header = deathData.header or deathData[1]
			local GUID = header[2]
			local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(CurrentFight.reaction[GUID])
			if ((isFriendly and not DeathTab_Variables.isEnemy) or (not isFriendly and DeathTab_Variables.isEnemy)) and (deathData[2] and deathData[2][1]) then
				local classColor = ""
				local isPlayer = ExRT.F.GetUnitTypeByGUID(GUID) == 0
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(GUID)
				elseif isFriendly then
					classColor = "|cffbbbbbb"
				end
				local text = date("%M:%S"..(header[1] == 5 and "*" or "").." ",timestampToFightTime(header[3]))..classColor..GetGUID(GUID)..GUIDtoText(" [%s]",GUID)
				list[#list+1] = {
					text = text,
					arg1 = i,
					arg2 = text,
					func = DeathTab_SetDeath,
					hoverFunc = DamageTab_ShowArrow,
					leaveFunc = DamageTab_HideArrow,
					hoverArg = timestampToFightTime( header[3] ) / GetFightLength(true),
				}
			end
		end
	end
	
	local function DeathTab_UpdatePage()
		DeathTab_UpdateData()
		DeathTab_ClearPage()
		DeathTab_SetDeathList()
		DeathTab_Variables.SetDeath_Last_Arg = nil
	end
	
	tab.chkFriendly = ELib:Radio(tab,L.BossWatcherFriendly,true):Point(15,-52):AddButton():OnClick(function(self) 
		DeathTab_Variables.isEnemy = false
		deathTab.chkEnemy:SetChecked(false)
		self:SetChecked(true)
		DeathTab_UpdatePage()
	end)
	tab.chkEnemy = ELib:Radio(tab,L.BossWatcherHostile):Point(150,-52):AddButton():OnClick(function(self) 
		DeathTab_Variables.isEnemy = true
		deathTab.chkFriendly:SetChecked(false)
		self:SetChecked(true)
		DeathTab_UpdatePage()
	end)
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(180):Point(335,-50):SetText(L.BossWatcherSelect)
	tab.sourceText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.sourceDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	
	tab.showBuffsChk = ELib:Check(tab,L.BossWatcherDeathBuffsShow):Point(530,-50):OnClick(function (self)
		if self:GetChecked() then
			DeathTab_Variables.isBuffs = true
		else
			DeathTab_Variables.isBuffs = false
		end
		if DeathTab_Variables.SetDeath_Last_Arg then
			DeathTab_SetDeath(nil,DeathTab_Variables.SetDeath_Last_Arg,DeathTab_Variables.SetDeath_Last_Arg2)
		end
	end)

	tab.showDebuffsChk = ELib:Check(tab,L.BossWatcherDeathDebuffsShow):Point(680,-50):OnClick(function (self)
		if self:GetChecked() then
			DeathTab_Variables.isDebuffs = true
		else
			DeathTab_Variables.isDebuffs = false
		end
		if DeathTab_Variables.SetDeath_Last_Arg then
			DeathTab_SetDeath(nil,DeathTab_Variables.SetDeath_Last_Arg,DeathTab_Variables.SetDeath_Last_Arg2)
		end
	end)
	
	tab.buffsblacklistChk = ELib:Check(tab,""):Point(833,-50):Tooltip(L.BossWatcherDeathBlacklist):OnClick(function (self)
		if self:GetChecked() then
			DeathTab_Variables.isBlack = true
		else
			DeathTab_Variables.isBlack = false
		end
		if DeathTab_Variables.SetDeath_Last_Arg then
			DeathTab_SetDeath(nil,DeathTab_Variables.SetDeath_Last_Arg,DeathTab_Variables.SetDeath_Last_Arg2)
		end
	end)
	
	local function DeathTab_LineOnEnter(self)
		if self.spellLink then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT",120,0)
			GameTooltip:SetHyperlink(self.spellLink)
			GameTooltip:Show()
		end
		if self.text:IsTruncated() then
			ELib.Tooltip:Add(nil,{self.text:GetText()},false,true)
		end
		if self.arrowPos then
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*self.arrowPos,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
		end
	end
	local function DeathTab_LineOnLeave(self)
		GameTooltip_Hide()
		ELib.Tooltip:HideAdd()
		BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
	end
	local function DeathTab_LineOnClick(self,button)
		if not self.clickToLog then
			if button == "RightButton" then
				DeathTab_UpdatePage()
			end
			return
		end
		if button == "RightButton" then
			return
		end
		local name = self.text:GetText()
		DeathTab_SetDeath(nil,self.clickToLog,name:match("(.-)|r"),nil)
	end
	tab.scroll = ELib:ScrollFrame(tab):Size(835,508):Point("TOP",0,-80)
	tab.lines = {}
	function DeathTab_SetLine(i,textTime,textText,gradientR,gradientG,gradientB,spellID,clickToLog,arrowPos)
		local line = deathTab.lines[i]
		if not line then
			line = CreateFrame("Button",nil,deathTab.scroll.C)
			deathTab.lines[i] = line
			line:SetPoint("TOP",0,-(i-1)*18)
			line:SetSize(810,18)
			
			line.time = ELib:Text(line,"00:02."..format("%02d",i),12):Size(150,16):Point("LEFT",10,0):Color():Shadow()
			line.text = ELib:Text(line,"00:02."..format("%02d",i),12):Size(810-125-20,16):Point("LEFT",125,0):Color():Shadow()
			
			line.back = line:CreateTexture(nil, "BACKGROUND")
			line.back:SetAllPoints()
			line.back:SetColorTexture( 1, 1, 1, 1)
			line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, 0)
			
			line:SetScript("OnEnter",DeathTab_LineOnEnter)
			line:SetScript("OnLeave",DeathTab_LineOnLeave)
			line:SetScript("OnClick",DeathTab_LineOnClick)
			
			line:RegisterForClicks("LeftButtonDown","RightButtonDown")
		end
		line.time:SetText(textTime)
		line.text:SetText(textText)
		line.back:SetGradientAlpha("HORIZONTAL", gradientR,gradientG,gradientB, 0.3, gradientR,gradientG,gradientB, 0)
		line.spellLink = spellID and "spell:"..spellID
		line.clickToLog = clickToLog
		line.arrowPos = arrowPos
		line:Show()
	end
	
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.report:Show()
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			DeathTab_UpdatePage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
	end)
	
	
	
	
	
	---- Positions Tab
	tab = BWInterfaceFrame.tab.tabs[9]
	local posTab = tab
	
	--[[
		Note:
		
		minX is higher then maxX in UnitPosition coords
		minY is higher then maxY in UnitPosition coords
		
		GetAreaMapInfo(zoneID) retruns terrainMapID (same as 4th param in UnitPosition)
		
		Funcs:
		GetCurrentMapDungeonLevel()	--> coords
		GetCurrentMapZone()		--> coords
		GetMapInfo()			--> map Name
		
	]]
	local PositionsTab_UpdatePage = nil
	local PositionsTab_Variables = {	--Use this because limit 200 local vars
		DisableMap = nil,
		SelectedMap = nil,
		NamesToDots = {},
		Maps = {},
		SelectedDot = nil,
		DebuffsBlackList = {
			[160029] = true,	--Resurrecting; haven't CLEU event for removing
		},
		UnitsBlackList = {
			["boss1"]=true,
			["boss2"]=true,
			["boss3"]=true,
			["boss4"]=true,
			["boss5"]=true,
			["boss6"]=true,
			["target"]=true,
			["focus"]=true,
		},
		HPList = {},
	}
	BWInterfaceFrame.PositionsTab_Variables = PositionsTab_Variables
	
	PositionsTab_Variables.BossToMap = {}
	
	local function PositionsTab_UpdatePositions(segment)
		local time = ceil(segment / 2)
		local tab = posTab
		for i=1,40 do
			tab.raidFrames[i]:Update(segment)
		end
		for i=1,6 do
			tab.unitFrames[i]:Update(time)
		end

		local text = ""
		for destGUID,destData in pairs(PositionsTab_Variables.HPList) do
			local curHP = 0
			for seg,hp in pairs(destData.res) do
				if CurrentFight.segments[seg] and (CurrentFight.segments[seg].t - CurrentFight.encounterStart) > time then
					break
				end
				curHP = hp
			end
			if curHP ~= 0 and curHP ~= destData.maxhp and (not destData.maxhp or curHP < destData.maxhp) and (not destData.lastSeen or segment+15 < destData.lastSeen) then
				text = text .. GetGUID(destGUID) .. GUIDtoText(" (%s)",destGUID) .. " "..(destData.maxhp and (destData.maxhp-curHP).."/"..destData.maxhp..format(" <%.1f%%>",(1-curHP/destData.maxhp)*100) or "-"..curHP) .. "|n"
			end
		end
		tab.scroll.mobsText:SetText(text)
	end
	
	tab.timeSlider = ELib:Slider(tab,L.BossWatcherPositionsSlider):Size(780):Point("TOP",-10,-20):Range(1,1):OnChange(function (self,value)
		value = ExRT.F.Round(value)
		
		local time = floor(value / 2)
		self.tooltipText = format("%d:%02d",time / 60,time % 60)
		self:tooltipReload(self)
		
		PositionsTab_UpdatePositions(value)
	end)
	tab.timeSlider.tooltipText = "0:00"
	tab.timeSlider:SetScript("OnMinMaxChanged",function (self)
		local _min,_max = self:GetMinMaxValues()
		self.Low:SetText("0:00")
		_max = max(1,_max / 2)
		self.High:SetText(format("%d:%02d",_max / 60,_max % 60))
	end)
	tab.timeSlider:SetObeyStepOnDrag(true)
	
	tab.hideMapChk = ELib:Check(tab,""):Point(833,-16):Tooltip(L.BossWatcherPositionsHideMap):OnClick(function (self)
		local backgrounds = posTab.scroll.C.backgrounds
		if self:GetChecked() then
			for i=1,#backgrounds do
				backgrounds[i]:Hide()
			end
			PositionsTab_Variables.DisableMap = true
		else
			for i=1,#backgrounds do
				backgrounds[i]:Show()
			end
			PositionsTab_Variables.DisableMap = nil
		end
		PositionsTab_UpdatePage()
	end)
		
	tab.scroll = ELib:ScrollFrame(tab):Size(835,540):Point("TOP",0,-50):Height(540)
	tab.scroll.ScrollBar:Hide()
	tab.scroll.C:SetWidth( tab.scroll:GetWidth() - 4 )
	
	tab.scroll.C.backgrounds = {}
	local PositionsTab_BackgroundsWidth = tab.scroll:GetWidth() * 256 / 1002
	local PositionsTab_BackgroundsHeight = tab.scroll:GetHeight() * 256 / 668
	
	for i=1,4 do
		for j=0,2 do
			tab.scroll.C.backgrounds[ j * 4 + i ] = tab.scroll.C:CreateTexture(nil, "BACKGROUND",nil,-7)
			tab.scroll.C.backgrounds[ j * 4 + i ]:SetSize(PositionsTab_BackgroundsWidth,PositionsTab_BackgroundsHeight)
			tab.scroll.C.backgrounds[ j * 4 + i ]:SetPoint("TOPLEFT",PositionsTab_BackgroundsWidth * (i-1),-j*PositionsTab_BackgroundsHeight)
		end
	end
	
	tab.scroll.scrollH = 0
	tab.scroll.scrollV = 0
	tab.scroll:SetScript("OnMouseWheel",function (self,delta)
		local x,y = ExRT.F.GetCursorPos(self)
	
		local oldScale = self.C:GetScale()
		local newScale = oldScale + delta * 0.25
		if newScale < 1 then
			newScale = 1
		elseif newScale > 7 then
			newScale = 7
		end
		self.C:SetScale( newScale )
		
		self.scrollH = self:GetWidth() - self:GetWidth() / newScale
		self.scrollV = self:GetHeight() - self:GetHeight() / newScale
		
		local scrollNowH = self:GetHorizontalScroll()
		local scrollNowV = self:GetVerticalScroll()

		scrollNowH = scrollNowH + x / oldScale - x / newScale
		scrollNowV = scrollNowV + y / oldScale - y / newScale
		
		if scrollNowH > self.scrollH then scrollNowH = self.scrollH end
		if scrollNowH < 0 then scrollNowH = 0 end
		if scrollNowV > self.scrollV then scrollNowV = self.scrollV end
		if scrollNowV < 0 then scrollNowV = 0 end
		
		self:SetHorizontalScroll(scrollNowH)
		self:SetVerticalScroll(scrollNowV)
		
		for i=1,#posTab.player do
			posTab.player[i].SubDot:SetScale(1 / newScale)
		end
	end)
	tab.scroll:SetScript("OnMouseDown",function (self)
		local x, y = GetCursorPosition()
		self.cursorX = x
		self.cursorY = y
		self.scrollNowH = self:GetHorizontalScroll()
		self.scrollNowV = self:GetVerticalScroll()
		self.move = true
		GameTooltip_Hide()
	end)
	tab.scroll:SetScript("OnMouseUP",function (self)
		self.move = nil
	end)
		
	tab.scroll.tooltipShown = {}
	tab.scroll:SetScript("OnUpdate",function (self)
		if not self.move then
			if not MouseIsOver(self) then
				return
			end
			if self.disableTooltip then
				return
			end
			local tooltip = nil
			for i=1,#self.player do
				self.tooltipShown[i] = nil
				local frame = self.player[i].SubDot
				if frame:IsVisible() and MouseIsOver(frame) then
					tooltip = true
					self.tooltipShown[i] = true
				end
			end
			if not tooltip then
				GameTooltip_Hide()
			else
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:SetText(TUTORIAL_TITLE19)
				for i=1,#self.player do
					if self.tooltipShown[i] then
						local distText = nil
						if PositionsTab_Variables.SelectedDot then
							local dot1,dot2 = PositionsTab_Variables.SelectedDot,self.player[i]
							if dot1.posX and dot2.posX then
								local dX = dot1.posX - dot2.posX
								local dY = dot1.posY - dot2.posY
								distText = " |cff999999(dist: ".. floor( sqrt(dX * dX + dY * dY) + 0.5 ).."y)"
							end
						end
						GameTooltip:AddLine(self.player[i].playerName..(distText or ""),1,1,1)
					end
				end
				GameTooltip:Show()
			end
			return
		end
		local x, y = GetCursorPosition()
		x,y = self.cursorX - x,self.cursorY - y
		
		local setH = self.scrollNowH + (x / self.C:GetScale())
		if setH < 0 then
			setH = 0
		elseif setH > self.scrollH then
			setH = self.scrollH
		end
		
		local setV = self.scrollNowV - (y / self.C:GetScale())
		if setV < 0 then
			setV = 0
		elseif setV > self.scrollV then
			setV = self.scrollV
		end
		
		self:SetHorizontalScroll(setH)
		self:SetVerticalScroll(setV)
	end)
	
	tab.player = {}
	tab.scroll.player = tab.player
	
	tab.SelectMapDropDown = ELib:DropDown(tab.scroll,205,5):Size(100):Point("BOTTOMRIGHT",-5,5):SetText("Select Map...")
	local function PositionsTab_SelectMapDropDown_SetValue(_,arg)
		PositionsTab_Variables.SelectedMap = arg
		PositionsTab_UpdatePage()
		if IsShiftKeyDown() then
			posTab.SelectMapDropDown:Hide()
		end
		ELib:DropDownClose()
	end
	do
		local contentTitles = {
			[0] = "WoW",
			[1] = "Classic",
			[2] = "BC",
			[3] = "WotLK",
			[4] = "Cataclysm",
			[5] = "MoP",
			[6] = "WoD",
			[7] = "Legion",
			[8] = "Brave new world",
		}
	
		tab.SelectMapDropDown.List[1] = {text = "Raids", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.raid = tab.SelectMapDropDown.List[1].subMenu

		tab.SelectMapDropDown.List[2] = {text = "Dungeons", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.dungeon = tab.SelectMapDropDown.List[2].subMenu
		
		tab.SelectMapDropDown.List[3] = {text = "PvP", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.pvp = tab.SelectMapDropDown.List[3].subMenu

		tab.SelectMapDropDown.List[4] = {text = "Other", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.other = tab.SelectMapDropDown.List[4].subMenu
		
		for mapID,maps in pairs(PositionsTab_Variables.Maps) do
			local subMenu = tab.SelectMapDropDown.List[ maps.type or "other" ]
			if subMenu then
				for i=1,#maps do
					subMenu[#subMenu + 1] = {
						text = maps[i][5]..(maps[i][6] or ""),
						func = PositionsTab_SelectMapDropDown_SetValue,
						arg1 = maps[i],
						_sort = (maps.content or 0) * 1000000 + mapID * 100 + 99 - i,
						content = (maps.content or 0),
					}
				end
			end
		end
		for i=1,#tab.SelectMapDropDown.List do
			local subMenu = tab.SelectMapDropDown.List[i].subMenu
			sort(subMenu,function(a,b) return a._sort > b._sort end)
			local listLen = #subMenu
			if listLen > 0 then
				local contentNow = subMenu[listLen].content
				for j=(listLen-1),1,-1 do
					local content = subMenu[j].content
					if content ~= contentNow then
						if contentNow ~= 0 then
							tinsert(subMenu,j+1,{text = contentTitles[contentNow], isTitle = true})
						end
						contentNow = content
					end
				end
				if contentNow ~= 0 then
					tinsert(subMenu,1,{text = contentTitles[contentNow], isTitle = true})
				end
			end
		end
		tab.SelectMapDropDown.List[#tab.SelectMapDropDown.List + 1] = {
			text = "None",
			func = PositionsTab_SelectMapDropDown_SetValue,
		}
	end
	
	local function PositionsTab_RaidFrame_UpdateHP(self,segment)
		if not self.Unit then
			self:Hide()
			return
		end
		local sec = ceil(segment / 2)
		local data = CurrentFight.graphData[sec]
		if not data then
			self:Hide()
			return
		end
		self:Show()
		
		local hpNow = data[self.Unit] and data[self.Unit].health or 0
		local hpMax = data[self.Unit] and data[self.Unit].hpmax or 0
		if hpMax == 0 or hpNow == 0 then
			self.hp:Hide()
		else
			self.hp:Show()
			self.hp:SetWidth(max(hpNow / hpMax * 70,1))
		end
		
		local data = self.debuffsData and self.debuffsData[segment]
		if not data then
			for i=1,#self.debuffs do
				self.debuffs[i]:Hide()
			end
		else
			for i=1,#data do
				if i > #self.debuffs then
					break
				end
				local spellID = floor( data[i] )
				local texture = GetSpellTexture(data[i])
				self.debuffs[i]:Texture(texture)
				self.debuffs[i].spellID = spellID
				local timeLeft = (data[i] % 1) * 1000
				self.debuffs[i].timeLeft = floor(timeLeft)
				self.debuffs[i]:Show()
			end
			for i=#data+1,#self.debuffs do
				self.debuffs[i]:Hide()
			end
		end
	end
	local function PositionsTab_UnitFrame_UpdateHP(self,sec)
		if not self.Unit then
			self:Hide()
			return
		end
		local data = CurrentFight.graphData[sec]
		if not data then
			self:Hide()
			return
		end
		
		self.text:SetText(data[self.Unit] and data[self.Unit].name or self.Unit)
		local hpNow = data[self.Unit] and data[self.Unit].health or 0
		local hpMax = data[self.Unit] and data[self.Unit].hpmax or 0
		if hpMax == 0 then
			self:Hide()
			return
		end
		self:Show()
		if hpMax == 0 or hpNow == 0 then
			self.hp:Hide()
			return
		end
		self.hp:Show()
		self.hp:SetWidth(max(hpNow / hpMax * 195,1))
		
		self.hp_text:SetFormattedText("%.1f",hpNow / hpMax * 100)
	end
	
	local function PositionsTab_RaidFrame_DebuffOnEnter(self)
		posTab.scroll.disableTooltip = true
		if self.spellID then
			ELib.Tooltip.Link(self,"spell:"..self.spellID)
			if self.stacks then
				GameTooltip:AddLine(L.BossWatcherBuffsAndDebuffsTooltipCountText..": "..self.stacks)
				GameTooltip:Show()
			end
			if self.timeLeft then
				GameTooltip:AddLine(format(PET_TIME_LEFT_SECONDS,self.timeLeft + 1))
				GameTooltip:Show()
			end
		end
	end
	local function PositionsTab_RaidFrame_DebuffOnLeave(self)
		posTab.scroll.disableTooltip = nil
		ELib.Tooltip:Hide()
	end
		
	tab.raidFrames = {}
	for i=1,8 do
		for j=1,5 do
			local frame = CreateFrame("Button",nil,tab.scroll)
			tab.raidFrames[(i-1)*5+j] = frame
			frame:SetSize(70,26)
			frame:SetPoint("BOTTOMLEFT",tab.scroll,5+(i-1)*(70+3),5+(j-1)*(26+3))
			frame.text = ELib:Text(frame,UnitName('player'),10):Size(60,14):Point("BOTTOMLEFT",5,3):Left():Color()
			frame.text:SetDrawLayer("ARTWORK", 0)
			
			frame.bordertop = frame:CreateTexture(nil, "BORDER")
			frame.borderbottom = frame:CreateTexture(nil, "BORDER")
			frame.borderleft = frame:CreateTexture(nil, "BORDER")
			frame.borderright = frame:CreateTexture(nil, "BORDER")
			
			frame.bordertop:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,1)
			frame.bordertop:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT",1,0)
		
			frame.borderbottom:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",-1,-1)
			frame.borderbottom:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",1,0)
		
			frame.borderleft:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,0)
			frame.borderleft:SetPoint("BOTTOMRIGHT",frame,"BOTTOMLEFT",0,0)
		
			frame.borderright:SetPoint("TOPLEFT",frame,"TOPRIGHT",0,0)
			frame.borderright:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",1,0)
		
			frame.bordertop:SetColorTexture(0,0,0,1)
			frame.borderbottom:SetColorTexture(0,0,0,1)
			frame.borderleft:SetColorTexture(0,0,0,1)
			frame.borderright:SetColorTexture(0,0,0,1)
			
			frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-5)
			frame.back:SetSize(70,26)
			frame.back:SetPoint("LEFT",0,0)
			frame.back:SetColorTexture(.05,.05,.05,1)

			frame.hp = frame:CreateTexture(nil, "BACKGROUND",nil,0)
			frame.hp:SetSize(70,26)
			frame.hp:SetPoint("LEFT",0,0)
			frame.hp:SetColorTexture(.3,.3,.3,1)
			
			frame.Update = PositionsTab_RaidFrame_UpdateHP
			
			frame.debuffs = {}
			for i=1,5 do
				frame.debuffs[i] = ELib:Frame(frame):Point("CENTER",frame,"TOPLEFT",7 + (i-1)*(12+1),-4):Size(12,12):Texture(GetSpellTexture(25771),nil):TexturePoint('x')
				frame.debuffs[i]:SetScript("OnEnter",PositionsTab_RaidFrame_DebuffOnEnter)
				frame.debuffs[i]:SetScript("OnLeave",PositionsTab_RaidFrame_DebuffOnLeave)
			end
			frame:Hide()
		end
	end
	
	tab.unitFrames = {}
	for i=1,6 do
		local frame = CreateFrame("Button",nil,tab.scroll)
		tab.unitFrames[i] = frame
		frame:SetSize(195,20)
		frame:SetPoint("TOPLEFT",tab.scroll,5,-200-(i-1)*23)	
		frame.text = ELib:Text(frame,UnitName('player'),10):Size(155,20):Point(2,0):Color()
		frame.text:SetDrawLayer("ARTWORK", 0)

		frame.hp_text = ELib:Text(frame,"99.9%",10):Size(36,20):Point(157,0):Right():Color()
		frame.hp_text:SetDrawLayer("ARTWORK", 0)
		
		frame.bordertop = frame:CreateTexture(nil, "BORDER")
		frame.borderbottom = frame:CreateTexture(nil, "BORDER")
		frame.borderleft = frame:CreateTexture(nil, "BORDER")
		frame.borderright = frame:CreateTexture(nil, "BORDER")
		
		frame.bordertop:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,1)
		frame.bordertop:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT",1,0)
	
		frame.borderbottom:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",-1,-1)
		frame.borderbottom:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",1,0)
	
		frame.borderleft:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,0)
		frame.borderleft:SetPoint("BOTTOMRIGHT",frame,"BOTTOMLEFT",0,0)
	
		frame.borderright:SetPoint("TOPLEFT",frame,"TOPRIGHT",0,0)
		frame.borderright:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",1,0)
	
		frame.bordertop:SetColorTexture(0,0,0,1)
		frame.borderbottom:SetColorTexture(0,0,0,1)
		frame.borderleft:SetColorTexture(0,0,0,1)
		frame.borderright:SetColorTexture(0,0,0,1)
		
		frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-5)
		frame.back:SetSize(195,20)
		frame.back:SetPoint("LEFT",0,0)
		frame.back:SetColorTexture(.05,.05,.05,1)

		frame.hp = frame:CreateTexture(nil, "BACKGROUND",nil,0)
		frame.hp:SetSize(195,20)
		frame.hp:SetPoint("LEFT",0,0)
		frame.hp:SetColorTexture(.3,.3,.3,1)
		
		frame.Update = PositionsTab_UnitFrame_UpdateHP
		
		frame:Hide()
	end

	tab.scroll.mobsText = ELib:Text(tab.scroll,"",10):Size(400,0):Point("TOPRIGHT",-5,-3):Left():Color()
	
	local function PositionsTab_DotOnUpdate(self,elapsed)
		self.anim = self.anim + elapsed
		if self.anim > 0.4 then
			self.anim = self.anim - 0.4
		end
		local alpha = self.anim
		if alpha > 0.2 then
			alpha = alpha - 0.2
			if alpha > 0.2 then
				alpha = 0.2
			end
			self:SetAlpha(0.5 + alpha * 2.5)
		else
			self:SetAlpha(1 - alpha * 2.5)
		end
		
	end
	local function PositionsTab_DotOnClick(self)
		self.anim = 0
		local isAnimOn = self.animOn
		for i=1,#posTab.player do
			if posTab.player[i].SubDot.animOn then
				posTab.player[i].SubDot:SetScript("OnUpdate",nil)
				posTab.player[i].SubDot.animOn = nil
				posTab.player[i].SubDot:SetAlpha(1)
			end
		end
		PositionsTab_Variables.SelectedDot = nil
		if not isAnimOn then
			self:SetScript("OnUpdate",PositionsTab_DotOnUpdate)
			self.animOn = true
			PositionsTab_Variables.SelectedDot = self:GetParent()
		end
	end
		
	function PositionsTab_UpdatePage()
		local tab = posTab
		local positionsData = CurrentFight.positionsData
		local minX,maxX,minY,maxY = 0,1,0,1
		local knownMap = nil
		
		local encounterID = CurrentFight.encounterID
		if encounterID and PositionsTab_Variables.BossToMap[encounterID] then
			knownMap = PositionsTab_Variables.BossToMap[encounterID]
		end
		knownMap = PositionsTab_Variables.SelectedMap or knownMap
		
		if knownMap and not PositionsTab_Variables.DisableMap then
			tab.minX = knownMap[1]
			tab.maxX = knownMap[3]
			tab.minY = knownMap[2]
			tab.maxY = knownMap[4]
			for i=1,12 do
				tab.scroll.C.backgrounds[i]:SetTexture("Interface\\WorldMap\\"..knownMap[5].."\\"..(knownMap[6] and knownMap[5]..knownMap[6].."_"..i or knownMap[5]..i))
			end
		elseif positionsData.mapInfo and not PositionsTab_Variables.DisableMap then
			local mapInfo = positionsData.mapInfo
			tab.minX = mapInfo.xL
			tab.maxX = mapInfo.xR
			tab.minY = mapInfo.yT
			tab.maxY = mapInfo.yB
			for i=1,12 do
				tab.scroll.C.backgrounds[i]:SetTexture("Interface\\WorldMap\\"..mapInfo.map.."\\"..mapInfo.map..(mapInfo.level and mapInfo.level.."_" or "")..i)
			end
		else
			tab.minX = minX
			tab.maxX = maxX
			tab.minY = minY
			tab.maxY = maxY
			for i=1,12 do
				tab.scroll.C.backgrounds[i]:SetTexture("")
			end
		end
		for i=1,#tab.player do
			tab.player[i]:Hide()
		end
		wipe(PositionsTab_Variables.NamesToDots)
		local dotCount = 0
		local raidFrames = {}
		local graphData = CurrentFight.graphData
		if graphData and graphData[1] then
			for name,data in pairs(graphData[1]) do
				if not PositionsTab_Variables.UnitsBlackList[name] then
					local unitGUID = ExRT.F.table_find2(CurrentFight.raidguids,name)
					local cR,cG,cB = .8,.8,.8
					if unitGUID then
						local class = select(2,GetPlayerInfoByGUID(unitGUID))
						if class then
							cR,cG,cB = ExRT.F.classColorNum(class)
						end
					end
					
					raidFrames[#raidFrames + 1] = {name,cR,cG,cB}
				end
			end
		end
		sort(raidFrames,function(a,b) return a[1]<b[1] end)
		--tinsert(raidFrames,1,{"target",.7,.7,.7})
		if graphData and graphData[1] then
			for i=1,#raidFrames do
				tab.raidFrames[i].Unit = raidFrames[i][1]
				tab.raidFrames[i].text:SetTextColor(raidFrames[i][2],raidFrames[i][3],raidFrames[i][4],1)
				tab.raidFrames[i].text:SetText(raidFrames[i][1])
				tab.raidFrames[i]:Update(1)
				
				--- debuffs list
				local debuffsData = {}
				tab.raidFrames[i].debuffsData = debuffsData
				local guid = nil
				for guidNow,nameNow in pairs(CurrentFight.raidguids) do
					if nameNow == raidFrames[i][1] then
						guid = guidNow
						break
					end
				end
				if guid then
					local current = {}
					local aurasData = CurrentFight.auras
					for k=1,#aurasData do
						local aurasLine = aurasData[k]
						if aurasLine[3] == guid and aurasLine[7] == 'DEBUFF' then
							local time_ = floor( timestampToFightTime( aurasLine[1] ) * 2 ) + 1
							local spellID = aurasLine[6]
							if not PositionsTab_Variables.DebuffsBlackList[ spellID ] then
								if aurasLine[8] ~= 2 then
									current[ spellID ] = current[ spellID ] or time_
								elseif aurasLine[8] == 2 then
									local start = current[ spellID ] or 1
									for l = start, time_ do
										debuffsData[l] = debuffsData[l] or {}
										tinsert(debuffsData[l],spellID+((time_ - l)%1000)/1000)
									end
									current[ spellID ] = nil
								end
							end
						end
					end
					local positionsData_len = #positionsData
					for spellID,start in pairs(current) do
						for j=start, positionsData_len do
							debuffsData[j] = debuffsData[j] or {}
							tinsert(debuffsData[j],spellID+((positionsData_len - j)%1000)/1000)
						end
					end
					
					tab.raidFrames[i]:Update(1)
				end
			end
			for i=#raidFrames+1,40 do
				tab.raidFrames[i].Unit = nil
				tab.raidFrames[i]:Update()
			end
			for i=1,6 do
				tab.unitFrames[i].Unit = "boss"..i
				tab.unitFrames[i]:Update(1)
			end
		else
			for i=1,40 do
				tab.raidFrames[i].Unit = nil
				tab.raidFrames[i]:Update()
			end
			for i=1,6 do
				tab.unitFrames[i].Unit = nil
				tab.unitFrames[i]:Update()
			end
		end
				
		tab.timeSlider:SetMinMaxValues(1,max(.5,#graphData)*2)
		
		tab.scroll.C:SetScale(1)
		tab.scroll.scrollH = 0
		tab.scroll.scrollV = 0		
		tab.scroll:SetHorizontalScroll(0)
		tab.scroll:SetVerticalScroll(0)
		for i=1,#tab.player do
			tab.player[i].SubDot:SetScale(1)
		end

		wipe(PositionsTab_Variables.HPList)

		for destGUID,destData in pairs(CurrentFight.damage) do
			for destReaction,destReactData in pairs(destData) do
				local isEnemy = false
				if GetUnitInfoByUnitFlagFix(destReaction,2) == 512 then
					isEnemy = true
				end
				if isEnemy then
					for sourceGUID,sourceData in pairs(destReactData) do
						local source = sourceGUID
						local dest = destGUID
						
						local mobData = PositionsTab_Variables.HPList[dest]
						if not mobData then
							mobData = {
								maxhp = CurrentFight.maxHP[dest],
								damage = {},
								heal = {},
								res = {},
							}
							PositionsTab_Variables.HPList[dest] = mobData
						end
												
						for spellID,spellSegments in pairs(sourceData) do
							for segment,spellAmount in pairs(spellSegments) do
								mobData.damage[segment] = (mobData.damage[segment] or 0) + spellAmount.amount - spellAmount.overkill
							end
						end
					end
				end
			end
		end
		for sourceGUID,sourceData in pairs(CurrentFight.heal) do
			for destGUID,destData in pairs(sourceData) do
				for destReact,destReactData in pairs(destData) do
					local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(destReact)
					if isEnemy then
						local source = sourceGUID
						local dest = destGUID
						
						local mobData = PositionsTab_Variables.HPList[dest]
						if not mobData then
							mobData = {
								maxhp = CurrentFight.maxHP[dest],
								damage = {},
								heal = {},
								res = {},
							}
							PositionsTab_Variables.HPList[dest] = mobData
						end
						
						for spellID,spellSegments in pairs(destReactData) do
							for segment,spellAmount in pairs(spellSegments) do
								mobData.damage[segment] = (mobData.damage[segment] or 0) - (spellAmount.amount - spellAmount.over + spellAmount.absorbed)
							end
						end
					end
				end
			end
		end

		for destGUID,destData in pairs(PositionsTab_Variables.HPList) do
			local dmgList = {}
			for seg,dmg in pairs(destData.damage) do
				dmgList[#dmgList+1] = {seg,dmg}
			end
			sort(dmgList,function(a,b)return a[1]<b[1] end)
			local now = 0
			for i,d in pairs(dmgList) do
				if not destData.seen then
					destData.seen = d[1]
				end
				now = now + d[2]
				destData.res[ d[1] ] = now
				destData.lastSeen = d[1]
			end
		end
		
		
		tab.timeSlider:SetValue(1)
		PositionsTab_UpdatePositions(1)
	end
	
	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			PositionsTab_UpdatePage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
		
		if IsShiftKeyDown() then
			posTab.SelectMapDropDown:Hide()
		else
			posTab.SelectMapDropDown:Show()
		end
	end)


	--- Others tab
	tab = BWInterfaceFrame.tab.tabs[10]
	local otherTab = tab

	tab.DecorationLine = tab:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-8)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine:SetColorTexture(1,1,1,1)
	tab.DecorationLine:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	tab.tab = ELib:Tabs(tab,0,
		TRACKING,
		"Damage Taken"
	):Size(865,600):Point("TOP",0,-29):SetTo(1)

	tab.tab:SetBackdropBorderColor(0,0,0,0)
	tab.tab:SetBackdropColor(0,0,0,0)
	

	---- Tracking
	tab = BWInterfaceFrame.tab.tabs[10].tab.tabs[1]
	local trackingTab = tab

	local TrackingTab_Variables = {
		EncounterOrder = {
			1778,1785,1787,1798,1786,1783,1788,1794,1777,1800,1784,1795,1799,
			1853,1841,1873,1854,1876,1877,1864,
			1958,1962,2008,
			1849,1865,1867,1871,1862,1886,1842,1863,1872,1866,
		},
	}
	
	tab.DecorationLine = tab:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-9)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine:SetColorTexture(1,1,1,1)
	tab.DecorationLine:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	tab.headerTab = ELib:Tabs(tab,0,
		L.BossWatcherTabPlayersSpells,
		L.BossWatcherTabSettings
	):Size(850,555):Point("TOP",0,-29):SetTo(1)
	tab.headerTab:SetBackdropBorderColor(0,0,0,0)
	tab.headerTab:SetBackdropColor(0,0,0,0)
	
	tab.spellsList = ELib:ScrollList(tab.headerTab.tabs[1]):Size(190,510):Point(10,-15)
	tab.targetsList = ELib:ScrollTableList(tab.headerTab.tabs[1],80,0):Size(625,510):Point("TOPLEFT",tab.spellsList,"TOPRIGHT",10,0)
	
	tab.spellsList.D = {}
	
	function tab.spellsList:SetListValue(index)
		wipe(trackingTab.targetsList.L)
		
		local L = trackingTab.targetsList.L
		
		local prevTime,prevTimeRow = nil
		
		local spellID = self.D[index]
		for i,trackingData in ipairs(CurrentFight.tracking) do
			if trackingData[6] == spellID then
				local time = timestampToFightTime(trackingData[1])
				local sourceGUID,destGUID = trackingData[2],trackingData[4]
				local sourceRaidTarget,destRaidTarget = nil
				
				if spellID == 185008 then	--Archimonde: Unleashed Torment
					for _,auraData in ipairs(CurrentFight.auras) do
						if auraData[2] == sourceGUID and auraData[6] == 184964 then
							sourceGUID = auraData[3]
							break
						end 
					end
				elseif spellID == 190399 then	--Archimonde: Mark of the Legion
					for _,auraData in ipairs(CurrentFight.auras) do
						if auraData[6] == 187050 and auraData[8] == 2 and abs(trackingData[1]-auraData[1])<0.4 then
							sourceGUID = auraData[3]
							break
						end 
					end
				elseif spellID == 182011 then	--Mannoroth: Empowered Mannoroth's Gaze
					local newSourceGUID = nil
					for _,auraData in ipairs(CurrentFight.auras) do
						if auraData[6] == 182006 and auraData[8] == 2 and auraData[1]>trackingData[1] then
							break
						elseif auraData[6] == 182006 and auraData[8] == 2 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 181617 then	--Mannoroth: Mannoroth's Gaze
					local newSourceGUID = nil
					for _,auraData in ipairs(CurrentFight.auras) do
						if auraData[6] == 181597 and auraData[8] == 2 and auraData[1]>trackingData[1] then
							break
						elseif auraData[6] == 181597 and auraData[8] == 2 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 180161 then	--Tyrant Velhari: Edict of Condemnation
					local newSourceGUID = nil
					for _,auraData in ipairs(CurrentFight.auras) do
						if auraData[6] == 185241 and auraData[8] == 1 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						elseif auraData[6] == 185241 and auraData[8] == 1 and auraData[1]>trackingData[1] then
							break
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 198099 then	--Ursoc: Barreling Momentum
					local newSourceGUID = nil
					for _,auraData in ipairs(CurrentFight.auras) do
						if auraData[6] == 198006 and auraData[8] == 1 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						elseif auraData[1]>trackingData[1] then
							break
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 228162 then	--Odyn: Shield of Light
					local newSourceGUID = nil
					if CurrentFight.cast[sourceGUID] then
						for _,castData in ipairs(CurrentFight.cast[sourceGUID]) do
							if castData[2] == 228162 and castData[3] == 1 and castData[1]<=trackingData[1] then
								newSourceGUID = castData[4]
							elseif castData[1]>trackingData[1] then
								break
							end
						end
					end
					sourceGUID = newSourceGUID or sourceGUID					
					
				end
				
				sourceRaidTarget = module.db.raidTargets[ trackingData[3] or 0 ]
				destRaidTarget = module.db.raidTargets[ trackingData[5] or 0 ]
			
				local diff = prevTime and (time-prevTime) or 999
				if diff <= 0.05 then
					prevTimeRow = prevTimeRow or prevTime
				else
					if prevTimeRow then
						for j=#L,1,-1 do
							if L[j][3] and L[j][3] < prevTimeRow then
								tinsert(L,j+1,{" "," "})
								break
							elseif L[j][1] == " " then
								break
							end
						end
						L[#L+1] = {" "," "}
					end
					prevTimeRow = nil
				end
				prevTime = time
				
				--{timestamp,sourceGUID,sourceFlags2,destGUID,destFlags2,spellID,amount,overkill,school,blocked,absorbed,critical,multistrike,missType}
				local amountString
				if not trackingData[14] then
					local overkill = trackingData[8] and trackingData[8] > 0 and " ("..ExRT.L.BossWatcherDeathOverKill..": "..ExRT.F.shortNumber(trackingData[8])..") " or ""
					local blocked = trackingData[10] and trackingData[10] > 0 and " ("..ExRT.L.BossWatcherDeathBlocked..": "..ExRT.F.shortNumber(trackingData[10])..") " or ""
					local absorbed = trackingData[11] and trackingData[11] > 0 and " ("..ExRT.L.BossWatcherDeathAbsorbed..": "..ExRT.F.shortNumber(trackingData[11])..") " or ""
					
					amountString = (trackingData[12] and "*" or "")..ExRT.F.shortNumber(trackingData[7] - trackingData[8])..(trackingData[12] and "*" or "").." "..overkill..blocked..absorbed
					amountString = strtrim(amountString)
				else
					amountString = "~"..trackingData[13].."~"
				end
				
				L[#L+1] = {date("%M:%S.", time)..format("%03d",time%1*1000),(sourceRaidTarget and ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..sourceRaidTarget..":0|t") or "").."|c".. ExRT.F.classColorByGUID(sourceGUID)..GetGUID(sourceGUID)..GUIDtoText(" [%s]",sourceGUID).."|r > "..(destRaidTarget and ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..destRaidTarget..":0|t") or "").."|c".. ExRT.F.classColorByGUID(destGUID)..GetGUID(destGUID)..GUIDtoText(" [%s]",destGUID).."|r: "..amountString,time}
			end
		end
		local prevTimeText = nil
		for i=1,#L do
			if L[i][1] == prevTimeText then
				prevTimeText = L[i][1]
				L[i][1] = ""
			else
				prevTimeText = L[i][1]
			end
		end
		
		trackingTab.targetsList:Update()
	end
	
	function tab.targetsList:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			GameTooltip_Hide()
		else
			if hoveredObj.text2:IsTruncated() then
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
				GameTooltip:AddLine(hoveredObj.text2:GetText() )
				GameTooltip:Show()
			end
		end
	end
	
	local function UpdateTrackingPage()
		wipe(trackingTab.targetsList.L)
		wipe(trackingTab.spellsList.L)
		wipe(trackingTab.spellsList.D)
		local L,D = trackingTab.spellsList.L,trackingTab.spellsList.D

		for i,trackingData in ipairs(CurrentFight.tracking) do
			if not ExRT.F.table_find(D,trackingData[6]) then
				D[#D+1] = trackingData[6]
			end
		end
		
		for i=1,#D do
			local spellName,_,spellTexture = GetSpellInfo(D[i])
			L[i] = "|T"..spellTexture..":0|t "..spellName
		end 
		
		trackingTab.spellsList:Update()
		trackingTab.targetsList:Update()
	end
	
	tab.optionsSpellsList = ELib:ScrollTableList(tab.headerTab.tabs[2],80,20,0,20):Size(650,400):Point(10,-15)
	
	local function UpdateTrackingOptionsPage()
		wipe(trackingTab.optionsSpellsList.L)
		local L = trackingTab.optionsSpellsList.L
		for spellID,encounterID in pairs(var_trackingDamageSpells) do
			local spellName,_,spellTexture = GetSpellInfo(spellID)
			spellName = spellName or '???'
			spellTexture = spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK"
			local encounterName = nil
			if type(encounterID)=='number' then
				encounterName = ExRT.L.bossName[encounterID]
			end
			L[#L+1] = {spellID,"|T"..spellTexture..":0|t",(encounterName and encounterName..": " or "")..spellName,module.db.def_trackingDamageSpells[spellID] and "" or "|TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:128:144:64:80|t",type(encounterID)=='number' and ExRT.F.table_find(TrackingTab_Variables.EncounterOrder,encounterID) or -1}
		end
		sort(L,function(a,b) if a[5]==b[5] then return a[1]<b[1] else return a[5]>b[5] end end)
		trackingTab.optionsSpellsList:Update()
	end
	function tab.optionsSpellsList:AdditionalLineClick()
		local x,y = ExRT.F.GetCursorPos(self)
		local pos = self:GetWidth()-x
		if pos <= 25 and pos > 7 then
			local parent = self.mainFrame
			local i = parent.selected
			if parent.L[i][4] ~= "" then
				local spellID = parent.L[i][1]
				VExRT.BossWatcher.trackingDamageSpells[ spellID ] = nil
				UpdateTrackingDamageSpellsTable()
				UpdateTrackingOptionsPage()
			end
		end
	end
	UpdateTrackingOptionsPage()
	
	tab.optionsEditAddSpell = ELib:Edit(tab.headerTab.tabs[2],6,true):Size(200,20):Point("TOPLEFT",tab.optionsSpellsList,"BOTTOMLEFT",0,-5)
	tab.optionsButtonAddSpell = ELib:Button(tab.headerTab.tabs[2],L.cd2TextAdd):Size(150,20):Point("LEFT",tab.optionsEditAddSpell,"RIGHT",5,0):OnClick(function()
		local tab = trackingTab
		local spellID = tonumber(tab.optionsEditAddSpell:GetText())
		if not spellID then
			return
		end
		tab.optionsEditAddSpell:SetText("")
		
		VExRT.BossWatcher.trackingDamageSpells[ spellID ] = true
		
		UpdateTrackingDamageSpellsTable()
		UpdateTrackingOptionsPage()
	end)
	
	
	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			self.lastFightID = BWInterfaceFrame.nowFightID
			UpdateTrackingPage()
		end
	end)


	---- Tracking
	tab = BWInterfaceFrame.tab.tabs[10].tab.tabs[2]
	local damageTakenTab = tab

	local DamageTakenTab_Variables = {
		graph_step = 5,
		check_byrole = true,
		check_absorbs = false,
		check_enemy = false,
	}

	tab.graph = ELib:GraphCol(tab):Point("TOP",0,-35):Size(780,400)
	tab.graph.TooltipText = function(self,tip)
		local t = tip.dataX
		local val = tip.dataY

		if val >= 1000000 then
			val = format("%.2fm",val/1000000)
		elseif val >= 1000 then
			val = format("%dk",val/1000)
		else
			val = format("%d",val)
		end

		return (tip.dataT and tip.dataT.."\n" or "") .. format("%d:%02d",t / 60,t % 60) .. "\n" ..val
	end
	tab.graph.TextX = function(self,x,data)
		x = data.x
		return format("%d:%02d",x / 60,x % 60)
	end
	tab.graph.media.colors = {
		{1,.3,0,1},
		{0.5,.8,0,1},
		{1,.3,0,.55}
	}

	tab.graph.stepSlider = ELib:Slider(tab.graph,"",true):Point("RIGHT",tab.graph,"LEFT",-10,0):Size(100):Range(1,60):SetTo(DamageTakenTab_Variables.graph_step):OnChange(function(self)
		local step = floor(self:GetValue() + 0.5)
		if DamageTakenTab_Variables.graph_step == step then
			return
		end
		DamageTakenTab_Variables.graph_step = step

		self:Tooltip(L.BossWatcherGraphicsStep.."\n"..step)
		self:tooltipReload()

		damageTakenTab:Update()
	end):Tooltip(L.BossWatcherGraphicsStep.."\n"..DamageTakenTab_Variables.graph_step)

	tab.chkByRole = ELib:Radio(tab,"Non-tanks/Tanks",DamageTakenTab_Variables.check_byrole):Point("TOPLEFT",tab.graph,"BOTTOMLEFT",0,-15):AddButton():OnClick(function(self) 
		damageTakenTab.chkAbsorbs:SetChecked(false)
		damageTakenTab.chkEnemies:SetChecked(false)
		self:SetChecked(true)
		
		DamageTakenTab_Variables.check_byrole = true
		DamageTakenTab_Variables.check_absorbs = false
		DamageTakenTab_Variables.check_enemy = false
		
		damageTakenTab:Update()
	end)
	tab.chkAbsorbs = ELib:Radio(tab,"Non-absorbed/Absorbed",DamageTakenTab_Variables.check_absorbs):Point("TOPLEFT",tab.chkByRole,"BOTTOMLEFT",0,-5):AddButton():OnClick(function(self) 
		damageTakenTab.chkByRole:SetChecked(false)
		damageTakenTab.chkEnemies:SetChecked(false)
		self:SetChecked(true)
		
		DamageTakenTab_Variables.check_byrole = false
		DamageTakenTab_Variables.check_absorbs = true
		DamageTakenTab_Variables.check_enemy = false
		
		damageTakenTab:Update()
	end)
	tab.chkEnemies = ELib:Radio(tab,"Enemies",DamageTakenTab_Variables.check_absorbs):Point("TOPLEFT",tab.chkAbsorbs,"BOTTOMLEFT",0,-5):AddButton():OnClick(function(self) 
		damageTakenTab.chkByRole:SetChecked(false)
		damageTakenTab.chkAbsorbs:SetChecked(false)
		self:SetChecked(true)
		
		DamageTakenTab_Variables.check_byrole = false
		DamageTakenTab_Variables.check_absorbs = false
		DamageTakenTab_Variables.check_enemy = true
		
		damageTakenTab:Update()
	end)

	function tab:Update()
		local result = {}
		local max_t = 0
		local doEnemy = DamageTakenTab_Variables.check_enemy
		local isReverse = false
		for destGUID,destData in pairs(CurrentFight.damage) do
			if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
				for destReaction,destReactData in pairs(destData) do
					local isEnemy = false
					if GetUnitInfoByUnitFlagFix(destReaction,2) == 512 then
						isEnemy = true
					end
					if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
						for sourceGUID,sourceData in pairs(destReactData) do
							local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
							if owner then
								sourceGUID = owner
							end
							if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
								local source = isReverse and destGUID or sourceGUID
								local dest = isReverse and sourceGUID or destGUID
								
								for spellID,spellSegments in pairs(sourceData) do
									for segment,spellAmount in pairs(spellSegments) do
										local t = floor(CurrentFight.segments[segment].t - CurrentFight.encounterStart)

										if not result[t] then
											result[t] = {0,0}
										end

										if DamageTakenTab_Variables.check_byrole then
											local c = CurrentFight.other.rolesGUID[dest] == "TANK" and 2 or 1
											--result[t][c] = result[t][c] + spellAmount.amount + spellAmount.absorbed - spellAmount.overkill
											result[t][c] = result[t][c] + spellAmount.amount - spellAmount.overkill
										elseif DamageTakenTab_Variables.check_absorbs then
											result[t][1] = result[t][1] + spellAmount.amount - spellAmount.overkill
											result[t][2] = result[t][2] + spellAmount.absorbed
										elseif DamageTakenTab_Variables.check_enemy then
											result[t][1] = result[t][1] + spellAmount.amount + spellAmount.absorbed - spellAmount.overkill
										end
										
										if t > max_t then max_t = t end
									end
								end
							end
						end
					end
				end
			end
		end

		--result={} max_t=600 for i=0,600 do result[i] = {math.random(100000),math.random(50000)} end

		local data = {}
		local step = DamageTakenTab_Variables.graph_step
		local now = 1

		local total = 0
		for i=0,max_t do
			if i % step == 0 and i > 0 then 
				now = now + 1 
			end

			data[now] = (data[now] or {{0,0},x=i})
			data[now][1][1] = data[now][1][1] + (result[i] and result[i][1] or 0)
			data[now][1][2] = data[now][1][2] + (result[i] and result[i][2] or 0)
		end
		if DamageTakenTab_Variables.check_byrole then
			data.c1_1 = tab.graph.media.colors[1]
			data.c1_2 = tab.graph.media.colors[2]
			data.t1_1 = "Non-tanks"
			data.t1_2 = "Tanks"
		elseif DamageTakenTab_Variables.check_absorbs then
			data.c1_1 = tab.graph.media.colors[1]
			data.c1_2 = tab.graph.media.colors[3]
			data.t1_1 = "Non-absorbed"
			data.t1_2 = "Absorbed"
		elseif DamageTakenTab_Variables.check_enemy then
			data.c1_1 = tab.graph.media.colors[1]
			for i=1,#data do
				for j=2,#data[i][1] do
					data[i][1][j] = nil
				end
			end
		end

		self.graph.data = data
		self.graph:Update()
	end

	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			self.lastFightID = BWInterfaceFrame.nowFightID
			damageTakenTab:Update()
		end
	end)


	
	BWInterfaceFrame:GetScript("OnShow")(BWInterfaceFrame)
end
