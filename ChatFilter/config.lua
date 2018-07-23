-----------------------------------------------------------------------
-- Config
-----------------------------------------------------------------------
local _, cf = ...

cf.Config = {
	["Enabled"] = true, --Enable the ChatFilter. // 是否开启本插件

	["NoProfanityFilter"] = false, --Disable the profanityFilter. // 关闭语言过滤器
	["NoWhisperSticky"] = false, --Disable the sticky of Whisper. // 取消持续密语
	["NoAltArrowkey"] = false, --Disable the AltArrowKeyMode. // 取消按住ALT才能移动光标
	["NoJoinLeaveChannel"] = true, --Disable the alert joinleaveChannel. // 关闭进出频道提示
	["MouseScrollMultiLine"] = false, --Mouse Scroll MultiLine. // 鼠标快速滚动(ctrl首尾&shift跳3行)

	["MergeTalentSpec"] = false, --Merge the messages:"You have learned/unlearned..." // 当切换天赋后合并显示“你学会了/忘却了法术...”
	["FilterPetTalentSpec"] = false, --Filter the messages:"Your pet has learned/unlearned..." // 不显示“你的宠物学会了/忘却了...”

	["MergeAchievement"] = false, --Merge the messages:"...has earned the achievement..." // 合并显示获得成就
	["MergeCraftMSG"] = true, --Merge the messages:"You has created..." // 合并显示“你制造了...”
	["OtherCraftMSG"] = true, --Filter the repeat messages:"... has created..." // 过滤掉重复的“...制造了...”

	["FilterRaidAlert"] = true, --Filter the bullshit messages from RaidAlert. // 过滤煞笔RaidAlert的脑残信息
	["FilterQuestReport"] = true, --Filter the bullshit messages from QuestReport. // 过滤掉烦人的任务通报信息

	["FilterDuelMSG"] = true, --Filter the messages:"... has defeated/fled from ... in a duel." // 过滤“...在决斗中战胜了...”
	["FilterDrunkMSG"] = true, --Filter the drunk messages:"... has drunked ..."// 过滤“...喝醉了.”
	["FilterAuctionMSG"] = false, --Filter the messages:"Auction created/cancelled."// 过滤“已开始拍卖/拍卖取消.”

	["FilterAdvertising"] = true, --Filter the advertising messages. // 过滤广告信息
	["AllowMatchs"] = 2, --How many words can be allowd to use. // 允许的关键字配对个数
	["IgnoreAdTimes"] = 30, --How many times shall we shield the advertising. // 屏蔽发广告的玩家多长时间(分钟)
	["IgnoreMore"] = true, --When the ignorelist is full, you can still ignore players. // 当屏蔽列表满了后仍然可以屏蔽玩家

	["FilterMultiLine"] = true, --Filter the multiple messages. // 过滤多行信息
	["AllowLines"] = 3, --How many lines can be allowd. // 允许的最大行数

	["FilterRepeat"] = true, --Filter the repeat messages. // 过滤重复聊天信息
	["RepeatAlike"] = 95, --Set the similarity between the messages. // 设定重复信息相似度
	["RepeatInterval"] = 30, --Set the interval between the messages. // 设定重复信息间隔时间(秒)

	["FilterByLevel"] = nil, --Filter the messages by level. // 屏蔽小号发言
	["OnlyOnWhisper"] = nil, --Only filter the whisper messages. // 只过滤密语
	["AllowLevel"] = 1, --Filter the messages by level. // 屏蔽多少级以下的发言
	["AddLevelBeforeName"] = nil, --Add the Level before the Name. // 名字前添加等级

	["SafeWords"] = {
		"recruit",
		"dkp",
		"looking",
		"lf[gm]",
		"|cff",
		"raid",
		"recount",
		"skada",
		"boss",
		"dps",
	},
	["DangerWords"] = {
		"平台",
		"平臺",
		"工作室",
		"专卖店",
		"大卡",
		"小卡",
		"点卡",
		"点心",
		"點卡",
		"點心",
		"烧饼",
		"大饼",
		"小饼",
		"烧圆形",
		"大圆形",
		"小圆形",
		"烧rt2",
		"大rt2",
		"小rt2",
		"rt2rt2",
		"担保",
		"擔保",
		"承接",
		"手工",
		"手打",
		"代打",
		"代练",
		"代刷",
		"带打",
		"带练",
		"带刷",
		"dai打",
		"dai练",
		"dai刷",
		"带评级",
		"代评级",
		"打金",
		"卖金",
		"售金",
		"出金",
		"萬金",
		"万金",
		"w金",
		"打g",
		"卖g",
		"售g",
		"萬g",
		"万g",
		"wg",
		"详情",
		"详谈",
		"详询",
		"信誉",
		"信赖",
		"充值",
		"储值",
		"服务",
		"套餐",
		"刷屏[勿见]",
		"扰屏[勿见]",
		"绑定.*上马",
		"上马.*绑定",
		"价格公道",
		"货到付款",
		"非诚勿扰",
		"先.*后钱",
		"先.*后款",
		"价.*优惠",
		"代.*s1",
		"售.*s1",
		"游戏币",
		"最低价",
		"无黑金",
		"不封号",
		"无风险",
		"好再付",
		"年老店",
		"金=",
		"g=",
		"元=",
		"5173",
		"支付宝",
		"支付寶",
		"淘宝",
		"淘寶",
		"皇冠",
		"冲冠",
		"热销",
		"促销",
		"qq",
		"加q",
		"企业q",
		"咨询",
		"联系",
		"电话",
		"旺旺",
		"口口",
		"扣扣",
		"叩叩",
		"歪歪",
		"丫丫",
		"yy",
		"大神带你打",
		"高手帮忙打",
		"竞技场大师",
		"血腥舞钢fm",
		"满及",
		"taobao",
		"8o",
		"9o",
		"八[o0]",
		"九[o0]",
		"０",
		"○",
		"①",
		"②",
		"③",
		"④",
		"⑤",
		"⑥",
		"⑦",
		"⑧",
		"⑨",
		"泏",
		"釒",
	},
	["WhiteList"] = {
	},
	["BlackList"] = {
		"86410866",
		"24267225",
	},
	["ShieldPlayers"] = {
	},
}

ChatFilterConfig = cf.Config

local function MergeList(listName)
    local mine = cf.ConfigMine[listName]
    local default = cf.Config[listName]
    if type(mine) == "table" and type(default) == "table" then
        local map = {}
        for _, v in ipairs(default) do
            map[v] = true
        end
        for i=1, #mine do
            local new = tremove(mine, 1)
            if not map[new] then
                tinsert(default, new)
            end
        end
        for k,v in pairs(mine) do
            if map[k] then
                tremovedata(default, k)
            end
        end
    end
end

if cf.ConfigMine then
    for k,v in pairs(cf.ConfigMine) do
        if v ~= nil and type(cf.Config[k]) ~= "table" then
            cf.Config[k] = v
        end
    end
    MergeList("DangerWords")
    MergeList("SafeWords")
end