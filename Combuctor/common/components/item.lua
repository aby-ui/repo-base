--[[
	item.lua
		An item slot button
--]]

local ADDON, Addon = ...
local FRAME_TYPE = Addon.IsRetail and 'ItemButton' or 'Button'

local ItemSlot = Addon:NewClass('ItemSlot', FRAME_TYPE)
ItemSlot.unused = {}
ItemSlot.nextID = 0

local Search = LibStub('LibItemSearch-1.2')
local Cache = LibStub('LibItemCache-2.0')
local Unfit = LibStub('Unfit-1.0')


--[[ Constructor ]]--

function ItemSlot:New(parent, bag, slot)
	local button = self:Restore() or self:Create()
	button:SetParent(self:GetDummyBag(parent, bag))
	button:SetID(slot)
	button.bag = bag

	if button:IsVisible() then
		button:Update()
	else
		button:Show()
	end

	return button
end

function ItemSlot:Create()
	local id = self:GetNextID()
	local item = self:Bind(self:GetBlizzard(id) or self:Construct(id))
	local name = item:GetName()

	item.UpdateTooltip = nil
	item.Flash = item:CreateAnimationGroup()
	item.IconGlow = item:CreateTexture(nil, 'OVERLAY', nil, -1)
	item.Cooldown, item.QuestBorder = _G[name .. 'Cooldown'], _G[name .. 'IconQuestTexture']

	item.newitemglowAnim:SetLooping('NONE')
	item.IconOverlay:SetAtlas('AzeriteIconFrame')
	item.QuestBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	item.IconGlow:SetTexture('Interface\\Buttons\\UI-ActionButton-Border')
	item.IconGlow:SetBlendMode('ADD')
	item.IconGlow:SetPoint('CENTER')
	item.IconGlow:SetSize(67, 67)

	for i = 1, 3 do
		local fade = item.Flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2)
		fade:SetDuration(.2)
		fade:SetFromAlpha(.8)
		fade:SetToAlpha(0)

		local fade = item.Flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2 + 1)
		fade:SetDuration(.3)
		fade:SetFromAlpha(0)
		fade:SetToAlpha(.8)
	end

	item:SetScript('OnShow', item.OnShow)
	item:SetScript('OnHide', item.OnHide)
	--abyui fix put regent to regent bank, conflict with TheBurningTrade
	if item:GetScript('PreClick') then item:HookScript('PreClick', item.OnPreClick) else item:SetScript('PreClick', item.OnPreClick) end
	item:HookScript('OnDragStart', item.OnDragStart)
	item:HookScript('OnClick', item.OnClick)
	item:SetScript('OnEnter', item.OnEnter)
	item:SetScript('OnLeave', item.OnLeave)
	item:SetScript('OnEvent', nil)

	return item
end

function ItemSlot:GetNextID()
    self.nextID = self.nextID + 1
    return self.nextID
end

function ItemSlot:Construct(id)
    return CreateFrame(FRAME_TYPE, ADDON..self.Name..id, nil, 'ContainerFrameItemButtonTemplate')
end

function ItemSlot:GetBlizzard(id)
    if Addon.sets.displayBlizzard or not Addon:AreBasicFramesEnabled() then
        return
    end

    local bag = ceil(id / MAX_CONTAINER_ITEMS)
    local slot = (id-1) % MAX_CONTAINER_ITEMS + 1
    local item = _G[format('ContainerFrame%dItem%d', bag, slot)]

    if item then
        item:SetID(0)
        item:ClearAllPoints()
        return item
    end
end

function ItemSlot:Restore()
	return tremove(self.unused, 1)
end

function ItemSlot:Free()
	self:Hide()
	self:SetParent(nil)
	self.frame = nil
	self.depositSlot = nil
	tinsert(self.unused, self)
end


--[[ Interaction ]]--

function ItemSlot:OnShow()
	self:RegisterFrameSignal('FOCUS_BAG', 'UpdateFocus')
	self:RegisterSignal('SEARCH_CHANGED', 'UpdateSearch')
	self:RegisterSignal('SEARCH_TOGGLED', 'UpdateSearch')
	self:RegisterSignal('FLASH_ITEM', 'OnItemFlashed')
	if(self:GetID()) then self:Update() end --abyui
