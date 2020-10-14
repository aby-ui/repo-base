--File Revision: 1
--Last Modification: 19/04/2014
--Change Log:
	-- 19/04/2014: File Created.
--Description:
	-- this file maintain the main function for row animations
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = 		_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> basic functions

	_detalhes.current_row_animation = ""
	_detalhes.row_animation_pool = {}
	
	function _detalhes:InstallRowAnimation (name, desc, func, options)
		
		if (not name) then
			return false
		elseif (not func) then
			return false
		end
		
		if (not desc) then
			desc = ""
		end
		
		tinsert (_detalhes.row_animation_pool, {name = name, desc = desc, func = func, options = options})
		return true
		
	end
	
	function _detalhes:SelectRowAnimation (name)
		for key, value in ipairs (_detalhes.row_animation_pool) do 
			if (value.name == name) then
				_detalhes.current_row_animation = name
				return true
			end
		end
		return false
	end
	
	function _detalhes:GetRowAnimationList()
		local t = {}
			for key, value in ipairs (_detalhes.row_animation_pool) do 
				tinsert (t, value.name)
			end
		return t
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> install default animations
	
	do
		local fade_func = function (row, state) 
			if (state) then
				_detalhes.gump:Fade (row, "out")
			else
				_detalhes.gump:Fade (row, "in")
			end
		end
		local fade_desc = "Default animation, makes the bar fade in or fade out when showing or hiding in the window"
		_detalhes:InstallRowAnimation ("Fade", fade_desc , fade_func, nil)
		
		_detalhes:SelectRowAnimation ("Fade")
	end
	
	
