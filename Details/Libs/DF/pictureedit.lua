
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

local _

	local window = DF:NewPanel (UIParent, nil, "DetailsFrameworkImageEdit", nil, 100, 100, false)
	window:SetPoint ("center", UIParent, "center")
	window:SetResizable (true)
	window:SetMovable (true)
	window:SetClampedToScreen (true)
	tinsert (UISpecialFrames, "DetailsFrameworkImageEdit")
	window:SetFrameStrata ("TOOLTIP")
	window:SetMaxResize (650, 500)
	
	window.hooks = {}
	
	local background = DF:NewImage (window, nil, nil, nil, "background", nil, nil, "$parentBackground")
	background:SetAllPoints()
	background:SetTexture (0, 0, 0, .8)
	
	local edit_texture = DF:NewImage (window, nil, 650, 500, "artwork", nil, nil, "$parentImage")
	edit_texture:SetAllPoints()
	
	local background_frame = CreateFrame ("frame", "DetailsFrameworkImageEditBackground", DetailsFrameworkImageEdit)
	background_frame:SetPoint ("topleft", DetailsFrameworkImageEdit, "topleft", -10, 12)
	background_frame:SetFrameStrata ("DIALOG")
	background_frame:SetSize (800, 540)
	
	background_frame:SetResizable (true)
	background_frame:SetMovable (true)
	
	background_frame:SetScript ("OnMouseDown", function()
		window:StartMoving()
	end)
	background_frame:SetScript ("OnMouseUp", function()
		window:StopMovingOrSizing()
	end)
	
	background_frame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	background_frame:SetBackdropColor (0, 0, 0, 0.9)
	background_frame:SetBackdropBorderColor (0, 0, 0, 1)
	
	local haveHFlip = false
	local haveVFlip = false
	
--> Top Slider
	
		local topCoordTexture = DF:NewImage (window, nil, nil, nil, "overlay", nil, nil, "$parentImageTopCoord")
		topCoordTexture:SetPoint ("topleft", window, "topleft")
		topCoordTexture:SetPoint ("topright", window, "topright")
		topCoordTexture:SetColorTexture (1, 0, 0)
		topCoordTexture.height = 1
		topCoordTexture.alpha = .2
		
		local topSlider = DF:NewSlider (window, nil, "$parentTopSlider", "topSlider", 100, 100, 0.1, 100, 0.1, 0)
		topSlider:SetAllPoints (window.widget)
		topSlider:SetOrientation ("VERTICAL")
		topSlider.backdrop = nil
		topSlider.fractional = true
		topSlider:SetHook ("OnEnter", function() return true end)
		topSlider:SetHook ("OnLeave", function() return true end)

		local topSliderThumpTexture = topSlider:CreateTexture (nil, "overlay")
		topSliderThumpTexture:SetColorTexture (1, 1, 1)
		topSliderThumpTexture:SetWidth (512)
		topSliderThumpTexture:SetHeight (1)
		topSlider:SetThumbTexture (topSliderThumpTexture)

		topSlider:SetHook ("OnValueChange", function (_, _, value)
			topCoordTexture.image:SetHeight (window.frame:GetHeight()/100*value)
			if (window.callback_func) then
				window.accept (nil, nil, true)
			end
		end)
		
		topSlider:Hide()

