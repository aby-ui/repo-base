--------------------------------------------------------------------------
-- GTFO_Recount.lua 
--------------------------------------------------------------------------
--[[
GTFO & Recount Integration
Author: Zensunim of Malygos

Change Log:
	v4.1
		- Added Recount Integration
	v4.6
		- Fixed label text

]]--

function GTFO_Recount()
	local L = LibStub("AceLocale-3.0"):GetLocale("Recount");

	local DetailTitles={}
	DetailTitles.GTFOEvents={
		TopNames = L["Type"],
		TopCount = L["Count"],
		TopAmount = L["Damage"],
		BotNames = L["Ability Name"],
		BotMin = L["Min"],
		BotAvg = L["Avg"],
		BotMax = L["Max"],
		BotAmount = L["Count"]
	}
	
	local RecountGTFO = {}
	
	function RecountGTFO:DataModesGTFO(data, num)
	    if not data then return 0 end
	    if num == 1 then
	        return (data.Fights[Recount.db.profile.CurDataSet].GTFOEventDamage or 0), tostring((data.Fights[Recount.db.profile.CurDataSet].GTFOEvents or 0))
	    else
					return (data.Fights[Recount.db.profile.CurDataSet].GTFOEventDamage or 0), {{data.Fights[Recount.db.profile.CurDataSet].GTFOEvent,": "..GTFOLocal.Recount_Name,DetailTitles.GTFOEvents}}
	    end
	end
	
	function RecountGTFO:TooltipFuncsGTFO(name,data)
	    local SortedData,total
	    GameTooltip:ClearLines()
	    GameTooltip:AddLine(name)
	    Recount:AddSortedTooltipData(GTFOLocal.Recount_Name,data and data.Fights[Recount.db.profile.CurDataSet] and data.Fights[Recount.db.profile.CurDataSet].GTFOEvent,4)
	    GameTooltip:AddLine("<"..L["Click for more Details"]..">",0,0.9,0);
	end
	
	Recount:AddModeTooltip(GTFOLocal.Recount_Name,RecountGTFO.DataModesGTFO,RecountGTFO.TooltipFuncsGTFO,nil,nil,nil,nil)

	function GTFO_RecordRecount(source, alertID, SpellName, damage)
	  local sourceData = Recount.db2.combatants[source];
	  if not sourceData then
	      GTFO_DebugPrint("No source combatant found in Recount for "..tostring(source).."!");
				return;
	  end
	
		local alertType = GTFO_GetAlertType(alertID);
		if not alertType then
			return;
		end
	  Recount:SetActive(sourceData);
	  Recount:AddAmount(sourceData, "GTFOEvents", 1);
	  Recount:AddAmount(sourceData, "GTFOEventDamage", damage);
	  Recount:AddTableDataStats(sourceData, "GTFOEvent", alertType, SpellName, damage);
	end
	
	GTFO_DebugPrint("Recount integration loaded.");
	
	return true;	
end