--[[------------------------------------------------------------
2017.06, 2022.08 warbaby
---------------------------------------------------------------]]

ELP_DEFAULT_SLOT = Enum.ItemSlotFilterType.Finger
ELP_ALL_SLOT = Enum.ItemSlotFilterType.NoFilter
ELP_ATTRS = {
    [1] = STAT_CRITICAL_STRIKE,
    [2] = STAT_HASTE,
    [3] = STAT_MASTERY,
    [4] = STAT_VERSATILITY,
}

local _, ELP = ...
_G.ELP = ELP

local db = {
    range = 0,
    attr1 = 0,
    attr2 = 0,
    ITEMS = {},
}

ELP.db = db

local function ELP_FILTER()
    return ELP_FILTERS[db.range]
end

--[[------------------------------------------------------------
events handler
---------------------------------------------------------------]]
ELP.frame = CreateFrame("Frame")
ELP.frame:Hide()
ELP.frame:RegisterEvent("VARIABLES_LOADED")

ELP.frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "VARIABLES_LOADED" then
        if ELPDATA and db ~= ELPDATA then
            local newVersion = GetAddOnMetadata("AbyEncounterLootPlus", "X-DataVersion")
            local oldVersion = ELPDATA.dataVersion
            if oldVersion == newVersion then
                -- 使用之前保存的ITEM信息
                wipe(db)
                u1copy(ELPDATA, db)
            else
                -- 使用默认的空数据
                db.dataVersion = newVersion
            end
        end
        ELPDATA = db

        db.ITEMS = db.ITEMS or {}
        --db.range = 0 --通过正常点击重置而不是强制重置
        if not ELP_FILTERS[db.range] then
            db.range = 0
        end

        self:SetScript("OnUpdate", ELP_RetrieveNext) --initial Hidden

        CoreDependCall("Blizzard_EncounterJournal", function()
            local btn = WW:Button("ELPSeasonTab", EncounterJournal, "BottomEncounterTierTabTemplate")
            :SetText("赛季大秘"):kv("id", 5) --set automatically :TOPLEFT(EncounterJournal.LootJournalTab, "TOPRIGHT", 3, 0)
            :SetScript("OnClick", EJ_ContentTab_OnClick_ELP):un()
            PanelTemplates_SetNumTabs(EncounterJournal, 5);
            --选中后仍需要点击，所以需要手工隐藏高亮
            hooksecurefunc(btn, "Enable", function(self)
                local shown = EncounterJournal.selectedTab ~= self.id
                self.LeftHighlight:SetShown(shown)
                self.RightHighlight:SetShown(shown)
                self.MiddleHighlight:SetShown(shown)
            end)
            btn.Disable = btn.Enable
            CoreUIEnableTooltip(btn, "爱不易提示", "此处为9.2.7方便查询史诗钥石掉落的入口。原来的爱不易装备搜索功能仍在'装备筛选'的下拉菜单中（可以按装备属性搜索全部副本装备），另外按住ALT点此标签也能直接跳转")

            EncounterJournalEncounterFrameInfoLootTab:Click() --初始为掉落面板

            ELP.setupHooks()
        end)
    end
end)

EJ_ContentTab_OnClick_ELP = function(self)
    --EJ_ContentTab_OnClick
    EJ_ContentTab_Select(self.id);
    local instanceSelect = EncounterJournal.instanceSelect;
    local tierData = GetEJTierData(ELP_VERSION_TIER);
    instanceSelect.bg:SetAtlas(tierData.backgroundAtlas, true);

    EJ_HideNonInstancePanels();
    instanceSelect.ScrollBox:Show();
    EncounterJournal_ListInstances_ELP() --abyui
    EncounterJournal_DisableTierDropDown(true);

    if IsModifierKeyDown() then
        if db.range == 0 then db.range = 1 end
        ELP_MenuOnClick(nil, "range", db.range)
    end
end

-- GetSeasonInstanceByIndex
function EJ_GetInstanceByIndex_ELP(index)
    local data = ELP_SEASON_MYTHICS[index]
    if data == nil then return end
    local instanceID = data[1]
    return instanceID, data[3], select(2, EJ_GetInstanceInfo(instanceID)) --EJ_GetInstanceByIndex(3, false) 和 EJ_GetInstanceInfo(1194) 暂时一致
end

