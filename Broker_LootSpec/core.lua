local name = ...
local L = LibStub('AceLocale-3.0'):NewLocale(name, 'enUS', true)
L["Loot"] = true
local L = LibStub('AceLocale-3.0'):NewLocale(name, 'zhCN') if L then
    L["Loot"] = "拾取"
end
local L = LibStub('AceLocale-3.0'):NewLocale(name, 'zhTW') if L then
    L["Loot"] = "拾取"
end

local name, addon = ...
LibStub('AceAddon-3.0'):NewAddon(addon, name, 'AceEvent-3.0')
addon.callbacks = LibStub("CallbackHandler-1.0"):New(addon)

-- Localise global variables
local _G = _G
local GetLootSpecialization, SetLootSpecialization = _G.GetLootSpecialization, _G.SetLootSpecialization
local GetSpecializationInfo, GetSpecializationInfoByID = _G.GetSpecializationInfo, _G.GetSpecializationInfoByID
local GetSpecialization = _G.GetSpecialization

function addon:OnInitialize()
	self.L = LibStub('AceLocale-3.0'):GetLocale(name)
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'TriggerLootSpecUpdated')
	self:RegisterEvent('PLAYER_LOOT_SPEC_UPDATED', 'TriggerLootSpecUpdated')
	self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'TriggerLootSpecUpdated')
end

function addon:OnEnable()
	self:TriggerLootSpecUpdated()
end

function addon:TriggerLootSpecUpdated()
    addon.callbacks:Fire('LOOT_SPEC_UPDATED')
end

function addon.GetLootSpecialization()
	local id = GetLootSpecialization()

	if id > 0 then
		return id, GetSpecializationInfoByID(id)
	else
		local spec = GetSpecialization()
		if spec then
			return id, GetSpecializationInfo(spec)
		end
	end

	return 0
end

function addon.SetLootSpecialization(spec)
	SetLootSpecialization(spec)
end
