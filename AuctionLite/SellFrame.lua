-------------------------------------------------------------------------------
-- SellFrame.lua
--
-- Implements the "Sell" tab.
-------------------------------------------------------------------------------

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

-- Constants for display elements.
local SELL_DISPLAY_SIZE = 16;

-- Pricing methods.
local METHOD_PER_ITEM = 1;
local METHOD_PER_STACK = 2;

-- Durations.
local DURATION_SHORT = 1;
local DURATION_MEDIUM = 2;
local DURATION_LONG = 3;

-- Current sorting state.
local SellSort = {
  sort = "BuyoutEach",
  flipped = false,
  justFlipped = false,
  sorted = false,
};

-- Info about data to be shown in scrolling pane.
local SellLink = nil;
local SellData = {};

-- Value of item currently in "Sell" tab.
local ItemValue = nil;

-- User-specified bid and buyout values for current item.
local ItemBid = nil;
local ItemBuyout = nil;

-- Can we undercut the current item value?
local AllowUndercut = nil;

-- Status shown in auction posting frame.
local StatusMessage = "";
local StatusError = false;

-- Number of times the user has edited the size box.
local ChangedSize = 0;

-- Previous prices set by the user.
local SavedPrices = {};

-- Add a money type that updates the deposit correctly.
MoneyTypeInfo["AUCTIONLITE_DEPOSIT"] = {
  UpdateFunc = function() return AuctionLite:CalculateDeposit() end,
  collapse = 1,
}

-- Determine the correct deposit for a single item.
function AuctionLite:CalculateDeposit()
  local time = self:GetDuration();
  local stacks = SellStacks:GetNumber();
  local size = SellSize:GetNumber();

  local startPrice = MoneyInputFrame_GetCopper(SellBidPrice);
  local buyoutPrice = MoneyInputFrame_GetCopper(SellBuyoutPrice);

  return GetAuctionDeposit(time, startPrice, buyoutPrice, size, stacks);
end

-- Update the deposit field.
function AuctionLite:UpdateDeposit()
  MoneyFrame_Update("SellDepositMoneyFrame", self:CalculateDeposit());
end

-- Generate a suggested bid and buyout from the market value.  We undercut
-- and round prices according to the user's settings.
function AuctionLite:GeneratePrice(value, allowUndercut)
  -- Find out how to round prices.
  local granularity = 1;
  if self.db.profile.roundPrices > 0 then
    granularity = math.pow(10, math.floor(math.log10(value))) *
                  self.db.profile.roundPrices;
  end

  -- How much do we undercut?
  -- Bid undercut applies all the time; buyout only when allowed.
  local bidUndercut = self.db.profile.bidUndercut;
  local buyoutUndercut = self.db.profile.buyoutUndercut;

  local bidUndercutFixed = self.db.profile.bidUndercutFixed;
  local buyoutUndercutFixed = self.db.profile.buyoutUndercutFixed;

  if bidUndercutFixed > 0 or buyoutUndercutFixed > 0 then granularity = 1 end --163ui 2016.9

  if not allowUndercut then
    buyoutUndercut = 0;
    buyoutUndercutFixed = 0;
  end

  -- Undercut bid and buyout as specified.
  local generate = function(value, undercut, undercutFixed, granularity)
    return math.max(1, math.floor((value * (1 - undercut)) / granularity) *
                       granularity - undercutFixed);
  end

  local bid =
    generate(value, bidUndercut, bidUndercutFixed, granularity);

  local buyout =
    generate(value, buyoutUndercut, buyoutUndercutFixed, granularity);

  return bid, max(bid, buyout);
end

