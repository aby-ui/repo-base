local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Clicks"))
end
local L = Gladius.L

-- Global functions
local pairs = pairs
local string = string

local FOCUS = FOCUS
local MACRO = MACRO
local TARGET = TARGET

local Clicks = Gladius:NewModule("Clicks", false, false, {
	clickAttributes = {
		["Left"] = { button = "1", modifier = "", action = "target", macro = ""},
		["Right"] = { button = "2", modifier = "", action = "focus", macro = ""},
	},
})

function Clicks:OnEnable()
	-- Table that holds all of the secure frames to apply click actions to
	self.secureFrames = self.secureFrames or {}
end

function Clicks:OnDisable()
	-- Iterate over all the secure frames and disable any attributes
	for _, t in pairs(self.secureFrames) do
		for frame, _ in pairs(t) do
			for _, attr in pairs(Gladius.dbi.profile.clickAttributes) do
				frame:SetAttribute(attr.modifier.."type"..attr.button, nil)
			end
		end
	end
end

-- Needed to not throw Lua errors <,<
function Clicks:GetAttachTo()
	return ""
end

-- Registers a secure frame and immediately applies
-- Click actions to it
function Clicks:RegisterSecureFrame(unit, frame)
	if not self.secureFrames[unit] then
		self.secureFrames[unit] = { }
	end
	if not self.secureFrames[unit][frame] then
		self.secureFrames[unit][frame] = true
		self:ApplyAttributes(unit, frame)
	end
end

-- Finds all the secure frames belonging to a specific unit and registers them
-- Uses [module:GetFrame()].secure to find the frames
function Clicks:GetSecureFrames(unit)
	-- Add the default secure frame
	self:RegisterSecureFrame(unit, Gladius.buttons[unit].secure)
	-- Find secure frames in other modules
	for m, _ in pairs(Gladius.modules) do
		local frame = Gladius:GetParent(unit, m)
		if frame and frame.secure then
			self:RegisterSecureFrame(unit, frame.secure)
		end
	end
end

function Clicks:Update(unit)
	-- Update secure frame table
	self:GetSecureFrames(unit)
	-- Apply attributes to the frames
	for frame, _ in pairs(self.secureFrames[unit]) do
		self:ApplyAttributes(unit, frame)
	end
end

-- Applies attributes to a specific frame
function Clicks:ApplyAttributes(unit, frame)
	frame:SetAttribute("unit", unit)
	for _, attr in pairs(Gladius.dbi.profile.clickAttributes) do
		frame:SetAttribute(attr.modifier.."type"..attr.button, attr.action)
		if attr.action == "macro" and attr.macro ~= "" then
			frame:SetAttribute(attr.modifier.."macrotext"..attr.button, string.gsub(attr.macro, "*unit", unit))
		elseif attr.action == "spell" and attr.macro ~= "" then
			frame:SetAttribute(attr.modifier.."spell"..attr.button, attr.macro)
		end
	end
end

function Clicks:Test(unit)
	-- Set arena1 to player
	for frame, _ in pairs(self.secureFrames[unit]) do
		frame:SetAttribute("unit", "player")
	end
end

local function getOption(info)
	local key = info[#info - 2]
	return Gladius.dbi.profile.clickAttributes[key][info[#info]]
end

local function setOption(info, value)
	local key = info[#info - 2]
	Gladius.dbi.profile.clickAttributes[key][info[#info]] = value
	Gladius:UpdateFrame()
end

local CLICK_BUTTONS = {["1"] = L["Left"], ["2"] = L["Right"], ["3"] = L["Middle"], ["4"] = L["Button 4"], ["5"] = L["Button 5"]}
local CLICK_MODIFIERS = {[""] = L["None"], ["ctrl-"] = L["ctrl-"], ["shift-"] = L["shift-"], ["alt-"] = L["alt-"]}

function Clicks:GetOptions()
	local addAttrButton = "1"
	local addAttrMod = ""
	local options = {
		attributeList = {
			type = "group",
			name = L["Click Actions"],
			order = 1,
				args = {
					add = {
					type = "group",
					name = L["Add click action"],
					inline = true,
					order = 1,
					args = {
						button = {
							type = "select",
							name = L["Mouse button"],
							desc = L["Select which mouse button this click action uses"],
							values = CLICK_BUTTONS,
							order = 10,
							get = function(info)
								return addAttrButton
							end,
							set = function(info, value)
								addAttrButton = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
						},
						modifier = {
							type = "select",
							name = L["Modifier"],
							desc = L["Select a modifier for this click action"],
							values = CLICK_MODIFIERS,
							order = 20,
							get = function(info)
								return addAttrMod
							end,
							set = function(info,
								value) addAttrMod = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
						},
						add = {
							type = "execute",
							name = L["Add"],
							order = 30,
							func = function()
								local attr = addAttrMod ~= "" and CLICK_MODIFIERS[addAttrMod]..CLICK_BUTTONS[addAttrButton] or CLICK_BUTTONS[addAttrButton]
								if not Gladius.db.clickAttributes[attr] then
									-- Add to db
									Gladius.db.clickAttributes[attr] = {
										button = addAttrButton,
										modifier = addAttrMod,
										action = "target",
										macro = ""
									}
									-- Add to options
									Gladius.options.args[self.name].args.attributeList.args[attr] = self:GetAttributeOptionTable(attr, self.order)
									-- Update
									Gladius:UpdateFrame()
								end
							end,
						},
					},
				},
			},
		},
	}
	-- Attributes
	local order = 1
	for attr, _ in pairs(Gladius.dbi.profile.clickAttributes) do
		options.attributeList.args[attr] = self:GetAttributeOptionTable(attr, order)
		order = order + 1
	end
	return options
end

function Clicks:GetAttributeOptionTable(attribute, order)
	return {
		type = "group",
		name = attribute,
		childGroups = "tree",
		order = order,
		disabled = function()
			return not Gladius.dbi.profile.modules[self.name]
		end,
		args = {
			delete = {
				type = "execute",
				name = L["Delete Click Action"],
				func = function()
					-- Remove from db
					Gladius.db.clickAttributes[attribute] = nil
					-- Remove from options
					Gladius.options.args[self.name].args.attributeList.args[attribute] = nil
					-- Update
					Gladius:UpdateFrame()
				end,
				order = 1,
			},
			action = {
				type = "group",
				name = L["Action"],
				inline = true,
				get = getOption,
				set = setOption,
				order = 2,
				args = {
					action = {
						type = "select",
						name = L["Action"],
						desc = L["Select what this Click Action does"],
						values = {["macro"] = MACRO, ["target"] = TARGET, ["focus"] = FOCUS, ["spell"] = L["Cast Spell"]},
						order = 10,
					},
					sep = {
						type = "description",
						name = "",
						width = "full",
						order = 15,
					},
					macro = {
						type = "input",
						multiline = true,
						name = L["Spell Name / Macro Text"],
						desc = L["Select what this Click Action does"],
						width = "double",
						order = 20,
					},
				},
			},
		},
	}
end