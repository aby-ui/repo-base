---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
Checkbox Widget
-------------------------------------------------------------------------------]]
--[[ s r
local Type, Version = "CheckBox", 26
]]
local Type, Version = "CheckBox-OmniCD", 27 --26 by OA
-- e
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local select, pairs = select, pairs

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent

-- s b
local USE_ICON_CROP = false
local DEFAULT_ICON_SIZE = USE_ICON_CROP and 21 or 18 -- tree icon: 18
local IMAGED_CHECKBOX_SIZE = 14
local CROP_FACTOR = 1.5
local CROP_ICON_HEIGHT = DEFAULT_ICON_SIZE / CROP_FACTOR
local CROP_BOTTOM_TEXCOORD = 1/CROP_FACTOR - 0.1
local USE_ICON_BACKDROP = false --WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
--[[ s r
local function AlignImage(self)
	local img = self.image:GetTexture()
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.checkbg, "RIGHT")
		self.text:SetPoint("RIGHT")
	else
		self.text:SetPoint("LEFT", self.image, "RIGHT", 1, 0)
		self.text:SetPoint("RIGHT")
	end
end
]]
local function AlignImage(self)
	local img = self.image:GetTexture()
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.checkbg, "RIGHT", 5, 0) -- our box is 10 smaller
		self.text:SetPoint("RIGHT")
		if USE_ICON_BACKDROP then
			self.imagebg:Hide()
		end
	else
		self.text:SetPoint("LEFT", USE_ICON_BACKDROP and self.imagebg or self.image, "RIGHT", 5, 0)
		self.text:SetPoint("RIGHT")

		if USE_ICON_BACKDROP then
			self.imagebg:Show()
		end
		if self.type ~= "radio" then
			self.checkbg:SetSize(IMAGED_CHECKBOX_SIZE, IMAGED_CHECKBOX_SIZE)
		end
	end
