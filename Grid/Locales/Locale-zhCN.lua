--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	GridLocale-zhCN.lua
	Simplified Chinese localization
	Contributors: ananhaid, candykiss, flyflame, Ghostar, isler, samuelcup, wowuicn, yleaf
----------------------------------------------------------------------]]

if GetLocale() ~= "zhCN" then return end

local _, Grid = ...
local L = { }
Grid.L = L

------------------------------------------------------------------------
--	GridCore

-- GridCore
L["Debugging"] = "调试信息"
L["Debugging messages help developers or testers see what is happening inside Grid in real time. Regular users should leave debugging turned off except when troubleshooting a problem for a bug report."] = "除错信息可以帮助开发者或测试者看到 Grid 内部发生的实时状态。普通用户应在没有出错问题报告时关闭除错。"
L["Enable debugging messages for the %s module."] = "启用%s模块除错信息。"
L["General"] = "通用"
L["Module debugging menu."] = "设置各模块的调试信息"
L["Open Grid's options in their own window, instead of the Interface Options window, when typing /grid or right-clicking on the minimap icon, DataBroker icon, or layout tab."] = "打开单独的Grid设置对话框，而不是内嵌在暴雪界面选项窗口中，影响/grid命令，以及右击小地图图标、DataBroker图标、布局标签。"
L["Output Frame"] = "输出框架"
L["Right-Click for more options."] = "右击获取更多选项。"
L["Show debugging messages in this frame."] = "在此框架显示除错信息。"
L["Show minimap icon"] = "显示小地图图标"
L["Show the Grid icon on the minimap. Note that some DataBroker display addons may hide the icon regardless of this setting."] = "在小地图显示Grid图标。注意，一些DataBroker插件会无视此设置始终隐藏。"
L["Standalone options"] = "单独的配置窗口"

------------------------------------------------------------------------
--	GridFrame