-- Generate price, and dump some data to the console.
function AuctionLite:ShowPriceData(itemLink, itemValue, stackSize)
  local hist = self:GetHistoricalPrice(itemLink);

  local stackValue = itemValue * stackSize;

  local _, _, count, _, _, vendor = GetAuctionSellItemInfo();
  local itemVendor = vendor / count;

  self:Print(L["|cff8080ffData for %s x%d|r"]:format(itemLink, stackSize));
  self:Print(L["Vendor: %s"]:format(self:PrintMoney(itemVendor * stackSize)));

  if hist ~= nil and hist.scans > 0 and hist.price > 0 then
    self:Print(L["Historical: %s (%d |4listing:listings;/scan, %d |4item:items;/scan)"]:
               format(self:PrintMoney(hist.price * stackSize),
                      math.floor(0.5 + hist.listings / hist.scans),
                      math.floor(0.5 + hist.items / hist.scans)));
    if itemVendor > 0 then
      self:Print(L["Current: %s (%.2fx historical, %.2fx vendor)"]:
                 format(self:PrintMoney(stackValue),
                        math.floor(100 * itemValue / hist.price) / 100,
                        math.floor(100 * itemValue / itemVendor) / 100));
    else
      self:Print(L["Current: %s (%.2fx historical)"]:
                 format(self:PrintMoney(stackValue),
                        math.floor(100 * itemValue / hist.price) / 100));
    end
  elseif itemVendor > 0 then
    self:Print(L["Current: %s (%.2fx vendor)"]:
               format(self:PrintMoney(stackValue),
                      math.floor(100 * itemValue / itemVendor) / 100));
  end

  return bid, buyout;
end

-- Set the market value for the current item.
function AuctionLite:SetItemValue(value, allowUndercut)
  ItemValue = value;
  AllowUndercut = allowUndercut;

  ItemBid = nil;
  ItemBuyout = nil;
end

-- Set the user-specified bid and buyout.
function AuctionLite:SetItemBidBuyout(bid, buyout)
  if bid ~= nil then
    ItemBid = bid;
  end

  if buyout ~= nil then
    ItemBuyout = buyout;
  end
end

-- Set the number of stacksto the maximum value based on the current stack size
function AuctionLite:SellStacksMaxButton_OnClick()
  local _, _, _, _, _, _, link = self:GetAuctionSellItemInfoAndLink();

  if link ~= nil then
    local size = SellSize:GetNumber();
    local numItems = self:CountItems(link);

	local stacks = (numItems - numItems % size) / size;

	SellStacks:SetText(stacks);
    AuctionLite:UserChangedSize();
  end
end

-- Set the stack size to the maximum value based on the current number of stacks
function AuctionLite:SellSizeMaxButton_OnClick()
  local _, _, _, _, _, _, link = self:GetAuctionSellItemInfoAndLink();

  if link ~= nil then
    local stacks = SellStacks:GetNumber();
    local numItems = self:CountItems(link);

	local size = (numItems - numItems % stacks) / stacks;

	SellSize:SetText(size);
    AuctionLite:UserChangedSize();
  end
end

-- Indicate that the user has messed with the stack size.
function AuctionLite:UserChangedSize()
  ChangedSize = ChangedSize + 1;

  self:UpdateDeposit();
  self:UpdatePrices();

  self:ValidateAuction();
end

-- Update the stack size based on a change in the number of stacks.
function AuctionLite:UserChangedStacks()
  -- If the user hasn't already specified a size, adjust the size to
  -- fit the number of stacks entered.
  if ChangedSize <= 0 then
    local _, _, _, _, _, _, link = self:GetAuctionSellItemInfoAndLink();

    if link ~= nil then
      local size = SellSize:GetNumber();
      local stacks = SellStacks:GetNumber();
      local numItems = self:CountItems(link);

      -- If we don't have enough items to fill the order, then we need to
      -- modify the stack size.
      if numItems < size * stacks then
        -- Get our new stack size.
        local newSize = math.floor(numItems / stacks);

        -- Make sure the stack is not too large.
        local maxSize = self:GetMaxStackSize(link);
        if maxSize < newSize then
          newSize = maxSize;
        end

        -- Update the size.
        if newSize ~= size then
          ChangedSize = ChangedSize - 1;
          SellSize:SetText(newSize);
        end
      end
    end
  end

  self:UpdateDeposit();
  self:ValidateAuction();
end

