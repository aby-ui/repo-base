-- Saved settings setup for OmniCC

local AddonName, Addon = ...

local DB_NAME = AddonName .. "DB"
local DB_VERSION = 5

local LEGACY_DB_NAME = "OmniCC4Config"

function Addon:InitializeDB()
	self.db = LibStub("AceDB-3.0"):New(DB_NAME, self:GetDBDefaults(), DEFAULT)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self:UpgradeDB()
end

function Addon:OnProfileChanged(...)
	self.Cooldown:ForAll("UpdateSettings")
end

function Addon:GetDBDefaults()
	return {
		global = {},

		profile = {
			rules = {
				["**"] = {
					-- what theme to apply for this rule
					theme = DEFAULT,

					-- enable checking the rule
					enabled = true,

					-- rule evaluation order
					priority = 0,

					-- lua patterns to check against frame names
					patterns = {}
				}
			},

			defaultTheme = DEFAULT,

			themes = {
				["**"] = {
					-- name = "localized theme name",

					-- cooldown text configuration
					enableText = true,

					-- what font to use (an actual path)
					fontFace = STANDARD_TEXT_FONT,

					-- the default font size
					fontSize = 22,

					-- font outline settings (NONE, OUTLINE, THICKOUTLINE, MONOCHROME)
					fontOutline = "OUTLINE",

					-- font shadow color and offsets
					fontShadow = {
						-- color
						r = 1,
						g = 1,
						b = 1,
						a = 0,

						-- offset
						x = 0,
						y = 0
					},

					-- enable/disable resizing text based off of frame size
					scaleText = true,

					-- text display conditions
					-- how big something must be to display cooldown text
					-- this is a percentage of the size of an action button
					minSize = 0.13,

					-- how long a cooldown (in seconds) must be to display text
					minDuration = 2,

					-- at what duration (in seconds) remaining should start
					-- displaying cooldowns in tenths of seconds format (ex, 3.1)
					tenthsDuration = 0,

					-- at what duration (in seconds) remaining should start
					-- displaying cooldowns in MM:SS format
					mmSSDuration = 0,

					-- what finish effect to display
					effect = "pulse",

					-- how long a cooldown must be (in seconds) to trigger
					-- a finish effect
					minEffectDuration = 30,

					-- where to position cooldown text within a frame
					anchor = "CENTER",
					xOff = 0,
					yOff = 0,

					-- draw cooldown backgrounds
					drawSwipes = true,

					textStyles = {
						["**"] = {
							r = 1,
							g = 1,
							b = 1,
							a = 1,
							scale = 1
						},
						soon = {
							r = 1,
							g = .1,
							b = .1,
							scale = 1.1
						},
						seconds = {
							r = 1,
							g = 1,
							b = .1
						},
						minutes = {
							r = 1,
							g = 1,
							b = 1
						},
						hours = {
							r = .7,
							g = .7,
							b = .7,
							scale = .75
						},
						days = {
							r = .7,
							g = .7,
							b = .7,
							scale = .75
						},
						charging = {
							r = 0.8,
							g = 1,
							b = .3,
							a = .8,
							scale = .75
						},
						controlled = {
							r = 1,
							g = .1,
							b = .1,
							scale = 1.1
						}
					}
				},
				[DEFAULT] = {
					name = DEFAULT,
				}
			}
		}
	}
end

function Addon:UpgradeDB()
	local dbVersion = self.db.global.dbVersion
	if dbVersion ~= DB_VERSION then
		if dbVersion == nil then
			self:MigrateLegacySettings(_G[LEGACY_DB_NAME])
		end

		self.db.global.dbVersion = DB_VERSION
	end

	local addonVersion = self.db.global.addonVersion
	if addonVersion ~= GetAddOnMetadata(AddonName, "Version") then
		self.db.global.addonVersion = GetAddOnMetadata(AddonName, "Version")
	end
end

function Addon:MigrateLegacySettings(legacyDb)
	if type(legacyDb) ~= "table" then
		return
	end

	local function getThemeID(id)
		if id == "base" then
			return DEFAULT
		end

		return id
	end

	local function copyTable(src, dest)
		if type(dest) ~= "table" then
			dest = {}
		end

		for k, v in pairs(src) do
			if type(v) == "table" then
				dest[k] = copyTable(v, dest[k])
			else
				dest[k] = v
			end
		end

		return dest
	end

	-- groupSettings -> themes
	local oldGroupSettings = legacyDb and legacyDb.groupSettings
	if type(oldGroupSettings) == "table" then
		for id, group in pairs(oldGroupSettings) do
			-- apply the old settings
			local theme = copyTable(group, self.db.profile.themes[getThemeID(id)])

			-- enabled -> enableText
			theme.enableText = theme.enabled
			theme.enabled = nil

			-- styles -> textStyles
			copyTable(theme.styles, theme.textStyles)
			theme.styles = nil
		end
	end

	-- groups -> rules
	local oldGroups = legacyDb.groups
	if type(oldGroups) == "table" then
		for i = #oldGroups, 1, -1 do
			local group = oldGroups[i]

			tinsert(
				self.db.profile.rules,
				1,
				{
					id = getThemeID(group.id),
					theme = getThemeID(group.id),

					-- group.rules -> patterns
					patterns = copyTable(group.rules),

					enabled = group.enabled,
					priority = i,
				}
			)
		end
	end

	return true
end