end
-- e

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
--[[ s r
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function CheckBox_OnMouseDown(frame)
	local self = frame.obj
	if not self.disabled then
		if self.image:GetTexture() then
			self.text:SetPoint("LEFT", self.image,"RIGHT", 2, -1)
		else
			self.text:SetPoint("LEFT", self.checkbg, "RIGHT", 1, -1)
		end
	end
	AceGUI:ClearFocus()
end

local function CheckBox_OnMouseUp(frame)
	local self = frame.obj
	if not self.disabled then
		self:ToggleChecked()

		if self.checked then
			PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		else -- for both nil and false (tristate)
			PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		end

		self:Fire("OnValueChanged", self.checked)
		AlignImage(self)
	end
end
]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
	-- v27
--	frame.obj.checkbg:SetBackdropBorderColor(0.5, 0.5, 0.5)	 -- match range slider editbox
	frame.obj.checkbg.border:SetColorTexture(0.5, 0.5, 0.5)
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
	-- v27
--	frame.obj.checkbg:SetBackdropBorderColor(0.2, 0.2, 0.25) -- match range slider editbox
	frame.obj.checkbg.border:SetColorTexture(0.2, 0.2, 0.25)
end

local mouseOverFrame -- (mu) prevent mouseup registering outside of frame region
--[[ not using yet
local cursorArg -- (dnd) drag'n drop
]]

local function CheckBox_OnMouseDown(frame)
	local self = frame.obj
	if not self.disabled then
		if self.image:GetTexture() then
			self.text:SetPoint("LEFT", USE_ICON_BACKDROP and self.imagebg or self.image,"RIGHT", 6, -1)
		else
			self.text:SetPoint("LEFT", self.checkbg, "RIGHT", 6, -1)
		end

		mouseOverFrame = GetMouseFocus();
		---[[
		local arg = self.arg
		if type(arg) == "number" then
			--cursorArg = arg

			local isCtrlKey = IsControlKeyDown()
			if isCtrlKey then
				OmniCD[1].EditSpell(nil, tostring(arg))
			end
		end
		--]]
	end
	AceGUI:ClearFocus()
end

local function CheckBox_OnMouseUp(frame, button)
	local self = frame.obj
	if mouseOverFrame == GetMouseFocus() then
		--[[ not using yet - make it work while disabled
		local controlKey = IsControlKeyDown()
		if controlKey then
			if type(cursorArg) == "function" then
				cursorArg()
			end
		]]
		if not self.disabled then
			self:ToggleChecked()

			if self.checked then
				PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
			else -- for both nil and false (tristate)
				PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
			end

			self:Fire("OnValueChanged", self.checked)
			AlignImage(self)
		end
	else -- v2.6.30 fix text alignment not reverting back to resting state
		if not self.disabled then
			AlignImage(self)
		end
	end

	mouseOverFrame = nil
	--cursorArg = nil
end
--e

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetType()
		self:SetValue(false)
		self:SetTriState(nil)
		-- height is calculated from the width and required space for the description
		self:SetWidth(200)
		self:SetImage()
		self:SetDisabled(nil)
		self:SetDescription(nil)
		--self:SetArg(nil) -- s a reset arg (dnd) not using yet
	end,

	-- ["OnRelease"] = nil,

	["OnWidthSet"] = function(self, width)
		if self.desc then
			self.desc:SetWidth(width - 30)
			if self.desc:GetText() and self.desc:GetText() ~= "" then
				self:SetHeight(28 + self.desc:GetStringHeight())
			end
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.text:SetTextColor(0.5, 0.5, 0.5)
			SetDesaturation(self.check, true)
			if self.desc then
				self.desc:SetTextColor(0.5, 0.5, 0.5)
			end
			-- v27
--			self.checkbg:SetBackdropColor(0.5, 0.5, 0.5) -- s a
			self.checkbg.bg:SetColorTexture(0.5, 0.5, 0.5)
		else
			self.frame:Enable()
			self.text:SetTextColor(1, 1, 1)
			if self.tristate and self.checked == nil then
				SetDesaturation(self.check, true)
			else
				SetDesaturation(self.check, false)
			end
			if self.desc then
				self.desc:SetTextColor(1, 1, 1)
			end
			-- v27
--			self.checkbg:SetBackdropColor(0, 0, 0) -- s a
			self.checkbg.bg:SetColorTexture(0, 0, 0)
		end
	end,

	["SetValue"] = function(self, value)
		local check = self.check
		self.checked = value
		if value then
			SetDesaturation(check, false)
			check:Show()
		else
			--Nil is the unknown tristate value
			if self.tristate and value == nil then
				SetDesaturation(check, true)
				check:Show()
			else
				SetDesaturation(check, false)
				check:Hide()
			end
		end

		self:SetDisabled(self.disabled)
	end,

	["GetValue"] = function(self)
		return self.checked
	end,

	["SetTriState"] = function(self, enabled)
		self.tristate = enabled
		self:SetValue(self:GetValue())
	end,

	["SetType"] = function(self, type)
		local checkbg = self.checkbg
		local check = self.check
		--[[ s -r
		local highlight = self.highlight
		]]

		local size
		if type == "radio" then
			size = 16
			checkbg:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
			checkbg:SetTexCoord(0, 0.25, 0, 1)
			check:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
			check:SetTexCoord(0.25, 0.5, 0, 1)
			check:SetBlendMode("ADD")
			--[[ s -r
			highlight:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
			highlight:SetTexCoord(0.5, 0.75, 0, 1)
			]]
		else
			--[[ s r
			size = 24
			checkbg:SetTexture(130755) -- Interface\\Buttons\\UI-CheckBox-Up
			checkbg:SetTexCoord(0, 1, 0, 1)
			check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check
			check:SetTexCoord(0, 1, 0, 1)
			check:SetBlendMode("BLEND")
			highlight:SetTexture(130753) -- Interface\\Buttons\\UI-CheckBox-Highlight
			highlight:SetTexCoord(0, 1, 0, 1)
			]]
			size = 14 -- No img info yet, set box size on SetImage
			check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check
			check:SetTexCoord(0, 1, 0, 1)
			check:SetBlendMode("BLEND")
			-- e
		end

		checkbg:SetHeight(size)
		checkbg:SetWidth(size)
	end,

	["ToggleChecked"] = function(self)
		local value = self:GetValue()
		if self.tristate then
			--cycle in true, nil, false order
			if value then
				self:SetValue(nil)
			elseif value == nil then
				self:SetValue(false)
			else
				self:SetValue(true)
			end
		else
			self:SetValue(not self:GetValue())
		end
	end,

	["SetLabel"] = function(self, label)
		self.text:SetText(label)
	end,

	["SetDescription"] = function(self, desc)
		if desc then
			if not self.desc then
				--[[ s r
				local f = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				]]
				local f = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall-OmniCD")
				-- e
				f:ClearAllPoints()
				f:SetPoint("TOPLEFT", self.checkbg, "TOPRIGHT", 5, -21)
				f:SetWidth(self.frame.width - 30)
				f:SetPoint("RIGHT", self.frame, "RIGHT", -30, 0)
				f:SetJustifyH("LEFT")
				f:SetJustifyV("TOP")
				self.desc = f
			end
			self.desc:Show()
			--self.text:SetFontObject(GameFontNormal)
			self.desc:SetText(desc)
			self:SetHeight(28 + self.desc:GetStringHeight())
		else
			if self.desc then
				self.desc:SetText("")
				self.desc:Hide()
			end
			--self.text:SetFontObject(GameFontHighlight)
			self:SetHeight(24)
		end
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			local n = select("#", ...)
			if n == 4 or n == 8 then
				--[[ s r
				image:SetTexCoord(...)
				]]
				if USE_ICON_BACKDROP then -- override
					if USE_ICON_CROP then
						self.imagebg:SetHeight(CROP_ICON_HEIGHT)
						image:SetTexCoord(0.05, 0.95, 0.1, CROP_BOTTOM_TEXCOORD)
					else
						self.imagebg:SetHeight(DEFAULT_ICON_SIZE)
						image:SetTexCoord(0.07, 0.93, 0.07, 0.93)
					end
				else
					if USE_ICON_CROP then
						image:SetHeight(CROP_ICON_HEIGHT)
						image:SetTexCoord(0.05, 0.95, 0.1, CROP_BOTTOM_TEXCOORD)
					else
						image:SetHeight(DEFAULT_ICON_SIZE)
						image:SetTexCoord(...)
					end
				end
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		end
		AlignImage(self)
	end,

	-- s b (edit/dnd)
	---[[
	["SetArg"] = function(self, arg)
		self.arg = arg
	end
	--]]
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Button", nil, UIParent)
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)
	frame:SetScript("OnMouseDown", CheckBox_OnMouseDown)
	frame:SetScript("OnMouseUp", CheckBox_OnMouseUp)

	frame:SetHitRectInsets(0, 10, 0, 0) -- s a (avoid misclicking) -- v27 20>10

	--[[ s r
	local checkbg = frame:CreateTexture(nil, "ARTWORK")
	checkbg:SetWidth(24)
	checkbg:SetHeight(24)
	checkbg:SetPoint("TOPLEFT")
	checkbg:SetTexture(130755) -- Interface\\Buttons\\UI-CheckBox-Up

	local check = frame:CreateTexture(nil, "OVERLAY")
	check:SetAllPoints(checkbg)
	check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check
	]]
	local checkbg = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	checkbg:SetWidth(14)
	checkbg:SetHeight(14)
	checkbg:SetPoint("LEFT")
	-- v27 added texture borders instead of backdrop
	-- OmniCD[1].BackdropTemplate(checkbg)
	-- checkbg:SetBackdropColor(0, 0, 0)
	-- checkbg:SetBackdropBorderColor(0.2, 0.2, 0.25)
	checkbg.border = checkbg:CreateTexture(nil, "BACKGROUND")
	OmniCD[1].DisablePixelSnap(checkbg.border)
	checkbg.border:SetAllPoints()
	checkbg.border:SetColorTexture(0.2, 0.2, 0.25)

	checkbg.bg = checkbg:CreateTexture(nil, "BORDER")
	OmniCD[1].DisablePixelSnap(checkbg.bg)
	checkbg.bg:SetColorTexture(0, 0, 0)
	local edgeSize = OmniCD[1].PixelMult
	checkbg.bg:SetPoint("TOPLEFT", checkbg, "TOPLEFT", edgeSize, -edgeSize)
	checkbg.bg:SetPoint("BOTTOMRIGHT", checkbg, "BOTTOMRIGHT", -edgeSize, edgeSize)

	local check = checkbg:CreateTexture(nil, "OVERLAY")
	check:SetPoint("TOPLEFT", -5, 5)
	check:SetPoint("BOTTOMRIGHT", 5, -5)
	check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check
	-- e

	--[[ s r
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	]]
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight-OmniCD")
	-- e
	text:SetJustifyH("LEFT")
	text:SetHeight(18)
	text:SetPoint("LEFT", checkbg, "RIGHT")
	text:SetPoint("RIGHT")

	--[[ s -r
	local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetTexture(130753) -- Interface\\Buttons\\UI-CheckBox-Highlight
	highlight:SetBlendMode("ADD")
	highlight:SetAllPoints(checkbg)
	]]

	--[[ s r
	local image = frame:CreateTexture(nil, "OVERLAY")
	image:SetHeight(16)
	image:SetWidth(16)
	image:SetPoint("LEFT", checkbg, "RIGHT", 1, 0)
	]]
	local imagebg, image
	if USE_ICON_BACKDROP then
		imagebg = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
		imagebg:SetHeight(DEFAULT_ICON_SIZE) -- 24 is frames full height
		imagebg:SetWidth(DEFAULT_ICON_SIZE)
		imagebg:SetPoint("LEFT", checkbg, "RIGHT", 2, 0)
		-- v27
