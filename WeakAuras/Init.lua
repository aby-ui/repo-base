WeakAuras = {}
WeakAuras.L = {}

WeakAuras.normalWidth = 1.25
WeakAuras.halfWidth = WeakAuras.normalWidth / 2
WeakAuras.doubleWidth = WeakAuras.normalWidth * 2

local versionStringFromToc = GetAddOnMetadata("WeakAuras", "Version")
local versionString = "2.13.1"
local buildTime = "20190626033040"

--[===[@debug@
if versionStringFromToc == "2.13.1" then
  versionStringFromToc = "Dev"
  buildTime = "Dev"
end
--@end-debug@]===]

WeakAuras.versionString = versionStringFromToc
WeakAuras.buildTime = buildTime
WeakAuras.printPrefix = "|cff9900ffWeakAuras:|r "
WeakAuras.newFeatureString = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t"

WeakAuras.prettyPrint = function(msg)
  print(WeakAuras.printPrefix .. msg)
end

WeakAuras.versionMismatchPrint = function()
  WeakAuras.prettyPrint("You need to restart your game client to complete the WeakAuras update!")
end

if versionString ~= versionStringFromToc and versionStringFromToc ~= "Dev" then
  C_Timer.After(1, WeakAuras.versionMismatchPrint)
end

WeakAuras.PowerAurasPath = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\"
WeakAuras.PowerAurasSoundPath = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\"

-- force enable WeakAurasCompanion because some addon managers interfere with it
EnableAddOn("WeakAurasCompanion")

--These function stubs are defined here to reduce the number of errors that occur if WeakAuras.lua fails to compile
function WeakAuras.RegisterRegionType()
end

function WeakAuras.RegisterRegionOptions()
end

function WeakAuras.StartProfileSystem()
end

function WeakAuras.StartProfileAura()
end

function WeakAuras.StopProfileSystem()
end

function WeakAuras.StopProfileAura()
end
