local GlobalAddonName, ExRT = ...

local UnitName, GetTime = UnitName, GetTime
local pairs, type, tonumber, abs = pairs, type, tonumber, abs
local UnitCombatlogname, RaidInCombat, ScheduleTimer, DelUnitNameServer = ExRT.F.UnitCombatlogname, ExRT.F.RaidInCombat, ExRT.F.ScheduleTimer, ExRT.F.delUnitNameServer
local CheckInteractDistance, CanInspect = CheckInteractDistance, CanInspect

local GetInspectSpecialization, GetNumSpecializationsForClassID, GetTalentInfo = GetInspectSpecialization, GetNumSpecializationsForClassID, GetTalentInfo
local C_SpecializationInfo_GetInspectSelectedPvpTalent
if ExRT.isClassic then
	GetInspectSpecialization = function () return 0 end
	GetNumSpecializationsForClassID = GetInspectSpecialization
	GetTalentInfo = ExRT.NULLfunc
	C_SpecializationInfo_GetInspectSelectedPvpTalent = ExRT.NULLfunc
else
	C_SpecializationInfo_GetInspectSelectedPvpTalent = C_SpecializationInfo.GetInspectSelectedPvpTalent
end

local VExRT = nil

local module = ExRT.mod:New("Inspect",nil,true)
local ELib,L = ExRT.lib,ExRT.L

local cooldownsModule = ExRT.A.ExCD2

module.db.inspectDB = {}
module.db.inspectDBAch = {}
module.db.inspectQuery = {}
module.db.inspectItemsOnly = {}
module.db.inspectNotItemsOnly = {}
module.db.inspectID = nil
module.db.inspectCleared = nil

cooldownsModule.db.inspectDB = module.db.inspectDB	--Quick fix for other modules

if ExRT.isClassic then
	SetAchievementComparisonUnit = ExRT.NULLfunc
end

local inspectForce = false
function module:Force() inspectForce = true end
function module:Slowly() inspectForce = false end

module.db.statsNames = {
	haste = {L.cd2InspectHaste,L.cd2InspectHasteGem},
	mastery = {L.cd2InspectMastery,L.cd2InspectMasteryGem},
	crit = {L.cd2InspectCrit,L.cd2InspectCritGem,L.cd2InspectCritGemLegendary},
	spirit = {L.cd2InspectSpirit,L.cd2InspectAll},
	
	intellect = {L.cd2InspectInt,L.cd2InspectIntGem,L.cd2InspectAll},
	agility = {L.cd2InspectAgi,L.cd2InspectAll},
	strength = {L.cd2InspectStr,L.cd2InspectStrGem,L.cd2InspectAll},
	spellpower = {L.cd2InspectSpd},
	
	versatility = {L.cd2InspectVersatility,L.cd2InspectVersatilityGem},
	leech = {L.cd2InspectLeech},
	armor = {L.cd2InspectBonusArmor},
	avoidance = {L.cd2InspectAvoidance},
	speed = {L.cd2InspectSpeed},

	corruption = {"%+(%d+) ?"..(ITEM_MOD_CORRUPTION or "Corruption").."$"},
	corruption_res = {"%+(%d+) ?"..(ITEM_MOD_CORRUPTION_RESISTANCE or "Corruption resistance").."$"},
}
if ExRT.locale == "koKR" then
	module.db.statsNames.corruption = {"^"..(ITEM_MOD_CORRUPTION or "Corruption").." ?%+(%d+)".."$"}
	module.db.statsNames.corruption_res = {"^"..(ITEM_MOD_CORRUPTION_RESISTANCE or "Corruption resistance").." ?%+(%d+)".."$"}
end

module.db.itemsSlotTable = {
	1,	--INVSLOT_HEAD
	2,	--INVSLOT_NECK
	3,	--INVSLOT_SHOULDER
	15,	--INVSLOT_BACK
	5,	--INVSLOT_CHEST
	9,	--INVSLOT_WRIST
	10,	--INVSLOT_HAND
	6,	--INVSLOT_WAIST
	7,	--INVSLOT_LEGS
	8,	--INVSLOT_FEET
	11,	--INVSLOT_FINGER1
	12,	--INVSLOT_FINGER2
	13,	--INVSLOT_TRINKET1
	14,	--INVSLOT_TRINKET2
	16,	--INVSLOT_MAINHAND
	17,	--INVSLOT_OFFHAND
}

local inspectScantip = CreateFrame("GameTooltip", "ExRTInspectScanningTooltip", nil, "GameTooltipTemplate")
inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")

