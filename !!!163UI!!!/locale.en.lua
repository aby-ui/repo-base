local L = select(2, ...).L







local CLSTLTS = {

    DEATHKNIGHT = {
        250, -- Blood
        251, -- Frost
        252, -- Unholy
    },

    DRUID = {
        102, -- Balance
        103, -- Feral
        104, -- Guardian
        105, -- Restoration
    },

    HUNTER = {
        253, -- Beast Mastery
        254, -- Marksmanship
        255, -- Survival
    },

    MAGE = {
        62, -- Arcane
        63, -- Fire
        64, -- Frost
    },

    MONK = {
        268, -- Brewmaster
        269, -- Mistweaver
        270, -- Windwalker
    },

    PALADIN = {
        65, -- Holy
        66, -- Protection
        67, -- Retribution
    },

    PRIEST = {
        256, -- Discipline
        257, -- Holy
        258, -- Shadow
    },

    ROGUE = {
        259, -- Assassination
        260, -- Combat
        261, -- Subtlety
    },

    SHAMAN = {
        262, -- Elemental
        263, -- Enhancement
        264, -- Restoration
    },

    WARLOCK = {
        265, -- Affliction
        266, -- Demonology
        267, -- Destruction
    },

    WARRIOR = {
        71, -- Arms
        72, -- Fury
        73, -- Protection
    },
}

for cls, cv in next, CLSTLTS do
    for i, id in next, cv do
        _G['U1TALENT_'..cls..i] = select(2, GetSpecializationInfoByID(id))
    end
end

-- U1TALENT_HUNTER1="Beast Mastery";
-- U1TALENT_HUNTER2="Marksmanship";
-- U1TALENT_HUNTER3="Survival";
-- U1TALENT_WARLOCK1="Affliction";
-- U1TALENT_WARLOCK2="Demonology";
-- U1TALENT_WARLOCK3="Destruction";
-- U1TALENT_PRIEST1="Discipline";
-- U1TALENT_PRIEST2="Holy";
-- U1TALENT_PRIEST3="Shadow";
-- U1TALENT_PALADIN1="Holy";
-- U1TALENT_PALADIN2="Protection";
-- U1TALENT_PALADIN3="Retribution";
-- U1TALENT_MAGE1="Arcane";
-- U1TALENT_MAGE2="Fire";
-- U1TALENT_MAGE3="Frost";
-- U1TALENT_ROGUE1="Assassination";
-- U1TALENT_ROGUE2="Combat";
-- U1TALENT_ROGUE3="Subtlety";
-- U1TALENT_DRUID1="Balance";
-- U1TALENT_DRUID2="Feral Combat";
-- U1TALENT_DRUID3="Restoration";
-- U1TALENT_SHAMAN1="Elemental";
-- U1TALENT_SHAMAN2="Enhancement";
-- U1TALENT_SHAMAN3="Restoration";
-- U1TALENT_WARRIOR1="Arms";
-- U1TALENT_WARRIOR2="Fury";
-- U1TALENT_WARRIOR3="Protection";
-- U1TALENT_DEATHKNIGHT1="Blood";
-- U1TALENT_DEATHKNIGHT2="Frost";
-- U1TALENT_DEATHKNIGHT3="Unholy";
-- U1TALENT_MONK1="Brewmaster";
-- U1TALENT_MONK2="Mistweaver";
-- U1TALENT_MONK3="Windwalker";



if L.zhCN or L.zhTW then return end