-- ListSeasonInstances, copy from blizzard EncounterJournal_ListInstances
function EncounterJournal_ListInstances_ELP()
    local EJ_NUM_INSTANCE_PER_ROW = 4
    local EJ_GetInstanceByIndex = EJ_GetInstanceByIndex_ELP

    local instanceSelect = EncounterJournal.instanceSelect;

    --local tierName = EJ_GetTierInfo(EJ_GetCurrentTier());
    --UIDropDownMenu_SetText(instanceSelect.tierDropDown, tierName);
    NavBar_Reset(EncounterJournal.navBar);
    EncounterJournal.encounter:Hide();
    instanceSelect:Show();

    local dataIndex = 1;
    local showRaid = not EncounterJournal.raidsTab:IsEnabled(); --nouse
    local instanceID, name, description, _, buttonImage, _, _, _, link, _, mapID = EJ_GetInstanceByIndex_ELP(dataIndex, showRaid);

    local dataProvider = CreateDataProvider();
    while instanceID ~= nil do
        dataProvider:Insert({
            instanceID = instanceID,
            name = name,
            description = description,
            buttonImage = buttonImage,
            link = link,
            mapID = mapID,
            seasonIndex = dataIndex,
        });

        dataIndex = dataIndex + 1;
        instanceID, name, description, _, buttonImage, _, _, _, link = EJ_GetInstanceByIndex_ELP(dataIndex, showRaid);
    end
    EncounterJournal.instanceSelect.ScrollBox:SetDataProvider(dataProvider);
end

function ELP_InstanceSelectScrollViewElementFactory(factory, elementData)
    if not elementData.seasonIndex then return end --set in EncounterJournal_ListInstances_ELP
    local instanceButton = EncounterJournalInstanceSelect.ScrollBox.view.factoryFrame --factory acquired scroll line frame
    instanceButton.seasonIndex = elementData.seasonIndex --normal dungeon and raid also set, but not matter.
    if instanceButton:GetScript("PreClick") == nil then
        instanceButton:SetScript("PreClick", function(self)
            if EncounterJournal.selectedTab == ELP_SEASON_TAB_ID and self.seasonIndex then
                for i, v in ipairs(ELP_FILTERS) do
                    if v.type == "dungeon" then
                        db.range = i - 1 + self.seasonIndex
                        break
                    end
                end
                ELP.do_not_reset_state = true --没啥好办法, 从这里点DisplayInstance也不能Reset, 但是没有
            else
                --db.range = 0 --在这里修改会导致Reset不能运行, "DisplayInstance_ELP 会处理
            end
        end)
        instanceButton:SetScript("PostClick", function()
            ELP_StartSearch(false)
            ELP.do_not_reset_state = nil
        end)
    end
end

--进入爱不易搜索模式，两个入口"赛季大秘"里的副本按钮和爱不易搜索下拉框
function ELP_StartSearch(displayInstance)
    if not ELP_IsNormalState() then
        if displayInstance then
            local insID = next(ELP_FILTER().instances)
            ELP_DisplayInstanceAndEncounterByUS(insID) --选中一下面板, 变一下更好
        end
        ELP_SetDefaultSlotFilterWhenManualClick()
        EncounterJournalEncounterFrameInfoLootTab:Click()
        EncounterJournalEncounterFrameInfoFilterToggle:Click()
        EncounterJournal_OnFilterChanged_ELP()
    end
end

function ELP_IsNormalState()
    return db.range == 0
end

--[[------------------------------------------------------------
 items retrieve
---------------------------------------------------------------]]

-- 没有属性的部位，忽略选择的属性
local SLOTS_WITH_NO_STATS = {
    [Enum.ItemSlotFilterType.Other] = true,
}

ELP.currs = { {}, {}, {}, {}, {} }
--curr_items是itemID的数组, 其他为itemID为key的map. itemID需要保存多个属性, 避免创建过多table
local curr_items, curr_insts, curr_encts, curr_links, curr_retrieving = unpack(ELP.currs)

function ELP_IsRetrieving()
    return next(curr_retrieving) ~= nil
end

function ELP_RetrieveNext()
    local itemID = next(curr_retrieving)
    while(itemID and db.ITEMS[itemID]) do
        curr_retrieving[itemID] = nil
        itemID = next(curr_retrieving, itemID)
    end
    if itemID == nil then
        ELP_RetrieveDone()
    else
        local stats = ELP_ScanStats(curr_links[itemID])
        if stats ~= nil then
            --if type(stats) == "table" then print(itemID, select(2, GetItemInfo(itemID)), unpack(stats, 2, 5)) end
            db.ITEMS[itemID] = stats
            curr_retrieving[itemID] = nil
        end
    end
end

local function sortByAttr1(a, b)
    local attr = db.attr1
    local aa = db.ITEMS[a][attr]
    local bb = db.ITEMS[b][attr]
    if aa == bb then
        return a < b
    else
        return aa > bb
    end
end

