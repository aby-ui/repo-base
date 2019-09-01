if true then return end

local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")

local module
placeholderNames = {}

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function createPlaceholder()
	local placeholderNames = placeholderNames
	local count = tablelength(placeholderNames) > 0 or 1
	local name = "CB_"..L["Placeholder"]..tablelength(placeholderNames)
	placeholderNames[name] = true
	ChocolateBar:AddObjectOptions(name, module:NewPlaceholder(name))
end

local function deleteAllPlaceholder()
	
end

local options = {
		inline = true,
		name=L["Placeholder"],
		type="group",
		order = 1,
		args={
			label1 = {
				order = 1,
				type = "description",
				name = L["Creates a new plugin to use as a placeholder."],
			},
			newPlaceholder = {
				type = 'execute',
				order = 2,
				name = L["Create Placeholder"],
				desc = L["Creates a new plugin to use as a placeholder."],
				func = createPlaceholder,
			},
			delPlaceholder = {
				type = 'execute',
				order = 3,
				name = L["Delete Placeholders"],
				desc = L["Removes all placeholders"],
				func = deleteAllPlaceholder,
			},
			label2 = {
				order = 3,
				type = "description",
				name = L["Tipp: Set the width behavior to fixed and adjust the the max text width to scale the placeholder."],
			},
	 },
}

module = ChocolateBar:NewModule("Placeholder", defaults, options)

local function removePlaceholder(info)
	local cleanName = info[#info-2]
	--local name = chocolateOptions[cleanName].desc
	moduleDB.placeholderNames[cleanName] = nil
	ChocolateBar:DisableDataObject(cleanName)
	ChocolateBar:RemovePluginOptions(cleanName)
end


local function addPlaceholderOptionsToPlugins()
	for name, _ in pairs(placeholderNames) do
		ChocolateBar:AddCustomPluginOptions(name, placeholderPluginOptions)
	end
end

function module:OnInitialize(moduleDB)
	placeholderNames = moduleDB.placeholderNames or {}
	moduleDB.placeholderNames = placeholderNames
	for name, _ in pairs(placeholderNames) do
		self:NewPlaceholder(name)
	end
end

function module:NewPlaceholder(name)
	placeholder = LibStub("LibDataBroker-1.1"):NewDataObject(name, {
		type = "data source",
		label = name,
		text  = "",
		OnClick = onRightClick,
	})
	return placeholder
end

function module:OnOpenOptions()
	addPlaceholderOptionsToPlugins()
end

placeholderPluginOptions = {
		inline = true,
		name=L["Placeholder Options"],
		type="group",
		order = 1,
		args={
			label = {
				order = 1,
				type = "description",
				name = L["Tipp: Set the width behavior to fixed and adjust the the max text width to scale the placeholder."],
			},
			disablePlaceholder = {
				type = 'execute',
				order = 0,
				name = L["Remove Placeholder"],
				desc = L["Remove this Placeholder"],
				func = removePlaceholder,
		  },
	 },
}
