--[[
	events.lua
		Custom ace item events for better performance

	BAG_UPDATE_SIZE
	args: bag
		called when the size of a bag changes, bag itself probably also has changed

	BAG_UPDATE_CONTENT
	args: bag
		called when the items of a bag change
--]]

local ADDON, Addon = ...
local Events = Addon:NewModule('Events')


--[[ Events ]]--

function Events:OnEnable()
	self.firstVisit = true
	self.sizes, self.types, self.queue = {}, {}, {}

	if REAGENTBANK_CONTAINER then
		self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')
		self:RegisterEvent('REAGENTBANK_PURCHASED')
	end

	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('BAG_UPDATE_DELAYED')
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
	self:RegisterMessage('CACHE_BANK_OPENED')
	self:UpdateSize(BACKPACK_CONTAINER)
	self:UpdateBags()
end

function Events:BAG_UPDATE(event, bag)
	self.queue[bag] = true
end

function Events:BAG_UPDATE_DELAYED()
	self:UpdateBags()

	if self.queue[BACKPACK_CONTAINER] then
		self:UpdateContent(BACKPACK_CONTAINER)
	end
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

function Events:CACHE_BANK_OPENED()
	if self.firstVisit then
		self.firstVisit = nil
		self:UpdateSize(BANK_CONTAINER)
		self:UpdateBankBags()

		if REAGENTBANK_CONTAINER then
			self:UpdateSize(REAGENTBANK_CONTAINER)
		end
	end
end


--[[ API ]]--

function Events:UpdateBags()
	for bag = 1, NUM_BAG_SLOTS do
		if not self:UpdateSize(bag) then
			self:UpdateType(bag)
		end
	end

	for bag in pairs(self.queue) do
		self:UpdateContent(bag)
	end
end

function Events:UpdateBankBags()
	for bag = 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
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
		self.queue[bag] = nil
		self:SendSignal('BAG_UPDATE_SIZE', bag)
		return true
	end
end

function Events:UpdateType(bag)
	local old = self.types[bag]
	local _, new = GetContainerNumFreeSlots(bag)

	if old ~= new then
		self.types[bag] = new
		self:UpdateContent(bag)
		return true
	end
end

function Events:UpdateContent(bag)
	self.queue[bag] = nil
	self:SendSignal('BAG_UPDATE_CONTENT', bag)
end
