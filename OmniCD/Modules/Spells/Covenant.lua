local E = select(2, ...):unpack()

local covenant_db = {
	["DEATHKNIGHT"] = {

		{ spellID = 324128, duration = {[250]=15,default=30}, type = "covenant", spec = 321077, parent = 43265, talent = 152280 },
		{ spellID = 312202, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 311648, duration = 60, type = "covenant", spec = 321079 },
	},
	["DEMONHUNTER"] = {

		{ spellID = 329554, duration = 120, type = "covenant", spec = 321078 },
		{ spellID = 317009, duration = 45, type = "covenant", spec = 321079 },

	},
	["DRUID"] = {


		{ spellID = 338142, duration = 60, type = "covenant", spec = 321076 },
		--[[ Merged
		{ spellID = 338035, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 338018, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 326462, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 326446, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 326647, duration = 60, type = "covenant", spec = 321076 },

		{ spellID = 326434, duration = 0, type = "covenant", spec = 321076 },
		{ spellID = 327022, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 327037, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 327071, duration = 60, type = "covenant", spec = 321076 },
		]]
		{ spellID = 323546, duration = 180, type = "covenant", spec = 321079 },
	},
	["HUNTER"] = {

		{ spellID = 324149, duration = 30, type = "covenant", spec = 321079 },
		{ spellID = 308491, duration = 60, type = "covenant", spec = 321076 },
		{ spellID = 328231, duration = 120, type = "covenant", spec = 321077 },
	},
	["MAGE"] = {
		{ spellID = 324220, duration = 180, type = "covenant", spec = 321078 },
		{ spellID = 314793, duration = 90, type = "covenant", spec = 321079 },


	},
	["MONK"] = {
		{ spellID = 325216, duration = 60, type = "covenant", spec = 321078 },

		{ spellID = 326860, duration = 180, type = "covenant", spec = 321079 },

	},
	["PALADIN"] = {
		{ spellID = 316958, duration = 240, type = "covenant", spec = 321079 },

		--[[ Merged
		{ spellID = 328622, duration = 45, type = "covenant", spec = 321077 },
		{ spellID = 328282, duration = 45, type = "covenant", spec = 321077 },
		{ spellID = 328620, duration = 45, type = "covenant", spec = 321077 },
		{ spellID = 328281, duration = 45, type = "covenant", spec = 321077 },
		]]

		{ spellID = 328204, duration = 30, type = "covenant", spec = 321078 },
	},
	["PRIEST"] = {
		{ spellID = 325013, duration = 180, type = "covenant", spec = 321076 },
		{ spellID = 327661, duration = 90, type = "covenant", spec = 321077 },

		{ spellID = 324724, duration = 60, type = "covenant", spec = 321078 },
	},
	["ROGUE"] = {




	},
	["SHAMAN"] = {
		{ spellID = 320674, duration = 90, type = "covenant", spec = 321079 },
		{ spellID = 328923, duration = 120, type = "covenant", spec = 321077 },

		{ spellID = 324386, duration = 60, type = "covenant", spec = 321076 },
	},
	["WARLOCK"] = {
		{ spellID = 325289, duration = 45, type = "covenant", spec = 321078, },
		{ spellID = 321792, duration = 60, type = "covenant", spec = 321079, },
		{ spellID = 312321, duration = 40, type = "covenant", spec = 321076, },

	},
	["WARRIOR"] = {
		{ spellID = 325886, duration = 90, type = "covenant", spec = 321077 },
		{ spellID = 317483, duration = {[72]=6,default=1}, type = "covenant", spec = 321079, parent = 5308 },
		{ spellID = 324143, duration = 120, type = "covenant", spec = 321078 },

	},
	["EVOKER"] = {
		{ spellID = 387168, duration = 120, type = "covenant", spec = {321078,321079,321076,321077} },
	},
	["COVENANT"] = {
		{ spellID = 300728, duration = 60, type = "covenant", spec = 321079 },
		{ spellID = 324631, duration = 120, type = "covenant", spec = 321078, buff = 324867 },
		{ spellID = 323436, duration = 180, type = "covenant", spec = 321076 },
		{ spellID = 310143, duration = 90, type = "covenant", spec = 321077 },
		{ spellID = 324739, duration = 300, type = "covenant", spec = 321076 },
		{ spellID = 319217, duration = 600, type = "covenant", spec = 319217, buff = 320224 },
	},
}

for class, t in pairs(covenant_db) do
	local c = E.spell_db[class]
	if c then
		for i = 1, #t do
			c[#c+1] = t[i]
		end
	else
		E.spell_db[class] = t
	end
end
