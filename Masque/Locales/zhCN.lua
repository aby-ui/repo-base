--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Locales\zhCN.lua

	zhCN Locale

	[ Notes ]

	To help with translations, use the localization system on WoWAce (https://www.wowace.com/projects/masque/localization)
	or contribute directly on GitHub (https://github.com/StormFX/Masque).

]]

-- GLOBALS: GetLocale

if GetLocale() ~= "zhCN" then return end

local _, Core = ...
local L = Core.Locale

----------------------------------------
-- About Masque
---

L["About Masque"] = "关于 Masque"
L["API"] = "API"
L["For more information, please visit one of the sites listed below."] = "查阅更多信息，请访问下边列表中的网页站点。"
L["Masque is a skinning engine for button-based add-ons."] = "Masque 一款基于按钮的外观美化插件。"
L["Select to view."] = "选择来查看。"
L["You must have an add-on that supports Masque installed to use it."] = "必须安装一个支持 Masque 的插件才能使用。"

----------------------------------------
-- Classic Skin
---

L["An improved version of the game's default button style."] = "一款游戏默认按钮样式的改进版本。"

----------------------------------------
-- Core Settings
---

L["About"] = "关于"
L["Click to load Masque's options."] = "点击载入 Masque 选项。"
L["Load Options"] = "载入选项"
L["Masque's options are load on demand. Click the button below to load them."] = "Masque 选项是按需载入。点击下面按钮加载它们。"
L["This section will allow you to view information about Masque and any skins you have installed."] = "此部分将允许查看关于 Masque 的信息或任意一款已安装的皮肤。"

----------------------------------------
-- Developer Settings
---

L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."] = "无论何时 Masque 遇到了一个插件问题或者皮肤问题，都让其屏蔽 Lua 错误。"
L["Clean Database"] = "清除数据库"
L["Click to purge the settings of all unused add-ons and groups."] = "点击清除全部无用插件和组设置。"
L["Debug Mode"] = "调试模式"
L["Developer"] = "开发者"
L["Developer Settings"] = "开发者设置"
L["Masque debug mode disabled."] = "Masque 调试模式已禁用。"
L["Masque debug mode enabled."] = "Masque 调试模式已启用。"
L["This action cannot be undone. Continue?"] = "此操作不可撤销。继续？"
L["This section will allow you to adjust settings that affect working with Masque's API."] = "此部分将允许调整影响 Masque 使用的 API。"

----------------------------------------
-- Dream Skin
---

L["A square skin with trimmed icons and a semi-transparent background."] = "一款方形皮肤带有修剪过的图标和半透明背景。"

----------------------------------------
-- General Settings
---

L["General Settings"] = "一般设置"
L["This section will allow you to adjust Masque's interface and performance settings."] = "此部分将允许调整 Masque 界面和性能设置。"

----------------------------------------
-- Installed Skins
---

L["Author"] = "作者"
L["Authors"] = "作者"
L["Click for details."] = "点击查看更多信息。"
L["Compatible"] = "兼容"
L["Description"] = "描述"
L["Incompatible"] = "不兼容"
L["Installed Skins"] = "已安装皮肤"
L["No description available."] = "没有可用的描述。"
L["Status"] = "状态"
L["The status of this skin is unknown."] = "此皮肤的状态未知。"
L["This section provides information on any skins you have installed."] = "此部分提供所有已安装皮肤的信息。"
L["This skin is compatible with Masque."] = "此皮肤与 Masque 兼容。"
L["This skin is outdated and is incompatible with Masque."] = "此皮肤已过期并且与 Masque 不兼容。"
L["This skin is outdated but is still compatible with Masque."] = "此皮肤已过期但仍与 Masque 兼容。"
L["Unknown"] = "未知"
L["Version"] = "版本"
L["Website"] = "网站"
L["Websites"] = "网站"

----------------------------------------
-- Interface Settings
---

