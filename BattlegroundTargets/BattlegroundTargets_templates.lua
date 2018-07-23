-- -------------------------------------------------------------------------- --
-- BattlegroundTargets by kunda                                               --
-- -------------------------------------------------------------------------- --

local print = print
local type = type
local unpack = unpack
local CreateFrame = CreateFrame

-- external resources BEGIN ------------------------------------------------- --
local _, prg = ...
if type(prg) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
-- external resources END --------------------------------------------------- --

-- -------------------------------------------------------------------------- --
-- TEMPLATE | templates
local TEMPLATE = {}
prg.TEMPLATE = TEMPLATE
-- -------------------------------------------------------------------------- --

local Textures = {}
Textures.Path          = "Interface\\AddOns\\BattlegroundTargets\\BattlegroundTargets-texture-icons"
Textures.SliderKnob    = {0.578125, 0.75,     0.734375, 1}        -- {37/64, 48/64, 47/64, 64/64}
Textures.SliderBG_Lnor = {0.015625, 0.09375,  0.578125, 0.671875} -- { 1/64,  6/64, 37/64, 43/64}
Textures.SliderBG_Mnor = {0.109375, 0.125,    0.578125, 0.671875} -- { 7/64,  8/64, 37/64, 43/64}
Textures.SliderBG_Rnor = {0.125,    0.203125, 0.578125, 0.671875} -- { 8/64, 13/64, 37/64, 43/64}
Textures.SliderBG_Ldis = {0.21875,  0.296875, 0.578125, 0.671875} -- {14/64, 19/64, 37/64, 43/64}
Textures.SliderBG_Mdis = {0.296875, 0.3125,   0.578125, 0.671875} -- {19/64, 20/64, 37/64, 43/64}
Textures.SliderBG_Rdis = {0.328125, 0.40625,  0.578125, 0.671875} -- {21/64, 26/64, 37/64, 43/64}
Textures.Expand        = {0.015625, 0.28125,  0.015625, 0.28125}  -- { 1/64, 18/64,  1/64, 18/64}
Textures.Collapse      = {0.28125,  0.28125,  0.28125,  0.015625, 0.015625, 0.28125,  0.015625, 0.015625}
Textures.Close         = {0.015625, 0.28125,  0.296875, 0.5625}   -- { 1/64, 18/64, 19/64, 36/64}
Textures.Copy1         = {0.296875, 0.6875,   0.015625, 0.28125}  -- {19/64, 44/64,  1/64, 18/64}
Textures.Copy2         = {0.296875, 0.6875,   0.296875, 0.5625}   -- {19/64, 44/64, 19/64, 36/64}

local function NOOP() end

local function Desaturation(texture, desaturation)
	local shaderSupported = texture:SetDesaturated(desaturation)
	if not shaderSupported then
		if desaturation then
			texture:SetVertexColor(0.5, 0.5, 0.5)
		else
			texture:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end

-- -----------------------------------------------------------------------------
TEMPLATE.BorderTRBL = function(frame) -- TRBL = Top-Right-Bottom-Left
	frame.FrameBorder = frame:CreateTexture(nil, "BORDER")
	frame.FrameBorder:SetPoint("TOPLEFT", 1, -1)
	frame.FrameBorder:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.FrameBorder:SetColorTexture(0, 0, 0, 1)
	frame.FrameBackground = frame:CreateTexture(nil, "BACKGROUND")
	frame.FrameBackground:SetPoint("TOPLEFT", 0, 0)
	frame.FrameBackground:SetPoint("BOTTOMRIGHT", 0, 0)
	frame.FrameBackground:SetColorTexture(0.8, 0.2, 0.2, 1)
