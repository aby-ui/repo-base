--[[
	none.lua
		no effect
--]]

local L = OMNICC_LOCALS
local noFunc = function() end

OmniCC:RegisterEffect {
	name = L.None,
	id = 'none',
	
	Run = noFunc,
	Setup = noFunc
}