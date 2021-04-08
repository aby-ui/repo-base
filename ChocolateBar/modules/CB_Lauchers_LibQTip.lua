-- Broker_MicroMenu by yess
local addonName = "CB_Laucher"
local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1",true)
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")

local _G, floor, string, GetNetStats, GetFramerate  = _G, floor, string, GetNetStats, GetFramerate
local delay, counter = 1,0
local dataobj, tooltip, db
local color = true
local path = "Interface\\AddOns\\Broker_MicroMenu\\media\\"
local _

local debug = ChocolateBar and ChocolateBar.Debug or function() end or function() end

local function RGBToHex(r, g, b)
	return ("%02x%02x%02x"):format(r*255, g*255, b*255)
end

local mb = _G.MainMenuMicroButton:GetScript("OnMouseUp")
local function mainmenu(self, ...) self.down = 1; mb(self, ...) end

dataobj = ldb:NewDataObject(addonName, {
	type = "data source",
	icon = path.."green.tga",
	label = "Launchers",
	text  = "Launchers",
	OnClick = function(self, button, ...)

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

local myProvider, cellPrototype = LibQTip:CreateCellProvider()

function cellPrototype:InitializeCell()
	self.texture = self:CreateTexture()
	self.texture:SetAllPoints(self)
end

function cellPrototype:SetupCell(tooltip, value, justification, font, iconCoords, unitID,guild)
	local tex = self.texture
	tex:SetWidth(16)
	tex:SetHeight(16)

	tex:SetTexture(value)

	if iconCoords then
		tex:SetTexCoord(_G.unpack(iconCoords))
	end
	return tex:GetWidth(), tex:GetHeight()
end

function cellPrototype:ReleaseCell()
end

local function MouseHandler(event, choco, button, ...)
  LibQTip:Release(tooltip)
	tooltip = nil

  choco.obj.OnClick(dataobj.frame, button)
end

function dataobj:OnEnter()
  if tooltip then
		LibQTip:Release(tooltip)
	end

  dataobj.frame = self

	tooltip = LibQTip:Acquire(addonName.."Tooltip", 2, "LEFT", "LEFT")
	tooltip:Clear()
	self.tooltip = tooltip

  for name, choco in pairs(ChocolateBar:GetChocolates()) do
    local obj = choco.obj
		if obj.type == "launcher" then
	    local y, x = tooltip:AddLine()
	    tooltip:SetCell(y, 1, obj.icon, myProvider)
	    tooltip:SetCell(y, 2, name)
	  	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, choco)
		end
	end

	tooltip:SetAutoHideDelay(0.001, self)
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end
