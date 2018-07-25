--[[
	events.lua
		Custom item events for better performance

	BAG_UPDATE_SIZE
	args: bag
		called when the size of a bag changes, bag itself probably also has changed

	BAG_UPDATE_CONTENT
	args: bag
		called when the items of a bag change

	BANK_OPENED
	args: none
		called when the bank has opened and all of other events have been fired

--]]

local _, Addon = ...
local Events = Addon:NewClass('Events')


--[[ Events ]]--

function Events:PLAYER_LOGIN()
	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
	self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')
	self:RegisterEvent('REAGENTBANK_PURCHASED')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:UpdateSize(BACKPACK_CONTAINER)
	self:UpdateBags()
end

function Events:BAG_UPDATE(event, bag)
	self:UpdateBags()
	self:UpdateContent(bag)
end

function Events:PLAYERBANKSLOTS_CHANGED()
	self:UpdateBankBags()
	self:UpdateContent(BANK_CONTAINER)
end

function Events:PLAYERREAGENTBANKSLOTS_CHANGED()
	self:UpdateContent(REAGENTBANK_CONTAINER)
end

function Events:REAGENTBANK_PURCHASED()
	self:UpdateContent(REAGENTBANK_CONTAINER)
end

function Events:BANKFRAME_OPENED()
	if self.firstVisit then
		self.firstVisit = nil
		self:UpdateSize(BANK_CONTAINER)
		self:UpdateSize(REAGENTBANK_CONTAINER)
		self:UpdateBankBags()
	end

	self:SendMessage('BANK_OPENED')
end


--[[ API ]]--

function Events:UpdateBags()
	for bag = 1, NUM_BAG_SLOTS do
		if not self:UpdateSize(bag) then
			self:UpdateType(bag)
		end
	end
end

function Events:UpdateBankBags()
	for bag = 1, NUM_BAG_SLOTS + GetNumBankSlots() do
		if not self:UpdateSize(bag) then
			self:UpdateType(bag)
		end
	end
end

function Events:UpdateSize(bag)
	local old = self.sizes[bag]
	local new = GetContainerNumSlots(bag) or 0

	if old ~= new then
		local _, kind = GetContainerNumFreeSlots(bag)
		self.types[bag] = kind
		self.sizes[bag] = new

		self:SendMessage('BAG_UPDATE_SIZE', bag)
		return true
	end
end

function Events:UpdateType(bag)
	local old = self.types[bag]
	local _, new = GetContainerNumFreeSlots(bag)

	if old ~= new then
		self.types[bag] = new
		self:SendMessage('BAG_UPDATE_CONTENT', bag)
	end
end

function Events:UpdateContent(bag)
	self:SendMessage('BAG_UPDATE_CONTENT', bag)
end


--[[ Startup ]]--

Events.firstVisit = true
Events.sizes, Events.types = {}, {}
Events:RegisterEvent('PLAYER_LOGIN')