L["TAG_RAID"] = "Raid"
L["TAG_DESC_RAID"] = ""
L["TAG_BIG"] = "Big"
L["TAG_DESC_BIG"] = ""
L["TAG_TRADING"] = "Trading"
L["TAG_DESC_TRADING"] = ""
L["TAG_INTERFACE"] = "Interface"
L["TAG_DESC_INTERFACE"] = ""
L["TAG_CHAT"] = "Chat"
L["TAG_DESC_CHAT"] = ""
L["TAG_PVP"] = "PVP"
L["TAG_DESC_PVP"] = ""
L["TAG_COMBATINFO"] = "Combat"
L["TAG_DESC_COMBATINFO"] = ""
L["TAG_MAPQUEST"] = "Map & Quest"
L["TAG_DESC_MAPQUEST"] = ""
L["TAG_GARRISON"] = "Garrison"
L["TAG_DESC_GARRISON"] = ""
L["TAG_MANAGEMENT"] = "Management"
L["TAG_DESC_MANAGEMENT"] = ""
L["TAG_ITEM"] = "Item"
L["TAG_DESC_ITEM"] = ""
L["TAG_GOOD"] = "Recommendation"
L["TAG_DESC_GOOD"] = ""
L["TAG_CLASS"] = "Class"
L["TAG_DESC_CLASS"] = ""
L["TAG_DESC_SINGLE"] = ""
L["TAG_UNIQUE"] = "Unique"
L["TAG_NEW"] = "New"
L["TAG_DATA"] = "Data"
L["TAG_DEV"] = "DevTools"
L["TAG_BETA"] = "Beta"

L["TAG_MANAGEMENT"] = "Management"

U1HUNTER="Hunter";
U1WARLOCK="Warlock";
U1PRIEST="Priest";
U1PALADIN="Paladin";
U1MAGE="Mage";
U1ROGUE="Rogue";
U1DRUID="Druid";
U1SHAMAN="Shaman";
U1WARRIOR="Warrior";
U1DEATHKNIGHT="DeathKnight";
U1MONK="Monk";
U1DEMONHUNTER="DemonHunter";

U1REASON_INCOMPATIBLE = "Incompatible"
U1REASON_DISABLED = "Disabled"
U1REASON_INTERFACE_VERSION = "Outdated"
U1REASON_DEP_DISABLED = "Deps Disabled"
U1REASON_DEP_CORRUPT = "Deps Corrupted"
U1REASON_SHORT_DEP_CORRUPT = "Deps Err"
U1REASON_SHORT_DEP_DISABLED = "Deps Err"
U1REASON_DEP_INTERFACE_VERSION = "Deps Outdated"
U1REASON_SHORT_DEP_INTERFACE_VERSION = "Deps Err"
U1REASON_DEP_MISSING = "Deps Missing"
U1REASON_SHORT_DEP_MISSING = "Deps Err"
U1REASON_DEP_NOT_DEMAND_LOADED = "Deps Not LoD"
U1REASON_SHORT_DEP_NOT_DEMAND_LOADED = "Deps Err"


--[[    ]] -- File: 163UI.lua

--[[ 142]] L["强制加载"] = "Load now"
--[[ 142]] L["说明`本插件会在满足条件时自动加载，如果现在就要加载请点击此按钮` `|cffff0000注意：有可能会出错|r"] = "Hint`This addon is designed for loading on demand. But if you can load it anytime by pressing this button.` `|cffff0000Warning: Errors may occur.|r"
--[[ 164]] L["爱不易插件集"] = "AbyUI Bundle"
--[[ 165]] L["此项功能为一系列功能相关的小插件组合，可以分别开启或关闭，为您提供最清晰的分类和最强大的灵活性。"] = "The bundle is a series of functional related small addons, which are shown together in the Control Panel."
--[[ 737]] L["插件-|cffffd100%s|r-"] = "addon |cffffd100%s|r"
--[[ 744]] L["%s加载成功"] = "%s loaded"
--[[ 746]] L["%s加载失败, 原因："] = "%s load failed, reason: "
--[[ 746]] L["未知"] = "Unknown"
--[[1042]] L["%s加载失败，依赖插件["] = "%s load failed, dependencies ["
--[[1042]] L["]无法加载。"] = "] can't be loaded"
--[[1056]] --L["%s加载失败，依赖插件["] = true
--[[1056]] --L["]无法加载。"] = true
--[[1152]] L["停用%s需要重载界面"] = "Reloading UI is required to disable %s."
--[[1155]] L["%s已暂停，彻底关闭需要重载界面。"] = "%s is current paused, the memory will not release until reload ui."
--[[1160]] L["%s不再停用"] = "%s is no longer disabled."
--[[1172]] L["%s已启用, 需要时会自动加载"] = "%s is enabled, and will load on demand."
--[[1271]] L["玩家登陆中"] = "Player logining in"
--[[1289]] L["玩家登陆完毕"] = "Player logged in"
--[[1345]] L["因上次载入过程未完成，已恢复之前的插件状态。"] = "Recovering former settings..."
--[[1526]] L["延迟加载 - 还有 |cff00ff00%d|r 个插件将在战斗结束后加载。"] = "Delay Loading - |cff00ff00%d|r addons will be loaded after combat."
--[[1536]] L["还有至少["] = true --NOUSE
--[[1536]] L["]个插件尚未更新完，请等待更新器全部完成后运行/reload重载界面。"] = true --NOUSE
--[[1538]] L["全部插件加载完毕。"] = "Done loading all addons."
--[[1567]] L["战斗结束，继续加载插件，请安心等待……"] = "Combat finished, continue loading addons, please wait..."
--[[1596]] L["进入世界"] = "Entering world"

