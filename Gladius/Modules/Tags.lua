local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Tags"))
end
local L = Gladius.L
local LSM

-- Global Functions
local loadstring = loadstring
local pairs = pairs
local strfind = string.find
local strformat = string.format
local strgmatch = string.gmatch
local strgsub = string.gsub

local UnitClass = UnitClass
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitName = UnitName
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitRace = UnitRace

local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local Tags = Gladius:NewModule("Tags", false, false, {
	tagsTexts = {
		["HealthBar Left Text"] = {
			attachTo = "HealthBar",
			position = "LEFT",
			offsetX = 2,
			offsetY = 0,
			size = 11,
			color = {r = 1, g = 1, b = 1, a = 1},
			text = "[name:status]",
		},
		["HealthBar Right Text"] = {
			attachTo = "HealthBar",
			position = "RIGHT",
			offsetX = - 2,
			offsetY = 0,
			size = 11,
			color = {r = 1, g = 1, b = 1, a = 1},
			text = "[health:percentage]",
		},
		["PowerBar Left Text"] = {
			attachTo = "PowerBar",
			position = "LEFT",
			offsetX = 2,
			offsetY = 0,
			size = 11,
			color = {r = 1, g = 1, b = 1, a = 1},
			text = "[spec] [class]",
		},
		["PowerBar Right Text"] = {
			attachTo = "PowerBar",
			position = "RIGHT",
			offsetX = - 2,
			offsetY = 0,
			size = 11,
			color = {r = 1, g = 1, b = 1, a = 1},
			text = "[power:short]/[maxpower:short]",
		},
		["TargetBar Left Text"] = {
			attachTo = "TargetBar",
			position = "LEFT",
			offsetX = 2,
			offsetY = 0,
			size = 11,
			color = {r = 1, g = 1, b = 1, a = 1},
			text = "[name:status]",
		},
		["TargetBar Right Text"] = {
			attachTo = "TargetBar",
			position = "RIGHT",
			offsetX = - 2,
			offsetY = 0,
			size = 11,
			color = {r = 1, g = 1, b = 1, a = 1},
			text = "[health:short]/[maxhealth:short] ([health:percentage])",
		},
	},
})

function Tags:OnEnable()
	LSM = Gladius.LSM
	self.version = 4
	-- frame
	if not self.frame then
		self.frame = { }
	end
	-- tags
	if not Gladius.db.tags or Gladius.db.tagsVersion == nil or self.version > Gladius.db.tagsVersion then
		Gladius.db.tags = self:GetTags()
	end
	-- cached functions
	self.func = { }
	-- gather events
	self.events = { }
	for k, v in pairs(Gladius.db.tagsTexts) do
		-- get tags
		for tagName in v.text:gmatch("%[(.-)%]") do
			-- get events
			local tag = Gladius.db.tags[tagName]
			if tag then
				for event in tag.events:gmatch("%S+") do
					if not self.events[event] then
						self.events[event] = { }
					end
					self.events[event][k] = true
				end
			end
		end
	end
	-- register events
	for event in pairs(self.events) do
		if strfind(event, "GLADIUS") then
			self:RegisterMessage(event, "OnMessage")
		else
			self:RegisterEvent(event, "OnEvent")
		end
	end
	Gladius.db.tagsVersion = self.version
end

function Tags:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		for text in pairs(self.frame[unit]) do
			self.frame[unit][text]:Hide()
		end
	end
end

function Tags:OnProfileChanged()
	Gladius.dbi.profile.tags = self:GetTags()
end

function Tags:GetAttachTo()
	return ""
end

function Tags:GetFrame(unit)
	return ""
end

function Tags:OnMessage(unit, event)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.events[event] then
		-- update texts
		for text, _ in pairs(self.events[event]) do
			self:UpdateText(unit, text)
		end
	end
end

function Tags:OnEvent(event, unit)
	if not unit then
		return
	end

	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.events[event] then
		-- update texts
		for text, _ in pairs(self.events[event]) do
			self:UpdateText(unit, text)
		end
	end
end

function Tags:CreateFrame(unit, text)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create frame
	self.frame[unit][text] = button:CreateFontString("Gladius"..self.name..unit..text, "OVERLAY")
end

