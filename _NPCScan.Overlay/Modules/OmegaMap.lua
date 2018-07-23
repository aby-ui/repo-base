--[[****************************************************************************
  * _NPCScanner by SLOKnightfall, a branch of _NPCScan.Overlay by Saiket       *
  * Modules/OmegaMap.lua - Canvas for the OmegaMap   addon.                    *
  ****************************************************************************]]

local private = select( 2, ... )
local panel = private.Modules.WorldMapTemplate.Embed( CreateFrame( "Frame", "NPCScanOmegaMapOverlay" ) )
panel.AlphaDefault = 0.8

private.Modules.Register( "OmegaMap", panel, private.L.MODULE_OMEGAMAP, "OmegaMap" )