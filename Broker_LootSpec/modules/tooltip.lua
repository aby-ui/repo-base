local name, addon = ...
local tooltip = addon:NewModule('Tooltip')

-- Localise global variables
local _G = _G
local GetSpecialization, GetSpecializationInfo = _G.GetSpecialization, _G.GetSpecializationInfo
local GetNumSpecializations, LOOT_SPECIALIZATION_DEFAULT = _G.GetNumSpecializations, _G.LOOT_SPECIALIZATION_DEFAULT
local format = _G.string.format

local LibQTip = LibStub('LibQTip-1.0')

function tooltip:OnEnable()
	addon.RegisterCallback(self, 'MOUSE_ENTER', 'Show')
	addon.RegisterCallback(self, 'MOUSE_CLICK', 'OnClick')
	addon.RegisterCallback(self, 'LOOT_SPEC_UPDATED', 'OnLootSpecUpdated')
end

function tooltip:OnDisable()
	self:Hide()
	addon.UnregisterCallback(self, 'MOUSE_ENTER')
	addon.UnregisterCallback(self, 'MOUSE_CLICK')
	addon.UnregisterCallback(self, 'LOOT_SPEC_UPDATED')
end

function tooltip:OnClick(event, frame, button)
	if button == 'LeftButton' then
		self:Show("CLICK", frame)
	end
end

function tooltip:OnLootSpecUpdated()
	self:Hide()
end

function tooltip:Show(event, anchor)
	self:Hide()

	if self.enabledState then
		self.tip = LibQTip:Acquire(name .. 'Tooltip', 3, 'LEFT', 'LEFT')
		self.tip:Clear()

		self:Populate()

		self.tip.OnRelease = function() self.tip = nil end
		self.tip:SetAutoHideDelay(0.1, anchor)
		self.tip:SmartAnchorTo(anchor)
		self.tip:Show()
	end
end

function tooltip:Hide()
	if self.tip then
		LibQTip:Release(self.tip)
	end
end

function tooltip:Populate()
	local lootspec = addon.GetLootSpecialization()
	local spec = GetSpecialization()
	local name, icon = 'None', 'Interface\\Icons\\INV_Misc_QuestionMark'
	local id, _

	if spec then
		id, name, _, icon = GetSpecializationInfo(spec)
	end

	self:AddLine(0, icon, format(LOOT_SPECIALIZATION_DEFAULT, name), lootspec == 0)

	for i = 1, GetNumSpecializations() do
		id, name, _, icon = GetSpecializationInfo(i)
		self:AddLine(id, icon, name, lootspec == id)
	end
end

function tooltip:AddLine(id, icon, name, active)
	local line = self.tip:AddLine()
	local radio = '|T:0|t'

	if active then
		radio = '|TInterface\\Buttons\\UI-RadioButton:8:8:0:0:64:16:19:28:3:12|t'
	end

	self.tip:SetCell(line, 1, radio)
	self.tip:SetCell(line, 2, '|T' .. icon .. ':14|t')
	self.tip:SetCell(line, 3, name)
	self.tip:SetLineScript(line, 'OnMouseUp', self:GetLineScript(id))
	return line
end

function tooltip:GetLineScript(id)
	return function(line, unknown, button)
        if button == "RightButton" then
            local specId, specName = 0, UNKNOWN
            for i = 1, 5 do
                if id == GetSpecializationInfo(i) then
                    specId = i
                    specName = select(2, GetSpecializationInfo(i))
                    break
                end
            end
            if specId > 0 then
                if( UnitCastingInfo("player") ) then
                    U1Message("施法中，无法切换至 |cffffff00"..specName.."|r 专精", 1, .7, .7)
                elseif( InCombatLockdown() ) then
                    U1Message("战斗中，无法切换至 |cffffff00"..specName.."|r 专精", 1, .7, .7)
                else
                    SetSpecialization(specId)
                    U1Message("正在切换至 |cffffff00"..specName.."|r 专精", .7, 1, .7)
                end
            end
        else
    		addon.SetLootSpecialization(id)
	    	self:Hide()
        end
	end
end
