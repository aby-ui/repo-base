--todo: 团队通报
--战斗关闭
--单人通报，设置频道，设置玩家，选择boss和难度，合计，选择次数,
--人员选择，设置频道，职业-天赋 GS，boss选择
--插件状态提示
--初次打开的信息提示
--todo: 缩放可以横向扩大
--todo: 保持排序
--todo: 有时名单有问题, 定时刷新
local _, TeamStats = ...
TeamStats = LibStub("AceTimer-3.0"):Embed(TeamStats);
local L = TeamStats.L
_G["TeamStats"] = TeamStats

local InspectLess = LibStub("LibInspectLess-1.0")

TeamStats.names = {} --保存当前团队名单, true为当前在队伍里的, false为离队的, nil为没关系的

local TABS = TeamStats.TABS
local VBOSSES = TeamStats.VERSION_BOSSES
local CHECK_DELAY = 3 --首次登入游戏时开始检查的延迟, 防止拖慢进游戏的速度
local CHECK_INTERVAL = 1.5 --每次检查之间的间隔时间
local INSPECT_TIMEOUT = 3 --观察天赋的超时时间, 如果一直没有返回会阻断循环
local MAX_KEEP_DAYS = 2
local PLAYER_REALM = GetRealmName()

local function GetPlayerData(name)
    if TeamStats.names[name] ~= nil then
        return TeamStats.db.players[name]
    end
end

local function UnitFullName(unit)
    if not unit then return UNKNOWNOBJECT end
    local name, realm = UnitName(unit)
    if not realm or realm=="" then
        if not PLAYER_REALM or PLAYER_REALM=="" then
            PLAYER_REALM = GetRealmName()
        end
        realm = PLAYER_REALM
    end
    return name.."-"..realm
end

--获取成就或者统计的内容，如果未完成或统计为--则返回0(如果是hash模式应该改为Nil), 成就日期返回的是(year*13+month)*32+day,
--@param id 成就或者统计的ID
--@param isStat 表示是统计而不是成就
--@param isPlayer 为空表示获取对比的成就
local function GetAchieveOrStatById(id, isStat, isPlayer)
    local func
    --6.0以后用id负值表示成就
    if id<0 then isStat = false id = -id end
    if isStat then
        local info = isPlayer and GetStatistic(id) or GetComparisonStatistic(id)
        if not info or info=="--" then
            return 0
        elseif info:find("MoneyFrame") then
            local _, _, gold = info:find("(%d*)/TInterface\\MoneyFrame\\UI%-GoldIcon")
            return gold or 0
        else
            return tonumber(info) or info
        end
    else
        local completed, month, day, year
        if isPlayer then
            _, _, _, completed, month, day, year = GetAchievementInfo(id)
        else
            completed, month, day, year = GetAchievementComparisonInfo(id)
        end
        return completed and floor(time({year=2000+year,month=month,day=day})/86400) or 0
        --return completed and (year*13+month)*32+day or 0
    end
end

local SLOT_NAME = { "头", "项", "肩", "", "胸", "腰", "裤", "鞋", "腕", "手", "戒", "戒", "饰", "饰", "披", "武", "副", "", "", }

--GS因为使用了GetInventoryItem所以必须要有unit
local function SaveGearScore(name, unit, isPlayer)
    local player = GetPlayerData(name)
    if(player) then
        local gem_info, waist_extra_slot = U1GetUnitGemInfo(unit)
        local total_enchant, has_enchant, missing_enchant = U1GetUnitEnchantInfo(unit, waist_extra_slot)
        player.gem_info = gem_info
        --player.total_enchant = total_enchant
        --player.has_enchant = has_enchant
        --player.missing_enchant = missing_enchant

        if(not player.gsGot) then
            local avgLevel, color, pvp, totalLevel, count, slotCount, itemLinks = U1GetInventoryLevel(unit, true)
            --debug("SaveGearScore", U1GetInventoryLevel(unit))
            if avgLevel and avgLevel > 0 then
                player.legends = nil
                for id, link in pairs(itemLinks) do
                    local _, _, quality = GetItemInfo(link)
                    if quality == 5 then
                        if player.legends then
                            player.legends = player.legends.."^"..SLOT_NAME[id].."^"..link
                            break
                        else
                            player.legends = SLOT_NAME[id].."^"..link
                        end
                    end
                end
                player.gs = avgLevel
                player.re = pvp
                player.bad = count~=slotCount --有格子没装备
                player.gsGot = true
                TeamStats:UIUpdate(not isPlayer)
            end
        end
    end
end

