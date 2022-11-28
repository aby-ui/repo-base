-- Overlay for the Black Market auction house.


----------------------------
-- UpdateIcon functions   --
----------------------------


local function BlackMarketFrame_OnUpdate(self)
     -- Sets the icon overlay for the Black Market auction frame.
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = self:GetParent():GetParent().itemLink
    CIMI_SetIcon(self, BlackMarketFrame_OnUpdate, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function UpdateBlackMarketButtons(self, elapsed)
    if not CanIMogIt.FrameShouldUpdate("BMAHOverlay", elapsed or 1) then return end
    for i=1, CanIMogIt.NUM_BLACKMARKET_BUTTONS do
        local frame = _G["CIMIOverlayFrame_BlackMarket"..i]
        if frame then
            BlackMarketFrame_OnUpdate(frame)
        end
    end
end


local blackMarketLoaded = false


local function AddToBlackMarketFrames()
    -- Add hook for the Black Market Auction House frames.
    local blackMarketButtons = _G["BlackMarketFrame"].ScrollBox:GetFrames()
    for i = 1, #blackMarketButtons do
        local frame = blackMarketButtons[i]
        if frame then
            blackMarketLoaded = true
            CIMI_AddToFrame(frame.Item, BlackMarketFrame_OnUpdate, "BlackMarket"..i)
        end
    end

    -- Add hook for scroll event of Black Market auction scroll frame.
    local hookframe = _G["BlackMarketFrame"]
    hookframe:HookScript("OnUpdate", UpdateBlackMarketButtons)
end


local function OnBlackMarketShow(event, ...)
    -- The button frames don't exist until the Black Market auction house is open.
    if event ~= "BLACK_MARKET_OPEN" then return end
    if blackMarketLoaded then return end

    -- Need slight delay because buttons don't exist immediately on first open.
    C_Timer.After(.5, AddToBlackMarketFrames)
end
CanIMogIt.frame:AddEventFunction(OnBlackMarketShow)


local function OnBlackMarketUpdate(event, ...)
    -- The button frames don't exist until the Black Market auction house is open.
    if event ~= "BLACK_MARKET_ITEM_UPDATE" then return end
    if not blackMarketLoaded then return end

    -- Refresh overlay of buttons created OnBlackMarketShow function.
    UpdateBlackMarketButtons()
end
CanIMogIt.frame:AddEventFunction(OnBlackMarketUpdate)
CanIMogIt:RegisterMessage("OptionUpdate", function () OnBlackMarketUpdate("BLACK_MARKET_ITEM_UPDATE") end)


------------------------
-- Event functions    --
------------------------
