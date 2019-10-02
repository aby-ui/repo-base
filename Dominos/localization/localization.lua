--[[
	Localization.lua
		Translations for Dominos

	English: Default language
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos', 'enUS', true)

--system messages
L.NewPlayer = 'Created new profile for %s'
L.Updated = 'Updated to v%s'

--profiles
L.ProfileCreated = 'Created new profile "%s"'
L.ProfileLoaded = 'Set profile to "%s"'
L.ProfileDeleted = 'Deleted profile "%s"'
L.ProfileCopied = 'Copied settings from "%s"'
L.ProfileReset = 'Reset profile "%s"'
L.CantDeleteCurrentProfile = 'Cannot delete the current profile'
L.InvalidProfile = 'Invalid profile "%s"'

--slash command help
L.ShowOptionsDesc = 'Shows the options menu'
L.ConfigDesc = 'Toggles configuration mode'

L.SetScaleDesc = 'Sets the scale of <frameList>'
L.SetAlphaDesc = 'Sets the opacity of <frameList>'
L.SetFadeDesc = 'Sets the faded opacity of <frameList>'

L.SetColsDesc = 'Sets the number of columns for <frameList>'
L.SetPadDesc = 'Sets the padding level for <frameList>'
L.SetSpacingDesc = 'Sets the spacing level for <frameList>'

L.ShowFramesDesc = 'Shows the given <frameList>'
L.HideFramesDesc = 'Hides the given <frameList>'
L.ToggleFramesDesc = 'Toggles the given <frameList>'

--slash commands for profiles
L.SetDesc = 'Switches settings to <profile>'
L.SaveDesc = 'Saves current settings and switches to <profile>'
L.CopyDesc = 'Copies settings from <profile>'
L.DeleteDesc = 'Deletes <profile>'
L.ResetDesc = 'Returns to default settings'
L.ListDesc = 'Lists all profiles'
L.AvailableProfiles = 'Available Profiles'
L.PrintVersionDesc = 'Prints the current version'

--dragFrame tooltips
L.ShowConfig = 'Right Click to configure'
L.HideBar = 'Middle Click or Shift-Right Click to hide'
L.ShowBar = 'Middle Click or Shift-Right Click to show'
L.SetAlpha = 'Mousewheel to set opacity (|cffffffff%d|r)'

--minimap button stuff
L.ConfigEnterTip = 'Left Click to enter configuration mode'
L.ConfigExitTip = 'Left Click to exit configuration mode'
L.BindingEnterTip = 'Shift-Left Click to enter binding mode'
L.BindingExitTip = 'Shift-Left Click to exit binding mode'
L.ShowOptionsTip = 'Right Click to show the options menu'

--helper dialog stuff
L.ConfigMode = 'Configuration Mode'
L.ConfigModeExit = 'Exit Config Mode'
L.ConfigModeHelp = 'Drag any bar to move it. Right Click to configure. Middle Click or Shift-Right Click to toggle visibility.'

--bar tooltips
L.TipRollBar = 'Displays frames for rolling on items, when in a group.'
L.TipVehicleBar = [[
Displays controls to aim and exit a vehicle.
All other vehicle actions are displayed on the possess bar.]]

L.BarDisplayName = "%s Bar"
L.ActionBarDisplayName = "Action Bar %s"