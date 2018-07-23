local name, KT = ...
KT.L = CoreBuildLocale()

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then

KT.L[name] = "玩具箱(ToyPlus)"

KT.L["Columns"] = "一行的按钮个数"
KT.L["Rows"] = "玩具箱行数"
KT.L["Scale"] = "缩放比例"
KT.L["Show Minimap Icon"] = "显示小地图按钮"
KT.L["Blue Theme"] = "蓝色界面"
KT.L["Search:"] = "搜索："


KT.L['Left-click menu icon to toggle toy buttons.'] = "左键点击：切换玩具箱窗口"
KT.L['Right-click menu icon for configuration.'] = "右键点击：配置选项"
KT.L['No favourites found. Add some via the toy list.'] = "没有任何偏好，先在列表里添加一些吧."
KT.L["Toy List"] = "列表"

KT.L["ToyPlus: Error: \124cffffffffCan't do that while in combat."] = "【玩具箱】错误：\124cffffffff战斗中不能这样做"
KT.L["ToyPlus: Error: \124cffffffffToy Box hasn't been loaded or no toys found."] = "【玩具箱】错误：\124cffffffff藏品插件未加载或没有玩具"
KT.L["ToyPlus: Error: \124cffffffffCan't adjust rows in combat."] = "【玩具箱】错误：\124cffffffff战斗中不能调整行数"

KT.L["Remove Favorite"] = "从偏好中移除"
KT.L["Add Favorite"] = "设置为偏好"
end