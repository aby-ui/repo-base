--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/Carbonite.lua - Modifies the WorldMap and Minimap modules for      *
  *   compatibility with Carbonite.                                            *
  ****************************************************************************]]


if ( not IsAddOnLoaded( "Carbonite" ) ) then
	return;
end


local CarboniteVersion = GetAddOnMetadata("Carbonite", "Version"):match("^([%d.]+)");
	--_NPCScanOverlayKey:SetMovable(false)
	--_NPCScanOverlayKey:SetScript("OnMouseDown",nil )
	--_NPCScanOverlayKey:SetScript("OnMouseUp", nil )
local FOLDER_NAME, private = ...
L = private.L

local function OverlayToggle()
	private.WorldMapPaths_ToggleOnClick()
end

local function KeyToggle()
	private.WorldMapKey_ToggleOnClick()
	local texture
	if private.Options.ShowKey then
		texture= private.KeyToggleIconTexture_Enabled
	else
		texture= private.KeyToggleIconTexture_Disabled
	end
	_NPCScanKeyToggle.KeyNormal:SetTexture(texture)
end


local WorldMap = private.Modules.List[ "WorldMap" ];
if ( not ( WorldMap and WorldMap.Registered ) ) then
	return;
end

local CarboniteMap 
local panel = CreateFrame( "Frame", nil, WorldMap );
private.Modules.Carbonite = panel;


--- Repositions the canvas as the Carbonite map moves.
function panel:OnUpdate ()
	CarboniteMap:ClipZoneFrm( CarboniteMap.Cont, CarboniteMap.Zone, WorldMap );
	WorldMap.RangeRing.Child:SetScale( WorldMap:GetScale() ); -- CarboniteMap:CZF also sets point		
	--WorldMap.KeyParent:SetAlpha( CarboniteMap.BackgndAlpha ); -- Obey window's "Fade Out" setting				
	WorldMap.KeyParent:SetAlpha( NxMap1.NxWin.BackgndFade ); -- Obey window's "Fade Out" setting
	WorldMap.KeyParent:SetScale( NxMap1:GetEffectiveScale() )
	WorldMap.KeyParent:SetFrameStrata("High");
end




--- Adjusts the canvas when leaving Carbonite mode to view the default WorldMap.
function panel:WorldMapFrameOnShow ()
	if ( WorldMap.Loaded ) then
		panel:Hide(); -- Stop updating with Carbonite

		-- Undo Carbonite scaling/fading
		WorldMap:SetScale( 1 );
		WorldMap.RangeRing.Child:SetScale( 1 );
		WorldMap.KeyParent:SetAlpha( 1 );

		WorldMap:SetParent( WorldMapDetailFrame );
		WorldMap:SetAllPoints();

		WorldMap.KeyParent:SetParent( WorldMapButton );
		WorldMap.KeyParent:SetAllPoints();
		WorldMap.KeyParent:SetFrameStrata("High");

		WorldMap.RangeRing:SetParent( WorldMapDetailFrame );
		WorldMap.RangeRing:SetAllPoints();
		WorldMap.RangeRingSetTarget( WorldMapPlayerUpper );
	end
end
--- Adjusts the canvas when entering Carbonite mode.
function panel:WorldMapFrameOnHide ()
	if not Nx.Initialized then
		return
	end
	if ( WorldMap.Loaded ) then		
		panel:Show(); -- Begin updating with Carbonite

		local ScrollFrame = CarboniteMap.TextScFrm;
		WorldMap:SetParent( ScrollFrame:GetScrollChild() );
		WorldMap:ClearAllPoints();

		WorldMap.KeyParent:SetParent( ScrollFrame );
		WorldMap.KeyParent:SetAllPoints();
		WorldMap.KeyParent:SetFrameStrata("High");

		WorldMap.RangeRing:SetParent( ScrollFrame );
		WorldMap.RangeRing:SetAllPoints();
		WorldMap.RangeRingSetTarget( CarboniteMap.PlyrFrm );
	end