--全部物品检索完毕后, 装备属性已获取, 根据玩家选择进行过滤, 更新界面
function ELP_RetrieveDone()
    ELP.frame:Hide()
    for itemID, insID in pairs(curr_insts) do
        if ELP_ShouldHideLootItem(itemID, insID) then
            --不加入curr_items
        else
            if SLOTS_WITH_NO_STATS[C_EncounterJournal.GetSlotFilter()] then
                tinsert(curr_items, itemID) --'其他'部位不判断装备属性
            elseif (db.attr1 == 0 or (db.attr1 ~= 0 and type(db.ITEMS[itemID])=="table" and db.ITEMS[itemID][db.attr1]))
                and (db.attr1 == 0 or db.attr2 == 0 or (db.attr2 ~= 0 and type(db.ITEMS[itemID])=="table" and db.ITEMS[itemID][db.attr2])) then
                tinsert(curr_items, itemID) --未搜索装备属性或装备属性匹配
            end
        end
    end
    -- sort according to attr1
    if db.attr1 ~= 0 and not SLOTS_WITH_NO_STATS[C_EncounterJournal.GetSlotFilter()] then
        table.sort(curr_items, sortByAttr1)
    end
    EncounterJournal_LootUpdate_ELP()
end

function ELP_RetrieveStart()
    if ELP_IsRetrieving() then
        ELP.frame:Show()
    else
        ELP_RetrieveDone()
    end
end

function ELP_UpdateCurrItem(itemID, insID, encounterID, link)
    if not curr_insts[itemID] then
        if not db.ITEMS[itemID] then
            curr_retrieving[itemID] = 1
        end
        curr_encts[itemID] = encounterID
        curr_insts[itemID] = insID
        --11:54:58 [1]="\124cffa335ee\124Hitem:109821::::::::60:65::33:8:7359:8253:8765:8136:8116:6652:3173:6646:1:28:1279:::::\124h[裂胆腿甲]\124h\124r"
        local link = link
        if link and ELP_LINK_REPLACE[insID] then
            link = link:gsub("(\124Hitem:%d+).-(\124h.-\124h)", "%1"..ELP_LINK_REPLACE[insID].."%2")
        end
        curr_links[itemID] = link
    end
end

function ELP_Iterate_Loot(insID, bosses, lootTable)
    for loot = 1, EJ_GetNumLoot() do
        local info = C_EncounterJournal.GetLootInfoByIndex(loot)
        if info.displayAsPerPlayerLoot then
            --不处理独立掉落的内容
        else
            local itemID = info.itemID
            if lootTable and not lootTable[itemID] then
                --拾取列表方式只处理列表里的
            else
                if bosses == "all" or bosses[info.encounterID] then --只保留指定boss
                    if lootTable and lootTable[itemID] and ELP_LOOT_TABLE_LOOTS_ALL[itemID] ~= insID then
                        insID = ELP_LOOT_TABLE_LOOTS_ALL[itemID]
                        info.encounterID = nil
                    end
                    local mod = EJ_GetNumEncountersForLootByIndex(loot) > 1 and -1 or 1 --复数表示多boss掉落
                    ELP_UpdateCurrItem(itemID, insID, info.encounterID and mod * info.encounterID or nil, info.link)
                end
            end
        end
    end
end

--筛选部位下拉菜单, 仅支持单一副本(支持指定boss和特定过滤, 但不支持属性过滤)
function ELP_Iterate_Loot_FilterType(isLootSlotPresent, insID, bosses, lootTable)
    local numLoot = EJ_GetNumLoot();
    for i = 1, numLoot do
        local itemInfo = C_EncounterJournal.GetLootInfoByIndex(i);
        if lootTable and not lootTable[itemInfo.itemID] then
            --忽略不在拾取列表里的装备
        elseif (bosses == "all" or bosses[itemInfo.encounterID])
                and not itemInfo.displayAsPerPlayerLoot
                and not ELP_ShouldHideLootItem(itemInfo.itemID, insID)
        then
            local filterType = itemInfo and itemInfo.filterType;
            if ( filterType ) then
                isLootSlotPresent[filterType] = true;
            end
        end
    end
end

function ELP_SetInstanceTitleToFilterName(filter, name)
    filter = filter or ELP_FILTER()
    if not name and filter and filter.type ~= "multi" then
        name = filter.text
    end
    if name then
        EncounterJournal.encounter.info.instanceTitle:SetText(name)
    end
end

