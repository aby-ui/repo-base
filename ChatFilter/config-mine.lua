-----------------------------------------------------------------------
-- 复制此文件为config-mine.lua
-- 取消对应选项的注释并修改取值，即可替换config.lua里的值，且不会被更新
-----------------------------------------------------------------------
local _, cf = ...

cf.ConfigMine = {
	--["NoProfanityFilter"]     = false, --关闭语言过滤器
	--["NoWhisperSticky"]       = false, --取消持续密语
	--["NoAltArrowkey"]         = false, --取消按住ALT才能移动光标
	--["NoJoinLeaveChannel"]    = true, --关闭进出频道提示
	--["MouseScrollMultiLine"]  = false, --鼠标快速滚动(ctrl首尾&shift跳3行)

	--["MergeTalentSpec"]       = false, --当切换天赋后合并显示“你学会了/忘却了法术...”
	--["FilterPetTalentSpec"]   = false, --不显示“你的宠物学会了/忘却了...”

	--["MergeAchievement"]      = false, --合并显示获得成就
	--["MergeCraftMSG"]         = true, --合并显示“你制造了...”
	--["OtherCraftMSG"]         = true, --过滤掉重复的“...制造了...”

	--["FilterRaidAlert"]       = true, --过滤煞笔RaidAlert的脑残信息
	--["FilterQuestReport"]     = true, --过滤掉烦人的任务通报信息

	--["FilterDuelMSG"]         = true, --过滤“...在决斗中战胜了...”
	--["FilterDrunkMSG"]        = true, --过滤“...喝醉了.”
	--["FilterAuctionMSG"]      = false, --过滤“已开始拍卖/拍卖取消.”

	--["FilterAdvertising"]     = true, --过滤广告信息
	--["AllowMatchs"]           = 2, --允许的关键字配对个数
	--["IgnoreAdTimes"]         = 30, --屏蔽发广告的玩家多长时间(分钟)
	--["IgnoreMore"]            = true, --当屏蔽列表满了后仍然可以屏蔽玩家

	--["FilterMultiLine"]       = true, --过滤多行信息
	--["AllowLines"]            = 3, --允许的最大行数

	--["RepeatAlike"]           = 95, --设定重复信息相似度
	--["RepeatInterval"]        = 30, --设定重复信息间隔时间(秒)

	--["OnlyOnWhisper"]         = nil, --只过滤密语
	--["AddLevelBeforeName"]    = nil, --名字前添加等级

	--["WhiteList"] = { },
	--["BlackList"] = { },
	--["ShieldPlayers"] = { },
    --["SafeWords"] = { },

    ["DangerWords"] = {
        "平台",                 --添加值到config的DangerWords
        ["test"] = 0,          --删除config里的默认值
   	},
}