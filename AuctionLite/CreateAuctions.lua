-------------------------------------------------------------------------------
-- CreateAuctions.lua
--
-- Create a group of auctions based on input in the "Sell" tab.
-------------------------------------------------------------------------------

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

-- Flag indicating whether we're currently posting auctions.
local Selling = false;
local MultisellCreated = 0;
local MultisellDone = false;
local MultisellError = false;

-- Current coroutine.
local Coro = nil;

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

-- Count the number of items matching the link (ignoring uniqueId).
function AuctionLite:CountItems(targetLink)
  local total = 0;

  if targetLink ~= nil then
    local i, j;
    for i = 0, 4 do
      local numItems = GetContainerNumSlots(i);
      for j = 1, numItems do
        local link = self:RemoveUniqueId(GetContainerItemLink(i, j));
        if link == targetLink then
          local _, count = GetContainerItemInfo(i, j);
          total = total + count;
        end
      end
    end

    -- Battle pets can only be sold one at a time, so cap this count at one.
    if total > 0 and self:IsBattlePetLink(targetLink) then
      total = 1;
    end
  end

  return total;
end

-- Find item in bags.
function AuctionLite:FindItem(targetLink)
  local total = 0;

  if targetLink ~= nil then
    local i, j;
    for i = 0, 4 do
      local numItems = GetContainerNumSlots(i);
      for j = 1, numItems do
        local link = self:RemoveUniqueId(GetContainerItemLink(i, j));
        if link == targetLink then
          return i, j;
        end
      end
    end
  end

  return nil;
end

-------------------------------------------------------------------------------
-- Auction creation
-------------------------------------------------------------------------------

-- Start the auctions and print a message to the console.
function AuctionLite:StartAuctions(bid, buyout, time, size, stacks, name, link)
  -- Make sure the item is present.
  if GetAuctionSellItemInfo() == nil then
    local container, slot = self:FindItem(link);
    if container ~= nil then
      ClearCursor();
      PickupContainerItem(container, slot);
      ClickAuctionSellItemButton();
    end
  end

  -- Check again, just to be sure.
  if GetAuctionSellItemInfo() ~= nil then
    -- Grab our initial state.
    local count = self:CountItems(link);

    MultisellCreated = 0;
    MultisellDone = false;
    MultisellError = false;

    -- Start the new auction, ignoring console spam.
    PostAuction(bid, buyout, time, size, stacks);
    self:IgnoreMessage(ERR_AUCTION_STARTED, stacks);

    -- If it's a multisell, wait for it to complete.  Note that we might
    -- sell fewer items than originally requested if the user cancels.
    if stacks > 1 then
      self:WaitForMultisell();
      stacks = MultisellCreated;
    end

    -- Now wait for the inventory to be updated so that CountItems doesn't
    -- get confused later.
    self:WaitForQuantity(link, count - (size * stacks));

    -- And tell the user what we did.
    self:Print(L["Created %d |4auction:auctions; of %s x%d (%s total)."]:
               format(stacks, name, size, self:PrintMoney(stacks * buyout)));
  end
end

-- Create new auctions based on the fields in the "Sell" tab.
function AuctionLite:CreateAuctionsCore()
  -- TODO: check stack size against max size

  if not Selling then
    Selling = true;

    local name, _, count, _, _, _, link, sellContainer, sellSlot =
      self:GetAuctionSellItemInfoAndLink();

    local stacks = SellStacks:GetNumber();
    local size = SellSize:GetNumber();

    local bid = MoneyInputFrame_GetCopper(SellBidPrice);
    local buyout = MoneyInputFrame_GetCopper(SellBuyoutPrice);
    local time = self:GetDuration();

    local numItems = self:CountItems(link);
    local maxSize = self:GetMaxStackSize(link);

    -- If we're pricing per item, then get the stack price.
    if self.db.profile.method == 1 then
      bid = bid * size;
      buyout = buyout * size;
    end

    -- Now do some sanity checks.
    if name == nil then
      self:Print(L["Error locating item in bags.  Please try again!"]);
    elseif bid == 0 then
      self:Print(L["Invalid starting bid."]);
    elseif 0 < buyout and buyout < bid then
      self:Print(L["Buyout cannot be less than starting bid."]);
    elseif GetMoney() < self:CalculateDeposit() then
      self:Print(L["Not enough cash for deposit."]);
    elseif numItems < stacks * size then
      self:Print(L["Not enough items available."]);
    elseif maxSize < size then
      self:Print(L["Stack size too large."]);
    elseif count ~= nil and stacks > 0 then
      local created = 0;

      -- Disable the auction creation button.
      SellCreateAuctionButton:Disable();

      -- Sell the main batch of items.
      self:StartAuctions(bid, buyout, time, size, stacks, name, link);

      -- We're done; clear the frame.
      self:ClearSellFrame();
    end

    Selling = false;
  else
    self:Print(L["Auction creation is already in progress."]);
  end
end

-- Start a coroutine to create auctions.
function AuctionLite:CreateAuctions()
  self:StartCoroutine(function() AuctionLite:CreateAuctionsCore() end);
end

-------------------------------------------------------------------------------
-- Coroutine functions
-------------------------------------------------------------------------------

-- Yield until the number of items in the inventory drops below a threshold.
function AuctionLite:WaitForQuantity(link, qty)
  self:WaitUntil(function()
    local count = self:CountItems(link);
    return (count <= qty);
  end);
end

-- Yield until a multisell operation completes.
function AuctionLite:WaitForMultisell()
  self:WaitUntil(function()
    return MultisellDone;
  end);
end

-- Yield until a condition is true.
function AuctionLite:WaitUntil(cond)
  while not cond() do
    coroutine.yield();
  end
end

-- Start a coroutine to call the specified function.
function AuctionLite:StartCoroutine(fn)
  if Coro == nil then
    Coro = coroutine.create(fn);
    AuctionLite:ResumeCoroutine();
  end
end

-- Resume the stalled coroutine.
function AuctionLite:ResumeCoroutine()
  if Coro ~= nil and coroutine.status(Coro) == "suspended" then
    coroutine.resume(Coro)
    if coroutine.status(Coro) == "dead" then
      Coro = nil;
    end
  end
end

-------------------------------------------------------------------------------
-- Coroutine hooks
-------------------------------------------------------------------------------

function AuctionLite:BAG_UPDATE()
  self:ResumeCoroutine();
end

function AuctionLite:AUCTION_MULTISELL_UPDATE(_, cur, total)
  MultisellCreated = cur;
  if cur == total then
    MultisellDone = true;
    self:ResumeCoroutine();
  end
end

function AuctionLite:AUCTION_MULTISELL_FAILURE(_, cur, total)
  MultisellDone = true;
  MultisellError = true;
  self:ResumeCoroutine();
end

-- Add the hooks needed for our coroutines.
function AuctionLite:HookCoroutines()
  self:RegisterEvent("BAG_UPDATE");
  self:RegisterEvent("AUCTION_MULTISELL_UPDATE");
  self:RegisterEvent("AUCTION_MULTISELL_FAILURE");
end

-------------------------------------------------------------------------------
-- Miscellaneous
-------------------------------------------------------------------------------

-- Indicate whether we're creating auctions.
function AuctionLite:CreateInProgress()
  return Selling;
end

-- Reset state.  Useful for recovering from bugs.
function AuctionLite:ResetAuctionCreation()
  Selling = false;
  MultisellCreated = 0;
  MultisellDone = false;
  MultisellError = false;
  Coro = nil;
end
