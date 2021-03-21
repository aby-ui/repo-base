local E, L, C = select(2, ...):unpack()

local P = E["Party"]

local priority = {
	name = L["Priority"],
	order = 50,
	type = "group",
	get = function(info) return E.DB.profile.Party[info[2]].priority[info[#info]] end,
	set = function(info, value) E.DB.profile.Party[info[2]].priority[info[#info]] = value P:ConfigBars(info[2], "priority") end,
	args = {
		desc = {
			name = L["Set the prioirty of spell types for sorting."], order = 0, type = "description",
		}
	},
}

for k, v in pairs(E.L_PRIORITY) do
	priority.args[k] = {
		name = v,
		order = 30 - C.Party.arena.priority[k],
		--width = "double",
		type = "range",
		min = 1, max = 20, step = 1,
		--descStyle = "inline",
	}
end

function P:AddPriorityOption(key)
	P.options.args[key].args.priority = priority
end
