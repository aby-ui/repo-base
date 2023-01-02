if BattlePetToolTip_Show ~= nil then -- not Auctionator.Constants.IsClassic
  hooksecurefunc (_G, "BattlePetToolTip_Show",
    function(speciesID, ...)
      Auctionator.Tooltip.AddPetTip(speciesID)
    end
  )
end

local TooltipHandlers = {}

-- This is called when mousing over an item in your bags
TooltipHandlers["SetBagItem"] = function(tip, bag, slot)
  local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)

  if C_Item.DoesItemExist(itemLocation) then
    local itemLink = C_Item.GetItemLink(itemLocation);
    local itemCount = C_Item.GetStackCount(itemLocation)

    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

-- This is called when mousing over an item in a merchant window (Buyback Pane)
TooltipHandlers["SetBuybackItem"] = function(tip, slotIndex)
  local itemLink = GetBuybackItemLink(slotIndex)
  local _, _, _, itemCount = GetBuybackItemInfo(slotIndex);

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

-- This is called when mousing over an item in a merchant window (Merchant Pane)
TooltipHandlers["SetMerchantItem"] = function(tip, index)
  local itemLink = GetMerchantItemLink(index)
  local _, _, _, itemCount = GetMerchantItemInfo(index);

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

-- This is called when mousing over an item in your bank, or a bag in your bag list
TooltipHandlers["SetInventoryItem"] = function(tip, unit, slot)
  local itemLink = GetInventoryItemLink(unit, slot)
  local itemCount = GetInventoryItemCount(unit, slot)

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount ~= 0 and itemCount or 1)
end

-- This is called when mousing over an item in your guild bank
-- Guild banks don't keep track of pets inside them correctly, so showing the AH
-- price is difficult.
TooltipHandlers["SetGuildBankItem"] = function(tip, tab, slot)
  local itemLink = GetGuildBankItemLink(tab, slot)
  local _, itemCount = GetGuildBankItemInfo(tab, slot)

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

if GameTooltip.SetRecipeReagentItem then -- Dragonflight
  -- Reagent in Dragonflight recipe tradeskill page, only for reagents without a
  -- quality rating.
  TooltipHandlers["SetRecipeReagentItem"] = function( tip, recipeID, slotID )
    local itemLink = C_TradeSkillUI.GetRecipeFixedReagentItemLink(recipeID, slotID)

    local schematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false, ProfessionsFrame.CraftingPage.SchematicForm:GetCurrentRecipeLevel())

    for _, reagentSlotSchematic in ipairs(schematic.reagentSlotSchematics) do
      if reagentSlotSchematic.dataSlotIndex == slotID then
        local itemCount = reagentSlotSchematic.quantityRequired
        Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
        break
      end
    end
  end
end

if GameTooltip.SetRecipeResultItem then -- Dragonflight
  TooltipHandlers["SetRecipeResultItem"] = function(tip, recipeID, reagents, allocations, recipeLevel, qualityID)
    local outputLink = Auctionator.CraftingInfo.GetOutputItemLink(recipeID, recipeLevel, reagents, allocations)

    if outputLink then
      local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false, recipeLevel)

      Auctionator.Tooltip.ShowTipWithPricing(GameTooltip, outputLink, recipeSchematic.quantityMin)
    end
  end
end

if GameTooltip.SetTradeSkillItem then -- Classic
  TooltipHandlers["SetTradeSkillItem"] = function(tip, recipeIndex, reagentIndex)
    local itemLink, itemCount
    if reagentIndex ~= nil then
      itemLink = GetTradeSkillReagentItemLink(recipeIndex, reagentIndex)
      itemCount = select(3, GetTradeSkillReagentInfo(recipeIndex, reagentIndex))
    else
      itemLink = GetTradeSkillItemLink(recipeIndex);
      itemCount  = GetTradeSkillNumMade(recipeIndex);
    end
    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

if GameTooltip.SetCraftItem then -- TBC classic and earlier
  TooltipHandlers["SetCraftItem"] = function(tip, recipeIndex, reagentIndex)
    local itemLink, itemCount
    if reagentIndex ~= nil then
      itemLink = GetCraftReagentItemLink(recipeIndex, reagentIndex)
      itemCount = select(3, GetCraftReagentInfo(recipeIndex, reagentIndex))
    else
      itemLink = GetCraftItemLink(recipeIndex);
      itemCount  = GetCraftNumMade(recipeIndex);
    end
    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

-- This is called when mousing over an item in the loot window
TooltipHandlers["SetLootItem"] = function (tip, slot)
  if LootSlotHasItem(slot) then
    local itemLink, _, itemCount = GetLootSlotLink(slot);

    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

-- TODO Haven't tested this so making an educated guess:
-- This is called when mousing over an item in the loot roll window
TooltipHandlers["SetLootRollItem"] = function (tip, slot)
  local itemLink = GetLootRollItemLink(slot)

  local _, _, itemCount = GetLootRollItemInfo(slot)

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

-- This is called when mousing over an item in a quest window
TooltipHandlers["SetQuestItem"] = function (tip, type, index)
  local itemLink = GetQuestItemLink(type, index)

  local _, _, itemCount = GetQuestItemInfo(type, index);

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

