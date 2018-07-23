-------------------------------------------------------------------------------
-- Util.lua
--
-- General utility functions.
-------------------------------------------------------------------------------

local _

-- Make a printable string for a time in seconds.
function AuctionLite:PrintTime(sec)
  local min = math.floor(sec / 60);
  sec = sec % 60;

  local hr = math.floor(min / 60);
  min = min % 60;

  local result = "";

  if hr > 0 then
    result = tostring(hr) .. ":" .. string.format("%02d", min) .. ":";
  else
    result = tostring(min) .. ":";
  end

  result = result .. string.format("%02d", sec);

  return result;
end

-- Make a printable string for a given amount of money (in copper).
function AuctionLite:PrintMoney(money)
  money = math.floor(money);
  local copper = money % 100;
  money = math.floor(money / 100);
  local silver = money % 100;
  money = math.floor(money / 100);
  local gold = money;

  local result = "";

  local append = function(s)
    if result ~= "" then
      result = result .. " ";
    end
    result = result .. s;
  end

  if gold > 0 then
    append("|cffd3c63a" .. gold .. "|cffffffffg|r");
  end
  if silver > 0 then
    append("|cffb0b0b0" .. silver .. "|cffffffffs|r");
  end
  if copper > 0 then
    append("|cffb2734a" .. copper .. "|cffffffffc|r");
  end

  if result == "" then
    result = "0";
  end

  return result;
end

-- Parse a string representing an amount of money.
function AuctionLite:ParseMoney(str)
  -- Remove colors.
  str = str:gsub("|c........", "");
  str = str:gsub("|r", "");

  -- Extract gold, silver, and copper portions.
  -- This could be a single regexp if Lua regexps worked properly...
  local _, _, gold = str:find("^ *(%d+)g");
  str = str:gsub("^ *(%d+)g", "");

  local _, _, silver = str:find("^ *(%d+)s");
  str = str:gsub("^ *(%d+)s", "");

  local _, _, copper = str:find("^ *(%d+)c");
  str = str:gsub("^ *(%d+)c", "");

  -- Make sure there's nothing left but whitespace, and compute the result.
  local money = 0;

  if str:find("^ *$") ~= nil then
    if gold ~= nil then
      money = money + gold * 10000
    end
    if silver ~= nil then
      money = money + silver * 100
    end
    if copper ~= nil then
      money = money + copper
    end
  end

  return money;
end

-- Regular expression for parsing links.
local LinkRegexp = "|c(.*)|H(.*)|h%[(.*)%]";

-- Is this string a link?
function AuctionLite:IsLink(str)
  return (str:find(LinkRegexp) ~= nil);
end

-- Is this link a battle pet link?
function AuctionLite:IsBattlePetLink(link)
  return strmatch(link, "|Hbattlepet:");
end

-- Dissect an item link or item string.
function AuctionLite:SplitLink(link)
  -- Parse the link.
  local _, _, color, str, name = link:find(LinkRegexp);

  -- If we failed, then assume it's actually an item string.
  if str == nil then
    str = link;
  end

  -- Split the item string.
  local _, id, enchant, jewel1, jewel2, jewel3, jewel4, suffix, unique =
        strsplit(":", str);

  return name, color,
         tonumber(id) or 0, tonumber(suffix) or 0, tonumber(enchant) or 0,
         tonumber(jewel1) or 0, tonumber(jewel2) or 0,
         tonumber(jewel3) or 0, tonumber(jewel4) or 0,
         tonumber(unique) or 0;
end

-- Zero out the uniqueId field from an item link.
function AuctionLite:RemoveUniqueId(link)
  if link ~= nil then
    return link:gsub(
        -- Fields: itemID, enchant, gem1, gem2, gem3, gem4, suffixID.
        "(Hitem:%-?%d*:%-?%d*:%-?%d*:%-?%d*:%-?%d*:%-?%d*:%-?%d*)" ..
        -- Fields: uniqueID, level.
        ":%-?%d*:%-?%d*",
        -- Set uniqueID and level to 0.
         "%1::")
  else
    return nil;
  end
end

-- Zero out the suffixId field from an item link, and also replace the name with the un-suffixed name.
function AuctionLite:RemoveSuffix(link)
  if link ~= nil then
    if AuctionLite:IsBattlePetLink(link) then
      return link
    end
    
    local name, _, id = AuctionLite:SplitLink(link)
    local baseName = GetItemInfo(id)
    return link:gsub(
        -- Fields: itemID, enchant, gem1, gem2, gem3, gem4.
        "(Hitem:%-?%d*:%-?%d*:%-?%d*:%-?%d*:%-?%d*:%-?%d*)" ..
        -- Fields: suffixID.
        ":%-?%d*",
        -- Set suffixID to 0.
         "%1:"):gsub(name, baseName)
  else
    return nil;
  end
