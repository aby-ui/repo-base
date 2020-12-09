local addon_name, addon_env = ...

if not LibStub then return end
local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not ldb then return end

local broker = ldb:NewDataObject(addon_name, {
   type = "data source",
   label = addon_name,
   icon = "Interface\\ICONS\\Achievement_Garrison_Tier01_" .. UnitFactionGroup("player"),
   OnTooltipShow = addon_env.RemoveAllWorkers_TooltipSetText
})
addon_env.broker = broker

addon_env.GarrisonBuilding_UpdateBuildings()
