_G.OMNICC_LOCALS = {} -- should be done in the US locale file, only

local L = _G.OMNICC_LOCALS

-- timer formats
L.TenthsFormat = "%0.1f"
L.SecondsFormat = "%d"
L.MMSSFormat = "%d:%02d"
L.MinuteFormat = "%dm"
L.HourFormat = "%dh"
L.DayFormat = "%dd"

-- effect names
L.None = NONE
L.Pulse = "Pulse"
L.Shine = "Shine"
L.Alert = "Alert"
L.Activate = "Activate"
L.Flare = "Flare"

-- effect tooltips
L.ActivateTip = [[Applies the ability triggering effect to the cooldown icon.]]
L.AlertTip = [[Pulses the finished cooldown icon
at the center of the screen.]]
L.PulseTip = [[Pulses the cooldown icon.]]

-- other
L.ConfigMissing = "%s could not be loaded because the addon is %s"
L.Version = "You are using |cffFCF75EOmniCC Version (%s)|r"
