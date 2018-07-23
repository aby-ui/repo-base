--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	GridLocale-zhTW.lua
	Traditional Chinese localization
	Contributors: ananhaid, helium, lsjyzjl, scorpion, Whyv, zhTW
----------------------------------------------------------------------]]

if GetLocale() ~= "zhTW" then return end

local _, Grid = ...
local L = { }
Grid.L = L

------------------------------------------------------------------------
--	GridCore

-- GridCore
L["Debugging"] = "除錯中"
--[[Translation missing --]]
L["Debugging messages help developers or testers see what is happening inside Grid in real time. Regular users should leave debugging turned off except when troubleshooting a problem for a bug report."] = "Debugging messages help developers or testers see what is happening inside Grid in real time. Regular users should leave debugging turned off except when troubleshooting a problem for a bug report."
--[[Translation missing --]]
L["Enable debugging messages for the %s module."] = "Enable debugging messages for the %s module."
--[[Translation missing --]]
L["General"] = "General"
L["Module debugging menu."] = "除錯模組設定。"
--[[Translation missing --]]
L["Open Grid's options in their own window, instead of the Interface Options window, when typing /grid or right-clicking on the minimap icon, DataBroker icon, or layout tab."] = "Open Grid's options in their own window, instead of the Interface Options window, when typing /grid or right-clicking on the minimap icon, DataBroker icon, or layout tab."
--[[Translation missing --]]
L["Output Frame"] = "Output Frame"
L["Right-Click for more options."] = "右鍵-點擊 開啟選單。"
--[[Translation missing --]]
L["Show debugging messages in this frame."] = "Show debugging messages in this frame."
L["Show minimap icon"] = "顯示小地圖按鈕"
L["Show the Grid icon on the minimap. Note that some DataBroker display addons may hide the icon regardless of this setting."] = "在小地圖顯示 Grid 圖示。注意，一些 DataBroker 顯示插件無論是否設定可能隱藏圖示。"
--[[Translation missing --]]
L["Standalone options"] = "Standalone options"
L["Toggle debugging for %s."] = "啟用/禁用 %s 的除錯訊息。"

------------------------------------------------------------------------
--	GridFrame

