--[[
	Wildpants.lua
		Starts the addon and its settings
--]]

local ADDON, Addon = ...
local Addon = LibStub('WildAddon-1.0'):NewAddon(ADDON, Addon, 'LibItemCache-2.0')
Addon.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Addon.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
Addon.Version = GetAddOnMetadata(ADDON, 'Version')

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SETS = ADDON .. '_Sets'

local function AsArray(table)
	return setmetatable(table, {__metatable = 1})
end

local function SetDefaults(target, defaults)
	defaults.__index = nil

	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			if getmetatable(v) == 1 then
				target[k] = target[k] or AsArray(CopyTable(v))
			else
				target[k] = SetDefaults(target[k] or {}, v)
			end
		end
	end

	defaults.__index = defaults
	return setmetatable(target, defaults)
end

local FrameDefaults = {
	enabled = true,
	money = true, broker = true,
	bagToggle = true, sort = true, search = true, options = true,

	strata = 'HIGH', alpha = 1,
	scale = Addon.FrameScale or 1,
	color = {0, 0, 0, 0.5},
	x = 0, y = 0,

	itemScale = Addon.ItemScale or 1,
	spacing = 2,

	brokerObject = Addon.Name .. 'Launcher',
	hiddenRules = {contain = true},
	hiddenBags = {},

	rules = AsArray({
		'all', 'all/normal', 'all/trade', 'all/reagent', 'all/keys', 'all/quiver',
		'equip', 'equip/armor', 'equip/weapon', 'equip/trinket',
		'use', 'use/consume', 'use/enhance',
		'trade', 'trade/goods', 'trade/gem', 'trade/glyph', 'trade/recipe',
		'quest', 'misc',
	}),
}

local ProfileDefaults = {
	inventory = SetDefaults({
		reversedTabs = true,
		borderColor = {1, 1, 1, 1},
		point = 'BOTTOMRIGHT',
		x = -50, y = 100,
		columns = 8,
		width = 384,
		height = 200,
	}, FrameDefaults),

	bank = SetDefaults({
		borderColor = {1, 1, 0, 1},
		point = 'LEFT',
		columns = 12,
		width = 600,
		height = 500,
		x = 95
	}, FrameDefaults),

	vault = SetDefaults({
		borderColor = {1, 0, 0.98, 1},
		point = 'LEFT',
		columns = 10,
		x = 95
	}, FrameDefaults),

	guild = SetDefaults({
		borderColor = {0, 1, 0, 1},
		point = 'CENTER',
		columns = 7,
	}, FrameDefaults)
}


--[[ Startup ]]--

function Addon:OnEnable()
  CreateFrame('Frame', nil, InterfaceOptionsFrame):SetScript('OnShow', function()
    LoadAddOn(Addon.Name .. '_Config')
  end)

	_G[SETS] = SetDefaults(_G[SETS] or {}, {
		version = Addon.Version,
		global = SetDefaults({}, ProfileDefaults),
		profiles = {},

		resetPlayer = true,
		displayBank = true, closeBank = true, displayAuction = true, displayGuild = true, displayMail = true, displayTrade = true, displayCraft = true, displayScrapping = true,
		flashFind = true, tipCount = true, fading = true, serverSort = true,

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true,

		emptySlots = true, colorSlots = true,
		normalColor = {1, 1, 1},
		keyColor = {1, .9, .19},
		quiverColor = {1, .87, .68},
		soulColor = {0.64, 0.39, 1},
		reagentColor = {1, .87, .68},
		leatherColor = {1, .6, .45},
		enchantColor = {0.64, 0.83, 1},
		inscribeColor = {.64, 1, .82},
		engineerColor = {.68, .63, .25},
		tackleColor = {0.42, 0.59, 1},
		fridgeColor = {1, .5, .5},
		gemColor = {1, .65, .98},
		mineColor = {1, .81, .38},
		herbColor = {.5, 1, .5},
	})

	self.sets = _G[SETS]
  self.sets.version = Addon.Version

	for owner, profile in pairs(self.sets.profiles) do
		SetDefaults(profile, ProfileDefaults)
	end

	self.profile = self:GetProfile()
end


--[[ Profiles ]]--

function Addon:SetCurrentProfile(profile)
	self.sets.profiles[self:GetOwnerID()] = profile and SetDefaults(profile, ProfileDefaults)
	self.profile = self:GetProfile()
end

function Addon:GetProfile(owner)
	return self.sets.profiles[self:GetOwnerID(owner)] or self.sets.global
end


--[[ Options ]]--

function Addon:ShowOptions()
	if LoadAddOn(ADDON .. '_Config') then
		Addon.GeneralOptions:Open()
	end
end
