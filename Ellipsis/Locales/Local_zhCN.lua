--[[
	Translations for Ellipsis

	Language: English (Default)
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Ellipsis', 'zhCN')
if not L then return end

L.OverlayCooldown = '冷却计时条'

L.VersionUpdated	= '版本更新至 v%s'
L.VersionUpdatedNew	= '版本更新至 v%s - 有新的选项可用!'
L.ChatUsage			= '用法 - /ellipsis [lock|unlock]\n   不带参数会打开设置界面, 或使用lock, unlock参数来锁定解锁框体.'
L.CannotLoadOptions	= '无法加载 Ellipsis_Options 插件, 无法打开设置界面, 返回的错误: |cffff2020%s|r'

-- aura & unit strings
L.Aura_Passive		= ''
L.Aura_Unknown		= '未知光环'
L.UnitLevel_Boss	= '首领'
L.UnitName_NoTarget	= '无目标'

-- aura tooltips
L.AuraTooltip			= '|cff67b1e9<左键点击> 通报剩余时间\n<右键点击> 取消此计时条\n<SHIFT右键> 屏蔽这个法术|r\n\n<CTRL+ALT+左键> 解锁框体'
L.AuraTooltipNoBlock	= '|cff67b1e9<左键点击> 通报剩余时间\n<右键点击> 取消此计时条|r\n|cffd0d0d0此法术只能在设置中屏蔽|r\n\n<CTRL+ALT+左键> 解锁框体'

-- cooldown icon tooltips
L.CooldownTimerTooltip			= '|cff67b1e9<左键点击> 通报剩余时间\n<右键点击> 取消这个计时\n<SHIFT右键> 屏蔽这个法术|r'
L.CooldownTimerTooltipNoBlock	= '|cff67b1e9<左键点击> 通报剩余时间\n<右键点击> 取消这个计时|r\n|cffd0d0d0此法术只能在设置中屏蔽|r'

-- filter lists
L.FilterBlackAdd				= '法术已添加到屏蔽列表: %s [|cffffd100%d|r]'
L.FilterBlackRemove			= '已不再屏蔽法术: %s [|cffffd100%d|r]'
L.FilterWhiteAdd			= '法术已添加到白名单: %s [|cffffd100%d|r]'
L.FilterWhiteRemove			= '法术已从白名单移除: %s [|cffffd100%d|r]'
L.BlacklistCooldownAdd		= '此法术冷却计时已屏蔽: %s [|cffffd100%d|r]'
L.BlacklistCooldownRemove	= '冷却计时已不再屏蔽法术: %s [|cffffd100%d|r]'
L.BlacklistUnknown			= '未知的法术'

-- announcements
L.Announce_ActiveAura			= '我在 %2$s 上的 %1$s 将在 %3$s 后结束.'
L.Announce_ActiveAura_NoTarget	= '我的 %s 将在 %s 后结束.'
L.Announce_ExpiredAura			= '我在 %2$s 上的 %1$s 已结束!'
L.Announce_ExpiredAura_NoTarget	= '我的 %s 已结束!'
L.Announce_PassiveAura			= '我的 %s 已在 %s 上激活.'
L.Announce_PassiveAura_NoTarget	= '我的 %s 已激活.'
L.Announce_ActiveCooldown		= '我的 %s 正在冷却 (%s).'

-- alerts
L.Alert_ExpiredAura		= '%2$s 上的 %1$s 结束了'
L.Alert_BrokenAura		= '%2$s 上的 %1$s 被打破!'
L.Alert_PrematureCool	= '%s 提前冷却完成!'
L.Alert_CompleteCool	= '%s 冷却完成'

-- overlay strings
L.OverlayHelperText		= '    框体已解锁，可以移动、缩放、设置透明度等'
L.OverlayTooltipHeader	= '计时条组 [|cffffd200%d|r]'
L.OverlayTooltipHelp	= '<左键拖动> 移动框体\n<鼠标滚轮> 设置透明度 (|cffffffff%d|r)\n<SHIFT滚轮> 设置缩放 (|cffffffff%.2f|r)'
L.OverlayTooltipAuras	= '单位分组: %s'

-- unit groups
L.UnitGroup_target		= '目标'
L.UnitGroup_focus		= '焦点'
L.UnitGroup_notarget	= '无目标技能'
L.UnitGroup_player		= '自身'
L.UnitGroup_pet			= '宠物'
L.UnitGroup_harmful		= '负面效果'
L.UnitGroup_helpful		= '增益'
L.UnitGroup_none		= '无'
