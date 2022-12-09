local E = select(2, ...):unpack()
local P = E.Party

local _G = _G
local IsInRaid, IsInGroup, UnitGUID = IsInRaid, IsInGroup, UnitGUID
local isColdStartDC = true

local COMPACT_RAID = {
	"CompactRaidFrame1", "CompactRaidFrame2", "CompactRaidFrame3", "CompactRaidFrame4", "CompactRaidFrame5",
	"CompactRaidFrame6", "CompactRaidFrame7", "CompactRaidFrame8", "CompactRaidFrame9", "CompactRaidFrame10",
	"CompactRaidFrame11", "CompactRaidFrame12", "CompactRaidFrame13", "CompactRaidFrame14", "CompactRaidFrame15",
	"CompactRaidFrame16", "CompactRaidFrame17", "CompactRaidFrame18", "CompactRaidFrame19", "CompactRaidFrame20",
	"CompactRaidFrame21", "CompactRaidFrame22", "CompactRaidFrame23", "CompactRaidFrame24", "CompactRaidFrame25",
	"CompactRaidFrame26", "CompactRaidFrame27", "CompactRaidFrame28", "CompactRaidFrame29", "CompactRaidFrame30",
	"CompactRaidFrame31", "CompactRaidFrame32", "CompactRaidFrame33", "CompactRaidFrame34", "CompactRaidFrame35",
	"CompactRaidFrame36", "CompactRaidFrame37", "CompactRaidFrame38", "CompactRaidFrame39", "CompactRaidFrame40",
	"CompactRaidFrame41", "CompactRaidFrame42", "CompactRaidFrame43", "CompactRaidFrame44", "CompactRaidFrame45",
	"CompactRaidFrame46", "CompactRaidFrame47", "CompactRaidFrame48", "CompactRaidFrame49", "CompactRaidFrame50",
}

local COMPACT_RAID_KGT = {
	"CompactRaidGroup1Member1", "CompactRaidGroup1Member2", "CompactRaidGroup1Member3", "CompactRaidGroup1Member4", "CompactRaidGroup1Member5",
	"CompactRaidGroup2Member1", "CompactRaidGroup2Member2", "CompactRaidGroup2Member3", "CompactRaidGroup2Member4", "CompactRaidGroup2Member5",
	"CompactRaidGroup3Member1", "CompactRaidGroup3Member2", "CompactRaidGroup3Member3", "CompactRaidGroup3Member4", "CompactRaidGroup3Member5",
	"CompactRaidGroup4Member1", "CompactRaidGroup4Member2", "CompactRaidGroup4Member3", "CompactRaidGroup4Member4", "CompactRaidGroup4Member5",
	"CompactRaidGroup5Member1", "CompactRaidGroup5Member2", "CompactRaidGroup5Member3", "CompactRaidGroup5Member4", "CompactRaidGroup5Member5",
	"CompactRaidGroup6Member1", "CompactRaidGroup6Member2", "CompactRaidGroup6Member3", "CompactRaidGroup6Member4", "CompactRaidGroup6Member5",
	"CompactRaidGroup7Member1", "CompactRaidGroup7Member2", "CompactRaidGroup7Member3", "CompactRaidGroup7Member4", "CompactRaidGroup7Member5",
	"CompactRaidGroup8Member1", "CompactRaidGroup8Member2", "CompactRaidGroup8Member3", "CompactRaidGroup8Member4", "CompactRaidGroup8Member5",
}

local COMPACT_PARTY = {
	"CompactPartyFrameMember1", "CompactPartyFrameMember2", "CompactPartyFrameMember3", "CompactPartyFrameMember4", "CompactPartyFrameMember5",
}

local PARTY_FRAME = {
	"PartyMemberFrame1", "PartyMemberFrame2", "PartyMemberFrame3", "PartyMemberFrame4",
}

function P:CompactFrameIsActive(isInRaid)
	return (isInRaid or IsInRaid()) and not self.isInArena or self.useRaidStylePartyFrames
end

function P:ShouldShowCompactFrame()
	return IsInGroup() and self:CompactFrameIsActive()
end

