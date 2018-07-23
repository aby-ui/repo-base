local Recount = _G.Recount

local revision = tonumber(string.sub("$Revision: 1435 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local pairs = pairs

local C_Scenario = C_Scenario
local GetInstanceInfo = GetInstanceInfo
local GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers
local GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsInScenarioGroup = IsInScenarioGroup
local UnitInRaid = UnitInRaid
local UnitIsGhost = UnitIsGhost

--[[local TOC
do
	-- Because GetBuildInfo() still returns 40000 on the PTR
	local major, minor, rev = strsplit(".", (GetBuildInfo()))
	TOC = major * 10000 + minor * 100
end]]

function Recount:DetectInstanceChange() -- Elsia: With thanks to Loggerhead

	--local zone = GetRealZoneText()
	local zone = GetInstanceInfo() -- Elsia: GetInstanceInfo() is robust at PEW!

	if zone == "" then
		-- zone hasn't been loaded yet, try again in 5 secs.
		self:ScheduleTimer("DetectInstanceChange", 5)
		return
	end

	if UnitIsGhost(Recount.PlayerName) then
		return
	end

	local inInstance, instanceType
	if zone == nil then
		inInstance, zone = IsInInstance()
		if zone == nil then
			inInstance, zone = C_Scenario.IsInScenario()
			Recount:DPrint((inInstance or "nil") .. " : ".. (zone or "nil"))
		end
	end

	--[[local groupType

	if Recount.inRaid then
		groupType = 2
	elseif Recount.inGroup then
		groupType = 1
	else
		groupType = 0
	end

	local inInstance, instanceType = IsInInstance()
	if Recount.SetZoneGroupFilter and not UnitIsGhost(Recount.PlayerName) then Recount:SetZoneGroupFilter(instanceType, groupType) end -- Use zone-based filters.]]
	Recount:UpdateZoneGroupFilter()

	if not Recount.db.profile.AutoDeleteNewInstance then
		return
	end

	local ct = 0
	for k, v in pairs(Recount.db2.combatants) do
		ct = ct + 1
		break
	end
	if ct == 0 then -- Elsia: Already deleted
		return
	end

	inInstance, instanceType = IsInInstance()

	if inInstance and (not Recount.db.profile.DeleteNewInstanceOnly or Recount.db.profile.LastInstanceName ~= zone) and Recount.CurrentDataCollect then
		if Recount.db.profile.ConfirmDeleteInstance == true then
			--Recount:DPrint("Instance based deletion: Old: "..Recount.db.profile.LastInstanceName.." New: "..zone)
			Recount:ShowReset() -- Elsia: Confirm & Delete!
		else
			Recount:ResetData() -- Elsia: Delete!
		end
		Recount.db.profile.LastInstanceName = zone -- Elsia: We'll set the instance even if the user opted to not delete...
	end
end

-- Elsia: For delete on join raid/group

function Recount:PartyMembersChanged()
	local ct = 0
	for k, v in pairs(Recount.db2.combatants) do
		ct = ct + 1
		break
	end

	if ct ~= 0 and Recount.db.profile.DeleteJoinRaid and not Recount.inRaid and not Recount.inScenario and GetNumRaidMembers() > 0 and IsInRaid() and Recount.CurrentDataCollect then
		if Recount.db.profile.ConfirmDeleteRaid then
			--Recount:DPrint("Raid based deletion")
			Recount:ShowReset() -- Elsia: Confirm & Delete!
		else
			Recount:ResetData() -- Elsia: Delete!
		end

		--[[if Recount.RequestVersion then
			Recount:RequestVersion()
		end]] -- Elsia: If LazySync is present request version when entering raid
	end

	if ct ~= 0 and Recount.db.profile.DeleteJoinGroup and not Recount.inGroup and GetNumPartyMembers() > 0 and not IsInRaid() and Recount.CurrentDataCollect then
		if Recount.db.profile.ConfirmDeleteGroup then
			--Recount:DPrint("Group based deletion")
			Recount:ShowReset() -- Elsia: Confirm & Delete!
		else
			Recount:ResetData() -- Elsia: Delete!
		end

		--[[if Recount.RequestVersion then
			Recount:RequestVersion()
		end]] -- Elsia: If LazySync is present request version when entering party
	end

	local change = false

	if GetNumPartyMembers() > 0 and not IsInRaid() then -- Elsia: This seems to be always true -> or UnitInParty("player")
		change = not Recount.inGroup
		Recount.inGroup = true
	else
		change = Recount.inGroup
		Recount.inGroup = false
	end

	if IsInRaid() and not IsInScenarioGroup() then
		change = change or not Recount.inRaid
		Recount.inRaid = true
	else
		change = change or Recount.inRaid
		Recount.inRaid = false
	end

	if IsInRaid() and IsInScenarioGroup() then
		change = change or not Recount.inScenario
		Recount.inScenario = true
	else
		change = change or Recount.inScenario
		Recount.inScenario = false
	end

	if change then
		Recount:UpdateZoneGroupFilter()
	end

	if Recount.GroupCheck then
		Recount:GroupCheck()
	end -- Elsia: Reevaluate group flagging on group changes.
end

function Recount:GROUP_ROSTER_UPDATE()
	Recount:PartyMembersChanged()
end

function Recount:InitPartyBasedDeletion()
	Recount.inGroup = false
	Recount.inRaid = false

	if (not IsInRaid() and GetNumPartyMembers() > 0) or IsInScenarioGroup() then
		Recount.inGroup = true
	end
	if IsInRaid() and GetNumRaidMembers() > 0 and not IsInScenarioGroup() then
		Recount.inRaid = true
	end

	--[[if TOC >= 50000 then
		Recount:RegisterEvent("GROUP_ROSTER_UPDATE", "PartyMembersChanged")
	else
		Recount:RegisterEvent("PARTY_MEMBERS_CHANGED","PartyMembersChanged")

		Recount:RegisterEvent("RAID_ROSTER_UPDATE","PartyMembersChanged")
	end]]
	Recount.events:RegisterEvent("GROUP_ROSTER_UPDATE")
	Recount:UpdateZoneGroupFilter()
end

function Recount:ReleasePartyBasedDeletion()
	if Recount.db.profile.DeleteJoinGroup == false and Recount.db.profile.DeleteJoinRaid == false then
		--Recount:UnregisterEvent("PARTY_MEMBERS_CHANGED")
		--Recount:UnregisterEvent("RAID_ROSTER_UPDATE")
	end
end