end

function ItemSlot:OnHide()
	if self.hasStackSplit == 1 then
		StackSplitFrame:Hide()
	end

	if self:IsNew() then
		C_NewItems.RemoveNewItem(self:GetBag(), self:GetID())
	end

	self:UnregisterSignals()
end

function ItemSlot:OnDragStart()
	ItemSlot.Cursor = self
end

function ItemSlot:OnPreClick(button)
	if IsModifiedClick() or button ~= 'RightButton' then
		return
	end

	if REAGENTBANK_CONTAINER and Cache.AtBank then
		if IsReagentBankUnlocked() and GetContainerNumFreeSlots(REAGENTBANK_CONTAINER) > 0 then
			if not Addon:IsReagents(self:GetBag()) and Search:IsReagent(self.info.link) then
				local maxstack = select(8, GetItemInfo(self.info.id))

				for _, bag in ipairs {BANK_CONTAINER, 5, 6, 7, 8, 9, 10, 11} do
					for slot = 1, GetContainerNumSlots(bag) do
						if GetContainerItemID(bag, slot) == self.info.id then
							local _,count = GetContainerItemInfo(bag, slot)
							local free = maxstack - count

							if (free > 0) then
								SplitContainerItem(self:GetBag(), self:GetID(), min(self.count, free))
								PickupContainerItem(bag, slot)
							end
						end
					end
				end

				return UseContainerItem(self:GetBag(), self:GetID(), nil, true)
			end
		end
	end

	if Addon.HasVault then
		for i = 1,9 do
			if not GetVoidTransferDepositInfo(i) then
				self.depositSlot = i
				return
			end
		end
	end
end

function ItemSlot:OnClick(button)
	if IsAltKeyDown() and button == 'LeftButton' then
		if Addon.sets.flashFind and self.info.id then
			self:SendSignal('FLASH_ITEM', self.info.id)
		end
	elseif GetNumVoidTransferDeposit and GetNumVoidTransferDeposit() > 0 and button == 'RightButton' then
		if self.canDeposit and self.depositSlot then
			ClickVoidTransferDepositSlot(self.depositSlot, true)
		end

		self.canDeposit = not self.canDeposit
	end
end

function ItemSlot:OnModifiedClick(...)
	local link = self.info.cached and self.info.link
	if link and not HandleModifiedItemClick(link) then
		self:OnClick(...)
	end
end

function ItemSlot:OnEnter()
	if self.info.cached then
		local dummy = ItemSlot:GetDummySlot()
		dummy:SetParent(self)
		dummy:SetAllPoints(self)
		dummy:Show()
	elseif self.info.id then
		self:ShowTooltip()
		self:UpdateBorder()
	else
		self:OnLeave()
	end
end

function ItemSlot:OnLeave()
	if BattlePetTooltip then
		BattlePetTooltip:Hide()
	end

	GameTooltip:Hide()
	ResetCursor()
end


--[[ Update ]]--

function ItemSlot:Update()
	self.info = self:GetInfo()
	self.hasItem = self.info.id and true
	self.readable = self.info.readable
	self:After(0.1, 'UpdateSecondary')
	self:UpdateSlotColor()
	self:UpdateBorder()

	SetItemButtonTexture(self, self.info.icon or self:GetEmptyItemIcon())
	SetItemButtonCount(self, self.info.count)
end

function ItemSlot:UpdateLocked()
	self.info = self:GetInfo()
	self:SetLocked(self.info.locked)
end

function ItemSlot:UpdateSecondary()
	if self:GetFrame() then
		self:UpdateFocus()
		self:UpdateSearch()
		self:UpdateCooldown()
		self:UpdateUpgradeIcon()

		if GameTooltip:IsOwned(self) then
			self:UpdateTooltip()
		end
	end
end


--[[ Appearance ]]--