--> Bottom Slider

		local bottomCoordTexture = DF:NewImage (window, nil, nil, nil, "overlay", nil, nil, "$parentImageBottomCoord")
		bottomCoordTexture:SetPoint ("bottomleft", window, "bottomleft", 0, 0)
		bottomCoordTexture:SetPoint ("bottomright", window, "bottomright", 0, 0)
		bottomCoordTexture:SetColorTexture (1, 0, 0)
		bottomCoordTexture.height = 1
		bottomCoordTexture.alpha = .2

		local bottomSlider= DF:NewSlider (window, nil, "$parentBottomSlider", "bottomSlider", 100, 100, 0.1, 100, 0.1, 100)
		bottomSlider:SetAllPoints (window.widget)
		bottomSlider:SetOrientation ("VERTICAL")
		bottomSlider.backdrop = nil
		bottomSlider.fractional = true
		bottomSlider:SetHook ("OnEnter", function() return true end)
		bottomSlider:SetHook ("OnLeave", function() return true end)

		local bottomSliderThumpTexture = bottomSlider:CreateTexture (nil, "overlay")
		bottomSliderThumpTexture:SetColorTexture (1, 1, 1)
		bottomSliderThumpTexture:SetWidth (512)
		bottomSliderThumpTexture:SetHeight (1)
		bottomSlider:SetThumbTexture (bottomSliderThumpTexture)

		bottomSlider:SetHook ("OnValueChange", function (_, _, value)
			value = math.abs (value-100)
			bottomCoordTexture.image:SetHeight (math.max (window.frame:GetHeight()/100*value, 1))
			if (window.callback_func) then
				window.accept (nil, nil, true)
			end
		end)
		
		bottomSlider:Hide()
		
--> Left Slider
		
		local leftCoordTexture = DF:NewImage (window, nil, nil, nil, "overlay", nil, nil, "$parentImageLeftCoord")
		leftCoordTexture:SetPoint ("topleft", window, "topleft", 0, 0)
		leftCoordTexture:SetPoint ("bottomleft", window, "bottomleft", 0, 0)
		leftCoordTexture:SetColorTexture (1, 0, 0)
		leftCoordTexture.width = 1
		leftCoordTexture.alpha = .2
		
		local leftSlider = DF:NewSlider (window, nil, "$parentLeftSlider", "leftSlider", 100, 100, 0.1, 100, 0.1, 0.1)
		leftSlider:SetAllPoints (window.widget)
		leftSlider.backdrop = nil
		leftSlider.fractional = true
		leftSlider:SetHook ("OnEnter", function() return true end)
		leftSlider:SetHook ("OnLeave", function() return true end)
		
		local leftSliderThumpTexture = leftSlider:CreateTexture (nil, "overlay")
		leftSliderThumpTexture:SetColorTexture (1, 1, 1)
		leftSliderThumpTexture:SetWidth (1)
		leftSliderThumpTexture:SetHeight (512)
		leftSlider:SetThumbTexture (leftSliderThumpTexture)
		
		leftSlider:SetHook ("OnValueChange", function (_, _, value)
			leftCoordTexture.image:SetWidth (window.frame:GetWidth()/100*value)
			if (window.callback_func) then
				window.accept (nil, nil, true)
			end
		end)
		
		leftSlider:Hide()
		
--> Right Slider
		
		local rightCoordTexture = DF:NewImage (window, nil, nil, nil, "overlay", nil, nil, "$parentImageRightCoord")
		rightCoordTexture:SetPoint ("topright", window, "topright", 0, 0)
		rightCoordTexture:SetPoint ("bottomright", window, "bottomright", 0, 0)
		rightCoordTexture:SetColorTexture (1, 0, 0)
		rightCoordTexture.width = 1
		rightCoordTexture.alpha = .2
		
		local rightSlider = DF:NewSlider (window, nil, "$parentRightSlider", "rightSlider", 100, 100, 0.1, 100, 0.1, 100)
		rightSlider:SetAllPoints (window.widget)
		rightSlider.backdrop = nil
		rightSlider.fractional = true
		rightSlider:SetHook ("OnEnter", function() return true end)
		rightSlider:SetHook ("OnLeave", function() return true end)
		--[
		local rightSliderThumpTexture = rightSlider:CreateTexture (nil, "overlay")
		rightSliderThumpTexture:SetColorTexture (1, 1, 1)
		rightSliderThumpTexture:SetWidth (1)
		rightSliderThumpTexture:SetHeight (512)
		rightSlider:SetThumbTexture (rightSliderThumpTexture)
		--]]
		rightSlider:SetHook ("OnValueChange", function (_, _, value)
			value = math.abs (value-100)
			rightCoordTexture.image:SetWidth (math.max (window.frame:GetWidth()/100*value, 1))
			if (window.callback_func) then
				window.accept (nil, nil, true)
			end
		end)
		
		rightSlider:Hide()
		
