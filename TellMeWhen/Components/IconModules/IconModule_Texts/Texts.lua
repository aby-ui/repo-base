-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local type, pairs, ipairs, assert, rawget, wipe, error, tonumber, _G =
	  type, pairs, ipairs, assert, rawget, wipe, error, tonumber, _G

-- GLOBALS: FROM, CreateFrame


local DogTag = LibStub("LibDogTag-3.0")
local LMB = LibStub("Masque", true) or (LibMasque and LibMasque("Button"))
local LSM = LibStub("LibSharedMedia-3.0")


local TEXT = TMW:NewModule("TextDisplay")
TMW.TEXT = TEXT


TEXT.MasqueSkinnableTexts = {
	-- A list of available SkinAs settings,
	-- paired with their localized name (for easy use in dropdowns)
	
	[""] = L["TEXTLAYOUTS_SKINAS_NONE"],
	
	Count = L["TEXTLAYOUTS_SKINAS_COUNT"],
	HotKey = L["TEXTLAYOUTS_SKINAS_HOTKEY"],
}





-- -------------------
-- DEFAULTS
-- -------------------

TMW:RegisterDatabaseDefaults{
	global = {
		TextLayouts = {
			-- Layout defaults
			["**"] = {
				n					= 1,		-- The number of text displays that this layout handles.
				Name				= "",		-- The name of this layout. Aesthetic only, doesn't need to be unique.
				GUID				= "",		-- The GUID of this layout. Must be unique for all layouts. This is what the layout is keyed as in its parent table, and is how layouts are identified everywhere.
				NoEdit				= false,	-- True if the layout is a default layout and should not be modified.
				
				-- Display defaults
				["**"] = {
					StringName		= "",				-- Name of the string (user-readable)
					Name 		  	= "Arial Narrow",	-- Name of the Font (Stupid key for this setting, but it dates back to antiquity)
					Size 		  	= 12,               -- Font size
					Justify	 		= "CENTER",         -- 
					JustifyV	 	= "MIDDLE",    		-- 
					Outline 	  	= "THICKOUTLINE",   -- Font outline
					Shadow			= 0,

					Height			= 0, -- If we set a fontString's dimensions to 0,
					Width			= 0, -- it will auto adjust, which is default behavior.
					Rotate			= 0, -- Degrees to rotate by.
					
					Anchors = {
						n = 1,
						["**"] = {
							x 	 		  	= 0,                -- Anchor setting
							y 	 		  	= 0,                -- Anchor setting
							point 		  	= "CENTER",         -- Anchor setting
							relativeTo	 	= "",         		-- Anchor setting
							relativePoint 	= "CENTER",         -- Anchor setting
						},
					},
					DefaultText		= "",               -- 
					SkinAs			= "",               -- 
				},
			},
			
			-- The only time this layout should ever get used is if a view doesn't declare any default layout for itself.
			-- It has no displays and cannot be edited. It should also be hidden from the text layout configuration in TMW's main options.
			[""] = {
				Name = L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"],
				GUID = "",
				NoEdit = true,
				n = 0,
			},
		},
	},
}

TMW:MergeDefaultsTables({
	SettingsPerView = {
		["**"] = {
			-- Fall back on the blank layout if an IconView does not explicitly define a layout.
			TextLayout = "", 
		},
	},
}, TMW.Group_Defaults)

TMW:MergeDefaultsTables({
	SettingsPerView = {
		["**"] = {
			-- The table of texts that correspond to the displays defined by the text layout.
			Texts = {},
		},
	},
}, TMW.Icon_Defaults)





-- -------------------
-- SETTINGS UPGRADES
-- -------------------

