-------------------------------------------------------------------------------
-- Query.lua
--
-- Queries the auction house.
-------------------------------------------------------------------------------

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

-- Maximum number of bytes in the first argument of QueryAuctionItems().
local MAX_QUERY_BYTES = 63;

-- Maximum number of retries if we get duplicate pages.
local MAX_RETRIES = 3;

-- State of our current auction query.
local QUERY_STATE_SEND    = 1; -- ready to request a new page
local QUERY_STATE_WAIT    = 2; -- waiting for results of previous request
local QUERY_STATE_APPROVE = 3; -- waiting for approval of a purchase

-- Time to wait (in seconds) after incomplete results are returned.
local QUERY_DELAY = 5;

-- Info about current AH query.
local Query = nil;

-- Is the current call to QueryAuctionItems ours?
local OurQuery = false;

-- Start an auction query.
function AuctionLite:StartQuery(newQuery)
  if Query ~= nil and Query.state == QUERY_STATE_APPROVE then
    self:CancelQuery();
  end
  if Query == nil then
    Query = newQuery;
    Query.state = QUERY_STATE_SEND;
    Query.page = 0;
    Query.retries = 0;
    Query.data = {};
    return true;
  else
    return false;
  end
end

-- Cancel an auction query.
function AuctionLite:CancelQuery()
  if Query ~= nil then
      if Query.state ~= QUERY_STATE_APPROVE and Query.data then
          --abyui Copy from QueryNewData()
          local oldQuery = Query;
          -- We're done.  End the query and return the results.
          self:QueryEnd();
          -- Update our price info.
          local results = self:AnalyzeData(oldQuery.data);
          for link, result in pairs(results) do
              self:UpdateHistoricalPrice(link, result);
          end
          -- Notify our caller.
          if oldQuery.finish ~= nil then
              oldQuery.finish(results, oldQuery.link);
          end
          return
      end

    if Query.state == QUERY_STATE_APPROVE then
      assert(Query.found ~= nil);
      Query.found = nil;
      if Query.finish ~= nil then
        Query.finish(true);
      end
    end
    self:QueryEnd();
  end
end

-- Cancel our queries if we see somebody else interfere.
function AuctionLite:QueryAuctionItems_Hook()
  if not OurQuery then
    self:CancelQuery();
  end
end