-- Fill in suggested prices based on a query result or a change in the
-- stack size.
function AuctionLite:UpdatePrices()
  if ItemValue ~= nil then
    local bid, buyout = self:GeneratePrice(ItemValue, AllowUndercut);
    if ItemBid ~= nil then
      bid = ItemBid;
    end
    if ItemBuyout ~= nil then
      buyout = ItemBuyout;
    end

    -- If we're pricing by stack, multiply by our stack size.
    if self.db.profile.method == METHOD_PER_STACK then
      local stackSize = SellSize:GetNumber();
      bid = bid * stackSize;
      buyout = buyout * stackSize;
    end

    MoneyInputFrame_SetCopper(SellBidPrice, math.floor(bid + 0.5));
    SellBidPrice.expectChanges = SellBidPrice.expectChanges + 1;

    MoneyInputFrame_SetCopper(SellBuyoutPrice, math.floor(buyout + 0.5));
    SellBuyoutPrice.expectChanges = SellBuyoutPrice.expectChanges + 1;

    -- Validate auction and enable create button.
    self:ValidateAuction();
  end
end

-- Check whether there are any errors in the auction.
function AuctionLite:ValidateAuction()
  local name, _, count, _, _, vendor, link =
    self:GetAuctionSellItemInfoAndLink();

  if name ~= nil and not self:QueryInProgress() then
    local bid = MoneyInputFrame_GetCopper(SellBidPrice);
    local buyout = MoneyInputFrame_GetCopper(SellBuyoutPrice);

    local stacks = SellStacks:GetNumber();
    local size = SellSize:GetNumber() or 1;

    local numItems = self:CountItems(link);
    local maxSize = self:GetMaxStackSize(link);

    -- If we're pricing by item, get the full stack price.
    if self.db.profile.method == METHOD_PER_ITEM then
      bid = bid * size;
      buyout = buyout * size;
    end

    -- Now perform our checks.
    if stacks * size <= 0 then
      StatusError = true;
      SellStatusText:SetText(L["|cffff0000Invalid stack size/count.|r"]);
      SellCreateAuctionButton:Disable();
    elseif maxSize < size then
      StatusError = true;
      SellStatusText:SetText(L["|cffff0000Stack size too large.|r"]);
      SellCreateAuctionButton:Disable();
    elseif numItems < stacks * size then
      StatusError = true;
      SellStatusText:SetText(L["|cffff0000Not enough items available.|r"]);
      SellCreateAuctionButton:Disable();
    elseif bid == 0 then
      StatusError = true;
      SellStatusText:SetText(L["|cffff0000No bid price set.|r"]);
      SellCreateAuctionButton:Disable();
    elseif 0 < buyout and buyout < bid then
      StatusError = true;
      SellStatusText:SetText(L["|cffff0000Buyout less than bid.|r"]);
      SellCreateAuctionButton:Disable();
    elseif GetMoney() < self:CalculateDeposit() then
      StatusError = true;
      SellStatusText:SetText(L["|cffff0000Not enough cash for deposit.|r"]);
      SellCreateAuctionButton:Disable();
    elseif 0 < buyout and buyout <= (vendor * size / count) then
      StatusError = true;
      SellStatusText:SetText(L["|cffff7030Buyout less than vendor price.|r"]);
      SellCreateAuctionButton:Enable();
    else
      StatusError = false;
      SellStatusText:SetText(StatusMessage);
      SellCreateAuctionButton:Enable();
    end
  end
end

