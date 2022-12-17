if not LOCALE_zhCN then return end

local L = select( 2, ...).L

L["New version found (%s). Please visit %s to get the latest version."] = "发现新版本 (%s)。 请访问 %s 下载最新版本。"
L["ABOUT"] = "Cell 受启发于 CompactRaid，但并非其修改版或增强版，而是一个全新的团队框架。\n我个人很喜欢 CompactRaid，并常年使用它，但其作者似乎已经不再更新了。因此我写了 Cell，希望你能喜欢。\n另外，我也参考了一些很棒的团队框架，比如 Aptechka、Grid2 和 VuhDo。\nCell 并不打算成为一个轻量或强大的团队框架插件。设置简单，功能足够，就行了。"
L["RESET"] = "从过旧的版本更新，需要重置Cell。\n|cff22ff22是|r - 重置Cell\n|cffff2222否|r - 我自己搞定"

-------------------------------------------------
-- slash command
-------------------------------------------------
L["Available slash commands"] = "可用的斜杠命令"
L["show Cell options frame"] = "打开Cell选项界面"
L["create a \"Healers\" indicator"] = "创建一个 “Healers” 指示器"
L["reset Cell position"] = "重置Cell位置"
L["These \"reset\" commands below affect all your characters in this account"] = "以下这些“重置”命令会影响该账号下的所有角色"
L["reset all Layouts and Indicators"] = "重置所有布局与指示器"
L["reset all Click-Castings"] = "重置所有点击施法"
L["reset all Raid Debuffs"] = "重置所有副本减益"
L["reset all Cell settings"] = "重置所有Cell设置"

-------------------------------------------------
-- buttons
-------------------------------------------------
L["Options"] = "选项"
L["Raid"] = "团队"

-------------------------------------------------
-- tools
-------------------------------------------------
L["Pull Timer"] = "开怪倒数"
L["You don't have permission to do this"] = "你没有权限这样做"
L["You"] = "你"
L["%s lock %s on %s."] = "%s将%s锁定在%s。"
L["%s unlock %s from %s."] = "%s将%s从%s解锁。"
-- L["Raid Sort"] = "团队排序"
-- L["Raid Roster"] = "团队名单"
L["Alt+Right-Click to remove a player"] = "用 Alt+右键 将玩家从团队中移出"

-------------------------------------------------
-- status text
-------------------------------------------------
L["AFK"] = "暂离"
L["FEIGN"]= "假死"
L["DEAD"] = "死亡"
L["GHOST"] = "鬼魂"
L["OFFLINE"] = "离线"
L["PENDING"] = "待定"
L["ACCEPTED"] = "已接受"
L["DECLINED"] = "已拒绝"
L["DRINKING"] = "喝水"

-------------------------------------------------
-- options
-------------------------------------------------
L["Can't change options in combat"] = "无法在战斗中更改设置"
L["Yes"] = "是"
L["No"] = "否"
L["ON"] = "开"
L["OFF"] = "关"
L["Disabled"] = "禁用"
L["Confirm"] = "确认"

-------------------------------------------------
-- general
-------------------------------------------------
L["General"] = "常规"
L["Blizzard Frames"] = "暴雪框体"
L["Hide Blizzard Party"] = "隐藏暴雪小队"
L["Hide Blizzard Raid"] = "隐藏暴雪团队"
L["Hide Blizzard Frames"] = "隐藏暴雪框体"
L["Require reload of the UI"] = "需要重载界面"
L["Tooltips"] = "鼠标提示"
L["Hide in Combat"] = "战斗中隐藏"
L["Anchored To"] = "对齐到"
L["Unit Button"] = "单位按钮"
L["Cursor"] = "鼠标指针"
L["Cursor Left"] = "指针左侧"
L["Cursor Right"] = "指针右侧"
L["Visibility"] = "可见性"
L["Show Solo"] = "单人时显示"
L["Show while not in a group"] = "当不在队伍时显示"
L["To open options frame, use /cell options"] = "用 /cell options 来打开选项窗口"
L["Show Party"] = "小队时显示"
L["Show while in a party"] = "当在小队时显示"
L["Increase Health Update Rate"] = "增加血条刷新速率"
L["Use CLEU events to increase health update rate"] = "使用战斗记录事件来增加血条刷新速率"
L["Lock Cell Frame"] = "把它给我锁死"
L["Fade Out Menu"] = "淡出菜单"
L["Fade out menu buttons on mouseout"] = "当鼠标移开时淡出菜单按钮"
L["Sort Party By Role"] = "按职责排列小队"
L["Menu Position"] = "菜单位置"

L["Tools"] = "工具"
L["Raid Tools"] = "团队工具"
L["only in group"] = "仅在队伍中"
L["Only show when you have permission to do this"] = "仅在你有权限这样做时显示"
L["ReadyCheck and PullTimer buttons"] = "就位确认 与 开怪倒数 按钮"
L["pullTimerTips"] = "\n|r开怪倒数\n左键单击: |cffffffff开始倒计时|r\n右键单击: |cffffffff取消倒计时|r"
L["readyCheckTips"] = "\n|r就位确认\n左键单击: |cffffffff就位确认|r\n右键单击: |cffffffff职责确认|r"
L["Ready"] = "就位"
L["Pull"] = "倒数"
L["Pull in %d sec"] = "%d秒后开怪"
L["Pull timer cancelled"] = "取消开怪"
L["Marks Bar"] = "标记工具条"
L["Target Marks"] = "目标标记"
L["World Marks"] = "世界标记"
L["Both"] = "全部"
L["marksTips"] = "\n|r目标标记\n左键单击: |cffffffff在目标上设置标记|r\n右键单击: |cffffffff将标记锁定在目标上 (在你的队伍中)|r"
L["Mover"] = "移动框"
L["Unlock"] = "解锁"
L["Lock"] = "锁定"
L["Battle Res Timer"] = "战复计时器"
L["Only show during encounter or in mythic+"] = "仅在首领战或者史诗钥石地下城中显示"
L["BR"] = "战复"
L["HIGH CPU USAGE"] = "高CPU占用"
L["MODERATE CPU USAGE"] = "中等CPU占用"
L["Death Report"] = "死亡通报"
L["Disabled in battlegrounds and arenas"] = "战场与竞技场中将禁用"
L["Report deaths to group"] = "向队伍通报死亡信息"
L["Use |cFFFFB5C5/cell report X|r to set the number of reports during a raid encounter"] = "用 |cFFFFB5C5/cell report X|r 来设定团队战中的通报个数"
L["Current"] = "当前"
L["all"] = "全部"
L["first %d"] = "前 %d 个"
L["Cell will report all deaths during a raid encounter."] = "Cell 将会通报团队战中的全部死亡信息。"
L["Cell will report first %d deaths during a raid encounter."] = "Cell 将会通报团队战中的前 %d 个死亡信息。"
L["A 0-40 integer is required."] = "需要一个0到40的整数。"
L["instakill"] = "秒杀"
L["Buff Tracker"] = "增益检查"
L["Check if your group members need some raid buffs"] = "检查队伍成员是否需要某些团队增益"
L["|cffffb5c5Left-Click:|r cast the spell"] = "|cffffb5c5左键：|r施放技能"
L["|cffffb5c5Right-Click:|r report unaffected"] = "|cffffb5c5右键：|r报告缺少该增益的玩家"
L["Unaffected"] = "未获得此增益"
L["Missing Buff"] = "缺少增益"
L["many"] = "很多"
L["Use |cFFFFB5C5/cell buff X|r to set icon size"] = "用 |cFFFFB5C5/cell buff X|r 来设定图标尺寸"
L["Buff Tracker icon size is set to %d."] = "将增益检查图标的尺寸设置为 %d。"
L["A positive integer is required."] = "需要一个正整数。"

-------------------------------------------------
-- nickname
-------------------------------------------------
L["Nickname Options"] = "昵称选项"
L["Name or Name-Server"] = "角色名 或 角色名-服务器名"
L["Nickname"] = "昵称"
L["My Nickname"] = "我的昵称"
L["Awesome!"] = "太棒了！"
L["Sync Nicknames with Others"] = "与他人同步昵称"
L["Custom Nicknames"] = "自定义昵称"
L["Only visible to me"] = "仅对自己可见"

