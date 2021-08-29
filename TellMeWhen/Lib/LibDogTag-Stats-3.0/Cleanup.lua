local DOGTAG_MAJOR_VERSION = "LibDogTag-3.0"
local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end
MINOR_VERSION = _G.DogTag_Stats_MINOR_VERSION
_G.DogTag_Stats_MINOR_VERSION = nil

local DogTag_Stats, oldMinor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
local DogTag_Stats_funcs = _G.DogTag_Stats_funcs
_G.DogTag_Stats_funcs = nil
if not DogTag_Stats then
	DogTag_Stats_funcs = nil
	collectgarbage('collect')
	return
end

local DogTag = LibStub:GetLibrary(DOGTAG_MAJOR_VERSION)
if not DogTag then
	error(("Cannot load %s without first loading %s"):format(MAJOR_VERSION, DOGTAG_MAJOR_VERSION))
end

if oldMinor then
	DogTag:ClearNamespace("Stats")
end

local oldLib
if next(DogTag_Stats) ~= nil then
	oldLib = {}
	for k,v in pairs(DogTag_Stats) do
		oldLib[k] = v
		DogTag_Stats[k] = nil
	end
end
DogTag_Stats.oldLib = oldLib

for _,v in ipairs(DogTag_Stats_funcs) do
	v(DogTag_Stats, DogTag)
end
