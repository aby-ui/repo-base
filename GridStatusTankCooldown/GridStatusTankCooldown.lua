local LL = {} local function L(key) return LL[key] or key end
if GetLocale():find'^zh' then
    LL["Tanking cooldowns"] = "坦克救命技能"
    LL["Show text as"] = "文字指示器显示内容："
    LL["Text to show when assigned to an indicator capable of displaying text"] = "如果指示器支持文字显示，则会显示所选的文字。"
    LL["Caster name"] = "施法者名字"
    LL["Spell name"] = "技能名称"
    LL["Check the spells that you want GridStatusTankCooldown to keep track of. Their position on the list defines their priority in the case that a unit has more than one of them."] = "选择要提示的坦克救命技能，如果开启的救命技能多于一个，则排在前面的会优先显示。"
    LL["Options"] = "选项"
    LL["Spells"] = "选择要提示的技能"
    LL["Tanking cooldowns secondary"] = "坦克救命技能(次级)"
    LL["Those not chosen in alert_tankcd and have cooldown more than 1 minutes, will be shown here."] = "部分没有在坦克救命技能里选择的、但仍然比较重要的状态，会在这里集中显示，如果需要关注，请启用并指定一个关联的指示器"
end
------------------------------------------------------------------------------
-- GridStatusTankCooldown by Slaren, modified at 7.0 by warbaby
------------------------------------------------------------------------------
GridStatusTankCooldown = Grid:GetModule("GridStatus"):NewModule("GridStatusTankCooldown")
GridStatusTankCooldown.menuName = L"Tanking cooldowns"