function P:CompactFrameIsShown()
	return self.isCompactFrameSetShown() and self:ShouldShowCompactFrame()
end

function P:FindRelativeFrame(guid)
	if E.customUF.active then
		if E.db.position.uf ~= "auto" then
			local frames, unitKey = E.customUF.frames, E.customUF.unit
			local n = #frames
			for i = 1, n do
				local name = frames[i]
				local f = _G[name]
				local unit = f and (f[unitKey] or f.GetAttribute and f:GetAttribute("unit"))
				if E.UNIT_TO_PET[unit] and UnitGUID(unit) == guid then
					return f:IsVisible() and f
				end
			end
			return
		end
		for addon, data in pairs(E.customUF.enabledList) do
			local frames, unitKey = data.frames, data.unit
			local n = #frames
			for i = 1, n do
				local name = frames[i]
				local f = _G[name]
				local unit = f and (f[unitKey] or f.GetAttribute and f:GetAttribute("unit"))
				if E.UNIT_TO_PET[unit] and UnitGUID(unit) == guid and f:IsVisible() then
					return f
				end
			end
		end
	end

	local isInRaid = IsInRaid()
	if E.isDF then

		local compactFrame = nil
		if isInRaid and not self.isInArena then
			compactFrame = self.isCompactFrameSetShown and (self.keepGroupsTogether and COMPACT_RAID_KGT or COMPACT_RAID)
		elseif IsInGroup() then
			compactFrame = self.useRaidStylePartyFrames and COMPACT_PARTY or false
		elseif EditModeManagerFrame:AreRaidFramesForcedShown() then
			compactFrame = self.isCompactFrameSetShown and (self.keepGroupsTogether and COMPACT_RAID_KGT or COMPACT_RAID)
		elseif EditModeManagerFrame:ArePartyFramesForcedShown() then
			compactFrame = EditModeManagerFrame:UseRaidStylePartyFrames() and COMPACT_PARTY or false
		end

		if compactFrame then
			local n = #compactFrame
			for i = 1, n do
				local name = compactFrame[i]
				local f = _G[name]
				local unit = f and f.unit
				if unit and UnitGUID(unit) == guid then
					return f:IsVisible() and f
				end
			end
		elseif compactFrame == false and (self.isInTestMode or guid ~= E.userGUID) then
			for memberFrame in PartyFrame.PartyMemberFramePool:EnumerateActive() do
				local unit = memberFrame.unit
				if unit and UnitGUID(unit) == guid then
					return memberFrame:IsVisible() and memberFrame
				end
			end
		end
	else
		if self:CompactFrameIsActive(isInRaid) or self.isInTestMode then
			if not self.isCompactFrameSetShown then return end
			local compactFrame = not self.keepGroupsTogether and COMPACT_RAID or (isInRaid and COMPACT_RAID_KGT or COMPACT_PARTY)
			local n = #compactFrame
			for i = 1, n do
				local name = compactFrame[i]
				local f = _G[name]
				local unit = f and f.unit
				if unit and UnitGUID(unit) == guid then
					return f:IsVisible() and f
				end
			end
		elseif guid ~= E.userGUID then
			for i = 1, 4 do
				local name = PARTY_FRAME[i]
				local f = _G[name]
				local unit = f and f.unit
				if unit and UnitGUID(unit) == guid then
					return f:IsVisible() and f
				end
			end
		end
	end
end

function P:SetAnchorPosition(frame)
	frame.anchor:ClearAllPoints()
	frame.anchor:SetPoint(self.anchorPoint, frame, self.point)
end

function P:SetOffset(frame)
	frame.container:ClearAllPoints()

	frame.container:SetPoint("TOPLEFT", frame, self.containerOfsX, self.containerOfsY)
end

