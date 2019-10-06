--[[

	This file is part of 'Masque: Caith', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque_Caith.

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
	--L["A larger version of Apathy inspired by Caith UI."] = "A larger version of Apathy inspired by Caith UI."
	return
--elseif Locale == "deDE" then
--elseif Locale == "esES" or Locale == "esMX" then
--elseif Locale == "frFR" then
--elseif Locale == "itIT" then
--elseif Locale == "koKR" then
--elseif Locale == "ptBR" then
--elseif Locale == "ruRU" then
elseif Locale == "zhCN" then
	L["A larger version of Apathy inspired by Caith UI."] = "一个更大版本的Apathy，启发自Caith UI。"
elseif Locale == "zhTW" then
	L["A larger version of Apathy inspired by Caith UI."] = "一個更大版本的Apathy，啟發自Caith UI。"
end