TMW:RegisterUpgrade(70010, {
	recursiveReplaceLayoutGUIDs = function(self, table, GUIDmap)
		for k, v in pairs(table) do
			if type(v) == "table" then
				self:recursiveReplaceLayoutGUIDs(v, GUIDmap)
			elseif k == "TextLayout" and GUIDmap[v] then
				table[k] = GUIDmap[v]
			end
		end
	end,

	profile = function(self, profile, profileName)
		if not profile.TextLayouts then
			return
		end

		local GUIDmap = {}

		for GUID, layout in pairs(profile.TextLayouts) do
			if type(layout) == "table" and not layout.NoEdit and type(layout.GUID) == "string" then

				if not layout.GUID:match("^TMW:textlayout") then
					-- Change the GUID into the new GUID syntax.

					local newGUID = "TMW:textlayout:" .. layout.GUID

					GUIDmap[GUID] = newGUID
					layout.GUID = newGUID
				end

				if not rawget(TMW.db.global.TextLayouts, layout.GUID) then
					-- The layout doesn't already exist, so just put it straight in.

					layout.Name = (layout.Name or L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"]) .. " (" .. FROM .. " " .. profileName .. ")"
					TMW:CopyTableInPlaceUsingDestinationMeta(layout, TMW.db.global.TextLayouts[layout.GUID])

					-- Make sure we upgrade the copy of the layout, not the old one that will be discarded
					layout = TMW.db.global.TextLayouts[layout.GUID]

					-- Upgrade the new layout manually. This is required because this possibly un-upgraded
					-- layout will be getting mixed into layouts whose version is tracked by the global
					-- version number. When we are upgrading a profile, global upgrades have already
					-- happened, so the layout we are sticking into global.TextLayouts will never get
					-- old upgrades.
					TMW:StartUpgrade("textlayout", profile.Version, layout, layout.GUID)
				else
					-- The layout does already exist.

					local existingName = TMW.db.global.TextLayouts[layout.GUID].Name
					TMW.db.global.TextLayouts[layout.GUID].Name = ""
					local layoutName = layout.Name or L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"]
					layout.Name = ""

					-- Check to see if it is exactly the same as the existing layout.
					-- In order to properly compare, we have to copy the old layout 
					-- into a new table so that all the database metatables will be in place.
					local layoutWithMetatables = TMW:CopyTableInPlaceUsingDestinationMeta(layout, TMW.db.global.TextLayouts["\000"])
					TMW.db.global.TextLayouts["\000"] = nil


					local comparison = TMW:DeepCompare(TMW.db.global.TextLayouts[layout.GUID], layoutWithMetatables)

					TMW.db.global.TextLayouts[layout.GUID].Name = existingName
					layout.Name = layoutName

					if comparison then
						-- The existing layout is the same. Do nothing.
					else
						-- The existing layout is different. Give it a new GUID and then stick it in.
						local newGUID = TMW:GenerateGUID("textlayout", TMW.CONST.GUID_SIZE)

						GUIDmap[GUID] = newGUID
						layout.GUID = newGUID
						layout.Name = layout.Name .. " (" .. FROM .. " " .. profileName .. ")"

						TMW:CopyTableInPlaceUsingDestinationMeta(layout, TMW.db.global.TextLayouts[layout.GUID])

						-- See above for an explanation of this upgrade.
						TMW:StartUpgrade("textlayout", profile.Version, layout, layout.GUID)
					end

				end
			end
		end

		profile.TextLayouts = nil

		self:recursiveReplaceLayoutGUIDs(profile, GUIDmap)
	end
})

TMW:RegisterUpgrade(60448, {
	textlayout = function(self, settings, GUID)
		if not settings.NoEdit then
			for i, displaySettings in ipairs(settings) do
				displaySettings.Anchors.n = 1
				
				local point = displaySettings.point or "CENTER"
				displaySettings.Justify = point:match("LEFT") or point:match("RIGHT") or "CENTER"
				
				displaySettings.Anchors[1].x 	 		  	= displaySettings.x or 0
				displaySettings.Anchors[1].y 	 		  	= displaySettings.y or 0
				displaySettings.Anchors[1].point 		  	= displaySettings.point or "CENTER"
				displaySettings.Anchors[1].relativePoint 	= displaySettings.relativePoint or "CENTER"
				
				displaySettings.x 	 		  	= nil
				displaySettings.y 	 		  	= nil
				displaySettings.point 		  	= nil
				displaySettings.relativePoint 	= nil
			end
		end
	end,
})

TMW:RegisterUpgrade(60338, {
	-- I decided to change [Stacks] to return numbers instead of strings
	icon = function(self, ics)
		for viewName, settingsPerView in pairs(ics.SettingsPerView) do
			for displayID, text in pairs(settingsPerView.Texts) do
				settingsPerView.Texts[displayID] = text
					:gsub("(Stacks[^:]-:Hide)%('0'%)", "%1(0)")
					:gsub("(Stacks[^:]-:Hide)%('0', '1'%)", "%1(0, 1)")
			end
		end
	end,
	textlayout = function(self, settings, GUID)
		-- I decided to change [Stacks] to return numbers instead of strings
		for i, displaySettings in ipairs(settings) do
			displaySettings.DefaultText = displaySettings.DefaultText and displaySettings.DefaultText
				:gsub("(Stacks[^:]-:Hide)%('0'%)", "%1(0)")
				:gsub("(Stacks[^:]-:Hide)%('0', '1'%)", "%1(0, 1)")
		end
	end,
})

TMW:RegisterUpgrade(60317, {
	textlayout = function(self, settings, GUID)
		-- A bug with importing text layouts led them to have their Name attribute set as a table
		-- (Happened because Name was getting set to nil, and was getting recreated as a table through metamethods)
		
		if type(settings.Name) == "table" then
			settings.Name = "Sorry, the name of this layout was lost."
		end
	end
})

TMW:RegisterUpgrade(60303, {
	icon = function(self, ics)
		-- The setting to trigger fallback on groups is nil now, not ""
		-- (icon settings per view don't define a default TextLayout,
		-- only groups do, so this will actually work and won't cause fallback
		-- on defaults by setting it nil because the default is also nil)
		
		for viewName, settingsPerView in pairs(ics.SettingsPerView) do
			if settingsPerView.TextLayout == "" then
				settingsPerView.TextLayout = nil
			end
		end
	end
})

TMW:RegisterUpgrade(60038, {
	group = function(self, gs)
		gs.Fonts = nil
	end
})

TMW:RegisterUpgrade(60029, {
	textlayout = function(self, settings, GUID)
		-- For some reason a lot of text layouts are missing quotes.
		-- (This may just be in my own settings as an artifact of early testing; but could also be in other people who alpha tested)
		-- It also changed to not hide a stack of '1'.
		for i, displaySettings in ipairs(settings) do
			if displaySettings.DefaultText == "[Stacks:Hide(0, 1)]"
			or displaySettings.DefaultText == "[Stacks:Hide('0', '1')]"
			or displaySettings.DefaultText == "[Stacks:Hide('0')]" then
				displaySettings.DefaultText = "[Stacks:Hide(0)]"
			end
		end
	end,
})

TMW:RegisterUpgrade(51019, {
	textlayout = function(self, settings, GUID)
		-- I don't know why this layout exists, but I know it was my fault, so I am going to delete it.
		if GUID == "icon" and settings.GUID == "" then
			TMW.db.global.TextLayouts[GUID] = nil
			TMW:Warn("TMW has deleted the invalid text layout keyed as 'icon' that was probably causing errors for you. If you were using it on any of your icons, then I apologize, but you probably weren't because it probably wasn't even named")
		end
	end,
})

TMW:RegisterUpgrade(51003, {
	---------- Helper methods and data ----------
	pairs = {
		-- Matches [displayID] = oldGroupTextSettingsKey
		[1] = "Bind",
		[2] = "Count",
	},
	
	-- The old defaults for the Count text (stacks) from the old text system.
	Count = {
		ConstrainWidth  = false,
		point           = "BOTTOMRIGHT",
		relativePoint   = "BOTTOMRIGHT",
		
		Name            = "Arial Narrow",
		Size            = 12,
		x               = -2,
		y               = 2,
		Outline         = "THICKOUTLINE",
	},
	
	-- The old defaults for the Bind text from the old text system.
	Bind = {
		y               = -2,
		point           = "TOPLEFT",
		relativePoint   = "TOPLEFT",
		
		Name            = "Arial Narrow",
		Size            = 12,
		x               = -2,
		Outline         = "THICKOUTLINE",
		ConstrainWidth  = true,
	},
	
	-- http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3
	deepcompare = function(self,t1,t2)
		local ty1 = type(t1)
		local ty2 = type(t2)
		if ty1 ~= ty2 then return false end
		-- non-table types can be directly compared
		if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
		for k1,v1 in pairs(t1) do
			local v2 = t2[k1]
			if v2 == nil or not self:deepcompare(v1,v2) then return false end
		end
		for k2,v2 in pairs(t2) do
			local v1 = t1[k2]
			if v1 == nil or not self:deepcompare(v1,v2) then return false end
		end
		return true
	end,
	
	-- Sets a group to use the specified text layout
	SetLayoutToGroup = function(self, gs, GUID)
		gs.SettingsPerView.icon.TextLayout = GUID
		
		-- the group setting is a fallback for icons, so there is no reason to set the layout for individual icons
		for iconID, ics in pairs(gs.Icons) do
			ics.SettingsPerView.icon.TextLayout = nil
		end
	end,
	
	
	---------- Upgrade method ----------
	group = function(self, gs)
		-- Create a layout table to start storing text layout data for this group in.
		local layout = TMW.db.global.TextLayouts[0]
		
		-- We don't actually want to define this as a real text layout yet, so take it out of TextLayouts.
		TMW.db.global.TextLayouts[0] = nil
		
		-- The old text system had two displays
		layout.n = 2
		
		-- These are constants for each text display:
		-- Display 1 is the binding/label text
		layout[1].StringName = L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"]
		layout[1].SkinAs = "HotKey" 
		
		-- Display 2 is the stack text
		layout[2].StringName = L["TEXTLAYOUTS_DEFAULTS_STACKS"]
		layout[2].DefaultText = "[Stacks:Hide(0)]"
		layout[2].SkinAs = "Count"
		
		for i = 1, layout.n do
			-- displaySettings holds the settings for the text layout being created
			local displaySettings = layout[i]
			
			-- settingsKey is the key that corresponds to the old text settings
			local settingsKey = self.pairs[i]
			-- source holds the old text settings
			local source = gs.Fonts and gs.Fonts[settingsKey]
			
			-- Iterate over all of the old text settings.
			for _, setting in TMW:Vararg(
				"Name",
				"Size",
				"x",
				"y",
				"point",
				"relativePoint",
				"Outline",
				"OverrideLBFPos",
				"ConstrainWidth"
			) do
				-- (not source) :: If the old text settings are nil, then the entire display used all default settings, so inherit from defaults.
					-- (So Ace3DB purged it completely because it wasn't needed)
				-- (source[setting] == nil) :: If this specific setting is nil, then it was default, so inherit from defaults. 
				if not source or source[setting] == nil then
					-- self[settingsKey][setting] holds the old defaults for the text display we are creating a layout for.					
					displaySettings[setting] = self[settingsKey][setting]
				else
					-- This setting was defined, so use the setting that was defined for it.
					displaySettings[setting] = source[setting]
				end
			end
			
			-- OverrideLBFPos isn't used anymore, instead SkinAs is set to "" (signifying don't skin this display)
			if displaySettings.OverrideLBFPos then
				displaySettings.SkinAs = ""
				displaySettings.OverrideLBFPos = nil
			end
			
			-- Fix this typo (MONOCHORME) which has probably been here at least a year without being noticed... until now
			if displaySettings.Outline == "MONOCHORME" then
				displaySettings.Outline = "MONOCHROME"
			end
		end
		
		-- We are done constructing a text layout out of this group's old text settings.
		-- Now, check and see if there alredy exists a layout with the exact same settings from a previous group's upgrade.
		for GUID, layoutSettings in pairs(TMW.db.global.TextLayouts) do
		
			if layoutSettings ~= layout then -- I don't know why this check was written, but leave it in.
			
				-- These three settings don't actually impact the group, so ignore them in the comparison.
				-- Save them into variables, and then set them to their defaults.
				local name, GUID, noedit = layoutSettings.Name, layoutSettings.GUID, layoutSettings.NoEdit
				layoutSettings.Name, layoutSettings.GUID, layoutSettings.NoEdit = "", "", false
				
				-- Do the actual comparison to check if the layout we just created is a duplicate of one that already exists.
				local isDuplicate = self:deepcompare(layoutSettings, layout)
				
				-- Restore the settings that we just set to defaults.
				layoutSettings.Name, layoutSettings.GUID, layoutSettings.NoEdit = name, GUID, noedit
				
				if isDuplicate then
					-- If the layout we just created is a duplicate of another, then set the pre-existing layout to the group.
					-- The layout we just created just becomes garbage and will get picked up by the gc eventually.
					self:SetLayoutToGroup(gs, GUID)
					return
				end
			end
		end
		
		-- If we've made it to this point, then the layout we just created wasn't a duplicate.
		
		-- Create a GUID for the new layout and set it.
		local GUID = TMW:GenerateGUID("textlayout", TMW.CONST.GUID_SIZE)
		layout.GUID = GUID
		
		-- Determine a name for the new layout:
		-- Start with this as the base name.
		local Name = L["TEXTLAYOUTS_DEFAULTS_ICON1"]
		repeat
			-- Loop until we find a name that isn't used by any other layouts.
			local found
			for k, layoutSettings in pairs(TMW.db.global.TextLayouts) do
				if layoutSettings.Name == Name then
					-- The current name is in use.
					found = true
					
					-- Increase the number at the end of the name ("Icon Layout 1" becomes "Icon Layout 2", etc...)
					Name = TMW.oneUpString(Name) or GUID -- fallback on the GUID if we cant increment the name for some reason
					
					-- Break the inner loop so that we can go through the outer loop again and check if the new name is in use.
					break
				end
			end
		until not found
		
		-- A unique name has now been determined. Set it on the layout.
		layout.Name = Name
		
		-- Store the layout under the new GUID in the TextLayouts table.
		TMW.db.global.TextLayouts[GUID] = layout
		
		-- Set the new layout to the group we are upgrading.
		self:SetLayoutToGroup(gs, GUID)
	end,
})

TMW:RegisterUpgrade(51002, {
	-- This is the upgrade that handles the transition from TMW's ghetto text substitutions to DogTag.
	
	-- self.translateString is a function defined in the v51002 upgrade in TellMeWhen.lua.
	-- It is the method that actually converts between the old and new text subs.
	
	-- This upgrade extends this upgrade to text displays
	-- (The old static text displays, not the new ones that are the whole purpose of this file.)
	
	icon = function(self, ics)
		local BindText = ics.BindText or ""
		
		-- Meta icons and default icons didn't implement BindText, so don't upgrade them.
		if ics.Type ~= "meta" and ics.Type ~= "" then
			ics.SettingsPerView.icon.Texts[1] = self:translateString(BindText)
		end
		ics.BindText = nil
		
		-- The stack text display was static, and it already corresponds to the default text for this text display, so do nothing.
		-- ics.SettingsPerView.icon.Texts[2] = "[Stacks:Hide(0)]"
	end,
})

TMW:RegisterCallback("TMW_UPGRADE_PERFORMED", function(event, type, upgradeData, ...)
	-- When a global settings upgrade is requested, update all text layouts.
	
	if type == "global" then
		for GUID, settings in pairs(TMW.db.global.TextLayouts) do
			TMW:Upgrade("textlayout", upgradeData, settings, GUID)
		end
	end
end)





-- -------------------
-- UTILITY FUNCTIONS
-- -------------------

function TEXT:GetTextLayoutForIconSettings(gs, ics, view)
	-- arg3, view, is optional. Defaults to the current view
	
	view = view or gs.View
	
	-- Get the GUID defined by the icon for the current IconView
	local GUID = ics.SettingsPerView[view].TextLayout
	
	-- If the icon defines the GUID as a blank string,
	-- it should default to whatever the group defines. (Intended behavior, btw.)
	if not GUID or GUID == "" then
		GUID = gs.SettingsPerView[view].TextLayout
	end
	
	-- Rawget from TextLayouts to see if the layout exists.
	local layoutSettings = GUID and rawget(TMW.db.global.TextLayouts, GUID)
	
	local isFallback
	if not layoutSettings then
		isFallback = true
		
		-- If the layout doesn't exist, fall back on the default layout for the current IconView
		local GroupDefaultsPerView = TMW.Group_Defaults.SettingsPerView
		GUID = GroupDefaultsPerView[view] and GroupDefaultsPerView[view].TextLayout
		
		-- If the current IconView doesn't define a default layout (or if it doesn't define DefaultsPerView),
		-- then fall back on the default for all IconViews, GUID == "", the blank layout
		if not GUID then
			GUID = ""
		end
		
		-- Attempt to find the layout settings again.
		layoutSettings = rawget(TMW.db.global.TextLayouts, GUID)
		
		-- Freak the fuck out if it wasn't found;
		-- Only happens if a view defines a default layout but doesn't actually define layout itself.
		assert(layoutSettings, ("Couldn't find default text layout with GUID %q for IconView %q"):format(GUID, view))
	end
	
	return GUID, layoutSettings, isFallback
