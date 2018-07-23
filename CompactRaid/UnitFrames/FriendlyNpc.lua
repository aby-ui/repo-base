------------------------------------------------------------
-- FriendlyNpc.lua
--
-- Abin
-- 2013-11-05
------------------------------------------------------------

local max = max
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local _, addon = ...

local frame = addon:CreateGroupParent("CompactRaidFriendlyNpcFrame", "SecureHandlerStateTemplate")
addon.friendlyNpcFrame = frame
frame:Hide()

function frame:UpdateContainer()
	addon:UpdateContainerSize()
end

CompactRaidGroupHeaderPet:SetSize(1, 36) -- Ensures NPC buttons always have a valid anchor even if the user did not enable the option "showRaidPets"

local anchors = {
	solo = CompactRaidSoloFramePlayer,
	party = CompactRaidPartyFramePet,
	raid = CompactRaidGroupHeaderPet,
}

local k, v
for k, v in pairs(anchors) do
	frame:SetFrameRef("anchor"..k, v)
end

frame.buttons = {}

local i
for i = 1, 5 do
	local button = CreateFrame("Button", frame:GetName().."Button"..i, frame, "AbinCompactRaidUnitButtonTemplate")
	button:Hide(i)
	button:SetAttribute("unit", "boss"..i)

	tinsert(frame.buttons, button)

	if i == 1 then
		button:SetPoint("TOPLEFT")
	end
end

frame:SetAttribute("_onstate-groupstate", [[
	local horiz = self:GetAttribute("horiz")
	local spacing = self:GetAttribute("spacing") or 0
	local showPartyPets = self:GetAttribute("showPartyPets")
	local showRaidPets = self:GetAttribute("showRaidPets")
	local anchor = self:GetFrameRef("anchor"..newstate)

	if anchor then
		self:ClearAllPoints()
		if newstate == "raid" and not showRaidPets then
			self:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
		elseif newstate == "party" and not showPartyPets then
			self:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
		elseif horiz then
			self:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -spacing)
		else
			self:SetPoint("TOPLEFT", anchor, "TOPRIGHT", spacing, 0)
		end

		self:CallMethod("UpdateContainer")
	end
]])

RegisterStateDriver(frame, "groupstate", "[group:raid] raid; [group:party] party; solo")

-- Frame matrix functions need to be redesigned
local Orig_GetSoloFramesMatrix = addon.GetSoloFramesMatrix
local Orig_GetPartyFramesMatrix = addon.GetPartyFramesMatrix
local Orig_GetRaidFramesMatrix = addon.GetRaidFramesMatrix

local function GetFriendlyNpcFramesMatrix()
	if not frame:IsShown() then
		return
	end

	local count
	local i
	for i = 1, 5 do
		if frame.buttons[i]:IsShown() then
			count = i
		end
	end

	if not count then
		return
	end

	if addon.db.grouphoriz then
		return count, 1
	else
		return 1, count
	end
end

local function AppendFriendlyNpcMatrix(cols, rows, hasPet, group, show)
	local c1, r1 = GetFriendlyNpcFramesMatrix()
	if not c1 then
		return cols, rows, hasPet
	end

	local reserve = 1
	if group == addon.group and not show then
		reserve = 0
	end

	if addon.db.grouphoriz then
		if hasPet then
			return max(cols, c1), rows + 1, hasPet
		else
			return max(cols, c1), rows + 1 + reserve, hasPet
		end
	else
		if hasPet then
			return cols + 1, max(rows, r1), hasPet
		else
			return cols + 1 + reserve, max(rows, r1), hasPet
		end
	end
end

function addon:GetSoloFramesMatrix()
	local cols, rows, hasPet = Orig_GetSoloFramesMatrix(self)
	local c1, r1 = GetFriendlyNpcFramesMatrix()
	if not c1 then
		return cols, rows, hasPet
	end

	if addon.db.grouphoriz then
		return max(cols, c1), rows + 1, hasPet
	else
		return cols + 1, max(rows, r1), hasPet
	end
end

function addon:GetPartyFramesMatrix()
	local cols, rows, hasPet = Orig_GetPartyFramesMatrix(self)
	return AppendFriendlyNpcMatrix(cols, rows, hasPet, "party", addon.chardb.showPartyPets)
end

function addon:GetRaidFramesMatrix()
	local cols, rows, hasPet = Orig_GetRaidFramesMatrix(self)
	return AppendFriendlyNpcMatrix(cols, rows, hasPet, "raid", addon.chardb.showRaidPets)
end

local function UpdateLayout()
	local horiz, spacing = addon:GetLayoutData()
	local group = addon.group
	local anchor = anchors[group] or anchors.solo

	frame:ClearAllPoints()
	if group == "raid" and not addon.chardb.showRaidPets then
		frame:SetPoint("TOPLEFT", anchor, "TOPLEFT")
	elseif group == "party" and not addon.chardb.showPartyPets then
		frame:SetPoint("TOPLEFT", anchor, "TOPLEFT")
	elseif horiz then
		frame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -spacing)
	else
		frame:SetPoint("TOPLEFT", anchor, "TOPRIGHT", spacing, 0)
	end

	frame:SetAttribute("horiz", horiz)
	frame:SetAttribute("spacing", spacing)

	local i
	for i = 2, 5 do
		local button = frame.buttons[i]
		button:ClearAllPoints()
		if horiz then
			button:SetPoint("LEFT", frame.buttons[i - 1], "RIGHT", spacing, 0)
		else
			button:SetPoint("TOP", frame.buttons[i - 1], "BOTTOM", 0, -spacing)
		end
	end
end

addon:RegisterOptionCallback("grouphoriz", UpdateLayout)
addon:RegisterOptionCallback("spacing", UpdateLayout)

addon:RegisterOptionCallback("showFriendlyNpc", function(value)
	local i
	for i = 1, 5 do
		local button = frame.buttons[i]
		if value then
			RegisterStateDriver(button, "visibility", "[@boss"..i..", help] show; hide")
		else
			UnregisterStateDriver(button, "visibility")
			button:Hide()
		end
	end

	if value then
		frame:Show()
	else
		frame:Hide()
	end

	addon:UpdateContainerSize()
end)

addon:RegisterOptionCallback("showRaidPets", function(value)
	frame:SetAttribute("showRaidPets", value)
	if addon.group == "raid" then
		UpdateLayout()
	end
end)

addon:RegisterOptionCallback("showPartyPets", function(value)
	frame:SetAttribute("showPartyPets", value)
	if addon.group == "party" then
		UpdateLayout()
	end
end)
