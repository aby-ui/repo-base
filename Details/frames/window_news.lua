local Details = 		_G.Details
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local g =	Details.gump
local _

function Details:OpenNewsWindow(textToShow, dumpValues, keeptext)

	Details.latest_news_saw = Details.userversion

	local newsFrame = Details:CreateOrOpenNewsWindow()

	if (dumpValues == "change_log" or textToShow == "LeftButton") then
		newsFrame:Text (Loc ["STRING_VERSION_LOG"])
		newsFrame:Show()
		return
	end
	
	if (textToShow and type (textToShow) == "table") then
		DetailsNewsWindowLower:SetSize (450, 5000)
		DetailsNewsWindowSlider:SetMinMaxValues (0, 5000)
		DetailsNewsWindowText:SetHeight (5000)
		
		local s = ""
		for _, text in ipairs (textToShow) do
			if (type (text) == "string" or type (text) == "number") then
				s = s .. text .. "\n"
			end
		end
		
		if (dumpValues) then
			s = Details.table.dump (textToShow)
		end
		
		if (keeptext) then
			newsFrame:Text ((DetailsNewsWindowText:GetText() or "") .. "\n\n" .. s)
		else
			if (dumpValues) then
				newsFrame.DumpTableFrame:SetText (s)
			else
				newsFrame:Text (s)
			end
		end
	else
		if (keeptext) then
			newsFrame:Text ((DetailsNewsWindowText:GetText() or "") .. "\n\n" .. (textToShow or Loc ["STRING_VERSION_LOG"]))
		else
			--show news
			newsFrame:Text (textToShow or Loc["STRING_VERSION_LOG"])
			--show textures
			if (_detalhes.build_counter == 8154) then
				newsFrame.imageFrame:Show()
				newsFrame.imageFrame.texture:SetTexture([[interface/addons/details/images/news_images]])
				newsFrame.imageFrame.texture:SetSize(279, 452)
				newsFrame.imageFrame.texture:SetTexCoord(0, 279/512, 0, 452/512)
			end
		end
	end

	newsFrame:Show()
end

function Details:CreateOrOpenNewsWindow()
	local frame = _G.DetailsNewsWindow
	
	if (not frame) then
		--build news frame

		frame = DetailsFramework:CreateSimplePanel(UIParent, 480, 460, "Details! Damage Meter " .. Details.version, "DetailsNewsWindow", panel_options, db)
		tinsert(UISpecialFrames, "DetailsNewsWindow")
		frame:SetPoint("left", UIParent, "left", 10, 0)
		frame:SetFrameStrata("FULLSCREEN")
		frame:SetMovable(true)
		frame:Hide()
		DetailsFramework:ApplyStandardBackdrop(frame)

		frame.imageFrame = CreateFrame("frame", "DetailsNewsWindowImageFrame", frame, "BackdropTemplate")
		frame.imageFrame:SetPoint("topleft", frame, "topright", 2, 0)
		frame.imageFrame:SetPoint("bottomleft", frame, "bottomright", 2, 0)
		frame.imageFrame:SetWidth(256)
		DetailsFramework:ApplyStandardBackdrop(frame.imageFrame)
		frame.imageFrame:Hide()
		frame.imageFrame.texture = frame.imageFrame:CreateTexture(nil, "overlay")
		frame.imageFrame.texture:SetPoint("topleft", frame.imageFrame, "topleft")

		local dumpFrame = g:CreateTextEntry(frame, function()end, 500, 512, "DumpTable", "$parentDumpTable")
		dumpFrame.editbox:SetMultiLine (true)
		
		dumpFrame:SetPoint("topleft", frame, "topleft", 8, -68)
		dumpFrame:SetBackdrop(nil)
		dumpFrame.editbox:SetBackdrop(nil)
		dumpFrame.editbox:SetJustifyH("left")
		dumpFrame.editbox:SetJustifyV("top")
		
		frame.DumpTableFrame = dumpFrame
		
		local frame_upper = CreateFrame("scrollframe", nil, frame, "BackdropTemplate")
		local frame_lower = CreateFrame("frame", "DetailsNewsWindowLower", frame_upper, "BackdropTemplate")

		frame_lower:SetSize (450, 2000)
		frame_upper:SetPoint ("topleft", frame, "topleft", 10, -30)
		frame_upper:SetWidth(445)
		frame_upper:SetHeight(400)
		frame_upper:SetBackdrop({
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
				tile = true, tileSize = 16,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})
		frame_upper:SetBackdropColor (.1, .1, .1, .3)
		frame_upper:SetScrollChild (frame_lower)
		
		local slider = CreateFrame ("slider", "DetailsNewsWindowSlider", frame, "BackdropTemplate")
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
		local texto = frame_lower:CreateFontString("DetailsNewsWindowText", "overlay", "GameFontNormal")
		texto:SetPoint("topleft", frame_lower, "topleft")
		texto:SetJustifyH("left")
		texto:SetJustifyV("top")
		texto:SetTextColor(1, 1, 1)
		texto:SetWidth(450)
		texto:SetHeight(2500)

		local statusBar = CreateFrame("frame", nil, frame, "BackdropTemplate")
		statusBar:SetPoint("bottomleft", frame, "bottomleft")
		statusBar:SetPoint("bottomright", frame, "bottomright")
		statusBar:SetHeight(20)

		local onToggleAutoOpen = function(_, _, state)
			Details.auto_open_news_window = state
		end
		local autoOpenCheckbox = DetailsFramework:CreateSwitch(statusBar, onToggleAutoOpen, Details.auto_open_news_window, _, _, _, _, "AutoOpenCheckbox", _, _, _, _, _, DetailsFramework:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		autoOpenCheckbox:SetAsCheckBox()
		autoOpenCheckbox:SetPoint("left", statusBar, "left", 2, 0)

		local autoOpenText = DetailsFramework:CreateLabel(statusBar, "Auto Open on New Changes")
		autoOpenText:SetPoint("left", autoOpenCheckbox, "right", 2, 0)

		DetailsFramework:ApplyStandardBackdrop(statusBar)
		statusBar:SetAlpha (0.8)
		DetailsFramework:BuildStatusbarAuthorInfo(statusBar, "", "")
		statusBar.authorName:SetPoint ("left", statusBar, "left", 207, 0)


		function frame:Title (title)
			frame:SetTitle(title or "")
		end

		function frame:Text (text)
			texto:SetText (text or "")
		end

		frame:Hide()
	end
	
	return frame
end
