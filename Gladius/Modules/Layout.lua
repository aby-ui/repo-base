local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Layout"))
end
local L = Gladius.L
local LSM

-- Global Functions
local next = next
local pairs = pairs
local strformat = string.format
local type = type

local Layout = Gladius:NewModule("Layout", false, false, {
})

function Layout:OnEnable()
	LSM = Gladius.LSM
end

function Layout:OnDisable()
	self:UnregisterAllEvents()
end

function Layout:GetAttachTo()
	return ""
end

function Layout:GetFrame(unit)
	return ""
end

local function SerializeTable(table, defaults)
	for key, value in pairs(table) do
		if type(value) == "table" then
			if defaults[key] ~= nil then
				local t = SerializeTable(value, defaults[key])
				if next(t) ~= nil then
					table[key] = t
				else
					table[key] = nil
				end
			end
		else
			if defaults[key] == value then
				table[key] = nil
			end
		end
	end
	return table
end

function Layout:GetOptions()
	self.layout = ""
	local t = {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				widget = {
					type = "group",
					name = L["Widget"],
					desc = L["Widget settings"],
					inline = true,
					order = 1,
					args = {
						layoutInput = {
							type = "input",
							name = L["Layout Code"],
							desc = L["Code of your layout."],
							get = function()
								return self.layout
							end,
							set = function(info, value)
								self.layout = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							multiline = true,
							width = "full",
							order = 5,
						},
						layoutImport = {
							type = "execute",
							name = L["Import layout"],
							desc = L["Import your layout code."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							func = function()
								if self.layout == nil or self.layout == "" then
									return
								end
								local err, layout = LibStub("AceSerializer-3.0"):Deserialize(self.layout)
								if not err then
									Gladius:Print(strformat(L["Error while importing layout: %s"], layout))
									return
								end
								local currentLayout = Gladius.dbi:GetCurrentProfile()
								Gladius.dbi:SetProfile("Import Backup")
								Gladius.dbi:CopyProfile(currentLayout)
								Gladius.dbi:SetProfile(currentLayout)
								Gladius.dbi:ResetProfile()
								Gladius.dbi.profile.modules["*"] = true
								for key, data in pairs(layout) do
									if type(data) == "table" then
										Gladius.dbi.profile[key] = CopyTable(data)
									else
										Gladius.dbi.profile[key] = data
									end
								end
								Gladius:UpdateFrame()
							end,
							order = 10,
						},
						layoutExport = {
							type = "execute",
							name = L["Export layout"],
							desc = L["Export your layout code."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							func = function()
								local t = CopyTable(Gladius.dbi.profile)
								self.layout = LibStub("AceSerializer-3.0"):Serialize(SerializeTable(t, Gladius.defaults.profile))
							end,
							order = 15,
						},
					},
				},
			},
		},
	}
	return t
end