if not _G.PlayerPowerBarAlt then return end

local AddonName, Addon = ...
local EncounterBarModule = Dominos:NewModule('EncounterBar', 'AceEvent-3.0')

function EncounterBarModule:OnInitialize()
	_G['PlayerPowerBarAlt'].ignoreFramePositionManager = true

	local timer = Dominos:CreateHiddenFrame('Frame')

	timer:SetScript('OnUpdate', function()
		self:RepositionBar()
		timer:Hide()
	end)

	-- grr
	hooksecurefunc('UIParent_ManageFramePosition', function()
		timer:Show()
	end)
end

function EncounterBarModule:Load()
	self.frame = Addon.EncounterBar:New()
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
end

function EncounterBarModule:Unload()
	self.frame:Free()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')
end

function EncounterBarModule:PLAYER_REGEN_ENABLED()
	if self.__NeedToRepositionBar then
		self:RepositionBar()
	end
end

function EncounterBarModule:RepositionBar()
	if self.frame then
		self.frame:Layout()
	end
end