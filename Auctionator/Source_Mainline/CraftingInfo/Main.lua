-- Get vendor or auction cost of an item depending on which is available
local function GetCostByItemID(itemID, multiplier)
  local vendorPrice = Auctionator.API.v1.GetVendorPriceByItemID(AUCTIONATOR_L_REAGENT_SEARCH, itemID)
  local auctionPrice = Auctionator.API.v1.GetAuctionPriceByItemID(AUCTIONATOR_L_REAGENT_SEARCH, itemID)

  local unitPrice = vendorPrice or auctionPrice

  if unitPrice ~= nil then
    return multiplier * unitPrice
  end
  return 0
end

local function GetByMinCostOption(reagents, multiplier)
  local min = 0
  for _, entry in ipairs(reagents) do
    local newValue = GetCostByItemID(entry.itemID, multiplier)
    if newValue ~= 0 and (min == 0 or newValue < min) then
      min = newValue
    end
  end
  return min
end

-- Go through all allocated reagents and get the total auction value of them
local function GetAllocatedCosts(reagentSlotSchematic, slotAllocations)
  local total = 0
  for _, reagent in ipairs(reagentSlotSchematic.reagents) do
    local itemID = reagent.itemID
    if itemID ~= nil then
      local multiplier
      local allocation = slotAllocations:FindAllocationByReagent(reagent)
      if allocation == nil then
        multiplier = 0
      else
        multiplier = allocation:GetQuantity()
      end
      total = total + GetCostByItemID(itemID, multiplier)
    end
  end
  return total
end

function Auctionator.CraftingInfo.CalculateCraftCost(recipeSchematic, transaction)
  local total = 0

  for slotIndex, reagentSlotSchematic in ipairs(recipeSchematic.reagentSlotSchematics) do
    if #reagentSlotSchematic.reagents > 0 then
      local selected = 0
      local slotAllocations = transaction:GetAllocations(slotIndex)
      -- Sometimes allocations may be missing, so check they exist
      if slotAllocations ~= nil then
        selected = slotAllocations:Accumulate()
        -- Select the value of the allocated reagents only including optional ones
        total = total + GetAllocatedCosts(reagentSlotSchematic, slotAllocations)
      end
      -- Calculate using the lowest quality for remaining mandatatory reagents
      -- that aren't allocated
      if reagentSlotSchematic.reagentType == Enum.CraftingReagentType.Basic and selected ~= reagentSlotSchematic.quantityRequired then
        total = total + GetByMinCostOption(reagentSlotSchematic.reagents, reagentSlotSchematic.quantityRequired - selected)
      end
    end
  end

  return total
end

-- Work around Blizzard APIs returning the wrong item ID for crafted reagents in
-- the C_TradeSKillUI.GetRecipeOutputItemData function with Dragonflight
function Auctionator.CraftingInfo.GetOutputItemLink(recipeID, recipeLevel, reagents, allocations)
  local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false, recipeLevel)

  local outputInfo = C_TradeSkillUI.GetRecipeOutputItemData(recipeID, reagents, allocations)

  -- Use the operation and recipe info to override the expected output of a
  -- craftable reagent
  -- Check that the recipe probably has an operation
  if recipeSchematic ~= nil and recipeSchematic.hasCraftingOperationInfo then
    local operationInfo = C_TradeSkillUI.GetCraftingOperationInfo(recipeID, reagents, allocations)

    if operationInfo ~= nil then
      outputInfo = C_TradeSkillUI.GetRecipeOutputItemData(recipeID, reagents, allocations, operationInfo.guaranteedCraftingQualityID)
    end
  end

  if outputInfo == nil then
    return nil
  end

  return outputInfo.hyperlink
end