-- GridFrame
L["Adjust the font outline."] = "调整字体轮廓。"
L["Adjust the font settings"] = "调整字体设置"
L["Adjust the font size."] = "调整字体尺寸。"
L["Adjust the height of each unit's frame."] = "调整单位框架的高度。"
L["Adjust the size of the border indicators."] = "调整外框指示的尺寸。"
L["Adjust the size of the center icon."] = "调整中心图标的尺寸。"
L["Adjust the size of the center icon's border."] = "调整中心图标外框的尺寸。"
L["Adjust the size of the corner indicators."] = "调整边角指示的尺寸。"
L["Adjust the texture of each unit's frame."] = "调整单位框架的材质。"
L["Adjust the width of each unit's frame."] = "调整单位框架的宽度。"
L["Always"] = "总是"
L["Bar Options"] = "血条样式"
L["Border"] = "边框"
L["Border Size"] = "边框宽窄"
L["Bottom Left Corner"] = "左下角"
L["Bottom Right Corner"] = "右下角"
L["Center Icon"] = "中心图标"
L["Center Text"] = "中心文本"
L["Center Text 2"] = "中心文本2"
L["Center Text Length"] = "中心文本长度"
L["Corner Size"] = "边角指示尺寸"
L["Darken the text color to match the inverted bar."] = "文本颜色变暗以匹配反转条。"
L["Enable %s"] = "启用%s"
L["Enable %s indicator"] = "启用%s指示"
L["Enable Mouseover Highlight"] = "启用鼠标悬停高亮"
L["Enable right-click menu"] = "启用右键菜单"
L["Font"] = "字体"
L["Font Outline"] = "字体轮廓"
L["Font Shadow"] = "字体阴影"
L["Font Size"] = "字体尺寸"
L["Frame"] = "框架"
L["Frame Alpha"] = "框架透明度"
L["Frame Height"] = "框架高度"
L["Frame Texture"] = "框架材质"
L["Frame Width"] = "框架宽度"
L["Healing Bar"] = "治疗条"
L["Healing Bar Opacity"] = "治疗条透明度"
L["Healing Bar Uses Status Color"] = "治疗条使用状态颜色"
L["Health Bar"] = "生命条"
L["Health Bar Color"] = "生命条颜色"
L["Horizontal"] = "水平"
L["Icon Border Size"] = "图标外框尺寸"
L["Icon Cooldown Frame"] = "图标冷却时间框架"
L["Icon Options"] = "图标选项"
L["Icon Size"] = "图标尺寸"
L["Icon Stack Text"] = "图标堆叠文本"
L["Indicators"] = "指示关联"
L["Invert Bar Color"] = "反转条颜色"
L["Invert Text Color"] = "反转文本颜色"
L["Make the healing bar use the status color instead of the health bar color."] = "治疗条使用状态颜色而不是治疗条颜色。"
L["Never"] = "从不"
L["None"] = "无"
L["Number of characters to show on Center Text indicator."] = "中心文本提示所显示文字的长度。"
L["OOC"] = "非战斗"
--L["Options for %s indicator."] = "设置%s提示器显示的内容。" --NO USE
L["Options for assigning statuses to indicators."] = "设置界面各个位置（边、角、条、图标等）显示的信息。"
L["Options for GridFrame."] = "设置Grid框体及各个指示器的自身参数，例如宽度、高度、字体、方向等。"
L["Options related to bar indicators."] = "血条指示器的选项"
L["Options related to icon indicators."] = "中央图标指示器的选项."
L["Options related to text indicators."] = "中心文本指示器的选项。"
L["Orientation of Frame"] = "框架方向"
L["Orientation of Text"] = "文本排列方向"
L["Set frame orientation."] = "设定框架方向。"
L["Set frame text orientation."] = "设定框架文本1和文本2的排列方向。"
L["Sets the opacity of the healing bar."] = "设定治疗条的透明度。"
L["Show the standard unit menu when right-clicking on a frame."] = "右击框架显示标准单位菜单。"
L["Show Tooltip"] = "显示提示信息"
L["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "显示单位框架的鼠标信息。选择“总是”，“从不”或“非战斗”。"
L["Statuses"] = "选择状态, 完全不用的状态请关闭"
L["Swap foreground/background colors on bars."] = "反转提示条上前景/背景的颜色。"
L["Text Options"] = "文字样式"
L["Thick"] = "粗"
L["Thin"] = "细"
L["Throttle Updates"] = "节流更新"
L["Throttle updates on group changes. This option may cause delays in updating frames, so you should only enable it if you're experiencing temporary freezes or lockups when people join or leave your group."] = "团队变化节流更新。此选项可能造成框架更新的延迟，仅当遇到任务加入或离开队伍时出现临时卡住的情况才使用。"
L["Toggle center icon's cooldown frame."] = "显示中心图标的冷却时间框架。"
L["Toggle center icon's stack count text."] = "切换中心图标的堆叠计数文本。"
L["Toggle mouseover highlight."] = "切换鼠标悬停高亮。"
L["Toggle status display."] = "切换状态显示。"
L["Toggle the %s indicator."] = "切换%s指示。"
L["Toggle the font drop shadow effect."] = "切换字体阴影效果。"
L["Top Left Corner"] = "左上角"
L["Top Right Corner"] = "右上角"
L["Vertical"] = "垂直"

------------------------------------------------------------------------
--	GridLayout

-- GridLayout
L["10 Player Raid Layout"] = "10人团队布局"
L["25 Player Raid Layout"] = "25人团队布局"
L["40 Player Raid Layout"] = "40人团队布局"
--L["Adjust background color and alpha."] = "调整背景颜色和透明度。"  --NO USE
--L["Adjust border color and alpha."] = "调整外框的颜色和透明度。"
--L["Adjust frame padding."] = "调整单位框架之间的间距。"
--L["Adjust frame spacing."] = "调整单位框架与外框的距离。"
--L["Adjust Grid scale."] = "调整整体缩放比例。"
L["Adjust the extra spacing inside the layout frame, around the unit frames."] = "调整边缘单位框架与整体外边框之间的填充距离"
L["Adjust the spacing between the individual unit frames."] = "调整各个单位框架之间的距离。"
--L["Advanced"] = "高级"
--L["Advanced options."] = "高级选项。"
L["Allow mouse clicks to pass through the background when Grid is locked."] = "当Grid锁定时，鼠标可以穿透背景，包括单位框架之间的空隙，进行点击操作，不会被阻挡。"
L["Alt-Click to permanantly hide this tab."] = "Ctrl+Alt+点击 隐藏此标签。"
L["Always hide wrong zone groups"] = "始终隐藏"
L["Arena Layout"] = "竞技场布局"
L["Background color"] = "背景颜色"
L["Background Texture"] = "背景材质"
L["Battleground Layout"] = "战场布局"
L["Beast"] = "野兽"
L["Border color"] = "外框颜色"
L["Border Inset"] = "外框内嵌"
L["Border Size"] = "外框尺寸"
L["Border Texture"] = "外框材质"
L["Bottom"] = "底部"
L["Bottom Left"] = "左下"
L["Bottom Right"] = "右下"
L["By Creature Type"] = "以生物种类"
L["By Owner Class"] = "以主人的职业颜色"
L["ByGroup Layout Options"] = "按小队编组时的选项"
L["Center"] = "中心"
--L["Choose the layout border texture."] = "选择布局外框材质。"
--L["Clamped to screen"] = "保持在屏幕上"
L["Class colors"] = "职业颜色"
L["Click through background"] = "背景不阻挡鼠标点击"
L["Color for %s."] = "%s的颜色。"
--L["Color of pet unit creature types."] = "宠物单位生物种类的颜色。"
--L["Color of player unit classes."] = "玩家单位职业颜色。"
L["Color of unknown units or pets."] = "未知单位或宠物颜色。"
--L["Color options for class and pets."] = "职业和宠物的颜色选项。"
L["Colors"] = "颜色"
L["Creature type colors"] = "生物种类颜色"
L["Demon"] = "恶魔"
L["Drag this tab to move Grid."] = "拖动此标签将移动 Grid。"
L["Dragonkin"] = "龙类"
L["Elemental"] = "元素"
L["Fallback colors"] = "缺省颜色"
--L["Flexible Raid Layout"] = "弹性团队布局"
L["Frame lock"] = "锁定框架"
--L["Frame Spacing"] = "框架间距"
L["Group Anchor"] = "队伍锚点"
L["Hide when in mythic raid instance"] = "位于史诗团队副本时隐藏"
L["Hide when in raid instance"] = "位于团队副本时隐藏"
L["Horizontal groups"] = "横向排列队伍"
L["Humanoid"] = "人型"
L["Layout"] = "布局"
L["Layout Anchor"] = "布局锚点"
L["Layout Background"] = "布局背景"
L["Layout Padding"] = "外框距离"
L["Layouts"] = "布局"
L["Layouts added by plugins might not support this option."] = "第三方模块添加的布局可能不支持此选项。"
L["Left"] = "左侧"
L["Lock Grid to hide this tab."] = "锁定 Grid 将隐藏此标签。"
L["Locks/unlocks the grid for movement."] = "锁定/解锁 Grid 框体来让其移动。"
L["Not specified"] = "未分类"
--L["Options for GridLayout."] = "Grid 布局的选项。"
--L["Padding"] = "填充"
L["Party Layout"] = "小队布局"
L["Pet color"] = "宠物颜色"
L["Pet coloring"] = "宠物着色"
L["Raid Layout"] = "团队布局"
L["Reset Position"] = "重置位置"
L["Resets the layout frame's position and anchor."] = "重置布局框架的位置和锚点。"
L["Right"] = "右侧"
L["Scale"] = "整体缩放"
--L["Select which layout to use when in a 10 player raid."] = "10人团队时所选择使用的布局。"
--L["Select which layout to use when in a 25 player raid."] = "25人团队时所选择使用的布局。"
--L["Select which layout to use when in a 40 player raid."] = "40人团队时所选择使用的布局。"
--L["Select which layout to use when in a battleground."] = "在战场时所选择使用的布局。"
--L["Select which layout to use when in a flexible raid."] = "弹性团队时所选择使用的布局。"
--L["Select which layout to use when in a party."] = "在小队时所选择使用的布局。"
--L["Select which layout to use when in an arena."] = "在竞技场时所选择使用的布局。"
--L["Select which layout to use when not in a party."] = "没有小队时所选择使用的布局。"
--L["Set the color of pet units."] = "设定宠物单位的颜色。"
--L["Set the coloring strategy of pet units."] = "设定宠物单位颜色策略。"
L["Sets where Grid is anchored relative to the screen."] = "设定Grid整体框架的锚点，相对于整个屏幕"
L["Sets where groups are anchored relative to the layout frame."] = "设定布局框架中队伍的锚点。"
L["Show a tab for dragging when Grid is unlocked."] = "未锁定 Grid 时显示标签。"
L["Show all groups"] = "显示全部队伍"
--L["Show Frame"] = "显示框架"
L["Show groups with all players in wrong zone."] = "设置如何显示成员全部未到场的小队"
L["Show groups with all players offline."] = "即使一个小队里的队员全部离线，仍然显示该小队"
L["Show Offline"] = "显示成员全部离线的小队"
L["Show tab"] = "显示标签"
L["Solo Layout"] = "单人布局"
--L["Spacing"] = "空隙"
L["Switch between horizontal/vertical groups."] = "选择横向/竖向显示队伍。"
L["The color of unknown pets."] = "未知宠物的颜色。"
L["The color of unknown units."] = "未知单位颜色。"
--L["Toggle whether to permit movement out of screen."] = "切换是否允许把窗口移出屏幕。"
L["Top"] = "顶部"
L["Top Left"] = "左上"
L["Top Right"] = "右上"
L["Undead"] = "亡灵"
L["Unknown Pet"] = "未知宠物"
L["Unit Spacing"] = "单位间距"
L["Unknown Unit"] = "未知单位"
--L["Use the 40 Player Raid layout when in a raid group outside of a raid instance, instead of choosing a layout based on the current Raid Difficulty setting."] = "当在副本之外的野外团队时使用40人团队布局，而不是选择基于当前副本难度设置的布局。"
L["Using Fallback color"] = "使用缺省颜色"
L["World Raid as 40 Player"] = "世界团队40人"
L["Wrong Zone"] = "未到场小队的显示"

------------------------------------------------------------------------
--	GridLayoutLayouts

-- GridLayoutLayouts
L["By Class 10"] = "10人职业以及宠物"
L["By Class 10 w/Pets"] = "10人职业"
L["By Class 25"] = "25人职业以及宠物"
L["By Class 25 w/Pets"] = "25人职业"
L["By Class 40"] = "40人职业"
L["By Class 40 w/Pets"] = "40人职业以及宠物"
L["By Group 10"] = "10人团队"
L["By Group 10 w/Pets"] = "10人团队以及宠物"
L["By Group 15"] = "15人团队"
L["By Group 15 w/Pets"] = "15人团队以及宠物"
L["By Group 25"] = "25人团队"
L["By Group 25 w/Pets"] = "25人团队以及宠物"
L["By Group 25 w/Tanks"] = "25人团队及坦克"
L["By Group 40"] = "40人团队"
L["By Group 40 w/Pets"] = "40人团队以及宠物"
L["By Group"] = "按小队编组"
L["By Role"] = "按角色编组"
L["By Class"] = "按职业角色编组"
L["None"] = "无"

------------------------------------------------------------------------
--	GridLDB

-- GridLDB
L["Click to toggle the frame lock."] = "点击锁定或解锁框架。"

------------------------------------------------------------------------
--	GridStatus

-- GridStatus
L["Color"] = "颜色"
L["Color for %s"] = "%s的颜色"
L["Enable"] = "启用"
L["Opacity"] = "不透明度"
L["Options for %s."] = "%s的选项。"
L["Priority"] = "优先度"
L["Priority for %s"] = "%s的优先度"
L["Range filter"] = "范围过滤"
L["Reset class colors"] = "重置职业颜色"
L["Reset class colors to defaults."] = "重置职业颜色为默认。"
L["Show status only if the unit is in range."] = "单位只在范围内时显示状态。"
L["Status"] = "状态选项"
L["Status: %s"] = "状态：%s"
L["Text"] = "文本"
L["Text to display on text indicators"] = "在文本提示上显示文本"

------------------------------------------------------------------------
--	GridStatusAbsorbs

-- GridStatusAbsorbs
L["Absorbs"] = "吸收"
L["Only show total absorbs greater than this percent of the unit's maximum health."] = "只显示吸收总量大于此百分比单位最大生命值。"

------------------------------------------------------------------------
--	GridStatusAggro

L["High"] = "高"
L["Aggro"] = "弱"
L["Tank"] = "坦"

--L["Aggro alert"] = "仇恨警报"
--L["Aggro color"] = "仇恨颜色"
--L["Color for Aggro."] = "获得仇恨时的颜色。"
--L["Color for High Threat."] = "高威胁时的颜色。"
--L["Color for Tanking."] = "坦克时的颜色。"
--L["High Threat color"] = "高威胁颜色"
--L["Tanking color"] = "坦克颜色"
--L["Threat"] = "威胁"

L["High State"] = "即将获得仇恨"
L["not tanking, higher threat than tank."] = "'高'：非当前仇恨目标，但威胁值已经比坦克高了。"
L["Aggro Status"] = "仇恨状态"
L["insecurely tanking, another unit have higher threat but not tanking."] = "'弱'：不稳定的坦克状态，有其他单位威胁值更高但尚未OT。"
L["Tanking State"] = "稳定坦克中"
L["securely tanking, highest threat."] = "'稳'：威胁值最高，稳定吸引仇恨中"
L["Threat levels"] = "仇恨级别"
L["Show more detailed threat levels."] = "显示更多威胁分级。"

------------------------------------------------------------------------
--	GridStatusAuras

-- GridStatusAuras
L["%s colors"] = "%s颜色"
L["%s colors and threshold values."] = "%s颜色和阈值。"
L["%s is high when it is at or above this value."] = "达到或高于此值时%s过高。"
L["%s is low when it is at or below this value."] = "达到或低于此值时%s过低。"
L["(De)buff name"] = "增（减）益名称"
L["<buff name>"] = "<增益名称> 或 <增益ID>"
L["<debuff name>"] = "<减益名称> 或 <减益ID>"
L["Add Buff"] = "增加新的增益"
L["Add Debuff"] = "增加新的减益"
L["Auras"] = "光环"
L["Buff: %s"] = "增益：%s"
L["Change what information is shown by the status color and text."] = "更改状态颜色和文本所指示的信息。"
L["Change what information is shown by the status color."] = "更改状态颜色所指示的信息。"
L["Change what information is shown by the status text."] = "更改状态文本所指示的信息。"
--L["Class Filter"] = "职业过滤"
L["Color"] = "颜色"
--L["Color to use when the %s is above the high count threshold values."] = "%s高于阈值上限使用的颜色。"
--L["Color to use when the %s is between the low and high count threshold values."] = "%s位于阈值上下限间使用的颜色。"
L["Color when %s is below the low threshold value."] = "%s 低于阈值下限使用的颜色。"
L["Color when %s is between the low and high threshold values."] = "%s 位于阈值上下限之间时使用的颜色。"
L["Color when %s is above the high threshold value."] = "%s 高于阈值上限使用的颜色。"
L["Create a new buff status."] = "状态模块添加一个新的增益"
L["Create a new debuff status."] = "状态模块添加一个新的减益"
L["Curse"] = "诅咒"
L["Debuff type: %s"] = "减益类型：%s"
L["Debuff: %s"] = "减益：%s"
L["Disease"] = "疾病"
L["Display status only if the buff is not active."] = "仅显示增益缺少时的状态。"
L["Display status only if the buff was cast by you."] = "仅显示由你施放的增益。"
L["Duration"] = "剩余时间"
--L["Ghost"] = "灵魂"
L["High color"] = "高值颜色"
L["High threshold"] = "阈值上限"
L["Low color"] = "低值颜色"
L["Low threshold"] = "阈值下限"
L["Magic"] = "魔法"
L["Middle color"] = "中值颜色"
L["Pet"] = "宠物"
L["Poison"] = "毒药"
L["Present or missing"] = "当前或缺失"
L["Refresh interval"] = "刷新间隔"
L["Remove %s from the menu"] = "从功能单中移除%s"
L["Remove an existing buff or debuff status."] = "删除状态模块内已有的一个增（减）益"
L["Remove Aura"] = "删除增（减）益"
L["Remove %s from the menu"] = "从菜单中移除%s"
L["%s colors"] = "%s颜色"
L["%s colors and threshold values."] = "%s颜色和阈值。"
L["%s is low below this value."] = "%s 低于此数即为低值"
L["%s is high above this value."] = "%s 高于此数即为高值"
L["Show advanced options"] = "显示高级选项"
L["Show advanced options for buff and debuff statuses.\n\nBeginning users may wish to leave this disabled until you are more familiar with Grid, to avoid being overwhelmed by complicated options menus."] = "为增益和减益状态显示高级选项。\n\n初级用户应禁用此选项，直到您更熟悉Grid，以避免被复杂的菜单选项搞晕。"
L["Show if mine"] = "显示我的"
L["Show if missing"] = "显示缺失"
L["Show on %s players."] = "在%s玩家上显示。"
L["Show on pets and vehicles."] = "显示宠物和载具"
L["Show status for the selected classes."] = "显示选定职业的状态。"
L["Show the time left to tenths of a second, instead of only whole seconds."] = "剩余时间精确到0.1秒而非显示整数秒。"
L["Show the time remaining, for use with the center icon cooldown."] = "显示的剩余时间，用于中心图标冷却。"
L["Show time left to tenths"] = "剩余时间显示到0.1秒"
L["Stack count"] = "堆叠层数"
L["Status Information"] = "状态信息"
L["Text"] = "文本"
L["Time in seconds between each refresh of the duration status."] = "每次刷新剩余时间的间隔（秒）。"
L["Time left"] = "时间剩余"

------------------------------------------------------------------------
--	GridStatusHeals

-- GridStatusHeals
L["Heals"] = "治疗"
L["Ignore heals cast by you."] = "忽略自身施放的治疗。"
L["Ignore Self"] = "忽略自身"
L["Incoming heals"] = "正被治疗"
L["Minimum Value"] = "最低值"
L["Only show incoming heals greater than this amount."] = "仅显示大于该数值的接受治疗量。"

------------------------------------------------------------------------
--	GridStatusHealth

-- GridStatusHealth
L["Color deficit based on class."] = "用职业颜色来显示损失的血量。"
L["Color health based on class."] = "用职业颜色来显示血量。"
L["DEAD"] = "死"
L["Death warning"] = "死亡警报"
L["FD"] = "假"
L["Feign Death warning"] = "假死提示"
L["Health and Death"] = "血量与死亡"
L["Health deficit"] = "损失的血量"
L["Health threshold"] = "血量阈值"
L["Low HP"] = "低"
L["Low HP threshold"] = "低血量阈值"
L["Low HP warning"] = "低血量警报"
L["Offline"] = "离"
L["Offline warning"] = "离线警报"
L["Only show deficit above % damage."] = "仅在受到大于%伤害时显示失血量。"
L["Set the HP % for the low HP warning."] = "按百分比设定低血量警报。"
L["Show dead as full health"] = "死亡显示为满血"
L["Treat dead units as being full health."] = "把死亡单位显示为满血。"
L["Unit health"] = "单位血量"
L["Use class color"] = "使用职业颜色"

------------------------------------------------------------------------
--	GridStatusMana

-- GridStatusMana
L["Low Mana"] = "低法力"
L["Low Mana warning"] = "低法力警报"
L["Mana"] = "法力"
L["Mana threshold"] = "法力阈值"
L["Set the percentage for the low mana warning."] = "按百分比设定低法力警报。"

------------------------------------------------------------------------
--	GridStatusName

-- GridStatusName
L["Color by class"] = "按职业着色"
L["Unit Name"] = "单位名字"

------------------------------------------------------------------------
--	GridStatusRange

-- GridStatusRange
L["Out of Range"] = "超出范围"
L["Range"] = "范围"
L["Range check frequency"] = "范围检测的频率"
L["Seconds between range checks"] = "多少秒检测一次范围"

------------------------------------------------------------------------
--	GridStatusReadyCheck

-- GridStatusReadyCheck
L["?"] = "？"
L["AFK"] = "离"
L["AFK color"] = "暂离颜色"
L["Delay"] = "结果保留时间"
L["Not Ready"] = "未就位"
L["R"] = "是"
L["Ready Check"] = "就位确认"
L["Ready"] = "已就位"
L["Set the delay until ready check results are cleared."] = "设定就位确认检查结果清除的延迟。"
L["Waiting"] = "等待确认中"
L["X"] = "否"

------------------------------------------------------------------------
--	GridStatusResurrect

-- GridStatusResurrect
L["Casting color"] = "施放颜色"
L["Pending color"] = "等待颜色"
L["RES"] = "复"
L["Resurrection"] = "复活"
L["Resurrection colors"] = "复活状态的颜色"
L["Show the status until the resurrection is accepted or expires, instead of only while it is being cast."] = "显示此状态直到单位确认复活或过期，而非仅在施放复活法术时显示。 "
L["Show until used"] = "未接受前一直显示"
L["Use this color for resurrections that are currently being cast."] = "正被施放复活法术时使用此颜色。"
L["Use this color for resurrections that have finished casting and are waiting to be accepted."] = "施放结束，等待接受复活使用此颜色。"
L["Soulstone color"] = "复活石等待颜色"
L["Use this color for pre-cast Soulstones that are waiting to be accepted."] = "绑定的复活石尚未被接受时，使用此颜色"

------------------------------------------------------------------------
--	GridStatusTarget

-- GridStatusTarget
L["Target"] = "目标"
L["Your Target"] = "你的目标"
L["Your Focus"] = "你的关注焦点"

------------------------------------------------------------------------
--	GridStatusVehicle

-- GridStatusVehicle
L["Driving"] = "载"
L["In Vehicle"] = "使用载具"

------------------------------------------------------------------------
--	GridStatusVoiceComm

-- GridStatusVoiceComm
L["Talking"] = "正在说话"
L["Voice Chat"] = "语音聊天"

------------------------------------------------------------------------
--	Group
L["Group Leader ABBREVIATION"] = "团"
L["Group Assistant ABBREVIATION"] = "助"
L["Master Looter ABBREVIATION"] = "分"
L["Group Leader"] = "团队领袖"
L["Group Assistant"] = "团队助理"
L["Master Looter"] = "团队分配"
L["Group"] = "团队角色"

------------------------------------------------------------------------
--	Stagger
L["Stagger"] = "醉拳(武僧坦克)"
L["Stagger colors"] = "醉拳颜色设置"
L["Light Stagger"] = "轻度醉拳"
L["Color for Light Stagger."] = "轻度醉拳时的颜色"
L["Moderate Stagger"] = "中度醉拳"
L["Color for Moderate Stagger."] = "中度醉拳时的颜色"
L["Heavy Stagger"] = "重度醉拳"
L["Color for Heavy Stagger."] = "重度醉拳时的颜色"
L["Status: %s\n\nSeverity of Stagger on Monk tanks"] = "状态： %s\n\n武僧坦克醉拳的程度"

------------------------------------------------------------------------
--	Others
L["Mouseover"] = "鼠标指向单位"
L["Raid Icon"] = "团队标记"
L["Role"] = "副本职责"
L["Hide in combat"] = "战斗时隐藏"


------------------------------------------------------------------------
-- Warbaby
L["Icon X offset"] = "横向偏移量"
L["Adjust the offset of the X-axis for center icon."] = "调整中心图标距离中心点的横坐标偏移量，左侧为负值，右侧为正值"
L["Icon Y offset"] = "纵向偏移量"
L["Adjust the offset of the Y-axis for center icon."] = "调整中心图标距离中心点的纵向偏移量，上方为正值，下方为负值"
L["Force Layout"] = "强制布局（此项选'无', 才按照组队情况布局）"
L["Options for Indicator %s"] = "配置'%s'的样式"
