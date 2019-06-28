-------------------------------------------------------------------------------
-- BuyFrame.lua
--
-- Implements the "Buy" tab.
-------------------------------------------------------------------------------

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

-- Constants for display elements.
local BUY_DISPLAY_SIZE = 15;
local ROW_HEIGHT = 21;
local EXPAND_ROWS = 4;

-- Various states for the buy frame.
local BUY_MODE_NONE        = 1;
local BUY_MODE_INTRO       = 2;
local BUY_MODE_SEARCH      = 3;
local BUY_MODE_SCAN        = 4;
local BUY_MODE_DEALS       = 5;
local BUY_MODE_FAVORITES   = 6;
local BUY_MODE_MY_AUCTIONS = 7;

-- Current state of the buy frame.
local BuyMode = BUY_MODE_NONE;

-- Current sorting state.
local SummarySort = {
  sort = "ItemSummary",
  flipped = false,
  justFlipped = false,
  sorted = false,
};
local DetailSort = {
  sort = "BuyoutEach",
  flipped = false,
  justFlipped = false,
  sorted = false,
};

-- Height of expandable frame.
local ExpandHeight = 0;

-- Data to be shown in detail view.
local DetailLink = nil;
local DetailData = {};
local SavedOffset = 0;

-- Save the last selected item.
local DetailLinkPrev = nil;

-- Selected item in detail view and index of last item clicked.
local SelectedItems = {};
local LastClick = nil;

-- Data to be shown in summary view.
local SummaryData = {};
local SummaryDataByLink = {};
local NoResults = false;

-- Info about current purchase for display in expandable frame.
local PurchaseOrder = nil;

-- Information about current search progress.
local StartTime = nil;
local LastTime = nil;
local LastRemaining = nil;
local Progress = nil;
local GetAll = nil;
local Scanning = nil;

-- Stored scan data from the latest full scan.
local ScanData = nil;

-- Links and data for multi-item scan.
local MultiScanCurrent = nil;
local MultiScanOriginal = {};
local MultiScanItems = {};
local MultiScanData = {};

-- Static popup advertising AL's fast scan.
StaticPopupDialogs["AL_FAST_SCAN"] = {
  text = L["FAST_SCAN_AD"],
  button1 = L["Enable"],
  button2 = L["Disable"],
  OnAccept = function(self)
    AuctionLite:Print(L["Fast auction scan enabled."]);
    AuctionLite.db.profile.fastScanAd2 = true;
    AuctionLite.db.profile.getAll = true;
    AuctionLite:StartFullScan();
  end,
  OnCancel = function(self)
    AuctionLite:Print(L["Fast auction scan disabled."]);
    AuctionLite.db.profile.fastScanAd2 = true;
    AuctionLite.db.profile.getAll = false;
    AuctionLite:StartFullScan();
  end,
  showAlert = 1,
  timeout = 0,
  exclusive = 1,
  hideOnEscape = 1,
  preferredIndex = 3
};

-- Static popup explaining cancel clicks.
StaticPopupDialogs["AL_CANCEL_NOTE"] = {
  text = L["CANCEL_NOTE"],
  button1 = OKAY,
  OnAccept = function(self)
    AuctionLite.db.profile.cancelNote = true;
  end,
  showAlert = 1,
  timeout = 0,
  exclusive = 1,
  hideOnEscape = 1,
  preferredIndex = 3
};

-- Set current item to be shown in detail view, and update dependent data.
function AuctionLite:SetDetailLink(link)
  -- If there's no data to show, then just set the link to nil.
  if link ~= nil and table.getn(SummaryDataByLink[link].data) == 0 then
    link = nil;
  end

  -- If we're leaving the summary view, save our offset.
  if DetailLink == nil then
    SavedOffset = FauxScrollFrame_GetOffset(BuyScrollFrame);
  end

  -- Set the new detail link, if any.
  DetailLink = link;

  local offset;
  if DetailLink ~= nil then
    DetailData = SummaryDataByLink[DetailLink].data;
    offset = 0;
  else
    DetailData = {};
    offset = SavedOffset;
  end

  DetailSort.sorted = false;

  -- Return to our saved offset.
  self:SetScrollFrameOffset(offset);

  SelectedItems = {};
  LastClick = nil;
end

-- Set the data for the scrolling frame.
function AuctionLite:SetBuyData(results)
  SummaryData = {};

  local count = 0;
  local last = nil;
  local foundPrev = false;

  -- Sort everything and assemble the summary data.
  for link, result in pairs(results) do
    table.insert(SummaryData, result);

    result.link = link;
    result.name = self:SplitLink(link);

    local hist = self:GetHistoricalPrice(link);
    if hist ~= nil then
      result.histPrice = hist.price;
    else
      result.histPrice = 0;
    end

    count = count + 1;
    last = link;

    if DetailLinkPrev == link then
      foundPrev = true;
    end
  end

  SummaryDataByLink = results;

  -- Sort our data by name/profit.
  if BuyMode == BUY_MODE_DEALS or
     BuyMode == BUY_MODE_SCAN then
    SummarySort.sort = "Historical";
    SummarySort.flipped = true;
  else
    SummarySort.sort = "ItemSummary";
    SummarySort.flipped = false;
  end

  SummarySort.sorted = false;
  SummarySort.justFlipped = false;

  -- Set up warning markers for undercuts.
  self:SetWarnings();

  -- If we found our last-selected item, then select it again.
  -- If we found only one item, select it.  Otherwise, select nothing.
  local newLink = nil;
  if foundPrev then
    newLink = DetailLinkPrev;
  elseif count == 1 then
    newLink = last;
  end
  DetailLinkPrev = nil;

  -- Reset current query info.
  self:ResetSearch();

  -- Save our data and set our detail link, if we only got one kind of item.
  SummaryDataByLink = results;
  NoResults = (count == 0);
  self:SetDetailLink(newLink);

  -- Clean up the display.
  BuyMessageText:Hide();
  BuyStatus:Hide();

  -- Start a mass buyout, if necessary.
  self:StartMassBuyout();

  -- Repaint.
  self:AuctionFrameBuy_Update();
end

-- Handle results for a full scan.  Make a list of the deals.
function AuctionLite:SetScanData(results)
  ScanData = {};

  -- Search through all scanned items.
  for link, result in pairs(results) do
    local hist = self:GetHistoricalPrice(link);

    -- Find the lowest buyout.
    local min = 0;
    for _, listing in ipairs(result.data) do
      if min == 0 or (0 < listing.buyout and listing.buyout < min) then
        min = listing.buyout;
      end
    end

    -- If it meets a bunch of conditions below, it's considered a deal.
    if min > 0 and hist ~= nil and
       min < hist.price - (10000 * self.db.profile.minProfit) and
       min < hist.price * (1 - self.db.profile.minDiscount) and
       hist.listings / hist.scans > 1.2 then

      result.profit = hist.price - min;
      ScanData[link] = result;
    end
  end

  -- Display our list of deals.
  DetailLinkPrev = nil;
  self:SetBuyData(ScanData, true);
end

