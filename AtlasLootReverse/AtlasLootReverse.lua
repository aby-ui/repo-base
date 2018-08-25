

-- local TT = {}
-- function TT:RegisterTooltip(tip)
--     table.insert(TT, tip);
-- end
-- function TT:AddCallback(func)
--     for _, v in ipairs(TT) do
--         if not v.__u1hooked then
--             CoreRawHook(v, "OnTooltipSetItem", function(self, ...) if self.__u1hookenable then func(self, ...) end end, true)
--         end
--         v.__u1hookenable = 1
--     end
-- end
-- function TT:RemoveCallback(func)
--     for _, v in ipairs(TT) do
--         v.__u1hookenable = nil
--     end
-- end
-- function TT:AddLine(tip, ...) tip:AddLine(...) end

--[[
AtlasLootReverse
Written by pceric
http://www.wowinterface.com/downloads/info9179-Know-It-All.html
]]
local AtlasLootReverse = LibStub("AceAddon-3.0"):NewAddon("AtlasLootReverse") -- , "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("AtlasLootReverse", true)
_G.AtlasLootReverse = AtlasLootReverse

AtlasLootReverse.title = L["AtlasLootReverse"]
AtlasLootReverse.version = GetAddOnMetadata("AtlasLootReverse", "Version")

local db
local tmp

-- searches a table for string s
local function tfind(t, s)
    local last
    for k, v in pairs(t) do
        if type(v) == "table" then
            tfind(v, s)
        else
            if v == s then
                tmp = last
            end
            last = v
        end
    end 
end

----------------------
--On start
function AtlasLootReverse:OnInitialize()
    --AtlasLootReverseDBx 由开发人员生成, 事先存在db.lua里

    if U1DBG then U1DBG.AtlasLootReverseDB = nil U1DBG.AtlasLootReverseDBx = nil end --清理开发人员的存储

    db = AtlasLootReverseDBx or {}
    db.sources = db.sources or {}
    db.whoTable = db.whoTable or {}

    AtlasLootReverseDBx = db

    self.enabled = false

    local OnTooltipSetItem = function(...)
        if(AtlasLootReverse.enabled) then
            return AtlasLootReverse:OnTooltipSetItem(...)
        end
    end

    for _, tip in next, { 'GameTooltip', 'ItemRefTooltip',
        'ShoppingTooltip1', 'ShoppingTooltip2', 'ShoppingTooltip3',
        'AtlasLootTooltipTEMP' } do
        local f = _G[tip]
        if(f) then
            CoreRawHook(f, 'OnTooltipSetItem', OnTooltipSetItem, true)
        end
    end
end

----------------------
--Disabled
function AtlasLootReverse:OnDisable()
    self.enabled = false
end

----------------------
--Loaded
function AtlasLootReverse:OnEnable()
    self.enabled = true
    if(DEBUG_MODE) then
         return self:RebuildDatabase()
    end
end

function AtlasLootReverse:OnTooltipSetItem(tooltip, item)
    item = item or select(2, tooltip:GetItem());
    if type(item)=="string" then
        local _, itemId = strsplit(":", item)
        --TT:AddLine(self, itemId, nil, nil, nil, db.embedded)
        local from = db.whoTable[tonumber(itemId)]
        if from then
            for id in string.gmatch(from, "[^,]+") do
                local v = db.sources[tonumber(id)]
                if not string.find(v, 'Tier ') and not string.find(v, 'Tabards') and not string.find(v, 'PvP ') then
                    v = string.format(L["Drops from %s"], v)
                end
                tooltip:AddLine(v, .7, .7, 1)
            end
        end
    end
end

--- 在atlasloot基础上遍历地下城手册
function AtlasLootReverse:RebuildDatabaseFromEJ(db)
    local db = db or AtlasLootReverseDBx
    U1DBG.AtlasLootReverseDBx = db
    print("正在添加手册物品...")
    local sourceMap = {}
    for i, name in ipairs(db.sources) do sourceMap[name] = i end

    local ELP_CURRENT_TIER = 8
    EJ_SelectTier(ELP_CURRENT_TIER)
    EJ_SetSlotFilter(0)
    EJ_SetLootFilter(0,0)
    for i = 1, 2 do
        local index = 1
        while true do
            local insID, name, _, _, _, _, _, _, link = EJ_GetInstanceByIndex(index, i == 1)
            if not insID then break end
            index = index + 1
            EJ_SelectInstance(insID)
            local instance_name,_,_,_,_,_,_,_,shouldDisplayDifficulty = EJ_GetInstanceInfo(insID)
            local bossNames = {}
            if shouldDisplayDifficulty then
                EJ_SetDifficulty(i==1 and 16 or 23)
            else
                EJ_SetDifficulty(i==1 and 14 or 1)
            end
            local count = 0
            for loot = 1, EJ_GetNumLoot() do
                count = count + 1
                local item_id, encounterID, name, icon, slot, armorType, link = EJ_GetLootInfoByIndex(loot)
                if not bossNames[encounterID] then
                    bossNames[encounterID] = EJ_GetEncounterInfo(encounterID)
                end
                local boss_name = bossNames[encounterID]
                local source = instance_name .. " " .. boss_name
                local source_id = sourceMap[source]
                if not source_id then
                    source_id = #db.sources + 1
                    db.sources[source_id] = source
                    sourceMap[source] = source_id
                end
                --有可能有多个来源, 不考虑了
                db.whoTable[item_id] = source_id
            end
            print(instance_name, count)
        end
    end
    print("添加手册物品完成...")
