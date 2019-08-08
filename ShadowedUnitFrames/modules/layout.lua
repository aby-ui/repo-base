local Layout = {mediaPath = {}}
local SML, mediaRequired, anchoringQueued
local mediaPath = Layout.mediaPath
local backdropTbl = {insets = {}}
local _G = getfenv(0)

ShadowUF.Layout = Layout

-- Someone is using another mod that is forcing a media type for all mods using SML
function Layout:MediaForced(mediaType)
	local oldPath = mediaPath[mediaType]
	self:CheckMedia()

	if( mediaPath[mediaType] ~= oldPath ) then
		self:Reload()
	end
end

local function loadMedia(type, name, default)
	if( name == "" ) then return "" end

	local media = SML:Fetch(type, name, true)
	if( not media ) then
		mediaRequired = mediaRequired or {}
		mediaRequired[type] = name
		return default
	end

	return media
end

-- Updates the background table
local function updateBackdrop()
	-- Update the backdrop table
	local backdrop = ShadowUF.db.profile.backdrop
	backdropTbl.bgFile = mediaPath.background
	if( mediaPath.border ~= "Interface\\None" ) then backdropTbl.edgeFile = mediaPath.border end
	backdropTbl.tile = backdrop.tileSize > 0 and true or false
	backdropTbl.edgeSize = backdrop.edgeSize
	backdropTbl.tileSize = backdrop.tileSize
	backdropTbl.insets.left = backdrop.inset
	backdropTbl.insets.right = backdrop.inset
	backdropTbl.insets.top = backdrop.inset
	backdropTbl.insets.bottom = backdrop.inset
end

-- Tries to load media, if it fails it will default to whatever I set
function Layout:CheckMedia()
	mediaPath[SML.MediaType.STATUSBAR] = loadMedia(SML.MediaType.STATUSBAR, ShadowUF.db.profile.bars.texture, "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\Aluminium")
	mediaPath[SML.MediaType.FONT] = loadMedia(SML.MediaType.FONT, ShadowUF.db.profile.font.name, "Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf")
	mediaPath[SML.MediaType.BACKGROUND] = loadMedia(SML.MediaType.BACKGROUND, ShadowUF.db.profile.backdrop.backgroundTexture, "Interface\\ChatFrame\\ChatFrameBackground")
	mediaPath[SML.MediaType.BORDER] = loadMedia(SML.MediaType.BORDER, ShadowUF.db.profile.backdrop.borderTexture, "")

	updateBackdrop()
end

-- We might not have had a media we required at initial load, wait for it to load and then update everything when it does
function Layout:MediaRegistered(event, mediaType, key)
	if( mediaRequired and mediaRequired[mediaType] and mediaRequired[mediaType] == key ) then
		mediaPath[mediaType] = SML:Fetch(mediaType, key)
		mediaRequired[mediaType] = nil

		self:Reload()
	end
end

-- Helper functions
function Layout:ToggleVisibility(frame, visible)
	if( frame and visible ) then
		frame:Show()
	elseif( frame ) then
		frame:Hide()
	end
end

function Layout:SetBarVisibility(frame, key, status)
	if( frame.secureLocked ) then return end

	-- Show the bar if it wasn't already
	if( status and not frame[key]:IsVisible() ) then
		ShadowUF.Tags:FastRegister(frame, frame[key])

		frame[key].visibilityManaged = true
		frame[key]:Show()
		ShadowUF.Layout:PositionWidgets(frame, ShadowUF.db.profile.units[frame.unitType])

	-- Hide the bar if it wasn't already
	elseif( not status and frame[key]:IsVisible() ) then
		ShadowUF.Tags:FastUnregister(frame, frame[key])

		frame[key].visibilityManaged = nil
		frame[key]:Hide()
		ShadowUF.Layout:PositionWidgets(frame, ShadowUF.db.profile.units[frame.unitType])
	end
end


