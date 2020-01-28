--[[
	item.lua
		An item slot button
--]]

local ADDON, Addon = ...
local Item = Addon.Tipped:NewClass('Item', Addon.IsRetail and 'ItemButton' or 'Button', 'ContainerFrameItemButtonTemplate', true)
local Search = LibStub('LibItemSearch-1.2')
local Unfit = LibStub('Unfit-1.0')

Item.SlotTypes = {
	[-3] = 'reagent',
	[0x00001] = 'quiver',
	[0x00002] = 'quiver',
	[0x00003] = 'soul',
	[0x00004] = 'soul',
	[0x00006] = 'herb',
	[0x00007] = 'enchant',
	[0x00008] = 'leather',
	[0x00009] = 'key',
	[0x00010] = 'inscribe',
	[0x00020] = 'herb',
	[0x00040] = 'enchant',
	[0x00080] = 'engineer',
	[0x00200] = 'gem',
	[0x00400] = 'mine',
 	[0x08000] = 'tackle',
 	[0x10000] = 'fridge'
}


--[[ Construct ]]--

function Item:New(parent, bag, slot)
	local b = self:Super(Item):New(parent)
	b:SetID(slot)
	b.bag = bag

	if b:IsVisible() then
		b:Update()
	else
		b:Show()
	end
	return b
end

function Item:Construct()
	local b = self:GetBlizzard() or self:Super(Item):Construct()
	local name = b:GetName()

	b.Flash = b:CreateAnimationGroup()
	b.IconGlow = b:CreateTexture(nil, 'OVERLAY', nil, -1)
	b.Cooldown, b.QuestBorder = _G[name .. 'Cooldown'], _G[name .. 'IconQuestTexture']
	b.UpdateTooltip = self.UpdateTooltip

	b.newitemglowAnim:SetLooping('NONE')
	b.IconOverlay:SetAtlas('AzeriteIconFrame')
	b.QuestBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	b.IconGlow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	b.IconGlow:SetBlendMode('ADD')
	b.IconGlow:SetPoint('CENTER')
	b.IconGlow:SetSize(67, 67)

	for i = 1, 3 do
		local fade = b.Flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2)
		fade:SetDuration(.2)
		fade:SetFromAlpha(.8)
		fade:SetToAlpha(0)

		local fade = b.Flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2 + 1)
		fade:SetDuration(.3)
		fade:SetFromAlpha(0)
		fade:SetToAlpha(.8)
	end

	b:SetScript('OnEvent', nil)
	b:SetScript('OnShow', b.OnShow)
	b:SetScript('OnHide', b.OnHide)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('PreClick', b.OnPreClick)
	b:HookScript('OnClick', b.OnPostClick)
	return b
end

function Item:GetBlizzard(id)
    if not Addon.sets.displayBlizzard and Addon.Frames:AreBasicsEnabled() then
			local id = self:NumFrames() + 1
			local bag = ceil(id / 36)
			local slot = (id-1) % 36 + 1
			local b = _G[format('ContainerFrame%dItem%d', bag, slot)]
			if b then
					b:ClearAllPoints()
					return self:Bind(b)
			end
    end
end

function Item:Bind(frame)
	local class = self
	while class do
		for k,v in pairs(class) do
			frame[k] = frame[k] or v
		end

		class = class:GetSuper()
	end

	return frame
end


--[[ Interaction ]]--

function Item:OnShow()
	self:RegisterFrameSignal('FOCUS_BAG', 'UpdateFocus')
	self:RegisterSignal('SEARCH_CHANGED', 'UpdateSearch')
	self:RegisterSignal('SEARCH_TOGGLED', 'UpdateSearch')
	self:RegisterSignal('FLASH_ITEM', 'OnItemFlashed')
	if(self:GetID()) then self:Update() end --abyui
end

function Item:OnHide()
	if self.hasStackSplit == 1 then
		StackSplitFrame:Hide()
	end

	if self:IsNew() then
		C_NewItems.RemoveNewItem(self:GetBag(), self:GetID())
	end

	self:UnregisterAll()
end

function Item:OnPreClick(button)
	if not IsModifiedClick() and button == 'RightButton' then
		if REAGENTBANK_CONTAINER and Addon:InBank() and IsReagentBankUnlocked() and GetContainerNumFreeSlots(REAGENTBANK_CONTAINER) > 0 then
			if not Addon:IsReagents(self:GetBag()) and Search:IsReagent(self.info.link) then
				for _, bag in ipairs {BANK_CONTAINER, 5, 6, 7, 8, 9, 10, 11} do
					for slot = 1, GetContainerNumSlots(bag) do
						if GetContainerItemID(bag, slot) == self.info.id then
							local free = self.info.stack - select(2, GetContainerItemInfo(bag, slot))
							if free > 0 then
								SplitContainerItem(self:GetBag(), self:GetID(), min(self.info.count, free))
								PickupContainerItem(bag, slot)
							end
						end
					end
				end

				UseContainerItem(self:GetBag(), self:GetID(), nil, true)
			end
		end
	end

	self.locked = self.info.locked