-- This is called when mousing over an item in a quest description in your quest log
TooltipHandlers["SetQuestLogItem"] = function (tip, type, index)
  local itemLink = GetQuestLogItemLink(type, index)

  local itemCount, _;
  if type == "choice" then
    _, _, itemCount = GetQuestLogChoiceInfo(index);
  else
    _, _, itemCount = GetQuestLogRewardInfo(index)
  end

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

-- This is called when mousing over an item in the send mail window
TooltipHandlers["SetSendMailItem"] = function (tip, id)
  local _, _, _, itemCount = GetSendMailItem(id)
  local itemLink = GetSendMailItemLink(id);

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
end

-- This occurs when:
-- 1. mousing over an item in the Open Mail frame
-- 2. mousing over an item in the Inbox frame
TooltipHandlers["SetInboxItem"] = function(tip, index, attachIndex)
  if Auctionator.Config.Get(Auctionator.Config.Options.MAILBOX_TOOLTIPS) then
    local attachmentIndex = attachIndex or 1

    local itemLink = GetInboxItemLink(index, attachmentIndex)

    local _, _, _, itemCount = GetInboxItem(index, attachmentIndex);

    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

-- This occurs when mousing over an item in the Inbox frame
hooksecurefunc("InboxFrameItem_OnEnter",
  function(self)
    local itemCount = select(8, GetInboxHeaderInfo(self.index))
    local tooltipEnabled =
      Auctionator.Config.Get(Auctionator.Config.Options.MAILBOX_TOOLTIPS) and  (
      Auctionator.Config.Get(Auctionator.Config.Options.VENDOR_TOOLTIPS) or
      Auctionator.Config.Get(Auctionator.Config.Options.AUCTION_TOOLTIPS) or
      Auctionator.Config.Get(Auctionator.Config.Options.ENCHANT_TOOLTIPS)
    )

    if tooltipEnabled and itemCount and itemCount > 1 then
      local itemEntries = {}
      local name, itemCount, itemLink, _

      for attachmentIndex = 1, ATTACHMENTS_MAX_RECEIVE do
        name, _, _, itemCount = GetInboxItem(self.index, attachmentIndex)

        if name then
          itemLink = GetInboxItemLink(self.index, attachmentIndex)

          table.insert(itemEntries, {
            link = itemLink,
            count = itemCount,
            name = name
          })
        end
      end

      Auctionator.Tooltip.ShowTipWithMultiplePricing(GameTooltip, itemEntries)
    end
  end
);

-- Occurs when mousing over  items I'm trading
TooltipHandlers["SetTradePlayerItem"] = function (tip, id)
  local itemLink = GetTradePlayerItemLink(id)
  if itemLink ~= nil then
    local _, _, itemCount = GetTradePlayerItemInfo(id);

    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

-- Occurs when mousing over items other player are trading
TooltipHandlers["SetTradeTargetItem"] = function (tip, id)
  local itemLink = GetTradeTargetItemLink(id)
  if itemLink ~= nil then
    local _, _, itemCount = GetTradeTargetItemInfo(id)

    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

if GameTooltip.SetAuctionItem then
  TooltipHandlers["SetAuctionItem"] = function(tip, viewType, index)
    local itemCount = select(3, GetAuctionItemInfo(viewType, index))
    local itemLink = GetAuctionItemLink(viewType, index)

    Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, itemCount)
  end
end

if GameTooltip.SetItemKey then
  TooltipHandlers["SetItemKey"] = function(tip, itemID, itemLevel, itemSuffix)
    local info = C_TooltipInfo.GetItemKey(itemID, itemLevel, itemSuffix)
    if info == nil then
      return
    end
    TooltipUtil.SurfaceArgs(info)
    if info.hyperlink then
      local hyperlink = info.hyperlink
      -- Necessary as for recipes the crafted item is returned info.hyperlink,
      -- so we check we actually got the recipe item
      if GetItemInfoInstant(info.hyperlink) ~= itemID then
        hyperlink = select(2, GetItemInfo(itemID))
      end
      Auctionator.Tooltip.ShowTipWithPricing(tip, hyperlink, 1)
    end
  end
end

-- Occurs when mousing over items in the Refer-a-Friend frame, and a few other places
TooltipHandlers["SetItemByID"] = function (tip, itemID)
  if not itemID then
    return
  end

  local itemLink = select(2, GetItemInfo(itemID))

  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, 1)
end

-- Occurs mainly with addons (Blizzard and otherwise)
TooltipHandlers["SetHyperlink"] = function (tip, itemLink)
  Auctionator.Tooltip.ShowTipWithPricing(tip, itemLink, 1)
end

-- Magic to update the tooltip with the prices when it is cleared and still
-- retain stack size information
if TooltipDataProcessor then
  TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
    if tooltip == GameTooltip or tooltip == ItemRefTooltip then
      if not tooltip.info or not tooltip.info.getterName or tooltip.info.excludeLines then
        return
      end
      local handler = TooltipHandlers[tooltip.info.getterName:gsub("^Get", "Set")]
      if handler ~= nil then
        handler(tooltip, unpack(tooltip.info.getterArgs))
      end
    end
  end)
else
  -- This occurs when clicking on an item link (i.e. in chat)
  hooksecurefunc(ItemRefTooltip, "SetHyperlink", TooltipHandlers["SetHyperlink"])

  for func, handler in pairs(TooltipHandlers) do
    hooksecurefunc(GameTooltip, func, handler)
  end
end
