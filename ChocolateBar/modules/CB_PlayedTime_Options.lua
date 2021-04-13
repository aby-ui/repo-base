local LibStub = LibStub
local addonName = "CB_PlayedTime"
local L = LibStub("AceLocale-3.0"):GetLocale("CB_PlayedTime")
local CB_PlayedTime = LibStub:GetLibrary("LibDataBroker-1.1",true):GetDataObjectByName(addonName)
local version = GetAddOnMetadata("CB_PlayedTime","X-Curse-Packaged-Version") or ""
local db

local aceoptions = {
  name = addonName.." "..version,
  handler = CB_PlayedTime,
	type='group',
	desc = addonName,
	childGroups = "tab",
    args = {
		general = {
			inline = true,
			name = L["General"],
			type="group",
			order = 1,
			args={
        reset = {
					type = 'execute',
					order = 0,
          name = L["Reset"],
          desc = L["Reset time for all Characters"],
		      func = function()
						CB_PlayedTime:Reset()
					end,
				},
			}
		}
	}
}

function CB_PlayedTime:RegisterOptions()
	local defaults = {
		profile = {
			showWorldLatency = true,
			showFPS = true,
			textOutput = "{fps}fps {lw}ms {lh}ms",
			customTextSetting = false
		}
	}

	--db = LibStub("AceDB-3.0"):New(addonName.."DB", defaults, "Default")
	--db = db.profile
	--CB_PlayedTime:SetDB(db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, aceoptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)
	--aceoptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
end

function CB_PlayedTime:OpenOptions()
	LibStub("AceConfigDialog-3.0"):Open(addonName)
end