end

function Item:OnPostClick(button)
	if self:FlashFind(button) or IsModifiedClick() then
		return
	elseif button == 'RightButton' and Addon:InVault() and self.locked then
		for i = 10, 1, -1 do
			if GetVoidTransferDepositInfo(i) == self.info.id then
				ClickVoidTransferDepositSlot(i, true)
			end
		end
	end
end

function Item:OnEnter()
	self:UpdateTooltip()
end

function Item:OnLeave()
	self:Super(Item):OnLeave()
	ResetCursor()
end


--[[ Update ]]--

function Item:Update()
	self.info = self:GetInfo()
	self.hasItem = self.info.id and true -- for blizzard template
	self.readable = self.info.readable -- for blizzard template
	self:Delay(0.05, 'UpdateSecondary')
	self:UpdateSlotColor()
	self:UpdateBorder()

	SetItemButtonTexture(self, self.info.icon or self:GetEmptyItemIcon())
	SetItemButtonCount(self, self.info.count)
end

function Item:UpdateLocked()
	self.info = self:GetInfo()
	self:SetLocked(self.info.locked)
end

function Item:UpdateSecondary()
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

function Item:UpdateBorder()
	local id, quality = self.info.id, self.info.quality
	local new = Addon.sets.glowNew and self:IsNew()
	local quest, questID = self:IsQuestItem()
	local paid = self:IsPaid()
	local r,g,b

	if new and not self.flashAnim:IsPlaying() then
		self.flashAnim:Play()
		self.newitemglowAnim:Play()
	end

	if id then
		if Addon.sets.glowQuest and quest then
			r,g,b = 1, .82, .2
		elseif Addon.sets.glowUnusable and Unfit:IsItemUnusable(id) then
			r,g,b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
		elseif Addon.sets.glowSets and Search:InSet(self.info.link) then
            r,g,b = .1, 1, 1
            local corruption = self.info.corruption if corruption and corruption > 0 then r,g,b = 1,0,0 end
        elseif Addon.sets.glowQuality and quality and quality > 1 then
            r,g,b = GetItemQualityColor(quality)
            local corruption = self.info.corruption if corruption and corruption > 0 then r,g,b = 1,0,0 end
        end
    end

	self.IconBorder:SetTexture(id and C_ArtifactUI and C_ArtifactUI.GetRelicInfoByItemID(id) and 'Interface/Artifacts/RelicIconFrame' or 'Interface/Common/WhiteIconFrame')
	self.IconBorder:SetVertexColor(r,g,b)
	self.IconBorder:SetShown(r)

	self.IconGlow:SetVertexColor(r,g,b, Addon.sets.glowAlpha)
	self.IconGlow:SetShown(r)

	self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
	self.NewItemTexture:SetShown(new and not paid)

	self.IconOverlay:SetShown(id and C_AzeriteEmpoweredItem and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(id))
	self.JunkIcon:SetShown(Addon.sets.glowPoor and quality == LE_ITEM_QUALITY_POOR and not self.info.worthless)
	self.BattlepayItemTexture:SetShown(new and paid)
	self.QuestBorder:SetShown(questID)
end

function Item:UpdateSlotColor()
	local color = not self.info.id and Addon.sets.colorSlots and Addon.sets[self:GetSlotType() .. 'Color'] or {}
	local r,g,b = color[1] or 1, color[2] or 1, color[3] or 1

	SetItemButtonTextureVertexColor(self, r,g,b)
	self:GetNormalTexture():SetVertexColor(r,g,b)
end

function Item:UpdateUpgradeIcon()
	local isUpgrade = self:IsUpgrade()
	if isUpgrade == nil then
		self:Delay(0.5, 'UpdateUpgradeIcon')
	else
		self.UpgradeIcon:SetShown(isUpgrade)
	end
end

function Item:SetLocked(locked)
	SetItemButtonDesaturated(self, locked)
end

function Item:UpdateCooldown()
	if self.info.id and (not self.info.cached) then
		ContainerFrame_UpdateCooldown(self:GetBag(), self)
	else
		self.Cooldown:Hide()
		CooldownFrame_Set(self.Cooldown, 0, 0, 0)
	end
end


--[[ Searches ]]--