function P:UpdatePosition()
	if self.disabled then
		return
	end

	if isColdStartDC then
		isColdStartDC = nil
		if IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") then
			self:UpdateCompactFrameSystemSettings()
		end
	end

	self:HideBars()

	local showRange = E.db.general.showRange
	local point, relPoint = self.point, self.relativePoint
	for guid, info in pairs(self.groupInfo) do
		local frame = info.bar
		if E.db.position.detached then
			frame:SetParent(UIParent);
			E.LoadPosition(frame)
			frame:Show()
		else
			local relFrame = self:FindRelativeFrame(guid)
			if relFrame then
				if showRange then
					frame:SetParent(relFrame)
					frame:SetFrameLevel(10)
				else
					frame:SetParent(UIParent)
				end
				frame:ClearAllPoints()
                local _, _, idx = (relFrame:GetName() or ""):find("PartyMemberFrame([1-4])")
                local EUF = idx and _G["EUF_PartyFrame"..idx.."HP"]
                local ox = EUF and EUF:IsVisible() and (self.relativePoint or ""):find("RIGHT") and 70 or idx and 12 or 0
				frame:SetPoint(point, relFrame, relPoint, ox, 0) --abyui adapt EUF
				frame:Show()
			end
		end

		self:SetAnchorPosition(frame)
		self:SetOffset(frame)
	end
end

function P:UpdateCompactFrameSystemSettings()
	if E.isDF then
		self.useRaidStylePartyFrames = EditModeManagerFrame:UseRaidStylePartyFrames();
		self.keepGroupsTogether = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
	else
		self.useRaidStylePartyFrames = C_CVar and C_CVar.GetCVarBool("useCompactPartyFrames") or GetCVarBool("useCompactPartyFrames")
		self.keepGroupsTogether = CompactRaidFrameManager_GetSetting("KeepGroupsTogether")
	end
	self.isCompactFrameSetShown = CompactRaidFrameManager_GetSetting("IsShown")
end

do
	local hookTimer

	local UpdatePosition_OnTimerEnd = function()
		P:UpdatePosition()
		hookTimer = nil
	end

	function P:HookFunc()
		if self.enabled and not E.db.position.detached and not hookTimer then
			hookTimer = C_Timer.NewTimer(0.5, UpdatePosition_OnTimerEnd)
		end
		if E.isDF and not E.customUF.active and self.isInTestMode and not EditModeManagerFrame:IsEditModeActive() then
			self:Test()
		end
	end

	function P:CVAR_UPDATE(cvar, value)
		if cvar == "USE_RAID_STYLE_PARTY_FRAMES" then
			self.useRaidStylePartyFrames = value == "1"
			self:HookFunc()
		end
	end

	function P:SetHooks()
		if self.hooked then
			return
		end

		if not IsAddOnLoaded("Blizzard_CompactRaidFrames") or not IsAddOnLoaded("Blizzard_CUFProfiles") then
			return
		end


		self:UpdateCompactFrameSystemSettings()

		if E.isDF then

			hooksecurefunc(EditModeManagerFrame, "UpdateRaidContainerFlow", function()
				P.keepGroupsTogether = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups()
				P:HookFunc()
			end)


			hooksecurefunc("UpdateRaidAndPartyFrames", function()
				P.useRaidStylePartyFrames = EditModeManagerFrame:UseRaidStylePartyFrames()
				P:HookFunc()
			end)


			hooksecurefunc("CompactRaidFrameManager_SetSetting", function(arg)
				if arg == "IsShown" then
					local isShown = CompactRaidFrameManager_GetSetting("IsShown")
					if P.isCompactFrameSetShown ~= isShown then
						P.isCompactFrameSetShown = isShown
						P:HookFunc()
					end
				end
			end)
		else
			hooksecurefunc("CompactUnitFrameProfiles_ApplyProfile", function(profile)
				if P:CompactFrameIsActive() then
					P:HookFunc()
				end
			end)

			hooksecurefunc("CompactRaidFrameManager_SetSetting", function(arg)
				if arg == "IsShown" then
					local isShown = CompactRaidFrameManager_GetSetting("IsShown")
					if P.isCompactFrameSetShown ~= isShown then
						P.isCompactFrameSetShown = isShown
						P:HookFunc()
					end
				elseif arg == "KeepGroupsTogether" then
					P.keepGroupsTogether = CompactRaidFrameManager_GetSetting("KeepGroupsTogether")
				end
			end)
		end

		self.hooked = true
	end
end
