local _, L = ...

setmetatable(L, {__index = function(L, key)
	local value = tostring(key)
	L[key] = value
	return value
end})

--[==========[
local locale = GetLocale()
if(locale == 'deDE') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'esES') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'esMX') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'frFR') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'itIT') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'koKR') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'ptBR') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'ruRU') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

elseif(locale == 'zhCN') then
--Translation missing 
	L['Enable tooltips in display'] = "启用LDB鼠标提示"
--Translation missing 
	L['Enable tooltips in menu'] = "启用菜单鼠标提示"
--Translation missing 
	L['Equipment sets!'] = "套装!"

elseif(locale == 'zhTW') then
--Translation missing 
-- L["Enable tooltips in display"] = ""
--Translation missing 
-- L["Enable tooltips in menu"] = ""
--Translation missing 
-- L["Equipment sets!"] = ""

end
--]==========]
