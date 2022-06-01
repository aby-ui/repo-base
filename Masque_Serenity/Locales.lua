--[[

	This file is part of 'Masque: Serenity', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque_Serenity.

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
	--L["A port of the original Serenity skin by Sairen."] = "A port of the original Serenity skin by Sairen."
	--L["A port of the original Serenity Square skin by Sairen."] = "A port of the original Serenity Square skin by Sairen."
	--L["An alternate version of Serenity with modified Checked and Equipped textures."] = "An alternate version of Serenity with modified Checked and Equipped textures."
	--L["An alternate version of Serenity Square with modified Checked and Equipped textures."] = "An alternate version of Serenity Square with modified Checked and Equipped textures."
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
