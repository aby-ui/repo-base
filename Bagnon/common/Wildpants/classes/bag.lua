--[[
	bag.lua
		A bag button object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bag = Addon.Tipped:NewClass('Bag', 'CheckButton')

Bag.SIZE = 32
Bag.TEXTURE_SIZE = 64 * (Bag.SIZE/36)
Bag.GetSlot = Bag.GetID


--[[ Construct ]]--

function Bag:New(parent, id)
	local bag = self:Super(Bag):New(parent)
	local icon = bag:CreateTexture(nil, 'BORDER')
	icon:SetAllPoints(bag)

	local count = bag:CreateFontString(nil, 'OVERLAY')
	count:SetFontObject('NumberFontNormal')
	count:SetPoint('BOTTOMRIGHT', -4, 3)
	count:SetJustifyH('RIGHT')

	local filter = CreateFrame('Frame', nil, bag)
	filter:SetPoint('TOPRIGHT', 4, 4)
	filter:SetSize(20, 20)

	local filterIcon = filter:CreateTexture()
	filterIcon:SetAllPoints()

	local nt = bag:CreateTexture()
	nt:SetTexture([[Interface\Buttons\UI-Quickslot2]])
	nt:SetWidth(self.TEXTURE_SIZE)
	nt:SetHeight(self.TEXTURE_SIZE)
	nt:SetPoint('CENTER', 0, -1)

	local pt = bag:CreateTexture()
	pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	pt:SetAllPoints()

	local ht = bag:CreateTexture()
	ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	ht:SetAllPoints()

	local ct = bag:CreateTexture()
	ct:SetTexture([[Interface\Buttons\CheckButtonHilight]])
	ct:SetBlendMode('ADD')
	ct:SetAllPoints()

	bag:SetID(id)
	bag:SetNormalTexture(nt)
	bag:SetPushedTexture(pt)
	bag:SetCheckedTexture(ct)
	bag:SetHighlightTexture(ht)
	bag:RegisterForClicks('anyUp')
	bag:RegisterForDrag('LeftButton')
	bag:SetSize(self.SIZE, self.SIZE)
	bag.Count, bag.FilterIcon = count, filter
	bag.FilterIcon.Icon = filterIcon
	bag.Icon = icon

	bag:SetScript('OnEnter', bag.OnEnter)
	bag:SetScript('OnLeave', bag.OnLeave)
	bag:SetScript('OnClick', bag.OnClick)
	bag:SetScript('OnDragStart', bag.OnDrag)
	bag:SetScript('OnReceiveDrag', bag.OnClick)
	bag:SetScript('OnShow', bag.RegisterEvents)
	bag:SetScript('OnHide', bag.UnregisterAll)
	bag:RegisterEvents()
	return bag
end


--[[ Interaction ]]--

function Bag:OnClick(button)
	if button == 'RightButton' and ContainerFrame1FilterDropDown then
		if not self:IsReagents() and self:GetInfo().owned then
			ContainerFrame1FilterDropDown:SetParent(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			ToggleDropDownMenu(1, nil, ContainerFrame1FilterDropDown, self, 0, 0)
		end
	elseif self:IsPurchasable() then
		self:Purchase()
	elseif CursorHasItem() and not self:GetInfo().cached then
		if self:IsBackpack() then
			PutItemInBackpack()
		else
			PutItemInBag(self:GetInfo().slot)
		end
	elseif self:CanToggle() then
		self:Toggle()
	end

	self:UpdateToggle()
end

function Bag:OnDrag()
	if self:IsCustomSlot() and not self:GetInfo().cached then
		PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		PickupBagFromSlot(self:GetInfo().slot)
	end
end

function Bag:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	self:UpdateTooltip()
	self:SetFocus(true)
end

function Bag:OnLeave()
	self:Super(Bag):OnLeave()
	self:SetFocus(false)
end


--[[ Events ]]--

function Bag:RegisterEvents()
	self:Update()
	self:UnregisterAll()
	self:RegisterFrameSignal('OWNER_CHANGED', 'RegisterEvents')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'UpdateToggle')
	self:RegisterEvent('BAG_CLOSED', 'BAG_UPDATE')
	self:RegisterEvent('BAG_UPDATE')

	if self:IsBank() or self:IsBankBag() or self:IsReagents() then
		self:RegisterMessage('CACHE_BANK_OPENED', 'RegisterEvents')
		self:RegisterMessage('CACHE_BANK_CLOSED', 'RegisterEvents')
	end

	if not self:GetInfo().cached then
		if self:IsReagents() then
			self:RegisterEvent('REAGENTBANK_PURCHASED', 'Update')
		elseif self:IsCustomSlot() then
			if self:IsBankBag() then
				self:RegisterEvent('PLAYERBANKBAGSLOTS_CHANGED', 'Update')
			end

			self:RegisterEvent(Addon.IsClassic and 'CURSOR_UPDATE' or 'CURSOR_CHANGED', 'UpdateCursor')
			self:RegisterEvent('ITEM_LOCK_CHANGED', 'UpdateLock')
		end
	elseif self:IsCustomSlot() then
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'Update')
	end
end

function Bag:BAG_UPDATE(_, bag)
	if bag == self:GetSlot() then
		self:Update()
	end
end


--[[ Update ]]--

function Bag:Update()
	local info = self:GetInfo()

	self.FilterIcon:SetShown(not info.cached)
	self.Count:SetText(info.free and info.free > 0 and info.free)

  if self:IsBackpack() or self:IsBank() then
		self:SetIcon('Interface/Buttons/Button-Backpack-Up')
	elseif self:IsReagents() then
		self:SetIcon('Interface/Icons/Achievement_GuildPerk_BountifulBags')
	elseif self:IsKeyring() then
		self:SetIcon('Interface/ContainerFrame/KeyRing-Bag-Icon')
	else
		self:SetIcon(info.icon or 'Interface/PaperDoll/UI-PaperDoll-Slot-Bag')
	  self.link = info.link

		if not info.icon then
			self.Count:SetText()
		end
	end

	for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
		local id = self:GetSlot()
		local active = id > NUM_BAG_SLOTS and GetBankBagSlotFlag(id - NUM_BAG_SLOTS, i) or GetBagSlotFlag(id, i)

		if active then
			self.FilterIcon.Icon:SetAtlas(BAG_FILTER_ICONS[i])
		end
	end

	self:UpdateLock()
	self:UpdateCursor()
	self:UpdateToggle()
end

function Bag:UpdateLock()
	if self:IsCustomSlot() then
    	SetItemButtonDesaturated(self, self:GetInfo().locked)
 	end
end

function Bag:UpdateCursor()
	if not self:IsCustomSlot() then
		if CursorCanGoInSlot(self:GetInfo().slot) then
			self:LockHighlight()
		else
			self:UnlockHighlight()
		end
	end
end

function Bag:UpdateToggle()
	self:SetChecked(self:IsToggled())
end

function Bag:UpdateTooltip()
	GameTooltip:ClearLines()

	-- title/item
	if self:IsPurchasable() then
		GameTooltip:SetText(self:IsReagents() and REAGENT_BANK or BANK_BAG_PURCHASE, 1, 1, 1)
		GameTooltip:AddLine(L.TipPurchaseBag:format(L.Click))

		SetTooltipMoney(GameTooltip, self:GetInfo().cost)
	elseif self:IsBackpack() then
		GameTooltip:SetText(BACKPACK_TOOLTIP, 1,1,1)
	elseif self:IsBank() then
		GameTooltip:SetText(BANK, 1,1,1)
	elseif self:IsReagents() then
		GameTooltip:SetText(REAGENT_BANK, 1,1,1)
	elseif self:IsKeyring() then
		GameTooltip:SetText(KEYRING, 1,1,1)
	elseif self.link and self:GetInfo().cached then
		GameTooltip:SetHyperlink(self.link)
	elseif self.link then
		GameTooltip:SetInventoryItem('player', ContainerIDToInventoryID(self:GetID()))
	elseif self:IsBankBag() then
		GameTooltip:SetText(BANK_BAG, 1, 1, 1)
	else
		GameTooltip:SetText(EQUIP_CONTAINER, 1, 1, 1)
	end

	-- instructions
	if self:CanToggle() then
		GameTooltip:AddLine((self:IsToggled() and L.TipHideBag or L.TipShowBag):format(L.Click))
	end

	GameTooltip:Show()
end


--[[ Actions ]]--

function Bag:Purchase()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)

	if self:IsReagents() then
		LibStub('Sushi-3.1').Popup('CONFIRM_BUY_REAGENTBANK_TAB')
	else
		LibStub('Sushi-3.1').Popup {
			text = CONFIRM_BUY_BANK_SLOT, button1 = YES, button2 = NO,
			hasMoneyFrame = 1, hideOnEscape = 1, timeout = 0,
			OnAccept = PurchaseSlot,
			OnShow = function(popup)
				MoneyFrame_Update(popup.moneyFrame, GetBankSlotCost(GetNumBankSlots()))
			end,
		}
	end
