local E, L, C = select(2, ...):unpack()

local InspectQueueFrame = CreateFrame("Frame")
local InspectTooltip = CreateFrame("GameTooltip", "OmniCDInspectToolTip", nil, "GameTooltipTemplate")
InspectTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local strjoin = strjoin
local strfind = string.find
local CanInspect = CanInspect
local GetInspectSpecialization = GetInspectSpecialization
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTalentInfo = GetTalentInfo
local GetInspectSelectedPvpTalent = C_SpecializationInfo.GetInspectSelectedPvpTalent
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetPvpTalentSlotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo
local IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local IsValidRuneforgeBaseItem = C_LegendaryCrafting.IsValidRuneforgeBaseItem
local IsRuneforgeLegendary = C_LegendaryCrafting.IsRuneforgeLegendary
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local Comms = E["Comms"]
local P = E["Party"]
local soulbind_conduits_rank = E.soulbind_conduits_rank
local covenant_IDToSpellID = E.covenant_IDToSpellID
local INS_ONUPDATE_INTERVAL = 1
local INS_DELAY_TIME = 2
local INS_PAUSE_TIME = 2
local INS_TIME_LIMIT = 180
local elapsedTime = 0
local nextInquiryTime = 0
local queried, paused

local queueEntries = {}
local staleEntries = {}

local invSlotIDs = {
	13, --INVSLOT_TRINKET1
	14, --INVSLOT_TRINKET2
	1,  --INVSLOT_HEAD
	2,  --INVSLOT_NECK
	3,  --INVSLOT_SHOULDER
	15, --INVSLOT_BACK
	5,  --INVSLOT_CHEST
	9,  --INVSLOT_WRIST
	10, --INVSLOT_HAND
	6,  --INVSLOT_WAIST
	7,  --INVSLOT_LEGS
	8,  --INVSLOT_FEET
	11, --INVSLOT_FINGER1
	12, --INVSLOT_FINGER2
}
local numInvSlotIDs = #invSlotIDs

local runeforgeBaseItems = { -- [74]
	nil, nil,
	{ 173245, 172317, 172325, 171415 },
	{ 178927, 178927, 178927, 178927 },
	{ 173247, 172319, 172327, 171417 },
	{ 173242, 173242, 173242, 173242 },
	{ 173241, 172314, 172322, 171412 },
	{ 173249, 172321, 172329, 171419 },
	{ 173244, 172316, 172324, 171414 },
	{ 173248, 172320, 172328, 171418 },
	{ 173246, 172318, 172326, 171416 },
	{ 173243, 172315, 172323, 171413 },
	{ 178926, 178926, 178926, 178926 },
	{ 178926, 178926, 178926, 178926 },
}

local function InspectQueueFrame_OnUpdate(self, elapsed)
	elapsedTime = elapsedTime + elapsed
	if elapsedTime > INS_ONUPDATE_INTERVAL then
		Comms:RequestInspect()
		elapsedTime = 0
	end
end

function Comms:InitInspect()
	if self.init then
		return
	end

	InspectQueueFrame:Hide()
	InspectQueueFrame:SetScript("OnUpdate", InspectQueueFrame_OnUpdate)

	self.init = true
end

function Comms:EnableInspect()
	if self.enabledInspect or next(queueEntries) == nil then
		return
	end

	self:RegisterEvent("INSPECT_READY")
	InspectQueueFrame:Show()

	self.enabledInspect = true
end

function Comms:DisableInspect()
	if not self.enabledInspect then
		return
	end

	ClearInspectPlayer()
	self:UnregisterEvent("INSPECT_READY")
	InspectQueueFrame:Hide()

	wipe(P.pendingQueue)
	wipe(queueEntries)
	wipe(staleEntries)
	queried = nil
	paused = nil
	self.enabledInspect = false
end

function Comms:DequeueInspect(guid)
	if queried == guid then
		queried = nil
	end
	queueEntries[guid] = nil
	staleEntries[guid] = nil
end

function Comms:EnqueueInspect(force, guid)
	local added = GetTime()

	if force then
		wipe(P.pendingQueue)
		wipe(queueEntries)
		wipe(staleEntries)

		for guid in pairs(P.groupInfo) do
			if guid == E.userGUID then
				self:InspectPlayer()
			else
				queueEntries[guid] = added
			end
		end
	elseif guid then
		if guid == E.userGUID then
			self:InspectPlayer()
		else
			queueEntries[guid] = added
		end
	else
		if #P.pendingQueue == 0 then
			return
		end

		for i = #P.pendingQueue, 1, -1 do
			local guid = P.pendingQueue[i]
			if guid ~= E.userGUID then
				queueEntries[guid] = added
			end
			P.pendingQueue[i] = nil
		end
	end

	if paused then
		nextInquiryTime = 0
		paused = nil
	end

	self:EnableInspect()
