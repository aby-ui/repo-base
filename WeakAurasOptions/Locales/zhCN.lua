if not(GetLocale() == "zhCN") then
  return
end

local L = WeakAuras.L

-- WeakAuras/Options
	L["-- Do not remove this comment, it is part of this trigger: "] = "-- 不要移除这条信息，这是该触发器的一部分。"
	L["% of Progress"] = "% 进度"
	L["%i Matches"] = "%i 符合"
	L["%s Color"] = "%s 颜色"
	--[[Translation missing --]]
	L["%s total auras"] = "%s total auras"
	L["1 Match"] = "1符合"
	L["1. Text"] = "文本"
	L["1. Text Settings"] = "字体设置"
	L["2. Text"] = "文本"
	L["2. Text Settings"] = "字体设置"
	L["A 20x20 pixels icon"] = "一个20x20像素图标"
	L["A 32x32 pixels icon"] = "一个32x32像素图标"
	L["A 40x40 pixels icon"] = "一个40x40像素图标"
	L["A 48x48 pixels icon"] = "一个48x48像素图标"
	L["A 64x64 pixels icon"] = "一个64x64像素图标"
	L["A group that dynamically controls the positioning of its children"] = "一个可以动态控制子元素的位置的群组"
	L["Actions"] = "动作"
	L["Add a new display"] = "添加一个新的显示"
	L["Add Condition"] = "添加条件"
	--[[Translation missing --]]
	L["Add Overlay"] = "Add Overlay"
	--[[Translation missing --]]
	L["Add Property Change"] = "Add Property Change"
	L["Add to group %s"] = "添加到组％s"
	L["Add to new Dynamic Group"] = "新增动态群组"
	L["Add to new Group"] = "新增群组"
	L["Add Trigger"] = "新增触发器"
	L["Addon"] = "插件"
	L["Addons"] = "插件"
	L["Align"] = "对齐"
	L["Allow Full Rotation"] = "允许完全旋转"
	L["Alpha"] = "透明度"
	L["Anchor"] = "锚点"
	L["Anchor Point"] = "锚点指向"
	L["Anchored To"] = "附着于"
	L["And "] = "和"
	L["Angle"] = "角度"
	L["Animate"] = "动画"
	L["Animated Expand and Collapse"] = "动态展开和折叠"
	L["Animates progress changes"] = "动画进度变化"
	L["Animation relative duration description"] = [=[动画的相对持续时间，表示为 分数(1/2)，百分比(50％)，或数字(0.5)。
|cFFFF0000注意：|r 如果没有进度(没有时间事件的触发器,没有持续时间的光环,或其他)，动画将不会播放。
|cFF4444FF举例：|r
如果动画的持续时间设定为 |cFF00CC0010%|r，然后触发的增益时间为20秒，入场动画会播放2秒。
如果动画的持续时间设定为 |cFF00CC0010%|r，然后触发的增益没有持续时间，将不会播放开始动画.]=]
	L["Animation Sequence"] = "动画序列"
	L["Animations"] = "动画"
	L["Apply Template"] = "应用模板"
	L["Arcane Orb"] = "奥术宝珠"
	--[[Translation missing --]]
	L["At a position a bit left of Left HUD position."] = "At a position a bit left of Left HUD position."
	--[[Translation missing --]]
	L["At a position a bit left of Right HUD position"] = "At a position a bit left of Right HUD position"
	L["At the same position as Blizzard's spell alert"] = "跟暴雪的法术警报在同一位置"
	L["Aura Name"] = "光环名称"
	L["Aura Type"] = "光环类型"
	L["Aura(s)"] = "光环"
	L["Aura:"] = "光环："
	L["Auras:"] = "光环："
	L["Auto"] = "自动"
	L["Auto-cloning enabled"] = "启用自动克隆"
	L["Automatic Icon"] = "自动显示图标"
	L["Backdrop Color"] = "背景颜色"
	--[[Translation missing --]]
	L["Backdrop in Front"] = "Backdrop in Front"
	L["Backdrop Style"] = "背景图案类型 "
	L["Background"] = "背景"
	L["Background Color"] = "背景色"
	L["Background Inset"] = "背景内嵌"
	L["Background Offset"] = "背景偏移"
	L["Background Texture"] = "背景材质"
	L["Bar Alpha"] = "条透明度"
	L["Bar Color"] = "条颜色"
	L["Bar Color Settings"] = "图标条颜色设置"
	L["Bar Texture"] = "条材质"
	L["Big Icon"] = "大图标"
	L["Blend Mode"] = "混合模式"
	L["Blue Rune"] = "蓝色符文"
	L["Blue Sparkle Orb"] = "蓝色闪光球"
	L["Border"] = "边框"
	L["Border Color"] = "边框颜色"
	--[[Translation missing --]]
	L["Border in Front"] = "Border in Front"
	L["Border Inset"] = "插入边框"
	L["Border Offset"] = "边框偏移"
	L["Border Settings"] = "边框设置"
	L["Border Size"] = "边框大小 "
	L["Border Style"] = "边框风格"
	L["Bottom Text"] = "底部文字"
	--[[Translation missing --]]
	L["Bracket Matching"] = "Bracket Matching"
	L["Button Glow"] = "按钮发光"
	--[[Translation missing --]]
	L["Can be a name or a UID (e.g., party1). A name only works on friendly players in your group."] = "Can be a name or a UID (e.g., party1). A name only works on friendly players in your group."
	L["Cancel"] = "取消"
	L["Channel Number"] = "频道索引"
	L["Chat Message"] = "聊天讯息"
	L["Check On..."] = "检查..."
	L["Children:"] = "子集"
	L["Choose"] = "选择"
	L["Choose Trigger"] = "选择触发器"
	L["Choose whether the displayed icon is automatic or defined manually"] = "选择显示的图示是自动显示还是手动定义"
	L["Clone option enabled dialog"] = [=[
你已经启用|cFFFF0000自动复制|r。
|cFFFF0000自动复制|r 会让一个图示自动重复来显示多目标的讯息。
直到你把这个图示放在一个|cFF22AA22动态群组|r里，所有被复制的图示都会显示在其它图示的顶端.
你想要让它被放到新的|cFF22AA22动态群组|r的吗？]=]
	L["Close"] = "关闭"
	L["Collapse"] = "折叠"
	L["Collapse all loaded displays"] = "折叠所有载入的图示"
	L["Collapse all non-loaded displays"] = "折叠所有未载入的图示"
	L["Color"] = "颜色"
	--[[Translation missing --]]
	L["color"] = "color"
	--[[Translation missing --]]
	L["Common Options"] = "Common Options"
	L["Compress"] = "压缩"
	--[[Translation missing --]]
	L["Condition %i"] = "Condition %i"
	L["Conditions"] = "条件"
	L["Constant Factor"] = "常数因子"
	L["Control-click to select multiple displays"] = "按住 Control 并点击来选择多种显示"
	L["Controls the positioning and configuration of multiple displays at the same time"] = "同时控制多个图示的位置和设定"
	L["Convert to..."] = "转换为..."
	L["Cooldown"] = "冷却"
	--[[Translation missing --]]
	L["Copy settings..."] = "Copy settings..."
	--[[Translation missing --]]
	L["Copy to all auras"] = "Copy to all auras"
	L["Copy URL"] = "复制 URL"
	L["Count"] = "计数 "
	L["Creating buttons: "] = "创建按钮:"
	L["Creating options: "] = "创建配置:"
	L["Crop"] = "剪裁"
	L["Crop X"] = "裁剪X"
	L["Crop Y"] = "裁剪Y"
	L["Custom"] = "自定义"
	L["Custom Code"] = "自定义代码"
	L["Custom Function"] = "自定义功能"
	L["Custom Trigger"] = "自定义生效触发器"
	L["Custom trigger event tooltip"] = [=[选择用于检查自订触发的事件。
如果有多个事件,可以用逗号或空白分隔。

|cFF4444FF例：|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
	L["Custom trigger status tooltip"] = [=[选择用于检查自订触发的事件。
因为这一个是状态触发器, 指定的事件 可以被 WeakAuras 调用, 而不需指定参数.
如果有多个事件,可以用逗号或空白分隔。

|cFF4444FF例：|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
	L["Custom Untrigger"] = "自定义失效触发器"
	L["Debuff Type"] = "减益类型"
	L["Default"] = "默认"
	L["Delete"] = "删除"
	L["Delete all"] = "删除所有"
	L["Delete children and group"] = "删除子节点和组"
	L["Delete Trigger"] = "删除触发器"
	L["Desaturate"] = "褪色"
	--[[Translation missing --]]
	L["Differences"] = "Differences"
	--[[Translation missing --]]
	L["Disable Import"] = "Disable Import"
	L["Disabled"] = "禁用"
	L["Discrete Rotation"] = "离散旋转"
	L["Display"] = "图示"
	L["Display Icon"] = "图示图标"
	L["Display Text"] = "图示文字"
	L["Displays a text, works best in combination with other displays"] = "显示一条文本，最好与其他显示效果结合运用"
	L["Distribute Horizontally"] = "横向分布"
	L["Distribute Vertically"] = "纵向分布"
	--[[Translation missing --]]
	L["Do not group this display"] = "Do not group this display"
	L["Done"] = "完成"
	L["Down"] = "下"
	L["Drag to move"] = "拖拽来移动"
	L["Duplicate"] = "复制"
	--[[Translation missing --]]
	L["Duplicate All"] = "Duplicate All"
	L["Duration (s)"] = "持续时间"
	L["Duration Info"] = "持续时间讯息"
	L["Dynamic Group"] = "动态群组"
	--[[Translation missing --]]
	L["Dynamic Information"] = "Dynamic Information"
	--[[Translation missing --]]
	L["Dynamic information from first active trigger"] = "Dynamic information from first active trigger"
	L["Dynamic information from Trigger %i"] = "来自触发器%i的动态信息"
	L["Dynamic text tooltip"] = [=[这里有几个特别的编码允许文字动态显示：

|cFFFF0000%p|r - 进度 - 剩余持续时间或非时间值
|cFFFF0000%t|r - 总共 - 总持续时间或最大的非时间值
|cFFFF0000%n|r - 名称 - 图示名称(通常是光环名称)或是没有动态名称图示的编号
|cFFFF0000%i|r - 图标 - 图示关连的显标
|cFFFF0000%s|r - 堆叠 - 光环堆叠数量(通常)
|cFFFF0000%c|r - 自定义 - 允许你自定义一个Lua函数并返回一个用于显示的字符串]=]
	L["Enabled"] = "启用"
	L["End Angle"] = "结束角度"
	L["Enter an aura name, partial aura name, or spell id"] = "键入一个法术名，或者法术ID"
	L["Event"] = "事件"
	L["Event Type"] = "事件类型"
	L["Event(s)"] = "事件（复数）"
	--[[Translation missing --]]
	L["Everything"] = "Everything"
	L["Expand"] = "展开"
	L["Expand all loaded displays"] = "展开所有载入的图示"
	L["Expand all non-loaded displays"] = "展开所有未载入的图示"
	--[[Translation missing --]]
	L["Expansion is disabled because this group has no children"] = "Expansion is disabled because this group has no children"
	L["Export to Lua table..."] = "导出为 Lua 表格..."
	L["Export to string..."] = "导出为字符串"
	L["Fade"] = "淡化"
	L["Fade In"] = "渐入"
	L["Fade Out"] = "渐出"
	--[[Translation missing --]]
	L["False"] = "False"
	L["Finish"] = "结束"
	L["Fire Orb"] = "火焰宝珠"
	L["Font"] = "字体"
	L["Font Flags"] = "字体效果"
	L["Font Size"] = "字体大小"
	L["Font Type"] = "字体类型"
	L["Foreground Color"] = "前景色"
	L["Foreground Texture"] = "前景材质"
	L["Frame"] = "框架"
	L["Frame Strata"] = "框架层级"
	L["From Template"] = "从模板"
	L["Full Scan"] = "完整扫描"
	L["General Text Settings"] = "通用字体设置"
	L["Glow"] = "发光"
	L["Glow Action"] = "发光动作"
	L["Green Rune"] = "绿色符文"
	L["Group"] = "组"
	L["Group (verb)"] = "群组（动态）"
	L["Group aura count description"] = [=[所输入的队伍或团队成员的数量必须给定一个或多个光环作为显示触发的条件。
如果输入的数字是一个整数(如5)，受影响的团队成员数量将与输入的数字相同。
如果输入的数字是一个小数(如0.5)，分数(例如1/ 2)，或百分比(例如50%%)，那么多比例的队伍或团队成员的必须受到影响。
|cFF4444FF举例：|r
|cFF00CC00大于 0|r  会在任意一人受影响时触发
|cFF00CC00等于 100%%|r 会在所有人受影响时触发
|cFF00CC00不等于 2|r 会在2人受影响之外时触发
|cFF00CC00小于等于 0.8|r 会在小于80%%的人受影响时触发
|cFF00CC00大于 1/2|r 会在超过一半以上的人受影响时触发
|cFF00CC00大于等于 0|r 总是触发.]=]
	L["Group Member Count"] = "队伍或团队成员数"
	--[[Translation missing --]]
	L["Group Scale"] = "Group Scale"
	L["Grow"] = "生长"
	L["Hawk"] = "鹰"
	L["Height"] = "高度"
	L["Hide"] = "隐藏"
	L["Hide on"] = "隐藏于"
	L["Hide this group's children"] = "隐藏此组的子节点"
	L["Hide When Not In Group"] = "不在队伍时隐藏"
	L["Horizontal Align"] = "水平对齐"
	L["Horizontal Bar"] = "水平条"
	L["Horizontal Blizzard Raid Bar"] = "水平暴雪团队条"
	L["Huge Icon"] = "巨型图标"
	L["Hybrid Position"] = "混合定位"
	L["Hybrid Sort Mode"] = "混合排序模式"
	L["Icon"] = "图标"
	L["Icon Color"] = "图标颜色"
	L["Icon Info"] = "图标信息"
	L["Icon Inset"] = "项目插入"
	--[[Translation missing --]]
	L["If"] = "If"
	--[[Translation missing --]]
	L["If this option is enabled, you are no longer able to import auras."] = "If this option is enabled, you are no longer able to import auras."
	--[[Translation missing --]]
	L["If Trigger %s"] = "If Trigger %s"
	L["Ignored"] = "被忽略"
	L["Import"] = "导入"
	L["Import a display from an encoded string"] = "从字串导入一个图示"
	L["Inverse"] = "反转"
	--[[Translation missing --]]
	L["Inverse Slant"] = "Inverse Slant"
	L["Justify"] = "对齐"
	--[[Translation missing --]]
	L["Keep Aspect Ratio"] = "Keep Aspect Ratio"
	L["Leaf"] = "叶子"
	--[[Translation missing --]]
	L["Left 2 HUD position"] = "Left 2 HUD position"
	--[[Translation missing --]]
	L["Left HUD position"] = "Left HUD position"
	L["Left Text"] = "左边文字"
	L["Load"] = "载入"
	L["Loaded"] = "已载入"
	--[[Translation missing --]]
	L["Loop"] = "Loop"
	L["Low Mana"] = "低法力值"
	L["Main"] = "主要的"
	L["Manage displays defined by Addons"] = "由插件管理已定义的图示"
	L["Medium Icon"] = "中等图标"
	L["Message"] = "讯息"
	L["Message Prefix"] = "讯息前缀"
	L["Message Suffix"] = "讯息后缀"
	L["Message Type"] = "讯息类型"
	L["Message type:"] = "消息类型："
	L["Mirror"] = "镜像"
	L["Model"] = "模型"
	L["Move Down"] = "向下移"
	--[[Translation missing --]]
	L["Move this display down in its group's order"] = "Move this display down in its group's order"
	--[[Translation missing --]]
	L["Move this display up in its group's order"] = "Move this display up in its group's order"
	L["Move Up"] = "向上移"
	L["Multiple Displays"] = "多个图示"
	L["Multiple Triggers"] = "多触发器"
	L["Multiselect ignored tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777单个|r - |cFF777777多个|r
当图示应该载入时这项设定不应该使用]=]
	L["Multiselect multiple tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777单个|r - |cFF777777多个|r
任何相匹配的值的值可以提取]=]
	L["Multiselect single tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777单个|r - |cFF777777多个|r
只有一个单一的匹配值可以提取]=]
	L["Name Info"] = "名称讯息"
	L["Negator"] = "不"
	L["Never"] = "从不"
	L["New"] = "新增"
	L["No"] = "不"
	--[[Translation missing --]]
	L["No Children"] = "No Children"
	L["No tooltip text"] = "没有提示文字"
	L["None"] = "无"
	L["Not all children have the same value for this option"] = "并非所有子元素都拥有相同的此选项的值"
	L["Not Loaded"] = "未载入"
	L["Offer a guided way to create auras for your class"] = "为你的职业提供创建光环的向导"
	L["Okay"] = "好"
	L["On Hide"] = "图示隐藏时触发"
	L["On Init"] = "于初始时"
	L["On Show"] = "图示显示时触发"
	L["Only match auras cast by people other than the player"] = "只匹配其它玩家施放的光环"
	L["Only match auras cast by the player"] = "只匹配玩家自己施放的光环"
	L["Operator"] = "运算符"
	--[[Translation missing --]]
	L["Options will open after combat ends."] = "Options will open after combat ends."
	L["or"] = "或"
	L["Orange Rune"] = "橙色符文"
	L["Orientation"] = "方向"
	L["Outline"] = "轮廓"
	--[[Translation missing --]]
	L["Overflow"] = "Overflow"
	--[[Translation missing --]]
	L["Overlay %s Info"] = "Overlay %s Info"
	--[[Translation missing --]]
	L["Overlays"] = "Overlays"
	L["Own Only"] = "只来源于自己"
	--[[Translation missing --]]
	L["Paste Action Settings"] = "Paste Action Settings"
	--[[Translation missing --]]
	L["Paste Animations Settings"] = "Paste Animations Settings"
	--[[Translation missing --]]
	L["Paste Condition Settings"] = "Paste Condition Settings"
	--[[Translation missing --]]
	L["Paste Display Settings"] = "Paste Display Settings"
	--[[Translation missing --]]
	L["Paste Group Settings"] = "Paste Group Settings"
	--[[Translation missing --]]
	L["Paste Load Settings"] = "Paste Load Settings"
	--[[Translation missing --]]
	L["Paste Settings"] = "Paste Settings"
	L["Paste text below"] = "在下方粘贴文本"
	--[[Translation missing --]]
	L["Paste Trigger Settings"] = "Paste Trigger Settings"
	L["Play Sound"] = "播放声音"
	L["Portrait Zoom"] = "纵向缩放"
	--[[Translation missing --]]
	L["Position Settings"] = "Position Settings"
	L["Preset"] = "预设"
	L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "阻止刷新光环时持续时间讯息的变动。如果使用了多个光环并且具有不同持续时间那么可能会造成问题。"
	L["Processed %i chars"] = "已处理%i个字符"
	L["Progress Bar"] = "进度条"
	L["Progress Texture"] = "进度条材质"
	L["Purple Rune"] = "紫色符文"
	--[[Translation missing --]]
	L["Put this display in a group"] = "Put this display in a group"
	L["Radius"] = "范围"
	L["Re-center X"] = "到中心 X 偏移"
	L["Re-center Y"] = "到中心 Y 偏移"
	--[[Translation missing --]]
	L["Regions of type \"%s\" are not supported."] = "Regions of type \"%s\" are not supported."
	L["Remaining Time"] = "剩余时间"
	L["Remaining Time Precision"] = "剩余时间精度"
	--[[Translation missing --]]
	L["Remove"] = "Remove"
	--[[Translation missing --]]
	L["Remove this condition"] = "Remove this condition"
	--[[Translation missing --]]
	L["Remove this display from its group"] = "Remove this display from its group"
	--[[Translation missing --]]
	L["Remove this property"] = "Remove this property"
	L["Rename"] = "重命名"
	--[[Translation missing --]]
	L["Repeat After"] = "Repeat After"
	--[[Translation missing --]]
	L["Repeat every"] = "Repeat every"
	--[[Translation missing --]]
	L["Required for Activation"] = "Required for Activation"
	--[[Translation missing --]]
	L["Right 2 HUD position"] = "Right 2 HUD position"
	--[[Translation missing --]]
	L["Right HUD position"] = "Right HUD position"
	L["Right Text"] = "右边文字"
	L["Right-click for more options"] = "右键点击获得更多选项"
	L["Rotate"] = "旋转"
	L["Rotate In"] = "旋转进入"
	L["Rotate Out"] = "旋转退出"
	L["Rotate Text"] = "旋转文字"
	L["Rotation"] = "旋转"
	L["Rotation Mode"] = "旋转模式"
	L["Same"] = "相同"
	L["Scale"] = "缩放"
	L["Search"] = "搜索"
	L["Select the auras you always want to be listed first"] = "选择优先列出的光环"
	L["Send To"] = "发送给"
	--[[Translation missing --]]
	L["Set Parent to Anchor"] = "Set Parent to Anchor"
	--[[Translation missing --]]
	L["Set tooltip description"] = "Set tooltip description"
	--[[Translation missing --]]
	L["Settings"] = "Settings"
	--[[Translation missing --]]
	L["Shift-click to create chat link"] = "Shift-click to create chat link"
	L["Show all matches (Auto-clone)"] = "列出所有符合的(自动复制)"
	L["Show Cooldown Text"] = "显示 CD 文本"
	--[[Translation missing --]]
	L["Show If Unit Is Invalid"] = "Show If Unit Is Invalid"
	L["Show model of unit "] = "显示该单位的模型"
	--[[Translation missing --]]
	L["Show On"] = "Show On"
	--[[Translation missing --]]
	L["Show this group's children"] = "Show this group's children"
	L["Shows a 3D model from the game files"] = "显示游戏文件中的3D模形"
	L["Shows a custom texture"] = "显示自定义材质"
	L["Shows a progress bar with name, timer, and icon"] = "显示一个进度条组件, 它拥有 名称, 时间 和 图标"
	L["Shows a spell icon with an optional cooldown overlay"] = "显示可选的法术图示有冷却时间重叠"
	L["Shows a texture that changes based on duration"] = "显示一个随持续时间而变的材质"
	L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "显示一行或多行文字, 它们包换动态信息, 如进度和叠加层数"
	L["Size"] = "大小"
	--[[Translation missing --]]
	L["Slant Amount"] = "Slant Amount"
	--[[Translation missing --]]
	L["Slant Mode"] = "Slant Mode"
	--[[Translation missing --]]
	L["Slanted"] = "Slanted"
	L["Slide"] = "滑动"
	L["Slide In"] = "滑动"
	L["Slide Out"] = "滑出"
	L["Small Icon"] = "小图标"
	--[[Translation missing --]]
	L["Smooth Progress"] = "Smooth Progress"
	L["Sort"] = "排序"
	L["Sound"] = "声音"
	L["Sound Channel"] = "声道"
	L["Sound File Path"] = "声音文件路径"
	L["Sound Kit ID"] = "音效包ID"
	L["Space"] = "间隙"
	L["Space Horizontally"] = "横向间隙"
	L["Space Vertically"] = "纵向间隙"
	L["Spark"] = "高光"
	L["Spark Settings"] = "高光设置"
	L["Spark Texture"] = "高光材质"
	L["Specific Unit"] = "指定单位"
	L["Spell ID"] = "法术ID"
	L["Stack Count"] = "层数"
	L["Stack Info"] = "层数信息"
	L["Stacks"] = "层数"
	L["Stacks Settings"] = "层数设置"
	L["Stagger"] = "交错"
	L["Star"] = "星星"
	L["Start"] = "开始"
	L["Start Angle"] = "起始角度"
	L["Status"] = "状态"
	L["Stealable"] = "可偷取"
	L["Sticky Duration"] = "持续时间置顶"
	--[[Translation missing --]]
	L["Stop Sound"] = "Stop Sound"
	L["Symbol Settings"] = "标志设置"
	L["Temporary Group"] = "模板群组"
	L["Text"] = "文字"
	L["Text Color"] = "文字颜色"
	L["Text Position"] = "文字位置"
	L["Texture"] = "材质"
	L["Texture Info"] = "材质信息"
	--[[Translation missing --]]
	L["Texture Wrap"] = "Texture Wrap"
	L["The duration of the animation in seconds."] = "动画持续秒数"
	--[[Translation missing --]]
	L["The duration of the animation in seconds. The finish animation does not start playing until after the display would normally be hidden."] = "The duration of the animation in seconds. The finish animation does not start playing until after the display would normally be hidden."
	L["The type of trigger"] = "触发器类型"
	--[[Translation missing --]]
	L["Then "] = "Then "
	--[[Translation missing --]]
	L["This display is currently loaded"] = "This display is currently loaded"
	--[[Translation missing --]]
	L["This display is not currently loaded"] = "This display is not currently loaded"
	L["This region of type \"%s\" is not supported."] = "该类型区域“%s”不受支持。"
	L["Time in"] = "时间"
	L["Tiny Icon"] = "微型图标"
	--[[Translation missing --]]
	L["To Frame's"] = "To Frame's"
	L["to group's"] = "到群组"
	--[[Translation missing --]]
	L["To Personal Ressource Display's"] = "To Personal Ressource Display's"
	--[[Translation missing --]]
	L["To Screen's"] = "To Screen's"
	L["Toggle the visibility of all loaded displays"] = "切换当前已载入图示的可见状态"
	L["Toggle the visibility of all non-loaded displays"] = "切换当前未载入图示的可见状态"
	--[[Translation missing --]]
	L["Toggle the visibility of this display"] = "Toggle the visibility of this display"
	L["Tooltip"] = "提示"
	L["Tooltip on Mouseover"] = "鼠标提示"
	L["Top HUD position"] = "顶部 HUD 位置"
	L["Top Text"] = "顶部文字"
	L["Total Time Precision"] = "总的时间精度"
	L["Trigger"] = "触发"
	L["Trigger %d"] = "触发器 %d"
	L["Trigger:"] = "触发器："
	--[[Translation missing --]]
	L["True"] = "True"
	L["Type"] = "类型"
	--[[Translation missing --]]
	L["Undefined"] = "Undefined"
	--[[Translation missing --]]
	L["Ungroup"] = "Ungroup"
	L["Unit"] = "单位"
	L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "不同于开始或结束动画，主动画将不停循环，直到图示被隐藏。"
	--[[Translation missing --]]
	L["Up"] = "Up"
	L["Update Custom Text On..."] = "更新自定义文字于"
	L["Use Full Scan (High CPU)"] = "使用完整扫描(高CPU)"
	--[[Translation missing --]]
	L["Use nth value from tooltip:"] = "Use nth value from tooltip:"
	--[[Translation missing --]]
	L["Use SetTransform"] = "Use SetTransform"
	L["Use tooltip \"size\" instead of stacks"] = "使用\\\"大小\\\"提示,而不是\\\"层数\\\""
	--[[Translation missing --]]
	L["Used in auras:"] = "Used in auras:"
	--[[Translation missing --]]
	L["Version: "] = "Version: "
	L["Vertical Align"] = "垂直对齐"
	L["Vertical Bar"] = "垂直条"
	L["View"] = "视图"
	L["Width"] = "宽度"
	L["X Offset"] = "X 偏移"
	L["X Rotation"] = "X旋转"
	L["X Scale"] = "宽度比例"
	L["Y Offset"] = "Y 偏移"
	L["Y Rotation"] = "Y旋转"
	L["Y Scale"] = "长度比例"
	L["Yellow Rune"] = "黄色符文"
	L["Yes"] = "是"
	L["Z Offset"] = "深度 偏移"
	L["Z Rotation"] = "Z旋转"
	L["Zoom"] = "缩放"
	L["Zoom In"] = "放大"
	L["Zoom Out"] = "缩小"