-------------------------------------------------
-- appearance
-------------------------------------------------
L["Appearance"] = "外观"
L["Texture"] = "材质"
L["Scale"] = "缩放"
L["Non-integer scaling may result in abnormal display of options UI"] = "非整数缩放可能导致选项界面显示不正常"
L["A UI reload is required.\nDo it now?"] = "需要重载界面。\n现在重载么？"
L["Pixel Perfect"] = "像素精确"
L["Options UI Accent Color"] = "选项界面强调色"
L["Options UI Font Size"] = "选项界面字体尺寸"
L["Unit Button Style"] = "单位按钮样式"
L["Power Color"] = "能量颜色"
L["Class Color"] = "职业颜色"
L["Class Color (dark)"] = "职业颜色 (暗)"
L["Gradient"] = "渐变"
L["Custom Color"] = "自定义颜色"
L["Health Bar Color"] = "血条颜色"
L["Health Loss Color"] = "损失血量颜色"
L["Health Bar Alpha"] = "血条透明度"
L["Health Loss Alpha"] = "损失血量透明度"
L["Enable Death Color"] = "启用死亡颜色"
L["Power Color"] = "能量颜色"
L["Power Color (dark)"] = "能量颜色 (暗)"
L["Bar Animation"] = "条动画"
L["Flash"] = "闪光"
L["Smooth"] = "平滑"
L["Target Highlight Color"] = "目标高亮颜色"
L["Mouseover Highlight Color"] = "鼠标指向高亮颜色"
L["Highlight Size"] = "高亮尺寸"
L["Out of Range Alpha"] = "超出距离透明度"
L["Background Alpha"] = "背景透明度"
L["Aura Icon Options"] = "增减益图标选项"
L["Play Icon Animation When"] = "播放图标动画于"
L["+ Stack & Duration"] = "层数与持续时间增加时"
L["+ Stack"] = "层数增加时"
L["Never"] = "从不"
L["Round Up Duration Text"] = "将持续时间文本向上取整"
L["Display One Decimal Place When"] = "持续时间文本显示一位小数于"
L["Color Duration Text"] = "对持续时间文本着色"
L["Heal Prediction"] = "治疗预估"
L["LibHealComm needs to be installed"] = "需要自行安装 LibHealComm"
L["Heal Absorb"] = "治疗吸收"
L["Shield Texture"] = "护盾材质"
L["Overshield Texture"] = "超过血量上限的护盾材质"
L["Reset All"] = "全部重置"
L["[Ctrl+LeftClick] to reset these settings"] = "[Ctrl+左键] 点击此按钮来重置这些设置"

-------------------------------------------------
-- click-castings
-------------------------------------------------
L["Click-Castings"] = "点击施法"
L["Profiles"] = "配置"
L["Use common profile"] = "使用通用配置"
L["Use separate profile for each spec"] = "为每个天赋使用独立配置"
L["Always Targeting"] = "总是选中目标"
L["Only available for Spells"] = "仅对法术有效"
L["Left Spell"] = "左键法术"
L["Any Spells"] = "所有法术"
L["Current Profile"] = "当前配置"
L["Common"] = "通用"
L["Primary Talents"] = "主天赋"
L["Secondary Talents"] = "副天赋"
L["New"] = "新建"
L["Save"] = "保存"
L["Discard"] = "撤销"
L["clickcastingsHints"] = "左键：编辑\n右键：删除"
L["Conflicts Detected!"] = "发现冲突！"
L["Remove"] = "移除"

L["Left"] = "左键"
L["Right"] = "右键"
L["Middle"] = "中键"
L["Button4"] = "侧键4"
L["Button5"] = "侧键5"
L["ScrollUp"] = "滚轮上"
L["ScrollDown"] = "滚轮下"

L["Macro"] = "宏"
L["Spell"] = "法术"
L["target"] = "目标"
L["focus"] = "焦点"
L["assist"] = "协助"
L["togglemenu"] = "菜单"
L["togglemenu_nocombat"] = "菜单（非战斗中）"

L["Target"] = "目标"
L["Focus"] = "焦点"
L["Assist"] = "协助"
L["Menu"] = "菜单"

L["T"] = "天赋"
L["P"] = "PvP天赋"
L["C"] = "职业天赋"
L["S"] = "专精天赋"

L["Edit"] = "编辑"
L["Extra Action Button"] = "额外按键"
L["Action"] = "动作"
L["Shift+Enter: add a new line"] = "Shift+Enter：添加新行"
L["Enter: apply\nESC: discard"] = "Enter：应用\nESC：取消"
L["Press Key to Bind"] = "点击按键以绑定"

-------------------------------------------------
-- layouts
-------------------------------------------------
L["Layouts"] = "布局"
L["Layout"] = "布局"
-- L["Currently Enabled"] = "当前启用"
L["Share"] = "分享"
L["Enable"] = "启用"
L["Rename"] = "重命名"
L["Delete"] = "删除"
L["Rename layout"] = "重命名布局"
L["Create new layout"] = "新建布局"
L["Delete layout"] = "删除布局"
L["Default layout"] = "默认布局"
L["Inherit: "] = "继承："
L["Layout Auto Switch"] = "布局自动切换"
L["Solo/Party"] = "单人/小队"
L["Outdoor"] = "野外"
L["Arena"] = "竞技场"
L["BG 1-15"] = "战场 1-15"
L["BG 16-40"] = "战场 16-40"
L["Group Filter"] = "队伍过滤"
L["Group Arrangement"] = "队伍排列"
L["Orientation"] = "方向"
L["Vertical"] = "纵向"
L["Horizontal"] = "横向"
L["Party"] = "小队"
L["Button Size"] = "按钮尺寸"
L["Pet Button"] = "宠物按钮"
L["Spotlight Button"] = "特别关注按钮"
L["NPC Button"] = "NPC 按钮"
L["Width"] = "宽"
L["Height"] = "高"
L["Power Size"] = "能量条尺寸"
L["Misc"] = "其他"
L["Unit Spacing"] = "单位间距"
L["Group Columns"] = "队伍列数"
L["Group Rows"] = "队伍行数"
L["Group Spacing"] = "队伍间距"
L["Bar Orientation"] = "条方向"
L["Rotate Texture"] = "旋转材质"
L["Friendly NPC Frame"] = "友方 NPC 框体"
L["Other Frames"] = "其他框体"
L["Show NPC Frame"] = "显示 NPC 框体"
L["Separate NPC Frame"] = "分离 NPC 框体"
L["Show friendly NPCs in a separate frame"] = "将友方 NPC 显示在一个单独的框体中"
L["You can move it in Preview mode"] = "你可以在“预览”模式中移动它"
L["Power Bar Filters"] = "能量条过滤"
L["PET"] = "宠物"
L["VEHICLE"] = "载具"
L["Show Party/Arena Pets"] = "显示小队/竞技场宠物"
L["Show Raid Pets"] = "显示团队宠物"
L["Raid Pets"] = "团队宠物"
L["Spotlight Frame"] = "特别关注框体"
L["spotlightTips"] = "左键：|cffffffff菜单|r\n右键：|cffffffff清除|r\n左键拖动：|cffffffff设置为目标单位（非战斗中）|r\n右键拖动：|cffffffff设置为目标单位的宠物（非战斗中）|r"
L["Show units you care about more in a separate frame"] = "将你特别关注的单位显示在一个单独的框体中"
L["Target of Target"] = "目标的目标"
L["Unit"] = "目标单位"
L["Unit's Pet"] = "目标单位的宠物"
L["Clear"] = "清除"
L["Invalid unit."] = "无效单位。"
L["Tip: Every layout has its own position setting"] = "提示：每个布局都有其单独的位置设置"

-------------------------------------------------
-- send/receive
-------------------------------------------------
L["To transfer across realm, you need to be in the same group"] = "跨服传输数据需要在同一个队伍里"
L["It will be renamed if this layout name already exists"] = "如果该布局名已存在，将自动重命名"
L["built-in(s)"] = "内置"
L["custom(s)"] = "自定义"
L["Data transfer failed..."] = "数据传输失败……"
L["Type: "] = "类型："
L["Name: "] = "名称："
L["From: "] = "来自："
L["Request"] = "请求"
L["Cancel"] = "取消"