-- There's been a click on the auction sell item slot.
function AuctionLite:ClickAuctionSellItemButton_Hook()
  -- Ignore clicks that we generated ourselves.
  if AuctionFrameSell:IsShown() and not self:CreateInProgress() then
    -- Clear everything first.
    self:ClearSellFrame();

    -- If we've got a new item in the auction slot, fill out the fields.
    local name, texture, count, _, _, _, link =
      self:GetAuctionSellItemInfoAndLink();

    if name ~= nil then
      local maxSize = self:GetMaxStackSize(link);

      SellItemButton:SetNormalTexture(texture);
      SellItemButtonName:SetText(name);

      if count > 1 then
        SellItemButtonCount:SetText(count);
        SellItemButtonCount:Show();
      else
        SellItemButtonCount:Hide();
      end

      local total = self:CountItems(link);
      local prefs = self:GetSavedPrices(link);

      local size = count;
      if prefs ~= nil and prefs.stackSize ~= nil then
        size = prefs.stackSize;
      elseif self.db.profile.defaultSize == "a_one" then
        size = 1;
      elseif self.db.profile.defaultSize == "b_stack" then
        size = count;
      elseif self.db.profile.defaultSize == "c_full" then
        size = maxSize;
        if size > total then
          size = total;
        end
      end

      local stacks = 1;
      if prefs ~= nil and prefs.stackCount ~= nil then
        stacks = prefs.stackCount;
      elseif self.db.profile.defaultStacks == "a_one" then
        stacks = 1;
      elseif self.db.profile.defaultStacks == "b_full" then
        stacks = math.floor(total / size);
      elseif self.db.profile.defaultStacks == "c_excess" then
        stacks = math.ceil(total / size);
      end

      if size ~= SellSize:GetNumber() then
        ChangedSize = ChangedSize - 1;
      end

      SellStacks:SetText(stacks);
      SellSize:SetText(size);

      SellStacks:SetFocus();

      SellStackText:SetText(
        L["Number of Items |cff808080(max %d)|r"]:format(total));

      self:UpdateDeposit();

      if IsControlKeyDown() then
        -- Just pretend the scan finished.
        self:Print(L["Auction scan skipped (control key is down)"]);
        self:SetSellData({}, link);
      else
        -- Start the scan.
        local query = {
          link = link,
          exact = true,
          update = function(pct, getAll, rawData)
              AuctionLite:UpdateProgressSell(pct)
              if rawData then
                  local data = AuctionLite:AnalyzeData(rawData);
                  AuctionLite:SetSellData(data, link, true)
              end
              AuctionLiteStopAuction:Show()
          end,
          finish = function(data, link) AuctionLite:SetSellData(data, link) end,
        };

        self:StartQuery(query);
        AuctionLiteStopAuction.query = query
      end
    end
  end
end

-- Forget all our saved prices.
function AuctionLite:ClearSavedPrices()
  SavedPrices = {};
end

-- Clean up the "Sell" tab.
function AuctionLite:ClearSellFrame()
  self:CancelQuery();

  SellSort = {
    sort = "BuyoutEach",
    flipped = false,
    justFlipped = false,
    sorted = false,
  };

  SellLink = nil;
  SellData = {};

  ItemValue = nil;
  ItemBid = nil;
  ItemBuyout = nil;
  AllowUndercut = nil;

  ChangedSize = 0;

  SellItemButton:SetNormalTexture(nil);
  SellItemButtonName:SetText("");
  SellItemButtonCount:Hide();

  SellStackText:SetText(L["Number of Items"]);
  SellStacks:SetText("");
  SellSize:SetText("");

  MoneyInputFrame_ResetMoney(SellBidPrice);
  MoneyInputFrame_ResetMoney(SellBuyoutPrice);

  SellCreateAuctionButton:Disable();
  SellRememberButton:Disable();
  AuctionLiteStopAuction:Hide();

  StatusError = false;
  self:SetStatus("");
  self:UpdateDeposit();

  FauxScrollFrame_SetOffset(SellScrollFrame, 0);

  self:AuctionFrameSell_Update();
end

-- Set the status line.
function AuctionLite:SetStatus(message)
  StatusMessage = message;
  if not StatusError then
    SellStatusText:SetText(message);
  end
end

