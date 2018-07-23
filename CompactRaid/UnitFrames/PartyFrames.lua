------------------------------------------------------------
-- PartyFrames.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local RegisterStateDriver = RegisterStateDriver

local _, addon = ...

local playerButtons = {}
local petButtons = {}

local frame = addon:CreateGroupParent("CompactRaidPartyFrame")
addon.partyFrame = frame

RegisterStateDriver(frame, "visibility", "[group:raid] hide; [group:party] show; hide")

local petParent = CreateFrame("Frame", frame:GetName().."PetFrame", frame, "SecureFrameTemplate")

local i
for i = 0, 4 do
	local playerName = (i == 0 and "Player" or "Party"..i)
	local petName = (i == 0 and "Pet" or "PartyPet"..i)
	local playerUnit = strlower(playerName)
	local petUnit = strlower(petName)

	local playerButton = CreateFrame("Button", frame:GetName()..playerName, frame, "AbinCompactRaidUnitButtonTemplate")
	playerButton:SetAttribute("unit", playerUnit)

	local petButton = CreateFrame("Button", frame:GetName()..petName, petParent, "AbinCompactRaidUnitButtonTemplate")
	petButton:SetAttribute("unit", petUnit)

	tinsert(playerButtons, playerButton)
	tinsert(petButtons, petButton)

	if i == 0 then
		playerButton:SetPoint("TOPLEFT")
		playerButton:Show()
		RegisterStateDriver(petButton, "visibility", "[nopet] hide; [vehicleui] hide; show")
	else
		RegisterUnitWatch(playerButton)
		RegisterStateDriver(petButton, "visibility", "[@"..petUnit..",noexists] hide; [@"..playerUnit..",unithasvehicleui] hide; show")
	end
end

function addon:GetPartyFramesMatrix()
	local count = 0
	local hasPet

	local i
	for i = 1, 5 do
		if playerButtons[i]:IsVisible() then
			count = i
			if not hasPet and petButtons[i]:IsVisible() then
				hasPet = 1
			end
		else
			break
		end
	end

	if addon.db.grouphoriz then
		return count, hasPet and 2 or 1, hasPet
	else
		return hasPet and 2 or 1, count, hasPet
	end
end

local function UpdateLayout()
	local horiz, spacing = addon:GetLayoutData()
	local i
	for i = 1, 5 do
		local playerButton, petButton = playerButtons[i], petButtons[i]
		if i > 1 then
			playerButton:ClearAllPoints()
		end
		petButton:ClearAllPoints()

		if horiz then
			if i > 1 then
				playerButton:SetPoint("LEFT", playerButtons[i - 1], "RIGHT", spacing, 0)
			end
			petButton:SetPoint("TOP", playerButton, "BOTTOM", 0, -spacing)
		else
			if i > 1 then
				playerButton:SetPoint("TOP", playerButtons[i - 1], "BOTTOM", 0, -spacing)
			end
			petButton:SetPoint("LEFT", playerButton, "RIGHT", spacing, 0)
		end
	end
end

addon:RegisterOptionCallback("grouphoriz", UpdateLayout)
addon:RegisterOptionCallback("spacing", UpdateLayout)

addon:RegisterOptionCallback("showPartyPets", function(value)
	if value then
		petParent:Show()
	else
		petParent:Hide()
	end
end)