end

--- 仅开发人员调用, 生成文件暂存在U1DBG里, 完事删掉, 不要用IDEA编辑 DEBUG_MODE = true GetLocale = function() return "zhTW" end
function AtlasLootReverse:RebuildDatabase()
    -- Sanity check for v6 of ALE
    -- assert(ATLASLOOT_VERSION_NUM, "Your AtlasLoot is either too old or broken!")

    -- 没有安装 AtlasLoot
    if(not select(2, GetAddOnInfo'AtlasLoot')) then return end

    local atlas_version = GetAddOnMetadata('AtlasLoot', 'Version')
    local alreverse_version = GetAddOnMetadata('AtlasLootReverse', 'Version')

    db = { sources = {}, whoTable = {} }
    db.alversion = atlas_version
    db.dbversion = alreverse_version
    U1DBG.AtlasLootReverseDBx = db

    do
        local loader = 'AtlasLoot'
        local name, title, notes = GetAddOnInfo(loader)
        local enabled = GetAddOnEnableState(UnitName("player"), loader)>=2

        if(title) then
            if not enabled then
                EnableAddOn(loader)
            end

            if(not IsAddOnLoaded(loader)) and U1LoadAddOn then
                U1LoadAddOn(loader)
            end
        end

        if not enabled then DisableAddOn(loader) end
    end

    local sourceMap = {}

    print("正在初始化物品来源数据库...")
    -- Force AtlasLoot to load all modules
    local modules = "Legion,WarlordsofDraenor,MistsofPandaria,Cataclysm,WrathoftheLichKing,BurningCrusade,Classic,Factions,PvP,WorldEvents,Crafting,Collections"
    for _, module in pairs({strsplit(",", modules)}) do
        LoadAddOn("AtlasLoot_"..module)
    end

    local count = 0
    --7.0 ["AtlasLoot_Legion"]["AssaultOnVioletHold"].items[i](boss)[DIFFCULITY] = { {1, id} }
    for module_name,module in pairs(AtlasLoot.ItemDB.Storage) do
        for k, v in pairs(module) do
            if not k:find("^__") and type(v) == "table" then
                if module_name == "AtlasLoot_PvP" then print(k) end
                local instance_name, instance_type = v:GetName(), module:GetContentTypes()[v.ContentType][1]
                for i, boss in ipairs(v.items) do
                    local boss_name = v:GetNameForItemTable(i)
                    for diff, list in pairs(boss_name and boss or _empty_table) do
                        if type(list) == "table" then
                            local diff_name = module:GetDifficultyName(diff)
                            for _, item in ipairs(list) do

                                local item_id = item[2]
                                --还有一些特殊情况, 不考虑了
                                --if not item_id then print(source, module_name, k, i, boss.EncounterJournalID) end
                                if item_id and type(item_id) == "number" then
                                    local source = instance_name .. " " .. boss_name
                                    local source_id = sourceMap[source]
                                    if not source_id then
                                        source_id = #db.sources + 1
                                        db.sources[source_id] = source
                                        sourceMap[source] = source_id
                                    end
                                    --有可能有多个来源, 不考虑了
                                    if not db.whoTable[item_id] then
                                        count = count + 1
                                        db.whoTable[item_id] = source_id
                                    end
                                    if item_id == 102635 then
                                        print(item_id, source, source_id)
                                    end
                                end

                            end
                        end
                    end
                end
            end
        end
    end

    print(db.whoTable[102635])

    sourceMap = nil
    print(AtlasLootReverse.title .. " 数据库已重建. 总数", count)

    AtlasLootReverse:RebuildDatabaseFromEJ(db)
    collectgarbage("collect")
end
