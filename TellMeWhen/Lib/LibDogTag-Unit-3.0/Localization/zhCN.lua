local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

if GetLocale() == "zhCN" then

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)
	local L = DogTag_Unit.L
	
	-- races
	L["Blood Elf"] = "血精灵"
	L["Draenei"] = "德莱尼"
	L["Dwarf"] = "矮人"
	L["Gnome"] = "侏儒"
	L["Human"] = "人类"
	L["Night Elf"] = "暗夜精灵"
	L["Orc"] = "兽人"
	L["Tauren"] = "牛头人"
	L["Troll"] = "巨魔"
	L["Undead"] = "亡灵"

	-- short races
	L["Blood Elf_short"] = "血"
	L["Draenei_short"] = "德"
	L["Dwarf_short"] = "矮"
	L["Gnome_short"] = "侏"
	L["Human_short"] = "人"
	L["Night Elf_short"] = "暗"
	L["Orc_short"] = "兽"
	L["Tauren_short"] = "牛"
	L["Troll_short"] = "巨"
	L["Undead_short"] = "亡"

	-- classes
	L["Warrior"] = "战士"
	L["Priest"] = "牧师"
	L["Mage"] = "法师"
	L["Shaman"] = "萨满祭司"
	L["Paladin"] = "圣骑士"
	L["Warlock"] = "术士"
	L["Druid"] = "德鲁伊"
	L["Rogue"] = "潜行者"
	L["Hunter"] = "猎人"

	-- short classes
	L["Warrior_short"] = "战"
	L["Priest_short"] = "牧"
	L["Mage_short"] = "法"
	L["Shaman_short"] = "萨"
	L["Paladin_short"] = "圣"
	L["Warlock_short"] = "术"
	L["Druid_short"] = "德"
	L["Rogue_short"] = "贼"
	L["Hunter_short"] = "猎"

	-- Some strings below are set to GlobalStrings in enUS.lua and no need to be localized, commented out
	-- 下面部分字串已经在enUS.lua里面使用了GlobalStrings，不需要翻译，注释掉
	--L["Player"] = PLAYER
	--L["Target"] = TARGET
	--L["Focus-target"] = FOCUS
	L["Mouse-over"] = "鼠标目标"
	L["%s's pet"] = "%s的宠物"
	L["%s's target"] = "%s的目标"
	L["%s's %s"] = "%1$s's %2$s"
	L["Party member #%d"] = "队伍成员#%d"
	L["Raid member #%d"] = "团队成员#%d"
	L["Boss #%d"] = "Boss #%d"
	L["Arena enemy #%d"] = "Arena enemy #%d"

	-- classifications
	L["Rare"] = "稀有"
	L["Rare-Elite"] = "稀有" and ELITE and "稀有" .. "-" .. ELITE
	--L["Elite"] = ELITE
	--L["Boss"] = BOSS
	-- short classifications
	L["Rare_short"] = "稀"
	L["Rare-Elite_short"] = "稀+"
	L["Elite_short"] = "+"
	L["Boss_short"] = "首"

	L["Feigned Death"] = "假死"
	L["Stealthed"] = "潜行"
	L["Soulstoned"] = "灵魂已保存"

	--L["Dead"] = DEAD
	L["Ghost"] = "鬼魂"
	--L["Offline"] = PLAYER_OFFLINE
	L["Online"] = "在线"
	L["Combat"] = "战斗"
	L["Resting"] = "休息"
	L["Tapped"] = "已被攻击"
	L["AFK"] = "暂离"
	L["DND"] = "勿扰"

	--L["Rage"] = RAGE
	--L["Focus"] = FOCUS
	--L["Energy"] = ENERGY
	--L["Mana"] = MANA

	--L["PvP"] = PVP
	L["FFA"] = "自由PK"

	-- genders
	--L["Male"] = MALE
	--L["Female"] = FEMALE

	-- forms
	L["Bear"] = "熊"
	L["Cat"] = "猎豹"
	L["Moonkin"] = "枭兽"
	L["Aquatic"] = "水栖"
	L["Flight"] = "飞行"
	L["Travel"] = "旅行"
	L["Tree"] = "树"

	L["Bear_short"] = "熊"
	L["Cat_short"] = "豹"
	L["Moonkin_short"] = "枭"
	L["Aquatic_short"] = "水"
	L["Flight_short"] = "飞"
	L["Travel_short"] = "旅"
	L["Tree_short"] = "树"

	-- shortgenders
	L["Male_short"] = "男"
	L["Female_short"] = "女"

	L["Leader"] = "队长"
	
	-- dispel types
	L["Magic"] = "魔法"
	L["Curse"] = "诅咒"
	L["Poison"] = "中毒"
	L["Disease"] = "疾病"
	
	L["True"] = "True"
	
	-- Categories
	L["Abbreviations"] = "缩写"
	L["Auras"] = "法术效果"
	L["Casting"] = "施法"
	-- Spell names
	L["Holy Light"] = "圣光术"
	-- Docs
	-- Auras
	L["Return True if unit has the aura argument"] = "如果单位身上有参数指定的法术效果，则返回True"
	L["Return the number of auras on the unit"] = "返回参数指定的法术效果在单位身上所存在的数量"
	L["Return the shapeshift form the unit is in if unit is a druid"] = "假如单位是德鲁伊，则返回其变形形态的名称"
	L["Return a shortened druid form of unit, or shorten a druid form"] = "返回单位的德鲁伊形态缩写，或者缩写一个德鲁伊形态"
	L["Return the total number of debuffs that unit has"] = "返回单位身上的Debuff数量"
	L["Return the duration until the aura for unit is finished"] = "返回参数指定的法术效果在失效前还有多少时间"
	L["Return True if the unit has the shadowform buff"] = "如果目标拥有暗影形态Buff则返回True"
	L["Return True if the unit is stealthed in some way"] = "如果目标以某种形式潜行则返回True"
	L["Return True if the unit has the Shield Wall buff"] = "如果目标拥有盾墙Buff则返回True"
	L["Return True if the unit has the Last Stand buff"] = "如果目标拥有破釜沉舟Buff则返回True"
	L["Return True if the unit has the Soulstone buff"] = "如果目标拥有灵魂石复活Buff则返回True"
	L["Return True if the unit has the Misdirection buff"] = "如果目标拥有误导Buff则返回True"
	L["Return True if the unit has the Ice Block buff"] = "如果目标拥有寒冰屏障Buff则返回True"
	L["Return True if the unit has the Invisibility buff"] = "如果目标拥有隐形术Buff则返回True"
	L["Return True if the unit has the Divine Intervention buff"] = "如果目标拥有神圣干涉Buff则返回True"
	L["Return True if friendly unit is has a debuff of type"] = "如果友好目标身上有指定系别的Debuff则返回True"
	L["Return True if the unit has a Magic debuff"] = "如果友好目标身上有魔法系的Debuff则返回True"
	L["Return True if the unit has a Curse debuff"] = "如果友好目标身上有诅咒系的Debuff则返回True"
	L["Return True if the unit has a Poison debuff"] = "如果友好目标身上有毒系的Debuff则返回True"
	L["Return True if the unit has a Disease debuff"] = "如果友好目标身上有病系的Debuff则返回True"
	-- Cast
	L["Return the current or last spell to be cast"] = "返回当前或者最后一次施放的法术名"
	L["Return the current cast target name"] = "返回当前施法所作用于的目标名字"
end

end