--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/WorldMapTemplate.lua - Template module for WorldMap-like canvases. *
  ****************************************************************************]]

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local private = select( 2, ... );
local panel = {};
local L = private.L
private.Modules.WorldMapTemplate = panel;

do
	local MapCurrent;
	--- Callback to draw a single NPC's paths for a zone.
	local function PaintPath ( self, PathData, FoundX, FoundY, R, G, B )
		private.DrawPath( self, PathData, "ARTWORK", R, G, B );

	--Do Not remove.  Disabled to unclutter map untill good way to limit number can be found
		if FoundX and private.Options.ModulesExtra["WorldMap"].DetectionRing then
			private.DrawFound( self, FoundX, FoundY,
				private.DetectionRadius / private.GetMapSize( MapCurrent ),
				"OVERLAY", R, G, B ); 
		end
	end
	--- Draws paths for the given map on this canvas.
	-- Must be viewing Map using the WorldMap API.
	-- @param Map  AreaID to draw paths for.
	function panel:Paint ( Map )
		MapCurrent = Map;
		private.TextureRemoveAll( self );
		private.ApplyZone( self, Map, PaintPath );
	end
end


local maptooltip = false
function panel:MouseOverCheck()
	if not private.Options.MouseoverText then return end

	local tooltip = (self:GetParent() == _G.WorldMapDetailFrame and WorldMapTooltip) 
	  or (self:GetParent() == _G.OmegaMapNoteFrame and OmegaMapTooltip) 
	  or GameTooltip


	local Parent = self:GetParent():GetName() --or self:GetName()

	for index = #self, 1, -1 do
		local texture = self[index]
		local isOver = texture:IsMouseOver()
		if isOver and not maptooltip and not tooltip:IsVisible() then
			--tooltip = (self:GetParent() == _G.WorldMapDetailFrame and WorldMapTooltip) 
			  --or (self:GetParent() == _G.OmegaMapNoteFrame and OmegaMapTooltip) 
			  --or GameTooltip
			tooltip:SetOwner( self, "ANCHOR_CURSOR" )
			tooltip:SetText( L.NPCs[ tostring(texture.id)] or texture.id or nil, nil, nil, nil, nil, 1 )
			tooltip:Show()
			maptooltip = tooltip
			return
		elseif isOver and  maptooltip and maptooltip:IsVisible() then
			return
		elseif not isOver and maptooltip and not maptooltip:IsVisible()then
				maptooltip:Hide()
				maptooltip = false 
		elseif maptooltip then
				maptooltip:Hide()
				maptooltip = false 
		end
	end
end


local MapUpdate;
--local MapNeedsUpdate = false;
private.forceKeyUpdate = false
do
	local GetCurrentMapAreaID = _G.GetCurrentMapAreaID;
	local GetCurrentMapDungeonLevel = _G.GetCurrentMapDungeonLevel;
	--- Repaints at most once per frame, and only when the displayed zome changes.
	local function OnUpdate ( self )
		--self:SetScript( "OnUpdate", nil );
		panel.MouseOverCheck(self)
		if self.MapNeedsUpdate then
			self.MapNeedsUpdate = false
			local Map = GetCurrentMapAreaID();
			local MapLevel = GetCurrentMapDungeonLevel();
			if ( Map ~= self.MapLast or MapLevel ~= self.MapLevelLast ) then
				self.MapLast = Map;
				self.MapLevelLast = MapLevel;
				if ( MapLevel ~= 0 ) then
					private.TextureRemoveAll( self );
					if ( _NPCScanOverlayKey ~= nil ) then 
						_NPCScanOverlayKey:Hide();
					end
				else
					return self:Paint( Map );
				end
			end
		end
	end


	--- Throttles calls to the Paint method.
	-- @param Force  Forces an update even if the map hasn't changed.
	function MapUpdate ( self, Force )
		if ( Force ) then
			self.MapLast = nil;
			self.MapLevelLast = nil;
		end
		self:SetScript( "OnUpdate", OnUpdate );
		self.MapNeedsUpdate = true
		private.forceKeyUpdate = false
	end
end


--- Update the map if the viewed zone changes.
function panel:WORLD_MAP_UPDATE ()
	MapUpdate( self );
end


--- Immediately update the map when shown.
function panel:OnShow ()
	MapUpdate( self, private.forceKeyUpdate);
end


--- Force an update if shown paths change.
-- @param Map  AreaID that changed, or nil if all zones must update.
function panel:OnMapUpdate ( Map )
	if ( not Map or Map == self.MapLast ) then
		MapUpdate( self, true );
	end
end


--- Shows the canvas when enabled.
function panel:OnEnable ()
	self:RegisterEvent( "WORLD_MAP_UPDATE" );
	self:Show();
end


--- Hides the canvas when disabled.
function panel:OnDisable ()
	self:UnregisterEvent( "WORLD_MAP_UPDATE" );
	self:Hide();
	private.TextureRemoveAll( self );
end


--- Initializes the canvas after its dependencies load.
function panel:OnLoad ()
	self:Hide();
	self:SetAllPoints();
	self:SetScript( "OnShow", self.OnShow );
	self:SetScript( "OnEvent", private.Modules.OnEvent );
	self.MapNeedsUpdate = false;
end


--- Clears all methods and scripts to be garbage collected.
function panel:OnUnload ()
	self:SetScript( "OnShow", nil );
	self:SetScript( "OnEvent", nil );
	self:SetScript( "OnUpdate", nil );
end


do
	local Preserve = {
		[ 0 ] = true; -- Frame UserData
		Name = true;
		Config = true;
		OnSynchronize = true;
	};
	--- Clears most module data to be garbage collected.
	function panel:OnUnregister ()
		for Key in pairs( self ) do
			if ( not Preserve[ Key ] ) then
				self[ Key ] = nil;
			end
		end
	end
end


do
	local Inherit = {
		"Paint",
		"WORLD_MAP_UPDATE",
		"OnShow",
		"OnMapUpdate",
		"OnEnable",
		"OnDisable",
		"OnLoad",
		"OnUnload",
		"OnUnregister"
	};
	--- Implements WorldMapTemplate for a given canvas module frame.
	function panel:Embed ()
		for _, Method in ipairs( Inherit ) do
			self[ Method ] = panel[ Method ];
		end
		self.super = panel;
		return self;
	end
end