end
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
local ButtonColor = {
	{normal = {0.38, 0   , 0   , 1}, border = {0.73, 0.26, 0.21, 1}, font = "GameFontNormal"     }, -- 1 red
	{normal = {0   , 0   , 0.5 , 1}, border = {0.43, 0.32, 0.68, 1}, font = "GameFontNormalSmall"}, -- 2 blue
	{normal = {0   , 0.2 , 0   , 1}, border = {0.24, 0.46, 0.21, 1}, font = "GameFontNormalSmall"}, -- 3 green
	{normal = {0.38, 0   , 0   , 1}, border = {0.73, 0.26, 0.21, 1}, font = "GameFontNormalSmall"}, -- 4 red
	{normal = {0.11, 0.11, 0.11, 1}, border = {0.44, 0.44, 0.44, 1}, font = "GameFontNormalSmall"}, -- 5 dark grey
}

TEMPLATE.DisableTextButton = function(button)
	button.Text:SetTextColor(0.4, 0.4, 0.4, 1)
	button.Border:SetColorTexture(0.4, 0.4, 0.4, 1)
	button:EnableMouse(false)
	button:Disable()
end

TEMPLATE.EnableTextButton = function(button)
	button.Text:SetTextColor(button.r, button.g, button.b, 1)
	button.Border:SetColorTexture(unpack(ButtonColor[button.action].border))
	button:EnableMouse(true)
	button:Enable()
end

TEMPLATE.TextButton = function(button, text, action)
	button.Background = button:CreateTexture(nil, "BORDER")
	button.Background:SetPoint("TOPLEFT", 1, -1)
	button.Background:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Background:SetColorTexture(0, 0, 0, 1)

	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetPoint("TOPLEFT", 0, 0)
	button.Border:SetPoint("BOTTOMRIGHT", 0, 0)
	button.Border:SetColorTexture(unpack(ButtonColor[action].border))

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", 2, -2)
	button.Normal:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Normal:SetColorTexture(unpack(ButtonColor[action].normal))
	button:SetNormalTexture(button.Normal)

	button.Disabled = button:CreateTexture(nil, "OVERLAY")
	button.Disabled:SetPoint("TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Disabled:SetColorTexture(0.6, 0.6, 0.6, 0.2)
	button:SetDisabledTexture(button.Disabled)

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", 3, -3)
	button.Highlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Highlight:SetColorTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.Highlight)

	button.Text = button:CreateFontString(nil, "OVERLAY", ButtonColor[action].font)
	button.Text:SetPoint("CENTER", 0, 0)
	button.Text:SetJustifyH("CENTER")
	button.Text:SetTextColor(1, 0.82, 0, 1)
	button.Text:SetText(text)

	button:SetScript("OnMouseDown", function(self) self.Text:SetPoint("CENTER", 1, -1) end)
	button:SetScript("OnMouseUp", function(self) self.Text:SetPoint("CENTER", 0, 0) end)

	button.action = action
	button.r, button.g, button.b = button.Text:GetTextColor()
end
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
TEMPLATE.SetIconButton = function(button, cut)
	local texture
	if cut == 1 then
		texture = Textures.Copy1
	elseif cut == 2 then
		texture = Textures.Copy2
	else--if cut == 0 then
		texture = Textures.Close
	end
	button.Normal:SetTexCoord(unpack(texture))
	button.Push:SetTexCoord(unpack(texture))
	button.Disabled:SetTexCoord(unpack(texture))
end

