-- See: http://wow.curseforge.com/addons/xloot/localization/ to create or fix translations
local locales = {
	enUS = {
		ML_RANDOM = "Raid Roll",
		ML_SELF = "Self Loot",
		ML_BANKER = "Banker",
		ML_DISENCHANTER = "Disenchanter",
		RECIPIENTS = "Special Recipients",
		SPECIALROLLS = "Special Rolls",
		BINDING_BANKER = "Set Banker",
		BINDING_DISENCHANTER = "Set Disenchanter",
		ITEM_AWARDED = "%s awarded: %s",
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
locales.ptBR["Master"] = {
}

locales.frFR["Master"] = {
}

locales.deDE["Master"] = {
	["BINDING_BANKER"] = "Setze Bankier",
	["BINDING_DISENCHANTER"] = "Setze Entzauberer",
	["ITEM_AWARDED"] = "%s erhielt: %s",
	["ML_BANKER"] = "Bankier",
	["ML_DISENCHANTER"] = "Entzauberer",
	["ML_RANDOM"] = "Schlachtzugswurf",
	["ML_SELF"] = "Eigenständiges Plündern",
	["RECIPIENTS"] = "Spezieller Empfänger",
	["SPECIALROLLS"] = "Spezielle Würfe",
}

locales.koKR["Master"] = {
	["BINDING_BANKER"] = "은행원 설정",
	["BINDING_DISENCHANTER"] = "마법부여사 설정",
	["ITEM_AWARDED"] = "%s |1을;를; 획득했습니다: %s",
	["ML_BANKER"] = "은행인",
	["ML_DISENCHANTER"] = "마법부여사",
	["ML_RANDOM"] = "공격대 주사위",
	["RECIPIENTS"] = "특별 수령인",
	["SPECIALROLLS"] = "특별 주사위",
}

locales.esMX["Master"] = {
}

locales.ruRU["Master"] = {
	["BINDING_BANKER"] = "Назначить банкира",
	["BINDING_DISENCHANTER"] = "Назначить дизенчантера",
	["ITEM_AWARDED"] = "%s получает: %s",
	["ML_BANKER"] = "Банкир",
	["ML_DISENCHANTER"] = "Дизенчантер",
	["ML_RANDOM"] = "Raid Roll",
	["ML_SELF"] = "Своя добыча",
	["RECIPIENTS"] = "Особые получатели",
	["SPECIALROLLS"] = "Особые броски",
}

locales.zhCN["Master"] = {
	["BINDING_BANKER"] = "设置银行存放者",
	["BINDING_DISENCHANTER"] = "设置附魔分解者",
	["ITEM_AWARDED"] = "%s 获得了： %s",
	["ML_BANKER"] = "银行存放者",
	["ML_DISENCHANTER"] = "附魔分解者",
	["ML_RANDOM"] = "团队掷骰",
	["ML_SELF"] = "自己掷骰",
	["RECIPIENTS"] = "特殊接收者",
	["SPECIALROLLS"] = "特殊掷骰",
}

locales.esES["Master"] = {
}

locales.zhTW["Master"] = {
	["BINDING_BANKER"] = "設定存放銀行者",
	["BINDING_DISENCHANTER"] = "設定附魔分解者",
	["ITEM_AWARDED"] = "%s 給與: %s",
	["ML_BANKER"] = "銀行存放者",
	["ML_DISENCHANTER"] = "附魔分解者",
	["ML_RANDOM"] = "團隊擲骰",
	["ML_SELF"] = "自己拾取",
	["RECIPIENTS"] = "特殊接受者",
	["SPECIALROLLS"] = "特殊擲骰",
}


XLoot:Localize("Master", locales)
