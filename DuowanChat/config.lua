local DWC = LibStub("AceAddon-3.0"):GetAddon("DuowanChat")
local L = LibStub("AceLocale-3.0"):GetLocale("DuowanChat") 
local optGetter, optSetter 
do 
	function optGetter(info) 
		local key = info[#info]
		return DWC.db.profile[key] 
	end

	function optSetter(info, value)
		local key = info[#info]
        DWC.db.profile[key] = value
        local modChatChannel = DWC:GetModule("CHATCHANNEL", true);
        if(key=="enablechatchannel" and modChatChannel)then
            if value then
                modChatChannel._SetByOption = true;
                modChatChannel:Enable()
            else
                modChatChannel:Disable()
            end
        end
		DWC:Refresh()
	end 
end 

local options, moduleOptions = nil, {} 
local function getOptions() 
	if not options then
		options = {
			type = "group",
			name = L.DWChatTitle, 
			args = { 
				general = {
					order = 1, 
					type = "group", 
					name = L.DWChat,
					get = optGetter, 
					set = optSetter, 
					args = {
						intro = {
							order = 1, 
							type = "description", 
							name = L["DWChat provides you convient tools like copy text, name highlight and timestamps"], 
						}, 
						classheader = {
							order = 6, 
							type = "header", 
							name = L["Class setting"], 
						}, 
						--enableclasscolor = { 
						--	order = 7, 
						--	type = "toggle",
						--	name = L["Enable Class Color"],
						--	width = "full", 
						--},
						enablelevel = { 
							order = 80,
							type = "toggle",
							name = L["Enable Level"], 
							width = "full", 
						},
						enablesubgroup = {
							order = 85,
							type = "toggle",
							name = L["Enable Group"],
							width = "full",
						},
						channelheader = { 
							order = 90,
							type = "header", 
							name = L["Channel setting"],
						}, 
						useshortname = {
							order = 100,
							name = L["Use short channel names"], 
							type = "toggle", 
							width = "full",
						}, 
						enablechatchannelmove={
							order = 110,
							type = "toggle",
							name = L["Enable channel buttons move"], 
                            width = "full",
						},
						enablechatchannel = {
							order = 120,
							name = L["Chat Channel"],
							type = "toggle",
                            width = "full",
						}, 
					}, 
				},
			}, 
		} 
		
		for k,v in pairs(moduleOptions) do
			options.args[k] = (type(v) == "function") and v() or v 
		end 
	end 
	return options 
end 

function DWC:ShowOptions()
	LibStub("AceConfigDialog-3.0"):Open("DuowanChat");
end 

function DWC:SetupOptions()
	InterfaceOptionsFrame:SetFrameStrata("DIALOG") 
	self.optionsFrames = {}
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("DuowanChat", getOptions) 
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles") 
	self:Refresh()
end 

function DWC:RegisterModuleOptions(name, optionTbl, displayName) 
	moduleOptions[name] = optionTbl
end 