-- Get our query results.
function AuctionLite:SetSellData(results, link, updating)
  -- Set the competing auction display.
  local result = results[link];
  if result ~= nil then
    local filtered = {};

    local i;
    for _, listing in ipairs(result.data) do
      if listing.buyout > 0 then
        table.insert(filtered, listing);
      end
    end

    SellLink = link;
    SellData = filtered;

    SellSort = {
      sort = "BuyoutEach",
      flipped = false,
      justFlipped = false,
      sorted = false,
    };
  end

  -- Get our recommended item value.
  local itemValue = 0;
  local allowUndercut = true;
  if result ~= nil and result.price > 0 then
    itemValue = result.price;
    if result.priceIsMine then
      allowUndercut = false;
    end
    if not updating then
    if self.db.profile.printPriceData then
      self:ShowPriceData(link, itemValue, SellSize:GetNumber());
    end
    self:SetStatus(L["|cff00ff00Scanned %d listings.|r"]:
                   format(result.listings));
    end
  else
    local hist = self:GetHistoricalPrice(link);
    if hist ~= nil and hist.price > 0 then
      itemValue = hist.price;
      self:SetStatus(L["|cffffd000Using historical data.|r"]);
    else
      local _, _, count, _, _, vendor = GetAuctionSellItemInfo();
      local mult = self.db.profile.vendorMultiplier;
      itemValue = mult * vendor / count;
      self:SetStatus(L["|cffff0000Using %.3gx vendor price.|r"]:
                     format(mult));
    end
    allowUndercut = false;
  end
  self:SetItemValue(itemValue, allowUndercut);

  -- Load the user's saved price, if it exists.
  local saved = SavedPrices[link];
  if saved ~= nil then
    if not updating then self:SetStatus(L["|cff00ff00Using previous price.|r"]); end
    self:SetItemBidBuyout(saved.bid, saved.buyout);
  end

  -- Load long-term saved prices.
  local prefs = self:GetSavedPrices(link);
  if prefs ~= nil then
    self:SetItemBidBuyout(prefs.bid, prefs.buyout);
  end

  -- Active the remember menu.
  if not updating then
  SellRememberButton:Enable();
  AuctionLiteStopAuction:Hide();
  end

  -- Update the UI.
  self:UpdatePrices();
  self:AuctionFrameSell_Update();
end

-- Save the current prices for later use.
function AuctionLite:RecordSellPrices()
  if ItemBid ~= nil and ItemBuyout ~= nil then
    local _, _, _, _, _, _, link = self:GetAuctionSellItemInfoAndLink();
    if link then
      SavedPrices[link] = { bid = ItemBid, buyout = ItemBuyout };
    end
  end
end

-- Static popup warning for clearing data.
StaticPopupDialogs["AL_VENDOR_WARNING"] = {
  text = L["VENDOR_WARNING"],
  button1 = L["Do it!"],
  button2 = L["Cancel"],
  OnAccept = function(self)
    AuctionLite:RecordSellPrices();
    AuctionLite:CreateAuctions();
  end,
  showAlert = 1,
  timeout = 0,
  exclusive = 1,
  hideOnEscape = 1,
  preferredIndex = 3
};

-- We've clicked the "Create" button (or pressed enter).
function AuctionLite:SellCreateAuctionButton_OnClick()
  local _, _, count, _, _, vendor = GetAuctionSellItemInfo();
  local buyout = MoneyInputFrame_GetCopper(SellBuyoutPrice);
  local size = SellSize:GetNumber();

  -- If we're pricing by item, get the full stack price.
  if self.db.profile.method == METHOD_PER_ITEM then
    buyout = buyout * size;
  end

  -- If we're below vendor price, warn; otherwise, sell.
  if 0 < buyout and buyout <= (vendor * size / count) then
    StaticPopup_Show("AL_VENDOR_WARNING");
  else
    self:RecordSellPrices();
    self:CreateAuctions();
  end
end

-- Handles clicks on buttons in the "Competing Auctions" display.
-- Get the appropriate auction and undercut it!
function AuctionLite:SellButton_OnClick(id)
  local offset = FauxScrollFrame_GetOffset(SellScrollFrame);
  local item = SellData[offset + id];

  if item ~= nil then
    if item.owner == UnitName("player") then
      self:SetItemBidBuyout(item.bid / item.count, item.buyout / item.count);
    else
      self:SetItemValue(item.price, true);
    end

    self:UpdatePrices();
  end
end

-- Mouse has entered a row in the scrolling frame.
function AuctionLite:SellButton_OnEnter(widget)
  -- Get our index into the current display data.
  local offset = FauxScrollFrame_GetOffset(SellScrollFrame);
  local id = widget:GetID();

  -- If there's an item at this location, create a tooltip for it.
  local item = SellData[offset + id];
  local _, _, _, _, _, _, link = self:GetAuctionSellItemInfoAndLink();
  if item ~= nil and link ~= nil then
    local shift = SellButton1Name:GetLeft() - SellButton1Count:GetLeft();
    self:SetAuctionLiteTooltip(widget, shift, link, item.count);
  end
