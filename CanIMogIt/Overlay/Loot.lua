-- Overlay for the loot roll frames.-- Common functions used for overlays.


----------------------------
-- UpdateIcon functions   --
----------------------------


function LootFrame_CIMIUpdateIcon(self)
    if not self then return end
    -- Sets the icon overlay for the loot frame.
    local lootID = self:GetParent():GetParent().rollID
    if not CIMI_CheckOverlayIconEnabled() or lootID == nil then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = GetLootRollItemLink(lootID)
    CIMI_SetIcon(self, LootFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function HookOverlayLoot(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the loot frames.
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            CIMI_AddToFrame(frame, LootFrame_CIMIUpdateIcon)
        end
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayLoot)


------------------------
-- Event functions    --
------------------------


local function LootOverlayEvents(event, ...)
    for i=1,NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i].IconFrame
        if frame then
            LootFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end

CanIMogIt.frame:AddOverlayEventFunction(LootOverlayEvents)

-- From ls: Toasts
local LOOT_ITEM_PATTERN = LOOT_ITEM_SELF:gsub("%%s", "(.+)")
local LOOT_ITEM_PUSHED_PATTERN = LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)")
local LOOT_ITEM_MULTIPLE_PATTERN = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)")
local LOOT_ITEM_PUSHED_MULTIPLE_PATTERN = LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub("%%s", "(.+)")
local PLAYER_NAME = UnitName("player")


local function ChatMessageLootEvent(event, message, _, _, _, target)
    -- Get the item link from the CHAT_MSG_LOOT event.
    if event ~= "CHAT_MSG_LOOT" then return end
    if target ~= PLAYER_NAME then
        return
    end

    local link = message:match(LOOT_ITEM_MULTIPLE_PATTERN)

    if not link then
        link = message:match(LOOT_ITEM_PUSHED_MULTIPLE_PATTERN)

        if not link then
            link = message:match(LOOT_ITEM_PATTERN)

            if not link then
                link = message:match(LOOT_ITEM_PUSHED_PATTERN)

                if not link then
                    return
                end
            end
        end
    end

    -- Remove the cache for this item
    CanIMogIt.cache:RemoveItem(link)

end

CanIMogIt.frame:AddEventFunction(ChatMessageLootEvent)
