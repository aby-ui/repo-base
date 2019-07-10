--------------------------------------------------------------------------
-- GTFO_WeakAuras.lua 
--------------------------------------------------------------------------
--[[
GTFO & WeakAuras Integration
Author: Zensunim of Malygos
]]--

function GTFO_DisplayAura_WeakAuras(iType)
  if (WeakAuras and WeakAuras.ScanEvents) then
    WeakAuras.ScanEvents("GTFO_DISPLAY", iType);
  end
end
