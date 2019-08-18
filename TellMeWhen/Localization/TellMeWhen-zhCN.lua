--[[ Credit for these translations goes to:
	lsjyzjl
	wowuicn
--]]
local L = LibStub("AceLocale-3.0"):NewLocale("TellMeWhen", "zhCN", false)
if not L then return end


L["!!Main Addon Description"] = "为冷却、增益/减益及其他各个方面提供视觉、听觉以及文字上的通知。"
L["ABSORBAMT"] = "护盾吸收量"
L["ABSORBAMT_DESC"] = "检测单位上的护盾的吸收总量."
L["ACTIVE"] = "%d 作用中"
L["ADDONSETTINGS_DESC"] = "配置所有通用插件的设置。"
L["AIR"] = "空气图腾"
L["ALLOWCOMM"] = "允许图标导入"
L["ALLOWCOMM_DESC"] = "允许另一个TellMeWhen使用者给你发送数据."
L["ALLOWVERSIONWARN"] = "新版本通知"
L["ALPHA"] = "透明度"
L["ANCHOR_CURSOR_DUMMY"] = "TellMeWhen鼠标指针"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [=[这是一个虚拟的鼠标指针，作用是帮你定位图标。

在使用”鼠标悬停目标“单位时，利用该指针定位分组非常有用。

你只需|cff7fffff右键点击并拖拽|r一个图标到指针上即可将该图标组依附到指针。

由于暴雪的bug，冷却时钟动画在移动后可能不能正常使用，依附指针的图标最好禁用它。

|cff7fffff左键点击并拖拽|r移动指针.]=]
L["ANCHORTO"] = "附着框架"
L["ANIM_ACTVTNGLOW"] = "图标:激活边框"
L["ANIM_ACTVTNGLOW_DESC"] = "在图标上显示暴雪的法术激活边框."
L["ANIM_ALPHASTANDALONE"] = "透明度"
L["ANIM_ALPHASTANDALONE_DESC"] = "设置动画的最大不透明度"
L["ANIM_ANCHOR_NOT_FOUND"] = "动画无法附着到框架%q. 当前图标是否没有使用到这个框架?"
L["ANIM_ANIMSETTINGS"] = "设置"
L["ANIM_ANIMTOUSE"] = "使用的动画效果"
L["ANIM_COLOR"] = "颜色/不透明度"
L["ANIM_COLOR_DESC"] = "设置闪光的颜色和不透明度."
L["ANIM_DURATION"] = "动画持续时间"
L["ANIM_DURATION_DESC"] = "设置动画触发后持续显示多久."
L["ANIM_FADE"] = "淡入淡出闪光"
L["ANIM_FADE_DESC"] = [=[勾选此项使每个闪光之间平滑的淡入淡出.不勾选则直接闪光.

(译者注:具体的差别请自行进行区分,我测试的效果除了第一次闪光之外,后面的闪光区别并不明显.)]=]
L["ANIM_ICONALPHAFLASH"] = "图标:透明度闪烁"
L["ANIM_ICONALPHAFLASH_DESC"] = "通过改变图标的透明度达到闪烁提示的效果."
L["ANIM_ICONBORDER"] = "图标:边框"
L["ANIM_ICONBORDER_DESC"] = "在图标上生成一个有颜色的边框."
L["ANIM_ICONCLEAR"] = "图标:停止动画"
L["ANIM_ICONCLEAR_DESC"] = "停止当前图标播放的所有动画效果."
L["ANIM_ICONFADE"] = "图标:淡入/淡出"
L["ANIM_ICONFADE_DESC"] = "在选定的事件发生时透明度将会渐变."
L["ANIM_ICONFLASH"] = "图标:颜色闪烁"
L["ANIM_ICONFLASH_DESC"] = "利用颜色重叠在整个图标上闪烁,达到提示的效果."
L["ANIM_ICONOVERLAYIMG"] = "图标:图像重叠"
L["ANIM_ICONOVERLAYIMG_DESC"] = "在图标上重叠显示自定义图像."
L["ANIM_ICONSHAKE"] = "图标:抖动"
L["ANIM_ICONSHAKE_DESC"] = "在事件触发时抖动图标."
L["ANIM_INFINITE"] = "无限重复播放"
L["ANIM_INFINITE_DESC"] = [=[勾选此项将会重复播放动画直到同个图标上另一相同类型的动画开始播放,或是在'%q'触发之后才会停止.

说明:比如在事件'开始'中设置了'图标:颜色闪烁',并且勾上了'无限重复播放',在事件'结束'设置了'图标:颜色闪烁'(持续时间3秒),事件'开始'中的'无限重复播放'就会在事件'结束'的动画播放结束后停止. 假如在同一个图标中没有设置相同类型的动画那就只能在'图标:停止动画'触发之后才会停止播放.如果还是不明白,就这样理解,同个图标中相同类型的动画只会存在一个,后面触发的会覆盖掉前面触发的.]=]
L["ANIM_MAGNITUDE"] = "抖动幅度"
L["ANIM_MAGNITUDE_DESC"] = "设置抖动的幅度需要多猛烈."
L["ANIM_PERIOD"] = "闪光周期"
L["ANIM_PERIOD_DESC"] = [=[设置每次闪烁应当持续多久 - 闪烁的显示时间或消退时间.

如果设置为0则不会闪烁和淡出.]=]
L["ANIM_PIXELS"] = "%s像素"
L["ANIM_SCREENFLASH"] = "屏幕:闪烁"
L["ANIM_SCREENFLASH_DESC"] = "利用颜色重叠在整个游戏屏幕上闪烁,达到提示的效果."
L["ANIM_SCREENSHAKE"] = "屏幕:抖动"
L["ANIM_SCREENSHAKE_DESC"] = [=[在事件触发时抖动整个游戏屏幕.

注意:屏幕抖动只能在离开战斗后使用,或者在你登陆之后没有启用姓名版的情况下使用.

(第一点啰嗦的解释:如果你在登陆之后按下显示姓名板的快捷键或者姓名板原本就已经启用了,就无法在战斗中使用屏幕抖动,如果你需要在战斗中使用请继续往下看.

第二点啰嗦的解释:如果一定要在战斗中使用屏幕抖动请先关闭在‘ESC->界面->名字’中有关显示单位姓名板的选项,然后小退,登陆之后切记不可以按到任何显示姓名板的快捷键.）]=]
L["ANIM_SECONDS"] = "%s秒"
L["ANIM_SIZE_ANIM"] = "边框大小"
L["ANIM_SIZE_ANIM_DESC"] = "设置边框的尺寸大小为多少."
L["ANIM_SIZEX"] = "图像宽度"
L["ANIM_SIZEX_DESC"] = "设置图像的宽度为多少."
L["ANIM_SIZEY"] = "图像高度"
L["ANIM_SIZEY_DESC"] = "设置图像的高度为多少."
L["ANIM_TAB"] = "动画"
L["ANIM_TAB_DESC"] = "设置需要播放的动画效果。它们当中有些作用于图标，有些则是作用于整个屏幕。"
L["ANIM_TEX"] = "材质"
L["ANIM_TEX_DESC"] = [=[选择你要用来覆盖图标的材质.

你可以输入一个材质路径, 例如'Interface/Icons/spell_nature_healingtouch', 假如材质路径为'Interface/Icons'可以只输入'spell_nature_healingtouch'.

你也能使用放在WoW目录中的自定义材质(请在该字段输入材质的相对路径,像是'tmw/ccc.tga'),仅支持尺寸为2的N次方(32, 64, 128,等)并且类型为.tga和.blp的材质文件.]=]
L["ANIM_THICKNESS"] = "边框粗细"
L["ANIM_THICKNESS_DESC"] = "设置边框的粗细为多少.(一个图标的默认尺寸为30)"
L["ANN_CHANTOUSE"] = "使用频道"
L["ANN_EDITBOX"] = "要输出的文字内容"
L["ANN_EDITBOX_DESC"] = "输入通知事件触发时你想输出的文字内容."
L["ANN_EDITBOX_WARN"] = "在此输入你想要输出的文字内容"
L["ANN_FCT_DESC"] = [=[使用暴雪的浮动战斗文字功能输出.必须先启用界面选项中的文字输出.
]=]
L["ANN_NOTEXT"] = "<无文字>"
L["ANN_SHOWICON"] = "显示图标材质"
L["ANN_SHOWICON_DESC"] = "一些文本目标能随文字内容一起显示一个材质.勾选此项启用该功能."
L["ANN_STICKY"] = "静态模式"
L["ANN_SUB_CHANNEL"] = "输出位置"
L["ANN_TAB"] = "文字"
L["ANN_TAB_DESC"] = "设置要输出的文本。包括暴雪的文字频道、UI框架以及其他的一些插件。"
L["ANN_WHISPERTARGET"] = "悄悄话目标"
L["ANN_WHISPERTARGET_DESC"] = "输入你想要密语的玩家名字,仅可密语同服务器/同阵营的玩家."
L["ASCENDING"] = "升序"
L["ASPECT"] = "守护"
L["AURA"] = "光环"
L["BACK_IE"] = "转到上一个"
L["BACK_IE_DESC"] = [=[载入上一个编辑过的图标

%s |T%s:0|t]=]
L["Bleeding"] = "流血效果"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["BUFFCNDT_DESC"] = "只有第一个法术会被检测,其他的将全部被忽略."
L["BUFFTOCHECK"] = "要检测的增益"
L["BUFFTOCOMP1"] = "进行比较的第一个增益"
L["BUFFTOCOMP2"] = "进行比较的第二个增益"
L["BURNING_EMBERS_FRAGMENTS"] = "燃烧余烬碎片"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[一个完整的燃烧余烬由十个碎片所组成.

假如你有一个半的燃烧余烬(由十五个余烬碎片组成),你要监视全部的余烬碎片时,可能需要使用此条件.]=]
L["CACHING"] = [=[TellMeWhen正在缓存和筛选游戏中的所有法术.
这只需要在每次魔兽世界补丁升级之后完成一次.您可以使用下方的滑杆加快或减慢过程.]=]
L["CACHINGSPEED"] = "法术缓存速度(每帧法术):"
L["CASTERFORM"] = "施法者形态"
L["CENTER"] = "居中"
L["CHANGELOG"] = "更新日志"
L["CHANGELOG_DESC"] = "显示TellMeWhen当前和之前版本的变动列表."
L["CHANGELOG_INFO2"] = [=[欢迎使用 TellMeWhen v%s!
<br/><br/>
在你确认完变更信息后, 点击标签 %s 或底部的标签 %s 开始设置TellMeWhen.]=]
L["CHANGELOG_LAST_VERSION"] = "上次安装的版本"
L["CHAT_FRAME"] = "聊天窗口"
L["CHAT_MSG_CHANNEL"] = "聊天频道"
L["CHAT_MSG_CHANNEL_DESC"] = "将输出到一个聊天频道,例如交易频道或是你加入的某个自定义频道."
L["CHAT_MSG_SMART"] = "智能频道"
L["CHAT_MSG_SMART_DESC"] = "此频道会自行选择最合适的输出频道.(仅限于:战场,团队,队伍,或说)"
L["CHOOSEICON"] = "选择一个用于检测的图标"
L["CHOOSEICON_DESC"] = [=[|cff7fffff点击|r选择一个图标/分组.
|cff7fffff左键点击并拖放|r以滚动方式改变顺序.
|cff7fffff右键点击并拖放|r以常用方式改变顺序.

译者注:如果分不清楚区别请直接使用常用方式.]=]
L["CHOOSENAME_DIALOG"] = [=[输入你想让此图标监视的名称或ID.你可以利用';'(分号)输入多个条目(名称/ID/同类型的任意组合).

你可以使用破折号（减号）从同类型法术中单独移除某个法术，例如"Slowed; -眩晕"。

你可以|cff7fffff按住Shift再按鼠标左键点选|r法术/物品/聊天连结或者拖曳法术/物品添加到此编辑框中.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959宠物技能|r必须使用法术ID."
L["CLEU_"] = "任意事件"
L["CLEU_CAT_AURA"] = "增益/减益"
L["CLEU_CAT_CAST"] = "施法"
L["CLEU_CAT_MISC"] = "其他"
L["CLEU_CAT_SPELL"] = "法术"
L["CLEU_CAT_SWING"] = "近战/远程"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "操控者关系"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "操控者关系:玩家(你)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "勾选以排除那些你控制的单位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "操控者关系:外人"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "勾选以排除那些与你同组的某人控制的单位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "操控者关系:队伍成员"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "勾选以排除那些你队伍中的玩家控制的单位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "操控者关系:团队成员"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "勾选以排除那些你团队中的玩家控制的单位."
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "操控者"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "操控者:服务器"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "勾选以排除那些服务器控制的单位(包括它们的宠物跟守卫)."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "操控者:人类"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "勾选以排除那些人类控制的单位(包括他们的宠物跟守卫),这里是指真正的人类,不是游戏中的人类种族,如果你教会了猴子/猩猩玩魔兽世界的话,可以加上它们."
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "其他:你的焦点目标"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "勾选以排除那个你设置为焦点目标的单位."
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "其他:主助攻"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "勾选以排除团队中被标记为主助攻的单位."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "其他:主坦克"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "勾选以排除团队中被标记为主坦克的单位."
L["CLEU_COMBATLOG_OBJECT_NONE"] = "其他:未知单位"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "勾选以排除WoW客户端完全未知的单位，还可以排除在游戏客户端中没有提供单位的一些事件。"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "单位反应:友好"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "勾选以排除那些对你反应是友好的单位."
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "单位反应:敌对"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "勾选以排除那些对你反应是敌对的单位."
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "单位反应"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "单位反应:中立"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "勾选以排除那些对你反应是中立的单位."
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "其他:你的目标"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "勾选以排除你当前的目标单位."
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "单位类型:守卫"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "勾选以排除守卫. 守卫是指那些会保护操控者但是不能直接被控制的单位."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "单位类型"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "单位类型:NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "勾选以排除非玩家角色."
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "单位类型:对象"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "勾选以排除像是陷阱,鱼点等其他没有被划分到\"单位类型\"中的其他任何东西."
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "单位类型:宠物"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "勾选以排除宠物. 宠物是指那些会保护操控者并且可以直接被控制的单位."
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "单位类型:玩家角色"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "勾选以排除玩家角色."
L["CLEU_CONDITIONS_DESC"] = [=[配置每个单元必须通过的条件，以便进行检查。

这些条件仅在输入要检查的单位，并且所有输入的单位均为单位ID时可用 - 不能在这些条件下使用名称。]=]
L["CLEU_CONDITIONS_DEST"] = "目标条件"
L["CLEU_CONDITIONS_SOURCE"] = "来源条件"
L["CLEU_DAMAGE_SHIELD"] = "伤害护盾"
L["CLEU_DAMAGE_SHIELD_DESC"] = "此事件在伤害护盾对一个单位造成伤害时发生. (%s,%s,等等,但是不包括%s)"
L["CLEU_DAMAGE_SHIELD_MISSED"] = "伤害护盾未命中"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "此事件在伤害护盾对一个单位造成伤害失败时发生. (%s,%s,等等,但是不包括%s)"
L["CLEU_DAMAGE_SPLIT"] = "伤害分担"
L["CLEU_DAMAGE_SPLIT_DESC"] = "此事件在伤害被两个或者更多个单位分担时发生."
L["CLEU_DESTUNITS"] = "用于检测的目标单位"
L["CLEU_DESTUNITS_DESC"] = "选择你想要图标检测的事件目标单位,可以保留空白让图标检测任意的事件目标单位."
L["CLEU_DIED"] = "死亡"
L["CLEU_ENCHANT_APPLIED"] = "附魔应用"
L["CLEU_ENCHANT_APPLIED_DESC"] = "此事件所指为暂时性武器附魔,像是潜行者的毒药和萨满的武器强化."
L["CLEU_ENCHANT_REMOVED"] = "附魔消失"
L["CLEU_ENCHANT_REMOVED_DESC"] = "此事件所指为暂时性武器附魔,像是潜行者的毒药和萨满的武器强化."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "环境伤害"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "包括来自熔岩、掉落、溺水以及疲劳的伤害."
L["CLEU_EVENTS"] = "用于检测的事件"
L["CLEU_EVENTS_ALL"] = "全部事件"
L["CLEU_EVENTS_DESC"] = "选择那些你想要图标检测的战斗事件."
L["CLEU_FLAGS_DESC"] = "可以排除列表中包含的某种属性的单位使其无法触发图标.如果勾选排除某种属性的单位,图标将不会处理那个单位相关的事件."
L["CLEU_FLAGS_DEST"] = "排除"
L["CLEU_FLAGS_SOURCE"] = "排除"
L["CLEU_HEADER"] = "战斗事件过滤"
L["CLEU_HEADER_DEST"] = "目标单位"
L["CLEU_HEADER_SOURCE"] = "来源单位"
L["CLEU_NOFILTERS"] = "%s图标在%s没有定义任何过滤条件.你需要定义至少一个过滤条件,否则无法正常使用."
L["CLEU_PARTY_KILL"] = "队伍击杀"
L["CLEU_PARTY_KILL_DESC"] = "当队伍中的某人击杀某怪物时触发."
L["CLEU_RANGE_DAMAGE"] = "远程攻击伤害"
L["CLEU_RANGE_MISSED"] = "远程攻击未命中"
L["CLEU_SOURCEUNITS"] = "用于检测的来源单位"
L["CLEU_SOURCEUNITS_DESC"] = "选择你想要图标检测的事件来源单位,可以保留空白让图标检测任意的事件来源单位."
L["CLEU_SPELL_AURA_APPLIED"] = "效果获得(指目标单位获得某增益/减益,来源单位为施放者)"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "效果叠加"
L["CLEU_SPELL_AURA_BROKEN"] = "效果被打破(物理)"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "效果被打破(法术)"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[此事件在一个效果被法术伤害打破时发生(通常是指某种控场技能).

图标会筛选出被打破的效果;在文字输出/显示时你可以使用标签[Extra]替代这个效果.]=]
L["CLEU_SPELL_AURA_REFRESH"] = "效果刷新"
L["CLEU_SPELL_AURA_REMOVED"] = "效果移除"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "效果叠加移除"
L["CLEU_SPELL_CAST_FAILED"] = "施法失败"
L["CLEU_SPELL_CAST_START"] = "开始施法"
L["CLEU_SPELL_CAST_START_DESC"] = [=[此事件在开始施放一个法术时发生.

注意:为了防止可能出现的游戏框架滥用,暴雪禁用了此事件的目标单位,所以你不能过滤它们.]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "法术施放成功"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "此事件在法术施放成功时发生."
L["CLEU_SPELL_CREATE"] = "法术制造"
L["CLEU_SPELL_CREATE_DESC"] = "此事件在一个对像被制造时发生,例如猎人的陷阱跟法师的传送门."
L["CLEU_SPELL_DAMAGE"] = "法术伤害"
L["CLEU_SPELL_DAMAGE_CRIT"] = "法术暴击"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "此事件在任意法术伤害暴击时发生，会跟%q事件同时触发。"
L["CLEU_SPELL_DAMAGE_DESC"] = "此事件在任意法术造成伤害时发生."
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "法术未暴击"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = "此事件在任意法术伤害没有暴击时发生，会跟%q事件同时触发。"
L["CLEU_SPELL_DISPEL"] = "驱散"
L["CLEU_SPELL_DISPEL_DESC"] = [=[此事件在一个效果被驱散时发生.

图标会筛选出被驱散的效果;在文字输出/显示时你可以使用标签[Extra]替代这个效果.]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "驱散失败"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[此事件在驱散某一效果失败时发生.

图标会筛选出这个驱散失败的效果;在文字输出/显示时你可以使用标签[Extra]替代这个效果.]=]
L["CLEU_SPELL_DRAIN"] = "抽取资源"
L["CLEU_SPELL_DRAIN_DESC"] = "此事件在资源从某个单位移除时发生(资源指生命值/魔法值/怒气/能量等)."
L["CLEU_SPELL_ENERGIZE"] = "获得资源"
L["CLEU_SPELL_ENERGIZE_DESC"] = "此事件在一个单位获得资源时发生(资源指生命值/魔法值/怒气/能量等)."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "获得额外攻击"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "此事件在你获得额外的近战攻击时发生."
L["CLEU_SPELL_HEAL"] = "治疗"
L["CLEU_SPELL_INSTAKILL"] = "秒杀"
L["CLEU_SPELL_INTERRUPT"] = "打断 - 被打断的法术"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[此事件在施法被打断时发生.

图标会筛选出被打断施法的法术;在文字输出/显示时你可以使用标签[Extra]替代这个法术.

请注意两个打断事件的区别 - 当一个法术被打断时两个事件都会发生,但是筛选出的法术会有所不同.]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "打断 - 造成打断的法术"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[此事件在施法被打断时发生.

图标会筛选出造成打断施法的法术;在文字输出/显示时你可以使用标签[Extra]替代这个法术.

请注意两个打断事件的区别 - 当一个法术被打断时两个事件都会发生,但是筛选出的法术会有所不同.]=]
L["CLEU_SPELL_LEECH"] = "资源吸取"
L["CLEU_SPELL_LEECH_DESC"] = "此事件在从某个单位移除资源给另一单位时发生(资源指生命值/魔法值/怒气/能量等)."
L["CLEU_SPELL_MISSED"] = "法术未命中"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "伤害(持续性)"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "抽取资源(持续性)"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "获得资源(持续性)"
L["CLEU_SPELL_PERIODIC_HEAL"] = "治疗(持续性)"
L["CLEU_SPELL_PERIODIC_LEECH"] = "资源吸取(持续性)"
L["CLEU_SPELL_PERIODIC_MISSED"] = "伤害(持续性)未命中"
L["CLEU_SPELL_REFLECT"] = "法术反射"
L["CLEU_SPELL_REFLECT_DESC"] = [=[此事件在你反射一个对你施放的法术时发生.

来源单位是反射法术者,目标单位是法术被反射的施法者.]=]
L["CLEU_SPELL_RESURRECT"] = "复活"
L["CLEU_SPELL_RESURRECT_DESC"] = "此事件在某个单位从死亡中复活时发生."
L["CLEU_SPELL_STOLEN"] = "效果被偷取"
L["CLEU_SPELL_STOLEN_DESC"] = [=[此事件在增益被偷取时发生,很可能来自%s.

图标会筛选出那个被偷取的法术.]=]
L["CLEU_SPELL_SUMMON"] = "法术召唤"
L["CLEU_SPELL_SUMMON_DESC"] = "此事件在一个NPC被召唤或者生成时发生."
L["CLEU_SWING_DAMAGE"] = "近战攻击伤害"
L["CLEU_SWING_MISSED"] = "近战攻击未命中"
L["CLEU_TIMER"] = "设置事件的计时器"
L["CLEU_TIMER_DESC"] = [=[设置图标计时器在事件发生时的持续时间.

你也可以在%q编辑框中使用"法术:持续时间"语法设置一个持续时间,在事件处理你所筛选出的那些法术时使用.

如果法术没有指定持续时间,或者你没有筛选过滤任何法术(编辑框为空白),那将使用这个持续时间.]=]
L["CLEU_UNIT_DESTROYED"] = "单位被摧毁"
L["CLEU_UNIT_DESTROYED_DESC"] = "此事件在一个单位被摧毁时发生(比如萨满的图腾)."
L["CLEU_UNIT_DIED"] = "单位死亡"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[你排除了%q分类中的所有条目,这将导致图标不再处理任何事件.

取消勾选至少一个条目使图标可以正常运作.]=]
L["CLICK_TO_EDIT"] = "|cff7fffff点击|r编辑."
L["CMD_CHANGELOG"] = "更新日志"
L["CMD_DISABLE"] = "禁用"
L["CMD_ENABLE"] = "启用"
L["CMD_OPTIONS"] = "选项"
L["CMD_PROFILE"] = "配置文件"
L["CMD_PROFILE_INVALIDPROFILE"] = "无法找到名为 %q 的配置文件! (译者注:注意区分大小写)"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = [=[提示: 如果配置文件名称包含空格,请在前后加上英文的引号. 

例如:
/tmw profile "打打 - 索拉丁"
或
/tmw 配置文件 "百战好哥哥 - 索拉丁"]=]
L["CMD_TOGGLE"] = "切换"
L["CNDT_DEPRECATED_DESC"] = "条件%s无效。这可能是因为游戏机制改变所造成的，请移除它或者更改为其他条件。"
L["CNDT_MULTIPLEVALID"] = "你可以利用分号分隔的方式输入多个用于检测的名称或ID。"
L["CNDT_ONLYFIRST"] = "仅第一个法术/物品会被检测,使用分号分隔的列表不适用此条件类型."
L["CNDT_RANGE"] = "单位距离"
L["CNDT_RANGE_DESC"] = "使用LibRangeCheck-2.0检测单位的大概距离．单位不存在时条件将会返回否（false）。"
L["CNDT_RANGE_IMPRECISE"] = "%d 码。 (|cffff1300不太准确|r)"
L["CNDT_RANGE_PRECISE"] = "%d 码。(|cff00c322准确|r)"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffff点击鼠标右键|r切换到手动输入模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffff点击鼠标右键|r切换到滚动条选择模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "仅允许在手动输入时输入大于%s的数值。 (较大的数值显示在暴雪滚动条会变得很奇怪)"
L["CNDT_TOTEMNAME"] = "图腾名称"
L["CNDT_TOTEMNAME_DESC"] = [=[设置为空白将检测所选类型的任意图腾.

你可以输入一个图腾名称,或者一个使用分号分隔开的名称列表,只用来检测某几个特定的图腾.]=]
L["CNDT_UNKNOWN_DESC"] = "你的设置中有一个名为%s的标识无法找到对应的条件。可能是因为使用了旧版本的TMW或者该条件已经被移除。"
L["CNDTCAT_ARCHFRAGS"] = "考古学碎片"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "玩家属性/状态"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "单位属性/状态"
L["CNDTCAT_BOSSMODS"] = "首领模块"
L["CNDTCAT_BUFFSDEBUFFS"] = "增益/减益"
L["CNDTCAT_CURRENCIES"] = "货币"
L["CNDTCAT_FREQUENTLYUSED"] = "常用条件"
L["CNDTCAT_LOCATION"] = "组队/区域"
L["CNDTCAT_MISC"] = "其他"
L["CNDTCAT_RESOURCES"] = "能量类型"
L["CNDTCAT_SPELLSABILITIES"] = "法术/物品"
L["CNDTCAT_STATS"] = "战斗统计(人物属性)"
L["CNDTCAT_TALENTS"] = "职业/天赋"
L["CODESNIPPET_ADD2"] = "新 %s 片段"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffff点击|r新增 %s 片段."
L["CODESNIPPET_AUTORUN"] = "登陆时自动运行"
L["CODESNIPPET_AUTORUN_DESC"] = "如果启用，此片段将在TWM载入时激活(激活时间为在玩家登陆事件PLAYER_LOGIN时，但是在图标跟分组创建之前)。"
L["CODESNIPPET_CODE"] = "用于执行的Lua代码"
L["CODESNIPPET_DELETE"] = "删除片段"
L["CODESNIPPET_DELETE_CONFIRM"] = "你确定要删除代码片段(%q)?"
L["CODESNIPPET_EDIT_DESC"] = "|cff7fffff点击|r 编辑此片段."
L["CODESNIPPET_GLOBAL"] = "共用片段"
L["CODESNIPPET_ORDER"] = "执行顺序"
L["CODESNIPPET_ORDER_DESC"] = [=[设置此代码片段的执行顺序(相对于其他的片段而言).

%s和%s都将基于这个数值来执行.

如果两个片段使用了相同的顺序,无法确认谁先执行的时候,可以使用小数.]=]
L["CODESNIPPET_PROFILE"] = "角色专用片段"
L["CODESNIPPET_RENAME"] = "代码片段名称"
L["CODESNIPPET_RENAME_DESC"] = [=[为这个片段输入一个自己容易识别的名称.

名称不是唯一,允许重复使用.]=]
L["CODESNIPPET_RUNAGAIN"] = "再次运行片段"
L["CODESNIPPET_RUNAGAIN_DESC"] = [=[此片段已经在进程中运行过一次。

|cff7fffff点击|r再次运行。]=]
L["CODESNIPPET_RUNNOW"] = "执行片段"
L["CODESNIPPET_RUNNOW_DESC"] = [=[点击执行此代码片段.

按住|cff7fffffCtrl|r跳过片段已经执行的确认.]=]
L["CODESNIPPETS"] = "Lua代码片段"
L["CODESNIPPETS_DEFAULTNAME"] = "新片段"
L["CODESNIPPETS_DESC"] = [=[此功能允许你编写Lua代码并在TellMeWhen加载时执行.

它是一个高级功能,可以让Lua熟练工如鱼得水,也可以让完全不懂Lua的人导入其他TellMeWhen使用者分享出来的片段.

可用在像是编写一个特定的过程用于Lua条件中(必须把它们定义在TMW.CNDT.Env).

片段可被定义为角色专用或公用(共用片段会在所有角色执行).]=]
L["CODESNIPPETS_DESC_SHORT"] = "输入的LUA代码会在TellMeWhen加载的时候运行。"
L["CODESNIPPETS_IMPORT_GLOBAL"] = "新的共用片段"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "片段导入为共用片段."
L["CODESNIPPETS_IMPORT_PROFILE"] = "新的角色专用片段"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "片段导入为角色专用片段."
L["CODESNIPPETS_TITLE"] = "Lua片段(高玩级)"
L["CODETOEXE"] = "要执行的代码"
L["COLOR_MSQ_COLOR"] = "使用Masque边框颜色(整个图标)"
L["COLOR_MSQ_COLOR_DESC"] = "勾选此项将使用Masque皮肤中设置的边框颜色对图标着色(假如你在皮肤设置中有使用边框的话)."
L["COLOR_MSQ_ONLY"] = "使用Masque边框颜色(仅边框)"
L["COLOR_MSQ_ONLY_DESC"] = "勾选此项将仅对图标边框使用Masque皮肤中设置的边框颜色进行着色(假如你在皮肤设置中有使用边框的话).图标不会被着色."
L["COLOR_OVERRIDE_GLOBAL"] = "覆盖全局颜色"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = "检查以配置独立于全局定义颜色的颜色。"
L["COLOR_OVERRIDE_GROUP"] = "覆盖分组颜色"
L["COLOR_OVERRIDE_GROUP_DESC"] = "检查以配置与为图标组指定的颜色无关的颜色。"
L["COLOR_USECLASS"] = "使用职业颜色"
L["COLOR_USECLASS_DESC"] = "勾选使用所检测单位的职业颜色来给进度条上色。"
L["COLORPICKER_BRIGHTNESS"] = "亮度"
L["COLORPICKER_BRIGHTNESS_DESC"] = "设置颜色的亮度(有时也称为值)"
L["COLORPICKER_DESATURATE"] = "减小饱和度"
L["COLORPICKER_DESATURATE_DESC"] = "在应用颜色之前对纹理去饱和，允许您重新着色纹理，而不是着色。"
L["COLORPICKER_HUE"] = "色度"
L["COLORPICKER_HUE_DESC"] = "设置颜色的色度"
L["COLORPICKER_ICON"] = "预览"
L["COLORPICKER_OPACITY"] = "不透明度"
L["COLORPICKER_OPACITY_DESC"] = "设置颜色的不透明度(也称为alpha通道)."
L["COLORPICKER_RECENT"] = "最近使用的颜色"
L["COLORPICKER_RECENT_DESC"] = [=[|cff7fffff点击|r读取这个颜色。
|cff7fffff右键点击|r从列表移除这个颜色。]=]
L["COLORPICKER_SATURATION"] = "饱和度"
L["COLORPICKER_SATURATION_DESC"] = "设置颜色的饱和度."
L["COLORPICKER_STRING"] = "16进制字符"
L["COLORPICKER_STRING_DESC"] = "获取/设置 当前颜色的十六进制(A)RGB"
L["COLORPICKER_SWATCH"] = "颜色"
L["COMPARISON"] = "比较"
L["CONDITION_COUNTER"] = "用于检测的计数器"
L["CONDITION_COUNTER_EB_DESC"] = "输入你想要检测的计数器名称。"
L["CONDITION_QUESTCOMPLETE"] = "任务完成"
L["CONDITION_QUESTCOMPLETE_DESC"] = "检测一个任务是否已完成."
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [=[输入你想检测的任务ID.

任务ID可以在魔兽世界数据库网站获得,像是db.178.com(中文)和www.wowhead.com(英文).

例如:http://db.178.com/wow/cn/quest/32615.html<超多的巨型恐龙骨骼>任务ID为32615.]=]
L["CONDITION_TIMEOFDAY"] = "一天中的时间"
L["CONDITION_TIMEOFDAY_DESC"] = [=[此条件将使用当前时间与设置时间进行比较.

用于比较的时间是本地时间(基于你的电脑时钟).它不会获取服务器的时间.]=]
L["CONDITION_TIMER"] = "用于检测的计时器"
L["CONDITION_TIMER_EB_DESC"] = "输入你想用于检测的计时器名称。"
L["CONDITION_TIMERS_FAIL_DESC"] = [=[设置条件无法通过以后图标计时器的持续时间

(译者注:图标在条件每次通过/无法通过后都会重新计时,另外在默认的情况下图标的显示只会根据条件通过情况来改变,设定的持续时间不会影响到图标的显示情况,不会在设置的持续时间倒数结束后隐藏图标,如果想要图标在计时结束后隐藏,需要勾选'仅在计时器作用时显示',这是4.5.3版本新加入的功能.)]=]
L["CONDITION_TIMERS_SUCCEED_DESC"] = [=[设置条件成功通过以后图标计时器的持续时间

(译者注:图标在条件每次通过/无法通过后都会重新计时,另外在默认的情况下图标的显示只会根据条件通过情况来改变,设定的持续时间不会影响到图标的显示情况,不会在设置的持续时间倒数结束后隐藏图标,如果想要图标在计时结束后隐藏,需要勾选'仅在计时器作用时显示',这是4.5.3版本新加入的功能.)]=]
L["CONDITION_WEEKDAY"] = "星期几"
L["CONDITION_WEEKDAY_DESC"] = [=[检测今天是不是星期几.

用于检测的时间是本地时间(基于你的电脑时钟).它不会获取服务器的时间.]=]
L["CONDITIONALPHA_METAICON"] = "条件未通过时"
L["CONDITIONALPHA_METAICON_DESC"] = [=[该透明度用于条件未通过时.

条件可在%q选项卡中设置.]=]
L["CONDITIONPANEL_ABSOLUTE"] = "(非百分比/绝对值)"
L["CONDITIONPANEL_ADD"] = "添加条件"
L["CONDITIONPANEL_ADD2"] = "点击增加一个条件"
L["CONDITIONPANEL_ALIVE"] = "单位存活"
L["CONDITIONPANEL_ALIVE_DESC"] = "此条件会检测指定单位的存活情况."
L["CONDITIONPANEL_ALTPOWER"] = "特殊能量"
L["CONDITIONPANEL_ALTPOWER_DESC"] = [=[这是大地的裂变某些首领战遇到的特殊能量,像是古加尔的腐化值跟艾卓曼德斯的音波值.
]=]
L["CONDITIONPANEL_AND"] = "同时"
L["CONDITIONPANEL_ANDOR"] = "同时/或者"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffff点击|r切换逻辑运算符 同时/或者(And/Or)"
L["CONDITIONPANEL_AUTOCAST"] = "宠物自动施法"
L["CONDITIONPANEL_AUTOCAST_DESC"] = "检查指定宠物技能是否自动释放中."
L["CONDITIONPANEL_BIGWIGS_ENGAGED"] = "Big Wigs - 首领战开始"
L["CONDITIONPANEL_BIGWIGS_ENGAGED_DESC"] = [=[检测Big Wigs激活的首领战。

请输入首领战的全名到“用于检测的首领战”。]=]
L["CONDITIONPANEL_BIGWIGS_TIMER"] = "Big Wigs - 计时器"
L["CONDITIONPANEL_BIGWIGS_TIMER_DESC"] = [=[检测Big Wigs首领模块计时器的持续时间。

请输入计时器全名到“用于检测的计时器”。]=]
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "始终为真"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "反选"
L["CONDITIONPANEL_BITFLAGS_CHECK_DESC"] = [=[勾选此项来反转检测所用的条件。

默认情况下，条件会在选择的选项成立时通过。

如果设置了此项，条件会在所选的选项都没有成立时通过。]=]
L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"] = "选择职业..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "选择大陆..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "选择图标..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"] = "选择类型..."
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "选择种族..."
L["CONDITIONPANEL_BITFLAGS_NEVER"] = "无 - 始终为否"
L["CONDITIONPANEL_BITFLAGS_NOT"] = "非"
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffff已选|r:"
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "套装已装备(自带装备管理器)"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "检测暴雪自带装备管理器中设置的套装是否已装备。"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "套装名称"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [=[输入你要检测的暴雪自带装备管理器中的套装名称。

只允许输入一个套装，注意|cFFFF5959区分大小写|r。

译者注：可以从右侧的提示与建议列表中直接选择套装名称。]=]
L["CONDITIONPANEL_CASTCOUNT"] = "法术施放次数"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = "检测一个单位施放某个法术的次数."
L["CONDITIONPANEL_CASTTOMATCH"] = "用于匹配的法术"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[输入一个法术名称使该条件只在施放的法术名称跟输入的法术名称完全匹配时才可通过.

你可以保留空白来检测任意的法术施放/引导法术(不包括瞬发法术).]=]
L["CONDITIONPANEL_CLASS"] = "单位职业"
L["CONDITIONPANEL_CLASSIFICATION"] = "单位分类"
L["CONDITIONPANEL_CLASSIFICATION_DESC"] = "检测一个单位是否为精英、稀有、世界首领。"
L["CONDITIONPANEL_COMBAT"] = "单位在战斗中"
L["CONDITIONPANEL_COMBO"] = "连击点数"
L["CONDITIONPANEL_COUNTER_DESC"] = "检测“计数器”通知处理所创建和修改的计数器的值。"
L["CONDITIONPANEL_CREATURETYPE"] = "单位生物类型"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [=[你可以利用分号(;)输入多个生物类型用于匹配.

输入的生物类型必须同鼠标提示信息上所显示的完全相同.

此条件会在输入的任意一个类型与你所检查单位的生物类型相同时通过.]=]
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "生物类型"
L["CONDITIONPANEL_DBM_ENGAGED"] = "Deadly Boss Mods - 首领战开始"
L["CONDITIONPANEL_DBM_ENGAGED_DESC"] = [=[检测Deadly Boss Mods激活的首领战。

请输入首领战的全名到“用于检测的首领战”。]=]
L["CONDITIONPANEL_DBM_TIMER"] = "Deadly Boss Mods - 计时器"
L["CONDITIONPANEL_DBM_TIMER_DESC"] = [=[检测Deadly Boss Mods计时器的持续时间。

请输入计时器的全名到“用于检测的计时器”。]=]
L["CONDITIONPANEL_DEFAULT"] = "选择条件类型..."
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[蚀星蔽月的范围是-100(月蚀)到100(日蚀)
如果你想在月蚀能量80時显示图标就輸入-80

说明:蚀星蔽月是台服的翻译,大陆的翻译叫月蚀,这样不容易区分这个月蚀所对应的日蚀/月蚀,所以这里的说明文字直接用台服的翻译.]=]
L["CONDITIONPANEL_EQUALS"] = "等于"
L["CONDITIONPANEL_EXISTS"] = "单位存在"
L["CONDITIONPANEL_GREATER"] = "大于"
L["CONDITIONPANEL_GREATEREQUAL"] = "大于或等于"
L["CONDITIONPANEL_GROUPSIZE"] = "副本人数"
L["CONDITIONPANEL_GROUPSIZE_DESC"] = "检测当前副本设置的人数，也可在检测弹性副本时使用。"
L["CONDITIONPANEL_GROUPTYPE"] = "组队类型"
L["CONDITIONPANEL_GROUPTYPE_DESC"] = "检查你所在的队伍类型(单独,小队或团队)."
L["CONDITIONPANEL_ICON"] = "图标显示"
L["CONDITIONPANEL_ICON_DESC"] = [=[此条件检测指定图标的显示状态或隐藏状态.

如果你不想显示被检测的图标,请在被检测图标的图标编辑器勾选 %q.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "隐藏"
L["CONDITIONPANEL_ICON_SHOWN"] = "显示"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "图标隐藏时间"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[此条件检测指定的图标已经隐藏了多久时间.

如果你不想显示被检测的图标,请在被检测图标的图标编辑器勾选 %q.]=]
L["CONDITIONPANEL_ICONSHOWNTIME"] = "图标显示时间"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[此条件检测指定的图标已经显示了多久时间.

如果你不想显示被检测的图标,请在被检测图标的图标编辑器勾选 %q.]=]
L["CONDITIONPANEL_INPETBATTLE"] = "在宠物对战中"
L["CONDITIONPANEL_INSTANCETYPE"] = "副本类型"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "检测你所在的地下城的类型。此条件包含任何地下城或团队副本的难度设置。"
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s(神话难度)"
L["CONDITIONPANEL_INSTANCETYPE_NONE"] = "野外"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "可打断"
L["CONDITIONPANEL_ITEMRANGE"] = "单位在物品范围内"
L["CONDITIONPANEL_LASTCAST"] = "最后使用的技能"
L["CONDITIONPANEL_LASTCAST_ISNTSPELL"] = "不匹配"
L["CONDITIONPANEL_LASTCAST_ISSPELL"] = "匹配"
L["CONDITIONPANEL_LESS"] = "小于"
L["CONDITIONPANEL_LESSEQUAL"] = "小于或等于"
L["CONDITIONPANEL_LEVEL"] = "单位等级"
L["CONDITIONPANEL_LOC_CONTINENT"] = "大陆"
L["CONDITIONPANEL_LOC_SUBZONE"] = "子地区"
L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"] = "输入您要检查的子区域。 用分号分隔多个子区域。"
L["CONDITIONPANEL_LOC_SUBZONE_DESC"] = "检查您当前的子区域。 请注意：有时，您可能不在子区域。"
L["CONDITIONPANEL_LOC_SUBZONE_LABEL"] = "输入子区域进行检查"
L["CONDITIONPANEL_LOC_ZONE"] = "地区"
L["CONDITIONPANEL_LOC_ZONE_DESC"] = "输入您要检查的区域。 用分号分隔多个区域。"
L["CONDITIONPANEL_LOC_ZONE_LABEL"] = "输入用于检测的区域"
L["CONDITIONPANEL_MANAUSABLE"] = "法术可用(魔法值/能量/等是否够用.)"
L["CONDITIONPANEL_MANAUSABLE_DESC"] = [=[如果一个法术的可用基于你的主要能量（法力、能量、怒气、符能、集中值等）。

不会再检测基于第二能量的可用性（符文、圣能、真气等）。]=]
L["CONDITIONPANEL_MAX"] = "(最大值)"
L["CONDITIONPANEL_MOUNTED"] = "在坐骑上"
L["CONDITIONPANEL_NAME"] = "单位名字"
L["CONDITIONPANEL_NAMETOMATCH"] = "用于比较的名字"
L["CONDITIONPANEL_NAMETOOLTIP"] = "你可以在每个名字后面加上分号(;)以便输入多个需要比较的名字. 其中任何一个名字相符时此条件都会通过."
L["CONDITIONPANEL_NOTEQUAL"] = "不等于"
L["CONDITIONPANEL_NPCID"] = "单位NPC编号"
L["CONDITIONPANEL_NPCID_DESC"] = [=[检测指定的单位NPC编号.

NPC编号可以在Wowhead之类的魔兽世界数据库找到(例如http://www.wowhead.com/npc=62943).

玩家与某些单位没有NPC编号,在此条件中的返回值为0.]=]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "用于比较的编号"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "你可以利用分号(;)输入多个NPC编号.条件会在任意一个编号相符时通过."
L["CONDITIONPANEL_OLD"] = "<|cffff1300旧版本|r>"
L["CONDITIONPANEL_OLD_DESC"] = "<|cffff1300旧版本|r> - 此条件有新版本可用。"
L["CONDITIONPANEL_OPERATOR"] = "运算符"
L["CONDITIONPANEL_OR"] = "或者"
L["CONDITIONPANEL_OVERLAYED"] = "法术激活边框"
L["CONDITIONPANEL_OVERLAYED_DESC"] = "检测一个法术是否有激活边框效果（就是在你动作条有黄色的边边的技能）。"
L["CONDITIONPANEL_OVERRBAR"] = "动作条效果"
L["CONDITIONPANEL_OVERRBAR_DESC"] = "检测你主要动作条上的一些动画效果，不包含宠物战斗。"
L["CONDITIONPANEL_PERCENT"] = "(百分比)"
L["CONDITIONPANEL_PERCENTOFCURHP"] = "当前生命值百分比"
L["CONDITIONPANEL_PERCENTOFMAXHP"] = "最大生命百分比"
L["CONDITIONPANEL_PETMODE"] = "宠物攻击模式"
L["CONDITIONPANEL_PETMODE_DESC"] = "检查当前宠物的攻击模式."
L["CONDITIONPANEL_PETMODE_NONE"] = "没有宠物"
L["CONDITIONPANEL_PETSPEC"] = "宠物种类"
L["CONDITIONPANEL_PETSPEC_DESC"] = "检测你当前宠物的专精类型。"
L["CONDITIONPANEL_POWER"] = "基本资源(能量类型)"
L["CONDITIONPANEL_POWER_DESC"] = "如果单位是猫形态的德鲁伊将检测能量值,如果是战士则检测怒气,等等"
L["CONDITIONPANEL_PVPFLAG"] = "单位PVP开启状态"
L["CONDITIONPANEL_RAIDICON"] = "单位团队标记"
L["CONDITIONPANEL_RAIDICON_DESC"] = "检测一个单位的团队标记图标。"
L["CONDITIONPANEL_REMOVE"] = "移除此条件"
L["CONDITIONPANEL_RESTING"] = "休息状态"
L["CONDITIONPANEL_ROLE"] = "单位角色类型"
L["CONDITIONPANEL_ROLE_DESC"] = "检测你队伍、团队中一个玩家所选择的角色类型。"
L["CONDITIONPANEL_RUNES"] = "符文数量"
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = [=[正常情况下,第一行的符文无论是不是死亡符文,在符合条件设置时都会通过.

启用这个选项强制第一行的符文仅匹配非死亡符文.]=]
L["CONDITIONPANEL_RUNES_DESC3"] = "使用此条件仅在特定数量的符文可用时显示图标。"
L["CONDITIONPANEL_RUNESLOCK"] = "符文锁定数量"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = "使用此条件仅在特定数量的符文被锁定时显示图标（等待恢复）。"
L["CONDITIONPANEL_RUNESRECH"] = "恢复中符文数量"
L["CONDITIONPANEL_RUNESRECH_DESC"] = "使用此条件仅在特定数量的符文正在恢复时显示图标。"
L["CONDITIONPANEL_SPELLCOST"] = "施法所需能量"
L["CONDITIONPANEL_SPELLCOST_DESC"] = "检测施法所需能量。像是法力值、怒气、能量等等。"
L["CONDITIONPANEL_SPELLRANGE"] = "单位在法术范围内"
L["CONDITIONPANEL_SWIMMING"] = "在游泳中"
L["CONDITIONPANEL_THREAT_RAW"] = "单位威胁值 - 原始"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[此条件用来检测你对一个单位的原始威胁值百分比.

近战玩家仇恨失控(OT)的威胁值为110%
远程玩家仇恨失控(OT)的威胁值为130%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "单位威胁值 - 比例"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[此条件用来检测你对一个单位的威胁值百分比比例.

100%表示你正在坦这个单位.]=]
L["CONDITIONPANEL_TIMER_DESC"] = "检测通知事件“计时器”中的计时器所创建和变更的值。"
L["CONDITIONPANEL_TRACKING"] = "追踪"
L["CONDITIONPANEL_TRACKING_DESC"] = "检测你小地图当前所追踪的类型。"
L["CONDITIONPANEL_TYPE"] = "类型"
L["CONDITIONPANEL_UNIT"] = "单位"
L["CONDITIONPANEL_UNITISUNIT"] = "单位比较"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "此条件在两个文本框输入的单位为同一角色时通过.(例子:文本框1为'targettarget',文本框2为'player',当'目标的目标'为'玩家'时则此条件通过. )"
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "在此文本框输入需要与所指定的第一单位进行比较的第二单位."
L["CONDITIONPANEL_UNITRACE"] = "单位种族"
L["CONDITIONPANEL_UNITSPEC"] = "单位专精"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "选择专精..."
L["CONDITIONPANEL_UNITSPEC_DESC"] = "此条件仅可用于战场跟竞技场。"
L["CONDITIONPANEL_VALUEN"] = "取值"
L["CONDITIONPANEL_VEHICLE"] = "单位控制载具"
L["CONDITIONPANEL_ZONEPVP"] = "区域PvP类型"
L["CONDITIONPANEL_ZONEPVP_DESC"] = "检测区域的PvP类型（例如：争夺中、圣域、战斗区域等）"
L["CONDITIONPANEL_ZONEPVP_FFA"] = "自由PVP"
L["CONDITIONS"] = "条件"
L["CONFIGMODE"] = "TellMeWhen正处于设置模式. 在离开设置模式之前,图标无法正常使用. 输入'/tellmewhen'或'/tmw'可以开启或关闭设置模式."
L["CONFIGMODE_EXIT"] = "退出设置模式"
L["CONFIGMODE_EXITED"] = "TMW已锁定。输入/tmw重新进入设置模式。"
L["CONFIGMODE_NEVERSHOW"] = "不再显示此信息"
L["CONFIGPANEL_BACKDROP_HEADER"] = "背景材质"
L["CONFIGPANEL_CBAR_HEADER"] = "计时条覆盖"
L["CONFIGPANEL_CLEU_HEADER"] = "战斗事件"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "条件计时器"
L["CONFIGPANEL_COMM_HEADER"] = "通讯"
L["CONFIGPANEL_MEDIA_HEADER"] = "媒体"
L["CONFIGPANEL_PBAR_HEADER"] = "能量条覆盖"
L["CONFIGPANEL_TIMER_HEADER"] = "计时器时钟"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "计时条"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s 将被删除."
L["CONFIRM_DELGROUP"] = "删除分组"
L["CONFIRM_DELLAYOUT"] = "删除样式"
L["CONFIRM_HEADER"] = "确定？"
L["COPYGROUP"] = "复制分组"
L["COPYPOSSCALE"] = "仅复制位置/比例"
L["CrowdControl"] = "控场技能"
L["Curse"] = "诅咒"
L["DamageBuffs"] = "信春哥(伤害性增益)"
L["DamageShield"] = "伤害护盾"
L["DBRESTORED_INFO"] = [=[TellMeWhen检测到数据库为空或者已损坏。 造成这个最可能的原因是WoW没有正常退出。

TellMeWhen_Options对数据库多备份了一次，以防止这样的情况发生，因为很少会出现TellMeWhen和TellMeWhen_Options的数据库同时损坏。

你这个创建于%s的备份已还原。]=]
L["DEBUFFTOCHECK"] = "要检测的减益"
L["DEBUFFTOCOMP1"] = "进行比较的第一个减益"
L["DEBUFFTOCOMP2"] = "进行比较的第二个减益"
L["DEFAULT"] = "默认值"
L["DefensiveBuffs"] = "信春哥(防御性增益)"
L["DefensiveBuffsAOE"] = "AOE 减伤 Buffs"
L["DefensiveBuffsSingle"] = "单体减伤 Buffs"
L["DESCENDING"] = "降序"
L["DISABLED"] = "已停用"
L["Disease"] = "疾病"
L["Disoriented"] = "被魅惑"
L["DOMAIN_GLOBAL"] = "|cff00c300共用|r"
L["DOMAIN_PROFILE"] = "角色配置"
L["DOWN"] = "下"
L["DR-Disorient"] = "迷惑/其他"
L["DR-Incapacitate"] = "瘫痪"
L["DR-Root"] = "定身"
L["DR-Silence"] = "沉默"
L["DR-Stun"] = "击晕"
L["DR-Taunt"] = "嘲讽"
L["DT_DOC_AuraSource"] = "返回图标检测的增益/减益的来源单位。最好同[Name]标签一起使用。(此标签仅能用于图标类型：%s)。"
L["DT_DOC_Counter"] = "返回TellMeWhen计数器的值。图标通知消息会创建或修改计数器。"
L["DT_DOC_Destination"] = "返回图标最后一次处理的战斗事件中的目标单位或名称.和[Name]标签一起使用效果更佳.(此标签仅可用于图标类型%s)"
L["DT_DOC_Duration"] = "返回图标当前的剩余持续时间.推荐你使用[TMWFormatDuration]."
L["DT_DOC_Extra"] = "返回图标最后一次处理过的战斗事件中的额外法术名称.（此标签仅可用于图标类型%s）"
L["DT_DOC_gsub"] = [=[提供给力的Lua函数string.gsub来处理DogTags输出的字符串。

替换当前值在匹配模式中的所有实例，可使用可选参数限制替换数目。]=]
L["DT_DOC_IsShown"] = "返回一个图标是否显示."
L["DT_DOC_LocType"] = "返回图标所显示的失去控制的效果类型.(此标签仅可用于图标类型%s)"
L["DT_DOC_MaxDuration"] = "返回当前图标的最大持续时间。 这个持续时间是指刚开始时的持续时间，不是当前剩余的持续时间。"
L["DT_DOC_Name"] = "返回单位的名称.这是一个由DogTag提供的默认[Name]标签的加强版本."
L["DT_DOC_Opacity"] = "返回一个图标的不透明度. 返回值为0到1之间的数字."
L["DT_DOC_PreviousUnit"] = "返回图标检测过的上一个单位或单位名称(相对于与当前检查单位来讲).和[Name]标签一起使用效果更佳."
L["DT_DOC_Source"] = "返回图标最后一次处理过的战斗事件中的来源单位或名称.和[Name]标签一起使用效果更佳.(此标签仅可用于图标类型%s)"
L["DT_DOC_Spell"] = "返回图标当前显示数据的物品名称或法术名称."
L["DT_DOC_Stacks"] = "返回图标当前的叠加数量"
L["DT_DOC_strfind"] = [=[提供给力的Lua函数string.find来处理DogTags输出的字符串。

返回当前值中从第几位开始出现的第一次匹配的具体位置。]=]
L["DT_DOC_StripServer"] = "从单位名字移除服务器名称。这将会移除名字的破折号之后的所有文字。"
L["DT_DOC_Timer"] = "返回TellMeWhen计时器的值。计时器一般在图标的通知事件中被创建或更改。"
L["DT_DOC_TMWFormatDuration"] = "返回一个由TellMeWhen的时间格式处理过的字符串​​.用于替代[FormatDuration]."
L["DT_DOC_Unit"] = "返回当前图标所检查的单位或单位名称.同[Name]标签一起使用效果更佳."
L["DT_DOC_Value"] = "返回图标当前显示的数字，此功能仅在小部分图标类型使用。"
L["DT_DOC_ValueMax"] = "返回图标当前显示的数字的初始最大值，此功能仅在小部分图标类型使用。"
L["DT_INSERTGUID_GENERIC_DESC"] = "如果你想要在一个图标上显示另外一个图标的信息，可以 |cff7fffffShift+鼠标点击|r那个图标將它的唯一标识符添加到标签参数icon中即可。"
L["DT_INSERTGUID_TOOLTIP"] = "|cff7fffffShift+鼠标点击|r将这个图标的标识符插入到DogTag。"
L["DURATION"] = "持续时间"
L["DURATIONALPHA_DESC"] = [=[设置在你要求的持续时间不符合时图标显示的不透明度.

此选项会在勾选%s时自动忽略。]=]
L["DURATIONPANEL_TITLE2"] = "持续时间限制"
L["EARTH"] = "大地图腾"
L["ECLIPSE_DIRECTION"] = "月蚀方向"
L["elite"] = "精英"
L["ENABLINGOPT"] = "TellMeWhen设置已禁用.重新启用中...."
L["ENCOUNTERTOCHECK"] = "用于检测的首领战"
L["ENCOUNTERTOCHECK_DESC_BIGWIGS"] = "输入首领战的全名。在BigWig的设置跟地下城手册中都有显示。"
L["ENCOUNTERTOCHECK_DESC_DBM"] = "输入首领战的全名。在聊天的拉怪、灭团、杀死或者在地下城手册中有显示。"
L["Enraged"] = "激怒"
L["EQUIPSETTOCHECK"] = "用于检测的套装名称(|cFFFF5959区分大小写|r)"
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "无法在战斗中这么做,请先启用%q选项(输入'/tmw options'或'/tmw 选项')."
L["ERROR_ANCHOR_CYCLICALDEPS"] = "%s尝试依附到%s，但是%s的位置依赖于%s的位置，为了防止出错TellMeWhen会将它重置到屏幕的中央。"
L["ERROR_ANCHORSELF"] = "%s尝试附着于它自己, 所以TellMeWhen会重置它的附着位置到屏幕中间以防止出现严重的错误."
L["ERROR_INVALID_SPELLID2"] = "一个图标正在检测一个无效的法术ID: %s. 为免图标发生错误,请移除它!"
L["ERROR_MISSINGFILE"] = "TellMeWhen需要在重开魔兽世界之后才能正常使用%s (原因:无法找到 %s ). 你要马上重开魔兽世界吗?"
L["ERROR_MISSINGFILE_NOREQ"] = "TellMeWhen需要在重开魔兽世界之后才能完全正常使用%s (原因:无法找到 %s ). 你要马上重开魔兽世界吗?"
L["ERROR_MISSINGFILE_OPT"] = [=[需要在重开魔兽世界之后才能设置TellMeWhen %s。

原因：无法找到%s。

你要马上重开魔兽世界吗？ ]=]
L["ERROR_MISSINGFILE_OPT_NOREQ"] = [=[可能需要在重开魔兽世界之后才能全面设置TellMeWhen %s。

原因：无法找到%s。

你要马上重开魔兽世界吗？ ]=]
L["ERROR_MISSINGFILE_REQFILE"] = "一个必需的文件"
L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "无法在战斗中解锁TellMeWhen,请先启用%q选项(输入'/tmw options'或'/tmw 选项')."
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "插件初始化失败,TellMeWhen不能执行该步骤."
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "插件初始化失败,TellMeWhen_Options无法加载."
L["ERROR_NOTINITIALIZED_OPT_NO_ACTION"] = "如果插件初始化失败，TellMeWhen_Options将无法执行该动作！"
L["ERRORS_FRAME"] = "错误框架"
L["ERRORS_FRAME_DESC"] = "输出文字到系统的错误框架,就是显示%q那个位置."
L["EVENT_CATEGORY_CHANGED"] = "数据已改变"
L["EVENT_CATEGORY_CHARGES"] = "充能"
L["EVENT_CATEGORY_CLICK"] = "交互"
L["EVENT_CATEGORY_CONDITION"] = "条件"
L["EVENT_CATEGORY_MISC"] = "其他"
L["EVENT_CATEGORY_STACKS"] = "叠加层数"
L["EVENT_CATEGORY_TIMER"] = "计时器"
L["EVENT_CATEGORY_VISIBILITY"] = "显示方式"
L["EVENT_FREQUENCY"] = "触发频率"
L["EVENT_FREQUENCY_DESC"] = "设置条件通过的触发频率（单位为秒）。"
L["EVENT_WHILECONDITIONS"] = "触发条件"
L["EVENT_WHILECONDITIONS_DESC"] = "点击设置条件，当它们通过时会触发通知事件。"
L["EVENT_WHILECONDITIONS_TAB_DESC"] = "设置触发通知事件需要的条件。"
L["EVENTCONDITIONS"] = "事件条件"
L["EVENTCONDITIONS_DESC"] = "点击进入设置用于触发此事件的条件."
L["EVENTCONDITIONS_TAB_DESC"] = "设置的条件通过时则触发此事件."
L["EVENTHANDLER_COUNTER_TAB"] = "计数器"
L["EVENTHANDLER_COUNTER_TAB_DESC"] = "配置一个计数器。此计数器可用于条件中检测或DogTags标签中显示文字。"
L["EVENTHANDLER_LUA_CODE"] = "用于执行的Lua代码"
L["EVENTHANDLER_LUA_CODE_DESC"] = "在此输入事件触发后需要执行的Lua代码."
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua事件: %s"
L["EVENTHANDLER_LUA_TAB"] = "Lua(高玩级)"
L["EVENTHANDLER_LUA_TAB_DESC"] = "设置用于执行的Lua脚本。这是一个高端的功能，需要有Lua语言编程基础。"
L["EVENTHANDLER_TIMER_TAB"] = "计时器"
L["EVENTHANDLER_TIMER_TAB_DESC"] = "设置一个时钟样式的计时器。此计时器可以使用条件及显示文字到DogTags。"
L["EVENTS_CHANGETRIGGER"] = "更改触发器"
L["EVENTS_CHOOSE_EVENT"] = "选择触发器："
L["EVENTS_CHOOSE_HANDLER"] = "选择通知事件："
L["EVENTS_CLONEHANDLER"] = "克隆"
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffff点击|r添加这个通知事件。"
L["EVENTS_HANDLERS_ADD"] = "添加通知事件..."
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffff点击|r选择一个通知事件添加到此图标,"
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffff点击|r打开通知事件选项.
|cff7fffff右键点击|r克隆或更改事件的触发.
|cff7fffff点击并拖拽|r来更改排序.]=]
L["EVENTS_HANDLERS_HEADER"] = "通知事件处理器"
L["EVENTS_HANDLERS_PLAY"] = "测试通知事件"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffff点击|r测试通知事件"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "仅在条件刚通过时"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "除非上面设置的条件刚刚成功通过,否则阻止通知事件的触发."
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "值"
L["EVENTS_SETTINGS_COUNTER_AMOUNT_DESC"] = "输入你想要检测的计数器被创建或修改的值。"
L["EVENTS_SETTINGS_COUNTER_HEADER"] = "计数器设置"
L["EVENTS_SETTINGS_COUNTER_NAME"] = "计数器名称"
L["EVENTS_SETTINGS_COUNTER_NAME_DESC"] = [=[输入计数器的名称。如果计数器不存在，它的初始值则为0。

计数器名称必须为小写，并且不能有空格。

你也可以在其它地方检测这个计数器,在条件检测或DogTags的文字显示标签[Counter]中。

高玩用户：计数器储存在TMW.COUNTERS[counterName] = value中。如果你想在自定义Lua语言脚本中更改一个计数器可调用 TMW:Fire( "TMW_COUNTER_MODIFIED", counterName )。]=]
L["EVENTS_SETTINGS_COUNTER_OP"] = "运算符"
L["EVENTS_SETTINGS_COUNTER_OP_DESC"] = "选择计数器要执行的运算符"
L["EVENTS_SETTINGS_HEADER"] = "触发设置"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "仅在图标显示时触发"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "勾选此项防止图标在没有显示时触发相关通知事件."
L["EVENTS_SETTINGS_PASSINGCNDT"] = "仅在条件通过时触发:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "除非下面设置的条件成功通过,否则阻止通知事件的触发."
L["EVENTS_SETTINGS_PASSTHROUGH"] = "允许触发其他事件"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[勾选允许在触发该通知事件后去触发另一个事件,如果不勾选,则在该事件触发并输出了文字/音效之后,图标将不再处理同时触发的其他任何通知事件.

可以有例外,详情请参阅个别事件的描述.]=]
L["EVENTS_SETTINGS_SIMPLYSHOWN"] = "仅在图标显示时触发"
L["EVENTS_SETTINGS_SIMPLYSHOWN_DESC"] = [=[让通知事件在图标显示时触发。

你可以在不设置条件的情况下启用此选项来触发事件。

或者你也可以加上条件来决定如何触发。]=]
L["EVENTS_SETTINGS_TIMER_HEADER"] = "计时器设置"
L["EVENTS_SETTINGS_TIMER_NAME"] = "计时器名称"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [=[输入你需要修改的计时器名称。

计时器名称必须为小写字母并且不能有空格。

此计时器使用的名称可以在其它任何地方来检测（条件和文本显示，像是DogTag中的[Timer]）]=]
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "选择你想要计时器使用的运算符"
L["EVENTS_TAB"] = "通知事件"
L["EVENTS_TAB_DESC"] = "设置声音/文字输出/动画的触发器."
L["EXPORT_ALLGLOBALGROUPS"] = "所有|cff00c300共用|r分组"
L["EXPORT_f"] = "导出 %s"
L["EXPORT_HEADING"] = "导出"
L["EXPORT_SPECIALDESC2"] = "其他TellMeWhen使用者只能在他们所使用的版本高于或等于%s时才能导入这些数据."
L["EXPORT_TOCOMM"] = "到玩家"
L["EXPORT_TOCOMM_DESC"] = [=[输入一个玩家的名字到编辑框同时选择此选项来发送数据给他们.他们必须是你能密语的某人(同阵营,同服务器,在线),同时他们必须已经安装版本为4.0.0+的TellMeWhen.

你还可以输入"GUILD"或"RAID"发送到整个公会或整个团队(输入时请注意区分大小写,'GUILD'跟'RAID'中的英文字母全部都是大写).]=]
L["EXPORT_TOGUILD"] = "到公会"
L["EXPORT_TORAID"] = "到团队"
L["EXPORT_TOSTRING"] = "到字符串"
L["EXPORT_TOSTRING_DESC"] = "包含必要数据的字符串将导出到编辑框里,按下CTRL+C复制它,然后到任何你想分享的地方贴上它."
L["FALSE"] = "否"
L["fCODESNIPPET"] = "代码片段: %s"
L["Feared"] = "被恐惧"
L["fGROUP"] = "分组: %s"
L["fGROUPS"] = "分组：%s"
L["fICON"] = "图标: %s"
L["FIRE"] = "火焰图腾"
L["FONTCOLOR"] = "文字颜色"
L["FONTSIZE"] = "字体大小"
L["FORWARDS_IE"] = "转到下一个"
L["FORWARDS_IE_DESC"] = [=[载入下一个编辑过的图标

%s |T%s:0|t]=]
L["fPROFILE"] = "配置文件: %s"
L["FROMNEWERVERSION"] = "你导入的数据为版本较新的TellMeWhen所创建,某些设置在更新至最新版本之前可能无法正常使用."
L["fTEXTLAYOUT"] = "文字显示样式: %s"
L["GCD"] = "公共冷却"
L["GCD_ACTIVE"] = "公共冷却作用中"
L["GENERIC_NUMREQ_CHECK_DESC"] = "勾选以启用并配置%s"
L["GENERICTOTEM"] = "图腾 %d"
L["GLOBAL_GROUP_GENERIC_DESC"] = "|cff00c300共用分组|r是指在你这个魔兽世界帐号中的TellMeWhen配置文件的所有角色都可共同使用的分组。"
L["GLYPHTOCHECK"] = "要检测的雕文"
L["GROUP"] = "分组"
L["GROUP_UNAVAILABLE"] = "|TInterface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent:20|t 由于其过度限制的规范/角色设置，此组无法显示。"
L["GROUPCONDITIONS"] = "分组条件"
L["GROUPCONDITIONS_DESC"] = "设置条件进行微调,以便更好的显示这个分组."
L["GROUPICON"] = "分组:%s ，图标:%s"
L["GROUPSELECT_TOOLTIP"] = [=[|cff7fffff点击|r 来编辑。

|cff7fffff点击拖拽|r 重新排序或更改域。]=]
L["GROUPSETTINGS_DESC"] = "设置此分组。"
L["GUIDCONFLICT_DESC_PART1"] = [=[TellMeWhen检测到下列的对象拥有相同的全局唯一标识符（GUID）。如果你从它们其中之一调用数据可能会发生料想不到问题（例如：将它们之中的一个加入到整合图标中）。

为了解决这个问题，请选择某个对象重新生成GUID，原有的调用都将指向到那个你没有重新生成GUID的对象。你可能需要适当调整你的设置确保所有东西都能正常使用。]=]
L["GUIDCONFLICT_DESC_PART2"] = "你也可以自行解决这个问题（例如：删除两个之中的某一个）。"
L["GUIDCONFLICT_IGNOREFORSESSION"] = "忽略该设置进程冲突。"
L["GUIDCONFLICT_REGENERATE"] = "为%s重新生成GUID"
L["Heals"] = "玩家治疗法术"
L["HELP_ANN_LINK_INSERTED"] = [=[你插入的链接看起来很诡异,可能是因为DogTag的格式转换所引起.

如果输出到暴雪频道时链接无法正常显示,请更改颜色代码.]=]
L["HELP_BUFF_NOSOURCERPPM"] = [=[看来你想检测%s，这个增益使用了RPPM系统。

由于暴雪的bug，在启用了%q选项时，这个增益无法被检测。

如果你想正确检测这个增益，请禁用该设置。]=]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [=[你可以选择两个条件都需要通过,还是只需要某个条件通过.

|cff7fffff点击|r此处更改条件之间的关联方式,以达到你所需的检测效果.]=]
L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [=[你可以组合多个条件执行复杂的检测功能,尤其是连同%q选项一起使用.

|cff7fffff点击|r括号将条件组合在一起,以达到你需要的检测效果(左右括号中间的条件就是一个条件组合).]=]
L["HELP_COOLDOWN_VOIDBOLT"] = [=[看起来你是想检测|TInterface/Icons/ability_ironmaidens_convulsiveshadows:20|t %s的冷却时间。

非常不幸的是暴雪的机制使它无法正常被监测到。

你需要检测的是 |T1386548:20|t %s 的冷却时间。

请添加一个条件检测增益 %s ，如果你仅仅是想检测 %s 是否可以使用的话。]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "按下|cff7fffffCMD+C|r复制"
L["HELP_EXPORT_DOCOPY_WIN"] = "按下|cff7fffffCTRL+C|r复制"
L["HELP_EXPORT_MULTIPLE_COMM"] = "导出的数据包括主要数据所需要的额外数据。想要知道包含了哪些内容，请导出相同数据到字符串后在导入菜单的“来自字符串”查看即可。"
L["HELP_EXPORT_MULTIPLE_STRING"] = [=[导出的数据包括主要数据所需要的额外数据。想要知道包含了哪些内容，请导出相同数据到字符串后在导入菜单的“来自字符串”查看即可。

TellMeWhen版本7.0.0+的使用者可以一次导入所有数据。其他人需要分开多次导入字符串。]=]
L["HELP_FIRSTUCD"] = [=[这是你第一次使用一个采取特定时间语法的图标类型!
在添加法术到某些图标类型的 %q 编辑框时,必须使用下列语法在法术后面指定它们的冷却时间/持续时间:

法术:时间

例如:

"%s: 120"
"%s: 10;%s: 24"
"%s: 180"
"%s: 3:00"
"62618: 3:00"

用建议列表插入条目时会自动添加在鼠标提示信息中显示的时间(译者注:自动添加时间功能支持提示信息中有显示冷却时间的法术以及提示信息中有注明持续时间的大部分法术,如果一个法术同时存在上述两种时间,会优先选择添加冷却时间,假如自动添加的时间不正确,请自行手动更改).]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[尝试在这个配置文件中移动或复制一个图标到另外一个图标栏位吗?

你可以轻松的做到这一点,使用|cff7fffff鼠标右键点击图标并拖拽|r它到另外一个图标栏位(这个过程需要按下鼠标右键不放开). 当你放开鼠标右键时,会出现一个有很多选项的选单.

尝试拖拽一个图标到整合图标,其他分组,或在你屏幕上的其他框架以获取其他相应的选项.]=]
L["HELP_MISSINGDURS"] = [=[以下法术缺少持续时间/冷却时间:

%s

请使用下列语法添加时间:

法术:时间

例如"%s: 10"

用建议列表插入条目时会自动添加在鼠标提示信息中显示的时间(译者注:自动添加时间功能支持提示信息中有显示冷却时间的法术以及提示信息中有注明持续时间的大部分法术,如果一个法术同时存在上述两种时间,会优先选择添加冷却时间,假如自动添加的时间不正确,请自行手动更改).]=]
L["HELP_NOUNIT"] = "你必须输入一个单位!"
L["HELP_NOUNITS"] = "你至少需要输入一个单位!"
L["HELP_ONLYONEUNIT"] = "条件只允许检测一个单位，你已经输入了%d个单位。"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t -- 关于怀表材质

此材质用于第一个检测到的有效法术在你的法术书中不存在时.

正确的材质将会在你施放过一次或者见到过一次该法术之后使用.

若要显示正确的材质,请把第一个被检测的法术名称更改为法术ID.你可以轻松的做到这一点,你只需要点击名称编辑框中的法术,再根据之后出现的建议列表中显示的正确的以及相对应的法术上点击鼠标右键即可.

(这里的法术指排在首位的法术,当你的鼠标移动到建议列表的某个法术上时,在提示信息中可以看到更为具体的鼠标左右键插入法术ID或法术名称的方法.)]=]
L["HELP_SCROLLBAR_DROPDOWN"] = [=[一些TellMeWhen的下拉菜单有滚动条。

你可以拖动滚动条来查看菜单的全部内容。

你也可以使用鼠标滚轮。]=]
L["ICON"] = "图标"
L["ICON_TOOLTIP_CONTROLLED"] = "此图标被这分组的第一个图标接管。你不能单独修改它。"
L["ICON_TOOLTIP_CONTROLLER"] = "此图标具有分组控制功能。"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffff点击鼠标右键|r进入图标设置.
|cff7fffff点击鼠标右键并拖拽|r 移动/复制 到另一个图标.
|cff7fffff拖拽|r法术或者物品到图标上进行快速设置.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffff点击鼠标右键|r进入图标设置."
L["ICONALPHAPANEL_FAKEHIDDEN"] = "始终隐藏"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[使该图标一直被隐藏,但图标依然会处理并执行音效和文字输出,而且仍然可以让包含该图标的条件或者整合图标进行检测.

|cff7fffff-|r此图标能一直检测其他图标的条件。
|cff7fffff-|r 整合图标能显示这个图标。
|cff7fffff-|r 此图标的通知事件会继续处理运行。]=]
L["ICONCONDITIONS_DESC"] = "设置条件进行微调,以便更好的显示图标."
L["ICONGROUP"] = "图标: %s (分组: %s)"
L["ICONMENU_ABSENT"] = "不存在"
L["ICONMENU_ABSENTEACH"] = "没有施法的单位"
L["ICONMENU_ABSENTEACH_DESC"] = [=[设置单位没有任何施法时的图标透明度。

如果此选项未设置成隐藏并且检测到有一个单位存在时，%s选项不会运作。]=]
L["ICONMENU_ABSENTONALL"] = "全都缺少"
L["ICONMENU_ABSENTONALL_DESC"] = "设置在检测的所有单位中不存在任何一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_ABSENTONANY"] = "任一缺少"
L["ICONMENU_ABSENTONANY_DESC"] = "设置在检测的所有单位中只要其中之一不存在任何一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_ADDMETA"] = "添加到'整合图标'"
L["ICONMENU_ALLOWGCD"] = "允许公共冷却"
L["ICONMENU_ALLOWGCD_DESC"] = "勾选此项允许冷却时钟显示公共冷却,而不是忽略它."
L["ICONMENU_ALLSPELLS"] = "所有法术技能可用"
L["ICONMENU_ALLSPELLS_DESC"] = "当此图标正在跟踪的所有法术准备好在特定单位上时，此状态处于活动状态。"
L["ICONMENU_ANCHORTO"] = "附着到 %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[附着%s到%s,无论%s如何移动,%s都会跟随它一起移动.

