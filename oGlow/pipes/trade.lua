local _E

local player = function(self, event, index)
	local slotFrame = _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = GetTradePlayerItemLink(index)

	self:CallFilters('trade', slotFrame, _E and slotLink)
end

local target = function(self, event, index)
	local slotFrame = _G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = GetTradeTargetItemLink(index)

	self:CallFilters('trade', slotFrame, _E and slotLink)
end

local update = function(self)
	for i=1, MAX_TRADE_ITEMS or 8 do
		player(self, nil, i)
		target(self, nil, i)
	end
end

local enable = function(self)
	_E = true

	self:RegisterEvent('TRADE_UPDATE', update)
	self:RegisterEvent('TRADE_SHOW', update)
	self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

local disable = function(self)
	_E = nil

	self:UnregisterEvent('TRADE_UPDATE', update)
	self:UnregisterEvent('TRADE_SHOW', update)
	self:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:UnregisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

oGlow:RegisterPipe('trade', enable, disable, update, 'Trade frame', nil)
