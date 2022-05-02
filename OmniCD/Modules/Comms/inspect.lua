local E, L, C = select(2, ...):unpack()

local InspectQueueFrame = CreateFrame("Frame")
local InspectTooltip = CreateFrame("GameTooltip", "OmniCDInspectToolTip", nil, "GameTooltipTemplate")
InspectTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local strjoin = strjoin
local strfind = string.find
local strmatch = string.match
local CanInspect = CanInspect
local GetTalentInfo = GetTalentInfo
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local Comms = E["Comms"]
local P = E["Party"]
local item_merged = E.item_merged
local INS_ONUPDATE_INTERVAL = 1
local INS_DELAY_TIME = 2
local INS_PAUSE_TIME = 2
local INS_TIME_LIMIT = 180
local elapsedTime = 0
local nextInquiryTime = 0
local queried, paused

local queueEntries = {}
local staleEntries = {}

local enhancedSoulbindRowRenownLevel = {
	[7]  = { [1] = 63, [3] = 66, [5] = 68, [6] = 72, [8] = 73, [10] = 78 },
	[13] = { [1] = 61, [3] = 64, [5] = 67, [6] = 70, [8] = 75, [10] = 79 },
	[18] = { [1] = 62, [3] = 65, [5] = 69, [6] = 71, [8] = 74, [10] = 77 },
	[8]  = { [1] = 63, [3] = 66, [5] = 68, [6] = 72, [8] = 73, [10] = 78 },
	[9]  = { [1] = 61, [3] = 64, [5] = 67, [6] = 70, [8] = 75, [10] = 79 },
	[3]  = { [1] = 62, [3] = 65, [5] = 69, [6] = 71, [8] = 74, [10] = 77 },
	[1]  = { [1] = 63, [3] = 66, [5] = 68, [6] = 72, [8] = 73, [10] = 78 },
	[2]  = { [1] = 61, [3] = 64, [5] = 67, [6] = 70, [8] = 75, [10] = 79 },
	[6]  = { [1] = 62, [3] = 65, [5] = 69, [6] = 71, [8] = 74, [10] = 77 },
	[4]  = { [1] = 63, [3] = 66, [5] = 68, [6] = 72, [8] = 73, [10] = 78 },
	[5]  = { [1] = 61, [3] = 64, [5] = 67, [6] = 70, [8] = 75, [10] = 79 },
	[10] = { [1] = 62, [3] = 65, [5] = 69, [6] = 71, [8] = 74, [10] = 77 },
}

local function IsSoulbindRowEnhanced(soulbindID, row, renownLevel)
	local minLevel = enhancedSoulbindRowRenownLevel[soulbindID] and enhancedSoulbindRowRenownLevel[soulbindID][row]
	if minLevel then
		return renownLevel >= minLevel
	end
end

local invSlotIDs = {
	13,
	14,
	16,
	1,
	2,
	3,
	15,
	5,
	9,
	10,
	6,
	7,
	8,
	11,
	12,
}
local numInvSlotIDs = #invSlotIDs