function Tags:UpdateText(unit, text)
	if not self.frame[unit] then
		return
	end
	if not self.frame[unit][text] then
		return
	end
	-- tags
	if not Gladius.dbi.profile.tags then
		Gladius.dbi.profile.tags = self:GetTags()
	end
	-- set unit
	local unitParameter = unit
	local parent = self.frame[unit][text]:GetParent()
	if parent and parent.unit then
		unitParameter = parent.unit
	end
	-- update tag
	local tagText = Gladius.db.tagsTexts[text].text
	for tagName in strgmatch(Gladius.db.tagsTexts[text].text, "%[(.-)%]") do
		local tag = Gladius.db.tags[tagName]
		if tag then
			local escapedText
			-- clear the tag, if unit does not exist
			if not Gladius.test and not UnitName(unitParameter) and not tag.preparation then
				escapedText = ""
			else
				-- create function
				local func = self.func[tagName]
				local error
				if not func and tag.func then
					func, error = loadstring("local strformat = string.format return "..tag.func)
					self.func[tagName] = func
				end
				-- escape return string
				local funcText = func()
				if funcText and unitParameter then
					escapedText = strgsub(funcText(unitParameter) or "", "%%", "%%%%")
				else
					escapedText = ""
				end
			end
			-- replace tag
			tagText = strgsub(tagText, "%["..tagName.."%]", escapedText)
		end
	end
	self.frame[unit][text]:SetText(tagText or "")
end

function Tags:Update(unit)
	if not self.frame[unit] then
		self.frame[unit] = { }
	end
	for text, _ in pairs(Gladius.db.tagsTexts) do
		local module = Gladius:GetModule(Gladius.db.tagsTexts[text].attachTo)
		if module and module.IsEnabled and module.frame and module.frame[unit] then
			-- create frame
			if not self.frame[unit][text] then
				self:CreateFrame(unit, text)
			end
			-- update frame
			self.frame[unit][text]:ClearAllPoints()
			self.frame[unit][text]:SetPoint(Gladius.db.tagsTexts[text].position, module.frame[unit], Gladius.db.tagsTexts[text].position, Gladius.db.tagsTexts[text].offsetX, Gladius.db.tagsTexts[text].offsetY)
			self.frame[unit][text]:SetParent(module.frame[unit])
			self.frame[unit][text]:SetFont(LSM:Fetch(LSM.MediaType.FONT, Gladius.db.globalFont), (Gladius.db.useGlobalFontSize and Gladius.db.globalFontSize or Gladius.db.tagsTexts[text].size))
			self.frame[unit][text]:SetTextColor(Gladius.db.tagsTexts[text].color.r, Gladius.db.tagsTexts[text].color.g, Gladius.db.tagsTexts[text].color.b, Gladius.db.tagsTexts[text].color.a)
			self.frame[unit][text]:SetShadowOffset(1, - 1)
			self.frame[unit][text]:SetShadowColor(0, 0, 0, 1)
			-- update text
			self:UpdateText(unit, text)
			-- hide
			self.frame[unit][text]:Hide()
		end
	end
end

function Tags:UpdateColors(unit, text)
	if not self.frame[unit] then
		return
	end
	self.frame[unit][text]:SetTextColor(Gladius.db.tagsTexts[text].color.r, Gladius.db.tagsTexts[text].color.g, Gladius.db.tagsTexts[text].color.b, Gladius.db.tagsTexts[text].color.a)
end

function Tags:Show(unit)
	if not self.frame[unit] then
		self.frame[unit] = { }
	end
	-- update text
	for text, _ in pairs(Gladius.db.tagsTexts) do
		self:UpdateText(unit, text)
	end
	-- show
	for _, text in pairs(self.frame[unit]) do
		text:Show()
	end
end

function Tags:Reset(unit)
	if not self.frame[unit] then
		self.frame[unit] = { }
	end
	-- hide
	for _, text in pairs(self.frame[unit]) do
		text:Hide()
	end
end

function Tags:Test(unit)
	-- test
end

