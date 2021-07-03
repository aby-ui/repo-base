-- QuestData.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/21/2021, 10:56:19 AM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

QUEST_CFG_DATA = { --
    [1] = {
        title = [[{{GetTimeLimitText}}通关{{progressMaxValue}}次{{challengeLevel}}层及以上史诗钥石地下城]],
        proto = {'challengeLevel', 'timeLimit'},
    },
}