do
	local essenceData,essenceDataByKey = nil
	local dbcData = {
		[36] = {311203,311210,311203,311210, 311206,311211,311302,311304, 311207,311212,311303,311306, 311209,311213,311303,311306},
		[37] = {312725,312771,312725,312771, 312764,312773,313921,313919, 312768,312774,313922,313920, 312770,312775,313922,313920},
		[34] = {310592,310603,310592,310603, 310597,310605,310601,310607, 310599,310606,310602,310608, 310600,310609,310602,310608},
		[35] = {310690,310712,310690,310712, 310705,311166,311194,311197, 310710,311167,311195,311198, 310711,311177,311195,311198},
		[33] = {295046,295164,295046,295164, 295098,295349,299984,299989, 295119,295353,299988,299991, 295308,295309,299988,299991},
		[32] = {303823,304081,303823,304081, 304086,304055,304088,304089, 303892,304125,304121,304123, 303894,304533,304121,304123},
		[28] = {298452,298407,298452,298407, 298455,298448,299376,299375, 298456,298449,299378,299377, 298457,298450,299378,299377},
		[27] = {298357,298268,298357,298268, 298376,298337,299372,299371, 298377,298339,299374,299373, 298405,298404,299374,299373},
		[25] = {298168,298193,298168,298193, 298169,298351,299273,299274, 298174,298352,299275,299277, 298186,298353,299275,299277},
		[24] = {297375,297411,297375,297411, 297546,297542,298309,298302, 297547,297544,298312,298304, 298184,298185,298312,298304},
		[4] =  {295186,295078,295186,295078, 295209,295208,298628,298627, 295160,295165,299334,299333, 295210,295166,299334,299333},
		[5] =  {295258,295246,295258,295246, 295262,295251,299336,299335, 295263,295252,299338,299337, 295264,295253,299338,299337},
		[21] = {296230,303448,296230,303448, 303472,303463,299958,303474, 296232,303460,299959,303476, 299559,299560,299959,303476},
		[20] = {293032,296207,293032,296207, 296220,296213,299943,299939, 296221,296214,299944,299940, 299520,299521,299944,299940},
		[3] =  {293031,294910,293031,294910, 294906,294919,300009,300012, 294907,294920,300010,300013, 294908,294922,300010,300013},
		[2] =  {293019,294668,293019,294668, 294653,294687,298080,298082, 294650,294688,298081,298083, 294655,294689,298081,298083},
		[19] = {296197,296136,296197,296136, 296200,296192,299932,299935, 296201,296193,299933,299936, 299529,299530,299933,299936},
		[18] = {296094,296081,296094,296081, 296102,296091,299882,299885, 296103,296089,299883,299887, 299518,299519,299883,299887},
		[7] =  {294926,294964,294926,294964, 295307,294970,300002,300004, 294945,294969,300003,300005, 295306,294972,300003,300005},
		[6] =  {295337,295293,295337,295293, 295364,295363,299345,299343, 295352,295351,299347,299346, 295358,295333,299347,299346},
		[14] = {295840,295834,295840,295834, 295841,295836,299355,299354, 295843,295837,299358,299357, 295892,295839,299358,299357},
		[15] = {302731,302916,302731,302916, 302778,302957,302982,302984, 302780,302961,302983,302985, 302910,302962,302983,302985},
		[16] = {296036,293030,296036,293030, 296038,296031,310425,310422, 296104,296032,310442,310426, 299542,299544,310442,310426},
		[17] = {296072,296050,296072,296050, 296074,296067,299875,299878, 296075,296062,299876,299879, 299522,299523,299876,299879},
		[13] = {295746,295750,295746,295750, 295747,295844,300015,300018, 295748,295846,300016,300020, 295749,295845,300016,300020},
		[12] = {295373,295365,295373,295365, 295377,295372,299349,299348, 295379,295369,299353,299350, 295380,295381,299353,299350},
		[22] = {296325,296320,296325,296320, 296326,296321,299368,299367, 303342,296322,299370,299369, 296328,296324,299370,299369},
		[23] = {297108,297147,297108,297147, 297120,297177,298273,298274, 297122,297178,298277,298275, 298182,298183,298277,298275},
	}
	module.db.essenceSpellsData = {}
	local CURRENT_MAX,CURRENT_MIN = 37,2

	function module:GetEssenceData()
		if not essenceData then
			essenceData = {}
			for i=CURRENT_MIN,CURRENT_MAX do 
				local ess = C_AzeriteEssence.GetEssenceHyperlink(i,1)
				if ess and ess ~= "" and dbcData[i] then
					ess = ess:match("%[(.-)%]"):gsub("%-","%%-")

					local currData = {
						name = ess,
						id = i,
					}
					essenceData[#essenceData+1] = currData

					local essData = C_AzeriteEssence.GetEssenceInfo(i)

					for j=1,4 do
						for k=0,1 do
							local spellID = dbcData[i][(j-1)*4+3+k]
							local spellName,_,spellTexture = GetSpellInfo(spellID)

							module.db.essenceSpellsData[spellID] = true

							currData[j*(k == 0 and 1 or -1)] = {
								icon = essData and essData.icon or spellTexture,
								spellID = spellID,
								previewSpellID = dbcData[i][(j-1)*4+1+k],
								name = ess,
								id = i,
								isMajor = k == 0,
								tier = j,
								link = C_AzeriteEssence.GetEssenceHyperlink(i,j),
							}
						end
					end
				end
			end
		end
		return essenceData
	end
	function module:GetEssenceDataByKey()
		if not essenceDataByKey then
			essenceDataByKey = {}
			local e = module:GetEssenceData()
			for k,v in pairs(e) do
				essenceDataByKey[v.id] = v
			end
		end
		return essenceDataByKey
	end
end

local function CheckForSuccesInspect(name)
	if not module.db.inspectDB[name] then
		module.db.inspectQuery[name] = true
	end
end

local inspectLastTime = 0
local function InspectNext()
	if RaidInCombat() or (InspectFrame and InspectFrame:IsShown()) then
		return
	end
	local nowTime = GetTime()
	for name,timeAdded in pairs(module.db.inspectQuery) do
		if name and UnitName(name) and (not ExRT.isClassic or CheckInteractDistance(name,1)) and CanInspect(name) then
			NotifyInspect(name)
			
			if (VExRT and VExRT.InspectViewer and VExRT.InspectViewer.EnableA4ivs) and not module.db.inspectDBAch[name] and not ExRT.isClassic then
				if AchievementFrameComparison then
					AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
					ExRT.F.Timer(AchievementFrameComparison.RegisterEvent, inspectForce and 1 or 2.5, AchievementFrameComparison, "INSPECT_ACHIEVEMENT_READY")
				end
				ClearAchievementComparisonUnit()
				SetAchievementComparisonUnit(name)
			end
			
			module.db.inspectQuery[name] = nil
			ExRT.F.Timer(CheckForSuccesInspect,10,name)	--Try later if failed
			return
		elseif not UnitName(name) then
			module.db.inspectQuery[name] = nil
		end
	end
end

local function InspectQueue()
	if ExRT.isClassic then	--Temp fix for 'Unknown unit' or 'Out of Range' errors
		return
	end
	local n = GetNumGroupMembers() or 0
	local timeAdded = GetTime()
	for j=1,n do
		local name,_,subgroup,_,_,_,_,online = GetRaidRosterInfo(j)
		if name and not module.db.inspectDB[name] and online then
			module.db.inspectQuery[name] = timeAdded
			module.db.inspectNotItemsOnly[name] = true
		end
	end
end

function module:AddToQueue(name) 
	if not module.db.inspectQuery[name] then
		module.db.inspectQuery[name] = GetTime()
		module.db.inspectNotItemsOnly[name] = true
	end
end


local InspectItems = nil
do
	local ITEM_LEVEL = (ITEM_LEVEL or "NO DATA FOR ITEM_LEVEL"):gsub("%%d","(%%d+)")
	local dataNames = {'tiersets','items','items_ilvl','azerite','essence'}
	function InspectItems(name,inspectedName,inspectSavedID)
		if module.db.inspectCleared or module.db.inspectID ~= inspectSavedID then
			return
		end
		module.db.inspectDB[name] = module.db.inspectDB[name] or {}
		local inspectData = module.db.inspectDB[name]
		inspectData['ilvl'] = 0
		for _,dataName in pairs(dataNames) do	--Prevent overuse memory
			if inspectData[dataName] then
				for q,w in pairs(inspectData[dataName]) do inspectData[dataName][q] = nil end
			else
				inspectData[dataName] = {}
			end		
		end
		for stateName,stateData in pairs(module.db.statsNames) do
			inspectData[stateName] = 0
		end

		cooldownsModule:ClearSessionDataReason(name,"azerite","essence","tier","item")
	
		local ilvl_count = 0
		
		local isArtifactEqipped = 0
		local ArtifactIlvlSlot1,ArtifactIlvlSlot2 = 0,0
		local mainHandSlot, offHandSlot = 0,0
		for i=1,#module.db.itemsSlotTable do
			local itemSlotID = module.db.itemsSlotTable[i]
			--local itemLink = GetInventoryItemLink(inspectedName, itemSlotID)
			inspectScantip:SetInventoryItem(inspectedName, itemSlotID)
			
			local _,itemLink = inspectScantip:GetItem()
			if itemLink and (itemSlotID == 16 or itemSlotID == 17) and itemLink:find("item::") then
				itemLink = GetInventoryItemLink(inspectedName, itemSlotID)
			end
			
			if itemLink then
				inspectData['items'][itemSlotID] = itemLink
				--inspectScantip:SetInventoryItem(inspectedName, itemSlotID)
				local itemID = itemLink:match("item:(%d+):")
				
				if itemSlotID == 16 or itemSlotID == 17 then
					local _,_,quality = GetItemInfo(itemLink)
					if quality == 6 then
						isArtifactEqipped = isArtifactEqipped + 1
					end
				end
				
				local AzeritePowers = nil
				if not ExRT.isClassic then
					local isAzeriteItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink)
					if isAzeriteItem then
						local powers = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(itemLink,inspectData.classID)
						if powers then
							AzeritePowers = {}
							for j=1,#powers do
								for k=1,#powers[j].azeritePowerIDs do
									local powerID = powers[j].azeritePowerIDs[k]
									
									local powerData = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
									if powerData then
										local spellName,_,spellTexture = GetSpellInfo(powerData.spellID)
										
										if spellName then
											AzeritePowers[#AzeritePowers+1] = {
												name = spellName,
												icon = spellTexture,
												id = powerID,
												item = itemSlotID,
												itemLink = itemLink,
												itemID = itemID,
												spellID = powerData.spellID,
												tier = j,
											}
										end
										
										cooldownsModule.db.spell_isAzeriteTalent[powerData.spellID] = true
									end
								end
							end
						end
					end
				end
				local EssencePowers
				if itemSlotID == 2 and C_AzeriteEssence and select(3,GetItemInfo(itemLink)) == 6 then
					EssencePowers = module:GetEssenceData()
				end

				if AzeritePowers then
					inspectData.azerite["i"..itemSlotID] = AzeritePowers
				end
				
				for j=2, inspectScantip:NumLines() do
					local tooltipLine = _G["ExRTInspectScanningTooltipTextLeft"..j]
					local text = tooltipLine:GetText()
					if text and text ~= "" then
						for stateName,stateData in pairs(module.db.statsNames) do
							inspectData[stateName] = inspectData[stateName] or 0
							local findText = text:gsub("[,]",""):gsub("(%d+)[ ]+(%d+)","%1%2")
							for k=1,#stateData do
								local findData = findText:match(stateData[k])
								if findData then
									local cR,cG,cB = tooltipLine:GetTextColor()
									cR = abs(cR - 0.5)
									cG = abs(cG - 0.5)
									cB = abs(cB - 0.5)
									if cR < 0.01 and cG < 0.01 and cB < 0.01 then
										findData = 0
									end
									inspectData[stateName] = inspectData[stateName] + tonumber(findData)
								end
							end
						end
						
						local ilvl = text:match(ITEM_LEVEL)
						if ilvl then
							ilvl = tonumber(ilvl)
							inspectData['ilvl'] = inspectData['ilvl'] + ilvl
							ilvl_count = ilvl_count + 1
							
							inspectData['items_ilvl'][itemSlotID] = ilvl
							
							if itemSlotID == 16 then
								mainHandSlot = ilvl
								ArtifactIlvlSlot1 = ilvl
							elseif itemSlotID == 17 then
								offHandSlot = ilvl
								ArtifactIlvlSlot2 = ilvl
							elseif itemSlotID == 2 and select(3,GetItemInfo(itemLink)) == 6 then
								cooldownsModule.db.spell_cdByTalent_scalable_data[296320][name] = "*"..(1 - min((ilvl - 465) * 0.15 + 19.8, 25) / 100)
								--[[
									63: 18.9
									66: 19.8
								]]
							end
						end
						
						if AzeritePowers then
							for k=1,#AzeritePowers do
								if text:find(AzeritePowers[k].name.."$") == 3 then
									inspectData.azerite[#inspectData.azerite + 1] = AzeritePowers[k]

									cooldownsModule.db.session_gGUIDs[name] = {AzeritePowers[k].spellID,"azerite"}
								end
							end
						end
						if EssencePowers then
							for k=1,#EssencePowers do
								if text:find(EssencePowers[k].name.."$") == 1 then
									local isMajor = _G["ExRTInspectScanningTooltipTextLeft"..(j-1)]:GetText() == " "
									local tier = 4
									local r,g,b = tooltipLine:GetTextColor()
									if abs(r-0.639)<0.01 and abs(g-0.217)<0.01 and abs(b-0.933)<0.01 then	--a335ee
										tier = 3
									elseif abs(r-0.117)<0.01 and abs(g-1)<0.01 and abs(b-0)<0.01 then	--1eff00
										tier = 1
									elseif abs(r-0)<0.01 and abs(g-0.439)<0.01 and abs(b-0.866)<0.01 then	--0070dd
										tier = 2
									else	--ff8000
										tier = 4
									end

									if isMajor then
										local ess = EssencePowers[k][tier]
										inspectData.essence[#inspectData.essence + 1] = ess
	
										cooldownsModule.db.session_gGUIDs[name] = {ess.spellID,"essence"}
										for l=tier-1,1,-1 do
											local ess = EssencePowers[k][l]
											cooldownsModule.db.session_gGUIDs[name] = {ess.spellID,"essence"}
										end
									end

									local ess = EssencePowers[k][tier*(-1)]
									if not isMajor then
										inspectData.essence[#inspectData.essence + 1] = ess
									end

									cooldownsModule.db.session_gGUIDs[name] = {ess.spellID,"essence"}
									for l=tier-1,1,-1 do
										local ess = EssencePowers[k][l*(-1)]
										cooldownsModule.db.session_gGUIDs[name] = {ess.spellID,"essence"}
									end
								end
							end
						end
					end
				end

				if not inspectData['items_ilvl'][itemSlotID] then
					local ilvl = select(4,GetItemInfo(itemLink))
					if ilvl then
						inspectData['ilvl'] = inspectData['ilvl'] + ilvl
						ilvl_count = ilvl_count + 1
						
						inspectData['items_ilvl'][itemSlotID] = ilvl
					end
				end
				
				itemID = tonumber(itemID or 0)
				
				--------> ExCD2
				local tierSetID = cooldownsModule.db.tierSetsList[itemID]
				if tierSetID then
					inspectData['tiersets'][tierSetID] = inspectData['tiersets'][tierSetID] and inspectData['tiersets'][tierSetID] + 1 or 1
				end
				local isTrinket = cooldownsModule.db.itemsToSpells[itemID]
				if isTrinket then
					cooldownsModule.db.session_gGUIDs[name] = {isTrinket,"item"}
				end
				
				
				--------> Relic
				if (itemSlotID == 16 or itemSlotID == 17) and isArtifactEqipped > 0 then
					--|cffe6cc80|Hitem:128935::140840:139250:140840::::110:262:16777472:9:1:744:113:1:3:3443:1472:3336:2:1806:1502:3:3443:1467:1813|h[Кулак Ра-дена]|h
					--|cffe6cc80|Hitem:128908::140837:140841:140817::::110:65 :256     :9:1:751:660:3:3516:1502:3337:3:3516:1497:3336:3:3515:1477:1813|h[Боевые мечи валарьяров]|h|r
					
					local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",itemLink,15)
										
					if ((gem1 and gem1 ~= "") or (gem2 and gem2 ~= "") or (gem1 and gem3 ~= "")) and (numBonusIDs and numBonusIDs ~= "") then
						numBonusIDs = tonumber(numBonusIDs)
						for j=1,numBonusIDs do
							if not restLink then
								break
							end
							local _,newRestLink = strsplit(":",restLink,2)
							restLink = newRestLink
						end
						if restLink then
							restLink = restLink:gsub("|h.-$","")
						
							if upgradeType and (tonumber(upgradeType) or 0) < 1000 then
								local _,newRestLink = strsplit(":",restLink,2)
								restLink = newRestLink
							else
								local _,_,newRestLink = strsplit(":",restLink,3)
								restLink = newRestLink							
							end
							
							for relic=1,3 do
								if not restLink then
									break
								end
								local numBonusRelic,newRestLink = strsplit(":",restLink,2)
								numBonusRelic = tonumber(numBonusRelic or "?") or 0
								restLink = newRestLink
								
								if numBonusRelic > 10 then	--Got Error in parsing here
									break
								end
								
								local relicBonus = numBonusRelic
								for j=1,numBonusRelic do
									if not restLink then
										break
									end
									local bonusID,newRestLink = strsplit(":",restLink,2)
									restLink = newRestLink
									relicBonus = relicBonus .. ":" .. bonusID					
								end
								
								local relicItemID = select(3+relic, strsplit(":",itemLink) )
								if relicItemID and relicItemID ~= "" then
									inspectData['items']['relic'..relic] = "item:"..relicItemID.."::::::::110:0::0:"..relicBonus..":::"
								end
							end
						end
					end
				end
			end
			
			inspectScantip:ClearLines()
		end
		if isArtifactEqipped > 0 then
			inspectData['ilvl'] = inspectData['ilvl'] - ArtifactIlvlSlot1 - ArtifactIlvlSlot2 + max(ArtifactIlvlSlot1,ArtifactIlvlSlot2) * 2
			
		elseif mainHandSlot > 0 and offHandSlot == 0 then
			inspectData['ilvl'] = inspectData['ilvl'] + mainHandSlot
		end
		inspectData['ilvl'] = inspectData['ilvl'] / 16
		

		--------> ExCD2
		for tierUID,count in pairs(inspectData['tiersets']) do
			local p2 = cooldownsModule.db.tierSetsSpells[tierUID][1]
			local p4 = cooldownsModule.db.tierSetsSpells[tierUID][2]
			if p2 and count >= 2 then
				if type(p2) ~= "table" then
					cooldownsModule.db.session_gGUIDs[name] = {p2,"tier"}
				else
					local sID = p2[ inspectData.specIndex or 0 ]
					if sID then
						cooldownsModule.db.session_gGUIDs[name] = {sID,"tier"}
					end
				end
			end
			if p4 and count >= 4 then
				if type(p4) ~= "table" then
					cooldownsModule.db.session_gGUIDs[name] = {p4,"tier"}
				else
					local sID = p4[ inspectData.specIndex or 0 ]
					if sID then
						cooldownsModule.db.session_gGUIDs[name] = {sID,"tier"}
					end
				end
			end
		end
		cooldownsModule:UpdateAllData()
	end
end

hooksecurefunc("NotifyInspect", function() module.db.inspectID = GetTime() module.db.inspectCleared = nil end)
hooksecurefunc("ClearInspectPlayer", function() module.db.inspectCleared = true end)

if not ExRT.isClassic then
	hooksecurefunc("SetAchievementComparisonUnit", function() module.db.achievementCleared = nil end)
	hooksecurefunc("ClearAchievementComparisonUnit", function() module.db.achievementCleared = true end)
end

do
	local tmr = -5
	local queueTimer = 0
	function module:timer(elapsed)
		tmr = tmr + elapsed
		if tmr > (inspectForce and 1 or 2) then
			queueTimer = queueTimer + tmr
			tmr = 0
			if queueTimer > 60 then
				queueTimer = 0
				InspectQueue()
			end
			InspectNext()
		end
	end
	function module:ResetTimer() tmr = 0 end
end

function module:Enable()
	module:RegisterTimer()
	module:RegisterEvents('PLAYER_SPECIALIZATION_CHANGED','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED','GROUP_ROSTER_UPDATE','ZONE_CHANGED_NEW_AREA','INSPECT_ACHIEVEMENT_READY','CHALLENGE_MODE_START','ENCOUNTER_START')
	module:RegisterAddonMessage()
end
function module:Disable()
	module:UnregisterTimer()
	module:UnregisterEvents('PLAYER_SPECIALIZATION_CHANGED','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED','GROUP_ROSTER_UPDATE','ZONE_CHANGED_NEW_AREA','INSPECT_ACHIEVEMENT_READY','CHALLENGE_MODE_START','ENCOUNTER_START')	
	module:UnregisterAddonMessage()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	if ExRT.SDB.charName then
		module.db.inspectQuery[ExRT.SDB.charName] = GetTime()
		module.db.inspectNotItemsOnly[ExRT.SDB.charName] = true
	end
	module:Enable()
end

function module.main:PLAYER_SPECIALIZATION_CHANGED(arg)
	if arg and UnitName(arg) then
		local name = UnitCombatlogname(arg)
		module.db.inspectDB[name] = nil
		
		--------> ExCD2
		VExRT.ExCD2.gnGUIDs[name] = nil		

		local _,class = UnitClass(name)
		if cooldownsModule.db.spell_talentsList[class] then
			for specID,specTalents in pairs(cooldownsModule.db.spell_talentsList[class]) do
				for _,spellID in pairs(specTalents) do
					if type(spellID) == "number" then
						cooldownsModule.db.session_gGUIDs[name] = -spellID
					end
				end
			end
		end

		cooldownsModule:ClearSessionDataReason(name,"talent","pvptalent","autotalent")
		
		cooldownsModule:UpdateAllData()
		--------> / ExCD2
		
		module.db.inspectQuery[name] = GetTime()
		module.db.inspectNotItemsOnly[name] = true
	end
end

do
	local scheludedQueue = nil
	local function funcScheduledUpdate()
		scheludedQueue = nil
		InspectQueue()
	end
	function module.main:GROUP_ROSTER_UPDATE()
		if not scheludedQueue then
			scheludedQueue = ScheduleTimer(funcScheduledUpdate,2)
		end
	end


	local prevDiff = nil
	local function ZoneCheck()
		local _,_,difficulty = GetInstanceInfo()
		if difficulty == 8 or prevDiff == 8 then
			local n = GetNumGroupMembers() or 0
			if IsInRaid() then
				n = min(n,5)
				for j=1,n do
					local name,_,subgroup = GetRaidRosterInfo(j)
					if name and subgroup == 1 then
						module.db.inspectNotItemsOnly[name] = true
						module.db.inspectQuery[name] = GetTime()
					end
				end
			else
				for j=1,5 do
					local uid = "party"..j
					if j==5 then
						uid = "player"
					end
					local name = UnitCombatlogname(uid)
					if name then
						module.db.inspectNotItemsOnly[name] = true
						module.db.inspectQuery[name] = GetTime()
					end
				end
			end
		end
		prevDiff = difficulty
	end
	function module.main:ZONE_CHANGED_NEW_AREA()
		ExRT.F.Timer(ZoneCheck,2)
		
		if not scheludedQueue then
			scheludedQueue = ScheduleTimer(funcScheduledUpdate,4)
		end
	end
	function module.main:CHALLENGE_MODE_START()
		ExRT.F.Timer(ZoneCheck,2)
		
		if not scheludedQueue then
			scheludedQueue = ScheduleTimer(funcScheduledUpdate,4)
		end
	end
end

do
	local lastInspectTime = {}
	function module.main:INSPECT_READY(arg)
		if not module.db.inspectCleared then
			ExRT.F.dprint('INSPECT_READY',arg)
			if not arg then 
				return
			end
			local currTime = GetTime()
			if lastInspectTime[arg] and (currTime - lastInspectTime[arg]) < 0.2 then
				return
			end
			lastInspectTime[arg] = currTime
			local _,_,_,race,_,name,realm = GetPlayerInfoByGUID(arg)
			if name then
				if realm and realm ~= "" then name = name.."-"..realm end
				local inspectedName = name
				if UnitName("target") == DelUnitNameServer(name) then 
					inspectedName = "target"
				elseif not UnitName(name) then
					return
				end
				module:ResetTimer()
				local _,class,classID = UnitClass(inspectedName)
				
				for i,slotID in pairs(module.db.itemsSlotTable) do
					local link = GetInventoryItemLink(inspectedName, slotID)
				end
				ScheduleTimer(InspectItems, inspectForce and 0.65 or 1.3, name, inspectedName, module.db.inspectID)
				if not inspectForce then
					--ScheduleTimer(InspectItems, 2.3, name, inspectedName, module.db.inspectID)
				end
	
				if module.db.inspectDB[name] and module.db.inspectItemsOnly[name] and not module.db.inspectNotItemsOnly[name] then
					module.db.inspectItemsOnly[name] = nil
					return
				end
				module.db.inspectItemsOnly[name] = nil
				module.db.inspectNotItemsOnly[name] = nil
				
				if module.db.inspectDB[name] then
					wipe(module.db.inspectDB[name])
				else
					module.db.inspectDB[name] = {}
				end
				local data = module.db.inspectDB[name]
				
				data.spec = floor( GetInspectSpecialization(inspectedName) + 0.5 )
				if data.spec < 1000 then
					VExRT.ExCD2.gnGUIDs[name] = data.spec
				end
				data.class = class
				data.classID = classID
				data.level = UnitLevel(inspectedName)
				data.race = race
				data.time = time()
				data.GUID = UnitGUID(inspectedName)
				data.lastUpdate = currTime
				data.lastUpdateTime = time()
				
				local specIndex = 1
				for i=1,GetNumSpecializationsForClassID(classID) do
					if GetSpecializationInfoForClassID(classID,i) == data.spec then
						specIndex = i
						break
					end
				end
				data.specIndex = specIndex
				
				for i=1,7 do
					data[i] = 0
				end
				data.talentsIDs = {}
				
				local classTalents = cooldownsModule.db.spell_talentsList[class]
				if classTalents then
					for _,list in pairs(classTalents) do
						for _,spellID in pairs(list) do
							cooldownsModule.db.session_gGUIDs[name] = -spellID
						end
					end
				end
				cooldownsModule:ClearSessionDataReason(name,"talent","pvptalent","autotalent")

				for spellID,specID in pairs(cooldownsModule.db.spell_autoTalent) do
					if specID == data.spec then
						cooldownsModule.db.session_gGUIDs[name] = {spellID,"autotalent"}
					end
				end
				
				for i=0,20 do
					local row,col = (i-i%3)/3+1,i%3+1
				
					local talentID, _, _, selected, available, spellID, _, _, _, _, grantedByAura = GetTalentInfo(row,col,specIndex,true,inspectedName)
					if selected then
						data[row] = col
						data.talentsIDs[row] = talentID
					end
					
					--------> ExCD2
					if spellID then
						local list = cooldownsModule.db.spell_talentsList[class]
						if not list then
							list = {}
							cooldownsModule.db.spell_talentsList[class] = list
						end
						
						list[specIndex] = list[specIndex] or {}
						
						list[specIndex][i+1] = spellID
						if selected or grantedByAura then
							cooldownsModule.db.session_gGUIDs[name] = {spellID,"talent"}
						end
						
						cooldownsModule.db.spell_isTalent[spellID] = true
					end
					--------> /ExCD2
				end

				for i=1,4 do
					local talentID = C_SpecializationInfo_GetInspectSelectedPvpTalent(inspectedName, i)
					if talentID then					
						data[i+7] = 1
						data.talentsIDs[i+7] = talentID
						
						local _, _, _, selected, available, spellID, _, _, _, _, grantedByAura = GetPvpTalentInfoByID(talentID)
						if spellID then
							local list = cooldownsModule.db.spell_talentsList[class]
							if not list then
								list = {}
								cooldownsModule.db.spell_talentsList[class] = list
							end
							
							list[-1] = list[-1] or {}
							
							list[-1][spellID] = spellID
							
							cooldownsModule.db.session_gGUIDs[name] = {spellID,"pvptalent"}
							
							--cooldownsModule.db.spell_isTalent[spellID] = true
							cooldownsModule.db.spell_isPvpTalent[spellID] = true
						end
					end
				end
				InspectItems(name, inspectedName, module.db.inspectID)
				
				cooldownsModule:UpdateAllData() 	--------> ExCD2
			end
		end
	end
end

do
	local lastInspectTime,lastInspectGUID = 0
	module.db.acivementsIDs = {} 
	function module.main:INSPECT_ACHIEVEMENT_READY(guid)
		ExRT.F.dprint('INSPECT_ACHIEVEMENT_READY',guid)
		if module.db.achievementCleared then
			C_Timer.NewTimer(.3,ClearAchievementComparisonUnit)	--prevent client crash on opening statistic 
			return
		end
		local currTime = GetTime()
		if not guid or (lastInspectGUID == guid and (currTime - lastInspectTime) < 0.2) then
			C_Timer.NewTimer(.3,ClearAchievementComparisonUnit)	--prevent client crash on opening statistic 
			return
		end
		lastInspectGUID = guid
		lastInspectTime = currTime
		local _,_,_,_,_,name,realm = GetPlayerInfoByGUID(guid)
		if name then
			if realm and realm ~= "" then name = name.."-"..realm end
			
			if module.db.inspectDBAch[name] then
				wipe(module.db.inspectDBAch[name])
			else
				module.db.inspectDBAch[name] = {}
			end
			local data = module.db.inspectDBAch[name]
			data.guid = guid
			for _,id in pairs(module.db.acivementsIDs) do
				if id > 0 then
					local completed, month, day, year, unk1 = GetAchievementComparisonInfo(id)
					if completed then
						data[id] = month..":"..day..":"..year
					end
				else
					id = -id
					local info = GetComparisonStatistic(id)
					info = tonumber(info or "-")
					if info then
						data[id] = info
					end
				end
			end
		end
		if not AchievementFrame or not AchievementFrame:IsShown() then
			C_Timer.NewTimer(.3,ClearAchievementComparisonUnit)	--prevent client crash on opening statistic 
		end
	end
end

function module.main:UNIT_INVENTORY_CHANGED(arg)
	if ExRT.isClassic then	--Temp fix for 'Unknown unit' or 'Out of Range' errors
		return
	end
	if arg=='player' then return end
	local name = UnitCombatlogname(arg or "?")
	if name and name ~= ExRT.SDB.charName then
		module.db.inspectItemsOnly[name] = true
		module.db.inspectQuery[name] = GetTime()
	end
end

function module.main:PLAYER_EQUIPMENT_CHANGED(arg)
	local name = UnitCombatlogname("player")
	module.db.inspectItemsOnly[name] = true
	module.db.inspectQuery[name] = GetTime()
end


function module.main:ENCOUNTER_START()
	if ExRT.isClassic then
		return
	end
	local str = ""

	local essTiers,essList = "",""
	local milestones,milestone = C_AzeriteEssence.GetMilestones()
	if milestones then
		for i,milestone in ipairs(milestones) do
			local eID = C_AzeriteEssence.GetMilestoneEssence(milestone.ID)
			if eID then
				local ess = C_AzeriteEssence.GetEssenceInfo(eID)
				if milestone.ID == 115 then	--Major
					essTiers =  ess.rank .. essTiers
					essList = eID .. essList
				else
					essTiers = essTiers .. ess.rank
					essList = essList .. ":" .. eID
				end
			end
		end
	end
	if essTiers ~= "" then
		if essList:find("^:") then
			essList = "0"..essList
			essTiers = "0"..essTiers
		end
		str = str .. (str ~= "" and "^" or "") .. "E:" .. essTiers ..":" .. essList
	end

	local tal = ""
	for tier=1,7 do
		local tierSpellID
		for col=1,3 do
			local talentID, _, _, selected, available, spellID, _, _, _, _, grantedByAura = GetTalentInfo(tier,col,1)
			if selected then
				tierSpellID = spellID
				break
			end
		end

		tal = tal .. ":" .. (tierSpellID or 0)
	end
	if tal ~= "" then
		str = str .. (str ~= "" and "^" or "") .. "T" .. tal
	end

	local azerite = ""
	local powerID
	local itemLocation = ItemLocation:CreateEmpty()
	local equipSlotIndex = EQUIPPED_FIRST
	while equipSlotIndex <= EQUIPPED_LAST do
		itemLocation:SetEquipmentSlot(equipSlotIndex)

		if C_Item.DoesItemExist(itemLocation) and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation) then
			local powers = C_AzeriteEmpoweredItem.GetAllTierInfo(itemLocation)
			for i,tier in ipairs(powers) do
				for j=1,#tier.azeritePowerIDs do
					powerID = tier.azeritePowerIDs[j]
					if C_AzeriteEmpoweredItem.IsPowerSelected(itemLocation,powerID) and powerID ~= 13 then
						azerite = azerite .. ":" .. powerID
					end
				end
			end
		end

		equipSlotIndex = equipSlotIndex + 1;
	end
	if azerite ~= "" then
		str = str .. (str ~= "" and "^" or "") .. "A" .. azerite
	end

	if str ~= "" then
		ExRT.F.SendExMsg("inspect","R\t"..str)
	end
end

function module:addonMessage(sender, prefix, subPrefix, ...)
	if prefix == "inspect" then
		if subPrefix == "R" then
			local str = ...
			local senderFull = sender
			sender = strsplit("-",sender)
			while str do
				local main,next = strsplit("^",str,2)
				str = next
				
				local key = main:sub(1,1)
				if key == "E" then
					cooldownsModule:ClearSessionDataReason(sender,"essence")
					cooldownsModule:ClearSessionDataReason(senderFull,"essence")
					
					local essencePowers = module:GetEssenceDataByKey()
					
					local _,tiers,list = strsplit(":",main,3)
					local count = 0					
					while list do
						local now,on = strsplit(":",list,2)
						list = on
						count = count + 1
						local tier = tiers:sub(count,count)
						now = tonumber(now)
						tier = tonumber(tier)
						local e = essencePowers[now]
						if e then
							if count == 1 then	--major
								for l=tier,1,-1 do
									local ess = e[l]
									cooldownsModule.db.session_gGUIDs[sender] = {ess.spellID,"essence"}
									cooldownsModule.db.session_gGUIDs[senderFull] = {ess.spellID,"essence"}
								end
							end
							for l=tier,1,-1 do
								local ess = e[l*(-1)]
								cooldownsModule.db.session_gGUIDs[sender] = {ess.spellID,"essence"}
								cooldownsModule.db.session_gGUIDs[senderFull] = {ess.spellID,"essence"}
							end
							--print(sender,'added essence',e.id,e.name)
						end
					end
				elseif key == "T" then
					cooldownsModule:ClearSessionDataReason(sender,"talent")
					cooldownsModule:ClearSessionDataReason(senderFull,"talent")

					local _,list = strsplit(":",main,2)
					while list do
						local spellID,on = strsplit(":",list,2)
						list = on

						spellID = tonumber(spellID or "?")
						if spellID and spellID ~= 0 then
							cooldownsModule.db.session_gGUIDs[sender] = {spellID,"talent"}
							cooldownsModule.db.session_gGUIDs[senderFull] = {spellID,"talent"}
							cooldownsModule.db.spell_isTalent[spellID] = true
							--print(sender,'added talent',spellID)
						end
					end					
				elseif key == "A" then
					cooldownsModule:ClearSessionDataReason(sender,"azerite")
					cooldownsModule:ClearSessionDataReason(senderFull,"azerite")

					local _,list = strsplit(":",main,2)
					while list do
						local powerID,on = strsplit(":",list,2)
						list = on

						powerID = tonumber(powerID or "?")
						if powerID and powerID ~= 0 then
							local powerData = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
							if powerData then
								local spellID = powerData.spellID
								cooldownsModule.db.session_gGUIDs[sender] = {spellID,"azerite"}
								cooldownsModule.db.session_gGUIDs[senderFull] = {spellID,"azerite"}
								cooldownsModule.db.spell_isAzeriteTalent[spellID] = true
								--print(sender,'added azerite',powerID)
							end
						end
					end
				end
			end
		end
	end
end