-- Helper that finds user's listings.  Return value indicates whether we've
-- been undercut.  (If that's all you care about, omit the last three args.)
function AuctionLite:FindMyListings(listings, list, name, onlyUndercut)
  local listingsCopy = {};

  -- Make a copy of listings.
  for a, b in pairs(listings) do
    listingsCopy[a] = b;
  end

  -- Sort by per-item buyout price.
  table.sort(listingsCopy,
    function(a, b) return a.buyout / a.count < b.buyout / b.count end);

  -- Iterate over listings.
  local undercut = false;
  local foundOther = false;
  local listing;
  for _, listing in ipairs(listingsCopy) do
    if listing.buyout > 0 then
      if listing.owner == UnitName("player") then
        if foundOther then
          undercut = true;
          if list == nil then
            break;
          end
        end
        if list ~= nil then
          if foundOther or not onlyUndercut then
            listing.name = name;
            table.insert(list, listing);
          end
        end
      else
        foundOther = true;
      end
    end
  end

  return undercut;
end

-- Set undercut warnings for all auctions.
function AuctionLite:SetWarnings()
  if BuyMode == BUY_MODE_MY_AUCTIONS then
    for link, result in pairs(SummaryDataByLink) do
      -- Sort by per-item buyout price.
      table.sort(result.data,
        function(a, b) return a.buyout / a.count < b.buyout / b.count end);

      -- Invalidate the current sort.
      DetailSort.sorted = false;

      -- Find the first listing with non-zero buyout.  If it's not ours,
      -- we've been undercut.
      result.warning = self:FindMyListings(result.data);
    end
  end
end

-- Determine whether the selected items are biddable/buyable.
function AuctionLite:GetSelectionStatus()
  local biddable = true;
  local buyable = true;
  local cancellable = true;
  local found = false;

  -- Helper to determine whether we have any listings.
  local findMine = function(data)
    for _, listing in ipairs(data) do
      if listing.owner == UnitName("player") then
        return true;
      end
    end
    return false;
  end

  if DetailLink ~= nil then
    -- Check all selected items.
    for listing, _ in pairs(SelectedItems) do
      -- We can't bid/buy our own auctions.
      if listing.owner == UnitName("player") then
        biddable = false;
        buyable = false;
      else
        cancellable = false;
      end
      -- To buy, we must have a buyout price listed.
      if listing.buyout == 0 then
        buyable = false;
      end
      -- We must find at least one selected item.
      found = true;
    end

    -- Nothing's selected, so check all items.
    if not found then
      cancellable = findMine(DetailData);
    end
  elseif SummaryDataByLink ~= nil then
    -- We're at the summary screen, so check all items.
    cancellable = false;
    for link, result in pairs(SummaryDataByLink) do
      if findMine(result.data) then
        cancellable = true;
        break;
      end
    end
  else
    cancellable = false;
  end

  return (found and biddable), (found and buyable), cancellable;
end

-- Cancel the selected items.
function AuctionLite:CancelItems(onlyUndercut, link)
  -- List of items to be cancelled.
  local list = {};

  -- If we didn't specify data, try using DetailData.
  if link == nil then
    link = DetailLink;
  end

  -- Now find the items to cancel.
  if link ~= nil then
    local data = SummaryDataByLink[link].data;
    local name = self:SplitLink(link);

    -- Add information about each selected item.
    local i;
    for listing, _ in pairs(SelectedItems) do
      assert(listing.owner == UnitName("player"));
      listing.name = name;
      table.insert(list, listing);
    end

    -- If we don't have any selected items, cancel all.
    if table.getn(list) == 0 then
      self:FindMyListings(data, list, name, onlyUndercut);
    end
  else
    -- We're at the summary screen, so do this for all items.
    for link, result in pairs(SummaryDataByLink) do
      local name = self:SplitLink(link);
      self:FindMyListings(result.data, list, name, onlyUndercut);
    end
  end

  -- If we found some items to cancel, do it.
  if table.getn(list) > 0 then
    self:CancelAuctions(list);
  end
end

-- Update the display now that we've finished cancelling.
function AuctionLite:CancelComplete()
  -- Go through all listings and remove the ones that were cancelled.
  for link, summary in pairs(SummaryDataByLink) do
    local data = summary.data;
    local i = table.getn(data);
    while i > 0 do
      local listing = data[i];
      if listing.cancelled then
        table.remove(data, i);
        summary.itemsAll = summary.itemsAll - listing.count;
        summary.itemsMine = summary.itemsMine - listing.count;
        summary.listingsAll = summary.listingsAll - 1;
        summary.listingsMine = summary.listingsMine - 1;
        SelectedItems[listing] = nil;
      end
      i = i - 1;
    end
  end

  -- Reevaluate "warning" status.
  self:SetWarnings();

  -- Cleanup.
  if table.getn(DetailData) == 0 then
    self:SetDetailLink(nil);
  end

  -- Update the display.
  self:AuctionFrameBuy_Update();
end

-- Called after a search query ends in order to start a mass buyout.
function AuctionLite:StartMassBuyout()
  -- See if the user requested a specific quantity.
  local requested = BuyQuantity:GetNumber();
  if DetailLink ~= nil and table.getn(DetailData) > 0 and requested > 0 then
    -- Clear our selected items.  (Should already be done, but what the hey.)
    SelectedItems = {};

    -- Make a list of all items from other sellers with nonzero buyout.
    -- Also figure out how many items we have available in all.
    local available = {};
    local cheapest = nil;
    local cheapestOwned = nil;
    local total = 0;
    local listing;
    for _, listing in ipairs(DetailData) do
      if listing.buyout > 0 then
        local price = listing.buyout / listing.count;
        if listing.owner == UnitName("player") then
          -- Remember the cheapest auction that we own.
          if cheapestOwned == nil or price < cheapestOwned then
            cheapestOwned = price;
          end
        else
          -- Remember the cheapest auction that we don't own.
          if cheapest == nil or price < cheapest then
            cheapest = price;
          end
          -- Keep track of all other auctions with buyouts.
          table.insert(available, listing);
          total = total + listing.count;
        end
      end
    end

    -- Are there enough items for sale to satisfy the request?
    if total <= requested then
      -- Nope.  Just take everything we can.
      local listing;
      for _, listing in ipairs(available) do
        SelectedItems[listing] = true;
      end
    else
      -- Yep.  So now we have to figure out what to buy.  We use an
      -- adaptation of the standard dynamic programming algorithm for
      -- 0-1 knapsack.

      -- The state for this algorithm is as follows:
      --   results: For any n, what's the best price we can get for exactly
      --            n items, and what listings do we have to buy to do so?
      --   indices: A list of valid indices for results, in descending order.
      -- We initialize these with 0, our base case.
      local results = { [0] = { price = 0 } };
      local indices = { 0 };

      -- Determine the maximum number of items we want to consider buying.
      -- This is the number requested plus the maximum stack size available
      -- in the AH.  We don't need to consider anything large than this,
      -- because if we could fill the user's order for a larger count, then
      -- we must be able to remove one listing to fill the user's order for
      -- less money overall.
      local maxCount = 0;
      local listing;
      for _, listing in ipairs(available) do
        if listing.count > maxCount then
          maxCount = listing.count;
        end
      end
      maxCount = maxCount + requested;

      -- Sort by count, which improves the speed of the algorithm below.
      table.sort(available, function(a, b) return a.count > b.count end);

      -- Save our start time.
      local start = time();

      -- Consider each listing in turn.  At each step, the results table
      -- will have the best results for the set of listings we've considered
      -- so far.
      local timeout = false;
      local listing;
      for _, listing in ipairs(available) do
        -- If we've taken more than 1-2 seconds, bail.
        if start + 1 < time() then
          timeout = true;
          break;
        end
        -- Iterate over all counts where we have results so far, in
        -- descending order so that we can update in place.
        local count;
        for _, count in ipairs(indices) do
          local info = results[count];
          local newCount = count + listing.count;
          assert(info ~= nil);
          -- Add this listing to the best result at this stack size.
          -- Do we care about the resulting set of items?
          if newCount < maxCount then
            -- If this is the first option at this new stack size, or if it's
            -- cheaper than our previous best effort, update the data.
            local newInfo = results[newCount];
            local newPrice = info.price + listing.buyout;
            if newInfo == nil or newPrice < newInfo.price then
              -- The new data consists of the current result's listings plus
              -- the listing we just added.
              results[newCount] = {
                price = newPrice,
                listing = listing,
                info = info,
              };
            end
            -- If we added a new index to the results table, add it to our
            -- list of indices too, and make sure it's still sorted.
            if newInfo == nil then
              table.insert(indices, newCount);
              table.sort(indices, function(a, b) return a > b end);
            end
          end
        end
      end

      if timeout then
        -- We hit a timeout, so just do things the fast way.
        -- First sort by per-item buyout.
        local sort = function(a, b)
          return a.buyout / a.count < b.buyout / b.count;
        end
        table.sort(available, sort);

        -- Get the cheapest items until the order is filled.
        local selected = {};
        local count = 0;
        local i = 1;
        while i < table.getn(available) and count < requested do
          local listing = available[i];
          table.insert(selected, listing);
          count = count + listing.count;
          i = i + 1;
        end

        -- Go over the selected items in reverse order and remove any
        -- that aren't actually necessary.
        local i = table.getn(selected);
        while i > 0 do
          local listing = selected[i];
          if count - listing.count >= requested then
            table.remove(selected, i);
            count = count - listing.count;
          end
          i = i - 1;
        end

        -- Update the selected items list as appropriate.
        local listing;
        for _, listing in ipairs(selected) do
          SelectedItems[listing] = true;
        end
      else
        -- We've computed our best options for all stack sizes.

        -- Figure out the resale value for this item.  We use the lesser
        -- of the cheapest price and the historical price.
        local resale = cheapest - 1;
        local hist = self:GetHistoricalPrice(DetailLink);
        if hist ~= nil and hist.price > 0 and hist.price < resale then
          resale = hist.price;
        end

        -- Now find the cheapest way to buy the requested number of items.
        local bestCount = nil;
        local bestInfo = nil;
        local count;
        local info;
        for count, info in pairs(results) do
          if count >= requested then
            -- If the user wants us to, adjust for resale price.
            if self.db.profile.considerResale then
              info.price = info.price - (resale * (count - requested));
            end
            -- Is this the best option we've seen?
            if bestInfo == nil or info.price < bestInfo.price or
               (info.price == bestInfo.price and count > bestCount) then
              bestCount = count;
              bestInfo = info;
            end
          end
        end

        -- Update SelectedItems with the final results.  We should always
        -- find a result here, but we'll be defensive anyway.
        while bestInfo ~= nil and bestInfo.listing ~= nil do
          SelectedItems[bestInfo.listing] = true;
          bestInfo = bestInfo.info;
        end
      end

      -- Sort by selectedness in order to pull selected items to the
      -- top, and mark the list as unsorted so that they will be sorted
      -- properly (and stably) on the next update.
      local sort = function(a, b)
        return SelectedItems[b] and not SelectedItems[a];
      end
      table.sort(DetailData, sort);
      DetailSort.sorted = false;
    end

    -- Do we have any listings for this item?
    if cheapestOwned ~= nil then
      -- Find the worst price we're paying.
      local worstBought = nil;
      local listing;
      for listing, _ in pairs(SelectedItems) do
        local price = listing.buyout / listing.count;
        if worstBought == nil or worstBought < price then
          worstBought = price;
        end
      end

      -- If it's above the price for our cheapest listing, warn the user.
      if cheapestOwned < worstBought then
        self:Print(L["|cffff0000[Warning]|r Skipping your own auctions.  " ..
                     "You might want to cancel them instead."]);
      end
    end

    -- Now create our buyout order.
    self:CreateOrder(true, requested);
  end
end

-- Create a purchase order based on the current selection.  The first
-- argument indicates whether we're bidding or buying, and the second
-- argument (optional) indicates the actual number of items the user wants.
function AuctionLite:CreateOrder(isBuyout, requested)
  if DetailLink ~= nil then
    -- Create purchase order object to be filled out.
    local order = { list = {}, name = self:SplitLink(DetailLink),
                    price = 0, spent = 0, count = 0, isBuyout = isBuyout,
                    itemsBought = 0, listingsBought = 0,
                    itemsNotFound = 0, listingsNotFound = 0 };

    -- Add information about each selected item.
    local i;
    for listing, _ in pairs(SelectedItems) do
      assert(listing.owner ~= UnitName("player"));

      local price;
      if isBuyout then
        price = listing.buyout;
      else
        price = listing.bid;
      end

      table.insert(order.list, listing);
      order.count = order.count + listing.count;
      order.price = order.price + price;
    end

    -- If we found any selected items and we have enough money, proceed.
    if order.price > GetMoney() then
      self:Print(L["|cffff0000[Error]|r Insufficient funds."]);
    elseif order.count > 0 then
      -- If the second argument wasn't specified, the user wants exactly
      -- the number of items selected.
      if requested == nil then
        requested = order.count;
      end

      -- If we overshot, figure out how much we can resell the excess for.
      if order.count > requested then
        order.resell = order.count - requested;

        local price = SummaryDataByLink[DetailLink].price;
        order.resellPrice = math.floor(order.resell * price);

        order.netPrice = order.price - order.resellPrice;
      end

      -- Get a historical comparison.
      local hist = self:GetHistoricalPrice(DetailLink);
      if hist ~= nil then
        order.histPrice = math.floor(requested * hist.price);
      else
        order.histPrice = 0;
      end

      -- Save the purchase order and start buying.
      PurchaseOrder = order;
      self:ContinuePurchase();
    end
  end
end

-- Place an order for the next item in line.
function AuctionLite:ContinuePurchase()
  local order = PurchaseOrder;
  if order ~= nil then
    assert(order.current == nil);

    local n = table.getn(order.list);
    if n > 0 then
      -- Find the first item to purchase in the current detail list.
      -- TODO: Make this more efficient by just sorting order.list.
      self:ApplyDetailSort();
      local index = nil;
      local i;
      local displayListing;
      for _, displayListing in ipairs(DetailData) do
        local purchaseListing;
        for i, purchaseListing in ipairs(order.list) do
          if displayListing == purchaseListing then
            index = i;
            break;
          end
        end
        if index ~= nil then
          break;
        end
      end

      -- The purchase items should be a subset of the main listing.
      assert(index ~= nil);

      order.current = table.remove(order.list, index);

      local query = {
        name = order.name,
        wait = true,
        exact = true,
        listing = order.current,
        isBuyout = order.isBuyout,
        finish = function(cancelled)
          AuctionLite:PurchaseComplete(cancelled);
        end,
      };

      -- TODO: Make this work.
      -- self:ScrollToListing(order.current);

      -- TODO: What if this returns false?
      self:StartQuery(query);
    else
      self:EndPurchase();
    end
  end
end

-- Finish a purchase; show the result and clean up.
function AuctionLite:EndPurchase(cancelled)
  assert(PurchaseOrder ~= nil);
  assert(PurchaseOrder.current == nil);

  local order = PurchaseOrder;

  -- Tally up remaining items.
  local listing;
  for _, listing in ipairs(order.list) do
    self:UpdatePurchaseStats(listing);
  end

  -- Print a summary.
  if not cancelled or order.listingsBought > 0 then
    if order.isBuyout then
      self:Print(L["Bought %dx %s (%d |4listing:listings; at %s)."]:
                 format(order.itemsBought, order.name, order.listingsBought,
                        self:PrintMoney(order.spent)));
    else
      self:Print(L["Bid on %dx %s (%d |4listing:listings; at %s)."]:
                 format(order.itemsBought, order.name, order.listingsBought,
                        self:PrintMoney(order.spent)));
    end

    if order.itemsNotFound > 0 then
      self:Print(L["Note: %d |4listing:listings; of %d |4item was:items were; not purchased."]:
                 format(order.listingsNotFound, order.itemsNotFound));
    end
  end

  PurchaseOrder = nil;
end

-- The query system needs us to approve purchases.
function AuctionLite:RequestApproval()
  -- Mark ourselves as waiting for approval.
  if PurchaseOrder ~= nil and PurchaseOrder.current ~= nil then
    PurchaseOrder.needsApproval = true;
  end

  -- Update the display.
  self:AuctionFrameBuy_Update();
end

-- The query system no longer needs approval.
function AuctionLite:CancelRequestApproval()
  -- Mark ourselves as not waiting for approval.
  if PurchaseOrder ~= nil then
    PurchaseOrder.needsApproval = nil;
  end

  -- Update the display.
  self:AuctionFrameBuy_Update();
end

-- Update purchase stats for an item.
function AuctionLite:UpdatePurchaseStats(listing)
  local order = PurchaseOrder;
  if order ~= nil then
    if listing.purchased then
      order.itemsBought = order.itemsBought + listing.count;
      order.listingsBought = order.listingsBought + 1;
      if order.isBuyout then
        order.spent = order.spent + listing.buyout;
      else
        order.spent = order.spent + listing.bid;
      end
    else
      order.itemsNotFound = order.itemsNotFound + listing.count;
      order.listingsNotFound = order.listingsNotFound + 1;
    end
  end
end

-- Notification that a purchase has completed.
function AuctionLite:PurchaseComplete(cancelled)
  local order = PurchaseOrder;

  -- Update the purchase order.
  if order ~= nil then
    -- Update our current purchase.
    if order.current ~= nil then
      self:UpdatePurchaseStats(order.current);
      order.current = nil;
    end

    -- Update our display according to the purchase.
    -- TODO: Make this more efficient, now that we only buy one item at a time.
    if DetailLink ~= nil then
      local summary = SummaryDataByLink[DetailLink];
      local i = table.getn(DetailData);
      while i > 0 do
        local listing = DetailData[i];
        if listing.purchased then
          if PurchaseOrder.isBuyout then
            -- If we bought an item, remove it.
            table.remove(DetailData, i);
            summary.itemsAll = summary.itemsAll - listing.count;
            summary.listingsAll = summary.listingsAll - 1;
            SelectedItems[listing] = nil;
          else
            -- If we bid on an item, update the minimum bid.
            local increment = math.floor(listing.bid / 100) * 5;
            listing.purchased = false;
            listing.bidder = 1;
            listing.bid = listing.bid + increment;
            if listing.bid > listing.buyout and listing.buyout > 0 then
              listing.bid = listing.buyout;
            end
          end
        end
        i = i - 1;
      end

      if table.getn(DetailData) == 0 then
        self:SetDetailLink(nil);
      end
    end

    -- Continue with further purchases if relevant.
    if not cancelled then
      self:ContinuePurchase();
    else
      self:EndPurchase(true);
    end
  end

  -- Update the display.
  self:AuctionFrameBuy_Update();
end

-- Update search progress display.
function AuctionLite:UpdateProgressSearch(pct, getAll, scan)
  -- If we got a progress update, record it.
  if pct ~= nil then
    Progress = pct;
  end

  -- Record a start time if we don't have one already.
  if StartTime == nil then
    StartTime = math.floor(time());
  end

  -- Figure out whether we're actually doing getAll and/or scanning.
  if GetAll == nil and getAll ~= nil then
    GetAll = getAll;
  end
  if Scanning == nil and scan ~= nil then
    Scanning = scan;
  end

  -- Update the display every second.
  local currentTime = math.floor(time());
  if LastTime == nil or currentTime > LastTime then
    LastTime = currentTime;

    -- If we have some data, compute the time remaining.
    local elapsed = currentTime - StartTime;
    if elapsed > 0 and Progress > 0 then
      -- In order to reduce jitter in the estimate, do the following:
      -- 1. Update once every two seconds at first.
      -- 2. Average each estimate with the previous one.
      -- 3. Ignore estimates that exceed the previous by less than 10%.
      if Progress > 15 or (elapsed % 2) == 0 then
        local remaining = math.floor((100 * elapsed / Progress) - elapsed);

        if LastRemaining ~= nil then
          remaining = math.floor((remaining + LastRemaining) / 2);

          if remaining > LastRemaining and remaining < LastRemaining * 1.1 then
            remaining = LastRemaining;
          end
        end

        LastRemaining = remaining;

        BuyRemainingData:SetText(self:PrintTime(remaining));
      end
    else
      BuyRemainingData:SetText("---");
    end

    -- Update the percentage.
    if GetAll then
      BuyStatusText:SetText(L["Scanning..."]);
      BuyStatusData:SetText("");
    else
      if Scanning then
        BuyStatusText:SetText(L["Scanning:"]);
      else
        BuyStatusText:SetText(L["Searching:"]);
      end
      BuyStatusData:SetText(tostring(Progress) .. "%");
    end

    -- Update the elapsed time and show the whole pane.
    BuyElapsedData:SetText(self:PrintTime(elapsed));
    BuyStatus:Show();
  end
end

-- Show our progress for the favorites scan.  We assume each scan takes
-- roughly the same amount of time, and then split each segment accordingly.
function AuctionLite:UpdateProgressMulti(pct)
  local numDone = 0;
  for _, _ in pairs(MultiScanData) do
    numDone = numDone + 1;
  end

  local numItems = 0;
  for _, _ in pairs(MultiScanItems) do
    numItems = numItems + 1;
  end

  local overall = math.floor(((100 * numDone) + pct) / numItems);
  self:UpdateProgressSearch(overall);
end

-- Take the next step in a multi-item scan.  If we need to scan for another
-- item, do it; if there are no items left, display our results.
function AuctionLite:MultiScan(items)
  -- Are we starting a new multi-item scan?
  local first = false;
  if items ~= nil then
    MultiScanOriginal = items;
    MultiScanItems = {};
    MultiScanData = {};
    for item, _ in pairs(items) do
      MultiScanItems[item] = true;
    end
    first = true;
  end

  -- Find an unscanned favorite.
  MultiScanCurrent = nil;
  local item;
  for item, _ in pairs(MultiScanItems) do
    if MultiScanItems[item] then
      MultiScanCurrent = item;
      break;
    end
  end

  if MultiScanCurrent ~= nil then
    -- Start the scan.
    local query = {
      wait = true,
      exact = true,
      update = function(pct) AuctionLite:UpdateProgressMulti(pct) end,
      finish = function(data) AuctionLite:SetMultiScanData(data) end,
    };

    if self:IsLink(MultiScanCurrent) then
      query.link = MultiScanCurrent;
    else
      query.name = MultiScanCurrent;
    end

    if self:StartQuery(query) and first then
      DetailLinkPrev = nil;
      self:ClearBuyFrame(true);
    end
  else
    -- Show our results.
    self:SetBuyData(MultiScanData);
    MultiScanData = {};
  end
end

-- Get the results for a multi-item scan.
function AuctionLite:SetMultiScanData(data)
  -- Gather all relevant results returned by the search.
  local found = false;
  for link, results in pairs(data) do
    local item = self:IsFavorite(link, MultiScanItems);

    if item then
      -- We were looking for this one.  Save the data and mark it as found.
      MultiScanItems[link] = false;
      MultiScanItems[item] = false;
      MultiScanData[link] = results;

      -- We now have a link to use, so swap it in if we just had a name before.
      if MultiScanOriginal[item] then
        MultiScanOriginal[item] = nil;
        MultiScanOriginal[link] = true;
      end
    end

    -- Did we find the actual search term?
    if MultiScanCurrent == link or MultiScanCurrent == item then
      found = true;
    end
  end

  -- We didn't find the item we were looking for, so add a fake entry to
  -- the list so that it shows up with zero results.
  if not found then
    local link;
    if self:IsLink(MultiScanCurrent) then
      link = MultiScanCurrent;
    else
      link = "|cffffffff|Hitem:0:0:0:0:0:0:0:0|h[" ..
             MultiScanCurrent ..
             "]|h|r";
    end

    MultiScanItems[MultiScanCurrent] = false;
    MultiScanData[link] = {
      link = link,
      data = {},
      price = 0,
      itemsAll = 0,
      itemsMine = 0,
      listingsAll = 0,
      listingsMine = 0,
    };
  end

  -- Continue the scan.
  self:MultiScan();
end

-- Sort the detail view.
function AuctionLite:ApplyDetailSort()
  local info = DetailSort;
  local data = DetailData;

  local cmp;
  if info.sort == "Item" then
    cmp = function(a, b) return a.count < b.count end;
  elseif info.sort == "BidEach" then
    cmp = function(a, b) return a.bid / a.count < b.bid / b.count end;
  elseif info.sort == "BidAll" then
    cmp = function(a, b) return a.bid < b.bid end;
  elseif info.sort == "BuyoutEach" then
    cmp = function(a, b) return (a.buyout == 0 and math.huge or a.buyout) / a.count < (b.buyout == 0 and math.huge or b.buyout) / b.count end; --warbaby put items without buyout to last
  elseif info.sort == "BuyoutAll" then
    cmp = function(a, b) return (a.buyout == 0 and math.huge or a.buyout) < (b.buyout == 0 and math.huge or b.buyout) end; --warbaby
  else
    assert(false);
  end

  self:ApplySort(info, data, cmp);
end

-- Sort the summary view.
function AuctionLite:ApplySummarySort()
  local info = SummarySort;
  local data = SummaryData;

  local cmp;
  if info.sort == "ItemSummary" then
    cmp = function(a, b)
      local aFav = (self:IsFavorite(a.link) ~= nil);
      local bFav = (self:IsFavorite(b.link) ~= nil);
      if aFav == bFav then
        return a.name < b.name;
      else
        return aFav;
      end
    end
  elseif info.sort == "Listings" then
    cmp = function(a, b) return a.listingsAll < b.listingsAll end;
  elseif info.sort == "Items" then
    cmp = function(a, b) return a.itemsAll < b.itemsAll end;
  elseif info.sort == "Market" then
    cmp = function(a, b) return a.price < b.price end;
  elseif info.sort == "Historical" then
    if BuyMode == BUY_MODE_DEALS or
       BuyMode == BUY_MODE_SCAN then
      cmp = function(a, b) return a.profit < b.profit end;
    else
      cmp = function(a, b) return a.histPrice < b.histPrice end;
    end
  else
    assert(false);
  end

  self:ApplySort(info, data, cmp);
end

-- Set a new sort type for the detail view.
function AuctionLite:DetailSortButton_OnClick(sort)
  assert(sort == "Item" or sort == "BidEach" or sort == "BidAll" or
         sort == "BuyoutEach" or sort == "BuyoutAll");

  self:SortButton_OnClick(DetailSort, sort);
  self:AuctionFrameBuy_Update();
end

-- Set a new sort type for the summary view.
function AuctionLite:SummarySortButton_OnClick(sort)
  assert(sort == "ItemSummary" or sort == "Listings" or sort == "Items" or
         sort == "Market" or sort == "Historical");

  self:SortButton_OnClick(SummarySort, sort);
  self:AuctionFrameBuy_Update();
end

-- Return a sorted list of favorites list names.
function AuctionLite:GetFavoritesLists()
  local names = {};

  for name, list in pairs(self.db.profile.favorites) do
    table.insert(names, name);
  end
  table.sort(names);

  return names;
end

-- Toggle the favorites flag for this item.
function AuctionLite:FavoritesButton_OnClick(id)
  local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);
  local link = SummaryData[offset + id].link;

  local toggle = function(list)
    -- Pop open any fake links.
    local item;
    local name, _, id = self:SplitLink(link);
    if id == 0 then
      item = name;
    else
      item = link;
    end

    -- Toggle the favorite.
    if list[item] == nil then
      list[item] = true;
    else
      list[item] = nil;
    end
    self:AuctionFrameBuy_Update();
  end

  local single = self:GetSingleFavoritesList();
  if single ~= nil then
    -- Just toggle the list.
    toggle(single);
  else
    -- Make a more detailed menu showing the available lists.
    if BuyFavoritesDropDown == nil then
      CreateFrame("Frame", "BuyFavoritesDropDown", UIParent,
                  "UIDropDownMenuTemplate");
    end

    BuyFavoritesDropDown.displayMode = "MENU";
    BuyFavoritesDropDown.initialize = function(menu)
      local info = UIDropDownMenu_CreateInfo();
      info.text = L["Member Of"];
      info.isTitle = true;
      UIDropDownMenu_AddButton(info);

      for _, name in ipairs(self:GetFavoritesLists()) do
        local list = self.db.profile.favorites[name];
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.func = function() toggle(list) end;
        info.checked = (self:IsFavorite(link, list) ~= nil);
        UIDropDownMenu_AddButton(info);
      end
    end

    ToggleDropDownMenu(1, nil, BuyFavoritesDropDown, "cursor");
  end
