------------------------------------------------------------
-- zhTW.lua
-- 简体中文

-- Abin
-- 2011/1/05
------------------------------------------------------------

if GetLocale() == "zhCN" then
	MERCHANTEX_LOCALE = {
		["title"] = "爱不易",
		["auto options"] = "自动选项",
		["repair"] = "修理装备",
		["guild repair"] = "公会银行支付",
		["sell"] = "出售垃圾",
		["details"] = "显示详情",
		["buy"] = "购买材料",
		["overbuy"] = "允许超量购买",
		["trade options"] = "交易选项",
		["exceptions"] = "例外列表",
		["buyings"] = "购买列表",
		["exception tooltip"] = "与通常情况相反，在例外列表中的白色物品将被出售而灰色物品将被保留。",
		["buy tooltip"] = "在购买列表中的物品将被自动购买以维持设定的数量。",
		["capture prompt"] = "要添加物品，请把物品扔到列表中，或在聊天窗口中Shift+点击一个物品链接。",
		["sell prompt"] = "将这件白色物品作为垃圾自动出售？",
		["keep prompt"] = "将这件灰色物品作为有用之物保留？",
		["this item cannot be traded"] = "这件物品无法被交易",
		["must be an item"] = "必须是一件物品",
		["must be gray or white items"] = "必须是|cff9d9d9d灰色|r或|cffffffff白色|r物品",
		["char"] = "角色",
		["buy qty"] = "维持数量：",
		["repair cannot afford"] = "|cffff0000你没有足够的钱修理所有装备。|r",
		["buy cannot afford"] = "|cffff0000你没有足够的钱购买物品:|r ",
		["sold trash"] = "出售垃圾 |cff00ff00收入:|r ",
		["repaired items"] = "修理装备 |cffff0000支出:|r ",
		["repaired items by using guild bank"] = "公会银行修理装备 |cffff0000支出:|r ",
		["guild bank cannot afford repair, will repair by your own money"] = "|cffff0000公会银行可用金额不足，改用自己的金币修理。|r",
		["refilled items"] = "购买材料 |cffff0000支出:|r ",
		["sold"] = "售出 ",
		["earned"] = "|cff00ff00自动修理贩卖获利:|r ",
		["lost"] = "|cffff0000自动修理贩卖亏损:|r ",
		["equal"] = "自动修理贩卖没有产生盈亏。",

        ["earned final"] = "|cff00ff00本次交易总计获利:|r ",
   		["lost final"] = "|cffff0000本次交易总计亏损:|r ",
   		["equal final"] = "本次交易没有产生盈亏。",
	}
end