--[[    ]] -- File: 163UIUI_V3.lua

--[[  79]] L["插件："] = "Addon: "
--[[  82]] L["快速启用/停用插件"] = "Quick Enable/Disable Addon"
--[[ 240]] L["已加载,重启后停用"] = "Loaded, reload to disable"
--[[ 242]] L["|cff00D100已加载|r"] = "|cff00D100Loaded|r"
--[[ 245]] L["|cffff0000未安装|r"] = "|cff00D100Missing|r"
--[[ 247]] L["|cffA0A0A0未启用|r"] = "|cff00D100Disabled|r"
--[[ 249]] L["已启用"] = "Enabled"
--[[ 249]] L["已启用,需重新加载"] = "Enabled, reloadui to load"
--[[ 252]] L["|cffA0A0A0依赖插件未启用|r"] = "|cffA0A0A0Deps Disabled|r"
--[[ 254]] L["|cffff7f7f启用失败|r"] = "|cffff7f7Load Failed|r"
--[[ 268]] L["子插件"] = "Sub-addon"
--[[ 283]] L["战斗中启用/停用插件可能会导致错误，重载界面后会正常。\n"] = "It's not recommended to Enable or Disable addons while in combat, If there are any errors, just reload ui to fix them.\n"
--[[ 286]] --L["子插件"] = true
--[[ 292]] L["作者"] = "Author"
--[[ 292]] L["修改"] = "Credits"
--[[ 294]] --L["作者"] = true
--[[ 315]] L["目录"] = "Folder"
--[[ 315]] L["版本"] = "Version"
--[[ 318]] --L["爱不易插件集"] = true
--[[ 329]] L["全部"] = "Total"
--[[ 331]] L["内存"] = "Mem"
--[[ 334]] L["状态"] = "Status"
--[[ 334]] L["|cff00D100按需载入|r"] = "|cff00D100LoD|r"
--[[ 338]] L["原因"] = "Reason"
--[[ 345]] L["依赖"] = "Depends"
--[[ 354]] L["单体插件"] = "Individual Addon" --"Independent"
--[[ 356]] L["爱不易整合版"] = "AbyUI Packed"
--[[ 409]] L['|cffFFA3A3没有启用插件|r'] = '|cffFFA3A3No Loaded Addons|r'
--[[ 429]] L[" 爱不易整合 "] = "   AbyUI   "
--[[ 430]] L["　其他插件　"] = "   Uncategoried   "
--[[ 430]] L["　单体插件　"] = "   Individual   "
--[[ 494]] L["地图任务"] = "Map & Quest"
--[[ 577]] L["正常模式"] = "UNUSED"
--[[ 577]] L["将界面还原成普通模式，而不是半透明的精简模式"] = "UNUSED"
--[[ 581]] L["爱不易设置"] = "Settings"
--[[ 597]] --L["爱不易设置"] = true
--[[ 597]] L["直接显示爱不易的介绍和配置项，再次点击则恢复当前的选择插件"] = "Jump to AbyUI's option page. Click the button again to go back to the former selected addon."
--[[ 598]] L["快捷设置"] = "Quick Menu"
--[[ 598]] L["一些常用的选项，以下拉菜单方式列出，可迅速进行设置。"] = "Some frequently used toggle options, shown in a dropdown menu."
--[[ 599]] --L["爱不易设置"] = true
--[[ 599]] L["设置"] = "Opt"
--[[ 621]] L["重载界面"] = "ReloadUI"
--[[ 627]] --L["重载界面"] = true
--[[ 627]] L["重载"] = "Reload"
--[[ 637]] L["请双击按钮（防止误操作）"] = "Please DOUBLE click to confirm"
--[[ 640]] L["回收内存"] = "MemoryGC"
--[[ 643]] L["释放内存"] = "Memory garbage collect"
--[[ 643]] L["强制回收空闲的内存, 除了确定插件内存的稳定值外, 并没有太大用处."] = ""
--[[ 644]] --L["回收内存"] = true
--[[ 644]] --L["内存"] = true
--[[ 647]] L["方案管理"] = "Profiles"
--[[ 649]] --L["方案管理"] = true
--[[ 649]] L["将已启用的插件列表等保存为方案，例如任务模式、副本模式等，亦可以在多个角色之间共用。"] = "Save addons status and control panel settings, and share the profile among characters."
--[[ 650]] --L["方案管理"] = true
--[[ 650]] L["方案"] = "Prf"
--[[ 666]] L["爱不易快捷设置"] = "AbyUI Quick Menu"
--[[ 682]] L["以下操作需要重载界面："] = "Operations require reloading: "
--[[ 691]] L["|cffff0000停用|r - "] = "|cffff0000Disable|r - "
--[[ 691]] L["配置 - "] = "Config - "
--[[ 742]] L["全部加载"] = "Load All"
--[[ 742]] L["全开"] = "Load"
--[[ 743]] L["加载当前显示的所有插件"] = "Load all addons in the above list"
--[[ 745]] L["注意：战斗中执行此操作可能会导致大量错误，建议执行完毕后重载界面。"] = "Warning: Loading addons in combat may cause lots of errors. You may want to reload ui after that."
--[[ 747]] L["注意：可能会加载近一分钟之久，期间游戏会停止响应，请安心等待。"] = "The game may freeze for up to 1 minute, just wait in patient."
--[[ 753]] L["全部停用"] = "Disable All"
--[[ 753]] L["全关"] = "Disable"
--[[ 754]] L["停用当前显示的所有插件"] = "Disable all addons in the above list"
--[[ 756]] L["注意：战斗中执行此操作可能会导致大量错误。"] = "Warning: Disabling addons in combat may cause lots of errors. You may want to reload ui after that."
--[[ 758]] L["停用后请手动重载界面"] = "Usually, disabling addons will not take effect unless you reload ui"
--[[ 764]] --L["已启用"] = true
--[[ 766]] L["说明"] = "Hint"
--[[ 766]] L["显示当前分类下已启用的插件"] = "Show or hide the loaded addons in the above list"
--[[ 767]] L["未启用"] = "Disabled"
--[[ 769]] --L["说明"] = true
--[[ 769]] L["显示当前分类下未启用的插件"] = "Show or hide the disabled addons in the above list"
--[[1038]] L["已启用|cff00ff00 %d|r"] = "|cff00ff00 %d|r Enabled"
--[[1039]] L["未启用|cffAAAAAA %d|r"] = "|cffAAAAAA %d|r Disabled"
--[[1049]] L["全部插件加载完毕."] = "All addons are done loading."
--[[1140]] L["插件选项"] = "Addon Option"
--[[1141]] L["插件介绍"] = "Addon Introduction"
--[[1275]] L["插件分类："] = "Category: "
--[[1275]] L["<P>　%s<br/><br/></P>"] = "<P>  %s<br/><br/></P>"
--[[1275]] L["<P>　%s</P></BODY></HTML>"] = "<P>  %s</P></BODY></HTML>"
--[[1276]] L["插件数："] = "Addons Installed: "
--[[1288]] L["<BR/>　"] = "<BR/>  "
--[[1291]] L["<BR/><BR/>　插件集包含以下插件："] = "<BR/><BR/>　Includes the following："
--[[1294]] L["<BR/>　|cffe6e6b3 - %s|r"] = "<BR/>  |cffe6e6b3 - %s|r"
--[[1301]] --L["插件介绍"] = true
--[[1301]] L["<P>　%s<br/></P>%s</BODY></HTML>"] = "<P>  %s<br/></P>%s</BODY></HTML>"
--[[1304]] L["<P>|cffe6e6b3作者: %s|r</P>"] = "<P>|cffe6e6b3Author: %s|r</P>"
--[[1307]] L["<P>|cffe6e6b3修改: %s|r</P>"] = "<P>|cffe6e6b3Credits: %s|r</P>"
--[[1319]] L["<H2 align='center'>|cff7f7fff◆ %s ◆|r</H2>"] = "<H2 align='center'>|cff7f7fff* %s *|r</H2>"
--[[1323]] L["<H2>◇|cffffd200%s|r</H2>"] = "<H2>- |cffffd200%s|r</H2>"
--[[1337]] L["<H2>|cff7f7fff◇ %s%s ◇|r</H2>"] = "<H2>|cff7f7fff- %s%s -|r</H2>"
--[[1337]] L[".*年(.*) %d+:%d+"] = true --UNUSED
--[[1347]] L["最近更新"] = "Update Logs"
--[[1653]] L["搜索插件及选项"] = "Search addons"
--[[1654]] L["输入汉字、全拼或简拼进行检索，只有一个结果时可按回车选定。"] = ""
--[[1656]] L["可以搜索插件名称或原名、以及选项中的任意文本，在当前标签下符合条件的插件会被显示出来，被搜索到的选项会被高亮显示。"] = ""
--[[1658]] L["仅爱不易官方支持的插件才能用拼音搜索名称。"] = ""
--[[1679]] L["这里可以输入汉字或者拼音，例如'|cffffd200对比|r'或者'|cffffd200Grid|r'。不但能查询插件名称，还能查询插件的选项呢！试试输入'|cffffd200对比|r'，然后选|cffffd200\"鼠标提示\"|r插件，选项里就会显示：\n|cffffd200\"是否自动|r|cff00d200对比|r|cffffd200装备\"|r。\n\n让一切功能手到擒来，现在就试试吧！"] = ""
--[[1745]] L["爱不易"] = "AbyUI"
--[[1745]] L["点击爱不易标志开启插件控制中心\n \nCtrl点击小地图图标可以收集/还原"] = "Click the icon to open AbyUI control panel.\n \nCtrl click minimap buttons to gather/restore them."
--[[1754]] --L["爱不易"] = true
--[[1771]] L["爱不易插件中心"] = "AbyUI Control Panel"
--[[1773]] L["    爱不易（AbyUI）是新一代整合插件。其设计理念是兼顾整合插件的易用性和单体插件的灵活性，同时适合普通和高级用户群体。|n|n    功能上，爱不易实现了任意插件的随需加载，并可先进入游戏再逐一加载插件，此为全球首创。此外还有标签分类、拼音检索、界面缩排等特色功能。"] = "An advanced in-game addon control center, which combines Categoring, Searching, Loading and Setting of wow addons all together."
--[[1775]] L["鼠标右键点击可打开快捷设置"] = "Right click to open quick menu."
--[[1776]] L["Ctrl点击任意小地图按钮可收集"] = "Ctrl click minimap buttons to gather them."
--[[1779]] L["图标闪光表示有新的小地图按钮被收集到控制台中， 请点击查看，下次就不再闪烁了"] = "New buttons are gathered by the control panel."

