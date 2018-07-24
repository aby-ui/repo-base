local L = LibStub("AceLocale-3.0"):NewLocale("TipTac", "zhCN")
if not L then return end 
-- TipTacOptions.lua
-- DropDown Lists		
L["|cffffa0a0None"] = "|cffffa0a0无";
L["Outline"] = "轮廓";
L["Thick Outline"] = "粗轮廓";
L["Normal Anchor"] = "常规锚点";
L["Mouse Anchor"] = "鼠标锚点";
L["Parent Anchor"] = "父锚点";
L["Top"] = "上部";
L["Top Left"] = "左上";
L["Top Right"] = "右上";
L["Bottom"] = "底部";
L["Bottom Left"] = "左下";
L["Bottom Right"] = "右下";
L["Left"] = "左侧";
L["Right"] = "右侧";
L["Center"] = "中间";
--L["|cffffa0a0None"] = "|cffffa0a0无";
L["Percentage"] = "百分比";
L["Current Only"] = "仅当前";
L["Values"] = "数值";
L["Values & Percent"] = "数值 & 百分比";
L["Deficit"] = "损失";
-- Options		
-- General		
L["General"] = "常规";
L["Enable TipTac Unit Tip Appearance"] = "启用 TipTac 单位提示外观";
L["Will change the appearance of how unit tips look. Many options in TipTac only work with this setting enabled.\nNOTE: Using this options with a non English client may cause issues!"] = "改变单位提示的外观. 多数 TipTac 选项仅在此设置启用时起作用.\n注意: 在非英文客户端上使用此选项可能导致冲突!";
L["Show DC, AFK and DND Status"] = "显示 离线, 暂离 及 请勿打扰 状态";
L["Will show the <DC>, <AFK> and <DND> status after the player name"] = "在玩家名字后显示 <离线>, <暂离> 及 <请勿打扰> 状态";
L["Show Player Guild Rank Title"] = "显示玩家公会会阶";
L["In addition to the guild name, with this option on, you will also see their guild rank by title"] = "此选项开启时, 除显示工会名称外, 你还将看到他们的公会会阶";
L["Show Who Targets the Unit"] = "看谁把该单位作为目标";
L["When in a raid or party, the tip will show who from your group is targeting the unit"] = "在团队或小队中时, 提示信息将显示你团队中有谁把该单位作为目标";
L["Show Player Gender"] = "显示玩家性别";
L["This will show the gender of the player. E.g. \"85 Female Blood Elf Paladin\"."] = "这将显示玩家的性别. 如 \"85 女性 血精灵 圣骑士\".";
L["Name Type"] = "姓名格式";
L["Name only"] = "仅名字";
L["Use player titles"] = "使用玩家头衔";
L["Copy from original tip"] = "复制自原始提示信息";
L["Mary Sue Protocol"] = "Mary Sue 协议";
L["Show Unit Realm"] = "显示单位服务器";
L["Do not show realm"] = "不显示服务器";
L["Show realm"] = "显示服务器";
L["Show (*) instead"] = "显示 (*) 来代替";
L["Show Unit Target"] = "显示单位目标";
L["Do not show target"] = "不显示目标";
L["First line"] = "首行";
L["Second line"] = "次行";
L["Last line"] = "末行";
L["Targeting You Text"] = "以你为目标时文本";
-- Special		
L["Special"] = "特殊";
L["Tooltip Scale"] = "游戏提示信息缩放";
L["Tip Update Frequency"] = "提示刷新频率";
L["Enable ChatFrame Hover Hyperlinks"] = "启用聊天框悬停显示提示信息";
L["When hovering the mouse over a link in the chatframe, show the tooltip without having to click on it"] = "当鼠标悬停在聊天框中的链接上时, 显示提示信息而不用点击它";
L["Hide Faction Text"] = "隐藏阵营文字";
L["Strips the Alliance or Horde faction text from the tooltip"] = "从提示信息中去除 联盟 或者 部落 阵营文字";
L["Hide Coalesced Realm Text"] = "隐藏 合并服务器 文字";
L["Strips the Coalesced Realm text from the tooltip"] = "从提示信息中去除 合并服务器 文字";
-- Colors		
L["Colors"] = "颜色";
L["Color Guild by Reaction"] = "按反应来对公会进行着色";
L["Guild color will have the same color as the reacion"] = "公会颜色将与反应具有相同颜色";
L["Guild Color"] = "公会颜色";
L["Color of the guild name, when not using the option to make it the same as reaction color"] = "公会名称颜色, 当未使用此选项则使其与公会反应颜色相同";
L["Your Guild Color"] = "你的公会颜色";
L["To better recognise players from your guild, you can configure the color of your guild name individually"] = "为更好辨认来自你公会的玩家, 你可以单独配置你的公会名称的颜色";
L["Race & Creature Type Color"] = "种族 & 生物类型颜色";
L["The color of the race and creature type text"] = "种族及生物类型文本颜色";
L["Neutral Level Color"] = "中立等级颜色";
L["Units you cannot attack will have their level text shown in this color"] = "你无法攻击的单位的等级将显示为此颜色";
L["Color Player Names by Class Color"] = "玩家姓名按职业颜色着色";
L["With this option on, player names are colored by their class color, otherwise they will be colored by reaction"] = "此选项开启时, 玩家姓名将按他们的职业颜色着色, 除非他们被按反应着色";
L["Color Tip Border by Class Color"] = "提示边框按职业颜色着色";
L["For players, the border color will be colored to match the color of their class\nNOTE: This option is overridden by reaction colored border"] = "对于玩家, 边框颜色将被着色来匹配他们的职业\n注意：此选项可能会被阵营颜色屏蔽";
-- Reactions		
L["Reactions"] = "反应";
L["Show the unit's reaction as text"] = "以文本显示单位反应";
L["With this option on, the reaction of the unit will be shown as text on the last line"] = "当此选项开启, 单位反应将以文本形式显示在末行";
L["Tapped Color"] = "已被接触颜色";
L["Hostile Color"] = "敌对颜色";
L["Caution Color"] = "警告颜色颜色";
L["Neutral Color"] = "中立颜色";
L["Friendly NPC or PvP Player Color"] = "友好 NPC 或 PVP 玩家颜色";
L["Friendly Player Color"] = "友好玩家颜色";
L["Dead Color"] = "死亡颜色";
-- BG Color		
L["BG Color"] = "背景颜色";
L["Color backdrop based on the unit's reaction"] = "背景基于单位反应着色";
L["If you want the tip's background color to be determined by the unit's reaction towards you, enable this. With the option off, the background color will be the one selected on the 'Backdrop' page"] = "如果你想提示信息的背景颜色由单位对你的反应来决定, 启用这个. 关闭选项时, 背景颜色将为'背景'页面选中的";
L["Color border based on the unit's reaction"] = "边框基于单位反应着色";
L["Same as the above option, just for the border\nNOTE: This option overrides class colored border"] = "与上一选项相同, 只对边框起作用\n注意: 此选项禁用职业着色边框";
-- L["Tapped Color"] = "已被接触颜色";
-- L["Hostile Color"] = "敌对颜色";
-- L["Caution Color"] = "警告颜色颜色";
-- L["Neutral Color"] = "中立颜色";
-- L["Friendly NPC or PvP Player Color"] = "友好 NPC 或 PVP 玩家颜色";
-- L["Friendly Player Color"] = "友好玩家颜色";
-- L["Dead Color"] = "死亡颜色";
-- Backdrop		
L["Backdrop"] = "背景";
L["Background Texture"] = "背景材质";
L["Border Texture"] = "边框材质";
L["Backdrop Edge Size"] = "背景边缘尺寸";
L["Backdrop Insets"] = "背景嵌入";
L["Tip Background Color"] = "提示背景颜色";
L["Tip Border Color"] = "提示边框颜色";
L["Show Gradient Tooltips"] = "显示渐变提示";
L["Display a small gradient area at the top of the tip to add a minor 3D effect to it. If you have an addon like Skinner, you may wish to disable this to avoid conflicts"] = "在提示信息顶部显示一个小的渐变区域来增加些许3D效果. 如果你有类似 Skinner 的插件, 你可以禁用此选项以避免冲突";
L["Gradient Color"] = "渐变颜色";
L["Select the base color for the gradient"] = "选择渐变的基本颜色";
-- Font		
L["Font"] = "字体";
L["Modify the GameTooltip Font Templates"] = "修改提示信息字体模板";
L["For TipTac to change the GameTooltip font templates, and thus all tooltips in the User Interface, you have to enable this option.\nNOTE: If you have an addon such as ClearFont, it might conflict with this option."] = "要使用 TipTac 改变游戏提示信息字体模板, 以及所有玩家界面的提示信息, 你需要启用此选项.\n注意: 如果你有类似 ClearFont 的插件, 也许会与此选项冲突.";
L["Font Face"] = "字体名称";
L["Font Flags"] = "字体标志";
L["Font Size"] = "字体尺寸";
L["Font Size Delta"] = "字体尺寸变化";
-- Classify		
L["Classify"] = "分类";
L["Minus"] = "负面";
L["Trivial"] = "琐碎";
L["Normal"] = "普通";
L["Elite"] = "精英";
L["Boss"] = "首领";
L["Rare"] = "稀有";
L["Rare Elite"] = "稀有精英";
-- Fading		
L["Fading"] = "渐隐";
L["Override Default GameTooltip Fade"] = "禁用默认提示信息渐隐";
L["Overrides the default fadeout function of the GameTooltip. If you are seeing problems regarding fadeout, please disable."] = "禁用默认提示信息渐隐功能. 如果你发现渐隐的问题, 请禁用.";
L["Prefade Time"] = "退色时间";
L["Fadeout Time"] = "渐隐时间";
L["Instantly Hide World Frame Tips"] = "立刻隐藏世界框体提示";
L["This option will make most tips which appear from objects in the world disappear instantly when you take the mouse off the object. Examples such as mailboxes, herbs or chests.\nNOTE: Does not work for all world objects."] = "此选项将在你的鼠标离开世界单位后使来自该单位的提示立刻消失. 例如邮箱, 草药或箱子.\n注意: 不对所有世界单位起作用.";
-- Bars		
L["Bars"] = "状态条";
-- L["Font Face"] = "字体名称";
-- L["Font Flags"] = "字体标志";
-- L["Font Size"] = "字体尺寸";
L["Bar Texture"] = "状态条材质";
L["Bar Height"] = "状态条高度";
-- Bar Types		
L["Bar Types"] = "状态条类型";
L["Hide the Default Health Bar"] = "隐藏默认生命条";
L["Check this to hide the default health bar"] = "选中则隐藏默认生命条";
L["Show Condensed Bar Values"] = "显示简化状态条数值";
L["You can enable this option to condense values shown on the bars. It does this by showing 57254 as 57.3k as an example"] = "你可以启用此选项来简化显示在状态条上的数值. 例如它通过显示 57254 为 57.3k 来运作";
L["Condense Type"] = "简化类型";
L["k/m/g"] = "k/m/g";
L["Wan/Yi"] = "万/亿";
L["Show Health Bar"] = "显示生命条";
L["Will show a health bar of the unit."] = "显示单位生命条.";
L["Health Bar Text"] = "生命条文字";
L["Class Colored Health Bar"] = "生命条按职业着色";
L["This options colors the health bar in the same color as the player class"] = "此选项按玩家职业颜色对生命条着色";
L["Health Bar Color"] = "生命条颜色";
L["The color of the health bar. Has no effect for players with the option above enabled"] = "生命条颜色. 当上面的选项启用时对玩家无效";
L["Show Mana Bar"] = "显示法力条";
L["If the unit has mana, a mana bar will be shown."] = "如果单位有法力, 将显示法力条.";
L["Mana Bar Text"] = "法力条文字";
L["Mana Bar Color"] = "法力条颜色";
L["The color of the mana bar"] = "法力条颜色";
L["Show Energy, Rage, Runic Power or Focus Bar"] = "显示能量, 怒气, 符文能量或集中值条";
L["If the unit uses either energy, rage, runic power or focus, a bar for that will be shown."] = "如果单位使用能量, 怒气, 符文能量或集中值, 将显示状态条.";
L["Power Bar Text"] = "能量条文字";
-- Auras		
L["Auras"] = "光环";
L["Put Aura Icons at the Bottom Instead of Top"] = "放置光环图标在底部而不是顶部";
L["Puts the aura icons at the bottom of the tip instead of the default top"] = "放置光环图标在提示底部而不是默认顶部";
L["Show Unit Buffs"] = "显示单位增益";
L["Show buffs of the unit"] = "显示单位的增益效果";
L["Show Unit Debuffs"] = "显示单位减益";
L["Show debuffs of the unit"] = "显示单位减益效果";
L["Only Show Auras Coming from You"] = "仅显示来自你的光环";
L["This will filter out and only display auras you cast yourself"] = "这将过滤并仅显示你自己施放的光环";
L["Aura Icon Dimension"] = "光环图标尺寸";
L["Max Aura Rows"] = "最大光环行数";
L["Show Cooldown Models"] = "显示冷却模型";
L["With this option on, you will see a visual progress of the time left on the buff"] = "此选项开启时, 你将看见一个增益剩余时间的可视进程";
L["No Cooldown Count Text"] = "无冷却计时文字";
L["Tells cooldown enhancement addons, such as OmniCC, not to display cooldown text"] = "告诉冷却增强类插件, 例如 OmniCC, 不显示冷却文字";
-- Icon		
L["Icon"] = "图标";
L["Show Raid Icon"] = "显示团队图标";
L["Shows the raid icon next to the tip"] = "在提示旁显示团队图标";
L["Show Faction Icon"] = "显示阵营图标";
L["Shows the faction icon next to the tip"] = "在提示旁显示阵营图标";
L["Show Combat Icon"] = "显示战斗图标";
L["Shows a combat icon next to the tip, if the unit is in combat"] = "如果单位在战斗中, 则在提示旁显示战斗图标";
L["Icon Anchor"] = "图标锚点";
L["Icon Dimension"] = "图标尺寸";
-- Anchors		
L["Anchors"] = "锚点";
L["World Unit Type"] = "世界单位类型";
L["World Unit Point"] = "世界单位位置";
L["World Tip Type"] = "世界提示类型";
L["World Tip Point"] = "世界提示位置";
L["Frame Unit Type"] = "框体单位类型";
L["Frame Unit Point"] = "框体单位位置";
L["Frame Tip Type"] = "框体提示类型";
L["Frame Tip Point"] = "框体提示位置";
-- Mouse		
L["Mouse"] = "鼠标";
L["Mouse Anchor X Offset"] = "鼠标锚点 X 偏移";
L["Mouse Anchor Y Offset"] = "鼠标锚点 Y 偏移";
-- Combat		
L["Combat"] = "战斗";
L["Hide All Unit Tips in Combat"] = "战斗时隐藏所有单位提示";
L["In combat, this option will prevent any unit tips from showing"] = "在战斗中, 此选项将阻止任何单位提示显示";
L["Hide Unit Tips for Unit Frames in Combat"] = "战斗时隐藏单位框体的单位提示";
L["When you are in combat, this option will prevent tips from showing when you have the mouse over a unit frame"] = "当你在战斗中时, 当你鼠标悬停在单位框体上时此选项将阻止提示显示";
L["Still Show Hidden Tips when Holding Shift"] = "按住 Shift 时始终显示隐藏的提示";
L["When you have this option checked, and one of the above options, you can still force the tip to show, by holding down shift"] = "当你选中此选项, 及以上选项中的一个, 你仍旧可以通过按住 Shift 强制显示提示";
-- L["Hide Tips in Combat For"] = "战斗时隐藏以下框体提示";
-- L["Unit Frames"] = "单位框体";
-- L["All Tips"] = "所有提示";
-- L["No Tips"] = "无提示";
-- Layouts		
L["Layouts"] = "布局";
L["Layout Template"] = "布局模板";
-- L["Save Layout"] = "保存布局";
-- L["Delete Layout"] = "删除布局";
-- TipTacTalents Support		
L["Talents"] = "天赋";
L["Enable TipTacTalents"] = "启用 TipTacTalents";
L["This option makes the tip show the talent specialization of other players"] = "此选项将使提示显示其他玩家天赋";
L["Only Show Talents for Players in Party or Raid"] = "仅显示小队或团队中玩家的天赋";
L["When you enable this, only talents of players in your party or raid will be requested and shown"] = "当启用此选项, 只有你小队或团队中的玩家的天赋将被查询并显示";
-- L["Talent Format"] = "天赋格式";
-- L["Elemental (57/14/00)"] = "元素 (57/14/00)";
-- L["Elemental"] = "元素";
-- L["57/14/00"] = "57/14/00";
L["Talent Cache Size"] = "天赋缓存大小";
-- TipTacItemRef Support		
L["ItemRef"] = "物品信息";
L["Enable ItemRefTooltip Modifications"] = "启用 ItemRefTooltip 调整";
L["Turns on or off all features of the TipTacItemRef addon"] = "开启或关闭所有 TipTacItemRef 插件的功能";
L["Information Color"] = "信息颜色";
L["The color of the various tooltip lines added by these options"] = "通过这些选项添加的各种提示信息行的颜色";
L["Show Item Tips with Quality Colored Border"] = "显示按质量对边框进行着色的物品提示";
L["When enabled and the tip is showing an item, the tip border will have the color of the item's quality"] = "当启用并且显示物品提示信息时, 提示边框将会有该物品品质的颜色";
L["Show Aura Tooltip Caster"] = "光环提示信息显示施法者";
L["When showing buff and debuff tooltips, it will add an extra line, showing who cast the specific aura"] = "当显示增益和减益提示信息, 将添加额外信息行, 显示谁施放了指定的光环";
L["Show Item Level & ID"] = "显示物品等级 & 编号";
L["For item tooltips, show their itemLevel and itemID"] = "对于物品提示信息, 显示它们的物品等级及物品编号";
L["Show Spell ID & Rank"] = "显示法术编号 & 等级";
L["For spell and aura tooltips, show their spellID and spellRank"] = "对于法术和状态提示信息, 显示它们的法术编号及法术等级";
-- L["Show Currency ID"] = "显示货币编号";
-- L["Currency items will now show their ID"] = "货币物品现在将显示其编号";
-- L["Show Achievement ID & Category"] = "显示成就编号 & 分类";
-- L["On achievement tooltips, the achievement ID as well as the category will be shown"] = "在成就提示信息上, 成就编号将和分类一起显示";
L["Show Quest Level & ID"] = "显示任务等级 & 编号";
L["For quest tooltips, show their questLevel and questID"] = "对于任务提示信息, 显示它们的任务等级及任务编号";
L["Modify Achievement Tooltips"] = "修改成就提示信息";
L["Changes the achievement tooltips to show a bit more information\nWarning: Might conflict with other achievement addons"] = "改变成就提示信息来显示更多一些信息\n警告: 也许会与其它成就插件冲突";
L["Show Icon Texture and Stack Count (when available)"] = "显示图标材质及堆叠数量 (当可用时)";
L["Shows an icon next to the tooltip. For items, the stack count will also be shown"] = "提示信息旁显示图标，如果是物品，还会显示其堆叠数量";

