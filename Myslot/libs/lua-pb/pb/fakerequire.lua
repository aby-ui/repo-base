local adepter = LibStub:NewLibrary("pblua.require", 1)

adepter.require = function(modname)
	if modname == 'bit' then
		return bit
	elseif modname == 'struct' then
		-- TODO
		return {}
	end

	modname = string.gsub(modname, '.*%.', '')
	return LibStub:GetLibrary('pblua.' .. modname)
end