-- Frame changed somehow between when we first set it all up and now
function Layout:Reload(unit)
	updateBackdrop()

	-- Now update them
	for frame in pairs(ShadowUF.Units.frameList) do
		if( frame.unit and ( not unit or frame.unitType == unit ) and not frame.isHeaderFrame ) then
			frame:SetVisibility()
			self:Load(frame)
			frame:FullUpdate()
		end
	end

	for header in pairs(ShadowUF.Units.headerFrames) do
		if( header.unitType and ( not unit or header.unitType == unit ) ) then
			local config = ShadowUF.db.profile.units[header.unitType]
			header:SetAttribute("style-height", config.height)
			header:SetAttribute("style-width", config.width)
			header:SetAttribute("style-scale", config.scale)
		end
	end

	ShadowUF:FireModuleEvent("OnLayoutReload", unit)
end

-- Do a full update
function Layout:Load(frame)
	local unitConfig = ShadowUF.db.profile.units[frame.unitType]

	-- About to set layout
	ShadowUF:FireModuleEvent("OnPreLayoutApply", frame, unitConfig)

	-- Figure out if we're secure locking
	frame.secureLocked = nil
	for _, module in pairs(ShadowUF.moduleOrder) do
		if( frame.visibility[module.moduleKey] and ShadowUF.db.profile.units[frame.unitType][module.moduleKey] and
			ShadowUF.db.profile.units[frame.unitType][module.moduleKey].secure and module:SecureLockable() ) then
			frame.secureLocked = true
			break
		end
	end

	-- Load all of the layout things
	self:SetupFrame(frame, unitConfig)
	self:SetupBars(frame, unitConfig)
	self:PositionWidgets(frame, unitConfig)
	self:SetupText(frame, unitConfig)

	-- Layouts been fully set
	ShadowUF:FireModuleEvent("OnLayoutApplied", frame, unitConfig)
end

-- Register it on file load because authors seem to do a bad job at registering the callbacks
SML = LibStub:GetLibrary("LibSharedMedia-3.0")
SML:Register(SML.MediaType.FONT, "Myriad Condensed Web", "Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf")
SML:Register(SML.MediaType.BORDER, "Square Clean", "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\ABFBorder")
SML:Register(SML.MediaType.BACKGROUND, "Chat Frame", "Interface\\ChatFrame\\ChatFrameBackground")
SML:Register(SML.MediaType.STATUSBAR, "BantoBar", "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\banto")
SML:Register(SML.MediaType.STATUSBAR, "Smooth",   "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\smooth")
SML:Register(SML.MediaType.STATUSBAR, "Perl",     "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\perl")
SML:Register(SML.MediaType.STATUSBAR, "Glaze",    "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\glaze")
SML:Register(SML.MediaType.STATUSBAR, "Charcoal", "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\Charcoal")
SML:Register(SML.MediaType.STATUSBAR, "Otravi",   "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\otravi")
SML:Register(SML.MediaType.STATUSBAR, "Striped",  "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\striped")
SML:Register(SML.MediaType.STATUSBAR, "LiteStep", "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\LiteStep")
SML:Register(SML.MediaType.STATUSBAR, "Aluminium", "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\Aluminium")
SML:Register(SML.MediaType.STATUSBAR, "Minimalist", "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\Minimalist")

function Layout:LoadSML()
	SML.RegisterCallback(self, "LibSharedMedia_Registered", "MediaRegistered")
	SML.RegisterCallback(self, "LibSharedMedia_SetGlobal", "MediaForced")
	self:CheckMedia()
end

--[[
	Keep in mind this is relative to where you're parenting it, RT will put the object outside of the frame, on the right side, at the top of it while ITR will put it inside the frame, at the top to the right

	* Positions OUTSIDE the frame
	RT = Right Top, RC = Right Center, RB = Right Bottom
	LT = Left Top, LC = Left Center, LB = Left Bottom,
	BL = Bottom Left, BC = Bottom Center, BR = Bottom Right
	TR = Top Right, TC = Top Center, TL = Top Left

	* Positions INSIDE the frame
	CLI = Inside Center Left, CRI = Inside Center Right
	TRI = Inside Top Right, TLI = Inside Top Left
	BRI = Inside Bottom Right, BRI = Inside Bottom left
]]