-------------------------------------------------
-- import/export
-------------------------------------------------
L["Import"] = "导入"
L["Export"] = "导出"
L["Overwrite Layout"] = "覆盖布局"
L["|cff1Aff1AYes|r - Overwrite"] = "|cff1Aff1A是|r - 覆盖"
L["|cffff1A1ANo|r - Create New"] = "|cffff1A1A否|r - 新建"
L["Error"] = "错误"
L["Incompatible Version"] = "版本不兼容"
L["Layout imported: %s."] = "已导入布局：%s。"

-------------------------------------------------
-- indicators
-------------------------------------------------
L["Sync With"] = "同步"
L["Sync Status"] = "同步状态"
L["Indicator Sync"] = "指示器同步"
L["syncTips"] = "在这里设置主布局\n从布局的所有指示器将与主布局完全同步\n这种同步是双向的，但在设置主布局时会导致从布局的所有指示器丢失"
L["All indicators of %s will be replaced with those in %s"] = "%s 布局的所有指示器将被 %s 布局的替换"
L["Indicators"] = "指示器"
L["Preview"] = "预览"
L["Create"] = "创建"
L["Copy"] = "复制"
L["Copy indicators from one layout to another"]= "将指示器从一个布局复制到另一个布局"
L["Custom indicators will not be overwritten, even with same name"] = "即使同名，自定义指示器也不会被覆盖"
L["This may overwrite built-in indicators"] = "这可能会覆盖内置指示器"
L["Close"] = "关闭"
L["From"] = "从"
L["To"] = "到"
L["ALL"] = "全选"
L["INVERT"] = "反选"
L["Indicator Settings"] = "指示器设置"
L["Name Text"] = "名字"
L["Status Text"] = "状态文字"
L["Health Text"] = "血量文字"
L["Status Icon"] = "状态图标"
L["Role Icon"] = "职责图标"
L["Leader Icon"] = "队长图标"
L["Ready Check Icon"] = "就位确认图标"
L["Raid Icon (player)"] = "团队标记 (玩家)"
L["Raid Icon (target)"] = "团队标记 (目标)"
L["Aggro (blink)"] = "仇恨 (闪烁)"
L["Aggro (bar)"] = "仇恨 (条)"
L["Aggro (border)"] = "仇恨 (边框)"
L["Shield Bar"] = "护盾条"
L["AoE Healing"] = "AoE 治疗"
L["External Cooldowns"] = "减伤 (来自他人)"
L["Defensive Cooldowns"] = "减伤 (自身)"
L["Externals + Defensives"] = "减伤 (全部)"
L["Tank Active Mitigation"] = "坦克主动减伤"
L["Dispels"] = "驱散"
L["Debuffs"] = "减益"
L["Targeted Spells"] = "被法术选中"
L["Target Counter"] = "目标计数"
L["Consumables"] = "消耗品"
L["Health Thresholds"] = "血量阈值"

L["Create new indicator"] = "创建新指示器"
L["Rename indicator"] = "重命名指示器"
L["Delete indicator"] = "删除指示器"
L["Buff"] = "增益"
L["Debuff"] = "减益"
L["Buff List"] = "增益列表"
L["Debuff List"] = "减益列表"
L["Spell List"] = "法术列表"
L["Enter spell id"] = "输入法术ID"
L["Invalid"] = "无效"
L["Debuff Filter (blacklist)"] = "减益过滤器 (黑名单)"
L["Big Debuffs"] = "放大显示的减益"
L["Icon"] = "图标"
L["Rect"] = "矩形"
L["Bar"] = "进度条"
L["Text"] = "文本"
L["Icons"] = "图标组"
L["Bars"] = "进度条组"

L["Enabled"] = "启用"
L["Anchor Point"] = "锚点"
L["To UnitButton's"] = "到单位按钮的"
L["To HealthBar's"] = "到血条的"
L["vehicle name"] = "载具名称"
L["Vehicle Name Position"] = "载具名称位置"
L["Status Text Position"] = "状态文字位置"
L["Hide"] = "隐藏"
L["Text Width"] = "文字宽度"
L["Unlimited"] = "无限制"
L["Percentage"] = "百分比"
L["NON-EN"] = "中"
L["EN"] = "英"
L["Name Width / UnitButton Width"] = "名字宽度 / 单位按钮宽度"
L["Font"] = "字体"
L["Font Outline"] = "字体轮廓"
L["Font Size"] = "字体尺寸"
L["Shadow"] = "阴影"
L["Outline"] = "轮廓"
L["Monochrome Outline"] = "单色轮廓"
L["Name Color"] = "名字颜色"
L["Use Custom Textures"] = "使用自定义材质"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["CENTER"] = "中"
L["LEFT"] = "左"
L["RIGHT"] = "右"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["X Offset"] = "X 偏移"
L["Y Offset"] = "Y 偏移"
L["Frame Level"] = "层级"
L["Size"] = "尺寸"
L["Size (Big)"] = "尺寸（大）"
L["Border"] = "边框"
L["Alpha"] = "透明度"
L["Max Icons"] = "最大显示数量"
L["Format"] = "格式"
L["hideFull"] = "当血量满时隐藏"
L["Color"] = "颜色"
L["Remaining Time <"] = "剩余时间 <"
L["sec"] = "秒"
L["Anchor To"] = "定位到"
L["Health Bar"] = "血条"
L["Entire"] = "整体"
L["Solid"] = "纯色"
L["Vertical Gradient"] = "垂直渐变"
L["Horizontal Gradient"] = "水平渐变"
L["Debuff Type"] = "减益类型"
L["Rotation"] = "旋转"
L["Externals + Defensives, no need to enable all of them"] = "包含了来自他人与自身的减伤，不必将它们全都启用"
L["Highlight Type"] = "高亮类型"

L["Click to preview"] = "点击预览"
L["Debug Mode"] = "调试模式"

L["showGroupNumber"] = "显示队伍编号"
L["dispellableByMe"] = "只显示我能驱散的减益"
L["showDuplicate"] = "不隐藏已显示为副本减益的减益"
L["showDispelTypeIcons"] = "显示驱散类型图标"
L["castByMe"] = "只显示我施放的增益"
L["trackByName"] = "匹配法术名称"
L["showDuration"] = "显示持续时间文本"
L["showStack"] = "显示层数文本"
L["Show duration text instead of icon animation"] = "用持续时间文本取代图标动画"
L["enableHighlight"] = "高亮单位按钮"
L["onlyShowTopGlow"] = "仅为优先级最高的减益显示发光效果"
L["circledStackNums"] = "用带圈数字显示层数"
L["Require font support"] = "需要字体支持"
L["showTooltip"] = "显示鼠标提示"
L["This will make these icons not click-through-able"] = "将会使这些图标无法点击穿透"
L["Tooltips need to be enabled in General tab"] = "需要先启用常规页面中的鼠标提示功能"
L["Only one threshold is displayed at a time"] = "同一时间只显示一个阈值"
L["hideDamager"] = "隐藏伤害输出"

L["left-to-right"] = "从左到右"
L["right-to-left"] = "从右到左"
L["top-to-bottom"] = "从上到下"
L["bottom-to-top"] = "从下到上"

L["Leader Icons will hide while in combat"] = "战斗时队长图标将会隐藏"
L["You can config debuffs in %s"] = "你可以在 %s 里设置减益"
L["Indicator settings are part of Layout settings which are account-wide."] = "指示器设置是布局设置的一部分，它们是账号配置而非角色。"
L["The spells list of a icons indicator is unordered (no priority)."] = "图标组指示器的法术列表是无序的（无优先级）。"
L["The priority of spells decreases from top to bottom."] = "法术优先级从上到下递减。"
L["With this indicator enabled, shield / overshield textures are disabled"] = "启用该指示器将会禁用血条上的护盾材质"
L["Check all visible enemy nameplates. Battleground/Arena only."] = "检查所有可见的敌方姓名板。仅在战场、竞技场有效。"
L["cleuAurasTips"] = "通过战斗记录事件匹配不可见的法术效果"
L["raidRosterTips"] = "[右键] 助理，[Alt+右键] 移除。"

