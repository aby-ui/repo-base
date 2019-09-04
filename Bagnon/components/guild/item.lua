--[[
	item.lua
		A guild item slot button
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local ItemSlot = Addon:NewClass('GuildItemSlot', 'Button', Addon.ItemSlot)
ItemSlot.nextID = 0
ItemSlot.unused = {}


--[[ Constructor ]]--

function ItemSlot:Create()
	local item = Addon.ItemSlot.Create(self)
	item:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	item:SetScript('OnDragStart', self.OnDragStart)
	item:SetScript('OnClick', self.OnClick)
	item:RegisterForDrag('LeftButton')
	item:RegisterForClicks('anyUp')
	item.SplitStack = nil -- template onload screws up this
	return item
end

function ItemSlot:GetBlizzard()
end


--[[ Events ]]--

function ItemSlot:OnClick(button)
	if HandleModifiedItemClick(self.info.link) or self:IsCached() then
		return
	end

	if IsModifiedClick('SPLITSTACK') then
		if not CursorHasItem() and not self.info.locked and self.info.count > 1 then
			StackSplitFrame:OpenStackSplitFrame(self.info.count, self, 'BOTTOMLEFT', 'TOPLEFT')
		end
		return
	end

	local type, money = GetCursorInfo()
	if type == 'money' then
		DepositGuildBankMoney(money)
		ClearCursor()
	elseif type == 'guildbankmoney' then
		DropCursorMoney()
		ClearCursor()
	elseif button == 'RightButton' then
		AutoStoreGuildBankItem(self:GetSlot())
	else
		PickupGuildBankItem(self:GetSlot())
	end
end

function ItemSlot:OnDragStart(button)
	if not self:IsCached() then
		PickupGuildBankItem(self:GetSlot())
	end
end

function ItemSlot:OnReceiveDrag(button)
	if not self:IsCached() then
		PickupGuildBankItem(self:GetSlot())
	end
end

function ItemSlot:OnEnter()
	if self.info.id then
 		self:AnchorTooltip()
		self:UpdateTooltip()
	end
end


--[[ Updaters ]]--

function ItemSlot:UpdateTooltip()
	if self:IsCached() then
		local dummySlot = self:GetDummySlot()
		dummySlot:SetParent(self)
		dummySlot:SetAllPoints(self)
		dummySlot:Show()
	else
		local pet = {GameTooltip:SetGuildBankItem(self:GetSlot())}
		if pet[1] and pet[1] > 0 then
			BattlePetToolTip_Show(unpack(pet))
		end

		GameTooltip:Show()
	end
end

function ItemSlot:SplitStack(split)
	local tab, slot = self:GetSlot()
	SplitGuildBankItem(tab, slot, split)
end

function ItemSlot:UpdateCooldown() end


--[[ Accessors ]]--

function ItemSlot:GetSlot()
	return self:GetBag(), self:GetID()
end

function ItemSlot:GetBag()
	return GetCurrentGuildBankTab()
end

function ItemSlot:IsQuestItem() end
function ItemSlot:IsNew() end
function ItemSlot:IsPaid() end
