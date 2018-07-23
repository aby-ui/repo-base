------------------------------------------------------------
-- TomTom.lua
--
-- Displays direction arrows on out-ranged group members.
-- Thanks TomTom for the beautiful model file "Arrow.blp".
--
-- Abin
-- 2013/11/11
------------------------------------------------------------

-- This feature is disabled by Blizzard since 70100, farewell
-- I just leave the code here in case it's re-enabled someday, you never know...
if 1 then return end

-- TomTom is NOT the only addon that has Arrow.blp included...
local TOMTOM_ARROW_ADDONS = {
	["DBM-Core"] = "\\textures\\arrows\\Arrow.blp",
	["TomTom"] = "\\Images\\Arrow.blp",
}

local arrowFilePath

do
	local name, path
	for name, path in pairs(TOMTOM_ARROW_ADDONS) do
		if not arrowFilePath and select(2, GetAddOnInfo(name)) then
			arrowFilePath = "Interface\\AddOns\\"..name..path
		end
	end
end

if not arrowFilePath then return end

local GetPlayerMapPosition = GetPlayerMapPosition
local atan = atan
local floor = floor
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitIsConnected = UnitIsConnected

local PI = math.pi -- 3.1415926535

local _, addon = ...

local frame = CreateFrame("Frame", "CompactRaidTomTomArrowFrame", UIParent)
frame:SetSize(70 / 2.5, 53 / 2.5)
frame:Hide()

local icon = frame:CreateTexture(frame:GetName().."Icon", "OVERLAY")
icon:SetAllPoints(frame)
icon:SetTexture(arrowFilePath) -- TomTom Arrows
icon:Hide()

------------------------------------------------------------
-- Calculate direction(0-359, in degrees) of the given unit
------------------------------------------------------------
--      0
--      |
-- 90---+---270
--      |
--     180
------------------------------------------------------------
local function CalcDirection(unit)
	if not unit then
		return
	end

	local unitX, unitY = GetPlayerMapPosition(unit)
	if unitX == 0 and unitY == 0 then
		return
	end

	local playerX, playerY = GetPlayerMapPosition("player")

	local angle
	if unitX == playerX then
		angle = unitY > playerY and 0 or 180
	elseif unitY == playerY then
		angle = unitX > playerX and 270 or 90
	else
		angle = atan(-(unitY - playerY) / (unitX - playerX))
		if unitX > playerX then
			angle = angle + 270
		else
			angle = angle + 90
		end
	end

	local facing = GetPlayerFacing() * 180 / PI
	local direction = (angle - facing) % 360
	if direction > 358 then
		direction = 0
	end

	return direction
end

------------------------------------------------------------
-- Calculate texcoord using which we display the arrow
------------------------------------------------------------
local function CalcTexCoord(direction)
	local cell = floor(direction / 360 * 108 + 0.5)
	local column = cell % 9
	local row = floor(cell / 9)
	return column * 56 / 512, (column + 1) * 56 / 512, row * 42 / 512, (row + 1) * 42 / 512
end

------------------------------------------------------------
-- Calculate rgb values of the arrow color, green for 0, red
-- for 180, gradients in-between
------------------------------------------------------------
local function CalcGradientColor(direction)
	local diff = direction
	if diff > 180 then
		diff = 180 - diff + 180
	end

	local perc = diff / 180

	local r, g = 1, 0
	if perc >= 0.5 then
		r, g = 1, (1.0 - perc) * 2
	else
		r, g = perc * 2, 1
	end

	return r, g, 0
end

------------------------------------------------------------
-- Paint the arrow if applicable
------------------------------------------------------------

local targetFrame

local function Frame_UpdateArrow(self)
	local direction
	if targetFrame and not targetFrame.inRange then
		direction = CalcDirection(targetFrame.displayedUnit)
	end

	if direction then
		icon:SetTexCoord(CalcTexCoord(direction))
		icon:SetVertexColor(CalcGradientColor(direction))
		icon:Show()
	else
		icon:Hide()
	end
end

local updateElapsed = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	updateElapsed = updateElapsed + elapsed
	if updateElapsed > 0.1 then
		updateElapsed = 0
		Frame_UpdateArrow(self)
	end
end)

------------------------------------------------------------
-- Find the currently targeted unit frame
------------------------------------------------------------

local function EnumUnitFrameProc(unitFrame)
	if not targetFrame and unitFrame:IsVisible() then
		if UnitIsUnit("target", unitFrame.displayedUnit or "") then
			targetFrame = unitFrame
		end
	end
end

local function Frame_CheckTarget(self)
	targetFrame = nil
	icon:Hide()

	-- Only check for qualified units: player & targeted & online & grouped
	if UnitIsPlayer("target") and not UnitIsUnit("player", "target") and UnitIsConnected("target") and (UnitInParty("target") or UnitInRaid("target")) then
		addon:EnumUnitFrames(EnumUnitFrameProc)
	end

	if targetFrame then
		frame:SetParent(targetFrame)
		frame:ClearAllPoints()
		frame:SetPoint("CENTER")
		frame:SetFrameLevel(100)
		Frame_UpdateArrow(frame)
		frame:Show()
	else
		frame:Hide()
	end
end

frame:SetScript("OnEvent", Frame_CheckTarget)

addon:RegisterOptionCallback("hideDirectionArrow", function(value)
	if value then
		frame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		frame:Hide()
	else
		frame:RegisterEvent("PLAYER_TARGET_CHANGED")
		Frame_CheckTarget(frame)
	end
end)