end

-- Get auction sell item info as well as a link to the item and the
-- location of the item in the player's bags.  We use the fact that it
-- must be locked (since it's in the auction slot).  Returns nil if the
-- item is not found or if we can't pinpoint the exact bag slot.
function AuctionLite:GetAuctionSellItemInfoAndLink()
  local name, texture, count, quality, canUse, price = GetAuctionSellItemInfo();

  local link = nil;
  local container = nil;
  local slot = nil;

  if name ~= nil then
    local i, j;

    -- Look through the bags to find a matching item.
    for i = 0, 4 do
      local numItems = GetContainerNumSlots(i);
      for j = 1, numItems do
        local _, curCount, locked = GetContainerItemInfo(i, j);
        if count == curCount and locked then
          -- We've found a partial match.  Now check the name...
          local curLink = GetContainerItemLink(i, j);
          local curName = self:SplitLink(curLink);
          if name == curName then
            if link == nil then
              -- It's our first match--make a note of it.
              link = self:RemoveUniqueId(curLink);
              container = i;
              slot = j;
            else
              -- Ambiguous result.  Bail!
              return;
            end
          end
        end
      end
    end
  end

  -- Return all the original item info plus our three results.
  return name, texture, count, quality, canUse, price, link, container, slot;
end

-- Get the maximum stack size for an item.
function AuctionLite:GetMaxStackSize(link)
  local _, _, _, _, _, _, _, maxSize = GetItemInfo(link);
  if maxSize == nil then
    maxSize = 1;
  end
  return maxSize;
end

-- Make a money frame value negative.
function AuctionLite:MakeNegative(frameName)
  local adjust = function(button)
    local current = button:GetText();
    if button:IsShown() then
      button:SetText("-" .. current);
      return true;
    else
      return false;
    end
  end

	local goldButton = getglobal(frameName .. "GoldButton");
  if not adjust(goldButton) then
    local silverButton = getglobal(frameName .. "SilverButton");
    if not adjust(silverButton) then
      local copperButton = getglobal(frameName .. "CopperButton");
      adjust(copperButton);
    end
  end
end

-- Truncates a UTF-8 string to a fixed number of bytes.
function AuctionLite:Truncate(str, bytes)
  -- We need to make sure that we don't truncate mid-character, and in
  -- UTF-8, all mid-character bytes start with bits 10.  So, reduce bytes
  -- until the first character we're dropping does not start with 10.

  if str:len() > bytes then
    while bytes > 0 and bit.band(str:byte(bytes + 1), 0xc0) == 0x80 do
      bytes = bytes - 1;
    end
  end

  return str:sub(1, bytes);
end

-- Get a listing from the auction house.
function AuctionLite:GetListing(kind, i)
  -- There has *got* to be a better way to do this...
  local link = self:RemoveUniqueId(GetAuctionItemLink(kind, i));
  local name, texture, count, quality, canUse, level,
        levelColHeader, minBid, minIncrement, buyout, bidAmount,
        highBidder, bidderFullName, owner, ownerFullName, sold =
        GetAuctionItemInfo(kind, i);

  -- Figure out the true minimum bid.
  local bid;
  if bidAmount <= 0 then
    bid = minBid;
  else
    bid = bidAmount + minIncrement;
    if bid > buyout and buyout > 0 then
      bid = buyout;
    end
  end

  -- Create a listing object with all this data.
  local listing = {
    link = link, name = name, texture = texture, count = count,
    quality = quality, canUse = canUse, level = level,
    bid = bid, minBid = minBid, minIncrement = minIncrement,
    buyout = buyout, bidAmount = bidAmount,
    highBidder = highBidder, owner = owner, sold = sold
  };

  return listing;
end

-- Does a target from the "Buy" frame match an auction listing?
-- TODO: Get rid of the targetName hackery.
function AuctionLite:MatchListing(targetName, target, listing)
  return targetName == listing.name and
         target.count == listing.count and
         target.bid == listing.bid and
         target.buyout == listing.buyout and
         (target.owner == nil or listing.owner == nil or
          target.owner == listing.owner);
end

-- Do two pages from an AH scan match exactly?
function AuctionLite:MatchPages(data, page1, page2)
  local i;
  for i = 1, NUM_AUCTION_ITEMS_PER_PAGE do
    local listing1 = data[page1 * NUM_AUCTION_ITEMS_PER_PAGE + i];
    local listing2 = data[page2 * NUM_AUCTION_ITEMS_PER_PAGE + i];
    if listing1 == nil or listing2 == nil or
       not self:MatchListing(listing1.name, listing1, listing2) then
      return false;
    end
  end

  return true;
end

-- Get the names of all my auctions.
function AuctionLite:GetMyAuctionLinks()
  local batch = GetNumAuctionItems("owner");
  local links = {};

  -- Find all the auctions to cancel.
  local i;
  for i = 1, batch do
    local listing = self:GetListing("owner", i);
    if listing.sold ~= 1 then
      links[listing.link] = true;
    end
  end

  return links;
end

-- Is the specified item (name or link) a favorite, optionally in a specific
-- favorites list?
function AuctionLite:IsFavorite(item, list)
  local name = self:SplitLink(item);
  local link;

  if name == nil then
    name = item;
    link = nil;
  else
    link = item;
  end
  name = strlower(name);

  local searchList = function(list)
    if list[link] ~= nil then
      return link;
    else
      for item, _ in pairs(list) do
        local itemName = self:SplitLink(item);
        if itemName == nil then
          itemName = item;
        end
        if strlower(itemName) == name then
          return item;
        end
      end
      return nil;
    end
  end

  if list ~= nil then
    return searchList(list);
  else
    for _, list in pairs(self.db.profile.favorites) do
      local result = searchList(list);
      if result then
        return result;
      end
    end
    return nil;
  end
end

-- If there's exactly one favorites list, get it.  Otherwise, return nil.
function AuctionLite:GetSingleFavoritesList()
  local found = nil;
  for _, list in pairs(self.db.profile.favorites) do
    if found == nil then
      found = list;
    else
      return nil;
    end
  end

  -- Sanity check: If there are no favorites lists, make one.
  if found == nil then
    found = {};
    self.db.profile.favorites = { [L["Favorites"]] = found };
  end

  return found;
end

-- Sort the columns by the designated sort type.
function AuctionLite:ApplySort(info, data, cmp)
  local fn = function(a, b)
    if cmp(a, b) == cmp(b, a) then
      if info.justFlipped then
        return a.orig < b.orig;
      else
        return b.orig < a.orig;
      end
    else
      if info.flipped then
        return cmp(b, a);
      else
        return cmp(a, b);
      end
    end
  end

  local i = 1;

  local item;
  for _, item in ipairs(data) do
    item.orig = i;
    i = i + 1;
  end

  table.sort(data, fn);

  local item;
  for _, item in ipairs(data) do
    item.orig = nil;
  end

  info.sorted = true;
  info.justFlipped = false;
end

-- Update the current sort for a click.
function AuctionLite:SortButton_OnClick(info, sort)
  if info.sort == sort then
    info.flipped = not info.flipped;
  else
    info.sort = sort;
    info.flipped = false;
    info.justFlipped = true;
  end

  info.sorted = false;
end

-- Update sortable header buttons.
function AuctionLite:UpdateSortButton(prefix, buttonName, text)
  local button = _G[prefix .. buttonName .. "Button"];
  local arrow = _G[prefix .. buttonName .. "ButtonArrow"];
  button:SetText(text);
  local offset = button:GetTextWidth();
  if offset > button:GetWidth() - 10 then
    offset = button:GetWidth() - 10;
  end
  arrow:SetPoint("RIGHT", button, "RIGHT", -offset - 1, -1);
end

-- Update sort arrows.
function AuctionLite:UpdateSortArrow(prefix, buttonSort, sort, flipped)
  local arrow = _G[prefix .. buttonSort .. "ButtonArrow"];
  if buttonSort == sort then
    arrow:Show();
    if flipped then
			arrow:SetTexCoord(0, 0.5625, 1.0, 0);
		else
		  arrow:SetTexCoord(0, 0.5625, 0, 1.0);
    end
  else
    arrow:Hide();
  end
end

-- Table of ignored chat messages (msg -> count).
local IgnoreTable = {};

-- Filter out "ignored" messages.
function AuctionLite:MessageEventFilter(frame, event, arg1, ...)
  local count = IgnoreTable[arg1];
  if count ~= nil then
    IgnoreTable[arg1] = (count > 1) and (count - 1) or nil;
    return true;
  else
    return false, arg1, ...;
  end
end

-- Ignore "count" instances of "msg" in the chat window.
function AuctionLite:IgnoreMessage(msg, count)
  -- Find out how many windows listen for this message.
  local mult = 0;
  for i = 1, NUM_CHAT_WINDOWS do
    local messages = { GetChatWindowMessages(i) };
    for _, message in ipairs(messages) do
      if message == "SYSTEM" then
        mult = mult + 1;
        break;
      end
    end
  end

  -- Increment the ignore table entry by an appropriate amount.
  count = count or 1;
  cur = IgnoreTable[msg] or 0;
  IgnoreTable[msg] = cur + (count * mult);
end
