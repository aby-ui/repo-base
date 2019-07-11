-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local strfind =
	  strfind
local PlaySoundFile =
	  PlaySoundFile


local LSM = LibStub("LibSharedMedia-3.0")


local Sound = TMW.C.EventHandler_WhileConditions_Repetitive:New("Sound", 10)
Sound.frequencyMinimum = 0.2

Sound:RegisterEventDefaults{
	Sound = "None",
}

TMW:RegisterUpgrade(42105, {
	-- cleanup some old stuff that i noticed is sticking around in my settings, probably in other peoples' settings too
	iconEventHandler = function(self, eventSettings)
		-- Major screw up: It should be "None", not "" for no sound.
		-- I think this is an old artifact of the 42102 upgrade.
		if eventSettings.Sound == "" then
			eventSettings.Sound = "None"
		end
	end,
})
TMW:RegisterUpgrade(42102, {
	icon = function(self, ics)
		local Events = ics.Events
		Events.OnShow.Sound = ics.SoundOnShow or "None"

		Events.OnHide.Sound = ics.SoundOnHide or "None"

		Events.OnStart.Sound = ics.SoundOnStart or "None"

		Events.OnFinish.Sound = ics.SoundOnFinish or "None"

		ics.SoundOnShow		= nil
		ics.SoundOnHide		= nil
		ics.SoundOnStart	= nil
		ics.SoundOnFinish	= nil
	end,
})


-- Helper methods
function Sound:GetSoundFileFromSettingValue(sound)

	sound = TMW:CleanPath(sound)
	local quiet = TMW:CleanPath("Interface/Quiet.ogg")

	if sound == "" or sound == quiet or sound == "None" then
		return nil, false

	elseif tonumber(sound) then
		return sound, true

	elseif strfind(sound, "%.[^/]+$") or tonumber(sound) then

		-- Checks to see if sound is a file name (although poorly). Checks for a period followed by non-slashes:
		-- Also allows numbers to pass through for PlaySoundKitID
		-- Good: file.ogg; path/to/file.ogg
		-- Bad: file; path/to/file; folder.with.periods/containing/file.ogg
		return sound, false
	else
		-- This will handle sounds from LSM.
		local s = LSM:Fetch("sound", sound)
		
		-- Some addons (BigWigs) are registering soundkitIDs with LSM.
		if tonumber(s) then
			return s, false
		end

		s = TMW:CleanPath(s)
		if s and s ~= quiet and s ~= "" then
			return s, false
		end
	end
end


-- Required methods
function Sound:ProcessIconEventSettings(event, eventSettings)
	return not not self:GetSoundFileFromSettingValue(eventSettings.Sound)
end

function Sound:HandleEvent(icon, eventSettings)
	return self:PlaySoundFromSettingValue(eventSettings.Sound)
end

function Sound:PlaySoundFromSettingValue(settingValue)
	local sound, isKit = self:GetSoundFileFromSettingValue(settingValue)

	if sound then
		if isKit then
		 	PlaySound(sound, TMW.db.profile.SoundChannel)
		else
			PlaySoundFile(sound, TMW.db.profile.SoundChannel)
		end

		return true
	end
end

function Sound:OnRegisterEventHandlerDataTable()
	error("Do not register event handler data for the Sound event handler. Use LibStub('LibSharedMedia-3.0'):Register('sound', name, path) instead.", 3)
end

do	-- LSM sound registration

	-- These are FileIDs, not SoundKitIDs.
	-- They were obtained by searching https://wow.tools/files/ 
	LSM:Register("sound", "Rubber Ducky",  566121)
	LSM:Register("sound", "Cartoon FX",	   566543)
	LSM:Register("sound", "Explosion", 	   566982)
	LSM:Register("sound", "Shing!", 	   566240)
	LSM:Register("sound", "Wham!", 		   566946)
	LSM:Register("sound", "Simon Chime",   566076)
	LSM:Register("sound", "War Drums", 	   567275)
	LSM:Register("sound", "Cheer", 		   567283)
	LSM:Register("sound", "Humm", 		   569518)
	LSM:Register("sound", "Short Circuit", 568975)
	LSM:Register("sound", "Fel Portal",    569215)
	LSM:Register("sound", "Fel Nova", 	   568582)
	LSM:Register("sound", "You Will Die!", 546633)

	LSM:Register("sound", "Die!", 		   551339)
	LSM:Register("sound", "You Fail!", 	   553345)

	LSM:Register("sound", "TMW - Pling 1", [[Interface\Addons\TellMeWhen\Sounds\Pling1.ogg]])
	LSM:Register("sound", "TMW - Pling 2", [[Interface\Addons\TellMeWhen\Sounds\Pling2.ogg]])
	LSM:Register("sound", "TMW - Pling 3", [[Interface\Addons\TellMeWhen\Sounds\Pling3.ogg]])
	LSM:Register("sound", "TMW - Pling 4", [[Interface\Addons\TellMeWhen\Sounds\Pling4.ogg]])
	LSM:Register("sound", "TMW - Pling 5", [[Interface\Addons\TellMeWhen\Sounds\Pling5.ogg]])
	LSM:Register("sound", "TMW - Pling 6", [[Interface\Addons\TellMeWhen\Sounds\Pling6.ogg]])
	LSM:Register("sound", "TMW - Ding 1",  [[Interface\Addons\TellMeWhen\Sounds\Ding1.ogg]])
	LSM:Register("sound", "TMW - Ding 2",  [[Interface\Addons\TellMeWhen\Sounds\Ding2.ogg]])
	LSM:Register("sound", "TMW - Ding 3",  [[Interface\Addons\TellMeWhen\Sounds\Ding3.ogg]])
	LSM:Register("sound", "TMW - Ding 4",  [[Interface\Addons\TellMeWhen\Sounds\Ding4.ogg]])
	LSM:Register("sound", "TMW - Ding 5",  [[Interface\Addons\TellMeWhen\Sounds\Ding5.ogg]])
	LSM:Register("sound", "TMW - Ding 6",  [[Interface\Addons\TellMeWhen\Sounds\Ding6.ogg]])
	LSM:Register("sound", "TMW - Ding 7",  [[Interface\Addons\TellMeWhen\Sounds\Ding7.ogg]])
	LSM:Register("sound", "TMW - Ding 8",  [[Interface\Addons\TellMeWhen\Sounds\Ding8.ogg]])
	LSM:Register("sound", "TMW - Ding 9",  [[Interface\Addons\TellMeWhen\Sounds\Ding9.ogg]])
end