end

-- Handles clicks on the buttons in the "Buy" scroll frame.
function AuctionLite:BuyButton_OnClick(id, button)
  if button == "LeftButton" then
    local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);

    if DetailLink ~= nil then
      -- We're in detail view, so select the item.

      -- Unless we're holding control, this is a new selection.
      if not IsControlKeyDown() then
        SelectedItems = {};
      end

      if LastClick ~= nil and IsShiftKeyDown() then
        -- Shift is down and we have a previous click.
        -- Add all items in this range to the selection.
        local lower = offset + id;
        local upper = offset + id;

        if LastClick < offset + id then
          lower = LastClick;
        else
          upper = LastClick;
        end

        local i;
        for i = lower, upper do
          SelectedItems[DetailData[i]] = true;
        end
      else
        -- No shift, or first click; add only the current item to the selection.
        -- If control is down, toggle the item.
        LastClick = offset + id;

        local listing = DetailData[offset + id];
        if IsControlKeyDown() and SelectedItems[listing] then
          SelectedItems[listing] = nil;
        else
          SelectedItems[listing] = true;
        end
      end
    else
      -- We're in summary view, so switch to detail view.
      self:SetDetailLink(SummaryData[offset + id].link);
      self:StartMassBuyout();
    end

    self:AuctionFrameBuy_Update();
  elseif button == "RightButton" then
    local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);

    if DetailLink == nil then
      local link = SummaryData[offset + id].link;
      local menuList = {
        {
          text = L["Cancel Undercut Auctions"],
          func = function() AuctionLite:CancelItems(true, link) end,
        },
        {
          text = L["Cancel All Auctions"],
          func = function() AuctionLite:CancelItems(false, link) end,
        },
      };

      if BuyContextDropDown == nil then
        CreateFrame("Frame", "BuyContextDropDown", UIParent,
                    "UIDropDownMenuTemplate");
      end

      EasyMenu(menuList, BuyContextDropDown, "cursor", 0, 0, "MENU");
    end
  end
