
------------------------------
-- Combo Point Widget
------------------------------

--[[

	- Proc Widget

--]]
local comboWidgetPath = "Interface\\Addons\\TidyPlatesWidgets\\ComboWidget\\"
local artpath = "Interface\\Addons\\TidyPlatesWidgets\\ComboWidget\\"
local artfile = artpath.."RogueLegion.tga"
local grid = .0625

local WidgetList = {}



-- Placeholder for function


local function GetComboPointTarget()
	if UnitCanAttack("player", "target") then
		local points = GetComboPoints("player", "target")
		local maxPoints = UnitPowerMax("player", 4)

		return points, maxPoints
	end
end

local function GetChiTarget()
	if UnitCanAttack("player", "target") then

		if SPEC_MONK_BREWMASTER == GetSpecialization() then return end

		local points = UnitPower("player", SPELL_POWER_CHI)
		local maxPoints = UnitPowerMax("player", SPELL_POWER_CHI)

		return points, maxPoints

	end
end



local GetResourceOnTarget
local LocalName, PlayerClass = UnitClass("player")

if PlayerClass == "MONK" then
	GetResourceOnTarget = GetChiTarget
elseif PlayerClass == "ROGUE" then
	GetResourceOnTarget = GetComboPointTarget
elseif PlayerClass == "DRUID" then
	GetResourceOnTarget = GetComboPointTarget
else
	GetResourceOnTarget = function() end
end



-- Update Graphics
local function UpdateWidgetFrame(frame)
	local points, maxPoints = GetResourceOnTarget()

	if points and points > 0 then
		-- At some point, custom art will be made for each class.  Hopefully!
		--UpdateWidgetArt(frame)
		--frame.Icon:SetTexture(comboWidgetPath..tostring(points))

		-- SetTexCoord:  First two values define the range of the Horizontal
		if maxPoints == 6 then
			frame.Icon:SetTexCoord(0, 1, grid*(points+9), grid *(points+10))
		else
			frame.Icon:SetTexCoord(0, 1, grid*(points-1), grid *(points))
		end

		frame:Show()

		return
	end

	frame:_Hide()
end

-- Context
local function UpdateWidgetContext(frame, plate, unit)
	local guid = unit.guid

	-- Add to Widget List
	if guid then
		if frame.guid then WidgetList[frame.guid] = nil end
		frame.guid = guid
		WidgetList[guid] = frame
	end

	-- Update Widget
	if UnitGUID("target") == guid then
		UpdateWidgetFrame(frame)
	else
		frame:_Hide()
	end
end

local function ClearWidgetContext(frame)
	local guid = frame.guid
	if guid then
		WidgetList[guid] = nil
		frame.guid = nil
	end
end

-- Watcher Frame
local WatcherFrame = CreateFrame("Frame", nil, WorldFrame )
local isEnabled = false

--[[
WatcherFrame:RegisterEvent("UNIT_COMBO_POINTS")
WatcherFrame:RegisterEvent("UNIT_POWER")
WatcherFrame:RegisterEvent("UNIT_DISPLAYPOWER")
WatcherFrame:RegisterEvent("UNIT_AURA")
WatcherFrame:RegisterEvent("UNIT_FLAGS")
--]]

-- 8.0

WatcherFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
WatcherFrame:RegisterEvent("RUNE_POWER_UPDATE")
--WatcherFrame:RegisterEvent("UNIT_POWER_FREQUENT")
WatcherFrame:RegisterEvent("UNIT_MAXPOWER")
WatcherFrame:RegisterEvent("UNIT_POWER_UPDATE")
WatcherFrame:RegisterEvent("UNIT_DISPLAYPOWER")
WatcherFrame:RegisterEvent("UNIT_AURA")
WatcherFrame:RegisterEvent("UNIT_FLAGS")



local function WatcherFrameHandler(frame, event, unitid)
		local guid = UnitGUID("target")
		if UnitExists("target") then
			local widget = WidgetList[guid]
			if widget then UpdateWidgetFrame(widget) end				-- To update all, use: for guid, widget in pairs(WidgetList) do UpdateWidgetFrame(widget) end
		end
end

local function EnableWatcherFrame(arg)
	if arg then
		WatcherFrame:SetScript("OnEvent", WatcherFrameHandler); isEnabled = true
	else WatcherFrame:SetScript("OnEvent", nil); isEnabled = false end
end

-- Widget Creation
local function CreateWidgetFrame(parent)
	-- Required Widget Code
	local frame = CreateFrame("Frame", nil, parent)
	frame:Hide()

	-- Custom Code
	frame:SetHeight(32)
	frame:SetWidth(64)

	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER", frame, "CENTER")
	frame.Icon:SetHeight(16)
	frame.Icon:SetWidth(64)

	frame.Icon:SetTexture(artfile)
	--frame.Icon:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -2, -2)
	--frame.Icon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)

	-- End Custom Code

	-- Required Widget Code
	frame.UpdateContext = UpdateWidgetContext
	frame.Update = UpdateWidgetFrame
	frame._Hide = frame.Hide
	frame.Hide = function() ClearWidgetContext(frame); frame:_Hide() end
	if not isEnabled then EnableWatcherFrame(true) end
	return frame
end

TidyPlatesWidgets.CreateComboPointWidget = CreateWidgetFrame