--[[    ]] -- File: Minimap.lua

--[[  54]] L["按住CTRL点击可以收集"] = "Ctrl+click to gather"
--[[  56]] L["按住CTRL点击可以还原"] = "Ctrl+click to uncollect"

--- ===========================================================
-- Profiles.lua ProfilesUI.lua
--- ===========================================================
L["Before Load Profile"] = true
L["Before Logout"] = true
L["Before Restore"] = true
L["After Login"] = true

L["Current addon enable states will be lost, are you SURE?"] = true
L["Are you sure to delete this profile?"] = true
L["AbyUI Profiles"] = true
L["Saved"] = true
L["Auto"] = true
L["EAC will automatically save profiles before logout, after login, or loading another profile."] = true
L["Create Profile"] = true
L["Restore Default"] = true
L["Profile: "] = true
L["AddOns: "] = true
L["Today"] = true
L["AddOn States"] = true
L["AddOn Options"] = true
L["In addition of saving addon enable/disable states, also save the options shown in the EAC panel."] = true
L["Rename"] = true
L["Unnamed"] = true
L["Load"] = true
L["Delete"] = true
L["Save"] = true
L["New profile name: "] = true
L["Change profile name: "] = true

--[[    ]] -- File: RunFirst.lua

--[[  32]] L["|cffcd1a1c【爱不易】|r- "] = "|cffcd1a1cAbyUI|r - "