end

-- Mouse has entered a row in the scrolling frame.
function AuctionLite:BuyButton_OnEnter(widget)
  -- Get our index into the current display data.
  local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);
  local id = widget:GetID();

  -- Get a link and count for the item we're currently hovering over.
  -- The "shift" is used to move the tooltip to the right in detail view
  -- so that it doesn't obscure item quantities.
  local link = nil;
  local count = 1;
  local shift = 0;

  if DetailLink ~= nil then
    local item = DetailData[offset + id];
    if item ~= nil then
      link = DetailLink;
      count = item.count;
      shift = BuyButton1DetailName:GetLeft() - BuyButton1DetailCount:GetLeft();
    end
    shift = shift + 200;
  else
    link = SummaryData[offset + id].link;
    shift = shift + 250;
  end

  -- If we have an item, show the tooltip.
  self:SetAuctionLiteTooltip(widget, shift, link, count);
end

-- Mouse has left a row in the scrolling frame.
function AuctionLite:BuyButton_OnLeave(widget)
  GameTooltip:Hide();
  BattlePetTooltip:Hide();
end

-- Click the advanced menu button.
function AuctionLite:BuyAdvancedButton_OnClick()
  BuyAdvancedDropDown.displayMode = "MENU";
  BuyAdvancedDropDown.initialize = function(menu, level)
    UIDropDownMenu_SetWidth(BuyAdvancedDropDown, 140);

    if level == 1 then
      local info = UIDropDownMenu_CreateInfo();
      info.text = L["Show Deals"];
      info.func = function() AuctionLite:AuctionFrameBuy_Deals() end;
      UIDropDownMenu_AddButton(info, level);

      local info = UIDropDownMenu_CreateInfo();
      info.text = L["Show Favorites"];
      local single = self:GetSingleFavoritesList();
      if single == nil then
        info.hasArrow = true;
      else
        info.func = function()
          BuyMode = BUY_MODE_FAVORITES;
          self:MultiScan(single);
        end
      end
      UIDropDownMenu_AddButton(info, level);

      local info = UIDropDownMenu_CreateInfo();
      info.text = L["Show My Auctions"];
      info.func = function()
        BuyMode = BUY_MODE_MY_AUCTIONS;
        self:MultiScan(self:GetMyAuctionLinks());
      end
      UIDropDownMenu_AddButton(info, level);

      local info = UIDropDownMenu_CreateInfo();
      info.text = L["Configure AuctionLite"];
      info.func = function()
        InterfaceOptionsFrame_OpenToCategory(AuctionLite.optionFrames.tooltips);
        InterfaceOptionsFrame_OpenToCategory(self.optionFrames.main);
      end
      UIDropDownMenu_AddButton(info, level);
    elseif level == 2 then
      for _, name in ipairs(self:GetFavoritesLists()) do
        local favs = self.db.profile.favorites[name];
        local info = UIDropDownMenu_CreateInfo();
        info.text = name;
        info.func = function()
          BuyMode = BUY_MODE_FAVORITES;
          self:MultiScan(favs);
          CloseDropDownMenus();
        end
        UIDropDownMenu_AddButton(info, level);
      end
    end
  end

  ToggleDropDownMenu(1, nil, BuyAdvancedDropDown);
