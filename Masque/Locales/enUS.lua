--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Locales\enUS.lua
	* Author.: StormFX

]]

local _, Core = ...

-- Locales Table
local L = {}

-- Thanks, Tekkub/Rabbit.
Core.Locale = setmetatable(L, {
	__index = function(self, k)
		self[k] = k
		return k
	end
})

-- enUS/enGB for Reference

	-- ToC

		-- L["A dynamic button skinning add-on."] = "A dynamic button skinning add-on."

	-- Core

		-- L["Addons"] = "Addons"
		-- L["Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."] = "Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."
		-- L["Adjust the skin of all buttons registered to %s: %s."] = "Adjust the skin of all buttons registered to %s: %s."
		-- L["Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."] = "Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."
		-- L["Backdrop Settings"] = "Backdrop Settings"
		-- L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."] = "Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."
		-- L["Checked"] = "Checked"
		-- L["Click this button to load Masque's options. You can also use the %s or %s chat command."] = "Click this button to load Masque's options. You can also use the %s or %s chat command."
		-- L["Click to open Masque's options window."] = "Click to open Masque's options window."
		-- L["Color"] = "Color"
		-- L["Colors"] = "Colors"
		-- L["Cooldown"] = "Cooldown"
		-- L["Debug Mode"] = "Debug Mode"
		-- L["Disable the skinning of this group."] = "Disable the skinning of this group."
		-- L["Disable"] = "Disable"
		-- L["Disabled"] = "Disabled"
		-- L["Enable the Backdrop texture."] = "Enable the Backdrop texture."
		-- L["Enable the Minimap icon."] = "Enable the Minimap icon."
		-- L["Enable"] = "Enable"
		-- L["Equipped"] = "Equipped"
		-- L["Flash"] = "Flash"
		-- L["General"] = "General"
		-- L["Global"] = "Global"
		-- L["Gloss Settings"] = "Gloss Settings"
		-- L["Highlight"] = "Highlight"
		-- L["Load Masque Options"] = "Load Masque Options"
		-- L["Loading Masque Options..."] = "Loading Masque Options..."
		-- L["Masque debug mode disabled."] = "Masque debug mode disabled."
		-- L["Masque debug mode enabled."] = "Masque debug mode enabled."
		-- L["Masque is a dynamic button skinning add-on."] = "Masque is a dynamic button skinning add-on."
		-- L["Minimap Icon"] = "Minimap Icon"
		-- L["Normal"] = "Normal"
		-- L["Opacity"] = "Opacity"
		-- L["Profiles"] = "Profiles"
		-- L["Pushed"] = "Pushed"
		-- L["Reset Skin"] = "Reset Skin"
		-- L["Reset all skin options to the defaults."] = "Reset all skin options to the defaults."
		-- L["Set the color of the Backdrop texture."] = "Set the color of the Backdrop texture."
		-- L["Set the color of the Checked texture."] = "Set the color of the Checked texture."
		-- L["Set the color of the Cooldown animation."] = "Set the color of the Cooldown animation."
		-- L["Set the color of the Disabled texture."] = "Set the color of the Disabled texture."
		-- L["Set the color of the Equipped item texture."] = "Set the color of the Equipped item texture."
		-- L["Set the color of the Flash texture."] = "Set the color of the Flash texture."
		-- L["Set the color of the Gloss texture."] = "Set the color of the Gloss texture."
		-- L["Set the color of the Highlight texture."] = "Set the color of the Highlight texture."
		-- L["Set the color of the Normal texture."] = "Set the color of the Normal texture."
		-- L["Set the color of the Pushed texture."] = "Set the color of the Pushed texture."
		-- L["Set the intensity of the Gloss color."] = "Set the intensity of the Gloss color."
		-- L["Set the skin for this group."] = "Set the skin for this group."
		-- L["Skin"] = "Skin"
		-- L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."] = "This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."

