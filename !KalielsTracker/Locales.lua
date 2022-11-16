--[[------------------------------------------------------------
zhCN locale by 163UI
---------------------------------------------------------------]]

local name, KT = ...
KT.L = CoreBuildLocale()

local cNote = "|cff00ffe3"
local cBold = "|cff00ffe3"

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    --------------- Filters.lua -----------------
    KT.L["Filter"] = "筛选"
    KT.L[" Quests"] = " 任务"
    KT.L[" Achievements"] = " 成就"
    KT.L["Quests"] = "任务"
    KT.L["All"] = "全部"
    KT.L["|cff00ff00Auto|r Zone"] = "|cff00ff00自动|r 当前地图"
    KT.L["Favorites"] = "收藏"	
    KT.L["Zone"] = "当前地图"
    KT.L["Daily"] = "日常"
	KT.L["Daily / Weekly"] = "日常/周常"
    KT.L["Instance"] = "副本"
    KT.L["Complete"] = "已完成"
	KT.L["Unfinished"] = "未完成"
    KT.L["Untrack All"] = "取消全部追踪"
    KT.L["Achievements"] = "成就"
    KT.L["Categories"] = "分类"
    KT.L["World Event"] = "世界事件"
    KT.L["WEvent"] = "世界事件"
    KT.L["Pets"] = "宠物"
    KT.L["Check All"] = "选择全部"
    KT.L["There is currently no World Event."] = "当前没有世界事件"
    KT.L["World Event - "] = "世界事件 - "

    ------------- KalielsTracker.lua ----------------
    KT.L[name] = "任务追踪增强"
    KT.L["Alt+Click - addon Options"] = "ALT+左键 打开设置面板"
    KT.L["Shift+Click - Move Panel"] = "SHT+左键 移动追踪面板"
    KT.L["%d/%d Quests  -  %d Dailies"] = "%d/%d 任务 - %d 日常"

    ------------- Options.lua -----------------------
    KT.L["Supported addons"] = "额外支持插件"
    KT.L["|cffff7fff[Beta]|r"] = "|cffff7fff[测试版]|r"
    KT.L["Warning:|r UI will be re-loaded!"] = "警告: 即将重新加载界面"
    KT.L["Options"] = "选项"
    KT.L["Info"] = "信息"
    KT.L[" |cffffd100Version:|r  "] = " |cffffd100版本号:|r  "
    KT.L["Position / Size"] = "位置 / 尺寸"
    KT.L["Anchor point"] = "锚点"
    KT.L["X offset"] = "横向位置"
    KT.L["Y offset"] = "纵向位置"
    KT.L["Max. height"] = "最大高度"
    KT.L["  Max. height is related with value Y offset.\n"..
            "  Content is lesser ... tracker height is automatically increases.\n"..
            "  Content is greater ... tracker enables scrolling."] = " 最大高度与纵向位置相关：\n 如果条目少, 追踪窗口会自动适应高度\n 如果条目继续增多，则支持滚动"
    KT.L["Show scroll indicator"] = "显示滚动条"
    KT.L["Strata"] = "滚动条优先级"
    KT.L["Background / Border"] = "背景 / 边框"
    KT.L["Background texture"] = "背景材质"
    KT.L["Background color"] = "背景颜色"
    KT.L[" For a custom background\n texture set white color."] = "自定义材质请使用白色"
    KT.L["Border texture"] = "边框材质"
    KT.L["Border color"] = "边框颜色"
    KT.L["Border color by |cff%sClass|r"] = "边框使用|cff%s职业|r颜色"
    KT.L["Border transparency"] = "边框透明度"
    KT.L["Border thickness"] = "边框粗细"
    KT.L["Background inset"] = "背景缩进"
    KT.L["Texts"] = "文本"
    KT.L["Font"] = "字体"
    KT.L["Font size"] = "文字大小"
    KT.L["Font flag"] = "字体风格"
    KT.L["Font shadow"] = "文字阴影"
    KT.L["Color by difficulty"] = "使用难度颜色"
    KT.L["Wrap long texts"] = "长文本换行"
    KT.L["Long texts shows on two lines or on one line with ellipsis (...)."] = "长文本多行显示或者单行在末尾显示省略号(...)"
    KT.L["Objective numbers at the beginning "] = "目标数字在前面"
    KT.L["Changing the position of objective numbers at the beginning of the line. "..
            cBold.."Only for deDE, esES, frFR, ruRU locale."] = cNote.."中文已经是这样了"
    KT.L["Headers"] = "标题栏"
    KT.L[" Texture"] = "材质"
    KT.L["Color"] = "颜色"
    KT.L["Use border color"] = "使用边框颜色"
    KT.L["Use border |cff"] = "使用边框|cff"
    KT.L["color|r"] = "颜色|r"
    KT.L[" Text"] = "文本"
    KT.L[" Buttons"] = "按钮"
    KT.L[" Collapsed tracker text"] = "窗口收起时的文本"
    KT.L["None"] = "无"
    KT.L["%d/%d Quests"] = "%d/%d 任务"
    KT.L["Show Quest Log and Achievements buttons"] = "显示任务日志和成就按钮"
    KT.L["Key - Minimize button"] = "热键 - 最小化"
    KT.L["Quest item buttons"] = "任务物品按钮"
    KT.L["Show buttons block background and border"] = "显示物品按钮区的背景和边框"
    KT.L["Enable Active button "] = "启用自动按钮"
    KT.L["Key - Active button"] = "热键 - 自动按钮"
    KT.L["Show Quest item button for CLOSEST quest as \"Extra Action Button\".\n"..
		   cBold.."Key bind is shared with EXTRAACTIONBUTTON1."] = "在'额外快捷键1'上显示最近任务的物品\n"..cBold.."与'额外快捷键1'共享热键"
    KT.L["Other options"] = "其他选项"
    KT.L["Show tooltips"] = "显示鼠标提示"
    KT.L["Show ID"] = "显示任务ID"
    KT.L["Wowhead URL"] = "数据库链接"
    KT.L["Wowhead URL click modifier"] = "数据库链接功能键"
    
    KT.L["Hide empty tracker"] = "没有追踪条目时隐藏"
    KT.L["Collapse in instance"] = "副本中自动收起"
    KT.L["Output for tracker messages"] = "任务进度通报频道"
    KT.L["Show number of Quests"] = "显示任务数量"
    KT.L["Show Achievement points"] = "显示成就点数"
    KT.L["Show number of owned Pets"] = "显示战斗宠物数"
    KT.L[" /kt|r  |cff808080...............|r  Toggle (expand/collapse) the tracker\n"] = " /kt|r  |cff808080...............|r  收起/展开任务追踪框"
    KT.L[" /kt config|r  |cff808080...|r  Show this config window\n"] = " /kt config|r  |cff808080...|r  显示现在这个配置窗口"

    KT.L["Legion Invasion Monitor"] = "军团入侵监控"
    KT.L["Legion Invasion"] = "军团入侵"
    KT.L["Special"] = "特别奉献"

    KT.L[" Skin options - for Quest item buttons or Active button"] = ""
    KT.L["Tracker"] = "任务追踪栏"
    KT.L["Tooltips"] = "鼠标提示"
    KT.L["Show Rewards"] = "显示奖励"
    KT.L["Menu items"] = "右键菜单项目"
    KT.L["Quest default action - World Map"] = "点击任务打开世界地图"
    KT.L["Notification messages"] = "信息通告"
    KT.L["Quest messages"] = "任务信息"
    KT.L["Achievement messages"] = "成就信息"
    KT.L["Notification sounds"] = "提示音效"
    KT.L["Quest sounds"] = "任务音效"
    KT.L["Complete Sound"] = "完成任务提示音"
    KT.L["Auto Quest tracking"] = "自动追踪新接任务"
    KT.L["Auto Quest progress tracking"] = "自动追踪任务进度"

    KT.L["Order of Modules "] = "模块顺序"
    KT.L["Modules"] = "模块排序"
    KT.L["Current Order"] = "当前顺序"
    KT.L["Default Order"] = "默认排序"
    KT.L["Popup "] = "自动弹出的"
    KT.L["Show Quest Zones"] = "显示任务区域"

    KT.L["Show Max. height overlay"] = "显示最大高度轮廓"
    KT.L["Show Quest tags"] = "显示任务标签(等级/类型)"
    KT.L["Show Active button Binding text"] = "显示自动按钮的按键绑定文本"

    KT.L[" Day"] = " 天"
    KT.L[" Hr"] = " 时"
    KT.L[" Min"] = " 分"
    KT.L[" Sec"] = " 秒"

    KT.L["Icecrown Rares"] = "冰冠冰川稀有"
    KT.L["Next Rare:"] = "下一个稀有："
    KT.L["Next Rare: %s in %s at %s"] = "下个稀有: %s in %s at %s"
    KT.L["Icecrown Rare Monitor "] = "冰冠冰川稀有监控 "
    KT.L["Shows Shadowlands Pre-Patch Rares, which are spawns. "] = "显示暗影国度前夕的精英"
    KT.L["This feature has not been tested much!|r"] = "这个功能没有很全面的测试!|r"
    KT.L["Timer Correction"] = "时间微调"
    KT.L["Show only in Icecrown"] = "只在冰冠冰川显示"
    KT.L["  Available actions:\n"] = "支持的操作:\n"
    KT.L["Left Click|r - add waypoint (Blizzard or TomTom)\n"] = "左键点击|r - 添加路点\n"
    KT.L["Right Click|r - remove waypoint (Blizzard or TomTom)\n"] = "右键点击|r - 移除路点\n"
    KT.L["Shift + Left Click|r - send Rare info to General chat channel"] = "SHIFT+左键|r - 发送稀有信息到综合频道"
    KT.L[" (unattackable now)"] = "(现在无法攻击)"
    KT.L["Realm Zone"] = "服务器"
    KT.L["Europe"] = "欧服"
    KT.L["North America"] = "美服"
    KT.L["China"] = "国服"

    --A_={} for i,id in ipairs({174067,174066,174065,174064,174063,174062,174061,174060,174059,174058,174057,174056,174055,174054,174053,174052,174051,174050,174049,174048}) do A_[i]=U1NameResolver:Resolve("unit:Creature-0-0-0-0-"..id) end
    KT.L["Prince Keleseth"] = "凯雷塞斯王子"
    KT.L["The Black Knight"] = "黑骑士"
    KT.L["Bronjahm"] = "布隆亚姆"
    KT.L["(34 slot Bag)"] = "(34格包)"
    KT.L["Scourgelord Tyrannus"] = "天灾领主泰兰努斯"
    KT.L["Forgemaster Garfrost"] = "熔炉之主加弗斯特"
    KT.L["Marwyn"] = "玛维恩"
    KT.L["Falric"] = "法瑞克"
    KT.L["The Prophet Tharon'ja"] = "先知萨隆亚"
    KT.L["Novos the Summoner"] = "召唤者诺沃斯"
    KT.L["Trollgore"] = "托尔戈"
    KT.L["Krik'thir the Gatewatcher"] = "看门者克里克希尔"
    KT.L["Prince Taldaram"] = "塔达拉姆王子"
    KT.L["Elder Nadox"] = "纳多克斯长老"
    KT.L["Noth the Plaguebringer"] = "药剂师诺斯"
    KT.L["Patchwerk"] = "帕奇维克"
    KT.L["Blood Queen Lana'thel"] = "鲜血女王兰娜瑟尔"
    KT.L["Professor Putricide"] = "普崔塞德教授"
    KT.L["Lady Deathwhisper"] = "亡语者女士"
    KT.L["Skadi the Ruthless"] = "残忍的斯卡迪"
    KT.L["(Mount)"] = "(坐骑)"
    KT.L["Ingvar the Plunderer"] = "掠夺者因格瓦尔"
end
