--[[

	This file is part of 'Masque: Cirque', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque_Cirque.

	* File...: Locales.lua
	* Author.: StormFX

]]

local _, Core = ...

----------------------------------------
-- WoW API
---

local Locale = GetLocale()

----------------------------------------
-- Local
---

local L = {}

----------------------------------------
-- Core
---

Core.Locale = setmetatable(L, {
	__index = function(self, k)
		self[k] = k
		return k
	end
})

----------------------------------------
-- Localization
---

if Locale == "enGB" or Locale == "enUS" then
	-- enUS/enGB for Reference
	--L["A circular skin with an outer ring as an accent."] = "A circular skin with an outer ring as an accent."
	--L["An alternate version of Cirque without an outer ring."] = "An alternate version of Cirque without an outer ring."
	return
--elseif Locale == "deDE" then
--elseif Locale == "esES" or Locale == "esMX" then
--elseif Locale == "frFR" then
--elseif Locale == "itIT" then
--elseif Locale == "koKR" then
--elseif Locale == "ptBR" then
--elseif Locale == "ruRU" then
elseif Locale == "zhCN" then
    L["A circular skin with an outer ring as an accent."] = "一个圆形皮肤，外圈为特色所在。"
   	L["An alternate version of Cirque without an outer ring."] = "没有外圈的Cirque的替代版本。"
elseif Locale == "zhTW" then
	L["A circular skin with an outer ring as an accent."] = "一個圓形皮膚，外圈為特色所在。"
	L["An alternate version of Cirque without an outer ring."] = "沒有外圈的Cirque的替代版本。"
end
