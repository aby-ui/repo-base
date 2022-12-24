--------------------------------------------------------------------------
-- GTFO_FF_DF.lua 
--------------------------------------------------------------------------
--[[
GTFO Friendly Fire List - Dragonflight
]]--

if (not (GTFO.ClassicMode or GTFO.BurningCrusadeMode or GTFO.WrathMode)) then

-- ****************
-- * Dragon Isles *
-- ****************

--- *********************
--- * Algeth'ar Academy *
--- *********************

GTFO.FFSpellID["387848"] = {
  --desc = "Astral Nova (Spectral Invoker)";
  sound = 4;
  ignoreSelfInflicted = true;
};

GTFO.FFSpellID["395278"] = {
  --desc = "Electric Surge";
  sound = 4;
  ignoreSelfInflicted = true;
};

end
