do
	local _detalhes = 		_G._detalhes

	local _error = {
		["error"] = true,
		["errortext"] = ""
	}
	_error.__index = _error
	_error.__newindex = function()
		assert (false, "Attempt to modify an read-only object.\nUse object() or object.errortext\n"..debugstack (2, 1 , 0))
		return
	end
	_error.__tostring = function()
		return _error.errortext
	end
	_error.__call = function (_this)
		print (_this.errortext)
	end
	
	function _detalhes:NewError (_msg)
		local this_error = {}
		this_error.errortext = _msg
		setmetatable (this_error, _error)
		return this_error
	end

end