local function SaveTalents(name, unit, isPlayer)
    local player = GetPlayerData(name)
    if not player then return end
    local inspecting = not isPlayer;
    if(inspecting)then
        local active = GetInspectSpecialization(unit)
        active = (active and active>0) and select(2, GetSpecializationInfoByID(active));
        player.talent1 = active
    else
        local active = GetActiveSpecGroup()
        active = active and GetSpecialization(false, false, active);
        active = active and select(2, GetSpecializationInfo(active));
        player.talent1 = active
    end
    player.inspected = time()
    TeamStats:UIUpdate()
    TeamStats:SetStatusText("已获得["..(player.name or name or UNKNOWNOBJECT).."]的天赋和GS")
end

local function SaveAchievements(name, unit, isPlayer)
    --只要对比了就可以获取, 不必担心unit失效的问题, 只有GS需要
    local player = TeamStats.db.players[name]
    local list = {}
    for i, id in ipairs(TeamStats.db.map) do
        list[i] = GetAchieveOrStatById(id, true, isPlayer) --TeamStats.stats[id] 目前只支持统计不支持成就
    end
    player.stats = list
    player.compared = time()
    TeamStats:UIUpdate()
    TeamStats:SetStatusText("已获得["..(player.name or name or UNKNOWNOBJECT).."]的成就资料") --TODO: 纳闷，只有一个人然后不停点清除缓存就出这个错
end


function TeamStats:OnInitialize()
    local f = CreateFrame("Frame")
    CoreDispatchEvent(f, TeamStats);

    f:RegisterEvent("VARIABLES_LOADED")
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterEvent("GROUP_ROSTER_UPDATE")
    f:RegisterEvent("UNIT_NAME_UPDATE")
    f:RegisterEvent("UNIT_PORTRAIT_UPDATE")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:RegisterEvent("UNIT_INVENTORY_CHANGED")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    --保存哪些ID是统计的
    --[[会引起加载延迟，只支持统计，或者增加一项配置
    TeamStats.stats = {}
    local cats = GetStatisticsCategoryList()
    for i, cat in ipairs(cats) do
        for j = 1, GetCategoryNumAchievements(cat) do
            TeamStats.stats[GetAchievementInfo(cat, j)] = true
        end
    end
    ]]
end

function TeamStats:DEFAULT_EVENT(event, ...)
    debug(event, ...)
end

function TeamStats:PLAYER_LOGIN()
    self:StartCheckTimer(CHECK_DELAY)
end

function TeamStats:UNIT_INVENTORY_CHANGED(event, unitId)
    local player = TeamStats.db.players[UnitFullName(unitId)]
    if player then
        player.inspected = false
        player.gsGot = false
        self:StartCheckTimer(1)
    end
end

function TeamStats:PLAYER_EQUIPMENT_CHANGED(event, unitId)
    self:UNIT_INVENTORY_CHANGED(event, "player")
end

function TeamStats:PLAYER_SPECIALIZATION_CHANGED(event, unit)
    return TeamStats:UNIT_INVENTORY_CHANGED(event, unit)
end

function TeamStats:GROUP_ROSTER_UPDATE()
    -- 离队再加入时,清空上次队伍信息. --solo初始为nil, 这样/rl后仍能保持最近离队的队员而不会触发新队伍的清理
    if not IsInGroup() then
        TeamStats.solo = true
    else
        if TeamStats.solo then
            TeamStats.solo = nil
            for name, _ in pairs(TeamStats.names) do
                TeamStats.names[name] = nil
            end
        end
    end
    self:StartUpdateNameTimer(0.2)
end

TeamStats.UNIT_NAME_UPDATE = TeamStats.GROUP_ROSTER_UPDATE
TeamStats.UNIT_PORTRAIT_UPDATE = TeamStats.GROUP_ROSTER_UPDATE

function TeamStats:VARIABLES_LOADED()
    TeamStats.db = TeamStatsDB
    if TeamStats.db == nil or not TeamStats.db.VERSION or TeamStats.db.VERSION < 20170301 then
        TeamStats.db = TeamStats:GetDefaultDB()
    end
    TeamStatsDB = TeamStats.db
    TeamStats.db.names = TeamStats.db.names or TeamStats.names
    TeamStats.names = TeamStats.db.names
    setmetatable(TeamStats.db.players, {__index=function(self, key) self[key]={} return self[key] end}) --如果不存在则建立空表

    self:ReMapData()

    --清理过期数据，最多保持2天
    local now = time()
    for k, v in pairs(TeamStats.db.players) do
        if not v.compared or now - v.compared > MAX_KEEP_DAYS*24*60*60 then
            TeamStats.db.players[k] = nil
        end
    end

    self:GROUP_ROSTER_UPDATE()
    --TeamStats:UIShow()
    if TeamStatsUI_CreateMinimapButton then TeamStatsUI_CreateMinimapButton() end
end

