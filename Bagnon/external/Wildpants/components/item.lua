--[[
	item.lua
		An item slot button
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local ItemSlot = Addon:NewClass('ItemSlot', 'Button')
ItemSlot.unused = {}
ItemSlot.nextID = 0

local ItemSearch = LibStub('LibItemSearch-1.2')
local Unfit = LibStub('Unfit-1.0')

local QUEST = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
local QUEST_LOWER = QUEST:lower()


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

	-- add a quality border texture
	local border = item:CreateTexture(nil, 'OVERLAY')
	border:SetSize(67, 67)
	border:SetPoint('CENTER', item)
	border:SetTexture([[Interface\Buttons\UI-ActionButton-Border]])
	border:SetBlendMode('ADD')
	border:Hide()

	-- add flash find animation
	local flash = item:CreateAnimationGroup()
	for i = 1, 3 do
		local fade = flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2)
		fade:SetDuration(.2)
		fade:SetFromAlpha(.8)
		fade:SetToAlpha(0)

		local fade = flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2 + 1)
		fade:SetDuration(.3)
		fade:SetFromAlpha(0)
		fade:SetToAlpha(.8)
	end

	item.UpdateTooltip = nil
	item.Border, item.Flash = border, flash
	item.newitemglowAnim:SetLooping('NONE')
	item.QuestBorder = _G[name .. 'IconQuestTexture']
	item.Cooldown = _G[name .. 'Cooldown']
	item:SetScript('OnShow', item.OnShow)
	item:SetScript('OnHide', item.OnHide)
	--163ui fix put regent to regent bank, conflict with TheBurningTrade
	if item:GetScript('PreClick') then item:HookScript('PreClick', item.OnPreClick) else item:SetScript('PreClick', item.OnPreClick) end
	item:HookScript('OnDragStart', item.OnDragStart)
	item:HookScript('OnClick', item.OnClick)
	item:SetScript('OnEnter', item.OnEnter)
	item:SetScript('OnLeave', item.OnLeave)
	item:SetScript('OnEvent', nil)
	item:HideBorder()

	return item
end

function ItemSlot:GetNextID()
	self.nextID = self.nextID + 1
	return self.nextID
end

function ItemSlot:Construct(id)
	return CreateFrame('Button', ADDON..self.Name..id, nil, 'ContainerFrameItemButtonTemplate')
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
	self.frame, self.depositSlot = nil
	tinsert(self.unused, self)
end


--[[ Interaction ]]--

function ItemSlot:OnShow()
	self:RegisterFrameSignal('FOCUS_BAG', 'UpdateFocus')
	self:RegisterSignal('SEARCH_CHANGED', 'UpdateSearch')
	self:RegisterSignal('SEARCH_TOGGLED', 'UpdateSearch')
	self:RegisterSignal('FLASH_ITEM', 'OnItemFlashed')
	if(self:GetID()) then self:Update() end --163ui
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
	if not IsModifiedClick() and button == 'RightButton' then
		if Cache.AtBank and IsReagentBankUnlocked() and GetContainerNumFreeSlots(REAGENTBANK_CONTAINER) > 0 then
			if not Addon:IsReagents(self:GetBag()) and ItemSearch:TooltipPhrase(self.info.link, PROFESSIONS_USED_IN_COOKING) then
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

		if not self.canDeposit then
			for i = 1,9 do
				if not GetVoidTransferDepositInfo(i) then
					self.depositSlot = i
					return
				end
			end
		end
	end
end

function ItemSlot:OnClick(button)
	if IsAltKeyDown() and button == 'LeftButton' then
		if Addon.sets.flashFind and self.info.id then
			self:SendSignal('FLASH_ITEM', self.info.id)
		end
	elseif GetNumVoidTransferDeposit() > 0 and button == 'RightButton' then
		if self.canDeposit and self.depositSlot then
			ClickVoidTransferDepositSlot(self.depositSlot, true)
		end

		self.canDeposit = not self.canDeposit
	end
end

function ItemSlot:OnModifiedClick(...)
	local link = self:IsCached() and self.info.link
	if link and not HandleModifiedItemClick(link) then
		self:OnClick(...)
	end
end

function ItemSlot:OnEnter()
	if self:IsCached() then
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
	GameTooltip:Hide()
	BattlePetTooltip:Hide()
	ResetCursor()
end


--[[ Update ]]--

function ItemSlot:Update()
	local info = self:GetInfo()

	self.info, self.hasItem, self.readable = info, info.id and true, info.readable
	self:After(0.1, 'SecondaryUpdate')
	self:SetLocked(info.locked)
	self:UpdateCooldown()

	SetItemButtonTexture(self, info.icon or self:GetEmptyItemIcon())
	SetItemButtonCount(self, info.count)
end

