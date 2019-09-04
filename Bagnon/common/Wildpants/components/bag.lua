--[[
	bag.lua
		A bag button object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bag = Addon:NewClass('Bag', 'CheckButton')

Bag.SIZE = 32
Bag.TEXTURE_SIZE = 64 * (Bag.SIZE/36)
Bag.GetSlot = Bag.GetID


--[[ Constructor ]]--

function Bag:New(parent, id)
	local bag = self:Bind(CreateFrame('CheckButton', ADDON .. self.Name .. id, parent))
	local icon = bag:CreateTexture(bag:GetName() .. 'IconTexture', 'BORDER')
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
	bag:SetScript('OnHide', bag.UnregisterSignals)
	bag:RegisterEvents()

	return bag
end


--[[ Interaction ]]--

function Bag:OnClick(button)
	if button == 'RightButton' then
		if not self:IsReagents() and not self:IsPurchasable() then
			ContainerFrame1FilterDropDown:SetParent(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			ToggleDropDownMenu(1, nil, ContainerFrame1FilterDropDown, self, 0, 0)
		end
	elseif self:IsPurchasable() then
		self:Purchase()
	elseif CursorHasItem() and not self:IsCached() then
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
	if self:IsCustomSlot() and not self:IsCached() then
		PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		PickupBagFromSlot(self:GetInfo().slot)
	end
end

function Bag:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	self:UpdateTooltip()
	self:SetFocus(true)
end

function Bag:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end

	self:SetFocus(false)
end


--[[ Events ]]--

function Bag:RegisterEvents()
	self:Update()

	self:UnregisterSignals()
	self:RegisterFrameSignal('OWNER_CHANGED', 'RegisterEvents')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'UpdateToggle')
	self:RegisterEvent('BAG_CLOSED', 'BAG_UPDATE')
	self:RegisterEvent('BAG_UPDATE')

	if self:IsBank() or self:IsBankBag() or self:IsReagents() then
		self:RegisterMessage('CACHE_BANK_OPENED', 'RegisterEvents')
		self:RegisterMessage('CACHE_BANK_CLOSED', 'RegisterEvents')
	end

	if self:IsCustomSlot() then
		if self:IsCached() then
			self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'Update')
		else
			self:RegisterEvent('ITEM_LOCK_CHANGED', 'UpdateLock')
			self:RegisterEvent('CURSOR_UPDATE', 'UpdateCursor')
		end
	elseif self:IsReagents() then
		self:RegisterEvent('REAGENTBANK_PURCHASED', 'Update')
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
	self:SetChecked(not self:IsHidden())
end

function Bag:UpdateTooltip()
	GameTooltip:ClearLines()

	-- title
	if self:IsPurchasable() then
		GameTooltip:SetText(self:IsReagents() and REAGENT_BANK or BANK_BAG_PURCHASE, 1, 1, 1)
		GameTooltip:AddLine(L.TipPurchaseBag)
		SetTooltipMoney(GameTooltip, self:GetCost())
	elseif self:IsBackpack() then
		GameTooltip:SetText(BACKPACK_TOOLTIP, 1,1,1)
	elseif self:IsBank() then
		GameTooltip:SetText(BANK, 1,1,1)
	elseif self:IsReagents() then
		GameTooltip:SetText(REAGENT_BANK, 1,1,1)
	elseif self.link then
		GameTooltip:SetHyperlink(self.link)
	elseif self:IsBankBag() then
		GameTooltip:SetText(BANK_BAG, 1, 1, 1)
	else
		GameTooltip:SetText(EQUIP_CONTAINER, 1, 1, 1)
	end

	-- instructions
	if self:CanToggle() then
		GameTooltip:AddLine(self:IsHidden() and L.TipShowBag or L.TipHideBag)
	end

	GameTooltip:Show()
end


--[[ Actions ]]--

function Bag:Purchase()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)

	if self:IsReagents() then
		StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
	else
		if not StaticPopupDialogs['CONFIRM_BUY_BANK_SLOT_' .. ADDON] then
			StaticPopupDialogs['CONFIRM_BUY_BANK_SLOT_' .. ADDON] = {
				text = CONFIRM_BUY_BANK_SLOT,
				button1 = YES,
				button2 = NO,
				OnAccept = PurchaseSlot,
				OnShow = function(self)
					MoneyFrame_Update(self.moneyFrame, GetBankSlotCost(GetNumBankSlots()))
				end,
				hasMoneyFrame = 1,
				hideOnEscape = 1, timeout = 0,
				preferredIndex = STATICPOPUP_NUMDIALOGS
			}
		end

		StaticPopup_Show('CONFIRM_BUY_BANK_SLOT_' .. ADDON)
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
	local color = self:IsPurchasable() and .1 or 1
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

function Bag:IsBankBag()
	return Addon:IsBankBag(self:GetSlot())
end

function Bag:IsCustomSlot()
	return self:IsBackpackBag() or self:IsBankBag()
end

function Bag:CanToggle()
	return self:IsBackpack() or self:IsBank() or not self:IsPurchasable()
end


--[[ Info ]]--

function Bag:IsCached()
 	return self:GetInfo().cached
end

function Bag:GetCost()
	return self:IsReagents() and GetReagentBankCost() or GetBankSlotCost(GetNumBankSlots())
end

function Bag:IsPurchasable()
	if not self:IsCached() then
		return self:IsBankBag() and (self:GetSlot() - NUM_BAG_SLOTS) > GetNumBankSlots() or self:IsReagents() and not IsReagentBankUnlocked()
	end
end

function Bag:IsHidden()
	return not self:GetFrame():IsShowingBag(self:GetSlot())
end

function Bag:GetInfo()
	return Addon:GetBagInfo(self:GetOwner(), self:GetSlot())
end
