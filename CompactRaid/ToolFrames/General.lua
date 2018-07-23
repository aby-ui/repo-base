------------------------------------------------------------
-- General.lua
--
-- Abin
-- 2012/1/14
------------------------------------------------------------

local ConvertToParty = ConvertToParty
local ConvertToRaid = ConvertToRaid
local SetEveryoneIsAssistant = SetEveryoneIsAssistant
local IsEveryoneAssistant = IsEveryoneAssistant
local RegisterStateDriver = RegisterStateDriver

local _, addon = ...
local L = addon.L

local function IsAllowed(officer)
	if addon.group == "raid" then
		return addon.leadship == "leader" or (officer and addon.leadship == "officer")
	elseif addon.group == "party" then
		return addon.leadship == "leader"
	end
end

local frame = addon:CreateToolbox("CompactRaidToolboxGeneral", 1, 1, 0, GENERAL, L["tooltip text general"])
local menu = frame:CreateMenu(GENERAL)

-- Refresh
local button = menu:AddClickButton(L["refresh frames"])
button:SetFrameRef("container", addon:GetMainFrame())
button:SetAttribute("_onclick", [[
	self:GetParent():Hide()
	local container = self:GetFrameRef("container")
	container:Hide()
	container:Show()
]])

button = menu:AddClickButton(CONVERT_TO_RAID, "SecureHandlerStateTemplate")

button:SetScript("OnUpdate", function(self)
	self:Grayout(not IsAllowed())
end)

function button:UpdateGroup(value)
	if value == 2 then
		self.text:SetText(CONVERT_TO_PARTY)
		self.func = ConvertToParty
	else
		self.text:SetText(CONVERT_TO_RAID)
		self.func = ConvertToRaid
	end
end

function button:OnClick()
	if addon.leadship == "leader" then
		self.func()
	else
		addon:PrintPermissionError()
	end
end

button:SetAttribute("_onstate-groupstate", [[
	if newstate == 0 then
		self:Disable()
	else
		self:Enable()
	end
	self:CallMethod("UpdateGroup", newstate)
]])

RegisterStateDriver(button, "groupstate", "[group: raid] 2; [group: party] 1; 0")

button = menu:AddClickButton(ALL_ASSIST_LABEL_LONG, "SecureHandlerStateTemplate")

button:SetScript("OnUpdate", function(self)
	self:Grayout(not UnitIsGroupLeader("player"))
end)

function button:OnClick()
	if addon.leadship == "leader" then
		SetEveryoneIsAssistant(not IsEveryoneAssistant())
	else
		addon:PrintPermissionError(ALL_ASSIST_NOT_LEADER_ERROR)
	end
end

button:SetScript("OnShow", function(self)
	if IsEveryoneAssistant() then
		self.check:Show()
	else
		self.check:Hide()
	end
end)

button:SetAttribute("_onstate-inraid", [[
	if newstate == 1 then
		self:Enable()
	else
		self:Disable()
	end
]])

RegisterStateDriver(button, "inraid", "[group: raid] 1; 0")

local function GroupToolButton_OnClick(self)
	if self.grayed then
		addon:PrintPermissionError()
	else
		self.func()
	end
end

local function CreateGroupToolButton(text, func)
	local button = menu:AddClickButton(text, "SecureHandlerStateTemplate")
	button.func = func
	button.OnClick = GroupToolButton_OnClick

	button:SetAttribute("_onstate-ingroup", [[
		if newstate == 1 then
			self:Enable()
		else
			self:Disable()
		end
	]])

	RegisterStateDriver(button, "ingroup", "[group] 1; 0")

	button:SetScript("OnUpdate", function(self)
		self:Grayout(not IsAllowed(1))
	end)

	return button
end

CreateGroupToolButton(ROLE_POLL, InitiateRolePoll)
CreateGroupToolButton(READY_CHECK, DoReadyCheck)

local lockButton = menu:AddClickButton(L["lock position"])

function lockButton:OnClick()
	local lock = 1
	if addon.db.lock then
		lock = nil
	end

	addon.db.lock = lock
	addon:ApplyOption("lock", lock)
end

addon:RegisterOptionCallback("lock", function(value)
	if value then
		lockButton.check:Show()
	else
		lockButton.check:Hide()
	end
end)

button = menu:AddClickButton(SETTINGS.."...")
function button:OnClick()
	addon.optionFrame:Toggle()
end

menu:Finish()