-- GridFrame
L["Adjust the font outline."] = "調整字體描邊。"
L["Adjust the font settings"] = "調整字型。"
L["Adjust the font size."] = "調整字型大小。"
L["Adjust the height of each unit's frame."] = "為每一個單位框架調整高度。"
L["Adjust the size of the border indicators."] = "調整邊框提示器大小"
L["Adjust the size of the center icon."] = "調整中央圖示大小。"
L["Adjust the size of the center icon's border."] = "調整中央圖示的邊框大小"
L["Adjust the size of the corner indicators."] = "調整角落提示器的大小。"
L["Adjust the texture of each unit's frame."] = "調整每一個單位框架的材質。"
L["Adjust the width of each unit's frame."] = "為每一個單位框架調整寬度。"
L["Always"] = "總是"
L["Bar Options"] = "狀態條選項"
L["Border"] = "邊框"
L["Border Size"] = "邊框大小"
L["Bottom Left Corner"] = "左下角"
L["Bottom Right Corner"] = "右下角"
L["Center Icon"] = "中央圖示"
L["Center Text"] = "中央文字"
L["Center Text 2"] = "中央文字2"
L["Center Text Length"] = "中央文字長度"
L["Color the healing bar using the active status color instead of the health bar color."] = "對治療條使用狀態中使用此顏色"
L["Corner Size"] = "角落提示器大小"
L["Darken the text color to match the inverted bar."] = "文本顏色變暗以匹配反轉條。"
L["Enable %s"] = "啟用%s"
L["Enable %s indicator"] = "啟用%s提示器"
L["Enable Mouseover Highlight"] = "啟用滑鼠懸停高亮"
L["Enable right-click menu"] = "啟用右擊菜單"
L["Font"] = "字型設定"
L["Font Outline"] = "字體描邊"
L["Font Shadow"] = "字體陰影"
L["Font Size"] = "字型大小"
L["Frame"] = "框架"
L["Frame Alpha"] = "框架透明度"
L["Frame Height"] = "框架高度"
L["Frame Texture"] = "框架材質"
L["Frame Width"] = "框架寬度"
L["Healing Bar"] = "治療條"
L["Healing Bar Opacity"] = "治療條透明度"
L["Healing Bar Uses Status Color"] = "治療條使用狀態的顏色"
L["Health Bar"] = "生命力條"
L["Health Bar Color"] = "生命力條顏色"
L["Horizontal"] = "水平"
L["Icon Border Size"] = "圖示邊框大小"
L["Icon Cooldown Frame"] = "圖示冷卻時間框架"
L["Icon Options"] = "圖示選項"
L["Icon Size"] = "圖示大小"
L["Icon Stack Text"] = "圖示堆疊文字"
L["Indicators"] = "提示器"
L["Invert Bar Color"] = "調換顏色"
L["Invert Text Color"] = "反轉文本顏色"
L["Make the healing bar use the status color instead of the health bar color."] = "治療條使用狀態顏色而不是治療條顏色。"
L["Never"] = "永不"
L["None"] = "無"
L["Number of characters to show on Center Text indicator."] = "中央文字提示器所顯示的文字長度。"
L["OOC"] = "戰鬥外"
L["Options for %s indicator."] = "%s提示器的設定選項。"
L["Options for assigning statuses to indicators."] = "分配狀態給提示器的選項"
L["Options for GridFrame."] = "GridFrame 設定選項。"
L["Options related to bar indicators."] = "狀態條提示器的選項"
L["Options related to icon indicators."] = "圖示提示器的選項"
L["Options related to text indicators."] = "文字提示器的選項"
L["Orientation of Frame"] = "框架排列方式"
L["Orientation of Text"] = "文字排列方式"
L["Set frame orientation."] = "設定框架排列方式。"
L["Set frame text orientation."] = "設定框架中文字排列方式。"
L["Sets the opacity of the healing bar."] = "設定治療條的透明度。"
L["Show the standard unit menu when right-clicking on a frame."] = "右擊框體顯示標準單位菜單。"
L["Show Tooltip"] = "顯示提示訊息"
L["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."] = "顯示單位框架的提示訊息。選擇「總是」，「永不」或「戰鬥外」。"
L["Statuses"] = "狀態"
L["Swap foreground/background colors on bars."] = "調換提示條背景與前景之顏色。"
L["Text Options"] = "文字選項"
L["Thick"] = "粗體"
L["Thin"] = "細體"
L["Throttle Updates"] = "調節更新"
L["Throttle updates on group changes. This option may cause delays in updating frames, so you should only enable it if you're experiencing temporary freezes or lockups when people join or leave your group."] = "隊伍改變時調節更新.這選項可能在更新框架時會導致延遲,所以當有人加入或離開隊伍時發生短暫凍結或畫面停止開啟此選項."
L["Toggle center icon's cooldown frame."] = "啟用/禁用圖示的冷卻時間框架。"
L["Toggle center icon's stack count text."] = "啟用/禁用圖示的堆疊計數文字。"
L["Toggle mouseover highlight."] = "啟用/禁用滑鼠懸停高亮。"
L["Toggle status display."] = "啟用/禁用顯示狀態。\n按住ALT點擊可配置此狀態的選項"
L["Toggle the %s indicator."] = "啟用/禁用%s提示器。"
L["Toggle the font drop shadow effect."] = "啟用/關閉 字型下拉陰影效果"
L["Top Left Corner"] = "左上角"
L["Top Right Corner"] = "右上角"
L["Vertical"] = "垂直"

------------------------------------------------------------------------
--	GridLayout

