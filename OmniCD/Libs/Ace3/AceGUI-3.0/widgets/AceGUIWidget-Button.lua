---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
Button Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "Button-OmniCD", 24
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Button_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	frame.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")

	PlaySound(1217)
	local fadeOut = frame.fadeOut
	if fadeOut:IsPlaying() then
		fadeOut:Stop()
	end
	frame.fadeIn:Play()
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")

	local fadeIn = frame.fadeIn
	if fadeIn:IsPlaying() then
		fadeIn:Stop()
	end
	frame.fadeOut:Play()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(22)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetAutoWidth(false)
		self:SetText()
	end,

	-- ["OnRelease"] = nil,

	["SetText"] = function(self, text)
		self.text:SetText(text)
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetAutoWidth"] = function(self, autoWidth)
		self.autoWidth = autoWidth
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.frame:SetBackdropColor(0.2, 0.2, 0.2)
		else
			self.frame:Enable()
			self.frame:SetBackdropColor(0.725, 0.008, 0.008)
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceGUI30Button-OmniCD" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent, "UIPanelButtonTemplate, BackdropTemplate")
	frame:Hide()

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)

	local text = frame:GetFontString()
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 15, -1)
	text:SetPoint("BOTTOMRIGHT", -15, 1)
	text:SetJustifyV("MIDDLE")

	frame.Left:Hide()
	frame.Right:Hide()
	frame.Middle:Hide()
	frame:SetHighlightTexture(nil)
	OmniCD[1].BackdropTemplate(frame)
	frame:SetBackdropColor(0.725, 0.008, 0.008)
	frame:SetBackdropBorderColor(0, 0, 0)
	frame:SetNormalFontObject("GameFontHighlight-OmniCD")
	frame:SetHighlightFontObject("GameFontHighlight-OmniCD")
	frame:SetDisabledFontObject("GameFontDisable-OmniCD")
	frame.bg = frame:CreateTexture(nil, "BORDER")
	OmniCD[1].DisablePixelSnap(frame.bg)
	frame.bg:SetPoint("TOPLEFT", frame.TopEdge, "BOTTOMLEFT")
	frame.bg:SetPoint("BOTTOMRIGHT", frame.BottomEdge, "TOPRIGHT")
	frame.bg:SetColorTexture(0.0, 0.6, 0.4)
	frame.bg:Hide()

	frame.fadeIn = frame.bg:CreateAnimationGroup()
	frame.fadeIn:SetScript("OnPlay", function() frame.bg:Show() end)
	local fadeIn = frame.fadeIn:CreateAnimation("Alpha")
	fadeIn:SetFromAlpha(0)
	fadeIn:SetToAlpha(1)
	fadeIn:SetDuration(0.4)
	fadeIn:SetSmoothing("OUT")

	frame.fadeOut = frame.bg:CreateAnimationGroup()
	frame.fadeOut:SetScript("OnFinished", function() frame.bg:Hide() end)
	local fadeOut = frame.fadeOut:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(1)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(0.3)
	fadeOut:SetSmoothing("OUT")

	local widget = {
		text  = text,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
