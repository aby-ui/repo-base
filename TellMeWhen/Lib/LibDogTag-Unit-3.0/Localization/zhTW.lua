local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

if GetLocale() == "zhTW" then

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)
	local L = DogTag_Unit.L
	
	-- races
	L["Blood Elf"] = "血精靈"
	L["Draenei"] = "德萊尼"
	L["Dwarf"] = "矮人"
	L["Gnome"] = "地精"
	L["Human"] = "人類"
	L["Night Elf"] = "夜精靈"
	L["Orc"] = "獸人"
	L["Tauren"] = "牛頭人"
	L["Troll"] = "食人妖"
	L["Undead"] = "不死族"
	L["Blood Elf_female"] = "血精靈"
	L["Draenei_female"] = "德萊尼"
	L["Dwarf_female"] = "矮人"
	L["Gnome_female"] = "地精"
	L["Human_female"] = "人類"
	L["Night Elf_female"] = "夜精靈"
	L["Orc_female"] = "獸人"
	L["Tauren_female"] = "牛頭人"
	L["Troll_female"] = "食人妖"
	L["Undead_female"] = "不死族"

	-- short races
	L["Blood Elf_short"] = "血"
	L["Draenei_short"] = "德"
	L["Dwarf_short"] = "矮"
	L["Gnome_short"] = "地"
	L["Human_short"] = "人"
	L["Night Elf_short"] = "夜"
	L["Orc_short"] = "獸"
	L["Tauren_short"] = "牛"
	L["Troll_short"] = "妖"
	L["Undead_short"] = "死"

	-- classes
	L["Death Knight"] = "死亡騎士"
	L["Warrior"] = "戰士"
	L["Priest"] = "牧師"
	L["Mage"] = "法師"
	L["Shaman"] = "薩滿"
	L["Paladin"] = "聖騎士"
	L["Warlock"] = "術士"
	L["Druid"] = "德魯伊"
	L["Rogue"] = "盜賊"
	L["Hunter"] = "獵人"
	L["Death Knight_female"] = "死亡騎士"
	L["Warrior_female"] = "戰士"
	L["Priest_female"] = "牧師"
	L["Mage_female"] = "法師"
	L["Shaman_female"] = "薩滿"
	L["Paladin_female"] = "聖騎士"
	L["Warlock_female"] = "術士"
	L["Druid_female"] = "德魯伊"
	L["Rogue_female"] = "盜賊"
	L["Hunter_female"] = "獵人"

	-- short classes
	L["Death Knight_short"] = "死騎"
	L["Warrior_short"] = "戰"
	L["Priest_short"] = "牧"
	L["Mage_short"] = "法"
	L["Shaman_short"] = "薩"
	L["Paladin_short"] = "聖"
	L["Warlock_short"] = "術"
	L["Druid_short"] = "德"
	L["Rogue_short"] = "賊"
	L["Hunter_short"] = "獵"

	L["Player"] = PLAYER
	L["Target"] = TARGET
	L["Focus-target"] = FOCUS
	L["Mouse-over"] = "滑鼠目標"
	L["%s's pet"] = "%s的寵物"
	L["%s's target"] = "%s的目標"
	L["%s's %s"] = "%1$s's %2$s"
	L["Party member #%d"] = "隊員#%d"
	L["Raid member #%d"] = "團員#%d"
	L["Boss #%d"] = "Boss #%d"
	L["Arena enemy #%d"] = "Arena enemy #%d"

	-- classifications
	L["Rare"] = "稀有"
	L["Rare-Elite"] = "稀有精英"
	L["Elite"] = "精英"
	L["Boss"] = BOSS
	-- short classifications
	L["Rare_short"] = "稀"
	L["Rare-Elite_short"] = "稀+"
	L["Elite_short"] = "+"
	L["Boss_short"] = "首"

	L["Feigned Death"] = "假死"
	L["Stealthed"] = "潛行"
	L["Soulstoned"] = "靈魂石"

	L["Dead"] = "死亡"
	L["Ghost"] = "鬼魂"
	L["Offline"] = "離線"
	L["Online"] = "線上"
	L["Combat"] = "戰鬥"
	L["Resting"] = "休息"
	L["Tapped"] = "戰鬥"
	L["AFK"] = "暫離"
	L["DND"] = "勿擾"

	L["Rage"] = "怒氣"
	L["Focus"] = "集中"
	L["Energy"] = "能量"
	L["Mana"] = "魔法"
	L["Runic Power"] = "符能"

	L["PvP"] = PVP
	L["FFA"] = "自由"..PVP

	-- genders
	L["Male"] = "男"
	L["Female"] = "女"

	-- forms
	L["Bear"] = "熊"
	L["Cat"] = "獵豹"
	L["Moonkin"] = "梟獸"
	L["Aquatic"] = "水棲"
	L["Flight"] = "飛行"
	L["Travel"] = "旅行"
	L["Tree"] = "樹"

	L["Bear_short"] = "熊"
	L["Cat_short"] = "豹"
	L["Moonkin_short"] = "梟"
	L["Aquatic_short"] = "水"
	L["Flight_short"] = "飛"
	L["Travel_short"] = "旅"
	L["Tree_short"] = "樹"

	-- shortgenders
	L["Male_short"] = "男"
	L["Female_short"] = "女"

	L["Leader"] = "隊長"
	
	-- dispel types
	L["Magic"] = "魔法"
	L["Curse"] = "詛咒"
	L["Poison"] = "中毒"
	L["Disease"] = "疾病"
end

end
