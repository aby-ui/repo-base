
------------------------------
-- Combo Point Widget
------------------------------


-- CombatIcons.tga

local comboWidgetPath = "Interface\\Addons\\TidyPlatesWidgets\\ComboWidget\\"
local artpath = "Interface\\Addons\\TidyPlatesWidgets\\ComboWidget\\"
local artfile = artpath.."RogueLegion.tga"
local grid = .0625

local WidgetList = {}

local CombatWidgetFrame


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



local function ConfigDruid()
	-- Set Power Type
	-- Set Power function
	-- Set Power Max / Marker config

	-- update on energy max?
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
local function UpdateCombatWidget()

	if CombatWidgetFrame.nameplateUnitID and UnitIsUnit("target", CombatWidgetFrame.nameplateUnitID ) then

		local points, maxPoints = GetResourceOnTarget()


		if points and points > 0 then

			-- SetTexCoord:  First two values define the range of the Horizontal
			if maxPoints == 6 then
				CombatWidgetFrame.Icon:SetTexCoord(0, 1, grid*(points+9), grid *(points+10))
			else
				CombatWidgetFrame.Icon:SetTexCoord(0, 1, grid*(points-1), grid *(points))
			end

			CombatWidgetFrame:Show()

			return
		end

	end

	CombatWidgetFrame:Hide()
end



local function UpdateWidgetFrame(frame)
	-- Not needed, I hope
end



local function CreateCombatWidget(parent)

	--[[

	* Independent dots
	* 1-6
	* Each dot has 4 conditions:
		- Empty
		- Active
		- Super-charged
		- Expiring / Charging

	--]]


	-- Required Widget Code
	local frame = CreateFrame("Frame", nil, parent)
	frame:Hide()

	frame:SetPoint("CENTER", parent, "CENTER")
	frame:SetHeight(32)
	frame:SetWidth(64)

	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER", frame, "CENTER")
	frame.Icon:SetHeight(16)
	frame.Icon:SetWidth(64)

	frame.Icon:SetTexture(artfile)

	return frame
end



local function ClearWidgetContext(frame)
	--print("Clearing Context")
	CombatWidgetFrame:SetParent(WorldFrame)
	CombatWidgetFrame.nameplateUnitID = nil
	CombatWidgetFrame:Hide()
end



-- Context
local function UpdateWidgetContext(frame, unit)

	-- Reanchor & Update Widget
	if UnitIsUnit("target", unit.unitid) then
		--print("Anchoring to", unit.name, unit.unitid)

		--CombatWidgetFrame:SetParent(frame)
        CombatWidgetFrame:ClearAllPoints()
		CombatWidgetFrame:SetParent(WorldFrame)
		CombatWidgetFrame:ClearAllPoints() 
		CombatWidgetFrame:SetPoint("CENTER", frame, "CENTER")

		CombatWidgetFrame.nameplateUnitID = unit.unitid
		UpdateCombatWidget()
	end
end


-- Watcher Frame
local WatcherFrame = CreateFrame("Frame", nil, WorldFrame )
local isEnabled = false



local function EnableWatcherFrame(arg)
	if arg then
		CombatWidgetFrame = CreateCombatWidget(WorldFrame)
		CombatWidgetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		CombatWidgetFrame:RegisterEvent("RUNE_POWER_UPDATE")
		CombatWidgetFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		CombatWidgetFrame:RegisterEvent("UNIT_MAXPOWER")
		CombatWidgetFrame:RegisterEvent("UNIT_POWER_UPDATE")
		CombatWidgetFrame:RegisterEvent("UNIT_DISPLAYPOWER")
		CombatWidgetFrame:RegisterEvent("UNIT_AURA")
		CombatWidgetFrame:RegisterEvent("UNIT_FLAGS")


		CombatWidgetFrame:SetScript("OnEvent", UpdateCombatWidget)
		isEnabled = true
	else 
		CombatWidgetFrame:SetScript("OnEvent", nil)
		isEnabled = false 
	end
end




-----------------------
-- Widget Creation
-----------------------

local function CreateWidgetCarrier(parent)
	-- Required Widget Code
	local frame = CreateFrame("Frame", nil, parent)
	--frame:Hide()

	frame:SetHeight(32)
	frame:SetWidth(64)


	-- Required Widget Code
	frame.UpdateContext = UpdateWidgetContext
	frame.Update = UpdateWidgetFrame
	--frame._Hide = frame.Hide
	--frame.Hide = function() ClearWidgetContext(frame); frame:_Hide() end

	if not isEnabled then EnableWatcherFrame(true) end

	return frame
end




TidyPlatesWidgets.CreateComboPointWidget = CreateWidgetCarrier