local preDefPoint = {C = "CENTER", CLI = "LEFT", RT = "TOPLEFT", BC = "TOP", CRI = "RIGHT", LT = "TOPRIGHT", TR = "BOTTOMRIGHT", BL = "TOPLEFT", LB = "BOTTOMRIGHT", LC = "RIGHT", RB = "BOTTOMLEFT", RC = "LEFT", TC = "BOTTOM", BR = "TOPRIGHT", TL = "BOTTOMLEFT", BRI = "BOTTOMRIGHT", BLI = "BOTTOMLEFT", TRI = "TOPRIGHT", TLI = "TOPLEFT"}
local preDefRelative = {C = "CENTER", CLI = "LEFT", RT = "TOPRIGHT", BC = "BOTTOM", CRI = "RIGHT", LT = "TOPLEFT", TR = "TOPRIGHT", BL = "BOTTOMLEFT", LB = "BOTTOMLEFT", LC = "LEFT", RB = "BOTTOMRIGHT", RC = "RIGHT", TC = "TOP", BR = "BOTTOMRIGHT", TL = "TOPLEFT", BRI = "BOTTOMRIGHT", BLI = "BOTTOMLEFT", TRI = "TOPRIGHT", TLI = "TOPLEFT"}
local columnDirection = {RT = "RIGHT", C = "RIGHT", BC = "BOTTOM", LT = "LEFT", TR = "TOP", BL = "BOTTOM", LB = "LEFT", LC = "LEFT", TRI = "TOP", RB = "RIGHT", RC = "RIGHT", TC = "TOP", CLI = "RIGHT", TL = "TOP", BR = "BOTTOM", IBL = "RIGHT", IBR = "RIGHT", CRI = "RIGHT", TLI = "TOP"}
local auraDirection = {RT = "BOTTOM", C = "LEFT", BC = "LEFT", LT = "BOTTOM", TR = "LEFT", BL = "RIGHT", LB = "TOP", LC = "LEFT", TRI = "LEFT", RB = "TOP", RC = "LEFT", TC = "LEFT", CLI = "RIGHT", TL = "RIGHT", BR = "LEFT", IBL = "TOP", IBR = "TOP", CRI = "LEFT", TLI = "RIGHT"}

-- Figures out how text should be justified based on where it's anchoring
function Layout:GetJustify(config)
	local point = config.anchorPoint and config.anchorPoint ~= "" and preDefPoint[config.anchorPoint] or config.point
	if( point and point ~= "" ) then
		if( string.match(point, "LEFT$") ) then
			return "LEFT"
		elseif( string.match(point, "RIGHT$") ) then
			return "RIGHT"
		end
	end

	return "CENTER"
end

function Layout:GetPoint(key)
	return preDefPoint[key] or "CENTER"
end

function Layout:GetRelative(key)
	return preDefRelative[key] or "CENTER"
end

function Layout:GetColumnGrowth(key)
	return columnDirection[key] or "DOWN"
end

function Layout:GetAuraGrowth(key)
	return auraDirection[key] or "LEFT"
end

function Layout:ReverseDirection(key)
	return key == "LEFT" and "RIGHT" or key == "RIGHT" and "LEFT" or key == "TOP" and "BOTTOM" or key == "BOTTOM" and "TOP"
end

-- Gets the relative anchoring for Blizzards default raid frames, these differ from the split ones
function Layout:GetRelativeAnchor(point)
	if( point == "TOP" ) then
		return "BOTTOM", 0, -1
	elseif( point == "BOTTOM" ) then
		return "TOP", 0, 1
	elseif( point == "LEFT" ) then
		return "RIGHT", 1, 0
	elseif( point == "RIGHT" ) then
		return "LEFT", -1, 0
	elseif( point == "TOPLEFT" ) then
		return "BOTTOMRIGHT", 1, -1
	elseif( point == "TOPRIGHT" ) then
		return "BOTTOMLEFT", -1, -1
	elseif( point == "BOTTOMLEFT" ) then
		return "TOPRIGHT", 1, 1
	elseif( point == "BOTTOMRIGHT" ) then
		return "TOPLEFT", -1, 1
	else
		return "CENTER", 0, 0
	end
