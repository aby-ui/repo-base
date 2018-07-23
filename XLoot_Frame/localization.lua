-- See: http://wow.curseforge.com/addons/xloot/localization/ to create or fix translations
local locales = {
	enUS = {
		linkall_threshold_missed = "No loot meets your quality threshold",
		button_link = "Link",
		button_close = "Close",
		button_auto = "A",
		button_auto_tooltip = "Add this item to XLoot's autoloot list\nSee /xloot for more info",
		bind_on_use_short = "BoU",
		bind_on_equip_short = "BoE",
		bind_on_pickup_short = "BoP",

		slot_name_error = "Could not get item name for loot slot %s , it may have already been looted. You can turn this message off in /xloot",
		slot_icon_error = "Could not get item icon for loot slot %s , it may have already been looted. You can turn this message off in /xloot",

	},
	-- Possibly localized
	ptBR = {

	},
	frFR = {

	},
	deDE = {

	},
	koKR = {

	},
	esMX = {

	},
	ruRU = {

	},
	zhCN = {

	},
	esES = {

	},
	zhTW = {

	},
}

-- Automatically inserted translations
locales.ptBR["Frame"] = {
}

locales.frFR["Frame"] = {
	["bind_on_equip_short"] = "LqE",
	["bind_on_pickup_short"] = "LqR",
	["bind_on_use_short"] = "LqU",
	["button_close"] = "Fermer",
	["button_link"] = "Lien",
	["linkall_threshold_missed"] = "Aucun butin ne correspond à votre seuil de qualité",
}

locales.deDE["Frame"] = {
	["bind_on_equip_short"] = "BoE",
	["bind_on_pickup_short"] = "BoP",
	["bind_on_use_short"] = "BoU",
	["button_close"] = "Schließen",
	["button_link"] = "Senden",
	["linkall_threshold_missed"] = "Beute entspricht nicht deinen Qualitätsansprüchen",
}

locales.koKR["Frame"] = {
	["bind_on_equip_short"] = "착귀",
	["bind_on_pickup_short"] = "획귀",
	["bind_on_use_short"] = "사귀",
	["button_close"] = "닫기",
	["button_link"] = "링크",
	["linkall_threshold_missed"] = "당신의 품질 기준을 만족하는 전리품 없음",
}

locales.esMX["Frame"] = {
}

locales.ruRU["Frame"] = {
	["bind_on_equip_short"] = "БоЕ",
	["bind_on_pickup_short"] = "БоП",
	["bind_on_use_short"] = "Становится персональным при использовании",
	["button_close"] = "Закрыть",
	["button_link"] = "Ссылка",
	["linkall_threshold_missed"] = "Нет добычи, удовлетворяющей установленному порогу качества",
}

locales.zhCN["Frame"] = {
	["bind_on_equip_short"] = "装备后绑定",
	["bind_on_pickup_short"] = "拾取后绑定",
	["bind_on_use_short"] = "使用后绑定",
	["button_close"] = "关闭",
	["button_link"] = "链接",
	["linkall_threshold_missed"] = "没有达到拾取品质门槛的物品",
}

locales.esES["Frame"] = {
}

locales.zhTW["Frame"] = {
	["bind_on_equip_short"] = "裝綁",
	["bind_on_pickup_short"] = "拾榜",
	["bind_on_use_short"] = "使綁",
	["button_close"] = "關閉",
	["button_link"] = "連結",
	["linkall_threshold_missed"] = "沒有達到品質門檻的戰利品",
}


XLoot:Localize("Frame", locales)