-- GridLayout
L["10 Player Raid Layout"] = "10人團隊模式"
L["25 Player Raid Layout"] = "25人團隊模式"
--[[Translation missing --]]
L["40 Player Raid Layout"] = "40 Player Raid Layout"
L["Adjust background color and alpha."] = "調整背景顏色與透明度。"
L["Adjust border color and alpha."] = "調整邊框顏色與透明度。"
L["Adjust frame padding."] = "調整框架間距。"
L["Adjust frame spacing."] = "調整外框架空間。"
L["Adjust Grid scale."] = "調整 Grid 縮放比例。"
--[[Translation missing --]]
L["Adjust the extra spacing inside the layout frame, around the unit frames."] = "Adjust the extra spacing inside the layout frame, around the unit frames."
--[[Translation missing --]]
L["Adjust the spacing between individual unit frames."] = "Adjust the spacing between individual unit frames."
L["Advanced"] = "進階"
L["Advanced options."] = "進階選項。"
L["Allows mouse click through the Grid Frame."] = "允許透過滑鼠點擊 Grid 框架。"
L["Alt-Click to permanantly hide this tab."] = "Alt-單擊總是隱藏此標簽。。"
--[[Translation missing --]]
L["Always hide wrong zone groups"] = "Always hide wrong zone groups"
L["Arena Layout"] = "競技場版面編排"
L["Background color"] = "背景顏色"
--[[Translation missing --]]
L["Background Texture"] = "Background Texture"
L["Battleground Layout"] = "戰場版面編排"
L["Beast"] = "野獸"
L["Border color"] = "邊框顏色"
--[[Translation missing --]]
L["Border Inset"] = "Border Inset"
--[[Translation missing --]]
L["Border Size"] = "Border Size"
L["Border Texture"] = "邊框材質"
L["Bottom"] = "下"
L["Bottom Left"] = "左下"
L["Bottom Right"] = "右下"
L["By Creature Type"] = "依生物類型"
L["By Owner Class"] = "依玩家職業"
--[[Translation missing --]]
L["ByGroup Layout Options"] = "ByGroup Layout Options"
L["Center"] = "中"
L["Choose the layout border texture."] = "選擇版面編排的邊框材質"
L["Clamped to screen"] = "限制框架於視窗內"
L["Class colors"] = "職業顏色"
L["Click through the Grid Frame"] = "透過點擊 Grid 框架"
L["Color for %s."] = "%s的顏色"
L["Color of pet unit creature types."] = "玩家召喚之寵物的顏色。"
L["Color of player unit classes."] = "玩家職業的顏色。"
L["Color of unknown units or pets."] = "未知單位或寵物的顏色。"
L["Color options for class and pets."] = "職業與寵物的顏色選項。"
L["Colors"] = "顏色"
L["Creature type colors"] = "召喚類型的顏色"
L["Demon"] = "惡魔"
L["Drag this tab to move Grid."] = "拖動此標簽移動 Grid。"
L["Dragonkin"] = "龍類"
L["Elemental"] = "元素生物"
L["Fallback colors"] = "備用顏色"
--[[Translation missing --]]
L["Flexible Raid Layout"] = "Flexible Raid Layout"
L["Frame lock"] = "鎖定框架"
--[[Translation missing --]]
L["Frame Spacing"] = "Frame Spacing"
L["Group Anchor"] = "小組錨點"
--[[Translation missing --]]
L["Hide when in mythic raid instance"] = "Hide when in mythic raid instance"
--[[Translation missing --]]
L["Hide when in raid instance"] = "Hide when in raid instance"
L["Horizontal groups"] = "橫向顯示小組"
L["Humanoid"] = "人形生物"
L["Layout"] = "版面編排"
L["Layout Anchor"] = "版面編排錨點"
--[[Translation missing --]]
L["Layout Background"] = "Layout Background"
--[[Translation missing --]]
L["Layout Padding"] = "Layout Padding"
--[[Translation missing --]]
L["Layouts"] = "Layouts"
L["Left"] = "左"
L["Lock Grid to hide this tab."] = "鎖定 Grid 隱藏此標簽。"
L["Locks/unlocks the grid for movement."] = "鎖定/解鎖 Grid 框架。"
L["Not specified"] = "未指定"
L["Options for GridLayout."] = "Grid版面設定選項。"
L["Padding"] = "間距"
L["Party Layout"] = "隊伍版面編排"
L["Pet color"] = "寵物顏色"
L["Pet coloring"] = "寵物配色"
L["Reset Position"] = "重設位置"
L["Resets the layout frame's position and anchor."] = "重設版面位置和錨點。"
L["Right"] = "右"
L["Scale"] = "縮放比例"
L["Select which layout to use when in a 10 player raid."] = "選擇10人團隊模式面板編排"
L["Select which layout to use when in a 25 player raid."] = "選擇25人團隊模式面板編排"
--[[Translation missing --]]
L["Select which layout to use when in a 40 player raid."] = "Select which layout to use when in a 40 player raid."
L["Select which layout to use when in a battleground."] = "選擇戰場版面編排方式。"
--[[Translation missing --]]
L["Select which layout to use when in a flexible raid."] = "Select which layout to use when in a flexible raid."
L["Select which layout to use when in a party."] = "選擇隊伍版面編排方式。"
L["Select which layout to use when in an arena."] = "選擇競技場版面編排方式。"
L["Select which layout to use when not in a party."] = "選擇單人版面編排方式。"
L["Set the color of pet units."] = "設定寵物使用的顏色"
L["Set the coloring strategy of pet units."] = "設定寵物的配色方案。"
L["Sets where Grid is anchored relative to the screen."] = "設定 Grid 的版面位置錨點。"
L["Sets where groups are anchored relative to the layout frame."] = "設定版面編排中的小組錨點。"
L["Show a tab for dragging when Grid is unlocked."] = "當未鎖定 Grid 時顯示標簽。"
--[[Translation missing --]]
L["Show all groups"] = "Show all groups"
L["Show Frame"] = "顯示框架"
--[[Translation missing --]]
L["Show groups with all players in wrong zone."] = "Show groups with all players in wrong zone."
--[[Translation missing --]]
L["Show groups with all players offline."] = "Show groups with all players offline."
--[[Translation missing --]]
L["Show Offline"] = "Show Offline"
L["Show tab"] = "顯示標簽"
L["Solo Layout"] = "單人版面編排"
L["Spacing"] = "空間"
L["Switch between horizontal/vertical groups."] = "轉換橫向/垂直顯示小組。"
L["The color of unknown pets."] = "未知寵物的顏色。"
L["The color of unknown units."] = "未知單位的顏色。"
L["Toggle whether to permit movement out of screen."] = "啟用/禁用框架於視窗內限制，避免拖曳出視窗外。"
L["Top"] = "上"
L["Top Left"] = "左上"
L["Top Right"] = "右上"
L["Undead"] = "不死生物"
L["Unknown Pet"] = "未知寵物"
L["Unknown Unit"] = "未知單位"
--[[Translation missing --]]
L["Use the 40 Player Raid layout when in a raid group outside of a raid instance, instead of choosing a layout based on the current Raid Difficulty setting."] = "Use the 40 Player Raid layout when in a raid group outside of a raid instance, instead of choosing a layout based on the current Raid Difficulty setting."
L["Using Fallback color"] = "使用備用顏色"
--[[Translation missing --]]
L["World Raid as 40 Player"] = "World Raid as 40 Player"
--[[Translation missing --]]
L["Wrong Zone"] = "Wrong Zone"