function Item:UpdateSearch()
	local search = Addon.canSearch and Addon.search or ''
	local matches = search == '' or Search:Matches(self.info.link, search)

	self:SetAlpha(matches and 1 or 0.3)
	self:SetLocked(not matches or self.info.locked)
end

function Item:UpdateFocus()
	if self:GetBag() == self:GetFrame().focusedBag then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end

function Item:FlashFind(button)
	if IsAltKeyDown() and button == 'LeftButton' and Addon.sets.flashFind and self.info.id then
		self:SendSignal('FLASH_ITEM', self.info.id)
		return true
	end
end

function Item:OnItemFlashed(_, itemID)
	self.Flash:Stop()
	if self.info.id == itemID then
		self.Flash:Play()
	end
end


--[[ Tooltip ]]--

function Item:UpdateTooltip()
    if self.info.link or self.info.id then
   		if self.info.link and self.info.cached then
			self:ShowCachedTooltip()
		else
			self:ShowTooltip()
			self:UpdateBorder()
		end
	else
		self:OnLeave()
	end
end

function Item:ShowTooltip()
	local bag = self:GetBag()
	local getSlot = Addon:IsBank(bag) and BankButtonIDToInvSlotID or
									Addon:IsKeyring(bag) and KeyRingButtonIDToInvSlotID or
									Addon:IsReagents(bag) and ReagentBankButtonIDToInvSlotID

	if getSlot then
		GameTooltip:SetOwner(self:GetTipAnchor())

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

function Item:ShowCachedTooltip()
	Item.dummy = Item.dummy or Item:CreateDummy()
	Item.dummy:SetParent(self)
	Item.dummy:SetAllPoints()
	Item.dummy:Show()
end

function Item:CreateDummy()
	local function showTooltip(slot)
		local parent = slot:GetParent()
		local link = parent.info.link
		if link then
			GameTooltip:SetOwner(parent:GetTipAnchor())
			parent:LockHighlight()
			CursorUpdate(parent)

			if link:find('battlepet:') then
				local _, specie, level, quality, health, power, speed = strsplit(':', link)
				local name = link:match('%[(.-)%]')

				BattlePetToolTip_Show(tonumber(specie), level, tonumber(quality), health, power, speed, name)
			else
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		end
	end

	local slot = CreateFrame('Button')
	slot.UpdateTooltip = showTooltip
	slot:SetScript('OnEnter', showTooltip)
	slot:SetScript('OnShow', showTooltip)
	slot:RegisterForClicks('anyUp')
	slot:SetToplevel(true)

	slot:SetScript('OnClick', function(slot, button)
		local parent = slot:GetParent()
		if not HandleModifiedItemClick(parent.info.link) then
			parent:FlashFind(button)
		end
	end)

	slot:SetScript('OnLeave', function(slot)
		slot:GetParent():UnlockHighlight()
		slot:GetParent():OnLeave()
		slot:Hide()
	end)

	return slot
end

if AbyUpdateTooltipWrapperFunc then Item.UpdateTooltip = AbyUpdateTooltipWrapperFunc(Item.UpdateTooltip, .5) end

--[[ Data ]]--

function Item:IsQuestItem()
	if self.info.id then
		if not self.info.cached and GetContainerItemQuestInfo then
			local isQuest, questID, isActive = GetContainerItemQuestInfo(self:GetBag(), self:GetID())
			return isQuest, (questID and not isActive)
		else
			return self.info.class == LE_ITEM_CLASS_QUESTITEM or Search:ForQuest(self.info.link)
		end
	end
end

function Item:IsUpgrade()
	if IsContainerItemAnUpgrade then -- difference bettween nil and false
		return IsContainerItemAnUpgrade(self:GetBag(), self:GetID())
	end
end

function Item:IsNew()
	return self:GetBag() and C_NewItems.IsNewItem(self:GetBag(), self:GetID())
end

function Item:IsPaid()
	return IsBattlePayItem(self:GetBag(), self:GetID())
end

function Item:IsSlot(bag, slot)
	return self:GetBag() == bag and self:GetID() == slot
end

function Item:GetInfo()
	return self:GetFrame():GetItemInfo(self:GetBag(), self:GetID())
end

function Item:GetItem() -- for legacy purposes
	return self.info.link
end

function Item:GetBag()
	return self.bag
end

function Item:GetSlotType()
	local bag = self:GetFrame():GetBagInfo(self:GetBag())
	return self.SlotTypes[bag.family] or 'normal'
end

function Item:GetEmptyItemIcon()
	return Addon.sets.emptySlots and 'Interface/PaperDoll/UI-Backpack-EmptySlot'
end
