local Ellipsis = _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis_Options')
local LSM		= LibStub('LibSharedMedia-3.0')

local dropOutputAnnounce = {
	['AUTO']	= L.NotifyDropAnnounce_AUTO,
	['GROUPS']	= L.NotifyDropAnnounce_GROUPS,
	['RAID']	= L.NotifyDropAnnounce_RAID,
	['PARTY']	= L.NotifyDropAnnounce_PARTY,
	['SAY']		= L.NotifyDropAnnounce_SAY,
}

local notificationOptions = {
	announceHeader = {
		name = '  ' .. L.NotifyAnnounceHeader,
		type = 'description',
		order = 1,
		width = 'normal',
		fontSize = 'medium',
	},
	outputAnnounce = {
		name = L.NotifyOutputAnnounce,
		desc = L.NotifyOutputAnnounceDesc,
		type = 'select',
		order = 2,
		values = dropOutputAnnounce,
	},
	groupAlert = {
		name = L.NotifyAlertHeader,
		type = 'group',
		inline = true,
		order = 3,
		args = {
			auraBrokenAlerts = {
				name = L.NotifyBrokenAuras,
				desc = L.NotifyBrokenAurasDesc,
				type = 'toggle',
				order = 1,
			},
			auraBrokenAudio = {
				name = L.NotifyAlertAudio,
				desc = L.NotifyAlertAudioDesc,
				type = 'select',
				order = 2,
				width = 'half',
				values = LSM:HashTable('sound'),
				dialogControl = 'LSM30_Sound',
				disabled = function()
					return not Ellipsis.db.profile.notify.auraBrokenAlerts
				end,
			},
			auraBrokenText = {
				name = L.NotifyAlertText,
				desc = L.NotifyAlertTextDesc,
				type = 'toggle',
				order = 3,
				width = 'half',
				disabled = function()
					return not Ellipsis.db.profile.notify.auraBrokenAlerts
				end,
			},
			auraExpiredAlerts = {
				name = L.NotifyExpiredAuras,
				desc = L.NotifyExpiredAurasDesc,
				type = 'toggle',
				order = 4,
			},
			auraExpiredAudio = {
				name = L.NotifyAlertAudio,
				desc = L.NotifyAlertAudioDesc,
				type = 'select',
				order = 5,
				width = 'half',
				values = LSM:HashTable('sound'),
				dialogControl = 'LSM30_Sound',
				disabled = function()
					return not Ellipsis.db.profile.notify.auraExpiredAlerts
				end,
			},
			auraExpiredText = {
				name = L.NotifyAlertText,
				desc = L.NotifyAlertTextDesc,
				type = 'toggle',
				order = 6,
				width = 'half',
				disabled = function()
					return not Ellipsis.db.profile.notify.auraExpiredAlerts
				end,
			},
			coolPrematureAlerts = {
				name = L.NotifyPrematureCool,
				desc = L.NotifyPrematureCoolDesc,
				type = 'toggle',
				order = 7,
			},
			coolPrematureAudio = {
				name = L.NotifyAlertAudio,
				desc = L.NotifyAlertAudioDesc,
				type = 'select',
				order = 8,
				width = 'half',
				values = LSM:HashTable('sound'),
				dialogControl = 'LSM30_Sound',
				disabled = function()
					return not Ellipsis.db.profile.notify.coolPrematureAlerts
				end,
			},
			coolPrematureText = {
				name = L.NotifyAlertText,
				desc = L.NotifyAlertTextDesc,
				type = 'toggle',
				order = 9,
				width = 'half',
				disabled = function()
					return not Ellipsis.db.profile.notify.coolPrematureAlerts
				end,
			},
			coolCompleteAlerts = {
				name = L.NotifyCompleteCool,
				desc = L.NotifyCompleteCoolDesc,
				type = 'toggle',
				order = 10,
			},
			coolCompleteAudio = {
				name = L.NotifyAlertAudio,
				desc = L.NotifyAlertAudioDesc,
				type = 'select',
				order = 11,
				width = 'half',
				values = LSM:HashTable('sound'),
				dialogControl = 'LSM30_Sound',
				disabled = function()
					return not Ellipsis.db.profile.notify.coolCompleteAlerts
				end,
			},
			coolCompleteText = {
				name = L.NotifyAlertText,
				desc = L.NotifyAlertTextDesc,
				type = 'toggle',
				order = 12,
				width = 'half',
				disabled = function()
					return not Ellipsis.db.profile.notify.coolCompleteAlerts
				end,
			},
		}
	},
	groupAlertOutput = {
		name = L.NotifyAlertOutput,
		type = 'group',
		order = -1,
		args = {
			outputAlertsHeader = {
				name = L.NotifyAlertOutputHeader,
				type = 'description',
				order = 1,
				width = 'full',
			},
		}
	},
}

-- ------------------------
-- DATA TABLE RETURN
-- ------------------------
function Ellipsis:GetNotificationOptions()
	return notificationOptions
end


-- ------------------------
-- GETTERS & SETTERS
-- ------------------------
function Ellipsis:NotifyGet(info)
	return self.db.profile.notify[info[#info]]
end

function Ellipsis:NotifySet(info, val)
	self.db.profile.notify[info[#info]] = val
	self:ConfigureAuras() -- used to set whether alerts are passed through from Aura objects
end