--[[    ]] -- File: Tags.lua

--[[  31]] L["全部插件"] = "All"
--[[  38]] L["精新推荐"] = "New"
--[[  43]] --L["爱不易"] = true
--[[  51]] --L["单体插件"] = true
--[[  58]] L["专用"] = ""
--[[  65]] --L["已启用"] = true
--[[  72]] --L["未启用"] = true

--[[    ]] -- File: Core\Core.lua

--[[ 228]] L["没有事件["] = "No script for event ["
--[[ 228]] L["]的处理函数."] = "]."
--[[ 420]] L["忘记设置isscript了？"] = "forgot to set isscript ?"

--[[    ]] -- File: Controls\Controls.lua

--[[ 106]] L["|cffff0000需要重新加载界面|r"] = "|cffff0000Changing this option requires a UI reloading.|r"
--[[ 108]] L["注意"] = "Warning: "
--[[ 108]] --L["|cffff0000需要重新加载界面|r"] = true

--[[    ]] -- File: Controls\SpinBox.lua

--[[  76]] L["请输入 |cffffd200%s|r ~ |cffffd200%s|r 之间的数字"] = "Please input a number between |cffffd200%s|r and |cffffd200%s|r"

--[[    ]] -- File: Configs\Cfg!!!163UI!!!.lua

