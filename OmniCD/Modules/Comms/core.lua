local E, L, C = select(2, ...):unpack()

local Comms = CreateFrame("Frame")
local P = E["Party"]

LibStub("AceComm-3.0"):Embed(Comms)

function Comms:Enable()
	if self.enabled then
		return
	end

	--[AC] self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	if not E.isBCC then
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

function Comms:PLAYER_SPECIALIZATION_CHANGED()
	self:InspectPlayer()
	self:SendSync()
	self:RegisterEventUnitPower()
end

function Comms:UNIT_PET(unit) -- [73]
	local pet = E.unitToPetId[unit]
	if not pet then
		return
	end

	local guid = UnitGUID(unit)
	local info = P.groupInfo[guid]
	if info and info.spec == 253 then
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

function Comms:COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED()
	self:InspectPlayer()
	self:SendSync()
end

E["Comms"] = Comms
