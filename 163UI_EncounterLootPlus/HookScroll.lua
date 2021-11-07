local _, ELP = ...
local db = ELP.db
local curr_items, curr_encts, curr_insts, _, curr_links = unpack(ELP.currs)

local INSTANCE_LOOT_BUTTON_HEIGHT = 64;

--[[------------------------------------------------------------
hook EncounterJournal_LootUpdate
---------------------------------------------------------------]]
EncounterJournal_LootUpdate_ELP = function()
    if db.range == 0 then
        local buttons = EncounterJournal.encounter.info.lootScroll.buttons;
        for _, button in ipairs(buttons) do if button.lootFrame.instance then button.lootFrame.instance:SetText("") end end
        return ELP_RunHooked("EncounterJournal_LootUpdate")
    end
    if ELP_IsRetrieving() then return end

    EncounterJournal_UpdateFilterString();
    local scrollFrame = EncounterJournal.encounter.info.lootScroll;
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local button, index;

    local numLoot = #curr_items --EJ_GetNumLoot();
    local buttonSize = INSTANCE_LOOT_BUTTON_HEIGHT;
    local buttons = scrollFrame.buttons;

    for i = 1, #buttons do
        button = buttons[i];
        index = offset + i;

        button.dividerFrame:Hide();
        local currentFrame = button.lootFrame;

        if index <= numLoot then
            button:SetHeight(INSTANCE_LOOT_BUTTON_HEIGHT);
            currentFrame.boss:Show();
            currentFrame.bossTexture:Show();
            currentFrame.bosslessTexture:Hide();
            button.index = index;
            EncounterJournal_SetLootButton(button);
        else
            button:Hide();
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
    --if not item.UpdateTooltip then item.UpdateTooltip = item:GetScript("OnEnter") end --for Azerite Tooltip Update
    if db.range == 0 then return ELP_RunHooked("EncounterJournal_SetLootButton", item) end
    local itemID = curr_items[item.index]
    local encounterID = curr_encts[itemID]
    local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice = GetItemInfo(itemID)
    link = curr_links[itemID]
    item.link = link;

    if true then --9.1.5
        item.lootFrame:Show();
        item.dividerFrame:Hide();
        item:SetEnabled(true);
    end

    local currentFrame = item.lootFrame;
    if ( name ) then
        currentFrame.name:SetText(format("|cffb37fff%s|r", name)); --a335ee
        currentFrame.icon:SetTexture(icon);
        currentFrame.slot:SetText(_G[equipSlot] or equipSlot);
        currentFrame.armorType:SetText(subclass~=OTHER_CLASS and subclass or "");
        if not currentFrame.instance then
            currentFrame.instance = item:CreateFontString("$parentInst", "OVERLAY", "GameFontBlack")
            currentFrame.instance:SetJustifyH("RIGHT")
            currentFrame.instance:SetSize(0, 12)
            currentFrame.instance:SetPoint("BOTTOMRIGHT", -6, 6)
            currentFrame.instance:SetTextColor(0.25, 0.1484375, 0.02, 1)
        end
        local instance = curr_insts[itemID]
        instance = instance and EJ_GetInstanceInfo(instance)
        currentFrame.instance:SetText(instance or "")

        currentFrame.boss:SetFormattedText(BOSS_INFO_STRING, EJ_GetEncounterInfo(encounterID));

        SetItemButtonQuality(currentFrame, 4, itemID);

        item.link = link; --"\231\189\145\046\230\152\147" .. select(2, GetItemInfo(format("item:%d::::::::120:70::23:1:%d:3524::", itemID, 1472+((db.forcelevel or 900)-iLevel)))) .. "\230\156\137\46\231\136\177"
    else
        currentFrame.name:SetText(RETRIEVING_ITEM_INFO);
        currentFrame.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
        currentFrame.slot:SetText("");
        currentFrame.armorType:SetText("");
        currentFrame.boss:SetText("");
        if currentFrame.instance then currentFrame.instance:SetText("") end
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
            C_EncounterJournal.SetSlotFilter(ELP_ALL_SLOT)
            EncounterJournal_RefreshSlotFilterText();
            EncounterJournal_LootUpdate()
        end
    end)

    hooksecurefunc("EncounterJournal_DisplayInstance", function()
        if not ELP.display_by_us and db.range ~= 0 then
            db.range = 0
            C_EncounterJournal.SetSlotFilter(ELP_ALL_SLOT)
            EncounterJournal_RefreshSlotFilterText();
            EncounterJournal_LootUpdate()
        end
    end)

    hooksecurefunc("EJ_ResetLootFilter", ELP_UpdateItemList)
    hooksecurefunc("ELP_UpdateItemList", function() EncounterJournal.encounter.info.lootScroll.scrollBar:SetValue(0) end)
    hooksecurefunc("EncounterJournal_UpdateFilterString", ELP_UpdateFilterString)

    --fix sometime can't go back
    hooksecurefunc(EncounterJournalNavBarHomeButton, "Disable", function(self, enabled) self:SetEnabled(true) end)
    --fix icon position
    EncounterJournalEncounterFrameInfoLootTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoLootTab, -6, 0)
    EncounterJournalEncounterFrameInfoOverviewTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoOverviewTab, -6, 0)
    EncounterJournalEncounterFrameInfoBossTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoBossTab, -6, 0)
    EncounterJournalEncounterFrameInfoModelTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoModelTab, -6, 0)
end

--[[------------------------------------------------------------
append EncounterJournal_UpdateFilterString
---------------------------------------------------------------]]
function ELP_UpdateFilterString()
    if db.range == 0 then return end

    local filter = db.range == 1 and "全部团本"
            or db.range == 2 and "地下城"
            or db.range == 3 and "全部副本"
            or db.range == 4 and "最新团本"
            or db.range == 5 and "最新副本" or ""

    if db.attr1 ~= 0 then
        filter = filter .. "：" .. ELP_ATTRS[db.attr1]
        if db.attr2 ~=0 and db.attr2 ~= db.attr1 then
            filter = filter .. " " .. ELP_ATTRS[db.attr2]
        end
    end

    local banner = EncounterJournal.encounter.info.lootScroll.classClearFilter
    if banner:IsShown() then
        local text = banner.text:GetText()
        local old = text --select(3, text:find((EJ_CLASS_FILTER:gsub("%%s", "(.+)")))) or text
        banner.text:SetText(old .. "，" .. filter)
    else
        banner.text:SetText(filter)
        EncounterJournal.encounter.info.lootScroll.classClearFilter:Show();
        EncounterJournal.encounter.info.lootScroll:SetHeight(360);
    end
end