--[[   3]] --L["爱不易"] = true
--[[   5]] L["爱不易是新一代整合插件。其设计理念是兼顾整合插件的易用性和单体插件的灵活性，同时适合普通和高级用户群体。|n|n    功能上，爱不易实现了任意插件的随需加载，并可先进入游戏再逐一加载插件，此为全球首创。此外还有标签分类、拼音检索、界面缩排等特色功能。"] = "AbyUI is an advanced in-game addon control center, which combines Categoring, Searching, Loading and Setting of wow addons all together.``The most advanced feature is that ANY addons can be loaded immediately at ANYTIME, even those are not load-on-demands.``And it provides a complete solution for registering addons options to the control panel. It provides a series option widgets like AceGUI does, and saves and loads variables automatically. You can easily add commonly used slash commands or toggle options to the addon page by add some lua codes in CfgCustom.lua. The detailed development guide is on the website."
--[[   9]] L["|cffcd1a1c[爱不易原创]|r"] = "|cffcd1a1c[AbyUI]|r"
--[[  13]] L["延迟加载插件"] = "Delay AddOns Loading"
--[[  14]] L["说明`爱不易独家支持，可以先读完蓝条然后再逐一加载插件。会大大加快读条速度，但是加载大型插件时会有卡顿。如果不喜欢这种方式，请取消勾选即可，下次进游戏时就会采用新设置。` `对比测试：`未开启时，在第7.5秒后读完蓝条同时加载完全部插件`开启后，在第3.8秒读完蓝条，第8.0秒加载完全部插件"] = "Hint`Addons that registered with \"loading='LATER'\" will be loaded after player entering world, to decrease the time spends on Blizzard loading screen."
--[[  22]] L["插件加载速度（个/秒）"] = "Loading Speed (Addons per Second)"
--[[  23]] L["说明`　控制进入游戏时插件加载的速度，如果数值大，则单次卡顿的时间长，但总的加载时间会短，比如设置成100就会大卡一下后插件就全部加载好了。而设置成5则是每秒只会小卡一下，但要很久才能加载完全部插件。` `　另外可以使用/rl2命令来强制最慢速度加载，适合副本战斗中界面出错后（比如上载具没出动作条）迅速重载界面。"] = "Hint`The game client will freeze if loading too much addons together. Decrease the loading speed to reduce the freezing time."
--[[  36]] L["允许加载过期插件"] = "Load out of date AddOns"
--[[  37]] L["说明`和人物选择功能插件界面上的选项一致"] = "Hint`Same as the blizzard option in character scrren."
--[[  46]] L["完全屏蔽默认的团队框架"] = "Hide Blizzard’s Compact Raid UI"
--[[  47]] L["说明`完全屏蔽暴雪团队框架及屏幕左侧的控制条，在使用Grid等团队框架时可以减少占用。` `注意此选项不能在战斗中设置"] = "Hint`Totally hide the Blizzard default raid UI, to free the CPU resource if you are using raid addons like Grid.` `Don't modify it while in combat"
--[[  53]] L["此选项不适合此游戏版本"] = "This options is not for current client version."
--[[  56]] L["此选项无法在战斗中设置，请脱战后重试"] = "This options can't be changed while in combat."
--[[  89]] L["设置最远镜头距离"] = "Set Max Camera Distance"
--[[  90]] L["说明`这个值是修改\"界面-镜头-最大镜头距离\"绝对值, 比如, 系统默认为15, 界面设置里调到最大是15，调到中间是7.5。当设置此选项为25时，调到最大是25，调到中间是12.5"] = "Hint`The max value of 'Interface - Camera - Max Camera Disatance' is 15 by default. It can be set to 25 by this option."
--[[  99]] L["控制台设置"] = "Control Panel Settigns"
--[[ 102]] L["显示插件英文名"] = "Show Addons Folder Name"
--[[ 104]] L["说明`选中显示插件目录的名字，适合中高级用户快速选择所需插件。"] = "Hint`Shows the addon origin name (folder name) instead of the Title in the toc file."
--[[ 116]] L["按插件所用内存排序"] = "Sort by Memory Usage"
--[[ 118]] L["说明`选中则按插件(包括子模块)所占内存大小进行排序，否则按插件名称排序。"] = "Hint`Sort the addons by their memory usages instead of names order."
--[[ 130]] L["小地图相关"] = "Minimap Buttons Settings"
--[[ 133]] L["收集全部小地图图标"] = "Gather All Minimap Buttons"
--[[ 140]] L["还原全部小地图图标"] = "Restore All Minimap Buttons"
--[[ 149]] L["隐藏缩小放大按钮"] = "Hide Zoom In/Out Buttons"
--[[ 150]] L["说明`隐藏后用鼠标滚轮缩放小地图"] = "Hint`Use mouse wheel to zoom in/out the minimap while the zoom buttons are hidden."
