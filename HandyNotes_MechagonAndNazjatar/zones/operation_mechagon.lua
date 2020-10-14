-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale
local Class = ns.Class
local Group = ns.Group
local Map = ns.Map
local Node = ns.node.Node

-------------------------------------------------------------------------------

ns.groups.MECH_BUFF = Group('mech_buffs')

-------------------------------------------------------------------------------

local map = Map({ id=1490, settings=true })
local nodes = map.nodes

-------------------------------------------------------------------------------
---------------------------------- BUFF BOTS ----------------------------------
-------------------------------------------------------------------------------

local Buff = Class('Buff', Node, {group=ns.groups.MECH_BUFF, scale=0.75})
local GREASE = Buff({icon=252178, label=L["grease_bot"], note=L["grease_bot_note"]})
local SHOCK = Buff({icon=136099, label=L["shock_bot"], note=L["shock_bot_note"]})
local WELDING = Buff({icon=134952, label=L["welding_bot"], note=L["welding_bot_note"]})

nodes[56702140] = GREASE
nodes[59103300] = GREASE
nodes[59103370] = GREASE
nodes[59805120] = GREASE
nodes[60004900] = GREASE
nodes[60803750] = GREASE
nodes[61505700] = GREASE
nodes[63204120] = GREASE
nodes[64005760] = GREASE
nodes[65003320] = GREASE
nodes[66002610] = GREASE
nodes[66305250] = GREASE
nodes[67404260] = GREASE
nodes[74205870] = GREASE
nodes[75306170] = GREASE
nodes[78805700] = GREASE

nodes[56203660] = SHOCK
nodes[60804320] = SHOCK
nodes[60804770] = SHOCK
nodes[63405760] = SHOCK
nodes[63503410] = SHOCK
nodes[63603890] = SHOCK
nodes[63903090] = SHOCK
nodes[64402440] = SHOCK
nodes[65506330] = SHOCK
nodes[67105480] = SHOCK
nodes[66904020] = SHOCK
nodes[69205780] = SHOCK
nodes[70304560] = SHOCK
nodes[73505120] = SHOCK
nodes[74305760] = SHOCK

nodes[55803660] = WELDING
nodes[57902130] = WELDING
nodes[58805320] = WELDING
nodes[58905080] = WELDING
nodes[60804190] = WELDING
nodes[61203710] = WELDING
nodes[61302930] = WELDING
nodes[61804750] = WELDING
nodes[63404180] = WELDING
nodes[63705830] = WELDING
nodes[65403820] = WELDING
nodes[66104490] = WELDING
nodes[68005440] = WELDING
nodes[69405270] = WELDING
nodes[71906280] = WELDING
nodes[76005440] = WELDING

--nodes[67305350] = Clone(GREASE, {note=L["grease_bot_note"]..'\n'..L["cave_spawn"]})
--nodes[66905350] = Clone(SHOCK, {note=L["shock_bot_note"]..'\n'..L["cave_spawn"]})
--nodes[65605560] = Clone(WELDING, {note=L["welding_bot_note"]..'\n'..L["cave_spawn"]})
--nodes[69005310] = Clone(WELDING, {note=L["welding_bot_note"]..'\n'..L["cave_spawn"]})
