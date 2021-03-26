-------------------------------------------------------------------------------
-- Dominos Config Localization
-- English (Default)
-------------------------------------------------------------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Dominos-Config", "enUS", true)

L.ActionBarBehavior = "Action Bar Behavior"
L.ActionBarNumber = "Action Bar %d"
L.ActionButtonLookAndFeel = "Action Button Look & Feel"
L.Advanced = "Advanced"
L.BagBarShowBags = "Show Bag Slots"
L.BagBarShowKeyRing = "Show Keyring"
L.Bar = "Bar %d"
L.BarSettings = "%s Settings"
L.Buttons = "Buttons"
L.ClickThrough = "Enable Click Through"
L.Columns = "Columns"
L.CommandKey = 'Command Key'
L.ConfirmCopyProfile = "Copy contents from %s into the current profile?"
L.ConfirmDeleteProfile = "Delete profile %s?"
L.ConfirmResetProfile = "Are you sure you want to reset your profile?"
L.Copy = "Copy"
L.CopyProfile = "Copy Profile..."
L.CreateProfile = "Create Profile..."
L.Delay = "Delay (sec)"
L.Delete = _G.DELETE
L.DisableMenuButtons = "Disable Buttons"
L.Duration = "Duration (sec)"
L.EnterBindingMode = "Bind Keys..."
L.EnterConfigMode = "Configure Bars..."
L.EnterName = "Enter Name"
L.ExtraBarShowBlizzardTexture = "Show Blizzard Texture"
L.FadedOpacity = "Faded Opacity"
L.FadeIn = "Fade In"
L.FadeOut = "Fade Out"
L.Fading = "Fading"
L.FrameStrata = "Frame Strata"
L.FrameStrata_BACKGROUND = BACKGROUND
L.FrameStrata_LOW = LOW
L.FrameStrata_MEDIUM = "Medium"
L.FrameStrata_HIGH = HIGH
L.FrameLevel = "Frame Level"
L.General = "General"
L.Layout = "Layout"
L.LeftToRight = "Layout Buttons From Left to Right"
L.LinkedOpacity = "Docked bars inherit opacity"
L.LockActionButtons = "Lock Action Button Positions"
L.MetaKey = 'Meta Key'
L.Modifiers = "Modifiers"
L.None = _G.NONE
L.OneBag = "One Bag"
L.Opacity = _G.OPACITY
L.OutOfCombat = "Out of Combat"
L.Padding = "Padding"
L.Paging = "Paging"
L.PossessBar = "Override Bar"
L.PossessBarDesc = "What action bar to display special actions on when possessing an enemy and in certain encounters"
L.Profiles = "Profiles"
L.ProfilesPanelDesc = "Allows you to manage saved Dominos layouts"
L.QuickMoveKey = "Quick Move Key"
L.QuickPaging = "Quick Paging"
L.RCUFocus = _G.FOCUS
L.RCUPlayer = "Self"
L.RCUToT = "Target of Target"
L.ResetProfile = "Reset Profile..."
L.RightClickUnit = "Right Click Target"
L.Save = _G.SAVE
L.Scale = "Scale"
L.SelfcastKey = "Selfcast Key"
L.Set = "Set"
L.ShowBindingText = "Show Binding Text"
L.ShowCountText = "Show Count Text"
L.ShowEmptyButtons = "Show Empty Buttons"
L.ShowEquippedItemBorders = "Show Equipped Item Borders"
L.ShowInOverrideUI = "Show With Override UI"
L.ShowInPetBattleUI = "Show With Pet Battle UI"
L.ShowKeyring = "Show Keyring"
L.ShowMacroText = "Show Macro Text"
L.ShowMinimapButton = "Show Minimap Button"
L.ShowOverrideUI = "Use Blizzard Override Action Bar"
L.ShowOverrideUIDesc = "Display the Blizzard override UI when piloting a vehicle, and other situations"
L.ShowStates = "Show States"
L.ShowTooltips = "Show Tooltips"
L.ShowTooltipsCombat = "Show Tooltips in Combat"
L.Size = "Size"
L.Spacing = "Spacing"
L.State_HARM = "Harm"
L.State_HELP = "Help"
L.State_NOTARGET = "No Target"
L.State_SHIELD = "Shield Equipped"
L.StickyBars = "Sticky Bars"
L.Targeting = "Targeting"
L.ThemeActionButtons = "Theme Action Buttons (Requires Reload)"
L.ThemeActionButtonsDesc = "Applies some custom style adjustments to action buttons when enabled, and leave them untouched when not"
L.TopToBottom = "Layout Buttons From Top to Bottom"
L.Visibility = "Visibility"

-- derived translations
L.State_ALTSHIFT = strjoin("-", ALT_KEY_TEXT, SHIFT_KEY_TEXT)
L.State_CTRLALT = strjoin("-", CTRL_KEY_TEXT, ALT_KEY_TEXT)
L.State_CTRLALTSHIFT = strjoin("-", CTRL_KEY_TEXT, ALT_KEY_TEXT, SHIFT_KEY_TEXT)
L.State_CTRLSHIFT = strjoin("-", CTRL_KEY_TEXT, SHIFT_KEY_TEXT)

if IsMacClient() then
    L.State_META = 'CMD Key'
else
    L.State_META = 'Meta Key'
end