--玩家改变筛选条件后, 提取相关的物品ID, 启动物品检索
local tempInstances = {}
function ELP_UpdateItemList()
    if ELP_IsNormalState() then return end
    if not EncounterJournalEncounterFrameInfo.LootContainer.ScrollBox.ScrollTarget:IsVisible() then return end
    local EncounterJournal = EncounterJournal or CreateFrame("Frame")
    EncounterJournal:UnregisterEvent("EJ_LOOT_DATA_RECIEVED")
    EncounterJournal:UnregisterEvent("EJ_DIFFICULTY_UPDATE")
    for _, v in ipairs(ELP.currs) do wipe(v) end

    local filter = ELP_FILTER()

    wipe(tempInstances)
    u1copy(filter.instances, tempInstances)
    if filter.otherInstances then
        u1copy(filter.otherInstances, tempInstances)
    end
    for insID, insData in pairs(tempInstances) do
        local diff = ELP_INSTANCE_DIFFICULTY[insID]
        if diff and diff ~= EJ_GetDifficulty() then
            EJ_SetDifficulty(diff) --需要在SelectInstance之前设置，最好改成异步响应EJ_DIFFICULTY_UPDATE
            --ELP_SetBestDifficulty(insID)
        end
        EJ_SelectInstance(insID)
        ELP_Iterate_Loot(insID, insData.bosses, insData.lootTable)
    end

    EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
    EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE")
    --EncounterJournal.encounter.info.LootContainer.ScrollBox:SetScrollPercentage(0) --意义不明

    ELP_SetInstanceTitleToFilterName(filter)

    ELP_RetrieveStart()
end

--检索过程中可能会出现数据更新消息, 重新检索 (已检索的已记录到db, 剩余的会被wipe清理)
CoreOnEventBucket("EJ_LOOT_DATA_RECIEVED", 0.25, function(...)
    if not ELP_IsNormalState() then
        ELP_UpdateItemList()
    end
end)

--[[------------------------------------------------------------
HookMenus 职业过滤菜单及部位过滤菜单
---------------------------------------------------------------]]
function ELP_SetBackground()
    local des = not ELP_IsNormalState()
    EncounterJournalEncounterFrameInfoBG:SetDesaturated(des)
    EncounterJournalEncounterFrameInfoLeftHeaderShadow:SetDesaturated(des)
    EncounterJournalEncounterFrameInfoRightHeaderShadow:SetDesaturated(des)
    for i=1, 20 do
        local bb = _G["EncounterJournalBossButton"..i]
        if not bb then break end
        bb:GetNormalTexture():SetDesaturated(des)
    end
end

EncounterJournal_OnFilterChanged_ELP = function()
    ELP_SetBackground()
    if ELP_IsNormalState() then
        return ELP_RunOrigin("EncounterJournal_OnFilterChanged")
    else
        CloseDropDownMenus(1);
        ELP_UpdateItemList()
    end
end

function ELP_MenuOnClick(self, var, value)
    db[var] = value
    if var == "range" and value == 0 then
        ELP_ResetToNormalState()
        EncounterJournal_OnFilterChanged_ELP()
    else
        ELP_StartSearch(true)
    end
    CloseDropDownMenus(1)
end

local function makeSubInfo(info, text, value, var, level)
    info.text = text
    info.arg1 = var
    info.arg2 = value
    info.checked = db[var] == value
    info.func = ELP_MenuOnClick
    UIDropDownMenu_AddButton(info, level)
end

-- 职业过滤菜单增加爱不易过滤器和2个属性过滤器
function EncounterJournal_InitLootFilter_ELP(self, level)
    local info = UIDropDownMenu_CreateInfo();
    if (level == 1) then
        info.text = "爱不易装备搜索"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = true
        info.value = "range"
        UIDropDownMenu_AddButton(info, level)

        info.disabled = ELP_IsNormalState()
        info.text = "选择属性1"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = not info.disabled
        info.value = "attr1"
        UIDropDownMenu_AddButton(info, level)

        info.disabled = ELP_IsNormalState() or db.attr1 == 0
        info.text = "选择属性2"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = not info.disabled
        info.value = "attr2"
        UIDropDownMenu_AddButton(info, level)

        info.disabled = nil
    end

    if (UIDROPDOWNMENU_MENU_VALUE == "range") then
        makeSubInfo(info, "正常(暴雪原始功能)", 0, "range", level)
        for i, v in ipairs(ELP_FILTERS) do
            local prefix = v.type == "dungeon" and "史诗钥石：" or v.type == "raid" and "团本：" or ""
            makeSubInfo(info, prefix .. v.text, i, "range", level)
        end
    elseif (UIDROPDOWNMENU_MENU_VALUE == "attr1") then
        makeSubInfo(info, "任意", 0, "attr1", level)
        for id, text in pairs(ELP_ATTRS) do
            makeSubInfo(info, "+ " .. text, id, "attr1", level)
        end
        info.disabled = nil
    elseif (UIDROPDOWNMENU_MENU_VALUE == "attr2") then
        makeSubInfo(info, "任意", 0, "attr2", level)
        for id, text in pairs(ELP_ATTRS) do
            info.disabled = db.attr1 == id
            makeSubInfo(info, "+ " .. text, id, "attr2", level)
        end
        info.disabled = nil
    end

    EncounterJournal_InitLootFilter(self, level)
end


