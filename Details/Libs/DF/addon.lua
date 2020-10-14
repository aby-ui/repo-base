
local DF = _G ["DetailsFramework"]
local _

if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

function DF:CreateAddOn (name, global_saved, global_table, options_table, broker)
	
	local addon = LibStub ("AceAddon-3.0"):NewAddon (name, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "DetailsFramework-1.0", "AceComm-3.0")
	_G [name] = addon
	addon.__name = name
	
	function addon:OnInitialize()
		
		if (global_saved) then
			if (broker and broker.Minimap and not global_table.Minimap) then
				DF:Msg (name, "broker.Minimap is true but no global.Minimap declared.")
			end
			self.db = LibStub ("AceDB-3.0"):New (global_saved, global_table or {}, true)
		end
		
		if (options_table) then
			LibStub ("AceConfig-3.0"):RegisterOptionsTable (name, options_table)
			addon.OptionsFrame1 = LibStub ("AceConfigDialog-3.0"):AddToBlizOptions (name, name)
			
			LibStub ("AceConfig-3.0"):RegisterOptionsTable (name .. "-Profiles", LibStub ("AceDBOptions-3.0"):GetOptionsTable (self.db))
			addon.OptionsFrame2 = LibStub ("AceConfigDialog-3.0"):AddToBlizOptions (name .. "-Profiles", "Profiles", name)
		end
		
		if (broker) then
			local broker_click_function = broker.OnClick
			if (not broker_click_function and options_table) then
				broker_click_function = function()
					InterfaceOptionsFrame_OpenToCategory (name)
					InterfaceOptionsFrame_OpenToCategory (name)
				end
			end
			
			local databroker = LibStub ("LibDataBroker-1.1"):NewDataObject (name, {
				type = broker.type or "launcher",
				icon = broker.icon or [[Interface\PvPRankBadges\PvPRank15]],
				text = broker.text or "",
				OnTooltipShow = broker.OnTooltipShow,
				OnClick = broker_click_function
			})
			
			if (databroker and broker.Minimap and global_table.Minimap) then
				LibStub ("LibDBIcon-1.0"):Register (name, databroker, addon.db.profile.Minimap)
			end
		end
		
		if (addon.OnInit) then
			xpcall (addon.OnInit, geterrorhandler(), addon)
		end
		
	end
	
	return addon
	
end
