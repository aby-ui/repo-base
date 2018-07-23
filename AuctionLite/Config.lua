-------------------------------------------------------------------------------
-- Config.lua
--
-- AuctionLite configuration stuff.
-------------------------------------------------------------------------------

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

local DBName = "AuctionLiteDB";

-------------------------------------------------------------------------------
-- First, tables of options
-------------------------------------------------------------------------------

-- Currently no slash commands...
local Options = {
  type = "group",
  get = function(item) return AuctionLite.db.profile[item[#item]] end,
  set = function(item, value) AuctionLite.db.profile[item[#item]] = value end,
  args = {
    storePrices = {
      type = "toggle",
      desc = L["Store price data for all items seen (disable to save memory)."],
      name = L["Store Price Data"],
      order = 4,
    },
    clearData = {
      type = "execute",
      handler = AuctionLite,
      func = "ClearData",
      desc = L["Clear all auction house price data."],
      name = L["Clear All Data"],
      order = 6,
    },
    openBags = {
      type = "toggle",
      desc = L["Open all your bags when you visit the auction house."],
      name = L["Open All Bags at AH"],
      width = "double",
      order = 8,
    },
    startTab = {
      type = "select",
      desc = L["Choose which tab is selected when opening the auction house."],
      name = L["Start Tab"],
      style = "dropdown",
      values = {
        a_default = L["Default"],
        b_buy = L["Buy Tab"],
        c_sell = L["Sell Tab"],
        d_last = L["Last Used Tab"],
      },
      order = 12,
    },
  },
};

local BuyOptions = {
  type = "group",
  get = function(item) return AuctionLite.db.profile[item[#item]] end,
  set = function(item, value) AuctionLite.db.profile[item[#item]] = value end,
  args = {
    minProfit = {
      type = "range",
      desc = L["Deals must be below the historical price by this much gold."],
      name = L["Minimum Profit (Gold)"],
      min = 0,
      max = 1000,
      step = 10,
      order = 5,
    },
    minDiscount = {
      type = "range",
      desc = L["Deals must be below the historical price by this percentage."],
      name = L["Minimum Profit (Pct)"],
      isPercent = true,
      min = 0,
      max = 1,
      step = 0.01,
      order = 6,
    },
    getAll = {
      type = "toggle",
      desc = L["Use fast method for full scans (may cause disconnects)."],
      name = L["Fast Auction Scan"],
      width = "double",
      order = 7,
    },
    countMyListings = {
      type = "toggle",
      desc = L["On the summary view, show how many listings/items are yours."],
      name = L["Show How Many Listings are Mine"],
      width = "double",
      order = 8,
    },
    considerResale = {
      type = "toggle",
      desc = L["Consider resale value of excess items when filling an order on the \"Buy\" tab."],
      name = L["Consider Resale Value When Buying"],
      width = "double",
      order = 9,
    },
  },
};

local SellOptions = {
  type = "group",
  get = function(item) return AuctionLite.db.profile[item[#item]] end,
  set = function(item, value) AuctionLite.db.profile[item[#item]] = value end,
  args = {
    bidUndercut = {
      type = "range",
      desc = L["Percent to undercut market value for bid prices (0-100)."],
      name = L["Bid Undercut"],
      isPercent = true,
      min = 0,
      max = 1,
      step = 0.01,
      order = 1,
    },
    buyoutUndercut = {
      type = "range",
      desc = L["Percent to undercut market value for buyout prices (0-100)."],
      name = L["Buyout Undercut"],
      isPercent = true,
      min = 0,
      max = 1,
      step = 0.01,
      order = 2,
    },
    header1 = { type = "header", name = "", order = 2.5},
    bidUndercutFixed = {
      name = L["Bid Undercut (Fixed)"],
      desc = L["Fixed amount to undercut market value for bid prices (e.g., 1g 2s 3c)."],
      type = "input",
      order = 3,
      handler = AuctionLite,
      get = "GetFixedBidUndercut",
      set = "SetFixedBidUndercut",
    },
    buyoutUndercutFixed = {
      name = L["Buyout Undercut (Fixed)"],
      desc = L["Fixed amount to undercut market value for buyout prices (e.g., 1g 2s 3c)."],
      type = "input",
      order = 4,
      handler = AuctionLite,
      get = "GetFixedBuyoutUndercut",
      set = "SetFixedBuyoutUndercut",
    },
    header2 = { type = "header", name = "", order = 4.5},
    vendorMultiplier = {
      type = "range",
      desc = L["Amount to multiply by vendor price to get default sell price."],
      name = L["Vendor Multiplier"],
      min = 0,
      max = 100,
      step = 0.5,
      order = 5,
    },
    roundPrices = {
      type = "range",
      desc = L["Round all prices to this granularity, or zero to disable (0-1)."],
      name = L["Round Prices"],
      min = 0,
      max = 1,
      step = 0.01,
      order = 6,
    },
    header3 = { type = "header", name = "", order = 6.5},
    defaultStacks = {
      type = "select",
      desc = L["Number of stacks suggested when an item is first placed in the \"Sell\" tab."],
      name = L["Default Number of Stacks"],
      style = "dropdown",
      values = {
        a_one = L["One Stack"],
        b_full = L["Max Stacks"],
        c_excess = L["Max Stacks + Excess"],
      },
      order = 7,
    },
    defaultSize = {
      type = "select",
      desc = L["Stack size suggested when an item is first placed in the \"Sell\" tab."],
      name = L["Default Stack Size"],
      style = "dropdown",
      values = {
        a_one = L["One Item"],
        b_stack = L["Selected Stack Size"],
        c_full = L["Full Stack"],
      },
      order = 8,
    },
    printPriceData = {
      type = "toggle",
      desc = L["Print detailed price data when selling an item."],
      name = L["Print Detailed Price Data"],
      width = "double",
      order = 9,
    },
  },
};

local YesNoMaybe = {
  a_yes = L["Always"],
  b_maybe = L["If Applicable"],
  c_no = L["Never"],
};

local TooltipLocations = {
  a_cursor = L["Mouse Cursor"],
  b_right = L["Right Side of AH"],
  c_below = L["Below AH"],
  d_corner = L["Window Corner"],
  e_hide = L["Hide Tooltips"],
};

local TooltipOptions = {
  type = "group",
  get = function(item) return AuctionLite.db.profile[item[#item]] end,
  set = function(item, value) AuctionLite.db.profile[item[#item]] = value end,
  args = {
    showVendor = {
      type = "select",
      desc = L["Show vendor sell price in tooltips."],
      name = L["Show Vendor Price"],
      style = "dropdown",
      values = YesNoMaybe,
      order = 1,
    },
    blankVendor = {
      type = "description",
      name = "",
      desc = "",
      order = 2,
    },
    showDisenchant = {
      type = "select",
      desc = L["Show expected disenchant value in tooltips."],
      name = L["Show Disenchant Value"],
      style = "dropdown",
      values = YesNoMaybe,
      order = 3,
    },
    blankDisenchant = {
      type = "description",
      name = "",
      desc = "",
      order = 4,
    },
    showAuction = {
      type = "select",
      desc = L["Show auction house value in tooltips."],
      name = L["Show Auction Value"],
      style = "dropdown",
      values = YesNoMaybe,
      order = 5,
    },
    blankAuction = {
      type = "description",
      name = "",
      desc = "",
      order = 6,
    },
    tooltipLocation = {
      type = "select",
      desc = L["Placement of tooltips in \"Buy\" and \"Sell\" tabs."],
      name = L["Tooltip Location"],
      style = "dropdown",
      values = TooltipLocations,
      order = 7,
    },
    blankLocation = {
      type = "description",
      name = "",
      desc = "",
      order = 8,
    },
    blank = {
      type = "description",
      name = " ",
      desc = " ",
      order = 9,
    },
    coinTooltips = {
      type = "toggle",
      desc = L["Uses the standard gold/silver/copper icons in tooltips."],
      name = L["Use Coin Icons in Tooltips"],
      width = "double",
      order = 10,
    },
    showStackPrice = {
      type = "toggle",
      desc = L["Show full stack prices in tooltips (shift toggles on the fly)."],
      name = L["Show Full Stack Price"],
      width = "double",
      order = 11,
    },
  },
};

local FavoritesOptions = {
  type = "group",
  handler = AuctionLite,
  args = {
    selectlist = {
      name = L["Select a Favorites List"],
      desc = L["Choose a favorites list to edit."],
      type = "select",
      get = "GetCurrentList",
      set = "SetCurrentList",
      values = "GetLists",
      order = 12,
    },
    newlist = {
      name = L["New..."],
      desc = L["Create a new favorites list."],
      type = "execute",
      func = "NewList",
      width = "half",
      order = 15,
    },
    deletelist = {
      name = L["Delete"],
      desc = L["Delete the selected favorites list."],
      type = "execute",
      func = "DeleteList",
      width = "half",
      order = 20,
    },
    additem = {
      name = L["Add an Item"],
      desc = L["Add a new item to a favorites list by entering the name here."],
      type = "input",
      order = 30,
      get = false,
      set = "AddListItem",
      width = "double",
    },
    selectitem = {
      name = "",
      desc = "",
      type = "multiselect",
      order = 40,
      get = "GetCurrentListItems",
      set = "SetCurrentListItems",
      values = "GetListItems",
      control = "ListBox",
      width = "double",
    },
    removeitems = {
      name = L["Remove Items"],
      desc = L["Remove the selected items from the current favorites list."],
      type = "execute",
      func = "RemoveListItems",
      order = 50,
    }
  },
};

local SlashOptions = {
  type = "group",
  handler = AuctionLite,
  args = {
    config = {
      type = "execute",
      desc = L["Open configuration dialog"],
      name = L["Configure"],
      func = function()
        InterfaceOptionsFrame_OpenToCategory(AuctionLite.optionFrames.tooltips);
        InterfaceOptionsFrame_OpenToCategory(AuctionLite.optionFrames.main);
      end,
    },
  },
};

local SlashCmds = {
  "al",
  "auctionlite",
};

local Defaults = {
  factionrealm = {
    prices = {},
    prefs = {},
  },
  profile = {
    method = 1,
    duration = 3,
    bidUndercut = 0.01,
    buyoutUndercut = 0.01,
    bidUndercutFixed = 0,
    buyoutUndercutFixed = 0,
    vendorMultiplier = 3,
    roundPrices = 0.01,
    minProfit = 10,
    minDiscount = 0.25,
    getAll = false,
    countMyListings = true,
    openBags = false,
    considerResale = false,
    defaultStacks = "a_one",
    defaultSize = "b_stack",
    printPriceData = false,
    showVendor = "a_yes",
    showAuction = "b_maybe",
    showDisenchant = "b_maybe",
    tooltipLocation = "a_cursor",
    coinTooltips = true,
    showStackPrice = true,
    storePrices = true,
    startTab = "d_last",
    lastTab = 1,
    fastScanAd = false,
    showGreeting = false,
    favorites = { [L["Favorites"]] = {} },
  },
};

-------------------------------------------------------------------------------
-- Handlers for favorites config screen
-------------------------------------------------------------------------------

-- Store the favorites list being edited and the selected items in that list.
local CurrentList = nil;
local SelectedItems = {};
local IndexKeys = {};
local ResetFocus = false;

-- Return the current favorites list.
function AuctionLite:GetCurrentList()
  return CurrentList;
end

-- Set the current favorites list.
function AuctionLite:SetCurrentList(info, list)
  if CurrentList ~= list then
    CurrentList = list;
    SelectedItems = {};
    ResetFocus = true;
  end
end

-- Get the list of favorites lists.
function AuctionLite:GetLists()
  local lists = {};
  for name, _ in pairs(self.db.profile.favorites) do
    lists[name] = name;
    if CurrentList == nil then
      CurrentList = name;
      SelectedItems = {};
    end
  end
  return lists;
end

-- Prompt for a name for a new favorites list.
StaticPopupDialogs["AL_NEW_FAVORITES_LIST"] = {
  text = L["Enter the name of the new favorites list:"],
  button1 = L["Accept"],
  button2 = L["Cancel"],
  OnAccept = function(self)
    local name = self.editBox:GetText();
    AuctionLite:CreateList(name);
  end,
  EditBoxOnEnterPressed = function(self)
    local name = self:GetText();
    AuctionLite:CreateList(name);
    self:GetParent():Hide();
  end,
  OnShow = function(self)
    self.editBox:SetFocus();
  end,
	OnHide = function(self)
		self.editBox:SetText("");
	end,
  hasEditBox = 1,
  timeout = 0,
  exclusive = 1,
  hideOnEscape = 1,
  preferredIndex = 3
};

-- Create a favorites list with a given name.
function AuctionLite:CreateList(name)
  local favorites = self.db.profile.favorites;
  if favorites[name] == nil then
    favorites[name] = {};
    CurrentList = name;
    SelectedItems = {};
    ResetFocus = true;
    InterfaceOptionsFrame_OpenToCategory(self.optionFrames.favs);
  end
end

-- Request a name for a new favorites list.
function AuctionLite:NewList()
  StaticPopup_Show("AL_NEW_FAVORITES_LIST");
end

-- Delete a favorites list.
function AuctionLite:DeleteList()
  if CurrentList ~= nil then
    self.db.profile.favorites[CurrentList] = nil;

    -- Find a new current list.
    CurrentList = nil;
    for name, _ in pairs(self.db.profile.favorites) do
      CurrentList = name;
      break;
    end

    -- If none exists, make an empty one.
    if CurrentList == nil then
      CurrentList = L["Favorites"];
      self.db.profile.favorites[CurrentList] = {};
    end

    SelectedItems = {};
  end
end

-- Add an item to a favorites list.
function AuctionLite:AddListItem(info, value)
  if CurrentList ~= nil and value ~= "" then
    local items = self.db.profile.favorites[CurrentList];

    -- Did we get a link or a name?
    local link;
    local name = self:SplitLink(value);
    if name ~= nil then
      link = value;
    else
      name = value;
      link = nil;
    end
    name = strlower(name);

    -- Search for the item in the current list.
    local found = false;
    for item, _ in pairs(items) do
      if self:IsLink(item) then
        -- It's a link.  If it's a match, we're done; no need to make changes.
        if strlower(self:SplitLink(item)) == name then
          found = true;
          break;
        end
      else
        -- It's a name.  If it's a match, remove it so we can add a new entry
        -- later, either with a link or with the new capitalization.
        if strlower(item) == name then
          items[item] = nil;
        end
      end
    end

    -- If we didn't find the item (or if we removed the old one), add it.
    if not found then
      if link ~= nil then
        items[link] = true;
      else
        items[value] = true;
      end
    end

    ResetFocus = true;
  end
end

-- Indicate whether an item is selected.
function AuctionLite:GetCurrentListItems(info, key)
  return SelectedItems[key];
end

-- Select or deselect an item.
function AuctionLite:SetCurrentListItems(info, key, value)
  if not value then
    value = nil;
  end
  SelectedItems[key] = value;
end

-- Get the contents of a favorites list.
function AuctionLite:GetListItems()
  local result = {};

  if CurrentList ~= nil then
    local items = self.db.profile.favorites[CurrentList];
    if items ~= nil then
      local keys = {};

      for item, _ in pairs(items) do
        local name, color = self:SplitLink(item);
        if name == nil or color == nil then
          name = item;
          color = "ffffffff";
        end

        local display = "|c" .. color .. name .. "|r";
        table.insert(result, display);
        keys[display] = item;
      end

      table.sort(result);

      IndexKeys = {};
      for index, display in ipairs(result) do
        IndexKeys[index] = keys[display];
      end
    end

    -- Massive hack: Move the focus to the "Add an Item" box.  This needs
    -- to be done whenever we get a list of items because AceConfig
    -- rebuilds the entire panel on every event.
    if ResetFocus then
      ResetFocus = false;

      local i = 1;
      while true do
        local editBox = _G["AceGUI-3.0EditBox" .. i];
        if editBox == nil then
          break;
        elseif editBox.obj:GetUserDataTable().options == FavoritesOptions then
          editBox:SetFocus();
          break;
        end
        i = i + 1;
      end
    end
  end

  return result;
end

-- Remove a set of items from a favorites list.
function AuctionLite:RemoveListItems()
  if CurrentList ~= nil then
    local items = self.db.profile.favorites[CurrentList];
    if items ~= nil then
      for index, _ in pairs(SelectedItems) do
        items[IndexKeys[index]] = nil;
      end
    end
    SelectedItems = {};
  end
end

-------------------------------------------------------------------------------
-- Handlers for fixed undercuts
-------------------------------------------------------------------------------

-- Get the current fixed bid undercut.
function AuctionLite:GetFixedBidUndercut()
  return self:PrintMoney(self.db.profile.bidUndercutFixed);
end

-- Get the current fixed buyout undercut.
function AuctionLite:GetFixedBuyoutUndercut()
  return self:PrintMoney(self.db.profile.buyoutUndercutFixed);
end

-- Set the fixed bid undercut.
function AuctionLite:SetFixedBidUndercut(info, value)
  self.db.profile.bidUndercutFixed = self:ParseMoney(value);
end

-- Set the fixed buyout undercut.
function AuctionLite:SetFixedBuyoutUndercut(info, value)
  self.db.profile.buyoutUndercutFixed = self:ParseMoney(value);
end

-------------------------------------------------------------------------------
-- Initialization code
-------------------------------------------------------------------------------

-- If we see an Ace2 database, convert it to Ace3.
function AuctionLite:ConvertDB()
  local db = _G[DBName];

  -- It's Ace2 if it uses "realms" instead of "factionrealm".
  if db ~= nil and db.realms ~= nil and db.factionrealm == nil then
    -- Change "Realm - Faction" keys to "Faction - Realm" keys.
    db.factionrealm = {}
    for k, v in pairs(db.realms) do
      db.factionrealm[k:gsub("(.*) %- (.*)", "%2 - %1")] = v;
    end

    -- Now unlink the old DB.
    db.realms = nil;
  end
end

-- Load our settings database.
function AuctionLite:LoadDB()
  self.db = LibStub("AceDB-3.0"):New(DBName, Defaults, "Default");
end

-- If any of the options are outdated, convert them.
function AuctionLite:ConvertOptions()
  for _, profile in pairs(self.db.profiles) do
    -- Convert tooltip options.
    if type(profile.showAuction) == "boolean" then
      if profile.showAuction then
        profile.showAuction = "b_maybe";
      else
        profile.showAuction = "c_no";
      end
    end
    if type(profile.showVendor) == "boolean" then
      if profile.showVendor then
        profile.showVendor = "a_yes";
      else
        profile.showVendor = "c_no";
      end
    end
    if profile.tooltipLocation == "b_corner" then
      profile.tooltipLocation = "d_corner";
    elseif profile.tooltipLocation == "c_hide" then
      profile.tooltipLocation = "e_hide";
    end
    -- Convert favorites.
    if profile.favorites ~= nil then
      local value = true;
      for _, v in pairs(profile.favorites) do
        value = v;
        break;
      end
      if type(value) == "boolean" then
        profile.favorites = { [L["Favorites"]] = profile.favorites };
      end
    end
  end
end

-- Set up all the config screens.
function AuctionLite:InitConfig()
  local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
  
  local config = LibStub("AceConfig-3.0");
  config:RegisterOptionsTable("AuctionLite", SlashOptions, SlashCmds);

  local registry = LibStub("AceConfigRegistry-3.0");
  registry:RegisterOptionsTable("AuctionLite Options", Options); Options.name = L["AuctionLite Options"]
  registry:RegisterOptionsTable("AuctionLite Buy", BuyOptions);
  registry:RegisterOptionsTable("AuctionLite Sell", SellOptions);
  registry:RegisterOptionsTable("AuctionLite Tooltips", TooltipOptions);
  registry:RegisterOptionsTable("AuctionLite Favorites", FavoritesOptions);
  registry:RegisterOptionsTable("AuctionLite Profiles", profiles);

  local dialog = LibStub("AceConfigDialog-3.0");
  self.optionFrames = {
    main     = dialog:AddToBlizOptions("AuctionLite Options", L["AuctionLite"]),
    buy      = dialog:AddToBlizOptions("AuctionLite Buy", L["Buy Tab"],
                                       L["AuctionLite"]);
    sell     = dialog:AddToBlizOptions("AuctionLite Sell", L["Sell Tab"],
                                       L["AuctionLite"]);
    tooltips = dialog:AddToBlizOptions("AuctionLite Tooltips", L["Tooltips"],
                                       L["AuctionLite"]);
    favs     = dialog:AddToBlizOptions("AuctionLite Favorites", L["Favorites"],
                                       L["AuctionLite"]);
    profiles = dialog:AddToBlizOptions("AuctionLite Profiles", L["Profiles"],
                                       L["AuctionLite"]);
  };
end