end

function Layout:GetSplitRelativeAnchor(point, columnPoint)
	-- Column is growing to the RIGHT
	if( columnPoint == "LEFT" ) then
		return "TOPLEFT", "TOPRIGHT", 1, 0
	-- Column is growing to the LEFT
	elseif( columnPoint == "RIGHT" ) then
		return "TOPRIGHT", "TOPLEFT", -1, 0
	-- Column is growing DOWN
	elseif( columnPoint == "TOP" ) then
		return "TOP" .. point, "BOTTOM" .. point, 0, -1
	-- Column is growing UP
	elseif( columnPoint == "BOTTOM" ) then
		return "BOTTOM" .. point, "TOP" .. point, 0, 1
	end
end

function Layout:AnchorFrame(parent, frame, config)
	if( not config or not config.anchorTo or not config.x or not config.y ) then
		return
	end

	local anchorTo = config.anchorTo
	local prefix = string.sub(config.anchorTo, 0, 1)
	if( config.anchorTo == "$parent" ) then
		anchorTo = parent
	-- $ is used as an indicator of a sub-frame inside a parent, $healthBar -> parent.healthBar and so on
	elseif( prefix == "$" ) then
		anchorTo = parent[string.sub(config.anchorTo, 2)]
	-- # is used as an indicator of an actual frame created by SUF, it lets us know that the frame might not be created yet
	-- and if so, to watch for it to be created and fix the anchoring
	elseif( prefix == "#" ) then
		anchorTo = string.sub(config.anchorTo, 2)

		-- The frame we wanted to anchor to doesn't exist yet, so will queue and wait for it to exist
		if( not _G[anchorTo] ) then
			frame.queuedParent = parent
			frame.queuedConfig = config
			frame.queuedName = anchorTo

			anchoringQueued = anchoringQueued or {}
			anchoringQueued[frame] = true

			-- For the time being, will take over the frame we wanted to anchor to's position.
			local unit = string.match(anchorTo, "SUFUnit(%w+)") or string.match(anchorTo, "SUFHeader(%w+)")
			if( unit and ShadowUF.db.profile.positions[unit] ) then
				self:AnchorFrame(parent, frame, ShadowUF.db.profile.positions[unit])
			end
			return
		end
	end

	if( config.block ) then
		anchorTo = anchorTo.blocks[frame.blockID]
	end

	-- Figure out where it's anchored
	local point = config.point and config.point ~= "" and config.point or preDefPoint[config.anchorPoint] or "CENTER"
	local relativePoint = config.relativePoint and config.relativePoint ~= "" and config.relativePoint or preDefRelative[config.anchorPoint] or "CENTER"

	-- Effective scaling is only used for unit based frames and if they are anchored to UIParent
	local scale = 1
	if( config.anchorTo == "UIParent" and frame.unitType ) then
		scale = frame:GetScale() * UIParent:GetScale()
	end

	frame:ClearAllPoints()
	frame:SetPoint(point, anchorTo, relativePoint, config.x / scale, config.y / scale)
end

