-- Localization
local L = wMarkerLocales

-------------------------------------------------------
-- Databases and backdrops
-------------------------------------------------------

local defaults = {
	profile = {
		raid = {
			locked= false,
			clamped = false,
			shown = true,
			flipped = false,
			vertical = true,
			partyShow = false,
			targetShow = false,
			assistShow = false,
			bgHide = false,
			tooltips = true,
			scale = 1,
			alpha = 1,
			iconSpace = 0,
		},
		world = {
			locked = false,
			clamped = false,
			shown = true,
			flipped = false,
			vertical = true,
			partyShow = true,
			assistShow = false,
			bgHide = false,
			tooltips = true,
			worldTex = 1,
			scale = 1,
			alpha = 1,
		},
		frameLoc = {
			["wMarkerRaid"] = {"LEFT", "UIParent", "LEFT", 0, 130},
			["wMarkerWorld"] = {"LEFT", "UIParent", "LEFT", 3, -130},
		},
	},
	global ={
		imported = false
	},
}

local defaultBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4,}
}
local borderlessBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	tile = true,
	tileSize = 16
}
local optionsBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
}
local editBoxBackdrop = {
	bgFile = "Interface\\COMMON\\Common-Input-Border",
	tile = false,
}

-------------------------------------------------------
-- Binding Frame Strings
-------------------------------------------------------

BINDING_HEADER_WMARKER = (U1GetAddonInfo and U1GetAddonInfo(...).title) or (...)
BINDING_HEADER_WMARKER_RAID = string.format("|cffe1a500w|cff69ccf0Marker|r - %s",L["Raid marker"]);
BINDING_HEADER_WMARKER_WORLD = string.format("|cffe1a500w|cff69ccf0Marker|r - %s",L["World markers"]);
BINDING_NAME_WMARKER_SKULL = L["Skull"];
BINDING_NAME_WMARKER_CROSS = L["Cross"];
BINDING_NAME_WMARKER_SQUARE = L["Square"];
BINDING_NAME_WMARKER_MOON = L["Moon"];
BINDING_NAME_WMARKER_TRI = L["Triangle"];
BINDING_NAME_WMARKER_DIA = L["Diamond"];
BINDING_NAME_WMARKER_CIR = L["Circle"];
BINDING_NAME_WMARKER_STAR = L["Star"];
BINDING_NAME_WMARKER_CLEAR = L["Clear mark"];
BINDING_NAME_WMARKER_READY = L["Ready check"];

_G["BINDING_NAME_CLICK wMarkerSquareflare:LeftButton"] = L["World markers"] .. L["Square"];
_G["BINDING_NAME_CLICK wMarkerTriangleflare:LeftButton"] = L["World markers"] .. L["Triangle"];
_G["BINDING_NAME_CLICK wMarkerDiamondflare:LeftButton"] = L["World markers"] .. L["Diamond"];
_G["BINDING_NAME_CLICK wMarkerCrossflare:LeftButton"] = L["World markers"] .. L["Cross"];
_G["BINDING_NAME_CLICK wMarkerStarflare:LeftButton"] = L["World markers"] .. L["Star"];
_G["BINDING_NAME_CLICK wMarkerCircleflare:LeftButton"] = L["World markers"] .. L["Circle"];
_G["BINDING_NAME_CLICK wMarkerMoonflare:LeftButton"] = L["World markers"] .. L["Moon"];
_G["BINDING_NAME_CLICK wMarkerSkullflare:LeftButton"] = L["World markers"] .. L["Skull"];
_G["BINDING_NAME_CLICK wMarkerClearflares:LeftButton"] = L["Clear all world markers"];

-------------------------------------------------------
-- wMarker Ace Setup
-------------------------------------------------------

wMarkerAce = LibStub("AceAddon-3.0"):NewAddon("wMarker", "AceConsole-3.0", "AceEvent-3.0")

wMarkerAce.titleText = "|cffe1a500w|cff69ccf0Marker|r"
wMarkerAce.color = {
	["yellow"] = "|cffe1a500",
	["blue"] = "|cff69ccf0"
}

function wMarkerAce:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("wMarkerAceDB", defaults, true)
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable("wMarker", self.options)

	local AceDialog = LibStub("AceConfigDialog-3.0")
	AceDialog:SetDefaultSize("wMarker", 600, 450)
	self.optionsFrame = AceDialog:AddToBlizOptions("wMarker","wMarker")

end

