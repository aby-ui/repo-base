local GlobalAddonName, ExRT = ...

--- ded module, RIP 2013 - 2017

local UnitAura, UnitIsDeadOrGhost, UnitIsConnected, UnitPower, UnitGUID, UnitName, UnitPosition, UnitInRange, UnitIsUnit, UnitClass = UnitAura, UnitIsDeadOrGhost, UnitIsConnected, UnitPower, UnitGUID, UnitName, UnitPosition, UnitInRange, UnitIsUnit, UnitClass
local GetTime, tonumber, tostring, sort, wipe, PI, pairs, type = GetTime, tonumber, tostring, table.sort, table.wipe, PI, pairs, type
local cos, sin, sqrt, acos, abs, floor, min, max, atan, GGetPlayerMapPosition, GGetPlayerFacing, GetNumGroupMembers = math.cos, math.sin, math.sqrt, acos, math.abs, math.floor, math.min, math.max, atan, GetPlayerMapPosition, GetPlayerFacing, GetNumGroupMembers
local ClassColorNum, SetMapToCurrentZone, GetCurrentMapAreaID, GetCurrentMapDungeonLevel, GetRaidRosterInfo, GetMobID, RAID_CLASS_COLORS, table_len, GetUnitTypeByGUID, delUnitNameServer = ExRT.F.classColorNum, SetMapToCurrentZone, GetCurrentMapAreaID, GetCurrentMapDungeonLevel, GetRaidRosterInfo, ExRT.F.GUIDtoID, RAID_CLASS_COLORS, ExRT.F.table_len, ExRT.F.GetUnitTypeByGUID, ExRT.F.delUnitNameServer

local VExRT = nil

local module = ExRT.mod:New("Bossmods",ExRT.L.bossmods,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.A = {}
-----------------------------------------
-- functions
-----------------------------------------

local function RaidRank()
	local n = UnitInRaid("player") or 0
	local name,rank = GetRaidRosterInfo(n)
	if name then
		return rank
	end
	return 0
end

local GetPlayerMapPosition = nil
do
	local currentMap = 0
	local currentMapLevel = 0
	function GetPlayerMapPosition(...)
		local nowMap = GetCurrentMapAreaID()
		local nowMapLevel = GetCurrentMapDungeonLevel()
		if currentMap ~= nowMap or currentMapLevel ~= nowMapLevel then
			SetMapToCurrentZone()
			currentMap = GetCurrentMapAreaID()
			currentMapLevel = GetCurrentMapDungeonLevel()
		end
		return GGetPlayerMapPosition(...)
	end
end
local function GetPlayerFacing()
	return GGetPlayerFacing() or 0
end

-----------------------------------------
-- Ра-ден
-----------------------------------------
local RaDen = {}
module.A.RaDen = RaDen

RaDen.mainframe = nil
RaDen.party = nil
RaDen.unstableVita_id1 = 138308
RaDen.unstableVita_id2 = 138297
RaDen.vitaSensitivity_id = 138372

function RaDen:RefreshAll()
	local n = GetNumGroupMembers() or 0
	if n > 0 then
		local grps = {0,0,0,0}
		for j=1,n do
			local name,_,subgroup = GetRaidRosterInfo(j)
			if name and subgroup == 2 then
				grps[1] = grps[1] + 1
				RaDen.party[1][grps[1]] = name
			elseif name and subgroup == 4 then
				grps[2] = grps[2] + 1
				RaDen.party[2][grps[2]] = name
			elseif name and subgroup == 3 then
				grps[3] = grps[3] + 1
				RaDen.party[3][grps[3]] = name
			elseif name and subgroup == 5 then
				grps[4] = grps[4] + 1
				RaDen.party[4][grps[4]] = name
			end
		end
		for i=1,4 do
			for j=(grps[i]+1),5 do
				RaDen.party[i][j] = ""
			end
			sort(RaDen.party[i])
			for j=1,5 do
				RaDen.mainframe.names[(i-1)*5+j].text:SetText(RaDen.party[i][j])
			end
		end
	end
end

function RaDen:timerfunc(elapsed)
	self.tmr = self.tmr + elapsed
	if self.tmr > 0.2 then
		self.tmr = 0
		for i=1,4 do
			for j=1,5 do
				if RaDen.party[i][j] and RaDen.party[i][j] ~= "" then
					local white = true
					for k=1,40 do
						local _,_,_,_,_,duration,expires,_,_,_,spellId = UnitAura(RaDen.party[i][j],k,"HARMFUL")
						if spellId == RaDen.unstableVita_id1 or spellId == RaDen.unstableVita_id2 then
							RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(0.5, 1, 0.5, 1)
							white = nil
						elseif spellId == RaDen.vitaSensitivity_id then
							RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(1, 0.5, 0.5, 1)
							white = nil
						elseif not spellId then 
							break
						end
					end
					if white then
						RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(1, 1, 1, 1)
					end
					if UnitIsDeadOrGhost(RaDen.party[i][j]) or not UnitIsConnected(RaDen.party[i][j]) then
						RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(1, 0.5, 0.5, 1)
					end
				else
					RaDen.mainframe.names[(i-1)*5+j].text:SetTextColor(0.1, 0.1, 0.1, 1)
				end
			end
		end
	end
end

function RaDen:EventHandler(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _,event_n,_,_,_,_,_,_,_,_,_,spellId = ...
		if event_n == "SPELL_AURA_APPLIED" and (spellId == RaDen.unstableVita_id1 or spellId == RaDen.unstableVita_id2) then
			RaDen.mainframe.vitacooldown.cooldown:SetCooldown(GetTime(), 5)
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		RaDen:RefreshAll()
	end
end

function RaDen:Load()
	if not RaDen.mainframe then
		RaDen.mainframe = CreateFrame("Frame","ExRTBossmodsRaden",UIParent)
		RaDen.mainframe:SetHeight(130)
		RaDen.mainframe:SetWidth(160)
		if VExRT.Bossmods.RaDenLeft and VExRT.Bossmods.RaDenTop then
			RaDen.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.RaDenLeft,VExRT.Bossmods.RaDenTop)
		else
			RaDen.mainframe:SetPoint("TOP",UIParent, "TOP", 0, -50)
		end
		RaDen.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
		RaDen.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
		RaDen.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
		RaDen.mainframe:EnableMouse(true)
		RaDen.mainframe:SetMovable(true)
		RaDen.mainframe:RegisterForDrag("LeftButton")
		RaDen.mainframe:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
			end
		end)
		RaDen.mainframe:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			VExRT.Bossmods.RaDenLeft = self:GetLeft()
			VExRT.Bossmods.RaDenTop = self:GetTop()
		end)
		if VExRT.Bossmods.Alpha then RaDen.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
		if VExRT.Bossmods.Scale then RaDen.mainframe:SetScale(VExRT.Bossmods.Scale/100) end
		
		RaDen.mainframe.tmr = 0

		RaDen.mainframe.names = {}

		for i=1,20 do
			RaDen.mainframe.names[i]=CreateFrame("Frame",nil,RaDen.mainframe)
			RaDen.mainframe.names[i]:SetSize(80,12)
			RaDen.mainframe.names[i]:SetPoint("TOPLEFT", (math.floor((i-1)/10))*80, -(((i-1)%10)*12)-5)
			RaDen.mainframe.names[i].text = RaDen.mainframe.names[i]:CreateFontString(nil,"ARTWORK")
			RaDen.mainframe.names[i].text:SetJustifyH("CENTER")
			RaDen.mainframe.names[i].text:SetFont(ExRT.F.defFont, 12,"OUTLINE")
			local b = GetNumGuildMembers()
			local a
			if b == 0 then 
				a = UnitName("player")
			else 
				a = GetGuildRosterInfo(math.random(1,b)) 
			end
			RaDen.mainframe.names[i].text:SetText(a)
			if i%3==0 then RaDen.mainframe.names[i].text:SetTextColor(1, 0.5, 0.5, 1) end
			if i%3==1 then RaDen.mainframe.names[i].text:SetTextColor(0.5, 1, 0.5, 1) end
			if i%3==2 then RaDen.mainframe.names[i].text:SetTextColor(1, 1, 1, 1) end
			RaDen.mainframe.names[i].text:SetAllPoints()
		end

		RaDen.mainframe.vitacooldown = CreateFrame("Frame",nil,RaDen.mainframe)
		RaDen.mainframe.vitacooldown:SetHeight(32)
		RaDen.mainframe.vitacooldown:SetWidth(32)
		RaDen.mainframe.vitacooldown:SetPoint("TOPLEFT", 0, -130)
		RaDen.mainframe.vitacooldown.tex = RaDen.mainframe.vitacooldown:CreateTexture(nil, "BACKGROUND")
		local tx = GetSpellTexture(RaDen.unstableVita_id2)
		RaDen.mainframe.vitacooldown.tex:SetTexture(tx)
		RaDen.mainframe.vitacooldown.tex:SetAllPoints()
		RaDen.mainframe.vitacooldown.cooldown = CreateFrame("Cooldown", nil, RaDen.mainframe.vitacooldown)
		RaDen.mainframe.vitacooldown.cooldown:SetAllPoints()

		RaDen.party = {}
		for i=1,4 do RaDen.party[i]={} end
		RaDen:RefreshAll()

		RaDen.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
		RaDen.mainframe:RegisterEvent("GROUP_ROSTER_UPDATE")
		RaDen.mainframe:SetScript("OnUpdate", RaDen.timerfunc)
		RaDen.mainframe:SetScript("OnEvent", RaDen.EventHandler)

		print(L.bossmodsradenhelp)
	end
end

-----------------------------------------
-- Sha of Pride
-----------------------------------------
local ShaOfPride = {}
module.A.ShaOfPride = ShaOfPride

ShaOfPride.mainframe = nil
ShaOfPride.raid = {}
ShaOfPride.norushen = nil

function ShaOfPride:SetTextColor(j,c_r,c_g,c_b,c_a)
	ShaOfPride.mainframe.names[j].text:SetTextColor(c_r, c_g, c_b, c_a)
	ShaOfPride.mainframe.names[j].textr:SetTextColor(c_r, c_g, c_b, c_a)
end

function ShaOfPride.sortFunc(a,b)
	if(a[2]==b[2]) then 
		return a[1] < b[1] 
	else 
		return a[2] > b[2] 
	end
end

function ShaOfPride:timerfunc(elapsed)
	self.tmr = self.tmr + elapsed
	if self.tmr > 0.3 then
		self.tmr = 0
		for j=1,#ShaOfPride.raid do
			ShaOfPride.raid[j][2] = UnitPower(ShaOfPride.raid[j][1],10) or 0
		end
		sort(ShaOfPride.raid,ShaOfPride.sortFunc)
		for j=1,#ShaOfPride.raid do
			ShaOfPride.mainframe.names[j].text:SetText(ShaOfPride.raid[j][1])
			ShaOfPride.mainframe.names[j].textr:SetText(ShaOfPride.raid[j][2])
			if ShaOfPride.norushen == 1 then
				if ShaOfPride.raid[j][2]>=100 then ShaOfPride:SetTextColor(j, 1, 0.3, 0.3, 1)
					elseif ShaOfPride.raid[j][2]>=75 then ShaOfPride:SetTextColor(j, 1, 1, 0.2, 1)
					else ShaOfPride:SetTextColor(j, 1, 1, 1, 1) end
				for i=1,40 do
					local _,_,_,_,_,_,_,_,_,_,spellId = UnitAura(ShaOfPride.raid[j][1], i,"HARMFUL")
					if spellId == 144851 or spellId == 144849 or spellId == 144850 then ShaOfPride:SetTextColor(j, 0.5, 1, 0.3, 1) break
						elseif not spellId then break end
				end
			elseif ShaOfPride.norushen == 2 then
				if ShaOfPride.raid[j][2]>=100 then ShaOfPride:SetTextColor(j, 0.8, 0.3, 0.8, 1)
					elseif ShaOfPride.raid[j][2]>=75 then ShaOfPride:SetTextColor(j, 0.5, 0.5, 1, 1)
					elseif ShaOfPride.raid[j][2]>=50 then ShaOfPride:SetTextColor(j, 1, 0.3, 0.3, 1)
					elseif ShaOfPride.raid[j][2]>=25 then ShaOfPride:SetTextColor(j, 1, 1, 0.2, 1)
					else ShaOfPride:SetTextColor(j, 1, 1, 1, 1) end
			elseif ShaOfPride.norushen == 3 then
				if UnitAura(ShaOfPride.raid[j][1],ShaOfPride.xaviusSpell,nil,"HARMFUL") then
					ShaOfPride:SetTextColor(j, .3, 1, .3, 1)
				else
					ShaOfPride:SetTextColor(j, 1, 1, 1, 1)
				end
			else
				ShaOfPride:SetTextColor(j, 1, 1, 1, 1)
			end
		end
	end
end

function ShaOfPride:RefreshAll()
	local n = GetNumGroupMembers() or 0
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	if n > 0 then
		wipe(ShaOfPride.raid)
		for j=1,n do
			local name,_,subgroup = GetRaidRosterInfo(j)
			if name and subgroup <= gMax then
				ShaOfPride.raid[#ShaOfPride.raid + 1] = {name,UnitPower(name,10)}
			end
		end
		sort(ShaOfPride.raid,ShaOfPride.sortFunc)
		for j=1,#ShaOfPride.raid do if j<=25 then
			ShaOfPride.mainframe.names[j].text:SetText(ShaOfPride.raid[j][1].." "..tostring(ShaOfPride.raid[j][2]))
		end end
		for j=(#ShaOfPride.raid+1),25 do
			ShaOfPride.mainframe.names[j].text:SetText("")
			ShaOfPride.mainframe.names[j].textr:SetText("")
		end
	else
		for j=1,gMax*5 do
			local b = GetNumGuildMembers()
			local a
			if b == 0 then 
				a = UnitName("player")
			else 
				a = GetGuildRosterInfo(math.random(1,b)) 
			end
			local c = math.random(0,20)*5
			local h = math.random(1,3)
			if h == 3 then a = a..a..a elseif h == 2 then a = a..a end
			ShaOfPride.mainframe.names[j].text:SetText(a)
			ShaOfPride.mainframe.names[j].text:SetTextColor(0.1, 0.1, 0.1, 1)

			ShaOfPride.mainframe.names[j].textr:SetText(tostring(c))
			ShaOfPride.mainframe.names[j].textr:SetTextColor(0.1, 0.1, 0.1, 1)
		end
	end
end

function ShaOfPride:EventHandler(event, ...)
	if event == "GROUP_ROSTER_UPDATE" then
		ShaOfPride:RefreshAll()
	elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
		local bossGUID = UnitGUID("boss1")
		if not bossGUID then 
			return 
		end
		local bossMobID = ExRT.F.GUIDtoID(bossGUID)
		if bossMobID == 72276 then
			ShaOfPride.norushen = 1
		elseif bossMobID == 71734 then
			ShaOfPride.norushen = 2
		elseif bossMobID == 103679 then
			ShaOfPride.norushen = 3
		else
			ShaOfPride.norushen = nil
		end
	end
end

function ShaOfPride:Load()
	if ShaOfPride.mainframe then 
		return 
	end
	ShaOfPride.mainframe = CreateFrame("Frame","ExRTBossmodsShaOfPride",UIParent)
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	ShaOfPride.mainframe:SetSize(100,gMax*5*12+8)
	if VExRT.Bossmods.ShaofprideLeft and VExRT.Bossmods.ShaofprideTop then
		ShaOfPride.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.ShaofprideLeft,VExRT.Bossmods.ShaofprideTop)
	else
		ShaOfPride.mainframe:SetPoint("TOP",UIParent, "TOP", 0, -50)	
	end
	ShaOfPride.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	ShaOfPride.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	ShaOfPride.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	ShaOfPride.mainframe:EnableMouse(true)
	ShaOfPride.mainframe:SetMovable(true)
	ShaOfPride.mainframe:RegisterForDrag("LeftButton")
	ShaOfPride.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	ShaOfPride.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.ShaofprideLeft = self:GetLeft()
		VExRT.Bossmods.ShaofprideTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then ShaOfPride.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then ShaOfPride.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	ShaOfPride.mainframe.tmr = 0

	ShaOfPride.mainframe.names = {}

	for i=1,30 do
		local name = CreateFrame("Frame",nil,ShaOfPride.mainframe)
		ShaOfPride.mainframe.names[i] = name
		name:SetSize(100,12)
		name:SetPoint("TOPLEFT", 0, -((i-1)*12)-4)
		
		name.text = ELib:Text(name):Size(71,12):Point(4,0):Top():Font(ExRT.F.defFont,12):Outline():Color(1,1,1)
		name.textr = ELib:Text(name):Size(50,12):Point("TOPRIGHT",-4,0):Top():Right():Font(ExRT.F.defFont,12):Outline():Color(1,1,1)
	end
	
	ShaOfPride.xaviusSpell = GetSpellInfo(206005)

	ShaOfPride:RefreshAll()
	ShaOfPride.mainframe:RegisterEvent("GROUP_ROSTER_UPDATE")
	ShaOfPride.mainframe:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	ShaOfPride.mainframe:SetScript("OnUpdate", ShaOfPride.timerfunc)
	ShaOfPride.mainframe:SetScript("OnEvent", ShaOfPride.EventHandler)
end

-----------------------------------------
-- Malkorok
-----------------------------------------
local Malkorok = {}
module.A.Malkorok = Malkorok

Malkorok.mainframe = nil
Malkorok.tmr = 0
Malkorok.main_coord_top_x = 0.36427
Malkorok.main_coord_top_y = 0.34581
Malkorok.main_coord_bot_x = 0.46707
Malkorok.main_coord_bot_y = 0.50000
Malkorok.unitid = 71454
Malkorok.spell = 142842
Malkorok.spell_baoe = 142861
Malkorok.baoe_num = 0
Malkorok.raid_marks_p = nil
Malkorok.raid_marks_e = nil
Malkorok.rotate = false
Malkorok.center = 90
Malkorok.pie_coord = {
	{{90,90},{90,-5},{0,36}},	--1
	{{90,90},{0,36},{-1,141}},	--2
	{{90,90},{-1,141},{90,185}},	--3
	{{90,90},{90,185},{182,144}},	--4
	{{90,90},{182,144},{185,38}},	--5
	{{90,90},{185,38},{90,-5}},	--6
}
Malkorok.pie_status = {0,0,0,0,0,0,0,0}
Malkorok.def_angle = (PI/180)*8
Malkorok.rotate_coords={tl={x=0,y=0},br={x=180/256,y=180/256}}
Malkorok.rotate_origin={x=90/256,y=90/256}
Malkorok.rotate_angle = 0
Malkorok.maps = {
	--[map]={topX,topY,botX,botY},
	[0]={0.36427,0.34581,0.46707,0.500},
	[807]={0.5157,0.4745,0.5207,0.4853},
	--[807]={0.5168,0.4767,0.5201,0.4844},
	[811]={0.4284,0.4285,0.4426,0.4478},
	[891]={0.4337,0.4589,0.4559,0.5276},
	[492]={0.7361,0.2098,0.7473,0.2264},
	[953]={0.36427,0.34581,0.46707,0.50000},
}
Malkorok.maps_t = {
	--[map]={link,topX,botX,topY,botY},
	--[map]={[MapDungeonLevel]={...},[MapDungeonLevel]={...}},
	--[807]={"Interface\\AddOns\\ExRT\\media\\Bossmods_807",0.22,0.8799,0.2037,0.9167},
	[807]={"Interface\\AddOns\\ExRT\\media\\Bossmods_807"},
	[953]={[8]={"Interface\\AddOns\\ExRT\\media\\Bossmods_953_8",0.293,0.6875,0.293,0.6875}},
}

Malkorok.maps_a = {}

function Malkorok:Danger(u)
	if u and not Malkorok.mainframe.Danger.shown then
		Malkorok.mainframe.Danger:Show() 
		Malkorok.mainframe.Danger.shown = true
		Malkorok.mainframe:SetBackdropColor(0.5,0,0,0.7)
		Malkorok.mainframe:SetBackdropBorderColor(1,0.2,0.2,0.9)
	elseif not u and Malkorok.mainframe.Danger.shown then
		Malkorok.mainframe.Danger:Hide() 
		Malkorok.mainframe.Danger.shown = nil
		Malkorok.mainframe:SetBackdropColor(0,0,0,0.5)
		Malkorok.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	end
end

function Malkorok:PShow()
	if not Malkorok.mainframe then return end 

	Malkorok.raid_marks_e = not Malkorok.raid_marks_e
	Malkorok.raid_marks_p = UnitName("player")

	if not Malkorok.mainframe.raidMarks then
		Malkorok.mainframe.raidMarks = {}
		local mSize = 12
		for i=1,40 do
			Malkorok.mainframe.raidMarks[i] = CreateFrame("Frame",nil,Malkorok.mainframe.main)
			Malkorok.mainframe.raidMarks[i]:SetSize(mSize,mSize)
			Malkorok.mainframe.raidMarks[i]:SetPoint("TOPLEFT", 0, 0)
			Malkorok.mainframe.raidMarks[i]:SetBackdrop({bgFile = "Interface\\AddOns\\ExRT\\media\\blip.tga",tile = true,tileSize = mSize})
			Malkorok.mainframe.raidMarks[i]:SetBackdropColor(0,1,0,0.8)
			Malkorok.mainframe.raidMarks[i]:SetFrameStrata("HIGH")
			Malkorok.mainframe.raidMarks[i]:Hide()
		end
	end
	if not Malkorok.raid_marks_e then
		for i=1,40 do
			Malkorok.mainframe.raidMarks[i]:Hide()
		end
	end
end

function Malkorok:MapNow()
	if not Malkorok.mainframe then return end 
	local mapNow = GetCurrentMapAreaID()
	if not Malkorok.maps_t[mapNow] then return end 
	local mp = Malkorok.maps_t[mapNow]

	local mapNowLevel = GetCurrentMapDungeonLevel()
	if type(Malkorok.maps_t[mapNow][1]) ~= "string" then
		if not mapNowLevel or not Malkorok.maps_t[mapNow][mapNowLevel] then return end
		mp = nil
		mp = Malkorok.maps_t[mapNow][mapNowLevel]
	end

	if not Malkorok.mainframe.main.t then
		Malkorok.mainframe.main.t = Malkorok.mainframe.main:CreateTexture(nil, "BACKGROUND")
		Malkorok.mainframe.main.t:SetAllPoints()
	end

	Malkorok.mainframe.main.t:SetTexture(mp[1])
	Malkorok.mainframe.main.t.xT = mp[2] or 0
	Malkorok.mainframe.main.t.xB = mp[3] or 1
	Malkorok.mainframe.main.t.yT = mp[4] or 0
	Malkorok.mainframe.main.t.yB = mp[5] or 1
	Malkorok.mainframe.main.t.xC = (Malkorok.mainframe.main.t.xB - Malkorok.mainframe.main.t.xT) / 2 + Malkorok.mainframe.main.t.xT
	Malkorok.mainframe.main.t.yC = (Malkorok.mainframe.main.t.yB - Malkorok.mainframe.main.t.yT) / 2 + Malkorok.mainframe.main.t.yT
	Malkorok.mainframe.main.t.r = 1

	for i=1,6 do
		Malkorok.mainframe.pie[i]:Hide()
	end
	Malkorok.def_angle = 0
end

function Malkorok:Cursor()
	local x,y = GetCursorPosition()

	local x1 = Malkorok.mainframe.main:GetLeft()
	local y1 = Malkorok.mainframe.main:GetTop()

	Malkorok.mainframe_scale = Malkorok.mainframe:GetScale()
	local uiparent_scale = UIParent:GetScale()
	x1 = x1 * Malkorok.mainframe_scale*uiparent_scale
	y1 = y1 * Malkorok.mainframe_scale*uiparent_scale

	x = x - x1
	y = -(y - y1)

	x = x / (Malkorok.mainframe_scale * uiparent_scale)
	y = y / (Malkorok.mainframe_scale * uiparent_scale)

	return x,y
end

function Malkorok.RotateCoordPair(x,y,ox,oy,a,asp)
	y=y/asp
	oy=oy/asp
	return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
end

function Malkorok.RotateTexture(self,angle,xT,yT,xB,yB,xC,yC,userAspect)
	local aspect = userAspect or (xT-xB)/(yT-yB)
	local g1,g2 = Malkorok.RotateCoordPair(xT,yT,xC,yC,angle,aspect)
	local g3,g4 = Malkorok.RotateCoordPair(xT,yB,xC,yC,angle,aspect)
	local g5,g6 = Malkorok.RotateCoordPair(xB,yT,xC,yC,angle,aspect)
	local g7,g8 = Malkorok.RotateCoordPair(xB,yB,xC,yC,angle,aspect)

	self:SetTexCoord(g1,g2,g3,g4,g5,g6,g7,g8)
end

do
	if Malkorok.def_angle~=0 then
		for i=1,6 do 
			for j=2,3 do
				Malkorok.pie_coord[i][j][1],Malkorok.pie_coord[i][j][2] = Malkorok.RotateCoordPair(Malkorok.pie_coord[i][j][1],Malkorok.pie_coord[i][j][2],Malkorok.pie_coord[i][1][1],Malkorok.pie_coord[i][1][2],-Malkorok.def_angle,1)
			end 
		end
	end
end

function Malkorok.def_angle_rotate()
	for i=1,6 do		
		Malkorok.RotateTexture(Malkorok.mainframe.pie[i].tex,Malkorok.def_angle,Malkorok.rotate_coords.tl.x,Malkorok.rotate_coords.tl.y,Malkorok.rotate_coords.br.x,Malkorok.rotate_coords.br.y,Malkorok.rotate_origin.x,Malkorok.rotate_origin.y)
	end
end

function Malkorok:findpie(x0,y0,pxy)
	for i=1,6 do
		local x1,y1 = Malkorok.pie_coord[i][1][1],Malkorok.pie_coord[i][1][2]
		local x2,y2 = Malkorok.pie_coord[i][2][1],Malkorok.pie_coord[i][2][2]
		local x3,y3 = Malkorok.pie_coord[i][3][1],Malkorok.pie_coord[i][3][2]
		if Malkorok.rotate and pxy == 1 then
			x2,y2= Malkorok.RotateCoordPair(x2,y2,Malkorok.center,Malkorok.center,-Malkorok.rotate_angle+Malkorok.def_angle,1)
			x3,y3= Malkorok.RotateCoordPair(x3,y3,Malkorok.center,Malkorok.center,-Malkorok.rotate_angle+Malkorok.def_angle,1)
		end

		local r1 = (x1 - x0) * (y2 - y1) - (x2 - x1) * (y1 - y0)
		local r2 = (x2 - x0) * (y3 - y2) - (x3 - x2) * (y2 - y0)
		local r3 = (x3 - x0) * (y1 - y3) - (x1 - x3) * (y3 - y0)

		if (r1>=0 and r2>=0 and r3>=0) or (r1<=0 and r2<=0 and r3<=0) then 
			return i 
		end
	end
	return 0
end

do
	local timerElapsed = 0
	function Malkorok:timerfunc(elapsed)
		timerElapsed = timerElapsed + elapsed
		if timerElapsed > 0.05 then
			timerElapsed = 0
			local px, py = GetPlayerMapPosition("player")
			if px == 0 and py == 0 and not Malkorok.raid_marks_e then return end
			if px >= Malkorok.main_coord_top_x and px<=Malkorok.main_coord_bot_x and py>=Malkorok.main_coord_top_y and py<=Malkorok.main_coord_bot_y then
				if not Malkorok.mainframe.Player.shown then 
					Malkorok.mainframe.Player.shown = 1 
					Malkorok.mainframe.Player:Show() 
				end
				local px1 = (px-Malkorok.main_coord_top_x)/(Malkorok.main_coord_bot_x-Malkorok.main_coord_top_x)*180
				local py1 = (py-Malkorok.main_coord_top_y)/(Malkorok.main_coord_bot_y-Malkorok.main_coord_top_y)*180
	
				local numpie = Malkorok:findpie(px1,py1)
				
				if not Malkorok.rotate then
					Malkorok.mainframe.Player:SetPoint("TOPLEFT", px1 / Malkorok.mainframe.Player.scale -15, -py1 / Malkorok.mainframe.Player.scale +20)
					Malkorok.RotateTexture(Malkorok.mainframe.Player.Texture,GetPlayerFacing(),0,0,1,1,15/32,20/32)
					if Malkorok.mainframe.main.t and Malkorok.mainframe.main.t.r then
						Malkorok.mainframe.main.t:SetTexCoord(Malkorok.mainframe.main.t.xT,Malkorok.mainframe.main.t.xB,Malkorok.mainframe.main.t.yT,Malkorok.mainframe.main.t.yB)
						Malkorok.mainframe.main.t.r = nil
					end
				else
					local h1,h2,h3 = sqrt( (Malkorok.center-px1)^2 + (180-py1)^2 ),sqrt( (Malkorok.center-Malkorok.center)^2 + (180-Malkorok.center)^2 ),sqrt( (Malkorok.center-px1)^2 + (Malkorok.center-py1)^2 )
					local h4 = (h2^2+h3^2-h1^2)/(2*h2*h3)
	
					h4 = acos(h4)
					if px1<Malkorok.center then h4=360-h4 end
					h4 = -h4
					Malkorok.rotate_angle=PI/180*h4 + Malkorok.def_angle
	
					Malkorok.RotateTexture(Malkorok.mainframe.Player.Texture,Malkorok.rotate_angle+GetPlayerFacing()-Malkorok.def_angle,0,0,1,1,15/32,20/32)
					Malkorok.mainframe.Player:SetPoint("TOPLEFT", Malkorok.center / Malkorok.mainframe.Player.scale - 15, (-Malkorok.center - h3)/ Malkorok.mainframe.Player.scale +20)
	
					for i=1,6 do	
						Malkorok.RotateTexture(Malkorok.mainframe.pie[i].tex,Malkorok.rotate_angle,Malkorok.rotate_coords.tl.x,Malkorok.rotate_coords.tl.y,Malkorok.rotate_coords.br.x,Malkorok.rotate_coords.br.y,Malkorok.rotate_origin.x,Malkorok.rotate_origin.y)
					end
	
					if Malkorok.mainframe.main.t then
						Malkorok.RotateTexture(Malkorok.mainframe.main.t,Malkorok.rotate_angle,Malkorok.mainframe.main.t.xT,Malkorok.mainframe.main.t.yT,Malkorok.mainframe.main.t.xB,Malkorok.mainframe.main.t.yB,Malkorok.mainframe.main.t.xC,Malkorok.mainframe.main.t.yC,1)
						Malkorok.mainframe.main.t.r = 1
					end
				end
	
				if not Malkorok.mainframe.main.t then
					if numpie>0 and Malkorok.pie_status[numpie] == 1 then 
						Malkorok:Danger(1)
					elseif numpie==0 or Malkorok.pie_status[numpie] == 0 then
						Malkorok:Danger()
					end
				else
					if Malkorok.maps_a[floor(py1)+1] and Malkorok.maps_a[floor(py1)+1][floor(px1)+1] == 1 then Malkorok:Danger(1) else Malkorok:Danger() end
				end
			else
				if Malkorok.mainframe.Player.shown then 
					Malkorok.mainframe.Player.shown = nil 
					Malkorok.mainframe.Player:Hide() 
				end
				if Malkorok.rotate then
					for i=1,6 do
						Malkorok.mainframe.pie[i].tex:SetTexCoord(0,180/256,0,180/256)
					end	
					Malkorok.rotate_angle = 0
					if Malkorok.def_angle~=0 then Malkorok.def_angle_rotate() end
				end
				Malkorok:Danger()		
			end
	
			local n = GetNumGroupMembers() or 0
			if n > 0 and Malkorok.raid_marks_e then
				for j=1,n do
					local name,_,subgroup,_,_,class = GetRaidRosterInfo(j)
					if name and subgroup <= 5 and not UnitIsDeadOrGhost(name) and UnitIsConnected(name) and name ~= Malkorok.raid_marks_p then
						local px, py = GetPlayerMapPosition(name)
	
						if px >= Malkorok.main_coord_top_x and px<=Malkorok.main_coord_bot_x and py>=Malkorok.main_coord_top_y and py<=Malkorok.main_coord_bot_y then
							local px1 = (px-Malkorok.main_coord_top_x)/(Malkorok.main_coord_bot_x-Malkorok.main_coord_top_x)*180
							local py1 = (py-Malkorok.main_coord_top_y)/(Malkorok.main_coord_bot_y-Malkorok.main_coord_top_y)*180
	
							if Malkorok.rotate then
								px1,py1 = Malkorok.RotateCoordPair(px1,py1,Malkorok.center,Malkorok.center,-Malkorok.rotate_angle+Malkorok.def_angle,1)
							end
				
							local cR,cG,cB = ClassColorNum(class)
							Malkorok.mainframe.raidMarks[j]:SetBackdropColor(cR,cG,cB,1)
							Malkorok.mainframe.raidMarks[j]:SetPoint("TOPLEFT", px1 - 8, -py1 + 8)
							Malkorok.mainframe.raidMarks[j]:Show()
						else
							Malkorok.mainframe.raidMarks[j]:Hide()
						end
					else
						if Malkorok.mainframe.raidMarks[j] then Malkorok.mainframe.raidMarks[j]:Hide() end
					end
				end
			end
		end
	end
end

function Malkorok:EventHandler(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _,event_n,_,_,_,_,_,destGUID,_,_,_,spellId = ...
		if event_n == "SPELL_CAST_SUCCESS" then
			if not (spellId == Malkorok.spell) then
				return
			end
			for i=1,6 do  
				Malkorok.pie_status[i]=0
				Malkorok.mainframe.pie[i].tex:SetVertexColor(0,1,0,0.8)
			end
			if Malkorok.baoe_num == 0 then 
				Malkorok.mainframe.aoecd.cooldown:SetCooldown(GetTime(), 60)
				Malkorok.baoe_num = 1
			else
				Malkorok.baoe_num = 0
			end
		elseif event_n == "SPELL_CAST_SUCCESS" then
			if not (spellId == Malkorok.spell_baoe) then
				return
			end
			Malkorok.baoe_num = 0
			Malkorok.mainframe.aoecd.cooldown:SetCooldown(GetTime(), 64)
			for i=1,6 do  
				Malkorok.pie_status[i]=0
				Malkorok.mainframe.pie[i].tex:SetVertexColor(0,1,0,0.8)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		SetMapToCurrentZone()
		local cmap = GetCurrentMapAreaID()
		if not Malkorok.maps[cmap] then cmap = 0 end
		Malkorok.main_coord_top_x = Malkorok.maps[cmap][1]
		Malkorok.main_coord_top_y = Malkorok.maps[cmap][2]
		Malkorok.main_coord_bot_x = Malkorok.maps[cmap][3]
		Malkorok.main_coord_bot_y = Malkorok.maps[cmap][4]	
	end
end

function Malkorok:addonMessage(sender, prefix, ...)
	if not Malkorok.mainframe then return end 
	if prefix == "malkorok" then
		local pienum,piecol = ...
		if not tonumber(pienum) or tonumber(pienum) == 0 then return end 
		pienum = tonumber(pienum)
		if pienum > 6 then return end
		if Malkorok.pie_status[pienum] == 0 and piecol == "R" then
			Malkorok.pie_status[pienum]=1
			Malkorok.mainframe.pie[pienum].tex:SetVertexColor(1,0,0,0.8)
		elseif Malkorok.pie_status[pienum] == 1 and piecol == "G" then
			Malkorok.pie_status[pienum]=0
			Malkorok.mainframe.pie[pienum].tex:SetVertexColor(0,1,0,0.8)
		end
	end
end

function Malkorok:Load()
	if Malkorok.mainframe then return end
	Malkorok.mainframe = CreateFrame("Frame","ExRTBossmodsMalkorok",UIParent)
	Malkorok.mainframe:SetSize(200,200)
	if VExRT.Bossmods.MalkorokLeft and VExRT.Bossmods.MalkorokTop then
		Malkorok.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.MalkorokLeft,VExRT.Bossmods.MalkorokTop)
	else
		Malkorok.mainframe:SetPoint("TOP",UIParent, "TOP", 0, -50)
	end
	Malkorok.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	Malkorok.mainframe:SetBackdropColor(0,0,0,0.5)
	Malkorok.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	Malkorok.mainframe:EnableMouse(true)
	Malkorok.mainframe:SetMovable(true)
	Malkorok.mainframe:RegisterForDrag("LeftButton")
	Malkorok.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)

	Malkorok.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.MalkorokLeft = self:GetLeft()
		VExRT.Bossmods.MalkorokTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then Malkorok.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then Malkorok.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	Malkorok.mainframe.main = CreateFrame("Frame",nil,Malkorok.mainframe)
	Malkorok.mainframe.main:SetSize(180,180)
	Malkorok.mainframe.main:SetPoint("TOPLEFT",10, -10)

	Malkorok.mainframe.pie = {}
	for i=1,6 do 
		Malkorok.mainframe.pie[i] = CreateFrame("Frame",nil,Malkorok.mainframe.main)
		Malkorok.mainframe.pie[i]:SetSize(180,180)
		Malkorok.mainframe.pie[i]:SetPoint("TOPLEFT", 0, 0)

		Malkorok.mainframe.pie[i].tex = Malkorok.mainframe.pie[i]:CreateTexture(nil, "BACKGROUND")
		Malkorok.mainframe.pie[i].tex:SetTexture("Interface\\AddOns\\ExRT\\media\\Pie"..i)
		Malkorok.mainframe.pie[i].tex:SetAllPoints()
		Malkorok.mainframe.pie[i].tex:SetTexCoord(0,180/256,0,180/256)
		Malkorok.mainframe.pie[i].tex:SetVertexColor(0,1,0,0.8)
		Malkorok.pie_status[i]=0
	end

	Malkorok.mainframe:SetScript("OnMouseDown", function(self,button)
		local j1,j2 = Malkorok:Cursor()

		if j1 < 6 and j2 < 6 then
			if not VExRT.Bossmods.MalkorokLock then
				Malkorok.mainframe.Lock.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
				Malkorok.mainframe:SetMovable(false)
				VExRT.Bossmods.MalkorokLock = true
			else
				Malkorok.mainframe.Lock.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\un_lock.tga")
				Malkorok.mainframe:SetMovable(true)
				VExRT.Bossmods.MalkorokLock = nil
			end
		elseif j1 < 22 and j2 < 6 then
			if Malkorok.rotate then
				VExRT.Bossmods.MalkorokRotate = nil
				Malkorok.rotate = nil
				for i=1,6 do
					Malkorok.mainframe.pie[i].tex:SetTexCoord(0,180/256,0,180/256)
				end
				Malkorok.rotate_angle = 0
				if Malkorok.def_angle~=0 then Malkorok.def_angle_rotate() end	
			else
				VExRT.Bossmods.MalkorokRotate = true
				Malkorok.rotate = true
			end
		elseif j1 < 8 and j2 > 170 then
			VExRT.Bossmods.MalkorokIconHide = not VExRT.Bossmods.MalkorokIconHide
			if VExRT.Bossmods.MalkorokIconHide then
				Malkorok.mainframe.aoecd:Hide()
			else
				Malkorok.mainframe.aoecd:Show()
			end
		end	

		local numpie = Malkorok:findpie(j1,j2,1)
		if numpie>0 then
			if button == "LeftButton" then
				Malkorok.pie_status[numpie]=1
				Malkorok.mainframe.pie[numpie].tex:SetVertexColor(1,0,0,0.8)
			elseif button == "RightButton" then
				Malkorok.pie_status[numpie]=0
				Malkorok.mainframe.pie[numpie].tex:SetVertexColor(0,1,0,0.8)
			end
			local col = "R"
			if button == "RightButton" then col = "G" end
			if RaidRank()>0 then 
				ExRT.F.SendExMsg("malkorok",tostring(numpie).."\t"..col) 
				ExRT.F.SendExMsg("malkorok",tostring(numpie).."\t"..col,nil,nil,"MHADD")
			end
		end
	end)
	
	Malkorok.mainframe.Player = CreateFrame("Frame",nil,Malkorok.mainframe.main)
	Malkorok.mainframe.Player:SetSize(32,32)
	Malkorok.mainframe.Player.Texture =Malkorok.mainframe.Player:CreateTexture(nil, "ARTWORK")
	Malkorok.mainframe.Player.Texture:SetSize(32,32)
	Malkorok.mainframe.Player.Texture:SetPoint("TOPLEFT",0,0)
	Malkorok.mainframe.Player.Texture:SetTexture("Interface\\MINIMAP\\MinimapArrow")
	Malkorok.mainframe.Player.scale = 1
	Malkorok.mainframe.Player:SetScale(Malkorok.mainframe.Player.scale)

	Malkorok.mainframe.Danger = ELib:Text(Malkorok.mainframe,L.bossmodsmalkorokdanger,18):Size(200,18):Point("TOP",0,15):Center():Top():Color(1,.2,.2):Outline()
	Malkorok.mainframe.Danger:Hide()

	Malkorok.mainframe.Lock = ELib:Icon(Malkorok.mainframe,"Interface\\AddOns\\ExRT\\media\\un_lock.tga",14):Point(2,-1)
	if VExRT.Bossmods.MalkorokLock then 
		Malkorok.mainframe.Lock.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
		Malkorok.mainframe:SetMovable(false)
	end

	Malkorok.mainframe.Rotate = ELib:Icon(Malkorok.mainframe,"Interface\\AddOns\\ExRT\\media\\icon-config.tga",14):Point(18,-1)
	Malkorok.mainframe.Rotate.texture:SetVertexColor(0.6,0.6,0.6,0.8)
	if VExRT.Bossmods.MalkorokRotate then 
		Malkorok.rotate = true
	else
		if Malkorok.def_angle~=0 then Malkorok.def_angle_rotate() end
	end

	Malkorok.mainframe.aoecd = ELib:Icon(Malkorok.mainframe,"Interface\\Icons\\Spell_Shadow_Shadesofdarkness",32):Point("BOTTOMLEFT",2,1)
	Malkorok.mainframe.aoecd.cooldown = CreateFrame("Cooldown", nil, Malkorok.mainframe.aoecd)
	Malkorok.mainframe.aoecd.cooldown:SetAllPoints()
	if VExRT.Bossmods.MalkorokIconHide then
		Malkorok.mainframe.aoecd:Hide()
	end

	Malkorok.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
	Malkorok.mainframe:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
	Malkorok.mainframe:SetScript("OnUpdate", Malkorok.timerfunc)
	Malkorok.mainframe:SetScript("OnEvent", Malkorok.EventHandler)

	print(L.bossmodsmalkorokhelp)

	SetMapToCurrentZone()
	local currentAreaID = GetCurrentMapAreaID()
	if Malkorok.maps[currentAreaID] then
		Malkorok.main_coord_top_x = Malkorok.maps[currentAreaID][1]
		Malkorok.main_coord_top_y = Malkorok.maps[currentAreaID][2]
		Malkorok.main_coord_bot_x = Malkorok.maps[currentAreaID][3]
		Malkorok.main_coord_bot_y = Malkorok.maps[currentAreaID][4]
	end