local debuffs = {
        [124273]    = true, --重度醉拳 debuff
        [124274]    = true, --中度醉拳 debuff
        [25771]     = true, --自律 debuff
        [187464]    = true, -- 暗影愈合 debuff 6s
        [219521]    = true, -- 暗影盟约 debuff 6s
}
local interest_buffs = { -- 1表示本职业自身 2表示可以给其他职业 负数表示不显示在次要状态中
    ["DEATHKNIGHT"] = {
        [48707]     = 1, -- [反魔法护罩] 1min 5s
        [81256]     = 1, -- [符文刃舞] 3min 8s
        [195181]    = -1, -- [白骨之盾] 30s 层数
        [206977]    = 1, -- [血之镜像] 2min 10s
        [194679]    = -1, --  [符文分流] 25秒冲能 3秒
        [116888]    = 1, -- 炼狱蔽体 114556 炼狱效果 3min 3s
        [48792]     = 1, -- [冰封之韧] 3min DPS
        [55233]     = 1, -- [吸血鬼之血] 1.5min
        [207319]    = 1, -- [血肉之盾] 1min 10s
        [219809]    = 1, -- 墓石 吸收伤害
        [205725]    = 1, -- 反魔法盾天赋 - 最大生命提高
    },
    ["DRUID"] = {
        [22812]     = 1, -- 树皮术 1min 12s
        [77764]     = -2, -- 奔窜咆哮 [狂奔怒吼] 2min 8s
        [102342]    = 2, -- 铁树皮术 铁木树皮 1.5min 12s
        [192083]    = 1, -- 厄索印记 [乌索尔的印记] 45怒气 6s 30%魔法伤害
        [192081]    = 1, -- 钢铁毛皮 [铁鬃] 45怒气 护甲提高
        --[203975]    = -1, -- 大地看守者  [大地守卫者] 3层被动
        [61336]     = 1, -- 求生本能 [生存本能] 3min 6s -50%伤害 冲能2次
        [29166]     = 2, -- 启动 [激活] 3min 10s
        [117679]    = 1, -- 生命之树 化身 3min 30s 33891 治疗大招
        [102558]    = 1, -- 厄索克守护者 [化身：乌索克的守护者] 嘲讽1.5s
    },
    ["HUNTER"] = {
        [186265] = 1, -- 巨龜守護 灵龟守护 3min 8s
    },
    ["MAGE"] = {
        [45438]  = 1, -- 寒冰屏障
        [11426]  = -1, -- 寒冰护体 25s
        [113862] = 1, -- 强效隐形
    },
    ["MONK"] = {
        --[152173] = 1, -- 冰心诀 [屏气凝神] 1.5min 8s DPS大招
        [122278] = 1, -- 卸劲诀 [躯不坏] 2min 3次攻击
        [122783] = 1, -- 驱魔诀 [散魔功] 2min 6s -60%魔法
        [125174] = 1, -- 乾坤挪移 [业报之触] 10s 1.5min 122470 DPS大招
        [120954] = 1, -- 石形绝酿 [壮胆酒] 7min 15s 115203
        [116849] = 2, -- 气茧护体 [作茧缚命] 3min 12s
        [124273] = 1, --重度醉拳 debuff
        [124274] = 1, --中度醉拳 debuff
        [115176] = 1, --禅悟冥想 --受到的所有伤害降低60%，持续8秒。移动，受到近战攻击或进行其他动作会取消该效果。
        --[215479] = 1, -- 金钟绝酿 [铁骨酒] 115308 21cd 3charge 6s 使醉拳化解的伤害量额外提高40%，持续6秒。
    },
    ["PALADIN"] = {
        [205191]    = -1, -- 以眼还眼 1min 反击
        [1022]      = 2, -- 保护祝福 5min 10s
        [498]       = 1, -- 圣佑术 1min 8s
        [642]       = 1, -- 圣盾术 5min 8s
        [86659]     = 1, -- 远古诸王守护者 5min 8s
        [31884]     = 1, -- 复仇之怒 2min 20 治疗大招
        [184662]    = 1, -- 复仇圣盾 2min 15s
        [1044]      = 2, -- 自由祝福  25s 8s
        --[132403]  = 1, -- 公正之盾  [正义盾击] 16s冲能 3次
        [31850]     = 1, -- 忠诚防卫者  [炽热防御者] 2min 8s
        [204150]    = 1, -- 圣光御盾 群体-20% 6s 骑士自己的
        [204335]    = 2, -- 圣光御盾 群体-20% 6s 队友的没时间
        [204018]    = 2, -- 抗咒祝福 3min 魔法免疫
        [6940]      = 2, -- 牺牲祝福 2.5min 给自己加
        [105809]    = -1, -- 神圣复仇者 1.5min 治疗中招
        [31842]     = 1, -- 复仇之怒 2min治疗大招
        [31821]     = 1, -- 精通光环 3min只有自己显示
        [25771]    = -2, --自律 debuff
    },
    ["PRIEST"] = {
        [47585]     = 1, -- 影散 消散 2min 6s -60% DPS
        [47788]     = 2, -- 守护圣灵 4min
        [33206]     = 2, -- 痛苦镇压 4min
        [81782]     = 2, -- 罩子  [真言术：障] 62618 3min 12s BUFF没有时间
        [15286]     = -1, -- 吸血鬼 3min 15s 治疗他人
        [10060]     = 1, -- 注入能量 [能量灌注] 3min 12s 治疗大招
        [47536]     = 1, -- 狂喜 [全神贯注] 2min 8s 盾无CD 治疗大招
        [64843]     = 1, -- 神圣礼颂 [神圣赞美诗] 3min 7.2s
        [64901]     = 1, -- 希望象征 [希望象征] 6min 治疗大招
        [200183]    = 1, -- 神化 神圣化神 3min 30s 治疗大招
        --[187464]    = 2, -- 暗影愈合 debuff 6s
        --[219521]    = 2, -- 暗影盟约 debuff 6s
    },
    ["ROGUE"] = {
        [31224]     = 1, -- 暗影披风 [暗影斗篷] 1.5min 5s
        [5277]      = 1, -- 闪避 2min 10s
        [1966]      = -1, -- 佯攻 范围伤害-50% 20能量 5s
        [185311]    = -1, -- 赤红药瓶 [猩红之瓶] 30s 6s 30%生命值
        [199754]    = 1, -- 还击 2min 招架提高100%
        [45182]     = 1, -- 死亡谎言 装死 2min 3s
    },
    ["SHAMAN"] = {
        [108271]    = 1, -- 星界转移1.5min
        [108281]    = 1, -- 先祖引导 先祖指引 2min 10s 20%伤害和治疗，治疗附近3名
        [98007]     = -2, -- 灵魂连接 buff
        [98008]     = -2, -- 灵魂连接 [灵魂链接图腾] 3min 6s
        [114052]    = 1, -- 卓越术 升腾 3min 大招 群疗
    },
    ["WARLOCK"] = {
        [108416]    = -1, -- 黑暗契约 1min 20s
        [104773]    = 1, -- 心志坚定 [不灭决心] 3min 8s
    },
    ["WARRIOR"] = {
        [118038]    =  1, -- 剑下亡魂 [剑在人在] 3min 8s
        [12975]     = 1, -- 破釜沉舟 3min 15s
        [97463]     = -2, -- 命令之吼 [命令怒吼] 3min 10s 97462
        [223658]    = 1, -- 安全守护 [捍卫] 拦截 20s 6s 198304
        [190456]    = 1, -- 无视苦痛 根据怒气
        [132404]    = -1, -- 盾牌格挡 6s 13s冲能 145054
        [125565]    = 1, -- 挫志怒吼 1.5min 8s 1160
        [871]       = 1, -- 盾墙 4min 8s
        [23920]     = 1, -- 法术反射 25s 5s
        --[197690]  = 1, -- 防御姿态 一直持续 没找到
        [184364]    = 1, -- 狂怒恢复 2min 8s DPS
    },
    ["DEMONHUNTER"] = {
        [187827]    = 1, -- 恶魔化身 [恶魔变形] 3min 15s
        [191427]    = 1, -- 恶魔化身 [恶魔变形] 浩劫 5min 30s
        [203819]    = -1, -- 恶魔尖刺 [恶魔尖刺] 203720 15s冲能 6s
        --[218256]  = 1, -- 强化结界 20s 6s
        [212800]    = -1, -- 残影 疾影 1min
        [209426]    = 1, -- 黑暗 196718 3min ???
        [207810]    = 2, -- 虚空链接
    }
}
local flags = {}
local class_of_spell = {}

