local LibStub = LibStub
local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local debug = ChocolateBar and ChocolateBar.debug or function() end

local GameMusic = {}
local addonName = "CB_Entertainer"

local dataobj = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
	type = "data source",
	--icon = "Interface\\AddOns\\ChocolateBar\\pics\\ChocolatePiece",
	label = addonName,
	text  = "Volume: ---",
	OnClick = OnClick,
	OnMouseWheel = OnMouseWheel,
	ChocolateBar = true
})

local function mute(self)
	debug("mute")
end

function dataobj:OnMouseWheel(vector)
	debug(vector)
	local cVar = "Sound_MasterVolume" --Sound_MusicVolume  Sound_SFXVolume
	local vol = GetCVar(cVar)
	local step = IsAltKeyDown() and vector * .01 or vector * .1
	vol = vol + step
	if vol > 1 then vol = 1 end
	if vol < 0 then vol = 0 end
	SetCVar(vol, voltypeCVar);
	dataobj.text = "Master: "..math.floor((_G.GetCVar(cVar)*100)).."%"
end

local function OnClick(self, btn)
	if btn == "LeftButton" then
			mute()
		else
			showList(self)
		end
end


local function showList(self)
	local LibQTip = LibStub("LibQTip-1.0")
	if tooltip then	LibQTip:Release(tooltip) end

	dataobj.frame = self

	tooltip = LibQTip:Acquire(addonName.."Tooltip", 2, "LEFT", "LEFT")
	tooltip:Clear()
	self.tooltip = tooltip

	for name, choco in pairs(ChocolateBar:GetChocolates()) do
		local obj = choco.obj
		local y, x = tooltip:AddLine()
		tooltip:SetCell(y, 1, obj.icon, myProvider)
		tooltip:SetCell(y, 2, name)
		tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, choco)
	end

	tooltip:SetAutoHideDelay(0.001, self)
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end
