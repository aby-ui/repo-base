-------------------------------------------------------------------------------
-- AuctionLite 1.9.1
--
-- Lightweight addon to determine accurate market prices and to simplify
-- the process of posting auctions.
--
-- Send suggestions, comments, and bugs to merial.kilrogg@gmail.com.
-------------------------------------------------------------------------------

-- Create our addon.
AuctionLite = LibStub("AceAddon-3.0"):NewAddon("AuctionLite",
                                               "AceConsole-3.0",
                                               "AceEvent-3.0",
                                               "AceHook-3.0");

local _
local L = LibStub("AceLocale-3.0"):GetLocale("AuctionLite", false)

local AUCTIONLITE_VERSION = "1.9.1";

-------------------------------------------------------------------------------
-- Hooks and boostrap code
-------------------------------------------------------------------------------

-- Hook some AH/GB functions and UI widgets when the AH/GB gets loaded.
function AuctionLite:ADDON_LOADED(_, name)
  if name == "Blizzard_AuctionUI" then
    self:RawHook("ChatEdit_InsertLink", "ChatEdit_InsertLink_Hook", true);
    self:SecureHook("ContainerFrameItemButton_OnModifiedClick",
                    "ContainerFrameItemButton_OnModifiedClick_Hook");
    self:SecureHook("AuctionFrameTab_OnClick",
                    "AuctionFrameTab_OnClick_Hook");
    self:SecureHook("ClickAuctionSellItemButton",
                    "ClickAuctionSellItemButton_Hook");
    self:SecureHook("QueryAuctionItems",
                    "QueryAuctionItems_Hook");
    self:HookAuctionFrameUpdate();
    self:AddAuctionFrameTabs();
    self:InitializeAuctionDuration();
  elseif name == "Blizzard_GuildBankUI" then
    self:HookBankTooltips();
  end
end

-- We're alive!
function AuctionLite:OnInitialize()
  -- Load our database.
  self:ConvertDB();
  self:LoadDB();

  -- Update any options that have changed.
  self:ConvertOptions();

  -- Set up our config options.
  self:InitConfig();

  -- Register for events.
  self:RegisterEvent("ADDON_LOADED");
  self:RegisterEvent("AUCTION_ITEM_LIST_UPDATE");
  self:RegisterEvent("AUCTION_HOUSE_SHOW");
  self:RegisterEvent("AUCTION_HOUSE_CLOSED");

  -- Another addon may have forced the Blizzard addons to load early.
  -- If so, just run the init code now.
  if IsAddOnLoaded("Blizzard_AuctionUI") then
    self:ADDON_LOADED("ADDON_LOADED", "Blizzard_AuctionUI");
  end
  if IsAddOnLoaded("Blizzard_GuildBankUI") then
    self:ADDON_LOADED("ADDON_LOADED", "Blizzard_GuildBankUI");
  end

  -- Add any hooks that don't depend upon Blizzard addons.
  self:HookCoroutines();
  self:HookTooltips();

  -- Bag Click
  local function ContainerItemPreClick(self, button)
      if IsAddOnLoaded("TheBurningTrade") then return end
      if(button=="RightButton" and not IsModifierKeyDown()) then
          local bag, item = self:GetParent():GetID(), self:GetID();
          local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, item);
          if (texture and not locked and AuctionFrame and AuctionFrame:IsVisible()) then
              if(AuctionFrameTab5 and SellItemButton) then
                  AuctionFrameTab_OnClick(AuctionFrameTab3); -- make UseContainerItem() to sell not to use
                  AuctionFrameTab_OnClick(AuctionFrameTab5);
              else
                  AuctionFrameTab_OnClick(AuctionFrameTab3);
              end
              ClickAuctionSellItemButton();
              ClearCursor();
              if ((AuctionsItemButton and AuctionsItemButton:IsVisible()) or (SellItemButton and SellItemButton:IsVisible())) then
                  PickupContainerItem(bag, item);
                  ClickAuctionSellItemButton();
                  AuctionsFrameAuctions_ValidateAuction();
              end
          end
      end
  end
  for i = 1, NUM_CONTAINER_FRAMES do
      for j = 1, MAX_CONTAINER_ITEMS do
          local f = getglobal("ContainerFrame"..i.."Item"..j);
          if(f) then
              CoreHookScript(f, 'PreClick', ContainerItemPreClick)
          end
      end
  end

  CoreDependCall("Bagnon", function()
      for i=1, 1000 do
          local f = _G["BagnonItem"..i]
          if(f) then
              CoreHookScript(f, 'PreClick', ContainerItemPreClick)
          else
              break
          end
      end
      local constructID
      hooksecurefunc(Bagnon.ItemSlot, 'Create', function()
          local f = constructID and _G["BagnonItem"..constructID]
          if(f) then
              CoreHookScript(f, 'PreClick', ContainerItemPreClick)
          end
      end)
      hooksecurefunc(Bagnon.ItemSlot, "Construct", function(self, id)
          constructID = id
      end)
  end)

  -- Add our chat message filter.
  ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(...)
    return self:MessageEventFilter(...);
  end);

  -- Set up our disenchant info.
  self:BuildDisenchantTable();

  -- And print a message if we're debugging.
  if self.db.profile.showGreeting then
    --self:Print(L["AuctionLite v%s loaded!"]:format(AUCTIONLITE_VERSION));
  end
end
