local GlobalAddonName, ExRT = ...

local VExRT = nil

local module = ExRT:New("Note",ExRT.L.message)
local ELib,L = ExRT.lib,ExRT.L

local GetTime, CombatLogGetCurrentEventInfo = GetTime, CombatLogGetCurrentEventInfo
local string_gsub, strsplit, tonumber, format, string_match, floor, string_find, type = string.gsub, strsplit, tonumber, format, string.match, floor, string.find, type

local GetSpecialization = GetSpecialization
if ExRT.isClassic then
	GetSpecialization = ExRT.NULLfunc
end

module.db.iconsList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t",
}
module.db.otherIconsList = {
	{"{"..L.classLocalizate["WARRIOR"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:0:64:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0,0.25},
	{"{"..L.classLocalizate["PALADIN"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:0:64:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0.5,0.75},
	{"{"..L.classLocalizate["HUNTER"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:0:64:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0.25,0.5},
	{"{"..L.classLocalizate["ROGUE"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:127:190:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.49609375,0.7421875,0,0.25},
	{"{"..L.classLocalizate["PRIEST"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:127:190:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.49609375,0.7421875,0.25,0.5},
	{"{"..L.classLocalizate["DEATHKNIGHT"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:64:128:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.5,0.5,0.75},
	{"{"..L.classLocalizate["SHAMAN"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:64:127:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.49609375,0.25,0.5},
	{"{"..L.classLocalizate["MAGE"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:64:127:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.49609375,0,0.25},
	{"{"..L.classLocalizate["WARLOCK"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:190:253:64:128|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0.25,0.5},
	{"{"..L.classLocalizate["MONK"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:128:189:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.5,0.73828125,0.5,0.75},
	{"{"..L.classLocalizate["DRUID"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:190:253:0:64|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0,0.25},
	{"{"..L.classLocalizate["DEMONHUNTER"] .."}","|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:190:253:128:192|t","Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0.5,0.75},
	{"{wow}","|TInterface\\FriendsFrame\\Battlenet-WoWicon:16|t","Interface\\FriendsFrame\\Battlenet-WoWicon"},
	{"{d3}","|TInterface\\FriendsFrame\\Battlenet-D3icon:16|t","Interface\\FriendsFrame\\Battlenet-D3icon"},
	{"{sc2}","|TInterface\\FriendsFrame\\Battlenet-Sc2icon:16|t","Interface\\FriendsFrame\\Battlenet-Sc2icon"},
	{"{bnet}","|TInterface\\FriendsFrame\\Battlenet-Portrait:16|t","Interface\\FriendsFrame\\Battlenet-Portrait"},
	{"{alliance}","|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t","Interface\\FriendsFrame\\PlusManz-Alliance"},
	{"{horde}","|TInterface\\FriendsFrame\\PlusManz-Horde:16|t","Interface\\FriendsFrame\\PlusManz-Horde"},
	{"{tank}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0,0.26171875,0.26171875,0.5234375},
	{"{healer}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0,0.26171875},
	{"{dps}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0.26171875,0.5234375},
}

if ExRT.isClassic then
	tremove(module.db.otherIconsList,12)
	tremove(module.db.otherIconsList,10)
	tremove(module.db.otherIconsList,6)
end

module.db.iconsLocalizatedNames = {
	L.raidtargeticon1,L.raidtargeticon2,L.raidtargeticon3,L.raidtargeticon4,L.raidtargeticon5,L.raidtargeticon6,L.raidtargeticon7,L.raidtargeticon8,
}
local iconsLangs = {"eng","de","it","fr","ru"}
for _,lang in pairs(iconsLangs) do
	local new = {}
	module.db["icons"..lang.."Names"] = new
	for i=1,8 do
		new[i] = L["raidtargeticon"..i.."_"..lang]
	end
end

local frameStrataList = {"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}

module.db.msgindex = -1
module.db.lasttext = ""

module.db.encounter_time_p = {}	--phases
module.db.encounter_time_c = {}	--custom
module.db.encounter_time_wa_uids = {}	--wa custom events
module.db.encounter_id = {}

local encounter_time_p = module.db.encounter_time_p
local encounter_time_c = module.db.encounter_time_c
local encounter_time_wa_uids = module.db.encounter_time_wa_uids
local encounter_id = module.db.encounter_id

local function GSUB_Icon(spellID)
	spellID = tonumber(spellID)

	local spellTexture = select(3,GetSpellInfo(spellID))
	spellTexture = "|T"..(spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK")..":16|t"

	return spellTexture
end

local function GSUB_Player(anti,list,msg)
	list = {strsplit(",",list)}
	local found = false
	local myName = (ExRT.SDB.charName):lower()
	for i=1,#list do
		list[i] = list[i]:gsub("|c........",""):gsub("|r",""):lower()
		if strsplit("-",list[i]) == myName then
			found = true
			break
		end
	end

	if (found and anti == "") or (not found and anti == "!") then
		return msg
	else
		return ""
	end
end

local function GSUB_Encounter(list,msg)
	list = {strsplit(",",list)}
	local found = false
	for i=1,#list do
		list[i] = list[i]:gsub("|c........",""):gsub("|r",""):lower()
		if encounter_id[ list[i] ] then
			found = true
			break
		end
	end

	if found then
		return msg
	else
		return ""
	end
end

local classList = {
	[L.classLocalizate.WARRIOR:lower()] = 1,
	[L.classLocalizate.PALADIN:lower()] = 2,
	[L.classLocalizate.HUNTER:lower()] = 3,
	[L.classLocalizate.ROGUE:lower()] = 4,
	[L.classLocalizate.PRIEST:lower()] = 5,
	[L.classLocalizate.DEATHKNIGHT:lower()] = 6,
	[L.classLocalizate.SHAMAN:lower()] = 7,
	[L.classLocalizate.MAGE:lower()] = 8,
	[L.classLocalizate.WARLOCK:lower()] = 9,
	[L.classLocalizate.MONK:lower()] = 10,
	[L.classLocalizate.DRUID:lower()] = 11,
	[L.classLocalizate.DEMONHUNTER:lower()] = 12,
	["warrior"] = 1,
	["paladin"] = 2,
	["hunter"] = 3,
	["rogue"] = 4,
	["priest"] = 5,
	["deathknight"] = 6,
	["shaman"] = 7,
	["mage"] = 8,
	["warlock"] = 9,
	["monk"] = 10,
	["druid"] = 11,
	["demonhunter"] = 12,
	["war"] = 1,
	["pal"] = 2,
	["hun"] = 3,
	["rog"] = 4,
	["pri"] = 5,
	["dk"] = 6,
	["sham"] = 7,
	["lock"] = 9,
	["dru"] = 11,
	["dh"] = 12,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 7,
	["9"] = 9,
	["10"] = 10,
	["11"] = 11,
	["12"] = 12,
}

local function GSUB_Class(anti,list,msg)
	list = {strsplit(",",list)}
	local myClassIndex = select(3,UnitClass("player"))
	local found = false
	for i=1,#list do
		list[i] = list[i]:gsub("|c........",""):gsub("|r",""):lower()
		if classList[ list[i] ] == myClassIndex then
			found = true
			break
		end
	end

	if (found and anti == "") or (not found and anti == "!") then
		return msg
	else
		return ""
	end
end

local function GSUB_Race(anti,list,msg)
	list = {strsplit(",",list)}
	local myRace = select(2,UnitRace("player")):lower()
	local found = false
	for i=1,#list do
		list[i] = list[i]:gsub("|c........",""):gsub("|r",""):lower()
		if list[i] == myRace then
			found = true
			break
		end
	end

	if (found and anti == "") or (not found and anti == "!") then
		return msg
	else
		return ""
	end
end

local function GSUB_Group(anti,groups,msg)
	local myGroup = 1
	if IsInRaid() then
		for i=1,GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if name == ExRT.SDB.charName then
				myGroup = subgroup
				break
			end
		end
	end
	myGroup = tostring(myGroup)
	local found = groups:find(myGroup)

	if (found and anti == "") or (not found and anti == "!") then
		return msg
	else
		return ""
	end
end

--[[
formats:
{time:75}
{time:1:15}
{time:2:30,p2}	--start on phase 2, works only with bigwigs
{time:0:30,SCC:17:2}	--start on combat log event. format "event:spellID:counter", events: SCC (SPELL_CAST_SUCCESS), SCS (SPELL_CAST_START), SAA (SPELL_AURA_APPLIED), SAR (SPELL_AURA_REMOVED)
{time:0:30,e,customevent}	--start on ExRT.F.Note_Timer(customevent) function or "/rt note starttimer customevent" 
{time:2:30,wa:nzoth_hs1}	--run weakauras custom event EXRT_NOTE_TIME_EVENT with arg1 = nzoth_hs1, arg2 = time left (event runs every second when timer has 5 seconds or lower), arg3 = note line text
]]
local function GSUB_Time(t,msg)
	local lineTime
	if string_find(t,":") then
		lineTime = tonumber(string_match(t,"(%d+):") or "0",nil) * 60 + tonumber(string_match(t,":(%d+)") or "0",nil)
	else
		lineTime = tonumber(string_match(t,"^(%d+)") or "0",nil)
	end

	local phase = string_match(t,",p(%d+)")

	if not module.db.encounter_time then
		return "|cffffed88"..(phase and "P"..phase.." " or "")..format("%d:%02d|r ",floor(lineTime/60),lineTime % 60)..msg.."\n"
	end

	local currTime = GetTime() - module.db.encounter_time

	local wa_event_uid = string_match(t,",[wW][aA]:([^,]+)")

	local CLEU = string_match(t,",(S[^,}]+)")
	if CLEU then
		t = module.db.encounter_counters_time[CLEU]
		if t then
			currTime = GetTime() - t
		else
			return "|cffffed88"..format("%d:%02d|r ",floor(lineTime/60),lineTime % 60)..msg.."\n"
		end
	end

	local phaseText = ""
	if phase then
		t = encounter_time_p[tonumber(phase)]
		if not t then
			return "|cffffed88"..format("P%s %d:%02d|r ",phase,floor(lineTime/60),lineTime % 60)..msg.."\n"
		end
		currTime = GetTime() - t

		phaseText = "P"..phase.." "
	end

	if type(t)=='string' then
		local custom_event = string_match(t,",e,(.+)")
		if custom_event then
			t = encounter_time_c[custom_event]
			if not t then
				return "|cffffed88"..format("%d:%02d|r ",floor(lineTime/60),lineTime % 60)..msg.."\n"
			end
			currTime = GetTime() - t
		end
	end

	if (currTime >= lineTime or lineTime - currTime <= 20) and wa_event_uid and type(WeakAuras)=="table" then
		local timeleft = currTime >= lineTime and 0 or ceil(lineTime - currTime)
		if timeleft <= 5 or timeleft % 5 == 0 then
			local wa_event_uid_cache = timeleft..":"..wa_event_uid
			if not encounter_time_wa_uids[wa_event_uid_cache] then
				encounter_time_wa_uids[wa_event_uid_cache] = true
				if WeakAuras.ScanEvents and type(WeakAuras.ScanEvents)=="function" then
					WeakAuras.ScanEvents("EXRT_NOTE_TIME_EVENT",wa_event_uid,timeleft,msg)
				end
			end
		end
	end

	if currTime >= lineTime then
		return "|cff555555"..msg:gsub("|c........",""):gsub("|r","").."|r\n"
	elseif lineTime - currTime <= 10 then
		t = lineTime - currTime
		return "|cff00ff00"..phaseText..format("%d:%02d ",floor(t/60),t % 60)..msg:gsub("|c........",""):gsub("|r",""):gsub(ExRT.SDB.charName,"|r|cffff0000>%1<|r|cff00ff00").."|r\n"
	else
		t = lineTime - currTime
		return "|cffffed88"..phaseText..format("%d:%02d|r ",floor(t/60),t % 60)..msg.."\n"
	end
end

local function GSUB_Phase(anti,phase,msg)
	if not module.db.encounter_time then
		return msg
	else
		local isPhase = encounter_time_p[tonumber(phase)]
		if (isPhase and anti == "") or (not isPhase and anti == "!") then
			return msg
		else
			return ""
		end
	end
end

local function txtWithIcons(t)
	t = t or ""

	if not t:find("{self}") then
		t = t..(t~="" and t~=" " and "\n" or "").."{self}"
	end
	t = string_gsub(t,"{self}",VExRT.Note.SelfText or "")

	t = string_gsub(t,"{[Ee]:([^}]+)}(.-){/[Ee]}",GSUB_Encounter)

	for i=1,8 do
		t = string_gsub(t,module.db.iconsLocalizatedNames[i],module.db.iconsList[i])
		t = string_gsub(t,"{rt"..i.."}",module.db.iconsList[i])
		for _,lang in pairs(iconsLangs) do
			t = string_gsub(t,module.db["icons"..lang.."Names"][i],module.db.iconsList[i])
		end
	end
	t = string_gsub(t,"||c","|c")
	t = string_gsub(t,"||r","|r")
	for i=1,#module.db.otherIconsList do
		t = string_gsub(t,module.db.otherIconsList[i][1],module.db.otherIconsList[i][2])
	end
	t = string_gsub(t,"{icon:([^}]+)}","|T%1:16|t")

	t = string_gsub(t,"{spell:(%d+)}",GSUB_Icon)

	local isHealer,isDD,isTank = false,false,false
	local spec = GetSpecialization()
	if spec then
		local role = select(5,GetSpecializationInfo(spec))
		if role == "HEALER" then isHealer = true end
		if role == "TANK" then isTank = true end
		if role == "DAMAGER" then isDD = true end
	end
	if not isHealer then t = string_gsub(t,"{[Hh]}.-{/[Hh]}","") end
	if not isTank then t = string_gsub(t,"{[Tt]}.-{/[Tt]}","") end
	if not isDD then t = string_gsub(t,"{[Dd]}.-{/[Dd]}","") end
	t = string_gsub(t,"{0}.-{/0}","")

	t = string_gsub(t,"(\n{!?[CcPpGg]:?[^}]+})\n","%1")
	t = string_gsub(t,"\n({/[CcPpGg]}\n)","%1")

	t = string_gsub(t,"{(!?)[Pp]:([^}]+)}(.-){/[Pp]}",GSUB_Player)

	t = string_gsub(t,"{(!?)[Pp](%d+)}(.-){/[Pp]}",GSUB_Phase)

	t = string_gsub(t,"{(!?)[Cc]:([^}]+)}(.-){/[Cc]}",GSUB_Class)

	t = string_gsub(t,"{(!?)[Gg](%d+)}(.-){/[Gg]}",GSUB_Group)

	t = string_gsub(t,"{(!?)[Rr][Aa][Cc][Ee]:([^}]+)}(.-){/[Rr][Aa][Cc][Ee]}",GSUB_Race)

	t = string_gsub(t.."\n","{time:([0-9:]+[^{}]*)}(.-)\n",GSUB_Time)

	t = string_gsub(t,"%b{}","")

	t = string_gsub(t, "\n+$", "")

	return t
end

function module.options:Load()
	self:CreateTilte()

	module.db.otherIconsAdditionalList = ExRT.isClassic and {} or {
		31821,62618,97462,98008,115310,64843,740,265202,108280,31884,196718,15286,64901,47536,246287,33891,16191,0,
		47788,33206,6940,102342,114030,1022,116849,633,204018,207399,0,
		2825,32182,80353,0,
		106898,192077,46968,119381,179057,192058,30283,0,
		29166,32375,114018,108199,49576,0,
		0,
		341489,328897,344111,343365,340324,342923,328857,328921,340047,343005,342863,341684,330711,342074,0,
		334757,338609,335114,334797,334960,334852,334860,334504,334884,334404,334893,334971,334708,338615,343259,334695,339639,338593,335303,0,
		333145,337865,325442,328248,325590,325877,341308,335581,328885,329561,325665,328731,329509,335598,326430,341473,326078,333002,328254,329539,336398,326455,329470,323402,339251,326456,328579,343026,325440,0,
		329770,340533,325361,340860,325399,328437,340870,328880,327414,329458,327887,326271,340842,0,
		329455,329774,329298,334522,334755,338614,329742,332375,332294,332295,0,
		325225,331844,331573,325908,331527,325769,325382,326538,325384,342287,325718,331550,325184,341746,324983,342320,335322,325596,341590,329618,0,
		327503,331634,330968,328334,328497,330978,342859,342852,331708,334909,334948,330965,335778,330964,327773,342847,327475,330967,327619,337110,0,
		335354,335300,340803,331209,332318,332443,341294,331212,332197,341102,341482,335297,341250,332969,339189,332687,335361,335295,332572,0,
		334765,333913,344740,342733,334929,333387,343881,336212,332683,339728,343086,343898,339690,344655,342425,342256,336231,342985,339645,343063,340038,334771,342741,332412,339693,339885,329636,342253,0,
		332734,341366,338689,330137,344313,338738,330627,330580,338582,326707,327227,327842,335875,329906,326851,332585,344776,327089,332797,328098,340685,332619,326823,338683,338510,327123,326824,330871,329974,341391,326699,338685,328936,336008,335873,329785,327992,328839,328276,338687,336162,327796,0,
		0,
		307013,313175,306735,311362,306015,314347,308682,305978,307017,306289,306111,306824,314373,312490,306794,313250,312266,307053,307974,0,
		314992,306005,306387,308872,305722,309315,307399,308903,314337,306301,307805,307839,308158,305663,308044,305675,0,
		313210,307784,309652,307785,307864,313208,309687,307445,313239,309657,307937,312741,307977,0,
		305575,311551,314298,311383,316211,306495,313264,306228,314202,312406,314300,309654,313198,305792,306876,314179,0,
		313460,313461,313129,307968,307201,310402,307217,307202,307582,307637,313676,313692,307227,313652,307232,315311,307569,308166,307213,307334,313441,0,
		312530,312329,311849,307471,308177,307472,312099,312332,314736,306932,306692,312528,307358,307945,312529,306934,312328,306942,306448,0,
		310329,310361,310563,310478,310246,308953,310078,315712,308373,310584,308947,310288,310358,308661,310567,308956,308995,317001,310406,310614,310552,0,
		310319,310788,314396,275269,318383,314502,309961,318396,316813,311143,310322,312486,311401,0,
		317157,315933,307177,307371,307317,310325,307729,307218,307639,307284,310311,306878,307421,307359,307057,315931,307297,307019,315769,315932,307343,0,
		306733,306865,306819,312996,306184,306874,306634,306115,313114,312750,306279,309852,316065,309985,309755,306257,313395,310003,306866,313109,313398,309777,306168,306090,306732,313399,313227,306881,314484,0,
		312158,316847,317165,307044,313322,313330,317627,307340,307131,317896,306984,307079,307008,307058,316701,312333,313364,307048,307831,307092,313334,311980,307832,316307,307042,315947,307306,306973,315954,0,
		309991,318449,318969,315772,310134,315710,318688,317066,310042,318768,309713,313793,313195,313400,312078,317292,309592,313955,310333,316271,313610,312873,308996,313184,313609,315709,308997,318896,311176,309990,316711,317874,314889,312155,0,
	}

	function self:DebugGetIcons(notUseJJBox)
		local L,U,F,C,P
		function F(eID)
			local f=select(4,EJ_GetEncounterInfoByIndex(eID))
			repeat 
				local I=C_EncounterJournal.GetSectionInfo(f)
				local O=I and (I.headerType == 3)
				if O then 
					f=I.siblingSectionID 
				end 
			until not O 
			return f 
		end
		function C(f) 
			local I=C_EncounterJournal.GetSectionInfo(f) 
			if I.firstChildSectionID then 
				C(I.firstChildSectionID)
			end 
			if I.spellID and I.spellID~=0 and P(I.spellID) then 
				L[I.spellID]=true 
			end 
			if I.siblingSectionID then 
				C(I.siblingSectionID) 
			end 
		end
		function P(s)
			local i=GetSpellTexture(s)
			if not U[i] then 
				U[i]=1 
				return true 
			end 
		end 
		local i = 1
		while _G["EncounterJournalBossButton"..i] and _G["EncounterJournalBossButton"..i]:IsShown() do
			L,U={},{} 
			local f=F(i) 
			C(f)
			local s="" 
			for q,w in pairs(L)do 
				s=s..q.."," 
			end 
			print(s..'0,')
			if not notUseJJBox then
				JJBox(s..'0,') 
			else
				RES = (RES or "")..s.."0,\n"
			end
			i = i + 1
		end
	end
	--/run GExRT.A.Note.options:DebugGetIcons()

	module.db.encountersList = ExRT.isClassic and {} or {
		{1735,2398,2418,2402,2383,2405,2406,2412,2399,2417,2407},
		{EXPANSION_NAME8..": "..DUNGEONS,-1182,-1183,-1184,-1185,-1186,-1187,-1188,-1189},
		{1582,2329,2327,2334,2328,2336,2333,2331,2335,2343,2345,2337,2344}, 
		{1512,2298,2305,2289,2304,2303,2311,2293,2299},
		{L.S_ZoneT23Storms,2269,2273},
		{1358,2265,2263,2284,2266,2285,2271,2268,2272,2276,2280,2281},
		{1148,2144,2141,2136,2134,2128,2145,2135,2122},
		{EXPANSION_NAME7..": "..DUNGEONS,-1012,-968,-1041,-1022,-1030,-1023,-1002,-1001,-1036,-1021},
		{909,2076,2074,2064,2070,2075,2082,2069,2088,2073,2063,2092},
		{850,2032,2048,2036,2037,2050,2054,2052,2038,2051},
		{764,1849,1865,1867,1871,1862,1886,1842,1863,1872,1866},
	}

	module.db.mapToEncounter = {
		--BfD
		[1358] = {2265,2263,2266},
		[1352] = {2276,2280},
		[1353] = 2271,
		[1354] = 2268,
		[1357] = 2272,
		[1364] = 2281,

		--Uldir
		[1148] = 2144,
		[1149] = 2141,
		[1151] = 2136,
		[1153] = 2128,
		[1152] = 2134,
		[1154] = {2145,2135},
		[1155] = 2122,

		--5ppl
		[1010] = -1012,
		[934] = -968,	[935] = -968,
		[1004] = -1041,
		[1041] = -1022,	[1042] = -1022,
		[1038] = -1030,	[1043] = -1030,

		[1162] = -1023,
		[974] = -1002,	[975] = -1002,	[974] = -1002,	[975] = -1002,	[976] = -1002,	[977] = -1002,	[978] = -1002,	[979] = -1002,	[980] = -1002,
		[936] = -1001,
		[1039] = -1036,	[1040] = -1036,
		[1015] = -1021,	[1016] = -1021,	[1017] = -1021,	[1018] = -1021,	[1029] = -1021,

		--nyalotha
		[1581] = {2329,2327,2334},
		[1592] = 2328,
		[1593] = 2336,
		[1590] = 2333,
		[1591] = 2331,
		[1594] = 2335,
		[1595] = 2343,
		[1596] = 2345,
		[1597] = {2337,2344},

		--5ppl
		[1666] = -1182,	[1667] = -1182,	[1668] = -1182,
		[1674] = -1183,	[1697] = -1183,
		[1669] = -1184,
		[1663] = -1185,	[1664] = -1185,	[1665] = -1185,
		[1693] = -1186,	[1694] = -1186,	[1695] = -1186,
		[1683] = -1187,	[1684] = -1187,	[1685] = -1187,	[1687] = -1187,
		[1677] = -1188,	[1678] = -1188,	[1679] = -1188,	[1680] = -1188,
		[1675] = -1189,	[1676] = -1189,

		--nathria
		[1735] = {2398,2418,2383,2399},
		[1744] = 2406,
		[1745] = 2405,
		[1746] = 2402,
		[1747] = {2417,2407},
		[1748] = 2407,
		[1750] = 2412,
	}


	function self:GetBossName(bossID)
		return bossID < 0 and L.EJInstanceName[ -bossID ] or L.bossName[ bossID ]
	end

	local BlackNoteNow = nil
	local NoteIsSelfNow = nil
	self.IsMainNoteNow = true

	self.decorationLine = ELib:DecorationLine(self,true,"BACKGROUND",-5):Point("TOPLEFT",self,0,-16):Point("BOTTOMRIGHT",self,"TOPRIGHT",0,-36)

	self.tab = ELib:Tabs(self,0,L.message,L.minimapmenuset,HELP_LABEL):Point(0,-36):Size(850,598):SetTo(1)
	self.tab:SetBackdropBorderColor(0,0,0,0)
	self.tab:SetBackdropColor(0,0,0,0)

	self.tab.tabs[1]:SetPoint("TOPLEFT",0,20)

	ELib:DecorationLine(self.tab.tabs[1]):Point("TOPLEFT",0,-129):Point("BOTTOMRIGHT",'x',"TOPRIGHT",0,-130)

	self.NotesList = ELib:ScrollList(self.tab.tabs[1]):Size(230,467+20):Point(0,-131):AddDrag():HideBorders()
	self.NotesList.selected = 1
	self.NotesList.LINE_PADDING_LEFT = 2
	self.NotesList.SCROLL_WIDTH = 12

	self.NotesList.Frame.ScrollBar:Size(10,0):Point("TOPRIGHT",0,0):Point("BOTTOMRIGHT",0,0)
	self.NotesList.Frame.ScrollBar.buttonUP:HideBorders()
	self.NotesList.Frame.ScrollBar.buttonDown:HideBorders()

	ELib:DecorationLine(self.NotesList.Frame.ScrollBar):Point("TOPLEFT",-1,1):Point("BOTTOMRIGHT",'x',"BOTTOMLEFT",0,0)
	ELib:DecorationLine(self.tab.tabs[1]):Point("TOPLEFT",self.NotesList,"TOPRIGHT",0,1):Point("BOTTOMLEFT",self,"BOTTOM",0,0):Size(1,0)

	local function SwapBlackNotes(noteFrom,noteTo)
		if noteTo < 1 or noteFrom < 1 or noteTo > #VExRT.Note.Black or noteFrom > #VExRT.Note.Black or not VExRT.Note.Black[noteTo] or not VExRT.Note.Black[noteFrom] then
			return
		end
		local text = VExRT.Note.Black[noteTo]
		local title = VExRT.Note.BlackNames[noteTo]
		local boss = VExRT.Note.AutoLoad[noteTo]
		local lastUpdateName = VExRT.Note.BlackLastUpdateName[noteTo]
		local lastUpdateTime = VExRT.Note.BlackLastUpdateTime[noteTo]

		VExRT.Note.Black[noteTo] = VExRT.Note.Black[noteFrom]
		VExRT.Note.BlackNames[noteTo] = VExRT.Note.BlackNames[noteFrom]
		VExRT.Note.AutoLoad[noteTo] = VExRT.Note.AutoLoad[noteFrom]
		VExRT.Note.BlackLastUpdateName[noteTo] = VExRT.Note.BlackLastUpdateName[noteFrom]
		VExRT.Note.BlackLastUpdateTime[noteTo] = VExRT.Note.BlackLastUpdateTime[noteFrom]

		VExRT.Note.Black[noteFrom] = text
		VExRT.Note.BlackNames[noteFrom] = title
		VExRT.Note.AutoLoad[noteFrom] = boss
		VExRT.Note.BlackLastUpdateName[noteFrom] = lastUpdateName
		VExRT.Note.BlackLastUpdateTime[noteFrom] = lastUpdateTime

		module.options:NotesListUpdateNames()
		module.options.NotesList.selected = noteTo + 2
		module.options.NotesList:Update()
	end

	self.NotesList.ButtonMoveUp = CreateFrame("Button",nil,self.NotesList)
	self.NotesList.ButtonMoveUp:Hide()
	self.NotesList.ButtonMoveUp:SetSize(8,8)
	self.NotesList.ButtonMoveUp:SetScript("OnClick",function(self)
		SwapBlackNotes(self.index,self.index - 1)
	end)
	self.NotesList.ButtonMoveUp.i = self.NotesList.ButtonMoveUp:CreateTexture()
	self.NotesList.ButtonMoveUp.i:SetPoint("CENTER")
	self.NotesList.ButtonMoveUp.i:SetSize(16,16)
	self.NotesList.ButtonMoveUp.i:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	self.NotesList.ButtonMoveUp.i:SetTexCoord(0.25,0.3125,0.625,0.5)

	self.NotesList.ButtonMoveDown = CreateFrame("Button",nil,self.NotesList)
	self.NotesList.ButtonMoveDown:Hide()
	self.NotesList.ButtonMoveDown:SetSize(8,8)
	self.NotesList.ButtonMoveDown:SetScript("OnClick",function(self)
		SwapBlackNotes(self.index,self.index + 1)
	end)
	self.NotesList.ButtonMoveDown.i = self.NotesList.ButtonMoveDown:CreateTexture()
	self.NotesList.ButtonMoveDown.i:SetPoint("CENTER")
	self.NotesList.ButtonMoveDown.i:SetSize(16,16)
	self.NotesList.ButtonMoveDown.i:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	self.NotesList.ButtonMoveDown.i:SetTexCoord(0.25,0.3125,0.5,0.625)


	self.NotesList.UpdateAdditional = function(self,val)
		self.ButtonMoveUp:Hide()
		self.ButtonMoveDown:Hide()
		for i=1,#self.List do
			local line = self.List[i]
			if line.index == 1 or line.index == 2 or line.index == #self.L or line.index == self.selected then
				line.ignoreDrag = true
			else
				line.ignoreDrag = false
			end
		end
		for i=1,#self.List-1 do
			if self.selected == self.List[i].index then
				self.ButtonMoveUp:SetPoint("BOTTOMRIGHT",self.List[i],"RIGHT",-2,0)
				self.ButtonMoveDown:SetPoint("TOPRIGHT",self.List[i],"RIGHT",-2,0)
				self.ButtonMoveUp:SetParent(self.List[i])
				self.ButtonMoveDown:SetParent(self.List[i])
				self.ButtonMoveUp.index = self.List[i].index - 2
				self.ButtonMoveDown.index = self.List[i].index - 2
				if i > 3 then
					self.ButtonMoveUp:Show()
				end
				if i >= 3 and i <= #self.List-2 then
					self.ButtonMoveDown:Show()
				end
				return
			end
		end
	end

	local function NotesListUpdateNames()
		local bossesToGreen = {}
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID and module.db.mapToEncounter[mapID] then
			local encounters = module.db.mapToEncounter[mapID]
			if type(encounters) == 'table' then
				for i=1,#encounters do
					bossesToGreen[ encounters[i] ] = true
				end
			else
				bossesToGreen[encounters] = true
			end
		end
		self.NotesList.L = {}

		self.NotesList.L[1] = "|cff55ee55"..L.messageTab1
		self.NotesList.L[2] = L.NoteSelf
		for i=1,#VExRT.Note.Black do
			self.NotesList.L[i+2] = (VExRT.Note.AutoLoad[i] and (bossesToGreen[ VExRT.Note.AutoLoad[i] ] and "|cff00ff00" or "|cffffff00").."["..module.options:GetBossName(VExRT.Note.AutoLoad[i]).."]|r" or "")..(VExRT.Note.BlackNames[i] or i)
		end
		self.NotesList.L[#self.NotesList.L + 1] = "|cff00aaff"..L.NoteAdd
		self.NotesList:Update()
	end
	NotesListUpdateNames()
	self.NotesListUpdateNames = NotesListUpdateNames

	local function UpdatePageAfterGettingNote()
		if NoteIsSelfNow then
			self.NotesList:SetListValue(2)
		elseif BlackNoteNow then
			self.NotesList:SetListValue(BlackNoteNow + 2)
		else
			self.NotesList:SetListValue(1)
		end
	end
	self.UpdatePageAfterGettingNote = UpdatePageAfterGettingNote

	module.options.LastIndex = 1
	function self.NotesList:SetListValue(index)
		module.options.LastIndex = index

		module.options.buttonsend:SetShown(index == 1)
		module.options.buttoncopy:SetShown(index > 2)

		BlackNoteNow = nil
		NoteIsSelfNow = nil
		module.options.IsMainNoteNow = nil

		if index == 1 then
			module.options.DraftName:Enable()
			module.options.RemoveDraft:Disable()
			module.options.autoLoadDropdown:Enable()
		elseif index > 2 then
			module.options.DraftName:Enable()
			module.options.RemoveDraft:Enable()
			module.options.autoLoadDropdown:Enable()
		else
			module.options.DraftName:Disable()
			module.options.RemoveDraft:Disable()
			module.options.autoLoadDropdown:Disable()
		end

		if index == 1 then
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Text1 or "")
			--module.options.DraftName:SetText( L.messageTab1 )

			module.options.IsMainNoteNow = true

			module.options.DraftName:SetText( VExRT.Note.DefName or "" )

			module.options.autoLoadDropdown:SetText(VExRT.Note.AutoLoad[0] and module.options:GetBossName(VExRT.Note.AutoLoad[0]) or "-")
		elseif index == 2 then
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.SelfText or "")
			module.options.DraftName:SetText( L.NoteSelf )

			module.options.autoLoadDropdown:SetText("-")

			NoteIsSelfNow = true
		elseif index == #self.L then
			VExRT.Note.Black[#VExRT.Note.Black + 1] = ""
			tinsert(self.L,#self.L - 1,#VExRT.Note.Black)
			module.options.NoteEditBox.EditBox:SetText("")
			self:Update()

			BlackNoteNow = #VExRT.Note.Black
			module.options.DraftName:SetText( "" )

			NotesListUpdateNames()

			module.options.autoLoadDropdown:SetText("-")
		else
			index = index - 2
			if IsShiftKeyDown() then
				VExRT.Note.Black[index] = VExRT.Note.Text1
			end
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Black[index] or "")

			BlackNoteNow = index
			module.options.DraftName:SetText( VExRT.Note.BlackNames[index] or "" )

			module.options.autoLoadDropdown:SetText(VExRT.Note.AutoLoad[index] and module.options:GetBossName(VExRT.Note.AutoLoad[index]) or "-")
		end
	end

	self.NotesList:SetScript("OnShow",function(self)
		NotesListUpdateNames()
	end)

	function self.NotesList:HoverListValue(isHover,index)
		if not isHover then
			GameTooltip_Hide()
		else
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			GameTooltip:AddLine(self.L[index])
			if index == 2 then
				GameTooltip:AddLine(L.NoteSelfTooltip)
			elseif index ~= #self.L and index > 2 then
				local i = index - 2
				if VExRT.Note.BlackLastUpdateName[i] then
					GameTooltip:AddLine(L.NoteLastUpdate..": "..VExRT.Note.BlackLastUpdateName[i].." ("..date("%d.%m.%Y %H:%M",VExRT.Note.BlackLastUpdateTime[i] or 0)..")")
				end
				--GameTooltip:AddLine(L.NoteTabCopyTooltip)
			end
			GameTooltip:Show()
		end
	end

	function self.NotesList:OnDragFunction(obj1,obj2)
		local index1,index2 = obj1.index,obj2.index

		if index2 < 3 or index2 >= #self.L then
			return
		end
		index1,index2 = index1 - 2,index2 - 2

		local tmpBlack = VExRT.Note.Black[index1]
		local tmpBlackNames = VExRT.Note.BlackNames[index1]
		local tmpAutoLoad = VExRT.Note.AutoLoad[index1]
		local tmpBlackLastUpdateName = VExRT.Note.BlackLastUpdateName[index1]
		local tmpBlackLastUpdateTime = VExRT.Note.BlackLastUpdateTime[index1]
		if index1 < index2 then
			for i=index1,index2-1 do
				VExRT.Note.Black[i] = VExRT.Note.Black[i + 1]
				VExRT.Note.BlackNames[i] = VExRT.Note.BlackNames[i + 1]
				VExRT.Note.AutoLoad[i] = VExRT.Note.AutoLoad[i + 1]
				VExRT.Note.BlackLastUpdateName[i] = VExRT.Note.BlackLastUpdateName[i + 1]
				VExRT.Note.BlackLastUpdateTime[i] = VExRT.Note.BlackLastUpdateTime[i + 1]
			end
		else
			for i=index1,index2+1,-1 do
				VExRT.Note.Black[i] = VExRT.Note.Black[i - 1]
				VExRT.Note.BlackNames[i] = VExRT.Note.BlackNames[i - 1]
				VExRT.Note.AutoLoad[i] = VExRT.Note.AutoLoad[i - 1]
				VExRT.Note.BlackLastUpdateName[i] = VExRT.Note.BlackLastUpdateName[i - 1]
				VExRT.Note.BlackLastUpdateTime[i] = VExRT.Note.BlackLastUpdateTime[i - 1]
			end
		end
		VExRT.Note.Black[index2] = tmpBlack
		VExRT.Note.BlackNames[index2] = tmpBlackNames
		VExRT.Note.AutoLoad[index2] = tmpAutoLoad
		VExRT.Note.BlackLastUpdateName[index2] = tmpBlackLastUpdateName
		VExRT.Note.BlackLastUpdateTime[index2] = tmpBlackLastUpdateTime

		NotesListUpdateNames()
	end

	self.DuplicateDraft = ELib:Button(self.tab.tabs[1],L.NoteDuplicate):Size(120,19):Point("RIGHT",0,0):Point("TOP",self.NotesList,0,1):OnClick(function (self)
		local pos = #VExRT.Note.Black + 1

		local text = module.options.LastIndex == 1 and (VExRT.Note.Text1 or "") or
				module.options.LastIndex == 2 and (VExRT.Note.SelfText or "") or
				(VExRT.Note.Black[module.options.LastIndex - 2] or "")
		local title = (module.options.LastIndex > 2 and VExRT.Note.BlackNames[module.options.LastIndex - 2]) or 
				(module.options.LastIndex == 1 and VExRT.Note.DefName)
		if not title then title = nil end

		local boss = module.options.LastIndex == 1 and VExRT.Note.AutoLoad[0] or
				module.options.LastIndex > 2 and VExRT.Note.AutoLoad[module.options.LastIndex - 2]
		if not boss then boss = nil end

		local lastUpdateName = module.options.LastIndex > 2 and VExRT.Note.BlackLastUpdateName[module.options.LastIndex - 2]
		if not lastUpdateName then lastUpdateName = nil end

		local lastUpdateTime = module.options.LastIndex > 2 and VExRT.Note.BlackLastUpdateTime[module.options.LastIndex - 2]
		if not lastUpdateTime then lastUpdateTime = nil end

		VExRT.Note.Black[pos] = text
		VExRT.Note.BlackNames[pos] = title
		VExRT.Note.AutoLoad[pos] = boss
		VExRT.Note.BlackLastUpdateName[pos] = lastUpdateName
		VExRT.Note.BlackLastUpdateTime[pos] = lastUpdateTime

		NotesListUpdateNames()
		module.options.NotesList:SetListValue(pos+2)
		module.options.NotesList.selected = pos+2
		module.options.NotesList:Update()
	end)
	self.DuplicateDraft:HideBorders()

	self.RemoveDraft = ELib:Button(self.tab.tabs[1],L.NoteRemove):Size(120,19):Point("RIGHT",self.DuplicateDraft,"LEFT",-5,0):Point("TOP",self.NotesList,0,1):Disable():OnClick(function (self)
		if not BlackNoteNow then
			return
		end
		local size = #VExRT.Note.Black
		for i=BlackNoteNow,size do
			if i < size then
				VExRT.Note.Black[i] = VExRT.Note.Black[i + 1]
				VExRT.Note.BlackNames[i] = VExRT.Note.BlackNames[i + 1]
				VExRT.Note.AutoLoad[i] = VExRT.Note.AutoLoad[i + 1]
				VExRT.Note.BlackLastUpdateName[i] = VExRT.Note.BlackLastUpdateName[i + 1]
				VExRT.Note.BlackLastUpdateTime[i] = VExRT.Note.BlackLastUpdateTime[i + 1]
			else
				VExRT.Note.Black[i] = nil
				VExRT.Note.BlackNames[i] = nil
				VExRT.Note.AutoLoad[i] = nil
				VExRT.Note.BlackLastUpdateName[i] = nil
				VExRT.Note.BlackLastUpdateTime[i] = nil
			end
		end
		NotesListUpdateNames()
		if BlackNoteNow == (#module.options.NotesList.L - 2) then
			BlackNoteNow = BlackNoteNow - 1
		end
		module.options.NotesList:SetListValue(2+BlackNoteNow)
		module.options.NotesList.selected = 2+BlackNoteNow
		module.options.NotesList:Update()
	end)
	self.RemoveDraft:HideBorders()

	self.DraftName = ELib:Edit(self.tab.tabs[1]):Size(0,18):Tooltip(L.NoteDraftName):Text(VExRT.Note.DefName or L.messageTab1):Point("TOPLEFT",self.NotesList,"TOPRIGHT",8,0):Point("RIGHT",self.RemoveDraft,"LEFT",-5,0):BackgroundText(L.NoteDraftName):OnChange(function(self,isUser)
		self:BackgroundTextCheck()
		if not isUser then return end
		if BlackNoteNow then
			VExRT.Note.BlackNames[ BlackNoteNow ] = self:GetText()
			NotesListUpdateNames()
		elseif not BlackNoteNow and not NoteIsSelfNow then
			VExRT.Note.DefName = self:GetText()
		end
	end)
	self.DraftName:SetBackdropColor(0, 0, 0, 0) 
	self.DraftName:SetBackdropBorderColor(0, 0, 0, 0)
	self.DraftName:HideBorders()

	ELib:DecorationLine(self.tab.tabs[1]):Point("TOP",0,-129-20):Point("LEFT",self.NotesList,"RIGHT",0,0):Point("RIGHT",'x',0,0):Size(0,1)

	local function autoLoadDropdown_SetValue(self,encounterID)
		local index = BlackNoteNow or 0

		VExRT.Note.AutoLoad[index] = encounterID

		module.options.autoLoadDropdown:SetText(encounterID and module.options:GetBossName(encounterID) or "-")
		NotesListUpdateNames()
		ELib:DropDownClose()
	end

	self.autoLoadDropdown = ELib:DropDown(self.tab.tabs[1],550,25):AddText(ENCOUNTER_JOURNAL_ENCOUNTER..":"):Point("TOPRIGHT",self.DuplicateDraft,"BOTTOMRIGHT",-2,-1):Size(550):SetText(VExRT.Note.AutoLoad[0] and L.bossName[ VExRT.Note.AutoLoad[0] ] or "-")
	do
		local List = self.autoLoadDropdown.List
		List[#List+1] = {
			text = NO,
			func = autoLoadDropdown_SetValue,
		}
		for i=1,#module.db.encountersList do
			local instance = module.db.encountersList[i]
			List[#List+1] = {
				text = type(instance[1])=='string' and instance[1] or (C_Map.GetMapInfo(instance[1] or 0) or {}).name or "???",
				isTitle = true,
			}
			for j=2,#instance do
				List[#List+1] = {
					text = module.options:GetBossName(instance[j]),
					arg1 = instance[j],
					func = autoLoadDropdown_SetValue,
				}
			end
		end
	end
	self.autoLoadDropdown:HideBorders()
	self.autoLoadDropdown.Background:Hide()
	self.autoLoadDropdown.Background:SetPoint("BOTTOMRIGHT",0,1)
	self.autoLoadDropdown.Background:SetColorTexture(1,1,1,.3)
	self.autoLoadDropdown.Text:SetJustifyH("LEFT")
	self.autoLoadDropdown:SetScript("OnMouseDown",function(self)
		self.Button:Click()
	end)
	self.autoLoadDropdown:SetScript("OnEnter",function(self)
		self.Background:Show()
	end)
	self.autoLoadDropdown:SetScript("OnLeave",function(self)
		self.Background:Hide()
	end)
	if ExRT.isClassic then
		self.autoLoadDropdown:Hide()
	end

	ELib:DecorationLine(self.tab.tabs[1]):Point("TOP",0,-129-40):Point("LEFT",self.NotesList,"RIGHT",0,0):Point("RIGHT",'x',0,0):Size(0,1)

	local IsFormattingOn = VExRT.Note.OptionsFormatting
	self.optFormatting = ELib:Check(self.tab.tabs[1],FORMATTING,VExRT.Note.OptionsFormatting):Point("TOPLEFT",self.NotesList,"TOPRIGHT",15,-41):Size(15,15):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.OptionsFormatting = true
		else
			VExRT.Note.OptionsFormatting = nil
		end
		IsFormattingOn = VExRT.Note.OptionsFormatting
		module.options.NotesList:SetListValue(module.options.LastIndex or 1)
	end)  

	--[[
	self.textClear = ELib:Text(self.tab.tabs[1],"["..L.messagebutclear.."]"):Point("TOPLEFT",self.NotesList,"TOPRIGHT",120,-41-1):Color()
	self.textClear:SetShadowColor(1,1,1,0)
	self.textClear:SetShadowOffset(1,-1)
	self.buttonClear = CreateFrame("Button",nil,self.NoteEditBox)
	self.buttonClear:SetAllPoints(self.textClear)
	self.buttonClear:SetScript("OnClick",function()
		module.frame:Clear() 
		module.options.NoteEditBox.EditBox:SetText("")
	end)
	self.buttonClear:SetScript("OnEnter",function()
		self.textClear:SetShadowColor(1,1,1,1)
	end)
	self.buttonClear:SetScript("OnLeave",function()
		self.textClear:SetShadowColor(1,1,1,0)
	end)
	]]

	ELib:DecorationLine(self.tab.tabs[1]):Point("TOP",0,-129-60):Point("LEFT",self.NotesList,"RIGHT",0,0):Point("RIGHT",'x',0,0):Size(0,1)

	self.NoteEditBox = ELib:MultiEdit(self.tab.tabs[1]):Point("TOPLEFT",self.NotesList,"TOPRIGHT",2,-61):Size(616,395)
	ELib:Border(self.NoteEditBox,0)


	self.NoteEditBox.EditBox._SetText = self.NoteEditBox.EditBox.SetText
	function self.NoteEditBox.EditBox:SetText(text)
		if IsFormattingOn then
			text = text:gsub("||([cr])","|%1")
		end
		return self:_SetText(text)
	end


	function self.NoteEditBox.EditBox:OnTextChanged(isUser)
		if not isUser and (not module.options.InsertFix or GetTime() - module.options.InsertFix > 0.1) then
			return
		end
		local text = self:GetText()
		if IsFormattingOn then
			text = text:gsub("|([cr])","||%1")
		end
		if NoteIsSelfNow then
			VExRT.Note.SelfText = text
			module.frame:UpdateText()
		elseif BlackNoteNow then
			VExRT.Note.Black[ BlackNoteNow ] = text

			VExRT.Note.BlackLastUpdateName[BlackNoteNow] = ExRT.SDB.charKey
			VExRT.Note.BlackLastUpdateTime[BlackNoteNow] = time()
		else
			VExRT.Note.Text1 = text
			if module.frame.text:GetText() ~= txtWithIcons(VExRT.Note.Text1) then
				module.options.buttonsend:Anim(true)
			else
				module.options.buttonsend:Anim(false)
			end
		end
	end
	local last_highlight_start,last_highlight_end,last_cursor_pos = 0,0,0
	local IsFormattingOn_Saved
	self.NoteEditBox.EditBox:SetScript("OnKeyDown",function(self,key)
		if IsFormattingOn and key == "LCTRL" then
			module.options.InsertFix = nil
			IsFormattingOn_Saved = true
			IsFormattingOn = nil
			local h_start,h_end = module.options.NoteEditBox:GetTextHighlight()
			local h_cursor = self:GetCursorPosition()
			local text = module.options.NoteEditBox.EditBox:GetText()

			last_highlight_start,last_highlight_end,last_cursor_pos = h_start,h_end,h_cursor

			local c_start,c_end,c_cursor = 0,0,0
			text:sub(1,h_start):gsub("|([cr])",function() c_start = c_start + 1 end)
			text:sub(1,h_end):gsub("|([cr])",function() c_end = c_end + 1 end)
			text:sub(1,h_cursor):gsub("|([cr])",function() c_cursor = c_cursor + 1 end)

			text = text:gsub("|([cr])","||%1")
			module.options.NoteEditBox.EditBox:_SetText(text)

			module.options.NoteEditBox.EditBox:HighlightText( h_start+c_start, h_end+c_end )
			module.options.NoteEditBox.EditBox:SetCursorPosition( h_cursor+c_cursor )
		end
	end)
	self.NoteEditBox.EditBox:SetScript("OnKeyUp",function(self,key)
		if IsFormattingOn_Saved and key == "LCTRL" then
			local text = module.options.NoteEditBox.EditBox:GetText()
			local h_start,h_end = module.options.NoteEditBox:GetTextHighlight()
			local h_cursor = self:GetCursorPosition()
			local c_start,c_end,c_cursor = 0,0,0
			text:sub(1,h_start):gsub("||([cr])",function() c_start = c_start + 1 end)
			text:sub(1,h_end):gsub("||([cr])",function() c_end = c_end + 1 end)
			text:sub(1,h_cursor):gsub("||([cr])",function() c_cursor = c_cursor + 1 end)

			IsFormattingOn = true
			IsFormattingOn_Saved = nil
			module.options.InsertFix = nil
			module.options.NotesList:SetListValue(module.options.LastIndex or 1)
			module.options.NoteEditBox.EditBox:HighlightText( h_start-c_start,h_end-c_end )
			module.options.NoteEditBox.EditBox:SetCursorPosition( h_cursor-c_cursor )
		end
	end)

	self.buttonsend = ELib:Button(self.tab.tabs[1],L.messagebutsend):Size(0,30):Point("LEFT",self.NotesList,"TOPRIGHT",4,0):Point("BOTTOM",self,"BOTTOM",0,2):Point("RIGHT",self,"RIGHT",-2,0):Tooltip(L.messagebutsendtooltip):OnClick(function (self)
		module.frame:Save() 

		if IsShiftKeyDown() then
			local text = VExRT.Note.Text1 or ""
			text = text:gsub("||c........","")
			text = text:gsub("||r","")
			text = text:gsub("||T.-:0||t ","")
			for i=1,8 do
				text = text:gsub(module.db.iconsLocalizatedNames[i],"{rt"..i.."}")
				for _,lang in pairs(iconsLangs) do
					text = text:gsub(module.db["icons"..lang.."Names"][i],"{rt"..i.."}")
				end
			end
			text = text:gsub("%b{}",function(p)
				if p and p:match("^{rt%d}$") then
					return p
				else
					return ""
				end
			end)

			local lines = {strsplit("\n", text)}
			for i=1,#lines do
				if lines[i] ~= "" then
					SendChatMessage(lines[i],(IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or "PARTY")
				end
			end
		end

		module.options.buttonsend:Anim(false)
	end) 

	function self.buttonsend:Anim(on)
		if on then
			self.t = self.t or 0
			self:SetScript("OnUpdate",function(self,elapsed)
				self.t = (self.t + elapsed) % 4

				local c = 0.05 * (self.t > 2 and (4-self.t) or self.t)

				self.Texture:SetGradientAlpha("VERTICAL",0.0+c,0.06+c,0.0+c,1, 0.05+c,0.21+c,0.05+c,1)
			end)
		else
			self:SetScript("OnUpdate",nil)
			self.Texture:SetGradientAlpha("VERTICAL",0.05,0.06,0.09,1, 0.20,0.21,0.25,1)
		end
	end

	self.buttoncopy = ELib:Button(self.tab.tabs[1],L.messageButCopy):Size(0,30):Point("LEFT",self.NotesList,"TOPRIGHT",4,0):Point("BOTTOM",self,"BOTTOM",0,2):Point("RIGHT",self,"RIGHT",-2,0):OnClick(function (self)
		if not BlackNoteNow then
			return
		end
		module.frame:Save(BlackNoteNow) 

		module.options.NotesList:SetListValue(1)

		module.options.NotesList.selected = 1
		module.options.NotesList:Update()
	end) 
	self.buttoncopy:Hide()

	local function AddTextToEditBox(self,text,mypos,noremove)
		local addedText = nil
		if not self then
			addedText = text
		else
			addedText = self.iconText
			if IsShiftKeyDown() then
				addedText = self.iconTextShift
			end
		end
		if not noremove then
			module.options.NoteEditBox.EditBox:Insert("")
		end
		local txt = module.options.NoteEditBox.EditBox:GetText()
		local pos = module.options.NoteEditBox.EditBox:GetCursorPosition()
		if not self and type(mypos)=='number' then
			pos = mypos
		end
		txt = string.sub (txt, 1 , pos) .. addedText .. string.sub (txt, pos+1)
		module.options.InsertFix = GetTime()
		module.options.NoteEditBox.EditBox:SetText(txt)
		local adjust = 0
		if IsFormattingOn then
			addedText:gsub("||",function() adjust = adjust + 1 end)
		end
		module.options.NoteEditBox.EditBox:SetCursorPosition(pos+addedText:len()-adjust)
	end

	self.buttonicons = {}
	for i=1,8 do
		local button = CreateFrame("Button", nil,self.tab.tabs[1])
		self.buttonicons[i] = button
		button:SetSize(18,18)
		button:SetPoint("TOPLEFT", 10+(i-1)*20,-30)
		button.back = button:CreateTexture(nil, "BACKGROUND")
		button.back:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)
		button.back:SetAllPoints()
		button:RegisterForClicks("LeftButtonDown")
		button.iconText = module.db.iconsLocalizatedNames[i]
		button:SetScript("OnClick", AddTextToEditBox)
	end
	for i=1,12 do
		local button = CreateFrame("Button", nil,self.tab.tabs[1])
		self.buttonicons[i] = button
		button:SetSize(18,18)
		button:SetPoint("TOPLEFT", 170+(i-1)*20,-30)
		button.back = button:CreateTexture(nil, "BACKGROUND")
		button.back:SetTexture(module.db.otherIconsList[i][3])
		if module.db.otherIconsList[i][4] then
			button.back:SetTexCoord(unpack(module.db.otherIconsList[i],4,7))
		end
		button.back:SetAllPoints()
		button:RegisterForClicks("LeftButtonDown")
		button.iconText = module.db.otherIconsList[i][1]
		button:SetScript("OnClick", AddTextToEditBox)
	end

	self.OtherIconsButton = ELib:Button(self.tab.tabs[1],L.NoteOtherIcons):Size(120,20):Point("TOPLEFT",self.buttonicons[#self.buttonicons],"TOPRIGHT",5,1):OnClick(function()
		module.options.OtherIconsFrame:ShowClick("TOPRIGHT")
	end)

	self.OtherIconsFrame = ELib:Popup(L.NoteOtherIcons):Size(300,300)
	self.OtherIconsFrame.ScrollFrame = ELib:ScrollFrame(self.OtherIconsFrame):Size(self.OtherIconsFrame:GetWidth()-10,self.OtherIconsFrame:GetHeight()-25):Point("TOP",0,-20):Height(500)

	local function CreateOtherIcon(pointX,pointY,texture,iconText)
		local self = CreateFrame("Button", nil,self.OtherIconsFrame.ScrollFrame.C)
		self:SetSize(18,18)
		self:SetPoint("TOPLEFT",pointX,pointY)
		self.texture = self:CreateTexture(nil, "BACKGROUND")
		self.texture:SetTexture(texture)
		self.texture:SetAllPoints()
		self:RegisterForClicks("LeftButtonDown")
		self.iconText = iconText
		self:SetScript("OnClick", AddTextToEditBox)
		return self
	end

	for i=13,#module.db.otherIconsList-3 do
		local icon = CreateOtherIcon(5+(i-13)*20,-2,module.db.otherIconsList[i][3],module.db.otherIconsList[i][1])
		if module.db.otherIconsList[i][4] then
			icon.texture:SetTexCoord( unpack(module.db.otherIconsList[i],4,7) )
		end
	end
	do
		local GetSpellInfo = GetSpellInfo
		local line = 2
		local inLine = 0
		for i=1,#module.db.otherIconsAdditionalList do
			local spellID = module.db.otherIconsAdditionalList[i]
			if spellID == 0 then
				line = line + 1
				inLine = 0
			elseif type(spellID) == 'string' then
				CreateOtherIcon(5+inLine*20,-2-(line-1)*20,spellID,"||T"..spellID..":0||t")
				inLine = inLine + 1
				if inLine > 12 and (not module.db.otherIconsAdditionalList[i+1] or module.db.otherIconsAdditionalList[i+1]~=0) then
					line = line + 1
					inLine = 0
				end
			else
				local _,_,spellTexture = GetSpellInfo( spellID )

				CreateOtherIcon(5+inLine*20,-2-(line-1)*20,spellTexture,"{spell:"..spellID.."}")
				inLine = inLine + 1
				if inLine > 12 and (not module.db.otherIconsAdditionalList[i+1] or module.db.otherIconsAdditionalList[i+1]~=0) then
					line = line + 1
					inLine = 0
				end
			end
		end
		self.OtherIconsFrame.ScrollFrame:SetNewHeight( max(self.OtherIconsFrame:GetHeight()-40 , line * 20 + 4) )
	end

	self:SetScript("OnHide",function (self)
		self.OtherIconsFrame:Hide()
	end)

	self.dropDownColor = ELib:DropDown(self.tab.tabs[1],170,10):Point(558,-30):Size(100):SetText(L.NoteColor)
	self.dropDownColor.list = {
		{L.NoteColorRed,"|cffff0000"},
		{L.NoteColorGreen,"|cff00ff00"},
		{L.NoteColorBlue,"|cff0000ff"},
		{L.NoteColorYellow,"|cffffff00"},
		{L.NoteColorPurple,"|cffff00ff"},
		{L.NoteColorAzure,"|cff00ffff"},
		{L.NoteColorBlack,"|cff000000"},
		{L.NoteColorGrey,"|cff808080"},
		{L.NoteColorRedSoft,"|cffee5555"},
		{L.NoteColorGreenSoft,"|cff55ee55"},
		{L.NoteColorBlueSoft,"|cff5555ee"},
	}
	local classNames = ExRT.GDB.ClassList
	for i,class in ipairs(classNames) do
		local colorTable = RAID_CLASS_COLORS[class]
		if colorTable and type(colorTable)=="table" then
			self.dropDownColor.list[#self.dropDownColor.list + 1] = {L.classLocalizate[class] or class,"|c"..(colorTable.colorStr or "ffaaaaaa")}
		end
	end
	self.dropDownColor:SetScript("OnEnter",function (self)
		ELib.Tooltip.Show(self,"ANCHOR_LEFT",L.NoteColor,{L.NoteColorTooltip1,1,1,1,true},{L.NoteColorTooltip2,1,1,1,true})
	end)
	self.dropDownColor:SetScript("OnLeave",function ()
		ELib.Tooltip:Hide()
	end)
	function self.dropDownColor:SetValue(colorCode)
		ELib:DropDownClose()

		local selectedStart,selectedEnd = module.options.NoteEditBox.EditBox:GetTextHighlight()
		colorCode = string.gsub(colorCode,"|","||")
		if selectedStart == selectedEnd then
			AddTextToEditBox(nil,colorCode.."||r",nil,true)
		else
			AddTextToEditBox(nil,"||r",selectedEnd,true)
			AddTextToEditBox(nil,colorCode,selectedStart,true)
		end
	end
	for i=1,#self.dropDownColor.list do
		local colorData = self.dropDownColor.list[i]
		self.dropDownColor.List[i] = {
			text = colorData[2]..colorData[1],
			func = self.dropDownColor.SetValue,
			justifyH = "CENTER",
			arg1 = colorData[2],
		}
	end
	self.dropDownColor.Lines = #self.dropDownColor.List

	local function RaidNamesOnEnter(self)
		self.html:SetShadowColor(0.2, 0.2, 0.2, 1)
	end
	local function RaidNamesOnLeave(self)
		self.html:SetShadowColor(0, 0, 0, 1)
	end
	self.raidnames = {}
	for i=1,40 do
		local button = CreateFrame("Button", nil,self.tab.tabs[1])
		self.raidnames[i] = button
		button:SetSize(93,14)
		button:SetPoint("TOPLEFT", 15+math.floor((i-1)/5)*95,-55-14*((i-1)%5))

		button.html = ELib:Text(button,"",11):Color()
		button.html:SetAllPoints()
		button.txt = ""
		button:RegisterForClicks("LeftButtonDown")
		button.iconText = ""
		button:SetScript("OnClick", AddTextToEditBox)

		button:SetScript("OnEnter", RaidNamesOnEnter)
		button:SetScript("OnLeave", RaidNamesOnLeave)
	end

	self.lastUpdate = ELib:Text(self.tab.tabs[1],"",11):Size(600,20):Point("TOPLEFT",self.NotesList,"BOTTOMLEFT",3,-6):Top():Color()
	if VExRT.Note.LastUpdateName and VExRT.Note.LastUpdateTime then
		self.lastUpdate:SetText( L.NoteLastUpdate..": "..VExRT.Note.LastUpdateName.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Note.LastUpdateTime)..")" )
	end
	self.lastUpdate:Hide()

	self.chkEnable = ELib:Check(self,L.Enable,VExRT.Note.enabled):Point(720,-17):Tooltip("/rt note|n/rt n"):Size(18,18):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)

	self.chkFix = ELib:Check(self,L.messagebutfix,VExRT.Note.Fix):Point(590,-17):Tooltip(L.messagebutfixtooltip):Size(18,18):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.Fix = true
			module.frame:SetMovable(false)
			module.frame:EnableMouse(false)
			module.frame.buttonResize:Hide()
			ExRT.lib.AddShadowComment(module.frame,1)
		else
			VExRT.Note.Fix = nil
			module.frame:SetMovable(true)
			module.frame:EnableMouse(true)
			module.frame.buttonResize:Show()
			ExRT.lib.AddShadowComment(module.frame,nil,L.message)
		end
	end) 

	self.chkOnlyPromoted = ELib:Check(self.tab.tabs[2],L.NoteOnlyPromoted,VExRT.Note.OnlyPromoted):Point(15,-15):Tooltip(L.NoteOnlyPromotedTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.OnlyPromoted = true
		else
			VExRT.Note.OnlyPromoted = nil
		end
	end)  


	self.chkOnlyInRaid = ELib:Check(self.tab.tabs[2],L.MarksBarDisableInRaid,VExRT.Note.HideOutsideRaid):Point(15,-40):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.HideOutsideRaid = true
		else
			VExRT.Note.HideOutsideRaid = nil
		end
		module:Visibility()
	end) 

	self.chkOnlyInRaidKInstance = ELib:Check(self.tab.tabs[2],L.NoteShowOnlyInRaid,VExRT.Note.ShowOnlyInRaid):Point(15,-65):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.ShowOnlyInRaid = true
			module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
		else
			VExRT.Note.ShowOnlyInRaid = nil
			module:UnregisterEvents('ZONE_CHANGED_NEW_AREA')
		end
		module:Visibility()
	end) 

	self.chkOnlySelf = ELib:Check(self.tab.tabs[2],L.NoteShowOnlyPersonal,VExRT.Note.ShowOnlyPersonal):Point(15,-90):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.ShowOnlyPersonal = true
		else
			VExRT.Note.ShowOnlyPersonal = nil
		end
		module.frame:UpdateText()
	end) 

	self.chkHideInCombat = ELib:Check(self.tab.tabs[2],L.NoteHideInCombat,VExRT.Note.HideInCombat):Point(15,-115):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.HideInCombat = true
			module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
		else
			VExRT.Note.HideInCombat = nil
			module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
		end
		module:Visibility()
	end) 

	self.chkSaveAllNew = ELib:Check(self.tab.tabs[2],L.NoteSaveAllNew,VExRT.Note.SaveAllNew):Point(15,-140):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.SaveAllNew = true
		else
			VExRT.Note.SaveAllNew = nil
		end
	end) 

	self.chkEnableWhenReceive = ELib:Check(self.tab.tabs[2],L.NoteEnableWhenReceive,VExRT.Note.EnableWhenReceive):Point(15,-165):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.EnableWhenReceive = true
		else
			VExRT.Note.EnableWhenReceive = nil
		end
	end) 

	self.sliderFontSize = ELib:Slider(self.tab.tabs[2],L.NoteFontSize):Size(300):Point(16,-200):Range(6,72):SetTo(VExRT.Note.FontSize or 12):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.FontSize = event
		module.frame:UpdateFont()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	local function DropDownFont_Click(_,arg)
		VExRT.Note.FontName = arg
		local FontNameForDropDown = arg:match("\\([^\\]*)$")
		module.options.dropDownFont:SetText(FontNameForDropDown or arg)
		ELib:DropDownClose()
		module.frame:UpdateFont()
	end

	self.dropDownFont = ELib:DropDown(self.tab.tabs[2],350,10):Point(15,-230):Size(300)
	for i=1,#ExRT.F.fontList do
		self.dropDownFont.List[i] = {}
		local info = self.dropDownFont.List[i]
		info.text = ExRT.F.fontList[i]
		info.arg1 = ExRT.F.fontList[i]
		info.func = DropDownFont_Click
		info.font = ExRT.F.fontList[i]
		info.justifyH = "CENTER" 
	end
	for name,font in ExRT.F.IterateMediaData("font") do
		local info = {}
		self.dropDownFont.List[#self.dropDownFont.List+1] = info

		info.text = name
		info.arg1 = font
		info.func = DropDownFont_Click
		info.font = font
		info.justifyH = "CENTER" 
	end
	do
		local arg = VExRT.Note.FontName or ExRT.F.defFont
		local FontNameForDropDown = arg:match("\\([^\\]*)$")
		self.dropDownFont:SetText(FontNameForDropDown or arg)
	end

	self.chkOutline = ELib:Check(self.tab.tabs[2],L.messageOutline,VExRT.Note.Outline):Point("LEFT",self.dropDownFont,"RIGHT",15,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.Outline = true
		else
			VExRT.Note.Outline = nil
		end
		module.frame:UpdateFont()
	end) 

	self.slideralpha = ELib:Slider(self.tab.tabs[2],L.messagebutalpha):Size(300):Point(16,-275):Range(0,100):SetTo(VExRT.Note.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.sliderscale = ELib:Slider(self.tab.tabs[2],L.messagebutscale):Size(300):Point(16,-345):Range(5,200):SetTo(VExRT.Note.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.slideralphaback = ELib:Slider(self.tab.tabs[2],L.messageBackAlpha):Size(300):Point(16,-310):Range(0,100):SetTo(VExRT.Note.ScaleBack or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.ScaleBack = event
		module.frame.background:SetColorTexture(0, 0, 0, event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.moreOptionsDropDown = ELib:DropDown(self.tab.tabs[2],275,#frameStrataList+1):Point(15,-380):Size(300):SetText(L.NoteFrameStrata)

	local function moreOptionsDropDown_SetVaule(_,arg)
		VExRT.Note.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.moreOptionsDropDown.List-1 do
			self.moreOptionsDropDown.List[i].checkState = VExRT.Note.Strata == self.moreOptionsDropDown.List[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end

	for i=1,#frameStrataList do
		self.moreOptionsDropDown.List[i] = {
			text = frameStrataList[i],
			checkState = VExRT.Note.Strata == frameStrataList[i],
			radio = true,
			arg1 = frameStrataList[i],
			func = moreOptionsDropDown_SetVaule,
		}
	end
	tinsert(self.moreOptionsDropDown.List,{text = L.minimapmenuclose, func = function()
		ELib:DropDownClose()
	end})

	self.ButtonToCenter = ELib:Button(self.tab.tabs[2],L.MarksBarResetPos):Size(300,20):Point(15,-410):Tooltip(L.MarksBarResetPosTooltip):OnClick(function()
		VExRT.Note.Left = nil
		VExRT.Note.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 

	if VExRT.Note.Text1 then 
		self.NoteEditBox.EditBox:SetText(VExRT.Note.Text1) 
	end

	self.textHelp = ELib:Text(self.tab.tabs[3],
		"|cffffff00||cffRRGGBB|r...|cffffff00||r|r - "..L.NoteHelp1..
		(not ExRT.isClassic and "|n|cffffff00{D}|r...|cffffff00{/D}|r - "..format(L.NoteHelp2,DAMAGER) or "")..
		(not ExRT.isClassic and "|n|cffffff00{H}|r...|cffffff00{/H}|r - "..format(L.NoteHelp2,HEALER) or "")..
		(not ExRT.isClassic and "|n|cffffff00{T}|r...|cffffff00{/T}|r - "..format(L.NoteHelp2,TANK) or "")..
		"|n|cffffff00{spell:|r|cff00ff0017|r|cffffff00}|r - "..L.NoteHelp3..
		"|n|cffffff00{self}|r - "..L.NoteHelp4..
		"|n|cffffff00{p:|r|cff00ff00JaneD|r|cffffff00,|r|cff00ff00JennyB-HowlingFjord|r|cffffff00}|r...|cffffff00{/p}|r - "..L.NoteHelp5..
		"|n|cffffff00{!p:|r|cff00ff00Leeroy|r|cffffff00,|r|cff00ff00Juron|r|cffffff00}|r...|cffffff00{/p}|r - "..L.NoteHelp5b..
		"|n|cffffff00{icon:|r|cff00ff00Interface/Icons/inv_hammer_unique_sulfuras|r|cffffff00}|r - "..L.NoteHelp6..
		"|n|cffffff00{c:|r|cff00ff00Paladin,Priest|r|cffffff00}|r...|cffffff00{/c}|r - "..L.NoteHelp8..
		"|n|cffffff00{!c:|r|cff00ff00Mage,Hunter|r|cffffff00}|r...|cffffff00{/c}|r - "..L.NoteHelp8b..
		"|n|cffffff00{g|r|cff00ff002|r|cffffff00}|r...|cffffff00{/g}|r - "..L.NoteHelp10..
		"|n|cffffff00{!g|r|cff00ff0034|r|cffffff00}|r...|cffffff00{/g}|r - "..L.NoteHelp10b..
		(ExRT.isClassic and "|n|cffffff00{race:|r|cff00ff00troll,orc|r|cffffff00}|r...|cffffff00{/race}|r - "..L.NoteHelp11 or "")..
		(ExRT.isClassic and "|n|cffffff00{!race:|r|cff00ff00dwarf|r|cffffff00}|r...|cffffff00{/race}|r - "..L.NoteHelp11b or "")..
		(not ExRT.isClassic and "|n|cffffff00{time:|r|cff00ff002:45|r|cffffff00}|r - "..L.NoteHelp7 or "")..
		(not ExRT.isClassic and "|n|cffffff00{p|r|cff00ff002|r|cffffff00}|r...|cffffff00{/p}|r - "..L.NoteHelp9 or "")
	):Point("TOPLEFT",10,-20):Point("TOPRIGHT",-10,-20):Color()

	self.advancedHelp = ELib:Button(self.tab.tabs[3],L.NoteHelpAdvanced):Size(400,20):Point("TOP",self.textHelp,"BOTTOM",0,-20):OnClick(function() 
		module.options.textHelpAdv:SetShown(not module.options.textHelpAdv:IsShown())
	end):Shown(not ExRT.isClassic)

	self.textHelpAdv = ELib:Text(self.tab.tabs[3],
		"|cffffff00{time:|r|cff00ff001:06,p2|r|cffffff00}|r - "..L.NoteHelpAdv1..
		"|n|cffffff00{time:|r|cff00ff000:30,SCC:17:2|r|cffffff00}|r - "..L.NoteHelpAdv2..
		"|n|cffffff00{time:|r|cff00ff002:00,e,customevent|r|cffffff00}|r - "..L.NoteHelpAdv3..
		"|n|cffffff00{time:|r|cff00ff000:45,wa:nzoth_hs1|r|cffffff00}|r - "..L.NoteHelpAdv4
	):Point("LEFT",10,0):Point("RIGHT",-10,0):Point("TOP",self.advancedHelp,"BOTTOM",0,-20):Color():Shown(false)

	module:RegisterEvents("GROUP_ROSTER_UPDATE")

	function self:OnShow()
		module.main:GROUP_ROSTER_UPDATE()
	end

	self.isWide = true
end


module.frame = CreateFrame("Frame",nil,UIParent)
module.frame:SetSize(200,100)
module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self)
	if self:IsMovable() then
		self:StartMoving()
	end
end)
module.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VExRT.Note.Left = self:GetLeft()
	VExRT.Note.Top = self:GetTop()
end)
module.frame:SetFrameStrata("HIGH")
module.frame:SetResizable(true)
module.frame:SetMinResize(30, 30)
module.frame:SetScript("OnSizeChanged", function (self, width, height)
	local width_, height_ = self:GetSize()
	if VExRT and VExRT.Note then
		VExRT.Note.Width = width
		VExRT.Note.Height = height

		module.frame:UpdateText()
	end
	module.frame.sf.C:SetWidth( width_ )
end)
module.frame:Hide() 

module.frame.sf = CreateFrame("ScrollFrame", nil, module.frame)
module.frame.sf:SetPoint("TOPLEFT",0,0)
module.frame.sf:SetAllPoints()
module.frame.sf.C = CreateFrame("Frame", nil, module.frame.sf) 
module.frame.sf:SetScrollChild(module.frame.sf.C)
module.frame.sf.C:SetHeight(2000)
module.frame.sf:Hide()

ELib:FixPreloadFont(module.frame,function() 
	if VExRT then
		module.frame.text:SetFont(GameFontWhite:GetFont(),11)
		module.frame:UpdateFont() 
		return true
	end
end)

function module.frame:UpdateFont()
	local font = VExRT and VExRT.Note and VExRT.Note.FontName or ExRT.F.defFont
	local size = VExRT and VExRT.Note and VExRT.Note.FontSize or 12
	local outline = VExRT and VExRT.Note and VExRT.Note.Outline and "OUTLINE"
	local isValidFont = self.text:SetFont(font,size,outline)
	if not isValidFont then 
		self.text:SetFont(GameFontNormal:GetFont(),size,outline)
	end
end

function module.frame:UpdateText()
	if VExRT.Note.ShowOnlyPersonal then
		self.text:SetText(txtWithIcons(""))
	else
		self.text:SetText(txtWithIcons(VExRT.Note.Text1 or "")) 
	end
end

module.frame.background = module.frame:CreateTexture(nil, "BACKGROUND")
module.frame.background:SetColorTexture(0, 0, 0, 1)
module.frame.background:SetAllPoints()

module.frame.red_back = CreateFrame("Frame",nil,module.frame)
module.frame.red_back:SetPoint("TOPLEFT",0,0)
module.frame.red_back:SetPoint("BOTTOMRIGHT",0,0)
module.frame.red_back.b = module.frame.red_back:CreateTexture(nil, "BACKGROUND", nil, 1)
module.frame.red_back.b:SetColorTexture(1, 0, 0, .2)
module.frame.red_back.b:SetAllPoints()
module.frame.red_back.s = ELib:Shadow(module.frame.red_back,20)
module.frame.red_back.s:SetBackdropBorderColor(1, 0, 0, .2)
module.frame.red_back:Hide()
local red_back_t = 1
module.frame.red_back:SetScript("OnShow",function()
	red_back_t = 3
end)
module.frame.red_back:SetScript("OnUpdate",function(self,tmr)
	red_back_t = red_back_t - tmr
	if red_back_t <= 0 then
		self:Hide()
		return
	end
	self.s:SetBackdropBorderColor(1, 0, 0, max(0, .4 * min(2,red_back_t)/2))
	self.b:SetColorTexture(1, 0, 0, max(0, .4 * min(2,red_back_t)/2))
end)


module.frame.text = module.frame:CreateFontString(nil,"ARTWORK")
module.frame.text:SetFont(ExRT.F.defFont, 12)
module.frame.text:SetPoint("TOPLEFT",5,-5)
module.frame.text:SetPoint("BOTTOMRIGHT",-5,5)
module.frame.text:SetJustifyH("LEFT")
module.frame.text:SetJustifyV("TOP")
module.frame.text:SetText(" ")

function module.frame.text:FixLag()
	self:SetParent(module.frame.sf.C)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT",5,-5)
	self:SetPoint("BOTTOMRIGHT",-5,5)
end

module.frame.buttonResize = CreateFrame("Frame",nil,module.frame)
module.frame.buttonResize:SetSize(15,15)
module.frame.buttonResize:SetPoint("BOTTOMRIGHT", 0, 0)
module.frame.buttonResize.back = module.frame.buttonResize:CreateTexture(nil, "BACKGROUND")
module.frame.buttonResize.back:SetTexture("Interface\\AddOns\\ExRT\\media\\Resize.tga")
module.frame.buttonResize.back:SetAllPoints()
module.frame.buttonResize:SetScript("OnMouseDown", function(self)
	module.frame:StartSizing()
end)
module.frame.buttonResize:SetScript("OnMouseUp", function(self)
	module.frame:StopMovingOrSizing()
end)



function module.frame:Save(blackNoteID)
	VExRT.Note.Text1 = (blackNoteID and VExRT.Note.Black[blackNoteID] or VExRT.Note.Text1 or "")

	if not blackNoteID and module.options.NoteEditBox and VExRT.Note.OptionsFormatting then
	--	VExRT.Note.Text1 = VExRT.Note.Text1:gsub("|([Ttcr])","||%1")
	end

	if #VExRT.Note.Text1 == 0 then
		VExRT.Note.Text1 = " "
	end
	local txttosand = VExRT.Note.Text1
	local arrtosand = {}
	local j = 1
	local indextosnd = tostring(GetTime())..tostring(math.random(1000,9999))
	for i=1,#txttosand do
		if i%220 == 0 then
			arrtosand[j]=string.sub (txttosand, (j-1)*220+1, j*220)
			j = j + 1
		elseif i == #txttosand then
			arrtosand[j]=string.sub (txttosand, (j-1)*220+1)
			j = j + 1
		end
	end
	local encounterID = VExRT.Note.AutoLoad[blackNoteID or 0] or "-"
	local noteName = (blackNoteID and VExRT.Note.BlackNames[blackNoteID]) or (not blackNoteID and VExRT.Note.DefName) or ""

	if blackNoteID then
		VExRT.Note.AutoLoad[0] = VExRT.Note.AutoLoad[blackNoteID]
		VExRT.Note.DefName = VExRT.Note.BlackNames[blackNoteID]
		if VExRT.Note.DefName then
			VExRT.Note.DefName = VExRT.Note.DefName:gsub("%*$","")
		end
	end

	if ExRT.isClassic then
		local MSG_LIMIT_COUNT = 10
		local MSG_LIMIT_TIME = 6
		if #arrtosand >= MSG_LIMIT_COUNT and module.options.buttonsend then
			module.options.buttonsend:Disable()
			C_Timer.After(floor((#arrtosand+1)/MSG_LIMIT_COUNT * MSG_LIMIT_TIME),function()
				module.options.buttonsend:Enable()
			end)
		end
		for i=1,#arrtosand,MSG_LIMIT_COUNT do
			local start = i
			C_Timer.After(floor((start-1)/MSG_LIMIT_COUNT) * MSG_LIMIT_TIME + 0.05,function()
				for j=start,min(#arrtosand,start+MSG_LIMIT_COUNT-1) do
					ExRT.F.SendExMsg("multiline",indextosnd.."\t"..arrtosand[j])
				end
			end)
		end
		C_Timer.After(floor((#arrtosand)/MSG_LIMIT_COUNT) * MSG_LIMIT_TIME + 0.1,function()
			ExRT.F.SendExMsg("multiline_add",ExRT.F.CreateAddonMsg(indextosnd,encounterID,noteName))
		end)
	else
		for i=1,#arrtosand do
			ExRT.F.SendExMsg("multiline",indextosnd.."\t"..arrtosand[i])
		end
		ExRT.F.SendExMsg("multiline_add",ExRT.F.CreateAddonMsg(indextosnd,encounterID,noteName))
	end
end 

function module.frame:Clear() 
	module.options.NoteEditBox.EditBox:SetText("") 
end 

function module:addonMessage(sender, prefix, ...)
	if prefix == "multiline" then
		if VExRT.Note.OnlyPromoted and IsInRaid() and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end

		VExRT.Note.LastUpdateName = sender
		VExRT.Note.LastUpdateTime = time()

		local msgnowindex,lastnowtext = ...
		if tostring(msgnowindex) == tostring(module.db.msgindex) then
			module.db.lasttext = module.db.lasttext .. lastnowtext
		else
			module.db.lasttext = lastnowtext
		end
		module.db.msgindex = msgnowindex
		VExRT.Note.Text1 = module.db.lasttext
		module.frame:UpdateText()
		if module.options.NoteEditBox then
			if module.options.IsMainNoteNow then
				module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Text1)
			end

			module.options.lastUpdate:SetText( L.NoteLastUpdate..": "..VExRT.Note.LastUpdateName.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Note.LastUpdateTime)..")" )
		end
		VExRT.Note.AutoLoad[0] = nil
		if module.options.UpdatePageAfterGettingNote then
			module.options.UpdatePageAfterGettingNote()
		end
		if VExRT.Note.EnableWhenReceive and not VExRT.Note.enabled then
			module:Enable()
		end
		module.frame.red_back:Show()
		if type(WeakAuras)=="table" and WeakAuras.ScanEvents and type(WeakAuras.ScanEvents)=="function" then
			WeakAuras.ScanEvents("EXRT_NOTE_UPDATE")
		end
	elseif prefix == "multiline_add" then
		if VExRT.Note.OnlyPromoted and IsInRaid() and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
		if sender == ExRT.SDB.charKey then
			return
		end
		local msgIndex,encounterID,noteName = ...
		if tostring(msgIndex) ~= tostring(module.db.msgindex) then
			return
		end
		encounterID = tonumber(encounterID)
		if noteName == "" then noteName = nil end
		VExRT.Note.AutoLoad[0] = encounterID
		VExRT.Note.DefName = noteName
		if VExRT.Note.SaveAllNew then
			local finded = false
			if noteName then
				noteName = noteName:gsub("%*+$","").."*"
				for i=1,#VExRT.Note.Black do
					if VExRT.Note.BlackNames[i] == noteName and VExRT.Note.AutoLoad[i] == encounterID then
						VExRT.Note.Black[i] = VExRT.Note.Text1
						VExRT.Note.AutoLoad[i] = encounterID
						VExRT.Note.BlackLastUpdateName[i] = sender
						VExRT.Note.BlackLastUpdateTime[i] = time()
						finded = true
						break
					end
				end
			elseif encounterID then
				for i=1,#VExRT.Note.Black do
					if VExRT.Note.AutoLoad[i] == encounterID and (not VExRT.Note.BlackNames[i] or VExRT.Note.BlackNames[i] == "") then
						VExRT.Note.Black[i] = VExRT.Note.Text1
						VExRT.Note.BlackLastUpdateName[i] = sender
						VExRT.Note.BlackLastUpdateTime[i] = time()
						finded = true
						break
					end
				end

			end
			if not finded then
				local newIndex = #VExRT.Note.Black + 1
				VExRT.Note.Black[newIndex] = VExRT.Note.Text1
				VExRT.Note.AutoLoad[newIndex] = encounterID
				VExRT.Note.BlackNames[newIndex] = noteName
				VExRT.Note.BlackLastUpdateName[newIndex] = sender
				VExRT.Note.BlackLastUpdateTime[newIndex] = time()
				if module.options.NotesListUpdateNames then
					module.options.NotesListUpdateNames()
				end
			end
		end 
		if module.options.UpdatePageAfterGettingNote then
			module.options.UpdatePageAfterGettingNote()
		end
	elseif prefix == "multiline_timer_sync" then
		local name = ...
		ExRT.F.Note_Timer(name)
	end 
end 

local gruevent = {}

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Note = VExRT.Note or {}
	VExRT.Note.Black = VExRT.Note.Black or {}
	VExRT.Note.AutoLoad = VExRT.Note.AutoLoad or {}

	if VExRT.Note.Left and VExRT.Note.Top then 
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.Note.Left,VExRT.Note.Top)
	end

	VExRT.Note.FontSize = VExRT.Note.FontSize or 12

	if VExRT.Note.Width then 
		module.frame:SetWidth(VExRT.Note.Width) 
	end
	if VExRT.Note.Height then 
		module.frame:SetHeight(VExRT.Note.Height) 
	end

	module.frame:UpdateFont()
	if VExRT.Note.enabled then 
		module:Enable()
	end
	C_Timer.After(5,function()
		module.frame:UpdateFont()
	end)

	if VExRT.Note.Text1 then 
		module.frame:UpdateText()
	end
	if VExRT.Note.Alpha then 
		module.frame:SetAlpha(VExRT.Note.Alpha/100) 
	end
	if VExRT.Note.Scale then 
		module.frame:SetScale(VExRT.Note.Scale/100) 
	end
	if VExRT.Note.ScaleBack then
		module.frame.background:SetColorTexture(0, 0, 0, VExRT.Note.ScaleBack/100)
	end
	if VExRT.Note.Fix then
		module.frame:SetMovable(false)
		module.frame:EnableMouse(false)
		module.frame.buttonResize:Hide()
	else
		ExRT.lib.AddShadowComment(module.frame,nil,L.message)
	end

	if VExRT.Addon.Version < 3225 then
		for i=1,12 do
			if not VExRT.Note.Black[i] then
				for j=i,12 do
					VExRT.Note.Black[j] = VExRT.Note.Black[j+1]
				end
			end
		end
	end
	if VExRT.Addon.Version < 3865 then
		--VExRT.Note.EnableWhenReceive = true
	end
	if VExRT.Addon.Version < 3895 then
		VExRT.Note.OnlyPromoted = true
	end
	if VExRT.Addon.Version < 3960 then
		VExRT.Note.OptionsFormatting = true
	end

	VExRT.Note.BlackNames = VExRT.Note.BlackNames or {}

	for i=1,3 do
		VExRT.Note.Black[i] = VExRT.Note.Black[i] or ""
	end

	VExRT.Note.BlackLastUpdateName = VExRT.Note.BlackLastUpdateName or {}
	VExRT.Note.BlackLastUpdateTime = VExRT.Note.BlackLastUpdateTime or {}

	VExRT.Note.Strata = VExRT.Note.Strata or "HIGH"

	module:RegisterAddonMessage()
	module:RegisterSlash()

	module.frame:SetFrameStrata(VExRT.Note.Strata)
end

function module.main:PLAYER_LOGIN()
	if VExRT.Note.enabled then
		module.frame:UpdateText()
	end
end

function module:Enable()
	VExRT.Note.enabled = true
	if module.options.chkEnable then
		module.options.chkEnable:SetChecked(true)
	end
	module:RegisterEvents("PLAYER_SPECIALIZATION_CHANGED","PLAYER_LOGIN","ENCOUNTER_END","ENCOUNTER_START")
	if VExRT.Note.HideOutsideRaid then
		module:RegisterEvents("GROUP_ROSTER_UPDATE")
	end
	if VExRT.Note.HideInCombat then
		module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
	end
	if VExRT.Note.ShowOnlyInRaid then
		module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
	end
	module:Visibility()
end

function module:Disable()
	VExRT.Note.enabled = nil
	if module.options.chkEnable then
		module.options.chkEnable:SetChecked(false)
	end
	module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ZONE_CHANGED_NEW_AREA',"PLAYER_SPECIALIZATION_CHANGED","PLAYER_LOGIN","ENCOUNTER_END","ENCOUNTER_START")
	module:Visibility()
end

local Note_CombatState = false

function module:Visibility()
	local bool = true
	if not VExRT.Note.enabled then
		bool = bool and false
	end
	if bool and VExRT.Note.HideOutsideRaid then
		if GetNumGroupMembers() > 0 then
			bool = bool and true
		else
			bool = bool and false
		end
	end
	if bool and VExRT.Note.HideInCombat then
		if Note_CombatState then
			bool = bool and false
		else
			bool = bool and true
		end
	end
	if bool and VExRT.Note.ShowOnlyInRaid then
		local _,zoneType = IsInInstance()
		if zoneType == "raid" then
			bool = bool and true
		else
			bool = bool and false
		end
	end

	if bool then
		module.frame:Show()
	else
		module.frame:Hide()
	end
end

local party_uids = {'player','party1','party2','party3','party4'}
function module.main:GROUP_ROSTER_UPDATE()
	C_Timer.After(1, module.Visibility)
	if not module.options.raidnames or not module.options:IsVisible() then
		return
	end
	for i=1,8 do gruevent[i] = 0 end
	for _,name,subgroup,class in ExRT.F.IterateRoster do
		gruevent[subgroup] = gruevent[subgroup] + 1
		local cR,cG,cB = ExRT.F.classColorNum(class)

		local POS = gruevent[subgroup] + (subgroup - 1) * 5
		local obj = module.options.raidnames[POS]

		if obj then
			name = ExRT.F.delUnitNameServer(name)
			local colorCode = ExRT.F.classColor(class)
			obj.iconText = "||c"..colorCode..name.."||r "
			obj.iconTextShift = name
			obj.html:SetText(name)
			obj.html:SetTextColor(cR, cG, cB, 1)
		end
	end
	for i=1,8 do
		for j=(gruevent[i]+1),5 do
			local frame = module.options.raidnames[(i-1)*5+j]
			frame.iconText = ""
			frame.iconTextShift = ""
			frame.html:SetText("")
		end
	end
end 
function module.main:PLAYER_REGEN_DISABLED()
	Note_CombatState = true
	module:Visibility()
end
function module.main:PLAYER_REGEN_ENABLED()
	Note_CombatState = false
	module:Visibility()
end

function module.main:ZONE_CHANGED_NEW_AREA()
	C_Timer.After(5, module.Visibility)
end

function module.main:PLAYER_SPECIALIZATION_CHANGED()
	module.frame:UpdateText()
end


do
	local BossPhasesBossmodAdded
	local function BossPhasesBossmod()
		if BossPhasesBossmodAdded then
			return
		end
		if type(BigWigsLoader)=='table' and BigWigsLoader.RegisterMessage then
			local r = {}
			local patt
			function r:BigWigs_Message (event, mod, key, text, ...)
				if (key == "stages") then
					if type(text)~='string' then
						return
					end

					if not patt and BigWigsAPI then
						local CL = BigWigsAPI:GetLocale("BigWigs: Common")
						if CL and CL.soon then
							patt = CL.soon:gsub("%%s","")
							if CL.soon:find("^%%s") then
								patt = patt .. "$"
							else
								patt = "^" .. patt
							end
						end
					end
					if patt and text:find( patt ) then
						return
					end

					local phase = text:match ("%d+")
					phase = tonumber (phase or "")
					if phase then
						wipe(encounter_time_p)
						encounter_time_p[phase] = GetTime()
						if module.frame:IsVisible() then
							module.frame:UpdateText()
						end
					end
				end
			end

			BigWigsLoader.RegisterMessage (r, "BigWigs_Message")

			BossPhasesBossmodAdded = true
		elseif type(DBM)=='table' and DBM.RegisterCallback then
			DBM:RegisterCallback("DBM_Announce", function(event, message, icon, etype, spellId, modId)
				if etype == "stagechange" then
					local phase = message:match("%d+")
					phase = tonumber(phase or "")
					if phase then
						wipe(encounter_time_p)
						encounter_time_p[phase] = GetTime()
						if module.frame:IsVisible() then
							module.frame:UpdateText()
						end
					end
				end
			end)

			BossPhasesBossmodAdded = true
		end
	end


	function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
		local updateTextReq
		local noteText = (VExRT.Note.Text1 or "")..(VExRT.Note.SelfText or "")
		if encounterID and encounterName then
			encounter_id[tostring(encounterID)] = true
			encounter_id[encounterName] = true
			if noteText:find("{[Ee]:([^}]+)}.-{/[Ee]}") then
				updateTextReq = true
			end
		end
		local timeInText = noteText:find("{time:([0-9:]+[^{}]*)}")
		local phaseInText = noteText:find("{[Pp](%d+)}(.-){/[Pp]}")
		if timeInText or (phaseInText and ((type(BigWigsLoader)=='table') or (type(DBM)=='table'))) then
			wipe(encounter_time_c)
			wipe(encounter_time_wa_uids)
			if timeInText then
				module:RegisterTimer()
			end
			module.db.encounter_time = GetTime()
			encounter_time_p[1] = module.db.encounter_time
			updateTextReq = true
			BossPhasesBossmod()

			if timeInText and noteText:find("{time:[0-9:]+[^}]*,S[^{},]+") then
				wipe(module.db.encounter_counters.SCC)
				wipe(module.db.encounter_counters.SCS)
				wipe(module.db.encounter_counters.SAA)
				wipe(module.db.encounter_counters.SAR)
				local anyEvent
				string_gsub(noteText,"{time:[0-9:]+[^}]*,(S[^{},]+)[,}]",function(str)
					local event,spellID,count = strsplit(":",str)
					if tonumber(count or "") and tonumber(spellID or "") and event and module.db.encounter_counters[event] then
						anyEvent = true
						module.db.encounter_counters[event][tonumber(spellID)] = 0
					end
				end)
				if anyEvent then
					wipe(module.db.encounter_counters_time)
					module:RegisterEvents("COMBAT_LOG_EVENT_UNFILTERED")
				end
			end
		end
		if updateTextReq then
			module.frame.sf:Show()
			module.frame.text:FixLag()
		end
		module.frame:UpdateText()
	end
	function module.main:ENCOUNTER_END()
		wipe(encounter_id)
		--if ((VExRT.Note.Text1 or "")..(VExRT.Note.SelfText or "")):find("{time:([0-9:]+[^{}]*)}") then
			module:UnregisterTimer()
			module.db.encounter_time = nil
			wipe(encounter_time_p)
			wipe(encounter_time_c)
			wipe(encounter_time_wa_uids)

			module:UnregisterEvents("COMBAT_LOG_EVENT_UNFILTERED")
		--end
		module.frame:UpdateText()
	end
	local tmr = 0
	function module:timer(elapsed)
		tmr = tmr + elapsed
		if tmr > 1 then
			tmr = 0
			if module.frame:IsVisible() then
				module.frame:UpdateText()
			end
		end
	end

	module.db.encounter_counters_time = {}
	module.db.encounter_counters = {
		SCC = {},
		SCS = {},
		SAA = {},
		SAR = {},
	}
	local ECT = module.db.encounter_counters_time
	local SCC = module.db.encounter_counters.SCC
	local SCS = module.db.encounter_counters.SCS
	local SAA = module.db.encounter_counters.SAA
	local SAR = module.db.encounter_counters.SAR
	function module.main:COMBAT_LOG_EVENT_UNFILTERED()
		local _,event,_,_,_,_,_,_,_,_,_,spellID = CombatLogGetCurrentEventInfo()
		if event == "SPELL_CAST_SUCCESS" and SCC[spellID] then
			SCC[spellID] = SCC[spellID] + 1
			ECT[ "SCC:"..spellID..":"..SCC[spellID] ] = GetTime()
			ECT[ "SCC:"..spellID..":"..0 ] = GetTime()
		elseif event == "SPELL_CAST_START" and SCS[spellID] then
			SCS[spellID] = SCS[spellID] + 1
			ECT[ "SCS:"..spellID..":"..SCS[spellID] ] = GetTime()
			ECT[ "SCS:"..spellID..":"..0 ] = GetTime()
		elseif event == "SPELL_AURA_APPLIED" and SAA[spellID] then
			SAA[spellID] = SAA[spellID] + 1
			ECT[ "SAA:"..spellID..":"..SAA[spellID] ] = GetTime()
			ECT[ "SAA:"..spellID..":"..0 ] = GetTime()
		elseif event == "SPELL_AURA_REMOVED" and SAR[spellID] then
			SAR[spellID] = SAR[spellID] + 1
			ECT[ "SAR:"..spellID..":"..SAR[spellID] ] = GetTime()
			ECT[ "SAR:"..spellID..":"..0 ] = GetTime()
		end
	end


	function ExRT.F.Note_Timer(name)
		if not name then
			return
		end
		if not module.db.encounter_time then
			module.main:ENCOUNTER_START()
		end
		encounter_time_c[name] = GetTime()
	end
	function ExRT.F.Note_SyncTimer(name)
		if not name then
			return
		end
		ExRT.F.SendExMsg("multiline_timer_sync",name)
	end
end

function module:slash(arg)
	if arg == "note" or arg == "n" then
		if VExRT.Note.enabled then 
			module:Disable()
		else
			module:Enable()
		end
	elseif arg == "editnote" or arg == "edit note" then
		ExRT.Options:Open(module.options)
	elseif arg == "note timer" then
		if module.db.encounter_time then
			module.main:ENCOUNTER_END()
			print('timer ended')
		else
			module.main:ENCOUNTER_START()
			print('timer started')
		end
	elseif arg and arg:find("^note starttimer ") then
		local timer = arg:match("^note starttimer (.-)$")
		if timer then
			ExRT.F.Note_Timer(timer)
		end
	elseif arg and arg:find("^note synctimer ") then
		local timer = arg:match("^note synctimer (.-)$")
		if timer then
			ExRT.F.Note_SyncTimer(timer)
		end
	elseif arg and arg:find("^note set ") then
		local name = arg:match("^note set (.-)$")
		if name then
			local nameNumber = tonumber(name)
			for i=1,#VExRT.Note.Black do
				local blackName = VExRT.Note.BlackNames[i]
				if (blackName and blackName:lower() == name) or (nameNumber == i) then
					module.frame:Save(i)
					return
				end
			end
		end
	end
end

function module:GetText(removeColors,removeExtraSpaces)
	local text = VExRT.Note.Text1 or ""
	if removeColors then
		text = text:gsub("|c........",""):gsub("|r","")
	end
	if removeExtraSpaces then
		text = text:gsub(" *\n","\n"):gsub(" *$",""):gsub(" +"," ")
	end
	return text
end
ExRT.F.GetNote = module.GetText
--- you can use to get note text GExRT.F:GetNote()