------------------------------------------------------------------------
--	GridLayoutLayouts

-- GridLayoutLayouts
L["By Class 10"] = "10人以職業排列"
L["By Class 10 w/Pets"] = "10人以職業/寵物排列"
L["By Class 25"] = "25人以職業排列"
L["By Class 25 w/Pets"] = "25人以職業/寵物排列"
--[[Translation missing --]]
L["By Class 40"] = "By Class 40"
--[[Translation missing --]]
L["By Class 40 w/Pets"] = "By Class 40 w/Pets"
L["By Group 10"] = "10人團隊"
L["By Group 10 w/Pets"] = "10人團隊及寵物"
L["By Group 15"] = "15人團隊"
L["By Group 15 w/Pets"] = "15人團隊及寵物"
L["By Group 25"] = "25人團隊"
L["By Group 25 w/Pets"] = "25人團隊及寵物"
L["By Group 25 w/Tanks"] = "25人團隊及坦克"
L["By Group 40"] = "40人團隊"
L["By Group 40 w/Pets"] = "40人團隊及寵物"
L["By Group 5"] = "5人團隊"
L["By Group 5 w/Pets"] = "5人團隊及寵物"
L["None"] = "無"

------------------------------------------------------------------------
--	GridLDB

-- GridLDB
L["Click to toggle the frame lock."] = "點擊切換框架鎖定。"