L["Would you like Cell to create a \"Healers\" indicator (icons)?"] = "需要 Cell 为你创建一个 “Healers” 指示器（图标组）？"

-------------------------------------------------
-- raid debuffs
-------------------------------------------------
L["Raid Debuffs"] = "副本减益"
L["Show Current Instance"] = "显示当前副本"
L["RAID_DEBUFFS_TIPS"] = "提示：[拖动]减益可以调整顺序，[双击]副本名可以打开地下城手册，[Shift+左键]副本名或首领名可以分享减益，[Alt+左键]副本名或首领名可以重置减益。常规减益的优先级比首领减益的优先级更高。"
-- L["Enable All"] = "全部启用"
-- L["Disable All"] = "全部禁用"
L["Track by ID"] = "匹配法术ID"
L["Condition"] = "条件"
L["Glow Type"] = "发光类型"
L["Glow Color"] = "发光颜色"
L["None"] = "无"
L["Normal"] = "通常"
L["Pixel"] = "像素"
L["Shine"] = "闪耀"
L["Glow Condition"] = "发光条件"
L["Stack"] = "层数"
L["Lines"] = "线条数"
L["Particles"] = "粒子数"
L["Frequency"] = "速度"
L["Length"] = "长度"
L["Thickness"] = "粗细"
L["Create new debuff (id)"] = "创建新减益 (id)"
L["Delete debuff?"] = "删除减益？"
L["Invalid spell id."] = "无效的法术id。"
L["Debuff already exists."] = "减益已存在。"
L["Instance Name"] = "副本名称"
L["Boss Name"] = "首领名称"
L["Current Boss"] = "当前首领"
L["All Bosses"] = "全部首领"
L["No custom debuffs to export!"] = "没有能够导出的减益！"
L["This will overwrite your debuffs"] = "这将覆盖你的副本减益"
L["Raid Debuffs updated: %s."] = "已更新副本减益：%s。"
L["Reset debuffs?"] = "重置减益？"
L["Current Season"] = "当前赛季"

-------------------------------------------------
-- glows
-------------------------------------------------
L["Glows"] = "亮闪闪"
L["Glow"] = "发光"
L["Glow Options"] = "发光选项"
L["Spell Request"] = "让我康康哪个家伙想吃宝宝的大宝剑"
L["Glow unit button when a group member sends a %s request"] = "当队内成员请求%s时高亮其单位按钮"
L["Shows only one spell glow on a unit button at a time"] = "每个单位按钮上同一时间只能显示一个法术高亮"
L["Check If Exists"] = "检查增益是否存在"
L["Do nothing if requested spell/buff already exists on requester"] = "若增益已存在于请求者身上，则不发光"
L["Free Cooldown Only"] = "仅当法术不在冷却时"
L["Known Spells Only"] = "仅限学会的法术"
L["If disabled, no check, no reply, just glow"] = "如禁用，则不检查冷却，也不回复密语，只显示发光"
L["Reply With Cooldown"] = "回复剩余冷却时间"
L["Reply After Cast"] = "施放技能后发送密语"
L["Respond to all requests from group members"] = "响应所有队内成员的请求"
L["Respond to requests that are only sent to me"] = "仅响应对我发出的请求"
L["Respond to whispers"] = "响应密语"
L["Response Type"] = "响应类型"
L["Timeout"] = "超时"
L["Contains"] = "包含"
L["Spells"] = "法术"
L["SPELL"] = "大宝剑"
L["Add"] = "添加"
L["[Alt+LeftClick] to edit"] = "[Alt+左键] 修改"
L["Add new spell"] = "添加新法术"
L["Edit spell"] = "修改法术"
L["SpellId and BuffId are the same in most cases"] = "大部分情况下法术ID与增益ID是相同的"
L["The spell is required to apply a buff on the target"] = "要求添加的法术能够在目标上施加增益效果"
L["Spell already exists."] = "法术已存在。"
L["Delete spell?"] = "删除法术？"
L["Dispel Request"] = "请求驱散"
L["DISPEL"] = "驱散"
L["Dispellable By Me"] = "仅当我能驱散时"
L["Respond to all dispellable debuffs"] = "响应所有的可驱散减益"
L["Respond to specific dispellable debuffs"] = "仅响应指定的可驱散减益"
L["IDs separated by whitespaces"] = "用空格分隔多个法术ID"

-------------------------------------------------
-- about
-------------------------------------------------
L["About"] = "关于"
L["Author"] = "作者"
L["Special Thanks"] = "特别感谢"
L["Patrons"] = "感谢发电"
L["Translators"] = "翻译"
L["Slash Commands"] = "斜杠命令"
L["Bug Report & Suggestion"] = "问题报告与建议"
L["Import & Export All Settings"] = "导入导出所有设置"
L["All Cell settings will be overwritten!"] = "所有 Cell 设置将被覆盖！"
L["Autorun will be disabled for all code snippets"] = "将禁用所有代码片段的自动运行"
L["Include Nickname Settings"] = "包含昵称设置"

-------------------------------------------------
-- code snippets
-------------------------------------------------
L["Code Snippets"] = "代码片段"
L["SNIPPETS_TIPS"] = "[双击]改名，[Shift+左键]删除。所有已勾选的代码片段将会在 Cell 初始化阶段的最后自动执行（即 ADDON_LOADED 事件中）。"
L["Run"] = "执行"
L["unnamed"] = "未命名"

