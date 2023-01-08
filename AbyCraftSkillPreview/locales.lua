local _, private = ...
local L = setmetatable({}, { __index = function(self, key) return key end })
private.L = L

L.TitleFontSize = 16 -- adjust preview checkbox text font size for different locales.

if LOCALE_zhCN then
    L.TitleFontSize = 24
    L["Quantities Mismatch"] = "数量不符"
    L["Estimate Skill"] = "预估技能"
    L["Try Reagents"] = "模拟材料品质"
end