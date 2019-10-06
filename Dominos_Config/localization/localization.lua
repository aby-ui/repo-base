--[[
	Localization.lua
		Translations for Dominos

	English: Default language
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Config', 'enUS', true)

L.Scale = 'Scale'
L.Opacity = 'Opacity'
L.FadedOpacity = 'Faded Opacity'
L.Visibility = 'Visibility'
L.Spacing = 'Spacing'
L.Padding = 'Padding'
L.Layout = 'Layout'
L.Columns = 'Columns'
L.Size = 'Size'
L.Modifiers = 'Modifiers'
L.QuickPaging = 'Quick Paging'
L.Targeting = 'Targeting'
L.ShowStates = 'Show States'
L.Set = 'Set'
L.Save = 'Save'
L.Copy = 'Copy'
L.Delete = 'Delete'
L.Bar = 'Bar %d'
L.RightClickUnit = 'Right Click Target'
L.RCUPlayer = 'Self'
L.RCUFocus = 'Focus'
L.RCUToT = 'Target of Target'
L.EnterName = 'Enter Name'
L.PossessBar = 'Override Bar'
L.Profiles = 'Profiles'
L.ProfilesPanelDesc = 'Allows you to manage saved Dominos layouts'
L.SelfcastKey = 'Selfcast Key'
L.QuickMoveKey = 'Quick Move Key'
L.ShowMacroText = 'Show Macro Text'
L.ShowBindingText = 'Show Binding Text'
L.ShowCountText = "Show Count Text"
L.ShowEmptyButtons = 'Show Empty Buttons'
L.LockActionButtons = 'Lock Action Button Positions'
L.EnterBindingMode = 'Bind Keys...'
L.EnterConfigMode = 'Configure Bars...'
L.BarSettings = '%s Settings'
L.ShowTooltips = 'Show Tooltips'
L.ShowTooltipsCombat = 'Show Tooltips in Combat'
L.OneBag = 'One Bag'
L.ShowKeyring = 'Show Keyring'
L.StickyBars = 'Sticky Bars'
L.ShowMinimapButton = 'Show Minimap Button'
L.Advanced = 'Advanced'
L.LeftToRight = 'Layout Buttons From Left to Right'
L.TopToBottom = 'Layout Buttons From Top to Bottom'
L.LinkedOpacity = 'Docked bars inherit opacity'
L.ClickThrough = 'Enable Click Through'
L.DisableMenuButtons = 'Disable Buttons'
L.ShowOverrideUI = 'Use Blizzard Override Action Bar'
L.ShowInOverrideUI = 'Show With Override UI'
L.ShowInPetBattleUI = 'Show With Pet Battle UI'
L.ShowEquippedItemBorders = 'Show Equipped Item Borders'
L.ThemeActionButtons = 'Theme Action Buttons (Requires Reload)'

L.State_HELP = 'Help'
L.State_HARM = 'Harm'
L.State_NOTARGET = 'No Target'
L.State_ALTSHIFT = strjoin('-', ALT_KEY_TEXT, SHIFT_KEY_TEXT)
L.State_CTRLSHIFT = strjoin('-', CTRL_KEY_TEXT, SHIFT_KEY_TEXT)
L.State_CTRLALT = strjoin('-', CTRL_KEY_TEXT, ALT_KEY_TEXT)
L.State_CTRLALTSHIFT = strjoin('-', CTRL_KEY_TEXT, ALT_KEY_TEXT, SHIFT_KEY_TEXT)

--totems
L.ShowTotems = 'Show Totems'
L.ShowTotemRecall = 'Show Recall'

--extra bar
L.ExtraBarShowBlizzardTexture = 'Show Blizzard Texture'

--general settings panel
L.General = 'General'

--profile settings panel
L.CreateProfile = 'Create Profile...'
L.ResetProfile = 'Reset Profile...'
L.CopyProfile = 'Copy Profile...'
L.ConfirmResetProfile = 'Are you sure you want to reset your profile?'
L.ConfirmCopyProfile = 'Copy contents from %s into the current profile?'
L.ConfirmDeleteProfile = 'Delete profile %s?'
