------------------------------
-- Combo Point Widget
------------------------------

-- constants
local artpath = "Interface\\Addons\\TidyPlatesWidgets\\ComboWidget\\"
local artfile = artpath.."RogueLegion.tga"
local grid = .0625

local powerTbl = {
    MONK = Enum.PowerType.Chi,
    ROGUE = Enum.PowerType.ComboPoints,
    DRUID = Enum.PowerType.ComboPoints,
    PALADIN = Enum.PowerType.HolyPower,
}
local powerID = powerTbl[select(2, UnitClass("player"))]



local function UpdatePowerWidget(self, event)
	if  powerID
        and self.nameplateUnitID
        and UnitIsUnit("target", self.nameplateUnitID)
        and UnitCanAttack("player", "target") then

		local points, maxPoints = UnitPower("player", powerID), UnitPowerMax("player", powerID)
		if points and points > 0 then
            local offset = maxPoints == 6 and 10 or 0
            self.Icon:SetTexCoord(0, 1, grid * (offset + points - 1), grid * (offset + points))
			self:Show()
			return
		end

	end

	self:Hide()
end

--* Context

--* MAJOR YIKES
--* unfortunately the Update function is on the anchor on each frame
--* but the widgetFrame should be unique
local widgetFrame
local blizzClassNameplate

local function UpdateWidgetContext(frame, unit)
	-- Reanchor & Update Widget
	if UnitIsUnit("target", unit.unitid) then
        local widget = widgetFrame
		widget:ClearAllPoints()
		widget:SetPoint("CENTER", frame, "CENTER")

		widget.nameplateUnitID = unit.unitid
		widget:Update()
	end
end

local function ClearWidgetContext(frame)
    local widget = frame.widget
	--print("Clearing Context")
	widget:SetParent(WorldFrame)
	widget.nameplateUnitID = nil
	widget:Hide()
end

-----------------------
-- Widget Creation
-----------------------
local isEnabled = false

function TidyPlatesWidgets.CreateComboPointWidget(parent)
    if false then
        --abyui
        local widgetAnchorFrame = CreateFrame("Frame", nil, parent)
        widgetAnchorFrame.UpdateContext = function() end
        widgetAnchorFrame.Update = function() end
        return widgetAnchorFrame
    end

	local widgetAnchorFrame = CreateFrame("Frame", nil, parent)
	widgetAnchorFrame:SetHeight(32)
	widgetAnchorFrame:SetWidth(64)

	-- Required Widget Code
	widgetAnchorFrame.UpdateContext = UpdateWidgetContext
	widgetAnchorFrame.Update = function() end
	--frame._Hide = frame.Hide
	--[[frame.Hide = function()
        ClearWidgetContext(frame)
        frame:_Hide()
    end]]

	if not isEnabled then
        blizzClassNameplate = NamePlateDriverFrame:GetClassNameplateBar()
        if blizzClassNameplate then
            blizzClassNameplate:HideNameplateBar()
            function blizzClassNameplate:ShowNameplateBar()
            end
        else
            function ClassNameplateBar:ShowNameplateBar()
            end
        end

        local widget = CreateFrame("Frame", nil, WorldFrame)
        widgetFrame = widget
        widget.Update = UpdatePowerWidget
        widget:Hide()

        widget:SetPoint("CENTER", WorldFrame, "CENTER")
        widget:SetHeight(32)
        widget:SetWidth(64)

        widget.Icon = widget:CreateTexture(nil, "OVERLAY")
        widget.Icon:SetPoint("CENTER", widget, "CENTER")
        widget.Icon:SetHeight(16)
        widget.Icon:SetWidth(64)
        widget.Icon:SetTexture(artfile)

        widget:RegisterEvent("PLAYER_TARGET_CHANGED")
        widget:RegisterEvent("RUNE_POWER_UPDATE")
        widget:RegisterEvent("UNIT_POWER_FREQUENT")
        widget:RegisterEvent("UNIT_MAXPOWER")
        widget:RegisterEvent("UNIT_POWER_UPDATE")
        widget:RegisterEvent("UNIT_DISPLAYPOWER")
        widget:RegisterEvent("UNIT_AURA")
        widget:RegisterEvent("UNIT_FLAGS")

        widget:SetScript("OnEvent", widget.Update)
        isEnabled = true
    end

	return widgetAnchorFrame
end