-- Called periodically to check whether a new query should be sent.
function AuctionLite:QueryUpdate()
  -- Find out whether we can send queries.
  local canSend, canGetAll = CanSendAuctionQuery("list");
  if canSend and Query ~= nil and Query.state == QUERY_STATE_SEND then
    -- Determine the query string.
    local name = nil;
    if Query.name ~= nil then
      name = Query.name;
    elseif Query.link ~= nil then
      name = self:SplitLink(Query.link);
    end

    -- Did we get a reasonable query?  We need a name, and if it's a getAll
    -- query, it should be on the first page with no shopping list.
    if name ~= nil and
       (not Query.getAll or (Query.page == 0 and Query.listing == nil)) then

      -- Truncate to avoid disconnects.
      name = self:Truncate(name, MAX_QUERY_BYTES);

      -- Was getAll requested, and can we actually use it?
      local getAll = false;
      if Query.getAll then
        if canGetAll then
          getAll = true;
        else
          Query.getAll = false;
          self:Print(L["|cffffd000[Note]|r " ..
                       "Fast auction scans can only be used once every " ..
                       "15 minutes. Using a slow scan for now."]);
        end
      end

      -- Submit the query.
      OurQuery = true;
      QueryAuctionItems(name, 0, 0, Query.page, false, -1, getAll,
                        Query.exact);
      OurQuery = false;

      -- Wait for our result.
      self:QueryWait();

      -- If this is the first query, notify the caller (mostly so that
      -- they know whether we're doing getAll or not).
      if Query.update ~= nil and Query.page == 0 then
        Query.update(0, getAll);
      end
    else
      self:CancelQuery();
    end
  end

  -- Are we waiting for a more detailed update?  If so, check to see
  -- whether we've timed out.
  if Query ~= nil and Query.state == QUERY_STATE_WAIT and
     Query.time ~= nil and Query.time + QUERY_DELAY < time() then
    Query.time = nil;
    self:QueryNewData();
  end
end

-- Wait for purchase approval.
function AuctionLite:QueryRequestApproval()
  assert(Query ~= nil and Query.state == QUERY_STATE_WAIT and
         Query.found ~= nil);
  Query.state = QUERY_STATE_APPROVE;
end

-- Wait for incoming data.
function AuctionLite:QueryWait()
  assert(Query ~= nil and
         (Query.state == QUERY_STATE_SEND or
          Query.state == QUERY_STATE_APPROVE));
  Query.state = QUERY_STATE_WAIT;
end

-- Get the next page.
function AuctionLite:QueryNext()
  assert(Query ~= nil and
         (Query.state == QUERY_STATE_WAIT or
          Query.state == QUERY_STATE_APPROVE));
  Query.state = QUERY_STATE_SEND;
  Query.page = Query.page + 1;
  Query.retries = 0;
end

-- Get the current page again.
function AuctionLite:QueryCurrent()
  assert(Query ~= nil and Query.state == QUERY_STATE_WAIT);
  Query.state = QUERY_STATE_SEND;
end

-- End the current query.
function AuctionLite:QueryEnd()
  assert(Query ~= nil);
  Query = nil;
end

-- Is there currently a query pending?
function AuctionLite:QueryInProgress()
  return (Query ~= nil and Query.state ~= QUERY_STATE_APPROVE);
end

-- Compute the average and standard deviation of the points in data.
function AuctionLite:ComputeStats(data)
  local count = 0;
  local sum = 0;
  local sumSquared = 0;

  for _, listing in ipairs(data) do
    if listing.keep then
      count = count + listing.count;
      sum = sum + listing.price * listing.count;
      sumSquared = sumSquared + (listing.price ^ 2) * listing.count;
    end
  end

  local avg = 0;
  local stddev = 0;

  if count ~= 0 then
    avg = sum / count;
    stddev = math.max(0, sumSquared / count - (sum ^ 2 / count ^ 2)) ^ 0.5;
  end
  
  return avg, stddev;
end

-- Analyze an AH query result.
function AuctionLite:AnalyzeData(rawData)
  local results = {};
  local itemData = {};
  local i;

  -- Split up our data into tables for each item.
  for _, entry in ipairs(rawData) do
    local link = entry.link;
    local count = entry.count;
    local bid = entry.bid;
    local buyout = entry.buyout
    local owner = entry.owner;
    local bidder = entry.highBidder;

    if link ~= nil then
      local price = buyout / count;
      if price <= 0 then
        price = bid / count;
      end

      local keep = owner ~= UnitName("player") and buyout > 0;

      local listing = { bid = bid, buyout = buyout,
                        price = price, count = count,
                        owner = owner, bidder = bidder, keep = keep };

      if itemData[link] == nil then
        itemData[link] = {};
      end

      table.insert(itemData[link], listing);
    end
  end

  -- Process each data set.
  local link, data;
  for link, data in pairs(itemData) do 
    local done = false;

    -- Discard any points that are more than 2 SDs away from the mean.
    -- Repeat until no such points exist.
    while not done do
      done = true;
      local avg, stddev = self:ComputeStats(data);
      for _, listing in ipairs(data) do
        if listing.keep and math.abs(listing.price - avg) > 2.5 * stddev then
          listing.keep = false;
          done = false;
        end
      end
    end

    -- We've converged.  Compute our min price and other stats.
    local result = { price = 1000000000, items = 0, listings = 0,
                     itemsMine = 0, listingsMine = 0,
                     itemsAll = 0, listingsAll = 0 };
    local setPrice = false;

    for _, listing in ipairs(data) do
      if listing.keep then
        result.items = result.items + listing.count;
        result.listings = result.listings + 1;
        if listing.price < result.price then
          result.price = listing.price;
          setPrice = true;
        end
      end
      if not result._minprice or listing.price < result._minprice  then result._minprice = listing.price end --warbaby add absolute _minprice for show
      if listing.owner == UnitName("player") then
        result.itemsMine = result.itemsMine + listing.count;
        result.listingsMine = result.listingsMine + 1;
      end
      result.itemsAll = result.itemsAll + listing.count;
      result.listingsAll = result.listingsAll + 1;
    end

    -- If we kept no data (e.g., all auctions are ours), pick the first
    -- price.  By construction of itemData, there is at least one entry.
    if not setPrice then
      result.price = data[1].price;
      result.priceIsMine = true;
    end

    result.data = data;
    results[link] = result;
  end

  return results;
end

-- Approve purchase of a pending item.
function AuctionLite:QueryApprove()
  assert(Query ~= nil);
  assert(Query.state == QUERY_STATE_APPROVE);
  assert(Query.found ~= nil);

  -- Place the request bid or buyout.
  local price;
  if Query.isBuyout then
    price = Query.found.buyout;
  else
    price = Query.found.bid;
  end
  if price <= GetMoney() then
    PlaceAuctionBid("list", Query.found.index, price);
    self:IgnoreMessage(ERR_AUCTION_BID_PLACED);
    if Query.isBuyout then
      self:IgnoreMessage(ERR_AUCTION_WON_S:format(Query.name));
    end
    Query.listing.purchased = true;
  end

  -- Clean up.
  Query.found = nil;

  -- End the query.
  local oldQuery = Query;
  self:QueryEnd();
  if oldQuery.finish ~= nil then
    oldQuery.finish();
  end
end

-- Cancel the current purchase and restart the approval process.
function AuctionLite:RestartApproval()
  assert(Query ~= nil);
  assert(Query.state == QUERY_STATE_APPROVE);
  assert(Query.found ~= nil);

  -- Forget the found item.
  Query.found = nil;

  -- Tell the "Buy" frame.
  self:CancelRequestApproval();

  -- Go back to the waiting state.
  self:QueryWait();
end

-- We've got new data.
function AuctionLite:QueryNewData()
  assert(Query ~= nil);
  assert(Query.state == QUERY_STATE_WAIT);

  -- We've completed one of our own queries.
  local seen = Query.page * NUM_AUCTION_ITEMS_PER_PAGE + Query.batch;

  -- If we're running a getAll query, we'd better have seen everything.
  assert(not Query.getAll or seen == Query.total);

  -- Update status.
  local pct = 0;
  if Query.total > 0 then
    pct = math.floor(seen * 100 / Query.total);
  end
  if Query.update ~= nil then
    Query.update(pct, Query.getAll, Query.data);
  end

  -- Handle the new data based on the kind of query.
  if Query.listing == nil then
    -- This is a search query, not a purchase.
    if seen < Query.total then
      -- Request the next page.
      self:QueryNext();
    else
      local oldQuery = Query;
      -- We're done.  End the query and return the results.
      self:QueryEnd();
      -- Update our price info.
      local results = self:AnalyzeData(oldQuery.data);
      for link, result in pairs(results) do 
        self:UpdateHistoricalPrice(link, result);
      end
      -- Notify our caller.
      if oldQuery.finish ~= nil then
        oldQuery.finish(results, oldQuery.link);
      end
    end
  else
    assert(not Query.getAll);
    assert(Query.found == nil);

    -- See if we've found the auction we're looking for.
    local i;
    for i = 1, Query.batch do
      local listing = Query.data[Query.page * NUM_AUCTION_ITEMS_PER_PAGE + i];
      if self:MatchListing(Query.name, Query.listing, listing) then
        Query.found = listing;
        Query.found.index = i;
        break;
      end
    end

    -- If we found something, request approval.
    -- Otherwise, get the next page or end the query.
    if Query.found ~= nil then
      self:RequestApproval();
      self:QueryRequestApproval();
    elseif seen < Query.total then
      self:QueryNext();
    else
      local oldQuery = Query;
      self:QueryEnd();
      if oldQuery.finish ~= nil then
        oldQuery.finish();
      end
    end
  end
end

-- Handle a completed auction query.
function AuctionLite:AUCTION_ITEM_LIST_UPDATE()
  -- If we were waiting for approval of a purchase, and the list of items
  -- changed from underneath us, we need to find the item again.
  if Query ~= nil and Query.state == QUERY_STATE_APPROVE then
    self:RestartApproval();
  end
  -- Now handle the data for real.
  if Query ~= nil and Query.state == QUERY_STATE_WAIT then
    Query.batch, Query.total = GetNumAuctionItems("list");

    -- Workaround for Blizzard bug in getAll queries that can cause it
    -- to return bogus values for Query.total.
    if Query.getAll and Query.total ~= Query.batch then
      Query.total = Query.batch;
    end

    local incomplete = 0;
    local i;

    -- Doing this speeds up performance by approx. 9500%. I didn't actually measure it, but it is absolutely staggering what a boost we get.
    AuctionFrameBrowse:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
    C_Timer.After(2, function() AuctionFrameBrowse:RegisterEvent("AUCTION_ITEM_LIST_UPDATE") end)
    for i = 1, Query.batch do
      local listing = self:GetListing("list", i);

      -- Sometimes we get incomplete records.  Is this one of them?
      if listing.owner == nil then
        incomplete = incomplete + 1;
      end

      -- Record the data.
      Query.data[Query.page * NUM_AUCTION_ITEMS_PER_PAGE + i] = listing;
    end

    local duplicate =
      Query.page > 0 and
      self:MatchPages(Query.data, Query.page - 1, Query.page);

    -- If we got a duplicate record, request the current one again.
    -- If it's an incomplete record, wait.
    -- Otherwise, process the data.
    if duplicate and Query.retries < MAX_RETRIES then
      Query.retries = Query.retries + 1;
      self:QueryCurrent();
    elseif Query.wait and incomplete > 0 then
      Query.time = time();
    else
      Query.time = nil;
      self:QueryNewData();
    end
  end
end
