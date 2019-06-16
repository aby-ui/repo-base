local _detalhes = 		_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local g =	_detalhes.gump
local _



function _detalhes:OpenNewsWindow (text_to_show, dumpvalues, keeptext)

	_detalhes.latest_news_saw = _detalhes.userversion

	local news_window = _detalhes:CreateOrOpenNewsWindow()
	
	news_window:Title (Loc ["STRING_NEWS_TITLE"])
	
	if (dumpvalues == "change_log" or text_to_show == "LeftButton") then
		news_window:Text (Loc ["STRING_VERSION_LOG"])
		news_window:Icon ([[Interface\AddOns\Details\images\icons2]], {108/512, 189/512, 319/512, 400/512})
		news_window:Show()
		return
	end
	
	if (text_to_show and type (text_to_show) == "table") then
	
		DetailsNewsWindowLower:SetSize (450, 5000)
		DetailsNewsWindowSlider:SetMinMaxValues (0, 5000)
		DetailsNewsWindowText:SetHeight (5000)
		
		local s = ""
		for _, text in ipairs (text_to_show) do
			if (type (text) == "string" or type (text) == "number") then
				s = s .. text .. "\n"
			end
		end
		
		if (dumpvalues) then
			s = _detalhes.table.dump (text_to_show)
		end
		
		if (keeptext) then
			news_window:Text ((DetailsNewsWindowText:GetText() or "") .. "\n\n" .. s)
		else
			if (dumpvalues) then
				news_window.DumpTableFrame:SetText (s)
				-- /run Details:DumpTable (C_NamePlate)
			else
				news_window:Text (s)
			end
		end
	else
	
		if (keeptext) then
			news_window:Text ((DetailsNewsWindowText:GetText() or "") .. "\n\n" .. (text_to_show or Loc ["STRING_VERSION_LOG"]))
		else
			news_window:Text (text_to_show or Loc ["STRING_VERSION_LOG"])
		end

	end
	
	news_window:Icon ([[Interface\AddOns\Details\images\icons2]], {108/512, 189/512, 319/512, 400/512})
	news_window:Show()
end

