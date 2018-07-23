local AddonName = ...
local Grid = Grid
local GridFrame = Grid:GetModule("GridFrame")
local GridIndicatorsDynamic = Grid:GetModule(AddonName)
local Media = LibStub("LibSharedMedia-3.0")

local BACKDROP = {
	edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 2,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
}

local function New(frame)
	local icon = CreateFrame("Button", nil, frame)
	icon:EnableMouse(false)
	icon:SetBackdrop(BACKDROP)
	
	local texture = icon:CreateTexture(nil, "ARTWORK")
	texture:SetPoint("BOTTOMLEFT", 2, 2)
	texture:SetPoint("TOPRIGHT", -2, -2)
	icon.texture = texture

	local text = icon:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetJustifyH("CENTER")
	text:SetJustifyV("CENTER")
	icon.text = text
	return icon
end

local function Reset(self)
	if not self.cooldown then
		local cd = CreateFrame("Cooldown", "GIDIconCooldownFrame"..self.__id, self, "CooldownFrameTemplate")
		cd:SetAllPoints(true)
		cd:SetReverse(true)
        cd:SetDrawBling(false)
        cd:SetDrawEdge(false)
        cd:SetSwipeColor(1, 1, 1, 0.6)
		self.cooldown = cd

		cd:SetScript("OnShow", function()
			self.text:SetParent(cd)
		end)
		cd:SetScript("OnHide", function()
			self.text:SetParent(self)
		end)
	end

	local profile = GridIndicatorsDynamic.db.profile[self.__id]
	if not profile then
		return
	end
	local font = Media:Fetch("font", profile.font) or STANDARD_TEXT_FONT
	local fontSize = profile.stackFontSize
	local iconSize = profile.iconSize
	local iconBorderSize = profile.iconBorderSize
	local totalSize = iconSize + (iconBorderSize * 2)
	local frame = self.__owner
	local r, g, b, a = self:GetBackdropBorderColor()

	self:SetFrameLevel(frame.indicators.bar:GetFrameLevel() + profile.frameLevel)
	self:SetWidth(totalSize)
	self:SetHeight(totalSize)

	self:ClearAllPoints()

	self:SetPoint(profile.anchor, profile.offsetX, -profile.offsetY)

	if iconBorderSize == 0 then
		self:SetBackdrop(nil)
	else
		BACKDROP.edgeSize = iconBorderSize
		BACKDROP.insets.left = iconBorderSize
		BACKDROP.insets.right = iconBorderSize
		BACKDROP.insets.top = iconBorderSize
		BACKDROP.insets.bottom = iconBorderSize
		
		self:SetBackdrop(BACKDROP)
		self:SetBackdropBorderColor(r, g, b, a)
	end

	self.texture:SetPoint("BOTTOMLEFT", iconBorderSize, iconBorderSize)
	self.texture:SetPoint("TOPRIGHT", -iconBorderSize, -iconBorderSize)

	self.text:SetPoint("CENTER", profile.stackOffsetX, profile.stackOffsetY)
	self.text:SetFont(font, fontSize, "OUTLINE")
end

local function SetStatus(self, color, text, value, maxValue, texture, texCoords, stack, start, duration)
	local profile = GridIndicatorsDynamic.db.profile[self.__id]
	if not texture then return end

	if type(texture) == "table" then
		self.texture:SetTexture(texture.r, texture.g, texture.b, texture.a or 1)
	else
		self.texture:SetTexture(texture)
		self.texture:SetTexCoord(texCoords.left, texCoords.right, texCoords.top, texCoords.bottom)
	end

	if type(color) == "table" then
		self:SetAlpha(color.a or 1)
		self:SetBackdropBorderColor(color.r, color.g, color.b, color.ignore and 0 or color.a or 1)
	else
		self:SetAlpha(1)
		self:SetBackdropBorderColor(0, 0, 0, 0)
    end

    if texCoords and texCoords.r then
        self.texture:SetVertexColor(texCoords.r, texCoords.g, texCoords.b, texCoords.a)
    else
        self.texture:SetVertexColor(1, 1, 1, 1)
    end

	if profile.enableIconCooldown and type(duration) == "number" and duration > 0 and type(start) == "number" and start > 0 then
		self.cooldown:SetCooldown(start, duration)
		self.cooldown:Show()
	else
		self.cooldown:Hide()
	end

	if profile.enableIconStackText and stack and stack ~= 0 then
		self.text:SetText(stack)
	else
		self.text:SetText("")
	end
	
	self:Show()
end

local function Clear(self)
	self:Hide()

	self.texture:SetTexture(1, 1, 1, 0)
	self.texture:SetTexCoord(0, 1, 0, 1)

	self.text:SetText("")
	self.text:SetTextColor(1, 1, 1, 1)

	self.cooldown:Hide()
end

function GridIndicatorsDynamic:Icon_RegisterIndicator(id, name)
	GridFrame:RegisterIndicator(id, name,
		New,
		Reset,
		SetStatus,
		Clear
	)
end