function ItemSlot:UpdateBorder()
	local id, quality = self.info.id, self.info.quality
	local new = Addon.sets.glowNew and self:IsNew()
	local quest, questID = self:IsQuestItem()
	local paid = self:IsPaid()
	local r, g, b

	if new and not self.flashAnim:IsPlaying() then
		self.flashAnim:Play()
		self.newitemglowAnim:Play()
	end

	if id then
		if Addon.sets.glowQuest and quest then
			r, g, b = 1, .82, .2
		elseif Addon.sets.glowUnusable and Unfit:IsItemUnusable(id) then
			r, g, b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
		elseif Addon.sets.glowSets and Search:InSet(self.info.link) then
	  	r, g, b = .1, 1, 1
		elseif Addon.sets.glowQuality and type(quality) == "number" and quality > 1 then
			r, g, b = GetItemQualityColor(quality)
		end
	end

	self.IconBorder:SetTexture(id and C_ArtifactUI and C_ArtifactUI.GetRelicInfoByItemID(id) and 'Interface\\Artifacts\\RelicIconFrame' or 'Interface\\Common\\WhiteIconFrame')
	self.IconBorder:SetVertexColor(r, g, b)
	self.IconBorder:SetShown(r)

	self.IconGlow:SetVertexColor(r, g, b, Addon.sets.glowAlpha)
	self.IconGlow:SetShown(r)

	self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
	self.NewItemTexture:SetShown(new and not paid)

	self.IconOverlay:SetShown(id and C_AzeriteEmpoweredItem and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(id))
	self.BattlepayItemTexture:SetShown(new and paid)
	self.QuestBorder:SetShown(questID)
end

function ItemSlot:UpdateSlotColor()
	local color = not self.info.id and Addon.sets.colorSlots and Addon.sets[self:GetBagType() .. 'Color']
	local r, g, b = color and color[1] or 1, color and color[2] or 1, color and color[3] or 1

	SetItemButtonTextureVertexColor(self, r,g,b)
	self:GetNormalTexture():SetVertexColor(r,g,b)
end

function ItemSlot:UpdateUpgradeIcon()
	local isUpgrade = self:IsUpgrade()
	if isUpgrade == nil then
		self:After(0.5, 'UpdateUpgradeIcon')
	else
		self.UpgradeIcon:SetShown(isUpgrade)
	end
end

function ItemSlot:SetLocked(locked)
	SetItemButtonDesaturated(self, locked)
end

function ItemSlot:UpdateCooldown()
	if self.info.id and (not self.info.cached) then
		ContainerFrame_UpdateCooldown(self:GetBag(), self)
	else
		self.Cooldown:Hide()
		CooldownFrame_Set(self.Cooldown, 0, 0, 0)
	end
end


--[[ Searches ]]--

function ItemSlot:UpdateSearch()
	local search = Addon.canSearch and Addon.search or ''
	local matches = search == '' or Search:Matches(self.info.link, search)

	self:SetAlpha(matches and 1 or 0.3)
	self:SetLocked(not matches or self.info.locked)
end

function ItemSlot:UpdateFocus()
	if self:GetBag() == self:GetFrame().focusedBag then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end

function ItemSlot:OnItemFlashed(_,itemID)
	self.Flash:Stop()
	if self.info.id == itemID then
		self.Flash:Play()
	end
end


--[[ Tooltip ]]--

function ItemSlot:ShowTooltip()
	local bag = self:GetBag()
	local getSlot = Addon:IsBank(bag) and BankButtonIDToInvSlotID or Addon:IsReagents(bag) and ReagentBankButtonIDToInvSlotID

	if getSlot then
		self:AnchorTooltip()

		local _, _, _, speciesID, level, breedQuality, maxHealth, power, speed, name = GameTooltip:SetInventoryItem('player', getSlot(self:GetID()))
		if speciesID and speciesID > 0 then
			BattlePetToolTip_Show(speciesID, level, breedQuality, maxHealth, power, speed, name)
		else
			if BattlePetTooltip then
				BattlePetTooltip:Hide()
			end
			GameTooltip:Show()
		end

		CursorUpdate(self)
	else
		ContainerFrameItemButton_OnEnter(self)
	end