end

function TEXT:GetTextLayoutForIcon(icon, view)
	return TEXT:GetTextLayoutForIconSettings(icon.group:GetSettings(), icon:GetSettings(), view)
end

function TEXT:GetTextFromSettingsAndLayout(Texts, layoutSettings, textID)
	TMW:ValidateType(2, "TEXT:GetTextForIconAndLayout()", Texts, "table")
	TMW:ValidateType(3, "TEXT:GetTextForIconAndLayout()", layoutSettings, "table")
	TMW:ValidateType(4, "TEXT:GetTextForIconAndLayout()", textID, "number")
	
	local text = Texts[textID]
	
	if not text then
		if textID > layoutSettings.n then
			error("textID is out of range for the given layout!", 2)
		end
	
		text = layoutSettings[textID].DefaultText
	end
	
	return text
end





-- -------------------
-- ICON MODULE
-- -------------------
	
local Texts = TMW:NewClass("IconModule_Texts", "IconModule")

Texts:RegisterConfigPanel_XMLTemplate(400, "TellMeWhen_TextDisplayOptions")


function Texts:OnNewInstance(icon)
	self.kwargs = {} -- Stores the DogTag kwargs table that will be used by the module for all its text displays/FontStrings.
	self.fontStrings = {} -- Stores all of the FontStrings that the midle has created.
	
	self.container = CreateFrame("Frame", nil, icon)
	self.container:SetAllPoints(icon)
	self.container:SetFrameLevel(icon:GetFrameLevel() + 3)
	
	-- We need to make sure that all strings that are Masque skinnable are always created
	-- so that they can be available to IconModule_IconContainer_Masque when it requests them.
	-- If Masque isn't installed, then don't bother - we will create them normally on demand.
	if LMB then
		for key in pairs(TEXT.MasqueSkinnableTexts) do
			if key ~= "" then
				local fontString = self:CreateFontString(key)
				self:SetSkinnableComponent(key, fontString)
			end
		end
	end
