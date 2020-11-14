-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

function private.NewLib(name)
	if (not private.libs) then
		private.libs = {}
	end

	private.libs[name] = {}
	return private.libs[name]
end

function private.ImportLib(name)
	if (not private.libs or not private.libs[name]) then
		return
	end

	return private.libs[name]
end
