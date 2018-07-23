function EUF_PartyInfo_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("UNIT_FACTION");
	self:RegisterEvent("UNIT_LEVEL");
	self:RegisterEvent("GROUP_ROSTER_UPDATE");
	self:RegisterEvent("VARIABLES_LOADED");
end

function EUF_PartyInfo_OnEvent(self, event, ...)
	--if event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" or event == "UNIT_LEVEL" then
    if(not IsInRaid())then
		EUF_FramePartyInfo_Update();
		EUF_PartyMember_CheckClass();
    end
	--end
end

function EUF_PartyInfo_Update(unit)
	if not unit then
		return;
	end
	local unitExists, _,unitId = string.find(unit, "^party(%d)$");
	if not unitExists then
		return;
	end
	-- Set class
	getglobal("EUF_PartyInfo"..unitId.."Class"):SetText("");

	-- Set level
	if EUF_CurrentOptions["PARTYINFO"] == 1 then
		local level= UnitLevel(unit);
		if level then
			if level < 1 then
				level = "??";
			end
			getglobal("EUF_PartyInfo"..unitId.."Level"):SetText(level);
		end
	else
		getglobal("EUF_PartyInfo"..unitId.."Level"):SetText("");
	end
end

function EUF_FramePartyInfo_Update()
	local i;
	for i = 1, GetNumSubgroupMembers(), 1 do
		EUF_PartyInfo_Update("party"..i);
	end
end

function EUF_PartyMember_CheckClass()
	local n = GetNumSubgroupMembers();
    if n > 0 then
        for i=1,n do
			local _,enClass = UnitClass("party"..i);
			if EUF_CurrentOptions["PARTYCOLOR"] == 1 and enClass then
				getglobal("PartyMemberFrame"..i.."Name"):SetTextColor(RAID_CLASS_COLORS[enClass].r,RAID_CLASS_COLORS[enClass].g,RAID_CLASS_COLORS[enClass].b);
			else
				getglobal("PartyMemberFrame"..i.."Name"):SetTextColor(1, 0.8, 0);
			end
		end
	end
end


function EUF_PartyInfoToggle(switch)
	local hp, mp;
	if (switch) then
		EUF_Options_Update("PARTYCLASSICONSMALL", 1);	
		EUF_Options_Update("PARTYCOLOR", 1);	
		EUF_Options_Update("PARTYINFO", 1);	
		EUF_Options_Update("PARTYHPMP", 1);		
	else
		EUF_Options_Update("PARTYCLASSICONSMALL", 0);	
		EUF_Options_Update("PARTYCOLOR", 0);	
		EUF_Options_Update("PARTYINFO", 0);	
		EUF_Options_Update("PARTYHPMP", 0);		
	end
end
