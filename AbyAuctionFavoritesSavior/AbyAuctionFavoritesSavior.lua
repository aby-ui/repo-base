local addonName = ...

local L = {}
L.BUTTON = "Load"
L.TOOLTIP_TITLE = "Load Favorites"
L.TOOLTIP_DESC = "Blizzard favorites is bugged, AbyAuctionFavoritesSavior saves your favorites in addon, and you can load it manually."
L.TOOLTIP_SAVED = "Saved items:"

if GetLocale() == "zhCN" then
    L.BUTTON = "加载"
    L.TOOLTIP_TITLE = "加载收藏列表"
    L.TOOLTIP_DESC = "暴雪的BUG导致8.3新拍卖行的收藏登出就没了，爱不易临时保存在插件里，可以加载回来。"
    L.TOOLTIP_SAVED = "已保存收藏列表："
end

local function init()
    AbyAuctionFavoritesDB = AbyAuctionFavoritesDB or {}
    local db = AbyAuctionFavoritesDB

    db.auction_fav = db.auction_fav or {}
    local saved = db.auction_fav

    local load = function()
        if C_AuctionHouse.FavoritesAreAvailable() then
            for i, v in ipairs(saved) do
                SET_FAVORITE_ABYUI = true
                C_AuctionHouse.SetFavoriteItem(v, true)
                SET_FAVORITE_ABYUI = nil
            end
        end
    end
    --if not C_AuctionHouse.HasFavorites() then load() end --only load when no fav at all. --there is problem when load, better manually

    local function createButton()
        if not (AuctionHouseFrame and AuctionHouseFrame.SearchBar and AuctionHouseFrame.SearchBar.FavoritesSearchButton) then
            return
        end

        local all_match = true
        for _, v in ipairs(saved) do
            if not C_AuctionHouse.IsFavoriteItem(v) then all_match = false break end
        end
        if all_match then return end

        local parent = AuctionHouseFrame.SearchBar.FavoritesSearchButton
        local btn = CreateFrame("Button", "AbyLoadFavourites", parent, "UIMenuButtonStretchTemplate")
        btn.Text:SetFont(ChatFontNormal:GetFont(), 13, "")
        btn:SetText(L.BUTTON)
        btn:SetSize(40,26)
        btn:SetPoint("TOPRIGHT", parent, "TOPLEFT", -5, -4)
        btn:SetFrameLevel(parent:GetFrameLevel())
        btn:Disable()

        btn:SetScript("OnClick", function(self)
            load()
            self:Hide()
            C_Timer.After(0.2, function() AuctionHouseFrame.SearchBar.FavoritesSearchButton:Click() end)
        end)

        btn:SetScript("OnUpdate", function(self, elapsed)
            if not self.timer or self.timer > 1 then
                self.timer = 0
                if C_AuctionHouse.FavoritesAreAvailable() then
                    self:Enable()
                    self:SetScript("OnUpdate", nil)
                end
            else
                self.timer = self.timer + elapsed
            end
        end)

        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, self.tooltipAnchorPoint)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L.TOOLTIP_TITLE,1,1,1)
            GameTooltip:AddLine(L.TOOLTIP_DESC, 1, 1, 0, true)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L.TOOLTIP_SAVED, 1, 1, 1)
            for _, v in ipairs(saved) do
                if v.itemID then
                    local name = GetItemInfo(v.itemID)
                    GameTooltip:AddLine(name)
                end
            end
            GameTooltip:Show()
        end)

        btn:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    end

    createButton()

    hooksecurefunc(C_AuctionHouse, "SetFavoriteItem", function(itemKey, isFav)
        if SET_FAVORITE_ABYUI then return end
        for i, v in ipairs(saved) do
            local match = true
            for key, value in pairs(itemKey) do
                if v[key] ~= value then
                    match = false
                    break
                end
            end
            if match then
                if not isFav then
                    table.remove(saved, i)
                end
                return
            end
        end
        if isFav then table.insert(saved, itemKey) end
    end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
    if addon == addonName then
        frame:UnregisterEvent("ADDON_LOADED")
        if not AbyLoadFavourites then init() end
    end
end)

--self:GetAuctionHouseFrame():QueryAll(AuctionHouseSearchContext.AllFavorites);
--C_AuctionHouse.SearchForFavorites(sorts);
--/dump hooksecurefunc(AuctionHouseFrame.BrowseResultsFrame, "UpdateBrowseResults", function() print(AuctionHouseFrame.isDisplayingFavorites, self.browseResults) end)
