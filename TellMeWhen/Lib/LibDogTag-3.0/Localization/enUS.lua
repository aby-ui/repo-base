local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

_G.DogTag_MINOR_VERSION = MINOR_VERSION

_G.DogTag_funcs = {}

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

DogTag.L = {
	["DogTag Help"] = "DogTag Help",
	["True"] = "True",
}
for k,v in pairs(DogTag.L) do
	if type(v) ~= "string" then -- some evil addon messed it up
		DogTag.L[k] = k
	end
end
setmetatable(DogTag.L, {__index = function(self, key)
--	local _, ret = pcall(error, ("Error indexing L[%q]"):format(tostring(key)), 2)
--	geterrorhandler()(ret)
	self[key] = key
	return key
end})

end