end

-----------------------------------------
-- Malkorok AI
-----------------------------------------
local MalkorokAI = {}
module.A.MalkorokAI = MalkorokAI

MalkorokAI.mainframe = nil
MalkorokAI.pie = {0,0,0,0,0,0}
MalkorokAI.pie_raid = {}
MalkorokAI.pie_yellow = 0
MalkorokAI.tmr = 0
MalkorokAI.tmr2 = 0
MalkorokAI.spell_aoe = 143805

function MalkorokAI:timerfunc2(elapsed)
	MalkorokAI.tmr2 = MalkorokAI.tmr2 + elapsed
	if MalkorokAI.tmr2 > 5 then
		for i=1,6 do 
			if MalkorokAI.pie[i] == 1 and Malkorok.pie_status[i]==1 then
				Malkorok.mainframe.pie[i].tex:SetVertexColor(1,0,0,0.8)
			end
			MalkorokAI.pie[i] = 0
		end
		MalkorokAI.mainframe:SetScript("OnUpdate", nil)
		MalkorokAI.tmr2 = 0
	end
end

function MalkorokAI:timerfunc(elapsed)
	MalkorokAI.tmr = MalkorokAI.tmr + elapsed
	if MalkorokAI.tmr > 0.5 then
		for i=1,6 do 
			if MalkorokAI.pie[i] == 1 then
				Malkorok.mainframe.pie[i].tex:SetVertexColor(1,0.8,0,0.8)
			end
		end
		MalkorokAI.mainframe:SetScript("OnUpdate", MalkorokAI.timerfunc2)
		MalkorokAI.tmr = 0
	end
end

MalkorokAI.mainframe_2 = nil
MalkorokAI.tmr_do = 0
function MalkorokAI:timerfunc_do(elapsed)
	MalkorokAI.tmr_do = MalkorokAI.tmr_do + elapsed
	if MalkorokAI.tmr_do > 4.5 then
		local n = GetNumGroupMembers() or 0
		if n > 0 then
			local gMax = ExRT.F.GetRaidDiffMaxGroup()
			for i=1,6 do MalkorokAI.pie_raid[i]=0 end
			for j=1,n do
				local name, _,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= gMax and not UnitIsDeadOrGhost(name) then
					local px, py = GetPlayerMapPosition(name)
					if px >= Malkorok.main_coord_top_x and px<=Malkorok.main_coord_bot_x and py>=Malkorok.main_coord_top_y and py<=Malkorok.main_coord_bot_y then
						local px1 = (px-Malkorok.main_coord_top_x)/(Malkorok.main_coord_bot_x-Malkorok.main_coord_top_x)*180
						local py1 = (py-Malkorok.main_coord_top_y)/(Malkorok.main_coord_bot_y-Malkorok.main_coord_top_y)*180
				
						local numpie = Malkorok:findpie(px1,py1)

						for i_a=1,40 do
							local _,_,_,_,_,_,_,_,_,_,auraSpellId = UnitAura(name, i_a,"HELPFUL")
							if not auraSpellId then 
								break
							elseif auraSpellId == 19263 or	--Deterrence
								auraSpellId == 110696 or--Ice Block druid
								auraSpellId == 110700 or--Divine Shield druid
								auraSpellId == 45438 or	--Ice Block
								auraSpellId == 47585 or	--Dispersion
								auraSpellId == 113862 or--Greater Invisibility
								auraSpellId == 110960 or--Greater Invisibility
								auraSpellId == 1022 or	--Hand of Protection
								auraSpellId == 642 then	--Divine Shield
									numpie = 0
							end
						end
						if numpie > 0 then 
							MalkorokAI.pie_raid[numpie] = MalkorokAI.pie_raid[numpie] + 1
						end
					end
				end
			end
			local minpieam = 40
			for i=1,6 do 
				minpieam = min(minpieam,MalkorokAI.pie_raid[i])
			end
			for i=1,6 do 
				if MalkorokAI.pie_raid[i]==minpieam then
					if RaidRank()>0 then 
						ExRT.F.SendExMsg("malkorok",tostring(i).."\tR")
						ExRT.F.SendExMsg("malkorok",tostring(i).."\tR",nil,nil,"MHADD")
					end
					MalkorokAI.pie[i] = 1
					Malkorok.pie_status[i]=1
				end
			end
			MalkorokAI.mainframe:SetScript("OnUpdate", MalkorokAI.timerfunc)
		end
		MalkorokAI.tmr_do = 0
		self:SetScript("OnUpdate", nil)
	end
end

function MalkorokAI:EventHandler(event,_,event_n,_,_,_,_,_,_,_,_,_,spellId)
	if event_n == "SPELL_CAST_SUCCESS" and spellId == MalkorokAI.spell_aoe then
		for i=1,6 do MalkorokAI.pie[i]=0 end
		MalkorokAI.tmr_do = 0
		MalkorokAI.mainframe_2:SetScript("OnUpdate", MalkorokAI.timerfunc_do)
	end
end

function MalkorokAI:Load()
	if not Malkorok.mainframe then return end
	if MalkorokAI.mainframe then return end

	MalkorokAI.mainframe = CreateFrame("Frame","ExRTBossmodsMalkorokAI",nil)
	if not MalkorokAI.mainframe_2 then MalkorokAI.mainframe_2 = CreateFrame("Frame") end

	MalkorokAI.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
	MalkorokAI.mainframe:SetScript("OnEvent", MalkorokAI.EventHandler)

	MalkorokAI.mainframe.text = CreateFrame("SimpleHTML", nil,Malkorok.mainframe)
	MalkorokAI.mainframe.text:SetText("AI")
	MalkorokAI.mainframe.text:SetFont(ExRT.F.defFont, 16,"OUTLINE")
	MalkorokAI.mainframe.text:SetHeight(12)
	MalkorokAI.mainframe.text:SetWidth(12)
	MalkorokAI.mainframe.text:SetPoint("CENTER", Malkorok.mainframe,"BOTTOMRIGHT", -12,12)
	MalkorokAI.mainframe.text:SetTextColor(1, 1, 1, 1)

	print(L.bossmodsmalkorokaihelp)
end

-----------------------------------------
-- Spoils of Pandaria
-----------------------------------------
local SpoilsOfPandaria = {}
module.A.SpoilsOfPandaria = SpoilsOfPandaria

SpoilsOfPandaria.mainframe = nil
SpoilsOfPandaria.side1 = nil
SpoilsOfPandaria.side2 = nil
SpoilsOfPandaria.tmr = 0

SpoilsOfPandaria.tmp_point_b_x = 0.4153
SpoilsOfPandaria.tmp_point_b_y = 0.4013
SpoilsOfPandaria.tmp_point_t_x = 0.6516
SpoilsOfPandaria.tmp_point_t_y = 0.1602
SpoilsOfPandaria.tmp_point_tg = abs(( SpoilsOfPandaria.tmp_point_t_y-SpoilsOfPandaria.tmp_point_b_y ) / ( SpoilsOfPandaria.tmp_point_b_x-SpoilsOfPandaria.tmp_point_t_x ))

function SpoilsOfPandaria.findroom(px,py)
	if px < SpoilsOfPandaria.tmp_point_b_x or px > SpoilsOfPandaria.tmp_point_t_x or py < SpoilsOfPandaria.tmp_point_t_y or py > SpoilsOfPandaria.tmp_point_b_y then return 0 end

	local tg_1 = abs( SpoilsOfPandaria.tmp_point_b_x-px )
	local tg_2 = SpoilsOfPandaria.tmp_point_tg * tg_1
	local tg_y = SpoilsOfPandaria.tmp_point_b_y - tg_2

	if tg_y > py then return 1 else return 2 end
end

SpoilsOfPandaria.point_subRoom_b_x = 0.5633
SpoilsOfPandaria.point_subRoom_b_y = 0.3701
SpoilsOfPandaria.point_subRoom_t_x = 0.4885
SpoilsOfPandaria.point_subRoom_t_y = 0.1993
function SpoilsOfPandaria.findroom2(x0,y0)
	local side = (SpoilsOfPandaria.tmp_point_b_x - x0) * (SpoilsOfPandaria.tmp_point_t_y - SpoilsOfPandaria.tmp_point_b_y) - (SpoilsOfPandaria.tmp_point_t_x - SpoilsOfPandaria.tmp_point_b_x) * (SpoilsOfPandaria.tmp_point_b_y - y0)
	if side < 0 then --TOP side
		side = -1
	else
		side = 1
	end
	local subRoom = (SpoilsOfPandaria.point_subRoom_b_x - x0) * (SpoilsOfPandaria.point_subRoom_t_y - SpoilsOfPandaria.point_subRoom_b_y) - (SpoilsOfPandaria.point_subRoom_t_x - SpoilsOfPandaria.point_subRoom_b_x) * (SpoilsOfPandaria.point_subRoom_b_y - y0)
	if subRoom < 0 then --LEFT room
		subRoom = 1
	else
		subRoom = 2
	end
	local room = side * subRoom
	if room < 0 then
		return room + 3
	else
		return room + 2
	end
	-- 1: TOP Mogu
	-- 2: TOP Klaxxi
	-- 3: BOTTOM: Klaxxi
	-- 4: BOTTOM: Mogu
end

function SpoilsOfPandaria:timerfunc(elapsed)
	SpoilsOfPandaria.tmr = SpoilsOfPandaria.tmr + elapsed
	if SpoilsOfPandaria.tmr > 1 then
		SpoilsOfPandaria.tmr = 0
		local o = {[1]=-1,[2]=-1,[0]=-1}
		local n = GetNumGroupMembers() or 0
		if n > 0 then
			for j=1,n do
				local name,_,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= 5 and UnitIsDeadOrGhost(name) ~= 1 and UnitIsConnected(name) then
					local px, py = GetPlayerMapPosition(name)
					local pr = SpoilsOfPandaria.findroom(px,py)
					if o[pr] < UnitPower(name,10) then
						o[pr] = UnitPower(name,10)
					end
				end
			end
			for j=1,2 do
				SpoilsOfPandaria.mainframe.side[j].pts = o[j]
				if o[j]==-1 then 
					SpoilsOfPandaria.mainframe.side[j].text:SetText("?") 
				else 
					SpoilsOfPandaria.mainframe.side[j].text:SetText(SpoilsOfPandaria.mainframe.side[j].pts) 
				end
			end
		else
			for j=1,2 do
				SpoilsOfPandaria.mainframe.side[j].text:SetText("?")
				SpoilsOfPandaria.mainframe.side[j].pts = 0
			end
		end
	end
end

SpoilsOfPandaria.roomNames = {
	L.BossmodsSpoilsofPandariaMogu,
	L.BossmodsSpoilsofPandariaKlaxxi,
	L.BossmodsSpoilsofPandariaKlaxxi,
	L.BossmodsSpoilsofPandariaMogu,
}
function SpoilsOfPandaria:onEvent(event,unitID,_,_,_,spellID)
  	if unitID:find("^raid%d+$") and spellID == 144229 then
		local name = ExRT.F.UnitCombatlogname(unitID)	
		if name then
			local px, py = GetPlayerMapPosition(unitID)
			local room = SpoilsOfPandaria.findroom2(px, py)
			local color = ExRT.F.classColorByGUID(UnitGUID(unitID))
			local ctime_ = ExRT.F.GetEncounterTime() or 0
			print(format("%d:%02d",ctime_/60,ctime_%60).." |c"..color..name.."|r ".. L.BossmodsSpoilsofPandariaOpensBox .." "..SpoilsOfPandaria.roomNames[room])
		end
	end
end

function SpoilsOfPandaria:Load()
	if SpoilsOfPandaria.mainframe then return end
	SpoilsOfPandaria.mainframe = CreateFrame("Frame","ExRTBossmodsSpoilsOfPandaria",UIParent)
	SpoilsOfPandaria.mainframe:SetSize(70,50)
	if VExRT.Bossmods.SpoilsofPandariaLeft and VExRT.Bossmods.SpoilsofPandariaTop then
		SpoilsOfPandaria.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.SpoilsofPandariaLeft,VExRT.Bossmods.SpoilsofPandariaTop)
	else
		SpoilsOfPandaria.mainframe:SetPoint("TOP",UIParent, "TOP", 0, -50)
	end
	SpoilsOfPandaria.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	SpoilsOfPandaria.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	SpoilsOfPandaria.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	SpoilsOfPandaria.mainframe:EnableMouse(true)
	SpoilsOfPandaria.mainframe:SetMovable(true)
	SpoilsOfPandaria.mainframe:RegisterForDrag("LeftButton")
	SpoilsOfPandaria.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	SpoilsOfPandaria.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.SpoilsofPandariaLeft = self:GetLeft()
		VExRT.Bossmods.SpoilsofPandariaTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then SpoilsOfPandaria.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then SpoilsOfPandaria.mainframe:SetScale(VExRT.Bossmods.Scale/100) end


	SpoilsOfPandaria.mainframe.side = {}
	for i=1,2 do
		SpoilsOfPandaria.mainframe.side[i] = CreateFrame("Frame",nil,SpoilsOfPandaria.mainframe)
		SpoilsOfPandaria.mainframe.side[i]:SetSize(70,20)
		SpoilsOfPandaria.mainframe.side[i].text = SpoilsOfPandaria.mainframe.side[i]:CreateFontString(nil,"ARTWORK")
		SpoilsOfPandaria.mainframe.side[i].text:SetJustifyH("CENTER")	
		SpoilsOfPandaria.mainframe.side[i].text:SetFont(ExRT.F.defFont, 20,"OUTLINE")	
		SpoilsOfPandaria.mainframe.side[i].text:SetText("100")
		SpoilsOfPandaria.mainframe.side[i].text:SetTextColor(1, 1, 1, 1)
		SpoilsOfPandaria.mainframe.side[i].text:SetAllPoints()
		SpoilsOfPandaria.mainframe.side[i].pts = 0
	end
	SpoilsOfPandaria.mainframe.side[1]:SetPoint("TOPLEFT", 0, -5)
	SpoilsOfPandaria.mainframe.side[2]:SetPoint("TOPLEFT", 0, -25)

	SpoilsOfPandaria.mainframe:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
	SpoilsOfPandaria.mainframe:SetScript("OnUpdate", SpoilsOfPandaria.timerfunc)
	SpoilsOfPandaria.mainframe:SetScript("OnEvent", SpoilsOfPandaria.onEvent)
end

-----------------------------------------
-- Kromog
-----------------------------------------
local Kromog = {}
module.A.Kromog = Kromog

Kromog.runes = {
	{3673.47,329.81},
	{3669.83,320.84},
	{3667.69,309.80},
	{3663.56,334.03},
	{3661.87,325.15},
	{3660.95,315.54},
	{3659.29,303.60},
	{3652.30,324.41},
	{3650.33,315.57},
	{3649.88,332.94},
	{3649.72,306.76},
	{3642.71,324.18},
	{3641.32,315.93},
	{3640.92,308.55},
	{3636.36,331.65},
	{3633.00,304.03},
	{3632.95,317.41},
	{3631.94,310.38},
	{3630.81,325.00},
	{3624.18,317.63},
	{3623.51,306.16},
	{3623.30,330.92},
	{3617.37,312.64},
	{3615.52,323.41},
	{3612.18,306.78},
	{3611.77,333.36},
	{3605.63,318.56},
	{3604.92,328.65},
	{3603.65,308.19},
	{3597.34,336.12},
	{3596.64,325.87},
	{3594.69,315.58},
	{3594.69,306.78},--Добавлена вручную
	{3587.57,323.10},
	{3587.45,333.16},
}
Kromog.map = {3938.75,611.333,3001,-13.833}	--xT,yT,xB,yB
Kromog.image = {190/772,199/515,322/772,271/515}	-- KromogMap.tga 512х291
--Kromog.image = {0,0,1,1}
Kromog.width = 1024	--712
Kromog.image_avg = 291 / 512

Kromog.hidePlayers = true
function Kromog:UpdateSelectRoster()
	local setup = {}
	for i=1,#Kromog.runes do
		local name = VExRT.Bossmods.Kromog[i]
		if name then
			setup[name] = true
		end
	end
	local raidData = {{},{},{},{},{},{}}
	for i=1,40 do
		local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
		if name and subgroup <= 6 then
			raidData[subgroup][ #raidData[subgroup]+1 ] = {name,class}
		end
	end
	for i=1,6 do
		for j=1,5 do
			local pos = (i-1)*5+j
			local data = raidData[i][j]
			if Kromog.raidRoster.buttons[pos] and data then
				Kromog.raidRoster.buttons[pos]._name = data[1]
				if Kromog.hidePlayers then
					if setup[ data[1] ] then
						Kromog.raidRoster.buttons[pos]:SetAlpha(.2)
					else
						Kromog.raidRoster.buttons[pos]:SetAlpha(1)
					end
				else
					Kromog.raidRoster.buttons[pos]:SetAlpha(1)
				end
				Kromog.raidRoster.buttons[pos].name:SetText("|c"..ExRT.F.classColor(data[2])..data[1])
				Kromog.raidRoster.buttons[pos]:Show()
			elseif Kromog.raidRoster.buttons[pos] then
				Kromog.raidRoster.buttons[pos]:Hide()
			end
		end
	end
end

function Kromog:ReRoster()
	local playerName = UnitName('player')
	for i=1,#Kromog.runes do
		local name = VExRT.Bossmods.Kromog[i]
		if name then
			local shortName = ExRT.F.delUnitNameServer(name)
			local class = select(2,UnitClass(shortName))
			if class then
				class = "|c"..ExRT.F.classColor(class)
			else
				class = ""
			end
			if shortName == playerName then
				Kromog.setupFrame.pings[i].icon:SetVertexColor(1,0.3,0.3,1)
			else
				Kromog.setupFrame.pings[i].icon:SetVertexColor(1,1,1,1)
			end
			Kromog.setupFrame.pings[i].name:SetText(class..name)
		else
			Kromog.setupFrame.pings[i].name:SetText("")
			Kromog.setupFrame.pings[i].icon:SetVertexColor(.3,1,.3,1)
		end
	end
end

function Kromog:Load()
	if Kromog.setupFrame then
		Kromog:ReRoster()
		Kromog.setupFrame:Show()
		if not VExRT.Bossmods.Kromog.DisableArrow then
			Kromog.setupFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		end
		if InterfaceOptionsFrame:IsShown() then
			InterfaceOptionsFrame:Hide()
		end
		if ExRT.Options.Frame:IsShown() then
			ExRT.Options.Frame:Hide()
		end
		Kromog.setupFrame.isEnabled = true
		return
	end
	Kromog.setupFrame = ELib:Popup("Kromog",0):Size(Kromog.width + 8,Kromog.image_avg * Kromog.width + 35)
	Kromog.setupFrame.map = Kromog.setupFrame:CreateTexture()
	Kromog.setupFrame.map:SetTexture("Interface\\AddOns\\ExRT\\media\\KromogMap.tga")
	Kromog.setupFrame.map:SetPoint("TOP",Kromog.setupFrame,"TOP",0,-30)
	Kromog.setupFrame.map:SetSize(Kromog.width,Kromog.image_avg * Kromog.width)
	Kromog.setupFrame.map:SetTexCoord(0,1,0,291 / 512)
	Kromog.setupFrame:SetFrameStrata("HIGH")
	
	Kromog.setupFrame.isEnabled = true
	
	local function DisableSync()
		VExRT.Bossmods.Kromog.sync = nil
		if VExRT.Bossmods.Kromog.name and VExRT.Bossmods.Kromog.time then
			Kromog.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kromog.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kromog.time)..")"..(not VExRT.Bossmods.Kromog.sync and " *" or ""))
		else
			Kromog.setupFrame.lastUpdate:SetText("")
		end
	end
	
	local function KromogFrameOnEvent(self,event,unitID,spell,_,lineID,spellID)
		if --(event == "UNIT_SPELLCAST_SUCCEEDED" and (spellID == 20473 or spellID == 774)) or 
		   (event == "CHAT_MSG_RAID_BOSS_EMOTE" and unitID:find("spell:157059")) then
			local playerName = UnitName('player')
			for i=1,#Kromog.runes do
				local name = VExRT.Bossmods.Kromog[i]
				if name and ExRT.F.delUnitNameServer(name) == playerName then
					ExRT.F.Arrow:ShowRunTo(Kromog.runes[i][1],Kromog.runes[i][2],2,10,true,true)
					return
				end
			end

		end
	end

	Kromog.setupFrame.pings = {}
	local function SetupFramePingsOnEnter(self)
		self.colors = {self.icon:GetVertexColor()}
		self.icon:SetVertexColor(1,.3,1,1)
	end
	local function SetupFramePingsOnLeave(self)
	  	self.icon:SetVertexColor(unpack(self.colors))
	end
	local function SetupFramePingsOnClick(self,button)
		if button == "RightButton" then
			self.colors = {.3,1,.3,1}
			VExRT.Bossmods.Kromog[self._i] = nil
			Kromog:ReRoster()
			
			DisableSync()
			return
		end
		Kromog.raidRoster.pos = self._i
		Kromog.raidRoster.title:SetText(L.BossmodsKromogSelectPlayer..self._i)
		Kromog.raidRoster:Show()
	end
	for i=1,#Kromog.runes do
		local x = (abs(Kromog.runes[i][1]-Kromog.map[1])) / (abs(Kromog.map[3] - Kromog.map[1]))
		local y = (abs(Kromog.runes[i][2]-Kromog.map[2])) / (abs(Kromog.map[4] - Kromog.map[2]))
		Kromog.setupFrame.pings[i] = CreateFrame('Button',nil,Kromog.setupFrame)
		Kromog.setupFrame.pings[i]:SetSize(32,32)
		Kromog.setupFrame.pings[i].icon = Kromog.setupFrame.pings[i]:CreateTexture(nil,"ARTWORK")
		Kromog.setupFrame.pings[i].icon:SetAllPoints()
		Kromog.setupFrame.pings[i].icon:SetTexture("Interface\\AddOns\\ExRT\\media\\KromogRune.tga")
		Kromog.setupFrame.pings[i].num = ELib:Text(Kromog.setupFrame.pings[i],i,12):Size(30,15):Point(0,0):Top():Color(1,1,1):Outline()
		Kromog.setupFrame.pings[i].name = ELib:Text(Kromog.setupFrame.pings[i],"Player"..i,11):Size(75,15):Point(0,-12):Top():Color(1,1,1):Outline()
		
		Kromog.setupFrame.pings[i]:SetScript("OnEnter",SetupFramePingsOnEnter)
		Kromog.setupFrame.pings[i]:SetScript("OnLeave",SetupFramePingsOnLeave)
		Kromog.setupFrame.pings[i]:RegisterForClicks("RightButtonDown","LeftButtonDown")
		Kromog.setupFrame.pings[i]._i = i
		Kromog.setupFrame.pings[i]:SetScript("OnClick",SetupFramePingsOnClick)
		
		if x >= Kromog.image[1] and x <= Kromog.image[3] and y >= Kromog.image[2] and y <= Kromog.image[4] then
			Kromog.setupFrame.pings[i]:SetPoint("CENTER",Kromog.setupFrame.map,"TOPLEFT", (x - Kromog.image[1])/(Kromog.image[3]-Kromog.image[1])*Kromog.width,-(y - Kromog.image[2])/(Kromog.image[4]-Kromog.image[2])*(Kromog.image_avg * Kromog.width))
		end
	end
	
	local function KromogClearConfirm()
		for i=1,#Kromog.runes do
			VExRT.Bossmods.Kromog[i] = nil
		end
		Kromog:ReRoster()
		
		DisableSync()
	end
	
	Kromog.setupFrame.clearButton = ELib:Button(Kromog.setupFrame,L.BossmodsKromogClear,0):Size(120,22):Point("BOTTOMRIGHT",Kromog.setupFrame,-15,10):OnClick(function (self)
		StaticPopupDialogs["EXRT_BOSSMODS_KROMOG_CLEAR"] = {
			text = L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = KromogClearConfirm,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KROMOG_CLEAR")
	end)
	
	Kromog.setupFrame.byName = ELib:Button(Kromog.setupFrame,L.BossmodsKromogSort,0):Size(120,22):Point("BOTTOMRIGHT",Kromog.setupFrame.clearButton,"TOPRIGHT",0,0):OnClick(function (self)
		local raid = {}
		for i=1,30 do
			local name = GetRaidRosterInfo(i)
			if name then
				raid[#raid+1] = name
			end
		end
		sort(raid)
		for i=1,max(#raid,#Kromog.runes) do
			VExRT.Bossmods.Kromog[i] = raid[i]
		end
		for i=#raid+1,#Kromog.runes do
			VExRT.Bossmods.Kromog[i] = nil
		end
		Kromog:ReRoster()
		
		DisableSync()
	end)
	
	local function SetupsDropDown_Load(_,arg)
		for i=1,#Kromog.runes do
			VExRT.Bossmods.Kromog[i] = VExRT.Bossmods.KromogSetups[arg][i]
		end
		Kromog:ReRoster()
		DisableSync()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Clear(_,arg)
		for i=1,#Kromog.runes do
			VExRT.Bossmods.KromogSetups[arg][i] = nil
		end
		VExRT.Bossmods.KromogSetups[arg].date = nil
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Save(_,arg)
		for i=1,#Kromog.runes do
			VExRT.Bossmods.KromogSetups[arg][i] = VExRT.Bossmods.Kromog[i]
		end
		VExRT.Bossmods.KromogSetups[arg].date = time()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Close()
		CloseDropDownMenus()
	end
	
	local setupsDropDown = CreateFrame("Frame", "ExRT_Kromog_SetupsDropDown", nil, "UIDropDownMenuTemplate")
	Kromog.setupFrame.setupsButton = ELib:Button(Kromog.setupFrame,L.BossmodsKromogSetups,0):Size(120,22):Point("BOTTOMRIGHT",Kromog.setupFrame.byName,"TOPRIGHT",0,0):OnClick(function (self)
		VExRT.Bossmods.KromogSetups = VExRT.Bossmods.KromogSetups or {}
	
		local dropDown = {
			{ text = L.BossmodsKromogSetups, isTitle = true, notCheckable = true, notClickable = true},
		}
		for i=1,5 do
			VExRT.Bossmods.KromogSetups[i] = VExRT.Bossmods.KromogSetups[i] or {}
		
			local subMenu = nil
			local saveMenu = { text = L.BossmodsKromogSetupsSave, func = SetupsDropDown_Save, arg1 = i, notCheckable = true }
			local loadMenu = { text = L.BossmodsKromogSetupsLoad, func = SetupsDropDown_Load, arg1 = i, notCheckable = true }
			local clearMenu = { text = L.BossmodsKromogSetupsClear, func = SetupsDropDown_Clear, arg1 = i, notCheckable = true }
			
			local isExists = VExRT.Bossmods.KromogSetups[i].date
			local dateText = ""
			if isExists then
				subMenu = {loadMenu,saveMenu,clearMenu}
				dateText = ". "..date("%H:%M:%S %d.%m.%Y",isExists)
			else
				subMenu = {saveMenu}
			end
			
			dropDown[i+1] = {
				text = i..dateText, hasArrow = true, menuList = subMenu, notCheckable = true
			}
		end
		dropDown[7] = { text = L.BossmodsKromogSetupsClose, func = SetupsDropDown_Close, notCheckable = true }
		EasyMenu(dropDown, setupsDropDown, "cursor", 10 , -15, "MENU")
	end)
		
	Kromog.setupFrame.sendButton = ELib:Button(Kromog.setupFrame,L.BossmodsKromogSend,0):Size(120,22):Point("BOTTOMRIGHT",Kromog.setupFrame.setupsButton,"TOPRIGHT",0,0):OnClick(function (self)
		local line = ""
		for i=1,#Kromog.runes do
			line = line .. i.."\t"..(VExRT.Bossmods.Kromog[i] or "-").."\t"
			if i%3 == 0 then
				ExRT.F.SendExMsg("kromog",line)
				line = ""
			end
		end
		if line ~= "" then
			ExRT.F.SendExMsg("kromog",line)
		end
	end)
	
	Kromog.setupFrame.testButton = ELib:Button(Kromog.setupFrame,L.BossmodsKromogTest,0):Size(120,22):Point("RIGHT",Kromog.setupFrame.clearButton,"LEFT",0,0):OnClick(function (self)
		KromogFrameOnEvent(Kromog.setupFrame,"CHAT_MSG_RAID_BOSS_EMOTE","spell:157059")
	end)
	
	Kromog.setupFrame.disableArrowChk = ELib:Check(Kromog.setupFrame,L.BossmodsKromogDisableArrow,VExRT.Bossmods.Kromog.DisableArrow,0):Point("BOTTOMLEFT",Kromog.setupFrame.sendButton,"TOPLEFT",-3,0):Scale(.9):OnClick(function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kromog.DisableArrow = true
			Kromog.setupFrame:UnregisterAllEvents()
		else
			VExRT.Bossmods.Kromog.DisableArrow = nil
			Kromog.setupFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		end
	end)
	
	Kromog.setupFrame.onlyTrustedChk = ELib:Check(Kromog.setupFrame,L.BossmodsKromogOnlyTrusted,not VExRT.Bossmods.Kromog.UpdatesFromAll,0):Point("BOTTOMLEFT",Kromog.setupFrame.disableArrowChk,"TOPLEFT",0,-7):Scale(.9):Tooltip(L.BossmodsKromogOnlyTrustedTooltip):OnClick(function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kromog.UpdatesFromAll = nil
		else
			VExRT.Bossmods.Kromog.UpdatesFromAll = true
		end
	end)
	
	Kromog.setupFrame.lastUpdate = ELib:Text(Kromog.setupFrame,"",12):Size(500,20):Point("BOTTOMLEFT",Kromog.setupFrame,"BOTTOMLEFT",15,13):Bottom():Color(1,1,1):Outline()

	Kromog.raidRoster = ELib:Popup(L.BossmodsKromogSelectPlayer,0):Size(80*6+25,113+14)
	Kromog.raidRoster:SetScript("OnShow",function (self)
		Kromog:UpdateSelectRoster()
	end)
	Kromog.raidRoster.buttons = {}
	local function RaidRosterButtonOnEnter(self)
		self.hl:Show()
	end
	local function RaidRosterButtonOnLeave(self)
		self.hl:Hide()
	end
	local function RaidRosterButtonOnClick(self)
		for i=1,#Kromog.runes do
			if VExRT.Bossmods.Kromog[i] == self._name then
				VExRT.Bossmods.Kromog[i] = nil
			end
		end
		VExRT.Bossmods.Kromog[Kromog.raidRoster.pos] = self._name
		Kromog:ReRoster()
		Kromog.raidRoster:Hide()
		
		DisableSync()
	end
	for i=1,6 do
		for j=1,5 do
			local pos = (i-1)*5+j
			Kromog.raidRoster.buttons[pos] = CreateFrame('Button',nil,Kromog.raidRoster)
			Kromog.raidRoster.buttons[pos]:SetPoint("TOPLEFT",15+(i-1)*80,-30-(j-1)*14)
			Kromog.raidRoster.buttons[pos]:SetSize(80,14)
			ExRT.lib.CreateHoverHighlight(Kromog.raidRoster.buttons[pos])
			Kromog.raidRoster.buttons[pos]:SetScript("OnEnter",RaidRosterButtonOnEnter)
			Kromog.raidRoster.buttons[pos]:SetScript("OnLeave",RaidRosterButtonOnLeave)
			Kromog.raidRoster.buttons[pos].name = ELib:Text(Kromog.raidRoster.buttons[pos],"",12):Size(80,14):Point(0,0):Color(1,1,1):Shadow()
			Kromog.raidRoster.buttons[pos]._name = nil
			Kromog.raidRoster.buttons[pos]:SetScript("OnClick",RaidRosterButtonOnClick)
		end
	end
	Kromog.raidRoster.clearButton = CreateFrame('Button',nil,Kromog.raidRoster)
	Kromog.raidRoster.clearButton:SetPoint("BOTTOMRIGHT",Kromog.raidRoster,"BOTTOMRIGHT",-11,12)
	Kromog.raidRoster.clearButton:SetSize(80,14)
	ExRT.lib.CreateHoverHighlight(Kromog.raidRoster.clearButton)
	Kromog.raidRoster.clearButton:SetScript("OnEnter",function(self)
		self.hl:Show()
	end)
	Kromog.raidRoster.clearButton:SetScript("OnLeave",function(self)
		self.hl:Hide()
	end)
	Kromog.raidRoster.clearButton.name = ELib:Text(Kromog.raidRoster.clearButton,L.BossmodsKromogClear,12):Size(80,14):Point(0,0):Right():Color(1,1,1):Shadow()
	Kromog.raidRoster.clearButton:SetScript("OnClick",function(self)
		VExRT.Bossmods.Kromog[Kromog.raidRoster.pos] = nil
		Kromog:ReRoster()
		Kromog.raidRoster:Hide()
		
		DisableSync()
	end)
	
	Kromog.raidRoster.hideChk = ELib:Check(Kromog.raidRoster,L.BossmodsKromogHidePlayers,true,0):Point("BOTTOMLEFT",10,7):Scale(.8):OnClick(function (self)
	  	Kromog.hidePlayers = self:GetChecked()
	  	Kromog:UpdateSelectRoster()
	end)
	
	if not VExRT.Bossmods.Kromog.DisableArrow then
		--Kromog.setupFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		Kromog.setupFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	end
	Kromog.setupFrame:SetScript("OnEvent",KromogFrameOnEvent)
	Kromog.setupFrame:SetScript("OnShow",function (self)
		local isAlpha = false
		if IsInRaid() then
			if ExRT.F.IsPlayerRLorOfficer(UnitName('player')) then
				isAlpha = false
			else
				isAlpha = true
			end
		end
		if isAlpha then
			self.clearButton:SetAlpha(.2)
			self.byName:SetAlpha(.2)
			self.sendButton:SetAlpha(.2)
			self.setupsButton:SetAlpha(.2)
		else
			self.clearButton:SetAlpha(1)
			self.byName:SetAlpha(1)
			self.sendButton:SetAlpha(1)
			self.setupsButton:SetAlpha(1)		
		end
	end)

	if not VExRT.Bossmods.Kromog.name or not VExRT.Bossmods.Kromog.time then
		Kromog.setupFrame.lastUpdate:SetText("")
	else
		Kromog.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kromog.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kromog.time)..")"..(not VExRT.Bossmods.Kromog.sync and " *" or ""))
	end
	Kromog:ReRoster()
	Kromog.setupFrame:Show()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	if ExRT.Options.Frame:IsShown() then
		ExRT.Options.Frame:Hide()
	end
end

function Kromog:addonMessage(sender, prefix, ...)
	if prefix == "kromog" then
		if IsInRaid() and not VExRT.Bossmods.Kromog.UpdatesFromAll and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
	
		local pos1,name1,pos2,name2,pos3,name3 = ...
		VExRT.Bossmods.Kromog.time = time()
		VExRT.Bossmods.Kromog.name = sender
		VExRT.Bossmods.Kromog.sync = true
		if pos1 and name1 then
			pos1 = tonumber(pos1)
			if name1 == "-" then
				name1 = nil
			end
			VExRT.Bossmods.Kromog[pos1] = name1
		end
		if pos2 and name2 then
			pos2 = tonumber(pos2)
			if name2 == "-" then
				name2 = nil
			end
			VExRT.Bossmods.Kromog[pos2] = name2
		end
		if pos3 and name3 then
			pos3 = tonumber(pos3)
			if name3 == "-" then
				name3 = nil
			end
			VExRT.Bossmods.Kromog[pos3] = name3
		end
		
		if Kromog.setupFrame then
			Kromog.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kromog.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kromog.time)..")")
			Kromog:ReRoster()
		end
	end
