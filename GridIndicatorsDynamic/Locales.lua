local name, addon = ...
local L = setmetatable({},{
    __index = function(self, key) return key end,
    __call = function(self, key) return rawget(self, key) or key  end
})
addon.L = L

if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then return end

--[[------------------------------------------------------------
163ui added
---------------------------------------------------------------]]
L["icontop"]    = "□顶部图标"
L["iconbottom"] = "□底部图标"
L["iconleft"]   = "□左侧图标"
L["iconright"]  = "□右侧图标"
L["iconrole"]   = "职责专用图标"

L["cornertexttopleft"]      = "◇左上角文字"
L["cornertexttopright"]     = "◇右上角文字"
L["cornertextbottomleft"]   = "◇左下角文字"
L["cornertextbottomright"]  = "◇右下角文字"

L["Show Remain Time"] = "强制显示剩余时间"
L["Show status's remain time (only if supported) instead of status text. The numbers will be updated by GridIndicatorsDynamic. It's more efficient than other ways."] = "强制显示状态的剩余时间而不是文本。这种方式下，数字会被统一刷新，比Grid光环设置成'显示剩余时间'效率更高。如果需要显示堆叠层数，应关闭此选项。"
L["5 Seconds Warning"] = "最后5秒变色"

--[[------------------------------------------------------------
Options.lua
---------------------------------------------------------------]]
L["Layout Anchor"] = "锚点位置"

L["Center"] = "中心"
L["Top"] = "顶部"
L["Bottom"] = "底部"
L["Left"] = "左侧"
L["Right"] = "右侧"
L["Top Left"] = "左上角"
L["Top Right"] = "右上角"
L["Bottom Left"] = "左下角"
L["Bottom Right"] = "右下角"

L["New Dynamic Text"] = "新的文本指示器"
L["Configure this text"] = "设置这个|cff00ff00文本指示器|r的选项"
L["Name"] = "指示器名称"
L["Delete"] = "删除"
L["Offset X"] = "X轴偏移量"
L["Offset Y"] = "Y轴偏移量"
L["Font"] = "文本字体"
L["Font Size"] = "文本尺寸"
L["Font Outline"] = "文本描边"
L["None"] = "无"
L["Thin"] = "细"
L["Thick"] = "粗"
L["Font Shadow"] = "文本阴影"
L["Text Length"] = "文本长度(字数)"
L["Frame level"] = "框架层级"

L["New Dynamic Icon"] = "新的图标指示器"
L["Configure this icon."] = "设置这个|cff00ff00图标指示器|r的选项"
L["Icon Size"] = "图标尺寸"
L["Icon Border Size"] = "图标边框尺寸"
L["Enable Icon Cooldown Frame"] = "启用冷却效果"
L["Enable Icon Stack Text"] = "启用层数文字"
L["Icon Stack Text Font Size"] = "层数文字大小"
L["Icon Stack Text Offset X"] = "层数文字横向位置"
L["Icon Stack Text Offset Y"] = "层数文字纵向位置"

L["New Dynamic Box"] = "新的色块指示器"
L["Configure this box"] = "设置这个|cff00ff00色块指示器|r的选项"
L["Size"] = "尺寸"

L["Dynamic Indicators"] = "自定义指示器"
L["New Text Indicator"] = "新建文本指示器"
L["New Icon Indicator"] = "新建图标指示器"
L["New Box Indicator"] = "新建色块指示器"