分组选项中有更为详细的附着设置.]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "重置附着"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[让%s重新附着到你的屏幕(UIParent).它目前附着到%s.

分组选项中有更为详细的附着设置.

分组选项中有更为详细的附着设置.]=]
L["ICONMENU_ANYSPELLS"] = "任意法术技能可用"
L["ICONMENU_ANYSPELLS_DESC"] = "当被该图标跟踪的法术中的至少一个准备好在特定单元上时，该状态是活动的。"
L["ICONMENU_APPENDCONDT"] = "添加到'图标显示'条件"
L["ICONMENU_BAR_COLOR_BACKDROP"] = "背景颜色/透明度"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "设置计量条后的背景颜色和透明度。"
L["ICONMENU_BAR_COLOR_COMPLETE"] = "完成颜色"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "计量条在冷却、持续时间完成时的颜色。"
L["ICONMENU_BAR_COLOR_MIDDLE"] = "过半颜色"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "计量条在冷却、持续时间过半时的颜色。"
L["ICONMENU_BAR_COLOR_START"] = "起始颜色"
L["ICONMENU_BAR_COLOR_START_DESC"] = "计量条在冷却、持续时间起始时的颜色。"
L["ICONMENU_BAROFFS"] = [=[此数值将会添加到计量条以便用来调整它的偏移值.

一些有用的例子:
当你开始施法时防止一个增益消失的自订指示器,或者用来指示某个法术施放所需能量的同时还剩多少时间可以打断施法.]=]
L["ICONMENU_BOTH"] = "任意一种"
L["ICONMENU_BUFF"] = "增益"
L["ICONMENU_BUFFCHECK"] = "增益/减益检测"
L["ICONMENU_BUFFCHECK_DESC"] = [=[检测你所设置的单位是否缺少某个增益.

可使用这个图标类型来检测缺少的团队增益(像是耐力之类).

其他情况应使用图标类型%q.]=]
L["ICONMENU_BUFFDEBUFF"] = "增益/减益"
L["ICONMENU_BUFFDEBUFF_DESC"] = "检测增益或减益."
L["ICONMENU_BUFFTYPE"] = "增益或减益"
L["ICONMENU_CAST"] = "法术施放"
L["ICONMENU_CAST_DESC"] = "检测非瞬发施法跟引导法术."
L["ICONMENU_CHECKNEXT"] = "扩展子元"
L["ICONMENU_CHECKNEXT_DESC"] = [=[选中此框该图标将检测添加在列表中的任意整合图标所包含的全部图标,它可能是任何级别的检测.

此外,该图标不会显示已经在另一个整合图标显示的任何图标.

译者注:因为很多人不明白这个功能,举个例子,假设你有3个设置完全一样的整合图标(每个图标中都是图标1 图标2 图标3),全部都勾上了这个选项,如果在整合图标中图标1 图标2 图标3都可以显示,显示顺序为图标3>图标1>图标2,那么在整合图标1将会显示图标3,整合图标2则是显示图标1,整合图标3显示图标2(理论上就是这样的效果,一些细节请自行钻研).]=]
L["ICONMENU_CHECKREFRESH"] = "法术刷新侦测"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[暴雪的战斗记录在涉及法术刷新和恐惧（或者某些在造成一定伤害量后才会中断的法术）存在严重缺陷，战斗记录会认为法术在造成伤害时已经刷新，尽管事实上并非如此。

取消此选项以便停用法术刷新侦测，注意：正常的刷新也将被忽略。

如果你检测的递减在造成一定伤害量后不会中断的话建议保留此选项。]=]
L["ICONMENU_CHOOSENAME_EVENTS"] = "选择用于检测的消息"
L["ICONMENU_CHOOSENAME_EVENTS_DESC"] = [=[输入你想要图标检测的错误消息。你可以利用';'(分号)输入多个条目。

错误信息必须完全匹配，不区分大小写。]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[输入你想要此图标监视的 名称/ID/装备栏编号. 你可以利用分号添加多个条目(名称/ID/装备栏编号的任意组合).

装备栏编号是已装备物品所在栏位的编号索引.即使你更换了那个装备栏的已装备物品,也不会影响图标的正常使用.

你可以|cff7fffff按住Shift再按鼠标左键点选|r物品/聊天连结 或者拖曳物品添加此编辑框中.]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "或者保留空白检测所有"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[输入你想要此图标监视的暂时性武器附魔的名称. 你可以利用分号(;)添加多个条目.

|cFFFF5959重要提示|r: 附魔名称必须使用在暂时性武器附魔激活时出现在武器的提示信息中的那个名称(例如:"%s", 而不是"%s").

译者注:大陆版魔兽世界中的部分标点符号用的是全角标点,在这里需要使用的就是全角括号.]=]
L["ICONMENU_CHOOSENAME3"] = "监视什么"
L["ICONMENU_CHOSEICONTODRAGTO"] = "选择一个图标拖拽到："
L["ICONMENU_CHOSEICONTOEDIT"] = "选择一个图标来修改:"
L["ICONMENU_CLEU"] = "战斗事件"
L["ICONMENU_CLEU_DESC"] = [=[检测战斗事件.

包括了像是法术反射,未命中,瞬发施法以及死亡等等. 
实际上图标能检测所有的战斗事件(包括上述的例子以及其他没有提到的战斗事件).]=]
L["ICONMENU_CLEU_NOREFRESH"] = "不刷新"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "勾选后在图标的计时器作用时不会再触发事件."
L["ICONMENU_CNDTIC"] = "条件图标"
L["ICONMENU_CNDTIC_DESC"] = "检测条件的状态."
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d个条件)"
L["ICONMENU_COMPONENTICONS"] = "组件图标&分组"
L["ICONMENU_COOLDOWNCHECK"] = "冷却检测"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "勾选此项启用当可用技能在冷却中时视为不可用."
L["ICONMENU_COPYCONDITIONS"] = "复制 %d 个条件"
L["ICONMENU_COPYCONDITIONS_DESC"] = "复制%s的%d个条件到%s。"
L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"] = "这将会覆盖已存在的%d个的条件。"
L["ICONMENU_COPYCONDITIONS_GROUP"] = "复制%d个分组条件"
L["ICONMENU_COPYEVENTHANDLERS"] = "复制 %d 个通知事件"
L["ICONMENU_COPYEVENTHANDLERS_DESC"] = "复制%s的%d个通知事件到%s。"
L["ICONMENU_COPYHERE"] = "复制到此"
L["ICONMENU_COUNTING"] = "倒数中"
L["ICONMENU_CTRLGROUP"] = "分组控制图标"
L["ICONMENU_CTRLGROUP_DESC"] = [=[启用此选项让这个图标控制整个分组。

如果启用，将使用这个图标的数据填充这个分组。

该分组中的其他图标都不能进行单独设置。

当你需要快速定制分组的布局、样式或者排列选项，可以选择使用它控制分组。]=]
L["ICONMENU_CTRLGROUP_UNAVAILABLE_DESC"] = "当前图标类型不能控制整个分组。"
L["ICONMENU_CTRLGROUP_UNAVAILABLEID_DESC"] = "只有组中的第一个图标（图标ID 1）可以是组控制器。"
L["ICONMENU_CUSTOMTEX"] = "自定义图标材质"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[你可以使用下列方法更改这个图标的显示材质：

|cff00d1ff法术材质|r
你可以输入一个材质路径, 例如'Interface/Icons/spell_nature_healingtouch', 假如材质路径为'Interface/Icons'可以只输入'spell_nature_healingtouch'.

|cff00d1ff空白(透明无材质)|r
输入none或blank后,图标将透明显示,不再使用任何材质.

|cff00d1ff物品栏|r
你可以在此编辑框输入"$"(美元符)浏览一个动态材质列表.

|cff00d1ff自定义|r
|cffff0000你也能使用放在WoW下的子目录中的自定义材质(请在该字段输入材质的相对路径,像是'tmw/ccc.tga'),仅支持尺寸为2的N次方(32, 64, 128,等)并且类型为.tga和.blp的材质文件.]=]
L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = [=[|cff00d1ff错误解决|r
|TNULL:0|t在自定义了某个材质后图标显示成绿色的话,请看看后面的两种可能性,如果你所指定的材质在WOW主目录(跟WOW.exe相同的目录)下面,请把材质移动到某个子目录(珍爱生命,远离WOW.exe)下即可正常使用(请关闭WOW之后再进行上面的操作),如果你使用的是某个特定的法术图标作为材质,那可能是因为暴雪移除或者更改了它们(它们原来的ID或名称已经不存在),请重新输入另一个你要用于自定义材质的法术名称或法术ID. ]=]
L["ICONMENU_DEBUFF"] = "减益"
L["ICONMENU_DISPEL"] = "驱散类型"
L["ICONMENU_DONTREFRESH"] = "不刷新"
L["ICONMENU_DONTREFRESH_DESC"] = "勾选此项在图标仍然倒数的时候触发效果将强制不重置冷却时间."
L["ICONMENU_DOTWATCH"] = "所有单位的增益/减益"
L["ICONMENU_DOTWATCH_AURASFOUND_DESC"] = "设置图标在被检测的任意单位有任意增益/减益时的透明度。"
L["ICONMENU_DOTWATCH_DESC"] = [=[尝试检测你所选的所有单位的增益、减益。

在检测多个法术效果时比较有用。

这个图标类型必须使用分组控制器 - 它不能是一个单独图标。]=]
L["ICONMENU_DOTWATCH_GCREQ"] = "必须为分组控制器"
L["ICONMENU_DOTWATCH_GCREQ_DESC"] = [=[此图标类型必须使用分组控制器来运作。你不能单独使用它。

请创建一个图标并且设置为分组控制器，他必须是分组中第一个图标（例如，他的图标ID为1），再启用%q选项，它在勾选框%q附近。
]=]
L["ICONMENU_DOTWATCH_NOFOUND_DESC"] = "设置在无法找到检测的增益/减益时图标的透明度。"
L["ICONMENU_DR"] = "递减"
L["ICONMENU_DR_DESC"] = "检测递减时间跟递减程度."
L["ICONMENU_DRABSENT"] = "未递减"
L["ICONMENU_DRPRESENT"] = "已递减"
L["ICONMENU_DRS"] = "递减"
L["ICONMENU_DURATION_MAX_DESC"] = "允许图标显示的最大持续时间,高于此数值图标将被隐藏."
L["ICONMENU_DURATION_MIN_DESC"] = "显示图标所需的最小持续时间,低于此数值图标将被隐藏."
L["ICONMENU_ENABLE"] = "启用"
L["ICONMENU_ENABLE_DESC"] = "图标需要在启用后才会起作用."
L["ICONMENU_ENABLE_GROUP_DESC"] = "分组在启用时才会正常运作。"
L["ICONMENU_ENABLE_PROFILE"] = "对角色启用"
L["ICONMENU_ENABLE_PROFILE_DESC"] = "取消勾选禁止这个角色使用|cff00c300公共|r分组。"
L["ICONMENU_FAIL2"] = "条件无效"
L["ICONMENU_FAKEMAX"] = "伪最大值"
L["ICONMENU_FAKEMAX_DESC"] = [=[设置计时器的伪最大值.

你可以使用此设置让整组图标以相同的速度进行倒计时.可以让你更清楚的看到哪些计时器先结束.

设置为0则禁用此选项.

译者注:如果你设置为20, 那TellMeWhen显示的计时条的总长度将变成20秒,但是并不影响你实际的计时,事实上法术的持续时间还是10秒,只是倒计时会从那个20秒长的计时条的中间开始.]=]
L["ICONMENU_FOCUS"] = "焦点目标"
L["ICONMENU_FOCUSTARGET"] = "焦点目标的目标"
L["ICONMENU_FRIEND"] = "友好单位"
L["ICONMENU_GROUPUNIT_DESC"] = [=[Group是TellMeWhen中一个特殊的单位，用于你在团队时检测团队成员，或你在队伍时检测队伍成员。

如果你在一个团队中,它不会检查重复的单位(实际上可检测的单位有"player;party;raid",某些时候队伍成员可能会被检测两次，但是它不会。)]=]
L["ICONMENU_GUARDIAN"] = "守护者"
L["ICONMENU_GUARDIAN_CHOOSENAME_DESC"] = [=[输入你需要监视的守护者名字或者NPC ID。

你可以利用分号(;)输入多个单位。]=]
L["ICONMENU_GUARDIAN_DESC"] = [=[检测你当前使用的守护者。 像是术士的小鬼等等。

此图标类型最好使用一个分组控制器。]=]
L["ICONMENU_GUARDIAN_DUR"] = "用于显示持续时间的单位"
L["ICONMENU_GUARDIAN_DUR_EITHER"] = "增效优先"
L["ICONMENU_GUARDIAN_DUR_EITHER_DESC"] = "如果存在增效，则优先显示增效的持续时间。否则将显示守护者的持续时间。"
L["ICONMENU_GUARDIAN_DUR_EMPOWER"] = "仅增效"
L["ICONMENU_GUARDIAN_DUR_GUARDIAN"] = "仅守护者"
L["ICONMENU_GUARDIAN_EMPOWERED"] = "增效"
L["ICONMENU_GUARDIAN_TRIGGER"] = "触发自：%s"
L["ICONMENU_GUARDIAN_UNEMPOWERED"] = "未增效"
L["ICONMENU_HIDENOUNITS"] = "无单位时隐藏"
L["ICONMENU_HIDENOUNITS_DESC"] = "勾选此项可在单位不存在时致使图标检测的所有单位都无效的情况下隐藏该图标(包括单位条件的设置在内)."
L["ICONMENU_HIDEUNEQUIPPED"] = "装备栏缺少武器时隐藏"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "勾选此项在检测的武器栏没有装备武器时强制隐藏图标"
L["ICONMENU_HOSTILE"] = "敌对单位"
L["ICONMENU_ICD"] = "内置冷却"
L["ICONMENU_ICD_DESC"] = [=[检测一个触发效果或与其类似效果的冷却.

|cFFFF5959重要提示|r: 关于如何检测每个类型的内置冷却请参阅在 %q 下方选项的提示信息.]=]
L["ICONMENU_ICDAURA_DESC"] = [=[如果是在下列情况开始内置冷却,请选择此项:

|cff7fffff1)|r在你应用某个减益/获得某个增益以后(包括触发),或是
|cff7fffff2)|r某一效果造成伤害以后,或是
|cff7fffff3)|r在充能效果使你恢复法力值/怒气/等以后,或是
|cff7fffff4)|r你召唤某个东西或者NPC以后.