end

function Texts:OnDisable()
	for id, fontString in pairs(self.fontStrings) do
		
		DogTag:RemoveFontString(fontString)		
		
		fontString:Hide()
	end
end

function Texts:CreateFontString(id)
	local container = self.container
	
	local fontString = container:CreateFontString(self:GetChildNameBase() .. id, "ARTWORK", "NumberFontNormalSmall")

	-- LDT-Unit has a script running on a timer that automatically cancels all queued updates for icons with kwargs.unit == "mouseover"
	-- This doesn't make any fucking sense to me at all, so I added a flag to LDT-Unit-3.0 that lets me disable this behavior on a per-fontstring basis.
	fontString.__DT_dontcancelupdatesforMO = true

	self.fontStrings[id] = fontString

	-- Remove this event if you are reading this comment in the year 2015 or later
	TMW:Fire("TMW_DEBUG_FS_CREATED", self.icon, fontString, id)
	
	return fontString
end


local function reSetup(self, event, icon)
	self:SetupForIcon(icon)
	return true -- Signal RegisterSelfDestructingCallback to unregister.
end

local function rotate(self, degrees)
	local anim = self.anim
	if not anim then
		if degrees == 0 then
			return
		end

		self.animGroup = self:CreateAnimationGroup()

		anim = self.animGroup:CreateAnimation("Rotation")
		anim:SetDuration(0)
		anim:SetEndDelay(math.huge)

		self.anim = anim
	end
	
	if degrees ~= 0 then
		anim:SetDegrees(degrees)
		anim:SetOrigin("CENTER", 0, 0)
		
		self.animGroup:Play()
	else
		self.animGroup:Stop()
	end