--部位过滤菜单 对于单一副本, 通过重置部位过滤重新获取一次所有装备的部位列表。对多副本则返回全部（不好实现而且基本都是全部部位都有）
function EncounterJournal_InitLootSlotFilter_ELP(self, level)
    if ELP_IsNormalState() then return EncounterJournal_InitLootSlotFilter(self, level) end

    local slotFilter = C_EncounterJournal.GetSlotFilter();

   	local info = UIDropDownMenu_CreateInfo();
    info.text = ALL_INVENTORY_SLOTS;
    info.checked = slotFilter == Enum.ItemSlotFilterType.NoFilter;
    info.arg1 = Enum.ItemSlotFilterType.NoFilter;
    info.func = EncounterJournal_SetSlotFilter;
    UIDropDownMenu_AddButton(info);

    local isLootSlotPresent;
    local efilter = ELP_FILTER()
    if efilter.type ~= "multi" then
        --单一副本获取全部部位列表, 但选了属性的话仍然不准确, 意义不大
        C_EncounterJournal.ResetSlotFilter();
        wipe(tempInstances)
        u1copy(efilter.instances, tempInstances)
        if efilter.otherInstances then
            u1copy(efilter.otherInstances, tempInstances)
        end
        isLootSlotPresent = {}
        for insID, insData in pairs(tempInstances) do
            EJ_SelectInstance(insID)
            ELP_Iterate_Loot_FilterType(isLootSlotPresent, insID, insData.bosses, insData.lootTable)
        end
        C_EncounterJournal.SetSlotFilter(slotFilter);
    end

   	for _, filter in pairs(Enum.ItemSlotFilterType) do
        if ( (isLootSlotPresent == nil or isLootSlotPresent[filter] or filter == slotFilter) and filter ~= Enum.ItemSlotFilterType.NoFilter ) then
   			info.text = SlotFilterToSlotName_ELP[filter];
   			info.checked = slotFilter == filter;
   			info.arg1 = filter;
   			UIDropDownMenu_AddButton(info);
   		end
   	end
end

--[[------------------------------------------------------------
HookScrolls 掉落列表界面相关
---------------------------------------------------------------]]
local INSTANCE_LOOT_BUTTON_HEIGHT = 64;

--[[------------------------------------------------------------
replace EncounterJournal_LootUpdate
---------------------------------------------------------------]]
EncounterJournal_LootUpdate_ELP = function()
    if ELP_IsNormalState() then return ELP_RunOrigin("EncounterJournal_LootUpdate") end
    if ELP_IsRetrieving() then return end

    EncounterJournal_UpdateFilterString();

    --不处理独立掉落的内容(导灵器、坐骑这种，没意义且可能太多)
    local scrollBox = EncounterJournal.encounter.info.LootContainer.ScrollBox;
    local dataProvider = CreateDataProvider();
    local loot = {};
    for i = 1, #curr_items do
        dataProvider:Insert({index=i});
    end
    scrollBox:SetDataProvider(dataProvider);
end

