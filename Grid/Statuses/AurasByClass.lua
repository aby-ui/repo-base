local _, Grid = ...
local L = Grid.L

local spell_classes = {
    ["DRUID"] = {
        (33763), --生命绽放 Lifebloom
        (8936), --愈合 Regrowth
        (774), --回春术 Rejuvenation
        (48438), --野性成长 Wild Growth

        102342, --铁木树皮
        102351, --塞纳里奥结界
        48504, --生命之种
    },
    ["MONK"] = {
        (124682), --氤氲之雾 "Enveloping Mist"
        (116849), --作茧缚命 "Life Cocoon"
        (115151), --复苏之雾 119611? 反正用名字 "Renewing Mist"

        116841, --迅如猛虎
        --185158, --T18效果
    },
    ["PALADIN"] = {
        (156910), --信仰信标 "Beacon of Faith"
        (53563), --圣光道标 "Beacon of Light"
        (25771), --自律 "Forbearance"
        [25771] = true, --debuff

        223306,  --赋予信仰
        200025,  --美德道标
        1022,    --保护祝福
        204150,  --圣光护盾
        204018,  --破咒祝福
        1044,    --自由祝福
        203528,	 --强效力量祝福
        203538,	 --强效王者祝福
        203539,	 --强效智慧祝福
        200654,  --提尔的拯救
        --200423,  --奶骑大特质 圣光救赎 血50%以下再受伤害
    },
    ["PRIEST"] = {
        (214206), --苦修 "Atonement" new in 7.0, +healing mod, alternate spellid 214206
        (152118), -- 意志洞悉 "Clarity of Will" new in 7.0, shield
        (17), --真言术盾 "Power Word: Shield"
        (33076), --愈合祷言 "Prayer of Mending"
        (139), --恢复 "Renew"

        214121, --身心合一
        219521, --暗影盟约debuff
        [219521] = true,
        187464, --暗影愈合 debuff
        [187464] = true,
    },
    ["SHAMAN"] = {
        (61295), --激流 "Riptide"
    }
}

local spell_names = {}
local spell_name_classes = {}
for clz, tbl in pairs(spell_classes) do
    for _, id in ipairs(tbl) do
        local name = GetSpellInfo(id)
        if name then
            spell_names[id] = name
            if tbl[id] ~= true then
                --ignore debuff
                spell_name_classes[name] = clz
            end
        end
    end
end

local GridStatusAuras = Grid:GetModule("GridStatus"):GetModule("GridStatusAuras")

local default_names = {}
for status, settings in pairs(GridStatusAuras.defaultDB) do
    if type(settings) == "table" and (settings.buff or settings.debuff) then
        default_names[settings.buff or settings.debuff] = true
    end
end

for clz, tbl in pairs(spell_classes) do
    for _, id in ipairs(tbl) do
        local name = spell_names[id]
        if name and not default_names[name] then
            local is_debuff = tbl[id]
            local status_name = (is_debuff and "debuff_" or "buff_")..name
            GridStatusAuras.defaultDB[status_name] = {
                _extra = true,
                enable = false,
                desc = is_debuff and format(L["Debuff: %s"], name) or format(L["Buff: %s"], name),
                buff = not is_debuff and name or nil,
                debuff = is_debuff and name or nil,
                text = GridStatusAuras:TextForSpell(name),
                color = { r = .8, g = .8, b = .2, a = 1 },
                priority = 85,
                mine = not is_debuff and true or nil,
            }
        end
    end
end
wipe(spell_classes) spell_classes = nil
wipe(default_names) default_names = nil
wipe(spell_names) spell_names = nil

GridStatusAuras.defaultDB.show_my_class = true
hooksecurefunc(GridStatusAuras, "PostInitialize", function(self)
    self.options.args["show_my_class"] = {
        order = 1,
        width = "full",
        name = "仅显示本职业相关的光环",
        type = "toggle",
        get = function() return self.db.profile.show_my_class end,
        set = function(info, v)
            self.db.profile.show_my_class = v
            self:Reset()
        end
    }
end)

local _, playerClass = UnitClass("player")

function GridStatusAuras:ShouldRegisterByClass(buff_name)
    local show_my_class = self.db.profile.show_my_class
    if show_my_class and spell_name_classes[buff_name] and spell_name_classes[buff_name] ~= playerClass then
        return false
    else
        return true
    end
end