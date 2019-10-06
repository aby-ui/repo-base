--[[

	This file is part of 'Masque: Apathy', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque_Apathy.

	* File....: Locales.lua
	* Authors.: StormFX

]]

-- GLOBALS: GetLocale, setmetatable

local _, Core = ...

----------------------------------------
-- Locales
---

local L = {}

Core.Locale = setmetatable(L, {
	__index = function(self, k)
		self[k] = k
		return k
	end
})

local Locale = GetLocale()

if Locale == "enGB" or Locale == "enUS" then
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