-- Setup the main frame
function Layout:SetupFrame(frame, config)
	local backdrop = ShadowUF.db.profile.backdrop
	frame:SetBackdrop(backdropTbl)
	frame:SetBackdropColor(backdrop.backgroundColor.r, backdrop.backgroundColor.g, backdrop.backgroundColor.b, backdrop.backgroundColor.a)
	frame:SetBackdropBorderColor(backdrop.borderColor.r, backdrop.borderColor.g, backdrop.borderColor.b, backdrop.borderColor.a)

	-- Prevent these from updating while in combat to prevent tainting
	if( not InCombatLockdown() ) then
		frame:SetHeight(config.height)
		frame:SetWidth(config.width)
		frame:SetScale(config.scale)

		-- Let the frame clip closer to the edge, not using inset + clip as that lets you move it too far in
		local clamp = backdrop.inset + 0.20
		frame:SetClampRectInsets(clamp, -clamp, -clamp, clamp)
		frame:SetClampedToScreen(true)

		-- This is wrong technically, I need to redo the backdrop stuff so it will accept insets and that will fit hitbox issues
		-- for the time being, this is a temporary fix to it
		local hit = backdrop.borderTexture == "None" and backdrop.inset or 0
		frame:SetHitRectInsets(hit, hit, hit, hit)

		if( not frame.ignoreAnchor ) then
			self:AnchorFrame(frame.parent or UIParent, frame, ShadowUF.db.profile.positions[frame.unitType])
		end
	end

	-- Check if we had anything parented to us
	if( anchoringQueued ) then
		for queued in pairs(anchoringQueued) do
			if( queued.queuedName == frame:GetName() ) then
				self:AnchorFrame(queued.queuedParent, queued, queued.queuedConfig)

				queued.queuedParent = nil
				queued.queuedConfig = nil
				queued.queuedName = nil
				anchoringQueued[queued] = nil
			end
		end
	end

end

-- Setup bars
function Layout:SetupBars(frame, config)
	for _, module in pairs(ShadowUF.modules) do
		local key = module.moduleKey
		local widget = frame[key]
		if( widget and ( module.moduleHasBar or config[key] and config[key].isBar ) ) then
			if( frame.visibility[key] and not frame[key].visibilityManaged and module.defaultVisibility == false ) then
				self:ToggleVisibility(widget, false)
			else
				self:ToggleVisibility(widget, frame.visibility[key])
			end

			if( ( widget:IsShown() or ( not frame[key].visibilityManaged and module.defaultVisibility == false ) ) and widget.SetStatusBarTexture ) then
				widget:SetStatusBarTexture(mediaPath.statusbar)
				widget:GetStatusBarTexture():SetHorizTile(false)

				widget:SetOrientation(config[key].vertical and "VERTICAL" or "HORIZONTAL")
				widget:SetReverseFill(config[key].reverse and true or false)
			end

			if( widget.background ) then
				if( config[key].background or config[key].invert ) then
					widget.background:SetTexture(mediaPath.statusbar)
					widget.background:SetHorizTile(false)
					widget.background:Show()

					widget.background.overrideColor = ShadowUF.db.profile.bars.backgroundColor or config[key].backgroundColor

					if( widget.background.overrideColor ) then
						widget.background:SetVertexColor(widget.background.overrideColor.r, widget.background.overrideColor.g, widget.background.overrideColor.b, ShadowUF.db.profile.bars.backgroundAlpha)
					end
				else
					widget.background:Hide()
				end
			end
		end
	end
end

-- Setup text
function Layout:SetupFontString(fontString, extraSize)
	local size = ShadowUF.db.profile.font.size + (extraSize or 0)
	if( size <= 0 ) then size = 1 end

	fontString:SetFont(mediaPath.font, size, ShadowUF.db.profile.font.extra)

	if( ShadowUF.db.profile.font.shadowColor and ShadowUF.db.profile.font.shadowX and ShadowUF.db.profile.font.shadowY ) then
		fontString:SetShadowColor(ShadowUF.db.profile.font.shadowColor.r, ShadowUF.db.profile.font.shadowColor.g, ShadowUF.db.profile.font.shadowColor.b, ShadowUF.db.profile.font.shadowColor.a)
		fontString:SetShadowOffset(ShadowUF.db.profile.font.shadowX, ShadowUF.db.profile.font.shadowY)
	else
		fontString:SetShadowColor(0, 0, 0, 0)
		fontString:SetShadowOffset(0, 0)
	end
