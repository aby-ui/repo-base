---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
Icon Widget
-------------------------------------------------------------------------------]]
--[[ s r
local Type, Version = "Icon", 21
]]
local Type, Version = "Icon-OmniCD", 21
-- e
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local select, pairs, print = select, pairs, print

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

-- s b
local USE_ICON_BACKDROP = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
	frame.obj.imagebg:SetBackdropBorderColor(0.5, 0.5, 0.5)	 -- s a
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
	frame.obj.imagebg:SetBackdropBorderColor(0.2, 0.2, 0.25)  -- s a
end

local function Button_OnClick(frame, button)
	frame.obj:Fire("OnClick", button)
	AceGUI:ClearFocus()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetHeight(110)
		self:SetWidth(110)
		self:SetLabel()
		self:SetImage(nil)
		self:SetImageSize(64, 64)
		self:SetDisabled(false)
	end,

	-- ["OnRelease"] = nil,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:Show()
			self.label:SetText(text)
			--[[ s r
			self:SetHeight(self.image:GetHeight() + 25)
			]]
			if USE_ICON_BACKDROP then
				self:SetHeight(self.imagebg:GetHeight() + 25)
			else
				self:SetHeight(self.image:GetHeight() + 25)
			end
			-- e
		else
			self.label:Hide()
			--[[ s r
			self:SetHeight(self.image:GetHeight() + 10)
			]]
			if USE_ICON_BACKDROP then
				self:SetHeight(self.imagebg:GetHeight() + 10)
			else
				self:SetHeight(self.image:GetHeight() + 10)
			end
			-- e
		end
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			local n = select("#", ...)
			if n == 4 or n == 8 then
				image:SetTexCoord(...)
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		end
	end,

	["SetImageSize"] = function(self, width, height)
		--[[ s r
		self.image:SetWidth(width)
		self.image:SetHeight(height)
		--self.frame:SetWidth(width + 30)
		]]
		if USE_ICON_BACKDROP then
			self.imagebg:SetWidth(width)
			self.imagebg:SetHeight(height)
		else
			self.image:SetWidth(width)
			self.image:SetHeight(height)
		end
		-- e
		if self.label:IsShown() then
			self:SetHeight(height + 25)
		else
			self:SetHeight(height + 10)
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.label:SetTextColor(0.5, 0.5, 0.5)
			self.image:SetVertexColor(0.5, 0.5, 0.5, 0.5)
		else
			self.frame:Enable()
			self.label:SetTextColor(1, 1, 1)
			self.image:SetVertexColor(1, 1, 1, 1)
		end
	end
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
	frame:SetScript("OnClick", Button_OnClick)

	--[[ s r
	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	]]
	local label = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall-OmniCD")
	-- e
	label:SetPoint("BOTTOMLEFT")
	label:SetPoint("BOTTOMRIGHT")
	label:SetJustifyH("CENTER")
	label:SetJustifyV("TOP")
	label:SetHeight(18)

	--[[ s r
	local image = frame:CreateTexture(nil, "BACKGROUND")
	image:SetWidth(64)
	image:SetHeight(64)
	image:SetPoint("TOP", 0, -5)
	]]
	if USE_ICON_BACKDROP then
		imagebg = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
		imagebg:SetHeight(64)
		imagebg:SetWidth(64)
		imagebg:SetPoint("TOP", 0, -5)
		OmniCD[1].BackdropTemplate(imagebg)
		imagebg:SetBackdropBorderColor(0.2, 0.2, 0.25)
		imagebg:SetBackdropColor(0, 0, 0, 0)
		image = imagebg:CreateTexture(nil, "OVERLAY")
		OmniCD[1].DisablePixelSnap(image)
		image:SetPoint("TOPLEFT", imagebg.TopEdge, "BOTTOMLEFT")
		image:SetPoint("BOTTOMRIGHT", imagebg.BottomEdge, "TOPRIGHT")
	else
		local image = frame:CreateTexture(nil, "BACKGROUND")
		image:SetWidth(64)
		image:SetHeight(64)
		image:SetPoint("TOP", 0, -5)
	end
	-- e

	local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints(image)
	highlight:SetTexture(136580) -- Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight
	highlight:SetTexCoord(0, 1, 0.23, 0.77)
	highlight:SetBlendMode("ADD")

	local widget = {
		label = label,
		image = image,
		frame = frame,
		type  = Type
	}
	-- s b
	if USE_ICON_BACKDROP then
		widget.imagebg = imagebg
	end
	-- e
	for method, func in pairs(methods) do
		widget[method] = func
	end

	widget.SetText = function(self, ...) print("AceGUI-3.0-Icon: SetText is deprecated! Use SetLabel instead!"); self:SetLabel(...) end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