end

-- Returns to the summary page.
function AuctionLite:BuySummaryButton_OnClick()
  if PurchaseOrder ~= nil then
    self:CancelQuery();
    self:ResetSearch();
  end

  self:SetDetailLink(nil);

  self:AuctionFrameBuy_Update();
end

-- Approve a pending purchase.
function AuctionLite:BuyApproveButton_OnClick()
  PurchaseOrder.needsApproval = nil;
  self:QueryApprove();
  self:AuctionFrameBuy_Update();
end

-- Cancel a pending purchase.
function AuctionLite:BuyCancelPurchaseButton_OnClick()
  PurchaseOrder.needsApproval = nil;
  self:CancelQuery();
  self:ResetSearch();
  self:AuctionFrameBuy_Update();
end

-- Cancel an in-progress search.
function AuctionLite:BuyCancelSearchButton_OnClick()
  self:CancelQuery();
  self:ResetSearch();
  self:AuctionFrameBuy_Update();
end

-- Bid on the currently-selected item.
function AuctionLite:BuyBidButton_OnClick()
  if PurchaseOrder ~= nil then
    self:CancelQuery();
  end
  self:CreateOrder(false);
  self:AuctionFrameBuy_Update();
end

-- Buy out the currently-selected item.
function AuctionLite:BuyBuyoutButton_OnClick()
  if PurchaseOrder ~= nil then
    self:CancelQuery();
  end
  self:CreateOrder(true);
  self:AuctionFrameBuy_Update();
