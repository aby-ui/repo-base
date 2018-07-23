-------------------------------------------------------------------------------
-- External.lua
--
-- Implement external API.
-------------------------------------------------------------------------------

local _

-- External interface for vendor values.
-- Deprecated due to addition of built-in vendor values.
function AuctionLite:GetVendorValue()
  return nil;
end

-- External interface for auction values.
function AuctionLite:GetAuctionValue(arg1, arg2)
  local result = nil;

  -- If we got a number, use it.
  -- If we got a string or a link, parse it.
  local id;
  local suffix;
  if type(arg1) == "number" then
    id = arg1;
    suffix = arg2;
    if suffix == nil then
      suffix = 0;
    end
  elseif type(arg1) == "string" then
    _, _, id, suffix = self:SplitLink(arg1);
  end

  -- Now look up the price.
  if id ~= nil then
    local hist = self:GetHistoricalPriceById(id, suffix);
    if hist ~= nil then
      result = math.floor(hist.price);
    end
  end

  return result;
end

-- Implement Tekkub's GetAuctionBuyout.
local origGetAuctionBuyout = GetAuctionBuyout;
function GetAuctionBuyout(item)
  return AuctionLite:GetAuctionValue(item) or
         (origGetAuctionBuyout and origGetAuctionBuyout(item));
end