L["Smart Icon Appearance"] = "智能显示图标";
L["When enabled, TipTacItemRef will determine if an icon is needed, based on where the tip is shown. It will not be shown on actionbars or bag slots for example, as they already show an icon"] = "当启用时, TipTacItemRef 将判断是否需要图标, 基于提示信息显示在哪. 例如它将不在动作条或背包栏中显示, 因为它们已经显示了图标";
L["Borderless Icons"] = "无边框图标";
L["Turn off the border on icons"] = "关闭图标边框";
L["Icon Size"] = "图标尺寸";
-- Initialize Frame		
L[" Options"] = " 选项";
L["Anchor"] = "锚点";
L["Defaults"] = "默认";
L["Close"] = "关闭";

-- DropDowns.lua
L["<<YOU>>"] = "<<你>>";
L["-%s "] = "-%s ";
L["~%s "] = "~%s ";
L["%s "] = "%s ";
L["+%s "] = "+%s ";
L["%s|r (Boss) "] = "%s|r (首领) ";
L["%s|r (Rare) "] = "%s|r (稀有) ";
L["+%s|r (Rare) "] = "+%s|r (稀有) ";
L["[YOU]"] = "[你]";
L["Level -%s"] = "等级 -%s";
L["Level ~%s"] = "等级 ~%s";
L["Level %s"] = "等级 %s";
L["Level %s|cffffcc00 Elite"] = "等级 %s|cffffcc00 精英";
L["Level %s|cffff0000 Boss"] = "等级 %s|cffff0000 首领";
L["Level %s|cffff66ff Rare"] = "等级 %s|cffff66ff 稀有";
L["Level %s|cffffaaff Rare Elite"] = "等级 %s|cffffaaff 稀有精英";
L["|cffff0000<<YOU>>"] = "|cffff0000<<YOU>>";
L["|rLevel -%s"] = "|r等级 -%s";
L["|rLevel ~%s"] = "|r等级 ~%s";
L["|rLevel %s"] = "|r等级 %s";
L["|rLevel %s (Elite)"] = "|r等级 %s (精英)";
L["|rLevel %s (Boss)"] = "|r等级 %s (首领)";
L["|rLevel %s (Rare)"] = "|r等级 %s (稀有)";
L["|rLevel %s (Rare Elite)"] = "|r等级 %s (稀有精英)";
L["|cff80ff80Layout Loaded"] = "|cff80ff80布局已载入";
L["|cffff8080Layout Deleted!"] = "|cffff8080布局已删除!";
L["|cff00ff00Pick Layout..."] = "|cff00ff00选择布局...";
L["|cff00ff00Delete Layout..."] = "|cff00ff00删除布局...";

