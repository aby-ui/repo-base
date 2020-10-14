

-- @windowN: number a a window to open the player details breakdown
-- /run Details:OpenPlayerDetails(windowN)
function Details:OpenPlayerDetails(window)
	window = window or 1
	local instance = Details:GetInstance (window)
	if (instance) then
		local display, subDisplay = instance:GetDisplay()
		if (display == 1) then
			instance:AbreJanelaInfo (Details:GetPlayer (false, 1))
		elseif (display == 2) then
			instance:AbreJanelaInfo (Details:GetPlayer (false, 2))
		end
	end
end