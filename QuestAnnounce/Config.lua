
local QuestAnnounce = LibStub("AceAddon-3.0"):GetAddon("QuestAnnounce")
local L = LibStub("AceLocale-3.0"):GetLocale("QuestAnnounce")

local options, configOptions = nil, {}
--[[ This options table is used in the GUI config. ]]-- 
local function getOptions() 
	if not options then
		options = {
		    type = "group",
			name ="QuestAnnounce",			
		    args = {
				general = {
					order = 1,
					type = "group",
					name = "General",
					args = {
						settings = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Settings"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestAnnounce:SendDebugMsg("getSettings: "..key.." :: "..tostring(QuestAnnounce.db.profile.settings[key]))
								return QuestAnnounce.db.profile.settings[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestAnnounce.db.profile.settings[key] = value
								QuestAnnounce:SendDebugMsg("setSettings: "..key.." :: "..tostring(QuestAnnounce.db.profile.settings[key]))
							end,
							args = {
								enabledesc = {
									order = 1,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestAnnounce"]
								},
								enable = {
									order = 2,
									type = "toggle",
									name = L["Enable"]
						        },
								everydesc = {
									order = 3,
									type = "description",
									fontSize = "medium",
									name = L["Announce progression every x number of steps (0 will announce on quest objective completion only)"]
								},
								every = {
									order = 4,
									type = "range",
									name = L["Announce Every"],
									min = 0,
									max = 10,
									step = 1
						        },
								sounddesc = {
									order = 5,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestAnnounce Sounds"]
									
								},
								sound = {
									order = 6,
									type = "toggle",
									name = L["Sound"]
								},
								debugdesc = {
									order = 100,
									type = "description",
									fontSize = "medium",
									name = L["Enable/Disable QuestAnnounce Debug Mode"]
								},
								debug = {
									order = 101,
									type = "toggle",
									name = L["Debug"]
						        },
								test = {
									order = 102,
									type = "execute",
									name = "Test Frame Messages",
									func = function() QuestAnnounce:SendMsg(L["QuestAnnounce Test Message"]) end
								}
							}
						},
						announceTo = {
							order = 6,
							type = "group",
							inline = true,
							name = L["Where do you want to make the announcements?"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestAnnounce:SendDebugMsg("getAnnounceTo: "..key.." :: "..tostring(QuestAnnounce.db.profile.announceTo[key]))
								return QuestAnnounce.db.profile.announceTo[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestAnnounce.db.profile.announceTo[key] = value
								QuestAnnounce:SendDebugMsg("setAnnounceTo: "..key.." :: "..tostring(QuestAnnounce.db.profile.announceTo[key]))
							end,
							args = {
								chatFrame = {
									order = 1,
									type = "toggle",
									name = L["Chat Frame"]
								},
								raidWarningFrame = {
									order = 2,
									type = "toggle",
									name = L["Raid Warning Frame"]
								},
								uiErrorsFrame = {
									order = 3,
									type = "toggle",
									name = L["UI Errors Frame"]
								}
							}
						},
						announceIn = {
							order = 7,
							type = "group",
							inline = true,
							name = L["What channels do you want to make the announcements?"],
							get = function(info)
								local key = info.arg or info[#info]
								QuestAnnounce:SendDebugMsg("getAnnounceIn: "..key.." :: "..tostring(QuestAnnounce.db.profile.announceIn[key]))
								return QuestAnnounce.db.profile.announceIn[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								QuestAnnounce.db.profile.announceIn[key] = value
								QuestAnnounce:SendDebugMsg("setAnnounceIn: "..key.." :: "..tostring(QuestAnnounce.db.profile.announceIn[key]))
							end,
							args = {
								say = {
									order = 1,
									type = "toggle",
									name = L["Say"]
								},
								party = {
									order = 2,
									type = "toggle",
									name = L["Party"]
								},
								instance = {
									order = 3,
									type = "toggle",
									name = L["Instance"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end									
								},								
								guild = {
									order = 4,
									type = "toggle",
									name = L["Guild"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end									
								},
								officer = {
									order = 5,
									type = "toggle",
									name = L["Officer"],
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								whisper = {
									order = 6,
									type = "toggle",
									name = L["Whisper"],
									width = 'half',
									confirm = function(info, value)
										return (value and L["Are you sure you want to announce to this channel?"] or false)
									end
								},
								whisperWho = {
									order = 7,
									type = "input",
									width = 'half',
									name = L["Whisper Who"]
								}																
							}
						}
					}
				}
		    }
		}
		for k,v in pairs(configOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end
	
	return options
end

local function openConfig() 
	InterfaceOptionsFrame_OpenToCategory(QuestAnnounce.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(QuestAnnounce.optionsFrames.QuestAnnounce)
	InterfaceOptionsFrame:Raise()
end

function QuestAnnounce:SetupOptions()
	self.optionsFrames = {}

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("QuestAnnounce", getOptions)
	self.optionsFrames.QuestAnnounce = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestAnnounce", nil, nil, "general")

	configOptions["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	self.optionsFrames["Profiles"] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("QuestAnnounce", "Profiles", "QuestAnnounce", "Profiles")

	LibStub("AceConsole-3.0"):RegisterChatCommand("qa", openConfig)
end