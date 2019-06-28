------------------------------------------------------------
-- WorldMarks.lua
--
-- Abin
-- 2012/1/14
------------------------------------------------------------

local IsRaidMarkerActive = IsRaidMarkerActive

local _, addon = ...
local L = addon.L

local function IsAllowed()
	if addon.group == "raid" then
		return addon.leadship == "leader" or addon.leadship == "officer"
	else
		return 1
	end
end

local frame = addon:CreateToolbox("CompactRaidToolboxWorldMarks", 0, 1, 0, L["world marks"], L["tooltip text world marks"])
RegisterStateDriver(frame, "visibility", "[group] show; hide")

local menu = frame:CreateMenu(L["world marks"])

local function Button_OnClick(self)
	if not IsAllowed() then
		addon:PrintPermissionError()
	end
end

local function Button_OnUpdate(self)
	if IsRaidMarkerActive(self:GetID()) then
		self.check:Show()
	else
		self.check:Hide()
	end
end

local NUM_BUTTONS = 8 + 1

local i
for i = 1, NUM_BUTTONS do
	local button = menu:AddButton(i == NUM_BUTTONS and REMOVE_WORLD_MARKERS or _G["WORLD_MARKER"..i], "SecureActionButtonTemplate")
	button:SetID(i)
	button:HookScript("OnClick", Button_OnClick)
	button:SetAttribute("type", "worldmarker")
	if i == NUM_BUTTONS then
		button:SetAttribute("action", "clear")
	else
		button:SetAttribute("marker", i)
		button:SetScript("OnUpdate", Button_OnUpdate)
	end

end

menu:Finish()