function wMarkerAce:OnEnable()

	-------------------------------------------------------
	-- wMarker Main Frame
	-------------------------------------------------------

	local function createMover(width,height,parent,pt,relPt)
		local f = CreateFrame("Frame",nil,parent, "BackdropTemplate");
		f:SetBackdrop(defaultBackdrop)
		f:SetBackdropColor(0.1,0.1,0.1,0.7)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:SetSize(width,height)
		f:SetPoint(pt,parent,relPt)
		f:SetScript("OnMouseDown",function(self,button) if (button=="LeftButton") then parent:StartMoving() end end)
		f:SetScript("OnMouseUp",function() parent:StopMovingOrSizing(); wMarkerAce:getLoc(parent) end)
		return f
	end

	local main = CreateFrame("Frame", "wMarkerRaid", UIParent, "BackdropTemplate");
	main:SetBackdrop(borderlessBackdrop)
	main:SetBackdropColor(0,0,0,0)
	main:EnableMouse(true)
	main:SetMovable(true)
	main:SetSize(225,35)
	main:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	main:SetClampedToScreen(false)
	wMarkerAce.raidMain = main

	wMarkerAce.raidMain.moverLeft = createMover(20,35,wMarkerAce.raidMain,"RIGHT","LEFT")
	wMarkerAce.raidMain.moverRight = createMover(20,35,wMarkerAce.raidMain,"LEFT","RIGHT")

	-------------------------------------------------------
	-- wMarker Icon Frame (and icons)
	-------------------------------------------------------


	local iconFrame = CreateFrame("Frame", "wMarkerRaid_iconFrame", wMarkerAce.raidMain, "BackdropTemplate");
	iconFrame:SetBackdrop(defaultBackdrop)
	iconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
	iconFrame:EnableMouse(true)
	iconFrame:SetMovable(true)
	iconFrame:SetSize(170,35)
	iconFrame:SetPoint("LEFT", wMarkerAce.raidMain, "LEFT")
	wMarkerAce.raidMain.iconFrame = iconFrame
	wMarkerAce.raidMain.icon = {}
	local lastFrame, xOff
	local function iconNew(name, num)
		if lastFrame then xOff = 0 else xOff = 5 end
		local f = CreateFrame("Button", string.format("wMarker%sicon",name), wMarkerAce.raidMain.iconFrame, "BackdropTemplate");
		table.insert(wMarkerAce.raidMain.icon, f)
		f:SetSize(20,20)
		f:SetPoint("LEFT",lastFrame or wMarkerAce.raidMain.iconFrame,xOff,0)
		f:SetNormalTexture(string.format("interface\\targetingframe\\ui-raidtargetingicon_%d",num))
		f:EnableMouse(true)
		f:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		f:SetScript("OnClick", function(self, button) if (button=="LeftButton") then SetRaidTarget("target", num) else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
		--f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L[name]); GameTooltip:Show() end end)
		--Use Global Strings for Tooltip
		f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(_G["BINDING_NAME_RAIDTARGET"..num]); GameTooltip:Show() end end)
		f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		lastFrame = f
		wMarkerAce.raidMain.icon[name] = f
	end
	iconNew("Skull",8)
	iconNew("Cross",7)
	iconNew("Square",6)
	iconNew("Moon",5)
	iconNew("Triangle",4)
	iconNew("Diamond",3)
	iconNew("Circle",2)
	iconNew("Star",1)

	-------------------------------------------------------
	-- wMarker Control Frame
	-------------------------------------------------------

	local controlFrame = CreateFrame("Frame", "wMarkerRaid_controlFrame", wMarkerAce.raidMain, "BackdropTemplate");
	controlFrame:SetBackdrop(defaultBackdrop)
	controlFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
	controlFrame:EnableMouse(true)
	controlFrame:SetMovable(true)
	controlFrame:SetSize(55,35)
	controlFrame:SetPoint("RIGHT", wMarkerAce.raidMain, "RIGHT")
	wMarkerAce.raidMain.controlFrame = controlFrame
	local clearIcon = CreateFrame("Button", "wMarkerClearIcon", wMarkerAce.raidMain.controlFrame, "BackdropTemplate");
	clearIcon:SetSize(20,20)
	clearIcon:SetPoint("LEFT", wMarkerAce.raidMain.controlFrame, "LEFT",10,0)
	clearIcon:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
	clearIcon:GetNormalTexture():SetTexCoord(0,0.5,0,0.5)
	clearIcon:EnableMouse(true)
	clearIcon:RegisterForClicks("LeftButtonDown","RightButtonDown")
	clearIcon:SetScript("OnClick", function(self, button) if (button=="LeftButton") then SetRaidTarget("target", 0) else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
	clearIcon:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear mark"]); GameTooltip:Show() end end)
	clearIcon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	wMarkerAce.raidMain.clearIcon = clearIcon
	local readyCheck = CreateFrame("Button", "wMarkerReadyCheck", wMarkerAce.raidMain.controlFrame, "BackdropTemplate");
	readyCheck:SetSize(20,20)
	readyCheck:SetPoint("LEFT", clearIcon, "RIGHT")
	readyCheck:SetNormalTexture("interface\\raidframe\\readycheck-waiting")
	readyCheck:GetNormalTexture():SetTexCoord(0,1,0,1)
	readyCheck:EnableMouse(true)
	readyCheck:RegisterForClicks("LeftButtonDown","RightButtonDown")
	readyCheck:SetScript("OnClick", function(self, button) if (button=="LeftButton") then DoReadyCheck() else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
	readyCheck:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Ready check"]); GameTooltip:Show() end end)
	readyCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	wMarkerAce.raidMain.readyCheck = readyCheck

	-------------------------------------------------------
	-- World Marker Main Frame 
	-------------------------------------------------------

	local worldFrame = CreateFrame("Frame", "wMarkerWorld", UIParent, "BackdropTemplate");
	worldFrame:SetBackdrop(defaultBackdrop)
	worldFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
	worldFrame:EnableMouse(true)
	worldFrame:SetMovable(true)
	worldFrame:SetSize(190,30)
	worldFrame:SetPoint("CENTER", UIParent, "CENTER",0,40)
	worldFrame:SetClampedToScreen(false)
	wMarkerAce.worldMain = worldFrame
	wMarkerAce.worldMain.moverLeft = createMover(20,30,wMarkerAce.worldMain,"RIGHT","LEFT")
	wMarkerAce.worldMain.moverRight = createMover(20,30,wMarkerAce.worldMain,"LEFT","RIGHT")

	-------------------------------------------------------
	-- The flares A.K.A. World markers
	-------------------------------------------------------

	-- New White (Skull 8), Red(Cross), Blue(Square), Silver (Moon 7), Green(Triangle), Purple (Diamond), Orange (Circle 6), Yellow (Star)
	wMarkerAce.worldMain.marker = {}
	local function flareNew(name, tex, num, xOff)

		local f = CreateFrame("Button", string.format("wMarker%sflare",name), wMarkerAce.worldMain, "SecureActionButtonTemplate")
		table.insert(wMarkerAce.worldMain.marker,f)
		f:SetSize(20,20)
		f:SetNormalTexture("interface\\targetingframe\\ui-raidtargeting6icons") -- "interface\\minimap\\partyraidblips"
		f:GetNormalTexture():SetTexCoord(unpack(tex))
		f:SetPoint("LEFT",lastFlare or wMarkerAce.worldMain,"RIGHT",xOff or 0,0)

		--Old Macro version
		--f:SetAttribute("type", "macro")
		--f:SetAttribute("macrotext",string.format("/wm %d",num))

		--Set Left-Click to Set Marker
		f:SetAttribute("type1","worldmarker")
		f:SetAttribute("marker1",num)
		f:SetAttribute("action1","set")
		--Set Right-Click to Clear Marker
		f:SetAttribute("type2","worldmarker")
		f:SetAttribute("marker2",num)
		f:SetAttribute("action2","clear")

		--f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.world.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(string.format("%s %s",L[name],L["world marker"])); GameTooltip:Show() end end)
		--Use Global Strings for Tooltip
		f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.world.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(_G["WORLD_MARKER"..num]); GameTooltip:Show() end end)
		f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		f:RegisterForClicks("AnyUp","AnyDown")
		lastFlare = f
		wMarkerAce.worldMain.marker[name] = f
		
	end
	flareNew("Square",{0.25,0.5,0.25,0.5},1,5)
	flareNew("Triangle",{0.75,1,0,0.25},2)
	flareNew("Diamond",{0.5,0.75,0,0.25},3)
	flareNew("Cross",{0.5,0.75,0.25,0.5},4)
	flareNew("Star",{0,0.25,0,0.25},5)
	flareNew("Circle",{0.25,0.5,0,0.25},6);
	flareNew("Moon",{0,0.25,0.25,0.5},7);
	flareNew("Skull",{0.75,1,0.25,0.5},8);

	local worldMarkerClear = CreateFrame("Button", "wMarkerClearflares", wMarkerAce.worldMain, "SecureActionButtonTemplate") -- Clear
	worldMarkerClear:SetSize(15,15)
	worldMarkerClear:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
	worldMarkerClear:GetNormalTexture():SetTexCoord(0,0.5,0,0.5)
	worldMarkerClear:SetPoint("LEFT", wMarkerAce.worldMain.marker["Skull"], "RIGHT",3,0)
	worldMarkerClear:SetAttribute("type1", "macro")
	worldMarkerClear:SetAttribute("macrotext1", "/cwm 0")
	worldMarkerClear:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.world.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear all world markers"]); GameTooltip:Show() end end)
	worldMarkerClear:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	worldMarkerClear:RegisterForClicks("AnyUp","AnyDown")
	wMarkerAce.worldMain.clearIcon = worldMarkerClear

end

function wMarkerAce:OnDisable()
	
end

function wMarkerAce:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: %s",wMarkerAce.titleText,msg))
end