end

-- Cancel the currently-selected item.
function AuctionLite:BuyCancelAuctionButton_OnClick()
  self:CancelItems(IsControlKeyDown());
  self:AuctionFrameBuy_Update();
end

-- Show the cancel tooltip.
function AuctionLite:BuyCancelAuctionButton_OnEnter(widget)
  GameTooltip:SetOwner(widget, "ANCHOR_TOPLEFT");
  GameTooltip:SetText(L["CANCEL_TOOLTIP"]);
end

-- Hide the cancel tooltip.
function AuctionLite:BuyCancelAuctionButton_OnLeave(widget)
  GameTooltip:Hide();
  BattlePetTooltip:Hide();
end

-- Starts a full scan of the auction house.
function AuctionLite:StartFullScan()
  BuyMode = BUY_MODE_SCAN;

  if not self.db.profile.fastScanAd2 then
    StaticPopup_Show("AL_FAST_SCAN");
  else
    local query = {
      name = "",
      getAll = self.db.profile.getAll,
      update = function(pct, all)
        AuctionLite:UpdateProgressSearch(pct, all, true);
      end,
      finish = function(data, link)
        AuctionLite:SetScanData(data);
      end,
    };

    if self:StartQuery(query) then
      DetailLinkPrev = nil;
      self:ClearBuyFrame(true);
    end
  end
end

-- List current deals.  If we haven't done a full scan, do it now.
function AuctionLite:AuctionFrameBuy_Deals()
  BuyMode = BUY_MODE_DEALS;

  if ScanData ~= nil then
    DetailLinkPrev = nil;
    self:SetScanData(ScanData);
  else
    self:StartFullScan();
  end
end

-- Submit a search query.
function AuctionLite:AuctionFrameBuy_Search()
  BuyMode = BUY_MODE_SEARCH;

  local query = {
    name = BuyName:GetText(),
    wait = true,
    exact = IsShiftKeyDown(),
    update = function(pct) AuctionLite:UpdateProgressSearch(pct) end,
    finish = function(data) AuctionLite:SetBuyData(data) end,
  };

  if self:StartQuery(query) then
    DetailLinkPrev = DetailLink;
    self:ClearBuyFrame(true);
  end
end

-- Adjust frame buttons for repaint.
function AuctionLite:AuctionFrameBuy_OnUpdate()
  local canSend = CanSendAuctionQuery("list") and not self:QueryInProgress();
  local biddable, buyable, cancellable = self:GetSelectionStatus();

  if canSend and BuyName:GetText() ~= "" then
    BuySearchButton:Enable();
  else
    BuySearchButton:Disable();
  end

  if canSend then
    BuyScanButton:Enable();
  else
    BuyScanButton:Disable();
  end

  if canSend and biddable then
    BuyBidButton:Enable();
  else
    BuyBidButton:Disable();
  end

  if canSend and buyable then
    BuyBuyoutButton:Enable();
  else
    BuyBuyoutButton:Disable();
  end

  if cancellable then
    BuyCancelAuctionButton:Enable();
  else
    BuyCancelAuctionButton:Disable();
  end

  if StartTime ~= nil then
    self:UpdateProgressSearch();
  end
end

-- Adjust the scroll bar to a specified offset.
function AuctionLite:SetScrollFrameOffset(offset)
  -- We have to set the inner scroll bar manually, because otherwise the
  -- two values will become inconsistent.  We also set the max values to
  -- make sure that the value we're setting is not ignored.
  FauxScrollFrame_SetOffset(BuyScrollFrame, offset);
  BuyScrollFrameScrollBar:SetMinMaxValues(0, offset * BuyButton1:GetHeight());
  BuyScrollFrameScrollBar:SetValue(offset * BuyButton1:GetHeight());
end

-- Scroll the frame to a particular listing.
function AuctionLite:ScrollToListing(listing)
  if DetailLink ~= nil then
    -- Get the index of the item we're looking for.
    local i;
    local current;
    local found = nil;
    for i, current in ipairs(DetailData) do
      if current == listing then
        found = i;
        break;
      end
    end

    if found ~= nil then
      local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);
      local displaySize = BUY_DISPLAY_SIZE - 2;

      if found < offset or found >= displaySize then
        local newOffset = math.min(0, found - (displaySize / 2));
        self:SetScrollFrameOffset(newOffset);
      end
    end
  end
end

-- Update the scroll frame with either the detail view or summary view.
function AuctionLite:AuctionFrameBuy_Update()
  -- First clear everything.
  local i;
  for i = 1, BUY_DISPLAY_SIZE do
    local buttonName = "BuyButton" .. i;

    local button = _G[buttonName];
    local buttonDetail = _G[buttonName .. "Detail"];
    local buttonSummary = _G[buttonName .. "Summary"];

    button:Hide();
    buttonDetail:Hide();
    buttonSummary:Hide();
  end

  BuyHeader:Hide();
  BuySummaryHeader:Hide();

  BuyStatus:Hide();

  -- If we have no items, say so.
  BuyMessageText:Show();
  if BuyMode == BUY_MODE_INTRO then
    BuyMessageText:SetText(L["Enter item name and click \"Search\""]);
  elseif BuyMode == BUY_MODE_SEARCH and NoResults then
    BuyMessageText:SetText(L["No items found"]);
  elseif BuyMode == BUY_MODE_SCAN and NoResults then
    BuyMessageText:SetText(L["Scan complete.  Try again later to find deals!"]);
  elseif BuyMode == BUY_MODE_DEALS and NoResults then
    BuyMessageText:SetText(L["No deals found"]);
  elseif BuyMode == BUY_MODE_FAVORITES and NoResults then
    BuyMessageText:SetText(L["No items found"]);
  elseif BuyMode == BUY_MODE_MY_AUCTIONS and NoResults then
    BuyMessageText:SetText(L["No current auctions"]);
  else
    BuyMessageText:Hide();
  end

  -- Update the expandable header.
  self:AuctionFrameBuy_UpdateExpand();

  -- Use detail view if we've chosen an item, or summary view otherwise.
  if DetailLink ~= nil then
    self:AuctionFrameBuy_UpdateDetail();
  else
    self:AuctionFrameBuy_UpdateSummary();
  end
