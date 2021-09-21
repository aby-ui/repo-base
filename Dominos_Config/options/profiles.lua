local _, Addon = ...

local tbl = LibStub("AceDBOptions-3.0"):GetOptionsTable(Addon:GetParent().db, true)
tbl.args.choose.width = "double"
tbl.args.copyfrom.width = "double"
tbl.args.delete.width = "double"
local db = Addon:GetParent().db

local options = LibStub("AceDBOptions-3.0"):GetOptionsTable(db, true)

local LibDualSpec = LibStub("LibDualSpec-1.0", true)

if LibDualSpec then
    LibDualSpec:EnhanceOptions(options, db)
end

Addon:AddOptionsPanelOptions("profiles", options)