function _detalhes:CreateOrOpenNewsWindow()
	local frame = _G.DetailsNewsWindow

	-- /script _detalhes.OpenNewsWindow()
	
	if (not frame) then
		--> construir a janela de news
		frame = CreateFrame ("frame", "DetailsNewsWindow", UIParent, "ButtonFrameTemplate")
		frame:SetPoint ("center", UIParent, "center")
		frame:SetFrameStrata ("FULLSCREEN")
		frame:SetMovable (true)
		frame:SetWidth (512)
		frame:SetHeight (512)
		tinsert (UISpecialFrames, "DetailsNewsWindow")

		frame:SetScript ("OnMouseDown", function(self, button)
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
		frame:SetScript ("OnMouseUp", function(self, button) 
			if (self.isMoving and button == "LeftButton") then
				self:StopMovingOrSizing()
				self.isMoving = nil
			end
		end)
		
		--> reinstall textura
		local textura = _detalhes.gump:NewImage (frame, [[Interface\DialogFrame\DialogAlertIcon]], 64, 64, nil, nil, nil, "$parentExclamacao")
		textura:SetPoint ("topleft", frame, "topleft", 60, -10)
		--> reinstall aviso
		local reinstall = _detalhes.gump:NewLabel (frame, nil, "$parentReinstall", nil, "", "GameFontHighlightLeft", 10)
		reinstall:SetPoint ("left", textura, "right", 2, -2)
		reinstall.text = Loc ["STRING_NEWS_REINSTALL"]

		local dumpFrame = g:NewSpecialLuaEditorEntry (frame, 500, 512, "DumpTable", "$parentDumpTable", false)
		local dumpFrame = g:CreateTextEntry (frame, function()end, 500, 512, "DumpTable", "$parentDumpTable")
		dumpFrame.editbox:SetMultiLine (true)
		
		dumpFrame:SetPoint ("topleft", frame, "topleft", 8, -68)
		dumpFrame:SetBackdrop (nil)
		dumpFrame.editbox:SetBackdrop (nil)
		dumpFrame.editbox:SetJustifyH ("left")
		dumpFrame.editbox:SetJustifyV ("top")
		
		--dumpFrame.editor:SetBackdrop (nil)
		frame.DumpTableFrame = dumpFrame
		
		local frame_upper = CreateFrame ("scrollframe", nil, frame)
		local frame_lower = CreateFrame ("frame", "DetailsNewsWindowLower", frame_upper)
		frame_lower:SetSize (450, 2000)
		frame_upper:SetPoint ("topleft", frame, "topleft", 15, -70)
		frame_upper:SetWidth (465)
		frame_upper:SetHeight (400)
		frame_upper:SetBackdrop({
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
				tile = true, tileSize = 16,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})
		frame_upper:SetBackdropColor (.1, .1, .1, .3)
		frame_upper:SetScrollChild (frame_lower)
		
		local slider = CreateFrame ("slider", "DetailsNewsWindowSlider", frame)
		slider.bg = slider:CreateTexture (nil, "background")
		slider.bg:SetAllPoints (true)
		slider.bg:SetTexture (0, 0, 0, 0.5)
		
		slider.thumb = slider:CreateTexture (nil, "OVERLAY")
		slider.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
		slider.thumb:SetSize (25, 25)
		
		slider:SetThumbTexture (slider.thumb)
		slider:SetOrientation ("vertical");
		slider:SetSize (16, 399)
		slider:SetPoint ("topleft", frame_upper, "topright")
		slider:SetMinMaxValues (0, 2000)
		slider:SetValue(0)
		slider:SetScript("OnValueChanged", function (self)
		      frame_upper:SetVerticalScroll (self:GetValue())
		end)
  
		frame_upper:EnableMouseWheel (true)
		frame_upper:SetScript("OnMouseWheel", function (self, delta)
		      local current = slider:GetValue()
		      if (IsShiftKeyDown() and (delta > 0)) then
				slider:SetValue(0)
		      elseif (IsShiftKeyDown() and (delta < 0)) then
				slider:SetValue (2000)
		      elseif ((delta < 0) and (current < 2000)) then
				slider:SetValue (current + 20)
		      elseif ((delta > 0) and (current > 1)) then
				slider:SetValue (current - 20)
		      end
		end)

		--> text box
		local texto = frame_lower:CreateFontString ("DetailsNewsWindowText", "overlay", "GameFontNormal")
		texto:SetPoint ("topleft", frame_lower, "topleft")
		texto:SetJustifyH ("left")
		texto:SetJustifyV ("top")
		texto:SetTextColor (1, 1, 1)
		texto:SetWidth (450)
		texto:SetHeight (2500)
		-- /script _detalhes.OpenNewsWindow()
		--> forum text
		local forum_button = CreateFrame ("Button", "DetailsNewsWindowForumButton", frame, "OptionsButtonTemplate")
		forum_button:SetPoint ("bottomleft", frame, "bottomleft", 10, 4)
		forum_button:SetText ("Forum Thread")
		forum_button:SetScript ("OnClick", function (self)
			--> copy and paste
			_detalhes:CopyPaste ("http://www.mmo-champion.com/threads/1480721-New-damage-meter-%28Details!%29-need-help-with-tests-and-feedbacks")
		end)
		forum_button:SetWidth (130)
		
		local forum_button_texto = frame:CreateFontString ("DetailsNewsWindowForumButtonText", "overlay", "GameFontHighlightSmall")
		forum_button_texto:SetPoint ("left", forum_button, "right", 3, 0)
		forum_button_texto:SetText ("on mmo-champions, for feedback, feature request, bug report.")
		forum_button_texto:SetTextColor (.7, .7, .7, 1)
		
		function frame:Title (title)
			frame.TitleText:SetText (title or "")
		end
		
		function frame:Text (text)
			texto:SetText (text or "")
		end
		
		function frame:Icon (path, coords)
			frame.portrait:SetTexture (path or nil)
			if (coords) then
				frame.portrait:SetTexCoord (unpack (coords))
			else
				frame.portrait:SetTexCoord (0, 1, 0, 1)
			end
		end
		
		frame:Hide()
	end
	
	return frame
end
