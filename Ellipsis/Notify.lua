local Ellipsis	= _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')
local LSM		= LibStub('LibSharedMedia-3.0')

local TIME_ABRV_HOUR 	= '%dhr'
local TIME_ABRV_MINS 	= '%dm'
local TIME_ABRV_SECS 	= '%ds'
local TIME_ABRV_TENS	= '%.1fs'

local ceil = math.ceil
local IsInRaid, IsInGroup = IsInRaid, IsInGroup
local PlaySoundFile, SendChatMessage = PlaySoundFile, SendChatMessage

local notifyDB

local alertLastPlayed = {
	['auraBroken']		= 0,
	['auraExpired']		= 0,
	['coolPremature']	= 0,
	['coolComplete']	= 0
}


-- ------------------------
-- INITIALIZATION
-- ------------------------
function Ellipsis:InitializeNotify()
	notifyDB = self.db.profile.notify
end


-- ------------------------
-- ANNOUNCEMENTS
-- ------------------------
local function SecondsToTime_Abrv(time)
	if (time < 10) then
		return TIME_ABRV_TENS, time					-- tenths of a second
	elseif (time < 61) then
		return TIME_ABRV_SECS, time					-- seconds
	elseif (time < 3601) then
		return TIME_ABRV_MINS, ceil(time / 60)		-- minutes
	else
		return TIME_ABRV_HOUR, ceil(time / 3600)	-- hours
	end
end

function Ellipsis:Announce(object)
	local output = notifyDB.outputAnnounce
	local channel

	if (output == 'SAY') then -- always announce to say, proceed
		channel = 'SAY'
	else
		if (IsInRaid()) then
			channel = (output == 'AUTO') and 'RAID' or (output == 'GROUPS') and 'RAID' or (output == 'PARTY') and 'PARTY'
		elseif (IsInGroup()) then
			channel = (output == 'AUTO') and 'PARTY' or (output == 'GROUPS') and 'PARTY' or (output == 'PARTY') and 'PARTY'
		else -- not in a group of any kind
			channel = (output == 'AUTO') and 'SAY' or false
		end
	end

	if (not channel) then return end -- no valid channale is available, abort

	if (object.auraID) then -- this is an aura
		if (object.expired) then
			if (object.parentUnit.group == 'notarget') then -- was an aoe, or other global aura, not targeted
				SendChatMessage(format(L.Announce_ExpiredAura_NoTarget, object.spellName), channel)
			else
				SendChatMessage(format(L.Announce_ExpiredAura, object.spellName, object.parentUnit.unitName), channel)
			end
		else -- active aura
			local remains = format(SecondsToTime_Abrv(object.expireTime - GetTime())) -- co-opting the abbreviated time display from auras for announcements

			if (object.parentUnit.group == 'notarget') then -- is an aoe, or other global aura, not targeted
				if (object.duration == 0) then -- passive
					SendChatMessage(format(L.Announce_PassiveAura_NoTarget, object.spellName), channel)
				else
					SendChatMessage(format(L.Announce_ActiveAura_NoTarget, object.spellName, remains), channel)
				end
			else
				if (object.duration == 0) then -- passive
					SendChatMessage(format(L.Announce_PassiveAura, object.spellName, object.parentUnit.unitName), channel)
				else
					SendChatMessage(format(L.Announce_ActiveAura, object.spellName, object.parentUnit.unitName, remains), channel)
				end
			end
		end
	else -- not an aura, must be a cooldown timer
		if (object.expired) then return end -- no need to announce an expired cooldown timer

		local remains = format(SecondsToTime_Abrv(object.expireTime - GetTime())) -- co-opting the abbreviated time display from auras for announcements

		SendChatMessage(format(L.Announce_ActiveCooldown, object.timerName, remains), channel)
	end
end


-- ------------------------
-- ALERTS
-- ------------------------
function Ellipsis:AlertAura(isBroken, aura)
	if (aura.parentUnit.group == 'notarget') then return end -- don't show alerts for notarget auras

	if (isBroken) then
		if(notifyDB.auraBrokenAlerts) then
			if (notifyDB.auraBrokenAudio ~= 'None') then -- play audio for broken auras
				local time = GetTime()

				if ((time - alertLastPlayed['auraBroken']) > 0.25) then -- only play if its been a short time since the last audio alert
					alertLastPlayed['auraBroken'] = time

					PlaySoundFile(LSM:Fetch('sound', notifyDB.auraBrokenAudio), 'Master')
				end
			end

			if (notifyDB.auraBrokenText) then -- show message for broken auras
				self:Pour(format(L.Alert_BrokenAura, aura.spellName, aura.parentUnit.unitName))
			end
		end
	else -- expired
		if (notifyDB.auraExpiredAlerts) then
			if (notifyDB.auraExpiredAudio ~= 'None') then -- play audio for expired auras
				local time = GetTime()

				if ((time - alertLastPlayed['auraExpired']) > 0.25) then -- only play if its been a short time since the last audio alert
					alertLastPlayed['auraExpired'] = time

					PlaySoundFile(LSM:Fetch('sound', notifyDB.auraExpiredAudio), 'Master')
				end
			end

			if (notifyDB.auraExpiredText) then -- show message for expired auras
				self:Pour(format(L.Alert_ExpiredAura, aura.spellName, aura.parentUnit.unitName))
			end
		end
	end
end

function Ellipsis:AlertCooldown(isPremature, timer)
	if (isPremature) then
		if (notifyDB.coolPrematureAlerts) then
			if (notifyDB.coolPrematureAudio ~= 'None') then -- play audio for premature cooldown
				local time = GetTime()

				if ((time - alertLastPlayed['coolPremature']) > 0.25) then -- only play if its been a short time since the last audio alert
					alertLastPlayed['coolPremature'] = time

					PlaySoundFile(LSM:Fetch('sound', notifyDB.coolPrematureAudio), 'Master')
				end
			end

			if (notifyDB.coolPrematureText) then -- show message for premature cooldowns
				self:Pour(format(L.Alert_PrematureCool, timer.timerName))
			end
		end
	else -- completed
		if (notifyDB.coolCompleteAlerts) then
			if (notifyDB.coolCompleteAudio ~= 'None') then -- play audio for complete cooldown
				local time = GetTime()

				if ((time - alertLastPlayed['coolComplete']) > 0.25) then -- only play if its been a short time since the last audio alert
					alertLastPlayed['coolComplete'] = time

					PlaySoundFile(LSM:Fetch('sound', notifyDB.coolCompleteAudio), 'Master')
				end
			end

			if (notifyDB.coolCompleteText) then -- show message for complete cooldowns
				self:Pour(format(L.Alert_CompleteCool, timer.timerName))
			end
		end
	end
end
