--[[

	This file is part of 'Masque: Entropy', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque_Entropy.

	* File...: Locales.lua
	* Author.: StormFX

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
	-- enUS/enGB for Reference
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
elseif Locale == "zhTW" then
	L["A metallic version of Apathy in the color of %s ore."] = "Apathy的一種金屬版本，以%s礦石的顏色顯示。"
end