end

-- Update the expandable frame at the top of the scroll frame.
function AuctionLite:AuctionFrameBuy_UpdateExpand()
  -- Figure out how big a window to make.
  local order = PurchaseOrder;
  if order == nil then
    ExpandHeight = 0;
  elseif order.resell == nil then
    ExpandHeight = 2;
  else
    ExpandHeight = 4;
  end

  -- Set the height of the expandable window.  It's always one higher than
  -- the number of rows because WoW gets confused if it goes to zero;
  -- other frame offsets are computed appropriately.
  BuyExpand:SetHeight((ExpandHeight + 1) * ROW_HEIGHT);

  -- Show rows as appropriate.
  local i;
  for i = 1, EXPAND_ROWS do
    local prefix = "BuyExpand" .. i;
    local text = _G[prefix .. "Text"];
    local money = _G[prefix .. "MoneyFrame"];

    if i <= ExpandHeight then
      text:Show();
      money:Show();
    else
      text:Hide();
      money:Hide();
    end
  end

  -- Populate the expandable frame with appropriate data from the order.
  local order = PurchaseOrder;
  if order ~= nil then
    if order.resell == nil then
      if order.isBuyout then
        BuyExpand1Text:SetText(L["Buyout cost for %d:"]:format(order.count));
      else
        BuyExpand1Text:SetText(L["Bid cost for %d:"]:format(order.count));
      end
      MoneyFrame_Update(BuyExpand1MoneyFrame, order.price);

      BuyExpand2Text:SetText(L["Historical price for %d:"]:format(order.count));
      MoneyFrame_Update(BuyExpand2MoneyFrame, order.histPrice);
    else
      if order.isBuyout then
        BuyExpand1Text:SetText(L["Buyout cost for %d:"]:format(order.count));
      else
        BuyExpand1Text:SetText(L["Bid cost for %d:"]:format(order.count));
      end
      MoneyFrame_Update(BuyExpand1MoneyFrame, order.price);

      BuyExpand2Text:SetText(L["Resell %d:"]:format(order.resell));
      MoneyFrame_Update(BuyExpand2MoneyFrame, order.resellPrice);
      self:MakeNegative("BuyExpand2MoneyFrame");

      BuyExpand3Text:SetText(
        L["Net cost for %d:"]:format(order.count - order.resell));
      if order.netPrice < 0 then
        MoneyFrame_Update(BuyExpand3MoneyFrame, - order.netPrice);
        self:MakeNegative("BuyExpand3MoneyFrame");
      else
        MoneyFrame_Update(BuyExpand3MoneyFrame, order.netPrice);
      end

      BuyExpand4Text:SetText(
        L["Historical price for %d:"]:format(order.count - order.resell));
      MoneyFrame_Update(BuyExpand4MoneyFrame, order.histPrice);
    end

    local current = order.listingsBought + order.listingsNotFound + 1;
    local total = current + table.getn(order.list);
    BuyBatchText:SetText(L["Listing %d of %d"]:format(current, total));
  else
    BuyBatchText:SetText("");
  end

  -- Show/hide and enable/disable approval buttons.
  if ExpandHeight > 0 then
    BuyApproveButton:Show();
    BuyCancelPurchaseButton:Show();

    if PurchaseOrder ~= nil and PurchaseOrder.needsApproval then
      BuyApproveButton:Enable();
      BuyCancelPurchaseButton:Enable();
    else
      BuyApproveButton:Disable();
      BuyCancelPurchaseButton:Disable();
    end
  else
    BuyApproveButton:Hide();
    BuyCancelPurchaseButton:Hide();
  end
end

-- Update the scroll frame with the detail view.
function AuctionLite:AuctionFrameBuy_UpdateDetail()
  if not DetailSort.sorted then
    self:ApplyDetailSort();
  end

  local sort;
  for _, sort in ipairs({ "Item", "BidEach", "BidAll",
                          "BuyoutEach", "BuyoutAll" }) do
    self:UpdateSortArrow("Buy", sort, DetailSort.sort, DetailSort.flipped);
  end

  local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);
  local displaySize = BUY_DISPLAY_SIZE - ExpandHeight;

  local _, _, _, _, enchant, jewel1, jewel2, jewel3, jewel4 =
    self:SplitLink(DetailLink);

  local showPlus = enchant ~= 0 or
                   jewel1 ~= 0 or jewel2 ~= 0 or
                   jewel3 ~= 0 or jewel4 ~= 0;

  local i;
  for i = 1, displaySize do
    local item = DetailData[offset + i];
    if item ~= nil then
      local buttonName = "BuyButton" .. i;
      local button = _G[buttonName];

      local warning = _G[buttonName .. "Warning"];

      local buttonDetailName = buttonName .. "Detail";
      local buttonDetail     = _G[buttonDetailName];

      local countText        = _G[buttonDetailName .. "Count"];
      local nameText         = _G[buttonDetailName .. "Name"];
      local plusText         = _G[buttonDetailName .. "Plus"];
      local bidEachFrame     = _G[buttonDetailName .. "BidEachFrame"];
      local bidFrame         = _G[buttonDetailName .. "BidFrame"];
      local buyoutEachFrame  = _G[buttonDetailName .. "BuyoutEachFrame"];
      local buyoutFrame      = _G[buttonDetailName .. "BuyoutFrame"];

      local name, color = self:SplitLink(DetailLink);

      local countColor;
      local nameColor;
      if item.owner == UnitName("player") then
        countColor = "ffffff00";
        nameColor = "ffffff00";
      else
        countColor = "ffffffff";
        nameColor = color;
      end

      countText:SetText("|c" .. countColor .. item.count .. "x|r");

      nameText:SetText("|c" .. nameColor .. name .. "|r");

      if showPlus then
        plusText:SetPoint("LEFT", nameText, "LEFT",
                          nameText:GetStringWidth(), 0);
        plusText:Show();
      else
        plusText:Hide();
      end

      MoneyFrame_Update(bidEachFrame, math.floor(item.bid / item.count));
      bidEachFrame:SetAlpha(0.5);
      if item.bidder then
        SetMoneyFrameColor(buttonDetailName .. "BidEachFrame", "yellow");
      else
        SetMoneyFrameColor(buttonDetailName .. "BidEachFrame", "white");
      end

      MoneyFrame_Update(bidFrame, math.floor(item.bid));
      bidFrame:SetAlpha(0.5);
      if item.bidder then
        SetMoneyFrameColor(buttonDetailName .. "BidFrame", "yellow");
      else
        SetMoneyFrameColor(buttonDetailName .. "BidFrame", "white");
      end

      if item.buyout > 0 then
        MoneyFrame_Update(buyoutEachFrame, math.floor(item.buyout / item.count));
        buyoutEachFrame:Show();

        MoneyFrame_Update(buyoutFrame, math.floor(item.buyout));
        buyoutFrame:Show();
      else
        buyoutEachFrame:Hide();
        buyoutFrame:Hide();
      end

      if SelectedItems[item] then
        button:LockHighlight();
      else
        button:UnlockHighlight();
      end

      if PurchaseOrder ~= nil and PurchaseOrder.current == item then
        warning:SetAlpha(0.4);
      else
        warning:SetAlpha(0);
      end

      buttonDetail:Show();
      button:Show();
    end
  end

  FauxScrollFrame_Update(BuyScrollFrame, table.getn(DetailData),
                         displaySize, ROW_HEIGHT);

  if table.getn(DetailData) > 0 then
    BuyHeader:Show();
  end
