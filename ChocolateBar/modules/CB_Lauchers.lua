-- Broker_MicroMenu by yess
local addonName = "CB_Laucher"
local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local Drag = ChocolateBar.Drag
local ldb = LibStub:GetLibrary("LibDataBroker-1.1",true)
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")
local debug = ChocolateBar and ChocolateBar.debug or function() end

local _G, floor, string, GetNetStats, GetFramerate  = _G, floor, string, GetNetStats, GetFramerate
local delay, counter = 1,0
local dataobj, tooltip, db
local color = true
local path = "Interface\\AddOns\\Broker_MicroMenu\\media\\"
local _
local launcherFrame
local chocolates = {}

dataobj = ldb:NewDataObject(addonName, {
	type = "data source",
	icon = path.."green.tga",
	label = "CB_MoreChocolate",
	text  = "More Chocolate",
	OnClick = function(self, button, ...)
    debug(self)
    if button == "RightButton" then
			if _G.IsModifierKeyDown() then
				mainmenu(self, button, ...)
			else
				dataobj:OpenOptions()
			end
		else
			_G.ToggleCharacter("PaperDollFrame")
		end
		LibQTip:Release(tooltip)
		tooltip = nil
	end
})

-- GetAnchors code taken with permission from fortress
local function GetAnchors(frame)
	local x, y = frame:GetCenter()
	local leftRight
	if x < _G.GetScreenWidth() / 2 then
		leftRight = "LEFT"
	else
		leftRight = "RIGHT"
	end
	if y < _G.GetScreenHeight() / 2 then
		return "BOTTOM", "TOP"
	else
		return "TOP", "BOTTOM"
	end
end

local function PrepareTooltip(frame, anchorFrame)
	if frame and anchorFrame then
		frame:ClearAllPoints()
		if frame.SetOwner then
			frame:SetOwner(anchorFrame, "ANCHOR_NONE")
		end
		local a1, a2 = GetAnchors(anchorFrame)
		frame:SetPoint(a1, anchorFrame, a2)
	end
end

function dataobj:OnLeave()
	local frame = GetMouseFocus()
	if frame and not frame.isOwn then
    --debug("dataobj:OnLeave() Hide", frame:GetName(), frame.isOwn)
		launcherFrame:Hide()
	end
end

local function MouseHandler(self, ...)
  --debug("MouseHandler", self, choco, dataobj.frame, ...)
  launcherFrame:Hide()

	if self.obj.OnClick then
	  self.obj.OnClick(self, ...)
	end
end

local function getLauncherFrame()
	if not launcherFrame then
		local frame = CreateFrame("Frame", "CB_LaunchersFrame", _G.UIParent, BackdropTemplateMixin and "BackdropTemplate")
		frame:SetWidth(200)
		frame:SetHeight(200)

		frame:SetBackdrop({bgFile = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Parchment-Horizontal-Desaturated",
				edgeFile = "Interface\\LFGFrame\\LFGBorder",
				tile = false, tileSize = 4, edgeSize = 4,
				insets = { left = 2, right = 2, top = 2, bottom = 2 }});
		--dropFrames:SetBackdropColor(0,0,0,1)
		--launcherFrame.text = dropFrames:CreateFontString(nil, nil, "GameFontHighlight")
		--launcherFrame.text:SetPoint("CENTER",0, -40)
    --infotitle:SetFormattedText("|T%s:%d|t%s", "Interface\\FriendsFrame\\InformationIcon", 16, L["Notes"])
		--launcherFrame.text:SetFormattedText("|T%s:%d|t%s", "Interface\\FriendsFrame\\InformationIcon", 16, " " .. L["Drop a Plugin onto any of the icons above."])
		launcherFrame  = frame
		launcherFrame.lastY = 0
		frame.isOwn = true
		frame:SetScript("OnLeave", dataobj.OnLeave)
	end
	return launcherFrame
end

local function OnDragStart(self)
	

		self:StartMoving()
		self.isMoving = true
		--self:highlight(1)
		Drag:Start(dataobj.bar, self.name, self)
		--ChocolateBar:SetDropPoins(frame)
end

local function OnDragStop(self)
	debug(OnDragStop, self:GetName())
end

local function addChocolate(name, obj)
  local frame = CreateFrame("Button", "CB_LaunchersFrame"..name, launcherFrame)
	frame.isOwn = true
 	frame:SetWidth(200)
 	frame:SetHeight(20)
 	frame:SetFrameStrata("DIALOG")
 	frame:SetPoint("TOPLEFT",0,launcherFrame.lastY - 3)
  launcherFrame.lastY = launcherFrame.lastY-20
	frame:SetScript("OnLeave", dataobj.OnLeave)

	local tex = frame:CreateTexture()
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetTexture(obj.icon)
	tex:SetPoint("TOPLEFT",5,-2)

	frame.text = frame:CreateFontString(nil, nil, "GameFontHighlight")
	frame.text:SetPoint("LEFT",20 + 3 + 3, 0)
	frame.text:SetText(name)
  frame.obj = obj

	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick", MouseHandler)
	frame:RegisterForDrag("LeftButton")


	frame:SetScript("OnDragStart", OnDragStart)
	frame:SetScript("OnDragStop", OnDragStop)

	--frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",			edgeFile = "Interface\\LFGFrame\\LFGBorder", tile = false, tileSize = 4, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
	--frame:SetBackdropColor(1,0,0,1)
end

function dataobj:OnEnter()

  if not launcherFrame then
	  launcherFrame = getLauncherFrame()
	  PrepareTooltip(launcherFrame, self)
	  
     dataobj.frame = self

    local count = 0
	  for name, choco in pairs(ChocolateBar:GetChocolates()) do
	    local obj = choco.obj
	    addChocolate(name, obj)
      count = count + 1
			--local y, x = tooltip:AddLine()
	    --tooltip:SetCell(y, 1, obj.icon, myProvider)
	    --tooltip:SetCell(y, 2, name)
	  	--tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, choco)
		end

		launcherFrame:SetHeight(count * 20 + 6)
	end

	launcherFrame:Show()

end