L["Enable the Minimap icon."] = "启用小地图图标。"
L["Interface"] = "界面"
L["Interface Settings"] = "界面设置"
L["Minimap Icon"] = "小地图图标"
L["Stand-Alone GUI"] = "独立用户界面"
L["This section will allow you to adjust settings that affect Masque's interface."] = "此部分将允许调整影响 Masque 界面的设置。"
L["Use a resizable, stand-alone options window."] = "使用可调整大小的独立选项窗口。"

----------------------------------------
-- LDB Launcher
---

L["Click to open Masque's settings."] = "点击打开 Masque 设置。"

----------------------------------------
-- Performance Settings
---

L["Click to load reload the interface."] = "点击重载界面。"
L["Load the skin information panel."] = "载入这个皮肤信息面板。"
L["Performance"] = "性能"
L["Performance Settings"] = "性能设置"
L["Reload Interface"] = "重载界面"
L["Requires an interface reload."] = "需要重载当前界面。"
L["Skin Information"] = "皮肤信息"
L["This section will allow you to adjust settings that affect Masque's performance."] = "此部分将允许调整影响 Masque 性能的设置。"

----------------------------------------
-- Profile Settings
---

L["Profile Settings"] = "配置文件设置"

----------------------------------------
-- Skin Settings
---

L["Backdrop"] = "背景设置"
L["Checked"] = "已选中"
L["Color"] = "颜色"
L["Colors"] = "颜色"
L["Cooldown"] = "冷却"
L["Disable"] = "禁用"
L["Disable the skinning of this group."] = "禁用此群组换肤。"
L["Disabled"] = "已禁用"
L["Enable"] = "启用"
L["Enable the Backdrop texture."] = "启用背景材质。"
L["Enable the Gloss texture."] = "启用光泽材质。"
L["Enable the Shadow texture."] = "启用阴影材质。"
L["Flash"] = "闪光"
L["Global"] = "全局"
L["Global Settings"] = "全局设置"
L["Gloss"] = "光泽设置"
L["Highlight"] = "高亮"
L["Normal"] = "正常"
L["Pushed"] = "按下"
L["Reset all skin options to the defaults."] = "重置所有皮肤选项为默认。"
L["Reset Skin"] = "重置皮肤"
L["Set the color of the Backdrop texture."] = "设置背景材质颜色。"
L["Set the color of the Checked texture."] = "设置已选中材质颜色。"
L["Set the color of the Cooldown animation."] = "设置冷却动画颜色。"
L["Set the color of the Disabled texture."] = "设置已禁用材质颜色。"
L["Set the color of the Flash texture."] = "设置闪光材质颜色。"
L["Set the color of the Gloss texture."] = "设置光泽材质颜色。"
L["Set the color of the Highlight texture."] = "设置高亮材质颜色。"
L["Set the color of the Normal texture."] = "设置一般材质颜色。"
L["Set the color of the Pushed texture."] = "设置加粗材质颜色。"
L["Set the color of the Shadow texture."] = "设置阴影材质颜色。"
L["Set the skin for this group."] = "为此群组设置皮肤。"
L["Shadow"] = "阴影"
L["Skin"] = "皮肤"
L["Skin Settings"] = "皮肤设置"
L["This section will allow you to adjust the skin settings of all buttons registered to %s."] = "此部分将允许调整注册到 %s 皮肤设置到全部按钮。"
L["This section will allow you to adjust the skin settings of all buttons registered to %s. This will overwrite any per-group settings."] = "此部分将允许调整注册到 %s 皮肤设置到全部按钮。这将覆盖任意群组设置。"
L["This section will allow you to adjust the skin settings of all registered buttons. This will overwrite any per-add-on settings."] = "此部分将允许调整注册皮肤设置到全部按钮。这将覆盖任意群组设置。"
L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."] = "此部分将允许将使用 Masque 注册的插件与插件群组的按钮。"

----------------------------------------
-- Zoomed Skin
---

L["A square skin with zoomed icons and a semi-transparent background."] = "一款方形皮肤带有缩放图标和半透明背景。"
