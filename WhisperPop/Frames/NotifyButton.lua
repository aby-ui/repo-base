------------------------------------------------------------
-- NotifyButton.lua
--
-- Abin
-- 2015-9-06
------------------------------------------------------------

local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT
local GameTooltip = GameTooltip

local addon = WhisperPop
local L = addon.L

local button = addon.templates.CreateIconButton("WhisperPopNotifyButton", UIParent, addon.ICON_FILE, 20, true)
addon.notifyButton = button

addon.frame:HookScript("OnShow", function()
	button:SetChecked(true)
end)

addon.frame:HookScript("OnHide", function()
	button:SetChecked(false)
end)

--button:SetPoint("CENTER", 0, 160)
button:SetPoint('BOTTOM', QuickJoinToastButton, 'TOP', 0, 2)
button:SetMovable(true)
button:SetUserPlaced(true)
button:SetDontSavePosition(false)
button:SetClampedToScreen(true)
button.icon:SetDesaturated(true)

button.text = button:CreateFontString(button:GetName().."Text", "ARTWORK", "GameFontGreenSmall")
button.text:SetPoint("LEFT", button, "RIGHT", 2, 0)
button.text:SetFont(STANDARD_TEXT_FONT, 13)

button:RegisterForDrag("LeftButton")
button:SetScript("OnDragStart", button.StartMoving)
button:SetScript("OnDragStop", button.StopMovingOrSizing)

button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

button:SetScript("OnClick", function(self)
	GameTooltip:Hide()
	addon:ToggleFrame()
end)

button:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine(L["title"])
	addon:AddTooltipText(GameTooltip)
	GameTooltip:Show()
end)

button:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

local function Button_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.5 then
		self.elapsed = 0
		if self.icon:IsShown() then
			self.icon:Hide()
		else
			self.icon:Show()
		end
	end
end

addon:RegisterEventCallback("OnListUpdate", function()
	local name = addon:GetNewMessage()
	if name == button.name then
		return
	end

	button.name = name
	button.elapsed = 0
	button.icon:Show()
	if name then
		button.icon:SetDesaturated(false)
		button.text:SetText(name)
		button:SetScript("OnUpdate", Button_OnUpdate)
	else
		button.icon:SetDesaturated(true)
		button.text:SetText()
		button:SetScript("OnUpdate", nil)
	end
end)

FriendsMicroButton = FriendsMicroButton or QuickJoinToastButton --fix 7.1
addon:RegisterEventCallback("OnResetFrames", function()
	button:ClearAllPoints()
	--button:SetPoint("CENTER", 0, 160)
    button:SetPoint('TOP', QuickJoinToastButton, 'BOTTOM', 0, -2)
end)

addon:RegisterOptionCallback("notifyButton", function(value)
	if value then
		button:Show()
	else
		button:Hide()
	end
end)

addon:RegisterOptionCallback("buttonScale", function(value)
	button:SetScale(value / 100)
end)