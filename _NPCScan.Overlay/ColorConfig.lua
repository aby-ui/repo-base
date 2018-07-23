--[[****************************************************************************
	Controlls for changing the map path and key coloring
  ****************************************************************************]]

local FOLDER_NAME, private = ...
local L = private.L
local panel = CreateFrame("Frame", "_NPCScanOverlayPathColorList")
private.ColorConfig = panel
tinsert(UISpecialFrames, "_NPCScanOverlayPathColorList")

local modify_id
local modify_Line
local r, g, b, a = 1, 0, 0, 1
local Count = 0
local Height, Width

-- Pane title
panel.Title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
panel.Title:SetPoint("TOPLEFT", 16, -16)
panel.Title:SetText(L.CONFIG_COLORLIST_LABEL)
local SubText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
panel.SubText = SubText
SubText:SetPoint("TOPLEFT", panel.Title, "BOTTOMLEFT", 0, -8)
SubText:SetPoint("RIGHT", -32, 0)
SubText:SetHeight(32)
SubText:SetJustifyH("LEFT")
SubText:SetJustifyV("TOP")
SubText:SetText(L.CONFIG_COLORLIST_INST)

panel:SetFrameStrata("DIALOG")
panel:SetWidth(250)
panel:SetHeight(250)
panel:SetBackdrop({
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 32,
	insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
panel:SetBackdropColor(0, 0, 0, 1)
panel:SetPoint("CENTER", 0, 0)
panel:Hide()

local function ShowColorPicker(r, g, b, a, changedCallback)
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
	ColorPickerFrame.previousValues = { r, g, b, a }
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
	changedCallback, changedCallback, changedCallback
	ColorPickerFrame:Hide() -- Need to run the OnShow handler.
	ColorPickerFrame:Show()
end


local function myColorCallback(restore)
	local newR, newG, newB, newA
	if restore then
		-- The user bailed, we extract the old color from the table created by ShowColorPicker.
		newR, newG, newB, newA = unpack(restore)
	else
		-- Something changed
		newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
	end
	-- Update our internal storage.
	r, g, b, a = newR, newG, newB, newA
	-- And update any UI elements that use this color...
	modify_Line.Text:SetTextColor(r, g, b, a)
	private.OverlayKeyColors[modify_id].r = r
	private.OverlayKeyColors[modify_id].g = g
	private.OverlayKeyColors[modify_id].b = b
end

-- Module options scrollframe
local Background = CreateFrame("Frame", nil, panel, "OptionsBoxTemplate")
Background:SetPoint("TOPLEFT", panel.SubText, 5, -18)
Background:SetPoint("BOTTOMRIGHT", -32, 50)
local Texture = Background:CreateTexture(nil, "BACKGROUND")
Texture:SetTexture(0, 0, 0, 0.5)
Texture:SetPoint("BOTTOMLEFT", 5, 5)
Texture:SetPoint("TOPRIGHT", -5, -5)

local ScrollFrame = CreateFrame("ScrollFrame", "_NPCScanOverlayScrollFrame", Background, "UIPanelScrollFrameTemplate")
ScrollFrame:SetPoint("TOPLEFT", 4, -4)
ScrollFrame:SetPoint("BOTTOMRIGHT", -4, 4)

panel.ScrollChild = CreateFrame("Frame")
ScrollFrame:SetScrollChild(panel.ScrollChild)
panel.ScrollChild:SetSize(1, 1)

local function AddLine(R, G, B)
	Count = Count + 1
	local line = CreateFrame("Button", "ColorSpot" .. Count, panel.ScrollChild)
	line:SetWidth(100)
	line:SetHeight(10)
	line.Text = line:CreateFontString()
	line.Text:SetFontObject(GameFontNormal)
	line.Text:SetAllPoints()
	line:SetID(Count)
	line:SetPoint("TOPLEFT", 5, -15 * Count)
	line.Text:SetText(L.CONFIG_COLORLIST_PLACEHOLDER .. Count)
	line.Text:SetTextColor(R, G, B)
	line:SetScript("OnClick", function(self)
		modify_id = self:GetID()
		modify_Line = self
		ShowColorPicker(R, G, B, nil, myColorCallback)
	end)
end

panel.Close = CreateFrame("Button", "SetColorCloseButton", _NPCScanOverlayPathColorList, "UIPanelButtonTemplate")
panel.Close:SetPoint("BOTTOM", 0, 15)
_G[panel.Close:GetName() .. "Text"]:SetText(_G.CLOSE)
panel.Close:SetScript("OnClick", function() _NPCScanOverlayPathColorList:Hide() end)
panel.Close:SetWidth(SetColorCloseButtonText:GetStringWidth() + 30)
panel.Close.tooltipText = L.CONFIG_SETCOLOR_DESC

local function OnShow(...)
	if Count == 0 then
		for x, y in pairs(private.OverlayKeyColors) do
			AddLine(y.r, y.g, y.b)
		end
	end
end

panel:SetScript("OnShow", OnShow)

