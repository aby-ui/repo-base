if not U1GetDominationShardsData then return end

local DominationShards, ShardIdToSetName, ShardIdToName, ShardIdToLevel, ShardIdToIndex = U1GetDominationShardsData()
local ShardTextures = {}
for i = 1, 9 do
    local tex = select(5, GetItemInfoInstant(DominationShards[i][1]))
    if tex then
        ShardTextures[i] = tex
        ShardTextures[tex] = true
    end
end

local tip = CreateFrame("GameTooltip", "GameTooltipForDomination", nil, "ShoppingTooltipTemplate")
for i = 1, 7 do
    if _G[tip:GetName() .. "TextLeft" .. i] == nil then
        tip:AddFontStrings(
            tip:CreateFontString( "$parentTextLeft"..i, nil, "GameTooltipText" ),
            tip:CreateFontString( "$parentTextRight"..i, nil, "GameTooltipText" )
        )
    end
end

local LINE_ABOVE_PATTERN = ITEM_LIMIT_CATEGORY_MULTIPLE:gsub("%%s", ".+"):gsub("%%d", "[0-9]+") --装备唯一：%s （%d）

local function findDescLineFromTooltip(tip)
    for i = 3, 7 do
        local line = _G[tip:GetName() .. "TextLeft" .. i]
        local text = line and line:GetText()
        if text and text:find(LINE_ABOVE_PATTERN) then
            line = _G[tip:GetName() .. "TextLeft" .. (i+1)]
            text = text and line and line:GetText()
            if text then
                return text, line, i+1
            end
        end
    end
end

local GemDescriptions = {}
local function GetGemDescription(id)
    if GemDescriptions[id] then return GemDescriptions[id] end
    local link = select(2, GetItemInfo(id))
    if link then
        tip:SetOwner(WorldFrame, "ANCHOR_NONE")
        for i = 1, 4 do
            local tex = _G[ tip:GetName() .."Texture"..i]
            if tex then tex:SetTexture("") end
        end
        tip:SetHyperlink((link))
        tip:Show()
        local text = findDescLineFromTooltip(tip)
        if text then
            text = text:gsub("\124[Cc]%x%x%x%x%x%x%x%x(.+)\124[Rr]", "%1")
            GemDescriptions[id] = text
            return text
        end
    end
end

local hookTooltipSetItem = function(self, link)
    link = select(2, self:GetItem())
    if not link then return end

    local id = GetItemInfoInstant(link)
    if ShardIdToSetName[id] then
        --gem item
        local descCurr, descLine = findDescLineFromTooltip(self)
        if descCurr then
            descLine:SetText(" ")
            self:AddLine("套装：" .. ShardIdToSetName[id])
            local level = ShardIdToLevel[id]
            self:AddLine("升级：" .. format("%d / 5", level))
            local idx = ShardIdToIndex[id]
            for i = 1, 5 do
                if i == level then
                    GameTooltip_AddNormalLine(self, format("%d级：%s", i, descCurr), true)
                else
                    local desc = GetGemDescription(DominationShards[idx][i])
                    if desc then
                        GameTooltip_AddNormalLine(self, format("%d级：\124c%s%s\124r", i, i==level and "ff20ff20" or "ff7f7f7f", desc), true)
                    end
                end
            end
            self:Show()
        end
    else
        --armor with gem socketed
        local _, _, gemID = link:find("item:[0-9]+:[0-9]*:([0-9]+):") --TODO: 如果普通宝石和统御碎片一起
        gemID = gemID and tonumber(gemID)
        if gemID and ShardIdToSetName[gemID] then
            local tex = _G[self:GetName() .. "Texture1"]
            local texId = tex and tex:IsShown() and tex:GetTexture()
            if texId and ShardTextures[texId] then
                local text = select(2, tex:GetPoint())
                if text then
                    text:SetText(format("%d级，%s，", ShardIdToLevel[gemID], ShardIdToName[gemID]) .. text:GetText())
                end
            end
        end
        self:Show()
    end