--[[------------------------------------------------------------
hook EncounterJournal_SetLootButton
---------------------------------------------------------------]]
local OTHER_CLASS = GetItemSubClassInfo(Enum.ItemClass.Armor, 0)
local tmpItemInfo = {}
EncounterJournalItemMixin_Init_ELP = function(self, elementData)
    --if not self.UpdateTooltip then self.UpdateTooltip = self:GetScript("OnEnter") end --for Azerite Tooltip Update
    if ELP_IsNormalState() then
        if self.instance then self.instance:SetText("") end
        return ELP_RunOrigin("EncounterJournalItemMixin.Init", self, elementData)
    end

    local index = elementData.index;
    if (false) then
        self:SetHeight(BOSS_LOOT_BUTTON_HEIGHT);
        self.boss:Hide();
        self.bossTexture:Hide();
        self.bosslessTexture:Show();
    else
        self:SetHeight(INSTANCE_LOOT_BUTTON_HEIGHT);
        self.boss:Show();
        self.bossTexture:Show();
        self.bosslessTexture:Hide();
    end
    self.index = index;

    local itemID = curr_items[self.index]
    local itemInfo = tmpItemInfo
    table.wipe(itemInfo)
    itemInfo.encounterID = curr_encts[itemID]
    itemInfo.itemID = itemID
    if not itemID then return end
    itemInfo.name, itemInfo.link, itemInfo.itemQuality, itemInfo.iLevel, itemInfo.reqLevel, itemInfo.class, itemInfo.subclass, itemInfo.maxStack, itemInfo.slot, itemInfo.icon, itemInfo.vendorPrice = GetItemInfo(itemID)
    itemInfo.itemQuality = max(4, itemInfo.itemQuality or 0) --all epic in mythic+
    itemInfo.link = curr_links[itemID]

    if ( itemInfo.link ) then
        self.name:SetText(WrapTextInColor(itemInfo.name, ITEM_QUALITY_COLORS[itemInfo.itemQuality].color));
        self.icon:SetTexture(itemInfo.icon);
        if itemInfo.handError then
            self.slot:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(itemInfo.slot));
        else
            self.slot:SetText(_G[itemInfo.slot] or itemInfo.slot);
        end
        if itemInfo.weaponTypeError then
            self.armorType:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(itemInfo.armorType));
        else
            self.armorType:SetText(itemInfo.subclass~=OTHER_CLASS and itemInfo.subclass or "");
        end

        if not self.instance then
            self.instance = self:CreateFontString("$parentInst", "OVERLAY", "GameFontBlack")
            self.instance:SetJustifyH("RIGHT")
            self.instance:SetSize(0, 12)
            self.instance:SetPoint("BOTTOMRIGHT", -6, 6)
            self.instance:SetTextColor(0.25, 0.1484375, 0.02, 1)
        end
        local instance = curr_insts[itemID]
        instance = instance and EJ_GetInstanceInfo(instance)
        self.instance:SetText(instance or "")

        local numEncounters = itemInfo.encounterID and 1 or 0 --只支持0个,1个,或多个 EJ_GetNumEncountersForLootByIndex(self.index);
        if (itemInfo.encounterID or 0) < 0 then
            itemInfo.encounterID = -itemInfo.encounterID
            numEncounters = 3
        end
        if ( numEncounters == 1 ) then
            self.boss:SetFormattedText(BOSS_INFO_STRING, EJ_GetEncounterInfo(itemInfo.encounterID) or UNKNOWN);
        elseif ( numEncounters == 2) then
            local itemInfoSecond = C_EncounterJournal.GetLootInfoByIndex(self.index, 2);
            local secondEncounterID = itemInfoSecond and itemInfoSecond.encounterID;
            if ( itemInfo.encounterID and secondEncounterID ) then
                self.boss:SetFormattedText(BOSS_INFO_STRING_TWO, EJ_GetEncounterInfo(itemInfo.encounterID), EJ_GetEncounterInfo(secondEncounterID));
            end
        elseif ( numEncounters > 2 ) then
            self.boss:SetFormattedText(BOSS_INFO_STRING_MANY, EJ_GetEncounterInfo(itemInfo.encounterID) or UNKNOWN);
        end

        --local itemName, _, quality = GetItemInfo(itemInfo.link);
        SetItemButtonQuality(self, itemInfo.itemQuality, itemInfo.link); --for TinyInspect
    else
        self.name:SetText(RETRIEVING_ITEM_INFO);
        self.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
        self.slot:SetText("");
        self.armorType:SetText("");
        self.boss:SetText("");
        if self.instance then self.instance:SetText("") end
    end
    self.encounterID = itemInfo and itemInfo.encounterID;
    self.itemID = itemInfo and itemInfo.itemID;
    self.link = itemInfo and itemInfo.link;
    if self.showingTooltip then
        EncounterJournal_SetTooltip(self.link);
    end
end

function ELP_DisplayInstanceAndEncounterByUS(insID, encounterID)
    ELP.do_not_reset_state = true
    if encounterID then ELP.bosslist = ELP_ENCOUNTER_SAMEINSTANCE_BOSSES[encounterID] end --列表boss时替换掉
    if insID then
            NavBar_Reset(EncounterJournal.navBar) --reset in DisplayInstance POST
            EncounterJournal_DisplayInstance(insID)
            --PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN);
    end
    if encounterID then
        EncounterJournal_DisplayEncounter(encounterID); --do_not_reset_state后只选中boss但不会变列表
    end
    ELP.bosslist = nil
    ELP.do_not_reset_state = nil
end

EncounterJournal_Loot_OnClick_ELP = function(self)
    if ELP_IsNormalState() then return ELP_RunOrigin("EncounterJournal_Loot_OnClick", self) end
    local insID = curr_insts[self.itemID]
    local encounterID = self.encounterID --remember before change
    local old = EncounterJournal.encounter.info.LootContainer.ScrollBox:GetScrollPercentage()
    --最后决定用户在爱不易查询状态下点击boss无效, 没有hook EncounterJournal_DisplayEncounter
    ELP_DisplayInstanceAndEncounterByUS(insID, encounterID)
    EncounterJournal.encounter.info.LootContainer.ScrollBox:SetScrollPercentage(old)

    --scroll boss list to selected encounter
    if encounterID then
        EncounterJournal.encounter.info.BossesScrollBox:ScrollToElementDataByPredicate(function(data)
            return select(3, EJ_GetEncounterInfoByIndex(data.index)) == encounterID
        end)
    end
end

