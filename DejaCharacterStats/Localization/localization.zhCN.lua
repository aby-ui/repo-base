local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

--local LOCALE = GetLocale()

if namespace.locale == "zhCN" then
	-- The EU English game client also
	-- uses the US English locale code.

L["DejaCharacterStats Slash commands (/dcstats):"] = "Deja角色详细属性 命令帮助 (/dcstats):"
L["  /dcstats config: Open the DejaCharacterStats addon config menu."] = "  /dcstats config: 打开配置界面."
L["  /dcstats reset:  Resets DejaCharacterStats frames to default positions."] = "  /dcstats reset:  重置为默认设置."

L["Resetting config to defaults"] = "设置已重置"
L["DejaCharacterStats is currently using "] = "Deja角色属性现在使用 "
L[" kbytes of memory"] = " KB的内存"
L[" kbytes of memory after garbage collection"] = "  KB的内存（垃圾收集后）"
L["config"] = "config"
L["dumpconfig"] = "dumpconfig"
L["With defaults"] = "With defaults"
L["Reset to Default"] = "重置回预设"


L['Checked displays all stats. Unchecked displays relevant stats. Use Shift-scroll to snap to the top or bottom.'] = '勾选显示所有属性。未勾选则显示相关属性。使用Shift快速滚动到顶部或底部。'
L["Show All Stats"] = "显示所有属性"
L['Select which stats to display. Use Shift-scroll to snap to the top or bottom.'] = '选择要显示哪个属性。使用Shift快速滚动到顶部或底部。'
L["Select-A-Stat™"] = "选择以下属性™"
L['Displays the average Durability percentage for equipped items in the stat frame.'] = '在属性框架显示已装备物品的耐久度百分比。'
L['Durability '] = '耐久度'
L['Displays the Repair Total before discounts for equipped items in the stat frame.'] = '在属性框架显示未打折的已装备物品修理花费总计。'
L['Repair Total '] = '修理费'

L['Displays the DCS scrollbar.'] = '属性面板显示滚动条。'
L["Scrollbar"] = "滚动条"

L['Displays Equipped/Available item levels unless equal.'] = '显示 已装备/可用 物品等级除非相等。'
L["Equipped/Available"] = "已装备/平均"

L['Show Character Stats'] = '显示角色属性'
L['Hide Character Stats'] = '隐藏角色属性'
L['Displays the Expand button for the character stats frame.'] = '在角色属性面板下部显示收缩按钮'
L["Expand"] = "显示收缩按钮"

L["Displays each equipped item's durability."] = "在每个装备栏上显示物品的耐久度"
L["Item Durability"] = "装备栏耐久度文字"
L["Displays a durability bar next to each item."] = "在每个物品的旁边显示耐久度条。"
L["Durability Bars"] = "耐久度条"
L["Durability"] = "耐久度"
L["Average equipped item durability percentage."] = "已装备物品平均耐久度百分比。"
L["Durability %s"] = "耐久度 %s"
L["Displays average item durability on the character shirt slot and durability frames."] = "在衬衫装备栏上显示已装备物品平均耐久度百分比数字。"
L["Average Durability"] = "平均耐久度"
L["Repair Total"] = "修理总计"
L["Repair Total %s"] = "修理总计 %s"
L["Total equipped item repair cost before discounts."] = "未打折前的已装备物品修理花费总计。"
L["Displays each equipped item's repair cost."] = "在装备栏显示每个物品所需的修理费"
L["Item Repair Cost"] = "装备栏修理费文字"

L['Displays "Enhancements" category stats to two decimal places.'] = '显示"强化"栏的属性到两个小数点。'
L["Decimals"] = "小数点"

-- ## Attributes ##

	L["Health"] = "生命值"
	L["Power"] = "能量"
	L["Druid Mana"] = "德鲁伊法力"
	L["Armor"] = "护甲"
	L["Strength"] = "力量"
	L["Agility"] = "敏捷"
	L["Intellect"] = "智力"
	L["Stamina"] = "耐力"
	L["Damage"] = "伤害"
	L["Attack Power"] = "攻击强度"
	L["Attack Speed"] = "攻击速度"
	L["Spell Power"] = "法术能量"
	L["Mana Regen"] = "法力恢复"
	L["Energy Regen"] = "能量恢复"
	L["Rune Regen"] = "符能恢复"
	L["Focus Regen"] = "集中值恢复"
	L["Movement Speed"] = "移动速度"
    L["Speed Rating"] = "加速值"
	L["Durability"] = "耐久度"
	L["Repair Total"] = "修理费"

