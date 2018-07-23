-- Overlay for the auction house.
-- Thanks to crappyusername on Curse for some of the code.


local auctioneerLoaded;

local function IsAuctioneerLoaded()
    -- Used to prevent loading when Auctioneer's Compact UI is enabled.
    if auctioneerLoaded == nil then
        auctioneerLoaded = IsAddOnLoaded("Auc-Advanced")

        if auctioneerLoaded then
            if not AucAdvanced.Settings.GetSetting("util.compactui.activated") then
                -- The compact UI isn't loaded, so pretend it's off.
                auctioneerLoaded = false
            end
        end
     end
    return auctioneerLoaded
end


----------------------------
-- UpdateIcon functions   --
----------------------------


local function AuctionFrame_OnUpdate(self)
     -- Sets the icon overlay for the auction frame.
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() or IsAuctioneerLoaded() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end
    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

    local index = self.id + offset
    local itemLink = GetAuctionItemLink("list", index)
    CIMI_SetIcon(self, AuctionFrame_OnUpdate, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function UpdateBrowseButtons(self, offset)
    for i=1, NUM_BROWSE_TO_DISPLAY do
        local frame = _G["CIMIOverlayFrame_BrowseButton"..i.."Item"]
        if frame then
            AuctionFrame_OnUpdate(frame)
        end
    end
end


local auctionHouseLoaded = false


local function OnAuctionHouseShow(event, ...)
    -- The button frames don't exist until the auction house is open.
    if event ~= "AUCTION_HOUSE_SHOW" then return end
    auctionHouseLoaded = true
    -- Add hook for the Auction House frames.

    for i=1, NUM_BROWSE_TO_DISPLAY do
        local frame = _G["BrowseButton"..i.."Item"]
        if frame then
            local cimi_frame = CIMI_AddToFrame(frame, AuctionFrame_OnUpdate)
            if cimi_frame then
                -- Add the index of the button, so we can reference
                -- it for the offset
                cimi_frame.id = i
            end
        end
    end

    -- add hook for scroll event of auction scroll frame
    -- Poor name, but it's the auction house browse tab scroll frame.
    local hookframe = _G["BrowseScrollFrame"]
    if hookframe then
        hookframe:HookScript("OnVerticalScroll", UpdateBrowseButtons)
    end
end
CanIMogIt.frame:AddEventFunction(OnAuctionHouseShow)


local function OnAuctionHouseUpdate(event, ...)
    -- The button frames don't exist until the auction house is open.
    if event ~= "AUCTION_ITEM_LIST_UPDATE" then return end
    if not auctionHouseLoaded then return end

    -- refresh overlay of buttons created OnAuctionHouseShow function.
    UpdateBrowseButtons()
end
CanIMogIt.frame:AddEventFunction(OnAuctionHouseUpdate)
CanIMogIt:RegisterMessage("OptionUpdate", function () OnAuctionHouseUpdate("AUCTION_ITEM_LIST_UPDATE") end)


------------------------
-- Event functions    --
------------------------
