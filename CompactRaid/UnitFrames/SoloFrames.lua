------------------------------------------------------------
-- SoloFrames.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local _, addon = ...

local frame = addon:CreateGroupParent("CompactRaidSoloFrame")
addon.soloFrame = frame
RegisterStateDriver(frame, "visibility", "[group] hide; show")

local playerButton = CreateFrame("Button", frame:GetName().."Player", frame, "AbinCompactRaidUnitButtonTemplate")
playerButton:SetAttribute("unit", "player")
playerButton:SetPoint("TOPLEFT")
playerButton:Show()

local petButton = CreateFrame("Button", frame:GetName().."Pet", frame, "AbinCompactRaidUnitButtonTemplate")
petButton:SetAttribute("unit", "pet")
RegisterStateDriver(petButton, "visibility", "[nopet] hide; [vehicleui] hide; show")

function addon:GetSoloFramesMatrix()
	local hasPet = petButton:IsVisible()
	local count = hasPet and 2 or 1
	if addon.db.grouphoriz then
		return count, 1, hasPet
	else
		return 1, count, hasPet
	end
end

local function UpdateLayout()
	local horiz, spacing = addon:GetLayoutData()
	petButton:ClearAllPoints()
	if horiz then
		petButton:SetPoint("LEFT", playerButton, "RIGHT", spacing, 0)
	else
		petButton:SetPoint("TOP", playerButton, "BOTTOM", 0, -spacing)
	end
end

addon:RegisterOptionCallback("grouphoriz", UpdateLayout)
addon:RegisterOptionCallback("spacing", UpdateLayout)