--[[
Copyright (c) 2009-2016, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "Coords"
local Coords = Mapster:NewModule(MODNAME)

local GetCursorPosition = GetCursorPosition
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local WorldMapScrollChild = WorldMapFrame.ScrollContainer.Child
local display, cursortext, playertext
local texttemplate, text = "%%s: %%.%df, %%.%df"

local MouseXY, OnUpdate

local db
local defaults = { 
	profile = {
		accuracy = 1,
		fontSize = 11,
	}
}

local optGetter, optSetter
do
	local mod = Coords
	function optGetter(info)
		local key = info[#info]
		return Coords.db.profile[key]
	end

	function optSetter(info, value)
		local key = info[#info]
		Coords.db.profile[key] = value
		mod:Refresh()
	end
end

local options
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["Coordinates"],
			arg = MODNAME,
			get = optGetter,
			set = optSetter,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["The Coordinates module adds a display of your current location, and the coordinates of your mouse cursor to the World Map frame."],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable Coordinates"],
					get = function() return Mapster:GetModuleEnabled(MODNAME) end,
					set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
				},
				accuracydesc = {
					order = 3,
					type = "description",
					name = "\n" .. L["You can control the accuracy of the coordinates, e.g. if you need very exact coordinates you can set this to 2."],
				},
				accuracy = {
					order = 4,
					type = "range",
					name = L["Accuracy"],
					min = 0, max = 2, step = 1,
				},
				fontSize = {
					order = 5,
					type = "range",
					name = L["Font Size"],
					desc = L["Font Size on the normal map."],
					min = 6, max = 18, step = 1,
				},
			},
		}
	end

	return options
end

function Coords:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["Coordinates"])
end

function Coords:OnEnable()
	if not display then
		display = CreateFrame("Frame", "Mapster_CoordsFrame", WorldMapFrame.ScrollContainer)

		cursortext = display:CreateFontString(nil, "OVERLAY")
		playertext = display:CreateFontString(nil, "OVERLAY")

		self:UpdateMapSize()

		cursortext:SetTextColor(1, 1, 1)
		playertext:SetTextColor(1, 1, 1)

		cursortext:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer, "BOTTOM", 30, -5)
		playertext:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "BOTTOM", -30, -5)

		tinsert(Mapster.elementsToHide, display)
	end

	display:SetScript("OnUpdate", OnUpdate)
	display:Show()

	self:Refresh()
end

function Coords:OnDisable()
	display:SetScript("OnUpdate", nil)
	display:Hide()
end

function Coords:Refresh()
	db = self.db.profile
	if not self:IsEnabled() then return end

	local acc = tonumber(db.accuracy) or 1
	text = texttemplate:format(acc, acc)
	self:UpdateMapSize()
end

function Coords:UpdateMapSize()
	if not cursortext or not playertext then return end
	cursortext:SetFont(GameFontNormal:GetFont(), db.fontSize, "OUTLINE")
	playertext:SetFont(GameFontNormal:GetFont(), db.fontSize, "OUTLINE")
end

function MouseXY()
	local left, top = WorldMapScrollChild:GetLeft(), WorldMapScrollChild:GetTop()
	local width, height = WorldMapScrollChild:GetWidth(), WorldMapScrollChild:GetHeight()
	local scale = WorldMapScrollChild:GetEffectiveScale()

	local x, y = GetCursorPosition()
	local cx = (x/scale - left) / width
	local cy = (top - y/scale) / height

	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		return
	end

	return cx, cy
end

local cursor, player = L["Cursor"], L["Player"]
local HBD = LibStub("HereBeDragons-2.0")
function OnUpdate()
	local cx, cy = MouseXY()
	local px, py
    if WorldMapFrame:GetMapID() == C_Map.GetBestMapForUnit("player") then
        px, py = HBD:GetPlayerZonePosition()
    end
    --[[
	local xy = GetPlayerMapPosition(WorldMapFrame:GetMapID(), "player")
	if xy then
		px, py = xy:GetXY()
	end
	]]

	if cx then
		cursortext:SetFormattedText(text, cursor, 100 * cx, 100 * cy)
	else
		cursortext:SetText("")
	end

	if not px or px == 0 then
		playertext:SetText("")
	else
		playertext:SetFormattedText(text, player, 100 * px, 100 * py)
	end
end