local runeforgeBaseItems = {
	[1] = { 173245, 172317, 172325, 171415 },
	[2] = { 178927, 178927, 178927, 178927 },
	[3] = { 173247, 172319, 172327, 171417 },
	[15]= { 173242, 173242, 173242, 173242 },
	[5] = { 173241, 172314, 172322, 171412 },
	[9] = { 173249, 172321, 172329, 171419 },
	[10]= { 173244, 172316, 172324, 171414 },
	[6] = { 173248, 172320, 172328, 171418 },
	[7] = { 173246, 172318, 172326, 171416 },
	[8] = { 173243, 172315, 172323, 171413 },
	[11]= { 178926, 178926, 178926, 178926 },
	[12]= { 178926, 178926, 178926, 178926 },
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

function Comms:DequeueInspect(guid, addToStale)
	if queried == guid then
		queried = nil
	end
	staleEntries[guid] = addToStale and queueEntries[guid] or nil
	queueEntries[guid] = nil
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
		if info and not isSyncedUnit then
			local unit = info.unit
			local elapsed = now - added
			if ( not UnitIsConnected(unit) or elapsed > INS_TIME_LIMIT ) then

				self:DequeueInspect(guid)
			elseif ( (E.isPreBCC and not CheckInteractDistance(unit,1)) or not CanInspect(unit) ) then


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

local item_setBonus = E.item_setBonus
local S_ITEM_SET_NAME  = "^" .. ITEM_SET_NAME:gsub("([%(%)])", "%%%1"):gsub("%%%d?$?d", "(%%d+)"):gsub("%%%d?$?s", "(.+)") .. "$"

if E.isPreBCC then
	local item_equipBonus = E.item_equipBonus
	local talentNameToRankID = E.talentNameToRankID

	function Comms:InspectUnit(guid)
		local info = P.groupInfo[guid]
		if not info or self.syncGUIDS[guid] then
			ClearInspectPlayer()
			return
		end

		local unit = info.unit
		info.spec = info.raceID
		info.talentData = {}
		info.invSlotData = {}

		for i = 1, 3 do
			for j = 1, 25 do


				local name, _,_,_, currentRank = GetTalentInfo(i, j, true, unit)
				if not name then break end
				if currentRank > 0 then
					local talent = talentNameToRankID[name]
					if talent then
						if type(talent[1]) == "table" then
							for k = 1, #talent do
								local t = talent[k]
								local talentID = t[currentRank]
								if talentID then
									info.talentData[talentID] = true
								end
							end
						else
							local talentID = talent[currentRank]
							if talentID then
								info.talentData[talentID] = true
							end
						end
					end
				end
			end
		end

		for i = numInvSlotIDs, 1, -1 do
			local slotID = invSlotIDs[i]
			InspectTooltip:SetInventoryItem(unit, slotID)
			local _, itemLink = InspectTooltip:GetItem()
			if itemLink then
				local itemID = GetItemInfoInstant(itemLink)
				if itemID then
					if i > 2 then

						local equipBonusID = item_equipBonus[itemID]
						if equipBonusID then
							info.talentData[equipBonusID] = true
						end

						local setBonus = item_setBonus[itemID]
						if setBonus then
							local bonusID, numRequired = setBonus[1], setBonus[2]
							if not info.talentData[bonusID] then
								for j = 10, InspectTooltip:NumLines() do
									local tooltipLine = _G["OmniCDInspectToolTipTextLeft"..j]
									local text = tooltipLine:GetText()
									if text and text ~= "" then
										local name, numEquipped, numFullSet = strmatch(text, S_ITEM_SET_NAME)
										if name and numEquipped and numFullSet then
											numEquipped = tonumber(numEquipped)
											if numEquipped and numEquipped >= numRequired then
												info.talentData[bonusID] = true
											end
											break
										end
									end
								end
							end
						end
					elseif i < 3 then
						itemID = item_merged[itemID] or itemID
						info.invSlotData[itemID] = true
					end
				end
			end

			InspectTooltip:ClearLines()
		end

		if info.level == 200 then
			local lvl = UnitLevel(unit)
			info.level = lvl > 0 and lvl or 200
		end

		ClearInspectPlayer()
		self:DequeueInspect(guid)

		P:UpdateUnitBar(guid)
	end

	function Comms:InspectPlayer()
		local guid = E.userGUID
		local info = P.userData

		info.spec = info.raceID
		info.talentData = {}
		info.invSlotData = {}
		local tmp = {}

		local c = 0
		for i = 1, 3 do
			for j = 1, 25 do
				local name, _,_,_, currentRank = GetTalentInfo(i, j)
				if not name then
					break
				end

				if currentRank > 0 then
					local talent = talentNameToRankID[name]
					if talent then
						if type(talent[1]) == "table" then
							for k = 1, #talent do
								local t = talent[k]
								local talentID = t[currentRank]
								if talentID then
									info.talentData[talentID] = true
									c = c + 1
									tmp[c] = talentID
								end
							end
						else
							local talentID = talent[currentRank]
							if talentID then
								info.talentData[talentID] = true
								c = c + 1
								tmp[c] = talentID
							end
						end
					end
				end
			end
		end

		local speed = UnitRangedDamage("player")
		if speed and speed > 0 then
			info.RAS = speed
			c = c + 1
			tmp[c] = -speed
		end

		local isDelimiter
		for i = numInvSlotIDs, 1, -1 do
			local slotID = invSlotIDs[i]
			local itemID = GetInventoryItemID("player", slotID)
			if itemID then
				if i > 3 then
					InspectTooltip:SetInventoryItem("player", slotID)

					local equipBonusID = item_equipBonus[itemID]
					if equipBonusID then
						info.talentData[equipBonusID] = true
						c = c + 1
						tmp[c] = equipBonusID
					end

					local setBonus = item_setBonus[itemID]
					if setBonus then
						local bonusID, numRequired = setBonus[1], setBonus[2]
						if not info.talentData[bonusID] then
							for j = 10, InspectTooltip:NumLines() do
								local tooltipLine = _G["OmniCDInspectToolTipTextLeft"..j]
								local text = tooltipLine:GetText()
								if text and text ~= "" then
									local name, numEquipped, numFullSet = strmatch(text, S_ITEM_SET_NAME)
									if name and numEquipped and numFullSet then
										numEquipped = tonumber(numEquipped)
										if numEquipped and numEquipped >= numRequired then
											info.talentData[bonusID] = true
											c = c + 1
											tmp[c] = bonusID
										end
										break
									end
								end
							end
						end
					end

					InspectTooltip:ClearLines()
				elseif i < 3 then
					if not isDelimiter then
						c = c + 1
						tmp[c] = "|"
						isDelimiter = true
					end
					itemID = item_merged[itemID] or itemID
					info.invSlotData[itemID] = true
					c = c + 1
					tmp[c] = itemID
				end
			end
		end

		local talentInvSlots = table.concat(tmp, ",")
		E.syncData = strjoin(",", guid, info.spec, talentInvSlots)

		if P.groupInfo[guid] then
			P:UpdateUnitBar(guid)
		end

		return true
	end
else
	local GetInspectSpecialization = GetInspectSpecialization
	local GetSpecialization = GetSpecialization
	local GetSpecializationInfo = GetSpecializationInfo
	local GetInspectSelectedPvpTalent = C_SpecializationInfo.GetInspectSelectedPvpTalent
	local GetPvpTalentInfoByID = GetPvpTalentInfoByID
	local GetPvpTalentSlotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo

	local GetRenownLevel = C_CovenantSanctumUI.GetRenownLevel
	local IsValidRuneforgeBaseItem = C_LegendaryCrafting.IsValidRuneforgeBaseItem
	local IsRuneforgeLegendary = C_LegendaryCrafting.IsRuneforgeLegendary
	local soulbind_conduits_rank = E.soulbind_conduits_rank
	local covenant_IDToSpellID = E.covenant_IDToSpellID

	local item_unity = E.item_unity
	E.lazySyncData = {}

	function Comms:InspectUnit(guid)
		local info = P.groupInfo[guid]
		if not info or self.syncGUIDS[guid] then
			ClearInspectPlayer()
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

		local addToStale
		local numRuneforge = 0
		local numSetBonus = 0
		local foundSetBonus
		for i = 1, numInvSlotIDs do
			local slotID = invSlotIDs[i]
			local itemLink = GetInventoryItemLink(unit, slotID)
			if itemLink then
				local itemID, _,_,_,_,_, itemSubClassID = GetItemInfoInstant(itemLink)
				if itemID then
					if i > 3 then
						local setBonus = item_setBonus[itemID]
						if setBonus then
							if numSetBonus < 2 and setBonus ~= foundSetBonus then
								local specSetBonus = setBonus[specID]
								if specSetBonus then
									local bonusID, numRequired = specSetBonus[1], specSetBonus[2]
									InspectTooltip:SetInventoryItem(unit, slotID)
									for j = 10, InspectTooltip:NumLines() do
										local tooltipLine = _G["OmniCDInspectToolTipTextLeft"..j]
										local text = tooltipLine:GetText()
										if text and text ~= "" then
											local name, numEquipped, numFullSet = strmatch(text, S_ITEM_SET_NAME)
											if name and numEquipped and numFullSet then
												numEquipped = tonumber(numEquipped)
												if numEquipped and numEquipped >= numRequired then
													info.talentData[bonusID] = "S"
												end
												break
											end
										end
									end
									InspectTooltip:ClearLines()
								end
								foundSetBonus = setBonus
								numSetBonus = numSetBonus + 1
							end
						else
							local unity = item_unity[itemID]
							if unity then
								if type(unity) == "table" then
									for i = 1, #unity do
										local runeforgeDescID = unity[i]
										info.talentData[runeforgeDescID] = "R"
									end
								else
									info.talentData[unity] = "R"
								end
								numRuneforge = numRuneforge + 1
							elseif numRuneforge < 2 then
								local baseItem = runeforgeBaseItems[slotID]
								itemSubClassID = itemSubClassID == 0 and 1 or itemSubClassID
								if itemID == baseItem[itemSubClassID] then
									local _,_,_,_,_,_,_,_,_,_,_,_,_,numBonusIDs,bonusIDs = strsplit(":",itemLink,15)
									numBonusIDs = tonumber(numBonusIDs)
									if numBonusIDs and bonusIDs then
										local t = { strsplit(":", bonusIDs, numBonusIDs + 1) }
										for j = 1, numBonusIDs do
											local bonusID = t[j]
											bonusID = tonumber(bonusID)
											local runeforgeDescID = E.runeforge_bonusToDescID[bonusID]
											if runeforgeDescID then
												if type(runeforgeDescID) == "table" then
													for _, v in pairs(runeforgeDescID) do
														info.talentData[v] = "R"
													end
												else
													info.talentData[runeforgeDescID] = "R"
												end
												break
											end
										end
									end
									numRuneforge = numRuneforge + 1
								end
							end
						end
					else
						itemID = item_merged[itemID] or itemID
						info.invSlotData[itemID] = true
					end
				end
			elseif not addToStale then
				addToStale = true
			end
		end

		if info.level == 200 then
			local lvl = UnitLevel(unit)
			info.level = lvl > 0 and lvl or 200
		end
		if info.name == "Unknown" then
			info.name = GetUnitName(unit, true)
		end

		ClearInspectPlayer()
		self:DequeueInspect(guid, addToStale)

		P:UpdateUnitBar(guid)
	end

	local function GetCovenantSoulbindData()
		local info = P.userData

		local covenantID = C_Covenants.GetActiveCovenantID();
		if covenantID == 0 then
			return
		end

		local covenantSpellID = covenant_IDToSpellID[covenantID]
		info.shadowlandsData.covenantID = covenantID
		info.talentData[covenantSpellID] = "C"
		local t = { "|C" }
		t[#t + 1] = covenantID

		local soulbindID = C_Soulbinds.GetActiveSoulbindID();
		if soulbindID == 0 then
			return t
		end
		info.shadowlandsData.soulbindID = soulbindID
		t[#t + 1] = soulbindID

		local soulbindData = C_Soulbinds.GetSoulbindData(soulbindID);
		local nodes = soulbindData.tree and soulbindData.tree.nodes
		if not nodes then
			return t
		end

		local renownLevel = GetRenownLevel()
		for i = 1, #nodes do
			local node = nodes[i]
			if node.state == Enum.SoulbindNodeState.Selected then
				local conduitID, conduitRank, row, spellID = node.conduitID, node.conduitRank, node.row, node.spellID
				if conduitID ~= 0 then
					spellID = C_Soulbinds.GetConduitSpellID(conduitID, conduitRank)
					if IsSoulbindRowEnhanced(soulbindID, row, renownLevel) then
						conduitRank = conduitRank + 2
					end
					local rankValue = soulbind_conduits_rank[spellID] and (soulbind_conduits_rank[spellID][conduitRank] or soulbind_conduits_rank[spellID][1])
					if rankValue then
						info.talentData[spellID] = rankValue
						t[#t + 1] = spellID .. "-" .. rankValue
					end
				elseif spellID ~= 0 then
					info.talentData[spellID] = 0
					t[#t + 1] = spellID
				end
			end
		end

		return t
	end


	function Comms:InspectPlayer()
		local guid = E.userGUID
		local info = P.userData

		local specIndex = GetSpecialization()
		local specID = GetSpecializationInfo(specIndex)
		if not specID or specID == 0 then
			return
		end

		info.spec = specID
		info.talentData = {}
		info.invSlotData = {}
		info.shadowlandsData = {}

		local tmp = { guid, specID, 2700, "|T" }
		for i = 1, 7 do
			for j = 1, 3 do
				local _,_,_, selected, _, id = GetTalentInfo(i, j, 1)
				if selected then
					info.talentData[id] = true
					tmp[#tmp + 1] = id
					break
				end
			end
		end

		for i = 1, 3 do
			local slotInfo = GetPvpTalentSlotInfo(i)
			local talentID = slotInfo and slotInfo.selectedTalentID
			if talentID then
				local _,_,_,_,_, spellID = GetPvpTalentInfoByID(talentID)
				info.talentData[spellID] = "PVP"
				tmp[#tmp + 1] = -spellID
			end
		end

		local covenantSoulbinds = GetCovenantSoulbindData()
		local tmpEquipped = { "|E" }
		local tmpSync = {}
		local numRuneforge = 0
		local numSetBonus = 0
		local foundSetBonus
		local isRaidZone = P.zone == "raid"

		for i = 1, numInvSlotIDs do
			local slotID = invSlotIDs[i]
			local itemID = GetInventoryItemID("player", slotID)
			if itemID then
				if i > 3 then
					local setBonus = item_setBonus[itemID]
					if setBonus then
						if numSetBonus< 2 and setBonus ~= foundSetBonus then
							local specSetBonus = setBonus[specID]
							if specSetBonus then
								local bonusID, numRequired = specSetBonus[1], specSetBonus[2]
								InspectTooltip:SetInventoryItem("player", slotID)
								for j = 10, InspectTooltip:NumLines() do
									local tooltipLine = _G["OmniCDInspectToolTipTextLeft"..j]
									local text = tooltipLine:GetText()
									if text and text ~= "" then
										local name, numEquipped, numFullSet = strmatch(text, S_ITEM_SET_NAME)
										if name and numEquipped and numFullSet then
											numEquipped = tonumber(numEquipped)
											if numEquipped and numEquipped >= numRequired then
												info.talentData[bonusID] = "S"
												tmp[#tmp + 1] = bonusID


												local syncList = E.sync_setBonus[bonusID];
												if ( syncList ) then
													for i = 1, #syncList do
														local id = syncList[i];
														if type(id) == "table" then
															local bid, tid = id[1], id[2]
															if tid and tid < 0 then
																id = not info.talentData[-tid] and bid or -tid
															else
																id = info.talentData[tid or bid] and bid
															end
														end
														if ( id and (not isRaidZone or E.sync_inRaid[id]) ) then
															tmpSync[id] = { 0, 0 };
														end
													end
												end
											end
											break
										end
									end
								end
								InspectTooltip:ClearLines()
							end
							foundSetBonus = setBonus
							numSetBonus = numSetBonus + 1
						end
					else
						local unity = item_unity[itemID]
						if unity then
							if type(unity) == "table" then
								for i = 1, #unity do
									local runeforgeDescID = unity[i]
									info.talentData[runeforgeDescID] = "R"
									tmp[#tmp + 1] = runeforgeDescID
								end
							else
								info.talentData[unity] = "R"
								tmp[#tmp + 1] = unity
							end
							numRuneforge = numRuneforge + 1
						elseif numRuneforge < 2 then
							local itemLink = GetInventoryItemLink("player", slotID)
							local itemLocation = ItemLocation:CreateFromEquipmentSlot(slotID)
							local isBaseItem = IsValidRuneforgeBaseItem(itemLocation)
							local isLegendary = IsRuneforgeLegendary(itemLocation)
							if isLegendary then
								local _,_,_,_,_,_,_,_,_,_,_,_,_,numBonusIDs,bonusIDs = strsplit(":",itemLink,15)
								numBonusIDs = tonumber(numBonusIDs)
								if numBonusIDs and bonusIDs then
									local t = { strsplit(":", bonusIDs, numBonusIDs + 1) }
									for j = 1, numBonusIDs do
										local bonusID = t[j]
										bonusID = tonumber(bonusID)
										local runeforgeDescID = E.runeforge_bonusToDescID[bonusID]
										if runeforgeDescID then
											if type(runeforgeDescID) == "table" then
												for _, v in pairs(runeforgeDescID) do
													info.talentData[v] = "R"
													tmp[#tmp + 1] = v
												end
											else
												local spec = E.runeforge_specID[runeforgeDescID]
												if not spec or spec == specID then
													info.talentData[runeforgeDescID] = "R"
													tmp[#tmp + 1] = runeforgeDescID
												end
											end
											break
										end
									end
								end
								numRuneforge = numRuneforge + 1
							elseif isBaseItem then
								numRuneforge = numRuneforge + 1
							end
						end
					end
				else
					itemID = item_merged[itemID] or itemID
					info.invSlotData[itemID] = true
					tmpEquipped[#tmpEquipped + 1] = itemID
				end
			end
		end

		E.syncData = E.MergeConcat(tmp, tmpEquipped, covenantSoulbinds)


		for class, t in pairs(E.sync_cooldowns) do
			if ( class == info.class or class == "ALL" ) then
				for k, v in pairs(t) do
					if ( not isRaidZone or E.sync_inRaid[k] ) then
						local isValid = k < 599 and k == specID or info.talentData[k];
						if ( isValid ) then
							for id, spec in pairs(v) do
								local spellID;
								if ( type(spec) == "table" ) then
									local talent, specialization = spec[1], spec[2];
									spellID = info.talentData[talent] and talent or (specialization == specID and id);
								elseif ( spec == true ) then
									spellID = id;
								elseif ( spec < 0 ) then
									spellID = not info.talentData[-spec] and id or -spec;
								elseif ( spec < 599 ) then
									spellID = spec == specID and id;
								else
									spellID = info.talentData[spec] and id;
								end
								if ( spellID ) then
									tmpSync[spellID] = { 0, 0 };
								end
							end
						end
					end
				end
			end
		end
		E.lazySyncData = tmpSync;
		self:ToggleLazySync();

		if P.groupInfo[guid] then
			P:UpdateUnitBar(guid)
		end

		return true
	end
end
