local AddonName = ...
local Grid = Grid
local GridFrame = Grid:GetModule("GridFrame")
local GridIndicatorsDynamic = Grid:GetModule(AddonName)
local Media = LibStub("LibSharedMedia-3.0")

local BACKDROP = {
	bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = true, tileSize = 8,
	edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1},
}

local function New(frame)
	local square = CreateFrame("Frame", nil, frame)
	square:SetBackdrop(BACKDROP)
	square:SetBackdropBorderColor(0, 0, 0, 1)
	return square
end

local function Reset(self)
	local profile = GridIndicatorsDynamic.db.profile[self.__id]
	if not profile then
		return
	end
	self:SetWidth(profile.size)
	self:SetHeight(profile.size)
	local bar = self.__owner.indicators.bar
	self:SetParent(bar)
	self:SetFrameLevel(bar:GetFrameLevel() + profile.frameLevel)
	self:ClearAllPoints()
	self:SetPoint(profile.anchor, profile.offsetX, profile.offsetY)
	self:Hide()
end

local function SetStatus(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
	if not color then return end
	self:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
	self:Show()
end

local function Clear(self)
	self:SetBackdropColor(1, 1, 1, 1)
	self:Hide()
end


function GridIndicatorsDynamic:Box_RegisterIndicator(id, name)
	GridFrame:RegisterIndicator(id, name,
		New,
		Reset,
		SetStatus,
		Clear
	)
end
