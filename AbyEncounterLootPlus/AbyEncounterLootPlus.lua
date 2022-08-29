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

        self:SetScript("OnUpdate", ELP_RetrieveNext) --initial Hidden

        CoreDependCall("Blizzard_EncounterJournal", function()
            local btn = WW:Button("ELPSeasonTab", EncounterJournalInstanceSelect, "EncounterTierTabTemplate")
            :SetText("赛季大秘"):kv("id", 5):BOTTOMLEFT(EncounterJournalInstanceSelectLootJournalTab, "BOTTOMRIGHT", 35, 0)
            :SetScript("OnClick", EJ_ContentTab_OnClick_ELP):un()
            btn.Disable = btn.Enable
            CoreUIEnableTooltip(btn, "爱不易提示", "此处为9.2.7方便查询史诗钥石掉落的入口。原来的爱不易装备搜索功能仍在'装备筛选'的下拉菜单中（可以按装备属性搜索全部副本装备），另外按住ALT点此标签也能直接跳转")

            EncounterJournalEncounterFrameInfoLootTab:Click() --初始为掉落面板

            ELP.setupHooks()
            --TODO EncounterJournal_OnShow（）有自动选地图的功能
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
    instanceSelect.scroll:Show();
    EncounterJournal_ListInstances_ELP() --abyui
    EncounterJournal_DisableTierDropDown(true);

    if IsModifierKeyDown() then
        if db.range == 0 then db.range = 1 end
        ELP_MenuOnClick(nil, "range", db.range)
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
        EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:Click()
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
                    ELP_UpdateCurrItem(itemID, insID, info.encounterID, info.link)
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
    if not EncounterJournalEncounterFrameInfoLootScrollFrame:IsVisible() then return end
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
        EJ_SelectInstance(insID)
        --ELP_SetBestDifficulty(insID) --这个是没有用的, 要响应 EJ_DIFFICULTY_UPDATE 才行, 过于复杂, 所以默认都紫装
        ELP_Iterate_Loot(insID, insData.bosses, insData.lootTable)
    end

    EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
    EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE")
    --EncounterJournal.encounter.info.lootScroll.scrollBar:SetValue(0) --意义不明

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
            local prefix = v.type == "dungeon" and "地下城：" or v.type == "raid" and "团本：" or ""
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
    if ELP_IsNormalState() then
        local buttons = EncounterJournal.encounter.info.lootScroll.buttons;
        for _, button in ipairs(buttons) do if button.lootFrame.instance then button.lootFrame.instance:SetText("") end end
        return ELP_RunOrigin("EncounterJournal_LootUpdate")
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
            EncounterJournal_SetLootButton_ELP(button);
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
    if ELP_IsNormalState() then return ELP_RunOrigin("EncounterJournal_SetLootButton", item) end
    local itemID = curr_items[item.index]
    local encounterID = curr_encts[itemID]
    local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice = GetItemInfo(itemID)
    quality = max(4, quality or 0)
    link = curr_links[itemID]
    item.link = link;

    do --9.1.5 dividerFrame
        item.lootFrame:Show();
        item.dividerFrame:Hide();
        item:SetEnabled(true);
    end

    local currentFrame = item.lootFrame;
    if ( name ) then
        currentFrame.name:SetText(ITEM_QUALITY_COLORS[quality].hex .. name .. "|r");
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

        currentFrame.boss:SetFormattedText(BOSS_INFO_STRING, encounterID and EJ_GetEncounterInfo(encounterID) or "未知");
        if encounterID and ELP_ENCOUNTER_INSTANCE_NAME[encounterID] then
            currentFrame.instance:SetText(ELP_ENCOUNTER_INSTANCE_NAME[encounterID]) --一个副本分两个大秘 --/dump EncounterJournal.encounterID
        end

        SetItemButtonQuality(currentFrame, quality, itemID);

        item.link = link;
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
    local old = EncounterJournal.encounter.info.lootScroll.scrollBar:GetValue()
    --最后决定用户在爱不易查询状态下点击boss无效, 没有hook EncounterJournal_DisplayEncounter
    ELP_DisplayInstanceAndEncounterByUS(insID, encounterID)
    EncounterJournal.encounter.info.lootScroll.scrollBar:SetValue(old)

    --scroll boss list to selected encounter
    if encounterID then
        local bs = EncounterJournal.encounter.info.bossesScroll
        for i=1, 20 do
            local bb = _G["EncounterJournalBossButton"..i]
            if not bb then break end
            if bb.encounterID == encounterID then
                local offset = bs:GetTop() - bs.child:GetHeight() - (bb:GetTop() - bb:GetHeight())
                if offset <= 0 then offset = bb:GetTop() - bs:GetTop() end
                if offset > 0 then RunOnNextFrame(function() EncounterJournal.encounter.info.bossesScroll.ScrollBar:SetValue(offset) end) end
                break
            end
        end
    end
end

function EncounterJournal_LootCalcScroll_ELP(offset)
    if ELP_IsNormalState() then return EncounterJournal_LootCalcScroll(offset) end
    local buttonHeight = INSTANCE_LOOT_BUTTON_HEIGHT;
    local index = floor(offset/buttonHeight)
    return index, offset - (index*buttonHeight);
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

    local banner = EncounterJournal.encounter.info.lootScroll.classClearFilter
    if banner:IsShown() then
        local text = banner.text:GetText()
        local old = text:gsub(EJ_CLASS_FILTER:gsub("%%s", "(.+)"), "职业：%1")
        banner.text:SetText(old .. (name == "" and "" or "，") .. append)
    else
        banner.text:SetText(append)
        RunOnNextFrameKey("AbyEncounterLootPlusShowFilter", function() EncounterJournal.encounter.info.lootScroll.classClearFilter:Show() end) --处理self:GetParent():Hide();
        EncounterJournal.encounter.info.lootScroll:SetHeight(360);
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
	local showRaid = not instanceSelect.raidsTab:IsEnabled(); --nouse

	local scrollFrame = instanceSelect.scroll.child;
	local index = 1;
	local instanceID, name, description, _, buttonImage, _, _, _, link, _, mapID = EJ_GetInstanceByIndex(index, showRaid);

	--[[
	--No instances in this tab
	if not instanceID and not infiniteLoopPolice then
		--disable this tab and select the other one.
		infiniteLoopPolice = true;
		if ( showRaid ) then
			instanceSelect.raidsTab.grayBox:Show();
			EJ_ContentTab_Select(instanceSelect.dungeonsTab.id);
		else
			instanceSelect.dungeonsTab.grayBox:Show();
			EJ_ContentTab_Select(instanceSelect.raidsTab.id);
		end
		return;
	end
	infiniteLoopPolice = false;
	--]]

	while instanceID do
		local instanceButton = scrollFrame["instance"..index];
		if not instanceButton then -- create button
			instanceButton = CreateFrame("BUTTON", scrollFrame:GetParent():GetName().."instance"..index, scrollFrame, "EncounterInstanceButtonTemplate");
			if ( EncounterJournal.localizeInstanceButton ) then
				EncounterJournal.localizeInstanceButton(instanceButton);
			end
			scrollFrame["instance"..index] = instanceButton;
			if mod(index-1, EJ_NUM_INSTANCE_PER_ROW) == 0 then
				instanceButton:SetPoint("TOP", scrollFrame["instance"..(index-EJ_NUM_INSTANCE_PER_ROW)], "BOTTOM", 0, -15);
			else
				instanceButton:SetPoint("LEFT", scrollFrame["instance"..(index-1)], "RIGHT", 15, 0);
			end
        end

        --abyui 设置当前状态
        instanceButton.seasonIndex = index
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

		instanceButton.name:SetText(name);
		instanceButton.bgImage:SetTexture(buttonImage);
		instanceButton.instanceID = instanceID;
		instanceButton.tooltipTitle = name;
		instanceButton.tooltipText = description;
		instanceButton.link = link;
		instanceButton.mapID = mapID;
		instanceButton:Show();
		instanceButton.ModifiedInstanceIcon:Hide();

        --[[
		local modifiedInstanceInfo = C_ModifiedInstance.GetModifiedInstanceInfoFromMapID(mapID)
		if (modifiedInstanceInfo) then
			instanceButton.ModifiedInstanceIcon.info = modifiedInstanceInfo;
			instanceButton.ModifiedInstanceIcon.name = name;
			local atlas = instanceButton.ModifiedInstanceIcon:GetIconTextureAtlas();
			instanceButton.ModifiedInstanceIcon.Icon:SetAtlas(atlas, true)
			instanceButton.ModifiedInstanceIcon:SetSize(instanceButton.ModifiedInstanceIcon.Icon:GetSize());
			instanceButton.ModifiedInstanceIcon:Show();
		end
		--]]

		index = index + 1;
		instanceID, name, description, _, buttonImage, _, _, _, link, _, mapID = EJ_GetInstanceByIndex(index, showRaid);
	end

	EJ_HideInstances(index);

    --[[
	--check if the other tab is empty
	local instanceText = EJ_GetInstanceByIndex(1, not showRaid);
	--No instances in the other tab
	if not instanceText then
		--disable the other tab.
		if ( showRaid ) then
			instanceSelect.dungeonsTab.grayBox:Show();
		else
			instanceSelect.raidsTab.grayBox:Show();
		end
	end
	--]]
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
                    local prefix = v.type == "dungeon" and "地下城：" or v.type == "raid" and "团本：" or ""
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
    ELP_Replace("EncounterJournal_OnFilterChanged", EncounterJournal_OnFilterChanged_ELP)
    UIDropDownMenu_Initialize(EncounterJournal.encounter.info.lootScroll.lootFilter, EncounterJournal_InitLootFilter_ELP, "MENU");
    UIDropDownMenu_Initialize(EncounterJournal.encounter.info.lootScroll.lootSlotFilter, EncounterJournal_InitLootSlotFilter_ELP, "MENU");

    ELP_Replace("EncounterJournal_LootUpdate", EncounterJournal_LootUpdate_ELP)
    ELP_Replace("EncounterJournal_SetLootButton", EncounterJournal_SetLootButton_ELP)
    ELP_Replace("EncounterJournal_Loot_OnClick", EncounterJournal_Loot_OnClick_ELP)

    EncounterJournal.encounter.info.lootScroll.update = EncounterJournal_LootUpdate_ELP;
    EncounterJournal.encounter.info.lootScroll.scrollBar.doNotHide = true;
    --EncounterJournal.encounter.info.lootScroll.dynamic = EncounterJournal_LootCalcScroll_ELP;

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
end
