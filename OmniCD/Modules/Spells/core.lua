local E, L, C = select(2, ...):unpack()

E.spell_highlighted = {}
E.spell_modifiers = {}

E.spell_marked = {
	[48707]  = 205727,  -- Anti-Magic Barrier
	[287250] = true,    -- Dead of Winter
	[51052]  = 328718,  -- Dome of Ancient Shadow
	[198589] = 205411,  -- Desperate Instincts
	[196718] = 227635,  -- Cover of Darkness
	[217832] = 205596,  -- Detainment
	[187650] = 203340,  -- Diamond Ice
	[122470] = 280195,  -- Good Karma
	[228049] = true,    -- Guardian of the Forgotten Queen
	[199452] = true,    -- Ultimate Sacrifice
	[62618]  = 197590,  -- Dome of Light
	[88625]  = 200199,  -- Censure
	[213602] = true,    -- Greater Fade
	[1966]   = 79008,   -- Elusiveness
	[79206]  = 290254,  -- Ancestral Gift
	--[[
	[190784] = 199542,  -- Steed of Glory
	[23920]  = 213915,  -- Rebound
	[5246]   = 275338,  -- Menace
	[199086] = true,    -- Warpath
	--]]
}
