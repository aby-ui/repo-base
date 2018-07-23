--[[
	Translations for Ellipsis

	Language: English (Default)
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Ellipsis', 'zhTW')
if not L then return end


L.OverlayCooldown = '冷卻計時條'




L.VersionUpdated	= '版本更新至 v%s'
L.VersionUpdatedNew	= '版本更新至 v%s - 有新的選項可用!'
L.ChatUsage			= '用法 - /ellipsis [lock|unlock]\n   不帶參數會打開設置介面, 或使用lock, unlock參數來鎖定解鎖框體.'
L.CannotLoadOptions	= '無法載入 Ellipsis_Options 外掛程式, 無法打開設置介面, 返回的錯誤: |cffff2020%s|r'

-- aura & unit strings
L.Aura_Passive		= ''
L.UnitLevel_Boss	= '首领'
L.UnitName_NoTarget	= '非目標'

-- aura tooltips
L.AuraTooltip			= '|cff67b1e9<左鍵點擊> 通報剩餘時間\n<右鍵點擊> 取消此計時條\n<SHIFT右鍵> 遮罩這個法術|r'
L.AuraTooltipNoBlock	= '|cff67b1e9<左鍵點擊> 通報剩餘時間\n<右鍵點擊> 取消此計時條|r\n|cffd0d0d0此法術只能在設置中遮罩|r'

-- cooldown icon tooltips
L.CooldownTimerTooltip			= '|cff67b1e9<左鍵點擊> 通報剩餘時間\n<右鍵點擊> 取消這個計時\n<SHIFT右鍵> 遮罩這個法術|r'
L.CooldownTimerTooltipNoBlock	= '|cff67b1e9<左鍵點擊> 通報剩餘時間\n<右鍵點擊> 取消這個計時|r\n|cffd0d0d0此法術只能在設置中遮罩|r'

-- blacklisting
L.BlacklistAdd				= '法術已添加到遮罩列表: %s [|cffffd100%d|r]'
L.BlacklistRemove			= '已不再遮罩法術: %s [|cffffd100%d|r]'
L.BlacklistCooldownAdd		= '此法術冷卻計時已遮罩: %s [|cffffd100%d|r]'
L.BlacklistCooldownRemove	= '冷卻計時已不再遮罩法術: %s [|cffffd100%d|r]'
L.BlacklistUnknown			= '未知的法術'

-- announcements
L.Announce_ActiveAura			= '我在 %2$s 上的 %1$s 將在 %3$s 後結束.'
L.Announce_ActiveAura_NoTarget	= '我的 %s 將在 %s 後結束.'
L.Announce_ExpiredAura			= '我在 %2$s 上的 %1$s 已結束!'
L.Announce_ExpiredAura_NoTarget	= '我的 %s 已結束!'
L.Announce_PassiveAura			= '我的 %s 已在 %s 上啟動.'
L.Announce_PassiveAura_NoTarget	= '我的 %s 已啟動.'
L.Announce_ActiveCooldown		= '我的 %s 正在冷卻 (%s).'

-- alerts
L.Alert_ExpiredAura		= '%2$s 上的 %1$s 結束了'
L.Alert_BrokenAura		= '%2$s 上的 %1$s 被打破!'
L.Alert_PrematureCool	= '%s 提前冷卻完成!'
L.Alert_CompleteCool	= '%s 冷卻完成'

-- overlay strings
L.OverlayHelperText		= '    框體已解鎖，可以移動、縮放、設置透明度等'
L.OverlayTooltipHeader	= '計時條組 [|cffffd200%d|r]'
L.OverlayTooltipHelp	= '<左鍵拖動> 移動框體\n<滑鼠滾輪> 設置透明度 (|cffffffff%d|r)\n<SHIFT滾輪> 設置縮放 (|cffffffff%.2f|r)'
L.OverlayTooltipAuras	= '單位分組: %s'

-- unit groups
L.UnitGroup_target		= '目標'
L.UnitGroup_focus		= '焦點'
L.UnitGroup_notarget	= '非目標'
L.UnitGroup_player		= '自身'
L.UnitGroup_pet			= '寵物'
L.UnitGroup_harmful		= '負面效果'
L.UnitGroup_helpful		= '增益'
L.UnitGroup_none		= '無'