end

-- Update the scroll frame with the summary view.
function AuctionLite:AuctionFrameBuy_UpdateSummary()
  if not SummarySort.sorted then
    self:ApplySummarySort();
  end

  local sort;
  for _, sort in ipairs({ "ItemSummary", "Listings", "Items",
                          "Market", "Historical" }) do
    self:UpdateSortArrow("Buy", sort, SummarySort.sort, SummarySort.flipped);
  end

  local offset = FauxScrollFrame_GetOffset(BuyScrollFrame);
  local displaySize = BUY_DISPLAY_SIZE - ExpandHeight;

  local i;
  for i = 1, displaySize do
    local item = SummaryData[offset + i];
    if item ~= nil then
      local buttonName = "BuyButton" .. i;
      local button = _G[buttonName];

      local warning = _G[buttonName .. "Warning"];

      local buttonSummaryName = buttonName .. "Summary";
      local buttonSummary     = _G[buttonSummaryName];

      local starButton        = _G[buttonSummaryName .. "StarButton"];
      local nameText          = _G[buttonSummaryName .. "Name"];
      local plusText          = _G[buttonSummaryName .. "Plus"];
      local listingsText      = _G[buttonSummaryName .. "Listings"];
      local itemsText         = _G[buttonSummaryName .. "Items"];
      local marketFrame       = _G[buttonSummaryName .. "MarketPriceFrame"];
      local histFrame         = _G[buttonSummaryName .. "HistPriceFrame"];

      if self:IsFavorite(item.link) then
        starButton:GetNormalTexture():SetAlpha(1.0);
      else
        starButton:GetNormalTexture():SetAlpha(0.1);
      end

      local name, color, _, _, enchant, jewel1, jewel2, jewel3, jewel4 =
        self:SplitLink(item.link);

      local countStr = function(mine, all)
        local prefix;
        if mine > 0 and self.db.profile.countMyListings then
          prefix = "(" .. mine .. ") ";
        else
          prefix = "";
        end
        return prefix .. "|cffffffff" .. all .. "|r";
      end

      nameText:SetText("|c" .. color .. name .. "|r");
      listingsText:SetText(countStr(item.listingsMine, item.listingsAll));
      itemsText:SetText(countStr(item.itemsMine, item.itemsAll));

      --warbaby add absolute _minprice for show
      if (item._minprice and item._minprice > 0) or (item.price ~= nil and item.price > 0) then
        MoneyFrame_Update(marketFrame, math.floor(item._minprice and item._minprice>0 and item._minprice or item.price));
        marketFrame:Show();
      else
        marketFrame:Hide();
      end

      local moreData;
      if BuyMode == BUY_MODE_DEALS or
         BuyMode == BUY_MODE_SCAN then
        moreData = item.profit;
      else
        moreData = item.histPrice;
      end

      if moreData ~= nil and moreData > 0 then
        MoneyFrame_Update(histFrame, math.floor(moreData));
        histFrame:Show();
      else
        histFrame:Hide();
      end

      if enchant ~= 0 or
         jewel1 ~= 0 or jewel2 ~= 0 or
         jewel3 ~= 0 or jewel4 ~= 0 then
        plusText:SetPoint("LEFT", nameText, "LEFT",
                          nameText:GetStringWidth(), 0);
        plusText:Show();
      else
        plusText:Hide();
      end

      button:UnlockHighlight();

      if item.warning then
        warning:SetAlpha(0.4);
      else
        warning:SetAlpha(0);
      end

      buttonSummary:Show();
      button:Show();
    end
  end

  FauxScrollFrame_Update(BuyScrollFrame, table.getn(SummaryData),
                         displaySize, ROW_HEIGHT);

  if table.getn(SummaryData) > 0 then
    BuySummaryHeader:Show();
    if BuyMode == BUY_MODE_DEALS or
       BuyMode == BUY_MODE_SCAN then
      self:UpdateSortButton("Buy", "Historical", L["Potential Profit"]);
    else
      self:UpdateSortButton("Buy", "Historical", L["Historical Price"]);
    end
  end
end

-- Loads a name into the input field and searches.
function AuctionLite:NameClickBuy(name)
  BuyName:SetText(name);
  BuyQuantity:SetFocus();
  AuctionLite:AuctionFrameBuy_Search();
end

-- Handle bag item clicks by searching for the item.
function AuctionLite:BagClickBuy(container, slot)
  local link = GetContainerItemLink(container, slot);
  if link ~= nil then
    local name = self:SplitLink(link);
    self:NameClickBuy(name);
  end
end

-- Resets all info about an in-progress search.
function AuctionLite:ResetSearch()
  StartTime = nil;
  LastTime = nil;
  LastRemaining = nil;
  Progress = nil;
  GetAll = nil;
  Scanning = nil;
end

-- Clean up the "Buy" tab.
function AuctionLite:ClearBuyFrame(partial)
  ExpandHeight = 0;

  if not partial then
    BuyMode = BUY_MODE_INTRO;

    SummarySort = {
      sort = "ItemSummary",
      flipped = false,
      justFlipped = false,
      sorted = false,
    };

    DetailSort = {
      sort = "BuyoutEach",
      flipped = false,
      justFlipped = false,
      sorted = false,
    };
  end

  DetailLink = nil;
  DetailData = {};

  if not partial then
    DetailLinkPrev = nil;
  end

  SelectedItems = {};
  LastClick = nil;

  SummaryData = {};
  SummaryDataByLink = {};
  NoResults = false;

  PurchaseOrder = nil;

  self:ResetSearch();

  if not partial then
    MultiScanCurrent = nil;
    MultiScanOriginal = {};
    MultiScanItems = {};
  end
  MultiScanData = {};

  if not partial then
    BuyName:SetText("");
    BuyQuantity:SetText("");
    BuyName:SetFocus();
  end

  BuyMessageText:Hide();
  BuyStatus:Hide();

  FauxScrollFrame_SetOffset(BuyScrollFrame, 0);
  BuyScrollFrameScrollBar:SetValue(0);

  self:AuctionFrameBuy_Update();
end

-- Create the "Buy" tab.
function AuctionLite:CreateBuyFrame()
  -- Create our tab.
  local index = self:CreateTab(L["AuctionLite - Buy"], AuctionFrameBuy);

  -- Set all localizable strings in the UI.
  BuyTitle:SetText(L["AuctionLite - Buy"]);
  BuyNameText:SetText(L["Name"]);
  BuyQuantityText:SetText(L["Qty"]);
  BuyStatusText:SetText(L["Searching:"]);
  BuyElapsedText:SetText(L["Time Elapsed:"]);
  BuyRemainingText:SetText(L["Time Remaining:"]);
  BuyCancelSearchButton:SetText(L["Cancel"]);
  BuyApproveButton:SetText(L["Approve"]);
  BuyCancelPurchaseButton:SetText(L["Cancel"]);
  BuyAdvancedText:SetText(L["Advanced"]);
  BuyScanButton:SetText(L["Full Scan"]);
  BuySearchButton:SetText(L["Search"]);
  BuyCancelAuctionButton:SetText(L["Cancel"]);

  -- Set button text and adjust arrow icons accordingly.
  BuyItemButton:SetText(L["Item"]);
  BuyItemSummaryButton:SetText(L["Item Summary"]);

  self:UpdateSortButton("Buy", "BidEach", L["Bid Per Item"]);
  self:UpdateSortButton("Buy", "BidAll", L["Bid Total"]);
  self:UpdateSortButton("Buy", "BuyoutEach", L["Buyout Per Item"]);
  self:UpdateSortButton("Buy", "BuyoutAll", L["Buyout Total"]);

  self:UpdateSortButton("Buy", "Historical", L["Historical Price"]);
  self:UpdateSortButton("Buy", "Market", L["Market Price"]);
  self:UpdateSortButton("Buy", "Items", L["Items"]);
  self:UpdateSortButton("Buy", "Listings", L["Listings"]);

  -- Make sure it's pristine.
  self:ClearBuyFrame();

  return index;
end
