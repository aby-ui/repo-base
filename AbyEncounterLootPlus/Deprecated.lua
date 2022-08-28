--[[ --9.0早期资料片下拉菜单没有没有暗影国度的选项
CoreDependCall("Blizzard_EncounterJournal", function()
    hooksecurefunc("EJTierDropDown_Initialize", function(self, level)
        if not level then return end
        local listFrame = _G["DropDownList"..level];
        local expId = ELP_CURRENT_TIER
        if listFrame.numButtons >= expId then return end
        local info = UIDropDownMenu_CreateInfo();
        info.text = EJ_GetTierInfo(expId);
        info.func = EncounterJournal_TierDropDown_Select
        info.checked = expId == EJ_GetCurrentTier;
        info.arg1 = expId;
        UIDropDownMenu_AddButton(info, 1)
    end)
end)
--]]

--7.0可以计算出物品等级
     --item.link = select(2, GetItemInfo(format("item:%d::::::::120:70::23:1:%d:3524::", itemID, 1472+((db.forcelevel or 900)-iLevel)))) .. "\230\156\137\46\231\136\177"

--[[ 不再限制多副本不能选全部
    -- force slot filter to avoid too many items listed.
    if filter.type == "multi" then
        if C_EncounterJournal.GetSlotFilter() == ELP_ALL_SLOT then
            C_EncounterJournal.SetSlotFilter(ELP_DEFAULT_SLOT)
            EncounterJournal_RefreshSlotFilterText()
        end
    end

    /dump EncounterJournal.instanceSelect.scroll.child.InstanceButtons[3].mapID
    /dump EJ_GetInstanceInfo(1194)
    EncounterInstanceButtonTemplate EncounterInstanceButtonTemplate_OnClick EncounterJournal_DisplayInstance(self.instanceID);
    Aby是 hook EncounterJournal_OnFilterChanged
        ELP_Hook("EncounterJournal_LootUpdate", EncounterJournal_LootUpdate_ELP) --核心
        ELP_Hook("EncounterJournal_SetLootButton", EncounterJournal_SetLootButton_ELP)
        ELP_Hook("EncounterJournal_Loot_OnClick", EncounterJournal_Loot_OnClick_ELP)
    主要通过 ELP_UpdateItemList() -> RetrieveStart

    EncounterJournal_OnFilterChanged() -> EncounterJournal_LootUpdate()
        Aby在所有菜单点击时会调用此方法，其他情况认为不会有变化
    hook EncounterJournal_OnFilterChanged 调用 ELP_UpdateItemList，然后等到数据获取完毕后调用 EncounterJournal_LootUpdate
    EncounterJournal_LootUpdate()还有多处被调用，暴雪在里面 EncounterJournal_BuildLootItemList
        OnShow OnDateReceived DisplayInstance DisplayEncounter OnFilterChanged
        是否可以LootUpdate自己调用自己，不可以
        如果在LootUpdate里更新数据列表，因为hooksecurefunc("EncounterJournal_DisplayInstance")才会reset range，无法提前判断是否正常处理
            也许可以判断 display_by_us 进行处理
            EncounterJournal_BuildLootItemList 如果替换这个，最大的问题还是异步处理的问题. 而且这个用的是局部变量没法修改，必须copy LootUpdate代码
        要不要响应 EJ_LOOT_DATA_RECIEVED 事件，可以模仿AtlasLoot来做

    Loot界面右边 EncounterItemTemplate  EncounterJournal_Loot_OnClick  EncounterJournal_DisplayEncounter

Data
    ELP_LOOT_APPEND = {
        --/run local i,s=7,"" ELP.db.range = 4+i; local id=ELP_SEASON_MYTHICS[i][1] ELP_StartSearch(true); for item in pairs(ELP_LOOT_ARMOR_LIST[id]) do if not tContains(ELP.currs[1], item) then s=s..item.."," print(GetItemInfo(item), item) end end print(s)
        [SKIPS.Grimrail] = { 109937,109972,109978,109932,109934,109942,109946,109988,109983, },
        [SKIPS.IronDocks] = { 109802, },
    }

ELP_Iterate_Loot
    if ELP_LOOT_APPEND[insID] then
        local encounterID = select(2, next(curr_encts))
        for _, itemID in ipairs(ELP_LOOT_APPEND[insID]) do
            local _, link = GetItemInfo(itemID)
            ELP_UpdateCurrItem(itemID, insID, encounterID, link)
        end
    end

ELP_ShouldHideLootItem
    --[[ --车站码头用lootTable方式
        if ( insID == SKIPS.Grimrail or insID == SKIPS.IronDocks ) and classId == Enum.ItemClass.Armor then
            if subClassId == Enum.ItemArmorSubclass.Cloth or subClassId == Enum.ItemArmorSubclass.Leather or subClassId == Enum.ItemArmorSubclass.Mail or subClassId == Enum.ItemArmorSubclass.Plate then
                skip = not ELP_LOOT_ARMOR_LIST[insID][itemID] --车站和码头护甲只取列表里
            else
                if equipSlot == "INVTYPE_FINGER" or equipSlot == "INVTYPE_NECK" then
                    skip = true --车站码头不掉戒指项链
                end
            end
        end
    --]]
--]]