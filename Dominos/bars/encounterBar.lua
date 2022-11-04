if not PlayerPowerBarAlt then return end

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

local EncounterBar = Addon:CreateClass('Frame', Addon.Frame)

function EncounterBar:New()
	local frame = EncounterBar.proto.New(self, 'encounter')

	frame:InitPlayerPowerBarAlt()
	frame:ShowInOverrideUI(true)
	frame:ShowInPetBattleUI(true)
	frame:Layout()

	return frame
end

function EncounterBar:GetDisplayName()
	return L.EncounterBarDisplayName
end

function EncounterBar:GetDefaults()
	return { point = 'CENTER', displayLayer = 'HIGH' }
end

-- always reparent + position the bar due to UIParent.lua moving it whenever its shown
function EncounterBar:Layout()
	local bar = self.__PlayerPowerBarAlt
	bar:ClearAllPoints()
	bar:SetParent(self)
	bar:SetPoint('CENTER', self)

	-- resize out of combat
	if not InCombatLockdown() then
		local width, height = bar:GetSize()
		local pW, pH = self:GetPadding()

		width = math.max(width, 36 * 6)
		height = math.max(height, 36)

		self:SetSize(width + pW, height + pH)
	end
end

-- grab a reference to the bar
-- and hook the scripts we need to hook
function EncounterBar:InitPlayerPowerBarAlt()
	if not self.__PlayerPowerBarAlt then
		local bar = PlayerPowerBarAlt

		if bar:GetScript('OnSizeChanged') then
			bar:HookScript('OnSizeChanged', function() self:Layout() end)
		else
			bar:SetScript('OnSizeChanged', function() self:Layout() end)
		end

		self.__PlayerPowerBarAlt = bar
	end
end

-- module
local EncounterBarModule = Addon:NewModule('EncounterBar', 'AceEvent-3.0')

function EncounterBarModule:Load()
	if not self.loaded then
		self:OnFirstLoad()
		self.loaded = true
	end

	self.frame = Addon.EncounterBar:New()
end

function EncounterBarModule:Unload()
	self.frame:Free()
end

function EncounterBarModule:PLAYER_LOGOUT()
	-- SetUserPlaced is persistent, so revert upon logout
	PlayerPowerBarAlt:SetUserPlaced(false)
end

function EncounterBarModule:OnFirstLoad()
	-- tell blizzard that we don't it to manage this frame's position
	-- PlayerPowerBarAlt.ignoreFramePositionManager = true

	-- the standard UI will check to see if the power bar is user placed before
	-- doing anything to its position, so mark as user placed to prevent that
	-- from happening
	PlayerPowerBarAlt:SetMovable(true)
	PlayerPowerBarAlt:SetUserPlaced(true)

	-- onshow/hide call UpdateManagedFramePositions on the blizzard end so turn
	-- that bit off
	PlayerPowerBarAlt:SetScript("OnShow", nil)
	PlayerPowerBarAlt:SetScript("OnHide", nil)

	self:RegisterEvent("PLAYER_LOGOUT")
end

-- exports
Addon.EncounterBar = EncounterBar