--> Edit Buttons

	local buttonsBackground = DF:NewPanel (UIParent, nil, "DetailsFrameworkImageEditButtonsBg", nil, 115, 230)
	--buttonsBackground:SetPoint ("topleft", window, "topright", 2, 0)
	buttonsBackground:SetPoint ("topright", background_frame, "topright", -8, -10)
	buttonsBackground:Hide()
	--buttonsBackground:SetMovable (true)
	tinsert (UISpecialFrames, "DetailsFrameworkImageEditButtonsBg")
	buttonsBackground:SetFrameStrata ("TOOLTIP")
	
		local alphaFrameShown = false
	
		local editingSide = nil
		local lastButton = nil
		local alphaFrame
		local originalColor = {0.9999, 0.8196, 0}
		
		local enableTexEdit = function (button, b, side)
			
			if (alphaFrameShown) then
				alphaFrame:Hide()
				alphaFrameShown = false
				button.text:SetTextColor (unpack (originalColor))
			end
			
			if (ColorPickerFrame:IsShown()) then
				ColorPickerFrame:Hide()
			end
			
			if (lastButton) then
				lastButton.text:SetTextColor (unpack (originalColor))
			end
			
			if (editingSide == side) then
				window [editingSide.."Slider"]:Hide()
				editingSide = nil
				return
				
			elseif (editingSide) then
				window [editingSide.."Slider"]:Hide()
			end

			editingSide = side
			button.text:SetTextColor (1, 1, 1)
			lastButton = button
			
			window [side.."Slider"]:Show()
		end
		
		local leftTexCoordButton = DF:NewButton (buttonsBackground, nil, "$parentLeftTexButton", nil, 100, 20, enableTexEdit, "left", nil, nil, "Crop Left", 1)
		leftTexCoordButton:SetPoint ("topright", buttonsBackground, "topright", -8, -10)
		local rightTexCoordButton = DF:NewButton (buttonsBackground, nil, "$parentRightTexButton", nil, 100, 20, enableTexEdit, "right", nil, nil, "Crop Right", 1)
		rightTexCoordButton:SetPoint ("topright", buttonsBackground, "topright", -8, -30)
		local topTexCoordButton = DF:NewButton (buttonsBackground, nil, "$parentTopTexButton", nil, 100, 20, enableTexEdit, "top", nil, nil, "Crop Top", 1)
		topTexCoordButton:SetPoint ("topright", buttonsBackground, "topright", -8, -50)
		local bottomTexCoordButton = DF:NewButton (buttonsBackground, nil, "$parentBottomTexButton", nil, 100, 20, enableTexEdit, "bottom", nil, nil, "Crop Bottom", 1)
		bottomTexCoordButton:SetPoint ("topright", buttonsBackground, "topright", -8, -70)
		leftTexCoordButton:InstallCustomTexture()
		rightTexCoordButton:InstallCustomTexture()
		topTexCoordButton:InstallCustomTexture()
		bottomTexCoordButton:InstallCustomTexture()
		
		local Alpha = DF:NewButton (buttonsBackground, nil, "$parentBottomAlphaButton", nil, 100, 20, alpha, nil, nil, nil, "Alpha", 1)
		Alpha:SetPoint ("topright", buttonsBackground, "topright", -8, -115)
		Alpha:InstallCustomTexture()
		
	--> overlay color
		local selectedColor = function (default)
			if (default) then
				edit_texture:SetVertexColor (unpack (default))
				if (window.callback_func) then
					window.accept (nil, nil, true)
				end
			else
				edit_texture:SetVertexColor (ColorPickerFrame:GetColorRGB())
				if (window.callback_func) then
					window.accept (nil, nil, true)
				end
			end
		end
		
		local changeColor = function()
		
			ColorPickerFrame.func = nil
			ColorPickerFrame.opacityFunc = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.previousValues = nil
			
			local r, g, b = edit_texture:GetVertexColor()
			ColorPickerFrame:SetColorRGB (r, g, b)
			ColorPickerFrame:SetParent (buttonsBackground.widget)
			ColorPickerFrame.hasOpacity = false
			ColorPickerFrame.previousValues = {r, g, b}
			ColorPickerFrame.func = selectedColor
			ColorPickerFrame.cancelFunc = selectedColor
			ColorPickerFrame:ClearAllPoints()
			ColorPickerFrame:SetPoint ("left", buttonsBackground.widget, "right")
			ColorPickerFrame:Show()
			
			if (alphaFrameShown) then
				alphaFrame:Hide()
				alphaFrameShown = false
				Alpha.button.text:SetTextColor (unpack (originalColor))
			end	
			
			if (lastButton) then
				lastButton.text:SetTextColor (unpack (originalColor))
				if (editingSide) then
					window [editingSide.."Slider"]:Hide()
				end
			end
		end
		
		local changeColorButton = DF:NewButton (buttonsBackground, nil, "$parentOverlayColorButton", nil, 100, 20, changeColor, nil, nil, nil, "Color", 1)
		changeColorButton:SetPoint ("topright", buttonsBackground, "topright", -8, -95)
		changeColorButton:InstallCustomTexture()
		
		alphaFrame = DF:NewPanel (buttonsBackground, nil, "DetailsFrameworkImageEditAlphaBg", nil, 40, 225)
		alphaFrame:SetPoint ("topleft", buttonsBackground, "topright", 2, 0)
		alphaFrame:Hide() 
		local alphaSlider = DF:NewSlider (alphaFrame, nil, "$parentAlphaSlider", "alphaSlider", 30, 220, 1, 100, 1, edit_texture:GetAlpha()*100)
		alphaSlider:SetPoint ("top", alphaFrame, "top", 0, -5)
		alphaSlider:SetOrientation ("VERTICAL")
		alphaSlider.thumb:SetSize (40, 30)
		--leftSlider.backdrop = nil
		--leftSlider.fractional = true
		
		local alpha = function (button)
		
			if (ColorPickerFrame:IsShown()) then
				ColorPickerFrame:Hide()
			end
		
			if (lastButton) then
				lastButton.text:SetTextColor (unpack (originalColor))
				if (editingSide) then
					window [editingSide.."Slider"]:Hide()
				end
			end
		
			if (not alphaFrameShown) then
				alphaFrame:Show()
				alphaSlider:SetValue (edit_texture:GetAlpha()*100)
				alphaFrameShown = true
				button.text:SetTextColor (1, 1, 1)
			else
				alphaFrame:Hide()
				alphaFrameShown = false
				button.text:SetTextColor (unpack (originalColor))
			end
		end
		
		Alpha.clickfunction = alpha
		
		alphaSlider:SetHook ("OnValueChange", function (_, _, value)
			edit_texture:SetAlpha (value/100)
			if (window.callback_func) then
				window.accept (nil, nil, true)
			end
		end)

		local resizer = CreateFrame ("Button", nil, window.widget)
		resizer:SetNormalTexture ([[Interface\AddOns\Details\images\skins\default_skin]])
		resizer:SetHighlightTexture ([[Interface\AddOns\Details\images\skins\default_skin]])
		resizer:GetNormalTexture():SetTexCoord (0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375)
		resizer:GetHighlightTexture():SetTexCoord (0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375)
		resizer:SetWidth (16)
		resizer:SetHeight (16)
		resizer:SetPoint ("BOTTOMRIGHT", window.widget, "BOTTOMRIGHT", 0, 0)
		resizer:EnableMouse (true)
		resizer:SetFrameLevel (window.widget:GetFrameLevel() + 2)
		
		resizer:SetScript ("OnMouseDown", function (self, button) 
			window.widget:StartSizing ("BOTTOMRIGHT")
		end)
		
		resizer:SetScript ("OnMouseUp", function (self, button) 
			window.widget:StopMovingOrSizing()
		end)
		
		window.widget:SetScript ("OnMouseDown", function()
			window.widget:StartMoving()
		end)
		window.widget:SetScript ("OnMouseUp", function()
			window.widget:StopMovingOrSizing()
		end)
		
		window.widget:SetScript ("OnSizeChanged", function()
			edit_texture.width = window.width
			edit_texture.height = window.height
			leftSliderThumpTexture:SetHeight (window.height)
			rightSliderThumpTexture:SetHeight (window.height)
			topSliderThumpTexture:SetWidth (window.width)
			bottomSliderThumpTexture:SetWidth (window.width)
			
			rightCoordTexture.image:SetWidth (math.max ( (window.frame:GetWidth() / 100 * math.abs (rightSlider:GetValue()-100)), 1))
			leftCoordTexture.image:SetWidth (window.frame:GetWidth()/100*leftSlider:GetValue())
			bottomCoordTexture:SetHeight (math.max ( (window.frame:GetHeight() / 100 * math.abs (bottomSlider:GetValue()-100)), 1))
			topCoordTexture:SetHeight (window.frame:GetHeight()/100*topSlider:GetValue())
			
			if (window.callback_func) then
				window.accept (nil, nil, true)
			end
		end)
		

		
	--> flip
		local flip = function (button, b, side)
			if (side == 1) then
				haveHFlip = not haveHFlip
				if (window.callback_func) then
					window.accept (nil, nil, true)
				end
			elseif (side == 2) then
				haveVFlip = not haveVFlip
				if (window.callback_func) then
					window.accept (nil, nil, true)
				end
			end
		end
		
		local flipButtonH = DF:NewButton (buttonsBackground, nil, "$parentFlipButton", nil, 100, 20, flip, 1, nil, nil, "Flip H", 1)
		flipButtonH:SetPoint ("topright", buttonsBackground, "topright", -8, -140)
		flipButtonH:InstallCustomTexture()
		--

		
	--> select area to crop
		local DragFrame = CreateFrame ("frame", nil, background_frame)
		DragFrame:EnableMouse (false)
		DragFrame:SetFrameStrata ("TOOLTIP")
		DragFrame:SetPoint ("topleft", edit_texture.widget, "topleft")
		DragFrame:SetPoint ("bottomright", edit_texture.widget, "bottomright")
		DragFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Worldmap\UI-QuestBlob-Inside]], tileSize = 256, tile = true})
		DragFrame:SetBackdropColor (1, 1, 1, .2)
		DragFrame:Hide()
		
		local SelectionBox_Up = DragFrame:CreateTexture (nil, "overlay")
		SelectionBox_Up:SetHeight (1)
		SelectionBox_Up:SetColorTexture (1, 1, 1)
		local SelectionBox_Down = DragFrame:CreateTexture (nil, "overlay")
		SelectionBox_Down:SetHeight (1)		
		SelectionBox_Down:SetColorTexture (1, 1, 1)
		local SelectionBox_Left = DragFrame:CreateTexture (nil, "overlay")
		SelectionBox_Left:SetWidth (1)
		SelectionBox_Left:SetColorTexture (1, 1, 1)
		local SelectionBox_Right = DragFrame:CreateTexture (nil, "overlay")
		SelectionBox_Right:SetWidth (1)
		SelectionBox_Right:SetColorTexture (1, 1, 1)
		
		function DragFrame.ClearSelectionBoxPoints()
			SelectionBox_Up:ClearAllPoints()
			SelectionBox_Down:ClearAllPoints()
			SelectionBox_Left:ClearAllPoints()
			SelectionBox_Right:ClearAllPoints()
		end
		
		local StartCrop = function()
			DragFrame:Show()
			DragFrame:EnableMouse (true)
		end
		
		local CropSelection = DF:NewButton (buttonsBackground, nil, "$parentCropSelection", nil, 100, 20, StartCrop, 2, nil, nil, "Crop Selection", 1)
		--CropSelection:SetPoint ("topright", buttonsBackground, "topright", -8, -260)
		CropSelection:InstallCustomTexture()
		
		DragFrame.OnTick = function (self, deltaTime)
			local x1, y1 = unpack (self.ClickedAt)
			local x2, y2 = GetCursorPosition()
			DragFrame.ClearSelectionBoxPoints()
			
			print (x1, y1, x2, y2)
			
			if (x2 > x1) then
				--right
				if (y1 > y2) then
					--top
					SelectionBox_Up:SetPoint ("topleft", UIParent, "bottomleft", x1, y1)
					SelectionBox_Up:SetPoint ("topright", UIParent, "bottomleft", x2, y1)
					
					SelectionBox_Left:SetPoint ("topleft", UIParent, "bottomleft", x1, y1)
					SelectionBox_Left:SetPoint ("bottomleft", UIParent, "bottomleft", x1, y2)
					
					print (1)
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
		
		DragFrame:SetScript ("OnMouseDown", function (self, MouseButton)
			if (MouseButton == "LeftButton") then
				self.ClickedAt = {GetCursorPosition()}
				DragFrame:SetScript ("OnUpdate", DragFrame.OnTick)
				
			end
		end)
		DragFrame:SetScript ("OnMouseUp", function (self, MouseButton)
			if (MouseButton == "LeftButton") then
				self.ReleaseAt = {GetCursorPosition()}
				DragFrame:EnableMouse (false)
				DragFrame:Hide()
				DragFrame:SetScript ("OnUpdate", nil)
				print (self.ClickedAt[1], self.ClickedAt[2], self.ReleaseAt[1], self.ReleaseAt[2])
			end
		end)
		
	--> accept
		window.accept = function (self, b, keep_editing)
		
			if (not keep_editing) then
				buttonsBackground:Hide()
				window:Hide()
				alphaFrame:Hide()
				ColorPickerFrame:Hide()
			end
			
			local coords = {}
			local l, r, t, b = leftSlider.value/100, rightSlider.value/100, topSlider.value/100, bottomSlider.value/100
			
			if (haveHFlip) then
				coords [1] = r
				coords [2] = l
			else
				coords [1] = l
				coords [2] = r
			end
			
			if (haveVFlip) then
				coords [3] = b
				coords [4] = t
			else
				coords [3] = t
				coords [4] = b
			end

			return window.callback_func (edit_texture.width, edit_texture.height, {edit_texture:GetVertexColor()}, edit_texture:GetAlpha(), coords, window.extra_param)
		end
		
		local acceptButton = DF:NewButton (buttonsBackground, nil, "$parentAcceptButton", nil, 100, 20, window.accept, nil, nil, nil, "Done", 1)
		acceptButton:SetPoint ("topright", buttonsBackground, "topright", -8, -200)
		acceptButton:InstallCustomTexture()
		


