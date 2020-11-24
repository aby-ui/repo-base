local _, L = ...

setmetatable(L, {__index = function(L, key)
	local value = tostring(key)
	L[key] = value
	return value
end})

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
    L['|cff33ff33Left-Click|r to open equipment menu.'] = '|cff33ff33左键点击|r 打开套装菜单.'
    L['|cff33ff33Right-Click|r to open character window.'] = '|cff33ff33右键点击|r 打开角色窗口.'
    L['|cff33ff33Click|r to equip set.'] = '|cff33ff33直接点击|r 装备套装.'
    L['|cff33ff33Shift-Click|r to update set with current equipment.'] = '|cff33ff33SHIFT点击|r 更新套装为身上装备.'
    L['|cff33ff33Ctrl-Click|r to |cffff3333delete|r set.'] = '|cff33ff33CTRL点击|r |cffff3333删除|r套装.'

elseif(locale == 'zhTW') then
    L['|cff33ff33Left-Click|r to open equipment menu.'] = '|cff33ff33左鍵點擊|r 打開套裝菜單.'
    L['|cff33ff33Right-Click|r to open character window.'] = '|cff33ff33右鍵點擊|r 打開角色視窗.'
    L['|cff33ff33Click|r to equip set.'] = '|cff33ff33直接點擊|r 裝備套裝.'
    L['|cff33ff33Shift-Click|r to update set with current equipment.'] = '|cff33ff33Shift點擊|r 更新套裝為身上裝備.'
    L['|cff33ff33Ctrl-Click|r to |cffff3333delete|r set.'] = '|cff33ff33Ctrl點擊|r |cffff3333刪除|r套裝.'
end