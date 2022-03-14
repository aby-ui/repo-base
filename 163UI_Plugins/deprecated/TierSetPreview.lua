CoreDependCall("Blizzard_EncounterJournal", function()
    local buttons = {}
    local chk = CreateFrame("CheckButton", "AbyTierSetPreview", EncounterJournal.LootJournal, "UICheckButtonTemplate")
    chk:SetPoint("TOPLEFT", 10, -10)
    chk:SetSize(24,24)
    CoreUIEnableTooltip(chk, "9.2套装效果", "目前看套装效果比较麻烦，爱不易做个小功能方便大家，只支持查看本职业的。\n（小号没有地下城手册，可运行 /abytz 命令强制打开）")
    chk:SetScript("OnClick", function(self)
        U1DBG.v920TierSetPreviewHide = not self:GetChecked()
        for _, btn in ipairs(buttons) do CoreUIShowOrHide(btn, self:GetChecked()) end
    end)

    local CURRENT_TIER, INSTANCE_INDEX = 9, 4
    EJ_SelectTier(CURRENT_TIER)
    local _, source = EJ_GetInstanceByIndex(INSTANCE_INDEX, true)
    local itemIDs = {}
    for _, v in pairs(C_TransmogSets.GetBaseSets()) do
        if v.label == source then
            local sources = C_TransmogSets.GetSourcesForSlot(v.setID, 1)
            for i, src in ipairs(sources) do
                itemIDs[#itemIDs + 1] = src.itemID
            end
            break
            --local index = special_class[select(2, UnitClass("player"))] or #sources --not sure: CollectionWardrobeUtil.GetValidIndexForNumSources(WardrobeCollectionFrame.tooltipSourceIndex, #sources);
            --itemId = sources[index].itemID
        end
    end
    if #itemIDs == 0 then
        chk:Hide()
        return
    end

    for i = 1, GetNumSpecializations() do
        buttons[i] = buttons[i] or CreateFrame("Button", "$parentTieSetPreview" .. i, chk, "UIMenuButtonStretchTemplate")
        buttons[i]:SetSize(48, 22)
        buttons[i]:ClearAllPoints()
        buttons[i]:SetPoint("LEFT", i == 1 and chk or buttons[i-1], "RIGHT", 0, 0)
        buttons[i]:SetFrameStrata("HIGH")
        local specId, specName = GetSpecializationInfo(i)
        buttons[i]:SetText(specName)
        buttons[i]:SetScript("OnEnter", function(self)
            if self.itemLink then
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:SetHyperlink(self.itemLink, 1, specId)
                GameTooltip:Show()
                return
            end
            for _, itemId in ipairs(itemIDs) do
                local _, link = GetItemInfo(itemId)
                if link then
                    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
                    GameTooltip:SetHyperlink(link, 1, specId)
                    GameTooltip:Show()
                    for j = 8, 20 do
                        local txt = _G["GameTooltipTextLeft" .. j]
                        if (txt and txt:GetText() or ""):find("%d/%d") then
                            self.itemLink = link
                            break
                        end
                    end
                    if self.itemLink == nil then
                        GameTooltip:Hide()
                    else
                        break
                    end
                end
            end
        end)
        buttons[i]:SetScript("OnLeave", function() GameTooltip:Hide() end)
        buttons[i]:SetScript("OnClick", function(self)
            if self.itemLink then
                CoreUIChatEdit_Insert(self.itemLink)
            end
        end)
    end

    if U1DBG.v920TierSetPreviewHide then
        chk:SetChecked(false)
        for _, btn in ipairs(buttons) do btn:Hide() end
    else
        chk:SetChecked(true)
    end
end)

CoreUIRegisterSlash('ABYUI_TIER_SET_PREVIEW', '/abytz', '/abytaozhuang', function()
    LoadAddOn("Blizzard_EncounterJournal")
    ShowUIPanel(EncounterJournal)
    EncounterJournalInstanceSelectLootJournalTab:Click()
end)