--[[
	OmniCC configuration localization - English
--]]

local L = OMNICC_LOCALS

L.GeneralSettings = "Display"
L.FontSettings = "Text Style"
L.RuleSettings = "Rules"
L.PositionSettings = "Text Position"

L.Font = "Font"
L.FontSize = "Base Font Size"
L.FontOutline = "Font Outline"

L.Outline_NONE = NONE
L.Outline_OUTLINE = "Thin"
L.Outline_THICKOUTLINE = "Thick"
L.Outline_OUTLINEMONOCHROME = "Monochrome"

L.MinDuration = "Minimum duration to display text"
L.MinSize = "Minimum size to display text"
L.ScaleText = "Automatically scale text to fit within frames"
L.EnableText = "Enable cooldown text"

L.Add = "Add"
L.Remove = "Remove"

L.FinishEffect = "Finish Effect"
L.MinEffectDuration = "Minimum duration to display a finish effect"

L.MMSSDuration = "Minimum duration to display text as MM:SS"
L.TenthsDuration = "Minimum duration to display tenths of seconds"

L.ColorAndScale = "Color & Scale"
L.Color_soon = "Soon to expire"
L.Color_seconds = "Under a minute"
L.Color_minutes = "Under an hour"
L.Color_hours = "One hour or more"
L.Color_charging = "Restoring charges"
L.Color_controlled = "Loss of control"

L.SpiralOpacity = "Spiral transparency"
L.UseAniUpdater = "Optimize performance"

--text positioning
L.XOffset = "X Offset"
L.YOffset = "Y Offset"

L.Anchor = 'Anchor'
L.Anchor_LEFT = 'Left'
L.Anchor_CENTER = 'Center'
L.Anchor_RIGHT = 'Right'
L.Anchor_TOPLEFT = 'Top Left'
L.Anchor_TOP = 'Top'
L.Anchor_TOPRIGHT = 'Top Right'
L.Anchor_BOTTOMLEFT = 'Bottom Left'
L.Anchor_BOTTOM = 'Bottom'
L.Anchor_BOTTOMRIGHT = 'Bottom Right'

--groups
L.Groups = 'Groups'
L.Group_base = 'Default'
L.Group_action = 'Actions'
L.Group_aura = 'Auras'
L.Group_pet = 'Pet Actions'
L.AddGroup = 'Add Group...'

--[[ Tooltips ]]--

L.ScaleTextTip =
[[When enabled, this setting will
cause text to shrink to fit within
frames that are too small.]]

L.SpiralOpacityTip =
 [[Sets the opacity of the dark spirals you normally
see on buttons when on cooldown.]]

L.UseAniUpdaterTip =
[[Optimizes CPU performance, but may
cause crashes on some environments.
Disabling this option will solve the issue.]]

L.MinDurationTip =
[[Determines how long a cooldown
must be in order to show text.

This setting is mainly used to
filter out the global cooldown.]]

L.MinSizeTip =
[[Determines how big a frame must be to display text.
The smaller the value, smaller things can be to show text.
The larger the value, the bigger things must be.

Some benchmarks:
100 - The size of an action button
80  - The size of a class or pet action button
55  - The size of a target frame buff]]

L.MinEffectDurationTip =
[[Determines how long a
cooldown must be in order
to show a finish effect
(ex, pulse/shine)]]

L.MMSSDurationTip =
[[Determines the threshold
for showing a cooldown
in a MM:SS format.]]

L.TenthsDurationTip =
[[Determines the threshold
for showing tenths of seconds.]]

L.FontSizeTip =
[[Controls how large text is.]]

L.FontOutlineTip =
[[Controls the thickness of the
outline around text.]]

L.UseBlacklistTip =
[[Click this to toggle using the blacklist.
When enabled, any frame with a name
that matches an item on the blacklist
will not display cooldown text.]]

L.FrameStackTip =
[[Toggles showing the names
of frames when you hover
over them.]]

L.XOffsetTip =
[[Controls the horizontal
offset of text.]]

L.YOffsetTip =
[[Controls the vertical
offset of text.]]