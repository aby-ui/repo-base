
local Details = 		_G.Details
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
local gump = Details.gump
local _, Details222 = ...
_ = nil

function Details:OpenNewsWindow(textToShow, dumpValues, keeptext)
	Details.latest_news_saw = Details.userversion

	local newsFrame = Details:CreateOrOpenNewsWindow()
	local animationHub = DetailsFramework:CreateAnimationHub(newsFrame)
	local fadeInAnim1 = DetailsFramework:CreateAnimation(animationHub, "alpha", 1, 0.2, 0, 0.2)
	local fadeInAnim2 = DetailsFramework:CreateAnimation(animationHub, "alpha", 2, 1.5, 0.5, 1)
	fadeInAnim2:SetStartDelay(1.3)

	if (dumpValues == "change_log" or textToShow == "LeftButton") then
		newsFrame:Text (Loc ["STRING_VERSION_LOG"])
		newsFrame:Show()
		return
	end

	if (textToShow and type(textToShow) == "table") then
		DetailsNewsWindowLower:SetSize(450, 5000)
		DetailsNewsWindowSlider:SetMinMaxValues(0, 5000)
		DetailsNewsWindowText:SetHeight(5000)

		local returnString = ""
		for _, text in ipairs(textToShow) do
			if (type(text) == "string" or type(text) == "number") then
				returnString = returnString .. text .. "\n"
			end
		end

		if (dumpValues) then
			returnString = Details.table.dump(textToShow)
		end

		if (keeptext) then
			newsFrame:Text((DetailsNewsWindowText:GetText() or "") .. "\n\n" .. returnString)
		else
			if (dumpValues) then
				newsFrame.DumpTableFrame:SetText(returnString)
			else
				newsFrame:Text (returnString)
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
	animationHub:Play()
end

function Details:CreateOrOpenNewsWindow()
	local frame = _G.DetailsNewsWindow

	if (not frame) then
		frame = DetailsFramework:CreateSimplePanel(UIParent, 480, 560, "Details! Damage Meter " .. Details.version, "DetailsNewsWindow", panel_options, db)
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

		local dumpFrame = gump:CreateTextEntry(frame, function()end, 500, 612, "DumpTable", "$parentDumpTable")
		dumpFrame.editbox:SetMultiLine(true)

		dumpFrame:SetPoint("topleft", frame, "topleft", 8, -68)
		dumpFrame:SetBackdrop(nil)
		dumpFrame.editbox:SetBackdrop(nil)
		dumpFrame.editbox:SetJustifyH("left")
		dumpFrame.editbox:SetJustifyV("top")

		frame.DumpTableFrame = dumpFrame

		local frameUpper = CreateFrame("scrollframe", nil, frame, "BackdropTemplate")
		local frameLower = CreateFrame("frame", "DetailsNewsWindowLower", frameUpper, "BackdropTemplate")

		frameLower:SetSize(450, 2000)
		frameUpper:SetPoint("topleft", frame, "topleft", 10, -30)
		frameUpper:SetWidth(445)
		frameUpper:SetHeight(500)
		frameUpper:SetBackdrop({
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
				tile = true, tileSize = 16,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})
		frameUpper:SetBackdropColor(.1, .1, .1, .3)
		frameUpper:SetScrollChild(frameLower)
		
		local slider = CreateFrame("slider", "DetailsNewsWindowSlider", frame, "BackdropTemplate")
		slider.bg = slider:CreateTexture(nil, "background")
		slider.bg:SetAllPoints(true)
		slider.bg:SetTexture(0, 0, 0, 0.5)
		
		slider.thumb = slider:CreateTexture(nil, "OVERLAY")
		slider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		slider.thumb:SetSize(25, 25)
		
		slider:SetThumbTexture (slider.thumb)
		slider:SetOrientation("vertical");
		slider:SetSize(16, 499)
		slider:SetPoint("topleft", frameUpper, "topright")
		slider:SetMinMaxValues(0, 2000)
		slider:SetValue(0)
		slider:SetScript("OnValueChanged", function(self)
		      frameUpper:SetVerticalScroll (self:GetValue())
		end)

		frameUpper:EnableMouseWheel(true)
		frameUpper:SetScript("OnMouseWheel", function(self, delta)
		      local current = slider:GetValue()
		      if (IsShiftKeyDown() and (delta > 0)) then
				slider:SetValue(0)
		      elseif (IsShiftKeyDown() and (delta < 0)) then
				slider:SetValue(2000)
		      elseif ((delta < 0) and (current < 2000)) then
				slider:SetValue(current + 20)
		      elseif ((delta > 0) and (current > 1)) then
				slider:SetValue(current - 20)
		      end
		end)

		--text box
		local texto = frameLower:CreateFontString("DetailsNewsWindowText", "overlay", "GameFontNormal")
		texto:SetPoint("topleft", frameLower, "topleft")
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
		local autoOpenCheckbox = DetailsFramework:CreateSwitch(statusBar, onToggleAutoOpen, Details.auto_open_news_window, _, _, _, _, "AutoOpenCheckbox", _, _, _, _, _, DetailsFramework:GetTemplate("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		autoOpenCheckbox:SetAsCheckBox()
		autoOpenCheckbox:SetPoint("left", statusBar, "left", 2, 0)

		local autoOpenText = DetailsFramework:CreateLabel(statusBar, "Auto Open on New Changes")
		autoOpenText:SetPoint("left", autoOpenCheckbox, "right", 2, 0)

		DetailsFramework:ApplyStandardBackdrop(statusBar)
		statusBar:SetAlpha(0.8)
		DetailsFramework:BuildStatusbarAuthorInfo(statusBar, "", "")
		statusBar.authorName:SetPoint("left", statusBar, "left", 207, 0)


		function frame:Title (title)
			frame:SetTitle(title or "")
		end

		function frame:Text (text)
			texto:SetText(text or "")
		end

		frame:Hide()
	end
	
	return frame
end