TEMPLATE.DisableIconButton = function(button)
	button.Border:SetColorTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnableIconButton = function(button)
	button.Border:SetColorTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.IconButton = function(button, cut)
	local texture
	if cut == 1 then
		texture = Textures.Copy1
	elseif cut == 2 then
		texture = Textures.Copy2
	else--if cut == 0 then
		texture = Textures.Close
	end

	button.Back = button:CreateTexture(nil, "BORDER")
	button.Back:SetPoint("TOPLEFT", 1, -1)
	button.Back:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Back:SetColorTexture(0, 0, 0, 1)

	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetPoint("TOPLEFT", 0, 0)
	button.Border:SetPoint("BOTTOMRIGHT", 0, 0)
	button.Border:SetColorTexture(0.8, 0.2, 0.2, 1)

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", 3, -3)
	button.Highlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Highlight:SetColorTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.Highlight)

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", 3, -3)
	button.Normal:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Normal:SetTexture(Textures.Path)
	button.Normal:SetTexCoord(unpack(texture))
	button:SetNormalTexture(button.Normal)

	button.Push = button:CreateTexture(nil, "ARTWORK")
	button.Push:SetPoint("TOPLEFT", 4, -4)
	button.Push:SetPoint("BOTTOMRIGHT", -4, 4)
	button.Push:SetTexture(Textures.Path)
	button.Push:SetTexCoord(unpack(texture))
	button:SetPushedTexture(button.Push)

	button.Disabled = button:CreateTexture(nil, "ARTWORK")
	button.Disabled:SetPoint("TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Disabled:SetTexture(Textures.Path)
	button.Disabled:SetTexCoord(unpack(texture))
	button:SetDisabledTexture(button.Disabled)
	Desaturation(button.Disabled, true)
end
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
TEMPLATE.DisableCheckButton = function(button)
	if button.Text then
		button.Text:SetTextColor(0.5, 0.5, 0.5)
	elseif button.Icon then
		Desaturation(button.Icon, true)
	end
	button.Border:SetColorTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnableCheckButton = function(button)
	if button.Text then
		button.Text:SetTextColor(1, 1, 1)
	elseif button.Icon then
		Desaturation(button.Icon, false)
	end
	button.Border:SetColorTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.CheckButton = function(button, size, space, text, icon)
	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetWidth( size )
	button.Border:SetHeight( size )
	button.Border:SetPoint("LEFT", 0, 0)
	button.Border:SetColorTexture(0.4, 0.4, 0.4, 1)

	button.Background = button:CreateTexture(nil, "BORDER")
	button.Background:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 1, -1)
	button.Background:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -1, 1)
	button.Background:SetColorTexture(0, 0, 0, 1)

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 1, -1)
	button.Normal:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -1, 1)
	button.Normal:SetColorTexture(0, 0, 0, 1)
	button:SetNormalTexture(button.Normal)

	button.Push = button:CreateTexture(nil, "ARTWORK")
	button.Push:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 4, -4)
	button.Push:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -4, 4)
	button.Push:SetColorTexture(0.4, 0.4, 0.4, 0.5)
	button:SetPushedTexture(button.Push)

	button.Disabled = button:CreateTexture(nil, "ARTWORK")
	button.Disabled:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -3, 3)
	button.Disabled:SetColorTexture(0.4, 0.4, 0.4, 0.5)
	button:SetDisabledTexture(button.Disabled)

	button.Checked = button:CreateTexture(nil, "ARTWORK")
	button.Checked:SetWidth( size )
	button.Checked:SetHeight( size )
	button.Checked:SetPoint("LEFT", 0, 0)
	button.Checked:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:SetCheckedTexture(button.Checked)

	if type(icon) == "table" then
		local width   = icon.width or 0
		local height  = icon.height or 0
		local coords1 = icon.coords[1] or 0
		local coords2 = icon.coords[2] or 0
		local coords3 = icon.coords[3] or 0
		local coords4 = icon.coords[4] or 0
		button.Icon = button:CreateTexture(nil, "BORDER")
		button.Icon:SetWidth(width)
		button.Icon:SetHeight(height)
		button.Icon:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
		button.Icon:SetTexture(Textures.Path)
		button.Icon:SetTexCoord(coords1, coords2, coords3, coords4)
		button:SetWidth(size + space + width + space)
		button:SetHeight(size)
	else
		button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		button.Text:SetHeight( size )
		button.Text:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
		button.Text:SetJustifyH("LEFT")
		button.Text:SetText(text)
		button.Text:SetTextColor(1, 1, 1, 1)
		button:SetWidth(size + space + button.Text:GetStringWidth() + space)
		button:SetHeight(size)
	end

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.Highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.Highlight:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
	button.Highlight:Hide()

	button:SetScript("OnEnter", function() button.Highlight:Show() end)
	button:SetScript("OnLeave", function() button.Highlight:Hide() end)
