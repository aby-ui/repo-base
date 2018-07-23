
function hidetab(flag)
	if flag then 
		local __index; 
		for __index = 1, U1BAR_MAX_BARS, 1 do
			local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = _G["MOGUBarFrame"..__index.."Tab"]
			if ( MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a ) then 
			MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:Hide(); 
			end 
		end 
	else
		for __index = 1, U1BAR_MAX_BARS, 1 do
			local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = _G["MOGUBarFrame"..__index.."Tab"] 
			if ( MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a ) then
				MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:Show(); 
			end 
		end 
	end
end
function hideall(flag)
	if flag then 
		local __index; 
		for __index = 1, U1BAR_MAX_BARS, 1 do
			local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = _G["MOGUBarFrame"..__index]
			if ( MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a ) then 
			MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:Hide(); 
			end 
		end 
	else
		for __index = 1, U1BAR_MAX_BARS, 1 do
			local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = _G["MOGUBarFrame"..__index] 
			if ( MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a ) then
				MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:Show(); 
			end 
		end 
	end
end