-- AzDropDown.lua
L["|cff00ff00Select Value..."] = "选择数值";

-- core.lua
L["Not specified"] = "未指定";
L["Tapped"] = "已被接触";
L["TipTacAnchor"] = "TipTac锚点";
L["Could not open TicTac Options: |1"] = "无法打开 TicTac 选项: |1";
L["|r. Please make sure the addon is enabled from the character selection screen."] = "|r. 请确定插件已在角色选择界面启动.";
L["The following |2parameters|r are valid for this addon:"] = "以下 |2parameters|r 可用于此插件:";
L[" |2anchor|r = Shows the anchor where the tooltip appears"] = " |2anchor|r = 显示提示信息出现的锚点";
L["Female"] = "女性";
L["Male"] = "男性";
L[" <DC>"] = " <离线>";
L[" <AFK>"] = " <暂离>";
L[" <DND>"] = " <请勿打扰>";
L["\n|cffffd100Targeting: "] = "\n|cffffd100目标: ";
L["Targeted By (|cffffffff%d|r): %s"] = "被以下选中 (|cffffffff%d|r): %s";
L["%.1fWan"] = "%.1f万";
L["%.2fYi"] = "%.2f亿";

L["Enable Battle Pet Tips"] = "启用战斗宠物提示";
L["Will show a special tip for both wild and companion battle pets. Might need to be disabled for certain non-English clients"] = "将为野生和伙伴战斗宠物显示一个特殊的鼠标提示。在非英语客户端中可能需要关闭此选项";
L["Show Class Icon"] = "显示职业图标";
L["For players, this will display the class icon next to the tooltip"] = "如果鼠标提示显示的是一个玩家，则在提示后面显示其职业图标";