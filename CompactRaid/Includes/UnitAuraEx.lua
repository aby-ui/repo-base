--------------------------------------------------------------
-- UnitAuraEx.lua
--
-- A library for continuting the old school UnitAura/UnitBuff/UnitDebuff API's:
--
-- API:
--
-- UnitAuraEx("unit", "aura" [, "filter"])
-- UnitBuffEx("unit", "aura" [, "filter"])
-- UnitDebuffEx("unit", "aura" [, "filter"])

-- Returns:

-- Abin
-- 2018-8-18
--------------------------------------------------------------

local UnitAura = UnitAura
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff

local VERSION = 1.01
if UnitAuraEx_GetVersion and UnitAuraEx_GetVersion() <= VERSION then return end

local function CallOfficalAPI(func, unit, aura, filter)
	if type(aura) ~= "string" then
		return func(unit, aura, filter)
	end

	local i
	for i = 1, 40 do
		local name, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20 = func(unit, i, filter)
		if name == aura then
			return name, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20
		end
	end
end


function UnitAuraEx(unit, aura, filter)
	CallOfficalAPI(UnitAura, unit, aura, filter)
end

function UnitBuffEx(unit, aura, filter)
	CallOfficalAPI(UnitBuff, unit, aura, filter)
end

function UnitDebuffEx(unit, aura, filter)
	CallOfficalAPI(UnitDebuff, unit, aura, filter)
end


function UnitAuraEx_GetVersion()
	return VERSION
end