-- ## Enhancements ##

	L["Critical Strike"] = "爆击"
	L["Haste"] = "急速"
	L["Versatility"] = "全能"
	L["Mastery"] = "精通"
	L["Leech"] = "吸血"
	L["Avoidance"] = "回避"
	L["Dodge"] = "闪避"
	L["Parry"] = "招架"
	L["Block"] = "格挡"

-- ## Patch 7.1.0 r2 additions ##
	L["Global Cooldown"] = "公共冷卻"
	L["Global Cooldown %.2fs"] = "公共冷卻 %.2fs"
--	L["General global cooldown for casters. Individual spells, set bonuses, talents, etc. not considered. Not suitable for melee. Improvements coming Soon(TM)."] = ""
	L["Unlock DCS"] = "选择要显示的属性"
	L["Lock DCS"] = "锁定属性列表"
	L["Item Level 1 Decimal Place"] = "显示物品等级到小数点后一位"
	L["Displays average item level to one decimal place."] = "显示平均装备等级到小数点后一位。"
	L["Item Level 2 Decimal Places"] = "显示物品等级到小数点后两位"
	L["Displays average item level to two decimal places."] = "显示平均装备等级到小数点后两位。"
	L["Main Hand"] = "主手"
	L["/Off Hand"] = "/副手"
	L[" weapon auto attack (white) DPS."] = ' 武器平砍(白字)秒伤。'
	L["Weapon DPS"] = "武器秒伤"
	L["Weapon DPS %s"] = "武器秒伤 %s"
--	L["Class Crest Background"] = ""
--	L["Displays the class crest background."] = ""

    L["Relevant Stats"] = "智能选择"
    L["Reset Stats"] = "恢复预设"
    L["All Stats"] = "选择全部"

    L["Haste Rating"] = "急速值"
    L["Leech Rating"] = "吸血值"
    L["Avoidance Rating"] = "闪避值"
    L["Dodge Rating"] = "躲闪值"
    L["Parry Rating"] = "招架值"
    L["Critical Strike Rating"] = "暴击值"
    L["Versatility Rating"] = "全能值"
    L["Mastery Rating"] = "精通值"

    L["General"] = "通用"
    L["Defense"] = "防御属性"
    L["Offense"] = "进攻属性"
    L["Ratings"] = "强化数值"
	
-- ###################################################################################################################################
-- ##	简体中文 (Simplified Chinese) translations provided by C_Reus(Azpilicuet@主宰之剑), alvisjiang, and y123ao6 on Curseforge.	##
-- ###################################################################################################################################

