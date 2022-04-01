local LibStub = LibStub
local addonName = "CB_PlayedTime"
local L = LibStub("AceLocale-3.0"):GetLocale("CB_PlayedTime")
local CB_PlayedTime = LibStub:GetLibrary("LibDataBroker-1.1",true):GetDataObjectByName(addonName)
local version = GetAddOnMetadata("CB_PlayedTime","X-Curse-Packaged-Version") or ""
local db
local tobedeleted

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
			},
		},
    delete = {
      inline = true,
			name = L["Delete a Character"],
      type="group",
			order = 2,
      args={
        },
	   },
  },
}
local deleteOptions = aceoptions.args.delete.args

local function GetName(info)
  local name = info[#info]
  return name
end

local function DeleteName(info)
  local name = info[#info]
  CB_PlayedTime:RemoveCharDeleteOption(name)
  CB_PlayedTime:Delete(name)
end

function CB_PlayedTime:AddCharDeleteOption(name)
  deleteOptions[name] = {
          type = 'execute',
          order = 0,
          name = GetName,
          desc = L["Delete this Character"],
          func = DeleteName,
    }
end

function CB_PlayedTime:RemoveCharDeleteOption(name)
  deleteOptions[name] = nil
end

function CB_PlayedTime:RegisterOptions(data)
  db = data
  local defaults = {
		profile = {
		}
	}
  for k, v in pairs(db) do
      self:AddCharDeleteOption(k)
  end


	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, aceoptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)
end

function CB_PlayedTime:OpenOptions()
	LibStub("AceConfigDialog-3.0"):Open(addonName)
end