end

local function OnUnload ()
	panel.OnUpdate = nil;
	if ( WorldMap.Loaded ) then
		panel:SetScript( "OnUpdate", nil );
	end
end


local function OnLoad ()
	panel:SetScript( "OnUpdate", panel.OnUpdate );	
	-- Give the canvas an explicit size so it paints correctly in Carbonite mode
	WorldMap:SetSize( WorldMapDetailFrame:GetSize() );

	-- Hooks to swap between Carbonite's map mode and the default UI map mode
	WorldMapFrame:HookScript( "OnShow", panel.WorldMapFrameOnShow );
	WorldMapFrame:HookScript( "OnHide", panel.WorldMapFrameOnHide );	
	WorldMapFrame:RegisterEvent("ZONE_CHANGED");
	WorldMapFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
	WorldMapFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	WorldMapFrame:HookScript( "OnEvent", panel.WorldMapFrameEventHandler);
	panel[ WorldMapFrame:IsVisible() and "WorldMapFrameOnShow" or "WorldMapFrameOnHide" ]( WorldMapFrame );
	if CarboniteMap then
	--print("CM")
	--print(Nx.Map.Cont)
		--CarboniteMap:ClipZoneFrm( CarboniteMap.Cont, CarboniteMap.Zone, WorldMap,1);
		-- Add Overlay Toggle buttons to Carbonite Toolbar
		Nx.Button.TypeData["OverlayToggle"] ={
			Up = private.PathToggleIconTexture_Enabled,
			Dn = private.PathToggleIconTexture_Enabled ,
			SizeUp = 22,
			SizeDn = 22,
		}
		--tinsert (Nx.BarData,{"OverlayToggle", L.MODULE_WORLDMAP_TOGGLE, OverlayToggle, false})
		Nx.ToolBar:AddCustomButton ("OverlayToggle", L.MODULE_WORLDMAP_TOGGLE, 2, OverlayToggle, false)

		Nx.Button.TypeData["KeyToggle"] ={
			Up = private.KeyToggleIconTexture_Enabled,
			Dn = private.KeyToggleIconTexture_Enabled ,
			SizeUp = 22,
			SizeDn = 22,
		}
		--tinsert (Nx.BarData,{"KeyToggle", L.MODULE_WORLDMAP_KEYTOGGLE, KeyToggle, false})
		Nx.ToolBar:AddCustomButton ("KeyToggle", L.MODULE_WORLDMAP_KEYTOGGLE, 1, KeyToggle, false)
	end
end

--- Sets a module's handler, or hooks the old one if it exists.
local function HookHandler ( Name, Handler )
	local Backup = WorldMap[ Name ];
	WorldMap[ Name ] = not Backup and Handler or function ( ... )
		Backup( ... );
		Handler( ... );
	end;
end

function panel:WorldMapFrameEventHandler (event, ...)
	if ( not Nx.Initialized ) then
		return
	end
	if not CarboniteMap then		
		if ( Nx.db.profile.MiniMap.Own ) then -- Minimap docked into WorldMap
			private.Modules.Unregister( "Minimap" );
		end
		CarboniteMap =  NxMap1.NxMap
		OnLoad()
	end
	if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
		if (Nx.Map:IsMicroDungeon(Nx.Map:GetCurrentMapId())) then
			WorldMap:SetAlpha(0);
			--CarboniteMap:ClipZoneFrm( CarboniteMap.Cont, CarboniteMap.Zone, WorldMap);
		else
			WorldMap:SetAlpha(CarboniteMap.BackgndAlpha);
			--CarboniteMap:ClipZoneFrm( CarboniteMap.Cont, CarboniteMap.Zone, WorldMap);
		end
	end
end


if ( WorldMap.Loaded ) then
	OnLoad();
else
	HookHandler( "OnLoad", OnLoad );
end
HookHandler( "OnUnload", OnUnload );