end

function Comms:RequestInspect()
	local now = GetTime()
	if now < nextInquiryTime then return end
	if UnitIsDead("player") then return end
	if InspectFrame and InspectFrame:IsShown() then return end

	local stale = queried
	if stale then
		staleEntries[stale] = queueEntries[stale]
		queueEntries[stale] = nil
		queried = nil
	end

	if next(queueEntries) == nil then
		if next(staleEntries) then
			local copy = queueEntries
			queueEntries = staleEntries
			staleEntries = copy

			nextInquiryTime = now + INS_PAUSE_TIME
			paused = true
		else
			self:DisableInspect()
		end

		return
	end

	if paused then
		paused = nil
	end

	for guid, added in pairs(queueEntries) do
		local info = P.groupInfo[guid]
		local isSyncedUnit = self.syncGUIDS[guid]
		if info and not isSyncedUnit then -- [85]
			local unit = info.unit
			local elapsed = now - added
			if ( not UnitIsConnected(unit) or elapsed > INS_TIME_LIMIT ) then -- [80]
				self:DequeueInspect(guid)
			elseif ( not CanInspect(unit) ) then -- [54]
				staleEntries[guid] = added
				queueEntries[guid] = nil
			else
				nextInquiryTime = now + INS_DELAY_TIME
				queried = guid
				NotifyInspect(unit)
				return
			end
		else
			self:DequeueInspect(guid)
		end
	end
end

function Comms:INSPECT_READY(guid)
	if queried == guid then
		self:InspectUnit(guid)
	end
end

function Comms:InspectUnit(guid)
	local info = P.groupInfo[guid]
	if not info or self.syncGUIDS[guid] then -- [85]
		return
	end

	local unit = info.unit
	local specID = GetInspectSpecialization(unit)
	if not specID or specID == 0 then
		return
	end

	info.spec = specID
	info.talentData = {}
	info.invSlotData = {}
	info.shadowlandsData = {}

	for i = 1, 7 do
		for j = 1, 3 do
			local _,_,_, selected, _, spellID = GetTalentInfo(i, j, 1, true, unit)
			if selected then
				info.talentData[spellID] = true
				break
			end
		end
	end

	for i = 1, 3 do
		local talentID = GetInspectSelectedPvpTalent(unit, i)
		if talentID then
			local _,_,_,_,_, spellID = GetPvpTalentInfoByID(talentID)
			info.talentData[spellID] = "PVP"
		end
	end

	local class = info.class
	local runeforgePower = 0
	for i = 1, numInvSlotIDs do
		local slotID = invSlotIDs[i]
		InspectTooltip:SetInventoryItem(unit, slotID)
		local _, itemLink = InspectTooltip:GetItem()
		if itemLink then
			local itemID, _,_,_,_,_, itemSubClassID = GetItemInfoInstant(itemLink)
			if itemID then
				if i > 2 then
					local baseItem = runeforgeBaseItems[i]
					itemSubClassID = itemSubClassID == 0 and 1 or itemSubClassID
					if itemID == baseItem[itemSubClassID] then
						local _,_,_,_,_,_,_,_,_,_,_,_,_,numBonusIDs,bonusIDs = strsplit(":",itemLink,15)
						numBonusIDs = tonumber(numBonusIDs)
						if numBonusIDs and bonusIDs then
							local t = { strsplit(":", bonusIDs, numBonusIDs + 1) }
							for i = 1, numBonusIDs do
								local bonusID = t[i]
								bonusID = tonumber(bonusID)
								local runeforgeDescID = E.runeforge_bonusToDescID[bonusID]
								if runeforgeDescID then
									runeforgePower = runeforgeDescID
									break
								end
							end
						end
						break
					end
				else
					info.invSlotData[itemID] = true
				end
			end
		end
	end
	info.shadowlandsData.runeforgeDescID = runeforgePower
	info.talentData[runeforgePower] = "R"

	if info.level == 200 then
		local lvl = UnitLevel(unit)
		info.level = lvl > 0 and lvl or 200
	end

	ClearInspectPlayer()
	self:DequeueInspect(guid)

	P:UpdateUnitBar(guid)
end