function Tags:GetOptions()
	-- tags
	if not Gladius.dbi.profile.tags then
		Gladius.dbi.profile.tags = self:GetTags()
	end
	-- add text values
	self.addTextAttachTo = "HealthBar"
	self.addTextName = ""
	-- add tag values
	self.addTagName = ""
	local options = {
		textList = {
			type = "group",
			name = L["Texts"],
			order = 1,
			args = {
				add = {
					type = "group",
					name = L["Add text"],
					inline = true,
					order = 1,
					args = {
						name = {
							type = "input",
							name = L["Name"],
							desc = L["Name of the text element"],
							order = 5,
							get = function(info)
								return self.addTextName
							end,
							set = function(info, value)
								self.addTextName = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
						},
						attachTo = {
							type = "select",
							name = L["Text Attach To"],
							desc = L["Attach text to module bar"],
							order = 10,
							values = function()
								local t = { }
								for moduleName, module in pairs(Gladius.modules) do
									if module.isBarOption then
									t[moduleName] = moduleName
									end
								end
								return t
							end,
							get = function(info)
								return self.addTextAttachTo
							end,
							set = function(info, value)
								self.addTextAttachTo = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
						},
						add = {
							type = "execute",
							name = L["Add Text"],
							order = 15,
							func = function()
								local text = self.addTextAttachTo.." "..self.addTextName
								if self.addTextName ~= "" and not Gladius.db.tagsTexts[text] then
									-- add to db
									Gladius.db.tagsTexts[text] = {
										attachTo = self.addTextAttachTo,
										position = "LEFT",
										offsetX = 0,
										offsetY = 0,
										size = 11,
										color = {r = 1, g = 1, b = 1, a = 1},
										text = ""
									}
									-- add to options
									Gladius.options.args[self.name].args.textList.args[text] = self:GetTextOptionTable(text, self.order)
									-- set tags
									Gladius.options.args[self.name].args.textList.args[text].args.tag.args = self.optionTags
									-- update
									Gladius:UpdateFrame()
								end
								self.addTextName = ""
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not self.addTextName or self.addTextName == ""
							end,
						},
					},
				},
			},
		},
		tagList = {
			type = "group",
			name = L["Tags"],
			hidden = function()
				return not Gladius.db.advancedOptions
			end,
			order = 2,
			args = {
				add = {
					type = "group",
					name = L["Add tag"],
					inline = true,
					order = 1,
					args = {
						name = {
							type = "input",
							name = L["Name"],
							desc = L["Name of the tag"],
							order = 5,
							get = function(info)
								return self.addTagName
							end,
							set = function(info, value)
								self.addTagName = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
						},
						add = {
							type = "execute",
							name = L["Add Tag"],
							order = 10,
							func = function()
								if self.addTagName ~= "" and not Gladius.db.tags[self.addTagName] then
									-- add to db
									Gladius.db.tags[self.addTagName] = {
										func = [[function(unit)
										end]],
										events = ""
									}
									-- add to options
									Gladius.options.args[self.name].args.tagList.args[self.addTagName] = self:GetTagOptionTable(self.addTagName, self.order)
									-- add to text option tags
									for text, v in pairs(Gladius.options.args[self.name].args.textList.args) do
										if v.args.tag then
											local tag = self.addTagName
											local tagName = L[tag.."Tag"] ~= tag.."Tag" and L[tag.."Tag"] or strformat(L["Tag: %s"], tag)
											Gladius.options.args[self.name].args.textList.args[text].args.tag.args[tag] = {
												type = "toggle",
												name = tagName,
												get = function(info)
													local key = info[#info - 2]
													-- check if the tag is in the text
													if (strfind(Gladius.dbi.profile.tagsTexts[key].text, "%["..info[#info].."%]")) then
														return true
													else
														return false
													end
												end,
												set = function(info, v)
													local key = info[#info - 2]
													-- add/remove tag to the text
													if not v then
														Gladius.dbi.profile.tagsTexts[key].text = strgsub(Gladius.dbi.profile.tagsTexts[key].text, "%["..info[#info].."%]", "")
														-- trim right
														Gladius.dbi.profile.tagsTexts[key].text = strgsub(Gladius.dbi.profile.tagsTexts[key].text, "^(.-)%s*$", "%1")
													else
														Gladius.dbi.profile.tagsTexts[key].text = Gladius.dbi.profile.tagsTexts[key].text.." ["..info[#info].."]"
													end
													-- update
													Gladius:UpdateFrame()
												end,
											}
										end
									end
									-- update
									Gladius:UpdateFrame()
								end
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
						},
					},
				},
			},
		},
	}
	-- text option tags
	self.optionTags = {
		text = {
			type = "input",
			name = L["Text"],
			desc = L["Text to be displayed"],
			width = "full",
			order = 1,
			disabled = function()
				return not Gladius.dbi.profile.modules[self.name]
			end,
		},
	}
	local order = 2
	for tag, _ in pairs(Gladius.dbi.profile.tags) do
		local tagName = L[tag.."Tag"] ~= tag.."Tag" and L[tag.."Tag"] or strformat(L["Tag: %s"], tag)
		self.optionTags[tag] = {
			type = "toggle",
			name = tagName,
			get = function(info)
				local key = info[#info - 2]
				-- check if the tag is in the text
				if (strfind(Gladius.dbi.profile.tagsTexts[key].text, "%["..info[#info].."%]")) then
					return true
				else
					return false
				end
			end,
			set = function(info, v)
				local key = info[#info - 2]
				-- add/remove tag to the text
				if not v then
					Gladius.dbi.profile.tagsTexts[key].text = strgsub(Gladius.dbi.profile.tagsTexts[key].text, "%["..info[#info].."%]", "")
					-- trim right
					Gladius.dbi.profile.tagsTexts[key].text = strgsub(Gladius.dbi.profile.tagsTexts[key].text, "^(.-)%s*$", "%1")
				else
					if Gladius.dbi.profile.tagsTexts[key].text == "" then
						Gladius.dbi.profile.tagsTexts[key].text = Gladius.dbi.profile.tagsTexts[key].text.."["..info[#info].."]"
					else
						Gladius.dbi.profile.tagsTexts[key].text = Gladius.dbi.profile.tagsTexts[key].text.." ["..info[#info].."]"
					end
				end
				-- update
				Gladius:UpdateFrame()
			end,
			disabled = function()
				return not Gladius.dbi.profile.modules[self.name]
			end,
			order = order,
		}
		order = order + 1
	end
	-- texts
	order = 1
	for text, _ in pairs(Gladius.dbi.profile.tagsTexts) do
		options.textList.args[text] = self:GetTextOptionTable(text, order)
		-- set tags
		options.textList.args[text].args.tag.args = self.optionTags
		order = order + 1
	end
	-- tags
	order = 1
	for tag, _ in pairs(Gladius.dbi.profile.tags) do
		options.tagList.args[tag] = self:GetTagOptionTable(tag, order)
		order = order + 1
	end
	return options
end

function Tags:GetTextOptionTable(text, order)
	return {
		type = "group",
		name = text,
		childGroups = "tree",
		order = order,
		get = function(info)
			local key = info[#info - 2]
			return Gladius.dbi.profile.tagsTexts[key][info[#info]]
		end,
		set = function(info, value)
			local key = info[#info - 2]
			Gladius.dbi.profile.tagsTexts[key][info[#info]] = value
			Gladius:UpdateFrame()
		end,
		args = {
			delete = {
				type = "execute",
				name = L["Delete Text"],
				order = 1,
				func = function()
					-- remove from db
					Gladius.db.tagsTexts[text] = nil
					-- remove from options
					Gladius.options.args[self.name].args.textList.args[text] = nil
					-- update
					Gladius:UpdateFrame()
				end,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name]
				end,
			},
			tag = {
				type = "group",
				name = L["Tag"],
				desc = L["Tag settings"],
				inline = true,
				order = 2,
				args = { },
			},
			text = {
			type = "group",
			name = L["Text"],
			desc = L["Text settings"],
			inline = true,
			order = 3,
				args = {
					color = {
						type = "color",
						name = L["Text Color"],
						desc = L["Text color of the text"],
						hasAlpha = true,
						order = 5,
						get = function(info)
							local key = info[#info - 2]
							return Gladius.dbi.profile.tagsTexts[key][info[#info]].r, Gladius.dbi.profile.tagsTexts[key][info[#info]].g, Gladius.dbi.profile.tagsTexts[key][info[#info]].b, Gladius.dbi.profile.tagsTexts[key][info[#info]].a
						end,
						set = function(info, r, g, b, a)
							local key = info[#info - 2]
							Gladius.dbi.profile.tagsTexts[key][info[#info]].r, Gladius.dbi.profile.tagsTexts[key][info[#info]].g, Gladius.dbi.profile.tagsTexts[key][info[#info]].b, Gladius.dbi.profile.tagsTexts[key][info[#info]].a = r, g, b, a
							for i = 1, 5 do
								local unit = "arena"..i
								self:UpdateColors(unit, key)
							end
						end,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
					},
					size = {
						type = "range",
						name = L["Text Size"],
						desc = L["Text size of the text"],
						min = 1,
						max = 20,
						step = 1,
						order = 10,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name] or Gladius.db.useGlobalFontSize
						end,
					},
				},
			},
			position = {
				type = "group",
				name = L["Position"],
				desc = L["Position settings"],
				inline = true,
				order = 4,
				args = {
					position = {
						type = "select",
						name = L["Text Align"],
						desc = L["Text align of the text"],
						values = {["LEFT"] = L["LEFT"], ["CENTER"] = L["CENTER"], ["RIGHT"] = L["RIGHT"]},
						width = "double",
						order = 5,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
					},
					offsetX = {
						type = "range",
						name = L["Text Offset X"],
						desc = L["X offset of the text"],
						min = - 100,
						max = 100,
						step = 1,
						order = 10,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
						hidden = function()
							return not Gladius.db.advancedOptions
						end,
					},
					offsetY = {
						type = "range",
						name = L["Text Offset Y"],
						desc = L["Y offset of the text"],
						min = - 100,
						max = 100,
						step = 1,
						order = 15,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
						hidden = function()
							return not Gladius.db.advancedOptions
						end,
					},
				},
			},
		},
	}
end

function Tags:GetTagOptionTable(tag, order)
	local tagName = L[tag.."Tag"] ~= tag.."Tag" and L[tag.."Tag"] or strformat(L["Tag: %s"], tag)
	return {
		type = "group",
		name = tagName,
		childGroups = "tree",
		order = order,
		args = {
			delete = {
				type = "execute",
				name = L["Delete Tag"],
				order = 1,
				func = function()
					-- remove from db
					Gladius.db.tags[tag] = nil
					-- remove from options
					Gladius.options.args[self.name].args.tagList.args[tag] = nil
					-- remove from text option tags
					for text, v in pairs(Gladius.options.args[self.name].args.textList.args) do
						if v.args.tag and v.args.tag.args[tag] then
							Gladius.options.args[self.name].args.textList.args[text].args.tag.args[tag] = nil
						end
					end
					-- update
					Gladius:UpdateFrame()
				end,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name]
				end,
			},
			tag = {
				type = "group",
				name = L["Tag"],
				desc = L["Tag settings"],
				inline = true,
				order = 2,
				args = {
					name = {
						type = "input",
						name = L["Name"],
						desc = L["Name of the tag"],
						width = "full",
						order = 5,
						get = function(info)
							local key = info[#info - 2]
							return key
						end,
						set = function(info, value)
							local key = info[#info - 2]
							-- db
							Gladius.db.tags[value] = Gladius.db.tags[key]
							Gladius.db.tags[key] = nil
							-- options
							Gladius.options.args[self.name].args.tagList.args[key] = nil
							Gladius.options.args[self.name].args.tagList.args[value] = self:GetTagOptionTable(value, order)
							-- update
							Gladius:UpdateFrame()
						end,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
					},
					events = {
						type = "input",
						name = L["Events"],
						desc = L["Events which update the tag"],
						width = "full",
						order = 10,
						get = function(info)
							local key = info[#info - 2]
							return Gladius.db.tags[key].events
						end,
						set = function(info, value)
							local key = info[#info - 2]
							Gladius.db.tags[key].events = value
							-- update
							Gladius:UpdateFrame()
						end,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
					},
					func = {
						type = "input",
						name = L["Function"],
						width = "full",
						multiline = true,
						order = 15,
						get = function(info)
							local key = info[#info - 2]
							return Gladius.db.tags[key].func
						end,
						set = function(info, value)
							local key = info[#info - 2]
							Gladius.db.tags[key].func = value
							-- delete cached function
							self.func[key] = nil
							-- update
							Gladius:UpdateFrame()
						end,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
					},
					name = {
						type = "toggle",
						name = L["Enable in preparation area"],
						desc = L["Whether or not to enable the tag in the arena preparation area."],
						width = "full",
						order = 20,
						get = function(info)
							local key = info[#info - 2]
							return Gladius.db.tags[key].preparation
						end,
						set = function(info, value)
							local key = info[#info - 2]
							Gladius.db.tags[key].preparation = value
							Gladius:UpdateFrame()
						end,
						disabled = function()
							return not Gladius.dbi.profile.modules[self.name]
						end,
					},
				},
			},
		},
	}
end

function Tags:GetTags()
	return {
		["name"] = {
			func = "function(unit)\nreturn UnitName(unit) or unit\nend",
			events = "UNIT_NAME_UPDATE",
		},
		["name:status"] = {
			func = "function(unit)\nreturn UnitIsDeadOrGhost(unit) and Gladius.L[\"DEAD\"] or (UnitName(unit) or unit)\nend",
			events = "UNIT_NAME_UPDATE UNIT_HEALTH",
		},
		["class"] = {
			func = "function(unit)\nreturn not Gladius.test and LOCALIZED_CLASS_NAMES_MALE[Gladius.buttons[unit].class] or LOCALIZED_CLASS_NAMES_MALE[Gladius.testing[unit].unitClass]\nend",
			events = "UNIT_NAME_UPDATE",
			preparation = true
		},
		["class:short"] = {
			func = "function(unit)\nreturn not Gladius.test and Gladius.L[LOCALIZED_CLASS_NAMES_MALE[Gladius.buttons[unit].class]..\":short\"] or Gladius.L[LOCALIZED_CLASS_NAMES_MALE[Gladius.testing[unit].unitClass]..\":short\"]\nend",
			events = "UNIT_NAME_UPDATE",
			preparation = true
		},
		["race"] = {
			func = "function(unit)\nreturn not Gladius.test and UnitRace(unit) or Gladius.testing[unit].unitRace\nend",
			events = "UNIT_NAME_UPDATE"
		},
		["spec"] = {
			func = "function(unit)\nreturn Gladius.test and Gladius.testing[unit].unitSpec or Gladius.buttons[unit].spec\nend",
			events = "UNIT_NAME_UPDATE GLADIUS_SPEC_UPDATE",
			preparation = true
		},
		["spec:short"] = {
			func = "function(unit)\nlocal spec = Gladius.test and Gladius.testing[unit].unitSpec or Gladius.buttons[unit].spec\nif (spec == nil or spec == \"\") then\nreturn \"\"\nend\nreturn Gladius.L[spec..\":short\"]\nend",
			events = "UNIT_NAME_UPDATE GLADIUS_SPEC_UPDATE",
			preparation = true
		},
		["health"] = {
			func = "function(unit)\nreturn not Gladius.test and UnitHealth(unit) or Gladius.testing[unit].health\nend",
			events = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"
		},
		["maxhealth"] = {
			func = "function(unit)\nreturn not Gladius.test and UnitHealthMax(unit) or Gladius.testing[unit].maxHealth\nend",
			events = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"
		},
		["health:short"] = {
			func = "function(unit)\nlocal health = not Gladius.test and UnitHealth(unit) or Gladius.testing[unit].health\nif (health > 999) then\nreturn strformat(\"%.1fk\", (health / 1000))\nelse\nreturn health\nend\nend",
			events = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"
		},
		["maxhealth:short"] = {
			func = "function(unit)\nlocal health = not Gladius.test and UnitHealthMax(unit) or Gladius.testing[unit].maxHealth\nif (health > 999) then\nreturn strformat(\"%.1fk\", (health / 1000))\nelse\nreturn health\nend\nend",
			events = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"
		},
		["health:percentage"] = {
			func = "function(unit)\nlocal health = not Gladius.test and UnitHealth(unit) or Gladius.testing[unit].health\nlocal maxHealth = not Gladius.test and UnitHealthMax(unit) or Gladius.testing[unit].maxHealth\nreturn strformat(\"%.1f%%\", (health / maxHealth * 100))\nend",
			events = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"
		},
		["power"] = {
			func = "function(unit)\nreturn not Gladius.test and UnitPower(unit) or Gladius.testing[unit].power\nend",
			events = "UNIT_POWER_UPDATE UNIT_DISPLAYPOWER UNIT_NAME_UPDATE"
		},
		["maxpower"] = {
			func = "function(unit)\nreturn not Gladius.test and UnitPowerMax(unit) or Gladius.testing[unit].maxPower\nend",
			events = "UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_NAME_UPDATE"
		},
		["power:short"] = {
			func = "function(unit)\nlocal power = not Gladius.test and UnitPower(unit) or Gladius.testing[unit].power\nif (power > 999) then\nreturn strformat(\"%.1fk\", (power / 1000))\nelse\nreturn power\nend\nend",
			events = "UNIT_POWER_UPDATE UNIT_DISPLAYPOWER UNIT_NAME_UPDATE"
		},
		["maxpower:short"] = {
			func = "function(unit)\nlocal power = not Gladius.test and UnitPowerMax(unit) or Gladius.testing[unit].maxPower\nif (power > 999) then\nreturn strformat(\"%.1fk\", (power / 1000))\nelse\nreturn power\nend\nend",
			events = "UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_NAME_UPDATE"
		},
		["power:percentage"] = {
			func = "function(unit)\nlocal power = not Gladius.test and UnitPower(unit) or Gladius.testing[unit].power\nlocal maxPower = not Gladius.test and UnitPowerMax(unit) or Gladius.testing[unit].maxPower\nreturn strformat(\"%.1f%%\", (power / maxPower * 100))\nend",
			events = "UNIT_POWER_UPDATE UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_NAME_UPDATE"
		},
	}
end