end
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
TEMPLATE.SetTabButton = function(button, show)
	if show then
		button.TextureBottom:SetColorTexture(0, 0, 0, 1)
		button.TextureBorder:SetColorTexture(0.8, 0.2, 0.2, 1)
		button.show = true
	else
		button.TextureBottom:SetColorTexture(0.8, 0.2, 0.2, 1)
		button.TextureBorder:SetColorTexture(0.4, 0.4, 0.4, 0.4)
		button.show = false
	end
end

TEMPLATE.DisableTabButton = function(button)
	if button.TabText then
		button.TabText:SetTextColor(0.5, 0.5, 0.5, 1)
	elseif button.TabTexture then
		Desaturation(button.TabTexture, true)
	end
	button:Disable()
end

TEMPLATE.EnableTabButton = function(button, active)
	if button.TabText then
		if button.monotext then
			button.TabText:SetTextColor(1, 0.82, 0, 1)
		elseif active then
			button.TabText:SetTextColor(0, 0.75, 0, 1)
		else
			button.TabText:SetTextColor(1, 0, 0, 1)
		end
	elseif button.TabTexture then
		Desaturation(button.TabTexture, false)
	end
	button:Enable()
end

TEMPLATE.TabButton = function(button, text, active, monotext)
	button.monotext = monotext
	button.Texture = button:CreateTexture(nil, "BORDER")
	button.Texture:SetPoint("TOPLEFT", 1, -1)
	button.Texture:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Texture:SetColorTexture(0, 0, 0, 1)

	button.TextureBorder = button:CreateTexture(nil, "BACKGROUND")
	button.TextureBorder:SetPoint("TOPLEFT", 0, 0)
	button.TextureBorder:SetPoint("BOTTOMRIGHT", -1, 1)
	button.TextureBorder:SetPoint("TOPRIGHT" ,0, 0)
	button.TextureBorder:SetPoint("BOTTOMLEFT" ,1, 1)
	button.TextureBorder:SetColorTexture(0.8, 0.2, 0.2, 1)

	button.TextureBottom = button:CreateTexture(nil, "ARTWORK")
	button.TextureBottom:SetPoint("TOPLEFT", button, "BOTTOMLEFT" ,1, 2)
	button.TextureBottom:SetPoint("BOTTOMLEFT" ,1, 1)
	button.TextureBottom:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT" ,-1, 2)
	button.TextureBottom:SetPoint("BOTTOMRIGHT" ,-1, 1)
	button.TextureBottom:SetColorTexture(0.8, 0.2, 0.2, 1)

	button.TextureHighlight = button:CreateTexture(nil, "ARTWORK")
	button.TextureHighlight:SetPoint("TOPLEFT", 3, -3)
	button.TextureHighlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.TextureHighlight:SetColorTexture(1, 1, 1, 0.1)
	button:SetHighlightTexture(button.TextureHighlight)

	button.TabText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	button.TabText:SetText(text)
	button.TabText:SetWidth(button.TabText:GetStringWidth()+10)
	button.TabText:SetHeight(12)
	button.TabText:SetPoint("CENTER", button, "CENTER", 0, 0)
	button.TabText:SetJustifyH("CENTER")
	if monotext then
		button.TabText:SetTextColor(1, 0.82, 0, 1)
	elseif active then
		button.TabText:SetTextColor(0, 0.75, 0, 1)
	else
		button.TabText:SetTextColor(1, 0, 0, 1)
	end

	button:SetScript("OnEnter", function() if not button.show then button.TextureBorder:SetColorTexture(0.4, 0.4, 0.4, 0.8) end end)
	button:SetScript("OnLeave", function() if not button.show then button.TextureBorder:SetColorTexture(0.4, 0.4, 0.4, 0.4) end end)
end
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
TEMPLATE.DisableSlider = function(slider)
	slider.textMin:SetTextColor(0.5, 0.5, 0.5, 1)
	slider.textMax:SetTextColor(0.5, 0.5, 0.5, 1)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG_Ldis))
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG_Mdis))
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG_Rdis))
	slider.thumb:SetTexCoord(0, 0, 0, 0)
	slider.Background:SetColorTexture(0, 0, 0, 0)
	slider:SetScript("OnEnter", NOOP)
	slider:SetScript("OnLeave", NOOP)
	slider:Disable()
