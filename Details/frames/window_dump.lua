

local Details = _G.Details
local DetailsFramework = _G.DetailsFramework
local C_Timer = _G.C_Timer

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> dump table frame

function Details:DumpTable (t)
	return Details:Dump (t)
end

function Details:Dump (t)
	if (not DetailsDumpFrame) then
		DetailsDumpFrame = DetailsFramework:CreateSimplePanel (_G.UIParent)
		DetailsDumpFrame:SetSize (700, 600)
		DetailsDumpFrame:SetTitle ("Details! Dump Table [|cFFFF3333Ready Only|r]")
		
		local text_editor = DetailsFramework:NewSpecialLuaEditorEntry (DetailsDumpFrame, 680, 560, "Editbox", "$parentEntry", true)
		text_editor:SetPoint ("topleft", DetailsDumpFrame, "topleft", 10, -30)
		
		text_editor.scroll:SetBackdrop (nil)
		text_editor.editbox:SetBackdrop (nil)
		text_editor:SetBackdrop (nil)
		
		DetailsFramework:ReskinSlider (text_editor.scroll)
		
		if (not text_editor.__background) then
			text_editor.__background = text_editor:CreateTexture (nil, "background")
		end
		
		text_editor:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		text_editor:SetBackdropBorderColor (0, 0, 0, 1)
		
		text_editor.__background:SetColorTexture (0.2317647, 0.2317647, 0.2317647)
		text_editor.__background:SetVertexColor (0.27, 0.27, 0.27)
		text_editor.__background:SetAlpha (0.8)
		text_editor.__background:SetVertTile (true)
		text_editor.__background:SetHorizTile (true)
		text_editor.__background:SetAllPoints()	
	end
	
	t = t or {}
	local s = Details.table.dump (t)
	DetailsDumpFrame.Editbox:SetText (s)
	DetailsDumpFrame:Show()
end



---------------------------------------------------------------------------------------------------------------------------------------
--> import export window
--show a window with a big text editor and 2 buttons: okay and cancel.
--cancel button always closes the window and okay calls the comfirm function passed in the argument
--default text is the text shown show the window is show()

function _detalhes:DumpString (text)
	_detalhes:ShowImportWindow (text)
end

function _detalhes:ShowImportWindow (defaultText, confirmFunc, titleText)
	if (not _G.DetailsExportWindow) then
		local importWindow = DetailsFramework:CreateSimplePanel (_G.UIParent, 800, 610, "Details! Dump String", "DetailsExportWindow")
		importWindow:SetFrameStrata ("FULLSCREEN")
		importWindow:SetPoint ("center")
		DetailsFramework:ApplyStandardBackdrop (importWindow, false, 1.2)
	
		local importTextEditor = DetailsFramework:NewSpecialLuaEditorEntry (importWindow, 780, 540, "ImportEditor", "$parentEditor", true)
		importTextEditor:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		importTextEditor:SetBackdropColor (.2, .2, .2, .5)
		importTextEditor:SetBackdropBorderColor (0, 0, 0, 1)
		importTextEditor:SetPoint ("topleft", importWindow, "topleft", 10, -30)
		
		importTextEditor.scroll:SetBackdrop (nil)
		importTextEditor.editbox:SetBackdrop (nil)
		importTextEditor:SetBackdrop (nil)
		
		DetailsFramework:ReskinSlider (importTextEditor.scroll)
		
		if (not importTextEditor.__background) then
			importTextEditor.__background = importTextEditor:CreateTexture (nil, "background")
		end
		
		importTextEditor:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		importTextEditor:SetBackdropBorderColor (0, 0, 0, 1)
		
		importTextEditor.__background:SetColorTexture (0.2317647, 0.2317647, 0.2317647)
		importTextEditor.__background:SetVertexColor (0.27, 0.27, 0.27)
		importTextEditor.__background:SetAlpha (0.8)
		importTextEditor.__background:SetVertTile (true)
		importTextEditor.__background:SetHorizTile (true)
		importTextEditor.__background:SetAllPoints()	
		
		--import button
		local onClickImportButton = function()
			if (_G.DetailsExportWindow.ConfirmFunction) then
				DetailsFramework:Dispatch (_G.DetailsExportWindow.ConfirmFunction, importTextEditor:GetText())
			end
			importWindow:Hide()
		end
		local okayButton = DetailsFramework:CreateButton (importTextEditor, onClickImportButton, 120, 20, "Okay", -1, nil, nil, nil, nil, nil, _detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), _detalhes.gump:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")) --> localize-me
		okayButton:SetIcon ([[Interface\BUTTONS\UI-Panel-BiggerButton-Up]], 20, 20, "overlay", {0.1, .9, 0.1, .9})
		importTextEditor.OkayButton = okayButton
	
		--cancel button
		local cancelButton = DetailsFramework:CreateButton (importTextEditor, function() importWindow:Hide() end, 120, 20, "Cancel", -1, nil, nil, nil, nil, nil, _detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), _detalhes.gump:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")) --> localize-me
		cancelButton:SetIcon ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Up]], 20, 20, "overlay", {0.1, .9, 0.1, .9})

		okayButton:SetPoint ("topright", importTextEditor, "bottomright", 0, -10)
		cancelButton:SetPoint ("right", okayButton, "left", -20, 0)
		
	end
	
	_G.DetailsExportWindow.ConfirmFunction = confirmFunc
	_G.DetailsExportWindow.ImportEditor:SetText (defaultText or "")
	_G.DetailsExportWindow:Show()
	
	titleText = titleText or "Details! Dump String"
	_G.DetailsExportWindow.Title:SetText (titleText)
	
	C_Timer.After (.2, function()
		_G.DetailsExportWindow.ImportEditor:SetFocus (true)
		_G.DetailsExportWindow.ImportEditor.editbox:HighlightText (0)
	end)
end

