
local DF = _G["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local texCoordinates

local CreateImageEditorFrame = function()
	local editorWindow = DF:NewPanel(UIParent, nil, "DetailsFrameworkImageEdit", nil, 650, 500, false)
	editorWindow:SetPoint("center", UIParent, "center")
	editorWindow:SetResizable(true)
	editorWindow:SetMovable(true)
	editorWindow:SetClampedToScreen(true)
	tinsert(UISpecialFrames, "DetailsFrameworkImageEdit")
	editorWindow:SetFrameStrata("TOOLTIP")

	if (not DetailsFramework.IsDragonflight()) then
		editorWindow:SetMaxResize(500, 500)
	else
		editorWindow:SetResizeBounds(100, 100, 500, 500)
	end

	_G.DetailsFrameworkImageEditTable = editorWindow

	editorWindow.hooks = {}

	local background = DF:NewImage(editorWindow, nil, nil, nil, "background", nil, "background", "$parentBackground")
	background:SetAllPoints()
	background:SetTexture(0, 0, 0, .8)

	local edit_texture = DF:NewImage(editorWindow, nil, 500, 500, "artwork", nil, "edit_texture", "$parentImage")
	edit_texture:SetAllPoints()
	_G.DetailsFrameworkImageEdit_EditTexture = edit_texture

	local background_frame = CreateFrame("frame", "DetailsFrameworkImageEditBackground", DetailsFrameworkImageEdit, "BackdropTemplate")
	background_frame:SetPoint("topleft", DetailsFrameworkImageEdit, "topleft", -10, 30)
	background_frame:SetFrameStrata("TOOLTIP")
	background_frame:SetFrameLevel(editorWindow:GetFrameLevel())
	background_frame:SetSize(790, 560)

	background_frame:SetResizable(true)
	background_frame:SetMovable(true)

	background_frame:SetScript("OnMouseDown", function()
		editorWindow:StartMoving()
	end)
	background_frame:SetScript("OnMouseUp", function()
		editorWindow:StopMovingOrSizing()
	end)

	DF:CreateTitleBar (background_frame, "Image Editor")
	DF:ApplyStandardBackdrop(background_frame, false, 0.98)
	DF:CreateStatusBar(background_frame)

	background_frame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	background_frame:SetBackdropColor(0, 0, 0, 0.9)
	background_frame:SetBackdropBorderColor(0, 0, 0, 1)

	local haveHFlip = false
	local haveVFlip = false

--Top Slider
		local topCoordTexture = DF:NewImage(editorWindow, nil, nil, nil, "overlay", nil, nil, "$parentImageTopCoord")
		topCoordTexture:SetPoint("topleft", editorWindow, "topleft")
		topCoordTexture:SetPoint("topright", editorWindow, "topright")
		topCoordTexture:SetColorTexture(1, 0, 0)
		topCoordTexture.height = 1
		topCoordTexture.alpha = .2

		local topSlider = DF:NewSlider (editorWindow, nil, "$parentTopSlider", "topSlider", 100, 100, 0.1, 100, 0.1, 0)
		topSlider:SetAllPoints(editorWindow.widget)
		topSlider:SetOrientation("VERTICAL")
		topSlider.backdrop = nil
		topSlider.fractional = true
		topSlider:SetHook("OnEnter", function() return true end)
		topSlider:SetHook("OnLeave", function() return true end)

		local topSliderThumpTexture = topSlider:CreateTexture(nil, "overlay")
		topSliderThumpTexture:SetColorTexture(1, 1, 1)
		topSliderThumpTexture:SetWidth(512)
		topSliderThumpTexture:SetHeight(1)
		topSlider:SetThumbTexture (topSliderThumpTexture)

		topSlider:SetHook("OnValueChange", function(_, _, value)
			topCoordTexture.image:SetHeight(editorWindow.frame:GetHeight()/100*value)
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end)

		topSlider:Hide()

--Bottom Slider
		local bottomCoordTexture = DF:NewImage(editorWindow, nil, nil, nil, "overlay", nil, nil, "$parentImageBottomCoord")
		bottomCoordTexture:SetPoint("bottomleft", editorWindow, "bottomleft", 0, 0)
		bottomCoordTexture:SetPoint("bottomright", editorWindow, "bottomright", 0, 0)
		bottomCoordTexture:SetColorTexture(1, 0, 0)
		bottomCoordTexture.height = 1
		bottomCoordTexture.alpha = .2

		local bottomSlider = DF:NewSlider (editorWindow, nil, "$parentBottomSlider", "bottomSlider", 100, 100, 0.1, 100, 0.1, 100)
		bottomSlider:SetAllPoints(editorWindow.widget)
		bottomSlider:SetOrientation("VERTICAL")
		bottomSlider.backdrop = nil
		bottomSlider.fractional = true
		bottomSlider:SetHook("OnEnter", function() return true end)
		bottomSlider:SetHook("OnLeave", function() return true end)

		local bottomSliderThumpTexture = bottomSlider:CreateTexture(nil, "overlay")
		bottomSliderThumpTexture:SetColorTexture(1, 1, 1)
		bottomSliderThumpTexture:SetWidth(512)
		bottomSliderThumpTexture:SetHeight(1)
		bottomSlider:SetThumbTexture (bottomSliderThumpTexture)

		bottomSlider:SetHook("OnValueChange", function(_, _, value)
			value = math.abs(value-100)
			bottomCoordTexture.image:SetHeight(math.max(editorWindow.frame:GetHeight()/100*value, 1))
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end)

		bottomSlider:Hide()

--Left Slider
		local leftCoordTexture = DF:NewImage(editorWindow, nil, nil, nil, "overlay", nil, nil, "$parentImageLeftCoord")
		leftCoordTexture:SetPoint("topleft", editorWindow, "topleft", 0, 0)
		leftCoordTexture:SetPoint("bottomleft", editorWindow, "bottomleft", 0, 0)
		leftCoordTexture:SetColorTexture(1, 0, 0)
		leftCoordTexture.width = 1
		leftCoordTexture.alpha = .2

		local leftSlider = DF:NewSlider (editorWindow, nil, "$parentLeftSlider", "leftSlider", 100, 100, 0.1, 100, 0.1, 0.1)
		leftSlider:SetAllPoints(editorWindow.widget)
		leftSlider.backdrop = nil
		leftSlider.fractional = true
		leftSlider:SetHook("OnEnter", function() return true end)
		leftSlider:SetHook("OnLeave", function() return true end)

		local leftSliderThumpTexture = leftSlider:CreateTexture(nil, "overlay")
		leftSliderThumpTexture:SetColorTexture(1, 1, 1)
		leftSliderThumpTexture:SetWidth(1)
		leftSliderThumpTexture:SetHeight(512)
		leftSlider:SetThumbTexture (leftSliderThumpTexture)

		leftSlider:SetHook("OnValueChange", function(_, _, value)
			leftCoordTexture.image:SetWidth(editorWindow.frame:GetWidth()/100*value)
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end)

		leftSlider:Hide()

--Right Slider
		local rightCoordTexture = DF:NewImage(editorWindow, nil, nil, nil, "overlay", nil, nil, "$parentImageRightCoord")
		rightCoordTexture:SetPoint("topright", editorWindow, "topright", 0, 0)
		rightCoordTexture:SetPoint("bottomright", editorWindow, "bottomright", 0, 0)
		rightCoordTexture:SetColorTexture(1, 0, 0)
		rightCoordTexture.width = 1
		rightCoordTexture.alpha = .2

		local rightSlider = DF:NewSlider (editorWindow, nil, "$parentRightSlider", "rightSlider", 100, 100, 0.1, 100, 0.1, 100)
		rightSlider:SetAllPoints(editorWindow.widget)
		rightSlider.backdrop = nil
		rightSlider.fractional = true
		rightSlider:SetHook("OnEnter", function() return true end)
		rightSlider:SetHook("OnLeave", function() return true end)
		--[
		local rightSliderThumpTexture = rightSlider:CreateTexture(nil, "overlay")
		rightSliderThumpTexture:SetColorTexture(1, 1, 1)
		rightSliderThumpTexture:SetWidth(1)
		rightSliderThumpTexture:SetHeight(512)
		rightSlider:SetThumbTexture (rightSliderThumpTexture)
		--]]
		rightSlider:SetHook("OnValueChange", function(_, _, value)
			value = math.abs(value-100)
			rightCoordTexture.image:SetWidth(math.max(editorWindow.frame:GetWidth()/100*value, 1))
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end)

		rightSlider:Hide()