end

-- Mouse has left a row in the scrolling frame.
function AuctionLite:SellButton_OnLeave(widget)
  GameTooltip:Hide();
  BattlePetTooltip:Hide();
end

-- Handles clicks on "Remember" button.
function AuctionLite:SellRememberButton_OnClick(widget)
  local _, _, _, _, _, _, link = self:GetAuctionSellItemInfoAndLink();

  if link ~= nil then
    local prefs = self:GetSavedPrices(link);

    local menuList = {
      {
        text = L["Saved Item Settings"],
        isTitle = true,
      },
    };

    -- Add items for each of our saved variables, including the
    -- current saved value if there is one.
    local addMenuItem = function(name, field, isMoney, fn)
      local value = prefs[field];
      if value ~= nil then
        if isMoney then
          if self.db.profile.method == METHOD_PER_STACK then
            local stackSize = SellSize:GetNumber();
            value = value * stackSize;
          end
          value = self:PrintMoney(value);
        end
      else
        value = "|cffc0c0c0" .. L["(none set)"] .. "|r";
      end
      local menuItem = {
        text = name .. ": " .. value,
        func = function()
          if prefs[field] ~= nil then
            prefs[field] = nil;
          else
            local newValue = fn();
            if isMoney and self.db.profile.method == METHOD_PER_STACK then
              local stackSize = SellSize:GetNumber();
              newValue = newValue / stackSize;
            end
            prefs[field] = newValue;
          end
          self:SetSavedPrices(link, prefs);
        end,
      };
      if prefs[field] ~= nil then
        menuItem.checked = true;
      end
      table.insert(menuList, menuItem);
    end

    addMenuItem(L["Stack Count"], "stackCount", false, function()
      return SellStacks:GetNumber();
    end);

    addMenuItem(L["Stack Size"], "stackSize", false, function()
      return SellSize:GetNumber();
    end);

    addMenuItem(L["Bid Price"], "bid", true, function()
      return MoneyInputFrame_GetCopper(SellBidPrice);
    end);

    addMenuItem(L["Buyout Price"], "buyout", true, function()
      return MoneyInputFrame_GetCopper(SellBuyoutPrice);
    end);

    -- Add the save/clear all items.
    table.insert(menuList, {
      text = "",
    });

    table.insert(menuList, {
      text = L["Save All"],
      func = function()
        local i;
        for i = 2, 5 do
          local item = menuList[i];
          if not item.checked then
            item.func();
          end
        end
      end,
    });

    table.insert(menuList, {
      text = L["Clear All"],
      func = function()
        local i;
        for i = 2, 5 do
          local item = menuList[i];
          if item.checked then
            item.func();
          end
        end
      end,
    });

    -- Now show/hide the menu.
    SellRememberDropDown.displayMode = "MENU";
    SellRememberDropDown.initialize = EasyMenu_Initialize;
    SellRememberDropDown.point = "TOPRIGHT";
    SellRememberDropDown.relativeTo = "SellRememberButton";
    SellRememberDropDown.relativePoint = "BOTTOMRIGHT";
    ToggleDropDownMenu(1, nil, SellRememberDropDown,
                       "SellRememberButton", 0, 0, menuList);
  end
end

-- Get the auction duration.
function AuctionLite:GetDuration()
  local time = 0;

  if SellShortAuctionButton:GetChecked() then
    time = 1;
  elseif SellMediumAuctionButton:GetChecked() then
    time = 2;
  elseif SellLongAuctionButton:GetChecked() then
    time = 3;
  end

  return time;
end

-- Handle updates to the auction duration.
function AuctionLite:ChangeAuctionDuration(value)
  self.db.profile.duration = value;

  SellShortAuctionButton:SetChecked(nil);
  SellMediumAuctionButton:SetChecked(nil);
  SellLongAuctionButton:SetChecked(nil);

  if value == DURATION_SHORT then
    SellShortAuctionButton:SetChecked(true);
  elseif value == DURATION_MEDIUM then
    SellMediumAuctionButton:SetChecked(true);
  elseif value == DURATION_LONG then
    SellLongAuctionButton:SetChecked(true);
  end

  self:UpdateDeposit();
