-- an effect that does nothing
local AddonName, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)

local NoopEffect = Addon.FX:Create("none", L.None)

function NoopEffect:Run()
end
