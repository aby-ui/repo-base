local _, ns = ...

local locale = GetLocale()
local L = setmetatable({}, { __index = function(self, k) return "[" .. locale .. "] " .. k end })
ns.L = L

-- enGB/enUS
L.UNDRESS = "Undress"
L.UNDRESS_SHORT = "Und"
L.INSPECT = "Inspect"
L.INSPECT_SHORT = "Ins"
L.TARGET = "Target"
L.TARGET_SHORT = "Tar"
L.PLAYER = "Player"
L.PLAYER_SHORT = "Plr"
L.CUSTOM = "Custom"
L.CUSTOM_SHORT = "Cus"

if locale == "zhCN" or locale == "zhTW" then
L.UNDRESS = "脱光"
L.UNDRESS_SHORT = "脱"
L.INSPECT = "观察对象"
L.INSPECT_SHORT = "观察"
L.TARGET = "目标模型"
L.TARGET_SHORT = "目标"
L.PLAYER = "自身模型"
L.PLAYER_SHORT = "玩家"
L.CUSTOM = "自定义"
L.CUSTOM_SHORT = "自"
end