-------------------------------------------------
-- CHANGELOGS
-------------------------------------------------
L["Changelogs"] = "更新记录"
L["Click to view recent changelogs"] = "点击查看近期更新记录"
L["Click to view older changelogs"] = "点击查看远古更新记录"
L["CHANGELOGS"] = [[
    <h1>r151-release (Dec 17, 2022, 10:18 GMT+8)</h1>
    <p>* 更新副本减益：化身巨龙牢窟。</p>
    <p>* 修复唤魔师的距离检查。</p>
    <p>* 修复可驱散检查（当进入副本/战场自动切换天赋时）。</p>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r150-release (Dec 12, 2022, 07:55 GMT+8)</h1>
    <p>* 更新巨龙时代减益。</p>
    <p>* 更新进度条类型的指示器（你可能需要重新设置它们的尺寸与位置）。</p>
    <p>* 更新驱散指示器。</p>
    <p>* 更新距离检查，移除LibRangeCheck。</p>
    <p>* 移除LibHealComm（如果要用，就自行安装独立版本的）。</p>
    <p>* 修复几处bug。</p>
    <br/>

    <h1>r149-release (Nov 29, 2022, 06:35 GMT+8)</h1>
    <p>* 添加 NPC 按钮尺寸选项。</p>
    <p>* 添加条方向选项“纵向 B”。</p>
    <br/>

    <h1>r148-release (Nov 27, 2022, 22:07 GMT+8)</h1>
    <p>* 修复怀旧服的布局自动切换。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r147-release (Nov 27, 2022, 18:02 GMT+8)</h1>
    <p>* 更新布局自动切换，添加了“副本 野外”类型。</p>
    <p>* 添加颜色选项：治疗预估、治疗吸收、护盾材质。</p>
    <p>* 更新状态图标指示器（复活相关）。</p>
    <p>* 更新被法术选中指示器。</p>
    <p>* 更新自定义指示器（进度条/矩形），添加了层数文本。</p>
    <p>* 修复距离检查。</p>
    <p>* 其他异常修复。</p>
    <br/>

    <h1>r146-release (Nov 25, 2022, 05:15 GMT+8)</h1>
    <p>* 更新点击施法。</p>
    <p>* 修复异常。</p>
    <br/>

    <h1>r145-release (Nov 24, 2022, 00:15 GMT+8)</h1>
    <p>* 修复bug。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r144-release (Nov 20, 2022, 05:02 GMT+8)</h1>
    <p>+ 为特别关注框体添加了几个快捷操作。</p>
    <p>* 修复bug。</p>
    <br/>

    <h1>r143-release (Nov 19, 2022, 15:02 GMT+8)</h1>
    <p>* 为唤魔师更新了距离检查（30码）。</p>
    <p>* 修复外观下的重置功能。</p>
    <br/>

    <h1>r142-release (Nov 18, 2022, 03:16 GMT+8)</h1>
    <p>* 选项界面现在可以在战斗中打开了，但并非所有选项都可以在战斗中调整。</p>
    <p>* 更新韩文。</p>
    <br/>

    <h1>r141-release (Nov 16, 2022, 06:17 GMT+8)</h1>
    <p>* 修复怀旧服的鼠标提示。</p>
    <br/>

    <h1>r140-release (Nov 16, 2022, 05:40 GMT+8)</h1>
    <p>* 适配10.0.2，更新鼠标提示相关功能。</p>
    <p>* 更新繁中与韩文。</p>
    <br/>

    <h1>r139-release (Nov 13, 2022, 23:10 GMT+8)</h1>
    <p>* 更新唤魔师法术。</p>
    <p>* 更新斜杠命令。</p>
    <p>* 更新特别关注框体。</p>
    <p>* 更新繁中与韩文。</p>
    <p>* 修复减益的鼠标提示。</p>
    <br/>

    <h1>r138-release (Nov 12, 2022, 04:56 GMT+8)</h1>
    <p>* 更新导入导出。</p>
    <p>* 将“单位间距”分为“单位间距 X”与“单位间距 Y”。</p>
    <p>* 修不完的bug。</p>
    <br/>

    <h1>r137-release (Nov 4, 2022, 18:07 GMT+8)</h1>
    <p>* 为团队宠物与分离的NPC框体添加了移动按钮。</p>
    <p>* 更新繁中。</p>
    <p>* 修bug。</p>
    <br/>

    <h1>r136-release (Nov 2, 2022, 17:59 GMT+8)</h1>
    <p>+ 添加了一个增加血条刷新速率的选项（但不推荐使用）。</p>
    <p>* 好像修复了什么bug，但我忘了。</p>
    <br/>

    <h1>r135-release (Nov 1, 2022, 06:27 GMT+8)</h1>
    <p>* 修复竞技场宠物。</p>
    <p>* 更新巫妖王之怒怀旧服的护盾。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r134-release (Oct 30, 2022, 19:20 GMT+8)</h1>
    <p>+ 被迫添加了团队宠物（最多20个草草草）。</p>
    <p>* 为“职责图标”指示器添加了“隐藏伤害输出”的选项。</p>
    <p>* 修复了几坨bug。</p>
    <br/>
        
    <h1>r133-release (Oct 28, 2022, 05:15 GMT+8)</h1>
    <p>* 修bug。</p>
    <br/>

    <h1>r132-release (Oct 27, 2022, 19:07 GMT+8)</h1>
    <p>+ 新指示器：血量阈值。</p>
    <p>* 更新巨龙时代的部分法术。</p>
    <p>* 修bug。</p>
    <br/>

    <h1>r131-beta (Oct 26, 2022, 18:37 GMT+8)</h1>
    <p>* 巨龙时代临时修复。</p>
    <br/>

    <h1>r130-release (Oct 24, 2022, 22:00 GMT+8)</h1>
    <p>* 小修一下。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r129-release (Oct 22, 2022, 19:37 GMT+8)</h1>
    <p>* 添加了一个用于禁用 LibHealComm 的选项。</p>
    <p>* 将“隐藏暴雪团队/小队”分为了两个选项。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r128-release (Oct 21, 2022, 18:57 GMT+8)</h1>
    <p>* 更新多图标指示器的对其方式，现在支持水平/垂直居中。</p>
    <p>* 为状态文字指示器的每个状态颜色添加了透明度。</p>
    <p>+ 现在可以单独设置特别关注框体的单位按钮尺寸了，在“布局”下的“单位按钮尺寸”的第3页。</p>
    <p>* 更新副本减益。</p>
    <p>* 更新减伤指示器。</p>
    <br/>

    <h1>r127-release (Oct 19, 2022, 02:45 GMT+8)</h1>
    <p>* 修复巫妖王之怒怀旧服的治疗预估（感谢 橘子味橙汁 帮忙发现了问题所在）。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r126-release (Oct 17, 2022, 16:35 GMT+8)</h1>
    <p>* 修复图标的持续时间文本。</p>
    <p>* 为“名字”指示器添加了“显示队伍编号”的选项。</p>
    <p>* 特别关注框体的菜单现在总是显示在屏幕内。</p>
    <p>* 更新“减伤”指示器的默认法术列表。</p>
    <p>* 更新团队名单框体，可以在这里设置助理了。</p>
    <p>* 更新“就位”按钮，右键单击可以进行职责确认。</p>
    <br/>

    <h1>r125-release (Oct 15, 2022, 16:30 GMT+8)</h1>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r124-release (Oct 15, 2022, 15:27 GMT+8)</h1>
    <p>* 修复菜单（选项按钮）的可见性。</p>
    <p>* 更新菜单的淡入淡出。</p>
    <br/>

    <h1>r123-release (Oct 15, 2022, 03:22 GMT+8)</h1>
    <p>* 更新点击施法的默认法术列表。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r122-release (Oct 14, 2022, 04:25 GMT+8)</h1>
    <p>* 修复了点击施法的另一个bug。</p>
    <br/>

    <h1>r121-release (Oct 13, 2022, 14:40 GMT+8)</h1>
    <p>* 修复那啥的bug。</p>
    <br/>

    <h1>r120-release (Oct 12, 2022, 20:45 GMT+8)</h1>
    <p>* 修复点击施法。</p>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r119-release (Oct 12, 2022, 18:10 GMT+8)</h1>
    <p>+ 特别关注框体（新）：可最多设置5个你特别关注的单位。每个单位按钮可以设置为目标、目标的目标、焦点、队伍成员或宠物。</p>
    <p>* 更新点击施法。</p>
    <p>* 更新菜单的淡入淡出。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r118-release (Oct 9, 2022, 23:30 GMT+8)</h1>
    <p>* 更新“增益检查”工具。</p>
    <p>* 尝试修复怀旧服不能选中载具的问题。</p>
    <br/>

    <h1>r117-release (Oct 7, 2022, 10:37 GMT+8)</h1>
    <h2>巫妖王之怒</h2>
    <p>* 更新护盾：护盾条指示器, 护盾材质。仅支持真言术：盾（需要真言术：盾雕文）与神圣庇护（自己施加的）。</p>
    <br/>

    <h1>r116-release (Oct 5, 2022, 00:27 GMT+8)</h1>
    <p>* 更新巫妖王之怒怀旧服中的“治疗预估”（使用 LibHealComm-4.0）。</p>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r115-release (Oct 2, 2022, 07:35 GMT+8)</h1>
    <p>* 更新指示器：驱散，消耗品。</p>
    <p>* 更新繁中。</p>
    <p>* 修复怀旧服的消耗品指示器。</p>
    <br/>

    <h1>r114-release (Oct 1, 2022, 04:00 GMT+8)</h1>
    <p>+ 新指示器：消耗品（虽然叫这个名字，但也可以追踪其他法术。使用调试模式来寻找ID，因为这个ID可能与法术/物品的ID不一致）。</p>
    <p>* 更新指示器：AoE 治疗，被法术选中，减益。</p>
    <p>* 更新繁中。</p>
    <h2>正式服</h2>
    <p>* 修复通过战斗记录事件匹配的法术效果和法师的镜像。</p>
    <h2>巫妖王之怒</h2>
    <p>* 更新副本减益。</p>
    <br/>

    <h1>r113-release (Sep 22, 2022, 16:30 GMT+8)</h1>
    <p>* 修复“减伤”指示器的自定义法术功能。</p>
    <h2>正式服</h2>
    <p>+ 实现了通过战斗记录匹配不可见法术效果的功能（详见“副本减益”指示器）。</p>
    <h2>巫妖王之怒</h2>
    <p>* 更新副本减益。</p>
    <p>* 修复血条颜色。</p>
    <br/>

    <h1>r112-release (Sep 11, 2022, 19:00 GMT+8)</h1>
    <p>* 减伤指示器现在支持添加自定义法术。</p>
    <p>* 将法师的镜像加入减伤指示器。</p>
    <p>* 将 Cell 的默认材质加入到 LibSharedMedia，这样你就可以在其他插件中用这个材质啦。</p>
    <h2>巫妖王之怒</h2>
    <p>* 更新副本减益。</p>
    <p>* 当职责不正确的情况下强制显示能量条。</p>
    <br/>

    <h1>r111-release (Sep 3, 2022, 12:07 GMT+8)</h1>
    <p>* 修复游戏版本检查。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r110-release (Sep 1, 2022, 19:50 GMT+8)</h1>
    <p>* 修复“倒数”按钮。</p>
    <p>* 修复部分复选框的鼠标提示。</p>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r109-release (Aug 27, 2022, 03:10 GMT+8)</h1>
    <h2>正式服</h2>
    <p>* 来自其他玩家的“虚弱灵魂”减益将不再可见。</p>
    <p>* 更新当前赛季史诗钥石地下城的相关减益。</p>
    <h2>巫妖王之怒</h2>
    <p>* Cell 基本可以在巫妖王之怒怀旧服中使用了（但并非所有正式服的功能都可用，有些不想做，有些做不了）。</p>
    <br/>

    <p><a href="older">]]..L["Click to view older changelogs"]..[[</a></p>
    <br/>
]]