local function GetCovenantSoulbindData()
	local info = P.userData

	local covenantID = C_Covenants.GetActiveCovenantID();
	if covenantID == 0 then
		return covenantID
	end

	local covenantSpellID = covenant_IDToSpellID[covenantID]
	info.shadowlandsData.covenantID = covenantSpellID
	info.talentData[covenantSpellID] = "C"

	local soulbindID = C_Soulbinds.GetActiveSoulbindID();
	if soulbindID == 0 then
		return covenantID
	end
	info.shadowlandsData.soulbindID = soulbindID

	local soulbindData = C_Soulbinds.GetSoulbindData(soulbindID);
	local nodes = soulbindData.tree and soulbindData.tree.nodes
	if not nodes then
		return covenantID .. "," .. soulbindID
	end

	local t = { covenantID, soulbindID }
	for i = 1, #nodes do
		local node = nodes[i]
		if node.state == Enum.SoulbindNodeState.Selected then
			local conduitID, conduitRank, spellID = node.conduitID, node.conduitRank, node.spellID
			if conduitID ~= 0 then
				spellID = C_Soulbinds.GetConduitSpellID(conduitID, conduitRank)
				local rankValue = soulbind_conduits_rank[spellID] and (soulbind_conduits_rank[spellID][conduitRank] or soulbind_conduits_rank[spellID][1])
				info.shadowlandsData[conduitID] = conduitRank
				info.talentData[spellID] = rankValue
				t[#t + 1] = conduitID .. "-" .. conduitRank
			elseif spellID ~= 0 then
				info.shadowlandsData[spellID] = 0
				info.talentData[spellID] = 0
				t[#t + 1] = spellID
			end
		end
	end

	return E.FormatConcat(t, "%s,")
end

--|cff9d9d9d|Hitem:itemID:enchantID:gemID1:gemID2:gemID3:gemID4:suffixID:uniqueID:linkLevel:specializationID:upgradeTypeID:instanceDifficultyID:numBonusIDs[:bonusID1:bonusID2:...][:upgradeValue1:upgradeValue2:...]:relic1NumBonusIDs[:relic1BonusID1:relic1BonusID2:...]:relic2NumBonusIDs[:relic2BonusID1:relic2BonusID2:...]:relic3NumBonusIDs[:relic3BonusID1:relic3BonusID2:...]:|h["displayed text"]|h|r
function Comms:InspectPlayer()
	local guid, class = E.userGUID, E.userClass
	local info = P.userData

	local specIndex = GetSpecialization()
	local specID = GetSpecializationInfo(specIndex) -- [58]
	if not specID or specID == 0 then
		return
	end

	info.spec = specID
	info.talentData = {}
	info.invSlotData = {}
	info.shadowlandsData = {}
	local tmp = {}

	for i = 1, 7 do
		local spellID
		for j = 1, 3 do
			local _,_,_, selected, _, id = GetTalentInfo(i, j, 1)
			if selected then
				spellID = id
				info.talentData[id] = true
				break
			end
		end
		tmp[i] = spellID or 0
	end

	for i = 1, 3 do
		local slotInfo = GetPvpTalentSlotInfo(i)
		local talentID = slotInfo and slotInfo.selectedTalentID
		if talentID then
			local _,_,_,_,_, spellID = GetPvpTalentInfoByID(talentID)
			info.talentData[spellID] = "PVP"
			tmp[i + 7] = spellID
		else
			tmp[i + 7] = 0
		end
	end

	local runeforgePower = 0
	for i = 1, numInvSlotIDs do
		local slotID = invSlotIDs[i]
		local itemID = GetInventoryItemID("player", slotID)
		if i > 2 then
			if itemID then
				local itemLink = GetInventoryItemLink("player", slotID)
				local itemLocation = ItemLocation:CreateFromEquipmentSlot(slotID)
				local isBaseItem = IsValidRuneforgeBaseItem(itemLocation)
				local isLegendary = IsRuneforgeLegendary(itemLocation)
				if isBaseItem then
					break
				end

				if isLegendary then
					local _,_,_,_,_,_,_,_,_,_,_,_,_,numBonusIDs,bonusIDs = strsplit(":",itemLink,15)
					numBonusIDs = tonumber(numBonusIDs)
					if numBonusIDs and bonusIDs then
						local t = { strsplit(":", bonusIDs, numBonusIDs + 1) }
						for i = 1, numBonusIDs do
							local bonusID = t[i]
							bonusID = tonumber(bonusID)
							local runeforgeDescID = E.runeforge_bonusToDescID[bonusID]
							if runeforgeDescID then
								runeforgePower = runeforgeDescID
								break
							end
						end
					end
					break
				end
			end
		else
			if itemID then
				info.invSlotData[itemID] = true
			end
			tmp[i + 10] = itemID or 0
		end
	end
	info.shadowlandsData.runeforgeDescID = runeforgePower
	info.talentData[runeforgePower] = "R"

	local talentInvSlots = table.concat(tmp, ",")
	local covenantSoulbinds = GetCovenantSoulbindData()
	E.syncData = strjoin(",", guid, specID, talentInvSlots, runeforgePower, covenantSoulbinds)

	if P.groupInfo[guid] then
		P:UpdateUnitBar(guid)
	end

	return true
end
