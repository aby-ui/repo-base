local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Wire = Postal:NewModule("Wire", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Wire.description = L["Set subject field to value of coins sent if subject is blank."]

local g, s, c
g = "^%["..GOLD_AMOUNT.." "..SILVER_AMOUNT.." "..COPPER_AMOUNT.."%]$"
s = "^%["..SILVER_AMOUNT.." "..COPPER_AMOUNT.."%]$"
c = "^%["..COPPER_AMOUNT.."%]$"
if GetLocale() == "ruRU" then
	--Because ruRU has these escaped strings which can't be in mail subjects.
	--COPPER_AMOUNT = "%d |4медная монета:медные монеты:медных монет;"; -- Lowest value coin denomination
	--SILVER_AMOUNT = "%d |4серебряная:серебряные:серебряных;"; -- Mid value coin denomination
	--GOLD_AMOUNT = "%d |4золотая:золотые:золотых;"; -- Highest value coin denomination
	g = "^%[%d+з %d+с %d+м%]$"
	s = "^%[%d+с %d+м%]$"
	c = "^%[%d+м%]$"
end
g = gsub(g, "%%d", "%%d+")
s = gsub(s, "%%d", "%%d+")
c = gsub(c, "%%d", "%%d+")

function Postal_Wire:OnEnable()
	-- Secure hook so that it calls the original function
	self:SecureHook(SendMailMoney, "onValueChangedFunc")
end

-- Disabling modules unregisters all events/hook automatically
--function Postal_Wire:OnDisable()
--end

function Postal_Wire:onValueChangedFunc()
	local subject = SendMailSubjectEditBox:GetText()
	if subject == "" or subject:find(g) or subject:find(s) or subject:find(c) then
		local money = MoneyInputFrame_GetCopper(SendMailMoney)
		if money and money > 0 then
			local gold = floor(money / 10000)
			local silver = floor((money - gold * 10000) / 100)
			local copper = mod(money, 100)
			if GetLocale() == "ruRU" then
				if gold > 0 then
					SendMailSubjectEditBox:SetText(format("[%d+з %d+с %d+м]", gold, silver, copper))
				elseif silver > 0 then
					SendMailSubjectEditBox:SetText(format("[%d+с %d+м]", silver, copper))
				else
					SendMailSubjectEditBox:SetText(format("[%d+м]", copper))
				end
			else
				if gold > 0 then
					SendMailSubjectEditBox:SetText(format("["..GOLD_AMOUNT.." "..SILVER_AMOUNT.." "..COPPER_AMOUNT.."]", gold, silver, copper))
				elseif silver > 0 then
					SendMailSubjectEditBox:SetText(format("["..SILVER_AMOUNT.." "..COPPER_AMOUNT.."]", silver, copper))
				else
					SendMailSubjectEditBox:SetText(format("["..COPPER_AMOUNT.."]", copper))
				end
			end
		else
			SendMailSubjectEditBox:SetText("")
		end
	end
end