function TeamStats:PLAYER_REGEN_DISABLED()
    --不需要，战斗中检查一次则不会继续发起
    TeamStats:SetStatusText(L["StatusPaused"]);
end

function TeamStats:PLAYER_REGEN_ENABLED()
    if TeamStats.queueForNameUpdate then
        TeamStats:StartUpdateNameTimer(CHECK_DELAY) --including StartCheckTimer
        TeamStats.queueForNameUpdate = nil
    else
        TeamStats:StartCheckTimer(CHECK_DELAY)
    end
end


--团员有变化时直接发起请求,随便设置一个时间,可以起到Bucket的作用
--查找有变化的玩家, 同时修改TeamStats.names

--需要判断names在不在列表里
local party_units, raid_units = {"player"}, {}
for i=1, MAX_PARTY_MEMBERS do table.insert(party_units, "party"..i) end
for i=1, MAX_RAID_MEMBERS do table.insert(raid_units, "raid"..i) end
local current_names = {} --当前团队成员名称, 用来跟老的做比较
function TeamStats:OnUpdateNameTimer()
    --print("OnUpdateNameTimer")
    self.updateNameTimer = nil
    local units = IsInRaid() and raid_units or party_units
    for _, unit in ipairs(units) do
        if UnitExists(unit) then
            if UnitName(unit) == UNKNOWNOBJECT or not UnitClass(unit) then
                self:StartUpdateNameTimer(0.2)
                return
            end
            local fullname = UnitFullName(unit)
            local player = TeamStats.db.players[fullname]
            if not player then player={} TeamStats.db.players[fullname]=player end
            player.name = UnitName(unit)
            player.heath = UnitHealthMax(unit)
            player.class = select(2, UnitClass(unit))
            current_names[fullname] = true
        end
    end

    for name, _ in pairs(TeamStats.names) do
        if not current_names[name] then
            TeamStats.names[name] = false
        end
    end

    local now = time()
    for name, _ in pairs(current_names) do
        --新加入团队的, 强制将gs和天赋标记清除, 但成就就不清了
        if not TeamStats.names[name] then
            local player = TeamStats.db.players[name]
            if player.inspected and now - player.inspected > 60*60 then
                player.inspected = false
                player.gsGot = false
            end
        end
        TeamStats.names[name] = true
        current_names[name] = nil
    end

    if(false and DEBUG_MODE) then
        for k,v in pairs(TeamStats.db.players) do
            TeamStats.names[k] = true
        end
    end

    self:StartCheckTimer(0.2)
    TeamStats:UIUpdateNames()
end

function TeamStats:GetDefaultDB()
    local version, build  = GetBuildInfo()
    local db = {
        VERSION = TeamStats.DATA_VERSION, --用来快速比较版本
        minimapPos = 354,
        players = {
            --保存各个玩家的所有成就信息, NAME-REALM
                --stats
                --gs
                --name
                --class
                --talent1
                --talent2
                --inspected 观察时间
                --compared 比较时间
                --gsGot
                --re 韧性
                --bad 是否有未装备的
        }
    }
    return db
end

