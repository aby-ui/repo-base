---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

---------------------------------------------------------------------------------

-- Widgets backdrop

--[[-----------------------------------------------------------------------------
InlineGroup Container
Simple container widget that creates a visible "box" with an optional title.
-------------------------------------------------------------------------------]]
local Type, Version = "InlineGroup-OmniCD", 22
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetWidth(300)
		self:SetHeight(100)
		self:SetTitle("")
	end,

	-- ["OnRelease"] = nil,

	["SetTitle"] = function(self,title)
		self.titletext:SetText(title)
	end,


	["LayoutFinished"] = function(self, width, height)
		if self.noAutoHeight then return end
		--[[ s r (use height to determine if the group is empty or has all content hidden)
		self:SetHeight((height or 0) + 40)
		]]
		if not height or height < 20 then
			self.frame:Hide()
			self:SetHeight(0)
		else
			self:SetHeight(height + 40)
			self.frame:Show()
		end
		-- e
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local contentwidth = width - 20
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - 20
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
--[[ s -r
local PaneBackdrop  = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}
]]

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")

	local titletext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal-OmniCD")
	--[[ s r
	titletext:SetPoint("TOPLEFT", 14, 0)
	titletext:SetPoint("TOPRIGHT", -14, 0)
	]]
	titletext:SetPoint("TOPLEFT", 10, 0)
	titletext:SetPoint("TOPRIGHT", -10, 0)
	-- e
	titletext:SetJustifyH("LEFT")
	titletext:SetHeight(18)

	local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	border:SetPoint("TOPLEFT", 0, -17)
	border:SetPoint("BOTTOMRIGHT", -1, 3)
	--[[ s r
	border:SetBackdrop(PaneBackdrop)
	border:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
	border:SetBackdropBorderColor(0.4, 0.4, 0.4)
	]]
	OmniCD[1].BackdropTemplate(border)
	border:SetBackdropColor(0, 0, 0, 0.25) -- BDR (group bg) re-darken
	border:SetBackdropBorderColor(0, 0, 0)

	--Container Support
	local content = CreateFrame("Frame", nil, border)
	content:SetPoint("TOPLEFT", 10, -10)
	content:SetPoint("BOTTOMRIGHT", -10, 10)

	local widget = {
		frame     = frame,
		content   = content,
		titletext = titletext,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