end

TEMPLATE.EnableSlider = function(slider)
	slider.textMin:SetTextColor(0.8, 0.8, 0.8, 1)
	slider.textMax:SetTextColor(0.8, 0.8, 0.8, 1)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG_Lnor))
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG_Mnor))
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG_Rnor))
	slider.thumb:SetTexCoord(unpack(Textures.SliderKnob))
	slider:SetScript("OnEnter", function() slider.Background:SetColorTexture(1, 1, 1, 0.15) end) -- COPYHL
	slider:SetScript("OnLeave", function() slider.Background:SetColorTexture(0, 0, 0, 0) end)
	slider:Enable()
end

TEMPLATE.Slider = function(slider, width, step, minVal, maxVal, curVal, func, measure)
	slider:SetWidth(width)
	slider:SetHeight(16)
	slider:SetValueStep(step)
	slider:SetObeyStepOnDrag(true)
	slider:SetMinMaxValues(minVal, maxVal)
	slider:SetValue(curVal)
	slider:SetOrientation("HORIZONTAL")

	slider.Background = slider:CreateTexture(nil, "BACKGROUND")
	slider.Background:SetWidth(width)
	slider.Background:SetHeight(16)
	slider.Background:SetPoint("LEFT", 0, 0)
	slider.Background:SetColorTexture(0, 0, 0, 0)

	slider.textMin = slider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	slider.textMin:SetPoint("TOP", slider, "BOTTOM", 0, -1)
	slider.textMin:SetPoint("LEFT", slider, "LEFT", 0, 0)
	slider.textMin:SetJustifyH("CENTER")
	slider.textMin:SetTextColor(0.8, 0.8, 0.8, 1)
	if measure == "%" then
		slider.textMin:SetText(minVal.."%")
	elseif measure == "K" then
		slider.textMin:SetText((minVal/1000).."k")
	elseif measure == "H" then
		slider.textMin:SetText((minVal/100))
	elseif measure == "px" then
		slider.textMin:SetText(minVal.."px")
	elseif measure == "blank" then
		slider.textMin:SetText("")
	else
		slider.textMin:SetText(minVal)
	end
	slider.textMax = slider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	slider.textMax:SetPoint("TOP", slider, "BOTTOM", 0, -1)
	slider.textMax:SetPoint("RIGHT", slider, "RIGHT", 0, 0)
	slider.textMax:SetJustifyH("CENTER")
	slider.textMax:SetTextColor(0.8, 0.8, 0.8, 1)
	if measure == "%" then
		slider.textMax:SetText(maxVal.."%")
	elseif measure == "K" then
		slider.textMax:SetText((maxVal/1000).."k")
	elseif measure == "H" then
		slider.textMax:SetText((maxVal/100))
	elseif measure == "px" then
		slider.textMax:SetText(maxVal.."px")
	elseif measure == "blank" then
		slider.textMax:SetText("")
	else
		slider.textMax:SetText(maxVal)
	end

	slider.sliderBGL = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGL:SetWidth(5)
	slider.sliderBGL:SetHeight(6)
	slider.sliderBGL:SetPoint("LEFT", slider, "LEFT", 0, 0)
	slider.sliderBGL:SetTexture(Textures.Path)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG_Lnor))
	slider.sliderBGM = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGM:SetWidth(width-5-5)
	slider.sliderBGM:SetHeight(6)
	slider.sliderBGM:SetPoint("LEFT", slider.sliderBGL, "RIGHT", 0, 0)
	slider.sliderBGM:SetTexture(Textures.Path)
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG_Mnor))
	slider.sliderBGR = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGR:SetWidth(5)
	slider.sliderBGR:SetHeight(6)
	slider.sliderBGR:SetPoint("LEFT", slider.sliderBGM, "RIGHT", 0, 0)
	slider.sliderBGR:SetTexture(Textures.Path)
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG_Rnor))

	slider.thumb = slider:CreateTexture(nil, "BORDER")
	slider.thumb:SetWidth(11)
	slider.thumb:SetHeight(17)
	slider.thumb:SetTexture(Textures.Path)
	slider.thumb:SetTexCoord(unpack(Textures.SliderKnob))
	slider:SetThumbTexture(slider.thumb)

	slider:SetScript("OnValueChanged", function(self, value)
		if not slider:IsEnabled() then return end
		if func then
			func(self, value)
		end
	end)

	slider:SetScript("OnEnter", function() slider.Background:SetColorTexture(1, 1, 1, 0.15) end) -- COPYHL
	slider:SetScript("OnLeave", function() slider.Background:SetColorTexture(0, 0, 0, 0) end)
