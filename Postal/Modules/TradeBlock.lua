local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_TradeBlock = Postal:NewModule("TradeBlock", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_TradeBlock.description = L["Block incoming trade requests while in a mail session."]

function Postal_TradeBlock:OnEnable()
	self:RegisterEvent("MAIL_SHOW")
end

function Postal_TradeBlock:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
	SetCVar("BlockTrades", 0)
	ClosePetition()
	PetitionFrame:RegisterEvent("PETITION_SHOW")
end

function Postal_TradeBlock:MAIL_SHOW()
	PetitionFrame:UnregisterEvent("PETITION_SHOW")
	if IsAddOnLoaded("Lexan") then return end
	if GetCVar("BlockTrades") == "0" then
		self:RegisterEvent("MAIL_CLOSED", "Reset")
		self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
		SetCVar("BlockTrades", 1)
	end
end

function Postal_TradeBlock:Reset()
	self:UnregisterEvent("MAIL_CLOSED")
	self:UnregisterEvent("PLAYER_LEAVING_WORLD")
	SetCVar("BlockTrades", 0)
	ClosePetition()
	PetitionFrame:RegisterEvent("PETITION_SHOW")
end