end

-- Handle updates to the pricing method.
function AuctionLite:ChangePricingMethod(value)
  local prevValue = self.db.profile.method;
  self.db.profile.method = value;

  local stackSize = SellSize:GetNumber();

  -- Clear everything.
  SellPerItemButton:SetChecked(nil);
  SellPerStackButton:SetChecked(nil);

  -- Now update the UI based on the new value.
  if value == METHOD_PER_ITEM then
    SellPerItemButton:SetChecked(true);

    SellBidStackText:SetText(L["|cff808080(per item)|r"]);
    SellBuyoutStackText:SetText(L["|cff808080(per item)|r"]);
  elseif value == METHOD_PER_STACK then
    SellPerStackButton:SetChecked(true);

    SellBidStackText:SetText(L["|cff808080(per stack)|r"]);
    SellBuyoutStackText:SetText(L["|cff808080(per stack)|r"]);
  end

  -- Update the listed prices based on the new pricing method.
  self:UpdatePrices();
end

-- User changed the prices manually.
function AuctionLite:UserChangedPrices()
  -- Get the user's values.
  local bid = MoneyInputFrame_GetCopper(SellBidPrice);
  local buyout = MoneyInputFrame_GetCopper(SellBuyoutPrice);

  -- If we're pricing by stack, divide by our stack size.
  if self.db.profile.method == METHOD_PER_STACK then
    local stackSize = SellSize:GetNumber();
    bid = bid / stackSize;
    buyout = buyout / stackSize;
  end

  -- Set our new state.
  self:SetItemBidBuyout(bid, buyout);
end

-- Update query progress.
function AuctionLite:UpdateProgressSell(pct)
  self:SetStatus(L["|cffffff00Scanning: %d%%|r"]:format(pct));
end

-- Apply the current sort.
function AuctionLite:ApplySellSort()
  local info = SellSort;
  local data = SellData;

  local cmp;
  if info.sort == "ItemName" then
    cmp = function(a, b) return a.count < b.count end;
  elseif info.sort == "BuyoutEach" then
    cmp = function(a, b) return a.buyout / a.count < b.buyout / b.count end;
  elseif info.sort == "BuyoutAll" then
    cmp = function(a, b) return a.buyout < b.buyout end;
  else
    assert(false);
  end

  self:ApplySort(info, data, cmp);
end

-- Set a new sort type for the "Sell" tab.
function AuctionLite:SellSortButton_OnClick(sort)
  assert(sort == "ItemName" or sort == "BuyoutEach" or sort == "BuyoutAll");

  self:SortButton_OnClick(SellSort, sort);
  self:AuctionFrameSell_Update();
end

-- Paint the scroll frame on the right-hand side with competing auctions.
function AuctionLite:AuctionFrameSell_Update()
  if not SellSort.sorted then
    self:ApplySellSort();
  end

  local sort;
  for _, sort in ipairs({ "ItemName", "BuyoutEach", "BuyoutAll" }) do
    self:UpdateSortArrow("Sell", sort, SellSort.sort, SellSort.flipped);
  end

  local offset = FauxScrollFrame_GetOffset(SellScrollFrame);

  local name, color, enchant, jewel1, jewel2, jewel3, jewel4;
  local showPlus;

  if SellLink ~= nil then
    name, color, _, _, enchant, jewel1, jewel2, jewel3, jewel4 =
      self:SplitLink(SellLink);

    showPlus = enchant ~= 0 or
               jewel1 ~= 0 or jewel2 ~= 0 or
               jewel3 ~= 0 or jewel4 ~= 0;
  end

  local i;
  for i = 1, SELL_DISPLAY_SIZE do
    local item = SellData[offset + i];

    local buttonName = "SellButton" .. i;
    local button = _G[buttonName];

    if item ~= nil then
      local countText = _G[buttonName .. "Count"];
      local nameText = _G[buttonName .. "Name"];
      local plusText = _G[buttonName .. "Plus"];
      local buyoutEachFrame = _G[buttonName .. "BuyoutEachFrame"];
      local buyoutFrame = _G[buttonName .. "BuyoutFrame"];

      local alpha;
      if item.owner ~= UnitName("player") and not item.keep then
        alpha = 0.5;
      else
        alpha = 1.0;
      end

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
      countText:SetAlpha(alpha);

      nameText:SetText("|c" .. nameColor .. name .. "|r");
      nameText:SetAlpha(alpha);

      if showPlus then
        plusText:SetPoint("LEFT", nameText, "LEFT",
                          nameText:GetStringWidth(), 0);
        plusText:Show();
      else
        plusText:Hide();
      end

      MoneyFrame_Update(buyoutEachFrame, math.floor(item.buyout / item.count + 0.5));
      buyoutEachFrame:SetAlpha(alpha);

      MoneyFrame_Update(buyoutFrame, math.floor(item.buyout + 0.5));
      buyoutFrame:SetAlpha(alpha);

      button:Show();
    else
      button:Hide();
    end
  end

  FauxScrollFrame_Update(SellScrollFrame, table.getn(SellData),
                         SELL_DISPLAY_SIZE, SellButton1:GetHeight());
