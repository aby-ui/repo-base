local _, namespace = ... 	--localization
local L = namespace.L 				--localization

-- ------------------------------------------------
-- -- DCS Character Frame Expand/Collapse Button --
-- ------------------------------------------------
local DCS_tooltipText
local PaperDollFrame = PaperDollFrame
local CharacterFrame = CharacterFrame
local function DCS_ExpandCheck_OnEnter(self)
	GameTooltip:SetOwner(PaperDollFrame.ExpandButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(DCS_tooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DCS_ExpandCheck_OnLeave(self)
	GameTooltip_Hide()
 end
 
local _, gdbprivate = ...
	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsExpandChecked = {
		ExpandSetChecked = true,
}

	PaperDollFrame.ExpandButton = CreateFrame("Button", nil, PaperDollFrame)
	PaperDollFrame.ExpandButton:SetSize(32, 32)
	PaperDollFrame.ExpandButton:SetPoint("BOTTOMLEFT", 298, 3)
	--PaperDollFrame.ExpandButton:SetPoint("TOPRIGHT", CharacterTrinket1Slot, "BOTTOMRIGHT", 2, -3)
	PaperDollFrame.ExpandButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight")
	
	PaperDollFrame.ExpandButton:SetScript("OnEnter", DCS_ExpandCheck_OnEnter)
	PaperDollFrame.ExpandButton:SetScript("OnLeave", DCS_ExpandCheck_OnLeave)
			 
	PaperDollFrame.ExpandButton:SetScript("OnMouseUp", function (self)
		if (CharacterFrame.Expanded) then
			CharacterFrame_Collapse()
			self:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			self:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
			DCS_tooltipText = L['Show Character Stats'] --Creates a tooltip on mouseover.
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked = false
		else
			CharacterFrame_Expand()
			self:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
			self:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
			DCS_tooltipText = L['Hide Character Stats'] --Creates a tooltip on mouseover.
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked = true
		end
		self.Collapsed = not CharacterFrame.Expanded
		DCS_ExpandCheck_OnEnter()
	end)

	PaperDollFrame:HookScript("OnShow", function(self)
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
		if checked == true then
			CharacterFrame_Expand()
			PaperDollFrame.ExpandButton:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
			PaperDollFrame.ExpandButton:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
			DCS_tooltipText = L['Hide Character Stats'] --Creates a tooltip on mouseover.
		else
			CharacterFrame_Collapse()
			PaperDollFrame.ExpandButton:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			PaperDollFrame.ExpandButton:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
			DCS_tooltipText = L['Show Character Stats'] --Creates a tooltip on mouseover.
		end
	end)


--------------------------
-- Toggle Expand Button --
--------------------------

local _, gdbprivate = ...
	gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsExpandButtonChecked = {
		ExpandButtonSetChecked = true,
}
local DCS_ExpandButtonCheck = CreateFrame("CheckButton", "DCS_ExpandButtonCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ExpandButtonCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ExpandButtonCheck:ClearAllPoints()
	DCS_ExpandButtonCheck:SetPoint("LEFT", 30, -205)
	DCS_ExpandButtonCheck:SetScale(1)
	DCS_ExpandButtonCheck.tooltipText = L['Displays the Expand button for the character stats frame.'] --Creates a tooltip on mouseover.
	_G[DCS_ExpandButtonCheck:GetName() .. "Text"]:SetText(L["Expand"])
	
	DCS_ExpandButtonCheck:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked
			self:SetChecked(checked)
			if checked then
				PaperDollFrame.ExpandButton:Show()
			else
				PaperDollFrame.ExpandButton:Hide()
			end
		end
		--[[
		if event == "PLAYER_LOGIN" then
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked
			self:SetChecked(checked.ExpandButtonSetChecked)
			if self:GetChecked(true) then
				PaperDollFrame.ExpandButton:Show()
				gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked = true
			else
				PaperDollFrame.ExpandButton:Hide()
				gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked = false
			end
		end
		--]]
	end)

	DCS_ExpandButtonCheck:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked = checked
		if checked then
			PaperDollFrame.ExpandButton:Show()
		else
			PaperDollFrame.ExpandButton:Hide()
		end
		--[[
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked
		if self:GetChecked(true) then
			PaperDollFrame.ExpandButton:Show()
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked = true
		else
			PaperDollFrame.ExpandButton:Hide()
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked = false
		end
		--]]
	end)