local tankingbuffs = {}
for clz, tbl in pairs(interest_buffs) do
    tankingbuffs[clz] = {}
    for id, flag in pairs(tbl) do
        tinsert(tankingbuffs[clz], id)
        flags[id] = flag
        class_of_spell[id] = clz
    end
end
wipe(interest_buffs) interest_buffs = nil

GridStatusTankCooldown.tankingbuffs = tankingbuffs

-- locals
local GridRoster = Grid:GetModule("GridRoster")
local GetSpellInfo = GetSpellInfo
local UnitAura = UnitAura
local UnitGUID = UnitGUID

local spellnames = {}

GridStatusTankCooldown.defaultDB = {
	debug = false,
	alert_tankcd = {
		enable = true,
		color = { r = 1, g = 1, b = 0, a = 1 },
		priority = 99,
		range = false,
		showtextas = "spell",
        showlatest = false,
		active_spellids = { -- default spells --会受到伤害的最前面，加治疗效果的次之，减伤再次，最次是加生命的
            116888, -- 炼狱蔽体
            47788,	-- 守护之魂
            116849, -- 作茧缚命
            98008,  -- 灵魂链接图腾
            33206,	-- 痛苦压制
            1022,   -- 保护祝福 5min 10s
            204018, -- 破咒祝福
            871,	-- 盾墙
            223658, -- 捍卫
            12975,  -- 破釜沉舟
            6940, 	-- 牺牲祝福
            642,    -- 圣盾术
            31850,	-- 忠诚防卫者
            86659,	-- 远古列王
            61336,	-- 生存本能
            102558, -- [化身：乌索克的守护者] 1.5s嘲讽
            120954, -- 壮胆酒 or 115203
            115176, -- 禅悟冥想
            122783, -- 散魔功
            187827, -- 恶魔变形+30%生命
            55233,  -- 吸血鬼之血+%生命+治疗量
            81256,  -- 符文刃舞 40%招架
            205725, -- 反魔法盾天赋+25%生命
            124273, -- 重度醉拳
            select(2, UnitClass("player")) == "PALADIN" and 25771 or nil, -- 自律
            --81782,-- 真言术：障，性价比不行
            --48792,-- 冰封之韧 DPS的
		},
		inactive_spellids = { -- used to remember priority of disabled spells
		}
    },
    alert_tankcd_secondary = {
        enable = false,
        color = { r = 0, g = 1, b = 1, a = 1 },
        priority = 98,
        range = false,
        showtextas = "spell",
    },
}

local active_by_class = { OTHER = {} } for i=1, GetNumClasses() do active_by_class[select(2, GetClassInfo(i))] = {} end
local active_by_class_2nd = { OTHER = {} } for i=1, GetNumClasses() do active_by_class_2nd[select(2, GetClassInfo(i))] = {} end
GridStatusTankCooldown.active_by_class_2nd = active_by_class_2nd
GridStatusTankCooldown.active_by_class = active_by_class
local active_spells_map = {}
function GridStatusTankCooldown:OnSpellListChanged()
    for k, v in pairs(active_by_class) do wipe(v) end
    wipe(active_spells_map)
    for order, id in ipairs(self.db.profile.alert_tankcd.active_spellids) do
        active_spells_map[id] = true
        if flags[id] == 2 or flags[id] == -2 then
            for k, v in pairs(active_by_class) do v[id] = order end
        else
            active_by_class[class_of_spell[id]][id] = order
        end
    end
    -- 次级重要的没有优先级
    for k, v in pairs(active_by_class_2nd) do wipe(v) end
    for id, flag in pairs(flags) do
        if flag > 0 and not active_spells_map[id] then
            if flags[id] == 2 or flags[id] == -2 then
                for k, v in pairs(active_by_class_2nd) do v[id] = true end
            else
                active_by_class_2nd[class_of_spell[id]][id] = true
            end
        end
    end
