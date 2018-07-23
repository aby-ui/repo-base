--Phanx localization code @ phanx.net

local _, namespace = ...
namespace.locale = GetLocale()
--print("at core",namespace.locale)
local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

namespace.L = L
