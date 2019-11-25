local AddonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "enUS", true)

-- timer formats
L.DayFormat = "%dd"
L.HourFormat = "%dh"
L.MinuteFormat = "%dm"
L.MMSSFormat = "%d:%02d"
L.SecondsFormat = "%d"
L.TenthsFormat = "%0.1f"

-- effect names
L.Activate = "Activate"
L.Alert = "Alert"
L.Flare = "Flare"
L.None = NONE
L.Pulse = "Pulse"
L.Shine = "Shine"

-- effect tooltips
L.ActivateTip = [[Applies the ability triggering effect to the cooldown icon.]]
L.AlertTip = [[Pulses the finished cooldown icon at the center of the screen.]]
L.PulseTip = [[Pulses the cooldown icon.]]

-- other
L.ConfigMissing = "%s could not be loaded because the addon is %s"
L.Version = "You are using |cffFCF75EOmniCC Version (%s)|r"
