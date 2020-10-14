do

	local _detalhes = _G._detalhes
	local DetailsFrameWork = _detalhes.gump
	local _
--> panel
	
	function _detalhes:CreateCopyPasteWindow()
	
		local panel = CreateFrame ("frame", "DetailsCopy", UIParent, "ButtonFrameTemplate")
		panel:SetSize (512, 148)
		tinsert (UISpecialFrames, "DetailsCopy")
		panel:SetFrameStrata ("TOOLTIP")
		panel:SetPoint ("center", UIParent, "center")
		panel.locked = false
		panel:SetToplevel (true)
		panel:SetMovable (true)
		panel:SetScript ("OnMouseDown", function(self, button)
			if (self.isMoving) then
				return
			end
			if (button == "RightButton") then
				self:Hide()
			else
				self:StartMoving() 
				self.isMoving = true
			end
		end)
		panel:SetScript ("OnMouseUp", function(self, button) 
			if (self.isMoving and button == "LeftButton") then
				self:StopMovingOrSizing()
				self.isMoving = nil
			end
		end)
		
		DetailsFrameWork:NewImage (panel, "Interface\\AddOns\\Details\\images\\copy", 512, 128, "overlay", nil, "background", "$parentBackGround")
		panel.background:SetPoint (0, -25)
		
		--> title
		panel.TitleText:SetText ("Paste & Copy")
		panel.portrait:SetTexture ([[Interface\CHARACTERFRAME\TEMPORARYPORTRAIT-FEMALE-BLOODELF]])
		
		DetailsFrameWork:NewTextEntry (panel, _, "$parentTextEntry", "text", 476, 14)
		panel.text:SetPoint (20, -127)
		panel.text:SetHook ("OnEditFocusLost", function() panel:Hide() end)
		panel.text:SetHook ("OnChar", function() panel:Hide() end)
		
		DetailsFrameWork:NewLabel (panel, _, _, "desc", "paste on your web browser address bar", "OptionsFontHighlightSmall", 12)
		panel.desc:SetPoint (340, -78)
		panel.desc.width = 150
		panel.desc.height = 25
		panel.desc.align = "|"
		panel.desc.color = "gray"
		
		panel:Hide()
	end
	
	function _detalhes:CopyPaste (link)
		_G.DetailsCopy.text.text = link
		_G.DetailsCopy.text:HighlightText()
		_G.DetailsCopy:Show()
		_G.DetailsCopy.text:SetFocus()

	end
end
