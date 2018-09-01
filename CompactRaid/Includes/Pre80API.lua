--------------------------------------------------------------
-- Pre80API.lua
--
-- A library for continuting some old school API pre 8.0

-- Abin
-- 2018-8-24
--------------------------------------------------------------

local UnitAura = UnitAura
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitPosition = UnitPosition
local ipairs = ipairs
local tinsert = tinsert
local unpack = unpack

local LIBNAME = "Pre80API"
local VERSION = 1.03

local lib = _G[LIBNAME]
if lib and lib.version >= VERSION then return end

if not lib then
	lib = {}
end

_G[LIBNAME] = lib
_G["Pre80API"] = lib

lib.version = VERSION

local function CallOfficalAPI(func, unit, aura, filter)
	if type(aura) ~= "string" then
		return func(unit, aura, filter)
	end

	local i
	for i = 1, 40 do
		local name, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20 = func(unit, i, filter)
		if not name then
			return
		end

		if name == aura then
			return name, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20
		end
	end
end


function lib.UnitAura(unit, aura, filter)
	return CallOfficalAPI(UnitAura, unit, aura, filter)
end

function lib.UnitBuff(unit, aura, filter)
	return CallOfficalAPI(UnitBuff, unit, aura, filter)
end

function lib.UnitDebuff(unit, aura, filter)
	return CallOfficalAPI(UnitDebuff, unit, aura, filter)
end

function lib.GetCurrentMapAreaID()
	local _, _, _, id = UnitPosition("player")
	return id
end

---------------------------------------------------
-- 13: 东部王国
-- 12: 卡利姆多
-- 101: 外域
-- 113: 诺森德
-- 424: 潘达利亚
-- 572: 德拉诺
-- 619: 破碎群岛
-- 876: 库尔提拉斯
---------------------------------------------------
local CONTINENT_IDS = { 12, 13, 101, 113, 424, 572, 619, 876 }
function lib.GetMapContinents()
	local result = {}
	local _, id
	for _, id in ipairs(CONTINENT_IDS) do
		local info = C_Map.GetMapInfo(id)
		if info then
			tinsert(result, info.name)
		end
	end
	return unpack(result)
end

function lib.GetCurrentMapContinent()
	local mapID = C_Map.GetBestMapForUnit("player")
	local info = MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true)
	if info then
		return info.mapID, info.name
	end
end