--[[------------------------------------------------------------
在顶部显示"全部副本：暴击 急速"字样
---------------------------------------------------------------]]
function EncounterJournal_UpdateFilterString_ELP_POST()
    if ELP_IsNormalState() then return end

    local filter = ELP_FILTER()
    local name = (filter.type == "multi" and (filter.short or filter.text)) or "单一副本"
    local append = name

    if db.attr1 ~= 0 then
        append = append .. "：" .. ELP_ATTRS[db.attr1]
        if db.attr2 ~=0 and db.attr2 ~= db.attr1 then
            append = append .. " " .. ELP_ATTRS[db.attr2]
        end
    end
    append = append .. format("：%d项", #curr_items)

    local banner = EncounterJournal.encounter.info.LootContainer.classClearFilter
    if banner:IsShown() then
        local text = banner.text:GetText()
        local old = text:gsub(EJ_CLASS_FILTER:gsub("%%s", "(.+)"), "职业：%1")
        banner.text:SetText(old .. (name == "" and "" or "，") .. append)
    else
        banner.text:SetText(append)
        RunOnNextFrameKey("AbyEncounterLootPlusShowFilter", function() EncounterJournal.encounter.info.LootContainer.classClearFilter:Show() end) --处理self:GetParent():Hide();
        EncounterJournal.encounter.info.LootContainer.ScrollBox:SetPoint("TOPLEFT", banner, "BOTTOMLEFT", 14, 7);
    end
end

function ELP_ResetToNormalState()
    if not ELP.do_not_reset_state and not ELP_IsNormalState() then
        db.range = 0
        local instanceID = EncounterJournal.instanceID
        local encounterID = EncounterJournal.encounterID
        if instanceID then
            NavBar_Reset(EncounterJournal.navBar);
            EJ_SelectInstance(instanceID);
            --ELP_SetBestDifficulty(instanceID);
            C_EncounterJournal.SetSlotFilter(ELP_ALL_SLOT);
            EncounterJournal_RefreshSlotFilterText();
            EncounterJournal_DisplayInstance(instanceID)
            if encounterID then
                EncounterJournal_DisplayEncounter(encounterID)
            end
            EncounterJournal_OnFilterChanged_ELP()
        end
    end
end

function ELP_SetDefaultSlotFilterWhenManualClick()
    if not ELP_IsNormalState() and ELP_FILTER().type == "multi" then
        if C_EncounterJournal.GetSlotFilter() == ELP_ALL_SLOT then
            C_EncounterJournal.SetSlotFilter(ELP_DEFAULT_SLOT)
            EncounterJournal_RefreshSlotFilterText()
        end
    end
end

function EJ_ResetLootFilter_ELP()
    ELP_RunOrigin("EJ_ResetLootFilter")
    db.attr1 = 0
    db.attr2 = 0
    ELP_SetDefaultSlotFilterWhenManualClick() --避免选择多个副本的全部, 但玩家可以再次手工选择全部
    EncounterJournal_OnFilterChanged_ELP() --系统自带的不会更新
end

function EJ_GetEncounterInfoByIndex_ELP(index, ...)
    if ELP_IsNormalState() then
        return ELP_RunOrigin("EJ_GetEncounterInfoByIndex", index, ...)
    end
    local bosslist = ELP.bosslist or ELP_FILTER() and ELP_FILTER().bosslist
    if bosslist then
        local bossId = bosslist[index]
        if bossId then
            return EJ_GetEncounterInfo(bossId)
        end
    else
        return ELP_RunOrigin("EJ_GetEncounterInfoByIndex", index, ...)
    end
end

function EncounterJournal_DisplayInstance_ELP(insID, noButton)
    if not ELP.do_not_reset_state and not ELP_IsNormalState() then
        EncounterJournal.instanceID = insID
        EncounterJournal.encounterID = nil
        return ELP_ResetToNormalState()
    end
    ELP_RunOrigin("EncounterJournal_DisplayInstance", insID, noButton)
    if ELP_IsNormalState() then return end

    ELP_SetBackground()
    if not noButton then
        NavBar_Reset(EncounterJournal.navBar)
        --NavBar_OpenTo(EncounterJournal.navBar, EncounterJournal.instanceID);
        local filter = ELP_FILTER()
        local buttonData = {
            id = insID,
            name = filter.short or filter.text,
            OnClick = EncounterJournal_OnFilterChanged_ELP, --EJNAV_RefreshInstance,
            listFunc = function(self) --EJNAV_GetInstanceList
                local list = { };
                for i, v in ipairs(ELP_FILTERS) do
                    local prefix = v.type == "dungeon" and "史诗钥石：" or v.type == "raid" and "团本：" or ""
                    local entry = {
                        text = prefix .. v.text,
                        id = i,
                        func = function(self, index, navBar) --EJNAV_SelectInstance
                            NavBar_Reset(navBar);
                            db.range = index
                            ELP_StartSearch(true)
                        end
                    };
                    tinsert(list, entry);
                end
                return list;
            end,
        }
        NavBar_AddButton(EncounterJournal.navBar, buttonData);
    end
end

function EncounterJournal_DisplayEncounter_ELP_POST(encounterID)
    --ELP_ResetToNormalState() --用户点击boss按钮是否重置查询状态, 可以考虑按Ctrl就行
    ELP_SetInstanceTitleToFilterName(nil, encounterID and ELP_ENCOUNTER_INSTANCE_NAME[encounterID])
end

ELP.setupHooks = function()
    --副本选择按钮点击处理
    hooksecurefunc(EncounterJournalInstanceSelect.ScrollBox.view, "elementFactory", ELP_InstanceSelectScrollViewElementFactory)

    ELP_Replace("EncounterJournal_OnFilterChanged", EncounterJournal_OnFilterChanged_ELP)
    UIDropDownMenu_Initialize(EncounterJournal.encounter.info.LootContainer.lootFilter, EncounterJournal_InitLootFilter_ELP, "MENU");
    UIDropDownMenu_Initialize(EncounterJournal.encounter.info.LootContainer.lootSlotFilter, EncounterJournal_InitLootSlotFilter_ELP, "MENU");

    ELP_Replace("EncounterJournal_LootUpdate", EncounterJournal_LootUpdate_ELP)
    ELP_Replace("EncounterJournalItemMixin.Init", EncounterJournalItemMixin_Init_ELP)
    ELP_Replace("EncounterJournal_Loot_OnClick", EncounterJournal_Loot_OnClick_ELP)

    --for LootItemButton height when choose encounter.
    local originExtentCalculator = EncounterJournal.encounter.info.LootContainer.ScrollBox.view:GetElementExtentCalculator()
    local function newExtentCalculator(...)
        if not ELP_IsNormalState() then
            return INSTANCE_LOOT_BUTTON_HEIGHT
        else
            return originExtentCalculator(...)
        end
    end
    EncounterJournal.encounter.info.LootContainer.ScrollBox.view:SetElementExtentCalculator(newExtentCalculator)

    -- wired, only with this line the Init is hooked
    CoreUIHookPoolCollection(EncounterJournalEncounterFrameInfo.LootContainer.ScrollBox.view.poolCollection, function(frame, frameType, template)
        if template == "EncounterItemTemplate" then
            frame.Init = EncounterJournalItemMixin_Init_ELP
        end
    end)

    EncounterJournal.encounter.info.LootContainer.ScrollBar.doNotHide = true;

    -- manually click boss will reset the option
    hooksecurefunc("EncounterJournal_DisplayEncounter", EncounterJournal_DisplayEncounter_ELP_POST)
    ELP_Replace("EncounterJournal_DisplayInstance", EncounterJournal_DisplayInstance_ELP) --必须replace, 不然无法及时reset, 导致UpdateFilterString state错误

    hooksecurefunc("EJ_ResetLootFilter", ELP_UpdateItemList)
    hooksecurefunc("EncounterJournal_UpdateFilterString", EncounterJournal_UpdateFilterString_ELP_POST)

    --fix sometime can't go back
    hooksecurefunc(EncounterJournalNavBarHomeButton, "Disable", function(self, enabled) self:SetEnabled(true) end)
    --fix icon position
    EncounterJournalEncounterFrameInfoLootTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoLootTab, -6, 0)
    EncounterJournalEncounterFrameInfoOverviewTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoOverviewTab, -6, 0)
    EncounterJournalEncounterFrameInfoBossTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoBossTab, -6, 0)
    EncounterJournalEncounterFrameInfoModelTabSelect:SetPoint("RIGHT", EncounterJournalEncounterFrameInfoModelTab, -6, 0)

    hooksecurefunc(EncounterJournal.encounter.info.difficulty, "SetShown", function(self) if not ELP_IsNormalState() then self:Hide() end end)
    hooksecurefunc(EncounterJournal.encounter.info.difficulty, "Show", function(self) if not ELP_IsNormalState() then self:Hide() end end)

    ELP_Replace("EJ_ResetLootFilter", EJ_ResetLootFilter_ELP)
    ELP_Replace("EJ_GetEncounterInfoByIndex", EJ_GetEncounterInfoByIndex_ELP) --副本拆成2个大秘时控制boss显示

    EncounterJournal:HookScript("OnShow", function()
        local mapID = C_ChallengeMode.GetActiveChallengeMapID()
        local filterIndex = mapID and ELP_CHALLENGE_MAPID_FILTER_INDEX[mapID]
        if filterIndex then
            ELP_MenuOnClick(nil, "range", filterIndex)
        end
    end)
end
