local _, Addon = ...

local tbl = LibStub("AceDBOptions-3.0"):GetOptionsTable(Addon:GetParent().db, true)
tbl.args.choose.width = "double"
tbl.args.copyfrom.width = "double"
tbl.args.delete.width = "double"
Addon:AddOptionsPanelOptions(
    "profiles",
    _G.LibStub("AceDBOptions-3.0"):GetOptionsTable(Addon:GetParent().db, true)
)
