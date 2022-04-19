-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSAudioAlerts = private.NewLib("RareScannerAudioAlerts")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")

---============================================================================
-- Audio alerts options
---============================================================================

local lastPlayedSoundTimer

local function PlaySound(soundFile)
	-- Avoids overlaping audio alerts
	if (lastPlayedSoundTimer and debugprofilestop() <= (lastPlayedSoundTimer + 900)) then
		return
	end
	
	if (RSConfigDB.GetCustomSound(soundFile)) then
		PlaySoundFile(string.format(RSConstants.EXTERNAL_SOUND_FOLDER, RSConfigDB.GetCustomSoundsFolder(), RSConfigDB.GetCustomSound(soundFile)), RSConfigDB.GetSoundChannel())
	else
		PlaySoundFile(string.gsub(RSConstants.DEFAULT_SOUNDS[soundFile], "-4", "-"..RSConfigDB.GetSoundVolume()), RSConfigDB.GetSoundChannel())
	end
	
	lastPlayedSoundTimer = debugprofilestop()
end

function RSAudioAlerts.PlaySoundAlert(atlasName)
	if (not RSConfigDB.IsPlayingObjectsSound() and (RSConstants.IsContainerAtlas(atlasName) or RSConstants.IsEventAtlas(atlasName))) then
		PlaySound(RSConfigDB.GetSoundPlayedWithObjects())
	elseif (not RSConfigDB.IsPlayingSound() and RSConstants.IsNpcAtlas(atlasName)) then
		PlaySound(RSConfigDB.GetSoundPlayedWithNpcs())
	end
end