end

local totalWeight = {}
function Layout:InitFontString(parent, frame, id, config, blockID)
	local rowID = blockID and tonumber(id .. "." .. blockID) or id

	local fontString = frame.fontStrings[rowID] or frame.highFrame:CreateFontString(nil, "ARTWORK")
	fontString.configID = id
	if( blockID ) then
		fontString.blockID = blockID
		fontString.block = parent.blocks[blockID]
	end

	self:SetupFontString(fontString, config.size)
	fontString:SetTextColor(ShadowUF.db.profile.font.color.r, ShadowUF.db.profile.font.color.g, ShadowUF.db.profile.font.color.b, ShadowUF.db.profile.font.color.a)
	fontString:SetText(config.text)
	fontString:SetJustifyH(self:GetJustify(config))
	self:AnchorFrame(frame, fontString, config)

	-- We figure out the anchor point so we can put text in the same area with the same width requirements
	local anchorPoint = columnDirection[config.anchorPoint]
	if( string.len(config.anchorPoint) == 3 ) then anchorPoint = anchorPoint .. "I" end

	fontString.parentBar = parent
	fontString.availableWidth = parent:GetWidth() - config.x
	fontString.widthID = config.anchorTo .. anchorPoint .. config.y
	totalWeight[fontString.widthID] = (totalWeight[fontString.widthID] or 0) + config.width

	ShadowUF.Tags:Register(frame, fontString, config.text)
	fontString:UpdateTags()
	fontString:Show()

	frame.fontStrings[rowID] = fontString
end

function Layout:SetupText(frame, config)
	-- Update tag text
	frame.fontStrings = frame.fontStrings or {}
	for _, fontString in pairs(frame.fontStrings) do
		ShadowUF.Tags:Unregister(fontString)
		fontString:Hide()
	end

	for k in pairs(totalWeight) do totalWeight[k] = nil end

	-- Update the actual text, and figure out the weighting information now
	for id, row in pairs(config.text) do
		local module = string.sub(row.anchorTo, 2)
		local parent = row.anchorTo == "$parent" and frame or frame[module]
		if( parent and ( ShadowUF.modules[module].defaultVisibility == false or parent:IsShown() ) and row.enabled and row.text ~= "" ) then
			if( not row.block ) then
				self:InitFontString(parent, frame, id, row, nil)
			else
				for blockID, block in pairs(parent.blocks) do
					self:InitFontString(parent, frame, id, row, blockID)
				end
			end
		end
	end

	-- Now set all of the width using our weightings
	for _, fontString in pairs(frame.fontStrings) do
		local id = fontString.configID
		if( fontString:IsShown() ) then
			fontString:SetWidth(fontString.availableWidth * (config.text[id].width / totalWeight[fontString.widthID]))
			fontString:SetHeight(ShadowUF.db.profile.font.size + 1)

			frame:RegisterUpdateFunc(fontString, "UpdateTags")
		else
			frame:UnregisterAll(fontString)
		end
	end
end

-- Setup the bar barOrder/info
local currentConfig
local function sortOrder(a, b)
	return currentConfig[a].order < currentConfig[b].order
end

