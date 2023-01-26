local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Rake = Postal:NewModule("Rake", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Rake.description = L["Prints the amount of money collected during a mail session."]

local money
local flag = false

function Postal_Rake:OnEnable()
	if Postal.WOWClassic or Postal.WOWBCClassic then
		self:RegisterEvent("MAIL_SHOW")
	else
		Postal_Rake:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
	end
end

-- Disabling modules unregisters all events/hook automatically
--function Postal_Rake:OnDisable()
--end

-- WoW 10.0 Release Show/Hide Frame Handlers
function Postal_Rake:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(eventName, ...)
	local paneType = ...
	if paneType ==  Enum.PlayerInteractionType.MailInfo then Postal_Rake:MAIL_SHOW() end
end

function Postal_Rake:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(eventName, ...)
	local paneType = ...
	if paneType ==  Enum.PlayerInteractionType.MailInfo then Postal_Rake:MAIL_CLOSED() end
end

function Postal_Rake:MAIL_SHOW()
	if not flag then
		money = GetMoney()
		if Postal.WOWClassic or Postal.WOWBCClassic then
			self:RegisterEvent("MAIL_CLOSED")
		else
			Postal_Rake:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
		end
		flag = true
	end
end

function Postal_Rake:MAIL_CLOSED()
	flag = false
	if Postal.WOWClassic or Postal.WOWBCClassic then
		self:UnregisterEvent("MAIL_CLOSED")
	else
		self:UnregisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
	end
	money = GetMoney() - money
	if money > 0 then
		Postal:Print(L["Collected"].." "..Postal:GetMoneyString(money))
	end
end