end

-----------------------------------------
-- Thogar
-----------------------------------------

local Thogar = {}
module.A.Thogar = Thogar

Thogar.data = {
	--{время с пула;колия;тип:1 - проезд,2-прибытие,3-отправка}	1 - самая дальняя от входа колия
	{18,4,1},
	{28,2,1},
	{33,1,2},
	{46,1,3},
	{48,3,1},
	{53,4,2},
	{78,4,3},
	{78,2,1},
	{85,3,2},
	{94,3,3},
	{108,1,1},
	{124,2,2},
	{124,3,2},
	{153,2,3},
	{153,3,3},
	{163,4,1},
	{163,1,1},
	{173,1,2},
	{183,2,1},
	{198,2,1},
	{198,4,2},
	{216,1,3},
	{219,3,1},
	{226,4,3},
	{228,2,1},
	{238,1,1},
	{254,2,2},
	{254,4,2},
	{265,2,3},
	{273,1,1},
	{278,3,1},
	{298,4,3},
	{308,4,2},
	{308,1,2},
	{318,2,1},
	{343,2,1},
	{373,2,2},
	{373,3,2},
	{393,3,3},
	{408,2,3},
	{408,1,1},
	{428,1,2},
	{428,4,2},
}
Thogar.statusText = {
	L.BossmodsThogarTransit,
	L.BossmodsThogarIn,
	L.BossmodsThogarOut,
}
Thogar.marksIcons = {
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
}

function Thogar:Load()
	if Thogar.mainframe then
		return
	end
	Thogar.mainframe = CreateFrame("Frame","ExRTBossmodsThogar",UIParent)
	Thogar.mainframe:SetSize(180,90)
	if VExRT.Bossmods.ThogarLeft and VExRT.Bossmods.ThogarTop then
		Thogar.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.ThogarLeft,VExRT.Bossmods.ThogarTop)
	else
		Thogar.mainframe:SetPoint("TOP",UIParent, "TOP", 0, -50)
	end
	--Thogar.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	Thogar.mainframe:SetBackdrop({edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	--Thogar.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	Thogar.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	Thogar.mainframe:EnableMouse(true)
	Thogar.mainframe:SetMovable(true)
	Thogar.mainframe:RegisterForDrag("LeftButton")
	Thogar.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	Thogar.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.ThogarLeft = self:GetLeft()
		VExRT.Bossmods.ThogarTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then Thogar.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then Thogar.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	Thogar.mainframe.Background = Thogar.mainframe:CreateTexture(nil, "BACKGROUND")
	--Thogar.mainframe.Background:SetTexture(.4,.4,.4,.7)
	Thogar.mainframe.Background:SetColorTexture(1,1,1,1)
	Thogar.mainframe.Background:SetAllPoints()
	Thogar.mainframe.Background:SetGradientAlpha("VERTICAL", 53/255, 53/255, 53/255, .8, 26/255, 26/255, 26/255, .8)
	--Thogar.mainframe.Background:SetGradientAlpha("VERTICAL", 0/255, 0/255, 0/255, .7, 63/255, 63/255, 63/255, .7)
	
	Thogar.mainframe.lines = {}
	for i=1,4 do
		Thogar.mainframe.lines[i] = CreateFrame("Frame",nil,Thogar.mainframe)
		Thogar.mainframe.lines[i]:SetPoint("TOPLEFT",0,-5-(i-1)*20)
		Thogar.mainframe.lines[i]:SetSize(180,20)
		Thogar.mainframe.lines[i].col = ELib:Text(Thogar.mainframe.lines[i],i):Size(30,20):Point(10,0):Font("Interface\\AddOns\\ExRT\\media\\Glametrix.otf",18):Color(1,1,1):Shadow()
		Thogar.mainframe.lines[i].status = ELib:Text(Thogar.mainframe.lines[i]):Size(100,20):Point(25,0):Font("Interface\\AddOns\\ExRT\\media\\Glametrix.otf",18):Color(1,1,1):Shadow()
		Thogar.mainframe.lines[i].time = ELib:Text(Thogar.mainframe.lines[i]):Size(50,20):Point(135,0):Font("Interface\\AddOns\\ExRT\\media\\Glametrix.otf",18):Color(1,1,1):Shadow()

		Thogar.mainframe.lines[i].g = Thogar.mainframe.lines[i]:CreateTexture(nil, "BACKGROUND")
		Thogar.mainframe.lines[i].g:SetColorTexture(1,1,1,1)
		Thogar.mainframe.lines[i].g:SetAllPoints()
		Thogar.mainframe.lines[i].g:SetGradientAlpha("HORIZONTAL", 255/255, 55/255, 55/255, .8, 255/255, 55/255, 55/255, 0)
		Thogar.mainframe.lines[i].g:Hide()
		
		Thogar.mainframe.lines[i].mark = Thogar.mainframe.lines[i]:CreateTexture(nil, "BACKGROUND")
		Thogar.mainframe.lines[i].mark:SetTexture(Thogar.marksIcons[i])
		Thogar.mainframe.lines[i].mark:SetSize(14,14)
		Thogar.mainframe.lines[i].mark:SetPoint("RIGHT",Thogar.mainframe.lines[i].time,"LEFT",-10,0)
	end
	
	local maxTime = 0
	for j,data in ipairs(Thogar.data) do
		maxTime = max(data[1],maxTime)
	end
	
	local tmr = 0
	local pullTime = 0
	local function ThogarUpdate(self,elapsed)
		tmr = tmr + elapsed
		if tmr > 0.05 then
			pullTime = pullTime + tmr
			--DInfo(pullTime)
			tmr = 0
			local nextTime = maxTime
			for i=1,4 do
				local line = self.lines[i]
				local isLineSet = false
				local isLineFull = false
				line.status:SetText("")
				line.time:SetText("")
				line.g:Hide()
				line.diffNow = nil
				for j,data in ipairs(Thogar.data) do
					if data[2] == i and pullTime > data[1] and data[3] == 1 and (pullTime - data[1]) < 3 then
						line.status:SetText(Thogar.statusText[ data[3] ])
						line.time:SetText("")
						line.diffNow = -1
						break
					elseif data[2] == i and data[1] > pullTime and not isLineSet then
						line.status:SetText(Thogar.statusText[ data[3] ])
						local diff = data[1] - pullTime
						local timeColor = ""
						line.time:SetText( date("%M:%S",diff) )
						
						--break
						isLineSet = true
						isLineFull = data[3] == 3
						if not isLineFull then
							line.diffNow = diff
						else
							line.diffNow = -1
						end
					end
				end
				if line.diffNow then
					if line.diffNow >= 0 then
						nextTime = min(nextTime,line.diffNow)
					end
					if line.diffNow <= 5 then
						line.g:SetGradientAlpha("HORIZONTAL", 255/255, 55/255, 55/255, .8, 255/255, 55/255, 55/255, 0)
						line.g:Show()
					elseif line.diffNow <= 10 then
						line.g:SetGradientAlpha("HORIZONTAL", 255/255, 255/255, 55/255, .65, 255/255, 255/255, 55/255, 0)
						line.g:Show()	
					end
				end
			end
			if nextTime > 10 then
				for i=1,4 do
					local line = self.lines[i]
					if line.diffNow and line.diffNow == nextTime then
						line.g:SetGradientAlpha("HORIZONTAL", 55/255, 255/255, 55/255, .5, 55/255, 255/255, 55/255, 0)
						line.g:Show()
					end
				end
			end
			if pullTime > maxTime then
				self:SetScript("OnUpdate",nil)
			end
		end
	end
	
	--Thogar.mainframe:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	Thogar.mainframe:RegisterEvent("ENCOUNTER_START")
	Thogar.mainframe:RegisterEvent("ENCOUNTER_END")
	Thogar.mainframe:SetScript("OnEvent",function (self,event,unitID,spell,_,lineID,spellID)
		if (event == "UNIT_SPELLCAST_SUCCEEDED" and (spellID == 20473 or spellID == 774)) then
			pullTime = 0
			self:SetScript("OnUpdate",ThogarUpdate)
		elseif event == "ENCOUNTER_START" and unitID == 1692 then
			pullTime = 0
			self:SetScript("OnUpdate",ThogarUpdate)
		elseif event == "ENCOUNTER_END" then
			self:SetScript("OnUpdate",nil)
		end		  
	end)
	
end

--ExRT.F.ScheduleTimer(Thogar.Load, 2)

-----------------------------------------
-- Imperator Mar'gok
-----------------------------------------

local Margok = {}
module.A.Margok = Margok

Margok.spellIDs = {
	[156225]=true,	--Phase 1
	[164004]=true,	--Phase 2
	[164005]=true,	--Phase 3
	[164006]=true,	--Phase 4
}
Margok.mapData = {}
Margok.Roster = {}
Margok.lastRange = nil
Margok.Range = 200

do
	local tmr = 0
	function Margok:OnTimer(elapsed)
		tmr = tmr + elapsed
		if tmr > 0.3 then
			tmr = 0
			local mainY,mainX,mainY2,mainX2 = nil
			if not self.Debuff and not self.Debuff2 then
				return
			end
			if self.Debuff then
				mainY,mainX = UnitPosition(self.Debuff)
			end
			if self.Debuff2 then
				mainY2,mainX2 = UnitPosition(self.Debuff2)
			end
			local diff,diffName,diff2,diffName2 = nil
			for name,_ in pairs(Margok.Roster) do
				if not UnitIsDeadOrGhost(name) then
					local y,x = UnitPosition(name)
					
					if name ~= self.Debuff then
						local dX = (x - mainX)
						local dY = (y - mainY)
						local diffNow = sqrt(dX * dX + dY * dY)
						if not diff or diffNow < diff then
							diff = diffNow
							diffName = name
						end
					end
					if name ~= self.Debuff2 then
						local dX = (x - mainX)
						local dY = (y - mainY)
						local diffNow = sqrt(dX * dX + dY * dY)
						if not diff2 or diffNow < diff2 then
							diff2 = diffNow
							diffName2 = name
						end
					end
				end
			end
			
			if diffName and diff <= Margok.Range then
				self.name:SetText("|c"..ExRT.F.classColor(select(2,UnitClass(diffName)))..diffName)
				if diffName ~= Margok.lastRange then
					--[[
					if GetRaidTargetIndex(diffName) ~= 7 then
						SetRaidTargetIcon(diffName, 7)
					end
					]]
					Margok.lastRange = diffName
				end
			else
				self.name:SetText("")
				Margok.lastRange = nil
			end
			if diffName2 and diff2 <= Margok.Range and diffName2 ~= diffName then
				if diffName2 ~= Margok.lastRange2 then
					--[[
					if GetRaidTargetIndex(diffName2) ~= 3 then
						SetRaidTargetIcon(diffName2, 3)
					end
					]]
					Margok.lastRange2 = diffName2
				end
			else
				Margok.lastRange2 = nil
			end
		end
	end
end
do
	local resetRange = nil
	local function ResetRange()
		resetRange = nil
		Margok.Range = 200
	end
	function Margok:OnEvent(_,_,event,_,_,_,_,_,destGUID,destName,_,_,spellID)
		if spellID and Margok.spellIDs[spellID] then
			if event == "SPELL_AURA_APPLIED" then
				if not self.Debuff then
					self.Debuff = destName
					--[[
					if GetRaidTargetIndex(destName) ~= 8 then
						SetRaidTargetIcon(destName, 8)
					end
					]]
					--ExRT.F.CancelTimer(resetRange)
				else
					self.Debuff2 = destName
					--[[
					if GetRaidTargetIndex(destName) ~= 2 then
						SetRaidTargetIcon(destName, 2)
					end
					]]
				end
			elseif event == "SPELL_AURA_REMOVED" then
				if self.Debuff2 and self.Debuff2 == destName then
					self.Debuff2 = nil
					if Margok.lastRange2 then
						--SetRaidTargetIcon(Margok.lastRange2, 0)
						Margok.lastRange2 = nil
					end
				else
					self.Debuff = nil
					if Margok.lastRange then
						--SetRaidTargetIcon(Margok.lastRange, 0)
						Margok.lastRange = nil
					end
				end
				--[[
				if spellID == 164005 then
					Margok.Range = Margok.Range * 0.75
				else
					Margok.Range = Margok.Range * 0.5
				end
				resetRange = ExRT.F.ScheduleTimer(ResetRange, 1.5)
				]]
			end
		end
	end
end
function Margok:OnRosterUpdate()
	wipe(Margok.Roster)
	local n = GetNumGroupMembers() or 0
	if n > 0 then
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		for j=1,n do
			local name, _,subgroup = GetRaidRosterInfo(j)
			if name and subgroup <= gMax then
				Margok.Roster[ name ] = true
			end
		end
	end
end

function Margok:Load()
	if Margok.mainframe then
		return
	end
	Margok.mainframe = CreateFrame("Frame",nil,UIParent)
	Margok.mainframe:SetSize(80,30)

	if VExRT.Bossmods.MargokLeft and VExRT.Bossmods.MargokTop then
		Margok.mainframe:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.MargokLeft,VExRT.Bossmods.MargokTop)
	else
		Margok.mainframe:SetPoint("TOP",UIParent, "TOP", 0, -50)
	end
	Margok.mainframe:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	--Margok.mainframe:SetBackdrop({edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	Margok.mainframe:SetBackdropColor(0.05,0.05,0.05,0.85)
	Margok.mainframe:SetBackdropBorderColor(0.2,0.2,0.2,0.4)
	Margok.mainframe:EnableMouse(true)
	Margok.mainframe:SetMovable(true)
	Margok.mainframe:RegisterForDrag("LeftButton")
	Margok.mainframe:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	Margok.mainframe:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.MargokLeft = self:GetLeft()
		VExRT.Bossmods.MargokTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then Margok.mainframe:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then Margok.mainframe:SetScale(VExRT.Bossmods.Scale/100) end

	Margok.mainframe.name = ELib:Text(Margok.mainframe,UnitName("player"),nil):Size(75,30):Point("CENTER",0,0):Center():Color(1,1,1):Shadow()
	
	Margok.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Margok.mainframe:SetScript("OnUpdate", Margok.OnTimer)
	Margok.mainframe:SetScript("OnEvent", Margok.OnEvent)
	
	Margok.rosterFrame = CreateFrame("Frame")
	Margok.rosterFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	Margok.rosterFrame:SetScript("OnEvent", Margok.OnRosterUpdate)
	Margok:OnRosterUpdate()
end

-----------------------------------------
-- Ko'ragh
-----------------------------------------

local Koragh = {}
module.A.Koragh = Koragh

function Koragh:OnEvent(_,_,event,_,_,_,_,_,destGUID,destName,_,_,spellID)
	if event == "SPELL_AURA_APPLIED" and spellID == 172895 and Koragh.playerGUID == destGUID then
		local x,y = GetPlayerMapPosition("player")
		ExRT.F.Arrow:ShowRunTo(x,y,1,12,false,true)
	end
end

function Koragh:Load()
	if Koragh.mainframe then
		return
	end
	Koragh.playerGUID = UnitGUID("player")
	
	Koragh.mainframe = CreateFrame('Frame')
	Koragh.mainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Koragh.mainframe:SetScript("OnEvent", Koragh.OnEvent)
end

-----------------------------------------
-- Shadow-Lord Iskar
-----------------------------------------

local Iskar = {}
module.A.Iskar = Iskar

function Iskar:Load()
	if Iskar.mainframe then
		return
	end
	if InCombatLockdown() then
		print("Combat error")
		return
	end
	ExRT.Options.Frame:Hide()
	
	local frame = CreateFrame('Frame',nil,UIParent)
	Iskar.mainframe = frame
	frame:SetSize(170,202)

	if VExRT.Bossmods.IskarLeft and VExRT.Bossmods.IskarTop then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.IskarLeft,VExRT.Bossmods.IskarTop)
	else
		frame:SetPoint("TOP",UIParent, "TOP", 0, -50)
	end
	frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-7)
	frame.back:SetAllPoints()
	frame.back:SetColorTexture(0,0,0,.6)
	
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.IskarLeft = self:GetLeft()
		VExRT.Bossmods.IskarTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then frame:SetAlpha(VExRT.Bossmods.Alpha/100) end
	--if VExRT.Bossmods.Scale then frame:SetScale(VExRT.Bossmods.Scale/100) end
	
	local RosterUpdate = nil
	local IsFelBombActive = nil
	local IsShadowRiposte = nil
	local IsFelConduit = nil
	local IsPhantasmalCorruption = nil
	
	local debuffName_wind = GetSpellInfo(181957) or "unk" --Phantasmal Winds
	local debuffName_radiance = GetSpellInfo(185239) or "unk" --Radiance of Anzu
	local buffName_eyeOfAnzu = GetSpellInfo(179202) or "unk" --Eye Of Anzu
	local debuffName_darkBindings = GetSpellInfo(185510) or "unk" --Dark Bindings
	local castName_felConduit = GetSpellInfo(181827) or "unk" --Fel Conduit
	local castName_felChainLightning = GetSpellInfo(181832) or "unk" --Fel Chain Lightning
	local debuffName_corruption = GetSpellInfo(181824) or "unk" --Phantasmal Corruption
	
	local function OnAuraEvent(self,_,unit)
		local name = self.unitID
		if not name or not UnitIsUnit(name,unit or "?") then
			return
		end
		local isRadiance,_,_,radianceCount = UnitAura(name,debuffName_radiance,nil,"HARMFUL")
		if isRadiance then
			self.stacks:SetText(radianceCount or 1)
		else
			self.stacks:SetText("")
		end
		if IsShadowRiposte then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetColorTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			local isWindDebuff = UnitAura(name,debuffName_wind,nil,"HARMFUL")
			if isWindDebuff then
				if self.state ~= 30 then
					self.back:SetColorTexture(1,1,.5,.9)
					self.state = 30
				end
				return
			end
			if self.state ~= 10 then
				self.back:SetColorTexture(.5,1,.5,.9)
				self.state = 10
			end
			return
		end
		if IsFelBombActive then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetColorTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			if self.isHealer then
				if self.state ~= 10 then
					self.back:SetColorTexture(.5,1,.5,.9)
					self.state = 10
				end
			else
				if self.state ~= 0 then
					self.back:SetColorTexture(0,0,0,.5)
					self.state = 0
				end
			end
			return
		end		
		if IsFelConduit then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetColorTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			if not self.isHealer then
				if self.state ~= 10 then
					self.back:SetColorTexture(.5,1,.5,.9)
					self.state = 10
				end
			else
				if self.state ~= 0 then
					self.back:SetColorTexture(0,0,0,.5)
					self.state = 0
				end
			end
			return
		end
		if IsPhantasmalCorruption then
			local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
			if eyeOfAnzu then
				if self.state ~= 20 then
					self.back:SetColorTexture(.5,.1,.5,.9)
					self.state = 20
				end
				return
			end
			local isCorrupted = false
			for i=1,10 do
				local _,_,_,_,_,_,_,_,_,_,spellID = UnitAura(name,i,"HARMFUL")
				if spellID == 181824 then
					isCorrupted = true
					break
				elseif not spellID then
					break
				end
			end
			if isCorrupted then
				if self.state ~= 10 then
					self.back:SetColorTexture(.5,1,.5,.9)
					self.state = 10
				end
			else
				if self.state ~= 0 then
					self.back:SetColorTexture(0,0,0,.5)
					self.state = 0
				end
			end
			return
		end
		local isWindDebuff = UnitAura(name,debuffName_wind,nil,"HARMFUL")
		if isWindDebuff then
			if self.state ~= 10 then
				self.back:SetColorTexture(.5,1,.5,.9)
				self.state = 10
			end
			return
		end
		local eyeOfAnzu = UnitAura(name,buffName_eyeOfAnzu)
		if eyeOfAnzu then
			if self.state ~= 20 then
				self.back:SetColorTexture(.5,.1,.5,.9)
				self.state = 20
			end
			return
		end
		local darkBindings = UnitAura(name,debuffName_darkBindings,nil,"HARMFUL")
		if darkBindings then
			if self.state ~= 30 then
				self.back:SetColorTexture(1,1,.5,.9)
				self.state = 30
			end
			return
		end
		if self.state ~= 0 then
			self.back:SetColorTexture(0,0,0,.5)
			self.state = 0
		end
	end
	
	local function OnEnterEvent(self)
		if not self.unitID or not IsAltKeyDown() then
			return
		end
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		GameTooltip:SetUnit(self.unitID)
		self.UpdateTooltip = OnEnterEvent
	end
	local function OnLeaveEvent(self)
		self.UpdateTooltip = nil
		GameTooltip_Hide()
	end
	
	local OnLoadMarkersData = {1,2,3,4,5,6,7,8}
	
	local classNames = ExRT.GDB.ClassList
	frame.units = {}
	for i=1,6 do
		for j=1,5 do
			local unitFrame = CreateFrame('Button',nil,frame,"SecureActionButtonTemplate")
			frame.units[(i-1)*5+j] = unitFrame
			unitFrame:SetSize(30,30)
			unitFrame:SetPoint("TOPLEFT",5+(j-1)*32,-5-(i-1)*32)
			
			unitFrame.ID = (i-1)*5+j
			
			unitFrame:RegisterForClicks("AnyDown")
			unitFrame:SetAttribute("type", "macro")
			--unitFrame:SetAttribute("macrotext", "/say test"..((i-1)*5+j))
			
			unitFrame:SetScript("OnEvent",OnAuraEvent)
			unitFrame:SetScript("OnEnter",OnEnterEvent)
			unitFrame:SetScript("OnLeave",OnLeaveEvent)
			
			local borderSize = 3
			
			unitFrame.bt = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.bt:SetPoint("TOPLEFT",0,0)
			unitFrame.bt:SetPoint("BOTTOMRIGHT",unitFrame,"TOPRIGHT",0,-borderSize)

			unitFrame.bb = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.bb:SetPoint("BOTTOMLEFT",0,0)
			unitFrame.bb:SetPoint("TOPRIGHT",unitFrame,"BOTTOMRIGHT",0,borderSize)

			unitFrame.bl = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.bl:SetPoint("TOPLEFT",0,-borderSize)
			unitFrame.bl:SetPoint("BOTTOMRIGHT",unitFrame,"BOTTOMLEFT",borderSize,borderSize)

			unitFrame.br = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.br:SetPoint("TOPRIGHT",0,-borderSize)
			unitFrame.br:SetPoint("BOTTOMLEFT",unitFrame,"BOTTOMRIGHT",-borderSize,borderSize)
			
			local cR,cG,cB = ExRT.F.classColorNum(classNames[fastrandom(1,11)])
			unitFrame.bt:SetColorTexture(cR,cG,cB,.3)
			unitFrame.bl:SetColorTexture(cR,cG,cB,.3)
			unitFrame.bb:SetColorTexture(cR,cG,cB,.3)
			unitFrame.br:SetColorTexture(cR,cG,cB,.3)
			
			unitFrame.back = unitFrame:CreateTexture(nil, "BACKGROUND")
			unitFrame.back:SetPoint("TOPLEFT",borderSize,-borderSize)
			unitFrame.back:SetPoint("BOTTOMRIGHT",-borderSize,borderSize)
			unitFrame.back:SetColorTexture(0,0,0,.5)
			
			unitFrame.marker = unitFrame:CreateTexture(nil, "ARTWORK")
			unitFrame.marker:SetSize(12,12)
			unitFrame.marker:SetPoint("CENTER",unitFrame,"TOP",0,-3)
			if VExRT.Bossmods.IskarShowMarks and #OnLoadMarkersData > 0 and fastrandom(100) > 49 then
				local m = fastrandom(1,#OnLoadMarkersData)
				unitFrame.marker:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..OnLoadMarkersData[m])
				tremove(OnLoadMarkersData,m)
			end
			
			unitFrame.name = ELib:Text(unitFrame,"Аф",10):Size(27,27):Point("CENTER",-1,-2):Center():Color(1,1,1)
			
			unitFrame.stacks = ELib:Text(unitFrame,fastrandom(1,5),10):Size(27,27):Point("TOPRIGHT",-3,-3):Right():Top():Color(1,1,1)
			
			if fastrandom(1,100) > 89 then
				unitFrame.back:SetColorTexture(.5,1,.5,.9)
			end
			
			if fastrandom(1,100) > 69 then
				unitFrame:SetAlpha(.2)
			end
		end
	end
	frame.units[fastrandom(1,30)].back:SetColorTexture(.5,.1,.5,.9)
	
	local function Lock(self,isLoad)
		local parent = self:GetParent()
		local var = VExRT.Bossmods.IskarLock
		if isLoad == 1 then
			var = not var
		end
		if var then
			VExRT.Bossmods.IskarLock = nil
			self.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\un_lock.tga")
			parent:SetMovable(true)
			parent:EnableMouse(true)
			parent.back:SetColorTexture(0,0,0,.6)
		else
			VExRT.Bossmods.IskarLock = true
			self.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
			parent:SetMovable(false)
			parent:EnableMouse(false)
			parent.back:SetColorTexture(0,0,0,0)
		end
	end
	
	frame.lock = ELib:Icon(frame,"Interface\\AddOns\\ExRT\\media\\un_lock.tga",14,true):Point(2,14):OnClick(Lock)
	
	frame.optionsDropDown = CreateFrame("Frame", "ExRTBossmodsIskarOptionsDropDown", nil, "UIDropDownMenuTemplate")
	
	frame.options = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],14,true):Point("TOPRIGHT",-2,14):OnClick(function()
		if InCombatLockdown() then
			print("Error: Disabled in combat")
			return
		end
		EasyMenu({
			{
				text = L.BossmodsIskarDisableClassColor,
				checked = VExRT.Bossmods.IskarDisableClassColors,
				func = function()
					VExRT.Bossmods.IskarDisableClassColors = not VExRT.Bossmods.IskarDisableClassColors
					RosterUpdate()
				end,
			},
			{
				text = L.BossmodsIskarHideStacks,
				checked = VExRT.Bossmods.IskarHideStacks,
				func = function()
					VExRT.Bossmods.IskarHideStacks = not VExRT.Bossmods.IskarHideStacks
					RosterUpdate()
				end,
			},
			{
				text = L.BossmodsIskarDisableRed,
				checked = VExRT.Bossmods.IskarDisableRedBackground,
				func = function()
					VExRT.Bossmods.IskarDisableRedBackground = not VExRT.Bossmods.IskarDisableRedBackground
				end,
			},
			--[[
			{
				text = "Disable Fel Bomb & Fel Conduit helper",
				checked = VExRT.Bossmods.IskarDisableFelBomb,
				func = function()
					VExRT.Bossmods.IskarDisableFelBomb = not VExRT.Bossmods.IskarDisableFelBomb
					if VExRT.Bossmods.IskarDisableFelBomb then
						frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
					end
				end,
			},
			]]
			{
				text = L.BossmodsIskarShowNames,
				checked = VExRT.Bossmods.IskarShowNames,
				func = function()
					VExRT.Bossmods.IskarShowNames = not VExRT.Bossmods.IskarShowNames
					RosterUpdate()
				end,
			},
			{
				text = L.BossmodsArchimondeDisableMarking,
				checked = not VExRT.Bossmods.IskarShowMarks,
				func = function()
					VExRT.Bossmods.IskarShowMarks = not VExRT.Bossmods.IskarShowMarks
					RosterUpdate()
				end,
			},
			{
				text = L.bossmodsscale,
				notCheckable = true,
				func = function()
					frame.scale:SetShown(not frame.scale:IsShown())
				end,
			},
			{
				text = L.bossmodsclose,
				notCheckable = true,
				func = function()
					ExRT.F:ExBossmodsCloseAll()
					CloseDropDownMenus()
				end,
			},						
			{
				text = L.BossWatcherSelectFightClose,
				notCheckable = true,
				func = function()
					CloseDropDownMenus()
				end,
			},
		}, frame.optionsDropDown, "cursor", 10 , -15, "MENU")
	end)
	frame.options.texture:SetTexCoord(0.26,0.3025,0.51,0.615)
	
	if VExRT.Bossmods.IskarScale and tonumber(VExRT.Bossmods.IskarScale) then
		frame:SetScale(VExRT.Bossmods.IskarScale)
	end
	frame.scale = ELib:Slider(frame):_Size(70,8):Point("BOTTOMRIGHT",frame,"TOPRIGHT",-25,2):Range(50,200,true):SetTo((VExRT.Bossmods.IskarScale or 1)*100):Scale(1 / (VExRT.Bossmods.IskarScale or 1)):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.Bossmods.IskarScale = event / 100
		ExRT.F.SetScaleFixTR(frame,VExRT.Bossmods.IskarScale)
		self:SetScale(1 / VExRT.Bossmods.IskarScale)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	frame.scale:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			self:SetValue(100)
		end
	end)
	frame.scale:Hide()	
	
	
	local function sortRoster(a,b) return a[1]<b[1]  end
	
	function RosterUpdate()
		if InCombatLockdown() then
			C_Timer.NewTimer(5,RosterUpdate)
			return
		end
	
		local n = GetNumGroupMembers()
		if n == 0 then
			local OnLoadMarkersData = {1,2,3,4,5,6,7,8}
			for i=1,6 do
				for j=1,5 do
					local unitFrame = frame.units[(i-1)*5+j]
					
					local cR,cG,cB = ExRT.F.classColorNum(classNames[fastrandom(1,11)])
					if VExRT.Bossmods.IskarDisableClassColors then
						cR,cG,cB = .1,.1,.1
					end
					unitFrame.bt:SetColorTexture(cR,cG,cB,.3)
					unitFrame.bl:SetColorTexture(cR,cG,cB,.3)
					unitFrame.bb:SetColorTexture(cR,cG,cB,.3)
					unitFrame.br:SetColorTexture(cR,cG,cB,.3)
					
					local stacks = fastrandom(0,5)
					unitFrame.stacks:SetText(stacks ~= 0 and stacks or "")
					
					unitFrame.back:SetColorTexture(0,0,0,.5)
					if fastrandom(1,100) > 89 then
						unitFrame.back:SetColorTexture(.5,1,.5,.9)
					end
					
					if fastrandom(1,100) > 69 then
						unitFrame:SetAlpha(.2)
					else
						unitFrame:SetAlpha(1)
					end
					
					if VExRT.Bossmods.IskarHideStacks then
						unitFrame.stacks:Hide()
					else
						unitFrame.stacks:Show()
					end
					
					if VExRT.Bossmods.IskarShowNames then
						unitFrame.name:SetText(ExRT.F:utf8sub(UnitName'player', 1, 2))
					else
						unitFrame.name:SetText("")
					end
					
					if VExRT.Bossmods.IskarShowMarks then
						if #OnLoadMarkersData > 0 and fastrandom(100) > 49 then
							local m = fastrandom(1,#OnLoadMarkersData)
							unitFrame.marker:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..OnLoadMarkersData[m])
							tremove(OnLoadMarkersData,m)
						end
					else
						unitFrame.marker:SetTexture("")
					end
					
					unitFrame.unitID = nil
					unitFrame:UnregisterAllEvents()
				end
			end
			frame.units[fastrandom(1,30)].back:SetColorTexture(.5,.1,.5,.9)
			return
		end
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		local roster = {}
		for i=1,n do
			local name,_,subgroup,_,_,class,_,_,_,_,_,role = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				roster[subgroup] = roster[subgroup] or {}
				roster[subgroup][ #roster[subgroup] + 1 ] = {name,class,role,'raid'..i}
			end
		end
		for i=1,gMax do
			roster[i] = roster[i] or {}
			sort(roster[i],sortRoster)
			
			for j=1,5 do
				local name = roster[i][j]
				local unitFrame = frame.units[(i-1)*5+j]
				if unitFrame then
					if name then
						unitFrame.unitID = name[1]
						unitFrame:UnregisterAllEvents()
						--unitFrame:RegisterUnitEvent("UNIT_AURA",name[4])
						local cR,cG,cB = ExRT.F.classColorNum(name[2])
						if VExRT.Bossmods.IskarDisableClassColors then
							cR,cG,cB = .1,.1,.1
						end
						unitFrame.bt:SetColorTexture(cR,cG,cB,.3)
						unitFrame.bl:SetColorTexture(cR,cG,cB,.3)
						unitFrame.bb:SetColorTexture(cR,cG,cB,.3)
						unitFrame.br:SetColorTexture(cR,cG,cB,.3)
						OnAuraEvent(unitFrame,nil,name[1])
						unitFrame:SetAttribute("macrotext", "/target "..ExRT.F.delUnitNameServer(name[1]).."\n/click ExtraActionButton1\n/targetlasttarget")
						--unitFrame:SetAttribute("macrotext", "/target "..ExRT.F.delUnitNameServer(name[1]).."\n/cast [@target] Восстановление\n/targetlasttarget")
						
						if VExRT.Bossmods.IskarHideStacks then
							unitFrame.stacks:Hide()
						else
							unitFrame.stacks:Show()
						end
						
						if VExRT.Bossmods.IskarShowNames then
							unitFrame.name:SetText(ExRT.F:utf8sub(name[1], 1, 2))
						else
							unitFrame.name:SetText("")
						end
						
						unitFrame.isHealer = name[3] == "HEALER"
						
						local inRange, checkedRange = UnitInRange(name[1])
						if inRange or not checkedRange then
							unitFrame:SetAlpha(1)
						else
							unitFrame:SetAlpha(.2)
						end
						
						if VExRT.Bossmods.IskarShowMarks then
							local mark = GetRaidTargetIndex(name[1])
							if mark then
								unitFrame.marker:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..mark)
							else
								unitFrame.marker:SetTexture("")
							end
						else
							unitFrame.marker:SetTexture("")
						end

						unitFrame:Show()
					else
						unitFrame.unitID = nil
						unitFrame:UnregisterAllEvents()
						unitFrame:Hide()
					end
				end
			end
		end
		for i=(gMax+1),6 do
			for j=1,5 do
				local unitFrame = frame.units[(i-1)*5+j]
				if unitFrame then
					unitFrame.unitID = nil
					unitFrame:UnregisterAllEvents()
					unitFrame:Hide()
				end
			end
		end
	end
	
	Lock(frame.lock,1)
	
	local function UpdateFrames()
		for i=1,30 do
			local unitFrame = frame.units[i]
			if unitFrame.unitID then
				OnAuraEvent(unitFrame,nil,unitFrame.unitID)
			end
		end
	end
	
	local AutoRemoveFelBombTimer = nil
	local function AutoRemoveFelBomb()
		AutoRemoveFelBombTimer = nil
		IsFelBombActive = nil
		UpdateFrames()
	end
	local function AutoRemoveShadowRiposte()
		IsShadowRiposte = nil
		UpdateFrames()
	end
	
	local IsFelBombCasting = nil
	local function IsFelBombCasting_Reset() IsFelBombCasting = nil end
	
	local updateSch = nil
	
	frame:SetScript("OnEvent",function(self,event,...)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local _,cleu_event,_,_,_,_,_,destGUID,_,_,_,spellID = ...
			if cleu_event == "SPELL_CAST_START" then
				if spellID == 179218 then	--Fel Bomb
					IsFelBombActive = true
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
					end
					AutoRemoveFelBombTimer = C_Timer.NewTimer(3.5, AutoRemoveFelBomb)
					IsFelBombCasting = C_Timer.NewTimer(3, IsFelBombCasting_Reset)
				elseif spellID == 185345 then	--Shadow Riposte
					local _,_,diff = GetInstanceInfo()
					if diff == 16 then
						IsShadowRiposte = true
						UpdateFrames()
						C_Timer.NewTimer(2, AutoRemoveShadowRiposte)
					end
					
				end
			elseif cleu_event == "SPELL_CAST_SUCCESS" then
				if spellID == 179218 then	--Fel Bomb
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
					end
					IsFelBombActive = true
					UpdateFrames()
					AutoRemoveFelBombTimer = C_Timer.NewTimer(6, AutoRemoveFelBomb)
					IsFelBombCasting = nil
				end
			elseif cleu_event == "SPELL_AURA_APPLIED" then
				if spellID == 181753 then
					IsFelBombActive = true
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
					end
					AutoRemoveFelBombTimer = C_Timer.NewTimer(6, AutoRemoveFelBomb)
				elseif spellID == 181824 then
					IsPhantasmalCorruption = true
					UpdateFrames()
				elseif spellID == 185239 or spellID == 181957 or spellID == 181824 or spellID == 185510 or spellID == 179219 or spellID == 181753 or spellID == 179202 then	--NEW
					if not updateSch then
						updateSch = C_Timer.NewTimer(0.05,function()
							updateSch = nil
							UpdateFrames()
						end)
					end
				end
			elseif cleu_event == "SPELL_AURA_REMOVED" then
				if spellID == 181753 then
					IsFelBombActive = nil
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
						AutoRemoveFelBombTimer = nil
					end
				elseif spellID == 181824 then
					IsPhantasmalCorruption = nil
					UpdateFrames()
				elseif spellID == 185239 or spellID == 181957 or spellID == 181824 or spellID == 185510 or spellID == 179219 or spellID == 181753 or spellID == 179202 then	--NEW
					if not updateSch then
						updateSch = C_Timer.NewTimer(0.05,function()
							updateSch = nil
							UpdateFrames()
						end)
					end
				end
			elseif cleu_event == "SPELL_AURA_APPLIED_DOSE" then
				if spellID == 185239 then	--NEW
					UpdateFrames()
				end
			elseif cleu_event == "SPELL_AURA_REMOVED_DOSE" then
				if spellID == 185239 then	--NEW
					UpdateFrames()
				end
			elseif cleu_event == "UNIT_DIED" then
				if GetMobID(destGUID) == 93985 and IsFelBombCasting then
					IsFelBombActive = nil
					UpdateFrames()
					if AutoRemoveFelBombTimer then
						AutoRemoveFelBombTimer:Cancel()
						AutoRemoveFelBombTimer = nil
					end
				end
			end
		elseif event == "RAID_TARGET_UPDATE" then
			if not VExRT.Bossmods.IskarShowMarks then
				return
			end
			for i=1,6 do
				for j=1,5 do
					local unitFrame = frame.units[(i-1)*5+j]
					if unitFrame then
						local unit = unitFrame.unitID
						if unit then
							local mark = GetRaidTargetIndex(unit)
							if mark then
								unitFrame.marker:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..mark)
							else
								unitFrame.marker:SetTexture("")
							end
						end
					end
				end
			end
		elseif event == "GROUP_ROSTER_UPDATE" then
			RosterUpdate()
		elseif event == "ENCOUNTER_START" or event == "ENCOUNTER_END" then
			IsFelBombActive = nil
			IsShadowRiposte = nil
			IsPhantasmalCorruption = nil
			UpdateFrames()
		end
	end)
	frame:RegisterEvent('GROUP_ROSTER_UPDATE')
	if not VExRT.Bossmods.IskarDisableFelBomb then
		frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
	frame:RegisterEvent('ENCOUNTER_START')
	frame:RegisterEvent('ENCOUNTER_END')
	frame:RegisterEvent('RAID_TARGET_UPDATE')
	
	local bossFrames = {"boss1","boss2","boss3","boss4","boss5"}
	local frame_tmr = 0
	local exbf_shown = false
	frame:SetScript("OnUpdate",function(self,elapsed)
		frame_tmr = frame_tmr + elapsed
		if frame_tmr > 0.1 then
			frame_tmr = 0
			--DraenorZoneAbilityFrame	ExtraActionBarFrame
			local eyeOfAnzu = UnitAura("player",buffName_eyeOfAnzu)
			if eyeOfAnzu and not exbf_shown then
				exbf_shown = true
				if not VExRT.Bossmods.IskarDisableRedBackground then
					self.back:SetColorTexture(1,.1,.1,.4)
				end
			elseif not eyeOfAnzu and exbf_shown then
				exbf_shown = false
				if VExRT.Bossmods.IskarLock then
					self.back:SetColorTexture(0,0,0,0)
				else
					self.back:SetColorTexture(0,0,0,.6)
				end
			end
			
			for i=1,30 do
				local unitFrame = self.units[i]
				if unitFrame.unitID then
					local alpha = 1
					local inRange, checkedRange = UnitInRange(unitFrame.unitID)
					if not (inRange or not checkedRange) then
						alpha = 0.2
					end
					local isDead = UnitIsDeadOrGhost(unitFrame.unitID)
					if isDead then
						alpha = 0.2
					end
					unitFrame:SetAlpha(alpha)
				end
			end
			
			local lastFelConduit = IsFelConduit
			IsFelConduit = nil
			for i=1,5 do
				local unit = bossFrames[i]
				
				local name = UnitCastingInfo(unit)
				if name == castName_felConduit then
					IsFelConduit = true
					break
				elseif not name then
					name = UnitChannelInfo(unit)
					if name == castName_felChainLightning then
						IsFelConduit = true
						break
					end
				end
			end
			if IsFelConduit ~= lastFelConduit then
				UpdateFrames()
			end
		end
	end)
	
	RosterUpdate()
	
	frame.Close = function(self)
		for i=1,#self.units do
			self.units[i].unitID = nil
			self.units[i]:UnregisterAllEvents()
		end
	end
	
	return true