local barOrder = {}
function Layout:PositionWidgets(frame, config)
	-- Deal with setting all of the bar heights
	local totalWidgetWeight, totalBars, hasFullSize = 0, -1

	-- Figure out total weighting as well as what bars are full sized
	for i=#(barOrder), 1, -1 do table.remove(barOrder, i) end
	for key, module in pairs(ShadowUF.modules) do
		if( config[key] and not config[key].height ) then config[key].height = 0.50 end

		if( ( module.moduleHasBar or config[key] and config[key].isBar ) and frame[key] and frame[key]:IsShown() and config[key].height > 0 ) then
			totalWidgetWeight = totalWidgetWeight + config[key].height
			totalBars = totalBars + 1

			table.insert(barOrder, key)

			config[key].order = config[key].order or 99

			-- Decide whats full sized
			if( not frame.visibility.portrait or config.portrait.isBar or config[key].order < config.portrait.fullBefore or config[key].order > config.portrait.fullAfter ) then
				hasFullSize = true
				frame[key].fullSize = true
			else
				frame[key].fullSize = nil
			end
		end
	end

	-- Sort the barOrder so it's all nice and orderly (:>)
	currentConfig = config
	table.sort(barOrder, sortOrder)

	-- Now deal with setting the heights and figure out how large the portrait should be.
	local clip = ShadowUF.db.profile.backdrop.inset + ShadowUF.db.profile.backdrop.clip
	local clipDoubled = clip * 2

	local portraitOffset, portraitAlignment, portraitAnchor, portraitWidth
	if( not config.portrait.isBar ) then
		self:ToggleVisibility(frame.portrait, frame.visibility.portrait)

		if( frame.visibility.portrait ) then
			-- Figure out portrait alignment
			portraitAlignment = config.portrait.alignment

			-- Set the portrait width so we can figure out the offset to use on bars, will do height and position later
			portraitWidth = math.floor(frame:GetWidth() * config.portrait.width) - ShadowUF.db.profile.backdrop.inset
			frame.portrait:SetWidth(portraitWidth - (portraitAlignment == "RIGHT" and 1 or 0.5))

			-- Disable portrait if there isn't enough room
			if( portraitWidth <= 0 ) then
				frame.portrait:Hide()
			end

			-- As well as how much to offset bars by (if it's using a left alignment) to keep them all fancy looking
			portraitOffset = clip
			if( portraitAlignment == "LEFT" ) then
				portraitOffset = portraitOffset + portraitWidth
			end
		end
	end

	-- Position and size everything
	local portraitHeight, xOffset = 0, -clip
	local availableHeight = frame:GetHeight() - clipDoubled - (math.abs(ShadowUF.db.profile.bars.spacing) * totalBars)
	for id, key in pairs(barOrder) do
		local bar = frame[key]

		-- Position the actual bar based on it's type
		if( bar.fullSize ) then
			bar:SetWidth(frame:GetWidth() - clipDoubled)
			bar:SetHeight(availableHeight * (config[key].height / totalWidgetWeight))

			bar:ClearAllPoints()
			bar:SetPoint("TOPLEFT", frame, "TOPLEFT", clip, xOffset)
		else
			bar:SetWidth(frame:GetWidth() - portraitWidth - clipDoubled)
			bar:SetHeight(availableHeight * (config[key].height / totalWidgetWeight))

			bar:ClearAllPoints()
			bar:SetPoint("TOPLEFT", frame, "TOPLEFT", portraitOffset, xOffset)

			portraitHeight = portraitHeight + bar:GetHeight()
		end

		-- Figure out where the portrait is going to be anchored to
		if( not portraitAnchor and config[key].order >= config.portrait.fullBefore ) then
			portraitAnchor = bar
		end

		xOffset = xOffset - bar:GetHeight() + ShadowUF.db.profile.bars.spacing
	end

	-- Now position the portrait and set the height
	if( frame.portrait and frame.portrait:IsShown() and portraitAnchor and portraitHeight > 0 ) then
		if( portraitAlignment == "LEFT" ) then
			frame.portrait:ClearAllPoints()
			frame.portrait:SetPoint("TOPLEFT", portraitAnchor, "TOPLEFT", -frame.portrait:GetWidth() - 0.5, 0)
		elseif( portraitAlignment == "RIGHT" ) then
			frame.portrait:ClearAllPoints()
			frame.portrait:SetPoint("TOPRIGHT", portraitAnchor, "TOPRIGHT", frame.portrait:GetWidth() + 1, 0)
		end

		if( hasFullSize ) then
			frame.portrait:SetHeight(portraitHeight)
		else
			frame.portrait:SetHeight(frame:GetHeight() - clipDoubled)
		end
	end

	ShadowUF:FireModuleEvent("OnLayoutWidgets", frame, config)
end

