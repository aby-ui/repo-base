local name, addon = ...
local click = addon:NewModule('Click')

-- Localise global variables
local _G = _G
local LoadAddOn, ShowUIPanel, HideUIPanel = _G.LoadAddOn, _G.ShowUIPanel, _G.HideUIPanel
local EJ_GetInstanceForMap, EJ_GetDifficulty = _G.EJ_GetInstanceForMap, _G.EJ_GetDifficulty
local UnitClass, GetInstanceInfo = _G.UnitClass, _G.GetInstanceInfo
local GetBestMapForUnit = _G.C_Map.GetBestMapForUnit

local EncounterJournal, EncounterJournal_SetClassAndSpecFilter
local EncounterJournal_ListInstances, EncounterJournal_DisplayInstance, EncounterJournal_SelectDifficulty

local function LoadEncounterJournal()
	if not _G.EncounterJournal then
		LoadAddOn('Blizzard_EncounterJournal')
	end

	EncounterJournal = _G.EncounterJournal
	EncounterJournal_SetClassAndSpecFilter = _G.EncounterJournal_SetClassAndSpecFilter
	EncounterJournal_ListInstances = _G.EncounterJournal_ListInstances
	EncounterJournal_DisplayInstance = _G.EncounterJournal_DisplayInstance
	EncounterJournal_SelectDifficulty = _G.EncounterJournal_SelectDifficulty
end

function click:OnEnable()
	addon.RegisterCallback(self, 'MOUSE_CLICK', 'OnClick')
	addon.RegisterCallback(self, 'LOOT_SPEC_UPDATED', 'OnLootSpecUpdated')
end

function click:OnDisable()
	addon.UnregisterCallback(self, 'MOUSE_CLICK')
	addon.UnregisterCallback(self, 'LOOT_SPEC_UPDATED')
end

function click:OnClick(event, frame, button)
	if button == 'RightButton' then
		if not EncounterJournal then
			LoadEncounterJournal()
		end

		if EncounterJournal:IsShown() then
			HideUIPanel(EncounterJournal)
		else
			self.PrepareEncounterJournal()
			ShowUIPanel(EncounterJournal)
		end
	end
end

function click:OnLootSpecUpdated()
	if EncounterJournal and EncounterJournal:IsShown() then
		self.PrepareEncounterJournal()
	end
end

function click.PrepareEncounterJournal()
	local _, _, class = UnitClass('player')
	local _, spec = addon.GetLootSpecialization()
	local instance = EJ_GetInstanceForMap(GetBestMapForUnit('player'))

	if instance > 0 then
		local _, _, difficulty = GetInstanceInfo()

		if instance ~= EncounterJournal.instanceID then
			EncounterJournal_ListInstances()
			EncounterJournal_DisplayInstance(instance)
		end

		if difficulty and difficulty ~= EJ_GetDifficulty() then
			EncounterJournal_SelectDifficulty(nil, difficulty)
		end
	end

	if spec then
		EncounterJournal_SetClassAndSpecFilter(nil, class, spec)
	else
		EncounterJournal_SetClassAndSpecFilter(nil, class, 0)
	end

	EncounterJournal.encounter.info.lootTab:Click()
end
