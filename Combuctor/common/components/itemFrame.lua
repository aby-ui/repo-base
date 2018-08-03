--[[
	itemFrame.lua
		An item slot container template
--]]

local ADDON, Addon = ...
local ItemFrame = Addon:NewClass('ItemFrame', 'Frame')
ItemFrame.Button = Addon.ItemSlot


--[[ Constructor ]]--

function ItemFrame:New(parent, bags)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f.bags, f.buttons, self.bagSlots = bags, {}, {}
	f:SetScript('OnHide', f.UnregisterSignals)
	f:SetScript('OnShow', f.Update)
	f:SetSize(1,1)

	if f:IsVisible() then
		f:Update()
	end

	return f
end

function ItemFrame:Update()
	self:RequestLayout()
	self:RegisterEvents()
end


--[[ Events ]]--

function ItemFrame:RegisterEvents()
	self:UnregisterSignals()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'RequestLayout')
	self:RegisterSignal('UPDATE_ALL', 'RequestLayout')
	self:RegisterEvent('GET_ITEM_INFO_RECEIVED')

	if not self:IsCached() then
		self:RegisterSignal('BAG_UPDATE_SIZE')
		self:RegisterSignal('BAG_UPDATE_CONTENT')
		self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
		self:RegisterEvent('ITEM_LOCK_CHANGED')

		self:RegisterEvent('BAG_UPDATE_COOLDOWN', 'ForAll', 'UpdateCooldown')
		self:RegisterEvent('BAG_NEW_ITEMS_UPDATED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('EQUIPMENT_SETS_CHANGED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('QUEST_ACCEPTED', 'ForAll', 'UpdateBorder')

		self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
		self:RegisterEvent('UNIT_INVENTORY_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
	else
		self:RegisterMessage('CACHE_BANK_OPENED', 'RegisterEvents')
	end
end

function ItemFrame:BAG_UPDATE_SIZE(_,bag)
	if self.bags[bag] then
		self:RequestLayout()
	end
end

function ItemFrame:BAG_UPDATE_CONTENT(_,bag)
	self:ForBag(bag, 'Update')
end

function ItemFrame:ITEM_LOCK_CHANGED(_,bag, slot)
	if not self:PendingLayout() then
		bag = self.bagSlots[bag]
		slot = bag and bag[slot]

		if slot then
			slot:UpdateLocked()
		end
	end
end

function ItemFrame:GET_ITEM_INFO_RECEIVED(_,itemID)
	if not self:PendingLayout() then
		for i, button in ipairs(self.buttons) do
			if button.info.id == itemID then
				button:Update()
			end
		end
	end
end

function ItemFrame:UNIT_QUEST_LOG_CHANGED(_,unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end


--[[ Management ]]--

function ItemFrame:RequestLayout()
	self:SetScript('OnUpdate', self.Layout)
end

function ItemFrame:PendingLayout()
	return self:GetScript('OnUpdate')
end

function ItemFrame:Layout()
	self:SetScript('OnUpdate', nil)
	self:ForAll('Free')
	self.buttons, self.bagSlots = {}, {}

	-- Acquire slots
	for _,bag in ipairs(self.bags) do
		if self:IsShowingBag(bag) then
			local numSlots = self:NumSlots(bag)
			for slot = 1, numSlots do
				if self:IsShowingItem(bag, slot) then
					local button = self.Button:New(self, bag, slot)
					tinsert(self.buttons, button)

					self.bagSlots[bag] = self.bagSlots[bag] or {}
					self.bagSlots[bag][slot] = button
				end
			end
		end
	end

	-- Position slots
	local profile = self:GetProfile()
	local columns, scale = self:LayoutTraits()
	local size = self:GetButtonSize()

	local revBags, revSlots = profile.reverseBags, profile.reverseSlots
	local x, y = 0,0

	for k = revBags and #self.bags or 1, revBags and 1 or #self.bags, revBags and -1 or 1 do
		local bag = self.bags[k]
		local slots = self.bagSlots[bag]

		if slots then
			local numSlots = self:NumSlots(bag)
			for slot = revSlots and numSlots or 1, revSlots and 1 or numSlots, revSlots and -1 or 1 do
				local button = slots[slot]
				if button then
					if x == columns then
						y = y + 1
						x = 0
					end

					button:ClearAllPoints()
					button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (self.Transposed and y or x), -size * (self.Transposed and x or y))
					button:SetScale(scale)

					x = x + 1
				end
			end

			if self:BagBreak() and x > 0 then
				y = y + 1
				x = 0
			end
		end
	end

	-- Resize frame
	if x > 0 then
		y = y + 1
	end

	local width, height = max(columns * size * scale, 1), max(y * size * scale, 1)
	self:SetSize(self.Transposed and height or width, self.Transposed and width or height)
	self:SendFrameSignal('ITEM_FRAME_RESIZED')
end

function ItemFrame:ForAll(method, ...)
	if not self:PendingLayout() then
		for i, button in ipairs(self.buttons) do
			button[method](button, ...)
		end
	end
end

function ItemFrame:ForBag(bag, method, ...)
	if self:CanUpdate(bag) then
		for slot, button in pairs(self.bagSlots[bag]) do
			button[method](button, ...)
		end
	end
end

function ItemFrame:CanUpdate(bag)
	return not self:PendingLayout() and self.bagSlots[bag]
end


--[[ Proprieties ]]--

function ItemFrame:IsShowingItem(bag, slot)
	return self:GetFrame():IsShowingItem(bag, slot)
end

function ItemFrame:IsShowingBag(bag)
	return self:GetFrame():IsShowingBag(bag)
end

function ItemFrame:NumSlots(bag)
	return Addon:GetBagInfo(self:GetOwner(), bag).count or 0
end

function ItemFrame:NumButtons()
	return #self.buttons
end

function ItemFrame:GetButtonSize()
	return 37 + self:GetProfile().spacing
end

function ItemFrame:BagBreak()
	return self:GetProfile().bagBreak
end