end

local myoptions = {
	["gstcd_header_1"] = {
		type = "header",
		order = 200,
		name = L"Options",
	},
	["showtextas"] = {
		order = 201,
		type = "select",
		name = L"Show text as",
		desc = L"Text to show when assigned to an indicator capable of displaying text",
		values = { ["caster"] = L"Caster name", ["spell"] = L"Spell name" },
		style = "radio",
		get = function() return GridStatusTankCooldown.db.profile.alert_tankcd.showtextas end,
		set = function(_, v) GridStatusTankCooldown.db.profile.alert_tankcd.showtextas = v end,
	},
    ["showlatest"] = {
        order = 202,
        type = "toggle",
        name = L"显示最后释放的技能",
        width = "full",
        desc = L"始终显示最后释放的技能，而不是按照优先级顺序显示。",
        get = function() return GridStatusTankCooldown.db.profile.alert_tankcd.showlatest end,
        set = function(_, v) GridStatusTankCooldown.db.profile.alert_tankcd.showlatest = v end,
    },
	["gstcd_header_2"] = {
		type = "header",
		order = 203,
		name = L"Spells",
	},
	["spells_description"] = {
		type = "description",
		order = 204,
		name = L"Check the spells that you want GridStatusTankCooldown to keep track of. Their position on the list defines their priority in the case that a unit has more than one of them.",
	},
	["spells"] = {
		type = "input",
		order = 205,
		name = "Spells",
		control = "GSTCD-SpellsConfig",
	},
}

local myoptions_2nd = {
    ["desc"] = {
        order = 200,
        type = "description",
        name = L"Those not chosen in alert_tankcd and have cooldown more than 1 minutes, will be shown here.",
    },
    ["showtextas"] = {
        order = 201,
        type = "select",
        name = L"Show text as",
        desc = L"Text to show when assigned to an indicator capable of displaying text",
        values = { ["caster"] = L"Caster name", ["spell"] = L"Spell name" },
        style = "radio",
        get = function() return GridStatusTankCooldown.db.profile.alert_tankcd_secondary.showtextas end,
        set = function(_, v) GridStatusTankCooldown.db.profile.alert_tankcd_secondary.showtextas = v end,
    },
}

function GridStatusTankCooldown:OnInitialize()
	self.super.OnInitialize(self)
	
	for class, buffs in pairs(tankingbuffs) do
		for _, spellid in pairs(buffs) do
			local sname = GetSpellInfo(spellid)
			spellnames[spellid] = sname
		end
	end
	
	self:RegisterStatus("alert_tankcd", L"Tanking cooldowns", myoptions, true)
    self:RegisterStatus("alert_tankcd_secondary", L"Tanking cooldowns secondary", myoptions_2nd, true)

	local settings = self.db.profile.alert_tankcd

	-- delete old format settings
	if settings.spellids then
		settings.spellids = nil
	end
	
	-- remove old spellids
	for p, aspellid in ipairs(settings.active_spellids) do
		local found = false
		for class, buffs in pairs(tankingbuffs) do
			for _, spellid in pairs(buffs) do
				if spellid == aspellid then
					found = true
					break
				end				
			end
		end
		
		if not found then
			table.remove(settings.active_spellids, p)
		end
		
		-- remove duplicates
		for i = #settings.active_spellids, p + 1, -1 do
			if settings.active_spellids[i] == aspellid then
				table.remove(settings.active_spellids, i)
			end
		end
    end

    GridStatusTankCooldown:OnSpellListChanged()
end

function GridStatusTankCooldown:OnStatusEnable(status)
	if status == "alert_tankcd" or status == "alert_tankcd_secondary" then
		self:RegisterEvent("UNIT_AURA", "ScanUnit")
		self:RegisterMessage("Grid_UnitJoined")
		self:UpdateAllUnits()
	end
end

function GridStatusTankCooldown:OnStatusDisable(status)
    if status == "alert_tankcd" or status == "alert_tankcd_secondary" then
        if status == "alert_tankcd" then
            self.core:SendStatusLostAllUnits("alert_tankcd")
        elseif status == "alert_tankcd_secondary" then
            self.core:SendStatusLostAllUnits("alert_tankcd_secondary")
        end
        if not self.db.profile.alert_tankcd.enable and not self.db.profile.alert_tankcd_secondary.enable then
            self:UnregisterEvent("UNIT_AURA")
            self:UnregisterEvent("Grid_UnitJoined")
        end
    end