end

function ItemSlot:AnchorTooltip()
	if self:GetRight() >= (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end
end

function ItemSlot:UpdateTooltip()
	self:OnEnter()
end

if AbyUpdateTooltipWrapperFunc then ItemSlot.UpdateTooltip = AbyUpdateTooltipWrapperFunc(ItemSlot.UpdateTooltip, 2) end

--[[ Data ]]--

function ItemSlot:IsQuestItem()
	if self.info.id then
		if not self.info.cached and GetContainerItemQuestInfo then
			local isQuest, questID, isActive = GetContainerItemQuestInfo(self:GetBag(), self:GetID())
			return isQuest, (questID and not isActive)
		else
			return select(12, GetItemInfo(self.info.id)) == LE_ITEM_CLASS_QUESTITEM or Search:ForQuest(self.info.link)
		end
	end
end

function ItemSlot:IsUpgrade()
	if IsContainerItemAnUpgrade then -- difference bettween nil and false
		return IsContainerItemAnUpgrade(self:GetBag(), self:GetID())
	end
end

function ItemSlot:IsNew()
	return self:GetBag() and C_NewItems.IsNewItem(self:GetBag(), self:GetID())
end

function ItemSlot:IsPaid()
	return IsBattlePayItem(self:GetBag(), self:GetID())
end

function ItemSlot:IsSlot(bag, slot)
	return self:GetBag() == bag and self:GetID() == slot
end

function ItemSlot:GetInfo()
	return self:GetFrame():GetItemInfo(self:GetBag(), self:GetID())
end

function ItemSlot:GetBagType()
	return Addon:GetBagType(self:GetOwner(), self:GetBag())
end

function ItemSlot:GetItem() -- for legacy purposes
	return self.info.link
end

function ItemSlot:GetBag()
	return self.bag
end

function ItemSlot:GetEmptyItemIcon()
	return Addon.sets.emptySlots and 'Interface/PaperDoll/UI-Backpack-EmptySlot'
end


--[[ Dummies ]]--

function ItemSlot:GetDummyBag(parent, bag)
	parent.dummyBags = parent.dummyBags or {}

	if not parent.dummyBags[bag] then
		parent.dummyBags[bag] = self:Bind(CreateFrame('Frame', nil, parent))
		parent.dummyBags[bag]:SetID(tonumber(bag) or 1)
	end

	return parent.dummyBags[bag]
end

function ItemSlot:GetDummySlot()
	self.dummySlot = self.dummySlot or self:CreateDummySlot()
	self.dummySlot:Hide()
	return self.dummySlot
end

function ItemSlot:CreateDummySlot()
	local slot = CreateFrame('Button')
	slot:RegisterForClicks('anyUp')
	slot:SetToplevel(true)

	local function Slot_OnEnter(self)
		local parent = self:GetParent()
		local item = parent:IsCached() and parent.info.link

		if item then
			parent.AnchorTooltip(self)

			if item:find('battlepet:') then
				local _, specie, level, quality, health, power, speed = strsplit(':', item)
				local name = item:match('%[(.-)%]')

				BattlePetToolTip_Show(tonumber(specie), level, tonumber(quality), health, power, speed, name)
			else
				GameTooltip:SetHyperlink(item)
				GameTooltip:Show()
			end
		end

		parent:LockHighlight()
		CursorUpdate(parent)
	end

	local function Slot_OnLeave(self)
		self:GetParent():OnLeave()
		self:Hide()
	end

	local function Slot_OnHide(self)
		local parent = self:GetParent()
		if parent then
			parent:UnlockHighlight()
		end
	end

	local function Slot_OnClick(self, button)
		self:GetParent():OnModifiedClick(button)
	end

	slot.UpdateTooltip = Slot_OnEnter
	slot:SetScript('OnClick', Slot_OnClick)
	slot:SetScript('OnEnter', Slot_OnEnter)
	slot:SetScript('OnLeave', Slot_OnLeave)
	slot:SetScript('OnShow', Slot_OnEnter)
	slot:SetScript('OnHide', Slot_OnHide)
	return slot
end