--当类型页被修改的时候，重建所有数据
--同时设置TeamStats.mirror
function TeamStats:ReMapData()
    local oldMap = TeamStats.db.map
    local mapping = {} --保存成就ID和序号的对应关系
    for _, tab in ipairs(TABS) do
        for _, id in pairs(tab.ids) do
            if type(id) == "table" then
                for _, iid in ipairs(id) do
                    if type(iid) == "table" then
                        for _, iiid in ipairs(iid) do
                            mapping[#mapping+1] = iiid
                        end
                    else
                        mapping[#mapping+1] = iid
                    end
                end
            else
                mapping[#mapping+1] = id
            end
        end
    end
    for i=1, #VBOSSES, 2 do
        mapping[#mapping+1] = VBOSSES[i]
    end

    table.sort(mapping)

    --重建数据
    local rebuild = false
    if oldMap == nil then
        assert(#TeamStats.db.players==0, "Mapping info is missing, this should not happen.")
        table.wipe(TeamStats.db.players)
        rebuild = true
    else
        for i,id in ipairs(oldMap) do
            if mapping[i]~=id then
                rebuild = true
                break
            end
        end
    end

    if rebuild then
        --使用新的映射
        TeamStats.db.map = mapping

        local oldStats = {} --将信息数组转回为hash
        for _, player in pairs(TeamStats.db.players) do
            if player.stats then
                table.wipe(oldStats)
                for i, value in ipairs(player.stats) do
                    if oldMap[i] then oldStats[oldMap[i]] = value end
                end
                for i, id in ipairs(mapping) do
                    local value = oldStats[id]
                    if value == nil then
                        --有新增加的项目
                        player.stats[i] = 0 --保持array
                        player.compared = nil
                    else
                        player.stats[i] = value
                    end
                end
            end
        end
        oldStats = nil
    else
        mapping = nil
    end

    TeamStats.mirror = TeamStats.mirror or {}
    table.wipe(TeamStats.mirror)
    for i=1,#TeamStats.db.map do
        TeamStats.mirror[TeamStats.db.map[i]] = i
    end
end

--检查团队的计时器, 当玩家登入或者队伍成员发生变动时启动
function TeamStats:StartCheckTimer(delay)
    self.checkTimer = self.checkTimer or self:ScheduleTimer("OnCheck", delay)
end
--延迟更新名称
function TeamStats:StartUpdateNameTimer(delay)
    if InCombatLockdown() then
        self.queueForNameUpdate = true;
    else
        self.updateNameTimer = self.updateNameTimer or self:ScheduleTimer("OnUpdateNameTimer", delay)
    end
end

--到时间时的检查
--这两个是缓存字符串
function TeamStats:OnCheck()
    --因为需要在战斗结束后重新startTimer所以必须设置为nil
    self.checkTimer = nil --标记timer不再运行,无法用AceTimer来判断timer是否在运行, 因为它重复利用table

    if InCombatLockdown() then
        TeamStats:PLAYER_REGEN_DISABLED();
        return
    end

    local units = IsInRaid() and raid_units or party_units

    local allDone = true --表示是否需要更新数据, 如果不需要则中止循环了
    local gotOne = false --表示本轮循环是否发起了一次请求
    for i=1, #units do
        local unit = units[i]
        if not UnitExists(unit) then break end

        local name = UnitFullName(unit)
        local curr = TeamStats.db.players[name]
        if UnitIsUnit("player", unit) then
            --玩家自身不需要观察直接获取
            if not curr.inspected then
                gotOne = true;
                SaveTalents(name, unit, true)
                SaveGearScore(name, unit, true)
            end
            
            if not curr.compared then
                gotOne = true;
                SaveAchievements(name, unit, true)
            end

        else
            if not curr.compared then
                allDone = false
                --正在比较的话就不比了
                if self:CanCompare(unit) then
                    gotOne = true;
                    if not self.comparing then
                        self.comparing = name
                        self.comparingUnit = unit
                        RequestProtection:Call("SetAchievementComparisonUnit", unit, self.CompareCallback);
                        --发起请求，不成功就下次再说
                    end
                end
            end

            if not curr.inspected then
                allDone = false
                if InspectLess:IsNotBlocking() and (InspectLess:IsReady() or not InspectLess:GetGUID()) then
                    if self:CanInspect(unit) then
                        gotOne = true;
                        NotifyInspect(unit)
                    end
                end
            end
        end
    end

    if allDone then
        --debug("All done")
        TeamStats:SetStatusText(L["StatusAllDone"]);
    else
        --继续检查
        TeamStats:StartCheckTimer(CHECK_INTERVAL)
        TeamStats:SetStatusText(gotOne and L["StatusGetting"] or L["StatusCannotGet"]);
    end
end

--是否可以比较成就或观察的保护条件, 因为有两处要用到
function TeamStats:CanCompare(unit)
    return (not AchievementFrame or not AchievementFrameComparison:IsVisible()) and UnitIsVisible(unit)
end
function TeamStats:CanInspect(unit)
    return (not InspectFrame or not InspectFrame:IsShown()) and (not Examiner or not Examiner:IsShown()) and UnitIsVisible(unit) and CanInspect(unit)
end

local i = 1
function TeamStats.CompareCallback(success, cause, ...)
    if success then
        SaveAchievements(TeamStats.comparing, TeamStats.comparingUnit, false)
    end
    TeamStats.comparing = false
end

function TeamStats:OnEnable()
end

TeamStats:OnInitialize()

function TeamStats:InspectLess_InspectItemReady(event, unit, guid)
    local name = UnitFullName(unit)
    --debug("InspectItemReady", unit, TeamStats.names[name])
    if TeamStats.names[name] ~= nil then
        SaveGearScore(name, unit, false)
    end
end

--不管是谁发起的观察,只要是当前团队的成员就记录
function TeamStats:InspectLess_InspectReady(event, unit, guid, done)
    --debug(event, unit, guid, unit and UnitFullName(unit) and TeamStats.names[UnitFullName(unit)])
    if unit then
        local name = UnitFullName(unit)
        if TeamStats.names[name] ~= nil then
            SaveTalents(name, unit, false)
        end
    end
end


InspectLess.RegisterCallback(TeamStats, "InspectLess_InspectItemReady")
InspectLess.RegisterCallback(TeamStats, "InspectLess_InspectReady")
