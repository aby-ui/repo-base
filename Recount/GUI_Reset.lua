local Recount = _G.Recount

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Recount")

local revision = tonumber(string.sub("$Revision: 1254 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local CreateFrame = CreateFrame
local UIParent = UIParent

local me = {}

function me:CreateResetWindow()
	me.ResetFrame = CreateFrame("Frame", nil, UIParent)

	local theFrame = me.ResetFrame

	theFrame:ClearAllPoints()
	theFrame:SetPoint("CENTER",UIParent)
	theFrame:SetHeight(78)
	theFrame:SetWidth(200)

	theFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\Recount\\textures\\otravi-semi-full-border", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})
	theFrame:SetBackdropBorderColor(1.0, 0.0, 0.0)
	theFrame:SetBackdropColor(24 / 255, 24 / 255, 24 / 255)
	Recount.Colors:RegisterBorder("Other Windows","Title",theFrame)
	Recount.Colors:RegisterBackground("Other Windows","Background",theFrame)

	theFrame:EnableMouse(true)
	theFrame:SetMovable(true)


	theFrame:SetScript("OnMouseDown", function(this, button)
		if (((not this.isLocked) or (this.isLocked == 0)) and (button == "LeftButton")) then
			Recount:SetWindowTop(this)
			this:StartMoving()
			this.isMoving = true
		end
	end)
	theFrame:SetScript("OnMouseUp", function(this)
		if (this.isMoving) then
			this:StopMovingOrSizing()
			this.isMoving = false
		end
	end)
	theFrame:SetScript("OnShow", function(this)
		Recount:SetWindowTop(this)
	end)
	theFrame:SetScript("OnHide", function(this)
		if (this.isMoving) then
			this:StopMovingOrSizing()
			this.isMoving = false
		end
	end)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -15)
	theFrame.Title:SetTextColor(1.0, 1.0, 1.0, 1.0)
	theFrame.Title:SetText(L["Reset Recount?"])
	Recount:AddFontString(theFrame.Title)

	--Recount.Colors:UnregisterItem(me.ResetFrame.Title)
	Recount.Colors:RegisterFont("Other Windows", "Title Text", me.ResetFrame.Title)

	theFrame.Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Text:SetPoint("CENTER", theFrame, "CENTER", 0, -3)
	theFrame.Text:SetTextColor(1.0, 1.0, 1.0)
	theFrame.Text:SetText(L["Do you wish to reset the data?"])
	Recount:AddFontString(theFrame.Text)

	theFrame.YesButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.YesButton:SetWidth(90)
	theFrame.YesButton:SetHeight(24)
	theFrame.YesButton:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOM", -4, 4)
	theFrame.YesButton:SetScript("OnClick", function()
		Recount:ResetData()theFrame:Hide()
	end)
	theFrame.YesButton:SetText(L["Yes"])

	theFrame.NoButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.NoButton:SetWidth(90)
	theFrame.NoButton:SetHeight(24)
	theFrame.NoButton:SetPoint("BOTTOMLEFT", theFrame, "BOTTOM", 4, 4)
	theFrame.NoButton:SetScript("OnClick", function()
		theFrame:Hide()
	end)
	theFrame.NoButton:SetText(L["No"])

	theFrame:Hide()

	theFrame:SetFrameStrata("DIALOG")

	--Need to add it to our window ordering system
	Recount:AddWindow(theFrame)
end

function Recount:ShowReset()
	if me.ResetFrame == nil then
		me:CreateResetWindow()
	end

	me.ResetFrame:Show()
end