end

function Iskar:AutoLoad()
	if Iskar.IsAutoloadedThisSession then
		return
	end
	Iskar.IsAutoloadedThisSession = Iskar:Load()
end

-----------------------------------------
-- Kormrok
-----------------------------------------
local Kormrok = {}
module.A.Kormrok = Kormrok

Kormrok.runes = {
	{-388.10,4209.00}, --1
	{-354.50,4208.60}, --2
	{-339.80,4210.80}, --3
	{-321.50,4210.20}, --4
	{-396.90,4227.70}, --5
	{-380.00,4223.90}, --6
	{-365.50,4224.90}, --7
	{-345.40,4223.80}, --8
	{-331.50,4220.00}, --9
	{-388.60,4241.30}, --10
	{-367.80,4241.80}, --11
	{-354.90,4238.60}, --12
	{-338.40,4243.40}, --13
	{-321.70,4243.10}, --14
	{-394.80,4258.40}, --15
	{-384.40,4253.80}, --16
	{-363.00,4258.30}, --17
	{-347.70,4253.60}, --18
	{-328.10,4252.60}, --19
	{-308.90,4253.00}, --20
	{-389.80,4269.90}, --21
	{-372.70,4271.60}, --22
	{-356.70,4270.40}, --23
	{-336.10,4270.40}, --24
	{-318.90,4271.40}, --25
	{-302.50,4271.00}, --26
	{-362.50,4283.60}, --27
	{-345.30,4283.00}, --28
	{-329.70,4287.20}, --29
	{-355.60,4301.30}, --30
	{-336.30,4299.70}, --31
	{-320.60,4303.30}, --32
	{-304.10,4301.50}, --33
	{-300.10,4240.10}, --34
	{-294.10,4255.20}, --35
	{-311.10,4281.70}, --36
	{-295.40,4285.90}, --37
	{-284.20,4270.00}, --38
	{-343.30,4316.10}, --39
	{-328.00,4318.30}, --40
	{-310.80,4318.40}, --41
	{-294.40,4316.50}, --42
	{-273.20,4315.90}, --43
	{-259.50,4317.70}, --44
	{-241.50,4315.60}, --45
	{-332.80,4329.70}, --46
	{-318.50,4332.70}, --47
	{-301.50,4333.20}, --48
	{-286.20,4329.10}, --49
	{-268.70,4329.80}, --50
	{-313.60,4344.40}, --51
	{-292.10,4344.00}, --52
	{-360.50,4318.30}, --53
	{-354.60,4329.70}, --54
	{-326.80,4343.50}, --55
	{-274.10,4345.40}, --56
	{-248.40,4329.20}, --57
	{-235.10,4332.30}, --58
	{-285.10,4299.00}, --59
	{-265.20,4299.00}, --60
	{-249.50,4303.40}, --61
	{-230.90,4297.20}, --62
	{-275.00,4288.40}, --63
	{-259.00,4283.00}, --64
	{-240.50,4284.10}, --65
	{-222.50,4286.70}, --66
	{-269.60,4272.00}, --67
	{-249.50,4269.60}, --68
	{-231.50,4267.30}, --69
	{-257.30,4253.20}, --70
	{-240.20,4253.80}, --71
	{-278.90,4255.20}, --72
}
Kormrok.map = {-217.50,4359.10,-415.90,4203.40}	--xT,yT,xB,yB
Kormrok.image = {0,0,1,1}	-- KormrokMap.tga 512х401
Kormrok.width = 1024
Kormrok.image_avg = 401 / 512

Kormrok.hidePlayers = true
function Kormrok:UpdateSelectRoster(phase)
	local setup = {}
	local fI = (phase - 1) * 100
	for i=fI+1,fI+100 do
		local name = VExRT.Bossmods.Kormrok[i]
		if name then
			setup[name] = true
		end
	end
	local raidData = {{},{},{},{}}
	for i=1,40 do
		local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
		if name and subgroup <= 4 then
			raidData[subgroup][ #raidData[subgroup]+1 ] = {name,class}
		end
	end
	for i=1,4 do
		for j=1,5 do
			local pos = (i-1)*5+j
			local data = raidData[i][j]
			if Kormrok.raidRoster.buttons[pos] and data then
				Kormrok.raidRoster.buttons[pos]._name = data[1]
				if Kormrok.hidePlayers then
					if setup[ data[1] ] then
						Kormrok.raidRoster.buttons[pos]:SetAlpha(.2)
					else
						Kormrok.raidRoster.buttons[pos]:SetAlpha(1)
					end
				else
					Kormrok.raidRoster.buttons[pos]:SetAlpha(1)
				end
				Kormrok.raidRoster.buttons[pos].name:SetText("|c"..ExRT.F.classColor(data[2])..data[1])
				Kormrok.raidRoster.buttons[pos]:Show()
			elseif Kormrok.raidRoster.buttons[pos] then
				Kormrok.raidRoster.buttons[pos]:Hide()
			end
		end
	end
end

function Kormrok:ReRoster(phase)
	local playerName = UnitName('player')
	phase = ((phase or 1) - 1) * 100
	for i=1,#Kormrok.runes do
		local name = VExRT.Bossmods.Kormrok[phase + i]
		if name then
			local shortName = ExRT.F.delUnitNameServer(name)
			local class = select(2,UnitClass(shortName))
			local desaturated = false
			if class then
				class = "|c"..ExRT.F.classColor(class)
			else
				class = ""
				desaturated = true
			end
			if not desaturated and ExRT.F.GetPlayerParty(name) > 4 then
				desaturated = true
			end
			if shortName == playerName then
				Kormrok.setupFrame.pings[i].icon:SetVertexColor(1,0.3,0.3,1)
			else
				--Kormrok.setupFrame.pings[i].icon:SetVertexColor(1,1,1,1)
				Kormrok.setupFrame.pings[i].icon:SetVertexColor(.4,.2,1,1)
			end
			Kormrok.setupFrame.pings[i].name:SetText(class..name)
			Kormrok.setupFrame.pings[i].icon:SetDesaturated(desaturated)
			if desaturated then
				Kormrok.setupFrame.pings[i].icon:SetVertexColor(1,1,1,.7)
			end
		else
			Kormrok.setupFrame.pings[i].name:SetText("")
			Kormrok.setupFrame.pings[i].icon:SetVertexColor(.3,1,.3,1)
			Kormrok.setupFrame.pings[i].icon:SetDesaturated(false)
		end
	end
end

function Kormrok:Load()
	if Kormrok.setupFrame then
		--Kormrok:ReRoster(1)
		Kormrok.setupFrame.phaseOrange:Click()
		Kormrok.setupFrame:Show()
		Kormrok:RegisterEvents()
		if InterfaceOptionsFrame:IsShown() then
			InterfaceOptionsFrame:Hide()
		end
		if ExRT.Options.Frame:IsShown() then
			ExRT.Options.Frame:Hide()
		end
		Kormrok.setupFrame.isEnabled = true
		return
	end
	Kormrok.setupFrame = ELib:Popup("Kormrok"):Size(Kormrok.width,Kormrok.image_avg * Kormrok.width)
	Kormrok.setupFrame.map = Kormrok.setupFrame:CreateTexture(nil,"BACKGROUND",nil,1)
	Kormrok.setupFrame.map:SetTexture("Interface\\AddOns\\ExRT\\media\\KormrokMap.tga")
	Kormrok.setupFrame.map:SetPoint("TOP",Kormrok.setupFrame,"TOP",0,0)
	Kormrok.setupFrame.map:SetSize(Kormrok.width,Kormrok.image_avg * Kormrok.width)
	Kormrok.setupFrame.map:SetTexCoord(0,1,0,401 / 512)
	Kormrok.setupFrame:SetFrameStrata("HIGH")
	Kormrok.setupFrame:SetClampedToScreen(false)
	
	if VExRT.Bossmods.KormrokScale and tonumber(VExRT.Bossmods.KormrokScale) then
		Kormrok.setupFrame:SetScale(VExRT.Bossmods.KormrokScale)
	end
	
	Kormrok.setupFrame.isEnabled = true
	local phaseNow = 1
	function Kormrok:GetCurrentPhase()
		return phaseNow
	end

	local function DisableSync()
		VExRT.Bossmods.Kormrok.sync = nil
		if VExRT.Bossmods.Kormrok.name and VExRT.Bossmods.Kormrok.time then
			Kormrok.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kormrok.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kormrok.time)..")"..(not VExRT.Bossmods.Kormrok.sync and " *" or ""))
		else
			Kormrok.setupFrame.lastUpdate:SetText("")
		end
	end

	local function KormrokFrameOnEvent(self,event,msg,spell,_,lineID,spellID)
		if event == "RAID_BOSS_EMOTE" then
			local fI,tI = nil
			if msg:find("spell:181293") and msg:find("INV_Bijou_Purple") then
				fI,tI = 201,300
			elseif msg:find("spell:181297") and msg:find("INV_Bijou_Orange") then
				fI,tI = 1,100
			elseif msg:find("spell:181300") and msg:find("INV_Bijou_Green") then
				fI,tI = 101,200
			end
			if fI and tI then
				local playerName = UnitName('player')
				for i=fI,tI do
					local name = VExRT.Bossmods.Kormrok[i]
					if name and ExRT.F.delUnitNameServer(name) == playerName then
						local pos = i % 100
						ExRT.F.Arrow:ShowRunTo(Kormrok.runes[pos][1],Kormrok.runes[pos][2],2,6,true,true)
						return
					end
				end
			end
		elseif event == "GROUP_ROSTER_UPDATE" then
			if Kormrok.setupFrame:IsShown() then
				Kormrok:ReRoster(phaseNow)
			end
		end
	end
	
	Kormrok.setupFrame.scale = ELib:Slider(Kormrok.setupFrame):_Size(70,8):Point("TOPRIGHT",-30,-5):Range(50,100,true):SetTo((VExRT.Bossmods.KormrokScale or 1)*100):Scale(1 / (VExRT.Bossmods.KormrokScale or 1)):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.Bossmods.KormrokScale = event / 100
		ExRT.F.SetScaleFixTR(Kormrok.setupFrame,VExRT.Bossmods.KormrokScale)
		self:SetScale(1 / VExRT.Bossmods.KormrokScale)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	Kormrok.setupFrame.pings = {}
	local function SetupFramePingsOnEnter(self)
		self.colors = {self.icon:GetVertexColor()}
		self.icon:SetVertexColor(1,.3,1,1)
	end
	local function SetupFramePingsOnLeave(self)
	  	self.icon:SetVertexColor(unpack(self.colors))
	end
	local function SetupFramePingsOnClick(self,button)
		if button == "RightButton" then
			self.colors = {.3,1,.3,1}
			VExRT.Bossmods.Kormrok[ (phaseNow-1)*100 + self._i] = nil
			Kormrok:ReRoster(phaseNow)
			
			DisableSync()
			return
		end
		Kormrok.raidRoster.pos = self._i
		Kormrok.raidRoster.title:SetText(L.BossmodsKromogSelectPlayer..self._i)
		Kormrok.raidRoster:Show()
	end
	for i=1,#Kormrok.runes do
		local x = (abs(Kormrok.runes[i][1]-Kormrok.map[1])) / (abs(Kormrok.map[3] - Kormrok.map[1]))
		local y = (abs(Kormrok.runes[i][2]-Kormrok.map[2])) / (abs(Kormrok.map[4] - Kormrok.map[2]))
		local currPing = CreateFrame('Button',nil,Kormrok.setupFrame)
		Kormrok.setupFrame.pings[i] = currPing
		currPing:SetSize(32,32)
		currPing.icon = currPing:CreateTexture(nil,"ARTWORK")
		currPing.icon:SetAllPoints()
		currPing.icon:SetTexture("Interface\\AddOns\\ExRT\\media\\KormrokRune.tga")
		currPing.num = ELib:Text(currPing,i,12):Size(30,15):Point(0,0):Top():Color():Outline()
		currPing.name = ELib:Text(currPing,"Player"..i,11):Size(75,15):Point(0,-12):Top():Color():Outline()
		
		currPing:SetScript("OnEnter",SetupFramePingsOnEnter)
		currPing:SetScript("OnLeave",SetupFramePingsOnLeave)
		currPing:RegisterForClicks("RightButtonDown","LeftButtonDown")
		currPing._i = i
		currPing:SetScript("OnClick",SetupFramePingsOnClick)
		
		if x >= Kormrok.image[1] and x <= Kormrok.image[3] and y >= Kormrok.image[2] and y <= Kormrok.image[4] then
			currPing:SetPoint("CENTER",Kormrok.setupFrame.map,"TOPLEFT", (x - Kormrok.image[1])/(Kormrok.image[3]-Kormrok.image[1])*Kormrok.width,-(y - Kormrok.image[2])/(Kormrok.image[4]-Kormrok.image[2])*(Kormrok.image_avg * Kormrok.width))
		end
	end
	
	local function KormrokClearConfirm()
		for i=1,300 do
			VExRT.Bossmods.Kormrok[i] = nil
		end
		Kormrok:ReRoster(phaseNow)
		
		DisableSync()
	end
	
	Kormrok.setupFrame.clearButton = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogClear):Size(120,20):Point("BOTTOMLEFT",7,22):OnClick(function (self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_CLEAR"] = {
			text = L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = KormrokClearConfirm,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_CLEAR")
	end)
	
	Kormrok.setupFrame.testButton = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogTest):Size(120,20):Point("BOTTOMRIGHT",Kormrok.setupFrame.clearButton,"TOPRIGHT",0,2):OnClick(function (self)
		KormrokFrameOnEvent(Kormrok.setupFrame,"RAID_BOSS_EMOTE",
			phaseNow == 1 and "INV_Bijou_Orange spell:181297" or
			phaseNow == 1 and "INV_Bijou_Green spell:181300" or
			"INV_Bijou_Purple spell:181293"	
		)
		Kormrok.setupFrame:Hide()
		C_Timer.NewTimer(6,function() Kormrok.setupFrame:Show() end)
	end)
	
	VExRT.Bossmods.KormrokSetups = VExRT.Bossmods.KormrokSetups or {}
	local function SetupsDropDown_Load(_,arg)
		for i=1,300 do
			VExRT.Bossmods.Kormrok[i] = VExRT.Bossmods.KormrokSetups[arg][i]
		end
		Kormrok:ReRoster(phaseNow)
		DisableSync()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Clear(_,arg)
		for i=1,300 do
			VExRT.Bossmods.KormrokSetups[arg][i] = nil
		end
		VExRT.Bossmods.KormrokSetups[arg].date = nil
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Save(_,arg)
		for i=1,300 do
			VExRT.Bossmods.KormrokSetups[arg][i] = VExRT.Bossmods.Kormrok[i]
		end
		VExRT.Bossmods.KormrokSetups[arg].date = time()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Close()
		CloseDropDownMenus()
	end
	
	local setupsDropDown = CreateFrame("Frame", "ExRT_Kormrok_SetupsDropDown", nil, "UIDropDownMenuTemplate")
	Kormrok.setupFrame.setupsButton = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogSetups):Size(120,20):Point("BOTTOMRIGHT",Kormrok.setupFrame.testButton,"TOPRIGHT",0,2):OnClick(function (self)
		VExRT.Bossmods.KormrokSetups = VExRT.Bossmods.KormrokSetups or {}
	
		local dropDown = {
			{ text = L.BossmodsKromogSetups, isTitle = true, notCheckable = true, notClickable = true},
		}
		for i=1,5 do
			VExRT.Bossmods.KormrokSetups[i] = VExRT.Bossmods.KormrokSetups[i] or {}
		
			local subMenu = nil
			local saveMenu = { text = L.BossmodsKromogSetupsSave, func = SetupsDropDown_Save, arg1 = i, notCheckable = true }
			local loadMenu = { text = L.BossmodsKromogSetupsLoad, func = SetupsDropDown_Load, arg1 = i, notCheckable = true }
			local clearMenu = { text = L.BossmodsKromogSetupsClear, func = SetupsDropDown_Clear, arg1 = i, notCheckable = true }
			
			local isExists = VExRT.Bossmods.KormrokSetups[i].date
			local dateText = ""
			if isExists then
				subMenu = {loadMenu,saveMenu,clearMenu}
				dateText = ". "..date("%H:%M:%S %d.%m.%Y",isExists)
			else
				subMenu = {saveMenu}
			end
			
			dropDown[i+1] = {
				text = i..dateText, hasArrow = true, menuList = subMenu, notCheckable = true
			}
		end
		dropDown[7] = { text = L.BossmodsKromogSetupsClose, func = SetupsDropDown_Close, notCheckable = true }
		EasyMenu(dropDown, setupsDropDown, "cursor", 10 , -15, "MENU")
	end)
		
	Kormrok.setupFrame.sendButton = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogSend):Size(120,20):Point("BOTTOMRIGHT",Kormrok.setupFrame.setupsButton,"TOPRIGHT",0,2):OnClick(function (self)
		local line = ""
		local counter = 0
		ExRT.F.SendExMsg("kormrok","clear")
		for i=1,300 do
			if VExRT.Bossmods.Kormrok[i] then
				line = line .. i.."\t"..VExRT.Bossmods.Kormrok[i].."\t"
				counter = counter + 1
				if counter > 2 then
					ExRT.F.SendExMsg("kormrok",line)
					counter = 0
					line = ""
				end
			end
		end
		if line ~= "" then
			ExRT.F.SendExMsg("kormrok",line)
		end
	end)
	
	Kormrok.setupFrame.onlyTrustedChk = ELib:Check(Kormrok.setupFrame,L.BossmodsKromogOnlyTrusted,not VExRT.Bossmods.Kormrok.UpdatesFromAll):Point("BOTTOMLEFT",Kormrok.setupFrame.sendButton,"TOPLEFT",0,2):Scale(.9):Tooltip(L.BossmodsKromogOnlyTrustedTooltip):OnClick(function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Kormrok.UpdatesFromAll = nil
		else
			VExRT.Bossmods.Kormrok.UpdatesFromAll = true
		end
	end)
	
	Kormrok.setupFrame.lastUpdate = ELib:Text(Kormrok.setupFrame,"",12):Size(500,20):Point("BOTTOMLEFT",Kormrok.setupFrame,"BOTTOMLEFT",7,5):Bottom():Color(1,1,1):Outline()
	
	local phaseBackground = Kormrok.setupFrame:CreateTexture(nil, "BACKGROUND",nil,2)
	phaseBackground:SetPoint("TOPLEFT",0,0)
	phaseBackground:SetPoint("BOTTOMRIGHT",Kormrok.setupFrame,"TOPRIGHT",0,-50)
	phaseBackground:SetColorTexture( 1, 1, 1, 1)
	
	local phaseOrange = ELib:Icon(Kormrok.setupFrame,"Interface\\Icons\\INV_Bijou_Orange.blp",72,true):Point("CENTER",Kormrok.setupFrame,"BOTTOMLEFT",224,94)
	phaseOrange.phase = 1
	
	phaseOrange.copy = ELib:Button(Kormrok.setupFrame,L.BossmodsKormrokCopy):Size(65,14):Point("CENTER",phaseOrange,0,-50)
	phaseOrange.copy.phase = 1
	phaseOrange.copy.icon = "Interface\\Icons\\INV_Bijou_Orange.blp"
	
	phaseOrange.clear = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogSetupsClear):Size(65,14):Point("CENTER",phaseOrange,0,-50)
	phaseOrange.clear.phase = 1

	local phaseGreen = ELib:Icon(Kormrok.setupFrame,"Interface\\Icons\\INV_Bijou_Green.blp",48,true):Point("CENTER",Kormrok.setupFrame,"BOTTOMLEFT",294,94)
	phaseGreen.phase = 2

	phaseGreen.copy = ELib:Button(Kormrok.setupFrame,L.BossmodsKormrokCopy):Size(65,14):Point("CENTER",phaseGreen,0,-50)
	phaseGreen.copy.phase = 2
	phaseGreen.copy.icon = "Interface\\Icons\\INV_Bijou_Green.blp"
	
	phaseGreen.clear = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogSetupsClear):Size(65,14):Point("CENTER",phaseGreen,0,-50)
	phaseGreen.clear.phase = 2

	local phasePurple = ELib:Icon(Kormrok.setupFrame,"Interface\\Icons\\INV_Bijou_Purple.blp",48,true):Point("CENTER",Kormrok.setupFrame,"BOTTOMLEFT",364,94)
	phasePurple.phase = 3

	phasePurple.copy = ELib:Button(Kormrok.setupFrame,L.BossmodsKormrokCopy):Size(65,14):Point("CENTER",phasePurple,0,-50)
	phasePurple.copy.phase = 3
	phasePurple.copy.icon = "Interface\\Icons\\INV_Bijou_Purple.blp"
	
	phasePurple.clear = ELib:Button(Kormrok.setupFrame,L.BossmodsKromogSetupsClear):Size(65,14):Point("CENTER",phasePurple,0,-50)
	phasePurple.clear.phase = 1
	
	local phaseBackgroundColors = {
		{r = 1, g = 190/255, b = 82/255},
		{r = 65/255, g = 239/255, b = 85/255},
		{r = 146/255, g = 6/255, b = 185/255},
	}
	local function SetPhaseButton(self)
		phaseNow = self.phase
		
		phaseOrange:SetSize(phaseNow == 1 and 72 or 48,phaseNow == 1 and 72 or 48)
		phaseGreen:SetSize(phaseNow == 2 and 72 or 48,phaseNow == 2 and 72 or 48)
		phasePurple:SetSize(phaseNow == 3 and 72 or 48,phaseNow == 3 and 72 or 48)
		
		phaseOrange.copy:SetShown(phaseNow ~= 1)
		phaseGreen.copy:SetShown(phaseNow ~= 2)
		phasePurple.copy:SetShown(phaseNow ~= 3)

		phaseOrange.clear:SetShown(phaseNow == 1)
		phaseGreen.clear:SetShown(phaseNow == 2)
		phasePurple.clear:SetShown(phaseNow == 3)
		
		phaseBackground:SetGradientAlpha("VERTICAL", 
			phaseBackgroundColors[phaseNow].r,phaseBackgroundColors[phaseNow].g,phaseBackgroundColors[phaseNow].b, 0,
			phaseBackgroundColors[phaseNow].r,phaseBackgroundColors[phaseNow].g,phaseBackgroundColors[phaseNow].b, 0.5
		)
		
		Kormrok:ReRoster(phaseNow)
	end
	local function SetPhaseCopyButton(self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_COPY"] = {
			text = L.BossmodsKormrokCopy .. " |T" ..self.icon..":24|t?",
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				for i=1,100 do
					VExRT.Bossmods.Kormrok[ (phaseNow-1)*100 + i ] = VExRT.Bossmods.Kormrok[ (self.phase-1)*100 + i ]
				end
				Kormrok:ReRoster(phaseNow)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_COPY")
	end
	
	local function SetPhaseClearButton(self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_CLEAR"] = {
			text = L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				for i=1,100 do
					VExRT.Bossmods.Kormrok[ (phaseNow-1)*100 + i ] = nil
				end
				Kormrok:ReRoster(phaseNow)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_CLEAR")
	end
	
	phaseOrange:SetScript("OnClick",SetPhaseButton)
	phaseGreen:SetScript("OnClick",SetPhaseButton)
	phasePurple:SetScript("OnClick",SetPhaseButton)

	phaseOrange.copy:SetScript("OnClick",SetPhaseCopyButton)
	phaseGreen.copy:SetScript("OnClick",SetPhaseCopyButton)
	phasePurple.copy:SetScript("OnClick",SetPhaseCopyButton)
	
	phaseOrange.clear:SetScript("OnClick",SetPhaseClearButton)
	phaseGreen.clear:SetScript("OnClick",SetPhaseClearButton)
	phasePurple.clear:SetScript("OnClick",SetPhaseClearButton)

	
	phaseOrange:Click()
	Kormrok.setupFrame.phaseOrange = phaseOrange

	Kormrok.raidRoster = ELib:Popup(L.BossmodsKromogSelectPlayer):Size(80*4+25,113+14)
	Kormrok.raidRoster:SetScript("OnShow",function (self)
		Kormrok:UpdateSelectRoster(phaseNow)
	end)
	Kormrok.raidRoster.buttons = {}
	local function RaidRosterButtonOnEnter(self)
		self.hl:Show()
	end
	local function RaidRosterButtonOnLeave(self)
		self.hl:Hide()
	end
	local function RaidRosterButtonOnClick(self)
		local fI = (phaseNow - 1) * 100
		for i=fI+1,fI+100 do
			if VExRT.Bossmods.Kormrok[i] == self._name then
				VExRT.Bossmods.Kormrok[i] = nil
			end
		end
		VExRT.Bossmods.Kormrok[fI + Kormrok.raidRoster.pos] = self._name
		Kormrok:ReRoster(phaseNow)
		Kormrok.raidRoster:Hide()
		
		DisableSync()
	end
	for i=1,4 do
		for j=1,5 do
			local pos = (i-1)*5+j
			Kormrok.raidRoster.buttons[pos] = CreateFrame('Button',nil,Kormrok.raidRoster)
			Kormrok.raidRoster.buttons[pos]:SetPoint("TOPLEFT",15+(i-1)*80,-25-(j-1)*14)
			Kormrok.raidRoster.buttons[pos]:SetSize(80,14)
			ExRT.lib.CreateHoverHighlight(Kormrok.raidRoster.buttons[pos])
			Kormrok.raidRoster.buttons[pos]:SetScript("OnEnter",RaidRosterButtonOnEnter)
			Kormrok.raidRoster.buttons[pos]:SetScript("OnLeave",RaidRosterButtonOnLeave)
			Kormrok.raidRoster.buttons[pos].name = ELib:Text(Kormrok.raidRoster.buttons[pos],"",12):Size(80,14):Point(0,0):Color(1,1,1):Shadow()
			Kormrok.raidRoster.buttons[pos]._name = nil
			Kormrok.raidRoster.buttons[pos]:SetScript("OnClick",RaidRosterButtonOnClick)
		end
	end
	Kormrok.raidRoster.clearButton = CreateFrame('Button',nil,Kormrok.raidRoster)
	Kormrok.raidRoster.clearButton:SetPoint("BOTTOMRIGHT",Kormrok.raidRoster,"BOTTOMRIGHT",-11,12)
	Kormrok.raidRoster.clearButton:SetSize(80,14)
	ExRT.lib.CreateHoverHighlight(Kormrok.raidRoster.clearButton)
	Kormrok.raidRoster.clearButton:SetScript("OnEnter",function(self)
		self.hl:Show()
	end)
	Kormrok.raidRoster.clearButton:SetScript("OnLeave",function(self)
		self.hl:Hide()
	end)
	
	Kormrok.raidRoster.clearButton.name = ELib:Text(Kormrok.raidRoster.clearButton,L.BossmodsKromogClear,12):Size(80,14):Point(0,0):Right():Middle():Color(1,1,1):Shadow()
	Kormrok.raidRoster.clearButton:SetScript("OnClick",function(self)
		VExRT.Bossmods.Kormrok[Kormrok.raidRoster.pos] = nil
		Kormrok:ReRoster(phaseNow)
		Kormrok.raidRoster:Hide()
		
		DisableSync()
	end)
	
	Kormrok.raidRoster.hideChk = ELib:Check(Kormrok.raidRoster,L.BossmodsKromogHidePlayers,true):Point("BOTTOMLEFT",10,7):Scale(.8):OnClick(function (self)
	  	Kormrok.hidePlayers = self:GetChecked()
	  	Kormrok:UpdateSelectRoster(phaseNow)
	end)
	
	function Kormrok:RegisterEvents()
		Kormrok.setupFrame:UnregisterAllEvents()
		Kormrok.setupFrame:RegisterEvent("RAID_BOSS_EMOTE")
		Kormrok.setupFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		if not VExRT.Bossmods.Kormrok.AlwaysArrow then
			--Kormrok.setupFrame:RegisterEvent("ENCOUNTER_START")
			--Kormrok.setupFrame:RegisterEvent("ENCOUNTER_END")
		end
	end
	Kormrok:RegisterEvents()
	
	Kormrok.setupFrame:SetScript("OnEvent",KormrokFrameOnEvent)
	Kormrok.setupFrame:SetScript("OnShow",function (self)
		local isAlpha = false
		if IsInRaid() then
			if ExRT.F.IsPlayerRLorOfficer(UnitName('player')) then
				isAlpha = false
			else
				isAlpha = true
			end
		end
		if isAlpha then
			self.clearButton:SetAlpha(.2)
			self.sendButton:SetAlpha(.2)
			self.setupsButton:SetAlpha(.2)
		else
			self.clearButton:SetAlpha(1)
			self.sendButton:SetAlpha(1)
			self.setupsButton:SetAlpha(1)		
		end
	end)

	if not VExRT.Bossmods.Kormrok.name or not VExRT.Bossmods.Kormrok.time then
		Kormrok.setupFrame.lastUpdate:SetText("")
	else
		Kormrok.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kormrok.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kormrok.time)..")"..(not VExRT.Bossmods.Kormrok.sync and " *" or ""))
	end
	Kormrok:ReRoster(1)
	Kormrok.setupFrame:Show()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	if ExRT.Options.Frame:IsShown() then
		ExRT.Options.Frame:Hide()
	end
end

function Kormrok:addonMessage(sender, prefix, ...)
	if prefix == "kormrok" then
		if IsInRaid() and not VExRT.Bossmods.Kormrok.UpdatesFromAll and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
	
		local pos1,name1,pos2,name2,pos3,name3 = ...
		VExRT.Bossmods.Kormrok.time = time()
		VExRT.Bossmods.Kormrok.name = sender
		VExRT.Bossmods.Kormrok.sync = true
		if pos1 == "clear" then
			for i=1,300 do
				VExRT.Bossmods.Kormrok[i] = nil
			end
			return
		end
		
		if pos1 and name1 then
			pos1 = tonumber(pos1)
			if name1 == "-" then
				name1 = nil
			end
			VExRT.Bossmods.Kormrok[pos1] = name1
		end
		if pos2 and name2 then
			pos2 = tonumber(pos2)
			if name2 == "-" then
				name2 = nil
			end
			VExRT.Bossmods.Kormrok[pos2] = name2
		end
		if pos3 and name3 then
			pos3 = tonumber(pos3)
			if name3 == "-" then
				name3 = nil
			end
			VExRT.Bossmods.Kormrok[pos3] = name3
		end
		
		if Kormrok.setupFrame then
			Kormrok.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Kormrok.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Kormrok.time)..")")
			Kormrok:ReRoster( Kormrok:GetCurrentPhase() )
		end
	end
end

-----------------------------------------
-- Mannoroth
-----------------------------------------
local Mannoroth = {}
module.A.Mannoroth = Mannoroth

