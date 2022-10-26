local E, L, C = select(2, ...):unpack()

local _G = _G
local IsInRaid = IsInRaid
local UnitGUID = UnitGUID
local P = E["Party"]
local isColdStartDC = true

function P:IsCRFActive()
	return IsInRaid() and not self.isInArena or self.useCRF
end

local function FindAnchorFrame(guid)
	local db = E.db.position.uf
	if E.customUF.enabled and db ~= "blizz" then
		local MIN, MAX = E.customUF.minIndex, E.customUF.index
		local frameName, frameUnit = E.customUF.frame, E.customUF.unit
		if db == "HealBot" then
			for i = 1, MAX do
				local f = _G[frameName .. i]
				if f and f:IsVisible() then
					local unit = f[frameUnit]
					if unit and unit ~= "target" and unit ~= "focus" and UnitGUID(unit) == guid then return f end
				end
			end
		elseif strfind(frameName, "%%d") then
			for i = MIN, 8 do
				local name = format(frameName, i)
				for j = 1, MAX do
					local f = _G[name .. j]
					if f and f:IsVisible() then
						local unit = f[frameUnit] or f.GetAttribute and f:GetAttribute("unit") -- ATA					
						if unit and UnitGUID(unit) == guid then return f end
					end
				end
			end
		else
			for i = 1, MAX do
				local f = _G[frameName .. i]
				if f and f:IsVisible() then
					local unit = f[frameUnit]
					if unit == nil and f.GetAttribute then unit = f:GetAttribute("unit") end --abyui
					if unit and UnitGUID(unit) == guid then return f end
				end
			end
		end

		if E.db.position.uf ~= "auto" then return end
	end

	if ( P:IsCRFActive() or P.test ) then
		if P.isShownCRFM then
			local crf = not P.useKGT and E.CRF_RAID or ( IsInRaid() and E.CRF_KGT or E.CRF_PARTY )
			local n = #crf
			for i = 1, n do
				local name = crf[i]
				local f = _G[name]
				if f and f:IsVisible() and f.unit and UnitGUID(f.unit) == guid then return f end
			end
		end
	elseif guid ~= E.userGUID then
		for i = 1, 4 do
			local f = _G["PartyMemberFrame" .. i]
			if f and f:IsVisible() and f.unit and UnitGUID(f.unit) == guid then return f end
		end
	end
end
P.FindAnchorFrame = FindAnchorFrame

function P:SetAnchorPosition(f)
	f.anchor:ClearAllPoints()
	f.anchor:SetPoint(self.anchorPoint, f, self.point)
end

function P:SetOffset(f)
	f.container:ClearAllPoints()

	f.container:SetPoint("TOPLEFT", f, self.containerOfsX, self.containerOfsY)
end

function P:UpdatePosition()
	if P.disabled then
		return
	end

	if isColdStartDC then
		isColdStartDC = nil
		if IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") then
			P:UpdateCRFCVars()
		end
	end

	P:HideBars()

	local showRange = E.db.general.showRange
	for guid, info in pairs(P.groupInfo) do
		local f = info.bar
		if E.db.position.detached then
			f:SetParent(UIParent);
			E.LoadPosition(f)
			f:Show()
		else
			local frame = FindAnchorFrame(guid)
			if frame then
				if ( showRange ) then
					f:SetParent(frame);
					f:SetFrameLevel(10);
				else
					f:SetParent(UIParent);
				end
				f:ClearAllPoints()
                local _, _, idx = (frame:GetName() or ""):find("PartyMemberFrame([1-4])")
                local EUF = idx and _G["EUF_PartyFrame"..idx.."HP"]
                local ox = EUF and EUF:IsVisible() and (P.relativePoint or ""):find("RIGHT") and 70 or idx and 12 or 0
				f:SetPoint(P.point, frame, P.relativePoint, ox, 0) --abyui adapt EUF
				f:Show()
			end
		end

		P:SetAnchorPosition(f)
		P:SetOffset(f)
	end
end

function P:UpdateCRFCVars()
	self.useCRF = C_CVar and C_CVar.GetCVarBool("useCompactPartyFrames") or GetCVarBool("useCompactPartyFrames")
	self.useKGT = CompactRaidFrameManager_GetSetting("KeepGroupsTogether")
	self.isShownCRFM = CompactRaidFrameManager_GetSetting("IsShown")
end

do
	local hookTimer

	local onTimerEnd = function()
		P:UpdatePosition()
		hookTimer = nil
	end

	function P:CVAR_UPDATE(cvar, value)
		if cvar == "USE_RAID_STYLE_PARTY_FRAMES" then
			self.useCRF = value == "1"

			if P.enabled and not E.db.position.detached and not hookTimer then
				hookTimer = C_Timer.NewTicker(0.5, onTimerEnd, 1)
			end
		end
	end

	local hookFunc = function()
		if P.enabled and not E.db.position.detached and P:IsCRFActive() then
			if not hookTimer then
				hookTimer = C_Timer.NewTicker(0.5, onTimerEnd, 1)
			end
		end
	end

	function P:SetHooks()
		if self.hooked then
			return
		end


		if ( not IsAddOnLoaded("Blizzard_CompactRaidFrames") or not IsAddOnLoaded("Blizzard_CUFProfiles") ) then
			return
		end

		self:UpdateCRFCVars()


		hooksecurefunc("CompactRaidFrameManager_SetSetting", function(arg)
			if arg == "IsShown" then
				local isShown = CompactRaidFrameManager_GetSetting("IsShown")
				if P.isShownCRFM ~= isShown then
					P.isShownCRFM = isShown
					hookFunc()
				end
			elseif arg == "KeepGroupsTogether" then
				P.useKGT = CompactRaidFrameManager_GetSetting("KeepGroupsTogether")
			end
		end)

		--hooksecurefunc("CompactUnitFrameProfiles_ApplyProfile", function(profile)
		--	hookFunc()
		--end)

		self.hooked = true
	end
end
