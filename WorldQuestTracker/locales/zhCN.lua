local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestTrackerAddon", "zhCN") 
if not L then return end

L["S_TUTORIAL_WORLDBUTTONS"] = [=[点击此处切换三种汇总方式:

- |cFFFFAA11按任务类型|r
- |cFFFFAA11按区域|r
- |cFFFFAA11不显示汇总|r

点击 |cFFFFAA11切换世界任务图标|r 可在大地图上隐藏/显示世界任务.]=]
L["S_TUTORIAL_MAPALIGN"] = "点击此处选择世界地图窗口的定位方式"
L["S_MAPFRAME_ALIGN_DESC"] = "|cFF22FF22点击|r 切换世界地图位于屏幕左侧或中间（对于可移动的世界地图来说没有什么用）."
L["S_WORLDBUTTONS_SHOW_NONE"] = "隐藏世界任务汇总"
L["S_WORLDBUTTONS_SHOW_TYPE"] = "显示世界任务汇总"
L["S_WORLDBUTTONS_SHOW_ZONE"] = "按地区显示汇总"
L["S_WORLDBUTTONS_TOGGLE_QUESTS"] = "切换世界任务图标"
L["S_WORLDMAP_QUESTLOCATIONS"] = "显示世界任务位置"
L["S_WORLDMAP_QUESTSUMMARY"] = "显示世界任务汇总"