end

-- Handle clicks on the scroll bar.
function AuctionLite:SellScrollFrame_OnVerticalScroll(offset)
  FauxScrollFrame_OnVerticalScroll(
    SellScrollFrame, offset, SellButton1:GetHeight(),
    function() AuctionLite:AuctionFrameSell_Update() end);
end

-- Handle bag item clicks by dropping the item into the sell tab.
function AuctionLite:BagClickSell(container, slot)
  if GetContainerItemLink(container, slot) ~= nil then
    ClearCursor();
    ClickAuctionSellItemButton();
    ClearCursor();
    PickupContainerItem(container, slot);
    ClickAuctionSellItemButton();
  end
end

-- Create the "Sell" tab.
function AuctionLite:CreateSellFrame()
  -- Create our tab.
  local index = self:CreateTab(L["AuctionLite - Sell"], AuctionFrameSell);

  -- Set all localizable strings in the UI.
  SellTitle:SetText(L["AuctionLite - Sell"]);
  SellStackText:SetText(L["Number of Items"]);
  SellStacksOfText:SetText(L["stacks of"]);
  SellBuyoutText:SetText(L["Buyout Price"]);
  SellMethodText:SetText(L["Pricing Method"]);

  SellPerItemButtonText:SetText(L["per item"]);
  SellPerStackButtonText:SetText(L["per stack"]);

  SellShortAuctionButtonText:SetText(L["%dh"]:format(12));
  SellMediumAuctionButtonText:SetText(L["%dh"]:format(24));
  SellLongAuctionButtonText:SetText(L["%dh"]:format(48));

  -- Set button text and adjust arrows.
  SellItemNameButton:SetText(L["Competing Auctions"]);

  self:UpdateSortButton("Sell", "BuyoutEach", L["Buyout Per Item"]);
  self:UpdateSortButton("Sell", "BuyoutAll", L["Buyout Total"]);

  -- Set our constants.
  SellPerItemButton:SetID(METHOD_PER_ITEM);
  SellPerStackButton:SetID(METHOD_PER_STACK);

  SellShortAuctionButton:SetID(DURATION_SHORT);
  SellMediumAuctionButton:SetID(DURATION_MEDIUM);
  SellLongAuctionButton:SetID(DURATION_LONG);

  -- Set up tabbing between fields.
  MoneyInputFrame_SetNextFocus(SellBidPrice, SellBuyoutPriceGold);
  MoneyInputFrame_SetPreviousFocus(SellBidPrice, SellSize);

  MoneyInputFrame_SetNextFocus(SellBuyoutPrice, SellStacks);
  MoneyInputFrame_SetPreviousFocus(SellBuyoutPrice, SellBidPriceCopper);

  -- Miscellaneous additional setup.
  MoneyFrame_SetType(SellDepositMoneyFrame, "AUCTIONLITE_DEPOSIT");

  -- Make sure it's pristine.
  self:ClearSellFrame();

  -- Set preferences.
  self:ChangeAuctionDuration(self.db.profile.duration);
  self:ChangePricingMethod(self.db.profile.method);

  return index;
end
