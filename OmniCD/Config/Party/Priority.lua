local E, L, C = select(2, ...):unpack()
local P = E.Party

local priority = {
	name = L["Priority"],
	order = 50,
	type = "group",
	get = function(info) return E.profile.Party[ info[2] ].priority[ info[#info] ] end,
	set = function(info, value) E.profile.Party[ info[2] ].priority[ info[#info] ] = value P:ConfigBars(info[2], "priority") end,
	args = {
		desc = {
			name = format("|TInterface\\FriendsFrame\\InformationIcon:14:14:0:0|t %s\n\n", L["Set the priority of spell types for sorting."]), order = 0, type = "description",
		},
	},
}

for k, v in pairs(E.L_PRIORITY) do
	priority.args[k] = {
		name = v,
		order = 30 - C.Party.arena.priority[k],
		type = "range",
		min = 0, max = 20, step = 1,
	}
end

P:RegisterSubcategory("priority", priority)