function ItemSlot:SecondaryUpdate()
	self:UpdateFocus()
	self:UpdateSearch()
	self:UpdateSlotColor()
	self:UpdateUpgradeIcon()

	if GameTooltip:IsOwned(self) then
		self:UpdateTooltip()
	end
end


--[[ Basic Features ]]--

function ItemSlot:UpdateLocked()
	self:SetLocked(self:GetInfo().locked)
end

function ItemSlot:SetLocked(locked)
	SetItemButtonDesaturated(self, locked)
end

function ItemSlot:UpdateCooldown()
	if self.info.id and (not self:IsCached()) then
		ContainerFrame_UpdateCooldown(self:GetBag(), self)
	else
		self.Cooldown:Hide()
		CooldownFrame_Set(self.Cooldown, 0, 0, 0)
	end
end

function ItemSlot:UpdateUpgradeIcon()
	local isUpgrade = self:IsUpgrade()
	if isUpgrade == nil then
		self:After(0.5, 'UpdateUpgradeIcon')
	else
		self.UpgradeIcon:SetShown(isUpgrade)
	end
end

function ItemSlot:UpdateSlotColor()
	if not self.info.id and Addon.sets.colorSlots then
		local color = Addon.sets[self:GetBagType() .. 'Color']
		self:SetSlotColor(color[1], color[2], color[3])
	else
		self:SetSlotColor(1, 1, 1)
	end
end

function ItemSlot:SetSlotColor(...)
	SetItemButtonTextureVertexColor(self, ...)
	self:GetNormalTexture():SetVertexColor(...)
end


--[[ Border Glow ]]--

function ItemSlot:UpdateBorder()
	self:HideBorder()

	local link = self.info.link
	if link then
		local isQuestItem, isQuestStarter = self:IsQuestItem()
		if isQuestStarter then
			self.QuestBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
			self.QuestBorder:Show()
			return
		end

		local quality = self.info.quality
		if Addon.sets.glowNew and self:IsNew() then
			if not self.flashAnim:IsPlaying() then
				self.flashAnim:Play()
				self.newitemglowAnim:SetLooping('NONE')
				self.newitemglowAnim:Play()
			end

			if self:IsPaid() then
				return self.BattlepayItemTexture:Show()
			else
				self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
				self.NewItemTexture:Show()
				return
			end
		end

		if Addon.sets.glowQuest and isQuestItem then
			return self:SetBorderColor(1, .82, .2)
		end

		if Addon.sets.glowSets and ItemSearch:InSet(link) then
	   		return self:SetBorderColor(.1, 1, 1)
	  	end

		if Addon.sets.glowUnusable and Unfit:IsItemUnusable(link) then
			return self:SetBorderColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		end

		if Addon.sets.glowQuality and type(quality)=="number" and quality > 1 then
			self:SetBorderColor(GetItemQualityColor(quality))
		end
	end
end

function ItemSlot:SetBorderColor(r, g, b)
	self.Border:SetVertexColor(r, g, b, Addon.sets.glowAlpha)
	self.Border:Show()
end

function ItemSlot:HideBorder()
	self.QuestBorder:Hide()
	self.Border:Hide()
	self.NewItemTexture:Hide()
	self.BattlepayItemTexture:Hide()
end


--[[ Searches ]]--

function ItemSlot:UpdateSearch()
	local search = Addon.canSearch and Addon.search or ''
	local matches = search == '' or ItemSearch:Matches(self.info.link, search)

	if matches then
		self:SetAlpha(1)
		self:UpdateLocked()
		self:UpdateBorder()
	else
		self:SetLocked(true)
		self:SetAlpha(0.4)
		self:HideBorder()
	end
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


--[[ Data ]]--

function ItemSlot:IsQuestItem()
	if self.info.id then
		if self:IsCached() then
			return select(12, GetItemInfo(self.info.id)) == LE_ITEM_CLASS_QUESTITEM or ItemSearch:Tooltip(self.info.link, QUEST_LOWER), false
		else
			local isQuestItem, questID, isActive = GetContainerItemQuestInfo(self:GetBag(), self:GetID())
			return isQuestItem, (questID and not isActive)
		end
	end
end

function ItemSlot:IsNew()
	return self:GetBag() and C_NewItems.IsNewItem(self:GetBag(), self:GetID())
end

function ItemSlot:IsPaid()
	return IsBattlePayItem(self:GetBag(), self:GetID())
end

function ItemSlot:IsUpgrade()
	return IsContainerItemAnUpgrade(self:GetBag(), self:GetID()) --163ui todo return false
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


--[[ Performance ]]--

function ItemSlot:After(time, action)
	local lock = 'scheduled' .. action
	if self[lock] then
		return
	end

	C_Timer.After(time, function()
		if self:GetFrame() then -- might have been released meanwhile
			self[action](self)
		end
		self[lock] = false
	end)

	self[lock] = true
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
