------------------------------------------------------------
-- Item.lua
--
-- Abin
-- 2012/1/26
------------------------------------------------------------

local GetItemInfo = GetItemInfo
local GetItemCount = GetItemCount
local GetItemCooldown = GetItemCooldown
local wipe = wipe
local select = select
local type = type
local tinsert = tinsert

local _, addon = ...
local L = addon.L
local templates = addon.templates

local function FindItem(itemList)
	local i
	for i = 1, #itemList do
		local data = itemList[i]
		local count = GetItemCount(data.id, false, data.asCharges)
		if count and count > 0 then
			return data, count
		end
	end
end

local function Button_OnBagUpdate(self)
	local data, count = FindItem(self.itemList)
	local r, g, b = addon:GetGradientColor(count, data and data.threshold)
	self.icon:SetText(count, r, g, b)

	if data then
		local start, duration, enable = GetItemCooldown(data.id)
		if start and start > 0 and duration > 0 and enable > 0 then
			self.icon.cooldown:SetCooldown(start, duration)
			self.icon.cooldown:Show()
			self.itemCooldownExpires = start + duration
		else
			self.icon.cooldown:Hide()
			self.itemCooldownExpires = 0
		end

		self.itemId = data.id
		self.itemCount = count
		local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(data.id)
		self.itemName, self.itemIcon = name, icon
	else
		self.itemId, self.itemName, self.itemIcon = nil
		self.itemCount = 0
		self.itemCooldownExpires = 0
	end

	self:UpdateTimer()
end

local function Button_SetItem(self, ...) -- itemID, threshold, asCharges, ...
	self.itemCount = 0
	self.itemCooldownExpires = 0
	wipe(self.itemList)

	local i
	for i = 1, select("#", ...), 3 do
		local id = select(i, ...)
		local threshold = select(i + 1, ...)
		local asCharges = select(i + 2, ...)

		if type(id) == "number" then
			if type(threshold) ~= "number" or threshold < 1 then
				threshold = 1
			end

			tinsert(self.itemList, { id = id, threshold = threshold, asCharges = asCharges })
		end
	end

	Button_OnBagUpdate(self)
end

templates.RegisterTemplate("ITEM", function(button)
	button.icon:UnregisterAllEvents()
	button.icon:SetScript("OnEvent", nil)
	button.icon2:UnregisterAllEvents()
	button.icon2:SetScript("OnEvent", nil)
	button.itemCount = 0
	button.itemCooldownExpires = 0
	button.itemList = {}
	button.SetItem = Button_SetItem
	button:HookMethod("OnBagUpdate", Button_OnBagUpdate)
end)