------------------------------------------------------------------------
--	GridStatus

-- GridStatus
L["Color"] = "顏色"
L["Color for %s"] = "%s的顏色"
L["Enable"] = "啟用"
--[[Translation missing --]]
L["Opacity"] = "Opacity"
L["Options for %s."] = "%s 設定選項。"
L["Priority"] = "優先程度"
L["Priority for %s"] = "%s的優先程度"
L["Range filter"] = "距離過濾"
L["Reset class colors"] = "重置職業顔色"
L["Reset class colors to defaults."] = "重置職業顔色為默認"
L["Show status only if the unit is in range."] = "當單位在距離中顯示狀態"
L["Status"] = "狀態"
L["Status: %s"] = "狀態: %s"
L["Text"] = "文字"
L["Text to display on text indicators"] = "顯示文字於文字提示器上"

------------------------------------------------------------------------
--	GridStatusAbsorbs

-- GridStatusAbsorbs
--[[Translation missing --]]
L["Absorbs"] = "Absorbs"
--[[Translation missing --]]
L["Only show total absorbs greater than this percent of the unit's maximum health."] = "Only show total absorbs greater than this percent of the unit's maximum health."

------------------------------------------------------------------------
--	GridStatusAggro

-- GridStatusAggro
L["Aggro"] = "仇恨"
L["Aggro alert"] = "仇恨警告"
L["Aggro color"] = "仇恨的顏色"
L["Color for Aggro."] = "獲得仇恨時的顏色"
L["Color for High Threat."] = "高仇恨時的顏色。"
L["Color for Tanking."] = "坦克時的顏色。"
L["High"] = "高"
L["High Threat color"] = "高仇恨的顏色"
L["Show detailed threat levels instead of simple aggro status."] = "顯示更詳細的仇恨值"
L["Tank"] = "坦克"
L["Tanking color"] = "坦克的顏色"
L["Threat"] = "仇恨"

------------------------------------------------------------------------
--	GridStatusAuras