end

function Bag:Toggle()
	local profile = self:GetProfile()
	local hidden = profile.hiddenBags
	local slot = profile.exclusiveReagent and not hidden[REAGENTBANK_CONTAINER] and REAGENTBANK_CONTAINER or self:GetSlot()
	hidden[slot] = not hidden[slot]

	self:SendFrameSignal('FILTERS_CHANGED')
	self:SetFocus(true)
end

function Bag:SetFocus(focus)
	local state = focus and self:GetSlot()
	self:GetFrame().focusedBag = state
	self:SendFrameSignal('FOCUS_BAG', state)
end

function Bag:SetIcon(icon)
	local color = self:GetInfo().owned and 1 or .1
	SetItemButtonTexture(self, icon)
	SetItemButtonTextureVertexColor(self, 1, color, color)
end


--[[ Bag Type ]]--

function Bag:IsBackpack()
	return Addon:IsBackpack(self:GetSlot())
end

function Bag:IsBackpackBag()
  return Addon:IsBackpackBag(self:GetSlot())
end

function Bag:IsBank()
	return Addon:IsBank(self:GetSlot())
end

function Bag:IsReagents()
	return Addon:IsReagents(self:GetSlot())
end

function Bag:IsKeyring()
	return Addon:IsKeyring(self:GetSlot())
end

function Bag:IsBankBag()
	return Addon:IsBankBag(self:GetSlot())
end

function Bag:IsCustomSlot()
	return self:IsBackpackBag() or self:IsBankBag()
end

function Bag:CanToggle()
	return self:IsBackpack() or self:IsBank() or self:GetInfo().owned
end


--[[ Info ]]--

function Bag:IsPurchasable()
	local info = self:GetInfo()
	return not info.cached and not info.owned
end

function Bag:IsToggled()
	return self:GetFrame():IsShowingBag(self:GetSlot()) and self:GetInfo().owned
end

function Bag:GetInfo()
	return self:GetFrame():GetBagInfo(self:GetSlot())
end
