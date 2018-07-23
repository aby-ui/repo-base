-- Localization
local L = wMarkerLocals

local options = wMarker.options

local defaultBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4,}
}
local wM = "|cffe1a500w|cff69ccf0Marker|cffffffff"
local combatWait = false
local checkUpdate

-------------------------------------------------------
-- Default database values
-------------------------------------------------------
local wM_defaults = {
	locked= false,
	clamped = false,
	shown = true,
	flipped = false,
	vertical = true,
	partyShow = true,
	targetShow = false,
	assistShow = false,
	bgHide = false,
	tooltips = true,
	detach = false,
	scale = 1,
	alpha = 1,
	iconSpace = 0,
	x = 0,
	y = 0,
	relPt = "CENTER",
}
local wF_defaults = {
	locked = false,
	clamped = false,
	shown = true,
	flipped = false,
	vertical = true,
	icons = false,
	partyShow = true,
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
-------------------------------------------------------
-- Manipulation functions (Oh so many of them.)
-------------------------------------------------------

-- Based on Shadowed's Out of Combat function queue
queuedFuncs = {};
function wMarker:RegisterOOCFunc(self,func)
	if (type(func)=="string") then
		queuedFuncs[func] = self;		
	else
		queuedFuncs[self] = true;
	end	
end

local worldMarks;
function wMarker:visibility()
	wMarker.main:Show()
	if (wMarkerDB.shown==false) then wMarker.main:Hide() end
	if (wMarkerDB.partyShow==true) then if (GetNumGroupMembers()==0) then wMarker.main:Hide() end end
	if (wMarkerDB.targetShow==true) then if not (UnitExists("target")) then wMarker.main:Hide() end end
	if (wMarkerDB.assistShow==true) then if (IsInRaid()) and (UnitIsGroupAssistant("player")==false) then wMarker.main:Hide() end end
	worldMarks = true;
	if (wFlaresDB.shown==false) then worldMarks = false end
	if (wFlaresDB.partyShow==true) then if (GetNumGroupMembers()==0) then worldMarks = false end end
	if (wFlaresDB.assistShow==true) then if (IsInRaid()==true) and (UnitIsGroupAssistant("player")==false) then worldMarks = false end end
	if not (InCombatLockdown()) then
		if (worldMarks==true) then
			if not(wFlares.main:IsShown()) then 
				wFlares.main:Show() 
			end
		else
			if (wFlares.main:IsShown()) then
				wFlares.main:Hide()
			end
		end
	else
		wMarker:RegisterOOCFunc(self,"visibility");
	end
end

local function lock()
	if (wMarkerDB.locked==true) then
		wMarker.other.moverLeft:SetAlpha(0)
		wMarker.other.moverLeft:EnableMouse(false)
		wMarker.other.moverRight:SetAlpha(0)
		wMarker.other.moverRight:EnableMouse(false)
	elseif (wMarkerDB.locked==false) then
		wMarker.other.moverLeft:SetAlpha(1)
		wMarker.other.moverLeft:EnableMouse(true)
		wMarker.other.moverRight:SetAlpha(1)
		wMarker.other.moverRight:EnableMouse(true)
	end
	if (wFlaresDB.locked==true) then
		wFlares.main.moverLeft:SetAlpha(0)
		wFlares.main.moverLeft:EnableMouse(false)
		wFlares.main.moverRight:SetAlpha(0)
		wFlares.main.moverRight:EnableMouse(false)
	elseif (wFlaresDB.locked==false) then
		wFlares.main.moverLeft:SetAlpha(1)
		wFlares.main.moverLeft:EnableMouse(true)
		wFlares.main.moverRight:SetAlpha(1)
		wFlares.main.moverRight:EnableMouse(true)
	end
end

local function backgroundVisibility()
	if (wMarkerDB.bgHide==true) then
		wMarker.iconFrame:SetBackdropColor(0,0,0,0)
		wMarker.iconFrame:SetBackdropBorderColor(0,0,0,0)
		wMarker.other.controlFrame:SetBackdropColor(0,0,0,0)
		wMarker.other.controlFrame:SetBackdropBorderColor(0,0,0,0)
	elseif (wMarkerDB.bgHide==false) then
		wMarker.iconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		wMarker.iconFrame:SetBackdropBorderColor(1,1,1,1)
		wMarker.other.controlFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		wMarker.other.controlFrame:SetBackdropBorderColor(1,1,1,1)
	end
	if (wFlaresDB.bgHide==true) then
		wFlares.main:SetBackdropColor(0,0,0,0)
		wFlares.main:SetBackdropBorderColor(0,0,0,0)
	elseif (wFlaresDB.bgHide==false) then
		wFlares.main:SetBackdropColor(0.1,0.1,0.1,1)
		wFlares.main:SetBackdropBorderColor(1,1,1,1)
	end
end

function wMarker:lockToggle()
	wMarkerDB.locked = not wMarkerDB.locked
	lock()
	checkUpdate()
end

function wFlares:lockToggle()
	wFlaresDB.locked = not wFlaresDB.locked
	lock()
	checkUpdate()
end

local function clamp()
	if (wMarkerDB.clamped==true) then wMarker.main:SetClampedToScreen(true) else wMarker.main:SetClampedToScreen(false) end
	if (wFlaresDB.clamped==true) then wFlares.main:SetClampedToScreen(true) else wFlares.main:SetClampedToScreen(false) end
end

function wMarker:clampToggle()
	wMarkerDB.clamped = not wMarkerDB.clamped
	clamp()
	checkUpdate()
end

function wFlares:clampToggle()
	wFlaresDB.clamped = not wFlaresDB.clamped
	clamp()
	checkUpdate()
end

function wMarker:frameFormat(orien)
	if (orien=="horiz") then
		wMarker.main:SetSize(225+(wMarkerDB.iconSpace*7),35)
		wMarker.iconFrame:SetSize(170+(wMarkerDB.iconSpace*7),35)
		wMarker.other.controlFrame:SetSize(55,35)
		wMarker.iconFrame:SetPoint("LEFT", wMarker.main, "LEFT")
		wMarker.other.controlFrame:SetPoint("LEFT", wMarker.iconFrame, "RIGHT")
		wMarker.other.moverLeft:SetSize(20,35)
		wMarker.other.moverRight:SetSize(20,35)
		wMarker.other.moverLeft:SetPoint("RIGHT",wMarker.main,"LEFT")
		wMarker.other.moverRight:SetPoint("LEFT",wMarker.main,"RIGHT")
	elseif (orien=="vert") then
		wMarker.main:SetSize(35,225+(wMarkerDB.iconSpace*7))
		wMarker.iconFrame:SetSize(35,170+(wMarkerDB.iconSpace*7))
		wMarker.other.controlFrame:SetSize(35,55)
		wMarker.iconFrame:SetPoint("TOP", wMarker.main, "TOP")
		wMarker.other.controlFrame:SetPoint("TOP", wMarker.iconFrame, "BOTTOM")
		wMarker.other.moverLeft:SetSize(35,20)
		wMarker.other.moverRight:SetSize(35,20)
		wMarker.other.moverLeft:SetPoint("BOTTOM",wMarker.main,"TOP")
		wMarker.other.moverRight:SetPoint("TOP",wMarker.main,"BOTTOM")
	end
end

function wMarker:orienFormat(dir)
	for k,v in pairs(wMarker.icon) do v:ClearAllPoints() end
	for k,v in pairs(wMarker.other) do v:ClearAllPoints() end
	if (dir==1) then -- Normal
		wMarker.icon["Skull"]:SetPoint("LEFT", wMarker.iconFrame, "LEFT",5,0)
		for i = 2,8 do wMarker.icon[i]:SetPoint("LEFT", wMarker.icon[i-1], "RIGHT",wMarkerDB.iconSpace,0) end
		wMarker.other.clearIcon:SetPoint("LEFT", wMarker.other.controlFrame, "LEFT",10,0)
		wMarker.other.readyCheck:SetPoint("LEFT", wMarker.other.clearIcon, "RIGHT")
		wMarker:frameFormat("horiz")
	elseif (dir==2) then -- Backwards
		wMarker.icon["Star"]:SetPoint("LEFT",wMarker.iconFrame,"LEFT",5,0)
		for i = 7,1,-1 do wMarker.icon[i]:SetPoint("LEFT",wMarker.icon[i+1],"RIGHT",wMarkerDB.iconSpace,0) end
		wMarker.other.clearIcon:SetPoint("LEFT", wMarker.other.controlFrame, "LEFT",10,0)
		wMarker.other.readyCheck:SetPoint("LEFT", wMarker.other.clearIcon, "RIGHT")
		wMarker:frameFormat("horiz")
	elseif (dir==3) then -- Normal vertical
		wMarker.icon["Skull"]:SetPoint("TOP", wMarker.iconFrame, "TOP",0,-5)
		for i = 2,8 do wMarker.icon[i]:SetPoint("TOP",wMarker.icon[i-1], "BOTTOM",0,-wMarkerDB.iconSpace) end
		wMarker.other.clearIcon:SetPoint("TOP", wMarker.other.controlFrame, "TOP",0,-10)
		wMarker.other.readyCheck:SetPoint("TOP", wMarker.other.clearIcon, "BOTTOM")
		wMarker:frameFormat("vert")
	elseif (dir==4) then -- Backwards vertical
		wMarker.icon["Star"]:SetPoint("TOP", wMarker.iconFrame, "TOP",0,-5)
		for i = 7,1,-1 do wMarker.icon[i]:SetPoint("TOP", wMarker.icon[i+1], "BOTTOM",0,-wMarkerDB.iconSpace) end
		wMarker.other.clearIcon:SetPoint("TOP", wMarker.other.controlFrame, "TOP",0,-10)
		wMarker.other.readyCheck:SetPoint("TOP", wMarker.other.clearIcon, "BOTTOM")
		wMarker:frameFormat("vert")
	end
end

function wMarker:orien()
	if (wMarkerDB.flipped==false) and (wMarkerDB.vertical==false) then
		wMarker:orienFormat(1)
	elseif (wMarkerDB.flipped==true) and (wMarkerDB.vertical==false) then 
		wMarker:orienFormat(2)	
	elseif (wMarkerDB.flipped==false) and (wMarkerDB.vertical==true) then
		wMarker:orienFormat(3)
	elseif (wMarkerDB.flipped==true) and (wMarkerDB.vertical==true) then
		wMarker:orienFormat(4)
	end
end

function wFlares:frameFormat(orien)
	if (orien=="horiz") then
		wFlares.main:SetSize(190,30)
		wFlares.main.moverLeft:SetSize(20,30)
		wFlares.main.moverRight:SetSize(20,30)
		wFlares.main.moverLeft:SetPoint("RIGHT",wFlares.main,"LEFT")
		wFlares.main.moverRight:SetPoint("LEFT",wFlares.main,"RIGHT")
	elseif (orien=="vert") then
		wFlares.main:SetSize(30,190)
		wFlares.main.moverLeft:SetSize(30,20)
		wFlares.main.moverRight:SetSize(30,20)
		wFlares.main.moverLeft:SetPoint("BOTTOM",wFlares.main,"TOP")
		wFlares.main.moverRight:SetPoint("TOP",wFlares.main,"BOTTOM")
	end
end

function wFlares:orienFormat(dir)
	for k,v in pairs(wFlares.flare) do v:ClearAllPoints() end
	wFlares.flareClear:ClearAllPoints()
	wFlares.main.moverLeft:ClearAllPoints()
	wFlares.main.moverRight:ClearAllPoints()
	if (dir==1) then -- Normal
		wFlares.flare["Square"]:SetPoint("LEFT", wFlares.main, "LEFT",5,0)
		for i = 2,8 do wFlares.flare[i]:SetPoint("LEFT", wFlares.flare[i-1], "RIGHT") end
		wFlares.flareClear:SetPoint("LEFT",wFlares.flare["Skull"],"RIGHT",3,0)
		wFlares:frameFormat("horiz")
	elseif (dir==2) then -- Backwards
		wFlares.flare["Skull"]:SetPoint("LEFT",wFlares.main,"LEFT",5,0)
		for i = 7,1,-1 do wFlares.flare[i]:SetPoint("LEFT",wFlares.flare[i+1],"RIGHT") end
		wFlares.flareClear:SetPoint("LEFT",wFlares.flare["Square"],"RIGHT",3,0)
		wFlares:frameFormat("horiz")
	elseif (dir==3) then -- Normal vertical
		wFlares.flare["Square"]:SetPoint("TOP", wFlares.main, "TOP",0,-5)
		for i = 2,8 do wFlares.flare[i]:SetPoint("TOP",wFlares.flare[i-1], "BOTTOM") end
		wFlares.flareClear:SetPoint("TOP",wFlares.flare["Skull"],"BOTTOM",0,-3)
		wFlares:frameFormat("vert")
	elseif (dir==4) then -- Backwards vertical
		wFlares.flare["Skull"]:SetPoint("TOP", wFlares.main, "TOP",0,-5)
		for i = 7,1,-1 do wFlares.flare[i]:SetPoint("TOP", wFlares.flare[i+1], "BOTTOM") end
		wFlares.flareClear:SetPoint("TOP",wFlares.flare["Square"],"BOTTOM",0,-3)
		wFlares:frameFormat("vert")
	end
end

function wFlares:orien(dir)
	if not (UnitAffectingCombat("player")) then
		if (wFlaresDB.flipped==false) and (wFlaresDB.vertical==false) then
			wFlares:orienFormat(1)
		elseif (wFlaresDB.flipped==true) and (wFlaresDB.vertical==false) then 
			wFlares:orienFormat(2)	
		elseif (wFlaresDB.flipped==false) and (wFlaresDB.vertical==true) then
			wFlares:orienFormat(3)
		elseif (wFlaresDB.flipped==true) and (wFlaresDB.vertical==true) then
			wFlares:orienFormat(4)
		end
	else
		wMarker:RegisterOOCFunc(self,"orien");
	end
end

function wMarker:bgToggle()
	wMarkerDB.bgHide = not wMarkerDB.bgHide
	backgroundVisibility()
	checkUpdate()
end

function wFlares:bgToggle()
	wFlaresDB.bgHide = not wFlaresDB.bgHide
	backgroundVisibility()
	checkUpdate()
end

local raidScaleText
function wMarker:scale(frame)
	if frame == nil then return end
	wMarkerDB.scale = (frame:GetValue());
	raidScaleText:SetFormattedText("%s: %d%s", L["Raid Markers scale"],math.floor(wMarkerDB.scale*100),"%")
	wMarker.main:SetScale(wMarkerDB.scale);
end

local raidAlphaText
function wMarker:alpha(frame)
	if frame == nil then return end
	wMarkerDB.alpha = (frame:GetValue());
	raidAlphaText:SetFormattedText("%s: %d%s",L["Raid Markers alpha"],math.floor(wMarkerDB.alpha*100),"%")
	wMarker.main:SetAlpha(wMarkerDB.alpha);
end

local raidSpaceText
function wMarker:space(frame)
	if frame == nil then return end
	wMarkerDB.iconSpace = (frame:GetValue());
	raidSpaceText:SetFormattedText("%s: %d",L["Icon spacing"],wMarkerDB.iconSpace)
	wMarker:orien()
end

local worldScaleText
function wFlares:scale(frame)
	if frame == nil then return end
	wFlaresDB.scale = (frame:GetValue());
	worldScaleText:SetFormattedText("%s: %d%s", L["World Markers scale"],math.floor(wFlaresDB.scale*100),"%")
	wFlares.main:SetScale(wFlaresDB.scale);
end

local worldAlphaText
function wFlares:alpha(frame)
	if frame == nil then return end
	wFlaresDB.alpha = (frame:GetValue());
	worldAlphaText:SetFormattedText("%s: %d%s", L["World Markers alpha"],math.floor(wFlaresDB.alpha*100),"%")
	wFlares.main:SetAlpha(wFlaresDB.alpha);
end

function wFlares:retex(tex)
	if (tex==1) then
		for k,v in pairs(wFlares.flare) do v:SetNormalTexture("interface\\minimap\\partyraidblips") end
		wFlares.flare["Square"]:GetNormalTexture():SetTexCoord(0.75,0.875,0,0.25)
		wFlares.flare["Triangle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0,0.25)
		wFlares.flare["Diamond"]:GetNormalTexture():SetTexCoord(0,0.125,0.25,0.5)
		wFlares.flare["Cross"]:GetNormalTexture():SetTexCoord(0.625,0.75,0,0.25)
		wFlares.flare["Star"]:GetNormalTexture():SetTexCoord(0.375,0.5,0,0.25)
		wFlares.flare["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0.25,0.5)
		wFlares.flare["Moon"]:GetNormalTexture():SetTexCoord(0.875,1,0,0.25)
		wFlares.flare["Skull"]:GetNormalTexture():SetTexCoord(0.5,0.625,0,0.25)
	else
		for k,v in pairs(wFlares.flare) do v:SetNormalTexture("interface\\targetingframe\\ui-raidtargetingicons") end
		wFlares.flare["Square"]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
		wFlares.flare["Triangle"]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
		wFlares.flare["Diamond"]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
		wFlares.flare["Cross"]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
		wFlares.flare["Star"]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
		wFlares.flare["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
		wFlares.flare["Moon"]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
		wFlares.flare["Skull"]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
end

function wMarker:getLoc()
	local point, relativeTo, relPt, xOff, yOff = wMarker.main:GetPoint()
	wMarkerDB.x = xOff
	wMarkerDB.y = yOff
	wMarkerDB.relPt = relPt
end
function wFlares:getLoc()
	local point, relativeTo, relPt, xOff, yOff = wFlares.main:GetPoint()
	wFlaresDB.x = xOff
	wFlaresDB.y = yOff
	wFlaresDB.relPt = relPt
end

function wMarker:detach()
	
end

function wMarker:retach()

end

-------------------------------------------------------
-- Options Panel (and sub frames)
-------------------------------------------------------

SLASH_WMARK1 = '/wmarker'
SLASH_WMARK2 = '/wma'
function SlashCmdList.WMARK(msg, editbox)
	if (msg=="lock") then
		wMarker:lockToggle()
		wFlares:lockToggle()
	elseif (msg=="reset") then
		reset()
	elseif (msg=="show") then
		wMarkerDB.shown=true; wFlaresDB.shown=true; wMarker:visibility()
	elseif (msg=="hide") then
		wMarkerDB.shown=false; wFlaresDB.shown=false; wMarker:visibility()
	elseif (msg=="clamp") then
		wMarker:clampToggle(); wFlares:clampToggle()
	elseif (msg=="options") then
		InterfaceOptionsFrame_OpenToCategory(wMarker.options)
	else
		InterfaceOptionsFrame_OpenToCategory(wMarker.options)
	end
end

SLASH_WMARKREADY1 = '/rc'
function SlashCmdList.WMARKREADY(msg, editbox)
	DoReadyCheck();
end

SLASH_WMARKROLE1 = '/roc'
function SlashCmdList.WMARKROLE(msg, editbox)
	InitiateRolePoll();
end

local credits; -- "Translation credits string created here to make usable in function below
local lastTranslationCredit;
local function createTransCredit(lang, contribs)
	local f = options:CreateFontString(nil, "OVERLAY", "ChatFontSmall");
	if not lastTranslationCredit then 
		f:SetPoint("TOPLEFT",credits,10,-20);
	else
		f:SetPoint("TOPLEFT",lastTranslationCredit,0,-20);
	end
	f:SetFormattedText("|cff69ccf0%s|r - %s",lang,contribs);	
	lastTranslationCredit = f;
end

local b = "|cffffd200"
local cbt = "UICheckButtonTemplate"
if not InterfaceOptionsFrame:IsMovable() then InterfaceOptionsFrame:SetMovable(true); InterfaceOptionsFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end); InterfaceOptionsFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end) end
local header = options:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
header:SetPoint("TOPLEFT", options, 20,-20)
header:SetText(wM)
local version = options:CreateFontString(nil, "OVERLAY", "ChatFontSmall")
version:SetPoint("TOPLEFT", options,30,-50)
version:SetFormattedText("%s%s:|r %s",b,L["Version"],GetAddOnMetadata("wMarker", "Version"))
local desc = options:CreateFontString(nil, "OVERLAY", "ChatFontSmall")
desc:SetPoint("TOPLEFT", version,0,-20)
desc:SetFormattedText("%s%s:|r %s",b,L["About"],GetAddOnMetadata("wMarker", "Notes"))
local author = options:CreateFontString(nil, "OVERLAY", "ChatFontSmall")
author:SetPoint("TOPLEFT", desc,0,-20)
author:SetFormattedText("%s%s:|r Waky - Azuremyst",b,L["Author"])
-- Translation Credits
credits = options:CreateFontString(nil, "OVERLAY", "ChatFontSmall")
credits:SetPoint("TOPLEFT",author,0,-20)
credits:SetFormattedText("%s%s:",b,L["Translation credits"])
createTransCredit("German-deDE", "TheGeek/StormCalai, Zaephyr81, Fiveyoushi, Morwo, Waky");
createTransCredit("Spanish-esES", "Waky");
createTransCredit("French-frFR", "Kromdhar, Argone");
createTransCredit("Traditional Chinese-zhTW", "EKE");
createTransCredit("Italian-itIT", "Fabsm");
createTransCredit("Russian-ruRU", "katanaFAN, panzer48, RamyAlexis");
createTransCredit("Simplified Chinese-zhCN", "zhTW, dll32");


keyBinds = CreateFrame("Button","wMarkerKeyBindings",options,"GameMenuButtonTemplate");
keyBinds:SetSize(100,20);
keyBinds:SetText(L["Key bindings"]);
keyBinds:SetPoint("BOTTOMRIGHT",options,-10,10);
keyBinds:SetScript("OnClick",function(self)
	KeyBindingFrame_LoadUI();
	KeyBindingFrame.mode = 1;
	ShowUIPanel(KeyBindingFrame);
end);


local lastCheckButton
local function checkNew(parent,text,func)
	local f = CreateFrame("CheckButton",nil,parent,"UICheckButtonTemplate")
	if not lastCheckButton then f:SetPoint("TOPLEFT",parent,20,-50) else f:SetPoint("TOP",lastCheckButton,"BOTTOM",0,-5) end
	f:SetScript("OnClick",func)
	f.text = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	f.text:SetPoint("LEFT",f,"RIGHT")
	f.text:SetText(text)
	lastCheckButton = f
	return f
end

-- Raid marker frame
wMarker.raidMark = CreateFrame("Frame", "wMarkerRaidMarker", options)
wMarker.raidMark.name = L["Raid marker"]
wMarker.raidMark.parent = wMarker.options.name
local raid = wMarker.raidMark
InterfaceOptions_AddCategory(raid)
local raidHeader = raid:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
raidHeader:SetPoint("TOPLEFT", raid, 20,-20)
raidHeader:SetFormattedText("%s - %s",wM,L["Raid marker"])
local raidShow = checkNew(raid,L["Show frame"],function() wMarkerDB.shown = not wMarkerDB.shown; wMarker:visibility() end)
local raidLock = checkNew(raid,L["Lock frame"],function() wMarker:lockToggle() end)
local raidClamp = checkNew(raid,L["Clamp to screen"],function() wMarker:clampToggle() end)
local raidFlip = checkNew(raid,L["Reverse icons"],function() wMarkerDB.flipped = not wMarkerDB.flipped; wMarker:orien() end)
local raidVert = checkNew(raid,L["Display vertically"],function() wMarkerDB.vertical = not wMarkerDB.vertical; wMarker:orien() end)
local raidParty = checkNew(raid,L["Hide when alone"],function() wMarkerDB.partyShow = not wMarkerDB.partyShow; wMarker:visibility() end)
local raidTarget = checkNew(raid,L["Show only with a target"],function() wMarkerDB.targetShow = not wMarkerDB.targetShow; wMarker:visibility() end)
local raidAssist = checkNew(raid,L["Hide without assist (in a raid)"],function() wMarkerDB.assistShow = not wMarkerDB.assistShow; wMarker:visibility() end)
local raidBG = checkNew(raid,L["Hide background"],function() wMarker:bgToggle() end)
local raidTool = checkNew(raid,L["Enable tooltips"],function() wMarkerDB.tooltips = not wMarkerDB.tooltips end)
local raidScale = CreateFrame("Slider","raidScale",raid,"OptionsSliderTemplate")
lastCheckButton = nil

raidScale:SetPoint("TOPRIGHT",raid,-20,-60)
raidScale:SetSize(180,16)
raidScale:SetMinMaxValues(0.5,1.5)
raidScale:SetValue(1)
raidScale:SetValueStep(0.01)
raidScale:SetOrientation("HORIZONTAL")
raidScale:SetScript("OnValueChanged", function(self) wMarker:scale(self) end)
_G["raidScaleLow"]:SetText("50%")
_G["raidScaleHigh"]:SetText("150%")
raidScaleText = _G["raidScaleText"]
local raidAlpha = CreateFrame("Slider","raidAlpha",raid,"OptionsSliderTemplate")
raidAlpha:SetPoint("TOP",raidScale,"BOTTOM",0,-25)
raidAlpha:SetSize(180,16)
raidAlpha:SetMinMaxValues(0,1)
raidAlpha:SetValue(1)
raidAlpha:SetValueStep(0.01)
raidAlpha:SetOrientation("HORIZONTAL")
raidAlpha:SetScript("OnValueChanged", function(self) wMarker:alpha(self) end)
_G["raidAlphaLow"]:SetText("0%")
_G["raidAlphaHigh"]:SetText("100%")
raidAlphaText = _G["raidAlphaText"]
local raidSpace = CreateFrame("Slider","raidSpace",raid,"OptionsSliderTemplate")
raidSpace:SetPoint("TOP",raidAlpha,"BOTTOM",0,-25)
raidSpace:SetSize(180,16)
raidSpace:SetMinMaxValues(-15,15)
raidSpace:SetValue(0)
raidSpace:SetValueStep(1)
raidSpace:SetOrientation("HORIZONTAL")
raidSpace:SetScript("OnValueChanged", function(self) wMarker:space(self) end)
_G["raidSpaceLow"]:SetText("-15")
_G["raidSpaceHigh"]:SetText("15")
raidSpaceText = _G["raidSpaceText"]

-- World marker frame
wMarker.worldMark = CreateFrame("Frame", "wMarkerWorldMarks", options)
wMarker.worldMark.name = L["World markers"]
wMarker.worldMark.parent = wMarker.options.name
local world = wMarker.worldMark
InterfaceOptions_AddCategory(world)
local worldHeader = world:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
worldHeader:SetPoint("TOPLEFT", world, 20,-20)
worldHeader:SetFormattedText("%s - %s",wM,L["World markers"])
worldShow = checkNew(world,L["Show frame"],function() wFlaresDB.shown = not wFlaresDB.shown; wMarker:visibility() end)
local worldLock = checkNew(world,L["Lock frame"],function() wFlares:lockToggle() end)
local worldClamp = checkNew(world,L["Clamp to screen"],function() wFlares:clampToggle() end)
local worldFlip = checkNew(world,L["Reverse icons"],function() wFlaresDB.flipped = not wFlaresDB.flipped; wFlares:orien() end)
local worldVert = checkNew(world,L["Display vertically"],function() wFlaresDB.vertical = not wFlaresDB.vertical; wFlares:orien() end)
local worldParty = checkNew(world,L["Hide when alone"],function() wFlaresDB.partyShow = not wFlaresDB.partyShow; wMarker:visibility() end)
local worldAssist = checkNew(world,L["Hide without assist (in a raid)"],function() wFlares.assistShow = not wFlaresDB.assistShow; wMarker:visibility() end)
local worldBG = checkNew(world,L["Hide background"],function() wFlares:bgToggle() end)
local worldTool = checkNew(world,L["Enable tooltips"],function() wFlaresDB.tooltips = not wFlaresDB.tooltips end)

local worldScale = CreateFrame("Slider","worldScale",world,"OptionsSliderTemplate")
worldScale:SetPoint("TOPRIGHT",world,-20,-60)
worldScale:SetSize(180,16)
worldScale:SetMinMaxValues(0.5,1.5)
worldScale:SetValue(1)
worldScale:SetValueStep(0.01)
worldScale:SetOrientation("HORIZONTAL")
worldScale:SetScript("OnValueChanged", function(self) wFlares:scale(self) end)
_G["worldScaleLow"]:SetText("50%")
_G["worldScaleHigh"]:SetText("150%")
worldScaleText = _G["worldScaleText"]
local worldAlpha = CreateFrame("Slider","worldAlpha",world,"OptionsSliderTemplate")
worldAlpha:SetPoint("TOP",worldScale,"BOTTOM",0,-25)
worldAlpha:SetSize(180,16)
worldAlpha:SetMinMaxValues(0,1)
worldAlpha:SetValue(1)
worldAlpha:SetValueStep(0.01)
worldAlpha:SetOrientation("HORIZONTAL")
worldAlpha:SetScript("OnValueChanged", function(self) wFlares:alpha(self) end)
_G["worldAlphaLow"]:SetText("0%")
_G["worldAlphaHigh"]:SetText("100%")
worldAlphaText = _G["worldAlphaText"]
local worldTexText = world:CreateFontString(nil,"OVERLAY","ChatFontNormal")
worldTexText:SetPoint("TOPLEFT",worldAlpha,"BOTTOMLEFT",0,-20)
worldTexText:SetText(L["Display as"])
local worldTex = CreateFrame("Frame", "worldTex", world, "UIDropDownMenuTemplate")
worldTex:SetPoint("TOPLEFT",worldTexText,"BOTTOMLEFT",-20,-5)

local worldTexDrop = {
	{text=L["Blips"], value=1, func=(function() wFlares:retex(1); wFlaresDB.worldTex=1; UIDropDownMenu_SetSelectedValue(worldTex, 1) end)},
	{text=L["Icons"], value=2, func=(function() wFlares:retex(2); wFlaresDB.worldTex=2; UIDropDownMenu_SetSelectedValue(worldTex, 2) end)}
}
local function initialize(self, level)
	local val = UIDROPDOWNMENU_MENU_VALUE
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(worldTexDrop) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v.text
		info.value = v.value
		info.func = v.func
		UIDropDownMenu_AddButton(info, level)
   end
end
UIDropDownMenu_Initialize(worldTex, initialize)
UIDropDownMenu_SetWidth(worldTex, 100);
UIDropDownMenu_SetButtonWidth(worldTex, 124)
UIDropDownMenu_JustifyText(worldTex, "LEFT")
UIDropDownMenu_SetSelectedValue(worldTex, wFlaresDB.worldTex)

checkUpdate = function()
	raidShow:SetChecked(wMarkerDB.shown)
	raidLock:SetChecked(wMarkerDB.locked)
	raidClamp:SetChecked(wMarkerDB.clamped)
	raidFlip:SetChecked(wMarkerDB.flipped)
	raidVert:SetChecked(wMarkerDB.vertical)
	raidParty:SetChecked(wMarkerDB.partyShow)
	raidTarget:SetChecked(wMarkerDB.targetShow)
	raidAssist:SetChecked(wMarkerDB.assistShow)
	raidBG:SetChecked(wMarkerDB.bgHide)
	raidTool:SetChecked(wMarkerDB.tooltips)
	raidScaleText:SetFormattedText("%s: %d%s", L["Raid Markers scale"],math.floor(wMarkerDB.scale*100),"%")
	_G[raidScale:GetName()]:SetValue(wMarkerDB.scale)
	raidAlphaText:SetFormattedText("%s: %d%s",L["Raid Markers alpha"],math.floor(wMarkerDB.alpha*100),"%")
	_G[raidAlpha:GetName()]:SetValue(wMarkerDB.alpha)
	raidSpaceText:SetFormattedText("%s: %d",L["Icon spacing"],wMarkerDB.iconSpace)
	_G[raidSpace:GetName()]:SetValue(wMarkerDB.iconSpace)
	worldShow:SetChecked(wFlaresDB.shown)
	worldLock:SetChecked(wFlaresDB.locked)
	worldClamp:SetChecked(wFlaresDB.clamped)
	worldFlip:SetChecked(wFlaresDB.flipped)
	worldVert:SetChecked(wFlaresDB.vertical)
	worldParty:SetChecked(wFlaresDB.partyShow)
	worldAssist:SetChecked(wFlaresDB.assistShow)
	worldBG:SetChecked(wFlaresDB.bgHide)
	worldTool:SetChecked(wFlaresDB.tooltips)
	worldScaleText:SetFormattedText("%s: %d%s", L["World Markers scale"],math.floor(wFlaresDB.scale*100),"%")
	_G[worldScale:GetName()]:SetValue(wFlaresDB.scale)
	worldAlphaText:SetFormattedText("%s: %d%s", L["World Markers alpha"],math.floor(wFlaresDB.alpha*100),"%")
	_G[worldAlpha:GetName()]:SetValue(wFlaresDB.alpha)
	wFlares:retex(wFlaresDB.worldTex)
	UIDropDownMenu_SetSelectedValue(worldTex,wFlaresDB.worldTex)
end
local function reset()
	for k,v in pairs(wM_defaults) do wMarkerDB[k] = wM_defaults[k] end
	for k,v in pairs(wF_defaults) do wFlaresDB[k] = wF_defaults[k] end
	wMarker.main:ClearAllPoints()
	wMarker.main:SetPoint("LEFT", UIParent,0,108)
	wFlares.main:ClearAllPoints()
	wFlares.main:SetPoint("LEFT", UIParent,0,-110)
	clamp()
	backgroundVisibility()
	wMarker:visibility()
	lock()
	wMarker:orien()
	checkUpdate()
end
wMarker.options.default = reset() -- Assigns the "Default" button in the options frame to the reset function

-------------------------------------------------------
-- OnEvent
-------------------------------------------------------

local update = CreateFrame("Frame");
local event = CreateFrame("Frame");
event:RegisterEvent("ADDON_LOADED");
event:SetScript("OnEvent", function(self,event,addon,...)
	if (event=="ADDON_LOADED") then
		if (addon=="wMarker") then
			for k,v in pairs(wM_defaults) do if wMarkerDB[k] == nil then wMarkerDB[k] = wM_defaults[k] end end
			for k,v in pairs(wF_defaults) do if wFlaresDB[k] == nil then wFlaresDB[k] = wF_defaults[k] end end
			
			if (wMarkerDB.isLocked) then wMarkerDB = {}; wMarker_reset() end -- Overwrite old database from version 1.0
			
			if (wMarkerDB.x==0) and (wMarkerDB.y==0) then 
				local point, relativeTo, relPt, xOff, yOff = wMarker.main:GetPoint()
				wMarkerDB.x = xOff
				wMarkerDB.y = yOff
				wMarkerDB.relPt = relPt
			else
				wMarker.main:SetPoint("CENTER", UIParent, wMarkerDB.relPt, wMarkerDB.x, wMarkerDB.y)
			end
			if (wFlaresDB.x==0) and (wFlaresDB.y==50) then
				local point, relativeTo, relPt, xOff, yOff = wFlares.main:GetPoint()
				wFlaresDB.x = xOff
				wFlaresDB.y = yOff
				wFlaresDB.relPt = relPt
			else
				wFlares.main:SetPoint("CENTER", UIParent, wFlaresDB.relPt, wFlaresDB.x, wFlaresDB.y)
			end		
			wMarker.main:SetScale(wMarkerDB.scale)
			wMarker.main:SetAlpha(wMarkerDB.alpha)
			
			wFlares.main:SetScale(wFlaresDB.scale)
			wFlares.main:SetAlpha(wFlaresDB.alpha)
			
			clamp()
			backgroundVisibility()
			wMarker:visibility()
			lock()
			wMarker:orien()
			wFlares:orien()
			checkUpdate()
		end
	elseif (event=="RAID_ROSTER_UPDATE") or (event=="PLAYER_TARGET_CHANGED") or (event=="PARTY_CONVERTED_TO_RAID") then
		wMarker:visibility()
	elseif (event=="PLAYER_REGEN_ENABLED") then
		
		-- Based on Shadowed's Out of Combat function queue
		for func, handler in pairs(queuedFuncs) do
			if (type(handler)=="table") then
				handler[func](hander);
			elseif (type(func)=="string") then
				_G[func]();
			else
				func();
			end
		end
		
		for func in pairs(queuedFuncs) do
			queuedFuncs[func] = nil;
		end
	
		if (combatWait==true) then
			update:SetScript("OnUpdate",function(self,elap) 
				update.e = update.e+elap;
				if (update.e >= 0.5) then
					if not InCombatLockdown() then		
						wMarker:visibility();
						wFlares:orien();
					end
					update.e = 0;
				end
			end)
		end
	end
end)
event:RegisterEvent("RAID_ROSTER_UPDATE")
--event:RegisterEvent("PARTY_CONVERTED_TO_RAID") --TODO aby8
event:RegisterEvent("PLAYER_TARGET_CHANGED")
event:RegisterEvent("PLAYER_REGEN_ENABLED")
event:RegisterEvent("PLAYER_REGEN_DISABLED")
event:RegisterEvent("UPDATE_BINDINGS")

-------------------------------------------------------
-- OnUpdate
-------------------------------------------------------

update.e = 0;
update:SetScript("OnUpdate",function(self,elap) 
	update.e = update.e+elap;
	if (update.e >= 0.5) then
		if not InCombatLockdown() then		
			wMarker:visibility();
			wFlares:orien();
			self:SetScript("OnUpdate",nil);
		end
		update.e = 0;
	end
end)
