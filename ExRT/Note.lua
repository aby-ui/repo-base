local GlobalAddonName, ExRT = ...

local VExRT = nil

local module = ExRT.mod:New("Note",ExRT.L.message,nil,true)
local ELib,L = ExRT.lib,ExRT.L

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
	{"{T}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0,0.26171875,0.26171875,0.5234375},
	{"{H}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0,0.26171875},
	{"{D}","|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t","Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0.26171875,0.5234375},
}

module.db.iconsLocalizatedNames = {
	L.raidtargeticon1,L.raidtargeticon2,L.raidtargeticon3,L.raidtargeticon4,L.raidtargeticon5,L.raidtargeticon6,L.raidtargeticon7,L.raidtargeticon8,
}
local iconsLangs = {"eng","de","it","fr","ru"}
for _,lang in pairs(iconsLangs) do
	module.db["icons"..lang.."Names"] = {}
	for i=1,8 do
		module.db["icons"..lang.."Names"][i] = L["raidtargeticon"..i.."_"..lang]
	end
end

local frameStrataList = {"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}

module.db.msgindex = -1
module.db.lasttext = ""

local string_gsub = string.gsub

local function txtWithIcons(t)
	t = t or ""
	t = string_gsub(t,"||T","|T")
	t = string_gsub(t,"||t","|t")
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
	
	local spellLastPos = t:find("{spell:%d+}")
	while spellLastPos do
		local template,spell = t:match("({spell:(%d+)})")
		local _,spellTexture
		spell = tonumber(spell)
		if spell then
			_,_,spellTexture = GetSpellInfo( spell )
			spellTexture = "|T"..(spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK")..":16|t"
		end
		spellTexture = spellTexture or ""
		
		if template:find("%-") then
			template = string_gsub(template,"%-","%%%-")
		end
		
		t = string_gsub(t,template,spellTexture)
		
		local spellNewPos = t:find("{spell:%d+}")
		if spellLastPos == spellNewPos then
			break
		end
		spellLastPos = spellNewPos
	end
	
	t = string_gsub(t,"%b{}","")
	return t
end

local IsUpdateNoteByEncounterFromMe = nil

function module.options:Load()
	self:CreateTilte()

	module.db.otherIconsAdditionalList = {
		31821,62618,97462,98008,115310,64843,740,108280,204150,31842,196718,15286,207946,0,
		47788,33206,6940,102342,114030,1022,116849,633,204018,207399,0,
		2825,32182,80353,0,
		106898,192077,46968,119381,179057,192058,0,
		--"Interface\\Icons\\inv_60legendary_ring1c","Interface\\Icons\\inv_60legendary_ring1b","Interface\\Icons\\inv_60legendary_ring1a",0,
		0,
		246220,254948,244761,244969,0,
		244056,244825,244057,244054,244055,248819,248815,244768,244131,0,
		254130,244892,254771,244722,253037,244625,245227,246505,257974,244172,0,
		244016,243983,244689,244915,244598,244926,245050,245118,244849,244613,244001,0,
		246305,254769,249017,249015,249014,249016,245764,248332,0,
		247367,247687,254244,247949,247641,247932,247681,248070,248068,0,
		254919,248214,246833,246504,246516,249535,254795,244328,0,
		243960,248732,244042,243999,244093,243968,243977,243980,243961,0,
		250097,250333,250334,249793,252861,253650,245627,246329,253520,245532,250757,245518,244899,0,
		255058,245458,255061,243431,244693,244912,254452,254022,245632,0,
		258838,257296,258030,248165,255826,248317,257869,257931,257215,255199,253903,253901,257966,258000,251570,250669,258837,248396,248167,0,
		0,
		233283,230345,234264,233272,233062,231363,0,
		233894,234015,239401,233426,233983,233441,236283,233430,0,
		237630,236442,236529,236518,236547,233263,236305,236596,236694,234996,234995,0,
		239375,239420,230959,230276,241509,230273,230362,230920,0,
		240066,241600,234016,233429,231729,240315,231854,241594,0,
		236142,235968,236340,236361,235969,236513,235927,236158,236449,236131,236072,236241,235924,235907,0,
		241635,235028,241636,236061,235267,248812,234891,235271,235240,235213,235538,243276,235534,241593,238028,0,
		236494,240623,233556,239207,240594,235572,242017,240249,240728,239212,0,
		238430,240910,239932,235120,238502,236710,236378,244834,241564,0,
		0,
		204284,204766,204372,204471,204448,204316,0,
		206617,205707,219823,206607,207011,207012,207013,219808,0,
		214573,206641,206488,206798,207631,208499,208910,207141,206792,206557,206560,206559,207513,0,
		215458,212647,212587,213166,213564,213864,213867,213869,0,
		206921,206388,214486,205649,206936,207720,221875,207439,206517,206949,206433,206589,0,
		212997,208230,212794,213531,206365,212795,215988,0,
		205348,206677,206376,206352,205863,205368,0,
		218806,219049,219009,218148,218424,218438,218774,218807,218508,0,
		209166,209165,208659,208944,209244,209973,232974,209568,210022,0,
		210339,210296,206985,206515,209011,206384,206555,206581,227550,209518,206840,206516,0,
		--[[
		0,
		228053,227992,227903,228056,227967,228565,228032,228730,193367,232450,0,
		228758,228768,228769,228744,228810,228818,228253,228228,228248,227514,227894,227642,0,
		229582,229583,227498,229579,229580,228012,228162,231350,227807,228914,228007,0,
		]]
	}
	
	module.db.encountersList = {
		{1148,2144,2141,2136,2128,2134,2145,2135,2122},
		{909,2076,2074,2064,2070,2075,2082,2069,2088,2073,2063,2092},
		{850,2032,2048,2036,2037,2050,2054,2052,2038,2051},
		{764,1849,1865,1867,1871,1862,1886,1842,1863,1872,1866},
	}

	local BlackNoteNow = nil
	local NoteIsSelfNow = nil
	self.IsMainNoteNow = true
	
	self.decorationLine = CreateFrame("Frame",nil,self)
	self.decorationLine.texture = self.decorationLine:CreateTexture(nil, "BACKGROUND", nil, -5)
	self.decorationLine:SetPoint("TOPLEFT",self,-8,-25)
	self.decorationLine:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",8,-45)
	self.decorationLine.texture:SetAllPoints()
	self.decorationLine.texture:SetColorTexture(1,1,1,1)
	self.decorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	self.tab = ELib:Tabs(self,0,L.message,L.minimapmenuset):Point(0,-45):Size(660,570):SetTo(1)
	self.tab:SetBackdropBorderColor(0,0,0,0)
	self.tab:SetBackdropColor(0,0,0,0)
	
	self.tab.tabs[1]:SetPoint("TOPLEFT",0,20)

	self.NotesList = ELib:ScrollList(self.tab.tabs[1]):Size(175,435):Point(5,-130)
	self.NotesList.selected = 1
	
	local function NotesListUpdateNames()
		self.NotesList.L = {}
		
		self.NotesList.L[1] = "|cff55ee55"..L.messageTab1
		self.NotesList.L[2] = L.NoteSelf
		for i=1,#VExRT.Note.Black do
			self.NotesList.L[i+2] = VExRT.Note.BlackNames[i] or i
		end
		self.NotesList.L[#self.NotesList.L + 1] = L.NoteAdd
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
	
	function self.NotesList:SetListValue(index)
		ExRT.lib.ShowOrHide(module.options.buttonsend,index == 1)
		ExRT.lib.ShowOrHide(module.options.textCancel,index == 1)
		ExRT.lib.ShowOrHide(module.options.buttoncopy,index > 2)
		
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
			
			module.options.autoLoadDropdown:SetText(VExRT.Note.AutoLoad[0] and L.bossName[ VExRT.Note.AutoLoad[0] ] or "-")
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
			module.options.DraftName:SetText( BlackNoteNow )
			
			NotesListUpdateNames()
			
			module.options.autoLoadDropdown:SetText("-")
		else
			index = index - 2
			if IsShiftKeyDown() then
				VExRT.Note.Black[index] = VExRT.Note.Text1
			end
			module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Black[index] or "")
			
			BlackNoteNow = index
			module.options.DraftName:SetText( VExRT.Note.BlackNames[index] or index )
			
			module.options.autoLoadDropdown:SetText(VExRT.Note.AutoLoad[index] and L.bossName[ VExRT.Note.AutoLoad[index] ] or "-")
		end
	end
	
	function self.NotesList:HoverListValue(isHover,index)
		if not isHover then
			GameTooltip_Hide()
		else
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			GameTooltip:AddLine(self.L[index])
			if index == 2 then
				GameTooltip:AddLine(L.NoteSelfTooltip)
			elseif index ~= #self.L and index > 2 then
				GameTooltip:AddLine(L.NoteTabCopyTooltip)
			end
			GameTooltip:Show()
		end
	end
	
	self.RemoveDraft = ELib:Button(self.tab.tabs[1],L.NoteRemove):Size(150,20):Point("RIGHT",0,0):Point("TOP",self.NotesList,0,1):Disable():OnClick(function (self)
		if not BlackNoteNow then
			return
		end
		local size = #VExRT.Note.Black
		for i=BlackNoteNow,size do
			if i < size then
				VExRT.Note.Black[i] = VExRT.Note.Black[i + 1]
				VExRT.Note.BlackNames[i] = VExRT.Note.BlackNames[i + 1]
				VExRT.Note.AutoLoad[i] = VExRT.Note.AutoLoad[i + 1]
			else
				VExRT.Note.Black[i] = nil
				VExRT.Note.BlackNames[i] = nil
				VExRT.Note.AutoLoad[i] = nil
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
	
	self.DraftName = ELib:Edit(self.tab.tabs[1]):Size(0,18):Tooltip(L.NoteDraftName):Text(VExRT.Note.DefName or L.messageTab1):Point("TOPLEFT",self.NotesList,"TOPRIGHT",8,0):Point("RIGHT",self.RemoveDraft,"LEFT",-5,0):OnChange(function(self,isUser)
		if not isUser then return end
		if BlackNoteNow then
			VExRT.Note.BlackNames[ BlackNoteNow ] = self:GetText()
			NotesListUpdateNames()
		elseif not BlackNoteNow and not NoteIsSelfNow then
			VExRT.Note.DefName = self:GetText()
		end
	end)
	
	local function autoLoadDropdown_SetValue(self,encounterID)
		local index = BlackNoteNow or 0
		
		VExRT.Note.AutoLoad[index] = encounterID
		
		module.options.autoLoadDropdown:SetText(encounterID and L.bossName[ encounterID ] or "-")
		ELib:DropDownClose()
	end
	
	self.autoLoadDropdown = ELib:DropDown(self.tab.tabs[1],300,15):AddText(L.NoteAutoloadOnBoss):Point("TOPRIGHT",self.RemoveDraft,"BOTTOMRIGHT",-2,-5):Size(300):SetText(VExRT.Note.AutoLoad[0] and L.bossName[ VExRT.Note.AutoLoad[0] ] or "-")
	do
		local List = self.autoLoadDropdown.List
		List[#List+1] = {
			text = NO,
			func = autoLoadDropdown_SetValue,
		}
		for i=1,#module.db.encountersList do
			local instance = module.db.encountersList[i]
			List[#List+1] = {
				text = (C_Map.GetMapInfo(instance[1] or 0) or {}).name or "???",
				isTitle = true,
			}
			for j=2,#instance do
				List[#List+1] = {
					text = L.bossName[ instance[j] ],
					arg1 = instance[j],
					func = autoLoadDropdown_SetValue,
				}
			end
		end
	end
	
	self.NoteEditBox = ELib:MultiEdit(self.tab.tabs[1]):Point("TOPLEFT",self.NotesList,"TOPRIGHT",9,-75):Size(469,294+91-25)
	
	self.NoteEditBox:Add730fix()	--Temp fix for cursor
	
	self.textClear = ELib:Text(self.NoteEditBox,"["..L.messagebutclear.."]"):Point("RIGHT",self.NoteEditBox,"BOTTOMRIGHT",-22,-6):Color()
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
	
	self.textCancel = ELib:Text(self.NoteEditBox,"["..CANCEL.."]"):Point("RIGHT",self.textClear,"LEFT",-5,0):Color()
	self.textCancel:SetShadowColor(1,1,1,0)
	self.textCancel:SetShadowOffset(1,-1)
	self.buttonCuncel = CreateFrame("Button",nil,self.NoteEditBox)
	self.buttonCuncel:SetAllPoints(self.textCancel)
	self.buttonCuncel:SetScript("OnClick",function()
		if not module.options.textCancel:IsShown() then
			return
		end
		module.options.NoteEditBox.EditBox:SetText(VExRT.Note.Text1)
	end)
	self.buttonCuncel:SetScript("OnEnter",function()
		self.textCancel:SetShadowColor(1,1,1,1)
	end)
	self.buttonCuncel:SetScript("OnLeave",function()
		self.textCancel:SetShadowColor(1,1,1,0)
	end)
		
	function self.NoteEditBox.EditBox:OnTextChanged()
		if NoteIsSelfNow then
			VExRT.Note.SelfText = self:GetText()
			module.frame:UpdateText()
		elseif BlackNoteNow then
			VExRT.Note.Black[ BlackNoteNow ] = self:GetText()
		else
			if self:GetText() ~= VExRT.Note.Text1 then
				module.options.buttonsend:Anim(true)
			else
				module.options.buttonsend:Anim(false)
			end
		end
	end
	
	self.buttonsend = ELib:Button(self.tab.tabs[1],L.messagebutsend):Size(469,20):Point("TOPLEFT",self.NotesList,"TOPRIGHT",9,-50):Tooltip(L.messagebutsendtooltip):OnClick(function (self)
		module.frame:Save() 
		
		if IsShiftKeyDown() then
			local text = VExRT.Note.Text1 or ""
			text = text:gsub("||c........","")
			text = text:gsub("||r","")
			text = text:gsub("||T.-:0||t ","")
			text = text:gsub("%b{}","")
			
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
	
	self.buttoncopy = ELib:Button(self.tab.tabs[1],L.messageButCopy):Size(469,20):Point("TOPLEFT",self.NotesList,"TOPRIGHT",9,-50):OnClick(function (self)
		if not BlackNoteNow then
			return
		end
		--VExRT.Note.Text1 = VExRT.Note.Black[BlackNoteNow] or ""
		--VExRT.Note.DefName = VExRT.Note.BlackNames[BlackNoteNow] or ""
		--VExRT.Note.AutoLoad[0] = VExRT.Note.AutoLoad[BlackNoteNow]
		module.frame:Save(BlackNoteNow) 
		
		module.options.NotesList:SetListValue(1)
		
		module.options.NotesList.selected = 1
		module.options.NotesList:Update()
	end) 
	self.buttoncopy:Hide()
	
	local function AddTextToEditBox(self,text,mypos)
		local addedText = nil
		if not self then
			addedText = text
		else
			addedText = self.iconText
			if IsShiftKeyDown() then
				addedText = self.iconTextShift
			end
		end
		local txt = module.options.NoteEditBox.EditBox:GetText()
		local pos = module.options.NoteEditBox.EditBox:GetCursorPosition()
		if not self and mypos then
			pos = mypos
		end
		txt = string.sub (txt, 1 , pos) .. addedText .. string.sub (txt, pos+1)
		module.options.NoteEditBox.EditBox:SetText(txt)
		module.options.NoteEditBox.EditBox:SetCursorPosition(pos+string.len(addedText))
	end

	self.buttonicons = {}
	for i=1,8 do
		self.buttonicons[i] = CreateFrame("Button", nil,self.tab.tabs[1])
		self.buttonicons[i]:SetSize(18,18)
		self.buttonicons[i]:SetPoint("TOPLEFT", 5+(i-1)*20,-30)
		self.buttonicons[i].back = self.buttonicons[i]:CreateTexture(nil, "BACKGROUND")
		self.buttonicons[i].back:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)
		self.buttonicons[i].back:SetAllPoints()
		self.buttonicons[i]:RegisterForClicks("LeftButtonDown")
		self.buttonicons[i].iconText = module.db.iconsLocalizatedNames[i]
		self.buttonicons[i]:SetScript("OnClick", AddTextToEditBox)
	end
	for i=1,12 do
		self.buttonicons[i] = CreateFrame("Button", nil,self.tab.tabs[1])
		self.buttonicons[i]:SetSize(18,18)
		self.buttonicons[i]:SetPoint("TOPLEFT", 165+(i-1)*20,-30)
		self.buttonicons[i].back = self.buttonicons[i]:CreateTexture(nil, "BACKGROUND")
		self.buttonicons[i].back:SetTexture(module.db.otherIconsList[i][3])
		if module.db.otherIconsList[i][4] then
			self.buttonicons[i].back:SetTexCoord(unpack(module.db.otherIconsList[i],4,7))
		end
		self.buttonicons[i].back:SetAllPoints()
		self.buttonicons[i]:RegisterForClicks("LeftButtonDown")
		self.buttonicons[i].iconText = module.db.otherIconsList[i][1]
		self.buttonicons[i]:SetScript("OnClick", AddTextToEditBox)
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
		if colorTable then
			self.dropDownColor.list[#self.dropDownColor.list + 1] = {L.classLocalizate[class],"|c"..colorTable.colorStr}
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
			AddTextToEditBox(nil,colorCode.."||r")
		else
			AddTextToEditBox(nil,"||r",selectedEnd)
			AddTextToEditBox(nil,colorCode,selectedStart)
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
	for i=1,30 do
		self.raidnames[i] = CreateFrame("Button", nil,self.tab.tabs[1])
		self.raidnames[i]:SetSize(105,14)
		self.raidnames[i]:SetPoint("TOPLEFT", 5+math.floor((i-1)/5)*108,-55-14*((i-1)%5))

		self.raidnames[i].html = ELib:Text(self.raidnames[i],"",11):Color()
		self.raidnames[i].html:SetAllPoints()
		self.raidnames[i].txt = ""
		self.raidnames[i]:RegisterForClicks("LeftButtonDown")
		self.raidnames[i].iconText = ""
		self.raidnames[i]:SetScript("OnClick", AddTextToEditBox)

		self.raidnames[i]:SetScript("OnEnter", RaidNamesOnEnter)
		self.raidnames[i]:SetScript("OnLeave", RaidNamesOnLeave)
	end
	
	self.lastUpdate = ELib:Text(self.tab.tabs[1],"",11):Size(600,20):Point("TOPLEFT",self.NotesList,"BOTTOMLEFT",3,-6):Top():Color()
	if VExRT.Note.LastUpdateName and VExRT.Note.LastUpdateTime then
		self.lastUpdate:SetText( L.NoteLastUpdate..": "..VExRT.Note.LastUpdateName.." ("..date("%H:%M:%S %d.%m.%Y",VExRT.Note.LastUpdateTime)..")" )
	end

	self.chkEnable = ELib:Check(self,L.senable,VExRT.Note.enabled):Point(560,-26):Tooltip('/rt note'):Size(18,18):OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)  
	
	self.chkFix = ELib:Check(self,L.messagebutfix,VExRT.Note.Fix):Point(430,-26):Tooltip(L.messagebutfixtooltip):Size(18,18):OnClick(function(self) 
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

	self.chkOnlyPromoted = ELib:Check(self.tab.tabs[2],L.NoteOnlyPromoted,VExRT.Note.OnlyPromoted):Point(10,-15):Tooltip(L.NoteOnlyPromotedTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.OnlyPromoted = true
		else
			VExRT.Note.OnlyPromoted = nil
		end
	end)  
	
	
	self.chkOnlyInRaid = ELib:Check(self.tab.tabs[2],L.MarksBarDisableInRaid,VExRT.Note.HideOutsideRaid):Point(10,-40):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.HideOutsideRaid = true
		else
			VExRT.Note.HideOutsideRaid = nil
		end
		module:Visibility()
	end) 
	
	self.chkOnlyInRaidKInstance = ELib:Check(self.tab.tabs[2],L.NoteShowOnlyInRaid,VExRT.Note.ShowOnlyInRaid):Point(10,-65):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.ShowOnlyInRaid = true
			module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
		else
			VExRT.Note.ShowOnlyInRaid = nil
			module:UnregisterEvents('ZONE_CHANGED_NEW_AREA')
		end
		module:Visibility()
	end) 
	
	self.chkOnlySelf = ELib:Check(self.tab.tabs[2],L.NoteShowOnlyPersonal,VExRT.Note.ShowOnlyPersonal):Point(10,-90):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.ShowOnlyPersonal = true
		else
			VExRT.Note.ShowOnlyPersonal = nil
		end
		module.frame:UpdateText()
	end) 
	
	self.chkHideInCombat = ELib:Check(self.tab.tabs[2],L.NoteHideInCombat,VExRT.Note.HideInCombat):Point(10,-115):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.HideInCombat = true
			module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
		else
			VExRT.Note.HideInCombat = nil
			module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED')
		end
		module:Visibility()
	end) 
	
	self.chkSaveAllNew = ELib:Check(self.tab.tabs[2],L.NoteSaveAllNew,VExRT.Note.SaveAllNew):Point(10,-140):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.SaveAllNew = true
		else
			VExRT.Note.SaveAllNew = nil
		end
	end) 
	
	self.chkSaveAllNew = ELib:Check(self.tab.tabs[2],L.NoteEnableWhenReceive,VExRT.Note.EnableWhenReceive):Point(10,-165):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.EnableWhenReceive = true
		else
			VExRT.Note.EnableWhenReceive = nil
		end
	end) 
	
	self.sliderFontSize = ELib:Slider(self.tab.tabs[2],L.NoteFontSize):Size(300):Point(11,-200):Range(6,72):SetTo(VExRT.Note.FontSize or 12):OnChange(function(self,event) 
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

	self.dropDownFont = ELib:DropDown(self.tab.tabs[2],350,10):Point(10,-230):Size(300)
	for i=1,#ExRT.F.fontList do
		self.dropDownFont.List[i] = {}
		local info = self.dropDownFont.List[i]
		info.text = ExRT.F.fontList[i]
		info.arg1 = ExRT.F.fontList[i]
		info.arg2 = i
		info.func = DropDownFont_Click
		info.font = ExRT.F.fontList[i]
		info.justifyH = "CENTER" 
	end
	if LibStub then
		local loaded,media = pcall(LibStub,"LibSharedMedia-3.0")
		if loaded and media then
			local fontList = media:HashTable("font")
			if fontList then
				local count = #self.dropDownFont.List
				for key,font in pairs(fontList) do
					count = count + 1
					self.dropDownFont.List[count] = {}
					local info = self.dropDownFont.List[count]
					
					info.text = font
					info.arg1 = font
					info.arg2 = count
					info.func = DropDownFont_Click
					info.font = font
					info.justifyH = "CENTER" 
				end
			end
		end
	end
	do
		local arg = VExRT.Note.FontName or ExRT.F.defFont
		local FontNameForDropDown = arg:match("\\([^\\]*)$")
		self.dropDownFont:SetText(FontNameForDropDown or arg)
	end
	
	self.chkOutline = ELib:Check(self.tab.tabs[2],L.messageOutline,VExRT.Note.Outline):Point("LEFT",self.dropDownFont,"RIGHT",10,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Note.Outline = true
		else
			VExRT.Note.Outline = nil
		end
		module.frame:UpdateFont()
	end) 
	
	self.slideralpha = ELib:Slider(self.tab.tabs[2],L.messagebutalpha):Size(300):Point(11,-275):Range(0,100):SetTo(VExRT.Note.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.sliderscale = ELib:Slider(self.tab.tabs[2],L.messagebutscale):Size(300):Point(11,-345):Range(5,200):SetTo(VExRT.Note.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.slideralphaback = ELib:Slider(self.tab.tabs[2],L.messageBackAlpha):Size(300):Point(11,-310):Range(0,100):SetTo(VExRT.Note.ScaleBack or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.Note.ScaleBack = event
		module.frame.background:SetColorTexture(0, 0, 0, event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.moreOptionsDropDown = ELib:DropDown(self.tab.tabs[2],275,#frameStrataList+1):Point(10,-380):Size(300):SetText(L.NoteFrameStrata)
	
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
	
	self.ButtonToCenter = ELib:Button(self.tab.tabs[2],L.MarksBarResetPos):Size(300,20):Point(10,-410):Tooltip(L.MarksBarResetPosTooltip):OnClick(function()
		VExRT.Note.Left = nil
		VExRT.Note.Top = nil

		module.frame:ClearAllPoints()
		module.frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	end) 
	
	if VExRT.Note.Text1 then 
		self.NoteEditBox.EditBox:SetText(VExRT.Note.Text1) 
	end

	module:RegisterEvents("GROUP_ROSTER_UPDATE")
	module.main:GROUP_ROSTER_UPDATE()
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
	VExRT.Note.Width = width
	VExRT.Note.Height = height
	module.frame:UpdateText()
end)
module.frame:Hide() 

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
	local selfText = VExRT.Note.SelfText or ""
	if VExRT.Note.ShowOnlyPersonal then
		self.text:SetText(txtWithIcons(selfText))
	else
		local text = VExRT.Note.Text1 or ""
		if text ~= "" and selfText ~= "" then 
			text = text .. "\n" 
		end
		self.text:SetText(txtWithIcons(text..selfText)) 
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
	VExRT.Note.Text1 = (blackNoteID and VExRT.Note.Black[blackNoteID] or module.options.NoteEditBox and module.options.NoteEditBox.EditBox:GetText() or VExRT.Note.Text1 or "")
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
	for i=1,#arrtosand do
		ExRT.F.SendExMsg("multiline",indextosnd.."\t"..arrtosand[i])
	end
	ExRT.F.SendExMsg("multiline_add",ExRT.F.CreateAddonMsg(indextosnd,VExRT.Note.AutoLoad[blackNoteID or 0] or "-",blackNoteID and VExRT.Note.BlackNames[blackNoteID] or VExRT.Note.DefName or ""))
end 

function module.frame:Clear() 
	module.options.NoteEditBox.EditBox:SetText("") 
end 

local function GetPlayerRankInRaid(unit)
	local rank = tonumber( ExRT.F.IsPlayerRLorOfficer(unit) or "0" )
	return rank or 0
end
local function SendNoteByEncounter(blackNoteID)
	if not IsUpdateNoteByEncounterFromMe then
		return
	end
	IsUpdateNoteByEncounterFromMe = nil
	if blackNoteID < 1 then
		blackNoteID = nil
	end
	module.frame:Save(blackNoteID)
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
		VExRT.Note.AutoLoad[0] = encounterID
		VExRT.Note.DefName = noteName
		if VExRT.Note.SaveAllNew then
			noteName = noteName:gsub("%**$","*")
			local finded = false
			for i=1,#VExRT.Note.Black do
				if VExRT.Note.BlackNames[i] == noteName then
					VExRT.Note.Black[i] = VExRT.Note.Text1
					VExRT.Note.AutoLoad[i] = encounterID
					finded = true
					break
				end
			end
			if not finded then
				local newIndex = #VExRT.Note.Black + 1
				VExRT.Note.Black[newIndex] = VExRT.Note.Text1
				VExRT.Note.AutoLoad[newIndex] = encounterID
				VExRT.Note.BlackNames[newIndex] = noteName
				if module.options.NotesListUpdateNames then
					module.options.NotesListUpdateNames()
				end
			end
		end 
		if module.options.UpdatePageAfterGettingNote then
			module.options.UpdatePageAfterGettingNote()
		end
	elseif prefix == "multiline_req" then
		if sender and IsUpdateNoteByEncounterFromMe then
			if ExRT.F.IsPlayerRLorOfficer(ExRT.SDB.charName) == 2 then
				return
			end
			if (ExRT.F.IsPlayerRLorOfficer(sender) == 2) or (GetPlayerRankInRaid(sender) > GetPlayerRankInRaid(ExRT.SDB.charName)) or (sender < ExRT.SDB.charName) then
				local type = ...
				if type == "ENCOUNTER" then
					IsUpdateNoteByEncounterFromMe = nil
				end
			end
		end
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
	--if VExRT.Note.Outline then module.frame.text:SetFont(ExRT.F.defFont, 12,"OUTLINE") end
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
	VExRT.Note.BlackNames = VExRT.Note.BlackNames or {}
	
	for i=1,3 do
		VExRT.Note.Black[i] = VExRT.Note.Black[i] or ""
	end
	
	VExRT.Note.Strata = VExRT.Note.Strata or "HIGH"
	
	module:RegisterAddonMessage()
	module:RegisterSlash()
	
	module.frame:SetFrameStrata(VExRT.Note.Strata)
end


function module:Enable()
	VExRT.Note.enabled = true
	if module.options.chkEnable then
		module.options.chkEnable:SetChecked(true)
	end
	module:RegisterEvents("ENCOUNTER_START")
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
	module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ZONE_CHANGED_NEW_AREA',"ENCOUNTER_START")
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

function module.main:GROUP_ROSTER_UPDATE()
	C_Timer.After(1, module.Visibility)
	if not module.options.raidnames then
		return
	end	
	local n = GetNumGroupMembers() or 0
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for i=1,8 do gruevent[i] = 0 end
	for i=1,n do
		local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
		if name and subgroup <= gMax and gruevent[subgroup] then
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
	end
	for i=1,6 do
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

do
	local encountersUsed = {}
	function module.main:ENCOUNTER_START(encounterID,encounterName)
		local _, zoneType, difficulty, _, _, _, _, mapID = GetInstanceInfo()
		if difficulty == 7 or difficulty == 17 then	--Disable if LFR
			return false
		end
		if encountersUsed[encounterID] then
			return
		end
		encountersUsed[encounterID] = true
		local limit = #VExRT.Note.Black
		for i=1,limit do
			local text = VExRT.Note.Black[i]
			if text:find("^{[eEеЕ][pPрР]:"..encounterID.."}") or (encounterName and (text:lower()):find("^{[eе][pр]:"..(encounterName:lower()).."}")) then
				VExRT.Note.SelfText = VExRT.Note.Black[i]
				module.frame:UpdateText()
				break
			end
		end
		for i=0,limit do
			if VExRT.Note.AutoLoad[i] == encounterID then
				ExRT.F.Timer(SendNoteByEncounter, 1.8, i)
				break
			end
			if i == limit then
				IsUpdateNoteByEncounterFromMe = nil
				return
			end
		end
		IsUpdateNoteByEncounterFromMe = true
		ExRT.F.Timer(ExRT.F.SendExMsg, 0.3, "multiline_req","ENCOUNTER")
	end
end

function module:slash(arg)
	if arg == "note" then
		if VExRT.Note.enabled then 
			module:Disable()
		else
			module:Enable()
		end
	elseif arg == "editnote" or arg == "edit note" then
		ExRT.Options:Open(module.options)
	end
end