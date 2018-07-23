-------------------------------------------------------------------------------
-- CancelAuctions.lua
--
-- Cancel a group of auctions.
-------------------------------------------------------------------------------

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

-- Static popup advertising AL's fast scan.
StaticPopupDialogs["AL_CANCEL_CONFIRM"] = {
  text = L["CANCEL_CONFIRM_TEXT"],
  button1 = L["Cancel All"],
  button3 = L["Cancel Unbid"],
  button2 = L["Do Nothing"],
  OnAccept = function(self)
    AuctionLite:FinishCancel(self.data, true);
  end,
  OnAlt = function(self)
    AuctionLite:FinishCancel(self.data, false);
  end,
  OnCancel = function(self)
    -- Do nothing.
  end,
  showAlert = 1,
  timeout = 0,
  exclusive = 1,
  hideOnEscape = 1,
  preferredIndex = 3
};

-- Cancel all auctions for "name" listed in "targets".
function AuctionLite:CancelAuctions(targets)
  local batch = GetNumAuctionItems("owner");
  local cancel = {};
  local bidsDetected = false;

  -- Find all the auctions to cancel.
  local i;
  for i = 1, batch do
    local listing = self:GetListing("owner", i);

    for _, target in ipairs(targets) do
      if not target.found and
         self:MatchListing(target.name, target, listing) then

        target.found = true;

        local item = { index = i,
                       target = target,
                       hasBid = (listing.bidAmount > 0) };

        table.insert(cancel, item);

        if item.hasBid then
          bidsDetected = true;
        end

        break;
      end
    end
  end

  -- Clear all our marks.
  for _, target in ipairs(targets) do
    target.found = nil;
  end

  -- If we found any bids, show our confirmation dialog.
  -- Otherwise, just cancel the auctions.
  if bidsDetected then
    local dialog = StaticPopup_Show("AL_CANCEL_CONFIRM");
    if dialog ~= nil then
      dialog.data = cancel;
    end
  else
    self:FinishCancel(cancel, false);
  end
end

-- Actually cancel the selected auctions.
function AuctionLite:FinishCancel(cancel, cancelBid)
  -- Sort them from highest to lowest so that we can cancel the higher
  -- ones without throwing off the indices of the remaining ones.
  table.sort(cancel, function(a, b) return a.index > b.index end);

  -- Cancel them!
  local summary = {};
  for _, item in ipairs(cancel) do
    if cancelBid or not item.hasBid then
      item.target.cancelled = true;
      CancelAuction(item.index);
      self:IgnoreMessage(ERR_AUCTION_REMOVED);

      local name = item.target.name;
      if summary[name] ~= nil then
        summary[name] = summary[name] + 1;
      else
        summary[name] = 1;
      end

      -- Hack: We only want to cancel the first item, since WoW 4.0
      -- now requires a hardware event for each cancel.  Break here
      -- and let subsequent calls to cancel take care of the rest.
      -- It's important that we cancelled the last item in the list
      -- so that subsequent calls don't fail.
      break;
    end
  end

  -- Print a summary.
  for name, listingsCancelled in pairs(summary) do
    self:Print(L["Cancelled %d |4listing:listings; of %s."]:
               format(listingsCancelled, name));
  end

  -- Notify the "Buy" frame.
  self:CancelComplete();
end