-- GridStatusAuras
L["%s colors"] = "%s的顏色"
L["%s colors and threshold values."] = "%s的顏色和門檻值"
L["%s is high when it is at or above this value."] = "當此值大於%s時設為高優先權"
L["%s is low when it is at or below this value."] = "當此值小於%s時設為低優先權"
L["(De)buff name"] = "光環名稱"
L["<buff name>"] = "<增益名稱> 或 <增益ID>"
L["<debuff name>"] = "<減益名稱> 或 <減益ID>"
L["Add Buff"] = "增加新的增益"
L["Add Debuff"] = "增加新的減益"
L["Auras"] = "光環"
L["Buff: %s"] = "增益: %s"
L["Change what information is shown by the status color and text."] = "改變狀態顏色與文字的顯示"
L["Change what information is shown by the status color."] = "改變狀態顏色的顯示"
L["Change what information is shown by the status text."] = "改變狀態文字的顯示"
L["Class Filter"] = "職業過濾"
L["Color"] = "顏色"
L["Color to use when the %s is above the high count threshold values."] = "當%s高於高優先權門檻值時使用此顏色"
L["Color to use when the %s is between the low and high count threshold values."] = "當%s在高優先權與低優先權之間的門檻值時使用此顏色"
L["Color when %s is below the low threshold value."] = "當%s低於低優先權的門檻值時使用此顏色"
L["Create a new buff status."] = "增加一個新的增益至狀態模組中"
L["Create a new debuff status."] = "增加一個新的減益至狀態模組中"
L["Curse"] = "詛咒"
L["Debuff type: %s"] = "減益類型: %s"
L["Debuff: %s"] = "減益: %s"
L["Disease"] = "疾病"
L["Display status only if the buff is not active."] = "當缺少增益時提示。"
L["Display status only if the buff was cast by you."] = "顯示只有你所施放的增益。"
L["Ghost"] = "鬼魂"
L["High color"] = "高優先權顏色"
L["High threshold"] = "高優先權門檻"
L["Low color"] = "低優先權顏色"
L["Low threshold"] = "低優先權門檻"
L["Magic"] = "魔法"
L["Middle color"] = "中間值門檻顏色"
L["Pet"] = "寵物"
L["Poison"] = "毒"
L["Present or missing"] = "目前或遺失"
L["Refresh interval"] = "更新間隔"
L["Remove %s from the menu"] = "從選單中刪除%s"
L["Remove an existing buff or debuff status."] = "刪除狀態模組內已有的增/減益"
L["Remove Aura"] = "刪除增/減益"
--[[Translation missing --]]
L["Show advanced options"] = "Show advanced options"
--[[Translation missing --]]
L[ [=[Show advanced options for buff and debuff statuses.

Beginning users may wish to leave this disabled until you are more familiar with Grid, to avoid being overwhelmed by complicated options menus.]=] ] = [=[Show advanced options for buff and debuff statuses.

Beginning users may wish to leave this disabled until you are more familiar with Grid, to avoid being overwhelmed by complicated options menus.]=]
L["Show duration"] = "顯示持續時間"
L["Show if mine"] = "顯示我的"
L["Show if missing"] = "顯示缺少"
L["Show on %s players."] = "在玩家%s上顯示。"
L["Show on pets and vehicles."] = "顯示在寵物和載具上"
L["Show status for the selected classes."] = "顯示選定職業的狀態。"
L["Show the time left to tenths of a second, instead of only whole seconds."] = "只在時間剩餘10秒時顯示"
L["Show the time remaining, for use with the center icon cooldown."] = "在圖示中顯示持續時間。"
L["Show time left to tenths"] = "剩餘10秒時顯示"
L["Stack count"] = "堆疊次數"
L["Status Information"] = "狀態訊息"
L["Text"] = "文字"
L["Time in seconds between each refresh of the status time left."] = "每次狀態更新的時間間隔"
L["Time left"] = "時間剩餘"

------------------------------------------------------------------------
--	GridStatusHeals

-- GridStatusHeals
L["Heals"] = "治療"
L["Ignore heals cast by you."] = "忽略自己施放的治療法術。"
L["Ignore Self"] = "忽略自己"
L["Incoming heals"] = "治療中"
L["Minimum Value"] = "最小值"
L["Only show incoming heals greater than this amount."] = "只顯示大於此值的治療"

------------------------------------------------------------------------
--	GridStatusHealth

-- GridStatusHealth
L["Color deficit based on class."] = "損失生命力值根據不同的職業著色。"
L["Color health based on class."] = "生命力顏色根據不同的職業著色。"
L["DEAD"] = "死亡"
L["Death warning"] = "死亡警報"
L["FD"] = "假死"
L["Feign Death warning"] = "假死警報"
L["Health and Death"] = "生命力及死亡"
L["Health deficit"] = "損失生命力"
L["Health threshold"] = "生命力臨界點"
L["Low HP"] = "生命力不足"
L["Low HP threshold"] = "生命力不足臨界點"
L["Low HP warning"] = "生命力不足警報"
L["Offline"] = "離線"
L["Offline warning"] = "斷線警報"
L["Only show deficit above % damage."] = "當損失生命力超過總生命力某個百分比時顯示損失生命力值。"
L["Set the HP % for the low HP warning."] = "設定當生命力低於臨界點時警告。"
L["Show dead as full health"] = "顯示死亡為生命力全滿"
L["Treat dead units as being full health."] = "把死亡玩家的生命力顯示成全滿。"
L["Unit health"] = "單位生命力"
L["Use class color"] = "使用職業顏色"

