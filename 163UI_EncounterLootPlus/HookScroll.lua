local _, ELP = ...
local db = ELP.db
local curr_items, curr_encts, curr_insts = unpack(ELP.currs)

local INSTANCE_LOOT_BUTTON_HEIGHT = 64;

--[[------------------------------------------------------------
hook EncounterJournal_LootUpdate
---------------------------------------------------------------]]
EncounterJournal_LootUpdate_ELP = function()
    if db.range == 0 then
        local items = EncounterJournal.encounter.info.lootScroll.buttons;
        for _, item in ipairs(items) do if item.instance then item.instance:SetText("") end end
        return ELP_RunHooked("EncounterJournal_LootUpdate")
    end
    if ELP_IsRetrieving() then return end

    EncounterJournal_UpdateFilterString();
    local scrollFrame = EncounterJournal.encounter.info.lootScroll;
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local items = scrollFrame.buttons;
    local item, index;

    local numLoot = #curr_items --EJ_GetNumLoot();
    local buttonSize = INSTANCE_LOOT_BUTTON_HEIGHT;

    for i = 1, #items do
        item = items[i];
        index = offset + i;
        if index <= numLoot then
            item:SetHeight(INSTANCE_LOOT_BUTTON_HEIGHT);
            item.boss:Show();
            item.bossTexture:Show();
            item.bosslessTexture:Hide();
            item.index = index;
            EncounterJournal_SetLootButton(item);
        else
            item:Hide();
        end
    end

    local totalHeight = numLoot * buttonSize;
    HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight());
end

--[[------------------------------------------------------------
hook EncounterJournal_SetLootButton
---------------------------------------------------------------]]
local OTHER_CLASS = GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR, 0)
EncounterJournal_SetLootButton_ELP = function(item)
    if db.range == 0 then return ELP_RunHooked("EncounterJournal_SetLootButton", item) end
    local itemID = curr_items[item.index]
    local encounterID = curr_encts[itemID]
    local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice = GetItemInfo(itemID)
    item.link = link;
    if ( name ) then
        item.name:SetText(format("|cffb37fff%s|r", name)); --a335ee
        item.icon:SetTexture(icon);
        item.slot:SetText(_G[equipSlot] or equipSlot);
        item.armorType:SetText(subclass~=OTHER_CLASS and subclass or "");
        if not item.instance then
            item.instance = item:CreateFontString("$parentInst", "OVERLAY", "GameFontBlack")
            item.instance:SetJustifyH("RIGHT")
            item.instance:SetSize(0, 12)
            item.instance:SetPoint("BOTTOMRIGHT", -6, 6)
            item.instance:SetTextColor(0.25, 0.1484375, 0.02, 1)
        end
        local instance = curr_insts[itemID]
        instance = instance and EJ_GetInstanceInfo(instance)
        item.instance:SetText(instance or "")

        item.boss:SetFormattedText(BOSS_INFO_STRING, EJ_GetEncounterInfo(encounterID));

        SetItemButtonQuality(item, 4, itemID);

        item.link = "\231\189\145\046\230\152\147" .. select(2, GetItemInfo(format("item:%d::::::::110::::2:%d:3517::", itemID, 1472+((db.forcelevel or 900)-iLevel)))) .. "\230\156\137\46\231\136\177"
    else
        item.name:SetText(RETRIEVING_ITEM_INFO);
        item.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
        item.slot:SetText("");
        item.armorType:SetText("");
        item.boss:SetText("");
        if item.instance then item.instance:SetText("") end
    end
    item.encounterID = encounterID;
    item.itemID = itemID;
    --item.link = link;
    item:Show();
    if item.showingTooltip then
        EncounterJournal_SetTooltip(link);
    end
end

EncounterJournal_Loot_OnClick_ELP = function(self)
    if db.range == 0 then return ELP_RunHooked("EncounterJournal_Loot_OnClick", self) end
    local insID = curr_insts[self.itemID]
    local old = EncounterJournal.encounter.info.lootScroll.scrollBar:GetValue()
    ELP.display_by_us = true
    if insID then
        NavBar_Reset(EncounterJournal.navBar)
        EncounterJournal_DisplayInstance(insID)
    end
    PlaySound(829) --"igSpellBookOpen";
    EncounterJournal_DisplayEncounter(self.encounterID);
    EncounterJournal.encounter.info.lootScroll.scrollBar:SetValue(old)
    ELP.display_by_us = nil
end

function EncounterJournal_LootCalcScroll_ELP(offset)
    if db.range == 0 then return EncounterJournal_LootCalcScroll(offset) end
    local buttonHeight = BOSS_LOOT_BUTTON_HEIGHT;
    local numLoot = #curr_items

    if (true or not EncounterJournal.encounterID) then
        buttonHeight = INSTANCE_LOOT_BUTTON_HEIGHT;
    end

    local index = floor(offset/buttonHeight)
    return index, offset - (index*buttonHeight);
end

ELP.initScroll = function()
    ELP_Hook("EncounterJournal_LootUpdate", EncounterJournal_LootUpdate_ELP)
    ELP_Hook("EncounterJournal_SetLootButton", EncounterJournal_SetLootButton_ELP)
    ELP_Hook("EncounterJournal_Loot_OnClick", EncounterJournal_Loot_OnClick_ELP)

    EncounterJournal.encounter.info.lootScroll.update = EncounterJournal_LootUpdate_ELP;
    EncounterJournal.encounter.info.lootScroll.scrollBar.doNotHide = true;
    EncounterJournal.encounter.info.lootScroll.dynamic = EncounterJournal_LootCalcScroll_ELP;

    -- manually click boss will reset the option
    hooksecurefunc("EncounterJournal_DisplayEncounter", function()
        if not ELP.display_by_us and db.range ~= 0 then
            db.range = 0
            EncounterJournal_LootUpdate()
        end
    end)

    hooksecurefunc("EJ_ResetLootFilter", ELP_UpdateItemList)
    hooksecurefunc("ELP_UpdateItemList", function() EncounterJournal.encounter.info.lootScroll.scrollBar:SetValue(0) end)

    --fix sometime can't go back
    hooksecurefunc(EncounterJournalNavBarHomeButton, "Disable", function(self, enabled) self:SetEnabled(true) end)
    --fix icon position
    EncounterJournalEncounterFrameInfoLootTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoLootTab, -6, 0)
    EncounterJournalEncounterFrameInfoOverviewTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoOverviewTab, -6, 0)
    EncounterJournalEncounterFrameInfoBossTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoBossTab, -6, 0)
    EncounterJournalEncounterFrameInfoModelTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoModelTab, -6, 0)
end