L["OLDER_CHANGELOGS"] = [[
    <h1>r108-release (Aug 17, 2022, 18:20 GMT+8)</h1>
    <p>* 更新当前赛季史诗钥石地下城的相关减益（感谢 夕曦@NGA 提供的列表）。</p>
    <p>* 修复了几处小问题。</p>
    <br/>

    <h1>r107-release (Aug 6, 2022, 19:50 GMT+8)</h1>
    <p>* 更新了第四赛季相关减益。</p>
    <p>* 在“副本减益”中的版本下拉菜单中添加了“当前赛季”项。</p>
    <br/>

    <h1>r106-beta (Aug 3, 2022, 00:45 GMT+8)</h1>
    <p>* 小修一下。</p>
    <br/>

    <h1>r105-beta (Aug 1, 2022, 23:00 GMT+8)</h1>
    <p>* 移除 LibGroupInSpecT。</p>
    <br/>

    <h1>r104-release (Jun 3, 2022, 20:30 GMT+8)</h1>
    <p>* 仅提升版本号。</p>
    <br/>

    <h1>r103-release (May 11, 2022, 08:10 GMT+8)</h1>
    <p>+ 现在可以自定义选项界面的强调色了（默认是当前职业颜色）。</p>
    <br/>

    <h1>r102-beta (May 8, 2022, 21:45 GMT+8)</h1>
    <p>* 更新副本减益。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r101-beta (May 8, 2022, 06:10 GMT+8)</h1>
    <p>* 更新配置导出。</p>
    <p>* 更新副本减益。</p>
    <p>* 修复名字长度。</p>
    <br/>

    <h1>r100-release (May 7, 2022, 01:07 GMT+8)</h1>
    <p>* Bug 修复。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r99-release (May 5, 2022, 14:10 GMT+8)</h1>
    <p>* 重写“昵称”模块。</p>
    <p>* 为“名字”指示器添加了“层级”。</p>
    <p>* 更新“状态图标”指示器。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r98-release (Apr 24, 2022, 16:10 GMT+8)</h1>
    <p>+ 新增“指示器同步”。</p>
    <p>+ 新增“自定义死亡颜色”。</p>
    <p>* 更新“职责图标”指示器。</p>
    <p>* 降低“仇恨（边框）”指示器的层级，设置为2可以不挡能量条。</p>
    <p>* 更新指示器预览。</p>
    <p>* 更新繁中。</p>
    <p>* 修复了一个从r87持续到r97的bug。</p>
    <br/>

    <h1>r97-release (Apr 19, 2022, 20:10 GMT+8)</h1>
    <p>+ 添加“昵称”（beta）。</p>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r96-release (Apr 19, 2022, 11:55 GMT+8)</h1>
    <p>* 歼灭两只bug。</p>
    <p>* 更新本地化。</p>
    <br/>
    
    <h1>r95-release (Apr 18, 2022, 09:17 GMT+8)</h1>
    <p>+ 添加了“将持续时间文本向上取整”的选项。</p>
    <p>* 更新了自定义“文本”指示器中“持续时间文本”的相关选项。</p>
    <p>* 更新繁中。</p>
    <p>* Bug 退散！</p>
    <br/>

    <h1>r94-release (Apr 17, 2022, 08:10 GMT+8)</h1>
    <p>+ 在“外观”页面中新增“增减益图标选项”。</p>
    <p>+ 为“减益”与“副本减益”指示器添加了“显示鼠标提示”的选项。需要注意的是，启用鼠标提示将会使这些图标无法点击穿透，也就是说它会使你点不到单位按钮。</p>
    <p>* 为“图标”和“图标组”类型的指示器的字体选项添加了“Y 偏移”。</p>
    <p>* 更新繁中。</p>
    <p>* 继续修复bug。</p>
    <br/>

    <h1>r93-release (Apr 16, 2022, 06:45 GMT+8)</h1>
    <p>+ 新指示器：减伤（全部）。</p>
    <p>+ 新自定义指示器类型：材质。</p>
    <p>+ 新增导入导出所有 Cell 设置的功能（在“关于”页面）。</p>
    <p>+ 为“布局自动切换”添加了对史诗团本的支持。</p>
    <p>* 更新繁中。</p>
    <p>* 修复些小问题。</p>
    <br/>

    <h1>r92-release (Apr 12, 2022, 14:30 GMT+8)</h1>
    <p>* 修复血条“渐变”颜色。</p>
    <br/>

    <h1>r91-release (Apr 12, 2022, 08:35 GMT+8)</h1>
    <p>* 修复“被法术选中”指示器。</p>
    <p>* 更新“法术请求”。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r90-release (Apr 11, 2022, 01:10 GMT+8)</h1>
    <p>+ 添加了“菜单位置”选项。</p>
    <p>* 重做“法术请求”模块，旧配置被删除。</p>
    <p>* 修复单位按钮的初始化问题。</p>
    <p>* 更新布局预览。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r89-release (Apr 8, 2022, 09:22 GMT+8)</h1>
    <p>* “法术请求”取代了“能量灌注请求”，更强大，更通用。</p>
    <p>* 修复了些你不知道的bug。</p>
    <p>* 更新本地化。</p>
    <br/>

    <h1>r88-release (Apr 7, 2022, 16:45 GMT+8)</h1>
    <p>* 修复治疗预估与请求发光。</p>
    <br/>

    <h1>r87-release (Apr 7, 2022, 04:40 GMT+8)</h1>
    <h2>工具</h2>
    <p>+ 新增“能量灌注请求”。</p>
    <p>+ 新增“驱散请求”。</p>
    <h2>布局</h2>
    <p>+ 新增“显示 NPC 框体”选项。</p>
    <p>+ 新增“纵向”单位按钮模式。</p>
    <h2>指示器</h2>
    <p>* 添加“显示持续时间文本”选项：减益、减伤。</p>
    <h2>其他</h2>
    <p>* 重写选项界面。</p>
    <p>* 修复 NPC 单位按钮的距离检查。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r86-release (Mar 27, 2022, 15:00 GMT+8)</h1>
    <p>* 为鼠标提示添加了一个“默认”锚点。</p>
    <br/>

    <h1>r85-release (Mar 26, 2022, 18:00 GMT+8)</h1>
    <p>* 修复当缩放不为1时出现的bug。</p>
    <br/>

    <h1>r84-release (Mar 26, 2022, 15:45 GMT+8)</h1>
    <p>+ 完成布局分享功能。</p>
    <p>+ 添加新自定义指示器类型：颜色。</p>
    <p>* 更新副本减益。</p>
    <br/>

    <h1>r83-release (Mar 18, 2022, 13:50 GMT+8)</h1>
    <p>+ 实现指示器的导入/导出。</p>
    <p>* 修复血量文字。</p>
    <br/>

    <h1>r82-release (Mar 16, 2022, 13:20 GMT+8)</h1>
    <p>+ 添加单位按钮淡入/淡出。</p>
    <p>* 更新放大显示的减益。</p>
    <p>* 尝试使用 CLEU 来解决 boss6/7/8 的血量更新问题。（玻璃渣，快来背锅！）</p>
    <br/>

    <h1>r81-release (Mar 12, 2022, 14:00 GMT+8)</h1>
    <p>* 标记工具条：新增纵向布局。</p>
    <p>* 更新初诞者圣墓减益。</p>
    <br/>

    <h1>r80-release (Mar 10, 2022, 17:00 GMT+8)</h1>
    <p>* 修复水平布局下的 NPC 框体。</p>
    <p>+ 新增“分离 NPC 框体”。</p>
    <br/>

    <h1>r79-release (Mar 10, 2022, 10:35 GMT+8)</h1>
    <p>* 更新友方 NPC 显示个数（5 -> 8）。</p>
    <p>* 更新名字宽度选项（可以单独设置中文/英文名字的长度）。</p>
    <br/>

    <h1>r78-release (Mar 9, 2022, 00:45 GMT+8)</h1>
    <p>+ 实现副本减益的导入、导出、重置，具体操作看副本减益页面的提示。</p>
    <p>* 更新初诞者圣墓减益。</p>
    <p>* 更新简中。</p>
    <br/>

    <h1>r77-release (Mar 3, 2022, 8:21 GMT+8)</h1>
    <p>* 修复神牧点击施法的法术列表。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r76-release (Feb 24, 2022, 11:20 GMT+8)</h1>
    <p>+ 更新副本减益：初诞者圣墓。</p>
    <p>* Bug修复：外观预览。</p>
    <br/>

    <h1>r75-release (Feb 17, 2022, 00:22 GMT+8)</h1>
    <h2>外观</h2>
    <p>* 更新按钮高亮尺寸：负值。</p>
    <p>+ 能量颜色：能量颜色 (暗)</p>
    <h2>常规</h2>
    <p>* 更新像素精确：团队工具。</p>
    <p>* 在战场、竞技场中禁用死亡通报。</p>
    <h2>布局</h2>
    <p>* 更新布局创建功能。</p>
    <h2>副本减益</h2>
    <p>+ 新的副本减益分享功能（测试）：shift + 左键点击副本/首领在聊天中发送分享链接。</p>
    <br/>

    <h1>r74-release (Jan 12, 2022, 22:20 GMT+8)</h1>
    <p>* Bug 修复：布局自动切换，血量文字。</p>
    <p>+ 副本减益中新增了“条件”选项。</p>
    <br/>

    <h1>r73-release (Dec 8, 2021, 22:22 GMT+8)</h1>
    <p>* 小修复一下。</p>
    <br/>

    <h1>r72-release (Dec 7, 2021, 15:20 GMT+8)</h1>
    <p>* 修复了“减益”指示器的延迟刷新问题。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r71-release (Nov 30, 2021, 04:15 GMT+8)</h1>
    <p>+ 为自定义文本指示器添加了“用带圈数字显示层数”的选项。</p>
    <p>+ 为状态文字指示器添加了对应状态的颜色选项。</p>
    <p>+ 实现了能量条按职责过滤（布局）。</p>
    <p>* 修复了指示器预览的一些问题。</p>
    <p>* 更新了“减伤（自身）”的默认法术列表。</p>
    <p>* 更新繁中。</p>
    <p>+ Cell 在第一次运行时会询问是否要创建一个包含常用治疗增益的指示器。</p>
    <br/>

    <h1>r70-release (Nov 18, 2021, 09:20 GMT+8)</h1>
    <p>+ 在“外观”中添加了一些新选项。</p>
    <p>+ 为自定义“文本”指示器添加了“显示持续时间”的选项。</p>
    <br/>

    <h1>r69-release (Nov 16, 2021, 09:10 GMT+8)</h1>
    <p>+ 在“外观”中添加了“背景透明度”的选项.</p>
    <p>* 更新“副本减益”指示器，现在可以显示最多3个减益，默认仍然为1，需要手动修改。</p>
    <br/>

    <h1>r68-release (Nov 5, 2021, 22:40 GMT+8)</h1>
    <p>+ 在“外观”中添加了一个“图标动画”的选项。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r67-release (Oct 8, 2021, 02:55 GMT+8)</h1>
    <p>* 修复了些小问题。</p>
    <br/>

    <h1>r66-release (Oct 7, 2021, 23:30 GMT+8)</h1>
    <p>+ 添加了对 Class Colors 插件的支持。</p>
    <p>+ 实现了“总是选中目标”（点击施法）。</p>
    <br/>

    <h1>r65-release (Sep 23, 2021, 10:00 GMT+8)</h1>
    <p>* 修复了些小问题。</p>
    <p>* 更新了“被法术选中”。</p>
    <p>+ 为指示器的法术列表添加了图标。</p>
    <br/>

    <h1>r64-release (Sep 1, 2021, 08:18 GMT+8)</h1>
    <p>* 更新了放大显示的减益、被法术选中、副本减益。</p>
    <br/>

    <h1>r63-release (Aug 24, 2021, 03:06 GMT+8)</h1>
    <p>* 减益黑名单将不再影响其他指示器。</p>
    <p>* 更新了“放大显示的减益”和“副本减益”。</p>
    <br/>

    <h1>r62-release (Aug 20, 2021, 06:05 GMT+8)</h1>
    <p>+ 为指示器添加了“重命名”按钮。</p>
    <p>* 修复了布局自动切换（战场&amp;竞技场）。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r61-release (Aug 16, 2021, 22:30 GMT+8)</h1>
    <p>+ 新指示器：仇恨 (边框)。</p>
    <p>* 重命名指示器：仇恨指示器 -> 仇恨 (闪烁), 仇恨条 -> 仇恨 (条)。</p>
    <p>* 更新了简中、繁中。</p>
    <br/>

    <h1>r60-release (Aug 16, 2021, 04:08 GMT+8)</h1>
    <p>+ 为“图标组”指示器添加了法术ID“0”，能够匹配所有增减益。</p>
    <p>+ 添加了“宠物按钮尺寸”的选项。</p>
    <p>* 更新了小队框体的单位ID，它们现在应该更加可靠了。</p>
    <p>* 更新了指示器的锚点。</p>
    <p>* 更新了“死亡通报”、“补Buff提示”和“被法术选中”。</p>
    <br/>

    <h1>r59-release (Aug 7, 2021, 18:23 GMT+8)</h1>
    <p>* 新增了“复制指示器”相关功能。</p>
    <p>* 更新了“布局自动切换”。</p>
    <p>* 更新了“副本减益”、“被法术选中”、“死亡通报”。</p>
    <br/>

    <h1>r58-release (Jul 26, 2021, 18:25 GMT+8)</h1>
    <p>* 更新对 OmniCD 的支持，现在也支持团队模式啦。</p>
    <p>* 更新了繁中、韩文。</p>
    <br/>

    <h1>r57-release (Jul 26, 2021, 00:52 GMT+8)</h1>
    <p>+ 新功能：死亡通报 &amp; 补buff提示。</p>
    <p>* 更新了副本减益。</p>
    <br/>

    <h1>r56-release (Jul 16, 2021, 01:20 GMT+8)</h1>
    <p>* 更新了“被法术选中”和“放大显示的减益”。</p>
    <p>* 修复了单位按钮的边框。</p>
    <p>* 修复了“死亡”状态文字。</p>
    <br/>

    <h1>r55-release (Jul 13, 2021, 17:35 GMT+8)</h1>
    <p>* 更新副本减益（塔扎维什）。</p>
    <p>* 更新放大显示的减益（折磨词缀相关）。</p>
    <p>* 修复了选项框体中按钮背景的尺寸。</p>
    <br/>

    <h1>r54-release (Jul 9, 2021, 01:49 GMT+8)</h1>
    <p>* 修复了战复计时器。</p>
    <br/>

    <h1>r53-release (Jul 8, 2021, 16:48 GMT+8)</h1>
    <p>* 更新副本减益（统御圣所）。</p>
    <br/>

    <h1>r52-release (Jul 8, 2021, 5:50 GMT+8)</h1>
    <p>- 从点击施法中移除了一个无效法术: 204293 “灵魂链接”（奶萨pvp天赋）。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r51-release (Jul 7, 2021, 13:50 GMT+8)</h1>
    <p>* 更新Cell缩放。Cell主框体现在为像素精确，选项框体则不会强行实现像素精确。</p>
    <p>* 更新副本减益列表，现在不全，之后还会更新。</p>
    <br/>
    
    <h1>r50-release (May 1, 2021, 03:20 GMT+8)</h1>
    <h2>指示器</h2>
    <P>+ 新指示器：状态图标，目标计数（仅战场、竞技场）。</P>
    <P>+ 新指示器功能：放大显示减益（减益指示器）。</P>
    <p>* 增加了最大图标数量：减益，自定义指示器。</p>
    <p>* 缩小了驱散高亮的尺寸。</p>
    <h2>其他</h2>
    <p>* 修复了一个Cell的缩放问题。</p>
    <p>* 再次修复战复计时器的位置。</p>
    <p>+ 为字体轮廓添加了“无”的选项。</p>
    <br/>

    <h1>r49-release (Apr 5, 2021, 16:10 GMT+8)</h1>
    <p>+ 在外观中添加了“条动画”的选项。</p>
    <p>* “血量文字”现在以中文“千、万、亿”显示。</p>
    <br/>

    <h1>r48-release (Apr 1, 2021, 16:03 GMT+8)</h1>
    <p>* 更新了“被法术选中”和“战复计时器”。</p>
    <p>* 修复了一些bug（单位按钮的边框背景和尺寸）。</p>
    <br/>

    <h1>r47-release (Mar 24, 2021, 18:30 GMT+8)</h1>
    <p>+ 添加了“高亮尺寸”和“超出距离透明度”的选项。</p>
    <p>- 移除了就位确认高亮。</p>
    <p>* 当勾选“显示持续时间文本”时，图标指示器的持续时间动画将被禁用。</p>
    <br/>

    <h1>r46-release (Mar 16, 2021, 9:25 GMT+8)</h1>
    <p>* 再次修复点击施法（鼠标滚轮）。</p>
    <p>+ 为“减伤”与“减益”指示器添加了“方向”的设定。</p>
    <p>* 更新了鼠标提示的选项。</p>
    <br/>

    <h1>r45-release (Mar 11, 2021, 13:00 GMT+8)</h1>
    <p>* 修复了点击施法（鼠标滚轮）。</p>
    <br/>

    <h1>r44-release (Mar 8, 2021, 12:07 GMT+8)</h1>
    <p>* 修复了战复计时器文字不显示的问题。</p>
    <p>* 更新了“被法术选中”的默认法术列表。</p>
    <p>* 更新了导入&amp;导出。</p>
    <p>* 更新繁中。</p>
    <br/>

    <h1>r43-release (Mar 3, 2021, 2:18 GMT+8)</h1>
    <p>+ 新功能：布局的导入&amp;导出。现在给别人分享你的布局（包含其指示器设置）就方便啦。</p>
    <br/>

    <h1>r42-release (Feb 22, 2021, 17:43 GMT+8)</h1>
    <p>* 修复单位按钮没有更新的问题。</p>
    <br/>

    <h1>r41-release (Feb 21, 2021, 10:23 GMT+8)</h1>
    <p>* 更新“被法术选中”指示器，现在它将默认启用。</p>
    <br/>

    <h1>r40-release (Feb 21, 2021, 9:22 GMT+8)</h1>
    <h2>小队框体</h2>
    <p>* 重写小队框体，实现了“按职责排序”的功能。</p>
    <h2>指示器</h2>
    <p>* “减益”指示器不再显示当前“副本减益”所显示的debuff了（索引也一致的情况下）。</p>
    <p>* 修复指示器预览。</p>
    <p>* 修复“被法术选中”指示器。</p>
    <p>* 更新了“减伤”指示器的法术。</p>
    <p>+ 为“副本减益”模块添加了“发光条件”选项（目前仅支持层数）。</p>
    <h2>其他</h2>
    <p>* 修复“点击施法”的一处输入错误。</p>
    <p>+ 添加了“韩文”。</p>
    <br/>

    <h1>r39-release (Jan 22, 2021, 13:24 GMT+8)</h1>
    <h2>指示器</h2>
    <p>+ 新指示器：被法术选中。</p>
    <h2>布局</h2>
    <p>+ 为竞技场布局添加了宠物框体。</p>
    <h2>其他</h2>
    <p>* OmniCD作者即使不添加对Cell的支持，现在也应该能正常工作了。</p>
    <p>! 用 /cell 可以重置Cell。当Cell出现错误时，这多少能有些用。</p>
    <br/>

    <h1>r37-release (Jan 4, 2021, 10:10 GMT+8)</h1>
    <h2>指示器</h2>
    <p>+ 新指示器：名字，状态文字，护盾条。</p>
    <p>+ 为“减益”指示器添加了“只显示我能驱散的减益”的选项。</p>
    <p>+ 为“职责图标”指示器添加了“自定义材质”的相关选项。</p>
    <h2>其他</h2>
    <p>- 由于指示器的变动，一些字体相关选项被移除了。</p>
    <p>* 修复了“战复计时器”的框体宽度。</p>
    <p>+ 添加了对OmniCD的支持（仅小队）。</p>
    <br/>

    <h1>r35-release (Dec 23, 2020, 0:01 GMT+8)</h1>
    <h2>指示器</h2>
    <p>+ 部分内置指示器现在有配置选项了：职责图标，队长图标，就位确认图标，仇恨指示器。</p>
    <p>+ 为“减益 (中间)”添加了“边框”与“仅为当前减益显示高亮效果”的选项。</p>
    <h2>副本减益 (Beta)</h2>
    <p>! 所有减益默认都是启用的，你可能想要禁用一些不那么重要的减益。</p>
    <p>+ 添加了“匹配法术ID”的选项。</p>
    <p>+ 添加了发光效果的详细配置选项。</p>
    <h2>常规</h2>
    <p>* 更新了鼠标提示相关选项。</p>
    <h2>布局</h2>
    <p>+ 在“文字宽度”内添加了“隐藏”选项。</p>
    <br/>

    <h1>r32-release (Dec 10, 2020, 7:29 GMT+8)</h1>
    <h2>指示器</h2>
    <p>+ 新指示器：血量文字。</p>
    <p>+ 新选项：层级。</p>
    <h2>副本减益 (Beta)</h2>
    <p>+ 添加了暗影国度的副本减益。这些减益目前仅匹配法术名称，之后会添加“匹配法术ID”的选项。</p>
    <p>! 所有减益默认都是启用的，你可能想要禁用一些不那么重要的减益。</p>
    <h2>其他</h2>
    <p>* 已修复：标记工具条，点击施法。</p>
    <p>* 已将“团队构成”文字移至“团队”按钮的鼠标提示中。</p>
    <p>+ 添加了“淡出菜单”的选项。</p>
    <br/>

    <h1>r26-release (Nov 23, 2020, 21:25 GMT+8)</h1>
    <h2>点击施法</h2>
    <p>* 点击施法现在支持键盘与多键鼠标。</p> 
    <p>! 由于代码改动，你可能需要重新设置点击施法的按键绑定。</p>
    <h2>指示器</h2>
    <p>* 指示器法术列表更新了，现在所有自定义指示器将检查法术ID而不是法术名称。</p>
    <p>! 因此，需要重新设置自定义指示器的增减益列表才能使其正常显示。</p>
    <h2>指示器预览透明度</h2>
    <p>+ 你现在可以更改指示器预览中的非当前指示器的透明度了，这下调整指示器应该会比以前方便些。</p>
    <p>! 查看“指示器”页面的右上角的滑动条，你懂的。</p>
    <h2>框体位置</h2>
    <p>* 每个布局现在有独立的位置设置。</p>
    <p>! 以下框体的位置已被重置：Cell主框体、标记、就位倒数。</p>
    <h2>其他</h2>
    <p>+ 新增的小队/团队预览模式可以帮你更方便地调整各种布局啦。</p>
    <p>+ 队伍锚点功能来啦，到 布局 -&gt; 队伍排列 那里看看吧。</p>
    <br/>

    <p><a href="recent">]]..L["Click to view recent changelogs"]..[[</a></p>
    <br/>
]]