end


function Texts:GetAnchor(layoutSettings, anchorSettings, fontStringID)
	local icon = self.icon

	local relativeTo = anchorSettings.relativeTo
	local err = nil

	if relativeTo:sub(1, 2) == "$$" then
		-- If relativeTo starts with "$$", then it points at another fontString by textID (index).
		-- Get that index:
		local index = tonumber(relativeTo:sub(3))

		if index <= layoutSettings.n then
			-- The index is valid for the current layout's number of fontStrings.
			local fontStringSettingsOfAnchor = layoutSettings[index]

			-- Find the actual fontString being anchored to.
			local relativeToID = self:GetFontStringID(index, fontStringSettingsOfAnchor)
			relativeTo = self.fontStrings[relativeToID]
		else
			-- The index isn't valid for the current layout.
			relativeTo = nil
		end

		if not relativeTo then
			-- If the index was invalid, or by some incident of fuckery the fontString doesn't exist when it should,
			-- show an error.
			err = L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"]:format(fontStringID, index, index, fontStringID)
		end
	else
		-- If relativeTo doesn't start with "$$", then the anchor is relative to an icon module's frame.
		-- The full name of the frame being anchored to will be as such:
		relativeTo = icon:GetName() .. relativeTo


		if not _G[relativeTo] then
			if self.hasSetupOnce then
				-- We have already setup once, and the frame doesn't exist.
				-- This probably means that it never will, so show an error.
				err = L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"]:format(anchorSettings.relativeTo:gsub("IconModule_", ""))

				relativeTo = nil
			else
				-- Run the text setup again after the icon is updated if we were missing an anchor frame.
				-- It might just be an issue with the module implementation order, although IconModule_Texts should always be last.
				TMW:RegisterSelfDestructingCallback("TMW_ICON_SETUP_POST", reSetup, self)

				-- Temporarily anchor to the icon.
				relativeTo = icon
			end
		end
	end

	return relativeTo, err
