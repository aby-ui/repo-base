--[[
	Translations for Ellipsis

	Language: English (Default)
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Ellipsis_Options', 'zhCN')
if not L then return end


-- ------------------------
-- GENERIC STRINGS
-- ------------------------
L.Enabled				= '启用'
L.Appearance			= '外观样式'
L.Colours				= '颜色'


-- ------------------------
-- PROFILE FEEDBACK
-- ------------------------
L.ProfileChanged	= '配置方案更改为: %s'
L.ProfileCopied		= '从 %s 中复制设置'
L.ProfileDeleted	= '删除配置方案: %s'
L.ProfileReset		= '重置方案: %s'


-- ------------------------
-- EXAMPLE AURAS & COOLDOWNS
-- ------------------------
L.SampleUnitHarmful = '一个敌对目标'
L.SampleUnitHelpful	= '一个友方单位'
L.SampleAuraDebuff	= '示例负面效果 %d'
L.SampleAuraBuff	= '示例增益 %d'
L.SampleAuraMinion	= '示例召唤物'
L.SampleAuraTotem	= '示例图腾'
L.SampleAuraGTAoE	= '示例地面AoE'
L.SampleCoolItem	= '示例物品冷却'
L.SampleCoolPet		= '示例宠物冷却'
L.SampleCoolSpell	= '示例法术冷却'

-- ------------------------
-- BASE OPTIONS (Options.lua)
-- ------------------------
L.GeneralHeader			= '一般设置'
L.GeneralControl1Header	= '计时过滤'
L.GeneralControl2Header	= '类型与分组'
L.GeneralControl3Header	= '布局与排序'
L.AuraHeader			= '计时选项'
L.UnitHeader		 	= '单位设置'
L.CooldownHeader		= '冷却选项'
L.NotifyHeader			= '通知选项'
L.AdvancedHeader		= '|cffff8040高级设置'

L.GeneralLocked			= '锁定框体'
L.GeneralLockedDesc		= 'Set whether frames are locked, or unlocked, for positioning, scaling and opacity changes. When unlocked, reference overlays are shown for each display frame to assist in placement.'
L.GeneralExample		= '显示示例效果'
L.GeneralExampleDesc	= 'Spawn a number of example auras and units for testing purposes. If the player is set to be tracked, sample auras will be created for the player as well.\n\nAll sample auras will be dismissed when the options window is closed or using |cffffd200<Shift-Left Click>|r on this button.'
L.GeneralHelpHeader 	= '介绍'
L.GeneralHelp			= '大概意思是说爱不易整合插件很好，推荐大家使用：）详细一点，就是说你可以把不同单位类型的计时条放到不同的"计时条组"中。\n默认是全放到了"计时条组1"里，可以在"类型与分组"里，设置某个单位类型是否显示，以及显示到哪个计时条组中。\n我就不详细翻译了.\n\n|cffffd200Terminology:|r\n|cffffd200Aura|r = Buffs & Debuffs cast by you or your pet\n|cffffd200Unit|r = Yourself, your pet, party members or hostile mobs\n\nAt its core, Ellipsis is there to help keep track of your auras when spread over multiple units, and under the headings to the left are numerous options to customize that display. Most are cosmetic, but you should pay special attention to the |cffffd200Grouping & Tracking|r panel. All auras you cast are attached to the unit they are cast on and these are then seperated into one of 7 groups when displayed. The first 4 groups are based on what the unit is, the 5th is a special case (see The Non-Targeted Unit below), and the last 2 are overrides for your current target and focus to keep them seperate (if desired) from every other displayed unit. Each group can be assigned to any of the 7 available display frames, and multiple groups can be assigned to a single frame.\n\n|cffffd200Example:|r\n|cff67b1e9Assign all harmful units to frame [1], and your target to frame [2] to quickly reference the DoT situation on your current target \'pulled out\' from the mess of all your other DoTs.|r\n\n|cffffd200The Non-Targeted Unit|r\nSome auras exist without any unit to attach themselves to such as temporary minion summons, totems, and ground-targeted AoE spells. These are all grouped together under the special Non-Targeted unit, which is the sole member of the non-targeted group (and can be assigned to a display frame and sorted just like any other unit).'


-- ------------------------
-- CONTROL OPTIONS (ControlOptions.lua
-- ------------------------
L.Control1TimeHeader			= '持续时间限制'
L.Control1TimeMinLimit			= '短于此时间的忽略'
L.Control1TimeMinValue			= '最短持续时间'
L.Control1TimeMinValueDesc		= 'Set the minimum duration (in seconds) an aura can have before it is blocked from display. All auras with a duration less than, or equal to, this value will not be displayed.'
L.Control1TimeMaxLimit			= '长于此时间的忽略'
L.Control1TimeMaxValue			= '最长持续时间'
L.Control1TimeMaxValueDesc		= 'Set the maximum duration (in seconds) an aura can have before it is blocked from display. All auras with a duration greater than, or equal to, this value will not be displayed.'
L.Control1TimeHelp				= '最短和最长时间限制对Ellipsis显示的所有状态计时都有效。除了被动光环，被动光环由下面这个选项决定是否显示：'
L.Control1ShowPassiveAuras		= '显示被动（无持续时间）效果'
L.Control1FilterHeader		= '屏蔽列表限制'
L.Control1FilterUsing			= '   Restrict Auras Using A:'
L.Control1FilterBlacklist		= '黑名单'
L.Control1FilterBlacklistDesc	= 'All auras will be displayed except for those blocked by being added to the blacklist.'
L.Control1FilterWhitelist		= '白名单'
L.Control1FilterWhitelistDesc	= 'No auras will be displayed except for those allowed by being added to the whitelist.'

L.Control1FilterAddBlack			= '要屏蔽的法术ID'
L.Control1FilterAddWhite		= '要添加到白名单的法术ID'
L.Control1FilterAddDesc		= 'Auras must be blacklisted by their SpellID rather than their name. For help finding the ID associated to a spell, you can use the databases on these sites:\n |cffffd100http://www.wowhead.com|r\n |cffffd100http://www.wowdb.com|r\n\nAlternatively, if auras are set to be Interactive (under |cffffd100Aura Configuration|r), you can blacklist an aura after casting it by using <Shift-Right Click> on the aura timer itself.'
L.Control1FilterAddBtn	= '添加到屏蔽列表'

L.Control1FilterListBlack			= '法术黑名单'
L.Control1FilterListWhite		= '法术白名单'
L.Control1FilterListDesc		= 'This is a list of all auras currently blacklisted from display, ordered by their SpellID.\n\nAuras can be removed from the list by selecting them and using the button below.'
L.Control1FilterListRemoveBtn	= '从屏蔽列表中移除'

L.Control2Drop_0 = '隐藏'
L.Control2Drop_1 = '[  |cffffd1001|r  ]'
L.Control2Drop_2 = '[  |cffffd1002|r  ]'
L.Control2Drop_3 = '[  |cffffd1003|r  ]'
L.Control2Drop_4 = '[  |cffffd1004|r  ]'
L.Control2Drop_5 = '[  |cffffd1005|r  ]'
L.Control2Drop_6 = '[  |cffffd1006|r  ]'
L.Control2Drop_7 = '[  |cffffd1007|r  ]'

L.Control2HelpBase			= '选择不同单位类型上的计时条分别显示到哪个"计时条组"：'
L.Control2HelpOverride		= '下面这两个会根据你当前的目标/焦点，优先于上面的规则进行处理。如果布局中"按优先级"选项被启用，它们会有固定的优先级，不可修改。'
L.Control2Display			= '显示到'
L.Control2DisplayDesc		= 'Select the display frame this unit group will be shown in. Multiple groups can be assigned to a single frame.'
L.Control2DisplayCanHide	= 'This unit group can be hidden from display entirely if desired.'
L.Control2DisplayPlayer		= '|cff67b1e9This unit group shows Buffs you, or your pets, cast on yourself.'
L.Control2DisplayPet		= '|cff67b1e9This unit group shows Buffs you, or your pets, cast on themselves.\n\nThis only applies to your actual pet, and not lesser minions such as Wild Imps or Feral Spirits.'
L.Control2DisplayHarmful	= '|cff67b1e9This unit group shows Debuffs you, or your pets, cast on hostile targets.'
L.Control2DisplayHelpful	= '|cff67b1e9This unit group shows Buffs you, or your pets, cast on friendly targets.'
L.Control2DisplayNoTarget	= '|cff67b1e9This special unit group shows effects that don\'t directly target something such as ground-targeted AoEs, totems, and temporary minion summons.'
L.Control2DisplayTarget		= '|cff67b1e9This unit group contains your current target if you have one, and overrides the base group of the unit targeted.\n\nWhen your focus and target are the same unit, the target group has a higher priority and the unit will be displayed as such.'
L.Control2DisplayFocus		= '|cff67b1e9This unit group contains your current focus if you have one, and overrides the base group of the unit targeted.\n\nWhen your focus and target are the same unit, the target group has a higher priority and the unit will be displayed as such.'
L.Control2Priority			= '优先级'
L.Control2PriorityDesc		= '当不同类型同时显示在一个计时条组中时，按优先级决定它们的显示次序.\n\n目标和焦点有固定的优先级，不能修改.'
L.Control2PriorityDisabled	= '当不同类型同时显示在一个计时条组中时，按优先级决定它们的显示次序.\n\n|cffffd100布局与排序|r 中的 |cffffd100按优先级|r 必须启用，才可以调整优先级, 如果未启用，则优先级设置不起任何作用.'

L.Control3DropSort_CREATE_ASC	= '施放次序(正序)'
L.Control3DropSort_CREATE_DESC	= '施放次序(倒序)'
L.Control3DropSort_EXPIRY_ASC	= '剩余时间(正序)'
L.Control3DropSort_EXPIRY_DESC	= '剩余时间(倒序)'
L.Control3DropSort_NAME_ASC		= '名称顺序(正序)'
L.Control3DropSort_NAME_DESC	= '名称顺序(倒序)'
L.Control3DropGrow_DOWN			= '向下'
L.Control3DropGrow_UP			= '向上'
L.Control3DropGrow_LEFT			= '向左'
L.Control3DropGrow_RIGHT		= '向右'
L.Control3DropGrow_CENTER		= '居中'

L.Control3AuraHeader			= '计时条布局与排序'
L.Control3AuraGrowth			= '增长方向'
L.Control3AuraGrowthDesc		= 'Set the direction auras grow from the header of their parent unit.\n\nWhen using the Icon style for auras, the row will continue in the direction specified, extending beyond the width of the unit, unless |cffffd100Wrap|r is enabled which will \'wrap\' displayed auras to a new row once they exceed the width of their unit.'
L.Control3AuraWrapAuras			= '换行'
L.Control3AuraWrapAurasDesc		= 'Set whether auras will wrap to a new row when the width of active auras exceeds the width of their unit.\n\nWhen disabled, auras will extend their row indefinitely in the direction specified by |cffffd100Aura Growth|r.'
L.Control3AuraSorting			= '同单位法术顺序'
L.Control3AuraSortingDesc		= 'Set how auras for each unit are sorted.\n\nWhen sorting by Remaining Time, passive auras will be sorted as if they had the highest duration.'
L.Control3AuraPaddingX			= '计时条间隔(水平)'
L.Control3AuraPaddingXDesc		= 'Set the horizontal padding (seperation) of auras when using the Icon style.'
L.Control3AuraPaddingY			= '计时条间隔(垂直)'
L.Control3AuraPaddingYDesc		= 'Set the vertical padding (seperation) of auras.\n\nWhen using Icon style, this option is also used to provide room for the timer text beneath each aura icon.'
L.Control3UnitHeader			= '单位布局与排序'
L.Control3UnitGrowth			= '增长方向'
L.Control3UnitGrowthDesc		= 'Set the direction units grow from their parent display frame.\n\nThe position of display frames can be changed when the UI is unlocked under the |cffffd100General|r options panel.'
L.Control3UnitSorting			= '单位排序'
L.Control3UnitSortingDesc		= 'Set how units attached to each display frame are sorted.\n\nIf |cffffd100Prioritize|r is enabled, the sorting order is partially overridden as units are sorted by their unit group first, before being sorted by the sorting option chosen.'
L.Control3UnitPrioritize		= '按优先级'
L.Control3UnitPrioritizeDesc	= 'Set whether units should be prioritized by the unit group they belong to. This only applies when multiple groups are assigned to the same display frame.\n\nThe priority order can be configured for all five of the base unit groups shown under |cffffd100Grouping & Tracking|r, the priority for the override groups (target and focus) is always set to come first and cannot be altered.'
L.Control3UnitPaddingX			= '单位间隔(水平)'
L.Control3UnitPaddingXDesc		= 'Set the horizontal padding (seperation) of units.'
L.Control3UnitPaddingY			= '单位间隔(垂直)'
L.Control3UnitPaddingYDesc		= 'Set the vertical padding (seperation) of units.'


-- ------------------------
-- AURA CONFIGURATION (AuraConfiguration.lua)
-- ------------------------
L.AuraDropTooltip_FULL		= '法术说明+帮助'
L.AuraDropTooltip_HELPER	= '帮助信息'
L.AuraDropTooltip_OFF		= '无'
L.AuraDropStyle_BAR			= '计时条'
L.AuraDropStyle_ICON		= '图标'
L.AuraDropTextFormat_AURA	= '法术名'
L.AuraDropTextFormat_UNIT	= '单位名'
L.AuraDropTextFormat_BOTH	= '两者'
L.AuraDropTimeFormat_ABRV	= '缩写'
L.AuraDropTimeFormat_TRUN	= '截断'
L.AuraDropTimeFormat_FULL	= '完整显示'

L.AuraColoursTextHeader			= '文字颜色'
L.AuraColoursText				= '名字 & 时间'
L.AuraColoursStacks				= '叠加层数'
L.AuraColoursWidgetHeader		= '界面颜色 (图标边框 & 计时条)'
L.AuraColoursWidgetGhosting		= '结束后保留'
L.AuraColoursWidgetGhostingDesc	= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura is ghosting.'
L.AuraColoursWidgetHigh			= '剩余超过10秒'
L.AuraColoursWidgetHighDesc		= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura has more than 10 seconds remaining.'
L.AuraColoursWidgetMed			= '剩余5-10秒'
L.AuraColoursWidgetMedDesc		= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura has between 5 and 10 seconds remaining. The colour will gradually change from the \'High\' colour to this one during that time.'
L.AuraColoursWidgetLow			= '剩余低于5秒'
L.AuraColoursWidgetLowDesc		= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura has less than 5 seconds remaining. The colour will gradually change from the \'Medium\' colour to this one as it approaches expiration.'
L.AuraColoursWidgetBarBG		= '计时条背景'
L.AuraColoursWidgetBarBGDesc	= 'Set the colour of the statusbar background visible as the remaining time decreases.'

L.AuraStyle				= '计时方式'
L.AuraStyleDesc			= 'Set the style of displayed auras.\n\nBars style shows a status bar with overlaid spell icon, name and remaining duration. The width of a bar is set by the width of Units, and will always be sorted vertically, above or below, the header of a Unit.\n\nIcon style shows only the spell icon and remaining time beneath it, and can be sorted in several ways beneath the header of a Unit.\n\nOptions for Aura display and sorting are available under...\n|cffffd100General > Layout & Sorting|r.'
L.AuraInteractive		= '交互'
L.AuraInteractiveDesc	= 'Allow individual auras to be announced, cancelled or blacklisted by mouse interaction.\n\nSome Non-Targeted auras cannot be blocked this way and need to be blocked via the Blacklist directly.\n\nDisabling this options allows you to click-through aura timers and select the world behind them.'
L.AuraTooltips			= '鼠标提示'
L.AuraTooltipsDesc		= 'Set how tooltips should be displayed when interacting with auras.\n\nFull:\nShow aura info and helper comments\n\nHelper:\nShow only helper comments\n\nOff:\nDo not display tooltips'
L.AuraBarSize			= '计时条高度'
L.AuraBarSizeDesc		= 'Set the height of an aura when displayed in the Bar style. The width is controlled by the width of Units.'
L.AuraIconSize			= '图标大小'
L.AuraIconSizeDesc		= 'Set the height and width of an aura when displayed in the Icon style.'
L.AuraTimeFormat		= '时间格式'
L.AuraTimeFormatDesc	= 'Set how remaining time should be displayed for each aura.\n\nAbbreviated:\n9.4s  |  9s  |  9m  |  9hr\n\nTruncated:\n9.4  |  9  |  9:09  |  9hr\n\nFull Display:\n9.4  |  9  |  9:09  |  9:09:09'
L.AuraBarTexture		= '计时条材质'
L.AuraBarTextureDesc	= 'Set the texture used for aura bars.'
L.AuraTextFormat		= '名称'
L.AuraTextFormatDesc	= 'Set what an aura\'s name text should display for each aura when in Bar style.\n\nAura:\nShow only the aura\'s name.\n\nUnit:\nShow the aura\'s parent unit name.\n\nBoth:\nShoiw the aura\'s parent unit name followed by the aura\'s name.'
L.AuraFlipIcon			= '图标居右'
L.AuraFlipIconDesc		= 'Set whether to flip the icon to the right side of the statusbar in Bar style.'
L.AuraGhostingHeader	= '状态结束后保留'
L.AuraGhostingDesc		= 'When enabled, auras that expire will \'ghost\' for a set duration before disappearing as a helpful reminder that it is no longer active. When disabled, auras will be removed as soon as they expire.'
L.AuraGhostDuration		= '保留时间'
L.AuraGhostDurationDesc	= 'Set how many seconds a ghost aura should be displayed for.'
L.AuraTextFont			= '名称字体'
L.AuraTextFontSize		= '名称字体大小'
L.AuraTextDesc			= 'Set the font, and the size of the font, to use for display of the spell (or unit) name (only in Bar style) and remaining time.'
L.AuraStacksFont		= '层数字体'
L.AuraStacksFontSize	= '层数字体大小'
L.AuraStacksDesc		= 'Set the font, and the size of the font, to use for display of an aura\'s stacks (if it has any). The stacks counter is always overlaid over the bottom right corner of the spell icon in all styles and only shown if the stack count is two or greater.'


-- ------------------------
-- UNIT CONFIGURATION (UnitConfiguration.lua)
-- ------------------------
L.UnitDropFontStyle_OUTLINE			= '细描边'
L.UnitDropFontStyle_THICKOUTLINE	= '粗描边'
L.UnitDropFontStyle_NONE			= '无'
L.UnitDropColourBy_CLASS			= '单位职业'
L.UnitDropColourBy_REACTION			= '单位阵营'
L.UnitDropColourBy_NONE				= '无 (使用基本颜色)'

L.UnitColoursBaseHeader			= '基本颜色'
L.UnitColoursColourHeader		= '名称行文字颜色'
L.UnitColoursColourHeaderDesc	= 'Colour to use for header text when not colouring units by reaction or class.\n\nAlso used for unknown units (or units with no class) and for the \'Non-Targeted\' special Unit.\n\nNon-Targeted auras include ground-target AoEs, short-term pet summons, totems, etc.'
L.UnitColoursReactionHeader		= '阵营颜色'
L.UnitColoursColourFriendly		= '友好单位'
L.UnitColoursColourHostile		= '敌对单位'

L.UnitWidth					= '单位宽度'
L.UnitWidthDesc				= 'Set the width of displayed units.\n\nWhen auras are displayed in Bar style, this also determines their width as well.\n\nWhen using Icon style and auras are set to \'wrap\', this determines the width at width the wrap occurs.\n\nOptions for Aura display and sorting are available under...\n|cffffd100General > Layout & Sorting|r.'
L.UnitHeaderHeight			= '名称行高度'
L.UnitHeaderHeightDesc		= 'Set the height of the header panel for each unit. This is where descriptive text for each unit is displayed.\n\nThis is always at the top of the unit except when Bar style auras are growing upwards.'
L.UnitOpacityFaded			= '非当前目标透明度'
L.UnitOpacityFadedDesc		= 'Set the opacity of units that are not currently being targeted. This does not include the Non-Targeted special unit.\n\nA setting of 1 will prevent fading out of units that are not currently your target.'
L.UnitOpacityNoTarget		= '无目标技能透明度'
L.UnitOpacityNoTargetDesc	= 'Set the opacity of the Non-Targeted special unit. A setting of 1 will keep the special unit as fully opaque.'
L.UnitHeaderTextHeader		= '单位名称'
L.UnitHeaderTextFont		= '名称行字体'
L.UnitHeaderTextFontSize	= '名称行字体大小'
L.UnitHeaderTextFontStyle	= '名称行字体描边'
L.UnitHeaderTextDesc		= 'Set the font, the size of the font, and the font outline style, to use for display of the unit name and level (if shown).'
L.UnitHeaderColourBy		= '文字颜色'
L.UnitHeaderColourByDesc	= 'Set how to colour the header text displayed for each unit. In the case of class colouring, if the unit has no class (or the class is unknown), the base header colour will be used instead.\n\nBase header colour can be set under...\n|cffffd100Unit Configuration > Colours|r.'
L.UnitHeaderShowLevel		= '显示等级'
L.UnitHeaderShowLevelDesc	= 'Show the unit\'s level in the header text if known.\n\nBosses will be displayed as [B].'
L.UnitStripServer			= '隐藏服务器名'
L.UnitStripServerDesc		= 'Set whether to strip the server from the header text display of player targets.'
L.UnitCollapseAllUnits		= '全部单位'
L.UnitCollapseAllUnitsDesc	= '设置是否隐藏 全部单位 的名称标题行.\n\n如果选中此项，建议在|cffffd100计时选项-名称|r中，选择显示单位名或两者（单位名+法术名）.'
L.UnitCollapseHeader		= '隐藏名称行'
L.UnitCollapsePlayer		= format('自身 (%s)', UnitName('player')) -- show player name to make obvious what we are referring to
L.UnitCollapsePlayerDesc	= 'Set whether to collapse the header (set height to zero), and disable display of header text for the player if being tracked.'
L.UnitCollapseNoTarget		= '无目标技能'
L.UnitCollapseNoTargetDesc	= 'Set whether to collapse the header (set height to zero), and disable display of header text for the special unit that holds non-targeted auras.\n\nNon-Targeted auras include ground-target AoEs, short-term pet summons, totems, etc.'


-- ------------------------
-- COOLDOWN OPTIONS (CooldownOptions.lua)
-- ------------------------
L.CoolItem	= 'ITEM'
L.CoolSpell	= 'SPELL'

L.CoolOnlyWhenTracking		= '必要时才显示'
L.CoolOnlyWhenTrackingDesc	= '仅当至少有一个项目在冷却时，才显示冷却监控条.\n\n否则冷却条将一直显示.'
L.CoolInteractive			= '可点击交互'
L.CoolInteractiveDesc		= 'Allow individual cooldown timers to be announced, cancelled or blacklisted by mouse interaction.\n\nDisabling this options allows you to click-through cooldown timers and select the world behind them. The cooldown bar itself always allows click-through.'
L.CoolTooltips				= '鼠标提示'
L.CoolTooltipsDesc			= 'Set how tooltips should be displayed when interacting with auras.\n\nFull:\nShow aura info and helper comments\n\nHelper:\nShow only helper comments\n\nOff:\nDo not display tooltips'

L.CoolControlHeader			= '冷却监控选项'
L.CoolTrackingHeader		= '监控内容:'
L.CoolTrackItem				= '物品'
L.CoolTrackItemDesc			= 'Enable tracking of item cooldowns.\n\nIncludes both equipped items as well as those in your bags such as potions. Does not include toys.'
L.CoolTrackPet				= '宠物'
L.CoolTrackPetDesc			= 'Enable tracking of your pet\'s ability cooldowns.\n\nThis only includes your actual pet and not temporary minion summons.'
L.CoolTrackSpell			= '玩家'
L.CoolTrackSpellDesc		= 'Enable tracking of your ability and spell cooldowns.\n\nThis includes General abilities such as Revive Battle Pets unless blacklisted.'

L.CoolTimeMinLimit			= '限制最短时间'
L.CoolTimeMinValue			= '最短冷却时间'
L.CoolTimeMinValueDesc		= 'Set the minimum duration (in seconds) a cooldown can have before it is blocked from display. All cooldowns with a duration less than, or equal to, this value will not be displayed.\n\nMinimum duration cannot be disabled and will always have a minimum of 2 seconds to prevent EVERY ability (on the GCD) from being tracked everytime an ability is used.'
L.CoolTimeMaxLimit			= '限制最长时间'
L.CoolTimeMaxValue			= '最长冷却时间'
L.CoolTimeMaxValueDesc		= 'Set the maximum duration (in seconds) a cooldown can have before it is blocked from display. All cooldowns with a duration greater than, or equal to, this value will not be displayed.'

L.CoolBlacklistAdd			= '屏蔽法术或物品ID'
L.CoolBlacklistAddDesc		= 'Cooldowns must be blacklisted by either SpellID or their ItemID rather than their name. For help finding the ID associated to a spell or item, you can use the databases on these sites:\n |cffffd100http://www.wowhead.com|r\n |cffffd100http://www.wowdb.com|r\n\nAlternatively, if cooldowns are set to be Interactive, you can blacklist them directy by using <Shift-Right Click> on the cooldown timer itself.'
L.CoolBlacklistAddItem		= '是物品'
L.CoolBlacklistAddItemDesc	= 'Set whether the ID being blacklisted is an ItemID as opposed to a SpellID.'
L.CoolBlacklistAddButton	= '添加ID'
L.CoolBlacklistList			= '已屏蔽的法术和物品'
L.CoolBlacklistListDesc		= 'This is a list of all cooldowns currently blacklisted from display, ordered first by whether they are items or spells, then by their ItemID or SpellID.\n\nCooldowns can be removed from the list by selecting them and using the button below.'
L.CoolBlacklistRemoveButton	= '从屏蔽列表中移除'

L.CoolHorizontal			= '水平或垂直'
L.CoolHorizontalDesc		= 'Set the orientation of the cooldown bar.\n\nWhen horizontal, cooldowns will countdown towards the left of the bar and towards the bottom when vertical.'
L.CoolTexture				= '冷却条材质'
L.CoolTextureDesc			= 'Set the texture to be used for the cooldown bar. This will be outlined by the backdrop colour as chosen under \n|cffffd100Colours|r.'
L.CoolLength				= '冷却条长度'
L.CoolLengthDesc			= 'Set the largest dimension for the cooldown bar. When horizontal, this will be its width, and its height when vertical.'
L.CoolThickness				= '冷却条宽度'
L.CoolThicknessDesc			= 'Set the smallest dimension for the cooldown bar. When horizontal, this will be its height, and its width when vertical.\n\nThis also sets the size of the cooldown timers themselves.'

L.CoolTimeHeader			= '时间范围与标记'
L.CoolTimeDisplayMax		= '最长表示时间'
L.CoolTimeDisplayMaxDesc	= 'Set the amount of time displayed by the cooldown bar.\n\nAny cooldowns with a duration greater than this value will be anchored to the end of the bar until they are able to start counting down.'
L.CoolTimeDetailed			= '详细的时间标记'
L.CoolTimeDetailedDesc		= 'Set whether to add extra time tags to the timescale display.\n\nThis provides more information as to where cooldowns are on the timescale, but can become overly crowded with higher timescales and short bars.'
L.CoolTimeFont				= '标记字体'
L.CoolTimeFontSize			= '标记字体大小'
L.CoolTimeFontDesc			= 'Set the font, and the size of the font, to use for display of the time tags on the cooldown bar.'

L.CoolOffsetHeader			= '偏移标线模式'
L.CoolOffsetTags			= '启用标线模式'
L.CoolOffsetTagsDesc		= '将冷却图标显示在冷却条之外，使用一条标线在冷却条上显示其精确位置.'
L.CoolOffsetItem			= '物品冷却位置'
L.CoolOffsetPet				= '宠物冷却位置'
L.CoolOffsetSpell			= '玩家冷却位置'
L.CoolOffsetDesc			= 'Set the offset distance for this cooldown group. A setting of 0 will disable the offset for this group.'

L.CoolColoursBase			= '基础冷却颜色'
L.CoolColoursBar			= '冷却条'
L.CoolColoursBackdrop		= '冷却条背景'
L.CoolColoursBackdropDesc	= 'Set the colour of the cooldown bar\'s backdrop. This is only visible if the colour of the bar itself is set to be transparent.'
L.CoolColoursBorder			= '冷却条边框'
L.CoolColoursBorderDesc		= 'Set the colour of the cooldown bar\'s border. This is the outline seen around the cooldown bar itself.'
L.CoolColoursText			= '时间标记文字'

L.CoolColoursGroups			= '冷却内容颜色'
L.CoolColoursGroupsDesc		= 'Set the colour for cooldowns belonging to this group. This sets the colour of the timer icon\'s border as well as the offset spoke if visible.'


-- ------------------------
-- NOTIFICATIONS
-- ------------------------
L.NotifyDropAnnounce_AUTO	= '自动'
L.NotifyDropAnnounce_GROUPS	= '团队或小队'
L.NotifyDropAnnounce_RAID	= '仅团队频道'
L.NotifyDropAnnounce_PARTY	= '仅小队频道'
L.NotifyDropAnnounce_SAY	= '仅"说"'

L.NotifyAnnounceHeader		= '|cffffd100通报:|r'
L.NotifyOutputAnnounce		= '通报到'
L.NotifyOutputAnnounceDesc	= 'Set where announcements from clicking on auras are displayed.\n\nAutomatic sends to raid if in a raid, party if only in a party, or say if ungrouped.\n\nGroup Chat Only sends to raid if in a raid, party if only in a party, or nothing if ungrouped.\n\nThis options requires auras to be set as |cffffd100Interactive|r under |cffffd100Aura Configuration|r.'
L.NotifyAlertHeader			= '警告设置'
L.NotifyAlertAudio			= '声音'
L.NotifyAlertAudioDesc		= 'Play a sound when this alert occurs.\n\nA setting of None can be chosen to disable audio for this alert.'
L.NotifyAlertText			= '文本'
L.NotifyAlertTextDesc		= 'Display a message when this alert occurs. To choose where the message appears, use the output options below.\n\nAll alert messages are displayed in the same output location.'
L.NotifyBrokenAuras			= '法术效果被打破'
L.NotifyBrokenAurasDesc		= 'Enable alerts for when your auras break earlier than they are intended to.\n\nNo alerts will happen if auras break due to their parent unit dying.'
L.NotifyExpiredAuras		= '法术效果结束'
L.NotifyExpiredAurasDesc	= 'Enable alerts for when your auras expire naturally.\n\nNo alerts will happen if auras expire due to their parent unit dying.'
L.NotifyPrematureCool		= '提前冷却完毕'
L.NotifyPrematureCoolDesc	= 'Enable alerts for when your cooldowns complete earlier than expected.\n\nThis is usually caused by an ability cooldown being reset from a proc.'
L.NotifyCompleteCool		= '正常冷却完毕'
L.NotifyCompleteCoolDesc	= 'Enabled alerts for when your cooldowns complete as expected.'

L.NotifyAlertOutput			= '输出警告到'
L.NotifyAlertOutputHeader	= '所有的警告文本提示都会输出到下面所选的位置。列表由Sink库提供，支持暴雪自带的框体/聊天，以及一些流行的插件，例如SCT和MikSBT\n'
L.NotifyAlertSinkHeader		= '|cffffd100输出警告信息到...|r'


-- ------------------------
-- ADVANCED
-- ------------------------
L.AdvancedTickRate = '刷新间隔(毫秒)'
L.AdvancedTickRateDesc = 'Set the rate at which auras will update their display in milliseconds. A lower value will result in smoother updates, but more resource usage with the opposite for higher values.\n\nThe maximum value will use very little resources, but if showing auras in Bar mode, progress will be very jerky.'
