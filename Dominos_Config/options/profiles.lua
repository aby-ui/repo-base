local _, Addon = ...

local db = Addon:GetParent().db

local options = LibStub("AceDBOptions-3.0"):GetOptionsTable(db, true)
options.args.choose.width = "double"
options.args.copyfrom.width = "double"
options.args.delete.width = "double"

local LibDualSpec = LibStub("LibDualSpec-1.0", true)

if LibDualSpec then
    LibDualSpec:EnhanceOptions(options, db)
    options.plugins["LibDualSpec-1.0"].choose.width = "double"
end

Addon:AddOptionsPanelOptions("profiles", options)