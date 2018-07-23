--[[
	Translations for Ellipsis

	Language: English (Default)
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Ellipsis', 'enUS', true)


L.OverlayCooldown = 'Cooldown Bar'

L.VersionUpdated	= 'Version updated to v%s'
L.VersionUpdatedNew	= 'Version updated to v%s - New settings are available!'
L.ChatUsage			= 'Usage - /ellipsis [lock|unlock]\n   With no argument to open options, or lock or unlock to control positioning of the display windows.'
L.CannotLoadOptions	= 'Failed to load Ellipsis_Options, cannot open settings. Error returned: |cffff2020%s|r'

-- aura & unit strings
L.Aura_Passive		= ''
L.Aura_Unknown		= 'Unknown Aura'
L.UnitLevel_Boss	= 'B'
L.UnitName_NoTarget	= 'Non-Targeted'

-- aura tooltips
L.AuraTooltip			= '|cff67b1e9<Left Click> to announce duration\n<Right Click> to cancel aura timer\n<Shift-Right Click> to block this aura|r'
L.AuraTooltipNoBlock	= '|cff67b1e9<Left Click> to announce duration\n<Right Click> to cancel aura timer|r\n|cffd0d0d0Manual block only using options|r'

-- cooldown icon tooltips
L.CooldownTimerTooltip			= '|cff67b1e9<Left Click> to announce cooldown\n<Right Click> to cancel cooldown timer\n<Shift-Right Click> to block this cooldown|r'
L.CooldownTimerTooltipNoBlock	= '|cff67b1e9<Left Click> to announce cooldown\n<Right Click> to cancel cooldown timer|r\n|cffd0d0d0Can only block using Blacklist options|r'

-- filter lists
L.FilterBlackAdd			= 'Aura Added To The Blacklist: %s [|cffffd100%d|r]'
L.FilterBlackRemove			= 'Aura Removed From The Blacklist: %s [|cffffd100%d|r]'
L.FilterWhiteAdd			= 'Aura Added To The Whitelist: %s [|cffffd100%d|r]'
L.FilterWhiteRemove			= 'Aura Removed From The Whitelist: %s [|cffffd100%d|r]'
L.BlacklistCooldownAdd		= 'Cooldown Added To The Blacklist: %s [|cffffd100%d|r]'
L.BlacklistCooldownRemove	= 'Cooldown Removed From The Blacklist: %s [|cffffd100%d|r]'


-- announcements
L.Announce_ActiveAura			= 'My [%s] will expire on [%s] in %s.'
L.Announce_ActiveAura_NoTarget	= 'My [%s] will expire in %s.'
L.Announce_ExpiredAura			= 'My [%s] has expired on [%s]!'
L.Announce_ExpiredAura_NoTarget	= 'My [%s] has expired!'
L.Announce_PassiveAura			= 'My [%s] is active on [%s].'
L.Announce_PassiveAura_NoTarget	= 'My [%s] is active.'
L.Announce_ActiveCooldown		= 'My [%s] is on cooldown for %s.'

-- alerts
L.Alert_ExpiredAura		= '%s has EXPIRED on %s!'
L.Alert_BrokenAura		= '%s has BROKEN on %s!'
L.Alert_PrematureCool	= '%s cooldown completed early!'
L.Alert_CompleteCool	= '%s cooldown has completed!'

-- overlay strings
L.OverlayHelperText		= 'Frames unlocked for positioning, scaling and opacity changes. Click below for full options or Exit to lock frame positions and hide overlays.'
L.OverlayTooltipHeader	= 'Aura Frame [|cffffd200%d|r]'
L.OverlayTooltipHelp	= '<Left Click> to move window\n<Mousewheel> to set opacity (|cffffffff%d|r)\n<Shift-Mousewheel> to set scale (|cffffffff%.2f|r)'
L.OverlayTooltipAuras	= 'Unit Groups: %s'

-- unit groups
L.UnitGroup_target		= 'Target'
L.UnitGroup_focus		= 'Focus'
L.UnitGroup_notarget	= 'Non-Targeted'
L.UnitGroup_player		= 'Player'
L.UnitGroup_pet			= 'Pet'
L.UnitGroup_harmful		= 'Harmful'
L.UnitGroup_helpful		= 'Helpful'
L.UnitGroup_none		= 'None'
