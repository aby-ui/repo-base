local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Rake = Postal:NewModule("Rake", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Rake.description = L["Prints the amount of money collected during a mail session."]

local money
local flag = false

function Postal_Rake:OnEnable()
	self:RegisterEvent("MAIL_SHOW")
end

-- Disabling modules unregisters all events/hook automatically
--function Postal_Rake:OnDisable()
--end

function Postal_Rake:MAIL_SHOW()
	if not flag then
		money = GetMoney()
		self:RegisterEvent("MAIL_CLOSED")
		flag = true
	end
end

function Postal_Rake:MAIL_CLOSED()
	flag = false
	self:UnregisterEvent("MAIL_CLOSED")
	money = GetMoney() - money
	if money > 0 then
		Postal:Print(L["Collected"].." "..Postal:GetMoneyString(money))
	end
end
