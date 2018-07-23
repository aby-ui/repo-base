--------------------------------------------------------------------------
-- GTFO_PowerAuras.lua 
--------------------------------------------------------------------------
--[[
GTFO & Power Auras Integration
Author: Zensunim of Malygos, Smacker

Change Log:
	v2.1
		- Added Power Auras Integration
	v4.7
		- Updated Power Auras Integration function
	v4.10
		- Added Power Auras 5.0 Integration

]]--

GTFO_PowerAuras = {"GTFOHigh", "GTFOLow", "GTFOFail", "GTFOFriendlyFire"};
function GTFO_DisplayAura_PowerAuras(iType)
	local PowaAurasEnabled
	if (PowaAuras_GlobalTrigger) then
		PowaAurasEnabled = PowaAuras_GlobalTrigger()
	end
	if (not PowaAuras) and (not PowaAurasEnabled) then return; end
	local auraType = GTFO_PowerAuras[iType];
	if (not auraType) then return; end

	GTFO.ShowAlert = true;
	
	if (PowaAuras and PowaAuras.MarkAuras) then
		-- PowerAuras 5.x
		PowaAuras:MarkAuras(auraType);
	elseif (PowaAurasEnabled) then
		-- PowerAuras 4.24.2+
		PowaAuras_GlobalTrigger(auraType);
	elseif (PowaAuras and PowaAuras.AurasByType[auraType]) then 
		-- Old and depeciated (for V4.x of PowerAuras)
		for index, auraid in ipairs(PowaAuras.AurasByType[auraType]) do
			if (PowaAuras.Auras[auraid]:ShouldShow()) then
				local shouldShow, reason = PowaAuras:CheckMultiple(PowaAuras.Auras[auraid], "", nil);
				if (shouldShow) then
					--GTFO_DebugPrint("Displaying "..tostring(auraType).." Power Aura #"..tostring(auraid));
					PowaAuras:DisplayAura(auraid);
					if (PowaAuras.Auras[auraid].timerduration == 0) then
						PowaAuras.Auras[auraid].HideRequest = true;
					end
				end   
			end
		end
	end
	
	GTFO.ShowAlert = nil;
end
