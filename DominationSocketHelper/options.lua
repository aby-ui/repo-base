local addonName, addon = ...
DSH_ADDON = DSH_ADDON or LibStub("AceAddon-3.0"):NewAddon("DSH_ADDON", "AceConsole-3.0")
local DSH = DSH_ADDON

local L = LibStub ("AceLocale-3.0"):GetLocale ("DominationSocketHelper")
if (not L) then
	print ("|cFFFFAA00Domination Socket Helper|r: Can't load locale. Something went wrong.|r")
	return
end

local ADDON_TITLE = GetAddOnMetadata(addonName, "Title")
local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

local function createconfig()
	local generalOptions
	
	local options = {}
	options.type = "group"
	options.name = "DSH"
	options.args = {}
	
	local function get(info) --don't feel like fixing this to be more dynamic atm
		local ns,opt = string.split(".", info.arg)	

		local val = DSH.db.profile[ns][opt]

		if type(val) == "table" then
			return unpack(val)
		else
			return val
		end

	end

	local function set(info, arg1, arg2, arg3, arg4)
		local ns,opt,opt2 = string.split(".", info.arg)
		if arg2 then
			local entry = DSH.db.profile[ns][opt]
			entry[1] = arg1
			entry[2] = arg2
			entry[3] = arg3
			entry[4] = arg4
		else
			DSH.db.profile[ns][opt] = arg1
			DSH:UpdateSlotButtons()
		end
	
	end

	
	generalOptions = {
		type = "group",
		order = 1,
		--inline = true,
		name = format("|cFFAAD372%s|r %s", DSH.TITLE, DSH.VERSION),
		childGroups = "tab",
		get = get,
		set = set,
		args = {
			quickslots = {
				order = 1,
				type = "group",
				inline = true,
				name = L["O_QUICK_SLOT"],
				childGroups = "tab",
				args = {
					enable = {
						order = 2,
						width = .75,
						type = "toggle",
						name = L["ENABLE"],
						desc = L["ENABLE_DESC"],
						arg = "quickslots.enable",
					},
					emptyonly = {
						order = 3,
						type = "toggle",
						name = L["ALWAYS_EMPTY"],
						desc = L["ALWAYS_EMPTY_DESC"],
						arg = "quickslots.alwaysempty",
					},
					stayopen = {
						order = 4,
						type = "toggle",
						name = L["STAY_OPEN"],
						desc = L["STAY_OPEN_DESC"],
						arg = "quickslots.stayopen",
					},						
				},
			},
			socketwindow = {
				order = 2,
				type = "group",
				inline = true,
				name = L["SOCKET_WINDOW"],
				childGroups = "tab",
				args = {
					auto = {
						order = 2,
						type = "toggle",
						name = L["AUTO_ACCEPT"],
						desc = L["AUTO_ACCEPT_DESC"],
						arg = "socketwindow.autoaccept",
					},			
				},
			},
		},
	}
	
	return generalOptions
end

local function createBlizzOptions()
	local options = createconfig()

	-- General Options
	config:RegisterOptionsTable("DSH", options)
	--local blizzPanel = config:AddToBlizOptions("PLT-General", options.args.general.name, "PLT")
	local blizzPanel = dialog:AddToBlizOptions("DSH", ADDON_TITLE)
	
	return blizzPanel

end

local addonLoaded = CreateFrame("FRAME") -- Variables
 addonLoaded:RegisterEvent("ADDON_LOADED") --RegisterAddonLoad
 addonLoaded:SetScript("OnEvent",function(self, event, arg1)

	if arg1 == "DominationSocketHelper" then
		createBlizzOptions()
	end
	
end)





