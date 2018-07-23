--[[****************************************************************************
  * Locales/Locale-zhTW.lua - Localized string constants (zh-TW).              *
  ****************************************************************************]]
function BGD_init_zhTW()
    BGD_HELP    = "$base 需要幫忙需要幫忙！！！！"
    BGD_SAFE    = "$base 已經安全."
    BGD_INC     = "注意!$base 有 $num 來襲！"
    BGD_INCPLUS = "救命阿！ $base 對面開火車來！"

	BGD_SM_zones = {
		["top"] = "公路/東北",
		["rock"] = "岩石/上",
		["water"] = "水/中",
		["lava"] = "熔岩/下"
	}

	BGD_DWG_zones = {
		["centre_mine"] = "我在中間",
		["goblin_mine"] = "南/妖精 我",
		["pandaren_mine"] = "北/熊貓人 我",
		["alliance_base"] = "聯盟基地",
		["horde_base"] = "部落基地"
	}
end

if (GetLocale() == "zhTW") then
    BGD_AV      = "奧特蘭克山谷"
    BGD_AB      = "阿拉希盆地"
    BGD_WSG     = "戰歌峽谷"
    BGD_WSL     = "戰歌伐木場"
    BGD_SWH     = "銀翼要塞"
    BGD_EOTS    = "暴風之眼"
    BGD_SOTA    = "遠祖灘頭"
    BGD_IOC     = "征服之島"
    BGD_TP      = "雙子峰"
    BGD_DMH     = "龍喉要塞"
    BGD_WHS		= "蠻錘要塞"
    BGD_GIL     = "吉爾尼斯之戰"

    BGD_WG      = "冬握湖"
    BGD_TB      = "托巴拉德"

    BGD_SM		= "碎銀礦坑"
    BGD_DWG		= "深風峽谷"

    BGD_AWAY    = "你並沒有靠近任何防衛點"
    BGD_OUT     = "你不在戰場裡!"

    BGD_GENERAL = "綜合"
end 
