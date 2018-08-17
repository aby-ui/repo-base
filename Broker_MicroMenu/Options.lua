local LibStub = LibStub
local Broker_MicroMenu = LibStub:GetLibrary("LibDataBroker-1.1",true):GetDataObjectByName("Broker_MicroMenu")
local version = GetAddOnMetadata("Broker_MicroMenu","X-Curse-Packaged-Version") or ""
local L = LibStub("AceLocale-3.0"):GetLocale("Broker_MicroMenu")
local db

local aceoptions = { 
    name = "Broker MicroMenu".." "..version,
    handler = DungeonHelper,
	type='group',
	desc = "Broker MicroMenu",
	childGroups = "tab",
    args = {
		general = {
			inline = true,
			name = L["General"],
			type="group",
			order = 1,
			args={
				enableColoring = {
					type = 'toggle',
					order = 1,
					name = L["Enable Coloring"],
					desc = L["Enable Coloring"],
					get = function(info, value)
						return db.enableColoring
					end,
					set = function(info, value)
						db.enableColoring = value
						Broker_MicroMenu:UpdateText()
					end,
				},
				showWorldLatency = {
					type = 'toggle',
					order = 2,
					name = L["Show World Latency"],
					desc = L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."],
					disabled = function(info, value)
						return db.customTextSetting
					end,
					get = function(info, value)
						return db.showWorldLatency
					end,
					set = function(info, value)
						db.showWorldLatency = value
						Broker_MicroMenu:UpdateText()
					end,
				},
				showHomeLatency = {
					type = 'toggle',
					order = 3,
					name = L["Show Home Latency"],
					desc = L["Show latency for chat data, auction house stuff some addon data, and various other data."],
					disabled = function(info, value)
						return db.customTextSetting
					end,
					get = function(info, value)
						return db.showHomeLatency
					end,
					set = function(info, value)
						db.showHomeLatency = value
						Broker_MicroMenu:UpdateText()
					end,
				},
				showFPS = {
					type = 'toggle',
					order = 4,
					name = L["Show FPS"],
					desc = L["Show frames per second."],
					disabled = function(info, value)
						return db.customTextSetting
					end,
					get = function(info, value)
						return db.showFPS
					end,
					set = function(info, value)
						db.showFPS = value
						Broker_MicroMenu:UpdateText()
					end,
				},
				fpsFirst = {
					type = 'toggle',
					order = 5,
					name = L["Show FPS First"],
					desc = L["Show FPS First"],
					disabled = function(info, value)
						return db.customTextSetting
					end,
					get = function(info, value)
						return db.fpsFirst
					end,
					set = function(info, value)
						db.fpsFirst = value
						Broker_MicroMenu:UpdateText()
					end,
				}
			}
		},
		advanced = {
			inline = true,
			name = L["Advanced"],
			type="group",
			order = 2,
			args={
				customTextSetting = {
					type = 'toggle',
					order = 1,
					name = L["Enable"],
					desc = L["Enable this if you want to fine tune the displayed text."],
					get = function(info, value)
						return db.customTextSetting
					end,
					set = function(info, value)
						db.customTextSetting = value
						Broker_MicroMenu:UpdateText()
					end,
				},
				textOutput = {
					type = 'input',
					order = 2,
					name = L["Custom Text"],
					desc = "{lw} - "..L["Show World Latency"].."\n{lh} - "..L["Show Home Latency"].."\n{fps} - "..L["Show FPS"],
					width = "full",
					disabled = function(info, value)
						return not db.customTextSetting
					end,
					get = function(info, value)
						return db.textOutput
					end,
					set = function(info, value)
						db.textOutput = value
						Broker_MicroMenu:UpdateText()
					end,
				},
			},
		},
	}
}

function Broker_MicroMenu:RegisterOptions()
	local defaults = {
		profile = {
			showWorldLatency = true,
			showFPS = false,
			textOutput = "{fps}fps {lw}ms {lh}ms",
			customTextSetting = false
		}
	}

	db = LibStub("AceDB-3.0"):New("Broker_MicroMenuDB", defaults, "Default")
	db = db.profile
	Broker_MicroMenu:SetDB(db)	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Broker_MicroMenu", aceoptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker_MicroMenu", "Broker MicroMenu")
	--aceoptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
end

function Broker_MicroMenu:OpenOptions()
	LibStub("AceConfigDialog-3.0"):Open("Broker_MicroMenu")
end
