--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/BattlefieldMinimap.lua - Canvas for Blizzard_BattlefieldMinimap.   *
  ****************************************************************************]]

local FOLDER_NAME, private = ...
local panel = private.Modules.WorldMapTemplate.Embed( _G.CreateFrame( "Frame" ) );

panel.AlphaDefault = 0.8;




--- Attaches the canvas to the zone map when it loads.
function panel:OnLoad ( ... )
	self:SetParent( BattlefieldMinimap );

	return self.super.OnLoad( self, ... );
end




private.Modules.Register( "BattlefieldMinimap", panel,
	private.L.MODULE_BATTLEFIELDMINIMAP,
	"Blizzard_BattlefieldMinimap" );