end
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
TEMPLATE.DisablePullDownMenu = function(button)
	button.PullDownMenu:Hide()
	button.PullDownButtonBorder:SetColorTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnablePullDownMenu = function(button)
	button.PullDownButtonBorder:SetColorTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.PullDownMenu = function(button, contentTable, buttonText, pulldownWidth, func, buttonOnEnterFunc, buttonOnLeaveFunc)
	local sizeOffset = 5
	local sizeBarHeight = 14

	button.PullDownButtonBG = button:CreateTexture(nil, "BORDER")
	button.PullDownButtonBG:SetPoint("TOPLEFT", 1, -1)
	button.PullDownButtonBG:SetPoint("BOTTOMRIGHT", -1, 1)
	button.PullDownButtonBG:SetColorTexture(0, 0, 0, 1)

	button.PullDownButtonBorder = button:CreateTexture(nil, "BACKGROUND")
	button.PullDownButtonBorder:SetPoint("TOPLEFT", 0, 0)
	button.PullDownButtonBorder:SetPoint("BOTTOMRIGHT", 0, 0)
	button.PullDownButtonBorder:SetColorTexture(0.4, 0.4, 0.4, 1)

	button.PullDownButtonExpand = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonExpand:SetHeight(14)
	button.PullDownButtonExpand:SetWidth(14)
	button.PullDownButtonExpand:SetPoint("RIGHT", button, "RIGHT", -2, 0)
	button.PullDownButtonExpand:SetTexture(Textures.Path)
	button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand))
	button:SetNormalTexture(button.PullDownButtonExpand)

	button.PullDownButtonDisabled = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonDisabled:SetPoint("TOPLEFT", 3, -3)
	button.PullDownButtonDisabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.PullDownButtonDisabled:SetColorTexture(0.6, 0.6, 0.6, 0.2)
	button:SetDisabledTexture(button.PullDownButtonDisabled)

	button.PullDownButtonHighlight = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonHighlight:SetPoint("TOPLEFT", 1, -1)
	button.PullDownButtonHighlight:SetPoint("BOTTOMRIGHT", -1, 1)
	button.PullDownButtonHighlight:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
	button:SetHighlightTexture(button.PullDownButtonHighlight)

	button.PullDownButtonText = button:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	button.PullDownButtonText:SetHeight(sizeBarHeight)
	button.PullDownButtonText:SetPoint("LEFT", sizeOffset+2, 0)
	button.PullDownButtonText:SetJustifyH("LEFT")
	button.PullDownButtonText:SetText(buttonText)
	button.PullDownButtonText:SetTextColor(1, 1, 0.49, 1)

	button.PullDownMenu = CreateFrame("Frame", nil, button)
	TEMPLATE.BorderTRBL(button.PullDownMenu)
	button.PullDownMenu:EnableMouse(true)
	button.PullDownMenu:SetToplevel(true)
	button.PullDownMenu:SetHeight(sizeOffset+(#contentTable*sizeBarHeight)+sizeOffset)
	button.PullDownMenu:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, 1)
	button.PullDownMenu:Hide()

	local function OnLeave()
		if not button:IsMouseOver() and not button.PullDownMenu:IsMouseOver() then
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand))
		end
	end

	local autoWidth = 0
	for i = 1, #contentTable do
		if not button.PullDownMenu.Button then button.PullDownMenu.Button = {} end
		button.PullDownMenu.Button[i] = CreateFrame("Button", nil, button.PullDownMenu)
		button.PullDownMenu.Button[i]:SetHeight(sizeBarHeight)
		button.PullDownMenu.Button[i]:SetFrameLevel( button.PullDownMenu:GetFrameLevel() + 5 )
		if i == 1 then
			button.PullDownMenu.Button[i]:SetPoint("TOPLEFT", button.PullDownMenu, "TOPLEFT", sizeOffset, -sizeOffset)
		else
			button.PullDownMenu.Button[i]:SetPoint("TOPLEFT", button.PullDownMenu.Button[(i-1)], "BOTTOMLEFT", 0, 0)
		end

		button.PullDownMenu.Button[i].Text = button.PullDownMenu.Button[i]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		button.PullDownMenu.Button[i].Text:SetHeight(sizeBarHeight)
		button.PullDownMenu.Button[i].Text:SetPoint("LEFT", 2, 0)
		button.PullDownMenu.Button[i].Text:SetJustifyH("LEFT")
		button.PullDownMenu.Button[i].Text:SetTextColor(1, 1, 1, 1)

		if buttonOnEnterFunc and buttonOnLeaveFunc then
			button.PullDownMenu.Button[i]:SetScript("OnEnter", function(self) buttonOnEnterFunc(self, button) end)
			button.PullDownMenu.Button[i]:SetScript("OnLeave", function(self) buttonOnLeaveFunc(self, button) OnLeave() end)
		else
			button.PullDownMenu.Button[i]:SetScript("OnLeave", OnLeave)
		end
		button.PullDownMenu.Button[i]:SetScript("OnClick", function()
			button.value1 = button.PullDownMenu.Button[i].value1
			button.PullDownButtonText:SetText( button.PullDownMenu.Button[i].Text:GetText() )
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand))
			if func then
				func(button.value1) -- PDFUNC
			end
		end)

		button.PullDownMenu.Button[i].Highlight = button.PullDownMenu.Button[i]:CreateTexture(nil, "ARTWORK")
		button.PullDownMenu.Button[i].Highlight:SetPoint("TOPLEFT", 0, 0)
		button.PullDownMenu.Button[i].Highlight:SetPoint("BOTTOMRIGHT", 0, 0)
		button.PullDownMenu.Button[i].Highlight:SetColorTexture(1, 1, 1, 0.2)
		button.PullDownMenu.Button[i]:SetHighlightTexture(button.PullDownMenu.Button[i].Highlight)

		button.PullDownMenu.Button[i].Text:SetText(contentTable[i])
		button.PullDownMenu.Button[i].value1 = i
		button.PullDownMenu.Button[i]:Show()

		if pulldownWidth <= 0 then
			local w = button.PullDownMenu.Button[i].Text:GetStringWidth()+15+18
			if w > autoWidth then
				autoWidth = w
			end
		end
	end

	--  < 0 : auto, but max width n
	-- == 0 : auto
	--  > 0 : fixed width n
	local newWidth = pulldownWidth
	if pulldownWidth < 0 then
		if autoWidth < -pulldownWidth then
			newWidth = autoWidth
		else
			newWidth = -pulldownWidth
		end
	elseif pulldownWidth == 0 then
		newWidth = autoWidth
	end

	button.PullDownButtonText:SetWidth(newWidth-sizeOffset-sizeOffset)
	button.PullDownMenu:SetWidth(newWidth)
	for i = 1, #contentTable do
		button.PullDownMenu.Button[i]:SetWidth(newWidth-sizeOffset-sizeOffset)
		button.PullDownMenu.Button[i].Text:SetWidth(newWidth-sizeOffset-sizeOffset)
	end
	button:SetWidth(newWidth)

	button.PullDownMenu:SetScript("OnLeave", OnLeave)
	button.PullDownMenu:SetScript("OnHide", function(self) self:Hide() end) -- for esc close

	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnClick", function()
		if button.PullDownMenu:IsShown() then
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand))
		else
			button.PullDownMenu:Show()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Collapse))
		end
	end)
end
-- -----------------------------------------------------------------------------