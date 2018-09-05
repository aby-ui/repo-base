------------------------------------------------------------
-- RaidTargets.lua
--
-- Abin
-- 2012/1/14
------------------------------------------------------------

local UnitExists = UnitExists
local GetRaidTargetIndex = GetRaidTargetIndex
local SetRaidTargetIcon = SetRaidTargetIcon
local UnitPopupButtons = UnitPopupButtons

local _, addon = ...
local L = addon.L

local frame = addon:CreateToolbox("CompactRaidToolboxRaidTargets", 0.5, 0.5, 1, BINDING_HEADER_RAID_TARGET, L["tooltip text raid targets"])
local menu = frame:CreateMenu(BINDING_HEADER_RAID_TARGET, 1)

local function IsAllowed()
	if addon.group == "raid" then
		return addon.leadship == "leader" or addon.leadship == "officer"
	else
		return 1
	end
end

local function Button_OnClick(self)
	if IsAllowed() then
		SetRaidTargetIcon(UnitExists("target") and "target" or "player", self:GetID())
	else
		addon:PrintPermissionError()
	end
end

local function Button_OnUpdate(self)
	local unit = UnitExists("target") and "target" or "player"
	local mark = unit and GetRaidTargetIndex(unit)
	if mark == self:GetID() then
		self.check:Show()
	else
		self.check:Hide()
	end
end

local i
for i = 1, 8 do
	local data = UnitPopupButtons["RAID_TARGET_"..i]

	local button = menu:AddClickButton(data.text)
	button:SetID(i)
	button.text:SetTextColor(data.color.r, data.color.g, data.color.b)
	button.OnClick = Button_OnClick
	button:SetScript("OnUpdate", Button_OnUpdate)

	local icon = button:CreateTexture(nil, "ARTWORK")
	icon:SetSize(16, 16)
	icon:SetPoint("RIGHT", -4, 0)
	icon:SetTexture(data.icon)
	icon:SetTexCoord(data.tCoordLeft, data.tCoordRight, data.tCoordTop, data.tCoordBottom)
end

local button = menu:AddClickButton(UnitPopupButtons["RAID_TARGET_NONE"].text)
button.OnClick = Button_OnClick

menu:Finish()