end


function Texts:CheckAnchorValidity()
	local _, layoutSettings = TMW.TEXT:GetTextLayoutForIcon(self.icon) 

	for textID, fontStringSettings in TMW:InNLengthTable(layoutSettings) do
		local fontStringID = self:GetFontStringID(textID, fontStringSettings)
		local fontString = self.fontStrings[fontStringID]

		for _, anchorSettings in TMW:InNLengthTable(fontStringSettings.Anchors) do
			
			-- Determine what the actual frame is for the anchor.
			local relativeTo, err = self:GetAnchor(layoutSettings, anchorSettings, fontStringID)
			
			if err then
				return err
			end
		end
	end

	return nil
end

function Texts:SetupForIcon(sourceIcon)
	local icon = self.icon
	
	
	-- The strings that we will set on the fontStrings
	local Texts = sourceIcon:GetSettingsPerView().Texts
	-- The layout settings that will be used to style the fontStrings.
	local _, layoutSettings = TMW.TEXT:GetTextLayoutForIcon(sourceIcon) 


	-- Store these tables on the moudle.
	self.layoutSettings = layoutSettings
	self.Texts = Texts
	

	-- Set the kwargs table to the correct vars for the source icon.
	wipe(self.kwargs)
	self.kwargs.icon = sourceIcon:GetGUID()
	self.kwargs.unit = sourceIcon.attributes.dogTagUnit
	

	-- Queue all fontStrings for removal from DogTag.
	-- Don't remove them all outright because DogTag uses a fuckton of CPU to do this.
	-- This var will be set false on still-valid strings, so we will only remove ones we don't use.
	for _, fontString in pairs(self.fontStrings) do
		fontString.TMW_QueueForRemoval = true
	end
	local queueMasqeSkin = nil

	if layoutSettings then
		-- Detect if masque skinning is being used on this icon.
		local isDefaultSkin = not TMW.C.IconModule_IconContainer_Masque:IsIconSkinned(icon)

		-- First, create all the fontStrings that will be used.
		-- This is done first so that fontStrings that anchor to other fontStrings via the layout settings
		-- can anchor to them in the loop after this one with no issue.
		for textID, fontStringSettings in TMW:InNLengthTable(layoutSettings) do

			-- Figure out the identifier for the fontString.
			-- This will be a string if its being skinned with masque, or a number if not.
			local fontStringID = self:GetFontStringID(textID, fontStringSettings)
			
			-- Gets an existing fontString, or creates one if it doesn't exist.
			local fontString = self.fontStrings[fontStringID] or self:CreateFontString(fontStringID)


			fontString:Show()
			fontString.settings = fontStringSettings
		end
		
		-- Now, go through and setup all the fontStrings that we just created.
		for textID, fontStringSettings in TMW:InNLengthTable(layoutSettings) do
			local fontStringID = self:GetFontStringID(textID, fontStringSettings)
			local fontString = self.fontStrings[fontStringID]
	
			
			-- Setup the fontString if it isn't going to get skinned by Masque.
			if isDefaultSkin or fontStringSettings.SkinAs == "" then

				-- Font settings:
				fontString:SetFont(LSM:Fetch("font", fontStringSettings.Name), fontStringSettings.Size, fontStringSettings.Outline)
				
				fontString:SetJustifyH(fontStringSettings.Justify)
				fontString:SetJustifyV(fontStringSettings.JustifyV)
				
				fontString:SetShadowOffset(fontStringSettings.Shadow, -fontStringSettings.Shadow)



				-- Position settings:
				fontString:SetWidth(fontStringSettings.Width)
				fontString:SetHeight(fontStringSettings.Height)

				rotate(fontString, fontStringSettings.Rotate)


				fontString:ClearAllPoints()
				local setPoint = fontString.__MSQ_SetPoint or fontString.SetPoint
				
				for _, anchorSettings in TMW:InNLengthTable(fontStringSettings.Anchors) do
					
					-- Determine what the actual frame is for the anchor.
					local relativeTo, err = self:GetAnchor(layoutSettings, anchorSettings, fontStringID)
					
					if relativeTo then
						-- Finally, set the point. We call it like this because we need to use Masque's SetPoint if it exists.
						setPoint(fontString, anchorSettings.point, relativeTo, anchorSettings.relativePoint, anchorSettings.x, anchorSettings.y)

						-- If there was an error, it will be shown in the icon editor - we won't print to chat.
					end
				end
			else
				queueMasqeSkin = true
			end
		end
	end
	
	-- TMW_QueueForRemoval gets set to nil for valid stings in OnKwargsUpdated, among other things
	self:OnKwargsUpdated()
	
	-- Remove from DogTag all the fontStrings that don't end up getting used.
	-- See the beginning of this function to see why we do it like this.
	for fontStringID, fontString in pairs(self.fontStrings) do		
		if fontString.TMW_QueueForRemoval then
			fontString.TMW_QueueForRemoval = nil
			DogTag:RemoveFontString(fontString)
			fontString:Hide()
		end
	end
	if queueMasqeSkin then

	end

	self.hasSetupOnce = true
