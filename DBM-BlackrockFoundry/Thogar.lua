local mod	= DBM:NewMod(1147, "DBM-BlackrockFoundry", nil, 457)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(76906)--81315 Crack-Shot, 81197 Raider, 77487 Grom'kar Firemender, 80791 Grom'kar Man-at-Arms, 81318 Iron Gunnery Sergeant, 77560 Obliterator Cannon, 81612 Deforester
mod:SetEncounterID(1692)
mod:SetZone()
mod:SetUsedIcons(8, 7, 2, 1)
mod.respawnTime = 29.5

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 160140 163753 159481",
	"SPELL_CAST_SUCCESS 155864 159481",
	"SPELL_AURA_APPLIED 155921 165195 164380 160140",
	"SPELL_AURA_APPLIED_DOSE 155921 164380",
	"SPELL_AURA_REFRESH 155921",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)

--Operator Thogar
local warnProtoGrenade				= mod:NewTargetAnnounce(155864, 3)
local warnEnkindle					= mod:NewStackAnnounce(155921, 2, nil, "Tank")
local warnTrain						= mod:NewTargetCountAnnounce(176312, 4, nil, nil, nil, nil, nil, 2)
--Adds
local warnDelayedSiegeBomb			= mod:NewTargetAnnounce(159481, 3)

--Operator Thogar
local specWarnProtoGrenade			= mod:NewSpecialWarningMove(165195, nil, nil, nil, 1, 2)
local specWarnProtoGrenadeNear		= mod:NewSpecialWarningClose(165195, nil, nil, nil, 1, 2)
local yellProtoGrenade				= mod:NewYell(165195)
local specWarnEnkindle				= mod:NewSpecialWarningStack(155921, nil, 2, nil, nil, 1, 6)--Maybe need 3 for new cd?
local specWarnEnkindleOther			= mod:NewSpecialWarningTaunt(155921, nil, nil, nil, 1, 2)
local specWarnTrain					= mod:NewSpecialWarningDodge(176312, nil, nil, nil, 3, 2)
local specWarnSplitSoon				= mod:NewSpecialWarning("specWarnSplitSoon", nil, nil, nil, 1, 2)--TODO, maybe include types in the split?
--Adds
local specWarnCauterizingBolt		= mod:NewSpecialWarningInterrupt(160140, "-Healer", nil, 2)
local specWarnCauterizingBoltDispel	= mod:NewSpecialWarningDispel(160140, "MagicDispeller")
local specWarnIronbellow			= mod:NewSpecialWarningSpell(163753, nil, nil, nil, 2)
local specWarnDelayedSiegeBomb		= mod:NewSpecialWarningYou(159481, nil, nil, nil, nil, 2)
local specWarnDelayedSiegeBombMove	= mod:NewSpecialWarningMove(159481)
local yellDelayedSiegeBomb			= mod:NewCountYell(159481)
local specWarnManOArms				= mod:NewSpecialWarningSwitch("ej9549", "-Healer")
local specWarnBurning				= mod:NewSpecialWarningStack(164380, nil, 2)--Mythic

