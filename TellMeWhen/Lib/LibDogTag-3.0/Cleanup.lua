local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = tonumber(("20210410135615"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end
MINOR_VERSION = _G.DogTag_MINOR_VERSION
_G.DogTag_MINOR_VERSION = nil

local DogTag, oldMinor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not DogTag then
	_G.DogTag_funcs = nil
	collectgarbage('collect')
	return
end

local oldLib
if next(DogTag) ~= nil then
	oldLib = {}
	for k,v in pairs(DogTag) do
		oldLib[k] = v
		DogTag[k] = nil
	end
end
DogTag.oldLib = oldLib

for _,v in ipairs(_G.DogTag_funcs) do
	v(DogTag)
end

DogTag.oldLib = nil

_G.DogTag_funcs = nil

collectgarbage('collect')