L["World Quest Tracker"] = "世界任务增强"
L["S_APOWER_AVAILABLE"] = "可用的"
L["S_APOWER_NEXTLEVEL"] = "下一等级"
L["S_DECREASESIZE"] = "减少尺寸"
L["S_ENABLED"] = "已启用"
L["S_ERROR_NOTIMELEFT"] = "此任务已过期。"
L["S_ERROR_NOTLOADEDYET"] = "这个任务还没有被加载，请稍候。"
L["S_FACTION_TOOLTIP_SELECT"] = "点击：选择此阵营"
L["S_FACTION_TOOLTIP_TRACK"] = "Shift+点击：追踪此阵营任务"
L["S_FLYMAP_SHOWTRACKEDONLY"] = "仅被追踪"
L["S_FLYMAP_SHOWTRACKEDONLY_DESC"] = "仅显示正在被追踪的任务"
L["S_FLYMAP_SHOWWORLDQUESTS"] = "显示世界任务"
L["S_GROUPFINDER_ACTIONS_CANCEL_APPLICATIONS"] = "点击取消申请…"
L["S_GROUPFINDER_ACTIONS_CANCELING"] = "取消中…"
L["S_GROUPFINDER_ACTIONS_CREATE"] = "未找到队伍？点击创建"
L["S_GROUPFINDER_ACTIONS_CREATE_DIRECT"] = "创建队伍"
L["S_GROUPFINDER_ACTIONS_LEAVEASK"] = "离开队伍吗？"
L["S_GROUPFINDER_ACTIONS_LEAVINGIN"] = "离开队伍（单击立即离开）："
L["S_GROUPFINDER_ACTIONS_RETRYSEARCH"] = "重新搜索"
L["S_GROUPFINDER_ACTIONS_SEARCH"] = "单击开始搜索队伍"
L["S_GROUPFINDER_ACTIONS_SEARCH_RARENPC"] = "寻找队伍击杀稀有"
L["S_GROUPFINDER_ACTIONS_SEARCH_TOOLTIP"] = "加入队伍做此任务"
L["S_GROUPFINDER_ACTIONS_SEARCHING"] = "搜索中…"
L["S_GROUPFINDER_ACTIONS_SEARCHMORE"] = "点击寻找更多队伍成员"
L["S_GROUPFINDER_ACTIONS_SEARCHOTHER"] = "离开并搜索其他的队伍？"
L["S_GROUPFINDER_ACTIONS_UNAPPLY1"] = "点击移除申请，以便于我们可以创建新队伍"
L["S_GROUPFINDER_ACTIONS_UNLIST"] = "点击后不列出你的队伍"
L["S_GROUPFINDER_ACTIONS_UNLISTING"] = "不列出…"
L["S_GROUPFINDER_ACTIONS_WAITING"] = "等待中…"
L["S_GROUPFINDER_AUTOOPEN_RARENPC_TARGETED"] = "目标为稀有怪物时自动打开"
L["S_GROUPFINDER_ENABLED"] = "新任务时自动启用"
L["S_GROUPFINDER_LEAVEOPTIONS"] = "离开队伍选项"
L["S_GROUPFINDER_LEAVEOPTIONS_AFTERX"] = "X 秒后离开"
L["S_GROUPFINDER_LEAVEOPTIONS_ASKX"] = "不自动离开，只提示 X 秒"
L["S_GROUPFINDER_LEAVEOPTIONS_DONTLEAVE"] = "不显示离开面板"
L["S_GROUPFINDER_LEAVEOPTIONS_IMMEDIATELY"] = "任务完成时立即离开队伍"
L["S_GROUPFINDER_NOPVP"] = "避开 PvP 服务器"
L["S_GROUPFINDER_OT_ENABLED"] = "任务追踪上显示按钮"
L["S_GROUPFINDER_QUEUEBUSY"] = "你已经在队列中。"
L["S_GROUPFINDER_QUEUEBUSY2"] = "不显示团队查找器窗口：已在队伍或查找时。"
L["S_GROUPFINDER_RESULTS_APPLYING"] = "有 %d 个剩余的队伍，请再点击一次"
L["S_GROUPFINDER_RESULTS_APPLYING1"] = "有1个剩余的队伍可加入，请再点击一次"
L["S_GROUPFINDER_RESULTS_FOUND"] = [=[找到%d个队伍
点击开始加入]=]
L["S_GROUPFINDER_RESULTS_FOUND1"] = [=[找到1个队伍
点击开始加入]=]
L["S_GROUPFINDER_RESULTS_UNAPPLY"] = "%d个剩余申请…"
L["S_GROUPFINDER_RIGHTCLICKCLOSE"] = "右击关闭"
L["S_GROUPFINDER_SECONDS"] = "秒"
L["S_GROUPFINDER_TITLE"] = "队伍寻找"
L["S_GROUPFINDER_TUTORIAL1"] = "加入队伍完成相同任务能更快的完成世界任务！"
L["S_INCREASESIZE"] = "增加尺寸"
L["S_MAPBAR_FILTER"] = "过滤"
L["S_MAPBAR_FILTERMENU_FACTIONOBJECTIVES"] = "阵营目标"
L["S_MAPBAR_FILTERMENU_FACTIONOBJECTIVES_DESC"] = "始终显示阵营任务即使他们已被过滤。"
L["S_MAPBAR_OPTIONS"] = "选项"
L["S_MAPBAR_OPTIONSMENU_ARROWSPEED"] = "箭头更新速度"
L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_HIGH"] = "快"
L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_MEDIUM"] = "中"
L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_REALTIME"] = "实时时间"
L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_SLOW"] = "慢"
L["S_MAPBAR_OPTIONSMENU_EQUIPMENTICONS"] = "装备图标"
L["S_MAPBAR_OPTIONSMENU_QUESTTRACKER"] = "启用任务追踪"
L["S_MAPBAR_OPTIONSMENU_REFRESH"] = "刷新"
L["S_MAPBAR_OPTIONSMENU_SOUNDENABLED"] = "启用音效"
L["S_MAPBAR_OPTIONSMENU_STATUSBAR_ONDISABLE"] = "使用“/wqt statusbar”或从用户界面下的插件选项恢复状态栏。"
L["S_MAPBAR_OPTIONSMENU_STATUSBAR_VISIBILITY"] = "显示状态栏"
L["S_MAPBAR_OPTIONSMENU_STATUSBARANCHOR"] = "顶部锚点"
L["S_MAPBAR_OPTIONSMENU_TRACKER_CURRENTZONE"] = "只限当前地区"
L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"] = "跟踪缩放：%s"
L["S_MAPBAR_OPTIONSMENU_TRACKERCONFIG"] = "追踪配置"
L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_AUTO"] = "自动位置"
L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_CUSTOM"] = "自定义位置"
L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_LOCKED"] = "已锁定"
L["S_MAPBAR_OPTIONSMENU_UNTRACKQUESTS"] = "停止追踪所有任务"
L["S_MAPBAR_OPTIONSMENU_WORLDMAPCONFIG"] = "世界地图配置"
L["S_MAPBAR_OPTIONSMENU_YARDSDISTANCE"] = "显示码数距离"
L["S_MAPBAR_OPTIONSMENU_ZONE_QUESTSUMMARY"] = "显示任务概况"
L["S_MAPBAR_OPTIONSMENU_ZONEMAPCONFIG"] = "区域地图配置"
L["S_MAPBAR_RESOURCES_TOOLTIP_TRACKALL"] = "点击追踪所有：|cFFFFFFFF%s|r任务。"
L["S_MAPBAR_SORTORDER"] = "分类排序"
L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_FADE"] = "消退任务"
L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_OPTION"] = "小于%d小时"
L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_SHOWTEXT"] = "剩余时间文本"
L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_SORTBYTIME"] = "以时间排序"
L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_TITLE"] = "剩余时间"
L["S_MAPBAR_SUMMARYMENU_ACCOUNTWIDE"] = "账号汇总"
L["S_OPTIONS_ACCESSIBILITY"] = "辅助"
L["S_OPTIONS_ACCESSIBILITY_EXTRATRACKERMARK"] = "额外追踪标记"
L["S_OPTIONS_ACCESSIBILITY_SHOWBOUNTYRING"] = "显示额外奖励圆环"
L["S_OPTIONS_ANIMATIONS"] = "进行动画"
L["S_OPTIONS_MAPFRAME_ALIGN"] = "地图窗口置于中部"
L["S_OPTIONS_MAPFRAME_ERROR_SCALING_DISABLED"] = "需要首先启用“地图窗口缩放”，没有数值被更改。"
L["S_OPTIONS_MAPFRAME_SCALE"] = "地图窗口缩放"
L["S_OPTIONS_MAPFRAME_SCALE_ENABLED"] = "启用地图窗口缩放"
L["S_OPTIONS_QUESTBLACKLIST"] = "任务黑名单"
L["S_OPTIONS_RESET"] = "重置"
L["S_OPTIONS_SHOWFACTIONS"] = "显示阵营"
L["S_OPTIONS_TIMELEFT_NOPRIORITY"] = "时间剩余无优先级"
L["S_OPTIONS_TRACKER_RESETPOSITION"] = "重置位置"
L["S_OPTIONS_WORLD_ANCHOR_LEFT"] = "左侧锚点"
L["S_OPTIONS_WORLD_ANCHOR_RIGHT"] = "右侧锚点"
L["S_OPTIONS_WORLD_DECREASEICONSPERROW"] = "减少每行块数"
L["S_OPTIONS_WORLD_INCREASEICONSPERROW"] = "增加每行块数"
L["S_OPTIONS_WORLD_ORGANIZE_BYMAP"] = "按地图分类"
L["S_OPTIONS_WORLD_ORGANIZE_BYTYPE"] = "按任务类型分类"
L["S_OPTIONS_ZONE_SHOWONLYTRACKED"] = "只已追踪"
L["S_OVERALL"] = "全部"
L["S_PARTY"] = "队伍"
L["S_PARTY_DESC1"] = "任务有蓝色星星的代表全部队友有此任务。"
L["S_PARTY_DESC2"] = "如果红星显示，队友没有世界任务资格或者还没有安装 WQT。"
L["S_PARTY_PLAYERSWITH"] = "队伍中使用 WQT 的玩家："
L["S_PARTY_PLAYERSWITHOUT"] = "队伍中没有使用 WQT 的玩家："
L["S_QUESTSCOMPLETED"] = "已经完成的任务"
L["S_QUESTTYPE_ARTIFACTPOWER"] = "神器能量"
L["S_QUESTTYPE_DUNGEON"] = "地下城"
L["S_QUESTTYPE_EQUIPMENT"] = "装备"
L["S_QUESTTYPE_GOLD"] = "金币"
L["S_QUESTTYPE_PETBATTLE"] = "宠物对战"
L["S_QUESTTYPE_PROFESSION"] = "专业"
L["S_QUESTTYPE_PVP"] = "PvP"
L["S_QUESTTYPE_RESOURCE"] = "资源"
L["S_QUESTTYPE_TRADESKILL"] = "商业技能"
L["S_RAREFINDER_ADDFROMPREMADE"] = "在预创建队伍添加已找到稀有"
L["S_RAREFINDER_NPC_NOTREGISTERED"] = "稀有不在数据库中"
L["S_RAREFINDER_OPTIONS_ENGLISHSEARCH"] = "总是使用英语查找"
L["S_RAREFINDER_OPTIONS_SHOWICONS"] = "激活稀有显示图标"
L["S_RAREFINDER_SOUND_ALWAYSPLAY"] = "音效已禁用时仍播放"
L["S_RAREFINDER_SOUND_ENABLED"] = "迷你地图出现稀有时播放音效"
L["S_RAREFINDER_SOUNDWARNING"] = "迷你地图出现稀有时已播放音效，可以在选项菜单 > 稀有查找器子菜单禁用此音效。"
L["S_RAREFINDER_TITLE"] = "稀有查找器"
L["S_RAREFINDER_TOOLTIP_REMOVE"] = "移除"
L["S_RAREFINDER_TOOLTIP_SEACHREALM"] = "在其他服务器搜索"
L["S_RAREFINDER_TOOLTIP_SPOTTEDBY"] = "发现人"
L["S_RAREFINDER_TOOLTIP_TIMEAGO"] = "分钟"
L["S_SUMMARYPANEL_EXPIRED"] = "已过期"
L["S_SUMMARYPANEL_LAST15DAYS"] = "最近15天"
L["S_SUMMARYPANEL_LIFETIMESTATISTICS_ACCOUNT"] = "账号在线时间统计"
L["S_SUMMARYPANEL_LIFETIMESTATISTICS_CHARACTER"] = "角色在线时间统计"
L["S_SUMMARYPANEL_OTHERCHARACTERS"] = "其他角色"
L["S_TUTORIAL_AMOUNT"] = "显示接收量"
L["S_TUTORIAL_CLICKTOTRACK"] = "点击追踪任务。"
L["S_TUTORIAL_PARTY"] = "队伍中时，蓝星显示此全部队友有此任务！"
L["S_TUTORIAL_STATISTICS_BUTTON"] = "点击这里查看统计和其它角色已保存列表。"
L["S_TUTORIAL_TIMELEFT"] = "显示剩余时间（大于4小时，大于90分钟，大于30分钟，小于30分钟）"
L["S_TUTORIAL_WORLDBUTTONS"] = [=[点击这里可在三种类型的摘要中循环：

- |cFFFFAA11按任务类型|r
- |cFFFFAA11按区域|r
- |cFFFFAA11无|r

点击|cFFFFAA11切换任务|r隐藏任务地点。]=]
L["S_TUTORIAL_WORLDMAPBUTTON"] = "点击这个按钮将向你显示破碎群岛地图。"
L["S_UNKNOWNQUEST"] = "未知任务"
L["S_WHATSNEW"] = "更新了什么？"
L["S_WORLDBUTTONS_SHOW_NONE"] = "隐藏概况"
L["S_WORLDBUTTONS_SHOW_TYPE"] = "显示概况"
L["S_WORLDBUTTONS_SHOW_ZONE"] = "按区域排列"
L["S_WORLDBUTTONS_TOGGLE_QUESTS"] = "切换任务"
L["S_WORLDMAP_QUESTLOCATIONS"] = "显示任务位置"
L["S_WORLDMAP_QUESTSUMMARY"] = "显示任务概况"
L["S_WORLDMAP_TOOGLEQUESTS"] = "切换任务"
L["S_WORLDMAP_TOOLTIP_TRACKALL"] = "追踪此列表上全部任务"
L["S_WORLDQUESTS"] = "世界任务"
L["Search for a Group in Group Finder"] = "用预创建寻找队伍"
L["Quest ID:"] = "任务ID:"
L["Quest Name:"] = "任务名:"
L["LeaveGroup"] = "离开队伍"
L["Ignore Quest"] = "忽略此任务"
L["right click to close this window"] = "右键点击关闭本窗口"
L["Invite Nearby Players"] = "邀请附近的玩家"