--		OmniCD[1].BackdropTemplate(imagebg)
--		imagebg:SetBackdropBorderColor(0.2, 0.2, 0.05)
		imagebg.border = imagebg:CreateTexture(nil, "BORDER")
		OmniCD[1].DisablePixelSnap(imagebg.border)
		imagebg.border:SetAllPoints()
		imagebg.border:SetColorTexture(0.2, 0.2, 0.05)

		image = imagebg:CreateTexture(nil, "OVERLAY")
		OmniCD[1].DisablePixelSnap(image)
		-- v27
--		image:SetPoint("TOPLEFT", imagebg.TopEdge, "BOTTOMLEFT")
--		image:SetPoint("BOTTOMRIGHT", imagebg.BottomEdge, "TOPRIGHT")
		image:SetPoint("TOPLEFT", imagebg, "TOPLEFT", edgeSize, -edgeSize)
		image:SetPoint("BOTTOMRIGHT", imagebg, "BOTTOMRIGHT", -edgeSize, edgeSize)
	else
		image = frame:CreateTexture(nil, "OVERLAY")
		image:SetHeight(DEFAULT_ICON_SIZE)
		image:SetWidth(DEFAULT_ICON_SIZE)
		image:SetPoint("LEFT", checkbg, "RIGHT", 2, 0)
	end
	-- e

	local widget = {
		checkbg	  = checkbg,
		check	  = check,
		text	  = text,
		--[[ s -r
		highlight = highlight,
		]]
		image	  = image,
		frame	  = frame,
		type	  = Type
	}

	-- s b
	if USE_ICON_BACKDROP then
		widget.imagebg = imagebg
	end
	-- e

	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