end

function GridStatusTankCooldown:Grid_UnitJoined(guid, unitid)
	self:ScanUnit("Grid_UnitJoined", unitid, guid)
end

function GridStatusTankCooldown:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:ScanUnit("UpdateAllUnits", unitid, guid)
	end
end

function GridStatusTankCooldown:ScanSpells(active_spells, status_name, active_spells2, status_name2, unitid, unitguid)
    local settings1 = self.db.profile[status_name]
    local settings2 = self.db.profile[status_name2]
    if not settings1.enable and not settings2.enable then return end

    local l_starttime, l_text, l_icon, l_count, l_duration, order;
    local l_starttime2, l_text2, l_icon2, l_count2, l_duration2;
    local enable1, enable2 = settings1.enable, settings2.enable

    -- Buff和Debuff必须循环两次
    for i=1, 40 do
        local name, icon, count, _, duration, expirationTime, caster, _, _, spellId = UnitAura(unitid, i)
        if not name then break end

        local spell_order = active_spells[spellId]
        local active = settings1.enable and spell_order and 1 or settings2.enable and active_spells2[spellId] and 2
        if active then
            local settings = active == 1 and settings1 or settings2
            local text = settings.showtextas == "caster" and (caster and UnitName(caster) or '') or name
            local starttime = expirationTime - duration
            if active == 1 then
                -- 如果显示最后释放，则比较时间，否则比较次序
                if settings.showlatest and (not l_starttime or l_starttime < starttime)
                        or (not order or order > spell_order) then
                    l_starttime, l_text, l_icon, l_count, l_duration = starttime, text, icon, count, duration
                    order = spell_order
                end
            else
                --次级技能没有次序，只能按时间比较
                if not l_starttime2 or l_starttime2 < starttime then
                    l_starttime2, l_text2, l_icon2, l_count2, l_duration2 = starttime, text, icon, count, duration
                end
            end
        end
    end

    -- 本来是可以根据有没有debuff来循环，但考虑到自律技能，所以都要循环
    -- 这段代码除了加了一个'HARMFUL'其他一模一样
    for i=1, 40 do
        local name, icon, count, _, duration, expirationTime, caster, _, _, spellId = UnitAura(unitid, i, 'HARMFUL')
        if not name then break end

        local spell_order = active_spells[spellId]
        local active = settings1.enable and spell_order and 1 or settings2.enable and active_spells2[spellId] and 2
        if active then
            local settings = active == 1 and settings1 or settings2
            local text = settings.showtextas == "caster" and (caster and UnitName(caster) or '') or name
            local starttime = expirationTime - duration
            if active == 1 then
                -- 如果显示最后释放，则比较时间，否则比较次序
                if settings.showlatest and (not l_starttime or l_starttime < starttime)
                        or (not order or order > spell_order) then
                    l_starttime, l_text, l_icon, l_count, l_duration = starttime, text, icon, count, duration
                    order = spell_order
                end
            else
                --次级技能没有次序，只能按时间比较
                if not l_starttime2 or l_starttime2 < starttime then
                    l_starttime2, l_text2, l_icon2, l_count2, l_duration2 = starttime, text, icon, count, duration
                end
            end
        end
    end

    if l_starttime then
        self.core:SendStatusGained(unitguid, status_name, settings1.priority, (settings1.range and 40), settings1.color,
            l_text,
            0,							-- value
            nil,						-- maxValue
            l_icon,						-- icon
            l_starttime,	            -- start
            l_duration,					-- duration
            l_count)					-- stack
    else
        self.core:SendStatusLost(unitguid, status_name)
    end

    if l_starttime2 then
        self.core:SendStatusGained(unitguid, status_name2, settings2.priority, (settings2.range and 40), settings2.color,
            l_text2,
            0,							-- value
            nil,						-- maxValue
            l_icon2,					-- icon
            l_starttime2,	            -- start
            l_duration2,				-- duration
            l_count2)					-- stack
    else
        self.core:SendStatusLost(unitguid, status_name2)
    end
end

function GridStatusTankCooldown:ScanUnit(event, unitid, unitguid)
	unitguid = unitguid or UnitGUID(unitid)
	if not GridRoster:IsGUIDInRaid(unitguid) then
		return
    end
    local _, clz = UnitClass(unitid)
    GridStatusTankCooldown:ScanSpells(active_by_class[clz] or active_by_class.OTHER, "alert_tankcd", active_by_class_2nd[clz] or active_by_class_2nd.OTHER, "alert_tankcd_secondary", unitid, unitguid)
end
