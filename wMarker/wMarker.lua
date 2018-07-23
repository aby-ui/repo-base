-- Localization
local L = wMarkerLocals

-------------------------------------------------------
-- Databases and backdrops
-------------------------------------------------------

wMarkerDB = wMarkerDB or {
	locked= false,
	clamped = false,
	shown = true,
	flipped = false,
	vertical = false,
	partyShow = false,
	targetShow = false,
	assistShow = false,
	bgHide = false,
	tooltips = true,
	detach = false,
	scale = 1,
	alpha = 1,
	iconSpace = 0,
	x= 0,
	y = 0,
	relPt = "CENTER",
}
wFlaresDB = wFlaresDB or {
	locked = false,
	clamped = false,
	shown = true,
	flipped = false,
	vertical = false,
	icons = false,
	partyShow = false,
	assistShow = false,
	bgHide = false,
	tooltips = true,
	worldTex = 1,
	scale = 1,
	alpha = 1,
	x= 0,
	y = 50,
	relPt = "CENTER",
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
-- Local variables
-------------------------------------------------------

local wM = "|cffe1a500w|cff69ccf0Marker|r"

-------------------------------------------------------
-- Binding Frame Strings
-------------------------------------------------------
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


_G["BINDING_NAME_CLICK wMarkerSquareflare:LeftButton"] = L["Square"];
_G["BINDING_NAME_CLICK wMarkerTriangleflare:LeftButton"] = L["Triangle"];
_G["BINDING_NAME_CLICK wMarkerDiamondflare:LeftButton"] = L["Diamond"];
_G["BINDING_NAME_CLICK wMarkerCrossflare:LeftButton"] = L["Cross"];
_G["BINDING_NAME_CLICK wMarkerStarflare:LeftButton"] = L["Star"];
_G["BINDING_NAME_CLICK wMarkerCircleflare:LeftButton"] = L["Circle"];
_G["BINDING_NAME_CLICK wMarkerMoonflare:LeftButton"] = L["Moon"];
_G["BINDING_NAME_CLICK wMarkerSkullflare:LeftButton"] = L["Skull"];
_G["BINDING_NAME_CLICK wMarkerClearflares:LeftButton"] = L["Clear all world markers"];


-------------------------------------------------------
-- wMarker Main Frame
-------------------------------------------------------

wMarker = {}
function wMarker:print(self, msg)
	DEFAULT_CHAT_FRAME:AddMessage(string.format("%s:%s",wM,msg))
end
wMarker.other = {}
local main = CreateFrame("Frame", "wMarkerMain", UIParent)
main:SetBackdrop(borderlessBackdrop)
main:SetBackdropColor(0,0,0,0)
main:EnableMouse(true)
main:SetMovable(true)
main:SetSize(225,35)
main:SetPoint("CENTER", UIParent, "CENTER")
main:SetClampedToScreen(false)
wMarker.main = main
local function createMover(width,height,parent,pt,relPt)
	local f = CreateFrame("Frame",nil,parent.main)
	f:SetBackdrop(defaultBackdrop)
	f:SetBackdropColor(0.1,0.1,0.1,0.7)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetSize(width,height)
	f:SetPoint(pt,parent.main,relPt)
	f:SetScript("OnMouseDown",function(self,button) if (button=="LeftButton") then parent.main:StartMoving() end end)
	f:SetScript("OnMouseUp",function() parent.main:StopMovingOrSizing(); parent:getLoc() end)
	return f
end
local wM_moverLeft = createMover(20,35,wMarker,"RIGHT","LEFT")
wMarker.other.moverLeft = wM_moverLeft
local wM_moverRight = createMover(20,35,wMarker,"LEFT","RIGHT")
wMarker.other.moverRight = wM_moverRight

-------------------------------------------------------
-- wMarker Icon Frame (and icons)
-------------------------------------------------------

-- Main options frame placed here so the icons can reference it via right-click
wMarker.options = CreateFrame("Frame", "wMarkerOptions", UIParent)
wMarker.options.name = "wMarker"
InterfaceOptions_AddCategory(wMarker.options)

wMarker.iconFrame = CreateFrame("Frame", "wMarker_iconFrame", wMarker.main)
wMarker.iconFrame:SetBackdrop(defaultBackdrop)
wMarker.iconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
wMarker.iconFrame:EnableMouse(true)
wMarker.iconFrame:SetMovable(true)
wMarker.iconFrame:SetSize(170,35)
wMarker.iconFrame:SetPoint("LEFT", wMarker.main, "LEFT")
table.insert(wMarker.other, wMarker.iconFrame)
wMarker.icon = {}
wMarker.icons = {}
local lastFrame, xOff
local function iconNew(name, num)
	if lastFrame then xOff = 0 else xOff = 5 end
	local f = CreateFrame("Button", string.format("wMarker%sicon",name), wMarker.iconFrame)
	table.insert(wMarker.icon, f)
	f:SetSize(20,20)
	f:SetPoint("LEFT",lastFrame or wMarker.iconFrame,xOff,0)
	f:SetNormalTexture(string.format("interface\\targetingframe\\ui-raidtargetingicon_%d",num))
	f:EnableMouse(true)
	f:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	f:SetScript("OnClick", function(self, button) if (button=="LeftButton") then SetRaidTarget("target", num) else InterfaceOptionsFrame_OpenToCategory(wMarker.options) end end)
	f:SetScript("OnEnter", function(self) if (wMarkerDB.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L[name]); GameTooltip:Show() end end)
	f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	lastFrame = f
	wMarker.icon[name] = f
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

local controlFrame = CreateFrame("Frame", "wMarker_controlFrame", wMarker.main)
controlFrame:SetBackdrop(defaultBackdrop)
controlFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
controlFrame:EnableMouse(true)
controlFrame:SetMovable(true)
controlFrame:SetSize(55,35)
controlFrame:SetPoint("LEFT", wMarker.iconFrame, "RIGHT")
wMarker.other.controlFrame = controlFrame 
local clearIcon = CreateFrame("Button", "wMarkerClearIcon", controlFrame)
clearIcon:SetSize(20,20)
clearIcon:SetPoint("LEFT", controlFrame, "LEFT",10,0)
clearIcon:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
clearIcon:GetNormalTexture():SetTexCoord(0,0.5,0,0.5)
clearIcon:EnableMouse(true)
clearIcon:SetScript("OnClick", function(self) SetRaidTarget("target", 0) end)
clearIcon:SetScript("OnEnter", function(self) if (wMarkerDB.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear mark"]); GameTooltip:Show() end end)
clearIcon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
wMarker.other.clearIcon = clearIcon
local readyCheck = CreateFrame("Button", "wMarkerReadyCheck", controlFrame)
readyCheck:SetSize(20,20)
readyCheck:SetPoint("LEFT", clearIcon, "RIGHT")
readyCheck:SetNormalTexture("interface\\raidframe\\readycheck-waiting")
readyCheck:GetNormalTexture():SetTexCoord(0,1,0,1)
readyCheck:EnableMouse(true)
readyCheck:SetScript("OnClick", function(self,btn) if (btn=="LeftButton") then DoReadyCheck() end end)
readyCheck:SetScript("OnEnter", function(self) if (wMarkerDB.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Ready check"]); GameTooltip:Show() end end)
readyCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
wMarker.other.readyCheck = readyCheck

-------------------------------------------------------
-- wFlares Main Frame 
-------------------------------------------------------

wFlares = {}
wFmain = CreateFrame("Frame", "wFlaresMain", UIParent)
wFmain:SetBackdrop(defaultBackdrop)
wFmain:SetBackdropColor(0.1,0.1,0.1,0.7)
wFmain:EnableMouse(true)
wFmain:SetMovable(true)
wFmain:SetUserPlaced(true)
wFmain:SetSize(190,30)
wFmain:SetPoint("CENTER", UIParent, "CENTER",0,40)
wFmain:SetClampedToScreen(false)
wFlares.main = wFmain
local wF_moverLeft = createMover(20,30,wFlares,"RIGHT","LEFT")
wFlares.main.moverLeft = wF_moverLeft
local wF_moverRight = createMover(20,30,wFlares,"LEFT","RIGHT")
wFlares.main.moverRight = wF_moverRight

-------------------------------------------------------
-- The flares A.K.A. World markers
-------------------------------------------------------

-- New White (Skull 8), Red(Cross), Blue(Square), Silver (Moon 7), Green(Triangle), Purple (Diamond), Orange (Circle 6), Yellow (Star)
wFlares.flare = {}
local function flareNew(name, tex, num, xOff)
	local f = CreateFrame("Button", string.format("wMarker%sflare",name), wFlares.main, "SecureActionButtonTemplate")
	table.insert(wFlares.flare,f)
	f:SetSize(20,20)
	f:SetNormalTexture("interface\\targetingframe\\ui-raidtargeting6icons") -- "interface\\minimap\\partyraidblips"
	f:GetNormalTexture():SetTexCoord(tex[1],tex[2],tex[3],tex[4])
	f:SetPoint("LEFT",lastFlare or wFlares.main,"RIGHT",xOff or 0,0)
	f:SetAttribute("type", "macro")
	f:SetAttribute("macrotext1", string.format("/wm %d",num))
	f:SetScript("OnEnter", function(self) if (wFlaresDB.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(string.format("%s %s",L[name],L["world marker"])); GameTooltip:Show() end end)
	f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	lastFlare = f
	wFlares.flare[name] = f
	
end
flareNew("Square",{0.25,0.5,0.25,0.5},1,5)
flareNew("Triangle",{0.75,1,0,0.25},2)
flareNew("Diamond",{0.5,0.75,0,0.25},3)
flareNew("Cross",{0.5,0.75,0.25,0.5},4)
flareNew("Star",{0,0.25,0,0.25},5)
flareNew("Circle",{0.25,0.5,0,0.25},6);
flareNew("Moon",{0,0.25,0.25,0.5},7);
flareNew("Skull",{0.75,1,0.25,0.5},8);

local flareClear = CreateFrame("Button", "wMarkerClearflares", wFlares.main, "SecureActionButtonTemplate") -- Clear
flareClear:SetSize(15,15)
flareClear:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
flareClear:GetNormalTexture():SetTexCoord(0,0.5,0,0.5)
flareClear:SetPoint("LEFT", wFlares.flare["Skull"], "RIGHT",3,0)
flareClear:SetAttribute("type", "macro")
flareClear:SetAttribute("macrotext1", "/cwm 0")
flareClear:SetScript("OnEnter", function(self) if (wFlaresDB.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear all world markers"]); GameTooltip:Show() end end)
flareClear:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
wFlares.flareClear = flareClear