L["  /dcstats config: Opens the DejaCharacterStats addon config menu."] = "/dcstats config: 开启DejaCharacterStats插件设置选项。"
L["  /dcstats reset:  Resets DejaCharacterStats options to default."] = "/dcstats reset: 重置DejaCharacterStats选项回预设。"
L["%s of %s increases %s by %.2f%%"] = "%s：%s 相当于 %s：%.2f%%"
L["About DCS"] = "关于DCS"
L["All Stats"] = "所有属性"
L["Attack"] = "攻击"
L["Average Durability"] = "平均耐久度"
L["Average equipped item durability percentage."] = "已装备的物品耐久度平均百分比"
L["Average Item Level:"] = "平均物品等级："
L["Avoidance Rating"] = "闪躲百分比值"
L["Blizzard's Hide At Zero"] = "以暴雪的方式隐藏 0 值"
L["Character Stats:"] = "角色属性："
L["Class Colors"] = "职业颜色"
L["Class Crest Background"] = "职业纹章背景"
L["Critical Strike Rating"] = "爆击百分比值"
L["DCS's Hide At Zero"] = "以 DCS 的方式隐藏 0 值"
L["Decimals"] = "小数点"
L["Defense"] = "防御"
L["Dejablue's improved character stats panel view."] = "Dejablue的角色属性统计面板增强。"
L["DejaCharacterStats Slash commands (/dcstats):"] = "DejaCharacterStats 命令(/dcsstats)"
L["Displays a durability bar next to each item."] = "在装备图标旁显示耐久条"
L["Displays average item durability on the character shirt slot and durability frames."] = "在角色界面衬衫栏与耐久度框架显示平均物品耐久度。"
L["Displays average item level to one decimal place."] = "显示平均装等小数点后一位"
L["Displays average item level to two decimal places."] = "显示平均装等小数点后两位"
L["Displays average item level with class colors."] = "以职业颜色显示平均物品等级。"
L["Displays each equipped item's durability."] = "显示每件装备的耐久度"
L["Displays each equipped item's repair cost."] = "显示每件装备的维修费用"
L["Displays 'Enhancements' category stats to two decimal places."] = "显示'强化'栏位的属性到两个小数点。"
L["Displays Equipped/Available item levels unless equal."] = "显示已装备/可用的物品等级除非相等。"
L["Displays the class crest background."] = "显示职业特色背景。"
L["Displays the DCS scrollbar."] = "显示DejaCharacterStats滚动条"
L["Displays the Expand button for the character stats frame."] = "显示打开角色属性界面按钮。"
L["Displays the item level of each equipped item."] = "显示已装备物品等级。"
L["Dodge Rating"] = "躲闪值"
L["Durability"] = "耐久度"
L["Durability Bars"] = "耐久度条"
L["Equipped/Available"] = "已装备/可用"
L["Expand"] = "展开"
L["General"] = "综合"
L["General global cooldown refresh time."] = "公共冷却刷新时间。"
L["Global Cooldown"] = "公共冷却"
L["Haste Rating"] = "急速值"
L["Hide Character Stats"] = "隐藏人物属性"
L["Hide low level mastery"] = "隐藏低等级精通"
L["Hides 'Enhancements' stats if their displayed value would be zero. Checking 'Decimals' changes the displayed value."] = "如果'强化'属性值为零则隐藏，开启'小数点'选项则显示。"
L["Hides 'Enhancements' stats only if their numerical value is exactly zero. For example, if stat value is 0.001%, then it would be displayed as 0%."] = "当'强化'属性值为零时隐藏，例：某属性值为0.001%，显示为0%"
L["Hides Mastery stat until the character starts to have benefit from it. Hiding Mastery with Select-A-Stat™ in the character panel has priority over this setting."] = "在角色从中受益之前，隐藏精通属性。(如果通过Select-A-Stat™在角色面板中隐藏精通，会优先于此设置。)"
L["Item Durability"] = "物品耐久度"
L["Item Level"] = "物品等级"
L["Item Repair Cost"] = "物品修理费"
L["Item Slots:"] = "物品栏位："
L["Leech Rating"] = "吸血值"
L["Lock DCS"] = "锁定DCS"
L["Main Hand"] = "主手"
L["Mastery Rating"] = "精通值"
L["Miscellaneous:"] = "其他选项："
L["Movement Speed"] = "移动速度"
L["Off Hand"] = "副手"
L["Offense"] = "设置"
L["One Decimal Place"] = "小数点后一位"
L["Parry Rating"] = "招架值"
L["Ratings"] = "等级"
L["Relevant Stats"] = "相应属性"
L["Repair Total"] = "总修理费"
L["Requires Level "] = "需求等级"
L["Reset Stats"] = "重置属性"
L["Reset to Default"] = "恢复至默认配置"
L["Resets order of stats."] = "重置属性顺序。"
L["Scrollbar"] = "滚动条"
L["Show all stats."] = "显示全部属性"
L["Show Character Stats"] = "显示角色属性"
L["Show only stats relevant to your class spec."] = "只显示你职业专精相关的属性。"
L["Total equipped item repair cost before discounts."] = "折扣前的已装备物品修理费"
L["Two Decimal Places"] = "小数点后两位"
L["Unlock DCS"] = "解锁DCS"
L["Versatility Rating"] = "全能百分比值"
L["weapon auto attack (white) DPS."] = "武器自动攻击(白字)每秒伤害。"
L["Weapon DPS"] = "武器伤害"

return end