你需要在 %q 编辑框中输入技能/法术的名称或ID:

|cff7fffff1)|r触发内置冷却的减益/增益,或是
|cff7fffff2)|r造成伤害的某一法术/技能(请查看你的战斗记录),或是
|cff7fffff3)|r使你恢复法力值/怒气/等的充能效果(请查看你的战斗记录),或是
|cff7fffff4)|r触发内置冷却的召唤效果法术/技能(请查看你的战斗记录).

(请查看你的战斗记录或者利用插件来确认法术名称/ID)]=]
L["ICONMENU_ICDBDE"] = "增益/减益/伤害/充能/召唤"
L["ICONMENU_ICDTYPE"] = "何时开始冷却..."
L["ICONMENU_IGNORENOMANA"] = "忽略能量不足"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[勾选此项当一个技能仅仅是因为能量不足而不可用时视该技能为可用.

对于像是%s 或者 %s这类技能很实用.]=]
L["ICONMENU_IGNORERUNES"] = "忽略符文"
L["ICONMENU_IGNORERUNES_DESC"] = [=[勾选此项,在技能冷却已结束,仅仅因为符文冷却(或公共冷却)导致无法施放技能,则视该技能为可用.

译者注:举例说明一下,比如死亡骑士的符文分流冷却时间为30秒,但是30秒冷却结束之后,在没有可用的鲜血符文或死亡符文的情况下会继续显示冷却倒数计时,如果有勾选这个选项,则图标就不会出现继续倒数,直接显示为符文分流可用.]=]
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "\"忽略符文\"必须在\"冷却检测\"已勾选后才可使用."
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "勾选此项以反向的方式填充计量条,会在持续时间到0时填满整个计量条."
L["ICONMENU_INVERTBARS"] = "反转计量条"
L["ICONMENU_INVERTCBAR_DESC"] = "勾选此项使图标上的计时条在持续时间为0时才填满图标的宽度,而不是计时条从填满开始减少."
L["ICONMENU_INVERTPBAR_DESC"] = "勾选此项使图标上的能量条在有足够的能量施法时才填满图标的宽度,而不是计时条从填满开始减少."
L["ICONMENU_INVERTTIMER"] = "反转阴影"
L["ICONMENU_INVERTTIMER_DESC"] = "勾选此项来反转计时器的阴影效果。"
L["ICONMENU_ISPLAYER"] = "单位是玩家"
L["ICONMENU_ITEMCOOLDOWN"] = "物品冷却"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "检测可使用物品的冷却."
L["ICONMENU_LIGHTWELL_DESC"] = "检测你施放的%s的持续时间跟可用次数."
L["ICONMENU_MANACHECK"] = "能量检测"
L["ICONMENU_MANACHECK_DESC"] = [=[勾选此项启用当你魔法值/怒气/符能等等不足时改变图标颜色(或视为不可用).

译者注:除非特別说明,本插件中的能量一般是指法术施放所需的法力/怒气/符能/集中值等等,并非指盗贼/野德鲁伊的能量值.]=]
L["ICONMENU_META"] = "整合图标"
L["ICONMENU_META_DESC"] = [=[组合多个图标到一个图标.

在整合图标中被检测的那些图标即使设置为 %q 在可以显示时同样会显示.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d个图标)"
L["ICONMENU_MOUSEOVER"] = "鼠标悬停目标"
L["ICONMENU_MOUSEOVERTARGET"] = "鼠标悬停目标的目标"
L["ICONMENU_MOVEHERE"] = "移动到此"
L["ICONMENU_NAMEPLATE"] = "姓名板"
L["ICONMENU_NOPOCKETWATCH"] = "未知时显示透明材质"
L["ICONMENU_NOPOCKETWATCH_DESC"] = "勾选此项使用透明材质代替时钟材质。"
L["ICONMENU_NOTCOUNTING"] = "未倒数"
L["ICONMENU_NOTREADY"] = "没有准备好"
L["ICONMENU_OFFS"] = "偏移"
L["ICONMENU_ONCOOLDOWN"] = "冷却中"
L["ICONMENU_ONFAIL"] = "在无效时"
L["ICONMENU_ONLYACTIVATIONOVERLAY"] = "需要激活边框"
L["ICONMENU_ONLYACTIVATIONOVERLAY_DESC"] = "此选项为检测系统默认提示技能可用时的黄色发光边框所需的必要选项。"
L["ICONMENU_ONLYBAGS"] = "只在背包中存在时"
L["ICONMENU_ONLYBAGS_DESC"] = "勾选此项当物品在背包中(或者已装备)时显示图标,如果启用'已装备的物品',此选项会被强制启用。"
L["ICONMENU_ONLYEQPPD"] = "只在已装备时"
L["ICONMENU_ONLYEQPPD_DESC"] = "勾选此项让图标只在物品已装备时显示."
L["ICONMENU_ONLYIFCOUNTING"] = "仅在计时器倒数时显示"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "勾选此项使图标仅在计时器持续时间设置大于0并且正在倒数时显示."
L["ICONMENU_ONLYIFNOTCOUNTING"] = "仅在计时器倒数完毕时显示"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "勾选此项使图标仅在计时器持续时间设置大于0并且倒数完毕时显示."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "仅可打断"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "仅在施法可打断时显示."
L["ICONMENU_ONLYMINE"] = "仅检测自己施放的"
L["ICONMENU_ONLYMINE_DESC"] = "勾选此项让该图标只显示你施放的增益或减益"
L["ICONMENU_ONLYSEEN"] = "仅显示施放过的法术"
L["ICONMENU_ONLYSEEN_ALL"] = "允许所有法术"
L["ICONMENU_ONLYSEEN_ALL_DESC"] = "选中此项以允许为所有检查的单元显示所有功能。"
L["ICONMENU_ONLYSEEN_CLASS"] = "仅单位职业法术、技能"
L["ICONMENU_ONLYSEEN_CLASS_DESC"] = [=[选中此项，只有在已知该单元的类具有该能力时，才允许该图标显示能力。

已知的类法术在建议列表中用蓝色或粉红色突出显示。]=]
L["ICONMENU_ONLYSEEN_DESC"] = "选择此项可以让图标只显示某单位至少施放过一次的法术冷却.如果你想在同一个图标中检测来自不同职业的法术那么应该勾上它."
L["ICONMENU_ONLYSEEN_HEADER"] = "法术筛选"
L["ICONMENU_ONSUCCEED"] = "在通过时"
L["ICONMENU_OO_F"] = "在 %s 之外"
L["ICONMENU_OOPOWER"] = "没有能量"
L["ICONMENU_OORANGE"] = "超出范围"
L["ICONMENU_PETTARGET"] = "宠物的目标"
L["ICONMENU_PRESENT"] = "存在"
L["ICONMENU_PRESENTONALL"] = "全都存在"
L["ICONMENU_PRESENTONALL_DESC"] = "设置在检测的所有单位中至少都有一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_PRESENTONANY"] = "任一存在"
L["ICONMENU_PRESENTONANY_DESC"] = "设置在检测的所有单位中至少存在一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_RANGECHECK"] = "距离检测"
L["ICONMENU_RANGECHECK_DESC"] = "勾选此项启用当你超出范围时改变图标颜色(或视为不可用)"
L["ICONMENU_REACT"] = "单位反应"
L["ICONMENU_REACTIVE"] = "触发性技能"
L["ICONMENU_REACTIVE_DESC"] = [=[检测触发性技能的可用情况.

触发性的技能指类似 %s, %s 和 %s 这些只能在某种特定条件下使用的技能.]=]
L["ICONMENU_READY"] = "准备"
L["ICONMENU_REVERSEBARS"] = "翻转进度条"
L["ICONMENU_REVERSEBARS_DESC"] = "翻转进度条为从左到右走。"
L["ICONMENU_RUNES"] = "符文冷却"
L["ICONMENU_RUNES_CHARGES"] = "不可用符文充能"
L["ICONMENU_RUNES_CHARGES_DESC"] = "启用此项,在一个符文获得额外充能并显示为可用时,让图标依然显示成符文正在冷却状态(显示为冷却时钟)."
L["ICONMENU_RUNES_DESC"] = "检测符文冷却."
L["ICONMENU_SHOWCBAR_DESC"] = "将会在跟图标重叠的下半部份显示剩余的冷却/持续时间的计量条(或是在'反转计量条'启用的情况下显示已用的时间)"
L["ICONMENU_SHOWPBAR_DESC"] = [=[将会在跟图标重叠的上半部份方显示你施放此法术还需多少能量的能量条(或是在'反转计量条'启用的情况下显示当前的能量).

译者注:这个能量可以是盗贼的能量,战士的怒气,猎人的集中值,其他职业的法力值等等.]=]
L["ICONMENU_SHOWSTACKS"] = "显示叠加数量"
L["ICONMENU_SHOWSTACKS_DESC"] = "勾选此项显示物品的叠加数量并启用叠加数量条件."
L["ICONMENU_SHOWTIMER"] = "显示计时器"
L["ICONMENU_SHOWTIMER_DESC"] = "勾选此项让该图标的冷却时钟动画在可用时显示.(译者注:此选项仅影响图标的时钟动画,就是技能冷却时的那个转圈效果,不包括数字在内哦.)"
L["ICONMENU_SHOWTIMERTEXT"] = "显示计时器数字"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[勾选此项以文字方式在图标上显示剩余冷却时间或持续时间的数字.

你需要安装一个像是OmniCC这样的插件来使它正常运行，或者你需要去界面->动作条下面去开启暴雪的计时器文字（已经AFK几年了，如果这句错误了，麻烦自行找在界面中找动作条的选项）。]=]
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "显示ElvUI计时器数字"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [=[勾选此项使用ElvUI的冷却数字来显示图标剩余的冷却时间/持续时间.

此设置仅用于ElvUI的计时器.如果你有其他插件提供类似此种计时器的功能(像是OmniCC),你可以利用%q选项来控制那些计时器. 我们不推荐两个选项同时启用.]=]
L["ICONMENU_SHOWTTTEXT_DESC2"] = [=[在图标的叠加数量位置显示技能效果的变量数值。较常使用在监视伤害护盾的数值等。

此数值会显示到图标的叠加数量位置并替代它。

数值来源为暴雪的API接口，可能跟提示信息上看到的数值会不相同。]=]
L["ICONMENU_SHOWTTTEXT_FIRST"] = "第一个非零的变量"
L["ICONMENU_SHOWTTTEXT_FIRST_DESC"] = [=[把增益/减益第一个非0的变量显示到图标叠加数量的位置。

一般情况下它显示的变量数值都是正确的，你也可以自行选择一个效果变量来显示。

如果检测%s，你需要监视变量#1。]=]
L["ICONMENU_SHOWTTTEXT_STACKS"] = "叠加数量（默认）"
L["ICONMENU_SHOWTTTEXT_STACKS_DESC"] = "在图标叠加数量位置显示增益/减益的叠加数量。"
L["ICONMENU_SHOWTTTEXT_VAR"] = "仅变量#%d"
L["ICONMENU_SHOWTTTEXT_VAR_DESC"] = [=[仅在图标叠加数量位置显示此变量数值。

请自行尝试并选择正确的数值来源。]=]
L["ICONMENU_SHOWTTTEXT2"] = "法术效果变量"
L["ICONMENU_SHOWWHEN"] = "何时显示图标"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "设置此图标在这个图标状态下用来显示的不透明度."
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "在%s|r时的不透明度"
L["ICONMENU_SHOWWHENNONE"] = "没有结果时显示"
L["ICONMENU_SHOWWHENNONE_DESC"] = "勾选此项允许在单位没有被检测到递减时显示图标."
L["ICONMENU_SHRINKGROUP"] = "收缩分组"
L["ICONMENU_SHRINKGROUP_DESC"] = [=[如果启用此项，分组将会动态调整可见图标的位置，使其变得不会狗啃骨头一样难看。

结合上面的图标排列以及布局方向一同使用，你就可以创建一个动态居中的分组。]=]
L["ICONMENU_SORT_STACKS_ASC"] = "叠加数量升序"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "勾选此项优先显示叠加数量最低的法术。"
L["ICONMENU_SORT_STACKS_DESC"] = "叠加数量降序"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "勾选此项优先显示叠加数量最高的法术。"
L["ICONMENU_SORTASC"] = "持续时间升序"
L["ICONMENU_SORTASC_DESC"] = "勾选此项优先显示持续时间最低的法术."
L["ICONMENU_SORTASC_META_DESC"] = "勾选此项优先显示持续时间最低的图标."
L["ICONMENU_SORTDESC"] = "持续时间降序"
L["ICONMENU_SORTDESC_DESC"] = "勾选该项优先显示持续时间最高的法术."
L["ICONMENU_SORTDESC_META_DESC"] = "勾选此项优先显示持续时间最高的图标."
L["ICONMENU_SPELLCAST_COMPLETE"] = "施法结束/瞬发施法"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[如果是在下列情况开始内置冷却,请选择此项:

|cff7fffff1)|r在你施法结束后,或是
|cff7fffff2)|r在你施放一个瞬发法术后.

你需要在 %q 编辑框中输入触发内置冷却的法术名称或ID.]=]
L["ICONMENU_SPELLCAST_START"] = "施法开始"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[如果是在下列情况开始内置冷却,请选择此项:

|cff7fffff1)|r在开始施法后.