end

function Texts:GetFontStringID(textID, fontStringSettings)
	local fontStringID = textID
	local SkinAs = fontStringSettings.SkinAs
	if SkinAs ~= "" then
		fontStringID = SkinAs
	end
	return fontStringID
end

function Texts:OnKwargsUpdated()
	if self.layoutSettings and self.Texts then
		for textID, fontStringSettings in TMW:InNLengthTable(self.layoutSettings) do
			local fontString = self.fontStrings[self:GetFontStringID(textID, fontStringSettings)]
			
			local text = TEXT:GetTextFromSettingsAndLayout(self.Texts, self.layoutSettings, textID)
			
			if fontString and text and text ~= "" then
				-- We let DogTag do the styling of the outline on our texts.
				-- Convert the style setting to a DogTag for the same style.
				local styleString = ""
				if fontStringSettings.Outline == "OUTLINE" or fontStringSettings.Outline == "THICKOUTLINE" then
					styleString = styleString .. ("[%s]"):format(fontStringSettings.Outline)
				end
				
				-- Let :SetupForIcon() know that we want to keep this fontString.
				fontString.TMW_QueueForRemoval = nil
				
				-- Register the fontString with DogTag.
				DogTag:AddFontString(fontString, self.icon, styleString .. text, TMW.DOGTAG.nsList, self.kwargs)
			end
		end
	end
end

function Texts:DOGTAGUNIT(icon, dogTagUnit)
	if self.kwargs.unit ~= dogTagUnit then
		self.kwargs.unit = dogTagUnit
		self:OnKwargsUpdated()
	end
end
Texts:SetDataListener("DOGTAGUNIT")