------------------------------------------------------------------------
--	GridStatusMana

-- GridStatusMana
L["Low Mana"] = "法力不足"
L["Low Mana warning"] = "法力不足警報"
L["Mana"] = "法力"
L["Mana threshold"] = "法力不足臨界點"
L["Set the percentage for the low mana warning."] = "設定當法力低於臨界點時警告。"

------------------------------------------------------------------------
--	GridStatusName

-- GridStatusName
L["Color by class"] = "使用職業顏色"
L["Unit Name"] = "名字"

------------------------------------------------------------------------
--	GridStatusRange

-- GridStatusRange
L["Out of Range"] = "超出射程"
L["Range"] = "距離"
L["Range check frequency"] = "距離檢測頻率"
L["Seconds between range checks"] = "設定程式多少秒檢測一次距離"

------------------------------------------------------------------------
--	GridStatusReadyCheck

-- GridStatusReadyCheck
L["?"] = "？"
L["AFK"] = "暫離"
L["AFK color"] = "暫離的顏色"
L["Color for AFK."] = "暫離的顏色"
L["Color for Not Ready."] = "尚未就緒的顏色"
L["Color for Ready."] = "就緒的顏色"
L["Color for Waiting."] = "等待中的顏色"
L["Delay"] = "延遲"
L["Not Ready color"] = "尚未就緒的顏色"
L["R"] = "是"
L["Ready Check"] = "檢查就緒"
L["Ready color"] = "就緒的顏色"
L["Set the delay until ready check results are cleared."] = "設定檢查就續結果清除的延遲。"
L["Waiting color"] = "等待中的顏色"
L["X"] = "否"

------------------------------------------------------------------------
--	GridStatusResurrect

-- GridStatusResurrect
L["Casting color"] = "施放顏色"
L["Pending color"] = "等待顏色"
L["RES"] = "復"
L["Resurrection"] = "復活"
L["Show the status until the resurrection is accepted or expires, instead of only while it is being cast."] = "顯示復活接受或過期的狀態，而不是只是施放。"
L["Show until used"] = "顯示直至使用"
L["Use this color for resurrections that are currently being cast."] = "當前施放復活使用此顏色。"
L["Use this color for resurrections that have finished casting and are waiting to be accepted."] = "結束施放和等待接受復活使用此顏色。"

------------------------------------------------------------------------
--	GridStatusTarget

-- GridStatusTarget
L["Target"] = "目標"
L["Your Target"] = "你的目標"

------------------------------------------------------------------------
--	GridStatusVehicle

-- GridStatusVehicle
L["Driving"] = "操作"
L["In Vehicle"] = "載具上"

------------------------------------------------------------------------
--	GridStatusVoiceComm

-- GridStatusVoiceComm
L["Talking"] = "說話中"
L["Voice Chat"] = "語音"

------------------------------------------------------------------------
-- Warbaby
L["Icon X offset"] = "橫向偏移量"
L["Adjust the offset of the X-axis for center icon."] = "調整中心圖示距離中心點的橫坐標偏移量，左側為負值，右側為正值"
L["Icon Y offset"] = "縱向偏移量"
L["Adjust the offset of the Y-axis for center icon."] = "調整中心圖示距離中心點的縱向偏移量，上方為正值，下方為負值"
L["Force Layout"] = "強制佈局（此項選'無', 才按照組隊情況佈局）"
L["Options for Indicator %s"] = "配置'%s'的樣式"
