local DOGTAG_MAJOR_VERSION = "LibDogTag-3.0"
local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end
MINOR_VERSION = _G.DogTag_Unit_MINOR_VERSION
_G.DogTag_Unit_MINOR_VERSION = nil

local DogTag_Unit, oldMinor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
local DogTag_Unit_funcs = _G.DogTag_Unit_funcs
_G.DogTag_Unit_funcs = nil
if not DogTag_Unit then
	DogTag_Unit_funcs = nil
	collectgarbage('collect')
	return
end

local DogTag = LibStub:GetLibrary(DOGTAG_MAJOR_VERSION)
if not DogTag then
	error(("Cannot load %s without first loading %s"):format(MAJOR_VERSION, DOGTAG_MAJOR_VERSION))
end

if oldMinor then
	DogTag:ClearNamespace("Unit")
end

local oldLib
if next(DogTag_Unit) ~= nil then
	oldLib = {}
	for k,v in pairs(DogTag_Unit) do
		oldLib[k] = v
		DogTag_Unit[k] = nil
	end
end
DogTag_Unit.oldLib = oldLib

for _,v in ipairs(DogTag_Unit_funcs) do
	v(DogTag_Unit, DogTag)
end
--[[
local function DogTag_Unit_RefreshLibrary(self)
	local oldLib = {}
	for k, v in pairs(DogTag_Unit) do
		oldLib[k] = v
		DogTag_Unit[k] = nil
	end
	DogTag_Unit.oldLib = oldLib
	
	for _,v in ipairs(_G.DogTag_Unit_funcs) do
		v(DogTag_Unit, DogTag)
	end
	
	DogTag_Unit.RefreshLibrary = DogTag_Unit_RefreshLibrary
end
DogTag_Unit.RefreshLibrary = DogTag_Unit_RefreshLibrary

DogTag:AddSubLibrary(MAJOR_VERSION)
]]