--Operator Thogar
local timerProtoGrenadeCD			= mod:NewCDTimer(11, 155864, nil, nil, nil, 3)
local timerEnkindleCD				= mod:NewCDTimer(11.5, 155921, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerTrainCD					= mod:NewNextCountTimer("d15", 176312, nil, nil, nil, 1, nil, DBM_CORE_DEADLY_ICON, nil, 1, 5)
--Adds
--local timerCauterizingBoltCD		= mod:NewNextTimer(30, 160140, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerIronbellowCD				= mod:NewCDTimer(8.5, 163753, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerDelayedSiegeBomb			= mod:NewNextCountTimer(6, 159481)

local berserkTimer					= mod:NewBerserkTimer(492)

mod:AddInfoFrameOption(176312)
mod:AddSetIconOption("SetIconOnAdds", "ej9549", false, true)
mod:AddHudMapOption("HudMapForTrain", 176312, false)
mod:AddBoolOption("HudMapUseIcons")--Depending what is easier to see/understand, i may change this to default off
mod:AddDropdownOption("TrainVoiceAnnounce", {"LanesOnly", "MovementsOnly", "LanesandMovements"}, "LanesOnly", "misc")
mod:AddDropdownOption("InfoFrameSpeed", {"Immediately", "Delayed"}, "Delayed", "misc")

mod.vb.trainCount = 0
mod.vb.infoCount = 0
local GetTime, UnitPosition = GetTime, UnitPosition
local MovingTrain, Cannon = DBM:GetSpellInfo(176312), DBM:GetSpellInfo(62357)
local Reinforcements, ManOArms, Deforester = DBM:EJ_GetSectionInfo(9537), DBM:EJ_GetSectionInfo(9549), DBM:EJ_GetSectionInfo(10329)
local fakeYellTime = 0
local bombFrom = nil

--Note, all Trains spawn 5 second after yell for that Train
--this means that for 5 second cd Trains you may see a yell for NEXT Train as previous Train is showing up. Do not confuse this!
--Also be aware that older beta videos are wrong, blizz has changed Train orders few times, so don't try to fill in missing data by putting "thogar" into youtube unless it's a RECENT LIVE video.

local mythicTrains = {
	[1] = { [4] = ManOArms },--+7 after pull.(00:07)
	[2] = { [1] = Deforester },--+5 after 1.(00:12)
	[3] = { [2] = L.Train },--+5 after 2.(00:17)
	[4] = { [3] = L.Train },--+15 after 3.(00:32)
	[5] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+20 after 4.(00:52)
	[6] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+15 after 5.(01:07)
	[7] = { [1] = Cannon, [4] = Cannon },--+10 after 6.(01:17)
	[8] = { [2] = L.Train },--+15 after 7.(01:32)
	[9] = { [3] = L.Train },--+15 after 8.(01:47)
	[10] = { [2] = Reinforcements, [3] = Reinforcements },--+35 after 9.(02:22) Split
	[11] = { [1] = L.Train, [4] = L.Train },--+25 after 10.(02:47)
	[12] = { [4] = Deforester },--+5 after 11.(02:52)
	[13] = { [1] = Deforester },--+5 after 12.(02:57)
	[14] = { [3] = L.Train },--+5 after 13.(03:02)
	[15] = { [2] = L.Train, [3] = L.Train },--+10(or +11?) after 14.(03:12)
	[16] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+20(or +19) after 15.(03:32)
	[17] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+15 after 16.(03:47)
	[18] = { [1] = ManOArms, [4] = Cannon },--+15 after 17.(04:02)
	[19] = { [1] = Deforester, [2] = L.Train, [3] = L.Train },--+20 after 18.(04:22)
	[20] = { [2] = L.Train, [3] = L.Train },--+20(or +21) after 19.(04:42)
	[21] = { [2] = Reinforcements, [3] = ManOArms },--+15 after 20.(04:57) Split
	[22] = { [1] = L.Train, [4] = L.Train },--+20 after 21.(05:17)
	[23] = { [2] = L.Train, [3] = L.Train },--+10 after 22.(05:27)
	[24] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+15 after 23.(05:42)
	[25] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+15 after 24.(05:57)
	[26] = { [4] = Reinforcements },--+5 after 25.(06:02)
	[27] = { [1] = Cannon },--+5 after 26.(06:07)
	[28] = { [2] = Deforester, [3] = Deforester },--+20 after 27.(06:27)
	[29] = { [1] = L.Train, [4] = L.Train },--+20 after 28.(06:47) (1 L.Train is guessed)
	[30] = { [1] = Reinforcements, [4] = Deforester },--+15 after 29.(07:02)
	[31] = { [2] = L.Train },--+10 after 30.(07:12)
	[32] = { [3] = Deforester },--+5 after 31.(07:17)
	[33] = { [2] = L.Train },--+10 after 32.(07:27)
	[34] = { [1] = ManOArms },--+15 after 33.(07:42)
	[35] = { ["specialw"] = L.threeTrains, ["speciali"] = L.threeRandom, [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+10 after 34.(07:52)
	[36] = { [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+15 after 35.(08:07)--berserk.
}

local otherTrains = {
	[1] = { [4] = L.Train },--+12 after pull (0:12)
	[2] = { [2] = L.Train },--+10 after 1 (0:22)
	[3] = { [1] = Reinforcements },--+5 after 2 (0:27)
	[4] = { [3] = L.Train },--+15 after 3 (0:42)
	[5] = { [4] = Cannon },--+5 after 4 (0:47)
	[6] = { [2] = L.Train },--+25 after 5 (1:12)
	[7] = { [3] = ManOArms },--+5 after 6 (1:17)
	[8] = { [1] = L.Train },--+25 after 7 (1:42)
	[9] = { [2] = Reinforcements, [3] = Reinforcements },--+15 after 8 (1:57) Split
	[10] = { [1] = L.Train, [4] = L.Train },--+40 after 9 (2:37)
	[11] = { [1] = Cannon },--+10 after 10 (2:47)
	[12] = { [2] = L.Train },--+15 after 11 (3:02)
	[13] = { [4] = Reinforcements },--+10 after 12 (3:12)
	[14] = { [3] = L.Train },--+20 after 13 (3:32)
	[15] = { [2] = L.Train },--+10 after 14 (3:42)
	[16] = { [1] = L.Train },--+10 after 15 (3:52)
	[17] = { [2] = ManOArms, [4] = Cannon },--+15 after 16 (4:07)
	[18] = { [1] = L.Train },--+20 after 17 (4:27)
	[19] = { [3] = L.Train },--+5 after 18 (4:32)
	[20] = { [1] = Cannon, [4] = Cannon },--+30 after 19 (5:02)
	[21] = { [2] = L.Train },--+10 after 20 (5:12)
	[22] = { [2] = L.Train },--+25 after 21 (5:37)
	[23] = { [2] = Reinforcements, [3] = ManOArms },--+30 after 22 (6:07) Split
	[24] = { ["specialw"] = L.oneTrain, ["speciali"] = L.oneRandom, [2] = L.Train, [4] = L.Train },--+15 after 23? (6:22). Lane 4, but if reinforcements aren't dead from wave 23, lane 2 (because reinforcements cart still blocking lane 4) Not Actually random. But detecting if reinforcement cart still in way impossible :\
	[25] = { [1] = L.Train },--+20 after 24 (6:42)
	[26] = { [1] = Cannon, [4] = Reinforcements },--+10 after 25 (6:52)
	[27] = { [2] = L.Train },--+15 after 26 (7:07)
	[28] = { [3] = L.Train },--+10 after 27 (7:17)
	[29] = { [3] = ManOArms },--+20 after 28 (7:37)
	[30] = { [1] = L.Train, [4] = L.Train },--+5 after 29 (7:42) 
	[31] = { [4] = L.Train },--+15 after 30 (7:57) (guessed.)--seems berserk. 4 L.Trains in a row (interval 4 sec.)
	[32] = { [3] = L.Train },--+4 after 31 (8:01)
	[33] = { [2] = L.Train },--+4 after 32 (8:05)
	[34] = { [1] = L.Train },--+4 after 33 (8:09)
	[35] = { [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+? after 34 (8:??)
}

--Kind of sucks having an entirely new table for 2 changes, but whatever.
local lfrTrains = {
	[1] = { [4] = L.Train },--+12 after pull (0:12)
	[2] = { [2] = L.Train },--+10 after 1 (0:22)
	[3] = { [1] = Reinforcements },--+5 after 2 (0:27)
	[4] = { [3] = L.Train },--+15 after 3 (0:42)
	[5] = { [4] = Cannon },--+5 after 4 (0:47)
	[6] = { [2] = L.Train },--+25 after 5 (1:12)
	[7] = { [3] = ManOArms },--+5 after 6 (1:17)
	[8] = { [1] = L.Train },--+25 after 7 (1:42)
	[9] = { [3] = Reinforcements },--+15 after 8 (1:57) Just one L.Train in LFR
	[10] = { [1] = L.Train, [4] = L.Train },--+40 after 9 (2:37)
	[11] = { [1] = Cannon },--+10 after 10 (2:47)
	[12] = { [2] = L.Train },--+15 after 11 (3:02)
	[13] = { [4] = Reinforcements },--+10 after 12 (3:12)
	[14] = { [3] = L.Train },--+20 after 13 (3:32)
	[15] = { [2] = L.Train },--+10 after 14 (3:42)
	[16] = { [1] = L.Train },--+10 after 15 (3:52)
	[17] = { [2] = ManOArms, [4] = Cannon },--+15 after 16 (4:07)
	[18] = { [1] = L.Train },--+20 after 17 (4:27)
	[19] = { [3] = L.Train },--+5 after 18 (4:32)
	[20] = { [1] = Cannon, [4] = Cannon },--+30 after 19 (5:02)
	[21] = { [2] = L.Train },--+10 after 20 (5:12)
	[22] = { [2] = L.Train },--+25 after 21 (5:37)
	--FIXME
	[23] = { [2] = Reinforcements, [3] = ManOArms },--+30 after 22 (6:07) Also not a split, but don't know what's changed
	--FIXME
	[24] = { ["specialw"] = L.oneTrain, ["speciali"] = L.oneRandom, [2] = L.Train, [4] = L.Train },--+15 after 23? (6:22). Lane 4, but if reinforcements aren't dead from wave 23, lane 2 (because reinforcements cart still blocking lane 4) Not Actually random. But detecting if reinforcement cart still in way impossible :\
	[25] = { [1] = L.Train },--+20 after 24 (6:42)
	[26] = { [1] = Cannon, [4] = Reinforcements },--+10 after 25 (6:52)
	[27] = { [2] = L.Train },--+15 after 26 (7:07)
	[28] = { [3] = L.Train },--+10 after 27 (7:17)
	[29] = { [3] = ManOArms },--+20 after 28 (7:37)
	[30] = { [1] = L.Train, [4] = L.Train },--+5 after 29 (7:42) 
	[31] = { [4] = L.Train },--+15 after 30 (7:57) (guessed.)--seems berserk. 4 L.Trains in a row (interval 4 sec.)
	[32] = { [3] = L.Train },--+4 after 31 (8:01)
	[33] = { [2] = L.Train },--+4 after 32 (8:05)
	[34] = { [1] = L.Train },--+4 after 33 (8:09)
	[35] = { [1] = L.Train, [2] = L.Train, [3] = L.Train, [4] = L.Train },--+? after 34 (8:??)
}

local function fakeTrainYell(self)
	self:CHAT_MSG_MONSTER_YELL("Fake", nil, nil, nil, L.Train)
	DBM:Debug("Fake yell fired, Boss skipped a yell?")
end

--  Voicelist
--	A: just rushing through the lane(express)
--	B: small Adds(Reinforcements)
--	C: cannon
--	D: big Adds (ManOArms)
--	E: fire(Deforester) 
--	F: random express (3x TrainType A)
--	X: random rail

local mythicVoice = {
	[1] = "D4",
	[2] = "E1",
	[3] = "A2",
	[4] = "A3",
	[5] = "F",
	[6] = "F",
	[7] = "C14",
	[8] = "A2",
	[9] = "A3",
	[10] = "B23",
	[11] = "A14",
	[12] = "E4",
	[13] = "E1",
	[14] = "A3",
	[15] = "A23",
	[16] = "F",
	[17] = "F",
	[18] = "D1C4",
	[19] = "E1A23",
	[20] = "A23",
	[21] = "B2D3",
	[22] = "A14",
	[23] = "A23",
	[24] = "F",
	[25] = "F",
	[26] = "B4",
	[27] = "C1",
	[28] = "E23",
	[29] = "A14",
	[30] = "B1E4",
	[31] = "A2",
	[32] = "E3",
	[33] = "A2",
	[34] = "D1",
	[35] = "F",
}

local otherVoice = {
	[1] = "A4",
	[2] = "A2",
	[3] = "B1",
	[4] = "A3",
	[5] = "C4",
	[6] = "A2",
	[7] = "D3",
	[8] = "A1",
	[9] = "B23",
	[10] = "A14",
	[11] = "C1",
	[12] = "A2",
	[13] = "B4",
	[14] = "A3",
	[15] = "A2",
	[16] = "A1",
	[17] = "D2C4",
	[18] = "A1",
	[19] = "A3",
	[20] = "C14",
	[21] = "A2",
	[22] = "A2",
	[23] = "B2D3",
	[24] = "AX",
	[25] = "A1",
	[26] = "C1D4",--Don't worry, B14 will be used on mythic i'm sure. sorry about this messup
	[27] = "A2",
	[28] = "A3",
	[29] = "D3",
	[30] = "A14",
	[31] = "A4",
	[32] = "A3",
	[33] = "A2",
	[34] = "A1",
}

local lfrVoice = {
	[1] = "A4",
	[2] = "A2",
	[3] = "B1",
	[4] = "A3",
	[5] = "C4",
	[6] = "A2",
	[7] = "D3",
	[8] = "A1",
	[9] = "B3",
	[10] = "A14",
	[11] = "C1",
	[12] = "A2",
	[13] = "B4",
	[14] = "A3",
	[15] = "A2",
	[16] = "A1",
	[17] = "D2C4",
	[18] = "A1",
	[19] = "A3",
	[20] = "C14",
	[21] = "A2",
	[22] = "A2",
	[23] = "B2D3",
	[24] = "AX",
	[25] = "A1",
	[26] = "C1D4",--Don't worry, B14 will be used on mythic i'm sure. sorry about this messup
	[27] = "A2",
	[28] = "A3",
	[29] = "D3",
	[30] = "A14",
	[31] = "A4",
	[32] = "A3",
	[33] = "A2",
	[34] = "A1",
}

local function showTrainWarning(self)
	local text = ""
	local textTable = {}
	local usedv = {}
	local train = self.vb.trainCount
	local trainTable = self:IsMythic() and mythicTrains or self:IsLFR() and lfrTrains or otherTrains
	if trainTable[train] then
		if trainTable[train]["specialw"] then
			text = text .. trainTable[train]["specialw"]..", "
		else
			for i = 1, 4 do
				if trainTable[train][i] then
					if not usedv[trainTable[train][i]] then
						usedv[trainTable[train][i]] = #textTable + 1
						local t = { vehicle = trainTable[train][i], lane = L.lane.." "..i }
						table.insert(textTable, t)
					else
						local t = textTable[usedv[trainTable[train][i]]]
						t.lane = t.lane..", "..i
					end
				end
			end
		end
	end
	for i = 1, #textTable do
		local t = textTable[i]
		text = text..t.lane..": "..t.vehicle..", "
	end
	text = string.sub(text, 1, text:len() - 2)
	text = "noStrip |cffffff9a"..text.."|r"
	warnTrain:Show(train, text)
end

local function lanePos(self)
	if self:HasMapRestrictions() then return 0 end
	local posX = UnitPosition("player")--room is perfrect square, y coord not needed.
	local playerLane
	-- map coord from http://mysticalos.com/images/DBM/ThogarData/1.jpeg http://mysticalos.com/images/DBM/ThogarData/2.jpeg http://mysticalos.com/images/DBM/ThogarData/3.jpeg http://mysticalos.com/images/DBM/ThogarData/4.jpeg
	if posX > 577.8 then
		playerLane = 1
	elseif posX > 553.8 then
		playerLane = 2
	elseif posX > 529.6 then
		playerLane = 3
	else
		playerLane = 4
	end
	return playerLane
end

local function laneCheck(self)
	if self:HasMapRestrictions() then return end
	local TrainTable = self:IsMythic() and mythicTrains or self:IsLFR() and lfrTrains or otherTrains
	local train = self.vb.trainCount
	local playerLane = lanePos(self)
	if TrainTable[train] and TrainTable[train][playerLane] then
		specWarnTrain:Show()
		specWarnTrain:Play("chargemove")
	end
end

local lines = {}
local sortedLines = {}
local function addLine(key, value)
	-- sort by insertion order
	lines[key] = value
	sortedLines[#sortedLines + 1] = key
end
local function updateInfoFrame()
	table.wipe(lines)
	table.wipe(sortedLines)
	local train = mod.vb.infoCount
	local TrainTable = mod:IsMythic() and mythicTrains or mod:IsLFR() and lfrTrains or otherTrains
	if TrainTable[train] then
		--local playerLane = lanePos(mod)
		for i = 1, 4 do
			--local lanetext = (playerLane == i and "|cff00ffff" or "")..L.lane.." "..i..(playerLane == i and "|r" or "")
			if TrainTable[train][i] then
				addLine(L.lane..i, TrainTable[train][i])
			else
				addLine(L.lane..i, "")
			end
		end
		if TrainTable[train]["speciali"] then
			addLine(TrainTable[train]["speciali"], "")
		end
	else
		addLine(DBM_CORE_UNKNOWN, "")
	end
	return lines, sortedLines
end

--Work In Progress
--Timing may need tweaks. more Moves need adding.
--Positions based on https://www.youtube.com/watch?v=0QC7BOEv2iE
local function showHud(self, Train, center)
	if self.Options.HudMapForTrain and not self:HasMapRestrictions() then
		local Red, Green, Blue = 1, 1, 1
		local hudType = nil
		if not self.Options.HudMapUseIcons then
			hudType = "highlight"
			Red, Green, Blue = 0, 1, 0
		end
		DBMHudMap:FreeEncounterMarkerByTarget(176312, "TrainHelper")--Clear any current icon, before showing next move
		--Regular Lane movements
		local specialPosition = center and 3314 or self:IsMelee() and 3328 or 3300--Melee west, ranged east, unless center is passed then center
		if Train == 9 then--Move to Circle (1)
			if not hudType then hudType = "circle" end
			if center then
				DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 590, 3314, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			else
				--East (where adds jump down, everyone goes west on this move)
				DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 590, 3300, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			end
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm2")
			end
		elseif Train == 8 or Train == 11 or Train == 19.25 then--Move to diamond (2)
			if not hudType then hudType = "diamond" end
			DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 566, specialPosition, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm3")
			end
		elseif Train == 1 or Train == 7 or Train == 15 or Train == 21 or Train == 23 or Train == 26 or Train == 28.5 then--Move to triangle (3)
			if not hudType then hudType = "triangle" end
			if Train == 1 then
				specialPosition = self:IsMelee() and 3300 or 3328--Only Train that does reverse specialPosition
				DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 542, specialPosition, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			else
				DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 542, specialPosition, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			end
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm4")
			end
		elseif Train == 20 or Train == 22 then--Move to Moon (4)
			if not hudType then hudType = "moon" end
			DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 517, specialPosition, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm5")
			end
		--Special lane movements (usually corners)
		elseif Train == 2 or Train == 28 then--Move to Cross (2 special corner)
			if not hudType then hudType = "cross" end
			DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 566, 3277, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm7")
			end
		elseif Train == 14 or Train == 32 then--Move to skull (4 special corner)
			if not hudType then hudType = "skull" end
			DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 517, 3353, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm8")
			end
		elseif Train == 17 then--Ranged and melee go to different lanes to avoid fire in on melee/adds in diamond while ranged kill cannon at triangle
			if self:IsMelee() then--Move to diamond for man at arms Train
				if not hudType then hudType = "diamond" end
				DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 566, 3332, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
				if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
					warnTrain:Play("mm3")
				end
			else--Move to triangle for Cannon
				if not hudType then hudType = "triangle" end
				DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 544, 3314, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
				if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
					warnTrain:Play("mm4")
				end
			end
		elseif Train == 19 then-- (1 special corner)
			if not hudType then hudType = "square" end
			DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 590, 3352, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm6")
			end
		elseif Train == 19.5 then----Move to star, also during Train count 19, but later
			if not hudType then hudType = "star" end
			DBMHudMap:RegisterPositionMarker(176312, "TrainHelper", hudType, 590, 3272, 3.5, 12, Red, Green, Blue, 0.5):Pulse(0.5, 0.5)
			if self.Options.TrainVoiceAnnounce ~= "LanesOnly" then
				warnTrain:Play("mm1")
			end
		end
	end
end

local function showInfoFrame(self)
	if self.Options.InfoFrame then
		self.vb.infoCount = self.vb.trainCount + 1
		DBM.InfoFrame:SetHeader(MovingTrain.." ("..(self.vb.infoCount)..")")
		DBM.InfoFrame:Show(5, "function", updateInfoFrame)
	end
end

--/run DBM:GetModByName(1147):test(4)
function mod:test(num)
	self.vb.trainCount = num
	showTrainWarning(self)
	laneCheck(self)
	showInfoFrame(self)
end

function mod:BombTarget(targetname, uId, bossuId)
	if not targetname then return end
	warnDelayedSiegeBomb:CombinedShow(0.5, targetname)
	if targetname == UnitName("player") then
		specWarnDelayedSiegeBomb:Show()
		specWarnDelayedSiegeBomb:Play("bombrun")
		local _, _, _, startTime, endTime = UnitCastingInfo(bossuId)
		local time = ((endTime or 0) - (startTime or 0)) / 1000
		if time then
			specWarnDelayedSiegeBombMove:Schedule(time - 0.5, 1)
			timerDelayedSiegeBomb:Start(time, 1)
		else
			specWarnDelayedSiegeBombMove:Schedule(4.4, 1)
			timerDelayedSiegeBomb:Start(4.9, 1)
		end
	end
end

function mod:GrenadeTarget(targetname, uId)
	if not targetname then
		warnProtoGrenade:Show(DBM_CORE_UNKNOWN)
		return
	end
	if targetname == UnitName("player") then
		yellProtoGrenade:Yell()
		if self:AntiSpam(1.5, 5) then
			specWarnProtoGrenade:Show()
			specWarnProtoGrenade:Play("runaway")
		end
	elseif self:CheckNearby(5, targetname) then
		specWarnProtoGrenadeNear:Show(targetname)
		specWarnProtoGrenadeNear:Play("runaway")
	else
		warnProtoGrenade:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	fakeYellTime = 0
	bombFrom = nil
	self.vb.trainCount = 0
	self.vb.infoCount = 0
	timerProtoGrenadeCD:Start(6-delay)
	if not self.Options.ShowedThogarMessage then
		DBM:AddMsg(L.helperMessage)
		self.Options.ShowedThogarMessage = true
	end
	if self:IsMythic() then
		self:Schedule(9.5, fakeTrainYell, self)
		timerTrainCD:Start(12-delay, 1)
		berserkTimer:Start()
		showHud(self, 1)
	else
		self:Schedule(14.5, fakeTrainYell, self)
		timerTrainCD:Start(17-delay, 1)
	end
	showInfoFrame(self)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 155864 and self:AntiSpam(2, 4) then
		self:BossTargetScanner(76906, "GrenadeTarget", 0.02, 50, true, nil, nil, nil, true)
		timerProtoGrenadeCD:Start()
	elseif spellId == 159481 and args:IsPlayer() then
		bombFrom = args.sourceGUID
		specWarnDelayedSiegeBomb:Play("keepmoving")
		yellDelayedSiegeBomb:Yell(1)
		specWarnDelayedSiegeBombMove:Show()
		timerDelayedSiegeBomb:Start(3, 2)
		yellDelayedSiegeBomb:Schedule(3, 2)
		specWarnDelayedSiegeBombMove:Schedule(2.5)
		timerDelayedSiegeBomb:Schedule(3, 3, 3)
		yellDelayedSiegeBomb:Schedule(6, 3)
		specWarnDelayedSiegeBombMove:Schedule(5.5)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 160140 and self:CheckInterruptFilter(args.sourceGUID) then
		specWarnCauterizingBolt:Show(args.sourceName)
	elseif spellId == 163753 then
		if self:AntiSpam(3, 1) then
			specWarnIronbellow:Show()
		end
		timerIronbellowCD:Start(nil, args.sourceGUID)
	elseif spellId == 159481 then
		self:BossTargetScanner(args.sourceGUID, "BombTarget", 0.05, 25)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 155921 then
		local amount = args.amount or 1
		timerEnkindleCD:Start()
		if amount >= 2 then
			if args:IsPlayer() then
				specWarnEnkindle:Show(amount)
				specWarnEnkindle:Play("stackhigh")
			else--Taunt as soon as stacks are clear, regardless of stack count.
				local _, _, _, _, duration, expires = DBM:UnitDebuff("player", args.spellName)
				local debuffTime = 0
				if expires then
					debuffTime = expires - GetTime()
				end
				if debuffTime < 12 and not UnitIsDeadOrGhost("player") then--No debuff, or debuff will expire before next cast.
					specWarnEnkindleOther:Show(args.destName)
					specWarnEnkindleOther:Play("tauntboss")
				else
					warnEnkindle:Show(args.destName, amount)
				end
			end
		else
			warnEnkindle:Show(args.destName, amount)
		end
	elseif spellId == 165195 and args:IsPlayer() and self:AntiSpam(1.5, 5) then
		specWarnProtoGrenade:Show()
		specWarnProtoGrenade:Play("runaway")
	--Applied debuffs, not damage. Damage occurs for 15 seconds even when player moves out of it, but player gains stack of debuff every second standing in fire.
	elseif spellId == 164380 and args:IsPlayer() and self:AntiSpam(2, 3) then
		local amount = args.amount or 1
		if amount >= 2 then
			specWarnBurning:Show(amount)
		end
	elseif spellId == 160140 and (args:GetDestCreatureID() == 80791 or args:GetDestCreatureID() == 77487) then--Mender or Man at arms. Filter the rest
		specWarnCauterizingBoltDispel:CombinedShow(0.3, args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 80791 then
		timerIronbellowCD:Cancel(args.destGUID)
	elseif bombFrom and args.destGUID == bombFrom then
		yellDelayedSiegeBomb:Cancel()
		specWarnDelayedSiegeBombMove:Cancel()
		timerDelayedSiegeBomb:Cancel()
		timerDelayedSiegeBomb:Unschedule()--Redundant?
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg, npc, _, _, target)
	local TrainLimit = self:IsMythic() and 36 or 35
	if target == L.Train and self.vb.trainCount <= TrainLimit then
		local adjusted = (GetTime() - fakeYellTime) < 2-- yell followed by fakeyell within 2 sec. this should realyell of scheduled fakeyell. so do not increase count and only do adjust.
		local fakeAdjust = 0
		self:Unschedule(fakeTrainYell)--Always unschedule
		if not adjusted then--do not adjust visible warn to prevent confusing. (although fakeyell worked early, maximum 3.5 sec. this is no matter. only adjust scheduled things.)
			self.vb.trainCount = self.vb.trainCount + 1
			showTrainWarning(self)
			if msg == "Fake" then
				laneCheck(self)
				fakeAdjust = 1.5
			else
				self:Schedule(1.5, laneCheck, self)
			end
		end
		self:Unschedule(showInfoFrame)
		local expectedTime
		local count = self.vb.trainCount
		if self:IsMythic() then
			if mythicVoice[count] and not adjusted and self.Options.TrainVoiceAnnounce ~= "MovementsOnly" then
				warnTrain:Play("Thogar\\"..mythicVoice[count])
			end
			if count == 1 or count == 2 or count == 11 or count == 12 or count == 13 or count == 25 or count == 26 or count == 31 then
				expectedTime = 5
				if count == 11 or count == 26 then
					showHud(self, count)
				elseif count == 2 then
					self:Schedule(14-fakeAdjust, showHud, self, count)
				end
			elseif count == 6 or count == 14 or count == 22 or count == 30 or count == 32 or count == 34 then
				expectedTime = 10
				if count == 14 then
					self:Schedule(10-fakeAdjust, showHud, self, count)
				elseif count == 22 then
					self:Schedule(8-fakeAdjust, showHud, self, count)
				elseif count == 30 then
					showHud(self, count)
				elseif count == 32 then
					self:Schedule(4-fakeAdjust, showHud, self, count)
				end
			elseif count == 3 or count == 5 or count == 7 or count == 8 or count == 16 or count == 17 or count == 20 or count == 23 or count == 24 or count == 29 or count == 33 then
				expectedTime = 15
				if count == 7 then
					showHud(self, count)
				elseif count == 8 then
					self:Schedule(12-fakeAdjust, showHud, self, count)
				elseif count == 17 or count == 23 then
					self:Schedule(10-fakeAdjust, showHud, self, count)
				elseif count == 20 then
					specWarnSplitSoon:Cancel()
					specWarnSplitSoon:Schedule(5-fakeAdjust)
					specWarnSplitSoon:ScheduleVoice(5-fakeAdjust, "mobsoon")
					self:Schedule(7, showHud, self, count)
				end
			elseif count == 4 or count == 15 or count == 18 or count == 19  or count == 21 or count == 27 or count == 28 then
				expectedTime = 20
				if count == 15 then
					self:Schedule(12-fakeAdjust, showHud, self, count)
				elseif count == 19 then
					showHud(self, count)
					self:Schedule(12, showHud, self, 19.25, true)--Group up center for deforester movement, after square.
					self:Schedule(20, showHud, self, 19.5)
				elseif count == 21 then
					self:Schedule(17, showHud, self, count)
				elseif count == 28 then
					showHud(self, count)
					self:Schedule(19, showHud, self, 28.5)
				end
			elseif count == 10 then
				expectedTime = 25
			elseif count == 9 then
				expectedTime = 35
				specWarnSplitSoon:Cancel()
				specWarnSplitSoon:CancelVoice()
				specWarnSplitSoon:Schedule(25)--10 is a split, pre warn 10 seconds before 10
				specWarnSplitSoon:ScheduleVoice(25, "mobsoon")
				self:Schedule(30-fakeAdjust, showHud, self, count)--hud marker 5 seconds before split. later you move the better the bomb placements.
			end
			if expectedTime then
				if msg == "Fake" then
					fakeYellTime = GetTime()
					expectedTime = expectedTime - 1.5
				end
				self:Schedule(expectedTime + 1.5, fakeTrainYell, self)--Schedule fake yell 1.5 seconds after we should have seen one.
				timerTrainCD:Unschedule(count+1)
				timerTrainCD:Schedule(5, expectedTime, count+1)
			end
			if (count == 1 or count == 18 or count == 21 or count == 34) and not adjusted then
				specWarnManOArms:Show()
				if self.Options.SetIconOnAdds then
					self:ScanForMobs(80791, 0, 8, 2, 0.2, 15)--Man At Arms scanner marking 8 down
					self:ScanForMobs(77487, 1, 1, 2, 0.2, 15)--Fire Mender scanner marking 1 up
				end
			end
		else
			local whatVoice = self:IsLFR() and lfrVoice[count] or otherVoice[count]
			--Add Trainvoiceanounce check only when actual movements are added to non mythic
			if whatVoice and not adjusted then--and self.Options.TrainVoiceAnnounce ~= "MovementsOnly"
				warnTrain:Play("Thogar\\"..whatVoice)
			end
			if count == 31 or count == 32 or count == 33 then
				expectedTime = 4
			elseif count == 2 or count == 4 or count == 6 or count == 18  or count == 29 then
				expectedTime = 5
			elseif count == 1 or count == 10 or count == 12 or count == 14 or count == 15 or count == 20 or count == 25 or count == 27 then
				expectedTime = 10
			elseif count == 3 or count == 8 or count == 11 or count == 16 or count == 23 or count == 26 or count == 30 then
				expectedTime = 15
				if not self:IsLFR() and count == 8 then
					specWarnSplitSoon:Cancel()
					specWarnSplitSoon:CancelVoice()
					specWarnSplitSoon:Schedule(5)
					specWarnSplitSoon:ScheduleVoice(5, "mobsoon")
				end
			elseif count == 13 or count == 17 or count == 24 or count == 28 then
				expectedTime = 20
			elseif count == 5 or count == 7 or count == 21 then
				expectedTime = 25
			elseif count == 19 or count == 22 then
				expectedTime = 30
				if not self:IsLFR() and count == 22 then
					specWarnSplitSoon:Cancel()
					specWarnSplitSoon:CancelVoice()
					specWarnSplitSoon:Schedule(20)
					specWarnSplitSoon:ScheduleVoice(20, "mobsoon")
				end
			elseif count == 9 then
				expectedTime = 40
			end
			if expectedTime then
				if msg == "Fake" then
					fakeYellTime = GetTime()
					expectedTime = expectedTime - 1.5
				end
				self:Schedule(expectedTime + 1.5, fakeTrainYell, self)--Schedule fake yell 1.5 seconds after we should have seen one.
				timerTrainCD:Unschedule(count+1)
				timerTrainCD:Schedule(5, expectedTime, count+1)
			end
			if (count == 7 or count == 17 or count == 23 or count == 28) and not adjusted then--I'm sure they spawn again sometime later, find that data
				specWarnManOArms:Show()
				if self.Options.SetIconOnAdds then
					self:ScanForMobs(80791, 0, 8, 2, 0.2, 15)--Man At Arms scanner marking 8 down
					self:ScanForMobs(77487, 1, 1, 2, 0.2, 15)--Fire Mender scanner marking 1 up
				end
			end
		end
		if self.Options.InfoFrameSpeed == "Delayed" then
			local adjust = 0
			if msg == "Fake" then
				if expectedTime and expectedTime == 4 then adjust = 1 end
				self:Schedule(2.5-adjust, showInfoFrame, self)
			else
				self:Schedule(4-adjust, showInfoFrame, self)
			end
		else
			showInfoFrame(self)
		end
	end
end
