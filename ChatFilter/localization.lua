-----------------------------------------------------------------------
-- Locals
-----------------------------------------------------------------------
local _, cf = ...

if (GetLocale() == "zhCN") then
	cf.L = {
		["You"] = YOU,
		["Space"] = "、",
		["Channel"] = "大脚世界频道",
		["RaidAlert"] = "%*%*(.+)%*%*",
		["QuestReport"] = "任务进度%s?[:：]",
		["Achievement"] = "%s获得了成就%s!",
		["LearnSpell"] = "你学会了技能: %s",
		["UnlearnSpell"] = "你遗忘了技能: %s",
	}
elseif (GetLocale() == "zhTW") then
	cf.L = {
		["You"] = YOU,
		["Space"] = "、",
		["Channel"] = "大腳世界頻道",
		["RaidAlert"] = "%*%*(.+)%*%*",
		["QuestReport"] = "任務進度%s?[:：]",
		["Achievement"] = "%s獲得了成就%s!",
		["LearnSpell"] = "你學會了技能: %s",
		["UnlearnSpell"] = "你遺忘了技能: %s",
	}
else
	cf.L = {
		["You"] = YOU,
		["Space"] = ", ",
		["Channel"] = "Bigfootworldchannel",
		["RaidAlert"] = "%*%*(.+)%*%*",
		["QuestReport"] = "Quest progress%s?:",
		["Achievement"] = "[%s] have earned the achievement %s!",
		["LearnSpell"] = "You have learned: %s",
		["UnlearnSpell"] = "You have unlearned: %s",
	}
end