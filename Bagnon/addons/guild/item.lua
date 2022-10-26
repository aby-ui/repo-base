--[[
	item.lua
		A guild item slot button
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Item = Addon.Item:NewClass('GuildItem')


--[[ Construct ]]--

function Item:Construct()
	local b = self:Super(Item):Construct()
	b:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	b:SetScript('OnDragStart', self.OnDragStart)
	b:SetScript('OnClick', self.OnClick)
	b:SetScript('PreClick', nil)
	b:RegisterForDrag('LeftButton')
	b:RegisterForClicks('anyUp')
	return b
end

function Item:GetBlizzard() end


--[[ Events ]]--

function Item:OnClick(button)
	if HandleModifiedItemClick(self.info.link) or self:FlashFind(button) then
		return
	elseif IsModifiedClick('SPLITSTACK') then
		if not CursorHasItem() and not self.info.locked and self.info.count > 1 then
			if OpenStackSplitFrame then
				OpenStackSplitFrame(self.info.count, self, 'BOTTOMLEFT', 'TOPLEFT')
			else
				StackSplitFrame:OpenStackSplitFrame(self.info.count, self, 'BOTTOMLEFT', 'TOPLEFT')
			end
		end
	else
		local type, amount = GetCursorInfo()
		if type == 'money' then
			DepositGuildBankMoney(amount)
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
end

function Item:OnDragStart(button)
	if not self:IsCached() then
		PickupGuildBankItem(self:GetSlot())
	end
end

function Item:OnReceiveDrag(button)
	if not self:IsCached() then
		PickupGuildBankItem(self:GetSlot())
	end
end


--[[ Update ]]--

function Item:UpdateTooltip()
	if not self.info.cached then
		GameTooltip:SetOwner(self:GetTipAnchor())

		local pet = {GameTooltip:SetGuildBankItem(self:GetSlot())}
		if pet[1] and pet[1] > 0 then
			BattlePetToolTip_Show(unpack(pet))
		end

		GameTooltip:Show()
		CursorUpdate(self)
	end
end

function Item:SplitStack(split)
	local tab, slot = self:GetSlot()
	SplitGuildBankItem(tab, slot, split)
end

function Item:UpdateFocus() end
function Item:UpdateCooldown() end


--[[ Accessors ]]--

function Item:GetSlot()
	return self:GetBag(), self:GetID()
end

function Item:GetBag()
	return GetCurrentGuildBankTab()
end

function Item:IsQuestItem() end
function Item:IsNew() end
function Item:IsPaid() end
