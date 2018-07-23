local XLoot = select(2, ...)

local function CompileLocales(locales)
	local L = locales[GetLocale()] and locales[GetLocale()] or locales.enUS
	if L ~= locales.enUS then
		setmetatable(L, { __index = locales.enUS })
		for k, v in pairs(L) do	
			if type(v) == 'table' then
				setmetatable(v, { __index = locales.enUS[k] })
			end
		end
	end
	return L
end

-- locales expects table: { enUS = {...}, ... }
function XLoot:Localize(name, locales)
	-- We need to extract the root namespace due to how Curse is currently doing localizations.
	for _,t in pairs(locales) do
		if t[name] then
			for k, v in pairs(t[name]) do
				t[k] = v
			end
			t[name] = nil
		end
	end
	self["L_"..name] = CompileLocales(locales)
end

local locales = {
	enUS = {
		skin_svelte = "XLoot: Svelte",
		skin_legacy = "XLoot: Legacy",
		skin_smooth = "XLoot: Smooth",
		anchor_hide = "hide",
		anchor_hide_desc = "Lock this module in position\nThis will hide the anchor,\nbut it can be shown again from the options",
	},
	-- Possibly localized
	ptBR = {},
	frFR = {},
	deDE = {},
	koKR = {},
	esMX = {},
	ruRU = {},
	zhCN = {},
	esES = {},
	zhTW = {},
}

-- Automatically inserted translations
locales.ptBR["Core"] = {
}

locales.frFR["Core"] = {
}

locales.deDE["Core"] = {
	["anchor_hide"] = "verstecken",
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.koKR["Core"] = {
	["anchor_hide"] = "감춤",
	["anchor_hide_desc"] = [=[이 모듈을 제 위치에 잠급니다.
이는 표시기를 숨기지만,
옵션에서 다시 표시할 수 있습니다.]=],
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.esMX["Core"] = {
}

locales.ruRU["Core"] = {
	["anchor_hide"] = "скрыть ",
	["anchor_hide_desc"] = [=[Заблокируйте положение этого модуля
Это позволит скрыть якорь,
но он может быть показан еще раз в настройках]=],
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.zhCN["Core"] = {
	["anchor_hide"] = "隐藏",
	["anchor_hide_desc"] = [=[在此位置锁定此模块
这将隐藏锚点
但可通过选项重新显示]=],
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.esES["Core"] = {
}

locales.zhTW["Core"] = {
	["anchor_hide"] = "隱藏",
	["anchor_hide_desc"] = [=[鎖定此模組在此位置上
這會隱藏此錨點,
但它可以藉由選項再次顯示]=],
	["skin_legacy"] = "XLoot: 傳統",
	["skin_smooth"] = "XLoot: 滑順",
	["skin_svelte"] = "XLoot: 苗條",
}



XLoot.L = CompileLocales(locales)
