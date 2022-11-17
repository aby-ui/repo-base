--[[

	This file is part of 'Masque: Apathy', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque_Apathy.

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
	--L["A square, minimalistic skin with thin borders."] = "A square, minimalistic skin with thin borders."
	return
--elseif Locale == "deDE" then
--elseif Locale == "esES" or Locale == "esMX" then
--elseif Locale == "frFR" then
--elseif Locale == "itIT" then
--elseif Locale == "koKR" then
--elseif Locale == "ptBR" then
--elseif Locale == "ruRU" then
elseif Locale == "zhCN" then
	L["A square, minimalistic skin with thin borders."] = "一个方形，简约带薄外框的主题皮肤。"
elseif Locale == "zhTW" then
	L["A square, minimalistic skin with thin borders."] = "一個方形，簡約帶薄外框的主題皮膚。"
end
