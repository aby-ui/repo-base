------------------------------------------------------------
-- zhTW.lua
-- 繁體中文

-- Abin
-- 2011/1/05
------------------------------------------------------------

if GetLocale() == "zhTW" then
	MERCHANTEX_LOCALE = {
		["title"] = "MerchantEx",
		["auto options"] = "自動選項",
		["repair"] = "修理裝備",
		["guild repair"] = "公會銀行支付",
		["sell"] = "出售垃圾",
		["details"] = "顯示詳情",
		["buy"] = "購買材料",
		["overbuy"] = "允許超量購買",
		["trade options"] = "交易選項",
		["exceptions"] = "例外列表",
		["buyings"] = "購買列表",
		["exception tooltip"] = "與通常情況相反，在例外列表中的白色物品將被出售而灰色物品將被保留。",
		["buy tooltip"] = "在購買列表中的物品將被自動購買以維持設定的數量。",
		["capture prompt"] = "要添加物品，請把物品扔到列表中，或在聊天窗口中Shift+點擊一個物品鏈接。",
		["sell prompt"] = "將這件白色物品作為垃圾自動出售？",
		["keep prompt"] = "將這件灰色物品作為有用之物保留？",
		["this item cannot be traded"] = "這件物品無法被交易",
		["must be an item"] = "必須是一件物品",
		["must be gray or white items"] = "必須是|cff9d9d9d灰色|r或|cffffffff白色|r物品",
		["char"] = "角色",
		["buy qty"] = "維持數量：",
		["repair cannot afford"] = "|cffff0000你沒有足夠的錢修理所有裝備。|r",
		["buy cannot afford"] = "|cffff0000你沒有足夠的錢購買物品:|r ",
		["sold trash"] = "出售垃圾 |cff00ff00收入:|r ",
		["repaired items"] = "修理裝備 |cffff0000支出:|r ",
		["repaired items by using guild bank"] = "公會銀行修理裝備 |cffff0000支出:|r ",
		["guild bank cannot afford repair, will repair by your own money"] = "|cffff0000公會銀行可用金額不足，改用自己的金幣修理。|r",
		["refilled items"] = "購買材料 |cffff0000支出:|r ",
		["sold"] = "售出 ",
		["earned"] = "|cff00ff00自動修理販賣獲利:|r ",
		["lost"] = "|cffff0000自動修理販賣虧損:|r ",
		["equal"] = "自動修理販賣沒有產生盈虧。",
        ["earned final"] = "|cff00ff00本次交易總計獲利:|r ",
        ["lost final"] = "|cffff0000本次交易總計虧損:|r ",
        ["equal final"] = "本次交易沒有產生盈虧。",
	}
end