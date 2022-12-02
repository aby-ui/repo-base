local E = select(2, ...):unpack()
local CM = E.Comm

CM.SERIALIZATION_VERSION = 1

function CM:Enable()
	if self.enabled then
		return
	end


	self.AddonPrefix = E.AddOn
	local success = C_ChatInfo.RegisterAddonMessagePrefix(self.AddonPrefix)
	if success then
		self:RegisterEvent('CHAT_MSG_ADDON')
	else
		error("Failed to register AddonMessagePrefix")
	end
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	self:RegisterEvent('PLAYER_LEAVING_WORLD')
	if E.isWOTLKC then
		self:RegisterEvent('PLAYER_TALENT_UPDATE')
	elseif E.preCata then
		self:RegisterEvent('CHARACTER_POINTS_CHANGED')
	else
		if E.isDF then
			self:RegisterEvent('TRAIT_CONFIG_UPDATED')
		end
		self:RegisterEvent('UNIT_PET')
		self:RegisterEvent('COVENANT_CHOSEN')
		self:RegisterEvent('SOULBIND_ACTIVATED')
		self:RegisterEvent('SOULBIND_NODE_LEARNED')
		self:RegisterEvent('SOULBIND_NODE_UNLEARNED')
		self:RegisterEvent('SOULBIND_NODE_UPDATED')
		self:RegisterEvent('SOULBIND_CONDUIT_INSTALLED')
		self:RegisterEvent('SOULBIND_PATH_CHANGED')
		self:RegisterEvent('COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED')
		self:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', "player")
	end
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self:InitInspect()
	self:InitCooldownSync()

	self.enabled = true
end

function CM:Disable()
	if not self.enabled then
		return
	end

	self:UnregisterAllEvents()
	self:DisableInspect()
	self:DesyncFromGroup()

	self.enabled = false
end

function CM:UNIT_PET(unit)
	local pet = E.UNIT_TO_PET[unit]
	if not pet then
		return
	end

	local guid = UnitGUID(unit)
	local info = E.Party.groupInfo[guid]
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
