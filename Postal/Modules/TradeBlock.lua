local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_TradeBlock = Postal:NewModule("TradeBlock", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_TradeBlock.description = L["Block incoming trade requests while in a mail session."]

function Postal_TradeBlock:OnEnable()
	if Postal.WOWClassic or Postal.WOWBCClassic then
		self:RegisterEvent("MAIL_SHOW")
	else
		Postal_TradeBlock:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
	end
end

function Postal_TradeBlock:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
	SetCVar("BlockTrades", 0)
	ClosePetition()
	PetitionFrame:RegisterEvent("PETITION_SHOW")
end

-- WoW 10.0 Release Show/Hide Frame Handlers
function Postal_TradeBlock:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(eventName, ...)
	local paneType = ...
	if paneType ==  Enum.PlayerInteractionType.MailInfo then Postal_TradeBlock:MAIL_SHOW() end
end

function Postal_TradeBlock:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(eventName, ...)
	local paneType = ...
	if paneType ==  Enum.PlayerInteractionType.MailInfo then Postal_TradeBlock:MAIL_CLOSED() end
end

function Postal_TradeBlock:MAIL_SHOW()
	PetitionFrame:UnregisterEvent("PETITION_SHOW")
	if IsAddOnLoaded("Lexan") then return end
	if GetCVar("BlockTrades") == "0" then
		if Postal.WOWClassic or Postal.WOWBCClassic then
			self:RegisterEvent("MAIL_CLOSED", "Reset")
		else
			Postal_TradeBlock:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", "Reset")
		end
		self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
		SetCVar("BlockTrades", 1)
	end
end

function Postal_TradeBlock:Reset()
	if Postal.WOWClassic or Postal.WOWBCClassic then
		self:UnregisterEvent("MAIL_CLOSED")
	else
		self:UnregisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
	end
	self:UnregisterEvent("PLAYER_LEAVING_WORLD")
	SetCVar("BlockTrades", 0)
	ClosePetition()
	PetitionFrame:RegisterEvent("PETITION_SHOW")
end
