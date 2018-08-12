--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
----------------------------------------------------------------------]]

local _, Grid = ...
local GridFrame = Grid:GetModule("GridFrame")
local Media = LibStub("LibSharedMedia-3.0")
local L = Grid.L

local strsub = string.utf8sub or string.sub

local function New(frame)
	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	return text
end

local function Reset(self)
	local profile = GridFrame.db.profile
	local font = Media:Fetch("font", profile.font) or STANDARD_TEXT_FONT

	local frame = self.__owner
	local bar = frame.indicators.bar

	self:SetParent(bar)
	self:SetFont(font, profile.fontSize, profile.fontOutline)

	if profile.fontShadow then
		self:SetShadowOffset(1, -1)
	else
		self:SetShadowOffset(0, 0)
	end

	if profile.invertBarColor and profile.invertTextColor then
		self:SetShadowColor(1, 1, 1)
	else
		self:SetShadowColor(0, 0, 0)
	end

	self:ClearAllPoints()
	if self.__id == "text" then
		if profile.textorientation == "HORIZONTAL" then
			self:SetJustifyH("LEFT")
			self:SetJustifyV("CENTER")
			self:SetPoint("TOPLEFT", 2, -2)
			self:SetPoint("BOTTOMLEFT", 2, 2)
			if profile.enableText2 then
				self:SetPoint("RIGHT", bar, "CENTER")
			else
				self:SetPoint("RIGHT", bar, -2, 0)
			end
		else
			self:SetJustifyH("CENTER")
			self:SetJustifyV("CENTER")
			self:SetPoint("TOPLEFT", 2, -2)
			self:SetPoint("TOPRIGHT", -2, -2)
			if profile.enableText2 then
				self:SetPoint("BOTTOM", bar, "CENTER")
			else
				self:SetPoint("BOTTOM", bar, 0, 2)
			end
		end
	elseif self.__id == "text2" then
		if not profile.enableText2 then
			return self:Hide()
		end
		self:Show()
		if profile.textorientation == "HORIZONTAL" then
			self:SetJustifyH("RIGHT")
			self:SetJustifyV("CENTER")
			self:SetPoint("TOPRIGHT", -2, -2)
			self:SetPoint("BOTTOMRIGHT", -2, 2)
			self:SetPoint("LEFT", bar, "CENTER")
		else
			self:SetJustifyH("CENTER")
			self:SetJustifyV("CENTER")
			self:SetPoint("BOTTOMLEFT", 2, -2)
			self:SetPoint("BOTTOMRIGHT", -2, -2)
			self:SetPoint("TOP", bar, "CENTER", 0, 2)
		end
	end
end

local function SetStatus(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
	local profile = GridFrame.db.profile
	if self.__id == "text2" and not profile.enableText2 then
		return
	elseif not text or text == "" then
		return self:SetText("")
	end

    local c = strbyte(text, 1)
   	if(c and c >= 224 and string.utf8sub) then
        self:SetText(string.utf8sub(text, 1, math.floor(GridFrame.db.profile.textlength / 2)));
   	else
	self:SetText(strsub(text, 1, profile.textlength))
   	end

	if color then
		if profile.invertBarColor and profile.invertTextColor then
			self:SetTextColor(color.r * 0.2, color.g * 0.2, color.b * 0.2, color.a or 1)
		else
			self:SetTextColor(color.r, color.g, color.b, color.a or 1)
		end
	end
end

local function Clear(self)
	self:SetText("")
end

GridFrame:RegisterIndicator("text",  L["Center Text"],   New, Reset, SetStatus, Clear)
GridFrame:RegisterIndicator("text2", L["Center Text 2"], New, Reset, SetStatus, Clear)