window:Hide()
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		local ttexcoord
		function DF:ImageEditor (callback, texture, texcoord, colors, width, height, extraParam, alpha, maximize)
		
			texcoord = texcoord or {0, 1, 0, 1}
			ttexcoord = texcoord
		
			colors = colors or {1, 1, 1, 1}
			
			alpha = alpha or 1
		
			edit_texture:SetTexture (texture)
			edit_texture.width = width
			edit_texture.height = height
			edit_texture.maximize = maximize
			
			edit_texture:SetVertexColor (colors [1], colors [2], colors [3])
			
			edit_texture:SetAlpha (alpha)

			DF:ScheduleTimer ("RefreshImageEditor", 0.2)
			
			window:Show()
			window.callback_func = callback
			window.extra_param = extraParam
			buttonsBackground:Show()
			buttonsBackground.widget:SetBackdrop (nil)
			
			table.wipe (window.hooks)
		end
		
		function DF:RefreshImageEditor()
		
			if (edit_texture.maximize) then
				DetailsFrameworkImageEdit:SetSize (266, 226)
			else
				DetailsFrameworkImageEdit:SetSize (edit_texture.width, edit_texture.height)
			end
			
			local l, r, t, b = unpack (ttexcoord)
			
			if (l > r) then
				haveHFlip = true
				leftSlider:SetValue (r * 100)
				rightSlider:SetValue (l * 100)
			else
				haveHFlip = false
				leftSlider:SetValue (l * 100)
				rightSlider:SetValue (r * 100)
			end
			
			if (t > b) then
				haveVFlip = true
				topSlider:SetValue (b * 100)
				bottomSlider:SetValue (t * 100)
			else
				haveVFlip = false
				topSlider:SetValue (t * 100)
				bottomSlider:SetValue (b * 100)
			end

			if (window.callback_func) then
				window.accept (nil, nil, true)
			end

		end
		
