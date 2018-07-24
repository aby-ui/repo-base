--[[
	item.lua
		A void storage item slot button
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local ItemSlot = Addon:NewClass('VaultSlot', 'Button', Addon.ItemSlot)
ItemSlot.nextID = 0
ItemSlot.unused = {}


--[[ Constructor ]]--

function ItemSlot:Create()
	local item = Addon.ItemSlot.Create(self)
	item:SetScript('OnReceiveDrag', self.OnDragStart)
	item:SetScript('OnDragStart', self.OnDragStart)
	item:SetScript('OnClick', self.OnClick)

	return item
end

function ItemSlot:Construct(id)
	return CreateFrame('Button', ADDON..'VaultItemSlot' .. id, nil, 'ContainerFrameItemButtonTemplate')
end

function ItemSlot:GetBlizzard()
end


--[[ Interaction ]]--

function ItemSlot:OnClick(button)
	if IsModifiedClick() then
		if self.info.link then
			HandleModifiedItemClick(self.info.link)
		end
	elseif self.bag == 'vault' and not self:IsCached() then
		local isRight = button == 'RightButton'
		local type, _, link = GetCursorInfo()
		local cursor = self.Cursor

		if not isRight and cursor and type == 'item' and link == cursor:GetItem() then
			cursor:GetScript('PreClick')(cursor, 'RightButton') -- simulates a click on the button, less code to maintain
			cursor:GetScript('OnClick')(cursor, 'RightButton')

		elseif isRight and self.info.locked then
			for i = 1,9 do
				if GetVoidTransferWithdrawalInfo(i) == self.info.id then
						ClickVoidTransferWithdrawalSlot(i, true)
				end
			end
		else
			ClickVoidStorageSlot(1, self:GetID(), isRight)
		end
	end
end

function ItemSlot:OnDragStart()
	self:OnClick('LeftButton')
end


--[[ Tooltip ]]--

function ItemSlot:ShowTooltip()
	self:AnchorTooltip()

	if self.bag == 'vault' then
		GameTooltip:SetVoidItem(1, self:GetID())
	elseif self.bag == DEPOSIT then
		GameTooltip:SetVoidDepositItem(self:GetID())
	else
		GameTooltip:SetVoidWithdrawalItem(self:GetID())
	end

	GameTooltip:Show()
	CursorUpdate(self)

	if IsModifiedClick('DRESSUP') then
		ShowInspectCursor()
	end
end


--[[ Proprieties ]]--

function ItemSlot:IsCached()
	-- delicious hack: behave as cached (disable interaction) while vault has not been purchased
	return not CanUseVoidStorage() or Addon.ItemSlot.IsCached(self)
end

function ItemSlot:IsQuestItem() end
function ItemSlot:IsNew() end
function ItemSlot:IsUpgrade() end
function ItemSlot:UpdateSlotColor() end
function ItemSlot:UpdateCooldown() end