end
SetOrHookScript(GameTooltip, "OnTooltipSetItem", hookTooltipSetItem)
SetOrHookScript(ItemRefTooltip, "OnTooltipSetItem", hookTooltipSetItem)
SetOrHookScript(ShoppingTooltip1, "OnTooltipSetItem", hookTooltipSetItem)

--[=[
CoreDependCall("Blizzard_ItemSocketingUI", function()

    --[[------------------------------------------------------------
    快捷按钮
    ---------------------------------------------------------------]]
    local function refreshButtonList()
        local shouldShow = false
        local numSockets = GetNumSockets();
        for i = 1, numSockets do
            if GetSocketTypes(i) == "Domination" then
                shouldShow = true
                break
            end
        end
        for i = 1, 9 do
            local btn = _G["AbyUIDominationShards" .. i]
            if not shouldShow then
                btn:Hide()
            else
                btn:Show()
                btn:SetEnabled(false)
                btn.icon:SetDesaturated(true)
            end
        end
        if not shouldShow then return end
        for container = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            local slots = GetContainerNumSlots(container)
            for slot = 1, slots do
                local itemId = GetContainerItemID(container, slot)
                local idx = ShardIdToIndex[itemId]
                if idx then
                    local btn = _G["AbyUIDominationShards" .. idx]
                    btn.bagID = container
                    btn.slotID = slot
                    btn:SetEnabled(true)
                    btn.icon:SetDesaturated(false)
                end
            end
        end
    end

    for i = 1,9 do
        local button = WW:Button("AbyUIDominationShards" .. i, ItemSocketingFrame, "ActionButtonTemplate"):SetSize(32, 32)
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM");
            GameTooltip:SetBagItem(self.bagID, self.slotID);
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function(self)
            GameTooltip_Hide()
        end)
        button:SetScript("OnClick", function(self)
            for i = 1, 9 do
                local btn = _G["AbyUIDominationShards" .. i]
                if btn ~= self then
                    btn:SetButtonState("PUSHED")
                    btn:SetButtonState("NORMAL")
                end
            end
            PickupContainerItem(self.bagID, self.slotID)
            ClickSocketButton(ItemSocketingSocket1:GetID())
            ClearCursor()
        end)
        button:SetPoint("TOPLEFT", ItemSocketingFrame, "BOTTOMLEFT", 2 + 36*(i-1) + math.floor((i-1)/3) * 6, -5)
        button.icon:SetTexture(ShardTextures[i])
    end

    CoreOnEventBucket("BAG_UPDATE", 0.2, refreshButtonList)

    --[[------------------------------------------------------------
    取出按钮
    ---------------------------------------------------------------]]
    local extractButton = WW:Button("AbyUIExtractGemButton", nil, "UIPanelButtonTemplate, SecureActionButtonTemplate"):SetSize(162, 22):SetText("取出统御碎片"):Hide()
    extractButton:SetAttribute("type", "macro")
	extractButton:SetAttribute("macrotext", "/use item:187532\n/click ItemSocketingSocket1")
    CoreOnEvent("PLAYER_REGEN_DISABLED", function()
        extractButton:Hide()
        extractButton:SetParent(nil)
    end)

    -- 只要已插入的宝石是统御碎片，exist就返回true，不判断是否有新宝石
    local function IsDominationChange(exist_or_new)
        local numSockets = GetNumSockets();
        for i = 1, numSockets do
            local f = exist_or_new == "new" and GetNewSocketInfo or GetExistingSocketInfo
            local name, icon = f(i)
            if icon and GetSocketTypes(i) == "Domination" then
                return true
            end
        end
    end

    --[[------------------------------------------------------------
    界面更新
    ---------------------------------------------------------------]]
    hooksecurefunc("ItemSocketingFrame_Update", function()
        refreshButtonList()
        if not InCombatLockdown() then
            local extractButton = AbyUIExtractGemButton
            if IsDominationChange() then
                extractButton:SetParent(ItemSocketingFrame)
                extractButton:SetPoint("BOTTOMLEFT", ItemSocketingFrame, "BOTTOMLEFT", 5, 3)
                extractButton:Show()
            else
                extractButton:Hide()
                extractButton:SetParent(nil)
            end
        end
    end)
end)
--]=]