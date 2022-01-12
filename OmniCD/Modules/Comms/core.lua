local E, L, C = select(2, ...):unpack()

local Comms = CreateFrame("Frame")
local P = E["Party"]

LibStub("AceComm-3.0"):Embed(Comms)

function Comms:Enable()
	if self.enabled then
		return
	end

--  [AC] self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	if E.isPreBCC then
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	else
		self:RegisterEventUnitPower()

		self:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
		self:RegisterEvent("UNIT_PET")
		self:RegisterEvent("COVENANT_CHOSEN")
		self:RegisterEvent("SOULBIND_ACTIVATED")
		self:RegisterEvent("SOULBIND_NODE_LEARNED")
		self:RegisterEvent("SOULBIND_NODE_UNLEARNED")
		self:RegisterEvent("SOULBIND_NODE_UPDATED")
		self:RegisterEvent("SOULBIND_CONDUIT_INSTALLED")
		self:RegisterEvent("SOULBIND_PATH_CHANGED")
		self:RegisterEvent("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
	end
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self:InitInspect()

	self.enabled = true
end

function Comms:Disable()
	if not self.enabled then
		return
	end

	self:UnregisterAllEvents()
	self:DisableInspect()
	self:Desync()

	self.enabled = false
end

function Comms:UNIT_PET(unit) -- changing spec will dismiss pet
	local pet = E.unitToPetId[unit]
	if not pet then
		return
	end

	local guid = UnitGUID(unit)
	local info = P.groupInfo[guid]
	if info and (info.class == "WARLOCK" or info.spec == 253) then
		local petGUID = info.petGUID
		if petGUID then
			E.Cooldowns.petGUIDS[petGUID] = nil
		end

		petGUID = UnitGUID(pet)
		if petGUID then
			info.petGUID = petGUID
			E.Cooldowns.petGUIDS[petGUID] = guid
		end
	end
end

function Comms:RegisterEventUnitPower()
	local specIndex = GetSpecialization()
	local specID = GetSpecializationInfo(specIndex)
	local threshold = E.POWER_TYPE_SPEC_OCC_THRESHOLD[specID]

	if not E.noPowerSync and threshold then
		self.oocThreshold = threshold
		if UnitAffectingCombat("player") then
			self:PLAYER_REGEN_DISABLED()
		else
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	else
		self.oocThreshold = nil
		self:UnregisterEvent("UNIT_POWER_UPDATE")
	end
end

E["Comms"] = Comms
