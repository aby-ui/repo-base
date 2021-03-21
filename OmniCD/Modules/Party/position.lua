local E, L, C = select(2, ...):unpack()

local _G = _G
local IsInRaid = IsInRaid
local UnitGUID = UnitGUID
local P = E["Party"]

function P:IsCRFActive() -- [21]
	return IsInRaid() and not self.isInArena or self.useCRF
end

local function FindAnchorFrame(guid) --[87]
	if E.customUF.enabled and E.db.position.uf ~= "blizz" then
		if not P.isInDungeon and GetNumGroupMembers() > 5 then return end -- MDI

		for i = 1, 5 do
			local f = _G[E.customUF.frame .. i]
			if f and f:GetPoint() then -- [93]
				local unit = f[E.customUF.unit]
                if unit == nil and f.GetAttribute then unit = f:GetAttribute("unit") end
				if unit and UnitGUID(unit) == guid then return f end
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
				if f and f.unit and UnitGUID(f.unit) == guid then return f end
			end
		end
	elseif guid ~= E.userGUID then
		for i = 1, 4 do
			local f = _G["PartyMemberFrame" .. i]
			if f and f.unit and UnitGUID(f.unit) == guid then return f end
		end
	end
end

function P:SetAnchorPosition(f)
	f.anchor:ClearAllPoints()
	f.anchor:SetPoint(self.anchorPoint, f, self.point)
end

function P:SetOffset(f)
	f.container:ClearAllPoints()
	--f.container:SetPoint(self.point, f, self.containerOfsX, self.containerOfsY)
	f.container:SetPoint("TOPLEFT", f, self.containerOfsX, self.containerOfsY)
end

function P:UpdatePosition()
	if P.disabled then
		return
	end

	P:HideBars() -- [63]

	for guid, info in pairs(P.groupInfo) do
		local f = info.bar
		if E.db.position.detached then
			E.LoadPosition(f)
			f:Show()
		else
			local frame = FindAnchorFrame(guid)
			if frame then
                local _, _, idx = (frame:GetName() or ""):find("PartyMemberFrame([1-4])")
                local EUF = idx and _G["EUF_PartyFrame"..idx.."HP"]
                local ox = EUF and EUF:IsVisible() and (self.relativePoint or ""):find("RIGHT") and 70 or idx and 12 or 0
				f:ClearAllPoints()
				f:SetPoint(P.point, frame, P.relativePoint, ox, 0) --abyui adapt EUF
				f:Show()
			end
		end

		P:SetAnchorPosition(f)
		P:SetOffset(f)
	end
end

function P:CVAR_UPDATE(cvar, value)
	if cvar == "USE_RAID_STYLE_PARTY_FRAMES" then
		self.useCRF = value == "1"

		if not E.db.position.detached then
			self:UpdatePosition()
		end
	end
end

do
	local hookTimer

	local onTimerEnd = function()
		P:UpdatePosition()
		hookTimer = nil
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

		-- Grid2
		if ( not IsAddOnLoaded("Blizzard_CompactRaidFrames") or not IsAddOnLoaded("Blizzard_CUFProfiles") ) then return end

		self.useCRF = C_CVar.GetCVarBool("useCompactPartyFrames")
		self.useKGT = CompactRaidFrameManager_GetSetting("KeepGroupsTogether")
		self.isShownCRFM = CompactRaidFrameManager_GetSetting("IsShown")
		self.activeRaidProfile = GetActiveRaidProfile()

		hooksecurefunc("CompactRaidFrameManager_SetSetting", function(arg) -- [64]
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

		hooksecurefunc("CompactUnitFrameProfiles_ApplyProfile", function(profile)
			hookFunc()
		end)

		self.hooked = true
	end
end
