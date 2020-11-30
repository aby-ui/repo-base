local name, addon = ...
local broker = addon:NewModule('DataBroker')
local obj = {}

function broker:OnInitialize()
    obj.type = 'data source'
    self:SetValue(UNKNOWN, 'Interface\\Icons\\INV_Misc_Coin_06')

	LibStub('LibDataBroker-1.1'):NewDataObject(name, obj)
end

function broker:OnEnable()
    addon.RegisterCallback(self, 'LOOT_SPEC_UPDATED', 'OnLootSpecUpdated')
	addon:TriggerLootSpecUpdated()
end

function broker:OnDisable()
    addon.UnregisterCallback(self, 'LOOT_SPEC_UPDATED')
end

function broker:OnLootSpecUpdated()
	local lootspec, id, name, description, icon = addon.GetLootSpecialization()

	if not name then
		name = 'None'
	end

	if not icon then
		icon = 'Interface\\Icons\\INV_Misc_QuestionMark'
	end

	if lootspec == 0 then
		name = name .. '*'
	end

	self:SetValue(name, icon)
end

function broker:SetValue(value, icon)
    obj.text = addon.L['Loot'] .. '-' .. value
    obj.value = value
    obj.icon = icon
end

function obj.OnEnter(frame)
	if broker.enabledState then
        addon.callbacks:Fire('MOUSE_ENTER', frame)
	end
end

function obj.OnLeave(frame)
	if broker.enabledState then
        addon.callbacks:Fire('MOUSE_LEAVE', frame)
	end
end

function obj.OnClick(frame, ...)
	if broker.enabledState then
        addon.callbacks:Fire('MOUSE_CLICK', frame, ...)
	end
end