function Mannoroth:Load()
	local mainFrame = Mannoroth.setupFrame
	if mainFrame then
		mainFrame:Show()
		mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		mainFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		if ExRT.Options.Frame:IsShown() then
			ExRT.Options.Frame:Hide()
		end
		mainFrame.isEnabled = true
		return
	end
	
	mainFrame = ELib:Popup("Mannoroth"):Size(600,400)
	Mannoroth.setupFrame = mainFrame
	mainFrame:SetFrameStrata("HIGH")
	mainFrame:Show()
	
	VExRT.Bossmods.Mannoroth.Section = VExRT.Bossmods.Mannoroth.Section or {}
	
	local function removeButtonOnClick(self)
		for i=self._i2,10 do
			VExRT.Bossmods.Mannoroth.Section[ self._i1 ][i] = VExRT.Bossmods.Mannoroth.Section[ self._i1 ][i+1]
		end
		mainFrame:UpdateSections()
	end
	
	mainFrame.markSection = {}
	mainFrame.sectionSelected = 1
	for i=1,3 do
		local frame = CreateFrame("Button",nil,mainFrame)
		mainFrame.markSection[i] = frame
		
		frame:SetSize(170,220)
		frame:SetPoint("TOP",-195 + (i-1)*195,-30)
		
		frame.shadow = ELib:Shadow(frame,25)
		frame.shadow:SetBackdropBorderColor(1,1,1,.45)
		
		if i==1 then
			frame.shadow:SetBackdropBorderColor(0,1,0,.45)
		end
		
		local icon = ELib:Icon(frame,"Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i,32):Point("TOP",0,-10)
		
		frame._i = i
		frame:SetScript("OnClick",function(self)
			mainFrame.sectionSelected = self._i
			for j=1,3 do
				if j ~= self._i then
					mainFrame.markSection[j].shadow:SetBackdropBorderColor(1,1,1,.45)
				else
					mainFrame.markSection[j].shadow:SetBackdropBorderColor(0,1,0,.45)
				end
			end
		end)
		
		frame.names = {}
		for j=1,10 do
			local line = CreateFrame("Frame",nil,frame)
			frame.names[j] = line
			line:SetPoint("TOP",0,-40-j*14)
			line:SetSize(170,14)
			
			line.name = ELib:Text(line,UnitName'player',12):Size(145,12):Point("LEFT",20,0):Color(1,1,1):Shadow()
			
			local remove = CreateFrame("Button",nil,line)
			line.remove = remove
			remove:SetPoint("LEFT",2,0)
			remove:SetSize(14,14)
			
			remove.texture = remove:CreateTexture(nil,"ARTWORK")
			remove.texture:SetAllPoints()
			remove.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
			remove.texture:SetTexCoord(0.5,0.5625,0.5,0.625)
			remove.texture:SetVertexColor(1,1,1,.7)
			remove.texture:Hide()
			remove:SetNormalTexture(remove.texture)
			
			remove.hover = remove:CreateTexture(nil,"ARTWORK")
			remove.hover:SetAllPoints()
			remove.hover:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
			remove.hover:SetTexCoord(0.5,0.5625,0.5,0.625)
			remove.hover:SetVertexColor(0.7,0,0,1)
			remove.hover:Hide()
			remove:SetHighlightTexture(remove.hover)
			
			remove:SetScript("OnClick",removeButtonOnClick)
			remove._i1 = i
			remove._i2 = j
		end
		
		
		VExRT.Bossmods.Mannoroth.Section[i] = VExRT.Bossmods.Mannoroth.Section[i] or {}
	end
	
	local function raidNamesOnEnter(self)
		self.name:SetShadowColor(0.2, 0.2, 0.2, 1)
	end
	local function raidNamesOnLeave(self)
		self.name:SetShadowColor(0, 0, 0, 1)
	end
	local function raidNamesOnClick(self)
		local list = VExRT.Bossmods.Mannoroth.Section[ mainFrame.sectionSelected ]
		if #list >= 10 then
			return
		end
		list[#list + 1] = self._name
		mainFrame:UpdateSections()
	end
	
	mainFrame.raidRoster = {}
	for i=1,6 do
		for j=1,5 do
			local line = CreateFrame("Button",nil,mainFrame)
			mainFrame.raidRoster[(i-1)*5+j] = line
			line:SetPoint("TOPLEFT",mainFrame.markSection[1],"BOTTOMLEFT",(i-1)*94,-5-j*14)
			line:SetSize(90,14)
			
			line.name = ELib:Text(line,UnitName'player',12):Size(90,12):Point("LEFT",0,0):Color(1,1,1):Shadow()
			line._name = (UnitName'player') .. ((i-1)*5+j)
			
			line:SetScript("OnClick", raidNamesOnClick)
			line:SetScript("OnEnter", raidNamesOnEnter)
			line:SetScript("OnLeave", raidNamesOnLeave)
		end
	end
	
	function mainFrame:UpdateRoster()
		local raidData = {{},{},{},{},{},{}}
		for i=1,40 do
			local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
			if name and subgroup <= 6 then
				raidData[subgroup][ #raidData[subgroup]+1 ] = {name,class}
			end
		end
		for i=1,6 do
			for j=1,5 do
				local pos = (i-1)*5+j
				local data = raidData[i][j]
				local line = mainFrame.raidRoster[pos]
				if line and data then
					line._name = data[1]
					line.name:SetText("|c"..ExRT.F.classColor(data[2])..data[1])
					line:Show()
				elseif line then
					line:Hide()
				end
			end
		end
	end
	
	function mainFrame:UpdateSections()
		local selectedRoster = {}
		for i=1,3 do
			local list = VExRT.Bossmods.Mannoroth.Section[i]
			for j=1,10 do
				local line = mainFrame.markSection[i].names[j]
				if list[j] then
					line.name:SetText( list[j] )
					line:Show()
					
					selectedRoster[ list[j] ] = true
				else
					line:Hide()
				end
			end
		end
		for i=1,6 do
			for j=1,5 do
				local line = mainFrame.raidRoster[(i-1)*5+j]
				local name = line._name
				if name then
					if selectedRoster[ name ] then
						line:SetAlpha(.2)
					else
						line:SetAlpha(1)
					end
				end
			end
		end
	end
	
	mainFrame:UpdateRoster()
	mainFrame:UpdateSections()
	
	mainFrame.lastUpdate = ELib:Text(mainFrame,"",12):Size(430,20):Point("BOTTOMLEFT",10,10):Bottom():Color():Outline()

	if not VExRT.Bossmods.Mannoroth.name or not VExRT.Bossmods.Mannoroth.time then
		mainFrame.lastUpdate:SetText("")
	else
		mainFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..ExRT.F.delUnitNameServer(VExRT.Bossmods.Mannoroth.name).." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Mannoroth.time)..")")
	end
	
	mainFrame.sendButton = ELib:Button(mainFrame,L.BossmodsKromogSend):Size(120,20):Point("BOTTOMRIGHT",-10,10):OnClick(function (self)
		local line = ""
		local counter = 0
		ExRT.F.SendExMsg("mannoroth","num\t"..(VExRT.Bossmods.Mannoroth.number or 3))
		for i=1,3 do
			for j=1,10 do
				local name = VExRT.Bossmods.Mannoroth.Section[i][j] or "-"
				line = line .. (i*10+j) .. "\t" .. name .. "\t"
				counter = counter + 1
				if counter > 2 then
					ExRT.F.SendExMsg("mannoroth",line)
					line = ""
					counter = 0
				end
			end
		end
		if line ~= "" then
			ExRT.F.SendExMsg("mannoroth",line)
		end
	end)
	
	local tableBuilder = {}
	local myName = UnitName("player")
	local markIDtoSelection = {
		[8] = 1,
		[7] = 2,
		[6] = 3,
	}

	local function ShowArrow(isEmpowered)
		ExRT.F.Arrow:Hide()
		local blackList = {}
		for i=8,6,-1 do
			if tableBuilder[i] then
				blackList[ ExRT.F.delUnitNameServer(tableBuilder[i]) ] = true
			end
		end
		for i=8,6,-1 do
			if tableBuilder[i] then
				local counter = 1
				for j=1,10 do
					local name = VExRT.Bossmods.Mannoroth.Section[ markIDtoSelection[i] ][j]
					if name and not blackList[ ExRT.F.delUnitNameServer(name) ] then
						counter = counter + 1
						if ExRT.F.delUnitNameServer(name) == myName then
							ExRT.F.Arrow:ShowToPlayer(tableBuilder[i],nil,nil,4,nil,true)
						end
						--print( name,tableBuilder[i] )
						if counter > (VExRT.Bossmods.Mannoroth.number or 3) and isEmpowered then
							break
						end
					end
				end
			end
		end
	end
	
	local markNow = 8
	
	mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	mainFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	mainFrame:SetScript("OnEvent",function(_,event,timestamp,cleu_event,hideCaster,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,spellName,school,auraType,amount)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if cleu_event == "SPELL_AURA_APPLIED" and (spellID == 182006 or spellID == 181597) then
				if markNow == 8 then
					wipe(tableBuilder)
				end
				local markFixed = markIDtoSelection[markNow]
				if markFixed and ExRT.F.table_len(VExRT.Bossmods.Mannoroth.Section[markFixed]) > 0 then
					SetRaidTarget(destName, markFixed)
				end
				tableBuilder[markNow] = destName
				ShowArrow(spellID == 182006)
				markNow = markNow - 1
				C_Timer.NewTimer(3,function() markNow = 8 end)
			elseif cleu_event == "SPELL_AURA_REMOVED" and (spellID == 182006 or spellID == 181597) then
				SetRaidTarget(destName, 0)
			end
		elseif event == "GROUP_ROSTER_UPDATE" then
			mainFrame:UpdateRoster()
			mainFrame:UpdateSections()
		end
	end)
	
	mainFrame.isEnabled = true
end

function Mannoroth:addonMessage(sender, prefix, ...)
	if prefix == "mannoroth" then
		if IsInRaid() and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
		
		VExRT.Bossmods.Mannoroth = VExRT.Bossmods.Mannoroth or {}
		VExRT.Bossmods.Mannoroth.Section = VExRT.Bossmods.Mannoroth.Section or {}
		for i=1,3 do VExRT.Bossmods.Mannoroth.Section[i] = VExRT.Bossmods.Mannoroth.Section[i] or {} end
	
		local pos1,name1,pos2,name2,pos3,name3 = ...
		VExRT.Bossmods.Mannoroth.time = time()
		VExRT.Bossmods.Mannoroth.name = sender
		VExRT.Bossmods.Mannoroth.sync = true
		if pos1 == "num" then
			VExRT.Bossmods.Mannoroth.number = tonumber(name1)
			return
		end
		
		if pos1 and name1 then
			pos1 = tonumber(pos1)
			if name1 == "-" then
				name1 = nil
			end
			local col = floor((pos1 - 1) / 10)
			local pos = pos1 % 10
			if pos == 0 then pos = 10 end
			VExRT.Bossmods.Mannoroth.Section[col][pos] = name1
		end
		if pos2 and name2 then
			pos2 = tonumber(pos2)
			if name2 == "-" then
				name2 = nil
			end
			local col = floor((pos2 - 1) / 10)
			local pos = pos2 % 10
			if pos == 0 then pos = 10 end
			VExRT.Bossmods.Mannoroth.Section[col][pos] = name2
		end
		if pos3 and name3 then
			pos3 = tonumber(pos3)
			if name3 == "-" then
				name3 = nil
			end
			local col = floor((pos3 - 1) / 10)
			local pos = pos3 % 10
			if pos == 0 then pos = 10 end
			VExRT.Bossmods.Mannoroth.Section[col][pos] = name3
		end
		
		if Mannoroth.setupFrame then
			Mannoroth.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..ExRT.F.delUnitNameServer(VExRT.Bossmods.Mannoroth.name).." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Mannoroth.time)..")")
			Mannoroth.setupFrame:UpdateSections()

			Mannoroth.setupFrame:UpdateRoster()
			Mannoroth.setupFrame:UpdateSections()
		end
	end
end

-----------------------------------------
-- Archimonde
-----------------------------------------
local Archimonde = {}
module.A.Archimonde = Archimonde

--[[

VExRT.Bossmods.ArchimondeRadius  - Radar Radius
VExRT.Bossmods.ArchimondeLineSize  - Line Size (2,4,6,8,10,12)
VExRT.Bossmods.ArchimondeDisableText  - Disable Text

]]

function Archimonde:Load()
	ExRT.Options.Frame:Hide()

	local frame = Archimonde.mainframe
	if frame then
		frame:Show()
		frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		frame:RegisterEvent('ENCOUNTER_START')
		frame:RegisterEvent('ENCOUNTER_END')
		frame.isEnabled = true
		return
	end

	local FRAME_SIZE = 200
	local VECTOR_LENGTH = 300
	local VECTOR_DEPTH = 1.5
	local VECTOR_DEPTH_ARCHIMONDE = 1.5
	local VECTOR_DEPTH_XAVIUS = 4.5
	local VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius or 20
	local VIEW_DISTANCE2 = VIEW_DISTANCE * 2
	local LINES_COLORS = {
		[1] = {r = 0.6, g = 1, b = 0.6, a = 1},
		[2] = {r = 1, g= .5, b = 0, a = 1},
		[3] = {r = 1, g = 0.6, b = 0.6, a = 1},
		[4] = {r = 0.2, g = 0.6, b = 0.85, a = 1},
	}

	local isXavius = nil

	frame = CreateFrame("Frame",nil,UIParent)
	Archimonde.mainframe = frame
	frame:SetSize(FRAME_SIZE,FRAME_SIZE)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.ArchimondeLeft = self:GetLeft()
		VExRT.Bossmods.ArchimondeTop = self:GetTop()
	end)
	if VExRT.Bossmods.ArchimondeLeft and VExRT.Bossmods.ArchimondeTop then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.ArchimondeLeft,VExRT.Bossmods.ArchimondeTop)
	else
		frame:SetPoint("CENTER",-200,0)
	end
	
	if VExRT.Bossmods.Alpha then frame:SetAlpha(VExRT.Bossmods.Alpha/100) end
	--if VExRT.Bossmods.Scale then frame:SetScale(VExRT.Bossmods.Scale/100) end
	
	VExRT.Bossmods.ArchimondeRadius = 40
	
	frame.isEnabled = true
	
	frame.back = frame:CreateTexture(nil, "BACKGROUND")
	frame.back:SetColorTexture(.7,.7,.7,.4)
	frame.back:SetAllPoints()
	
	frame.player = frame:CreateTexture(nil, "OVERLAY")
	frame.player:SetSize(32,32)
	frame.player:SetPoint("CENTER",0,0)
	frame.player:SetTexture("Interface\\MINIMAP\\MinimapArrow")
	
	ELib:Shadow(frame,15,20)
	
	frame.close = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],16,true):Point("TOPRIGHT",2,18)
	frame.close.texture:SetTexCoord(0.5,0.5625,0.5,0.625)
	frame.close:SetScript("OnClick",function(self)
		self:GetParent():Hide()
	end)
	frame.close:SetScript("OnEnter",function(self)
		self.texture:SetVertexColor(1,0,.7,1)
	end)
	frame.close:SetScript("OnLeave",function(self)
		self.texture:SetVertexColor(1,1,1,1)
	end)

	frame.lines = {}
	local SetLine,RotateTexture,RotateCoordPair
	do
		local cos, sin = math.cos, math.sin
		function RotateCoordPair(x,y,ox,oy,a,asp)
			y=y/asp
			oy=oy/asp
			return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
		end
		function RotateTexture(self,angle,xT,yT,xB,yB,xC,yC,userAspect)
			local aspect = userAspect or (xT-xB)/(yT-yB)
			local g1,g2 = RotateCoordPair(xT,yT,xC,yC,angle,aspect)
			local g3,g4 = RotateCoordPair(xT,yB,xC,yC,angle,aspect)
			local g5,g6 = RotateCoordPair(xB,yT,xC,yC,angle,aspect)
			local g7,g8 = RotateCoordPair(xB,yB,xC,yC,angle,aspect)
		
			self:SetTexCoord(g1,g2,g3,g4,g5,g6,g7,g8)
		end
		function SetLine(i,fX,fY,tX,tY,c)
			local line = frame.lines[i]
			if not line then
				line = frame:CreateTexture(nil, "BORDER", nil, 5)
				frame.lines[i] = line
				line:SetTexture("Interface\\AddOns\\ExRT\\media\\line"..(VExRT.Bossmods.ArchimondeLineSize or 12).."px")
				line:SetTexture("Interface\\AddOns\\ExRT\\media\\line12px")
				line:SetSize(256,256)
				line:SetVertexColor(0.6, 1, 0.6, 1)
			end
			local toDown = tY < fY
			if toDown then
				tY,fY = fY,tY
			end
			local size = max(tX-fX,tY-fY)
			local changeSize = (1 - (size / 256)) / 2
			local min,max = changeSize,1 - changeSize
			local angle
			if tX-fX == 0 then
				angle = 90
			else
				angle = atan( (tY-fY)/(tX-fX) )
			end
			if toDown then
				angle = -angle
			end
			line:SetAlpha(1)
			line:SetSize(size,size)
			RotateTexture(line,(PI/180)*angle,min,min,max,max,.5,.5)
			
			line:SetPoint("CENTER",frame,"BOTTOMLEFT",fX + (tX - fX)/2, fY + (tY - fY)/2)
			c = c or 1
			local color_list = LINES_COLORS[c]
			line:SetVertexColor(color_list.r, color_list.g, color_list.b, color_list.a)
			
			if c == 2 then
				line:SetDrawLayer("BORDER", 6)
			elseif c == 3 then
				line:SetDrawLayer("BORDER", 5)
			else
				line:SetDrawLayer("BORDER", 4)
			end
			--line:Show()
		end
	end
	
	local function UpdateLinesBold(size)
		VExRT.Bossmods.ArchimondeLineSize = size
		size = size or 12
		for i=1,#frame.lines do
			frame.lines[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\line"..size.."px")
			frame.lines[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\line12px")
		end
		
		local rad = VExRT.Bossmods.ArchimondeRadius or 20
		if rad > 30 then
			rad = 10
		else
			rad = 12
		end
		for i=1,#frame.players do
			frame.players[i]:SetFont(ExRT.F.defFont, rad, "OUTLINE")
		end
	end

	
	frame.players = {}
	local function SetPlayer(i,data,pX,pY)
		if VExRT.Bossmods.ArchimondeDisableText then
			return
		end
		local text = frame.players[i]
		if not text then
			text = frame:CreateFontString(nil,"ARTWORK")
			frame.players[i] = text
			local rad = (VExRT.Bossmods.ArchimondeRadius or 20) > 30
			text:SetFont(ExRT.F.defFont, rad and 10 or 12, "OUTLINE")
		end
		text:SetPoint("CENTER",frame,"BOTTOMLEFT",pX,pY)
		text:SetText(data)
		--text:Show()
		text:SetAlpha(1)
	end
	
	frame.circles = {}
	local function SetCircle(i,pX,pY,c,moreAlpha)
		local circle = frame.circles[i]
		if not circle then
			circle = frame:CreateTexture(nil, "BACKGROUND", nil, 4)
			frame.circles[i] = circle
			circle:SetTexture("Interface\\AddOns\\ExRT\\media\\circle256")
		end
		local isPlayer = c == 4
		local half_size = FRAME_SIZE / VIEW_DISTANCE2 * (isPlayer and 30 or 25)
		local size = half_size * 2
		
		local width,height = size,size
		
		local npX,npY = pX - half_size,pY - half_size
		
		local L,R,T,B = 0,1,0,1
		local left = pX - half_size
		local right = pX + half_size
		if left < 0 then
			L = -left / size
			width = width - L * size
			
			npX = 0
		end
		if right > FRAME_SIZE then
			R = (right - FRAME_SIZE) / size
			width = width - R * size
			R = 1 - R
		end
		
		local bottom = pY - half_size
		local top = pY + half_size
		if bottom < 0 then
			B = -bottom / size
			height = height - B * size
			B = 1 - B
			
			npY = 0
		end
		if top > FRAME_SIZE then
			T = (top - FRAME_SIZE) / size
			height = height - T * size
		end
		if L == R or T == B then
			return
		end
		
		circle:SetAlpha(1)
		
		circle:SetTexCoord(L,R,T,B)
		
		circle:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",npX,npY)
		circle:SetSize(width,height)
		local color_list = LINES_COLORS[c or 1]
		local alpha = .7
		if isPlayer then
			if moreAlpha then
				alpha = 0
			else
				alpha = .25
			end
		elseif moreAlpha then
			alpha = .25
		end
		circle:SetVertexColor(color_list.r, color_list.g, color_list.b, alpha)
		
		if c == 3 then
			circle:SetDrawLayer("BORDER", 3)
		elseif c == 1 then
			circle:SetDrawLayer("BORDER", 2)
		else
			circle:SetDrawLayer("BORDER", 1)
		end
		
		--circle:Show()
	end
	
	local function GetContactPosition(x1,x2,x3,x4,y1,y2,y3,y4)
		local d = (x1-x2)*(y4-y3) - (y1-y2)*(x4-x3)
		local da= (x1-x3)*(y4-y3) - (y1-y3)*(x4-x3)
		local db= (x1-x2)*(y1-y3) - (y1-y2)*(x1-x3)
		
		local ta,tb=da/d,db/d
		
		if ta >= 0 and ta <= 1 and tb >=0 and tb <= 1 then
			local x=x1 + ta *(x2 - x1)
			local y=y1 + ta *(y2 - y1)
			
			return x,y
		end
	end
	
	local function IsDotIn(pX,pY,point1x,point2x,point3x,point4x,point1y,point2y,point3y,point4y)
		local D1 = (pX - point1x) * (point2y - point1y) - (pY - point1y) * (point2x - point1x)	--1,2
		local D2 = (pX - point2x) * (point3y - point2y) - (pY - point2y) * (point3x - point2x)	--2,3
		local D3 = (pX - point3x) * (point4y - point3y) - (pY - point3y) * (point4x - point3x)	--3,4
		local D4 = (pX - point4x) * (point1y - point4y) - (pY - point4y) * (point1x - point4x)	--4,1

		return (D1 < 0 and D2 < 0 and D3 < 0 and D4 < 0) or (D1 > 0 and D2 > 0 and D3 > 0 and D4 > 0)
	end
	
	local function dist(x1,y1,x2,y2)
		local dX = (x1 - x2)
		local dY = (y1 - y2)
		return sqrt(dX * dX + dY * dY)
	end
	local function dist_dot(x0,y0,x1,y1,x2,y2)
		local r1 = dist(x0,y0,x1,y1)
		local r2 = dist(x0,y0,x2,y2)
		local r12 = dist(x1,y1,x2,y2)
		
  		local a = y2 - y1
  		local b = x1 - x2
  		local c = - x1 * (y2 - y1) + y1 * (x2 - x1)
  		
  		local t = dist(a,b,0,0)
  		if c > 0 then
  			a = -a
  			b = -b
  			c = -c
  		end
  		return (a*x0+b*y0+c)/t
	end
	
	local function IsCircleIn(xC,yC,R,x1,y1,x2,y2)
		x1 = x1 - xC
		y1 = y1 - yC
		x2 = x2 - xC
		y2 = y2 - yC
		
		local dx = x2 - x1
		local dy = y2 - y1
		
		local a = dx*dx + dy*dy
		local b = 2 * (x1 * dx + y1 * dy)
		local c = x1 * x1 + y1*y1 - R*R
		
		if -b < 0 then
			return c < 0
		elseif -b < (2*a) then
			return (4*a*c - b*b) < 0
		else
			return (a+b+c) < 0
		end
	end
	
	local chainsList,chainsWipe = {},0
	local scheduleWipeChains = nil
	local function scheduleWipeChains_Func()
		scheduleWipeChains = nil
		wipe(chainsList)
		frame:Visibility()
	end
	
	local shackledList,shackledLast = {},0
	local function AddTestSchackled()
		local y,x = UnitPosition('player')
		shackledList[#shackledList + 1] = {x=x,y=y}
	end
	
	frame.Visibility = function(self)
		local chainsCount = table_len(chainsList)
		local shackledCount = table_len(shackledList)
		if chainsCount == 0 and shackledCount == 0 then
			self:Hide()
		end
	end
	
	local xaviusTarget1 = nil
	
	frame:SetScript("OnEvent",function(self,mainEvent,timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,...)
		if mainEvent == 'COMBAT_LOG_EVENT_UNFILTERED' then
			if event == "SPELL_AURA_APPLIED" then
				if spellID == 185014 then
					isXavius = nil
					VECTOR_DEPTH = VECTOR_DEPTH_ARCHIMONDE

					if scheduleWipeChains then
						scheduleWipeChains:Cancel()
						scheduleWipeChains = nil
					end
					scheduleWipeChains = C_Timer.NewTimer(7,scheduleWipeChains_Func)
				
					local currTime = GetTime()
					if (currTime - chainsWipe) > 4 then
						wipe(chainsList)
					end
					chainsWipe = currTime
					
					chainsList[sourceName] = destName
					
					frame:Show()
				elseif spellID == 184964 then
					isXavius = nil
					VECTOR_DEPTH = VECTOR_DEPTH_ARCHIMONDE

					local _,_,difficulty = GetInstanceInfo()
					if VExRT.Bossmods.ArchimondeDisableShackled or difficulty ~= 16 then
						return
					end
					local currTime = GetTime()
					if (currTime - shackledLast) > 25 then
						wipe(shackledList)
					end
					shackledLast = currTime
					local y,x = UnitPosition(destName)
					if not x or y == 0 then
						return
					end
					shackledList[destName] = {x=x,y=y}
					
					frame:Show()
				elseif spellID == 211802 then
					isXavius = true
					VECTOR_DEPTH = VECTOR_DEPTH_XAVIUS

					if not xaviusTarget1 then
						xaviusTarget1 = destName
					else
						chainsList[destName] = xaviusTarget1
						
						frame:Show()
					end
				--[[
				elseif spellID == 206651 then
					isXavius = true
					
					shackledList[destName] = {p=destName}
					
					frame:Show()
				]]
				end
			elseif event == "SPELL_AURA_REMOVED" then
				if spellID == 185014 then
					chainsList[sourceName] = nil
					
					--if ExRT.F.table_len(chainsList) == 0 then frame:Hide() end
					frame:Visibility()
				elseif spellID == 184964 then
					shackledList[destName] = nil
					
					frame:Visibility()
				elseif spellID == 211802 then
					C_Timer.After(1,function()
						chainsList[destName] = nil
						xaviusTarget1 = nil
						
						frame:Visibility()
					end)
				--[[
				elseif spellID == 206651 then
					shackledList[destName] = nil
					
					frame:Visibility()
				]]
				end
			end
		elseif mainEvent == 'ENCOUNTER_START' or mainEvent == 'ENCOUNTER_END' then
			wipe(shackledList)
			wipe(chainsList)
			
			frame:Visibility()
		end
	end)
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:RegisterEvent('ENCOUNTER_START')
	frame:RegisterEvent('ENCOUNTER_END')
	
	local DEBUG_POS = {
		[1] = {y=5623.8002929688,x=4531.8999023438},
		[2] = {y=5654,x=4520},
		[3] = {y=5645.3002929688,x=4547.1000976563},
		[4] = {y=5648.5,x=4513.5},
		[5] = {y=5656.8999023438,x=4538.7001953125},
	}
	
	local function ARCHI_ADD(s,t,w)
		if w then
			wipe(chainsList)
		end
		chainsList[s] = t
	end
	local function ARCHI_WIPE()
		wipe(chainsList)
		wipe(shackledList)
	end
	local function ARCHI_TEST()
		wipe(chainsList)
		wipe(shackledList)
		local list = {}
		
		local groupSize = GetNumGroupMembers()
		
		for i=1,groupSize do
			local name = GetRaidRosterInfo(i)
			if name then
				list[#list + 1] = name
			end
		end
		
		if groupSize == 0 then
			local y,x = UnitPosition'player'
			y=y or 0
			x=x or 0
			wipe(DEBUG_POS)
			DEBUG_POS[1] = {x = x + 15, y = y + 15}
			DEBUG_POS[2] = {x = x - 15, y = y + 15}
			DEBUG_POS[3] = {x = x - 15, y = y - 15}
			DEBUG_POS[4] = {x = x + 15, y = y - 15}
			DEBUG_POS[5] = {x = x, y = y + 25}
			for i=1,5 do
				list[#list + 1] = i
			end
			list[#list + 1] = UnitName'player'
			
			if not VExRT.Bossmods.ArchimondeDisableShackled then
				shackledList[1] = {x = x, y = y - 20}
				shackledList[UnitName'player'] = {x = x + 27, y = y + 27}
			end
		else
			if not VExRT.Bossmods.ArchimondeDisableShackled then
				local name1 = list[math.random(1,#list)]
				local y,x = UnitPosition(name1)
				if x then
					shackledList[name1] = {x = x, y = y}
				end
				
				local name2 = list[math.random(1,#list)]
				if name2 ~= name1 then
					y,x = UnitPosition(name2)
					if x then
						shackledList[name2] = {x = x, y = y}
					end
				end
			end
		end
		

		--print('Archi TEST')
		while #list > 1 do
			local first = math.random(1,#list)
			local name = list[first]
			tremove(list,first)
			
			local second = math.random(1,#list)
			local name2 = list[second]
			tremove(list,second)
			
			chainsList[name] = name2
			
			--print(name,'>',name2)
		end
		
		if IsShiftKeyDown() then
			wipe(chainsList)
		end
	end
	
	frame.optionsDropDown = CreateFrame("Frame", "ExRTBossmodsArchimondeOptionsDropDown", nil, "UIDropDownMenuTemplate")
	
	frame.options = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],14,true):Point("TOPLEFT",2,16)
	frame.options.texture:SetTexCoord(0.26,0.3025,0.51,0.615)
	frame.options:SetScript("OnClick",function()
		EasyMenu({
			{
				text = L.BossmodsKromogTest,
				notCheckable = true,
				func = function()
					if ExRT.F.table_len(chainsList) > 0 then
						wipe(chainsList)
						wipe(shackledList)
					else
						ARCHI_TEST()
					end
				end,
			},
			{
				text = L.BossmodsArchimondeDisableShackled,
				checked = VExRT.Bossmods.ArchimondeDisableShackled,
				func = function()
					VExRT.Bossmods.ArchimondeDisableShackled = not VExRT.Bossmods.ArchimondeDisableShackled
					wipe(shackledList)
				end,
			},
			{
				text = L.BossmodsArchimondeDisableText,
				checked = VExRT.Bossmods.ArchimondeDisableText,
				func = function()
					VExRT.Bossmods.ArchimondeDisableText = not VExRT.Bossmods.ArchimondeDisableText
				end,
			},
			{
				text = L.BossmodsArchimondeDistance,
				hasArrow = true,
				notCheckable = true,
				menuList = {
					{text = "20y",func = function() VExRT.Bossmods.ArchimondeRadius = nil VIEW_DISTANCE = 20 VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold() CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 20 or not VExRT.Bossmods.ArchimondeRadius,},
					{text = "25y",func = function() VExRT.Bossmods.ArchimondeRadius = 25 VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold() CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 25,},
					{text = "30y",func = function() VExRT.Bossmods.ArchimondeRadius = 30 VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold(10) CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 30,},
					{text = "35y",func = function() VExRT.Bossmods.ArchimondeRadius = 35 VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold(8) CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 35,},
					{text = "40y",func = function() VExRT.Bossmods.ArchimondeRadius = 40 VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold(6) CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 40,},
					{text = "50y",func = function() VExRT.Bossmods.ArchimondeRadius = 50 VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold(4) CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 50,},
					{text = "60y",func = function() VExRT.Bossmods.ArchimondeRadius = 60 VIEW_DISTANCE = VExRT.Bossmods.ArchimondeRadius VIEW_DISTANCE2 = VIEW_DISTANCE * 2 UpdateLinesBold(4) CloseDropDownMenus() end,checked = VExRT.Bossmods.ArchimondeRadius == 60,},
				},
			},
			{
				text = L.bossmodsscale,
				notCheckable = true,
				func = function()
					frame.scale:SetShown(not frame.scale:IsShown())
				end,
			},
			{
				text = L.bossmodsclose,
				notCheckable = true,
				func = function()
					ExRT.F:ExBossmodsCloseAll()
					CloseDropDownMenus()
				end,
			},				
			{
				text = L.BossWatcherSelectFightClose,
				notCheckable = true,
				func = function()
					CloseDropDownMenus()
				end,
			},
		}, frame.optionsDropDown, "cursor", 10 , -15, "MENU")
	end)
	
	local function Lock(self,isLoad)
		local parent = self:GetParent()
		local var = VExRT.Bossmods.ArchimondeLock
		if isLoad == 1 then
			var = not var
		end
		if var then
			VExRT.Bossmods.ArchimondeLock = nil
			self.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\un_lock.tga")
			frame:SetMovable(true)
			frame:EnableMouse(true)
		else
			VExRT.Bossmods.ArchimondeLock = true
			self.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\lock.tga")
			frame:SetMovable(false)
			frame:EnableMouse(false)
		end
	end
	
	frame.lock = ELib:Icon(frame,"Interface\\AddOns\\ExRT\\media\\un_lock.tga",14,true):Point("TOPLEFT",18,16):OnClick(Lock)
	Lock(frame.lock,1)
	
	if VExRT.Bossmods.ArchimondeScale and tonumber(VExRT.Bossmods.ArchimondeScale) then
		frame:SetScale(VExRT.Bossmods.ArchimondeScale)
	end
	frame.scale = ELib:Slider(frame):_Size(70,8):Point("BOTTOMRIGHT",frame,"TOPRIGHT",-25,5):Range(50,200,true):SetTo((VExRT.Bossmods.ArchimondeScale or 1)*100):Scale(1 / (VExRT.Bossmods.ArchimondeScale or 1)):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.Bossmods.ArchimondeScale = event / 100
		ExRT.F.SetScaleFixTR(frame,VExRT.Bossmods.ArchimondeScale)
		self:SetScale(1 / VExRT.Bossmods.ArchimondeScale)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	frame.scale:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			self:SetValue(100)
		end
	end)
	frame.scale:Hide()
	
	local trottle = 0
	frame:SetScript("OnUpdate",function(self,elapsed)
		trottle = trottle + elapsed
		if trottle > 0.02 then
			trottle = 0
			local playerY,playerX = UnitPosition('player')
			if not playerY then
				return
			end
			
			local tLx,tLy,tRx,tRy,bRx,bRy,bLx,bLy = playerX + VIEW_DISTANCE,playerY + VIEW_DISTANCE,playerX - VIEW_DISTANCE,playerY + VIEW_DISTANCE,playerX - VIEW_DISTANCE, playerY - VIEW_DISTANCE,playerX + VIEW_DISTANCE,playerY - VIEW_DISTANCE
			
			local angle = -GetPlayerFacing()
			tLx,tLy = RotateCoordPair(tLx,tLy,playerX,playerY,angle,1)
			tRx,tRy = RotateCoordPair(tRx,tRy,playerX,playerY,angle,1)
			bRx,bRy = RotateCoordPair(bRx,bRy,playerX,playerY,angle,1)
			bLx,bLy = RotateCoordPair(bLx,bLy,playerX,playerY,angle,1)
			
			
			for i=1,#self.lines do
				--frame.lines[i]:Hide()
				frame.lines[i]:SetAlpha(0)
			end
			for i=1,#self.players do
				--frame.players[i]:Hide()
				frame.players[i]:SetAlpha(0)
			end
			for i=1,#self.circles do
				--frame.circles[i]:Hide()
				frame.circles[i]:SetAlpha(0)
			end
			
			local count = 0
			local countText = 0
			local isRed = false
			local onLines = 0
			self.back:SetColorTexture(.7,.7,.7,.4)

			local isChains = false
			
			for chainFrom,chainTo in pairs(chainsList) do
				isChains = true
				
				local sourceY,sourceX = UnitPosition(chainFrom)
				local targetY,targetX = UnitPosition(chainTo)
				if type(chainFrom) == 'number' then sourceY,sourceX = DEBUG_POS[chainFrom].y,DEBUG_POS[chainFrom].x end
				if type(chainTo) == 'number' then targetY,targetX = DEBUG_POS[chainTo].y,DEBUG_POS[chainTo].x end
				if not (sourceX == targetX and sourceY == targetY) and sourceX and targetX then
			
					local dX = (sourceX - targetX)
					local dY = (sourceY - targetY)
					local dist = sqrt(dX * dX + dY * dY)
					
					local t_cos = (targetX-sourceX) / dist
					local newX = VECTOR_LENGTH * t_cos  +  targetX
					
					local t_sin = (targetY-sourceY) / dist
					local newY = VECTOR_LENGTH * t_sin  +  targetY
					
					local radiusX,radiusY = VECTOR_DEPTH * t_sin, VECTOR_DEPTH * t_cos
					
					if isXavius then
						sourceX, sourceY = sourceX - VECTOR_LENGTH * t_cos, sourceY - VECTOR_LENGTH * t_sin
					end
					local point1x = sourceX + radiusX
					local point1y = sourceY - radiusY
					
					local point2x = sourceX - radiusX
					local point2y = sourceY + radiusY
					
					local point3x = newX + radiusX
					local point3y = newY - radiusY
					
					local point4x = newX - radiusX
					local point4y = newY + radiusY
	
				
					local xS,yS,xE,yE = sourceX,sourceY,newX,newY
					
					local x1,y1,x2,y2 = nil
	
					local cx1,cy1 = GetContactPosition(xS,xE,tLx,tRx,yS,yE,tLy,tRy)
					local cx2,cy2 = GetContactPosition(xS,xE,tRx,bRx,yS,yE,tRy,bRy)
					local cx3,cy3 = GetContactPosition(xS,xE,bLx,bRx,yS,yE,bLy,bRy)
					local cx4,cy4 = GetContactPosition(xS,xE,tLx,bLx,yS,yE,tLy,bLy)
					
					if cx1 then
						x1,y1 = cx1,cy1
					end
					if cx2 then
						if x1 then
							x2,y2 = cx2,cy2
						else
							x1,y1 = cx2,cy2
						end
					end
					if cx3 then
						if x1 then
							x2,y2 = cx3,cy3
						else
							x1,y1 = cx3,cy3
						end
					end
					if cx4 then
						if x1 then
							x2,y2 = cx4,cy4
						else
							x1,y1 = cx4,cy4
						end
					end			
								
					if IsDotIn(xS,yS,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) then
						if not x1 then
							x1,y1 = xS,yS
						else
							x2,y2 = xS,yS
						end
					end
					
					if IsDotIn(xE,yE,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) then
						if not x1 then
							x1,y1 = xE,yE
						else
							x2,y2 = xE,yE
						end
					end
					
					local isFromPlayer = UnitIsUnit('player',chainFrom)
					local isToPlayer = UnitIsUnit('player',chainTo)
					local isPlayer = isFromPlayer or isToPlayer
					
					local isOnLine = IsDotIn(playerX,playerY,point1x,point2x,point4x,point3x,point1y,point2y,point4y,point3y)			
					if isOnLine and not isPlayer then
						onLines = onLines + 1
						if onLines > 0 then
							isRed = true
							self.back:SetColorTexture(1,.7,.7,.4)
						end
					end
					
					if x1 and x2 then
						count = count + 1
	
						local aX = abs(dist_dot( x1,y1,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local aY = abs(dist_dot( x1,y1,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local bX = abs(dist_dot( x2,y2,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local bY = abs(dist_dot( x2,y2,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
					
						if aX > bX then aX,bX=bX,aX aY,bY=bY,aY end
	
						SetLine(count,aX,aY,bX,bY,(isPlayer and 2) or (isOnLine and 3) or 1)
					end
					
					if not isFromPlayer and IsDotIn(sourceX,sourceY,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) and not isXavius then
						countText = countText + 1
						
						local aX = abs(dist_dot( sourceX,sourceY,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local aY = abs(dist_dot( sourceX,sourceY,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						
						local _,class = UnitClass(chainFrom)
						local color = RAID_CLASS_COLORS[class] and "|c"..RAID_CLASS_COLORS[class].colorStr or ""
						
						SetPlayer(countText,color..chainFrom,aX,aY)
					end
					
					if not isToPlayer and IsDotIn(targetX,targetY,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) and not isXavius then
						countText = countText + 1
						
						local aX = abs(dist_dot( targetX,targetY,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						local aY = abs(dist_dot( targetX,targetY,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
						
						local _,class = UnitClass(chainTo)
						local color = RAID_CLASS_COLORS[class] and "|c"..RAID_CLASS_COLORS[class].colorStr or ""
						
						SetPlayer(countText,color..chainTo,aX,aY)
					end
				end
			end
			
			local circles_count = 0
			for shackledTarget,shackledData in pairs(shackledList) do
				local x,y = shackledData.x,shackledData.y
				if shackledData.p then
					y,x = UnitPosition(shackledData.p)
				end

				local isPlayer = UnitIsUnit('player',shackledTarget)
				if isPlayer and (
				   IsCircleIn(x,y,30,tLx,tLy,tRx,tRy) or 
				   IsCircleIn(x,y,30,tRx,tRy,bRx,bRy) or 
				   IsCircleIn(x,y,30,bRx,bRy,bLx,bLy) or 
				   IsCircleIn(x,y,30,bLx,bLy,tLx,tLy) or 
				   IsDotIn(x,y,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy)) then
					circles_count = circles_count + 1
					
					local aX = abs(dist_dot( x,y,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
					local aY = abs(dist_dot( x,y,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
					
					local side_x = (bLx - x) * (tLy - bLy) - (tLx - bLx) * (bLy - y)
					if side_x < 0 then
						aX = -aX
					end
					
					local side_y = (bRx - x) * (bLy - bRy) - (bLx - bRx) * (bRy - y)
					if side_y < 0 then
						aY = -aY
					end
					
					SetCircle(circles_count,aX,aY,4,isChains)
				end
				
				if IsCircleIn(x,y,25,tLx,tLy,tRx,tRy) or 
				   IsCircleIn(x,y,25,tRx,tRy,bRx,bRy) or 
				   IsCircleIn(x,y,25,bRx,bRy,bLx,bLy) or 
				   IsCircleIn(x,y,25,bLx,bLy,tLx,tLy) or 
				   IsDotIn(x,y,tLx,tRx,bRx,bLx,tLy,tRy,bRy,bLy) then
					circles_count = circles_count + 1
					
					local aX = abs(dist_dot( x,y,tLx,tLy,bLx,bLy ) / VIEW_DISTANCE2 * FRAME_SIZE)
					local aY = abs(dist_dot( x,y,bLx,bLy,bRx,bRy ) / VIEW_DISTANCE2 * FRAME_SIZE)
					
					local side_x = (bLx - x) * (tLy - bLy) - (tLx - bLx) * (bLy - y)
					if side_x < 0 then
						aX = -aX
					end
					
					local side_y = (bRx - x) * (bLy - bRy) - (bLx - bRx) * (bRy - y)
					if side_y < 0 then
						aY = -aY
					end
					
					local isInCircle = ((playerX - x) * (playerX - x) + (playerY - y) * (playerY - y)) <= (25 *25)
					
					SetCircle(circles_count,aX,aY,isInCircle and 3 or 1,isChains)
				end
				
			end

		end
	end)
end

-----------------------------------------
-- Archimonde Infernals
-----------------------------------------
local ArchimondeInfernals = {}
module.A.ArchimondeInfernals = ArchimondeInfernals

function ArchimondeInfernals:Load()
	ExRT.Options.Frame:Hide()

	local frame = ArchimondeInfernals.mainframe
	if frame then
		frame:RegisterEvent('ENCOUNTER_START')
		frame:RegisterEvent('ENCOUNTER_END')
		if not InCombatLockdown() then
			frame:Test()
		end
		frame.isEnabled = true
		return
	end
	
	local infernalMaxHP = 2893432 / 2
	local infernalHellfireCD = 15
	
	local SIZE_WIDTH,SIZE_HEIGHT = 220,36	--250,40
	
	local infernalFrames = {}
	local function HideAllFrames()
		for i=1,#infernalFrames do
			infernalFrames[i]:Hide()
		end
	end
	
	local function SetHP(self,hp)
		if hp <= 0 then
			self.hp:Hide()
			self.hpText:SetText("DEAD")
			
			self.isAlive = false
			
			local isAllDead = true
			for j=1,#infernalFrames do
				if infernalFrames[j].isAlive then
					isAllDead = false
					break
				end
			end
			if isAllDead then
				HideAllFrames()
			end
		else
			local hp_per = hp / infernalMaxHP
			self.hp:SetWidth(SIZE_WIDTH * hp_per)
			self.hp:Show()
			self.hpText:SetFormattedText("%.1f%%",hp_per * 100)
			
			self.isAlive = true
		end
	end
	
	local function AddFrame(i)
		local frame = infernalFrames[i]
		if not frame then
			frame = CreateFrame('Frame',nil,UIParent)
			infernalFrames[i] = frame
			frame:SetSize(SIZE_WIDTH,SIZE_HEIGHT)
			if i==1 then
				if VExRT.Bossmods.ArchimondeInfernalPosX and VExRT.Bossmods.ArchimondeInfernalPosY then
					frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.ArchimondeInfernalPosX,VExRT.Bossmods.ArchimondeInfernalPosY)
				else
					frame:SetPoint("TOP",UIParent,"CENTER",-350,200)
				end
				frame:EnableMouse(true)
				frame:SetMovable(true)
			else
				frame:SetPoint("TOP",infernalFrames[i-1],"BOTTOM",0,-3)
			end
			frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 4})
			frame:SetBackdropBorderColor(0.2,0.2,0.2,0.8)
			--frame:SetBackdropColor(.2,.2,.2,1)
			frame:SetBackdropColor(.2,.2,.2,0)
			
			--if VExRT.Bossmods.Scale then
			--	frame:SetScale(VExRT.Bossmods.Scale / 100)
			--end
			if VExRT.Bossmods.ArchimondeInfernalsScale then
				frame:SetScale(VExRT.Bossmods.ArchimondeInfernalsScale)
			end
			if VExRT.Bossmods.Alpha then
				frame:SetAlpha(VExRT.Bossmods.Alpha / 100)
			end
			
			if i == 1 then
				frame.close = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],16,true):Point("TOPRIGHT",2,18)
				frame.close.texture:SetTexCoord(0.5,0.5625,0.5,0.625)
				frame.close:SetScript("OnClick",function(self)
					HideAllFrames()
				end)
				frame.close:SetScript("OnEnter",function(self)
					self.texture:SetVertexColor(1,0,.7,1)
				end)
				frame.close:SetScript("OnLeave",function(self)
					self.texture:SetVertexColor(1,1,1,1)
				end)
				
				frame.optionsDropDown = CreateFrame("Frame", "ExRTBossmodsArchimondeInfernalsOptionsDropDown", nil, "UIDropDownMenuTemplate")
				
				frame.options = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],16,true):Point("TOPRIGHT",-14,18)
				frame.options.texture:SetTexCoord(0.26,0.3025,0.51,0.615)
				frame.options:SetScript("OnClick",function()
					EasyMenu({
						{
							text = L.BossmodsArchimondeDisableMarking,
							checked = VExRT.Bossmods.ArchimondeDisableMarking,
							func = function()
								VExRT.Bossmods.ArchimondeDisableMarking = not VExRT.Bossmods.ArchimondeDisableMarking
							end,
						},	
						{
							text = L.bossmodsscale,
							notCheckable = true,
							func = function()
								frame.scale:SetShown(not frame.scale:IsShown())
							end,
						},
						{
							text = L.bossmodsclose,
							notCheckable = true,
							func = function()
								ExRT.F:ExBossmodsCloseAll()
								CloseDropDownMenus()
							end,
						},
						{
							text = L.BossWatcherSelectFightClose,
							notCheckable = true,
							func = function()
								CloseDropDownMenus()
							end,
						},
					}, frame.optionsDropDown, "cursor", 10 , -15, "MENU")
				end)
			end
			
			frame:RegisterForDrag("LeftButton")
			frame:SetScript("OnDragStart", function(self)
				if self:IsMovable() then
					self:StartMoving()
				end
			end)
			frame:SetScript("OnDragStop", function(self) 
				self:StopMovingOrSizing() 
				
				VExRT.Bossmods.ArchimondeInfernalPosX = self:GetLeft()
				VExRT.Bossmods.ArchimondeInfernalPosY = self:GetTop()
			end)
			
			frame.hp = frame:CreateTexture(nil, "BACKGROUND")
			frame.hp:SetTexture(ExRT.F.barImg)
			frame.hp:SetPoint("LEFT",0,0)
			frame.hp:SetHeight(SIZE_HEIGHT)
			frame.hp:SetVertexColor(1,.5,.5,1)
			
			frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-7)
			frame.back:SetTexture(ExRT.F.barImg)
			frame.back:SetAllPoints()
			frame.back:SetVertexColor(.2,.2,.2,.5)
			
			frame.hpText = frame:CreateFontString(nil,"ARTWORK")
			frame.hpText:SetPoint("LEFT", 32, 0)
			frame.hpText:SetFont(ExRT.F.defFont, 16)
			frame.hpText:SetShadowOffset(1,-1)
			
			frame.icon = frame:CreateTexture(nil, "ARTWORK")
			frame.icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)
			frame.icon:SetPoint("LEFT",5,0)
			frame.icon:SetSize(24,24)
			
			frame.cdIcon = frame:CreateTexture(nil, "ARTWORK")
			frame.cdIcon:SetTexture(GetSpellTexture(187078))
			frame.cdIcon:SetPoint("RIGHT",frame,"LEFT",0,0)
			frame.cdIcon:SetSize(SIZE_HEIGHT,SIZE_HEIGHT)

			frame.cd = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
			frame.cd:SetDrawEdge(false)
			frame.cd:SetAllPoints(frame.cdIcon)
			
			frame.SetHP = SetHP
		end
		
		frame.isAlive = true
		frame.cd:SetCooldown(GetTime(),infernalHellfireCD)
		frame:SetHP(infernalMaxHP)
		frame:Show()
		for j=1,(i-1) do
			infernalFrames[j]:Show()
		end
	end
	
	local function ARCHI_INF_TEST()
		AddFrame(1)
		AddFrame(2)
		AddFrame(3)
		AddFrame(4)
		AddFrame(5)
		
		infernalFrames[1]:SetHP(2893432*0.9)
		infernalFrames[2]:SetHP(2893432*0.5)
		infernalFrames[3]:SetHP(-1)
		infernalFrames[4]:SetHP(2893432*0.1)
		infernalFrames[5]:SetHP(1)
	end
	ARCHI_INF_TEST()
	
	local lastSummon = 0
	local summonCount = 0
	local infernalsHP = {}
	local guidToFrame = {}

	local frame = CreateFrame'Frame'
	ArchimondeInfernals.mainframe = frame
	frame:RegisterEvent('ENCOUNTER_START')
	frame:RegisterEvent('ENCOUNTER_END')
	frame.isEnabled = true
	local function Engage()
		wipe(infernalsHP)
		wipe(guidToFrame)
		HideAllFrames()
		for i=1,#infernalFrames do
			infernalFrames[i].isAlive = false
		end
		frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		frame:RegisterEvent('UNIT_TARGET')
		frame:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
		
		local _,instanceType,difficultyID,difficultyName,maxPlayers,dynamicDifficulty,isDynamic,instanceMapID,instanceGroupSize = GetInstanceInfo()
		if not instanceGroupSize or not tonumber(instanceGroupSize) then
			instanceGroupSize = 10
		else
			instanceGroupSize = max(10,instanceGroupSize)
		end
		
		if difficultyID == 16 then
			infernalMaxHP = 2893432 / 2
			infernalHellfireCD = 15
		elseif difficultyID == 15 then
			--[[
				10: 904735
				14: 1284759
				15: 1379756
				16: 1474762
				30: 2804760
				
				95005
			]]
			
			infernalMaxHP = (904735 + 95005 * (instanceGroupSize - 10)) / 2
			infernalHellfireCD = 31
		elseif difficultyID == 14 then
			--[[
				10: 723811
				30: 2243808
				
				76000
			]]
			
			infernalMaxHP = (723811 + 76000 * (instanceGroupSize - 10)) / 2
			infernalHellfireCD = 31
		elseif difficultyID == 7 then
			infernalMaxHP = 1397855	 / 1.5	
			infernalHellfireCD = 46
		end
	end
	frame.Engage = Engage
	frame.Close = function(self)
		self:UnregisterAllEvents()
		self.isEnabled = false
		HideAllFrames()
	end
	frame.SetAlpha = function(self,val)
		for i=1,#infernalFrames do
			infernalFrames[i]:SetAlpha(val)
		end
	end
	frame.SetScale = function(self,val)
		if infernalFrames[1] then
			ExRT.F.SetScaleFix(infernalFrames[1],val)
		end
		for i=2,#infernalFrames do
			infernalFrames[i]:SetScale(val)
		end
	end
	frame.ClearAllPoints = function(self)
		if infernalFrames[1] then
			infernalFrames[1]:SetPoint("TOP",UIParent,"CENTER",-350,200)
		end
	end
	frame.Test = ARCHI_INF_TEST
	
	if infernalFrames[1] then
		infernalFrames[1].scale = ELib:Slider(infernalFrames[1]):_Size(70,8):Point("BOTTOMRIGHT",infernalFrames[1],"TOPRIGHT",-70,6):Range(50,200,true):SetTo((VExRT.Bossmods.ArchimondeInfernalsScale or 1)*100):Scale(1 / (VExRT.Bossmods.ArchimondeInfernalsScale or 1)):OnChange(function(self,event) 
			event = ExRT.F.Round(event)
			VExRT.Bossmods.ArchimondeInfernalsScale = event / 100
			if infernalFrames[1] then
				ExRT.F.SetScaleFixTR(infernalFrames[1],VExRT.Bossmods.ArchimondeInfernalsScale)
			end
			for i=2,#infernalFrames do
				infernalFrames[i]:SetScale(VExRT.Bossmods.ArchimondeInfernalsScale)
			end
			self:SetScale(1 / VExRT.Bossmods.ArchimondeInfernalsScale)
			self.tooltipText = event
			self:tooltipReload(self)
		end)
		infernalFrames[1].scale:SetScript("OnMouseUp",function(self,button)
			if button == "RightButton" then
				self:SetValue(100)
			end
		end)
		infernalFrames[1].scale:Hide()
	end
	
	local function Infernals_OnEvent(self,event,...)
		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,swingOverkill,_,amount,overkill = ...
			if event == "SPELL_SUMMON" then
				if GetMobID(destGUID) == 94412 then
					local currTime = GetTime()
					if (currTime - lastSummon) > 20 then
						HideAllFrames()
						summonCount = 0
						lastSummon = currTime
					end
					summonCount = summonCount + 1
					infernalsHP[destGUID] = infernalMaxHP
					guidToFrame[destGUID] = summonCount
					AddFrame(summonCount)
				end
			elseif event == "SPELL_DAMAGE" or event == "RANGE_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" then
				local target = destGUID and guidToFrame[destGUID]
				if target then
					local newHP = infernalsHP[destGUID] - amount - overkill
					infernalsHP[destGUID] = newHP
					infernalFrames[target]:SetHP(newHP)
				end
			elseif event == "SWING_DAMAGE" then
				local target = destGUID and guidToFrame[destGUID]
				if target then
					local newHP = infernalsHP[destGUID] - spellID - swingOverkill
					infernalsHP[destGUID] = newHP
					infernalFrames[target]:SetHP(newHP)
				end
			elseif event == "UNIT_DIED" then
				if GetMobID(destGUID) == 94412 then
					local target = destGUID and guidToFrame[destGUID]
					if target then
						infernalsHP[destGUID] = -1
						infernalFrames[target]:SetHP(-1)
					end
				end
			elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
				local target = destGUID and guidToFrame[destGUID]
				if target then
					local newHP = infernalsHP[destGUID] + amount - overkill
					if newHP > infernalMaxHP then
						newHP = infernalMaxHP
					end
					infernalsHP[destGUID] = newHP
					infernalFrames[target]:SetHP(newHP)
				end
			end
		elseif event == "UNIT_TARGET" or event == "UPDATE_MOUSEOVER_UNIT" then
			if VExRT.Bossmods.ArchimondeDisableMarking then
				return
			end
			local unit = ...
			local targetUnit = event == "UNIT_TARGET" and (unit or "").."target" or "mouseover"
			local targetGUID = UnitGUID(targetUnit)
			if not targetGUID then return end
			local targetMark = guidToFrame[ targetGUID ]
			if targetMark and GetRaidTargetIndex(targetUnit) ~= targetMark then 
				SetRaidTarget(targetUnit, targetMark) 
			end
		elseif event == 'ENCOUNTER_START' then
			local eID = ...
			if eID == 1799 then
				Engage()
			end
		elseif event == 'ENCOUNTER_END' then
			self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			self:UnregisterEvent('UNIT_TARGET')
			self:UnregisterEvent('UPDATE_MOUSEOVER_UNIT')
			HideAllFrames()
		end
	  
	end
	
	frame:SetScript("OnEvent",Infernals_OnEvent)
end



-----------------------------------------
-- Gorefiend
-----------------------------------------
local Gorefiend = {}
module.A.Gorefiend = Gorefiend

function Gorefiend:Load()
	ExRT.Options.Frame:Hide()

	local frame = Gorefiend.mainframe
	if frame then
		frame:RegisterEvent('ENCOUNTER_START')
		frame:RegisterEvent('ENCOUNTER_END')
		if not InCombatLockdown() then
			frame:Test()
		end
		frame.isEnabled = true
		return
	end
	
	local SIZE_WIDTH,SIZE_HEIGHT = 170,24
	
	local soulMaxHP = 523590
	
	local soulsFrames = {}
	local function HideAllFrames()
		for i=1,#soulsFrames do
			soulsFrames[i]:Hide()
		end
	end
	
	local function UpdateFrame(self,name,hp,cd)
		if name then
			if hp < 0 then hp = 0 end
			local hp_per = hp / soulMaxHP
			self.hp:SetWidth(SIZE_WIDTH * hp_per)
			self.hpText:SetFormattedText("%dk / %.1f%%",hp / 1000,hp_per * 100)
			self.nameText:SetText(name)
			local isOnCD = (GetTime() - cd) < 36
			if isOnCD then
				self.cd:SetCooldown(cd,36)
				self.cd_settedToZero = nil
			elseif not self.cd_settedToZero then
				self.cd:SetCooldown(cd,36)
				self.cd_settedToZero = true
			end
			self.CD_TIMER = cd + 36
			self:Show()
		else
			self:Hide()
			self.CD_TIMER = nil
		end
	end
	
	local function UpdateTimerText(self)
		if self.CD_TIMER then
			local curr = GetTime()
			if self.CD_TIMER - curr > 0 then
				self.cdText:SetFormattedText("%d",self.CD_TIMER - curr)
			else
				self.cdText:SetText("")
			end
		else
			self.cdText:SetText("")
		end 
	end
	
	local function AddFrame(i)
		local frame = soulsFrames[i]
		if not frame then
			frame = CreateFrame('Frame',nil,UIParent)
			soulsFrames[i] = frame
			frame:SetSize(SIZE_WIDTH,SIZE_HEIGHT)
			if i==1 then
				if VExRT.Bossmods.GorefiendPosX and VExRT.Bossmods.GorefiendPosY then
					frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.GorefiendPosX,VExRT.Bossmods.GorefiendPosY)
				else
					frame:SetPoint("TOP",UIParent,"CENTER",-350,200)
				end
				frame:EnableMouse(true)
				frame:SetMovable(true)
			else
				frame:SetPoint("TOP",soulsFrames[i-1],"BOTTOM",0,-3)
			end
			frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 4})
			frame:SetBackdropBorderColor(0.2,0.2,0.2,0.8)
			frame:SetBackdropColor(.2,.2,.2,0)
			
			if VExRT.Bossmods.GorefiendScale then
				frame:SetScale(VExRT.Bossmods.GorefiendScale)
			end
			if VExRT.Bossmods.Alpha then
				frame:SetAlpha(VExRT.Bossmods.Alpha / 100)
			end
			
			if i == 1 then
				frame.close = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],16,true):Point("TOPRIGHT",2,18)
				frame.close.texture:SetTexCoord(0.5,0.5625,0.5,0.625)
				frame.close:SetScript("OnClick",function(self)
					HideAllFrames()
				end)
				frame.close:SetScript("OnEnter",function(self)
					self.texture:SetVertexColor(1,0,.7,1)
				end)
				frame.close:SetScript("OnLeave",function(self)
					self.texture:SetVertexColor(1,1,1,1)
				end)
				
				frame.optionsDropDown = CreateFrame("Frame", "ExRTBossmodsGorefiendOptionsDropDown", nil, "UIDropDownMenuTemplate")
				
				frame.options = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],16,true):Point("TOPRIGHT",-14,18)
				frame.options.texture:SetTexCoord(0.26,0.3025,0.51,0.615)
				frame.options:SetScript("OnClick",function()
					EasyMenu({
						{
							text = L.bossmodsscale,
							notCheckable = true,
							func = function()
								frame.scale:SetShown(not frame.scale:IsShown())
							end,
						},
						{
							text = L.BossmodsGorefiendTargeting,
							notCheckable = true,
							func = function()
								CloseDropDownMenus()
								if InCombatLockdown() then
									print('Combat Error')
									return
								end
								ExRT.F:ExBossmodsCloseAll()
								module.A.Gorefiend2:Load()
							end,
						},
						{
							text = L.bossmodsclose,
							notCheckable = true,
							func = function()
								ExRT.F:ExBossmodsCloseAll()
								CloseDropDownMenus()
							end,
						},
						{
							text = L.BossWatcherSelectFightClose,
							notCheckable = true,
							func = function()
								CloseDropDownMenus()
							end,
						},
					}, frame.optionsDropDown, "cursor", 10 , -15, "MENU")
				end)
			end
			
			frame:RegisterForDrag("LeftButton")
			frame:SetScript("OnDragStart", function(self)
				if self:IsMovable() then
					self:StartMoving()
				end
			end)
			frame:SetScript("OnDragStop", function(self) 
				self:StopMovingOrSizing() 
				
				VExRT.Bossmods.GorefiendPosX = self:GetLeft()
				VExRT.Bossmods.GorefiendPosY = self:GetTop()
			end)
			
			frame.hp = frame:CreateTexture(nil, "BACKGROUND")
			frame.hp:SetTexture(ExRT.F.barImg)
			frame.hp:SetPoint("LEFT",0,0)
			frame.hp:SetHeight(SIZE_HEIGHT)
			frame.hp:SetVertexColor(1,.5,.5,1)
			
			frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-7)
			frame.back:SetTexture(ExRT.F.barImg)
			frame.back:SetAllPoints()
			frame.back:SetVertexColor(.2,.2,.2,.5)
			
			frame.hpText = frame:CreateFontString(nil,"ARTWORK")
			frame.hpText:SetPoint("RIGHT", -3, 0)
			frame.hpText:SetFont(ExRT.F.defFont, 12)
			frame.hpText:SetShadowOffset(1,-1)
			frame.hpText:SetJustifyH("RIGHT")
			
			frame.nameText = frame:CreateFontString(nil,"ARTWORK")
			frame.nameText:SetPoint("LEFT", 4, 0)
			frame.nameText:SetPoint("RIGHT", frame.hpText, "LEFT", -1, 0)
			frame.nameText:SetFont(ExRT.F.defFont, 12)
			frame.nameText:SetShadowOffset(1,-1)
			frame.nameText:SetJustifyH("LEFT")
			
			frame.cdIcon = frame:CreateTexture(nil, "ARTWORK")
			frame.cdIcon:SetTexture(GetSpellTexture(181295))
			frame.cdIcon:SetPoint("RIGHT",frame,"LEFT",0,0)
			frame.cdIcon:SetSize(SIZE_HEIGHT,SIZE_HEIGHT)

			frame.cd = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
			frame.cd:SetDrawEdge(false)
			frame.cd:SetAllPoints(frame.cdIcon)
			frame.cd:SetHideCountdownNumbers(true)
			
			frame.cdText = frame.cd:CreateFontString(nil,"ARTWORK")
			frame.cdText:SetPoint("CENTER", frame.cd, 0, 0)
			frame.cdText:SetFont(ExRT.F.defFont, 14, "OUTLINE")
			--frame.cdText:SetShadowOffset(1,-1)
			frame.cdText:SetJustifyH("CENTER")
			frame.cdText:SetJustifyH("MIDDLE")
			
			frame:SetScript("OnUpdate",UpdateTimerText)
			
			frame.UpdateFrame = UpdateFrame
		end
	end
	
	local targetToMark = {
		[0x1] = 1,
		[0x2] = 2,
		[0x4] = 3,
		[0x8] = 4,
		[0x10] = 5,
		[0x20] = 6,
		[0x40] = 7,
		[0x80] = 8,
	}
	
	local data = IsEncounterInProgress() and {} or {
		{name = UnitName'player',time = GetTime(),hp = soulMaxHP},
		{name = UnitName'player',time = GetTime(),hp = soulMaxHP * 0.67},
		{name = UnitName'player',time = GetTime(),hp = soulMaxHP * 0.33,mark = 0x4},
	}
	
	local guidToFrame,unkSouls = {},{}

	local function UpdateFrames()
		local counter = 0
		for i=1,#data do
			local currData = data[i]
			if currData.hp > 0 then
				counter = counter + 1
				if not soulsFrames[counter] then
					AddFrame(counter)
				end
				local mark
				if currData.mark then
					local icon_id = targetToMark[ currData.mark ]
					if icon_id then
						mark = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. icon_id  ..":0|t "
					end
				end
				soulsFrames[counter]:UpdateFrame((mark or "")..currData.name,currData.hp,currData.time)
			else
				currData.hp = nil
			end
		end
		for i=counter+1,#soulsFrames do
			soulsFrames[i]:UpdateFrame()
		end
		for i=#data,1,-1 do
			if not data[i].hp then
				local guid = data[i].guid
				if guid then
					guidToFrame[ guid ] = nil
				end
				tremove(data,i)
			end
		end
	end
	
	local frame = CreateFrame'Frame'
	Gorefiend.mainframe = frame
	frame:RegisterEvent('ENCOUNTER_START')
	frame:RegisterEvent('ENCOUNTER_END')
	frame:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
	frame.isEnabled = true
	local function Engage()
		wipe(guidToFrame)
		wipe(data)
		wipe(unkSouls)
		HideAllFrames()
		
		local _,_,difficultyID = GetInstanceInfo()
		if difficultyID ~= 16 then
			return
		end
		
		frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
	frame.Engage = Engage
	frame.Close = function(self)
		self:UnregisterAllEvents()
		self.isEnabled = false
		HideAllFrames()
	end
	frame.SetAlpha = function(self,val)
		for i=1,#soulsFrames do
			soulsFrames[i]:SetAlpha(val)
		end
	end
	frame.SetScale = function(self,val)
		if soulsFrames[1] then
			ExRT.F.SetScaleFix(soulsFrames[1],val)
		end
		for i=2,#soulsFrames do
			soulsFrames[i]:SetScale(val)
		end
	end
	frame.ClearAllPoints = function(self)
		if soulsFrames[1] then
			soulsFrames[1]:ClearAllPoints()
			soulsFrames[1]:SetPoint("TOP",UIParent,"CENTER",-350,200)
		end
	end
	frame.Test = function()
		if GetNumGroupMembers() > 0 then
			data = {
				{name = UnitName'player',time = GetTime(),hp = soulMaxHP},
				{name = UnitName('raid'..fastrandom(1,GetNumGroupMembers())) or UnitName'player',time = GetTime()-8,hp = soulMaxHP * fastrandom(50,90)/100},
				{name = UnitName('raid'..fastrandom(1,GetNumGroupMembers())) or UnitName'player',time = GetTime()-15,hp = soulMaxHP * fastrandom(15,45)/100},
			}
		else
			data = {
				{name = UnitName'player',time = GetTime(),hp = soulMaxHP},
				{name = UnitName'player',time = GetTime()-8,hp = soulMaxHP * fastrandom(50,90)/100},
				{name = UnitName'player',time = GetTime()-15,hp = soulMaxHP * fastrandom(15,45)/100},
			}
		end
		UpdateFrames()
	end
	frame.soulsFrames = soulsFrames
	
	UpdateFrames()
	if soulsFrames[1] then
		soulsFrames[1].scale = ELib:Slider(soulsFrames[1]):_Size(70,8):Point("BOTTOMRIGHT",soulsFrames[1],"TOPRIGHT",-70,6):Range(50,200,true):SetTo((VExRT.Bossmods.GorefiendScale or 1)*100):Scale(1 / (VExRT.Bossmods.GorefiendScale or 1)):OnChange(function(self,event) 
			event = ExRT.F.Round(event)
			VExRT.Bossmods.GorefiendScale = event / 100
			if soulsFrames[1] then
				ExRT.F.SetScaleFixTR(soulsFrames[1],VExRT.Bossmods.GorefiendScale)
			end
			for i=2,#soulsFrames do
				soulsFrames[i]:SetScale(VExRT.Bossmods.GorefiendScale)
			end
			self:SetScale(1 / VExRT.Bossmods.GorefiendScale)
			self.tooltipText = event
			self:tooltipReload(self)
		end)
		soulsFrames[1].scale:SetScript("OnMouseUp",function(self,button)
			if button == "RightButton" then
				self:SetValue(100)
			end
		end)
		soulsFrames[1].scale:Hide()
	end
	
	local function Gorefiend_OnEvent(self,event,...)
		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,swingOverkill,_,amount,overkill = ...
			if event == "SPELL_AURA_APPLIED" then
				if spellID == 179867 then
					tinsert(data,{
						name = delUnitNameServer(destName),
						time = GetTime(),
						hp = soulMaxHP,
					})
					UpdateFrames()
				end
			elseif event == "SPELL_DAMAGE" or event == "RANGE_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "SWING_DAMAGE" then
				if not destGUID or GetMobID(destGUID) ~= 93288 then
					return
				end
				if event == "SWING_DAMAGE" then
					amount,overkill = spellID,swingOverkill
				end
				local target = guidToFrame[destGUID]
				if target then
					target.hp = target.hp - amount - overkill
					target.mark = destFlags2
					UpdateFrames()
				else
					if destName then
						for i=1,#data do
							local currData = data[i]
							if destName:find(currData.name) then
								guidToFrame[destGUID] = currData
								currData.guid = destGUID
								currData.mark = destFlags2
								
								currData.hp = currData.hp - amount - overkill
								if unkSouls[destGUID] then
									currData.hp = currData.hp - unkSouls[destGUID]
									unkSouls[destGUID] = nil
								end
								UpdateFrames()
								
								return
							end
						end
					end
					unkSouls[destGUID] = (unkSouls[destGUID] or 0) + amount + overkill
				end
			elseif event == "UNIT_DIED" then
				if GetMobID(destGUID) == 93288 then
					for i=1,#data do
						if data[i].guid == destGUID then
							guidToFrame[destGUID] = nil
							tremove(data,i)
							UpdateFrames()
							return
						end
					end
				elseif GetUnitTypeByGUID(destGUID) == 0 and destName then
					destName = delUnitNameServer(destName)
					for i=1,#data do
						if data[i].name == destName then
							local guid = data[i].guid
							if guid then
								guidToFrame[ guid ] = nil
							end
							tremove(data,i)
							UpdateFrames()
							return
						end
					end
				end
			end
		elseif event == 'ENCOUNTER_START' then
			if ... == 1783 then
				C_Timer.After(1,function()
					local boss1guid = UnitGUID'boss1'
					if boss1guid and GetMobID(boss1guid) == 90199 then
						Engage()
					else
						self:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
					end
				end)
			end
		elseif event == 'ENCOUNTER_END' then
			self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			self:UnregisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
			HideAllFrames()
			wipe(guidToFrame)
			wipe(data)
			wipe(unkSouls)
		elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
			local boss1guid = UnitGUID'boss1'
			if boss1guid and GetMobID(boss1guid) == 90199 then
				self:UnregisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
				Engage()
			end
		end
	  
	end
	
	frame:SetScript("OnEvent",Gorefiend_OnEvent)
end

-----------------------------------------
-- Gorefiend 2
-----------------------------------------

local Gorefiend2 = {}
module.A.Gorefiend2 = Gorefiend2

function Gorefiend2:Load()
	ExRT.Options.Frame:Hide()

	local frame = Gorefiend2.mainframe
	if frame then
		frame:RegisterEvent('ENCOUNTER_START')
		frame:RegisterEvent('ENCOUNTER_END')
		frame:RegisterEvent('GROUP_ROSTER_UPDATE')
		if not InCombatLockdown() then
			frame:Test()
		end
		frame:Show()
		frame.isEnabled = true
		return
	end
	
	if InCombatLockdown() then
		print('Combat Error')
		return
	end
	
	local SIZE_WIDTH,SIZE_HEIGHT = 140,20
	
	local soulMaxHP = 523590
	
	local soulsFrames = {}
	
	local function OnUpdateFrame(self)
		local soul_data = self.soul_data
		if soul_data then
			local currTime = GetTime() - soul_data.time
			if currTime > 0 then
				local barTime = 36 - currTime
				local width = barTime *2
				if width > 0 then
					self.backtimer:SetWidth(width)
					if barTime > 10 then
						self.backtimer:SetColorTexture(1,1,1,.8)
					else
						self.backtimer:SetColorTexture(1,.2,.2,.8)
					end
					self.backtimer:Show()
				else
					self.backtimer:Hide()
				end
			else
				self.backtimer:Hide()
			end
			if currTime < 0 then currTime = 0 elseif currTime > 34 then currTime = 34 end
			if currTime <= 17 then
				currTime = currTime / 17 * 0.5
				self.hp:SetVertexColor(0.5+currTime,1,0.5,1)
			else
				currTime = (currTime - 17) / 17 * 0.5
				self.hp:SetVertexColor(1,1 - currTime,0.5,1)
			end
		else
			self.hp:SetVertexColor(1,.5,.5,1)
		end
	end
	local function UpdateFrame(self)
		local name = self.name
		if not name then
			self:Hide()
			return
		end
		self.nameText:SetText(name)
		local soul_data = self.soul_data
		if soul_data then
			local hp = soul_data.hp
			if hp < 0 then hp = 0 elseif hp > soulMaxHP then hp = soulMaxHP end
			local hp_per = hp / soulMaxHP
			self.hp:SetWidth(SIZE_WIDTH * hp_per)
			self.hpText:SetFormattedText("%dk / %.1f%%",hp / 1000,hp_per * 100)
			self.cd:Show()
			self.cd:SetCooldown(soul_data.time,36)
			self:SetAlpha(1)
			self.CD_TIMER = soul_data.time + 36
			if not self.OnUpdateSetted then
				self:SetScript("OnUpdate",OnUpdateFrame)
				self.OnUpdateSetted = true
			end
		else
			self.hp:SetWidth(SIZE_WIDTH)
			self.hpText:SetText("")
			self.cd:Hide()
			self.cd:SetCooldown(GetTime(),0)
			self:SetAlpha(.1)
			self.backtimer:Hide()
			self.CD_TIMER = nil
			if self.OnUpdateSetted then
				self:SetScript("OnUpdate",nil)
				self.hp:SetVertexColor(1,.5,.5,1)
				self.OnUpdateSetted = nil
			end
		end
		self:Show()
	end
	
	local function UpdateTimerText(self)
		local paernt = self:GetParent()
		if paernt.CD_TIMER then
			local curr = GetTime()
			if paernt.CD_TIMER - curr > 0 then
				paernt.cdText:SetFormattedText("%d",paernt.CD_TIMER - curr)
			else
				paernt.cdText:SetText("")
			end
		else
			paernt.cdText:SetText("")
		end 
	end
	
	local frame = CreateFrame('Frame',nil,UIParent)
	Gorefiend2.mainframe = frame
	frame:SetSize(SIZE_WIDTH,16)
	if VExRT.Bossmods.GorefiendPosX and VExRT.Bossmods.GorefiendPosY then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.GorefiendPosX,VExRT.Bossmods.GorefiendPosY)
	else
		frame:SetPoint("TOP",UIParent,"CENTER",-350,200)
	end
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame.texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.texture:SetAllPoints()
	frame.texture:SetColorTexture(0,0,0,.3)
	
	frame.optionsDropDown = CreateFrame("Frame", "ExRTBossmodsGorefiend2OptionsDropDown", nil, "UIDropDownMenuTemplate")
	
	frame.options = ELib:Icon(frame,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128.tga]],16,true):Point("RIGHT",-1,0)
	frame.options.texture:SetTexCoord(0.26,0.3025,0.51,0.615)
	frame.options:SetScript("OnClick",function()
		EasyMenu({
			{
				text = L.bossmodsscale,
				notCheckable = true,
				func = function()
					frame.scale:SetShown(not frame.scale:IsShown())
				end,
			},
			{
				text = L.bossmodsclose,
				notCheckable = true,
				func = function()
					ExRT.F:ExBossmodsCloseAll()
					CloseDropDownMenus()
				end,
			},
			{
				text = L.BossWatcherSelectFightClose,
				notCheckable = true,
				func = function()
					CloseDropDownMenus()
				end,
			},
		}, frame.optionsDropDown, "cursor", 10 , -15, "MENU")
	end)
	if VExRT.Bossmods.GorefiendScale then
		frame:SetScale(VExRT.Bossmods.GorefiendScale)
	end
	if VExRT.Bossmods.Alpha then
		frame:SetAlpha(VExRT.Bossmods.Alpha / 100)
	end
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() and not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing() 
		
		VExRT.Bossmods.GorefiendPosX = self:GetLeft()
		VExRT.Bossmods.GorefiendPosY = self:GetTop()
	end)

	
	local function AddFrame(i)
		local frame = soulsFrames[i]
		if not frame then
			frame = CreateFrame('Button',nil,Gorefiend2.mainframe,"SecureActionButtonTemplate")
			soulsFrames[i] = frame
			frame:SetSize(SIZE_WIDTH,SIZE_HEIGHT)
			if i==1 then
				frame:SetPoint("TOP",Gorefiend2.mainframe,"BOTTOM",0,-3)
			else
				frame:SetPoint("TOP",soulsFrames[i-1],"BOTTOM",0,-3)
			end
			frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 4})
			frame:SetBackdropBorderColor(0.2,0.2,0.2,0.8)
			frame:SetBackdropColor(.2,.2,.2,0)
			
			frame:RegisterForClicks("AnyDown")
			frame:SetAttribute("type", "macro")
			frame:SetAttribute("macrotext", "/tar "..UnitName'player')
			
			frame.hp = frame:CreateTexture(nil, "BACKGROUND")
			frame.hp:SetTexture(ExRT.F.barImg)
			frame.hp:SetPoint("LEFT",0,0)
			frame.hp:SetHeight(SIZE_HEIGHT)
			frame.hp:SetVertexColor(1,.5,.5,1)
			
			frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-7)
			frame.back:SetTexture(ExRT.F.barImg)
			frame.back:SetAllPoints()
			frame.back:SetVertexColor(.2,.2,.2,.5)
			
			frame.backtimer = frame:CreateTexture(nil, "BACKGROUND",nil,-7)
                        frame.backtimer:SetTexture(1, 228/255, 181/255,1)
			frame.backtimer:SetPoint("RIGHT",frame,"LEFT", -SIZE_HEIGHT,0)
			frame.backtimer:SetSize(70,SIZE_HEIGHT)
			frame.backtimer:Hide()
			
			frame.hpText = frame:CreateFontString(nil,"ARTWORK")
			frame.hpText:SetPoint("RIGHT", -3, 0)
			frame.hpText:SetFont(ExRT.F.defFont, 12)
			frame.hpText:SetShadowOffset(1,-1)
			frame.hpText:SetJustifyH("RIGHT")
			
			frame.nameText = frame:CreateFontString(nil,"ARTWORK")
			frame.nameText:SetPoint("LEFT", 4, 0)
			frame.nameText:SetPoint("RIGHT", frame.hpText, "LEFT", -1, 0)
			frame.nameText:SetFont(ExRT.F.defFont, 12)
			frame.nameText:SetShadowOffset(1,-1)
			frame.nameText:SetJustifyH("LEFT")
			
			frame.cdIcon = frame:CreateTexture(nil, "ARTWORK")
			frame.cdIcon:SetTexture(GetSpellTexture(181295))
			frame.cdIcon:SetPoint("RIGHT",frame,"LEFT",0,0)
			frame.cdIcon:SetSize(SIZE_HEIGHT,SIZE_HEIGHT)

			frame.cd = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
			frame.cd:SetDrawEdge(false)
			frame.cd:SetAllPoints(frame.cdIcon)
			frame.cd:SetHideCountdownNumbers(true)
			
			frame.cdText = frame.cd:CreateFontString(nil,"ARTWORK")
			frame.cdText:SetPoint("CENTER", frame.cd, 0, 0)
			frame.cdText:SetFont(ExRT.F.defFont, 14, "OUTLINE")
			--frame.cdText:SetShadowOffset(1,-1)
			frame.cdText:SetJustifyH("CENTER")
			frame.cdText:SetJustifyH("MIDDLE")
			
			frame.timerUpdater = CreateFrame('Frame',nil,frame)
			frame.timerUpdater:SetScript("OnUpdate",UpdateTimerText)
			
			frame.UpdateFrame = UpdateFrame
			--frame.Update = UpdateFrame
			--frame:SetScript("OnUpdate",OnUpdateFrame)
		end
	end
	
	local targetToMark = {
		[0x1] = 1,
		[0x2] = 2,
		[0x4] = 3,
		[0x8] = 4,
		[0x10] = 5,
		[0x20] = 6,
		[0x40] = 7,
		[0x80] = 8,
	}
	
	local data = {}
	
	for i=1,20 do AddFrame(i) end
	
	local function UpdateFrames()
		for i=1,#soulsFrames do
			soulsFrames[i]:UpdateFrame()
		end
	end
	local function UpdateFrames_Roster()
		if InCombatLockdown() then
			C_Timer.NewTimer(5,UpdateFrames_Roster)
			return
		end
		local n = GetNumGroupMembers()
		if n == 0 then return end
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		local roster = {}
		for i=1,n do
			local name,_,subgroup = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				roster[subgroup] = roster[subgroup] or {}
				roster[subgroup][ #roster[subgroup] + 1 ] = name
			end
		end
		local frameCounter = 0
		for i=1,gMax do
			roster[i] = roster[i] or {}
			for j=1,5 do
				local name = roster[i][j]
				if name then
					frameCounter = frameCounter + 1
					local frame = soulsFrames[frameCounter]
					if frame then
						frame.name = delUnitNameServer(name)
						--frame:SetAttribute("macrotext", "/target "..ExRT.F:utf8sub(delUnitNameServer(name), 1, 3))
						--frame:SetAttribute("macrotext", "/target "..delUnitNameServer(name))
						local _name = delUnitNameServer(name)
						frame:SetAttribute("macrotext", "/target "..ExRT.F:utf8sub(_name, 1, ExRT.F:utf8len(_name)-1))
						--[[
						if i < 3 then
							frame:SetAttribute("macrotext", "/target "..delUnitNameServer(name))
						elseif i == 3 then
							frame:SetAttribute("macrotext", "/target "..ExRT.F:utf8sub(delUnitNameServer(name), 1, 3))
						else
							frame:SetAttribute("macrotext", "/target "..ExRT.F:utf8sub(delUnitNameServer(name), 1, 3).."\n")
						end
						]]
						frame.soul_data = nil
						frame:UpdateFrame()
					end
				end
			end
		end
		for i=frameCounter+1,20 do
			local frame = soulsFrames[i]
			frame.name = nil
			frame.soul_data = nil
			frame:UpdateFrame()
		end
	end
	
	local guidToFrame,unkSouls = {},{}

	frame:RegisterEvent('ENCOUNTER_START')
	frame:RegisterEvent('ENCOUNTER_END')
	frame:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
	frame:RegisterEvent('GROUP_ROSTER_UPDATE')
	frame.isEnabled = true
	local function Engage()
		wipe(guidToFrame)
		wipe(data)
		wipe(unkSouls)
		
		local _,_,difficultyID = GetInstanceInfo()
		if difficultyID ~= 16 then
			return
		end
		
		for i=1,20 do
			local frame = soulsFrames[i]
			frame.soul_data = nil
		end
		UpdateFrames()
		
		frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
	frame.Engage = Engage
	frame.Close = function(self)
		self:UnregisterAllEvents()
		self.isEnabled = false
		self:Hide()
	end
	frame.Test = function()
		if GetNumGroupMembers() > 0 then
			UpdateFrames_Roster()
		else
			data = {
				{name = UnitName'player',time = GetTime(),hp = soulMaxHP},
				{name = UnitName'player',time = GetTime() - fastrandom(1,35),hp = soulMaxHP * fastrandom()},
				{name = UnitName'player',time = GetTime() - fastrandom(1,35),hp = soulMaxHP * fastrandom(),mark = 0x4},
			}
			for i=1,20 do
				soulsFrames[i].name = UnitName'player'
				soulsFrames[i].soul_data = nil
			end
			local f1,f2,f3 = fastrandom(1,20),fastrandom(1,20),fastrandom(1,20)
			soulsFrames[f1].soul_data = data[1]
			soulsFrames[f2].soul_data = data[2]
			soulsFrames[f3].soul_data = data[3]
			C_Timer.After(-GetTime()+36+data[1].time,function()soulsFrames[f1].soul_data = nil UpdateFrames() end)
			C_Timer.After(-GetTime()+36+data[2].time,function()soulsFrames[f2].soul_data = nil UpdateFrames() end)
			C_Timer.After(-GetTime()+36+data[3].time,function()soulsFrames[f3].soul_data = nil UpdateFrames() end)
		end
		UpdateFrames()
	end
	frame.soulsFrames = soulsFrames
	
	frame:Test()
	
	frame.scale = ELib:Slider(frame):_Size(70,8):Point("RIGHT",frame,"RIGHT",-70,0):Range(50,200,true):SetTo((VExRT.Bossmods.GorefiendScale or 1)*100):Scale(1 / (VExRT.Bossmods.GorefiendScale or 1)):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.Bossmods.GorefiendScale = event / 100
		ExRT.F.SetScaleFixTR(frame,VExRT.Bossmods.GorefiendScale)
		self:SetScale(1 / VExRT.Bossmods.GorefiendScale)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	frame.scale:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			self:SetValue(100)
		end
	end)
	frame.scale:Hide()
	
	local function Gorefiend2_OnEvent(self,event,...)
		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,swingOverkill,_,amount,overkill = ...
			if event == "SPELL_AURA_APPLIED" then
				if spellID == 179867 then
					local shortName = delUnitNameServer(destName)
					tinsert(data,{
						name = shortName,
						time = GetTime(),
						hp = soulMaxHP,
					})
					for i=1,#soulsFrames do
						local frame = soulsFrames[i]
						if frame.name == shortName then
							frame.soul_data = data[#data]
						end
					end
					UpdateFrames()
				end
			elseif event == "SPELL_DAMAGE" or event == "RANGE_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "SWING_DAMAGE" then
				if not destGUID or GetMobID(destGUID) ~= 93288 then
					return
				end
				if event == "SWING_DAMAGE" then
					amount,overkill = spellID,swingOverkill
				end
				local target = guidToFrame[destGUID]
				if target then
					target.hp = target.hp - amount - overkill
					target.mark = destFlags2
					UpdateFrames()
				else
					if destName then
						for i=1,#data do
							local currData = data[i]
							if destName:find(currData.name) then
								guidToFrame[destGUID] = currData
								currData.guid = destGUID
								currData.mark = destFlags2
								
								currData.hp = currData.hp - amount - overkill
								if unkSouls[destGUID] then
									currData.hp = currData.hp - unkSouls[destGUID]
									unkSouls[destGUID] = nil
								end
								UpdateFrames()
								
								return
							end
						end
					end
					unkSouls[destGUID] = (unkSouls[destGUID] or 0) + amount + overkill
				end
			elseif event == "UNIT_DIED" then
				if GetMobID(destGUID) == 93288 then
					for i=1,#data do
						local currData = data[i]
						if currData.guid == destGUID then
							for j=1,#soulsFrames do
								local frame = soulsFrames[j]
								if frame.soul_data == currData then
									frame.soul_data = nil
									break
								end
							end
							tremove(data,i)
							guidToFrame[destGUID] = nil
							UpdateFrames()
							return
						end
					end
				elseif GetUnitTypeByGUID(destGUID) == 0 and destName then
					destName = delUnitNameServer(destName)
					for i=1,#data do
						local currData = data[i]
						if currData.name == destName then
							local guid = currData.guid
							if guid then
								guidToFrame[ guid ] = nil
							end
							for j=1,#soulsFrames do
								local frame = soulsFrames[j]
								if frame.soul_data == currData then
									frame.soul_data = nil
									break
								end
							end
							tremove(data,i)
							UpdateFrames()
							return
						end
					end
				end
			end
		elseif event == 'ENCOUNTER_START' then
			if ... == 1783 then
				C_Timer.After(1,function()
					local boss1guid = UnitGUID'boss1'
					if boss1guid and GetMobID(boss1guid) == 90199 then
						Engage()
					else
						self:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
					end
				end)
			end
		elseif event == 'ENCOUNTER_END' then
			self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			self:UnregisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
			wipe(guidToFrame)
			wipe(data)
			wipe(unkSouls)
			for j=1,#soulsFrames do
				soulsFrames[j].soul_data = nil
			end
			UpdateFrames()
		elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
			local boss1guid = UnitGUID'boss1'
			if boss1guid and GetMobID(boss1guid) == 90199 then
				self:UnregisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT')
				Engage()
			end
		elseif event == 'GROUP_ROSTER_UPDATE' then
			UpdateFrames_Roster()
		end
	end
	
	frame:SetScript("OnEvent",Gorefiend2_OnEvent)
	UpdateFrames()
end

-----------------------------------------
-- Il'gynoth
-----------------------------------------
local Ilgynoth = {}
module.A.Ilgynoth = Ilgynoth

Ilgynoth.runes = {
{	12380.46	,	-12795.02		}, --	27	0
{	12377.793333333	,	-12783.320047483	}, --	27	1
{	12370.320082305	,	-12773.931196699	}, --	27	2
{	12359.516444648	,	-12768.708035455	}, --	27	3
{	12347.516472246	,	-12768.682299306	}, --	27	4
{	12336.690530017	,	-12773.859071937	}, --	27	5
{	12329.177075687	,	-12783.215780975	}, --	27	6
{	12326.460248381	,	-12794.904187598	}, --	27	7
{	12329.076705346	,	-12806.615470745	}, --	27	8
{	12336.509615576	,	-12816.036290535	}, --	27	9
{	12347.290749889	,	-12821.305744294	}, --	27	10
{	12359.290501509	,	-12821.382952266	}, --	27	11
{	12370.138549126	,	-12816.252663494	}, --	27	12
{	12377.692068522	,	-12806.928268353	}, --	27	13
{	12367.46	,	-12795.02		}, --	14	0
{	12362.317142857	,	-12784.177905165	}, --	14	1
{	12350.666997085	,	-12781.301431025	}, --	14	2
{	12341.068853454	,	-12788.50390552		}, --	14	3
{	12340.574409327	,	-12800.493714735	}, --	14	4
{	12349.546929776	,	-12808.462019246	}, --	14	5
{	12361.394358961	,	-12806.554554516	}, --	14	6
}
--Ilgynoth.map = {12535.42578125,-12679.200195313,12066.67578125,-12991.700195313}	--xT,yT,xB,yB
Ilgynoth.image_avg = 341 / 512
Ilgynoth.map = {12353.46 + 45,-12792.02 + 90 * Ilgynoth.image_avg / 2,12353.46 - 45,-12792.02 - 90 * Ilgynoth.image_avg / 2 - 10}	--xT,yT,xB,yB
Ilgynoth.image = {0,0,1,1}	-- IlgynothMap.tga 512х341
Ilgynoth.width = 768

Ilgynoth.hidePlayers = true
function Ilgynoth:UpdateSelectRoster()
	local setup = {}
	for i=1,#Ilgynoth.runes do
		local name = VExRT.Bossmods.Ilgynoth[i]
		if name then
			setup[name] = true
		end
	end
	local raidData = {{},{},{},{},{},{}}
	if IsInRaid() then
		for i=1,40 do
			local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
			if name and subgroup <= 6 then
				raidData[subgroup][ #raidData[subgroup]+1 ] = {name,class}
			end
		end
	else
		for _,unit in pairs({'player','party1','party2','party3','party4'}) do
			local name = UnitName(unit)
			local _,class = UnitClass(unit)
			if name then
				raidData[1][ #raidData[1]+1 ] = {name,class}
			end
		end
	end
	for i=1,6 do
		for j=1,5 do
			local pos = (i-1)*5+j
			local data = raidData[i][j]
			if Ilgynoth.raidRoster.buttons[pos] and data then
				Ilgynoth.raidRoster.buttons[pos]._name = data[1]
				if Ilgynoth.hidePlayers then
					if setup[ data[1] ] then
						Ilgynoth.raidRoster.buttons[pos]:SetAlpha(.2)
					else
						Ilgynoth.raidRoster.buttons[pos]:SetAlpha(1)
					end
				else
					Ilgynoth.raidRoster.buttons[pos]:SetAlpha(1)
				end
				Ilgynoth.raidRoster.buttons[pos].name:SetText("|c"..ExRT.F.classColor(data[2])..data[1])
				Ilgynoth.raidRoster.buttons[pos]:Show()
			elseif Ilgynoth.raidRoster.buttons[pos] then
				Ilgynoth.raidRoster.buttons[pos]:Hide()
			end
		end
	end
end

function Ilgynoth:ReRoster()
	local playerName = UnitName('player')
	for i=1,#Ilgynoth.runes do
		local name = VExRT.Bossmods.Ilgynoth[i]
		if name then
			local shortName = ExRT.F.delUnitNameServer(name)
			local class = select(2,UnitClass(shortName))
			local desaturated = false
			if class then
				class = "|c"..ExRT.F.classColor(class)
			else
				class = ""
				desaturated = true
			end
			if not desaturated and ExRT.F.GetPlayerParty(name) > 4 then
				desaturated = true
			end
			if shortName == playerName then
				Ilgynoth.setupFrame.pings[i].icon:SetVertexColor(1,0.3,0.3,1)
			else
				--Ilgynoth.setupFrame.pings[i].icon:SetVertexColor(1,1,1,1)
				Ilgynoth.setupFrame.pings[i].icon:SetVertexColor(.4,.2,1,1)
			end
			Ilgynoth.setupFrame.pings[i].name:SetText(class..name)
			Ilgynoth.setupFrame.pings[i].icon:SetDesaturated(desaturated)
			if desaturated then
				Ilgynoth.setupFrame.pings[i].icon:SetVertexColor(1,1,1,.7)
			end
		else
			Ilgynoth.setupFrame.pings[i].name:SetText("")
			Ilgynoth.setupFrame.pings[i].icon:SetVertexColor(.3,1,.3,1)
			Ilgynoth.setupFrame.pings[i].icon:SetDesaturated(false)
		end
	end
end

function Ilgynoth:Load()
	if Ilgynoth.setupFrame then
		--Ilgynoth:ReRoster(1)
		Ilgynoth.setupFrame:Show()
		Ilgynoth:RegisterEvents()
		if ExRT.Options.Frame:IsShown() then
			ExRT.Options.Frame:Hide()
		end
		Ilgynoth.setupFrame.isEnabled = true
		return
	end
	Ilgynoth.setupFrame = ELib:Popup("Il'gynoth"):Size(Ilgynoth.width,Ilgynoth.image_avg * Ilgynoth.width)
	Ilgynoth.setupFrame.map = Ilgynoth.setupFrame:CreateTexture(nil,"BACKGROUND",nil,1)
	Ilgynoth.setupFrame.map:SetTexture("Interface\\AddOns\\ExRT\\media\\IlgynothMap.tga")
	Ilgynoth.setupFrame.map:SetPoint("TOP",Ilgynoth.setupFrame,"TOP",0,0)
	Ilgynoth.setupFrame.map:SetSize(Ilgynoth.width,Ilgynoth.image_avg * Ilgynoth.width)
	Ilgynoth.setupFrame.map:SetTexCoord(Ilgynoth.image[1],Ilgynoth.image[3],Ilgynoth.image[2] * Ilgynoth.image_avg,Ilgynoth.image[4] * Ilgynoth.image_avg)
	Ilgynoth.setupFrame:SetFrameStrata("HIGH")
	Ilgynoth.setupFrame:SetClampedToScreen(false)
	
	if VExRT.Bossmods.IlgynothScale and tonumber(VExRT.Bossmods.IlgynothScale) then
		Ilgynoth.setupFrame:SetScale(VExRT.Bossmods.IlgynothScale)
	end
	
	Ilgynoth.setupFrame.isEnabled = true

	local function DisableSync()
		VExRT.Bossmods.Ilgynoth.sync = nil
		if VExRT.Bossmods.Ilgynoth.name and VExRT.Bossmods.Ilgynoth.time then
			Ilgynoth.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Ilgynoth.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Ilgynoth.time)..")"..(not VExRT.Bossmods.Ilgynoth.sync and " *" or ""))
		else
			Ilgynoth.setupFrame.lastUpdate:SetText("")
		end
	end

	local function IlgynothFrameOnEvent(self,event,_,event_n,_,_,_,_,_,destGUID)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if event_n == "UNIT_DIED" and ExRT.F.GUIDtoID(destGUID) == 105906 then
				local playerName = UnitName('player')
				for i=1,#Ilgynoth.runes do
					local name = VExRT.Bossmods.Ilgynoth[i]
					if name and ExRT.F.delUnitNameServer(name) == playerName then
						ExRT.F.Arrow:ShowRunTo(Ilgynoth.runes[i][1],Ilgynoth.runes[i][2],1,60,true,true)
						return
					--elseif name then
					--	ExRT.F.SendExMsg("arrow", ExRT.F.CreateAddonMsg(name,"g","0",Ilgynoth.runes[i][1],Ilgynoth.runes[i][2],"1","60","1","1"))
					end
				end
			end
		elseif event == "GROUP_ROSTER_UPDATE" then
			if Ilgynoth.setupFrame:IsShown() then
				Ilgynoth:ReRoster()
			end
		end
	end
	
	Ilgynoth.setupFrame.scale = ELib:Slider(Ilgynoth.setupFrame):_Size(70,8):Point("TOPRIGHT",-30,-5):Range(50,100,true):SetTo((VExRT.Bossmods.IlgynothScale or 1)*100):Scale(1 / (VExRT.Bossmods.IlgynothScale or 1)):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.Bossmods.IlgynothScale = event / 100
		ExRT.F.SetScaleFixTR(Ilgynoth.setupFrame,VExRT.Bossmods.IlgynothScale)
		self:SetScale(1 / VExRT.Bossmods.IlgynothScale)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	Ilgynoth.setupFrame.pings = {}
	local function SetupFramePingsOnEnter(self)
		self.colors = {self.icon:GetVertexColor()}
		self.icon:SetVertexColor(1,.3,1,1)
	end
	local function SetupFramePingsOnLeave(self)
	  	self.icon:SetVertexColor(unpack(self.colors))
	end
	local function SetupFramePingsOnClick(self,button)
		if button == "RightButton" then
			self.colors = {.3,1,.3,1}
			VExRT.Bossmods.Ilgynoth[ self._i] = nil
			Ilgynoth:ReRoster()
			
			DisableSync()
			return
		end
		Ilgynoth.raidRoster.pos = self._i
		Ilgynoth.raidRoster.title:SetText(L.BossmodsKromogSelectPlayer..self._i)
		Ilgynoth.raidRoster:Show()
	end
	for i=1,#Ilgynoth.runes do
		local x = (abs(Ilgynoth.runes[i][1]-Ilgynoth.map[1])) / (abs(Ilgynoth.map[3] - Ilgynoth.map[1]))
		local y = (abs(Ilgynoth.runes[i][2]-Ilgynoth.map[2])) / (abs(Ilgynoth.map[4] - Ilgynoth.map[2]))
		local currPing = CreateFrame('Button',nil,Ilgynoth.setupFrame)
		Ilgynoth.setupFrame.pings[i] = currPing
		currPing:SetSize(32,32)
		currPing.icon = currPing:CreateTexture(nil,"ARTWORK")
		currPing.icon:SetAllPoints()
		currPing.icon:SetTexture("Interface\\AddOns\\ExRT\\media\\KormrokRune.tga")
		currPing.num = ELib:Text(currPing,i,12):Size(30,15):Point(0,0):Top():Color():Outline()
		currPing.name = ELib:Text(currPing,"Player"..i,11):Size(75,15):Point(0,-12):Top():Color():Outline()
		
		currPing:SetScript("OnEnter",SetupFramePingsOnEnter)
		currPing:SetScript("OnLeave",SetupFramePingsOnLeave)
		currPing:RegisterForClicks("RightButtonDown","LeftButtonDown")
		currPing._i = i
		currPing:SetScript("OnClick",SetupFramePingsOnClick)
		
		if x >= Ilgynoth.image[1] and x <= Ilgynoth.image[3] and y >= Ilgynoth.image[2] and y <= Ilgynoth.image[4] then
			currPing:SetPoint("CENTER",Ilgynoth.setupFrame.map,"TOPLEFT", (x - Ilgynoth.image[1])/(Ilgynoth.image[3]-Ilgynoth.image[1])*Ilgynoth.width,-(y - Ilgynoth.image[2])/(Ilgynoth.image[4]-Ilgynoth.image[2])*(Ilgynoth.image_avg * Ilgynoth.width))
		end
	end
	
	local function IlgynothClearConfirm()
		for i=1,#Ilgynoth.runes do
			VExRT.Bossmods.Ilgynoth[i] = nil
		end
		Ilgynoth:ReRoster()
		
		DisableSync()
	end
	
	Ilgynoth.setupFrame.clearButton = ELib:Button(Ilgynoth.setupFrame,L.BossmodsKromogClear):Size(120,20):Point("BOTTOMLEFT",7,22):OnClick(function (self)
		StaticPopupDialogs["EXRT_BOSSMODS_KORMROK_CLEAR"] = {
			text = L.BossmodsKromogClear,
			button1 = YES,
			button2 = NO,
			OnAccept = IlgynothClearConfirm,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_KORMROK_CLEAR")
	end)
	
	Ilgynoth.setupFrame.testButton = ELib:Button(Ilgynoth.setupFrame,L.BossmodsKromogTest):Size(120,20):Point("BOTTOMRIGHT",Ilgynoth.setupFrame.clearButton,"TOPRIGHT",0,2):OnClick(function (self)
		IlgynothFrameOnEvent(Ilgynoth.setupFrame,"COMBAT_LOG_EVENT_UNFILTERED",nil,"UNIT_DIED",nil,nil,nil,nil,nil,"Creature-0-2084-1520-2701-105906-00006DB1E6")
		Ilgynoth.setupFrame:Hide()
		C_Timer.NewTimer(6,function() Ilgynoth.setupFrame:Show() end)
	end)
	
	VExRT.Bossmods.IlgynothSetups = VExRT.Bossmods.IlgynothSetups or {}
	local function SetupsDropDown_Load(_,arg)
		for i=1,#Ilgynoth.runes do
			VExRT.Bossmods.Ilgynoth[i] = VExRT.Bossmods.IlgynothSetups[arg][i]
		end
		Ilgynoth:ReRoster()
		DisableSync()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Clear(_,arg)
		for i=1,#Ilgynoth.runes do
			VExRT.Bossmods.IlgynothSetups[arg][i] = nil
		end
		VExRT.Bossmods.IlgynothSetups[arg].date = nil
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Save(_,arg)
		for i=1,#Ilgynoth.runes do
			VExRT.Bossmods.IlgynothSetups[arg][i] = VExRT.Bossmods.Ilgynoth[i]
		end
		VExRT.Bossmods.IlgynothSetups[arg].date = time()
		CloseDropDownMenus()
	end
	local function SetupsDropDown_Close()
		CloseDropDownMenus()
	end
	
	local setupsDropDown = CreateFrame("Frame", "ExRT_Ilgynoth_SetupsDropDown", nil, "UIDropDownMenuTemplate")
	Ilgynoth.setupFrame.setupsButton = ELib:Button(Ilgynoth.setupFrame,L.BossmodsKromogSetups):Size(120,20):Point("BOTTOMRIGHT",Ilgynoth.setupFrame.testButton,"TOPRIGHT",0,2):OnClick(function (self)
		VExRT.Bossmods.IlgynothSetups = VExRT.Bossmods.IlgynothSetups or {}
	
		local dropDown = {
			{ text = L.BossmodsKromogSetups, isTitle = true, notCheckable = true, notClickable = true},
		}
		for i=1,5 do
			VExRT.Bossmods.IlgynothSetups[i] = VExRT.Bossmods.IlgynothSetups[i] or {}
		
			local subMenu = nil
			local saveMenu = { text = L.BossmodsKromogSetupsSave, func = SetupsDropDown_Save, arg1 = i, notCheckable = true }
			local loadMenu = { text = L.BossmodsKromogSetupsLoad, func = SetupsDropDown_Load, arg1 = i, notCheckable = true }
			local clearMenu = { text = L.BossmodsKromogSetupsClear, func = SetupsDropDown_Clear, arg1 = i, notCheckable = true }
			
			local isExists = VExRT.Bossmods.IlgynothSetups[i].date
			local dateText = ""
			if isExists then
				subMenu = {loadMenu,saveMenu,clearMenu}
				dateText = ". "..date("%H:%M:%S %d.%m.%Y",isExists)
			else
				subMenu = {saveMenu}
			end
			
			dropDown[i+1] = {
				text = i..dateText, hasArrow = true, menuList = subMenu, notCheckable = true
			}
		end
		dropDown[7] = { text = L.BossmodsKromogSetupsClose, func = SetupsDropDown_Close, notCheckable = true }
		EasyMenu(dropDown, setupsDropDown, "cursor", 10 , -15, "MENU")
	end)
		
	Ilgynoth.setupFrame.sendButton = ELib:Button(Ilgynoth.setupFrame,L.BossmodsKromogSend):Size(120,20):Point("BOTTOMRIGHT",Ilgynoth.setupFrame.setupsButton,"TOPRIGHT",0,2):OnClick(function (self)
		local line = ""
		local counter = 0
		ExRT.F.SendExMsg("Ilgynoth","clear")
		for i=1,#Ilgynoth.runes do
			if VExRT.Bossmods.Ilgynoth[i] then
				line = line .. i.."\t"..VExRT.Bossmods.Ilgynoth[i].."\t"
				counter = counter + 1
				if counter > 2 then
					ExRT.F.SendExMsg("Ilgynoth",line)
					counter = 0
					line = ""
				end
			end
		end
		if line ~= "" then
			ExRT.F.SendExMsg("Ilgynoth",line)
		end
	end)
	
	Ilgynoth.setupFrame.onlyTrustedChk = ELib:Check(Ilgynoth.setupFrame,L.BossmodsKromogOnlyTrusted,not VExRT.Bossmods.Ilgynoth.UpdatesFromAll):Point("BOTTOMLEFT",Ilgynoth.setupFrame.sendButton,"TOPLEFT",0,2):Scale(.9):Tooltip(L.BossmodsKromogOnlyTrustedTooltip):OnClick(function (self)
		if self:GetChecked() then
			VExRT.Bossmods.Ilgynoth.UpdatesFromAll = nil
		else
			VExRT.Bossmods.Ilgynoth.UpdatesFromAll = true
		end
	end)
	
	Ilgynoth.setupFrame.lastUpdate = ELib:Text(Ilgynoth.setupFrame,"",12):Size(500,20):Point("BOTTOMLEFT",Ilgynoth.setupFrame,"BOTTOMLEFT",7,5):Bottom():Color(1,1,1)--:Outline()
	Ilgynoth.setupFrame.lastUpdate:Color(0,0,0)
	
	local phaseBackground = Ilgynoth.setupFrame:CreateTexture(nil, "BACKGROUND",nil,2)
	phaseBackground:SetPoint("TOPLEFT",0,0)
	phaseBackground:SetPoint("BOTTOMRIGHT",Ilgynoth.setupFrame,"TOPRIGHT",0,-50)
	--phaseBackground:SetColorTexture( 1, 1, 1, 1)
	
	
	Ilgynoth.raidRoster = ELib:Popup(L.BossmodsKromogSelectPlayer):Size(80*6+25,113+14)
	Ilgynoth.raidRoster:SetScript("OnShow",function (self)
		Ilgynoth:UpdateSelectRoster()
	end)
	Ilgynoth.raidRoster.buttons = {}
	local function RaidRosterButtonOnEnter(self)
		self.hl:Show()
	end
	local function RaidRosterButtonOnLeave(self)
		self.hl:Hide()
	end
	local function RaidRosterButtonOnClick(self)
		for i=1,#Ilgynoth.runes do
			if VExRT.Bossmods.Ilgynoth[i] == self._name then
				VExRT.Bossmods.Ilgynoth[i] = nil
			end
		end
		VExRT.Bossmods.Ilgynoth[Ilgynoth.raidRoster.pos] = self._name
		Ilgynoth:ReRoster()
		Ilgynoth.raidRoster:Hide()
		
		DisableSync()
	end
	for i=1,6 do
		for j=1,5 do
			local pos = (i-1)*5+j
			Ilgynoth.raidRoster.buttons[pos] = CreateFrame('Button',nil,Ilgynoth.raidRoster)
			Ilgynoth.raidRoster.buttons[pos]:SetPoint("TOPLEFT",15+(i-1)*80,-25-(j-1)*14)
			Ilgynoth.raidRoster.buttons[pos]:SetSize(80,14)
			ExRT.lib.CreateHoverHighlight(Ilgynoth.raidRoster.buttons[pos])
			Ilgynoth.raidRoster.buttons[pos]:SetScript("OnEnter",RaidRosterButtonOnEnter)
			Ilgynoth.raidRoster.buttons[pos]:SetScript("OnLeave",RaidRosterButtonOnLeave)
			Ilgynoth.raidRoster.buttons[pos].name = ELib:Text(Ilgynoth.raidRoster.buttons[pos],"",12):Size(80,14):Point(0,0):Color(1,1,1):Shadow()
			Ilgynoth.raidRoster.buttons[pos]._name = nil
			Ilgynoth.raidRoster.buttons[pos]:SetScript("OnClick",RaidRosterButtonOnClick)
		end
	end
	Ilgynoth.raidRoster.clearButton = CreateFrame('Button',nil,Ilgynoth.raidRoster)
	Ilgynoth.raidRoster.clearButton:SetPoint("BOTTOMRIGHT",Ilgynoth.raidRoster,"BOTTOMRIGHT",-11,12)
	Ilgynoth.raidRoster.clearButton:SetSize(80,14)
	ExRT.lib.CreateHoverHighlight(Ilgynoth.raidRoster.clearButton)
	Ilgynoth.raidRoster.clearButton:SetScript("OnEnter",function(self)
		self.hl:Show()
	end)
	Ilgynoth.raidRoster.clearButton:SetScript("OnLeave",function(self)
		self.hl:Hide()
	end)
	
	Ilgynoth.raidRoster.clearButton.name = ELib:Text(Ilgynoth.raidRoster.clearButton,L.BossmodsKromogClear,12):Size(80,14):Point(0,0):Right():Middle():Color(1,1,1):Shadow()
	Ilgynoth.raidRoster.clearButton:SetScript("OnClick",function(self)
		VExRT.Bossmods.Ilgynoth[Ilgynoth.raidRoster.pos] = nil
		Ilgynoth:ReRoster()
		Ilgynoth.raidRoster:Hide()
		
		DisableSync()
	end)
	
	Ilgynoth.raidRoster.hideChk = ELib:Check(Ilgynoth.raidRoster,L.BossmodsKromogHidePlayers,true):Point("BOTTOMLEFT",10,7):Scale(.8):OnClick(function (self)
	  	Ilgynoth.hidePlayers = self:GetChecked()
	  	Ilgynoth:UpdateSelectRoster()
	end)
	
	function Ilgynoth:RegisterEvents()
		Ilgynoth.setupFrame:UnregisterAllEvents()
		Ilgynoth.setupFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		Ilgynoth.setupFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		if not VExRT.Bossmods.Ilgynoth.AlwaysArrow then
			--Ilgynoth.setupFrame:RegisterEvent("ENCOUNTER_START")
			--Ilgynoth.setupFrame:RegisterEvent("ENCOUNTER_END")
		end
	end
	Ilgynoth:RegisterEvents()
	
	Ilgynoth.setupFrame:SetScript("OnEvent",IlgynothFrameOnEvent)
	Ilgynoth.setupFrame:SetScript("OnShow",function (self)
		local isAlpha = false
		if IsInRaid() then
			if ExRT.F.IsPlayerRLorOfficer(UnitName('player')) then
				isAlpha = false
			else
				isAlpha = true
			end
		end
		if isAlpha then
			self.clearButton:SetAlpha(.2)
			self.sendButton:SetAlpha(.2)
			self.setupsButton:SetAlpha(.2)
		else
			self.clearButton:SetAlpha(1)
			self.sendButton:SetAlpha(1)
			self.setupsButton:SetAlpha(1)		
		end
	end)

	if not VExRT.Bossmods.Ilgynoth.name or not VExRT.Bossmods.Ilgynoth.time then
		Ilgynoth.setupFrame.lastUpdate:SetText("")
	else
		Ilgynoth.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Ilgynoth.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Ilgynoth.time)..")"..(not VExRT.Bossmods.Ilgynoth.sync and " *" or ""))
	end
	Ilgynoth:ReRoster()
	Ilgynoth.setupFrame:Show()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	if ExRT.Options.Frame:IsShown() then
		ExRT.Options.Frame:Hide()
	end
end

function Ilgynoth:addonMessage(sender, prefix, ...)
	if prefix == "Ilgynoth" then
		if IsInRaid() and not VExRT.Bossmods.Ilgynoth.UpdatesFromAll and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
	
		local pos1,name1,pos2,name2,pos3,name3 = ...
		VExRT.Bossmods.Ilgynoth.time = time()
		VExRT.Bossmods.Ilgynoth.name = sender
		VExRT.Bossmods.Ilgynoth.sync = true
		if pos1 == "clear" then
			for i=1,#Ilgynoth.runes do
				VExRT.Bossmods.Ilgynoth[i] = nil
			end
			return
		end
		
		if pos1 and name1 then
			pos1 = tonumber(pos1)
			if name1 == "-" then
				name1 = nil
			end
			VExRT.Bossmods.Ilgynoth[pos1] = name1
		end
		if pos2 and name2 then
			pos2 = tonumber(pos2)
			if name2 == "-" then
				name2 = nil
			end
			VExRT.Bossmods.Ilgynoth[pos2] = name2
		end
		if pos3 and name3 then
			pos3 = tonumber(pos3)
			if name3 == "-" then
				name3 = nil
			end
			VExRT.Bossmods.Ilgynoth[pos3] = name3
		end
		
		if Ilgynoth.setupFrame then
			Ilgynoth.setupFrame.lastUpdate:SetText(L.BossmodsKromogLastUpdate..": "..VExRT.Bossmods.Ilgynoth.name.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Bossmods.Ilgynoth.time)..")")
			Ilgynoth:ReRoster()
		end
	end
end

-----------------------------------------
-- Dragons
-----------------------------------------
local Dragons = {}
module.A.Dragons = Dragons

function Dragons:Load()
	if Dragons.mainFrame then
		Dragons.mainFrame:Enable()
		return
	end
	local frame = CreateFrame("Frame",nil,UIParent)
	frame:SetSize(230,16)
	if VExRT.Bossmods.DragonsLeft and VExRT.Bossmods.DragonsTop then
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Bossmods.DragonsLeft,VExRT.Bossmods.DragonsTop)
	else
		frame:SetPoint("TOP",UIParent, "TOP", 0, -50)	
	end
	Dragons.mainFrame = frame
	
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.Bossmods.DragonsLeft = self:GetLeft()
		VExRT.Bossmods.DragonsTop = self:GetTop()
	end)
	if VExRT.Bossmods.Alpha then frame:SetAlpha(VExRT.Bossmods.Alpha/100) end
	if VExRT.Bossmods.Scale then frame:SetScale(VExRT.Bossmods.Scale/100) end
	
	frame.back = frame:CreateTexture(nil,"BACKGROUND")
	frame.back:SetColorTexture(0,0,0,.3)
	frame.back:SetAllPoints()
	
	frame.nameText = frame:CreateFontString(nil,"ARTWORK")
	frame.nameText:SetPoint("CENTER")
	frame.nameText:SetFont(ExRT.F.defFont, 12)
	frame.nameText:SetShadowOffset(1,-1)
	frame.nameText:SetText(GetSpellInfo(203153))
	
	frame:SetClampedToScreen(true)
	
	frame.botLine = CreateFrame("Frame",nil,frame)
	frame.botLine:SetPoint("TOP",frame,"BOTTOM",0,-50)
	frame.botLine:SetSize(100,1)
	
	frame.linesL,frame.linesR,frame.linesC = {},{},{}
	
	local flowers = {}
	
	local function GetLine(pos,i)
		local arr = (pos == "L" and frame.linesL) or (pos == "R" and frame.linesR) or frame.linesC
		if not arr[i] then
			local line = CreateFrame("Frame",nil,frame)
			arr[i] = line
			line:SetSize(114,24)
			if pos == "L" then
				line:SetPoint("TOPLEFT",frame,"BOTTOMLEFT",0,-24*(i-1))
			elseif pos == "R" then
				line:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",0,-24*(i-1))
			else
				line:SetPoint("TOP",frame.botLine,"BOTTOM",0,-24*(i-1))
			end
			
			line.nameText = line:CreateFontString(nil,"ARTWORK")
			line.nameText:SetPoint("LEFT",2,0)
			line.nameText:SetPoint("RIGHT",-2,0)
			line.nameText:SetJustifyH(pos == "L" and "LEFT" or pos == "R" and "RIGHT" or "CENTER")
			line.nameText:SetFont(ExRT.F.defFont, 12)
			line.nameText:SetShadowOffset(1,-1)
			line.nameText:SetText("Player name")
			
			line.back = line:CreateTexture(nil,"BACKGROUND")
			line.back:SetColorTexture(0,0,0,.1)
			line.back:SetAllPoints()		
					
			line.cdIcon = line:CreateTexture(nil, "ARTWORK")
			line.cdIcon:SetTexture(GetSpellTexture(203690))
			if pos ~= "R" then
				line.cdIcon:SetPoint("RIGHT",line,"LEFT",0,0)
			else
				line.cdIcon:SetPoint("LEFT",line,"RIGHT",0,0)
			end
			line.cdIcon:SetSize(24,24)
			line.cdIcon:SetTexCoord(.1,.9,.1,.9)

			line.cd = CreateFrame("Cooldown", nil, line, "CooldownFrameTemplate")
			line.cd:SetDrawEdge(false)
			line.cd:SetAllPoints(line.cdIcon)
		end
		return arr[i]
	end
	
	local FlowerDuration = select(3,GetInstanceInfo()) == 16 and 30 or 40
	
	local linesCount = {
		L = 0,
		C = 0,
		R = 0,
	}
	local function UpdateLines()
		linesCount.L = 0
		linesCount.C = 0
		linesCount.R = 0
		for i=1,#flowers do
			local flower = flowers[i]
			local side = flower.side
			linesCount[side] = linesCount[side] + 1
			local line = GetLine(side,linesCount[side])
		
			if flower[1] then
				line.nameText:SetText(flower[1])
				local _,class = UnitClass(flower[1])
				if class then
					line.nameText:SetTextColor(ExRT.F.classColorNum(class))
				else
					line.nameText:SetTextColor(1,1,1)
				end
				line.back:SetColorTexture(0,0,0,.1)	
			else
				line.nameText:SetText("")
				line.back:SetColorTexture(1,0,0,.2)
			end
			line.cd:SetCooldown(flower.t, FlowerDuration)
			line:Show()
		end
		for i=linesCount.L + 1,#frame.linesL do
			frame.linesL[i]:Hide()
		end
		for i=linesCount.C + 1,#frame.linesC do
			frame.linesC[i]:Hide()
		end
		for i=linesCount.R + 1,#frame.linesR do
			frame.linesR[i]:Hide()
		end
		frame.botLine:SetPoint("TOP",frame,"BOTTOM",0,-24 * max(linesCount.L, linesCount.R))
	end
	
	function frame:Enable()
		frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		frame:RegisterEvent("ENCOUNTER_START")
		frame:RegisterEvent("ENCOUNTER_END")
		frame:Show()
	end
	function frame:Disable()
		frame:UnregisterAllEvents()
		frame:Hide()
	end
	frame:Enable()
	
	local p1y,p1x = 519,-12782
	local p2y,p2x = 679,-12857
	local function GetPlayerSide(playerName)
		local y,x = UnitPosition(playerName)
		
		if y then
			local m = (x - p1x) * (p2y - p1y) - (y - p1y) * (p2x - p1x)
			if m > 0 then
				return "L"
			else
				return "R"
			end
		end
	end
	
	frame:SetScript("OnEvent",function(self,event,timestamp,event_cleu,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if event_cleu == "SPELL_SUMMON" and spellID == 203153 then
				flowers[#flowers + 1] = {
					guid = destGUID,
					side = "C",
					t = GetTime(),
				}
				UpdateLines()
				C_Timer.After(FlowerDuration,function()
					for i=1,#flowers do
						if flowers[i].guid == destGUID then
							tremove(flowers, i)
							UpdateLines()
							break
						end
					end
				end)
			elseif event_cleu == "SPELL_AURA_APPLIED" and spellID == 207681 then
				for i=1,#flowers do
					if flowers[i].guid == sourceGUID then
						flowers[i][ #flowers[i] + 1 ] = destName
						flowers[i].side = GetPlayerSide(destName) or flowers[i].side
						UpdateLines()
						break
					end
				end
			elseif event_cleu == "SPELL_AURA_REMOVED" and spellID == 207681 then
				for i=1,#flowers do
					if flowers[i].guid == sourceGUID then
						for j=1,#flowers[i] do
							if flowers[i][j] == destName then
								flowers[i].side = GetPlayerSide(destName) or flowers[i].side
								tremove(flowers[i], j)
								UpdateLines()
								return
							end
						end
					end
				end
			elseif event_cleu == "SPELL_DAMAGE" and spellID == 203153 then
				local lastFlower = flowers[ #flowers ]
				if not lastFlower or (GetTime() - lastFlower.t) > 1.5 then
					return
				end
				lastFlower.side = GetPlayerSide(destName) or lastFlower.side
			end
		elseif event == 'ENCOUNTER_START' and timestamp == 1854 then
			wipe(flowers)
			FlowerDuration = select(3,GetInstanceInfo()) == 16 and 30 or 40
			UpdateLines()
		elseif event == 'ENCOUNTER_END' and timestamp == 1854 then
			wipe(flowers)
			UpdateLines()
		end
	end)
end


-----------------------------------------
-- Options
-----------------------------------------

local function GetSpellText(spellID)
	if spellID < 0 then
		local name, _, _, abilityIcon = C_EncounterJournal.GetSectionInfo(-spellID)[1]
		if not name then
			return ""
		end
		return "|T"..(abilityIcon or "")..":0|t"..name
	end
	local spellName,_,spellTexture = GetSpellInfo(spellID)
	if not spellName then
		return ""
	end
	
	return "|T"..spellTexture..":0|t"..spellName
end

function module.options:Load()
	self:CreateTilte()

	local PI2 = PI * 2

	local model = CreateFrame("PlayerModel", nil, self)
	model:SetSize(280,220)
	model:SetPoint("BOTTOMRIGHT", 0, 67)
	model:SetFrameStrata("DIALOG")
	model:Hide()
	--EncounterJournal.ceatureDisplayID
	
	model.fac = 0
	model:SetScript("OnUpdate",function (self,elapsed)
		self.fac = self.fac + 0.5
		if self.fac >= 360 then
			self.fac = 0
		end
		self:SetFacing(PI2 / 360 * self.fac)
		
	end)
	model:SetScript("OnShow",function (self)
		self.fac = 0
	end)
	
	self.model = model
	
	
	self.decorationLine = self:CreateTexture(nil, "BACKGROUND")
	self.decorationLine:SetPoint("TOPLEFT",self,-8,-25)
	self.decorationLine:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",8,-45)
	self.decorationLine:SetColorTexture(1,1,1,1)
	self.decorationLine:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	self.tab = ELib:Tabs(self,0,EXPANSION_NAME4,EXPANSION_NAME5,EXPANSION_NAME6):Point(0,-45):Size(660,570):SetTo(3)
	self.tab:SetBackdropBorderColor(0,0,0,0)
	self.tab:SetBackdropColor(0,0,0,0)
	
	local function buttonOnEnter(self)
		if self.modelID then
			model:Show() 
			model:SetDisplayInfo(self.modelID) 
		end
		ELib.Tooltip.Std(self)
	end
	local function buttonOnLeave(self)
		model:Hide() 
		ELib.Tooltip:Hide()
	end
	
	self.tab.tabs[1].positionNow = -5
	self.tab.tabs[2].positionNow = -5
	self.tab.tabs[3].positionNow = -5
		
	local function AddTitle(expansion,title)
		local this = ELib:Text(self.tab.tabs[expansion],title,14):Size(650,20):Point(5,self.tab.tabs[expansion].positionNow):Center():Color()
		self.tab.tabs[expansion].positionNow = self.tab.tabs[expansion].positionNow - 20
		return this
	end
	local function AddButton(expansion,title,tooltip,clickFunction,modelID,isChk,chkEnabled,chkTooltip)
		local this = ELib:Button(self.tab.tabs[expansion],title):Size(isChk and 625 or 650,20):Point(5,self.tab.tabs[expansion].positionNow):Tooltip(tooltip):OnClick(clickFunction)
		this:SetScript("OnEnter",buttonOnEnter) 
		this:SetScript("OnLeave",buttonOnLeave) 
		this.modelID = modelID
		if isChk then
			this.chk = ELib:Check(self.tab.tabs[expansion],"",chkEnabled):Point(635,self.tab.tabs[expansion].positionNow):Tooltip(chkTooltip)
		end
		self.tab.tabs[expansion].positionNow = self.tab.tabs[expansion].positionNow - 25
		return this
	end
	
	AddTitle(1,L.bossmodstot)
	AddButton(1,L.bossmodsraden,'/rt raden',RaDen.Load,47739)
	AddTitle(1,L.bossmodssoo)
	AddButton(1,L.bossmodsshaofpride,'/rt shapride',ShaOfPride.Load,49098)
	
	local malkorok_loadbut = AddButton(1,L.bossmodsmalkorok,'/rt malkorok\n/rt malkorok raid',Malkorok.Load,49070,true,not VExRT.Bossmods.MalkorokAutoload,L.bossmodsAutoLoadTooltip)
	malkorok_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.MalkorokAutoload = nil
		else
			VExRT.Bossmods.MalkorokAutoload = true
		end
	end)
	
	local malkorokAI_loadbut = AddButton(1,L.bossmodsmalkorokai,'/rt malkorokai',MalkorokAI.Load,49070,true,VExRT.Bossmods.MalkorokAIAutoload,L.bossmodsAutoLoadTooltip)
	malkorokAI_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.MalkorokAIAutoload = true
		else
			VExRT.Bossmods.MalkorokAIAutoload = nil
		end
	end)

	local Spoils_of_Pandaria_loadbut = AddButton(1,L.bossmodsSpoilsofPandaria,nil,SpoilsOfPandaria.Load,51173,true,VExRT.Bossmods.SpoilsOfPandariaAutoload,L.bossmodsAutoLoadTooltip)
	Spoils_of_Pandaria_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.SpoilsOfPandariaAutoload = true
		else
			VExRT.Bossmods.SpoilsOfPandariaAutoload = nil
		end
	end)
	

	AddTitle(2,L.RaidLootT17Highmaul)

	local Koragh_loadbut = AddButton(2,L.BossmodsKoragh,L.BossmodsKoraghHelp,Koragh.Load,54825,true,not VExRT.Bossmods.KoraghAutoload,L.bossmodsAutoLoadTooltip)
	Koragh_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.KoraghAutoload = nil
		else
			VExRT.Bossmods.KoraghAutoload = true
		end
	end)

	AddButton(2,L.BossmodsMargok,nil,Margok.Load,54329)

	AddTitle(2,L.RaidLootT17BF)

	local Kromog_loadbut = AddButton(2,L.BossmodsKromog,"/rt kromog",Kromog.Load,56214,true,not VExRT.Bossmods.KromogAutoload,L.bossmodsAutoLoadTooltip)
	Kromog_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.KromogAutoload = nil
		else
			VExRT.Bossmods.KromogAutoload = true
		end
	end)
	
	AddButton(2,L.BossmodsThogar,nil,Thogar.Load,53519)
	
	AddTitle(2,L.RaidLootT18HC)
	
	local Kormrok_loadbut = AddButton(2,L.RaidLootT18HCBoss3.." ["..L.sencounterWODMythic.."]","/rt kormrok|n|n"..GetSpellText(181092),Kormrok.Load,61990,true,not VExRT.Bossmods.KormrokAutoload,L.bossmodsAutoLoadTooltip)
	Kormrok_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.KormrokAutoload = nil
		else
			VExRT.Bossmods.KormrokAutoload = true
		end
	end)
	
	local Gorefiend_loadbut = AddButton(2,L.RaidLootT18HCBoss6.." ["..L.sencounterWODMythic.."]","/rt gorefiend|n|n"..GetSpellText(-11547),Gorefiend.Load,61913,true,VExRT.Bossmods.GorefiendAutoload,L.bossmodsAutoLoadTooltip)
	Gorefiend_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.GorefiendAutoload = true
		else
			VExRT.Bossmods.GorefiendAutoload = nil
		end
	end)	
	
	AddButton(2,L.RaidLootT18HCBoss6.." ["..L.sencounterWODMythic.."] "..L.BossmodsGorefiendWithClicking,"/rt gorefiend2|n|n"..GetSpellText(-11547),Gorefiend2.Load,61913)
	
	local Iskar_loadbut = AddButton(2,L.RaidLootT18HCBoss7,"/rt iskar|n|n"..GetSpellText(179202),Iskar.Load,61932,true,not VExRT.Bossmods.IskarAutoload,L.bossmodsAutoLoadTooltip)
	Iskar_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.IskarAutoload = nil
		else
			VExRT.Bossmods.IskarAutoload = true
		end
	end)	
	
	local Mannoroth_loadbut = AddButton(2,L.RaidLootT18HCBoss12,"/rt mannoroth|n|n"..GetSpellText(181597),Mannoroth.Load,62410,true,VExRT.Bossmods.MannorothAutoload,L.bossmodsAutoLoadTooltip)
	Mannoroth_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.MannorothAutoload = true
		else
			VExRT.Bossmods.MannorothAutoload = nil
		end
	end)	
	
	local Archimonde_loadbut = AddButton(2,L.RaidLootT18HCBoss13..": "..L.BossmodsArchimondeRadar,"/rt archimonde|n|n"..GetSpellText(186123),Archimonde.Load,62423,true,not VExRT.Bossmods.ArchimondeAutoload,L.bossmodsAutoLoadTooltip)
	Archimonde_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.ArchimondeAutoload = nil
		else
			VExRT.Bossmods.ArchimondeAutoload = true
		end
	end)
	
	local ArchimondeInfernals_loadbut = AddButton(2,L.RaidLootT18HCBoss13..": "..L.BossmodsArchimondeInfernals,"/rt archimondeinf|n|n"..L.BossmodsArchimondeInfernalsTooltip,ArchimondeInfernals.Load,62423,true,not VExRT.Bossmods.ArchimondeInfernalsAutoload,L.bossmodsAutoLoadTooltip)
	ArchimondeInfernals_loadbut.chk:SetScript("OnClick", function(self,event) 
		if self:GetChecked() then
			VExRT.Bossmods.ArchimondeInfernalsAutoload = nil
		else
			VExRT.Bossmods.ArchimondeInfernalsAutoload = true
		end
	end)
	
	AddTitle(3,L.S_ZoneT19Nightmare)
	
	AddButton(3,L.bossName[1854],"",Dragons.Load,67748,false,not VExRT.Bossmods.DragonsAutoload,L.bossmodsAutoLoadTooltip)
	
	AddButton(3,L.bossName[1873],"",Ilgynoth.Load,69115,false,not VExRT.Bossmods.IlgynothAutoload,L.bossmodsAutoLoadTooltip)
		
	local Xavius_loadbut = AddButton(3,L.bossName[1864]..": "..L.BossmodsArchimondeRadar,"",Archimonde.Load,65636,false,not VExRT.Bossmods.XaviusAutoload,L.bossmodsAutoLoadTooltip)
	Xavius_loadbut:Disable()
	
	local BossmodsSlider1 = ELib:Slider(self,L.bossmodsalpha):Size(640):Point("TOP",0,-550):Range(0,100):SetTo(VExRT.Bossmods.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Bossmods.Alpha = event	
		if RaDen.mainframe then
			RaDen.mainframe:SetAlpha(event/100)
		end
		if Malkorok.mainframe then
			Malkorok.mainframe:SetAlpha(event/100)
		end
		if ShaOfPride.mainframe then
			ShaOfPride.mainframe:SetAlpha(event/100)
		end
		if SpoilsOfPandaria.mainframe then
			SpoilsOfPandaria.mainframe:SetAlpha(event/100)
		end
		if Thogar.mainframe then
			Thogar.mainframe:SetAlpha(event/100)
		end
		if Margok.mainframe then
			Margok.mainframe:SetAlpha(event/100)
		end
		if Iskar.mainframe then
			Iskar.mainframe:SetAlpha(event/100)
		end
		if Gorefiend.mainframe then
			Gorefiend.mainframe:SetAlpha(event/100)
		end
		if Gorefiend2.mainframe then
			--Gorefiend2.mainframe:SetAlpha(event/100)
		end
		if Archimonde.mainframe then
			Archimonde.mainframe:SetAlpha(event/100)
		end
		if ArchimondeInfernals.mainframe then
			ArchimondeInfernals.mainframe:SetAlpha(event/100)
		end
		if Dragons.mainFrame then
			Dragons.mainFrame:SetAlpha(event/100)
		end
		
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	local BossmodsSlider2 = ELib:Slider(self,L.bossmodsscale):Size(640):Point("TOP",0,-580):Range(5,200):SetTo(VExRT.Bossmods.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Bossmods.Scale = event
		if RaDen.mainframe then
			ExRT.F.SetScaleFix(RaDen.mainframe,event/100)
		end
		if Malkorok.mainframe then
			ExRT.F.SetScaleFix(Malkorok.mainframe,event/100)
		end
		if ShaOfPride.mainframe then
			ExRT.F.SetScaleFix(ShaOfPride.mainframe,event/100)
		end
		if SpoilsOfPandaria.mainframe then
			ExRT.F.SetScaleFix(SpoilsOfPandaria.mainframe,event/100)
		end
		if Thogar.mainframe then
			ExRT.F.SetScaleFix(Thogar.mainframe,event/100)
		end
		if Margok.mainframe then
			ExRT.F.SetScaleFix(Margok.mainframe,event/100)
		end
		if Iskar.mainframe then
			--ExRT.F.SetScaleFix(Iskar.mainframe,event/100)
		end
		if Archimonde.mainframe then
			--ExRT.F.SetScaleFix(Archimonde.mainframe,event/100)
		end
		if ArchimondeInfernals.mainframe then
			--ArchimondeInfernals.mainframe:SetScale(event/100)
		end
		if Dragons.mainFrame then
			ExRT.F.SetScaleFix(Dragons.mainFrame,event/100)
		end
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	local clearallbut = ELib:Button(self,L.bossmodsclose):Size(320,20):Point("RIGHT",self,"TOP",-5,-515):OnClick(function()
		ExRT.F:ExBossmodsCloseAll()
	end) 
	
	local ButtonToCenter = ELib:Button(self,L.BossmodsResetPos):Size(320,20):Point("LEFT",self,"TOP",5,-515):Tooltip(L.BossmodsResetPosTooltip):OnClick(function()
		StaticPopupDialogs["EXRT_BOSSMODS_CENTER"] = {
			text = L.BossmodsResetPosTooltip,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				VExRT.Bossmods.RaDenLeft = nil
				VExRT.Bossmods.RaDenTop = nil
				if RaDen.mainframe then
					RaDen.mainframe:ClearAllPoints()
					RaDen.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end
				
				VExRT.Bossmods.ShaofprideLeft = nil
				VExRT.Bossmods.ShaofprideTop = nil
				if ShaOfPride.mainframe then
					ShaOfPride.mainframe:ClearAllPoints()
					ShaOfPride.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end
				
				VExRT.Bossmods.MalkorokLeft = nil
				VExRT.Bossmods.MalkorokTop = nil
				if Malkorok.mainframe then
					Malkorok.mainframe:ClearAllPoints()
					Malkorok.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end	
				
				VExRT.Bossmods.SpoilsofPandariaLeft = nil
				VExRT.Bossmods.SpoilsofPandariaTop = nil
				if SpoilsOfPandaria.mainframe then
					SpoilsOfPandaria.mainframe:ClearAllPoints()
					SpoilsOfPandaria.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end
				
				VExRT.Bossmods.ThogarLeft = nil
				VExRT.Bossmods.ThogarTop = nil
				if Thogar.mainframe then
					Thogar.mainframe:ClearAllPoints()
					Thogar.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end		
				
				VExRT.Bossmods.MargokLeft = nil
				VExRT.Bossmods.MargokTop = nil
				if Margok.mainframe then
					Margok.mainframe:ClearAllPoints()
					Margok.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end
				
				VExRT.Bossmods.IskarLeft = nil
				VExRT.Bossmods.IskarTop = nil
				if Iskar.mainframe then
					Iskar.mainframe:ClearAllPoints()
					Iskar.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end
				
				VExRT.Bossmods.GorefiendPosX = nil
				VExRT.Bossmods.GorefiendPosY = nil
				if Gorefiend.mainframe then
					Gorefiend.mainframe:ClearAllPoints()
				end
				if Gorefiend2.mainframe then
					Gorefiend2.mainframe:ClearAllPoints()
					Gorefiend2.mainframe:SetPoint("TOP",UIParent,"CENTER",-350,200)
				end
				
				VExRT.Bossmods.ArchimondeLeft = nil
				VExRT.Bossmods.ArchimondeTop = nil
				if Archimonde.mainframe then
					Archimonde.mainframe:ClearAllPoints()
					Archimonde.mainframe:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
				end
				
				VExRT.Bossmods.ArchimondeInfernalPosX = nil
				VExRT.Bossmods.ArchimondeInfernalPosY = nil
				if ArchimondeInfernals.mainframe then
					ArchimondeInfernals.mainframe:ClearAllPoints()
				end
				
				VExRT.Bossmods.DragonsLeft = nil
				VExRT.Bossmods.DragonsTop = nil
				if Dragons.mainFrame then
					Dragons.mainFrame:ClearAllPoints()
					Dragons.mainFrame:SetPoint("TOP",UIParent, "TOP", 0, -50)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_BOSSMODS_CENTER")

	end) 
	
	VExRT.Bossmods.ModuleViewed3580 = true
end

function ExRT.F:ExBossmodsCloseAll()
	if RaDen.mainframe then
		RaDen.mainframe:Hide()
		RaDen.mainframe:SetScript("OnUpdate", nil)
		RaDen.mainframe:SetScript("OnEvent", nil)
		RaDen.mainframe:UnregisterAllEvents()
		RaDen.mainframe = nil
	end
	if MalkorokAI.mainframe then
		MalkorokAI.mainframe:Hide()
		MalkorokAI.mainframe:UnregisterAllEvents() 
		MalkorokAI.mainframe:SetScript("OnUpdate", nil)
		MalkorokAI.mainframe:SetScript("OnEvent", nil)
		if MalkorokAI.mainframe_2 then
			MalkorokAI.mainframe_2:SetScript("OnUpdate", nil)
			MalkorokAI.mainframe_2 = nil
		end
		MalkorokAI.mainframe = nil
	end
	if Malkorok.mainframe then
		Malkorok.mainframe:Hide()
		Malkorok.mainframe:UnregisterAllEvents()
		Malkorok.mainframe:SetScript("OnUpdate", nil)
		Malkorok.mainframe:SetScript("OnEvent", nil)
		Malkorok.mainframe = nil
	end
	if ShaOfPride.mainframe then
		ShaOfPride.mainframe:Hide()
		ShaOfPride.mainframe:UnregisterAllEvents()
		ShaOfPride.mainframe:SetScript("OnUpdate", nil)
		ShaOfPride.mainframe:SetScript("OnEvent", nil)
		ShaOfPride.mainframe = nil
	end
	if SpoilsOfPandaria.mainframe then
		SpoilsOfPandaria.mainframe:Hide()
		SpoilsOfPandaria.mainframe:SetScript("OnUpdate", nil)
		SpoilsOfPandaria.mainframe = nil
	end
	if Kromog.setupFrame then
		Kromog.setupFrame:UnregisterAllEvents()
		Kromog.setupFrame.isEnabled = nil
	end
	if Thogar.mainframe then
		Thogar.mainframe:Hide()
		Thogar.mainframe:UnregisterAllEvents()
		Thogar.mainframe:SetScript("OnUpdate", nil)
		Thogar.mainframe:SetScript("OnEvent", nil)
		Thogar.mainframe = nil
	end
	if Margok.mainframe then
		Margok.mainframe:Hide()
		Margok.mainframe:UnregisterAllEvents()
		Margok.mainframe:SetScript("OnUpdate", nil)
		Margok.mainframe:SetScript("OnEvent", nil)
		Margok.mainframe = nil
		Margok.rosterFrame:UnregisterAllEvents()
		Margok.rosterFrame:SetScript("OnEvent", nil)
		Margok.rosterFrame = nil
	end
	if Koragh.mainframe then
		Koragh.mainframe:UnregisterAllEvents()
		Koragh.mainframe:SetScript("OnEvent", nil)
		Koragh.mainframe = nil
	end
	if Iskar.mainframe then
		Iskar.mainframe:Hide()
		Iskar.mainframe:UnregisterAllEvents()
		Iskar.mainframe:SetScript("OnUpdate", nil)
		Iskar.mainframe:SetScript("OnEvent", nil)
		Iskar.mainframe:Close()
		if not Iskar.mainframe:IsShown() then
			Iskar.mainframe = nil
		end
	end
	if Kormrok.setupFrame then
		Kormrok.setupFrame:UnregisterAllEvents()
		Kormrok.setupFrame.isEnabled = nil
	end
	if Mannoroth.setupFrame then
		Mannoroth.setupFrame:UnregisterAllEvents()
		Mannoroth.setupFrame.isEnabled = nil	
	end
	if Gorefiend.mainframe then
		Gorefiend.mainframe:Close()
	end
	if Gorefiend2.mainframe then
		Gorefiend2.mainframe:Close()
	end
	if Archimonde.mainframe then
		Archimonde.mainframe:Hide()
		Archimonde.mainframe:UnregisterAllEvents()
		Archimonde.mainframe.isEnabled = nil	
	end
	if ArchimondeInfernals.mainframe then
		ArchimondeInfernals.mainframe:Close()
	end
	if Dragons.mainFrame then
		Dragons.mainFrame:Disable()
	end
	if Ilgynoth.setupFrame then
		Ilgynoth.setupFrame:UnregisterAllEvents()
		Ilgynoth.setupFrame.isEnabled = nil
	end
end

function module:miniMapMenu()
	if true then
		return
	end
	SetMapToCurrentZone()
	local cmap = GetCurrentMapAreaID()
	local clvl = GetCurrentMapDungeonLevel()

	if cmap==930 and clvl==8 then
		ExRT.F.MinimapMenuAdd("|cff00ff00"..L.bossmodsraden, function() RaDen:Load() CloseDropDownMenus() end,3,"Bossmods_Raden")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Raden")
	end

	if cmap==953 and clvl==8 then
		ExRT.F.MinimapMenuAdd(L.bossmodsmalkorok, function() Malkorok:Load() CloseDropDownMenus() end,3,"Bossmods_Malkorok")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Malkorok")
	end

	if cmap==953 and clvl==8 then
		ExRT.F.MinimapMenuAdd(L.bossmodsmalkorokai, function() MalkorokAI:Load() CloseDropDownMenus() end,3,"Bossmods_MalkorokAI")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_MalkorokAI")
	end

	if cmap==953 and clvl==3 then
		ExRT.F.MinimapMenuAdd(L.bossmodsshaofpride, function() ShaOfPride:Load() CloseDropDownMenus() end,3,"Bossmods_Sha")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Sha")
	end

	if cmap==953 and clvl==9 then
		ExRT.F.MinimapMenuAdd(L.bossmodsSpoilsofPandaria, function() SpoilsOfPandaria:Load() CloseDropDownMenus() end,3,"Bossmods_Spoils")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Spoils")
	end
	
	if cmap==994 and clvl==4 then
		ExRT.F.MinimapMenuAdd(L.BossmodsKoragh, function() Koragh:Load() CloseDropDownMenus() end,3,"Bossmods_Koragh")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Koragh")
	end
	
	if cmap==994 and clvl==6 then
		ExRT.F.MinimapMenuAdd(L.BossmodsMargok, function() Margok:Load() CloseDropDownMenus() end,3,"Bossmods_Margok")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Margok")
	end
	
	if cmap==988 and clvl==1 then
		ExRT.F.MinimapMenuAdd(L.BossmodsKromog, function() Kromog:Load() CloseDropDownMenus() end,3,"Bossmods_Kromog")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Kromog")
	end

	if cmap==988 and clvl==4 then
		ExRT.F.MinimapMenuAdd(L.BossmodsThogar, function() Thogar:Load() CloseDropDownMenus() end,3,"Bossmods_Thogar")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Thogar")
	end
	
	if cmap==1026 and clvl==2 then
		ExRT.F.MinimapMenuAdd(L.RaidLootT18HCBoss6, function() Gorefiend:Load() CloseDropDownMenus() end,3,"Bossmods_Gorefiend")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Gorefiend")
	end
	
	if cmap==1026 and clvl==6 then
		ExRT.F.MinimapMenuAdd(L.RaidLootT18HCBoss7, function() Iskar:Load() CloseDropDownMenus() end,3,"Bossmods_Iskar")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Iskar")
	end
	
	if cmap==1026 and clvl==4 then
		ExRT.F.MinimapMenuAdd(L.RaidLootT18HCBoss3, function() Kormrok:Load() CloseDropDownMenus() end,3,"Bossmods_Kormrok")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Kormrok")
	end
	
	if cmap==1026 and clvl==9 then
		ExRT.F.MinimapMenuAdd(L.RaidLootT18HCBoss12, function() Mannoroth:Load() CloseDropDownMenus() end,3,"Bossmods_Mannoroth")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Mannoroth")
	end
	
	if cmap==1026 and clvl==10 then
		ExRT.F.MinimapMenuAdd(L.RaidLootT18HCBoss13..": "..L.BossmodsArchimondeRadar, function() Archimonde:Load() CloseDropDownMenus() end,3,"Bossmods_Archimonde")
		ExRT.F.MinimapMenuAdd(L.RaidLootT18HCBoss13..": "..L.BossmodsArchimondeInfernals, function() ArchimondeInfernals:Load() CloseDropDownMenus() end,3,"Bossmods_ArchimondeInf")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Archimonde")
		ExRT.F.MinimapMenuRemove("Bossmods_ArchimondeInf")
	end

	if RaDen.mainframe or Malkorok.mainframe or ShaOfPride.mainframe or SpoilsOfPandaria.mainframe or Thogar.mainframe or Margok.mainframe or (Kromog.setupFrame and Kromog.setupFrame.isEnabled) or Koragh.mainframe or Iskar.mainframe or (Archimonde.mainframe and Archimonde.mainframe.isEnabled) or (Mannoroth.setupFrame and Mannoroth.setupFrame.isEnabled) or (ArchimondeInfernals.mainframe and ArchimondeInfernals.mainframe.isEnabled) or (Gorefiend.mainframe and Gorefiend.mainframe.isEnabled) or (Gorefiend2.mainframe and Gorefiend2.mainframe.isEnabled) then
		ExRT.F.MinimapMenuAdd("|cffff9999"..L.bossmodsclose, function() ExRT.F:ExBossmodsCloseAll() CloseDropDownMenus() end,4,"Bossmods_Close")
	else
		ExRT.F.MinimapMenuRemove("Bossmods_Close")
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Bossmods = VExRT.Bossmods or {}
	
	module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END','ZONE_CHANGED','ZONE_CHANGED_NEW_AREA')
	module:RegisterAddonMessage()
	module:RegisterMiniMapMenu()
	module:RegisterSlash()
	
	module.main:ZONE_CHANGED()
	
	--Kromog
	VExRT.Bossmods.Kromog = VExRT.Bossmods.Kromog or {}
	--Kormrok
	VExRT.Bossmods.Kormrok = VExRT.Bossmods.Kormrok or {}
	--Mannoroth
	VExRT.Bossmods.Mannoroth = VExRT.Bossmods.Mannoroth or {}
	--Archimonde
	VExRT.Bossmods.Archimonde = nil
	--Il'gynoth
	VExRT.Bossmods.Ilgynoth = VExRT.Bossmods.Ilgynoth or {}
	
	if VExRT.Addon.Version < 3580 and VExRT.Addon.Version ~= 0 then
		VExRT.Bossmods.ModuleViewed3580 = true
	end
	if VExRT.Addon.Version < 3505 then
		VExRT.Bossmods.MannorothAutoload = nil
	end
	if VExRT.Addon.Version < 3525 then
		if VExRT.Bossmods.Scale then
			VExRT.Bossmods.ArchimondeScale = VExRT.Bossmods.Scale / 100
			VExRT.Bossmods.IskarScale = VExRT.Bossmods.Scale / 100
			VExRT.Bossmods.ArchimondeInfernalsScale = VExRT.Bossmods.Scale / 100
		end
	end
	
	if not VExRT.Bossmods.ModuleViewed3580 then
		--ExRT.Options:AddIcon(L.bossmods,{"Interface\\common\\help-i",28})
	end
end


function module:addonMessage(sender, prefix, ...)
	Malkorok:addonMessage(sender, prefix, ...)
	Kromog:addonMessage(sender, prefix, ...)
	Kormrok:addonMessage(sender, prefix, ...)
	Mannoroth:addonMessage(sender, prefix, ...)
	Ilgynoth:addonMessage(sender, prefix, ...)
end

function module.main:ENCOUNTER_START(encounterID,encounterName,difficultyID,groupSize,...)
	if encounterID == 1595 and not VExRT.Bossmods.MalkorokAutoload and not Malkorok.mainframe then
		Malkorok:Load()
		if VExRT.Bossmods.MalkorokAIAutoload then
			MalkorokAI:Load()
		end
	elseif encounterID == 1594 and VExRT.Bossmods.SpoilsOfPandariaAutoload and not SpoilsOfPandaria.mainframe then
		SpoilsOfPandaria:Load()
	elseif encounterID == 1692 and not Thogar.mainframe and 1==2 then
		Thogar:Load()
		local func = Thogar.mainframe:GetScript("OnEvent")
		func(Thogar.mainframe,encounterID,encounterName,difficultyID,groupSize,...)
	elseif encounterID == 1723 and not Koragh.mainframe and not VExRT.Bossmods.KoraghAutoload and difficultyID == 16 then		
		Koragh:Load()
	elseif encounterID == 1713 and not Kromog.setupFrame and not VExRT.Bossmods.KromogAutoload then
		Kromog:Load()
		Kromog.setupFrame:Hide()
	elseif encounterID == 1787 and (not Kormrok.setupFrame or not Kormrok.setupFrame.isEnabled) and not VExRT.Bossmods.KormrokAutoload and difficultyID == 16 then
		Kormrok:Load()
		Kormrok.setupFrame:Hide()
	elseif encounterID == 1795 and (not Mannoroth.setupFrame or not Mannoroth.setupFrame.isEnabled) and VExRT.Bossmods.MannorothAutoload then
		Mannoroth:Load()
		Mannoroth.setupFrame:Hide()
	elseif encounterID == 1783 and (not Gorefiend.mainframe or Gorefiend.mainframe.isEnabled) and (not Gorefiend2.mainframe or not Gorefiend2.mainframe.isEnabled) and VExRT.Bossmods.GorefiendAutoload and difficultyID == 16 then
		Gorefiend:Load()
		Gorefiend.mainframe:Engage()
	elseif encounterID == 1799 then
		if (not Archimonde.mainframe or not Archimonde.mainframe.isEnabled) and not VExRT.Bossmods.ArchimondeAutoload then
			Archimonde:Load()
			Archimonde.mainframe:Hide()
		end
		if (not ArchimondeInfernals.mainframe or not ArchimondeInfernals.mainframe.isEnabled) and not VExRT.Bossmods.ArchimondeInfernalsAutoload then
			ArchimondeInfernals:Load()
			ArchimondeInfernals.mainframe:Engage()
		end
	end
end

function module.main:ENCOUNTER_END(encounterID,_,_,_,success)
	if not (success == 1) then
		return
	elseif encounterID == 1594 and SpoilsOfPandaria.mainframe then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1604 and ShaOfPride.mainframe then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1595 and Malkorok.mainframe then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1692 and Thogar.mainframe then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1723 and Koragh.mainframe then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1788 and Iskar.mainframe then
		C_Timer.NewTimer(4, function() ExRT.F:ExBossmodsCloseAll() end)
		C_Timer.NewTimer(10, function() ExRT.F:ExBossmodsCloseAll() end)
	elseif encounterID == 1787 and Kormrok.setupFrame and Kormrok.setupFrame.isEnabled then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1795 and Mannoroth.setupFrame and Mannoroth.setupFrame.isEnabled then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1783 then
		if Gorefiend.mainframe and Gorefiend.mainframe.isEnabled then
			ExRT.F:ExBossmodsCloseAll()
		end
		if Gorefiend2.mainframe and Gorefiend2.mainframe.isEnabled  then
			C_Timer.NewTimer(4, function() ExRT.F:ExBossmodsCloseAll() end)
			C_Timer.NewTimer(10, function() ExRT.F:ExBossmodsCloseAll() end)
			
		end
	elseif encounterID == 1799 and ((Archimonde.mainframe and Archimonde.mainframe.isEnabled) or (ArchimondeInfernals.mainframe and ArchimondeInfernals.mainframe.isEnabled)) then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1854 and Dragons.mainFrame then
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1873 and Ilgynoth.setupFrame and Ilgynoth.setupFrame.isEnabled and false then	--Removed in 7.1
		ExRT.F:ExBossmodsCloseAll()
	elseif encounterID == 1864 and Archimonde.mainframe and Archimonde.mainframe.isEnabled and false then	--Removed in 7.1
		ExRT.F:ExBossmodsCloseAll()
	end
end

function module.main:ZONE_CHANGED()
	local y,x,_,map = UnitPosition'player'
	if map == 1448 and y then
		if x > 2455 and x < 2620 and y < 4105 and y > 3980 then
			module:RegisterEvents('PLAYER_TARGET_CHANGED')
		else
			module:UnregisterEvents('PLAYER_TARGET_CHANGED')
		end
	end
end

function module.main:ZONE_CHANGED_NEW_AREA()
	ExRT.F.Timer(module.main.ZONE_CHANGED,2)
end

function module.main:PLAYER_TARGET_CHANGED()
	local targetGUID = UnitGUID'target'
	if not targetGUID then
		return
	elseif GetMobID(targetGUID) == 90316 then
		if InCombatLockdown() then
			return
		end
		if not VExRT.Bossmods.IskarAutoload then
			Iskar:AutoLoad()
		end
	end

end

function module:slash(arg)
	if arg == "raden" then
		RaDen:Load()
	elseif arg == "malkorok raid" then
		Malkorok:PShow()
	elseif arg == "malkorok map" then
		Malkorok:MapNow()
	elseif arg == "malkorok" then
		Malkorok:Load()
	elseif arg == "malkorokai" then
		MalkorokAI:Load()
	elseif arg == "shapride" then
		ShaOfPride:Load()
	elseif arg == "kromog" then
		Kromog:Load()
	elseif arg == "iskar" then
		Iskar:Load()
	elseif arg == "kormrok" then
		Kormrok:Load()
	elseif arg == "mannoroth" then
		Mannoroth:Load()
	elseif arg == "gorefiend" then	
		Gorefiend:Load()
	elseif arg == "gorefiend2" then	
		Gorefiend2:Load()
	elseif arg == "archimonde" then
		Archimonde:Load()
	elseif arg == "archimondeinf" then
		ArchimondeInfernals:Load()
	end
end