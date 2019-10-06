--[[

	This file is part of 'Masque: Entropy', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque_Entropy.

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
	--L["A metallic version of Apathy in the color of %s ore."]
	return
--elseif Locale == "deDE" then
--elseif Locale == "esES" or Locale == "esMX" then
--elseif Locale == "frFR" then
--elseif Locale == "itIT" then
--elseif Locale == "koKR" then
--elseif Locale == "ptBR" then
--elseif Locale == "ruRU" then
--elseif Locale == "zhCN" then
--elseif Locale == "zhTW" then
end