你需要在 %q 编辑框中输入触发内置冷却的法术名称或ID.]=]
L["ICONMENU_SPELLCOOLDOWN"] = "法术冷却"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "检测在你法术书中的那些法术的冷却"
L["ICONMENU_SPLIT"] = "拆分成新的分组"
L["ICONMENU_SPLIT_DESC"] = "创建一个新的分组并将这个图标移动到上面. 原分组中的许多设置会保留到新的分组."
L["ICONMENU_SPLIT_GLOBAL"] = "拆分成新的|cff00c300global共用分组|r"
L["ICONMENU_SPLIT_NOCOMBAT_DESC"] = "战斗中不能创建新的分组。请在脱离战斗后分离到新的分组。"
L["ICONMENU_STACKS_MAX_DESC"] = "允许图标显示的最大叠加数量,高于此数值图标将被隐藏."
L["ICONMENU_STACKS_MIN_DESC"] = "显示图标所需的最低叠加数量,低于此数值图标将被隐藏."
L["ICONMENU_STATECOLOR"] = "图标色彩和材质"
L["ICONMENU_STATECOLOR_DESC"] = [=[将图标纹理的色调设置为此图标状态。

白色是正常的。 任何其他颜色会使纹理的颜色。

在此状态下，还可以覆盖图标上显示的纹理。]=]
L["ICONMENU_STATUE"] = "武僧雕像"
L["ICONMENU_STEALABLE"] = "仅可法术吸取"
L["ICONMENU_STEALABLE_DESC"] = "勾选此项仅显示能被“法术吸取”的增益，非常适合跟驱散类型中的魔法搭配使用。"
L["ICONMENU_SUCCEED2"] = "条件通过"
L["ICONMENU_SWAPWITH"] = "交换位置"
L["ICONMENU_SWINGTIMER"] = "攻击计时器"
L["ICONMENU_SWINGTIMER_DESC"] = "检测你的主手和副手武器的自动攻击时间."
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "无攻击"
L["ICONMENU_SWINGTIMER_SWINGING"] = "攻击中"
L["ICONMENU_TARGETTARGET"] = "目标的目标"
L["ICONMENU_TOTEM"] = "图腾"
L["ICONMENU_TOTEM_DESC"] = "检测你的图腾."
L["ICONMENU_TOTEM_GENERIC_DESC"] = "检测你的 %s。"
L["ICONMENU_TYPE"] = "图标类型"
L["ICONMENU_TYPE_CANCONTROL"] = "此图标类型如果在分组的第一个图标设置好就能控制整个分组。"
L["ICONMENU_TYPE_DISABLED_BY_VIEW"] = "此图标类型不支持显示方式:%q。你可以更改分组显示方式或者创建一个新的分组使用这个图标类型。"
L["ICONMENU_UIERROR"] = "战斗错误事件"
L["ICONMENU_UIERROR_DESC"] = [=[检测UI错误信息。

例如：“怒气不足”、“你必须面对目标”等等。]=]
L["ICONMENU_UNIT_DESC"] = [=[在此框输入需要监视的单位,此单位能从右边的下拉列表插入,或者你是一位高端玩家可以自行输入需要监视的单位.多个单位请用分号分隔开(;),可使用标准单位(例如:player,target,mouseover等等可用在宏里的单位),或者友好玩家的名字(像是%s,Cybeloras,百战好哥哥等.)

需要了解更多关于单位的相关信息,请访问http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [=[在此框输入需要监视的单位,此单位能从右边的下拉列表插入,或者你是一位高端玩家可以自行输入需要监视的单位.

可使用标准单位(例如:player,target,mouseover等等可用在宏里的单位),或者友好玩家的名字(像是%s,Cybeloras,百战好哥哥等.)

需要了解更多关于单位的相关信息,请访问http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [=[在此框输入需要监视的单位,此单位能从右边的下拉列表插入.

"unit"是指当前图标正在检测的任意单位.]=]
L["ICONMENU_UNITCNDTIC"] = "单位条件图标"
L["ICONMENU_UNITCNDTIC_DESC"] = [=[检测单位的条件状态。

设置中所有应用的单位都会被检测。]=]
L["ICONMENU_UNITCOOLDOWN"] = "单位冷却"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[检测其他单位的冷却.

%s可以使用 %q 作为名称来检测.

译者注:玩家也可以作为被检测的单位.]=]
L["ICONMENU_UNITFAIL"] = "单位条件未通过"
L["ICONMENU_UNITS"] = "单位"
L["ICONMENU_UNITSTOWATCH"] = "监视的单位"
L["ICONMENU_UNITSUCCEED"] = "单位条件通过"
L["ICONMENU_UNUSABLE"] = "不可用"
L["ICONMENU_UNUSABLE_DESC"] = "当上述状态也不激活时，该状态是活动的。 不透明度为0％的状态将永远不会被激活。"
L["ICONMENU_USABLE"] = "可用"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "检测激活边框"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "检测系统默认提示技能可用时的黄色发光边框."
L["ICONMENU_VALUE"] = "资源显示"
L["ICONMENU_VALUE_DESC"] = "显示一个单位的资源（生命值、法力值等等）"
L["ICONMENU_VALUE_HASUNIT"] = "单位存在"
L["ICONMENU_VALUE_NOUNIT"] = "单位不存在"
L["ICONMENU_VALUE_POWERTYPE"] = "资源类型"
L["ICONMENU_VALUE_POWERTYPE_DESC"] = "设置你想要图标检测的资源类型。"
L["ICONMENU_VEHICLE"] = "载具"
L["ICONMENU_VIEWREQ"] = "分组显示方式不兼容"
L["ICONMENU_VIEWREQ_DESC"] = [=[此图标类型不能用于当前分组显示方式，因为它没有显示全部数据所需的组件。

请更改分组的显示方式或者创建一个新的分组再使用这个图标类型。]=]
L["ICONMENU_WPNENCHANT"] = "暂时性武器附魔"
L["ICONMENU_WPNENCHANT_DESC"] = "检测暂时性的武器附魔."
L["ICONMENU_WPNENCHANTTYPE"] = "要监视的武器栏"
L["IconModule_CooldownSweepCooldown"] = "冷却时钟"
L["IconModule_IconContainer_MasqueIconContainer"] = "图标容器"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "容纳图标的主要部份,像是材质."
L["IconModule_PowerBar_OverlayPowerBar"] = "重叠式能量条"
L["IconModule_SelfIcon"] = "图标"
L["IconModule_Texture_ColoredTexture"] = "图标材质"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "计时条(计量条显示)"
L["IconModule_TimerBar_OverlayTimerBar"] = "重叠式计时条"
L["ICONTOCHECK"] = "要检测的图标"
L["ICONTYPE_DEFAULT_HEADER"] = "提示信息"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [=[要开始设置该图标,请先从%q下拉式菜单中选择一个图标类型.

图标只能在锁定状态才能正常运作,当你设置结束后记得输入"/TMW".


在设置TellMeWhen时,请仔细阅读每个设置选项的提示信息,里面会有如何设置的关键信息,可以让你事半功倍!]=]
L["ICONTYPE_SWINGTIMER_TIP"] = [=[你需要检测%s的时间吗?图标类型%s拥有你想要的功能. 只需简单设置一个%s来检测%q(法术ID:%d)!

你可以点击下方的按钮自动应用设置.]=]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "应用%s设置"
L["IE_NOLOADED_GROUP"] = "选择一个分组加载："
L["IE_NOLOADED_ICON"] = "没有图标被加载。"
L["IE_NOLOADED_ICON_DESC"] = [=[你可以右键点击来读取一个图标。

如果你的屏幕上没有显示任何图标，请点击下面的 %s 标签 。

在那里你可以新增一个分组或者配置一个已存在的分组。

输入'/tmw'退出设置模式。]=]
L["ImmuneToMagicCC"] = "免疫魔法控制"
L["ImmuneToStun"] = "免疫昏迷"
L["IMPORT_EXPORT"] = "导出/导入/还原"
L["IMPORT_EXPORT_BUTTON_DESC"] = "点击此下拉式菜单来导入或导出图标/分组/配置文件."
L["IMPORT_EXPORT_DESC"] = [=[点击这个编辑框右侧的下拉式菜单的箭头来导出图标,分组或配置文件.

导出/导入字符串或发送给其他玩家需要使用这个编辑框. 具体的使用方法请看下拉式菜单上的提示信息.]=]
L["IMPORT_FAILED"] = "导入失败！"
L["IMPORT_FROMBACKUP"] = "来自备份"
L["IMPORT_FROMBACKUP_DESC"] = "用这个菜单可以还原设置到: %s"
L["IMPORT_FROMBACKUP_WARNING"] = "备份设置: %s"
L["IMPORT_FROMCOMM"] = "来自玩家"
L["IMPORT_FROMCOMM_DESC"] = "如果其他TellMeWhen使用者给你发送了配置数据,可以从这个子菜单导入那些数据."
L["IMPORT_FROMLOCAL"] = "来自配置文件"
L["IMPORT_FROMSTRING"] = "来自字符串"
L["IMPORT_FROMSTRING_DESC"] = [=[字符串允许你在游戏以外的地方转存TellMeWhen配置数据.(包括用来给其他人分享自己的设置,或者导入其他人分享的设置,也可用来备份你自己的设置.)

从字符串导入的方法: 当复制TMW字符串到你的剪切板后,在'导出/导入'编辑框中按下CTRL+V贴上字符串,然后返回浏览这个子菜单.]=]
L["IMPORT_GROUPIMPORTED"] = "分组已导入！"
L["IMPORT_GROUPNOVISIBLE"] = "你刚刚导入的分组无法显示，因为它的设置似乎不是你当前的专精和职业所使用。请输入'/tmw options'，在分组设置中修改专精和职业设置。"
L["IMPORT_HEADING"] = "导入"
L["IMPORT_ICON_DISABLED_DESC"] = "你必须在设置一个图标的时候才能导入一个图标."
L["IMPORT_LUA_CONFIRM"] = "确定导入"
L["IMPORT_LUA_DENY"] = "取消导入"
L["IMPORT_LUA_DESC"] = [=[导入的数据中包含了以下Lua代码可以被TellMeWhen执行。

你需要警惕导入的Lua代码的来源是否可信，大部分情况下它们都是安全的，但是知人知面不知心，不要被少数坏人有机可乘。

注意检查并确认代码来自可信的地方，以及它们不会做像是以你的名义来发送邮件或者确认交易这种事情。]=]
L["IMPORT_LUA_DESC2"] = "|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t 请注意检视红色部分代码，它们可能会有某些恶意行为。|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
L["IMPORT_NEWGUIDS"] = [=[你刚导入的数据中的%d|4分组:分组;和%d|4图标:图标;有唯一标识符。可能是因为你之前已经导入过该数据。

TellMeWhen已经为导入的数据分配了新的标识符。你在这之后导入的那些图标都将引用新的数据，可能会无法正常使用 - 新数据会使用到老的图标数据而造成混乱。

如果你打算替换现有的数据，请重新导入到正确的位置。 ]=]
L["IMPORT_PROFILE"] = "复制配置文件"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59创建|r新的配置文件"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959覆盖|r %s"
L["IMPORT_SUCCESSFUL"] = "导入成功!"
L["IMPORTERROR_FAILEDPARSE"] = "处理字符串时发生错误.请确保你复制的字符串是完整的."
L["IMPORTERROR_INVALIDTYPE"] = "尝试导入未知类型的数据,请检查是否已安装了最新版本的TellMeWhen."
L["Incapacitated"] = "被瘫痪"
L["INCHEALS"] = "单位受到的治疗量"
L["INCHEALS_DESC"] = [=[检测单位即将受到的治疗量(包括下一跳HoT和施放中的治疗法术)

仅能在友好单位使用, 敌对单位会返回0.

译者註:由于暴雪API的限制, HoT只会返回单位框架上所显示的数值.]=]
L["INRANGE"] = "在范围内"
L["ITEMCOOLDOWN"] = "物品冷却"
L["ITEMEQUIPPED"] = "已装备物品"
L["ITEMINBAGS"] = "物品计数(包含次数)"
L["ITEMSPELL"] = "物品有使用功能"
L["ITEMTOCHECK"] = "要检测的物品"
L["ITEMTOCOMP1"] = "进行比较的第一个物品"
L["ITEMTOCOMP2"] = "进行比较的第二个物品"
L["LAYOUTDIRECTION"] = "布局方向"
L["LAYOUTDIRECTION_PRIMARY_DESC"] = "使图标的主要布局方向沿 %s 方向展开。"
L["LAYOUTDIRECTION_SECONDARY_DESC"] = "使连续的行/列图标沿 %s 方向展开。"
L["LDB_TOOLTIP1"] = "|cff7fffff左键点击|r 锁定或解锁分组"
L["LDB_TOOLTIP2"] = "|cff7fffff右键点击|r 显示主选项"
L["LEFT"] = "左"
L["LOADERROR"] = "TellMeWhen设置插件无法加载:"
L["LOADINGOPT"] = "正在加载TellMeWhen设置插件."
L["LOCKED"] = "已锁定"
L["LOCKED2"] = "位置锁定."
L["LOSECONTROL_CONTROLLOST"] = "失去控制"
L["LOSECONTROL_DROPDOWNLABEL"] = "失去控制类型"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "选择你需要作用于图标的失去控制的类型(译者注:可多选)."
L["LOSECONTROL_ICONTYPE"] = "失去控制"
L["LOSECONTROL_ICONTYPE_DESC"] = "检测那些造成你角色失去控制权的效果."
L["LOSECONTROL_INCONTROL"] = "可控制"
L["LOSECONTROL_TYPE_ALL"] = "全部类型"
L["LOSECONTROL_TYPE_ALL_DESC"] = "让图标显示所有相关类型的信息."
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "注意:图标无法判断这个失去控制的类型是否已使用."
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "魔法免疫"
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "法术类别被锁定"
L["LUA_INSERTGUID_TOOLTIP"] = "|cff7fffffShift点击|r插入并在你的代码中引用这个图标。"
L["LUACONDITION"] = "Lua(高玩级)"
L["LUACONDITION_DESC"] = [=[此条件类型允许你使用Lua语言来评估一个条件的状态。(非高玩慎入！)

输入不能为'if..then'叙述,也不能为function closure。它可以是一个普通的叙述评估，例如：‘a and b or c’。如果需要复杂功能，可使用函数调用，例如：’CheckStuff()‘，这是一个外部函数。(也可使用Lua片段功能)。

使用"thisobj"来引用这个图标、分组的数据。你也可以插入其他图标的GUID，在编辑框获得焦点时SHIFT点击那个图标即可。

如果需要更多的帮助(但不是关于如何去写Lua代码)，到CurseForge提交一份回报单。关于如何编写Lua代码，请自行去互联网搜索资料。

PS：Lua语言部份就不翻译了，翻译了反而觉得怪怪的。]=]
L["LUACONDITION2"] = "Lua条件"
L["MACROCONDITION"] = "宏命令条件语"
L["MACROCONDITION_DESC"] = [=[此条件将会评估宏命令条件语,在宏命令条件语成立时则此条件通过.
所有的宏命令条件语都能在前面加上"no"进行逆向检测.
例子:
"[nomodifier:alt]" - 没有按住ALT键
"[@target, help][mod:ctrl]" - 目标是友好的或者按住CTRL键
"[@focus, harm, nomod:shift]" - 焦点目标是敌对的同时没有按住SHIFT键

需要更多的帮助,请访问http://www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "使用单一条件时中括号是可选的,使用多个条件语时中括号是必须的.​​(说明:中括号->'[ ]')"
L["MACROTOEVAL"] = "输入需要评估的宏命令条件语(允许多个)"
L["Magic"] = "魔法"
L["MAIN"] = "主页面"
L["MAIN_DESC"] = "包含这个图标的主要选项."
L["MAINASSIST"] = "主助攻"
L["MAINASSIST_DESC"] = "检测团队中标记为主助攻的单位。"
L["MAINOPTIONS_SHOW"] = "分组设置"
L["MAINTANK"] = "主坦克"
L["MAINTANK_DESC"] = "检测你团队中被标记为主坦克(Main Tank)的单位。"
L["MAKENEWGROUP_GLOBAL"] = "|cff59ff59创建|r新的|cff00c300帐号共用|r分组"
L["MAKENEWGROUP_PROFILE"] = "|cff59ff59创建|r新的角色配置分组"
L["MESSAGERECIEVE"] = "%s给你发送了一些TellMeWhen数据!你可以使用图标编辑器中的 %q 下拉式菜单把数据导入TellMeWhen."
L["MESSAGERECIEVE_SHORT"] = "%s给你发送了一些TellMeWhen数据!"
L["META_ADDICON"] = "增加图标"
L["META_ADDICON_DESC"] = "点击新增图标到此整合图标中."
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [=[该分组的图标不能用于整合图标检测,因为它们使用不同的显示方式.

分组:%s
目标分组:%s]=]
L["METAPANEL_DOWN"] = "往下移动"
L["METAPANEL_REMOVE"] = "移除此图标"
L["METAPANEL_REMOVE_DESC"] = "点击从整合图标检测列表中移除该图标."
L["METAPANEL_UP"] = "往上移动"
L["minus"] = "仆从"
L["MISCELLANEOUS"] = "其他"
L["MiscHelpfulBuffs"] = "其他增益"
L["MODTIMER_PATTERN"] = "允许Lua匹配模式"
L["MODTIMER_PATTERN_DESC"] = [=[默认情况下，这个条件将匹配任何包含你输入的文字的计时器，不区分大小写。

如果启用此设置，输入将使用Lua样式的字符匹配模式。

输入^timer name$时将强制匹配计时器的完整名称。TellMeWhen保存计时器的名称必须全部为小写字母。

需要获取更多的信息，请访问http://wowpedia.org/Pattern_matching]=]
L["MODTIMERTOCHECK"] = "用于检测的计时器"
L["MODTIMERTOCHECK_DESC"] = "输入显示在首领模块计时器显示在计时条上的全名。"
L["MOON"] = "月蚀"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "无鼠标悬停目标"
L["MOUSEOVERCONDITION"] = "鼠标指针悬停"
L["MOUSEOVERCONDITION_DESC"] = "此条件检测你的鼠标指针是否有悬停在此图标上,如果是分组条件则是鼠标指针是否有悬停在此分组的某个图标上."
L["MP5"] = "%d 5秒回蓝"
L["MUSHROOM"] = "蘑菇 %d"
L["NEWVERSION"] = "检测到新版本可升级:(%s)"
L["NOGROUPS_DIALOG_BODY"] = [=[你当前的TellMeWhen设置或玩家专精不允许显示任何分组，所以没有东西可以进行设置。

如果你想更改已有分组的设置或新增一个分组，请输入/tmw options打开TellMeWhen的首选项或者点击下方的按键。

输入/tellmewhen或/tmw退出设置模式。 ]=]
L["NONE"] = "不包含任何一个"
L["normal"] = "普通"
L["NOTINRANGE"] = "不在范围内"
L["NOTYPE"] = "<无图标类型>"
L["NUMAURAS"] = "数量"
L["NUMAURAS_DESC"] = [=[此条件仅检测一个作用中的法术效果的数量- 不要与法术效果的叠加数量混淆.
像是你的两个相同的武器附魔特效同时触发并且在作用中.
请有节制的使用它,此过程需要消耗不少CPU运算来计算数量.]=]
L["ONLYCHECKMINE"] = "仅检测自己施放的"
L["ONLYCHECKMINE_DESC"] = "选择此项让该条件只检测自己施放的增益/减益"
L["OPERATION_DIVIDE"] = "除（/）"
L["OPERATION_MINUS"] = "减（-）"
L["OPERATION_MULTIPLY"] = "乘（*）"
L["OPERATION_PLUS"] = "加（+）"
L["OPERATION_SET"] = "集（Set）"
L["OPERATION_TPAUSE"] = "暂停"
L["OPERATION_TPAUSE_DESC"] = "暂停计时器。"
L["OPERATION_TRESET"] = "重置"
L["OPERATION_TRESET_DESC"] = "重置计时器为0，如果它还在运行的话不会停止。"
L["OPERATION_TRESTART"] = "重新开始"
L["OPERATION_TRESTART_DESC"] = "重置计时器为0。如果它未运行则开始运行。"
L["OPERATION_TSTART"] = "开始"
L["OPERATION_TSTART_DESC"] = "如果计时器没在运行则开始计时。不重置计时器。"
L["OPERATION_TSTOP"] = "停止"
L["OPERATION_TSTOP_DESC"] = "停止并重置计时器为0。"
L["OUTLINE_MONOCHORME"] = "单色"
L["OUTLINE_NO"] = "没有描边"
L["OUTLINE_THICK"] = "粗描边"
L["OUTLINE_THIN"] = "细描边"
L["PARENTHESIS_TYPE_("] = "左括号'('"
L["PARENTHESIS_TYPE_)"] = "右括号')'"
L["PARENTHESIS_WARNING1"] = [=[左右括号的数量不相等!

缺少%d个%s.]=]
L["PARENTHESIS_WARNING2"] = [=[一些右括号缺少左括号!

缺少%d个左括号'('.]=]
L["PERCENTAGE"] = "百分比"
L["PERCENTAGE_DEPRECATED_DESC"] = [=[百分比条件已经作废，因为它们不再可靠。

在德拉诺之王，增益/减益的加速机制更改为未结束前刷新可以最大延长至130%基础持续时间。 

其他一大段略过，基本同上。]=]
L["PET_TYPE_CUNNING"] = "狡诈"
L["PET_TYPE_FEROCITY"] = "狂野"
L["PET_TYPE_TENACITY"] = "坚韧"
L["PLAYER_DESC"] = "单位'player'是你自己。"
L["Poison"] = "毒"
L["PROFILE_LOADED"] = "已读取配置文件: %s"
L["PROFILES_COPY"] = "复制配置..."
L["PROFILES_COPY_CONFIRM"] = "复制配置"
L["PROFILES_COPY_CONFIRM_DESC"] = "配置 %q 将会被配置 %q 的一个副本覆盖."
L["PROFILES_COPY_DESC"] = [=[选择一个配置. 当前的配置会被这个选择的配置覆盖.

在登出游戏或重载前你都可以使用 %q (下方菜单 %q 中的选项)来恢复被删配置.]=]
L["PROFILES_DELETE"] = "删除配置..."
L["PROFILES_DELETE_CONFIRM"] = "删除配置"
L["PROFILES_DELETE_CONFIRM_DESC"] = "配置 %q 将会被删除."
L["PROFILES_DELETE_DESC"] = [=[选择需要删除的配置.

在登出游戏或重载前你都可以使用 %q (下方菜单 %q 中的选项)来恢复被删配置.]=]
L["PROFILES_NEW"] = "新建配置"
L["PROFILES_NEW_DESC"] = "输入新配置名称, 然后按回车建立."
L["PROFILES_SET"] = "变更配置..."
L["PROFILES_SET_DESC"] = "切换到选择的配置."
L["PROFILES_SET_LABEL"] = "当前配置"
L["PvPSpells"] = "PVP控场技能等"
L["QUESTIDTOCHECK"] = "用于检测的任务ID"
L["RAID_WARNING_FAKE"] = "团队警报 (假)"
L["RAID_WARNING_FAKE_DESC"] = "输出类似于团队警报信息的文字,此信息不会被其他人看到,你不需要团队权限,也不需要在团队中即可使用."
L["RaidWarningFrame"] = "团队警告框架"
L["rare"] = "稀有"
L["rareelite"] = "稀有精英"
L["REACTIVECNDT_DESC"] = "此条件仅检测技能的触发/激活情况,并非它的冷却."
L["REDO"] = "恢复"
L["REDO_DESC"] = "重做上次对这些设置所做的更改。"
L["ReducedHealing"] = "治疗效果降低"
L["REQFAILED_ALPHA"] = "无效时的不透明度"
L["RESET_ICON"] = "重置"
L["RESET_ICON_DESC"] = "重置这个图标的所有设置为默认值。"
L["RESIZE"] = "调整大小"
L["RESIZE_GROUP_CLOBBERWARN"] = "当你使用|cff7fffff右键点击并拖拽|r缩小分组时，部分图标将会临时保存设置，在你使用|cff7fffff右键点击并拖拽|r放大分组时会恢复，但是在你登出或者重新加载UI后临时保存的数据将会丢失。"
L["RESIZE_TOOLTIP"] = "|cff7fffff点击并拖拽|r以改变大小"
L["RESIZE_TOOLTIP_CHANGEDIMS"] = "|cff7fffff鼠标右键点击并拖拽|r来更改分组的行跟列的数量。"
L["RESIZE_TOOLTIP_IEEXTRA"] = "在主选项启用缩放。"
L["RESIZE_TOOLTIP_SCALEX_SIZEY"] = "|cff7fffff点击并拖拽|r来改变尺寸"
L["RESIZE_TOOLTIP_SCALEXY"] = [=[|cff7fffff点击同时拖曳|r快速调整尺寸
|cff7fffff按住CTRL|r微调尺寸]=]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = "|cff7fffff点击并拖动|r来调整尺寸"
L["RIGHT"] = "右"
L["ROLEf"] = "职责: %s"
L["Rooted"] = "被缠绕"
L["RUNEOFPOWER"] = "符文%d"
L["RUNES"] = "要检测的符文"
L["RUNSPEED"] = "单位奔跑速度"
L["RUNSPEED_DESC"] = "这是指单位的最大运行速度，而不管单位是否正在移动。"
L["SAFESETUP_COMPLETE"] = "安全&慢速设置完成."
L["SAFESETUP_FAILED"] = "安全&慢速设置失败:%s"
L["SAFESETUP_TRIGGERED"] = "正在进行安全&慢速设置..."
L["SEAL"] = "圣印"
L["SENDSUCCESSFUL"] = "已成功发送"
L["SHAPESHIFT"] = "变身"
L["Shatterable"] = "冰冻"
L["SHOWGUIDS_OPTION"] = "在鼠标提示信息上显示GUID。"
L["SHOWGUIDS_OPTION_DESC"] = "启用此设置可以在鼠标提示面板显示图标跟分组的GUID（全局唯一标识符）。在需要知道图标或分组所对应的GUID时，这可能对你有所帮助。"
L["Silenced"] = "被沉默"
L["Slowed"] = "被减速"
L["SORTBY"] = "排列方式"
L["SORTBYNONE"] = "正常排列"
L["SORTBYNONE_DESC"] = [=[如果选中，法术将按照"%s"编辑框中的输入顺序来检测并排列。

如果是一个增益/减益图标，只要出现在单位框体上的法术效果数字没有超出效率阀值设定，就会被检测并排列。

(PS：如果看不懂请无视这段说明，只要知道它是按照你输入的顺序来排列就好。)]=]
L["SORTBYNONE_DURATION"] = "持续时间正常"
L["SORTBYNONE_META_DESC"] = "如果勾选,被检测的图标将使用上面的列表所设置的顺序来排列."
L["SORTBYNONE_STACKS"] = "叠加数量正常"
L["SOUND_CHANNEL"] = "音效播放频道"
L["SOUND_CHANNEL_DESC"] = [=[选择一个你想用于播放声音的频道(会直接使用在系统->音效中该频道所设置的音量跟设定来播放).

选择%q时,可以在音效关闭时播放声音.]=]
L["SOUND_CHANNEL_MASTER"] = "主声道"
L["SOUND_CUSTOM"] = "自定义音效文件"
L["SOUND_CUSTOM_DESC"] = [=[输入需要用来播放的自定义音效文件的路径.
下面是一些例子,其中"File"是你的音效文件名,"ext"是后缀名(只能用ogg或者mp3格式)

-"CustomSounds\File.ext": 一个文件放在WOW主目录一个命名为"CustomSound"的新建文件夹中(此文件夹同WOW.exe,Interface和WTF在同一位置)
-"Interface\AddOns\file.ext": 插件文件夹中的某一文件
-"file.ext": WOW主目录的某个文件

注意:魔兽世界必须在重开之后才能正常使用那些在它启动时还不存在的文件.]=]
L["SOUND_ERROR_ALLDISABLED"] = [=[无法进行音效播放测试，原因：游戏音效已经被完全禁用。

你需要去更改暴雪音效选项的相关设置。]=]
L["SOUND_ERROR_DISABLED"] = [=[无法进行音效播放测试，原因：音效播放频道 %q 已经被禁用。

你需要去更改暴雪音效选项的相关设置，或者你也可以在TellMeWhen的主选项中更改TellMeWhen的音效播放频道('/tmw options')。]=]
L["SOUND_ERROR_MUTED"] = [=[无法进行音效播放测试，原因：音效播放频道 %q 的音量大小为0。

你需要去更改暴雪音效选项的相关设置，或者你也可以在TellMeWhen的主选项中更改TellMeWhen的音效播放频道('/tmw options')。]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "不可用"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [=[在当前图标设置下,此事件不可用.

可能因为当前的图标类型(%s)还不支持此事件,请|cff7fffff右键点击|r更改事件类型.]=]
L["SOUND_EVENT_NOEVENT"] = "未配置的事件"
L["SOUND_EVENT_ONALPHADEC"] = "在透明度百分比减少时"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[当图标的不透明度降低时触发此事件.

注意:不透明度在降低后如果为0%不会触发此事件(如果有需要请使用"在隐藏时").]=]
L["SOUND_EVENT_ONALPHAINC"] = "在透明度百分比增加时"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[当图标的不透明度提高时触发此事件.

注意:不透明度在提高前如果为0%不会触发此事件(如果有需要请使用"在显示时").]=]
L["SOUND_EVENT_ONCHARGEGAINED"] = "在充能获取时"
L["SOUND_EVENT_ONCHARGEGAINED_DESC"] = "此事件在一个被检测的充能类型技能获取一次充能时触发。"
L["SOUND_EVENT_ONCHARGELOST"] = "在充能使用时"
L["SOUND_EVENT_ONCHARGELOST_DESC"] = "此事件在一个被检测的充能类型技能使用一次充能时触发。"
L["SOUND_EVENT_ONCLEU"] = "在战斗事件发生时"
L["SOUND_EVENT_ONCLEU_DESC"] = "此事件在图标处理一个战斗事件时触发."
L["SOUND_EVENT_ONCONDITION"] = "在设置的条件通过时"
L["SOUND_EVENT_ONCONDITION_DESC"] = "当你设置的条件通过时触发一次此事件."
L["SOUND_EVENT_ONDURATION"] = "在持续时间改变时"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[此事件在图标计时器的持续时间改变时触发.

因为在计时器运行时每次图标更新都会触发该事件,你必须设置一个条件,使事件仅在条件的状态改变时触发.]=]
L["SOUND_EVENT_ONEVENTSRESTORED"] = "在图标设置后"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [=[此事件在图标已经设置完毕后触发.

这主要发生在你退出设置模式时,同样也会发生在某些区域的进入事件或离开事件.

你可以视它为图标的"软重置".

此事件比较常用于创建一个图标的默认状态的动画.]=]
L["SOUND_EVENT_ONFINISH"] = "在结束时"
L["SOUND_EVENT_ONFINISH_DESC"] = "当冷却结束,增益/减益消失,等相似的情况下触发此事件."
L["SOUND_EVENT_ONHIDE"] = "在隐藏时"
L["SOUND_EVENT_ONHIDE_DESC"] = "当图标隐藏时触发此事件.(即使 %q 已勾选)"
L["SOUND_EVENT_ONLEFTCLICK"] = "在鼠标左键点击时"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = "在图标锁定的情况下,当你|cff7fffff用鼠标左键点击|r这个图标时触发此事件."
L["SOUND_EVENT_ONRIGHTCLICK"] = "在鼠标右键点击时"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = "在图标锁定的情况下,当你|cff7fffff用鼠标右键点击|r这个图标时触发此事件."
L["SOUND_EVENT_ONSHOW"] = "在显示时"
L["SOUND_EVENT_ONSHOW_DESC"] = "当图标显示时触发此事件.(即使 %q 已勾选)"
L["SOUND_EVENT_ONSPELL"] = "在法术改变时"
L["SOUND_EVENT_ONSPELL_DESC"] = "当图标显示信息中的法术/物品/等改变时触发此事件."
L["SOUND_EVENT_ONSTACK"] = "在叠加数量改变时"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[此事件在图标所检测的法术/物品等的叠加数量发生改变时触发.

包括逐渐降低的%s图标.]=]
L["SOUND_EVENT_ONSTACKDEC"] = "在叠加数量减少时"
L["SOUND_EVENT_ONSTACKINC"] = "在叠加数量增加时"
L["SOUND_EVENT_ONSTART"] = "在开始时"
L["SOUND_EVENT_ONSTART_DESC"] = "当冷却开始,增益/减益开始作用,等相似的情况下触发此事件."
L["SOUND_EVENT_ONUIERROR"] = "在战斗错误事件发生时"
L["SOUND_EVENT_ONUIERROR_DESC"] = "此事件在图标处理一个战斗错误事件时触发。"
L["SOUND_EVENT_ONUNIT"] = "在单位改变时"
L["SOUND_EVENT_ONUNIT_DESC"] = "当图标显示信息中的单位改变时触发此事件."
L["SOUND_EVENT_WHILECONDITION"] = "当设置的条件通过时"
L["SOUND_EVENT_WHILECONDITION_DESC"] = "此类型的通知事件会在你设置的条件通过时持续触发。"
L["SOUND_SOUNDTOPLAY"] = "要播放的音效"
L["SOUND_TAB"] = "音效"
L["SOUND_TAB_DESC"] = "设置用于播放的声音。 你可以使用LibSharedMedia的声音或者指定一个声音文件。"
L["SOUNDERROR1"] = "文件必须有后缀名!"
L["SOUNDERROR2"] = [=[魔兽世界4.0+不支持自定义WAV文件

(WoW自带WAV音效可以使用)]=]
L["SOUNDERROR3"] = "只支持OGG跟MP3文件!"
L["SPEED"] = "单位速度"
L["SPEED_DESC"] = [=[这是指单位当前的移动速度,如果单位不移动则为0.
如果您要检测单位的最高奔跑速度,可以使用"单位奔跑速度"条件来代替.]=]
L["SpeedBoosts"] = "速度提升"
L["SPELL_EQUIV_REMOVE_FAILED"] = "警告：尝试把%q从法术列表%q中移除，但是无法找到。"
L["SPELLCHARGES"] = "法术次数"
L["SPELLCHARGES_DESC"] = "检测像是%s或%s这类法术的可用次数."
L["SPELLCHARGES_FULLYCHARGED"] = "完全恢复"
L["SPELLCHARGETIME"] = "法术次数恢复时间"
L["SPELLCHARGETIME_DESC"] = "检测像是%s或%s恢复一次充能还需要多少时间."
L["SPELLCOOLDOWN"] = "法术冷却"
L["SPELLREACTIVITY"] = "法术反应(激活/触发/可能)"
L["SPELLTOCHECK"] = "要检测的法术"
L["SPELLTOCOMP1"] = "进行比较的第一个法术"
L["SPELLTOCOMP2"] = "进行比较的第二个法术"
L["STACKALPHA_DESC"] = [=[设置在你要求的叠加数量不符合时图标显示的不透明度.

此选项会在勾选%s时自动忽略。]=]
L["STACKS"] = "叠加数量"
L["STACKSPANEL_TITLE2"] = "叠加数量限制"
L["STANCE"] = "姿态"
L["STANCE_DESC"] = [=[你可以利用分号(;)输入多个用于检测的姿态.

此条件会在任意一个姿态符合时通过.]=]
L["STANCE_LABEL"] = "姿态"
L["STRATA_BACKGROUND"] = "背景(最低)"
L["STRATA_DIALOG"] = "对话框"
L["STRATA_FULLSCREEN"] = "全屏幕"
L["STRATA_FULLSCREEN_DIALOG"] = "全屏幕对话框"
L["STRATA_HIGH"] = "高"
L["STRATA_LOW"] = "低"
L["STRATA_MEDIUM"] = "中"
L["STRATA_TOOLTIP"] = "提示信息(最高)"
L["Stunned"] = "被昏迷"
L["SUG_BUFFEQUIVS"] = "同类型增益"
L["SUG_CLASSSPELLS"] = "已知玩家/宠物的法术"
L["SUG_DEBUFFEQUIVS"] = "同类型减益"
L["SUG_DISPELTYPES"] = "驱散类型"
L["SUG_FINISHHIM"] = "马上结束缓存"
L["SUG_FINISHHIM_DESC"] = "|cff7fffff点击|r快速完成该缓存/筛选过程. 友情提示:你的电脑可能会因此卡住几秒钟的时间."
L["SUG_FIRSTHELP_DESC"] = [=[这是一个提示与建议列表，它可以显示相关的条目供你选择以加快设置速度。

|cff7fffff鼠标点击|r或者使用键盘|cff7fffff上/下|r箭头和|cff7fffffTab|r插入条目。

如果你只需要插入名称，可以无视条目的ID是否正确，只要名称完全相同即可。

大部分情况下，用名称来检测是比较好的选择。在同个名称存在多个不同效果可能发生重叠的情况下你才需要使用ID来检测。

如果你输入的是一个名称，则|cff7fffff点击右键|r条目会插入一个ID，反之亦然,你输入的是ID则|cff7fffff点击右键|r会插入一个名称。]=]
L["SUG_INSERT_ANY"] = "|cff7fffff点击鼠标|r"
L["SUG_INSERT_LEFT"] = "|cff7fffff点击鼠标左键|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffff点击鼠标右键|r"
L["SUG_INSERT_TAB"] = "或者按|cff7fffffTab|r键"
L["SUG_INSERTEQUIV"] = "%s 插入同类型条目"
L["SUG_INSERTERROR"] = "%s插入错误信息"
L["SUG_INSERTID"] = "%s插入编号(ID)"
L["SUG_INSERTITEMSLOT"] = "%s插入物品对应的装备栏编号"
L["SUG_INSERTNAME"] = "%s插入名称"
L["SUG_INSERTNAME_INTERFERE"] = [=[%s插入名称。

|TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffffa500CAUTION: |TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffff1111
此法术可能有多个效果。
如果使用名称可能无法被正确的检测。
你应当使用一个ID来检测。|r]=]
L["SUG_INSERTTEXTSUB"] = "%s插入标签"
L["SUG_INSERTTUNITID"] = "%s插入单位ID"
L["SUG_MISC"] = "杂项"
L["SUG_MODULE_FRAME_LIKELYADDON"] = "猜测来源：%s"
L["SUG_NPCAURAS"] = "已知NPC的增益/减益"
L["SUG_OTHEREQUIVS"] = "其他同类型"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "鱼饵%（%+%d+钓鱼技能%）"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "磨快%（%+%d+伤害%）"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "增重%（%+%d+伤害%）"
L["SUG_PLAYERAURAS"] = "已知玩家/宠物的增益/减益"
L["SUG_PLAYERSPELLS"] = "你的法术"
L["SUG_TOOLTIPTITLE"] = [=[当你输入时,TellMeWhen将会在缓存中查找并提示你最有可能输入的法术.

法术按照以下列表分类跟着色.
注意:在记录到相应的数据之前或者在你没有登陆过其他的职业的情况下不会把那些法术放入"已知"开头的分类中.

点击一个条目将其插入到编辑框.

]=]
L["SUG_TOOLTIPTITLE_GENERIC"] = [=[当你输入时，TellMeWhen会尝试确定你想要输入的内容。

在某些情况下，建议列表中可能显示了错误的内容。你可以不用选择建议列表中的条目 - 当你输入编辑框的（正确）内容越长时，TellMeWhen越不容易发生这样的情况。

点击一个条目把它插入到编辑框中。]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[下列的单位变量可以使用在输出显示的文字内容中.变量将会被替换成与其相应的内容后再输出显示.

点击一个条目将其插入到编辑框中.]=]
L["SUGGESTIONS"] = "提示与建议:"
L["SUGGESTIONS_DOGTAGS"] = "DogTags:"
L["SUGGESTIONS_SORTING"] = "排列中..."
L["SUN"] = "日蚀"
L["SWINGTIMER"] = "攻击计时"
L["TABGROUP_GROUP_DESC"] = "设置 TellMeWhen 分组."
L["TABGROUP_ICON_DESC"] = "设置 TellMeWhen 图标."
L["TABGROUP_MAIN_DESC"] = "TellMeWhen综合设置"
L["TEXTLAYOUTS"] = "文字显示样式"
L["TEXTLAYOUTS_ADDANCHOR"] = "增加描点"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "点击增加文字描点."
L["TEXTLAYOUTS_ADDLAYOUT"] = "新增文字显示样式"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "创建一个你可自行配置并应用到图标的文字显示样式."
L["TEXTLAYOUTS_ADDSTRING"] = "新增文字显示方案"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "添加一个新的文字显示方案到此文字显示样式中."
L["TEXTLAYOUTS_BLANK"] = "(空白)"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "选择样式..."
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "选取此图标要使用的文字显示样式."
L["TEXTLAYOUTS_CLONELAYOUT"] = "克隆显示样式"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "点击创建一个该显示样式的副本,你可以单独修改它."
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "计量条显示样式 1"
L["TEXTLAYOUTS_DEFAULTS_BAR2"] = "垂直计量条布局1"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "绑定/标签"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "居中数字"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "持续时间"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "图标样式 1"
L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<无显示样式>"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "数字"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "法术"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "叠加数量"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "默认: %s"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "默认显示文字"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "修改文字显示样式在图标上显示的默认文字."
L["TEXTLAYOUTS_DEGREES"] = "%d 度"
L["TEXTLAYOUTS_DELANCHOR"] = "删除描点"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = "点击删除该文字描点."
L["TEXTLAYOUTS_DELETELAYOUT"] = "删除文字显示样式"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"] = "%s: ~%d |4图标:图标;"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_NUM2"] = "|cFFFF2929下列角色配置的图标中使用了这个显示样式。如果你要删除该显示样式，图标将重新使用默认的显示样式：|r"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = "点击删除此文字显示样式"
L["TEXTLAYOUTS_DELETESTRING"] = "删除文字显示方案"
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = "从文字显示样式中删除这个文字显示方案。"
L["TEXTLAYOUTS_DESC"] = "定义的文字显示样式能用于你设置的任意一个图标。"
L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"] = "此文字布局无法使用在这个分组显示方式上，请选择另外的文字布局。（未找到描点：%s）"
L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"] = [=[文字布局错误：文字显示#%d尝试依附到文字显示#%d，但是%d不存在，所以文字显示#%d不能正常使用。
]=]
L["TEXTLAYOUTS_ERROR_FALLBACK"] = [=[找不到此图标使用的文字显示样式.在找到相符的显示样式或选择其他的显示样式之前将使用默认文字显示样式.

(你是不是删除了相关的文字显示样式?或只有导入图标而没导入它使用的文字显示样式?)]=]
L["TEXTLAYOUTS_fLAYOUT"] = "文字显示样式: %s"
L["TEXTLAYOUTS_FONTSETTINGS"] = "字体设置"
L["TEXTLAYOUTS_fSTRING"] = "文字显示方案 %s"
L["TEXTLAYOUTS_fSTRING2"] = "文字显示方案 %d: %s"
L["TEXTLAYOUTS_fSTRING3"] = "文字显示方案:%s"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "文字显示方案"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "文字显示样式"
L["TEXTLAYOUTS_IMPORT"] = "导入文字显示样式"
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "|cff59ff59新增|r"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [=[文字显示样式中已有一个跟该显示样式相同的唯一标识.

选择此项创建一个新的唯一标识并导入这个显示样式.]=]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = "点击导入文字显示样式."
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "|cFFFF5959替换|r 现有"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [=[文字显示样式中已有一个跟需要导入的显示样式相同的唯一标识.

选择此项覆盖已有唯一标识的显示样式并导入新的显示样式.那些正在使用被覆盖掉的那个文字显示样式的图标都会在导入后自动作出相应的更新.]=]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = "你不能覆盖默认文字显示样式."
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "重置为默认"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = "重置当前文字显示样式设置中所有方案的文字为默认显示文字."
L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [=[文字显示方案:
%s]=]
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "显示样式设置"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "点击设置文字显示样式 %q."
L["TEXTLAYOUTS_NOEDIT_DESC"] = [=[这个文字显示样式是TellMeWhen默认的文字显示样式,你无法对其作出更改.

如果你想更改的话,请克隆一份此文字显示样式的副本.]=]
L["TEXTLAYOUTS_POINT2"] = "文字位置"
L["TEXTLAYOUTS_POINT2_DESC"] = "将 %s 的文本显示到锚定目标。"
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "位置设定"
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "将文本显示到 %s 的锚定目标。"
L["TEXTLAYOUTS_RELATIVETO_DESC"] = "文字将依附的对象"
L["TEXTLAYOUTS_RENAME"] = "重命名显示样式"
L["TEXTLAYOUTS_RENAME_DESC"] = "为此文字显示样式修改一个与其用途相符的名称,让你可以轻松的找到它."
L["TEXTLAYOUTS_RENAMESTRING"] = "重命名文字显示方案"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "为此文字显示方案修改一个与其用途相符的名称,让你可以轻松的找到它."
L["TEXTLAYOUTS_RESETSKINAS"] = "%q设置用于文字%q将被重置,以防止跟文字%q的新设置产生冲突."
L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "文字显示样式"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "选择显示样式..."
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [=[设置使用于这个分组所有图标的文字显示样式.

每个图标的文字显示样式也可以自行单独设置.]=]
L["TEXTLAYOUTS_SETTEXT"] = "设置显示文字"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [=[设置用于这个文字显示方案中的文字.

文字可能会被转化为DogTag标记的格式,以便动态显示信息. 关于如何使用DogTag标记,请输入'/dogtag'或'/dt'查看帮助.]=]
L["TEXTLAYOUTS_SIZE_AUTO"] = "自动"
L["TEXTLAYOUTS_SKINAS"] = "使用皮肤"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "叠加数量"
L["TEXTLAYOUTS_SKINAS_DESC"] = "选择你想让这些显示文字使用的Masque皮肤."
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "绑定/标签"
L["TEXTLAYOUTS_SKINAS_NONE"] = "无"
L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [=[此文本显示皮肤由Masque设置。 

因此，当此布局用于由Masque设置外观的TellMeWhen图标时，下面的设置不会有任何效果。]=]
L["TEXTLAYOUTS_STRING_COPYMENU"] = "复制"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = [=[点击打开一个此配置文件中所有的已使用显示文字列表,你可以将它们加入到这个文字显示方案中.
]=]
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "重置为默认"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [=[重置当前文字显示方案中的显示文字为下列默认显示文字,在该文字显示样式中的设置为:

%s]=]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "已使用%d次."
L["TEXTLAYOUTS_TAB"] = "文字显示方案"
L["TEXTLAYOUTS_UNNAMED"] = "<未命名>"
L["TEXTLAYOUTS_USEDBY_HEADER"] = "以下角色配置在他们的图标中使用了此显示样式："
L["TEXTLAYOUTS_USEDBY_NONE"] = "此魔兽世界帐号中的TellMeWhen配置文件中没有使用这个显示样式。"
L["TEXTMANIP"] = "文字处理"
L["TOOLTIPSCAN"] = "法术效果变量"
L["TOOLTIPSCAN_DESC"] = "此条件类型允许你检测某一单位的某个法术效果提示信息上的第一个变量(数字).数字是由暴雪API所提供,跟你在法术效果的提示信息中看到的数字可能会不同(像是服务器已经在线修正,客户端依然显示错误的数字这种情况),同时也不保证一定能够从法术效果获取一个数字,不过在大多数实际情况下都能检测到正确的数字."
L["TOOLTIPSCAN2"] = "提示信息数字 #%d"
L["TOOLTIPSCAN2_DESC"] = "此条件类型将允许你检测一个在技能提示信息面板上找到的数字。"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["TOTEMS"] = "检测图腾"
L["TREEf"] = "专精：%s"
L["TRUE"] = "是"
L["UIPANEL_ADDGROUP2"] = "新建 %s 分组"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffff点击|r 新建 %s 分组."
L["UIPANEL_ALLOWSCALEIE"] = "允许图标编辑器缩放"
L["UIPANEL_ALLOWSCALEIE_DESC"] = [=[默认情况下图标编辑器不允许拖放更改尺寸，以便让布局比较清新以及完美。

如果你不介意这个或者有特别的原因，那么请启用它。]=]
L["UIPANEL_ANCHORNUM"] = "描点 %d"
L["UIPANEL_BAR_BORDERBAR"] = "进度条边框"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "设置进度条边框."
L["UIPANEL_BAR_BORDERCOLOR"] = "边框颜色"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "改变图标和进度条边框颜色."
L["UIPANEL_BAR_BORDERICON"] = "图标边框"
L["UIPANEL_BAR_BORDERICON_DESC"] = "在纹理，冷却时钟和其他类似组件周围设置边框。"
L["UIPANEL_BAR_FLIP"] = "翻转图标"
L["UIPANEL_BAR_FLIP_DESC"] = "将纹理，冷却时钟和其他类似的组件放置在图标的另一侧。"
L["UIPANEL_BAR_PADDING"] = "填充"
L["UIPANEL_BAR_PADDING_DESC"] = "设置图标和计时条间距."
L["UIPANEL_BAR_SHOWICON"] = "显示图标"
L["UIPANEL_BAR_SHOWICON_DESC"] = "禁用此设置可隐藏纹理，冷却时钟和其他类似组件。"
L["UIPANEL_BARTEXTURE"] = "计量条材质"
L["UIPANEL_COLUMNS"] = "列"
L["UIPANEL_COMBATCONFIG"] = "允许在战斗中进行设置"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[启用这个选项就可以在战斗中对TellMeWhen进行设置.

注意,该选项会让插件强制加载设置模块, 内存的占用以及插件加载的时间都会随之增加.

所有角色的配置文件共同使用该选项.

|cff7fffff需要重新加载UI|cffff5959才能生效.|r]=]
L["UIPANEL_DELGROUP"] = "删除该分组"
L["UIPANEL_DIMENSIONS"] = "尺寸"
L["UIPANEL_DRAWEDGE"] = "高亮计时器指针"
L["UIPANEL_DRAWEDGE_DESC"] = "高亮冷却计时器的指针来改善可视性"
L["UIPANEL_EFFTHRESHOLD"] = "增益效率閥值"
L["UIPANEL_EFFTHRESHOLD_DESC"] = "输入增益/减益的最小时间以便在它们有很高的数值时切换到更有效的检测模式. 注意:一旦效果的数值超出所选择的数字的限定,数值较大的效果会优先显示,而不是按照设定的优先级顺序."
L["UIPANEL_FONT_DESC"] = "选择图标的叠加数量文字所使用的字体"
L["UIPANEL_FONT_HEIGHT"] = "高"
L["UIPANEL_FONT_HEIGHT_DESC"] = [=[设置显示文字的最大高度。如果设为0将自动使用可能的最大高度。

如果这个显示文字依附于底部或顶部可能会无效。]=]
L["UIPANEL_FONT_JUSTIFY"] = "文字横向对齐校准"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "设置该文字显示方案中文字的横向对齐位置校准(左/中/右)."
L["UIPANEL_FONT_JUSTIFYV"] = "文字垂直对齐校准"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "设置该文字显示方案中文字的垂直对齐位置校准(左/中/右)."
L["UIPANEL_FONT_OUTLINE"] = "字体描边"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "设置文字显示方案的轮廓样式。"
L["UIPANEL_FONT_ROTATE"] = "旋转"
L["UIPANEL_FONT_ROTATE_DESC"] = [=[设置你想要文字显示旋转的度数。

此方法不是暴雪自带的功能，所以可能发生一些奇怪的错误，我们也只能做到这了，好运。]=]
L["UIPANEL_FONT_SHADOW"] = "阴影偏移"
L["UIPANEL_FONT_SHADOW_DESC"] = "更改文字阴影的偏移数值,设置为0则禁用阴影效果."
L["UIPANEL_FONT_SIZE"] = "字体大小"
L["UIPANEL_FONT_SIZE_DESC2"] = "改变字体大小."
L["UIPANEL_FONT_WIDTH"] = "宽"
L["UIPANEL_FONT_WIDTH_DESC"] = [=[设置显示文字的最大宽度。如果设为0将自动使用可能的最大宽度。

如果这个显示文字依附于左右两侧可能会无效。]=]
L["UIPANEL_FONT_XOFFS"] = "X偏移"
L["UIPANEL_FONT_XOFFS_DESC"] = "描点的X轴偏移值"
L["UIPANEL_FONT_YOFFS"] = "Y偏移"
L["UIPANEL_FONT_YOFFS_DESC"] = "描点的Y轴偏移值"
L["UIPANEL_FONTFACE"] = "字体"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "禁用暴雪冷却文字"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = "强制关闭暴雪内置的冷却文字显示。它在你安装了有此类功能的插件时会自动开启禁用。"
L["UIPANEL_GLYPH"] = "雕文"
L["UIPANEL_GLYPH_DESC"] = "检测你是否激活了某一特定的雕文."
L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "按照ID排列"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "按照持续时间排列"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "显示的图标靠前"
L["UIPANEL_GROUPALPHA"] = "分组不透明度"
L["UIPANEL_GROUPALPHA_DESC"] = [=[设置整个分组的不透明度等级.

此选项对图标原本的功能没有任何影响,仅改变这个分组所有图标的外观.

如果你要隐藏整个分组并且仍然允许此分组下的图标正常运作,请将此选项设置为0(该选项有点类似于图标设置中的%q).]=]
L["UIPANEL_GROUPNAME"] = "重命名此分组"
L["UIPANEL_GROUPRESET"] = "重置位置"
L["UIPANEL_GROUPS"] = "分组"
L["UIPANEL_GROUPS_DROPDOWN"] = "选择/创建分组"
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [=[使用此菜单加载要配置的其他组，或创建新组。

您也可以|cff7fffff右键点击|r在屏幕上的图标加载该图标的组。]=]
L["UIPANEL_GROUPS_GLOBAL"] = "|cff00c300共用|r分组"
L["UIPANEL_GROUPSORT"] = "图标排列"
L["UIPANEL_GROUPSORT_ADD"] = "增加优先级"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "为分组新增一个图标优先级排序."
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "无可用优先级"
L["UIPANEL_GROUPSORT_ALLDESC"] = [=[|cff7fffff点击|r更改此排序优先级的方向。
|cff7fffff点击并拖动|r重新排列。

拖动到底部删除。]=]
L["UIPANEL_GROUPSORT_alpha"] = "不透明度"
L["UIPANEL_GROUPSORT_alpha_1"] = "透明靠前"
L["UIPANEL_GROUPSORT_alpha_-1"] = "不透明靠前"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "分组将根据图标的不透明度来排列"
L["UIPANEL_GROUPSORT_duration"] = "持续时间"
L["UIPANEL_GROUPSORT_duration_1"] = "短持续时间靠前"
L["UIPANEL_GROUPSORT_duration_-1"] = "长持续时间靠前"
L["UIPANEL_GROUPSORT_duration_DESC"] = "分组将根据图标剩余的持续时间来排列."
L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_1"] = "总是隐藏靠后"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "总是隐藏靠前"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "按 %q 设置的状态对组进行排序。"
L["UIPANEL_GROUPSORT_id"] = "图标ID"
L["UIPANEL_GROUPSORT_id_1"] = "低IDs靠前"
L["UIPANEL_GROUPSORT_id_-1"] = "高IDs靠前"
L["UIPANEL_GROUPSORT_id_DESC"] = "分组将根据图标ID数字来排列."
L["UIPANEL_GROUPSORT_PRESETS"] = "选择预设值..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "从预设排序优先级列表中选择以应用于此图标。"
L["UIPANEL_GROUPSORT_shown"] = "显示"
L["UIPANEL_GROUPSORT_shown_1"] = "隐藏的图标靠前"
L["UIPANEL_GROUPSORT_shown_-1"] = "显示的图标靠前"
L["UIPANEL_GROUPSORT_shown_DESC"] = "分组将根据图标是否显示来排列."
L["UIPANEL_GROUPSORT_stacks"] = "叠加数量"
L["UIPANEL_GROUPSORT_stacks_1"] = "低堆叠靠前"
L["UIPANEL_GROUPSORT_stacks_-1"] = "高堆叠靠前"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "分组将根据每个图标的叠加数量来排列."
L["UIPANEL_GROUPSORT_value"] = "数值"
L["UIPANEL_GROUPSORT_value_1"] = "低数值靠前"
L["UIPANEL_GROUPSORT_value_-1"] = "高数值靠前"
L["UIPANEL_GROUPSORT_value_DESC"] = "按进度条值对组进行排序。 这是 %s 图标类型提供的值。"
L["UIPANEL_GROUPSORT_valuep"] = "百分比数值"
L["UIPANEL_GROUPSORT_valuep_1"] = "低值％优先"
L["UIPANEL_GROUPSORT_valuep_-1"] = "高值％优先"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "按进度条值百分比对组进行排序。 这是 %s 图标类型提供的值。"
L["UIPANEL_GROUPTYPE"] = "分组显示方式"
L["UIPANEL_GROUPTYPE_BAR"] = "计时条"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "分组使用图标+进度条的方式来显示."
L["UIPANEL_GROUPTYPE_BARV"] = "垂直计量条"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = "在分组中的图标将会显示垂直的计量条。"
L["UIPANEL_GROUPTYPE_ICON"] = "图标"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "分组使用TellMeWhen传统的图标方式来显示."
L["UIPANEL_HIDEBLIZZCDBLING"] = "禁用暴雪自带的冷却完成动画"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [=[禁止暴雪增加的计时器冷却结束时的闪光效果。

此效果暴雪添加于6.2版本。]=]
L["UIPANEL_ICONS"] = "图标"
L["UIPANEL_ICONSPACING"] = "图标间距"
L["UIPANEL_ICONSPACING_DESC"] = "同组图标之间的间隔距离"
L["UIPANEL_ICONSPACINGX"] = "图标横向间隔"
L["UIPANEL_ICONSPACINGY"] = "图标纵向间隔"
L["UIPANEL_LEVEL"] = "框体优先级"
L["UIPANEL_LEVEL_DESC"] = "在组的层次内，应该绘制的等级。"
L["UIPANEL_LOCK"] = "锁定位置"
L["UIPANEL_LOCK_DESC"] = "锁定该组,禁止移动或改变比例."
L["UIPANEL_LOCKUNLOCK"] = "锁定/解锁插件"
L["UIPANEL_MAINOPT"] = "主选项"
L["UIPANEL_ONLYINCOMBAT"] = "仅在战斗中显示"
L["UIPANEL_PERFORMANCE"] = "性能"
L["UIPANEL_POINT"] = "附着点"
L["UIPANEL_POINT2_DESC"] = "将组的 %s 锚定到锚定目标。"
L["UIPANEL_POSITION"] = "位置"
L["UIPANEL_PRIMARYSPEC"] = "主天赋"
L["UIPANEL_PROFILES"] = "配置文件"
L["UIPANEL_PTSINTAL"] = "天赋使用点数(非天赋树)"
L["UIPANEL_PVPTALENTLEARNED"] = "已学荣誉天赋"
L["UIPANEL_RELATIVEPOINT"] = "附着位置"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "将组锚到 %s 的锚定目标的。"
L["UIPANEL_RELATIVETO"] = "附着框体"
L["UIPANEL_RELATIVETO_DESC"] = [=[输入'/framestack'来观察当前鼠标指针所在框体的提示信息,以便寻找需要输入文本框的框体名称.

需要更多帮助,请访问http://www.wowpedia.org/API_Region_SetPoint]=]
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "当前值是另一分组的唯一标识符。它是在该分组右键点击并拖拽到另一分组并且\"依附到\"选项被选中时设置的。 "
L["UIPANEL_ROLE_DESC"] = "勾选此项允许在你当前专精可以担任这个职责时显示分组。"
L["UIPANEL_ROWS"] = "行"
L["UIPANEL_SCALE"] = "比例"
L["UIPANEL_SECONDARYSPEC"] = "副天赋"
L["UIPANEL_SHOWCONFIGWARNING"] = "显示设置模式警告"
L["UIPANEL_SPEC"] = "双天赋"
L["UIPANEL_SPECIALIZATION"] = "天赋类型"
L["UIPANEL_SPECIALIZATIONROLE"] = "专精职责"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "检测你当前专精所能满足的职责（坦克，治疗，伤害输出）。"
L["UIPANEL_STRATA"] = "框体层级"
L["UIPANEL_STRATA_DESC"] = "应该绘制组的UI的层。"
L["UIPANEL_SUBTEXT2"] = [=[图标在锁定后开始工作.
在解除锁定时,你可以移动图标分组(或更改大小),右键点击图标打开设置页面.

你可以输入'/tellmewhen'或'/tmw'来锁定/解除锁定.]=]
L["UIPANEL_TALENTLEARNED"] = "已学天赋"
L["UIPANEL_TOOLTIP_COLUMNS"] = "设置在本组中的图标列数"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "重置该组的位置跟比例"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "勾选此项使该分组仅在战斗中显示"
L["UIPANEL_TOOLTIP_ROWS"] = "设置在本组中的图标行数"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "设置图标显示/隐藏,透明度,条件等的更新频率(秒).0为最快.低端电脑请自重,设置数值过低会使帧数明显降低."
L["UIPANEL_TREE_DESC"] = "勾选来允许该组在某个天赋树激活时显示，或者不勾选让它在天赋树没激活时隐藏。"
L["UIPANEL_UPDATEINTERVAL"] = "更新间隔"
L["UIPANEL_USE_PROFILE"] = "使用个人档设置"
L["UIPANEL_WARNINVALIDS"] = "提示无效的图标"
L["UIPANEL_WARNINVALIDS_DESC"] = [=[如果勾选此项， TellMeWhen会在检测到你的图标存在无效的设置时警告你。

非常推荐开启这个选项，某些错误的设置可能会让你的电脑变得非常卡。]=]
L["UNDO"] = "撤消"
L["UNDO_DESC"] = "取消最后所做的更改操作。"
L["UNITCONDITIONS"] = "单位条件"
L["UNITCONDITIONS_DESC"] = [=[点击以便设置条件在上面输入的全部单位中筛选出你想用于检测的每个单位.

译者注:
单位条件可用于像是检测团队中哪几个人缺少耐力,或者像是检测团队中的某个坦克中了魔法/疾病等等,这只是我随便举的两个例子,实际应用范围更大.(两个例子的前提都有在单位框中输入了player,raid1-40,party1-4)]=]
L["UNITCONDITIONS_STATICUNIT"] = "<图标单位>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "该条件将检测正在被图标检测中的每个单位。"
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "<图标单位>的目标"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "该条件将检查图标正在检测之中的每个单位的目标."
L["UNITCONDITIONS_TAB_DESC"] = "设置条件只让那些你要使用到的单位通过."
L["UNITTWO"] = "第二单位"
L["UNKNOWN_GROUP"] = "<未知/不可用分组>"
L["UNKNOWN_ICON"] = "<未知/不可用图标>"
L["UNKNOWN_UNKNOWN"] = "<未知???>"
L["UNNAMED"] = "(未命名)"
L["UP"] = "上"
L["VALIDITY_CONDITION_DESC"] = "条件中检测的图标是无效的 >>>"
L["VALIDITY_CONDITION2_DESC"] = "第%d个条件>>>"
L["VALIDITY_ISINVALID"] = "."
L["VALIDITY_META_DESC"] = "整合图标中检测的第%d个图标是无效的 >>>"
L["WARN_DRMISMATCH"] = [=[警告!你正在检测递减的法术来自两个不同的已知分类.

在同一个递减图标中,用于检测的所有法术应当使用同一递减分类才能使图标正常运行.

检测到下列你所使用的法术及其分类:]=]
L["WATER"] = "水之图腾"
L["worldboss"] = "首领"
