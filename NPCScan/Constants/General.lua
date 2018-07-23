-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

-- ----------------------------------------------------------------------------
-- General constants.
-- ----------------------------------------------------------------------------
private.DEFAULT_OS_SPAWN_POINT = _G.IsMacClient() and "TOPRIGHT" or "BOTTOMRIGHT"
private.NUM_RAID_ICONS = 8

-- ----------------------------------------------------------------------------
-- Preferences.
-- ----------------------------------------------------------------------------
private.DetectionGroupStatusLabels = {
	_G.ENABLE,
	_G.CUSTOM,
	_G.DISABLE,
}

private.DetectionGroupStatusColors = {
	_G.GREEN_FONT_COLOR_CODE,
	_G.NORMAL_FONT_COLOR_CODE,
	_G.RED_FONT_COLOR_CODE,
}