--Edit Buttons
	local buttonsBackground = DF:NewPanel(UIParent, nil, "DetailsFrameworkImageEditButtonsBg", nil, 115, 230)
	--buttonsBackground:SetPoint("topleft", window, "topright", 2, 0)
	buttonsBackground:SetPoint("topright", background_frame, "topright", -8, -10)
	buttonsBackground:Hide()
	--buttonsBackground:SetMovable(true)
	tinsert(UISpecialFrames, "DetailsFrameworkImageEditButtonsBg")
	buttonsBackground:SetFrameStrata("TOOLTIP")

		local alphaFrameShown = false

		local editingSide = nil
		local lastButton = nil
		local alphaFrame
		local originalColor = {0.9999, 0.8196, 0}

		local enableTexEdit = function(button, bottom, side)

			if (alphaFrameShown) then
				alphaFrame:Hide()
				alphaFrameShown = false
				button.text:SetTextColor(unpack(originalColor))
			end

			if (ColorPickerFrame:IsShown()) then
				ColorPickerFrame:Hide()
			end

			if (lastButton) then
				lastButton.text:SetTextColor(unpack(originalColor))
			end

			if (editingSide == side) then
				editorWindow [editingSide.."Slider"]:Hide()
				editingSide = nil
				return

			elseif (editingSide) then
				editorWindow [editingSide.."Slider"]:Hide()
			end

			editingSide = side
			button.text:SetTextColor(1, 1, 1)
			lastButton = button

			editorWindow [side.."Slider"]:Show()
		end

		local yMod = -10

		local leftTexCoordButton = DF:NewButton(buttonsBackground, nil, "$parentLeftTexButton", nil, 100, 20, enableTexEdit, "left", nil, nil, "Crop Left", 1)
		leftTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -10 + yMod)
		leftTexCoordButton:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

		local rightTexCoordButton = DF:NewButton(buttonsBackground, nil, "$parentRightTexButton", nil, 100, 20, enableTexEdit, "right", nil, nil, "Crop Right", 1)
		rightTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -30 + yMod)
		rightTexCoordButton:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

		local topTexCoordButton = DF:NewButton(buttonsBackground, nil, "$parentTopTexButton", nil, 100, 20, enableTexEdit, "top", nil, nil, "Crop Top", 1)
		topTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -50 + yMod)
		topTexCoordButton:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

		local bottomTexCoordButton = DF:NewButton(buttonsBackground, nil, "$parentBottomTexButton", nil, 100, 20, enableTexEdit, "bottom", nil, nil, "Crop Bottom", 1)
		bottomTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -70 + yMod)
		bottomTexCoordButton:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

		local Alpha = DF:NewButton(buttonsBackground, nil, "$parentBottomAlphaButton", nil, 100, 20, alpha, nil, nil, nil, "Alpha", 1)
		Alpha:SetPoint("topright", buttonsBackground, "topright", -8, -115 + yMod)
		Alpha:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

	--overlay color
		local selectedColor = function(default)
			if (default) then
				edit_texture:SetVertexColor(unpack(default))
				if (editorWindow.callback_func) then
					editorWindow.accept(nil, nil, true)
				end
			else
				edit_texture:SetVertexColor(ColorPickerFrame:GetColorRGB())
				if (editorWindow.callback_func) then
					editorWindow.accept(nil, nil, true)
				end
			end
		end

		local changeColor = function()

			ColorPickerFrame.func = nil
			ColorPickerFrame.opacityFunc = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.previousValues = nil

			local right, g, bottom = edit_texture:GetVertexColor()
			ColorPickerFrame:SetColorRGB (right, g, bottom)
			ColorPickerFrame:SetParent(buttonsBackground.widget)
			ColorPickerFrame.hasOpacity = false
			ColorPickerFrame.previousValues = {right, g, bottom}
			ColorPickerFrame.func = selectedColor
			ColorPickerFrame.cancelFunc = selectedColor
			ColorPickerFrame:ClearAllPoints()
			ColorPickerFrame:SetPoint("left", buttonsBackground.widget, "right")
			ColorPickerFrame:Show()

			if (alphaFrameShown) then
				alphaFrame:Hide()
				alphaFrameShown = false
				Alpha.button.text:SetTextColor(unpack(originalColor))
			end

			if (lastButton) then
				lastButton.text:SetTextColor(unpack(originalColor))
				if (editingSide) then
					editorWindow [editingSide.."Slider"]:Hide()
				end
			end
		end

		local changeColorButton = DF:NewButton(buttonsBackground, nil, "$parentOverlayColorButton", nil, 100, 20, changeColor, nil, nil, nil, "Color", 1)
		changeColorButton:SetPoint("topright", buttonsBackground, "topright", -8, -95 + yMod)
		changeColorButton:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

		alphaFrame = DF:NewPanel(buttonsBackground, nil, "DetailsFrameworkImageEditAlphaBg", nil, 40, 225)
		alphaFrame:SetPoint("topleft", buttonsBackground, "topright", 2, 0)
		alphaFrame:Hide()
		local alphaSlider = DF:NewSlider (alphaFrame, nil, "$parentAlphaSlider", "alphaSlider", 30, 220, 1, 100, 1, edit_texture:GetAlpha()*100)
		alphaSlider:SetPoint("top", alphaFrame, "top", 0, -5)
		alphaSlider:SetOrientation("VERTICAL")
		alphaSlider.thumb:SetSize(40, 30)
		--leftSlider.backdrop = nil
		--leftSlider.fractional = true

		local alpha = function(button)

			if (ColorPickerFrame:IsShown()) then
				ColorPickerFrame:Hide()
			end

			if (lastButton) then
				lastButton.text:SetTextColor(unpack(originalColor))
				if (editingSide) then
					editorWindow [editingSide.."Slider"]:Hide()
				end
			end

			if (not alphaFrameShown) then
				alphaFrame:Show()
				alphaSlider:SetValue(edit_texture:GetAlpha()*100)
				alphaFrameShown = true
				button.text:SetTextColor(1, 1, 1)
			else
				alphaFrame:Hide()
				alphaFrameShown = false
				button.text:SetTextColor(unpack(originalColor))
			end
		end

		Alpha.clickfunction = alpha

		alphaSlider:SetHook("OnValueChange", function(_, _, value)
			edit_texture:SetAlpha(value/100)
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end)

		local resizer = CreateFrame("Button", nil, editorWindow.widget, "BackdropTemplate")
		resizer:SetNormalTexture([[Interface\AddOns\Details\images\skins\default_skin]])
		resizer:SetHighlightTexture([[Interface\AddOns\Details\images\skins\default_skin]])
		resizer:GetNormalTexture():SetTexCoord(0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375)
		resizer:GetHighlightTexture():SetTexCoord(0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375)
		resizer:SetWidth(16)
		resizer:SetHeight(16)
		resizer:SetPoint("BOTTOMRIGHT", editorWindow.widget, "BOTTOMRIGHT", 0, 0)
		resizer:EnableMouse(true)
		resizer:SetFrameLevel(editorWindow.widget:GetFrameLevel() + 2)

		resizer:SetScript("OnMouseDown", function(self, button)
			editorWindow.widget:StartSizing("BOTTOMRIGHT")
		end)

		resizer:SetScript("OnMouseUp", function(self, button)
			editorWindow.widget:StopMovingOrSizing()
		end)

		editorWindow.widget:SetScript("OnMouseDown", function()
			editorWindow.widget:StartMoving()
		end)
		editorWindow.widget:SetScript("OnMouseUp", function()
			editorWindow.widget:StopMovingOrSizing()
		end)

		editorWindow.widget:SetScript("OnSizeChanged", function()
			edit_texture.width = editorWindow.width
			edit_texture.height = editorWindow.height
			leftSliderThumpTexture:SetHeight(editorWindow.height)
			rightSliderThumpTexture:SetHeight(editorWindow.height)
			topSliderThumpTexture:SetWidth(editorWindow.width)
			bottomSliderThumpTexture:SetWidth(editorWindow.width)

			rightCoordTexture.image:SetWidth(math.max( (editorWindow.frame:GetWidth() / 100 * math.abs(rightSlider:GetValue()-100)), 1))
			leftCoordTexture.image:SetWidth(editorWindow.frame:GetWidth()/100*leftSlider:GetValue())
			bottomCoordTexture:SetHeight(math.max( (editorWindow.frame:GetHeight() / 100 * math.abs(bottomSlider:GetValue()-100)), 1))
			topCoordTexture:SetHeight(editorWindow.frame:GetHeight()/100*topSlider:GetValue())

			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end)

	--flip button
	local flip = function(button, bottom, side)
		if (side == 1) then
			haveHFlip = not haveHFlip
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		elseif (side == 2) then
			haveVFlip = not haveVFlip
			if (editorWindow.callback_func) then
				editorWindow.accept(nil, nil, true)
			end
		end
	end

	local flipButtonH = DF:NewButton(buttonsBackground, nil, "$parentFlipButton", nil, 100, 20, flip, 1, nil, nil, "Flip H", 1)
	flipButtonH:SetPoint("topright", buttonsBackground, "topright", -8, -140 + yMod)
	flipButtonH:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

	--select area to crop
	local dragFrame = CreateFrame("frame", nil, background_frame, "BackdropTemplate")
	dragFrame:EnableMouse(false)
	dragFrame:SetFrameStrata("TOOLTIP")
	dragFrame:SetPoint("topleft", edit_texture.widget, "topleft")
	dragFrame:SetPoint("bottomright", edit_texture.widget, "bottomright")
	dragFrame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Worldmap\UI-QuestBlob-Inside]], tileSize = 256, tile = true})
	dragFrame:SetBackdropColor(1, 1, 1, .2)
	dragFrame:Hide()

	local selectionBoxUp = dragFrame:CreateTexture(nil, "overlay")
	selectionBoxUp:SetHeight(1)
	selectionBoxUp:SetColorTexture(1, 1, 1)

	local selectionBoxDown = dragFrame:CreateTexture(nil, "overlay")
	selectionBoxDown:SetHeight(1)
	selectionBoxDown:SetColorTexture(1, 1, 1)

	local selectionBoxLeft = dragFrame:CreateTexture(nil, "overlay")
	selectionBoxLeft:SetWidth(1)
	selectionBoxLeft:SetColorTexture(1, 1, 1)

	local selectionBoxRight = dragFrame:CreateTexture(nil, "overlay")
	selectionBoxRight:SetWidth(1)
	selectionBoxRight:SetColorTexture(1, 1, 1)

	function dragFrame.ClearSelectionBoxPoints()
		selectionBoxUp:ClearAllPoints()
		selectionBoxDown:ClearAllPoints()
		selectionBoxLeft:ClearAllPoints()
		selectionBoxRight:ClearAllPoints()
	end

	local startCropFunc = function()
		dragFrame:Show()
		dragFrame:EnableMouse(true)
	end

	local cropSelection = DF:NewButton(buttonsBackground, nil, "$parentCropSelection", nil, 100, 20, startCropFunc, 2, nil, nil, "Crop Selection", 1)
	cropSelection:InstallCustomTexture()

	dragFrame.OnTick = function(self, deltaTime)
		local x1, y1 = unpack(self.ClickedAt)
		local x2, y2 = GetCursorPosition()
		dragFrame.ClearSelectionBoxPoints()

		if (x2 > x1) then
			--right
			if (y1 > y2) then
				--top
				selectionBoxUp:SetPoint("topleft", UIParent, "bottomleft", x1, y1)
				selectionBoxUp:SetPoint("topright", UIParent, "bottomleft", x2, y1)

				selectionBoxLeft:SetPoint("topleft", UIParent, "bottomleft", x1, y1)
				selectionBoxLeft:SetPoint("bottomleft", UIParent, "bottomleft", x1, y2)

			else
				--bottom
			end
		else
			--left
			if (y2 > y1) then
				--top
			else
				--bottom
			end
		end
	end

	dragFrame:SetScript("OnMouseDown", function(self, MouseButton)
		if (MouseButton == "LeftButton") then
			self.ClickedAt = {GetCursorPosition()}
			dragFrame:SetScript("OnUpdate", dragFrame.OnTick)
		end
	end)

	dragFrame:SetScript("OnMouseUp", function(self, MouseButton)
		if (MouseButton == "LeftButton") then
			self.ReleaseAt = {GetCursorPosition()}
			dragFrame:EnableMouse(false)
			dragFrame:Hide()
			dragFrame:SetScript("OnUpdate", nil)
			print(self.ClickedAt[1], self.ClickedAt[2], self.ReleaseAt[1], self.ReleaseAt[2])
		end
	end)

	--accept
	editorWindow.accept = function(self, bottom, keepEditing)
		if (not keepEditing) then
			buttonsBackground:Hide()
			editorWindow:Hide()
			alphaFrame:Hide()
			ColorPickerFrame:Hide()
		end

		local coords = {}
		local left, right, top, bottom = leftSlider.value/100, rightSlider.value/100, topSlider.value/100, bottomSlider.value/100

		if (haveHFlip) then
			coords [1] = right
			coords [2] = left
		else
			coords [1] = left
			coords [2] = right
		end

		if (haveVFlip) then
			coords [3] = bottom
			coords [4] = top
		else
			coords [3] = top
			coords [4] = bottom
		end

		return editorWindow.callback_func(edit_texture.width, edit_texture.height, {edit_texture:GetVertexColor()}, edit_texture:GetAlpha(), coords, editorWindow.extra_param)
	end

	local acceptButton = DF:NewButton(buttonsBackground, nil, "$parentAcceptButton", nil, 100, 20, editorWindow.accept, nil, nil, nil, "Done", 1)
	acceptButton:SetPoint("topright", buttonsBackground, "topright", -8, -200)
	acceptButton:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

	function DF:RefreshImageEditor()
		if (edit_texture.maximize) then
			DetailsFrameworkImageEdit:SetSize(266, 226)
		else
			DetailsFrameworkImageEdit:SetSize(edit_texture.width, edit_texture.height)
		end

		local left, right, top, bottom = unpack(texCoordinates)

		if (left > right) then
			haveHFlip = true
			leftSlider:SetValue(right * 100)
			rightSlider:SetValue(left * 100)
		else
			haveHFlip = false
			leftSlider:SetValue(left * 100)
			rightSlider:SetValue(right * 100)
		end

		if (top > bottom) then
			haveVFlip = true
			topSlider:SetValue(bottom * 100)
			bottomSlider:SetValue(top * 100)
		else
			haveVFlip = false
			topSlider:SetValue(top * 100)
			bottomSlider:SetValue(bottom * 100)
		end

		if (editorWindow.callback_func) then
			editorWindow.accept(nil, nil, true)
		end
	end

	editorWindow:Hide()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function DF:ImageEditor(callback, texture, texcoord, colors, width, height, extraParam, alpha, maximize)
		if (not _G.DetailsFrameworkImageEdit) then
			CreateImageEditorFrame()
		end

		local window = _G.DetailsFrameworkImageEditTable

		texcoord = texcoord or {0, 1, 0, 1}
		texCoordinates = texcoord

		colors = colors or {1, 1, 1, 1}

		alpha = alpha or 1

		_G.DetailsFrameworkImageEdit_EditTexture:SetTexture(texture)
		_G.DetailsFrameworkImageEdit_EditTexture.width = width
		_G.DetailsFrameworkImageEdit_EditTexture.height = height
		_G.DetailsFrameworkImageEdit_EditTexture.maximize = maximize

		_G.DetailsFrameworkImageEdit_EditTexture:SetVertexColor(colors [1], colors [2], colors [3])
		_G.DetailsFrameworkImageEdit_EditTexture:SetAlpha(alpha)

		DF.Schedules.NewTimer(0.2, DF.RefreshImageEditor)

		window:Show()
		window.callback_func = callback
		window.extra_param = extraParam
		DetailsFrameworkImageEditButtonsBg:Show()
		DetailsFrameworkImageEditButtonsBg:SetBackdrop(nil)

		table.wipe(window.hooks)
	end
