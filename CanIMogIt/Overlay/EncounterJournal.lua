-- Overlay for Adventure Guide loot.


----------------------------
-- UpdateIcon functions   --
----------------------------


function EncounterJournalFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local itemLink = self:GetParent().link
    CIMI_SetIcon(self, EncounterJournalFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


local function EncounterJournalFrame_CIMISetLootButton(self)
    -- Sets the icon overlay for the Encounter Journal dungeon and raid tabs.
    local overlay = self.CanIMogItOverlay
    if not overlay then return end
    if not CIMI_CheckOverlayIconEnabled(overlay) then
        overlay.CIMIIconTexture:SetShown(false)
        overlay:SetScript("OnUpdate", nil)
        return
    end
    local itemLink = self.link
    CIMI_SetIcon(overlay, EncounterJournalFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


function EncounterJournalFrame_CIMIOnValueChanged(_, elapsed)
    if not CanIMogIt.FrameShouldUpdate("EncounterJournal", elapsed or 1) then return end
    local encounterJournalScrollFrame = _G["EncounterJournalEncounterFrameInfo"].LootContainer.ScrollBox
    local lootItemFrames = encounterJournalScrollFrame:GetFrames()
    for i = 1, #lootItemFrames do
        local frame = lootItemFrames[i]
        if frame then
            CIMI_AddToFrame(frame, EncounterJournalFrame_CIMIUpdateIcon, "EncounterJournal"..i, "TOPRIGHT")
            EncounterJournalFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local encounterJournalLoaded = false

local function OnEncounterJournalLoaded(event, addonName, ...)
    if event ~= "ADDON_LOADED" then return end
    if addonName ~= "Blizzard_EncounterJournal" then return end
    encounterJournalLoaded = true
    hooksecurefunc("EncounterJournal_SetLootButton", EncounterJournalFrame_CIMISetLootButton)
    local encounterJournalLootFrame = _G["EncounterJournalEncounterFrameInfo"].LootContainer
    encounterJournalLootFrame:HookScript("OnUpdate", EncounterJournalFrame_CIMIOnValueChanged)
end

CanIMogIt.frame:AddEventFunction(OnEncounterJournalLoaded)


------------------------
-- Event functions    --
------------------------


local function EncounterJournalOverlayEvents(event, ...)
    if encounterJournalLoaded then
        EncounterJournalFrame_CIMIOnValueChanged()
    end
end

CanIMogIt.frame:AddOverlayEventFunction(EncounterJournalOverlayEvents)

CanIMogIt:RegisterMessage("OptionUpdate", EncounterJournalOverlayEvents)
