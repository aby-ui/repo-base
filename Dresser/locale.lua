local _, L = ...
local locale = GetLocale()

L.RESET_MODEL = "Reset current model"
L.PLAYER_BUTTON_TEXT = "P"
L.PLAYER_BUTTON_TOOLTIP = "Player character"
L.TARGET_BUTTON_TEXT = "T"
L.TARGET_BUTTON_TOOLTIP = "Target model"
L.TARGET_GEAR_BUTTON_TEXT = "TG"
L.TARGET_GEAR_BUTTON_TOOLTIP = "Target gear"
L.TARGET_GEAR_BUTTON_TOOLTIP_NEWBIE = [[Target gear
> Left-click to equip all items worn
> Right-click to skip head, shirt and tabard]]
L.UNDRESS_BUTTON_TEXT = "U"
L.UNDRESS_BUTTON_TOOLTIP = "Undress unit"
L.UNDRESS_BUTTON_TEXT_FULL = "Undress"

if locale == "deDE" then
elseif locale == "esES" then
elseif locale == "esMX" then
elseif locale == "frFR" then
elseif locale == "itIT" then
elseif locale == "koKR" then
elseif locale == "ptBR" then
elseif locale == "ruRU" then
elseif locale == "zhCN" or locale == "zhTW" then
	L.RESET_MODEL = "重置"
	L.PLAYER_BUTTON_TEXT = "自"
	L.PLAYER_BUTTON_TOOLTIP = "玩家自身模型"
	L.TARGET_BUTTON_TEXT = "目模"
	L.TARGET_BUTTON_TOOLTIP = "使用目标模型"
	L.TARGET_GEAR_BUTTON_TEXT = "目装"
	L.TARGET_GEAR_BUTTON_TOOLTIP = "试穿目标装备"
	L.TARGET_GEAR_BUTTON_TOOLTIP_NEWBIE = [[试穿目标装备
	> 左键点击 试穿全部物品
	> 右键点击 忽略头部、衬衫和战袍]]
	L.UNDRESS_BUTTON_TEXT = "脱"
	L.UNDRESS_BUTTON_TOOLTIP = "脱光所有装备"
	L.UNDRESS_BUTTON_TEXT_FULL = "脱光"
elseif locale == "zhTW" then
end
